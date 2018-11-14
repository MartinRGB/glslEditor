var springSystem = new rebound.SpringSystem();
var slot1Spring = springSystem.createSpring(40, 10);
var slot2Spring = springSystem.createSpring(80, 20);	
var isSwitch = true;
var isIn = false;
var switcher = document.getElementById('cb2');
var codeMirrorContent = document.getElementsByClassName('CodeMirror-sizer')[0]
var controlPanel = document.getElementById('control_panel')
var topPanel = document.getElementsByClassName('ge_panel')[0]
var renderRequestId;
var array = [];


var foggyJSONRequest = new XMLHttpRequest();
var liquidflowJSONRequest = new XMLHttpRequest();
var foggyOriginalShaderRequest = new XMLHttpRequest();
var foggyShaderRequest = new XMLHttpRequest();
var liquidflowShaderRequest = new XMLHttpRequest();

// ### Stats.js
function setStats(){

	for ( var i = 0; i < 3; i ++ ) {
		var stats = new Stats();
		stats.showPanel(2-i);
		stats.dom.style.position = 'fixed';
		stats.dom.style.right =  34 + i*80 +'px';
		document.body.appendChild( stats.dom );
		array.push( stats );
	}

}

function statsAnimate() {
	renderRequestId = undefined;
	for ( var i = 0; i < array.length; i ++ ) {
		var stats = array[ i ];
		stats.update();
	}
	startStats();
}


function startStats(){
	if(!renderRequestId){
		renderRequestId = requestAnimationFrame( statsAnimate );
	}
}

function stopStats(){
	if(renderRequestId){

		window.cancelAnimationFrame(renderRequestId);
		renderRequestId = undefined;
	}
}


// ### Reset Tab

function resetTab(){


	
	var totalBuffer = window.glslEditor.bufferManager.buffers;
	var bufferArray = []
	for (var key in totalBuffer) {
		if (totalBuffer.hasOwnProperty(key)) {
			bufferArray.push({"type" : key, "name" : totalBuffer[key] })
		}
	}

	if(bufferArray.length != 2){
		for(i=0;i<bufferArray.length;i++){
			if(bufferArray[i].type != '烟雾' && bufferArray[i].type != '光流'){
				window.glslEditor.bufferManager.close(bufferArray[i].type);
			}
		}
	}


	if(window.glslEditor.bufferManager.buffers.烟雾 !=null){
		//window.glslEditor.bufferManager.close('光流')
	}
	else{

		foggyShaderRequest.open('GET', './shader/foggy.glsl', true);
	
		foggyShaderRequest.responseType = 'text';
		foggyShaderRequest.onload = function() {
			foggyShaderText = foggyShaderRequest.responseText;
			window.glslEditor.open(foggyShaderRequest.responseText,'烟雾')
		};

		foggyShaderRequest.send();

	}

	if(window.glslEditor.bufferManager.buffers.光流 !=null){
		//window.glslEditor.bufferManager.close('烟雾')
	}
	else{


		liquidflowShaderRequest.open('GET', './shader/lightflow.glsl', true);
	
		liquidflowShaderRequest.responseType = 'text';

		
		liquidflowShaderRequest.onload = function() {
			window.glslEditor.open(liquidflowShaderRequest.responseText,'光流')
		};
		liquidflowShaderRequest.send();


	}


	initTabWithJSON()
}


function getShaderData(path){ 
	var data
	var xhr=new XMLHttpRequest();
	xhr.open('GET', path,false);
	xhr.onload=function(){
		data=this.responseText;
	}
	xhr.send();
	return data;
}


