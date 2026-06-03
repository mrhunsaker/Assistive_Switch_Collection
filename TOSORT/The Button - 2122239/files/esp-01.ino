#include <ESP8266WiFi.h>
#include <WiFiClient.h>
 
const char* ssid = "name"; // type your ssid
const char* password = "password"; // type your password
const char* host = "xxx.xxx.xxx.xxx"; // HUE bridge IP
const char* api_key = "apikey"; // Hue API key
int  LED = 2;
boolean success = false;

WiFiClient client;

void setup() {
  pinMode(LED, OUTPUT);
  digitalWrite(LED, LOW);
  int counter = 0;
  Serial.begin(115200);
  Serial.println("************************ WLAN ***********************");
  WiFi.disconnect();
  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid, password);

  Serial.print("Versuche mit WLAN ");
  Serial.print(ssid);
  Serial.println(" zu verbinden.");
  
  while (WiFi.status() != WL_CONNECTED) {
    if ( counter < 100 ) {
      Serial.print("."); 
      digitalWrite(LED, HIGH);
      delay(200-counter);
      digitalWrite(LED, LOW);
      delay(201-(counter*2));   
    }
    else {
      delay(200);
    }   
    if ( counter >= 100 ) {
      Serial.println();
      Serial.println("Keine WLAN Verbindung möglich!"); 
      error();
      shutdown(); 
    }
    counter++;
  }    
  Serial.println();
  Serial.println("zack da issa.");
  Serial.print("IP Adresse: ");
  Serial.println(WiFi.localIP());
  
  Serial.print("MAC Adresse: ");
  Serial.println(WiFi.macAddress());
  Serial.println();
  
  Serial.println("*****************************************************");
  Serial.println();
  Serial.println("******************** SENDE DATEN ********************");
  
  if (client.connect(host,80))
  {
    // szene alex    /api/yK0_apiKey_5k3/groups/0/action   body-  { "scene": "RsInOrgQ2Xd3F1y" }
    // alle lampen   /api/yK0_apiKey_5k3/groups/0/action   body-  { "on": false }
    client.print("PUT /api/");
    Serial.print("PUT /api/");
    client.print(api_key);
    Serial.print(api_key);
    client.print("/groups/0/action");    //groups/0/ is the group where all the lights AND scenes are in
    Serial.print("/groups/0/action");
    client.println(" HTTP/1.1");
    Serial.println(" HTTP/1.1");
    client.print("Host: ");
    Serial.print("Host: ");
    client.println(host);  
    Serial.println(host);                      
    client.println("Connection: close");
    Serial.println("Connection: close");
    client.println("Content-Type: application/x-www-form-urlencoded");
    Serial.println("Content-Type: application/x-www-form-urlencoded");
    client.println("Content-Length: 12\r\n");
    Serial.println("Content-Length: 12\r\n");
    client.print("{\"on\":false}");  // shut off lights on:false
    Serial.println("{\"on\":false}");  // shut off lights on:false

    //client.println("Content-Length: 27\r\n");
    //client.print("{\"scene\":\"akk7k3SkPojYUHw\"}"); // turn on scene scene:IDofScene
    Serial.println();
    
  Serial.println("*****************************************************");
  Serial.println();
  Serial.println("******************* SERVER ANTWORT ******************");
  while (client.connected()) {
      if (client.available()) {
        String line = client.readStringUntil('\n');

        Serial.println(line);
        if (line.substring(0, 15) == "HTTP/1.1 200 OK")
          {
            success = true;                 
          }
      }
  }
  client.stop();
  } else {
    Serial.println("kann keine Verbindung aufbauen!!");
    error();
    shutdown(); // Unable to connect
  }
  if ( success == true ) {
    Serial.println();
    Serial.println("erfolgreich gesendet!!");
    gesendet();
  }
  Serial.println("*****************************************************");
  shutdown();
}

void loop() {

}

void gesendet() {
  for (int i = 4; i < 90; i=(5*i) >> 2) {
    digitalWrite(LED, HIGH);   // LED aus
    delay(10*i);               // warte
    digitalWrite(LED, LOW);    // LED an
    delay(10*i);               // warte
  }
}

void error() {
    digitalWrite(LED, HIGH);   // LED an
    delay(3000);               // warte
    digitalWrite(LED, LOW);    // LED aus
}

void shutdown() {
  digitalWrite(LED, LOW);
  ESP.deepSleep(0); // sleep esp
  while(1) {        //shutdown error
    error();
  }
}
