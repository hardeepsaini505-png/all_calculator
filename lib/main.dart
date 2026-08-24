import 'package:flutter/material.dart';

void main() => runApp(const AllCalculatorApp());

class AllCalculatorApp extends StatelessWidget {
  const AllCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'All Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <Map<String, dynamic>>[
      {'title': 'Unit Converter', 'icon': Icons.straighten, 'page': const UnitConverterPage()},
      {'title': 'Discount Calculator', 'icon': Icons.percent, 'page': const DiscountPage()},
      {'title': 'Profit / Loss', 'icon': Icons.trending_up, 'page': const ProfitLossPage()},
      {'title': 'GST Calculator', 'icon': Icons.receipt_long, 'page': const GstPage()},
      {'title': 'Extra Expense %', 'icon': Icons.local_shipping, 'page': const ExpensePage()},
      {'title': 'MRP / Sale Price', 'icon': Icons.sell, 'page': const MrpPage()},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('All-in-One Calculator')),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10,
          childAspectRatio: 1.35,
        ),
        itemCount: items.length,
        itemBuilder: (context, i) => Card(
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => items[i]['page'])),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(items[i]['icon'], size: 38),
                const SizedBox(height: 8),
                Text(items[i]['title'], textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CalcPage extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const CalcPage({super.key, required this.title, required this.children});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(title)),
    body: ListView(padding: const EdgeInsets.all(16), children: children),
  );
}

Widget field(TextEditingController c, String label, {TextInputType type = const TextInputType.numberWithOptions(decimal: true)}) =>
    Padding(padding: const EdgeInsets.only(bottom: 12), child: TextField(
      controller: c, keyboardType: type, decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
    ));

