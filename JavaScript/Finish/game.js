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

var rocketSize = 35; //size of the rocket in pixels
var keepPlaying = true; //used to determine whether to keep calling game.play every cycle
var burnRate = 1; //constant burnrate of the engine
var playerBurningFuel = false; //boolean used to determine if the user has the engine on or not
var currentPlanet = "pluto"; //current planet, can be pluto or jupiter

//draws lander and the sky
function drawLander(height)
{
    // The y-coordinate goes from 0 to canvas.height, so need to reverse for
    // the rocket appearing to go down.
    var ycoord = gameCanvas.height - height;

    //draws a nice gradient that becomes more red as the lander gets closer to the ground
    var skyColor = gameContext.createLinearGradient(0, 0, 0, height);
    skyColor.addColorStop(0, "blue");
    skyColor.addColorStop(1, "red");

    gameContext.fillStyle = skyColor;
    gameContext.beginPath();

    gameContext.fillRect(0, 0, gameCanvas.width, gameCanvas.height);

    gameContext.stroke();

    //gets a shipImage (hidden on the page) and draws it
    var shipImage = document.getElementById("EnterpriseE4");
    gameContext.drawImage(shipImage, gameCanvas.width / 2 - rocketSize / 2, gameCanvas.height - (height + rocketSize), rocketSize, rocketSize);

    //decides whether to draw the burning jet streams or not
    if (playerBurningFuel == true)
    {
        var fireImage = document.getElementById("fireStream");
        gameContext.drawImage(fireImage, gameCanvas.width / 2 - rocketSize / 2, gameCanvas.height - (height + rocketSize) + rocketSize, rocketSize / 2, rocketSize);
        gameContext.drawImage(fireImage, gameCanvas.width / 2 - rocketSize / 2 + rocketSize / 2, gameCanvas.height - (height + rocketSize) + rocketSize, rocketSize / 2, rocketSize);

    }




}

// Draw where to land
function drawSurface(height)
{
    gameContext.fillStyle = "black";
    gameContext.beginPath();
    gameContext.fillRect(0, gameCanvas.height - height, gameCanvas.width, height);
    gameContext.stroke();
}

// Display a message
function message(text)
{
    textContext.clearRect(messageX, 0, textCanvas.width, textCanvas.height);

    var yseperation = 30; //seperation between each line in pixels
    var startingYSeperation = 2; //seperation between top of canvas and first line

    var textArray = text.split("\n");
    for (var i = 0; i < textArray.length; ++i)
    {
        textContext.strokeText(textArray[i], 0, yseperation * (i + startingYSeperation));
    }


}

// The Planet class models a Planet, which has a gravity and
// a ground height.
function Planet(gravity, ground)
{
    this.gravity = gravity;
    this.ground = ground;
    this.getGravity = (function () { return this.gravity; });
    this.getGround = (function () { return this.ground; });
}

// The Rocket class models a Rocket, which has a current height
// above a planet, amount of fuel left, current velocity, and
// engine strength
function Rocket(velocity, height, fuel, engineStrength, planet)
{
    this.velocity = velocity;
    this.height = height;
    this.fuel = fuel;
    this.engineStrength = engineStrength;
    this.planet = planet;
    this.engineOn = false

    //sets height to the next height in the cycle
    this.nextHeight = function (deltaTime)
    {
        //height(t) = height(t - dt) + (velocity(t - dt) * dt).
        this.height = this.height + this.velocity * deltaTime;
    }
    //sets velocity to the next velocity in the cycle
    this.nextVelocity = function (br, deltaTime)
    {
        //velocity(t) = velocity(t - dt) + ((engine_strength * burnRate) - GRAVITY)
        this.velocity = this.velocity + (this.engineStrength * br) - planet.getGravity();
    }
    this.toString = function ()
    {
        return "HEIGHT " + this.height + "\n" + " Velocity " + this.velocity + "\n" +
                   " FUEL " + this.fuel + "\n";
    }

    //was used in the AI stragety to determine if the lander is about to crash
    //this.calculatedNextHeight = function (deltaTime)
    //{
    //    return this.height + this.velocity * deltaTime;
    //}

    this.reachedSurface = function () { }
    this.landed = function (safeVelocity) { }

	//moves the ship to the new height with the next velocity
    this.move = function (deltaTime)
    {
        var br = burnRate; //burnRate is constant
        if (playerBurningFuel == true)
        {
            if (this.fuel < (br * deltaTime))
            {
                br = this.fuel / deltaTime;
                this.fuel = 0.0;
            }
            else
            {
                this.fuel = this.fuel - br * deltaTime;
            }
        }
        else
        {
            br = 0;
        }

        this.nextVelocity(br, deltaTime);
        this.nextHeight(deltaTime);



    }

}

