R Markdown
----------

Aqui cosas sobre limpieza de semillas
=====================================

TODO
----

-   Organizar toda la información en este repo
-   Ver el repo <https://github.com/ajpelu/lifeadap/blob/master/README.md> y traer la info aqui

Semillas 2017
=============

-   Pesadas el día 12/09/2018

``` r
df <- data.frame(
pesos = c(1.0454,1.2898,0.9596,0.3618,0.6851),
n = c(72,91,68,25,49))

df$avg1 <- (df$pesos/df$n)

pesototal <- 8.7341 + 11.0661 + 6.8741 + 4.3417
min(df$avg1)
```

    ## [1] 0.01398163

``` r
ntotal <- pesototal / mean(df$avg1)
ntotal_Upper <- pesototal / min(df$avg1)
ntotal_Lower <- pesototal / max(df$avg1)

ntotal
```

    ## [1] 2176.303

``` r
ntotal_Lower
```

    ## [1] 2136.17

``` r
ntotal_Upper
```

    ## [1] 2218.339

Hay 2176.3 semillas (2136.17 - 2218.34)
