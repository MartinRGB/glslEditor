/*
Original: https://github.com/tangrams/tangram-play/blob/gh-pages/src/js/addons/ui/Divider.js
Author: Lou Huang (@saikofish)
*/

'use strict';

// Import Greensock (GSAP)
// import 'gsap/src/uncompressed/Tweenlite.js';
// import 'gsap/src/uncompressed/plugins/CSSPlugin.js';
// import Draggable from 'gsap/src/uncompressed/utils/Draggable.js';

const CM_MINIMUM_WIDTH = 160; // integer, in pixels
const GC_MINIMUM_WIDTH = 130; // integer, in pixels
const STORAGE_POSITION_KEY = 'divider-position-x';

export default class Divider {
    constructor (main) {
    	this.main = main;
    	this.pressed = false;
        this.x = 0.;

    	this.el = document.createElement('div');
        this.el.setAttribute('class', 'ge-divider');
        let spanDOM = document.createElement('span');
        spanDOM.setAttribute('class', 'ge-divider-affordance');
        this.el.appendChild(spanDOM);
        this.main.container.appendChild(this.el);

        // set Events
        let divider = this;
        this.el.style.left = 'auto';
        this.el.addEventListener('mousedown', (event) => {
			event.preventDefault();
			divider.pressed = true;
		}, false);
        this.main.container.addEventListener('mouseup',(event) => {
			event.preventDefault();
			divider.savePosition();
			divider.pressed = false;
		}, false);
		this.main.container.addEventListener('blur',(event) => {
			event.preventDefault();
			divider.savePosition();
			divider.pressed = false;
		}, false);
        this.main.container.addEventListener('mousemove', (event) => {
			if (divider.pressed) {
				event.preventDefault();
				divider.setPosition(event.pageX); 
			}
		}, false);

        this.main.editor.on('viewportChange', () => {
            // console.log(new Date().getTime());
            this.setPosition(this.getPosition());
        });

		this.setPosition(this.getStartingPosition());
	}

	setPosition (x) {
        this.x = x;

		x -= this.el.getBoundingClientRect().width/2;
        let y = 0;
        if (this.main.menu) {
            y = this.main.menu.menuDOM.getBoundingClientRect().height;
        }
    
		let transformStyle = 'translate3d(' + x + 'px, '+y+'px, 0px)';
		if (this.el.style.hasOwnProperty('transform')) {
            this.el.style.transform = transformStyle;
        }
        else if (this.el.style.hasOwnProperty('webkitTransform')) {
            // For Safari
            this.el.style.webkitTransform = transformStyle;
        }
        else {
            // For Firefox
            this.el.style.transform = transformStyle;
        }

        let editorWidth = this.main.editor.getWrapperElement().getBoundingClientRect();
        this.main.editor.setSize(editorWidth,'100%');

        let canvasWidth = this.main.container.getBoundingClientRect().width - this.el.getBoundingClientRect().left;
        let canvasHeight = this.main.container.getBoundingClientRect().height;


        this.main.sandbox.canvasDOM.style.width = canvasWidth + 'px';
        this.main.sandbox.canvasDOM.style.height = canvasHeight + 'px';
        this.el.style.height = canvasHeight + 'px';
	}

    getPosition() {
        return this.x;
    }

	getStartingPosition () {
		return this.main.container.getBoundingClientRect().width/2;
	}

	savePosition () {

	}
}