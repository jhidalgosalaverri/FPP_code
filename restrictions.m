% Constants
mu_0 = 4*pi*1e-7;
R_shielding = 0.5;



function Bt_bool = btLimit(Bt, R, A)
% Checks if the Bt limit is surpassed
I_conductor = Bt*2*pi*R/mu_0;
R_conductor = get_R_conductor(A,R,R_shielding);
B_conductor = mu_0*I_conductor/(2*pi*R_conductor);

Bt_bool = B_conductor < 20;

end


function R_conductor = get_R_conductor(A,R,R_shielding)
R_conductor = R-R/A-R_shielding;

end

