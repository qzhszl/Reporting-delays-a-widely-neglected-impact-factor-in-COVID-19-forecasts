# **Reporting delays: a widely neglecting impact factor in COVID-19 forecasts**


### **Summmary**

This repository contains the codes to 1. generate a SIRD epidemic model, 2. uncover the reported delay for real data or generated synthetic data and 3. plot the evidence for reporting delays, which are described in the paper [Reporting delays: a widely neglecting impact factor in COVID-19 forecasts](https://arxiv.org/abs/2304.11863). If you use these codes, please cite the original paper and this repository. There are 6 main files in the repository:
1. polyapdf.m:
Return a Polya-Aeppli probability density function.
2. odefcn.m:
dydt=odefcn(y,N,beta,gammar,gammam) returns the differential equations of an SIRD epidemic model.
3. infer_reporting_delays_realdata.m:
Uncover reporting delay with real data(e.g. Spain).
4. SIRD_report_delay_synethic.m:
Uncover reporting delay with generated synthetic datasets.
5. Camp_Scatter.py:
Plot the correlation between the fractions of infected $\tilde{I}$, recovered $\Delta \tilde{R}$, and deceased $\Delta\tilde{D}$ individuals.
6. correlation.m:
Plot the fractions of infected $\tilde{I}$, recovered $\Delta \tilde{R}$, and deceased $\Delta\tilde{D}$ individuals with the change of time span (days).

## **1. polyapdf.m**
Return the Polya-Aeppli probability density function as described in the paper. 
Two parameters **lambda** and **theta** determine the mean value $E[T]=\lambda/\theta$ and variance $Var[T]=\lambda (2-\theta)/\theta^2$
### Dependencies
Matlab (version>=2012a)

### Usage
#### Parameters
- x: 1*n vector, where x(i)=i, i is an integer from 1 to n.
- lambda: lambda>0.
- theta: 0 <= theta <=1.
#### Output
- y: 1*n vector. Polya-Aeppli probability density function with the input lambda and theta.

### Examples
```
x = 1:100;
lambda_D = 0.7;
theta_D = 0.5;
P_D=polyapdf(x,lambda_D,theta_D)
```

## **2. odefcn.m**
Within the SIRD model, the population is split into four compartments: susceptible $S$, infectious $I$, recovered $R$, and deceased $D$. Compartment $S$ denotes the fraction of susceptible individuals, who can be infected by infectious individuals. Compartment $I$ denotes the fraction of individuals, who have been infected but have not recovered or are deceased. Compartments $R$ and $D$ are respectively the fractions of individuals, who have recovered or are deceased. The SIRD model assumes that recovered individuals become immune and cannot be infected by the virus in the future. Further, the SIRD model assumes the uniform mixing of the Infectious and Susceptible sub-populations. As a result, the discrete-time transitions between the compartments are governed by first-order difference time equations
- $I[k+1]-I[k]  = \beta {I[k]S[k]}-(\gamma_r+\gamma_d){I[k]}$
- $R[k+1]-R[k] = \gamma_{r} {I[k]}$
- $D[k+1]-D[k] = \gamma_{d} {I[k]}$
- ${S[k]} + {I[k]} + {R[k]} + {D[k]} = 1$

where $\beta$, $\gamma_r$ and $\gamma_d$ are the infection, the recovery, and the deceased probabilities, respectively.

dydt=odefcn(y,N,beta,gammar,gammam) returns the differential equations of a SIRD epidemic model.

A SIRD model(infectious $I[k]$, recovered $R[k]$, and deceased $D[k]$ time series epidemic data) described in the paper can be obtained utilizing this function, which is shown in the example below.

### Dependencies
Matlab (version>=2012a)

### Usage
#### Parameters
- y: 1*4 vector. In the example below, y0 contains the initial fractions cases (i.e. S I R D).
- N: normalized parameter (default N = 1). If the input elements in y are not fractions, but the exact number of cases (e.g. the number of infected individuals), then we let N equal the total size of the dataset, i.e., the sum of the number of individuals in S, I, R and D state.
- beta: infection rate.
- gammar: recovery rate.
- gammam: deseased rate.
#### Output
- dydt: 4*1 vector. dydt(1) contains the derivative of S; dydt(2) contains the derivative of I; dydt(3) contains the derivative of R; dydt(4) contains the derivative of D.

### Examples
```
beta=0.5;
gammar=0.2;
gammam=0.05;
N=1;
tspan=0:0.1:100;
y0=[99990/100000,10/100000,0,0];
[t,y]=ode45(@(t,y) odefcn(y,N,beta,gammar,gammam),tspan,y0); % Generate an SIRD model. t: the time span of the SIRD model and y: the fraction of each case(S I R D) for each timespan.
```

## **3. infer_reporting_delays_realdata.m**
Uncover reporting delay with real data as described in the paper. 

For a SIRD model introduced in the paper and in **2. odefcn.m**, the population is split into four compartments S I R D. Each compartment is a time series of values, each corresponding to a specific observation time. For brevity, we refer to the triplet of infectious, recovered, and deceased data as $Y = \{I,R,D\}$. **All values contained in the $Y$ time series are fractions of individuals found in the corresponding state on a specific day.**
For instance, $I[k]$ corresponds to the fraction of individuals who are infectious on day $k$. Since COVID-19 reported data often is advertised in the form of changes in the number of epidemic cases, we find it convenient to introduce the daily changes in epidemic data as $\Delta Y[k]$ for $Y = \{I,R,D\}$.} Further, in this work, we operate with reported epidemic data $\tilde{Y}$ and inferred data $\hat{Y}$. Since reported and inferred data are expected to differ from the true data $Y$, we need to distinguish the three. The notation is shown in the table below.
| Cumulative Quantities  | Quantity Increments |
| ------------- | ------------- |
| $Y$:fractions of cases  | $\Delta Y$:fractions of new cases  |
|$\widetilde{Y}$:fractions of reported cases  | $\Delta \widetilde{Y}$:fractions of reported new cases |
|$\hat{Y}$:fractions of predicted cases  | $\Delta \hat{Y}$:fractions of predicted new cases  |

