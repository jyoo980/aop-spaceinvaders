package aspects;

import util.Logger;

import game.Stage;

public aspect GameStateLogger {
	
	private final Logger Log = Logger.getInstance();
	
	pointcut gameEnded(): execution(void Stage.endGame());
	
	after(): gameEnded() {
		Log.info("Player has lost the game");
	}

}
