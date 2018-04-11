//
// Created by hod on 11/04/18.
//

#ifndef ASSIGNMENT2_ARCHIT_HEADER_H
#define ASSIGNMENT2_ARCHIT_HEADER_H

#include <stdbool.h>

typedef struct {
    float real;
    float imagine;
} complexNumber;

typedef struct {
    int order;
    complexNumber* coeffs;
} polynom;

typedef struct{
    float epsilon;
    complexNumber initial;
} initData;

void readInput(initData* init, polynom* pol);

complexNumber calcF(polynom* pol, complexNumber z);

polynom* getDeriv(polynom* pol);//hod

complexNumber getNextZ(complexNumber z, polynom* pol_f, polynom* pol_f_deriv);

bool checkAcc(initData* init, polynom* pol, complexNumber z);

//complexNumber abs(complexNumber z);//not neccesery

void printResult(complexNumber root);

complexNumber power(complexNumber z, int power);

complexNumber div(complexNumber dividend, complexNumber divisor);// (Dividend/Divisor) = quotient.remainder hod

complexNumber mult(complexNumber first, complexNumber second);//hod

complexNumber add(complexNumber first, complexNumber second);//hod

complexNumber sub(complexNumber first, complexNumber second);// first-second hod

void printNumber(complexNumber z);//for debugging
void printPolynom(polynom* pol);
#endif //ASSIGNMENT2_ARCHIT_HEADER_H
