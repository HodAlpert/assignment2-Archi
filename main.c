//
// Created by hod on 11/04/18.
//
#include <malloc.h>
#include "header.h"

//void getNextZ(complexNumber* z, polynom* pol_f, polynom* pol_f_deriv){
//    complexNumber* curr_z = z;
//    complexNumber* z_f = calloc(1, sizeof(complexNumber));
//    complexNumber* z_f_deriv = calloc(1, sizeof(complexNumber));
//    complexNumber* quotient;
//
//    calcF(pol_f,z_f);
//    calcF(pol_f_deriv,z_f_deriv);
//
//    quotient = div(z_f, z_f_deriv);
//    free(z_f);
//    free(z_f_deriv);
//
//    z = sub(curr_z, quotient);
//    free(curr_z);
//    free(quotient);
//}

polynom* getDeriv(polynom* pol){
    polynom* newPolynom = calloc(1, sizeof(polynom));
    newPolynom->coeffs = calloc((size_t)pol->order, sizeof(complexNumber));
    newPolynom->order = pol->order-1;
    for (int i=0;i<pol->order;i++){
        newPolynom->coeffs[i].real = pol->coeffs[i].real*i;
        newPolynom->coeffs[i].imagine = pol->coeffs[i].imagine*i;
    }
    return newPolynom;
}

complexNumber mult(complexNumber first, complexNumber second) {
    complexNumber result = {0.0,0.0};
    result.real = (first.real*second.real)-first.imagine*second.imagine;
    result.imagine = (first.real*second.imagine)+first.imagine*second.real;
    return result;
}

complexNumber sub(complexNumber first, complexNumber second) {//first-second
    complexNumber result={0.0,0.0};
    result.real = first.real-second.real;
    result.imagine = first.imagine-second.imagine;
    return result;
}

complexNumber add(complexNumber first, complexNumber second) {
    complexNumber result={0.0,0.0};
    result.real = first.real+second.real;
    result.imagine = first.imagine+second.imagine;
    return result;
}

complexNumber div(complexNumber dividend, complexNumber divisor) {
    complexNumber divisorConjugate = {divisor.real,-divisor.imagine};
    float abs = divisor.real*divisor.real+divisor.imagine*divisor.imagine;
    complexNumber result = mult(dividend,divisorConjugate);
    result.real = result.real/abs;
    result.imagine = result.imagine/abs;
    return result;
}

void calcF(polynom *pol, complexNumber* z) {
    complexNumber result={0.0,0.0};
    for(int i=0;i<=pol->order;i++){
        complexNumber xPowerI=power(*z,i);
        complexNumber ithElement = mult(xPowerI,pol->coeffs[i]);
        result = add(result,ithElement);
    }
    z->imagine = result.imagine;
    z->real = result.real;
}

complexNumber power(complexNumber z, int power) {//assume power>=0
    if (power == 0) {
        return {1.0, 0.0};
    }
    complexNumber result={z.real,z.imagine};
    for (int i=0;i<power;i++){
        result = mult(result,result);
    }
    return result;

}

void printNumber(complexNumber z) {
    printf("((%f)+(%f)i)",z.real,z.imagine);
}

void printPolynom(polynom *pol) {
    for (int i=0;i<=pol->order;i++){
        if(i==0)
            printNumber(pol->coeffs[i]);
        else{
            printf("+");
            printNumber(pol->coeffs[i]);
            printf("x^%d",i);
        }
    }
    printf("\n");
}

int main(int argc, char *argv[]) {

//	initData* init = calloc(1, sizeof(initData));  // should we allocate here?****************
//	complexNumber* z;
//    init->initial = z;
//    polynom* pol_f = calloc(1, sizeof(polynom)); // should we allocate here?***************
//    readInput(init, pol_f); // this function will allocate memory for the polynom itself once we know the size
//
//	polynom* pol_f_deriv = getDeriv(pol_f);
//
//    getNextZ(z, pol_f, pol_f_deriv);
//
//	while (!checkAcc(init, pol_f, z)){
//        getNextZ(z, pol_f, pol_f_deriv); //overwrites the given root number
//    }
//
//    printResult(z);

}

