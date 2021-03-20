class User{
  String email ;
  String password ;
  String first_name ;
  String last_name ;
  String phone ;

  User.forSignIn({this.email,this.password});
  User.forSignUp({this.email,this.password,this.first_name,this.last_name,this.phone});
  User.fullUser({this.email,this.first_name,this.last_name,this.phone});
}