¡Claro! Aquí tienes un ejemplo de README con ese estilo, pero adaptado a un proyecto de Xcode que incluye una app para **iOS y watchOS**:

---

# 📱⌚ Proyecto iOS + watchOS

Este es un proyecto base desarrollado en Xcode que incluye una aplicación principal para iPhone y una extensión complementaria para Apple Watch. Ideal para sincronizar datos entre dispositivos y experimentar con la integración entre plataformas de Apple. Ademas de enviar datos a un websockets.

## 🚀 Requisitos

- macOS con la última versión estable.
- [Xcode](https://developer.apple.com/xcode/) (versión 15 o superior recomendada).
- Un iPhone y un Apple Watch (simulador o dispositivo real).

## ⚙️ Configuración del proyecto

1. Clona este repositorio:
   ```bash
   git clone https://github.com/backsoul/cross-ios-watch.git
   ```

2. Abre el archivo `.xcworkspace` (si usas CocoaPods) o `.xcodeproj` directamente en Xcode:
   ```bash
   open counter.xcodeproj
   ```

3. Selecciona el **target** correcto:
   - `Counter-iOS` para la app del iPhone.
   - `Counter-WatchOS Extension` para la extensión del Apple Watch.

4. Conecta tu iPhone y Watch o usa simuladores para ejecutar y depurar.

## 🔄 Sincronización entre iOS y watchOS

El proyecto usa `WatchConnectivity` para sincronizar datos entre la app del iPhone y la del Apple Watch. Puedes probar el envío de datos activando acciones en uno de los dispositivos y observando la respuesta en el otro.