// ### Render Setting
function setRender(){

	window.glslEditor.shader.canvas.pause();
	window.glslEditor.shader.controls.playPause.name = '<i class="material-icons">play_arrow</i>';
	stopStats();


	document.addEventListener("mouseleave", function(event){

		if(event.clientY <= 0 || event.clientX <= 0 || (event.clientX >= window.innerWidth || event.clientY >= window.innerHeight))
		{
			console.log("I'm out");
			if(isIn){
				isIn = false;
				window.glslEditor.shader.canvas.pause()
				window.glslEditor.shader.controls.playPause.name = '<i class="material-icons">play_arrow</i>';
				stopStats();
				//console.log(window.glslEditor.shader.controls.playPause.shouldPlay)
			}
		}
	});

	document.addEventListener("mouseenter", function(event){

		if(event.clientY <= 0 || event.clientX <= 0 || (event.clientX >= window.innerWidth || event.clientY >= window.innerHeight))
		{
	
		}
		else{
			console.log("I'm in");
			if(!isIn){
				isIn = true;
				window.glslEditor.shader.canvas.play()
				window.glslEditor.shader.controls.playPause.name = '<i class="material-icons">pause</i>';
				startStats();
				//console.log(window.glslEditor.shader.controls.playPause.shouldPlay)
			}
		}
	});
}

// ### Init Spring System
function initSpringSystem(){
	slot1Spring.addListener({
		onSpringUpdate: function(slot1Spring) {
			var val = slot1Spring.getCurrentValue();
			window.glslEditor.shader.canvas.createUniform('1f', 'float', 'u_slot1', val)
		}
	});
	
	slot2Spring.addListener({
		onSpringUpdate: function(slot2Spring) {
		var val = slot2Spring.getCurrentValue();
		}
	});
	
	slot1Spring.setCurrentValue(1.0);
	slot2Spring.setCurrentValue(0.0);
}

// Use Menu to Control Spring System
function setSpringControl(){
	window.glslEditor.menu.menus.createItems(
		window.glslEditor.menu.menus.slot1,
		window.glslEditor.menu.el,
		'ge_menu',
		'S1',
		function (event) {
			if(isSwitch){
			slot1Spring.setEndValue(0);
			}
			else{
			slot1Spring.setEndValue(1);
			}
			isSwitch = !isSwitch;
		}
	)
	
	
	window.glslEditor.menu.menus.createItems(
		window.glslEditor.menu.menus.slot2,
		window.glslEditor.menu.el,
		'ge_menu',
		'S2-0',
		function (event) {
			slot2Spring.setEndValue(0);
		}
	)
	
	window.glslEditor.menu.menus.createItems(
		window.glslEditor.menu.menus.slot2,
		window.glslEditor.menu.el,
		'ge_menu',
		'S2-1',
		function (event) {
			slot2Spring.setEndValue(1);
		}
	)
	
	window.glslEditor.menu.menus.createItems(
		window.glslEditor.menu.menus.slot2,
		window.glslEditor.menu.el,
		'ge_menu',
		'S2-2',
		function (event) {
			slot2Spring.setEndValue(2);
		}
	)
	
	window.glslEditor.menu.menus.createItems(
		window.glslEditor.menu.menus.slot2,
		window.glslEditor.menu.el,
		'ge_menu',
		'S2-3',
		function (event) {
			slot2Spring.setEndValue(3);
		}
	)
}

// Bind Spring System into Shader
function bindSpringToShader(){
	window.glslEditor.shader.canvas.createUniform('1f', 'float', 'u_slot1', slot1Spring.getCurrentValue())
	window.glslEditor.shader.canvas.createUniform('1f', 'float', 'u_slot2', slot2Spring.getCurrentValue())
	window.glslEditor.shader.canvas.createUniform('1f', 'float', 'u_slot3', 1)
	window.glslEditor.shader.canvas.createUniform('1f', 'float', 'u_slot4', 0)
}

function setSpring(){
	initSpringSystem();
	setSpringControl();
	bindSpringToShader();
}


// ### Switcher Check Event

function setSwitcher(){
	switcher.addEventListener('change', handleSwitch);
	function handleSwitch(e){
		if(e.target.checked == true){
			controlPanel.style.height = '0px';
			codeMirrorContent.style.filter = 'blur(0px)';
		}
		else{
			controlPanel.style.height = "659px";
			codeMirrorContent.style.filter = 'blur(7px)';
		}
	};

}

