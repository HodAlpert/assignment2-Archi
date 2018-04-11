//
// Created by hod on 11/04/18.
//

#ifndef ASSIGNMENT2_ARCHIT_HEADER_H
#define ASSIGNMENT2_ARCHIT_HEADER_H

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
    complexNumber* initial;
} initData;

void readInput(initData* init, polynom* pol);

void f(polynom* pol, complexNumber* z); // function changes the given number

polynom* getDeriv(polynom* pol);//hod

void clearComplexNumber(complexNumber* z);

void getNextZ(complexNumber* z, polynom* pol_f, polynom* pol_f_deriv); // function changes the given number

bool checkAcc(initData* init, polynom* pol, complexNumber* z);

complexNumber* abs(complexNumber* z);

void printResult(complexNumber* root);

// (Dividend/Divisor) = quotient.remainder
complexNumber* power(complexNumber* z, int power);

complexNumber* div(complexNumber* dividend, complexNumber* divisor);

complexNumber* mult(complexNumber* first, complexNumber* second);

complexNumber* add(complexNumber* first, complexNumber* second);

complexNumber* sub(complexNumber* first, complexNumber* second);


#endif //ASSIGNMENT2_ARCHIT_HEADER_H
