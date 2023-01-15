import 'package:book_club/widgets/ourContainer.dart';
import 'package:books_finder/books_finder.dart';
import 'package:flutter/material.dart';

class BookTest extends StatefulWidget {
  const BookTest({Key? key}) : super(key: key);

  @override
  State<BookTest> createState() => _BookTestState();
}

class _BookTestState extends State<BookTest> {

  List<Book> searchedBook=[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(prefixIcon: Icon(Icons.alternate_email),
                  hintText: "Email"),
              onChanged: (text)async{
                final books = await queryBooks(
                  text,
                  maxResults: 5,
                  printType: PrintType.books,
                  orderBy: OrderBy.relevance,
                  reschemeImageLinks: true,
                );
                for (final book in books) {
                  setState((){
                    searchedBook.add(book);
                    print(book.info.imageLinks);
                  });

                }
              },
            ),
            ListView(
              children: [
                OurContainer(
                    child: Row(
                      children: [

                      ],
                    )
                )
              ],
            )
          ],
        ),
    );
  }
}
