public class MenuButton {
  private float x, y, w, h; // Physical properties
  private PImage normalImage, pressedImage;
  private boolean hover; // Physical states

  public MenuButton(float argx, float argy, float argw, float argh) {
    x = argx;
    y = argy;
    w = argw;
    h = argh;
  }

  public void setImages(PImage argNormalImage, PImage argPressedImage) {
    normalImage = argNormalImage;
    pressedImage = argPressedImage;
  }

  public boolean check() {
    if(x - w/2 <= mouseX && mouseX <= x + w/2 && y - h/2 <= mouseY && mouseY <= y + h/2) {
      hover = true; 
    }
    else {
      hover = false;
    }

    if(hover) {
      if(mouseClicked) {
        return true;
      }
    }
    return false;
  }

  public void show() {
    imageMode(CENTER);
    if(hover) {
      image(pressedImage, x, y, w, h);
    }
    else {
      image(normalImage, x, y, w, h);
    }
    imageMode(CORNER);
  }
}
