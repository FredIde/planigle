package org.planigle.planigle.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import mx.controls.Alert;
	import mx.rpc.IResponder;
	import org.planigle.planigle.business.IterationsDelegate;
	import org.planigle.planigle.model.IterationFactory;
	
	public class GetIterationsCommand implements ICommand, IResponder
	{
		public function GetIterationsCommand()
		{
		}
		
		// Required for the ICommand interface.  Event must be of type Cairngorm event.
		public function execute(event:CairngormEvent):void
		{
			//  Delegate acts as both delegate and responder.
			var delegate:IterationsDelegate = new IterationsDelegate( this, IterationFactory.getInstance().timeUpdated );
			
			delegate.get();
		}
		
		// Handle successful server request.
		public function result( event:Object ):void
		{
			var result:Object = event.result;
			if (result.records != null)
				IterationFactory.getInstance().populate(result.time, result.records as Array);
		}
		
		// Handle case where error occurs.
		public function fault( event:Object ):void
		{
			Alert.show(event.fault.faultString);
		}
	}
}