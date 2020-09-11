/* Lightning City Scape with Splitting Bolts */

//import processing.sound.*; // load the Sound Library


// GLOBAL PARAMETERS
int strikePercentage = 5; // percent of frames that have a lightning bolt
int defaultFrameRate = 4;
int thunderDelay = 8; // number of frames to wait before thunder sounds after lightning
int howWidePhoto = 900; // (these need to match the size function parameters)
int howTallPhoto = 250; //  found in setup()
int howLongIsBolt = 110;//  how long is the maximum length of the bolt?

// GLOBAL VARIABLES
PImage image1;               //image1: the background picture of the city
int startX = 10;              // where a lightning bolt line segment starts
int startY = 0;
int endX = 0;                  // where a lightning bolt line segment stops
int endY = 0;

// SoundFile thunderSoundFile;  //  soundfile that stores the thunder sound

int thunderCountDown; // keeps track of how long since lightning strike

int returnRandomNumber(int max) {
 // this function returns a random integer,x, such that 0<= X <= max
 // the argument, max, must be an integer >= 0.
return ((int) (Math.random()*(max+1)));
}

// MAIN FUNCTIONS
void setup()
{
 size(900,250); // these should be at least as large has the howWidePhoto and howTallPhoto parameters
 image1 = loadImage("sfnight1.jpeg");
 // from https://www.jharrisonphoto.com/Landscapes/San-Francisco-City-Scapes-and/i-PQLTk4b/
 image1.resize(howWidePhoto, howTallPhoto);
 background(image1);
 frameRate(defaultFrameRate); // slow down redraw to keep lightning on screen
 // thunderSoundFile = new SoundFile(this, "thunder.mp3");  // Load a soundfile and play it back
 // from https://www.freesoundeffects.com/free-sounds/thunder-sounds-10040/
}

void drawBolt(int startX, int startY, int yLimit, int sW, int xVar, int splitProbability) {

/*  This function draws a lighting bolt starting at startX, startY and
    ending when the Y coordinate is at the yLimit.

    The amount of xVariation is defined by xVar: an integer 0-20 where 20 means more variation.

    The sW is the stroke width of the bolt.

    The probability of the bolt splitting is defined by splitProbability: 0 to 99.
    */
 int endX, endY = 0;

 if (sW < 1) {
    sW = 1;
 }
 strokeWeight(sW);
 while (endY < yLimit) {
   endX = startX + returnRandomNumber(xVar-1)-(xVar/2);
         /* e.g. if xvar is 18, this will return a random number between -9 and +9
          and add it to startX. So, x increases or decreases by a random amount. */
   endY = startY + returnRandomNumber(xVar/2);
         /* this line advances Y by a random amount with half of the variation of
           the x variation. e.g. in the above example when xVar is 18, this would
           make an endY that is startY plus a random value from 0 to 9. */
   line (startX, startY, endX, endY); // draw the line segment
   startX = endX; // move the starting point for the next line segment to
   startY = endY; // the ending point of this line segment

   /* Determine if the lightning bolt is going to split into two bolts */
   if (returnRandomNumber(99)<splitProbability) {
       // splitProbability is used to decide how likely it is for the lightning bolt
       // to split. If 99, then it will always split. If 0, then it will never split.
       // otherwise, it sill split according to its percentage.
       // A single bolt can split multiple times, because the split can happen (or not)
       // at each line segment.
     //System.out.println("Bolt Splits!"); a debugging statement
     drawBolt(startX, startY,yLimit, sW-1, xVar+1, splitProbability);
       // call this function drawBolt, again. This is a recursive function call.
       // it starts drawing the new lightning bolt that resulted from the split
       // at the current x, y location.
       // we send startX and startY (the starting point for the 'split' bolt.
       // the y-limit is the same.
       // it increases the xvariable after the split to make the bolts cooler. (xVar+1).
       // and we keep the split probability the same (you could increase it, but
       // the program crashed with too many recursive calls).
   }
 }
}

void draw()
{
background(image1); //make the city background the background.
thunderCountDown--; //each time we enter draw, the value of thunderCountDown decreases.
if (thunderCountDown == 0) {
 // when thunderCountDown == zero, then we play the sound of thunder.
 //thunderSoundFile.play();
}
if (returnRandomNumber(99)<strikePercentage) {
 // lighting isnt drawn every time draw is run. To make it more realistic,
 // lighting happens randomly, and not often. strikePercentage is used to decide
 // how often. If it's 99, then everytime we enter draw, there will be a lightning strike.
 // if zero, then there will never be a lightning strike
 stroke(255,255,255); // set the stroke color (white)
 startX = returnRandomNumber(howWidePhoto-20)+10; // the starting point of the lighting bolt.
                                      // a randomSpot on the top of the screen.
                                      // we add 10 so that it is not starting at the
                                      // edge of the screen. And we substract 20 from the
                                      // random number so it's not at the right edge
                                      // of the screen
 drawBolt(startX, 0, howLongIsBolt, 3,18,10);
 thunderCountDown = thunderDelay;
 }
}

void mousePressed()
{
background(image1);
drawBolt(mouseX, mouseY, howLongIsBolt, 3,30, 20);
thunderCountDown = thunderDelay;
}
