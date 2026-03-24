// Programme par pole-ergo : www.pole-ergo.fr Librement adapté d'exemples proposés par PRJC fabricant de Teensy
// Programme contacteur sur TEENSY 2.0 pour le contacteur proposé sur Thingiverse https://www.thingiverse.com/Pole_ergo/about
// Fonction : emulation des déplacements du pointeur de souris et du clic gauche.
// Installer puis Programmer votre Teensy : voir https://www.pjrc.com/teensy/first_use.html
// Utiliser l'environnement Arduino : voir https://www.arduino.cc/en/Guide/HomePage
// Ecrit et compilé sur IDE Arduino 1.8.5
// Librairies Teensy
// Type de carte : Teensy 2.0 - USB type : Keyboard + Mouse + Joystick - CPU speed : 16MHZ - Keyboard layout : français

//******************** Début de programme *****************************************************
#include <Bounce.h> //utilisation de la librairie Bounce : voir https://www.pjrc.com/teensy/td_libs_Bounce.html

Bounce clic = Bounce(PIN_D5, 10);
Bounce jack1 = Bounce(PIN_D1, 10);
Bounce jack2 = Bounce(PIN_D3, 10);
Bounce jack3 = Bounce(PIN_D4, 10);
Bounce jack4 = Bounce(PIN_D7, 10);

//VARIABLES
int xpos;
int ypos;


//********************** Définition des entrées/sorties du Teensy *****************************

void setup() {
 
  pinMode(PIN_D5, INPUT_PULLUP);  // Défini le bouton poussoir en entrée sur la broche D5 avec resistance interne activée
  pinMode(PIN_D1, INPUT_PULLUP);  // Défini le bouton poussoir en entrée sur la broche D5 avec resistance interne activée
  pinMode(PIN_D3, INPUT_PULLUP);  // Défini le bouton poussoir en entrée sur la broche D5 avec resistance interne activée
  pinMode(PIN_D4, INPUT_PULLUP);  // Défini le bouton poussoir en entrée sur la broche D5 avec resistance interne activée
  pinMode(PIN_D7, INPUT_PULLUP);  // Défini le bouton poussoir en entrée sur la broche D5 avec resistance interne activée
  pinMode(PIN_D6, OUTPUT);        // Défini la LED sur le Teensy sur la broche D6
xpos=0;
ypos=0;
}

//********************** Programme en boucle **************************************************

void loop() {
  clic.update();                    //lecture en boucle de l'entrée "clic" (broche D5 du Teensy)
  jack1.update();                   //lecture en boucle de l'entrée "jack1" (broche D5 du Teensy)
  jack2.update();                   //lecture en boucle de l'entrée "jack2" (broche D5 du Teensy)
  jack3.update();                   //lecture en boucle de l'entrée "jack3" (broche D5 du Teensy)
  jack4.update();                   //lecture en boucle de l'entrée "jack4" (broche D5 du Teensy)

//********************** CLIC SOURIS ET DEPLACMENTS SOURIS*************************************
//  Transforme l'appui du bouton en clic gauche de souris *************************************
//  Transforme l'appui des boutons branchés sur les prises jack en déplacements de pointeurs Jack1 : vers la droite, jack2 vers la gauche, jack3 vers le haut, jack4 vers le bas.
//  Pour augmenter la vitesse de déplacement, modifier les lignes xpos=xpos+2 par +3 ou +4

if (clic.fallingEdge()) {                   // Lorsque l'appui est détecté alors génère un clic gauche par la prise USB
        Mouse.press(MOUSE_LEFT);
            digitalWrite(PIN_D6, HIGH);     // Allume la led rapidement pour confirmer la prise en compte de l'appui sur le bouton
      }

if (jack1.fallingEdge()) {                   // Lorsque l'appui est détecté génère un déplacement vers la droite du pointeur de souris par la prise USB
        xpos=xpos+2;
            digitalWrite(PIN_D6, HIGH);     // Allume la led rapidement pour confirmer la prise en compte de l'appui sur le bouton
      }

if (jack2.fallingEdge()) {                   // Lorsque l'appui est détecté génère un déplacement vers la gauche du pointeur de souris par la prise USB
        xpos=xpos-2;
            digitalWrite(PIN_D6, HIGH);     // Allume la led rapidement pour confirmer la prise en compte de l'appui sur le bouton
      }

if (jack3.fallingEdge()) {                   // Lorsque l'appui est détecté génère un déplacement vers le haut du pointeur de souris par la prise USB
        ypos=ypos+2;
            digitalWrite(PIN_D6, HIGH);     // Allume la led rapidement pour confirmer la prise en compte de l'appui sur le bouton
      }

if (jack4.fallingEdge()) {                   // Lorsque l'appui est détecté génère un déplacement vers le bas du pointeur de souris par la prise USB
        ypos=ypos-2;
            digitalWrite(PIN_D6, HIGH);     // Allume la led rapidement pour confirmer la prise en compte de l'appui sur le bouton
      }
 
      Mouse.move (xpos , ypos);             // Applique le déplacement au pointeur de souris.
      delay(25);

if (jack1.risingEdge()) {                   // Lorsque l'appui est relaché, remet le compteur de déplacements à zero
        xpos=0;
            digitalWrite(PIN_D6, LOW);      // Eteint la led

      }

if (jack2.risingEdge()) {                   // Lorsque l'appui est relaché, remet le compteur de déplacements à zero
        xpos=0;
            digitalWrite(PIN_D6, LOW); 

}
if (jack3.risingEdge()) {                   // Lorsque l'appui est relaché, remet le compteur de déplacements à zero
        ypos=0;
            digitalWrite(PIN_D6, LOW); 

      }
if (jack4.risingEdge()) {                   // Lorsque l'appui est relaché, remet le compteur de déplacements à zero
        ypos=0;
            digitalWrite(PIN_D6, LOW); 

      }
      
if (clic.risingEdge()){                     // Détecte lorsque le bouton poussoir est relaché
        Mouse.release(MOUSE_LEFT);
             digitalWrite(PIN_D6, LOW);     // Eteint la led
  }

  
}

//************************************FIN*************************************************
