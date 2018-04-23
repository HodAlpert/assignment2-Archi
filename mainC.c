//
// Created by hod on 11/04/18.
//
#include <malloc.h>
#include "header.h"

//complexNumber getNextZ(complexNumber z, polynom* pol_f, polynom* pol_f_deriv){
//   complexNumber curr_z = z;
//   complexNumber z_f = calcF(pol_f,z);
//   complexNumber z_f_deriv = calcF(pol_f_deriv,z);
//   complexNumber quotient = divide(z_f, z_f_deriv);
//   z = subtract(curr_z, quotient);
//   return z;
//}

polynom* getDeriv(polynom* pol){
    polynom* newPolynom = calloc(1, sizeof(polynom));
    newPolynom->coeffs = calloc((size_t)pol->order, sizeof(complexNumber));
    newPolynom->order = pol->order-1;
    for (int i = 0; i < pol->order; i++){
        newPolynom->coeffs[i].real = pol->coeffs[i+1].real*(i+1);
        newPolynom->coeffs[i].imagine = pol->coeffs[i+1].imagine*(i+1);
    }
    return newPolynom;
}

//complexNumber mult(complexNumber first, complexNumber second) {
//    complexNumber result = {0.0,0.0};
//    result.real = (first.real*second.real)-first.imagine*second.imagine;
//    result.imagine = (first.real*second.imagine)+first.imagine*second.real;
//    return result;
//}
//complexNumber subtract(complexNumber first, complexNumber second) {//first-second
//    complexNumber result={0.0,0.0};
//    result.real = first.real-second.real;
//    result.imagine = first.imagine-second.imagine;
//    return result;
//}

//complexNumber sum(complexNumber first, complexNumber second) {
//    complexNumber result = {0.0,0.0};
//    result.real = first.real+second.real;
//    result.imagine = first.imagine+second.imagine;
//    return result;
//}

//complexNumber divide(complexNumber dividend, complexNumber divisor) {
//    long double absolute = squareAbs(divisor);
//    complexNumber divisorConjugate = {divisor.real,-divisor.imagine};
//    complexNumber result = mult(dividend,divisorConjugate);
//    result.real = result.real/absolute;
//    result.imagine = result.imagine/absolute;
//    return result;
//}
//
//complexNumber power(complexNumber z, int power) {//assume power>=0
//    if (power == 0) {
//        complexNumber z = {1.0, 0.0};
//        return z;
//    }
//
//    complexNumber result={z.real,z.imagine};
//    for (int i=0;i<power-1;i++){
//        result = mult(result,z);
//    }
//    return result;
//
//}

//long double squareAbs(complexNumber z) {
//    return z.real*z.real + z.imagine *z.imagine;
//}

//complexNumber calcF(polynom *pol, complexNumber z) {
//    complexNumber result={0.0,0.0};
//    for(int i = 0; i <= pol->order; i++){
//        complexNumber xPowerI = power(z,i);
//        complexNumber element_i = mult(xPowerI,pol->coeffs[i]);
//        result = sum(result, element_i);
//    }
//    return result;
//}



void printNumber(complexNumber z) {
    printf("%.*Lf %.*Lfi\n",15,z.real,15,z.imagine);
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

// void readInput(initData *init, polynom *pol) {
//     scanf("epsilon = %Lf\n", &init->epsilon);
//     scanf("order = %d\n", &pol->order);
//     pol->coeffs = calloc((size_t) pol->order + 1, sizeof(complexNumber));
//     for (int i = 0; i <= pol->order; i++) {
//         int current = 0;
//         long double real = 0;
//         long double img = 0;
//         scanf("coeff %d = %Lf %Lf\n", &current, &real, &img);
//         pol->coeffs[current].real = real;
//         pol->coeffs[current].imagine = img;
//     }
//     scanf("initial = %Lf %Lf", &init->initial.real, &init->initial.imagine);
// }

// int main(int argc, char *argv[]) {
//     initData* init = calloc(1, sizeof(initData));
//     polynom* pol_f = calloc(1, sizeof(polynom));

//     readInput(init, pol_f);

//     // printf("epsilon: %lf\ninitial: ", init->epsilon);
//     // printNumber(init->initial);
//     // printf("\norder: %d\n", pol_f->order);
//     // printPolynom(pol_f);

// 	polynom* pol_f_deriv = getDeriv(pol_f);
//     complexNumber z = init->initial;
//     complexNumber z_f;

//     //printPolynom(pol_f_deriv);

//     do{
//         z = getNextZ(z, pol_f, pol_f_deriv);
//         z_f = calcF(pol_f, z);

//     }while( squareAbs(z_f) > (init->epsilon*init->epsilon) );
	
//     free(init);
//     free(pol_f->coeffs);
//     free(pol_f);
//     free(pol_f_deriv->coeffs);
//     free(pol_f_deriv);
//     printf("root = %.*Le %.*Le\n", 17, z.real, 17, z.imagine);
// }
