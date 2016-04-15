
const int pdz = A0;
const int btn = A5;

int sensible = 0;
int sensorValue0 = 0;
int sensorValue5 = 0;

int compteur = 0;


void setup() {
  Serial.begin(9600);
  pinMode(13, OUTPUT);
}


void loop() {

  sensorValue0 = analogRead(pdz);
  sensorValue5 = analogRead(btn);

 Serial.println(compteur);
 if(sensorValue0==sensible){
   Serial.println("Ca frappe");
   digitalWrite(13, HIGH);
   compteur=compteur+1;
   delay(20);
 }
 else{
  digitalWrite(13, LOW);
 }
 }



