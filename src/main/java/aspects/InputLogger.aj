package aspects;

import util.Logger;
import game.InputHandler;
import java.awt.event.*;

public aspect InputLogger {
	
	private final Logger Log = Logger.getInstance();
	pointcut handleInput(KeyEvent ev): execution(void InputHandler.handleInput(..)) && args(ev);
	
	void around(KeyEvent ev): handleInput(ev) {
		// TODO: this is gonna be tricky
	}

}
