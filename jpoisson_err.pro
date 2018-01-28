;
;  Using Gehrels 1986 Poisson Limits 
;  Anything greater than 50  we use sqrt(num) as an estimates
;
;  Usage;   resarr = jpoisson_err(input_num)
;  It outputs the lower side 1 sigma and upper side 1 sigma (absolute)
;  Changing s can give you other confidence levels
; 
;  For n=0, there is an upper limit, but there is no lower limit.
;  so to get the real number its  i-lowsig and higsig+i
;
;  If n=NaN then lowsig, higsig = 0
;  If n=0   then loswsig = 0, highsig = 1.841
;
Function jpoisson_err,  inputnum

 s=1 
 testnum = fix(inputnum)
 gnum = indgen(51)
 ghigsig = [1.841d, $
            3.300, 4.638, 5.918, 7.163, 8.382, 9.584, 10.77, 11.95, 13.11, 14.27, $
            15.42, 16.56, 17.70, 18.83, 19.96, 21.08, 22.20, 23.32, 24.44, 25.55, $ 
            26.66, 27.76, 28.87, 29.97, 31.07, 32.16, 33.26, 34.35, 35.45, 36.54, $
            37.63, 38.72, 39.80, 40.89, 41.97, 43.06, 44.14, 45.22, 46.30, 47.38, $
            48.46, 49.53, 50.61, 51.68, 52.76, 53.83, 54.90, 55.98, 57.05, 58.12]

 glowsig = [0, $
            0.173d, 0.708, 1.367, 2.086, 2.840, 3.620, 4.419, 5.232, 6.057, 6.891, $
            7.734, 8.585, 9.441, 10.30, 11.17, 12.04, 12.92, 13.80, 14.68, 15.57, $
            16.45, 17.35, 18.24, 19.14, 20.03, 20.93, 21.84, 22.74, 23.65, 24.55, $
            25.46, 26.37, 27.28, 28.20, 29.11, 30.03, 30.94, 31.86, 32.78, 33.70, $
            34.62, 35.55, 36.47, 37.39, 38.32, 39.24, 40.17, 41.10, 42.02, 42.95]

 numloc = where(gnum eq testnum)

 if testnum gt 50 then begin
   higsig = testnum + s* sqrt(testnum+1) + (s^2 + 2.0d)/3.0d   - testnum
   lowsig = testnum - (testnum - s* sqrt(testnum)   + (s^2 - 1.0d)/3.0d)
 endif else begin 
   higsig = ghigsig[numloc] - testnum
   lowsig = testnum - glowsig[numloc]
 endelse

 return, [lowsig, higsig]

END
