classdef FPP_code < handle
% Main class to run the FPP_code. Input must be given in form of N 1D
% vectors inside a structure with the variables named. See run_FPP_code for 
% the naming convention.

    properties
        % Constants
        mu_0 = 4*pi*1e-7    % Vacuum magnetic permeability [As/Vm]
        
        % Fixed values
        R_shielding = 0.5   % [m]
        J_TFC_limit = 100e6 % Current density limit on the TFC [A/m2]
        B_TFC_limit = 20    % Magnetic field limit on the TFC [T]
        
        % Class properties
        inputs
        outputs
        n
    end
    
    
    methods (Access=public,Hidden=false)
        % Constructor
        function obj = FPP_code(inputs)
            obj.inputs = inputs;
            % Check if all inputs have the same length
            if not(length(inputs.R_major) == length(inputs.Bt) && ...
                    length(inputs.R_major) == length(inputs.aspect_ratio))
                error('Inputs must have the same dimension')
            end
            obj.n = length(inputs.R_major);
            
            % Prepare the outputs
            aux = nan*zeros(obj.n,1);
            obj.outputs = struct('I_TFC', aux,...
                'R_TFC', aux, ...
                'B_TFC', aux, ...
                'valid', aux);
        end
        function obj = apply_restrictions(obj)
            % Main method of the FPP_code class. It is separated from the 
            % constructor to allow the variation of the fixed values 
            % without running this method. 
            % Apply all restrictions. Saving outputs and checking if the 
            % simulated inputs are valid 
            for i=1:obj.n
                obj = get_R_TFC(obj,i);
                obj = check_current_density_limit_TFC(obj,i);
                obj = check_Btfc_limit(obj, i);
                
            end
        end
    end
    methods (Access=public,Hidden=true)
        
        function obj = get_R_TFC(obj, index)
            % Get the toroidal field coil radius. 
            R = obj.inputs.R_major(index);
            aspect_ratio = obj.inputs.aspect_ratio(index);
            obj.outputs.R_TFC(index) = R-R/aspect_ratio-obj.R_shielding;
            
            if obj.outputs.R_TFC(index) > 0 && obj.outputs.valid(index) ~= false
                obj.outputs.valid(index) = true;
            else
                obj.outputs.valid(index) = false;
            end  
        end
        
        function obj = check_current_density_limit_TFC(obj, index)
            % Check if the current density limit in the TFC is surpassed 
            Bt = obj.inputs.Bt(index);
            R_major = obj.inputs.R_major(index);
            obj.outputs.I_TFC(index) = Bt*2*pi*R_major/obj.mu_0;
            
            if obj.outputs.I_TFC(index) < obj.J_TFC_limit && ...
                    obj.outputs.valid(index) ~= false
                obj.outputs.valid(index) = true;
            else
                obj.outputs.valid(index) = false;
            end  
        end
        
        function obj = check_Btfc_limit(obj, index)
            % Check if the TFC magnetic field is reached
            I_TFC = obj.outputs.I_TFC(index);
            R_TFC = obj.outputs.R_TFC(index);
            obj.outputs.B_TFC(index) = obj.mu_0*I_TFC/(2*pi*R_TFC);
            
            if obj.outputs.B_TFC(index) < obj.B_TFC_limit && ...
                obj.outputs.valid(index) ~= false
                obj.outputs.valid(index) = true;
            else
                obj.outputs.valid(index) = false;
            end  
        end
    end
end