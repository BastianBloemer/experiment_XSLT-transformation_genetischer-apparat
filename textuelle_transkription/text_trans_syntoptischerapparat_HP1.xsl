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
                
                <!-- CSS-Anweisungen für Tieferstellungen von Hinzufügungen usw. -->
                <style>
                    .add-1-soon {
                        position: relative;
                        top: 1em;
                    }
                    .add-2-soon {
                        position: relative;
                        top: 2em;
                    }
                    span {
                        font-weight: bold;
                    }
                    .del-soon,
                    .del-instant {
                        font-weight: normal;
                    }</style>
            </head>
            <!-- Erzeugung der Grundlegenden Liste -->
            <body>
                <h1>Faust - Synoptischer Apparat</h1>
                <ol>
                    <xsl:apply-templates select="xml/text/p"/>
                </ol>
            </body>
        </html>
    </xsl:template>
    
    <!-- Erzeugung eines Listeneintrags pro Paragraph -->x
    <xsl:template match="p">
        <li>
            <span class="line">
                <xsl:apply-templates select="node()"/>
            </span>
        </li>
        <br/>
        <br/>
    </xsl:template>
    
    <!-- Klassifierzung der Sofortkorrektur und setzten eckiger Klammer-->
    <xsl:template match="del[@revType = ('instant')]">
        <span class="del-instant"> [<xsl:apply-templates/>]</span>
    </xsl:template>
    
    <!-- Klassifizierung der Streichung und setzten eckiger Klammer -->
    <xsl:template match="del[@revType = 'soon']">
        <span class="del-soon">[<xsl:apply-templates/>]</span>
    </xsl:template>
    
    <!-- Klassifizierung der Hinzufügung der Sofortkorrektur -->
    <xsl:template match="add[.//del[@revType = 'instant']]">
        <span class="add-del-instant">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <!-- Klassifizierung der einfachen Hinzufügungen nach Reihenfolge innerhalb eines Paragraphen -->
    <xsl:template match="add[not(.//del[@revType = 'instant'])]">
        <xsl:variable name="p" select="ancestor::p[1]"/>
        <xsl:variable name="index"
            select="count($p//add[not(.//del[@revType = 'instant'])]
            [. &lt;&lt; current()]) + 1"/>
        <span class="add-{$index}-soon">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    
</xsl:stylesheet>
