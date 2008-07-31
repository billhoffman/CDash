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
$noforcelogin = 1;
include("config.php");
require_once("pdo.php");
include('login.php');
include_once("common.php");
include("version.php"); 

@$projectname = $_GET["project"];
if(!isset($projectname))
  {
  die("Error: project not specified<br>\n");
  }
@$date = $_GET["date"];
if(!isset($date) or $date == "")
  {
  $date = date("Ymd",time());
  }
$date = pdo_real_escape_string($date); 
 
$db = pdo_connect("$CDASH_DB_HOST", "$CDASH_DB_LOGIN","$CDASH_DB_PASS");
pdo_select_db("$CDASH_DB_NAME",$db);

$xml = '<?xml version="1.0"?><cdash>';
$xml .= "<title>".$projectname." : Test Overview</title>";
$xml .= "<cssfile>".$CDASH_CSS_FILE."</cssfile>";
$xml .= "<version>".$CDASH_VERSION."</version>";
$xml .= get_cdash_dashboard_xml_by_name($projectname,$date);

//get some information about the specified project
$projectname = pdo_real_escape_string($projectname);
$projectQuery = "SELECT id, nightlytime FROM project WHERE name = '$projectname'";
$projectResult = pdo_query($projectQuery);
if(!$projectRow = pdo_fetch_array($projectResult))
  {
  die("Error:  project $projectname not found<br>\n");
  }
$projectid = $projectRow["id"];
$nightlytime = $projectRow["nightlytime"];

checkUserPolicy(@$_SESSION['cdash']['loginid'],$projectid);

//get each build that was submitted on this date
$rlike = "RLIKE";
if(isset($CDASH_DB_TYPE) && $CDASH_DB_TYPE == "pgsql")
   {
   $rlike = "~";
   }
$buildQuery = "SELECT id FROM build WHERE stamp ".$rlike." '^$date-' AND projectid = '$projectid'"; 
$buildResult = pdo_query($buildQuery);
$builds = array();
while($buildRow = pdo_fetch_array($buildResult))
  {
  array_push($builds, $buildRow["id"]);
  }

//find all the tests that were performed for this project on this date
//skip tests that passed on all builds
$firstTime = TRUE;
$testQuery = "";
foreach($builds as $id)
{
if($firstTime)
  {
  $testQuery =
    "SELECT DISTINCT test.name FROM test,build2test WHERE (build2test.buildid='$id'";
  $firstTime = FALSE;
  }
else
  {
  $testQuery .= " OR build2test.buildid='$id'";
  }
}
$testQuery .= ") AND build2test.testid=test.id AND build2test.status NOT LIKE 'passed'";

@$testResult = pdo_query($testQuery);
if($testResult === FALSE)
  {
  die("No tests found for $projectname on $date");
  }
$tests = array();
while($testRow = pdo_fetch_array($testResult))
  {
  array_push($tests, $testRow["name"]);
  }
natcasesort($tests);

//now generate some XML
$xml .= "<tests>\n";
$previousLetter = "";
$firstSection = TRUE;
foreach($tests as $testName)
  {
  $letter = strtolower(substr($testName, 0, 1));
  if($letter != $previousLetter)
    {
    if($firstSection)
      {
      $xml .= "<section>\n";
      $firstSection = FALSE;
      }
    else
      {
      $xml .= "</section>\n<section>";
      }
    $xml .= add_XML_value("sectionName", $letter) . "\n";
    $previousLetter = $letter;
    }
  $xml .= "<test>\n";
  $xml .= add_XML_value("testName", $testName) . "\n";
  $summaryLink = "testSummary.php?project=$projectid&name=$testName&date=$date";
  $xml .= add_XML_value("summaryLink", $summaryLink) . "\n";
  $xml .= "</test>\n";
  }
  
if(count($tests)>0)
  {
  $xml .= "</section>\n";
  }
$xml .= "</tests>\n";
$xml .= "</cdash>";

generate_XSLT($xml, "testOverview");
?>