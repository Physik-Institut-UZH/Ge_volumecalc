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

#ifndef SIMION_SOLVER_LAPLACE_H_
#define SIMION_SOLVER_LAPLACE_H_

#include "ADL.h" //... only for defining int and double ...?
#include "SIMION_Array.h"

//allocate necessary variables:
//extern struct SIMION_PA *SIMION_G_PA;	//potential arrays
static double SIMION_GridSize_LAPLACE;		//GridSize [cm/gridunit] (sets common dimension of above arrays)

//SIMION routines:
int SIMION_Setup_SOLVER_LAPLACE(char *);
int SIMION_Status_SOLVER_LAPLACE(void);

int SIMION_Solve3D_LAPLACE(struct SIMION_PA *);
int SIMION_Solve2D_LAPLACE(struct SIMION_PA *);

#endif /* SIMION_SOLVER_LAPLACE_H_ */
