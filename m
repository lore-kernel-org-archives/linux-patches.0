Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2067.outbound.protection.outlook.com [40.107.243.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A58811D63CD
	for <patches@lists.linux.dev>; Fri, 15 Nov 2024 18:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731694143; cv=fail; b=tLDlH6VDlshU7qqvd1SexTXmAhD2GsgPnXotbTGCnSd+SqU1iaJm/IMh4zUQqjkTOXkMyZogZ9luIneLLlbOp9/mMm9weSaf0j/lHquohRb4NF++zOHiyA3Fvt0Ej7eYhsvMWY4Wb3b0jU278wgEHmKk2+/N0muQeLMkBmN+Z6s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731694143; c=relaxed/simple;
	bh=A49DNd0ZgvMpnTXIPaIzZifXfRDfmc110PQKoBhQso4=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=boixynr2Dm5d6Sem7+ZXyMCst1MJyJmb9Ir1XTKeW38QEFFPUoJSiwW1Y2y/Z05ymJZ30TENHnEqFJJIQHznraS7l5t/qTRnuea6x+7NexoK5FcWOmchLDe0oVBEzshL6ICQ4NIbtA/TETWDliMVVV02fZdh+7tD03wLdXwJfMs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hqO1zqCv; arc=fail smtp.client-ip=40.107.243.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hqO1zqCv"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BKbf4+IothuF2LZLsTwGrUJyNWSXGL/FzHRSRgHKwkYcLJfn3IqzWWU1L7KRxfLWKNF9gAQRGGvrxbK2XgDgcJPf5wxA8A816c5oJ9st/UnHTzp/VeGnHQkj15x0d0sGyNQfv2LVc0RkV/fdfiVNFqFQ2QAvcPA09ySX40rzpsn1yyjx3TYLsik16LriLl4o/xmeMdYQDnLCowLfjVu7waAgKBijSz62NxfY0jhi3bKmx8Nt1oOcF+AkQPS3W3qNg5UjbVnb028PmHTpslFb3/viI7SVtDUVfHmubv2eJiYeux5Ml9kKKShQ6h+FZLLF1r/ohwfgR8I6LxCPEjcH9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6kRE6olA4n4PU1pBCC+KEcn2FIVt6AeXqbxM9o3VF3k=;
 b=vAODPb22XyGbNSubW2XW9WuymzBR2mb2eAYUVSJF05Xlg5o3p3jQw7HHMxxeOp5KQUk5pwmOM9KaOQ2j2v5B3Ad4DtCTLEwtT3xJIrp65kMO8dD3MmXWypljoLlCsRVNHPkNIqjcRt4XF01WrzXPQ4Bg+vaUMbCD165/6wbl+HWO4AFw4jnzO9Izh4Tvipe2QdnrRfpQFKHNN+BG3KCL1yhngtN2OmbZ8U36fPUlI+0E5LQ5UPVG133rVljbmmd8qpzG6wh0tMUBrNBJq1fQwUj1SaQVsT2bN5f2X7ik0sLGvkTMOHuFPtvTtySKHr1sX1joZbXcWlK82Qe1IMdXzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6kRE6olA4n4PU1pBCC+KEcn2FIVt6AeXqbxM9o3VF3k=;
 b=hqO1zqCv1fQR81jzalk/eogk80DlCEWCKG5QeVvJ8gVqxAVQviuIiTl98oURwf3rqjm63odTSIWrhcnuVmUnuRKWIjZp4tAEQ5uMebXZmgmUHwEhqtKGDYpvGmvk5SYEmaseEQdEvbUjRH5lXKJKKQo9m+DQQxsFw8OKbZhhlQWSEHFUQUG7kH3NI+CxiRQyQgXrMTg6KT5CzFG67g9ueZdXxDiKFd6AUPB/60wV1m6hJPuWr0DPhZztaNIoW9pR7cDkw1Gs3hbmXGPK6cIPl/zN+3JbSKyL8T1cOCkEiHJ4cle5M2wXp7UXoQdwOgnvTh8PEqZvVH6BkOmk1oGqkw==
Received: from SJ0PR03CA0187.namprd03.prod.outlook.com (2603:10b6:a03:2ef::12)
 by MN0PR12MB6077.namprd12.prod.outlook.com (2603:10b6:208:3cb::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.17; Fri, 15 Nov
 2024 18:08:57 +0000
Received: from SJ5PEPF000001C8.namprd05.prod.outlook.com
 (2603:10b6:a03:2ef:cafe::a5) by SJ0PR03CA0187.outlook.office365.com
 (2603:10b6:a03:2ef::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.17 via Frontend
 Transport; Fri, 15 Nov 2024 18:08:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SJ5PEPF000001C8.mail.protection.outlook.com (10.167.242.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8158.14 via Frontend Transport; Fri, 15 Nov 2024 18:08:53 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 15 Nov
 2024 10:08:40 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Fri, 15 Nov 2024 10:08:39 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Fri, 15 Nov 2024 10:08:39 -0800
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
Subject: Re: [PATCH 5.10 00/82] 5.10.230-rc1 review
In-Reply-To: <20241115063725.561151311@linuxfoundation.org>
References: <20241115063725.561151311@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <ffff0709-99d5-4a68-a451-8671397baf8c@drhqmail203.nvidia.com>
Date: Fri, 15 Nov 2024 10:08:39 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001C8:EE_|MN0PR12MB6077:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ea7013f-9cf2-4fbe-a63e-08dd05a09086
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|7416014|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OGhiSzdwRUQ2TDdUMEJmRDFSVHlwV2tmcWwwRG04R3h5cHFEQVpNLzgyVUt1?=
 =?utf-8?B?QTlWaTJDai9LMUJPd0w2UmxKZDlYK0dacDkydlB5WTc3a2VnMHdsdGs4dTBX?=
 =?utf-8?B?RFRQbmlVR2dMcE9iMDM5b0tlVS9qc1EwWWdqQnpoVFdUejF5MVpJVnI3bWRU?=
 =?utf-8?B?dXk5dWlCMm5oN2liSVBFb04vb05aOElwUnpQWjY4ajNRNnVxOHFpOWJQN1Bn?=
 =?utf-8?B?K2FjaTFIU1hFYndRV3I1amQzdVJ2Y05VV09sYVBURHFaY0gzSHZQSnZhMG84?=
 =?utf-8?B?a1RQNXZsQ0Q2RC9JOGZRNFBzaWJZUEpqbHRBczZZUHI1ZjZXSTUvVE5STmxq?=
 =?utf-8?B?aGdCU2xsVVJuTVBBT291elF4RDZFQ0lZTDcveHUrSGhueVRqM3l2Sng4bkx6?=
 =?utf-8?B?QkU0enRTQkYra05EeVB0NGpwMHJUTUc0L2pJRmpXTEpESEZSOVBNTDN6UmRM?=
 =?utf-8?B?WTl2dzBIQjNsdlVYVzROTlIrSVZzNEZjOWxtTFJ3ZWNJL0dVZXRxdHFjZVN6?=
 =?utf-8?B?cXhleHRQZWxGVWplTWVIZUZQbGg1RGZLMi83L0dHZzcxaksvaVdYa2NZazdQ?=
 =?utf-8?B?RytSdGlwSlNxNTFHeTRDdE9JS29vVktpWmxQeTNDclpTN3E0VEVNblRNMDNY?=
 =?utf-8?B?dWVpUFR0dUZGa3lBRkJBWmJjeHV6YnlYd0IrY0tBTml2YTMxdjEzZlUxNkVt?=
 =?utf-8?B?bThrK3FWNm5XRTJaOW9Cc0FWYTN3TzhYOWcwdlBIS0VZT01iR3Zpa0Y4WWdR?=
 =?utf-8?B?TTNYVDVJcGxHekhEY0FNbnlrMFkvOW1PZ21hZ1VVMXAxb05sQmhuWVJGVkNz?=
 =?utf-8?B?RWpaWmlqc2R5Y2tBUGs4N2ROby9wUi82RElOSmhGUERWa0dFTitlNmp2MkR4?=
 =?utf-8?B?eWFrclMwMWhLeFFOVG9ZZDJQZ0R3RjcrbUtRWDFOWFRrTXBheU13TkV4Y3NH?=
 =?utf-8?B?RGNJcVpUU0hSdlRFSHlQa0dlZ1V6WmhQaWdmSE0wTUMvY0NzREZFbEVSaTBx?=
 =?utf-8?B?K1hzNWFHL2ZlRWxLZzhzUmV1WndCWVZFdzNlQ0RGTVhMRUxKQ3V4Q0xEUzJT?=
 =?utf-8?B?MkZCQXJ1VVZIakhVNi9uVXl3dmgwWE1OSVMyeW0wV1RxVTJqZUlYODRpSnE3?=
 =?utf-8?B?U1lndVBjMWY3bElzeEpObXdHeGR5SjZzUUxYZGhMd3pnMUpLQzRRM1E3MUNv?=
 =?utf-8?B?Uy9DNGl3U1ZmellQUWVVM0lxRTRudHNUMXdjbjZoeis5TU9qZmtvR1JpVHFl?=
 =?utf-8?B?b0NzTlRTQ1Eyd0ZFbUhKWUpBZUlGVk1sWnRZWGNUbDJOZi8vZGNqU2ZXbm1q?=
 =?utf-8?B?MStCMnRxaDZOYUF1WmhIWGJleWJBZlZPOXRkMmI1YzhzdnV2K2hoNnk5Tmgx?=
 =?utf-8?B?MWlDMVduMnAzYml0ZHl4dFJpTUJPRm5yTCs1cEp4aVVvWjlBNVF3Wmc4NTZE?=
 =?utf-8?B?Zm1valhKT0k1ZTNtcHFnTTYzUHNxaEhMQlJJOWlMTU9sZjMzZklVK0p2YzY4?=
 =?utf-8?B?TGNqZVBHakE5S2ZzbFBHS1V3R0FIUnB3bk4wN2lCM3VkbTI4U2tkbWY2Sis4?=
 =?utf-8?B?dEZtcDhScHE5UDRqVmtqdElFNE5WQTZNc2MxZ1ZNRFFGcWE0aHNBMXNuZWdh?=
 =?utf-8?B?bTY1aDIxWnpSbDh6V2V4Mm90M0x3UVFhRGFVUXhpMFRYc3FjZ3dKbGdzRW1q?=
 =?utf-8?B?cFplaHQyRTdUd1hhS2dhSlYvNmh1QzdtQ3FhYlhVdXl3Y21ZTklwcXcwWTNi?=
 =?utf-8?B?byt6cGtzMHlINVErT256UzBhQVBuQllJT2x6akdLVjdWZUVFZGpCSlRsZS96?=
 =?utf-8?B?cWNROGV0VVNVSk9EcEZWS2RYNHgzaUpnU0VqTTEvZDVsUDIrU3dnQ0N1Y1dZ?=
 =?utf-8?B?U2pSVzljS09OWjVxd0hnaVAyUWpWR1Y4dkRqL1dpeDJ5RVE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(7416014)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2024 18:08:53.3815
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ea7013f-9cf2-4fbe-a63e-08dd05a09086
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001C8.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6077

On Fri, 15 Nov 2024 07:37:37 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.230 release.
> There are 82 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 17 Nov 2024 06:37:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.230-rc1.gz
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

Linux version:	5.10.230-rc1-gd7359abfa20d
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
