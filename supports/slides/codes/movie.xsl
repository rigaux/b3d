<?xml version="1.0" encoding="iso-8859-1"?>

<xsl:stylesheet version="1.0" 
           xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="html" indent="yes"/>
 
  <xsl:template match="movie">
          <h1><i><xsl:value-of select="titte"/></i></h1>
 
          <!-- Genre, pays, et année du film      -->
          <xsl:value-of select="genre"/>,   
          <i> <xsl:value-of select="country"/></i>,
          <xsl:value-of select="year"/>.

          <!-- Auteur du film  -->
          Mis en scène par 
            <b><xsl:value-of 
              select="concat(director/first_name, ' ', director/last_name)"/>
            </b>

        <h3>Acteurs</h3>
        <xsl:for-each select="actor">
           <b><xsl:value-of select="concat(first_name,' ',last_name)"/></b>:
                <xsl:value-of select="role"/><br/>
        </xsl:for-each>

        <!-- Résumé du film  -->
        <h3>Résumé</h3>
          <xsl:value-of select="summary"/>   

  </xsl:template>
</xsl:stylesheet>
