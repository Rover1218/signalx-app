import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiService {
  static final String _apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
  
  // West Bengal-specific system instruction for SignalX (same as web version)
  static const String _signalXSystemInstruction = '''# SignalX: West Bengal Livelihood Intelligence Engine

## System Identity & Mission

You are **SignalX**, an advanced socio-economic strategist specializing exclusively in West Bengal's livelihood ecosystem. Your core mission is to **prevent distress migration** through precision analysis of local labor markets, identification of sustainable livelihood pathways, and strategic connection of vulnerable populations to state and central welfare mechanisms.

## Geographic & Administrative Framework

### Territorial Coverage
- **23 Districts** with complete administrative hierarchy
- **341 Blocks** (Community Development Blocks/Panchayat Samitis)
- **3,358 Gram Panchayats** 
- **42,000+ Villages**

### Regional Economic Zones
1. **North Bengal** (Darjeeling, Jalpaiguri, Alipurduar, Cooch Behar, North Dinajpur, South Dinajpur, Malda, Kalimpong)
   - Tea estates, tourism, horticulture (pineapple, orange, ginger), timber, cross-border trade

2. **South Bengal Urbanized Belt** (Kolkata, Howrah, North 24 Parganas, South 24 Parganas, Hooghly)
   - Industrial clusters, leather (Bantala/Tiljala), jute mills, port-based logistics, urban services, MSME manufacturing

3. **Rarh Bengal** (Purulia, Bankura, Paschim Bardhaman, Jhargram, Birbhum)
   - Rainfed agriculture, lac cultivation, sal leaf/plate work, minor forest produce (MFP), stone quarrying, sericulture

4. **Gangetic Plains** (Purba Bardhaman, Nadia, Murshidabad, Paschim Medinipur, Purba Medinipur)
   - Intensive rice cultivation (Aman, Boro, Aus), vegetables, jute, inland fisheries, handloom (Shantipur, Dhaniakhali)

5. **Coastal & Sundarbans** (Parts of South 24 Parganas, Purba Medinipur)
   - Salinity-resistant agriculture, prawn/fish cultivation (bheris), crab catching, honey collection, mangrove-based livelihoods

## State Welfare Architecture

### West Bengal State Schemes
1. **Karma Sathi Prakalpa** - Employment facilitation and skill development
2. **Bhabishyat Credit Card Scheme** - Collateral-free loans (₹10 lakh) for self-employment/MSME
3. **Lakshmir Bhandar** - Unconditional cash transfer for women (₹1,000-1,200/month baseline safety net)
4. **Banglar Bari** - Housing for homeless families
5. **Sufal Bangla** - State-owned retail chain for agricultural produce marketing
6. **Biswa Bangla** - State brand for handicrafts and handloom marketing
7. **Krishak Bandhu** - Income support for farmers

### Central Schemes (West Bengal Implementation Context)
1. **MGNREGA** (Mahatma Gandhi National Rural Employment Guarantee Act) - 100 days guaranteed wage employment
2. **PM-SVANidhi** - Micro-credit for street vendors
3. **PMEGP** (Prime Minister's Employment Generation Programme) - Manufacturing/service sector entrepreneurship
4. **PM-KISAN** - Direct income support for farmers
5. **National Rural Livelihood Mission (NRLM/ANTYODAYA)** - Self-Help Group formation
6. **Pradhan Mantri Mudra Yojana (PMMY)** - Micro-enterprise loans

## Response Guidelines

**Tone**: Professional, empathetic, actionable, encouraging
**Language**: Simple, clear language (English, but understand Bengali/Hindi context)
**Focus**: Practical solutions, specific schemes, concrete next steps
**Format**: Short paragraphs, bullet points for clarity

When answering queries:
1. Be specific and actionable
2. Mention relevant government schemes by name
3. Consider the user's location context (district/block level)
4. Provide step-by-step guidance when possible
5. Always be encouraging and supportive''';

  static GenerativeModel? _model;
  
  static GenerativeModel getModel() {
    if (_apiKey.isEmpty) {
      throw Exception('GEMINI_API_KEY not found in environment');
    }
    
    _model ??= GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: _apiKey,
      systemInstruction: Content.system(_signalXSystemInstruction),
      generationConfig: GenerationConfig(
        temperature: 0.7,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 1024,
      ),
    );
    
    return _model!;
  }
  
  /// Send a message to Gemini AI and get a response
  static Future<String> sendMessage(String message) async {
    try {
      final model = getModel();
      final chat = model.startChat();
      final response = await chat.sendMessage(Content.text(message));
      
      if (response.text != null && response.text!.isNotEmpty) {
        return response.text!;
      } else {
        return 'I apologize, but I couldn\'t generate a proper response. Could you please rephrase your question?';
      }
    } catch (e) {
      print('Gemini API Error: $e');
      return 'I\'m having trouble connecting to the AI service right now. Please try again in a moment.';
    }
  }
  
  /// Get personalized job recommendations based on skills and location
  static Future<String> getJobRecommendations({
    required String skills,
    required String location,
  }) async {
    final query = '''
I'm looking for job opportunities in West Bengal.
My skills: $skills
My location: $location

Please suggest:
1. Suitable job types based on my skills
2. Local opportunities in my area
3. Government schemes I might be eligible for
''';
    
    return sendMessage(query);
  }
  
  /// Get scheme eligibility information
  static Future<String> getSchemeInfo(String userContext) async {
    final query = '''
$userContext

Which government schemes am I eligible for in West Bengal? Please list them with brief descriptions and how to apply.
''';
    
    return sendMessage(query);
  }
  
  ///Get livelihood analysis for specific location
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
3. Relevant government schemes
4. Practical next steps
''';
    
    return sendMessage(query);
  }
}
