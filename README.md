# Übersicht CH Meteo Widget
Widget for [Übersicht](http://tracesof.net/uebersicht/) that displays meteorological data 
from a selected Swiss station (also included Malbun, Schaan and Vaduz, Liechtenstein).

![Screenshot](/screenshot.png?raw=true "Screenshot")

## Installing
Just extract the zip file inside your Übersicht widgets folder 
(normally `~/Library/Application Support/Übersicht`)

## Configuring
Open `index.coffee` in a text editor and change the following:

* `station = "TAE"` to any other three-letter code. You can find a list [in the attached file](/stations_list.tsv) or search the map [at the Meteoschweiz site](http://www.meteoschweiz.admin.ch/home/mess-und-prognosesysteme/bodenstationen/automatisches-messnetz.html).
* `language = "en"` (English) is the default but you can change it to `de` (German), `fr` (French), `it` (Italian) or `rm` (Romansh).
* Show or hide data changing `"yes"` to `"no"` or vice-versa in the items of `show`.

To reposition the widget, look further in the file for 
the `style:` section and change the numerical value 
of the lines `top: 100px` and `left: 10px`, 
which are the distances in pixels to the borders of the screen.
