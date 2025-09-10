# Gurted Framework Context Documentation

## Overview

Gurted is a unique HTML/CSS framework that renders natively through **Flumi** (a Godot-based browser engine). It combines familiar HTML syntax with utility-first CSS styling (similar to Tailwind CSS) but renders with native performance through the Godot engine.

## Key Characteristics

### What Makes Gurted Different

- **Native Rendering**: Renders through Flumi (Godot engine) instead of traditional web browsers
- **Utility-First CSS**: Uses Tailwind-like utility classes but with custom implementation
- **GURT Protocol**: Supports `gurt://` protocol links alongside standard `https://`
- **Custom Font System**: Advanced web font loading with `<font>` tag
- **Browser-Grade Flexbox**: Full flexbox support via Yoga layout engine
- **Pixel Scaling**: Different pixel scaling (24px = 16px in standard browsers)

## HTML Standard

### Document Structure

```html
<head>
    <title>My Gurted Page</title>
    <icon src="https://example.com/icon.png">
    <meta name="theme-color" content="#1a202c">
    <meta name="description" content="Page description">

    <font name="roboto" src="https://fonts.gstatic.com/.../roboto.woff2" />
    <style>/* CSS rules */</style>
    <script src="script.lua" />
</head>
<body>
    <!-- Content goes here -->
</body>
```

### Text Elements

#### Headers

- `<h1>` → `text-5xl font-bold` (72px)
- `<h2>` → `text-4xl font-bold` (54px)
- `<h3>` → `text-3xl font-bold` (45px)
- `<h4>` → `text-2xl font-bold` (36px)
- `<h5>` → `text-xl font-bold` (30px)
- `<h6>` → `text-base font-bold` (24px)

#### Inline Elements

- `<b>` → Bold text
- `<i>` → Italic text
- `<u>` → Underlined text
- `<small>` → Small text (21px)
- `<mark>` → Highlighted text (yellow background)
- `<code>` → Monospace font
- `<span>` → Generic inline container

#### Links

```html
<a href="https://example.com">External link</a>
<a href="gurt://internal.site">GURT protocol link</a>
```

### Container Elements

#### Division Elements

```html
<div style="flex flex-col gap-4 p-4 bg-[#f8fafc] rounded">
  <h2>Content Area</h2>
  <p>Container content</p>
</div>
```

#### Separators

```html
<separator />
<!-- Horizontal separator (default) -->
<separator direction="horizontal" />
<separator direction="vertical" />
```

### List Elements

#### Unordered Lists

```html
<ul>
  <!-- Default disc bullets -->
  <ul type="circle">
    <!-- Circle bullets -->
    <ul type="square">
      <!-- Square bullets -->
      <ul type="none">
        <!-- No bullets -->
      </ul>
    </ul>
  </ul>
</ul>
```

#### Ordered Lists

```html
<ol>
  <!-- Default decimal: 1, 2, 3... -->
  <ol type="zero-lead">
    <!-- Zero-padded: 01, 02, 03... -->
    <ol type="lower-alpha">
      <!-- Lowercase letters: a, b, c... -->
      <ol type="upper-alpha">
        <!-- Uppercase letters: A, B, C... -->
        <ol type="lower-roman">
          <!-- Lowercase Roman: i, ii, iii... -->
          <ol type="upper-roman">
            <!-- Uppercase Roman: I, II, III... -->
          </ol>
        </ol>
      </ol>
    </ol>
  </ol>
</ol>
```

### Form Elements

#### Input Types

```html
<!-- Text Input -->
<input
  type="text"
  placeholder="Enter your name"
  value="John"
  maxlength="20"
  minlength="3"
/>

<!-- Password Input -->
<input type="password" placeholder="Your password..." />

<!-- Email Input -->
<input
  type="email"
  placeholder="Enter your email address"
  pattern="^[^@\s]+@[^@\s]+\.[^@\s]+$"
/>

<!-- Checkbox -->
<input type="checkbox" />
<input type="checkbox" value="true" checked="true" />

<!-- Radio Buttons -->
<input type="radio" group="food" /><span>Pizza</span>
<input type="radio" group="food" /><span>Pasta</span>
<input type="radio" group="food" checked="true" /><span>Salad</span>

<!-- Color Picker -->
<input type="color" value="#ff0000" />

<!-- Date Picker -->
<input type="date" value="2024-01-15" />

<!-- Range Slider -->
<input
  type="range"
  min="0"
  max="100"
  step="5"
  value="50"
  style="max-w-32 max-h-8"
/>

<!-- Number Input -->
<input
  type="number"
  min="1"
  max="10"
  step="0.5"
  value="5"
  placeholder="Enter number"
/>

<!-- File Upload -->
<input type="file" accept=".txt,.pdf,image/*" />
```

