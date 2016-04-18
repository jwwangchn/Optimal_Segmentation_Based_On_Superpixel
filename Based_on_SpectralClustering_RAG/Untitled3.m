theta = linspace(0,2*pi,100);
x1 = sin(theta);
y1 = cos(theta);

hold on

% figure
h1=scatter(x1,y1,'b','d')

x2 = 2*sin(theta);
y2 = 2*cos(theta);

h2=scatter(x2,y2,'g','x')

x3 = 3*sin(theta);
y3 = 3*cos(theta);

h3=scatter(x3,y3,'r','o')

% hold off
axis equal
legend([h1,h2,h3],'radius = 1','radius = 2','hhh')