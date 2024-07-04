Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2072.outbound.protection.outlook.com [40.107.220.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD3101ABC25
	for <patches@lists.linux.dev>; Thu,  4 Jul 2024 14:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720102289; cv=fail; b=WMuZ8LYC/ynRykkjpuPZpco/Z8yWWfUqYyZ2NR4B3L3cvujeik4ENNhrJ3PYUxAk642aKuYrIvuc7xKZfypv5bxyFhVm1E9z+FS1xyeMxOid/MwM12WPD8hpLU5Pn1pWfIoC67Ztrmcu3luHOVdzwUmj6YLalX/+wMxgPPt0b8g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720102289; c=relaxed/simple;
	bh=7U4rxJiKq7qqu2qCYbEEhmq4BEIU4RhLZ3k63m/lLG4=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=lLHDmhIgYYaZRn8VIZV1oA1YGOBTs12wxuwKDGqMBvZCrN5yM+l7L5sdGaYvjYNfnxVbnDevWKzF/boycDnmU3APBsshHdDKwMZk1RL//2/5MNC/IcnEjF3uQiVhF46+f3HwBBtoHWupm3HJnEyabcghvnaEV/Ex53pdjP5ehNA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=W/BKqZ57; arc=fail smtp.client-ip=40.107.220.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="W/BKqZ57"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gc168jydrARTVQ4k+L9vGI9XALuWIyEfxwAxgsDpFSK1PyUc80g4mkkcMZ2iWqQd/Vn+lBmmzIzNIXB8ZMxISUK3fM/TEwxW4AeNtjVCKt+RwIMhGE32kMMFpbWp9+CjueTE8mBuVfZWUFw79/VEJYHPR/4yl/FfmqBr4RBRhOo6kIiFuUv6TSlgmKLdyipbY73HM/lfj7zfhmlKfHHPIAmnza1RmaLzqzFDdEGPGJOuh7AkAEQlzixy1n2d+94yMSmJvr3Qu5aBuJUD1mtqGG1ieiQYWzWtZ7uOUztlpqJ9VYVvybVZoPfNtgYps8w6MFGZKC/FoylqEfteZZEv1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zzgam0ZqLdd2IYu3tFgqnhKYlHEBZRkX7j6fl5frNpA=;
 b=M48TGanfM6314BjO8NoZrLxvQE2qMadTsu8HOjpES6MiOoXMS42BQizjVs9SOS+NuDgMfWCe5a0ibQGn+0Yo3oALpLYqNW0I1Z69rz0FyTCUBcyvdoyzHPsEPSnWfmBM9Bfq/yGvHjk1dh7b275snp46vwdatnnUoaaohSdSccaago11iYoM3mGD6mzJa/vlhOwjisu8swpW1ugYkC+Y6qLXgmlvHNwnMvBEWQdoBYdptefqeyrrA9UFeZBnbd+1PjmxGUunUzStbNACoLJMM3h/laetm0unmHMFXwIwl+GVGubMqJbvs9diUU3x/gaQ6tsoytGjUGrZvE39plbO/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zzgam0ZqLdd2IYu3tFgqnhKYlHEBZRkX7j6fl5frNpA=;
 b=W/BKqZ577x2No5JpwB9wycAklu5LJ4hkYE03C8aKAZNU+d8fV0ltOYRY5Tn8FIQJNvLinOZMW9snr13LPww0FfM4+Pt8tUK3a/S5RCi/1zZOFiDgz8w5bxGF4LmcInopnTnfzEHvsXPxp8cQ5u6kRHhuTCze65ps9JjYn1O2tAAerr8plm4NbOe8nDeeHkc0YpZPEUP1yi62lSfxEDyXulun//fJzaYIfNJHVV8riwEE2lJTl4sPX1xtP+ybm+smmdbq/QwRFdnDGBzZIc2hohFbs3yGaOA3eIjR9JUs242pPWM5ljMdefqWRN/y4KWYJ50eb0PqaGIDWluZ+gxp7Q==
Received: from BN9PR03CA0777.namprd03.prod.outlook.com (2603:10b6:408:13a::32)
 by LV8PR12MB9232.namprd12.prod.outlook.com (2603:10b6:408:182::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.23; Thu, 4 Jul
 2024 14:11:23 +0000
Received: from BN2PEPF00004FC0.namprd04.prod.outlook.com
 (2603:10b6:408:13a:cafe::df) by BN9PR03CA0777.outlook.office365.com
 (2603:10b6:408:13a::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.30 via Frontend
 Transport; Thu, 4 Jul 2024 14:11:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN2PEPF00004FC0.mail.protection.outlook.com (10.167.243.186) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7741.18 via Frontend Transport; Thu, 4 Jul 2024 14:11:23 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 4 Jul 2024
 07:11:17 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Thu, 4 Jul 2024 07:11:17 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Thu, 4 Jul 2024 07:11:17 -0700
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
Subject: Re: [PATCH 5.10 000/284] 5.10.221-rc2 review
In-Reply-To: <20240704094505.095988824@linuxfoundation.org>
References: <20240704094505.095988824@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <52c52c9b-3f4d-40a5-a808-99424d9975dd@drhqmail202.nvidia.com>
Date: Thu, 4 Jul 2024 07:11:17 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF00004FC0:EE_|LV8PR12MB9232:EE_
X-MS-Office365-Filtering-Correlation-Id: 6afed6fe-262e-4e39-9de5-08dc9c332fb9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|7416014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SHUyTEtwbDhRZGkvZGRueHBjMGIzdGlGdWVyejJBQ3JpRTBXOHQ0bzJVTGd2?=
 =?utf-8?B?Y3JCYTMxMVlOUzJ1VFdtaGQxd2RGSjYwR0FNV09Wb3lsL20wWmNadVFmcDNz?=
 =?utf-8?B?UzlUOEtock1RcXVtNXVFUGlseTQzeUNxanlTSFNEeHZBWnkreFVDVEdNRkRy?=
 =?utf-8?B?WVhiUzZ6alExNXBQUG1rSFdBendMdmRpRlVwZEFVRzZZa1FwdWM4c1h4bGJa?=
 =?utf-8?B?dzFQWThaRHdUTU1YVUhtYkFvUklJRlRjUkJRd2hzU0hTK3dhUmh2dThzRGJF?=
 =?utf-8?B?VmxiWEd3RUhhaXRKcjRqejBDNE80S3F2UG1KMS9CRHdVTWh1STM1ZFlZNXpM?=
 =?utf-8?B?bFhJc2k2dVNuMk1WaitUL0ZDYitKbW03ZWFwanQzYkY3L3BqTUl5c1h4eU1S?=
 =?utf-8?B?cHBmSTdNMXdoWEVBSXJSbG0rNG9qU2daL0paN0tvQkVwMzNCOEIxaTV5L21W?=
 =?utf-8?B?RVEvOGo0bzl6a2N3ZmgydFFlNWxaaEcxem5MQm9NMVFWRUxBenRrQ3g3eFYx?=
 =?utf-8?B?dWMzOStyM2tZYnBmT2Q1RFZTRlU4ZkFsbkRGZ0RYdzZCZ2lyZHZxR2dERENJ?=
 =?utf-8?B?V0hzQmJnKy95NGdKQkdybEtHN0ZKVkxRL3huanBnVVRHcGpPdktaamY0TjFM?=
 =?utf-8?B?N1h4MXEyNk50aVc5Nm03NlRuQ1NJS0E3RXRmU3dOOHRTSTdPTkVZM3BML0FU?=
 =?utf-8?B?THp4TmJzT0ZMQW4xK3pQQzNsbGRIbExDMXhtV1RvTzhTdkt4c2Z4K1BDVzFw?=
 =?utf-8?B?ZnZHZ0hsd2xSTHBKSGJtUnREMityL0tYMGcvRjZITUdDTXMzM2k5VFYwd0hI?=
 =?utf-8?B?aXZoQWNMeW5neVJtb003SHI5YW9sb0lGSGFsV1ZrMmluSnhaTzhOanpGZmlP?=
 =?utf-8?B?RHFmTjloUmd6U1JCSTdKdFZCWGc0UW1RWm9VY0hBT0lLUDMxbEZsMkVFYkNt?=
 =?utf-8?B?SThadHVValFlemduSmFGei91UlpHd3pBK2ZvZnRLYUtSZVc1TkNTeDdIOHdx?=
 =?utf-8?B?anVWSEYzaFVKQ1lWdWhPRE1SSG84T3AxcHFCVjZabkFmcDRBcUhVWkpmYU01?=
 =?utf-8?B?d1YzTmwzN0Fnb21TZ3g0MFZjMzBQQU1vTCtFanJGd0o3ckNsY2ZSV3ZLbnZo?=
 =?utf-8?B?SUZxUDJrU042WEptcDRuUTdiUnRsTm40eWFpVE5wUVRPVUN4TFhETW5BOFpO?=
 =?utf-8?B?QmtkTzZVb1MybUM1S041RU9taDJ2dVJET1pBREF1MndmSUcvcGdWTmZvOVB2?=
 =?utf-8?B?OXAxREhVdGgzUWNGZHVKWFBDN3FzVTBWVTBUemp4K2FWL2xKYW9mT0MrN2V0?=
 =?utf-8?B?MDE5L0FLcEliaSs5bm9vejBtdENlSTNBNUQ4dmIyZklQbCsySFQ3d2tHZ3NV?=
 =?utf-8?B?UWtmVExCRmtNbnNjQ2V1Y2VkejJWYlRPdkhIczM5RDhBNjdwQWxCZmVZb05j?=
 =?utf-8?B?Q3JBN3U1N1poa1pycENha0hqNEs3R1dISTFjS2xURjlaUWFzSWhKNVRBdDhh?=
 =?utf-8?B?Y3NMZWFLNExDd3hHcUc0cWlaVmYwd1JKbkZvblJNNVVUYm84bEhrSkRHSnZl?=
 =?utf-8?B?NmZjMXhLZVlmRkNzNlFrY1JZREcrYmV6YXBrVnJ4Q0NpV0hXcE04WDNSVVVM?=
 =?utf-8?B?K3h2bGpOeGl1YU5VbnZlQytJZUFHZytaOW1aUHNGcmduZi9weVBoSlB5YWcx?=
 =?utf-8?B?b3Y2U0FxZ1ZNdkhPZFEwdFJ2S1VzSGFhZGQ1aHNjT2NxNVhnYzFwTHNjK21P?=
 =?utf-8?B?MkhUZW1UMGdmWE1udmdSY201NExFdmo5NkxYVXV3VGwxa3FDMHZlcWs0UTZ0?=
 =?utf-8?B?QWhWVTArT2pPSURUblg3dUZBemljdE5SbmdXMGQ2MGU5NTFEWG83eGVONHpY?=
 =?utf-8?B?emtHcjNZSWM1T3dyR2VMQmdwUWJBemc2YmczeGVlZ242L0pPekkwNUdEL2pa?=
 =?utf-8?Q?p3ol8XQS4zaBcZwuPuwTCgoTnaixnN8z?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(376014)(7416014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jul 2024 14:11:23.5695
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6afed6fe-262e-4e39-9de5-08dc9c332fb9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF00004FC0.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9232

On Thu, 04 Jul 2024 11:48:18 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.221 release.
> There are 284 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 06 Jul 2024 09:44:13 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.221-rc2.gz
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
    68 tests:	68 pass, 0 fail

Linux version:	5.10.221-rc2-g6db6c4ec363b
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
