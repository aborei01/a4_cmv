class PieView extends PortView {

 private float PIE_PADDING = 0.8;
  
 private float x_origin, y_origin;
 private float radius;
 
 private ArrayList<Datum> d_collapsed;
 private ArrayList<Datum> arr;
  
 PieView() {}
 
 public void init() {
    setPieSize();
    setPieOrigin();
    collapseLocal();
    sortData();
 }
 
 public void collapseLocal() {
    d_collapsed = collapseByDiscipline();
 }
  
 public void setPieOrigin() {
   x_origin = leftX + (w / 2);
   y_origin = leftY + (h / 2);
 }
 
 public void sortData() {
   arr = sortByDiscipline();
 }
  
 public void setPieSize() {
   radius = (w > h ? (h * PIE_PADDING) : (w * PIE_PADDING));
 }
 
 public void display() {
   drawBox();
   
   /* Compute values in current scope and draw */
   double total = computeTotalValue(arr);
  
   drawPie(arr, total);
   
 }
 
 public Datum hover() {
   
   int hoveringIndex = isHovering(arr);
   
   Datum highlighted = new Datum();
   
   if (hoveringIndex >= 0) {
     Datum hoveringSection = arr.get(hoveringIndex);
     highlighted = new Datum(hoveringSection.discipline,
                                 null, null, -1, -1);
   }

   return highlighted;
   
 }

 private int isHovering(ArrayList<Datum> a) {
   
   float distance = dist(mouseX, mouseY, x_origin, y_origin);
   boolean inRadius = (distance < radius/2);
   
   if (inRadius) {
   
     float temp = 0.0;
     float totalVal = computeTotalValue(a);
     float TwoPi = 2*PI;
     float theta = 0.0;
     float new_x = mouseX - x_origin;
     float new_y = y_origin - mouseY;
     float r = (new_y / new_x);
     
     for (int i = 0; i < a.size(); i++) {
       Datum d = a.get(i);
       float ratio = ((d.total / totalVal) * TwoPi);
       
       if (new_x  < 0.0) {
         theta = atan(r) + PI;
       } else {
         theta = atan(r);
       }
       
       if (theta < 0.0) {
         theta += (2*PI);
       }
       float newTemp = temp + ratio;
       if (theta < (TwoPi - temp) && theta > (TwoPi - newTemp)) {
         return i;
       }
       temp = newTemp;
     }
   }
   return -1;
 }
 
 private void drawPie(ArrayList<Datum> d, double total) {
   
   float tmp_pos = 0.0;
   float TwoPi = 2.0*PI;
   
   int hoveringIndex = isHovering(d);
   
   String highlightedName = "";
   
   if (hoveringIndex >= 0) {
     Datum highlighted = d.get(hoveringIndex);
     highlightedName = highlighted.discipline;
   }
   
   for (int i = 0; i < d.size(); i++) {
          
       Datum currDatum = d.get(i);
       
       float value = (float) currDatum.total;
       float ratio = (float) ((value / total) * TwoPi);
       
       int pos = 0;
       
       for (int j = 0; j < d.size(); j++) {
         
         Datum tempDatum = d.get(j);
         
         if (currDatum.discipline.equals(tempDatum.discipline)) {
           pos = j;
           break;
         }
         
       }
       
       if (currDatum.discipline.equals(highlightedName) || mark.sharesPartOf(currDatum)) {
         fill(255, 0, 0);
       } else {
         fill(((pos + 1) * 50) % 255, ((pos + 2) * 40) % 255, ((pos + 3) * 30) % 255);
       }

       arc(x_origin, y_origin, radius, radius, tmp_pos, tmp_pos + ratio);
       tmp_pos += ratio;
       
     }
     
 }
 
 public int compare(String s1, String s2) {
   return s1.compareToIgnoreCase(s2);
 }
 
 private ArrayList<Datum> sortByDiscipline() {
   
   ArrayList<Datum> temp = new ArrayList<Datum>();
   
   for (Datum d : data) {
     temp.add(d);
   }
   
   for (int i = 0; i < temp.size(); i++) {
     int min = findMinIndex(temp, i);
     swap(temp, i, min);
   }
   
   return temp;
   
 }
 
 private void swap(ArrayList<Datum> a, int i, int j) {
   Datum temp = a.get(i);
   a.set(i, a.get(j));
   a.set(j, temp);
 }
  
 private int findMinIndex(ArrayList<Datum> a, int left) {
   
   int minIndex = left;
   
   for (int i = left; i < a.size(); i++) {
     
     Datum min  = a.get(minIndex);
     Datum curr = a.get(i);
     
     if (compare(curr.discipline, min.discipline) < 0) {
       minIndex = i;
     }
   }
   
   return minIndex;
 }
 
 private void shiftRightFromIndex(ArrayList<Datum> a, int index) {
   for (int i = a.size(); i > index; i--) {
     Datum temp = a.get(i - 1);
     a.add(i, temp);
   }
 }
 
 /* "data" is global here */
 private ArrayList<Datum> collapseByDiscipline() {
  
  ArrayList<Datum> temp = new ArrayList<Datum>();
  
  for (Datum d1 : data) {
    
    String dis1 = d1.discipline;
    float tempVal = 0.0;
    
    for (int i = 0; i < temp.size(); i++) {
      
      Datum d2 = temp.get(i);
      
      String dis2 = d2.discipline;
      
      if (dis1.equals(dis2)) {
         tempVal = d2.total;
         temp.remove(i);
         break;
       }
       
     }
       
     float newTotal = d1.total + tempVal;  
     
     Datum toAdd = new Datum(d1.discipline, 
                             d1.department, 
                             d1.sponsor,
                             d1.year,
                             newTotal);

     temp.add(toAdd);
    
  }
  
  return temp;
  
 }
  

 
}