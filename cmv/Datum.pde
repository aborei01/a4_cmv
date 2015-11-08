class Datum {

  public String discipline = null;
  public String department = null;
  public String sponsor    = null;
  public int    year  = -1;
  public float  total = -1;

  Datum(){
    
  }

  Datum(String _discipline, String _department, String _sponsor,
        String _year, String _total) {
        
          discipline = _discipline;
          department = _department;
          sponsor    = _sponsor;
          year       = Integer.parseInt(_year);
          total      = Float.parseFloat(_total);
       
        }
        
  Datum(String _discipline, String _department, String _sponsor,
        int _year, float _total) {
        
          discipline = _discipline;
          department = _department;
          sponsor    = _sponsor;
          year       = _year;
          total      = _total;
       
        }
        
  /* compares a complete datum (d2) to a not full datum (this) */    
  boolean isEqualTo(Datum d){
      return (this != null) &&
             (this.discipline == null || this.discipline.equals(d.discipline)) &&
             (this.department == null || this.department.equals(d.department)) &&
             (this.sponsor    == null || this.sponsor.   equals(d.sponsor)   ) &&
             (this.year       == -1   || this.year       ==     d.year       ) &&
             (this.total      == -1   || this.total      ==     d.total      );
  }
  
  boolean sharesPartOf(Datum d){
      return !isEmpty() && isEqualTo(d);
  }

  boolean isEmpty(){
      return (this.discipline == null) &&
             (this.department == null) &&
             (this.sponsor    == null) &&
             (this.year       == -1)   &&
             (this.total      == -1); 
  }

}