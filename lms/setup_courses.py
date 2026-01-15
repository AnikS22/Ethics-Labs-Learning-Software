#!/usr/bin/env python3
"""
Script to create the two main Ethics Lab courses:
1. AI Ethics
2. Ethical Creation of AI

Run this script from the Frappe bench directory after installing the LMS app.
Usage: bench --site [your-site] execute lms.setup_courses.setup_ethics_lab_courses
"""

import frappe
from frappe import _


def setup_ethics_lab_courses():
	"""Create the two main Ethics Lab courses with their structure."""
	
	print("Creating Ethics Lab courses...")
	
	# Create Course 1: AI Ethics
	create_ai_ethics_course()
	
	# Create Course 2: Ethical Creation of AI
	create_ethical_creation_course()
	
	# Link courses as related
	link_related_courses()
	
	print("Courses created successfully!")
	frappe.db.commit()


def create_ai_ethics_course():
	"""Create the AI Ethics course."""
	
	course_name = "ai-ethics"
	
	# Check if course already exists
	if frappe.db.exists("LMS Course", course_name):
		print(f"Course '{course_name}' already exists. Skipping...")
		return frappe.get_doc("LMS Course", course_name)
	
	# Create course
	course = frappe.new_doc("LMS Course")
	course.title = "AI Ethics"
	course.name = course_name
	course.short_introduction = "Understand the ethical dimensions of artificial intelligence through philosophical inquiry and critical analysis."
	course.description = """
	<h2>About This Course</h2>
	<p>Explore the philosophical foundations, ethical frameworks, and critical questions surrounding artificial intelligence. 
	This course examines the moral implications of AI systems, their impact on society, and the ethical dilemmas they present.</p>
	
	<h3>What You'll Learn</h3>
	<ul>
		<li>Foundational concepts in AI ethics and philosophy</li>
		<li>Understanding bias, fairness, and discrimination in AI</li>
		<li>Privacy, surveillance, and data rights</li>
		<li>Autonomy, agency, and responsibility in AI systems</li>
		<li>Deep philosophical questions about AI consciousness and moral status</li>
		<li>Social impact, justice, and democratic implications</li>
		<li>Real-world case studies and ethical analysis</li>
	</ul>
	
	<h3>Who Should Take This Course</h3>
	<p>This course is designed for anyone interested in understanding the ethical dimensions of AI, including students, 
	professionals, policymakers, and concerned citizens. No technical background required.</p>
	"""
	
	course.tags = "AI Ethics, Philosophy, Ethics, Critical Thinking, Social Impact"
	course.published = 1
	course.enable_certification = 1
	course.paid_course = 0  # Free course
	
	# Add default instructor (you'll need to set this to an actual user)
	# course.append("instructors", {"instructor": "Administrator"})
	
	course.insert()
	
	# Create chapters
	chapters_data = [
		{
			"title": "Foundations of AI Ethics",
			"description": "Introduction to the field of AI ethics and its philosophical underpinnings.",
			"lessons": [
				"What is AI Ethics?",
				"Philosophical Foundations",
				"Key Ethical Frameworks"
			]
		},
		{
			"title": "Bias and Fairness",
			"description": "Understanding how bias manifests in AI systems and strategies for fairness.",
			"lessons": [
				"Understanding Algorithmic Bias",
				"Fairness in Machine Learning",
				"Addressing Discrimination"
			]
		},
		{
			"title": "Privacy and Surveillance",
			"description": "Examining privacy concerns and surveillance implications of AI technologies.",
			"lessons": [
				"Privacy in the Age of AI",
				"Surveillance and Monitoring",
				"Data Rights and Ownership"
			]
		},
		{
			"title": "Autonomy and Agency",
			"description": "Exploring questions of autonomy, agency, and responsibility in AI systems.",
			"lessons": [
				"AI Autonomy and Decision-Making",
				"Agency and Responsibility",
				"Human-AI Collaboration"
			]
		},
		{
			"title": "Philosophical Questions",
			"description": "Deep dive into fundamental philosophical questions raised by AI.",
			"lessons": [
				"Consciousness and AI",
				"Moral Status of AI",
				"Existential Risks",
				"Meaning and Purpose"
			]
		},
		{
			"title": "Social Impact and Justice",
			"description": "Examining the broader social implications and justice concerns of AI.",
			"lessons": [
				"Economic Impact",
				"Social Justice",
				"Democracy and Governance"
			]
		},
		{
			"title": "Case Studies and Applications",
			"description": "Real-world case studies of ethical challenges in AI applications.",
			"lessons": [
				"Healthcare AI",
				"Criminal Justice",
				"Autonomous Vehicles",
				"Social Media and Content Moderation"
			]
		},
		{
			"title": "Ethics in Practice",
			"description": "Practical approaches to implementing ethical AI in organizations.",
			"lessons": [
				"Ethics Review Processes",
				"Stakeholder Engagement",
				"Continuous Monitoring"
			]
		}
	]
	
	create_course_structure(course, chapters_data)
	
	return course


