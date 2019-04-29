function [x y rs thetas] = makeCircle(r, anglemin, anglemax, noiseLevel)
    thetas = linspace(anglemin, anglemax, (anglemax-anglemin+1))';
    rs = r*ones(size(thetas));
    rs = rs + randn(size(rs))*noiseLevel;
    x = cosd(thetas).*rs;
    y = sind(thetas).*rs;
end