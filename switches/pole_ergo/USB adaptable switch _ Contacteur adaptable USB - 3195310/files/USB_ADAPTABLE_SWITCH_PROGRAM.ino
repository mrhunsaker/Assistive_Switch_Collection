// Programme par pole-ergo : www.pole-ergo.fr Librement adapté d'exemples proposés par PRJC fabricant de Teensy
// Programme contacteur sur TEENSY 2.0 pour le contacteur proposé sur Thingiverse 
// Fonction : emulation d'une touche du clavier ou d'un clic souris lors de l'appui sur le bouton poussoir du contacteur.
// Installer puis Programmer votre Teensy : voir
// Utiliser l'environnement Arduino : voir
// Tableau des caractères utilisables avec le contacteur : voir fin du programme
// Ecrit et compilé sur IDE Arduino 1.8.5
// Librairies Teensy
// Type de carte : Teensy 2.0 - USB type : Keyboard + Mouse + Joystick - CPU speed : 16MHZ - Keyboard layout : français

//******************** Début de programme *****************************************************
#include <Bounce.h> //utilisation de la librairie Bounce : voir https://www.pjrc.com/teensy/td_libs_Bounce.html

Bounce clic = Bounce(PIN_D5, 10);

//********************** Définition des entrées/sorties du Teensy *****************************

void setup() {
  pinMode(PIN_D5, INPUT_PULLUP);  // Défini le bouton poussoir en entrée sur la broche D5 avec resistance interne activée
  pinMode(PIN_D6, OUTPUT);        // Défini la LED sur le Teensy sur la broche D6

}

//********************** Programme en boucle **************************************************

void loop() {
  clic.update();                    //lecture en boucle de l'entrée "clic" (broche D5 du Teensy)

//********************** CLIC SOURIS **********************************************************
//  Transforme l'appui du bouton en clic gauche de souris *************************************
//  Pour stopper cette fonction rajoutez les symboles de commentaires en début de ligne : // 

if (clic.fallingEdge()) {                   // Lorsque l'appui est détecté alors génère un clic gauche par la prise USB
        Mouse.press(MOUSE_LEFT);
            digitalWrite(PIN_D6, HIGH);     // Allume la led rapidement pour confirmer la prise en compte de l'appui sur le bouton
      }
      
if (clic.risingEdge()){                     // Détecte lorsque le bouton poussoir est relaché
        Mouse.release(MOUSE_LEFT);
             digitalWrite(PIN_D6, LOW);     // Eteint la led
  }
}
//********************* TOUCHE CLAVIER ********************************************************
//  Transforme l'appui sur le bouton en appui clavier touche F11 par USB **********************
//  Pour obtenir cette fonction supprimez les symboles de commentaires en début de ligne : //


//    if (clic.fallingEdge()) {           // Lorsque l'appui est détecté alors génère le caractère du clavier de la ligne du dessous entre parenthèses
//          Keyboard.press(KEY_ENTER);        // Ici génère la touche enter
//          delay (200);                      // Délai pour permettre une prise cn compte de la touche
//              Keyboard.release(KEY_ENTER);    // Détecte lorsque le bouton poussoir est relaché
//                digitalWrite(PIN_D6, HIGH);   // Allume la led rapidement pour confirmer la prise en compte de l'appui sur le bouton
//  }
//     if(clic.risingEdge()){                // Détecte lorsque le bouton poussoir est relaché
//                digitalWrite(PIN_D6, LOW);          // Eteint la led
//  }
// }
//
//************************************* ANNEXE TOUCHES SOURIS ********************************************************************
// MOUSE_LEFT MOUSE_MIDDLE MOUSE_RIGHT MOUSE_BACK MOUSE_FORWARD
//
//
//************************************* ANNEXE TOUCHES CLAVIER ****************************************************************************************************************
//TABLEAU DES CARACTERES
//Normal Keys
//KEY_A  KEY_B KEY_C KEY_D KEY_E KEY_F KEY_G KEY_H KEY_I KEY_J KEY_K KEY_L KEY_M KEY_N KEY_O KEY_P KEY_Q KEY_R KEY_S KEY_T KEY_U KEY_V KEY_W KEY_X
//KEY_Y KEY_Z KEY_1 KEY_2 KEY_3 KEY_4 KEY_5 KEY_6 KEY_7 KEY_8 KEY_9 KEY_0 KEY_ENTER KEY_ESC KEY_BACKSPACE KEY_TAB KEY_SPACE KEY_MINUS KEY_EQUAL KEY_LEFT_BRACE KEY_RIGHT_BRACE KEY_BACKSLASH   KEY_SEMICOLON
//KEY_QUOTE KEY_TILDE KEY_COMMA KEY_PERIOD KEY_SLASH KEY_CAPS_LOCK KEY_F1  KEY_F2 KEY_F3  KEY_F4  KEY_F5  KEY_F6 KEY_F7  KEY_F8  KEY_F9  KEY_F10
//KEY_F11 KEY_F12 KEY_PRINTSCREEN KEY_SCROLL_LOCK KEY_PAUSE KEY_INSERT  KEY_HOME  KEY_PAGE_UP KEY_DELETE  KEY_END KEY_PAGE_DOWN KEY_RIGHT
//KEY_LEFT  KEY_DOWN  KEY_UP  KEY_NUM_LOCK KEYPAD_SLASH  KEYPAD_ASTERIX  KEYPAD_MINUS  KEYPAD_PLUS KEYPAD_ENTER  KEYPAD_1  KEYPAD_2  KEYPAD_3 KEYPAD_4  KEYPAD_5  KEYPAD_6  KEYPAD_7
//KEYPAD_8  KEYPAD_9  KEYPAD_0  KEYPAD_PERIOD
//Modifier Keys
//MODIFIERKEY_CTRL  MODIFIERKEY_RIGHT_CTRL  - Control Key
//MODIFIERKEY_SHIFT MODIFIERKEY_RIGHT_SHIFT - Shift Key
//MODIFIERKEY_ALT MODIFIERKEY_RIGHT_ALT - Alt Key
//MODIFIERKEY_GUI MODIFIERKEY_RIGHT_GUI - Windows (PC) or Clover (Mac)
//Media Player Keys
//KEY_MEDIA_PLAY  KEY_MEDIA_PAUSE
//KEY_MEDIA_RECORD  KEY_MEDIA_STOP
//KEY_MEDIA_REWIND  KEY_MEDIA_FAST_FORWARD
//KEY_MEDIA_PREV_TRACK  KEY_MEDIA_NEXT_TRACK
//KEY_MEDIA_VOLUME_DEC  KEY_MEDIA_VOLUME_INC
//KEY_MEDIA_PLAY_PAUSE  KEY_MEDIA_PLAY_SKIP
//KEY_MEDIA_MUTE  KEY_MEDIA_EJECT
//System Control Keys
//KEY_SYSTEM_POWER_DOWN KEY_SYSTEM_SLEEP
//KEY_SYSTEM_WAKE_UP  
//************************************FIN*************************************************
