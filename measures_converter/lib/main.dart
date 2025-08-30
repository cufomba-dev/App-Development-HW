// Flutter Measures Converter Application
import 'package:flutter/material.dart';

// Entry point of the application
void main() {
  runApp(ConversionApp());
}

// Root widget that sets up the MaterialApp
class ConversionApp extends StatelessWidget {
  const ConversionApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Measures Converter',
      home: ConverterScreen(),
    );
  }
}

class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});
  @override
  ConverterScreenState createState() => ConverterScreenState();
}

class ConverterScreenState extends State<ConverterScreen> {
  // Unit selections and values
  String fromUnit = 'meters';
  String toUnit = 'feet';
  double inputValue = 100.0;
  double outputValue = 328.084;

  // Controller for the input TextField
  final TextEditingController _controller = TextEditingController(text: '100');

  // Supported units and their categories
  final Map<String, List<String>> unitCategories = {
    'Distance': ['meters', 'feet', 'inches', 'yards', 'miles', 'kilometers', 'centimeters', 'millimeters'],
    'Weight': ['kilograms', 'pounds', 'ounces', 'grams', 'stones'],
  };

  // Conversion factors relative to a base unit (meters for distance, kilograms for weight)
  final Map<String, double> conversionFactors = {
    'meters': 1.0,
    'feet': 3.28084,
    'inches': 39.3701,
    'yards': 1.09361,
    'miles': 0.000621371,
    'kilometers': 0.001,
    'centimeters': 100.0,
    'millimeters': 1000.0,
    'kilograms': 1.0,
    'pounds': 2.20462,
    'ounces': 35.274,
    'grams': 1000.0,
    'stones': 0.157473,
  };

  // Determine the category of a given unit
  String _getUnitCategory(String unit) {
    for (String category in unitCategories.keys) {
      if (unitCategories[category]!.contains(unit)) {
        return category;
      }
    }
    return '';
  }

  // Get valid 'to' units based on the selected 'from' unit
  List<String> _getValidToUnits() {
    String fromCategory = _getUnitCategory(fromUnit);
    return unitCategories[fromCategory] ?? [];
  }

  List<String> get allUnits => conversionFactors.keys.toList()..sort();

  // Perform the conversion based on selected units and input value
  void _performConversion() {
    String fromCategory = _getUnitCategory(fromUnit);
    String toCategory = _getUnitCategory(toUnit);
    
    if (fromCategory != toCategory || fromCategory.isEmpty) {
      setState(() {
        outputValue = 0.0;
      });
      return;
    }
    
    final fromFactor = conversionFactors[fromUnit]!;
    final toFactor = conversionFactors[toUnit]!;
    final baseValue = inputValue / fromFactor;
    final result = baseValue * toFactor;
    
    setState(() {
      outputValue = result;
    });
  }

  // Handle changes in the input TextField
  void _onInputChanged(String value) {
    setState(() {
      inputValue = double.tryParse(value) ?? 0.0;
      _performConversion();
    });
  }

  String _formatOutput(double value) {
    return value.toStringAsFixed(3);
  }

  // Build the UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[500],
      appBar: AppBar(
        title: Text('Measures Converter'),
        backgroundColor: Colors.blue[500],
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            children: [
              SizedBox(height: 20),
              
              Text('Value', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
              SizedBox(height: 12),
              TextField(
                controller: _controller,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, color: Colors.blue[600]),
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[600]!),
                  ),
                ),
                onChanged: _onInputChanged,
              ),
              
              SizedBox(height: 40),
              
              Text('From', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton<String>(
                  value: fromUnit,
                  isExpanded: true,
                  underline: SizedBox(),
                  style: TextStyle(fontSize: 18, color: Colors.blue[600]),
                  items: allUnits.map((unit) {
                    return DropdownMenuItem(value: unit, child: Text(unit));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      fromUnit = value!;
                      String newCategory = _getUnitCategory(fromUnit);
                      List<String> validToUnits = unitCategories[newCategory]!;
                      if (!validToUnits.contains(toUnit)) {
                        toUnit = validToUnits.first;
                      }
                      _performConversion();
                    });
                  },
                ),
              ),
              
              SizedBox(height: 40),
              
              Text('To', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton<String>(
                  value: toUnit,
                  isExpanded: true,
                  underline: SizedBox(),
                  style: TextStyle(fontSize: 18, color: Colors.blue[600]),
                  items: _getValidToUnits().map((unit) {
                    return DropdownMenuItem(value: unit, child: Text(unit));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      toUnit = value!;
                      _performConversion();
                    });
                  },
                ),
              ),
              
              SizedBox(height: 40),
              
              ElevatedButton(
                onPressed: _performConversion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('Convert', style: TextStyle(fontSize: 18)),
              ),
              
              SizedBox(height: 30),
              
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${_formatOutput(inputValue)} $fromUnit are ${_formatOutput(outputValue)} $toUnit',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}