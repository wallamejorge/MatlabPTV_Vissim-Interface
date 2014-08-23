%% --------------------------------------------------------------------- %%
%  Interface Matlab -> PTV VISSIM 6.0      
%  Autor: Jorge Luis Mayorga Taborda
%  Fecha: 23/08/2014
%
%  Comentarios: Interfaz para control y simulación de una red de trafico
%  utilizando el software de simulación PTV VISSIM 6.00 en adelante.
%
% ----------------------------------------------------------------------- % 
%% --------------------------------------------------------------------- %%
% Mod 0:Limpiar Variables y preprar Matlab para comenzar   
    clc;
    clear all;
    format compact;
% ----------------------------------------------------------------------- % 
%% --------------------------------------------------------------------- %%
% Mod 1:Ejecutar terminal Xserver   
    vissim_com=actxserver('VISSIM.vissim.600');
% ----------------------------------------------------------------------- %
%% --------------------------------------------------------------------- %%
% Mod 2:Generar rutas de los archivos   
    MainDirPath=pwd;
    
    VissimFilesPath='\Vissim\';
    BackgroundPath='\Background\';
    ResultsPath='\SimulationResults';
    
    NetName='PTV_VISSIM_Net';
    LayoutName='PTV_VISSIM_Layout';
    BackgroundName='BACKGROUND_Image';
    
    NetFormat='.inpx';
    LayoutFormat='.layx';
    BackgroundFormat='.png';
    
    PathNet=...
        [MainDirPath  VissimFilesPath NetName NetFormat];
    PathLayout=...
        [MainDirPath  VissimFilesPath LayoutName LayoutFormat];
    PathBackground=...
        [MainDirPath BackgroundPath BackgroundName BackgroundFormat];
% ----------------------------------------------------------------------- %
%% --------------------------------------------------------------------- %%
% Mod 3:Cargar los archivos
    vissim_com.LoadNet(PathNet);
    vissim_com.LoadLayout(PathLayout);
% ----------------------------------------------------------------------- %
%% --------------------------------------------------------------------- %%
% Mod 4: Inicializar Simulación
    sim=vissim_com.Simulation;
% ----------------------------------------------------------------------- %
%% --------------------------------------------------------------------- %%
% Mod 5: Cargar Red de Trafico
    vnet=vissim_com.Net;
% ----------------------------------------------------------------------- %
%% --------------------------------------------------------------------- %%
% Mod 6: Definir Links,SignalControllers,etc
    NetLinks=vnet.links;
% ----------------------------------------------------------------------- %
%% --------------------------------------------------------------------- %%
% Mod 7: Simulación
    for i=1:100
        sim.RunSingleStep; 
        
        PathBackground=...
        [MainDirPath BackgroundPath BackgroundName num2str(i) BackgroundFormat];
        vissim_com.Graphics.CurrentNetworkWindow.Screenshot(PathBackground);
        
        NetLinks.ItemByKey(1).Vehs.GetMultipleAttributes('No');
        
        
    end
% ----------------------------------------------------------------------- %
%%
%sim.set('BreakAt',10 )
%sim.RunContinuous;
for i=0:1800
  sim.RunSingleStep;
  pause(.05) %This is a MATLAB command which breaks the continuous run with 0.2 sec
  if rem(i,10)==0 
      density=link_1.GetSegmentResult('Density', 0, 0.0,1,0) 
      %The Evaluation property of the link must be flagged in VISSIM!
      %link_2.GetSegmentResult('Speed', 0, 0.0,1,0);
      if density>40
          sg_1.set('State',3); %Green=3
          sg_2.set('State',1); 
      else
          sg_1.set('State',1); %Red=1
          sg_2.set('State',3);
      end
       disp(['Simulation Time: ' num2str(i)]);
  end
end

%Break Matlab run: Ctrl+C

