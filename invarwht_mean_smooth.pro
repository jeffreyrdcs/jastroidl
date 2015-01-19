;invarwht_mean_smooth
;
; To smooth a 1D spectrum using Inverse-variance weighing
;
; output: outputspec, inverse-variance-weighted (mean) spec with a kernel size of smoothrange pixel
; input: require an inputspec and an errspec
; Start from forward: hence the first and last several pixel might not be correctly weighted - 
; so we did not compute any mean from that, computation start from pixel with smoothrange/2
; let just allow odd number of smoothrange to compute stuff easily

function invarwht_mean_smooth, inputspec, errspec, smoothrange 
   
  specsize = n_elements(inputspec)
  outputspec = inputspec
  outerrspec = errspec
  if smoothrange mod 2 eq 0 then begin 
    print,"only use odd number of smoothrange, using default 7 instead" 
    smoothwindow = 3
  endif else begin 
    smoothwindow = (smoothrange - 1)/2
    print,"smoothwindow :"+string(smoothwindow)
  endelse
  
  for i=smoothwindow,n_elements(inputspec)-1-smoothwindow,1 do begin
    tmpinputspec = inputspec[i-smoothwindow:i+smoothwindow] 
    tmperrspec   = errspec[i-smoothwindow:i+smoothwindow]
    outputspec[i] = total(tmpinputspec/(tmperrspec)^2.0d)/total(1/(tmperrspec)^2.0d)
    outerrspec[i] = (1.0d/ total(1/(tmperrspec)^2.0d))^0.5d
  endfor    
  
  return, [[outputspec],[outerrspec]]

END
