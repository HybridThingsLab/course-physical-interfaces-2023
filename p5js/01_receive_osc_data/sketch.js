// canvas
let w = 800;
let h = 600;


// osc data
let smoothData = 0.1;
let light = 0;
let smooth_light = 0;
let acceleration = [0,0,0]
let smooth_acceleration = [0,0,0]


// osc
let socket;
let connectedStatus = 0;

let bridgeConfig = {
	local: {
		port: 9998,
		host: '127.0.0.1'
	},
	remotes: [{
		name: "noodle",
		port: 9999,
		host: '192.168.1.201'
		//host: '127.0.0.1'
	}
	]
};

function setup() {

	canvas = createCanvas(w, h);

	// osc
	setupOsc();

}

function draw() {

	background(0);

	// sendOsc("/data", [int(random(100)), int(random(100)), int(random(100))]);

	// show data as text
	noStroke();
	fill(255);
	text("light sensor: "+light, 16, 48);
	text("accelerator: "+acceleration[0]+" "+acceleration[1]+" "+acceleration[2], 16, 80);

	// show data as graphic
	fill(255);
	rect(16, 200, light, 10);

	fill(255,0,0);
	rect(width/2, 240, acceleration[0]*100, 10);
	fill(0,255,0);
	rect(width/2, 260, acceleration[1]*100, 10);
	fill(0,0,255);
	rect(width/2, 280, acceleration[2]*100, 10);

	// smooth data
	smooth_light = lerp(smooth_light, light, smoothData);

	smooth_acceleration[0] = lerp(smooth_acceleration[0], acceleration[0], smoothData);
	smooth_acceleration[1] = lerp(smooth_acceleration[1], acceleration[1], smoothData);
	smooth_acceleration[2] = lerp(smooth_acceleration[2], acceleration[2], smoothData);

	fill(255);
	rect(16, 300, smooth_light, 10);

	fill(255,0,0);
	rect(width/2, 340, smooth_acceleration[0]*100, 10);
	fill(0,255,0);
	rect(width/2, 360, smooth_acceleration[1]*100, 10);
	fill(0,0,255);
	rect(width/2, 380, smooth_acceleration[2]*100, 10);

}
// -------------------------------------------- //

function keyPressed() {

}

// -------------------------------------------- //

// OSC
function receiveOsc(address, value) {

	// console.log(address + "   " + value + '\n');

	// check osc address

	// light sensor
	if(address == "/light"){
		light = value[0];
	}

	// accelerometer
	if(address == "/acceleration"){
		acceleration[0] = value[0];
		acceleration[1] = value[1];
		acceleration[2] = value[2];
	}


}

function sendOsc(address, value) {
	socket.emit('message', [address].concat(value));
}

function setupOsc() {
	socket = io.connect('http://127.0.0.1:8081', {
		port: 8081,
		rememberTransport: false
	});
	socket.on('connect', function () {
		socket.emit('config', bridgeConfig);
	});
	socket.on('connected', function (msg) {
		connectedStatus = msg;
		console.log("socket says we're connected to osc", msg);
	});
	socket.on('message', function (msg) {
		// console.log("client socket got", msg);
		if (msg[0] == '#bundle') {
			for (var i = 2; i < msg.length; i++) {
				receiveOsc(msg[i][0], msg[i].splice(1));
			}
		} else {
			receiveOsc(msg[0], msg.splice(1));
		}
	});
}
