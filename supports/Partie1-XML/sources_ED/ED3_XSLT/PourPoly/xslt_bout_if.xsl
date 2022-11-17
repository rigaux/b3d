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
