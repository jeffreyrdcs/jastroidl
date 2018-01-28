;
;
;  To get the peak and 68% value of the probability distribution
;  use Interpolation and int_tabulated
;
;  Output format: [peak, lower34%, upper34%]
;
Function jprobdist_sigma, pdx, pdy

  pdres = [0.0d, 0.0d, 0.0d]

  ;Generate a fine version of the pdx array 
  ;Roughly 10 times finer
  pdsize = size(pdx)
  pdxsize = pdsize[1]
  usesize = 10^(ceil(alog10(pdxsize))+1)
   
  interval = (max(pdx) - min(pdx))/usesize
  pdxintepol = dindgen(usesize) * interval + min(pdx)
  pdyintepol = interpol(pdy, pdx, pdxintepol, /spline)

  ;Integration
  totint = int_tabulated(pdxintepol, pdyintepol)
  maxval = max(pdyintepol,maxloc) 
  pdmax = pdxintepol[maxloc]
   
  ;Find upper 34%
;  pdrange = [maxloc, maxloc+1]
  pdrange = [0,1]
  tmpcheck = 0
  count = 0
  while tmpcheck lt 0.8413d do begin
    count = count + 1 
    tmpint = int_tabulated(pdxintepol[pdrange], pdyintepol[pdrange])
    pdrange = findgen(1+count)
    tmpcheck = tmpint / totint
  endwhile
  uloc = count
  
  ;Find 16%
  pdrange = [0,1]
  tmpcheck = 0
  count = 0
  while tmpcheck lt 0.1587d do begin 
    count = count + 1
    tmpint = int_tabulated(pdxintepol[pdrange], pdyintepol[pdrange])
    pdrange = findgen(1+count)
    tmpcheck = tmpint / totint
  endwhile
  lloc = count-1

  pdres[0] = pdmax
  pdres[1] = pdxintepol[lloc]
  pdres[2] = pdxintepol[uloc]

  return, pdres 

END

