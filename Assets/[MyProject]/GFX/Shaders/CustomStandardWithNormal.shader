Shader "Custom/CustomStandardWithNormal" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
		_NormalMap ("Normal Map (RGB)", 2D) = "bump" {}

		_DetailNormal ("Detail Normal Map (RGB)", 2D) = "bump" {}
		_DetailIntensity ("Detail Normal Intensity", Range(0,3)) = 1.0
		_Inversion ("Detail Normal Inversion", Range(-1,1)) = 1.0
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
		sampler2D _NormalMap;
		sampler2D _DetailNormal;

		struct Input {
			float2 uv_MainTex;
			float2 uv_DetailNormal;
		};

		half _Glossiness;
		half _Metallic;
		half _DetailIntensity;
		half _Inversion;
		fixed4 _Color;

		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
			//fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			fixed3 n = UnpackNormal (tex2D (_NormalMap, IN.uv_MainTex));
			fixed3 dn = UnpackNormal (tex2D (_DetailNormal, IN.uv_DetailNormal));
			fixed3 norm;
			norm.r = (_Inversion - ((_Inversion * n.r * 2) - 0.5))/1.5;
			norm.g = (_Inversion - ((_Inversion * n.g  * 2) - 0.5))/1.5;
			norm.b = n.b ;
			norm = (_Inversion - ((_Inversion * n.rgb * 2) - 0.5))/1.5;

			o.Albedo = c.rgb;
			//o.Albedo = (_Inversion - ((_Inversion * c.rgb * 2) - 0.5))/1.5;
			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Normal = norm;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
