Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2075.outbound.protection.outlook.com [40.107.243.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B70E780045
	for <patches@lists.linux.dev>; Fri, 16 Aug 2024 19:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723837459; cv=fail; b=AWkOgjU/E5/6IsnrYM9eWCIpDLXUL2HlXKhjfWZAHlvKscxKsQhAR4emTWmytbe15GxwRtT4N4+bZk+qNMfHiTqtJTmMFehywPrbqQI3U4rDf+8d1GmZP/pAlSeNMgHqYxf5zsVwbWr2FpsLcT/Rt+HA+mLAPOPzYPdIIh117IQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723837459; c=relaxed/simple;
	bh=KsltRLsKdPKqZPQCmexqMJlDKdESiSfmmpGqE5LqTw4=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=eFGYLOMmBPs+gJscaYmwtvuiqGGofbHsOIftvMgkhhHkP7lbCpkD4TBZrsBiHHIGDNmP4G6AgmreV5RatiHEr7cO4NR4nnagacbau/U7PKFVduX2Q3OFk0LcacbaY1ah0jhEhL4T4Yj2TAT7PVnWZaX9CpAGVS0ZkIxz2vPFkv0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=PhWO3vRG; arc=fail smtp.client-ip=40.107.243.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="PhWO3vRG"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rpwOD8njHFm5xU5WtRprQs4RU1ZkN2PX8XHHFkL8kPyl2RSs8OnZp4FqhvDyxhDPwqcjuT50ABuR2GXwFrH43cQGa41VV0uqaf937nXPqhTagpMM+D56vLPSNODQbcz/GP48jCuUdKazmpx23nNEzg2eOEtYwb5dZUXZBMmHJl8QX3AAH2II/xKHIQxMvMNjJTxbu0DLEhl7okENBedlxDnxJ0sTtTvQvDCW47NgS9kB0sMY1b0futDRQfRj7dwdLgcuoq3CPGTh2YVVOxk3KXlrdxdC+0ibgBzatkqdVgG9G6s76DOwsdu78pPUq54koTwTa+kEvyMjjo6eOvuX9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8Y01Aa1LEzBcTdfx5nRK8c8df5b7aWXSORKnihHbB4c=;
 b=oTmibpiVBp7rqEJsuePAbdD2iL1H0A1irMcCNePFjmTR6P1gdCEpPzMtRx9n164xBgEoEE28bHmBYICAPo5VaZCs60RfwkBZeGmIvO63y4Z7cZ3bv5SBIcW95KJ/zso2qTgNgPJUX1ZuOyflEhnRGAcrU4Xm43XwN/t7jVllGhTx+6O0bADbQrPAwgWMZsWMJOoA0u2cAALMfHJ6Bywrfklf7CotcDZ5dssU4tj2zO1JxOAFBXhyx1u6NrfH5Jy0OC4EDw9fz5fGBTh1dv6Qjuuo4MBKvwA+h57AysHU21B521QGQgm8b8P4+TMsNZR2WSrmqIgE1g6HHjowyrQTNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Y01Aa1LEzBcTdfx5nRK8c8df5b7aWXSORKnihHbB4c=;
 b=PhWO3vRGALKIRrJj/iy07vD6rxDei1QmNc3x4VcNRxhHvxsv/V/6QgYzh3gQiUaqvvkaCqesbjLtfa/9sv3aibK2R6SCfjJ4ME3JBmWIYPge38PfIgC42m3bKGppQ4e5oh16D4TD+arS2VhTN5W2mBOtTO65xU0OTNst07Vvm4yITuRBLnPbEDeWiBGc0aOpCEDvdUc7RQaQrclGqwTTYe/iToENrTqEblBynhkhC+gTNBjOmCv2VokHnriOL4ujzvJ8SVqm3c96BQpKzeniuUvfpliJac8Lwd0pGo1UueD9WtFmoPNPoTS4N5TYaU7YPJ5UE13MJgq1/sHPaEbGFA==
Received: from BY5PR16CA0033.namprd16.prod.outlook.com (2603:10b6:a03:1a0::46)
 by PH7PR12MB8015.namprd12.prod.outlook.com (2603:10b6:510:26a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.17; Fri, 16 Aug
 2024 19:44:12 +0000
Received: from MWH0EPF000971E3.namprd02.prod.outlook.com
 (2603:10b6:a03:1a0:cafe::9f) by BY5PR16CA0033.outlook.office365.com
 (2603:10b6:a03:1a0::46) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.19 via Frontend
 Transport; Fri, 16 Aug 2024 19:44:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MWH0EPF000971E3.mail.protection.outlook.com (10.167.243.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7849.8 via Frontend Transport; Fri, 16 Aug 2024 19:44:12 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 16 Aug
 2024 12:43:54 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 16 Aug
 2024 12:43:54 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Fri, 16 Aug 2024 12:43:53 -0700
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
Subject: Re: [PATCH 5.15 000/483] 5.15.165-rc2 review
In-Reply-To: <20240816101524.478149768@linuxfoundation.org>
References: <20240816101524.478149768@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <d08e84af-0418-4e1d-a3d8-bf49a5501d4a@rnnvmail203.nvidia.com>
Date: Fri, 16 Aug 2024 12:43:53 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E3:EE_|PH7PR12MB8015:EE_
X-MS-Office365-Filtering-Correlation-Id: dc23ff40-7496-4d21-9669-08dcbe2bcda0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|7416014|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?S05hZkp1YlVkR1VKeEpBeWhzOTN6Yi9BQXJ5cVNsTjZubFJ3UnFRLzdVSmJj?=
 =?utf-8?B?VklDc0xvUk5TbXh0OUdpa2M3Mk02YVd0cS8vOXFTNWtJd0RMVU1PTUFIRTVI?=
 =?utf-8?B?YStQK25NcytPOVVFSURtc05PUFRQLzB0QVJuMXBHZXZXWDFjYjBhUmRtT0hv?=
 =?utf-8?B?U3hiVXFHM1dMei9kTi82Z2FWbCtSd1ovc3V4TjAwdlhBZG1sSVdFYzF2dlht?=
 =?utf-8?B?c1cxV2Zvb1B4b3NiUW5uVm0zaE1BMENhOFlSei9vSjFlaUJqeEZEK2Jpdjgy?=
 =?utf-8?B?c2Z2YWlxN0o2VVNPYVoyMTc1S2lSZGQ4TGdXaTg1dExYREZwVGI3bkphYW1v?=
 =?utf-8?B?aWFZTWpKS2g5a0FBZXZiZkt6bmlQZDJHakprWTR6R3FxMk53Q0dXdFhFbUFU?=
 =?utf-8?B?ZmxNVDJsTzhNKyt4MUF3Nk9BM250TUw1U09NT0U3dm0zOWNzNHZyZEpvVmR3?=
 =?utf-8?B?M3kwa3dpUjFxSWFxTFVWdzkybGFBYU9tbFRLazFvbUlxZE8zWXEzYnRlN2hZ?=
 =?utf-8?B?b0dxc0h5S3lONmZJTVVwbnR1WHdrd1VyblJQTzkyWlJvcjJJYnZlTXRpKzFh?=
 =?utf-8?B?YjlBM1NWVnF5MW02ei9qalhxb3RxNUJVOXFZRUdsR0ZRZzlYTE1nci9WUmtT?=
 =?utf-8?B?UW83bDVPcnZIYlR4M0RtUWc5b2hyTGl6TWNVZ1VDZVJhLzEwNVVzVSsyLzky?=
 =?utf-8?B?S0FBdXJLUmNlbnVEemlINTI0a1FBd3FPaVhyKy9kNHNDWGtBMkNQMDhnZ2VP?=
 =?utf-8?B?d0N1K25PY1kwa1ZITk5ZRDdQQkx3UW5JQVNhRmR0V3BRVFEzeWk0S0tyNG8z?=
 =?utf-8?B?N2lpa0VnV2hNNEMvek52cDYxdXFjamVyajl2UDdzNUNvdWluYmRiVGhwa0g5?=
 =?utf-8?B?aU1pSUVOb01ZVWl6dHNrdjhpUDJTbHY3RHl1bE5JQzZtS3kyaVhod3piVE1K?=
 =?utf-8?B?cC91SlBrQll4YVVoWUNnZ0paZHRvd1AwVmRhN3hRbHZBNklManlJa2Q2L3M5?=
 =?utf-8?B?c0JNUTBkdXBXM3UyVnRiMDI5eDlLWlRSVTZmT1B4U0NmRTBCbk40ZkU4SlVS?=
 =?utf-8?B?SGgzTkI5YW51NW4xeTgyTkN3NDJFamFwLzlYVjZEbThKMnFVdHZZdlYxR2g2?=
 =?utf-8?B?bUdYQWd1eklWNXlNS2ZEa1hqQ3d6SEwxNEUxa0NTMWtYcXpDd3JJR0ZsS1Zx?=
 =?utf-8?B?ZGdpZjQ5TGtFN09CU1lGZU5zK3ZTY2NROFc2QXhiY2ZibWlJdy8zVlRGWlVZ?=
 =?utf-8?B?R3oraFpDOEpQVEhnRjQ5SVRUU09hdnFNcHU5MW1PdkEyVjZCZTM0VEp6VDVl?=
 =?utf-8?B?K2ZIOGFvVmhoQUZPMnExVkNDY1lDeDlUY0tydk1EUjI4eXdZQ3JlUTdGRk9X?=
 =?utf-8?B?SlY5VDVucG9aYWxxUFZ0Tm14QWszaVFTYmZYbEJFY1dkbTF6TndTZTJseEl2?=
 =?utf-8?B?QnI0YzJTNVV2Y1Jva09LbG8rZ29DRWhpN2JKVm9ORkVQT0x0ZElhVFFmU2JX?=
 =?utf-8?B?S0Z6Wm5QVjZSNm1XckJlT3ZmSUpOVjdHbzA2TXFzMlk2Zzdxc3Q3aWRPelhx?=
 =?utf-8?B?aDVhdERSa210dGM2bmN6ZTRuRkdMZDFOSFNRMllqRHNEU2FoMUd3bGI5cG9j?=
 =?utf-8?B?cXV1MzZ1SE5zL2tGQjBQN1piY0hoR3ZxQkxqcDZDRXdpSVUxeWNvenlUcDAv?=
 =?utf-8?B?M3p2RTY5VVVoVWtqZkFKNUJWUXhGZTRuaUdPVjRaQmp1dHhTaTI5eGU0UE5T?=
 =?utf-8?B?eTA0aHhzSnFsOGtXUzZEazZVY2ZPeE1ZVUs4U2gycllwUHNsS2dLTmFkMjM2?=
 =?utf-8?B?MTVOeUVsUzcwcE1lZUg4NXVQVDZoSWhwcUlPQkZRR0U4MTVDeEw2cVJBYkhi?=
 =?utf-8?B?eEdRUlFrZWpwelNxaUpkcUJvQkdBSnhrSHNTZk1iVks1OFNuTmg4QzVMNnhl?=
 =?utf-8?Q?5qHW5JN6PmAeqob23YzMcD4DepG7rCkM?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(7416014)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2024 19:44:12.0773
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dc23ff40-7496-4d21-9669-08dcbe2bcda0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E3.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8015

On Fri, 16 Aug 2024 12:22:17 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.165 release.
> There are 483 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 18 Aug 2024 10:14:00 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.165-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.15:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    102 tests:	102 pass, 0 fail

Linux version:	5.15.165-rc2-gaff234a5be72
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
