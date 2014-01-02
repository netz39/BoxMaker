module ausschnitt(l,r,t) {
  translate([l/2,0,-1])
    cylinder(h=t+2, r=r);
  translate([-l/2,0,-1])
    cylinder(h=t+2, r=r);
  translate([-l/2,-r,-1])
    cube([l, 2*r, t+2]);
}

// al - ausschnitt-laenge
// aa -ausschnitt-abstand
module reihe(l,t, al=15, aa=10, f="innen") {
    as=al+aa;
    
    //anzahl ausschnitte berechnen
    n = floor((l-2*t)/as);
    
    // länge aller ausschnitte
    laa = n*as-aa;
    
    // versatz
    v = (l-laa)/2;
    
    if (f == "innen") {
      for ( i = [0 : as : laa]) {
	translate([i+v, 0, -1])
	    cube(size=[al,t,t+2]);
      }
    }
    
    if (f == "aussen") {
      difference() {
	translate([0, 0, -1])
	  cube([l,t+1,t+2]);
	for ( i = [0 : as : laa]) {
	  translate([i+v, 0, -1])
	      cube(size=[al,t,t+2]);
	}
      }
    }

    for ( i = [0 : as : laa]) {
      translate([i+v, 0, 0])
	union() {
	  translate([0,1,-1])
	    cylinder(h=t+2, r=1);
	  translate([al,1,-1])
	    cylinder(h=t+2, r=1);
	}
    }

}

module boden(l, b, t) {
  difference() {
    cube(size=[l,b,t]);
    
    // eine reihe ausschnitte
    translate([2*t,b-t,0])
      reihe(l-4*t,t, f="innen");
    
    rotate([0,0,90])
    translate([2*t,-t,0])
      reihe(b-4*t,t, f="innen");

    rotate([0,0,180])
    translate([-l+2*t,-t,0])
      reihe(l-4*t,t, f="innen");

    rotate([0,0,270])
    translate([-b+2*t,l-t,0])
      reihe(b-4*t,t, f="innen");
  }
}

module wand(l, h, t, ausschnitt="false") {
  difference() {
    cube(size=[l,h,t]);

    // boden
    rotate([0,0,180])
    translate([-l+2*t,-t,0])
      reihe(l-4*t,t, f="aussen");
    translate([0,0,-1])
      cube([4*t, t, t+2]); 
    translate([l-4*t,0,-1])
      cube([4*t, t, t+2]); 

    // waende
    
    rotate([0,0,90])
    translate([t,-t,0])
      reihe(h,t, f="aussen");

    rotate([0,0,270])
    translate([-h-t,l-t,0])
      reihe(h,t, f="innen");
      
    if (ausschnitt=="true") {
      translate([l/2, h-40, 0])
	ausschnitt(30,10,t);
    }  
  }
}


// l - Lange
// b - Breite
// h - hoehe
// t - thickness (Materialdicke)
// d - distance (Abstand zw. Werkstücken)
module box(l,b,h,t=5, d=10) {
  //rotate([0,0,0])
  boden(l,b,t);

  rotate([0,0,0])
  translate([0,b+d,0])
    wand(l,h,t);

  rotate([0,0,0])
  translate([l+d,b+d,0])
    wand(b,h,t, ausschnitt="false");

  rotate([0,0,180])
  translate([-l,d,0])
   wand(l,h,t);

  rotate([0,0,0])
  translate([l+d,b-h,0])
    wand(b,h,t, ausschnitt="false");
}

//#cube([300,300,1]);

t=4;

projection(cut=true)
  translate([0,0,-t/2])
  box(115+2*t, 145+2*t, 45, t);

