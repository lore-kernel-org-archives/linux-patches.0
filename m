Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012061.outbound.protection.outlook.com [40.107.209.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AA22348462
	for <patches@lists.linux.dev>; Tue, 28 Oct 2025 17:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761671052; cv=fail; b=XVVtzc47/zItFDhtqpUXWT3WVmhGOHeS2E5KDTg+LyaT7uhS+DJ9j/Q7rnJK6hUTi97BIRkyCmDegvxr5BHfcRsFloV+g1BfNSQsiLcVs/OkXzLZmWyrX5QJmSP0pnQNSEx/T7Q8HgjyuZW9kOb0Nnwd7LpkzxueXFhIBUieIOg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761671052; c=relaxed/simple;
	bh=KbzOD0eChZQuxRYmECXVZfKwWRpKnUhYTPf0RuGdR5A=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=ga57LbzEfBqCYegOOsz22NdjSF2ey0F9iXuHcPsLzxI/Vqh/MkbEY/od3seafhbOYEwa3xePKegqzjmJADaFQn/FFCiCYbLpJG0KJqWUAhXFPH0ShMJhJI/BySkLiDyJhYZT1UX5GJzx9z9pyvBGc23vH0ROklpqDa7wUjRtNYg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=TTEhoMvl; arc=fail smtp.client-ip=40.107.209.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="TTEhoMvl"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t+/W0UdbKJDhYtsZCbAklDQgVrOOjJMqwEnBbcgZ6SFX7nOi/ehaEsHwdoLuA7n1YgklZVeXFiuqBRuSR4Axjf1NBoskNKsmMcVYjENFam+OBvzitCnT5PL2QpDL1c+rbdSSYqKXAkTRclpxARFn8ABOC8qWtmTfN0tXtFIaGlW1gbq3xebqFgeruVTlWu0uX8EnomWLpl2oki9yc/SC0SFpP2nw2jqCZXVBBElRtisBiHlg03o4pG8cObUWy1dVAq+ylKMPyl14XRRKafqBdpQ6oY6VVceW1F6EUyBlE5ktZ68DtCCpCRj8ENC13RjfgfVwQdh3TloI7H4x3rzMBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BbUD/a7Kz4J74qTgOGRzdXRKWRfQR1m+PhWTudHQaLc=;
 b=voqFqGnrj+COSyKk62nfzivM7NmVBLaxpY1wmOhS+9klqIYxtMfrWwBTFuNzt+LP8j0hkjce8+8P3kaCdITZzk9I8QSZ82GBD+h6jrVnFm9HTlh3wWyjjK9Y/nmjHuuH82a4gb8usrWtn82GfzyRYHDXANGPJ7xa3CaPs3qvzqzGYY41QIYAJPrUPkm6JJoN+L3EiMR3lzpauNcPk0fx8YmR2kE59pnwnhghWVu5QBmIEvNSXzDi+Uo8RPbWzyXrWrRbSAMjoIK2RBciIaA/PNa6iigR5rwet/c9YAvuyK+jLtKGDl487VRdpNpfSTz+y+9HRrJrdRKLebxCaCuAUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BbUD/a7Kz4J74qTgOGRzdXRKWRfQR1m+PhWTudHQaLc=;
 b=TTEhoMvlZfeRjHnBkJIgOJmMrRpKPFoy5TsHOIC1CvYLBDSK3mbdAiURJ7HmrIgT7d/h/Pqdz1TOZmi6pZFyfphF21FwPpCoZ3Y/IGqdB8pl1RHCjZkXLt4IGwrQQi3KjOnmbuOtkD4gFmo0uVqdWJ2mWawWwhc+2b6Q/8fDMhby5CLl0wgRMMySXn9fUCWVjniNXKYe486eWbZIwOOto/gBjUQ8RSkeerb2a4jtvsDp7bwPDiTw7EnorPIHHF9XA5bTs7lyDcIQuz4wbNejdUH+zPa/VcjGDeIkAKyXcGsrUbbMNcAK+MiHnCoykgz4v69jujGUFyzHPAZspq5Low==
Received: from DM6PR06CA0101.namprd06.prod.outlook.com (2603:10b6:5:336::34)
 by DM4PR12MB7574.namprd12.prod.outlook.com (2603:10b6:8:10e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.19; Tue, 28 Oct
 2025 17:04:03 +0000
Received: from CH3PEPF00000018.namprd21.prod.outlook.com
 (2603:10b6:5:336:cafe::6) by DM6PR06CA0101.outlook.office365.com
 (2603:10b6:5:336::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9253.19 via Frontend Transport; Tue,
 28 Oct 2025 17:04:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH3PEPF00000018.mail.protection.outlook.com (10.167.244.123) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9298.0 via Frontend Transport; Tue, 28 Oct 2025 17:04:00 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.34; Tue, 28 Oct
 2025 10:03:38 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 28 Oct
 2025 10:03:37 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 28 Oct 2025 10:03:36 -0700
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <rwarsow@gmx.de>,
	<conor@kernel.org>, <hargar@microsoft.com>, <broonie@kernel.org>,
	<achill@achill.org>, <sr@sladewatkins.com>, <linux-tegra@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH 5.10 000/325] 5.10.246-rc2 review
In-Reply-To: <20251028092846.265406861@linuxfoundation.org>
References: <20251028092846.265406861@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <bd849f35-6d75-4a88-8dd7-206302736ae8@rnnvmail203.nvidia.com>
Date: Tue, 28 Oct 2025 10:03:36 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PEPF00000018:EE_|DM4PR12MB7574:EE_
X-MS-Office365-Filtering-Correlation-Id: 56bbe961-5cf6-495a-8865-08de1643fdc7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RHNwRGl2ZnYvZHdRdkpxYU9LQngrYTlQUHV5THk1U2JKVDI1WCtsWExOSWMv?=
 =?utf-8?B?RDNMZ2VvUmdiQ3V5RC9jdDRZM3RVelRUNGxlWFhNZ1pkVkFKL1lJY25BOFAx?=
 =?utf-8?B?TkpmSlZaRE9XendlbXFaM1RyZEN4Vm9Xd0JObU5taHVCZ0JEeWxmRWhCL1pB?=
 =?utf-8?B?WVo2RnhjaVpNZ1FaQnc4R1ZXYWp5K05BU2NlUUlQL1RGbm9lTjRrNTJJMTNK?=
 =?utf-8?B?L00vZE1uSlNGRktheWpqNmI4MlFqUldkWDlMM0FKQW9yQjBJN0gwVG1maTRC?=
 =?utf-8?B?dklhNGhYL3d1bll6VWJEL2tjamlva0F4OEtWVXlmSWNIZDIzaDVpMEJpYXNp?=
 =?utf-8?B?ZStwWWxTbkZJbmxOb0tNRENKd2ZzR3p0OFdwWHdlME1Bc1BUSWFOZktPMzVX?=
 =?utf-8?B?dyt2UGp4UzRpeUJIdjhTRVI0NWU1S2t2a2l4R0NuQ1RZWGp5dHpObkpDSVY5?=
 =?utf-8?B?S21DMVpURzdoWVI3VGpHYXBLNDVvWXhTaXZFY0pMTExQb1RoRC9ITFB3Vm5t?=
 =?utf-8?B?WlR1MGtHeXRlVUxqaGFxTmNPTTRsV05HVkJ6cjNrVElBR3FJaUhqaDRkdmlj?=
 =?utf-8?B?SW5JTU1zRjZyRFdxbENsVUFPNE0zSXRpZjN3N0xieVlxNzRsZjd3bFR6anpp?=
 =?utf-8?B?aWNiRFd6NWttNUtsNkFJZTcveE12bjJQd01YdTV6bHBGY1k5a2xKaWhsSCtX?=
 =?utf-8?B?S0dHNW0wN2gvRWYwUllDbjJXY0gvNjlxR0w0VnRPZVdySEV1OHJYTllaTVp0?=
 =?utf-8?B?NTFCbjB5ZUJVOUs2em8vTlVMV01BNlZWQUxuYXRJV2pzejhGZXNJeEN5Z0Rx?=
 =?utf-8?B?U2lFVGpsVmFjaVA0Ym12Wm9ZNWlIaklOdUx5dHdWVWprL2hIV1BhR3k3dTZQ?=
 =?utf-8?B?NkRhSEYxeW1Na2xQR3QyS0x2RGEzWWVVSFhzdW1ZUmNJMWx5cVVLN01JTi9r?=
 =?utf-8?B?d2c4bUY2U3hhMkpDOVJjMGZIK1pXSEVHK3ZjZklUdUpSTDQveE4rKzdOYkZt?=
 =?utf-8?B?VWNHc3Zja01COVRxWXo0V1NMZ2VHTFZOcERKNyt2czJqZmJJWW5memV1eFBp?=
 =?utf-8?B?a3U2akRMUFljTkdEWXhOeGVvd0hxV1B3R3pnUlpiVldvUUZ2dWJRKy9GcldS?=
 =?utf-8?B?RWR3Q3B0bzNUQlg3WitDS1ZzZ21nZEtpMU50Y3VSeHk4WGFmRXhTTFRUK1Iy?=
 =?utf-8?B?bEJtS1ZpTTFYTURCMFVzbmRKbDFwQnBnUGhIUFkzNkI4SnNwR2xsSDhrdzNy?=
 =?utf-8?B?bXVEYzVZdVM0NzduamdlU1c3OUtNMFlva2h3KzVLY0FCaWFSdnNIRFRiRG91?=
 =?utf-8?B?eG5UclFIYTdVVkpvbjJmL0pBS1NuUU80blhOY1J6Y1MyZzRyZ2xwcEZyeWdB?=
 =?utf-8?B?UDcybzNyZTQxWmEvYld0WTZYYkRHR1NvZ2F1M3BkN2l3allyR0Z5QXBMeFY0?=
 =?utf-8?B?Y1BLVXI3cDBVMnMwTjFWamJiUFdlcXBwMnVTdUtkUGxlOHpnNmRFV2tEWG11?=
 =?utf-8?B?c1VKeUlNVnZvZFYrOUVaZGlueFMrQy9YVWlscjBSNmdYZDZGOHRRMjdPK3ZG?=
 =?utf-8?B?c2FCOVliRVoyNnVQS0FtNjBaWUY0UUYrOFRzOURzZlpXN2NybTVHRlFtdmhi?=
 =?utf-8?B?NHdoVW1SWmwrUFR5bXNQOFJ3WXlWWHNZUyt2cHVCT3c4THhiWGxyQTdkVTdP?=
 =?utf-8?B?enkzazJibHVBUlgyMUtmcVVwSi9LS0V2MENKSUNRcTh1TlcrOXRKM1hoV2NO?=
 =?utf-8?B?N3NVRU5acTlETTdEbUhmcXVBNTdvMG41ZmNIbjNBdU4yZXJGRS9XQm9GYnAz?=
 =?utf-8?B?NUJWeElGY1hZYStQYlNPUUkrSFl1ZnNIVHV5NVYwTlAwUnJwU3hqMkxhZ3Nn?=
 =?utf-8?B?T0RVWFhFc2N3RUd6QWN3ejU0K1N1ejdtVWZjZlBsMWpkZ0VyVDJDNWZNOGd5?=
 =?utf-8?B?UXhETXpGaWF3K2FzQndNRWlYTmd1S25SRzVab1Q0a0NTSjdqSndkTnhhaEp0?=
 =?utf-8?B?VnRkaXN4elRXSVBvbGdpa1R0VEtBVUxxZHl2SDJsdkdqZUxlbXNWdUNzUUNa?=
 =?utf-8?B?RjBzMjYzdk1xbGxwLzlnd3ZONElldXoyaTlnQlN4aW9QWnkwT3U5MEJWMHY1?=
 =?utf-8?Q?XiDo=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2025 17:04:00.7950
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 56bbe961-5cf6-495a-8865-08de1643fdc7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00000018.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7574

On Tue, 28 Oct 2025 10:29:21 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.246 release.
> There are 325 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 30 Oct 2025 09:28:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.246-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.10:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    67 tests:	67 pass, 0 fail

Linux version:	5.10.246-rc2-g98417fb6195f
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
