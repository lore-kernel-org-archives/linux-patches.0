Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2082.outbound.protection.outlook.com [40.107.223.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3E9FEC7
	for <patches@lists.linux.dev>; Fri, 24 May 2024 15:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716564026; cv=fail; b=dge1YA20Q2q3NMaGwSsALw61AOv1VSGvfayBuPPOgc6Q8WcfY1wtrE9Tvnu+e+5RhLLN0Xq4hgTxIXTgTs4YPDGjiGaJbd3eOEifmFZBAQMBXSFWJnEfJeOv7m6P71TK1xnrGIRXpkHNzVu5+K82IIcBGauzflyFlO7MpUCdHLA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716564026; c=relaxed/simple;
	bh=E3Kur8JZawdJN8WWoKDdUyPtKPBJ9XluWJuUp4Krjas=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=MwfPWoQxM+lSTL3CDrNkyeRj+FnFRB0V7R7FII4/G1FDwc9aFW+hmosRqiNvQxOEgKiN+J3RQszjfOoNtT9pV1OV//stmZjhsEVf5VONpgzzP1U2bUbApXel22OVWmeedYER6y5LhlCSOMPyuPImjxR4SaEPdvZqwzYKHXiFsIo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=U5PZZnbn; arc=fail smtp.client-ip=40.107.223.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="U5PZZnbn"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D8GG+6C764ckBf18jA9+mKGKMM5TkmpA4z1P4jjDHoH4cCmCpuo6XQfvIHifACZg/7jntlIXFFjWgztL0OCSS/OWQcHubRkLbNf9SUTjoN3gmfpPbyfzEvOSsJfecRG4O1a4fvcds1GzJbAUDiHAhFB0BF+A+hcLyy4oIHdGo1NHNWAFIay7hxajh+Yw9At5cGeQoVwZVSDkuhKluqwkJBUOCyPNG9qnKtgTa/m2CqvtN6zwRWFBLt2QuLvhVRdta9KTlZtPWN3zRIHFoXSNcqO7Zpq2u5+cP/QrSThjr3edYNUHBYPcXJdAncono5LozHKW8GCA2u/zkK7ypcJtMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ba+nSHPFsOhBZrIpJS8BrVyaNAx0YLtOaJRW2WB5Sdc=;
 b=MtnlT6R9k8ZSNKRSA154m/b81o3YPxWiRLqOM+ebn+XuK/aqKOvzTiT4P2iEGIMLTDvg2dCYWnhZRA/L4pwJuVa1V764n2/WnS8AvcmCKQL7YZgEEisU3OFsHBq+jc5sbBL6Z1GHA7tPLug3AdmFBJagnx+bnJMeO1hZo827FqvdcMyrX+rOpIo59ZSaOjAgW7+cWB5e75/ieUMd/prgbTp2l0+NEUpJSrzu2444du3mKNHuh5csqIg+kPpWIHAwgNDk31CRCMRMOHgDa8CLTEFBnr8mhSbvUir+JS3ezsFrbUIowLCVsGYZSzNLMsT1FSiAmfl34zPW0K3klr71/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ba+nSHPFsOhBZrIpJS8BrVyaNAx0YLtOaJRW2WB5Sdc=;
 b=U5PZZnbnF0XwtlmDNVMeY1bV7jpD8IatDvXEvLJbXjrDAYocNvfxHXR9Odmnv0YAR5bQiewCXp6fwnNcAazzN7L3/d5q/CO4RXBXE4L5Z7PrP7RpTIy0PjTEvp8GhHH/lhP6Dy8gh+/3VElcsJEu3Htd4MmzYK0o66y46eQS/GtkkH2XctqttMlzwBEi7xIRIEY7d682BlrVXCuLJqIu435pfrepblf/fdQDAUD1QA1STNKXy4E3QgYUIXT9NfB4PzVnTQKTYAicijOlWVx8RDVZTxlIn2lWNhiS23wifzkviipE1Qwtkh3IZoxSLoYqoOaXTDffvzQT4G82vUE2UA==
Received: from SA1P222CA0144.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:3c2::22)
 by MW4PR12MB6999.namprd12.prod.outlook.com (2603:10b6:303:20a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.27; Fri, 24 May
 2024 15:20:21 +0000
Received: from SN1PEPF0002636E.namprd02.prod.outlook.com
 (2603:10b6:806:3c2:cafe::d0) by SA1P222CA0144.outlook.office365.com
 (2603:10b6:806:3c2::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.20 via Frontend
 Transport; Fri, 24 May 2024 15:20:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SN1PEPF0002636E.mail.protection.outlook.com (10.167.241.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7611.14 via Frontend Transport; Fri, 24 May 2024 15:20:21 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 24 May
 2024 08:20:14 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Fri, 24 May 2024 08:20:14 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Fri, 24 May 2024 08:20:14 -0700
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
	<rwarsow@gmx.de>, <conor@kernel.org>, <allen.lkml@gmail.com>,
	<broonie@kernel.org>, <linux-tegra@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 6.1 00/45] 6.1.92-rc1 review
In-Reply-To: <20240523130332.496202557@linuxfoundation.org>
References: <20240523130332.496202557@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <2777b42d-91dd-48ce-9968-1df7117736d9@drhqmail201.nvidia.com>
Date: Fri, 24 May 2024 08:20:14 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002636E:EE_|MW4PR12MB6999:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d1cccf4-985d-49be-db8e-08dc7c0506dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|1800799015|7416005|36860700004|376005|82310400017;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TmN1VWl4Yjg4RzBEa3EwY1RYeGppL1RaTjV0eVN5YXZPY0R3UTN1dE5HWWRE?=
 =?utf-8?B?YzlDbnJ4bGdqM0JjOGpHUG9rdk9vVC9NclJnTGliNnFQZjVmczQwaVVCMWFv?=
 =?utf-8?B?QUlkb25PelRUaW1wb3Y0TTc3MllmcVc0a2VkNWxQS3E5UE5zN2gzVEVjbUx3?=
 =?utf-8?B?TTN5djdpK2J6SUJKZ1JYTFhScyswUXlLcy9VRlhYTHNpb25pUWpId3MrMHFZ?=
 =?utf-8?B?NTR4d1FXV0lDN0dFN2F6TWRVQU9Kbm9TdXJjdUt5Z25QNFU3TG9abHdYTnln?=
 =?utf-8?B?WFlUU2FPZEJQNXYwdU9zc2s1VnpDRHIrTU12TENIcStHNTdNL3AwdTIxcHJG?=
 =?utf-8?B?cWFmZWk5STIxOW5FTmZycFk0M1BJS0JNVGpXN3ZlTlpJenRORE80Ry9IRVM1?=
 =?utf-8?B?QytYMEVBK2wvelNSSzV2WU9Dek1QeDBuOExuK3I0aVVLNnJZNldxaG81a05x?=
 =?utf-8?B?TkppaDNyTWFpTVdLSTgwc1c2OU9VQU8xL2N4ZEYxNVd0YmY2UTBsc1g0bGdY?=
 =?utf-8?B?U2I4L3FRUEgvMUN3dUN1YjlsNFBHNDJlRGphL1RhbFBDcmJ4ZWcwTHBvL2Zl?=
 =?utf-8?B?RG1hcXVQdHd2WmJnUjkxSkNuQmhha2VSQ3F4ZEhYbTZ3WE5lTG5wYWdxYkhr?=
 =?utf-8?B?cDJuc0owQUtXdkpqTlU4Wmx4S1ZLYU1BbkpSaCtkS2hGRTExaDAvdDNyQUxG?=
 =?utf-8?B?YUlIUHBJeE5zZklVdWQrb2UvZkZkelRDM0I1dytobjJ3TS9QNFRNVFRKOUpJ?=
 =?utf-8?B?bG9XT2ZBeXFsTzgzWjhOVlZDYktUYmYvajhPeG5sT1RqVG9EWFUxUFN1YjdN?=
 =?utf-8?B?aGI0Nkw3VVZ5K2VRN2NkNmhOYUpMZ2RZVlo0TG5WRDBMbnF6bG51WEIxYkFC?=
 =?utf-8?B?WkVvdS9VNTgxWmptQldDQnJwSmgzb09ZME14a2ozclJPVWhBTHBySFVlYVVG?=
 =?utf-8?B?dFZGdnVJb1ZvT1l3Z0tlVHlUSzA1TUVsL2VyMFhJN3hCWEVmcEc5TW1zODlq?=
 =?utf-8?B?bmZ0dDhIK0dhb1JoSElLMitkTVQ1d0dpN3RtMnNmYmlPUG13aStnR2RKVXB4?=
 =?utf-8?B?TlFoL1VjWkluRDJHTTZuVDVNcHdZR2d6R0wydFVIOFEvVklSSFR5OVg1LzZN?=
 =?utf-8?B?QVVZRTVsSXV1c1ZUd1kyblh2Vk1tSTVqbmxGTnk5NDBPc0NydC9uZThWM1VF?=
 =?utf-8?B?TVJTdFhoMFF1WFdYejF6Wjl3QmJvOFRFY1hvaUExeEY1ckdNa1BoOHlxVmdP?=
 =?utf-8?B?UFJkbUY2Ymp3RlErZDQ3MHIwbVNjRXRvLzVJNklNL2NPcFBEcHI4Y0ZDQmVN?=
 =?utf-8?B?Zjd5VzlSVzB1RDErb0tWTTBwdjVDQ2dZOERmS3MrcmcyNDExcU5xSDkrMEVn?=
 =?utf-8?B?aGRoWEdGWjBQcUxpR20ya2Y5YkxvWURITFBLRmR4OVBSQWtiTk05Umgzc0RX?=
 =?utf-8?B?NTZpMGpOUmduVENYN2YvOUM5d0hYUWxkQ1JSSmIvYVVqNjh0UEFkZVorRWlw?=
 =?utf-8?B?b25XNHl5a1dZejdxeE14ZG8xYUlmeThuSFhPNi82bkNLQWtFZ3E5eWtnVk10?=
 =?utf-8?B?OHdPMjJ2WkExUHV5dmJxU3YrV0libHJrTlY3djl4SnpWL2tReVEwTlE0eTA3?=
 =?utf-8?B?NHRPKzE0SWlNTTlHR0gzNWR1UmhOUkZUMlQ1UHByZnNqS3dRa2QwS3dwMmdq?=
 =?utf-8?B?dE9RQUREL3ByTCtWdmljOE1MbmZ5T1d3Z1k3bnN2WDd3N2x0SnYrSVEyNjV1?=
 =?utf-8?B?KzR3RndlWCtWWmM2a2xuc3dVV3k4dEZZdkY1N2JCM2tXUnZSM2lnczVDNWc4?=
 =?utf-8?B?WlV5a2VUQ0JMU1AzZGw3aEtibDdlMk1mZjJUcXhRdWlJZk5KTmsrbWtKWjJk?=
 =?utf-8?Q?nx0l4vxY6/dcW?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(36860700004)(376005)(82310400017);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2024 15:20:21.0245
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d1cccf4-985d-49be-db8e-08dc7c0506dd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002636E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6999

On Thu, 23 May 2024 15:12:51 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.92 release.
> There are 45 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 May 2024 13:03:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.92-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.1:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.1.92-rc1-g662b26bd104f
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
