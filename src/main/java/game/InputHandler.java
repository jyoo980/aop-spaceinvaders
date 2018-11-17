package game;

import java.awt.event.KeyEvent;

import actors.Player;
import util.Logger;

/**
 * creates a thread to process player input
 * @author ghast
 *
 */
public class InputHandler {

	private Invaders invaders = null;
	private Player player  = null;
	private static final Logger LOGGER = Logger.getInstance();
	public Action action;

	public InputHandler(Invaders invaders, Player player) {
		this.invaders = invaders;
		this.player = player;
	}

	public void handleInput(KeyEvent event) {
		if (action == Action.PRESS) {
			if (KeyEvent.VK_ENTER == event.getKeyCode()) {
				if (invaders.gameOver || invaders.gameWon) {
					LOGGER.info("Game restarted");
					invaders.initWorld();
					invaders.game();
				}
			}

			else {
				LOGGER.info(String.format("Player pressed key %s", KeyEvent.getKeyText(event.getKeyCode())));
				player.keyPressed(event);
			}
		}
		else if (action == Action.RELSEASE)
			player.keyReleased(event);
	}

	public enum Action {
		PRESS,
		RELSEASE
	}
}
