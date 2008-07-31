<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

   <xsl:include href="footer.xsl"/>
   <xsl:include href="headerback.xsl"/> 
   
   <!-- Local includes -->
   <xsl:include href="local/footer.xsl"/>
   <xsl:include href="local/headerback.xsl"/> 

  <xsl:output method="xml" indent="yes"  doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" 
   doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" encoding="iso-8859-1"/>
    <xsl:template match="/">
      <html>
       <head>
       <title><xsl:value-of select="cdash/title"/></title>
        <meta name="robots" content="noindex,nofollow" />
         <link rel="StyleSheet" type="text/css">
         <xsl:attribute name="href"><xsl:value-of select="cdash/cssfile"/></xsl:attribute>
         </link>
        <!-- Functions to confirm the remove -->
  <xsl:text disable-output-escaping="yes">
        &lt;script language="JavaScript"&gt;
        function confirmDelete() {
           if (window.confirm("Are you sure you want to delete this project?")){
              return true;
           }
           return false;
        }
        &lt;/script&gt;
  </xsl:text>
       </head>
       <body bgcolor="#ffffff">
       
<xsl:choose>         
<xsl:when test="/cdash/uselocaldirectory=1">
  <xsl:call-template name="headerback_local"/>
</xsl:when>
<xsl:otherwise>
  <xsl:call-template name="headerback"/>
</xsl:otherwise>
</xsl:choose>

<br/>
<xsl:value-of select="cdash/alert"/>

<xsl:choose>
 <xsl:when test="cdash/project_created=1">
 The project <b><xsl:value-of select="cdash/project_name"/></b> has been created successfully.<br/> <br/>          
 Click here to access the  <a>
 <xsl:attribute name="href">index.php?project=<xsl:value-of select="cdash/project_name"/></xsl:attribute>
 CDash project page</a><br/> 
 Click here to <a>
 <xsl:attribute name="href">createProject.php?projectid=<xsl:value-of select="cdash/project_id"/></xsl:attribute>
edit the project</a><br/> 
 Click here to <a>
