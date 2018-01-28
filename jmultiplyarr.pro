function jmultiplyarr, inarr
  innum = n_elements(inarr)
  x = 1.0d
  for i=0L,innum-1,1 do begin
    x = x * inarr[i]
  endfor
  return, x
END
