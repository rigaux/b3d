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
      <xsl:apply-templates select="."/>
    </xsl:for-each>
    <br/>
    Description : <xsl:value-of select="abstract"/></li>
  </xsl:template>

  <xsl:template match="author">
    <xsl:value-of select="firstname"/>
    <xsl:value-of select="lastname"/>
  </xsl:template>

</xsl:stylesheet>

