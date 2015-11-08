abstract class PortView {
    float leftX = -1;
    float leftY = -1;
    float   w   = -1;
    float   h   = -1;
    
    Controller ctrl = null;
    String name = null;
    ArrayList<Datum> data = null;
  
    Datum mark = null;
  
    public abstract Datum hover();
    public abstract void display();
  
  
    PortView() {
    }

    PortView setController(Controller contrl) {
        this.ctrl = ctrl;
        return this;
    }

    PortView setMark(Datum d) {
        this.mark = d;
        return this;
    }

    PortView setName(String name) {
        this.name = name;
        return this;
    }

    PortView setData(ArrayList<Datum> d) {
       this.data = d;
       return this;
    }

    PortView setPosition(float x, float y) {
        this.leftX = x;
        this.leftY = y;
        return this;
    }

    PortView setSize(float w, float h) {
        this.w = w;
        this.h = h;
        return this;
    }

    //public void sendMsg(Message msg) {
    //    if(ctrl != null){
    //        ctrl.receiveMsg(msg);
    //    }
    //}
    
    public boolean isOnMe() {
        return mouseX >= leftX && mouseX <= (leftX + w) && mouseY >= leftY && mouseY <= (leftY + h);
    }
    
   public float computeTotalValue(ArrayList<Datum> a) {
     float sum = 0;
     for (Datum currData : a) {
       sum += currData.total;
     }
     return sum;
   }
   
   void drawBox() {
        stroke(100);
        strokeWeight(3);
        fill(255);
        rectMode(CORNER);
        rect(leftX+(BORDER/2), leftY+(BORDER/2), w-BORDER, h-BORDER);
   }

  
  
}