Specifically, the daily epidemic reports are used to construct the fraction of infected individuals as $\tilde{I}[k] = \sum_{\ell}\left(\Delta \tilde{I} [\ell] - \Delta \tilde{R} [\ell] - \Delta \tilde{D} [\ell]\right)$, where $\ell=0:k-1$.

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
where $\rho(X,Y)$ is the Pearson correlation coefficient between time series $X$ and $Y$. The objective function $O_{b}(\widetilde{Y}\kappa)$ reaches its maximum value of $1$ when all three pairwise correlations among the $\widetilde{I}\kappa$, $\Delta \widetilde{R}\kappa$ and $\Delta \widetilde{D}\kappa$ time series are 1, which we expect when recovery $\gamma_r$ and deceased $\gamma_d$ epidemic probabilities are constant. Due to the nature of the Pearson correlation coefficient, the objective function $O_{b}(\widetilde{Y}\kappa[k]) = O_{b}(\widetilde{Y}\kappa[k-T])$ is invariant under the constant time shift $T$ of the epidemic data. As a result, we can only infer the reporting delays up to a constant time shift $T$.

In this repository, we present an example of uncovering the reporting delay in Spain. 

### Dependencies
Matlab (version>=2012a)

infer_reporting_delays_realdata.m, odefcn.m, polyapdf.m, i_cnov.xlsx, r_cnov.xlsx and d_cnov.xlsx should be in the same dictionary. 

### Usage
#### Input
- i_cnov.xlsx: Number of daily infected cases I time series. In the Excel file, the first row is the date, and the second row is the number of reported cases.
- r_cnov.xlsx: Number of daily recovered cases R time series. In the Excel file, the first row is the date and the second row is the number of reported cases.
- d_cnov.xlsx: Number of daily deceased cases D time series. In the Excel file, the first row is the date and the second row is the number of reported cases.
These three Excel files should have the same dimension, i.e., for a specific date, the Excel should have all I, R and D data.
#### Output

a = $\[\theta_D, \theta_I, \theta_R, \lambda_D, \lambda_I, \lambda_R\]$

## **4. SIRD_report_delay_synethic.m**
Uncover reporting delay with generated synthetic datasets as described in the paper.

