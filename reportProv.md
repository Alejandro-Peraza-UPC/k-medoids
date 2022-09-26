# **Cluster - Median Problem**

### Alejandro Peraza González <!-- omit in toc -->
### Miguel Benítez Humanes <!-- omit in toc -->

- [**Cluster - Median Problem**](#cluster---median-problem)
  - [**Introduction**](#introduction)
  - [**Section 2**](#section-2)
    - [Section 2.1 Definition of the clustering optimization problem](#section-21-definition-of-the-clustering-optimization-problem)
      - [Formulation 1](#formulation-1)
      - [Formulation 2](#formulation-2)
    - [Section 2.2 Testing the two alternative formulations](#section-22-testing-the-two-alternative-formulations)
    - [Section 2.3: Optimal Branch and Bound solution for the cluster-median problem](#section-23-optimal-branch-and-bound-solution-for-the-cluster-median-problem)
  - [(REST OF SECTIONS)](#rest-of-sections)

## **Introduction**



In this report we compare the solutions to a Cluster-Median problem provided by different optimization methods and heuristics:

- In section 2 we implement the branch and bound method to find the optimal solution to the k-medoid clustering optimization problem. We consider two possible formulations of the optimization problem. We show that one of them is more efficient to solve a clustering problem for a reduced dataset. We then implement the optimal formulation to solve a clustering problem for a bigger dataset.

- In section 3 we solve the same clustering problem again, but using the Minimum Spanning Tree heuristic. (CONTINUAR...)

- In section 4 we try the k-means heuristic, implemented with Python's scikit learn library. (CONTINUAR...)

- In section 5 we compare the results of the three methods and state the main conclusions of the project

## **Section 2**

### Section 2.1 Definition of the clustering optimization problem

We would like to generate k clusters in which the different observations of a dataset are grouped by similarity. That is, each observation $x_{i}$ will be included in the cluster whose center $x_{j}$ is the closest in "distance" to $x_{i}$ among the center points of all the k clusters generated. 

We will define the distance between two observations of a dataset as the euclidean distance between them. We standardize all variable values for the observations before computing the distance.

This problem is one of integer programming (IP) which could be formulated as follows:

#### Formulation 1

$\sum_{i = 1}^{n}\sum_{j = 1}^{n}d_{ij}*x_{ij}$

subject to:

$\sum_{i = 1}^{n}x_{ij}=1,$ $\forall$ $i=1,..,n$

$\sum_{j = 1}^{n}x_{jj}=k$

$x_{jj}$ $\geq$ $x_{ij},$ $\forall$ $i,j=1,..,n$

$x_{ij}$ $\in$ {0,1}


- $x_{ij}$ is a variable that is 1 if observation i belongs to the j-th cluster. That is, the cluster whose center is observation j. 


- The objective function minimizes the sum of the distances between each observation and the center of the cluster to which they belong. 

- The first set of n constraints ensures that each observation will be allocated exactly to one cluster

- The second constraint ensures that only k clusters will be generated

- The last set of constraints ensures that the center of the j-th cluster belongs to that same cluster. There are $n^2$ constraints. 


Another possibility that reduces the number of constraints is: 


#### Formulation 2

$\sum_{i = 1}^{n}\sum_{j = 1}^{n}d_{ij}*x_{ij}$

subject to:

$\sum_{i = 1}^{n}x_{ij}=1,$ $\forall$ $i=1,..,n$

$\sum_{j = 1}^{n}x_{jj}=k$

$n*x_{jj}$ $\geq$ $\sum_{i = 1}^{n}x_{ij},$ $\forall$ $i,j=1,..,n$

$x_{ij}$ $\in$ {0,1}

- The third set of restrictions from the previous formulation is summed for all j to reduce the number of constraints to a total of n

(CONFIRMAR CON PROFESOR QUE ES POR ESTO)Even though the second formulation has less constraints, the feasible set for its linear relaxation is bigger. This means that the lower bound computed to solve the optimization problem is smaller or equal to the one computed for the linear relaxation of Formulation 1. Therefore, Formulation 1 is potentially faster. 

### Section 2.2 Testing the two alternative formulations

To test which formulation is faster, we use a small dataset which is a subset of the "iris" dataset, one built in dataset in R programming language. 

Our subset containts 62 observations of three different types of flowers for which we specify two variables: petal length and petal width.

**Results**


Correct Clustering             |  Calculated clustering
:-------------------------:|:-------------------------:
![](Im%C3%A1genes%20del%20proyecto.%20Parte%201/Clustering%20correcto%20flores.png)  |  ![](Im%C3%A1genes%20del%20proyecto.%20Parte%201/Clustering%20Flores.png)

The calculated clustering solution varies in two flowers (60 hits / 2 misses) with the correct clustering. Those flowers were from the group *versicolor*. The two clusters *versicolor* and *virginica* partially mix in the frontier between them, which leads to the error obtained in our own clustering.


Formulation 1             |  Formulation 2
:-------------------------:|:-------------------------:
![](Im%C3%A1genes%20del%20proyecto.%20Parte%201/Flores%20Resultados%20Form%201.jpeg)  |  ![](Im%C3%A1genes%20del%20proyecto.%20Parte%201/Flores%20Resultados%20Form%202.jpeg)



(Por qué usa el MIP simplex) 

We confirm that formulation 1 is more efficient. Therefore, this is the implementation of the optimization problem we will use to create the clusters for the dataset in next section. 

### Section 2.3: Optimal Branch and Bound solution for the cluster-median problem

Throughout the rest of the report, we will use a dataset which contains the percentage of population belonging to each ethnicity, for the 254 counties of the state of Texas. 

After standardizing the percentages, the euclidean distance between each observation is computed and included in a matrix which corresponds to "d" in the previous formulations. 

The results are the following for k= 3, 5 and 10 clusters: 


K = 3             |  K = 5 | K = 10
:-------------------------:|:-------------------------:|:-------------------------:
![](Im%C3%A1genes%20del%20proyecto.%20Parte%201/Clustering%20Condados%20k%3D3.png)  |  ![](Im%C3%A1genes%20del%20proyecto.%20Parte%201/Clustering%20Condados%20k%3D5.png) |  ![](Im%C3%A1genes%20del%20proyecto.%20Parte%201/Clustering%20Condados%20k%3D10.png)
![](Imagenes%20del%20proyecto%20TX/TexasK3.png)  |  ![](Imagenes%20del%20proyecto%20TX/TexasK5.png) |  ![](Imagenes%20del%20proyecto%20TX/TexasK10.png)


(MAPA DE LOS RESULTADOS)
(DEBAJO DEL MAPA DE LOS RESULTADOS PONER ALGUNOS FUN FACTS SOBRE
LO QUE HAY EN CADA GRUPO, EN LETRA PEQUEÑA)

Even though the number of observations is not too large, the solver took a relatively noticeable amount of time in computing the optimal solution. For larger problems (for instance repeating the same problem for the three thousand counties in the US), this could be an issue. We are therefore interested in heuristics that reduce the computation time and provide clusters that are not too different to the optimal ones. We explore this in the following sections. 

## (REST OF SECTIONS)

