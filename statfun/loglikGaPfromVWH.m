function f=loglikGaPfromVWH(varargin)
% f=loglikGaPfromVWH(varargin)
% complete log likellihood of the GaP model 
% Vxt =     varargin{1};        %data (XxT)
% Wxk =     varargin{2};        %basis functions (XxK)
% Hkt =     varargin{3};        %intensities (KxT)
% alpha =   varargin{4};        %parameters of the Gamma blinking (Kx1)
% beta =    varargin{5};        %parameters of the Gamma blinking (Kx1) 
% peval =   varargin{6};        %parameters
% Gamma distribution with mean alpha/beta!
% X: number of pixels
% T: number of images (time - slices)
% K: number of components

Vxt =     varargin{1};        %data (XxT)
Wxk =     varargin{2};        %basis functions (XxK)
Hkt =     varargin{3};        %intensities (KxT)
alpha =   varargin{4};        %parameters of the Gamma blinking (Kx1)
beta =    varargin{5};        %parameters of the Gamma blinking (Kx1)
peval =   varargin{6};        %parameters

k=size(Wxk,2);
if length(alpha) ==1; alpha = repmat(alpha,k, 1); end
if length(beta) ==1; beta = repmat(beta,k, 1); end
%[Wxkbg,Hktbg]=addbg(Wxk, Hkt, peval.bg);
%P=Wxkbg*Hktbg; %current approximation (XxT)
P=Wxk*Hkt; %current approximation (XxT)

%Poisson contribution
t1=Vxt.*log(P) - P - factorialapprox(Vxt); %(XxT)
%Gamma contribution
t2a=bsxfun(@times,(alpha-1),log(Hkt)) - bsxfun(@times,beta,Hkt); % (KxT)
t2b=-alpha.*log(beta)-log(gamma(alpha)); %(1xK)

f=sum(t1(:))+sum(t2a(:))+sum(t2b(:));
% Conjugate gradient is mimimizing! for this it needs to be f=-f; 