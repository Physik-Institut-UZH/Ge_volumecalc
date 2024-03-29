/*
 * AGATA Detector simulation Library (ADL)
 *
 * Bart Bruyneel - bartb@ikp.uni-koeln.de
 * Benedikt Birkenbach - bene@ikp.uni-koeln.de
 *
 * IKP Cologne
 * http://www.ikp.uni-koeln.de/agata
 *
 */

#include "ADL_Convl.h"

double ADL_G_RCtau = 0.;

//Dummy routine, does nothing. Apply for simulation without convolution.
//***************************************************************************************************

double GetRCtau(){return ADL_G_RCtau;}

int ADL_Setup_CONVL_DUMMY(char *filename_setupfile){
  //Here the setup file for this library version:
  int		i,len,segnr,err=1;
  struct	ADL_KEYWORD **Kwords;
  
  //Here we free ADL_G_INVERSE if it already existed:
  if (ADL_G_INVERSE != NULL) free(ADL_G_INVERSE);
  //allocation and initialization to 0 of ADL_G_INVERSE:
  ADL_G_INVERSE = (int *)calloc(GetNSEG(),sizeof(int));
  
  //get list of keywords from file:
  if (strlen(filename_setupfile)>1) {// if a filename is supplied, parse it
    //get list of keywords
    Kwords = ADL_parse_file (filename_setupfile);
    
    //give keywords parsed values:
    len = Kwords[1]->linenumber;
    err = Kwords[len+2]->linenumber;
    //set late binding of functions:
    for (i=0;i<len;i++) {
      if (strcmp(Kwords[2+i]->keyword,"INVERT")==0){
        sscanf(Kwords[2+i]->svalue,"%d",&segnr);
        if ((segnr >= 0)&&(segnr < GetNSEG())) ADL_G_INVERSE[segnr]=1;
      }
      if (strcmp(Kwords[2+i]->keyword,"ADL_G_RCtau")==0)
        sscanf(Kwords[2+i]->svalue,"%lf",&ADL_G_RCtau);
    }
  }
  free(Kwords);
  
  if (GetADLDebug()) ADL_Status_CONVL_DUMMY();
  return err;
}


int ADL_Status_CONVL_DUMMY(void){
  int i;
  printf("\nStatus CONVL DUMMY:\n");
  printf("-------------------\n");
  if (ADL_G_INVERSE == NULL) {
    printf("WARNING: ADL_G_INVERSE == NULL -Requires setup!!!\n");
    return 1;
  }
  printf("ADL_G_INVERSE = ");
  for (i=0; i<GetNSEG(); i++) printf("%d",ADL_G_INVERSE[i]);
  printf("\n");
  printf("ADL_G_RCtau = %le \n",ADL_G_RCtau);
  printf("depends on: EVENT \n");
  return 0;
}


void ADL_Convolute_DUMMY(struct ADL_TRACES *Evnt)
{
  int i,j;
  double RCtau = GetRCtau(); // in mus
  
  //Apply a simple RC circuit preamp response if time constant is not zero (Y. Kermaidic May 2017)
  if(RCtau>0){
    double timeStep = GetDeltaT();

    double x1 = exp(-timeStep/RCtau);
    double a10 = (1+x1)/2.;
    double a11 = -(1+x1)/2.;
    double b11 = x1;
    
    
    struct ADL_TRACES *EvntIn = new_traces();
    
    for(j = 0; j<GetDIMT();j++) EvntIn->Tr[0][j] = Evnt->Tr[0][j];
    
    for(int j = 1; j<GetDIMT();j++)
      Evnt->Tr[0][j] = a10*EvntIn->Tr[0][j] + a11*EvntIn->Tr[0][j-1] + b11*Evnt->Tr[0][j-1];
    
    Evnt->Tr[0][GetDIMT()-1]=Evnt->Tr[0][GetDIMT()-2];
    /*
    for(j = 1; j<GetDIMT();j++){
      integral = Evnt->Tr[0][j-1] + (EvntIn->Tr[0][j-1] - Evnt->Tr[0][j-1])/RCtau * timeStep;
      Evnt->Tr[0][j] = integral;
    }
     */
  }
  
  //invert signals of inverting preamps:
  for (i=0; i<GetNSEG(); i++)
    if (ADL_G_INVERSE[i]) for (j=0; j<=GetDIMT(); j++) Evnt->Tr[i][j] *= -1.0;
}


