Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012026.outbound.protection.outlook.com [52.101.48.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 623ED3F9C5
	for <patches@lists.linux.dev>; Fri, 10 Oct 2025 17:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.26
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760116554; cv=fail; b=lgVnLtScy3hBfO47GcJLtrut4owanXDyPsgdStVdkj/mljpV/Cs3SgIAMGzXSezLhqDBNcib71tGcKLEfr58rIAAAy+K1DTNZUz/U7Flc+rfBDtcSPFo8COcjiYRP1U1IAKBttZ9EAJF1Z8GmKvI5c5PSh4eMVWfMwlK/GR/pLk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760116554; c=relaxed/simple;
	bh=Y7UD/oFqnLasfb6zAUS+WGDyL7F3elxKejyE5l2kd9s=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=QbfE04FdFpSTiTAP1fS2HMyQrS2x4C4IDLnqQf9z+pCrhzSXOHNk44ahpJ0IITWTIMlu9zNjPaugTSSPTHdMlWTBLCks1JFDsiRKnKKO82jonjeHLzskP87N9kpDGAC/1Gyv5zEc6Vg0D9+896TYV3kBPmi+M1RFETfN5mmq3C0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=EiRuN4vA; arc=fail smtp.client-ip=52.101.48.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="EiRuN4vA"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I5IuDgGhOLmZqPniBdMS/nL86gZATa+Ds45FQq+6NNBl/Ylg2ALc1YM8fgsmn4kqSbn+UEePS9Rm3eln+Y8fIyoDQ4B8CtCOM6/teCggtJI1VmREsGEu3W0hNy9cavx+cjF3QgSdaWP6k0+/wTjFeUkxXxfI8NWsW13cwLGok00plFqyj6VR4Zmv1IilajYtrp4CznLsJ+2++/cs3ut0qzPUKYwEQirIwh10tYN46gvB3MujmwF8qFOtK/r/jbSLJvPGIUQ+zwgi2q4vnPr5jXygwd4PjTQcKGTV/r2hqFDTtBCCpvALiUMGb04jfYgOaK8TMRoHHG6x5SEBOjZ8qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7uXxr5cxIg4c2ABdk8hMNszSnkckDlcyO6ZpL89Hhh8=;
 b=VTZwN0fOO9XyYWqOdP3l0imrHs+op2RJKhNnUWbGgUaOpYroW76ysqScRhoqEOghGKl12iBGTejSJOA6/P/yMHeA8nq9+bnD2axo4nsJ6mr0AACU8I0+ncywbKFBXUfPNJiJntFH4EYzrGVpLYzfuJ/tzE7x73zs2eD+Q0CabqyPNnn0/y5l0iR5rsK7/rkAaZQkr84aJzMasl7xmeZ8je1/EQgXcJyHqh5SwL6/Xr6SWSFUbz2BjIqzeHAbAXNDiTMG/KiGanHGFwTdq5/YZCFHF+CyNTuvPoKyRmaPZoUXcyHnar+d68Fh8SD0h056IxsoUh7sB/DIrch3FqRHvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7uXxr5cxIg4c2ABdk8hMNszSnkckDlcyO6ZpL89Hhh8=;
 b=EiRuN4vAPCaoknZ0Xkr9lNKiPgqtiIFwWPU4uH2T0BXA1L2kz/nMiMlzDNTafKRuPUQokdpgdMcYak+z/gRTG2J9poJ4I7pwmPc8Dw/7djhUraKAsiGaf+fuLIP/GR5/SLoj1nCXIBIbICWLLssutoSNm5DhTVYNboREuTxyj1w8ayXYFcVV86BMhsCrigAFt4ai+xsDi9aYSxr36fm4PVbnvEc/8BKJNDvADBDiR/SEQsqLkEQ5hn5knbh/S5LhJBLE2D/cxkh7FoMPJ2hVK/HJ0UZAm48jJ0Qh6MVW2FhR25UKNflIcL3/Vvcr6xIJQyRt2ZMRKAPv1xABFIUSFQ==
Received: from BYAPR06CA0021.namprd06.prod.outlook.com (2603:10b6:a03:d4::34)
 by PH7PR12MB7308.namprd12.prod.outlook.com (2603:10b6:510:20c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.9; Fri, 10 Oct
 2025 17:15:47 +0000
Received: from BY1PEPF0001AE17.namprd04.prod.outlook.com
 (2603:10b6:a03:d4:cafe::cf) by BYAPR06CA0021.outlook.office365.com
 (2603:10b6:a03:d4::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9203.10 via Frontend Transport; Fri,
 10 Oct 2025 17:15:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BY1PEPF0001AE17.mail.protection.outlook.com (10.167.242.107) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9203.9 via Frontend Transport; Fri, 10 Oct 2025 17:15:47 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Fri, 10 Oct
 2025 10:15:38 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Fri, 10 Oct 2025 10:15:38 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Fri, 10 Oct 2025 10:15:38 -0700
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
Subject: Re: [PATCH 6.17 00/26] 6.17.2-rc1 review
In-Reply-To: <20251010131331.204964167@linuxfoundation.org>
References: <20251010131331.204964167@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <f2b27b64-e08f-4312-8ec3-fc7cdd2196ae@drhqmail201.nvidia.com>
Date: Fri, 10 Oct 2025 10:15:38 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY1PEPF0001AE17:EE_|PH7PR12MB7308:EE_
X-MS-Office365-Filtering-Correlation-Id: a7fbb9a2-efe0-49c1-936d-08de0820a79d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|82310400026|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NlJIOVg3dytHOFpkbUhhcEdKcTdrL3JvTTBGRStvYmpVb00zeTNBNkNyc05h?=
 =?utf-8?B?elJZNzJiZjduT1FBYUR2QmZRbTJCMDF5U2JTcWpiUTliV2tUTkpQVGVhbGxB?=
 =?utf-8?B?TXhlU3VtbGgxdG5Eb0E1aGJXelhLUVVzelJxZ256WEJBTzdFMVE1NDFjK29w?=
 =?utf-8?B?NjNBTjNiTkg0Y1ptUmZydFdtS29TTXJXTXQ1ZUhObFlaNEszTFg0dkVzMXdj?=
 =?utf-8?B?KzZweXNOdnI3S1FRbUlFSXVYcTRMN2RXSFRQbXJuMTBjOTVvV0FVWGZwQlcr?=
 =?utf-8?B?N0g1bE5Ec3VYRVRralFaSisycTd1MGYwWnZwc3lyWWloSE4vVkRiUkNGZkJS?=
 =?utf-8?B?Y1JTbkNML0Jzdi94eGlOUURZNnJoeU44YjcxWVY0M0ZCVGJib2lNMmMreWJu?=
 =?utf-8?B?akhjUlRuOWIxc1hKM0JKWDZuWThqMis4b1FhY0RrN0hJblU0V2dvL0hLU3Jk?=
 =?utf-8?B?TDdic2podmkrS053R0YyU2xLaDcyaitTbEt1eUd5SjBYUE53VnhlVHlUSlZQ?=
 =?utf-8?B?dlR1Q0pGaCszVUw4K2t6ZlpoeUg4L2N3Wi9WQmREUmNwTVBTbkpETklTQnMr?=
 =?utf-8?B?Z09QTG4rUkV1ZE1Qa3gwTFdKSk9aRkhBK0JVVHZmWVZNYzRDNHJzNFpZQmlk?=
 =?utf-8?B?UkYvOC9wMWd0R1U0Q3hZbWdHYkU0SXlnS0pzcy8rNHZJemliSUFHV2ZCaW5h?=
 =?utf-8?B?ejhJQUtwSm1tRVg3bG1aQ3dWd1k3MVZrRVlDMmE3OXdhNGNvYUpHdmxvNVln?=
 =?utf-8?B?R21SSnFQanFVc2pzTXlnRHRuMHJiMmEyUTR0NVNoamVuUDZTREJtS2k5WHpO?=
 =?utf-8?B?MFAwbGRNNFdtVTBGR2xFekc1MWZzeWFuTUtoWFYvd2oxLzRaaG9xS1d6OWxs?=
 =?utf-8?B?bGdlNkhPZHpDU1E0WmFvMndRSU5Eei8zNHVrQUZlVnR3Vng0RTdZWUo4ZDRi?=
 =?utf-8?B?Tkd6M2RGbGRtUkQwUjBzZi9SeU5mR2tZaUw5RHExRlJJRTl6Z3N5ZC9GQ0U1?=
 =?utf-8?B?d3NJSEU1Zkg0ODVabGhwVDdaelo5TU1SdkpJcTNpZEZsSDdhMnFFTTQ5NWN3?=
 =?utf-8?B?UEZEQ0RObFJ4cThJbGdXYWtNVFJEUW1RdFQ5UjNoZ2JhNzdKRjYwbzRuczRa?=
 =?utf-8?B?QVM3aW1lTHordU42M0xtU251VlJHUXcyQm9MYWxxS2M5S3NUb3duUFlOdEZW?=
 =?utf-8?B?TWtsMHlCY0lzQndZcTkwMXdqWGFpZG5kVEgvVVVDcGZmcXkxejZHSHRHYzhM?=
 =?utf-8?B?b1pVZHprNzErL1NydTAzMUI0c2JxczdzQ2lPSmE0VlFLb3dFUTJVNStKSjQ3?=
 =?utf-8?B?ZWVSKzk0Q3ZJTFF3VUNTVkZLY01NM2JBUEJhaVBlaE9JTzRPWER2akdyZjZq?=
 =?utf-8?B?ajlqcUpKd1ZPc2RqV25jL1lSL1ZwdS8yNHJhbU0zN2JCZ292K0hQZ1Naa1JO?=
 =?utf-8?B?QkovRDgzNFc5cmkxcmlESi9RaFQ5YjZObU82aEVLUmw0SzJidFYwQmd1TTJV?=
 =?utf-8?B?ZjExUkE1TEJ5bjhFUTc3MGQ0a0xuZ3FzZGVJTGlLdi9rNFJzUytmN2ZDZ0VW?=
 =?utf-8?B?Z0xIM0hJTXI3bDJXQWx2S1JLbm01WUl4bW5jLzVabmhieTZpenYzdThoZmxJ?=
 =?utf-8?B?bHBPRXdrSGJGOGFPakdYZUZPZmtoa0l4T2V1czBIWmVZSGRTSllzOUhMSDEr?=
 =?utf-8?B?SWpxLzFHd1B1K3lvUU9qRWRuZWdmOS9lelJBV3RWQndkcWFPcEo1TjZhSHVI?=
 =?utf-8?B?L2krMUpuL0d3V0liWDhtRk9PN3hqUXF0YzA5V2tmQ2gxSENTNlZ2TFJDSHlh?=
 =?utf-8?B?SS9sd1FReXoxRWhPQ2JYcnpyM3RIamM4dW42UHlqVDJZNzdZaFVDOUV6NXB4?=
 =?utf-8?B?b3FhZURaY0VCdWJHcThTT1I5Tmg2UmIrbjJxaWN4cVJTVisxM3hnUmZQR0Mw?=
 =?utf-8?B?dmROd2syVDU1cVN6U2tzRW5RaFBkUGFvOVk0TVpYeFEzYzlmR1YyRi9laGJM?=
 =?utf-8?B?UDVGTGhvODIwYTU2MXNiMjRkckgremxwUDZuc2Z6TGhWbFVDT3NiZVo3TFIy?=
 =?utf-8?B?eEtBT3JIYWRzb0tmRnRsZlEwTWNjQlE0ZWN6MEg2SGYveGhJcFh2Q2x3MWYz?=
 =?utf-8?Q?bAng=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(82310400026)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2025 17:15:47.7094
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a7fbb9a2-efe0-49c1-936d-08de0820a79d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BY1PEPF0001AE17.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7308

On Fri, 10 Oct 2025 15:15:55 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.17.2 release.
> There are 26 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 12 Oct 2025 13:13:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.17.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.17:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    120 tests:	120 pass, 0 fail

Linux version:	6.17.2-rc1-g8902adbbfd36
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
