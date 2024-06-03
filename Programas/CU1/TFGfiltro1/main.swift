import Foundation
import ImageIO

func FiltroImagen(from imagenArchivo: String) {
    let imagenURL = URL(fileURLWithPath: imagenArchivo)
     
    //Gestión de errores
    guard FileManager.default.fileExists(atPath: imagenURL.path) else {
        print("El archivo de audio no existe en la ruta proporcionada.")
        return
    }
    print("\nRuta de la imagen: \(imagenURL)")
    
    guard let imagenSource = CGImageSourceCreateWithURL(imagenURL as CFURL, nil) else {
        print("No se pudo crear la fuente de imagen para la URL dada.")
        return
    }

    guard let imagenPropiedades = CGImageSourceCopyPropertiesAtIndex(imagenSource, 0, nil) as? [String: Any] else {
        print("No se pudieron extraer las propiedades de la imagen.")
        return
    }
    
    //Filtro
    if let gpsPropiedades = imagenPropiedades["{GPS}"] as? [String: Any] {
        if let latitud = gpsPropiedades["Latitude"] as? Double,
           let longitud = gpsPropiedades["Longitude"] as? Double {
            print("Latitud: \(latitud), Longitud: \(longitud)")
            if latitud >= 40.969 && latitud <= 40.972 && longitud >= 5.669 && longitud <= 5.672 {
                
                print("La imagen está dentro del rango especificado.")

                // Añadir a carpeta
                let fileManager = FileManager.default
                let carpetaDestino = "/Users/administrador/Desktop/filtroUbicacion"
                let URLdestino = URL(fileURLWithPath: carpetaDestino).appendingPathComponent(imagenURL.lastPathComponent)
                
                do {
                    if !fileManager.fileExists(atPath: carpetaDestino) {
                        try fileManager.createDirectory(atPath: carpetaDestino, withIntermediateDirectories: true, attributes: nil)
                    }
                    try fileManager.copyItem(at: imagenURL, to: URLdestino)
                    print("La imagen ha sido copiada a la carpeta: \(carpetaDestino)")
                } 
                //Gestión de errores
                catch {
                    print("Error al copiar la imagen a la carpeta: \(error)")
                }
                
            } else {
                print("La imagen está fuera del rango especificado.")
            }
        } else {
            print("No se pudo encontrar la latitud o longitud en las propiedades GPS.")
        }
    } else {
        print("No se encontraron propiedades GPS.")
    }
}

func procesarCarpeta(_ carpeta: String) {
    let fileManager = FileManager.default
    let carpetaURL = URL(fileURLWithPath: carpeta)
    
    do {
        let archivos = try fileManager.contentsOfDirectory(at: carpetaURL, includingPropertiesForKeys: nil, options: [])
        
        for archivo in archivos {
            if archivo.pathExtension == "jpg" || archivo.pathExtension == "jpeg" || archivo.pathExtension == "png" || archivo.pathExtension == "gif"{
                FiltroImagen(from: archivo.path)
                print("\n")
            }
        }
    } catch {
        print("Error al leer el contenido de la carpeta: \(error)")
    }
}

let carpetaArchivos = "/Users/administrador/Desktop/pruebas/archivosCU1"
procesarCarpeta(carpetaArchivos)
