Shader "UI/Default-SoftMask" {
	Properties {
		[PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
		_Color ("Tint", Vector) = (1,1,1,1)
		_StencilComp ("Stencil Comparison", Float) = 8
		_Stencil ("Stencil ID", Float) = 0
		_StencilOp ("Stencil Operation", Float) = 0
		_StencilWriteMask ("Stencil Write Mask", Float) = 255
		_StencilReadMask ("Stencil Read Mask", Float) = 255
		_ColorMask ("Color Mask", Float) = 15
		[Toggle(UNITY_UI_ALPHACLIP)] _UseUIAlphaClip ("Use Alpha Clip", Float) = 0
	}
	SubShader {
		Tags { "CanUseSpriteAtlas" = "true" "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
		Pass {
			Name "Default"
			Tags { "CanUseSpriteAtlas" = "true" "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			ColorMask 0 -1
			ZWrite Off
			Cull Off
			Stencil {
				ReadMask 0
				WriteMask 0
				Comp Disabled
				Pass Keep
				Fail Keep
				ZFail Keep
			}
			GpuProgramID 60803
			Program "vp" {
				SubProgram "gles hw_tier00 " {
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	mediump vec4 _Color;
					uniform 	vec4 _MainTex_ST;
					attribute highp vec4 in_POSITION0;
					attribute highp vec4 in_COLOR0;
					attribute highp vec2 in_TEXCOORD0;
					varying mediump vec4 vs_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_TEXCOORD1;
					vec4 u_xlat0;
					vec4 u_xlat1;
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
					    u_xlat0 = in_COLOR0 * _Color;
					    vs_COLOR0 = u_xlat0;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    vs_TEXCOORD1 = in_POSITION0;
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
					uniform 	vec4 _ScreenParams;
					uniform 	float _Stencil;
					uniform 	mediump vec4 _MaskInteraction;
					uniform 	mediump vec4 _TextureSampleAdd;
					uniform 	vec4 _ClipRect;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _SoftMaskTex;
					varying mediump vec4 vs_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_TEXCOORD1;
					#define SV_Target0 gl_FragData[0]
					vec4 u_xlat0;
					bvec4 u_xlatb0;
					vec4 u_xlat1;
					lowp vec4 u_xlat10_1;
					bvec4 u_xlatb1;
					vec4 u_xlat2;
					lowp vec4 u_xlat10_2;
					vec4 u_xlat3;
					bvec4 u_xlatb3;
					vec2 u_xlat4;
					bvec2 u_xlatb4;
					void main()
					{
					vec4 hlslcc_FragCoord = vec4(gl_FragCoord.xyz, 1.0/gl_FragCoord.w);
					    u_xlatb0 = greaterThanEqual(_MaskInteraction.xxyy, vec4(1.0, 2.0, 1.0, 2.0));
					    u_xlat0 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb0));
					    u_xlatb1 = greaterThanEqual(vec4(_Stencil), vec4(1.0, 3.0, 7.0, 15.0));
					    u_xlat1 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb1));
					    u_xlat0 = u_xlat0 * u_xlat1.xxyy;
					    u_xlat1.xy = hlslcc_FragCoord.xy / _ScreenParams.xy;
					    u_xlat10_2 = texture2D(_SoftMaskTex, u_xlat1.xy);
					    u_xlat2 = u_xlat10_2 + vec4(-1.0, -1.0, -1.0, -1.0);
					    u_xlat0.xz = u_xlat0.xz * u_xlat2.xy + vec2(1.0, 1.0);
					    u_xlat1.xy = u_xlat0.xz * vec2(-2.0, -2.0) + vec2(1.0, 1.0);
					    u_xlat0.xy = u_xlat0.yw * u_xlat1.xy + u_xlat0.xz;
					    u_xlat0.x = u_xlat0.y * u_xlat0.x;
					    u_xlatb3 = greaterThanEqual(_MaskInteraction.zzww, vec4(1.0, 2.0, 1.0, 2.0));
					    u_xlat3 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb3));
					    u_xlat1 = u_xlat1.zzww * u_xlat3;
					    u_xlat4.xy = u_xlat1.xz * u_xlat2.zw + vec2(1.0, 1.0);
					    u_xlat1.xz = u_xlat4.xy * vec2(-2.0, -2.0) + vec2(1.0, 1.0);
					    u_xlat4.xy = u_xlat1.yw * u_xlat1.xz + u_xlat4.xy;
					    u_xlat0.x = u_xlat4.x * u_xlat0.x;
					    u_xlat0.x = u_xlat4.y * u_xlat0.x;
					    u_xlatb4.xy = greaterThanEqual(vs_TEXCOORD1.xyxx, _ClipRect.xyxx).xy;
					    u_xlat4.xy = mix(vec2(0.0, 0.0), vec2(1.0, 1.0), vec2(u_xlatb4.xy));
					    u_xlatb1.xy = greaterThanEqual(_ClipRect.zwzz, vs_TEXCOORD1.xyxx).xy;
					    u_xlat1.xy = mix(vec2(0.0, 0.0), vec2(1.0, 1.0), vec2(u_xlatb1.xy));
					    u_xlat4.xy = u_xlat4.xy * u_xlat1.xy;
					    u_xlat4.x = u_xlat4.y * u_xlat4.x;
					    u_xlat10_1 = texture2D(_MainTex, vs_TEXCOORD0.xy);
					    u_xlat1 = u_xlat10_1 + _TextureSampleAdd;
					    u_xlat1 = u_xlat1 * vs_COLOR0;
					    u_xlat4.x = u_xlat4.x * u_xlat1.w;
					    u_xlat1.w = u_xlat0.x * u_xlat4.x;
					    SV_Target0 = u_xlat1;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier01 " {
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	mediump vec4 _Color;
					uniform 	vec4 _MainTex_ST;
					attribute highp vec4 in_POSITION0;
					attribute highp vec4 in_COLOR0;
					attribute highp vec2 in_TEXCOORD0;
					varying mediump vec4 vs_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_TEXCOORD1;
					vec4 u_xlat0;
					vec4 u_xlat1;
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
					    u_xlat0 = in_COLOR0 * _Color;
					    vs_COLOR0 = u_xlat0;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    vs_TEXCOORD1 = in_POSITION0;
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
					uniform 	vec4 _ScreenParams;
					uniform 	float _Stencil;
					uniform 	mediump vec4 _MaskInteraction;
					uniform 	mediump vec4 _TextureSampleAdd;
					uniform 	vec4 _ClipRect;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _SoftMaskTex;
					varying mediump vec4 vs_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_TEXCOORD1;
					#define SV_Target0 gl_FragData[0]
					vec4 u_xlat0;
					bvec4 u_xlatb0;
					vec4 u_xlat1;
					lowp vec4 u_xlat10_1;
					bvec4 u_xlatb1;
					vec4 u_xlat2;
					lowp vec4 u_xlat10_2;
					vec4 u_xlat3;
					bvec4 u_xlatb3;
					vec2 u_xlat4;
					bvec2 u_xlatb4;
					void main()
					{
					vec4 hlslcc_FragCoord = vec4(gl_FragCoord.xyz, 1.0/gl_FragCoord.w);
					    u_xlatb0 = greaterThanEqual(_MaskInteraction.xxyy, vec4(1.0, 2.0, 1.0, 2.0));
					    u_xlat0 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb0));
					    u_xlatb1 = greaterThanEqual(vec4(_Stencil), vec4(1.0, 3.0, 7.0, 15.0));
					    u_xlat1 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb1));
					    u_xlat0 = u_xlat0 * u_xlat1.xxyy;
					    u_xlat1.xy = hlslcc_FragCoord.xy / _ScreenParams.xy;
					    u_xlat10_2 = texture2D(_SoftMaskTex, u_xlat1.xy);
					    u_xlat2 = u_xlat10_2 + vec4(-1.0, -1.0, -1.0, -1.0);
					    u_xlat0.xz = u_xlat0.xz * u_xlat2.xy + vec2(1.0, 1.0);
					    u_xlat1.xy = u_xlat0.xz * vec2(-2.0, -2.0) + vec2(1.0, 1.0);
					    u_xlat0.xy = u_xlat0.yw * u_xlat1.xy + u_xlat0.xz;
					    u_xlat0.x = u_xlat0.y * u_xlat0.x;
					    u_xlatb3 = greaterThanEqual(_MaskInteraction.zzww, vec4(1.0, 2.0, 1.0, 2.0));
					    u_xlat3 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb3));
					    u_xlat1 = u_xlat1.zzww * u_xlat3;
					    u_xlat4.xy = u_xlat1.xz * u_xlat2.zw + vec2(1.0, 1.0);
					    u_xlat1.xz = u_xlat4.xy * vec2(-2.0, -2.0) + vec2(1.0, 1.0);
					    u_xlat4.xy = u_xlat1.yw * u_xlat1.xz + u_xlat4.xy;
					    u_xlat0.x = u_xlat4.x * u_xlat0.x;
					    u_xlat0.x = u_xlat4.y * u_xlat0.x;
					    u_xlatb4.xy = greaterThanEqual(vs_TEXCOORD1.xyxx, _ClipRect.xyxx).xy;
					    u_xlat4.xy = mix(vec2(0.0, 0.0), vec2(1.0, 1.0), vec2(u_xlatb4.xy));
					    u_xlatb1.xy = greaterThanEqual(_ClipRect.zwzz, vs_TEXCOORD1.xyxx).xy;
					    u_xlat1.xy = mix(vec2(0.0, 0.0), vec2(1.0, 1.0), vec2(u_xlatb1.xy));
					    u_xlat4.xy = u_xlat4.xy * u_xlat1.xy;
					    u_xlat4.x = u_xlat4.y * u_xlat4.x;
					    u_xlat10_1 = texture2D(_MainTex, vs_TEXCOORD0.xy);
					    u_xlat1 = u_xlat10_1 + _TextureSampleAdd;
					    u_xlat1 = u_xlat1 * vs_COLOR0;
					    u_xlat4.x = u_xlat4.x * u_xlat1.w;
					    u_xlat1.w = u_xlat0.x * u_xlat4.x;
					    SV_Target0 = u_xlat1;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier02 " {
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	mediump vec4 _Color;
					uniform 	vec4 _MainTex_ST;
					attribute highp vec4 in_POSITION0;
					attribute highp vec4 in_COLOR0;
					attribute highp vec2 in_TEXCOORD0;
					varying mediump vec4 vs_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_TEXCOORD1;
					vec4 u_xlat0;
					vec4 u_xlat1;
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
					    u_xlat0 = in_COLOR0 * _Color;
					    vs_COLOR0 = u_xlat0;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    vs_TEXCOORD1 = in_POSITION0;
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
					uniform 	vec4 _ScreenParams;
					uniform 	float _Stencil;
					uniform 	mediump vec4 _MaskInteraction;
					uniform 	mediump vec4 _TextureSampleAdd;
					uniform 	vec4 _ClipRect;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _SoftMaskTex;
					varying mediump vec4 vs_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_TEXCOORD1;
					#define SV_Target0 gl_FragData[0]
					vec4 u_xlat0;
					bvec4 u_xlatb0;
					vec4 u_xlat1;
					lowp vec4 u_xlat10_1;
					bvec4 u_xlatb1;
					vec4 u_xlat2;
					lowp vec4 u_xlat10_2;
					vec4 u_xlat3;
					bvec4 u_xlatb3;
					vec2 u_xlat4;
					bvec2 u_xlatb4;
					void main()
					{
					vec4 hlslcc_FragCoord = vec4(gl_FragCoord.xyz, 1.0/gl_FragCoord.w);
					    u_xlatb0 = greaterThanEqual(_MaskInteraction.xxyy, vec4(1.0, 2.0, 1.0, 2.0));
					    u_xlat0 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb0));
					    u_xlatb1 = greaterThanEqual(vec4(_Stencil), vec4(1.0, 3.0, 7.0, 15.0));
					    u_xlat1 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb1));
					    u_xlat0 = u_xlat0 * u_xlat1.xxyy;
					    u_xlat1.xy = hlslcc_FragCoord.xy / _ScreenParams.xy;
					    u_xlat10_2 = texture2D(_SoftMaskTex, u_xlat1.xy);
					    u_xlat2 = u_xlat10_2 + vec4(-1.0, -1.0, -1.0, -1.0);
					    u_xlat0.xz = u_xlat0.xz * u_xlat2.xy + vec2(1.0, 1.0);
					    u_xlat1.xy = u_xlat0.xz * vec2(-2.0, -2.0) + vec2(1.0, 1.0);
					    u_xlat0.xy = u_xlat0.yw * u_xlat1.xy + u_xlat0.xz;
					    u_xlat0.x = u_xlat0.y * u_xlat0.x;
					    u_xlatb3 = greaterThanEqual(_MaskInteraction.zzww, vec4(1.0, 2.0, 1.0, 2.0));
					    u_xlat3 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb3));
					    u_xlat1 = u_xlat1.zzww * u_xlat3;
					    u_xlat4.xy = u_xlat1.xz * u_xlat2.zw + vec2(1.0, 1.0);
					    u_xlat1.xz = u_xlat4.xy * vec2(-2.0, -2.0) + vec2(1.0, 1.0);
					    u_xlat4.xy = u_xlat1.yw * u_xlat1.xz + u_xlat4.xy;
					    u_xlat0.x = u_xlat4.x * u_xlat0.x;
					    u_xlat0.x = u_xlat4.y * u_xlat0.x;
					    u_xlatb4.xy = greaterThanEqual(vs_TEXCOORD1.xyxx, _ClipRect.xyxx).xy;
					    u_xlat4.xy = mix(vec2(0.0, 0.0), vec2(1.0, 1.0), vec2(u_xlatb4.xy));
					    u_xlatb1.xy = greaterThanEqual(_ClipRect.zwzz, vs_TEXCOORD1.xyxx).xy;
					    u_xlat1.xy = mix(vec2(0.0, 0.0), vec2(1.0, 1.0), vec2(u_xlatb1.xy));
					    u_xlat4.xy = u_xlat4.xy * u_xlat1.xy;
					    u_xlat4.x = u_xlat4.y * u_xlat4.x;
					    u_xlat10_1 = texture2D(_MainTex, vs_TEXCOORD0.xy);
					    u_xlat1 = u_xlat10_1 + _TextureSampleAdd;
					    u_xlat1 = u_xlat1 * vs_COLOR0;
					    u_xlat4.x = u_xlat4.x * u_xlat1.w;
					    u_xlat1.w = u_xlat0.x * u_xlat4.x;
					    SV_Target0 = u_xlat1;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier00 " {
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	mediump vec4 _Color;
					uniform 	vec4 _MainTex_ST;
					in highp vec4 in_POSITION0;
					in highp vec4 in_COLOR0;
					in highp vec2 in_TEXCOORD0;
					out mediump vec4 vs_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp vec4 vs_TEXCOORD1;
					vec4 u_xlat0;
					vec4 u_xlat1;
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
					    u_xlat0 = in_COLOR0 * _Color;
					    vs_COLOR0 = u_xlat0;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    vs_TEXCOORD1 = in_POSITION0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _ScreenParams;
					uniform 	float _Stencil;
					uniform 	mediump vec4 _MaskInteraction;
					uniform 	mediump vec4 _TextureSampleAdd;
					uniform 	vec4 _ClipRect;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _SoftMaskTex;
					in mediump vec4 vs_COLOR0;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_TEXCOORD1;
					layout(location = 0) out mediump vec4 SV_Target0;
					vec4 u_xlat0;
					bvec4 u_xlatb0;
					vec4 u_xlat1;
					mediump vec4 u_xlat16_1;
					bvec4 u_xlatb1;
					vec4 u_xlat2;
					mediump vec4 u_xlat16_2;
					vec4 u_xlat3;
					bvec4 u_xlatb3;
					vec2 u_xlat4;
					bvec2 u_xlatb4;
					void main()
					{
					vec4 hlslcc_FragCoord = vec4(gl_FragCoord.xyz, 1.0/gl_FragCoord.w);
					    u_xlatb0 = greaterThanEqual(_MaskInteraction.xxyy, vec4(1.0, 2.0, 1.0, 2.0));
					    u_xlat0 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb0));
					    u_xlatb1 = greaterThanEqual(vec4(_Stencil), vec4(1.0, 3.0, 7.0, 15.0));
					    u_xlat1 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb1));
					    u_xlat0 = u_xlat0 * u_xlat1.xxyy;
					    u_xlat1.xy = hlslcc_FragCoord.xy / _ScreenParams.xy;
					    u_xlat16_2 = texture(_SoftMaskTex, u_xlat1.xy);
					    u_xlat2 = u_xlat16_2 + vec4(-1.0, -1.0, -1.0, -1.0);
					    u_xlat0.xz = u_xlat0.xz * u_xlat2.xy + vec2(1.0, 1.0);
					    u_xlat1.xy = u_xlat0.xz * vec2(-2.0, -2.0) + vec2(1.0, 1.0);
					    u_xlat0.xy = u_xlat0.yw * u_xlat1.xy + u_xlat0.xz;
					    u_xlat0.x = u_xlat0.y * u_xlat0.x;
					    u_xlatb3 = greaterThanEqual(_MaskInteraction.zzww, vec4(1.0, 2.0, 1.0, 2.0));
					    u_xlat3 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb3));
					    u_xlat1 = u_xlat1.zzww * u_xlat3;
					    u_xlat4.xy = u_xlat1.xz * u_xlat2.zw + vec2(1.0, 1.0);
					    u_xlat1.xz = u_xlat4.xy * vec2(-2.0, -2.0) + vec2(1.0, 1.0);
					    u_xlat4.xy = u_xlat1.yw * u_xlat1.xz + u_xlat4.xy;
					    u_xlat0.x = u_xlat4.x * u_xlat0.x;
					    u_xlat0.x = u_xlat4.y * u_xlat0.x;
					    u_xlatb4.xy = greaterThanEqual(vs_TEXCOORD1.xyxx, _ClipRect.xyxx).xy;
					    u_xlat4.xy = mix(vec2(0.0, 0.0), vec2(1.0, 1.0), vec2(u_xlatb4.xy));
					    u_xlatb1.xy = greaterThanEqual(_ClipRect.zwzz, vs_TEXCOORD1.xyxx).xy;
					    u_xlat1.xy = mix(vec2(0.0, 0.0), vec2(1.0, 1.0), vec2(u_xlatb1.xy));
					    u_xlat4.xy = u_xlat4.xy * u_xlat1.xy;
					    u_xlat4.x = u_xlat4.y * u_xlat4.x;
					    u_xlat16_1 = texture(_MainTex, vs_TEXCOORD0.xy);
					    u_xlat1 = u_xlat16_1 + _TextureSampleAdd;
					    u_xlat1 = u_xlat1 * vs_COLOR0;
					    u_xlat4.x = u_xlat4.x * u_xlat1.w;
					    u_xlat1.w = u_xlat0.x * u_xlat4.x;
					    SV_Target0 = u_xlat1;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier01 " {
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	mediump vec4 _Color;
					uniform 	vec4 _MainTex_ST;
					in highp vec4 in_POSITION0;
					in highp vec4 in_COLOR0;
					in highp vec2 in_TEXCOORD0;
					out mediump vec4 vs_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp vec4 vs_TEXCOORD1;
					vec4 u_xlat0;
					vec4 u_xlat1;
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
					    u_xlat0 = in_COLOR0 * _Color;
					    vs_COLOR0 = u_xlat0;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    vs_TEXCOORD1 = in_POSITION0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _ScreenParams;
					uniform 	float _Stencil;
					uniform 	mediump vec4 _MaskInteraction;
					uniform 	mediump vec4 _TextureSampleAdd;
					uniform 	vec4 _ClipRect;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _SoftMaskTex;
					in mediump vec4 vs_COLOR0;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_TEXCOORD1;
					layout(location = 0) out mediump vec4 SV_Target0;
					vec4 u_xlat0;
					bvec4 u_xlatb0;
					vec4 u_xlat1;
					mediump vec4 u_xlat16_1;
					bvec4 u_xlatb1;
					vec4 u_xlat2;
					mediump vec4 u_xlat16_2;
					vec4 u_xlat3;
					bvec4 u_xlatb3;
					vec2 u_xlat4;
					bvec2 u_xlatb4;
					void main()
					{
					vec4 hlslcc_FragCoord = vec4(gl_FragCoord.xyz, 1.0/gl_FragCoord.w);
					    u_xlatb0 = greaterThanEqual(_MaskInteraction.xxyy, vec4(1.0, 2.0, 1.0, 2.0));
					    u_xlat0 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb0));
					    u_xlatb1 = greaterThanEqual(vec4(_Stencil), vec4(1.0, 3.0, 7.0, 15.0));
					    u_xlat1 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb1));
					    u_xlat0 = u_xlat0 * u_xlat1.xxyy;
					    u_xlat1.xy = hlslcc_FragCoord.xy / _ScreenParams.xy;
					    u_xlat16_2 = texture(_SoftMaskTex, u_xlat1.xy);
					    u_xlat2 = u_xlat16_2 + vec4(-1.0, -1.0, -1.0, -1.0);
					    u_xlat0.xz = u_xlat0.xz * u_xlat2.xy + vec2(1.0, 1.0);
					    u_xlat1.xy = u_xlat0.xz * vec2(-2.0, -2.0) + vec2(1.0, 1.0);
					    u_xlat0.xy = u_xlat0.yw * u_xlat1.xy + u_xlat0.xz;
					    u_xlat0.x = u_xlat0.y * u_xlat0.x;
					    u_xlatb3 = greaterThanEqual(_MaskInteraction.zzww, vec4(1.0, 2.0, 1.0, 2.0));
					    u_xlat3 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb3));
					    u_xlat1 = u_xlat1.zzww * u_xlat3;
					    u_xlat4.xy = u_xlat1.xz * u_xlat2.zw + vec2(1.0, 1.0);
					    u_xlat1.xz = u_xlat4.xy * vec2(-2.0, -2.0) + vec2(1.0, 1.0);
					    u_xlat4.xy = u_xlat1.yw * u_xlat1.xz + u_xlat4.xy;
					    u_xlat0.x = u_xlat4.x * u_xlat0.x;
					    u_xlat0.x = u_xlat4.y * u_xlat0.x;
					    u_xlatb4.xy = greaterThanEqual(vs_TEXCOORD1.xyxx, _ClipRect.xyxx).xy;
					    u_xlat4.xy = mix(vec2(0.0, 0.0), vec2(1.0, 1.0), vec2(u_xlatb4.xy));
					    u_xlatb1.xy = greaterThanEqual(_ClipRect.zwzz, vs_TEXCOORD1.xyxx).xy;
					    u_xlat1.xy = mix(vec2(0.0, 0.0), vec2(1.0, 1.0), vec2(u_xlatb1.xy));
					    u_xlat4.xy = u_xlat4.xy * u_xlat1.xy;
					    u_xlat4.x = u_xlat4.y * u_xlat4.x;
					    u_xlat16_1 = texture(_MainTex, vs_TEXCOORD0.xy);
					    u_xlat1 = u_xlat16_1 + _TextureSampleAdd;
					    u_xlat1 = u_xlat1 * vs_COLOR0;
					    u_xlat4.x = u_xlat4.x * u_xlat1.w;
					    u_xlat1.w = u_xlat0.x * u_xlat4.x;
					    SV_Target0 = u_xlat1;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier02 " {
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	mediump vec4 _Color;
					uniform 	vec4 _MainTex_ST;
					in highp vec4 in_POSITION0;
					in highp vec4 in_COLOR0;
					in highp vec2 in_TEXCOORD0;
					out mediump vec4 vs_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp vec4 vs_TEXCOORD1;
					vec4 u_xlat0;
					vec4 u_xlat1;
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
					    u_xlat0 = in_COLOR0 * _Color;
					    vs_COLOR0 = u_xlat0;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    vs_TEXCOORD1 = in_POSITION0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _ScreenParams;
					uniform 	float _Stencil;
					uniform 	mediump vec4 _MaskInteraction;
					uniform 	mediump vec4 _TextureSampleAdd;
					uniform 	vec4 _ClipRect;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _SoftMaskTex;
					in mediump vec4 vs_COLOR0;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_TEXCOORD1;
					layout(location = 0) out mediump vec4 SV_Target0;
					vec4 u_xlat0;
					bvec4 u_xlatb0;
					vec4 u_xlat1;
					mediump vec4 u_xlat16_1;
					bvec4 u_xlatb1;
					vec4 u_xlat2;
					mediump vec4 u_xlat16_2;
					vec4 u_xlat3;
					bvec4 u_xlatb3;
					vec2 u_xlat4;
					bvec2 u_xlatb4;
					void main()
					{
					vec4 hlslcc_FragCoord = vec4(gl_FragCoord.xyz, 1.0/gl_FragCoord.w);
					    u_xlatb0 = greaterThanEqual(_MaskInteraction.xxyy, vec4(1.0, 2.0, 1.0, 2.0));
					    u_xlat0 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb0));
					    u_xlatb1 = greaterThanEqual(vec4(_Stencil), vec4(1.0, 3.0, 7.0, 15.0));
					    u_xlat1 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb1));
					    u_xlat0 = u_xlat0 * u_xlat1.xxyy;
					    u_xlat1.xy = hlslcc_FragCoord.xy / _ScreenParams.xy;
					    u_xlat16_2 = texture(_SoftMaskTex, u_xlat1.xy);
					    u_xlat2 = u_xlat16_2 + vec4(-1.0, -1.0, -1.0, -1.0);
					    u_xlat0.xz = u_xlat0.xz * u_xlat2.xy + vec2(1.0, 1.0);
					    u_xlat1.xy = u_xlat0.xz * vec2(-2.0, -2.0) + vec2(1.0, 1.0);
					    u_xlat0.xy = u_xlat0.yw * u_xlat1.xy + u_xlat0.xz;
					    u_xlat0.x = u_xlat0.y * u_xlat0.x;
					    u_xlatb3 = greaterThanEqual(_MaskInteraction.zzww, vec4(1.0, 2.0, 1.0, 2.0));
					    u_xlat3 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb3));
					    u_xlat1 = u_xlat1.zzww * u_xlat3;
					    u_xlat4.xy = u_xlat1.xz * u_xlat2.zw + vec2(1.0, 1.0);
					    u_xlat1.xz = u_xlat4.xy * vec2(-2.0, -2.0) + vec2(1.0, 1.0);
					    u_xlat4.xy = u_xlat1.yw * u_xlat1.xz + u_xlat4.xy;
					    u_xlat0.x = u_xlat4.x * u_xlat0.x;
					    u_xlat0.x = u_xlat4.y * u_xlat0.x;
					    u_xlatb4.xy = greaterThanEqual(vs_TEXCOORD1.xyxx, _ClipRect.xyxx).xy;
					    u_xlat4.xy = mix(vec2(0.0, 0.0), vec2(1.0, 1.0), vec2(u_xlatb4.xy));
					    u_xlatb1.xy = greaterThanEqual(_ClipRect.zwzz, vs_TEXCOORD1.xyxx).xy;
					    u_xlat1.xy = mix(vec2(0.0, 0.0), vec2(1.0, 1.0), vec2(u_xlatb1.xy));
					    u_xlat4.xy = u_xlat4.xy * u_xlat1.xy;
					    u_xlat4.x = u_xlat4.y * u_xlat4.x;
					    u_xlat16_1 = texture(_MainTex, vs_TEXCOORD0.xy);
					    u_xlat1 = u_xlat16_1 + _TextureSampleAdd;
					    u_xlat1 = u_xlat1 * vs_COLOR0;
					    u_xlat4.x = u_xlat4.x * u_xlat1.w;
					    u_xlat1.w = u_xlat0.x * u_xlat4.x;
					    SV_Target0 = u_xlat1;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier00 " {
					Keywords { "UNITY_UI_ALPHACLIP" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	mediump vec4 _Color;
					uniform 	vec4 _MainTex_ST;
					attribute highp vec4 in_POSITION0;
					attribute highp vec4 in_COLOR0;
					attribute highp vec2 in_TEXCOORD0;
					varying mediump vec4 vs_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_TEXCOORD1;
					vec4 u_xlat0;
					vec4 u_xlat1;
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
					    u_xlat0 = in_COLOR0 * _Color;
					    vs_COLOR0 = u_xlat0;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    vs_TEXCOORD1 = in_POSITION0;
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
					uniform 	vec4 _ScreenParams;
					uniform 	float _Stencil;
					uniform 	mediump vec4 _MaskInteraction;
					uniform 	mediump vec4 _TextureSampleAdd;
					uniform 	vec4 _ClipRect;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _SoftMaskTex;
					varying mediump vec4 vs_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_TEXCOORD1;
					#define SV_Target0 gl_FragData[0]
					vec4 u_xlat0;
					bvec4 u_xlatb0;
					vec4 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec4 u_xlat2;
					mediump float u_xlat16_2;
					bvec4 u_xlatb2;
					vec4 u_xlat3;
					bvec4 u_xlatb3;
					vec4 u_xlat4;
					lowp vec4 u_xlat10_4;
					vec2 u_xlat5;
					bool u_xlatb5;
					vec2 u_xlat10;
					void main()
					{
					vec4 hlslcc_FragCoord = vec4(gl_FragCoord.xyz, 1.0/gl_FragCoord.w);
					    u_xlatb0.xy = greaterThanEqual(vs_TEXCOORD1.xyxx, _ClipRect.xyxx).xy;
					    u_xlatb0.zw = greaterThanEqual(_ClipRect.zzzw, vs_TEXCOORD1.xxxy).zw;
					    u_xlat0 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb0));
					    u_xlat0.xy = u_xlat0.zw * u_xlat0.xy;
					    u_xlat0.x = u_xlat0.y * u_xlat0.x;
					    u_xlat10_1 = texture2D(_MainTex, vs_TEXCOORD0.xy);
					    u_xlat1 = u_xlat10_1 + _TextureSampleAdd;
					    u_xlat1 = u_xlat1 * vs_COLOR0;
					    u_xlat16_2 = u_xlat1.w * u_xlat0.x + -0.00100000005;
					    u_xlat0.x = u_xlat0.x * u_xlat1.w;
					    u_xlatb5 = u_xlat16_2<0.0;
					    if(((int(u_xlatb5) * -1))!=0){discard;}
					    u_xlatb2 = greaterThanEqual(_MaskInteraction.xxyy, vec4(1.0, 2.0, 1.0, 2.0));
					    u_xlat2 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb2));
					    u_xlatb3 = greaterThanEqual(vec4(_Stencil), vec4(1.0, 3.0, 7.0, 15.0));
					    u_xlat3 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb3));
					    u_xlat2 = u_xlat2 * u_xlat3.xxyy;
					    u_xlat5.xy = hlslcc_FragCoord.xy / _ScreenParams.xy;
					    u_xlat10_4 = texture2D(_SoftMaskTex, u_xlat5.xy);
					    u_xlat4 = u_xlat10_4 + vec4(-1.0, -1.0, -1.0, -1.0);
					    u_xlat5.xy = u_xlat2.xz * u_xlat4.xy + vec2(1.0, 1.0);
					    u_xlat3.xy = u_xlat5.xy * vec2(-2.0, -2.0) + vec2(1.0, 1.0);
					    u_xlat5.xy = u_xlat2.yw * u_xlat3.xy + u_xlat5.xy;
					    u_xlat5.x = u_xlat5.y * u_xlat5.x;
					    u_xlatb2 = greaterThanEqual(_MaskInteraction.zzww, vec4(1.0, 2.0, 1.0, 2.0));
					    u_xlat2 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb2));
					    u_xlat2 = u_xlat2 * u_xlat3.zzww;
					    u_xlat10.xy = u_xlat2.xz * u_xlat4.zw + vec2(1.0, 1.0);
					    u_xlat3.xy = u_xlat10.xy * vec2(-2.0, -2.0) + vec2(1.0, 1.0);
					    u_xlat10.xy = u_xlat2.yw * u_xlat3.xy + u_xlat10.xy;
					    u_xlat5.x = u_xlat10.x * u_xlat5.x;
					    u_xlat5.x = u_xlat10.y * u_xlat5.x;
					    u_xlat1.w = u_xlat5.x * u_xlat0.x;
					    SV_Target0 = u_xlat1;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier01 " {
					Keywords { "UNITY_UI_ALPHACLIP" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	mediump vec4 _Color;
					uniform 	vec4 _MainTex_ST;
					attribute highp vec4 in_POSITION0;
					attribute highp vec4 in_COLOR0;
					attribute highp vec2 in_TEXCOORD0;
					varying mediump vec4 vs_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_TEXCOORD1;
					vec4 u_xlat0;
					vec4 u_xlat1;
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
					    u_xlat0 = in_COLOR0 * _Color;
					    vs_COLOR0 = u_xlat0;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    vs_TEXCOORD1 = in_POSITION0;
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
					uniform 	vec4 _ScreenParams;
					uniform 	float _Stencil;
					uniform 	mediump vec4 _MaskInteraction;
					uniform 	mediump vec4 _TextureSampleAdd;
					uniform 	vec4 _ClipRect;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _SoftMaskTex;
					varying mediump vec4 vs_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_TEXCOORD1;
					#define SV_Target0 gl_FragData[0]
					vec4 u_xlat0;
					bvec4 u_xlatb0;
					vec4 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec4 u_xlat2;
					mediump float u_xlat16_2;
					bvec4 u_xlatb2;
					vec4 u_xlat3;
					bvec4 u_xlatb3;
					vec4 u_xlat4;
					lowp vec4 u_xlat10_4;
					vec2 u_xlat5;
					bool u_xlatb5;
					vec2 u_xlat10;
					void main()
					{
					vec4 hlslcc_FragCoord = vec4(gl_FragCoord.xyz, 1.0/gl_FragCoord.w);
					    u_xlatb0.xy = greaterThanEqual(vs_TEXCOORD1.xyxx, _ClipRect.xyxx).xy;
					    u_xlatb0.zw = greaterThanEqual(_ClipRect.zzzw, vs_TEXCOORD1.xxxy).zw;
					    u_xlat0 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb0));
					    u_xlat0.xy = u_xlat0.zw * u_xlat0.xy;
					    u_xlat0.x = u_xlat0.y * u_xlat0.x;
					    u_xlat10_1 = texture2D(_MainTex, vs_TEXCOORD0.xy);
					    u_xlat1 = u_xlat10_1 + _TextureSampleAdd;
					    u_xlat1 = u_xlat1 * vs_COLOR0;
					    u_xlat16_2 = u_xlat1.w * u_xlat0.x + -0.00100000005;
					    u_xlat0.x = u_xlat0.x * u_xlat1.w;
					    u_xlatb5 = u_xlat16_2<0.0;
					    if(((int(u_xlatb5) * -1))!=0){discard;}
					    u_xlatb2 = greaterThanEqual(_MaskInteraction.xxyy, vec4(1.0, 2.0, 1.0, 2.0));
					    u_xlat2 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb2));
					    u_xlatb3 = greaterThanEqual(vec4(_Stencil), vec4(1.0, 3.0, 7.0, 15.0));
					    u_xlat3 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb3));
					    u_xlat2 = u_xlat2 * u_xlat3.xxyy;
					    u_xlat5.xy = hlslcc_FragCoord.xy / _ScreenParams.xy;
					    u_xlat10_4 = texture2D(_SoftMaskTex, u_xlat5.xy);
					    u_xlat4 = u_xlat10_4 + vec4(-1.0, -1.0, -1.0, -1.0);
					    u_xlat5.xy = u_xlat2.xz * u_xlat4.xy + vec2(1.0, 1.0);
					    u_xlat3.xy = u_xlat5.xy * vec2(-2.0, -2.0) + vec2(1.0, 1.0);
					    u_xlat5.xy = u_xlat2.yw * u_xlat3.xy + u_xlat5.xy;
					    u_xlat5.x = u_xlat5.y * u_xlat5.x;
					    u_xlatb2 = greaterThanEqual(_MaskInteraction.zzww, vec4(1.0, 2.0, 1.0, 2.0));
					    u_xlat2 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb2));
					    u_xlat2 = u_xlat2 * u_xlat3.zzww;
					    u_xlat10.xy = u_xlat2.xz * u_xlat4.zw + vec2(1.0, 1.0);
					    u_xlat3.xy = u_xlat10.xy * vec2(-2.0, -2.0) + vec2(1.0, 1.0);
					    u_xlat10.xy = u_xlat2.yw * u_xlat3.xy + u_xlat10.xy;
					    u_xlat5.x = u_xlat10.x * u_xlat5.x;
					    u_xlat5.x = u_xlat10.y * u_xlat5.x;
					    u_xlat1.w = u_xlat5.x * u_xlat0.x;
					    SV_Target0 = u_xlat1;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier02 " {
					Keywords { "UNITY_UI_ALPHACLIP" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	mediump vec4 _Color;
					uniform 	vec4 _MainTex_ST;
					attribute highp vec4 in_POSITION0;
					attribute highp vec4 in_COLOR0;
					attribute highp vec2 in_TEXCOORD0;
					varying mediump vec4 vs_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_TEXCOORD1;
					vec4 u_xlat0;
					vec4 u_xlat1;
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
					    u_xlat0 = in_COLOR0 * _Color;
					    vs_COLOR0 = u_xlat0;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    vs_TEXCOORD1 = in_POSITION0;
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
					uniform 	vec4 _ScreenParams;
					uniform 	float _Stencil;
					uniform 	mediump vec4 _MaskInteraction;
					uniform 	mediump vec4 _TextureSampleAdd;
					uniform 	vec4 _ClipRect;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _SoftMaskTex;
					varying mediump vec4 vs_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_TEXCOORD1;
					#define SV_Target0 gl_FragData[0]
					vec4 u_xlat0;
					bvec4 u_xlatb0;
					vec4 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec4 u_xlat2;
					mediump float u_xlat16_2;
					bvec4 u_xlatb2;
					vec4 u_xlat3;
					bvec4 u_xlatb3;
					vec4 u_xlat4;
					lowp vec4 u_xlat10_4;
					vec2 u_xlat5;
					bool u_xlatb5;
					vec2 u_xlat10;
					void main()
					{
					vec4 hlslcc_FragCoord = vec4(gl_FragCoord.xyz, 1.0/gl_FragCoord.w);
					    u_xlatb0.xy = greaterThanEqual(vs_TEXCOORD1.xyxx, _ClipRect.xyxx).xy;
					    u_xlatb0.zw = greaterThanEqual(_ClipRect.zzzw, vs_TEXCOORD1.xxxy).zw;
					    u_xlat0 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb0));
					    u_xlat0.xy = u_xlat0.zw * u_xlat0.xy;
					    u_xlat0.x = u_xlat0.y * u_xlat0.x;
					    u_xlat10_1 = texture2D(_MainTex, vs_TEXCOORD0.xy);
					    u_xlat1 = u_xlat10_1 + _TextureSampleAdd;
					    u_xlat1 = u_xlat1 * vs_COLOR0;
					    u_xlat16_2 = u_xlat1.w * u_xlat0.x + -0.00100000005;
					    u_xlat0.x = u_xlat0.x * u_xlat1.w;
					    u_xlatb5 = u_xlat16_2<0.0;
					    if(((int(u_xlatb5) * -1))!=0){discard;}
					    u_xlatb2 = greaterThanEqual(_MaskInteraction.xxyy, vec4(1.0, 2.0, 1.0, 2.0));
					    u_xlat2 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb2));
					    u_xlatb3 = greaterThanEqual(vec4(_Stencil), vec4(1.0, 3.0, 7.0, 15.0));
					    u_xlat3 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb3));
					    u_xlat2 = u_xlat2 * u_xlat3.xxyy;
					    u_xlat5.xy = hlslcc_FragCoord.xy / _ScreenParams.xy;
					    u_xlat10_4 = texture2D(_SoftMaskTex, u_xlat5.xy);
					    u_xlat4 = u_xlat10_4 + vec4(-1.0, -1.0, -1.0, -1.0);
					    u_xlat5.xy = u_xlat2.xz * u_xlat4.xy + vec2(1.0, 1.0);
					    u_xlat3.xy = u_xlat5.xy * vec2(-2.0, -2.0) + vec2(1.0, 1.0);
					    u_xlat5.xy = u_xlat2.yw * u_xlat3.xy + u_xlat5.xy;
					    u_xlat5.x = u_xlat5.y * u_xlat5.x;
					    u_xlatb2 = greaterThanEqual(_MaskInteraction.zzww, vec4(1.0, 2.0, 1.0, 2.0));
					    u_xlat2 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb2));
					    u_xlat2 = u_xlat2 * u_xlat3.zzww;
					    u_xlat10.xy = u_xlat2.xz * u_xlat4.zw + vec2(1.0, 1.0);
					    u_xlat3.xy = u_xlat10.xy * vec2(-2.0, -2.0) + vec2(1.0, 1.0);
					    u_xlat10.xy = u_xlat2.yw * u_xlat3.xy + u_xlat10.xy;
					    u_xlat5.x = u_xlat10.x * u_xlat5.x;
					    u_xlat5.x = u_xlat10.y * u_xlat5.x;
					    u_xlat1.w = u_xlat5.x * u_xlat0.x;
					    SV_Target0 = u_xlat1;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier00 " {
					Keywords { "UNITY_UI_ALPHACLIP" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	mediump vec4 _Color;
					uniform 	vec4 _MainTex_ST;
					in highp vec4 in_POSITION0;
					in highp vec4 in_COLOR0;
					in highp vec2 in_TEXCOORD0;
					out mediump vec4 vs_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp vec4 vs_TEXCOORD1;
					vec4 u_xlat0;
					vec4 u_xlat1;
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
					    u_xlat0 = in_COLOR0 * _Color;
					    vs_COLOR0 = u_xlat0;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    vs_TEXCOORD1 = in_POSITION0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _ScreenParams;
					uniform 	float _Stencil;
					uniform 	mediump vec4 _MaskInteraction;
					uniform 	mediump vec4 _TextureSampleAdd;
					uniform 	vec4 _ClipRect;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _SoftMaskTex;
					in mediump vec4 vs_COLOR0;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_TEXCOORD1;
					layout(location = 0) out mediump vec4 SV_Target0;
					vec4 u_xlat0;
					bvec4 u_xlatb0;
					vec4 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec4 u_xlat2;
					mediump float u_xlat16_2;
					bvec4 u_xlatb2;
					vec4 u_xlat3;
					bvec4 u_xlatb3;
					vec4 u_xlat4;
					mediump vec4 u_xlat16_4;
					vec2 u_xlat5;
					bool u_xlatb5;
					vec2 u_xlat10;
					void main()
					{
					vec4 hlslcc_FragCoord = vec4(gl_FragCoord.xyz, 1.0/gl_FragCoord.w);
					    u_xlatb0.xy = greaterThanEqual(vs_TEXCOORD1.xyxx, _ClipRect.xyxx).xy;
					    u_xlatb0.zw = greaterThanEqual(_ClipRect.zzzw, vs_TEXCOORD1.xxxy).zw;
					    u_xlat0 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb0));
					    u_xlat0.xy = u_xlat0.zw * u_xlat0.xy;
					    u_xlat0.x = u_xlat0.y * u_xlat0.x;
					    u_xlat16_1 = texture(_MainTex, vs_TEXCOORD0.xy);
					    u_xlat1 = u_xlat16_1 + _TextureSampleAdd;
					    u_xlat1 = u_xlat1 * vs_COLOR0;
					    u_xlat16_2 = u_xlat1.w * u_xlat0.x + -0.00100000005;
					    u_xlat0.x = u_xlat0.x * u_xlat1.w;
					#ifdef UNITY_ADRENO_ES3
					    u_xlatb5 = !!(u_xlat16_2<0.0);
					#else
					    u_xlatb5 = u_xlat16_2<0.0;
					#endif
					    if(((int(u_xlatb5) * int(0xffffffffu)))!=0){discard;}
					    u_xlatb2 = greaterThanEqual(_MaskInteraction.xxyy, vec4(1.0, 2.0, 1.0, 2.0));
					    u_xlat2 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb2));
					    u_xlatb3 = greaterThanEqual(vec4(_Stencil), vec4(1.0, 3.0, 7.0, 15.0));
					    u_xlat3 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb3));
					    u_xlat2 = u_xlat2 * u_xlat3.xxyy;
					    u_xlat5.xy = hlslcc_FragCoord.xy / _ScreenParams.xy;
					    u_xlat16_4 = texture(_SoftMaskTex, u_xlat5.xy);
					    u_xlat4 = u_xlat16_4 + vec4(-1.0, -1.0, -1.0, -1.0);
					    u_xlat5.xy = u_xlat2.xz * u_xlat4.xy + vec2(1.0, 1.0);
					    u_xlat3.xy = u_xlat5.xy * vec2(-2.0, -2.0) + vec2(1.0, 1.0);
					    u_xlat5.xy = u_xlat2.yw * u_xlat3.xy + u_xlat5.xy;
					    u_xlat5.x = u_xlat5.y * u_xlat5.x;
					    u_xlatb2 = greaterThanEqual(_MaskInteraction.zzww, vec4(1.0, 2.0, 1.0, 2.0));
					    u_xlat2 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb2));
					    u_xlat2 = u_xlat2 * u_xlat3.zzww;
					    u_xlat10.xy = u_xlat2.xz * u_xlat4.zw + vec2(1.0, 1.0);
					    u_xlat3.xy = u_xlat10.xy * vec2(-2.0, -2.0) + vec2(1.0, 1.0);
					    u_xlat10.xy = u_xlat2.yw * u_xlat3.xy + u_xlat10.xy;
					    u_xlat5.x = u_xlat10.x * u_xlat5.x;
					    u_xlat5.x = u_xlat10.y * u_xlat5.x;
					    u_xlat1.w = u_xlat5.x * u_xlat0.x;
					    SV_Target0 = u_xlat1;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier01 " {
					Keywords { "UNITY_UI_ALPHACLIP" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	mediump vec4 _Color;
					uniform 	vec4 _MainTex_ST;
					in highp vec4 in_POSITION0;
					in highp vec4 in_COLOR0;
					in highp vec2 in_TEXCOORD0;
					out mediump vec4 vs_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp vec4 vs_TEXCOORD1;
					vec4 u_xlat0;
					vec4 u_xlat1;
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
					    u_xlat0 = in_COLOR0 * _Color;
					    vs_COLOR0 = u_xlat0;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    vs_TEXCOORD1 = in_POSITION0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _ScreenParams;
					uniform 	float _Stencil;
					uniform 	mediump vec4 _MaskInteraction;
					uniform 	mediump vec4 _TextureSampleAdd;
					uniform 	vec4 _ClipRect;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _SoftMaskTex;
					in mediump vec4 vs_COLOR0;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_TEXCOORD1;
					layout(location = 0) out mediump vec4 SV_Target0;
					vec4 u_xlat0;
					bvec4 u_xlatb0;
					vec4 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec4 u_xlat2;
					mediump float u_xlat16_2;
					bvec4 u_xlatb2;
					vec4 u_xlat3;
					bvec4 u_xlatb3;
					vec4 u_xlat4;
					mediump vec4 u_xlat16_4;
					vec2 u_xlat5;
					bool u_xlatb5;
					vec2 u_xlat10;
					void main()
					{
					vec4 hlslcc_FragCoord = vec4(gl_FragCoord.xyz, 1.0/gl_FragCoord.w);
					    u_xlatb0.xy = greaterThanEqual(vs_TEXCOORD1.xyxx, _ClipRect.xyxx).xy;
					    u_xlatb0.zw = greaterThanEqual(_ClipRect.zzzw, vs_TEXCOORD1.xxxy).zw;
					    u_xlat0 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb0));
					    u_xlat0.xy = u_xlat0.zw * u_xlat0.xy;
					    u_xlat0.x = u_xlat0.y * u_xlat0.x;
					    u_xlat16_1 = texture(_MainTex, vs_TEXCOORD0.xy);
					    u_xlat1 = u_xlat16_1 + _TextureSampleAdd;
					    u_xlat1 = u_xlat1 * vs_COLOR0;
					    u_xlat16_2 = u_xlat1.w * u_xlat0.x + -0.00100000005;
					    u_xlat0.x = u_xlat0.x * u_xlat1.w;
					#ifdef UNITY_ADRENO_ES3
					    u_xlatb5 = !!(u_xlat16_2<0.0);
					#else
					    u_xlatb5 = u_xlat16_2<0.0;
					#endif
					    if(((int(u_xlatb5) * int(0xffffffffu)))!=0){discard;}
					    u_xlatb2 = greaterThanEqual(_MaskInteraction.xxyy, vec4(1.0, 2.0, 1.0, 2.0));
					    u_xlat2 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb2));
					    u_xlatb3 = greaterThanEqual(vec4(_Stencil), vec4(1.0, 3.0, 7.0, 15.0));
					    u_xlat3 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb3));
					    u_xlat2 = u_xlat2 * u_xlat3.xxyy;
					    u_xlat5.xy = hlslcc_FragCoord.xy / _ScreenParams.xy;
					    u_xlat16_4 = texture(_SoftMaskTex, u_xlat5.xy);
					    u_xlat4 = u_xlat16_4 + vec4(-1.0, -1.0, -1.0, -1.0);
					    u_xlat5.xy = u_xlat2.xz * u_xlat4.xy + vec2(1.0, 1.0);
					    u_xlat3.xy = u_xlat5.xy * vec2(-2.0, -2.0) + vec2(1.0, 1.0);
					    u_xlat5.xy = u_xlat2.yw * u_xlat3.xy + u_xlat5.xy;
					    u_xlat5.x = u_xlat5.y * u_xlat5.x;
					    u_xlatb2 = greaterThanEqual(_MaskInteraction.zzww, vec4(1.0, 2.0, 1.0, 2.0));
					    u_xlat2 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb2));
					    u_xlat2 = u_xlat2 * u_xlat3.zzww;
					    u_xlat10.xy = u_xlat2.xz * u_xlat4.zw + vec2(1.0, 1.0);
					    u_xlat3.xy = u_xlat10.xy * vec2(-2.0, -2.0) + vec2(1.0, 1.0);
					    u_xlat10.xy = u_xlat2.yw * u_xlat3.xy + u_xlat10.xy;
					    u_xlat5.x = u_xlat10.x * u_xlat5.x;
					    u_xlat5.x = u_xlat10.y * u_xlat5.x;
					    u_xlat1.w = u_xlat5.x * u_xlat0.x;
					    SV_Target0 = u_xlat1;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier02 " {
					Keywords { "UNITY_UI_ALPHACLIP" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	mediump vec4 _Color;
					uniform 	vec4 _MainTex_ST;
					in highp vec4 in_POSITION0;
					in highp vec4 in_COLOR0;
					in highp vec2 in_TEXCOORD0;
					out mediump vec4 vs_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp vec4 vs_TEXCOORD1;
					vec4 u_xlat0;
					vec4 u_xlat1;
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
					    u_xlat0 = in_COLOR0 * _Color;
					    vs_COLOR0 = u_xlat0;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    vs_TEXCOORD1 = in_POSITION0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _ScreenParams;
					uniform 	float _Stencil;
					uniform 	mediump vec4 _MaskInteraction;
					uniform 	mediump vec4 _TextureSampleAdd;
					uniform 	vec4 _ClipRect;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _SoftMaskTex;
					in mediump vec4 vs_COLOR0;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_TEXCOORD1;
					layout(location = 0) out mediump vec4 SV_Target0;
					vec4 u_xlat0;
					bvec4 u_xlatb0;
					vec4 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec4 u_xlat2;
					mediump float u_xlat16_2;
					bvec4 u_xlatb2;
					vec4 u_xlat3;
					bvec4 u_xlatb3;
					vec4 u_xlat4;
					mediump vec4 u_xlat16_4;
					vec2 u_xlat5;
					bool u_xlatb5;
					vec2 u_xlat10;
					void main()
					{
					vec4 hlslcc_FragCoord = vec4(gl_FragCoord.xyz, 1.0/gl_FragCoord.w);
					    u_xlatb0.xy = greaterThanEqual(vs_TEXCOORD1.xyxx, _ClipRect.xyxx).xy;
					    u_xlatb0.zw = greaterThanEqual(_ClipRect.zzzw, vs_TEXCOORD1.xxxy).zw;
					    u_xlat0 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb0));
					    u_xlat0.xy = u_xlat0.zw * u_xlat0.xy;
					    u_xlat0.x = u_xlat0.y * u_xlat0.x;
					    u_xlat16_1 = texture(_MainTex, vs_TEXCOORD0.xy);
					    u_xlat1 = u_xlat16_1 + _TextureSampleAdd;
					    u_xlat1 = u_xlat1 * vs_COLOR0;
					    u_xlat16_2 = u_xlat1.w * u_xlat0.x + -0.00100000005;
					    u_xlat0.x = u_xlat0.x * u_xlat1.w;
					#ifdef UNITY_ADRENO_ES3
					    u_xlatb5 = !!(u_xlat16_2<0.0);
					#else
					    u_xlatb5 = u_xlat16_2<0.0;
					#endif
					    if(((int(u_xlatb5) * int(0xffffffffu)))!=0){discard;}
					    u_xlatb2 = greaterThanEqual(_MaskInteraction.xxyy, vec4(1.0, 2.0, 1.0, 2.0));
					    u_xlat2 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb2));
					    u_xlatb3 = greaterThanEqual(vec4(_Stencil), vec4(1.0, 3.0, 7.0, 15.0));
					    u_xlat3 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb3));
					    u_xlat2 = u_xlat2 * u_xlat3.xxyy;
					    u_xlat5.xy = hlslcc_FragCoord.xy / _ScreenParams.xy;
					    u_xlat16_4 = texture(_SoftMaskTex, u_xlat5.xy);
					    u_xlat4 = u_xlat16_4 + vec4(-1.0, -1.0, -1.0, -1.0);
					    u_xlat5.xy = u_xlat2.xz * u_xlat4.xy + vec2(1.0, 1.0);
					    u_xlat3.xy = u_xlat5.xy * vec2(-2.0, -2.0) + vec2(1.0, 1.0);
					    u_xlat5.xy = u_xlat2.yw * u_xlat3.xy + u_xlat5.xy;
					    u_xlat5.x = u_xlat5.y * u_xlat5.x;
					    u_xlatb2 = greaterThanEqual(_MaskInteraction.zzww, vec4(1.0, 2.0, 1.0, 2.0));
					    u_xlat2 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb2));
					    u_xlat2 = u_xlat2 * u_xlat3.zzww;
					    u_xlat10.xy = u_xlat2.xz * u_xlat4.zw + vec2(1.0, 1.0);
					    u_xlat3.xy = u_xlat10.xy * vec2(-2.0, -2.0) + vec2(1.0, 1.0);
					    u_xlat10.xy = u_xlat2.yw * u_xlat3.xy + u_xlat10.xy;
					    u_xlat5.x = u_xlat10.x * u_xlat5.x;
					    u_xlat5.x = u_xlat10.y * u_xlat5.x;
					    u_xlat1.w = u_xlat5.x * u_xlat0.x;
					    SV_Target0 = u_xlat1;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier00 " {
					Keywords { "UNITY_UI_CLIP_RECT" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	mediump vec4 _Color;
					uniform 	vec4 _MainTex_ST;
					attribute highp vec4 in_POSITION0;
					attribute highp vec4 in_COLOR0;
					attribute highp vec2 in_TEXCOORD0;
					varying mediump vec4 vs_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_TEXCOORD1;
					vec4 u_xlat0;
					vec4 u_xlat1;
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
					    u_xlat0 = in_COLOR0 * _Color;
					    vs_COLOR0 = u_xlat0;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    vs_TEXCOORD1 = in_POSITION0;
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
					uniform 	vec4 _ScreenParams;
					uniform 	float _Stencil;
					uniform 	mediump vec4 _MaskInteraction;
					uniform 	mediump vec4 _TextureSampleAdd;
					uniform 	vec4 _ClipRect;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _SoftMaskTex;
					varying mediump vec4 vs_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_TEXCOORD1;
					#define SV_Target0 gl_FragData[0]
					vec4 u_xlat0;
					bvec4 u_xlatb0;
					vec4 u_xlat1;
					lowp vec4 u_xlat10_1;
					bvec4 u_xlatb1;
					vec4 u_xlat2;
					lowp vec4 u_xlat10_2;
					vec4 u_xlat3;
					bvec4 u_xlatb3;
					vec2 u_xlat4;
					bvec2 u_xlatb4;
					void main()
					{
					vec4 hlslcc_FragCoord = vec4(gl_FragCoord.xyz, 1.0/gl_FragCoord.w);
					    u_xlatb0 = greaterThanEqual(_MaskInteraction.xxyy, vec4(1.0, 2.0, 1.0, 2.0));
					    u_xlat0 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb0));
					    u_xlatb1 = greaterThanEqual(vec4(_Stencil), vec4(1.0, 3.0, 7.0, 15.0));
					    u_xlat1 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb1));
					    u_xlat0 = u_xlat0 * u_xlat1.xxyy;
					    u_xlat1.xy = hlslcc_FragCoord.xy / _ScreenParams.xy;
					    u_xlat10_2 = texture2D(_SoftMaskTex, u_xlat1.xy);
					    u_xlat2 = u_xlat10_2 + vec4(-1.0, -1.0, -1.0, -1.0);
					    u_xlat0.xz = u_xlat0.xz * u_xlat2.xy + vec2(1.0, 1.0);
					    u_xlat1.xy = u_xlat0.xz * vec2(-2.0, -2.0) + vec2(1.0, 1.0);
					    u_xlat0.xy = u_xlat0.yw * u_xlat1.xy + u_xlat0.xz;
					    u_xlat0.x = u_xlat0.y * u_xlat0.x;
					    u_xlatb3 = greaterThanEqual(_MaskInteraction.zzww, vec4(1.0, 2.0, 1.0, 2.0));
					    u_xlat3 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb3));
					    u_xlat1 = u_xlat1.zzww * u_xlat3;
					    u_xlat4.xy = u_xlat1.xz * u_xlat2.zw + vec2(1.0, 1.0);
					    u_xlat1.xz = u_xlat4.xy * vec2(-2.0, -2.0) + vec2(1.0, 1.0);
					    u_xlat4.xy = u_xlat1.yw * u_xlat1.xz + u_xlat4.xy;
					    u_xlat0.x = u_xlat4.x * u_xlat0.x;
					    u_xlat0.x = u_xlat4.y * u_xlat0.x;
					    u_xlatb4.xy = greaterThanEqual(vs_TEXCOORD1.xyxx, _ClipRect.xyxx).xy;
					    u_xlat4.xy = mix(vec2(0.0, 0.0), vec2(1.0, 1.0), vec2(u_xlatb4.xy));
					    u_xlatb1.xy = greaterThanEqual(_ClipRect.zwzz, vs_TEXCOORD1.xyxx).xy;
					    u_xlat1.xy = mix(vec2(0.0, 0.0), vec2(1.0, 1.0), vec2(u_xlatb1.xy));
					    u_xlat4.xy = u_xlat4.xy * u_xlat1.xy;
					    u_xlat4.x = u_xlat4.y * u_xlat4.x;
					    u_xlat10_1 = texture2D(_MainTex, vs_TEXCOORD0.xy);
					    u_xlat1 = u_xlat10_1 + _TextureSampleAdd;
					    u_xlat1 = u_xlat1 * vs_COLOR0;
					    u_xlat4.x = u_xlat4.x * u_xlat1.w;
					    u_xlat1.w = u_xlat0.x * u_xlat4.x;
					    SV_Target0 = u_xlat1;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier01 " {
					Keywords { "UNITY_UI_CLIP_RECT" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	mediump vec4 _Color;
					uniform 	vec4 _MainTex_ST;
					attribute highp vec4 in_POSITION0;
					attribute highp vec4 in_COLOR0;
					attribute highp vec2 in_TEXCOORD0;
					varying mediump vec4 vs_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_TEXCOORD1;
					vec4 u_xlat0;
					vec4 u_xlat1;
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
					    u_xlat0 = in_COLOR0 * _Color;
					    vs_COLOR0 = u_xlat0;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    vs_TEXCOORD1 = in_POSITION0;
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
					uniform 	vec4 _ScreenParams;
					uniform 	float _Stencil;
					uniform 	mediump vec4 _MaskInteraction;
					uniform 	mediump vec4 _TextureSampleAdd;
					uniform 	vec4 _ClipRect;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _SoftMaskTex;
					varying mediump vec4 vs_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_TEXCOORD1;
					#define SV_Target0 gl_FragData[0]
					vec4 u_xlat0;
					bvec4 u_xlatb0;
					vec4 u_xlat1;
					lowp vec4 u_xlat10_1;
					bvec4 u_xlatb1;
					vec4 u_xlat2;
					lowp vec4 u_xlat10_2;
					vec4 u_xlat3;
					bvec4 u_xlatb3;
					vec2 u_xlat4;
					bvec2 u_xlatb4;
					void main()
					{
					vec4 hlslcc_FragCoord = vec4(gl_FragCoord.xyz, 1.0/gl_FragCoord.w);
					    u_xlatb0 = greaterThanEqual(_MaskInteraction.xxyy, vec4(1.0, 2.0, 1.0, 2.0));
					    u_xlat0 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb0));
					    u_xlatb1 = greaterThanEqual(vec4(_Stencil), vec4(1.0, 3.0, 7.0, 15.0));
					    u_xlat1 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb1));
					    u_xlat0 = u_xlat0 * u_xlat1.xxyy;
					    u_xlat1.xy = hlslcc_FragCoord.xy / _ScreenParams.xy;
					    u_xlat10_2 = texture2D(_SoftMaskTex, u_xlat1.xy);
					    u_xlat2 = u_xlat10_2 + vec4(-1.0, -1.0, -1.0, -1.0);
					    u_xlat0.xz = u_xlat0.xz * u_xlat2.xy + vec2(1.0, 1.0);
					    u_xlat1.xy = u_xlat0.xz * vec2(-2.0, -2.0) + vec2(1.0, 1.0);
					    u_xlat0.xy = u_xlat0.yw * u_xlat1.xy + u_xlat0.xz;
					    u_xlat0.x = u_xlat0.y * u_xlat0.x;
					    u_xlatb3 = greaterThanEqual(_MaskInteraction.zzww, vec4(1.0, 2.0, 1.0, 2.0));
					    u_xlat3 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb3));
					    u_xlat1 = u_xlat1.zzww * u_xlat3;
					    u_xlat4.xy = u_xlat1.xz * u_xlat2.zw + vec2(1.0, 1.0);
					    u_xlat1.xz = u_xlat4.xy * vec2(-2.0, -2.0) + vec2(1.0, 1.0);
					    u_xlat4.xy = u_xlat1.yw * u_xlat1.xz + u_xlat4.xy;
					    u_xlat0.x = u_xlat4.x * u_xlat0.x;
					    u_xlat0.x = u_xlat4.y * u_xlat0.x;
					    u_xlatb4.xy = greaterThanEqual(vs_TEXCOORD1.xyxx, _ClipRect.xyxx).xy;
					    u_xlat4.xy = mix(vec2(0.0, 0.0), vec2(1.0, 1.0), vec2(u_xlatb4.xy));
					    u_xlatb1.xy = greaterThanEqual(_ClipRect.zwzz, vs_TEXCOORD1.xyxx).xy;
					    u_xlat1.xy = mix(vec2(0.0, 0.0), vec2(1.0, 1.0), vec2(u_xlatb1.xy));
					    u_xlat4.xy = u_xlat4.xy * u_xlat1.xy;
					    u_xlat4.x = u_xlat4.y * u_xlat4.x;
					    u_xlat10_1 = texture2D(_MainTex, vs_TEXCOORD0.xy);
					    u_xlat1 = u_xlat10_1 + _TextureSampleAdd;
					    u_xlat1 = u_xlat1 * vs_COLOR0;
					    u_xlat4.x = u_xlat4.x * u_xlat1.w;
					    u_xlat1.w = u_xlat0.x * u_xlat4.x;
					    SV_Target0 = u_xlat1;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier02 " {
					Keywords { "UNITY_UI_CLIP_RECT" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	mediump vec4 _Color;
					uniform 	vec4 _MainTex_ST;
					attribute highp vec4 in_POSITION0;
					attribute highp vec4 in_COLOR0;
					attribute highp vec2 in_TEXCOORD0;
					varying mediump vec4 vs_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_TEXCOORD1;
					vec4 u_xlat0;
					vec4 u_xlat1;
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
					    u_xlat0 = in_COLOR0 * _Color;
					    vs_COLOR0 = u_xlat0;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    vs_TEXCOORD1 = in_POSITION0;
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
					uniform 	vec4 _ScreenParams;
					uniform 	float _Stencil;
					uniform 	mediump vec4 _MaskInteraction;
					uniform 	mediump vec4 _TextureSampleAdd;
					uniform 	vec4 _ClipRect;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _SoftMaskTex;
					varying mediump vec4 vs_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_TEXCOORD1;
					#define SV_Target0 gl_FragData[0]
					vec4 u_xlat0;
					bvec4 u_xlatb0;
					vec4 u_xlat1;
					lowp vec4 u_xlat10_1;
					bvec4 u_xlatb1;
					vec4 u_xlat2;
					lowp vec4 u_xlat10_2;
					vec4 u_xlat3;
					bvec4 u_xlatb3;
					vec2 u_xlat4;
					bvec2 u_xlatb4;
					void main()
					{
					vec4 hlslcc_FragCoord = vec4(gl_FragCoord.xyz, 1.0/gl_FragCoord.w);
					    u_xlatb0 = greaterThanEqual(_MaskInteraction.xxyy, vec4(1.0, 2.0, 1.0, 2.0));
					    u_xlat0 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb0));
					    u_xlatb1 = greaterThanEqual(vec4(_Stencil), vec4(1.0, 3.0, 7.0, 15.0));
					    u_xlat1 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb1));
					    u_xlat0 = u_xlat0 * u_xlat1.xxyy;
					    u_xlat1.xy = hlslcc_FragCoord.xy / _ScreenParams.xy;
					    u_xlat10_2 = texture2D(_SoftMaskTex, u_xlat1.xy);
					    u_xlat2 = u_xlat10_2 + vec4(-1.0, -1.0, -1.0, -1.0);
					    u_xlat0.xz = u_xlat0.xz * u_xlat2.xy + vec2(1.0, 1.0);
					    u_xlat1.xy = u_xlat0.xz * vec2(-2.0, -2.0) + vec2(1.0, 1.0);
					    u_xlat0.xy = u_xlat0.yw * u_xlat1.xy + u_xlat0.xz;
					    u_xlat0.x = u_xlat0.y * u_xlat0.x;
					    u_xlatb3 = greaterThanEqual(_MaskInteraction.zzww, vec4(1.0, 2.0, 1.0, 2.0));
					    u_xlat3 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb3));
					    u_xlat1 = u_xlat1.zzww * u_xlat3;
					    u_xlat4.xy = u_xlat1.xz * u_xlat2.zw + vec2(1.0, 1.0);
					    u_xlat1.xz = u_xlat4.xy * vec2(-2.0, -2.0) + vec2(1.0, 1.0);
					    u_xlat4.xy = u_xlat1.yw * u_xlat1.xz + u_xlat4.xy;
					    u_xlat0.x = u_xlat4.x * u_xlat0.x;
					    u_xlat0.x = u_xlat4.y * u_xlat0.x;
					    u_xlatb4.xy = greaterThanEqual(vs_TEXCOORD1.xyxx, _ClipRect.xyxx).xy;
					    u_xlat4.xy = mix(vec2(0.0, 0.0), vec2(1.0, 1.0), vec2(u_xlatb4.xy));
					    u_xlatb1.xy = greaterThanEqual(_ClipRect.zwzz, vs_TEXCOORD1.xyxx).xy;
					    u_xlat1.xy = mix(vec2(0.0, 0.0), vec2(1.0, 1.0), vec2(u_xlatb1.xy));
					    u_xlat4.xy = u_xlat4.xy * u_xlat1.xy;
					    u_xlat4.x = u_xlat4.y * u_xlat4.x;
					    u_xlat10_1 = texture2D(_MainTex, vs_TEXCOORD0.xy);
					    u_xlat1 = u_xlat10_1 + _TextureSampleAdd;
					    u_xlat1 = u_xlat1 * vs_COLOR0;
					    u_xlat4.x = u_xlat4.x * u_xlat1.w;
					    u_xlat1.w = u_xlat0.x * u_xlat4.x;
					    SV_Target0 = u_xlat1;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier00 " {
					Keywords { "UNITY_UI_CLIP_RECT" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	mediump vec4 _Color;
					uniform 	vec4 _MainTex_ST;
					in highp vec4 in_POSITION0;
					in highp vec4 in_COLOR0;
					in highp vec2 in_TEXCOORD0;
					out mediump vec4 vs_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp vec4 vs_TEXCOORD1;
					vec4 u_xlat0;
					vec4 u_xlat1;
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
					    u_xlat0 = in_COLOR0 * _Color;
					    vs_COLOR0 = u_xlat0;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    vs_TEXCOORD1 = in_POSITION0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _ScreenParams;
					uniform 	float _Stencil;
					uniform 	mediump vec4 _MaskInteraction;
					uniform 	mediump vec4 _TextureSampleAdd;
					uniform 	vec4 _ClipRect;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _SoftMaskTex;
					in mediump vec4 vs_COLOR0;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_TEXCOORD1;
					layout(location = 0) out mediump vec4 SV_Target0;
					vec4 u_xlat0;
					bvec4 u_xlatb0;
					vec4 u_xlat1;
					mediump vec4 u_xlat16_1;
					bvec4 u_xlatb1;
					vec4 u_xlat2;
					mediump vec4 u_xlat16_2;
					vec4 u_xlat3;
					bvec4 u_xlatb3;
					vec2 u_xlat4;
					bvec2 u_xlatb4;
					void main()
					{
					vec4 hlslcc_FragCoord = vec4(gl_FragCoord.xyz, 1.0/gl_FragCoord.w);
					    u_xlatb0 = greaterThanEqual(_MaskInteraction.xxyy, vec4(1.0, 2.0, 1.0, 2.0));
					    u_xlat0 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb0));
					    u_xlatb1 = greaterThanEqual(vec4(_Stencil), vec4(1.0, 3.0, 7.0, 15.0));
					    u_xlat1 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb1));
					    u_xlat0 = u_xlat0 * u_xlat1.xxyy;
					    u_xlat1.xy = hlslcc_FragCoord.xy / _ScreenParams.xy;
					    u_xlat16_2 = texture(_SoftMaskTex, u_xlat1.xy);
					    u_xlat2 = u_xlat16_2 + vec4(-1.0, -1.0, -1.0, -1.0);
					    u_xlat0.xz = u_xlat0.xz * u_xlat2.xy + vec2(1.0, 1.0);
					    u_xlat1.xy = u_xlat0.xz * vec2(-2.0, -2.0) + vec2(1.0, 1.0);
					    u_xlat0.xy = u_xlat0.yw * u_xlat1.xy + u_xlat0.xz;
					    u_xlat0.x = u_xlat0.y * u_xlat0.x;
					    u_xlatb3 = greaterThanEqual(_MaskInteraction.zzww, vec4(1.0, 2.0, 1.0, 2.0));
					    u_xlat3 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb3));
					    u_xlat1 = u_xlat1.zzww * u_xlat3;
					    u_xlat4.xy = u_xlat1.xz * u_xlat2.zw + vec2(1.0, 1.0);
					    u_xlat1.xz = u_xlat4.xy * vec2(-2.0, -2.0) + vec2(1.0, 1.0);
					    u_xlat4.xy = u_xlat1.yw * u_xlat1.xz + u_xlat4.xy;
					    u_xlat0.x = u_xlat4.x * u_xlat0.x;
					    u_xlat0.x = u_xlat4.y * u_xlat0.x;
					    u_xlatb4.xy = greaterThanEqual(vs_TEXCOORD1.xyxx, _ClipRect.xyxx).xy;
					    u_xlat4.xy = mix(vec2(0.0, 0.0), vec2(1.0, 1.0), vec2(u_xlatb4.xy));
					    u_xlatb1.xy = greaterThanEqual(_ClipRect.zwzz, vs_TEXCOORD1.xyxx).xy;
					    u_xlat1.xy = mix(vec2(0.0, 0.0), vec2(1.0, 1.0), vec2(u_xlatb1.xy));
					    u_xlat4.xy = u_xlat4.xy * u_xlat1.xy;
					    u_xlat4.x = u_xlat4.y * u_xlat4.x;
					    u_xlat16_1 = texture(_MainTex, vs_TEXCOORD0.xy);
					    u_xlat1 = u_xlat16_1 + _TextureSampleAdd;
					    u_xlat1 = u_xlat1 * vs_COLOR0;
					    u_xlat4.x = u_xlat4.x * u_xlat1.w;
					    u_xlat1.w = u_xlat0.x * u_xlat4.x;
					    SV_Target0 = u_xlat1;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier01 " {
					Keywords { "UNITY_UI_CLIP_RECT" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	mediump vec4 _Color;
					uniform 	vec4 _MainTex_ST;
					in highp vec4 in_POSITION0;
					in highp vec4 in_COLOR0;
					in highp vec2 in_TEXCOORD0;
					out mediump vec4 vs_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp vec4 vs_TEXCOORD1;
					vec4 u_xlat0;
					vec4 u_xlat1;
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
					    u_xlat0 = in_COLOR0 * _Color;
					    vs_COLOR0 = u_xlat0;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    vs_TEXCOORD1 = in_POSITION0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _ScreenParams;
					uniform 	float _Stencil;
					uniform 	mediump vec4 _MaskInteraction;
					uniform 	mediump vec4 _TextureSampleAdd;
					uniform 	vec4 _ClipRect;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _SoftMaskTex;
					in mediump vec4 vs_COLOR0;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_TEXCOORD1;
					layout(location = 0) out mediump vec4 SV_Target0;
					vec4 u_xlat0;
					bvec4 u_xlatb0;
					vec4 u_xlat1;
					mediump vec4 u_xlat16_1;
					bvec4 u_xlatb1;
					vec4 u_xlat2;
					mediump vec4 u_xlat16_2;
					vec4 u_xlat3;
					bvec4 u_xlatb3;
					vec2 u_xlat4;
					bvec2 u_xlatb4;
					void main()
					{
					vec4 hlslcc_FragCoord = vec4(gl_FragCoord.xyz, 1.0/gl_FragCoord.w);
					    u_xlatb0 = greaterThanEqual(_MaskInteraction.xxyy, vec4(1.0, 2.0, 1.0, 2.0));
					    u_xlat0 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb0));
					    u_xlatb1 = greaterThanEqual(vec4(_Stencil), vec4(1.0, 3.0, 7.0, 15.0));
					    u_xlat1 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb1));
					    u_xlat0 = u_xlat0 * u_xlat1.xxyy;
					    u_xlat1.xy = hlslcc_FragCoord.xy / _ScreenParams.xy;
					    u_xlat16_2 = texture(_SoftMaskTex, u_xlat1.xy);
					    u_xlat2 = u_xlat16_2 + vec4(-1.0, -1.0, -1.0, -1.0);
					    u_xlat0.xz = u_xlat0.xz * u_xlat2.xy + vec2(1.0, 1.0);
					    u_xlat1.xy = u_xlat0.xz * vec2(-2.0, -2.0) + vec2(1.0, 1.0);
					    u_xlat0.xy = u_xlat0.yw * u_xlat1.xy + u_xlat0.xz;
					    u_xlat0.x = u_xlat0.y * u_xlat0.x;
					    u_xlatb3 = greaterThanEqual(_MaskInteraction.zzww, vec4(1.0, 2.0, 1.0, 2.0));
					    u_xlat3 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb3));
					    u_xlat1 = u_xlat1.zzww * u_xlat3;
					    u_xlat4.xy = u_xlat1.xz * u_xlat2.zw + vec2(1.0, 1.0);
					    u_xlat1.xz = u_xlat4.xy * vec2(-2.0, -2.0) + vec2(1.0, 1.0);
					    u_xlat4.xy = u_xlat1.yw * u_xlat1.xz + u_xlat4.xy;
					    u_xlat0.x = u_xlat4.x * u_xlat0.x;
					    u_xlat0.x = u_xlat4.y * u_xlat0.x;
					    u_xlatb4.xy = greaterThanEqual(vs_TEXCOORD1.xyxx, _ClipRect.xyxx).xy;
					    u_xlat4.xy = mix(vec2(0.0, 0.0), vec2(1.0, 1.0), vec2(u_xlatb4.xy));
					    u_xlatb1.xy = greaterThanEqual(_ClipRect.zwzz, vs_TEXCOORD1.xyxx).xy;
					    u_xlat1.xy = mix(vec2(0.0, 0.0), vec2(1.0, 1.0), vec2(u_xlatb1.xy));
					    u_xlat4.xy = u_xlat4.xy * u_xlat1.xy;
					    u_xlat4.x = u_xlat4.y * u_xlat4.x;
					    u_xlat16_1 = texture(_MainTex, vs_TEXCOORD0.xy);
					    u_xlat1 = u_xlat16_1 + _TextureSampleAdd;
					    u_xlat1 = u_xlat1 * vs_COLOR0;
					    u_xlat4.x = u_xlat4.x * u_xlat1.w;
					    u_xlat1.w = u_xlat0.x * u_xlat4.x;
					    SV_Target0 = u_xlat1;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier02 " {
					Keywords { "UNITY_UI_CLIP_RECT" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	mediump vec4 _Color;
					uniform 	vec4 _MainTex_ST;
					in highp vec4 in_POSITION0;
					in highp vec4 in_COLOR0;
					in highp vec2 in_TEXCOORD0;
					out mediump vec4 vs_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp vec4 vs_TEXCOORD1;
					vec4 u_xlat0;
					vec4 u_xlat1;
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
					    u_xlat0 = in_COLOR0 * _Color;
					    vs_COLOR0 = u_xlat0;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    vs_TEXCOORD1 = in_POSITION0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _ScreenParams;
					uniform 	float _Stencil;
					uniform 	mediump vec4 _MaskInteraction;
					uniform 	mediump vec4 _TextureSampleAdd;
					uniform 	vec4 _ClipRect;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _SoftMaskTex;
					in mediump vec4 vs_COLOR0;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_TEXCOORD1;
					layout(location = 0) out mediump vec4 SV_Target0;
					vec4 u_xlat0;
					bvec4 u_xlatb0;
					vec4 u_xlat1;
					mediump vec4 u_xlat16_1;
					bvec4 u_xlatb1;
					vec4 u_xlat2;
					mediump vec4 u_xlat16_2;
					vec4 u_xlat3;
					bvec4 u_xlatb3;
					vec2 u_xlat4;
					bvec2 u_xlatb4;
					void main()
					{
					vec4 hlslcc_FragCoord = vec4(gl_FragCoord.xyz, 1.0/gl_FragCoord.w);
					    u_xlatb0 = greaterThanEqual(_MaskInteraction.xxyy, vec4(1.0, 2.0, 1.0, 2.0));
					    u_xlat0 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb0));
					    u_xlatb1 = greaterThanEqual(vec4(_Stencil), vec4(1.0, 3.0, 7.0, 15.0));
					    u_xlat1 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb1));
					    u_xlat0 = u_xlat0 * u_xlat1.xxyy;
					    u_xlat1.xy = hlslcc_FragCoord.xy / _ScreenParams.xy;
					    u_xlat16_2 = texture(_SoftMaskTex, u_xlat1.xy);
					    u_xlat2 = u_xlat16_2 + vec4(-1.0, -1.0, -1.0, -1.0);
					    u_xlat0.xz = u_xlat0.xz * u_xlat2.xy + vec2(1.0, 1.0);
					    u_xlat1.xy = u_xlat0.xz * vec2(-2.0, -2.0) + vec2(1.0, 1.0);
					    u_xlat0.xy = u_xlat0.yw * u_xlat1.xy + u_xlat0.xz;
					    u_xlat0.x = u_xlat0.y * u_xlat0.x;
					    u_xlatb3 = greaterThanEqual(_MaskInteraction.zzww, vec4(1.0, 2.0, 1.0, 2.0));
					    u_xlat3 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb3));
					    u_xlat1 = u_xlat1.zzww * u_xlat3;
					    u_xlat4.xy = u_xlat1.xz * u_xlat2.zw + vec2(1.0, 1.0);
					    u_xlat1.xz = u_xlat4.xy * vec2(-2.0, -2.0) + vec2(1.0, 1.0);
					    u_xlat4.xy = u_xlat1.yw * u_xlat1.xz + u_xlat4.xy;
					    u_xlat0.x = u_xlat4.x * u_xlat0.x;
					    u_xlat0.x = u_xlat4.y * u_xlat0.x;
					    u_xlatb4.xy = greaterThanEqual(vs_TEXCOORD1.xyxx, _ClipRect.xyxx).xy;
					    u_xlat4.xy = mix(vec2(0.0, 0.0), vec2(1.0, 1.0), vec2(u_xlatb4.xy));
					    u_xlatb1.xy = greaterThanEqual(_ClipRect.zwzz, vs_TEXCOORD1.xyxx).xy;
					    u_xlat1.xy = mix(vec2(0.0, 0.0), vec2(1.0, 1.0), vec2(u_xlatb1.xy));
					    u_xlat4.xy = u_xlat4.xy * u_xlat1.xy;
					    u_xlat4.x = u_xlat4.y * u_xlat4.x;
					    u_xlat16_1 = texture(_MainTex, vs_TEXCOORD0.xy);
					    u_xlat1 = u_xlat16_1 + _TextureSampleAdd;
					    u_xlat1 = u_xlat1 * vs_COLOR0;
					    u_xlat4.x = u_xlat4.x * u_xlat1.w;
					    u_xlat1.w = u_xlat0.x * u_xlat4.x;
					    SV_Target0 = u_xlat1;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier00 " {
					Keywords { "UNITY_UI_ALPHACLIP" "UNITY_UI_CLIP_RECT" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	mediump vec4 _Color;
					uniform 	vec4 _MainTex_ST;
					attribute highp vec4 in_POSITION0;
					attribute highp vec4 in_COLOR0;
					attribute highp vec2 in_TEXCOORD0;
					varying mediump vec4 vs_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_TEXCOORD1;
					vec4 u_xlat0;
					vec4 u_xlat1;
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
					    u_xlat0 = in_COLOR0 * _Color;
					    vs_COLOR0 = u_xlat0;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    vs_TEXCOORD1 = in_POSITION0;
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
					uniform 	vec4 _ScreenParams;
					uniform 	float _Stencil;
					uniform 	mediump vec4 _MaskInteraction;
					uniform 	mediump vec4 _TextureSampleAdd;
					uniform 	vec4 _ClipRect;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _SoftMaskTex;
					varying mediump vec4 vs_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_TEXCOORD1;
					#define SV_Target0 gl_FragData[0]
					vec4 u_xlat0;
					bvec4 u_xlatb0;
					vec4 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec4 u_xlat2;
					mediump float u_xlat16_2;
					bvec4 u_xlatb2;
					vec4 u_xlat3;
					bvec4 u_xlatb3;
					vec4 u_xlat4;
					lowp vec4 u_xlat10_4;
					vec2 u_xlat5;
					bool u_xlatb5;
					vec2 u_xlat10;
					void main()
					{
					vec4 hlslcc_FragCoord = vec4(gl_FragCoord.xyz, 1.0/gl_FragCoord.w);
					    u_xlatb0.xy = greaterThanEqual(vs_TEXCOORD1.xyxx, _ClipRect.xyxx).xy;
					    u_xlatb0.zw = greaterThanEqual(_ClipRect.zzzw, vs_TEXCOORD1.xxxy).zw;
					    u_xlat0 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb0));
					    u_xlat0.xy = u_xlat0.zw * u_xlat0.xy;
					    u_xlat0.x = u_xlat0.y * u_xlat0.x;
					    u_xlat10_1 = texture2D(_MainTex, vs_TEXCOORD0.xy);
					    u_xlat1 = u_xlat10_1 + _TextureSampleAdd;
					    u_xlat1 = u_xlat1 * vs_COLOR0;
					    u_xlat16_2 = u_xlat1.w * u_xlat0.x + -0.00100000005;
					    u_xlat0.x = u_xlat0.x * u_xlat1.w;
					    u_xlatb5 = u_xlat16_2<0.0;
					    if(((int(u_xlatb5) * -1))!=0){discard;}
					    u_xlatb2 = greaterThanEqual(_MaskInteraction.xxyy, vec4(1.0, 2.0, 1.0, 2.0));
					    u_xlat2 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb2));
					    u_xlatb3 = greaterThanEqual(vec4(_Stencil), vec4(1.0, 3.0, 7.0, 15.0));
					    u_xlat3 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb3));
					    u_xlat2 = u_xlat2 * u_xlat3.xxyy;
					    u_xlat5.xy = hlslcc_FragCoord.xy / _ScreenParams.xy;
					    u_xlat10_4 = texture2D(_SoftMaskTex, u_xlat5.xy);
					    u_xlat4 = u_xlat10_4 + vec4(-1.0, -1.0, -1.0, -1.0);
					    u_xlat5.xy = u_xlat2.xz * u_xlat4.xy + vec2(1.0, 1.0);
					    u_xlat3.xy = u_xlat5.xy * vec2(-2.0, -2.0) + vec2(1.0, 1.0);
					    u_xlat5.xy = u_xlat2.yw * u_xlat3.xy + u_xlat5.xy;
					    u_xlat5.x = u_xlat5.y * u_xlat5.x;
					    u_xlatb2 = greaterThanEqual(_MaskInteraction.zzww, vec4(1.0, 2.0, 1.0, 2.0));
					    u_xlat2 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb2));
					    u_xlat2 = u_xlat2 * u_xlat3.zzww;
					    u_xlat10.xy = u_xlat2.xz * u_xlat4.zw + vec2(1.0, 1.0);
					    u_xlat3.xy = u_xlat10.xy * vec2(-2.0, -2.0) + vec2(1.0, 1.0);
					    u_xlat10.xy = u_xlat2.yw * u_xlat3.xy + u_xlat10.xy;
					    u_xlat5.x = u_xlat10.x * u_xlat5.x;
					    u_xlat5.x = u_xlat10.y * u_xlat5.x;
					    u_xlat1.w = u_xlat5.x * u_xlat0.x;
					    SV_Target0 = u_xlat1;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier01 " {
					Keywords { "UNITY_UI_ALPHACLIP" "UNITY_UI_CLIP_RECT" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	mediump vec4 _Color;
					uniform 	vec4 _MainTex_ST;
					attribute highp vec4 in_POSITION0;
					attribute highp vec4 in_COLOR0;
					attribute highp vec2 in_TEXCOORD0;
					varying mediump vec4 vs_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_TEXCOORD1;
					vec4 u_xlat0;
					vec4 u_xlat1;
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
					    u_xlat0 = in_COLOR0 * _Color;
					    vs_COLOR0 = u_xlat0;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    vs_TEXCOORD1 = in_POSITION0;
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
					uniform 	vec4 _ScreenParams;
					uniform 	float _Stencil;
					uniform 	mediump vec4 _MaskInteraction;
					uniform 	mediump vec4 _TextureSampleAdd;
					uniform 	vec4 _ClipRect;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _SoftMaskTex;
					varying mediump vec4 vs_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_TEXCOORD1;
					#define SV_Target0 gl_FragData[0]
					vec4 u_xlat0;
					bvec4 u_xlatb0;
					vec4 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec4 u_xlat2;
					mediump float u_xlat16_2;
					bvec4 u_xlatb2;
					vec4 u_xlat3;
					bvec4 u_xlatb3;
					vec4 u_xlat4;
					lowp vec4 u_xlat10_4;
					vec2 u_xlat5;
					bool u_xlatb5;
					vec2 u_xlat10;
					void main()
					{
					vec4 hlslcc_FragCoord = vec4(gl_FragCoord.xyz, 1.0/gl_FragCoord.w);
					    u_xlatb0.xy = greaterThanEqual(vs_TEXCOORD1.xyxx, _ClipRect.xyxx).xy;
					    u_xlatb0.zw = greaterThanEqual(_ClipRect.zzzw, vs_TEXCOORD1.xxxy).zw;
					    u_xlat0 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb0));
					    u_xlat0.xy = u_xlat0.zw * u_xlat0.xy;
					    u_xlat0.x = u_xlat0.y * u_xlat0.x;
					    u_xlat10_1 = texture2D(_MainTex, vs_TEXCOORD0.xy);
					    u_xlat1 = u_xlat10_1 + _TextureSampleAdd;
					    u_xlat1 = u_xlat1 * vs_COLOR0;
					    u_xlat16_2 = u_xlat1.w * u_xlat0.x + -0.00100000005;
					    u_xlat0.x = u_xlat0.x * u_xlat1.w;
					    u_xlatb5 = u_xlat16_2<0.0;
					    if(((int(u_xlatb5) * -1))!=0){discard;}
					    u_xlatb2 = greaterThanEqual(_MaskInteraction.xxyy, vec4(1.0, 2.0, 1.0, 2.0));
					    u_xlat2 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb2));
					    u_xlatb3 = greaterThanEqual(vec4(_Stencil), vec4(1.0, 3.0, 7.0, 15.0));
					    u_xlat3 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb3));
					    u_xlat2 = u_xlat2 * u_xlat3.xxyy;
					    u_xlat5.xy = hlslcc_FragCoord.xy / _ScreenParams.xy;
					    u_xlat10_4 = texture2D(_SoftMaskTex, u_xlat5.xy);
					    u_xlat4 = u_xlat10_4 + vec4(-1.0, -1.0, -1.0, -1.0);
					    u_xlat5.xy = u_xlat2.xz * u_xlat4.xy + vec2(1.0, 1.0);
					    u_xlat3.xy = u_xlat5.xy * vec2(-2.0, -2.0) + vec2(1.0, 1.0);
					    u_xlat5.xy = u_xlat2.yw * u_xlat3.xy + u_xlat5.xy;
					    u_xlat5.x = u_xlat5.y * u_xlat5.x;
					    u_xlatb2 = greaterThanEqual(_MaskInteraction.zzww, vec4(1.0, 2.0, 1.0, 2.0));
					    u_xlat2 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb2));
					    u_xlat2 = u_xlat2 * u_xlat3.zzww;
					    u_xlat10.xy = u_xlat2.xz * u_xlat4.zw + vec2(1.0, 1.0);
					    u_xlat3.xy = u_xlat10.xy * vec2(-2.0, -2.0) + vec2(1.0, 1.0);
					    u_xlat10.xy = u_xlat2.yw * u_xlat3.xy + u_xlat10.xy;
					    u_xlat5.x = u_xlat10.x * u_xlat5.x;
					    u_xlat5.x = u_xlat10.y * u_xlat5.x;
					    u_xlat1.w = u_xlat5.x * u_xlat0.x;
					    SV_Target0 = u_xlat1;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles hw_tier02 " {
					Keywords { "UNITY_UI_ALPHACLIP" "UNITY_UI_CLIP_RECT" }
					"!!GLES
					#ifdef VERTEX
					#version 100
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	mediump vec4 _Color;
					uniform 	vec4 _MainTex_ST;
					attribute highp vec4 in_POSITION0;
					attribute highp vec4 in_COLOR0;
					attribute highp vec2 in_TEXCOORD0;
					varying mediump vec4 vs_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_TEXCOORD1;
					vec4 u_xlat0;
					vec4 u_xlat1;
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
					    u_xlat0 = in_COLOR0 * _Color;
					    vs_COLOR0 = u_xlat0;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    vs_TEXCOORD1 = in_POSITION0;
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
					uniform 	vec4 _ScreenParams;
					uniform 	float _Stencil;
					uniform 	mediump vec4 _MaskInteraction;
					uniform 	mediump vec4 _TextureSampleAdd;
					uniform 	vec4 _ClipRect;
					uniform lowp sampler2D _MainTex;
					uniform lowp sampler2D _SoftMaskTex;
					varying mediump vec4 vs_COLOR0;
					varying highp vec2 vs_TEXCOORD0;
					varying highp vec4 vs_TEXCOORD1;
					#define SV_Target0 gl_FragData[0]
					vec4 u_xlat0;
					bvec4 u_xlatb0;
					vec4 u_xlat1;
					lowp vec4 u_xlat10_1;
					vec4 u_xlat2;
					mediump float u_xlat16_2;
					bvec4 u_xlatb2;
					vec4 u_xlat3;
					bvec4 u_xlatb3;
					vec4 u_xlat4;
					lowp vec4 u_xlat10_4;
					vec2 u_xlat5;
					bool u_xlatb5;
					vec2 u_xlat10;
					void main()
					{
					vec4 hlslcc_FragCoord = vec4(gl_FragCoord.xyz, 1.0/gl_FragCoord.w);
					    u_xlatb0.xy = greaterThanEqual(vs_TEXCOORD1.xyxx, _ClipRect.xyxx).xy;
					    u_xlatb0.zw = greaterThanEqual(_ClipRect.zzzw, vs_TEXCOORD1.xxxy).zw;
					    u_xlat0 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb0));
					    u_xlat0.xy = u_xlat0.zw * u_xlat0.xy;
					    u_xlat0.x = u_xlat0.y * u_xlat0.x;
					    u_xlat10_1 = texture2D(_MainTex, vs_TEXCOORD0.xy);
					    u_xlat1 = u_xlat10_1 + _TextureSampleAdd;
					    u_xlat1 = u_xlat1 * vs_COLOR0;
					    u_xlat16_2 = u_xlat1.w * u_xlat0.x + -0.00100000005;
					    u_xlat0.x = u_xlat0.x * u_xlat1.w;
					    u_xlatb5 = u_xlat16_2<0.0;
					    if(((int(u_xlatb5) * -1))!=0){discard;}
					    u_xlatb2 = greaterThanEqual(_MaskInteraction.xxyy, vec4(1.0, 2.0, 1.0, 2.0));
					    u_xlat2 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb2));
					    u_xlatb3 = greaterThanEqual(vec4(_Stencil), vec4(1.0, 3.0, 7.0, 15.0));
					    u_xlat3 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb3));
					    u_xlat2 = u_xlat2 * u_xlat3.xxyy;
					    u_xlat5.xy = hlslcc_FragCoord.xy / _ScreenParams.xy;
					    u_xlat10_4 = texture2D(_SoftMaskTex, u_xlat5.xy);
					    u_xlat4 = u_xlat10_4 + vec4(-1.0, -1.0, -1.0, -1.0);
					    u_xlat5.xy = u_xlat2.xz * u_xlat4.xy + vec2(1.0, 1.0);
					    u_xlat3.xy = u_xlat5.xy * vec2(-2.0, -2.0) + vec2(1.0, 1.0);
					    u_xlat5.xy = u_xlat2.yw * u_xlat3.xy + u_xlat5.xy;
					    u_xlat5.x = u_xlat5.y * u_xlat5.x;
					    u_xlatb2 = greaterThanEqual(_MaskInteraction.zzww, vec4(1.0, 2.0, 1.0, 2.0));
					    u_xlat2 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb2));
					    u_xlat2 = u_xlat2 * u_xlat3.zzww;
					    u_xlat10.xy = u_xlat2.xz * u_xlat4.zw + vec2(1.0, 1.0);
					    u_xlat3.xy = u_xlat10.xy * vec2(-2.0, -2.0) + vec2(1.0, 1.0);
					    u_xlat10.xy = u_xlat2.yw * u_xlat3.xy + u_xlat10.xy;
					    u_xlat5.x = u_xlat10.x * u_xlat5.x;
					    u_xlat5.x = u_xlat10.y * u_xlat5.x;
					    u_xlat1.w = u_xlat5.x * u_xlat0.x;
					    SV_Target0 = u_xlat1;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier00 " {
					Keywords { "UNITY_UI_ALPHACLIP" "UNITY_UI_CLIP_RECT" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	mediump vec4 _Color;
					uniform 	vec4 _MainTex_ST;
					in highp vec4 in_POSITION0;
					in highp vec4 in_COLOR0;
					in highp vec2 in_TEXCOORD0;
					out mediump vec4 vs_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp vec4 vs_TEXCOORD1;
					vec4 u_xlat0;
					vec4 u_xlat1;
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
					    u_xlat0 = in_COLOR0 * _Color;
					    vs_COLOR0 = u_xlat0;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    vs_TEXCOORD1 = in_POSITION0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _ScreenParams;
					uniform 	float _Stencil;
					uniform 	mediump vec4 _MaskInteraction;
					uniform 	mediump vec4 _TextureSampleAdd;
					uniform 	vec4 _ClipRect;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _SoftMaskTex;
					in mediump vec4 vs_COLOR0;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_TEXCOORD1;
					layout(location = 0) out mediump vec4 SV_Target0;
					vec4 u_xlat0;
					bvec4 u_xlatb0;
					vec4 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec4 u_xlat2;
					mediump float u_xlat16_2;
					bvec4 u_xlatb2;
					vec4 u_xlat3;
					bvec4 u_xlatb3;
					vec4 u_xlat4;
					mediump vec4 u_xlat16_4;
					vec2 u_xlat5;
					bool u_xlatb5;
					vec2 u_xlat10;
					void main()
					{
					vec4 hlslcc_FragCoord = vec4(gl_FragCoord.xyz, 1.0/gl_FragCoord.w);
					    u_xlatb0.xy = greaterThanEqual(vs_TEXCOORD1.xyxx, _ClipRect.xyxx).xy;
					    u_xlatb0.zw = greaterThanEqual(_ClipRect.zzzw, vs_TEXCOORD1.xxxy).zw;
					    u_xlat0 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb0));
					    u_xlat0.xy = u_xlat0.zw * u_xlat0.xy;
					    u_xlat0.x = u_xlat0.y * u_xlat0.x;
					    u_xlat16_1 = texture(_MainTex, vs_TEXCOORD0.xy);
					    u_xlat1 = u_xlat16_1 + _TextureSampleAdd;
					    u_xlat1 = u_xlat1 * vs_COLOR0;
					    u_xlat16_2 = u_xlat1.w * u_xlat0.x + -0.00100000005;
					    u_xlat0.x = u_xlat0.x * u_xlat1.w;
					#ifdef UNITY_ADRENO_ES3
					    u_xlatb5 = !!(u_xlat16_2<0.0);
					#else
					    u_xlatb5 = u_xlat16_2<0.0;
					#endif
					    if(((int(u_xlatb5) * int(0xffffffffu)))!=0){discard;}
					    u_xlatb2 = greaterThanEqual(_MaskInteraction.xxyy, vec4(1.0, 2.0, 1.0, 2.0));
					    u_xlat2 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb2));
					    u_xlatb3 = greaterThanEqual(vec4(_Stencil), vec4(1.0, 3.0, 7.0, 15.0));
					    u_xlat3 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb3));
					    u_xlat2 = u_xlat2 * u_xlat3.xxyy;
					    u_xlat5.xy = hlslcc_FragCoord.xy / _ScreenParams.xy;
					    u_xlat16_4 = texture(_SoftMaskTex, u_xlat5.xy);
					    u_xlat4 = u_xlat16_4 + vec4(-1.0, -1.0, -1.0, -1.0);
					    u_xlat5.xy = u_xlat2.xz * u_xlat4.xy + vec2(1.0, 1.0);
					    u_xlat3.xy = u_xlat5.xy * vec2(-2.0, -2.0) + vec2(1.0, 1.0);
					    u_xlat5.xy = u_xlat2.yw * u_xlat3.xy + u_xlat5.xy;
					    u_xlat5.x = u_xlat5.y * u_xlat5.x;
					    u_xlatb2 = greaterThanEqual(_MaskInteraction.zzww, vec4(1.0, 2.0, 1.0, 2.0));
					    u_xlat2 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb2));
					    u_xlat2 = u_xlat2 * u_xlat3.zzww;
					    u_xlat10.xy = u_xlat2.xz * u_xlat4.zw + vec2(1.0, 1.0);
					    u_xlat3.xy = u_xlat10.xy * vec2(-2.0, -2.0) + vec2(1.0, 1.0);
					    u_xlat10.xy = u_xlat2.yw * u_xlat3.xy + u_xlat10.xy;
					    u_xlat5.x = u_xlat10.x * u_xlat5.x;
					    u_xlat5.x = u_xlat10.y * u_xlat5.x;
					    u_xlat1.w = u_xlat5.x * u_xlat0.x;
					    SV_Target0 = u_xlat1;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier01 " {
					Keywords { "UNITY_UI_ALPHACLIP" "UNITY_UI_CLIP_RECT" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	mediump vec4 _Color;
					uniform 	vec4 _MainTex_ST;
					in highp vec4 in_POSITION0;
					in highp vec4 in_COLOR0;
					in highp vec2 in_TEXCOORD0;
					out mediump vec4 vs_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp vec4 vs_TEXCOORD1;
					vec4 u_xlat0;
					vec4 u_xlat1;
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
					    u_xlat0 = in_COLOR0 * _Color;
					    vs_COLOR0 = u_xlat0;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    vs_TEXCOORD1 = in_POSITION0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _ScreenParams;
					uniform 	float _Stencil;
					uniform 	mediump vec4 _MaskInteraction;
					uniform 	mediump vec4 _TextureSampleAdd;
					uniform 	vec4 _ClipRect;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _SoftMaskTex;
					in mediump vec4 vs_COLOR0;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_TEXCOORD1;
					layout(location = 0) out mediump vec4 SV_Target0;
					vec4 u_xlat0;
					bvec4 u_xlatb0;
					vec4 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec4 u_xlat2;
					mediump float u_xlat16_2;
					bvec4 u_xlatb2;
					vec4 u_xlat3;
					bvec4 u_xlatb3;
					vec4 u_xlat4;
					mediump vec4 u_xlat16_4;
					vec2 u_xlat5;
					bool u_xlatb5;
					vec2 u_xlat10;
					void main()
					{
					vec4 hlslcc_FragCoord = vec4(gl_FragCoord.xyz, 1.0/gl_FragCoord.w);
					    u_xlatb0.xy = greaterThanEqual(vs_TEXCOORD1.xyxx, _ClipRect.xyxx).xy;
					    u_xlatb0.zw = greaterThanEqual(_ClipRect.zzzw, vs_TEXCOORD1.xxxy).zw;
					    u_xlat0 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb0));
					    u_xlat0.xy = u_xlat0.zw * u_xlat0.xy;
					    u_xlat0.x = u_xlat0.y * u_xlat0.x;
					    u_xlat16_1 = texture(_MainTex, vs_TEXCOORD0.xy);
					    u_xlat1 = u_xlat16_1 + _TextureSampleAdd;
					    u_xlat1 = u_xlat1 * vs_COLOR0;
					    u_xlat16_2 = u_xlat1.w * u_xlat0.x + -0.00100000005;
					    u_xlat0.x = u_xlat0.x * u_xlat1.w;
					#ifdef UNITY_ADRENO_ES3
					    u_xlatb5 = !!(u_xlat16_2<0.0);
					#else
					    u_xlatb5 = u_xlat16_2<0.0;
					#endif
					    if(((int(u_xlatb5) * int(0xffffffffu)))!=0){discard;}
					    u_xlatb2 = greaterThanEqual(_MaskInteraction.xxyy, vec4(1.0, 2.0, 1.0, 2.0));
					    u_xlat2 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb2));
					    u_xlatb3 = greaterThanEqual(vec4(_Stencil), vec4(1.0, 3.0, 7.0, 15.0));
					    u_xlat3 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb3));
					    u_xlat2 = u_xlat2 * u_xlat3.xxyy;
					    u_xlat5.xy = hlslcc_FragCoord.xy / _ScreenParams.xy;
					    u_xlat16_4 = texture(_SoftMaskTex, u_xlat5.xy);
					    u_xlat4 = u_xlat16_4 + vec4(-1.0, -1.0, -1.0, -1.0);
					    u_xlat5.xy = u_xlat2.xz * u_xlat4.xy + vec2(1.0, 1.0);
					    u_xlat3.xy = u_xlat5.xy * vec2(-2.0, -2.0) + vec2(1.0, 1.0);
					    u_xlat5.xy = u_xlat2.yw * u_xlat3.xy + u_xlat5.xy;
					    u_xlat5.x = u_xlat5.y * u_xlat5.x;
					    u_xlatb2 = greaterThanEqual(_MaskInteraction.zzww, vec4(1.0, 2.0, 1.0, 2.0));
					    u_xlat2 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb2));
					    u_xlat2 = u_xlat2 * u_xlat3.zzww;
					    u_xlat10.xy = u_xlat2.xz * u_xlat4.zw + vec2(1.0, 1.0);
					    u_xlat3.xy = u_xlat10.xy * vec2(-2.0, -2.0) + vec2(1.0, 1.0);
					    u_xlat10.xy = u_xlat2.yw * u_xlat3.xy + u_xlat10.xy;
					    u_xlat5.x = u_xlat10.x * u_xlat5.x;
					    u_xlat5.x = u_xlat10.y * u_xlat5.x;
					    u_xlat1.w = u_xlat5.x * u_xlat0.x;
					    SV_Target0 = u_xlat1;
					    return;
					}
					
					#endif"
				}
				SubProgram "gles3 hw_tier02 " {
					Keywords { "UNITY_UI_ALPHACLIP" "UNITY_UI_CLIP_RECT" }
					"!!GLES3
					#ifdef VERTEX
					#version 300 es
					
					uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
					uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
					uniform 	mediump vec4 _Color;
					uniform 	vec4 _MainTex_ST;
					in highp vec4 in_POSITION0;
					in highp vec4 in_COLOR0;
					in highp vec2 in_TEXCOORD0;
					out mediump vec4 vs_COLOR0;
					out highp vec2 vs_TEXCOORD0;
					out highp vec4 vs_TEXCOORD1;
					vec4 u_xlat0;
					vec4 u_xlat1;
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
					    u_xlat0 = in_COLOR0 * _Color;
					    vs_COLOR0 = u_xlat0;
					    vs_TEXCOORD0.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					    vs_TEXCOORD1 = in_POSITION0;
					    return;
					}
					
					#endif
					#ifdef FRAGMENT
					#version 300 es
					
					precision highp float;
					precision highp int;
					uniform 	vec4 _ScreenParams;
					uniform 	float _Stencil;
					uniform 	mediump vec4 _MaskInteraction;
					uniform 	mediump vec4 _TextureSampleAdd;
					uniform 	vec4 _ClipRect;
					uniform mediump sampler2D _MainTex;
					uniform mediump sampler2D _SoftMaskTex;
					in mediump vec4 vs_COLOR0;
					in highp vec2 vs_TEXCOORD0;
					in highp vec4 vs_TEXCOORD1;
					layout(location = 0) out mediump vec4 SV_Target0;
					vec4 u_xlat0;
					bvec4 u_xlatb0;
					vec4 u_xlat1;
					mediump vec4 u_xlat16_1;
					vec4 u_xlat2;
					mediump float u_xlat16_2;
					bvec4 u_xlatb2;
					vec4 u_xlat3;
					bvec4 u_xlatb3;
					vec4 u_xlat4;
					mediump vec4 u_xlat16_4;
					vec2 u_xlat5;
					bool u_xlatb5;
					vec2 u_xlat10;
					void main()
					{
					vec4 hlslcc_FragCoord = vec4(gl_FragCoord.xyz, 1.0/gl_FragCoord.w);
					    u_xlatb0.xy = greaterThanEqual(vs_TEXCOORD1.xyxx, _ClipRect.xyxx).xy;
					    u_xlatb0.zw = greaterThanEqual(_ClipRect.zzzw, vs_TEXCOORD1.xxxy).zw;
					    u_xlat0 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb0));
					    u_xlat0.xy = u_xlat0.zw * u_xlat0.xy;
					    u_xlat0.x = u_xlat0.y * u_xlat0.x;
					    u_xlat16_1 = texture(_MainTex, vs_TEXCOORD0.xy);
					    u_xlat1 = u_xlat16_1 + _TextureSampleAdd;
					    u_xlat1 = u_xlat1 * vs_COLOR0;
					    u_xlat16_2 = u_xlat1.w * u_xlat0.x + -0.00100000005;
					    u_xlat0.x = u_xlat0.x * u_xlat1.w;
					#ifdef UNITY_ADRENO_ES3
					    u_xlatb5 = !!(u_xlat16_2<0.0);
					#else
					    u_xlatb5 = u_xlat16_2<0.0;
					#endif
					    if(((int(u_xlatb5) * int(0xffffffffu)))!=0){discard;}
					    u_xlatb2 = greaterThanEqual(_MaskInteraction.xxyy, vec4(1.0, 2.0, 1.0, 2.0));
					    u_xlat2 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb2));
					    u_xlatb3 = greaterThanEqual(vec4(_Stencil), vec4(1.0, 3.0, 7.0, 15.0));
					    u_xlat3 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb3));
					    u_xlat2 = u_xlat2 * u_xlat3.xxyy;
					    u_xlat5.xy = hlslcc_FragCoord.xy / _ScreenParams.xy;
					    u_xlat16_4 = texture(_SoftMaskTex, u_xlat5.xy);
					    u_xlat4 = u_xlat16_4 + vec4(-1.0, -1.0, -1.0, -1.0);
					    u_xlat5.xy = u_xlat2.xz * u_xlat4.xy + vec2(1.0, 1.0);
					    u_xlat3.xy = u_xlat5.xy * vec2(-2.0, -2.0) + vec2(1.0, 1.0);
					    u_xlat5.xy = u_xlat2.yw * u_xlat3.xy + u_xlat5.xy;
					    u_xlat5.x = u_xlat5.y * u_xlat5.x;
					    u_xlatb2 = greaterThanEqual(_MaskInteraction.zzww, vec4(1.0, 2.0, 1.0, 2.0));
					    u_xlat2 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb2));
					    u_xlat2 = u_xlat2 * u_xlat3.zzww;
					    u_xlat10.xy = u_xlat2.xz * u_xlat4.zw + vec2(1.0, 1.0);
					    u_xlat3.xy = u_xlat10.xy * vec2(-2.0, -2.0) + vec2(1.0, 1.0);
					    u_xlat10.xy = u_xlat2.yw * u_xlat3.xy + u_xlat10.xy;
					    u_xlat5.x = u_xlat10.x * u_xlat5.x;
					    u_xlat5.x = u_xlat10.y * u_xlat5.x;
					    u_xlat1.w = u_xlat5.x * u_xlat0.x;
					    SV_Target0 = u_xlat1;
					    return;
					}
					
					#endif"
				}
			}
			Program "fp" {
				SubProgram "gles hw_tier00 " {
					"!!GLES"
				}
				SubProgram "gles hw_tier01 " {
					"!!GLES"
				}
				SubProgram "gles hw_tier02 " {
					"!!GLES"
				}
				SubProgram "gles3 hw_tier00 " {
					"!!GLES3"
				}
				SubProgram "gles3 hw_tier01 " {
					"!!GLES3"
				}
				SubProgram "gles3 hw_tier02 " {
					"!!GLES3"
				}
				SubProgram "gles hw_tier00 " {
					Keywords { "UNITY_UI_ALPHACLIP" }
					"!!GLES"
				}
				SubProgram "gles hw_tier01 " {
					Keywords { "UNITY_UI_ALPHACLIP" }
					"!!GLES"
				}
				SubProgram "gles hw_tier02 " {
					Keywords { "UNITY_UI_ALPHACLIP" }
					"!!GLES"
				}
				SubProgram "gles3 hw_tier00 " {
					Keywords { "UNITY_UI_ALPHACLIP" }
					"!!GLES3"
				}
				SubProgram "gles3 hw_tier01 " {
					Keywords { "UNITY_UI_ALPHACLIP" }
					"!!GLES3"
				}
				SubProgram "gles3 hw_tier02 " {
					Keywords { "UNITY_UI_ALPHACLIP" }
					"!!GLES3"
				}
				SubProgram "gles hw_tier00 " {
					Keywords { "UNITY_UI_CLIP_RECT" }
					"!!GLES"
				}
				SubProgram "gles hw_tier01 " {
					Keywords { "UNITY_UI_CLIP_RECT" }
					"!!GLES"
				}
				SubProgram "gles hw_tier02 " {
					Keywords { "UNITY_UI_CLIP_RECT" }
					"!!GLES"
				}
				SubProgram "gles3 hw_tier00 " {
					Keywords { "UNITY_UI_CLIP_RECT" }
					"!!GLES3"
				}
				SubProgram "gles3 hw_tier01 " {
					Keywords { "UNITY_UI_CLIP_RECT" }
					"!!GLES3"
				}
				SubProgram "gles3 hw_tier02 " {
					Keywords { "UNITY_UI_CLIP_RECT" }
					"!!GLES3"
				}
				SubProgram "gles hw_tier00 " {
					Keywords { "UNITY_UI_ALPHACLIP" "UNITY_UI_CLIP_RECT" }
					"!!GLES"
				}
				SubProgram "gles hw_tier01 " {
					Keywords { "UNITY_UI_ALPHACLIP" "UNITY_UI_CLIP_RECT" }
					"!!GLES"
				}
				SubProgram "gles hw_tier02 " {
					Keywords { "UNITY_UI_ALPHACLIP" "UNITY_UI_CLIP_RECT" }
					"!!GLES"
				}
				SubProgram "gles3 hw_tier00 " {
					Keywords { "UNITY_UI_ALPHACLIP" "UNITY_UI_CLIP_RECT" }
					"!!GLES3"
				}
				SubProgram "gles3 hw_tier01 " {
					Keywords { "UNITY_UI_ALPHACLIP" "UNITY_UI_CLIP_RECT" }
					"!!GLES3"
				}
				SubProgram "gles3 hw_tier02 " {
					Keywords { "UNITY_UI_ALPHACLIP" "UNITY_UI_CLIP_RECT" }
					"!!GLES3"
				}
			}
		}
	}
}