Shader "Hidden/ALIyerEdon/ColorGrading" {
	Properties {
		_Color ("Color", Vector) = (1,0,0,1)
		_Contrast ("Contrast", Float) = 1
		_Exposure ("Exposure", Float) = 1
		_Gamma ("Gamma", Float) = 1
		_VignetteIntensity ("_VignetteIntensity", Float) = 0.3
		_Saturation ("Saturatiob", Float) = 1
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	SubShader {
		Pass {
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 12465
			Program "vp" {
				SubProgram "gles hw_tier00 " {
					Keywords { "ACES_ON" "SaturN_ON" "Vignette_ON" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					varying highp vec2 vs_TEXCOORD0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
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
					uniform 	mediump vec4 _Color;
					uniform 	float _Contrast;
					uniform 	float _Exposure;
					uniform 	float _Gamma;
					uniform 	float _VignetteIntensity;
					uniform 	float _Saturation;
					uniform lowp sampler2D _MainTex;
					varying highp vec2 vs_TEXCOORD0;
					#define SV_Target0 gl_FragData[0]
					vec4 u_xlat0;
					lowp vec3 u_xlat10_0;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					void main()
					{
					    u_xlat10_0.xyz = texture2D(_MainTex, vs_TEXCOORD0.xy).xyz;
					    u_xlat12 = dot(u_xlat10_0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat16_1.xyz = u_xlat10_0.xyz + vec3(-0.5, -0.5, -0.5);
					    u_xlat16_1.xyz = vec3(_Contrast) * u_xlat16_1.xyz + vec3(0.5, 0.5, 0.5);
					    u_xlat16_1.xyz = clamp(u_xlat16_1.xyz, 0.0, 1.0);
					    u_xlat0.xyz = vec3(u_xlat12) + (-u_xlat16_1.xyz);
					    u_xlat0.xyz = vec3(_Saturation) * u_xlat0.xyz + u_xlat16_1.xyz;
					    u_xlat0.xyz = log2(u_xlat0.xyz);
					    u_xlat12 = float(1.0) / _Gamma;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat12);
					    u_xlat0.xyz = exp2(u_xlat0.xyz);
					    u_xlat0.xyz = u_xlat0.xyz + _Color.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(vec3(_Exposure, _Exposure, _Exposure));
					    u_xlat2.xyz = u_xlat0.xyz * vec3(12.5500002, 12.5500002, 12.5500002) + vec3(0.0299999993, 0.0299999993, 0.0299999993);
					    u_xlat3.xyz = u_xlat0.xyz * vec3(5.0, 5.0, 5.0);
					    u_xlat0.xyz = u_xlat0.xyz * vec3(12.1500006, 12.1500006, 12.1500006) + vec3(0.589999974, 0.589999974, 0.589999974);
					    u_xlat0.xyz = u_xlat3.xyz * u_xlat0.xyz + vec3(0.140000001, 0.140000001, 0.140000001);
					    u_xlat2.xyz = u_xlat2.xyz * u_xlat3.xyz;
					    u_xlat0.xyz = u_xlat2.xyz / u_xlat0.xyz;
					    u_xlat0.xyz = clamp(u_xlat0.xyz, 0.0, 1.0);
					    u_xlat16_1.xy = vs_TEXCOORD0.xy + vec2(-0.5, -0.5);
					    u_xlat16_1.xy = u_xlat16_1.xy + u_xlat16_1.xy;
					    u_xlat16_1.x = dot(u_xlat16_1.xy, u_xlat16_1.xy);
					    u_xlat2.x = (-u_xlat16_1.x) * _VignetteIntensity + 1.0;
					    u_xlat0.w = 1.0;
					    u_xlat0 = u_xlat0 * u_xlat2.xxxx;
					    SV_Target0 = u_xlat0;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier01 " {
					Keywords { "ACES_ON" "SaturN_ON" "Vignette_ON" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					varying highp vec2 vs_TEXCOORD0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
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
					uniform 	mediump vec4 _Color;
					uniform 	float _Contrast;
					uniform 	float _Exposure;
					uniform 	float _Gamma;
					uniform 	float _VignetteIntensity;
					uniform 	float _Saturation;
					uniform lowp sampler2D _MainTex;
					varying highp vec2 vs_TEXCOORD0;
					#define SV_Target0 gl_FragData[0]
					vec4 u_xlat0;
					lowp vec3 u_xlat10_0;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					void main()
					{
					    u_xlat10_0.xyz = texture2D(_MainTex, vs_TEXCOORD0.xy).xyz;
					    u_xlat12 = dot(u_xlat10_0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat16_1.xyz = u_xlat10_0.xyz + vec3(-0.5, -0.5, -0.5);
					    u_xlat16_1.xyz = vec3(_Contrast) * u_xlat16_1.xyz + vec3(0.5, 0.5, 0.5);
					    u_xlat16_1.xyz = clamp(u_xlat16_1.xyz, 0.0, 1.0);
					    u_xlat0.xyz = vec3(u_xlat12) + (-u_xlat16_1.xyz);
					    u_xlat0.xyz = vec3(_Saturation) * u_xlat0.xyz + u_xlat16_1.xyz;
					    u_xlat0.xyz = log2(u_xlat0.xyz);
					    u_xlat12 = float(1.0) / _Gamma;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat12);
					    u_xlat0.xyz = exp2(u_xlat0.xyz);
					    u_xlat0.xyz = u_xlat0.xyz + _Color.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(vec3(_Exposure, _Exposure, _Exposure));
					    u_xlat2.xyz = u_xlat0.xyz * vec3(12.5500002, 12.5500002, 12.5500002) + vec3(0.0299999993, 0.0299999993, 0.0299999993);
					    u_xlat3.xyz = u_xlat0.xyz * vec3(5.0, 5.0, 5.0);
					    u_xlat0.xyz = u_xlat0.xyz * vec3(12.1500006, 12.1500006, 12.1500006) + vec3(0.589999974, 0.589999974, 0.589999974);
					    u_xlat0.xyz = u_xlat3.xyz * u_xlat0.xyz + vec3(0.140000001, 0.140000001, 0.140000001);
					    u_xlat2.xyz = u_xlat2.xyz * u_xlat3.xyz;
					    u_xlat0.xyz = u_xlat2.xyz / u_xlat0.xyz;
					    u_xlat0.xyz = clamp(u_xlat0.xyz, 0.0, 1.0);
					    u_xlat16_1.xy = vs_TEXCOORD0.xy + vec2(-0.5, -0.5);
					    u_xlat16_1.xy = u_xlat16_1.xy + u_xlat16_1.xy;
					    u_xlat16_1.x = dot(u_xlat16_1.xy, u_xlat16_1.xy);
					    u_xlat2.x = (-u_xlat16_1.x) * _VignetteIntensity + 1.0;
					    u_xlat0.w = 1.0;
					    u_xlat0 = u_xlat0 * u_xlat2.xxxx;
					    SV_Target0 = u_xlat0;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier02 " {
					Keywords { "ACES_ON" "SaturN_ON" "Vignette_ON" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					varying highp vec2 vs_TEXCOORD0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
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
					uniform 	mediump vec4 _Color;
					uniform 	float _Contrast;
					uniform 	float _Exposure;
					uniform 	float _Gamma;
					uniform 	float _VignetteIntensity;
					uniform 	float _Saturation;
					uniform lowp sampler2D _MainTex;
					varying highp vec2 vs_TEXCOORD0;
					#define SV_Target0 gl_FragData[0]
					vec4 u_xlat0;
					lowp vec3 u_xlat10_0;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					void main()
					{
					    u_xlat10_0.xyz = texture2D(_MainTex, vs_TEXCOORD0.xy).xyz;
					    u_xlat12 = dot(u_xlat10_0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat16_1.xyz = u_xlat10_0.xyz + vec3(-0.5, -0.5, -0.5);
					    u_xlat16_1.xyz = vec3(_Contrast) * u_xlat16_1.xyz + vec3(0.5, 0.5, 0.5);
					    u_xlat16_1.xyz = clamp(u_xlat16_1.xyz, 0.0, 1.0);
					    u_xlat0.xyz = vec3(u_xlat12) + (-u_xlat16_1.xyz);
					    u_xlat0.xyz = vec3(_Saturation) * u_xlat0.xyz + u_xlat16_1.xyz;
					    u_xlat0.xyz = log2(u_xlat0.xyz);
					    u_xlat12 = float(1.0) / _Gamma;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat12);
					    u_xlat0.xyz = exp2(u_xlat0.xyz);
					    u_xlat0.xyz = u_xlat0.xyz + _Color.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(vec3(_Exposure, _Exposure, _Exposure));
					    u_xlat2.xyz = u_xlat0.xyz * vec3(12.5500002, 12.5500002, 12.5500002) + vec3(0.0299999993, 0.0299999993, 0.0299999993);
					    u_xlat3.xyz = u_xlat0.xyz * vec3(5.0, 5.0, 5.0);
					    u_xlat0.xyz = u_xlat0.xyz * vec3(12.1500006, 12.1500006, 12.1500006) + vec3(0.589999974, 0.589999974, 0.589999974);
					    u_xlat0.xyz = u_xlat3.xyz * u_xlat0.xyz + vec3(0.140000001, 0.140000001, 0.140000001);
					    u_xlat2.xyz = u_xlat2.xyz * u_xlat3.xyz;
					    u_xlat0.xyz = u_xlat2.xyz / u_xlat0.xyz;
					    u_xlat0.xyz = clamp(u_xlat0.xyz, 0.0, 1.0);
					    u_xlat16_1.xy = vs_TEXCOORD0.xy + vec2(-0.5, -0.5);
					    u_xlat16_1.xy = u_xlat16_1.xy + u_xlat16_1.xy;
					    u_xlat16_1.x = dot(u_xlat16_1.xy, u_xlat16_1.xy);
					    u_xlat2.x = (-u_xlat16_1.x) * _VignetteIntensity + 1.0;
					    u_xlat0.w = 1.0;
					    u_xlat0 = u_xlat0 * u_xlat2.xxxx;
					    SV_Target0 = u_xlat0;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier00 " {
					Keywords { "ACES_ON" "SaturN_ON" "Vignette_ON" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					out highp vec2 vs_TEXCOORD0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	mediump vec4 _Color;
					uniform 	float _Contrast;
					uniform 	float _Exposure;
					uniform 	float _Gamma;
					uniform 	float _VignetteIntensity;
					uniform 	float _Saturation;
					uniform mediump sampler2D _MainTex;
					in highp vec2 vs_TEXCOORD0;
					layout(location = 0) out mediump vec4 SV_Target0;
					vec4 u_xlat0;
					mediump vec3 u_xlat16_0;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					void main()
					{
					    u_xlat16_0.xyz = texture(_MainTex, vs_TEXCOORD0.xy).xyz;
					    u_xlat12 = dot(u_xlat16_0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat16_1.xyz = u_xlat16_0.xyz + vec3(-0.5, -0.5, -0.5);
					    u_xlat16_1.xyz = vec3(_Contrast) * u_xlat16_1.xyz + vec3(0.5, 0.5, 0.5);
					#ifdef UNITY_ADRENO_ES3
					    u_xlat16_1.xyz = min(max(u_xlat16_1.xyz, 0.0), 1.0);
					#else
					    u_xlat16_1.xyz = clamp(u_xlat16_1.xyz, 0.0, 1.0);
					#endif
					    u_xlat0.xyz = vec3(u_xlat12) + (-u_xlat16_1.xyz);
					    u_xlat0.xyz = vec3(_Saturation) * u_xlat0.xyz + u_xlat16_1.xyz;
					    u_xlat0.xyz = log2(u_xlat0.xyz);
					    u_xlat12 = float(1.0) / _Gamma;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat12);
					    u_xlat0.xyz = exp2(u_xlat0.xyz);
					    u_xlat0.xyz = u_xlat0.xyz + _Color.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(vec3(_Exposure, _Exposure, _Exposure));
					    u_xlat2.xyz = u_xlat0.xyz * vec3(12.5500002, 12.5500002, 12.5500002) + vec3(0.0299999993, 0.0299999993, 0.0299999993);
					    u_xlat3.xyz = u_xlat0.xyz * vec3(5.0, 5.0, 5.0);
					    u_xlat0.xyz = u_xlat0.xyz * vec3(12.1500006, 12.1500006, 12.1500006) + vec3(0.589999974, 0.589999974, 0.589999974);
					    u_xlat0.xyz = u_xlat3.xyz * u_xlat0.xyz + vec3(0.140000001, 0.140000001, 0.140000001);
					    u_xlat2.xyz = u_xlat2.xyz * u_xlat3.xyz;
					    u_xlat0.xyz = u_xlat2.xyz / u_xlat0.xyz;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat0.xyz = min(max(u_xlat0.xyz, 0.0), 1.0);
					#else
					    u_xlat0.xyz = clamp(u_xlat0.xyz, 0.0, 1.0);
					#endif
					    u_xlat16_1.xy = vs_TEXCOORD0.xy + vec2(-0.5, -0.5);
					    u_xlat16_1.xy = u_xlat16_1.xy + u_xlat16_1.xy;
					    u_xlat16_1.x = dot(u_xlat16_1.xy, u_xlat16_1.xy);
					    u_xlat2.x = (-u_xlat16_1.x) * _VignetteIntensity + 1.0;
					    u_xlat0.w = 1.0;
					    u_xlat0 = u_xlat0 * u_xlat2.xxxx;
					    SV_Target0 = u_xlat0;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier01 " {
					Keywords { "ACES_ON" "SaturN_ON" "Vignette_ON" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					out highp vec2 vs_TEXCOORD0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	mediump vec4 _Color;
					uniform 	float _Contrast;
					uniform 	float _Exposure;
					uniform 	float _Gamma;
					uniform 	float _VignetteIntensity;
					uniform 	float _Saturation;
					uniform mediump sampler2D _MainTex;
					in highp vec2 vs_TEXCOORD0;
					layout(location = 0) out mediump vec4 SV_Target0;
					vec4 u_xlat0;
					mediump vec3 u_xlat16_0;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					void main()
					{
					    u_xlat16_0.xyz = texture(_MainTex, vs_TEXCOORD0.xy).xyz;
					    u_xlat12 = dot(u_xlat16_0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat16_1.xyz = u_xlat16_0.xyz + vec3(-0.5, -0.5, -0.5);
					    u_xlat16_1.xyz = vec3(_Contrast) * u_xlat16_1.xyz + vec3(0.5, 0.5, 0.5);
					#ifdef UNITY_ADRENO_ES3
					    u_xlat16_1.xyz = min(max(u_xlat16_1.xyz, 0.0), 1.0);
					#else
					    u_xlat16_1.xyz = clamp(u_xlat16_1.xyz, 0.0, 1.0);
					#endif
					    u_xlat0.xyz = vec3(u_xlat12) + (-u_xlat16_1.xyz);
					    u_xlat0.xyz = vec3(_Saturation) * u_xlat0.xyz + u_xlat16_1.xyz;
					    u_xlat0.xyz = log2(u_xlat0.xyz);
					    u_xlat12 = float(1.0) / _Gamma;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat12);
					    u_xlat0.xyz = exp2(u_xlat0.xyz);
					    u_xlat0.xyz = u_xlat0.xyz + _Color.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(vec3(_Exposure, _Exposure, _Exposure));
					    u_xlat2.xyz = u_xlat0.xyz * vec3(12.5500002, 12.5500002, 12.5500002) + vec3(0.0299999993, 0.0299999993, 0.0299999993);
					    u_xlat3.xyz = u_xlat0.xyz * vec3(5.0, 5.0, 5.0);
					    u_xlat0.xyz = u_xlat0.xyz * vec3(12.1500006, 12.1500006, 12.1500006) + vec3(0.589999974, 0.589999974, 0.589999974);
					    u_xlat0.xyz = u_xlat3.xyz * u_xlat0.xyz + vec3(0.140000001, 0.140000001, 0.140000001);
					    u_xlat2.xyz = u_xlat2.xyz * u_xlat3.xyz;
					    u_xlat0.xyz = u_xlat2.xyz / u_xlat0.xyz;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat0.xyz = min(max(u_xlat0.xyz, 0.0), 1.0);
					#else
					    u_xlat0.xyz = clamp(u_xlat0.xyz, 0.0, 1.0);
					#endif
					    u_xlat16_1.xy = vs_TEXCOORD0.xy + vec2(-0.5, -0.5);
					    u_xlat16_1.xy = u_xlat16_1.xy + u_xlat16_1.xy;
					    u_xlat16_1.x = dot(u_xlat16_1.xy, u_xlat16_1.xy);
					    u_xlat2.x = (-u_xlat16_1.x) * _VignetteIntensity + 1.0;
					    u_xlat0.w = 1.0;
					    u_xlat0 = u_xlat0 * u_xlat2.xxxx;
					    SV_Target0 = u_xlat0;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier02 " {
					Keywords { "ACES_ON" "SaturN_ON" "Vignette_ON" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					out highp vec2 vs_TEXCOORD0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	mediump vec4 _Color;
					uniform 	float _Contrast;
					uniform 	float _Exposure;
					uniform 	float _Gamma;
					uniform 	float _VignetteIntensity;
					uniform 	float _Saturation;
					uniform mediump sampler2D _MainTex;
					in highp vec2 vs_TEXCOORD0;
					layout(location = 0) out mediump vec4 SV_Target0;
					vec4 u_xlat0;
					mediump vec3 u_xlat16_0;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					void main()
					{
					    u_xlat16_0.xyz = texture(_MainTex, vs_TEXCOORD0.xy).xyz;
					    u_xlat12 = dot(u_xlat16_0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat16_1.xyz = u_xlat16_0.xyz + vec3(-0.5, -0.5, -0.5);
					    u_xlat16_1.xyz = vec3(_Contrast) * u_xlat16_1.xyz + vec3(0.5, 0.5, 0.5);
					#ifdef UNITY_ADRENO_ES3
					    u_xlat16_1.xyz = min(max(u_xlat16_1.xyz, 0.0), 1.0);
					#else
					    u_xlat16_1.xyz = clamp(u_xlat16_1.xyz, 0.0, 1.0);
					#endif
					    u_xlat0.xyz = vec3(u_xlat12) + (-u_xlat16_1.xyz);
					    u_xlat0.xyz = vec3(_Saturation) * u_xlat0.xyz + u_xlat16_1.xyz;
					    u_xlat0.xyz = log2(u_xlat0.xyz);
					    u_xlat12 = float(1.0) / _Gamma;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat12);
					    u_xlat0.xyz = exp2(u_xlat0.xyz);
					    u_xlat0.xyz = u_xlat0.xyz + _Color.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(vec3(_Exposure, _Exposure, _Exposure));
					    u_xlat2.xyz = u_xlat0.xyz * vec3(12.5500002, 12.5500002, 12.5500002) + vec3(0.0299999993, 0.0299999993, 0.0299999993);
					    u_xlat3.xyz = u_xlat0.xyz * vec3(5.0, 5.0, 5.0);
					    u_xlat0.xyz = u_xlat0.xyz * vec3(12.1500006, 12.1500006, 12.1500006) + vec3(0.589999974, 0.589999974, 0.589999974);
					    u_xlat0.xyz = u_xlat3.xyz * u_xlat0.xyz + vec3(0.140000001, 0.140000001, 0.140000001);
					    u_xlat2.xyz = u_xlat2.xyz * u_xlat3.xyz;
					    u_xlat0.xyz = u_xlat2.xyz / u_xlat0.xyz;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat0.xyz = min(max(u_xlat0.xyz, 0.0), 1.0);
					#else
					    u_xlat0.xyz = clamp(u_xlat0.xyz, 0.0, 1.0);
					#endif
					    u_xlat16_1.xy = vs_TEXCOORD0.xy + vec2(-0.5, -0.5);
					    u_xlat16_1.xy = u_xlat16_1.xy + u_xlat16_1.xy;
					    u_xlat16_1.x = dot(u_xlat16_1.xy, u_xlat16_1.xy);
					    u_xlat2.x = (-u_xlat16_1.x) * _VignetteIntensity + 1.0;
					    u_xlat0.w = 1.0;
					    u_xlat0 = u_xlat0 * u_xlat2.xxxx;
					    SV_Target0 = u_xlat0;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier00 " {
					Keywords { "ACES_ON" "SaturN_ON" "Vignette_OFF" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					varying highp vec2 vs_TEXCOORD0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
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
					uniform 	mediump vec4 _Color;
					uniform 	float _Contrast;
					uniform 	float _Exposure;
					uniform 	float _Gamma;
					uniform 	float _Saturation;
					uniform lowp sampler2D _MainTex;
					varying highp vec2 vs_TEXCOORD0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					void main()
					{
					    u_xlat10_0.xyz = texture2D(_MainTex, vs_TEXCOORD0.xy).xyz;
					    u_xlat12 = dot(u_xlat10_0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat16_1.xyz = u_xlat10_0.xyz + vec3(-0.5, -0.5, -0.5);
					    u_xlat16_1.xyz = vec3(_Contrast) * u_xlat16_1.xyz + vec3(0.5, 0.5, 0.5);
					    u_xlat16_1.xyz = clamp(u_xlat16_1.xyz, 0.0, 1.0);
					    u_xlat0.xyz = vec3(u_xlat12) + (-u_xlat16_1.xyz);
					    u_xlat0.xyz = vec3(_Saturation) * u_xlat0.xyz + u_xlat16_1.xyz;
					    u_xlat0.xyz = log2(u_xlat0.xyz);
					    u_xlat12 = float(1.0) / _Gamma;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat12);
					    u_xlat0.xyz = exp2(u_xlat0.xyz);
					    u_xlat0.xyz = u_xlat0.xyz + _Color.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(vec3(_Exposure, _Exposure, _Exposure));
					    u_xlat2.xyz = u_xlat0.xyz * vec3(12.5500002, 12.5500002, 12.5500002) + vec3(0.0299999993, 0.0299999993, 0.0299999993);
					    u_xlat3.xyz = u_xlat0.xyz * vec3(5.0, 5.0, 5.0);
					    u_xlat0.xyz = u_xlat0.xyz * vec3(12.1500006, 12.1500006, 12.1500006) + vec3(0.589999974, 0.589999974, 0.589999974);
					    u_xlat0.xyz = u_xlat3.xyz * u_xlat0.xyz + vec3(0.140000001, 0.140000001, 0.140000001);
					    u_xlat2.xyz = u_xlat2.xyz * u_xlat3.xyz;
					    u_xlat0.xyz = u_xlat2.xyz / u_xlat0.xyz;
					    u_xlat0.xyz = clamp(u_xlat0.xyz, 0.0, 1.0);
					    SV_Target0.xyz = u_xlat0.xyz;
					    SV_Target0.w = 1.0;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier01 " {
					Keywords { "ACES_ON" "SaturN_ON" "Vignette_OFF" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					varying highp vec2 vs_TEXCOORD0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
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
					uniform 	mediump vec4 _Color;
					uniform 	float _Contrast;
					uniform 	float _Exposure;
					uniform 	float _Gamma;
					uniform 	float _Saturation;
					uniform lowp sampler2D _MainTex;
					varying highp vec2 vs_TEXCOORD0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					void main()
					{
					    u_xlat10_0.xyz = texture2D(_MainTex, vs_TEXCOORD0.xy).xyz;
					    u_xlat12 = dot(u_xlat10_0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat16_1.xyz = u_xlat10_0.xyz + vec3(-0.5, -0.5, -0.5);
					    u_xlat16_1.xyz = vec3(_Contrast) * u_xlat16_1.xyz + vec3(0.5, 0.5, 0.5);
					    u_xlat16_1.xyz = clamp(u_xlat16_1.xyz, 0.0, 1.0);
					    u_xlat0.xyz = vec3(u_xlat12) + (-u_xlat16_1.xyz);
					    u_xlat0.xyz = vec3(_Saturation) * u_xlat0.xyz + u_xlat16_1.xyz;
					    u_xlat0.xyz = log2(u_xlat0.xyz);
					    u_xlat12 = float(1.0) / _Gamma;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat12);
					    u_xlat0.xyz = exp2(u_xlat0.xyz);
					    u_xlat0.xyz = u_xlat0.xyz + _Color.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(vec3(_Exposure, _Exposure, _Exposure));
					    u_xlat2.xyz = u_xlat0.xyz * vec3(12.5500002, 12.5500002, 12.5500002) + vec3(0.0299999993, 0.0299999993, 0.0299999993);
					    u_xlat3.xyz = u_xlat0.xyz * vec3(5.0, 5.0, 5.0);
					    u_xlat0.xyz = u_xlat0.xyz * vec3(12.1500006, 12.1500006, 12.1500006) + vec3(0.589999974, 0.589999974, 0.589999974);
					    u_xlat0.xyz = u_xlat3.xyz * u_xlat0.xyz + vec3(0.140000001, 0.140000001, 0.140000001);
					    u_xlat2.xyz = u_xlat2.xyz * u_xlat3.xyz;
					    u_xlat0.xyz = u_xlat2.xyz / u_xlat0.xyz;
					    u_xlat0.xyz = clamp(u_xlat0.xyz, 0.0, 1.0);
					    SV_Target0.xyz = u_xlat0.xyz;
					    SV_Target0.w = 1.0;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier02 " {
					Keywords { "ACES_ON" "SaturN_ON" "Vignette_OFF" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					varying highp vec2 vs_TEXCOORD0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
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
					uniform 	mediump vec4 _Color;
					uniform 	float _Contrast;
					uniform 	float _Exposure;
					uniform 	float _Gamma;
					uniform 	float _Saturation;
					uniform lowp sampler2D _MainTex;
					varying highp vec2 vs_TEXCOORD0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					void main()
					{
					    u_xlat10_0.xyz = texture2D(_MainTex, vs_TEXCOORD0.xy).xyz;
					    u_xlat12 = dot(u_xlat10_0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat16_1.xyz = u_xlat10_0.xyz + vec3(-0.5, -0.5, -0.5);
					    u_xlat16_1.xyz = vec3(_Contrast) * u_xlat16_1.xyz + vec3(0.5, 0.5, 0.5);
					    u_xlat16_1.xyz = clamp(u_xlat16_1.xyz, 0.0, 1.0);
					    u_xlat0.xyz = vec3(u_xlat12) + (-u_xlat16_1.xyz);
					    u_xlat0.xyz = vec3(_Saturation) * u_xlat0.xyz + u_xlat16_1.xyz;
					    u_xlat0.xyz = log2(u_xlat0.xyz);
					    u_xlat12 = float(1.0) / _Gamma;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat12);
					    u_xlat0.xyz = exp2(u_xlat0.xyz);
					    u_xlat0.xyz = u_xlat0.xyz + _Color.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(vec3(_Exposure, _Exposure, _Exposure));
					    u_xlat2.xyz = u_xlat0.xyz * vec3(12.5500002, 12.5500002, 12.5500002) + vec3(0.0299999993, 0.0299999993, 0.0299999993);
					    u_xlat3.xyz = u_xlat0.xyz * vec3(5.0, 5.0, 5.0);
					    u_xlat0.xyz = u_xlat0.xyz * vec3(12.1500006, 12.1500006, 12.1500006) + vec3(0.589999974, 0.589999974, 0.589999974);
					    u_xlat0.xyz = u_xlat3.xyz * u_xlat0.xyz + vec3(0.140000001, 0.140000001, 0.140000001);
					    u_xlat2.xyz = u_xlat2.xyz * u_xlat3.xyz;
					    u_xlat0.xyz = u_xlat2.xyz / u_xlat0.xyz;
					    u_xlat0.xyz = clamp(u_xlat0.xyz, 0.0, 1.0);
					    SV_Target0.xyz = u_xlat0.xyz;
					    SV_Target0.w = 1.0;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier00 " {
					Keywords { "ACES_ON" "SaturN_ON" "Vignette_OFF" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					out highp vec2 vs_TEXCOORD0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	mediump vec4 _Color;
					uniform 	float _Contrast;
					uniform 	float _Exposure;
					uniform 	float _Gamma;
					uniform 	float _Saturation;
					uniform mediump sampler2D _MainTex;
					in highp vec2 vs_TEXCOORD0;
					layout(location = 0) out mediump vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					void main()
					{
					    u_xlat16_0.xyz = texture(_MainTex, vs_TEXCOORD0.xy).xyz;
					    u_xlat12 = dot(u_xlat16_0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat16_1.xyz = u_xlat16_0.xyz + vec3(-0.5, -0.5, -0.5);
					    u_xlat16_1.xyz = vec3(_Contrast) * u_xlat16_1.xyz + vec3(0.5, 0.5, 0.5);
					#ifdef UNITY_ADRENO_ES3
					    u_xlat16_1.xyz = min(max(u_xlat16_1.xyz, 0.0), 1.0);
					#else
					    u_xlat16_1.xyz = clamp(u_xlat16_1.xyz, 0.0, 1.0);
					#endif
					    u_xlat0.xyz = vec3(u_xlat12) + (-u_xlat16_1.xyz);
					    u_xlat0.xyz = vec3(_Saturation) * u_xlat0.xyz + u_xlat16_1.xyz;
					    u_xlat0.xyz = log2(u_xlat0.xyz);
					    u_xlat12 = float(1.0) / _Gamma;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat12);
					    u_xlat0.xyz = exp2(u_xlat0.xyz);
					    u_xlat0.xyz = u_xlat0.xyz + _Color.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(vec3(_Exposure, _Exposure, _Exposure));
					    u_xlat2.xyz = u_xlat0.xyz * vec3(12.5500002, 12.5500002, 12.5500002) + vec3(0.0299999993, 0.0299999993, 0.0299999993);
					    u_xlat3.xyz = u_xlat0.xyz * vec3(5.0, 5.0, 5.0);
					    u_xlat0.xyz = u_xlat0.xyz * vec3(12.1500006, 12.1500006, 12.1500006) + vec3(0.589999974, 0.589999974, 0.589999974);
					    u_xlat0.xyz = u_xlat3.xyz * u_xlat0.xyz + vec3(0.140000001, 0.140000001, 0.140000001);
					    u_xlat2.xyz = u_xlat2.xyz * u_xlat3.xyz;
					    u_xlat0.xyz = u_xlat2.xyz / u_xlat0.xyz;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat0.xyz = min(max(u_xlat0.xyz, 0.0), 1.0);
					#else
					    u_xlat0.xyz = clamp(u_xlat0.xyz, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = u_xlat0.xyz;
					    SV_Target0.w = 1.0;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier01 " {
					Keywords { "ACES_ON" "SaturN_ON" "Vignette_OFF" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					out highp vec2 vs_TEXCOORD0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	mediump vec4 _Color;
					uniform 	float _Contrast;
					uniform 	float _Exposure;
					uniform 	float _Gamma;
					uniform 	float _Saturation;
					uniform mediump sampler2D _MainTex;
					in highp vec2 vs_TEXCOORD0;
					layout(location = 0) out mediump vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					void main()
					{
					    u_xlat16_0.xyz = texture(_MainTex, vs_TEXCOORD0.xy).xyz;
					    u_xlat12 = dot(u_xlat16_0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat16_1.xyz = u_xlat16_0.xyz + vec3(-0.5, -0.5, -0.5);
					    u_xlat16_1.xyz = vec3(_Contrast) * u_xlat16_1.xyz + vec3(0.5, 0.5, 0.5);
					#ifdef UNITY_ADRENO_ES3
					    u_xlat16_1.xyz = min(max(u_xlat16_1.xyz, 0.0), 1.0);
					#else
					    u_xlat16_1.xyz = clamp(u_xlat16_1.xyz, 0.0, 1.0);
					#endif
					    u_xlat0.xyz = vec3(u_xlat12) + (-u_xlat16_1.xyz);
					    u_xlat0.xyz = vec3(_Saturation) * u_xlat0.xyz + u_xlat16_1.xyz;
					    u_xlat0.xyz = log2(u_xlat0.xyz);
					    u_xlat12 = float(1.0) / _Gamma;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat12);
					    u_xlat0.xyz = exp2(u_xlat0.xyz);
					    u_xlat0.xyz = u_xlat0.xyz + _Color.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(vec3(_Exposure, _Exposure, _Exposure));
					    u_xlat2.xyz = u_xlat0.xyz * vec3(12.5500002, 12.5500002, 12.5500002) + vec3(0.0299999993, 0.0299999993, 0.0299999993);
					    u_xlat3.xyz = u_xlat0.xyz * vec3(5.0, 5.0, 5.0);
					    u_xlat0.xyz = u_xlat0.xyz * vec3(12.1500006, 12.1500006, 12.1500006) + vec3(0.589999974, 0.589999974, 0.589999974);
					    u_xlat0.xyz = u_xlat3.xyz * u_xlat0.xyz + vec3(0.140000001, 0.140000001, 0.140000001);
					    u_xlat2.xyz = u_xlat2.xyz * u_xlat3.xyz;
					    u_xlat0.xyz = u_xlat2.xyz / u_xlat0.xyz;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat0.xyz = min(max(u_xlat0.xyz, 0.0), 1.0);
					#else
					    u_xlat0.xyz = clamp(u_xlat0.xyz, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = u_xlat0.xyz;
					    SV_Target0.w = 1.0;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier02 " {
					Keywords { "ACES_ON" "SaturN_ON" "Vignette_OFF" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					out highp vec2 vs_TEXCOORD0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	mediump vec4 _Color;
					uniform 	float _Contrast;
					uniform 	float _Exposure;
					uniform 	float _Gamma;
					uniform 	float _Saturation;
					uniform mediump sampler2D _MainTex;
					in highp vec2 vs_TEXCOORD0;
					layout(location = 0) out mediump vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					void main()
					{
					    u_xlat16_0.xyz = texture(_MainTex, vs_TEXCOORD0.xy).xyz;
					    u_xlat12 = dot(u_xlat16_0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat16_1.xyz = u_xlat16_0.xyz + vec3(-0.5, -0.5, -0.5);
					    u_xlat16_1.xyz = vec3(_Contrast) * u_xlat16_1.xyz + vec3(0.5, 0.5, 0.5);
					#ifdef UNITY_ADRENO_ES3
					    u_xlat16_1.xyz = min(max(u_xlat16_1.xyz, 0.0), 1.0);
					#else
					    u_xlat16_1.xyz = clamp(u_xlat16_1.xyz, 0.0, 1.0);
					#endif
					    u_xlat0.xyz = vec3(u_xlat12) + (-u_xlat16_1.xyz);
					    u_xlat0.xyz = vec3(_Saturation) * u_xlat0.xyz + u_xlat16_1.xyz;
					    u_xlat0.xyz = log2(u_xlat0.xyz);
					    u_xlat12 = float(1.0) / _Gamma;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat12);
					    u_xlat0.xyz = exp2(u_xlat0.xyz);
					    u_xlat0.xyz = u_xlat0.xyz + _Color.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(vec3(_Exposure, _Exposure, _Exposure));
					    u_xlat2.xyz = u_xlat0.xyz * vec3(12.5500002, 12.5500002, 12.5500002) + vec3(0.0299999993, 0.0299999993, 0.0299999993);
					    u_xlat3.xyz = u_xlat0.xyz * vec3(5.0, 5.0, 5.0);
					    u_xlat0.xyz = u_xlat0.xyz * vec3(12.1500006, 12.1500006, 12.1500006) + vec3(0.589999974, 0.589999974, 0.589999974);
					    u_xlat0.xyz = u_xlat3.xyz * u_xlat0.xyz + vec3(0.140000001, 0.140000001, 0.140000001);
					    u_xlat2.xyz = u_xlat2.xyz * u_xlat3.xyz;
					    u_xlat0.xyz = u_xlat2.xyz / u_xlat0.xyz;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat0.xyz = min(max(u_xlat0.xyz, 0.0), 1.0);
					#else
					    u_xlat0.xyz = clamp(u_xlat0.xyz, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = u_xlat0.xyz;
					    SV_Target0.w = 1.0;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier00 " {
					Keywords { "ACES_ON" "SaturN_OFF" "Vignette_ON" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					varying highp vec2 vs_TEXCOORD0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
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
					uniform 	mediump vec4 _Color;
					uniform 	float _Contrast;
					uniform 	float _Exposure;
					uniform 	float _Gamma;
					uniform 	float _VignetteIntensity;
					uniform lowp sampler2D _MainTex;
					varying highp vec2 vs_TEXCOORD0;
					#define SV_Target0 gl_FragData[0]
					vec4 u_xlat0;
					lowp vec3 u_xlat10_0;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					void main()
					{
					    u_xlat10_0.xyz = texture2D(_MainTex, vs_TEXCOORD0.xy).xyz;
					    u_xlat16_1.xyz = u_xlat10_0.xyz + vec3(-0.5, -0.5, -0.5);
					    u_xlat16_1.xyz = vec3(_Contrast) * u_xlat16_1.xyz + vec3(0.5, 0.5, 0.5);
					    u_xlat16_1.xyz = clamp(u_xlat16_1.xyz, 0.0, 1.0);
					    u_xlat0.xyz = log2(u_xlat16_1.xyz);
					    u_xlat12 = float(1.0) / _Gamma;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat12);
					    u_xlat0.xyz = exp2(u_xlat0.xyz);
					    u_xlat0.xyz = u_xlat0.xyz + _Color.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(vec3(_Exposure, _Exposure, _Exposure));
					    u_xlat2.xyz = u_xlat0.xyz * vec3(12.5500002, 12.5500002, 12.5500002) + vec3(0.0299999993, 0.0299999993, 0.0299999993);
					    u_xlat3.xyz = u_xlat0.xyz * vec3(5.0, 5.0, 5.0);
					    u_xlat0.xyz = u_xlat0.xyz * vec3(12.1500006, 12.1500006, 12.1500006) + vec3(0.589999974, 0.589999974, 0.589999974);
					    u_xlat0.xyz = u_xlat3.xyz * u_xlat0.xyz + vec3(0.140000001, 0.140000001, 0.140000001);
					    u_xlat2.xyz = u_xlat2.xyz * u_xlat3.xyz;
					    u_xlat0.xyz = u_xlat2.xyz / u_xlat0.xyz;
					    u_xlat0.xyz = clamp(u_xlat0.xyz, 0.0, 1.0);
					    u_xlat16_1.xy = vs_TEXCOORD0.xy + vec2(-0.5, -0.5);
					    u_xlat16_1.xy = u_xlat16_1.xy + u_xlat16_1.xy;
					    u_xlat16_1.x = dot(u_xlat16_1.xy, u_xlat16_1.xy);
					    u_xlat2.x = (-u_xlat16_1.x) * _VignetteIntensity + 1.0;
					    u_xlat0.w = 1.0;
					    u_xlat0 = u_xlat0 * u_xlat2.xxxx;
					    SV_Target0 = u_xlat0;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier01 " {
					Keywords { "ACES_ON" "SaturN_OFF" "Vignette_ON" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					varying highp vec2 vs_TEXCOORD0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
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
					uniform 	mediump vec4 _Color;
					uniform 	float _Contrast;
					uniform 	float _Exposure;
					uniform 	float _Gamma;
					uniform 	float _VignetteIntensity;
					uniform lowp sampler2D _MainTex;
					varying highp vec2 vs_TEXCOORD0;
					#define SV_Target0 gl_FragData[0]
					vec4 u_xlat0;
					lowp vec3 u_xlat10_0;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					void main()
					{
					    u_xlat10_0.xyz = texture2D(_MainTex, vs_TEXCOORD0.xy).xyz;
					    u_xlat16_1.xyz = u_xlat10_0.xyz + vec3(-0.5, -0.5, -0.5);
					    u_xlat16_1.xyz = vec3(_Contrast) * u_xlat16_1.xyz + vec3(0.5, 0.5, 0.5);
					    u_xlat16_1.xyz = clamp(u_xlat16_1.xyz, 0.0, 1.0);
					    u_xlat0.xyz = log2(u_xlat16_1.xyz);
					    u_xlat12 = float(1.0) / _Gamma;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat12);
					    u_xlat0.xyz = exp2(u_xlat0.xyz);
					    u_xlat0.xyz = u_xlat0.xyz + _Color.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(vec3(_Exposure, _Exposure, _Exposure));
					    u_xlat2.xyz = u_xlat0.xyz * vec3(12.5500002, 12.5500002, 12.5500002) + vec3(0.0299999993, 0.0299999993, 0.0299999993);
					    u_xlat3.xyz = u_xlat0.xyz * vec3(5.0, 5.0, 5.0);
					    u_xlat0.xyz = u_xlat0.xyz * vec3(12.1500006, 12.1500006, 12.1500006) + vec3(0.589999974, 0.589999974, 0.589999974);
					    u_xlat0.xyz = u_xlat3.xyz * u_xlat0.xyz + vec3(0.140000001, 0.140000001, 0.140000001);
					    u_xlat2.xyz = u_xlat2.xyz * u_xlat3.xyz;
					    u_xlat0.xyz = u_xlat2.xyz / u_xlat0.xyz;
					    u_xlat0.xyz = clamp(u_xlat0.xyz, 0.0, 1.0);
					    u_xlat16_1.xy = vs_TEXCOORD0.xy + vec2(-0.5, -0.5);
					    u_xlat16_1.xy = u_xlat16_1.xy + u_xlat16_1.xy;
					    u_xlat16_1.x = dot(u_xlat16_1.xy, u_xlat16_1.xy);
					    u_xlat2.x = (-u_xlat16_1.x) * _VignetteIntensity + 1.0;
					    u_xlat0.w = 1.0;
					    u_xlat0 = u_xlat0 * u_xlat2.xxxx;
					    SV_Target0 = u_xlat0;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier02 " {
					Keywords { "ACES_ON" "SaturN_OFF" "Vignette_ON" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					varying highp vec2 vs_TEXCOORD0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
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
					uniform 	mediump vec4 _Color;
					uniform 	float _Contrast;
					uniform 	float _Exposure;
					uniform 	float _Gamma;
					uniform 	float _VignetteIntensity;
					uniform lowp sampler2D _MainTex;
					varying highp vec2 vs_TEXCOORD0;
					#define SV_Target0 gl_FragData[0]
					vec4 u_xlat0;
					lowp vec3 u_xlat10_0;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					void main()
					{
					    u_xlat10_0.xyz = texture2D(_MainTex, vs_TEXCOORD0.xy).xyz;
					    u_xlat16_1.xyz = u_xlat10_0.xyz + vec3(-0.5, -0.5, -0.5);
					    u_xlat16_1.xyz = vec3(_Contrast) * u_xlat16_1.xyz + vec3(0.5, 0.5, 0.5);
					    u_xlat16_1.xyz = clamp(u_xlat16_1.xyz, 0.0, 1.0);
					    u_xlat0.xyz = log2(u_xlat16_1.xyz);
					    u_xlat12 = float(1.0) / _Gamma;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat12);
					    u_xlat0.xyz = exp2(u_xlat0.xyz);
					    u_xlat0.xyz = u_xlat0.xyz + _Color.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(vec3(_Exposure, _Exposure, _Exposure));
					    u_xlat2.xyz = u_xlat0.xyz * vec3(12.5500002, 12.5500002, 12.5500002) + vec3(0.0299999993, 0.0299999993, 0.0299999993);
					    u_xlat3.xyz = u_xlat0.xyz * vec3(5.0, 5.0, 5.0);
					    u_xlat0.xyz = u_xlat0.xyz * vec3(12.1500006, 12.1500006, 12.1500006) + vec3(0.589999974, 0.589999974, 0.589999974);
					    u_xlat0.xyz = u_xlat3.xyz * u_xlat0.xyz + vec3(0.140000001, 0.140000001, 0.140000001);
					    u_xlat2.xyz = u_xlat2.xyz * u_xlat3.xyz;
					    u_xlat0.xyz = u_xlat2.xyz / u_xlat0.xyz;
					    u_xlat0.xyz = clamp(u_xlat0.xyz, 0.0, 1.0);
					    u_xlat16_1.xy = vs_TEXCOORD0.xy + vec2(-0.5, -0.5);
					    u_xlat16_1.xy = u_xlat16_1.xy + u_xlat16_1.xy;
					    u_xlat16_1.x = dot(u_xlat16_1.xy, u_xlat16_1.xy);
					    u_xlat2.x = (-u_xlat16_1.x) * _VignetteIntensity + 1.0;
					    u_xlat0.w = 1.0;
					    u_xlat0 = u_xlat0 * u_xlat2.xxxx;
					    SV_Target0 = u_xlat0;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier00 " {
					Keywords { "ACES_ON" "SaturN_OFF" "Vignette_ON" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					out highp vec2 vs_TEXCOORD0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	mediump vec4 _Color;
					uniform 	float _Contrast;
					uniform 	float _Exposure;
					uniform 	float _Gamma;
					uniform 	float _VignetteIntensity;
					uniform mediump sampler2D _MainTex;
					in highp vec2 vs_TEXCOORD0;
					layout(location = 0) out mediump vec4 SV_Target0;
					vec4 u_xlat0;
					mediump vec3 u_xlat16_0;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					void main()
					{
					    u_xlat16_0.xyz = texture(_MainTex, vs_TEXCOORD0.xy).xyz;
					    u_xlat16_1.xyz = u_xlat16_0.xyz + vec3(-0.5, -0.5, -0.5);
					    u_xlat16_1.xyz = vec3(_Contrast) * u_xlat16_1.xyz + vec3(0.5, 0.5, 0.5);
					#ifdef UNITY_ADRENO_ES3
					    u_xlat16_1.xyz = min(max(u_xlat16_1.xyz, 0.0), 1.0);
					#else
					    u_xlat16_1.xyz = clamp(u_xlat16_1.xyz, 0.0, 1.0);
					#endif
					    u_xlat0.xyz = log2(u_xlat16_1.xyz);
					    u_xlat12 = float(1.0) / _Gamma;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat12);
					    u_xlat0.xyz = exp2(u_xlat0.xyz);
					    u_xlat0.xyz = u_xlat0.xyz + _Color.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(vec3(_Exposure, _Exposure, _Exposure));
					    u_xlat2.xyz = u_xlat0.xyz * vec3(12.5500002, 12.5500002, 12.5500002) + vec3(0.0299999993, 0.0299999993, 0.0299999993);
					    u_xlat3.xyz = u_xlat0.xyz * vec3(5.0, 5.0, 5.0);
					    u_xlat0.xyz = u_xlat0.xyz * vec3(12.1500006, 12.1500006, 12.1500006) + vec3(0.589999974, 0.589999974, 0.589999974);
					    u_xlat0.xyz = u_xlat3.xyz * u_xlat0.xyz + vec3(0.140000001, 0.140000001, 0.140000001);
					    u_xlat2.xyz = u_xlat2.xyz * u_xlat3.xyz;
					    u_xlat0.xyz = u_xlat2.xyz / u_xlat0.xyz;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat0.xyz = min(max(u_xlat0.xyz, 0.0), 1.0);
					#else
					    u_xlat0.xyz = clamp(u_xlat0.xyz, 0.0, 1.0);
					#endif
					    u_xlat16_1.xy = vs_TEXCOORD0.xy + vec2(-0.5, -0.5);
					    u_xlat16_1.xy = u_xlat16_1.xy + u_xlat16_1.xy;
					    u_xlat16_1.x = dot(u_xlat16_1.xy, u_xlat16_1.xy);
					    u_xlat2.x = (-u_xlat16_1.x) * _VignetteIntensity + 1.0;
					    u_xlat0.w = 1.0;
					    u_xlat0 = u_xlat0 * u_xlat2.xxxx;
					    SV_Target0 = u_xlat0;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier01 " {
					Keywords { "ACES_ON" "SaturN_OFF" "Vignette_ON" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					out highp vec2 vs_TEXCOORD0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	mediump vec4 _Color;
					uniform 	float _Contrast;
					uniform 	float _Exposure;
					uniform 	float _Gamma;
					uniform 	float _VignetteIntensity;
					uniform mediump sampler2D _MainTex;
					in highp vec2 vs_TEXCOORD0;
					layout(location = 0) out mediump vec4 SV_Target0;
					vec4 u_xlat0;
					mediump vec3 u_xlat16_0;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					void main()
					{
					    u_xlat16_0.xyz = texture(_MainTex, vs_TEXCOORD0.xy).xyz;
					    u_xlat16_1.xyz = u_xlat16_0.xyz + vec3(-0.5, -0.5, -0.5);
					    u_xlat16_1.xyz = vec3(_Contrast) * u_xlat16_1.xyz + vec3(0.5, 0.5, 0.5);
					#ifdef UNITY_ADRENO_ES3
					    u_xlat16_1.xyz = min(max(u_xlat16_1.xyz, 0.0), 1.0);
					#else
					    u_xlat16_1.xyz = clamp(u_xlat16_1.xyz, 0.0, 1.0);
					#endif
					    u_xlat0.xyz = log2(u_xlat16_1.xyz);
					    u_xlat12 = float(1.0) / _Gamma;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat12);
					    u_xlat0.xyz = exp2(u_xlat0.xyz);
					    u_xlat0.xyz = u_xlat0.xyz + _Color.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(vec3(_Exposure, _Exposure, _Exposure));
					    u_xlat2.xyz = u_xlat0.xyz * vec3(12.5500002, 12.5500002, 12.5500002) + vec3(0.0299999993, 0.0299999993, 0.0299999993);
					    u_xlat3.xyz = u_xlat0.xyz * vec3(5.0, 5.0, 5.0);
					    u_xlat0.xyz = u_xlat0.xyz * vec3(12.1500006, 12.1500006, 12.1500006) + vec3(0.589999974, 0.589999974, 0.589999974);
					    u_xlat0.xyz = u_xlat3.xyz * u_xlat0.xyz + vec3(0.140000001, 0.140000001, 0.140000001);
					    u_xlat2.xyz = u_xlat2.xyz * u_xlat3.xyz;
					    u_xlat0.xyz = u_xlat2.xyz / u_xlat0.xyz;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat0.xyz = min(max(u_xlat0.xyz, 0.0), 1.0);
					#else
					    u_xlat0.xyz = clamp(u_xlat0.xyz, 0.0, 1.0);
					#endif
					    u_xlat16_1.xy = vs_TEXCOORD0.xy + vec2(-0.5, -0.5);
					    u_xlat16_1.xy = u_xlat16_1.xy + u_xlat16_1.xy;
					    u_xlat16_1.x = dot(u_xlat16_1.xy, u_xlat16_1.xy);
					    u_xlat2.x = (-u_xlat16_1.x) * _VignetteIntensity + 1.0;
					    u_xlat0.w = 1.0;
					    u_xlat0 = u_xlat0 * u_xlat2.xxxx;
					    SV_Target0 = u_xlat0;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier02 " {
					Keywords { "ACES_ON" "SaturN_OFF" "Vignette_ON" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					out highp vec2 vs_TEXCOORD0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	mediump vec4 _Color;
					uniform 	float _Contrast;
					uniform 	float _Exposure;
					uniform 	float _Gamma;
					uniform 	float _VignetteIntensity;
					uniform mediump sampler2D _MainTex;
					in highp vec2 vs_TEXCOORD0;
					layout(location = 0) out mediump vec4 SV_Target0;
					vec4 u_xlat0;
					mediump vec3 u_xlat16_0;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					void main()
					{
					    u_xlat16_0.xyz = texture(_MainTex, vs_TEXCOORD0.xy).xyz;
					    u_xlat16_1.xyz = u_xlat16_0.xyz + vec3(-0.5, -0.5, -0.5);
					    u_xlat16_1.xyz = vec3(_Contrast) * u_xlat16_1.xyz + vec3(0.5, 0.5, 0.5);
					#ifdef UNITY_ADRENO_ES3
					    u_xlat16_1.xyz = min(max(u_xlat16_1.xyz, 0.0), 1.0);
					#else
					    u_xlat16_1.xyz = clamp(u_xlat16_1.xyz, 0.0, 1.0);
					#endif
					    u_xlat0.xyz = log2(u_xlat16_1.xyz);
					    u_xlat12 = float(1.0) / _Gamma;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat12);
					    u_xlat0.xyz = exp2(u_xlat0.xyz);
					    u_xlat0.xyz = u_xlat0.xyz + _Color.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(vec3(_Exposure, _Exposure, _Exposure));
					    u_xlat2.xyz = u_xlat0.xyz * vec3(12.5500002, 12.5500002, 12.5500002) + vec3(0.0299999993, 0.0299999993, 0.0299999993);
					    u_xlat3.xyz = u_xlat0.xyz * vec3(5.0, 5.0, 5.0);
					    u_xlat0.xyz = u_xlat0.xyz * vec3(12.1500006, 12.1500006, 12.1500006) + vec3(0.589999974, 0.589999974, 0.589999974);
					    u_xlat0.xyz = u_xlat3.xyz * u_xlat0.xyz + vec3(0.140000001, 0.140000001, 0.140000001);
					    u_xlat2.xyz = u_xlat2.xyz * u_xlat3.xyz;
					    u_xlat0.xyz = u_xlat2.xyz / u_xlat0.xyz;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat0.xyz = min(max(u_xlat0.xyz, 0.0), 1.0);
					#else
					    u_xlat0.xyz = clamp(u_xlat0.xyz, 0.0, 1.0);
					#endif
					    u_xlat16_1.xy = vs_TEXCOORD0.xy + vec2(-0.5, -0.5);
					    u_xlat16_1.xy = u_xlat16_1.xy + u_xlat16_1.xy;
					    u_xlat16_1.x = dot(u_xlat16_1.xy, u_xlat16_1.xy);
					    u_xlat2.x = (-u_xlat16_1.x) * _VignetteIntensity + 1.0;
					    u_xlat0.w = 1.0;
					    u_xlat0 = u_xlat0 * u_xlat2.xxxx;
					    SV_Target0 = u_xlat0;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier00 " {
					Keywords { "ACES_ON" "SaturN_OFF" "Vignette_OFF" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					varying highp vec2 vs_TEXCOORD0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
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
					uniform 	mediump vec4 _Color;
					uniform 	float _Contrast;
					uniform 	float _Exposure;
					uniform 	float _Gamma;
					uniform lowp sampler2D _MainTex;
					varying highp vec2 vs_TEXCOORD0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					void main()
					{
					    u_xlat10_0.xyz = texture2D(_MainTex, vs_TEXCOORD0.xy).xyz;
					    u_xlat16_1.xyz = u_xlat10_0.xyz + vec3(-0.5, -0.5, -0.5);
					    u_xlat16_1.xyz = vec3(_Contrast) * u_xlat16_1.xyz + vec3(0.5, 0.5, 0.5);
					    u_xlat16_1.xyz = clamp(u_xlat16_1.xyz, 0.0, 1.0);
					    u_xlat0.xyz = log2(u_xlat16_1.xyz);
					    u_xlat12 = float(1.0) / _Gamma;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat12);
					    u_xlat0.xyz = exp2(u_xlat0.xyz);
					    u_xlat0.xyz = u_xlat0.xyz + _Color.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(vec3(_Exposure, _Exposure, _Exposure));
					    u_xlat2.xyz = u_xlat0.xyz * vec3(12.5500002, 12.5500002, 12.5500002) + vec3(0.0299999993, 0.0299999993, 0.0299999993);
					    u_xlat3.xyz = u_xlat0.xyz * vec3(5.0, 5.0, 5.0);
					    u_xlat0.xyz = u_xlat0.xyz * vec3(12.1500006, 12.1500006, 12.1500006) + vec3(0.589999974, 0.589999974, 0.589999974);
					    u_xlat0.xyz = u_xlat3.xyz * u_xlat0.xyz + vec3(0.140000001, 0.140000001, 0.140000001);
					    u_xlat2.xyz = u_xlat2.xyz * u_xlat3.xyz;
					    u_xlat0.xyz = u_xlat2.xyz / u_xlat0.xyz;
					    u_xlat0.xyz = clamp(u_xlat0.xyz, 0.0, 1.0);
					    SV_Target0.xyz = u_xlat0.xyz;
					    SV_Target0.w = 1.0;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier01 " {
					Keywords { "ACES_ON" "SaturN_OFF" "Vignette_OFF" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					varying highp vec2 vs_TEXCOORD0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
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
					uniform 	mediump vec4 _Color;
					uniform 	float _Contrast;
					uniform 	float _Exposure;
					uniform 	float _Gamma;
					uniform lowp sampler2D _MainTex;
					varying highp vec2 vs_TEXCOORD0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					void main()
					{
					    u_xlat10_0.xyz = texture2D(_MainTex, vs_TEXCOORD0.xy).xyz;
					    u_xlat16_1.xyz = u_xlat10_0.xyz + vec3(-0.5, -0.5, -0.5);
					    u_xlat16_1.xyz = vec3(_Contrast) * u_xlat16_1.xyz + vec3(0.5, 0.5, 0.5);
					    u_xlat16_1.xyz = clamp(u_xlat16_1.xyz, 0.0, 1.0);
					    u_xlat0.xyz = log2(u_xlat16_1.xyz);
					    u_xlat12 = float(1.0) / _Gamma;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat12);
					    u_xlat0.xyz = exp2(u_xlat0.xyz);
					    u_xlat0.xyz = u_xlat0.xyz + _Color.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(vec3(_Exposure, _Exposure, _Exposure));
					    u_xlat2.xyz = u_xlat0.xyz * vec3(12.5500002, 12.5500002, 12.5500002) + vec3(0.0299999993, 0.0299999993, 0.0299999993);
					    u_xlat3.xyz = u_xlat0.xyz * vec3(5.0, 5.0, 5.0);
					    u_xlat0.xyz = u_xlat0.xyz * vec3(12.1500006, 12.1500006, 12.1500006) + vec3(0.589999974, 0.589999974, 0.589999974);
					    u_xlat0.xyz = u_xlat3.xyz * u_xlat0.xyz + vec3(0.140000001, 0.140000001, 0.140000001);
					    u_xlat2.xyz = u_xlat2.xyz * u_xlat3.xyz;
					    u_xlat0.xyz = u_xlat2.xyz / u_xlat0.xyz;
					    u_xlat0.xyz = clamp(u_xlat0.xyz, 0.0, 1.0);
					    SV_Target0.xyz = u_xlat0.xyz;
					    SV_Target0.w = 1.0;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier02 " {
					Keywords { "ACES_ON" "SaturN_OFF" "Vignette_OFF" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					varying highp vec2 vs_TEXCOORD0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
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
					uniform 	mediump vec4 _Color;
					uniform 	float _Contrast;
					uniform 	float _Exposure;
					uniform 	float _Gamma;
					uniform lowp sampler2D _MainTex;
					varying highp vec2 vs_TEXCOORD0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					void main()
					{
					    u_xlat10_0.xyz = texture2D(_MainTex, vs_TEXCOORD0.xy).xyz;
					    u_xlat16_1.xyz = u_xlat10_0.xyz + vec3(-0.5, -0.5, -0.5);
					    u_xlat16_1.xyz = vec3(_Contrast) * u_xlat16_1.xyz + vec3(0.5, 0.5, 0.5);
					    u_xlat16_1.xyz = clamp(u_xlat16_1.xyz, 0.0, 1.0);
					    u_xlat0.xyz = log2(u_xlat16_1.xyz);
					    u_xlat12 = float(1.0) / _Gamma;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat12);
					    u_xlat0.xyz = exp2(u_xlat0.xyz);
					    u_xlat0.xyz = u_xlat0.xyz + _Color.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(vec3(_Exposure, _Exposure, _Exposure));
					    u_xlat2.xyz = u_xlat0.xyz * vec3(12.5500002, 12.5500002, 12.5500002) + vec3(0.0299999993, 0.0299999993, 0.0299999993);
					    u_xlat3.xyz = u_xlat0.xyz * vec3(5.0, 5.0, 5.0);
					    u_xlat0.xyz = u_xlat0.xyz * vec3(12.1500006, 12.1500006, 12.1500006) + vec3(0.589999974, 0.589999974, 0.589999974);
					    u_xlat0.xyz = u_xlat3.xyz * u_xlat0.xyz + vec3(0.140000001, 0.140000001, 0.140000001);
					    u_xlat2.xyz = u_xlat2.xyz * u_xlat3.xyz;
					    u_xlat0.xyz = u_xlat2.xyz / u_xlat0.xyz;
					    u_xlat0.xyz = clamp(u_xlat0.xyz, 0.0, 1.0);
					    SV_Target0.xyz = u_xlat0.xyz;
					    SV_Target0.w = 1.0;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier00 " {
					Keywords { "ACES_ON" "SaturN_OFF" "Vignette_OFF" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					out highp vec2 vs_TEXCOORD0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	mediump vec4 _Color;
					uniform 	float _Contrast;
					uniform 	float _Exposure;
					uniform 	float _Gamma;
					uniform mediump sampler2D _MainTex;
					in highp vec2 vs_TEXCOORD0;
					layout(location = 0) out mediump vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					void main()
					{
					    u_xlat16_0.xyz = texture(_MainTex, vs_TEXCOORD0.xy).xyz;
					    u_xlat16_1.xyz = u_xlat16_0.xyz + vec3(-0.5, -0.5, -0.5);
					    u_xlat16_1.xyz = vec3(_Contrast) * u_xlat16_1.xyz + vec3(0.5, 0.5, 0.5);
					#ifdef UNITY_ADRENO_ES3
					    u_xlat16_1.xyz = min(max(u_xlat16_1.xyz, 0.0), 1.0);
					#else
					    u_xlat16_1.xyz = clamp(u_xlat16_1.xyz, 0.0, 1.0);
					#endif
					    u_xlat0.xyz = log2(u_xlat16_1.xyz);
					    u_xlat12 = float(1.0) / _Gamma;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat12);
					    u_xlat0.xyz = exp2(u_xlat0.xyz);
					    u_xlat0.xyz = u_xlat0.xyz + _Color.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(vec3(_Exposure, _Exposure, _Exposure));
					    u_xlat2.xyz = u_xlat0.xyz * vec3(12.5500002, 12.5500002, 12.5500002) + vec3(0.0299999993, 0.0299999993, 0.0299999993);
					    u_xlat3.xyz = u_xlat0.xyz * vec3(5.0, 5.0, 5.0);
					    u_xlat0.xyz = u_xlat0.xyz * vec3(12.1500006, 12.1500006, 12.1500006) + vec3(0.589999974, 0.589999974, 0.589999974);
					    u_xlat0.xyz = u_xlat3.xyz * u_xlat0.xyz + vec3(0.140000001, 0.140000001, 0.140000001);
					    u_xlat2.xyz = u_xlat2.xyz * u_xlat3.xyz;
					    u_xlat0.xyz = u_xlat2.xyz / u_xlat0.xyz;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat0.xyz = min(max(u_xlat0.xyz, 0.0), 1.0);
					#else
					    u_xlat0.xyz = clamp(u_xlat0.xyz, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = u_xlat0.xyz;
					    SV_Target0.w = 1.0;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier01 " {
					Keywords { "ACES_ON" "SaturN_OFF" "Vignette_OFF" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					out highp vec2 vs_TEXCOORD0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	mediump vec4 _Color;
					uniform 	float _Contrast;
					uniform 	float _Exposure;
					uniform 	float _Gamma;
					uniform mediump sampler2D _MainTex;
					in highp vec2 vs_TEXCOORD0;
					layout(location = 0) out mediump vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					void main()
					{
					    u_xlat16_0.xyz = texture(_MainTex, vs_TEXCOORD0.xy).xyz;
					    u_xlat16_1.xyz = u_xlat16_0.xyz + vec3(-0.5, -0.5, -0.5);
					    u_xlat16_1.xyz = vec3(_Contrast) * u_xlat16_1.xyz + vec3(0.5, 0.5, 0.5);
					#ifdef UNITY_ADRENO_ES3
					    u_xlat16_1.xyz = min(max(u_xlat16_1.xyz, 0.0), 1.0);
					#else
					    u_xlat16_1.xyz = clamp(u_xlat16_1.xyz, 0.0, 1.0);
					#endif
					    u_xlat0.xyz = log2(u_xlat16_1.xyz);
					    u_xlat12 = float(1.0) / _Gamma;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat12);
					    u_xlat0.xyz = exp2(u_xlat0.xyz);
					    u_xlat0.xyz = u_xlat0.xyz + _Color.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(vec3(_Exposure, _Exposure, _Exposure));
					    u_xlat2.xyz = u_xlat0.xyz * vec3(12.5500002, 12.5500002, 12.5500002) + vec3(0.0299999993, 0.0299999993, 0.0299999993);
					    u_xlat3.xyz = u_xlat0.xyz * vec3(5.0, 5.0, 5.0);
					    u_xlat0.xyz = u_xlat0.xyz * vec3(12.1500006, 12.1500006, 12.1500006) + vec3(0.589999974, 0.589999974, 0.589999974);
					    u_xlat0.xyz = u_xlat3.xyz * u_xlat0.xyz + vec3(0.140000001, 0.140000001, 0.140000001);
					    u_xlat2.xyz = u_xlat2.xyz * u_xlat3.xyz;
					    u_xlat0.xyz = u_xlat2.xyz / u_xlat0.xyz;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat0.xyz = min(max(u_xlat0.xyz, 0.0), 1.0);
					#else
					    u_xlat0.xyz = clamp(u_xlat0.xyz, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = u_xlat0.xyz;
					    SV_Target0.w = 1.0;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier02 " {
					Keywords { "ACES_ON" "SaturN_OFF" "Vignette_OFF" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					out highp vec2 vs_TEXCOORD0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	mediump vec4 _Color;
					uniform 	float _Contrast;
					uniform 	float _Exposure;
					uniform 	float _Gamma;
					uniform mediump sampler2D _MainTex;
					in highp vec2 vs_TEXCOORD0;
					layout(location = 0) out mediump vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					mediump vec3 u_xlat16_1;
					vec3 u_xlat2;
					vec3 u_xlat3;
					float u_xlat12;
					void main()
					{
					    u_xlat16_0.xyz = texture(_MainTex, vs_TEXCOORD0.xy).xyz;
					    u_xlat16_1.xyz = u_xlat16_0.xyz + vec3(-0.5, -0.5, -0.5);
					    u_xlat16_1.xyz = vec3(_Contrast) * u_xlat16_1.xyz + vec3(0.5, 0.5, 0.5);
					#ifdef UNITY_ADRENO_ES3
					    u_xlat16_1.xyz = min(max(u_xlat16_1.xyz, 0.0), 1.0);
					#else
					    u_xlat16_1.xyz = clamp(u_xlat16_1.xyz, 0.0, 1.0);
					#endif
					    u_xlat0.xyz = log2(u_xlat16_1.xyz);
					    u_xlat12 = float(1.0) / _Gamma;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat12);
					    u_xlat0.xyz = exp2(u_xlat0.xyz);
					    u_xlat0.xyz = u_xlat0.xyz + _Color.xyz;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(vec3(_Exposure, _Exposure, _Exposure));
					    u_xlat2.xyz = u_xlat0.xyz * vec3(12.5500002, 12.5500002, 12.5500002) + vec3(0.0299999993, 0.0299999993, 0.0299999993);
					    u_xlat3.xyz = u_xlat0.xyz * vec3(5.0, 5.0, 5.0);
					    u_xlat0.xyz = u_xlat0.xyz * vec3(12.1500006, 12.1500006, 12.1500006) + vec3(0.589999974, 0.589999974, 0.589999974);
					    u_xlat0.xyz = u_xlat3.xyz * u_xlat0.xyz + vec3(0.140000001, 0.140000001, 0.140000001);
					    u_xlat2.xyz = u_xlat2.xyz * u_xlat3.xyz;
					    u_xlat0.xyz = u_xlat2.xyz / u_xlat0.xyz;
					#ifdef UNITY_ADRENO_ES3
					    u_xlat0.xyz = min(max(u_xlat0.xyz, 0.0), 1.0);
					#else
					    u_xlat0.xyz = clamp(u_xlat0.xyz, 0.0, 1.0);
					#endif
					    SV_Target0.xyz = u_xlat0.xyz;
					    SV_Target0.w = 1.0;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier00 " {
					Keywords { "ACES_OFF" "SaturN_ON" "Vignette_ON" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					varying highp vec2 vs_TEXCOORD0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
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
					uniform 	mediump vec4 _Color;
					uniform 	float _Contrast;
					uniform 	float _Gamma;
					uniform 	float _VignetteIntensity;
					uniform 	float _Saturation;
					uniform lowp sampler2D _MainTex;
					varying highp vec2 vs_TEXCOORD0;
					#define SV_Target0 gl_FragData[0]
					vec4 u_xlat0;
					lowp vec3 u_xlat10_0;
					mediump vec3 u_xlat16_1;
					float u_xlat2;
					float u_xlat9;
					void main()
					{
					    u_xlat10_0.xyz = texture2D(_MainTex, vs_TEXCOORD0.xy).xyz;
					    u_xlat9 = dot(u_xlat10_0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat16_1.xyz = u_xlat10_0.xyz + vec3(-0.5, -0.5, -0.5);
					    u_xlat16_1.xyz = vec3(_Contrast) * u_xlat16_1.xyz + vec3(0.5, 0.5, 0.5);
					    u_xlat16_1.xyz = clamp(u_xlat16_1.xyz, 0.0, 1.0);
					    u_xlat0.xyz = vec3(u_xlat9) + (-u_xlat16_1.xyz);
					    u_xlat0.xyz = vec3(_Saturation) * u_xlat0.xyz + u_xlat16_1.xyz;
					    u_xlat0.xyz = log2(u_xlat0.xyz);
					    u_xlat9 = float(1.0) / _Gamma;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9);
					    u_xlat0.xyz = exp2(u_xlat0.xyz);
					    u_xlat0.xyz = u_xlat0.xyz + _Color.xyz;
					    u_xlat16_1.xy = vs_TEXCOORD0.xy + vec2(-0.5, -0.5);
					    u_xlat16_1.xy = u_xlat16_1.xy + u_xlat16_1.xy;
					    u_xlat16_1.x = dot(u_xlat16_1.xy, u_xlat16_1.xy);
					    u_xlat2 = (-u_xlat16_1.x) * _VignetteIntensity + 1.0;
					    u_xlat0.w = 1.0;
					    u_xlat0 = u_xlat0 * vec4(u_xlat2);
					    SV_Target0 = u_xlat0;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier01 " {
					Keywords { "ACES_OFF" "SaturN_ON" "Vignette_ON" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					varying highp vec2 vs_TEXCOORD0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
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
					uniform 	mediump vec4 _Color;
					uniform 	float _Contrast;
					uniform 	float _Gamma;
					uniform 	float _VignetteIntensity;
					uniform 	float _Saturation;
					uniform lowp sampler2D _MainTex;
					varying highp vec2 vs_TEXCOORD0;
					#define SV_Target0 gl_FragData[0]
					vec4 u_xlat0;
					lowp vec3 u_xlat10_0;
					mediump vec3 u_xlat16_1;
					float u_xlat2;
					float u_xlat9;
					void main()
					{
					    u_xlat10_0.xyz = texture2D(_MainTex, vs_TEXCOORD0.xy).xyz;
					    u_xlat9 = dot(u_xlat10_0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat16_1.xyz = u_xlat10_0.xyz + vec3(-0.5, -0.5, -0.5);
					    u_xlat16_1.xyz = vec3(_Contrast) * u_xlat16_1.xyz + vec3(0.5, 0.5, 0.5);
					    u_xlat16_1.xyz = clamp(u_xlat16_1.xyz, 0.0, 1.0);
					    u_xlat0.xyz = vec3(u_xlat9) + (-u_xlat16_1.xyz);
					    u_xlat0.xyz = vec3(_Saturation) * u_xlat0.xyz + u_xlat16_1.xyz;
					    u_xlat0.xyz = log2(u_xlat0.xyz);
					    u_xlat9 = float(1.0) / _Gamma;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9);
					    u_xlat0.xyz = exp2(u_xlat0.xyz);
					    u_xlat0.xyz = u_xlat0.xyz + _Color.xyz;
					    u_xlat16_1.xy = vs_TEXCOORD0.xy + vec2(-0.5, -0.5);
					    u_xlat16_1.xy = u_xlat16_1.xy + u_xlat16_1.xy;
					    u_xlat16_1.x = dot(u_xlat16_1.xy, u_xlat16_1.xy);
					    u_xlat2 = (-u_xlat16_1.x) * _VignetteIntensity + 1.0;
					    u_xlat0.w = 1.0;
					    u_xlat0 = u_xlat0 * vec4(u_xlat2);
					    SV_Target0 = u_xlat0;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier02 " {
					Keywords { "ACES_OFF" "SaturN_ON" "Vignette_ON" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					varying highp vec2 vs_TEXCOORD0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
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
					uniform 	mediump vec4 _Color;
					uniform 	float _Contrast;
					uniform 	float _Gamma;
					uniform 	float _VignetteIntensity;
					uniform 	float _Saturation;
					uniform lowp sampler2D _MainTex;
					varying highp vec2 vs_TEXCOORD0;
					#define SV_Target0 gl_FragData[0]
					vec4 u_xlat0;
					lowp vec3 u_xlat10_0;
					mediump vec3 u_xlat16_1;
					float u_xlat2;
					float u_xlat9;
					void main()
					{
					    u_xlat10_0.xyz = texture2D(_MainTex, vs_TEXCOORD0.xy).xyz;
					    u_xlat9 = dot(u_xlat10_0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat16_1.xyz = u_xlat10_0.xyz + vec3(-0.5, -0.5, -0.5);
					    u_xlat16_1.xyz = vec3(_Contrast) * u_xlat16_1.xyz + vec3(0.5, 0.5, 0.5);
					    u_xlat16_1.xyz = clamp(u_xlat16_1.xyz, 0.0, 1.0);
					    u_xlat0.xyz = vec3(u_xlat9) + (-u_xlat16_1.xyz);
					    u_xlat0.xyz = vec3(_Saturation) * u_xlat0.xyz + u_xlat16_1.xyz;
					    u_xlat0.xyz = log2(u_xlat0.xyz);
					    u_xlat9 = float(1.0) / _Gamma;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9);
					    u_xlat0.xyz = exp2(u_xlat0.xyz);
					    u_xlat0.xyz = u_xlat0.xyz + _Color.xyz;
					    u_xlat16_1.xy = vs_TEXCOORD0.xy + vec2(-0.5, -0.5);
					    u_xlat16_1.xy = u_xlat16_1.xy + u_xlat16_1.xy;
					    u_xlat16_1.x = dot(u_xlat16_1.xy, u_xlat16_1.xy);
					    u_xlat2 = (-u_xlat16_1.x) * _VignetteIntensity + 1.0;
					    u_xlat0.w = 1.0;
					    u_xlat0 = u_xlat0 * vec4(u_xlat2);
					    SV_Target0 = u_xlat0;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier00 " {
					Keywords { "ACES_OFF" "SaturN_ON" "Vignette_ON" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					out highp vec2 vs_TEXCOORD0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	mediump vec4 _Color;
					uniform 	float _Contrast;
					uniform 	float _Gamma;
					uniform 	float _VignetteIntensity;
					uniform 	float _Saturation;
					uniform mediump sampler2D _MainTex;
					in highp vec2 vs_TEXCOORD0;
					layout(location = 0) out mediump vec4 SV_Target0;
					vec4 u_xlat0;
					mediump vec3 u_xlat16_0;
					mediump vec3 u_xlat16_1;
					float u_xlat2;
					float u_xlat9;
					void main()
					{
					    u_xlat16_0.xyz = texture(_MainTex, vs_TEXCOORD0.xy).xyz;
					    u_xlat9 = dot(u_xlat16_0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat16_1.xyz = u_xlat16_0.xyz + vec3(-0.5, -0.5, -0.5);
					    u_xlat16_1.xyz = vec3(_Contrast) * u_xlat16_1.xyz + vec3(0.5, 0.5, 0.5);
					#ifdef UNITY_ADRENO_ES3
					    u_xlat16_1.xyz = min(max(u_xlat16_1.xyz, 0.0), 1.0);
					#else
					    u_xlat16_1.xyz = clamp(u_xlat16_1.xyz, 0.0, 1.0);
					#endif
					    u_xlat0.xyz = vec3(u_xlat9) + (-u_xlat16_1.xyz);
					    u_xlat0.xyz = vec3(_Saturation) * u_xlat0.xyz + u_xlat16_1.xyz;
					    u_xlat0.xyz = log2(u_xlat0.xyz);
					    u_xlat9 = float(1.0) / _Gamma;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9);
					    u_xlat0.xyz = exp2(u_xlat0.xyz);
					    u_xlat0.xyz = u_xlat0.xyz + _Color.xyz;
					    u_xlat16_1.xy = vs_TEXCOORD0.xy + vec2(-0.5, -0.5);
					    u_xlat16_1.xy = u_xlat16_1.xy + u_xlat16_1.xy;
					    u_xlat16_1.x = dot(u_xlat16_1.xy, u_xlat16_1.xy);
					    u_xlat2 = (-u_xlat16_1.x) * _VignetteIntensity + 1.0;
					    u_xlat0.w = 1.0;
					    u_xlat0 = u_xlat0 * vec4(u_xlat2);
					    SV_Target0 = u_xlat0;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier01 " {
					Keywords { "ACES_OFF" "SaturN_ON" "Vignette_ON" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					out highp vec2 vs_TEXCOORD0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	mediump vec4 _Color;
					uniform 	float _Contrast;
					uniform 	float _Gamma;
					uniform 	float _VignetteIntensity;
					uniform 	float _Saturation;
					uniform mediump sampler2D _MainTex;
					in highp vec2 vs_TEXCOORD0;
					layout(location = 0) out mediump vec4 SV_Target0;
					vec4 u_xlat0;
					mediump vec3 u_xlat16_0;
					mediump vec3 u_xlat16_1;
					float u_xlat2;
					float u_xlat9;
					void main()
					{
					    u_xlat16_0.xyz = texture(_MainTex, vs_TEXCOORD0.xy).xyz;
					    u_xlat9 = dot(u_xlat16_0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat16_1.xyz = u_xlat16_0.xyz + vec3(-0.5, -0.5, -0.5);
					    u_xlat16_1.xyz = vec3(_Contrast) * u_xlat16_1.xyz + vec3(0.5, 0.5, 0.5);
					#ifdef UNITY_ADRENO_ES3
					    u_xlat16_1.xyz = min(max(u_xlat16_1.xyz, 0.0), 1.0);
					#else
					    u_xlat16_1.xyz = clamp(u_xlat16_1.xyz, 0.0, 1.0);
					#endif
					    u_xlat0.xyz = vec3(u_xlat9) + (-u_xlat16_1.xyz);
					    u_xlat0.xyz = vec3(_Saturation) * u_xlat0.xyz + u_xlat16_1.xyz;
					    u_xlat0.xyz = log2(u_xlat0.xyz);
					    u_xlat9 = float(1.0) / _Gamma;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9);
					    u_xlat0.xyz = exp2(u_xlat0.xyz);
					    u_xlat0.xyz = u_xlat0.xyz + _Color.xyz;
					    u_xlat16_1.xy = vs_TEXCOORD0.xy + vec2(-0.5, -0.5);
					    u_xlat16_1.xy = u_xlat16_1.xy + u_xlat16_1.xy;
					    u_xlat16_1.x = dot(u_xlat16_1.xy, u_xlat16_1.xy);
					    u_xlat2 = (-u_xlat16_1.x) * _VignetteIntensity + 1.0;
					    u_xlat0.w = 1.0;
					    u_xlat0 = u_xlat0 * vec4(u_xlat2);
					    SV_Target0 = u_xlat0;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier02 " {
					Keywords { "ACES_OFF" "SaturN_ON" "Vignette_ON" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					out highp vec2 vs_TEXCOORD0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	mediump vec4 _Color;
					uniform 	float _Contrast;
					uniform 	float _Gamma;
					uniform 	float _VignetteIntensity;
					uniform 	float _Saturation;
					uniform mediump sampler2D _MainTex;
					in highp vec2 vs_TEXCOORD0;
					layout(location = 0) out mediump vec4 SV_Target0;
					vec4 u_xlat0;
					mediump vec3 u_xlat16_0;
					mediump vec3 u_xlat16_1;
					float u_xlat2;
					float u_xlat9;
					void main()
					{
					    u_xlat16_0.xyz = texture(_MainTex, vs_TEXCOORD0.xy).xyz;
					    u_xlat9 = dot(u_xlat16_0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat16_1.xyz = u_xlat16_0.xyz + vec3(-0.5, -0.5, -0.5);
					    u_xlat16_1.xyz = vec3(_Contrast) * u_xlat16_1.xyz + vec3(0.5, 0.5, 0.5);
					#ifdef UNITY_ADRENO_ES3
					    u_xlat16_1.xyz = min(max(u_xlat16_1.xyz, 0.0), 1.0);
					#else
					    u_xlat16_1.xyz = clamp(u_xlat16_1.xyz, 0.0, 1.0);
					#endif
					    u_xlat0.xyz = vec3(u_xlat9) + (-u_xlat16_1.xyz);
					    u_xlat0.xyz = vec3(_Saturation) * u_xlat0.xyz + u_xlat16_1.xyz;
					    u_xlat0.xyz = log2(u_xlat0.xyz);
					    u_xlat9 = float(1.0) / _Gamma;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9);
					    u_xlat0.xyz = exp2(u_xlat0.xyz);
					    u_xlat0.xyz = u_xlat0.xyz + _Color.xyz;
					    u_xlat16_1.xy = vs_TEXCOORD0.xy + vec2(-0.5, -0.5);
					    u_xlat16_1.xy = u_xlat16_1.xy + u_xlat16_1.xy;
					    u_xlat16_1.x = dot(u_xlat16_1.xy, u_xlat16_1.xy);
					    u_xlat2 = (-u_xlat16_1.x) * _VignetteIntensity + 1.0;
					    u_xlat0.w = 1.0;
					    u_xlat0 = u_xlat0 * vec4(u_xlat2);
					    SV_Target0 = u_xlat0;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier00 " {
					Keywords { "ACES_OFF" "SaturN_ON" "Vignette_OFF" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					varying highp vec2 vs_TEXCOORD0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
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
					uniform 	mediump vec4 _Color;
					uniform 	float _Contrast;
					uniform 	float _Gamma;
					uniform 	float _Saturation;
					uniform lowp sampler2D _MainTex;
					varying highp vec2 vs_TEXCOORD0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					mediump vec3 u_xlat16_1;
					float u_xlat6;
					void main()
					{
					    u_xlat10_0.xyz = texture2D(_MainTex, vs_TEXCOORD0.xy).xyz;
					    u_xlat6 = dot(u_xlat10_0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat16_1.xyz = u_xlat10_0.xyz + vec3(-0.5, -0.5, -0.5);
					    u_xlat16_1.xyz = vec3(_Contrast) * u_xlat16_1.xyz + vec3(0.5, 0.5, 0.5);
					    u_xlat16_1.xyz = clamp(u_xlat16_1.xyz, 0.0, 1.0);
					    u_xlat0.xyz = vec3(u_xlat6) + (-u_xlat16_1.xyz);
					    u_xlat0.xyz = vec3(_Saturation) * u_xlat0.xyz + u_xlat16_1.xyz;
					    u_xlat0.xyz = log2(u_xlat0.xyz);
					    u_xlat6 = float(1.0) / _Gamma;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat6);
					    u_xlat0.xyz = exp2(u_xlat0.xyz);
					    u_xlat0.xyz = u_xlat0.xyz + _Color.xyz;
					    SV_Target0.xyz = u_xlat0.xyz;
					    SV_Target0.w = 1.0;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier01 " {
					Keywords { "ACES_OFF" "SaturN_ON" "Vignette_OFF" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					varying highp vec2 vs_TEXCOORD0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
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
					uniform 	mediump vec4 _Color;
					uniform 	float _Contrast;
					uniform 	float _Gamma;
					uniform 	float _Saturation;
					uniform lowp sampler2D _MainTex;
					varying highp vec2 vs_TEXCOORD0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					mediump vec3 u_xlat16_1;
					float u_xlat6;
					void main()
					{
					    u_xlat10_0.xyz = texture2D(_MainTex, vs_TEXCOORD0.xy).xyz;
					    u_xlat6 = dot(u_xlat10_0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat16_1.xyz = u_xlat10_0.xyz + vec3(-0.5, -0.5, -0.5);
					    u_xlat16_1.xyz = vec3(_Contrast) * u_xlat16_1.xyz + vec3(0.5, 0.5, 0.5);
					    u_xlat16_1.xyz = clamp(u_xlat16_1.xyz, 0.0, 1.0);
					    u_xlat0.xyz = vec3(u_xlat6) + (-u_xlat16_1.xyz);
					    u_xlat0.xyz = vec3(_Saturation) * u_xlat0.xyz + u_xlat16_1.xyz;
					    u_xlat0.xyz = log2(u_xlat0.xyz);
					    u_xlat6 = float(1.0) / _Gamma;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat6);
					    u_xlat0.xyz = exp2(u_xlat0.xyz);
					    u_xlat0.xyz = u_xlat0.xyz + _Color.xyz;
					    SV_Target0.xyz = u_xlat0.xyz;
					    SV_Target0.w = 1.0;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier02 " {
					Keywords { "ACES_OFF" "SaturN_ON" "Vignette_OFF" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					varying highp vec2 vs_TEXCOORD0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
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
					uniform 	mediump vec4 _Color;
					uniform 	float _Contrast;
					uniform 	float _Gamma;
					uniform 	float _Saturation;
					uniform lowp sampler2D _MainTex;
					varying highp vec2 vs_TEXCOORD0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					mediump vec3 u_xlat16_1;
					float u_xlat6;
					void main()
					{
					    u_xlat10_0.xyz = texture2D(_MainTex, vs_TEXCOORD0.xy).xyz;
					    u_xlat6 = dot(u_xlat10_0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat16_1.xyz = u_xlat10_0.xyz + vec3(-0.5, -0.5, -0.5);
					    u_xlat16_1.xyz = vec3(_Contrast) * u_xlat16_1.xyz + vec3(0.5, 0.5, 0.5);
					    u_xlat16_1.xyz = clamp(u_xlat16_1.xyz, 0.0, 1.0);
					    u_xlat0.xyz = vec3(u_xlat6) + (-u_xlat16_1.xyz);
					    u_xlat0.xyz = vec3(_Saturation) * u_xlat0.xyz + u_xlat16_1.xyz;
					    u_xlat0.xyz = log2(u_xlat0.xyz);
					    u_xlat6 = float(1.0) / _Gamma;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat6);
					    u_xlat0.xyz = exp2(u_xlat0.xyz);
					    u_xlat0.xyz = u_xlat0.xyz + _Color.xyz;
					    SV_Target0.xyz = u_xlat0.xyz;
					    SV_Target0.w = 1.0;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier00 " {
					Keywords { "ACES_OFF" "SaturN_ON" "Vignette_OFF" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					out highp vec2 vs_TEXCOORD0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	mediump vec4 _Color;
					uniform 	float _Contrast;
					uniform 	float _Gamma;
					uniform 	float _Saturation;
					uniform mediump sampler2D _MainTex;
					in highp vec2 vs_TEXCOORD0;
					layout(location = 0) out mediump vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					mediump vec3 u_xlat16_1;
					float u_xlat6;
					void main()
					{
					    u_xlat16_0.xyz = texture(_MainTex, vs_TEXCOORD0.xy).xyz;
					    u_xlat6 = dot(u_xlat16_0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat16_1.xyz = u_xlat16_0.xyz + vec3(-0.5, -0.5, -0.5);
					    u_xlat16_1.xyz = vec3(_Contrast) * u_xlat16_1.xyz + vec3(0.5, 0.5, 0.5);
					#ifdef UNITY_ADRENO_ES3
					    u_xlat16_1.xyz = min(max(u_xlat16_1.xyz, 0.0), 1.0);
					#else
					    u_xlat16_1.xyz = clamp(u_xlat16_1.xyz, 0.0, 1.0);
					#endif
					    u_xlat0.xyz = vec3(u_xlat6) + (-u_xlat16_1.xyz);
					    u_xlat0.xyz = vec3(_Saturation) * u_xlat0.xyz + u_xlat16_1.xyz;
					    u_xlat0.xyz = log2(u_xlat0.xyz);
					    u_xlat6 = float(1.0) / _Gamma;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat6);
					    u_xlat0.xyz = exp2(u_xlat0.xyz);
					    u_xlat0.xyz = u_xlat0.xyz + _Color.xyz;
					    SV_Target0.xyz = u_xlat0.xyz;
					    SV_Target0.w = 1.0;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier01 " {
					Keywords { "ACES_OFF" "SaturN_ON" "Vignette_OFF" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					out highp vec2 vs_TEXCOORD0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	mediump vec4 _Color;
					uniform 	float _Contrast;
					uniform 	float _Gamma;
					uniform 	float _Saturation;
					uniform mediump sampler2D _MainTex;
					in highp vec2 vs_TEXCOORD0;
					layout(location = 0) out mediump vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					mediump vec3 u_xlat16_1;
					float u_xlat6;
					void main()
					{
					    u_xlat16_0.xyz = texture(_MainTex, vs_TEXCOORD0.xy).xyz;
					    u_xlat6 = dot(u_xlat16_0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat16_1.xyz = u_xlat16_0.xyz + vec3(-0.5, -0.5, -0.5);
					    u_xlat16_1.xyz = vec3(_Contrast) * u_xlat16_1.xyz + vec3(0.5, 0.5, 0.5);
					#ifdef UNITY_ADRENO_ES3
					    u_xlat16_1.xyz = min(max(u_xlat16_1.xyz, 0.0), 1.0);
					#else
					    u_xlat16_1.xyz = clamp(u_xlat16_1.xyz, 0.0, 1.0);
					#endif
					    u_xlat0.xyz = vec3(u_xlat6) + (-u_xlat16_1.xyz);
					    u_xlat0.xyz = vec3(_Saturation) * u_xlat0.xyz + u_xlat16_1.xyz;
					    u_xlat0.xyz = log2(u_xlat0.xyz);
					    u_xlat6 = float(1.0) / _Gamma;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat6);
					    u_xlat0.xyz = exp2(u_xlat0.xyz);
					    u_xlat0.xyz = u_xlat0.xyz + _Color.xyz;
					    SV_Target0.xyz = u_xlat0.xyz;
					    SV_Target0.w = 1.0;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier02 " {
					Keywords { "ACES_OFF" "SaturN_ON" "Vignette_OFF" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					out highp vec2 vs_TEXCOORD0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	mediump vec4 _Color;
					uniform 	float _Contrast;
					uniform 	float _Gamma;
					uniform 	float _Saturation;
					uniform mediump sampler2D _MainTex;
					in highp vec2 vs_TEXCOORD0;
					layout(location = 0) out mediump vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					mediump vec3 u_xlat16_1;
					float u_xlat6;
					void main()
					{
					    u_xlat16_0.xyz = texture(_MainTex, vs_TEXCOORD0.xy).xyz;
					    u_xlat6 = dot(u_xlat16_0.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
					    u_xlat16_1.xyz = u_xlat16_0.xyz + vec3(-0.5, -0.5, -0.5);
					    u_xlat16_1.xyz = vec3(_Contrast) * u_xlat16_1.xyz + vec3(0.5, 0.5, 0.5);
					#ifdef UNITY_ADRENO_ES3
					    u_xlat16_1.xyz = min(max(u_xlat16_1.xyz, 0.0), 1.0);
					#else
					    u_xlat16_1.xyz = clamp(u_xlat16_1.xyz, 0.0, 1.0);
					#endif
					    u_xlat0.xyz = vec3(u_xlat6) + (-u_xlat16_1.xyz);
					    u_xlat0.xyz = vec3(_Saturation) * u_xlat0.xyz + u_xlat16_1.xyz;
					    u_xlat0.xyz = log2(u_xlat0.xyz);
					    u_xlat6 = float(1.0) / _Gamma;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat6);
					    u_xlat0.xyz = exp2(u_xlat0.xyz);
					    u_xlat0.xyz = u_xlat0.xyz + _Color.xyz;
					    SV_Target0.xyz = u_xlat0.xyz;
					    SV_Target0.w = 1.0;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier00 " {
					Keywords { "ACES_OFF" "SaturN_OFF" "Vignette_ON" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					varying highp vec2 vs_TEXCOORD0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
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
					uniform 	mediump vec4 _Color;
					uniform 	float _Contrast;
					uniform 	float _Gamma;
					uniform 	float _VignetteIntensity;
					uniform lowp sampler2D _MainTex;
					varying highp vec2 vs_TEXCOORD0;
					#define SV_Target0 gl_FragData[0]
					vec4 u_xlat0;
					lowp vec3 u_xlat10_0;
					mediump vec3 u_xlat16_1;
					float u_xlat2;
					float u_xlat9;
					void main()
					{
					    u_xlat10_0.xyz = texture2D(_MainTex, vs_TEXCOORD0.xy).xyz;
					    u_xlat16_1.xyz = u_xlat10_0.xyz + vec3(-0.5, -0.5, -0.5);
					    u_xlat16_1.xyz = vec3(_Contrast) * u_xlat16_1.xyz + vec3(0.5, 0.5, 0.5);
					    u_xlat16_1.xyz = clamp(u_xlat16_1.xyz, 0.0, 1.0);
					    u_xlat0.xyz = log2(u_xlat16_1.xyz);
					    u_xlat9 = float(1.0) / _Gamma;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9);
					    u_xlat0.xyz = exp2(u_xlat0.xyz);
					    u_xlat0.xyz = u_xlat0.xyz + _Color.xyz;
					    u_xlat16_1.xy = vs_TEXCOORD0.xy + vec2(-0.5, -0.5);
					    u_xlat16_1.xy = u_xlat16_1.xy + u_xlat16_1.xy;
					    u_xlat16_1.x = dot(u_xlat16_1.xy, u_xlat16_1.xy);
					    u_xlat2 = (-u_xlat16_1.x) * _VignetteIntensity + 1.0;
					    u_xlat0.w = 1.0;
					    u_xlat0 = u_xlat0 * vec4(u_xlat2);
					    SV_Target0 = u_xlat0;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier01 " {
					Keywords { "ACES_OFF" "SaturN_OFF" "Vignette_ON" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					varying highp vec2 vs_TEXCOORD0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
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
					uniform 	mediump vec4 _Color;
					uniform 	float _Contrast;
					uniform 	float _Gamma;
					uniform 	float _VignetteIntensity;
					uniform lowp sampler2D _MainTex;
					varying highp vec2 vs_TEXCOORD0;
					#define SV_Target0 gl_FragData[0]
					vec4 u_xlat0;
					lowp vec3 u_xlat10_0;
					mediump vec3 u_xlat16_1;
					float u_xlat2;
					float u_xlat9;
					void main()
					{
					    u_xlat10_0.xyz = texture2D(_MainTex, vs_TEXCOORD0.xy).xyz;
					    u_xlat16_1.xyz = u_xlat10_0.xyz + vec3(-0.5, -0.5, -0.5);
					    u_xlat16_1.xyz = vec3(_Contrast) * u_xlat16_1.xyz + vec3(0.5, 0.5, 0.5);
					    u_xlat16_1.xyz = clamp(u_xlat16_1.xyz, 0.0, 1.0);
					    u_xlat0.xyz = log2(u_xlat16_1.xyz);
					    u_xlat9 = float(1.0) / _Gamma;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9);
					    u_xlat0.xyz = exp2(u_xlat0.xyz);
					    u_xlat0.xyz = u_xlat0.xyz + _Color.xyz;
					    u_xlat16_1.xy = vs_TEXCOORD0.xy + vec2(-0.5, -0.5);
					    u_xlat16_1.xy = u_xlat16_1.xy + u_xlat16_1.xy;
					    u_xlat16_1.x = dot(u_xlat16_1.xy, u_xlat16_1.xy);
					    u_xlat2 = (-u_xlat16_1.x) * _VignetteIntensity + 1.0;
					    u_xlat0.w = 1.0;
					    u_xlat0 = u_xlat0 * vec4(u_xlat2);
					    SV_Target0 = u_xlat0;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier02 " {
					Keywords { "ACES_OFF" "SaturN_OFF" "Vignette_ON" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					varying highp vec2 vs_TEXCOORD0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
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
					uniform 	mediump vec4 _Color;
					uniform 	float _Contrast;
					uniform 	float _Gamma;
					uniform 	float _VignetteIntensity;
					uniform lowp sampler2D _MainTex;
					varying highp vec2 vs_TEXCOORD0;
					#define SV_Target0 gl_FragData[0]
					vec4 u_xlat0;
					lowp vec3 u_xlat10_0;
					mediump vec3 u_xlat16_1;
					float u_xlat2;
					float u_xlat9;
					void main()
					{
					    u_xlat10_0.xyz = texture2D(_MainTex, vs_TEXCOORD0.xy).xyz;
					    u_xlat16_1.xyz = u_xlat10_0.xyz + vec3(-0.5, -0.5, -0.5);
					    u_xlat16_1.xyz = vec3(_Contrast) * u_xlat16_1.xyz + vec3(0.5, 0.5, 0.5);
					    u_xlat16_1.xyz = clamp(u_xlat16_1.xyz, 0.0, 1.0);
					    u_xlat0.xyz = log2(u_xlat16_1.xyz);
					    u_xlat9 = float(1.0) / _Gamma;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9);
					    u_xlat0.xyz = exp2(u_xlat0.xyz);
					    u_xlat0.xyz = u_xlat0.xyz + _Color.xyz;
					    u_xlat16_1.xy = vs_TEXCOORD0.xy + vec2(-0.5, -0.5);
					    u_xlat16_1.xy = u_xlat16_1.xy + u_xlat16_1.xy;
					    u_xlat16_1.x = dot(u_xlat16_1.xy, u_xlat16_1.xy);
					    u_xlat2 = (-u_xlat16_1.x) * _VignetteIntensity + 1.0;
					    u_xlat0.w = 1.0;
					    u_xlat0 = u_xlat0 * vec4(u_xlat2);
					    SV_Target0 = u_xlat0;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier00 " {
					Keywords { "ACES_OFF" "SaturN_OFF" "Vignette_ON" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					out highp vec2 vs_TEXCOORD0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	mediump vec4 _Color;
					uniform 	float _Contrast;
					uniform 	float _Gamma;
					uniform 	float _VignetteIntensity;
					uniform mediump sampler2D _MainTex;
					in highp vec2 vs_TEXCOORD0;
					layout(location = 0) out mediump vec4 SV_Target0;
					vec4 u_xlat0;
					mediump vec3 u_xlat16_0;
					mediump vec3 u_xlat16_1;
					float u_xlat2;
					float u_xlat9;
					void main()
					{
					    u_xlat16_0.xyz = texture(_MainTex, vs_TEXCOORD0.xy).xyz;
					    u_xlat16_1.xyz = u_xlat16_0.xyz + vec3(-0.5, -0.5, -0.5);
					    u_xlat16_1.xyz = vec3(_Contrast) * u_xlat16_1.xyz + vec3(0.5, 0.5, 0.5);
					#ifdef UNITY_ADRENO_ES3
					    u_xlat16_1.xyz = min(max(u_xlat16_1.xyz, 0.0), 1.0);
					#else
					    u_xlat16_1.xyz = clamp(u_xlat16_1.xyz, 0.0, 1.0);
					#endif
					    u_xlat0.xyz = log2(u_xlat16_1.xyz);
					    u_xlat9 = float(1.0) / _Gamma;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9);
					    u_xlat0.xyz = exp2(u_xlat0.xyz);
					    u_xlat0.xyz = u_xlat0.xyz + _Color.xyz;
					    u_xlat16_1.xy = vs_TEXCOORD0.xy + vec2(-0.5, -0.5);
					    u_xlat16_1.xy = u_xlat16_1.xy + u_xlat16_1.xy;
					    u_xlat16_1.x = dot(u_xlat16_1.xy, u_xlat16_1.xy);
					    u_xlat2 = (-u_xlat16_1.x) * _VignetteIntensity + 1.0;
					    u_xlat0.w = 1.0;
					    u_xlat0 = u_xlat0 * vec4(u_xlat2);
					    SV_Target0 = u_xlat0;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier01 " {
					Keywords { "ACES_OFF" "SaturN_OFF" "Vignette_ON" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					out highp vec2 vs_TEXCOORD0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	mediump vec4 _Color;
					uniform 	float _Contrast;
					uniform 	float _Gamma;
					uniform 	float _VignetteIntensity;
					uniform mediump sampler2D _MainTex;
					in highp vec2 vs_TEXCOORD0;
					layout(location = 0) out mediump vec4 SV_Target0;
					vec4 u_xlat0;
					mediump vec3 u_xlat16_0;
					mediump vec3 u_xlat16_1;
					float u_xlat2;
					float u_xlat9;
					void main()
					{
					    u_xlat16_0.xyz = texture(_MainTex, vs_TEXCOORD0.xy).xyz;
					    u_xlat16_1.xyz = u_xlat16_0.xyz + vec3(-0.5, -0.5, -0.5);
					    u_xlat16_1.xyz = vec3(_Contrast) * u_xlat16_1.xyz + vec3(0.5, 0.5, 0.5);
					#ifdef UNITY_ADRENO_ES3
					    u_xlat16_1.xyz = min(max(u_xlat16_1.xyz, 0.0), 1.0);
					#else
					    u_xlat16_1.xyz = clamp(u_xlat16_1.xyz, 0.0, 1.0);
					#endif
					    u_xlat0.xyz = log2(u_xlat16_1.xyz);
					    u_xlat9 = float(1.0) / _Gamma;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9);
					    u_xlat0.xyz = exp2(u_xlat0.xyz);
					    u_xlat0.xyz = u_xlat0.xyz + _Color.xyz;
					    u_xlat16_1.xy = vs_TEXCOORD0.xy + vec2(-0.5, -0.5);
					    u_xlat16_1.xy = u_xlat16_1.xy + u_xlat16_1.xy;
					    u_xlat16_1.x = dot(u_xlat16_1.xy, u_xlat16_1.xy);
					    u_xlat2 = (-u_xlat16_1.x) * _VignetteIntensity + 1.0;
					    u_xlat0.w = 1.0;
					    u_xlat0 = u_xlat0 * vec4(u_xlat2);
					    SV_Target0 = u_xlat0;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier02 " {
					Keywords { "ACES_OFF" "SaturN_OFF" "Vignette_ON" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					out highp vec2 vs_TEXCOORD0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	mediump vec4 _Color;
					uniform 	float _Contrast;
					uniform 	float _Gamma;
					uniform 	float _VignetteIntensity;
					uniform mediump sampler2D _MainTex;
					in highp vec2 vs_TEXCOORD0;
					layout(location = 0) out mediump vec4 SV_Target0;
					vec4 u_xlat0;
					mediump vec3 u_xlat16_0;
					mediump vec3 u_xlat16_1;
					float u_xlat2;
					float u_xlat9;
					void main()
					{
					    u_xlat16_0.xyz = texture(_MainTex, vs_TEXCOORD0.xy).xyz;
					    u_xlat16_1.xyz = u_xlat16_0.xyz + vec3(-0.5, -0.5, -0.5);
					    u_xlat16_1.xyz = vec3(_Contrast) * u_xlat16_1.xyz + vec3(0.5, 0.5, 0.5);
					#ifdef UNITY_ADRENO_ES3
					    u_xlat16_1.xyz = min(max(u_xlat16_1.xyz, 0.0), 1.0);
					#else
					    u_xlat16_1.xyz = clamp(u_xlat16_1.xyz, 0.0, 1.0);
					#endif
					    u_xlat0.xyz = log2(u_xlat16_1.xyz);
					    u_xlat9 = float(1.0) / _Gamma;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat9);
					    u_xlat0.xyz = exp2(u_xlat0.xyz);
					    u_xlat0.xyz = u_xlat0.xyz + _Color.xyz;
					    u_xlat16_1.xy = vs_TEXCOORD0.xy + vec2(-0.5, -0.5);
					    u_xlat16_1.xy = u_xlat16_1.xy + u_xlat16_1.xy;
					    u_xlat16_1.x = dot(u_xlat16_1.xy, u_xlat16_1.xy);
					    u_xlat2 = (-u_xlat16_1.x) * _VignetteIntensity + 1.0;
					    u_xlat0.w = 1.0;
					    u_xlat0 = u_xlat0 * vec4(u_xlat2);
					    SV_Target0 = u_xlat0;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier00 " {
					Keywords { "ACES_OFF" "SaturN_OFF" "Vignette_OFF" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					varying highp vec2 vs_TEXCOORD0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
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
					uniform 	mediump vec4 _Color;
					uniform 	float _Contrast;
					uniform 	float _Gamma;
					uniform lowp sampler2D _MainTex;
					varying highp vec2 vs_TEXCOORD0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					mediump vec3 u_xlat16_1;
					float u_xlat6;
					void main()
					{
					    u_xlat10_0.xyz = texture2D(_MainTex, vs_TEXCOORD0.xy).xyz;
					    u_xlat16_1.xyz = u_xlat10_0.xyz + vec3(-0.5, -0.5, -0.5);
					    u_xlat16_1.xyz = vec3(_Contrast) * u_xlat16_1.xyz + vec3(0.5, 0.5, 0.5);
					    u_xlat16_1.xyz = clamp(u_xlat16_1.xyz, 0.0, 1.0);
					    u_xlat0.xyz = log2(u_xlat16_1.xyz);
					    u_xlat6 = float(1.0) / _Gamma;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat6);
					    u_xlat0.xyz = exp2(u_xlat0.xyz);
					    u_xlat0.xyz = u_xlat0.xyz + _Color.xyz;
					    SV_Target0.xyz = u_xlat0.xyz;
					    SV_Target0.w = 1.0;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier01 " {
					Keywords { "ACES_OFF" "SaturN_OFF" "Vignette_OFF" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					varying highp vec2 vs_TEXCOORD0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
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
					uniform 	mediump vec4 _Color;
					uniform 	float _Contrast;
					uniform 	float _Gamma;
					uniform lowp sampler2D _MainTex;
					varying highp vec2 vs_TEXCOORD0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					mediump vec3 u_xlat16_1;
					float u_xlat6;
					void main()
					{
					    u_xlat10_0.xyz = texture2D(_MainTex, vs_TEXCOORD0.xy).xyz;
					    u_xlat16_1.xyz = u_xlat10_0.xyz + vec3(-0.5, -0.5, -0.5);
					    u_xlat16_1.xyz = vec3(_Contrast) * u_xlat16_1.xyz + vec3(0.5, 0.5, 0.5);
					    u_xlat16_1.xyz = clamp(u_xlat16_1.xyz, 0.0, 1.0);
					    u_xlat0.xyz = log2(u_xlat16_1.xyz);
					    u_xlat6 = float(1.0) / _Gamma;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat6);
					    u_xlat0.xyz = exp2(u_xlat0.xyz);
					    u_xlat0.xyz = u_xlat0.xyz + _Color.xyz;
					    SV_Target0.xyz = u_xlat0.xyz;
					    SV_Target0.w = 1.0;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier02 " {
					Keywords { "ACES_OFF" "SaturN_OFF" "Vignette_OFF" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					attribute highp vec4 in_POSITION0;
					attribute highp vec2 in_TEXCOORD0;
					varying highp vec2 vs_TEXCOORD0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
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
					uniform 	mediump vec4 _Color;
					uniform 	float _Contrast;
					uniform 	float _Gamma;
					uniform lowp sampler2D _MainTex;
					varying highp vec2 vs_TEXCOORD0;
					#define SV_Target0 gl_FragData[0]
					vec3 u_xlat0;
					lowp vec3 u_xlat10_0;
					mediump vec3 u_xlat16_1;
					float u_xlat6;
					void main()
					{
					    u_xlat10_0.xyz = texture2D(_MainTex, vs_TEXCOORD0.xy).xyz;
					    u_xlat16_1.xyz = u_xlat10_0.xyz + vec3(-0.5, -0.5, -0.5);
					    u_xlat16_1.xyz = vec3(_Contrast) * u_xlat16_1.xyz + vec3(0.5, 0.5, 0.5);
					    u_xlat16_1.xyz = clamp(u_xlat16_1.xyz, 0.0, 1.0);
					    u_xlat0.xyz = log2(u_xlat16_1.xyz);
					    u_xlat6 = float(1.0) / _Gamma;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat6);
					    u_xlat0.xyz = exp2(u_xlat0.xyz);
					    u_xlat0.xyz = u_xlat0.xyz + _Color.xyz;
					    SV_Target0.xyz = u_xlat0.xyz;
					    SV_Target0.w = 1.0;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier00 " {
					Keywords { "ACES_OFF" "SaturN_OFF" "Vignette_OFF" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					out highp vec2 vs_TEXCOORD0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	mediump vec4 _Color;
					uniform 	float _Contrast;
					uniform 	float _Gamma;
					uniform mediump sampler2D _MainTex;
					in highp vec2 vs_TEXCOORD0;
					layout(location = 0) out mediump vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					mediump vec3 u_xlat16_1;
					float u_xlat6;
					void main()
					{
					    u_xlat16_0.xyz = texture(_MainTex, vs_TEXCOORD0.xy).xyz;
					    u_xlat16_1.xyz = u_xlat16_0.xyz + vec3(-0.5, -0.5, -0.5);
					    u_xlat16_1.xyz = vec3(_Contrast) * u_xlat16_1.xyz + vec3(0.5, 0.5, 0.5);
					#ifdef UNITY_ADRENO_ES3
					    u_xlat16_1.xyz = min(max(u_xlat16_1.xyz, 0.0), 1.0);
					#else
					    u_xlat16_1.xyz = clamp(u_xlat16_1.xyz, 0.0, 1.0);
					#endif
					    u_xlat0.xyz = log2(u_xlat16_1.xyz);
					    u_xlat6 = float(1.0) / _Gamma;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat6);
					    u_xlat0.xyz = exp2(u_xlat0.xyz);
					    u_xlat0.xyz = u_xlat0.xyz + _Color.xyz;
					    SV_Target0.xyz = u_xlat0.xyz;
					    SV_Target0.w = 1.0;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier01 " {
					Keywords { "ACES_OFF" "SaturN_OFF" "Vignette_OFF" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					out highp vec2 vs_TEXCOORD0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	mediump vec4 _Color;
					uniform 	float _Contrast;
					uniform 	float _Gamma;
					uniform mediump sampler2D _MainTex;
					in highp vec2 vs_TEXCOORD0;
					layout(location = 0) out mediump vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					mediump vec3 u_xlat16_1;
					float u_xlat6;
					void main()
					{
					    u_xlat16_0.xyz = texture(_MainTex, vs_TEXCOORD0.xy).xyz;
					    u_xlat16_1.xyz = u_xlat16_0.xyz + vec3(-0.5, -0.5, -0.5);
					    u_xlat16_1.xyz = vec3(_Contrast) * u_xlat16_1.xyz + vec3(0.5, 0.5, 0.5);
					#ifdef UNITY_ADRENO_ES3
					    u_xlat16_1.xyz = min(max(u_xlat16_1.xyz, 0.0), 1.0);
					#else
					    u_xlat16_1.xyz = clamp(u_xlat16_1.xyz, 0.0, 1.0);
					#endif
					    u_xlat0.xyz = log2(u_xlat16_1.xyz);
					    u_xlat6 = float(1.0) / _Gamma;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat6);
					    u_xlat0.xyz = exp2(u_xlat0.xyz);
					    u_xlat0.xyz = u_xlat0.xyz + _Color.xyz;
					    SV_Target0.xyz = u_xlat0.xyz;
					    SV_Target0.w = 1.0;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier02 " {
					Keywords { "ACES_OFF" "SaturN_OFF" "Vignette_OFF" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					in highp vec4 in_POSITION0;
					in highp vec2 in_TEXCOORD0;
					out highp vec2 vs_TEXCOORD0;
					vec4 u_xlat0;
					vec4 u_xlat1;
					void main()
					{
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
					    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
					    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
					    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
					    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
					    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
					    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	mediump vec4 _Color;
					uniform 	float _Contrast;
					uniform 	float _Gamma;
					uniform mediump sampler2D _MainTex;
					in highp vec2 vs_TEXCOORD0;
					layout(location = 0) out mediump vec4 SV_Target0;
					vec3 u_xlat0;
					mediump vec3 u_xlat16_0;
					mediump vec3 u_xlat16_1;
					float u_xlat6;
					void main()
					{
					    u_xlat16_0.xyz = texture(_MainTex, vs_TEXCOORD0.xy).xyz;
					    u_xlat16_1.xyz = u_xlat16_0.xyz + vec3(-0.5, -0.5, -0.5);
					    u_xlat16_1.xyz = vec3(_Contrast) * u_xlat16_1.xyz + vec3(0.5, 0.5, 0.5);
					#ifdef UNITY_ADRENO_ES3
					    u_xlat16_1.xyz = min(max(u_xlat16_1.xyz, 0.0), 1.0);
					#else
					    u_xlat16_1.xyz = clamp(u_xlat16_1.xyz, 0.0, 1.0);
					#endif
					    u_xlat0.xyz = log2(u_xlat16_1.xyz);
					    u_xlat6 = float(1.0) / _Gamma;
					    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat6);
					    u_xlat0.xyz = exp2(u_xlat0.xyz);
					    u_xlat0.xyz = u_xlat0.xyz + _Color.xyz;
					    SV_Target0.xyz = u_xlat0.xyz;
					    SV_Target0.w = 1.0;
					    return;
					}
					
					#endif"
				}
			}
			Program "fp" {
				SubProgram "gles hw_tier00 " {
					Keywords { "ACES_ON" "SaturN_ON" "Vignette_ON" }
					"!!GLES"
				}
				SubProgram "gles hw_tier01 " {
					Keywords { "ACES_ON" "SaturN_ON" "Vignette_ON" }
					"!!GLES"
				}
				SubProgram "gles hw_tier02 " {
					Keywords { "ACES_ON" "SaturN_ON" "Vignette_ON" }
					"!!GLES"
				}
				SubProgram "gles3 hw_tier00 " {
					Keywords { "ACES_ON" "SaturN_ON" "Vignette_ON" }
					"!!GLES3"
				}
				SubProgram "gles3 hw_tier01 " {
					Keywords { "ACES_ON" "SaturN_ON" "Vignette_ON" }
					"!!GLES3"
				}
				SubProgram "gles3 hw_tier02 " {
					Keywords { "ACES_ON" "SaturN_ON" "Vignette_ON" }
					"!!GLES3"
				}
				SubProgram "gles hw_tier00 " {
					Keywords { "ACES_ON" "SaturN_ON" "Vignette_OFF" }
					"!!GLES"
				}
				SubProgram "gles hw_tier01 " {
					Keywords { "ACES_ON" "SaturN_ON" "Vignette_OFF" }
					"!!GLES"
				}
				SubProgram "gles hw_tier02 " {
					Keywords { "ACES_ON" "SaturN_ON" "Vignette_OFF" }
					"!!GLES"
				}
				SubProgram "gles3 hw_tier00 " {
					Keywords { "ACES_ON" "SaturN_ON" "Vignette_OFF" }
					"!!GLES3"
				}
				SubProgram "gles3 hw_tier01 " {
					Keywords { "ACES_ON" "SaturN_ON" "Vignette_OFF" }
					"!!GLES3"
				}
				SubProgram "gles3 hw_tier02 " {
					Keywords { "ACES_ON" "SaturN_ON" "Vignette_OFF" }
					"!!GLES3"
				}
				SubProgram "gles hw_tier00 " {
					Keywords { "ACES_ON" "SaturN_OFF" "Vignette_ON" }
					"!!GLES"
				}
				SubProgram "gles hw_tier01 " {
					Keywords { "ACES_ON" "SaturN_OFF" "Vignette_ON" }
					"!!GLES"
				}
				SubProgram "gles hw_tier02 " {
					Keywords { "ACES_ON" "SaturN_OFF" "Vignette_ON" }
					"!!GLES"
				}
				SubProgram "gles3 hw_tier00 " {
					Keywords { "ACES_ON" "SaturN_OFF" "Vignette_ON" }
					"!!GLES3"
				}
				SubProgram "gles3 hw_tier01 " {
					Keywords { "ACES_ON" "SaturN_OFF" "Vignette_ON" }
					"!!GLES3"
				}
				SubProgram "gles3 hw_tier02 " {
					Keywords { "ACES_ON" "SaturN_OFF" "Vignette_ON" }
					"!!GLES3"
				}
				SubProgram "gles hw_tier00 " {
					Keywords { "ACES_ON" "SaturN_OFF" "Vignette_OFF" }
					"!!GLES"
				}
				SubProgram "gles hw_tier01 " {
					Keywords { "ACES_ON" "SaturN_OFF" "Vignette_OFF" }
					"!!GLES"
				}
				SubProgram "gles hw_tier02 " {
					Keywords { "ACES_ON" "SaturN_OFF" "Vignette_OFF" }
					"!!GLES"
				}
				SubProgram "gles3 hw_tier00 " {
					Keywords { "ACES_ON" "SaturN_OFF" "Vignette_OFF" }
					"!!GLES3"
				}
				SubProgram "gles3 hw_tier01 " {
					Keywords { "ACES_ON" "SaturN_OFF" "Vignette_OFF" }
					"!!GLES3"
				}
				SubProgram "gles3 hw_tier02 " {
					Keywords { "ACES_ON" "SaturN_OFF" "Vignette_OFF" }
					"!!GLES3"
				}
				SubProgram "gles hw_tier00 " {
					Keywords { "ACES_OFF" "SaturN_ON" "Vignette_ON" }
					"!!GLES"
				}
				SubProgram "gles hw_tier01 " {
					Keywords { "ACES_OFF" "SaturN_ON" "Vignette_ON" }
					"!!GLES"
				}
				SubProgram "gles hw_tier02 " {
					Keywords { "ACES_OFF" "SaturN_ON" "Vignette_ON" }
					"!!GLES"
				}
				SubProgram "gles3 hw_tier00 " {
					Keywords { "ACES_OFF" "SaturN_ON" "Vignette_ON" }
					"!!GLES3"
				}
				SubProgram "gles3 hw_tier01 " {
					Keywords { "ACES_OFF" "SaturN_ON" "Vignette_ON" }
					"!!GLES3"
				}
				SubProgram "gles3 hw_tier02 " {
					Keywords { "ACES_OFF" "SaturN_ON" "Vignette_ON" }
					"!!GLES3"
				}
				SubProgram "gles hw_tier00 " {
					Keywords { "ACES_OFF" "SaturN_ON" "Vignette_OFF" }
					"!!GLES"
				}
				SubProgram "gles hw_tier01 " {
					Keywords { "ACES_OFF" "SaturN_ON" "Vignette_OFF" }
					"!!GLES"
				}
				SubProgram "gles hw_tier02 " {
					Keywords { "ACES_OFF" "SaturN_ON" "Vignette_OFF" }
					"!!GLES"
				}
				SubProgram "gles3 hw_tier00 " {
					Keywords { "ACES_OFF" "SaturN_ON" "Vignette_OFF" }
					"!!GLES3"
				}
				SubProgram "gles3 hw_tier01 " {
					Keywords { "ACES_OFF" "SaturN_ON" "Vignette_OFF" }
					"!!GLES3"
				}
				SubProgram "gles3 hw_tier02 " {
					Keywords { "ACES_OFF" "SaturN_ON" "Vignette_OFF" }
					"!!GLES3"
				}
				SubProgram "gles hw_tier00 " {
					Keywords { "ACES_OFF" "SaturN_OFF" "Vignette_ON" }
					"!!GLES"
				}
				SubProgram "gles hw_tier01 " {
					Keywords { "ACES_OFF" "SaturN_OFF" "Vignette_ON" }
					"!!GLES"
				}
				SubProgram "gles hw_tier02 " {
					Keywords { "ACES_OFF" "SaturN_OFF" "Vignette_ON" }
					"!!GLES"
				}
				SubProgram "gles3 hw_tier00 " {
					Keywords { "ACES_OFF" "SaturN_OFF" "Vignette_ON" }
					"!!GLES3"
				}
				SubProgram "gles3 hw_tier01 " {
					Keywords { "ACES_OFF" "SaturN_OFF" "Vignette_ON" }
					"!!GLES3"
				}
				SubProgram "gles3 hw_tier02 " {
					Keywords { "ACES_OFF" "SaturN_OFF" "Vignette_ON" }
					"!!GLES3"
				}
				SubProgram "gles hw_tier00 " {
					Keywords { "ACES_OFF" "SaturN_OFF" "Vignette_OFF" }
					"!!GLES"
				}
				SubProgram "gles hw_tier01 " {
					Keywords { "ACES_OFF" "SaturN_OFF" "Vignette_OFF" }
					"!!GLES"
				}
				SubProgram "gles hw_tier02 " {
					Keywords { "ACES_OFF" "SaturN_OFF" "Vignette_OFF" }
					"!!GLES"
				}
				SubProgram "gles3 hw_tier00 " {
					Keywords { "ACES_OFF" "SaturN_OFF" "Vignette_OFF" }
					"!!GLES3"
				}
				SubProgram "gles3 hw_tier01 " {
					Keywords { "ACES_OFF" "SaturN_OFF" "Vignette_OFF" }
					"!!GLES3"
				}
				SubProgram "gles3 hw_tier02 " {
					Keywords { "ACES_OFF" "SaturN_OFF" "Vignette_OFF" }
					"!!GLES3"
				}
			}
		}
	}
}