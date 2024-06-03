import Foundation
import AVFoundation

func FiltroAudio(from audioArchivo: String) {
    let audioURL = URL(fileURLWithPath: audioArchivo)
    let asset = AVURLAsset(url: audioURL)

    print("Metadatos del AUDIO \(audioArchivo):")
    
    var hayCopyright = false
    
    for formato in asset.availableMetadataFormats {
        let metadato = asset.metadata(forFormat: formato)
        for item in metadato {
            if let key = item.commonKey?.rawValue, let value = item.value {
                if key == "copyrights" {
                    hayCopyright = true
                    print("Audio con copyright\n")
                    print("Derechos pertenecientes a: \(value)")
                }
            }
        }
    }
    
    if !hayCopyright {
        print("No se encontró información de copyright en los metadatos del archivo de audio.")
        let fileManager = FileManager.default
        let destinationFolder = "/Users/administrador/Desktop/musicaSinCopyright"
        let destinationURL = URL(fileURLWithPath: destinationFolder).appendingPathComponent(audioURL.lastPathComponent)
        do {
            if !fileManager.fileExists(atPath: destinationFolder) {
                try fileManager.createDirectory(atPath: destinationFolder, withIntermediateDirectories: true, attributes: nil)
            }
            try fileManager.copyItem(at: audioURL, to: destinationURL)
            print("El archivo de audio ha sido copiado a la carpeta: \(destinationFolder)")
        } 
        catch {
            print("Error al copiar el archivo de audio a la carpeta: \(error)")
        }
    }
}

func leerCarpeta(_ carpeta: String) {
    let fileManager = FileManager.default
    let carpetaURL = URL(fileURLWithPath: carpeta)
    do {
        let archivos = try fileManager.contentsOfDirectory(at: carpetaURL, includingPropertiesForKeys: nil, options: [])
        for archivo in archivos {
            if archivo.pathExtension == "mp3" {
                FiltroAudio(from: archivo.path)
                print("\n")
            }
        }
    } 
    catch {
        print("Error al leer el contenido de la carpeta: \(error)")
    }
}

let carpetaArchivos = "/Users/administrador/Desktop/pruebas/archivosCU2"
leerCarpeta(carpetaArchivos)
