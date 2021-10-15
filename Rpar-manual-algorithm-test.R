# Script para ejecutar pruebas sistematicas 
# de parametros con ACOTSP

# cargar librerias 
suppressMessages(require("stringr"))
suppressMessages(require("parallel"))
source("utils/ejecucion.R")
source("utils/boxplot.R")

# Ruta al ejecutable del algoritmo
exe = "ACOTSP-1.03/acotsp"
cores = 6

# Instancia para evaluar el algoritmo
instancia = "-i instances/rat783.tsp"

# Defina el tiempo definido para cada ejecucion
exe_args = "--tries 1 --time 10 --quiet"

# Defina parametros fijos
param_fijos = "--ants 10"

# Defina el parametro que se va a evaluar
param_test = "--"
values_test = c("as", "ras", "eas", "mmas", "acs")

#param_test = "--alpha"
#values_test = c("0.1", "0.25", "0.5", "1.0", "1.5", "2.0")

# Linea de parameteros de prueba
test_lines = paste(param_test, values_test, sep="")

# Numero de repeticiones por instancia
runs = 10
semillas = round(runif(runs) * 100000)

# Variable para guardar experimentos
resultados = matrix(NA, ncol=length(values_test), nrow=runs)
colnames(resultados) = values_test

cat ("Instancia: ", instancia)
cat ("\nParametro: ", param_test)

command_lines <- c()
# Crear las lineas de comando
for (i in 1:length(test_lines)) {
  for (j in 1:runs) {
    # Crear linea de comando
    command_lines = c(command_lines, paste(exe_args, param_fijos, instancia, test_lines[i], "--seed", semillas[j]))
  }
}

# Ejecutar los experimentos
cat("\nEjecutando ", length(command_lines), " experimentos...\n")
all_output = mclapply(command_lines, runExperiment, mc.cores = cores, command=exe)
print("\n")

# Obtener resultados
k = 1
for (i in 1:(length(command_lines)/runs)) {
  cat ("\n  Valor: ", values_test[i])
  for (j in 1:runs) {
    resultados[j,i] = all_output[[k]]
    cat ("\n    semilla",semillas[j],": ", resultados[j,i])
    k = k + 1
  }
  
}

# Escribir los resultados a un archivo
filename = paste("resultados", param_test, ".txt", sep="")
cat("\nGuardando archivo", filename, "\n")
write.table(resultados, file=filename, sep=";", row.names=FALSE, 
            col.names=colnames(resultados), quote=FALSE)

#Plot details in the file boxplot.R
filename_plot = paste("resultados", param_test, ".png", sep="")
do.boxplot(data.matrix=resultados, output=filename_plot)

