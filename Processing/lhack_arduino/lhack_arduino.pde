import processing.serial.*;
import cc.arduino.*;
Arduino arduino;

Serial myPort;


int bouton;
int boutonValue;
int piezo;
int piezoValue;
boolean debut=false;

int contpiezo = 0;

int contbouton = 0; //Chiffre à deviner
int contboutonjoueur = 0; //Chiffre proposé par les autres joueurs

int chrono = 0;
int chrono2 = 0;

int tempsinput =100; //Délai d'attente entre les inputs
int max = 21; //Valeur maximale du chiffre à faire deviné


void setup(){

size(200,200);
println(Arduino.list());
 arduino = new Arduino(this, Arduino.list()[1], 57600); 
 // Ensuite, la syntaxe est la même que dans l'IDE Arduino
 arduino.pinMode(1, Arduino.INPUT); 
 arduino.pinMode(5, Arduino.INPUT); 
 background(0); 
 fill(255); 
 smooth();


}

// Un message est reçu depuis l'Arduino


void draw(){
  
piezo = piezoValue;
bouton = boutonValue;
//println(piezo);

conteurpiezo();
//Controller l’arrière plan avec le switch
 piezoValue = arduino.analogRead(1);  


 //Controller une ellipse avec le potentiomètre 
 boutonValue = arduino.analogRead(0)/4;  



println("Chiffre a devine");
println(contbouton);

println("________________________");

println("Chiffre propose");
println(contboutonjoueur);


println("________________________");

    conteurbouton();
    if(chrono>tempsinput){
      joueur();
    }
//println(debut);
}

void conteurpiezo(){
  
  if (piezo != 0){
  contpiezo ++;
  delay(200); 
  }
//println(contpiezo);
}

void conteurbouton(){
  chrono ++;
  if (bouton > 200 && chrono < tempsinput && contbouton < max){
  contbouton ++;
  chrono = 0;
  delay(400); 
  }
  else if (chrono > tempsinput || contbouton > max){
  contbouton = contbouton;
  chrono = tempsinput+1;
  }
} 


void joueur(){
  chrono2 ++;
     if (piezo != 0 && chrono2 < tempsinput){
      contboutonjoueur ++;
      chrono2 = 0;
      delay(200); 
      }
    else if (chrono2 > tempsinput ){
            if(contboutonjoueur == contbouton && contbouton != 0){
             println("C'EST GAGNE !!!!!!!!!");
            noLoop(); 
            }
            else if(contboutonjoueur > contbouton && contbouton != 0){
             println("C'EST PERDU !!!!!!!!!"); 
             noLoop();
            }
            else if(contboutonjoueur < contbouton){
             chrono2 = 0; 
            }  
      }
}

  
