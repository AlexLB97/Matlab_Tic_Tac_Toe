%Author: Alex Bourdage
%Date: 11/9/2020
%Lab 5
%Implementation of tic tac toe

function Lab05_TTT

%initialize all variables


% record = [player1wins player2wins ties]
record = [0 0 0];

gameBoard = zeros(3,3);

numMoves = 0;

typeChose = false;
cpu1Chose = false;
cpu2Chose = false;
firstChose = false;

gameType = [];
currentPlayer = [];
originalCurrentPlayer = [];
cpuOneLevel = [];
cpuTwoLevel = [];

figure1 = figure;
figure1.Units = 'normalized';
figure1.Position = [20 20 40 40 ]/100;


x = 5;
y = 62.5;
width = 17;
height = 25;
ypos = y;
xpos = x;
count = 1;
user = 'O';
cpu = 'X';
position = 1;
cpuOneLevel = 'Hard';
cpuTwoLevel = 'Easy';

%create all buttons and labels for start game menu

quitButton = uicontrol('Style', 'pushbutton');
quitButton.Units = 'normalized';
quitButton.FontUnits = 'normalized';
quitButton.BackgroundColor = [1 0 0];
quitButton.Position = [5 2 15 7]/100;
quitButton.String = 'Quit';
quitButton.Callback = 'close;';

playAgain = uicontrol('Style', 'pushbutton');
playAgain.Units = 'normalized';
playAgain.FontUnits = 'normalized';
playAgain.BackgroundColor = [0 1 0];
playAgain.Position = [80 2 15 7]/100;
playAgain.String = 'Play Again';
playAgain.Enable = 'off';
playAgain.Visible = 'off';
playAgain.Callback = @resetBoard;

startGameButton = uicontrol('Style', 'pushbutton', 'Units', 'normalized', 'FontUnits', 'normalized','Position', [80 5 15 5]/100, 'Enable', 'off', 'BackgroundColor' , [0 1 0], 'FontSize', 0.7,'Callback', @startGame, 'String', 'Start Game');


typeLabel = uicontrol('Style', 'text', 'Units', 'normalized', 'FontUnits', 'normalized','Position', [5 65 15 5]/100, 'FontSize', 0.6, 'String', 'Select Game Type:');
pvpButton = uicontrol('Style', 'pushbutton', 'Units', 'normalized', 'FontUnits', 'normalized','Position', [5 55 20 5]/100, 'FontSize', 0.7,'Callback', {@setType,'PVP'}, 'String', 'Player vs. Player');
cvpButton = uicontrol('Style', 'pushbutton', 'Units', 'normalized', 'FontUnits', 'normalized','Position', [5 45 20 5]/100, 'FontSize', 0.7,'Callback', {@setType,'CVP'}, 'String', 'CPU vs. Player');
cvcButton = uicontrol('Style', 'pushbutton', 'Units', 'normalized', 'FontUnits', 'normalized','Position', [5 35 20 5]/100, 'FontSize', 0.7,'Callback', {@setType,'CVC'}, 'String', 'CPU vs. CPU');

cpuOneLevelLabel = uicontrol('Style', 'text', 'Units', 'normalized', 'FontUnits', 'normalized','Position', [30 65 15 5]/100, 'FontSize', 0.6, 'Visible', 'on','String', 'Select Level:');
cpuOneEasyButton = uicontrol('Style', 'pushbutton', 'Units', 'normalized', 'FontUnits', 'normalized','Position', [30 55 15 5]/100, 'FontSize', 0.7,'Callback', {@setCPUOneLevel,'Easy'}, 'Visible', 'on','String', 'Easy');
cpuOneMediumButton = uicontrol('Style', 'pushbutton', 'Units', 'normalized', 'FontUnits', 'normalized','Position', [30 45 15 5]/100, 'FontSize', 0.7,'Callback', {@setCPUOneLevel,'Medium'}, 'Visible', 'on','String', 'Medium');
cpuOneHardButton = uicontrol('Style', 'pushbutton', 'Units', 'normalized', 'FontUnits', 'normalized','Position', [30 35 15 5]/100, 'FontSize', 0.7,'Callback', {@setCPUOneLevel,'Hard'}, 'Visible', 'on','String', 'Hard');

