function [] = oneRound(app)

    app.currRound = app.currRound+1; %increment round
    app.dispRound = app.currRound; %look at most recent round
    app.MaxRounds.Value = app.currRound; %maximum round reached
    
    if(app.currRound == 1) % first round
        app.DispSlider.Limits = [1 1.1];
        app.DispSpinner.Limits = [1 1.1];
        app.DispSlider.Value = 1;
        app.DispSpinner.Value = 1;
    else
        app.DispSlider.Limits = [1 app.currRound];
        app.DispSpinner.Limits = [1 app.currRound];
        app.DispSlider.Value = app.dispRound;
        app.DispSpinner.Value = app.dispRound;
    end
    
    [~, deadlist, livelist] = killEm(app.players, app.currRound); 
        %for dead and livelists
    numsPicked = []; %zero out picked duelers
    fights = 0; %reset counter
    while fights < .8*((size(app.players,2)-size(deadlist,2))/2) 
                            %set number of duel s
        per1Ind = randi(size(livelist),1); %pick a player
        per1 = livelist(per1Ind); %assign them the actual number
        if(any(find(numsPicked == per1))) %already picked
            continue;
        end
        numsPickedMini = [numsPicked, per1]; %include per1 now
        per2Ind = randi(size(livelist),1); %pick a player
        per2 = livelist(per2Ind); %assign real number
        if(any(find(numsPickedMini == per2))) %already picked
            continue;
        end
        numsPicked = [numsPickedMini, per2]; %now include both pers
        app.players = duel(app.players,per1,per2,app.currRound, ...
            app.duelPara); %FIGHT
        fights = fights +1;
        
    end
    [app.players, ~, ~] = killEm(app.players,app.currRound); %elim deads
    app.players = lvlUp(app.players, app.currRound, app.lvlUpPara); %do level ups
    app.players = makeBabes(app.players, app.currRound, ...
        app.makeBabesPara, app.makePlayerPara); %add players
    
    app.bigData = recordTrends(app.players, app.currRound, livelist,...
        app.bigData); %record info
    
    %Graph each round's state
    graphBBScatter(app);
    graphTrends(app); 
    drawnow(); %redraw figure
%     pause(.001); %hopefully graph it?
    app.TrendyPicButton.Enable = 'on'; %new data that can be graphed
    app.BBVidButton.Enable = 'on'; %new data to record
end