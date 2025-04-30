RefinementFunction <- function(rawData)
{
  # Z score
  
  binocular = rawData$occluderTransparency
  zScore = scale(binocular)
  cat(zScore, "\n")
  
  outliersZ <- which(abs(zScore)>2)
  
  if (length(outliersZ) > 0)
  {
    cat("The following entries are likely erroneous for binocular opacity, using Z-Score: ", binocular[outliersZ], "\n")
  }
  
  # IQR
  Q1 <- quantile(binocular, 0.25)
  Q3 <- quantile(binocular, 0.75)
  IQR_val <- Q3 - Q1
  
  lower_bound <- Q1 - 1.5 * IQR_val
  upper_bound <- Q3 + 1.5 * IQR_val
  
  outliersIQR <-  which(binocular < lower_bound | binocular > upper_bound)
  
  if (length(outliersIQR) > 0)
  {
    cat("The following entries are likely erroneous for binocular opacity, using IQR: ", binocular[outliersIQR], "\n")
  }
  
  allOutliers <-  union(outliersZ, outliersIQR)
  return (rawData[-allOutliers,])
}

if (!requireNamespace("readxl")) {
  stop("Please install the 'readxl' package")
}
library("readxl")

rawData <-  read_excel("../ProcessedData.xlsx")

# Refine the data based on the binocular opacity
refinedData <-  RefinementFunction(rawData)

#load variables
participantCount <- nrow(refinedData)
leftEyeOpacity <-  refinedData$leftEyeOccluderTransparency
rightEyeOpacity <-  refinedData$rightEyeOccluderTransparency
binocularOpacity <-  refinedData$occluderTransparency
dichopticPreference <-  refinedData$preferredDichoptic

preferredDichopticOpacity  =length(which(dichopticPreference == TRUE))

# Removing concept of left and right eye, instead larger opacity (prominent) and smaller opacity (nonProminent)
prominentOpacity = mapply(max,leftEyeOpacity, rightEyeOpacity)
nonProminentOpacity = mapply(min, leftEyeOpacity, rightEyeOpacity)

# midpoint between both eyes
dichopticMidpoint = (prominentOpacity + nonProminentOpacity) / 2
# difference
dichopticRange = abs(prominentOpacity - nonProminentOpacity)

differenceQ1 = quantile(dichopticRange, 0.25)
differenceQ3 = quantile(dichopticRange, 0.75)

differenceInQ1 = length(which(dichopticRange >= differenceQ1))

cat("Binocular Opacity: Average = ",
   mean(binocularOpacity), ", Standard Deviation  = ", sd(binocularOpacity) ,"\n")

cat("Dichoptic (Middle) Opacity: Average = ",
    mean(dichopticMidpoint), ", Standard Deviation  = ", sd(dichopticMidpoint) ,"\n")

cat("Dichoptic (Difference) Opacity: Average = ",
    mean(dichopticRange), ", Standard Deviation  = ", sd(dichopticRange),"\n")

cat ("Percentage of participants who preferred dichoptic opacity = ",(preferredDichopticOpacity / participantCount) * 100, "%\n")

cat("The lower quartile was", differenceQ1, "with", differenceInQ1, "entries beyond it\n")

cat("The correlation between binocular opacity and dichoptic middle is", cor(binocularOpacity, dichopticMidpoint), "\n")

cat("Number of particpants who had a dichoptic range below the lower quartile and who did not prefer dichoptic opacity was",
    length(which((dichopticRange <= differenceQ1) & dichopticPreference == FALSE)))