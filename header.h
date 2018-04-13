//
// Created by hod on 11/04/18.
//

#ifndef ASSIGNMENT2_ARCHIT_HEADER_H
#define ASSIGNMENT2_ARCHIT_HEADER_H

#include <stdbool.h>

typedef struct {
    double real;
    double imagine;
} complexNumber;

typedef struct {
    int order;
    complexNumber* coeffs;
} polynom;

typedef struct{
    double epsilon;
    complexNumber initial;
} initData;

void readInput(initData* init, polynom* pol);// reading input
double getEpsilonValue();
int getOrderValue();
int getCoeffIndex();
complexNumber getNumber();

complexNumber calcF(polynom* pol, complexNumber z);

polynom* getDeriv(polynom* pol);

complexNumber getNextZ(complexNumber z, polynom* pol_f, polynom* pol_f_deriv);

bool checkAcc(initData* init, polynom* pol, complexNumber z); //checking the root
double squareAbs(complexNumber z);//?? not neccesery ??

//arithmetic operations
complexNumber power(complexNumber z, int power);
complexNumber divide(complexNumber dividend, complexNumber divisor);// (Dividend/Divisor) = quotient.remainder hod
complexNumber mult(complexNumber first, complexNumber second);
complexNumber add(complexNumber first, complexNumber second);
complexNumber sub(complexNumber first, complexNumber second);

// for debugging
void printNumber(complexNumber z);
void printPolynom(polynom* pol);
int getCoeffPower();
void arithmaticTests();


#endif //ASSIGNMENT2_ARCHIT_HEADER_H
