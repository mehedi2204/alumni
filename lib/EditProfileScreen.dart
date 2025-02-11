import 'dart:io';
import 'package:alumni/profession_list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:typed_data'; // Import for Uint8List

import 'Home_screen.dart';

class EditProfileScreen extends StatefulWidget {
  final User user; // Assuming User is a defined class with necessary fields

  const EditProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _mobileController;
  late TextEditingController _fNameController;
  late TextEditingController _mNameController;
  late TextEditingController _preAddrController;
  late TextEditingController _prePhoneController;
  late TextEditingController _preEmailController;
  late TextEditingController _perAddrController;
  late TextEditingController _perPhoneController;
  late TextEditingController _perEmailController;
  late TextEditingController _officeNameController;
  late TextEditingController _offAddrController;
  late TextEditingController _offPhoneController;
  late TextEditingController _offEmailController;
  late TextEditingController _dobController;
  late TextEditingController _designationController;

  // New TextEditingControllers for additional fields
  late TextEditingController _catCodeController; // For category code
  late TextEditingController _collSecController; // For college section
  late TextEditingController _yrOfPassController; // For year of passing
  late TextEditingController _preDivController; // For present division
  late TextEditingController _preDistController; // For present district
  late TextEditingController _preThanaController; // For present thana
  late TextEditingController _perDivController; // For permanent division
  late TextEditingController _perDistController; // For permanent district
  late TextEditingController _perThanaController; // For permanent thana
  late TextEditingController _profCodeController; // For professional code
  late TextEditingController _domController; // For date of membership
  late TextEditingController _prePostCodeController; // For present post code
  late TextEditingController _memTypeController; // For member type

  bool _isLoading = false;

  String? memId = "";
  String? savedPhone = "";
  String? savedPassword = "";
  String? username = "";
  String? usermemphoto = "";
  String? usercollrollname = "";
  String? fathername = "";
  String? mothername = ""; // Added for mother's name
  String? presentAddress = ""; // Added for present address
  String? presentPhone = ""; // Added for present phone
  String? presentEmail = ""; // Added for present email
  String? permanentAddress = ""; // Added for permanent address
  String? permanentPhone = ""; // Added for permanent phone
  String? permanentEmail = ""; // Added for permanent email
  String? officeName = ""; // Added for office name
  String? officeAddress = ""; // Added for office address
  String? officePhone = ""; // Added for office phone
  String? officeEmail = ""; // Added for office email
  String? dob = ""; // Added for date of birth
  String? designation = ""; // Added for designation

// Additional fields for more user data
  String? catCode = ""; // Added for category code
  String? collSec = ""; // Added for college section
  String? yrOfPass = ""; // Added for year of passing
  String? preAddr = ""; // Added for present address
  String? preDiv = ""; // Added for present division
  String? preDist = ""; // Added for present district
  String? preThana = ""; // Added for present thana
  String? prePhone = ""; // Added for present phone
  String? perAddr = ""; // Added for permanent address
  String? perDiv = ""; // Added for permanent division
  String? perDist = ""; // Added for permanent district
  String? perThana = ""; // Added for permanent thana
  String? perPhone = ""; // Added for permanent phone
  String? profCode = ""; // Added for profession code
  String? dom = ""; // Added for date of membership
  String? prePostCode = ""; // Added for present post code
  String? memType = ""; // Added for member type
// Added for designation

  String? selectedProfession;


  File? _pickedImage; // To store the picked image
  final ImagePicker _picker = ImagePicker(); // Image picker instance

