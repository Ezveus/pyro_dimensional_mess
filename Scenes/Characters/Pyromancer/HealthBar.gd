extends ProgressBar

func _ready():
	# Appeler la fonction pour mettre à jour la couleur dès le démarrage
	_update_color()

func _on_value_changed(value):
	# Mettre à jour la couleur à chaque changement de valeur
	_update_color()

func _update_color():
	var progress = self.value / self.max_value  # Obtenir la progression entre 0 et 1
	var color = Color.WHITE  # Couleur par défaut

	if progress <= 0.34:
		color = Color.RED  # Rouge pour les valeurs faibles
	elif progress <= 0.67:
		color = Color.YELLOW  # Jaune pour les valeurs moyennes
	else:
		color = Color.GREEN  # Vert pour les valeurs élevées

	# Appliquer la couleur au StyleBox de la barre
	var style = StyleBoxFlat.new()
	style.bg_color = color
	self.add_theme_stylebox_override("fill", style)
