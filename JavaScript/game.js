// Global variables
// Canvas area for text
var textCanvas;  
// Drawing environment for text canvas
var textContext; 

// Canvas area for rocket
var gameCanvas;  
// Drawing environment for rocket
var gameContext; 

// Adjust as needed
var fontSize = 20;  
// Y-Position where to draw rocket message (if needed) in text canvas
var rocketMessagePosition = fontSize;  
// Y-coordinates of Rocket height message
var heightTextPosition = rocketMessagePosition + fontSize + 10;
// Y-coordinates of Rocket velocity message
var velocityTextPosition = heightTextPosition + fontSize + 10;
// Y-coordinates of Rocket fuel message
var fuelTextPosition = velocityTextPosition + fontSize + 10;
// X-coordinate of the messages
var messageX = 0;

// Time interval in milliseconds for animation, set as desired
var deltaTimeInterval = 100;

// Is the engine burning?
var burning = false;

// Game class
var game;
// Has the game been initialized?
var initialized = false;

var rocketSize;

// You add this function, and change this context, it is passed
// the height of the rocket.
function drawLander(height) {
  // The y-coordinate goes from 0 to canvas.height, so need to reverse for
  // the rocket appearing to go down.
  var ycoord = gameCanvas.height - height;
  rocketSize = 5;
  // Rocket is a square, draw it. You should draw a nice rocket.
  gameContext.fillRect(gameCanvas.width/2, h-rocketSize, rocketSize, rocketSize);
}

// Draw where to land
function drawSurface(height) {
}

// Display a message
function message(text, ycoord) {
  textContext.clearRect(messageX, y - fontSize, textCanvas.width, fontSize + 10);
  textContext.strokeText(text, 0, y);  
}

// The Planet class models a Planet, which has a gravity and
// a ground height.
function Planet(gravity, ground) {
    this.gravity = gravity;
    this.ground = ground;
    this.getGravity = (function() { return this.gravity; });
    this.getGround = (function() { return this.ground; });
}

// The Rocket class models a Rocket, which has a current height
// above a planet, amount of fuel left, current velocity, and
// engine strength
function Rocket(velocity, height, fuel, engine, planet) {
  this.nextHeight = function(deltaTime) { }
  this.nextVelocity = function(burnRate, deltaTime) { }
  this.reportHeight = function() { }
  this.reportVelocity = function() { }
  this.reportFuel = function() { }
  this.toString = function() {
    return "HEIGHT " + this.height + " Velocity " + this.velocity 
               + " FUEL " + this.amountFuel;
  }

  this.reachedSurface = function() { }
  this.landed = function(safeVelocity) { }

  this.move = function(burnRate, deltaTime) { 
    var br = burnRate;
    if (this .amountFuel < (br * deltaTime)) {
      br = this.amountFuel / deltaTime;
      this.amountFuel = 0.0;
      }
    else {
      this.amountFuel = this.amountFuel - br * deltaTime;
    }
   this.nextHeight(deltaTime);
   this.nextVelocity(br, deltaTime);
  }

}

// The Game class models a Game, the safeVelocity is the
// velocity within which the rocket can land.  The crashVelocity
// is the Velocity in which the rocket is blasted to smithereens.
function Game(rocket, safeVelocity, crashVelocity) {
  this.rocket = rocket;
  this.deltaTime = deltaTimeInterval / 1000;

  // Rocket explodes if reached surface going faster than this
  this.tooFast = crashVelocity;

// Message if lander crashes
  this.crashedMessage = "Crashed and Burned Sucker!\n";
  this.explodedMessage = "Blasted to Smithereens!\n";
  this.landedMessage = "Landed Safely! One small step for man, one giant leap for mankind\n";

// Safe landing velocity must be between 0 and this number
  this.safeVelocity = safeVelocity;

  this.strategy = function() { }

  this.play = function() {
    var burnRate = this.strategy();
    }
  }


// Functions to turn the engines on/off
function burn() { }
function noburn() { }

// Main function to start the game
function gameStart() {
  if (!initialized) {
    // Initialize the drawing environments
    textCanvas = document.getElementById("textCanvas");
    textContext = textCanvas.getContext("2d");
    textContext.clearRect(0,0,textCanvas.width,textCanvas.height);
    gameCanvas = document.getElementById('gameCanvas');
    gameContext = gameCanvas.getContext("2d");
    gameContext.clearRect(0,0,textCanvas.width,textCanvas.height);
    textContext.font = fontSize + "px Courier"; // Set the font as desired

    // Create a few objects
    var pluto = new Planet(0.5, 200.0);
    var jupiter = new Planet(1.0, 4.0);
    var myRocket = new Rocket(0.0, gameCanvas.height - rocketSize, 100.0, 1.0, pluto);
    drawSurface(pluto.getGround());
    game = new Game(myRocket, -4.0, -10.0);
    noburn();
    initialized = true;
  }

  // Start the game
  game.play();
  return false;
}

// Animate
setInterval(gameStart, deltaTimeInterval);
