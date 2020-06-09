class Planta {
	const anioObtencion
	const altura
	
	method horasDeSolToleradas() // Método abstracto (solo declaro la firma, no una implementación)
	method esFuerte() { return self.horasDeSolToleradas() > 10 } // Template method

	method daNuevasSemillas() { return self.esFuerte() or self.condicionParaSemillas() }
	method condicionParaSemillas()

	method espacioQueOcupa() // Podría no estar
}

class Menta inherits Planta {
	override method horasDeSolToleradas() { return 6 }
	override method condicionParaSemillas() { return altura > 0.4 }
	override method espacioQueOcupa() { return altura * 3 }
}

class HierbaBuena inherits Menta {
	override method espacioQueOcupa() { return super() * 2 }
}


class Soja inherits Planta {
	override method horasDeSolToleradas() { return if (altura < 0.5) 6 else if (altura < 1) 7 else 9 }
	override method condicionParaSemillas() { return anioObtencion > 2007 and altura > 1 }
	override method espacioQueOcupa() { return altura / 2 }
}

class SojaTransgenica inherits Soja {
	override method daNuevasSemillas() { return false }
}


class Quinoa inherits Planta {
	const property horasDeSolToleradas
	
	override method condicionParaSemillas() { return anioObtencion < 2005 }
	override method espacioQueOcupa() { return 0.5 }
}



