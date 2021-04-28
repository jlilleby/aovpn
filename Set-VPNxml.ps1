$vpnprofiles = Read-Host "Enter VPN Profile"
$custID = Read-Host "Enter Customer ID i.e. 50xx"
$fqdn = Read-Host "Enter customer FQDN i.e. domain.com"
$server = Read-Host "Enter Server Address i.e vpn.domain.com"
$dc01 = Read-Host "Enter IP of Customer Domain Controller 01 i.e. 50xxdc01 = 10.136.xxx.2"
$dc02 = Read-Host "Enter IP of Customer Domain Controller 02 i.e. 50xxdc01 = 10.136.xxx.3"

$RouteObjects = Import-CSV "C:\Users\Jone\OneDrive - Hatteland\03Scripts\PS.VPN.XML\routes.csv"
New-Item -Path "C:\Users\Jone\OneDrive - Hatteland\03Scripts\PS.VPN.XML\$custID-vpn.xml" -ItemType File

Write-Verbose "Extracting EAP configuration from template connection $vpnprofiles"
$vpnprofile = Get-VpnConnection -Name $vpnprofiles
$vpnconfig = $vpnprofile.EapConfigXmlStream.InnerXml

Write-Verbose "Creating XML file"
Add-Content -Path "C:\Users\Jone\OneDrive - Hatteland\03Scripts\PS.VPN.XML\$custID-vpn.xml" -Value '<VPNProfile>'
Add-Content -Path "C:\Users\Jone\OneDrive - Hatteland\03Scripts\PS.VPN.XML\$custID-vpn.xml" -Value "    <DnsSuffix>$fqdn</DnsSuffix>"
Add-Content -Path "C:\Users\Jone\OneDrive - Hatteland\03Scripts\PS.VPN.XML\$custID-vpn.xml" -Value '    <NativeProfile>'
Add-Content -Path "C:\Users\Jone\OneDrive - Hatteland\03Scripts\PS.VPN.XML\$custID-vpn.xml" -Value "        <Servers>$server</Servers>"
Add-Content -Path "C:\Users\Jone\OneDrive - Hatteland\03Scripts\PS.VPN.XML\$custID-vpn.xml" -Value '        <NativeProtocolType>IKEv2</NativeProtocolType>'
Add-Content -Path "C:\Users\Jone\OneDrive - Hatteland\03Scripts\PS.VPN.XML\$custID-vpn.xml" -Value '        <Authentication>'
Add-Content -Path "C:\Users\Jone\OneDrive - Hatteland\03Scripts\PS.VPN.XML\$custID-vpn.xml" -Value '            <UserMethod>Eap</UserMethod>'
Add-Content -Path "C:\Users\Jone\OneDrive - Hatteland\03Scripts\PS.VPN.XML\$custID-vpn.xml" -Value '            <Eap>'
Add-Content -Path "C:\Users\Jone\OneDrive - Hatteland\03Scripts\PS.VPN.XML\$custID-vpn.xml" -Value '                <Configuration>'
Add-Content -Path "C:\Users\Jone\OneDrive - Hatteland\03Scripts\PS.VPN.XML\$custID-vpn.xml" -Value "                       $vpnconfig"
Add-Content -Path "C:\Users\Jone\OneDrive - Hatteland\03Scripts\PS.VPN.XML\$custID-vpn.xml" -Value '               </Configuration>'
Add-Content -Path "C:\Users\Jone\OneDrive - Hatteland\03Scripts\PS.VPN.XML\$custID-vpn.xml" -Value '            </Eap>'
Add-Content -Path "C:\Users\Jone\OneDrive - Hatteland\03Scripts\PS.VPN.XML\$custID-vpn.xml" -Value '        </Authentication>'
Add-Content -Path "C:\Users\Jone\OneDrive - Hatteland\03Scripts\PS.VPN.XML\$custID-vpn.xml" -Value '        <RoutingPolicyType>ForceTunnel</RoutingPolicyType>'
Add-Content -Path "C:\Users\Jone\OneDrive - Hatteland\03Scripts\PS.VPN.XML\$custID-vpn.xml" -Value '    </NativeProfile>'
Add-Content -Path "C:\Users\Jone\OneDrive - Hatteland\03Scripts\PS.VPN.XML\$custID-vpn.xml" -Value '    <Route>'

    ForEach ( $RouteObject in $RouteObjects ) {
        #Assign the content to variables
        $Segment = $RouteObject.segment
        $Prefix = $RouteObject.prefix
        
        Add-Content -Path "C:\Users\Jone\OneDrive - Hatteland\03Scripts\PS.VPN.XML\$custID-vpn.xml" -Value "                                                                                                            <Address>$Segment</Address>"
        Add-Content -Path "C:\Users\Jone\OneDrive - Hatteland\03Scripts\PS.VPN.XML\$custID-vpn.xml" -Value "                                                                                                            <PrefixSize>$Prefix</PrefixSize>"
        Add-Content -Path "C:\Users\Jone\OneDrive - Hatteland\03Scripts\PS.VPN.XML\$custID-vpn.xml" -Value "                                                                                                            <ExclusionRoute>true</ExclusionRoute>"
        }  

Add-Content -Path "C:\Users\Jone\OneDrive - Hatteland\03Scripts\PS.VPN.XML\$custID-vpn.xml" -Value '    </Route>'
Add-Content -Path "C:\Users\Jone\OneDrive - Hatteland\03Scripts\PS.VPN.XML\$custID-vpn.xml" -Value '    <AlwaysOn>true</AlwaysOn>'
Add-Content -Path "C:\Users\Jone\OneDrive - Hatteland\03Scripts\PS.VPN.XML\$custID-vpn.xml" -Value '    <RememberCredentials>true</RememberCredentials>'
Add-Content -Path "C:\Users\Jone\OneDrive - Hatteland\03Scripts\PS.VPN.XML\$custID-vpn.xml" -Value "    <TrustedNetworkDetection>$fqdnhatteland.com</TrustedNetworkDetection>"
Add-Content -Path "C:\Users\Jone\OneDrive - Hatteland\03Scripts\PS.VPN.XML\$custID-vpn.xml" -Value '    <DomainNameInformation>'
Add-Content -Path "C:\Users\Jone\OneDrive - Hatteland\03Scripts\PS.VPN.XML\$custID-vpn.xml" -Value "        <DomainName>$fqdn</DomainName>"
Add-Content -Path "C:\Users\Jone\OneDrive - Hatteland\03Scripts\PS.VPN.XML\$custID-vpn.xml" -Value "        <DnsServers>$dc01,$dc02</DnsServers>"
Add-Content -Path "C:\Users\Jone\OneDrive - Hatteland\03Scripts\PS.VPN.XML\$custID-vpn.xml" -Value '    </DomainNameInformation>'
Add-Content -Path "C:\Users\Jone\OneDrive - Hatteland\03Scripts\PS.VPN.XML\$custID-vpn.xml" -Value '    <RegisterDNS>true</RegisterDNS>'
Add-Content -Path "C:\Users\Jone\OneDrive - Hatteland\03Scripts\PS.VPN.XML\$custID-vpn.xml" -Value '</VPNProfile>'


