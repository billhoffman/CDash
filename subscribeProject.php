<?php
/*=========================================================================

  Program:   CDash - Cross-Platform Dashboard System
  Module:    $Id$
  Language:  PHP
  Date:      $Date$
  Version:   $Revision$

  Copyright (c) 2002 Kitware, Inc.  All rights reserved.
  See Copyright.txt or http://www.cmake.org/HTML/Copyright.html for details.

     This software is distributed WITHOUT ANY WARRANTY; without even 
     the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR 
     PURPOSE.  See the above copyright notices for more information.

=========================================================================*/
include("config.php"); 
include('login.php');
include_once('common.php');
include('version.php');

if ($session_OK) 
  {
  $userid = $_SESSION['cdash']['loginid'];
   
  @$db = mysql_connect("$CDASH_DB_HOST", "$CDASH_DB_LOGIN","$CDASH_DB_PASS");
  mysql_select_db("$CDASH_DB_NAME",$db);
  
  $xml = "<cdash>";
  $xml .= "<cssfile>".$CDASH_CSS_FILE."</cssfile>";
  $xml .= "<version>".$CDASH_VERSION."</version>";
  $xml .= "<backurl>user.php</backurl>";
  $xml .= "<title>CDash - Subscribe to a project</title>";
  $xml .= "<menutitle>CDash</menutitle>";
  $xml .= "<menusubtitle>Subscription</menusubtitle>";
 
  @$projectid = $_GET["projectid"];
  @$edit = $_GET["edit"];
  
  // Checks
  if(!isset($projectid) || !is_numeric($projectid))
    {
    echo "Not a valid projectid!";
    return;
    }
  if(isset($edit) && $edit!=1)
    {
    echo "Not a valid edit!";
    return;
    }
    
  if($edit)
    {
    $xml .= "<edit>1</edit>";
    }
  else
    {
    $xml .= "<edit>0</edit>";
    }
 

  $project = mysql_query("SELECT id,name FROM project WHERE id='$projectid'");
  $project_array = mysql_fetch_array($project);
  
  // Check if the user is not already in the database
  $user2project = mysql_query("SELECT cvslogin,role,emailtype FROM user2project WHERE userid='$userid' AND projectid='$projectid'");
  if(mysql_num_rows($user2project)>0)
    {
    $user2project_array = mysql_fetch_array($user2project);
    $xml .= add_XML_value("cvslogin",$user2project_array["cvslogin"]);
    $xml .= add_XML_value("role",$user2project_array["role"]);
    $xml .= add_XML_value("emailtype",$user2project_array["emailtype"]);
    }
    
  
  // If we ask to subscribe
  @$Subscribe = $_POST["subscribe"];
  @$UpdateSubscription = $_POST["updatesubscription"];
  @$Unsubscribe = $_POST["unsubscribe"]; 
  @$Role = $_POST["role"];
  @$CVSLogin = $_POST["cvslogin"];
  @$EmailType = $_POST["emailtype"];
  
  if($Unsubscribe)
    {
    mysql_query("DELETE FROM user2project WHERE userid='$userid' AND projectid='$projectid'");
    
    // Remove the claim sites for this project if they are only part of this project
    mysql_query("DELETE FROM site2user WHERE userid='$userid' 
                 AND siteid NOT IN(SELECT siteid FROM build WHERE projectid!='$projectid' GROUP BY siteid)");
                 
    header( 'location: user.php?note=unsubscribedtoproject' );
    }   
  else if($Subscribe || $UpdateSubscription)
    {
    if(mysql_num_rows($user2project)>0)
      {
      mysql_query("UPDATE user2project SET role='$Role',cvslogin='$CVSLogin',emailtype='$EmailType' WHERE userid='$userid' AND projectid='$projectid'");
      }
    else
      {
      mysql_query("INSERT INTO user2project (role,cvslogin,userid,projectid,emailtype) VALUES ('$Role','$CVSLogin','$userid','$projectid','$EmailType')");
      }  
    header( 'location: user.php?note=subscribedtoproject' );
    }
  // XML
  $xml .= "<project>";
  $xml .= add_XML_value("id",$project_array['id']);
  $xml .= add_XML_value("name",$project_array['name']);
  $xml .= "</project>";  
  
  $xml .= "</cdash>";
  
  // Now doing the xslt transition
  generate_XSLT($xml,"subscribeProject");
  } // end session OK

?>
