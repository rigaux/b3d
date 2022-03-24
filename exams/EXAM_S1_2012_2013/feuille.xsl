<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml">
  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
  
  <xsl:template match="/agence">
    <html>    
      <body>
	<h1>Liste d appartements</h1>
	<ul>
	  <xsl:for-each select="appart">
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
  
  <xsl:template match="appart" mode="long">
    <li>
      Appartement de <xsl:value-of select="@superficie"/> m2, <xsl:value-of select="@prix"/> euros, a <xsl:value-of select="quartier/@ville"/>.<br/>
      <b>Pieces :</b>
      <xsl:for-each select="piece">
        <xsl:value-of select="./text()"/> de <xsl:value-of select="@superficie"/> m2,
      </xsl:for-each>
      <b>Salles d eau</b>
      <xsl:for-each select="piecedeau">
        <xsl:value-of select="./text()"/> de <xsl:value-of select="@superficie"/> m2,
      </xsl:for-each>
      <b>Cuisine</b>
      <xsl:for-each select="cuisine">
        <xsl:value-of select="./text()"/> de <xsl:value-of select="@superficie"/> m2,
      </xsl:for-each>
      <xsl:if select="ascenseur"> ascenseur, </xsl:if>
      <xsl:if select="cave"> cave, </xsl:if>
      <xsl:if select="parking"> parking, </xsl:if>
      <p><b>Description : </b> <xsl:value-of select="description/text()"/></p>
    </li>
  </xsl:template>
</xsl:stylesheet>

