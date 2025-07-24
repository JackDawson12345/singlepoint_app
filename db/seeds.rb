# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Clear existing templates in development
if Rails.env.development?
  puts "🧹 Cleaning existing templates..."
  Template.destroy_all
end

puts "🌱 Creating sample template..."

# ================================
# MODERN BUSINESS TEMPLATE
# ================================
Template.find_or_create_by(name: "Modern Business") do |template|
  template.category = "business"
  template.description = "A clean, professional template perfect for businesses and services"
  template.html_content = <<~HTML
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>{{company_name}}</title>
    </head>
    <body>
        <header class="header">
            <nav class="navbar">
                <div class="nav-brand">
                    <h1>{{company_name}}</h1>
                </div>
                <ul class="nav-menu">
                    <li><a href="#home">Home</a></li>
                    <li><a href="#about">About</a></li>
                    <li><a href="#services">Services</a></li>
                    <li><a href="#contact">Contact</a></li>
                </ul>
            </nav>
        </header>

        <main>
            <section id="home" class="hero">
                <div class="hero-content">
                    <h1>Welcome to {{company_name}}</h1>
                    <p>{{hero_subtitle}}</p>
                    <a href="#contact" class="cta-button">Get Started</a>
                </div>
            </section>

            <section id="about" class="about">
                <div class="container">
                    <h2>About Us</h2>
                    <p>{{about_text}}</p>
                </div>
            </section>

            <section id="services" class="services">
                <div class="container">
                    <h2>Our Services</h2>
                    <div class="services-grid">
                        <div class="service-card">
                            <h3>{{service_1_title}}</h3>
                            <p>{{service_1_description}}</p>
                        </div>
                        <div class="service-card">
                            <h3>{{service_2_title}}</h3>
                            <p>{{service_2_description}}</p>
                        </div>
                        <div class="service-card">
                            <h3>{{service_3_title}}</h3>
                            <p>{{service_3_description}}</p>
                        </div>
                    </div>
                </div>
            </section>

            <section id="contact" class="contact">
                <div class="container">
                    <h2>Contact Us</h2>
                    <p>Email: <a href="mailto:{{contact_email}}">{{contact_email}}</a></p>
                    <p>Phone: {{phone_number}}</p>
                    <p>Address: {{address}}</p>
                </div>
            </section>
        </main>

        <footer class="footer">
            <div class="container">
                <p>&copy; 2025 {{company_name}}. All rights reserved.</p>
            </div>
        </footer>
    </body>
    </html>
  HTML

  template.css_content = <<~CSS
    :root {
        --primary-color: #3498db;
        --secondary-color: #2c3e50;
        --text-color: #333;
        --background-color: #fff;
        --gray-light: #f8f9fa;
    }

    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }

    body {
        font-family: "Arial", sans-serif;
        line-height: 1.6;
        color: var(--text-color);
        background-color: var(--background-color);
    }

    .container {
        max-width: 1200px;
        margin: 0 auto;
        padding: 0 20px;
    }

    /* Header */
    .header {
        background: var(--background-color);
        box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        position: sticky;
        top: 0;
        z-index: 1000;
    }

    .navbar {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 1rem 2rem;
        max-width: 1200px;
        margin: 0 auto;
    }

    .nav-brand h1 {
        color: var(--primary-color);
        font-size: 1.8rem;
    }

    .nav-menu {
        display: flex;
        list-style: none;
        gap: 2rem;
    }

    .nav-menu a {
        text-decoration: none;
        color: var(--text-color);
        font-weight: 500;
        transition: color 0.3s;
    }

    .nav-menu a:hover {
        color: var(--primary-color);
    }

    /* Hero Section */
    .hero {
        background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
        color: white;
        padding: 100px 0;
        text-align: center;
    }

    .hero-content h1 {
        font-size: 3rem;
        margin-bottom: 1rem;
    }

    .hero-content p {
        font-size: 1.2rem;
        margin-bottom: 2rem;
        max-width: 600px;
        margin-left: auto;
        margin-right: auto;
    }

    .cta-button {
        display: inline-block;
        background: white;
        color: var(--primary-color);
        padding: 12px 30px;
        text-decoration: none;
        border-radius: 5px;
        font-weight: bold;
        font-size: 1.1rem;
        transition: transform 0.3s, box-shadow 0.3s;
    }

    .cta-button:hover {
        transform: translateY(-2px);
        box-shadow: 0 5px 15px rgba(0,0,0,0.2);
    }

    /* Sections */
    .about, .services, .contact {
        padding: 80px 0;
    }

    .about {
        background: var(--gray-light);
    }

    section h2 {
        font-size: 2.5rem;
        text-align: center;
        margin-bottom: 3rem;
        color: var(--secondary-color);
    }

    .about p {
        font-size: 1.1rem;
        text-align: center;
        max-width: 800px;
        margin: 0 auto;
    }

    /* Services */
    .services-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
        gap: 2rem;
        margin-top: 2rem;
    }

    .service-card {
        background: white;
        padding: 2rem;
        border-radius: 10px;
        box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        text-align: center;
        transition: transform 0.3s;
    }

    .service-card:hover {
        transform: translateY(-5px);
    }

    .service-card h3 {
        color: var(--primary-color);
        margin-bottom: 1rem;
        font-size: 1.3rem;
    }

    /* Contact */
    .contact {
        background: var(--gray-light);
        text-align: center;
    }

    .contact p {
        margin-bottom: 1rem;
        font-size: 1.1rem;
    }

    .contact a {
        color: var(--primary-color);
        text-decoration: none;
    }

    /* Footer */
    .footer {
        background: var(--secondary-color);
        color: white;
        text-align: center;
        padding: 2rem 0;
    }

    /* Responsive */
    @media (max-width: 768px) {
        .navbar {
            flex-direction: column;
            gap: 1rem;
        }

        .nav-menu {
            gap: 1rem;
        }

        .hero-content h1 {
            font-size: 2rem;
        }

        .services-grid {
            grid-template-columns: 1fr;
        }
    }
  CSS

  template.customizable_fields = [
    {
      "name" => "company_name",
      "label" => "Company Name",
      "type" => "text",
      "default" => "Your Company"
    },
    {
      "name" => "hero_subtitle",
      "label" => "Hero Subtitle",
      "type" => "text",
      "default" => "We provide exceptional services to help your business grow"
    },
    {
      "name" => "about_text",
      "label" => "About Text",
      "type" => "textarea",
      "default" => "We are a dedicated team committed to delivering excellent results for our clients."
    },
    {
      "name" => "service_1_title",
      "label" => "Service 1 Title",
      "type" => "text",
      "default" => "Consulting"
    },
    {
      "name" => "service_1_description",
      "label" => "Service 1 Description",
      "type" => "textarea",
      "default" => "Expert consulting to help guide your business decisions."
    },
    {
      "name" => "service_2_title",
      "label" => "Service 2 Title",
      "type" => "text",
      "default" => "Development"
    },
    {
      "name" => "service_2_description",
      "label" => "Service 2 Description",
      "type" => "textarea",
      "default" => "Custom development solutions tailored to your needs."
    },
    {
      "name" => "service_3_title",
      "label" => "Service 3 Title",
      "type" => "text",
      "default" => "Support"
    },
    {
      "name" => "service_3_description",
      "label" => "Service 3 Description",
      "type" => "textarea",
      "default" => "Ongoing support to ensure your success."
    },
    {
      "name" => "contact_email",
      "label" => "Contact Email",
      "type" => "email",
      "default" => "contact@example.com"
    },
    {
      "name" => "phone_number",
      "label" => "Phone Number",
      "type" => "text",
      "default" => "+1 (555) 123-4567"
    },
    {
      "name" => "address",
      "label" => "Address",
      "type" => "text",
      "default" => "123 Business St, City, State 12345"
    }
  ]

  template.active = true
  template.price_cents = 0
end

puts "✅ Template created successfully!"
puts "Created: Modern Business template"
puts ""
puts "To create more templates, you can add them to this seeds file later."
puts "Run 'rails db:seed' to execute this file."