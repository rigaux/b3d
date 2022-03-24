<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://www.w3.org/1999/xhtml">

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
  
  <xsl:template match="book" mode="short">
    <li> <a href="#{generate-id()}" title="{title}"><xsl:value-of select="title"/></a></li>
  </xsl:template>
  
  <xsl:template match="book" mode="long">
    <li><b><a name="{generate-id()}"><xsl:value-of select="title"/></a></b> (<xsl:value-of select="pubyear"/>) de
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

  <xsl:template match="author">
    <xsl:value-of select="firstname"/>&#160;<xsl:value-of select="lastname"/>
  </xsl:template>

</xsl:stylesheet>

