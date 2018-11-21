package aspects;

import actors.Invader;
import actors.Ufo;

privileged aspect UpdateSpeed {
	pointcut invaderAct(): 
		execution(void Invader.act());
	
	pointcut ufoAct():
		execution(void Ufo.act());
	
	after(Invader inv): target(inv) && invaderAct() {
		inv.updateXSpeed();
		inv.updateYSpeed();
	}
	
	after(Ufo ufo): target(ufo) && ufoAct() {
		ufo.updateXSpeed();
		ufo.updateYSpeed();
	}
}
