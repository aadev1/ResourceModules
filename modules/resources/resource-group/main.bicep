metadata name = 'Resource Groups'
metadata description = 'This module deploys a Resource Group.'
metadata owner = 'Azure/module-maintainers'

targetScope = 'subscription'

@description('Required. The name of the Resource Group.')
param name string

@description('Optional. Location of the Resource Group. It uses the deployment\'s location when not provided.')
param location string = deployment().location

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments roleAssignmentType

@description('Optional. Tags of the storage account resource.')
param tags object = {}

@description('Optional. The ID of the resource that manages this resource group.')
param managedBy string = ''

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

var builtInRoleNames = {
  'API Management Service Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '312a565d-c81f-4fd8-895a-4e21e48d571c')
  'API Management Service Operator Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'e022efe7-f5ba-4159-bbe4-b44f577e9b61')
  'API Management Service Reader Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '71522526-b88f-4d52-b57f-d31fc3546d0d')
  'Application Group Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'ca6382a4-1721-4bcf-a114-ff0c70227b6b')
  'Application Insights Component Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'ae349356-3a1b-4a5e-921d-050484c6347e')
  'Application Insights Snapshot Debugger': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '08954f03-6346-4c2e-81c0-ec3a5cfae23b')
  'Automation Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'f353d9bd-d4a6-484e-a77a-8050b599b867')
  'Automation Job Operator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4fe576fe-1146-4730-92eb-48519fa6bf9f')
  'Automation Operator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'd3881f73-407a-4167-8283-e981cbba0404')
  'Automation Runbook Operator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '5fb5aef8-1081-4b8e-bb16-9d5d0385bab5')
  'Autonomous Development Platform Data Contributor (Preview)': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b8b15564-4fa6-4a59-ab12-03e1d9594795')
  'Autonomous Development Platform Data Owner (Preview)': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '27f8b550-c507-4db9-86f2-f4b8e816d59d')
  'Autonomous Development Platform Data Reader (Preview)': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'd63b75f7-47ea-4f27-92ac-e0d173aaf093')
  'Avere Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4f8fab4f-1852-4a58-a46a-8eaf358af14a')
  'Avere Operator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'c025889f-8102-4ebf-b32c-fc0c6f0c6bd9')
  'Azure Arc Enabled Kubernetes Cluster User Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '00493d72-78f6-4148-b6c5-d3ce8e4799dd')
  'Azure Arc Kubernetes Admin': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'dffb1e0c-446f-4dde-a09f-99eb5cc68b96')
  'Azure Arc Kubernetes Cluster Admin': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8393591c-06b9-48a2-a542-1bd6b377f6a2')
  'Azure Arc Kubernetes Viewer': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '63f0a09d-1495-4db4-a681-037d84835eb4')
  'Azure Arc Kubernetes Writer': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '5b999177-9696-4545-85c7-50de3797e5a1')
  'Azure Arc ScVmm Administrator role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'a92dfd61-77f9-4aec-a531-19858b406c87')
  'Azure Arc ScVmm Private Cloud User': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'c0781e91-8102-4553-8951-97c6d4243cda')
  'Azure Arc ScVmm Private Clouds Onboarding': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '6aac74c4-6311-40d2-bbdd-7d01e7c6e3a9')
  'Azure Arc ScVmm VM Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'e582369a-e17b-42a5-b10c-874c387c530b')
  'Azure Arc VMware Administrator role ': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'ddc140ed-e463-4246-9145-7c664192013f')
  'Azure Arc VMware Private Cloud User': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'ce551c02-7c42-47e0-9deb-e3b6fc3a9a83')
  'Azure Arc VMware Private Clouds Onboarding': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '67d33e57-3129-45e6-bb0b-7cc522f762fa')
  'Azure Arc VMware VM Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b748a06d-6150-4f8a-aaa9-ce3940cd96cb')
  'Azure Center for SAP solutions administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7b0c7e81-271f-4c71-90bf-e30bdfdbc2f7')
  'Azure Center for SAP solutions reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '05352d14-a920-4328-a0de-4cbe7430e26b')
  'Azure Center for SAP solutions service role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'aabbc5dd-1af0-458b-a942-81af88f9c138')
  'Azure Connected Machine Resource Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'cd570a14-e51a-42ad-bac8-bafd67325302')
  'Azure Extension for SQL Server Deployment': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7392c568-9289-4bde-aaaa-b7131215889d')
  'Azure Front Door Domain Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '0ab34830-df19-4f8c-b84e-aa85b8afa6e8')
  'Azure Front Door Domain Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '0f99d363-226e-4dca-9920-b807cf8e1a5f')
  'Azure Front Door Secret Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '3f2eb865-5811-4578-b90a-6fc6fa0df8e5')
  'Azure Front Door Secret Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '0db238c4-885e-4c4f-a933-aa2cef684fca')
  'Azure Kubernetes Fleet Manager Contributor Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '63bb64ad-9799-4770-b5c3-24ed299a07bf')
  'Azure Kubernetes Fleet Manager RBAC Admin': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '434fb43a-c01c-447e-9f67-c3ad923cfaba')
  'Azure Kubernetes Fleet Manager RBAC Cluster Admin': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '18ab4d3d-a1bf-4477-8ad9-8359bc988f69')
  'Azure Kubernetes Fleet Manager RBAC Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '30b27cfc-9c84-438e-b0ce-70e35255df80')
  'Azure Kubernetes Fleet Manager RBAC Writer': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '5af6afb3-c06c-4fa4-8848-71a8aee05683')
  'Azure Kubernetes Service Contributor Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'ed7f3fbd-7b88-4dd4-9017-9adb7ce333f8')
  'Azure Kubernetes Service Policy Add-on Deployment': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '18ed5180-3e48-46fd-8541-4ea054d57064')
  'Azure Kubernetes Service RBAC Admin': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '3498e952-d568-435e-9b2c-8d77e338d7f7')
  'Azure Kubernetes Service RBAC Cluster Admin': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b1ff04bb-8a4e-4dc4-8eb5-8693973ce19b')
  'Azure Kubernetes Service RBAC Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7f6c6a51-bcf8-42ba-9220-52d62157d7db')
  'Azure Kubernetes Service RBAC Writer': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'a7ffa36f-339b-4b5c-8bdf-e2c188b2c0eb')
  'Azure Maps Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'dba33070-676a-4fb0-87fa-064dc56ff7fb')
  'Azure Stack HCI registration role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'bda0d508-adf1-4af0-9c28-88919fc3ae06')
  'Azure Traffic Controller Configuration Manager': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'fbc52c3f-28ad-4303-a892-8a056630b8f1')
  'Backup Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '5e467623-bb1f-42f4-a55d-6e525e11384b')
  'Backup Operator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '00c29273-979b-4161-815c-10b084fb9324')
  'BizTalk Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '5e3c6656-6cfa-4708-81fe-0de47ac73342')
  'Blueprint Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '41077137-e803-4205-871c-5a86e6a753b4')
  'Blueprint Operator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '437d2ced-4a38-4302-8479-ed2bcb43d090')
  'CDN Endpoint Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '426e0c7f-0c7e-4658-b36f-ff54d6c29b45')
  'CDN Endpoint Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '871e35f6-b5c1-49cc-a043-bde969a0f2cd')
  'CDN Profile Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'ec156ff8-a8d1-4d15-830c-5b80698ca432')
  'CDN Profile Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8f96442b-4075-438f-813d-ad51ab4019af')
  'Chamber Admin': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4e9b8407-af2e-495b-ae54-bb60a55b1b5a')
  'Chamber User': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4447db05-44ed-4da3-ae60-6cbece780e32')
  'Classic Network Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b34d265f-36f7-4a0d-a4d4-e158ca92e90f')
  'Classic Storage Account Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '86e8f5dc-a6e9-4c67-9d15-de283e8eac25')
  'Classic Virtual Machine Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'd73bb868-a0df-4d4d-bd69-98a00b01fccb')
  'ClearDB MySQL DB Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '9106cda0-8a86-4e81-b686-29a22c54effe')
  'Code Signing Certificate Profile Signer': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '2837e146-70d7-4cfd-ad55-7efa6464f958')
  'Cognitive Services Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '25fbc0a9-bd7c-42a3-aa1a-3b75d497ee68')
  'Cognitive Services User': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'a97b65f3-24c7-4388-baec-2e87135dc908')
  'Collaborative Data Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'daa9e50b-21df-454c-94a6-a8050adab352')
  'Collaborative Runtime Operator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7a6f0e70-c033-4fb1-828c-08514e5f4102')
  'ContainerApp Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'ad2dd5fb-cd4b-4fd4-a9b6-4fed3630980b')
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'Cosmos DB Account Reader Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'fbdf93bf-df7d-467e-a4d2-9458aa1360c8')
  'Cosmos DB Operator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '230815da-be43-4aae-9cb4-875f7bd000aa')
  'Cost Management Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '434105ed-43f6-45c7-a02f-909b2ba83430')
  'Cost Management Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '72fafb9e-0641-4937-9268-a91bfd8191a3')
  'Data Box Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'add466c9-e687-43fc-8d98-dfcf8d720be5')
  'Data Factory Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '673868aa-7521-48a0-acc6-0f60742d39f5')
  'Data Lake Analytics Developer': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '47b7735b-770e-4598-a7da-8b91488b4c88')
  'Deployment Environments User': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '18e40d4e-8d2e-438d-97e1-9528336e149c')
  'Desktop Virtualization Application Group Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '86240b0e-9422-4c43-887b-b61143f32ba8')
  'Desktop Virtualization Application Group Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'aebf23d0-b568-4e86-b8f9-fe83a2c6ab55')
  'Desktop Virtualization Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '082f0a83-3be5-4ba1-904c-961cca79b387')
  'Desktop Virtualization Host Pool Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'e307426c-f9b6-4e81-87de-d99efb3c32bc')
  'Desktop Virtualization Host Pool Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'ceadfde2-b300-400a-ab7b-6143895aa822')
  'Desktop Virtualization Power On Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '489581de-a3bd-480d-9518-53dea7416b33')
  'Desktop Virtualization Power On Off Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '40c5ff49-9181-41f8-ae61-143b0e78555e')
  'Desktop Virtualization Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '49a72310-ab8d-41df-bbb0-79b649203868')
  'Desktop Virtualization Session Host Operator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '2ad6aaab-ead9-4eaa-8ac5-da422f562408')
  'Desktop Virtualization User Session Operator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'ea4bfff8-7fb4-485a-aadd-d4129a0ffaa6')
  'Desktop Virtualization Virtual Machine Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'a959dbd1-f747-45e3-8ba6-dd80f235f97c')
  'Desktop Virtualization Workspace Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '21efdde3-836f-432b-bf3d-3e8e734d4b2b')
  'Desktop Virtualization Workspace Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '0fa44ee9-7a7d-466b-9bb2-2bf446b1204d')
  'DevCenter Dev Box User': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '45d50f46-0b78-4001-a660-4198cbe8cd05')
  'DevCenter Project Admin': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '331c37c6-af14-46d9-b9f4-e1909e1b95a0')
  'Device Update Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '02ca0879-e8e4-47a5-a61e-5c618b76e64a')
  'Device Update Content Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '0378884a-3af5-44ab-8323-f5b22f9f3c98')
  'Device Update Content Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'd1ee9a80-8b14-47f0-bdc2-f4a351625a7b')
  'Device Update Deployments Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'e4237640-0e3d-4a46-8fda-70bc94856432')
  'Device Update Deployments Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '49e2f5d2-7741-4835-8efa-19e1fe35e47f')
  'Device Update Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'e9dba6fb-3d52-4cf0-bce3-f06ce71b9e0f')
  'DevTest Labs User': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '76283e04-6283-4c54-8f91-bcf1374a3c64')
  'Disk Pool Operator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '60fc6e62-5479-42d4-8bf4-67625fcc2840')
  'Disk Restore Operator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b50d9833-a0cb-478e-945f-707fcc997c13')
  'Disk Snapshot Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7efff54f-a5b4-42b5-a1c5-5411624893ce')
  'DNS Resolver Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '0f2ebee7-ffd4-4fc0-b3b7-664099fdad5d')
  'DNS Zone Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'befefa01-2a29-4197-83a8-272ff33ce314')
  'DocumentDB Account Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '5bd9cd88-fe45-4216-938b-f97437e15450')
  'Domain Services Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'eeaeda52-9324-47f6-8069-5d5bade478b2')
  'Domain Services Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '361898ef-9ed1-48c2-849c-a832951106bb')
  'Elastic SAN Owner': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '80dcbedb-47ef-405d-95bd-188a1b4ac406')
  'Elastic SAN Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'af6a70f8-3c9f-4105-acf1-d719e9fca4ca')
  'EventGrid Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '1e241071-0855-49ea-94dc-649edcd759de')
  'EventGrid Data Sender': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'd5a91429-5739-47e2-a06b-3470a27159e7')
  'EventGrid EventSubscription Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '428e0ff0-5e57-4d9c-a221-2c70d0e0a443')
  'EventGrid EventSubscription Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '2414bbcf-6497-4faf-8c65-045460748405')
  'Experimentation Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7f646f1b-fa08-80eb-a33b-edd6ce5c915c')
  'Experimentation Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7f646f1b-fa08-80eb-a22b-edd6ce5c915c')
  'Guest Configuration Resource Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '088ab73d-1256-47ae-bea9-9de8e7131f31')
  'HDInsight Cluster Operator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '61ed4efc-fab3-44fd-b111-e24485cc132a')
  'Intelligent Systems Account Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '03a6d094-3444-4b3d-88af-7477090a9e5e')
  'Key Vault Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '00482a5a-887f-4fb3-b363-3b7fe8e74483')
  'Key Vault Certificates Officer': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'a4417e6f-fecd-4de8-b567-7b0420556985')
  'Key Vault Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'f25e0fa2-a7c8-4377-a976-54943a77a395')
  'Key Vault Crypto Officer': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '14b46e9e-c2b7-41b4-b07b-48a6ebf60603')
  'Key Vault Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '21090545-7ca7-4776-b22c-e363652d74d2')
  'Key Vault Secrets Officer': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b86a8fe4-44ce-4948-aee5-eccb2c155cd7')
  'Kubernetes Cluster - Azure Arc Onboarding': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '34e09817-6cbe-4d01-b1a2-e0eac5743d41')
  'Kubernetes Extension Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '85cb6faf-e071-4c9b-8136-154b5a04f717')
  'Lab Assistant': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'ce40b423-cede-4313-a93f-9b28290b72e1')
  'Lab Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '5daaa2af-1fe8-407c-9122-bba179798270')
  'Lab Creator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b97fb8bc-a8b2-4522-a38b-dd33c7e65ead')
  'Lab Operator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'a36e6959-b6be-4b12-8e9f-ef4b474d304d')
  'Lab Services Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'f69b8690-cc87-41d6-b77a-a4bc3c0a966f')
  'Lab Services Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '2a5c394f-5eb7-4d4f-9c8e-e8eae39faebc')
  'Load Test Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '749a398d-560b-491b-bb21-08924219302e')
  'Load Test Owner': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '45bb0b16-2f0c-4e78-afaa-a07599b003f6')
  'Load Test Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '3ae3fb29-0000-4ccd-bf80-542e7b26e081')
  'LocalNGFirewallAdministrator role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'a8835c7d-b5cb-47fa-b6f0-65ea10ce07a2')
  'LocalRulestacksAdministrator role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'bfc3b73d-c6ff-45eb-9a5f-40298295bf20')
  'Log Analytics Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '92aaf0da-9dab-42b6-94a3-d43ce8d16293')
  'Log Analytics Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '73c42c96-874c-492b-b04d-ab87d138a893')
  'Logic App Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '87a39d53-fc1b-424a-814c-f7e04687dc9e')
  'Logic App Operator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '515c2055-d9d4-4321-b1b9-bd0c9a0f79fe')
  'Managed Application Contributor Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '641177b8-a67a-45b9-a033-47bc880bb21e')
  'Managed Application Operator Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'c7393b34-138c-406f-901b-d8cf2b17e6ae')
  'Managed Applications Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b9331d33-8a36-4f8c-b097-4f54124fdb44')
  'Managed Identity Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'e40ec5ca-96e0-45a2-b4ff-59039f2c2b59')
  'Managed Identity Operator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'f1a07417-d97a-45cb-824c-7a7467783830')
  'Media Services Account Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '054126f8-9a2b-4f1c-a9ad-eca461f08466')
  'Media Services Live Events Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '532bc159-b25e-42c0-969e-a1d439f60d77')
  'Media Services Media Operator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'e4395492-1534-4db2-bedf-88c14621589c')
  'Media Services Policy Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'c4bba371-dacd-4a26-b320-7250bca963ae')
  'Media Services Streaming Endpoints Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '99dba123-b5fe-44d5-874c-ced7199a5804')
  'Microsoft Sentinel Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'ab8e14d6-4a74-4a29-9ba8-549422addade')
  'Microsoft Sentinel Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8d289c81-5878-46d4-8554-54e1e3d8b5cb')
  'Microsoft Sentinel Responder': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '3e150937-b8fe-4cfb-8069-0eaf05ecd056')
  'Monitoring Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '749f88d5-cbae-40b8-bcfc-e573ddc772fa')
  'Monitoring Metrics Publisher': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '3913510d-42f4-4e42-8a64-420c390055eb')
  'Monitoring Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '43d0d8ad-25c7-4714-9337-8ba259a9fe05')
  'Network Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4d97b98b-1d4f-4787-a291-c67834d212e7')
  'New Relic APM Account Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '5d28c62d-5b37-4476-8438-e587778df237')
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  'PlayFab Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '0c8b84dc-067c-4039-9615-fa1a4b77c726')
  'PlayFab Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'a9a19cc5-31f4-447c-901f-56c0bb18fcaf')
  'Private DNS Zone Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b12aa53e-6015-4669-85d0-8515ebb3ae7f')
  'Quota Request Operator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '0e5f05e5-9ab9-446b-b98d-1e2157c94125')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Redis Cache Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'e0f68234-74aa-48ed-b826-c38b57376e17')
  'Reservation Purchaser': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'f7b75c60-3036-4b75-91c3-6b41c27c1689')
  'Resource Policy Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '36243c78-bf99-498c-9df9-86d9f8d28608')
  'Role Based Access Control Administrator (Preview)': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'f58310d9-a9f6-439a-9e8d-f62e7b41a168')
  'Scheduler Job Collections Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '188a0f2f-5c9e-469b-ae67-2aa5ce574b94')
  'Search Service Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7ca78c08-252a-4471-8644-bb5ff32d4ba0')
  'Security Admin': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'fb1c8493-542b-48eb-b624-b4c8fea62acd')
  'Security Manager (Legacy)': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'e3d13bf0-dd5a-482e-ba6b-9b8433878d10')
  'Security Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '39bc4728-0917-49c7-9d2c-d95423bc2eb4')
  'Services Hub Operator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '82200a5b-e217-47a5-b665-6d8765ee745b')
  'SignalR AccessKey Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '04165923-9d83-45d5-8227-78b77b0a687e')
  'SignalR/Web PubSub Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8cf5e20a-e4b2-4e9d-b3a1-5ceb692c2761')
  'Site Recovery Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '6670b86e-a3f7-4917-ac9b-5d6ab1be4567')
  'Site Recovery Operator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '494ae006-db33-4328-bf46-533a6560a3ca')
  'SQL DB Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '9b7fa17d-e63e-47b0-bb0a-15c516ac86ec')
  'SQL Managed Instance Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4939a1f6-9ae0-4e48-a1e0-f2cbe897382d')
  'SQL Security Manager': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '056cd41c-7e88-42e1-933e-88ba6a50c9c3')
  'SQL Server Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '6d8ee4ec-f05a-4a1d-8b00-a9b17e38b437')
  'Storage Account Backup Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'e5e2a7ff-d759-4cd2-bb51-3152d37e2eb1')
  'Storage Account Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '17d1049b-9a84-46fb-8f53-869881c3d3ab')
  'Support Request Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'cfd33db0-3dd1-45e3-aa9d-cdbdf3b6f24e')
  'Tag Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4a9ae827-6dc8-4573-8ac7-8239d42aa03f')
  'Template Spec Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '1c9b6475-caf0-4164-b5a1-2142a7116f4b')
  'Template Spec Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '392ae280-861d-42bd-9ea5-08ee6d83b80e')
  'Traffic Manager Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'a4b10055-b0c7-44c2-b00f-c7b5b3550cf7')
  'User Access Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9')
  'Virtual Machine Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '9980e02c-c2be-4d73-94e8-173b1dc7cf3c')
  'Web Plan Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '2cc479cb-7b4d-49a8-b449-8c00fd0f0a4b')
  'Website Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'de139f84-1756-47ae-9be6-808fbbe84772')
}

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name, location)}'
  location: location
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  location: location
  name: name
  tags: tags
  managedBy: managedBy
  properties: {}
}

