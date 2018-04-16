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

//complexNumber mult(complexNumber first, complexNumber second) {
//    complexNumber result = {0.0,0.0};
//    result.real = (first.real*second.real)-first.imagine*second.imagine;
//    result.imagine = (first.real*second.imagine)+first.imagine*second.real;
//    return result;
//}

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
    long double absolute = squareAbs(divisor);
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

long double squareAbs(complexNumber z) {
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

long double getEpsilonValue(char *line) {
    char* temp = line;
    for (;(*temp<'0')||(*temp>'9');temp++){}
    return strtold(temp,NULL);
}

int getOrderValue(char *line) {
    char* temp = line;
    for (;(*temp<'0')||(*temp>'9');temp++){}
    return atoi(temp);
}

int getCoeffIndex(char *line) {
    return atoi(line+6);
}

complexNumber getNumber(char *line) {
    complexNumber result={0.0,0.0};
    char* temp = line;
    char* end;
    result.real =strtold(temp,&end);
    result.imagine = strtold(end,NULL);
    return result;
}

void printNumber(complexNumber z) {
    printf("%Lf %Lfi",z.real,z.imagine);
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
    char* currentline = NULL;
    size_t len=0;
    ssize_t read;
    while((read = getline(&currentline,&len,stdin))!=-1){
        if(strstr(currentline,"epsilon")!=NULL){
            init->epsilon = getEpsilonValue(currentline);
        }
        else if(strstr(currentline,"order")!=NULL){
            pol->order = getOrderValue(currentline);
            pol->coeffs = calloc((size_t)pol->order+1,sizeof(complexNumber));
        }
        else if(strstr(currentline,"coeff")!=NULL){
            int power = getCoeffIndex(currentline);
            char* temp=currentline;
            for (;(*temp!='=');temp++){}
            pol->coeffs[power] = getNumber(temp+1);
            continue;
        }
        else if(strstr(currentline,"initial")!=NULL){
            char* temp=currentline;
            for (;(*temp!='=');temp++){}
            init->initial= getNumber(temp+1);
            break;
        }
        free(currentline);
    }
}

int main(int argc, char *argv[]) {
    complexNumber n1 = {1,2};
    complexNumber n2 = {2,3};
    mult(n1,n2);
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
//    printNumber(z);
    printf("root = %Le %Le",z.real
            ,z.imagine);
}
