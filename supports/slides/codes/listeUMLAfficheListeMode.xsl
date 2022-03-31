<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml">
  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
  
  <xsl:template match="diagrammesUML">
    <html>    
      <body>
	Liste courte
	<ul>
	  <xsl:for-each select="diagramme">
	    <xsl:apply-templates select="." mode="short"/>
	  </xsl:for-each>
	</ul>
	Liste avec description
	<ul>
	  <xsl:for-each select="diagramme">
	    <xsl:apply-templates select="." mode="long"/>
	  </xsl:for-each>
	</ul>
      </body>
    </html>
  </xsl:template>
  
  <xsl:template match="diagramme" mode="short">
    <li> <xsl:value-of select="name"/></li>
  </xsl:template>
  
  <xsl:template match="diagramme" mode="long">
    <li><b><xsl:value-of select="name"/>:</b><xsl:value-of select="description"/></li>
  </xsl:template>

</xsl:stylesheet>

