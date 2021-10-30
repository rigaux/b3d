<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns="http://www.w3.org/1999/xhtml">
  
  <xsl:template match="biblio">
    <html>    
      <body>
	<h1>Sommaire</h1>
	<ul>
	  <xsl:for-each select="book">
	    <xsl:apply-templates select="." mode="short"/>
	  </xsl:for-each>
	</ul>
	<br/>
	<h1>Description</h1>
	<ul>
	  <xsl:for-each select="book">
	    <xsl:apply-templates select="." mode="long"/>
	  </xsl:for-each>
	</ul>
      </body>
    </html>
  </xsl:template>
  
  <xsl:template match="book" mode="short">
    <li> <xsl:value-of select="title"/></li>
  </xsl:template>
  
  <xsl:template match="book" mode="long">
    <li><b><xsl:value-of select="title"/></b> de
    <xsl:for-each select="author">
      <xsl:if test="position()=last() and position()!=1"> et </xsl:if>
      <xsl:apply-templates select="."/>
      <xsl:if test="position()!=last() and position()!=last()-1">, </xsl:if>
    </xsl:for-each>
    <br/>
    <xsl:if test="abstract"> Description : <xsl:value-of select="abstract"/>
    </xsl:if>
  </li>
  </xsl:template>

  <xsl:template match="author">
    <xsl:value-of select="firstname"/>&#160;<xsl:value-of select="lastname"/>
  </xsl:template>

</xsl:stylesheet>

