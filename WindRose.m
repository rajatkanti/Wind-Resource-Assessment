function [figure_handle,count,speeds,directions,Table] = WindRose(direction,speed,varargin)
    %% WindRose
    %  Draw a Wind Rose knowing direction and speed
    %
    %  [figure_handle,count,speeds,directions,Table] = WindRose(direction,speed);
    %  [figure_handle,count,speeds,directions,Table] = WindRose(direction,speed,'parameter1',value1,...);
    %
    %  figure_handle is the handle of the figure containing the chart
    %  count is the frequency for each speed (ncolumns = nspeeds) and for each direction (nrows = ndirections).
    %  speeds is a 1 by n vector containing the values for the speed intervals
    %  directions is a m by 1 vector containing the values in which direction intervals are centered
    %  Table is a (4+m) by (3+m) cell array (excel-ready), containing Frequencies for each direction and for each speed. 
    %
    %  User can specify direction angle meaning North and East winds, so
    %  the graphs is shown in the desired reference
    %
    %     % Example:
    %     %----------------------------------------------------------------
    %     d = 360 * rand(10000,1); % My reference is North = 0º, East = 90º.
    %     v = 30*rand(10000,1);
    %
    %     % Default notation with several input arguments
    %     [figure_handle,count,speeds,directions,Table] = WindRose(d,v,'anglenorth',0,'angleeast',90,'labels',{'N (0°)','S (180°)','E (90°)','W (270°)'},'freqlabelangle',45);
    %
    %     % All the wind rose options into a cell array, so function call can be simplified
    %     Properties = {'anglenorth',0,'angleeast',90,'labels',{'N (0°)','S (180°)','E (90°)','W (270°)'},'freqlabelangle',45};
    %     [figure_handle2,count2,speeds2,directions2,Table2] = WindRose(d,v,Properties);
    %     
    %     % All the wind rose options into a structure, so function call can be simplified.
    %     Options.AngleNorth     = 0;
    %     Options.AngleEast      = 90;
    %     Options.Labels         = {'N (0°)','S (180°)','E (90°)','W (270°)'};
    %     Options.FreqLabelAngle = 45;
    %     [figure_handle3,count3,speeds3,directions3,Table3] = WindRose(d,v,Options);
    %
    %
    %
    % PARAMETER             CLASS           DEFAULT VALUE           DESCRIPTION
    %------------------------------------------------------------------------------------------------------------------------------------------------------------
	% 'centeredin0'         Logical.        true                    Is first angular bin centered in 0 (-5 to 5)? -> CeteredIn0 = true // or does it start in 0 (0 to 10)? -> CeteredIn0 = false.
    % 'ndirections'         Numeric.        36                      Number of direction bins (subdivisions) to be shown.
    % 'freqround'           Numeric.        1                       Maximum frquency value will be rounded to the first higher whole multiple of FrequenciesRound. Only applies if 'maxfrequency' is specified.
    % 'nfreq'               Numeric.        5                       Draw this number of circles indicating frequency.
    % 'speedround'          Numeric.        [] (auto)               Maximum wind speed will be rounded to the first higher whole multiple of WindSpeedRound.
    % 'nspeeds'             Numeric.        [] (auto) or 6          Draw this number of windspeeds subdivisions (bins). Default is 6 if 'speedround' is specified. Otherwise, default is automatic.
    % 'maxfrequency'        Numeric.        [] (auto)               Set the value of the maximum frequency circle to be displayed. Be careful, because bins radius keep the original size.
    % 'freqlabelangle'      Numeric/String. [] (auto)               Angle in which frequecy labels are shown. If this value is empty or is NaN, the frequency labels will NOT be shown. Trigonometric reference. 0=Right, 90=Up. You can use 'auto' to show them in the optimal position. Use 'ruler' or 'RulerRight' to show frequencies as if it was a ruler to the right of the plot. Use 'RulerLeft', to show the frequencies in ruler format to the left. 
    % 'titlestring'         Cell/String.    {'Wind Rose';' '}       Figure title. It is recommended to include an empty line below the main string.
    % 'lablegend'           String.         'Wind speeds in m/s'    String that will appear at the top of the legend. Can be empty.
    % 'legendvariable'      String.         'W_S'                   Variable abbreviation that appears inside the legend. You can use TeX sequences.
    % 'cmap'                Numeric/String. 'parlua/jet'            N×3 RGB map or String with the name of a colormap function. If the string option is chosen and if you put inv before the name of the colormap funcion, colors will be flipped (e.g. 'invjet', 'invautum', 'invbone', 'invparula', ...). Use any of the built-in functions (autumn, bone, colorcube, cool, copper, flag, gray, hot, hsv, jet, lines, pink, prism, spring, summer, white, winter). See doc colormap for more information.
    % 'height'              Numeric.        2/3*screensize          Figure inner height in pixels. Default is 2/3 of minimum window dimension;
    % 'width'               Numeric.        2/3*screensize          Figure inner width in pixels.  Default is 2/3 of minimum window dimension;
    % 'figcolor'            Color Code.     'w'                     Figure color, any admitted matlab color format. Default is white. If 'axes' is specified, figure color will be used as background color.
    % 'textcolor'           Color Code.     'k'                     Text and axis color, any admitted matlab color format. Default is black.
    % 'labels'              CellString      {'N','E','S','W'}       Specify North South East West in a cell array of strings. Now you can specify as many as you want, for example: {'N','NE','E','SE','S','SW','W','NW'}
    % 'labelnorth'          Cell/String.    'N'                     Label to indicate North. Be careful if you specify 'labels' and 'labelnorth'. Last parameter specified will be the one used.
    % 'labelsouth'          Cell/String.    'S'                     Label to indicate South. Be careful if you specify 'labels' and 'labelsouth'. Last parameter specified will be the one used.
	% 'labeleast'           Cell/String.    'E'                     Label to indicate East.  Be careful if you specify 'labels' and 'labeleast' . Last parameter specified will be the one used.
    % 'labelwest'           Cell/String.    'W'                     Label to indicate West.  Be careful if you specify 'labels' and 'labelwest' . Last parameter specified will be the one used.
    % 'titlefontweight'     String.         'bold'                  Title font weight. You can use 'normal','bold','light','demi'
    % 'anglenorth'          Numeric.        90                      Direction angle meaning North wind. Default is 90 for North (trigonometric reference). If you specify 'north' angle, you need to specify 'east' angle, so the script knows how angles are referenced.
    % 'angleeast'           Numeric.        0                       Direction angle meaning East wind.  Default is  0 for East  (counterclockwise).        If you specify 'east' angle, you need to specify 'north' angle, so the script knows how angles are referenced.
    % 'min_radius'          Numeric.        1/15                    Minimum radius of the wind rose, relative to the maximum frequency radius. An empty circle of this size appears if greater than 0.
    % 'legendtype'          Numeric.        2                       Legend type continuous = 1 (colorbar), separated boxes = 2 (legend)
    % 'toolbar'             String.         'figure'                Choose if you want to show figure's toolbar ('figure') or hide it ('none')
    % 'menubar'             String.         'figure'                Choose if you want to show figure's menubar ('figure') or hide it ('none')
    % 'colors'              Num Array.      []                      If 'nspeeds' has been specified, colors can be a nspeeds-by-3 array (R G B), containing the color for each speed (lowest in first row, highest in last row). Color components must be in range 0 to 1.      
    % 'inverse'             Logical.        false                   Specify if slowest speeds are shown in the outermost side of the rose (true) or if slowest speeds are shown in the center of the rose (false). cmap is automatically inverted.
    % 'vwinds'              Num Array.      []                      Specify the wind speeds that you want to appear on the windrose, instead of just specifying the number of speed bins
    % 'scalefactor'         Numeric.        1                       Specify the relative size of the windrose inside the figure 1=max, 0= not showing
    % 'axes'                Numeric.        []                      Specify the axes handle in which the wind rose will be represented. Use 'axes',gca to plot the wind rose in the current axes
    % 'gridcolor'           Matlab color.   'k'                     Specify the grid color (for both, radial an circular grid) 
    % 'gridstyle'           Line style.     ':' & '-'               Specify the grid line style (for both, radial an circular grid)
    % 'gridwidth'           Numeric.        0.5                     Specify the grid line width (for both, radial an circular grid)
    % 'gridalpha'           Numeric.        0.3                     Specify the grid line alpha (for both, radial an circular grid) - Only available in version 8.4 and above
    % 'radialgridcolor'     Matlab color.   'k'                     Specify the radial grid color
    % 'radialgridstyle'     Line style.     ':' & '-'               Specify the radial grid line style
    % 'radialgridwidth'     Numeric.        0.5                     Specify the radial grid line width
    % 'radialgridalpha'     Numeric.        0.3                     Specify the radial grid line alpha - Only available in version 8.4 and above
    % 'circulargridcolor'   Matlab color.   'k'                     Specify the circular grid color
    % 'circulargridstyle'   Line style.     ':' & '-'               Specify the circular grid line style
    % 'circulargridwidth'   Numeric.        0.5                     Specify the circular grid line width
    % 'circulargridalpha'   Numeric.        0.3                     Specify the circular grid line alpha - Only available in version 8.4 and above
    % 'radialgridnumber'    Numeric.        12                      Specify the number of the grid radial divisions 
    % 'zeroandnegative'     Boolean         false                   Specify if you want to show zero and negative values in the plot
    % 'textfontname'        String          'Helvetica'             Specify font name for frequency and axis labels
    % 'titlefontname'       String          'Helvetica'             Specify font name for title string
    % 'legendfontname'      String          'Helvetica'             Specify font name for legend strings
    % 'X'                   Numeric.        0                       Set where to place the wind rose by coordinates X and Y
    % 'Y'                   Numeric.        0                       Set where to place the wind rose by coordinates X and Y
    % 'CenterLocation'      Numeric 2�1.    [0,0]                   Set where to place the wind rose by coordinates X and Y
    %
    %
    % by Daniel Pereira - daniel.pereira.valades@gmail.com
    %
    % 2014/Jul/14 - First version
    % 2014/Jul/28 - Figure has options to hide/show menubar and toolbar. Default is that menubar and toolbar are shown.
    %               Default min_radius is 1/15 instead of 1/30.
    %               User can specify speed bins 'colors' (necessary that nspeeds or vwinds are specified)
    %               Order of the speeds can be modified: lowest speeds inside ('inverse',false) -default- or lowest speeds outside ('inverse',true)
    %               Speed bins can be explicitly defined ('vwinds'), instead of just defining the number of the speed bins
    %               Corrected bug when showing colorbar ('legendtype',2) with cmap other than jet
    %               All options can now be passed to the function into a single cell array or a structure, where fieldnames are the property to be modified.
    % 2015/Feb/22 - Corrected small errors.
    %               Created extra documentation.
    %               Corrected help dialog
    % 2015/Mar/13 - Added option to represent windrose inside given axes handle
    % 2015/Jun/22 - Corrected histogram count inside function "PivotTableCount", which didn't consider always values greater than the max(vwinds) value.
    % 2020/Mar/03 - Changed the way in which labels are read. The order now should be 'North','East','South','West'.
    %               Added options for grid line styles (color, line style and transparency/alpha) both for radial and circular grids.
    %               Added option for variable adial divisions.
    %               New angular-label options, now the function is able to support several labels in form of a cell array, which will be equally spaced.
    %               cMap now allows a N×3 array of colors, which will be interpolated for the number of speeds shown (previously, the only option was to put these colors into 'colors' with a number if colors matching the 'nspeeds')
    %               Added ability to change text, title and legend font through 'textfontname', 'titlefontname' and 'legendfontname' respectively
    %               Added option to show frequency labels in the best place possible, with 'auto' option for 'freqlabelangle'
    %               Added ability to plot zero and negative data
    % 2020/Mar/04 - Added option to plot the windrose in the desired position (X,Y) in a plot. This is very useful combined with scalefactor.
    % 2021/Apr/20 - Added option to show frequencies as in a ruler (thanks to Jacqueline Freire Rigatto for the idea)
    %               Added a space below the title string so it does not interfere with the upper label
    %               Added the variable name into legend type 1 (colorbar)
    
    %% Check funciton call
    if nargin<2
        error('WindRose needs at least two inputs');        % function needs 2 input arguments
    elseif mod(length(varargin),2)~=0                       % If varargin are not paired
        if (length(varargin)==1 && isstruct(varargin{1}))   % Could be a single structure with field names and field values.
            varargin = reshape([fieldnames(varargin{1}) struct2cell(varargin{1})]',1,[]); % Create varargin as if they were separate inputs
        elseif (length(varargin)==1 && iscell(varargin{1})) % Could be a single cell array with all the varargins
            varargin = reshape(varargin{1},1,[]);           % Reshape just in case, and create varargin as if they were separate inputs.
        else
            error('Inputs must be paired: WindRose(Speed,Direction,''PropertyName'',PropertyValue,...)'); % If not any of the two previous cases, error
        end
    elseif ~isnumeric(speed) || ~isnumeric(direction)       % Check that speed and direction are numeric arrays.
        error('Speed and Direction must be numeric arrays.');
    elseif ~isequal(size(speed),size(direction))            % Check that speed and direction are the same size.
        error('Speed and Direction must be the same size.');
    end

%% Default parameters
SCS                     = get(0,'screensize');

CeteredIn0              = true;
ndirections             = 36;
FrequenciesRound        = 1;
NFrequencies            = 5;
WindSpeedRound          = [];
NSpeeds                 = [];
circlemax               = [];
FreqLabelAngle          = [];
TitleString             = 'Wind Rose';
lablegend               = 'Wind Speeds in m/s';
height                  = min(SCS(3:4))*2/3;
width                   = min(SCS(3:4))*2/3;
figcolor                = 'w';
TextColor               = 'k';
label.N                 = 'N';
label.S                 = 'S';
label.W                 = 'W';
label.E                 = 'E';
titlefontweight         = 'bold';
legendvariable          = 'W_S';
RefN                    = 90;
RefE                    = 0;
min_radius              = 1/15;
LegendType              = 2;
MenuBar                 = 'figure';
ToolBar                 = 'figure';
colors                  = [];
inverse                 = false;
vwinds                  = [];
scalefactor             = 1;
axs                     = [];
hg2_support             = ~verLessThan('matlab', '8.4');
% hg2_support               = ([1 0.01]*sscanf(version,'%d.',2)>=8.40);
RadialGridColor         = 'k';
CircularGridColor       = 'k';
RadialGridWidth         = 0.5;
CircularGridWidth       = 0.5;
Ngridradius             = 12;
considerZeroAndNegative = false;
titlefontname           = 'Helvetica';
textfontname            = 'Helvetica';
legendfontname          = 'Helvetica';

X = 0;
Y = 0;

if ~hg2_support
    RadialGridStyle   = ':';
    CircularGridStyle = ':';
    RadialGridAlpha   = 1;
    CircularGridAlpha = 1;
else
    RadialGridStyle   = '-';
    CircularGridStyle = '-';
    RadialGridAlpha   = 0.3;
    CircularGridAlpha = 0.3;
end

if (exist('parula','builtin') || exist('parula','file'))
    colorfun     = 'parula';
else
    colorfun     = 'jet';
end

%% User-.specified parameters
figcolorspecif    = false;
alphawarningshown = false;
lots_of_labels    = false;
colormap_set      = false;
XYposition_set    = false;

for i=1:2:numel(varargin)
    switch lower(varargin{i})
        case 'centeredin0'
            CeteredIn0       = varargin{i+1};
        case 'ndirections'
            ndirections      = varargin{i+1};
        case 'freqround'
            FrequenciesRound = varargin{i+1};
        case 'nfreq'
            NFrequencies     = varargin{i+1}; 
        case 'speedround'
            WindSpeedRound   = varargin{i+1};
        case 'nspeeds'
            NSpeeds          = varargin{i+1};
        case 'freqlabelangle'
            FreqLabelAngle   = varargin{i+1};
        case 'titlestring'
            TitleString      = varargin{i+1};
        case 'lablegend'
            lablegend        = varargin{i+1};
        case 'cmap'
            colorfun         = varargin{i+1};
            if ~ischar(colorfun) && size(colorfun,1)>1 && size(colorfun,2)==3
                colormap_set = true;
            elseif ~ischar(colorfun) && size(colorfun,1)<=1 && size(colorfun,2)~=3
                error('You can specify a color array for defining the colormap to be used, but an array of at least 2×3 must be used');
            end
        case 'height'
            height           = varargin{i+1};
        case 'width'
            width            = varargin{i+1};
        case 'textcolor'
            TextColor        = varargin{i+1};
        case 'figcolor'
            figcolor         = varargin{i+1};
            figcolorspecif   = true;
        case 'min_radius'
            min_radius       = varargin{i+1};
        case 'maxfrequency'
            circlemax        = varargin{i+1};
        case 'titlefontweight'
            titlefontweight  = varargin{i+1};
        case 'legendvariable'
            legendvariable   = varargin{i+1};
        case 'legendtype'
            LegendType       = varargin{i+1};
        case 'inverse'
            inverse          = varargin{i+1};
        case 'labelnorth'
            label.N          = varargin{i+1};
        case 'labelsouth'
            label.S          = varargin{i+1};
        case 'labeleast'
            label.E          = varargin{i+1};
        case 'labelwest'
            label.W          = varargin{i+1};
        case 'labels'
            if length(varargin{i+1})==4
                label.N          = varargin{i+1}{1};
                label.E          = varargin{i+1}{2};
                label.S          = varargin{i+1}{3};
                label.W          = varargin{i+1}{4};
            else
                lots_of_labels = true;
                label          = varargin{i+1};
                if ~any(arrayfun(@(x) strcmpi(x,'radialgridnumber'),varargin))
                    Ngridradius = length(label);
                end
            end
        case 'menubar'
            MenuBar          = varargin{i+1};
        case 'toolbar'
            ToolBar          = varargin{i+1};
        case 'scalefactor'
            scalefactor      = varargin{i+1};
        case 'vwinds'
            k = any(arrayfun(@(x) strcmpi(x,'nspeeds'),varargin));
            if k
                warning('''vwinds'' and ''nspeeds'' have been specified. The value for ''nspeeds'' wil be omitted');
            end
            vwinds           = varargin{i+1};
        case 'colors'
            k = any(arrayfun(@(x) strcmpi(x,'nspeeds'),varargin)) + any(arrayfun(@(x) strcmpi(x,'vwinds'),varargin));
            if ~k
                error('To specify ''colors'' matrix, you need to specify the number of speed bins ''nspeeds'' or the speeds to be used ''vwinds''');
            end
            k = any(arrayfun(@(x) strcmpi(x,'cmap'),varargin));
            if k
                warning('Specified CMAP is not being used, since ''colors'' argument has been set by user');
            end
            colors           = varargin{i+1};
        case 'anglenorth'
            k = any(arrayfun(@(x) strcmpi(x,'angleeast'),varargin));
            if ~k
                error('Reference angles need to be specified for AngleEAST and AngleNORTH directions');
            end
        case 'angleeast'
            k = find(arrayfun(@(x) strcmpi(x,'anglenorth'),varargin));
            if isempty(k)
                error('Reference angles need to be specified for AngleEAST and AngleNORTH directions');
            else
                RefE         = varargin{i+1};
                RefN         = varargin{k+1};
            end
            if abs(RefN-RefE)~=90
                error('The angles specified for north and east must differ in 90 degrees');
            end
        case 'axes'
            axs = varargin{i+1};
        case 'gridcolor'
            if ~any(arrayfun(@(x) strcmpi(x,'radialgridcolor'),varargin))
                RadialGridColor = varargin{i+1};
            end
            if ~any(arrayfun(@(x) strcmpi(x,'circulargridcolor'),varargin))
                CircularGridColor = varargin{i+1};
            end
        case 'gridstyle'
            if ~any(arrayfun(@(x) strcmpi(x,'radialgridstyle'),varargin))
                RadialGridStyle = varargin{i+1};
            end
            if ~any(arrayfun(@(x) strcmpi(x,'circulargridstyle'),varargin))
                CircularGridStyle = varargin{i+1};
            end
        case 'gridwidth'
            if ~any(arrayfun(@(x) strcmpi(x,'radialgridwidth'),varargin))
                RadialGridWidth = varargin{i+1};
            end
            if ~any(arrayfun(@(x) strcmpi(x,'circulargridwidth'),varargin))
                CircularGridWidth = varargin{i+1};
            end
        case 'gridalpha'
            if ~hg2_support && ~alphawarningshown
                warning('Line Alpha is now supported by this matlab version\nGrid Line will be fully opaque. Use ''gridstyle'','':'' as an appropiate grid style');
                alphawarningshown = true;
            end
            if ~any(arrayfun(@(x) strcmpi(x,'radialgridalpha'),varargin))
                RadialGridAlpha = varargin{i+1};
            end
            if ~any(arrayfun(@(x) strcmpi(x,'circulargridalpha'),varargin))
                CircularGridAlpha = varargin{i+1};
            end
        case 'radialgridcolor'
            RadialGridColor   = varargin{i+1};
        case 'circulargridcolor'
            CircularGridColor = varargin{i+1};
        case 'radialgridstyle'
            RadialGridStyle   = varargin{i+1};
        case 'circulargridstyle'
            CircularGridStyle = varargin{i+1};
        case 'radialgridwidth'  
            RadialGridWidth   = varargin{i+1};
        case 'circulargridwidth'    
            CircularGridWidth = varargin{i+1};
        case 'radialgridalpha'
            if ~hg2_support && ~alphawarningshown
                warning('Line Alpha is now supported by this matlab version\nGrid Line will be fully opaque. Use ''gridstyle'','':'' as an appropiate grid style');
                alphawarningshown = true;
            end
            RadialGridAlpha   = varargin{i+1};
        case 'circulargridalpha'
            if ~hg2_support && ~alphawarningshown
                warning('Line Alpha is now supported by this matlab version\nGrid Line will be fully opaque. Use ''gridstyle'','':'' as an appropiate grid style');
                alphawarningshown = true;
            end
            CircularGridAlpha = varargin{i+1};
        case 'radialgridnumber'
            Ngridradius = varargin{i+1};
        case 'zeroandnegative'
            considerZeroAndNegative = varargin{i+1};
        case 'titlefontname'
            titlefontname = varargin{i+1};
        case 'textfontname'
            textfontname = varargin{i+1};
        case 'legendfontname'
            legendfontname = varargin{i+1};
        case 'x'
            X = varargin{i+1};
            XYposition_set = true;
        case 'y'
            Y = varargin{i+1};
            XYposition_set = true;
        case 'centerlocation'
            X = varargin{i+1}(1);
            Y = varargin{i+1}(2);
            XYposition_set = true;
        otherwise
            error([varargin{i} ' is not a valid property for WindRose function.']);
    end
end

CenterLocation.X = X;
CenterLocation.Y = Y;
CenterLocation.S = XYposition_set;

if ~isempty(vwinds)
    vwinds  = unique(reshape(vwinds(:),1,[]));    % ?? Should have used vwinds  = unique([0 reshape(vwinds(:),1,[])]); to ensure that values in the interval [0 vmin) appear. If user want hat range to appear, 0 must be included.
    NSpeeds = length(vwinds);
end

if ~isempty(colors)
    if ~isequal(size(colors),[NSpeeds 3])
        error('colors must be a nspeeds by 3 matrix');
    end
    if any(colors(:)>1) || any(colors(:)<0)
        error('colors must be in the range 0-1');
    end
end

if inverse
    colorfun = regexprep(['inv' colorfun],'invinv','');
    colors   = flipud(colors);
end

speed            = reshape(speed,[],1);                                    % Convert wind speed into a column vector
direction        = reshape(direction,[],1);                                % Convert wind direction into a column vector
NumberElements   = numel(direction);                                       % Coun the actual number of elements, to consider winds = 0 when calculating frequency.
dir              = mod((RefN-direction)/(RefN-RefE)*90,360);               % Ensure that the direction is between 0 and 360�
if ~considerZeroAndNegative
    dir          = dir(speed>0);                                           % Wind = 0 does not have direction, so it cannot appear in a wind rose, but the number of appeareances must be considered.
    speed        = speed(speed>0);                                         % Only show winds higher than 0. �Why? See comment before.
end

if ~CenterLocation.S
    if isempty(axs) % If no axes were specified, create a new figure
        figure_handle = figure('color',figcolor,'units','pixels','position',[SCS(3)/2-width/2 SCS(4)/2-height/2 width height],'menubar',MenuBar,'toolbar',ToolBar);
    else % If axes are specified, use the figure in which the axes are located
        figure_handle = get(axs,'parent');
        if ~figcolorspecif; figcolor = get(figure_handle,'color'); end
    end
else
    figure_handle = get(gca,'parent');
end

%% Bin Directions
N     = linspace(0,360,ndirections+1);                                     % Create ndirections direction intervals (ndirections+1 edges)
N     = N(1:end-1);                                                        % N is the angles in which direction bins are centered. We do not want the 360 to appear, because 0 is already appearing.
n     = 180/ndirections;                                                   % Angle that should be put backward and forward to create the angular bin, 1st centered in 0
if ~CeteredIn0                                                             % If user does not want the 1st bin to be centered in 0º
    N = N+n;                                                               % Bin goes from 0 to 2n (N to N+2n), instead of from -n to n (N-n to N+n), so Bin is not centered in 0 (N) angle, but in the n (N+n) angle
end

%% Bin intensities
if isempty(vwinds)                                                         % If user did not specify the wind speeds he/she wants to show
    if ~isempty(WindSpeedRound)                                            % If user did specify the rounding value
        if isempty(NSpeeds); NSpeeds = 6; end                              % Default value for NSpeeds if not user-specified
        vmax      = ceil(max(speed)/WindSpeedRound)*WindSpeedRound;        % Max wind speed rounded to the nearest whole multiple of WindSpeedRound (Use round or ceil as desired)
                    if vmax==0; vmax=WindSpeedRound; end                   % If max wind speed is 0, make max wind to be WindSpeedRound, so wind speed bins are correctly shown.
        vwinds    = linspace(0,vmax,NSpeeds);                              % Wind speeds go from 0 to vmax, creating the desired number of wind speed intervals
    else                                                                   % If user did nor specify the rounding value
        figure2 = figure('visible','off'); plot(speed);                    % Plot wind speed
        vwinds = get(gca,'ytick'); delete(figure2);                        % Yaxis will automatically make divisions for us.
        if ~isempty(NSpeeds)                                               % If a number of speeds are specified
            vwinds = linspace(min(vwinds),max(vwinds),NSpeeds);            % create a vector with that number of elements, distributed along the plotted windspeeds. 
        end 
    end
end

%% Histogram in each direction + Draw
count       = PivotTableCount(N,n,vwinds,speed,dir,NumberElements);        % For each direction and for each speed, value of the radius that the windorose must reach (Accumulated in speed).

if isequal(lower(FreqLabelAngle),'auto')
    [~,idxmin]  = min(count(:,end));                                       % Find the direction with the least number of elements
    DirFreqAuto = N(idxmin);                                               % The angle at which the lowest cumulative frequency appears
    FreqLabelAngle = 90-DirFreqAuto;                                       % Convert from the patch drawing reference (x=sin(alpha), y=cos(alpha)) to the label drawing reference (x=cos(theta), y=sin(theta)) => theta = 90-alpha
end

if isequal(lower(FreqLabelAngle),'none')                                   % If the freqlabelangle is set to none
    FreqLabelAngle = NaN;                                                  % Set the angle to be nan, so frequencies do not appear.
end

ruler = false;
if isequal(lower(FreqLabelAngle),'ruler') || isequal(lower(FreqLabelAngle),'rulerright') % If the freqlabelangle is set to ruler or rulerright
    ruler = 'right';                                                       % Set the type of ruler
    FreqLabelAngle = [];                                                   % Set the angle to be empty, so frequencies do not appear.
end
if isequal(lower(FreqLabelAngle),'rulerleft')                              % If the freqlabelangle is set to ruler or rulerright
    ruler = 'left';                                                        % Set the type of ruler
    FreqLabelAngle = [];                                                   % Set the angle to be empty, so frequencies do not appear.
end

if isempty(circlemax)                                                      % If no max frequency is specified
    circlemax = ceil(max(max(count))/FrequenciesRound)*FrequenciesRound;   % Round highest frequency to closest whole multiple of theFrequenciesRound  (Use round or ceil as desired)
end

circles     = linspace(0,circlemax,NFrequencies+1); circles = circles(2:end);% Radii of the circles that must be drawn (frequencies). We do not want to spend time drawing radius=0.
min_radius  = min_radius*circlemax;                                         % The minimum radius is initially specified as a fraction of the circle max, convert it to absolute units.
radius      = circles    + min_radius;                                      % for each circle, add the minimum radius
radiusmax   = circlemax  + min_radius;

escala      = scalefactor/radiusmax;

isaxisempty = isempty(axs);                                                % isaxisempty will allow us to identify whether the axes where specified or not, because we are going to assign in the next line a value, so axs will be never again empty.
[color,axs] = DrawPatches(N,n,vwinds,count,colorfun,figcolor,min_radius,colors,inverse,axs,colormap_set,escala,CenterLocation); % Draw the windrose, knowing the angles, the range for each direction, the speed ranges, the count (frequency) values, the colormap used and the colors used.

if ~CenterLocation.S
axis off;                                                                  % turn axis off if axis was not defined
end
axis equal;                                                                % equal axis


if isaxisempty; set(axs,'position',[0 0 1 1]); end                         % If no axes were specified, set the axes position to fill the whole figure.
%% Constant frequecy circles and x-y axes + Draw + Labels

[x,y]     = cylinder(1,400); x = x(1,:); y = y(1,:);                       % Get x and y for a unit-radius circle

if ~isaxisempty % If axis are specified (not empty)
    h=fill(x'*radiusmax*escala,y'*radiusmax*escala,figcolor);                            % create a background circle
    hAnnotation = get(h,'Annotation');                                     % get annotation from the circle
    hLegendEntry = get(hAnnotation','LegendInformation');                  % get legend information from the circle
    set(hLegendEntry,'IconDisplayStyle','off')                             % remove the cricle from the legened information.
    uistack(h,'bottom');                                                   % the circle must be placed below everything.
end

p1 = plot(axs,x'*radius(1:end-1)*escala+CenterLocation.X,y'*radius(1:end-1)*escala+CenterLocation.Y,CircularGridStyle,'color',CircularGridColor,'linewidth',CircularGridWidth);    % Draw dotted circle lines
plot(axs,x*radiusmax*escala+CenterLocation.X,y*radiusmax*escala+CenterLocation.Y,'-','color',CircularGridColor,'linewidth',CircularGridWidth);           % Redraw last circle line in solid style

axisangles = 0:360/Ngridradius:360; axisangles = axisangles(1:end-1);      % Angles in which to draw the radial axis (trigonometric reference)
R  = [min_radius;radiusmax];                                   % radius
p2 = plot(axs,R*cosd(axisangles)*escala+CenterLocation.X,R*sind(axisangles)*escala+CenterLocation.Y,RadialGridStyle,'color',RadialGridColor,'linewidth',RadialGridWidth);     % Draw radial axis, in the specified angles

if hg2_support
    for i=1:length(p1)
        p1(i).Color(4) = CircularGridAlpha;
    end
    for i=1:length(p2)
        p2(i).Color(4) = RadialGridAlpha;
    end
end

FrequecyLabels(circles,radius,FreqLabelAngle,TextColor,textfontname,escala,CenterLocation,min_radius);      % Display frequency labels
CardinalLabels(radiusmax,TextColor,label,lots_of_labels,textfontname,escala,CenterLocation);     % Display N, S, E, W

if ~CenterLocation.S
    xlim(axs,[-1 1]);                       % Set limits with the scale factor
    ylim(axs,[-1 1]);
end

%% Title and Legend
if ischar(TitleString)
    TitleString = {TitleString;' '};
elseif iscell(TitleString)
    TitleString = [TitleString; repmat({' '},1,size(TitleString,2))];
end
title(TitleString,'color',TextColor,'fontweight',titlefontweight,'fontname',titlefontname);         % Display a title
if isaxisempty; set(axs,'outerposition',[0 0 1 1]); end                    % Check that the current axis fills the figure, only if axis were not specified
if LegendType==2                                                           % If legend type is box:
    leyenda = CreateLegend(vwinds,lablegend,legendvariable,inverse);       % Create a legend cell string
    l       = legend(axs,leyenda,'location','northwest');                  % Display the legend wherever (position is corrected)
    if isaxisempty                                                         % If axis were not specified
        PrettyLegend(l,TextColor,legendfontname);                          % Display the legend in a good position
    else                                                                   % If axis were specified
        set(l,'textcolor',TextColor,'color',figcolor,'fontname',legendfontname); % change only the legend colour (text and background)
    end
elseif LegendType==1                                                       % If legend type is colorbar
    caxis(axs,[vwinds(1) vwinds(end)]);                                    % Set colorbar limits
    colormap(axs,interp1(vwinds,color,linspace(min(vwinds),max(vwinds),256))); % set colorbar colours (colormap)
    c = colorbar('YTick',vwinds,'fontname',legendfontname);                % The values shown in the colorbar are the intenisites.
    if isempty(lablegend); lablegend = ''; end                             % Ensure a string is available
    set(get(c,'label'),'string',lablegend);                                % Set the variable in the colorbar
end

%% Create Ruler
if ruler~=false
    if isequal(ruler,'left')
        K = -1;
    else
        K = 1;
    end
    circle_lab = [0 circles];
    circle_pos = [min_radius*escala radius*escala];
    hidelegend = @(h) set(get(get(h,'Annotation')','LegendInformation'),'IconDisplayStyle','off'); % function to hide a handle from the legend
    p          = plot(K*[min(circle_pos) max(circle_pos)],[0 0],'k');
    hidelegend(p);
    for i=1:length(circle_lab)
        p = plot(K*circle_pos(i)*[1 1],[0 0.05]*max(circle_pos),'-k');
        hidelegend(p);
        if i>1
            p = plot(K*mean(circle_pos(i-1:i))*[1 1],[0 0.025]*max(circle_pos),'-k');
            hidelegend(p); 
        end
        text(K*circle_pos(i),0.05*max(circle_pos),[num2str(circle_lab(i)) '%'],'horizontalalignment','center','verticalalignment','bottom');
    end
end
          
%% Outputs
[count,speeds,directions,Table] = CreateOutputs(count,vwinds,N,n,RefN,RefE); % Create output arrays and tables.


function count = PivotTableCount(N,n,vwinds,speed,dir,NumberElements)
    count  = zeros(length(N),length(vwinds));
    for i=1:length(N)
        d1 = mod(N(i)-n,360);                                              % Direction 1 is N-n
        d2 = N(i)+n;                                                       % Direction 2 is N+n
        if d1>d2                                                           % If direction 1 is greater than direction 2 of the bin (d1 = -5 = 355, d2 = 5)
            cond = or(dir>=d1,dir<d2);                                     % The condition is satisfied whenever d>=d1 or d<d2
        else                                                               % For the rest of the cases,
            cond = and(dir>=d1,dir<d2);                                    % Both conditions must be met for the same bin
        end
%         counter    = histc(speed(cond),vwinds);                          %# REMOVED 2015/Jun/22  % If vmax was for instance 25, counter will have counts for these intervals: [>=0 y <5] [>=5 y <10] [>=10 y <15] [>=15 y <20] [>=20 y <25] [>=25]
        counter    = histc(speed(cond),[vwinds(:)' inf]);                  %# ADDED 2015/Jun/22: Consider the wind speeds greater than max(vwinds), by adding inf into the histogram count
        counter    = counter(1:length(vwinds));                            %# ADDED 2015/Jun/22: Crop the resulting vector form histc, so as it has only length(Vwinds) elements
        if isempty(counter); counter = zeros(1,size(count,2)); end         % If counter is empty for any reason, set the counts to 0.
        count(i,:) = cumsum(counter);                                      % Computing cumsum will make count to have the counts for [<5] [<10] [<15] [<20] [<25] [>=25] (cumulative count, so we have the radius for each speed)
    end
    count = count/NumberElements*100;                                      % Frequency in percentage

function [color,axs] = DrawPatches(N,n,vwinds,count,colorfun,figcolor,min_radius,colors,inverse,axs,colormap_set,escala,CenterLocation)
    if isempty(colors)
        if ~colormap_set
            inv = strcmp(colorfun(1:3),'inv');                                     % INV = First three letters in cmap are inv
            if inv; colorfun = colorfun(4:end); end                                % if INV, cmap is the rest, excluding inv
            color = feval(colorfun,256);                                           % Create color map
            color = interp1(linspace(1,length(vwinds),256),color,1:length(vwinds));% Get the needed values.
            if inv; color = flipud(color); end                                     % if INV, flip upside down the colormap
        else
            color = interp1(1:size(colorfun,1), colorfun, linspace(1,size(colorfun,1),length(vwinds)), 'linear');
        end
    else
        color = colors;
    end
    if isempty(axs)
%         plot(0+CenterLocation.X,0+CenterLocation.Y,'.','color',figcolor,'markeredgecolor',figcolor,'markerfacecolor',figcolor); % This will create an empty legend entry.
        patch(([0 1 1 0]-0.5)/1000*escala+CenterLocation.X,([0 0 1 1]-0.5)/1000*escala+CenterLocation.Y,figcolor,'facealpha',0,'edgecolor','none');
        axs = gca;
    else
%         plot(axs,0+CenterLocation.X,0+CenterLocation.Y,'.','color',figcolor,'markeredgecolor',figcolor,'markerfacecolor',figcolor); % This will create an empty legend entry.
        patch(axs,([0 1 1 0]-0.5)/1000*escala+CenterLocation.X,([0 0 1 1]-0.5)/1000*escala+CenterLocation.Y,figcolor,'facealpha',0,'edgecolor','none');
    end
    set(gcf,'currentaxes',axs);
    hold on; %axis square; axis off;
    
    if inverse                                                             % If wind speeds are shown in inverse way (slowest is outside)
        count          = [count(:,1) diff(count,1,2)];                     % De-compose cumsum
        count          = cumsum(fliplr(count),2);                          % Cumsum inverting count.
    end
    
    for i=1:length(N)                                                      % For every angle
        for j=length(vwinds):-1:1                                          % For every wind speed range (last to first)
            if j>1                                                         % If the wind speed range is not the first
                r(1) = count(i,j-1);                                       % the lower radius of this bin is the upper radius of the one with lower speeds
            else                                                           % If the wind speed range is the first
                r(1) = 0;                                                  % the lower radius is 0
            end
            r(2)  = count(i,j);                                            % The upper radius is the cumulative count for this angle and this speed range
            r     = r+min_radius;                                          % We have to sum the minimum radius.
            
            alpha = linspace(-n,n,100)+N(i);                               % these are the angles for which the bins are plotted
            x1    = r(1) * sind(fliplr(alpha));                            % convert 1 radius and 100 angles into a line, x
            y1    = r(1) * cosd(fliplr(alpha));                            % and y
            x     = [x1 r(2)*sind(alpha)];                                 % Create circular sectors, completing x1 and y1 with the upper radius.
            y     = [y1 r(2)*cosd(alpha)];
            fill(x*escala+CenterLocation.X,y*escala+CenterLocation.Y,color(j,:),'edgecolor',hsv2rgb(rgb2hsv(color(j,:)).*[1 1 0.7])); % Draw them in the specified coloe. Edge is slightly darker.
        end
    end

function FrequecyLabels(circles,radius,angulo,TextColor,textfontname,escala,CenterLocation,rmin)
    s = sind(angulo); c = cosd(angulo);                                      % Get the positions in which labels must be placed
    if c>0; ha = 'left';   elseif c<0; ha = 'right'; else; ha = 'center'; end % Depending on the sign of the cosine, horizontal alignment should be one or another
    if s>0; va = 'bottom'; elseif s<0; va = 'top';   else; va = 'middle'; end % Depending on the sign of the sine  , vertical   alignment should be one or another
    for i=1:length(circles)
        text(radius(i)*c*escala+CenterLocation.X,radius(i)*s*escala+CenterLocation.Y,[num2str(circles(i)) '%'],'HorizontalAlignment',ha,'verticalalignment',va,'color',TextColor,'fontname',textfontname); % display the labels for each circle
    end
%     if length(radius)>1
%         rmin = radius(1)-abs(diff(radius(1:2)));
        if rmin>0
            if c>0; ha = 'right'; elseif c<0; ha = 'left';   else; ha = 'center'; end % Depending on the sign of the cosine, horizontal alignment should be one or another
            if s>0; va = 'top';   elseif s<0; va = 'bottom'; else; va = 'middle'; end % Depending on the sign of the sine  , vertical   alignment should be one or another
            text(rmin*c*escala+CenterLocation.X,rmin*s*escala+CenterLocation.Y,'0%','HorizontalAlignment',ha,'verticalalignment',va,'color',TextColor,'fontname',textfontname); % display the labels for each circle
        end
%     end
    
function CardinalLabels(circlemax,TextColor,labels,lots_of_labels,textfontname,escala,CenterLocation)
    if ~lots_of_labels && isstruct(labels)
        text( circlemax*escala+CenterLocation.X,0+CenterLocation.Y,[' ' labels.E],'HorizontalAlignment','left'  ,'verticalalignment','middle','color',TextColor,'fontname',textfontname); % East  label
        text(-circlemax*escala+CenterLocation.X,0+CenterLocation.Y,[labels.W ' '],'HorizontalAlignment','right' ,'verticalalignment','middle','color',TextColor,'fontname',textfontname); % West  label
        text(0+CenterLocation.X, circlemax*escala+CenterLocation.Y,labels.N      ,'HorizontalAlignment','center','verticalalignment','bottom','color',TextColor,'fontname',textfontname); % North label
        text(0+CenterLocation.X,-circlemax*escala+CenterLocation.Y,labels.S      ,'HorizontalAlignment','center','verticalalignment','top'   ,'color',TextColor,'fontname',textfontname); % South label
    else % If lots of labels
        angles = linspace(0,2*pi,length(labels)+1); % Divide the circle in n+1 parts
        angles = angles(1:end-1); % Select only n parts (n+1 is the same as 1)
        for i=1:length(angles)
            minval = 1e-5;
            x = sin(angles(i));
            y = cos(angles(i));
            if x>minval % If x is to the right, text must be aligned to the left.
                ha    = 'left';
                label = [' ' labels{i}];
            elseif x<-minval % If x is to the left, text must be aligned to the right.
                ha    = 'right';
                label = [labels{i} ' '];
            else % if x is 0, text must be 
                ha    = 'center';
                label = labels{i};
            end
            
            if y>minval
                va = 'bottom';
            elseif y<-minval
                va = 'top';
            else
                va = 'middle';
            end
            
            text(abs(circlemax)*x*escala+CenterLocation.X,abs(circlemax)*y*escala+CenterLocation.Y,label,'horizontalalignment',ha,'verticalalignment',va,'color',TextColor,'fontname',textfontname);
        end
    end
    
function leyenda = CreateLegend(vwinds,lablegend,legendvariable,inverse)
    leyenda = cell(length(vwinds),1);                                      % Initialize legend cell array
    cont    = 0;                                                           % Initialize Counter
    if inverse                                                             % If wind speed order must bu shown in inverse order
        orden = length(vwinds):-1:1;                                       % Set order backwards
    else                                                                   % Else
        orden = 1:length(vwinds);                                          % Set normal order (cont will be equal to j).
    end
    
    for j=orden                                                            % Cross the speeds in the specified direction
        cont = cont+1;                                                     % Increase counter
        if j==length(vwinds)                                               % When last index is reached
            string = sprintf('%s %s %g',legendvariable,'\geq',vwinds(j));  % Display wind <= max wind
        else                                                               % For the rest of the indices
            string = sprintf('%g %s %s < %g',vwinds(j),'\leq',legendvariable,vwinds(j+1)); % Set v1 <= v2 < v1
        end
        string = regexprep(string,'0 \leq','0 <');                         % Replace "0 <=" by "0 <", because wind speed = 0 is not displayed in the graph.
        leyenda{length(vwinds)-cont+1} = string;
    end
    if isempty(lablegend); lablegend = ' '; end                            % Ensure that lablegend is not empty, so windspeeds appear in the right position.
    leyenda = [lablegend; leyenda];                                        % Add the title for the legend
    
function PrettyLegend(l,TextColor,legendfontname)
    set(l,'units','normalized','box','off');                               % Do not display the box
    POS = get(l,'position');                                               % get legend position (width and height)
    set(l,'position',[0 1-POS(4) POS(3) POS(4)],'textcolor',TextColor,'fontname',legendfontname);    % Put the legend in the upper left corner
    uistack(l,'bottom');                                                   % Put the legend below the axis
    
function [count,speeds,directions,Table] = CreateOutputs(count,vwinds,N,n,RefN,RefE)
    count          = [count(:,1) diff(count,1,2)];                         % Count had the accumulated frequencies. With this line, we get the frequency for each single direction and each single speed with no accumulation.
    speeds         = vwinds;                                               % Speeds are the same as the ones used in the Wind Rose Graph
    directions     = mod(RefN - N'/90*(RefN-RefE),360);                    % Directions are the directions in which the sector is centered. Convert function reference to user reference
    vwinds(end+1)  = inf;                                                  % Last wind direction is inf (for creating intervals)
    
    [directions,i] = sort(directions);                                     % Sort directions in ascending order
    count          = count(i,:);                                           % Sort count in the same way.
    
    wspeeds        = cell(1,length(vwinds)-1);
    for i=1:(length(vwinds)-1)
        if vwinds(i) == 0; s1 = '('; else; s1 = '['; end                     % If vwinds(i) =0 interval is open, because count didn't compute windspeed = 0. Otherwise, the interval is closed [
        wspeeds{i} = [s1 num2str(vwinds(i)) ' , ' num2str(vwinds(i+1)) ')'];% Create wind speed intervals, open in the right.
    end
    
    wdirs = cell(length(directions),1);
    for i=1:length(directions)
        wdirs{i} = sprintf('[%g , %g)',mod(directions(i)-n,360),directions(i)+n); % Create wind direction intervals [a,b)
    end
    
    WindZeroFreqency = 100-sum(sum(count));                                % Wind speed = 0 appears 100-sum(total) % of the time. It does not have direction.
    WindZeroFreqency = WindZeroFreqency*(WindZeroFreqency/100>eps);        % If frequency/100% is lower than eps, do not show that value.

    Table            = [{'Frequencies (%)'},{''},{'Wind Speed Interval'},repmat({''},1,numel(wspeeds));'Direction Interval (°)','Avg. Direction',wspeeds,'TOTAL';[wdirs num2cell(directions) num2cell(count) num2cell(sum(count,2))]]; % Create table cell. Ready to xlswrite.
    Table(end+1,:)   = [{'[0 , 360)','TOTAL'},num2cell(sum(count,1)),{sum(sum(count))}]; % the last row is the total
    Table(end+1,1:2) = {'No Direction', 'Wind Speed = 0'};                 % add an additional row showing Wind Speed = 0 on table.
    Table{end,end}   = WindZeroFreqency;                                   % at the end of the table (last row, last column), show the total number of elements with 0 speed.