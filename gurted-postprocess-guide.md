# Gurted Postprocess Effects - Design Guide

## Overview

The `<postprocess>` tag in Gurted enables real-time visual effects applied to entire webpages through GPU-accelerated shaders. These effects render as overlays on top of content without affecting browser UI, providing professional visual enhancement capabilities.

## Key Concepts

### What is Postprocess?
- **GPU-Accelerated**: All effects use Godot's shader system for optimal performance
- **Webpage Overlay**: Effects apply to the entire page content as a visual layer
- **Real-time Rendering**: Dynamic effects that can be animated and interactive
- **Browser UI Preservation**: Effects don't interfere with navigation or controls

### Three Implementation Methods

1. **Built-in Presets**: Ready-to-use effects with customizable parameters
2. **External Shader Files**: Custom `.gdshader` files for complex effects
3. **Inline Shader Code**: GDShader code directly in HTML for simple customizations

## Usage Patterns

### Basic Preset Usage
```html
<!-- Simple preset application -->
<postprocess preset="crt" />

<!-- Preset with custom parameters -->
<postprocess preset="vignette" vignette_strength="1.5" inner_radius="0.2" />

<!-- Multiple effects can be layered -->
<postprocess preset="film" grain_amount="0.08" />
<postprocess preset="vignette" vignette_strength="0.8" />
```

### External Shader Files
```html
<!-- Loading custom shader -->
<postprocess src="custom-shader.gdshader" />

<!-- With parameters -->
<postprocess src="casino-glow.gdshader" intensity="2.0" color="#ff6b35" />
```

### Inline Shader Code
```html
<postprocess>
shader_type canvas_item;

void fragment() {
    COLOR = texture(SCREEN_TEXTURE, SCREEN_UV);
    // Custom shader logic here
}
</postprocess>
```

## Parameter Types & Syntax

### Numeric Values
```html
<!-- Float values (decimals) -->
<postprocess preset="vignette" vignette_strength="1.5" />
<postprocess preset="film" grain_amount="0.05" />

<!-- Integer values (whole numbers) -->
<postprocess preset="snowfall" num_of_layers="25" />
<postprocess preset="chrome" levels="3" />

<!-- Boolean values -->
<postprocess preset="custom" enable_effect="true" />
```

### Vector Types
```html
<!-- Vector2 - Two dimensional coordinates/values -->
<postprocess preset="rblur" blur_center="Vector2(0.3, 0.7)" />
<postprocess preset="rblur" blur_center="vec2(0.3, 0.7)" />

<!-- Vector3 - RGB color or 3D coordinates -->
<postprocess preset="lensflare" tint="Vector3(1.4, 1.2, 1.0)" />
<postprocess preset="lensflare" tint="vec3(1.4, 1.2, 1.0)" />

<!-- Vector4 - RGBA color or 4D coordinates -->
<postprocess preset="vignette" vignette_color="Vector4(0.0, 0.0, 0.0, 1.0)" />
<postprocess preset="vignette" vignette_color="vec4(0.0, 0.0, 0.0, 1.0)" />
```

### Color Values
```html
<!-- Hex colors -->
<postprocess preset="vignette" vignette_color="#ff0000" />
<postprocess preset="snowfall" snow_color="#ffffff" />

<!-- Named colors -->
<postprocess preset="snowfall" snow_color="white" />
<postprocess preset="pencil" u_bgColor="black" />
```

## Built-in Preset Library

### 🖥️ CRT Monitor Effect
**Use Case**: Retro gaming websites, vintage aesthetics, nostalgic designs

```html
<postprocess preset="crt" />
```

**Key Parameters**:
- `curvature` (0.0-10.0, default: 2.0) - Screen curvature amount
- `vignette_strength` (0.0-2.0, default: 1.0) - Dark edge intensity
- `scanlines_opacity` (0.0-2.0, default: 1.0) - Scanline visibility
- `scanline_thickness` (0.0-0.6, default: 0.5) - Line thickness
- `image_flicker` (0.0-1.0, default: 1.0) - Screen flicker intensity

**Design Applications**:
- Retro gaming sites
- Arcade-style interfaces
- Vintage computer terminals
- 80s/90s themed designs

### 🎬 Film Grain Effect
**Use Case**: Cinematic websites, photography portfolios, vintage aesthetics

```html
<postprocess preset="film" grain_amount="0.05" grain_size="1.0" />
```

**Key Parameters**:
- `grain_amount` (0.0-1.0, default: 0.05) - Noise intensity
- `grain_size` (0.1-10.0, default: 1.0) - Grain particle size

