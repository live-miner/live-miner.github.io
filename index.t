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
		<p>Releases are signed with PGP; import the <a href="keys.asc">release keyring</a> if you want to check them.
		<ul id="downloads">
			{% for entry in tree recursive %}
				{% if entry.children %}
				<li class="{% if entry.latest %}latest{% endif %}">
					<a href="#" class="directory">{{ entry.name }}</a> …
					{% if entry.note %}({{ entry.note }}){% endif %}
					<ul>{{ loop (entry.children) }}</ul>
				</li>
			{% else %}
				<li class="{% if entry.interesting %}interesting{% endif %}">
					<a href="https://sourceforge.net/projects/live-miner/files/{{ entry.path }}">{{ entry.name }}</a>{% if entry.note %} ({{ entry.note }}){% endif %}
				</li>
			{% endif %}
		{% endfor %}
		</ul>
	</body>
</html>
