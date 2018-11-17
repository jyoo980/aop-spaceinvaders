package aspects;

import util.Logger;

import java.awt.event.KeyEvent;

import actors.Invader;
import game.InputHandler;
import game.Invaders;
import game.InputHandler.Action;

privileged aspect InvadersLogger {
	
	private int invaderNumSoFar = 0;
	private final Logger Log = Logger.getInstance();
	
	pointcut invaderConstructor(): call(Invader.new(..));
	pointcut addInvaders(): execution(void Invaders.addInvaders(..));
	pointcut game(Invaders inv): execution(void Invaders.game(..)) && target(inv);
	pointcut handleInput(InputHandler h, KeyEvent ev):
		target(h) && execution(void InputHandler.handleInput(..)) && args(ev);
	
	after(): invaderConstructor() {
		this.invaderNumSoFar++;
	}
	
	after(): addInvaders() {
		Log.info("Total number of invaders instantiated: " + this.invaderNumSoFar);
	}
	
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
	
	void around(Invaders invaderGame): game(invaderGame) {
		if (invaderGame.gameOver()) {
			Log.trace("Player has lost the game");
		} else if (invaderGame.gameWon()) {
			Log.trace("Player has won the game");
		}
		proceed(invaderGame);
	}
	
	private String formatInputString(KeyEvent event) {
		return KeyEvent.getKeyText(event.getKeyCode());
	}
}
