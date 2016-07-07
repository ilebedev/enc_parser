var STATE = {};

var Viewport = function(){
	this.init = function(){
		this.left = null;
		this.right = null;
		this.up = null;
		this.down = null;	
	}
	this.include = function(x,y){
		if(this.left == null || x < this.left){
			this.left = x;
		}
		if(this.right == null || x > this.right){
			this.right = x;
		}
		if(this.up == null || y < this.up){
			this.up = y;
		}
		if(this.down == null || y > this.down){
			this.down = y;
		}
	}

	this.center = function() {
		return {
			x: (this.right - this.left)/2 + this.left,
			y: (this.down - this.up)/2 + this.up
		}
	}
	this.radius = function() {
		return Math.max(this.right-this.left,this.down-this.up)/2
	}

	this.init();
}
var NauticalMap = function(id){
	this.init = function(id){
		this.map = L.map(id).setView([51.505,-0.09],13);
		L.tileLayer("http://{s}.tile.osm.org/{z}/{x}/{y}.png", {
			attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributers'
		}).addTo(this.map);
		this.data_viewport = new Viewport();
	}

	this.load = function(data){
		console.log(data);
		
		for(id in data.spatial.isol_nodes){
			var node = data.spatial.isol_nodes[id];
			var ys = node.data.x; 
			var xs = node.data.y;
			var zs = node.data.depth;
			if(xs.length == 1){
			   //L.marker([xs[0],ys[0]]).addTo(this.map)
				continue;
			}
			var coords = [];
			for(var i=0; i < xs.length; i++){
				var x = xs[i];
				var y = ys[i];
				var z = zs[i]
				coords.push([x,y]);
				this.data_viewport.include(x,y);
			}
			//L.polyline(coords).addTo(this.map);
		}
		for(id in data.spatial.edges){
			var node = data.spatial.edges[id];
			var ys = node.data.x;
			var xs = node.data.y;
			var coords = [];
			for(var i=0; i < xs.length; i++){
				var x = xs[i];
				var y = ys[i];
				coords.push([x,y]);
				this.data_viewport.include(x,y);
			}
			L.polyline(coords).addTo(this.map);

		}
		var c = this.data_viewport.center();
		this.map.setView([c.x,c.y],13);
	}


	this.init(id);
}
var init_map = function(){

}
$(document).ready(function(){
	STATE.map = new NauticalMap("viewport");

	$("#nautical").change(function(){
		var file = $(this).get(0).files[0]
		if(!file){
			return;
		}
		var reader = new FileReader();
		reader.onload = function(e){
  			var contents = e.target.result;
			STATE.data = JSON.parse(contents);
			STATE.map.load(STATE.data)
		}
		reader.readAsText(file);
	});
	$("#cache_file").click(function(){
		localStorage.setItem("nautical_data", JSON.stringify(STATE.data));
	});
	$("#load_cached").click(function(){
		var data_str = localStorage.getItem("nautical_data");
		if(data_str == undefined){
			return;
		}
		STATE.data = JSON.parse(data_str);
		STATE.map.load(STATE.data);
	});
	$("#load_cached").click();
});
