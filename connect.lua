local _X,_Y,_Z,_A,_B,_C,_D,_E,_F,_G="","",{},{};_X=type;_Y=pcall
_B=function(s)local m,n={},{};for i=1,#s do local c=string.sub(s,i,i) if not m[c]then m[c]=true;table.insert(n,c)end end;local t,u={},{};for i,v in ipairs(n)do local tok=string.format("~%02X",i);t[v]=tok;u[tok]=v end;local p={};for i=1,#s do p[#p+1]=t[string.sub(s,i,i)] end;return table.concat(p),u end
_C=function(x) _Y(function() if _X(setclipboard)=="function" then setclipboard(x) elseif _X(syn)=="table" and _X(syn.set_clipboard)=="function" then syn.set_clipboard(x) end end) end
_D=function() if _X(obf_string)~="string" or #obf_string==0 then return false end if _X(rev_mapping)~="table" then return false end if (#obf_string%3)~=0 then return false end return true end
local junk=(function() local a=0 for i=1,3 do a=a+math.floor((math.random()*2)+0) end return a end)()
if not _D() then local o,p=_B(src) obf_string=o rev_mapping=p _C(o) end
_E=function()
 if _X(obf_string)~="string" or _X(rev_mapping)~="table" then return nil end
 local r={},i=1,#obf_string
 while i<=#obf_string do
  local tok=string.sub(obf_string,i,i+2)
  local ch=rev_mapping[tok]
  if ch==nil then r[#r+1]=("<~UNKNOWN:%s~>"):format(tok) else r[#r+1]=ch end
  i=i+3
 end
 return table.concat(r)
end
_F=function()
 local s=_E() if not s then return nil end
 local L=(load or loadstring) if not L then return nil end
 local CC,err=L(s,"_G.exec")
 if not CC then return nil end
 _Y(CC)
end
local mt={__call=function(self,...) return _F() end}
setmetatable(_G or {},mt)
local function A(z)local t={} for i=1,#z do t[i]=string.byte(z,i) end return t end
local _no=A("m40fuscation")
(function(x) if x and x[1] then return _F() else return (function()return _F()end)() end end)(_no)
