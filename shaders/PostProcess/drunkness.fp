#define SPEED 1.0

void main()
{
    vec2 uv = TexCoord.xy;

    float t = ViewTimer * SPEED;
    float phase = RandomSeed * 6.28318;
    float dir = (RandomSeed > 0.5) ? 1.0 : -1.0;

    float envelope = sin(DV_Progress * 3.14159265);
    float intensity = clamp((DrunkLevel - 20.0) / 50.0, 0.0, 1.0);

    float driftX = sin(t + phase) * abs(DV_OffsetX);
    float driftY = cos(t * 0.85 + phase) * abs(DV_OffsetY);

    vec2 baseShift = vec2(driftX, driftY) * envelope * (1.3 + intensity * 1.7);

    vec4 base = texture(InputTexture, uv);
    vec4 color;

// doubles
    if (DrunkLevel < 50.0)
    {
        vec4 ghost = texture(InputTexture, clamp(uv + baseShift, 0.0, 1.0));
        float w = mix(0.3, 0.6, intensity) * envelope;
        color = mix(base, ghost, w);
    }

// triples
    else if (DrunkLevel < 70.0)
    {
        vec4 g1 = texture(InputTexture, clamp(uv + baseShift, 0.0, 1.0));
        vec4 g2 = texture(InputTexture, clamp(uv - baseShift, 0.0, 1.0));
        color = (base + g1 + g2) / 3.0;
    }

// triangle circling
    else if (DrunkLevel < 80.0)
    {
        float rotSpeed = (0.15 + intensity * 0.2) * mix(0.7, 1.3, RandomSeed);
        float angleOffset = phase + t * rotSpeed * dir;

        float radius = length(baseShift);

        vec2 dir1 = vec2(cos(angleOffset), sin(angleOffset));
        vec2 dir2 = vec2(cos(angleOffset + 2.0944), sin(angleOffset + 2.0944));
        vec2 dir3 = vec2(cos(angleOffset + 4.1888), sin(angleOffset + 4.1888));

        vec4 g1 = texture(InputTexture, clamp(uv + dir1 * radius, 0.0, 1.0));
        vec4 g2 = texture(InputTexture, clamp(uv + dir2 * radius, 0.0, 1.0));
        vec4 g3 = texture(InputTexture, clamp(uv + dir3 * radius, 0.0, 1.0));

        color = (base + g1 + g2 + g3) / 4.0;
    }

// drunken carousel of hell
    else
    {
        float rotSpeed = (0.2 + intensity * 0.3) * mix(0.7, 1.3, RandomSeed);
        float angleOffset = phase + t * rotSpeed * dir;

        float radius = length(baseShift);

        vec2 d1 = vec2(cos(angleOffset), sin(angleOffset));
        vec2 d2 = vec2(cos(angleOffset + 1.5708), sin(angleOffset + 1.5708));
        vec2 d3 = vec2(cos(angleOffset + 3.14159), sin(angleOffset + 3.14159));
        vec2 d4 = vec2(cos(angleOffset + 4.71239), sin(angleOffset + 4.71239));

        vec4 g1 = texture(InputTexture, clamp(uv + d1 * radius, 0.0, 1.0));
        vec4 g2 = texture(InputTexture, clamp(uv + d2 * radius, 0.0, 1.0));
        vec4 g3 = texture(InputTexture, clamp(uv + d3 * radius, 0.0, 1.0));
        vec4 g4 = texture(InputTexture, clamp(uv + d4 * radius, 0.0, 1.0));

        color = (base + g1 + g2 + g3 + g4) / 5.0;
    }

///////////////// UNCOMMENT THIS IF YOU WANT CHANGING COLORS ////////////////

//     float wave = envelope;
//     float satAmount = 1.0 + intensity * 0.7 * wave;
//     float contrast = 1.0 + intensity * 0.6 * wave;
//     float luminance = dot(color.rgb, vec3(0.299, 0.587, 0.114));
//     vec3 gray = vec3(luminance);
//     color.rgb = mix(gray, color.rgb, satAmount);
//     color.rgb = mix(vec3(luminance), color.rgb, contrast);
//     color.rgb *= 1.0 + intensity * 0.02 * wave;
//     color.rgb = clamp(color.rgb, 0.0, 1.0);

    FragColor = color;
}