% Constants
mu_0 = 4*pi*1e-7;
R_shielding = 0.;

%% INPUTS
Bt = linspace(0,14,100); 
R = linspace(0,10,100);
A = linspace(1.5, 5, 20);

% Prepare combinations
inputs = ndgrid(Bt,R,A);
valid = zeros(100*100*20,1);
index = 1;
for i = 1:length(Bt)
   for j = 1:length(R)
      for k = 1:length(A)
          
          valid(index) = btLimit(Bt(i), R(j), A(k), mu_0, R_shielding);
          index = index+1; 
      end
   end
end



Bt_plot = [];
R_plot = [];
index = 1;
for i = 1:length(Bt)
   for j = 1:length(R)
      for k = 1:length(A)
          if valid(index) && A(k) == A(4)
              Bt_plot = [Bt_plot; Bt(i)];
              R_plot = [R_plot; R(j)];              
          end
          index = index+1;
                      
      end
   end
end

figure
hold on

plot(Bt_plot, R_plot, 'x')
xlabel('Bt [T]')
ylabel('R [m]')



function Bt_bool = btLimit(Bt, R, A, mu_0, R_shielding)
% Checks if the Bt limit is surpassed
I_conductor = Bt*2*pi*R/mu_0;
R_conductor = get_R_conductor(A,R,R_shielding);
B_conductor = mu_0*I_conductor/(2*pi*R_conductor);

Bt_bool = B_conductor < 20;
if R_conductor < 0
    Bt_bool = false;
end

if not(current_density_limit(R_conductor, I_conductor))
    Bt_bool = false;
end

end


function R_conductor = get_R_conductor(A,R,R_shielding)
R_conductor = R-R/A-R_shielding;

end

function valid = current_density_limit(R_conductor, I_conductor)
 J_limit = 100e6;
 valid = J_limit > I_conductor/(R_conductor^2*pi);
end
