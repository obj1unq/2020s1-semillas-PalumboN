class Planta {
	const anioObtencion
	const altura
	
	method horasDeSolToleradas() // Método abstracto (solo declaro la firma, no una implementación)
	method esFuerte() { return self.horasDeSolToleradas() > 10 } // Template method

	method daNuevasSemillas() { return self.esFuerte() or self.condicionParaSemillas() }
	method condicionParaSemillas()

	method espacioQueOcupa() // Podría no estar
	
	method esIdeal(parcela)
	
	method esAlta() { return altura > 1.5 }
}

class Menta inherits Planta {
	override method horasDeSolToleradas() { return 6 }
	override method condicionParaSemillas() { return altura > 0.4 }
	override method espacioQueOcupa() { return altura * 3 }
	override method esIdeal(parcela) { return parcela.superficie() > 6 }
}

class HierbaBuena inherits Menta {
	override method espacioQueOcupa() { return super() * 2 }
}


class Soja inherits Planta {
	override method horasDeSolToleradas() { return if (altura < 0.5) 6 else if (altura < 1) 7 else 9 }
	override method condicionParaSemillas() { return anioObtencion > 2007 and altura > 1 }
	override method espacioQueOcupa() { return altura / 2 }
	override method esIdeal(parcela) { return parcela.horasDeSol() == self.horasDeSolToleradas() }
}

class SojaTransgenica inherits Soja {
	override method daNuevasSemillas() { return false }
	override method esIdeal(parcela) { return parcela.monocultivo() }
}


class Quinoa inherits Planta {
	const property horasDeSolToleradas
	
	override method condicionParaSemillas() { return anioObtencion < 2005 }
	override method espacioQueOcupa() { return 0.5 }
	override method esIdeal(parcela) { return not parcela.tienePlantasAltas() }
}



class Parcela {
	const ancho
	const largo
	const property horasDeSol
	const property plantas = []
//	const tipo = ecologico // Alternativa 2
	
	method superficie() { return ancho * largo }
	method cantidadMaximaDePlantas() { return 
		if (ancho > largo) 	{ self.superficie() / 5 } 
		else 				{ self.superficie() / 3 + largo }
	}
	method tieneComplicaciones() { 
		return plantas.any({ planta => planta.horasDeSolToleradas() < horasDeSol })
//		return plantas.any({ planta => planta.toleraCantidadDeSol(horasDeSol ) })
	}
	
	method plantar(planta) {
		self.validarNuevaPlanta(planta)
		plantas.add(planta)
	}
	
	method validarNuevaPlanta(planta) {
		if (plantas.size() + 1 > self.cantidadMaximaDePlantas()) {
			self.error("La parcela ya está llena.")
		}
		
		if (horasDeSol - planta.horasDeSolToleradas() >= 2) {
			self.error("Esta parcela recibe mucho sol para esa plata.")
		}
	}
	
	method monocultivo() { return self.cantidadMaximaDePlantas() == 1 }
	
	method tienePlantasAltas() { return plantas.any({ planta => planta.esAlta() }) }
	
	method seAsociaBien(planta) // Alternativa 1
	
//	method seAsociaBien(planta) { // Alternativa 2
//		return tipo.seAsociaBien(planta, self)
//	} 

	method cantPlantas() { return plantas.size() }
	
	method porcentajePlantasBienAsociadas() {
		return self.plantasBienAsociadas().size() / self.cantPlantas() * 100 
	}
	
	method plantasBienAsociadas() {
		return plantas.filter({ planta => self.seAsociaBien(planta) })
	}
}


// ALternativa 1: Herencia
class ParcelaEcologica inherits Parcela {
	override method seAsociaBien(planta) { 
		return not self.tieneComplicaciones() and planta.esIdeal(self)
	}
}


class ParcelaIndustrial inherits Parcela {
	override method seAsociaBien(planta) { 
		return self.cantPlantas() <= 2 and planta.esFuerte()
	}
}

// Alternativa 2: Composicion
object ecologico {
	method seAsociaBien(planta, parcela) {
		return not parcela.tieneComplicaciones() and planta.esIdeal(parcela)
	}
}

object industrial {
	method seAsociaBien(planta, parcela) {
		return parcela.cantPlantas() <= 2 and planta.esFuerte()
	}
}


object inta {
	const parcelas = []
	
	method promedioDePlantas() { return self.cantPlantasTotales() / parcelas.size()}
	method cantPlantasTotales() { return parcelas.sum({ parcela => parcela.cantPlantas() })}
	
	method parcelaMasSustentable() { 
		return parcelas
			.filter({ parcela => parcela.cantPlantas() > 4 })
			.max({ parcela => parcela.porcentajePlantasBienAsociadas() })
	}
}







