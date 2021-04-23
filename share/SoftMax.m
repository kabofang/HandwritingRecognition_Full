function R=SoftMax(In)
x=exp(In);
R=x./sum(x);