classdef SolveDTSS
    properties
        params;
        sStep;
    end
    
    methods
        function obj = SolveDTSS(params,sStep)
            obj.params = params;
            obj.sStep = sStep;
        end

        function [t, y] = expFun(obj)
            t = 1;
            y = obj.params.initialValue;
            for i = 2 : obj.params.duration
                y(i) = y(i-1) + y(i-1).*obj.params.r;
                t(i) = t(i-1)+obj.sStep;
            end
        end

        function [t, y] = logFun(obj)
            t = 1;
            y = obj.params.initialValue;
            for i = 2 : obj.params.duration
                y(i) = y(i-1) + y(i-1).*obj.params.r - (obj.params.r.*y(i-1).*y(i-1))/obj.params.K;
                t(i) = t(i-1)+obj.sStep;
            end
        end

        function [t, y] = harvFun(obj)
            t = 1;
            y = obj.params.initialValue;
            for i = 2 : obj.params.duration
                y(i) = y(i-1) + y(i-1).*obj.params.r - (obj.params.r.*y(i-1).*y(i-1))/obj.params.K - obj.params.h;
                t(i) = t(i-1)+obj.sStep;
            end
        end

        function [t, y] = fiboFun(obj)
            t = 1;
            t(2) = 2;
            y = obj.params.initialValues(1);
            y(2) = obj.params.initialValues(2);
            for i = 3 : obj.params.duration
                y(i) = y(i-2) + y(i-1);
                t(i) = t(i-1)+obj.sStep;
            end
        end

        function [t, y] = catalFun(obj)
            t = 1;
            y = obj.params.initialValue;
            for i = 1 : obj.params.duration
                y(i+1) = 2.*(2*i+1)/(i+2).*y(i);
                t(i+1) = t(i)+obj.sStep;
            end
        end

        function [t, y] = kolcsFun(obj)
            t = 1;
            y = obj.params.initialValue
            for i = 2 : obj.params.duration;
                y(i) = (obj.params.r./12 + 1) .* y(i-1)-obj.params.p ;
                t(i) = t(i-1)+obj.sStep;
            end
        end

        function [t, y] = lifeLikeCAFun(obj)
            t = 1;
            y = obj.params.initialValue
            for i = 2 : obj.params.duration;
                y(i) = (obj.params.r./12 + 1) .* y(i-1)-obj.params.p ;
                t(i) = t(i-1)+obj.sStep;
            end
        end

    end
end
