Shader "Custom/EasyStandardShader" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("BaseColor (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness (R)", 2D) = "black" {}
		//_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic (R)", 2D) = "black" {}
		_Normal ("Normal (RGB)", 2D) = "bumb" {}
		//_Emission ("Emission (RGB)", 2D) = "black" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _Glossiness;
		sampler2D _Metallic;
		sampler2D _Normal;
		//sampler2D _Emission;

		struct Input {
			float2 uv_MainTex;
		};

		//half _Glossiness;
		//half _Metallic;
		fixed4 _Color;

		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			fixed4 g = tex2D (_Glossiness, IN.uv_MainTex);
			fixed4 m = tex2D (_Metallic, IN.uv_MainTex);
			//fixed4 n = UnpackNormal (tex2D (_Normal, IN.uv_MainTex));
			//fixed4 e = tex2D (_Emission, IN.uv_MainTex);
			o.Albedo = c.rgb;
			// Metallic and smoothness come from slider variables
			o.Metallic = m.r;
			o.Smoothness = g.r;
			//o.Smoothness = _Glossiness;
			o.Normal = UnpackNormal (tex2D (_Normal, IN.uv_MainTex));
			//o.Emission = e;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