function changeSwitcher(){
	var clickEvent = new MouseEvent("click", {
		"view": window,
		"bubbles": false,
		"cancelable": false
	});
	
	switcher.dispatchEvent(clickEvent)
}


// ### Tab Click Event

function setTabClickEvent(){
	topPanel.children[0].addEventListener("click", handleTabOne);
	topPanel.children[1].addEventListener("click", handleTabTwo);
	
	function handleTabOne(e){
		// if(switcher.checked == true){
		// 	changeSwitcher();
		// }
		switchJSON(4,foggyJSONRequest)
	};
	
	function handleTabTwo(e){
		switchJSON(2,liquidflowJSONRequest)
	};
}

function initTabWithJSON(){

	// Remove Tab
	var radioParent = document.getElementById("radiot_group");
	while (radioParent.firstChild) {
		radioParent.removeChild(radioParent.firstChild);
	}

	var sliderParent = document.getElementById("slider_group");
	while (sliderParent.firstChild) {
		sliderParent.removeChild(sliderParent.firstChild);
	}


	// Load JSON
	foggyJSONRequest.open('GET', './shader/foggy_program.json', true);

	foggyJSONRequest.responseType = 'json';

	foggyJSONRequest.onload = function() {
		var foggyJSONInfo = foggyJSONRequest.response;
	};
	foggyJSONRequest.send(null);


	liquidflowJSONRequest.open('GET', './shader/lightflow_program.json', true);

	liquidflowJSONRequest.responseType = 'json';

	liquidflowJSONRequest.onload = function() {
		var initJSONInfo = liquidflowJSONRequest.response;
		// Create Radio
		for(i=0;i<initJSONInfo.presents.length;i++){
			if(i == initJSONInfo.presents.length - 1 ){
				createCheckBox(initJSONInfo.presents[i],initJSONInfo.presents[i].translation,i,true);
			}
			else{
				createCheckBox(initJSONInfo.presents[i],initJSONInfo.presents[i].translation,i,false);
			}
		}


		for(i=0;i<initJSONInfo.presents[initJSONInfo.presents.length - 1].arguments.length;i++){

			bindJSONtoUnifrom(initJSONInfo.presents[initJSONInfo.presents.length - 1].arguments[i],initJSONInfo.presents[initJSONInfo.presents.length - 1].arguments[i].translation,i)
			createSeekBar(initJSONInfo.presents[initJSONInfo.presents.length - 1].arguments[i],initJSONInfo.presents[initJSONInfo.presents.length - 1].arguments[i].translation,i);

		}

	};
	liquidflowJSONRequest.send(null);
}

function switchJSON(index,jsonReq){
	var radioParent = document.getElementById("radiot_group");
	while (radioParent.firstChild) {
		radioParent.removeChild(radioParent.firstChild);
	}

	var sliderParent = document.getElementById("slider_group");
	while (sliderParent.firstChild) {
		sliderParent.removeChild(sliderParent.firstChild);
	}

	var jsonInfo = jsonReq.response;
	for(i=0;i<jsonInfo.presents.length;i++){
		if(i == index ){
			createCheckBox(jsonInfo.presents[i],jsonInfo.presents[i].translation,i,true);
		}
		else{
			createCheckBox(jsonInfo.presents[i],jsonInfo.presents[i].translation,i,false);
		}

	}

	for(i=0;i<jsonInfo.presents[index].arguments.length;i++){
		bindJSONtoUnifrom(jsonInfo.presents[index].arguments[i],jsonInfo.presents[index].arguments[i].translation,i)
		createSeekBar(jsonInfo.presents[index].arguments[i],jsonInfo.presents[index].arguments[i].translation,i);
	}
	
}


