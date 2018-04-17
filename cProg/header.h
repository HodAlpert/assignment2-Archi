//
// Created by hod on 11/04/18.
//

#ifndef ASSIGNMENT2_ARCHIT_HEADER_H
#define ASSIGNMENT2_ARCHIT_HEADER_H

#include <stdbool.h>

typedef struct {
    long double real;
    long double imagine;
} complexNumber; // 16 byte = 0x10

typedef struct {
    int order;
    complexNumber* coeffs;
} polynom; // 4+6=12 but! compiler adds room for padding.. so: 0x10

typedef struct{
    long double epsilon;
    complexNumber initial;
} initData; // 16+8=24 byte = 0x18

void readInput(initData* init, polynom* pol);// reading input
long double getEpsilonValue(char *line);
int getOrderValue(char *line);
int getCoeffIndex(char *line);
complexNumber getNumber(char *line);

complexNumber calcF(polynom* pol, complexNumber z);

polynom* getDeriv(polynom* pol);

complexNumber getNextZ(complexNumber z, polynom* pol_f, polynom* pol_f_deriv);

int checkAcc(initData* init, polynom* pol, complexNumber z); //checking the root
long double squareAbs(complexNumber z);//?? not neccesery ??

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
