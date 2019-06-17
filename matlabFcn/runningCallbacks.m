function [] = runningCallbacks(app, event)
%runningCallbacks Callback functions for running the simulation

switch event.Source
    %Top bar running things
    
        %Display Round
    case app.DispSlider
%         if(strcmp(event.EventName, 'ValueChanging')) %moving slider
%             disp('Value changing');
%             if(strcmp(app.sliderTimer.running, 'off'))
%                 start(app.sliderTimer); %begin timing updates
%             end %if running
%         elseif(strcmp(event.EventName, 'ValueChanged'))
%             disp('Value changed');
%             if(strcmp(app.sliderTimer.running, 'on'))
%                 stop(app.sliderTimer);
%             end
%             app.dispRound = round(app.DispSlider.Value); %round display
%             app.DispSpinner.Value = app.dispRound; %display
%             app.DispSlider.Value = app.dispRound; %discretize?
%             graphBBScatter(app); %regraph
%         end
        app.dispRound = round(app.DispSlider.Value); %round display
        app.DispSlider.Value = app.dispRound; %discretize?
        graphBBScatter(app); %regraph
        drawnow();
        disp('updated!')
        if(strcmp(event.EventName, 'ValueChanged'))
            app.DispSpinner.Value = app.dispRound; %display
        end
    case app.DispSpinner
        app.dispRound= round(app.DispSpinner.Value);% round
        app.DispSlider.Value = app.dispRound;
        pause(0.1); %stability?
        graphBBScatter(app); %regraph
    %Run Rounds
    case app.Run1RoundButton
        oneRound(app); %run a single round
    case app.RunRoundsButton %continuously run rounds
        while app.RunRoundsButton.Value %continuously
            oneRound(app); %THIS SCARES ME
            pause(0.001); %stablizer
        end
    case app.RunXRoundsButton
        if(strcmp(app.RunXSpinner.Enable, 'on')) %not running rn
            app.RunXSpinner.Enable = 'off'; %disable it
            oldVal = app.RunXSpinner.Value;
            app.RunXSpinner.BackgroundColor = 'yellow'; %color for counting
            for indR = oldVal:-1:1 %increment down
                app.RunXSpinner.Value = indR; %count down
                oneRound(app);
                if(strcmp(app.RunXSpinner.UpperLimitInclusive, 'off'))
                    %we are cancelling the run
                    app.RunXSpinner.UpperLimitInclusive = 'on'; %reset
                    break;
                end %cancel
            end
            app.RunXSpinner.Enable = 'on';
            app.RunXSpinner.Value = oldVal;
            app.RunXSpinner.BackgroundColor = 'white';
        else %running rounds
            app.RunXSpinner.UpperLimitInclusive = 'off';
                %we'll use this as an indicator to cancel
        end %if running

    %Save Request things
    case app.ManSaveButton %manually save data
        direc = [app.genPara.savePath,'/',app.genPara.simTitle '/']; 
        players = app.players; %players struct
        bigData = app.bigData; %historical Data
        save([direc 'playersAndData.mat'], 'players','bigData');
        
    case app.TrendyPicButton
        saveTrends(app); %save picture!
    case app.BBVidButton
        saveBBScatter(app); %save video
        
    %change settings for export, can techincally regraph
    case app.VidFrameRate
        app.BBVidButton.Enable = 'on'; 
    case app.VidIntroLength
        app.BBVidButton.Enable = 'on';
    case app.VidName
        app.BBVidButton.Enable = 'on';
    case app.PicName
        app.TrendyPicButton.Enable = 'on';
        
        
    % Close Request Function, hope this is right...
    case app.AWSim % Parent, oooh boy...
        if(strcmp(app.SettingsTabs.Visible, 'off')) %run mode
            direc = [app.genPara.savePath,'/',app.genPara.simTitle '/']; 
            players = app.players; %players struct
            bigData = app.bigData; %historical Data
            save([direc 'playersAndData.mat'], 'players','bigData');
        end %if running
        delete(app); %destroy it
end
end

