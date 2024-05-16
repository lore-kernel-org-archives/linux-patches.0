Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2089.outbound.protection.outlook.com [40.107.220.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3667E763
	for <patches@lists.linux.dev>; Thu, 16 May 2024 12:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715862740; cv=fail; b=qC1J80u03A3Dg4WMbHXxD2ZYwGFnfLSIgXBQT2m3gJF4N2uEBgTol6Koh1462Z61DNwD/PuOUldfnWQiKtE1Mtn6jQTidU/WpnTF7l5i0HmF3g+HYvK5giHIePuizfaD430QvmKecqhv6WCxB93DCQMoxGh53dFSEPUppMYWkr8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715862740; c=relaxed/simple;
	bh=CPAoTNhUtV5UoOSTIYdgy/p82/yeke+T7j9X+WuwcMU=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=oC02gP8hcaPTlIO06xMzTgcAAOcoRQb+rwXJXDDxfT0Sku/uSOMxLlHRd/IzYwIDBzkUFXeo+IEeyD5TY32jbi134FivNUtXGSPoAEfjEpJA84qK+8LOR7AFNIkkF6jXbD8O0xtdO7BoXjlUU4aBo8UVeiRRmr3avnWc+nr5vAc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=HLU6kQt6; arc=fail smtp.client-ip=40.107.220.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="HLU6kQt6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X5YS7s54LqT+AMbKue6q2oUPkaKRmgM5oarZzd5BLkxQU4rw5MNrvLJm/drrOd6Xt2PmYgFBBoDSvQZolu/VPSJLnBj04SyC3l8aR25nWO6h0hDqTfW0zBWpMdGMoOXtbu9o1/b+xx+3CmJjWSzTVNOUILXvOcEJmy217pCPfzoRsx15Rk3HuVaBCObSrIwtjdUN6cIhxr0actVDrlx+6E/W1db7f+895s5eIaIZqJp+1549zFr/BUEz4ARaR1fUKcXWJrnHL4Z6Jv/5Z6cZOThYJ73lF9nn3BsbXqg8eYnxQlgMjobIvvkNl8Q5sAgd/QseTSZJgZsXfgIQgyYjBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pnSUQ9KYqxtPX6P7iz6+qk1zjM5OLDYyN8n1Ikf+A5E=;
 b=YtJwHCLPr+9gc5jb8rGuQeSNRbrO7GCgAcOybOMBhic4pRm0NJLwmUEyDezUL6ZH+CY0pbanEK1OVEveLgUNgW7g0Ic4EHGOYQrJdUGZXwIn1UxPbCaCbr2bCmHYH030RPdwfSJmXylNmdkC5G93XgSy0aCrIzw/hTl+kIgvGNFtcdQq46QAajk6mSf8pzOfozxXidrIVebeePy94rkW7sU1MAW5IZ4cgeMnq7V/mKls6CVTY4jjvhZX36Ri3He337d+heiKMbTnqyh/f+lj7Al8kHIP8zW3eDCeKV+Y/kTg0ba8kSiV5ufl4BYplVHvNia9m6GECxdS5apxQx0kig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pnSUQ9KYqxtPX6P7iz6+qk1zjM5OLDYyN8n1Ikf+A5E=;
 b=HLU6kQt6sM4eBFVHuqHmNvSSFJfowtIWMJXb10PXka+QprKDCZyXmiNEQg9P+g/up2EYzKTzWNjhYxLJXReUTm8BFya7a10pnemJMhBYEd3d/QUVao0Cd2xQKIwI9PwWAppWwa9uRRyIB/ZsZAEuFdGEFRfeZO7xyGCjmwttLjuFXOypoxZ6/vghxRvP5MFCtIBvpNoHg4CNVXm6YWzBt3+wni1RC78wmzsau5paOT/pBShk83byGnbutYZ2TylIHrSf8bYGqHAqqSmOowmm9ZuQW9gJOshKFddgT7vhsChuWf4BAzY9A9abjD5mAL4dIIgrbxD/KZV9AkYsbXdy0Q==
Received: from BN9PR03CA0035.namprd03.prod.outlook.com (2603:10b6:408:fb::10)
 by CH3PR12MB8212.namprd12.prod.outlook.com (2603:10b6:610:120::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.28; Thu, 16 May
 2024 12:32:16 +0000
Received: from BN2PEPF00004FBE.namprd04.prod.outlook.com
 (2603:10b6:408:fb:cafe::a4) by BN9PR03CA0035.outlook.office365.com
 (2603:10b6:408:fb::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.28 via Frontend
 Transport; Thu, 16 May 2024 12:32:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN2PEPF00004FBE.mail.protection.outlook.com (10.167.243.184) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7587.21 via Frontend Transport; Thu, 16 May 2024 12:32:15 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 16 May
 2024 05:31:55 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 16 May
 2024 05:31:54 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Thu, 16 May 2024 05:31:54 -0700
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
Subject: Re: [PATCH 5.10 000/111] 5.10.217-rc1 review
In-Reply-To: <20240514100957.114746054@linuxfoundation.org>
References: <20240514100957.114746054@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <0f99cf4d-64fe-4e3e-af90-6cd23497821f@rnnvmail201.nvidia.com>
Date: Thu, 16 May 2024 05:31:54 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF00004FBE:EE_|CH3PR12MB8212:EE_
X-MS-Office365-Filtering-Correlation-Id: 95c554e0-a107-4d7e-4fab-08dc75a43851
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|376005|36860700004|7416005|1800799015|82310400017;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dmF3UWRMWGtZQmRCSDFySDg1SlNpTVhITXFoMnlYaXJyeFdaMWc0dlFWZTBy?=
 =?utf-8?B?TzRuUGNFVWZnL1RYbnpqT0FSTjVPZllPbWFERkV4VnRFdVZ0cHNmcFdRRXZC?=
 =?utf-8?B?ckVFdlhXdEkvc0tTeWQ0N1doL3MvMmJmWG5PVkdDdWxzSWdwWUxJUys3Tmlj?=
 =?utf-8?B?YkR1emhQZmxnOFRRUzZMeU5peUZuM1dpbnlSZFdpT2RLVDA5ODR5MkM0NUl4?=
 =?utf-8?B?cmkxMXh0bElsRnJMUDlnY2lxRE5obVlXVEJzV09jbUhMNHJwVU1TZFgzS1Y3?=
 =?utf-8?B?TUk5QytNVzlCNDlsdjdRcm84bW42VFZqRDVsN2RFYVgvM0V6VTZPMDZPUW1I?=
 =?utf-8?B?ZlhJU3AxaXpDYnJJZE1NSU1JMWZxYlhzZjdrMTV2L1l2Z2tjMDlONkhSd1ls?=
 =?utf-8?B?ck85TURySVg4ZUtPMVM2elprZkdhYnRBMEdabkpUSlRZZURBUG9vVkk1TEdN?=
 =?utf-8?B?VmZUMmhNQmF2TWYwM1dsT3pXczIybnVRY09YTEZsb3VmaFhlWUxYU2VhWjNI?=
 =?utf-8?B?VkNPTFlhMGNDdFBNd2FXaE9yRXQvNnVNMmtRdk5QOStFaXhzb0MwSE5SQzJ2?=
 =?utf-8?B?N2hNaWtGeWJxWjduZGNqRnBFajYyc0NXL09OTmJaS1Z3QnB1WnhvWmlYMm1Z?=
 =?utf-8?B?TFBxWUt5Y0NDNXdmWXRsdFZKZVNCTjJEM1dwNFVjVkh3SjBVU1MvTWdpeTJZ?=
 =?utf-8?B?c3RFV3hWOGhuS2tTY1hBamdpRDU2Yk9LSFA5TmRFT2Vsa25ydHBGbWdENEZt?=
 =?utf-8?B?bjZyK1lrcWJndHZiVHNpM3BRcTBSSERlTzhtaGtzblh1cjF6bkxiWWk3Y3B6?=
 =?utf-8?B?UnVjVTlZWXlQM2JDaGU4cDNRM0QyV2lxaWtnWm9ITVJtenVxMEM2MllFakll?=
 =?utf-8?B?UGllOC9mMzIzb2czYXh1ZjQyY21Xd0hWYXJ1amtlV0xGOTljQmtQNDVtZnhS?=
 =?utf-8?B?Y1BhQ1hGVVJibWtQL3BCN29EZEJEdDJNdUp4V1gxQTdCZXZPTnhZeVpYZjZT?=
 =?utf-8?B?c05oeVBqZ3l6QjJHR3RNSnRyMVVBVy9kNngzbWE5NmhCQmhjdDlaZWVuWlQ0?=
 =?utf-8?B?enMvenM5R01sWTlzNUJJUEhvSllUWVdYZzdwN3RBT2NEbEJwcHVsd0FRc3V1?=
 =?utf-8?B?UVYxSVIxWko5dk0xd1AyQWJ1K1ZhVFZEbjJWVm5xR2I5dlVHWXZNcnR3TnhK?=
 =?utf-8?B?TFNpSndLLzFuR3F0NVFrSkdzdmFCYmVOU1g3R0FWRGdzdWRaeE4vcGNIc2wy?=
 =?utf-8?B?bUFDdVN0dEVBZkpZTVlTVmhNaVUvc3kxOXFnRW9Jb2c4aFA5VTBSUlpBREJj?=
 =?utf-8?B?bTI1aGxIVERaMVlrN2NoamtzNEJlemVhR0RpSmNONFA2c2Q0Z0xEMzBHZTlq?=
 =?utf-8?B?a3JvVXlaNnppNHJ0b0lLR2lwczF6NlVPWHlTbTQrU2xMaUNJRnpnanF1ZFJY?=
 =?utf-8?B?cDZJT0NCalRjcnZkUDRXRE02aTVqQWxVU2I3Y0dtMTdiQTY4cW5uTFZEdHlJ?=
 =?utf-8?B?eWhNemQ5ZDcwOVl5RXVUdi8rSXplS1Mwa2ZMblIzOVFNd0hJOXA0dTNyNm1D?=
 =?utf-8?B?MmYxbDBFdGFiNDRSKzlDb0RqVmFoa3NzN2g3RHNWdHk5elFpQW5lLzRSVGpp?=
 =?utf-8?B?Q1Joc21JK2szZTVLdm1GekNsQzgrR0hMcVFpM3RFYkppWTRkZ2ZpRkoycEZ1?=
 =?utf-8?B?aEM2ejNzWVNtZFk3MVdWSmdZVklEeFhnQTBzOHVHeWVLMTVZVHloZGszMDdG?=
 =?utf-8?B?L1BOLzNyeEIyeFVxaDNCL3IwTzhlQ1R5T3BuSk82a2pOSmhZNk93TmhFaE9v?=
 =?utf-8?B?NTNZQWJtZVc3WEgvZVdvam10RklUeUVpZzh3anlKeFVFQldnZVZST0Nycndr?=
 =?utf-8?Q?sq2IbMNpS9LcD?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(376005)(36860700004)(7416005)(1800799015)(82310400017);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2024 12:32:15.7675
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 95c554e0-a107-4d7e-4fab-08dc75a43851
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF00004FBE.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8212

On Tue, 14 May 2024 12:18:58 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.217 release.
> There are 111 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 16 May 2024 10:09:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.217-rc1.gz
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

Linux version:	5.10.217-rc1-gb060558757cd
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
