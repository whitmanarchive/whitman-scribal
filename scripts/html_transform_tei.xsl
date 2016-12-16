<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="xs" version="2.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xpath-default-namespace="http://www.whitmanarchive.org/namespace">

  <xsl:import href="../../whitman-scripts/html/whitman_to_html.xsl"/>
  
  <!-- overrides -->

  <!-- THINGS JESSICA IS ADDING -->
  <xsl:template name="image_url">
    <xsl:value-of select="$externalfileroot"/>manuscripts/scribal<xsl:value-of select="@facs"/>
  </xsl:template>

  <!-- TODO need to refactor this -->
  <xsl:template name="authorial">
    <xsl:if test="//note[@type='authorial']">
      <div class="marginalnotes">
        <hr class="hr"/>
        <p>
          <xsl:for-each select="//body//note[@type='authorial']">
            <xsl:apply-templates/>
            <xsl:if test="child::note[@type='editorial']">
              <!-- The following is a very hacky work-around meant to get the footnotes functional for now, but this will need to be revisited -->
              <span>
                <sup>
                  <xsl:value-of select="count(//body//note[@type='editorial'])"/>
                </sup>
              </span>
            </xsl:if>
            <br/>
          </xsl:for-each>
        </p>
      </div>
    </xsl:if>
  </xsl:template>

  <xsl:template match="note">
    <xsl:choose>
      <xsl:when test="@type='editorial'">
        <xsl:choose>
          <xsl:when test="parent::note[@type='authorial']"/>
          <xsl:when test="count(//body//note[@type='editorial']) = 1"/>
          <xsl:otherwise>
            <span>
              <sup>
                <xsl:number count="note[@type='editorial']" level="any"/>
              </sup>
            </span>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="@type='authorial'"/>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
