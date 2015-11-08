String path = "soe-funding.csv";
ArrayList<Datum> data;
Controller ctrl = null;
//Datum mark = null;
float BORDER = 4;

/* TODO: Insert MVC classes here */

void settings() {
  //fullScreen();
  size(1500, 900);
}

void setup() {

  surface.setResizable(true);
  parse();
  
  Datum mark = new Datum();
  ctrl = new Controller();
  ctrl.initViews(data, mark);
}

void draw(){
  background(255);
  ctrl.hover();
  ctrl.drawViews(); 

}

void mouseClicked(){
  
}







/**********************/
/* FUNCTIONS TO PARSE */

void parse() {
  
  data = new ArrayList<Datum>();

  String lines[] = loadStrings(path);
  String categories[] = split(lines[0], ",");

  for (int i = 1; i < lines.length; i++) {
    String row[] = split(lines[i], ",");
    Datum d = new Datum(row[0], row[1], row[2], row[3], row[4]);
    data.add(d);
  }
  collapseData();
}

/* Sum total values of sponsors within single year */
void collapseData() {
  
  ArrayList<Datum> temp = new ArrayList<Datum>();
  
  for (Datum d1 : data) {
    
    Datum row = null;
    
    for (Datum d2 : temp) {
      if (matchDataRow(d1, d2)) {
         row = d2;
         temp.remove(d2);
         break;
       }
     }
     if (row != null) {
       d1.total = row.total + d1.total;
     }
     temp.add(d1); 
  }
  data = temp;
}

boolean hasDataRow(ArrayList<Datum> arr, Datum row) {
  boolean match = false;
  
  for (Datum d : arr) {
    match = match | matchDataRow(d, row);
  }
  return match;
}

boolean matchDataRow(Datum row1, Datum row2) {
  return ((row1.discipline.equals(row2.discipline)) &&
          (row1.department.equals(row2.department)) &&
          (row1.sponsor.equals(row2.sponsor))       &&
          (row1.year       == row2.year));
}

/*********** END OF PARSE FUNCTIONS ****************/