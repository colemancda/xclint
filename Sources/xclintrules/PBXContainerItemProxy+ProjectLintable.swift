import Foundation
import xcproj

extension PBXContainerItemProxy: ProjectLintable {
    
    // MARK: - Public
    
    public func lint(project: PBXProj) -> [LintError] {
        var errors: [LintError] = []
        if let remoteGlobalIDStringError = lintRemoteGlobalIDString(project: project) {
            errors.append(remoteGlobalIDStringError)
        }
        if let containerPortalError = lintContainerPortal(project: project) {
            errors.append(containerPortalError)
        }
        return errors
    }
    
    // MARK: - Fileprivate
    
    fileprivate func lintRemoteGlobalIDString(project: PBXProj) -> LintError? {
        guard let remoteGlobalIDString = self.remoteGlobalIDString else { return nil }
        let exists = project.nativeTargets.contains(reference: remoteGlobalIDString)
        if exists { return nil }
        return LintError.missingReference(objectType: String(describing: type(of: self)),
                                          objectReference: reference,
                                          missingReference: "PBXFileReference<\(remoteGlobalIDString)>")
    }
    
    fileprivate func lintContainerPortal(project: PBXProj) -> LintError? {
        let exists = project.projects.contains(reference: containerPortal)
        if exists { return nil }
        return LintError.missingReference(objectType: String(describing: type(of: self)),
                                          objectReference: reference,
                                          missingReference: "PBXProject<\(containerPortal)>")
    }
    
}

