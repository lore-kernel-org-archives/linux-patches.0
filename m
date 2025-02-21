Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2045.outbound.protection.outlook.com [40.107.237.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF8B0209F23
	for <patches@lists.linux.dev>; Fri, 21 Feb 2025 11:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740138819; cv=fail; b=HIHaj3GN0spgzyztoaZfiiCxlUAfL+pIJ9V1Gd1hUh4LNDuehht4/Mf3v6lIYuM7DSAZDp/VJr3iMh3vioQ1i21Q3cbKrn2kvlnh60bEvW80lU//i+BseZD+V7ZvWQ2at0d/S09i5qGDwvg5r1a1c6Zoa390+N51CGGuYv3stFE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740138819; c=relaxed/simple;
	bh=w4342xyABx66DqCMlGseToxr1wlXpoS9SE5NJOyDEeE=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=MFHR51kS9DudTZaJe8pPXhJoj4DA4Jf+z8YxAMmwO603ujdPvGB16NmTXa2wTYU4oPuCHjXiCT/O4H0NKGBecPg+h6nA2I+zwq+XvlkqkE3EPsil3uLUFsx82GFBPiutGaWq0NhbpZT7Q+A7wnGnZxkGKi79AISAO49SkWL9cq0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=dWnoyvJU; arc=fail smtp.client-ip=40.107.237.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="dWnoyvJU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s9GvMCUtWLqOp2u8PiIP+kF3I0b4QGk83v4i1Eat5CxvTweuoeTm1tyBaQev70U0n0n6JmHZDYrZP0MHU+ZIyzf91vOxCwv7bFwjDViajiSJjBPX6lt9T4EIerMGF02cEMMRVi+HuyPyGB3r6Psg1L5LbsNyHsRfNf2tfao09q4F7BiEuNvpYvkdscrwo97H4eXyaY/EnXOnIx1R+G1pgAVXLrNASzqDN4g5S4MdpN1GL2haIuNb0R4g80DmZtavbb6B6z7XckcmK6Ou0m+BU/scOj8Yh3nA0GjbY2KCy8ZJFk/C5QuVFrRSB31CSUKVJHm2q5xoaho01FtHHy4C/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A0/VhvSWzq61QYcq7pZIF0YptZT82cgMHOsgzDg2AgU=;
 b=JtEPOMp/tdjsMp7wDAybBe8B2etWpEursbLhO5IbDNjQy05A4rW6CRmgxBBI1sGur0oWOlPH/I8NdynnalJ1NItlpmZDzSUnuOUDSgTCEJANeaW8fgN1f/Za4NFyNUxZyldNMCzoJvjw/twxlO7V0j6rFUJ5AsLUQOcIgONXDalp04UcAS0bomNijinGTRia9vqxI0t3A5ljaIs6O2sd1L+EQdHgikxfcKs1T0sGfZr5y5v7CDmRV3VKxrsn8igzoL3wjC65sfQD7gLPdM4CRTCyqMIiApkTeV4KkSdz5vGv4/99cdB/7cCtMw8onP/fIywBdgGaiCIQVtpYqMwCqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A0/VhvSWzq61QYcq7pZIF0YptZT82cgMHOsgzDg2AgU=;
 b=dWnoyvJUGGyjTdKZSkImQqv8ZazNH4vsJFTOIPMeIwgAX3JsqAwEM3GBCVcFfmvatCJWH8PoOulqwX58oLyZkXli2HwaiDnW0SlqrW3MVTxPD7ThAzcMFsqG8SWY9Z51zxJgNMIDcOaLZzbrTOWWrdCZtEllFfx5X9DkTD1WDDkUoK9KNZMEo5+CTpumBE34jHOzR5afabKtcYvmmRpodOkgRkdsDw1ehh65M0qs9/j2O2laG4Pm831yOXJQSDnPLE/hJZQ2BNztLzb3E9Boe4p86nxH+IaG3FVJ2oO+WN7yKNlQB4UUxjnj3Qeofic/p6qgJNl1Z0SFBp5GXeYS9Q==
Received: from BN0PR04CA0021.namprd04.prod.outlook.com (2603:10b6:408:ee::26)
 by SJ2PR12MB7918.namprd12.prod.outlook.com (2603:10b6:a03:4cc::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.16; Fri, 21 Feb
 2025 11:53:33 +0000
Received: from BL6PEPF00022570.namprd02.prod.outlook.com
 (2603:10b6:408:ee:cafe::69) by BN0PR04CA0021.outlook.office365.com
 (2603:10b6:408:ee::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8466.17 via Frontend Transport; Fri,
 21 Feb 2025 11:53:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL6PEPF00022570.mail.protection.outlook.com (10.167.249.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8466.11 via Frontend Transport; Fri, 21 Feb 2025 11:53:32 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 21 Feb
 2025 03:53:23 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Fri, 21 Feb
 2025 03:53:23 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Fri, 21 Feb 2025 03:53:22 -0800
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
Subject: Re: [PATCH 6.12 000/225] 6.12.16-rc2 review
In-Reply-To: <20250220104454.293283301@linuxfoundation.org>
References: <20250220104454.293283301@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <5b233f05-dc5b-4502-b022-73dde846cab2@rnnvmail204.nvidia.com>
Date: Fri, 21 Feb 2025 03:53:22 -0800
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF00022570:EE_|SJ2PR12MB7918:EE_
X-MS-Office365-Filtering-Correlation-Id: bbdd3264-db72-4488-6c31-08dd526e5db3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014|7416014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?R29NelFmWnJjRFhwdlpzdm9lQTFqQUoySzcyVWM5Ni9VUTU0QW5KMUYyMit0?=
 =?utf-8?B?d3I5bm0wUlh4eWF1QjRCNVlZK0hQUjF6SU9LRThiWTl5aURCa1JhRjZmeDdB?=
 =?utf-8?B?ZjM3NnAvVmM0N2NDS3dTdU1aLzJDRjNMRHlUNGNoM2ZDeEtjMmkyeDBpcDh0?=
 =?utf-8?B?WHdFRzdiMSt2S0NBN1NrVFRQek9aejBnSm44V0ZtRUFqbXgxWnNlZC8va0N1?=
 =?utf-8?B?bDZUaEJvWGc4ajJ3TXZaZmtDV29sZ2todjVGRVd4MjhLTzhuOXd2cThZRGRl?=
 =?utf-8?B?QktZY0FBaFp4eUhvb1F5a3gvNGw5cTVrajUzemM5RHNGZ2FpeHYvWWpuQUEv?=
 =?utf-8?B?ODFqV1VmTHcvNWpnTHhSRkRma2pHeU5wSFhZZm9VN3lUSGVKNzlQcTNGUTZJ?=
 =?utf-8?B?ZTMySEVwbGRNVUxQK0VHVVVhV2tRc2hyY1FOZGVienNwaGVCdWg1aW5RQldR?=
 =?utf-8?B?SE56V0hFWXNrSXBkMEJPcU5PYkppUGxYWmM1MzRJWUR4RFlreE9sTnB3UkFK?=
 =?utf-8?B?SVJ3SUkwc2NVK3ZpTE8xSnFxNEdlTGlUTUl2RFV6WGVLMXArSzZHb3NkK2pJ?=
 =?utf-8?B?MUtlaXU0U1BDOVp6c2h6VUZpRWpvcUE0NDl3QmlzZHZ5bERSQ01DSzJTQWVP?=
 =?utf-8?B?a2UwdzYvbEJmZXBib3V6WGdEcTUyL1hqMUxST1NwZzE5ekZVTldlMHBUYVBk?=
 =?utf-8?B?d1E3ZnpiWStEaUxTejRyZTRDVHdHQ29mOEJxS3MzQ3lDYWV3ODNhVjhNWEZh?=
 =?utf-8?B?c21zYjM5MElkL21jVE1ibW9qMGZmckkvdTVYbjhacW0yUXdOdTNWMk1rR09q?=
 =?utf-8?B?b1ZURS9nM3Npa3NtVGRQWHJtOWU1TExJbjN4Q1Z6UFNaaHZHdi9kWWlGL2Mz?=
 =?utf-8?B?N0JWRkpkS3ljdDRMcERSQ3pCa2NqVk9mTExhcVl5K0d2bDlnZUV0bWV5MjVr?=
 =?utf-8?B?TUh4WmZVeEtDQy9NUWdsZFliUXNpNE9Jb0JlQXNTQktKYjlJVzhBUHJSSnVV?=
 =?utf-8?B?ckJNNWVUdUxGbW1HY3ZCSG5HOWdQOHpDenNxSU9FM0x3MUsyUUxXcFk2cVNP?=
 =?utf-8?B?NlZKSFI4Z2hjOFFoaFVmVjFvS25vSG9HZ0dJSllUcUEyNnR3V3Q1NkJRK3Qx?=
 =?utf-8?B?N2psTFAxNTh4dUNlVzdBR2ZvUGFQTXcwUkFPQlB4T1VXQnpQelVzR1dYeHR3?=
 =?utf-8?B?YlZxRXVZM1A2OEQ5VnBGNzRrU3AzRk9TMUR6Z0RqdmN2Y29JeldLVkpta1B1?=
 =?utf-8?B?SklORzYzZVBxWjZ3bUJzWitLNVIwRTZSemc1dnlLQk9pTXJCb0lZMk94NUxs?=
 =?utf-8?B?Tld4RmNRMThDdDhGQ0QzUXdpREtpNXkzNzlKSWlUMUlXQU41eFA4ZkI2WGV0?=
 =?utf-8?B?UHNDelR5cmZXejE3NXpoangvSThadGwvdnQzSkN5QllyMS9kL2NNTW5yV21G?=
 =?utf-8?B?WkpqTTYzUzEzbmM0eEN0U3ErNlorYjdzTDRaWWhOeXI5UDQybEN1cE1ZWmI3?=
 =?utf-8?B?Tk1GdWRBRWJ1UklpZzJVZG1XWVNHUFNxd1F1dmpJcGVVK2FSZ0NOS1BLMTFB?=
 =?utf-8?B?MmlNeEtYZVEzWmQzWkdBaS9YT1BvZS9ES29KY0JYN3FBWFlweFBvUGI4UWZB?=
 =?utf-8?B?aHQzQ1FQU2tHcVVIRFAzdGxPU25NQUw4bFZQMDNiajhCS2haU2xxNlNWYWdh?=
 =?utf-8?B?cStwNnNudEZZRFNWcUIvK3FqUGFxVHZwb3kvRUh5ejltL00yWHo4MG5kdjlH?=
 =?utf-8?B?eDBveXF5OVJ5T3dMajh3VVJKRCszVDdWcFZHREk3RWtxZnZiandGNmVBLzlZ?=
 =?utf-8?B?QmVxeXN6Yy80ZmVTdnBBTlREZit0YTVFeERlTXJZMGI0RmJpSER0SG9uc215?=
 =?utf-8?B?djk1UG1ZbEl4aUR0S3gxVHdEeFVLNE9iYzZxZ2tSL3Q2RTViWUgzbUR5VlN1?=
 =?utf-8?B?ZlBXWnNnYlhtamdRZ1VIT0dNdC9vbTNmSVBwUU1nZHg0dGpuejdXemVOTHJy?=
 =?utf-8?Q?0NXun43238W2YyX61ik6DlZvCg+9g0=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014)(7416014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2025 11:53:32.6835
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bbdd3264-db72-4488-6c31-08dd526e5db3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00022570.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7918

On Thu, 20 Feb 2025 11:58:09 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.16 release.
> There are 225 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 Feb 2025 10:44:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.16-rc2.gz
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
    26 boots:	26 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.12.16-rc2-gc3d6b353438e
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