// The Game class models a Game, the safeVelocity is the
// velocity within which the rocket can land.  The crashVelocity
// is the Velocity in which the rocket is blasted to smithereens.
function Game(rocket, safeVelocity, crashVelocity)
{
    this.rocket = rocket;
    this.deltaTime = deltaTimeInterval / 1000;

    // Rocket explodes if reached surface going faster than this
    this.crashVelocity = crashVelocity;
    // Safe landing velocity must be between 0 and this number
    this.safeVelocity = safeVelocity;

    // Message if lander crashes
    this.crashedMessage = "Crashed and Burned Sucker!\n";
    this.explodedMessage = "Blasted to Smithereens!\n";
    this.landedMessage = "Landed Safely! One small step for man, one giant leap for mankind\n";

    
    
    //AI stragety (when I thought the burn rate was not constant), it decides if the ship is about to crash and
    //if so burns enough fuel to put the ship back in a safe velocity (if possible)
    //this.strategy = function ()
    //{
    //    if (rocket.calculatedNextHeight(this.deltaTime) < rocket.planet.getGround())
    //    {
    //        var neededBurnRate = (rocket.planet.getGravity() + safeVelocity + rocket.velocity * -1) / rocket.engineStrength;
    //        return neededBurnRate;
    //    }
    //    else
    //    {
    //        return 0;
    //    }
    //}

    this.play = function ()
    {
        //determines if the ship has landed
        if (reachedSurface(rocket))
        {
            var resultMessage;
            if (rocket.velocity < this.crashVelocity)
            {
                resultMessage = this.explodedMessage;
            }
            else if (rocket.velocity < this.safeVelocity)
            {
                resultMessage = this.crashedMessage;
            }
            else
            {
                resultMessage = this.landedMessage;
            }
            keepPlaying = confirm(resultMessage + "play again?")
            if (keepPlaying == true)
            {
                gameStart();
            }
            return;

        }

        //was used for the AI when I thought burnRate was not constant
        //var burnRate = this.strategy();

        rocket.move(this.deltaTime);
        drawLander(rocket.height);
        drawSurface(rocket.planet.getGround());
        message(rocket.toString());
    }
}

//determines if the rocket has landed
function reachedSurface(rocket)
{
	if (rocket.height < rocket.planet.getGround())
		return true;
	else
		return false;
}

//a function that will return if the rocket landed safely (not used in my implementation)
//NOTE: rocket.velocity and safeVelocity will be negative values
function landed(rocket, safeVelocity)
{
	if (rocket.velocity < this.safeVelocity)
	{
		return false;
	}
	else
	{
		return true;
	}
	
}

function switchPlanet()
{
    if (currentPlanet == "pluto")
    {
        currentPlanet = "jupiter";
    }
    else
    {
        currentPlanet = "pluto";
    }
    gameStart();
}


// turns engine on
function burn()
{
    playerBurningFuel = true;
    document.getElementById("buttonBurn").style.backgroundColor = "green";
    document.getElementById("buttonNoBurn").style.backgroundColor = "";
}

//turns engine off
function noburn()
{
    document.getElementById("buttonBurn").style.backgroundColor = "";
    document.getElementById("buttonNoBurn").style.backgroundColor = "green";
    playerBurningFuel = false;
}

// Main function to start the game
function gameStart()
{
    keepPlaying = true;
    if (!initialized)
    {
        document.getElementById("buttonStartGame").innerHTML = "restart game"; //lets the player restart the level
        setInterval(gameCycle, deltaTimeInterval); //animates the frame by calling gameCycle every deltaTimeInterval miliseconds
    }

    // Initialize the drawing environments
    textCanvas = document.getElementById("textCanvas");
    textContext = textCanvas.getContext("2d");
    textContext.clearRect(0, 0, textCanvas.width, textCanvas.height);
    gameCanvas = document.getElementById('gameCanvas');
    gameContext = gameCanvas.getContext("2d");
    gameContext.clearRect(0, 0, textCanvas.width, textCanvas.height);
    textContext.font = fontSize + "px Courier"; // Set the font as desired

    // Create a few objects
    var pluto = new Planet(0.5, 200.0);
    var jupiter = new Planet(0.75, 4.0);
    var myRocket;
    if (currentPlanet == "pluto")
        myRocket = new Rocket(0.0, gameCanvas.height - rocketSize, 100.0, 1.0, pluto);
    else
        myRocket = new Rocket(0.0, gameCanvas.height - rocketSize, 100.0, 1.0, jupiter);
    game = new Game(myRocket, -4.0, -10.0);
    noburn();
    initialized = true;

}

//this is called every cycle at which the height, velocity, and fuel are recalculated
function gameCycle()
{
    if (!keepPlaying)
        return;
    game.play();
}
