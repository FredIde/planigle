package org.planigle.planigle.control
{
	import com.adobe.cairngorm.control.FrontController;
	import org.planigle.planigle.commands.GetIndividualsCommand;
	import org.planigle.planigle.events.IndividualChangedEvent;
	
	public class IndividualsController extends FrontController
	{
		public function IndividualsController()
		{
			this.initialize();	
		}
		
		public function initialize():void
		{
			// Map event to command.
			this.addCommand(IndividualChangedEvent.INDIVIDUAL_CHANGED, GetIndividualsCommand);	
		}
	}
}