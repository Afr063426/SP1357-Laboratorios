#Se programa una funcion que permita obtener todo lo solicitado en el punto 1
require(tidyverse)
require(tictoc)

#Se programa una funcion para estimar lo soliticitado en el punto 1
fn_punto_1 <- function(df = iris[,-5], k = 2, nstart = 100, ...){

    df_kmeans <- data.frame(k = numeric(), 
        tot.withinss = numeric(), 
        tiempo = numeric())


    #Se realizan 100 iteraciones de k means
    for(i in 1:nstart){

    #Se ejecuta el algoritmo
    start.time <- Sys.time()
    km <- kmeans(df, centers = k, nstart = 1,...)
    end.time <- Sys.time()
    time.taken <- end.time - start.time
    df_aux <- data.frame(k = k, 
        tot.withinss = km$tot.withinss, 
        tiempo = time.taken)
    df_kmeans <- rbind(df_kmeans, df_aux)
        if(i==1){ 
            mejor_optimo <- km$tot.withinss
            mejor_km <- km
        }else if(mejor_optimo > km$tot.withinss){
            mejor_optimo <- km$tot.withinss
            mejor_km <- km
        }
    
    }
    
    optimo_promedio <- mean(df_kmeans$tot.withinss)

    atraccion_mejor_optimo <- sum(df_kmeans$tot.withinss == mejor_optimo)/nrow(df_kmeans)*100

    #Grafico de los optimos locales
    plot_optimos <- df_kmeans %>%
        ggplot(aes(x = tot.withinss)) +
        geom_histogram() + 
        theme_minimal() +
        labs(x = "Optimos locales", 
        y = "Cantidad")

    plot_tiempo <- df_kmeans %>%
        ggplot(aes(x = tiempo)) +
        geom_histogram() + 
        theme_minimal() +
        labs(x = "Tiempo en segundos\n convergencia k-means", 
        y = "Cantidad")
    #Se retorna una lista de parametros de relevancia para el laboratior
    return(list(informacion_general = list(df = df,
            df_kmeans = df_kmeans,
            mejor_km = mejor_km), 
            resumen = list(plot_optimos = plot_optimos,
            plot_tiempo = plot_tiempo,
            optimo_promedio = optimo_promedio,
            mejor_optimo = mejor_optimo, 
            atraccion_mejor_optimo = atraccion_mejor_optimo
            )
        ))


}

