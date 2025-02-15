Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2059.outbound.protection.outlook.com [40.107.100.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10A581E5B74
	for <patches@lists.linux.dev>; Sat, 15 Feb 2025 16:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739636546; cv=fail; b=WWS37IxyvFQmzfA4bvThwyPxdLH0zbtln0qyBvN/75dcRq47tzrLMayjgcNpKx6mlCpYKsCQ7+KHVTRQac4rN/qw/NK/D4RH7yicpb4MKF/KP3IGpnsQT71/O7CFLkO838UwjMI4zLx49WmuQ+j5fwmbqG4JZBT9ZD+GUdUeFVw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739636546; c=relaxed/simple;
	bh=y4Hz+GiYDvTAq8x5fEancnXDN5M8XR4shcwlYMDurSE=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=m7BEXnbjiNTOdJtamJNmcuDCwgnf0Vo/GkYosz9TBeEaNIKfd//zvc4s8By6uEorq4YvD5bZblfHWLJBHZUr9JYoEphNm6HqutWURKzPODpEsx85bgm7gq+09Oxg3EttRcaONGN8/cpQqRqiOfpcxuJQFGIXL03DtFbx6Z83oUg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WD+QQwkT; arc=fail smtp.client-ip=40.107.100.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WD+QQwkT"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MCnSVaT3DX/sU1fSlaT78dj1if3t461jM8qQQDmMZgbpuViBF6IuyBvS7AWAgn8RyYXyYPrH83eiRQx7XUdnmFbDDfBGf+NS83Wid1qxLSOV0gS8P4loOotCwuo+YJ8NTJ0Zi+MnWxOTeD3+Oful6zbB3YGNDVR5CdDxqAfXfiXjZwHtKRVg8EC6VYfRG1uV7jXMey5IALukiAFvs4MX3tRBpMk8ZIEh4pU0Pqyye384cn21MG2Ry+X3IG2vZbqzDz2JDErlKIDdn28B3WPuPau7Q1bh2F1PeLAJItZrzsnEKI22Q29klfIF0HkmbMT1LYruFoVdx14KlGQEfQOV+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GBsvKiWvoFFEIDSdn8xPxW/IgC2ZcpFvh0hEIBkwVJA=;
 b=glk4lT3suW4Ac8KSFzzxulmuEyiyciVJJ6g/RgExC1XEdBmxlTRRzjlIKsfzCvJFHOrTqXxabMx0SpAsqdtYZJEyrYhi/IHJIsaDQpQ69prnDjtU4EMTRUnYYtTsvZF01v7ZK2HRcHvbs4WE6jltdg1AeYQPbNJJ43e7mt5aG/cmhLDCCGFEPgMPffC+/xtiXRScSek0VVcdO8QmPWAEYFqRpgHwAlCWBYL7quEz0yVr5YbbXzlA3Du5eYTs27g9W4Gl5+b57lu9kB6h4fTpQ1MeFZAJXvUjMbXiJv1oZoh2HewP1b6FXPBGVqHHmUhPty2gsEvUWxWLE0lB4Fcqew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GBsvKiWvoFFEIDSdn8xPxW/IgC2ZcpFvh0hEIBkwVJA=;
 b=WD+QQwkTshj0UR0gVkElTtq8ljSbHv2hwexAsVOMZAPIUVR9ovBGno+NxTma/KzKRucYfe1YHhXuGLbMvjVq0gLBYMVwoS3hWg3aC3iayiHxGEBZZx8ImBvbjhKpxfZDlxan+q5bZ1g4hL1EmwlNuJf29scfs6mP1r0ObNQgThsoGLivz/QK8SE1kr5GZOvglcruFCnFmCnEuPROdQEmDjSIUHC/uEI7nxHCKJ6Y4I0UQ2ngZ177b73ui9Wld6M2KPq2rtoM1PbxmQzpo/MQgjgidryOVFza+rwKDDxAuKa4CeIZiDeka+k5bee9ZI62Q54APZ/9n7DqjWMlsO/4tA==
Received: from MN2PR07CA0006.namprd07.prod.outlook.com (2603:10b6:208:1a0::16)
 by DM4PR12MB6544.namprd12.prod.outlook.com (2603:10b6:8:8d::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8445.13; Sat, 15 Feb 2025 16:22:20 +0000
Received: from BL02EPF0001A104.namprd05.prod.outlook.com
 (2603:10b6:208:1a0:cafe::69) by MN2PR07CA0006.outlook.office365.com
 (2603:10b6:208:1a0::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8445.19 via Frontend Transport; Sat,
 15 Feb 2025 16:22:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL02EPF0001A104.mail.protection.outlook.com (10.167.241.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8466.11 via Frontend Transport; Sat, 15 Feb 2025 16:22:19 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sat, 15 Feb
 2025 08:22:11 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Sat, 15 Feb
 2025 08:22:11 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Sat, 15 Feb 2025 08:22:11 -0800
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
	<rwarsow@gmx.de>, <conor@kernel.org>, <hargar@microsoft.com>,
	<broonie@kernel.org>, <linux-tegra@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 6.13 000/442] 6.13.3-rc3 review
In-Reply-To: <20250215075925.888236411@linuxfoundation.org>
References: <20250215075925.888236411@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <89b2547b-f351-4029-a5cf-b54690996b6c@rnnvmail204.nvidia.com>
Date: Sat, 15 Feb 2025 08:22:11 -0800
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A104:EE_|DM4PR12MB6544:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c8129cd-3410-4190-96f1-08dd4ddceb8b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|7416014|376014|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aldXMG5uWHR6TjExSWxIZnU1QU9FRy9lY1QvZFJJbDJvZ3NJUGlWSXNjRlJ0?=
 =?utf-8?B?aXlOenp3TFM1eU8wdVpWZzhOZWcrYXpzQU1IS1R1aDM5V3hIZWdkL1NLdExu?=
 =?utf-8?B?VUFCZVRDSWdGc090aWp6b1ZVZXh0aGorZE1jSjU3L01MTkxJQVZUUTVqdFV6?=
 =?utf-8?B?WjV0YjNNQko2NmRiYUdlbWxmNVBvZ05wOUx0Mk9FMURVWjk1MUxUUkhoYjdS?=
 =?utf-8?B?Sy8yMk1NQUdRZXVHMi9rMTdialRDbUgvYXJzVHM3K3hyMVVTeTFsZ3pFc1NN?=
 =?utf-8?B?VFV6TzBaT3kvcGhNR1RQcUduTXdRTEhNVWlKYkJFL0ZlUzNuWkloU0luUVRT?=
 =?utf-8?B?aHhaOXJ6SjArYlNPNXNkVlZYd0U5RnFOcDRMcmJMZGNUeHQxZjFnL2FXeHAy?=
 =?utf-8?B?WDNNOTFneDY4Z2IyM2lzcmJreFRGQXhlVkVmVGdaTTd0TWFmZ3JxN3dBUlgv?=
 =?utf-8?B?Q09Tc3ozeHNyZjZWenlnVU9kVFk3cGtGMzFtZ1dnQWdkMzY2TkNyMGhCaWxO?=
 =?utf-8?B?cUl0ZzFPUUlRckgzTXBjaTJGc0tzT2RWTjdwSTNvSUlsWVZuNm0rcXFkNFp4?=
 =?utf-8?B?czZsc1hjMmxjdzB6REc1L3VkL0dSdFNtcG5JLzhQOGd3ZDY2SitzMm1qU2hD?=
 =?utf-8?B?RGNmNmU1NHFrS1lMVmh0WVhvMTV3SDI0TUppWFdwczU4RDZKUzZuVlBkV0ky?=
 =?utf-8?B?Vi9iMEZZMTU0UGJ5RVRmd0V0MDBMYkcvS21aR1llcVJ4dGl4QnNFZktKeFBH?=
 =?utf-8?B?ajdVc3ZHY0V1d0srajVDQXlSSmcrN2RHa0JVelExaHhISEVyZXRxZW91T0VW?=
 =?utf-8?B?MFFuT3BGL1dyQVdNWmRxRmJBcnExaDNGQnpJYVhoNThzOVp4Q0dsVzFNVU9E?=
 =?utf-8?B?VWQ2ZExJSVZaZnVZaHdSL3RDY0pXS0xxLzcrazJyQnU0RmorZnVERGxyR1pK?=
 =?utf-8?B?dFlQbEoreUZLbXpsc21qc1AxckZpS0pGdjFCc0N6QWNNZk9PWVZXSnd6Qi9D?=
 =?utf-8?B?L09LL0V4Q2FUclFKOGxtRkZ0UHQ2UmlQRzA3RTBER25ld0ppQkRucTFBY3py?=
 =?utf-8?B?UWFEVzZwT2hTNkxWdHlVdVF5NWE5VkNoeXBvVTRqdmdqWVZ1V3lDWStranlO?=
 =?utf-8?B?cTY5b294WS80TzhrVmZ5NW1DUEYwUkJ3TnF5ZGtMeTZlaXlkRklWZTJaK0FO?=
 =?utf-8?B?VjFRRmVUZk1wMmNMREh0MDlOaGVKbDlNa1BkeG10NzdENUNiQWo1V1dTMlpq?=
 =?utf-8?B?L3ZXbHBzSE0zOExRS3Y3eXJ0UURxSUx6T0ZUZk5HOGdMU0hHV05FbE1Kd2VH?=
 =?utf-8?B?clpDNXNPNUdHdDhVdHRtU2NUaHlXeUVFOExmQituQVd3QzE4WUk0UjVzWW1U?=
 =?utf-8?B?U2ZoWHBsNEJkcVJWK1FtU3ZyN3M5OUJqaExYZ3pFNVJXNXZmeURCRnAzYmNJ?=
 =?utf-8?B?SkpSUEFRR0N3bnpvVDdGV1k1azlwMVQ5N1FKdVZBNFVaeEh6cy9kMk9lSkZL?=
 =?utf-8?B?ZXlnVDFqdWF0Z0tQNXZXckE0MTZFb091RkJpNU5WUEowL1hoWHVLMnIwbWZB?=
 =?utf-8?B?a2doREx1KzhBTGluN0h0Q2NJTXNwSmkrVUs2TDF5RE8xb1ZHRTVpRFdtTWEv?=
 =?utf-8?B?RUtQdFVQR1NFMTA4amgzM0srUG9JOXg5dHZDSllqUFlJMCtCV0RTRE1wZUdW?=
 =?utf-8?B?TXNvcTRCcmEveXhPVUhvNTNlRjllWGNaL0NOSVJJcFhQY2lKNjBGbXMwQ1VT?=
 =?utf-8?B?Qi90aGhkMkM1YUQ3NEs2WDdYUUNGVys0WGlrNisvR1VKVVQySlVObkJwb2I4?=
 =?utf-8?B?aVFBM0dyekhoalVZTjJxcjFmYXlYRVBaK0NYUDF0RlVRdW54QVZFTE1Nd0pJ?=
 =?utf-8?B?bTF5UlEyLzBxcDN4RmpZYjZmenlyUzM1WEtxNGovOVlxQlczU0pJa051b1Rz?=
 =?utf-8?B?cUpNNHBaU0ZJdmNnZGhnL2VFcHpQRFpDZ0I0SGV4dkE2Zjl6RVI2MXFyR2Ev?=
 =?utf-8?Q?f1airwR/9RENg5D2XHOIZttjkeyMTM=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(7416014)(376014)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2025 16:22:19.5010
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c8129cd-3410-4190-96f1-08dd4ddceb8b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A104.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6544

On Sat, 15 Feb 2025 09:00:06 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.3 release.
> There are 442 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 17 Feb 2025 07:57:54 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.3-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.13.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.13:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.13.3-rc3-gf10c3f62c5fd
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
