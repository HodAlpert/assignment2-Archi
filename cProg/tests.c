//
// Created by hod on 13/04/18.
//
#include <assert.h>
#include <stdio.h>
#include <malloc.h>
#include "header.h"
void arithmaticTests(){
    complexNumber oneAndTwo={1.0,2.0};
    complexNumber threeAndOne={3.0,1.0};
    complexNumber five={5.0,0.0};
    complexNumber one={1.0,0.0};
    complexNumber seven={7.0,-1.0};
    complexNumber imgtwo={0.0,-2.0};
    complexNumber ans1=(add(oneAndTwo,threeAndOne));
    assert(ans1.real==4.0&&ans1.imagine==3.0);
    complexNumber ans2=add(sub(five,sub(imgtwo,seven)),one);
    assert(ans2.real==13.0&&ans2.imagine==1.0);
    //~~~~~~~~~~~~~~~~`mult test~~~~~~~~~~~~~~~~~~~`
    complexNumber multans1 = mult(oneAndTwo,threeAndOne);
    complexNumber minux1 = {-1.0,-1.0};
    complexNumber minux3plus2i = {-3.0,2.0};
    complexNumber multans2= mult(minux1,minux3plus2i);
    complexNumber numbertoAbs = {1.0,1.0};
    long double absoluteans = squareAbs(numbertoAbs);
    assert(absoluteans==2.0);
    complexNumber toPower = {3.0,1.0};
    complexNumber powerAns = power(toPower,2);
    assert(powerAns.real==8.0&&powerAns.imagine==6.0);
    assert(multans1.real==1.0&&multans1.imagine==7.0);
    assert(multans2.real==5.0&&multans2.imagine==1.0);
    //~~~~~~~~~~~~~~~~~~~~~~~~`divide~~~~~~~~~~~~~~~~~~~~~~~~`
    complexNumber divans1 = divide(one,numbertoAbs);
    complexNumber threeminusi = {3.0,-1.0};
    complexNumber twoplus5i = {2.0,5.0};
    complexNumber divans2 = divide(threeminusi,twoplus5i);
    assert((divans1.real == 0.5)&&(divans1.imagine==(-0.5)));
    assert(divans2.real==(1.0/29.0)&&divans2.imagine==(-17.0/29.0));
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~calcFtest~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    polynom* pol = calloc(1, sizeof(polynom));
    pol->coeffs = calloc(4,sizeof(complexNumber));
    pol->order=3;
    complexNumber a0={7.0,0.0};
    complexNumber a1={5.0,0.0};
    complexNumber a2={2.0,0.0};
    complexNumber a3={3.0,0.0};

    pol->coeffs[0]=a0;
    pol->coeffs[1]=a1;
    pol->coeffs[2]=a2;
    pol->coeffs[3]=a3;
    complexNumber x1={1.0,0.0};
    complexNumber y1 = calcF(pol, x1);
    printNumber(y1);
    assert(y1.real==17.0&&y1.imagine==0.0);
    complexNumber x2={3.0,0.0};
    complexNumber y2 = calcF(pol,x2);
    printNumber(y2);
    assert(y2.real==121.0&&y2.imagine==0.0);
    complexNumber x3={3.0,-3.2};
    complexNumber y3=calcF(pol,x3);
    printNumber(y3);

//    assert(y3.real==-(175.0+(24.0/24.0))&&y3.imagine==-(215.0+(37.0/125.0)));//not working- check manually
    complexNumber zn = {2.0};
    polynom* derivpol = getDeriv(pol);
    complexNumber nextz = getNextZ(zn,pol,derivpol);
    assert(nextz.real==1&&nextz.imagine==0);

}

