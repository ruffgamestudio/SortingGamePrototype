// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Outline2D"
{
	Properties
	{
		[PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
		_Color ("Tint", Color) = (1,1,1,1)
		[MaterialToggle] PixelSnap ("Pixel snap", Float) = 0
		[PerRendererData] _AlphaTex ("External Alpha", 2D) = "white" {}
		_OutlineWidth("Outline Width", Range( 0 , 5)) = 5
		[Toggle(_OBJECTSCALE_DEPENDANT_ON)] _ObjectScale_Dependant("ObjectScale_Dependant", Float) = 0
		_TilingOffset("Tiling/Offset", Vector) = (1,1,0,0)
		_OutlineColor("Outline Color", Color) = (0,0,0,0)
		[Toggle(_REPLACEWITHCOLOR_ON)] _ReplaceWithColor("ReplaceWithColor", Float) = 0
		[KeywordEnum(Inner,Outer)] _Outline_Direction("Outline_Direction", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}

	SubShader
	{
		LOD 0

		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" "CanUseSpriteAtlas"="True" }

		Cull Off
		Lighting Off
		ZWrite Off
		Blend One OneMinusSrcAlpha
		
		
		Pass
		{
		CGPROGRAM
			
			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile _ PIXELSNAP_ON
			#pragma multi_compile _ ETC1_EXTERNAL_ALPHA
			#include "UnityCG.cginc"
			#define ASE_NEEDS_FRAG_COLOR
			#pragma shader_feature_local _OUTLINE_DIRECTION_INNER _OUTLINE_DIRECTION_OUTER
			#pragma shader_feature_local _OBJECTSCALE_DEPENDANT_ON
			#pragma shader_feature_local _REPLACEWITHCOLOR_ON


			struct appdata_t
			{
				float4 vertex   : POSITION;
				float4 color    : COLOR;
				float2 texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				
			};

			struct v2f
			{
				float4 vertex   : SV_POSITION;
				fixed4 color    : COLOR;
				float2 texcoord  : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				
			};
			
			uniform fixed4 _Color;
			uniform float _EnableExternalAlpha;
			uniform sampler2D _MainTex;
			uniform sampler2D _AlphaTex;
			uniform float4 _OutlineColor;
			uniform float _OutlineWidth;
			uniform float4 _MainTex_ST;
			uniform float4 _TilingOffset;

			
			v2f vert( appdata_t IN  )
			{
				v2f OUT;
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);
				UNITY_TRANSFER_INSTANCE_ID(IN, OUT);
				
				
				IN.vertex.xyz +=  float3(0,0,0) ; 
				OUT.vertex = UnityObjectToClipPos(IN.vertex);
				OUT.texcoord = IN.texcoord;
				OUT.color = IN.color * _Color;
				#ifdef PIXELSNAP_ON
				OUT.vertex = UnityPixelSnap (OUT.vertex);
				#endif

				return OUT;
			}

			fixed4 SampleSpriteTexture (float2 uv)
			{
				fixed4 color = tex2D (_MainTex, uv);

#if ETC1_EXTERNAL_ALPHA
				// get the color from an external texture (usecase: Alpha support for ETC1 on android)
				fixed4 alpha = tex2D (_AlphaTex, uv);
				color.a = lerp (color.a, alpha.r, _EnableExternalAlpha);
#endif //ETC1_EXTERNAL_ALPHA

				return color;
			}
			
			fixed4 frag(v2f IN  ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				float widthORI182 = _OutlineWidth;
				float2 uv_MainTex = IN.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 tex2DNode17 = tex2D( _MainTex, uv_MainTex );
				float4 tex2DNode1_g2 = tex2D( _MainTex, uv_MainTex );
				float2 appendResult84_g2 = (float2(_TilingOffset.x , _TilingOffset.y));
				float2 appendResult85_g2 = (float2(_TilingOffset.z , _TilingOffset.w));
				float2 texCoord83_g2 = IN.texcoord.xy * appendResult84_g2 + appendResult85_g2;
				float2 UV86_g2 = texCoord83_g2;
				float3 ase_objectScale = float3( length( unity_ObjectToWorld[ 0 ].xyz ), length( unity_ObjectToWorld[ 1 ].xyz ), length( unity_ObjectToWorld[ 2 ].xyz ) );
				#ifdef _OBJECTSCALE_DEPENDANT_ON
				float staticSwitch90_g2 = ase_objectScale.x;
				#else
				float staticSwitch90_g2 = 1.0;
				#endif
				float Width87_g2 = ( ( _OutlineWidth / 100.0 ) / staticSwitch90_g2 );
				float4 tex2DNode2_g2 = tex2D( _MainTex, ( UV86_g2 + ( Width87_g2 * float2( -1,0 ) ) ) );
				float4 tex2DNode4_g2 = tex2D( _MainTex, ( UV86_g2 + ( Width87_g2 * float2( 0,1 ) ) ) );
				float4 tex2DNode3_g2 = tex2D( _MainTex, ( UV86_g2 + ( Width87_g2 * float2( 0,-1 ) ) ) );
				float4 tex2DNode16_g2 = tex2D( _MainTex, ( UV86_g2 + ( Width87_g2 * float2( 1,1 ) ) ) );
				float4 tex2DNode17_g2 = tex2D( _MainTex, ( UV86_g2 + ( Width87_g2 * float2( 1,-1 ) ) ) );
				float4 tex2DNode18_g2 = tex2D( _MainTex, ( UV86_g2 + ( Width87_g2 * float2( -1,-1 ) ) ) );
				float4 tex2DNode19_g2 = tex2D( _MainTex, ( UV86_g2 + ( Width87_g2 * float2( -1,1 ) ) ) );
				float4 tex2DNode34_g2 = tex2D( _MainTex, ( UV86_g2 + ( Width87_g2 * float2( 1,0.5 ) ) ) );
				float4 tex2DNode35_g2 = tex2D( _MainTex, ( UV86_g2 + ( Width87_g2 * float2( 0.5,1 ) ) ) );
				float4 tex2DNode36_g2 = tex2D( _MainTex, ( UV86_g2 + ( Width87_g2 * float2( -0.5,1 ) ) ) );
				float4 tex2DNode37_g2 = tex2D( _MainTex, ( UV86_g2 + ( Width87_g2 * float2( -1,0.5 ) ) ) );
				float4 tex2DNode52_g2 = tex2D( _MainTex, ( UV86_g2 + ( Width87_g2 * float2( -1,-0.5 ) ) ) );
				float4 tex2DNode53_g2 = tex2D( _MainTex, ( UV86_g2 + ( Width87_g2 * float2( -0.5,-1 ) ) ) );
				float4 tex2DNode54_g2 = tex2D( _MainTex, ( UV86_g2 + ( Width87_g2 * float2( 0.5,-1 ) ) ) );
				float4 tex2DNode55_g2 = tex2D( _MainTex, ( UV86_g2 + ( Width87_g2 * float2( 1,-0.5 ) ) ) );
				#if defined(_OUTLINE_DIRECTION_INNER)
				float staticSwitch238 = ( tex2DNode1_g2.a * tex2DNode2_g2.a * tex2DNode4_g2.a * tex2DNode3_g2.a * ( tex2DNode16_g2.a * tex2DNode17_g2.a * tex2DNode18_g2.a * tex2DNode19_g2.a * ( tex2DNode34_g2.a * tex2DNode35_g2.a * tex2DNode36_g2.a * tex2DNode37_g2.a * ( tex2DNode52_g2.a * tex2DNode53_g2.a * tex2DNode54_g2.a * tex2DNode55_g2.a ) ) ) );
				#elif defined(_OUTLINE_DIRECTION_OUTER)
				float staticSwitch238 = ( tex2DNode1_g2.a + tex2DNode2_g2.a + tex2DNode4_g2.a + tex2DNode3_g2.a + ( tex2DNode16_g2.a + tex2DNode17_g2.a + tex2DNode18_g2.a + tex2DNode19_g2.a + ( tex2DNode34_g2.a + tex2DNode35_g2.a + tex2DNode36_g2.a + tex2DNode37_g2.a + ( tex2DNode52_g2.a + tex2DNode53_g2.a + tex2DNode54_g2.a + tex2DNode55_g2.a ) ) ) );
				#else
				float staticSwitch238 = ( tex2DNode1_g2.a * tex2DNode2_g2.a * tex2DNode4_g2.a * tex2DNode3_g2.a * ( tex2DNode16_g2.a * tex2DNode17_g2.a * tex2DNode18_g2.a * tex2DNode19_g2.a * ( tex2DNode34_g2.a * tex2DNode35_g2.a * tex2DNode36_g2.a * tex2DNode37_g2.a * ( tex2DNode52_g2.a * tex2DNode53_g2.a * tex2DNode54_g2.a * tex2DNode55_g2.a ) ) ) );
				#endif
				float Outline233 = staticSwitch238;
				float temp_output_52_0 = saturate( Outline233 );
				#if defined(_OUTLINE_DIRECTION_INNER)
				float staticSwitch239 = ( tex2DNode17.a - temp_output_52_0 );
				#elif defined(_OUTLINE_DIRECTION_OUTER)
				float staticSwitch239 = ( temp_output_52_0 - tex2DNode17.a );
				#else
				float staticSwitch239 = ( tex2DNode17.a - temp_output_52_0 );
				#endif
				float ifLocalVar171 = 0;
				if( widthORI182 > 0.0 )
				ifLocalVar171 = staticSwitch239;
				float3 temp_output_20_0 = (IN.color).rgb;
				#ifdef _REPLACEWITHCOLOR_ON
				float3 staticSwitch243 = temp_output_20_0;
				#else
				float3 staticSwitch243 = (tex2DNode17).rgb;
				#endif
				float4 lerpResult47 = lerp( float4( staticSwitch243 , 0.0 ) , _OutlineColor , ( _OutlineColor.a * ifLocalVar171 ));
				float ifLocalVar179 = 0;
				if( widthORI182 > 0.0 )
				ifLocalVar179 = Outline233;
				float4 appendResult21 = (float4(( float4( temp_output_20_0 , 0.0 ) * lerpResult47 ).rgb , ( IN.color.a * saturate( ( tex2DNode17.a + ifLocalVar179 ) ) )));
				float4 lerpResult229 = lerp( ( _OutlineColor * ifLocalVar171 ) , appendResult21 , 1.0);
				
				fixed4 c = lerpResult229;
				c.rgb *= c.a;
				return c;
			}
		ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	Fallback "False"
}
/*ASEBEGIN
Version=18935
0;0;1280;672.3334;24.6513;446.4077;1.075071;True;False
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;13;-1566.9,-254.3001;Inherit;True;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;237;-1323.513,541.7841;Inherit;False;Outline;1;;2;683c23ffee125184187a079e09cb2017;0;1;78;SAMPLER2D;0;False;2;FLOAT;0;FLOAT;77
Node;AmplifyShaderEditor.StaticSwitch;238;-1013.649,650.1479;Inherit;False;Property;_Outline_Direction;Outline_Direction;7;0;Create;True;0;0;0;False;0;False;0;0;0;True;;KeywordEnum;2;Inner;Outer;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;233;-951.7496,514.9246;Inherit;False;Outline;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;234;-471.3226,525.0646;Inherit;False;233;Outline;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;52;-246.9634,377.682;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;17;-724.9343,-317.3208;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;29;-69.56525,993.8656;Inherit;False;Property;_OutlineWidth;Outline Width;0;0;Create;True;0;0;0;False;0;False;5;0.39;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;45;-84.5604,107.3257;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;240;-80.89169,252.0446;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;182;301.6883,989.3981;Inherit;False;widthORI;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;184;94.01249,515.5795;Inherit;False;182;widthORI;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;193;-222.9089,-921.8429;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;239;105.266,268.1281;Inherit;False;Property;_Keyword0;Keyword 0;7;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Reference;238;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;183;228.1315,-20.70749;Inherit;False;182;widthORI;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;171;465.3349,41.83395;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;18;-259.1285,-409.7607;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ConditionalIfNode;179;322.3836,521.357;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;20;49.87373,-854.3766;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;48;403.8492,-264.6359;Inherit;False;Property;_OutlineColor;Outline Color;5;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;44;670.4765,399.0984;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;243;71.01227,-505.8569;Inherit;False;Property;_ReplaceWithColor;ReplaceWithColor;6;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;258;662.3192,-67.26593;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;53;1039.033,383.0201;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;47;942.7911,-329.2546;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;1405.163,-279.7617;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;1418.815,-497.9667;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;245;1772.565,330.3998;Inherit;False;Constant;_Float1;Float 1;13;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;21;1877.705,-89.18384;Inherit;False;COLOR;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;89;1880.078,-1.607391;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;229;2188.539,-1.991498;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;11;2901.388,-30.17831;Float;False;True;-1;2;ASEMaterialInspector;0;8;Outline2D;0f8ba0101102bb14ebf021ddadce9b49;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;2;False;True;3;1;False;-1;10;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;True;5;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;CanUseSpriteAtlas=True;False;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;0;False;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;237;78;13;0
WireConnection;238;1;237;0
WireConnection;238;0;237;77
WireConnection;233;0;238;0
WireConnection;52;0;234;0
WireConnection;17;0;13;0
WireConnection;45;0;52;0
WireConnection;45;1;17;4
WireConnection;240;0;17;4
WireConnection;240;1;52;0
WireConnection;182;0;29;0
WireConnection;239;1;240;0
WireConnection;239;0;45;0
WireConnection;171;0;183;0
WireConnection;171;2;239;0
WireConnection;18;0;17;0
WireConnection;179;0;184;0
WireConnection;179;2;234;0
WireConnection;20;0;193;0
WireConnection;44;0;17;4
WireConnection;44;1;179;0
WireConnection;243;1;18;0
WireConnection;243;0;20;0
WireConnection;258;0;48;4
WireConnection;258;1;171;0
WireConnection;53;0;44;0
WireConnection;47;0;243;0
WireConnection;47;1;48;0
WireConnection;47;2;258;0
WireConnection;22;0;193;4
WireConnection;22;1;53;0
WireConnection;12;0;20;0
WireConnection;12;1;47;0
WireConnection;21;0;12;0
WireConnection;21;3;22;0
WireConnection;89;0;48;0
WireConnection;89;1;171;0
WireConnection;229;0;89;0
WireConnection;229;1;21;0
WireConnection;229;2;245;0
WireConnection;11;0;229;0
ASEEND*/
//CHKSM=713F17D3157B053B132AF2E9C272A38A40C0C05A