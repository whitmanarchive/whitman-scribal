<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:whitman="http://www.whitmanarchive.org/namespace"
  xpath-default-namespace="http://www.tei-c.org/ns/1.0" version="2.0"
  exclude-result-prefixes="xsl tei xs whitman">
  
  <!-- ==================================================================== -->
  <!--                             IMPORTS                                  -->
  <!-- ==================================================================== -->
  
  <xsl:import href="../.xslt-datura/tei_to_html/tei_to_html.xsl"/>
  <xsl:import href="../../../whitman-scripts/scripts/archive-wide/overrides.xsl"/>
  
  <!-- For display in TEI framework, have changed all namespace declarations to http://www.tei-c.org/ns/1.0. If different (e.g. Whitman), will need to change -->
  <xsl:output method="xml" indent="no" encoding="UTF-8" omit-xml-declaration="no"/>
  
  <!-- add overrides for this section here -->

 

  
  <xsl:variable name="top_metadata">
    <ul>
       <!-- <li><strong>Title: </strong> <xsl:value-of select="//title[@type='main']"/></li>
      <li><strong>Date: </strong> <xsl:value-of select="/TEI/teiHeader/fileDesc/sourceDesc/bibl/date"/></li>
      <li><strong>Whitman Archive ID: </strong> <xsl:value-of select="//teiHeader/fileDesc/publicationStmt/idno"/></li> -->
      
       <!-- source field -->
      <li><strong>Source: </strong> 
        
        <xsl:choose>
          <xsl:when test="TEI/teiHeader/fileDesc/sourceDesc/biblStruct[not(@type='supplied')]">
            <xsl:text>The transcription presented here is derived from </xsl:text> 
            <!-- if author -->
            <xsl:if test="TEI/teiHeader/fileDesc/sourceDesc/biblStruct/monogr/author">
              <xsl:value-of select="TEI/teiHeader/fileDesc/sourceDesc/biblStruct/monogr/author"/>
              <xsl:text>, </xsl:text>
            </xsl:if>
            <!-- monograph title -->
            <em><xsl:value-of select="TEI/teiHeader/fileDesc/sourceDesc/biblStruct/monogr/title"/></em>
            <!-- if editor // todo: simplify, should work if more than 2 editors -->
            <xsl:if test="TEI/teiHeader/fileDesc/sourceDesc/biblStruct/monogr/editor">
              <xsl:text>, ed. </xsl:text>
              <xsl:value-of select="TEI/teiHeader/fileDesc/sourceDesc/biblStruct/monogr/editor[1]"/>
              <xsl:if test="TEI/teiHeader/fileDesc/sourceDesc/biblStruct/monogr/editor[2]">
                <xsl:text> and </xsl:text>
                <xsl:value-of select="TEI/teiHeader/fileDesc/sourceDesc/biblStruct/monogr/editor[2]"/>
              </xsl:if>
            </xsl:if>
            <!-- publisher and date -->
            <xsl:text> (</xsl:text>
            <xsl:value-of select="TEI/teiHeader/fileDesc/sourceDesc/biblStruct/monogr//pubPlace"/>
            <xsl:text>: </xsl:text>
            <xsl:value-of select="TEI/teiHeader/fileDesc/sourceDesc/biblStruct/monogr//publisher"/>
            <xsl:text>, </xsl:text>
            <xsl:value-of select="TEI/teiHeader/fileDesc/sourceDesc/biblStruct/monogr//date"/>
            <xsl:text>)</xsl:text>
            <xsl:text>, </xsl:text>
            <!-- if volume -->
            <xsl:if test="TEI/teiHeader/fileDesc/sourceDesc/biblStruct/monogr//biblScope[@type='volume']">
              <xsl:value-of select="TEI/teiHeader/fileDesc/sourceDesc/biblStruct/monogr//biblScope[@type='volume']"/>
              <xsl:text>:</xsl:text>
            </xsl:if>
            <!-- page -->
            <xsl:value-of select="TEI/teiHeader/fileDesc/sourceDesc/biblStruct/monogr//biblScope[@unit='page']"/>
            <xsl:text>. </xsl:text>
            <!-- project -->
            <xsl:if test="TEI/teiHeader/fileDesc/sourceDesc/biblStruct/note[@type='project']">
              <xsl:apply-templates select="TEI/teiHeader/fileDesc/sourceDesc/biblStruct/note[@type='project']"/>
            </xsl:if>
            <xsl:text> </xsl:text>
            <!-- orgname // dodo: simplify -->
            <xsl:value-of select="TEI//sourceDesc//bibl[1]/orgName"/>
            <xsl:if test="TEI//sourceDesc//bibl[2]/orgName">
              <xsl:text>; </xsl:text>
              <xsl:value-of select="TEI//sourceDesc//bibl[2]/orgName"/>
            </xsl:if>
          </xsl:when>
          <!-- orgname // not sure if this will ever hit for manuscripts -->
          <xsl:otherwise>
            <xsl:value-of select="//TEI//sourceDesc//bibl[1]/orgName"/>
            <xsl:if test="TEI//sourceDesc//bibl[2]/orgName">
              <xsl:text>; </xsl:text>
              <xsl:value-of select="TEI//sourceDesc//bibl[2]/orgName"/>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>
        
        <!-- orgname // todo: simplify -->
        <xsl:choose>
          <xsl:when test="count(//TEI//sourceDesc//bibl) > 1 and //tei//sourceDesc//bibl[2]/orgname">
            <xsl:if test="not(ends-with(//TEI//sourceDesc//bibl[2]/orgName, '.'))">
              <xsl:text>.</xsl:text>
            </xsl:if>
          </xsl:when>
          <xsl:otherwise>
            <xsl:if test="not(ends-with(//TEI//sourceDesc//bibl[1]/orgName, '.'))">
              <xsl:text>.</xsl:text>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:text>  </xsl:text>
        
        <!-- project -->
        <xsl:apply-templates select="//TEI//sourceDesc//bibl[1]/note[@type = 'project'][not(@target)]"/>
        
        <!-- transcription statement -->
          <xsl:if test="not(TEI/teiHeader/fileDesc/sourceDesc/biblStruct)">
            <xsl:text> Transcribed from digital images or a microfilm reproduction of the original item. </xsl:text>
          </xsl:if>
        
        <!-- editorial statement -->
        <xsl:text> For a description of the editorial rationale behind our treatment of the manuscripts, see our </xsl:text>
        <a>
          <xsl:attribute name="href">
            <xsl:value-of select="$site_url"/>
            <xsl:text>/about/editorial</xsl:text>
          </xsl:attribute>
          <xsl:text>statement of editorial policy</xsl:text>
        </a>
        <xsl:text>.</xsl:text>
      </li>

    <!-- editorial note(s) field -->
    <xsl:if test="//body//note[@type='editorial'] | //body//note[@type='authorial'][@resp='unk'] | //notesStmt/note | //sourceDesc/bibl/note[@type='project'][not(@target)]">
        <xsl:choose>                        
            <xsl:when test="count(//body//note[@type='editorial'] | //body//note[@type='authorial'][@resp='unk']) = 1">
                <li><strong>Editorial Note: </strong>
                    <xsl:if test="//body//note[@type='editorial']">
                        <xsl:value-of select="//body//note[@type='editorial']"/>
                    </xsl:if>
                    <xsl:if test="//body//note[@type='authorial'][@resp='unk']">
                        <xsl:text>The marginal annotation, "</xsl:text><xsl:apply-templates select="//body//note[@type='authorial'][@resp='unk']"/><xsl:text>," is in a hand other than Whitman's.</xsl:text>
                    </xsl:if>
                </li>
            </xsl:when>
            
            <xsl:when test="count(//body//note[@type='editorial']) > 1">
                <li><strong>Editorial Notes: </strong>
                    <xsl:for-each select="//body//note[@type='editorial']">
                        <xsl:number level="any" count="note[@type='editorial']"/>
                        <xsl:text>. </xsl:text><xsl:apply-templates/>
                        <xsl:if test="following::note[@type='editorial']"><br /><br /></xsl:if>
                    </xsl:for-each>
                </li>
            </xsl:when>                                
        </xsl:choose>
    </xsl:if>

       <!-- <li><strong>Contributors to digital file: </strong> <xsl:value-of separator=" | " select="//teiHeader/fileDesc/notesStmt/note/persName"></xsl:value-of></li> -->

    </ul>
  </xsl:variable>
  


  <!-- PB's -->
  
  <xsl:template match="pb">
    <!-- do nothing on match, moved to top in next match -->
  </xsl:template>
  
  <!-- add all pb's to top and authorial notes to bottom -->
  <xsl:template match="/TEI/text">
    <div class="page_images_top">
      <xsl:for-each select="//pb">
        
        <xsl:variable name="figure_id">
            <xsl:variable name="figure_id_full">
              <xsl:value-of select="normalize-space(@facs)"/>
            </xsl:variable>
            <xsl:choose>
              <xsl:when test="ends-with($figure_id_full, '.jpg') or ends-with($figure_id_full, '.jpeg')">
                <xsl:value-of select="substring-before($figure_id_full, '.jp')"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$figure_id_full"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
        
          <xsl:if test="$figure_id != ''">
            <span>
              <xsl:attribute name="class">
                <xsl:text>pageimage</xsl:text>
              </xsl:attribute>
              <a>
                <xsl:attribute name="href">
                  <xsl:call-template name="url_builder">
                    <xsl:with-param name="figure_id_local" select="$figure_id"/>
                    <xsl:with-param name="image_size_local" select="$image_large"/>
                    <xsl:with-param name="iiif_path_local" select="$collection"/>
                  </xsl:call-template>
                </xsl:attribute>
                <xsl:attribute name="rel">
                  <xsl:text>prettyPhoto[pp_gal]</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="title">
                  <xsl:text>Page Image, text on page</xsl:text>              </xsl:attribute>
                
                <img>
                  <xsl:attribute name="src">
                    <xsl:call-template name="url_builder">
                      <xsl:with-param name="figure_id_local" select="$figure_id"/>
                      <xsl:with-param name="image_size_local" select="$image_thumb"/>
                      <xsl:with-param name="iiif_path_local" select="$collection"/>
                    </xsl:call-template>
                  </xsl:attribute>
                  <xsl:attribute name="class">
                    <xsl:text>display&#160;</xsl:text>
                  </xsl:attribute>
                </img>
              </a>
              <p>
                <xsl:text>Image </xsl:text>
                <xsl:value-of select="position()"/>
              </p>
            </span>
          
        </xsl:if>
        
      </xsl:for-each>
    </div>
    <xsl:apply-templates/>
    
    <!-- authorial notes -->
    <xsl:if test="//note[@type='authorial']">
      <div class="authorial_notes">
        <xsl:for-each select="//note[@type='authorial']">
          <div>
            <xsl:attribute name="class">
              <xsl:text>authorial_note </xsl:text>
              <xsl:call-template name="add_attributes"></xsl:call-template>
            </xsl:attribute>
            <xsl:apply-templates/>
          </div>
        </xsl:for-each>
        
      </div>
    </xsl:if>
  </xsl:template>
  
  <!-- authorial notes are moved to the end. see if authorial notes EVER display in place, 
    if not, we can move the choice for authorial notes to the whitman wide override file -->
  <xsl:template match="note">
    <xsl:choose>
      <xsl:when test="@type = 'authorial'"><!-- do nothing, these are moved to the end --></xsl:when>
      <xsl:when test="@place = 'foot'">
        <span>
          <xsl:attribute name="class">
            <xsl:call-template name="add_attributes"/>
            <xsl:text>foot </xsl:text>
          </xsl:attribute>
          <a>
            <xsl:attribute name="href">
              <xsl:text>#</xsl:text>
              <xsl:text>foot</xsl:text>
              <xsl:value-of select="@xml:id"/>
            </xsl:attribute>
            <xsl:attribute name="id">
              <xsl:text>body</xsl:text>
              <xsl:value-of select="@xml:id"/>
            </xsl:attribute>
            
            <xsl:text>(</xsl:text>
            <xsl:value-of select="substring(@xml:id, 2)"/>
            <xsl:text>)</xsl:text>
          </a>
        </span>
      </xsl:when>
      <xsl:otherwise>
        <div>
          <xsl:attribute name="class">
            <xsl:call-template name="add_attributes"/><xsl:text> </xsl:text>
            <xsl:value-of select="name()"/>
          </xsl:attribute>
          <span>
            
            <xsl:apply-templates/>
          </span>
        </div>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
</xsl:stylesheet>
