import 'package:flutter/material.dart';
import 'package:rive_animation/screens/entryPoint/chat/chat.dart';
class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController name = TextEditingController();
     TextEditingController Medical_condition = TextEditingController();
      TextEditingController Age = TextEditingController();
       TextEditingController Gender = TextEditingController();
        TextEditingController Weight = TextEditingController();
         TextEditingController BloodGroup = TextEditingController();
          TextEditingController Medical_History = TextEditingController();
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 50.0),
          child: Stack(
            children:<Widget>[ 
              Container(
                   margin: EdgeInsets.only(top:80.0),
                   width: MediaQuery.of(context).size.width,
                   height: MediaQuery.of(context).size.height,
                   decoration: BoxDecoration(
                    color: Color(0xFF7BBFFF),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                    )
        
        
                   ),
        
                child: Column(children: <Widget>[
              
                  Container(
                    padding: EdgeInsets.only(top:70.0,left:20.0,right: 20.0),
                    child: Column(children: <Widget>[
                      TextField(
                        controller: name,
                        decoration: InputDecoration(
                          labelText: 'Name' ,
                          prefixIcon: Icon(Icons.person),
                          border:myInputBorder(),
                          enabledBorder: myInputBorder(),
                          focusedBorder: myFocusBorder(), 
                        ),
                      ),
                           
                      SizedBox(height: 20.0,),
                               TextField(
                        controller: Medical_condition,
                        decoration: InputDecoration(
                          labelText: 'Medical_condition' ,
                          prefixIcon: Icon(Icons.medical_information),
                          border:myInputBorder(),
                          enabledBorder: myInputBorder(),
                          focusedBorder: myFocusBorder(), 
                        ),
                      ),
                      SizedBox(height: 20.0,),
                               TextField(
                        controller: Age,
                        decoration: InputDecoration(
                          labelText: 'Age' ,
                          prefixIcon: Icon(Icons.person_3),
                          border:myInputBorder(),
                          enabledBorder: myInputBorder(),
                          focusedBorder: myFocusBorder(), 
                        ),
                      ),
                      SizedBox(height: 20.0,),
                               TextField(
                        controller: Gender,
                        decoration: InputDecoration(
                          labelText: 'Gender' ,
                          prefixIcon: Icon(Icons.person_add_alt_1_rounded),
                          border:myInputBorder(),
                          enabledBorder: myInputBorder(),
                          focusedBorder: myFocusBorder(), 
                        ),
                      ),
                      SizedBox(height: 20.0,),
                               TextField(
                        controller: Weight,
                        decoration: InputDecoration(
                          labelText: 'Weight' ,
                          prefixIcon: Icon(Icons.monitor_weight_rounded),
                          border:myInputBorder(),
                          enabledBorder: myInputBorder(),
                          focusedBorder: myFocusBorder(), 
                        ),
                      ),
                      SizedBox(height: 20.0,),
                           TextField(
                        controller: BloodGroup,
                        decoration: InputDecoration(
                          labelText: 'BloodGroup' ,
                          prefixIcon: Icon(Icons.bloodtype),
                          border:myInputBorder(),
                          enabledBorder: myInputBorder(),
                          focusedBorder: myFocusBorder(), 
                        ),
                      ),
                      SizedBox(height: 20.0,),
                               TextField(
                        controller: Medical_History,
                        decoration: InputDecoration(
                          labelText: 'Medical_History' ,
                          prefixIcon: Icon(Icons.medical_information_sharp),
                          border:myInputBorder(),
                          enabledBorder: myInputBorder(),
                          focusedBorder: myFocusBorder(), 
                        ),
                      ),
                      SizedBox
                      (height: 20.0,
                      ),
                  ElevatedButton(onPressed:(){
                  },
                   child: Text('update'),
                   style: ElevatedButton.styleFrom(
                       shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(15.0),
                       ),
                    primary: Color(0xFF1713DB),
                    padding: EdgeInsets.symmetric(horizontal: 45.0,vertical: 20.0),
                    textStyle: TextStyle(fontSize: 25,fontWeight: FontWeight.bold)
      
                   ),
                   
                   )
                  
                  
                  
                    ],),
                  )
                ],
                ),
              ),
              Align(
              alignment: Alignment.topCenter,
            child: Stack(
             children: <Widget>[
               ClipOval(
              child: Image.asset('images/person.jpg'
              ,width: 150,height: 150,fit: BoxFit.cover,),
            ),
            // Icon(Icons.edit,size: 30.0 ,)
            Positioned(
              bottom: 5,
              right: 15.5,
              child: Container(
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 196, 239, 254),shape: BoxShape.circle
              ),
              child: const Icon(Icons.edit,size: 30.0,)),
            )
              ]),),
          ]),
        ),
      ));
  }
  OutlineInputBorder myInputBorder(){
    return OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20)),
    
    borderSide: BorderSide(
      color: Color.fromARGB(255, 140, 175, 250),
      width: 3,
    ));
  }
    OutlineInputBorder myFocusBorder(){
    return OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20)),
    
    borderSide: BorderSide(
      color: Color.fromARGB(255, 2, 219, 247),
      width: 3,
    ));
  }
}