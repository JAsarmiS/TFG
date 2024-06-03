import Foundation
import ImageIO
import AVFoundation

//Funcion para la extracción de imágenes
func Imagen(from imagenArchivo: String) {
    let imagenURL = URL(fileURLWithPath: imagenArchivo) // Convierte la ruta (URL) en un String
    
    guard FileManager.default.fileExists(atPath: imagenURL.path) else {
        print("El archivo de audio no existe en la ruta proporcionada.")
        return
    }
    
    print("Ruta de la IMAGEN: \(imagenURL)\n")

    //Gestión de errores
    guard let imagenSource = CGImageSourceCreateWithURL(imagenURL as CFURL, nil) else {
        print("No se pudo crear la fuente de imagen para la URL dada.")
        return
    }

    guard let imagenPropiedades = CGImageSourceCopyPropertiesAtIndex(imagenSource, 0, nil) as? [String: Any] else { //el 0 es por si se pone un gif, para que coja la primera imagen
        print("No se pudieron extraer las propiedades de la imagen.")
        return
    }
    //Impresión de los metadatos
    print(imagenPropiedades)
}

func Audio(from audioArchivo: String) {
    let audioURL = URL(fileURLWithPath: audioArchivo) // Convierte la ruta (URL) en un String
    
    // Verificar si la URL es válida
    guard FileManager.default.fileExists(atPath: audioURL.path) else {
        print("El archivo de audio no existe en la ruta proporcionada.")
        return
    }
    
    let asset = AVURLAsset(url: audioURL) // Crea un objeto de fuente de audio para leer sus metadatos
    
    print("Ruta del AUDIO: \(audioURL)\n")
    
    // Verificar si hay formatos de metadatos disponibles
    guard !asset.availableMetadataFormats.isEmpty else {
        print("No hay formatos de metadatos disponibles para este archivo de audio.")
        return
    }
    
    for formato in asset.availableMetadataFormats {
        let metadato = asset.metadata(forFormat: formato)
        
        //Impresión de metadatos
        for item in metadato {
            if let key = item.commonKey?.rawValue, let value = item.value {
                print("\(key): \(value)")
            } else {
                print("*Metadato no disponible*")
            }
        }
    }
}

func Video(from videoArchivo: String) {
    let videoURL = URL(fileURLWithPath: videoArchivo)
    let asset = AVURLAsset(url: videoURL, options: [AVURLAssetPreferPreciseDurationAndTimingKey: true])

    // Verificar si la URL es válida
    guard FileManager.default.fileExists(atPath: videoURL.path) else {
        print("El archivo de audio no existe en la ruta proporcionada.")
        return
    }
    print("Ruta deL VIDEO: \(videoURL)\n")
    
    //Verificar si el archivo esta vacío de metadatos
    guard !asset.availableMetadataFormats.isEmpty else {
        print("No hay formatos de metadatos disponibles para este archivo de audio.")
        return
    }
    // Se exploran todos los formatos de metadatos disponibles
    for formato in asset.availableMetadataFormats {
        let metadato = asset.metadata(forFormat: formato)
        for item in metadato {
            
            //Extraer más metadatos, incluidos los que no son "commonKey"
            if let key = item.commonKey?.rawValue {
                if let valor = item.stringValue {
                    print("\(key): \(valor)")
                }
            } else if let key = item.key as? String {
                //Si el elemento de metadatos no tiene una commonKey, compruebe su valor
                if let valor = item.stringValue {
                    print("\(key): \(valor)")
                }
            } else if let key = item.identifier?.rawValue {
                //Se busca el identificador si está disponible
                if let valor = item.stringValue {
                    print("\(key): \(valor)")
                }
            }
            else { //Mensaje de error
                print("*Metadato no disponible*")
            }
        }
    }
}

//Lectura de la carpeta
func procesarCarpeta(_ carpeta: String) {
    let fileManager = FileManager.default
    let carpetaURL = URL(fileURLWithPath: carpeta)
    
    do {
        let archivos = try fileManager.contentsOfDirectory(at: carpetaURL, includingPropertiesForKeys: nil, options: [])
        
        //filtro de formato de archivo
        for archivo in archivos {
            //Archivos de imagen
            if archivo.pathExtension == "jpg" || archivo.pathExtension == "jpeg" || archivo.pathExtension == "png" || archivo.pathExtension == "gif"{
                Imagen(from: archivo.path)
                print("\n")
            }
            //Archivos de audio
            else if archivo.pathExtension == "mp3" || archivo.pathExtension == "wav" || archivo.pathExtension == "flac" || archivo.pathExtension == "m4a"{
                Audio(from: archivo.path)
                print("\n")
            }
            //Archivos de video
            else if archivo.pathExtension == "mp4" || archivo.pathExtension == "MOV"{
                Video(from: archivo.path)
                print("\n")
            }
        }
    } 
    //Gestión de errores
    catch {
        print("Error al leer el contenido de la carpeta: \(error)")
    }
}

//Introducción de archivo
let carpetaArchivos = "/Users/administrador/Desktop/pruebas/archivosMain"
procesarCarpeta(carpetaArchivos)