def create_ethical_creation_course():
	"""Create the Ethical Creation of AI course."""
	
	course_name = "ethical-creation-of-ai"
	
	# Check if course already exists
	if frappe.db.exists("LMS Course", course_name):
		print(f"Course '{course_name}' already exists. Skipping...")
		return frappe.get_doc("LMS Course", course_name)
	
	# Create course
	course = frappe.new_doc("LMS Course")
	course.title = "Ethical Creation of AI"
	course.name = course_name
	course.short_introduction = "Master the technical skills and methodologies needed to create AI systems that are fair, transparent, accountable, and beneficial."
	course.description = """
	<h2>About This Course</h2>
	<p>Learn practical methods and best practices for developing AI systems ethically. This hands-on course covers technical 
	approaches, development methodologies, and tools for building responsible AI systems.</p>
	
	<h3>What You'll Learn</h3>
	<ul>
		<li>Ethics by design principles and development methodologies</li>
		<li>Ethical data collection, management, and governance</li>
		<li>Fairness-aware machine learning algorithms</li>
		<li>Transparency and explainability techniques</li>
		<li>Privacy-preserving AI methods (differential privacy, federated learning)</li>
		<li>Robustness, safety, and security in AI systems</li>
		<li>Accountability mechanisms and governance frameworks</li>
		<li>Human-centered design for AI</li>
		<li>Deployment, monitoring, and incident response</li>
		<li>Practical tools and frameworks for ethical AI development</li>
	</ul>
	
	<h3>Who Should Take This Course</h3>
	<p>This course is designed for AI developers, data scientists, ML engineers, and technical professionals who want to 
	build AI systems responsibly. Basic understanding of machine learning is recommended.</p>
	"""
	
	course.tags = "AI Development, Responsible AI, Machine Learning, Ethics in Practice, Technical Skills"
	course.published = 1
	course.enable_certification = 1
	course.paid_course = 0  # Free course
	
	# Add default instructor (you'll need to set this to an actual user)
	# course.append("instructors", {"instructor": "Administrator"})
	
	course.insert()
	
	# Create chapters
	chapters_data = [
		{
			"title": "Introduction to Ethical AI Development",
			"description": "Foundations of building AI systems with ethics in mind from the start.",
			"lessons": [
				"Ethics by Design",
				"Development Methodologies",
				"Team Roles and Responsibilities"
			]
		},
		{
			"title": "Data Ethics and Management",
			"description": "Ethical considerations in data collection, preparation, and management.",
			"lessons": [
				"Ethical Data Collection",
				"Data Preprocessing Ethics",
				"Data Governance"
			]
		},
		{
			"title": "Fairness in Machine Learning",
			"description": "Technical approaches to building fair and unbiased AI systems.",
			"lessons": [
				"Measuring Fairness",
				"Fairness-Aware Algorithms",
				"Bias Detection and Mitigation"
			]
		},
		{
			"title": "Transparency and Explainability",
			"description": "Making AI systems understandable and accountable.",
			"lessons": [
				"Explainable AI (XAI)",
				"Interpretability Techniques",
				"Documentation and Communication"
			]
		},
		{
			"title": "Privacy-Preserving AI",
			"description": "Techniques for building AI systems that protect user privacy.",
			"lessons": [
				"Differential Privacy",
				"Federated Learning",
				"Homomorphic Encryption",
				"Secure Multi-Party Computation"
			]
		},
		{
			"title": "Robustness and Safety",
			"description": "Building AI systems that are reliable, secure, and safe.",
			"lessons": [
				"Adversarial Robustness",
				"Safety Engineering",
				"Testing and Validation"
			]
		},
		{
			"title": "Accountability and Governance",
			"description": "Establishing accountability mechanisms and governance structures.",
			"lessons": [
				"Audit Trails and Logging",
				"Version Control and Reproducibility",
				"Governance Frameworks"
			]
		},
		{
			"title": "Human-Centered Design",
			"description": "Designing AI systems that prioritize human well-being and agency.",
			"lessons": [
				"User-Centered Design",
				"Human-AI Interaction",
				"Empowerment and Agency"
			]
		},
		{
			"title": "Deployment and Monitoring",
			"description": "Ethical considerations in deploying and maintaining AI systems.",
			"lessons": [
				"Responsible Deployment",
				"Continuous Monitoring",
				"Incident Response"
			]
		},
		{
			"title": "Tools and Frameworks",
			"description": "Practical tools and frameworks for ethical AI development.",
			"lessons": [
				"Open Source Tools",
				"Development Frameworks",
				"Industry Standards"
			]
		}
	]
	
	create_course_structure(course, chapters_data)
	
	return course


