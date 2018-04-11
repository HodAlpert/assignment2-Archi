//
// Created by hod on 11/04/18.
//

#ifndef ASSIGNMENT2_ARCHIT_HEADER_H
#define ASSIGNMENT2_ARCHIT_HEADER_H
typedef struct {
    float* real;
    float* imagine;
} complexNumber;

typedef struct {
    int order;
    complexNumber* coeffs;
} polynom;

typedef struct{
    float epsilon;
    float initial;
} initData;

void readInput(initData* init, polynom* pol);

complexNumber* f(polynom* pol, complexNumber* z);

polynom* convertDeriv(polynom* pol);

// (Dividend/Divisor) = quotient.remainder
complexNumber* div(complexNumber* dividend, complexNumber* divisor);

complexNumber* getNextZ(complexNumber* z_n, polynom* pol_f, polynom* pol_f_deriv);

bool checkAcc(initData* init, polynom* pol, complexNumber z_n);

complexNumber* abs(complexNumber* z);

void printResult(complexNumber* root);

#endif //ASSIGNMENT2_ARCHIT_HEADER_H
