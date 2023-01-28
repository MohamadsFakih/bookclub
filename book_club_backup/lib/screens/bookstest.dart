import 'package:book_club/screens/addBookScreen/addBook.dart';
import 'package:book_club/widgets/SearchItem.dart';
import 'package:book_club/widgets/ourContainer.dart';
import 'package:books_finder/books_finder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../states/currentGroup.dart';

class BookTest extends StatefulWidget {
  final String gid;
  final bool onGroupCreation;
  const BookTest({Key? key,
  required this.gid,required this.onGroupCreation}) : super(key: key);

  @override
  State<BookTest> createState() => _BookTestState();
}

class _BookTestState extends State<BookTest> {
  TextEditingController searchEditor=TextEditingController();

  List<Book> searchedBook=[];

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(

      appBar: AppBar(
        title: Text("Add Book",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: Color(0xfff73366ff),
        elevation: 0.0,
        leading: IconButton(icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pop(context);
          },),
      ),

        body: SafeArea(
          child: Column(
            children: [

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextFormField(
                  controller: searchEditor,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(prefixIcon: Icon(Icons.search),
                      hintText: "Search"),

                ),
              ),
              SizedBox(height: 15,),

              RaisedButton(
                child: Text("Search"),
                  onPressed: ()async {
                  searchedBook.clear();
                    final books = await queryBooks(
                      searchEditor.text.trim(),
                      maxResults: 10,
                      printType: PrintType.books,
                      orderBy: OrderBy.relevance,
                      reschemeImageLinks: true,
                    );
                    for (final book in books) {
                      final info = book.info;

                      setState((){
                        searchedBook.add(book);
                      });


                    }
                  }
              ),
              RaisedButton(
                  child: Text("Add Manually"),
                  onPressed: () {

                    Navigator.push(context,MaterialPageRoute(builder: (context)=>OurAddBook(groupName: widget.gid, onGroupCreation: widget.onGroupCreation,
                    bookLink: "",name: "",author: "",length: "",image: "https://i.postimg.cc/cLQRLt7f/content.jpg",)));

                  }
              ),
              SizedBox(height: 8,),
             Expanded(
               child: ListView.builder(
                 shrinkWrap: true,
                   itemCount: searchedBook.length,
                   scrollDirection: Axis.vertical,

                   itemBuilder: (context, index){
                   Book b =searchedBook[index];
                   Uri? uri=searchedBook[index].info.imageLinks["thumbnail"];

                        return SearchItem(name: b.info.title, author: b.info.authors.isEmpty?"":b.info.authors[0],pages: b.info.pageCount.toString(),
                          categories: b.info.categories,image: uri==null? "https://i.postimg.cc/cLQRLt7f/content.jpg":uri.toString(),gid: widget.gid,
                          onGroupCreation: widget.onGroupCreation,
                        );
                   }
               ),
             )

            ],
          ),
        ),
    );
  }
}
