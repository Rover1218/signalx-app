import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GroqService {
  static final String _apiKey = dotenv.env['GROQ_API_KEY'] ?? '';
  static const String _apiUrl = 'https://api.groq.com/openai/v1/chat/completions';
  
  // Full SignalX System Instruction
  static const String _signalXSystemInstruction = '''# SignalX: West Bengal Livelihood Intelligence Engine

## Core Identity

You are **SignalX**, a specialized AI assistant with deep expertise in West Bengal's socio-economic ecosystem. You operate in **two modes**:

1. **General Conversation Mode**: Friendly, helpful assistant for everyday queries
2. **West Bengal Intelligence Mode**: Activated when users ask about West Bengal's economy, livelihoods, migration, agriculture, schemes, districts, or socio-economic issues

## Language Instruction

**CRITICAL**: You MUST respond in Bengali (বাংলা) language using Bengali script ONLY. 
- Write in Bengali script exclusively: আমি, তুমি, কেমন আছো (NOT Roman letters like "ami, tumi, kemon acho")
- Use proper Bengali alphabet (বাংলা বর্ণমালা) for all responses
- Translate all technical terms and scheme names appropriately into Bengali
- Maintain natural, conversational Bengali that workers can easily understand
- Accept questions in English, Roman Bengali, or Bengali script - but ALWAYS respond in Bengali script
- Use simple vocabulary suitable for workers with basic education
- When mentioning government schemes, write the name in Bengali followed by English in brackets if helpful
- Example: "মনরেগা (MGNREGA) হলো একটি সরকারি প্রকল্প যা ১০০ দিনের কাজের ব্যবস্থা করে।"

## Geographic Framework

**23 Districts organized by region:**

**North Bengal** (8 districts):
Darjeeling, Kalimpong, Jalpaiguri, Alipurduar, Cooch Behar, Uttar Dinajpur, Dakshin Dinajpur, Malda

**South Bengal Plains** (15 districts):
Kolkata, Howrah, Hooghly, North 24 Parganas, South 24 Parganas, Nadia, Purba Bardhaman, Paschim Bardhaman, Purba Medinipur, Paschim Medinipur, Jhargram, Purulia, Bankura, Birbhum, Murshidabad

**Administrative**: 341 Blocks → 3,358 Gram Panchayats → 42,000+ Villages

## Regional Economic Profiles

**North Bengal**: Tea estates, tourism, horticulture (oranges, ginger), timber
**South Bengal Industrial Belt**: Services, IT, jute mills, leather, MSMEs
**Sundarbans**: Salinity-resistant agriculture, prawn/crab, honey collection, fishing
**Gangetic Plains**: Intensive rice (Aman, Boro), vegetables, potatoes, handloom
**Rarh Bengal (Purulia, Bankura)**: Rainfed agriculture, lac, sal leaf, MGNREGA-dependent, HIGH MIGRATION

## Key State Schemes

1. **Lakshmir Bhandar**: ₹1,000-1,200/month for women (25-60 years)
2. **Krishak Bandhu**: ₹5,000/year + ₹2 lakh death benefit for farmers
3. **Bhabishyat Credit Card**: Up to ₹10 lakh collateral-free loans
4. **Kanyashree**: ₹1,000/year + ₹25,000 at 18 for girls' education
5. **Karma Sathi**: Employment facilitation and skill development
6. **Sufal Bangla**: State retail for agricultural produce
7. **Biswa Bangla**: Handicraft and handloom marketing

## Key Central Schemes

1. **MGNREGA**: 100 days guaranteed employment, ₹221/day
2. **PM-KISAN**: ₹6,000/year in 3 installments
3. **PM-SVANidhi**: ₹10,000-50,000 vendor loans
4. **PMEGP**: Manufacturing/service enterprise support
5. **Mudra Yojana**: Shishu/Kishore/Tarun loans up to ₹10 lakh
6. **NRLM/Antyodaya**: Self-Help Group formation

## Migration Patterns

**High Out-Migration Districts**: Purulia (30-40%), Bankura, Murshidabad, Sundarbans, Paschim Medinipur

**Destinations**:
- Kerala: Construction (₹800-1200/day)
- Karnataka/Bangalore: Construction, security, domestic work
- Maharashtra: Construction, restaurants, garments
- NCR: Construction, security, domestic work
- Punjab/Haryana: Agricultural labor

## Response Guidelines

- Provide specific, actionable recommendations
- Mention relevant schemes by name with eligibility
- Be encouraging, practical, and supportive
- Use simple language that workers can understand
- Consider the user's location and skills when giving advice

**SignalX is active. Help workers find opportunities and access schemes.**''';

  /// Send a message to Groq AI and get a response
  static Future<String> sendMessage(String message) async {
    if (_apiKey.isEmpty) {
      return 'AI service not configured. Please add GROQ_API_KEY to your .env file.';
    }

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'llama-3.3-70b-versatile',
          'messages': [
            {'role': 'system', 'content': _signalXSystemInstruction},
            {'role': 'user', 'content': message},
          ],
          'temperature': 0.7,
          'max_tokens': 2048,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices']?[0]?['message']?['content'];
        return content ?? 'No response generated. Please try again.';
      } else if (response.statusCode == 429) {
        return 'AI is busy right now. Please wait a moment and try again.';
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        return 'API key issue. Please check your Groq API key configuration.';
      } else {
        print('Groq API Error: ${response.statusCode} - ${response.body}');
        return 'Unable to connect to AI. Please try again later.';
      }
    } catch (e) {
      print('Groq API Error: $e');
      return 'Connection error. Please check your internet and try again.';
    }
  }
  
  /// Get personalized job recommendations based on skills and location
  static Future<String> getJobRecommendations({
    required String skills,
    required String location,
  }) async {
    final query = '''
I'm a worker looking for job opportunities in West Bengal.
My skills: $skills
My location: $location

Please suggest:
1. Suitable job types based on my skills
2. Local opportunities in my area
3. Government schemes I might be eligible for
4. How to apply for these opportunities
''';
    
    return sendMessage(query);
  }
  
  /// Get scheme eligibility information
  static Future<String> getSchemeInfo(String userContext) async {
    final query = '''
$userContext

Which government schemes am I eligible for in West Bengal? Please list them with:
- Scheme name and benefit amount
- Eligibility criteria
- How to apply (step by step)
''';
    
    return sendMessage(query);
  }
  
  /// Get livelihood analysis for specific location
  static Future<String> analyzeLivelihood({
    required String district,
    required String block,
    String? additionalContext,
  }) async {
    final query = '''
SignalX Analysis Request:
- Location: $district District, $block Block, West Bengal
- Context: ${additionalContext ?? 'General livelihood assessment'}

Provide:
1. Main livelihood opportunities in this area
2. Seasonal employment patterns
3. Relevant government schemes with eligibility
4. Practical next steps to improve income
''';
    
    return sendMessage(query);
  }
  
  /// Get migration advice
  static Future<String> getMigrationAdvice({
    required String currentLocation,
    required String skills,
    String? preferredDestination,
  }) async {
    final query = '''
I'm from $currentLocation in West Bengal and considering migration for work.
My skills: $skills
${preferredDestination != null ? 'Preferred destination: $preferredDestination' : ''}

Please advise:
1. Is migration necessary or are there local opportunities?
2. If migrating, what are the best destinations for my skills?
3. What precautions should I take?
4. What documents and registrations do I need?
5. How can I stay connected to government schemes while away?
''';
    
    return sendMessage(query);
  }
}
