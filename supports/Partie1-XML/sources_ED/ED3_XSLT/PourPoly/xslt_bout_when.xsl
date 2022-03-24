<xsl:template match="book" mode="long">
    <li><b><xsl:value-of select="title"/></b> (<xsl:value-of select="pubyear"/>) de
    <xsl:for-each select="author">
      <xsl:if test="position()=last() and position()!=1"> et </xsl:if>
      <xsl:apply-templates select="."/>
      <xsl:if test="position()!=last() and position()!=last()-1">, </xsl:if>
    </xsl:for-each>
    <br/>
    <xsl:choose>
      <xsl:when test='@lang="fr"'>
	<xsl:if test="abstract"> Résumé : <xsl:value-of select="abstract"/>
	</xsl:if>    
      </xsl:when>
      <xsl:when test='@lang="en"'>
	<xsl:if test="abstract"> Abstract : <xsl:value-of select="abstract"/>
	</xsl:if>    
      </xsl:when>
    </xsl:choose>
    </li>
  </xsl:template>
