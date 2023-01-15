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
      retval[0]=daysUntil.toString() +" days\n"+hoursUntil.toString()+" hours\n"+minutesUntil.toString()+" minutes\n"+secondsUntil.toString()+" seconds";

    }else if(hoursUntil>0){
      retval[0]=hoursUntil.toString()+" hours\n"+minutesUntil.toString()+" minutes\n"+secondsUntil.toString()+" seconds";
    }else if(minutesUntil>0){
      retval[0]=minutesUntil.toString()+" minutes\n"+secondsUntil.toString()+" seconds";
    }else if(secondsUntil>0){
      retval[0]=secondsUntil.toString()+" seconds";
    }else{
      retval[0]="Book timer ended";
    }

    //reveal date
    Duration timeUntilReveal=due.subtract(Duration(days: 1)).difference(DateTime.now());

    int daysUntilReveal=timeUntilReveal.inDays;
    int hoursUntilReveal=timeUntilReveal.inHours-(daysUntilReveal*24);
    int minutesUntilReveal=timeUntilReveal.inMinutes-(daysUntilReveal*24*60)-(hoursUntilReveal*60);
    int secondsUntilReveal=timeUntilReveal.inSeconds-
        ( daysUntilReveal*24*60*60)-(hoursUntilReveal*60*60)-(minutesUntilReveal*60);

    if(daysUntilReveal>0){
      retval[1]=daysUntilReveal.toString() +" days\n"+hoursUntilReveal.toString()+" hours\n"+minutesUntilReveal.toString()+" minutes\n"+secondsUntilReveal.toString()+" seconds";

    }else if(hoursUntilReveal>0){
      retval[1]=hoursUntilReveal.toString()+" hours\n"+minutesUntilReveal.toString()+" minutes\n"+secondsUntilReveal.toString()+" seconds";
    }else if(minutesUntilReveal>0){
      retval[1]=minutesUntilReveal.toString()+" minutes\n"+secondsUntilReveal.toString()+" seconds";
    }else if(secondsUntilReveal>0){
      retval[1]=secondsUntilReveal.toString()+" seconds";
    }else{
      retval[1]="Error";
    }


    return retval;
  }
}