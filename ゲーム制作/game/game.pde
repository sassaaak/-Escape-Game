import processing.sound.*;

PFont myFont;
PImage doorImg, wallImg, clockImg, keyImg, senImg, reiImg, tansuImg, takaraImg, driImg, tonImg;
SoundFile glassSound, incorrSound, switchSound, dropSound;
Item door, clock, theKey, sen, rei, tansu, takara, driver, tonkachi;
Inventory inventory = new Inventory();
boolean solvedFlg = false;
boolean searchFlg = false;
boolean searchFlg2 = false;
boolean searchFlg3 = false;
boolean keyFlg = false;
boolean tonkachiFlg = false;
boolean driFlg = false;
boolean dri2Flg = false;
boolean tonFlg = false;
String message = "";

void setup() {
  size(480, 480);
  background(255, 255, 255);
  fill(0, 0, 0);
  noStroke();
  frameRate(40);
  myFont = createFont("YuGothic", 24, true);
  textFont(myFont);

  doorImg  = loadImage("window.png");
  wallImg = loadImage("haikei.jpg");
  clockImg = loadImage("kakedokei.png");
  keyImg = loadImage("key.png");
  senImg = loadImage("sentakuki.png");
  reiImg = loadImage("reizouko.png");
  tansuImg= loadImage("tansu.png");
  takaraImg= loadImage("takarabako.png");
  driImg= loadImage("driver.png");
  tonImg= loadImage("tonkachi.png");
  glassSound = new SoundFile(this, "glass-break2.mp3");
  incorrSound = new SoundFile(this, "incorrect1.mp3");
  switchSound = new SoundFile(this, "switch1.mp3");
  dropSound = new SoundFile(this, "key-drop1.mp3");

  door = new Item(doorImg, 100, 150, 0.18);
  clock = new Item(clockImg, 320, 100, 0.15);
  theKey = new Item(keyImg, 350, 250, 0.14);
  sen = new Item(senImg, 370, 370, 0.14);
  rei =new Item(reiImg, 20, 340, 0.18);
  tansu =new Item(tansuImg, 130, 370, 0.14);
  takara =new Item(takaraImg, 250, 410, 0.18);
  driver =new Item(driImg, 230, 400, 0.1);
  tonkachi =new Item(tonImg, 330, 410, 0.1);
}

void draw() {
  background(0);
  image(wallImg, 0, 0, 480, 480);
  door.draw();
  clock.draw();
  sen.draw();
  rei.draw();
  tansu.draw();
  takara.draw();
  fill(0);

  inventory.draw();

  if (searchFlg) {
    driver.draw();
  }
  if (searchFlg2) {
    theKey.draw();
  }
  if (searchFlg3) {
    tonkachi.draw();
  }


  if (solvedFlg) {
    fill(0);
    textSize(48);
    text("CLEAR!", 100, 240);
  }
  text(message, 10, 475);
}



void mousePressed() {
  message = "";
  if (solvedFlg) {
    return;
  }

  if (tansu.isIn(mouseX, mouseY)) {
    if (!driFlg &&  !dri2Flg) {
      searchFlg = true;
      dropSound.play();
      message = "ドライバーが出てきた";
    }
  }

  if (tansu.isIn(mouseX, mouseY)) {
    if (!searchFlg && driFlg) {
      message = "タンスには何もない";
    }
  }

  if (driver.isIn(mouseX, mouseY)) {
    if (searchFlg && !driFlg && !dri2Flg) {
      driFlg = true;
      searchFlg = false;
      inventory.put(driver);
      switchSound.play();
      message = "ドライバーをゲットした";
    }
  }



  if (clock.isIn(mouseX, mouseY)) {
    if (driFlg) {
      searchFlg2 = true;
      driFlg = false;
      dri2Flg = true;
      dropSound.play();
      message = "何かおちたぞー！";
    }
    if (!driFlg && !searchFlg2) {
      message = "ドライバーがあれば開けられそうだ";
    }

    if (!driFlg && keyFlg) {
      message = "何もなさそうだ";
    }
  }





  if (theKey.isIn(mouseX, mouseY)) {
    if (searchFlg2) {
      keyFlg = true;
      searchFlg2 = false;
      inventory.put(theKey);
      switchSound.play();
      message = "鍵を見つけた";
    }
  }

  if (takara.isIn(mouseX, mouseY)) {
    if (keyFlg && !tonFlg) {
      searchFlg3 = true;
      dropSound.play();
      message = "トンカチが出てきた";
    }
  }

  if (tonkachi.isIn(mouseX, mouseY)) {
    if (searchFlg3) {
      tonFlg = true;
      searchFlg3 = false;
      inventory.put(tonkachi);
      switchSound.play();
      message = "窓を壊して脱出";
    }
  }


  if (door.isIn(mouseX, mouseY)) {
    if (tonFlg) {
      glassSound.play();
      message = "CLEAR";
    }

    if (!tonFlg) {
      message = "鍵がかかっているよ";
    }
  }

  if (sen.isIn(mouseX, mouseY)) {
    incorrSound.play();
    message = "何も無いようだ";
  }
  if (rei.isIn(mouseX, mouseY)) {
    incorrSound.play();
    message = "食材しか入っていない";
  }
}






class Item {
  PImage img;
  int xpos;
  int ypos;
  float scale;

  Item(PImage _img, int _xpos, int _ypos, float _scale) {
    img = _img;
    xpos = _xpos;
    ypos = _ypos;
    scale = _scale;
  }

  void draw() {
    float imgWidth = img.width * scale;
    float imgHeight = img.height * scale;
    image(img, xpos, ypos, imgWidth, imgHeight);
  }


  boolean isIn(int x, int y) {
    if (x >= xpos && x <= xpos + img.width * scale &&
      y >= ypos && y <= ypos + img.height * scale) {
      return true;
    } else {
      return false;
    }
  }
}

class Inventory {
  int itemMax = 3;
  Item[] items = new Item[itemMax];
  int found = 0;

  void put(Item i) {
    if (found < itemMax) {
      items[found] = i;
      found++;
    }
  }

  void draw() {
    fill(0);
    stroke(255, 215, 0);
    strokeWeight(2);
    for (int i = 0; i < itemMax; i++) {
      rect(i * 30 + 20, 20, 30, 30);
      if (items[i] != null) {
        image(items[i].img, i * 30 + 20, 20, 28, 28);
      }
    }
  }
}
