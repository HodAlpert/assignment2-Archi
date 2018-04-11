//
// Created by hod on 11/04/18.
//
#include "header.h"

void getNextZ(complexNumber* z, polynom* pol_f, polynom* pol_f_deriv){
    complexNumber* curr_z = calloc(1, sizeof(complexNumber));
    complexNumber* z_f = calloc(1, sizeof(complexNumber));
    complexNumber* z_f_deriv = calloc(1, sizeof(complexNumber));
    curr_z->real = z->real;
    curr_z->imagine = z->imagine;

    z_f = 

}

polynom* getDeriv(polynom* pol){
    polynom* newPolynom = calloc(1, sizeof(polynom));
    newPolynom->coeffs = calloc(pol->order, sizeof(complexNumber));
    newPolynom->order = pol->order-1;
    for (int i=0;i<pol->order;i++){
        newPolynom->coeffs[i].real = pol->coeffs[i].real*i;
        newPolynom->coeffs[i].imagine = pol->coeffs[i].imagine*i;
    }
    return newPolynom;
}

int main(int argc, char *argv[]) {
	
	initData* init = calloc(1, sizeof(initData));  // should we allocate here?****************
	complexNumber* z;
    init->initial = z;
    polynom* pol_f = calloc(1, sizeof(polynom)); // should we allocate here?***************
    readInput(init, pol); // this function will allocate memory for the polynom itself once we know the size 
    
	polynom* pol_f_deriv = getDeriv(pol_f);

    getNextZ(z, pol_f, pol_f_deriv);

	while (!checkAcc(init, pol, z)){
        getNextZ(z, pol_f, pol_f_deriv); //overwrites the given root number 
    }

    printResult()
}

