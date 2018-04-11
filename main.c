//
// Created by hod on 11/04/18.
//
#include "header.h"
polynom* convertDeriv(polynom* pol){
    polynom* newPolynom = calloc(1, sizeof(polynom));
    newPolynom->coeffs = calloc(pol->order, sizeof(complexNumber));
    newPolynom->order = pol->order-1;
    for (int i=0;i<pol->order;i++){
        newPolynom->coeffs[i].real = pol->coeffs[i].real*i;
        newPolynom->coeffs[i].imagine = pol->coeffs[i].imagine*i;
    }
    return newPolynom;
}


