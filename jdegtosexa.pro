;function jdegtosexa, ra_deg, dec_deg
;+
; NAME:
;       JDEGTOSEXA
; PURPOSE:
;       Convert Degree RA and DEC to Sexagesimal
; EXPLANATION:
;       RA and DEG can be represented in degrees or in sexagesimal (base 60)
; CALLING EXAMPLE:
;       Result = JDEGTOSEXA(ra_deg, dec_deg)
;
; INPUTS:
;       ra_deg = value of the RA in degrees (0 <= ra_deg <= 360)
;       dec_deg = value of the Dec in degrees (-90 <= dec_deg <= 90)
;
; OUTPUTS:
;       [ra_h, ra_m, ra_s, de_h, de_m, de_s] = an array with RA
'       and DEC in Sexagesimal (Hours, minutes, seconds)
;
; MODIFICATION HISTORY:
;       Written, Jeffrey Chan    January 2018
;       Added Docstring, modified format  May 2021
;-
;==============================================================================
function jdegtosexa, ra_deg, dec_deg

  ra_h  = fix(ra_deg/15.)
  ra_md = abs(ra_deg*4.0d - ra_h*60.0d)
  ra_m  = fix(ra_md)
  ra_s  = (ra_md-ra_m)*60.0d

  de_h  = fix(dec_deg)
  de_md= abs(dec_deg-de_h)*60.0d
  de_m = fix(de_md)
  de_s = (de_md-de_m)*60.0d

; Test for the special case of zero degrees (taken from radec.pro)
; Do this since if 0deg, the min has to be minus if overall dec_deg < 0
; And of course if de_m eq 0 then de_s has to have a minus sign

  zero_deg = (de_h eq 0) and (dec_deg lt 0)
  de_m = de_m - 2*de_m*fix(zero_deg*(de_m ne 0))
  de_s = de_s - 2*de_s*zero_deg*(de_m eq 0)

  return, [ra_h, ra_m, ra_s, de_h, de_m, de_s]

END

