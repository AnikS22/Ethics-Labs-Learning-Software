# Ethics Lab Certificate Design Guide

## Overview

The certificate template has been completely redesigned to match "The Ethics Lab" branding, featuring:

- **Landscape orientation** on white background
- **Decorative corner elements** (neural network, brain, arms with hands, paintbrush)
- **Distinctive typography** with pixelated/blackletter font for "The Ethics Lab"
- **Vibrant color scheme** (bright blue, orange, yellow, red)
- **Professional signature section** with names and titles

## Design Elements

### 1. Typography

- **"The Ethics Lab"**: Uses "Uncial One" font (pixelated/blackletter style)
  - Size: 3.5rem
  - Weight: 900 (Black)
  - Color: Black (#000000)
  - Text transform: Uppercase
  - Letter spacing: 0.1em

- **Certificate Title**: Uses Inter font
  - Size: 1.5rem
  - Weight: 700 (Bold)
  - Example: "Certificate of Ethical AI in Policy"

- **Recipient Name**: Uses Inter font
  - Size: 3.5rem
  - Weight: 900 (Black)
  - Most prominent text on certificate

- **Description**: Uses Inter font
  - Size: 1rem
  - Weight: 400 (Regular)
  - Color: Medium gray (#666666)
  - Line height: 1.6

- **Signatures**: Uses Inter font
  - Names: 1.1rem, Weight 700, Black
  - Titles: 0.9rem, Weight 400, Gray (#666666)

### 2. Decorative Elements

Four corner decorations in SVG format:

#### Top Left: Blue Arm with Orange Hand
- Blue sleeve (#0066FF)
- Orange hand (#FF8C00)
- Light orange fingernails (#FFB84D)
- Represents: Friendly, approachable, human touch

#### Top Right: Neural Network Diagram
- Input layer: 3 blue nodes (#0066FF)
- Hidden layer 1: 4 orange nodes (#FF8C00)
- Hidden layer 2: 3 red nodes (#FF4444)
- Output: 1 black node (#000000)
- Gray connections between nodes
- Represents: AI/technology aspect

#### Bottom Left: Stylized Brain
- Blue outer shape (#0066FF)
- Orange and gold internal patterns (#FF8C00, #FFD700)
- White highlights
- Represents: Ethics, thinking, learning

#### Bottom Right: Orange Arm with Paintbrush
- Orange sleeve (#FF8C00)
- Light orange hand (#FFB84D)
- Red paintbrush handle (#FF4444)
- Gold brush tip (#FFD700)
- Represents: Creativity, design, shaping the future

### 3. Color Palette

| Element | Color | Hex Code |
|---------|-------|----------|
| Primary Text | Black | #000000 |
| Secondary Text | Gray | #666666 |
| Blue Elements | Bright Blue | #0066FF |
| Orange Elements | Orange | #FF8C00 |
| Orange Light | Light Orange | #FFB84D |
| Red Elements | Red | #FF4444 |
| Gold Elements | Gold | #FFD700 |
| Background | White | #FFFFFF |

### 4. Layout Structure

```
┌─────────────────────────────────────────┐
│  [Arm]              [Neural Network]   │
│                                         │
│         THE ETHICS LAB                 │
│    Certificate of [Course Title]       │
│                                         │
│            [Recipient Name]             │
│                                         │
│    [Description Paragraph]             │
│                                         │
│  [Brain]              [Arm+Paintbrush]  │
│                                         │
│  [Signature 1]      [Signature 2]     │
└─────────────────────────────────────────┘
```

## Customization

### Changing Signature Names

The certificate currently has hardcoded signatures:
- **Anik Sahai** - Tech Head / Co-Founder
- **Michael Gomez** - Policy Head / Co-Founder

To customize, edit the certificate template HTML in:
`lms/lms/print_format/certificate/certificate.json`

Look for the `certificate-signatures` section and update:

```html
<div class="signature-block">
    <div class="signature-name">Your Name</div>
    <div class="signature-title">Your Title</div>
</div>
```

### Making Signatures Dynamic

To use course instructors or evaluators as signatures, you can modify the template to:

```jinja
{% set instructors = frappe.get_all("Course Instructor", {"parent": doc.course}, pluck="instructor", order_by="idx") %}
{% if instructors %}
    {% for instructor in instructors[:2] %}
        <div class="signature-block">
            <div class="signature-name">{{ frappe.db.get_value("User", instructor, "full_name") }}</div>
            <div class="signature-title">Course Instructor</div>
        </div>
    {% endfor %}
{% endif %}
```

### Changing Certificate Description

The description is currently:
> "This certificate recognizes successful completion of Ethics Lab's Technical Track, demonstrating the ability to design, build, and responsibly deploy real-world AI solutions for partner organizations."

To customize, edit the `certificate_description` variable in the template, or make it dynamic based on course data.

### Customizing Certificate Title

The certificate title is generated from the course title:
```jinja
Certificate of {{ certificate_type }}
```

Where `certificate_type` comes from the course title. You can customize this to:
- Use a fixed format: `"Certificate of Ethical AI in Policy"`
- Use course category
- Use a custom field from the course

### Adjusting Decorative Elements

The decorative SVG elements are embedded directly in the HTML. To modify:

1. Edit the SVG code in the `certificate-decorations` section
2. Adjust colors by changing the `fill` and `stroke` attributes
3. Adjust size by modifying the `viewBox` and container dimensions
4. Reposition by changing the `top`, `left`, `right`, `bottom` CSS values

### Font Customization

To change the "The Ethics Lab" font:

1. Update the Google Fonts import to include your preferred blackletter/pixelated font
2. Change the `font-family` in `.certificate-org-name` class

Popular alternatives:
- **Blackletter**: "Uncial One", "MedievalSharp"
- **Pixelated**: "Press Start 2P", "VT323"

## File Locations

- **Certificate Template**: `lms/lms/print_format/certificate/certificate.json`
- **Certificate CSS**: Embedded in the template's `css` field
- **Decorative SVG**: Embedded in the template's `html` field
- **Standalone SVG File**: `lms/public/images/certificate-decorations.svg` (reference only)

## Testing

To test the certificate:

1. **Generate a test certificate**:
   - Create a course
   - Enroll a test student
   - Complete the course requirements
   - Issue a certificate

2. **View the certificate**:
   - Navigate to the certificate URL
   - Or download as PDF

3. **Check print quality**:
   - Print to PDF
   - Verify all elements render correctly
   - Check colors match design
   - Verify text is readable

## Print Considerations

- **Orientation**: Landscape (A4)
- **Margins**: 3rem top/bottom, 4rem left/right
- **Font sizes**: Adjusted for print in `@media print` section
- **Colors**: All colors are print-safe

## Responsive Design

The certificate is optimized for:
- **Screen viewing**: Full size with all decorations
- **PDF generation**: Adjusted margins and font sizes
- **Print**: Landscape orientation, proper scaling

## Troubleshooting

### Fonts not loading
- Ensure Google Fonts are accessible
- Check internet connection for font loading
- Consider hosting fonts locally

### SVG decorations not showing
- Verify SVG code is properly escaped in JSON
- Check that SVG viewBox values are correct
- Ensure container dimensions allow visibility

### Text overflow
- Adjust font sizes in CSS
- Modify container max-width
- Adjust padding/margins

### Colors not matching
- Verify hex codes are correct
- Check for CSS specificity issues
- Ensure no other styles are overriding

## Best Practices

1. **Keep signatures consistent** across all certificates
2. **Use high-quality fonts** for professional appearance
3. **Test PDF generation** before deploying
4. **Maintain color consistency** with brand guidelines
5. **Keep decorative elements subtle** - they should enhance, not distract
6. **Ensure accessibility** - text should be readable and high contrast

## Future Enhancements

Potential improvements:
- [ ] Dynamic signature selection based on course
- [ ] Custom certificate descriptions per course
- [ ] Multiple certificate templates for different course types
- [ ] QR code for certificate verification
- [ ] Digital signature integration
- [ ] Certificate number/ID display
- [ ] Issue date display
- [ ] Expiry date display (if applicable)

---

**Certificate Design Complete!** The certificates now match "The Ethics Lab" professional branding.
