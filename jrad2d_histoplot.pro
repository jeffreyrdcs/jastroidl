;=======================================================================================
;27 March 2016
;
;
; Function arcxy from idlcoyote 'arc', slight modification
;
; Main routine jrad2d_histoplot
; Important: ANGLES are in DEGREES and count from X-axis (counterclockwise)
; Use /nooutline if one do not want to show grid lines in each wedge
;
: Example:
; IDL> radmin = [0,0,0,0,0,1,1,1,2,2,3,3,4,4,4]
; IDL> radmax = [1,1,1,1,1,2,2,2,3,3,4,4,5,5,6]
; IDL> angmin = [0,60,120,270,300,0,30,120,180,340,25,70,10,160,280]
; IDL> angmax = [60,120,270,300,360,30,120,180,320,360,60,315,140,200,360]
; IDL> value = [100, 2.05, 50.0, 45, 110, 222, 170, 300, 50, -10.0, 250, 150, 100, 50, 0]
; IDL> jrad2d_histoplot, 'testrad.ps', radmin,radmax,angmin,angmax, value
;
;=======================================================================================
Function arcxy, xc, yc, ang1, ang2, rad1
      points = (2.0d * !DPI  * !RaDeg / 999.0) * Findgen(1000)
      indices = Where((points GE ang1) AND (points LE ang2), count)
      IF count GT 0 THEN points = points[indices]
      x = xc + rad1 * COS(points * !DtoR)
      y = yc + rad1 * SIN(points * !DtoR)
      RETURN, Transpose([[x],[y]])
END


;Main routine
pro jrad2d_histoplot, outpsfilename, radmin, radmax, angmin, angmax, value, nooutline=nooutline

;== Determine Number of arcs ===============
  narc = n_elements(radmin) 
  if n_elements(radmin) ne n_elements(radmax) then print, 'Array size not match !!!'
  print, 'Number of Cells: ', narc

;== Setup the PSfile =======================
  cgPS_open, filename = outpsfilename, decomposed = 1, xsize=6.0, ysize=6.0, /encapsulate
  maxrad = max(radmax,/nan)
  xbasearr = [-1.1*maxrad, 1.1*maxrad]    ;Change it for 0 to 180 or 0 to 360
  ybasearr = [-1.1*maxrad, 1.1*maxrad]    

  cgplot, xbasearr, ybasearr,  xtitle = 'X', ytitle = 'Y', $
          ASPECT=1.0, /nodata, xstyle=1, ystyle=1

;== Fill the Wedges ==================================
  cgloadct, 13, ncolors = 256, bottom =  0, clip = [0,256]     ;Load the rainbow table
  ;Normalize the color into [0,255] with highest number
  valuenorm = 255.0d - ((value - min(value))/ (max(value)-min(value)) * 255.0d)
  print, valuenorm
 
  for i =0, narc-1, 1 do begin
    ptarcmin = arcxy(0, 0, angmin[i], angmax[i], radmin[i])
    ptarcmax = arcxy(0, 0, angmin[i], angmax[i], radmax[i])
    print, angmin[i], angmax[i], radmin[i], radmax[i], ceil(valuenorm[i])
    xtmparcmin = ptarcmin[0,*]
    xtmparcmax = ptarcmax[0,*]
    ytmparcmin = ptarcmin[1,*]
    ytmparcmax = ptarcmax[1,*]
    totx = [reform(xtmparcmin), reverse(reform(xtmparcmax))] 
    toty = [reform(ytmparcmin), reverse(reform(ytmparcmax))] 
    cgcolorfill, totx, toty, color=fix(ceil(valuenorm[i]))
  endfor 

;== Draw the arcs and sides of the wedge =======
  colorarc = 'black'                      ;Pick the COLOR!
  if n_elements(nooutline) eq 0 then begin
    for i =0, narc-1, 1 do begin
      ptarcmin = arcxy(0, 0, angmin[i], angmax[i], radmin[i])
      ptarcmax = arcxy(0, 0, angmin[i], angmax[i], radmax[i])
      cgplot, ptarcmin[0,*], ptarcmin[1,*], linestyle=1, color=colorarc, /overplot, thick=1.5
      cgplot, ptarcmax[0,*], ptarcmax[1,*], linestyle=1, color=colorarc, /overplot, thick=1.5
      xr1 = [radmin[i] * COS(angmin[i] * !DtoR),radmax[i] * COS(angmin[i] * !DtoR)]
      yr1 = [radmin[i] * SIN(angmin[i] * !DtoR),radmax[i] * SIN(angmin[i] * !DtoR)]
      xr2 = [radmin[i] * COS(angmax[i] * !DtoR),radmax[i] * COS(angmax[i] * !DtoR)]
      yr2 = [radmin[i] * SIN(angmax[i] * !DtoR),radmax[i] * SIN(angmax[i] * !DtoR)]
      cgplot, xr1, yr1, color=colorarc, linestyle=1, /overplot, thick=1.5
      cgplot, xr2, yr2, color=colorarc, linestyle=1, /overplot, thick=1.5
    endfor
  endif

;== Draw the color bar ===============================
  cgcolorbar, divisions = 5, range = [max(value), min(value)],  xminor = 1, $
  xticklen = 0.1, format = '(I3)', $
  position = [0.2, 0.77, 0.5, 0.82] ,$
  annotatecolor = 'black', charsize = 0.8


 
  cgPS_close


END
