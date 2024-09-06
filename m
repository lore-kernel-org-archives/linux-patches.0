Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2081.outbound.protection.outlook.com [40.107.244.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 493A81C8715
	for <patches@lists.linux.dev>; Fri,  6 Sep 2024 10:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725616937; cv=fail; b=ORPmczBiUcRxqfYRvhEgr7WexZ2J4jX24526KErPzLla4+iu/W3SmNXT/rsIHneKN+mwxTXmQAqXwJ27+bC7IwD+o4230hYLmUkITjNmEbteFmASKYUBEhJDDS5/mtxVZTAYosrHaSMBLAn+2cr0tWBGrvfOszhYc/83WJ0wuns=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725616937; c=relaxed/simple;
	bh=xhFPFguPnKWMSpYEnds8IlH0oJd1bCHAHNNK6TdXX8U=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=TA0AV2h+LK3UScPqEbWsBIT5eCd6SdFEPtluR8nGBny05ABShpnZnc1IOlFUd5PfuXmev7UnIqoPWZBRaKi/3Xebg6RfEzkxFIeii7fsslye7LR6bFOQccEDRg/IRrVL55ujeu8B3i0AiuEH+Cdr/K2qka3vVLM9rnLiZ1KB7/w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qTDAjhdK; arc=fail smtp.client-ip=40.107.244.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qTDAjhdK"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ruQXLWRXOIn8Hz83NyIuBeEbDb9k9e0KJmxnCd778j3T+pRMHgVVdmXRvEqhYgKb2JpsBt1fThRJNIbel9FGA7O479q7yRy8a4FmKT2nIpNOcf8Gbc9wJ3uHGSJXJsMw6mKeUYosew7hFoPDk4pFGb4JwxB5mg9lanZllKT1Y08uIIGJLmaINDetTkUvXBd87pRw2VupPhka9o453+gf/2nYq2cJvn+wg0ccZ6PjSZ1xtT1lldO6ENZXz2uTsYvvZkwX0qvUU9J7Aa0tMUmQhaBuknnSANEgtWHySc3tBjeSEzHrAER85YoyK1OjlzjGPyme9F3vPrq7N9ZaDpN6gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DWqpOmhjBXxthMClChEI4y2YhomoJetBhPwb1aWk2VU=;
 b=NslKMtqy4Cl6m1F1+l56lvz1u9atQD8MpiVnk1g/8+sWBoawx1x0TMCZamoCmiGtLUfh+7MuQ8VPD4/4VoTtTaS1iqWI21DMx59euwQxElr6cRqnXo2tjvxdCd86Rv5RGLTJrIVHmQ1am+l5dQUyiLSw+WRjPb4HmdRwaS7BPuVWOnlvxswNAlWvqQW/uRyd3EwjTumJ9jeII8pzUUhGFnmel6pIYM+Nq5w1SC3UhhxgxTwYVHholT/llX+A4eGjtB2manFlXa5jlKztHNwcgcPB7IveO+mMgzbpk807fYlIVQs5BkdCJDRIVOfF2SePk+r5DEW0IdwHmKsjmo2XAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DWqpOmhjBXxthMClChEI4y2YhomoJetBhPwb1aWk2VU=;
 b=qTDAjhdKeRU7cbBdzMH06c0gNbG3m3NNl4pyBlt1ZkkixeDKe/9xnZGfyy7GbcT/qh7dGjcQX7hcoqyIZsbwOJUdghGKD3GEezZ1uLkZ4IIhHUdP7zIp5jA6Al6fPw/jVILp/frLlIxx5Ug4DRtOV43xCqyhg//NquEzS5COuFIZODBmbjhqy5s9mq4EUl6/OKSPMFAZwfYMIcKUtZ4kXV0NY67USs/Gr0zxYRd1jDsMGGxR79FQK5Qnq+a1AUssJzSiXKBmnb16Q1CgWGCT37OsN7NKy2BsjmHEkrbyiyF8zNQGs5H+37VzmyUmuRMphjMHmbrPOMPPR3qtz4u60w==
Received: from SA9PR11CA0017.namprd11.prod.outlook.com (2603:10b6:806:6e::22)
 by IA1PR12MB6459.namprd12.prod.outlook.com (2603:10b6:208:3a9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.17; Fri, 6 Sep
 2024 10:02:11 +0000
Received: from SN1PEPF0002BA4E.namprd03.prod.outlook.com
 (2603:10b6:806:6e:cafe::7b) by SA9PR11CA0017.outlook.office365.com
 (2603:10b6:806:6e::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.27 via Frontend
 Transport; Fri, 6 Sep 2024 10:02:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SN1PEPF0002BA4E.mail.protection.outlook.com (10.167.242.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Fri, 6 Sep 2024 10:02:10 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 6 Sep 2024
 03:02:03 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Fri, 6 Sep 2024 03:02:03 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Fri, 6 Sep 2024 03:02:03 -0700
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
Subject: Re: [PATCH 6.1 000/101] 6.1.109-rc1 review
In-Reply-To: <20240905093716.075835938@linuxfoundation.org>
References: <20240905093716.075835938@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <fa0f7a94-f3c6-4de1-83b6-1c1b7bed81c8@drhqmail203.nvidia.com>
Date: Fri, 6 Sep 2024 03:02:03 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA4E:EE_|IA1PR12MB6459:EE_
X-MS-Office365-Filtering-Correlation-Id: 84a8cc7c-4420-46fd-b1c9-08dcce5af96c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|7416014|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YTgvNkg4WnFvOUhkTHovVy9xSm5JODRGMHpLRjF3bmVYUmNJMXVaNGtDU3Uw?=
 =?utf-8?B?OFRDc2NCMGpKN2pDWlZ3dG5VL0pNN0l2WG1VUHFTcmJSeC9PUm1lK21MR2Nr?=
 =?utf-8?B?SkV5U055R2R4MDBNYWhnZjZwZnJJT3JVRVFyRlRmMnl5N05kMmR1TklIc05J?=
 =?utf-8?B?UnB0R1FaQzA4ZGpxNC83SEFFSEVZYldqSUtwMWE5QlBmQWl4N2ozejhXQ2Uy?=
 =?utf-8?B?djdtL0xuK3M3aHVCTDlVWjdybktvcU9DZ3VkUTVVWGlZaGhQaWxzcTVzbXgz?=
 =?utf-8?B?YkhSakNZbi94WGRRTHcxNkhqU09uSVNKWU9BOUZKVUcvTmpYSXRqbWlnbWJw?=
 =?utf-8?B?Q3lvdGNtdU9kUGtQZ1VjaVF5Tjh2NER2TzlkSXVySmVQQVVlbzBnK09JOEs2?=
 =?utf-8?B?YU02bGlhUlBuS1ZNTmZCWGE4OVNsdVNsaUFnRFVjMWRVRTdKS3p1RFZkVHlD?=
 =?utf-8?B?THJXRm8vSWJmOUdqTzlIRTBOMnVDanJFd0lPeFc5ODVJSG9EVTNnVHc3VUdo?=
 =?utf-8?B?dFhhV3lTWGwybWZOTDFYeEtmM3NBSDliSFFpbTVybTRLOW5iSWptdk14RHZ0?=
 =?utf-8?B?UnVSOUtiT3hKbzA2U0MrWFJXK3N5MTdrQ0pYMVJnOTdOc0dCWnVkdkRrUWRk?=
 =?utf-8?B?SktFVkNWc1Y4Q0U2V21wVi9BZGJsQXAyMFYrYjYwWDR4YTlxZ3JEWmk5enJm?=
 =?utf-8?B?SUtzdmI0L1ozM2R0OVQvd2RzbUpGT0xKaXNrU2N3MHRWbjBxOHozcWZwSGlH?=
 =?utf-8?B?UVZVMDhNMFhBcENiNzExNTNVOTBIRzV4M1NpRkhwNWV6M3ZIdWRpNk1DNW5M?=
 =?utf-8?B?YklnVWRZWjQvUlVRUjJzYnRjdEtGMG9CSTJaRnl3RlZHa1J0WDhFRFNPS0Vw?=
 =?utf-8?B?T21YdTlza0xOME41UUdlMWZDRGJleWYxdHJwSHg3d0tpSXBvaVJJOFVPS0xO?=
 =?utf-8?B?UFFVWEZGTW52bzdpNGlmK0Z4SnVnNFo4SmdyVUpORUlzR0NNNTBPVklXMEll?=
 =?utf-8?B?NTdSZWJMTklpMkFpbUlFM3A3MTZaeFFsL0NuUlpURHBpclhUUXcvNXpDVGlT?=
 =?utf-8?B?VDV0Wkt0NjIzclZWNU93N1p1VURveUcxY3cwMzM4TWkrS0p3QytyL2R1QVRm?=
 =?utf-8?B?ek1iSU5JRjY0MnRGWWZ0YUhXb29HUFd5cndkUkVNd1ZCaWgwOEUvcHN2S0xl?=
 =?utf-8?B?bWphazBlaEtpWnA4eGswSTdCaWF2OVUzejJLL3pwWkZGUjFabVg3blQweFdD?=
 =?utf-8?B?WXNCWC9wZk5zZnc4Qm1tbjdCQmVKTXJuTmg5aE42RkY1dk13cEI4YnEvaGty?=
 =?utf-8?B?aHd5ZGJabENuK1ZHWC84SktJaGVsL0VIYU5acnBtT3FlNEtHVUFHSEptTitP?=
 =?utf-8?B?UDJ0RW01UWRMcE5pY0MwTWc2TjlDYTYyRHRTVml4bHdEeUdZRXcvcTlhQW1E?=
 =?utf-8?B?aGZ5aUxKQmpyRDIvRFpaRjNBQVgrd2tSQzBrVVROOXNDR1JqRU5FZmVwWjBq?=
 =?utf-8?B?a3huL2lrQTBXVGdoYUROTitFakpPMGlyLzE3WGVYSmJZc2dnNjZhTEVOZlZ1?=
 =?utf-8?B?aEttb0tPR2FkY1ZlVjg5MkZzS3dRbWxDSmJHVXRKVjVDNmo5ZjJFMXJZdHZ5?=
 =?utf-8?B?YjdncGRvU1B4Ym4xYXk5S0EwZlZkM2lJM3Btbm9ENC8xTGU0Skc3UWpFcUpo?=
 =?utf-8?B?czY2aGFhWGJ2dmVuMmEvRFA5WVlPSVJpRitjbjVPL1NBWk9wakI1OEVEemEw?=
 =?utf-8?B?MTk1NC9FVXZIUVZ2R1dXdGk5VTB6b0N4cFFLVm9sZHppdkRFNWpWd1hSOGN3?=
 =?utf-8?B?dGlRRTlNeXVIanJYcWF0cENHWmFaYzBBUVd5cUE5ODgyczdBOEtLaWxmUVh3?=
 =?utf-8?B?VHFkQ21FMGttdHR2Q3hHbmV6cGk1bGhKL0ZDRzNaRkRibUpTcnh4ZjRreGNv?=
 =?utf-8?Q?ZjzuXmIHbjGXpBHATXXSS9R89vUYuHgO?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(7416014)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2024 10:02:10.5546
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 84a8cc7c-4420-46fd-b1c9-08dcce5af96c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA4E.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6459

On Thu, 05 Sep 2024 11:40:32 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.109 release.
> There are 101 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 07 Sep 2024 09:36:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.109-rc1.gz
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
    115 tests:	115 pass, 0 fail

Linux version:	6.1.109-rc1-gbe9ed790219a
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
