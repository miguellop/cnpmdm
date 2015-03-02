function [f ] = fbell(np, ni, r, h, norm)
%np-n�mero de picos
%ni-n�mero de issues
%r-rango de radios
%h-rango de alturas
%norm-flag de normalizaci�n a utilidad 1
    options = saoptimset('Display','off');
    d = [zeros(1,ni);100*ones(1,ni)];
    cv = unifrnd(0,100,np,ni);
    rv = unifrnd(r(1),r(2),np,1);
    hv = unifrnd(h(1),h(2),np,1);
    if norm
        [x mval] = simulannealbnd(@(x) -1.*funcion_bell(x,np,cv,rv,hv,false,0), unifrnd(0,100,1,ni), zeros(1,ni), ones(1,ni)*100, options);
        f= @(x) funcion_bell(x, np, cv, rv, hv, true, -1*mval);
    else
        f= @(x) funcion_bell(x, np, cv, rv, hv, false);
    end
end

function z = funcion_bell (x, npeaks, c, r, h, nor, m)
    npoints = size(x,1);
    z = zeros(1,npoints);
    for j=1:npoints
        for i=1:npeaks
            dist = norm(x(j,:)-c(i,:));
            ind = dist<(r(i)./2);
            z(ind) = z(ind)+h(i)-2*h(i)*dist(ind).^2./r(i).^2;
            ind = dist>=(r(i)./2) & dist<r(i);
            z(ind) = z(ind)+(2.*h(i)./r(i).^2).*(dist(ind)-r(i)).^2;
        end
    end
    if nor
        z = z./m;
    end
    
    z(not(prod(x>=0 & x<=100,2))) = 0;
    
end