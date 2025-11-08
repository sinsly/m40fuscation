local a1,a2,a3,a4,a5,a6,a7,a8,a9,a0,b1,b2,b3,b4
a1=type;a2=pcall;a3=string.sub;a4=string.format;a5=table.insert;a6=table.concat
a7=function(x1)local x2={} local x3={} for x4=1,#x1 do local x5=a3(x1,x4,x4) if not x2[x5]then x2[x5]=true;a5(x3,x5)end end local x6={} local x7={} for x8,x9 in ipairs(x3)do local y0=a4("~%02X",x8) x6[x9]=y0 x7[y0]=x9 end local z1={} for x4=1,#x1 do z1[#z1+1]=x6[a3(x1,x4,x4)] end return a6(z1),x7 end
a8=function(z) a2(function() if a1(setclipboard)=="function"then setclipboard(z) elseif a1(syn)=="table" and a1(syn.set_clipboard)=="function"then syn.set_clipboard(z)end end) end
a9=function() if a1(obf_string)~="string"or #obf_string==0 then return false end if a1(rev_mapping)~="table"then return false end if (#obf_string%3)~=0 then return false end return true end
if not a9()then local b0,b1=a7(src) obf_string=b0 rev_mapping=b1 a8(b0) end
b2=function() if a1(obf_string)~="string"or a1(rev_mapping)~="table"then return nil end local c1={} local c2,c3=1,#obf_string while c2<=c3 do local c4=a3(obf_string,c2,c2+2) local c5=rev_mapping[c4]or a4("<%s>",c4) c1[#c1+1]=c5 c2=c2+3 end return a6(c1) end
b3=function() local d1=b2() if not d1 then return nil end local d2=load or loadstring if not d2 then return nil end local d3,d4=d2(d1,"_") if not d3 then return nil end a2(d3) end
b3()
