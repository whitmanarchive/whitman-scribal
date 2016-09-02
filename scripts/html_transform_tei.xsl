<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="xs" version="2.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xpath-default-namespace="http://www.whitmanarchive.org/namespace">

  <xsl:import href="../../whitman-scripts/html/whitman_to_html.xsl"/>
  
  <!-- overrides -->

  <!-- THINGS JESSICA IS ADDING -->
  <xsl:template name="image_url">
    <xsl:value-of select="$externalfileroot"/>manuscripts/scribal<xsl:value-of select="@facs"/>
  </xsl:template>

  <!-- TODO did not refactor anything when copying into scribal -->
  <xsl:template name="authorial">
    <xsl:if test="//note[@type='authorial']">
      <xsl:if test="$path1='scribal'">
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
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
