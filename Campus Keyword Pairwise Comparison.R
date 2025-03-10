comparison<- result[, c(1,4, 8, 10)]
#comparison$`Organization Unit` <- factor(comparison$`Organization Unit`)
comII <- comparison[comparison$`NYHA Classification` == "NYHA II",]
comIII <- comparison[comparison$`NYHA Classification` == "NYHA III",]
comIV <- comparison[comparison$`NYHA Classification` == "NYHA IV",]
summary(comII)
summary(comIII)
summary(comIV)


library(car)

leveneTest(comII$`correct words percent` ~ comII$`Organization Unit`)

anovaII <- aov(comII$`correct words percent` ~ comII$`Organization Unit`)
summary(anovaII)
par(mfrow = c(1, 2)) # combine plots

# histogram
hist(anovaII$residuals)

# QQ-plot
library(car)
qqPlot(anovaII$residuals,
       id = FALSE # id = FALSE to remove point identification
)
shapiro.test(anovaII$residuals)

leveneTest(comIII$`correct words percent` ~ comIII$`Organization Unit`)
library("lattice")
anovaIII <- oneway.test(comIII$`correct words percent` ~ comIII$`Organization Unit`, var.equal = FALSE)
dotplot(comIII$`correct words percent` ~ comIII$`Organization Unit`)
#anovaIII <- aov(comIII$`correct words percent` ~ comIII$`Organization Unit`)
summary(anovaIII)
anovaIII
hist(anovaIII$residuals)

# QQ-plot
library(car)
qqPlot(anovaIII$residuals,
       id = FALSE # id = FALSE to remove point identification
)
shapiro.test(anovaIII$residuals)

leveneTest(comIV$`correct words percent` ~ comIV$`Organization Unit`)
anovaIV <- aov(comIV$`correct words percent` ~ comIV$`Organization Unit`)
summary(anovaIV)

hist(anovaIV$residuals)

# QQ-plot
library(car)
qqPlot(anovaIV$residuals,
       id = FALSE # id = FALSE to remove point identification
)
shapiro.test(anovaIV$residuals)

TukeyHSD(anovaII)
plot(TukeyHSD(anovaII))

TukeyHSD(anovaIII)
plot(TukeyHSD(anovaIII))

TukeyHSD(anovaIV)
plot(TukeyHSD(anovaIV))


anovaAll <- aov(comparison$`correct words percent` ~ comparison$`Organization Unit`)
summary(anovaAll)
leveneTest(comparison$`correct words percent` ~ comparison$`Organization Unit`)
hist(anovaAll$residuals)

library(car)
qqPlot(anovaAll$residuals,
       id = FALSE # id = FALSE to remove point identification
)
shapiro.test(anovaAll$residuals)
TukeyHSD(anovaAll)
plot(TukeyHSD(anovaAll))






comparison<- result[, c(1,4, 8, 10)]
VA <- comparison[comparison$`Organization Unit` == 'Virginia',]
mean(VA$`correct words percent`)
cut_off <- sd(VA$`correct words percent`)*1.5
cut_off
mean(VA$`correct words percent`)-cut_off
VA[VA$`correct words percent` <= mean(VA$`correct words percent`)-cut_off,]


AC <- comparison[comparison$`Organization Unit` == 'Auburn',]
mean(AC$`correct words percent`)
cut_off <- sd(AC$`correct words percent`)*1.5
cut_off
mean(AC$`correct words percent`)-cut_off
AC[AC$`correct words percent` <= mean(AC$`correct words percent`)-cut_off,]

CC <- comparison[comparison$`Organization Unit` == 'Carolinas',]
mean(CC$`correct words percent`)
cut_off <- sd(CC$`correct words percent`)*1.5
cut_off
mean(CC$`correct words percent`)-cut_off
CC[CC$`correct words percent` <= mean(CC$`correct words percent`)-cut_off,]

LC <- comparison[comparison$`Organization Unit` == 'Monroe',]
mean(LC$`correct words percent`)
cut_off <- sd(LC$`correct words percent`)*1.5
cut_off
mean(LC$`correct words percent`)-cut_off
LC[LC$`correct words percent` <= mean(LC$`correct words percent`)-cut_off,]