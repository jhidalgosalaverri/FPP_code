function fig =  plot_2D(obj, varargin)
    % Plot in 2D the inputs, while fixing the third input
    % INPUTS:
    % xvar: variable name to plot in the x axis
    % yvar: variable name to plot in the y axis
    % fixedvar: variable name to fix
    % fixedvarvalue: value to fix in the fixedvar. Closest value is chosen.
    % 
    % OUTPUTS:
    % f: figure handle

    % Parse input
    p = inputParser();
    addRequired(p, 'xvar', @ischar)
    addRequired(p, 'yvar', @ischar)
    addRequired(p, 'fixedvar', @ischar)
    addRequired(p, 'fixedvarvalue')
    parse(p,varargin{:});
    xvar = p.Results.xvar;
    yvar = p.Results.yvar;
    fixedvar = p.Results.fixedvar;
    fixedvarvalue = p.Results.fixedvarvalue;

    [~, fixed_index] = min(abs(fixedvarvalue-unique(obj.inputs.(fixedvar))));
    x = []; y = []; valid = [];

    for i=1:obj.n
        if obj.inputs.(fixedvar)(i) == obj.inputs.(fixedvar)(fixed_index) &&...
            obj.outputs.valid(i)
            x = [x; obj.inputs.(xvar)(i)];
            y = [y; obj.inputs.(yvar)(i)];
        end
    end
    fig = figure;
    hold on
    plot(x,y, 'x')
    xlabel(xvar)
    ylabel(yvar)
end