function q = unwrapdeg(p,cutoff,dim)
%UNWRAPDEG Unwraps angles just like unwrap, but using degrees

q = unwrap(p * pi/180, cutoff * pi/180, dim);

end