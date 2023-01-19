%% INPUTS
Bt = linspace(0,14,100); 
R_major = linspace(0,10,100);
aspect_ratio = linspace(1.5, 5, 20);

%% Run the code
% Prepare combinations
aux = nan*zeros(length(Bt)*length(R_major)*length(aspect_ratio),1);
inputs = struct('Bt', aux, ...
    'R_major', aux,...
    'aspect_ratio', aux);

index = 1;
for i = 1:length(Bt)
   for j = 1:length(R_major)
      for k = 1:length(aspect_ratio)
          inputs.Bt(index) = Bt(i);
          inputs.R_major(index) = R_major(j);
          inputs.aspect_ratio(index) = aspect_ratio(k);
          index = index+1; 
      end
   end
end


% Run the code
fpp = FPP_code(inputs);
fpp.apply_restrictions();


%% Plot example
xvar = 'Bt';
yvar = 'R_major';
fixedvar = 'aspect_ratio';
fixedvarvalue = 2;

fig = fpp.plot_2D(xvar,yvar,fixedvar,fixedvarvalue);



