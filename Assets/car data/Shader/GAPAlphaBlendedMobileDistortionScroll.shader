Shader "GAP/AlphaBlendedMobileDistortionScroll" {
	Properties {
		_TintColor ("Color", Vector) = (1,0.6235296,0.1470588,1)
		_ColorMultiplier ("Color Multiplier", Range(0, 10)) = 1
		_MainTextUSpeed ("MainText U Speed", Float) = 0
		_MainTextVSpeed ("MainText V Speed", Float) = 0
		_MainTex ("MainTex", 2D) = "white" {}
		[MaterialToggle] _DistortMainTexture ("Distort Main Texture", Float) = 0
		_GradientPower ("Gradient Power", Range(0, 50)) = 0
		_GradientUSpeed ("Gradient U Speed", Float) = 0.1
		_GradientVSpeed ("Gradient V Speed", Float) = 0.1
		_Gradient ("Gradient", 2D) = "white" {}
		_NoiseAmount ("Noise Amount", Range(-1, 1)) = 0.1
		_DistortionUSpeed ("Distortion U Speed", Float) = 0.1
		_DistortionVSpeed ("Distortion V Speed", Float) = 0.1
		_Distortion ("Distortion", 2D) = "white" {}
		_MainTexMask ("MainTexMask", 2D) = "white" {}
		_DoubleSided ("DoubleSided", Float) = 1
		[HideInInspector] _Cutoff ("Alpha cutoff", Range(0, 1)) = 0.5
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
		Pass {
			Name "FORWARD"
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "PreviewType" = "Plane" "QUEUE" = "Transparent" "RenderType" = "Transparent" "SHADOWSUPPORT" = "true" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			ZWrite Off
			Cull Off
			GpuProgramID 17788
			Program "vp" {
				SubProgram "gles hw_tier00 " {
					Keywords { "DIRECTIONAL" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					attribute highp vec4 in_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 100
					
					#ifdef GL_FRAGMENT_PRECISION_HIGH
					    precision highp float;
					#else
					    precision mediump float;
					#endif
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _Gradient;
					uniform lowp sampler2D _MainTexMask;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					lowp float u_xlat10_9;
					const int BITWISE_BIT_COUNT = 32;
					int op_modi(int x, int y) { return x - y * (x / y); }
					ivec2 op_modi(ivec2 a, ivec2 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); return a; }
					ivec3 op_modi(ivec3 a, ivec3 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); return a; }
					ivec4 op_modi(ivec4 a, ivec4 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); a.w = op_modi(a.w, b.w); return a; }
					
					int op_and(int a, int b) { int result = 0; int n = 1; for (int i = 0; i < BITWISE_BIT_COUNT; i++) { if ((op_modi(a, 2) != 0) && (op_modi(b, 2) != 0)) { result += n; } a = a / 2; b = b / 2; n = n * 2; if (!(a > 0 && b > 0)) { break; } } return result; }
					ivec2 op_and(ivec2 a, ivec2 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); return a; }
					ivec3 op_and(ivec3 a, ivec3 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); return a; }
					ivec4 op_and(ivec4 a, ivec4 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); a.w = op_and(a.w, b.w); return a; }
					
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat10_0.x = texture2D(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat10_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat10_1 = texture2D(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_0.xyz = texture2D(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat10_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat10_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat10_9 = texture2D(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat10_9) * u_xlat0.xyz;
					    u_xlat2.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat10_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    SV_Target0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat10_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat10_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier01 " {
					Keywords { "DIRECTIONAL" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					attribute highp vec4 in_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 100
					
					#ifdef GL_FRAGMENT_PRECISION_HIGH
					    precision highp float;
					#else
					    precision mediump float;
					#endif
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _Gradient;
					uniform lowp sampler2D _MainTexMask;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					lowp float u_xlat10_9;
					const int BITWISE_BIT_COUNT = 32;
					int op_modi(int x, int y) { return x - y * (x / y); }
					ivec2 op_modi(ivec2 a, ivec2 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); return a; }
					ivec3 op_modi(ivec3 a, ivec3 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); return a; }
					ivec4 op_modi(ivec4 a, ivec4 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); a.w = op_modi(a.w, b.w); return a; }
					
					int op_and(int a, int b) { int result = 0; int n = 1; for (int i = 0; i < BITWISE_BIT_COUNT; i++) { if ((op_modi(a, 2) != 0) && (op_modi(b, 2) != 0)) { result += n; } a = a / 2; b = b / 2; n = n * 2; if (!(a > 0 && b > 0)) { break; } } return result; }
					ivec2 op_and(ivec2 a, ivec2 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); return a; }
					ivec3 op_and(ivec3 a, ivec3 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); return a; }
					ivec4 op_and(ivec4 a, ivec4 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); a.w = op_and(a.w, b.w); return a; }
					
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat10_0.x = texture2D(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat10_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat10_1 = texture2D(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_0.xyz = texture2D(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat10_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat10_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat10_9 = texture2D(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat10_9) * u_xlat0.xyz;
					    u_xlat2.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat10_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    SV_Target0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat10_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat10_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier02 " {
					Keywords { "DIRECTIONAL" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					attribute highp vec4 in_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 100
					
					#ifdef GL_FRAGMENT_PRECISION_HIGH
					    precision highp float;
					#else
					    precision mediump float;
					#endif
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _Gradient;
					uniform lowp sampler2D _MainTexMask;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					lowp float u_xlat10_9;
					const int BITWISE_BIT_COUNT = 32;
					int op_modi(int x, int y) { return x - y * (x / y); }
					ivec2 op_modi(ivec2 a, ivec2 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); return a; }
					ivec3 op_modi(ivec3 a, ivec3 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); return a; }
					ivec4 op_modi(ivec4 a, ivec4 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); a.w = op_modi(a.w, b.w); return a; }
					
					int op_and(int a, int b) { int result = 0; int n = 1; for (int i = 0; i < BITWISE_BIT_COUNT; i++) { if ((op_modi(a, 2) != 0) && (op_modi(b, 2) != 0)) { result += n; } a = a / 2; b = b / 2; n = n * 2; if (!(a > 0 && b > 0)) { break; } } return result; }
					ivec2 op_and(ivec2 a, ivec2 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); return a; }
					ivec3 op_and(ivec3 a, ivec3 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); return a; }
					ivec4 op_and(ivec4 a, ivec4 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); a.w = op_and(a.w, b.w); return a; }
					
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat10_0.x = texture2D(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat10_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat10_1 = texture2D(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_0.xyz = texture2D(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat10_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat10_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat10_9 = texture2D(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat10_9) * u_xlat0.xyz;
					    u_xlat2.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat10_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    SV_Target0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat10_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat10_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier00 " {
					Keywords { "DIRECTIONAL" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					in highp vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _Gradient;
					uniform mediump sampler2D _MainTexMask;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					mediump float u_xlat16_9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat16_0.x = texture(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat16_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat16_1 = texture(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_0.xyz = texture(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat16_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat16_9 = texture(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat16_9) * u_xlat0.xyz;
					    u_xlat2.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat16_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    SV_Target0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat16_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat16_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier01 " {
					Keywords { "DIRECTIONAL" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					in highp vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _Gradient;
					uniform mediump sampler2D _MainTexMask;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					mediump float u_xlat16_9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat16_0.x = texture(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat16_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat16_1 = texture(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_0.xyz = texture(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat16_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat16_9 = texture(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat16_9) * u_xlat0.xyz;
					    u_xlat2.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat16_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    SV_Target0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat16_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat16_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier02 " {
					Keywords { "DIRECTIONAL" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					in highp vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _Gradient;
					uniform mediump sampler2D _MainTexMask;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					mediump float u_xlat16_9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat16_0.x = texture(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat16_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat16_1 = texture(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_0.xyz = texture(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat16_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat16_9 = texture(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat16_9) * u_xlat0.xyz;
					    u_xlat2.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat16_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    SV_Target0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat16_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat16_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier00 " {
					Keywords { "DIRECTIONAL" "LIGHTPROBE_SH" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					attribute highp vec4 in_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 100
					
					#ifdef GL_FRAGMENT_PRECISION_HIGH
					    precision highp float;
					#else
					    precision mediump float;
					#endif
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _Gradient;
					uniform lowp sampler2D _MainTexMask;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					lowp float u_xlat10_9;
					const int BITWISE_BIT_COUNT = 32;
					int op_modi(int x, int y) { return x - y * (x / y); }
					ivec2 op_modi(ivec2 a, ivec2 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); return a; }
					ivec3 op_modi(ivec3 a, ivec3 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); return a; }
					ivec4 op_modi(ivec4 a, ivec4 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); a.w = op_modi(a.w, b.w); return a; }
					
					int op_and(int a, int b) { int result = 0; int n = 1; for (int i = 0; i < BITWISE_BIT_COUNT; i++) { if ((op_modi(a, 2) != 0) && (op_modi(b, 2) != 0)) { result += n; } a = a / 2; b = b / 2; n = n * 2; if (!(a > 0 && b > 0)) { break; } } return result; }
					ivec2 op_and(ivec2 a, ivec2 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); return a; }
					ivec3 op_and(ivec3 a, ivec3 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); return a; }
					ivec4 op_and(ivec4 a, ivec4 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); a.w = op_and(a.w, b.w); return a; }
					
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat10_0.x = texture2D(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat10_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat10_1 = texture2D(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_0.xyz = texture2D(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat10_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat10_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat10_9 = texture2D(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat10_9) * u_xlat0.xyz;
					    u_xlat2.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat10_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    SV_Target0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat10_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat10_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier01 " {
					Keywords { "DIRECTIONAL" "LIGHTPROBE_SH" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					attribute highp vec4 in_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 100
					
					#ifdef GL_FRAGMENT_PRECISION_HIGH
					    precision highp float;
					#else
					    precision mediump float;
					#endif
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _Gradient;
					uniform lowp sampler2D _MainTexMask;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					lowp float u_xlat10_9;
					const int BITWISE_BIT_COUNT = 32;
					int op_modi(int x, int y) { return x - y * (x / y); }
					ivec2 op_modi(ivec2 a, ivec2 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); return a; }
					ivec3 op_modi(ivec3 a, ivec3 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); return a; }
					ivec4 op_modi(ivec4 a, ivec4 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); a.w = op_modi(a.w, b.w); return a; }
					
					int op_and(int a, int b) { int result = 0; int n = 1; for (int i = 0; i < BITWISE_BIT_COUNT; i++) { if ((op_modi(a, 2) != 0) && (op_modi(b, 2) != 0)) { result += n; } a = a / 2; b = b / 2; n = n * 2; if (!(a > 0 && b > 0)) { break; } } return result; }
					ivec2 op_and(ivec2 a, ivec2 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); return a; }
					ivec3 op_and(ivec3 a, ivec3 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); return a; }
					ivec4 op_and(ivec4 a, ivec4 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); a.w = op_and(a.w, b.w); return a; }
					
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat10_0.x = texture2D(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat10_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat10_1 = texture2D(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_0.xyz = texture2D(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat10_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat10_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat10_9 = texture2D(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat10_9) * u_xlat0.xyz;
					    u_xlat2.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat10_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    SV_Target0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat10_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat10_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier02 " {
					Keywords { "DIRECTIONAL" "LIGHTPROBE_SH" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					attribute highp vec4 in_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 100
					
					#ifdef GL_FRAGMENT_PRECISION_HIGH
					    precision highp float;
					#else
					    precision mediump float;
					#endif
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _Gradient;
					uniform lowp sampler2D _MainTexMask;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					lowp float u_xlat10_9;
					const int BITWISE_BIT_COUNT = 32;
					int op_modi(int x, int y) { return x - y * (x / y); }
					ivec2 op_modi(ivec2 a, ivec2 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); return a; }
					ivec3 op_modi(ivec3 a, ivec3 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); return a; }
					ivec4 op_modi(ivec4 a, ivec4 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); a.w = op_modi(a.w, b.w); return a; }
					
					int op_and(int a, int b) { int result = 0; int n = 1; for (int i = 0; i < BITWISE_BIT_COUNT; i++) { if ((op_modi(a, 2) != 0) && (op_modi(b, 2) != 0)) { result += n; } a = a / 2; b = b / 2; n = n * 2; if (!(a > 0 && b > 0)) { break; } } return result; }
					ivec2 op_and(ivec2 a, ivec2 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); return a; }
					ivec3 op_and(ivec3 a, ivec3 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); return a; }
					ivec4 op_and(ivec4 a, ivec4 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); a.w = op_and(a.w, b.w); return a; }
					
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat10_0.x = texture2D(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat10_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat10_1 = texture2D(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_0.xyz = texture2D(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat10_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat10_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat10_9 = texture2D(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat10_9) * u_xlat0.xyz;
					    u_xlat2.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat10_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    SV_Target0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat10_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat10_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier00 " {
					Keywords { "DIRECTIONAL" "LIGHTPROBE_SH" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					in highp vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _Gradient;
					uniform mediump sampler2D _MainTexMask;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					mediump float u_xlat16_9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat16_0.x = texture(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat16_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat16_1 = texture(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_0.xyz = texture(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat16_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat16_9 = texture(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat16_9) * u_xlat0.xyz;
					    u_xlat2.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat16_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    SV_Target0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat16_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat16_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier01 " {
					Keywords { "DIRECTIONAL" "LIGHTPROBE_SH" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					in highp vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _Gradient;
					uniform mediump sampler2D _MainTexMask;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					mediump float u_xlat16_9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat16_0.x = texture(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat16_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat16_1 = texture(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_0.xyz = texture(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat16_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat16_9 = texture(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat16_9) * u_xlat0.xyz;
					    u_xlat2.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat16_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    SV_Target0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat16_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat16_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier02 " {
					Keywords { "DIRECTIONAL" "LIGHTPROBE_SH" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					in highp vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _Gradient;
					uniform mediump sampler2D _MainTexMask;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					mediump float u_xlat16_9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat16_0.x = texture(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat16_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat16_1 = texture(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_0.xyz = texture(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat16_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat16_9 = texture(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat16_9) * u_xlat0.xyz;
					    u_xlat2.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat16_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    SV_Target0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat16_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat16_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier00 " {
					Keywords { "DIRECTIONAL" "LIGHTMAP_ON" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					attribute highp vec4 in_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 100
					
					#ifdef GL_FRAGMENT_PRECISION_HIGH
					    precision highp float;
					#else
					    precision mediump float;
					#endif
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _Gradient;
					uniform lowp sampler2D _MainTexMask;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					lowp float u_xlat10_9;
					const int BITWISE_BIT_COUNT = 32;
					int op_modi(int x, int y) { return x - y * (x / y); }
					ivec2 op_modi(ivec2 a, ivec2 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); return a; }
					ivec3 op_modi(ivec3 a, ivec3 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); return a; }
					ivec4 op_modi(ivec4 a, ivec4 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); a.w = op_modi(a.w, b.w); return a; }
					
					int op_and(int a, int b) { int result = 0; int n = 1; for (int i = 0; i < BITWISE_BIT_COUNT; i++) { if ((op_modi(a, 2) != 0) && (op_modi(b, 2) != 0)) { result += n; } a = a / 2; b = b / 2; n = n * 2; if (!(a > 0 && b > 0)) { break; } } return result; }
					ivec2 op_and(ivec2 a, ivec2 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); return a; }
					ivec3 op_and(ivec3 a, ivec3 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); return a; }
					ivec4 op_and(ivec4 a, ivec4 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); a.w = op_and(a.w, b.w); return a; }
					
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat10_0.x = texture2D(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat10_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat10_1 = texture2D(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_0.xyz = texture2D(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat10_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat10_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat10_9 = texture2D(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat10_9) * u_xlat0.xyz;
					    u_xlat2.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat10_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    SV_Target0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat10_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat10_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier01 " {
					Keywords { "DIRECTIONAL" "LIGHTMAP_ON" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					attribute highp vec4 in_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 100
					
					#ifdef GL_FRAGMENT_PRECISION_HIGH
					    precision highp float;
					#else
					    precision mediump float;
					#endif
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _Gradient;
					uniform lowp sampler2D _MainTexMask;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					lowp float u_xlat10_9;
					const int BITWISE_BIT_COUNT = 32;
					int op_modi(int x, int y) { return x - y * (x / y); }
					ivec2 op_modi(ivec2 a, ivec2 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); return a; }
					ivec3 op_modi(ivec3 a, ivec3 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); return a; }
					ivec4 op_modi(ivec4 a, ivec4 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); a.w = op_modi(a.w, b.w); return a; }
					
					int op_and(int a, int b) { int result = 0; int n = 1; for (int i = 0; i < BITWISE_BIT_COUNT; i++) { if ((op_modi(a, 2) != 0) && (op_modi(b, 2) != 0)) { result += n; } a = a / 2; b = b / 2; n = n * 2; if (!(a > 0 && b > 0)) { break; } } return result; }
					ivec2 op_and(ivec2 a, ivec2 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); return a; }
					ivec3 op_and(ivec3 a, ivec3 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); return a; }
					ivec4 op_and(ivec4 a, ivec4 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); a.w = op_and(a.w, b.w); return a; }
					
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat10_0.x = texture2D(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat10_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat10_1 = texture2D(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_0.xyz = texture2D(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat10_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat10_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat10_9 = texture2D(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat10_9) * u_xlat0.xyz;
					    u_xlat2.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat10_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    SV_Target0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat10_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat10_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier02 " {
					Keywords { "DIRECTIONAL" "LIGHTMAP_ON" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					attribute highp vec4 in_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 100
					
					#ifdef GL_FRAGMENT_PRECISION_HIGH
					    precision highp float;
					#else
					    precision mediump float;
					#endif
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _Gradient;
					uniform lowp sampler2D _MainTexMask;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					lowp float u_xlat10_9;
					const int BITWISE_BIT_COUNT = 32;
					int op_modi(int x, int y) { return x - y * (x / y); }
					ivec2 op_modi(ivec2 a, ivec2 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); return a; }
					ivec3 op_modi(ivec3 a, ivec3 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); return a; }
					ivec4 op_modi(ivec4 a, ivec4 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); a.w = op_modi(a.w, b.w); return a; }
					
					int op_and(int a, int b) { int result = 0; int n = 1; for (int i = 0; i < BITWISE_BIT_COUNT; i++) { if ((op_modi(a, 2) != 0) && (op_modi(b, 2) != 0)) { result += n; } a = a / 2; b = b / 2; n = n * 2; if (!(a > 0 && b > 0)) { break; } } return result; }
					ivec2 op_and(ivec2 a, ivec2 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); return a; }
					ivec3 op_and(ivec3 a, ivec3 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); return a; }
					ivec4 op_and(ivec4 a, ivec4 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); a.w = op_and(a.w, b.w); return a; }
					
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat10_0.x = texture2D(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat10_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat10_1 = texture2D(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_0.xyz = texture2D(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat10_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat10_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat10_9 = texture2D(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat10_9) * u_xlat0.xyz;
					    u_xlat2.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat10_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    SV_Target0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat10_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat10_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier00 " {
					Keywords { "DIRECTIONAL" "LIGHTMAP_ON" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					in highp vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _Gradient;
					uniform mediump sampler2D _MainTexMask;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					mediump float u_xlat16_9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat16_0.x = texture(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat16_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat16_1 = texture(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_0.xyz = texture(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat16_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat16_9 = texture(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat16_9) * u_xlat0.xyz;
					    u_xlat2.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat16_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    SV_Target0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat16_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat16_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier01 " {
					Keywords { "DIRECTIONAL" "LIGHTMAP_ON" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					in highp vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _Gradient;
					uniform mediump sampler2D _MainTexMask;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					mediump float u_xlat16_9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat16_0.x = texture(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat16_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat16_1 = texture(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_0.xyz = texture(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat16_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat16_9 = texture(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat16_9) * u_xlat0.xyz;
					    u_xlat2.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat16_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    SV_Target0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat16_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat16_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier02 " {
					Keywords { "DIRECTIONAL" "LIGHTMAP_ON" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					in highp vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _Gradient;
					uniform mediump sampler2D _MainTexMask;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					mediump float u_xlat16_9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat16_0.x = texture(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat16_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat16_1 = texture(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_0.xyz = texture(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat16_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat16_9 = texture(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat16_9) * u_xlat0.xyz;
					    u_xlat2.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat16_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    SV_Target0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat16_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat16_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier00 " {
					Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "LIGHTPROBE_SH" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					attribute highp vec4 in_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 100
					
					#ifdef GL_FRAGMENT_PRECISION_HIGH
					    precision highp float;
					#else
					    precision mediump float;
					#endif
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _Gradient;
					uniform lowp sampler2D _MainTexMask;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					lowp float u_xlat10_9;
					const int BITWISE_BIT_COUNT = 32;
					int op_modi(int x, int y) { return x - y * (x / y); }
					ivec2 op_modi(ivec2 a, ivec2 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); return a; }
					ivec3 op_modi(ivec3 a, ivec3 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); return a; }
					ivec4 op_modi(ivec4 a, ivec4 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); a.w = op_modi(a.w, b.w); return a; }
					
					int op_and(int a, int b) { int result = 0; int n = 1; for (int i = 0; i < BITWISE_BIT_COUNT; i++) { if ((op_modi(a, 2) != 0) && (op_modi(b, 2) != 0)) { result += n; } a = a / 2; b = b / 2; n = n * 2; if (!(a > 0 && b > 0)) { break; } } return result; }
					ivec2 op_and(ivec2 a, ivec2 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); return a; }
					ivec3 op_and(ivec3 a, ivec3 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); return a; }
					ivec4 op_and(ivec4 a, ivec4 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); a.w = op_and(a.w, b.w); return a; }
					
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat10_0.x = texture2D(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat10_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat10_1 = texture2D(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_0.xyz = texture2D(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat10_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat10_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat10_9 = texture2D(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat10_9) * u_xlat0.xyz;
					    u_xlat2.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat10_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    SV_Target0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat10_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat10_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier01 " {
					Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "LIGHTPROBE_SH" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					attribute highp vec4 in_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 100
					
					#ifdef GL_FRAGMENT_PRECISION_HIGH
					    precision highp float;
					#else
					    precision mediump float;
					#endif
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _Gradient;
					uniform lowp sampler2D _MainTexMask;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					lowp float u_xlat10_9;
					const int BITWISE_BIT_COUNT = 32;
					int op_modi(int x, int y) { return x - y * (x / y); }
					ivec2 op_modi(ivec2 a, ivec2 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); return a; }
					ivec3 op_modi(ivec3 a, ivec3 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); return a; }
					ivec4 op_modi(ivec4 a, ivec4 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); a.w = op_modi(a.w, b.w); return a; }
					
					int op_and(int a, int b) { int result = 0; int n = 1; for (int i = 0; i < BITWISE_BIT_COUNT; i++) { if ((op_modi(a, 2) != 0) && (op_modi(b, 2) != 0)) { result += n; } a = a / 2; b = b / 2; n = n * 2; if (!(a > 0 && b > 0)) { break; } } return result; }
					ivec2 op_and(ivec2 a, ivec2 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); return a; }
					ivec3 op_and(ivec3 a, ivec3 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); return a; }
					ivec4 op_and(ivec4 a, ivec4 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); a.w = op_and(a.w, b.w); return a; }
					
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat10_0.x = texture2D(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat10_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat10_1 = texture2D(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_0.xyz = texture2D(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat10_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat10_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat10_9 = texture2D(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat10_9) * u_xlat0.xyz;
					    u_xlat2.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat10_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    SV_Target0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat10_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat10_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier02 " {
					Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "LIGHTPROBE_SH" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					attribute highp vec4 in_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 100
					
					#ifdef GL_FRAGMENT_PRECISION_HIGH
					    precision highp float;
					#else
					    precision mediump float;
					#endif
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _Gradient;
					uniform lowp sampler2D _MainTexMask;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					lowp float u_xlat10_9;
					const int BITWISE_BIT_COUNT = 32;
					int op_modi(int x, int y) { return x - y * (x / y); }
					ivec2 op_modi(ivec2 a, ivec2 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); return a; }
					ivec3 op_modi(ivec3 a, ivec3 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); return a; }
					ivec4 op_modi(ivec4 a, ivec4 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); a.w = op_modi(a.w, b.w); return a; }
					
					int op_and(int a, int b) { int result = 0; int n = 1; for (int i = 0; i < BITWISE_BIT_COUNT; i++) { if ((op_modi(a, 2) != 0) && (op_modi(b, 2) != 0)) { result += n; } a = a / 2; b = b / 2; n = n * 2; if (!(a > 0 && b > 0)) { break; } } return result; }
					ivec2 op_and(ivec2 a, ivec2 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); return a; }
					ivec3 op_and(ivec3 a, ivec3 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); return a; }
					ivec4 op_and(ivec4 a, ivec4 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); a.w = op_and(a.w, b.w); return a; }
					
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat10_0.x = texture2D(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat10_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat10_1 = texture2D(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_0.xyz = texture2D(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat10_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat10_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat10_9 = texture2D(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat10_9) * u_xlat0.xyz;
					    u_xlat2.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat10_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    SV_Target0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat10_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat10_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier00 " {
					Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "LIGHTPROBE_SH" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					in highp vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _Gradient;
					uniform mediump sampler2D _MainTexMask;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					mediump float u_xlat16_9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat16_0.x = texture(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat16_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat16_1 = texture(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_0.xyz = texture(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat16_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat16_9 = texture(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat16_9) * u_xlat0.xyz;
					    u_xlat2.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat16_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    SV_Target0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat16_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat16_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier01 " {
					Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "LIGHTPROBE_SH" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					in highp vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _Gradient;
					uniform mediump sampler2D _MainTexMask;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					mediump float u_xlat16_9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat16_0.x = texture(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat16_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat16_1 = texture(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_0.xyz = texture(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat16_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat16_9 = texture(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat16_9) * u_xlat0.xyz;
					    u_xlat2.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat16_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    SV_Target0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat16_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat16_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier02 " {
					Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "LIGHTPROBE_SH" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					in highp vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _Gradient;
					uniform mediump sampler2D _MainTexMask;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					mediump float u_xlat16_9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat16_0.x = texture(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat16_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat16_1 = texture(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_0.xyz = texture(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat16_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat16_9 = texture(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat16_9) * u_xlat0.xyz;
					    u_xlat2.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat16_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    SV_Target0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat16_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat16_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier00 " {
					Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					attribute highp vec4 in_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 100
					
					#ifdef GL_FRAGMENT_PRECISION_HIGH
					    precision highp float;
					#else
					    precision mediump float;
					#endif
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _Gradient;
					uniform lowp sampler2D _MainTexMask;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					lowp float u_xlat10_9;
					const int BITWISE_BIT_COUNT = 32;
					int op_modi(int x, int y) { return x - y * (x / y); }
					ivec2 op_modi(ivec2 a, ivec2 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); return a; }
					ivec3 op_modi(ivec3 a, ivec3 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); return a; }
					ivec4 op_modi(ivec4 a, ivec4 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); a.w = op_modi(a.w, b.w); return a; }
					
					int op_and(int a, int b) { int result = 0; int n = 1; for (int i = 0; i < BITWISE_BIT_COUNT; i++) { if ((op_modi(a, 2) != 0) && (op_modi(b, 2) != 0)) { result += n; } a = a / 2; b = b / 2; n = n * 2; if (!(a > 0 && b > 0)) { break; } } return result; }
					ivec2 op_and(ivec2 a, ivec2 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); return a; }
					ivec3 op_and(ivec3 a, ivec3 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); return a; }
					ivec4 op_and(ivec4 a, ivec4 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); a.w = op_and(a.w, b.w); return a; }
					
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat10_0.x = texture2D(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat10_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat10_1 = texture2D(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_0.xyz = texture2D(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat10_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat10_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat10_9 = texture2D(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat10_9) * u_xlat0.xyz;
					    u_xlat2.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat10_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    SV_Target0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat10_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat10_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier01 " {
					Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					attribute highp vec4 in_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 100
					
					#ifdef GL_FRAGMENT_PRECISION_HIGH
					    precision highp float;
					#else
					    precision mediump float;
					#endif
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _Gradient;
					uniform lowp sampler2D _MainTexMask;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					lowp float u_xlat10_9;
					const int BITWISE_BIT_COUNT = 32;
					int op_modi(int x, int y) { return x - y * (x / y); }
					ivec2 op_modi(ivec2 a, ivec2 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); return a; }
					ivec3 op_modi(ivec3 a, ivec3 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); return a; }
					ivec4 op_modi(ivec4 a, ivec4 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); a.w = op_modi(a.w, b.w); return a; }
					
					int op_and(int a, int b) { int result = 0; int n = 1; for (int i = 0; i < BITWISE_BIT_COUNT; i++) { if ((op_modi(a, 2) != 0) && (op_modi(b, 2) != 0)) { result += n; } a = a / 2; b = b / 2; n = n * 2; if (!(a > 0 && b > 0)) { break; } } return result; }
					ivec2 op_and(ivec2 a, ivec2 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); return a; }
					ivec3 op_and(ivec3 a, ivec3 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); return a; }
					ivec4 op_and(ivec4 a, ivec4 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); a.w = op_and(a.w, b.w); return a; }
					
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat10_0.x = texture2D(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat10_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat10_1 = texture2D(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_0.xyz = texture2D(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat10_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat10_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat10_9 = texture2D(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat10_9) * u_xlat0.xyz;
					    u_xlat2.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat10_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    SV_Target0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat10_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat10_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier02 " {
					Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					attribute highp vec4 in_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 100
					
					#ifdef GL_FRAGMENT_PRECISION_HIGH
					    precision highp float;
					#else
					    precision mediump float;
					#endif
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _Gradient;
					uniform lowp sampler2D _MainTexMask;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					lowp float u_xlat10_9;
					const int BITWISE_BIT_COUNT = 32;
					int op_modi(int x, int y) { return x - y * (x / y); }
					ivec2 op_modi(ivec2 a, ivec2 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); return a; }
					ivec3 op_modi(ivec3 a, ivec3 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); return a; }
					ivec4 op_modi(ivec4 a, ivec4 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); a.w = op_modi(a.w, b.w); return a; }
					
					int op_and(int a, int b) { int result = 0; int n = 1; for (int i = 0; i < BITWISE_BIT_COUNT; i++) { if ((op_modi(a, 2) != 0) && (op_modi(b, 2) != 0)) { result += n; } a = a / 2; b = b / 2; n = n * 2; if (!(a > 0 && b > 0)) { break; } } return result; }
					ivec2 op_and(ivec2 a, ivec2 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); return a; }
					ivec3 op_and(ivec3 a, ivec3 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); return a; }
					ivec4 op_and(ivec4 a, ivec4 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); a.w = op_and(a.w, b.w); return a; }
					
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat10_0.x = texture2D(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat10_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat10_1 = texture2D(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_0.xyz = texture2D(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat10_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat10_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat10_9 = texture2D(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat10_9) * u_xlat0.xyz;
					    u_xlat2.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat10_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    SV_Target0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat10_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat10_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier00 " {
					Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					in highp vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _Gradient;
					uniform mediump sampler2D _MainTexMask;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					mediump float u_xlat16_9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat16_0.x = texture(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat16_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat16_1 = texture(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_0.xyz = texture(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat16_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat16_9 = texture(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat16_9) * u_xlat0.xyz;
					    u_xlat2.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat16_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    SV_Target0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat16_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat16_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier01 " {
					Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					in highp vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _Gradient;
					uniform mediump sampler2D _MainTexMask;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					mediump float u_xlat16_9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat16_0.x = texture(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat16_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat16_1 = texture(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_0.xyz = texture(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat16_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat16_9 = texture(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat16_9) * u_xlat0.xyz;
					    u_xlat2.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat16_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    SV_Target0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat16_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat16_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier02 " {
					Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					in highp vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _Gradient;
					uniform mediump sampler2D _MainTexMask;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					mediump float u_xlat16_9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat16_0.x = texture(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat16_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat16_1 = texture(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_0.xyz = texture(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat16_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat16_9 = texture(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat16_9) * u_xlat0.xyz;
					    u_xlat2.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat16_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    SV_Target0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat16_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat16_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier00 " {
					Keywords { "DIRECTIONAL" "LIGHTPROBE_SH" "SHADOWS_SCREEN" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					attribute highp vec4 in_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 100
					
					#ifdef GL_FRAGMENT_PRECISION_HIGH
					    precision highp float;
					#else
					    precision mediump float;
					#endif
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _Gradient;
					uniform lowp sampler2D _MainTexMask;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					lowp float u_xlat10_9;
					const int BITWISE_BIT_COUNT = 32;
					int op_modi(int x, int y) { return x - y * (x / y); }
					ivec2 op_modi(ivec2 a, ivec2 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); return a; }
					ivec3 op_modi(ivec3 a, ivec3 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); return a; }
					ivec4 op_modi(ivec4 a, ivec4 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); a.w = op_modi(a.w, b.w); return a; }
					
					int op_and(int a, int b) { int result = 0; int n = 1; for (int i = 0; i < BITWISE_BIT_COUNT; i++) { if ((op_modi(a, 2) != 0) && (op_modi(b, 2) != 0)) { result += n; } a = a / 2; b = b / 2; n = n * 2; if (!(a > 0 && b > 0)) { break; } } return result; }
					ivec2 op_and(ivec2 a, ivec2 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); return a; }
					ivec3 op_and(ivec3 a, ivec3 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); return a; }
					ivec4 op_and(ivec4 a, ivec4 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); a.w = op_and(a.w, b.w); return a; }
					
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat10_0.x = texture2D(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat10_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat10_1 = texture2D(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_0.xyz = texture2D(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat10_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat10_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat10_9 = texture2D(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat10_9) * u_xlat0.xyz;
					    u_xlat2.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat10_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    SV_Target0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat10_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat10_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier01 " {
					Keywords { "DIRECTIONAL" "LIGHTPROBE_SH" "SHADOWS_SCREEN" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					attribute highp vec4 in_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 100
					
					#ifdef GL_FRAGMENT_PRECISION_HIGH
					    precision highp float;
					#else
					    precision mediump float;
					#endif
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _Gradient;
					uniform lowp sampler2D _MainTexMask;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					lowp float u_xlat10_9;
					const int BITWISE_BIT_COUNT = 32;
					int op_modi(int x, int y) { return x - y * (x / y); }
					ivec2 op_modi(ivec2 a, ivec2 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); return a; }
					ivec3 op_modi(ivec3 a, ivec3 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); return a; }
					ivec4 op_modi(ivec4 a, ivec4 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); a.w = op_modi(a.w, b.w); return a; }
					
					int op_and(int a, int b) { int result = 0; int n = 1; for (int i = 0; i < BITWISE_BIT_COUNT; i++) { if ((op_modi(a, 2) != 0) && (op_modi(b, 2) != 0)) { result += n; } a = a / 2; b = b / 2; n = n * 2; if (!(a > 0 && b > 0)) { break; } } return result; }
					ivec2 op_and(ivec2 a, ivec2 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); return a; }
					ivec3 op_and(ivec3 a, ivec3 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); return a; }
					ivec4 op_and(ivec4 a, ivec4 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); a.w = op_and(a.w, b.w); return a; }
					
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat10_0.x = texture2D(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat10_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat10_1 = texture2D(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_0.xyz = texture2D(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat10_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat10_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat10_9 = texture2D(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat10_9) * u_xlat0.xyz;
					    u_xlat2.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat10_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    SV_Target0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat10_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat10_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier02 " {
					Keywords { "DIRECTIONAL" "LIGHTPROBE_SH" "SHADOWS_SCREEN" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					attribute highp vec4 in_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 100
					
					#ifdef GL_FRAGMENT_PRECISION_HIGH
					    precision highp float;
					#else
					    precision mediump float;
					#endif
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _Gradient;
					uniform lowp sampler2D _MainTexMask;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					lowp float u_xlat10_9;
					const int BITWISE_BIT_COUNT = 32;
					int op_modi(int x, int y) { return x - y * (x / y); }
					ivec2 op_modi(ivec2 a, ivec2 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); return a; }
					ivec3 op_modi(ivec3 a, ivec3 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); return a; }
					ivec4 op_modi(ivec4 a, ivec4 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); a.w = op_modi(a.w, b.w); return a; }
					
					int op_and(int a, int b) { int result = 0; int n = 1; for (int i = 0; i < BITWISE_BIT_COUNT; i++) { if ((op_modi(a, 2) != 0) && (op_modi(b, 2) != 0)) { result += n; } a = a / 2; b = b / 2; n = n * 2; if (!(a > 0 && b > 0)) { break; } } return result; }
					ivec2 op_and(ivec2 a, ivec2 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); return a; }
					ivec3 op_and(ivec3 a, ivec3 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); return a; }
					ivec4 op_and(ivec4 a, ivec4 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); a.w = op_and(a.w, b.w); return a; }
					
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat10_0.x = texture2D(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat10_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat10_1 = texture2D(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_0.xyz = texture2D(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat10_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat10_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat10_9 = texture2D(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat10_9) * u_xlat0.xyz;
					    u_xlat2.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat10_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    SV_Target0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat10_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat10_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier00 " {
					Keywords { "DIRECTIONAL" "LIGHTPROBE_SH" "SHADOWS_SCREEN" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					in highp vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _Gradient;
					uniform mediump sampler2D _MainTexMask;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					mediump float u_xlat16_9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat16_0.x = texture(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat16_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat16_1 = texture(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_0.xyz = texture(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat16_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat16_9 = texture(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat16_9) * u_xlat0.xyz;
					    u_xlat2.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat16_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    SV_Target0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat16_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat16_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier01 " {
					Keywords { "DIRECTIONAL" "LIGHTPROBE_SH" "SHADOWS_SCREEN" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					in highp vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _Gradient;
					uniform mediump sampler2D _MainTexMask;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					mediump float u_xlat16_9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat16_0.x = texture(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat16_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat16_1 = texture(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_0.xyz = texture(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat16_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat16_9 = texture(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat16_9) * u_xlat0.xyz;
					    u_xlat2.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat16_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    SV_Target0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat16_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat16_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier02 " {
					Keywords { "DIRECTIONAL" "LIGHTPROBE_SH" "SHADOWS_SCREEN" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					in highp vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _Gradient;
					uniform mediump sampler2D _MainTexMask;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					mediump float u_xlat16_9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat16_0.x = texture(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat16_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat16_1 = texture(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_0.xyz = texture(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat16_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat16_9 = texture(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat16_9) * u_xlat0.xyz;
					    u_xlat2.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat16_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    SV_Target0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat16_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat16_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier00 " {
					Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "SHADOWS_SCREEN" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					attribute highp vec4 in_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 100
					
					#ifdef GL_FRAGMENT_PRECISION_HIGH
					    precision highp float;
					#else
					    precision mediump float;
					#endif
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _Gradient;
					uniform lowp sampler2D _MainTexMask;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					lowp float u_xlat10_9;
					const int BITWISE_BIT_COUNT = 32;
					int op_modi(int x, int y) { return x - y * (x / y); }
					ivec2 op_modi(ivec2 a, ivec2 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); return a; }
					ivec3 op_modi(ivec3 a, ivec3 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); return a; }
					ivec4 op_modi(ivec4 a, ivec4 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); a.w = op_modi(a.w, b.w); return a; }
					
					int op_and(int a, int b) { int result = 0; int n = 1; for (int i = 0; i < BITWISE_BIT_COUNT; i++) { if ((op_modi(a, 2) != 0) && (op_modi(b, 2) != 0)) { result += n; } a = a / 2; b = b / 2; n = n * 2; if (!(a > 0 && b > 0)) { break; } } return result; }
					ivec2 op_and(ivec2 a, ivec2 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); return a; }
					ivec3 op_and(ivec3 a, ivec3 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); return a; }
					ivec4 op_and(ivec4 a, ivec4 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); a.w = op_and(a.w, b.w); return a; }
					
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat10_0.x = texture2D(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat10_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat10_1 = texture2D(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_0.xyz = texture2D(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat10_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat10_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat10_9 = texture2D(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat10_9) * u_xlat0.xyz;
					    u_xlat2.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat10_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    SV_Target0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat10_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat10_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier01 " {
					Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "SHADOWS_SCREEN" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					attribute highp vec4 in_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 100
					
					#ifdef GL_FRAGMENT_PRECISION_HIGH
					    precision highp float;
					#else
					    precision mediump float;
					#endif
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _Gradient;
					uniform lowp sampler2D _MainTexMask;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					lowp float u_xlat10_9;
					const int BITWISE_BIT_COUNT = 32;
					int op_modi(int x, int y) { return x - y * (x / y); }
					ivec2 op_modi(ivec2 a, ivec2 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); return a; }
					ivec3 op_modi(ivec3 a, ivec3 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); return a; }
					ivec4 op_modi(ivec4 a, ivec4 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); a.w = op_modi(a.w, b.w); return a; }
					
					int op_and(int a, int b) { int result = 0; int n = 1; for (int i = 0; i < BITWISE_BIT_COUNT; i++) { if ((op_modi(a, 2) != 0) && (op_modi(b, 2) != 0)) { result += n; } a = a / 2; b = b / 2; n = n * 2; if (!(a > 0 && b > 0)) { break; } } return result; }
					ivec2 op_and(ivec2 a, ivec2 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); return a; }
					ivec3 op_and(ivec3 a, ivec3 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); return a; }
					ivec4 op_and(ivec4 a, ivec4 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); a.w = op_and(a.w, b.w); return a; }
					
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat10_0.x = texture2D(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat10_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat10_1 = texture2D(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_0.xyz = texture2D(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat10_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat10_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat10_9 = texture2D(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat10_9) * u_xlat0.xyz;
					    u_xlat2.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat10_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    SV_Target0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat10_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat10_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier02 " {
					Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "SHADOWS_SCREEN" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					attribute highp vec4 in_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 100
					
					#ifdef GL_FRAGMENT_PRECISION_HIGH
					    precision highp float;
					#else
					    precision mediump float;
					#endif
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _Gradient;
					uniform lowp sampler2D _MainTexMask;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					lowp float u_xlat10_9;
					const int BITWISE_BIT_COUNT = 32;
					int op_modi(int x, int y) { return x - y * (x / y); }
					ivec2 op_modi(ivec2 a, ivec2 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); return a; }
					ivec3 op_modi(ivec3 a, ivec3 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); return a; }
					ivec4 op_modi(ivec4 a, ivec4 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); a.w = op_modi(a.w, b.w); return a; }
					
					int op_and(int a, int b) { int result = 0; int n = 1; for (int i = 0; i < BITWISE_BIT_COUNT; i++) { if ((op_modi(a, 2) != 0) && (op_modi(b, 2) != 0)) { result += n; } a = a / 2; b = b / 2; n = n * 2; if (!(a > 0 && b > 0)) { break; } } return result; }
					ivec2 op_and(ivec2 a, ivec2 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); return a; }
					ivec3 op_and(ivec3 a, ivec3 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); return a; }
					ivec4 op_and(ivec4 a, ivec4 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); a.w = op_and(a.w, b.w); return a; }
					
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat10_0.x = texture2D(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat10_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat10_1 = texture2D(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_0.xyz = texture2D(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat10_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat10_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat10_9 = texture2D(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat10_9) * u_xlat0.xyz;
					    u_xlat2.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat10_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    SV_Target0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat10_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat10_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier00 " {
					Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "SHADOWS_SCREEN" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					in highp vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _Gradient;
					uniform mediump sampler2D _MainTexMask;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					mediump float u_xlat16_9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat16_0.x = texture(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat16_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat16_1 = texture(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_0.xyz = texture(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat16_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat16_9 = texture(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat16_9) * u_xlat0.xyz;
					    u_xlat2.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat16_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    SV_Target0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat16_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat16_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier01 " {
					Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "SHADOWS_SCREEN" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					in highp vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _Gradient;
					uniform mediump sampler2D _MainTexMask;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					mediump float u_xlat16_9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat16_0.x = texture(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat16_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat16_1 = texture(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_0.xyz = texture(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat16_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat16_9 = texture(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat16_9) * u_xlat0.xyz;
					    u_xlat2.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat16_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    SV_Target0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat16_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat16_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier02 " {
					Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "SHADOWS_SCREEN" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					in highp vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _Gradient;
					uniform mediump sampler2D _MainTexMask;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					mediump float u_xlat16_9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat16_0.x = texture(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat16_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat16_1 = texture(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_0.xyz = texture(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat16_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat16_9 = texture(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat16_9) * u_xlat0.xyz;
					    u_xlat2.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat16_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    SV_Target0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat16_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat16_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier00 " {
					Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "LIGHTPROBE_SH" "SHADOWS_SCREEN" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					attribute highp vec4 in_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 100
					
					#ifdef GL_FRAGMENT_PRECISION_HIGH
					    precision highp float;
					#else
					    precision mediump float;
					#endif
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _Gradient;
					uniform lowp sampler2D _MainTexMask;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					lowp float u_xlat10_9;
					const int BITWISE_BIT_COUNT = 32;
					int op_modi(int x, int y) { return x - y * (x / y); }
					ivec2 op_modi(ivec2 a, ivec2 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); return a; }
					ivec3 op_modi(ivec3 a, ivec3 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); return a; }
					ivec4 op_modi(ivec4 a, ivec4 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); a.w = op_modi(a.w, b.w); return a; }
					
					int op_and(int a, int b) { int result = 0; int n = 1; for (int i = 0; i < BITWISE_BIT_COUNT; i++) { if ((op_modi(a, 2) != 0) && (op_modi(b, 2) != 0)) { result += n; } a = a / 2; b = b / 2; n = n * 2; if (!(a > 0 && b > 0)) { break; } } return result; }
					ivec2 op_and(ivec2 a, ivec2 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); return a; }
					ivec3 op_and(ivec3 a, ivec3 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); return a; }
					ivec4 op_and(ivec4 a, ivec4 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); a.w = op_and(a.w, b.w); return a; }
					
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat10_0.x = texture2D(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat10_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat10_1 = texture2D(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_0.xyz = texture2D(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat10_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat10_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat10_9 = texture2D(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat10_9) * u_xlat0.xyz;
					    u_xlat2.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat10_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    SV_Target0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat10_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat10_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier01 " {
					Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "LIGHTPROBE_SH" "SHADOWS_SCREEN" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					attribute highp vec4 in_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 100
					
					#ifdef GL_FRAGMENT_PRECISION_HIGH
					    precision highp float;
					#else
					    precision mediump float;
					#endif
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _Gradient;
					uniform lowp sampler2D _MainTexMask;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					lowp float u_xlat10_9;
					const int BITWISE_BIT_COUNT = 32;
					int op_modi(int x, int y) { return x - y * (x / y); }
					ivec2 op_modi(ivec2 a, ivec2 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); return a; }
					ivec3 op_modi(ivec3 a, ivec3 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); return a; }
					ivec4 op_modi(ivec4 a, ivec4 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); a.w = op_modi(a.w, b.w); return a; }
					
					int op_and(int a, int b) { int result = 0; int n = 1; for (int i = 0; i < BITWISE_BIT_COUNT; i++) { if ((op_modi(a, 2) != 0) && (op_modi(b, 2) != 0)) { result += n; } a = a / 2; b = b / 2; n = n * 2; if (!(a > 0 && b > 0)) { break; } } return result; }
					ivec2 op_and(ivec2 a, ivec2 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); return a; }
					ivec3 op_and(ivec3 a, ivec3 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); return a; }
					ivec4 op_and(ivec4 a, ivec4 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); a.w = op_and(a.w, b.w); return a; }
					
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat10_0.x = texture2D(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat10_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat10_1 = texture2D(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_0.xyz = texture2D(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat10_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat10_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat10_9 = texture2D(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat10_9) * u_xlat0.xyz;
					    u_xlat2.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat10_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    SV_Target0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat10_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat10_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier02 " {
					Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "LIGHTPROBE_SH" "SHADOWS_SCREEN" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					attribute highp vec4 in_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 100
					
					#ifdef GL_FRAGMENT_PRECISION_HIGH
					    precision highp float;
					#else
					    precision mediump float;
					#endif
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _Gradient;
					uniform lowp sampler2D _MainTexMask;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					lowp float u_xlat10_9;
					const int BITWISE_BIT_COUNT = 32;
					int op_modi(int x, int y) { return x - y * (x / y); }
					ivec2 op_modi(ivec2 a, ivec2 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); return a; }
					ivec3 op_modi(ivec3 a, ivec3 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); return a; }
					ivec4 op_modi(ivec4 a, ivec4 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); a.w = op_modi(a.w, b.w); return a; }
					
					int op_and(int a, int b) { int result = 0; int n = 1; for (int i = 0; i < BITWISE_BIT_COUNT; i++) { if ((op_modi(a, 2) != 0) && (op_modi(b, 2) != 0)) { result += n; } a = a / 2; b = b / 2; n = n * 2; if (!(a > 0 && b > 0)) { break; } } return result; }
					ivec2 op_and(ivec2 a, ivec2 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); return a; }
					ivec3 op_and(ivec3 a, ivec3 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); return a; }
					ivec4 op_and(ivec4 a, ivec4 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); a.w = op_and(a.w, b.w); return a; }
					
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat10_0.x = texture2D(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat10_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat10_1 = texture2D(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_0.xyz = texture2D(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat10_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat10_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat10_9 = texture2D(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat10_9) * u_xlat0.xyz;
					    u_xlat2.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat10_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    SV_Target0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat10_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat10_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier00 " {
					Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "LIGHTPROBE_SH" "SHADOWS_SCREEN" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					in highp vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _Gradient;
					uniform mediump sampler2D _MainTexMask;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					mediump float u_xlat16_9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat16_0.x = texture(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat16_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat16_1 = texture(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_0.xyz = texture(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat16_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat16_9 = texture(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat16_9) * u_xlat0.xyz;
					    u_xlat2.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat16_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    SV_Target0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat16_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat16_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier01 " {
					Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "LIGHTPROBE_SH" "SHADOWS_SCREEN" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					in highp vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _Gradient;
					uniform mediump sampler2D _MainTexMask;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					mediump float u_xlat16_9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat16_0.x = texture(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat16_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat16_1 = texture(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_0.xyz = texture(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat16_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat16_9 = texture(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat16_9) * u_xlat0.xyz;
					    u_xlat2.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat16_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    SV_Target0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat16_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat16_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier02 " {
					Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "LIGHTPROBE_SH" "SHADOWS_SCREEN" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					in highp vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _Gradient;
					uniform mediump sampler2D _MainTexMask;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					mediump float u_xlat16_9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat16_0.x = texture(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat16_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat16_1 = texture(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_0.xyz = texture(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat16_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat16_9 = texture(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat16_9) * u_xlat0.xyz;
					    u_xlat2.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat16_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    SV_Target0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat16_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat16_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier00 " {
					Keywords { "DIRECTIONAL" "VERTEXLIGHT_ON" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					attribute highp vec4 in_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 100
					
					#ifdef GL_FRAGMENT_PRECISION_HIGH
					    precision highp float;
					#else
					    precision mediump float;
					#endif
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _Gradient;
					uniform lowp sampler2D _MainTexMask;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					lowp float u_xlat10_9;
					const int BITWISE_BIT_COUNT = 32;
					int op_modi(int x, int y) { return x - y * (x / y); }
					ivec2 op_modi(ivec2 a, ivec2 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); return a; }
					ivec3 op_modi(ivec3 a, ivec3 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); return a; }
					ivec4 op_modi(ivec4 a, ivec4 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); a.w = op_modi(a.w, b.w); return a; }
					
					int op_and(int a, int b) { int result = 0; int n = 1; for (int i = 0; i < BITWISE_BIT_COUNT; i++) { if ((op_modi(a, 2) != 0) && (op_modi(b, 2) != 0)) { result += n; } a = a / 2; b = b / 2; n = n * 2; if (!(a > 0 && b > 0)) { break; } } return result; }
					ivec2 op_and(ivec2 a, ivec2 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); return a; }
					ivec3 op_and(ivec3 a, ivec3 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); return a; }
					ivec4 op_and(ivec4 a, ivec4 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); a.w = op_and(a.w, b.w); return a; }
					
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat10_0.x = texture2D(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat10_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat10_1 = texture2D(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_0.xyz = texture2D(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat10_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat10_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat10_9 = texture2D(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat10_9) * u_xlat0.xyz;
					    u_xlat2.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat10_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    SV_Target0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat10_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat10_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier01 " {
					Keywords { "DIRECTIONAL" "VERTEXLIGHT_ON" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					attribute highp vec4 in_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 100
					
					#ifdef GL_FRAGMENT_PRECISION_HIGH
					    precision highp float;
					#else
					    precision mediump float;
					#endif
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _Gradient;
					uniform lowp sampler2D _MainTexMask;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					lowp float u_xlat10_9;
					const int BITWISE_BIT_COUNT = 32;
					int op_modi(int x, int y) { return x - y * (x / y); }
					ivec2 op_modi(ivec2 a, ivec2 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); return a; }
					ivec3 op_modi(ivec3 a, ivec3 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); return a; }
					ivec4 op_modi(ivec4 a, ivec4 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); a.w = op_modi(a.w, b.w); return a; }
					
					int op_and(int a, int b) { int result = 0; int n = 1; for (int i = 0; i < BITWISE_BIT_COUNT; i++) { if ((op_modi(a, 2) != 0) && (op_modi(b, 2) != 0)) { result += n; } a = a / 2; b = b / 2; n = n * 2; if (!(a > 0 && b > 0)) { break; } } return result; }
					ivec2 op_and(ivec2 a, ivec2 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); return a; }
					ivec3 op_and(ivec3 a, ivec3 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); return a; }
					ivec4 op_and(ivec4 a, ivec4 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); a.w = op_and(a.w, b.w); return a; }
					
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat10_0.x = texture2D(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat10_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat10_1 = texture2D(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_0.xyz = texture2D(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat10_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat10_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat10_9 = texture2D(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat10_9) * u_xlat0.xyz;
					    u_xlat2.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat10_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    SV_Target0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat10_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat10_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier02 " {
					Keywords { "DIRECTIONAL" "VERTEXLIGHT_ON" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					attribute highp vec4 in_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 100
					
					#ifdef GL_FRAGMENT_PRECISION_HIGH
					    precision highp float;
					#else
					    precision mediump float;
					#endif
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _Gradient;
					uniform lowp sampler2D _MainTexMask;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					lowp float u_xlat10_9;
					const int BITWISE_BIT_COUNT = 32;
					int op_modi(int x, int y) { return x - y * (x / y); }
					ivec2 op_modi(ivec2 a, ivec2 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); return a; }
					ivec3 op_modi(ivec3 a, ivec3 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); return a; }
					ivec4 op_modi(ivec4 a, ivec4 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); a.w = op_modi(a.w, b.w); return a; }
					
					int op_and(int a, int b) { int result = 0; int n = 1; for (int i = 0; i < BITWISE_BIT_COUNT; i++) { if ((op_modi(a, 2) != 0) && (op_modi(b, 2) != 0)) { result += n; } a = a / 2; b = b / 2; n = n * 2; if (!(a > 0 && b > 0)) { break; } } return result; }
					ivec2 op_and(ivec2 a, ivec2 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); return a; }
					ivec3 op_and(ivec3 a, ivec3 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); return a; }
					ivec4 op_and(ivec4 a, ivec4 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); a.w = op_and(a.w, b.w); return a; }
					
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat10_0.x = texture2D(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat10_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat10_1 = texture2D(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_0.xyz = texture2D(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat10_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat10_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat10_9 = texture2D(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat10_9) * u_xlat0.xyz;
					    u_xlat2.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat10_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    SV_Target0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat10_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat10_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier00 " {
					Keywords { "DIRECTIONAL" "VERTEXLIGHT_ON" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					in highp vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _Gradient;
					uniform mediump sampler2D _MainTexMask;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					mediump float u_xlat16_9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat16_0.x = texture(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat16_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat16_1 = texture(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_0.xyz = texture(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat16_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat16_9 = texture(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat16_9) * u_xlat0.xyz;
					    u_xlat2.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat16_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    SV_Target0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat16_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat16_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier01 " {
					Keywords { "DIRECTIONAL" "VERTEXLIGHT_ON" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					in highp vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _Gradient;
					uniform mediump sampler2D _MainTexMask;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					mediump float u_xlat16_9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat16_0.x = texture(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat16_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat16_1 = texture(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_0.xyz = texture(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat16_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat16_9 = texture(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat16_9) * u_xlat0.xyz;
					    u_xlat2.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat16_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    SV_Target0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat16_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat16_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier02 " {
					Keywords { "DIRECTIONAL" "VERTEXLIGHT_ON" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					in highp vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _Gradient;
					uniform mediump sampler2D _MainTexMask;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					mediump float u_xlat16_9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat16_0.x = texture(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat16_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat16_1 = texture(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_0.xyz = texture(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat16_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat16_9 = texture(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat16_9) * u_xlat0.xyz;
					    u_xlat2.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat16_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    SV_Target0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat16_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat16_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier00 " {
					Keywords { "DIRECTIONAL" "LIGHTPROBE_SH" "VERTEXLIGHT_ON" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					attribute highp vec4 in_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 100
					
					#ifdef GL_FRAGMENT_PRECISION_HIGH
					    precision highp float;
					#else
					    precision mediump float;
					#endif
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _Gradient;
					uniform lowp sampler2D _MainTexMask;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					lowp float u_xlat10_9;
					const int BITWISE_BIT_COUNT = 32;
					int op_modi(int x, int y) { return x - y * (x / y); }
					ivec2 op_modi(ivec2 a, ivec2 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); return a; }
					ivec3 op_modi(ivec3 a, ivec3 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); return a; }
					ivec4 op_modi(ivec4 a, ivec4 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); a.w = op_modi(a.w, b.w); return a; }
					
					int op_and(int a, int b) { int result = 0; int n = 1; for (int i = 0; i < BITWISE_BIT_COUNT; i++) { if ((op_modi(a, 2) != 0) && (op_modi(b, 2) != 0)) { result += n; } a = a / 2; b = b / 2; n = n * 2; if (!(a > 0 && b > 0)) { break; } } return result; }
					ivec2 op_and(ivec2 a, ivec2 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); return a; }
					ivec3 op_and(ivec3 a, ivec3 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); return a; }
					ivec4 op_and(ivec4 a, ivec4 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); a.w = op_and(a.w, b.w); return a; }
					
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat10_0.x = texture2D(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat10_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat10_1 = texture2D(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_0.xyz = texture2D(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat10_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat10_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat10_9 = texture2D(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat10_9) * u_xlat0.xyz;
					    u_xlat2.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat10_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    SV_Target0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat10_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat10_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier01 " {
					Keywords { "DIRECTIONAL" "LIGHTPROBE_SH" "VERTEXLIGHT_ON" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					attribute highp vec4 in_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 100
					
					#ifdef GL_FRAGMENT_PRECISION_HIGH
					    precision highp float;
					#else
					    precision mediump float;
					#endif
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _Gradient;
					uniform lowp sampler2D _MainTexMask;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					lowp float u_xlat10_9;
					const int BITWISE_BIT_COUNT = 32;
					int op_modi(int x, int y) { return x - y * (x / y); }
					ivec2 op_modi(ivec2 a, ivec2 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); return a; }
					ivec3 op_modi(ivec3 a, ivec3 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); return a; }
					ivec4 op_modi(ivec4 a, ivec4 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); a.w = op_modi(a.w, b.w); return a; }
					
					int op_and(int a, int b) { int result = 0; int n = 1; for (int i = 0; i < BITWISE_BIT_COUNT; i++) { if ((op_modi(a, 2) != 0) && (op_modi(b, 2) != 0)) { result += n; } a = a / 2; b = b / 2; n = n * 2; if (!(a > 0 && b > 0)) { break; } } return result; }
					ivec2 op_and(ivec2 a, ivec2 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); return a; }
					ivec3 op_and(ivec3 a, ivec3 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); return a; }
					ivec4 op_and(ivec4 a, ivec4 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); a.w = op_and(a.w, b.w); return a; }
					
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat10_0.x = texture2D(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat10_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat10_1 = texture2D(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_0.xyz = texture2D(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat10_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat10_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat10_9 = texture2D(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat10_9) * u_xlat0.xyz;
					    u_xlat2.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat10_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    SV_Target0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat10_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat10_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier02 " {
					Keywords { "DIRECTIONAL" "LIGHTPROBE_SH" "VERTEXLIGHT_ON" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					attribute highp vec4 in_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 100
					
					#ifdef GL_FRAGMENT_PRECISION_HIGH
					    precision highp float;
					#else
					    precision mediump float;
					#endif
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _Gradient;
					uniform lowp sampler2D _MainTexMask;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					lowp float u_xlat10_9;
					const int BITWISE_BIT_COUNT = 32;
					int op_modi(int x, int y) { return x - y * (x / y); }
					ivec2 op_modi(ivec2 a, ivec2 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); return a; }
					ivec3 op_modi(ivec3 a, ivec3 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); return a; }
					ivec4 op_modi(ivec4 a, ivec4 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); a.w = op_modi(a.w, b.w); return a; }
					
					int op_and(int a, int b) { int result = 0; int n = 1; for (int i = 0; i < BITWISE_BIT_COUNT; i++) { if ((op_modi(a, 2) != 0) && (op_modi(b, 2) != 0)) { result += n; } a = a / 2; b = b / 2; n = n * 2; if (!(a > 0 && b > 0)) { break; } } return result; }
					ivec2 op_and(ivec2 a, ivec2 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); return a; }
					ivec3 op_and(ivec3 a, ivec3 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); return a; }
					ivec4 op_and(ivec4 a, ivec4 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); a.w = op_and(a.w, b.w); return a; }
					
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat10_0.x = texture2D(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat10_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat10_1 = texture2D(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_0.xyz = texture2D(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat10_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat10_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat10_9 = texture2D(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat10_9) * u_xlat0.xyz;
					    u_xlat2.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat10_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    SV_Target0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat10_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat10_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier00 " {
					Keywords { "DIRECTIONAL" "LIGHTPROBE_SH" "VERTEXLIGHT_ON" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					in highp vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _Gradient;
					uniform mediump sampler2D _MainTexMask;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					mediump float u_xlat16_9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat16_0.x = texture(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat16_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat16_1 = texture(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_0.xyz = texture(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat16_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat16_9 = texture(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat16_9) * u_xlat0.xyz;
					    u_xlat2.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat16_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    SV_Target0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat16_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat16_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier01 " {
					Keywords { "DIRECTIONAL" "LIGHTPROBE_SH" "VERTEXLIGHT_ON" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					in highp vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _Gradient;
					uniform mediump sampler2D _MainTexMask;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					mediump float u_xlat16_9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat16_0.x = texture(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat16_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat16_1 = texture(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_0.xyz = texture(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat16_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat16_9 = texture(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat16_9) * u_xlat0.xyz;
					    u_xlat2.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat16_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    SV_Target0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat16_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat16_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier02 " {
					Keywords { "DIRECTIONAL" "LIGHTPROBE_SH" "VERTEXLIGHT_ON" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					in highp vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _Gradient;
					uniform mediump sampler2D _MainTexMask;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					mediump float u_xlat16_9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat16_0.x = texture(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat16_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat16_1 = texture(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_0.xyz = texture(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat16_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat16_9 = texture(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat16_9) * u_xlat0.xyz;
					    u_xlat2.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat16_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    SV_Target0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat16_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat16_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier00 " {
					Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					attribute highp vec4 in_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 100
					
					#ifdef GL_FRAGMENT_PRECISION_HIGH
					    precision highp float;
					#else
					    precision mediump float;
					#endif
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _Gradient;
					uniform lowp sampler2D _MainTexMask;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					lowp float u_xlat10_9;
					const int BITWISE_BIT_COUNT = 32;
					int op_modi(int x, int y) { return x - y * (x / y); }
					ivec2 op_modi(ivec2 a, ivec2 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); return a; }
					ivec3 op_modi(ivec3 a, ivec3 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); return a; }
					ivec4 op_modi(ivec4 a, ivec4 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); a.w = op_modi(a.w, b.w); return a; }
					
					int op_and(int a, int b) { int result = 0; int n = 1; for (int i = 0; i < BITWISE_BIT_COUNT; i++) { if ((op_modi(a, 2) != 0) && (op_modi(b, 2) != 0)) { result += n; } a = a / 2; b = b / 2; n = n * 2; if (!(a > 0 && b > 0)) { break; } } return result; }
					ivec2 op_and(ivec2 a, ivec2 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); return a; }
					ivec3 op_and(ivec3 a, ivec3 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); return a; }
					ivec4 op_and(ivec4 a, ivec4 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); a.w = op_and(a.w, b.w); return a; }
					
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat10_0.x = texture2D(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat10_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat10_1 = texture2D(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_0.xyz = texture2D(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat10_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat10_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat10_9 = texture2D(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat10_9) * u_xlat0.xyz;
					    u_xlat2.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat10_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    SV_Target0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat10_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat10_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier01 " {
					Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					attribute highp vec4 in_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 100
					
					#ifdef GL_FRAGMENT_PRECISION_HIGH
					    precision highp float;
					#else
					    precision mediump float;
					#endif
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _Gradient;
					uniform lowp sampler2D _MainTexMask;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					lowp float u_xlat10_9;
					const int BITWISE_BIT_COUNT = 32;
					int op_modi(int x, int y) { return x - y * (x / y); }
					ivec2 op_modi(ivec2 a, ivec2 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); return a; }
					ivec3 op_modi(ivec3 a, ivec3 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); return a; }
					ivec4 op_modi(ivec4 a, ivec4 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); a.w = op_modi(a.w, b.w); return a; }
					
					int op_and(int a, int b) { int result = 0; int n = 1; for (int i = 0; i < BITWISE_BIT_COUNT; i++) { if ((op_modi(a, 2) != 0) && (op_modi(b, 2) != 0)) { result += n; } a = a / 2; b = b / 2; n = n * 2; if (!(a > 0 && b > 0)) { break; } } return result; }
					ivec2 op_and(ivec2 a, ivec2 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); return a; }
					ivec3 op_and(ivec3 a, ivec3 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); return a; }
					ivec4 op_and(ivec4 a, ivec4 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); a.w = op_and(a.w, b.w); return a; }
					
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat10_0.x = texture2D(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat10_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat10_1 = texture2D(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_0.xyz = texture2D(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat10_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat10_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat10_9 = texture2D(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat10_9) * u_xlat0.xyz;
					    u_xlat2.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat10_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    SV_Target0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat10_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat10_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier02 " {
					Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					attribute highp vec4 in_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 100
					
					#ifdef GL_FRAGMENT_PRECISION_HIGH
					    precision highp float;
					#else
					    precision mediump float;
					#endif
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _Gradient;
					uniform lowp sampler2D _MainTexMask;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					lowp float u_xlat10_9;
					const int BITWISE_BIT_COUNT = 32;
					int op_modi(int x, int y) { return x - y * (x / y); }
					ivec2 op_modi(ivec2 a, ivec2 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); return a; }
					ivec3 op_modi(ivec3 a, ivec3 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); return a; }
					ivec4 op_modi(ivec4 a, ivec4 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); a.w = op_modi(a.w, b.w); return a; }
					
					int op_and(int a, int b) { int result = 0; int n = 1; for (int i = 0; i < BITWISE_BIT_COUNT; i++) { if ((op_modi(a, 2) != 0) && (op_modi(b, 2) != 0)) { result += n; } a = a / 2; b = b / 2; n = n * 2; if (!(a > 0 && b > 0)) { break; } } return result; }
					ivec2 op_and(ivec2 a, ivec2 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); return a; }
					ivec3 op_and(ivec3 a, ivec3 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); return a; }
					ivec4 op_and(ivec4 a, ivec4 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); a.w = op_and(a.w, b.w); return a; }
					
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat10_0.x = texture2D(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat10_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat10_1 = texture2D(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_0.xyz = texture2D(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat10_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat10_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat10_9 = texture2D(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat10_9) * u_xlat0.xyz;
					    u_xlat2.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat10_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    SV_Target0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat10_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat10_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier00 " {
					Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					in highp vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _Gradient;
					uniform mediump sampler2D _MainTexMask;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					mediump float u_xlat16_9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat16_0.x = texture(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat16_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat16_1 = texture(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_0.xyz = texture(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat16_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat16_9 = texture(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat16_9) * u_xlat0.xyz;
					    u_xlat2.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat16_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    SV_Target0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat16_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat16_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier01 " {
					Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					in highp vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _Gradient;
					uniform mediump sampler2D _MainTexMask;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					mediump float u_xlat16_9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat16_0.x = texture(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat16_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat16_1 = texture(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_0.xyz = texture(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat16_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat16_9 = texture(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat16_9) * u_xlat0.xyz;
					    u_xlat2.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat16_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    SV_Target0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat16_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat16_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier02 " {
					Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					in highp vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _Gradient;
					uniform mediump sampler2D _MainTexMask;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					mediump float u_xlat16_9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat16_0.x = texture(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat16_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat16_1 = texture(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_0.xyz = texture(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat16_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat16_9 = texture(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat16_9) * u_xlat0.xyz;
					    u_xlat2.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat16_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    SV_Target0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat16_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat16_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier00 " {
					Keywords { "DIRECTIONAL" "LIGHTPROBE_SH" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					attribute highp vec4 in_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 100
					
					#ifdef GL_FRAGMENT_PRECISION_HIGH
					    precision highp float;
					#else
					    precision mediump float;
					#endif
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _Gradient;
					uniform lowp sampler2D _MainTexMask;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					lowp float u_xlat10_9;
					const int BITWISE_BIT_COUNT = 32;
					int op_modi(int x, int y) { return x - y * (x / y); }
					ivec2 op_modi(ivec2 a, ivec2 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); return a; }
					ivec3 op_modi(ivec3 a, ivec3 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); return a; }
					ivec4 op_modi(ivec4 a, ivec4 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); a.w = op_modi(a.w, b.w); return a; }
					
					int op_and(int a, int b) { int result = 0; int n = 1; for (int i = 0; i < BITWISE_BIT_COUNT; i++) { if ((op_modi(a, 2) != 0) && (op_modi(b, 2) != 0)) { result += n; } a = a / 2; b = b / 2; n = n * 2; if (!(a > 0 && b > 0)) { break; } } return result; }
					ivec2 op_and(ivec2 a, ivec2 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); return a; }
					ivec3 op_and(ivec3 a, ivec3 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); return a; }
					ivec4 op_and(ivec4 a, ivec4 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); a.w = op_and(a.w, b.w); return a; }
					
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat10_0.x = texture2D(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat10_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat10_1 = texture2D(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_0.xyz = texture2D(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat10_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat10_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat10_9 = texture2D(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat10_9) * u_xlat0.xyz;
					    u_xlat2.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat10_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    SV_Target0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat10_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat10_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier01 " {
					Keywords { "DIRECTIONAL" "LIGHTPROBE_SH" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					attribute highp vec4 in_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 100
					
					#ifdef GL_FRAGMENT_PRECISION_HIGH
					    precision highp float;
					#else
					    precision mediump float;
					#endif
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _Gradient;
					uniform lowp sampler2D _MainTexMask;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					lowp float u_xlat10_9;
					const int BITWISE_BIT_COUNT = 32;
					int op_modi(int x, int y) { return x - y * (x / y); }
					ivec2 op_modi(ivec2 a, ivec2 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); return a; }
					ivec3 op_modi(ivec3 a, ivec3 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); return a; }
					ivec4 op_modi(ivec4 a, ivec4 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); a.w = op_modi(a.w, b.w); return a; }
					
					int op_and(int a, int b) { int result = 0; int n = 1; for (int i = 0; i < BITWISE_BIT_COUNT; i++) { if ((op_modi(a, 2) != 0) && (op_modi(b, 2) != 0)) { result += n; } a = a / 2; b = b / 2; n = n * 2; if (!(a > 0 && b > 0)) { break; } } return result; }
					ivec2 op_and(ivec2 a, ivec2 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); return a; }
					ivec3 op_and(ivec3 a, ivec3 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); return a; }
					ivec4 op_and(ivec4 a, ivec4 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); a.w = op_and(a.w, b.w); return a; }
					
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat10_0.x = texture2D(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat10_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat10_1 = texture2D(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_0.xyz = texture2D(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat10_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat10_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat10_9 = texture2D(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat10_9) * u_xlat0.xyz;
					    u_xlat2.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat10_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    SV_Target0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat10_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat10_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier02 " {
					Keywords { "DIRECTIONAL" "LIGHTPROBE_SH" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					attribute highp vec4 in_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 100
					
					#ifdef GL_FRAGMENT_PRECISION_HIGH
					    precision highp float;
					#else
					    precision mediump float;
					#endif
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _Gradient;
					uniform lowp sampler2D _MainTexMask;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					lowp float u_xlat10_9;
					const int BITWISE_BIT_COUNT = 32;
					int op_modi(int x, int y) { return x - y * (x / y); }
					ivec2 op_modi(ivec2 a, ivec2 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); return a; }
					ivec3 op_modi(ivec3 a, ivec3 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); return a; }
					ivec4 op_modi(ivec4 a, ivec4 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); a.w = op_modi(a.w, b.w); return a; }
					
					int op_and(int a, int b) { int result = 0; int n = 1; for (int i = 0; i < BITWISE_BIT_COUNT; i++) { if ((op_modi(a, 2) != 0) && (op_modi(b, 2) != 0)) { result += n; } a = a / 2; b = b / 2; n = n * 2; if (!(a > 0 && b > 0)) { break; } } return result; }
					ivec2 op_and(ivec2 a, ivec2 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); return a; }
					ivec3 op_and(ivec3 a, ivec3 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); return a; }
					ivec4 op_and(ivec4 a, ivec4 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); a.w = op_and(a.w, b.w); return a; }
					
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat10_0.x = texture2D(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat10_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat10_1 = texture2D(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_0.xyz = texture2D(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat10_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat10_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat10_9 = texture2D(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat10_9) * u_xlat0.xyz;
					    u_xlat2.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat10_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    SV_Target0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat10_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat10_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier00 " {
					Keywords { "DIRECTIONAL" "LIGHTPROBE_SH" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					in highp vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _Gradient;
					uniform mediump sampler2D _MainTexMask;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					mediump float u_xlat16_9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat16_0.x = texture(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat16_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat16_1 = texture(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_0.xyz = texture(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat16_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat16_9 = texture(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat16_9) * u_xlat0.xyz;
					    u_xlat2.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat16_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    SV_Target0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat16_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat16_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier01 " {
					Keywords { "DIRECTIONAL" "LIGHTPROBE_SH" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					in highp vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _Gradient;
					uniform mediump sampler2D _MainTexMask;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					mediump float u_xlat16_9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat16_0.x = texture(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat16_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat16_1 = texture(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_0.xyz = texture(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat16_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat16_9 = texture(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat16_9) * u_xlat0.xyz;
					    u_xlat2.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat16_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    SV_Target0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat16_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat16_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier02 " {
					Keywords { "DIRECTIONAL" "LIGHTPROBE_SH" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					in highp vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _Gradient;
					uniform mediump sampler2D _MainTexMask;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					mediump float u_xlat16_9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat16_0.x = texture(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat16_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat16_1 = texture(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_0.xyz = texture(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat16_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat16_9 = texture(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat16_9) * u_xlat0.xyz;
					    u_xlat2.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat16_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    SV_Target0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat16_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat16_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier00 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 unity_FogParams;
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					attribute highp vec4 in_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD1 = u_xlat0.z * unity_FogParams.z + unity_FogParams.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 100
					
					#ifdef GL_FRAGMENT_PRECISION_HIGH
					    precision highp float;
					#else
					    precision mediump float;
					#endif
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	mediump vec4 unity_FogColor;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _Gradient;
					uniform lowp sampler2D _MainTexMask;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					lowp float u_xlat10_9;
					const int BITWISE_BIT_COUNT = 32;
					int op_modi(int x, int y) { return x - y * (x / y); }
					ivec2 op_modi(ivec2 a, ivec2 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); return a; }
					ivec3 op_modi(ivec3 a, ivec3 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); return a; }
					ivec4 op_modi(ivec4 a, ivec4 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); a.w = op_modi(a.w, b.w); return a; }
					
					int op_and(int a, int b) { int result = 0; int n = 1; for (int i = 0; i < BITWISE_BIT_COUNT; i++) { if ((op_modi(a, 2) != 0) && (op_modi(b, 2) != 0)) { result += n; } a = a / 2; b = b / 2; n = n * 2; if (!(a > 0 && b > 0)) { break; } } return result; }
					ivec2 op_and(ivec2 a, ivec2 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); return a; }
					ivec3 op_and(ivec3 a, ivec3 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); return a; }
					ivec4 op_and(ivec4 a, ivec4 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); a.w = op_and(a.w, b.w); return a; }
					
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat10_0.x = texture2D(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat10_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat10_1 = texture2D(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_0.xyz = texture2D(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat10_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat10_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat10_9 = texture2D(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat10_9) * u_xlat0.xyz;
					    u_xlat2.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat10_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + (-unity_FogColor.xyz);
					    u_xlat1.x = vs_TEXCOORD1;
					    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
					    SV_Target0.xyz = u_xlat1.xxx * u_xlat0.xyz + unity_FogColor.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat10_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat10_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier01 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 unity_FogParams;
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					attribute highp vec4 in_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD1 = u_xlat0.z * unity_FogParams.z + unity_FogParams.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 100
					
					#ifdef GL_FRAGMENT_PRECISION_HIGH
					    precision highp float;
					#else
					    precision mediump float;
					#endif
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	mediump vec4 unity_FogColor;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _Gradient;
					uniform lowp sampler2D _MainTexMask;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					lowp float u_xlat10_9;
					const int BITWISE_BIT_COUNT = 32;
					int op_modi(int x, int y) { return x - y * (x / y); }
					ivec2 op_modi(ivec2 a, ivec2 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); return a; }
					ivec3 op_modi(ivec3 a, ivec3 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); return a; }
					ivec4 op_modi(ivec4 a, ivec4 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); a.w = op_modi(a.w, b.w); return a; }
					
					int op_and(int a, int b) { int result = 0; int n = 1; for (int i = 0; i < BITWISE_BIT_COUNT; i++) { if ((op_modi(a, 2) != 0) && (op_modi(b, 2) != 0)) { result += n; } a = a / 2; b = b / 2; n = n * 2; if (!(a > 0 && b > 0)) { break; } } return result; }
					ivec2 op_and(ivec2 a, ivec2 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); return a; }
					ivec3 op_and(ivec3 a, ivec3 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); return a; }
					ivec4 op_and(ivec4 a, ivec4 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); a.w = op_and(a.w, b.w); return a; }
					
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat10_0.x = texture2D(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat10_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat10_1 = texture2D(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_0.xyz = texture2D(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat10_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat10_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat10_9 = texture2D(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat10_9) * u_xlat0.xyz;
					    u_xlat2.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat10_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + (-unity_FogColor.xyz);
					    u_xlat1.x = vs_TEXCOORD1;
					    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
					    SV_Target0.xyz = u_xlat1.xxx * u_xlat0.xyz + unity_FogColor.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat10_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat10_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier02 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 unity_FogParams;
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					attribute highp vec4 in_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD1 = u_xlat0.z * unity_FogParams.z + unity_FogParams.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 100
					
					#ifdef GL_FRAGMENT_PRECISION_HIGH
					    precision highp float;
					#else
					    precision mediump float;
					#endif
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	mediump vec4 unity_FogColor;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _Gradient;
					uniform lowp sampler2D _MainTexMask;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					lowp float u_xlat10_9;
					const int BITWISE_BIT_COUNT = 32;
					int op_modi(int x, int y) { return x - y * (x / y); }
					ivec2 op_modi(ivec2 a, ivec2 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); return a; }
					ivec3 op_modi(ivec3 a, ivec3 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); return a; }
					ivec4 op_modi(ivec4 a, ivec4 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); a.w = op_modi(a.w, b.w); return a; }
					
					int op_and(int a, int b) { int result = 0; int n = 1; for (int i = 0; i < BITWISE_BIT_COUNT; i++) { if ((op_modi(a, 2) != 0) && (op_modi(b, 2) != 0)) { result += n; } a = a / 2; b = b / 2; n = n * 2; if (!(a > 0 && b > 0)) { break; } } return result; }
					ivec2 op_and(ivec2 a, ivec2 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); return a; }
					ivec3 op_and(ivec3 a, ivec3 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); return a; }
					ivec4 op_and(ivec4 a, ivec4 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); a.w = op_and(a.w, b.w); return a; }
					
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat10_0.x = texture2D(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat10_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat10_1 = texture2D(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_0.xyz = texture2D(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat10_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat10_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat10_9 = texture2D(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat10_9) * u_xlat0.xyz;
					    u_xlat2.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat10_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + (-unity_FogColor.xyz);
					    u_xlat1.x = vs_TEXCOORD1;
					    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
					    SV_Target0.xyz = u_xlat1.xxx * u_xlat0.xyz + unity_FogColor.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat10_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat10_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier00 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 unity_FogParams;
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					in highp vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp float vs_TEXCOORD1;
					out highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD1 = u_xlat0.z * unity_FogParams.z + unity_FogParams.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	mediump vec4 unity_FogColor;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _Gradient;
					uniform mediump sampler2D _MainTexMask;
					in highp vec2 vs_TEXCOORD0;
					in highp float vs_TEXCOORD1;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					mediump float u_xlat16_9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat16_0.x = texture(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat16_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat16_1 = texture(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_0.xyz = texture(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat16_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat16_9 = texture(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat16_9) * u_xlat0.xyz;
					    u_xlat2.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat16_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + (-unity_FogColor.xyz);
					    u_xlat1.x = vs_TEXCOORD1;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat1.x = min(max(u_xlat1.x, 0.0), 1.0);
					#else
					    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = u_xlat1.xxx * u_xlat0.xyz + unity_FogColor.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat16_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat16_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier01 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 unity_FogParams;
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					in highp vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp float vs_TEXCOORD1;
					out highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD1 = u_xlat0.z * unity_FogParams.z + unity_FogParams.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	mediump vec4 unity_FogColor;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _Gradient;
					uniform mediump sampler2D _MainTexMask;
					in highp vec2 vs_TEXCOORD0;
					in highp float vs_TEXCOORD1;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					mediump float u_xlat16_9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat16_0.x = texture(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat16_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat16_1 = texture(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_0.xyz = texture(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat16_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat16_9 = texture(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat16_9) * u_xlat0.xyz;
					    u_xlat2.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat16_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + (-unity_FogColor.xyz);
					    u_xlat1.x = vs_TEXCOORD1;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat1.x = min(max(u_xlat1.x, 0.0), 1.0);
					#else
					    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = u_xlat1.xxx * u_xlat0.xyz + unity_FogColor.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat16_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat16_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier02 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 unity_FogParams;
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					in highp vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp float vs_TEXCOORD1;
					out highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD1 = u_xlat0.z * unity_FogParams.z + unity_FogParams.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	mediump vec4 unity_FogColor;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _Gradient;
					uniform mediump sampler2D _MainTexMask;
					in highp vec2 vs_TEXCOORD0;
					in highp float vs_TEXCOORD1;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					mediump float u_xlat16_9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat16_0.x = texture(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat16_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat16_1 = texture(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_0.xyz = texture(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat16_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat16_9 = texture(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat16_9) * u_xlat0.xyz;
					    u_xlat2.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat16_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + (-unity_FogColor.xyz);
					    u_xlat1.x = vs_TEXCOORD1;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat1.x = min(max(u_xlat1.x, 0.0), 1.0);
					#else
					    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = u_xlat1.xxx * u_xlat0.xyz + unity_FogColor.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat16_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat16_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier00 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTPROBE_SH" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 unity_FogParams;
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					attribute highp vec4 in_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD1 = u_xlat0.z * unity_FogParams.z + unity_FogParams.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 100
					
					#ifdef GL_FRAGMENT_PRECISION_HIGH
					    precision highp float;
					#else
					    precision mediump float;
					#endif
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	mediump vec4 unity_FogColor;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _Gradient;
					uniform lowp sampler2D _MainTexMask;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					lowp float u_xlat10_9;
					const int BITWISE_BIT_COUNT = 32;
					int op_modi(int x, int y) { return x - y * (x / y); }
					ivec2 op_modi(ivec2 a, ivec2 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); return a; }
					ivec3 op_modi(ivec3 a, ivec3 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); return a; }
					ivec4 op_modi(ivec4 a, ivec4 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); a.w = op_modi(a.w, b.w); return a; }
					
					int op_and(int a, int b) { int result = 0; int n = 1; for (int i = 0; i < BITWISE_BIT_COUNT; i++) { if ((op_modi(a, 2) != 0) && (op_modi(b, 2) != 0)) { result += n; } a = a / 2; b = b / 2; n = n * 2; if (!(a > 0 && b > 0)) { break; } } return result; }
					ivec2 op_and(ivec2 a, ivec2 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); return a; }
					ivec3 op_and(ivec3 a, ivec3 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); return a; }
					ivec4 op_and(ivec4 a, ivec4 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); a.w = op_and(a.w, b.w); return a; }
					
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat10_0.x = texture2D(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat10_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat10_1 = texture2D(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_0.xyz = texture2D(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat10_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat10_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat10_9 = texture2D(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat10_9) * u_xlat0.xyz;
					    u_xlat2.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat10_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + (-unity_FogColor.xyz);
					    u_xlat1.x = vs_TEXCOORD1;
					    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
					    SV_Target0.xyz = u_xlat1.xxx * u_xlat0.xyz + unity_FogColor.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat10_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat10_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier01 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTPROBE_SH" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 unity_FogParams;
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					attribute highp vec4 in_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD1 = u_xlat0.z * unity_FogParams.z + unity_FogParams.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 100
					
					#ifdef GL_FRAGMENT_PRECISION_HIGH
					    precision highp float;
					#else
					    precision mediump float;
					#endif
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	mediump vec4 unity_FogColor;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _Gradient;
					uniform lowp sampler2D _MainTexMask;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					lowp float u_xlat10_9;
					const int BITWISE_BIT_COUNT = 32;
					int op_modi(int x, int y) { return x - y * (x / y); }
					ivec2 op_modi(ivec2 a, ivec2 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); return a; }
					ivec3 op_modi(ivec3 a, ivec3 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); return a; }
					ivec4 op_modi(ivec4 a, ivec4 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); a.w = op_modi(a.w, b.w); return a; }
					
					int op_and(int a, int b) { int result = 0; int n = 1; for (int i = 0; i < BITWISE_BIT_COUNT; i++) { if ((op_modi(a, 2) != 0) && (op_modi(b, 2) != 0)) { result += n; } a = a / 2; b = b / 2; n = n * 2; if (!(a > 0 && b > 0)) { break; } } return result; }
					ivec2 op_and(ivec2 a, ivec2 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); return a; }
					ivec3 op_and(ivec3 a, ivec3 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); return a; }
					ivec4 op_and(ivec4 a, ivec4 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); a.w = op_and(a.w, b.w); return a; }
					
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat10_0.x = texture2D(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat10_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat10_1 = texture2D(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_0.xyz = texture2D(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat10_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat10_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat10_9 = texture2D(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat10_9) * u_xlat0.xyz;
					    u_xlat2.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat10_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + (-unity_FogColor.xyz);
					    u_xlat1.x = vs_TEXCOORD1;
					    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
					    SV_Target0.xyz = u_xlat1.xxx * u_xlat0.xyz + unity_FogColor.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat10_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat10_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier02 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTPROBE_SH" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 unity_FogParams;
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					attribute highp vec4 in_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD1 = u_xlat0.z * unity_FogParams.z + unity_FogParams.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 100
					
					#ifdef GL_FRAGMENT_PRECISION_HIGH
					    precision highp float;
					#else
					    precision mediump float;
					#endif
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	mediump vec4 unity_FogColor;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _Gradient;
					uniform lowp sampler2D _MainTexMask;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					lowp float u_xlat10_9;
					const int BITWISE_BIT_COUNT = 32;
					int op_modi(int x, int y) { return x - y * (x / y); }
					ivec2 op_modi(ivec2 a, ivec2 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); return a; }
					ivec3 op_modi(ivec3 a, ivec3 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); return a; }
					ivec4 op_modi(ivec4 a, ivec4 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); a.w = op_modi(a.w, b.w); return a; }
					
					int op_and(int a, int b) { int result = 0; int n = 1; for (int i = 0; i < BITWISE_BIT_COUNT; i++) { if ((op_modi(a, 2) != 0) && (op_modi(b, 2) != 0)) { result += n; } a = a / 2; b = b / 2; n = n * 2; if (!(a > 0 && b > 0)) { break; } } return result; }
					ivec2 op_and(ivec2 a, ivec2 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); return a; }
					ivec3 op_and(ivec3 a, ivec3 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); return a; }
					ivec4 op_and(ivec4 a, ivec4 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); a.w = op_and(a.w, b.w); return a; }
					
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat10_0.x = texture2D(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat10_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat10_1 = texture2D(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_0.xyz = texture2D(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat10_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat10_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat10_9 = texture2D(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat10_9) * u_xlat0.xyz;
					    u_xlat2.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat10_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + (-unity_FogColor.xyz);
					    u_xlat1.x = vs_TEXCOORD1;
					    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
					    SV_Target0.xyz = u_xlat1.xxx * u_xlat0.xyz + unity_FogColor.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat10_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat10_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier00 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTPROBE_SH" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 unity_FogParams;
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					in highp vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp float vs_TEXCOORD1;
					out highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD1 = u_xlat0.z * unity_FogParams.z + unity_FogParams.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	mediump vec4 unity_FogColor;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _Gradient;
					uniform mediump sampler2D _MainTexMask;
					in highp vec2 vs_TEXCOORD0;
					in highp float vs_TEXCOORD1;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					mediump float u_xlat16_9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat16_0.x = texture(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat16_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat16_1 = texture(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_0.xyz = texture(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat16_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat16_9 = texture(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat16_9) * u_xlat0.xyz;
					    u_xlat2.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat16_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + (-unity_FogColor.xyz);
					    u_xlat1.x = vs_TEXCOORD1;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat1.x = min(max(u_xlat1.x, 0.0), 1.0);
					#else
					    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = u_xlat1.xxx * u_xlat0.xyz + unity_FogColor.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat16_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat16_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier01 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTPROBE_SH" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 unity_FogParams;
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					in highp vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp float vs_TEXCOORD1;
					out highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD1 = u_xlat0.z * unity_FogParams.z + unity_FogParams.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	mediump vec4 unity_FogColor;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _Gradient;
					uniform mediump sampler2D _MainTexMask;
					in highp vec2 vs_TEXCOORD0;
					in highp float vs_TEXCOORD1;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					mediump float u_xlat16_9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat16_0.x = texture(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat16_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat16_1 = texture(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_0.xyz = texture(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat16_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat16_9 = texture(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat16_9) * u_xlat0.xyz;
					    u_xlat2.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat16_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + (-unity_FogColor.xyz);
					    u_xlat1.x = vs_TEXCOORD1;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat1.x = min(max(u_xlat1.x, 0.0), 1.0);
					#else
					    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = u_xlat1.xxx * u_xlat0.xyz + unity_FogColor.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat16_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat16_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier02 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTPROBE_SH" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 unity_FogParams;
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					in highp vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp float vs_TEXCOORD1;
					out highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD1 = u_xlat0.z * unity_FogParams.z + unity_FogParams.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	mediump vec4 unity_FogColor;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _Gradient;
					uniform mediump sampler2D _MainTexMask;
					in highp vec2 vs_TEXCOORD0;
					in highp float vs_TEXCOORD1;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					mediump float u_xlat16_9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat16_0.x = texture(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat16_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat16_1 = texture(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_0.xyz = texture(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat16_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat16_9 = texture(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat16_9) * u_xlat0.xyz;
					    u_xlat2.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat16_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + (-unity_FogColor.xyz);
					    u_xlat1.x = vs_TEXCOORD1;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat1.x = min(max(u_xlat1.x, 0.0), 1.0);
					#else
					    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = u_xlat1.xxx * u_xlat0.xyz + unity_FogColor.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat16_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat16_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier00 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTMAP_ON" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 unity_FogParams;
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					attribute highp vec4 in_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD1 = u_xlat0.z * unity_FogParams.z + unity_FogParams.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 100
					
					#ifdef GL_FRAGMENT_PRECISION_HIGH
					    precision highp float;
					#else
					    precision mediump float;
					#endif
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	mediump vec4 unity_FogColor;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _Gradient;
					uniform lowp sampler2D _MainTexMask;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					lowp float u_xlat10_9;
					const int BITWISE_BIT_COUNT = 32;
					int op_modi(int x, int y) { return x - y * (x / y); }
					ivec2 op_modi(ivec2 a, ivec2 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); return a; }
					ivec3 op_modi(ivec3 a, ivec3 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); return a; }
					ivec4 op_modi(ivec4 a, ivec4 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); a.w = op_modi(a.w, b.w); return a; }
					
					int op_and(int a, int b) { int result = 0; int n = 1; for (int i = 0; i < BITWISE_BIT_COUNT; i++) { if ((op_modi(a, 2) != 0) && (op_modi(b, 2) != 0)) { result += n; } a = a / 2; b = b / 2; n = n * 2; if (!(a > 0 && b > 0)) { break; } } return result; }
					ivec2 op_and(ivec2 a, ivec2 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); return a; }
					ivec3 op_and(ivec3 a, ivec3 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); return a; }
					ivec4 op_and(ivec4 a, ivec4 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); a.w = op_and(a.w, b.w); return a; }
					
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat10_0.x = texture2D(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat10_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat10_1 = texture2D(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_0.xyz = texture2D(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat10_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat10_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat10_9 = texture2D(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat10_9) * u_xlat0.xyz;
					    u_xlat2.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat10_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + (-unity_FogColor.xyz);
					    u_xlat1.x = vs_TEXCOORD1;
					    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
					    SV_Target0.xyz = u_xlat1.xxx * u_xlat0.xyz + unity_FogColor.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat10_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat10_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier01 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTMAP_ON" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 unity_FogParams;
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					attribute highp vec4 in_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD1 = u_xlat0.z * unity_FogParams.z + unity_FogParams.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 100
					
					#ifdef GL_FRAGMENT_PRECISION_HIGH
					    precision highp float;
					#else
					    precision mediump float;
					#endif
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	mediump vec4 unity_FogColor;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _Gradient;
					uniform lowp sampler2D _MainTexMask;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					lowp float u_xlat10_9;
					const int BITWISE_BIT_COUNT = 32;
					int op_modi(int x, int y) { return x - y * (x / y); }
					ivec2 op_modi(ivec2 a, ivec2 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); return a; }
					ivec3 op_modi(ivec3 a, ivec3 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); return a; }
					ivec4 op_modi(ivec4 a, ivec4 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); a.w = op_modi(a.w, b.w); return a; }
					
					int op_and(int a, int b) { int result = 0; int n = 1; for (int i = 0; i < BITWISE_BIT_COUNT; i++) { if ((op_modi(a, 2) != 0) && (op_modi(b, 2) != 0)) { result += n; } a = a / 2; b = b / 2; n = n * 2; if (!(a > 0 && b > 0)) { break; } } return result; }
					ivec2 op_and(ivec2 a, ivec2 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); return a; }
					ivec3 op_and(ivec3 a, ivec3 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); return a; }
					ivec4 op_and(ivec4 a, ivec4 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); a.w = op_and(a.w, b.w); return a; }
					
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat10_0.x = texture2D(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat10_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat10_1 = texture2D(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_0.xyz = texture2D(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat10_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat10_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat10_9 = texture2D(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat10_9) * u_xlat0.xyz;
					    u_xlat2.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat10_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + (-unity_FogColor.xyz);
					    u_xlat1.x = vs_TEXCOORD1;
					    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
					    SV_Target0.xyz = u_xlat1.xxx * u_xlat0.xyz + unity_FogColor.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat10_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat10_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier02 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTMAP_ON" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 unity_FogParams;
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					attribute highp vec4 in_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD1 = u_xlat0.z * unity_FogParams.z + unity_FogParams.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 100
					
					#ifdef GL_FRAGMENT_PRECISION_HIGH
					    precision highp float;
					#else
					    precision mediump float;
					#endif
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	mediump vec4 unity_FogColor;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _Gradient;
					uniform lowp sampler2D _MainTexMask;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					lowp float u_xlat10_9;
					const int BITWISE_BIT_COUNT = 32;
					int op_modi(int x, int y) { return x - y * (x / y); }
					ivec2 op_modi(ivec2 a, ivec2 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); return a; }
					ivec3 op_modi(ivec3 a, ivec3 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); return a; }
					ivec4 op_modi(ivec4 a, ivec4 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); a.w = op_modi(a.w, b.w); return a; }
					
					int op_and(int a, int b) { int result = 0; int n = 1; for (int i = 0; i < BITWISE_BIT_COUNT; i++) { if ((op_modi(a, 2) != 0) && (op_modi(b, 2) != 0)) { result += n; } a = a / 2; b = b / 2; n = n * 2; if (!(a > 0 && b > 0)) { break; } } return result; }
					ivec2 op_and(ivec2 a, ivec2 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); return a; }
					ivec3 op_and(ivec3 a, ivec3 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); return a; }
					ivec4 op_and(ivec4 a, ivec4 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); a.w = op_and(a.w, b.w); return a; }
					
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat10_0.x = texture2D(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat10_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat10_1 = texture2D(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_0.xyz = texture2D(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat10_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat10_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat10_9 = texture2D(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat10_9) * u_xlat0.xyz;
					    u_xlat2.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat10_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + (-unity_FogColor.xyz);
					    u_xlat1.x = vs_TEXCOORD1;
					    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
					    SV_Target0.xyz = u_xlat1.xxx * u_xlat0.xyz + unity_FogColor.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat10_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat10_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier00 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTMAP_ON" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 unity_FogParams;
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					in highp vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp float vs_TEXCOORD1;
					out highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD1 = u_xlat0.z * unity_FogParams.z + unity_FogParams.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	mediump vec4 unity_FogColor;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _Gradient;
					uniform mediump sampler2D _MainTexMask;
					in highp vec2 vs_TEXCOORD0;
					in highp float vs_TEXCOORD1;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					mediump float u_xlat16_9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat16_0.x = texture(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat16_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat16_1 = texture(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_0.xyz = texture(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat16_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat16_9 = texture(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat16_9) * u_xlat0.xyz;
					    u_xlat2.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat16_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + (-unity_FogColor.xyz);
					    u_xlat1.x = vs_TEXCOORD1;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat1.x = min(max(u_xlat1.x, 0.0), 1.0);
					#else
					    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = u_xlat1.xxx * u_xlat0.xyz + unity_FogColor.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat16_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat16_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier01 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTMAP_ON" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 unity_FogParams;
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					in highp vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp float vs_TEXCOORD1;
					out highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD1 = u_xlat0.z * unity_FogParams.z + unity_FogParams.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	mediump vec4 unity_FogColor;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _Gradient;
					uniform mediump sampler2D _MainTexMask;
					in highp vec2 vs_TEXCOORD0;
					in highp float vs_TEXCOORD1;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					mediump float u_xlat16_9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat16_0.x = texture(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat16_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat16_1 = texture(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_0.xyz = texture(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat16_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat16_9 = texture(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat16_9) * u_xlat0.xyz;
					    u_xlat2.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat16_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + (-unity_FogColor.xyz);
					    u_xlat1.x = vs_TEXCOORD1;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat1.x = min(max(u_xlat1.x, 0.0), 1.0);
					#else
					    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = u_xlat1.xxx * u_xlat0.xyz + unity_FogColor.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat16_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat16_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier02 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTMAP_ON" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 unity_FogParams;
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					in highp vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp float vs_TEXCOORD1;
					out highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD1 = u_xlat0.z * unity_FogParams.z + unity_FogParams.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	mediump vec4 unity_FogColor;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _Gradient;
					uniform mediump sampler2D _MainTexMask;
					in highp vec2 vs_TEXCOORD0;
					in highp float vs_TEXCOORD1;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					mediump float u_xlat16_9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat16_0.x = texture(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat16_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat16_1 = texture(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_0.xyz = texture(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat16_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat16_9 = texture(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat16_9) * u_xlat0.xyz;
					    u_xlat2.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat16_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + (-unity_FogColor.xyz);
					    u_xlat1.x = vs_TEXCOORD1;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat1.x = min(max(u_xlat1.x, 0.0), 1.0);
					#else
					    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = u_xlat1.xxx * u_xlat0.xyz + unity_FogColor.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat16_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat16_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier00 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTMAP_ON" "LIGHTPROBE_SH" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 unity_FogParams;
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					attribute highp vec4 in_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD1 = u_xlat0.z * unity_FogParams.z + unity_FogParams.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 100
					
					#ifdef GL_FRAGMENT_PRECISION_HIGH
					    precision highp float;
					#else
					    precision mediump float;
					#endif
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	mediump vec4 unity_FogColor;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _Gradient;
					uniform lowp sampler2D _MainTexMask;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					lowp float u_xlat10_9;
					const int BITWISE_BIT_COUNT = 32;
					int op_modi(int x, int y) { return x - y * (x / y); }
					ivec2 op_modi(ivec2 a, ivec2 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); return a; }
					ivec3 op_modi(ivec3 a, ivec3 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); return a; }
					ivec4 op_modi(ivec4 a, ivec4 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); a.w = op_modi(a.w, b.w); return a; }
					
					int op_and(int a, int b) { int result = 0; int n = 1; for (int i = 0; i < BITWISE_BIT_COUNT; i++) { if ((op_modi(a, 2) != 0) && (op_modi(b, 2) != 0)) { result += n; } a = a / 2; b = b / 2; n = n * 2; if (!(a > 0 && b > 0)) { break; } } return result; }
					ivec2 op_and(ivec2 a, ivec2 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); return a; }
					ivec3 op_and(ivec3 a, ivec3 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); return a; }
					ivec4 op_and(ivec4 a, ivec4 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); a.w = op_and(a.w, b.w); return a; }
					
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat10_0.x = texture2D(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat10_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat10_1 = texture2D(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_0.xyz = texture2D(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat10_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat10_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat10_9 = texture2D(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat10_9) * u_xlat0.xyz;
					    u_xlat2.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat10_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + (-unity_FogColor.xyz);
					    u_xlat1.x = vs_TEXCOORD1;
					    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
					    SV_Target0.xyz = u_xlat1.xxx * u_xlat0.xyz + unity_FogColor.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat10_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat10_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier01 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTMAP_ON" "LIGHTPROBE_SH" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 unity_FogParams;
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					attribute highp vec4 in_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD1 = u_xlat0.z * unity_FogParams.z + unity_FogParams.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 100
					
					#ifdef GL_FRAGMENT_PRECISION_HIGH
					    precision highp float;
					#else
					    precision mediump float;
					#endif
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	mediump vec4 unity_FogColor;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _Gradient;
					uniform lowp sampler2D _MainTexMask;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					lowp float u_xlat10_9;
					const int BITWISE_BIT_COUNT = 32;
					int op_modi(int x, int y) { return x - y * (x / y); }
					ivec2 op_modi(ivec2 a, ivec2 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); return a; }
					ivec3 op_modi(ivec3 a, ivec3 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); return a; }
					ivec4 op_modi(ivec4 a, ivec4 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); a.w = op_modi(a.w, b.w); return a; }
					
					int op_and(int a, int b) { int result = 0; int n = 1; for (int i = 0; i < BITWISE_BIT_COUNT; i++) { if ((op_modi(a, 2) != 0) && (op_modi(b, 2) != 0)) { result += n; } a = a / 2; b = b / 2; n = n * 2; if (!(a > 0 && b > 0)) { break; } } return result; }
					ivec2 op_and(ivec2 a, ivec2 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); return a; }
					ivec3 op_and(ivec3 a, ivec3 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); return a; }
					ivec4 op_and(ivec4 a, ivec4 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); a.w = op_and(a.w, b.w); return a; }
					
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat10_0.x = texture2D(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat10_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat10_1 = texture2D(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_0.xyz = texture2D(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat10_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat10_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat10_9 = texture2D(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat10_9) * u_xlat0.xyz;
					    u_xlat2.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat10_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + (-unity_FogColor.xyz);
					    u_xlat1.x = vs_TEXCOORD1;
					    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
					    SV_Target0.xyz = u_xlat1.xxx * u_xlat0.xyz + unity_FogColor.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat10_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat10_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier02 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTMAP_ON" "LIGHTPROBE_SH" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 unity_FogParams;
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					attribute highp vec4 in_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD1 = u_xlat0.z * unity_FogParams.z + unity_FogParams.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 100
					
					#ifdef GL_FRAGMENT_PRECISION_HIGH
					    precision highp float;
					#else
					    precision mediump float;
					#endif
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	mediump vec4 unity_FogColor;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _Gradient;
					uniform lowp sampler2D _MainTexMask;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					lowp float u_xlat10_9;
					const int BITWISE_BIT_COUNT = 32;
					int op_modi(int x, int y) { return x - y * (x / y); }
					ivec2 op_modi(ivec2 a, ivec2 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); return a; }
					ivec3 op_modi(ivec3 a, ivec3 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); return a; }
					ivec4 op_modi(ivec4 a, ivec4 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); a.w = op_modi(a.w, b.w); return a; }
					
					int op_and(int a, int b) { int result = 0; int n = 1; for (int i = 0; i < BITWISE_BIT_COUNT; i++) { if ((op_modi(a, 2) != 0) && (op_modi(b, 2) != 0)) { result += n; } a = a / 2; b = b / 2; n = n * 2; if (!(a > 0 && b > 0)) { break; } } return result; }
					ivec2 op_and(ivec2 a, ivec2 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); return a; }
					ivec3 op_and(ivec3 a, ivec3 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); return a; }
					ivec4 op_and(ivec4 a, ivec4 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); a.w = op_and(a.w, b.w); return a; }
					
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat10_0.x = texture2D(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat10_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat10_1 = texture2D(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_0.xyz = texture2D(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat10_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat10_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat10_9 = texture2D(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat10_9) * u_xlat0.xyz;
					    u_xlat2.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat10_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + (-unity_FogColor.xyz);
					    u_xlat1.x = vs_TEXCOORD1;
					    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
					    SV_Target0.xyz = u_xlat1.xxx * u_xlat0.xyz + unity_FogColor.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat10_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat10_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier00 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTMAP_ON" "LIGHTPROBE_SH" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 unity_FogParams;
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					in highp vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp float vs_TEXCOORD1;
					out highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD1 = u_xlat0.z * unity_FogParams.z + unity_FogParams.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	mediump vec4 unity_FogColor;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _Gradient;
					uniform mediump sampler2D _MainTexMask;
					in highp vec2 vs_TEXCOORD0;
					in highp float vs_TEXCOORD1;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					mediump float u_xlat16_9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat16_0.x = texture(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat16_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat16_1 = texture(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_0.xyz = texture(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat16_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat16_9 = texture(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat16_9) * u_xlat0.xyz;
					    u_xlat2.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat16_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + (-unity_FogColor.xyz);
					    u_xlat1.x = vs_TEXCOORD1;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat1.x = min(max(u_xlat1.x, 0.0), 1.0);
					#else
					    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = u_xlat1.xxx * u_xlat0.xyz + unity_FogColor.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat16_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat16_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier01 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTMAP_ON" "LIGHTPROBE_SH" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 unity_FogParams;
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					in highp vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp float vs_TEXCOORD1;
					out highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD1 = u_xlat0.z * unity_FogParams.z + unity_FogParams.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	mediump vec4 unity_FogColor;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _Gradient;
					uniform mediump sampler2D _MainTexMask;
					in highp vec2 vs_TEXCOORD0;
					in highp float vs_TEXCOORD1;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					mediump float u_xlat16_9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat16_0.x = texture(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat16_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat16_1 = texture(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_0.xyz = texture(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat16_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat16_9 = texture(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat16_9) * u_xlat0.xyz;
					    u_xlat2.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat16_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + (-unity_FogColor.xyz);
					    u_xlat1.x = vs_TEXCOORD1;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat1.x = min(max(u_xlat1.x, 0.0), 1.0);
					#else
					    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = u_xlat1.xxx * u_xlat0.xyz + unity_FogColor.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat16_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat16_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier02 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTMAP_ON" "LIGHTPROBE_SH" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 unity_FogParams;
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					in highp vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp float vs_TEXCOORD1;
					out highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD1 = u_xlat0.z * unity_FogParams.z + unity_FogParams.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	mediump vec4 unity_FogColor;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _Gradient;
					uniform mediump sampler2D _MainTexMask;
					in highp vec2 vs_TEXCOORD0;
					in highp float vs_TEXCOORD1;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					mediump float u_xlat16_9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat16_0.x = texture(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat16_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat16_1 = texture(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_0.xyz = texture(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat16_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat16_9 = texture(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat16_9) * u_xlat0.xyz;
					    u_xlat2.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat16_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + (-unity_FogColor.xyz);
					    u_xlat1.x = vs_TEXCOORD1;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat1.x = min(max(u_xlat1.x, 0.0), 1.0);
					#else
					    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = u_xlat1.xxx * u_xlat0.xyz + unity_FogColor.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat16_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat16_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier00 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "SHADOWS_SCREEN" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 unity_FogParams;
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					attribute highp vec4 in_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD1 = u_xlat0.z * unity_FogParams.z + unity_FogParams.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 100
					
					#ifdef GL_FRAGMENT_PRECISION_HIGH
					    precision highp float;
					#else
					    precision mediump float;
					#endif
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	mediump vec4 unity_FogColor;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _Gradient;
					uniform lowp sampler2D _MainTexMask;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					lowp float u_xlat10_9;
					const int BITWISE_BIT_COUNT = 32;
					int op_modi(int x, int y) { return x - y * (x / y); }
					ivec2 op_modi(ivec2 a, ivec2 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); return a; }
					ivec3 op_modi(ivec3 a, ivec3 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); return a; }
					ivec4 op_modi(ivec4 a, ivec4 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); a.w = op_modi(a.w, b.w); return a; }
					
					int op_and(int a, int b) { int result = 0; int n = 1; for (int i = 0; i < BITWISE_BIT_COUNT; i++) { if ((op_modi(a, 2) != 0) && (op_modi(b, 2) != 0)) { result += n; } a = a / 2; b = b / 2; n = n * 2; if (!(a > 0 && b > 0)) { break; } } return result; }
					ivec2 op_and(ivec2 a, ivec2 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); return a; }
					ivec3 op_and(ivec3 a, ivec3 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); return a; }
					ivec4 op_and(ivec4 a, ivec4 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); a.w = op_and(a.w, b.w); return a; }
					
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat10_0.x = texture2D(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat10_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat10_1 = texture2D(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_0.xyz = texture2D(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat10_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat10_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat10_9 = texture2D(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat10_9) * u_xlat0.xyz;
					    u_xlat2.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat10_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + (-unity_FogColor.xyz);
					    u_xlat1.x = vs_TEXCOORD1;
					    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
					    SV_Target0.xyz = u_xlat1.xxx * u_xlat0.xyz + unity_FogColor.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat10_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat10_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier01 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "SHADOWS_SCREEN" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 unity_FogParams;
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					attribute highp vec4 in_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD1 = u_xlat0.z * unity_FogParams.z + unity_FogParams.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 100
					
					#ifdef GL_FRAGMENT_PRECISION_HIGH
					    precision highp float;
					#else
					    precision mediump float;
					#endif
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	mediump vec4 unity_FogColor;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _Gradient;
					uniform lowp sampler2D _MainTexMask;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					lowp float u_xlat10_9;
					const int BITWISE_BIT_COUNT = 32;
					int op_modi(int x, int y) { return x - y * (x / y); }
					ivec2 op_modi(ivec2 a, ivec2 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); return a; }
					ivec3 op_modi(ivec3 a, ivec3 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); return a; }
					ivec4 op_modi(ivec4 a, ivec4 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); a.w = op_modi(a.w, b.w); return a; }
					
					int op_and(int a, int b) { int result = 0; int n = 1; for (int i = 0; i < BITWISE_BIT_COUNT; i++) { if ((op_modi(a, 2) != 0) && (op_modi(b, 2) != 0)) { result += n; } a = a / 2; b = b / 2; n = n * 2; if (!(a > 0 && b > 0)) { break; } } return result; }
					ivec2 op_and(ivec2 a, ivec2 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); return a; }
					ivec3 op_and(ivec3 a, ivec3 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); return a; }
					ivec4 op_and(ivec4 a, ivec4 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); a.w = op_and(a.w, b.w); return a; }
					
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat10_0.x = texture2D(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat10_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat10_1 = texture2D(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_0.xyz = texture2D(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat10_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat10_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat10_9 = texture2D(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat10_9) * u_xlat0.xyz;
					    u_xlat2.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat10_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + (-unity_FogColor.xyz);
					    u_xlat1.x = vs_TEXCOORD1;
					    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
					    SV_Target0.xyz = u_xlat1.xxx * u_xlat0.xyz + unity_FogColor.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat10_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat10_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier02 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "SHADOWS_SCREEN" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 unity_FogParams;
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					attribute highp vec4 in_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD1 = u_xlat0.z * unity_FogParams.z + unity_FogParams.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 100
					
					#ifdef GL_FRAGMENT_PRECISION_HIGH
					    precision highp float;
					#else
					    precision mediump float;
					#endif
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	mediump vec4 unity_FogColor;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _Gradient;
					uniform lowp sampler2D _MainTexMask;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					lowp float u_xlat10_9;
					const int BITWISE_BIT_COUNT = 32;
					int op_modi(int x, int y) { return x - y * (x / y); }
					ivec2 op_modi(ivec2 a, ivec2 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); return a; }
					ivec3 op_modi(ivec3 a, ivec3 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); return a; }
					ivec4 op_modi(ivec4 a, ivec4 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); a.w = op_modi(a.w, b.w); return a; }
					
					int op_and(int a, int b) { int result = 0; int n = 1; for (int i = 0; i < BITWISE_BIT_COUNT; i++) { if ((op_modi(a, 2) != 0) && (op_modi(b, 2) != 0)) { result += n; } a = a / 2; b = b / 2; n = n * 2; if (!(a > 0 && b > 0)) { break; } } return result; }
					ivec2 op_and(ivec2 a, ivec2 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); return a; }
					ivec3 op_and(ivec3 a, ivec3 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); return a; }
					ivec4 op_and(ivec4 a, ivec4 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); a.w = op_and(a.w, b.w); return a; }
					
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat10_0.x = texture2D(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat10_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat10_1 = texture2D(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_0.xyz = texture2D(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat10_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat10_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat10_9 = texture2D(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat10_9) * u_xlat0.xyz;
					    u_xlat2.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat10_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + (-unity_FogColor.xyz);
					    u_xlat1.x = vs_TEXCOORD1;
					    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
					    SV_Target0.xyz = u_xlat1.xxx * u_xlat0.xyz + unity_FogColor.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat10_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat10_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier00 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "SHADOWS_SCREEN" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 unity_FogParams;
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					in highp vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp float vs_TEXCOORD1;
					out highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD1 = u_xlat0.z * unity_FogParams.z + unity_FogParams.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	mediump vec4 unity_FogColor;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _Gradient;
					uniform mediump sampler2D _MainTexMask;
					in highp vec2 vs_TEXCOORD0;
					in highp float vs_TEXCOORD1;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					mediump float u_xlat16_9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat16_0.x = texture(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat16_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat16_1 = texture(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_0.xyz = texture(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat16_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat16_9 = texture(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat16_9) * u_xlat0.xyz;
					    u_xlat2.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat16_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + (-unity_FogColor.xyz);
					    u_xlat1.x = vs_TEXCOORD1;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat1.x = min(max(u_xlat1.x, 0.0), 1.0);
					#else
					    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = u_xlat1.xxx * u_xlat0.xyz + unity_FogColor.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat16_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat16_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier01 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "SHADOWS_SCREEN" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 unity_FogParams;
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					in highp vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp float vs_TEXCOORD1;
					out highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD1 = u_xlat0.z * unity_FogParams.z + unity_FogParams.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	mediump vec4 unity_FogColor;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _Gradient;
					uniform mediump sampler2D _MainTexMask;
					in highp vec2 vs_TEXCOORD0;
					in highp float vs_TEXCOORD1;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					mediump float u_xlat16_9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat16_0.x = texture(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat16_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat16_1 = texture(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_0.xyz = texture(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat16_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat16_9 = texture(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat16_9) * u_xlat0.xyz;
					    u_xlat2.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat16_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + (-unity_FogColor.xyz);
					    u_xlat1.x = vs_TEXCOORD1;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat1.x = min(max(u_xlat1.x, 0.0), 1.0);
					#else
					    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = u_xlat1.xxx * u_xlat0.xyz + unity_FogColor.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat16_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat16_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier02 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "SHADOWS_SCREEN" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 unity_FogParams;
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					in highp vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp float vs_TEXCOORD1;
					out highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD1 = u_xlat0.z * unity_FogParams.z + unity_FogParams.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	mediump vec4 unity_FogColor;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _Gradient;
					uniform mediump sampler2D _MainTexMask;
					in highp vec2 vs_TEXCOORD0;
					in highp float vs_TEXCOORD1;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					mediump float u_xlat16_9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat16_0.x = texture(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat16_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat16_1 = texture(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_0.xyz = texture(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat16_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat16_9 = texture(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat16_9) * u_xlat0.xyz;
					    u_xlat2.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat16_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + (-unity_FogColor.xyz);
					    u_xlat1.x = vs_TEXCOORD1;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat1.x = min(max(u_xlat1.x, 0.0), 1.0);
					#else
					    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = u_xlat1.xxx * u_xlat0.xyz + unity_FogColor.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat16_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat16_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier00 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTPROBE_SH" "SHADOWS_SCREEN" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 unity_FogParams;
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					attribute highp vec4 in_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD1 = u_xlat0.z * unity_FogParams.z + unity_FogParams.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 100
					
					#ifdef GL_FRAGMENT_PRECISION_HIGH
					    precision highp float;
					#else
					    precision mediump float;
					#endif
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	mediump vec4 unity_FogColor;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _Gradient;
					uniform lowp sampler2D _MainTexMask;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					lowp float u_xlat10_9;
					const int BITWISE_BIT_COUNT = 32;
					int op_modi(int x, int y) { return x - y * (x / y); }
					ivec2 op_modi(ivec2 a, ivec2 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); return a; }
					ivec3 op_modi(ivec3 a, ivec3 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); return a; }
					ivec4 op_modi(ivec4 a, ivec4 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); a.w = op_modi(a.w, b.w); return a; }
					
					int op_and(int a, int b) { int result = 0; int n = 1; for (int i = 0; i < BITWISE_BIT_COUNT; i++) { if ((op_modi(a, 2) != 0) && (op_modi(b, 2) != 0)) { result += n; } a = a / 2; b = b / 2; n = n * 2; if (!(a > 0 && b > 0)) { break; } } return result; }
					ivec2 op_and(ivec2 a, ivec2 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); return a; }
					ivec3 op_and(ivec3 a, ivec3 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); return a; }
					ivec4 op_and(ivec4 a, ivec4 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); a.w = op_and(a.w, b.w); return a; }
					
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat10_0.x = texture2D(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat10_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat10_1 = texture2D(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_0.xyz = texture2D(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat10_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat10_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat10_9 = texture2D(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat10_9) * u_xlat0.xyz;
					    u_xlat2.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat10_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + (-unity_FogColor.xyz);
					    u_xlat1.x = vs_TEXCOORD1;
					    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
					    SV_Target0.xyz = u_xlat1.xxx * u_xlat0.xyz + unity_FogColor.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat10_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat10_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier01 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTPROBE_SH" "SHADOWS_SCREEN" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 unity_FogParams;
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					attribute highp vec4 in_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD1 = u_xlat0.z * unity_FogParams.z + unity_FogParams.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 100
					
					#ifdef GL_FRAGMENT_PRECISION_HIGH
					    precision highp float;
					#else
					    precision mediump float;
					#endif
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	mediump vec4 unity_FogColor;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _Gradient;
					uniform lowp sampler2D _MainTexMask;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					lowp float u_xlat10_9;
					const int BITWISE_BIT_COUNT = 32;
					int op_modi(int x, int y) { return x - y * (x / y); }
					ivec2 op_modi(ivec2 a, ivec2 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); return a; }
					ivec3 op_modi(ivec3 a, ivec3 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); return a; }
					ivec4 op_modi(ivec4 a, ivec4 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); a.w = op_modi(a.w, b.w); return a; }
					
					int op_and(int a, int b) { int result = 0; int n = 1; for (int i = 0; i < BITWISE_BIT_COUNT; i++) { if ((op_modi(a, 2) != 0) && (op_modi(b, 2) != 0)) { result += n; } a = a / 2; b = b / 2; n = n * 2; if (!(a > 0 && b > 0)) { break; } } return result; }
					ivec2 op_and(ivec2 a, ivec2 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); return a; }
					ivec3 op_and(ivec3 a, ivec3 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); return a; }
					ivec4 op_and(ivec4 a, ivec4 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); a.w = op_and(a.w, b.w); return a; }
					
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat10_0.x = texture2D(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat10_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat10_1 = texture2D(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_0.xyz = texture2D(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat10_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat10_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat10_9 = texture2D(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat10_9) * u_xlat0.xyz;
					    u_xlat2.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat10_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + (-unity_FogColor.xyz);
					    u_xlat1.x = vs_TEXCOORD1;
					    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
					    SV_Target0.xyz = u_xlat1.xxx * u_xlat0.xyz + unity_FogColor.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat10_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat10_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier02 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTPROBE_SH" "SHADOWS_SCREEN" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 unity_FogParams;
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					attribute highp vec4 in_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD1 = u_xlat0.z * unity_FogParams.z + unity_FogParams.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 100
					
					#ifdef GL_FRAGMENT_PRECISION_HIGH
					    precision highp float;
					#else
					    precision mediump float;
					#endif
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	mediump vec4 unity_FogColor;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _Gradient;
					uniform lowp sampler2D _MainTexMask;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					lowp float u_xlat10_9;
					const int BITWISE_BIT_COUNT = 32;
					int op_modi(int x, int y) { return x - y * (x / y); }
					ivec2 op_modi(ivec2 a, ivec2 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); return a; }
					ivec3 op_modi(ivec3 a, ivec3 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); return a; }
					ivec4 op_modi(ivec4 a, ivec4 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); a.w = op_modi(a.w, b.w); return a; }
					
					int op_and(int a, int b) { int result = 0; int n = 1; for (int i = 0; i < BITWISE_BIT_COUNT; i++) { if ((op_modi(a, 2) != 0) && (op_modi(b, 2) != 0)) { result += n; } a = a / 2; b = b / 2; n = n * 2; if (!(a > 0 && b > 0)) { break; } } return result; }
					ivec2 op_and(ivec2 a, ivec2 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); return a; }
					ivec3 op_and(ivec3 a, ivec3 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); return a; }
					ivec4 op_and(ivec4 a, ivec4 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); a.w = op_and(a.w, b.w); return a; }
					
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat10_0.x = texture2D(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat10_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat10_1 = texture2D(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_0.xyz = texture2D(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat10_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat10_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat10_9 = texture2D(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat10_9) * u_xlat0.xyz;
					    u_xlat2.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat10_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + (-unity_FogColor.xyz);
					    u_xlat1.x = vs_TEXCOORD1;
					    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
					    SV_Target0.xyz = u_xlat1.xxx * u_xlat0.xyz + unity_FogColor.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat10_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat10_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier00 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTPROBE_SH" "SHADOWS_SCREEN" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 unity_FogParams;
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					in highp vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp float vs_TEXCOORD1;
					out highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD1 = u_xlat0.z * unity_FogParams.z + unity_FogParams.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	mediump vec4 unity_FogColor;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _Gradient;
					uniform mediump sampler2D _MainTexMask;
					in highp vec2 vs_TEXCOORD0;
					in highp float vs_TEXCOORD1;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					mediump float u_xlat16_9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat16_0.x = texture(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat16_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat16_1 = texture(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_0.xyz = texture(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat16_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat16_9 = texture(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat16_9) * u_xlat0.xyz;
					    u_xlat2.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat16_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + (-unity_FogColor.xyz);
					    u_xlat1.x = vs_TEXCOORD1;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat1.x = min(max(u_xlat1.x, 0.0), 1.0);
					#else
					    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = u_xlat1.xxx * u_xlat0.xyz + unity_FogColor.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat16_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat16_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier01 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTPROBE_SH" "SHADOWS_SCREEN" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 unity_FogParams;
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					in highp vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp float vs_TEXCOORD1;
					out highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD1 = u_xlat0.z * unity_FogParams.z + unity_FogParams.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	mediump vec4 unity_FogColor;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _Gradient;
					uniform mediump sampler2D _MainTexMask;
					in highp vec2 vs_TEXCOORD0;
					in highp float vs_TEXCOORD1;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					mediump float u_xlat16_9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat16_0.x = texture(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat16_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat16_1 = texture(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_0.xyz = texture(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat16_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat16_9 = texture(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat16_9) * u_xlat0.xyz;
					    u_xlat2.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat16_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + (-unity_FogColor.xyz);
					    u_xlat1.x = vs_TEXCOORD1;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat1.x = min(max(u_xlat1.x, 0.0), 1.0);
					#else
					    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = u_xlat1.xxx * u_xlat0.xyz + unity_FogColor.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat16_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat16_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier02 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTPROBE_SH" "SHADOWS_SCREEN" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 unity_FogParams;
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					in highp vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp float vs_TEXCOORD1;
					out highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD1 = u_xlat0.z * unity_FogParams.z + unity_FogParams.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	mediump vec4 unity_FogColor;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _Gradient;
					uniform mediump sampler2D _MainTexMask;
					in highp vec2 vs_TEXCOORD0;
					in highp float vs_TEXCOORD1;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					mediump float u_xlat16_9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat16_0.x = texture(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat16_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat16_1 = texture(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_0.xyz = texture(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat16_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat16_9 = texture(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat16_9) * u_xlat0.xyz;
					    u_xlat2.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat16_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + (-unity_FogColor.xyz);
					    u_xlat1.x = vs_TEXCOORD1;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat1.x = min(max(u_xlat1.x, 0.0), 1.0);
					#else
					    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = u_xlat1.xxx * u_xlat0.xyz + unity_FogColor.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat16_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat16_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier00 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTMAP_ON" "SHADOWS_SCREEN" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 unity_FogParams;
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					attribute highp vec4 in_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD1 = u_xlat0.z * unity_FogParams.z + unity_FogParams.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 100
					
					#ifdef GL_FRAGMENT_PRECISION_HIGH
					    precision highp float;
					#else
					    precision mediump float;
					#endif
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	mediump vec4 unity_FogColor;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _Gradient;
					uniform lowp sampler2D _MainTexMask;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					lowp float u_xlat10_9;
					const int BITWISE_BIT_COUNT = 32;
					int op_modi(int x, int y) { return x - y * (x / y); }
					ivec2 op_modi(ivec2 a, ivec2 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); return a; }
					ivec3 op_modi(ivec3 a, ivec3 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); return a; }
					ivec4 op_modi(ivec4 a, ivec4 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); a.w = op_modi(a.w, b.w); return a; }
					
					int op_and(int a, int b) { int result = 0; int n = 1; for (int i = 0; i < BITWISE_BIT_COUNT; i++) { if ((op_modi(a, 2) != 0) && (op_modi(b, 2) != 0)) { result += n; } a = a / 2; b = b / 2; n = n * 2; if (!(a > 0 && b > 0)) { break; } } return result; }
					ivec2 op_and(ivec2 a, ivec2 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); return a; }
					ivec3 op_and(ivec3 a, ivec3 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); return a; }
					ivec4 op_and(ivec4 a, ivec4 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); a.w = op_and(a.w, b.w); return a; }
					
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat10_0.x = texture2D(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat10_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat10_1 = texture2D(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_0.xyz = texture2D(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat10_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat10_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat10_9 = texture2D(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat10_9) * u_xlat0.xyz;
					    u_xlat2.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat10_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + (-unity_FogColor.xyz);
					    u_xlat1.x = vs_TEXCOORD1;
					    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
					    SV_Target0.xyz = u_xlat1.xxx * u_xlat0.xyz + unity_FogColor.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat10_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat10_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier01 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTMAP_ON" "SHADOWS_SCREEN" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 unity_FogParams;
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					attribute highp vec4 in_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD1 = u_xlat0.z * unity_FogParams.z + unity_FogParams.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 100
					
					#ifdef GL_FRAGMENT_PRECISION_HIGH
					    precision highp float;
					#else
					    precision mediump float;
					#endif
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	mediump vec4 unity_FogColor;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _Gradient;
					uniform lowp sampler2D _MainTexMask;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					lowp float u_xlat10_9;
					const int BITWISE_BIT_COUNT = 32;
					int op_modi(int x, int y) { return x - y * (x / y); }
					ivec2 op_modi(ivec2 a, ivec2 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); return a; }
					ivec3 op_modi(ivec3 a, ivec3 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); return a; }
					ivec4 op_modi(ivec4 a, ivec4 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); a.w = op_modi(a.w, b.w); return a; }
					
					int op_and(int a, int b) { int result = 0; int n = 1; for (int i = 0; i < BITWISE_BIT_COUNT; i++) { if ((op_modi(a, 2) != 0) && (op_modi(b, 2) != 0)) { result += n; } a = a / 2; b = b / 2; n = n * 2; if (!(a > 0 && b > 0)) { break; } } return result; }
					ivec2 op_and(ivec2 a, ivec2 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); return a; }
					ivec3 op_and(ivec3 a, ivec3 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); return a; }
					ivec4 op_and(ivec4 a, ivec4 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); a.w = op_and(a.w, b.w); return a; }
					
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat10_0.x = texture2D(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat10_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat10_1 = texture2D(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_0.xyz = texture2D(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat10_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat10_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat10_9 = texture2D(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat10_9) * u_xlat0.xyz;
					    u_xlat2.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat10_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + (-unity_FogColor.xyz);
					    u_xlat1.x = vs_TEXCOORD1;
					    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
					    SV_Target0.xyz = u_xlat1.xxx * u_xlat0.xyz + unity_FogColor.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat10_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat10_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier02 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTMAP_ON" "SHADOWS_SCREEN" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 unity_FogParams;
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					attribute highp vec4 in_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD1 = u_xlat0.z * unity_FogParams.z + unity_FogParams.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 100
					
					#ifdef GL_FRAGMENT_PRECISION_HIGH
					    precision highp float;
					#else
					    precision mediump float;
					#endif
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	mediump vec4 unity_FogColor;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _Gradient;
					uniform lowp sampler2D _MainTexMask;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					lowp float u_xlat10_9;
					const int BITWISE_BIT_COUNT = 32;
					int op_modi(int x, int y) { return x - y * (x / y); }
					ivec2 op_modi(ivec2 a, ivec2 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); return a; }
					ivec3 op_modi(ivec3 a, ivec3 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); return a; }
					ivec4 op_modi(ivec4 a, ivec4 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); a.w = op_modi(a.w, b.w); return a; }
					
					int op_and(int a, int b) { int result = 0; int n = 1; for (int i = 0; i < BITWISE_BIT_COUNT; i++) { if ((op_modi(a, 2) != 0) && (op_modi(b, 2) != 0)) { result += n; } a = a / 2; b = b / 2; n = n * 2; if (!(a > 0 && b > 0)) { break; } } return result; }
					ivec2 op_and(ivec2 a, ivec2 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); return a; }
					ivec3 op_and(ivec3 a, ivec3 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); return a; }
					ivec4 op_and(ivec4 a, ivec4 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); a.w = op_and(a.w, b.w); return a; }
					
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat10_0.x = texture2D(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat10_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat10_1 = texture2D(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_0.xyz = texture2D(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat10_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat10_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat10_9 = texture2D(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat10_9) * u_xlat0.xyz;
					    u_xlat2.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat10_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + (-unity_FogColor.xyz);
					    u_xlat1.x = vs_TEXCOORD1;
					    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
					    SV_Target0.xyz = u_xlat1.xxx * u_xlat0.xyz + unity_FogColor.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat10_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat10_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier00 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTMAP_ON" "SHADOWS_SCREEN" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 unity_FogParams;
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					in highp vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp float vs_TEXCOORD1;
					out highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD1 = u_xlat0.z * unity_FogParams.z + unity_FogParams.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	mediump vec4 unity_FogColor;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _Gradient;
					uniform mediump sampler2D _MainTexMask;
					in highp vec2 vs_TEXCOORD0;
					in highp float vs_TEXCOORD1;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					mediump float u_xlat16_9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat16_0.x = texture(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat16_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat16_1 = texture(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_0.xyz = texture(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat16_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat16_9 = texture(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat16_9) * u_xlat0.xyz;
					    u_xlat2.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat16_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + (-unity_FogColor.xyz);
					    u_xlat1.x = vs_TEXCOORD1;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat1.x = min(max(u_xlat1.x, 0.0), 1.0);
					#else
					    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = u_xlat1.xxx * u_xlat0.xyz + unity_FogColor.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat16_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat16_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier01 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTMAP_ON" "SHADOWS_SCREEN" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 unity_FogParams;
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					in highp vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp float vs_TEXCOORD1;
					out highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD1 = u_xlat0.z * unity_FogParams.z + unity_FogParams.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	mediump vec4 unity_FogColor;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _Gradient;
					uniform mediump sampler2D _MainTexMask;
					in highp vec2 vs_TEXCOORD0;
					in highp float vs_TEXCOORD1;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					mediump float u_xlat16_9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat16_0.x = texture(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat16_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat16_1 = texture(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_0.xyz = texture(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat16_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat16_9 = texture(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat16_9) * u_xlat0.xyz;
					    u_xlat2.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat16_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + (-unity_FogColor.xyz);
					    u_xlat1.x = vs_TEXCOORD1;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat1.x = min(max(u_xlat1.x, 0.0), 1.0);
					#else
					    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = u_xlat1.xxx * u_xlat0.xyz + unity_FogColor.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat16_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat16_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier02 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTMAP_ON" "SHADOWS_SCREEN" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 unity_FogParams;
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					in highp vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp float vs_TEXCOORD1;
					out highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD1 = u_xlat0.z * unity_FogParams.z + unity_FogParams.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	mediump vec4 unity_FogColor;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _Gradient;
					uniform mediump sampler2D _MainTexMask;
					in highp vec2 vs_TEXCOORD0;
					in highp float vs_TEXCOORD1;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					mediump float u_xlat16_9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat16_0.x = texture(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat16_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat16_1 = texture(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_0.xyz = texture(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat16_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat16_9 = texture(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat16_9) * u_xlat0.xyz;
					    u_xlat2.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat16_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + (-unity_FogColor.xyz);
					    u_xlat1.x = vs_TEXCOORD1;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat1.x = min(max(u_xlat1.x, 0.0), 1.0);
					#else
					    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = u_xlat1.xxx * u_xlat0.xyz + unity_FogColor.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat16_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat16_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier00 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTMAP_ON" "LIGHTPROBE_SH" "SHADOWS_SCREEN" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 unity_FogParams;
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					attribute highp vec4 in_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD1 = u_xlat0.z * unity_FogParams.z + unity_FogParams.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 100
					
					#ifdef GL_FRAGMENT_PRECISION_HIGH
					    precision highp float;
					#else
					    precision mediump float;
					#endif
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	mediump vec4 unity_FogColor;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _Gradient;
					uniform lowp sampler2D _MainTexMask;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					lowp float u_xlat10_9;
					const int BITWISE_BIT_COUNT = 32;
					int op_modi(int x, int y) { return x - y * (x / y); }
					ivec2 op_modi(ivec2 a, ivec2 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); return a; }
					ivec3 op_modi(ivec3 a, ivec3 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); return a; }
					ivec4 op_modi(ivec4 a, ivec4 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); a.w = op_modi(a.w, b.w); return a; }
					
					int op_and(int a, int b) { int result = 0; int n = 1; for (int i = 0; i < BITWISE_BIT_COUNT; i++) { if ((op_modi(a, 2) != 0) && (op_modi(b, 2) != 0)) { result += n; } a = a / 2; b = b / 2; n = n * 2; if (!(a > 0 && b > 0)) { break; } } return result; }
					ivec2 op_and(ivec2 a, ivec2 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); return a; }
					ivec3 op_and(ivec3 a, ivec3 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); return a; }
					ivec4 op_and(ivec4 a, ivec4 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); a.w = op_and(a.w, b.w); return a; }
					
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat10_0.x = texture2D(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat10_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat10_1 = texture2D(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_0.xyz = texture2D(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat10_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat10_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat10_9 = texture2D(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat10_9) * u_xlat0.xyz;
					    u_xlat2.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat10_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + (-unity_FogColor.xyz);
					    u_xlat1.x = vs_TEXCOORD1;
					    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
					    SV_Target0.xyz = u_xlat1.xxx * u_xlat0.xyz + unity_FogColor.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat10_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat10_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier01 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTMAP_ON" "LIGHTPROBE_SH" "SHADOWS_SCREEN" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 unity_FogParams;
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					attribute highp vec4 in_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD1 = u_xlat0.z * unity_FogParams.z + unity_FogParams.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 100
					
					#ifdef GL_FRAGMENT_PRECISION_HIGH
					    precision highp float;
					#else
					    precision mediump float;
					#endif
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	mediump vec4 unity_FogColor;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _Gradient;
					uniform lowp sampler2D _MainTexMask;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					lowp float u_xlat10_9;
					const int BITWISE_BIT_COUNT = 32;
					int op_modi(int x, int y) { return x - y * (x / y); }
					ivec2 op_modi(ivec2 a, ivec2 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); return a; }
					ivec3 op_modi(ivec3 a, ivec3 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); return a; }
					ivec4 op_modi(ivec4 a, ivec4 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); a.w = op_modi(a.w, b.w); return a; }
					
					int op_and(int a, int b) { int result = 0; int n = 1; for (int i = 0; i < BITWISE_BIT_COUNT; i++) { if ((op_modi(a, 2) != 0) && (op_modi(b, 2) != 0)) { result += n; } a = a / 2; b = b / 2; n = n * 2; if (!(a > 0 && b > 0)) { break; } } return result; }
					ivec2 op_and(ivec2 a, ivec2 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); return a; }
					ivec3 op_and(ivec3 a, ivec3 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); return a; }
					ivec4 op_and(ivec4 a, ivec4 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); a.w = op_and(a.w, b.w); return a; }
					
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat10_0.x = texture2D(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat10_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat10_1 = texture2D(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_0.xyz = texture2D(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat10_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat10_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat10_9 = texture2D(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat10_9) * u_xlat0.xyz;
					    u_xlat2.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat10_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + (-unity_FogColor.xyz);
					    u_xlat1.x = vs_TEXCOORD1;
					    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
					    SV_Target0.xyz = u_xlat1.xxx * u_xlat0.xyz + unity_FogColor.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat10_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat10_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier02 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTMAP_ON" "LIGHTPROBE_SH" "SHADOWS_SCREEN" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 unity_FogParams;
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					attribute highp vec4 in_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD1 = u_xlat0.z * unity_FogParams.z + unity_FogParams.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 100
					
					#ifdef GL_FRAGMENT_PRECISION_HIGH
					    precision highp float;
					#else
					    precision mediump float;
					#endif
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	mediump vec4 unity_FogColor;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _Gradient;
					uniform lowp sampler2D _MainTexMask;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					lowp float u_xlat10_9;
					const int BITWISE_BIT_COUNT = 32;
					int op_modi(int x, int y) { return x - y * (x / y); }
					ivec2 op_modi(ivec2 a, ivec2 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); return a; }
					ivec3 op_modi(ivec3 a, ivec3 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); return a; }
					ivec4 op_modi(ivec4 a, ivec4 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); a.w = op_modi(a.w, b.w); return a; }
					
					int op_and(int a, int b) { int result = 0; int n = 1; for (int i = 0; i < BITWISE_BIT_COUNT; i++) { if ((op_modi(a, 2) != 0) && (op_modi(b, 2) != 0)) { result += n; } a = a / 2; b = b / 2; n = n * 2; if (!(a > 0 && b > 0)) { break; } } return result; }
					ivec2 op_and(ivec2 a, ivec2 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); return a; }
					ivec3 op_and(ivec3 a, ivec3 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); return a; }
					ivec4 op_and(ivec4 a, ivec4 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); a.w = op_and(a.w, b.w); return a; }
					
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat10_0.x = texture2D(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat10_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat10_1 = texture2D(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_0.xyz = texture2D(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat10_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat10_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat10_9 = texture2D(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat10_9) * u_xlat0.xyz;
					    u_xlat2.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat10_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + (-unity_FogColor.xyz);
					    u_xlat1.x = vs_TEXCOORD1;
					    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
					    SV_Target0.xyz = u_xlat1.xxx * u_xlat0.xyz + unity_FogColor.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat10_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat10_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier00 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTMAP_ON" "LIGHTPROBE_SH" "SHADOWS_SCREEN" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 unity_FogParams;
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					in highp vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp float vs_TEXCOORD1;
					out highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD1 = u_xlat0.z * unity_FogParams.z + unity_FogParams.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	mediump vec4 unity_FogColor;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _Gradient;
					uniform mediump sampler2D _MainTexMask;
					in highp vec2 vs_TEXCOORD0;
					in highp float vs_TEXCOORD1;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					mediump float u_xlat16_9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat16_0.x = texture(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat16_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat16_1 = texture(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_0.xyz = texture(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat16_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat16_9 = texture(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat16_9) * u_xlat0.xyz;
					    u_xlat2.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat16_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + (-unity_FogColor.xyz);
					    u_xlat1.x = vs_TEXCOORD1;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat1.x = min(max(u_xlat1.x, 0.0), 1.0);
					#else
					    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = u_xlat1.xxx * u_xlat0.xyz + unity_FogColor.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat16_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat16_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier01 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTMAP_ON" "LIGHTPROBE_SH" "SHADOWS_SCREEN" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 unity_FogParams;
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					in highp vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp float vs_TEXCOORD1;
					out highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD1 = u_xlat0.z * unity_FogParams.z + unity_FogParams.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	mediump vec4 unity_FogColor;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _Gradient;
					uniform mediump sampler2D _MainTexMask;
					in highp vec2 vs_TEXCOORD0;
					in highp float vs_TEXCOORD1;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					mediump float u_xlat16_9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat16_0.x = texture(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat16_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat16_1 = texture(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_0.xyz = texture(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat16_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat16_9 = texture(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat16_9) * u_xlat0.xyz;
					    u_xlat2.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat16_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + (-unity_FogColor.xyz);
					    u_xlat1.x = vs_TEXCOORD1;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat1.x = min(max(u_xlat1.x, 0.0), 1.0);
					#else
					    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = u_xlat1.xxx * u_xlat0.xyz + unity_FogColor.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat16_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat16_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier02 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTMAP_ON" "LIGHTPROBE_SH" "SHADOWS_SCREEN" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 unity_FogParams;
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					in highp vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp float vs_TEXCOORD1;
					out highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD1 = u_xlat0.z * unity_FogParams.z + unity_FogParams.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	mediump vec4 unity_FogColor;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _Gradient;
					uniform mediump sampler2D _MainTexMask;
					in highp vec2 vs_TEXCOORD0;
					in highp float vs_TEXCOORD1;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					mediump float u_xlat16_9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat16_0.x = texture(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat16_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat16_1 = texture(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_0.xyz = texture(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat16_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat16_9 = texture(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat16_9) * u_xlat0.xyz;
					    u_xlat2.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat16_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + (-unity_FogColor.xyz);
					    u_xlat1.x = vs_TEXCOORD1;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat1.x = min(max(u_xlat1.x, 0.0), 1.0);
					#else
					    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = u_xlat1.xxx * u_xlat0.xyz + unity_FogColor.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat16_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat16_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier00 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "VERTEXLIGHT_ON" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 unity_FogParams;
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					attribute highp vec4 in_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD1 = u_xlat0.z * unity_FogParams.z + unity_FogParams.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 100
					
					#ifdef GL_FRAGMENT_PRECISION_HIGH
					    precision highp float;
					#else
					    precision mediump float;
					#endif
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	mediump vec4 unity_FogColor;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _Gradient;
					uniform lowp sampler2D _MainTexMask;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					lowp float u_xlat10_9;
					const int BITWISE_BIT_COUNT = 32;
					int op_modi(int x, int y) { return x - y * (x / y); }
					ivec2 op_modi(ivec2 a, ivec2 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); return a; }
					ivec3 op_modi(ivec3 a, ivec3 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); return a; }
					ivec4 op_modi(ivec4 a, ivec4 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); a.w = op_modi(a.w, b.w); return a; }
					
					int op_and(int a, int b) { int result = 0; int n = 1; for (int i = 0; i < BITWISE_BIT_COUNT; i++) { if ((op_modi(a, 2) != 0) && (op_modi(b, 2) != 0)) { result += n; } a = a / 2; b = b / 2; n = n * 2; if (!(a > 0 && b > 0)) { break; } } return result; }
					ivec2 op_and(ivec2 a, ivec2 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); return a; }
					ivec3 op_and(ivec3 a, ivec3 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); return a; }
					ivec4 op_and(ivec4 a, ivec4 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); a.w = op_and(a.w, b.w); return a; }
					
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat10_0.x = texture2D(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat10_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat10_1 = texture2D(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_0.xyz = texture2D(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat10_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat10_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat10_9 = texture2D(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat10_9) * u_xlat0.xyz;
					    u_xlat2.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat10_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + (-unity_FogColor.xyz);
					    u_xlat1.x = vs_TEXCOORD1;
					    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
					    SV_Target0.xyz = u_xlat1.xxx * u_xlat0.xyz + unity_FogColor.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat10_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat10_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier01 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "VERTEXLIGHT_ON" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 unity_FogParams;
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					attribute highp vec4 in_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD1 = u_xlat0.z * unity_FogParams.z + unity_FogParams.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 100
					
					#ifdef GL_FRAGMENT_PRECISION_HIGH
					    precision highp float;
					#else
					    precision mediump float;
					#endif
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	mediump vec4 unity_FogColor;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _Gradient;
					uniform lowp sampler2D _MainTexMask;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					lowp float u_xlat10_9;
					const int BITWISE_BIT_COUNT = 32;
					int op_modi(int x, int y) { return x - y * (x / y); }
					ivec2 op_modi(ivec2 a, ivec2 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); return a; }
					ivec3 op_modi(ivec3 a, ivec3 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); return a; }
					ivec4 op_modi(ivec4 a, ivec4 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); a.w = op_modi(a.w, b.w); return a; }
					
					int op_and(int a, int b) { int result = 0; int n = 1; for (int i = 0; i < BITWISE_BIT_COUNT; i++) { if ((op_modi(a, 2) != 0) && (op_modi(b, 2) != 0)) { result += n; } a = a / 2; b = b / 2; n = n * 2; if (!(a > 0 && b > 0)) { break; } } return result; }
					ivec2 op_and(ivec2 a, ivec2 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); return a; }
					ivec3 op_and(ivec3 a, ivec3 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); return a; }
					ivec4 op_and(ivec4 a, ivec4 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); a.w = op_and(a.w, b.w); return a; }
					
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat10_0.x = texture2D(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat10_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat10_1 = texture2D(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_0.xyz = texture2D(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat10_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat10_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat10_9 = texture2D(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat10_9) * u_xlat0.xyz;
					    u_xlat2.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat10_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + (-unity_FogColor.xyz);
					    u_xlat1.x = vs_TEXCOORD1;
					    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
					    SV_Target0.xyz = u_xlat1.xxx * u_xlat0.xyz + unity_FogColor.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat10_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat10_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier02 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "VERTEXLIGHT_ON" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 unity_FogParams;
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					attribute highp vec4 in_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD1 = u_xlat0.z * unity_FogParams.z + unity_FogParams.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 100
					
					#ifdef GL_FRAGMENT_PRECISION_HIGH
					    precision highp float;
					#else
					    precision mediump float;
					#endif
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	mediump vec4 unity_FogColor;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _Gradient;
					uniform lowp sampler2D _MainTexMask;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					lowp float u_xlat10_9;
					const int BITWISE_BIT_COUNT = 32;
					int op_modi(int x, int y) { return x - y * (x / y); }
					ivec2 op_modi(ivec2 a, ivec2 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); return a; }
					ivec3 op_modi(ivec3 a, ivec3 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); return a; }
					ivec4 op_modi(ivec4 a, ivec4 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); a.w = op_modi(a.w, b.w); return a; }
					
					int op_and(int a, int b) { int result = 0; int n = 1; for (int i = 0; i < BITWISE_BIT_COUNT; i++) { if ((op_modi(a, 2) != 0) && (op_modi(b, 2) != 0)) { result += n; } a = a / 2; b = b / 2; n = n * 2; if (!(a > 0 && b > 0)) { break; } } return result; }
					ivec2 op_and(ivec2 a, ivec2 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); return a; }
					ivec3 op_and(ivec3 a, ivec3 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); return a; }
					ivec4 op_and(ivec4 a, ivec4 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); a.w = op_and(a.w, b.w); return a; }
					
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat10_0.x = texture2D(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat10_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat10_1 = texture2D(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_0.xyz = texture2D(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat10_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat10_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat10_9 = texture2D(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat10_9) * u_xlat0.xyz;
					    u_xlat2.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat10_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + (-unity_FogColor.xyz);
					    u_xlat1.x = vs_TEXCOORD1;
					    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
					    SV_Target0.xyz = u_xlat1.xxx * u_xlat0.xyz + unity_FogColor.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat10_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat10_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier00 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "VERTEXLIGHT_ON" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 unity_FogParams;
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					in highp vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp float vs_TEXCOORD1;
					out highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD1 = u_xlat0.z * unity_FogParams.z + unity_FogParams.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	mediump vec4 unity_FogColor;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _Gradient;
					uniform mediump sampler2D _MainTexMask;
					in highp vec2 vs_TEXCOORD0;
					in highp float vs_TEXCOORD1;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					mediump float u_xlat16_9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat16_0.x = texture(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat16_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat16_1 = texture(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_0.xyz = texture(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat16_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat16_9 = texture(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat16_9) * u_xlat0.xyz;
					    u_xlat2.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat16_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + (-unity_FogColor.xyz);
					    u_xlat1.x = vs_TEXCOORD1;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat1.x = min(max(u_xlat1.x, 0.0), 1.0);
					#else
					    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = u_xlat1.xxx * u_xlat0.xyz + unity_FogColor.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat16_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat16_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier01 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "VERTEXLIGHT_ON" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 unity_FogParams;
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					in highp vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp float vs_TEXCOORD1;
					out highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD1 = u_xlat0.z * unity_FogParams.z + unity_FogParams.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	mediump vec4 unity_FogColor;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _Gradient;
					uniform mediump sampler2D _MainTexMask;
					in highp vec2 vs_TEXCOORD0;
					in highp float vs_TEXCOORD1;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					mediump float u_xlat16_9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat16_0.x = texture(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat16_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat16_1 = texture(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_0.xyz = texture(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat16_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat16_9 = texture(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat16_9) * u_xlat0.xyz;
					    u_xlat2.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat16_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + (-unity_FogColor.xyz);
					    u_xlat1.x = vs_TEXCOORD1;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat1.x = min(max(u_xlat1.x, 0.0), 1.0);
					#else
					    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = u_xlat1.xxx * u_xlat0.xyz + unity_FogColor.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat16_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat16_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier02 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "VERTEXLIGHT_ON" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 unity_FogParams;
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					in highp vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp float vs_TEXCOORD1;
					out highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD1 = u_xlat0.z * unity_FogParams.z + unity_FogParams.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	mediump vec4 unity_FogColor;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _Gradient;
					uniform mediump sampler2D _MainTexMask;
					in highp vec2 vs_TEXCOORD0;
					in highp float vs_TEXCOORD1;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					mediump float u_xlat16_9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat16_0.x = texture(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat16_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat16_1 = texture(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_0.xyz = texture(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat16_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat16_9 = texture(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat16_9) * u_xlat0.xyz;
					    u_xlat2.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat16_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + (-unity_FogColor.xyz);
					    u_xlat1.x = vs_TEXCOORD1;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat1.x = min(max(u_xlat1.x, 0.0), 1.0);
					#else
					    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = u_xlat1.xxx * u_xlat0.xyz + unity_FogColor.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat16_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat16_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier00 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTPROBE_SH" "VERTEXLIGHT_ON" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 unity_FogParams;
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					attribute highp vec4 in_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD1 = u_xlat0.z * unity_FogParams.z + unity_FogParams.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 100
					
					#ifdef GL_FRAGMENT_PRECISION_HIGH
					    precision highp float;
					#else
					    precision mediump float;
					#endif
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	mediump vec4 unity_FogColor;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _Gradient;
					uniform lowp sampler2D _MainTexMask;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					lowp float u_xlat10_9;
					const int BITWISE_BIT_COUNT = 32;
					int op_modi(int x, int y) { return x - y * (x / y); }
					ivec2 op_modi(ivec2 a, ivec2 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); return a; }
					ivec3 op_modi(ivec3 a, ivec3 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); return a; }
					ivec4 op_modi(ivec4 a, ivec4 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); a.w = op_modi(a.w, b.w); return a; }
					
					int op_and(int a, int b) { int result = 0; int n = 1; for (int i = 0; i < BITWISE_BIT_COUNT; i++) { if ((op_modi(a, 2) != 0) && (op_modi(b, 2) != 0)) { result += n; } a = a / 2; b = b / 2; n = n * 2; if (!(a > 0 && b > 0)) { break; } } return result; }
					ivec2 op_and(ivec2 a, ivec2 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); return a; }
					ivec3 op_and(ivec3 a, ivec3 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); return a; }
					ivec4 op_and(ivec4 a, ivec4 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); a.w = op_and(a.w, b.w); return a; }
					
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat10_0.x = texture2D(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat10_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat10_1 = texture2D(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_0.xyz = texture2D(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat10_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat10_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat10_9 = texture2D(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat10_9) * u_xlat0.xyz;
					    u_xlat2.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat10_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + (-unity_FogColor.xyz);
					    u_xlat1.x = vs_TEXCOORD1;
					    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
					    SV_Target0.xyz = u_xlat1.xxx * u_xlat0.xyz + unity_FogColor.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat10_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat10_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier01 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTPROBE_SH" "VERTEXLIGHT_ON" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 unity_FogParams;
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					attribute highp vec4 in_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD1 = u_xlat0.z * unity_FogParams.z + unity_FogParams.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 100
					
					#ifdef GL_FRAGMENT_PRECISION_HIGH
					    precision highp float;
					#else
					    precision mediump float;
					#endif
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	mediump vec4 unity_FogColor;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _Gradient;
					uniform lowp sampler2D _MainTexMask;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					lowp float u_xlat10_9;
					const int BITWISE_BIT_COUNT = 32;
					int op_modi(int x, int y) { return x - y * (x / y); }
					ivec2 op_modi(ivec2 a, ivec2 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); return a; }
					ivec3 op_modi(ivec3 a, ivec3 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); return a; }
					ivec4 op_modi(ivec4 a, ivec4 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); a.w = op_modi(a.w, b.w); return a; }
					
					int op_and(int a, int b) { int result = 0; int n = 1; for (int i = 0; i < BITWISE_BIT_COUNT; i++) { if ((op_modi(a, 2) != 0) && (op_modi(b, 2) != 0)) { result += n; } a = a / 2; b = b / 2; n = n * 2; if (!(a > 0 && b > 0)) { break; } } return result; }
					ivec2 op_and(ivec2 a, ivec2 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); return a; }
					ivec3 op_and(ivec3 a, ivec3 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); return a; }
					ivec4 op_and(ivec4 a, ivec4 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); a.w = op_and(a.w, b.w); return a; }
					
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat10_0.x = texture2D(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat10_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat10_1 = texture2D(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_0.xyz = texture2D(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat10_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat10_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat10_9 = texture2D(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat10_9) * u_xlat0.xyz;
					    u_xlat2.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat10_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + (-unity_FogColor.xyz);
					    u_xlat1.x = vs_TEXCOORD1;
					    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
					    SV_Target0.xyz = u_xlat1.xxx * u_xlat0.xyz + unity_FogColor.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat10_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat10_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier02 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTPROBE_SH" "VERTEXLIGHT_ON" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 unity_FogParams;
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					attribute highp vec4 in_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD1 = u_xlat0.z * unity_FogParams.z + unity_FogParams.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 100
					
					#ifdef GL_FRAGMENT_PRECISION_HIGH
					    precision highp float;
					#else
					    precision mediump float;
					#endif
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	mediump vec4 unity_FogColor;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _Gradient;
					uniform lowp sampler2D _MainTexMask;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					lowp float u_xlat10_9;
					const int BITWISE_BIT_COUNT = 32;
					int op_modi(int x, int y) { return x - y * (x / y); }
					ivec2 op_modi(ivec2 a, ivec2 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); return a; }
					ivec3 op_modi(ivec3 a, ivec3 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); return a; }
					ivec4 op_modi(ivec4 a, ivec4 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); a.w = op_modi(a.w, b.w); return a; }
					
					int op_and(int a, int b) { int result = 0; int n = 1; for (int i = 0; i < BITWISE_BIT_COUNT; i++) { if ((op_modi(a, 2) != 0) && (op_modi(b, 2) != 0)) { result += n; } a = a / 2; b = b / 2; n = n * 2; if (!(a > 0 && b > 0)) { break; } } return result; }
					ivec2 op_and(ivec2 a, ivec2 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); return a; }
					ivec3 op_and(ivec3 a, ivec3 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); return a; }
					ivec4 op_and(ivec4 a, ivec4 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); a.w = op_and(a.w, b.w); return a; }
					
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat10_0.x = texture2D(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat10_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat10_1 = texture2D(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_0.xyz = texture2D(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat10_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat10_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat10_9 = texture2D(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat10_9) * u_xlat0.xyz;
					    u_xlat2.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat10_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + (-unity_FogColor.xyz);
					    u_xlat1.x = vs_TEXCOORD1;
					    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
					    SV_Target0.xyz = u_xlat1.xxx * u_xlat0.xyz + unity_FogColor.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat10_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat10_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier00 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTPROBE_SH" "VERTEXLIGHT_ON" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 unity_FogParams;
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					in highp vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp float vs_TEXCOORD1;
					out highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD1 = u_xlat0.z * unity_FogParams.z + unity_FogParams.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	mediump vec4 unity_FogColor;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _Gradient;
					uniform mediump sampler2D _MainTexMask;
					in highp vec2 vs_TEXCOORD0;
					in highp float vs_TEXCOORD1;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					mediump float u_xlat16_9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat16_0.x = texture(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat16_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat16_1 = texture(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_0.xyz = texture(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat16_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat16_9 = texture(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat16_9) * u_xlat0.xyz;
					    u_xlat2.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat16_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + (-unity_FogColor.xyz);
					    u_xlat1.x = vs_TEXCOORD1;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat1.x = min(max(u_xlat1.x, 0.0), 1.0);
					#else
					    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = u_xlat1.xxx * u_xlat0.xyz + unity_FogColor.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat16_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat16_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier01 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTPROBE_SH" "VERTEXLIGHT_ON" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 unity_FogParams;
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					in highp vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp float vs_TEXCOORD1;
					out highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD1 = u_xlat0.z * unity_FogParams.z + unity_FogParams.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	mediump vec4 unity_FogColor;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _Gradient;
					uniform mediump sampler2D _MainTexMask;
					in highp vec2 vs_TEXCOORD0;
					in highp float vs_TEXCOORD1;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					mediump float u_xlat16_9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat16_0.x = texture(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat16_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat16_1 = texture(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_0.xyz = texture(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat16_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat16_9 = texture(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat16_9) * u_xlat0.xyz;
					    u_xlat2.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat16_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + (-unity_FogColor.xyz);
					    u_xlat1.x = vs_TEXCOORD1;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat1.x = min(max(u_xlat1.x, 0.0), 1.0);
					#else
					    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = u_xlat1.xxx * u_xlat0.xyz + unity_FogColor.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat16_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat16_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier02 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTPROBE_SH" "VERTEXLIGHT_ON" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 unity_FogParams;
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					in highp vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp float vs_TEXCOORD1;
					out highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD1 = u_xlat0.z * unity_FogParams.z + unity_FogParams.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	mediump vec4 unity_FogColor;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _Gradient;
					uniform mediump sampler2D _MainTexMask;
					in highp vec2 vs_TEXCOORD0;
					in highp float vs_TEXCOORD1;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					mediump float u_xlat16_9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat16_0.x = texture(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat16_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat16_1 = texture(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_0.xyz = texture(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat16_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat16_9 = texture(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat16_9) * u_xlat0.xyz;
					    u_xlat2.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat16_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + (-unity_FogColor.xyz);
					    u_xlat1.x = vs_TEXCOORD1;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat1.x = min(max(u_xlat1.x, 0.0), 1.0);
					#else
					    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = u_xlat1.xxx * u_xlat0.xyz + unity_FogColor.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat16_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat16_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier00 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 unity_FogParams;
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					attribute highp vec4 in_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD1 = u_xlat0.z * unity_FogParams.z + unity_FogParams.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 100
					
					#ifdef GL_FRAGMENT_PRECISION_HIGH
					    precision highp float;
					#else
					    precision mediump float;
					#endif
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	mediump vec4 unity_FogColor;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _Gradient;
					uniform lowp sampler2D _MainTexMask;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					lowp float u_xlat10_9;
					const int BITWISE_BIT_COUNT = 32;
					int op_modi(int x, int y) { return x - y * (x / y); }
					ivec2 op_modi(ivec2 a, ivec2 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); return a; }
					ivec3 op_modi(ivec3 a, ivec3 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); return a; }
					ivec4 op_modi(ivec4 a, ivec4 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); a.w = op_modi(a.w, b.w); return a; }
					
					int op_and(int a, int b) { int result = 0; int n = 1; for (int i = 0; i < BITWISE_BIT_COUNT; i++) { if ((op_modi(a, 2) != 0) && (op_modi(b, 2) != 0)) { result += n; } a = a / 2; b = b / 2; n = n * 2; if (!(a > 0 && b > 0)) { break; } } return result; }
					ivec2 op_and(ivec2 a, ivec2 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); return a; }
					ivec3 op_and(ivec3 a, ivec3 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); return a; }
					ivec4 op_and(ivec4 a, ivec4 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); a.w = op_and(a.w, b.w); return a; }
					
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat10_0.x = texture2D(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat10_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat10_1 = texture2D(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_0.xyz = texture2D(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat10_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat10_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat10_9 = texture2D(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat10_9) * u_xlat0.xyz;
					    u_xlat2.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat10_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + (-unity_FogColor.xyz);
					    u_xlat1.x = vs_TEXCOORD1;
					    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
					    SV_Target0.xyz = u_xlat1.xxx * u_xlat0.xyz + unity_FogColor.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat10_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat10_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier01 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 unity_FogParams;
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					attribute highp vec4 in_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD1 = u_xlat0.z * unity_FogParams.z + unity_FogParams.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 100
					
					#ifdef GL_FRAGMENT_PRECISION_HIGH
					    precision highp float;
					#else
					    precision mediump float;
					#endif
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	mediump vec4 unity_FogColor;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _Gradient;
					uniform lowp sampler2D _MainTexMask;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					lowp float u_xlat10_9;
					const int BITWISE_BIT_COUNT = 32;
					int op_modi(int x, int y) { return x - y * (x / y); }
					ivec2 op_modi(ivec2 a, ivec2 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); return a; }
					ivec3 op_modi(ivec3 a, ivec3 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); return a; }
					ivec4 op_modi(ivec4 a, ivec4 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); a.w = op_modi(a.w, b.w); return a; }
					
					int op_and(int a, int b) { int result = 0; int n = 1; for (int i = 0; i < BITWISE_BIT_COUNT; i++) { if ((op_modi(a, 2) != 0) && (op_modi(b, 2) != 0)) { result += n; } a = a / 2; b = b / 2; n = n * 2; if (!(a > 0 && b > 0)) { break; } } return result; }
					ivec2 op_and(ivec2 a, ivec2 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); return a; }
					ivec3 op_and(ivec3 a, ivec3 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); return a; }
					ivec4 op_and(ivec4 a, ivec4 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); a.w = op_and(a.w, b.w); return a; }
					
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat10_0.x = texture2D(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat10_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat10_1 = texture2D(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_0.xyz = texture2D(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat10_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat10_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat10_9 = texture2D(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat10_9) * u_xlat0.xyz;
					    u_xlat2.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat10_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + (-unity_FogColor.xyz);
					    u_xlat1.x = vs_TEXCOORD1;
					    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
					    SV_Target0.xyz = u_xlat1.xxx * u_xlat0.xyz + unity_FogColor.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat10_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat10_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier02 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 unity_FogParams;
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					attribute highp vec4 in_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD1 = u_xlat0.z * unity_FogParams.z + unity_FogParams.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 100
					
					#ifdef GL_FRAGMENT_PRECISION_HIGH
					    precision highp float;
					#else
					    precision mediump float;
					#endif
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	mediump vec4 unity_FogColor;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _Gradient;
					uniform lowp sampler2D _MainTexMask;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					lowp float u_xlat10_9;
					const int BITWISE_BIT_COUNT = 32;
					int op_modi(int x, int y) { return x - y * (x / y); }
					ivec2 op_modi(ivec2 a, ivec2 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); return a; }
					ivec3 op_modi(ivec3 a, ivec3 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); return a; }
					ivec4 op_modi(ivec4 a, ivec4 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); a.w = op_modi(a.w, b.w); return a; }
					
					int op_and(int a, int b) { int result = 0; int n = 1; for (int i = 0; i < BITWISE_BIT_COUNT; i++) { if ((op_modi(a, 2) != 0) && (op_modi(b, 2) != 0)) { result += n; } a = a / 2; b = b / 2; n = n * 2; if (!(a > 0 && b > 0)) { break; } } return result; }
					ivec2 op_and(ivec2 a, ivec2 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); return a; }
					ivec3 op_and(ivec3 a, ivec3 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); return a; }
					ivec4 op_and(ivec4 a, ivec4 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); a.w = op_and(a.w, b.w); return a; }
					
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat10_0.x = texture2D(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat10_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat10_1 = texture2D(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_0.xyz = texture2D(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat10_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat10_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat10_9 = texture2D(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat10_9) * u_xlat0.xyz;
					    u_xlat2.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat10_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + (-unity_FogColor.xyz);
					    u_xlat1.x = vs_TEXCOORD1;
					    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
					    SV_Target0.xyz = u_xlat1.xxx * u_xlat0.xyz + unity_FogColor.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat10_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat10_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier00 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 unity_FogParams;
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					in highp vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp float vs_TEXCOORD1;
					out highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD1 = u_xlat0.z * unity_FogParams.z + unity_FogParams.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	mediump vec4 unity_FogColor;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _Gradient;
					uniform mediump sampler2D _MainTexMask;
					in highp vec2 vs_TEXCOORD0;
					in highp float vs_TEXCOORD1;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					mediump float u_xlat16_9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat16_0.x = texture(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat16_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat16_1 = texture(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_0.xyz = texture(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat16_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat16_9 = texture(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat16_9) * u_xlat0.xyz;
					    u_xlat2.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat16_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + (-unity_FogColor.xyz);
					    u_xlat1.x = vs_TEXCOORD1;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat1.x = min(max(u_xlat1.x, 0.0), 1.0);
					#else
					    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = u_xlat1.xxx * u_xlat0.xyz + unity_FogColor.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat16_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat16_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier01 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 unity_FogParams;
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					in highp vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp float vs_TEXCOORD1;
					out highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD1 = u_xlat0.z * unity_FogParams.z + unity_FogParams.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	mediump vec4 unity_FogColor;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _Gradient;
					uniform mediump sampler2D _MainTexMask;
					in highp vec2 vs_TEXCOORD0;
					in highp float vs_TEXCOORD1;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					mediump float u_xlat16_9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat16_0.x = texture(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat16_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat16_1 = texture(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_0.xyz = texture(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat16_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat16_9 = texture(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat16_9) * u_xlat0.xyz;
					    u_xlat2.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat16_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + (-unity_FogColor.xyz);
					    u_xlat1.x = vs_TEXCOORD1;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat1.x = min(max(u_xlat1.x, 0.0), 1.0);
					#else
					    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = u_xlat1.xxx * u_xlat0.xyz + unity_FogColor.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat16_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat16_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier02 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 unity_FogParams;
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					in highp vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp float vs_TEXCOORD1;
					out highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD1 = u_xlat0.z * unity_FogParams.z + unity_FogParams.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	mediump vec4 unity_FogColor;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _Gradient;
					uniform mediump sampler2D _MainTexMask;
					in highp vec2 vs_TEXCOORD0;
					in highp float vs_TEXCOORD1;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					mediump float u_xlat16_9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat16_0.x = texture(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat16_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat16_1 = texture(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_0.xyz = texture(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat16_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat16_9 = texture(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat16_9) * u_xlat0.xyz;
					    u_xlat2.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat16_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + (-unity_FogColor.xyz);
					    u_xlat1.x = vs_TEXCOORD1;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat1.x = min(max(u_xlat1.x, 0.0), 1.0);
					#else
					    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = u_xlat1.xxx * u_xlat0.xyz + unity_FogColor.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat16_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat16_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier00 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTPROBE_SH" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 unity_FogParams;
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					attribute highp vec4 in_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD1 = u_xlat0.z * unity_FogParams.z + unity_FogParams.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 100
					
					#ifdef GL_FRAGMENT_PRECISION_HIGH
					    precision highp float;
					#else
					    precision mediump float;
					#endif
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	mediump vec4 unity_FogColor;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _Gradient;
					uniform lowp sampler2D _MainTexMask;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					lowp float u_xlat10_9;
					const int BITWISE_BIT_COUNT = 32;
					int op_modi(int x, int y) { return x - y * (x / y); }
					ivec2 op_modi(ivec2 a, ivec2 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); return a; }
					ivec3 op_modi(ivec3 a, ivec3 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); return a; }
					ivec4 op_modi(ivec4 a, ivec4 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); a.w = op_modi(a.w, b.w); return a; }
					
					int op_and(int a, int b) { int result = 0; int n = 1; for (int i = 0; i < BITWISE_BIT_COUNT; i++) { if ((op_modi(a, 2) != 0) && (op_modi(b, 2) != 0)) { result += n; } a = a / 2; b = b / 2; n = n * 2; if (!(a > 0 && b > 0)) { break; } } return result; }
					ivec2 op_and(ivec2 a, ivec2 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); return a; }
					ivec3 op_and(ivec3 a, ivec3 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); return a; }
					ivec4 op_and(ivec4 a, ivec4 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); a.w = op_and(a.w, b.w); return a; }
					
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat10_0.x = texture2D(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat10_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat10_1 = texture2D(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_0.xyz = texture2D(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat10_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat10_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat10_9 = texture2D(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat10_9) * u_xlat0.xyz;
					    u_xlat2.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat10_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + (-unity_FogColor.xyz);
					    u_xlat1.x = vs_TEXCOORD1;
					    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
					    SV_Target0.xyz = u_xlat1.xxx * u_xlat0.xyz + unity_FogColor.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat10_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat10_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier01 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTPROBE_SH" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 unity_FogParams;
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					attribute highp vec4 in_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD1 = u_xlat0.z * unity_FogParams.z + unity_FogParams.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 100
					
					#ifdef GL_FRAGMENT_PRECISION_HIGH
					    precision highp float;
					#else
					    precision mediump float;
					#endif
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	mediump vec4 unity_FogColor;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _Gradient;
					uniform lowp sampler2D _MainTexMask;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					lowp float u_xlat10_9;
					const int BITWISE_BIT_COUNT = 32;
					int op_modi(int x, int y) { return x - y * (x / y); }
					ivec2 op_modi(ivec2 a, ivec2 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); return a; }
					ivec3 op_modi(ivec3 a, ivec3 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); return a; }
					ivec4 op_modi(ivec4 a, ivec4 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); a.w = op_modi(a.w, b.w); return a; }
					
					int op_and(int a, int b) { int result = 0; int n = 1; for (int i = 0; i < BITWISE_BIT_COUNT; i++) { if ((op_modi(a, 2) != 0) && (op_modi(b, 2) != 0)) { result += n; } a = a / 2; b = b / 2; n = n * 2; if (!(a > 0 && b > 0)) { break; } } return result; }
					ivec2 op_and(ivec2 a, ivec2 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); return a; }
					ivec3 op_and(ivec3 a, ivec3 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); return a; }
					ivec4 op_and(ivec4 a, ivec4 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); a.w = op_and(a.w, b.w); return a; }
					
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat10_0.x = texture2D(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat10_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat10_1 = texture2D(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_0.xyz = texture2D(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat10_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat10_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat10_9 = texture2D(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat10_9) * u_xlat0.xyz;
					    u_xlat2.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat10_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + (-unity_FogColor.xyz);
					    u_xlat1.x = vs_TEXCOORD1;
					    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
					    SV_Target0.xyz = u_xlat1.xxx * u_xlat0.xyz + unity_FogColor.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat10_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat10_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier02 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTPROBE_SH" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 unity_FogParams;
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					attribute highp vec4 in_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD1 = u_xlat0.z * unity_FogParams.z + unity_FogParams.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 100
					
					#ifdef GL_FRAGMENT_PRECISION_HIGH
					    precision highp float;
					#else
					    precision mediump float;
					#endif
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	mediump vec4 unity_FogColor;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _Gradient;
					uniform lowp sampler2D _MainTexMask;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					lowp float u_xlat10_9;
					const int BITWISE_BIT_COUNT = 32;
					int op_modi(int x, int y) { return x - y * (x / y); }
					ivec2 op_modi(ivec2 a, ivec2 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); return a; }
					ivec3 op_modi(ivec3 a, ivec3 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); return a; }
					ivec4 op_modi(ivec4 a, ivec4 b) { a.x = op_modi(a.x, b.x); a.y = op_modi(a.y, b.y); a.z = op_modi(a.z, b.z); a.w = op_modi(a.w, b.w); return a; }
					
					int op_and(int a, int b) { int result = 0; int n = 1; for (int i = 0; i < BITWISE_BIT_COUNT; i++) { if ((op_modi(a, 2) != 0) && (op_modi(b, 2) != 0)) { result += n; } a = a / 2; b = b / 2; n = n * 2; if (!(a > 0 && b > 0)) { break; } } return result; }
					ivec2 op_and(ivec2 a, ivec2 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); return a; }
					ivec3 op_and(ivec3 a, ivec3 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); return a; }
					ivec4 op_and(ivec4 a, ivec4 b) { a.x = op_and(a.x, b.x); a.y = op_and(a.y, b.y); a.z = op_and(a.z, b.z); a.w = op_and(a.w, b.w); return a; }
					
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat10_0.x = texture2D(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat10_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat10_1 = texture2D(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_0.xyz = texture2D(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat10_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat10_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat10_9 = texture2D(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat10_9) * u_xlat0.xyz;
					    u_xlat2.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat10_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + (-unity_FogColor.xyz);
					    u_xlat1.x = vs_TEXCOORD1;
					    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
					    SV_Target0.xyz = u_xlat1.xxx * u_xlat0.xyz + unity_FogColor.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat10_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat10_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier00 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTPROBE_SH" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 unity_FogParams;
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					in highp vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp float vs_TEXCOORD1;
					out highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD1 = u_xlat0.z * unity_FogParams.z + unity_FogParams.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	mediump vec4 unity_FogColor;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _Gradient;
					uniform mediump sampler2D _MainTexMask;
					in highp vec2 vs_TEXCOORD0;
					in highp float vs_TEXCOORD1;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					mediump float u_xlat16_9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat16_0.x = texture(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat16_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat16_1 = texture(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_0.xyz = texture(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat16_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat16_9 = texture(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat16_9) * u_xlat0.xyz;
					    u_xlat2.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat16_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + (-unity_FogColor.xyz);
					    u_xlat1.x = vs_TEXCOORD1;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat1.x = min(max(u_xlat1.x, 0.0), 1.0);
					#else
					    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = u_xlat1.xxx * u_xlat0.xyz + unity_FogColor.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat16_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat16_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier01 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTPROBE_SH" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 unity_FogParams;
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					in highp vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp float vs_TEXCOORD1;
					out highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD1 = u_xlat0.z * unity_FogParams.z + unity_FogParams.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	mediump vec4 unity_FogColor;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _Gradient;
					uniform mediump sampler2D _MainTexMask;
					in highp vec2 vs_TEXCOORD0;
					in highp float vs_TEXCOORD1;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					mediump float u_xlat16_9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat16_0.x = texture(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat16_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat16_1 = texture(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_0.xyz = texture(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat16_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat16_9 = texture(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat16_9) * u_xlat0.xyz;
					    u_xlat2.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat16_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + (-unity_FogColor.xyz);
					    u_xlat1.x = vs_TEXCOORD1;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat1.x = min(max(u_xlat1.x, 0.0), 1.0);
					#else
					    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = u_xlat1.xxx * u_xlat0.xyz + unity_FogColor.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat16_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat16_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier02 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTPROBE_SH" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	vec4 unity_FogParams;
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					in highp vec4 in_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp float vs_TEXCOORD1;
					out highp vec4 vs_COLOR0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    gl_Position = u_xlat0;
					    vs_TEXCOORD1 = u_xlat0.z * unity_FogParams.z + unity_FogParams.w;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    vs_COLOR0 = in_COLOR0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _Time;
					uniform 	mediump vec4 unity_FogColor;
					uniform 	vec4 _MainTex_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	vec4 _MainTexMask_ST;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	float _MainTextUSpeed;
					uniform 	float _MainTextVSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _Gradient;
					uniform mediump sampler2D _MainTexMask;
					in highp vec2 vs_TEXCOORD0;
					in highp float vs_TEXCOORD1;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat6;
					mediump float u_xlat16_9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat16_0.x = texture(_Distortion, u_xlat0.xy).x;
					    u_xlat0.xy = u_xlat16_0.xx + (-vs_TEXCOORD0.xy);
					    u_xlat6.xy = vec2(_NoiseAmount) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat0.xy * vec2(_NoiseAmount);
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextUSpeed, _MainTextVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    u_xlat16_1 = texture(_MainTex, u_xlat0.xy);
					    u_xlat0.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat6.xy;
					    u_xlat0.xy = u_xlat0.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_0.xyz = texture(_Gradient, u_xlat0.xy).xyz;
					    u_xlat2.xyz = log2(u_xlat16_0.xyz);
					    u_xlat2.xyz = u_xlat2.xyz * vec3(_GradientPower);
					    u_xlat2.xyz = exp2(u_xlat2.xyz);
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www;
					    u_xlat2.xy = vs_TEXCOORD0.xy * _MainTexMask_ST.xy + _MainTexMask_ST.zw;
					    u_xlat16_9 = texture(_MainTexMask, u_xlat2.xy).w;
					    u_xlat0.xyz = vec3(u_xlat16_9) * u_xlat0.xyz;
					    u_xlat2.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat2.x = max(u_xlat2.x, _DoubleSided);
					    u_xlat2.x = min(u_xlat2.x, 1.0);
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xxx;
					    u_xlat1.xyz = u_xlat16_1.xyz * vs_COLOR0.xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz;
					    u_xlat1.xyz = u_xlat1.xyz + u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + (-unity_FogColor.xyz);
					    u_xlat1.x = vs_TEXCOORD1;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat1.x = min(max(u_xlat1.x, 0.0), 1.0);
					#else
					    u_xlat1.x = clamp(u_xlat1.x, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = u_xlat1.xxx * u_xlat0.xyz + unity_FogColor.xyz;
					    u_xlat0.x = vs_COLOR0.w * _TintColor.w;
					    u_xlat0.x = u_xlat16_1.w * u_xlat0.x;
					    SV_Target0.w = u_xlat16_9 * u_xlat0.x;
					    return;
					}
					
					#endif"
				}
			}
			Program "fp" {
				SubProgram "gles hw_tier00 " {
					Keywords { "DIRECTIONAL" }
					"!!GLES"
				}
				SubProgram "gles hw_tier01 " {
					Keywords { "DIRECTIONAL" }
					"!!GLES"
				}
				SubProgram "gles hw_tier02 " {
					Keywords { "DIRECTIONAL" }
					"!!GLES"
				}
				SubProgram "gles3 hw_tier00 " {
					Keywords { "DIRECTIONAL" }
					"!!GLES3"
				}
				SubProgram "gles3 hw_tier01 " {
					Keywords { "DIRECTIONAL" }
					"!!GLES3"
				}
				SubProgram "gles3 hw_tier02 " {
					Keywords { "DIRECTIONAL" }
					"!!GLES3"
				}
				SubProgram "gles hw_tier00 " {
					Keywords { "DIRECTIONAL" "LIGHTPROBE_SH" }
					"!!GLES"
				}
				SubProgram "gles hw_tier01 " {
					Keywords { "DIRECTIONAL" "LIGHTPROBE_SH" }
					"!!GLES"
				}
				SubProgram "gles hw_tier02 " {
					Keywords { "DIRECTIONAL" "LIGHTPROBE_SH" }
					"!!GLES"
				}
				SubProgram "gles3 hw_tier00 " {
					Keywords { "DIRECTIONAL" "LIGHTPROBE_SH" }
					"!!GLES3"
				}
				SubProgram "gles3 hw_tier01 " {
					Keywords { "DIRECTIONAL" "LIGHTPROBE_SH" }
					"!!GLES3"
				}
				SubProgram "gles3 hw_tier02 " {
					Keywords { "DIRECTIONAL" "LIGHTPROBE_SH" }
					"!!GLES3"
				}
				SubProgram "gles hw_tier00 " {
					Keywords { "DIRECTIONAL" "LIGHTMAP_ON" }
					"!!GLES"
				}
				SubProgram "gles hw_tier01 " {
					Keywords { "DIRECTIONAL" "LIGHTMAP_ON" }
					"!!GLES"
				}
				SubProgram "gles hw_tier02 " {
					Keywords { "DIRECTIONAL" "LIGHTMAP_ON" }
					"!!GLES"
				}
				SubProgram "gles3 hw_tier00 " {
					Keywords { "DIRECTIONAL" "LIGHTMAP_ON" }
					"!!GLES3"
				}
				SubProgram "gles3 hw_tier01 " {
					Keywords { "DIRECTIONAL" "LIGHTMAP_ON" }
					"!!GLES3"
				}
				SubProgram "gles3 hw_tier02 " {
					Keywords { "DIRECTIONAL" "LIGHTMAP_ON" }
					"!!GLES3"
				}
				SubProgram "gles hw_tier00 " {
					Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "LIGHTPROBE_SH" }
					"!!GLES"
				}
				SubProgram "gles hw_tier01 " {
					Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "LIGHTPROBE_SH" }
					"!!GLES"
				}
				SubProgram "gles hw_tier02 " {
					Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "LIGHTPROBE_SH" }
					"!!GLES"
				}
				SubProgram "gles3 hw_tier00 " {
					Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "LIGHTPROBE_SH" }
					"!!GLES3"
				}
				SubProgram "gles3 hw_tier01 " {
					Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "LIGHTPROBE_SH" }
					"!!GLES3"
				}
				SubProgram "gles3 hw_tier02 " {
					Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "LIGHTPROBE_SH" }
					"!!GLES3"
				}
				SubProgram "gles hw_tier00 " {
					Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" }
					"!!GLES"
				}
				SubProgram "gles hw_tier01 " {
					Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" }
					"!!GLES"
				}
				SubProgram "gles hw_tier02 " {
					Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" }
					"!!GLES"
				}
				SubProgram "gles3 hw_tier00 " {
					Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" }
					"!!GLES3"
				}
				SubProgram "gles3 hw_tier01 " {
					Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" }
					"!!GLES3"
				}
				SubProgram "gles3 hw_tier02 " {
					Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" }
					"!!GLES3"
				}
				SubProgram "gles hw_tier00 " {
					Keywords { "DIRECTIONAL" "LIGHTPROBE_SH" "SHADOWS_SCREEN" }
					"!!GLES"
				}
				SubProgram "gles hw_tier01 " {
					Keywords { "DIRECTIONAL" "LIGHTPROBE_SH" "SHADOWS_SCREEN" }
					"!!GLES"
				}
				SubProgram "gles hw_tier02 " {
					Keywords { "DIRECTIONAL" "LIGHTPROBE_SH" "SHADOWS_SCREEN" }
					"!!GLES"
				}
				SubProgram "gles3 hw_tier00 " {
					Keywords { "DIRECTIONAL" "LIGHTPROBE_SH" "SHADOWS_SCREEN" }
					"!!GLES3"
				}
				SubProgram "gles3 hw_tier01 " {
					Keywords { "DIRECTIONAL" "LIGHTPROBE_SH" "SHADOWS_SCREEN" }
					"!!GLES3"
				}
				SubProgram "gles3 hw_tier02 " {
					Keywords { "DIRECTIONAL" "LIGHTPROBE_SH" "SHADOWS_SCREEN" }
					"!!GLES3"
				}
				SubProgram "gles hw_tier00 " {
					Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "SHADOWS_SCREEN" }
					"!!GLES"
				}
				SubProgram "gles hw_tier01 " {
					Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "SHADOWS_SCREEN" }
					"!!GLES"
				}
				SubProgram "gles hw_tier02 " {
					Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "SHADOWS_SCREEN" }
					"!!GLES"
				}
				SubProgram "gles3 hw_tier00 " {
					Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "SHADOWS_SCREEN" }
					"!!GLES3"
				}
				SubProgram "gles3 hw_tier01 " {
					Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "SHADOWS_SCREEN" }
					"!!GLES3"
				}
				SubProgram "gles3 hw_tier02 " {
					Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "SHADOWS_SCREEN" }
					"!!GLES3"
				}
				SubProgram "gles hw_tier00 " {
					Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "LIGHTPROBE_SH" "SHADOWS_SCREEN" }
					"!!GLES"
				}
				SubProgram "gles hw_tier01 " {
					Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "LIGHTPROBE_SH" "SHADOWS_SCREEN" }
					"!!GLES"
				}
				SubProgram "gles hw_tier02 " {
					Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "LIGHTPROBE_SH" "SHADOWS_SCREEN" }
					"!!GLES"
				}
				SubProgram "gles3 hw_tier00 " {
					Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "LIGHTPROBE_SH" "SHADOWS_SCREEN" }
					"!!GLES3"
				}
				SubProgram "gles3 hw_tier01 " {
					Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "LIGHTPROBE_SH" "SHADOWS_SCREEN" }
					"!!GLES3"
				}
				SubProgram "gles3 hw_tier02 " {
					Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "LIGHTPROBE_SH" "SHADOWS_SCREEN" }
					"!!GLES3"
				}
				SubProgram "gles hw_tier00 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" }
					"!!GLES"
				}
				SubProgram "gles hw_tier01 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" }
					"!!GLES"
				}
				SubProgram "gles hw_tier02 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" }
					"!!GLES"
				}
				SubProgram "gles3 hw_tier00 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" }
					"!!GLES3"
				}
				SubProgram "gles3 hw_tier01 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" }
					"!!GLES3"
				}
				SubProgram "gles3 hw_tier02 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" }
					"!!GLES3"
				}
				SubProgram "gles hw_tier00 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTPROBE_SH" }
					"!!GLES"
				}
				SubProgram "gles hw_tier01 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTPROBE_SH" }
					"!!GLES"
				}
				SubProgram "gles hw_tier02 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTPROBE_SH" }
					"!!GLES"
				}
				SubProgram "gles3 hw_tier00 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTPROBE_SH" }
					"!!GLES3"
				}
				SubProgram "gles3 hw_tier01 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTPROBE_SH" }
					"!!GLES3"
				}
				SubProgram "gles3 hw_tier02 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTPROBE_SH" }
					"!!GLES3"
				}
				SubProgram "gles hw_tier00 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTMAP_ON" }
					"!!GLES"
				}
				SubProgram "gles hw_tier01 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTMAP_ON" }
					"!!GLES"
				}
				SubProgram "gles hw_tier02 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTMAP_ON" }
					"!!GLES"
				}
				SubProgram "gles3 hw_tier00 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTMAP_ON" }
					"!!GLES3"
				}
				SubProgram "gles3 hw_tier01 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTMAP_ON" }
					"!!GLES3"
				}
				SubProgram "gles3 hw_tier02 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTMAP_ON" }
					"!!GLES3"
				}
				SubProgram "gles hw_tier00 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTMAP_ON" "LIGHTPROBE_SH" }
					"!!GLES"
				}
				SubProgram "gles hw_tier01 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTMAP_ON" "LIGHTPROBE_SH" }
					"!!GLES"
				}
				SubProgram "gles hw_tier02 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTMAP_ON" "LIGHTPROBE_SH" }
					"!!GLES"
				}
				SubProgram "gles3 hw_tier00 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTMAP_ON" "LIGHTPROBE_SH" }
					"!!GLES3"
				}
				SubProgram "gles3 hw_tier01 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTMAP_ON" "LIGHTPROBE_SH" }
					"!!GLES3"
				}
				SubProgram "gles3 hw_tier02 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTMAP_ON" "LIGHTPROBE_SH" }
					"!!GLES3"
				}
				SubProgram "gles hw_tier00 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "SHADOWS_SCREEN" }
					"!!GLES"
				}
				SubProgram "gles hw_tier01 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "SHADOWS_SCREEN" }
					"!!GLES"
				}
				SubProgram "gles hw_tier02 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "SHADOWS_SCREEN" }
					"!!GLES"
				}
				SubProgram "gles3 hw_tier00 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "SHADOWS_SCREEN" }
					"!!GLES3"
				}
				SubProgram "gles3 hw_tier01 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "SHADOWS_SCREEN" }
					"!!GLES3"
				}
				SubProgram "gles3 hw_tier02 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "SHADOWS_SCREEN" }
					"!!GLES3"
				}
				SubProgram "gles hw_tier00 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTPROBE_SH" "SHADOWS_SCREEN" }
					"!!GLES"
				}
				SubProgram "gles hw_tier01 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTPROBE_SH" "SHADOWS_SCREEN" }
					"!!GLES"
				}
				SubProgram "gles hw_tier02 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTPROBE_SH" "SHADOWS_SCREEN" }
					"!!GLES"
				}
				SubProgram "gles3 hw_tier00 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTPROBE_SH" "SHADOWS_SCREEN" }
					"!!GLES3"
				}
				SubProgram "gles3 hw_tier01 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTPROBE_SH" "SHADOWS_SCREEN" }
					"!!GLES3"
				}
				SubProgram "gles3 hw_tier02 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTPROBE_SH" "SHADOWS_SCREEN" }
					"!!GLES3"
				}
				SubProgram "gles hw_tier00 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTMAP_ON" "SHADOWS_SCREEN" }
					"!!GLES"
				}
				SubProgram "gles hw_tier01 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTMAP_ON" "SHADOWS_SCREEN" }
					"!!GLES"
				}
				SubProgram "gles hw_tier02 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTMAP_ON" "SHADOWS_SCREEN" }
					"!!GLES"
				}
				SubProgram "gles3 hw_tier00 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTMAP_ON" "SHADOWS_SCREEN" }
					"!!GLES3"
				}
				SubProgram "gles3 hw_tier01 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTMAP_ON" "SHADOWS_SCREEN" }
					"!!GLES3"
				}
				SubProgram "gles3 hw_tier02 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTMAP_ON" "SHADOWS_SCREEN" }
					"!!GLES3"
				}
				SubProgram "gles hw_tier00 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTMAP_ON" "LIGHTPROBE_SH" "SHADOWS_SCREEN" }
					"!!GLES"
				}
				SubProgram "gles hw_tier01 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTMAP_ON" "LIGHTPROBE_SH" "SHADOWS_SCREEN" }
					"!!GLES"
				}
				SubProgram "gles hw_tier02 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTMAP_ON" "LIGHTPROBE_SH" "SHADOWS_SCREEN" }
					"!!GLES"
				}
				SubProgram "gles3 hw_tier00 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTMAP_ON" "LIGHTPROBE_SH" "SHADOWS_SCREEN" }
					"!!GLES3"
				}
				SubProgram "gles3 hw_tier01 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTMAP_ON" "LIGHTPROBE_SH" "SHADOWS_SCREEN" }
					"!!GLES3"
				}
				SubProgram "gles3 hw_tier02 " {
					Keywords { "DIRECTIONAL" "FOG_LINEAR" "LIGHTMAP_ON" "LIGHTPROBE_SH" "SHADOWS_SCREEN" }
					"!!GLES3"
				}
			}
		}
	}
	CustomEditor "ShaderForgeMaterialInspector"
}