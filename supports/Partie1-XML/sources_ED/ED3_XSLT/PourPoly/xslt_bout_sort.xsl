<xsl:template match="biblio">
    <html>    
      <body>
	<h1>Sommaire</h1>
	<ul>
	  <xsl:for-each select="book">
	    <xsl:sort select="pubyear" order ="descending"/>
	    <xsl:apply-templates select="." mode="short"/>
	  </xsl:for-each>
	</ul>
	<br/>
	<h1>Description</h1>
	<ul>
	  <xsl:for-each select="book">
	    <xsl:sort select="pubyear" order ="descending"/>
	    <xsl:apply-templates select="." mode="long"/>
	  </xsl:for-each>
	</ul>
      </body>
    </html>
  </xsl:template>