#### Other Form Elements

```html
<!-- Buttons -->
<button>Normal Button</button>
<button disabled="true">Disabled Button</button>
<button type="submit">Submit Form</button>

<!-- Select Dropdown -->
<select style="text-center max-w-40 max-h-32">
  <option value="option1">Option 1</option>
  <option value="option2" selected="true">Option 2 (Selected)</option>
  <option value="option3">Option 3</option>
  <option value="option4" disabled="true">Option 4 (Disabled)</option>
</select>

<!-- Textarea -->
<textarea
  cols="30"
  rows="5"
  maxlength="200"
  placeholder="Enter your message..."
></textarea>
<textarea readonly="true">This text cannot be edited</textarea>
<textarea disabled="true" value="Disabled content"></textarea>
```

### Media Elements

```html
<!-- Images -->
<img src="https://example.com/image.jpg" style="max-w-24 max-h-24 rounded" />
<img src="gurt://local.site/image.png" style="w-32 h-32" />
```

## CSS Standard

### Integration Methods

```html
<head>
    <!-- Inline styles in head -->
    <style>
        h1 { text-[#ff0000] font-italic hover:text-[#00ff00] }
        p { text-[#333333] text-2xl }
        button { hover:bg-[#FF6B35] hover:text-[#FFFFFF] active:bg-[#CC5429] }
    </style>

    <!-- External stylesheet -->
    <style src="styles.css">
</head>
<body>
    <!-- Inline styles on elements -->
    <div style="flex flex-col gap-4 p-4 bg-[#f8fafc] rounded">
        <h1 style="text-3xl font-bold text-center">Styled Content</h1>
    </div>
</body>
```

### Typography

#### Font Sizes (Progressive Scaling)

- `text-xs` → 18px (Extra small - fine print, captions)
- `text-sm` → 21px (Small - secondary information)
- `text-base` → 24px (Base - default body text)
- `text-lg` → 27px (Large - slightly emphasized)
- `text-xl` → 30px (Extra large - small headings)
- `text-2xl` → 36px (2XL - medium headings)
- `text-3xl` → 45px (3XL - large headings)
- `text-4xl` → 54px (4XL - very large headings)
- `text-5xl` → 72px (5XL - display headings)
- `text-6xl` → 90px (6XL - hero headings)

**Note**: Flumi handles pixel sizes differently - 24px in Gurted = 16px in standard browsers

#### Font Families

- `font-sans` → Sans-serif (default, clean modern)
- `font-serif` → Serif (traditional with decorative strokes)
- `font-mono` → Monospace (fixed-width, ideal for code)
- `font-roboto` → Custom web font (requires `<font>` declaration)

#### Font Styling

- `font-bold` → Bold text
- `font-italic` → Italic text
- `underline` → Underlined text

#### Text Alignment

- `text-left` → Left aligned (default)
- `text-center` → Center aligned
- `text-right` → Right aligned
- `text-justify` → Justified text

### Colors

#### Color Systems

1. **Hex Colors**: `#ff0000`, `#00ff00`, `#0000ff`
2. **RGB Colors**: `rgb(255, 0, 0)`, `rgba(255, 0, 0, 0.5)`
3. **Predefined Palette**: `red-500`, `blue-600`, etc.

#### Usage Patterns

```html
<!-- Custom hex colors -->
<p style="text-[#ff0000]">Red text</p>
<div style="bg-[#f8fafc] p-4">Light gray background</div>

<!-- Predefined colors -->
<p style="text-red-500">Red 500</p>
<div style="bg-blue-500 text-white p-4">Blue background</div>
```

#### Color Scale (50-950)

- **50-200**: Very light tints (backgrounds)
- **300-400**: Light colors (subtle accents)
- **500-600**: Medium colors (primary elements)
- **700-800**: Dark colors (text, emphasis)
- **900-950**: Very dark colors (strong contrast)

#### Available Colors

Red, Orange, Amber, Yellow, Lime, Green, Emerald, Teal, Cyan, Sky, Blue, Indigo, Violet, Purple, Fuchsia, Pink, Rose, Slate, Gray, Zinc, Neutral, Stone

