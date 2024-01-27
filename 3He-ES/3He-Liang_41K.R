## Calculate the elastic scattering optical model potentials from
## Liang et al., J. Phys. G 36 (2009) 085104

E <- 21      # 3He energy in MeV
A <- 41      # Target mass in AMU
#A <- 38.953301122441 # Target mass in AMU (Very little difference)
Z <- 19      # Target charge

###############################################
## Real Parts
V <- 118.36 - 0.2071*E + 6.3961e-5*E^2 + 26.001*(A-2*Z)/A + 0.5668*Z/A^{1/3}
rr <- 1.1657 + 0.0401*A^{-1/3}
ar <- 0.6641 + 0.0305*A^{1/3}

## Imaginary Volume parts
Wv <- -6.8871 + 0.3115*E - 6.8096e-4*E^2
rv <- 1.4022 + 0.0418*A^{-1/3}
av <- 0.7732 + 0.0219*A^{1/3}

## Imaginary Surface parts
Ws <- 20.119 - 0.1626*E - 5.4067*(A-2*Z)/A + 1.2087*A^{1/3}
rs <- 1.1802 + 0.0587*A^{-1/3}
as <- 0.6292 + 0.0657*A^{1/3}
          
## Spin-Orbit parts
Vso <- 2.0491 + 9.9804e-3*A^{1/3}
rso <- 0.7211 + 0.0586*A^{-1/3}
aso <- 0.7643 + 0.0535*A^{1/3}

Wso <- -1.1591

## Coulomb radius
rc <- 1.289

##############################################
cat("\nThe Parameters obtained from")
#cat(" Bojowald, M., Phys. Rev. C 38, 1153 (1988):\n")
cat("Liang et al., J. Phys. G 36 (2009) 085104:\n")

cat("\n--- Coulomb Part ---\n")
cat("rc  =",formatC(rc,digits=3,format="f"),"\n")

cat("\n--- Real Parts ---\n")
cat("V   =",formatC(V,digits=3,format="f"),"\n")
cat("rr  = ",formatC(rr,digits=3,format="f"),"\n")
cat("ar  = ",formatC(ar,digits=3,format="f"),"\n")

cat("\n--- Imaginary Surface Parts ---\n")
cat("Ws  = ",formatC(Ws,digits=3,format="f"),"\n")
cat("rs  = ",formatC(rs,digits=3,format="f"),"\n")
cat("as  = ",formatC(as,digits=3,format="f"),"\n")

cat("\n--- Imaginary Volume Parts ---\n")
cat("Wv  = ",formatC(Wv,digits=3,format="f"),"\n")
cat("rv  = ",formatC(rv,digits=3,format="f"),"\n")
cat("av  = ",formatC(av,digits=3,format="f"),"\n")

cat("\n--- Spin-Orbit Parts ---\n")
cat("Vso = ",formatC(Vso,digits=3,format="f"),"\n")
cat("Wso = ",formatC(Wso,digits=3,format="f"),"\n")
cat("rso = ",formatC(rso,digits=3,format="f"),"\n")
cat("aso = ",formatC(aso,digits=3,format="f"),"\n")

cat("-------------------------------\n\n")

