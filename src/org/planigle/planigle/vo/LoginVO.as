package org.planigle.planigle.vo
{
	public class LoginVO
	{
		public var username:String;
		public var password:String;
		public var rememberMe:Boolean;
		public var acceptAgreement:Boolean;
		public var test:Boolean;
				
		public function LoginVO(username:String, password:String, rememberMe:Boolean = false, acceptAgreement:Boolean = false, test:Boolean = false)
		{
			this.username = username;
			this.password = password;
			this.rememberMe = rememberMe;
			this.acceptAgreement = acceptAgreement;
			this.test = test;
		}
	}
}