module resourceGroup_lock 'modules/nested_lock.bicep' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: '${uniqueString(deployment().name, location)}-RG-Lock'
  params: {
    lock: lock
    name: resourceGroup.name
  }
  scope: resourceGroup
}

resource resourceGroup_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for (roleAssignment, index) in (roleAssignments ?? []): {
  name: guid(resourceGroup.id, roleAssignment.principalId, roleAssignment.roleDefinitionIdOrName)
  properties: {
    roleDefinitionId: contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName] : roleAssignment.roleDefinitionIdOrName
    principalId: roleAssignment.principalId
    description: roleAssignment.?description
    principalType: roleAssignment.?principalType
    condition: roleAssignment.?condition
    conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
    delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
  }
}]

@description('The name of the resource group.')
output name string = resourceGroup.name

@description('The resource ID of the resource group.')
output resourceId string = resourceGroup.id

@description('The location the resource was deployed into.')
output location string = resourceGroup.location

// =============== //
//   Definitions   //
// =============== //

type lockType = {
  @description('Optional. Specify the name of lock.')
  name: string?

  @description('Optional. Specify the type of lock.')
  kind: ('CanNotDelete' | 'ReadOnly' | 'None')?
}?

type roleAssignmentType = {
  @description('Required. The name of the role to assign. If it cannot be found you can specify the role definition ID instead.')
  roleDefinitionIdOrName: string

  @description('Required. The principal ID of the principal (user/group/identity) to assign the role to.')
  principalId: string

  @description('Optional. The principal type of the assigned principal ID.')
  principalType: ('ServicePrincipal' | 'Group' | 'User' | 'ForeignGroup' | 'Device' | null)?

  @description('Optional. The description of the role assignment.')
  description: string?

  @description('Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container"')
  condition: string?

  @description('Optional. Version of the condition.')
  conditionVersion: '2.0'?

  @description('Optional. The Resource Id of the delegated managed identity resource.')
  delegatedManagedIdentityResourceId: string?
}[]?
