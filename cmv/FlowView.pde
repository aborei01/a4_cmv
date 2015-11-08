class FlowView extends PortView {

  float squaresHeight = 100;
  float squaresWidth;
  
  ArrayList<Datum> bySponsorAndDept = null;
  ArrayList<Datum> bySponsor = null;
  ArrayList<Datum> byDept    = null;
  color[] sponsColors    = null;
  color[] deptColors     = null;
  
  ArrayList<Tuple> sponsTuples = null;
  ArrayList<Tuple> deptTuples  = null;
  
  float total_funding;
  

  void init() {
    total_funding = computeTotalValue(data);
    bySponsor = sortBySponsor();
    byDept = sortByDepartment();
    squaresWidth = w - BORDER;
    setCoordinates();
    setColors();
  }
  
  void setColors() {
    
     sponsColors = new color[bySponsor.size()];
     deptColors  = new color[bySponsor.size()];
     int fill = 0;
     color c = color(((fill + 1) * 50) % 255, ((fill + 2) * 40) % 255, ((fill + 3) * 30) % 255);
     String lastSponsor = bySponsor.get(0).sponsor;
     String lastDept = byDept.get(0).department;

     for(int i = 0; i < bySponsor.size(); i++) {
          Datum d = bySponsor.get(i);
          if (! d.sponsor.equals(lastSponsor)) {
              fill++;
              c = color(((fill + 1) * 50) % 255, ((fill + 2) * 40) % 255, ((fill + 3) * 30) % 255);
              sponsColors[i] = c;
              lastSponsor = d.sponsor; 
          } else sponsColors[i] = c;
      } fill++;
      
      for(int i = 0; i < byDept.size(); i++) {
        
          Datum d = byDept.get(i);
          
          println(d.department + " size is " + byDept.size());
          
          if (! d.department.equals(lastDept)) {
              fill++;
              c = color(((fill + 1) * 50) % 255, ((fill + 2) * 40) % 255, ((fill + 3) * 30) % 255);
              deptColors[i] = c;
              lastDept = d.department; 
          } else deptColors[i] = c;
          
      }
  }
  
  void setCoordinates() {
      sponsTuples = new ArrayList<Tuple>();
      deptTuples  = new ArrayList<Tuple>();
      
      float deptCornerX = leftX + BORDER;
      float sponsCornerX = leftX + BORDER;
      float rWidth = 0;
      
      for(int i = 0; i < byDept.size(); i++){
           Datum d = byDept.get(i);
           Datum s = bySponsor.get(i);
           
           Tuple dt = new Tuple();
           deptTuples.add(dt);
           deptTuples.get(i).setA(deptCornerX);
           rWidth = (d.total / total_funding) * squaresWidth;
           deptCornerX += rWidth;
           deptTuples.get(i).setB(deptCornerX);
  
           Tuple st = new Tuple();      
           sponsTuples.add(st);
           sponsTuples.get(i).setA(sponsCornerX);
           rWidth = (s.total / total_funding) * squaresWidth;
           sponsCornerX += rWidth;
           sponsTuples.get(i).setB(sponsCornerX);
      }
  }
      

  
  void display() {
     float rWidth = 0;
     float upperY = leftY + BORDER;
     float lowerY = h - BORDER - squaresHeight; 

     drawBox();

     for(int i = 0; i < bySponsor.size(); i++) {
         Datum s = bySponsor.get(i);
         Datum d = byDept.get(i);
             
             if (mark.sharesPartOf(s)) {
                 stroke(255, 0, 0);
                 fill(255, 0, 0);
              } else {
                 stroke(sponsColors[i]);
                 fill(sponsColors[i]);
              }
              
              rWidth = sponsTuples.get(i).b - sponsTuples.get(i).a;
              rect(sponsTuples.get(i).a, upperY, rWidth, squaresHeight);
              
              if(mark.sharesPartOf(d)) {
                 stroke(255, 0, 0);
                 fill(255, 0, 0);
              } else {
                 stroke(deptColors[i]);
                 fill(deptColors[i]);  
              }
              rWidth = deptTuples.get(i).b - deptTuples.get(i).a;
              rect(deptTuples.get(i).a, lowerY, rWidth, squaresHeight); 
       }
       
     drawCurves();
  }


  /* Draw Beizer curves */  
  void drawCurves(){
     float sponsHeight = leftY + BORDER + squaresHeight;
     float deptHeight  = h - BORDER - squaresHeight;
     float c1, c2;
     for(int i = 0; i < bySponsor.size(); i++) {
        Datum sd = bySponsor.get(i);
        for(int j = 0; j < byDept.size(); j++) {
           Datum dd = byDept.get(j);
           if(sd.isEqualTo(dd)){
             
             float diff = sponsTuples.get(i).b - sponsTuples.get(i).a;
             
             noStroke();
             fill(sponsColors[i], 150);
             //fill(((i + 1) * 50) % 255, ((i + 2) * 40) % 255, ((i + 3) * 30) % 255);
             
             c1 = lerp(sponsTuples.get(i).b, deptTuples.get(j).b, (1/3));
             c2 = lerp(sponsTuples.get(i).b, deptTuples.get(j).b, (2/3));
             beginShape();
             vertex(sponsTuples.get(i).a, sponsHeight);
             vertex(sponsTuples.get(i).b, sponsHeight);
             bezierVertex(c1, 500.0, c2, 400.0, deptTuples.get(j).b, deptHeight);
             vertex(deptTuples.get(j).a, deptHeight);
             bezierVertex(c1-diff, 500.0, c2-diff, 400.0, sponsTuples.get(i).a, sponsHeight);
             endShape(CLOSE);
           } 
        }
     }
         
    
  }
  
  
  public Datum hover() {
      Datum m = new Datum();
    
      int sIndex = highlightingSponsors();
      int dIndex = highlightingDept();
    
      if (sIndex >= 0) {
          Datum hovering = bySponsor.get(sIndex);
          m = new Datum(null, null, hovering.sponsor, -1, -1);
      }
      
      else if (dIndex >= 0) {
          Datum hovering = byDept.get(dIndex);
          m = new Datum(null, hovering.department, null, -1, -1);
      }
      
    return m;
  }
  
  int highlightingSponsors() {
     int index = -1;
     for (int i = 0; i < sponsTuples.size(); i++) {
         if (mouseX > sponsTuples.get(i).a &&
             mouseX < sponsTuples.get(i).b &&
             mouseY > BORDER &&
             mouseY < BORDER + squaresHeight) {
               index = i;
               break;
         }
     }
     return index;
  }
  
  int highlightingDept() {
     int index = -1;
     for (int i = 0; i < deptTuples.size(); i++) {
         if (mouseX > deptTuples.get(i).a &&
             mouseX < deptTuples.get(i).b &&
             mouseY < h - BORDER &&
             mouseY > h - BORDER - squaresHeight) {
               index = i;
               break;
         }
     }
     return index;
  }
  
  // Sorting 
  // NEEDS WORK : STABLE SORT? WHAT TO DO 
  public int compare(String s1, String s2) {
    return s1.compareToIgnoreCase(s2);
  }
 
  private ArrayList<Datum> sortBySponsor() {
   ArrayList<Datum> temp = new ArrayList<Datum>();
   for (Datum d : data) {
     temp.add(d);
   }
   
   for (int i = 1; i < temp.size(); i++) {
     for (int j = i; j > 0; j--) {
       if (compare(temp.get(j).sponsor, temp.get(j - 1).sponsor) >= 0) {
         break;
       } else {
         swap(temp, j, (j - 1));
       }
     }
   }
   
   return temp;
 }
 
 private void swap(ArrayList<Datum> a, int i, int j) {
   Datum temp = a.get(i);
   a.set(i, a.get(j));
   a.set(j, temp);
 }
 
 private ArrayList<Datum> sortByDepartment() {
   
   ArrayList<Datum> temp = new ArrayList<Datum>();
   for (Datum d : bySponsor) {
     temp.add(d);
   }
   
   for (int i = 1; i < temp.size(); i++) {
     for (int j = i; j > 0; j--) {
       if (compare(temp.get(j).department, temp.get(j - 1).department) >= 0) {
         break;
       } else {
         swap(temp, j, (j - 1));
       }
     }
   }
   return temp;
   
 }

}