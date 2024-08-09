Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2088.outbound.protection.outlook.com [40.107.94.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A44B1922F3
	for <patches@lists.linux.dev>; Fri,  9 Aug 2024 10:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723200885; cv=fail; b=KjhvBtDkdfcWAiubO/ADLtjBhVWKgRzsP4GgjFePlZ0vo/bRS8+uucyhsTDWD8v3lVPNVJRvkwx/Qouoj7SqOiFaWsKW3EdTm7RfhnrfSzDshniP30WGi6r+pEHdv0R4UGeXLyQP63V3Xo94xBIvsBecuwNtu9jny6xa5en+brw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723200885; c=relaxed/simple;
	bh=aMznUbL6dvJ3DlzfAgu8DUXF5JfKe+y7ZrcAJN9vSz0=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=lTSlZXVUBdDfZ2n56pXdZCFDE6FYIAatLTRTLkeBSl8oUiZJxfHvsJc7qOEYgMCUM4Z1et/Cnq/j2705OhfGDTfEhtqgh2aGieQxHmLw3JIDycQCcxFrJJ15PdyInCkJe30FnE0tnhHfkNEEQTod9ezDE98FfGU5p6T7hfXePSg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=I92ccnAl; arc=fail smtp.client-ip=40.107.94.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="I92ccnAl"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xxQeo03lwnoZxqfGQiQs05DJLuVRN1is4tAMVqDfDizMajk0Ak4eL4UXG6bjdw1zoiV+AEJ6mvI+dGW+PytFJbQhc1d4MHl7MRNzcpZEt66vzImEI1acwivzP0JHPT3bCGHy7JHiX7EJIHXWeHdXb52QN4dAoqmIiAqib1swpJiDQOyw2HuvLrxgSuDwAVL2K1G/dn/4bNFdM5IglS+lI/O3UFCdCozZxwgMiSegyiT7cUq24KLytNfCacGjG5hF3SenG+cpzzW2H8lkJjcMIxgog8HgDPI9IAwC0h5jv0i0kuepJbXp70WFdoejoCOTFHJWOeq+fhHXs0bQ+TOr8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LS6etmgMXa6b6sNJ6Mxtjw9VLN6J8v/FGXnLGK14SCU=;
 b=CWfiE4ebY8K0GHwc/ZDlM6A3Kcpx67t/rG4V6/ThCgeTL06IjmIEfIOOaW99YlAh8awsXbytlEYl7dAhvdYgGT3z4LMChfL4l/ckGulRd1horfrgrXzBtTBJCji65cXoYTq7kCqwKW0K8a+pcC5rhUOjetda2EKqQb4ifGJnfVqCGsYxaCv8ECgo9wDpk95jfBqgmqr7421+NDWGGiC04LOJ3iUMwAZypHPaKhlVEbb+HF0qKajeJ3ZcVdbRNTzcJ7o2K+fKRohKeoAENJlNTh7FKZC8UPYupyonwiqpvmruaULdw8iK75n3FNWdhM+J3nwPZ/YHBK7a3Piq2XRp8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LS6etmgMXa6b6sNJ6Mxtjw9VLN6J8v/FGXnLGK14SCU=;
 b=I92ccnAlOVaQZBxM+P/u2PI+eK6H2PYS0ax5fNem2TPA0vQStt9hrkHvtMz4yfG8GM16fu9/N6p/yQ2BCVN8Zr61bGfkT7Obz7jdVKJcoHvju0eOdwN6CAXwbchHJ4XSB89cxNq8e8c5HQBFbXFOAPxBxIL7VqWgZ+O4GklNozqeaeB1c95h0yL6UiB84E1LqRnqh8vE0zaEe0WoUF8WOTvi4vs8kSSv1J+niJUs1RrXdZuyt6KYPxmKNlAW3u7F2YR/tYyxKa8sQ+rWFMOOl5wRRIx/KBlTS0JfsHDht/iPhEXlkuKaXRYZS84s8LTHTJYjDE7DxJyHsUtgBooZDA==
Received: from SN4PR0501CA0054.namprd05.prod.outlook.com
 (2603:10b6:803:41::31) by MN0PR12MB6176.namprd12.prod.outlook.com
 (2603:10b6:208:3c3::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.15; Fri, 9 Aug
 2024 10:54:40 +0000
Received: from SA2PEPF000015CB.namprd03.prod.outlook.com
 (2603:10b6:803:41:cafe::ca) by SN4PR0501CA0054.outlook.office365.com
 (2603:10b6:803:41::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.9 via Frontend
 Transport; Fri, 9 Aug 2024 10:54:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SA2PEPF000015CB.mail.protection.outlook.com (10.167.241.201) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7828.19 via Frontend Transport; Fri, 9 Aug 2024 10:54:39 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 9 Aug 2024
 03:54:28 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 9 Aug 2024
 03:54:27 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Fri, 9 Aug 2024 03:54:27 -0700
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
Subject: Re: [PATCH 6.6 000/121] 6.6.45-rc1 review
In-Reply-To: <20240807150019.412911622@linuxfoundation.org>
References: <20240807150019.412911622@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <ac30c96f-0526-4d43-94d8-7b365fcd4d9c@rnnvmail205.nvidia.com>
Date: Fri, 9 Aug 2024 03:54:27 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF000015CB:EE_|MN0PR12MB6176:EE_
X-MS-Office365-Filtering-Correlation-Id: 9007d79e-4ecc-4be1-df14-08dcb861aaf0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RGFianQwbG1JTStpa1NMSnZ5bFdaSngzbHIxYkQxNzAvaThicjl2Y2pUNk4r?=
 =?utf-8?B?d2txRzRsd0xYcElqVFZveG9LT3c4TjZlN2VWSFNlRnNCSmVMejhld3ptMlkx?=
 =?utf-8?B?aXBNYVI0Y3VvQmRQRnpZNUZyQ2lwZ0p5dG5Jb3ZkemtpdFJuOER2YUtYZUth?=
 =?utf-8?B?WWVyMWV3ZGVBMGc2KzdyZ1BXU0xHR3Nrb2tzQnA2VExxdHBpSGJiUWlXQUEz?=
 =?utf-8?B?SVZYZUZFWHVmMVgrbGlMbkZqZThhKzRINE9WMU95aUptekFQWHFTMHg3ckRz?=
 =?utf-8?B?Z08vbWFoNTh3MGhRa0E5dlMyZFRPcTNwTUlTYnJGeVVaK3pTN2EzNm5lSGFm?=
 =?utf-8?B?c1g0elNYUGxaaVlUSGpTbWsxWkVzNDc5SDFkWFpiaTJ4cy9ZUVU5Sng5VWk5?=
 =?utf-8?B?c2d0NWd1THluYW96WmVITDVkdVl4ZWp4ZjZhSmFGSWthV3IwYWlzS2g4Mmt0?=
 =?utf-8?B?bTA1Mzc2OGVYMWdYVG5XaHhjWmdqMk9PelVvcER5WldzdmlrcTBCNUxqWlJ2?=
 =?utf-8?B?aEE1STlybVJIRWdFYnV0Y2RNL1p2Tks2Sk16c1h4UC9CRDllTlFPelNpS0J6?=
 =?utf-8?B?M2VPN2dKSHdsQnFzR09WRVBwQnIzS1pxaGxGdXMySlI4QzlOSTMxdEhML21O?=
 =?utf-8?B?a0VIS09rdm5GWXQrRkhldFh3Q0FCd1d0SUJabGc5S1RKSStGYVlITFhvUjFL?=
 =?utf-8?B?U09ORmJWelh3NDZ6NEs5ci8yWnZXMDhudGhWNU1yMUJodkg4bnh4N1Vwcjdz?=
 =?utf-8?B?Ny9LbVZJeDdGeXFxdUNyVnpzTWRZeVZiMFBMZGpXZ1BXRkVwYjRmczJkMmht?=
 =?utf-8?B?UGZqOG9OcXFCeHU0eDNXVVcwcThBb09pSzNQbFdGVUhQczB6bnVFU2dXYUl4?=
 =?utf-8?B?dllRaUJvUmR2TThVZ3R6QmhoUm9ZUG1sYlpTMzJJZXU2bjVQTHlCdHBiemtI?=
 =?utf-8?B?cUc4SmlpWUZyR05pdlhMRW05OW9RSjJuRmhCeUE3OERBeW0xU2M0ci94VTFa?=
 =?utf-8?B?QnRUamk5VjYzemtFU01ueHkwamp2SkowOEJmalZ2R3NDajBOQ1NocjRGQmwy?=
 =?utf-8?B?SXFrUnJHa3ZxaTBRdUdTLyt5cVRvb2daU204eDdtdTR3RTlvZ25mL1RyZ1pY?=
 =?utf-8?B?RVZmVDlmZ1JRanU0SDVkY2had0c3Z0F5Q3J4UWVoWUVySkE3eTFSZTNTK3p6?=
 =?utf-8?B?akdjR0JHcSt2TWtybnFhdEJVcXp4WGZzbXpWczJ5aEdHRkdPVHpVdUptWmVo?=
 =?utf-8?B?UHJVNWlhcWc2Mjk1L3REZmZxN2NDS3BId0pTN0trcDN4R1pKK0JUT1ltQVNM?=
 =?utf-8?B?WG16NlRpMHgvRElDdUVJQlIvVkxCQ1VJMGRJdUhPUlF3RVVaanJFRVhmaFU3?=
 =?utf-8?B?Um0xL1BrbjN6U29VbUhzVllNa1JaVUpYQ2JBaXpsVW4vM01Bdzc1Zy9tNVM3?=
 =?utf-8?B?WlJ0WDd0THlRWUNZM0ZpWkw0Zm1uYy9OcExmbkg4Mm5yNXUvMk9sbnZYdlhl?=
 =?utf-8?B?d3NRRnlxRUhkQ0ZNb1AxdmZoQnBneEhXRWN2dWdmbVJUQ3lXeVNWU1E2MitR?=
 =?utf-8?B?cmZXT3h3MWI4WmpxVVN6bjJLS2I2aXUrTjhxNjUrYlVrMWhoR29KMDNvQlQr?=
 =?utf-8?B?RWdCSmcxakJVTDIray9VQ2puSk1BbDVScDQwbmt2T25pNjdwSjIwV1FVWEZN?=
 =?utf-8?B?enhpMHdEa3ZNaDdvSTRqN0RlTE1DVmkyaUVsT2R2c0JVRnVkQTVCWTluZnNJ?=
 =?utf-8?B?M3pGYkpUeTJ6Y0ttZDkvd2t2SWd1UDBpdlFmblBwUlpWY2UrVGVMOW9xR3RJ?=
 =?utf-8?B?Y3p6RHRLam9laGZ5Wi96dTVIKzc5YXNhaThFcVNDSGREdjFZaWhPanh1dGZD?=
 =?utf-8?B?K0VOZmZ5aU5nRXU2ejhnNXRQWXVlOFk5R25qS0Vhd0dpNTRzRE1FcUZLYXpk?=
 =?utf-8?Q?F8AOC58tqsZYbs3Rah+veU2/Nol5I0yI?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2024 10:54:39.7925
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9007d79e-4ecc-4be1-df14-08dcb861aaf0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF000015CB.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6176

On Wed, 07 Aug 2024 16:58:52 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.45 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 09 Aug 2024 14:59:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.45-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.6:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.6.45-rc1-g272b28faf61f
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
