# Maschinen
* der Pneumatische Packer verschiebt items von einem Laufband in eine Kiste, einen Ofen, etc.
* der Puffernde Pneumatische Packer verhält sich wie ein Pneumatischer Packer, nur dass er ein eigenes Inventar hat
* der Überfließende Pneumatische Packer verhält sich wie ein Pneumatischer Packer, nur dass er nicht mehr als ein stapel eines typs in das Ziel lässt
* die Pneumatischen Nehmer entnehmen items aus kisten, öfen, etc.
* Laufbänder bewegen items
* Ventilatoren pusten items weg
* der Sauger saugt items in seinem Radius ein
* der Sortierer sortiert items die man unten (oder mit Packer) rein tut nach oben, die items die links und rechts in den unteren slots liegen geben vor wo die items hin sollen (lässt sich mit dem Pneumatischen Nehmer an der seite mit der jeweiligen Farbe entnehmen)
* im Flüssigkeitstank kann man Wasser und Lava speichern indem man in mit dem Eimer schlägt
* die Bohrer graben sich in den Boden und fördern Recourcen
* in den Hersteller kann man oben links das crafting rezept herein legen und unten (bzw. mit "mover") die Rostoffe und er stellt nach dem Rezept etwas her
* der Setzling Verarbeiter macht aus, oben Setzlingen ("sapplings") und unten Dünger, Holz
* der industrielle Ofen verhält sich wie ein normaler Ofen ("furnace"), nur dass er mindestens zwei Schornsteine oben drauf braucht
* die Industrielle Presse kann die aus Bäumen den saft holen und mit der man Lehm ("clay") komprimieren zu Komprimierten Lehm; oben die Recource unten Brennstoff; braucht auch zwei Schornsteine
* die Schornsteine müssen minimal 2 und maximal 7 Blöcke lang sein

# durch Verbrennung getriebene Maschinen
Alle Maschinen die durch Verbrennung funktionieren, wie auch der Setzlingverarbeiter nehmen ihr Brennmaterial durch die Rückseite.  
Alle Gegenstände die durch Front oder Seite gegeben werden landen im oberen Eingangsplatz.  
Gegenstände können aus dem Ausgang von jeder Seite genommen werden, aber es ist besser wenn man sich dabei nicht die Rückseite blockiert.  

Es gibt einige mit Verbrennung laufende Maschinen wie den Dratschneider, die Presse oder den Hochofen.  
Der Hochofen nutzt die Hitze rein zur Erhitzung des Inhalts,  
andere Maschinen nutzen die hitze meist um Rotationsenergie zu erzeugen.
Der Dratschneider Erhitzt auch das metall um es zu schneiden, dreht und schneidet aber hauptsächlich.  
Die Presse braucht die Hitze nur zum Pressen, nicht um den Inhalt zu erwärmen.

# dekorative Blöcke

## Fabrik Backstein
Ein Backstein der die Wände einer Fabrik verschönert.  
Er wird aus 4 Fabrik Klumpen hergestellt, welche aus Komprimiertem Lehm gebacken werden, welcher wiederum durch das pressen von Lehm hergestellt wird.  

## Gegenstandssieb
Ich hasse es in ein Loch im Boden zu fallen, welches nur da ist um Gegenstände durchzulassen.  
Gegenstandssiebe sind reine Dekoration, damit Spieler nicht durchfallen, wo Gegenstände hin sollen.  
Die Haufen Siebe sind ein wenig größer, damit auch große Mengen auf einem Haufen hindurch können.

# Sortierer
Der sortierer nimmt Gegenstände aus den unteren Feldern und überprüft ob sie die selben wie in einer der langen Seiten sind.  
Wenn ein Gegenstand der gleiche ist, wird er in den Ausgang auf der entspechenden Seite gelegt.  
Wenn ein Gegenstand nicht passt wird er in den oberen Ausgangsslot gelegt.  
Die Gegenstände in den Ausgagnsslots können mit Pneumatischen Nehmern an den seiten mit der jeweiligen Farbe entnommen werden.  
Die andere seite ist für die Eingabe von Gegenständen.  

# Elektronik

## Verteilung
Elektizität fließt durch Kabel. Anders als bei reeller Elektizität verteilt sich diese ungleichmäßig.  
Die Verteilung geht an alle Verbundenen Blöcke aus der "factory_electronic" Gruppe.  
Die erste Maschine die Strom bekommt nimmt soviel sie speichern kann.  
Die Restliche Energie wird im Netzwerk weiter verteilt.  
Wenn Energie fließt "heizen" sich Kabel auf, das verhindert Endlosschleifen in den Kabeln.  
Aufgeheizte Kabel kühlen sich ab, wenn die Energie auf alle umliegenden Blöcke verteilt wurde.  
Außerdem kühlen sie sich ab, wenn sie vom Spiel geladen werden damit Kabel außerhalb der Ladezone nicht blockiert bleiben.

## Generatoren
Generatoren stellen dem Netzwerk Energie zur verfügung, sie haben eine kleine Kapazität für übriggebliebene Energie, damit sie aufhören können zu laufen.  
Der Verbrennungsgenerator nimmt Brennbares um Energie zu produzieren. Er braucht wie die anderen Maschinen in "factory" die auf Verbrennung laufen einen Schornstein.

## Baterien
Baterien speichern Energie und verteilen sie wieder ins Netzwerk.  
Baterien speichern pro Zufluss 100 Einheiten damit sie nicht die gesamte Energie entziehen.  
Baterien schieben sich die Energie gegenseitig zu wodurch die Ladung ungleichmäßig verteilt wird.

## Verbraucher
Verbraucher wie der Elektrische Ofen funktionieren nur mit Strom.
Sie haben meist eine kleine Kapazität als Puffer.

## api
Die Beschreibung für Programierer ist auf englisch vorhanden.
