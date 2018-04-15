//
// Created by hod on 11/04/18.
//
#include <malloc.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include "header.h"

complexNumber getNextZ(complexNumber z, polynom* pol_f, polynom* pol_f_deriv){
   complexNumber curr_z = z;
   complexNumber z_f = calcF(pol_f,z);
   complexNumber z_f_deriv = calcF(pol_f_deriv,z);
   complexNumber quotient = divide(z_f, z_f_deriv);
   z = sub(curr_z, quotient);
   return z;
}

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
    complexNumber result = {0.0,0.0};
    result.real = first.real+second.real;
    result.imagine = first.imagine+second.imagine;
    return result;
}

complexNumber divide(complexNumber dividend, complexNumber divisor) {
    complexNumber divisorConjugate = {divisor.real,-divisor.imagine};
    double absolute = squareAbs(divisor);
    complexNumber result = mult(dividend,divisorConjugate);
    result.real = result.real/absolute;
    result.imagine = result.imagine/absolute;
    return result;
}

complexNumber power(complexNumber z, int power) {//assume power>=0
    if (power == 0) {
        complexNumber z = {1.0, 0.0};
        return z;
    }

    complexNumber result={z.real,z.imagine};
    for (int i=0;i<power-1;i++){
        result = mult(result,z);
    }
    return result;

}

double squareAbs(complexNumber z) {
    return z.real*z.real + z.imagine *z.imagine;
}

int checkAcc(initData *init, polynom *pol, complexNumber z) {
    return ( squareAbs(calcF(pol,z)) < (init->epsilon) );
}

complexNumber calcF(polynom *pol, complexNumber z) {
    complexNumber result={0.0,0.0};
    for(int i = 0; i <= pol->order; i++){
        complexNumber xPowerI = power(z,i);
        complexNumber element_i = mult(xPowerI,pol->coeffs[i]);
        result = add(result,element_i);
    }
    return result;
}

// int getCoeffPower(char *line) {
//     return atoi(line+6);
// }

double getEpsilonValue() {
    double base = 0;
    double power = 0;
    double powerSign = -1;
    char input;
    while ( (input = fgetc(stdin)) != '='){;}

    input = fgetc(stdin); // proceed to the beggining of the number after space
    
    while ( (input = fgetc(stdin)) != '.'){
        base = base*10 + (input - '0');
    }
    // skips '.'
    for (double i = 1; ( (input = fgetc(stdin)) != 'e'); ++i){
        base = base + (input-'0')*pow(10, -i);
    }
    //skips 'e'
    if ( (input = fgetc(stdin)) != '-'){
        // here should come minus, otherwise the power is positive and we stepped into the number..
        printf("The power is positive\n");
        powerSign = 1;
        power = (input-'0');
    }

    while ( (input = fgetc(stdin)) != '.'){
        power = power*10 + (input-'0');
    }
    // skips '.'
    for (double i = 1; ( (input = fgetc(stdin)) != '\n'); ++i){
        power = power + (input-'0') * pow(10.0, -i);
    }

    double result = base*pow(10, power*powerSign);
    return result;
}

int getOrderValue() {
    char input;
    int order = 0;
    while ( (input = fgetc(stdin)) != '='){;}
    
    input = fgetc(stdin); // proceed to the beggining of the number after space
    
    while ((input = fgetc(stdin)) != '\n'){
        order = order*10 + (input-'0');
    }
    return order;
}

int getCoeffIndex(){
    char input;
    int coeffIndex = 0;
    while ( (input = fgetc(stdin)) != ' '){;}
    
    while ((input = fgetc(stdin)) != ' '){
        coeffIndex = coeffIndex*10 + (input-'0');
    }
    return coeffIndex;
}

complexNumber getNumber(){
    double real = 0;
    double imagine = 0;
    int isNeg = 0;
    char input;
    while ((input = fgetc(stdin)) != '=') {;}
    
    input = fgetc(stdin); // this is a space- proceed to the beggining of the number after space
    if ((input = fgetc(stdin)) == '-'){
        isNeg = 1;
        input = fgetc(stdin);
    }
    real = (input-'0');

    while ((input = fgetc(stdin)) != '.'){
        real = real*10 + (input-'0');
    }
    if (isNeg){
        real = real*(-1);
        isNeg = 0;
    }

    // skips '.'
    for (int i = 1; ((input = fgetc(stdin)) != ' '); ++i){
        real = real + (input-'0')*pow(10, -i);
    }
    //skips space
    if ((input = fgetc(stdin)) == '-'){
        isNeg = 1;
        input = fgetc(stdin);
        
    }
    imagine = (input-'0');


    while ((input = fgetc(stdin)) != '.'){
        imagine = imagine*10 + (input-'0');
    }
    // skips '.'
    for (int i = 1; ((input = fgetc(stdin)) != '\n'); ++i){
        imagine = imagine + (input-'0')*pow(10, -i);
    }

    if (isNeg){
        imagine = imagine*(-1);
        isNeg = 0;
    }

    complexNumber result = {real , imagine};
    return result;
}

void printNumber(complexNumber z) {
    printf("%lf %lfi",z.real,z.imagine);
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

void readInput(initData *init, polynom *pol) {
    init->epsilon = 0;
    init->epsilon = getEpsilonValue();
    pol->order = getOrderValue();
    pol->coeffs = calloc(pol->order+1, sizeof(complexNumber));

    int coeffIndex = 0;
    for (int i = 0; i <= pol->order; ++i){
        coeffIndex = getCoeffIndex();
        pol->coeffs[coeffIndex] = getNumber();
    }
    init->initial = getNumber();
}
/*
int main(int argc, char *argv[]) {

    initData* init = calloc(1, sizeof(initData));  
    polynom* pol_f = calloc(1, sizeof(polynom)); 
    
    readInput(init, pol_f); 

    // printf("epsilon: %lf\ninitial: ", init->epsilon);
    // printNumber(init->initial);
    // printf("\norder: %d\n", pol_f->order);
    // printPolynom(pol_f);

	polynom* pol_f_deriv = getDeriv(pol_f);
    complexNumber z = init->initial;

    //printPolynom(pol_f_deriv);

    z = getNextZ(z, pol_f, pol_f_deriv);
	while (!checkAcc(init, pol_f, z)){
        z = getNextZ(z, pol_f, pol_f_deriv);
    }
    // print the result
    printNumber(z);
}
*/