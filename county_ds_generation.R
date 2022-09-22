#TRANSFORMING RAW DATA INTO AMPL.DAT FORMAT

# Loading data in df

df <- read.csv("county_facts.csv",header=TRUE)

# Selecting columns and rows of interest

df <- df[,c("state_abbreviation","RHI225214","RHI325214","RHI425214","RHI525214","RHI625214","RHI725214","RHI825214")]
colnames(df) <- c("state","%black","%native","%asian","%islander","%multiple","%hispanic","%white")
df <- df[df$state == "TX",]
df <- df[,2:dim(df)[2]]

# Standardizing percentages

for ( i in 1:dim(df)[2] ) {
  
  meanC = mean(df[,i])
  sdC = sd(df[,i])
  df[,i] = ( df[,i] - meanC ) / sdC
  
}

# Computing euclidean distance between counties (same weight for all variables)

distanceM = matrix(0,dim(df)[1],dim(df)[1])

for (i in 1:dim(df)[1]) {
  
  for (j in 1:dim(df)[1]){
    
    difVector = df[i,] - df[j,]
    distance = norm(difVector, type='2')
    distanceM[i,j] = distance
    
  }
  
}

# Formatting with numeric names of rows, columns, and parameter name "A"

distanceM <- rbind( 1:dim(distanceM)[2] , distanceM )
distanceM <- cbind( c("A",1:dim(distanceM)[1]) , distanceM  )

# Creando file 

library(MASS)
write.matrix(distanceM,file="counties1.csv")

# Guardando qué condado es cada número 

df[1:5,1:5]
a <- read.csv("county_facts.csv",header=TRUE)
a <- a[a$state_abbreviation == "TX","area_name"]
names <- data.frame("Number" = 1:length(a), "County" = a )
print(names)

