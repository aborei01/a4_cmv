class LineView extends PortView {
    
    /*points for the coordinates*/ 
    FloatList xCoords  = null;
    FloatList yCoords = null;
    
    FloatList years = null;
    FloatList totals = null;
    
    /*drawing the axes*/
    float x_end = -1;
    float y_end = -1;
    float x_origin = -1;
    float y_origin = -1;
    
    int diameter = 10;
    float interval = -1;
    
    
    Datum hover() {
        Datum m = new Datum();
        for(int i = 0; i < xCoords.size(); i++) {
            if(isHovering(i)) {
                m.year = int(years.get(i));
            }
      } 
      return m; 
    }
    
    
    boolean isHovering(int i) {
        return (diameter >= dist(mouseX, mouseY, xCoords.get(i), yCoords.get(i)));
    }
    
    void setAxes() {
      x_origin = (1.0/10.0)*w + leftX;
      y_origin = (9.0/10.0)*h + leftY;
      
      x_end = (9.0/10.0)*w + leftX;
      y_end = (1.0/10.0)*h + leftY;
    }
    
   /* * *  FUNCTIONS TO INITIALIZE THE LINE GRAPH * * */
    
    void init() {
        setAxes();
        setDataLists();
        setInterval();
        setCoords();
    }
     
    void setCoords() {
        float yLength = y_origin - y_end;
       
        xCoords = new FloatList();
        yCoords = new FloatList();
       
        float max_total = totals.get(0);
        for(float t : totals){
            if(max_total < t) max_total = t;
        }
       
        for(int i = totals.size() - 1; i >= 0; i--) {
            float y = y_origin - ((totals.get(i)/max_total) * yLength);
            yCoords.append(y);
            xCoords.append(x_origin + (interval*i));
        }
    }
         
    void setDataLists() {
        int index;
       
        years = new FloatList();
        totals = new FloatList();
        for(Datum d : data){
            if(!years.hasValue(d.year)){
                years.append(float(d.year));
                totals.append(d.total);
            } if(years.hasValue(d.year)) {
                index = indexOf(years, d.year);
                totals.add(index, d.total);
            }
         }
     }
  

     void setInterval() {
       interval = (x_end - x_origin) / float(years.size());
     }
    
    
     int indexOf(FloatList list, int x) {
         for(int i = 0; i < list.size(); i++) {
             if (list.get(i) == x) return i;
         } return -1;
     }
    
    
    
    
  /* * *  FUNCTIONS TO DISPLAY THE LINE GRAPH * * */
    
    void display() {
        drawBox();
        drawAxes();
        drawGraph();
    }
    
    void drawAxes(){
        stroke(0);
        strokeWeight(1);
        /* draw the axes */
        fill(0);
        line(x_origin, y_origin, x_origin, y_end);
        line(x_origin, y_origin, x_end, y_origin);
    }
    
    void drawGraph(){
        for(int i = 0; i < xCoords.size(); i++) {
            fill(0);
            stroke(0);
            strokeWeight(1);
            float x = xCoords.get(i);
            /* draw the points and connecting lines */
            if(i < xCoords.size() - 1) 
            line(x, yCoords.get(i), xCoords.get(i+1), yCoords.get(i+1));
          
            if (isHovering(i)) fill(255, 0, 0);
            ellipse(x, yCoords.get(i), diameter, diameter);

            /* draw the dash on the axis */
            line(x, y_origin, x, y_origin + 5);
            /* draw the dash label */
            textAlign(CENTER);
            textSize(10);
            text(int(years.get(i)), x, y_origin + 20);
            
            
            
        }  
    }
  
  
}