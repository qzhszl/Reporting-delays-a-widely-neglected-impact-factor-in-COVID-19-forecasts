# **Reporting delays: a widely neglecting impact factor in COVID-19 forecasts**


### **Summmary**

This repository contains the codes to 1. generate a SIRD epidemic model, 2. uncover the reported delay for real data or generated synthetic data and 3. plot the evidence for reporting delays, which is described in the paper [Reporting delays: a widely neglecting impact factor in COVID-19 forecasts](https://arxiv.org/abs/2304.11863). If you use these codes, please cite the original paper and this repository. There are 6 main files in the repository:
1. polyapdf.m:
Neyman type A probability density function
2. odefcn.m:
dydt=odefcn(y,N,beta,gammar,gammam) returns the differential equations of an SIRD epidemic model
3. infer_reporting_delays_realdata.m:
Uncover reporting delay with real data(e.g. Spain)
4. SIRD_report_delay_synethic.m:
Uncover reporting delay with generated synthetic datasets
5. Camp_Scatter.py:
Plot the relation between I, delta R and delta D
6. correlation.m:
Plot reported I, delta R and delta D with the change of Day.

## **1. polyapdf.m**
Return the Polya-Aeppli probability density function as described in the paper. Two parameters **lambda** and **theta** determine the mean value and variance.
### Dependencies
Matlab (version>=2012a)

### Usage
#### Parameters
- x: 1*n vector, where x(i)=i, i is an integer from 1 to n
- lambda: lambda>0
- theta: 0 <= theta <=1 
#### Output
- y: 1*n vector with the Polya-Aeppli probability density function

#### Examples
```
L1 = 100;
x = 1:100;
r_D = 0.7;
theta_D = 0.5;
P_D=polyapdf(x,r_D,theta_D)
```

## **2. odefcn.m**
dydt=odefcn(y,N,beta,gammar,gammam) returns the differential equations of a SIRD epidemic model as described in the paper.

### Dependencies
Matlab (version>=2012a)

### Usage
#### Parameters
- y: 1*4 vector, in the example below, y0 contains the initial fractions cases(i.e.S I R D)
- N: normalized parameter(default N = 1). If the input in y is not a fraction but not the exact number of cases, then we let N equal the total size of the dataset, including all the S I R D data.
- beta: infection rate
- gammar: recovery rate
- gammam: deseased rate
#### Output
- dydt: 4*1 vector dydt(1) contains the derivative of S; dydt(2) contains the derivative of I; dydt(3) contains the derivative of R; dydt(4) contains the derivative of D

#### Examples
```
beta=0.5;
gammar=0.2;
gammam=0.05;
N=1;
tspan=0:0.1:100;
y0=[99990/100000,10/100000,0,0];
[t,y]=ode45(@(t,y) odefcn(y,N,beta,gammar,gammam),tspan,y0); % return t: the time span of the SIRD model and y: the fraction of each case(S I R D) in each timespan.
```

## **3. infer_reporting_delays_realdata.m**
Uncover reporting delay with real data(e.g. Spain)

### Dependencies
Matlab (version>=2012a)

### Usage
#### Parameters
- infected0=xlsread('i_cnov.xlsx')   %number of daily infected cases
- recovered0=xlsread('r_cnov.xlsx'); %number of daily recovered cases
- death0=xlsread('d_cnov.xlsx');     %number of daily deceased cases
#### Output
- dydt: 4*1 vector dydt(1) contains the derivative of S; dydt(2) contains the derivative of I; dydt(3) contains the derivative of R; dydt(4) contains the derivative of D

#### Examples
```
- infected0=xlsread('i_cnov.xlsx')   %number of daily infected cases
- recovered0=xlsread('r_cnov.xlsx'); %number of daily recovered cases
- death0=xlsread('d_cnov.xlsx');     %number of daily deceased cases
```

