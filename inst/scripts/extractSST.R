# What does this event look like:  GHRSST – All Nov 2017 days.
# What does this look like compared to recent years:  GHRSST – Nov 23rd days for all data period years
# Lets place this in context, what deos it look like compared to conditions more generally:  AVHRR – monthly mean for November for all of data period years
#
# I’ll get back to you with some figures / animations that show this story and we can iterate back and forth from there…

library(raadtools)
library(dplyr)
ex <- extent(140, 153, -50, -35)

gfiles <- ghrsstfiles()

ghrsst <- readghrsst(dplyr::filter(gfiles, format(date, "%Y-%m") == "2017-11")$date,
                     xylim = ex) - 273.15
ghrsst <- setZ(ghrsst, dplyr::filter(gfiles, format(date, "%Y-%m") == "2017-11")$date)
writeRaster(ghrsst, "sstdata_output/ghrsst_2017-11.grd", overwrite = TRUE)


ofiles <- sstfiles()
oisst <- readsst(dplyr::filter(gfiles, format(date, "%m") == "11")$date,
                 xylim = ex)
writeRaster(oisst, "sstdata_output/oisst_1982_2017-11.grd")

## monthly from OISST
dts <- getZ(oisst)

month_oisst <- brick(lapply(split(seq_along(dts), format(dts, "%Y")), function(i) mean(subset(oisst, i))))
writeRaster(month_oisst, "sstdata_output/oisst_monthly_1982_2017-11.grd")
