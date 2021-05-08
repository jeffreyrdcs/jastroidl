;+
; NAME:
;       JSEXATODEG
; PURPOSE:
;       Convert Sexagesimal RA and DEC to degree
; EXPLANATION:
;       RA and DEG can be represented in degrees or in sexagesimal (base 60)
; CALLING EXAMPLE:
;       Result = JSEXATODEG(ra_h, ra_m, ra_s, de_h, de_m, de_s)
;
; INPUTS:
;       ra_h = value of the RA hours
;       ra_m = value of the RA minutes
;       ra_s = value of the RA seconds
;       de_h = value of the Dec hours
;       de_m = value of the Dec minutes
;       de_s = value of the Dec seconds
;
; OUTPUTS:
;       [rad,decd] = an array with RA and DEC in degrees
;
; MODIFICATION HISTORY:
;       Written, Jeffrey Chan  January 2018
;       Added Docstring        May 2021
;-
;==============================================================================
function jsexatodeg, ra_h, ra_m, ra_s, de_h, de_m, de_s

  rad = (ra_h + ra_m / 60.0d + ra_s / 3600.0d) * 15.0d

  if de_h lt 0 then begin
    decd = (de_h - de_m / 60.0d - de_s / 3600.0d)   ;Negative dec
  endif else begin
    decd = (de_h + de_m / 60.0d + de_s / 3600.0d)   ;Positive dec
  endelse

  return, [rad,decd]

END
