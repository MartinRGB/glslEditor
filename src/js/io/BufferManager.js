'use strict';

// Import CodeMirror
import CodeMirror from 'codemirror';
import 'codemirror/mode/clike/clike.js';

export default class BufferManager {
	constructor (main) {
		this.main = main;
		this.buffers = {};
		this.tabs = {};
		this.current = 'untitled.frag';
	}

	open (name, content) {
		if (this.panel === undefined) {
			// Create DOM element
			this.el = document.createElement('ul');
			this.el.className = 'ge_panel';
			// Create Panel CM element
			this.panel = this.main.editor.addPanel(this.el, {position: 'top'});
			this.open(this.current, this.main.getContent());
		}
		this.buffers[name] = CodeMirror.Doc(content, 'x-shader/x-fragment');

		// Create a new tab
		let tab = document.createElement('li');
		tab.setAttribute('class', 'ge_panel_tab');
		tab.textContent = name;
		CodeMirror.on(tab, 'click', () => {
			this.select(name);
		});

		if (this.getLength() !== 1) {
			let close = tab.appendChild(document.createElement('a'));
			close.textContent = 'x';
			close.setAttribute('class', 'ge_panel_tab_close');
			CodeMirror.on(close, 'click', () => {
				this.close(name);
			});
		}

		this.el.appendChild(tab);
		this.tabs[name] = tab;
	}

	select (name) {
		let buf = this.buffers[name];

		if (buf === undefined) {
			return;
		}

		if (buf.getEditor()) {
			buf = buf.linkedDoc({sharedHist: true});
		}
		let old = this.main.editor.swapDoc(buf);
		let linked = old.iterLinkedDocs(function(doc) {
			linked = doc;
		});
		if (linked) {
		    // Make sure the document in buffers is the one the other view is looking at
		    for (var name in this.buffers) {
		    	if (this.buffers[name] === old) {
		    		this.buffers[name] = linked;
		    	}
		    }
		    old.unlinkDoc(linked);
		}
		this.main.editor.focus();
		this.main.setContent(this.main.getContent());

		if (this.tabs[this.current]) {
			this.tabs[this.current].setAttribute('class', 'ge_panel_tab');
		}
		
		this.tabs[name].setAttribute('class', 'ge_panel_tab_active');
		this.current = name;
	}

	close (name) {
		if (name === this.getCurrent()) {
			this.select('untitled.frag');
		}
    	this.el.removeChild(this.tabs[name]);
    	delete this.tabs[name];
    	delete this.buffers[name];

    	if (this.getLength() === 1) {
    		this.panel.clear();
    		this.panel = undefined;
    		this.el = undefined;
    	}
	}

	getCurrent () {
		return this.current;
	}

	getLength () {
		return Object.keys(this.buffers).length;
	}
}