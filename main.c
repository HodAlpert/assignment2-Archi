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
    double base;
    double power;
    int powerSign = -1;
    char input;
    while ( (input = fgetc(stdin)) != '='){
            input = fgetc(stdin);
    }
    fgetc(stdin); // proceed to the beggining of the number after space
    while ((input = fgetc(stdin) != '.')){
        base = base*10 + input;
    }
    // skips '.'
    for (int i = 1; ((input = fgetc(stdin)) != 'e'); ++i){
        base = base + input*pow(10, -i);
    }
    //skips 'e'
    if ( (input = fgetc(stdin)) != '-'){
        // here should come minus, otherwise the power is positive and we stepped into the number..
        printf("The power is positive\n");
        powerSign = 1;
        power = input;
    }

    while ((input = fgetc(stdin) != '.')){
        power = power*10 + input;
    }
    // skips '.'
    for (int i = 1; ((input = fgetc(stdin)) != '\n'); ++i){
        power = power + input*pow(10, -i);
    }
    return pow(base, power*powerSign);
}

int getOrderValue() {
    char input;
    int order;
    while ( (input = fgetc(stdin)) != '='){
            input = fgetc(stdin);
    }
    fgetc(stdin); // proceed to the beggining of the number after space
    while ((input = fgetc(stdin) != '\n')){
        order = order*10 + input;
    }
    return order;
}


complexNumber getNumber(){
    double real;
    double imagine;
    char input;
    while ((input = fgetc(stdin)) != '=') {
        input = fgetc(stdin);
    }
    fgetc(stdin);
    while ((input = fgetc(stdin) != '.')){
        real = real*10 + input;
    }
    // skips '.'
    for (int i = 1; ((input = fgetc(stdin)) != ' '); ++i){
        real = real + input*pow(10, -i);
    }
    //skips space
    while ((input = fgetc(stdin) != '.')){
        imagine = imagine*10 + input;
    }
    // skips '.'
    for (int i = 1; ((input = fgetc(stdin)) != '\n'); ++i){
        imagine = imagine + input*pow(10, -i);
    }
    complexNumber result = {real , imagine};
    return result;
}
void readInput1(initData *init, polynom *pol) {
    char input;
    init->epsilon = 0;
    while ((input = fgetc(stdin)) != '\0') {
        init->epsilon = getEpsilonValue();
        pol->order = getOrderValue();
        pol->coeffs = calloc(pol->order, sizeof(complexNumber));

        int order = 0;
        for (int i = 0; i <= pol->order; ++i){
            while ((input = fgetc(stdin)) != ' ') {
                input = fgetc(stdin);
            }
            order = input;
            // proceed after '='' to the number
            pol->coeffs[order] = getNumber();
        }
        init->initial = getNumber();

    }
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

double squareAbs(complexNumber z) {
    return z.real*z.real + z.imagine *z.imagine;
}

bool checkAcc(initData *init, polynom *pol, complexNumber z) {
    return ( squareAbs(calcF(pol,z)) < (init->epsilon*init->epsilon) );
}

// void readInput(initData *init, polynom *pol) {
//     char* currentline = NULL;
//     size_t len=0;
//     size_t read;
//     while((read = getline(&currentline, &len, stdin))!=-1){
//         //printf("%s", currentline);
//         else if(strstr(currentline,"order")!=NULL){
//             pol->order = getOrderValue(currentline);
//             pol->coeffs = calloc(pol->order, sizeof(complexNumber));
//         }
//         else if(strstr(currentline,"coeff")!=NULL){
//             int power = getCoeffPower(currentline);
//             char* temp=currentline;
//             for (;(*temp!='=');temp++){}
//             pol->coeffs[power] = getNumber(temp+1);
//             continue;
//         }
//         else if(strstr(currentline,"initial")!=NULL){
//             char* temp=currentline;
//             for (;(*temp!='=');temp++){}
//             init->initial= getNumber(temp+1);
//             break;
//         }
//     }
//     free(currentline);

// }

int main(int argc, char *argv[]) {

    initData* init = calloc(1, sizeof(initData));  // should we allocate here?****************
    polynom* pol_f = calloc(1, sizeof(polynom)); // should we allocate here?***************

    readInput(init, pol_f); // this function will allocate memory for the polynom itself once we know the size
    complexNumber z = init->initial;

	polynom* pol_f_deriv = getDeriv(pol_f);

    z = getNextZ(z, pol_f, pol_f_deriv);
    printf("Reached Here\n");
	while (!checkAcc(init, pol_f, z)){
      z = getNextZ(z, pol_f, pol_f_deriv);
    }

    //printResult(z);
}

