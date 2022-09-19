Shader "GAP/AdditiveMobileDistortionScroll" {
	Properties {
		_TintColor ("Color", Vector) = (1,0.5342799,0.1764706,1)
		_ColorRamp ("Color Ramp", 2D) = "white" {}
		_ColorMultiplier ("Color Multiplier", Range(0, 10)) = 1.32872
		_MainTextureUSpeed ("Main Texture U Speed", Float) = 0
		_MainTextureVSpeed ("Main Texture V Speed", Float) = 0
		_MainTexutre ("Main Texutre", 2D) = "white" {}
		[MaterialToggle] _DistortMainTexture ("Distort Main Texture", Float) = 0
		_GradientPower ("Gradient Power", Range(0, 50)) = 2.214298
		_GradientUSpeed ("Gradient U Speed", Float) = -0.2
		_GradientVSpeed ("Gradient V Speed", Float) = -0.2
		_Gradient ("Gradient", 2D) = "white" {}
		_NoiseAmount ("Noise Amount", Range(-1, 1)) = 0.1144851
		_DistortionUSpeed ("Distortion U Speed", Float) = 0.2
		_DistortionVSpeed ("Distortion V Speed", Float) = 0
		_Distortion ("Distortion", 2D) = "white" {}
		_Mask ("Mask", 2D) = "white" {}
		_DoubleSided ("DoubleSided", Float) = 1
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
		Pass {
			Name "FORWARD"
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "PreviewType" = "Plane" "QUEUE" = "Transparent" "RenderType" = "Transparent" "SHADOWSUPPORT" = "true" }
			Blend One One, One One
			ZWrite Off
			Cull Off
			GpuProgramID 23205
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Mask;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTexutre;
					uniform lowp sampler2D _ColorRamp;
					uniform lowp sampler2D _Gradient;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec4 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec3 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					lowp float u_xlat10_3;
					vec2 u_xlat6;
					float u_xlat9;
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
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_0.x = texture2D(_Mask, u_xlat0.xy).x;
					    u_xlat10_3 = texture2D(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat10_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat10_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat10_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat10_0 = texture2D(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_1.x = texture2D(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat10_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat10_0.w * u_xlat1.x;
					    u_xlat1.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_1.xyz = texture2D(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat10_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat10_1.xyz = texture2D(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat10_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Mask;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTexutre;
					uniform lowp sampler2D _ColorRamp;
					uniform lowp sampler2D _Gradient;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec4 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec3 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					lowp float u_xlat10_3;
					vec2 u_xlat6;
					float u_xlat9;
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
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_0.x = texture2D(_Mask, u_xlat0.xy).x;
					    u_xlat10_3 = texture2D(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat10_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat10_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat10_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat10_0 = texture2D(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_1.x = texture2D(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat10_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat10_0.w * u_xlat1.x;
					    u_xlat1.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_1.xyz = texture2D(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat10_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat10_1.xyz = texture2D(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat10_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Mask;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTexutre;
					uniform lowp sampler2D _ColorRamp;
					uniform lowp sampler2D _Gradient;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec4 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec3 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					lowp float u_xlat10_3;
					vec2 u_xlat6;
					float u_xlat9;
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
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_0.x = texture2D(_Mask, u_xlat0.xy).x;
					    u_xlat10_3 = texture2D(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat10_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat10_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat10_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat10_0 = texture2D(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_1.x = texture2D(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat10_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat10_0.w * u_xlat1.x;
					    u_xlat1.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_1.xyz = texture2D(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat10_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat10_1.xyz = texture2D(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat10_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Mask;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTexutre;
					uniform mediump sampler2D _ColorRamp;
					uniform mediump sampler2D _Gradient;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec4 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					mediump float u_xlat16_3;
					vec2 u_xlat6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_0.x = texture(_Mask, u_xlat0.xy).x;
					    u_xlat16_3 = texture(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat16_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat16_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat16_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat16_0 = texture(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_1.x = texture(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat16_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat16_0.w * u_xlat1.x;
					    u_xlat1.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_1.xyz = texture(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat16_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat16_1.xyz = texture(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat16_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Mask;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTexutre;
					uniform mediump sampler2D _ColorRamp;
					uniform mediump sampler2D _Gradient;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec4 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					mediump float u_xlat16_3;
					vec2 u_xlat6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_0.x = texture(_Mask, u_xlat0.xy).x;
					    u_xlat16_3 = texture(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat16_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat16_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat16_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat16_0 = texture(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_1.x = texture(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat16_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat16_0.w * u_xlat1.x;
					    u_xlat1.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_1.xyz = texture(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat16_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat16_1.xyz = texture(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat16_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Mask;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTexutre;
					uniform mediump sampler2D _ColorRamp;
					uniform mediump sampler2D _Gradient;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec4 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					mediump float u_xlat16_3;
					vec2 u_xlat6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_0.x = texture(_Mask, u_xlat0.xy).x;
					    u_xlat16_3 = texture(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat16_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat16_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat16_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat16_0 = texture(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_1.x = texture(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat16_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat16_0.w * u_xlat1.x;
					    u_xlat1.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_1.xyz = texture(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat16_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat16_1.xyz = texture(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat16_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Mask;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTexutre;
					uniform lowp sampler2D _ColorRamp;
					uniform lowp sampler2D _Gradient;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec4 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec3 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					lowp float u_xlat10_3;
					vec2 u_xlat6;
					float u_xlat9;
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
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_0.x = texture2D(_Mask, u_xlat0.xy).x;
					    u_xlat10_3 = texture2D(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat10_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat10_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat10_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat10_0 = texture2D(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_1.x = texture2D(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat10_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat10_0.w * u_xlat1.x;
					    u_xlat1.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_1.xyz = texture2D(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat10_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat10_1.xyz = texture2D(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat10_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Mask;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTexutre;
					uniform lowp sampler2D _ColorRamp;
					uniform lowp sampler2D _Gradient;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec4 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec3 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					lowp float u_xlat10_3;
					vec2 u_xlat6;
					float u_xlat9;
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
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_0.x = texture2D(_Mask, u_xlat0.xy).x;
					    u_xlat10_3 = texture2D(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat10_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat10_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat10_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat10_0 = texture2D(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_1.x = texture2D(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat10_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat10_0.w * u_xlat1.x;
					    u_xlat1.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_1.xyz = texture2D(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat10_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat10_1.xyz = texture2D(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat10_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Mask;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTexutre;
					uniform lowp sampler2D _ColorRamp;
					uniform lowp sampler2D _Gradient;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec4 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec3 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					lowp float u_xlat10_3;
					vec2 u_xlat6;
					float u_xlat9;
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
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_0.x = texture2D(_Mask, u_xlat0.xy).x;
					    u_xlat10_3 = texture2D(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat10_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat10_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat10_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat10_0 = texture2D(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_1.x = texture2D(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat10_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat10_0.w * u_xlat1.x;
					    u_xlat1.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_1.xyz = texture2D(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat10_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat10_1.xyz = texture2D(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat10_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Mask;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTexutre;
					uniform mediump sampler2D _ColorRamp;
					uniform mediump sampler2D _Gradient;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec4 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					mediump float u_xlat16_3;
					vec2 u_xlat6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_0.x = texture(_Mask, u_xlat0.xy).x;
					    u_xlat16_3 = texture(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat16_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat16_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat16_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat16_0 = texture(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_1.x = texture(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat16_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat16_0.w * u_xlat1.x;
					    u_xlat1.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_1.xyz = texture(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat16_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat16_1.xyz = texture(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat16_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Mask;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTexutre;
					uniform mediump sampler2D _ColorRamp;
					uniform mediump sampler2D _Gradient;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec4 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					mediump float u_xlat16_3;
					vec2 u_xlat6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_0.x = texture(_Mask, u_xlat0.xy).x;
					    u_xlat16_3 = texture(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat16_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat16_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat16_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat16_0 = texture(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_1.x = texture(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat16_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat16_0.w * u_xlat1.x;
					    u_xlat1.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_1.xyz = texture(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat16_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat16_1.xyz = texture(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat16_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Mask;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTexutre;
					uniform mediump sampler2D _ColorRamp;
					uniform mediump sampler2D _Gradient;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec4 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					mediump float u_xlat16_3;
					vec2 u_xlat6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_0.x = texture(_Mask, u_xlat0.xy).x;
					    u_xlat16_3 = texture(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat16_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat16_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat16_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat16_0 = texture(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_1.x = texture(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat16_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat16_0.w * u_xlat1.x;
					    u_xlat1.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_1.xyz = texture(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat16_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat16_1.xyz = texture(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat16_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Mask;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTexutre;
					uniform lowp sampler2D _ColorRamp;
					uniform lowp sampler2D _Gradient;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec4 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec3 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					lowp float u_xlat10_3;
					vec2 u_xlat6;
					float u_xlat9;
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
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_0.x = texture2D(_Mask, u_xlat0.xy).x;
					    u_xlat10_3 = texture2D(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat10_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat10_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat10_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat10_0 = texture2D(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_1.x = texture2D(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat10_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat10_0.w * u_xlat1.x;
					    u_xlat1.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_1.xyz = texture2D(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat10_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat10_1.xyz = texture2D(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat10_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Mask;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTexutre;
					uniform lowp sampler2D _ColorRamp;
					uniform lowp sampler2D _Gradient;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec4 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec3 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					lowp float u_xlat10_3;
					vec2 u_xlat6;
					float u_xlat9;
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
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_0.x = texture2D(_Mask, u_xlat0.xy).x;
					    u_xlat10_3 = texture2D(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat10_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat10_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat10_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat10_0 = texture2D(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_1.x = texture2D(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat10_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat10_0.w * u_xlat1.x;
					    u_xlat1.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_1.xyz = texture2D(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat10_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat10_1.xyz = texture2D(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat10_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Mask;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTexutre;
					uniform lowp sampler2D _ColorRamp;
					uniform lowp sampler2D _Gradient;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec4 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec3 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					lowp float u_xlat10_3;
					vec2 u_xlat6;
					float u_xlat9;
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
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_0.x = texture2D(_Mask, u_xlat0.xy).x;
					    u_xlat10_3 = texture2D(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat10_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat10_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat10_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat10_0 = texture2D(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_1.x = texture2D(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat10_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat10_0.w * u_xlat1.x;
					    u_xlat1.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_1.xyz = texture2D(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat10_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat10_1.xyz = texture2D(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat10_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Mask;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTexutre;
					uniform mediump sampler2D _ColorRamp;
					uniform mediump sampler2D _Gradient;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec4 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					mediump float u_xlat16_3;
					vec2 u_xlat6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_0.x = texture(_Mask, u_xlat0.xy).x;
					    u_xlat16_3 = texture(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat16_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat16_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat16_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat16_0 = texture(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_1.x = texture(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat16_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat16_0.w * u_xlat1.x;
					    u_xlat1.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_1.xyz = texture(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat16_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat16_1.xyz = texture(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat16_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Mask;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTexutre;
					uniform mediump sampler2D _ColorRamp;
					uniform mediump sampler2D _Gradient;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec4 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					mediump float u_xlat16_3;
					vec2 u_xlat6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_0.x = texture(_Mask, u_xlat0.xy).x;
					    u_xlat16_3 = texture(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat16_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat16_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat16_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat16_0 = texture(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_1.x = texture(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat16_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat16_0.w * u_xlat1.x;
					    u_xlat1.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_1.xyz = texture(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat16_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat16_1.xyz = texture(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat16_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Mask;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTexutre;
					uniform mediump sampler2D _ColorRamp;
					uniform mediump sampler2D _Gradient;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec4 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					mediump float u_xlat16_3;
					vec2 u_xlat6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_0.x = texture(_Mask, u_xlat0.xy).x;
					    u_xlat16_3 = texture(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat16_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat16_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat16_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat16_0 = texture(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_1.x = texture(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat16_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat16_0.w * u_xlat1.x;
					    u_xlat1.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_1.xyz = texture(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat16_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat16_1.xyz = texture(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat16_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Mask;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTexutre;
					uniform lowp sampler2D _ColorRamp;
					uniform lowp sampler2D _Gradient;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec4 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec3 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					lowp float u_xlat10_3;
					vec2 u_xlat6;
					float u_xlat9;
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
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_0.x = texture2D(_Mask, u_xlat0.xy).x;
					    u_xlat10_3 = texture2D(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat10_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat10_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat10_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat10_0 = texture2D(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_1.x = texture2D(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat10_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat10_0.w * u_xlat1.x;
					    u_xlat1.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_1.xyz = texture2D(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat10_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat10_1.xyz = texture2D(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat10_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Mask;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTexutre;
					uniform lowp sampler2D _ColorRamp;
					uniform lowp sampler2D _Gradient;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec4 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec3 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					lowp float u_xlat10_3;
					vec2 u_xlat6;
					float u_xlat9;
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
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_0.x = texture2D(_Mask, u_xlat0.xy).x;
					    u_xlat10_3 = texture2D(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat10_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat10_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat10_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat10_0 = texture2D(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_1.x = texture2D(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat10_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat10_0.w * u_xlat1.x;
					    u_xlat1.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_1.xyz = texture2D(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat10_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat10_1.xyz = texture2D(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat10_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Mask;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTexutre;
					uniform lowp sampler2D _ColorRamp;
					uniform lowp sampler2D _Gradient;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec4 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec3 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					lowp float u_xlat10_3;
					vec2 u_xlat6;
					float u_xlat9;
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
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_0.x = texture2D(_Mask, u_xlat0.xy).x;
					    u_xlat10_3 = texture2D(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat10_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat10_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat10_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat10_0 = texture2D(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_1.x = texture2D(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat10_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat10_0.w * u_xlat1.x;
					    u_xlat1.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_1.xyz = texture2D(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat10_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat10_1.xyz = texture2D(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat10_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Mask;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTexutre;
					uniform mediump sampler2D _ColorRamp;
					uniform mediump sampler2D _Gradient;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec4 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					mediump float u_xlat16_3;
					vec2 u_xlat6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_0.x = texture(_Mask, u_xlat0.xy).x;
					    u_xlat16_3 = texture(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat16_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat16_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat16_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat16_0 = texture(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_1.x = texture(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat16_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat16_0.w * u_xlat1.x;
					    u_xlat1.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_1.xyz = texture(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat16_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat16_1.xyz = texture(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat16_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Mask;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTexutre;
					uniform mediump sampler2D _ColorRamp;
					uniform mediump sampler2D _Gradient;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec4 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					mediump float u_xlat16_3;
					vec2 u_xlat6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_0.x = texture(_Mask, u_xlat0.xy).x;
					    u_xlat16_3 = texture(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat16_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat16_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat16_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat16_0 = texture(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_1.x = texture(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat16_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat16_0.w * u_xlat1.x;
					    u_xlat1.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_1.xyz = texture(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat16_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat16_1.xyz = texture(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat16_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Mask;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTexutre;
					uniform mediump sampler2D _ColorRamp;
					uniform mediump sampler2D _Gradient;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec4 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					mediump float u_xlat16_3;
					vec2 u_xlat6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_0.x = texture(_Mask, u_xlat0.xy).x;
					    u_xlat16_3 = texture(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat16_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat16_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat16_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat16_0 = texture(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_1.x = texture(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat16_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat16_0.w * u_xlat1.x;
					    u_xlat1.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_1.xyz = texture(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat16_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat16_1.xyz = texture(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat16_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Mask;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTexutre;
					uniform lowp sampler2D _ColorRamp;
					uniform lowp sampler2D _Gradient;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec4 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec3 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					lowp float u_xlat10_3;
					vec2 u_xlat6;
					float u_xlat9;
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
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_0.x = texture2D(_Mask, u_xlat0.xy).x;
					    u_xlat10_3 = texture2D(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat10_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat10_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat10_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat10_0 = texture2D(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_1.x = texture2D(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat10_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat10_0.w * u_xlat1.x;
					    u_xlat1.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_1.xyz = texture2D(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat10_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat10_1.xyz = texture2D(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat10_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Mask;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTexutre;
					uniform lowp sampler2D _ColorRamp;
					uniform lowp sampler2D _Gradient;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec4 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec3 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					lowp float u_xlat10_3;
					vec2 u_xlat6;
					float u_xlat9;
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
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_0.x = texture2D(_Mask, u_xlat0.xy).x;
					    u_xlat10_3 = texture2D(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat10_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat10_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat10_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat10_0 = texture2D(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_1.x = texture2D(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat10_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat10_0.w * u_xlat1.x;
					    u_xlat1.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_1.xyz = texture2D(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat10_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat10_1.xyz = texture2D(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat10_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Mask;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTexutre;
					uniform lowp sampler2D _ColorRamp;
					uniform lowp sampler2D _Gradient;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec4 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec3 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					lowp float u_xlat10_3;
					vec2 u_xlat6;
					float u_xlat9;
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
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_0.x = texture2D(_Mask, u_xlat0.xy).x;
					    u_xlat10_3 = texture2D(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat10_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat10_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat10_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat10_0 = texture2D(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_1.x = texture2D(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat10_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat10_0.w * u_xlat1.x;
					    u_xlat1.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_1.xyz = texture2D(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat10_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat10_1.xyz = texture2D(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat10_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Mask;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTexutre;
					uniform mediump sampler2D _ColorRamp;
					uniform mediump sampler2D _Gradient;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec4 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					mediump float u_xlat16_3;
					vec2 u_xlat6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_0.x = texture(_Mask, u_xlat0.xy).x;
					    u_xlat16_3 = texture(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat16_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat16_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat16_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat16_0 = texture(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_1.x = texture(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat16_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat16_0.w * u_xlat1.x;
					    u_xlat1.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_1.xyz = texture(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat16_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat16_1.xyz = texture(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat16_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Mask;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTexutre;
					uniform mediump sampler2D _ColorRamp;
					uniform mediump sampler2D _Gradient;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec4 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					mediump float u_xlat16_3;
					vec2 u_xlat6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_0.x = texture(_Mask, u_xlat0.xy).x;
					    u_xlat16_3 = texture(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat16_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat16_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat16_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat16_0 = texture(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_1.x = texture(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat16_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat16_0.w * u_xlat1.x;
					    u_xlat1.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_1.xyz = texture(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat16_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat16_1.xyz = texture(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat16_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Mask;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTexutre;
					uniform mediump sampler2D _ColorRamp;
					uniform mediump sampler2D _Gradient;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec4 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					mediump float u_xlat16_3;
					vec2 u_xlat6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_0.x = texture(_Mask, u_xlat0.xy).x;
					    u_xlat16_3 = texture(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat16_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat16_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat16_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat16_0 = texture(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_1.x = texture(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat16_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat16_0.w * u_xlat1.x;
					    u_xlat1.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_1.xyz = texture(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat16_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat16_1.xyz = texture(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat16_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Mask;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTexutre;
					uniform lowp sampler2D _ColorRamp;
					uniform lowp sampler2D _Gradient;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec4 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec3 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					lowp float u_xlat10_3;
					vec2 u_xlat6;
					float u_xlat9;
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
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_0.x = texture2D(_Mask, u_xlat0.xy).x;
					    u_xlat10_3 = texture2D(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat10_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat10_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat10_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat10_0 = texture2D(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_1.x = texture2D(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat10_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat10_0.w * u_xlat1.x;
					    u_xlat1.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_1.xyz = texture2D(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat10_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat10_1.xyz = texture2D(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat10_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Mask;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTexutre;
					uniform lowp sampler2D _ColorRamp;
					uniform lowp sampler2D _Gradient;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec4 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec3 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					lowp float u_xlat10_3;
					vec2 u_xlat6;
					float u_xlat9;
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
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_0.x = texture2D(_Mask, u_xlat0.xy).x;
					    u_xlat10_3 = texture2D(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat10_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat10_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat10_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat10_0 = texture2D(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_1.x = texture2D(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat10_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat10_0.w * u_xlat1.x;
					    u_xlat1.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_1.xyz = texture2D(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat10_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat10_1.xyz = texture2D(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat10_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Mask;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTexutre;
					uniform lowp sampler2D _ColorRamp;
					uniform lowp sampler2D _Gradient;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec4 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec3 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					lowp float u_xlat10_3;
					vec2 u_xlat6;
					float u_xlat9;
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
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_0.x = texture2D(_Mask, u_xlat0.xy).x;
					    u_xlat10_3 = texture2D(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat10_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat10_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat10_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat10_0 = texture2D(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_1.x = texture2D(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat10_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat10_0.w * u_xlat1.x;
					    u_xlat1.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_1.xyz = texture2D(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat10_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat10_1.xyz = texture2D(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat10_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Mask;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTexutre;
					uniform mediump sampler2D _ColorRamp;
					uniform mediump sampler2D _Gradient;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec4 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					mediump float u_xlat16_3;
					vec2 u_xlat6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_0.x = texture(_Mask, u_xlat0.xy).x;
					    u_xlat16_3 = texture(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat16_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat16_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat16_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat16_0 = texture(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_1.x = texture(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat16_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat16_0.w * u_xlat1.x;
					    u_xlat1.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_1.xyz = texture(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat16_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat16_1.xyz = texture(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat16_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Mask;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTexutre;
					uniform mediump sampler2D _ColorRamp;
					uniform mediump sampler2D _Gradient;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec4 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					mediump float u_xlat16_3;
					vec2 u_xlat6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_0.x = texture(_Mask, u_xlat0.xy).x;
					    u_xlat16_3 = texture(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat16_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat16_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat16_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat16_0 = texture(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_1.x = texture(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat16_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat16_0.w * u_xlat1.x;
					    u_xlat1.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_1.xyz = texture(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat16_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat16_1.xyz = texture(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat16_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Mask;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTexutre;
					uniform mediump sampler2D _ColorRamp;
					uniform mediump sampler2D _Gradient;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec4 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					mediump float u_xlat16_3;
					vec2 u_xlat6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_0.x = texture(_Mask, u_xlat0.xy).x;
					    u_xlat16_3 = texture(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat16_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat16_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat16_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat16_0 = texture(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_1.x = texture(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat16_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat16_0.w * u_xlat1.x;
					    u_xlat1.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_1.xyz = texture(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat16_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat16_1.xyz = texture(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat16_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Mask;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTexutre;
					uniform lowp sampler2D _ColorRamp;
					uniform lowp sampler2D _Gradient;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec4 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec3 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					lowp float u_xlat10_3;
					vec2 u_xlat6;
					float u_xlat9;
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
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_0.x = texture2D(_Mask, u_xlat0.xy).x;
					    u_xlat10_3 = texture2D(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat10_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat10_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat10_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat10_0 = texture2D(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_1.x = texture2D(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat10_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat10_0.w * u_xlat1.x;
					    u_xlat1.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_1.xyz = texture2D(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat10_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat10_1.xyz = texture2D(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat10_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Mask;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTexutre;
					uniform lowp sampler2D _ColorRamp;
					uniform lowp sampler2D _Gradient;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec4 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec3 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					lowp float u_xlat10_3;
					vec2 u_xlat6;
					float u_xlat9;
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
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_0.x = texture2D(_Mask, u_xlat0.xy).x;
					    u_xlat10_3 = texture2D(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat10_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat10_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat10_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat10_0 = texture2D(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_1.x = texture2D(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat10_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat10_0.w * u_xlat1.x;
					    u_xlat1.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_1.xyz = texture2D(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat10_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat10_1.xyz = texture2D(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat10_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Mask;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTexutre;
					uniform lowp sampler2D _ColorRamp;
					uniform lowp sampler2D _Gradient;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec4 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec3 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					lowp float u_xlat10_3;
					vec2 u_xlat6;
					float u_xlat9;
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
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_0.x = texture2D(_Mask, u_xlat0.xy).x;
					    u_xlat10_3 = texture2D(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat10_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat10_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat10_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat10_0 = texture2D(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_1.x = texture2D(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat10_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat10_0.w * u_xlat1.x;
					    u_xlat1.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_1.xyz = texture2D(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat10_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat10_1.xyz = texture2D(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat10_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Mask;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTexutre;
					uniform mediump sampler2D _ColorRamp;
					uniform mediump sampler2D _Gradient;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec4 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					mediump float u_xlat16_3;
					vec2 u_xlat6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_0.x = texture(_Mask, u_xlat0.xy).x;
					    u_xlat16_3 = texture(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat16_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat16_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat16_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat16_0 = texture(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_1.x = texture(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat16_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat16_0.w * u_xlat1.x;
					    u_xlat1.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_1.xyz = texture(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat16_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat16_1.xyz = texture(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat16_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Mask;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTexutre;
					uniform mediump sampler2D _ColorRamp;
					uniform mediump sampler2D _Gradient;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec4 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					mediump float u_xlat16_3;
					vec2 u_xlat6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_0.x = texture(_Mask, u_xlat0.xy).x;
					    u_xlat16_3 = texture(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat16_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat16_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat16_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat16_0 = texture(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_1.x = texture(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat16_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat16_0.w * u_xlat1.x;
					    u_xlat1.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_1.xyz = texture(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat16_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat16_1.xyz = texture(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat16_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Mask;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTexutre;
					uniform mediump sampler2D _ColorRamp;
					uniform mediump sampler2D _Gradient;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec4 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					mediump float u_xlat16_3;
					vec2 u_xlat6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_0.x = texture(_Mask, u_xlat0.xy).x;
					    u_xlat16_3 = texture(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat16_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat16_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat16_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat16_0 = texture(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_1.x = texture(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat16_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat16_0.w * u_xlat1.x;
					    u_xlat1.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_1.xyz = texture(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat16_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat16_1.xyz = texture(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat16_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Mask;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTexutre;
					uniform lowp sampler2D _ColorRamp;
					uniform lowp sampler2D _Gradient;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec4 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec3 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					lowp float u_xlat10_3;
					vec2 u_xlat6;
					float u_xlat9;
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
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_0.x = texture2D(_Mask, u_xlat0.xy).x;
					    u_xlat10_3 = texture2D(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat10_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat10_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat10_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat10_0 = texture2D(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_1.x = texture2D(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat10_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat10_0.w * u_xlat1.x;
					    u_xlat1.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_1.xyz = texture2D(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat10_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat10_1.xyz = texture2D(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat10_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Mask;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTexutre;
					uniform lowp sampler2D _ColorRamp;
					uniform lowp sampler2D _Gradient;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec4 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec3 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					lowp float u_xlat10_3;
					vec2 u_xlat6;
					float u_xlat9;
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
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_0.x = texture2D(_Mask, u_xlat0.xy).x;
					    u_xlat10_3 = texture2D(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat10_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat10_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat10_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat10_0 = texture2D(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_1.x = texture2D(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat10_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat10_0.w * u_xlat1.x;
					    u_xlat1.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_1.xyz = texture2D(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat10_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat10_1.xyz = texture2D(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat10_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Mask;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTexutre;
					uniform lowp sampler2D _ColorRamp;
					uniform lowp sampler2D _Gradient;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec4 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec3 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					lowp float u_xlat10_3;
					vec2 u_xlat6;
					float u_xlat9;
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
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_0.x = texture2D(_Mask, u_xlat0.xy).x;
					    u_xlat10_3 = texture2D(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat10_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat10_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat10_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat10_0 = texture2D(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_1.x = texture2D(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat10_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat10_0.w * u_xlat1.x;
					    u_xlat1.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_1.xyz = texture2D(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat10_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat10_1.xyz = texture2D(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat10_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Mask;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTexutre;
					uniform mediump sampler2D _ColorRamp;
					uniform mediump sampler2D _Gradient;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec4 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					mediump float u_xlat16_3;
					vec2 u_xlat6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_0.x = texture(_Mask, u_xlat0.xy).x;
					    u_xlat16_3 = texture(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat16_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat16_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat16_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat16_0 = texture(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_1.x = texture(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat16_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat16_0.w * u_xlat1.x;
					    u_xlat1.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_1.xyz = texture(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat16_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat16_1.xyz = texture(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat16_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Mask;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTexutre;
					uniform mediump sampler2D _ColorRamp;
					uniform mediump sampler2D _Gradient;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec4 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					mediump float u_xlat16_3;
					vec2 u_xlat6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_0.x = texture(_Mask, u_xlat0.xy).x;
					    u_xlat16_3 = texture(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat16_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat16_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat16_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat16_0 = texture(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_1.x = texture(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat16_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat16_0.w * u_xlat1.x;
					    u_xlat1.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_1.xyz = texture(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat16_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat16_1.xyz = texture(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat16_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Mask;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTexutre;
					uniform mediump sampler2D _ColorRamp;
					uniform mediump sampler2D _Gradient;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec4 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					mediump float u_xlat16_3;
					vec2 u_xlat6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_0.x = texture(_Mask, u_xlat0.xy).x;
					    u_xlat16_3 = texture(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat16_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat16_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat16_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat16_0 = texture(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_1.x = texture(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat16_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat16_0.w * u_xlat1.x;
					    u_xlat1.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_1.xyz = texture(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat16_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat16_1.xyz = texture(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat16_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Mask;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTexutre;
					uniform lowp sampler2D _ColorRamp;
					uniform lowp sampler2D _Gradient;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec4 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec3 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					lowp float u_xlat10_3;
					vec2 u_xlat6;
					float u_xlat9;
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
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_0.x = texture2D(_Mask, u_xlat0.xy).x;
					    u_xlat10_3 = texture2D(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat10_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat10_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat10_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat10_0 = texture2D(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_1.x = texture2D(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat10_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat10_0.w * u_xlat1.x;
					    u_xlat1.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_1.xyz = texture2D(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat10_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat10_1.xyz = texture2D(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat10_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Mask;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTexutre;
					uniform lowp sampler2D _ColorRamp;
					uniform lowp sampler2D _Gradient;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec4 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec3 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					lowp float u_xlat10_3;
					vec2 u_xlat6;
					float u_xlat9;
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
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_0.x = texture2D(_Mask, u_xlat0.xy).x;
					    u_xlat10_3 = texture2D(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat10_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat10_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat10_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat10_0 = texture2D(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_1.x = texture2D(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat10_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat10_0.w * u_xlat1.x;
					    u_xlat1.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_1.xyz = texture2D(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat10_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat10_1.xyz = texture2D(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat10_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Mask;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTexutre;
					uniform lowp sampler2D _ColorRamp;
					uniform lowp sampler2D _Gradient;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec4 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec3 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					lowp float u_xlat10_3;
					vec2 u_xlat6;
					float u_xlat9;
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
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_0.x = texture2D(_Mask, u_xlat0.xy).x;
					    u_xlat10_3 = texture2D(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat10_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat10_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat10_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat10_0 = texture2D(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_1.x = texture2D(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat10_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat10_0.w * u_xlat1.x;
					    u_xlat1.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_1.xyz = texture2D(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat10_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat10_1.xyz = texture2D(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat10_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Mask;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTexutre;
					uniform mediump sampler2D _ColorRamp;
					uniform mediump sampler2D _Gradient;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec4 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					mediump float u_xlat16_3;
					vec2 u_xlat6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_0.x = texture(_Mask, u_xlat0.xy).x;
					    u_xlat16_3 = texture(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat16_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat16_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat16_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat16_0 = texture(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_1.x = texture(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat16_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat16_0.w * u_xlat1.x;
					    u_xlat1.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_1.xyz = texture(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat16_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat16_1.xyz = texture(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat16_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Mask;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTexutre;
					uniform mediump sampler2D _ColorRamp;
					uniform mediump sampler2D _Gradient;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec4 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					mediump float u_xlat16_3;
					vec2 u_xlat6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_0.x = texture(_Mask, u_xlat0.xy).x;
					    u_xlat16_3 = texture(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat16_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat16_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat16_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat16_0 = texture(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_1.x = texture(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat16_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat16_0.w * u_xlat1.x;
					    u_xlat1.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_1.xyz = texture(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat16_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat16_1.xyz = texture(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat16_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Mask;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTexutre;
					uniform mediump sampler2D _ColorRamp;
					uniform mediump sampler2D _Gradient;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec4 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					mediump float u_xlat16_3;
					vec2 u_xlat6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_0.x = texture(_Mask, u_xlat0.xy).x;
					    u_xlat16_3 = texture(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat16_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat16_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat16_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat16_0 = texture(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_1.x = texture(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat16_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat16_0.w * u_xlat1.x;
					    u_xlat1.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_1.xyz = texture(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat16_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat16_1.xyz = texture(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat16_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Mask;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTexutre;
					uniform lowp sampler2D _ColorRamp;
					uniform lowp sampler2D _Gradient;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec4 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec3 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					lowp float u_xlat10_3;
					vec2 u_xlat6;
					float u_xlat9;
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
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_0.x = texture2D(_Mask, u_xlat0.xy).x;
					    u_xlat10_3 = texture2D(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat10_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat10_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat10_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat10_0 = texture2D(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_1.x = texture2D(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat10_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat10_0.w * u_xlat1.x;
					    u_xlat1.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_1.xyz = texture2D(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat10_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat10_1.xyz = texture2D(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat10_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Mask;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTexutre;
					uniform lowp sampler2D _ColorRamp;
					uniform lowp sampler2D _Gradient;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec4 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec3 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					lowp float u_xlat10_3;
					vec2 u_xlat6;
					float u_xlat9;
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
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_0.x = texture2D(_Mask, u_xlat0.xy).x;
					    u_xlat10_3 = texture2D(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat10_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat10_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat10_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat10_0 = texture2D(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_1.x = texture2D(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat10_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat10_0.w * u_xlat1.x;
					    u_xlat1.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_1.xyz = texture2D(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat10_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat10_1.xyz = texture2D(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat10_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Mask;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTexutre;
					uniform lowp sampler2D _ColorRamp;
					uniform lowp sampler2D _Gradient;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec4 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec3 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					lowp float u_xlat10_3;
					vec2 u_xlat6;
					float u_xlat9;
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
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_0.x = texture2D(_Mask, u_xlat0.xy).x;
					    u_xlat10_3 = texture2D(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat10_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat10_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat10_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat10_0 = texture2D(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_1.x = texture2D(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat10_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat10_0.w * u_xlat1.x;
					    u_xlat1.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_1.xyz = texture2D(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat10_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat10_1.xyz = texture2D(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat10_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Mask;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTexutre;
					uniform mediump sampler2D _ColorRamp;
					uniform mediump sampler2D _Gradient;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec4 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					mediump float u_xlat16_3;
					vec2 u_xlat6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_0.x = texture(_Mask, u_xlat0.xy).x;
					    u_xlat16_3 = texture(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat16_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat16_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat16_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat16_0 = texture(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_1.x = texture(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat16_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat16_0.w * u_xlat1.x;
					    u_xlat1.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_1.xyz = texture(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat16_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat16_1.xyz = texture(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat16_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Mask;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTexutre;
					uniform mediump sampler2D _ColorRamp;
					uniform mediump sampler2D _Gradient;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec4 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					mediump float u_xlat16_3;
					vec2 u_xlat6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_0.x = texture(_Mask, u_xlat0.xy).x;
					    u_xlat16_3 = texture(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat16_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat16_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat16_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat16_0 = texture(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_1.x = texture(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat16_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat16_0.w * u_xlat1.x;
					    u_xlat1.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_1.xyz = texture(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat16_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat16_1.xyz = texture(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat16_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Mask;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTexutre;
					uniform mediump sampler2D _ColorRamp;
					uniform mediump sampler2D _Gradient;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec4 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					mediump float u_xlat16_3;
					vec2 u_xlat6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_0.x = texture(_Mask, u_xlat0.xy).x;
					    u_xlat16_3 = texture(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat16_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat16_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat16_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat16_0 = texture(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_1.x = texture(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat16_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat16_0.w * u_xlat1.x;
					    u_xlat1.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_1.xyz = texture(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat16_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat16_1.xyz = texture(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat16_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Mask;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTexutre;
					uniform lowp sampler2D _ColorRamp;
					uniform lowp sampler2D _Gradient;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec4 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec3 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					lowp float u_xlat10_3;
					vec2 u_xlat6;
					float u_xlat9;
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
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_0.x = texture2D(_Mask, u_xlat0.xy).x;
					    u_xlat10_3 = texture2D(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat10_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat10_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat10_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat10_0 = texture2D(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_1.x = texture2D(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat10_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat10_0.w * u_xlat1.x;
					    u_xlat1.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_1.xyz = texture2D(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat10_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat10_1.xyz = texture2D(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat10_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Mask;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTexutre;
					uniform lowp sampler2D _ColorRamp;
					uniform lowp sampler2D _Gradient;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec4 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec3 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					lowp float u_xlat10_3;
					vec2 u_xlat6;
					float u_xlat9;
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
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_0.x = texture2D(_Mask, u_xlat0.xy).x;
					    u_xlat10_3 = texture2D(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat10_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat10_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat10_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat10_0 = texture2D(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_1.x = texture2D(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat10_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat10_0.w * u_xlat1.x;
					    u_xlat1.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_1.xyz = texture2D(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat10_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat10_1.xyz = texture2D(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat10_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Mask;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTexutre;
					uniform lowp sampler2D _ColorRamp;
					uniform lowp sampler2D _Gradient;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec4 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec3 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					lowp float u_xlat10_3;
					vec2 u_xlat6;
					float u_xlat9;
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
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_0.x = texture2D(_Mask, u_xlat0.xy).x;
					    u_xlat10_3 = texture2D(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat10_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat10_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat10_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat10_0 = texture2D(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_1.x = texture2D(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat10_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat10_0.w * u_xlat1.x;
					    u_xlat1.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_1.xyz = texture2D(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat10_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat10_1.xyz = texture2D(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat10_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Mask;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTexutre;
					uniform mediump sampler2D _ColorRamp;
					uniform mediump sampler2D _Gradient;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec4 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					mediump float u_xlat16_3;
					vec2 u_xlat6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_0.x = texture(_Mask, u_xlat0.xy).x;
					    u_xlat16_3 = texture(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat16_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat16_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat16_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat16_0 = texture(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_1.x = texture(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat16_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat16_0.w * u_xlat1.x;
					    u_xlat1.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_1.xyz = texture(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat16_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat16_1.xyz = texture(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat16_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Mask;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTexutre;
					uniform mediump sampler2D _ColorRamp;
					uniform mediump sampler2D _Gradient;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec4 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					mediump float u_xlat16_3;
					vec2 u_xlat6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_0.x = texture(_Mask, u_xlat0.xy).x;
					    u_xlat16_3 = texture(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat16_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat16_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat16_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat16_0 = texture(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_1.x = texture(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat16_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat16_0.w * u_xlat1.x;
					    u_xlat1.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_1.xyz = texture(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat16_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat16_1.xyz = texture(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat16_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Mask;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTexutre;
					uniform mediump sampler2D _ColorRamp;
					uniform mediump sampler2D _Gradient;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec4 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					mediump float u_xlat16_3;
					vec2 u_xlat6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_0.x = texture(_Mask, u_xlat0.xy).x;
					    u_xlat16_3 = texture(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat16_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat16_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat16_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat16_0 = texture(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_1.x = texture(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat16_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat16_0.w * u_xlat1.x;
					    u_xlat1.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_1.xyz = texture(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat16_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat16_1.xyz = texture(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat16_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Mask;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTexutre;
					uniform lowp sampler2D _ColorRamp;
					uniform lowp sampler2D _Gradient;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec4 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec3 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					lowp float u_xlat10_3;
					vec2 u_xlat6;
					float u_xlat9;
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
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_0.x = texture2D(_Mask, u_xlat0.xy).x;
					    u_xlat10_3 = texture2D(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat10_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat10_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat10_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat10_0 = texture2D(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_1.x = texture2D(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat10_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat10_0.w * u_xlat1.x;
					    u_xlat1.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_1.xyz = texture2D(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat10_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat10_1.xyz = texture2D(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat10_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Mask;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTexutre;
					uniform lowp sampler2D _ColorRamp;
					uniform lowp sampler2D _Gradient;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec4 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec3 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					lowp float u_xlat10_3;
					vec2 u_xlat6;
					float u_xlat9;
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
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_0.x = texture2D(_Mask, u_xlat0.xy).x;
					    u_xlat10_3 = texture2D(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat10_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat10_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat10_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat10_0 = texture2D(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_1.x = texture2D(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat10_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat10_0.w * u_xlat1.x;
					    u_xlat1.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_1.xyz = texture2D(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat10_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat10_1.xyz = texture2D(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat10_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Mask;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTexutre;
					uniform lowp sampler2D _ColorRamp;
					uniform lowp sampler2D _Gradient;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec4 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec3 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					lowp float u_xlat10_3;
					vec2 u_xlat6;
					float u_xlat9;
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
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_0.x = texture2D(_Mask, u_xlat0.xy).x;
					    u_xlat10_3 = texture2D(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat10_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat10_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat10_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat10_0 = texture2D(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_1.x = texture2D(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat10_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat10_0.w * u_xlat1.x;
					    u_xlat1.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_1.xyz = texture2D(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat10_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat10_1.xyz = texture2D(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat10_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Mask;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTexutre;
					uniform mediump sampler2D _ColorRamp;
					uniform mediump sampler2D _Gradient;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec4 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					mediump float u_xlat16_3;
					vec2 u_xlat6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_0.x = texture(_Mask, u_xlat0.xy).x;
					    u_xlat16_3 = texture(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat16_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat16_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat16_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat16_0 = texture(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_1.x = texture(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat16_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat16_0.w * u_xlat1.x;
					    u_xlat1.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_1.xyz = texture(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat16_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat16_1.xyz = texture(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat16_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Mask;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTexutre;
					uniform mediump sampler2D _ColorRamp;
					uniform mediump sampler2D _Gradient;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec4 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					mediump float u_xlat16_3;
					vec2 u_xlat6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_0.x = texture(_Mask, u_xlat0.xy).x;
					    u_xlat16_3 = texture(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat16_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat16_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat16_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat16_0 = texture(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_1.x = texture(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat16_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat16_0.w * u_xlat1.x;
					    u_xlat1.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_1.xyz = texture(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat16_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat16_1.xyz = texture(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat16_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Mask;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTexutre;
					uniform mediump sampler2D _ColorRamp;
					uniform mediump sampler2D _Gradient;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec4 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					mediump float u_xlat16_3;
					vec2 u_xlat6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_0.x = texture(_Mask, u_xlat0.xy).x;
					    u_xlat16_3 = texture(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat16_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat16_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat16_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat16_0 = texture(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_1.x = texture(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat16_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat16_0.w * u_xlat1.x;
					    u_xlat1.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_1.xyz = texture(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat16_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat16_1.xyz = texture(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat16_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Mask;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTexutre;
					uniform lowp sampler2D _ColorRamp;
					uniform lowp sampler2D _Gradient;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec4 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec3 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					lowp float u_xlat10_3;
					vec2 u_xlat6;
					float u_xlat9;
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
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_0.x = texture2D(_Mask, u_xlat0.xy).x;
					    u_xlat10_3 = texture2D(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat10_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat10_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat10_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat10_0 = texture2D(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_1.x = texture2D(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat10_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat10_0.w * u_xlat1.x;
					    u_xlat1.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_1.xyz = texture2D(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat10_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat10_1.xyz = texture2D(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat10_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9) + vec3(-0.5, -0.5, -0.5);
					    u_xlat9 = vs_TEXCOORD1;
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz + vec3(0.5, 0.5, 0.5);
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Mask;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTexutre;
					uniform lowp sampler2D _ColorRamp;
					uniform lowp sampler2D _Gradient;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec4 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec3 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					lowp float u_xlat10_3;
					vec2 u_xlat6;
					float u_xlat9;
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
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_0.x = texture2D(_Mask, u_xlat0.xy).x;
					    u_xlat10_3 = texture2D(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat10_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat10_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat10_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat10_0 = texture2D(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_1.x = texture2D(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat10_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat10_0.w * u_xlat1.x;
					    u_xlat1.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_1.xyz = texture2D(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat10_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat10_1.xyz = texture2D(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat10_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9) + vec3(-0.5, -0.5, -0.5);
					    u_xlat9 = vs_TEXCOORD1;
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz + vec3(0.5, 0.5, 0.5);
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Mask;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTexutre;
					uniform lowp sampler2D _ColorRamp;
					uniform lowp sampler2D _Gradient;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec4 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec3 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					lowp float u_xlat10_3;
					vec2 u_xlat6;
					float u_xlat9;
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
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_0.x = texture2D(_Mask, u_xlat0.xy).x;
					    u_xlat10_3 = texture2D(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat10_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat10_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat10_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat10_0 = texture2D(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_1.x = texture2D(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat10_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat10_0.w * u_xlat1.x;
					    u_xlat1.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_1.xyz = texture2D(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat10_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat10_1.xyz = texture2D(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat10_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9) + vec3(-0.5, -0.5, -0.5);
					    u_xlat9 = vs_TEXCOORD1;
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz + vec3(0.5, 0.5, 0.5);
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Mask;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTexutre;
					uniform mediump sampler2D _ColorRamp;
					uniform mediump sampler2D _Gradient;
					in highp vec2 vs_TEXCOORD0;
					in highp float vs_TEXCOORD1;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec4 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					mediump float u_xlat16_3;
					vec2 u_xlat6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_0.x = texture(_Mask, u_xlat0.xy).x;
					    u_xlat16_3 = texture(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat16_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat16_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat16_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat16_0 = texture(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_1.x = texture(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat16_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat16_0.w * u_xlat1.x;
					    u_xlat1.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_1.xyz = texture(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat16_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat16_1.xyz = texture(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat16_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9) + vec3(-0.5, -0.5, -0.5);
					    u_xlat9 = vs_TEXCOORD1;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat9 = min(max(u_xlat9, 0.0), 1.0);
					#else
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz + vec3(0.5, 0.5, 0.5);
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Mask;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTexutre;
					uniform mediump sampler2D _ColorRamp;
					uniform mediump sampler2D _Gradient;
					in highp vec2 vs_TEXCOORD0;
					in highp float vs_TEXCOORD1;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec4 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					mediump float u_xlat16_3;
					vec2 u_xlat6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_0.x = texture(_Mask, u_xlat0.xy).x;
					    u_xlat16_3 = texture(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat16_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat16_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat16_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat16_0 = texture(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_1.x = texture(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat16_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat16_0.w * u_xlat1.x;
					    u_xlat1.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_1.xyz = texture(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat16_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat16_1.xyz = texture(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat16_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9) + vec3(-0.5, -0.5, -0.5);
					    u_xlat9 = vs_TEXCOORD1;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat9 = min(max(u_xlat9, 0.0), 1.0);
					#else
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz + vec3(0.5, 0.5, 0.5);
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Mask;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTexutre;
					uniform mediump sampler2D _ColorRamp;
					uniform mediump sampler2D _Gradient;
					in highp vec2 vs_TEXCOORD0;
					in highp float vs_TEXCOORD1;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec4 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					mediump float u_xlat16_3;
					vec2 u_xlat6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_0.x = texture(_Mask, u_xlat0.xy).x;
					    u_xlat16_3 = texture(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat16_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat16_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat16_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat16_0 = texture(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_1.x = texture(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat16_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat16_0.w * u_xlat1.x;
					    u_xlat1.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_1.xyz = texture(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat16_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat16_1.xyz = texture(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat16_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9) + vec3(-0.5, -0.5, -0.5);
					    u_xlat9 = vs_TEXCOORD1;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat9 = min(max(u_xlat9, 0.0), 1.0);
					#else
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz + vec3(0.5, 0.5, 0.5);
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Mask;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTexutre;
					uniform lowp sampler2D _ColorRamp;
					uniform lowp sampler2D _Gradient;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec4 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec3 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					lowp float u_xlat10_3;
					vec2 u_xlat6;
					float u_xlat9;
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
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_0.x = texture2D(_Mask, u_xlat0.xy).x;
					    u_xlat10_3 = texture2D(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat10_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat10_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat10_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat10_0 = texture2D(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_1.x = texture2D(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat10_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat10_0.w * u_xlat1.x;
					    u_xlat1.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_1.xyz = texture2D(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat10_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat10_1.xyz = texture2D(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat10_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9) + vec3(-0.5, -0.5, -0.5);
					    u_xlat9 = vs_TEXCOORD1;
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz + vec3(0.5, 0.5, 0.5);
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Mask;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTexutre;
					uniform lowp sampler2D _ColorRamp;
					uniform lowp sampler2D _Gradient;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec4 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec3 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					lowp float u_xlat10_3;
					vec2 u_xlat6;
					float u_xlat9;
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
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_0.x = texture2D(_Mask, u_xlat0.xy).x;
					    u_xlat10_3 = texture2D(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat10_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat10_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat10_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat10_0 = texture2D(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_1.x = texture2D(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat10_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat10_0.w * u_xlat1.x;
					    u_xlat1.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_1.xyz = texture2D(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat10_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat10_1.xyz = texture2D(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat10_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9) + vec3(-0.5, -0.5, -0.5);
					    u_xlat9 = vs_TEXCOORD1;
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz + vec3(0.5, 0.5, 0.5);
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Mask;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTexutre;
					uniform lowp sampler2D _ColorRamp;
					uniform lowp sampler2D _Gradient;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec4 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec3 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					lowp float u_xlat10_3;
					vec2 u_xlat6;
					float u_xlat9;
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
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_0.x = texture2D(_Mask, u_xlat0.xy).x;
					    u_xlat10_3 = texture2D(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat10_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat10_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat10_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat10_0 = texture2D(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_1.x = texture2D(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat10_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat10_0.w * u_xlat1.x;
					    u_xlat1.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_1.xyz = texture2D(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat10_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat10_1.xyz = texture2D(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat10_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9) + vec3(-0.5, -0.5, -0.5);
					    u_xlat9 = vs_TEXCOORD1;
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz + vec3(0.5, 0.5, 0.5);
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Mask;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTexutre;
					uniform mediump sampler2D _ColorRamp;
					uniform mediump sampler2D _Gradient;
					in highp vec2 vs_TEXCOORD0;
					in highp float vs_TEXCOORD1;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec4 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					mediump float u_xlat16_3;
					vec2 u_xlat6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_0.x = texture(_Mask, u_xlat0.xy).x;
					    u_xlat16_3 = texture(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat16_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat16_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat16_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat16_0 = texture(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_1.x = texture(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat16_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat16_0.w * u_xlat1.x;
					    u_xlat1.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_1.xyz = texture(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat16_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat16_1.xyz = texture(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat16_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9) + vec3(-0.5, -0.5, -0.5);
					    u_xlat9 = vs_TEXCOORD1;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat9 = min(max(u_xlat9, 0.0), 1.0);
					#else
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz + vec3(0.5, 0.5, 0.5);
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Mask;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTexutre;
					uniform mediump sampler2D _ColorRamp;
					uniform mediump sampler2D _Gradient;
					in highp vec2 vs_TEXCOORD0;
					in highp float vs_TEXCOORD1;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec4 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					mediump float u_xlat16_3;
					vec2 u_xlat6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_0.x = texture(_Mask, u_xlat0.xy).x;
					    u_xlat16_3 = texture(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat16_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat16_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat16_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat16_0 = texture(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_1.x = texture(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat16_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat16_0.w * u_xlat1.x;
					    u_xlat1.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_1.xyz = texture(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat16_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat16_1.xyz = texture(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat16_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9) + vec3(-0.5, -0.5, -0.5);
					    u_xlat9 = vs_TEXCOORD1;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat9 = min(max(u_xlat9, 0.0), 1.0);
					#else
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz + vec3(0.5, 0.5, 0.5);
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Mask;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTexutre;
					uniform mediump sampler2D _ColorRamp;
					uniform mediump sampler2D _Gradient;
					in highp vec2 vs_TEXCOORD0;
					in highp float vs_TEXCOORD1;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec4 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					mediump float u_xlat16_3;
					vec2 u_xlat6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_0.x = texture(_Mask, u_xlat0.xy).x;
					    u_xlat16_3 = texture(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat16_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat16_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat16_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat16_0 = texture(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_1.x = texture(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat16_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat16_0.w * u_xlat1.x;
					    u_xlat1.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_1.xyz = texture(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat16_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat16_1.xyz = texture(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat16_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9) + vec3(-0.5, -0.5, -0.5);
					    u_xlat9 = vs_TEXCOORD1;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat9 = min(max(u_xlat9, 0.0), 1.0);
					#else
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz + vec3(0.5, 0.5, 0.5);
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Mask;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTexutre;
					uniform lowp sampler2D _ColorRamp;
					uniform lowp sampler2D _Gradient;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec4 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec3 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					lowp float u_xlat10_3;
					vec2 u_xlat6;
					float u_xlat9;
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
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_0.x = texture2D(_Mask, u_xlat0.xy).x;
					    u_xlat10_3 = texture2D(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat10_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat10_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat10_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat10_0 = texture2D(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_1.x = texture2D(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat10_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat10_0.w * u_xlat1.x;
					    u_xlat1.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_1.xyz = texture2D(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat10_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat10_1.xyz = texture2D(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat10_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9) + vec3(-0.5, -0.5, -0.5);
					    u_xlat9 = vs_TEXCOORD1;
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz + vec3(0.5, 0.5, 0.5);
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Mask;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTexutre;
					uniform lowp sampler2D _ColorRamp;
					uniform lowp sampler2D _Gradient;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec4 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec3 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					lowp float u_xlat10_3;
					vec2 u_xlat6;
					float u_xlat9;
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
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_0.x = texture2D(_Mask, u_xlat0.xy).x;
					    u_xlat10_3 = texture2D(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat10_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat10_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat10_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat10_0 = texture2D(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_1.x = texture2D(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat10_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat10_0.w * u_xlat1.x;
					    u_xlat1.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_1.xyz = texture2D(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat10_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat10_1.xyz = texture2D(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat10_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9) + vec3(-0.5, -0.5, -0.5);
					    u_xlat9 = vs_TEXCOORD1;
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz + vec3(0.5, 0.5, 0.5);
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Mask;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTexutre;
					uniform lowp sampler2D _ColorRamp;
					uniform lowp sampler2D _Gradient;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec4 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec3 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					lowp float u_xlat10_3;
					vec2 u_xlat6;
					float u_xlat9;
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
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_0.x = texture2D(_Mask, u_xlat0.xy).x;
					    u_xlat10_3 = texture2D(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat10_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat10_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat10_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat10_0 = texture2D(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_1.x = texture2D(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat10_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat10_0.w * u_xlat1.x;
					    u_xlat1.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_1.xyz = texture2D(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat10_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat10_1.xyz = texture2D(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat10_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9) + vec3(-0.5, -0.5, -0.5);
					    u_xlat9 = vs_TEXCOORD1;
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz + vec3(0.5, 0.5, 0.5);
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Mask;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTexutre;
					uniform mediump sampler2D _ColorRamp;
					uniform mediump sampler2D _Gradient;
					in highp vec2 vs_TEXCOORD0;
					in highp float vs_TEXCOORD1;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec4 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					mediump float u_xlat16_3;
					vec2 u_xlat6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_0.x = texture(_Mask, u_xlat0.xy).x;
					    u_xlat16_3 = texture(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat16_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat16_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat16_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat16_0 = texture(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_1.x = texture(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat16_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat16_0.w * u_xlat1.x;
					    u_xlat1.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_1.xyz = texture(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat16_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat16_1.xyz = texture(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat16_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9) + vec3(-0.5, -0.5, -0.5);
					    u_xlat9 = vs_TEXCOORD1;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat9 = min(max(u_xlat9, 0.0), 1.0);
					#else
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz + vec3(0.5, 0.5, 0.5);
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Mask;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTexutre;
					uniform mediump sampler2D _ColorRamp;
					uniform mediump sampler2D _Gradient;
					in highp vec2 vs_TEXCOORD0;
					in highp float vs_TEXCOORD1;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec4 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					mediump float u_xlat16_3;
					vec2 u_xlat6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_0.x = texture(_Mask, u_xlat0.xy).x;
					    u_xlat16_3 = texture(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat16_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat16_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat16_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat16_0 = texture(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_1.x = texture(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat16_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat16_0.w * u_xlat1.x;
					    u_xlat1.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_1.xyz = texture(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat16_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat16_1.xyz = texture(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat16_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9) + vec3(-0.5, -0.5, -0.5);
					    u_xlat9 = vs_TEXCOORD1;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat9 = min(max(u_xlat9, 0.0), 1.0);
					#else
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz + vec3(0.5, 0.5, 0.5);
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Mask;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTexutre;
					uniform mediump sampler2D _ColorRamp;
					uniform mediump sampler2D _Gradient;
					in highp vec2 vs_TEXCOORD0;
					in highp float vs_TEXCOORD1;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec4 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					mediump float u_xlat16_3;
					vec2 u_xlat6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_0.x = texture(_Mask, u_xlat0.xy).x;
					    u_xlat16_3 = texture(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat16_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat16_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat16_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat16_0 = texture(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_1.x = texture(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat16_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat16_0.w * u_xlat1.x;
					    u_xlat1.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_1.xyz = texture(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat16_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat16_1.xyz = texture(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat16_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9) + vec3(-0.5, -0.5, -0.5);
					    u_xlat9 = vs_TEXCOORD1;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat9 = min(max(u_xlat9, 0.0), 1.0);
					#else
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz + vec3(0.5, 0.5, 0.5);
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Mask;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTexutre;
					uniform lowp sampler2D _ColorRamp;
					uniform lowp sampler2D _Gradient;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec4 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec3 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					lowp float u_xlat10_3;
					vec2 u_xlat6;
					float u_xlat9;
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
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_0.x = texture2D(_Mask, u_xlat0.xy).x;
					    u_xlat10_3 = texture2D(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat10_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat10_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat10_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat10_0 = texture2D(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_1.x = texture2D(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat10_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat10_0.w * u_xlat1.x;
					    u_xlat1.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_1.xyz = texture2D(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat10_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat10_1.xyz = texture2D(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat10_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9) + vec3(-0.5, -0.5, -0.5);
					    u_xlat9 = vs_TEXCOORD1;
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz + vec3(0.5, 0.5, 0.5);
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Mask;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTexutre;
					uniform lowp sampler2D _ColorRamp;
					uniform lowp sampler2D _Gradient;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec4 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec3 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					lowp float u_xlat10_3;
					vec2 u_xlat6;
					float u_xlat9;
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
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_0.x = texture2D(_Mask, u_xlat0.xy).x;
					    u_xlat10_3 = texture2D(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat10_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat10_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat10_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat10_0 = texture2D(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_1.x = texture2D(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat10_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat10_0.w * u_xlat1.x;
					    u_xlat1.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_1.xyz = texture2D(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat10_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat10_1.xyz = texture2D(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat10_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9) + vec3(-0.5, -0.5, -0.5);
					    u_xlat9 = vs_TEXCOORD1;
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz + vec3(0.5, 0.5, 0.5);
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Mask;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTexutre;
					uniform lowp sampler2D _ColorRamp;
					uniform lowp sampler2D _Gradient;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec4 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec3 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					lowp float u_xlat10_3;
					vec2 u_xlat6;
					float u_xlat9;
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
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_0.x = texture2D(_Mask, u_xlat0.xy).x;
					    u_xlat10_3 = texture2D(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat10_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat10_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat10_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat10_0 = texture2D(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_1.x = texture2D(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat10_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat10_0.w * u_xlat1.x;
					    u_xlat1.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_1.xyz = texture2D(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat10_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat10_1.xyz = texture2D(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat10_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9) + vec3(-0.5, -0.5, -0.5);
					    u_xlat9 = vs_TEXCOORD1;
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz + vec3(0.5, 0.5, 0.5);
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Mask;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTexutre;
					uniform mediump sampler2D _ColorRamp;
					uniform mediump sampler2D _Gradient;
					in highp vec2 vs_TEXCOORD0;
					in highp float vs_TEXCOORD1;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec4 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					mediump float u_xlat16_3;
					vec2 u_xlat6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_0.x = texture(_Mask, u_xlat0.xy).x;
					    u_xlat16_3 = texture(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat16_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat16_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat16_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat16_0 = texture(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_1.x = texture(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat16_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat16_0.w * u_xlat1.x;
					    u_xlat1.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_1.xyz = texture(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat16_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat16_1.xyz = texture(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat16_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9) + vec3(-0.5, -0.5, -0.5);
					    u_xlat9 = vs_TEXCOORD1;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat9 = min(max(u_xlat9, 0.0), 1.0);
					#else
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz + vec3(0.5, 0.5, 0.5);
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Mask;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTexutre;
					uniform mediump sampler2D _ColorRamp;
					uniform mediump sampler2D _Gradient;
					in highp vec2 vs_TEXCOORD0;
					in highp float vs_TEXCOORD1;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec4 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					mediump float u_xlat16_3;
					vec2 u_xlat6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_0.x = texture(_Mask, u_xlat0.xy).x;
					    u_xlat16_3 = texture(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat16_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat16_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat16_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat16_0 = texture(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_1.x = texture(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat16_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat16_0.w * u_xlat1.x;
					    u_xlat1.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_1.xyz = texture(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat16_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat16_1.xyz = texture(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat16_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9) + vec3(-0.5, -0.5, -0.5);
					    u_xlat9 = vs_TEXCOORD1;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat9 = min(max(u_xlat9, 0.0), 1.0);
					#else
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz + vec3(0.5, 0.5, 0.5);
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Mask;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTexutre;
					uniform mediump sampler2D _ColorRamp;
					uniform mediump sampler2D _Gradient;
					in highp vec2 vs_TEXCOORD0;
					in highp float vs_TEXCOORD1;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec4 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					mediump float u_xlat16_3;
					vec2 u_xlat6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_0.x = texture(_Mask, u_xlat0.xy).x;
					    u_xlat16_3 = texture(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat16_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat16_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat16_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat16_0 = texture(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_1.x = texture(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat16_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat16_0.w * u_xlat1.x;
					    u_xlat1.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_1.xyz = texture(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat16_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat16_1.xyz = texture(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat16_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9) + vec3(-0.5, -0.5, -0.5);
					    u_xlat9 = vs_TEXCOORD1;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat9 = min(max(u_xlat9, 0.0), 1.0);
					#else
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz + vec3(0.5, 0.5, 0.5);
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Mask;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTexutre;
					uniform lowp sampler2D _ColorRamp;
					uniform lowp sampler2D _Gradient;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec4 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec3 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					lowp float u_xlat10_3;
					vec2 u_xlat6;
					float u_xlat9;
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
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_0.x = texture2D(_Mask, u_xlat0.xy).x;
					    u_xlat10_3 = texture2D(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat10_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat10_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat10_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat10_0 = texture2D(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_1.x = texture2D(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat10_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat10_0.w * u_xlat1.x;
					    u_xlat1.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_1.xyz = texture2D(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat10_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat10_1.xyz = texture2D(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat10_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9) + vec3(-0.5, -0.5, -0.5);
					    u_xlat9 = vs_TEXCOORD1;
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz + vec3(0.5, 0.5, 0.5);
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Mask;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTexutre;
					uniform lowp sampler2D _ColorRamp;
					uniform lowp sampler2D _Gradient;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec4 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec3 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					lowp float u_xlat10_3;
					vec2 u_xlat6;
					float u_xlat9;
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
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_0.x = texture2D(_Mask, u_xlat0.xy).x;
					    u_xlat10_3 = texture2D(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat10_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat10_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat10_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat10_0 = texture2D(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_1.x = texture2D(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat10_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat10_0.w * u_xlat1.x;
					    u_xlat1.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_1.xyz = texture2D(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat10_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat10_1.xyz = texture2D(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat10_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9) + vec3(-0.5, -0.5, -0.5);
					    u_xlat9 = vs_TEXCOORD1;
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz + vec3(0.5, 0.5, 0.5);
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Mask;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTexutre;
					uniform lowp sampler2D _ColorRamp;
					uniform lowp sampler2D _Gradient;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec4 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec3 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					lowp float u_xlat10_3;
					vec2 u_xlat6;
					float u_xlat9;
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
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_0.x = texture2D(_Mask, u_xlat0.xy).x;
					    u_xlat10_3 = texture2D(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat10_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat10_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat10_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat10_0 = texture2D(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_1.x = texture2D(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat10_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat10_0.w * u_xlat1.x;
					    u_xlat1.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_1.xyz = texture2D(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat10_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat10_1.xyz = texture2D(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat10_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9) + vec3(-0.5, -0.5, -0.5);
					    u_xlat9 = vs_TEXCOORD1;
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz + vec3(0.5, 0.5, 0.5);
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Mask;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTexutre;
					uniform mediump sampler2D _ColorRamp;
					uniform mediump sampler2D _Gradient;
					in highp vec2 vs_TEXCOORD0;
					in highp float vs_TEXCOORD1;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec4 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					mediump float u_xlat16_3;
					vec2 u_xlat6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_0.x = texture(_Mask, u_xlat0.xy).x;
					    u_xlat16_3 = texture(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat16_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat16_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat16_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat16_0 = texture(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_1.x = texture(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat16_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat16_0.w * u_xlat1.x;
					    u_xlat1.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_1.xyz = texture(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat16_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat16_1.xyz = texture(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat16_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9) + vec3(-0.5, -0.5, -0.5);
					    u_xlat9 = vs_TEXCOORD1;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat9 = min(max(u_xlat9, 0.0), 1.0);
					#else
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz + vec3(0.5, 0.5, 0.5);
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Mask;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTexutre;
					uniform mediump sampler2D _ColorRamp;
					uniform mediump sampler2D _Gradient;
					in highp vec2 vs_TEXCOORD0;
					in highp float vs_TEXCOORD1;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec4 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					mediump float u_xlat16_3;
					vec2 u_xlat6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_0.x = texture(_Mask, u_xlat0.xy).x;
					    u_xlat16_3 = texture(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat16_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat16_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat16_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat16_0 = texture(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_1.x = texture(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat16_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat16_0.w * u_xlat1.x;
					    u_xlat1.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_1.xyz = texture(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat16_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat16_1.xyz = texture(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat16_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9) + vec3(-0.5, -0.5, -0.5);
					    u_xlat9 = vs_TEXCOORD1;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat9 = min(max(u_xlat9, 0.0), 1.0);
					#else
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz + vec3(0.5, 0.5, 0.5);
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Mask;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTexutre;
					uniform mediump sampler2D _ColorRamp;
					uniform mediump sampler2D _Gradient;
					in highp vec2 vs_TEXCOORD0;
					in highp float vs_TEXCOORD1;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec4 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					mediump float u_xlat16_3;
					vec2 u_xlat6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_0.x = texture(_Mask, u_xlat0.xy).x;
					    u_xlat16_3 = texture(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat16_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat16_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat16_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat16_0 = texture(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_1.x = texture(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat16_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat16_0.w * u_xlat1.x;
					    u_xlat1.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_1.xyz = texture(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat16_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat16_1.xyz = texture(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat16_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9) + vec3(-0.5, -0.5, -0.5);
					    u_xlat9 = vs_TEXCOORD1;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat9 = min(max(u_xlat9, 0.0), 1.0);
					#else
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz + vec3(0.5, 0.5, 0.5);
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Mask;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTexutre;
					uniform lowp sampler2D _ColorRamp;
					uniform lowp sampler2D _Gradient;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec4 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec3 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					lowp float u_xlat10_3;
					vec2 u_xlat6;
					float u_xlat9;
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
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_0.x = texture2D(_Mask, u_xlat0.xy).x;
					    u_xlat10_3 = texture2D(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat10_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat10_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat10_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat10_0 = texture2D(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_1.x = texture2D(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat10_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat10_0.w * u_xlat1.x;
					    u_xlat1.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_1.xyz = texture2D(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat10_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat10_1.xyz = texture2D(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat10_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9) + vec3(-0.5, -0.5, -0.5);
					    u_xlat9 = vs_TEXCOORD1;
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz + vec3(0.5, 0.5, 0.5);
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Mask;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTexutre;
					uniform lowp sampler2D _ColorRamp;
					uniform lowp sampler2D _Gradient;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec4 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec3 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					lowp float u_xlat10_3;
					vec2 u_xlat6;
					float u_xlat9;
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
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_0.x = texture2D(_Mask, u_xlat0.xy).x;
					    u_xlat10_3 = texture2D(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat10_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat10_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat10_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat10_0 = texture2D(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_1.x = texture2D(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat10_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat10_0.w * u_xlat1.x;
					    u_xlat1.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_1.xyz = texture2D(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat10_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat10_1.xyz = texture2D(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat10_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9) + vec3(-0.5, -0.5, -0.5);
					    u_xlat9 = vs_TEXCOORD1;
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz + vec3(0.5, 0.5, 0.5);
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Mask;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTexutre;
					uniform lowp sampler2D _ColorRamp;
					uniform lowp sampler2D _Gradient;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec4 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec3 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					lowp float u_xlat10_3;
					vec2 u_xlat6;
					float u_xlat9;
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
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_0.x = texture2D(_Mask, u_xlat0.xy).x;
					    u_xlat10_3 = texture2D(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat10_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat10_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat10_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat10_0 = texture2D(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_1.x = texture2D(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat10_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat10_0.w * u_xlat1.x;
					    u_xlat1.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_1.xyz = texture2D(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat10_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat10_1.xyz = texture2D(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat10_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9) + vec3(-0.5, -0.5, -0.5);
					    u_xlat9 = vs_TEXCOORD1;
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz + vec3(0.5, 0.5, 0.5);
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Mask;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTexutre;
					uniform mediump sampler2D _ColorRamp;
					uniform mediump sampler2D _Gradient;
					in highp vec2 vs_TEXCOORD0;
					in highp float vs_TEXCOORD1;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec4 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					mediump float u_xlat16_3;
					vec2 u_xlat6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_0.x = texture(_Mask, u_xlat0.xy).x;
					    u_xlat16_3 = texture(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat16_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat16_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat16_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat16_0 = texture(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_1.x = texture(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat16_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat16_0.w * u_xlat1.x;
					    u_xlat1.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_1.xyz = texture(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat16_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat16_1.xyz = texture(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat16_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9) + vec3(-0.5, -0.5, -0.5);
					    u_xlat9 = vs_TEXCOORD1;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat9 = min(max(u_xlat9, 0.0), 1.0);
					#else
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz + vec3(0.5, 0.5, 0.5);
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Mask;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTexutre;
					uniform mediump sampler2D _ColorRamp;
					uniform mediump sampler2D _Gradient;
					in highp vec2 vs_TEXCOORD0;
					in highp float vs_TEXCOORD1;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec4 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					mediump float u_xlat16_3;
					vec2 u_xlat6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_0.x = texture(_Mask, u_xlat0.xy).x;
					    u_xlat16_3 = texture(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat16_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat16_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat16_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat16_0 = texture(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_1.x = texture(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat16_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat16_0.w * u_xlat1.x;
					    u_xlat1.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_1.xyz = texture(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat16_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat16_1.xyz = texture(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat16_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9) + vec3(-0.5, -0.5, -0.5);
					    u_xlat9 = vs_TEXCOORD1;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat9 = min(max(u_xlat9, 0.0), 1.0);
					#else
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz + vec3(0.5, 0.5, 0.5);
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Mask;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTexutre;
					uniform mediump sampler2D _ColorRamp;
					uniform mediump sampler2D _Gradient;
					in highp vec2 vs_TEXCOORD0;
					in highp float vs_TEXCOORD1;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec4 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					mediump float u_xlat16_3;
					vec2 u_xlat6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_0.x = texture(_Mask, u_xlat0.xy).x;
					    u_xlat16_3 = texture(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat16_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat16_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat16_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat16_0 = texture(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_1.x = texture(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat16_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat16_0.w * u_xlat1.x;
					    u_xlat1.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_1.xyz = texture(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat16_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat16_1.xyz = texture(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat16_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9) + vec3(-0.5, -0.5, -0.5);
					    u_xlat9 = vs_TEXCOORD1;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat9 = min(max(u_xlat9, 0.0), 1.0);
					#else
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz + vec3(0.5, 0.5, 0.5);
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Mask;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTexutre;
					uniform lowp sampler2D _ColorRamp;
					uniform lowp sampler2D _Gradient;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec4 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec3 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					lowp float u_xlat10_3;
					vec2 u_xlat6;
					float u_xlat9;
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
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_0.x = texture2D(_Mask, u_xlat0.xy).x;
					    u_xlat10_3 = texture2D(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat10_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat10_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat10_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat10_0 = texture2D(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_1.x = texture2D(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat10_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat10_0.w * u_xlat1.x;
					    u_xlat1.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_1.xyz = texture2D(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat10_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat10_1.xyz = texture2D(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat10_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9) + vec3(-0.5, -0.5, -0.5);
					    u_xlat9 = vs_TEXCOORD1;
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz + vec3(0.5, 0.5, 0.5);
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Mask;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTexutre;
					uniform lowp sampler2D _ColorRamp;
					uniform lowp sampler2D _Gradient;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec4 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec3 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					lowp float u_xlat10_3;
					vec2 u_xlat6;
					float u_xlat9;
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
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_0.x = texture2D(_Mask, u_xlat0.xy).x;
					    u_xlat10_3 = texture2D(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat10_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat10_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat10_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat10_0 = texture2D(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_1.x = texture2D(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat10_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat10_0.w * u_xlat1.x;
					    u_xlat1.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_1.xyz = texture2D(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat10_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat10_1.xyz = texture2D(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat10_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9) + vec3(-0.5, -0.5, -0.5);
					    u_xlat9 = vs_TEXCOORD1;
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz + vec3(0.5, 0.5, 0.5);
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Mask;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTexutre;
					uniform lowp sampler2D _ColorRamp;
					uniform lowp sampler2D _Gradient;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec4 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec3 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					lowp float u_xlat10_3;
					vec2 u_xlat6;
					float u_xlat9;
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
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_0.x = texture2D(_Mask, u_xlat0.xy).x;
					    u_xlat10_3 = texture2D(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat10_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat10_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat10_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat10_0 = texture2D(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_1.x = texture2D(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat10_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat10_0.w * u_xlat1.x;
					    u_xlat1.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_1.xyz = texture2D(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat10_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat10_1.xyz = texture2D(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat10_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9) + vec3(-0.5, -0.5, -0.5);
					    u_xlat9 = vs_TEXCOORD1;
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz + vec3(0.5, 0.5, 0.5);
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Mask;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTexutre;
					uniform mediump sampler2D _ColorRamp;
					uniform mediump sampler2D _Gradient;
					in highp vec2 vs_TEXCOORD0;
					in highp float vs_TEXCOORD1;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec4 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					mediump float u_xlat16_3;
					vec2 u_xlat6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_0.x = texture(_Mask, u_xlat0.xy).x;
					    u_xlat16_3 = texture(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat16_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat16_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat16_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat16_0 = texture(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_1.x = texture(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat16_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat16_0.w * u_xlat1.x;
					    u_xlat1.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_1.xyz = texture(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat16_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat16_1.xyz = texture(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat16_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9) + vec3(-0.5, -0.5, -0.5);
					    u_xlat9 = vs_TEXCOORD1;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat9 = min(max(u_xlat9, 0.0), 1.0);
					#else
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz + vec3(0.5, 0.5, 0.5);
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Mask;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTexutre;
					uniform mediump sampler2D _ColorRamp;
					uniform mediump sampler2D _Gradient;
					in highp vec2 vs_TEXCOORD0;
					in highp float vs_TEXCOORD1;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec4 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					mediump float u_xlat16_3;
					vec2 u_xlat6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_0.x = texture(_Mask, u_xlat0.xy).x;
					    u_xlat16_3 = texture(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat16_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat16_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat16_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat16_0 = texture(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_1.x = texture(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat16_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat16_0.w * u_xlat1.x;
					    u_xlat1.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_1.xyz = texture(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat16_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat16_1.xyz = texture(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat16_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9) + vec3(-0.5, -0.5, -0.5);
					    u_xlat9 = vs_TEXCOORD1;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat9 = min(max(u_xlat9, 0.0), 1.0);
					#else
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz + vec3(0.5, 0.5, 0.5);
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Mask;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTexutre;
					uniform mediump sampler2D _ColorRamp;
					uniform mediump sampler2D _Gradient;
					in highp vec2 vs_TEXCOORD0;
					in highp float vs_TEXCOORD1;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec4 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					mediump float u_xlat16_3;
					vec2 u_xlat6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_0.x = texture(_Mask, u_xlat0.xy).x;
					    u_xlat16_3 = texture(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat16_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat16_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat16_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat16_0 = texture(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_1.x = texture(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat16_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat16_0.w * u_xlat1.x;
					    u_xlat1.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_1.xyz = texture(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat16_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat16_1.xyz = texture(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat16_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9) + vec3(-0.5, -0.5, -0.5);
					    u_xlat9 = vs_TEXCOORD1;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat9 = min(max(u_xlat9, 0.0), 1.0);
					#else
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz + vec3(0.5, 0.5, 0.5);
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Mask;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTexutre;
					uniform lowp sampler2D _ColorRamp;
					uniform lowp sampler2D _Gradient;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec4 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec3 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					lowp float u_xlat10_3;
					vec2 u_xlat6;
					float u_xlat9;
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
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_0.x = texture2D(_Mask, u_xlat0.xy).x;
					    u_xlat10_3 = texture2D(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat10_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat10_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat10_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat10_0 = texture2D(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_1.x = texture2D(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat10_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat10_0.w * u_xlat1.x;
					    u_xlat1.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_1.xyz = texture2D(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat10_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat10_1.xyz = texture2D(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat10_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9) + vec3(-0.5, -0.5, -0.5);
					    u_xlat9 = vs_TEXCOORD1;
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz + vec3(0.5, 0.5, 0.5);
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Mask;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTexutre;
					uniform lowp sampler2D _ColorRamp;
					uniform lowp sampler2D _Gradient;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec4 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec3 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					lowp float u_xlat10_3;
					vec2 u_xlat6;
					float u_xlat9;
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
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_0.x = texture2D(_Mask, u_xlat0.xy).x;
					    u_xlat10_3 = texture2D(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat10_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat10_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat10_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat10_0 = texture2D(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_1.x = texture2D(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat10_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat10_0.w * u_xlat1.x;
					    u_xlat1.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_1.xyz = texture2D(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat10_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat10_1.xyz = texture2D(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat10_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9) + vec3(-0.5, -0.5, -0.5);
					    u_xlat9 = vs_TEXCOORD1;
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz + vec3(0.5, 0.5, 0.5);
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Mask;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTexutre;
					uniform lowp sampler2D _ColorRamp;
					uniform lowp sampler2D _Gradient;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec4 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec3 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					lowp float u_xlat10_3;
					vec2 u_xlat6;
					float u_xlat9;
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
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_0.x = texture2D(_Mask, u_xlat0.xy).x;
					    u_xlat10_3 = texture2D(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat10_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat10_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat10_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat10_0 = texture2D(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_1.x = texture2D(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat10_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat10_0.w * u_xlat1.x;
					    u_xlat1.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_1.xyz = texture2D(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat10_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat10_1.xyz = texture2D(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat10_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9) + vec3(-0.5, -0.5, -0.5);
					    u_xlat9 = vs_TEXCOORD1;
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz + vec3(0.5, 0.5, 0.5);
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Mask;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTexutre;
					uniform mediump sampler2D _ColorRamp;
					uniform mediump sampler2D _Gradient;
					in highp vec2 vs_TEXCOORD0;
					in highp float vs_TEXCOORD1;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec4 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					mediump float u_xlat16_3;
					vec2 u_xlat6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_0.x = texture(_Mask, u_xlat0.xy).x;
					    u_xlat16_3 = texture(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat16_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat16_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat16_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat16_0 = texture(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_1.x = texture(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat16_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat16_0.w * u_xlat1.x;
					    u_xlat1.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_1.xyz = texture(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat16_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat16_1.xyz = texture(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat16_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9) + vec3(-0.5, -0.5, -0.5);
					    u_xlat9 = vs_TEXCOORD1;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat9 = min(max(u_xlat9, 0.0), 1.0);
					#else
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz + vec3(0.5, 0.5, 0.5);
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Mask;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTexutre;
					uniform mediump sampler2D _ColorRamp;
					uniform mediump sampler2D _Gradient;
					in highp vec2 vs_TEXCOORD0;
					in highp float vs_TEXCOORD1;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec4 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					mediump float u_xlat16_3;
					vec2 u_xlat6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_0.x = texture(_Mask, u_xlat0.xy).x;
					    u_xlat16_3 = texture(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat16_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat16_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat16_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat16_0 = texture(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_1.x = texture(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat16_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat16_0.w * u_xlat1.x;
					    u_xlat1.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_1.xyz = texture(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat16_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat16_1.xyz = texture(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat16_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9) + vec3(-0.5, -0.5, -0.5);
					    u_xlat9 = vs_TEXCOORD1;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat9 = min(max(u_xlat9, 0.0), 1.0);
					#else
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz + vec3(0.5, 0.5, 0.5);
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Mask;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTexutre;
					uniform mediump sampler2D _ColorRamp;
					uniform mediump sampler2D _Gradient;
					in highp vec2 vs_TEXCOORD0;
					in highp float vs_TEXCOORD1;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec4 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					mediump float u_xlat16_3;
					vec2 u_xlat6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_0.x = texture(_Mask, u_xlat0.xy).x;
					    u_xlat16_3 = texture(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat16_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat16_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat16_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat16_0 = texture(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_1.x = texture(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat16_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat16_0.w * u_xlat1.x;
					    u_xlat1.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_1.xyz = texture(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat16_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat16_1.xyz = texture(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat16_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9) + vec3(-0.5, -0.5, -0.5);
					    u_xlat9 = vs_TEXCOORD1;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat9 = min(max(u_xlat9, 0.0), 1.0);
					#else
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz + vec3(0.5, 0.5, 0.5);
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Mask;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTexutre;
					uniform lowp sampler2D _ColorRamp;
					uniform lowp sampler2D _Gradient;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec4 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec3 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					lowp float u_xlat10_3;
					vec2 u_xlat6;
					float u_xlat9;
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
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_0.x = texture2D(_Mask, u_xlat0.xy).x;
					    u_xlat10_3 = texture2D(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat10_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat10_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat10_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat10_0 = texture2D(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_1.x = texture2D(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat10_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat10_0.w * u_xlat1.x;
					    u_xlat1.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_1.xyz = texture2D(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat10_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat10_1.xyz = texture2D(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat10_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9) + vec3(-0.5, -0.5, -0.5);
					    u_xlat9 = vs_TEXCOORD1;
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz + vec3(0.5, 0.5, 0.5);
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Mask;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTexutre;
					uniform lowp sampler2D _ColorRamp;
					uniform lowp sampler2D _Gradient;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec4 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec3 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					lowp float u_xlat10_3;
					vec2 u_xlat6;
					float u_xlat9;
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
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_0.x = texture2D(_Mask, u_xlat0.xy).x;
					    u_xlat10_3 = texture2D(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat10_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat10_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat10_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat10_0 = texture2D(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_1.x = texture2D(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat10_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat10_0.w * u_xlat1.x;
					    u_xlat1.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_1.xyz = texture2D(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat10_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat10_1.xyz = texture2D(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat10_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9) + vec3(-0.5, -0.5, -0.5);
					    u_xlat9 = vs_TEXCOORD1;
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz + vec3(0.5, 0.5, 0.5);
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Mask;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTexutre;
					uniform lowp sampler2D _ColorRamp;
					uniform lowp sampler2D _Gradient;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec4 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec3 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					lowp float u_xlat10_3;
					vec2 u_xlat6;
					float u_xlat9;
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
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_0.x = texture2D(_Mask, u_xlat0.xy).x;
					    u_xlat10_3 = texture2D(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat10_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat10_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat10_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat10_0 = texture2D(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_1.x = texture2D(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat10_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat10_0.w * u_xlat1.x;
					    u_xlat1.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_1.xyz = texture2D(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat10_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat10_1.xyz = texture2D(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat10_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9) + vec3(-0.5, -0.5, -0.5);
					    u_xlat9 = vs_TEXCOORD1;
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz + vec3(0.5, 0.5, 0.5);
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Mask;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTexutre;
					uniform mediump sampler2D _ColorRamp;
					uniform mediump sampler2D _Gradient;
					in highp vec2 vs_TEXCOORD0;
					in highp float vs_TEXCOORD1;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec4 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					mediump float u_xlat16_3;
					vec2 u_xlat6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_0.x = texture(_Mask, u_xlat0.xy).x;
					    u_xlat16_3 = texture(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat16_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat16_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat16_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat16_0 = texture(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_1.x = texture(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat16_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat16_0.w * u_xlat1.x;
					    u_xlat1.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_1.xyz = texture(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat16_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat16_1.xyz = texture(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat16_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9) + vec3(-0.5, -0.5, -0.5);
					    u_xlat9 = vs_TEXCOORD1;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat9 = min(max(u_xlat9, 0.0), 1.0);
					#else
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz + vec3(0.5, 0.5, 0.5);
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Mask;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTexutre;
					uniform mediump sampler2D _ColorRamp;
					uniform mediump sampler2D _Gradient;
					in highp vec2 vs_TEXCOORD0;
					in highp float vs_TEXCOORD1;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec4 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					mediump float u_xlat16_3;
					vec2 u_xlat6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_0.x = texture(_Mask, u_xlat0.xy).x;
					    u_xlat16_3 = texture(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat16_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat16_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat16_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat16_0 = texture(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_1.x = texture(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat16_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat16_0.w * u_xlat1.x;
					    u_xlat1.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_1.xyz = texture(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat16_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat16_1.xyz = texture(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat16_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9) + vec3(-0.5, -0.5, -0.5);
					    u_xlat9 = vs_TEXCOORD1;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat9 = min(max(u_xlat9, 0.0), 1.0);
					#else
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz + vec3(0.5, 0.5, 0.5);
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Mask;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTexutre;
					uniform mediump sampler2D _ColorRamp;
					uniform mediump sampler2D _Gradient;
					in highp vec2 vs_TEXCOORD0;
					in highp float vs_TEXCOORD1;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec4 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					mediump float u_xlat16_3;
					vec2 u_xlat6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_0.x = texture(_Mask, u_xlat0.xy).x;
					    u_xlat16_3 = texture(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat16_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat16_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat16_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat16_0 = texture(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_1.x = texture(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat16_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat16_0.w * u_xlat1.x;
					    u_xlat1.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_1.xyz = texture(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat16_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat16_1.xyz = texture(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat16_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9) + vec3(-0.5, -0.5, -0.5);
					    u_xlat9 = vs_TEXCOORD1;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat9 = min(max(u_xlat9, 0.0), 1.0);
					#else
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz + vec3(0.5, 0.5, 0.5);
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Mask;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTexutre;
					uniform lowp sampler2D _ColorRamp;
					uniform lowp sampler2D _Gradient;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec4 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec3 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					lowp float u_xlat10_3;
					vec2 u_xlat6;
					float u_xlat9;
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
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_0.x = texture2D(_Mask, u_xlat0.xy).x;
					    u_xlat10_3 = texture2D(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat10_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat10_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat10_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat10_0 = texture2D(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_1.x = texture2D(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat10_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat10_0.w * u_xlat1.x;
					    u_xlat1.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_1.xyz = texture2D(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat10_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat10_1.xyz = texture2D(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat10_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9) + vec3(-0.5, -0.5, -0.5);
					    u_xlat9 = vs_TEXCOORD1;
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz + vec3(0.5, 0.5, 0.5);
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Mask;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTexutre;
					uniform lowp sampler2D _ColorRamp;
					uniform lowp sampler2D _Gradient;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec4 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec3 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					lowp float u_xlat10_3;
					vec2 u_xlat6;
					float u_xlat9;
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
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_0.x = texture2D(_Mask, u_xlat0.xy).x;
					    u_xlat10_3 = texture2D(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat10_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat10_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat10_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat10_0 = texture2D(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_1.x = texture2D(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat10_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat10_0.w * u_xlat1.x;
					    u_xlat1.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_1.xyz = texture2D(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat10_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat10_1.xyz = texture2D(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat10_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9) + vec3(-0.5, -0.5, -0.5);
					    u_xlat9 = vs_TEXCOORD1;
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz + vec3(0.5, 0.5, 0.5);
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Mask;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTexutre;
					uniform lowp sampler2D _ColorRamp;
					uniform lowp sampler2D _Gradient;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec4 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec3 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					lowp float u_xlat10_3;
					vec2 u_xlat6;
					float u_xlat9;
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
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_0.x = texture2D(_Mask, u_xlat0.xy).x;
					    u_xlat10_3 = texture2D(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat10_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat10_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat10_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat10_0 = texture2D(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_1.x = texture2D(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat10_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat10_0.w * u_xlat1.x;
					    u_xlat1.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_1.xyz = texture2D(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat10_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat10_1.xyz = texture2D(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat10_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9) + vec3(-0.5, -0.5, -0.5);
					    u_xlat9 = vs_TEXCOORD1;
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz + vec3(0.5, 0.5, 0.5);
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Mask;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTexutre;
					uniform mediump sampler2D _ColorRamp;
					uniform mediump sampler2D _Gradient;
					in highp vec2 vs_TEXCOORD0;
					in highp float vs_TEXCOORD1;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec4 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					mediump float u_xlat16_3;
					vec2 u_xlat6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_0.x = texture(_Mask, u_xlat0.xy).x;
					    u_xlat16_3 = texture(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat16_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat16_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat16_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat16_0 = texture(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_1.x = texture(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat16_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat16_0.w * u_xlat1.x;
					    u_xlat1.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_1.xyz = texture(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat16_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat16_1.xyz = texture(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat16_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9) + vec3(-0.5, -0.5, -0.5);
					    u_xlat9 = vs_TEXCOORD1;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat9 = min(max(u_xlat9, 0.0), 1.0);
					#else
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz + vec3(0.5, 0.5, 0.5);
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Mask;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTexutre;
					uniform mediump sampler2D _ColorRamp;
					uniform mediump sampler2D _Gradient;
					in highp vec2 vs_TEXCOORD0;
					in highp float vs_TEXCOORD1;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec4 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					mediump float u_xlat16_3;
					vec2 u_xlat6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_0.x = texture(_Mask, u_xlat0.xy).x;
					    u_xlat16_3 = texture(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat16_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat16_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat16_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat16_0 = texture(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_1.x = texture(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat16_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat16_0.w * u_xlat1.x;
					    u_xlat1.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_1.xyz = texture(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat16_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat16_1.xyz = texture(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat16_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9) + vec3(-0.5, -0.5, -0.5);
					    u_xlat9 = vs_TEXCOORD1;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat9 = min(max(u_xlat9, 0.0), 1.0);
					#else
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz + vec3(0.5, 0.5, 0.5);
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Mask;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTexutre;
					uniform mediump sampler2D _ColorRamp;
					uniform mediump sampler2D _Gradient;
					in highp vec2 vs_TEXCOORD0;
					in highp float vs_TEXCOORD1;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec4 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					mediump float u_xlat16_3;
					vec2 u_xlat6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_0.x = texture(_Mask, u_xlat0.xy).x;
					    u_xlat16_3 = texture(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat16_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat16_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat16_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat16_0 = texture(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_1.x = texture(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat16_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat16_0.w * u_xlat1.x;
					    u_xlat1.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_1.xyz = texture(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat16_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat16_1.xyz = texture(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat16_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9) + vec3(-0.5, -0.5, -0.5);
					    u_xlat9 = vs_TEXCOORD1;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat9 = min(max(u_xlat9, 0.0), 1.0);
					#else
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz + vec3(0.5, 0.5, 0.5);
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Mask;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTexutre;
					uniform lowp sampler2D _ColorRamp;
					uniform lowp sampler2D _Gradient;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec4 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec3 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					lowp float u_xlat10_3;
					vec2 u_xlat6;
					float u_xlat9;
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
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_0.x = texture2D(_Mask, u_xlat0.xy).x;
					    u_xlat10_3 = texture2D(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat10_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat10_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat10_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat10_0 = texture2D(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_1.x = texture2D(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat10_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat10_0.w * u_xlat1.x;
					    u_xlat1.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_1.xyz = texture2D(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat10_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat10_1.xyz = texture2D(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat10_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9) + vec3(-0.5, -0.5, -0.5);
					    u_xlat9 = vs_TEXCOORD1;
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz + vec3(0.5, 0.5, 0.5);
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Mask;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTexutre;
					uniform lowp sampler2D _ColorRamp;
					uniform lowp sampler2D _Gradient;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec4 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec3 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					lowp float u_xlat10_3;
					vec2 u_xlat6;
					float u_xlat9;
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
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_0.x = texture2D(_Mask, u_xlat0.xy).x;
					    u_xlat10_3 = texture2D(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat10_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat10_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat10_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat10_0 = texture2D(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_1.x = texture2D(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat10_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat10_0.w * u_xlat1.x;
					    u_xlat1.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_1.xyz = texture2D(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat10_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat10_1.xyz = texture2D(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat10_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9) + vec3(-0.5, -0.5, -0.5);
					    u_xlat9 = vs_TEXCOORD1;
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz + vec3(0.5, 0.5, 0.5);
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Mask;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTexutre;
					uniform lowp sampler2D _ColorRamp;
					uniform lowp sampler2D _Gradient;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec4 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec3 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					lowp float u_xlat10_3;
					vec2 u_xlat6;
					float u_xlat9;
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
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_0.x = texture2D(_Mask, u_xlat0.xy).x;
					    u_xlat10_3 = texture2D(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat10_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat10_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat10_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat10_0 = texture2D(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_1.x = texture2D(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat10_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat10_0.w * u_xlat1.x;
					    u_xlat1.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_1.xyz = texture2D(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat10_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat10_1.xyz = texture2D(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat10_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9) + vec3(-0.5, -0.5, -0.5);
					    u_xlat9 = vs_TEXCOORD1;
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz + vec3(0.5, 0.5, 0.5);
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Mask;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTexutre;
					uniform mediump sampler2D _ColorRamp;
					uniform mediump sampler2D _Gradient;
					in highp vec2 vs_TEXCOORD0;
					in highp float vs_TEXCOORD1;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec4 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					mediump float u_xlat16_3;
					vec2 u_xlat6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_0.x = texture(_Mask, u_xlat0.xy).x;
					    u_xlat16_3 = texture(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat16_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat16_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat16_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat16_0 = texture(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_1.x = texture(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat16_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat16_0.w * u_xlat1.x;
					    u_xlat1.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_1.xyz = texture(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat16_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat16_1.xyz = texture(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat16_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9) + vec3(-0.5, -0.5, -0.5);
					    u_xlat9 = vs_TEXCOORD1;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat9 = min(max(u_xlat9, 0.0), 1.0);
					#else
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz + vec3(0.5, 0.5, 0.5);
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Mask;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTexutre;
					uniform mediump sampler2D _ColorRamp;
					uniform mediump sampler2D _Gradient;
					in highp vec2 vs_TEXCOORD0;
					in highp float vs_TEXCOORD1;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec4 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					mediump float u_xlat16_3;
					vec2 u_xlat6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_0.x = texture(_Mask, u_xlat0.xy).x;
					    u_xlat16_3 = texture(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat16_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat16_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat16_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat16_0 = texture(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_1.x = texture(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat16_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat16_0.w * u_xlat1.x;
					    u_xlat1.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_1.xyz = texture(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat16_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat16_1.xyz = texture(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat16_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9) + vec3(-0.5, -0.5, -0.5);
					    u_xlat9 = vs_TEXCOORD1;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat9 = min(max(u_xlat9, 0.0), 1.0);
					#else
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz + vec3(0.5, 0.5, 0.5);
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Mask;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTexutre;
					uniform mediump sampler2D _ColorRamp;
					uniform mediump sampler2D _Gradient;
					in highp vec2 vs_TEXCOORD0;
					in highp float vs_TEXCOORD1;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec4 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					mediump float u_xlat16_3;
					vec2 u_xlat6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_0.x = texture(_Mask, u_xlat0.xy).x;
					    u_xlat16_3 = texture(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat16_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat16_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat16_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat16_0 = texture(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_1.x = texture(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat16_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat16_0.w * u_xlat1.x;
					    u_xlat1.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_1.xyz = texture(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat16_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat16_1.xyz = texture(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat16_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9) + vec3(-0.5, -0.5, -0.5);
					    u_xlat9 = vs_TEXCOORD1;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat9 = min(max(u_xlat9, 0.0), 1.0);
					#else
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz + vec3(0.5, 0.5, 0.5);
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Mask;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTexutre;
					uniform lowp sampler2D _ColorRamp;
					uniform lowp sampler2D _Gradient;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec4 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec3 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					lowp float u_xlat10_3;
					vec2 u_xlat6;
					float u_xlat9;
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
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_0.x = texture2D(_Mask, u_xlat0.xy).x;
					    u_xlat10_3 = texture2D(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat10_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat10_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat10_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat10_0 = texture2D(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_1.x = texture2D(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat10_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat10_0.w * u_xlat1.x;
					    u_xlat1.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_1.xyz = texture2D(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat10_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat10_1.xyz = texture2D(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat10_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9) + vec3(-0.5, -0.5, -0.5);
					    u_xlat9 = vs_TEXCOORD1;
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz + vec3(0.5, 0.5, 0.5);
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Mask;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTexutre;
					uniform lowp sampler2D _ColorRamp;
					uniform lowp sampler2D _Gradient;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec4 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec3 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					lowp float u_xlat10_3;
					vec2 u_xlat6;
					float u_xlat9;
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
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_0.x = texture2D(_Mask, u_xlat0.xy).x;
					    u_xlat10_3 = texture2D(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat10_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat10_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat10_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat10_0 = texture2D(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_1.x = texture2D(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat10_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat10_0.w * u_xlat1.x;
					    u_xlat1.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_1.xyz = texture2D(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat10_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat10_1.xyz = texture2D(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat10_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9) + vec3(-0.5, -0.5, -0.5);
					    u_xlat9 = vs_TEXCOORD1;
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz + vec3(0.5, 0.5, 0.5);
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform lowp sampler2D _Mask;
					uniform lowp sampler2D _Distortion;
					uniform lowp sampler2D _MainTexutre;
					uniform lowp sampler2D _ColorRamp;
					uniform lowp sampler2D _Gradient;
					varying highp vec2 vs_TEXCOORD0;
					varying highp float vs_TEXCOORD1;
					varying highp vec4 vs_COLOR0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec4 u_xlat10_0;
					vec3 u_xlat1;
					lowp vec3 u_xlat10_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					lowp float u_xlat10_3;
					vec2 u_xlat6;
					float u_xlat9;
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
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_0.x = texture2D(_Mask, u_xlat0.xy).x;
					    u_xlat10_3 = texture2D(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat10_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat10_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat10_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat10_0 = texture2D(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat10_1.x = texture2D(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat10_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat10_0.w * u_xlat1.x;
					    u_xlat1.x = float(op_and(int((gl_FrontFacing ? 1 : 0)), 1065353216));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat10_1.xyz = texture2D(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat10_0.xyz * u_xlat10_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat10_1.xyz = texture2D(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat10_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9) + vec3(-0.5, -0.5, -0.5);
					    u_xlat9 = vs_TEXCOORD1;
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz + vec3(0.5, 0.5, 0.5);
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Mask;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTexutre;
					uniform mediump sampler2D _ColorRamp;
					uniform mediump sampler2D _Gradient;
					in highp vec2 vs_TEXCOORD0;
					in highp float vs_TEXCOORD1;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec4 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					mediump float u_xlat16_3;
					vec2 u_xlat6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_0.x = texture(_Mask, u_xlat0.xy).x;
					    u_xlat16_3 = texture(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat16_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat16_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat16_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat16_0 = texture(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_1.x = texture(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat16_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat16_0.w * u_xlat1.x;
					    u_xlat1.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_1.xyz = texture(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat16_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat16_1.xyz = texture(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat16_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9) + vec3(-0.5, -0.5, -0.5);
					    u_xlat9 = vs_TEXCOORD1;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat9 = min(max(u_xlat9, 0.0), 1.0);
					#else
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz + vec3(0.5, 0.5, 0.5);
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Mask;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTexutre;
					uniform mediump sampler2D _ColorRamp;
					uniform mediump sampler2D _Gradient;
					in highp vec2 vs_TEXCOORD0;
					in highp float vs_TEXCOORD1;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec4 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					mediump float u_xlat16_3;
					vec2 u_xlat6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_0.x = texture(_Mask, u_xlat0.xy).x;
					    u_xlat16_3 = texture(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat16_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat16_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat16_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat16_0 = texture(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_1.x = texture(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat16_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat16_0.w * u_xlat1.x;
					    u_xlat1.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_1.xyz = texture(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat16_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat16_1.xyz = texture(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat16_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9) + vec3(-0.5, -0.5, -0.5);
					    u_xlat9 = vs_TEXCOORD1;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat9 = min(max(u_xlat9, 0.0), 1.0);
					#else
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz + vec3(0.5, 0.5, 0.5);
					    SV_Target0.w = 1.0;
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
					uniform 	vec4 _MainTexutre_ST;
					uniform 	vec4 _TintColor;
					uniform 	float _GradientUSpeed;
					uniform 	float _GradientVSpeed;
					uniform 	vec4 _Gradient_ST;
					uniform 	float _NoiseAmount;
					uniform 	vec4 _Distortion_ST;
					uniform 	mediump float _DistortMainTexture;
					uniform 	float _DistortionUSpeed;
					uniform 	float _DistortionVSpeed;
					uniform 	float _GradientPower;
					uniform 	float _ColorMultiplier;
					uniform 	vec4 _Mask_ST;
					uniform 	vec4 _ColorRamp_ST;
					uniform 	float _MainTextureVSpeed;
					uniform 	float _MainTextureUSpeed;
					uniform 	float _DoubleSided;
					uniform mediump sampler2D _Mask;
					uniform mediump sampler2D _Distortion;
					uniform mediump sampler2D _MainTexutre;
					uniform mediump sampler2D _ColorRamp;
					uniform mediump sampler2D _Gradient;
					in highp vec2 vs_TEXCOORD0;
					in highp float vs_TEXCOORD1;
					in highp vec4 vs_COLOR0;
					layout(location = 0) out highp vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec4 u_xlat16_0;
					vec3 u_xlat1;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec2 u_xlat3;
					mediump float u_xlat16_3;
					vec2 u_xlat6;
					float u_xlat9;
					void main()
					{
					    u_xlat0.xy = _Time.yy * vec2(_DistortionUSpeed, _DistortionVSpeed) + vs_TEXCOORD0.xy;
					    u_xlat6.xy = u_xlat0.xy * _Distortion_ST.xy + _Distortion_ST.zw;
					    u_xlat0.xy = u_xlat0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_0.x = texture(_Mask, u_xlat0.xy).x;
					    u_xlat16_3 = texture(_Distortion, u_xlat6.xy).x;
					    u_xlat3.xy = vec2(u_xlat16_3) + (-vs_TEXCOORD0.xy);
					    u_xlat3.xy = u_xlat3.xy * vec2(_NoiseAmount);
					    u_xlat1.xy = u_xlat16_0.xx * u_xlat3.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = u_xlat3.xy * u_xlat16_0.xx;
					    u_xlat0.xy = vec2(_DistortMainTexture) * u_xlat0.xy + vs_TEXCOORD0.xy;
					    u_xlat0.xy = _Time.yy * vec2(_MainTextureUSpeed, _MainTextureVSpeed) + u_xlat0.xy;
					    u_xlat0.xy = u_xlat0.xy * _MainTexutre_ST.xy + _MainTexutre_ST.zw;
					    u_xlat16_0 = texture(_MainTexutre, u_xlat0.xy);
					    u_xlat1.xy = _Time.yy * vec2(_GradientUSpeed, _GradientVSpeed) + u_xlat1.xy;
					    u_xlat1.xy = u_xlat1.xy * _Gradient_ST.xy + _Gradient_ST.zw;
					    u_xlat16_1.x = texture(_Gradient, u_xlat1.xy).x;
					    u_xlat1.x = log2(u_xlat16_1.x);
					    u_xlat1.x = u_xlat1.x * _GradientPower;
					    u_xlat1.x = exp2(u_xlat1.x);
					    u_xlat9 = u_xlat16_0.w * u_xlat1.x;
					    u_xlat1.x = uintBitsToFloat(uint((gl_FrontFacing ? 0xffffffffu : uint(0)) & 1065353216u));
					    u_xlat1.x = max(u_xlat1.x, _DoubleSided);
					    u_xlat1.x = min(u_xlat1.x, 1.0);
					    u_xlat9 = u_xlat9 * u_xlat1.x;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _Mask_ST.xy + _Mask_ST.zw;
					    u_xlat16_1.xyz = texture(_Mask, u_xlat1.xy).xyz;
					    u_xlat0.xyz = u_xlat16_0.xyz * u_xlat16_1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vs_COLOR0.xyz;
					    u_xlat1.xy = vs_TEXCOORD0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
					    u_xlat16_1.xyz = texture(_ColorRamp, u_xlat1.xy).xyz;
					    u_xlat2.xyz = _TintColor.xyz * vec3(vec3(_ColorMultiplier, _ColorMultiplier, _ColorMultiplier));
					    u_xlat1.xyz = u_xlat16_1.xyz * u_xlat2.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
					    u_xlat0.xyz = u_xlat0.xyz + u_xlat0.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9) + vec3(-0.5, -0.5, -0.5);
					    u_xlat9 = vs_TEXCOORD1;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat9 = min(max(u_xlat9, 0.0), 1.0);
					#else
					    u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = vec3(u_xlat9) * u_xlat0.xyz + vec3(0.5, 0.5, 0.5);
					    SV_Target0.w = 1.0;
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