function createCheckBox(info,title,index,checked){

	var labelE = document.createElement('label');
	labelE.className = 'control control--radio';
	labelE.innerHTML = title
	var inputE = document.createElement('input');
	inputE.type = "radio"
	inputE.name ="radio"
	inputE.checked = checked;
	var indicatorE = document.createElement('div');
	indicatorE.className = 'control__indicator';
	document.getElementById('radiot_group').append(labelE);
	labelE.append(inputE);
	labelE.append(indicatorE);

	inputE.addEventListener( 'change', function() {
		if(this.checked) {
			console.log(index + " checked!")
			if(window.glslEditor.bufferManager.current == '光流'){
				//switchJSONTwo(index)
				switchJSON(index,liquidflowJSONRequest)
			}
			else if(window.glslEditor.bufferManager.current == '烟雾'){
				//switchJSONOne(index)
				switchJSON(index,foggyJSONRequest)
			}
		} 
	});


}

function bindJSONtoUnifrom(info,title,index){
	if(info.type == "vec1"){
		window.glslEditor.shader.canvas.createUniform('1f', 'float', info.name, Number(info.value[0]))
	}

	if(info.type == "vec2"){
		window.glslEditor.shader.canvas.createUniform2f('2f', 'float', info.name, Number(info.value[0]), Number(info.value[1]))
	}

	if(info.type == "boolean"){
		window.glslEditor.shader.canvas.createUniform('1i', 'bool', info.name, info.value)
	}

	if(info.type == "color"){
		window.glslEditor.shader.canvas.createUniform3f('3f', 'float', info.name,Number(info.value[0]),Number(info.value[1]),Number(info.value[2]));
	}


}