cpuTwoLevelLabel = uicontrol('Style', 'text', 'Units', 'normalized', 'FontUnits', 'normalized','Position', [55 65 15 5]/100, 'FontSize', 0.6, 'Visible', 'off','String', 'Select CPU Two Level:');
cpuTwoEasyButton = uicontrol('Style', 'pushbutton', 'Units', 'normalized', 'FontUnits', 'normalized','Position', [55 55 15 5]/100, 'FontSize', 0.7,'Callback', {@setCPUTwoLevel,'Easy'}, 'Visible', 'off','String', 'Easy');
cpuTwoMediumButton = uicontrol('Style', 'pushbutton', 'Units', 'normalized', 'FontUnits', 'normalized','Position', [55 45 15 5]/100, 'FontSize', 0.7,'Callback', {@setCPUTwoLevel,'Medium'}, 'Visible', 'off','String', 'Medium');
cpuTwoHardButton = uicontrol('Style', 'pushbutton', 'Units', 'normalized', 'FontUnits', 'normalized','Position', [55 35 15 5]/100, 'FontSize', 0.7,'Callback', {@setCPUTwoLevel,'Hard'}, 'Visible', 'off','String', 'Hard');

playsFirstLabel = uicontrol('Style', 'text', 'Units', 'normalized', 'FontUnits', 'normalized','Position', [55 65 15 5]/100, 'FontSize', 0.6, 'Visible', 'on','String', 'Who plays first?'); 
playerOneButton = uicontrol('Style', 'pushbutton', 'Units', 'normalized', 'FontUnits', 'normalized','Position', [55 55 15 5]/100, 'FontSize', 0.7,'Callback', {@setFirstPlayer,'CPU'}, 'Visible', 'on','String', 'CPU');
playerTwoButton = uicontrol('Style', 'pushbutton', 'Units', 'normalized', 'FontUnits', 'normalized','Position', [55 45 15 5]/100, 'FontSize', 0.7,'Callback', {@setFirstPlayer,'User'}, 'Visible', 'on','String', 'User');



%create game board and scoreboard, set to invisible to start with

for k = 1:9
    buttonName = strcat( 'button', num2str(k));
    variable.(buttonName) = uicontrol('Style', 'pushbutton', 'Units','normalized', 'Position', [xpos ypos width height]/100, 'String', '', 'FontUnits', 'normalized', 'FontSize', 0.8, 'Enable', 'on','Visible', 'off','Callback', {@selectPosition, 'User'});
    if (count == 3)
        ypos = y;
        xpos = xpos + width;
        count = 1;
    else
        ypos = ypos - height;
        count = count + 1;
    end
end