**Design Applications**:
- Photography websites
- Film/cinema portfolios
- Vintage-themed designs
- Artistic presentations

### 🔍 Vignette Effect
**Use Case**: Focus attention, dramatic lighting, professional photography look

```html
<postprocess preset="vignette" vignette_strength="1.0" inner_radius="0.1" />
```

**Key Parameters**:
- `inner_radius` (0.0-1.0, default: 0.1) - Inner edge position
- `outer_radius` (0.0-1.0, default: 1.0) - Outer edge position
- `vignette_strength` (0.0-2.0, default: 1.0) - Darkening intensity
- `vignette_color` (color, default: black) - Vignette overlay color
- `dither_strength` (0.0-1.0, default: 0.03) - Anti-banding noise

**Design Applications**:
- Portrait photography sites
- Dramatic presentations
- Focus-driven interfaces
- Professional portfolios

### ✏️ Pencil Drawing Effect
**Use Case**: Artistic websites, sketch portfolios, creative presentations

```html
<postprocess preset="pencil" u_threshold1="0.75" u_bgColor="white" />
```

**Key Parameters**:
- `u_threshold1` to `u_threshold4` (0.0-1.0) - Line detection sensitivity
- `u_bgColor` (color, default: white) - Paper background color
- `u_patternColor` (color, default: black) - Pencil line color
- `u_bgColorFactor` (0.0-1.0, default: 0.4) - Background blend amount

**Design Applications**:
- Art portfolio websites
- Sketch galleries
- Creative agency sites
- Educational drawing tools

### ❄️ Snowfall Effect
**Use Case**: Winter themes, holiday websites, atmospheric effects

```html
<postprocess preset="snowfall" num_of_layers="40" speed="0.5" />
```

**Key Parameters**:
- `spread` (0.0-1.5, default: 0.5) - Horizontal distribution
- `size` (0.01-5.0, default: 0.5) - Snowflake size
- `speed` (0.0-10.0, default: 0.5) - Falling speed
- `wind` (-2.0-2.0, default: 0.0) - Horizontal wind effect
- `num_of_layers` (integer, default: 40) - Depth layers
- `snow_color` (color, default: white) - Particle color

**Design Applications**:
- Holiday websites
- Winter sports sites
- Christmas themes
- Atmospheric backgrounds

### 🌈 Chromatic Aberration Effect
**Use Case**: Glitch aesthetics, cyberpunk themes, digital art

```html
<postprocess preset="chrome" levels="3" spread="0.01" />
```

**Key Parameters**:
- `levels` (integer, default: 3) - Color separation levels
- `spread` (float, default: 0.01) - Channel separation amount

**Design Applications**:
- Cyberpunk websites
- Glitch art presentations
- Digital art portfolios
- Tech/gaming sites

### 💫 Radial Blur Effect
**Use Case**: Speed effects, focus attention, motion graphics

```html
<postprocess preset="rblur" blur_center="vec2(0.5, 0.5)" blur_power="0.01" />
```

**Key Parameters**:
- `blur_center` (Vector2, default: vec2(0.5, 0.5)) - Blur origin point
- `blur_power` (0.0-1.0, default: 0.01) - Blur intensity
- `sampling_count` (1-64, default: 2) - Quality/smoothness

**Design Applications**:
- Speed/motion websites
- Racing game interfaces
- Action sports sites
- Dynamic presentations

### ✨ Lens Flare Effect
**Use Case**: Cinematic effects, bright interfaces, sunlight themes

```html
<postprocess preset="lensflare" sun_position="vec2(400.0, 0.0)" />
```

**Key Parameters**:
- `sun_position` (Vector2, default: vec2(400.0, 0.0)) - Light source position
- `tint` (Vector3, default: vec3(1.4, 1.2, 1.0)) - Color tint

**Design Applications**:
- Photography websites
- Cinematic presentations
- Bright/sunny themes
- Professional portfolios

### 🌿 Foliage Sway Effect
**Use Case**: Nature themes, organic movement, fluid interfaces

```html
<postprocess preset="foliage" x_intensity="3.0" speed="2.0" />
```

**Key Parameters**:
- `x_intensity` (float, default: 3.0) - Horizontal sway intensity
- `y_intensity` (float, default: 0.5) - Vertical sway intensity
- `speed` (0-20, default: 2.0) - Animation speed
- `wave_frequency` (0-100, default: 20) - Wave oscillation frequency
- `wave_length` (50-800, default: 200.0) - Wave pattern length

**Design Applications**:
- Nature/outdoor websites
- Organic/fluid interfaces
- Environmental themes
- Relaxing/meditative sites

