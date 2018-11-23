package aspects;

import util.Logger;

import java.awt.event.KeyEvent;

import actors.Invader;
import game.InputHandler;
import game.Invaders;
import actors.*;
import game.InputHandler.Action;

privileged aspect InvadersLogger {
	
	private int invaderNumSoFar = 0;
	private final Logger Log = Logger.getInstance();
	
	pointcut invaderConstructor(): call(Invader.new(..));
	pointcut addInvaders(): execution(void Invaders.addInvaders(..));
	pointcut gameOver(): 
		call(* Invaders.gameOver(..)) && cflow(execution(void Invaders.game(..)));
	pointcut gameWon(): 
		call(* Invaders.gameWon(..)) && cflow(execution(void Invaders.game(..)));
	pointcut markedForRemoval(Actor actr):
		target(actr) && call(boolean Actor.isMarkedForRemoval(..)) && withincode(void Invaders.updateWorld(..));
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
	
	after(Actor actr): markedForRemoval(actr) {
		if (actr.isMarkedForRemoval()) {
			int pointVal = actr.getPointValue();
			if (pointVal > 0) {
				Log.info("Player destroyed enemy worth: " + pointVal + " pts");
			}
		}
	}
	
	boolean around(): gameOver() {
		boolean gameOver = proceed();
		if (gameOver) {
			Log.trace("Player has lost the game");
		}
		return gameOver;
	}
	
	boolean around(): gameWon() {
		boolean gameWon = proceed();
		if (gameWon) {
			Log.trace("Player has won the game");
		}
		return gameWon;
	}
	
	private String formatInputString(KeyEvent event) {
		return KeyEvent.getKeyText(event.getKeyCode());
	}
}