scoreboardLabel = uicontrol('Style', 'text', 'Units', 'normalized', 'FontUnits', 'normalized','Position', [70 90 15 5]/100, 'FontSize', 0.8, 'Visible', 'off','String', 'Scoreboard');
playerOneLabel = uicontrol('Style', 'text', 'Units', 'normalized', 'FontUnits', 'normalized','Position', [65 80 15 5]/100, 'FontSize', 0.8, 'Visible', 'off','String', 'Player 1:'); 
playerTwoLabel = uicontrol('Style', 'text', 'Units', 'normalized', 'FontUnits', 'normalized','Position', [65 70 15 5]/100, 'FontSize', 0.8, 'Visible', 'off','String', 'Player 2:'); 
tieLabel = uicontrol('Style', 'text', 'Units', 'normalized', 'FontUnits', 'normalized','Position', [65 60 15 5]/100, 'FontSize', 0.8, 'Visible', 'off','String', 'Ties:'); 
playerOneWins = uicontrol('Style', 'text', 'Units', 'normalized', 'FontUnits', 'normalized','Position', [80 80 15 5]/100, 'FontSize', 0.8, 'Visible', 'off','String', '0'); 
playerTwoWins = uicontrol('Style', 'text', 'Units', 'normalized', 'FontUnits', 'normalized','Position', [80 70 15 5]/100, 'FontSize', 0.8, 'Visible', 'off','String', '0'); 
ties = uicontrol('Style', 'text', 'Units', 'normalized', 'FontUnits', 'normalized','Position', [80 60 15 5]/100, 'FontSize', 0.8, 'Visible', 'off','String', '0'); 


 %initialize game. set all menu buttons to invisible and make gameboard and
 %scoreboard visible. Start game by invoking cpuMove if a CPU player plays
 %first.
 
    function startGame(~, ~)
        for j = 1:9
            button = eval(sprintf('variable.button%d', j));
            button.Visible = 'on';
        end
        set(startGameButton, 'Visible', 'off');
        set(playAgain, 'Visible', 'on');
        set(pvpButton, 'Visible', 'off');
        set(cvpButton, 'Visible', 'off');
        set(cvcButton, 'Visible', 'off');
        set(typeLabel, 'Visible', 'off');
        set(cpuTwoLevelLabel, 'Visible', 'off');
        set(cpuTwoEasyButton, 'Visible', 'off');
        set(cpuTwoMediumButton, 'Visible', 'off');
        set(cpuTwoHardButton, 'Visible', 'off');
        set(cpuOneLevelLabel, 'Visible', 'off');
        set(cpuOneEasyButton, 'Visible', 'off');
        set(cpuOneMediumButton, 'Visible', 'off');
        set(cpuOneHardButton, 'Visible', 'off');
        set(playsFirstLabel, 'Visible', 'off');        
        set(playerOneButton, 'Visible', 'off');
        set(playerTwoButton, 'Visible', 'off');
        set(scoreboardLabel, 'Visible', 'on');
        set(playerOneLabel, 'Visible', 'on');
        set(playerTwoLabel, 'Visible', 'on');
        set(tieLabel, 'Visible', 'on');
        set(playerOneWins, 'Visible', 'on');
        set(playerTwoWins, 'Visible', 'on');
        set(ties, 'Visible', 'on');
        
        if(strcmp(gameType, 'CVC'))
            set(playerOneLabel, 'String', 'CPU1:');
            set(playerTwoLabel, 'String', 'CPU2:');
            if (strcmp(currentPlayer, 'User'))
                cpuMove(2, cpuTwoLevel);
            else
                cpuMove(1, cpuOneLevel);
            end
        elseif (strcmp(gameType, 'CVP'))
            set(playerOneLabel, 'String', 'CPU:');
            set(playerTwoLabel, 'String', 'Player:');
            if (strcmp(currentPlayer, 'CPU'))
                cpuMove(1, cpuOneLevel);
            end
        end
    end

