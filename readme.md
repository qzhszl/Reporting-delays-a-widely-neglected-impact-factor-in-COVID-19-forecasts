# **Reporting delays: a widely neglecting impact factor in COVID-19 forecasts**


### **Summmary**

This repository contains the codes to 1. generate a SIRD epidemic model, 2. uncover the reported delay for real data or generated synthetic data and 3. plot the evidence for reporting delays, which is described in the paper [Reporting delays: a widely neglecting impact factor in COVID-19 forecasts](https://arxiv.org/abs/2304.11863). If you use these codes, please cite the original paper and this repository. There are 6 main files in the repository:
1. polyapdf.m:
Polya-Aeppli probability density function
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

### Examples
```
L1 = 100;
x = 1:100;
r_D = 0.7;
theta_D = 0.5;
P_D=polyapdf(x,r_D,theta_D)
```

## **2. odefcn.m**
Within the SIRD model, the population is split into four compartments: susceptible $S$, infectious $I$, recovered $R$, and deceased $D$. Compartment $S$ denotes the fraction of susceptible individuals, who can be infected by infectious individuals. Compartment $I$ denotes the fraction of individuals, who have been infected but have not recovered or are deceased. Compartments $R$ and $D$ are respectively the fractions of individuals, who have recovered or are deceased. The SIRD model assumes that recovered individuals become immune and cannot be infected by the virus in the future. Further, the SIRD model assumes the uniform mixing of the Infectious and Susceptible sub-populations. As a result, the discrete-time transitions between the compartments are governed by first-order difference time equations
- $I[k+1]-I[k]  = \beta {I[k]S[k]}-(\gamma_r+\gamma_d){I[k]}$
- $R[k+1]-R[k] = \gamma_{r} {I[k]}$
- $D[k+1]-D[k] = \gamma_{d} {I[k]}$
- ${S[k]} + {I[k]} + {R[k]} + {D[k]} = 1$
where $\beta$, $\gamma_r$ and $\gamma_d$ are the infection, the recovery, and the deceased probabilities, respectively.

dydt=odefcn(y,N,beta,gammar,gammam) returns the differential equations of a SIRD epidemic model.

A SIRD model described in the paper can be obtained utilizing this function, which is shown in the example below.

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

### Examples
```
beta=0.5;
gammar=0.2;
gammam=0.05;
N=1;
tspan=0:0.1:100;
y0=[99990/100000,10/100000,0,0];
[t,y]=ode45(@(t,y) odefcn(y,N,beta,gammar,gammam),tspan,y0); % Generate an SIRD model. t: the time span of the SIRD model and y: the fraction of each case(S I R D) in each timespan.
```

## **3. infer_reporting_delays_realdata.m**
Uncover reporting delay with real data as described in the paper. 

In our statistical framework, we assume that the reporting delays correspond to three datasets, $Y = \{ I, R, D\}$, which are all characterized by the Polya-Aeppli distribution, albeit with different parameters  $\kappa=(\lambda_{I},\theta_{I},\lambda_{R},\theta_{R},\lambda_{D},\theta_{D})$. 
With the choice of the Polya-Aeppli distribution, the reporting delays $\Delta \widetilde{Y}$ in our basic equation can be determined in parameterized form $\Delta\widetilde{Y}\kappa$.
Given the incremental time series $\Delta \widetilde{Y}\kappa$, the cumulative time series $\widetilde{Y}\kappa$ are given by
- $\widetilde{I}\kappa[k+1] = \widetilde{I}\kappa[k]  + \Delta \widetilde{I} \kappa[k] - \Delta \widetilde{R}\kappa[k] - \Delta \widetilde{D}\kappa[k]$
- $\widetilde{R}\kappa[k+1] = \widetilde{R}\kappa[k]  + \Delta \widetilde{R} \kappa[k]$
- $\widetilde{D}\kappa[k+1] = \widetilde{D}\kappa[k]  + \Delta \widetilde{D} \kappa[k]$
for $k \geq 0$, and $\widetilde{I}\kappa[0]=\widetilde{R}\kappa[0]=\widetilde{D}\kappa[0]=0$. 

The main assumption of our reporting delay removal framework is that the increments in new recovered $\Delta R$ and deceased $\Delta D$ individuals are proportional to the cumulative fraction of infectious individuals $I$.
Therefore, we determine the "best" parameters $\bar{\kappa}$ that maximize the product of pairwise correlations among the three epidemic time series in $\widetilde{Y}\kappa$:
$O_{b}(\widetilde{Y}\kappa) \equiv O_{b}(\widetilde{I}\kappa,\Delta \widetilde{R}\kappa, \Delta \widetilde{D}\kappa) = \rho (\Delta \widetilde{R}\kappa, \Delta \widetilde{D}\kappa) \rho (\widetilde{I}\kappa, \Delta \widetilde{R}\kappa) \rho (\widetilde{I}\kappa, \Delta \widetilde{D}\kappa)$,
where $\rho(X,Y)$ is the Pearson correlation coefficient between time series $X$ and $Y$. The objective function $O_{b}(\widetilde{Y}\kappa)$ reaches its maximum value of $1$ when all three pairwise correlations among the $\widetilde{I}\kappa$, $\Delta \widetilde{R}\kappa$ and $\Delta \widetilde{D}\kappa $ time series are 1, which we expect when recovery $\gamma_r$ and deceased $\gamma_d$ epidemic probabilities are constant. Due to the nature of the Pearson correlation coefficient, the objective function $O_{b}(\widetilde{Y}\kappa[k]) = O_{b}(\widetilde{Y}\kappa[k-T])$ is invariant under the constant time shift $T$ of the epidemic data. As a result, we can only infer the reporting delays up to a constant time shift $T$.

In this repository, we present an example of uncovering the reporting delay in Spain. 

### Dependencies
Matlab (version>=2012a)

### Usage
#### Input
- i_cnov.xlsx   %an excel file number of daily infected cases
- r_cnov.xlsx   %number of daily recovered cases
- d_cnov.xlsx   %number of daily deceased cases
#### Output
- dydt: 4*1 vector dydt(1) contains the derivative of S; dydt(2) contains the derivative of I; dydt(3) contains the derivative of R; dydt(4) contains the derivative of D



