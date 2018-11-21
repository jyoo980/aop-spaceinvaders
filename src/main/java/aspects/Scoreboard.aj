package aspects;

import actors.Actor;
import game.Invaders;
import util.Logger;

import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics;

public aspect Scoreboard {
	
	private int score = 0;
	private static final Logger LOGGER = Logger.getInstance();
	
	pointcut hit(boolean isMarked): call(void Actor.setMarkedForRemoval(..)) && args(isMarked);
	pointcut display(): 
		execution(void paintGameWon()) || execution(void Invaders.paintGameOver()) || execution(void paintWorld());
	
	after(Invaders inv): target(inv) && display() {
		Graphics g = inv.strategy.getDrawGraphics();
		this.updateScore(g);
		inv.strategy.show();
	}
	
	after(Actor actor, boolean isMarked): target(actor) && hit(isMarked) {
		if (isMarked) {
			int pointValue = actor.getPointValue();
			if (pointValue > 0) LOGGER.info(String.format("Player has destroyed an enemy worth %d points", actor.getPointValue()));
			score += pointValue;
		}
	}
	
	private void updateScore(Graphics g) {
		g.setFont(new Font("Arial",Font.BOLD,20));
		g.setColor(Color.green);
		g.drawString("Score: ",20,20);
		g.setColor(Color.red);
		g.drawString("" + score, 100, 20);
	}
	
}