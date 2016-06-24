# PKU-Balanced

Die App wurde im Rahmen des iOS Schulkurses der Berner Fachhochschule BFH, Studiengang Informatik, entwickelt. Ziel war Grundlegende Kenntnisse im Bereich der iOS Programmierung zu erhalten und diese in einem App-Projekt zu realisieren.

## Idee

Menschen die an der Stoffwechselstörung Phenylketonurie betroffen sind, müssen täglich "Buch" führen über die Mahlzeiten die Sie zu sich genommen haben.
Mit der App soll es möglich sein, Produkte und deren Nährwerte zu erfassen, diese anschliessend in geeigneter Weise darzustellen und auswählen können. Jedes zu sich genommene Produkt soll täglich in einem Protokoll festgehalten werden und den entsprechend Phenylalanin-Wert angezeigen (einzeln wie auch im Total). Sollte das Phenylalanin sein persönliches Limit überschreiten, soll dies hervorgehoben werden.

Die Tagesprotokolle sollen auch für spätere Betrachtung zur Verfügung stehen.

## Der Fokus

Der Fokus wurde Hauptsächlich auf Grundlegende Funktionen von iOS und Xcode mit Swift geleget und deren Anwendung. Konkret Core Data, Table Views, Storyboard, Suchfunktion (testweise) und Basics.

## Die Realisation
- Der Anwender hat die Möglichkeit ein neues Produkt zu erfassen, dem Tagesprotokoll hinzuzufügen und auch nachträglich zu bearbeiten.
- Die Tagesprotokolle können auch noch nachträglich eingesehen werden.
- Optimiert für iPhone 5

## Features

- Produkt hinzufügen
- Einfache Validierung der Input Felder
- Persistente Speicherung der Datenwerte
- Produkte nachträglich bearbeiten
- Produkte löschen können
- Aktuelle Anzeige des Phenylalanin (Phe) basierend auf die zugenommene Menge pro Produkt und gesamt
- Visualisierung, wann das Phe-Limit überschritten wurde
- Mit Swipe nach Links können Protokolleinträge und Produkte bearbeitet oder gelöscht werden
- Tagesprotokolle in der Übersicht einsehen
- Tagesprotokolle einzeln ansehen
- Suchfunktion im Produktkatalog

## Known Issues

- Wenn ein Produkt gelöscht wird und dieses in einem Tagesprotokoll vorkommt crashed die App da der Phe-Wert nicht mehr ausgerechnet werden kann
- Bei der Suche im Produktkatalog verschiebt sich die TableView nach oben und das Suchfeld überdeckt die erste Zeile der TableView. Die Suche funktioniert nur wird das gefundene Produkt evt. durch das Suchfeld eben überdeckt (wenn die TableView nach unten gezogen wird, sieht man das gesuchte Produkt).
