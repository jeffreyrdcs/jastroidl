;savit_golay_smooth
;
; To smooth a 1D spectrum using Savitzky-Golay filter
;
; output: outputspec, Savitzky-Golay filtered spec with a kernel size of smoothrange pixel and 
; an polynomial order of polyorder
; input: require an inputspec and an errspec, smoothwindowsize, and order of the polynomial
; Start from forward: hence the first and last several pixel might not be correctly weighted - 
; so we did not compute any mean from that, computation start from pixel with smoothrange/2
; let just allow odd number of smoothrange to compute stuff easily

function poly_order, x, p
  polyord = n_elements(p)-1
  polyresult = dblarr(n_elements(x))  

  for i=0,polyord,1 do begin
    polyresult = polyresult + p[i] * x^(i)  
  endfor

  return, polyresult
End 


;---------------------------------------------------------------------------------
function savit_golay_smooth, inputspec, errspec, smoothrange, polyorder
   
  specsize = n_elements(inputspec)
  outputspec = inputspec
  if smoothrange mod 2 eq 0 then begin 
    print,"only use odd number of smoothrange, using default 7 instead" 
    smoothwindow = 3
  endif else begin 
    smoothwindow = (smoothrange - 1)/2
    print,"smoothwindow :"+string(smoothwindow)
  endelse
 
  if 2*smoothwindow lt polyorder then begin
    print,"Order N needs to be <= 2M to conditioned the equations"
    polyorder = 2*smoothwindow - 1 
    print,"Setting N being the maximum, N = 2M - 1: " + string(polyorder)
  endif else begin 
    print,"polyorder N:"+string(polyorder)
  endelse

  ;We determinze the size of the start_params using the polyorder keyword
  ;and that will be how the function poly_order know the order we are fitting
  start_params  = dblarr(polyorder+1)

  for i=smoothwindow,n_elements(inputspec)-1-smoothwindow,1 do begin
    tmpinputspec = inputspec[i-smoothwindow:i+smoothwindow] 
    tmperrspec   = errspec[i-smoothwindow:i+smoothwindow]
    tmpx = findgen(smoothwindow*2 + 1) - smoothwindow 
    tmpresult = mpfitfun('poly_order', tmpx, tmpinputspec, tmperrspec, start_params, /quiet) 
    outputspec[i] = tmpresult[0]
  endfor    

  return, outputspec

END
