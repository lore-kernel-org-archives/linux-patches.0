Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012007.outbound.protection.outlook.com [40.107.209.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B73535770A
	for <patches@lists.linux.dev>; Mon, 12 Jan 2026 12:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768219800; cv=fail; b=Q0HJFOd7cn7ZOs8W1T+hnGzpyeOl3pKSDsH1Bit+A9ru3NK75S3lCkJwye7uwVRkpfKmdafMcOgoJFvGbR56zmPAMUD4XDu5L1Zg/gQDshjnSP8eA/bIUB+wveD+gmWxvtvj7HKr9TL7qizO8zk2+uQh0wvMp59dRNU3f6YNmR4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768219800; c=relaxed/simple;
	bh=mevMBxNU6QbkjajhwX3CC4GD0nRGhiVWtTmMQsjPQAA=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=NlbD9mHqYdk1AGDt956EsPg5Badn3Sfy5/801+vlP+Q2SCwtBTuxnzkWOdtKNC7J0LfJ01ixaBaU2SoPOAsgKC1EOdy5I+WS0Wb+zNkd4o8Oi+m7jXgLu4t9ncBzpCC3O6A8vWrk+zzBKPoZxtP51HpM7S3UNgHT1JwKipNZaTI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=CeqUXlLm; arc=fail smtp.client-ip=40.107.209.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="CeqUXlLm"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wvHhIbGAIWiBFKLMbaO+0kGSu+4ffVCW6T38bx7oY06fdfdjAtGJJn581WpMYuUSEB4LOWfqp1s0KHZx6MmkfFQKJdUkht2Tj2S2inl4cYcK6QIwZEDzGW/GKt1XDha+/Ulhk6xuORO9BUOxWdB2MjYUN6grozrwtaknhbdS/+yo3LCglY4LMnitx/twWqaXi6mUOwcnnRYDn7k5NRMX7vbzRX+Ye/Gj/4FiNscz+gG664KwBk3pmrV9Ldn0hTeS8XdKB6ROo/3jy/JOkFXgEQ0wKanDy1tVsKWdgZ3opxJq2JtcLNs4BPxh5wswbFGJgRcKsn5Syx9a1ejRoRmSMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VxQm5OUhCkJXsPTAoENvnEAfocdEMy05CocxVws6YvM=;
 b=wWlubf1KYhCRPV0HkCYYsoHqCWzw5hPDDXPyK4lPga8EiA4gwpVFbtDqDuXU9tSK1fR+LqpOTqs2pwzie3Rf42ozbMPOW+abyKWQqit67qaHft87sUkkaZog3MhsgPIaDprzNo6lIgSP9vJETZUGUy+6acJ0ltQA/rlFggMl/XcRClQgos/BgAr+AdqfFfu6zkBS6Lzee4oxnfNZn06eq/PqAaC28i6SYRD6hg+1Mq00TNSWlLIKap8dA5R3LZynRYFjijgDdtjbUje/8ZsXn+h98CrV4hpqudEgyS7Hmgsy3nckGEOxE1qeQr4nD/USB4kMGxOCZB01ZAT+DgSV4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VxQm5OUhCkJXsPTAoENvnEAfocdEMy05CocxVws6YvM=;
 b=CeqUXlLmNgIMRxqKQPaErnZBw9q15uOndwB8+a/SwRLj8+Wr3St59ezb9byeB/zmFLKSDQGCRG3P5N2lYpH1kSZnmm5IloeixlYmXauqbE5Pl2NRI9Zi7fcluQE9c7u05Y3n8aSo0rPPpFcjHsOsSDW6/5wuyKaeVXy+z7+XM580Af1AeHuEdbOm+TB3rfs+V8oNMQYdBBCNjJfgXuS+PHMQaenYmQq4/CrB36gCDABRzp9DdSgNcqGmYwJsH67qF3NCMkUOroxl1n/o9zEMk5hamUc3XwTNT0nXaCFYta6i0m7XjJfK+mtqlENPF0n6yjwydkEHmZg+o0+fgeQCSQ==
Received: from MW4PR04CA0276.namprd04.prod.outlook.com (2603:10b6:303:89::11)
 by CYYPR12MB8730.namprd12.prod.outlook.com (2603:10b6:930:c1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Mon, 12 Jan
 2026 12:09:54 +0000
Received: from MWH0EPF000A672F.namprd04.prod.outlook.com
 (2603:10b6:303:89:cafe::43) by MW4PR04CA0276.outlook.office365.com
 (2603:10b6:303:89::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.7 via Frontend Transport; Mon,
 12 Jan 2026 12:09:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 MWH0EPF000A672F.mail.protection.outlook.com (10.167.249.21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.1 via Frontend Transport; Mon, 12 Jan 2026 12:09:53 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 12 Jan
 2026 04:09:37 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 12 Jan
 2026 04:09:36 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Mon, 12 Jan 2026 04:09:35 -0800
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <rwarsow@gmx.de>,
	<conor@kernel.org>, <hargar@microsoft.com>, <broonie@kernel.org>,
	<achill@achill.org>, <sr@sladewatkins.com>, <linux-tegra@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH 6.1 000/633] 6.1.160-rc2 review
In-Reply-To: <20260110135319.581406700@linuxfoundation.org>
References: <20260110135319.581406700@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <f5cf6068-ef2e-4052-8bea-343be248f351@rnnvmail205.nvidia.com>
Date: Mon, 12 Jan 2026 04:09:35 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000A672F:EE_|CYYPR12MB8730:EE_
X-MS-Office365-Filtering-Correlation-Id: 680eb66d-4fdb-4c80-859c-08de51d37e96
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|7416014|376014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RDNtK2hjbmlQdmkwc0NKQVB2Qkl1MUFPUmI0ZWJPNXh1Y28waUNkeHpTQ25N?=
 =?utf-8?B?L3JZdXNrRGlpRzJwNUh1aFhjTkh6cXk0ZENTK1pSekU4eWl0NEJYRm5aVUhH?=
 =?utf-8?B?Tk54a1pKMk5va0huMGJnaFRGdnF6UUIrcWY0bG5Fek5oQ05OemlGdkVqWktW?=
 =?utf-8?B?NUlOcEFHVWVYSHlxNU83L3hHbHBEVGl3WlFBbThPNW5FUUxRamw4ZUQ1TFBs?=
 =?utf-8?B?RnJCRTlIc3NUdkZ0aXRNWEp1WGR5SE5maXBTWTFiMml6MWVGb0JrZTBnODY4?=
 =?utf-8?B?cmU5anRsT1lablFFZ050RGR3Q1R0U2Q5Nkh6NG1Cd2tOenhhUFFMS2lIUGor?=
 =?utf-8?B?cGpaUy9CTmRncHdiM0lKV2VtWTdKTVFxM2UwSVh2MFpWeDhFRGNZZDFDTDVT?=
 =?utf-8?B?VGZFYUJwblM3QmV2NStGT3FwTks4Tml3TjN2WDVKaTlmOEgwNlhiaHVGdmhI?=
 =?utf-8?B?eWdRV0JaR3JKR29XZ2VOUWprRk1UVkxON3ljb296ZElPSU04elZPaHMvZ2gv?=
 =?utf-8?B?VjFOdHBDWFhFK2lsSDNtdzI4Zk9nazZFRW1mOUdWWGg0TC9HazZ4T2YxK28y?=
 =?utf-8?B?RExWeUdQUVl3VWl1Q29yYzE3V3JGcG04Ujd4MWpFYzEwY3ZTWWxDMzdxemt6?=
 =?utf-8?B?Vkk0RTlOb3AxcDJKSUFQQ2hhRTVpRi9iOXR1dFptN0E3Um9pSnJyRGhDVm5L?=
 =?utf-8?B?eFFuY281TkU5cDZnSUtNM21RS1Y1c3R4RC9FcWZZQUZUVkw1WkdmdmNyT2VW?=
 =?utf-8?B?bWthT25lTzVPMy9iNEVyYjVOUDhIYldjRjB5TFdRbXF0eTY0d3FHeVRwYVJ3?=
 =?utf-8?B?TEVjemZKV2RXdDBSb0RxY3NyaHdCSUc5WXZqcG0rTStsbkIwQ1A4dWlvVW5C?=
 =?utf-8?B?L3Fra1VPMStKYUhoMCtTWGVybE5VcEVDRnFGZFUxNmRONzdFc1k0NVBnbG54?=
 =?utf-8?B?ci9tRDdHdkxHbEQvS3cvdTlveUw0TnY2RDI0YVhCcmp5WGNieGhEaWFCamFo?=
 =?utf-8?B?Z2hjdERBUGduNVUzNXFvWkFBcTRwQUlYRUxHRkRyai82a0RIZ0M4RnRMOVJq?=
 =?utf-8?B?NE4yM3hZdm5UUXo2RGd4RUFEdGt6MFNNYjhzVGQ0WjVkbWh2K1lPR3BQcGtQ?=
 =?utf-8?B?Y0ZTeDZlanYzZUc0RXFIVTJabE5xVlFScWNXTzE1MVlZWG5jL1RXaEo2Qkdw?=
 =?utf-8?B?THk4cktsdmJOMWxscnNETXdldGNETGxmUUVKZDd2QTdtNkwrRkxCS0k2Vkw1?=
 =?utf-8?B?U1c5blR2R0Z0V3ZrSHMvbER2MXNtUTNGaVNXSnZHaW1lL1ExS3pvNXFoQWVt?=
 =?utf-8?B?UW11bXo0R3NxQjNJVWg3YWJnckY2K2JzVHJOVWd4ZjJLdjZyWldxRk9OV3Ro?=
 =?utf-8?B?TXdwZjRYOEgvdmlNekovdUZRa0xTbU1ZTVBRVll4VkMxdkVSL2c0NXJTbk45?=
 =?utf-8?B?OFU3eGRRRzEyYzJhRHdsQkx3K3hzZks0UVppRm1oOUFJNU1oSzlWSVFNejZE?=
 =?utf-8?B?QWxXODhobWNrb1pvL1NGM2o2cjFkL1hmcmQ3alk2TjRha1hYdSs3b1RKOEUr?=
 =?utf-8?B?anhoV2xlUmVmWXdjai9ZK2VSUnNuamJ1bXB6T2wvQ1NwMTY1ZnRFc0EyQ2h5?=
 =?utf-8?B?MVZjSFA4YzcvUytJSjNucnRjTHI2SEsvT0h2TUlsNVkrNFhFRi95ekNGcUR4?=
 =?utf-8?B?Mkd3R3MrZnVsS25SUi90dGorQko2VzVuVHRIUWdzUGxaSkhkdHkrMWpLS3RP?=
 =?utf-8?B?b25ZdzFjR29SWEI1eVJoV1ZKd1NSYjRIU1dUQ2JyeWdjNXVBOFNua2I2ZGZG?=
 =?utf-8?B?VVN0QjJBZzh0S3BOTXRaaWxTQ2ZjWWdYdDBTaFF5U2hNaktkaTFLaXJEbitC?=
 =?utf-8?B?Y1Z6amUxSkRQNm9VQ0ZtdTBpcnpqN1dKbkFWNWd4M2dxUU9tbmZIdVpscTJG?=
 =?utf-8?B?TGljM24xMmdCMlRKaDBsTVFLcGc4b0pHS2xZcDhCOXl1d0ZmUGRoR3ltYTRk?=
 =?utf-8?B?bXc1VUMwb0JJM1J2N2s1Ym9FWFF1YUljN3JNSkxJcG5vZ3EzWW5BaGdYeVRR?=
 =?utf-8?B?UVhmV1NLcGN0TU8ySHJLKzRyd2VkcmY4U21KbWxEdVlyWHNsdVRsSFYvbnpR?=
 =?utf-8?Q?oeVQ=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(7416014)(376014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2026 12:09:53.5462
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 680eb66d-4fdb-4c80-859c-08de51d37e96
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A672F.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8730

On Sat, 10 Jan 2026 17:27:38 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.160 release.
> There are 633 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 12 Jan 2026 13:51:43 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.160-rc2.gz
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
    28 boots:	28 pass, 0 fail
    119 tests:	119 pass, 0 fail

Linux version:	6.1.160-rc2-g38b254e86276
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
