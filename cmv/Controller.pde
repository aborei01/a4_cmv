import java.util.Iterator;
import java.lang.Iterable;

class Controller {
    ArrayList <PortView> views = null;

    Controller() {
        views = new ArrayList <PortView> ();
    }

    void hover() {
        for (PortView v: views) {
            if (v.isOnMe()) {
                Datum m = v.hover();
                for (PortView view : views) {
                  view.setMark(m);
                }
                break;
            }
        }
    }

    void drawViews() {
        for (PortView v: views) {
            v.display();
        }
    }


    public void resetMark() {
        // marks are global
        mark = new Datum();
    }

    //public void setMarksOfViews(){
    //    for (PortView v: views) {
    //        v.setMarks(marks);
    //    }
    //}
    
    
    
    void initViews(ArrayList<Datum> d) {
        PieView pv = new PieView();
        pv
            .setController(this)
            .setName("Pie")
            /*Bottom right corner */
            .setPosition((4*width/5), 0)
            .setSize(width/5, height/2)
            .setMark(mark)
            .setData(d)
            ;
        pv.init();
            
        
        LineView lv = new LineView();
        lv
            .setController(this)
            .setName("Line")
            /* upper right corner */
            .setPosition((4*width/5), height/2)
            .setSize((width/5), height/2)
            .setMark(mark)
            .setData(d)
            ;
        lv.init();
        //println("leftX = "+lv.leftX+" leftY = "+lv.leftY);
        //println("width = "+lv.w+" height = "+lv.h);
        //lv.setXYIndices();
            
        FlowView fv = new FlowView();
        fv
            .setController(this)
            .setName("Flow")
            /*Bottom right corner */
            .setPosition(0, 0)
            .setSize((4*width/5), height)
            .setMark(mark)
            .setData(d)
            ;
        fv.init();
        
        
        views.add(pv);
        views.add(lv);
        views.add(fv);
    }
      
    
    
}