def create_course_structure(course, chapters_data):
	"""Create chapters and lessons for a course."""
	
	for idx, chapter_data in enumerate(chapters_data, 1):
		# Create chapter
		chapter = frappe.new_doc("Course Chapter")
		chapter.course = course.name
		chapter.title = chapter_data["title"]
		chapter.insert()
		
		# Add chapter to course
		course.append("chapters", {"chapter": chapter.name, "idx": idx})
		
		# Create lessons
		for lesson_idx, lesson_title in enumerate(chapter_data["lessons"], 1):
			lesson = frappe.new_doc("Course Lesson")
			lesson.course = course.name
			lesson.chapter = chapter.name
			lesson.title = lesson_title
			
			# Add placeholder content
			lesson.body = f"""
# {lesson_title}

## Overview
This lesson covers the key concepts and practical applications related to {lesson_title.lower()}.

## Learning Objectives
- Understand the fundamental concepts
- Apply knowledge to real-world scenarios
- Analyze ethical implications

## Content
*Content to be added by instructors*

## Key Takeaways
- Key point 1
- Key point 2
- Key point 3

## Further Reading
- Additional resources to be added
			"""
			
			lesson.insert()
			
			# Add lesson to chapter
			chapter.append("lessons", {"lesson": lesson.name, "idx": lesson_idx})
		
		chapter.save()
	
	course.save()


def link_related_courses():
	"""Link the two courses as related to each other."""
	
	ai_ethics = frappe.db.exists("LMS Course", "ai-ethics")
	ethical_creation = frappe.db.exists("LMS Course", "ethical-creation-of-ai")
	
	if ai_ethics and ethical_creation:
		# Link Ethical Creation as related to AI Ethics
		ai_ethics_doc = frappe.get_doc("LMS Course", "ai-ethics")
		if not any(r.course == "ethical-creation-of-ai" for r in ai_ethics_doc.related_courses):
			ai_ethics_doc.append("related_courses", {"course": "ethical-creation-of-ai"})
			ai_ethics_doc.save()
		
		# Link AI Ethics as related to Ethical Creation
		ethical_creation_doc = frappe.get_doc("LMS Course", "ethical-creation-of-ai")
		if not any(r.course == "ai-ethics" for r in ethical_creation_doc.related_courses):
			ethical_creation_doc.append("related_courses", {"course": "ai-ethics"})
			ethical_creation_doc.save()


# Note: When running from bench console, frappe is already connected
# When running as a script, you may need to call frappe.connect() first
if __name__ == "__main__":
	import sys
	if not frappe.db:
		frappe.connect()
	setup_ethics_lab_courses()