  @override
  void initState() {
    getdata();
    super.initState();
    fetchDivisions();
    // Initialize controllers with user data
    _nameController = TextEditingController(text: widget.user.memName);
    _mobileController = TextEditingController(text: widget.user.memMobileNo);
    _fNameController = TextEditingController(text: widget.user.fName ?? '');
    _mNameController = TextEditingController(text: widget.user.mName ?? '');
    _preAddrController = TextEditingController(text: widget.user.preAddr ?? '');
    _prePhoneController = TextEditingController(text: widget.user.prePhone ?? '');
    _preEmailController = TextEditingController(text: widget.user.preEmail ?? '');
    _perAddrController = TextEditingController(text: widget.user.perAddr ?? '');
    _perPhoneController = TextEditingController(text: widget.user.perPhone ?? '');
    _perEmailController = TextEditingController(text: widget.user.perEmail ?? '');
    _officeNameController = TextEditingController(text: widget.user.officeName ?? '');
    _offAddrController = TextEditingController(text: widget.user.offAddr ?? '');
    _offPhoneController = TextEditingController(text: widget.user.offPhone ?? '');
    _offEmailController = TextEditingController(text: widget.user.offEmail ?? '');
    _dobController = TextEditingController(text: widget.user.dob ?? '');
    _designationController = TextEditingController(text: widget.user.designation ?? '');

    // Initialize additional controllers for new fields
    _catCodeController = TextEditingController(text: widget.user.catCode ?? '');
    _collSecController = TextEditingController(text: widget.user.collSec ?? '');
    _yrOfPassController = TextEditingController(text: widget.user.yrOfPass ?? '');
    _preDivController = TextEditingController(text: widget.user.preDiv ?? '');
    _preDistController = TextEditingController(text: widget.user.preDist ?? '');
    _preThanaController = TextEditingController(text: widget.user.preThana ?? '');
    _perDivController = TextEditingController(text: widget.user.perDiv ?? '');
    _perDistController = TextEditingController(text: widget.user.perDist ?? '');
    _perThanaController = TextEditingController(text: widget.user.perThana ?? '');
    _profCodeController = TextEditingController(text: widget.user.profCode ?? '');
    _domController = TextEditingController(text: widget.user.dom ?? '');
    _prePostCodeController = TextEditingController(text: widget.user.prePostCode ?? '');
    _memTypeController = TextEditingController(text: widget.user.memType ?? '');
  }


  void getdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      memId = prefs.getString('memid') ?? '';
      savedPhone = prefs.getString('userphone') ?? '';
      savedPassword = prefs.getString('password') ?? '';
      username = prefs.getString("username") ?? '';
      usercollrollname = prefs.getString("usercollrollname") ?? '';
      usermemphoto = prefs.getString("memPhoto") ?? '';
      fathername = prefs.getString("fathername") ?? '';
      mothername = prefs.getString("mothername") ?? '';
      presentAddress = prefs.getString("presentaddress") ?? '';
      presentPhone = prefs.getString("presentphone") ?? '';
      presentEmail = prefs.getString("presentemail") ?? '';
      permanentAddress = prefs.getString("permanentaddress") ?? '';
      permanentPhone = prefs.getString("permanentphone") ?? '';
      permanentEmail = prefs.getString("permanentemail") ?? '';
      officeName = prefs.getString("officename") ?? '';
      officeAddress = prefs.getString("officeaddress") ?? '';
      officePhone = prefs.getString("officephone") ?? '';
      officeEmail = prefs.getString("officeemail") ?? '';
      dob = prefs.getString("dob") ?? '';
      designation = prefs.getString("designation") ?? '';

      // Adding additional fields
      catCode = prefs.getString("usercatcode") ?? ''; // Added for category code
      collSec = prefs.getString("usercollsec") ?? ''; // Added for college section
      yrOfPass = prefs.getString("yearofpass") ?? ''; // Added for year of passing
      preDiv = prefs.getString("presentdiv") ?? ''; // Added for present division
      preDist = prefs.getString("presentdist") ?? ''; // Added for present district
      preThana = prefs.getString("presentthana") ?? ''; // Added for present thana
      perDiv = prefs.getString("permanentdiv") ?? ''; // Added for permanent division
      perDist = prefs.getString("permanentdist") ?? ''; // Added for permanent district
      perThana = prefs.getString("permanentthana") ?? ''; // Added for permanent thana
      profCode = prefs.getString("profcode") ?? ''; // Added for profession code
      dom = prefs.getString("dom") ?? ''; // Added for date of membership
      prePostCode = prefs.getString("pre_post_code") ?? ''; // Added for present post code
      memType = prefs.getString("membertype") ?? ''; // Added for member type

