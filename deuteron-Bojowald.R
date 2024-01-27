## Calculate the elastic scattering optical model potentials from
## Bojowald, M., Phys. Rev. C 38, 1153 (1988)

E <- 21.0-2.8347# deuteron energy in MeV
A <- 40      # Target mass in AMU
Z <- 20       # Target charge

###############################################
## Real Parts
V <- 81.32-0.24*E+1.43*Z/A^{1/3}
rr <- 1.18
ar <- 0.636+0.035*A^{1/3}

## Imaginary Volume parts
Wv <- max(0,0.132*(E-45))
rv <- 1.27
av <- 0.768+0.021*A^{1/3}

## Imaginary Surface parts
Ws <- max(0,7.80+1.04*A^{1/3}-0.712*Wv)
rs <- rv
as <- av
          
## Spin-Orbit parts
Vso <- 6
rso <- 0.78+0.038*A^{1/3}
aso <- rso

## Coulomb radius
rc <- 1.30

##############################################
cat("\nThe Parameters obtained from")
cat(" Bojowald, M., Phys. Rev. C 38, 1153 (1988):\n")

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
cat("rso = ",formatC(rso,digits=3,format="f"),"\n")
cat("aso = ",formatC(aso,digits=3,format="f"),"\n")

cat("-------------------------------\n\n")