### Layout & Sizing

#### Spacing System

- **Scale**: Each number = 4px (`1` = 4px, `2` = 8px, `4` = 16px, `8` = 32px, `16` = 64px)

#### Dimensions

```html
<!-- Fixed sizes -->
<div style="w-16 h-16 bg-red-500">64x64px</div>
<div style="w-32 h-24 bg-blue-500">128x96px</div>

<!-- Custom pixel values -->
<div style="w-[200px] h-[100px] bg-green-500">200x100px</div>

<!-- Relative sizes -->
<div style="w-full h-32 bg-purple-500">Full width</div>
<div style="w-1/2 h-16 bg-yellow-500">Half width</div>

<!-- Min/max constraints -->
<div style="min-w-32 max-w-64 min-h-16 max-h-32 bg-pink-500"></div>
```

#### Spacing (Padding & Margin)

```html
<!-- Padding (internal spacing) -->
<div style="p-4 bg-gray-200">Padding all sides (16px)</div>
<div style="px-6 py-2 bg-gray-300">Horizontal 24px, vertical 8px</div>
<div style="pt-4 pr-3 pb-2 pl-1 bg-gray-400">Individual sides</div>

<!-- Margin (external spacing) -->
<div style="m-4 bg-red-200">Margin all sides (16px)</div>
<div style="mt-6 mb-4 bg-green-200">Top 24px, bottom 16px margin</div>

<!-- Custom spacing -->
<div style="p-[20px] m-[10px] bg-yellow-200">
  Custom 20px padding, 10px margin
</div>
```

#### Direction Shortcuts

- `p` = padding all sides
- `px` = padding left and right (x-axis)
- `py` = padding top and bottom (y-axis)
- `pt`, `pr`, `pb`, `pl` = individual sides
- Same pattern for margins with `m` prefix

### Flexbox System

Gurted implements browser-grade Flexbox via **Yoga layout engine**.

#### Container Properties

```html
<div style="flex">Basic flex container</div>
<div style="inline-flex">Inline flex container</div>
```

#### Direction & Wrap

```html
<!-- Direction -->
<div style="flex flex-row">Horizontal (default)</div>
<div style="flex flex-row-reverse">Reverse horizontal</div>
<div style="flex flex-col">Vertical layout</div>
<div style="flex flex-col-reverse">Reverse vertical</div>

<!-- Wrapping -->
<div style="flex flex-wrap">Allow wrapping</div>
<div style="flex flex-nowrap">No wrapping (default)</div>
<div style="flex flex-wrap-reverse">Reverse wrap</div>
```

#### Alignment

```html
<!-- Main axis (justify) -->
<div style="flex justify-start">Start alignment (default)</div>
<div style="flex justify-end">End alignment</div>
<div style="flex justify-center">Center alignment</div>
<div style="flex justify-between">Space between</div>
<div style="flex justify-around">Space around</div>
<div style="flex justify-evenly">Even space</div>

<!-- Cross axis (align) -->
<div style="flex items-start">Start cross-axis</div>
<div style="flex items-end">End cross-axis</div>
<div style="flex items-center">Center cross-axis</div>
<div style="flex items-baseline">Baseline alignment</div>
<div style="flex items-stretch">Stretch items (default)</div>
```

#### Gap & Spacing

```html
<div style="flex gap-2">8px gap between items</div>
<div style="flex gap-4">16px gap between items</div>
<div style="flex gap-[12px]">Custom 12px gap</div>
<div style="flex flex-col row-gap-2 col-gap-4">Directional gaps</div>
```

#### Item Properties

```html
<div style="flex">
  <div style="flex-grow-1">Grows to fill space</div>
  <div style="flex-grow-2">Grows twice as much</div>
  <div style="flex-shrink-0">Never shrinks</div>
  <div style="basis-32">Fixed 128px basis</div>
  <div style="self-start">Self alignment</div>
  <div style="order-3">Display order</div>
</div>
```

### Borders & Effects

#### Border Radius

