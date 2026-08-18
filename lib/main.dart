import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PasswordGeneratorApp());
}

class PasswordGeneratorApp extends StatelessWidget {
  const PasswordGeneratorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Password Generator',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F7FB),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
        ),
      ),
      home: const PasswordGeneratorScreen(),
    );
  }
}

class PasswordGeneratorScreen extends StatefulWidget {
  const PasswordGeneratorScreen({super.key});

  @override
  State<PasswordGeneratorScreen> createState() =>
      _PasswordGeneratorScreenState();
}

class _PasswordGeneratorScreenState
    extends State<PasswordGeneratorScreen> {
  String password = 'Generate your password';

  double length = 16;

  bool uppercase = true;
  bool lowercase = true;
  bool numbers = true;
  bool symbols = true;

  final Random random = Random();

  static const String upperChars =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

  static const String lowerChars =
      'abcdefghijklmnopqrstuvwxyz';

  static const String numberChars =
      '0123456789';

  static const String symbolChars =
      '!@#\$%^&*()_+-=[]{}|;:,.<>?';

  void generatePassword() {
    String characters = '';

    if (uppercase) {
      characters += upperChars;
    }

    if (lowercase) {
      characters += lowerChars;
    }

    if (numbers) {
      characters += numberChars;
    }

    if (symbols) {
      characters += symbolChars;
    }

    if (characters.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Select at least one character type.',
          ),
        ),
      );
      return;
    }

    final result = StringBuffer();

    for (int i = 0; i < length.round(); i++) {
      result.write(
        characters[random.nextInt(characters.length)],
      );
    }

    setState(() {
      password = result.toString();
    });
  }

  Future<void> copyPassword() async {
    if (password == 'Generate your password') {
      generatePassword();
      return;
    }

    await Clipboard.setData(
      ClipboardData(text: password),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Password copied!'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void resetOptions() {
    setState(() {
      length = 16;
      uppercase = true;
      lowercase = true;
      numbers = true;
      symbols = true;
      password = 'Generate your password';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            20,
            24,
            20,
            30,
          ),
          children: [
            // HEADER
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDE9FE),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(
                    Icons.lock_rounded,
                    color: Color(0xFF6366F1),
                    size: 25,
                  ),
                ),
                const SizedBox(width: 13),
                const Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Password Generator',
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF172033),
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Create a strong password',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF8993A1),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // PASSWORD CARD
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF6366F1),
                    Color(0xFF8B5CF6),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  const Text(
                    'YOUR PASSWORD',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),

                  const SizedBox(height: 14),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 15,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            password,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        IconButton(
                          onPressed: copyPassword,
                          color: Colors.white,
                          tooltip: 'Copy',
                          icon: const Icon(
                            Icons.copy_rounded,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: generatePassword,
                      icon: const Icon(
                        Icons.refresh_rounded,
                      ),
                      label: const Text(
                        'Generate Password',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor:
                        const Color(0xFF6366F1),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // LENGTH
            _sectionTitle('Password Length'),

            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.fromLTRB(
                16,
                13,
                16,
                10,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text(
                        'Length',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding:
                        const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEDE9FE),
                          borderRadius:
                          BorderRadius.circular(9),
                        ),
                        child: Text(
                          '${length.round()}',
                          style: const TextStyle(
                            color: Color(0xFF6366F1),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),

                  Slider(
                    value: length,
                    min: 6,
                    max: 32,
                    divisions: 26,
                    activeColor:
                    const Color(0xFF6366F1),
                    onChanged: (value) {
                      setState(() {
                        length = value;
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // CHARACTER OPTIONS
            _sectionTitle('Character Options'),

            const SizedBox(height: 8),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  _option(
                    icon: Icons.text_fields_rounded,
                    title: 'Uppercase Letters',
                    subtitle: 'A-Z',
                    value: uppercase,
                    onChanged: (value) {
                      setState(() {
                        uppercase = value;
                      });
                    },
                  ),

                  _divider(),

                  _option(
                    icon: Icons.text_format_rounded,
                    title: 'Lowercase Letters',
                    subtitle: 'a-z',
                    value: lowercase,
                    onChanged: (value) {
                      setState(() {
                        lowercase = value;
                      });
                    },
                  ),

                  _divider(),

                  _option(
                    icon: Icons.numbers_rounded,
                    title: 'Numbers',
                    subtitle: '0-9',
                    value: numbers,
                    onChanged: (value) {
                      setState(() {
                        numbers = value;
                      });
                    },
                  ),

                  _divider(),

                  _option(
                    icon: Icons.alternate_email_rounded,
                    title: 'Special Characters',
                    subtitle: '! @ # \$ %',
                    value: symbols,
                    onChanged: (value) {
                      setState(() {
                        symbols = value;
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            // RESET
            SizedBox(
              height: 48,
              child: OutlinedButton.icon(
                onPressed: resetOptions,
                icon: const Icon(
                  Icons.restart_alt_rounded,
                  size: 19,
                ),
                label: const Text(
                  'Reset Options',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor:
                  const Color(0xFF6366F1),
                  side: const BorderSide(
                    color: Color(0xFFD9D7F8),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(14),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            const Center(
              child: Text(
                'Passwords are generated locally on your device.',
                style: TextStyle(
                  fontSize: 10,
                  color: Color(0xFF9AA3AE),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: Color(0xFF172033),
      ),
    );
  }

  Widget _divider() {
    return const Divider(
      height: 1,
      indent: 70,
      endIndent: 15,
      color: Color(0xFFF0F1F4),
    );
  }

  Widget _option({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 3,
      ),
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: const Color(0xFFEDE9FE),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: const Color(0xFF6366F1),
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 10,
          color: Color(0xFF8993A1),
        ),
      ),
      trailing: Switch(
        value: value,
        activeThumbColor:
        const Color(0xFF6366F1),
        onChanged: onChanged,
      ),
    );
  }
}