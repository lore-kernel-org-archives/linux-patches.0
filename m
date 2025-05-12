Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2083.outbound.protection.outlook.com [40.107.212.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17903298CDA
	for <patches@lists.linux.dev>; Mon, 12 May 2025 20:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747083430; cv=fail; b=VYH8zEFLtnLWOGMpYyYKwEyXElLyBYtf3hhXXCmbBX7flh6tkGYr8lKF09ZGPASrKLbhe4z9LAj13L+VG6CxJhvE5seV0v2F+x40IwE2ZEYwuGAffop4hXH/OO6CDtB3bsZ5ibDfi5alx8Os3bhJR9/ie0mO2tk6OWS46f4bwf8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747083430; c=relaxed/simple;
	bh=Ceo78lZQghGpDe7MYln/pbzOTA3GAI1KhFkQcf1w5ik=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=UUZI6sY2xGZYk7Cpr5QSw92wuwoNXeZGjopS7Pt4Zozwlk6DE1oUJz8Ic0IWMC/KeG9WUzzfxQcmn7KrkCDYDxQFLyVjPXMYxBh5bNsGx9UyrVLCKDo+Ym0rraF/6T8x0t9sDm+K98Gt7DgkBjjut/K68M+gc1LLOKJajNLmB+Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nYkPh9Ly; arc=fail smtp.client-ip=40.107.212.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nYkPh9Ly"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uuXBmgC7MQ35nnvYJ16N5yBRk+lABruxWsKgBc9cholLcjF4vxFexOBtnkPJYrgbguZH2sSuRjLcevH0pD2p3fbUebvyMKhC2ltRuiPnD6oOCzhlTasaIfyzrLLcgqI0D/wzRiQvc1k7he6FekDQ/r0PbpT8b8nP+/BfsgGOPavAkKqZ5cJOOrhUebTJIiUZi9FuQh2KvX0PVXE1WqQsvjOPyNXVa6DdCJufXp7CcuS/H6Hw/8llztKupE7+ye09E78YYXADfjqZAifwO/9ejfre1NhqkJ7YUtdONNqPBqxkRCurt6GWwF28C+Nv74mZAsxdVtgscmo9k3uNPCur7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cJu8qaVBJrxOWnrqdlB0GSG4ZB8/lTPuE2noHuW7oas=;
 b=Rdfgt+e+BzCLoNjKhGkiKd9p4fAr+ex3poWXEzI7Vbw75Blv1T4TEGKk6KgMS2Do9wEM4XmdIAZgGEqqLFUaXSX6bn0+lwAjwU9tGjpC4VDhxT7oSabe+1LZ1rsrdVcOYzW8eHK7Pl8LTTkGO4DtmJF+iuvmucywv9kCch6tZ7ULhkJYWYVkMQ2kS6e0enfHu2xL+bJFKDfd80tOL7r/SIdgQ8oO5e6IpU33hRKQEZWAFKnbK9SXruKWzoYBZseOUcW1qpQuC+Imf45VLYJYHlMyTfGaTh/zapW533lWxKqi62lupBmTtkqw9vhpzj7SnoK0aFLlK40T+zvd3OU8ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cJu8qaVBJrxOWnrqdlB0GSG4ZB8/lTPuE2noHuW7oas=;
 b=nYkPh9LycMB1rcA/thzf20yxi3ErRx//eZoB4Lv5P7x3U/3YB0Dv8Gw/0Wwxl2myL0ObkBRwUUDAnDWg5vvtxoFUmLiLzGAlBFlLUCtBHmdgJyRRLm7mBniNM5XUdslAD/iRK1IDLn7WekoxJGSLi5F02zjHbwsvyZyVxzzv+wpzAW1zKc9XRl0VNllHanuUuJcedVHrVLad3wA+a/3tPVsDVUQFI1PEF8oHuBr8nA6vZFPzIqZAlFieQozsn2Seoil9tMSPhEYKjBFvoA8oEyT8x+Go1y82wDY+0Gotx1m+QTprqvhwfL9mfQ3XhbE4O8g5r1LL8Wq0f2PTvugmrA==
Received: from BN9PR03CA0517.namprd03.prod.outlook.com (2603:10b6:408:131::12)
 by DS0PR12MB7948.namprd12.prod.outlook.com (2603:10b6:8:152::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.27; Mon, 12 May
 2025 20:57:05 +0000
Received: from BL6PEPF0001AB4E.namprd04.prod.outlook.com
 (2603:10b6:408:131:cafe::f6) by BN9PR03CA0517.outlook.office365.com
 (2603:10b6:408:131::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8699.31 via Frontend Transport; Mon,
 12 May 2025 20:57:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL6PEPF0001AB4E.mail.protection.outlook.com (10.167.242.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8722.18 via Frontend Transport; Mon, 12 May 2025 20:57:04 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 12 May
 2025 13:56:52 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Mon, 12 May
 2025 13:56:52 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Mon, 12 May 2025 13:56:52 -0700
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
Subject: Re: [PATCH 6.12 000/184] 6.12.29-rc1 review
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <1b87e8da-a106-4957-a34f-e8e7a2d0b7ba@rnnvmail202.nvidia.com>
Date: Mon, 12 May 2025 13:56:52 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB4E:EE_|DS0PR12MB7948:EE_
X-MS-Office365-Filtering-Correlation-Id: 4255ff55-587a-4f00-c807-08dd91978d2c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|82310400026|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?L3BUS2ZPampFeW5kOWFSK3BubU9ENG9LZlpxclc0YTI5eFM1WkRucXBrRU83?=
 =?utf-8?B?amIxeXZucG1SV2ljTTk0S1lMcDlOUFg0eHp6SFJlZnhPdktURXRFWG1NSDUw?=
 =?utf-8?B?dllZc3N0dTJGT1VpdEl5bUdlZkhYZWpacm9iNUM0TldlQkZ3OHp4MDZvSGRI?=
 =?utf-8?B?cGgzeHNkVWRianVIVWhlT0hBV3J2RkJKYUdsWWF5cVBDaFJ4c29WbU16dmpl?=
 =?utf-8?B?VEVORWp2NjVhTFZpeFpRdXhMOWt1M016YmFDbzJpdFN5Q2RyVlZYNDI3QUlY?=
 =?utf-8?B?eHB0UVhkM211cC81YUk2amJyWmNUWlpVUGN0bG1VYTRPL0pSRVVpQ29haVZG?=
 =?utf-8?B?SVZlbEJQMEdtVGJkcDdDTm5NclZ0WWNlMXY2TDBPN0lVN2dYdTYxMFRhTEJZ?=
 =?utf-8?B?TUIxWUttRFRZZTh3Y084THpNdHhPQUpSa0Fpbm5xSVNrRHlxcVZBWkNQcmEv?=
 =?utf-8?B?ZHRQN1pmZXV6d0tqSXE3NUZFbVpJWVNJbnY5Mm8wblpJWnJBUDZTNXVCZzY0?=
 =?utf-8?B?MEY2T3VKKyttQzdWMGZwaUdISThsbk85T0crRDJaZWhObGVGMW5weEpmVW85?=
 =?utf-8?B?dWRFOGZpU1k4R0FDZ3FheXY4QmRqZEZhR3luYkg4QzZkRE5GcHBueVBoVGda?=
 =?utf-8?B?TTdjeUhGSU9ncXlodUVXN2YzRG95bURIc3FCR0lQQzNIK1Nnb1pkaUN2dllh?=
 =?utf-8?B?d2E3VUU2cHZPbTNvTTZrRlpZYmtUTnVEMTlKLzRUTjRJUXNNSzR0UDNpSGFr?=
 =?utf-8?B?Vk1ZdHArVSsrSm5FaFVUSkdoOGRpRytsOTdnOVduWEp3cEFOa0kvMElIb2tM?=
 =?utf-8?B?YzFKTW1MNEw0NVBZUi8zVFFGd2JkdWxXQ3JNc3hYcFJFYlhqd2xSMDdQeFVa?=
 =?utf-8?B?cGRWcjYzNTVKZDZDWFFWYVpDMFAxaE00M3pqb011Y3RnN1I2Rlh1V0FTeGdU?=
 =?utf-8?B?aEV5T2pOaDdHbG5sU3pjVjVlUGZJUHRnL05qQWFuaE1JODlOcDV1eUVpWjRs?=
 =?utf-8?B?Ti9FUjlTR3l6UFNTMWkwV1JmL0NnTlNOQ1lqblU3SHNPRDdxbDRJZzM1RkNn?=
 =?utf-8?B?a1VBWm9zbE5sTVQ1RStySGZuYXFVc0FHcUhFTlQ2U3dYSnNhMnhobEFHaXVa?=
 =?utf-8?B?QktkQjdDNDdwUXJOVTBla3dIZTZuUVExenVucUZFK0t0V3AyeTQ3NWtiM255?=
 =?utf-8?B?T1dVZHRSbzFSRmhGbG84VWlKY0cxN2JqVE50QjUxMnhLb3EyZ29TcXJzRE9Z?=
 =?utf-8?B?SnFGQ2pRTkNFbjVERE9SdTJrTks0cjZXT21DeWM1WUVKL0RMOExvUXR0S3pK?=
 =?utf-8?B?VndqN0lNUHZiemZ5S3dIbnZudnQ0RFlvdlZQck1oT0w3RnVWR3lKVVE2emlq?=
 =?utf-8?B?RDhpY2sxVE1SV3p4Um9NUGdaSGlpU2ZTSzZLN3E3dU1URGxENU9vazlrb0pq?=
 =?utf-8?B?OGNqUHpXanhIaHBhTnBQWUtzK1hPb0tGY0NWekNlbEFnbVYyK1lvSFZldDNL?=
 =?utf-8?B?Y2wrdnMvSEJWODIrZm5xbjlEU3VzZW1DUUtxdWJqR1U5VGJ6TWZFYWdKWGVx?=
 =?utf-8?B?elpDSlVtYjFGNFRkRDJXSCtiTDdyc2E0WHZLS1RQT2dCS1R4UlE4NmZGRVBP?=
 =?utf-8?B?dE53NFhFWUdCUVQ5U205cUlTb3ZVLzJzRmVEd0I2bTNDaVZRcEEyR2RYQWts?=
 =?utf-8?B?RWV1WDBDa2d3aWxqOEZOOU9LUCtuOXpYT2xUOGw0Qnh0V0hHbmlPczR4azFV?=
 =?utf-8?B?TEM4SDhVRVl5NitaWTBuRTMzYmIxUVYvTCtwanR6NkJxeVhCaHY1K1pNemlD?=
 =?utf-8?B?NTRjSlBLZVhWazFQdjVWTVh1WHhuQmIrREVmRUF4QTlKK0E1S1ZuTkdNNXFS?=
 =?utf-8?B?d3oyU1Q3YjAvU0podnFwVjVTdnJ5bXVvNVJZcjhZMTF0UWFoeGIyYUxpVTgv?=
 =?utf-8?B?S1FKNjZzdTUxellFSDZlY0VUcStPQnRmaDBmU3pMRjY2RG9JaFR1Y1FVZ0h1?=
 =?utf-8?B?SmVwTURjb3JmNmFISVFzVWxLWUVCNmVHd25ndGRiOWdENThjbUpFSTh3YzJN?=
 =?utf-8?B?T0pNaXR0bjlaMUxPZ0lHdzVUREk2NVM0bDg2dz09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(82310400026)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2025 20:57:04.9093
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4255ff55-587a-4f00-c807-08dd91978d2c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB4E.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7948

On Mon, 12 May 2025 19:43:21 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.29 release.
> There are 184 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 May 2025 17:19:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.29-rc1.gz
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
    116 tests:	116 pass, 0 fail

Linux version:	6.12.29-rc1-gd90d77b7ffdf
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
