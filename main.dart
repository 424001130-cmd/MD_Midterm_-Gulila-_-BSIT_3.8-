import 'dart:io';

mixin TimestampMixin {
  final String dateCreated = DateTime.now().toString().substring(0, 16);
}

abstract class CenterRecord with TimestampMixin {
  final int id;
  final String name;
  CenterRecord(this.id, this.name);
  void displayDetails();
}

class LearningResource extends CenterRecord {
  final String _category;
  int _availableCopies;

  LearningResource(super.id, super.name, this._category, this._availableCopies);

  int get availableCopies => _availableCopies;
  bool borrowResource() => _availableCopies > 0 ? (_availableCopies--) > -1 : false;
  void returnResource() => _availableCopies++;

  @override
  void displayDetails() => print(
      '  * [RESOURCE]    ID: ${id.toString().padRight(4)} | Title: ${name.padRight(16)} | Category: ${_category.padRight(10)} | Copies: ${_availableCopies.toString().padRight(3)} | Added: $dateCreated');
}

class Participant extends CenterRecord {
  final String _email;
  int _borrowedResources = 0;

  Participant(super.id, super.name, this._email);

  int get borrowedResources => _borrowedResources;
  void borrowItem() => _borrowedResources++;
  void returnItem() => _borrowedResources > 0 ? _borrowedResources-- : null;

  @override
  void displayDetails() => print(
      '  * [PARTICIPANT] ID: ${id.toString().padRight(4)} | Name:  ${name.padRight(16)} | Email:    ${_email.padRight(19)} | Borrows: ${_borrowedResources.toString().padRight(3)} | Added: $dateCreated');
}

final Map<int, LearningResource> resourceMap = {};
final Map<int, Participant> participantMap = {};

String getInput(String msg) {
  stdout.write('  > $msg');
  return stdin.readLineSync()?.trim() ?? '';
}

int getInteger(String msg) {
  while (true) {
    int? n = int.tryParse(getInput(msg));
    if (n != null && n >= 0) return n;
    print('Input Error!: Please enter a valid non-negative integer.');
  }
}

void printSectionHeader(String title) {
  print('\n************************************************************');
  print('  :: $title ::');
  print('************************************************************');
}

void addResource() {
  printSectionHeader('ADD LEARNING RESOURCE');
  int id = getInteger('Resource ID: ');
  if (resourceMap.containsKey(id)) return print('Error!: Resource ID already exists.');

  resourceMap[id] = LearningResource(
    id,
    getInput('Resource Title: '),
    getInput('Category: '),
    getInteger('Available Copies: '),
  );
  print('\n  [successfully Registered] Resource successfully registered.');
}

void registerParticipant() {
  printSectionHeader('REGISTER PARTICIPANT');
  int id = getInteger('Participant ID: ');
  if (participantMap.containsKey(id)) return print('Error!: Participant ID already exists.');

  String name = getInput('Full Name: ');
  String email = getInput('Email Address: ');
  if (!email.contains('@') || !email.contains('.')) return print('Error!: Invalid email format.');

  participantMap[id] = Participant(id, name, email);
  print('\n  [+] Participant successfully registered.');
}

void viewRecords() {
  printSectionHeader('SYSTEM RECORDS DISPLAY');
  if (resourceMap.isEmpty && participantMap.isEmpty) {
    print('  [i] No records currently stored in the system.');
    return;
  }

  for (var r in [...resourceMap.values, ...participantMap.values]) {
    r.displayDetails();
  }
  print('--------------------------------------------------------------------------------');
  print('  Summary: ${resourceMap.length} Resource(s) | ${participantMap.length} Participant(s)');
}

void processTransaction(bool isBorrow) {
  printSectionHeader(isBorrow ? 'PROCESS BORROW TRANSACTION' : 'PROCESS RETURN TRANSACTION');
  if (resourceMap.isEmpty || participantMap.isEmpty) {
    print('  [i] Action requires at least one registered resource and participant.');
    return;
  }

  var p = participantMap[getInteger('Participant ID: ')];
  if (p == null) return print('Error!: Participant record not found.');

  var r = resourceMap[getInteger('Resource ID: ')];
  if (r == null) return print('Error!: Resource record not found.');

  if (isBorrow) {
    if (r.borrowResource()) {
      p.borrowItem();
      print('\n  [Success] Success: ${p.name} borrowed "${r.name}".');
    } else {
      print('    [Failed] Transaction Failed: No available copies left.');
    }
  } else {
    if (p.borrowedResources <= 0) return print('    [!] Error: Participant has no active borrows.');
    p.returnItem();
    r.returnResource();
    print('\n  [+] Success: ${p.name} returned "${r.name}".');
  }
}

void main() {
  bool running = true;
  print('\n*************************************************************************');
  print('         COMMUNITY LEARNING CENTER MANAGEMENT SYSTEM');
  print('*************************************************************************');

  while (running) {
    print('\n----------------------------- MAIN MENU ---------------------------');
    print('|  [1] Add Resource              |  [4] Borrow Resource           |');
    print('|  [2] Register Participant      |  [5] Return Resource           |');
    print('|  [3] View All Records          |  [6] Exit System               |');
    print('-------------------------------------------------------------------');

    switch (getInput('Select Option (1-6): ')) {
      case '1': addResource(); break;
      case '2': registerParticipant(); break;
      case '3': viewRecords(); break;
      case '4': processTransaction(true); break;
      case '5': processTransaction(false); break;
      case '6': 
        running = false; 
        print('\n================================================================================');
        print('  System execution terminated. Goodbye!');
        print('================================================================================\n');
        break;
      default: print('    [!] Invalid selection. Please enter a choice from 1 to 6.');
    }
  }
}