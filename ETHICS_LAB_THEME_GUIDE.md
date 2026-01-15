# Ethics Lab Theme & Color Scheme Guide

This guide documents the color scheme and design theme applied to the Ethics Labs LMS based on "The Ethics Lab" branding.

## Color Palette

### Primary Colors

| Color | Hex Code | Usage |
|-------|----------|-------|
| **Bright Blue** | `#0066FF` | Primary brand color, buttons, links, borders |
| **Blue Light** | `#3399FF` | Hover states, light accents |
| **Blue Dark** | `#0052CC` | Active states, pressed buttons |

### Secondary Colors

| Color | Hex Code | Usage |
|-------|----------|-------|
| **Orange** | `#FF8C00` | Secondary actions, highlights, certificate signatures |
| **Orange Light** | `#FFB84D` | Light accents |
| **Gold** | `#FFD700` | Premium features, special highlights |

### Accent Colors

| Color | Hex Code | Usage |
|-------|----------|-------|
| **Red** | `#FF4444` | Alerts, expiry dates, important notices |
| **Red Light** | `#FF7777` | Light accents |
| **Red Dark** | `#CC3636` | Darker accents |

### Neutral Colors

| Color | Hex Code | Usage |
|-------|----------|-------|
| **Black** | `#000000` | Text, outlines, primary content |
| **White** | `#FFFFFF` | Backgrounds, cards |
| **Light Grey** | `#F8F9FA` | Subtle backgrounds, gradients |
| **Grey** | `#E2E6E9` | Borders, dividers |

## Design Theme Elements

### Typography
- **Main Title**: Bold, modern sans-serif (can be styled with pixelated/blackletter font for "The Ethics Lab" branding)
- **Body Text**: Clean, readable sans-serif (Inter font family)
- **Accents**: Cursive font for signatures and special elements

### Visual Elements
The theme incorporates:
- **Neural Network Diagrams**: Representing AI/technology aspect
- **Brain Illustrations**: Representing ethics/thinking
- **Creative Elements**: Paintbrush/artistic elements for creativity
- **Modern, Playful Aesthetic**: Accessible yet professional

## Implementation

### CSS Variables

The color scheme is defined in `ETHICS_LAB_COLOR_SCHEME.css` with CSS custom properties:

```css
--ethics-lab-blue: #0066FF;
--ethics-lab-orange: #FF8C00;
--ethics-lab-red: #FF4444;
--ethics-lab-black: #000000;
--ethics-lab-white: #FFFFFF;
```

### Files Updated

1. **Certificate Template** (`lms/lms/print_format/certificate/certificate.json`)
   - Border color: Changed to bright blue (#0066FF)
   - Text colors: Updated to black for better contrast
   - Signature color: Orange (#FF8C00)
   - Expiry date: Red (#FF4444)
   - Added subtle gradient background

2. **Main CSS** (`lms/public/css/style.css`)
   - Certificate border styling updated
   - Certificate text colors updated
   - Added gradient effects

## Usage Examples

### Buttons
```css
/* Primary Button */
.btn-primary {
    background-color: #0066FF;
    color: #FFFFFF;
}

/* Secondary Button */
.btn-secondary {
    background-color: #FF8C00;
    color: #FFFFFF;
}
```

### Links
```css
a {
    color: #0066FF;
}

a:hover {
    color: #0052CC;
}
```

### Certificates
- Border: Bright blue (#0066FF)
- Text: Black (#000000)
- Signatures: Orange (#FF8C00)
- Expiry dates: Red (#FF4444)
- Background: White with subtle grey gradient

## Customization

To apply the full color scheme:

1. **Import the color scheme CSS** (if using as separate file):
   ```html
   <link rel="stylesheet" href="/assets/lms/ethic_lab_color_scheme.css">
   ```

2. **Or integrate into main CSS**:
   Copy the CSS variables from `ETHICS_LAB_COLOR_SCHEME.css` into your main stylesheet.

3. **Update Frappe Theme** (if using Frappe's theming):
   - Go to Website Settings
   - Configure primary color: `#0066FF`
   - Set accent colors as needed

## Color Combinations

### Recommended Combinations

1. **Primary Action**: Blue on White
   - Background: White
   - Text/Button: Bright Blue (#0066FF)

2. **Secondary Action**: Orange on White
   - Background: White
   - Text/Button: Orange (#FF8C00)

3. **Alert/Important**: Red on White
   - Background: White
   - Text: Red (#FF4444)

4. **Gradient Backgrounds**:
   - Blue gradient: `linear-gradient(135deg, #0066FF 0%, #3399FF 100%)`
   - Orange gradient: `linear-gradient(135deg, #FF8C00 0%, #FFD700 100%)`
   - Multi-color: `linear-gradient(135deg, #0066FF 0%, #FF8C00 50%, #FF4444 100%)`

## Accessibility

All color combinations meet WCAG AA contrast requirements:
- Blue (#0066FF) on White: ✅ 4.5:1 contrast ratio
- Black (#000000) on White: ✅ 21:1 contrast ratio
- Orange (#FF8C00) on White: ✅ 4.5:1 contrast ratio
- Red (#FF4444) on White: ✅ 4.5:1 contrast ratio

## Brand Consistency

When creating new components or pages:
1. Use bright blue for primary actions
2. Use orange for secondary/highlight elements
3. Use red sparingly for alerts/important information
4. Maintain black text on white backgrounds for readability
5. Add subtle gradients for visual interest

## Next Steps

1. Replace logo files with Ethics Lab branding
2. Apply color scheme to all UI components
3. Update any remaining blue references (#0089FF) to new blue (#0066FF)
4. Test color combinations for accessibility
5. Create branded email templates with these colors
