import Foundation

#if SWIFT_PACKAGE
import PlayerUI
#endif

/**
 Wrapper to instantiate @player-ui/common-types-plugin
 */
public class CommonTypesPlugin: JSBasePlugin, NativePlugin {
    /**
     Constructs a PartialMatchRegistry JS object
     */
    public convenience init() {
        self.init(fileName: "common-types-plugin.prod", pluginName: "CommonTypesPlugin.CommonTypesPlugin")
    }

    override open func getUrlForFile(fileName: String) -> URL? {
        #if SWIFT_PACKAGE
        ResourceUtilities.urlForFile(name: fileName, ext: "js", bundle: Bundle.module)
        #else
        ResourceUtilities.urlForFile(name: fileName, ext: "js", bundle: Bundle(for: CommonTypesPlugin.self), pathComponent: "CommonTypesPlugin.bundle")
        #endif
    }
}