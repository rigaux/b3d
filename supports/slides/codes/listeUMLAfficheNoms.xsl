<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml">

  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
  
  <xsl:template match="diagrammesUML">
    <html xmlns="http://www.w3.org/1999/xhtml">    
      <body>
	<xsl:apply-templates select="diagramme"/>
      </body>
    </html>
  </xsl:template>
  
  <xsl:template match="diagramme">
    <xsl:value-of select="name"/>
  </xsl:template>
    
</xsl:stylesheet>