```html
<div style="rounded bg-gray-300 p-4">Default 4px radius</div>
<div style="rounded-sm bg-gray-300 p-4">Small 2px radius</div>
<div style="rounded-md bg-gray-300 p-4">Medium 6px radius</div>
<div style="rounded-lg bg-gray-300 p-4">Large 8px radius</div>
<div style="rounded-xl bg-gray-300 p-4">Extra large 12px radius</div>
<div style="rounded-2xl bg-gray-300 p-4">2XL 16px radius</div>
<div style="rounded-3xl bg-gray-300 p-4">3XL 24px radius</div>
<div style="rounded-full bg-gray-300 p-4">Fully rounded (pill shape)</div>
<div style="rounded-[20px] bg-gray-300 p-4">Custom 20px radius</div>
```

#### Border System

```html
<!-- Border thickness -->
<div style="border p-2">Default 1px border</div>
<div style="border-2 p-2">2px border</div>
<div style="border-4 p-2">4px border</div>
<div style="border-[6px] p-2">Custom 6px border</div>

<!-- Border sides -->
<div style="border-t p-2">Top border only</div>
<div style="border-r p-2">Right border only</div>
<div style="border-b p-2">Bottom border only</div>
<div style="border-l p-2">Left border only</div>

<!-- Border styles -->
<div style="border border-solid p-2">Solid border (default)</div>
<div style="border-none p-2">No border</div>

<!-- Border colors -->
<div style="border-2 border-red-500 p-2">Red border</div>
<div style="border-2 border-[#3b82f6] p-2">Custom blue border</div>
<div style="border border-transparent p-2">Transparent border</div>
```

### Interactive States

#### Hover States

```html
<button
  style="bg-blue-500 text-white px-4 py-2 hover:bg-blue-600 hover:text-gray-100"
>
  Hover to change color
</button>

<div style="bg-gray-200 p-4 rounded hover:bg-gray-300">Hoverable container</div>
```

#### Active States

```html
<button
  style="bg-green-500 text-white px-4 py-2 rounded
               hover:bg-green-600 
               active:bg-green-700 active:text-gray-100"
>
  Click and hold to see active state
</button>
```

#### Cursor Control

```html
<div style="cursor-pointer p-4 bg-blue-100">pointer</div>
<div style="cursor-text p-4 bg-green-100">text</div>
<div style="cursor-default p-4 bg-yellow-100">default</div>
<div style="cursor-move p-4 bg-red-100">move</div>
<div style="cursor-crosshair p-4 bg-purple-100">crosshair</div>
<div style="cursor-help p-4 bg-pink-100">help</div>
<div style="cursor-not-allowed p-4 bg-gray-100">not-allowed</div>
```

### Advanced CSS Features

#### Opacity & Z-Index

```html
<div style="opacity-75 bg-red-500 text-white p-4">75% opacity</div>
<div style="opacity-50 bg-blue-500 text-white p-4">50% opacity</div>
<div style="opacity-[0.25] bg-green-500 text-white p-4">25% custom opacity</div>

<div style="z-10 bg-red-500 p-4">Z-index 10</div>
<div style="z-20 bg-blue-500 p-4">Z-index 20 (on top)</div>
<div style="z-[999] bg-green-500 p-4">Custom z-index 999</div>
```

#### CSS Selectors

```html
<head>
  <style>
    /* Descendant selectors */
    div p { text-[#663399] }
    .container span { bg-[#ffeeaa] }

    /* Direct child selectors */
    .outer > p { font-bold }
    .parent > button { bg-[#44cc88] }

    /* Adjacent sibling selectors */
    h1 + p { text-[#ff0000] font-bold }
    h2 + div { bg-[#eeffee] }

    /* General sibling selectors */
    h1 ~ p { text-[#0000ff] }
    h3 ~ span { bg-[#ffdddd] }

    /* Attribute selectors */
    input[type="text"] { border bg-[#f9f9f9] }
    a[href^="https"] { text-[#008000] font-bold }
    button[disabled] { bg-[#888888] text-[#cccccc] }
    input[placeholder*="email"] { border-2 border-[#0066cc] }
    div[style$="special"] { bg-[#ffffaa] }

    /* Pseudo-class selectors */
    button:hover { bg-[#2563eb] }
    input:focus { border-blue-500 }
    li:first-child { font-bold }
    li:last-child { text-red-500 }
  </style>
</head>
```

#### Class-Based Styling

```html
<head>
  <style>
    .card { bg-[#1e293b] text-white rounded-xl p-4 shadow-lg }
    .btn-primary { bg-[#3b82f6] text-white px-4 py-2 rounded hover:bg-[#2563eb] }
    .btn-success { bg-[#10b981] text-white px-4 py-2 rounded hover:bg-[#059669] }
  </style>
</head>
<body>
  <div class="card">
    <h2>Card Title</h2>
    <p>Card content</p>
    <button style="btn-primary">Primary Action</button>
    <button style="btn-success z-10">Success Action</button>
  </div>
</body>
```