      selectedProfession = profCode; // Set selectedProfession to profCode
    });

    print('---------------------$usermemphoto-----------------------');
  }


  Uint8List? decodeBase64(String base64String) {
    try {
      return base64Decode(base64String);
    } catch (e) {
      print("Error decoding Base64: $e");
      return null;
    }
  }

  Future<void> _updateUserData() async {
    setState(() {
      _isLoading = true;
    });

    // Check if memId is empty or null
    if (memId == null || memId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User ID is missing. Please try again.')),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    // Convert image to Base64 string if an image is picked
    String? memPhotoBase64;
    if (_pickedImage != null) {
      final bytes = await _pickedImage!.readAsBytes();
      memPhotoBase64 = base64Encode(bytes);
    }

    // Construct the updated user data
    final updatedUserData = {
      'mem_id': memId,
      'action': "update",
      'mem_photo': memPhotoBase64 ?? '', // Ensure empty string if no new image
      'mem_name': _nameController.text,
      'mem_mobile_no': _mobileController.text,
      'f_name': _fNameController.text,
      'm_name': _mNameController.text,
      'pre_addr': _preAddrController.text,
      'pre_phone': _prePhoneController.text,
      'pre_email': _preEmailController.text,
      'per_addr': _perAddrController.text,
      'per_phone': _perPhoneController.text,
      'per_email': _perEmailController.text,
      'office_name': _officeNameController.text,
      'off_addr': _offAddrController.text,
      'off_phone': _offPhoneController.text,
      'off_email': _offEmailController.text,
      'dob': _dobController.text,
      'designation': _designationController.text,
      // Additional fields
      'cat_code': _catCodeController.text,
      'coll_sec': _collSecController.text,
      'yr_of_pass': _yrOfPassController.text,
      'pre_div': selectedPreDivision,
      'pre_dist': selectedPreDistrict,
      'pre_thana': selectedPreThana,
      'per_div': selectedPerDivision,
      'per_dist': selectedPerDistrict,
      'per_thana': selectedPerThana,
      'prof_code': selectedProfession,
      'dom': _domController.text,
      'pre_post_code': _prePostCodeController.text,
      'mem_type': _memTypeController.text,
    };

    try {
      // Call your API to update user data here
      final response = await http.post(
        Uri.parse('http://103.106.118.10/ndc90_api/userupdate.php'), // Replace with your actual endpoint
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updatedUserData), // Ensure that the data is correctly formatted
      );

      if (response.statusCode == 200) {
        // Handle success
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );

        // Update local state with the new data

        print('----------------Professional Code $selectedProfession ---------------------');
        // Optionally, you can navigate back or refresh the user data
        Navigator.pop(context, true); // Go back to the previous screen
      } else {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: ${response.body}')),
        );
      }

    } catch (e) {
      // Handle exceptions (e.g., network issues)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred. Please try again later.')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Function to pick image from the gallery
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path); // Store the image file
      });

      // Encode the image to Base64
      String base64Image = await _encodeImageToBase64(_pickedImage!);

      // Here you can use `base64Image` to include in your database
      // Example: saveToDatabase(base64Image);
    }
  }

// Function to encode image to Base64
  Future<String> _encodeImageToBase64(File image) async {
    // Read the image file as bytes
    Uint8List imageBytes = await image.readAsBytes();
    // Encode the bytes to Base64
    String base64String = base64Encode(imageBytes);
    return base64String; // Return the encoded string
  }

