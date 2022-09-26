
# Subsetting dataset

irisSS <- iris[c(1:20,51:71,101:121),3:4]
irisClas <- iris[c(1:20,51:71,101:121),3:5]

# Standardizing dataset

for (i in 1:dim(irisSS)[2]) {
  
  irisSS[,i] <- ( irisSS[,i] - mean(irisSS[,i]) ) / sd(irisSS[,1])
  
}

for (i in 1:(dim(irisClas)[2]-1)) {
  
  irisClas[,i] <- ( irisClas[,i] - mean(irisClas[,i]) ) / sd(irisClas[,1])
  
}


# Representando gráficamente el clustering correcto


library(ggplot2)

ggplot(data = irisClas, aes(Petal.Length, Petal.Width, color = Species)) +
  geom_point() +
  scale_color_manual(values = c("setosa" = "red", "versicolor" = "blue", "virginica" = "yellow"))


#Matriz de ceros

m = matrix(0,62,62)

#Rellenar matriz con distancias euclidean

for (i in 1:62) {
  
  for (j in 1:62){
    
    difVector = irisSS[i,] - irisSS[j,]
    distance = norm(difVector, type='2')
    m[i,j] = distance
    
  }
  
}

m <- round(m,2)

#Pasando a formato AMPL

m <- cbind(1:dim(m)[1],m)
m <- rbind( c( "m" , 1:(dim(m)[2]-1) ) , m)

# Checkar que está bien el formato

m[1:5,1:5]

# Exportar. (Falta eliminar "" en Text Editor)

write.table(m, file = "NuevasFlores.csv", row.names = FALSE, col.names = FALSE)

# Cargar la matriz clasificadora y convertirla a una lista que diga a qué cluster cada flor

(...)

dfClas #Nombre de la columna que dice a qué cluster pertenece cada observación.

irisClas <- cbind(irisClas, dfClas)

# Gráfico clusters

ggplot(data = irisClas, aes(Petal.Length, Petal.Width, color = dfClas)) +
  geom_point() +
  scale_color_manual(values = c("setosa" = "red", "versicolor" = "blue", "virginica" = "yellow"))