**Note**: Classes are defined inside `style` attribute alongside inline styles, unlike traditional CSS.

### Custom Fonts

```html
<head>
  <font name="roboto" src="https://fonts.gstatic.com/.../roboto.woff2" />
  <font
    name="roboto"
    src="https://fonts.gstatic.com/.../roboto.woff2"
    weight="400"
  />

  <style>
    body { font-roboto }
    h1 { font-roboto text-3xl font-bold }
  </style>
</head>
```

### Default Styles

Gurted provides sensible defaults:

```css
/* Text elements */
body { text-base text-[#000000] text-left }
h1 { text-5xl font-bold }  /* 72px bold */
h2 { text-4xl font-bold }  /* 54px bold */
h3 { text-3xl font-bold }  /* 45px bold */
h4 { text-2xl font-bold }  /* 36px bold */
h5 { text-xl font-bold }   /* 30px bold */
h6 { text-base font-bold } /* 24px bold */

/* Text formatting */
b { font-bold }
i { font-italic }
u { underline }
small { text-sm }    /* 21px */
mark { bg-[#FFFF00] }
code { text-base font-mono }
pre { text-base font-mono }

/* Interactive elements */
a { text-[#1a0dab] }  /* Traditional blue */

/* Buttons */
button {
    bg-[#1b1b1b] rounded-md text-white
    hover:bg-[#2a2a2a]
    active:bg-[#101010]
}
button[disabled] {
    bg-[#666666] text-[#999999] cursor-not-allowed
}
```

## Best Practices

### 1. Styling Approach

- Use utility classes for rapid styling
- Combine inline styles with class-based styling for reusability
- Leverage the default styles as a foundation

### 2. Layout Strategy

- Use Flexbox for complex layouts (via Yoga engine)
- Utilize the spacing system consistently (4px increments)
- Consider responsive behavior with wrapping

### 3. Color Management

- Use the predefined color palette for consistency
- Employ custom hex colors sparingly for brand-specific needs
- Follow the color scale guidelines (50-950)

### 4. Typography

- Respect the progressive font sizing system
- Consider the pixel scaling difference in Flumi
- Use semantic heading hierarchy

### 5. Interactive Design

- Implement hover and active states for better UX
- Use appropriate cursor styles for different elements
- Consider z-index stacking for overlays

## Development Workflow

1. **Structure**: Start with semantic HTML structure
2. **Layout**: Apply Flexbox utilities for positioning
3. **Spacing**: Use consistent padding/margin system
4. **Colors**: Apply color palette or custom hex values
5. **Typography**: Set appropriate font sizes and styles
6. **Borders**: Add borders and radius as needed
7. **Interactions**: Implement hover/active states
8. **Custom**: Add custom fonts and advanced selectors

## Common Patterns

### Button Variations

```html
<!-- Basic styled buttons -->
<button style="bg-[#4CAF50] rounded-lg text-white px-4 py-2">
  Green Button
</button>
<button style="bg-[#2196F3] rounded-xl text-white px-4 py-2">
  Blue Button
</button>
<button style="bg-[#FF5722] rounded-full text-white px-6 py-2">
  Orange Pill
</button>

<!-- Multi-state buttons -->
<button
  style="bg-[#e74c3c] text-white rounded 
               hover:bg-[#c0392b] 
               active:bg-[#a93226]"
>
  Red Multi-State
</button>
```

### Card Components

```html
<div style="bg-[#1e293b] text-white rounded-xl p-6 shadow-lg">
  <h3 style="text-xl font-semibold mb-2">Card Title</h3>
  <p style="text-base">Card content</p>
</div>
```

### Form Layouts

```html
<form style="flex flex-col gap-4 w-80 mx-auto">
  <input type="text" placeholder="Name" required="true" />
  <input type="email" placeholder="Email" required="true" />
  <textarea placeholder="Message" rows="4"></textarea>
  <button type="submit" style="bg-[#4ade80] text-white py-2 rounded">
    Submit
  </button>
</form>
```

This context file should help you understand the unique characteristics of Gurted and enable you to code effectively within this framework. The key is understanding that while it looks like HTML/CSS, it renders natively through Flumi with its own specific behaviors and optimizations.
test