// Function to decode Base64 to image (optional, for display purposes)
  Uint8List? _decodeBase64(String? base64String) {
    if (base64String == null || base64String.isEmpty) {
      return null; // Return null if the Base64 string is null or empty
    }
    return base64Decode(base64String); // Decode and return the bytes
  }

  // Variables for Dropdowns
  String? selectedPreDivision;
  String? selectedPreDistrict;
  String? selectedPreThana;
  String? selectedPerDivision;
  String? selectedPerDistrict;
  String? selectedPerThana;

  List<dynamic> divisions = [];
  List<dynamic> districts = [];
  List<dynamic> thanas = [];

  // For Present Address Dropdowns
  List<dynamic> preDistricts = [];
  List<dynamic> preThanas = [];

  // For Permanent Address Dropdowns
  List<dynamic> perDistricts = [];
  List<dynamic> perThanas = [];


  // Fetch Divisions
  Future<void> fetchDivisions() async {
    final response = await http.get(Uri.parse('http://103.106.118.10/ndc90_api/div.php'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        divisions = data['data'];
        if (divisions.isNotEmpty) {
          print("pre dist============================================ProfCode: ${profCode}");
          // Set initial selected value for divisions
          selectedPreDivision = divisions[int.parse(preDiv!)-1]['DIV_CODE']; // Assuming the key is 'division_code'
          selectedPerDivision = divisions[int.parse(perDiv!)-1]['DIV_CODE'];
          print("=====================pre div: $selectedPreDivision");
          // Fetch districts for the initial division
          fetchDistricts(selectedPreDivision!, true); // For present address
          fetchDistricts(selectedPerDivision!, false); // For permanent address
        }
      });
    }
  }


  // Fetch Districts based on division code
  Future<void> fetchDistricts(String divCode, bool isPresent) async {
    final response = await http.get(Uri.parse('http://103.106.118.10/ndc90_api/district.php?div_code=$divCode'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        if (isPresent) {
          preDistricts = data['data'];
          print(preDistricts);
          if (preDistricts.isNotEmpty) {
            // Find the district that matches the preDist value, don't use it as an index
            selectedPreDistrict = preDistricts.firstWhere(
                  (district) => district['DIST_CODE'] == preDist,
              orElse: () => null,
            )?['DIST_CODE'];

            if (selectedPreDistrict != null) {
              fetchThanas(selectedPreDistrict!, true); // Fetch Thanas for the selected district
            }
            print("================pre District: $selectedPreDistrict");
          }
        } else {
          perDistricts = data['data'];
          if (perDistricts.isNotEmpty) {
            // Find the district that matches the perDist value
            selectedPerDistrict = perDistricts.firstWhere(
                  (district) => district['DIST_CODE'] == perDist,
              orElse: () => null,
            )?['DIST_CODE'];

            if (selectedPerDistrict != null) {
              fetchThanas(selectedPerDistrict!, false); // Fetch Thanas for the selected district
            }
          }
        }
        selectedPreThana = null;  // Reset Thana for new district
        selectedPerThana = null;
      });
    }
  }



  // Fetch Thanas based on district code
  Future<void> fetchThanas(String distCode, bool isPresent) async {
    final response = await http.get(Uri.parse('http://103.106.118.10/ndc90_api/thana.php?dist_code=$distCode'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        if (isPresent) {
          preThanas = data['data'];
          if (preThanas.isNotEmpty) {
            // Find the thana that matches the preThana value
            selectedPreThana = preThanas.firstWhere(
                  (thana) => thana['THANA_CODE'] == preThana,
              orElse: () => null,
            )?['THANA_CODE'];
          }
        } else {
          perThanas = data['data'];
          if (perThanas.isNotEmpty) {
            // Find the thana that matches the perThana value
            selectedPerThana = perThanas.firstWhere(
                  (thana) => thana['THANA_CODE'] == perThana,
              orElse: () => null,
            )?['THANA_CODE'];
          }
        }
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Edit Profile",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.greenAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // User Profile Photo with image picker
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _pickedImage != null
                        ? FileImage(_pickedImage!)
                        : usermemphoto != null && usermemphoto!.isNotEmpty
                        ? MemoryImage(decodeBase64(fixBase64(usermemphoto!)) ?? Uint8List(0))
                        : const AssetImage('assets/default_profile.png') as ImageProvider,
                  ),
                ),
                const SizedBox(height: 20),

                // User Information Fields
                _buildTextField(_nameController, 'Name', username),
                _buildTextField(_mobileController, 'Phone number', savedPhone),
                _buildTextField(_fNameController, 'Father\'s Name', fathername),
                _buildTextField(_mNameController, 'Mother\'s Name', mothername),
                _buildDropdownProf('Select Profession', selectedProfession, professions, (value) {
                  setState(() {
                    selectedProfession = value;
                    print("---------------------------Selected Profession: $selectedProfession");
                  });
                }),

                const SizedBox(height: 10),

                // Tab Bar for addresses
                TabBar(
                  tabs: [
                    Tab(
                      child: Container(
                        height: 60.0, // Set a common height for all tabs
                        decoration: BoxDecoration(
                          color: Color(0xFFC0392B), // Set background color
                          borderRadius: BorderRadius.circular(8.0), // Optional: add rounded corners
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Present", style: TextStyle(color: Colors.white)),
                            Text("Address", style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                    Tab(
                      child: Container(
                        height: 60.0, // Set a common height for all tabs
                        decoration: BoxDecoration(
                          color: Color(0xFFC0392B), // Set background color
                          borderRadius: BorderRadius.circular(8.0), // Optional: add rounded corners
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Permanent", style: TextStyle(color: Colors.white)),
                            Text("Address", style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                    Tab(
                      child: Container(
                        height: 60.0, // Set a common height for all tabs
                        decoration: BoxDecoration(
                          color: Color(0xFFC0392B), // Set background color
                          borderRadius: BorderRadius.circular(8.0), // Optional: add rounded corners
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Office", style: TextStyle(color: Colors.white)),
                            Text("Address", style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),


                const SizedBox(height:20),
                // Tab view for addresses
                SizedBox(
                  height: 400, // Adjust height as needed
                  child: TabBarView(
                    children: [
                      // Present Address Tab
                      Container(
                        padding: const EdgeInsets.all(16.0), // Add padding if needed
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              _buildTextField(_preAddrController, 'Present Address', presentAddress),
                              _buildTextField(_prePhoneController, 'Present Phone', presentPhone),
                              _buildTextField(_preEmailController, 'Present Email', presentEmail),
                              _buildDropdown('Present Division', selectedPreDivision, divisions, (value) {
                                setState(() {
                                  selectedPreDivision = value;
                                  fetchDistricts(value!, true); // Fetch districts for present address
                                });
                              }),
                              _buildDropdown('Present District', selectedPreDistrict, preDistricts, (value) {
                                setState(() {
                                  selectedPreDistrict = value;
                                  fetchThanas(value!, true); // Fetch thanas for present address
                                });
                              }),
                              _buildDropdown('Present Thana', selectedPreThana, preThanas, (value) {
                                setState(() {
                                  selectedPreThana = value;
                                });
                              }),
                              _buildTextField(_prePostCodeController, 'Present Post Code', prePostCode),
                            ],
                          ),
                        ),
                      ),

                      // Permanent Address Tab
                      Container(
                        padding: const EdgeInsets.all(16.0), // Add padding if needed
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              _buildTextField(_perAddrController, 'Permanent Address', permanentAddress),
                              _buildTextField(_perPhoneController, 'Permanent Phone', permanentPhone),
                              _buildTextField(_perEmailController, 'Permanent Email', permanentEmail),
                              _buildDropdown('Permanent Division', selectedPerDivision, divisions, (value) {
                                setState(() {
                                  selectedPerDivision = value;
                                  fetchDistricts(value!, false); // Fetch districts for permanent address
                                });
                              }),
                              _buildDropdown('Permanent District', selectedPerDistrict, perDistricts, (value) {
                                setState(() {
                                  selectedPerDistrict = value;
                                  fetchThanas(value!, false); // Fetch thanas for permanent address
                                });
                              }),
                              _buildDropdown('Permanent Thana', selectedPerThana, perThanas, (value) {
                                setState(() {
                                  selectedPerThana = value;
                                });
                              }),
                            ],
                          ),
                        ),
                      ),

                      // Office Address Tab
                      Container(
                        padding: const EdgeInsets.all(16.0), // Add padding if needed
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              _buildTextField(_officeNameController, 'Office Name', officeName),
                              _buildTextField(_offAddrController, 'Office Address', officeAddress),
                              _buildTextField(_offPhoneController, 'Office Phone', officePhone),
                              _buildTextField(_offEmailController, 'Office Email', officeEmail),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),


                const SizedBox(height: 20),

                // Save Button
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: _updateUserData,
                  child: const Text('Save Changes'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }



  // Helper method to fix the Base64 string before decoding
  String fixBase64(String base64) {
    return base64.replaceAll('data:image/png;base64,', '').replaceAll(' ', '+');
  }




  Widget _buildTextField(TextEditingController controller, String labelText, String? initialValue) {
    controller.text = initialValue ?? '';
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0), // Space between TextFields
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: Color(0xFFC0392B)),
          // Label color
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0), // Circular border
            borderSide: const BorderSide(color: Color(0xFF1A5276)),
            // Border color
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0), // Circular border when focused
            borderSide: const BorderSide(color: Color(0xFF1A5276)),
            // Focused border color
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0), // Circular border when enabled
            borderSide: const BorderSide(color: Color(0xFF1A5276)),
            // Enabled border color
          ),
        ),
      ),
    );
  }
}


Widget _buildDropdown(String label, String? selectedValue, List<dynamic> items, Function(String?) onChanged) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16.0),
    child: DropdownButtonFormField<String>(
      value: selectedValue,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
      ),
      items: items.map<DropdownMenuItem<String>>((item) {
        return DropdownMenuItem<String>(
          value: item['DIV_CODE'] ?? item['DIST_CODE'] ?? item['THANA_CODE'],
          child: Text(item['DIV_DESC'] ?? item['DIST_DESC'] ?? item['THANA_DESC']),
        );
      }).toList(),
      onChanged: onChanged,
    ),
  );
}



Widget _buildDropdownProf(String label, String? selectedValue, List<dynamic> items, Function(String?) onChanged) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16.0),
    child: DropdownButtonFormField<String>(
      value: selectedValue, // Allow null here if no initial value is selected
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
      ),
      items: items.map<DropdownMenuItem<String>>((item) {
        // Handle nulls safely
        final value = item['DIV_CODE'] ?? item['DIST_CODE'] ?? item['THANA_CODE'] ?? item['PROF_CODE'];
        final description = item['DIV_DESC'] ?? item['DIST_DESC'] ?? item['THANA_DESC'] ?? item['PROF_DESC'];

        return DropdownMenuItem<String>(
          value: value, // This can be null if no code is found
          child: Text(description ?? ''), // Use empty string if description is null
        );
      }).toList(),
      onChanged: onChanged, // Allow null handling here too
    ),
  );
}


