;Create a cube with xy-coord in the first and second slide
;with respect to the center
;default being [0,0]
;
;

Function jxyarrcreate, xsize, ysize, center=center

  if n_elements(center) eq 0 then begin
    xarray=cmreplicate(findgen(xsize),ysize)
    yarray=rotate(cmreplicate(findgen(ysize),xsize),1)
  endif else begin
    xarray=cmreplicate(findgen(xsize),ysize) - center[0]
    yarray=rotate(cmreplicate(findgen(ysize),xsize) - center[1],1)
  endelse

  cube = fltarr(xsize,ysize,2)
  cube[*,*,0] = xarray
  cube[*,*,1] = yarray
  return, cube 

END