%functions to set initial parameters
    function setCPUOneLevel(src,~, level)
        cpu1Chose = true;
        cpuOneLevel = level;
        set(cpuOneEasyButton, 'BackgroundColor', [1 1 1]);
        set(cpuOneMediumButton, 'BackgroundColor', [1 1 1]);
        set(cpuOneHardButton, 'BackgroundColor', [1 1 1]);
        set(src, 'BackgroundColor', [0 0 1]);
        checkParamsSet();
        
    end

    function setCPUTwoLevel(src,~, level)
        set(cpuTwoEasyButton, 'BackgroundColor', [1 1 1]);
        set(cpuTwoMediumButton, 'BackgroundColor', [1 1 1]);
        set(cpuTwoHardButton, 'BackgroundColor', [1 1 1]);
        set(src, 'BackgroundColor', [0 0 1]);
        cpu2Chose = true;
        cpuTwoLevel = level;
        checkParamsSet();
    end

    function setFirstPlayer(src,~, firstPlayer)
        firstChose = true;
        currentPlayer = firstPlayer;
        set(playerOneButton, 'BackgroundColor', [1 1 1]);
        set(playerTwoButton, 'BackgroundColor', [1 1 1]);
        set(src, 'BackgroundColor', [0 0 1]);
        originalCurrentPlayer = firstPlayer;
        checkParamsSet();
    end

    function setType(src,~, type)
        typeChose = true;
        gameType = type;
        set(cvcButton, 'BackgroundColor', [1 1 1]);
        set(cvpButton, 'BackgroundColor', [1 1 1]);
        set(pvpButton, 'BackgroundColor', [1 1 1]);
        set(src, 'BackgroundColor', [0 0 1]);
        if (strcmp(type, 'CVC'))
            checkParamsSet();
            set(cpuTwoLevelLabel, 'Visible', 'on')
            set(cpuTwoEasyButton, 'Visible', 'on')
            set(cpuTwoMediumButton, 'Visible', 'on')
            set(cpuTwoHardButton, 'Visible', 'on')      
            set(cpuOneLevelLabel, 'Visible', 'on')
            set(cpuOneLevelLabel, 'String', 'Select CPU One Level:');
            set(cpuOneEasyButton, 'Visible', 'on')
            set(cpuOneMediumButton, 'Visible', 'on')
            set(cpuOneHardButton, 'Visible', 'on') 
            set(playsFirstLabel, 'Position', [80 65 15 5]/100);
            set(playerOneButton, 'Position', [80 55 15 5]/100);
            set(playerTwoButton, 'Position', [80 45 15 5]/100);
            set(playerTwoButton, 'String', 'CPU2');
            set(playsFirstLabel, 'Visible', 'on');        
            set(playerOneButton, 'Visible', 'on');
            set(playerTwoButton, 'Visible', 'on');
        elseif (strcmp(type, 'CVP'))
            checkParamsSet()
            set(cpuTwoLevelLabel, 'Visible', 'off')
            set(cpuTwoEasyButton, 'Visible', 'off')
            set(cpuTwoMediumButton, 'Visible', 'off')
            set(cpuTwoHardButton, 'Visible', 'off')
            set(cpuOneLevelLabel, 'String', 'Select Level:');
            set(cpuOneLevelLabel, 'Visible', 'on')
            set(cpuOneEasyButton, 'Visible', 'on')
            set(cpuOneMediumButton, 'Visible', 'on')
            set(cpuOneHardButton, 'Visible', 'on') 
            set(playsFirstLabel, 'Position', [55 65 15 5]/100);
            set(playerOneButton, 'Position', [55 55 15 5]/100);
            set(playerTwoButton, 'String', 'User');
            set(playerTwoButton, 'Position', [55 45 15 5]/100); 
            set(playsFirstLabel, 'Visible', 'on');        
            set(playerOneButton, 'Visible', 'on');
            set(playerTwoButton, 'Visible', 'on');

        else
            currentPlayer = 'CPU';
            originalCurrentPlayer = 'CPU';
            set(cpuTwoLevelLabel, 'Visible', 'off')
            set(cpuTwoEasyButton, 'Visible', 'off')
            set(cpuTwoMediumButton, 'Visible', 'off')
            set(cpuTwoHardButton, 'Visible', 'off')      
            set(cpuOneLevelLabel, 'Visible', 'off')
            set(cpuOneEasyButton, 'Visible', 'off')
            set(cpuOneMediumButton, 'Visible', 'off')
            set(cpuOneHardButton, 'Visible', 'off')
            set(playsFirstLabel, 'Visible', 'off');        
            set(playerOneButton, 'Visible', 'off');
            set(playerTwoButton, 'Visible', 'off');
            
        end
        checkParamsSet()
    end


%function to ensure that all parameters are set before allowing user to
%start the game.

    function checkParamsSet()
        if (strcmp(gameType, 'CVC') && cpu1Chose && cpu2Chose && typeChose && firstChose)
            set(startGameButton, 'Enable', 'on');
        elseif (strcmp(gameType, 'CVP') && cpu1Chose && typeChose && firstChose && (~cpu2Chose || cpu2Chose ))
            set(startGameButton, 'Enable', 'on'); 
        elseif (strcmp(gameType, 'PVP') && typeChose)
            set(startGameButton, 'Enable', 'on');
        else
           set(startGameButton, 'Enable', 'off');  
        end
    end

