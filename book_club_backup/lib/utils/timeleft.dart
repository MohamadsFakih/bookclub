import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class OurTimeLeft{
  List<String> timeleft(DateTime due){
    List<String> retval=List.filled(2, "");
    //due date
    Duration timeUntilDue=due.difference(DateTime.now());
    int daysUntil=timeUntilDue.inDays;
    int hoursUntil=timeUntilDue.inHours-(daysUntil*24);
    int minutesUntil=timeUntilDue.inMinutes-(daysUntil*24*60)-(hoursUntil*60);
    int secondsUntil=timeUntilDue.inSeconds-
        ( daysUntil*24*60*60)-(hoursUntil*60*60)-(minutesUntil*60);

    if(daysUntil>0){
      retval[0]=daysUntil.toString() +" days "+hoursUntil.toString()+" hours \n"+minutesUntil.toString()+" minutes "+secondsUntil.toString()+" seconds";

    }else if(hoursUntil>0){
      retval[0]=hoursUntil.toString()+" hours \n"+minutesUntil.toString()+" minutes "+secondsUntil.toString()+" seconds";
    }else if(minutesUntil>0){
      retval[0]=minutesUntil.toString()+" minutes "+secondsUntil.toString()+" seconds";
    }else if(secondsUntil>0){
      retval[0]=secondsUntil.toString()+" seconds";
    }else{
      retval[0]="Timer Ended";
    }


    return retval;
  }
}