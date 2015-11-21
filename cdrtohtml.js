var graph = new function() {};
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
graph.getLimits = function (el,escala) {
	// auto find offsets
	var minX = 1e10;
	var minY = -1e10;
	var maxX = -1e10;
	var maxY = 1e10;
	for (var ii=0;ii<Object.keys(el).length;ii++){
		//if (ii == 81){1;}
		var points = getAllPoints(el[ii]);
		for (var jj=0;jj<points.length;jj++){
			if (escala*points[jj][0] < minX){
				minX = escala*points[jj][0];
			}
			if (escala*points[jj][1] > minY){
				minY = escala*points[jj][1];
			}
			if (escala*points[jj][0] > maxX){
				maxX = escala*points[jj][0];
			}
			if (escala*points[jj][1] < maxY){
				maxY = escala*points[jj][1];
			}
		}
	}
	//console.log(minX);
	return {minX: minX, minY: minY, maxX: maxX, maxY: maxY};
}
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
graph.getSelected = function(el,offsetX,offsetY,escala,x1,y1,x2,y2) {
	// auto find offsets
	var selecionados = [];
	var grupo = 0;
	
	var keys = Object.keys(el);
	for (var ii=0;ii<keys.length;ii++){
		//if (el[ii].grupo==29) {1;}
		var selected = true;
		var points = getAllPoints(el[keys[ii]]);
		//console.log(ii);
		for (var jj=0;jj<points.length;jj++){
			if ((escala*points[jj][0] + offsetX < x1)||(escala*points[jj][0] + offsetX > x2)||
				(-escala*points[jj][1] + offsetY < y1)||(-escala*points[jj][1] + offsetY > y2)){
				selected = false;
			}
		}
		if (selected){
			selecionados.push(el[keys[ii]].grupo);
		}
	}
	console.log(selecionados);
	
	return selecionados;
}
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
graph.drawOnCanvas = function(ctx, el, offsetX, offsetY, escala, modify) {
	//graph.draw2(ctx, el, offsetX, offsetY, escala, modify);
	var lineCaps = ["butt", "round", "square"];
	ctx.textAlign = "start"; 
	for (var ii=0;ii<Object.keys(el).length;ii++){
		//alterar valores dos grupos
		//ctx.setLineDash([]);
		if ("indexes" in modify) {
			if (modify.indexes.indexOf(el[ii].grupo)>=0){
				//ctx.setLineDash([2,6]);
				var keys = Object.keys(modify.props);
				for (var jj=0;jj<keys.length;jj++){
					el[ii][keys[jj]] = modify.props[keys[jj]];	
				}
			}
		}
		else {
			//ctx.setLineDash([2,6]);
			if (el[ii].grupo in modify){
				var keys = Object.keys(modify[el[ii].grupo]);
				for (var jj=0;jj<keys.length;jj++){
					el[ii][keys[jj]] = modify[el[ii].grupo][keys[jj]];
				}
			}
		}
		
		ctx.strokeStyle = el[ii].strokeStyle;

		switch (el[ii].type){
			case 'curveLine': {
				ctx.lineWidth = escala*el[ii].outline;
				ctx.lineCap = lineCaps[el[ii].linecaps];
				ctx.beginPath();
				ctx.moveTo(offsetX+escala*el[ii].points[0][0],offsetY-escala*el[ii].points[0][1]);
				for (var jj=0;jj<el[ii].points.length;jj++){
					ctx.lineTo(offsetX+escala*el[ii].points[jj][0],offsetY-escala*el[ii].points[jj][1]);
				}
				ctx.stroke();
				break;
			}
			case 'curveCurve': {
				ctx.lineWidth = escala*el[ii].outline;
				ctx.lineCap = lineCaps[el[ii].linecaps];
				ctx.beginPath();
				ctx.moveTo(offsetX+escala*el[ii].points[0].start[0],offsetY-escala*el[ii].points[0].start[1]);
				for (var jj=0;jj<Object.keys(el[ii].points).length;jj++){
					ctx.bezierCurveTo(offsetX+escala*el[ii].points[jj].startC[0], offsetY-escala*el[ii].points[jj].startC[1],
						offsetX+escala*el[ii].points[jj].endC[0], offsetY-escala*el[ii].points[jj].endC[1],
						offsetX+escala*el[ii].points[jj].end[0], offsetY-escala*el[ii].points[jj].end[1]);
						ctx.stroke();
				}
				if (el[ii].closed){
					ctx.closePath();
					if (el[ii].fillStyle !== "none") {
						ctx.fillStyle = el[ii].fillStyle;
						ctx.fill();
					}
				}
				break;
			}
			case "text": {
				ctx.font = escala*el[ii].size*1.4 + "px " + el[ii].font;
				ctx.fillStyle = el[ii].fillStyle;
				ctx.fillText(el[ii].text, offsetX+escala*el[ii].posicao[0], offsetY-escala*el[ii].posicao[1]);
				break;
			}
			case "rectangle": {
				ctx.beginPath();
				ctx.lineWidth = escala*el[ii].outline;
				ctx.fillStyle = el[ii].fillStyle;
				ctx.strokeStyle = el[ii].strokeStyle;
				ctx.rect(offsetX+escala*el[ii].points[0], 
					offsetY-escala*el[ii].points[1], 
					escala*(el[ii].dims[0]), 
					-escala*(el[ii].dims[1]));
				if (el[ii].fillStyle !== "none"){
					ctx.fill();
				}
				ctx.stroke();
				break;
			}
			case "ellipse": {
				ctx.beginPath();
				ctx.lineWidth = escala*el[ii].outline;
				ctx.fillStyle = el[ii].fillStyle;
				var rotationRads = 0;
				ctx.strokeStyle = el[ii].strokeStyle;
				ctx.ellipse(offsetX+escala*el[ii].center[0], offsetY-escala*el[ii].center[1],
				escala*el[ii].radius[0], escala*el[ii].radius[1], rotationRads, 0, 2 * Math.PI);
				ctx.fill();
				ctx.stroke();
				break;
			}
			default: {
				console.log("Tipo não encontrado");
			}
		}
	}
}
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
graph.drawSVG = function(svg, el, offsetX, offsetY, escala, modify) {
	var lineCaps = ["butt", "round", "square"];
	for (var ii=0;ii<Object.keys(el).length;ii++){
		//alterar valores dos grupos
		if ("indexes" in modify) {
			if (modify.indexes.indexOf(el[ii].grupo)>=0){
				//ctx.setLineDash([2,6]);
				var keys = Object.keys(modify.props);
				for (var jj=0;jj<keys.length;jj++){
					el[ii][keys[jj]] = modify.props[keys[jj]];	
				}
			}
		}
		else {
			if (el[ii].grupo in modify){
				var keys = Object.keys(modify[el[ii].grupo]);
				for (var jj=0;jj<keys.length;jj++){
					el[ii][keys[jj]] = modify[el[ii].grupo][keys[jj]];
				}
			}
		}
		
		ctx.strokeStyle = el[ii].strokeStyle;

		switch (el[ii].type){
			case 'curveLine': {
				var elem = document.createElementNS(NS,"polyline");
				var points = "";
				for (var jj=0;jj<el[ii].points.length;jj++){
					points += (offsetX+escala*el[ii].points[jj][0]) + "," + (offsetY-escala*el[ii].points[jj][1]) + " ";
				}
				elem.setAttribute("points",points);
				elem.style.strokeLinecap = lineCaps[el[ii].linecaps];
				elem.style.fill = el[ii].fillStyle;
				elem.style.stroke = el[ii].strokeStyle;
				elem.style.strokeWidth = escala*el[ii].outline;
				svg.appendChild(elem);
				break;
			}
			case 'curveCurve': {
				var elem = document.createElementNS(NS,"path");
				var points = "";
				for (var jj=0;jj<Object.keys(el[ii].points).length;jj++){
					if (jj==0){
						points += "M" +(offsetX+escala*el[ii].points[jj].start[0]) + "," + (offsetY-escala*el[ii].points[jj].start[1]) + " ";
					}			
					points += "C" + (offsetX+escala*el[ii].points[jj].startC[0]) + "," + (offsetY-escala*el[ii].points[jj].startC[1]) + " ";
					points += (offsetX+escala*el[ii].points[jj].endC[0]) + "," + (offsetY-escala*el[ii].points[jj].endC[1]) + " ";
					points += (offsetX+escala*el[ii].points[jj].end[0]) + "," + (offsetY-escala*el[ii].points[jj].end[1]) + " ";
				}
				if ((el[ii].closed)&&(el[ii].fillStyle !== "none")){
					points += "z";
				}
				elem.setAttribute("d",points);
				elem.setAttribute("fill","black");
				elem.style.strokeLinecap = lineCaps[el[ii].linecaps];
				elem.style.fill = el[ii].fillStyle;
				elem.style.stroke = el[ii].strokeStyle;
				elem.style.strokeWidth = escala*el[ii].outline;
				svg.appendChild(elem);
				break;
			}
			case "text": {
				var elem = document.createElementNS(NS,"text");
				elem.setAttribute("x",offsetX+escala*el[ii].posicao[0]);
				elem.setAttribute("y",offsetY-escala*el[ii].posicao[1]);
				elem.innerHTML = el[ii].text;
				elem.style.fontSize = escala*el[ii].size*1.4+ "px ";
				elem.style.fontFamily = el[ii].font;;
				elem.style.fill = el[ii].fillStyle;
				elem.style.stroke = el[ii].strokeStyle;
				elem.style.strokeWidth = escala*el[ii].outline;
				svg.appendChild(elem);
				break;
			}
			case "rectangle": {
				var elem = document.createElementNS(NS,"rect");
				elem.setAttribute("x",offsetX+escala*el[ii].points[0]);
				elem.setAttribute("y",offsetY-escala*el[ii].points[1]-escala*(el[ii].dims[1]));
				elem.setAttribute("width",escala*(el[ii].dims[0]));
				elem.setAttribute("height",escala*(el[ii].dims[1]));
				elem.style.fill = el[ii].fillStyle;
				elem.style.stroke = el[ii].strokeStyle;
				elem.style.strokeWidth = escala*el[ii].outline;
				svg.appendChild(elem);
				break;
			}
			case "ellipse": {
				var elem = document.createElementNS(NS,"ellipse");
				elem.setAttribute("cx",offsetX+escala*el[ii].center[0]);
				elem.setAttribute("cy",offsetY-escala*el[ii].center[1]);
				elem.setAttribute("rx",escala*el[ii].radius[0]);
				elem.setAttribute("ry",escala*el[ii].radius[1]);
				elem.style.fill = el[ii].fillStyle;
				elem.style.stroke = el[ii].strokeStyle;
				elem.style.strokeWidth = escala*el[ii].outline;
				svg.appendChild(elem);		
				break;
			}
			default: {
				console.log("Tipo não encontrado");
			}
		}
	}
}
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
function getAllPoints(el){
	var points = [];
	switch (el.type){
		case 'curveLine': {
			for (var jj=0;jj<el.points.length;jj++){
				points.push([el.points[jj][0],el.points[jj][1]]);
			}
			break;
		}
		case 'curveCurve': {
			points.push([el.points[0].start[0], el.points[0].start[1]]);
			for (var jj=0;jj<Object.keys(el.points).length;jj++){
				points.push([el.points[jj].end[0], el.points[jj].end[1]]);
			}
			break;
		}
		case "text": {
			points.push([el.posicao[0], el.posicao[1]]);
			break;
		}
		case "rectangle": {
			points.push(el.points);
			points.push([el.points[0]+el.dims[0], el.points[1]+el.dims[1]]);
			break;
		}
		case "ellipse": {
			points.push([el.center[0]+el.radius[0], el.center[1]+el.radius[1]]);
			points.push([el.center[0]-el.radius[0], el.center[1]+el.radius[1]]);
			points.push([el.center[0]+el.radius[0], el.center[1]-el.radius[1]]);
			points.push([el.center[0]-el.radius[0], el.center[1]-el.radius[1]]);
			break;
		}
		default: {
			console.log("Tipo não encontrado");
		}
	}
	return points;
}

