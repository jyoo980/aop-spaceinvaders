package aspects;

import util.Logger;
import game.InputHandler;
import game.InputHandler.Action;

import java.awt.event.*;

public aspect InputLogger {
	
	private final Logger Log = Logger.getInstance();
	pointcut handleInput(InputHandler h, KeyEvent ev):
		target(h) && execution(void InputHandler.handleInput(..)) && args(ev);
	
	before(InputHandler h, KeyEvent ev): handleInput(h, ev) {
		if (h.action == Action.PRESS) {
			if (KeyEvent.VK_ENTER == ev.getKeyCode()) {
				if (h.invaders.gameOver || h.invaders.gameWon) {
					Log.info("Game Restarted");
				}
			} else {
				Log.info(String.format("Player pressed key %s", this.formatInputString(ev)));
			}
		}
	}
	
	private String formatInputString(KeyEvent event) {
		return KeyEvent.getKeyText(event.getKeyCode());
	}

}
