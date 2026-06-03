include <Springs.scad>      // Dibujo de resortes ==> Autor: Rudolf Huttary (https://www.thingiverse.com/thing:648813)

$fn=100;
delta=0.1;
grosor=1.5;

diam_tornillos=3;

// Dimensiones de las grapas
longitud_grapa=11.8;    // largo interior entre patas
calibre_grapa=1;        // grosor del alambre

// Dimensiones de la arandela
diamext_arandela=8;     // diametro exterior
diamint_arandela=3;     // diametro interior
calibre_arandela=1.0;   // grosor

// Dimensiones del resorte
diam_interior_resorte=2.4;                                          // diametro interior del resorte
diam_exterior_resorte=3.45;                                         // diametro exterior del resorte
calibre_resorte=(diam_exterior_resorte-diam_interior_resorte)/2;    // grosor
largo_max_resorte=13;                                               // longitud del resorte sin comprimir
largo_min_resorte=6.5;                                              // longitud del resorte comprimido al máximo
largo_util_resorte=11;                                              // longitud del resorte comprimido hasta el punto de uso

calibre_bastago=diam_interior_resorte-3*delta;     // grosor (debe ser < diamint_arandela y < diam_interior_resorte)
largo_cruceta_bastago=diamext_arandela;

// Dimensiones de la carcasa del pushbutton
dimx=grosor+largo_util_resorte+calibre_grapa+calibre_bastago+grosor;
dimy=longitud_grapa+2*calibre_grapa;
dimz=diamext_arandela+2*grosor;

// Dimensiones del bastago
largo_extra_delantero=5;
largo_extra_trasero=1.5;
largo_tramo1_bastago=grosor+largo_util_resorte+largo_extra_trasero;
largo_tramo2_bastago=dimx+3*grosor+largo_extra_delantero-(grosor+largo_min_resorte+calibre_bastago);
largo_bastago=largo_tramo1_bastago+calibre_bastago+largo_tramo2_bastago;

////////////////////////////////////////////////////////////////

//ensamblar();
imprimir();

module imprimir()
{
    translate([dimz,0,0]) rotate([0,-90,0]) carcasa();
    translate([0,dimy+20,delta+calibre_bastago/2]) bastago();
    translate([0,dimy+40,0]) tapa_delantera();
}

module ensamblar()
{
    dibujo_artistico_NO_PULSADO();
    translate([50,0,0]) dibujo_artistico_PULSADO();
}

module dibujo_artistico_NO_PULSADO()
{
    dibujo_artistico(largo_util_resorte);
}

module dibujo_artistico_PULSADO()
{
    dibujo_artistico(largo_min_resorte);
}

module dibujo_artistico(largo)
{
    #carcasa();
    translate([grosor,dimy/2,dimz/2]) resorte(largo);
    
    pos_arandela=grosor+largo+calibre_bastago;
    
    translate([pos_arandela,dimy/2,dimz/2]) rotate([0,90,0]) arandela(diamext_arandela,diamint_arandela,calibre_arandela);
    
    color("red") translate([(pos_arandela-(largo_tramo1_bastago+calibre_bastago)),dimy/2,dimz/2]) bastago();
    
    translate([dimx+2*grosor+delta/2,0,grosor]) rotate([0,-90,0]) tapa_delantera();
}


module carcasa()
{
    union() {
        difference() {
            cube([dimx,dimy,dimz]);
            union() {
                translate([grosor+largo_min_resorte,-delta,grosor]) cube([dimx,dimy+2*delta,dimz-2*grosor]);
                translate([-delta,dimy/2,dimz/2]) rotate([0,90,0]) cylinder(d=diamint_arandela,h=dimx+2*delta);
                #translate([grosor,dimy/2,dimz/2]) rotate([0,90,0]) cylinder(d=diam_exterior_resorte+2*calibre_resorte,h=largo_min_resorte+2*delta);
                
                // muescas para las grapas (contactos NO)
                muescas(grosor+largo_min_resorte+calibre_bastago-calibre_grapa);
                // muescas para las grapas (contactos NC)
                muescas(grosor+largo_util_resorte+calibre_bastago+calibre_arandela);
            }
        }
        
        // El enganche para la tapa delantera
        translate([dimx,0,0]) union() {
           enganche();
           translate([0,dimy,dimz]) rotate([180,0,0]) enganche();
        }
        
        // El soporte para los tornillos
        translate([0,0,-(diam_tornillos+2*grosor)]) {
            rotate([90,0,0]) soporte_tornillos();
            //translate([0,dimy+2*grosor,0]) rotate([90,0,0]) soporte_tornillos();
        }
    }
}

module enganche()
{
    translate([0,0,grosor]) cube([grosor,dimy,grosor/2]);
    translate([0,0,0]) cube([3*grosor+delta,dimy,grosor]);
    translate([2*grosor+delta,dimy,grosor]) rotate([90,0,0]) linear_extrude(height=dimy,center=false,slices=0,scale=1,convexity=10,twist=0)
        polygon(points=[[0,0],[0,grosor],[grosor,0]]);
}

module soporte_tornillos()
{
    diamext=diam_tornillos+2*grosor;
    difference() {
        union() {
            color("red") translate([0,diamext/2,0]) cube([grosor+largo_min_resorte,dimz+diamext,2*grosor]);
            translate([diamext/2,diamext/2,0]) cylinder(d=diam_tornillos+2*grosor,h=2*grosor);
            translate([diamext/2,dimz+3*diamext/2,0]) cylinder(d=diam_tornillos+2*grosor,h=2*grosor);
        }
        translate([diamext/2,diamext/2,-delta]) cylinder(d=diam_tornillos,h=2*(grosor+delta));
        translate([diamext/2,dimz+3*diamext/2,-delta]) cylinder(d=diam_tornillos,h=2*(grosor+delta));
    }
}

// Muescas para colocar las grapas
module muescas(posx)
{
    union() {
        translate([posx,-delta,-delta]) cube([calibre_grapa,calibre_grapa+delta,grosor+delta*2]);
        translate([posx,dimy-calibre_grapa,-delta]) cube([calibre_grapa,calibre_grapa+delta,grosor+delta*2]);
        translate([posx,-delta,dimz-grosor-delta]) cube([calibre_grapa,calibre_grapa+delta,grosor+delta*2]);
        translate([posx,dimy-calibre_grapa,dimz-grosor-delta]) cube([calibre_grapa,calibre_grapa+delta,grosor+delta*2]);
    }
}


module resorte(largo)
{
    rotate([0,90,0]) spring(Windings = 4, R = diam_exterior_resorte/2, r = calibre_resorte, h = largo);
}

module arandela(de=8,di=3,c=1.0)
{
    difference() {
        cylinder(d=de,h=c);
        translate([0,0,-delta]) cylinder(d=di,h=c+2*delta);
    }
}

module bastago()
{
    translate([0,-calibre_bastago/2,-calibre_bastago/2]) union() {
        cube([largo_bastago,calibre_bastago,calibre_bastago]);
        translate([largo_tramo1_bastago,(calibre_bastago-largo_cruceta_bastago)/2,0])
            cube([calibre_bastago,largo_cruceta_bastago,calibre_bastago]);
    }
}

module tapa_delantera()
{
    difference() {
        cube([dimz-2*grosor,dimy,grosor]);
        translate([(dimz/2)-grosor,dimy/2,-delta]) cylinder(d=diamint_arandela,h=2*delta+grosor);
    }
}
