# swift-cognito-developer-auth
Swift AWS Cognito custom developer authentication.  

Look at <https://github.com/jwalstrom/aws-lambda-cognito-auth> for a sample lambda token generator

## Input

This is usually called in the AppDelegate and wrapped into a singleton to manage the Cognito tokens.

```swift
let authenticator = DeveloperAuthenticator()
let identityProvider = DeveloperIdentityProvider(providerName: "COGNITO_DEVELOPER_PROVIDER_NAME", authenticator: authenticator)
letcredentialsProvider = AWSCognitoCredentialsProvider(regionType: "COGNITO_REGION"
    identityProvider: identityProvider,
    unauthRoleArn:nil,
    authRoleArn:nil)
}
let defaultServiceConfiguration = AWSServiceConfiguration(region: AWSRegionType.USEast1, credentialsProvider: credentialsProvider)
AWSServiceManager.defaultServiceManager().defaultServiceConfiguration = defaultServiceConfiguration
```