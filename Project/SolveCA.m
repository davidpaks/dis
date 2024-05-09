classdef SolveCA
    properties
        params;
    end
    
    methods
        function obj = SolveCA(params)
            obj.params = params;
        end

        function res = wolframFun(obj)
            rule = obj.params.rule;
            aliveCells = obj.params.aliveCells;
            res = zeros(obj.params.duration,obj.params.x,obj.params.duration);
            
            rule_bin = dec2bin(rule);
            rule_array = zeros(1,8);
            for i=1:length(rule_bin)
                rule_array(i+8-length(rule_bin)) = str2num(rule_bin(i));
            end
            A = zeros(1,obj.params.x);
            aliveCells = split(aliveCells,",")
            for i=1:length(aliveCells)
                A(str2num(char(aliveCells(i))))=1;
            end
            if length(char(aliveCells)) == 0
                for i = 1:100
                    A(1,randi(obj.params.x)) = randi(2)-1;
                end
            end
            l = length(A);
            for i = 2:obj.params.duration
                for j = 2:l-1
                    A(i,j) = rule_array(8-bin2dec(strcat(num2str(A(i-1,j-1)),num2str(A(i-1,j)),num2str(A(i-1,j+1)))));
                end
                A(i,1) = rule_array(8-bin2dec(strcat(num2str(A(i-1,l)),num2str(A(i-1,j)),num2str(A(i-1,j+1)))));
                A(i,l) = rule_array(8-bin2dec(strcat(num2str(A(i-1,j-1)),num2str(A(i-1,j)),num2str(A(i-1,1)))));
            end            
            for i=1:obj.params.duration
                res(:,:,i) = A;
            end
            for i=obj.params.x:-1:2
                res(i:obj.params.duration,:,i-1) = zeros(obj.params.duration-(i-1),obj.params.x);
            end
        end

        function res = lifeLikeFun(obj)
            map = zeros(obj.params.x,obj.params.y);
            h = height(map);
            l = length(map);
            cycle = obj.params.duration;
            aliveCells = obj.params.aliveCells
            %aliveCells = extractBetween("(5,5) (5,6) (6,5) (7,6) (7,8) (3,13) (12,17) (20,20) (20,21) (21,20) (21,21)","(",")");
            aliveCells = extractBetween(aliveCells,"(",")");
            
            bRule = obj.params.bRule;
            sRule = obj.params.sRule;
            
            bRule = char(bRule);
            sRule = char(sRule);
            
            tmp = [];
            for i = 1:length(aliveCells)
                c = split(aliveCells(i),",");
                c = char(c);
                for j = 1:length(c)
                     tmp(j) = str2num(c(j,:));
                end
                map(tmp(1),tmp(2)) = 1;
            end
            
            if obj.params.aliveCells==""
                for i = 1:10000
                    map(randi(l),randi(h)) = randi(2);
                end
                map(:,1)=0; map(:,h)=0; map(1,:)=0; map(l,:)=0;
            end
            index = 1;
            res(:,:,index) = map;
            B = map;
            for k = 1:cycle
                for i = 2:l-1
                    for j = 2:h-1
                        B(i,j) = map(i,j);
                        %Calc neighbor
                        count = 0;
                        for m = -1:1
                            for n = -1:1
                                count = count + map(i+m,n+j);
                            end
                        end
                        count = count - map(i,j);
            
                        value = false;
                        state = map(i,j);
                        if state == 0  %% Birth 
                            for p = 1:length(bRule)
                                if str2num(bRule(p)) == count
                                    value = true;
                                end
                            end
                        else           %% Survive
                            for p = 1:length(sRule)
                                if str2num(sRule(p)) == count
                                    value = true;
                                end
                            end
                        end
                        if value
                            B(i,j) = 1;
                        else
                            B(i,j) = 0;
                        end
                    end
                end
                map = B;
                index = index+1;
                res(:,:,index) = map;
            end
        end

    end
end
