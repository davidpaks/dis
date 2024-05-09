classdef SelectSolver
    properties
        odeSolver;
        odeParams;
        params;
    end
    
    methods
        function obj = SelectSolver(odeSolver,odeParams)
            obj.odeSolver = odeSolver;
            obj.odeParams = odeParams;
        end

        function [t, y] = expFun(obj,params)
            obj.params = params;
            fv = @(t, x) x*obj.params.r;
            [t, y] = obj.odeSolver(fv, [0, obj.params.duration], obj.params.initialValue);
        end

        function [t, y] = logFun(obj,params)
            obj.params = params;
            fv = @(t, x) x*obj.params.r*(1-x/obj.params.K);
            [t, y] = obj.odeSolver(fv, [0, obj.params.duration], obj.params.initialValue);    
        end

        function [t, y] = logRedFun(obj,params)
            obj.params = params;
            fv = @(t, x) x*obj.params.r*(1-x/obj.params.K)-obj.params.h.*x;
            [t, y] = obj.odeSolver(fv, [0, obj.params.duration], obj.params.initialValue);    
        end

        function [t, y] = neutFun(obj,params)
            obj.params = params;
            fv = @(t, x) [x(1) .* obj.params.r1; x(2) .* obj.params.r2 .* ( 1 - x(2) ./ obj.params.K2)];
            [t, y] = obj.odeSolver(fv, [0, obj.params.duration], [obj.params.initialValues(1) obj.params.initialValues(2)]);   
        end

        function [t, y] = symbExpFun(obj,params)
            obj.params = params;
            fv = @(t, x) [x(1) .* obj.params.r1 + obj.params.alpha .* x(1) .* x(2); x(2) .* obj.params.r2 + obj.params.beta .* x(1) .* x(2)];
            [t, y] = obj.odeSolver(fv, [0, obj.params.duration], [obj.params.initialValues(1) obj.params.initialValues(2)]);   
        end

        function [t, y] = symbLogFun(obj,params)
            obj.params = params;
            fv = @(t, x) [obj.params.r1 .* x(1) .* (obj.params.K1 - x(1) +obj.params.alpha .* x(2)) ./obj.params.K2 ;obj.params.r2 .* x(2) .* (obj.params.K2 - x(2) +obj.params.beta .* x(1)) ./obj.params.K2];
            [t, y] = obj.odeSolver(fv, [0, obj.params.duration], [obj.params.initialValues(1) obj.params.initialValues(2)]);   
        end
             
        function [t, y] = commFun(obj,params)
            obj.params = params;
            fv = @(t, x) [obj.params.r1 .* x(1) .* ((obj.params.K1 - x(1) + obj.params.alpha .* x(2)) ./ obj.params.K1); obj.params.r2 .* x(2) .* ((obj.params.K2 - x(2)) ./ obj.params.K2)];
            [t, y] = obj.odeSolver(fv, [0, obj.params.duration], [obj.params.initialValues(1) obj.params.initialValues(2)]);   
        end

        function [t, y] = compFun(obj,params)
            obj.params = params;
            fv = @(t, x) [obj.params.r1 .* x(1) .* ((obj.params.K1 - x(1) - obj.params.alpha .* x(2)) ./ obj.params.K1); obj.params.r2 .* x(2) * ((obj.params.K2 - x(2) - obj.params.beta .* x(1)) ./ obj.params.K2)];
            [t, y] = obj.odeSolver(fv, [0, obj.params.duration], [obj.params.initialValues(1) obj.params.initialValues(2)]);   
        end
      
        function [t, y] = predFun(obj,params)
            obj.params = params;
            fv = @(t, x) [x(1) .* obj.params.r1 - obj.params.alpha .* x(1) .*x(2); obj.params.r2 .* obj.params.alpha .* x(1) .*x(2) - obj.params.beta .* x(2)];
            [t, y] = obj.odeSolver(fv, [0, obj.params.duration], [obj.params.initialValues(1) obj.params.initialValues(2)]);   
        end

        function [t, y] = predRedFun(obj,params)
            obj.params = params;
            fv = @(t, x) [x(1) .* obj.params.r1 .* (1 - x(1) ./ obj.params.K1) - obj.params.alpha .* x(1) .*x(2); obj.params.r2 .* obj.params.alpha .* x(1) .*x(2) - obj.params.beta .* x(2)];
            [t, y] = obj.odeSolver(fv, [0, obj.params.duration], [obj.params.initialValues(1) obj.params.initialValues(2)]);   
        end

        function [t, y] = sirFun(obj,params)
            obj.params = params;
            fv = @(t, x) [-obj.params.beta .* x(1) .* x(2); obj.params.beta .* x(1) .* x(2) - obj.params.gamma .* x(2); obj.params.gamma .* x(2)];
            [t, y] = obj.odeSolver(fv, [0, obj.params.duration], [obj.params.initialValues(1) obj.params.initialValues(2) obj.params.initialValues(3)]);   
        end

        function [t, y] = sisFun(obj,params)
            obj.params = params;
            fv = @(t, x) [-(obj.params.beta .* x(1) .* x(2)) ./ (x(1)+x(2)); (obj.params.beta .* x(1) .* x(2)) ./ (x(1)+x(2)) - obj.params.gamma .* x(2)];
            [t, y] = obj.odeSolver(fv, [0, obj.params.duration], [obj.params.initialValues(1) obj.params.initialValues(2)]);   
        end

        function [t, y] = sirdFun(obj,params)
            obj.params = params;
            fv = @(t, x) [-(obj.params.beta .* x(1) .* x(2)) ./ (x(1)+x(2)+x(3)+x(4)) ; (obj.params.beta .* x(1) .* x(2)) ./ (x(1)+x(2)+x(3)+x(4)) - obj.params.gamma .* x(2) - obj.params.mu .* x(2); obj.params.gamma .* x(2) ; obj.params.mu .* x(2)];
            [t, y] = obj.odeSolver(fv, [0, obj.params.duration], [obj.params.initialValues(1) obj.params.initialValues(2) obj.params.initialValues(3) obj.params.initialValues(4)]);   
        end

        function [t, y] = siarFun(obj,params)
            obj.params = params;
            fv = @(t, x) [
                -obj.params.beta1 .* x(1) .* x(2) - obj.params.beta2 .* x(1) .* x(3); 
                obj.params.p .* (obj.params.beta1 .* x(1) .* x(2) + obj.params.beta2 .* x(1) .* x(3)) - obj.params.gamma1 .* x(2); 
                (1-obj.params.p).*(obj.params.beta1 .* x(1) .* x(2) + obj.params.beta2 .* x(1) .* x(3)) - obj.params.gamma2 .* x(3); 
                obj.params.gamma1 .* x(2) + obj.params.gamma2 .* x(3)
                ];
            [t, y] = obj.odeSolver(fv, [0, obj.params.duration], [obj.params.initialValues(1) obj.params.initialValues(2) obj.params.initialValues(3) obj.params.initialValues(4)]);   
        end

        function [t, y] = seairFun(obj,params)
            obj.params = params;
            fv = @(t, x) [
                -obj.params.betaI .* x(4) .* x(1) - obj.params.betaA .* x(3) .* x(1) + obj.params.delta .* x(5);
                obj.params.betaI .* x(4) .* x(1) + obj.params.betaA .* x(3) .* x(1) - obj.params.sigma .* x(2);
                obj.params.alpha .* obj.params.sigma .* x(2) - obj.params.dA .* x(3);
                (1 - obj.params.alpha) .* obj.params.sigma .* x(2) - obj.params.dI .* x(4);
                obj.params.dA .* x(3) + obj.params.dI .* x(4) - obj.params.delta .* x(5)      
            ];
            [t, y] = obj.odeSolver(fv, [0, obj.params.duration], [obj.params.initialValues(1) obj.params.initialValues(2) obj.params.initialValues(3) obj.params.initialValues(4) obj.params.initialValues(5)]);   
        end
    end
end