The code generated $k$ SIRD epidemic model datasets with different epidemic parameters and added synthetic reported delays to the obtained times series.
With the generated dataset with delays, the inferred model is executed to recover the generated SIRD model data without delays.

### Dependencies
Matlab (version>=2012a)

SIRD_report_delay_synethic.m, odefcn.m and polyapdf.m should be in the same dictionary. 

### Usage
#### Parameters
- beta: infection rate of the SIRD model. Modify line 10 if you want to change beta.
- gammar: infection rate of the SIRD model. Modify line 11 if you want to change gammar.
- gammam: infection rate of the SIRD model. Modify line 12 if you want to change gammam.
- knum: number of generated SIRD epidemic models. Modify line 39 if you want to change knum
These three excel files should have the same dimension, i.e. for a specific date, the excel should have all I, R and D data.
#### Output
- save saverandomnb.mat: A $k$*10 matrix, the first 6 elements in each row save the parameters $\[\theta_D, \theta_I, \theta_R, \lambda_D, \lambda_I, \lambda_R\]$ of the inferred Polya-Aeppli probability distribution for the $k$-th SIRD model. The 7-th element saves the inferred $O_{b}(\widetilde{Y}\kappa)$. The 8th, 9th and 10th elements respectively save the Pearson correlation coefficients $\rho (\widetilde{I}\kappa, \Delta \widetilde{D}\kappa)$, $\rho (\widetilde{I}\kappa, \Delta \widetilde{R}\kappa)$ and $\rho (\Delta \widetilde{R}\kappa, \Delta \widetilde{D}\kappa)$.
- save trueparameters.mat: A $k$*6 matrix, each row saves the parameters $\[\theta_D, \theta_I, \theta_R, \lambda_D, \lambda_I, \lambda_R\]$ of the added Polya-Aeppli probability distribution for the $k$-th SIRD model


## **5. Camp_Scatter.py:**
Plot the correlation between the fractions of infected $\tilde{I}$, recovered $\Delta \tilde{R}$, and deceased $\Delta\tilde{D}$ individuals, as shown in Fig.1 b, c, e, f, h, i, k, l of the paper. 
In this repository, we present an example of plotting the correlation between infected $\tilde{I}$ and deceased $\Delta\tilde{D}$ on synthetic epidemic data generated with reported delays. Synthetic reporting delays were generated with the Polya-Aeppli distributions. 
### Dependencies
python3
Camp_Scatter.py and synethic_ID.xlsx should be in the same dictionary. 

### Usage
#### Input
- synethic_ID.xlsx: Excel file. Two rows respectively include two of the fractions of infected $\tilde{I}$, recovered $\Delta \tilde{R}$, and deceased $\Delta\tilde{D}$ individuals time series. In our provided example, the first row is $\tilde{I}$ while the second row is $\Delta\tilde{D}$.

#### Output
- A scatter figure. In the provided example, the x-axis represents $\tilde{I}$ while the y-axis is $\Delta\tilde{D}$.



## **6. correlation.m:**
Plot the fractions of infected $\tilde{I}$, recovered $\Delta \tilde{R}$, and deceased $\Delta\tilde{D}$ individuals with the change of time span (days), as shown in Fig.1 a,d,g,j of the paper. 
In this repository, we present an example of plotting synthetic epidemic data generated with reported delays. Synthetic reporting delays were generated with the Polya-Aeppli distributions. 
### Dependencies
Matlab (version>=2012a)

correlation.m Idelay.xlsx, Rdelay.xlsx and Ddelay.xlsx should be in the same dictionary. 

### Usage
#### Input
- Idelay.xlsx: Excel file. The fractions of infected $\tilde{I}$ individuals time series. 
- Rdelay.xlsx: Excel file. The fractions of recovered $\Delta \tilde{R}$ individuals time series.
- Ddelay.xlsx: Excel file. The fractions of deceased $\Delta\tilde{D}$ individuals time series.

#### Output
- A figure: the fractions of infected $\tilde{I}$, recovered $\Delta \tilde{R}$, and deceased $\Delta\tilde{D}$ individuals with the change of time span (days).
