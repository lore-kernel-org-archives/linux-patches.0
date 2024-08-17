Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2043.outbound.protection.outlook.com [40.107.102.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 852FDC153
	for <patches@lists.linux.dev>; Sat, 17 Aug 2024 19:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723924132; cv=fail; b=cofyJBeJHoB75L5XpHrtaVG6CJJpmoWEGzXR1ok9T/N+Mmf7FjbLPxUFJRdrzI6f9HbC2yVsHb7KrQPPjsCiG9zAA0mmf/H8KgFmVn+nY6UN2bFa7ASLvMZ+mNTvsx7KlwsiYjQcvink7gG2PrGx61H1PNFCgpiLNdc0p58/jiI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723924132; c=relaxed/simple;
	bh=xhz3O+ipunDV3PBf/LlWbPfn2dKaodveTwVgbnJ69tA=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=TXO7AtHzxIXOSnd1ZYtZrK8ID18oFmlFlfbttRrFqrTslotLFQnOyzDpr/NVLTCQRUeyWB3omAXcDSqzYRW2Z7ccQuFyi3LKeY3dOMQq26N3a/9rPe/fnBAouM+z09fG5+hH303KU3+B63ewsfo75+AMlb6EVHfy2uNb4nksWxA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Y3MJHhGQ; arc=fail smtp.client-ip=40.107.102.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Y3MJHhGQ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EKxdUfWcZbKydg8BGZPIEOJsQMU7wQkiDJYlI34FXF7fmI2yzppTPIE914madWRMrgx45vVA55OuY0rfZwT8DZUqj9420B5I88l+/Yj+KMnGDmDl0TQacoUnQHDi5LShtnfPbVMruBeVwI0bST3H5HmAPjGIPHyq3GyRYUwl/AAO8R1NMm1uRAz3iX4KBODE85wXR6qZTLMJ4tkvl0vfMUZIqk10eo0iBYCG6F9GQelxqtb+FHmZ6r/2Pns1LwkPIsOLV+5a/gQpFIhbXs1UijJmkjeQ6/oHyrBnx5QbEP4Y+VFksl0PnnkEdbmBpi6+6RonLr/v7aWOb7nb0xhj2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RQaRb2SIjhLzM5q7a9LZNUGcAL32NRDNE5g+7Ejdt7E=;
 b=p94adZTyGyqFPMyLf73E4y2FGR/spmLguPxNIUx+EUfJ0UXkuzHHuWCUxv6pkfyOzJYOyumvqxjURMruvLsAYhNzRmSVm3cFhQTrg+MiR0iM5zXWIGSfk/p3W0NlPhkQG1dzzAsCX+RcKle03B9yFppOHF2yuXflakgcnDAyi+JPZWCPXyTgHHrqO1jDg4NPqqBg9lpR8405HLj5OGe6KAOR40yKE7yr6Uz4VaIJKXZjOBi4MzLakKqQLMXWpFOgN/Nk3z6JFO55pKZCJmBBSwODQ8T9sCJWqzuO4MYt9MHDrpjheJQMb0qNR6/cEcdKkSG7GgQdH7a0gLE1Xved/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RQaRb2SIjhLzM5q7a9LZNUGcAL32NRDNE5g+7Ejdt7E=;
 b=Y3MJHhGQ1PxxN9TBs/ORqMimdhwaWVKYQxYGpBk1GedW119i8eKXJlHLiv1xULHvCKrLyCKqB75k8DgILbZ3EVK23t48DzR8/mYBb2wuTp7fOnQvWzgG0Pd6Z+/tlOCZa0n85iKzflH6+tl1o4UAGCOm27QJEMB7Mu9FxEeSPbFB6H3YBhbpUkl5ncV63ES9PABvhSQKYQmEt3QSNnJNVfQQt7zAWqwCSX8PWzzaIiPF3p68rxGKSj0AznoDK2QPp6h5XvsBZCG27eT1cy1YKSYq5wkccNQUwNd1dJ8mgAlOWUfHL/akIQwN06kp4pPabCU/VDvQD30nV14acbiUqA==
Received: from BN0PR04CA0172.namprd04.prod.outlook.com (2603:10b6:408:eb::27)
 by CH3PR12MB9100.namprd12.prod.outlook.com (2603:10b6:610:1a8::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.21; Sat, 17 Aug
 2024 19:48:43 +0000
Received: from MN1PEPF0000F0DE.namprd04.prod.outlook.com
 (2603:10b6:408:eb:cafe::f2) by BN0PR04CA0172.outlook.office365.com
 (2603:10b6:408:eb::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.21 via Frontend
 Transport; Sat, 17 Aug 2024 19:48:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MN1PEPF0000F0DE.mail.protection.outlook.com (10.167.242.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7897.11 via Frontend Transport; Sat, 17 Aug 2024 19:48:42 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sat, 17 Aug
 2024 12:48:36 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sat, 17 Aug
 2024 12:48:36 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Sat, 17 Aug 2024 12:48:35 -0700
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
Subject: Re: [PATCH 5.15 000/479] 5.15.165-rc3 review
In-Reply-To: <20240817075228.220424500@linuxfoundation.org>
References: <20240817075228.220424500@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <91c7ae73-72fe-407a-9d51-a37141e7b681@rnnvmail203.nvidia.com>
Date: Sat, 17 Aug 2024 12:48:35 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0DE:EE_|CH3PR12MB9100:EE_
X-MS-Office365-Filtering-Correlation-Id: 54531590-35b8-4407-7ba4-08dcbef5995e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?enBFMUhDb3Ayb3QrNnZldk5YRUlBWUVqV3dwTEs0T2l4b2hOZW1HNTYxOVdv?=
 =?utf-8?B?bGxaUWxUc29QaVpndkdsczNpelI0dXBjZ1F2MFhXeElXMjdiWjlDM3VCRDY3?=
 =?utf-8?B?cEtYRldKTGdVaFAzS2wvSVdLM2dQNTZ4UHl1K1hDTlY3T2F4OHZqZElWaEZu?=
 =?utf-8?B?WDVrSGxwdU5oN3NFT25tOUltQThYQzhiNkZKdGZhb1FtMGRvMUxHSVNiZTF3?=
 =?utf-8?B?cTJzaTNLdmJtdVVXNjY3N2lpcVdBYTNsYjc0bkxaeDlnTFJ0OWNuS3hucGdD?=
 =?utf-8?B?NXBUajFQL0x6YUxab2RxSDZIbjVtMDNVbWdZYmFtR2NtWEc5TEFCNlMrOUE3?=
 =?utf-8?B?dEFFTmJqNnAvcjVQOUx0K0krOUdNYzFsS2E5cDZGbVhSQ3YxR2tEMm9ERW95?=
 =?utf-8?B?MHRrY2FiVEp2SUpxam9ldmg4R1ZJZnVpcGZvTWMrOU44NVdsMHNrYS9JQ2ov?=
 =?utf-8?B?bFViYnlES2phTy9uRTQ0WTU0TDNyZkduSWV6a2dIekl2M3NLaEg5SzVaNXdU?=
 =?utf-8?B?MHpDRC9CRjFjTnM5K1FSY2FuYXFYM3YwQjRNbXhUeDY3QmtBV3FxbXVsN0hM?=
 =?utf-8?B?aUJFblJiUmNZc09RWVNvM1F3eUVjdDlRYVFzVU5lOWVjZDJXaFlaVm1VM1Jn?=
 =?utf-8?B?VVpBNnBnWGNwS1FRc0pKRENBdllCR1ZkbmdWTEhOOVZWVkpEZHhub0Z0MUhu?=
 =?utf-8?B?OTJnR2Z3RWZ0UXNWOENNV3dtMk41RlZrTkovZjBnaXlCYmxkQXkrMzc0MXdu?=
 =?utf-8?B?SVlKaWRqV1RyYWlXVlE0a0FuWVFLV0hmL25PVDBPOFVqU1JPSUx1a2tneUxY?=
 =?utf-8?B?MG1iRUlQS0pCVG12TDZ0eHJXS1J1eUROZXl4OHhlVWJFNHFXbHhBbWxOVmlN?=
 =?utf-8?B?bG9DdXRCOE8xRkxOd2VlQTBVbjhxaTlRbndpejBYdldVK25lZmNwRmw0UFNE?=
 =?utf-8?B?c014NmJsM0FTQjl4UW9ZblFZdjk3dUdreU1OTFU0dnpPSUtEK3NtQ0pUQitX?=
 =?utf-8?B?M0Z2QVc1djB4WjYwYzhiQ0FRcFNKRnh4TkMwTUNNZTNKUDEyYlJ0NnNPc2sy?=
 =?utf-8?B?cXVRZFNYK1paaHQvcXNLck01ck40QlBBaDBQbEJxZE1IZ2tpemo2MVI1Z2RN?=
 =?utf-8?B?M245OUJ3WStGdFIrWHFVTHN1d0t4YS9zbGU2TUhoVFh3MVNJTElad1M1enFX?=
 =?utf-8?B?ZkthVVpFU2V3UjlyL1BIV1cwN1hFc2F1SlhqelRmMkJ5R0crQjgzUi9yVitn?=
 =?utf-8?B?RGsyNU0zNHFUSEtlREtUT1Zwa0kzUzhWajhaVTZpYnkrZm9MenFKcEFKV0c4?=
 =?utf-8?B?dnBORUJsbTRpTkt3eGFBK0htUHFDREN5SVZPNlh4UVZmcG1GR1o1TUlqeGx3?=
 =?utf-8?B?UDJLZkFQaDdxMFJoZzA3NTFwcEZqc3JoU2l1WmRxbDJwWHdlN1VUbnl3ZTF2?=
 =?utf-8?B?KzZYT0tzZzdKRGlxZVEzT3IrN3dNcVoxSm1EVmxiek53VE85eTJYS3RwWDFq?=
 =?utf-8?B?b2FVMVRqRFBjQm5UQmNBY1A0czBNOW5YUndkMHJEdUVpb2l2QXF4SldoVjRO?=
 =?utf-8?B?VmpjTEhkSk9DZjNtcnRCOUQ3UEQrM2w2U2MvUmZBTHg1SW1VSStHZEZSS01m?=
 =?utf-8?B?YTNlZERSVDZOd3Y3eVJqYTVZVHZ5dERFZVpGS0pHM2FMZkVNalRqZUFjK2do?=
 =?utf-8?B?QXk4aVArSWVtNkZVREZQUkRhcDZ0OWdHTjFWaHdkNWpUR3BPaHErOStxdjFo?=
 =?utf-8?B?TitPaDkvbGYrWWZBZmEzb2NGL01LT2o4Q3JkOFY5ZlEvKzd2WDFZc01PUHVv?=
 =?utf-8?B?YnFzNEZDSHY3TUpNUHZYenR1NGZoVmF6REdNTGhGekd6OGxmTUJ5MHV6b2lI?=
 =?utf-8?B?NFhZbm13T3VFZjYvRTFoRlhHSXdydXlaVHB0cGhacEFaTk1uMS91cTZCYUx5?=
 =?utf-8?Q?qDG69zzM5ZSfj1RPADy0bvv1vVG9Lamu?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2024 19:48:42.7263
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 54531590-35b8-4407-7ba4-08dcbef5995e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0DE.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9100

On Sat, 17 Aug 2024 10:00:38 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.165 release.
> There are 479 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 19 Aug 2024 07:51:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.165-rc3.gz
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

Linux version:	5.15.165-rc3-g2a66d0cb3772
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
