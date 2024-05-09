classdef SettingsField < matlab.apps.AppBase
    properties (Access = private)
        app
        name
        variableName
        value
        row
        callbackFun

        
    end
    properties (Access = public)
        label
        field
    end
    
    methods
        function obj = SettingsField(app,name,variableName,value,row,callbackFun)
            obj.app = app;
            obj.name = name;
            obj.variableName = variableName;
            obj.value = value;
            obj.row = row;
            

            obj.label = uilabel(app.TypeSpecificOptionsGrid);
            obj.label.Layout.Row = row;
            obj.label.Layout.Column = 1;
            obj.label.Text = name;

            if ~exist('callbackFun','var')
                obj.callbackFun = @obj.noCallbackFun;
            else
                obj.callbackFun = callbackFun;
            end
            
            if length(value) > 1
                obj.field = uidropdown(app.TypeSpecificOptionsGrid,"Items",value,"ValueChangedFcn",@(src, event) obj.valueChangedCallback(src, event));
                obj.field.Layout.Row = row;
                obj.field.Layout.Column = 2;
            else
                obj.field = uieditfield(app.TypeSpecificOptionsGrid);
                obj.field.Layout.Row = row;
                obj.field.Layout.Column = 2;
                obj.field.Value = value;
            end
        end
        function valueChangedCallback(obj, ~, ~)
            obj.callbackFun()
        end
        function delete(obj)
            obj.label.delete()
            obj.field.delete()
        end    
        function noCallbackFun(obj)
        
        end
        function result = getFieldValue(obj)
            result = obj.field.Value;
        end
        function result = getVariableName(obj)
            result = obj.variableName;
        end
    end
end