%function that drives the CPU actions based on the CPU's level and which
%CPU is playing

    function cpuMove(player, playerLevel)
        pause(0.5)
        if (player == 1)
            pVal = 1;
            oVal = 4;
            current = 'cpu';
            otherPlayer = 'user';
            whoClicked = 'CPU';
        else
            pVal = 4;
            oVal = 1;
            current = 'user';
            otherPlayer = 'cpu';
            whoClicked = 'User';
        end
        if (strcmp(playerLevel, 'Hard'))
            if (numMoves == 0)
                selectPosition(eval(sprintf('variable.button%d', 1)), '', whoClicked);
                
            else
                
                bestScore = -inf;
                for i = 1:9
                    if (gameBoard(i) == 0)
                        gameBoard(i) = pVal;
                        score = minimax(false, player);
                        gameBoard(i) = 0;
                        if (score > bestScore)
                            bestScore = score;
                            position = i;
                        end
                    end
                end
                selectPosition(eval(sprintf('variable.button%d', position)), '', whoClicked)
            end
        elseif (strcmp(playerLevel, 'Medium'))
            for i = 1:9
                if (gameBoard(i) == 0)
                    gameBoard(i) = pVal;
                    result = checkWin(false);
                    gameBoard(i) = 0;
                    if(strcmp(result, current))
                        button = eval(sprintf('variable.button%d', i));
                        selectPosition(button, '', whoClicked);
                        return
                    end
                end
            end
            for i = 1:9
                if(gameBoard(i) == 0)
                    gameBoard(i) = oVal;
                    result = checkWin(false);
                    gameBoard(i) = 0;
                    if(strcmp(result, otherPlayer))
                        button = eval(sprintf('variable.button%d', i));
                        selectPosition(button, '', whoClicked);
                        return
                    end
                end
            end
            possibleMoves = find(gameBoard == 0);
            choice = randi(length(possibleMoves));
            pos = possibleMoves(choice);
            button = eval(sprintf('variable.button%d', pos));
            selectPosition(button, '', whoClicked);
        else
            possibleMoves = find(gameBoard == 0);
            choice = randi(length(possibleMoves));
            pos = possibleMoves(choice);
            button = eval(sprintf('variable.button%d', pos));
            selectPosition(button, '', whoClicked);
        end
        
    end


%minimax algorithm for hard mode. Generates all possible moves and chooses
%the one with the best chance of winning.

    function [score] = minimax(maximizing, player)
        result = checkWin(false);
        if (player == 1)
            pVal = 1;
            oVal = 4;
            if (~strcmp(result, 'continue'))
                if (strcmp(result, 'cpu'))
                    score = 10;
                    return
                elseif (strcmp(result, 'user'))
                    score = -10;
                    return
                else
                    score = 0;
                    return
                end
            end
        else
            pVal = 4;
            oVal = 1;
            if (~strcmp(result, 'continue'))
                if (strcmp(result, 'user'))
                    score = 10;
                    return
                elseif (strcmp(result, 'cpu'))
                    score = -10;
                    return
                else
                    score = 0;
                    return
                end
            end
        end
        
        if(maximizing)
            bestScore = -inf;
            for i = 1:9
                if (gameBoard(i) == 0)
                    gameBoard(i) = pVal;
                    score = minimax(false, player);
                    gameBoard(i) = 0;
                    if (score > bestScore)
                        bestScore = score;
                    end
                end
            end
            score = bestScore;
            return
        else
            bestScore = inf;
            for i = 1:9
                if (gameBoard(i) == 0)
                    gameBoard(i) = oVal;
                    score = minimax(true, player);
                    gameBoard(i) = 0;
                    if (score < bestScore)
                        bestScore = score;
                    end
                end
            end
            score = bestScore;
            return
        end
    end