function createSeekBar(info,title,index){

	var containerE = document.createElement('div');
	containerE.className = 'slidecontainer';
	

	if(info.type == "vec1"){
		var labelE = document.createElement('p');
		labelE.innerHTML = title + ': ' + info.value.toString()
		labelE.className ="control_text"
		var controlE = document.createElement('input');
		controlE.className = 'slider';
		controlE.id = "range"
		controlE.type = "range"
		controlE.min = "-5"
		controlE.max = "5"
		controlE.step = "0.01"
		controlE.value = info.value
		document.getElementById('slider_group').append(containerE);
		containerE.append(labelE);
		containerE.append(controlE);

		controlE.addEventListener( 'input', function(e) {
			labelE. innerHTML = title + ': ' + e.target.value;
			window.glslEditor.shader.canvas.createUniform('1f', 'float', info.name,  Number(e.target.value))

			// var val = (Number(e.target.value) - Number(e.target.attributes.min.nodeValue))/(Number(e.target.attributes.max.nodeValue) - Number(e.target.attributes.min.nodeValue));
			// console.log(val);
		});
	}
	if(info.type == "color"){

		var controlContainerE = document.createElement('div');
		document.getElementById('slider_group').append(containerE);

		var labelE = document.createElement('p');
		labelE.innerHTML = title 
		labelE.className ="control_text"
		labelE.style.marginBottom = "0px";
		controlContainerE.append(labelE);

		var controlElement1 = document.createElement('input');
		var controlElement2 = document.createElement('input');
		var controlElement3 = document.createElement('input');
		var controlTitle1 = document.createElement('p');
		var controlTitle2 = document.createElement('p');
		var controlTitle3 = document.createElement('p');
		var childrenE1 = document.createElement('div');
		var childrenE2 = document.createElement('div');
		var childrenE3 = document.createElement('div');

		var colorString = ['红','黄','蓝']
		var childrenElement = [childrenE1,childrenE2,childrenE3]
		var sliderElement = [controlElement1,controlElement2,controlElement3]
		var titleElement = [controlTitle1,controlTitle2,controlTitle3]
		containerE.append(controlContainerE);
		var colorValStore = [];
		colorValStore.push(info.value[0]);
		colorValStore.push(info.value[1]);
		colorValStore.push(info.value[2]);

		//0
		childrenElement[0].style.display = 'inline-block'
		childrenElement[0].style.width = '33%'

		sliderElement[0].className = 'control control--slider';
		sliderElement[0].style.width ='90%';
		sliderElement[0].id = "range"
		sliderElement[0].type = "range"
		sliderElement[0].min = "0"
		sliderElement[0].max = "1"
		sliderElement[0].value = info.value[0]
		sliderElement[0].step = "0.01"
		sliderElement[0].style.paddingLeft = "0px"

		titleElement[0].index = 0
		titleElement[0].className ="control_text"

		titleElement[0].innerHTML = colorString[0] + ": " + info.value[0].toString();

		sliderElement[0].addEventListener( 'input', function(e) {
			colorValStore[0] = e.target.value;
			titleElement[0].innerHTML = colorString[0] + ': ' + e.target.value;
			window.glslEditor.shader.canvas.createUniform3f('3f', 'float', info.name,Number(colorValStore[0]),Number(colorValStore[1]),Number(colorValStore[2]));
		});

		childrenElement[0].append(titleElement[0]);
		childrenElement[0].append(sliderElement[0]);

		controlContainerE.append(childrenElement[0]);


		//1
		childrenElement[1].style.display = 'inline-block'
		childrenElement[1].style.width = '33%'

		sliderElement[1].className = 'control control--slider';
		sliderElement[1].style.width ='90%';
		sliderElement[1].style.marginLeft = '5%';
		sliderElement[1].id = "range"
		sliderElement[1].type = "range"
		sliderElement[1].min = "0"
		sliderElement[1].max = "1"
		sliderElement[1].value = info.value[1]
		sliderElement[1].step = "0.01"
		sliderElement[1].style.paddingLeft = "0px"

		titleElement[1].index = 1
		titleElement[1].style.marginLeft = '5%';
		titleElement[1].className ="control_text"
		titleElement[1].innerHTML = colorString[1] + ": " + info.value[1].toString();

		sliderElement[1].addEventListener( 'input', function(e) {
			colorValStore[1] = e.target.value;
			titleElement[1].innerHTML = colorString[1] + ': ' + e.target.value;
			window.glslEditor.shader.canvas.createUniform3f('3f', 'float', info.name,Number(colorValStore[0]),Number(colorValStore[1]),Number(colorValStore[2]));
		});

		childrenElement[1].append(titleElement[1]);
		childrenElement[1].append(sliderElement[1]);

		controlContainerE.append(childrenElement[1]);

		//2

		childrenElement[2].style.display = 'inline-block'
		childrenElement[2].style.width = '33%'

		sliderElement[2].className = 'control control--slider';
		sliderElement[2].style.width ='90%';
		sliderElement[2].style.marginLeft = '10%';
		sliderElement[2].id = "range"
		sliderElement[2].type = "range"
		sliderElement[2].min = "0"
		sliderElement[2].max = "1"
		sliderElement[2].value = info.value[2]
		sliderElement[2].step = "0.01"
		sliderElement[2].style.paddingLeft = "0px"

		titleElement[2].index = 2
		titleElement[2].style.marginLeft = '10%';
		titleElement[2].className ="control_text"

		titleElement[2].innerHTML = colorString[2] + ": " + info.value[2].toString();

		sliderElement[2].addEventListener( 'input', function(e) {
			colorValStore[2] = e.target.value;
			titleElement[2].innerHTML = colorString[2] + ': ' + e.target.value;
			window.glslEditor.shader.canvas.createUniform3f('3f', 'float', info.name,Number(colorValStore[0]),Number(colorValStore[1]),Number(colorValStore[2]));
		});

		childrenElement[2].append(titleElement[2]);
		childrenElement[2].append(sliderElement[2]);

		controlContainerE.append(childrenElement[2]);

	}

	if(info.type == "vec2"){

		var controlContainerE = document.createElement('div');
		document.getElementById('slider_group').append(containerE);

		var labelE = document.createElement('p');
		labelE.innerHTML = title 
		labelE.className ="control_text"
		labelE.style.marginBottom = "0px";
		controlContainerE.append(labelE);

		var controlElement1 = document.createElement('input');
		var controlElement2 = document.createElement('input');
		var controlTitle1 = document.createElement('p');
		var controlTitle2 = document.createElement('p');
		var childrenE1 = document.createElement('div');
		var childrenE2 = document.createElement('div');

		var axisString = ['x轴','y轴',]
		var childrenElement = [childrenE1,childrenE2]
		var sliderElement = [controlElement1,controlElement2]
		var titleElement = [controlTitle1,controlTitle2]
		containerE.append(controlContainerE);
		var axisValStore = [];
		axisValStore.push(info.value[0]);
		axisValStore.push(info.value[1]);

		//0
		childrenElement[0].style.display = 'inline-block'
		childrenElement[0].style.width = '50%'

		sliderElement[0].className = 'control control--slider';
		sliderElement[0].style.width ='90%';
		sliderElement[0].id = "range"
		sliderElement[0].type = "range"
		sliderElement[0].min = "0"
		sliderElement[0].max = "100"
		sliderElement[0].value = info.value[0]
		sliderElement[0].step = "0.01"
		sliderElement[0].style.paddingLeft = "0px"

		titleElement[0].index = 0
		titleElement[0].className ="control_text"

		titleElement[0].innerHTML = axisString[0] + ": " + info.value[0].toString();

		sliderElement[0].addEventListener( 'input', function(e) {
			axisValStore[0] = e.target.value;
			titleElement[0].innerHTML = axisString[0] + ': ' + e.target.value;
			window.glslEditor.shader.canvas.createUniform2f('2f', 'float', info.name,Number(axisValStore[0]),Number(axisValStore[1]));
		});

		childrenElement[0].append(titleElement[0]);
		childrenElement[0].append(sliderElement[0]);

		controlContainerE.append(childrenElement[0]);


		//1
		childrenElement[1].style.display = 'inline-block'
		childrenElement[1].style.width = '50%'

		sliderElement[1].className = 'control control--slider';
		sliderElement[1].style.width ='90%';
		sliderElement[1].style.marginLeft = '10%';
		sliderElement[1].id = "range"
		sliderElement[1].type = "range"
		sliderElement[1].min = "0"
		sliderElement[1].max = "100"
		sliderElement[1].value = info.value[1]
		sliderElement[1].step = "0.01"
		sliderElement[1].style.paddingLeft = "0px"

		titleElement[1].index = 1
		titleElement[1].style.marginLeft = '10%';
		titleElement[1].className ="control_text"
		titleElement[1].innerHTML = axisString[1] + ": " + info.value[1].toString();

		sliderElement[1].addEventListener( 'input', function(e) {
			axisValStore[1] = e.target.value;
			titleElement[1].innerHTML = axisString[1] + ': ' + e.target.value;
			window.glslEditor.shader.canvas.createUniform2f('2f', 'float', info.name,Number(axisValStore[0]),Number(axisValStore[1]));
		});

		childrenElement[1].append(titleElement[1]);
		childrenElement[1].append(sliderElement[1]);

		controlContainerE.append(childrenElement[1]);

	}

	if(info.type == "boolean"){
		var labelE = document.createElement('label');
		labelE.className = 'control control--checkbox';
		labelE.innerHTML = title
		var inputE = document.createElement('input');
		inputE.type = "checkbox"
		inputE.checked = info.value;
		var indicatorE = document.createElement('div');
		indicatorE.className = 'control__indicator';
		document.getElementById('slider_group').append(containerE);
		containerE.append(labelE);
		labelE.append(inputE);
		labelE.append(indicatorE);
		containerE.style.marginTop = '15px';

		inputE.addEventListener('change', handleSwitch);
		function handleSwitch(e){
			if(e.target.checked == true){
				window.glslEditor.shader.canvas.createUniform('1f', 'float', info.name, e.target.checked)
			}
			else{
				window.glslEditor.shader.canvas.createUniform('1f', 'float', info.name, e.target.checked)
			}
		};

	}
}

setStats();
resetTab();
setSpring();
setRender();
setSwitcher();
setTabClickEvent();