Widget result(String text) => Card(
  child: Padding(padding: const EdgeInsets.all(14), child: Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
);

double val(TextEditingController c) => double.tryParse(c.text.trim()) ?? 0;



class UnitConverterPage extends StatefulWidget {
  const UnitConverterPage({super.key});
  @override State<UnitConverterPage> createState() => _UnitConverterPageState();
}
class _UnitConverterPageState extends State<UnitConverterPage> {
  final c = TextEditingController();
  String type = 'Inch → CM';
  double r = 0;
  final types = ['Inch → CM','CM → Inch','Inch → Feet','Feet → Inch','Meter → Feet','Feet → Meter','Sq Ft → Sq Meter','Sq Meter → Sq Ft'];
  void calculate() {
    final x = val(c);
    setState(() {
      switch(type) {
        case 'Inch → CM': r=x*2.54; break;
        case 'CM → Inch': r=x/2.54; break;
        case 'Inch → Feet': r=x/12; break;
        case 'Feet → Inch': r=x*12; break;
        case 'Meter → Feet': r=x*3.280839895; break;
        case 'Feet → Meter': r=x/3.280839895; break;
        case 'Sq Ft → Sq Meter': r=x*0.09290304; break;
        default: r=x/0.09290304;
      }
    });
  }
  @override Widget build(BuildContext context) => CalcPage(title: 'Unit Converter', children: [
    DropdownButtonFormField<String>(value: type, decoration: const InputDecoration(labelText: 'Conversion', border: OutlineInputBorder()),
      items: types.map((x)=>DropdownMenuItem(value:x, child:Text(x))).toList(), onChanged:(x)=>setState(()=>type=x!)),
    const SizedBox(height: 12), field(c, 'Enter value'),
    ElevatedButton(onPressed: calculate, child: const Text('Convert')),
    result('Result = ${r.toStringAsFixed(4)}'),
  ]);
}

class DiscountPage extends StatefulWidget {
  const DiscountPage({super.key});
  @override State<DiscountPage> createState() => _DiscountPageState();
}
class _DiscountPageState extends State<DiscountPage> {
  final mrp=TextEditingController(), sale=TextEditingController();
  double p=0, saving=0;
  void calc(){ final m=val(mrp), s=val(sale); setState((){saving=m-s; p=m==0?0:(m-s)/m*100;});}
  @override Widget build(BuildContext context)=>CalcPage(title:'Discount Calculator',children:[
    field(mrp,'MRP'),field(sale,'Sale Price'),ElevatedButton(onPressed:calc,child:const Text('Calculate')),
    result('Discount = ${p.toStringAsFixed(2)}%\nSaving = ₹${saving.toStringAsFixed(2)}'),
  ]);
}

class ProfitLossPage extends StatefulWidget {
  const ProfitLossPage({super.key});
  @override State<ProfitLossPage> createState()=>_ProfitLossPageState();
}
class _ProfitLossPageState extends State<ProfitLossPage>{
  final cost=TextEditingController(), sale=TextEditingController(); double amount=0,p=0;
  void calc(){final c=val(cost),s=val(sale);setState((){amount=s-c;p=c==0?0:(s-c)/c*100;});}
  @override Widget build(BuildContext context)=>CalcPage(title:'Profit / Loss',children:[
    field(cost,'Cost Price'),field(sale,'Sale Price'),ElevatedButton(onPressed:calc,child:const Text('Calculate')),
    result(amount>=0?'Profit = ₹${amount.toStringAsFixed(2)}\nProfit % = ${p.toStringAsFixed(2)}%':'Loss = ₹${(-amount).toStringAsFixed(2)}\nLoss % = ${(-p).toStringAsFixed(2)}%'),
  ]);
}

class GstPage extends StatefulWidget {
  const GstPage({super.key});
  @override State<GstPage> createState()=>_GstPageState();
}
class _GstPageState extends State<GstPage>{
  final amount=TextEditingController(), rate=TextEditingController(text:'18'); bool add=true; double gst=0,total=0;
  void calc(){final a=val(amount),r=val(rate);setState((){gst=a*r/100;total=add?a+gst:a-gst;});}
  @override Widget build(BuildContext context)=>CalcPage(title:'GST Calculator',children:[
    field(amount,'Amount'),field(rate,'GST %'),
    SwitchListTile(title:Text(add?'Add GST':'Remove GST'),value:add,onChanged:(x)=>setState(()=>add=x)),
    ElevatedButton(onPressed:calc,child:const Text('Calculate')),
    result('GST = ₹${gst.toStringAsFixed(2)}\nFinal Amount = ₹${total.toStringAsFixed(2)}'),
  ]);
}

class ExpensePage extends StatefulWidget {
  const ExpensePage({super.key});
  @override State<ExpensePage> createState()=>_ExpensePageState();
}
class _ExpensePageState extends State<ExpensePage>{
  final amount=TextEditingController(), expense=TextEditingController(); double p=0,total=0;
  void calc(){final a=val(amount),e=val(expense);setState((){p=a==0?0:e/a*100;total=a+e;});}
  @override Widget build(BuildContext context)=>CalcPage(title:'Extra Expense %',children:[
    field(amount,'Samaan ki Cost'),field(expense,'Courier / Extra Expense'),
    ElevatedButton(onPressed:calc,child:const Text('Calculate')),
    result('Extra Expense = ${p.toStringAsFixed(2)}%\nTotal Cost = ₹${total.toStringAsFixed(2)}'),
    const Text('Example: ₹20,000 + ₹200 courier = 1% extra expense'),
  ]);
}


class MrpPage extends StatefulWidget {
  const MrpPage({super.key});
  @override State<MrpPage> createState()=>_MrpPageState();
}
class _MrpPageState extends State<MrpPage>{
  final cost=TextEditingController(),sale=TextEditingController(),mrp=TextEditingController();
  double disc=0,profit=0,profitP=0;
  void calc(){final c=val(cost),s=val(sale),m=val(mrp);setState((){disc=m==0?0:(m-s)/m*100;profit=s-c;profitP=c==0?0:(s-c)/c*100;});}
  @override Widget build(BuildContext context)=>CalcPage(title:'MRP / Sale Price',children:[
    field(cost,'Cost Price'),field(sale,'Sale Price'),field(mrp,'MRP'),
    ElevatedButton(onPressed:calc,child:const Text('Calculate')),
    result('MRP Discount = ${disc.toStringAsFixed(2)}%\nProfit = ₹${profit.toStringAsFixed(2)}\nProfit % = ${profitP.toStringAsFixed(2)}%'),
  ]);
}
