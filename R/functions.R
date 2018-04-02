LoadData <- function(filename)
{
  splitname <- strsplit(filename,"\\.")[[1]]
  if(tolower(splitname[length(splitname)]) == "cdf"){
    msobj <- openMSfile(filename,backend="netCDF")
  }else if (tolower(splitname[length(splitname)]) == "mzml"){
    msobj <- openMSfile(filename,backend="pwiz")
  }else{
    msobj <- openMSfile(filename,backend="Ramp")
  }

  peakInfo <- peaks(msobj)
  headerInfo <- header(msobj)
  whMS1 <- which(headerInfo$msLevel==1)
  peakInfo <- peakInfo[whMS1]

  peakInfo <- lapply(peakInfo, function(spectrum) {
    keep <- spectrum[,2] > 1e-6
    output <- as.data.frame(spectrum[keep,,drop = FALSE])
    colnames(output) <- c('mz','intensity')
    return(output)
  })

  scanTime <- round(headerInfo$retentionTime[whMS1],3)
  # close(msobj)

  return(list(path=filename, times=scanTime, peaks = peakInfo))
}

deblank <- function(raw_blank, raw_file, window=5, threshold=100, digit=2) {
  ps <- raw_file$peaks
  pb <- raw_blank$peaks
  if (threshold<=0){
    threshold <- quantile(unlist(lapply(pb, function(p) p$intensity)), 0.95)
  }
  pd <- lapply(seq_along(ps), function(s){
    this.rt <- raw_file$times[s]
    this.peak <- ps[[s]]

    left.rt <- this.rt - window
    right.rt <- this.rt + window
    blank.win <- which(raw_blank$times>left.rt & raw_blank$times<right.rt)
    blank.ion <- do.call(rbind, pb[blank.win])
    blank.ion <- blank.ion[blank.ion[,2]>threshold,]
    if (is.null(blank.ion)){next}

    keep <- ! round(this.peak$mz, digit) %in% round(blank.ion$mz, digit)
    this.peak[keep,]
  })
  return(list(times=raw_file$times, peaks=pd))
}

getTIC <- function(raw){
  tic <- sapply(raw$peaks, function(p) sum(p[,2]))
  rt <- raw$times
  return(data.frame(rt=rt, tic=tic))
}

getMS <- function(raw, rt){
  this <- which.min(abs(raw$times-rt))
  return(raw$peaks[[this]])
}

plotTIC <- function(tic_raw, tic_blank, tic_deblank) {
  p <- plot_ly() %>%
    layout(xaxis = list(tick0 = 0, title = 'Retention Time (s)'),
           yaxis = list(title = 'Intensity'))

  p <- add_lines(p, x=tic_raw$rt, y=tic_raw$tic, name='sample')
  p <- add_lines(p, x=tic_blank$rt, y=tic_blank$tic, name='blank')
  p <- add_lines(p, x=tic_deblank$rt, y=tic_deblank$tic, name='sample deblank')

  p
}

plotMS <- function(ms){
  p <- plot_ly() %>%
    layout(xaxis = list(range=c(0, max(ms[,'mz'])+20), tick0 = 0, title = 'mass-to-charge'),
           yaxis = list(tick0 = 0, title = 'Intensity'),
           showlegend = FALSE)

  for (i in 1:nrow(ms)){
    p <- add_lines(p, x=rep(ms[i,'mz'],2), y=c(0,ms[i,'intensity']), color=I('blue'))
  }

  p
}

