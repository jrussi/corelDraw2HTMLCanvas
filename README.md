# corelDraw2HTMLCanvas
The aim is to be able to export basic Corel Draw shapes to the HTML canvas

It consists of a VBA macro to export the data and .js to interprete it.

#Usage

##In corel draw

1. Install the macro in corel draw;
2. Select the forms in corel draw; it won't work for groups inside groups.
3. Run the macro;
4. The code will be copied to the clipboard;
5. Paste it in the .js script. (next step)

##In the HTML file

First thing, create the object with the graphical data:

```js
var el = {  0: {
      grupo: 0,
      outline: 0.79,
      linecaps: 0,
      ZOrder: 9,
      strokeStyle: "#373435",
      type : "rectangle",
      fillStyle: "#00CCFF",
      points: [147.08,855.52],
      dims: [161.63,122.77]
  },
  1: {
      grupo: 1,
      outline: 0.79,
      linecaps: 0,
      ZOrder: 7,
      strokeStyle: "#373435",
      type : "rectangle",
      fillStyle: "none",
      points: [154.59,728.13],
      dims: [134.09,91.18]
  },
  2: {
      grupo: 2,
      outline: 2.67,
      linecaps: 0,
      ZOrder: 2,
      strokeStyle: "#373435",
      type : "rectangle",
      fillStyle: "#FF0000",
      points: [235.04,779.08],
      dims: [142.14,147.50]
  },
  3: {
      grupo: 2,
      outline: 2.67,
      linecaps: 0,
      ZOrder: 1,
      strokeStyle: "#373435",
      type: "ellipse",
      fillStyle: "#FFFF00",
      center: [306.11,852.83],
      radius: [71.07,73.75]
  },
  4: {
      grupo: 3,
      outline: 0.79,
      linecaps: 0,
      ZOrder: 5,
      strokeStyle: "#373435",
      fillStyle: "none",
      type: "curveLine",
      points: [
          [154.59,819.31],
          [235.04,926.58],
      ],
  },
  5: {
      grupo: 4,
      outline: 0.79,
      linecaps: 0,
      ZOrder: 4,
      strokeStyle: "#373435",
      fillStyle: "none",
      type: "curveLine",
      points: [
          [377.18,926.58],
          [433.99,846.58],
          [377.18,779.08],
      ],
  },
  6: {
      grupo: 5,
      outline: 0.79,
      linecaps: 0,
      ZOrder: 3,
      strokeStyle: "#373435",
      fillStyle: "none",
      type: "curveCurve",
      points: {
          0: { start: [154.59,728.13],
              startC: [167.34,758.52],
              endC: [158.28,819.31],
              end: [192.86,819.31],
          },
          1: { start: [192.86,819.31],
              startC: [227.44,819.31],
              endC: [223.35,794.48],
              end: [235.04,779.08],
          },
          2: { start: [235.04,779.08],
              startC: [246.73,763.69],
              endC: [242.89,728.13],
              end: [262.09,728.13],
          },
          3: { start: [262.09,728.13],
              startC: [281.28,728.13],
              endC: [279.81,762.10],
              end: [288.68,779.08],
          },
      },
  },
  7: {
      grupo: 6,
      outline: 0.00,
      linecaps: 0,
      ZOrder: 2,
      strokeStyle: "#C5CB30",
      type: "text",
      fillStyle: "#373435",
      text: "test import from corel",
      size: "24.00",
      font: "Arial",
      posicao: [150.95,935.67],
  },
  };
```

###(a) Canvas

```js
	//canvas panel
	var ctx = {};
	var canvasSchem=document.createElement("canvas");
	document.getElementById("tdCanvas").appendChild(canvasSchem);
	var ctxSchem = canvasSchem.getContext("2d");
	canvasSchem.width = limits["maxX"]-limits["minX"]+50;
	canvasSchem.height = -limits["maxY"]+limits["minY"]+50;
	
	//draw it
	var mod = {indices: [], props: {fillStyle: "#00FF00"}};
	graph.drawOnCanvas(ctxSchem, el, offsetX, offsetY, escala, mod);
```
	
###(b) SVG

```js
	//svg panel
	var NS="http://www.w3.org/2000/svg";
	var svg=document.createElementNS(NS,"svg");
	svg.setAttribute("width",limits["maxX"]-limits["minX"]+50);
	svg.setAttribute("height",-limits["maxY"]+limits["minY"]+50);
	document.getElementById("tdSVG").appendChild(svg);
	
	//draw it
	var mod = {indices: [], props: {fillStyle: "#00FF00"}};
	graph.drawSVG(svg, el, offsetX, offsetY, escala, mod);
```
	
##Methods:

Method|Descriptions
------|------------
graph.getLimits()|Returns maximum and minimum x and y coordinates
graph.getSelected()|Returns the index of the elements within a rectangle
graph.drawOnCanvas()|Draws an object within a canvas
graph.drawSVG()|Draws an object within an SVG element



###Parameter's description
```js
graph.getLimits(el, scale)

graph.getSelected(el, offsetX, offsetY, scale, x1, y1, x2, y2)

graph.drawOnCanvas(ctx, el, offsetX, offsetY, scale, modify)

graph.drawSVG(svg, el, offsetX, offsetY, scale, modify)
```

Parameter|Descriptions
-----------|----------
el|graphical data
scale|value that multiplies all values of the graphical data
offsetX|value that is addet to all x values of the graphical data
offsetY|value that is addet to all y values of the graphical data
x1|smaller x coordinate
y1|smaller y coordinate
x2|largest x coordinate
y2|largest y coordinate
ctx|context of a canvas object (var ctx = canvas.getContext("2d"))
modify|elements from the graphical data that will be modified
svg|svg object (var svg=document.createElementNS(NS,"svg"))

modify syntax:
```js
var indexes = [1,2,3];//array of indexes of the objects to be modified
var props = {fillStyle: "#00FF00", outline: 1};//object with a list of the properties to 
		//be modified and their new values
		
var modify = {indexes: indexes, props: props};
```

#Live example
[Simple live example](https://rawgit.com/jrussi/complexMathLibrary/master/example1.html)

