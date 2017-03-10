function value=decbdr(x0,w1,b1,w2,b2)

value=(x0*(w1(1,1)-w2(1,1))+b1-b2)./(w1(2,1)-w2(2,1));
end