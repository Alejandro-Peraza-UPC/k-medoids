# "k-medoids"

param m; # Number of points
param k; # Number of clusters
set M:= {1..m};

# Distance matrix
param d {M, M};

var x{M, M} binary; # Decision variable. 1 if i belongs to cluster-j

minimize f: sum{i in M, j in M} d[i, j] * x[i, j];
subject to one_cluster{i in M}: sum{j in M} x[i, j] = 1;
subject to k_clusters: sum{j in M} x[j,j] = k;

# Formulation 1
subject to belongs_to{i in M, j in M}: x[j,j] >= x[i,j];

# Formulation 2
#subject to belongs_to{j in M}: m * x[j,j] >= sum{i in M} x[i,j]


 