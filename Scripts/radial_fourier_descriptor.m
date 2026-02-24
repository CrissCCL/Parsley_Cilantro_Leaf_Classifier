function f = radial_fourier_descriptor(BW, N, K)
    BW = logical(BW);
    BW = imfill(BW,'holes');
    BW = bwareafilt(BW,1);

    stats = regionprops(BW,'Centroid');
    c = stats.Centroid;  % [x y]

    B = bwboundaries(BW);
    b = B{1};
    y = b(:,1); x = b(:,2);

    dx = x - c(1);
    dy = y - c(2);

    theta = atan2(dy, dx);
    r = sqrt(dx.^2 + dy.^2);

    [theta_s, idx] = sort(theta);
    r_s = r(idx);

    [theta_s2, ia] = unique(theta_s, 'stable');
    r_s2 = r_s(ia);

    theta_u = linspace(-pi, pi, N);
    r_u = interp1(theta_s2, r_s2, theta_u, 'linear', 'extrap');

    r_u = r_u / (max(r_u) + eps);

    R = fft(r_u);
    f = abs(R(2:K+1));  % 1xK
end