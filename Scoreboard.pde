//Video library
import processing.video.*;
Movie movie1;
Movie movie2;
Movie movie4;
Movie movie5;

//Minim audio library
import ddf.minim.*;
Minim minim;
AudioPlayer player;

//OSC library
import oscP5.*;
import netP5.*;
OscP5 oscP5;
NetAddress myRemoteLocation;

int cr = 25; //color transparancy of red 
int cb = 25; //color transparancy of blue
int cg = 25; //color transparancy of green
int cy = 25; //color transparancy of yellow

color[] colors = new color[4];
color i = (int(random(colors.length)));
int value = 0;

PFont font;

String[] fingers = {
  "index finger", "middle finger", "ring finger"
};
int whichFinger = int(random(fingers.length));

//Game states
boolean gameDefault = true;
boolean gameOver = false;
boolean gameStart = false;
boolean playedStartMovie = false;
boolean P1Wins = false;
boolean P2Wins = false;

//Timer variables
int savedTime;
int totalTime = 4000;
int savedTime2;
int totalTime2 = 2500;
int savedTime3;

void setup() {
  size(1440, 900);
  background(255);
  
  smooth();

  movie1 = new Movie(this, "gameover.mov");
  movie2 = new Movie(this, "gamestarted.mov");
  movie4 = new Movie(this, "p1wins.mov");
  movie5 = new Movie(this, "p2wins.mov");

  //This is the port you listen on 
  oscP5 = new OscP5(this, 12000);
  //This is the port you send on
  myRemoteLocation = new NetAddress("127.0.0.1", 8888);
}

void draw() {
  savedTime3 = millis();
  background(255);
  stroke(255);
  
  // Circle consisting of 4 colored arcs
  fill(255, 0, 0, cr);
  arc(400, 300, 370, 370, radians(270), radians(360));

  fill(44, 180, 54, cg);
  arc(400, 300, 370, 370, radians(0), radians(90));

  fill(0, 0, 255, cb);
  arc(400, 300, 370, 370, radians(90), radians(180));

  fill(250, 255, 0, cy);
  arc(400, 300, 370, 370, radians(180), radians(270));//random finger text

  fill(0);
  font = loadFont("Qubix-48.vlw");
  textFont (font, 90);
  text(fingers[whichFinger], 800, 180, 400, 400);

  //Line for seperating bottom part of scetch
  stroke(0);
  strokeWeight(8);
  line(0, 560, 1440, 560);

  if (gameDefault == true) {
    gameOver = false;
    P1Wins = false;
    P2Wins = false;
    savedTime2 = millis();
    movie1.stop();
    movie4.stop();
    movie5.stop();
    textFont (font, 65);
    text("WAITING FOR PLAYERS...", 250, 750);
  }

  if (gameStart == true) {
    gameDefault = false;
    int passedTime2 = millis() - savedTime2;

    if (playedStartMovie == false) {
      gameStartMovie();
    }

    if (passedTime2 > totalTime2) {
      movie2.stop();
      playedStartMovie = true;
      savedTime2 = millis();
    }
  }

  if (gameOver == true) {

    int passedTime = millis() - savedTime;

    fill(0);
    gameOverMovie();
    movie2.stop();

    if (passedTime > totalTime) {
      gameDefault = true;
      gameStart = false;
      gameOver = false;
      savedTime = millis();
      movie1.stop();
    }
  }
  
  if (P1Wins == true){
    player1Wins();
  }
  
  if (P2Wins == true){
    player2Wins();
  }
}

void keyPressed() {

  if (key == ENTER) {
    i = (int(random(colors.length)));
    whichFinger = int(random(fingers.length));
    println(i);

    if (i == 0) {
      cr = 255;
      cb = 25;
      cg = 25;
      cy = 25;
    }
    if (i == 1) {
      cb = 255;
      cg = 25;
      cy = 25;
      cr = 25;
    }
    if (i == 2) {
      cg = 255;
      cy = 25;
      cr = 25;
      cb = 25;
    }
    if (i == 3) {
      cy = 255;
      cr = 25;
      cb = 25;
      cg = 25;
    }
  }

  if (key == '1') {
    P1Wins = true;
    gameOver = false;
  }

  if (key == '2') {
    P2Wins = true;
    gameOver = false;
  }
}


//Incoming osc message are forwarded to the oscEvent method
void oscEvent(OscMessage theOscMessage) {
  //Print the address pattern and the typetag of the received OscMessage

  int twf = theOscMessage.get(0).intValue();

  savedTime = millis();
  
  //If this sketch receives "1" via OSC from TwistNRace sketch:
  if (twf == 1) {
    gameOver = true;
    gameStart = false;
  }

  //If this sketch receives "2" via OSC from TwistNRace sketch:
  if (twf == 2) {
    gameStart = true;
    playedStartMovie = false;
    gameDefault = false;
  }
}

void movieEvent(Movie m) {
  m.read();
}

void gameStartMovie() {
  movie2.loop();
  imageMode(CENTER);
  image(movie2, width/2, 700);
}

void gameOverMovie() {
  movie1.loop();
  imageMode(CENTER);
  image(movie1, width/2, 700);
}

void player1Wins() {
  gameStart = false;
  gameDefault = false;
  gameOver = false;
  movie4.loop();
  movie1.stop();
  imageMode(CENTER);
  image(movie4, width/2, 700);
}

void player2Wins() {
  gameStart = false;
  gameDefault = false;
  gameOver = false;
  movie5.loop();
  movie1.stop();
  imageMode(CENTER);
  image(movie5, width/2, 700);
}

//Built in to be able to hard-reset game to default
void mousePressed() {
  gameDefault = true;
  gameOver = false;
}

