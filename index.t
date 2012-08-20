<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset='utf-8'>
		<title>live-miner files</title>
		<script src="jquery-1.8.0.min.js"></script>
		<script src="index.js"></script>
		<style type="text/css">
			li.interesting > a {
				font-weight: bold;
			}
		</style>
	</head>

	<body>
		<h1>live-miner releases</h1>
		<ul id="downloads">
			{% for entry in tree recursive %}
				{% if entry.children %}
				<li{% if entry.latest %} class="latest"{% endif %}>
					<a href="#" class="directory">{{ entry.name }}</a>
					{% if entry.note %}({{ entry.note }}){% endif %}
					<ul>{{ loop (entry.children) }}</ul>
				</li>
			{% else %}
				<li{% if entry.interesting %} class="interesting"{% endif %}>
					<a href="{{ entry.path }}">{{ entry.name }}</a>{% if entry.note %} ({{ entry.note }}){% endif %}
				</li>
			{% endif %}
		{% endfor %}
		</ul>
	</body>
</html>
