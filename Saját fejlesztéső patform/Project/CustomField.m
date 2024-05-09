classdef CustomField
    properties (Access = private)
        name, value, row, label, field, app, variableName, tooltip, legend
    end
    
    methods
        function obj = CustomField(app,name,tooltip,variableName,value,row,legend)
            obj.app = app;
            obj.name = name;
            obj.value = value;
            obj.row = row;
            obj.variableName = variableName;
            obj.tooltip = tooltip;
            if ~exist('legend','var')
                obj.legend = "";
            else
            obj.legend = legend;
            end

            obj.label = uilabel(app.LabelsGrid);
            obj.label.Interpreter = 'latex';
            obj.label.Layout.Row = row;
            obj.label.Layout.Column = 1;
            obj.label.Text = name;
            obj.label.Tooltip = tooltip;

            obj.field = uieditfield(app.LabelsGrid);
            obj.field.Layout.Row = row;
            obj.field.Layout.Column = 2;
            obj.field.Value = value;
        end
        function delete(obj)
            obj.label.delete()
            obj.field.delete()
        end
        function result = getVariableName(obj)
            result = obj.variableName;
        end
        function result = getFieldValue(obj)
            result = obj.field.Value;
        end
        function result = getLegend(obj)
            result = obj.legend;
        end
    end
end

