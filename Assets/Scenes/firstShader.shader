Shader "Custom/NewSurfaceShader" 
{
    Properties
    {
        _PrimaryColor ("Primary color", Color) = (1,1,1,1)
        _SecondaryColor ("Secondary color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
            float3 worldPos;
        };

        //half tipe data 16 bit
        half _Glossiness;
        half _Metallic;

        //fixed4 tipe data 11 bit
        fixed4 _PrimaryColor;
        fixed4 _SecondaryColor;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            //menggabungkan nilai warna dari sebuah tekstur dengan warna primer yang ditentukan oleh variabel _PrimaryColor
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _PrimaryColor;

            //mengatur hasilnya sebagai warna albedo yang mungkin akan digunakan dalam pengaturan visual pada shader.
            o.Albedo = c.xyz;
    
            //inisiasi waktu
            float deltaTime = 2.0;

            //menyesuaikan posisi terkini
            float currPos = (_Time.y % deltaTime) / deltaTime;

                
                float currPos2 = (1 - ((_Time.y % deltaTime) / deltaTime) * 2);

                //menyimpan nilai absolut dari currPos2 dalam tipe data float
                float currPos2_abs = abs(currPos2);
                if (IN.worldPos.y + 0.5 < currPos2_abs)
                {
                    //membuat warna merah dari line atas hingga bawah
                    if (currPos2 > 0)
                    {
                        o.Albedo = fixed3(1.0, 0.0, 0.0);
                    }
                    //mengganti warna dari line bawah hingga atas
                    else
                    {
                        o.Albedo = fixed3(0.0, 1.0, 0.0);
                    }
                }
                //Membuat pergantian warna jika worldpos lebih kevil dari currpos2_abs
                else
                {
                    //mengganti warna dari line bawah hingga atas
                    if (currPos2 > 0)
                    {
                        o.Albedo = fixed3(1.0, 1.0, 0.0);
                    }
                    //mengganti warna dari line bawah hingga atas
                    else{
                        o.Albedo = fixed3(1.0, 0.0, 0.0);
                    }
                }

                //Untuk membuat garis hitam
                if (abs(IN.worldPos.y + 0.5 - currPos2_abs) < 0.05)
                {
                    o.Albedo = fixed3(0.0, 0.0, 0.0);
                }
                
        o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}