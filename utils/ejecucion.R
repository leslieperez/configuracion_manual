
runExperiment <- function(command, command_line) {
  output = system2(command=command, args=command_line, stdout=TRUE, stderr=TRUE)
  # Validar que no hay error    
  if (!is.null(attr(output, "status"))) {
    cat ("\nError ejecutando comando: ", command_line, "\n")
    cat (output, "\n")
    return(NULL)
  }
  # Extraer resultados
  if (command == "java") {
    sel = which(sapply(output, grep, pattern="Best tour:", ignore.case = FALSE, value=FALSE) == 1)
    resultado = as.numeric(output[sel+1])
  } else {
    sel = which(sapply(output, grep, pattern="try 0, Best", ignore.case = FALSE, value=FALSE) == 1)
    resultado = as.numeric(strsplit(trimws(strsplit(output[sel],"," )[[1]][2]), "\\s")[[1]][2])
    #resultado = as.numeric(str_split(str_trim(str_split(output[sel],"," )[[1]][2]), "\\s")[[1]][2])
  }
  return(resultado)
}
