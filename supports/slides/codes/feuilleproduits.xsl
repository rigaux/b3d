<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns="http://www.w3.org/1999/xhtml">

  <xsl:template match="/">
    <html>    
      <body>
	<h1>Liste des magasins</h1>
	<ul>
	  <xsl:for-each select="Produits/Magasin">
	    <li><xsl:apply-templates select="." mode="nom_seul"/></li>
	  </xsl:for-each>
	</ul>
	<h1>Détail des produits des magasins</h1>
	  <xsl:for-each select="Produits/Magasin">
	    <xsl:apply-templates select="." mode="detail_produits"/>
	  </xsl:for-each>
      </body>
    </html>
  </xsl:template>

  <!-- Template n'affichant que le nom du magasin-->
  <xsl:template match="Magasin" mode="nom_seul">
    <xsl:value-of select="name"/>
  </xsl:template>
  
  <!-- Template affichant le nom du magasin et de détail des produits de celui-ci dans une liste -->
  <xsl:template match="Magasin" mode="detail_produits">
    <!-- Affichage du nom à l'aide du template précédent -->
    <xsl:apply-templates select="." mode="nom_seul"/> 
    <!-- Affichage de chaque produit dans une liste -->
    <ul> <!-- début de liste -->
      <xsl:for-each select="Produit">
	<li> <xsl:value-of select="lib"/> (<xsl:value-of select="Marque"/>)</li> <!-- un item par produit -->
      </xsl:for-each>  
    </ul> <!-- fin de liste -->
  </xsl:template>
</xsl:stylesheet>
