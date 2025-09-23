Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010041.outbound.protection.outlook.com [52.101.56.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6F5E322C9B
	for <patches@lists.linux.dev>; Tue, 23 Sep 2025 13:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758633060; cv=fail; b=QucLAj30WCrvJVgQzGlqW5wmvHFLVhVsCoZuS5wPpo6QzjzNEYxGSSDPMV8s54ehR4VC/OfMl0R2MdRHhpgcmL2+6BvvjlsXfc/BSWMPTJrpBma9Bz8A2h2MXDpGuT2dpw6awE2e7TzOVwHSXcrkH9jFUQt+bdiCl/FchvMBvhI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758633060; c=relaxed/simple;
	bh=NJgVqsdmL5o6Jyum7D35QI/WKg4nRpa73Q/zl4DaoxI=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=FfM3/exuYJmRDpa0PFy3vvUAIjgy+vM5R1Bh6zB5QJFt9Vo3R83dUvEGCXCfftQcKkLXW28S55H8zvfrz9LVdj3zOKCmJRLWWZyg5Ko7udXHujCCqXe2Jrdzwmvn2bt4buorEDufAtWryBRdrP8sw8dOTUFn08CZmznkgsMvtiY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=EEjeqTzc; arc=fail smtp.client-ip=52.101.56.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="EEjeqTzc"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eiCyRLpNGclccdLs8ulIwH5xxbAuzCtkyfJS6s1QtcNG1j5NYtKUW2pcUR9ADKUCtRh1i//Kj3YZo7udTNSTuc/ZrPmecAkSPaecOHCDRqMjuh71YITB9WUbFAxTxxNBCpOI2yvVrJC9OY+/5SOF0Mj/6xdMqJWPizxogdWpHWb8Bxj92rk36xP6GJGSZuS9p33y6M+PozEws2BfGrumAWCg4ctoEgrnMQIR2re3Ug/oY70XSAjGwnBohd3Ztfp1ueVAOkFX423Q0LTzTaPrfImT7mSV4wVtU2ypSxl7kBmcy42Ca6NeUfAEaR0SykGhdB0sTCXLB9Eau28JDj/eyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mIXdEtkCilS8X/M4x4Ney2IZcbTj7hVMMIxjRd5YwIs=;
 b=ravPO/DqnlGuj0hTfBuWKf/clUQ44xZhUUn2GTudZh18MlnpGP90lJVraXXQScjshIBVMAijBrNxV2hmOsTQ2xLLj6JgV3MEv0gqh7COOMX/R/V0EKxD5fGY0FQ8n0yJSAu8Z/vHXyOaCX6gp2kq7JOOWGJAmE4W2fBSx76Mc7QXFp/pkNbakgA2cBEDkxseeVDzOdMXIbiG+A5w2iStCrBGPEMCU+IKAUkrkNYKA3LUzvKXE6pFwjZbkbRFzNfTLB9Xx7KfAc+kN3I170XVtTFvdMswGoOIYXFWKx+LWQRfZ5/sJvY1kX/4S7U6e6A8ISoJAuGH7UTfeUx6w1FJCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mIXdEtkCilS8X/M4x4Ney2IZcbTj7hVMMIxjRd5YwIs=;
 b=EEjeqTzc4ojwvKKtO4CU6tE7yhMZEblbWhVJgBUNV3nAZwgyInA/ErBULRV9ZuUtKqrsJdQA3MPxNQCjWGxNGsDNEoPaCBjYodUfOjUyCHnWSUexGU3JqRX1w5GXRmH+urlGLCGDVuatIORAB2Tvrc+OL3JqBYZhj3s7BmAnkE8UD3Aqjc4fxBRyckckz+of68B/3YeNrUekVemC4njep8TrGZuvs+7sCYiFtUzKpHY12hMHKJ0nk91wNeWW3zTYdvqnBME8Dtnx8MHMESXyfiak5cwifZy8ZEX/EjKjPOP3Iak9HvBNUStwBwbAyoRGBMbI6n+7JVSUZniywMGlYw==
Received: from DM6PR07CA0126.namprd07.prod.outlook.com (2603:10b6:5:330::9) by
 DS0PR12MB6559.namprd12.prod.outlook.com (2603:10b6:8:d1::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9160.9; Tue, 23 Sep 2025 13:10:55 +0000
Received: from CY4PEPF0000EE3A.namprd03.prod.outlook.com
 (2603:10b6:5:330:cafe::94) by DM6PR07CA0126.outlook.office365.com
 (2603:10b6:5:330::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.20 via Frontend Transport; Tue,
 23 Sep 2025 13:10:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CY4PEPF0000EE3A.mail.protection.outlook.com (10.167.242.12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.12 via Frontend Transport; Tue, 23 Sep 2025 13:10:55 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Tue, 23 Sep
 2025 06:10:38 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Tue, 23 Sep 2025 06:10:38 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 23 Sep 2025 06:10:38 -0700
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
	<rwarsow@gmx.de>, <conor@kernel.org>, <hargar@microsoft.com>,
	<broonie@kernel.org>, <achill@achill.org>, <linux-tegra@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH 6.16 000/149] 6.16.9-rc1 review
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <1dea06d2-4989-4c6b-97ec-1a98cdb42709@drhqmail202.nvidia.com>
Date: Tue, 23 Sep 2025 06:10:38 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE3A:EE_|DS0PR12MB6559:EE_
X-MS-Office365-Filtering-Correlation-Id: 380bffd2-dd38-4bb1-3261-08ddfaa2a157
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?R1BZajk4Mmtlb1VudzNoVFBxeTJvQjhraHQxM3N5N3NuYWlYc1R0SFpSNTZR?=
 =?utf-8?B?QW5pZkMvUEMrcjJCWXV3a0Frb0doVzJvTGgrampLNGFWNjJIbFAya1REM3BW?=
 =?utf-8?B?Tm9xWExiMm5kTHR2a1RhbDZDandQM2NtdmMyclhYazhMaGhJa1hQWXRRdTlK?=
 =?utf-8?B?UnJKTkoveDBkY3dTMW9ic2VZUnF0UHdFNS9IbU5SSzFxenlMKzhrVE1Vdkh1?=
 =?utf-8?B?bkVDUWdDWkhqMkdra3NINHgxbHBKM2NxZU91OVJXVmdzLzNweTFGUHg1NW8w?=
 =?utf-8?B?cXRSZGo1WDJrYkt3aWxIQm1LZ2JCR29VdjFLZFpkYkhleFZYVmdBai9GT1Fq?=
 =?utf-8?B?R2M0UWdVeUkwY3g1MElvNkM2NHc5NXB4RXpFYnVuVWw5ZlVJUFY5YnFjRHcx?=
 =?utf-8?B?TDNKcVVZekdPNmp2bFY0OUd4bmZ3bFdsYmtmY3pNZWpFNlplZjhBRmNrQ3R0?=
 =?utf-8?B?NGthOVFGR2RyTXdzSUozODFnMGZHQi8vOVI5RUhHbkxNSGZxeDBib21teFlh?=
 =?utf-8?B?MTRTL0IxRmZIR09SQ3lEY1lBbDlOZmFjUFAxanNIS2ZQSTJsUTZPNkVDYlh3?=
 =?utf-8?B?b01kY3B6RUU1SitFQUFGcURQUHdPanN4NVBOdHdFaGUvZ0VqdTVTYStwWGdp?=
 =?utf-8?B?dk9uTjV4dzhMZjE1NkVUZ0s3QVgyL3lkL2huNGMvcnZIS0ZHR3BHQUcxcjZ0?=
 =?utf-8?B?dVZ1WGVGeDlhK0FOQWsvblJWM1hRVXVXS0hiWG9TV1I5dWUwdGY1czVDdjNv?=
 =?utf-8?B?YitiVzhlUWZTaXg2Mjh1NTkyeG1ndkpuL1RqZExMRjVaTzlCeFpXRmwwa3Jl?=
 =?utf-8?B?aHpiZ3FFUWs0K09sM3M1aXEyb3dJdGd0SXJoczE0dlRPdG52bFhUcWxnc2dB?=
 =?utf-8?B?QlVkSDBwZllvWmx3b2I0WkVtMU51blVPVCs2QkVvK2h6YnZ6bFUvTUpxWThr?=
 =?utf-8?B?RElnKzQ4NDFoTlM2NjRYd2dhZmF1WU5UczZzOVNUT1BEVDU2blRUSXFvdTZw?=
 =?utf-8?B?Umc4UlJTWHNvL3ZEdmIvZ2hTcWpVeXNHeGxBNVdXVXNzUlRkbjNmUm1rZUky?=
 =?utf-8?B?bVd5Z0NwdnUxblZoSXB0eEtWckhYYTlLdTZkZ3BBSktnc2FzMW93VmVLQm5p?=
 =?utf-8?B?ZW9lV3VqV3MwVUtiY21nSS9zdGdzMG9lTFRUWmo4VnRsVW96NmNUak1YS3RN?=
 =?utf-8?B?UjRUTWdjbW5oVGFMdDFESE1ZdFh6RG1odzVoV1lnRXpib0FEUzViYTJqN2Ni?=
 =?utf-8?B?cy8vQUJUdjh3eTY5V0crbVI5Z2x4MFc4VWRnVGtpRFNkcmhCN3haeGY0TGVK?=
 =?utf-8?B?N2EwZ0lnM2Vkd3VTZ1pYcVVDa2tka1dDbTdISHIva3RyR2NKcXUxVWFETHNK?=
 =?utf-8?B?YXhWakxLRkJQWXR4VzFXZzEycVMvS3lNUWZFd1oxb3ZIcjFDWW1xWDIzcFBp?=
 =?utf-8?B?MG93VG5ZblBPbG1GMm5EelZpZ0ppRkdtbnVKSlFObW5XTHBGRDB2SHpiSTU5?=
 =?utf-8?B?TW9ucFhsZWJFMU5BMTl6V2RPakpSRzZuczF0RXhvVXczL3Z3OVRidkszdmtW?=
 =?utf-8?B?YnlqN3BjODFubG9mb0ZMOFg5N3hJUHFWd2MrY0dyMHJZRzhkc1V3Sk5RdkJ5?=
 =?utf-8?B?Zng1RFlON0dxUlhPeGtEU2k2c3hzVnIrK2xnb2Y1dVdrZHY3cUszek9HRkY1?=
 =?utf-8?B?NWpYWUJSbWVCRHhBT05LMXVnVXlRRUxDT0g5QnZzUmM1T09PZy9TVmlBbDV4?=
 =?utf-8?B?ZGdUSW5KVFU5Z2RJNnpaZFBBOUNKREc3dndQd3F5TjR6c25BQ05xdklHUFNl?=
 =?utf-8?B?eG84Q2taM2pFTjdjRWI0TmFPOWZ0dVM5ZC8rajZ0bFZ2UHZ0UU5aWDNYVWx1?=
 =?utf-8?B?U2R3ZG1KVmpFYkZiZjRWYmpEMVJHUHFYdmNhcmQ4V1NDb0svNlV1YWdpZzIx?=
 =?utf-8?B?YktIUytCQldiaHAyTzlSM2lVOHEvclRDZ2duZkVrMW5VNUdPdG5DelhRMm1Z?=
 =?utf-8?B?RHowaE9vcnE1YnA5c2N1T3BsM2dQaXp4NUx6a09HbzltRTVQUnlPa01zVjhw?=
 =?utf-8?B?Z01YWjBJV3lkS244ZWg5czRwazQ3bDZlZlFkQT09?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 13:10:55.3990
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 380bffd2-dd38-4bb1-3261-08ddfaa2a157
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE3A.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6559

On Mon, 22 Sep 2025 21:28:20 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.16.9 release.
> There are 149 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 24 Sep 2025 19:23:52 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.16.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.16:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    120 tests:	120 pass, 0 fail

Linux version:	6.16.9-rc1-gfef8d1e3eca6
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
