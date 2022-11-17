<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml">
  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
  
  <xsl:template match="/favoris">
    <html>    
      <body>
	<h1>Liste courte</h1>
	<ul>
	  <xsl:for-each select="album">
	    <xsl:apply-templates select="." mode="short"/>
	  </xsl:for-each>
	</ul>
	<h1>Liste avec description</h1>
	<ul>
	  <xsl:for-each select="album">
	    <xsl:apply-templates select="." mode="long"/>
	  </xsl:for-each>
	</ul>
      </body>
    </html>
  </xsl:template>
  
  <xsl:template match="album" mode="short">
    <li> <xsl:value-of select="titre"/></li>
  </xsl:template>
  
  <xsl:template match="album" mode="long">
    <li>
      <b><xsl:value-of select="titre"/>: </b><xsl:value-of select="interprete"/>, <xsl:value-of select="annee"/>
    </li>
  </xsl:template>

</xsl:stylesheet>

