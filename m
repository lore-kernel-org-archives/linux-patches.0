Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2048.outbound.protection.outlook.com [40.107.243.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A26781DFDA2
	for <patches@lists.linux.dev>; Wed, 19 Feb 2025 13:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739970676; cv=fail; b=HUXZYJYZps6INyoP7NKJO5hpvvnBlsALH/YMDN8ZkV72zMUR78euwiPfL3mtZ7IsfDwiGxzvgCrYAwaZgNkwlAJlFzk9wZxccqu2nNiZkZDVlip+BPbmLqz3pmrANc3pQtTcfhh0B1hsCD+bYwpnu+1flel9yvYjv2t8xWuIGYY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739970676; c=relaxed/simple;
	bh=qeXoBi0YbUNeRXOKvbsVUMoDz7zrcFhng1B4tGWEKzQ=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=HJi/FBosJ17mAyDwhHOaz87Jj98BFMNKGDkRZZxdGRqlahBYre8FOPM+cvk+Y1R0r+6qSBGqjt/QV7ln8d+/DJSKkb2uyNsitl6Pu0LXJ77aCkd0myEy4yU80dORGkvtV0Er0iZIyKZSCoQeVuDwJPen7JBm7rzLVxR/bCFGgdE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=UFVnkmnc; arc=fail smtp.client-ip=40.107.243.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="UFVnkmnc"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KeVhuluf17Uqi1SJKUCzVnVx4yn5evU8/o/FhWqOTkV35IINgA3gbP+nRi7c3w+NYZvbPDBT4xRyun6npxW2IcvEd5SqdQkyXgcNKCbqmtnzBukH1/7G2eI+iwURR8hLO/PUfB40jb9O8Ov0kmkib7pF6u7N/jxYl6EUs7cwR13vnNqnJuER/JyjsBKlwOfEdFbPFFvIZRETt3sc2WHs49jzpE90ceUFp8TTDOttnYP7GArQjIlcTxRN3rHPbi2yiPnxUOdab3tbw0T8PIC7NrTiJaClpoxz19IuNaQg5RxQ2EZboZM4jHRbXYtUn+3pMtgeOqADhgrdAi1aciO6QQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NnBgSzlIc4zqeGBwk7xLXpbOuZeYe5KXosdJH9/PeAA=;
 b=QBeFnZeEncy0UmgVGp6OEVc6iP6a//46FQT8Z9SzWNnNIxZBkxZusWXKF3vaoHlkRRrONOHTUwjX8BVe1MTdsEXE3KrjlpCpxQIWaMXJBhlykEu9pyfyrI+aLXB0qpagafCWAzffQDk4kxOjuJUbc12XgPBw8ySneDWIJ/nr1eWd4NvFM4gA8bc6XYz3Gqf69nnAzJvRXrk5v1Peo5WgtvZwlNZ2bFDF00kOFFboRmsTLvXgX6r9XaLrGp7Hs77sCGFMddbTdUYeGeiOgjWeQ4uKo9rlJ0sYNhN3h7dugC8jSnYX6RfgSo1RmVnyqjcRYGnomr+ibp6Lpvsl5avDlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NnBgSzlIc4zqeGBwk7xLXpbOuZeYe5KXosdJH9/PeAA=;
 b=UFVnkmncMKw67s+I02p7uvCT0EFsiNYLIlZDMm+eJF2vSvFH7j2FcbLAi7ivoo1HmMs14hXHT58wkdPkl39uinbZlPL2E3M/5dyENuvyoaMH/CpUAKi8CNuhMPsmZo5qQ6TH2IQlyQ9bCnbqoaUMZERjXG9FyisfJvW1EhIPZwe9K6JLjsDOr0yzrVpYeNXFIffvHs86TsMGU/qwgwqJLcPKBrUJdA6oHbtx7hfzA2kgiqvj4kIJzkI3bybkKGvjY+WLLSrlGaFio92lqAQrEZq2E9+o4l7RaYxGZSycH2BCI85uerBczKFm5zVAevvOLAVm/NdcryYqCrRe96owSQ==
Received: from BN8PR12CA0011.namprd12.prod.outlook.com (2603:10b6:408:60::24)
 by DM6PR12MB4074.namprd12.prod.outlook.com (2603:10b6:5:218::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.19; Wed, 19 Feb
 2025 13:11:11 +0000
Received: from MN1PEPF0000F0E5.namprd04.prod.outlook.com
 (2603:10b6:408:60:cafe::9b) by BN8PR12CA0011.outlook.office365.com
 (2603:10b6:408:60::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8466.15 via Frontend Transport; Wed,
 19 Feb 2025 13:11:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 MN1PEPF0000F0E5.mail.protection.outlook.com (10.167.242.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8466.11 via Frontend Transport; Wed, 19 Feb 2025 13:11:11 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 19 Feb
 2025 05:10:52 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 19 Feb
 2025 05:10:51 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 19 Feb 2025 05:10:51 -0800
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
Subject: Re: [PATCH 6.12 000/230] 6.12.16-rc1 review
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <b5a72621-a76a-41a1-a415-5ab1cabf0108@rnnvmail201.nvidia.com>
Date: Wed, 19 Feb 2025 05:10:51 -0800
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E5:EE_|DM6PR12MB4074:EE_
X-MS-Office365-Filtering-Correlation-Id: 69f517fb-5923-4d50-d4ee-08dd50e6e1bb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZGlZSFRFTmkyZW1yNVFIN0FPUkRJUWpTTXJsRWVoR0JKWHJaYmltbXRWdFN1?=
 =?utf-8?B?OUN6bHNXYkxNQ2xSWEUzTTU3OVc2N1E0ckU5UHJWc3lBM0tpQ1FLSFhEYm9n?=
 =?utf-8?B?VklDMFgySWRmczV0eWwwQXA4RHVMNXBkOXo2bHlMalFoYUNiZk5JcWtSTmsv?=
 =?utf-8?B?UjFIOGgyMHdLOWx1U2kzeGJzTFZXZlZrY0M1SklkdU1MUE9TTmVDQ1lHRVBY?=
 =?utf-8?B?TDRBWk1hWDdQMlF1Qm96TDdmN2grNCt0L1lKcTZJZ3pNMEp3N2VMVU0vazlV?=
 =?utf-8?B?aGgvdm1HZmVVZWZ6VkJrUDk2clpnanFqdjlpOWZXcjZDczVxY2J0UDUvVE5w?=
 =?utf-8?B?SEdscjVIcVEvR1ltNmlHVFJFT2Z1bzBpbzh5cWZqNVBMYi9wZXZrODMrMjBC?=
 =?utf-8?B?dFdRVjB6MFYrQ2dEeTZhNkJpejc2VjBnbzhGUFM2bzBsVFd4Q3ZHd053ZEph?=
 =?utf-8?B?Q0dLSXE2K1NiZ3VpL1IrV3ZhaEtJWFRjWjhVQnZGbmxETTVodTRab3hBa2pH?=
 =?utf-8?B?R1dabjc2MUVHczNqM1hmcjU0alVxSkIzaitXZmk0TitCZ2dQT1VKcFU4TEVh?=
 =?utf-8?B?TmJicnJPQ2JVK1Nac1g1clc4WVVHTmVtY1p1d1I3TEVJZ0NLMklITkRidnN2?=
 =?utf-8?B?NzlhKzNOdXZaaEVJemt1K0hZWHlEbTRwSW5PcUYzMUNNUGFaU3BLVkRIVWhY?=
 =?utf-8?B?bmltTm8ranRiME5WYWxWTjNqMHdaQzRxck4xMGlydmRCMzJWVXB6L2tmdmxh?=
 =?utf-8?B?bFNycnMxYlF3Q0pQTHprNUxwL2M5VnhrYmxGYUVBVjVBdk80TWkrdTdqZXpQ?=
 =?utf-8?B?OUNLbjVwaDEvMHpuRjJ2QkxSa0I1UHZkdUxiM3ptYmM3S1VqMG5lRnlnUkpZ?=
 =?utf-8?B?cXVOUGt0T2JVMkx1Y0NUMFdmL3llUjVUKzgrRHg0S1Z4bE9jZDJnZkg1SlUr?=
 =?utf-8?B?NjBtMVdmTFltRFhlUHBOQVRpVGdvYk9zZkJUd2ppTE5PM0FIcVlPb2hvTnh5?=
 =?utf-8?B?ZTJOVGQxM3U0QlJPU0o1WUFxaWhNMytRY3JRM2NGREhucHpscWk5bDZtQWo0?=
 =?utf-8?B?MFZTMlZuNjNQajlOcUVJNS84c1F0Vm1uZjB2Ti9jOGJNWDdFZ2FCWTMzRlhv?=
 =?utf-8?B?bmJBOE5vZThqQWJTcGtvOG9nUmFmMXpST2JnZWJIemZ4MWZCMDNYZUgwaU9O?=
 =?utf-8?B?SGEzQmQ3QlRHS3A0YmtmR2xSc2lJVmo3OGhqOWlEdkNZdTladjRMWXh3WGdn?=
 =?utf-8?B?SCtHWjVFRk9xd0kxaXlJS1YzRHFlN2hHMlJFbGdnY1ZXS2IyaDhIeTVJZWdX?=
 =?utf-8?B?OUl2NjRZVlZnNStjUmx1MXVZbS9Wd0tnK0tQK3BRV3R6bmxCcE9MNDFuVlpN?=
 =?utf-8?B?NlpBSUdBTS9tdjhqOGVCZWJ3ZkZKK3JjcVUxbmlBRHhiZGErc2d2Vm42SWpL?=
 =?utf-8?B?SW5XT2pyU0xISTRic3A2K3REeS9KWXMrbUJNYkt3ZXhFSElIUkg4MStEeUtl?=
 =?utf-8?B?SUFOb2VrYnJsb1BLVjdWSTFXWE9NaDkycXRpTVZIWjhZK2ZLQTUwbnIvaTQr?=
 =?utf-8?B?MFl5anZScnpBT3dTOHhGRHhVYWU0dmJoZkRXUGhtQzd5UnNycm5adXJnQTlQ?=
 =?utf-8?B?d3krVDh6SWYwM25IOUJXOTZyT0huVE94NWJWR0FlV05OZS9NZlJPWFA4dlQ2?=
 =?utf-8?B?SkVWOTRBTGVTYXUyYkFETk5ISWJzT3loc2hmbEhwYzBWTThZQ1dEOHBPZjZL?=
 =?utf-8?B?dTF1YmtTdytKSDU4aTJEYnRLRWcxaDNzU29DSHp2VE92SDI4eUQ1T3ZRSkRU?=
 =?utf-8?B?ekVUbnYwS0pDUVJIcGdmZVBRK1FzZHhyVVVCWjY5LzVNd2ZjZUpYRmhKaTFs?=
 =?utf-8?B?blFPSFF4dUVKdytWWEJDR2VZbWpPNUxJN1JjaGc0ekptNHllWUJ4L3NYL2dT?=
 =?utf-8?B?cEVuWitYQWlDSVd3bkJHallLZnpZeVpkWFRzT0psMENVQXgyMDVkODc5SHdK?=
 =?utf-8?Q?XRraBFtqm5nc1b3gc3iWe6TmdlI884=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2025 13:11:11.4486
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 69f517fb-5923-4d50-d4ee-08dd50e6e1bb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E5.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4074

On Wed, 19 Feb 2025 09:25:17 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.16 release.
> There are 230 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 21 Feb 2025 08:25:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.16-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Failures detected for Tegra ...

Test results for stable-v6.12:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    116 tests:	115 pass, 1 fail

Linux version:	6.12.16-rc1-gcf505a9aecb7
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Test failures:	tegra186-p2771-0000: pm-system-suspend.sh


Jon
