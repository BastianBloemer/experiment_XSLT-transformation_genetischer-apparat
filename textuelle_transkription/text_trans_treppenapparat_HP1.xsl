<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="xs math"
  version="3.0">
  <xsl:template match="/">
    <html>
      <head>
        <title>Faust – Prosaentwurf (HTML)</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>

        <!-- CSS-Anweisungen für das Verhalten der Sublist (in HP1 Sofortkorrektur)-->
        <style>
          .inline-sublist {
              display: inline-flex;
              flex-direction: column;
              margin: 0;
              padding: 0;
              list-style: none;
          }
          .inline-sublist > li {
              display: block;
              counter-increment: item;
          }
          .inline-sublist > li::before {
              content: counters(item, ".") ".";
              margin-right: 0.5em;
              margin-left: 0.5em;
              font-weight: bold;
          }
          .inline-sublist > li:first-child {
              display: inline-flex;
          }
          ol li::marker {
              font-weight: bold;
          }</style>
      </head>
      <body>
        <h1>Faust - Stufenapparat</h1>

        <!-- Erzeugen der ersten geordneten Liste. Inhalt wird weitere durch Templates erzeugt -->
        <ol start="1">
          <xsl:apply-templates select="xml/text/p"/>
        </ol>
      </body>
    </html>
  </xsl:template>

  <!-- Grundlegendes Template für alle Paragraphen. Es wird eine erste Listenzeiel mit dem Textinhalt bis zur ersten Hinzufügung erzeugt -->
  <xsl:template match="p">
    <li>
      <ol>
        <li>
          <xsl:apply-templates select="node()[not(self::add) and not(preceding-sibling::add)]"/>
        </li>

        <!-- Schleife für Streichung. Wenn eine Streichung im Paragraph wird eine leere Listenzeile erzeugt -->
        <xsl:for-each select="del[@revType = 'soon']">
          <li/>
        </xsl:for-each>

        <!-- Schleife für Hinzufügungen, die keine Sofortkorrekturen sind.  -->
        <xsl:for-each select="add[not(.//del[@revType = 'instant'])]">
          <li>
            <xsl:variable name="upto-current"
              select="../node()[. &lt;&lt; current() or . is current()]"/>
            <xsl:apply-templates select="$upto-current"/>
            <xsl:if
              test="position() = last() and not(following-sibling::add[1]//del[@revType = 'instant'])">
              <xsl:apply-templates select="following-sibling::node()"/>
            </xsl:if>
            
            <!--  Schleife für Sofortkorrekturen, wenn diese auf die erste Hinzufügung folgen  -->
            <xsl:if test="following-sibling::add[1][.//del[@revType = 'instant']]">
              <xsl:apply-templates
                select="following-sibling::node()
                [. &lt;&lt; following-sibling::add[.//del[@revType = 'instant']][1]]"/>
              <ol class="inline-sublist">
                <li>
                  <xsl:apply-templates
                    select="following-sibling::add/del[@revType = 'instant']/node()"/>
                </li>
                <li>
                  <xsl:apply-templates select="following-sibling::add/node()[not(self::del)]"/>
                </li>
              </ol>
            </xsl:if>
            
          </li>
        </xsl:for-each>
      </ol>
      <p/>
    </li>
  </xsl:template>


</xsl:stylesheet>