### 🎮 Dithering Effect
**Use Case**: Retro gaming, pixel art, vintage computer aesthetics

```html
<postprocess preset="dither" pixel="1.0" />
```

**Key Parameters**:
- `pixel` (float, default: 1.0) - Pixel size for dithering pattern

**Note**: Colors are hardcoded to rusty tint due to GDShader limitations

**Design Applications**:
- Retro gaming sites
- Pixel art galleries
- Vintage computer themes
- 8-bit style interfaces

## Design Strategy & Best Practices

### 1. **Effect Layering**
```html
<!-- Subtle atmospheric layering -->
<postprocess preset="film" grain_amount="0.03" />
<postprocess preset="vignette" vignette_strength="0.6" />

<!-- Dramatic gaming effect -->
<postprocess preset="chrome" levels="2" spread="0.005" />
<postprocess preset="crt" curvature="1.5" />
```

### 2. **Performance Considerations**
- **GPU-Accelerated**: All effects use hardware acceleration
- **Layering Impact**: Multiple effects can impact performance
- **Parameter Optimization**: Higher quality settings (like `sampling_count`) affect performance
- **Mobile Consideration**: Test effects on lower-end devices

### 3. **Design Context Matching**

#### Gaming/Entertainment Sites
```html
<!-- Retro arcade feel -->
<postprocess preset="crt" curvature="2.0" scanlines_opacity="1.0" />

<!-- Modern gaming glitch -->
<postprocess preset="chrome" levels="3" spread="0.008" />
```

#### Professional/Portfolio Sites
```html
<!-- Subtle film grain for sophistication -->
<postprocess preset="film" grain_amount="0.02" grain_size="0.8" />

<!-- Focus attention with vignette -->
<postprocess preset="vignette" vignette_strength="0.8" inner_radius="0.15" />
```

#### Artistic/Creative Sites
```html
<!-- Pencil sketch aesthetic -->
<postprocess preset="pencil" u_threshold1="0.8" u_bgColor="white" />

<!-- Dynamic sway for organic feel -->
<postprocess preset="foliage" x_intensity="2.0" speed="1.5" />
```

### 4. **Seasonal/Thematic Applications**
```html
<!-- Winter holiday theme -->
<postprocess preset="snowfall" num_of_layers="30" speed="0.3" wind="0.2" />

<!-- Summer/bright theme -->
<postprocess preset="lensflare" sun_position="vec2(300.0, 100.0)" />
```

### 5. **Interactive Effects**
- Effects can be controlled via JavaScript/Lua scripting
- Parameters can be animated or changed dynamically
- User preferences can toggle effects on/off

## Common Design Patterns

### Gambling Site Effects
```html
<!-- Subtle sophistication -->
<postprocess preset="film" grain_amount="0.025" />
<postprocess preset="vignette" vignette_strength="0.7" vignette_color="#001122" />

<!-- Neon gaming feel -->
<postprocess preset="chrome" levels="2" spread="0.003" />
```

### Portfolio Enhancement
```html
<!-- Professional photography -->
<postprocess preset="vignette" vignette_strength="1.2" inner_radius="0.2" />

<!-- Artistic sketch style -->
<postprocess preset="pencil" u_threshold1="0.85" u_patternColor="#333333" />
```

### Atmospheric Backgrounds
```html
<!-- Gentle movement -->
<postprocess preset="foliage" x_intensity="1.5" y_intensity="0.3" speed="1.0" />

<!-- Seasonal ambiance -->
<postprocess preset="snowfall" num_of_layers="20" size="0.3" speed="0.4" />
```

## Integration with Gurted Framework

### Combining with UI Elements
- Postprocess effects don't interfere with interactive elements
- Effects apply after UI rendering
- Hover states and animations work normally under effects

### Performance with Complex Layouts
- Flexbox layouts render normally under effects
- Custom fonts and styling are preserved
- Color schemes may need adjustment under certain effects

### Mobile Responsiveness
- Effects scale with viewport
- Consider disabling intensive effects on mobile
- Test battery impact on mobile devices

## Troubleshooting & Optimization

### Common Issues
1. **Effect Too Subtle**: Increase intensity parameters
2. **Performance Issues**: Reduce quality settings or layer count
3. **Color Conflicts**: Adjust effect colors to match theme
4. **Mobile Problems**: Implement device-specific effect settings

### Optimization Tips
- Use lower `sampling_count` for mobile devices
- Layer complementary effects rather than conflicting ones
- Test across different screen sizes and devices
- Consider user preferences for accessibility

This guide provides the framework for creating sophisticated visual experiences in Gurted applications while maintaining performance and usability standards.