<xsl:attribute name="href">generateCTestConfig.php?projectid= <xsl:value-of select="cdash/project_id"/>
</xsl:attribute>download the CTest configuration file
</a><br/> 
</xsl:when>
<xsl:otherwise>
<form name="form1" enctype="multipart/form-data" method="post" action="">
<table>
  <xsl:if test="cdash/edit=1">
  <tr>
    <td width="99"></td>
    <td><div align="right"><strong>Project:</strong></div></td>
    <td><select onchange="location = 'createProject.php?projectid='+this.options[this.selectedIndex].value;" name="projectSelection">
        <option>
        <xsl:attribute name="value">0</xsl:attribute>
        Choose...
        </option>
        
        <xsl:for-each select="cdash/availableproject">
        <option>
        <xsl:attribute name="value"><xsl:value-of select="id"/></xsl:attribute>
        <xsl:if test="selected=1">
        <xsl:attribute name="selected"></xsl:attribute>
        </xsl:if>
        <xsl:value-of select="name"/>
        </option>
        </xsl:for-each>
        </select></td>
  </tr>
  </xsl:if>
  <!-- If a project has been selected -->
  <xsl:if test="count(cdash/project)>0 or cdash/edit=0">
  <xsl:if test="cdash/edit=0">
    <tr>
      <td></td>
      <td><div align="right"><strong>Name:</strong></div></td>
      <td><input name="name" type="text" id="name"/></td>
    </tr>
  </xsl:if> 
  <tr>
    <td></td>
    <td><div align="right"><strong>Description:</strong></div></td>
    <td><textarea name="description" id="description" cols="40" rows="5">
    <xsl:value-of select="cdash/project/description"/>
    </textarea></td>
  </tr>
  <tr>
    <td></td>
    <td><div align="right"><strong>Home URL :</strong></div></td>
    <td><input name="homeURL" type="text" id="homeURL" size="50">
    <xsl:attribute name="value">
    <xsl:value-of select="cdash/project/homeurl"/>
    </xsl:attribute>
    </input>
    </td>
  </tr>
  <tr>
    <td></td>
    <td><div align="right"><strong>CVS/SVN ViewerURL:</strong></div></td>
    <td><input name="cvsURL" type="text" id="cvsURL" size="50">
     <xsl:attribute name="value">
    <xsl:value-of select="cdash/project/cvsurl"/>
    </xsl:attribute>
    </input>
    <xsl:text disable-output-escaping="yes"> </xsl:text>
    <a href="http://public.kitware.com/Wiki/CDash:Administration#Creating_a_project" target="blank">
    <img src="images/help.gif" border="0"/></a>
    </td>
  </tr>
  <tr>
    <td></td>
    <td><div align="right"><strong>CVS/SVN Viewer Type:</strong></div></td>
    <td><select name="cvsviewertype">
    <xsl:for-each select="/cdash/cvsviewer">
    <option>
    <xsl:attribute name="value"><xsl:value-of select="value"/></xsl:attribute>
    <xsl:if test="selected=1">
      <xsl:attribute name="selected">true</xsl:attribute>
    </xsl:if>
    <xsl:value-of select="description"/></option>
    </xsl:for-each>
    </select>
    </td>
  </tr>
  <xsl:for-each select="/cdash/cvsrepository">
   <tr>
    <td></td>
    <td>
    <xsl:if test="id=0">
      <div align="right"><strong>CVS/SVN Repository:</strong></div>
    </xsl:if>
    </td>
    <td>
    <input type="text" size="50">
    <xsl:attribute name="name">
      cvsRepository[<xsl:value-of select="id"/>]
    </xsl:attribute>
    <xsl:attribute name="value">
    <xsl:value-of select="url"/>
    </xsl:attribute>
    </input>
    <xsl:text disable-output-escaping="yes"> </xsl:text>
    <a href="http://public.kitware.com/Wiki/CDash:Administration#Creating_a_project" target="blank">
    <img src="images/help.gif" border="0"/></a>
    </td>
  </tr>
  </xsl:for-each>
  
  <xsl:if test="cdash/edit=1">
  <tr>
    <td></td>
    <td></td>
    <td>
    <input name="AddRepository" type="submit" value="Add another repository"/>
    <input name="nRepositories" type="hidden">
    <xsl:attribute name="value">
      <xsl:value-of select="cdash/nrepositories"/>
    </xsl:attribute>
    </input>
    </td>
  </tr>
  </xsl:if>
  <tr>
    <td></td>
    <td><div align="right"><strong>Bug Tracker URL:</strong></div></td>
    <td><input name="bugURL" type="text" id="bugURL" size="50"> 
    <xsl:attribute name="value">
    <xsl:value-of select="cdash/project/bugurl"/>
    </xsl:attribute>
    </input>
    <xsl:text disable-output-escaping="yes"> </xsl:text>
    <a href="http://public.kitware.com/Wiki/CDash:Administration#Creating_a_project" target="blank">
    <img src="images/help.gif" border="0"/></a>
    </td>
  </tr>
 <tr>
    <td></td>
    <td><div align="right"><strong>Documentation URL:</strong></div></td>
    <td><input name="docURL" type="text" id="docURL" size="50"> 
    <xsl:attribute name="value">
    <xsl:value-of select="cdash/project/docurl"/>
    </xsl:attribute>
    </input></td>
  </tr>
  <tr>
    <td></td>
    <td><div align="right"><strong>Logo:</strong></div></td>
    <td><input type="file" name="logo" size="40"/></td>
  </tr>
  <xsl:if test="cdash/edit=1">
  <tr>
    <td></td>
    <td><div align="right"><strong>Current logo:</strong></div></td>
    <td>
    <xsl:if test="cdash/project/imageid=0">
    [none]
    </xsl:if>
    <img border="0">
    <xsl:attribute name="alt"><xsl:value-of select="cdash/dashboard/project/name"/></xsl:attribute>
    <xsl:attribute name="src">displayImage.php?imgid=<xsl:value-of select="cdash/project/imageid"/></xsl:attribute>
    </img>
    </td>
  </tr>
  </xsl:if>
  <tr>
    <td></td>
    <td><div align="right"><strong>Public Dashboard:</strong></div></td>
    <td><input type="checkbox" name="public" value="1">
    <xsl:if test="cdash/project/public=1">
    <xsl:attribute name="checked"></xsl:attribute>
    </xsl:if>
    </input>
    </td>
  </tr>
  <tr>
    <td></td>
    <td><div align="right"><strong>Coverage Threshold:</strong></div></td>
    <td><input name="coverageThreshold" type="text" id="coverageThreshold" size="2" value="70">
    <xsl:attribute name="value">
    <xsl:if test="string-length(cdash/project/coveragethreshold)=0">70</xsl:if>
    <xsl:value-of select="cdash/project/coveragethreshold"/>
    </xsl:attribute>
    </input>
    <xsl:text disable-output-escaping="yes"> </xsl:text>
    <a href="http://public.kitware.com/Wiki/CDash:Administration#Creating_a_project" target="blank">
    <img src="images/help.gif" border="0"/></a>
    </td>
  </tr>
  <tr>
    <td></td>
    <td><div align="right"><strong>Nightly Start Time:</strong></div></td>
    <td>
    <input name="nightlyTime" type="text" id="nightlyTime" size="20">
    <xsl:attribute name="value">
    <xsl:if test="string-length(cdash/project/nightlytime)=0">00:00:00 EST</xsl:if>
      <xsl:value-of select="cdash/project/nightlytime"/>
    </xsl:attribute>
    </input>
    <xsl:text disable-output-escaping="yes"> </xsl:text>
    <a href="http://public.kitware.com/Wiki/CDash:Administration#Creating_a_project" target="blank">
    <img src="images/help.gif" border="0"/></a>
    </td>
  </tr>
  
  <tr>
    <td></td>
    <td><div align="right"><strong>Google Analytics Tracker:</strong></div></td>
    <td>
    <input name="googleTracker" type="text" id="googleTracker" size="50">
    <xsl:attribute name="value">
      <xsl:value-of select="cdash/project/googletracker"/>
    </xsl:attribute>
    </input>
    <xsl:text disable-output-escaping="yes"> </xsl:text>
    <a href="http://public.kitware.com/Wiki/CDash:Administration#Adding_Google_Analytics" target="blank">
    <img src="images/help.gif" border="0"/></a>
    </td>
  </tr>
  
  <tr>
    <td></td>
    <td><div align="right"><strong>Enable test timing:</strong></div></td>
    <td>
    <input name="showTestTime" type="checkbox" value="1">
    <xsl:if test="cdash/project/showtesttime=1">
    <xsl:attribute name="checked"></xsl:attribute>
    </xsl:if>
    </input></td>
  </tr>
  
  <tr>
    <td></td>
    <td><div align="right"><strong>Test time standard deviation:</strong></div></td>
    <td>
    <input name="testTimeStd" type="text" id="testTimeStd" size="4">
    <xsl:attribute name="value">
      <xsl:if test="string-length(cdash/project/testtimestd)=0">4.0</xsl:if>
      <xsl:value-of select="cdash/project/testtimestd"/>
    </xsl:attribute>
    </input>
     <xsl:text disable-output-escaping="yes"> </xsl:text>
    <a href="http://public.kitware.com/Wiki/CDash:Design#Test_Timing" target="blank">
    <img src="images/help.gif" border="0"/></a>
    </td>
  </tr>
  
  <tr>
    <td></td>
    <td><div align="right"><strong>Test time standard deviation threshold:</strong></div></td>
    <td>
    <input name="testTimeStdThreshold" type="text" id="testTimeStdThreshold" size="4">
    <xsl:attribute name="value">
      <xsl:if test="string-length(cdash/project/testtimestdthreshold)=0">1.0</xsl:if>
      <xsl:value-of select="cdash/project/testtimestdthreshold"/>
    </xsl:attribute>
    </input>
    <xsl:text disable-output-escaping="yes"> </xsl:text>
    <a href="http://public.kitware.com/Wiki/CDash:Design#Test_Timing" target="blank">
    <img src="images/help.gif" border="0"/></a>
    </td>
  </tr>
  
  <tr>
    <td></td>
    <td><div align="right"><strong>Test time # max failures before flag:</strong></div></td>
    <td>
    <input name="testTimeMaxStatus" type="text" id="testTimeMaxStatus" size="4">
    <xsl:attribute name="value">
      <xsl:if test="string-length(cdash/project/testtimemaxstatus)=0">3</xsl:if>
      <xsl:value-of select="cdash/project/testtimemaxstatus"/>
    </xsl:attribute>
    </input>
     <xsl:text disable-output-escaping="yes"> </xsl:text>
    <a href="http://public.kitware.com/Wiki/CDash:Design#Test_Timing" target="blank">
    <img src="images/help.gif" border="0"/></a>
    </td>
  </tr>
  
  <tr>
    <td></td>
    <td><div align="right"><strong>Email broken submission:</strong></div></td>
    <td><input type="checkbox" name="emailBrokenSubmission" value="1">
    <xsl:if test="cdash/project/emailbrokensubmission=1">
    <xsl:attribute name="checked"></xsl:attribute>
    </xsl:if>
    </input>
    </td>
  </tr>
  <tr>
    <td></td>
    <td><div align="right"><strong>Email build missing:</strong></div></td>
    <td><input type="checkbox" name="emailBuildMissing" value="1">
    <xsl:if test="cdash/project/emailbuildmissing=1">
    <xsl:attribute name="checked"></xsl:attribute>
    </xsl:if>
    </input>
    </td>
  </tr>
  <tr>
    <td></td>
    <td><div align="right"><strong>Email low coverage:</strong></div></td>
    <td><input type="checkbox" name="emailLowCoverage" value="1">
    <xsl:if test="cdash/project/emaillowcoverage=1">
    <xsl:attribute name="checked"></xsl:attribute>
    </xsl:if>
    </input>
    </td>
  </tr>
  <tr>
    <td></td>
    <td><div align="right"><strong>Email test timing changed:</strong></div></td>
    <td><input type="checkbox" name="emailTestTimingChanged" value="1">
    <xsl:if test="cdash/project/emailtesttimingchanged=1">
    <xsl:attribute name="checked"></xsl:attribute>
    </xsl:if>
    </input>
    </td>
  </tr> 
  
   <tr>
    <td></td>
    <td><div align="right"><strong>Maximum number of items in email:</strong></div></td>
    <td>
    <input name="emailMaxItems" type="text" id="emailMaxItems" size="4">
    <xsl:attribute name="value">
      <xsl:if test="string-length(cdash/project/emailmaxitems)=0">5</xsl:if>
      <xsl:value-of select="cdash/project/emailmaxitems"/>
    </xsl:attribute>
    </input>
    </td>
  </tr>
  
   <tr>
    <td></td>
    <td><div align="right"><strong>Maximum number of characters per item in email:</strong></div></td>
    <td>
    <input name="emailMaxChars" type="text" id="emailMaxChars" size="4">
    <xsl:attribute name="value">
      <xsl:if test="string-length(cdash/project/emailmaxchars)=0">255</xsl:if>
      <xsl:value-of select="cdash/project/emailmaxchars"/>
    </xsl:attribute>
    </input>
    </td>
  </tr>
 
 <!-- downloading the CTestConfig.cmake -->
 <xsl:if test="cdash/edit=1">
 <tr>
    <td></td>
    <td><div align="right"><strong>Download CTestConfig:</strong></div></td>
    <td><a>
  <xsl:attribute name="href">generateCTestConfig.php?projectid= <xsl:value-of select="cdash/project/id"/>
  </xsl:attribute>CTestConfig.php
  </a>
    </td>
  </tr> 
 </xsl:if>
 
  <tr>
    <td></td>
    <td><div align="right"></div></td>
    <xsl:if test="cdash/edit=0">
      <td><input type="submit" name="Submit" value="Create Project"/></td>
    </xsl:if>
    <xsl:if test="cdash/edit=1">
      <td><input type="submit" name="Update" value="Update Project"/><input type="submit" name="Delete" value="Delete Project" onclick="return confirmDelete()"/></td>
    </xsl:if>
  </tr>
  </xsl:if>
</table>
</form>
</xsl:otherwise>
</xsl:choose>

<br/>
<!-- FOOTER -->
<br/>
 
<xsl:choose>         
<xsl:when test="/cdash/uselocaldirectory=1">
  <xsl:call-template name="footer_local"/>
</xsl:when>
<xsl:otherwise>
  <xsl:call-template name="footer"/>
</xsl:otherwise>
</xsl:choose>

        </body>
      </html>
    </xsl:template>
</xsl:stylesheet>