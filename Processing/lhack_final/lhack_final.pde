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

boolean recordPDF = false;

int formResolution = 15;
int stepSize = 1;
float distortionFactor = 1;
float initRadius = 150;
float centerX, centerY;
float[] x = new float[formResolution];
float[] y = new float[formResolution];

boolean filled = false;
boolean freeze = false;

int etat;

	void setup(){
		size(800, 800);
		smooth();
		etat = 0;
		
		// init form
		centerX = width/2; 
		centerY = height/2;
		float angle = radians(360/float(formResolution));
		for (int i=0; i<formResolution; i++){
			x[i] = cos(angle*i) * initRadius;
			y[i] = sin(angle*i) * initRadius;
		}

		println(Arduino.list());
		arduino = new Arduino(this, Arduino.list()[1], 57600); 
		// Ensuite, la syntaxe est la même que dans l'IDE Arduino
		arduino.pinMode(1, Arduino.INPUT); 
		arduino.pinMode(5, Arduino.INPUT); 
		background(0); 
		fill(0); 
		smooth();
	}

	void draw(){
		if (etat == 0){
			boot();
		}
		else if (etat == 1){
			tampon();
		}
		else{
			jeux();
		}
	}

	void boot(){
		fill(0);
		rect(-10,-10,820,820);
		fill(255);
		textSize(64);
		textAlign(CENTER);
		text( "LabHit" , 400 , 350 );
		
		textSize(36);
		textAlign(CENTER);
		text( "L'HackABoire" , 400 , 400 );
		
		textSize(23);
		textAlign(CENTER);
		text( "Quentin Laloux - Victor Boquet - Antoine Derouin" , 400 , 450 );
		etat = 1;
	}

	void tampon(){
		delay(4000);
		fill(0);
		rect(-10,-10,820,820);
		etat = 2;
	}

	void jeux(){
		stepSize = contboutonjoueur;
		
		stroke(random(0,255),random(0,255),random(0,255));
		fill(0,5);
		rect(-10,-10,820,820);
		
		// calculate new points
		for (int i=0; i<formResolution; i++){
			x[i] += random(-stepSize,stepSize);
			y[i] += random(-stepSize,stepSize);
		// ellipse(x[i], y[i], 5, 5);
		}
	
		strokeWeight(random(0,5));
		if (filled) fill(50);
		else noFill();
		
		beginShape();
		// start controlpoint
		curveVertex(x[formResolution-1]+centerX, y[formResolution-1]+centerY);
		
		// only these points are drawn
		for (int i=0; i<formResolution; i++){
			curveVertex(x[i]+centerX, y[i]+centerY);
		}
		curveVertex(x[0]+centerX, y[0]+centerY);
	
		// end controlpoint
		curveVertex(x[1]+centerX, y[1]+centerY);
		endShape();
		
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
				gagne(); 
			}
			else if(contboutonjoueur > contbouton && contbouton != 0){
				println("C'EST PERDU !!!!!!!!!"); 
				perdu();
			}
			else if(contboutonjoueur < contbouton){
				chrono2 = 0; 
			}
		}
	}
	
	void gagne(){
		fill(0);
		rect(-10,-10,820,820);
		fill(255);
		textSize(64);
		textAlign(CENTER);
		text( "Gagné, ils boivent" , 400 , 350 );
		if (bouton > 200){
			reboot();
		}
	}
	
	void perdu(){
		fill(0);
		rect(-10,-10,820,820);
		fill(255);
		textSize(64);
		textAlign(CENTER);
		text( "Perdu, tu bois" , 400 , 350 );
		if (bouton > 200){
			reboot();
		}
	}
	
	void reboot(){
		piezoValue = 0;
		boutonValue = 0;
		contboutonjoueur = 0;
		contbouton = 0;
		chrono = 0 ;
		chrono2 = 0;
		stepSize = 1;
		formResolution = 15;
		distortionFactor = 1;
		initRadius = 150;
		draw();
	}
