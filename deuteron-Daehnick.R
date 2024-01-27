## Calculate the elastic scattering optical model potentials from
## Daehnick, W. W. et al., PRC 21 (1980) 2253

#E <- 18.7*22/20    # deuteron energy in MeV
#A <- 20      # Target mass in AMU
#Z <- 10      # Target charge
E <- 21.0-2.8347      # deuteron lab energy in MeV
A <- 40      # Target mass in AMU
Z <- 20       # Target charge

###############################################
## Real Parts
V <- 88.5 - 0.26*E + 0.88*Z*A^{-1/3}
rr <- 1.17
ar <- 0.709 + 0.0017*E 

beta <- -(E/100)^2
mu <- ((c(8,20,28,50,82,126)-(A+Z))/2)^2

## Imaginary Surface parts
Ws <- (12.2+0.026*E)*exp(beta)
rs <- 1.325
as <- 0.53+0.07*A^{1/3}-0.04*sum(exp(-mu))

## Imaginary Volume parts
Wv <- (12.2 + 0.026*E)*(1-exp(beta))
rv <- rs
av <- as

## Spin-Orbit parts
Vso <- 7.33-0.029*E
rso <- 1.07
aso <- 0.66

## Coulomb radius
rc <- 1.300

##############################################
cat("\nThe Parameters obtained from")
cat(" Daehnick, W. W. et al., Phys. Rev. C 21, 2253 (1980):\n")

cat("\n--- Coulomb Part ---\n")
cat("rc  =",formatC(rc,digits=3,format="f"),"\n")

cat("\n--- Real Parts ---\n")
cat("V   =",formatC(V,digits=3,format="f"),"\n")
cat("rr  = ",formatC(rr,digits=3,format="f"),"\n")
cat("ar  = ",formatC(ar,digits=3,format="f"),"\n")

cat("\n--- Imaginary Surface Parts ---\n")
cat("Ws  = ",formatC(Ws,digits=3,format="f")," --> 4*as*Ws = ",
    formatC(4*as*Ws,digits=3,format="f"),"\n")
cat("rs  = ",formatC(rs,digits=3,format="f"),"\n")
cat("as  = ",formatC(as,digits=3,format="f"),"\n")

cat("\n--- Imaginary Volume Parts ---\n")
cat("Wv  = ",formatC(Wv,digits=3,format="f"),"\n")
cat("rv  = ",formatC(rv,digits=3,format="f"),"\n")
cat("av  = ",formatC(av,digits=3,format="f"),"\n")

cat("\n--- Spin-Orbit Parts ---\n")
cat("Vso = ",formatC(Vso,digits=3,format="f"),"\n")
cat("rso = ",formatC(rso,digits=3,format="f"),"\n")
cat("aso = ",formatC(aso,digits=3,format="f"),"\n")

cat("-------------------------------\n\n")