%checks to see if there is a winner. used with "false" argument when
%minimax and simulating possible games. Used with "true" argument when a
%button is actually pressed.

    function [winner] = checkWin(realMove)
        pointsKey = {[1 4 7] [2 5 8] [3 6 9] [1 2 3] [4 5 6] [7 8 9] [1 5 9] [7 5 3]};
        points = zeros(1,8);
        index = 1;
        for i = 1:3
            points(index) = sum(gameBoard(i, :));
            points(index + 3) = sum(gameBoard(:, i));
            index = index + 1;
        end
        points(7) = sum(diag(gameBoard));
        points(8) = sum(diag(flip(gameBoard)));
        
        
        for i = 1:8
            if(points(i) == 3)
                winner = 'cpu';
                if (realMove)
                    record(1) = record(1) + 1;
                    set(playerOneWins, 'String', num2str(record(1)));
                    for j = pointsKey{i}
                        button = eval(sprintf('variable.button%d', j));
                        button.BackgroundColor = [1 0 0];
                        playAgain.Enable = 'on';
                    end
                end
                return
            elseif (points(i) == 12)
                winner = 'user';
                if(realMove)
                    record(2) = record(2) + 1;
                    set(playerTwoWins, 'String', num2str(record(2)));
                    for j = pointsKey{i}
                        button = eval(sprintf('variable.button%d', j));
                        button.BackgroundColor = [0 1 0];
                        playAgain.Enable = 'on';
                    end
                end
                return
            else
                winner = 'continue';
            end
        end
        
        flag = false;
        for i = 1:9
            if (gameBoard(i) == 0)
                flag = true;
            end
        end
        if (flag == false)
            winner = 'tie';
            if(realMove)
                record(3) = record(3) + 1;
                set(ties, 'String', num2str(record(3)));
                for j = 1:9
                    button = eval(sprintf('variable.button%d', j));
                    button.BackgroundColor = [ 1 1 0 ];
                    playAgain.Enable = 'on';
                end
            end
        end
        
    end

%function to control which positions on the game board are inhabited and
%who plays next.

    function selectPosition(src, ~, whoClicked)
        if (strcmp(whoClicked, currentPlayer) ||strcmp(gameType, 'PVP'))
            if (strcmp(currentPlayer, 'CPU'))
                symbol = cpu;
            else
                symbol = user;
            end
            set(src, 'String', symbol);
            set(src, 'Enable', 'off');
            numMoves = numMoves + 1;
            mapBoard(symbol, src.Position(1:2));
            winner = checkWin(true);
            if(~strcmp(winner, 'continue'))
                for j = 1:9
                    eval(sprintf('variable.button%d.Enable = ''off'';', j));
                end
                return
            else
                if (strcmp(symbol, user))
                    currentPlayer = 'CPU';
                else
                    currentPlayer = 'User';
                end
                if (strcmp(gameType, 'CVP'))
                    if(strcmp(currentPlayer, 'CPU'))
                        cpuMove(1, cpuOneLevel);
                        return
                    else
                        return
                    end
                elseif (strcmp(gameType, 'CVC'))
                    if(strcmp(currentPlayer, 'CPU'))
                        cpuMove(1, cpuOneLevel);
                        return
                    else
                        cpuMove(2, cpuTwoLevel);
                        return
                    end
                elseif (strcmp(gameType, 'PVP'))
                    return
                end
            end
        end
        
        
    end

    function mapBoard(str, pos)
        if (strcmp(str, 'X'))
            val = 1;
        else
            val = 4;
        end
        col = int8(((pos(1) * 100-x)/width) + 1);
        row = int8((y + height - pos(2) * 100)/height);
        
        gameBoard(row, col) = val;
        
    end

%resets the game to play again.

    function resetBoard(~, ~)
        for j = 1:9
            button = eval(sprintf('variable.button%d', j));
            button.Enable = 'on';
            set(button, 'String', '');
            set(button, 'BackgroundColor', [1 1 1]);
        end
        gameBoard = zeros(3,3);
        numMoves = 0;
        currentPlayer = originalCurrentPlayer;
        if(strcmp(gameType, 'CVC'))
            if (strcmp(currentPlayer, 'User'))
                cpuMove(2, cpuTwoLevel);
            else
                cpuMove(1, cpuOneLevel);
            end
        elseif (strcmp(gameType, 'CVP'))
            if (strcmp(currentPlayer, 'CPU'))
                cpuMove(1, cpuOneLevel);
            end
        end
    end

end