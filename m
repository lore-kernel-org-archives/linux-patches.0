Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010022.outbound.protection.outlook.com [52.101.56.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51DDA315D35
	for <patches@lists.linux.dev>; Tue, 14 Oct 2025 13:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.22
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760447406; cv=fail; b=oXK+rg4e4ChNl8dTpwZEyC4bnkwTnmmj0ORF/Rv3WlX3UT+ifng6OELQHES49QzPtbEtY4ryT7f/A5sI7may1tXD4U30CNaJFk6ikpFs4SUMFHX3/UrlHahmCv0t0Rxyoy1Kr8UHvjxb0v/7W8tBRzEdMkIT68/wzDhJNYxjKsU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760447406; c=relaxed/simple;
	bh=3E862F+CUurCQRhsYNohOLEMKJaIfQ1ltHJeUSD7Kro=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=mUm2PQjhdUhBirax0beHzC1laOZTOFZ2UiSSiPQictD46vVsGwgOHfcvUzQWXIHCnULb293/X9HRdoUslFPTFSwCgujJ9v+rVPtQEBlP3+j6kFNmf0w1l9CJEIUVtvq2aY2XwAO3Fku7O68Ah2F1O2o+H2zzkytB/KEL2of8nVs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=c4SimvH4; arc=fail smtp.client-ip=52.101.56.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="c4SimvH4"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ncSgaaXNH21UudLqe/l5Npu67JEEAsCfEVpr/FPpE9muFeEJW5gs7tiGqywSA9p3/dbIqm+a1CEb/1Uus9pJBu+ZC6iMw4FgiG4poSPlWDJYYeGkYrOaqKASyd6RJxHdAx6KhmJIi4k7OpBd8nVzD8Otq5TV0X5SgTh1Fhu2pQLm5EVQ51vNYlWpk9WFquANbmry221BoA0foqA98oRqI7MMc/nkvawri2UWAzofeA6SbWK6WmCAbZRwxi5Z8ffFsQCaCT/L5rKpy9EHna9Ae5GHcST09rlJlM5+dQwC8YbzqE4TCLEege8Jqf2aVcyxuw729jK6vmxcJO4xq9IVqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j0hGvxTi8xeqwOFIvFLLb5Q1YKthCtGOzTGkGYRdbhk=;
 b=tJJZs3ofbW6kSgMyG9JS+9787eLn+5+3YdTR0SnpMdz8XM5XvL4Z9oyW/vfD4XER0/xHeNN81cZogZDlcMe91Mhtvw9GHfAHvaXOgBIKqwVujC+zsSvf0dAw1HMgzBK0K25Q9Lsm5PWjdblmJLjTTd/pP1mTmDfzTpUCSPmqNyxu8+9zF7YurLY3P7EoaatPGFTgYDg5Vacycu1hWShd/CrXlZ5Zdnk3IkrpCO/77D31wkpajQKGiUcuG1D5P3mM67jwa3258sdkf8CHdqVKFn9/GSPY2Vf2orHKo9MQ1PNYZWevKFs/wqWMiyu8HmdbnMI4fblQJiVr/hsWNshD6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j0hGvxTi8xeqwOFIvFLLb5Q1YKthCtGOzTGkGYRdbhk=;
 b=c4SimvH4uIdZ6nnxuaMltK7cfyU5e4LyJR+grhwcm5EVaB0vKOkVvTDDidh3Wzt9npm/Wr4lY9YRtgBFL/njbMMTQ6Sqj2z+wOhhXp59CLYvGv5vSTWhM4Tb+Yk+Mt8HTQKfWZC4iAAHZEooXtvySwnDECe6oGDlZRiCBXEkywIzuRJ7bP8FKvg7k8eZnEIqeMAB0wRlB6oGicxZ+yqlRqTKRMjm/FDkbxSDeIqv77L4t8AQVUPNu9JutB+BDF438yo83NCrBh6m4F4BlpUpWJgh90DrzyQWxhgKFnr/9fnBmZ6HEoxvS6xbSpjcYjVaIcCpyK3AA5xLL4t4CEh1Eg==
Received: from BLAPR03CA0038.namprd03.prod.outlook.com (2603:10b6:208:32d::13)
 by CY8PR12MB9035.namprd12.prod.outlook.com (2603:10b6:930:77::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.13; Tue, 14 Oct
 2025 13:09:54 +0000
Received: from BL02EPF0002992C.namprd02.prod.outlook.com
 (2603:10b6:208:32d:cafe::c) by BLAPR03CA0038.outlook.office365.com
 (2603:10b6:208:32d::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9228.10 via Frontend Transport; Tue,
 14 Oct 2025 13:09:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL02EPF0002992C.mail.protection.outlook.com (10.167.249.57) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9228.7 via Frontend Transport; Tue, 14 Oct 2025 13:09:53 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.34; Tue, 14 Oct
 2025 06:09:36 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 14 Oct
 2025 06:09:35 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 14 Oct 2025 06:09:35 -0700
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <rwarsow@gmx.de>,
	<conor@kernel.org>, <hargar@microsoft.com>, <broonie@kernel.org>,
	<achill@achill.org>, <linux-tegra@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 6.12 000/262] 6.12.53-rc1 review
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <832d0502-3729-4b5b-9799-bd88d8b76002@rnnvmail205.nvidia.com>
Date: Tue, 14 Oct 2025 06:09:35 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0002992C:EE_|CY8PR12MB9035:EE_
X-MS-Office365-Filtering-Correlation-Id: db9c78d6-d1af-47bb-366c-08de0b22f764
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dWdvU2ZSL3V0RWo1V1d4NnplcGpMbjFhWGw3Ly8wYTh2Q1QzandpbW8xdXdX?=
 =?utf-8?B?Y1FyL1dONzFKOE5vcE9GWG1WTVltTE1yVmtVZzRjYWRqTW9EcjU4akl0cy9q?=
 =?utf-8?B?a29ZUFQvTlYvMmhpV1JmNHdaUndWd0hGOElMSHovSTd0YXNVYkRDRllzUGts?=
 =?utf-8?B?dlVxR1hRNlFGZkY4M2ZjaW5NaW9RS3dMa1o2dklucThxUTNNOU1Vd2RTNC9N?=
 =?utf-8?B?bEJlVTl6dTFzSHY5S0swS0VvRVlNSFE4eFhsRGhXaGZvVDJ3eVVoSU5aOEdG?=
 =?utf-8?B?Wkg3WVN6aUdmNGxxbGFUYmdzOHV2cU9kRVpUaVRLMXRiNkFmcjB3a0FGZDRV?=
 =?utf-8?B?VDhPYTNTYlVEQlRtM0VaeXhNREFrZXowa29JMm8rR1dPNTFCL05tdnZBTU5v?=
 =?utf-8?B?Tm5uVC9HL2EwdTVyZzBvK2wyRHYxZ3EveHgyWHJ1SklWUkRsZmxZT2I1cFNn?=
 =?utf-8?B?S2hySTd1aU1iNFRBR09lNkZEM2ZMQnpqRWw3TFhJM2tVcm1pK0pPeFRkVzN4?=
 =?utf-8?B?QmUrYXdjZlFhRnN3K2JyaEhkbDZCTExiSkJwNWc5b2MrQndrZ0RXTEIvU0c3?=
 =?utf-8?B?dE1EbUNBMklRSm9Ma1BlYlZlSmJGcHBOQTYraEJBM05CWUNZaVlPYlVmWlpv?=
 =?utf-8?B?ODNmWUtxWjVXbVRiZDg5TDFLNTRheUlzZEMrN1lYbmpIUG1ueUJGd1FBWFpx?=
 =?utf-8?B?M3RGdUw3bUs1V2ZBMHFXdDE5ZHd4bWl5MGVPb1lPTGphbExLa3JiVUZaUVYr?=
 =?utf-8?B?T0ZCOHBlQ1ppNytzYUplS0Qya21UMVpKMkFHajNvdU8zdGkyTUROVDQ4azZ2?=
 =?utf-8?B?L0dmUENIRHhBbVIxZ25YMWZ2VTF2eStSRDhYbFNnRGl1ekxnTWlzMEtqb3hk?=
 =?utf-8?B?U2hqRTZsUnQvMmhnM0g2QVlWZW9tS3FiOGhIRW5yUmpIc0RGQlRoV1QzaDYy?=
 =?utf-8?B?UHpxZENXT3dYa1JuNE1OUitURURuVUZBTGtRZmxiY1kwTFd5am1tV0FseXU3?=
 =?utf-8?B?UEVnc3lkd3FRdzdneHdoaHdSb256ZkR4YXc2RTNTVFg4bHVPWkZIQmtYVXZV?=
 =?utf-8?B?bEpvT1FiTjU3Z1FZazVOVVpqWWtyd21mVU1ZYS9ySUNlZUVaS25FNllMQ2Rt?=
 =?utf-8?B?NllrUzMvdzV4d241NHYyYkZuWnRFQWdZR3Q1Q3NuYjdQWnQ1NENFdW1JMnBY?=
 =?utf-8?B?NHArMHZvTkRINy8zMko4Tk5KSThKV2JTSElpUjJKWnEzNTdxYXk5ZVhLWmpB?=
 =?utf-8?B?TXRFMGNZL1ppQ2tjby8yMFV3RDZwWUpXeXkva05VOXRTbDVkRWFEcHRoWDhW?=
 =?utf-8?B?OGZxUXM0ejJVNTVzczRqbkp6VnpUL1JvM3cwdlFqNk5UYjd0N0RLZXNxRllM?=
 =?utf-8?B?Zi8xNk1wVVlhWHExcHB2QWxLRm5rWHRWNVRVQkFzcG43bGl2MU5VS09sb0My?=
 =?utf-8?B?Wi84aGJPUlVlQ2lwdEl4MnoxNHpkdHFXaTBxL1N1NlBSa2l3cDBtTFdhclJm?=
 =?utf-8?B?MU9SRWVOZ3lyYzR3eGFBYzdVT0k0ZXlUU2JqSjNrUmlIT2xlYm9nZjlMM1kw?=
 =?utf-8?B?TzUycVZydFhidTdlQTc5R1JwQVY0K0VOYkpyL0dlWTM2V2d0UVRmZHRhV0ts?=
 =?utf-8?B?K2tja1JUNXVmWVh5WXpkdWg2NHhWUklLbkx6ZkN0cU93YmZVaXhaNmdCRFhY?=
 =?utf-8?B?NzlVMjFGWHdzTUpON0hqMktkSlJSOXlXNXR4bTM1bGdLeG4xSzd5MGtaNWtW?=
 =?utf-8?B?eWxWdVBsaVkrUFFsQXFTMTVKZjdwRWdkMnp4Y0hrb2dsdDhna0Q4YTkrOSs5?=
 =?utf-8?B?cHFUNzVidGJ4QW5iTnFkOWFrUlJ0UHBoNUdJa1RMMlozaE81ZWhmNXNpa2VM?=
 =?utf-8?B?NWZ4Q0Fma1N4T0o0aTNVcEloc29SVnZHRnVabzVvb08ySkxkWHlzblQ3Y1Zr?=
 =?utf-8?B?RDIzYjUvelhVM1J3cXIzV0NBTzF3c0I0YnpNejZyTk9UYjRicjBoNVZaY1ls?=
 =?utf-8?B?Y0VBRGVVcE05YkNNSmtiWHhTTGVIdXZyVUhXQitvUU1IV2p3OG45ajBzdG9W?=
 =?utf-8?B?TjNTMzZtdFVnT1Q0a0pNOVNrSjUzcVlPT095TWp2azIrVkNMTkliYk1JL3Jh?=
 =?utf-8?Q?kaWY=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2025 13:09:53.8103
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: db9c78d6-d1af-47bb-366c-08de0b22f764
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0002992C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB9035

On Mon, 13 Oct 2025 16:42:22 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.53 release.
> There are 262 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Oct 2025 14:42:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.53-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.12:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    120 tests:	120 pass, 0 fail

Linux version:	6.12.53-rc1-g7e50c0945b4a
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
