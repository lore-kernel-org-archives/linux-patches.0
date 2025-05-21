Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2086.outbound.protection.outlook.com [40.107.236.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3330E212FB8
	for <patches@lists.linux.dev>; Wed, 21 May 2025 08:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747816320; cv=fail; b=lpQOmXczRx1ZmfTsMMRJgjawSrO9cRjLJcBsAtasALfVqtzk8dIhT4nOw+KzC/AZkQWpiktvRpsotO+zH6H0bDhLZaxbmG2nixc1+qVQT0n0Wz6gv2pwXwY2IS8zrR/A8HdDErlnji1qm86vP61DBqfSt+A3QANaZupZpDVz5LY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747816320; c=relaxed/simple;
	bh=CU+emJb3kyxj9W07pukLRLKeFEHdiS5rover3epaQQs=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=tlAn1PUQEpTZ1kaq4id0zH+0xoj8wLK29LpBpOnKV0ui/CimjjmMDor8lKJIa1DmuEI1cR/3NlsCvmz6GNqDUYKT7g2IzxYof/5fLgp/oOwRQKKGcmdD43PQ3yIkfqk1Bmpu5tQJdoa7HQt0JHICHrJoSxzL3Q4KOy+8WIMxjHg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=RjjEkbpa; arc=fail smtp.client-ip=40.107.236.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="RjjEkbpa"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RGBUm9cQgxXdtrHSatG2R6ULTiFlAmruUF6Bw9XpfUedwxHTJJ4laP/N4sNhxS0788cJVSnla6dC6HBTPmxLtffXNnnFTmKR3r2zDuiha9EPNZfaC94HsJkC0j3iXazxc4g6f6accRDsCrYBCB4eGDbKbUVUuUNkM5QXV8KIKxGngaYhL1j3O6XSDaxTT2iwS7kLGsmw/iuDP0BRbUGlAu54SSb1knY0RzK5ntpC6fWDUuBaKOyscK2wrhC9QY1w8ThgaX6oNL027iVcjCiP84BbOHu7nY1WUO5oif0WXHy1f1QkjfacNVZzxSIIOB2CqWBF/+ZkdPOwkmgcUY32hA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pKgSTYsQEOCXfK4YYow29AJDsFo9xyraDvbt05k/Iyk=;
 b=Pen2E8jXx9RHU6gE2FDnKSA7kbVq35MiScu7/uf68quV0+4T6m6UaZdGU6rrU0Qkkiw7ww99EpN0qWmdK+GWnu02mN0Mz0xl0A5GzwJbN5Uc1y/MhCXCtMd5Zfvq4dHX4bt2Uim6yPjhHZSu1yuk3Olj+I9RocF8lmP0SM1/+bnuYi1MEngD+TtPrBErZaTNq+bs87ywf+wJybLVjsTOGS20d/Ln7b6BoLVkOpZHTNcedWbwuj5iiGewsjfaodcfU0EyjwWW/YRL4rSBhR14cr2qh5F7IIFgaNsMi2jMikotcjm0TRnI22QZ/7hUNJu+N4gZ1nTsanlsmKWsoXpM2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pKgSTYsQEOCXfK4YYow29AJDsFo9xyraDvbt05k/Iyk=;
 b=RjjEkbpaTqi3CN8W1LsDSVLJVS0g8WIfUJ+VXjHU6MzlGCO3xQ4jHz11Pwdxo+xJCFyRlPq3deSiOoJWLvHNZ1+LI1rmNBYP1KjFpOTROk95IESM1IKdidMGlYh3GYw33bp12aNDJifynhLiBxl/+MCQu7B+gizW5WDHQElWEwgNDEg9q9YMbdFlrPx0qhtcvvqHEE99UHQ3vols2GjiIqQajzUdKoDOhQ4vdmTORC88T26RE/pRWBewhMRm4QXBCmleL24jV8UuZ6JMHIZGOnIkAVn0xXHWB2ffzKbhJrquxonuTiAoVnGYQZ7/VwaAd4xZoJmK2gEOJHQTa3IczQ==
Received: from MN2PR07CA0010.namprd07.prod.outlook.com (2603:10b6:208:1a0::20)
 by PH8PR12MB6842.namprd12.prod.outlook.com (2603:10b6:510:1c9::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.31; Wed, 21 May
 2025 08:31:53 +0000
Received: from BL02EPF0001A107.namprd05.prod.outlook.com
 (2603:10b6:208:1a0:cafe::32) by MN2PR07CA0010.outlook.office365.com
 (2603:10b6:208:1a0::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8746.21 via Frontend Transport; Wed,
 21 May 2025 08:31:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BL02EPF0001A107.mail.protection.outlook.com (10.167.241.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8769.18 via Frontend Transport; Wed, 21 May 2025 08:31:53 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 21 May
 2025 01:31:41 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 21 May 2025 01:31:41 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 21 May 2025 01:31:41 -0700
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
Subject: Re: [PATCH 6.12 000/143] 6.12.30-rc1 review
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <6dee284b-d652-4343-9254-07720030dbec@drhqmail203.nvidia.com>
Date: Wed, 21 May 2025 01:31:41 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A107:EE_|PH8PR12MB6842:EE_
X-MS-Office365-Filtering-Correlation-Id: 792df863-4017-4ef0-2e63-08dd9841f0d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VzFJRHBwaU9zUjl4bmJZVGhnM3REcm9jSHJHc2tFemN5cHF2SERHZEhCclJo?=
 =?utf-8?B?N25EOW56WU1lZWlZZnVrclJMaGZFS01QajJqY3RjeHNKY1kzU0gvUVFGdWwz?=
 =?utf-8?B?UlBhTHBnSjlnaDBNVHpxRWFGRTZVQkxCRTdodUNqY09qaTJIcGtVL1ZZbmhL?=
 =?utf-8?B?ZkIwaGxHeVhmNFdWTW5Mcnh0N1BpNW83bjBrMkN3V1ZjRXhoSUYzQjRjS242?=
 =?utf-8?B?OGhreVh6bFhFYWZpTUtZN3IxQTMyZlBibzVINFFsOUhQRDZlMkJ1RG5GRzdz?=
 =?utf-8?B?ZDN0MnZQSVppWVYxRThBV1UrZ2ttU0YzNEZlQWk0cU1NNjROV3BadnZ3R2JG?=
 =?utf-8?B?Mm1hTkl0cE54Mlo4TkhKU2tzMG8vNm5uVHh4L1RLT3loMC9IOTFTTkZlcThG?=
 =?utf-8?B?ZzVTR0ZPMXNZWHlZeld4QXE4RFQydi81Qy84NGk5ekcxWEk1UVlLMHdnd3Ro?=
 =?utf-8?B?VjVWT2ViWWd4MXZzYmpqa2hiYVFwYUYrM2RTN29IZmZwREk3OTlpa1pJRzlO?=
 =?utf-8?B?VkxFSkN0d0N6czBPK2w0b1p5VEtvK3B6Rm9rempHakZhbzBnVzNEVzREOUlU?=
 =?utf-8?B?Q0FlL1preHpQYnpJSW9KR1MrZzZITkFlb2drZ2V5K3dNbzkwOUdDZTNVa2E2?=
 =?utf-8?B?czRtbVBmK3lTWklSUFpZNEFqOWhuT2NOVGlCaWZWWlNRa0VRaXRaK1kzY3pP?=
 =?utf-8?B?SG5SQmRSOU9VbmlhN0JTZitkdFhPRnArTG1jMHJZTTUrb2xpZ0duSWdTVHZU?=
 =?utf-8?B?R29QTngyVTI2ZHRUNDR3YkVvQnRMcWxtcVNycHU5Zk5MTnQyZWZEaEp2MWp1?=
 =?utf-8?B?b0RGQ0YyQjFHZTRKeTZheVowU2o5bmJVS2ZWWWNvTU5SWU55U0g5TUhuaWpp?=
 =?utf-8?B?ZEk5UmNCTjN4UlRKZVBYbThod1E3dFlqaWEycjZRdjB0OElJeDJZSm5xMnp6?=
 =?utf-8?B?WXl1TTVUOXBLb3IzVVpxR0tBVU01bHVWeGgyYk9zK3RBbEVzU3piZk1oQkJ6?=
 =?utf-8?B?azR4dDN2TE5qbTA0SzlJbHRGUnpPUWdZbUg0RVZMYVlTMmNmdnlPeGlvenhI?=
 =?utf-8?B?ajQyN1NVZDVzVnRFM2U1N3hvK2pUb2QwNUJPSGl1bW4xWVZ5cHRTQzhzNmx4?=
 =?utf-8?B?Z2NyamRjd21xdzBKYTY0TWl0WFcxdXVuMjkzYXRXMVZValRrMEVVVzNLN1BG?=
 =?utf-8?B?cEtZMzhrNzhkOFVQS0piRUc0WWZleWFkQlhTS2VpRHZMeHRhNWVjZTVrZ3lM?=
 =?utf-8?B?YVU1b3JmT3R4SHJiY3RvWUF1ZTlqWTg5THJCdGk0UDBabUhlR3RLUXNrTXp1?=
 =?utf-8?B?ZFltLzZNOFcvYzY2c2s1cjZTN0drL0o3VGFCdWNtaUxmODJ5M2pPNW5lRXhP?=
 =?utf-8?B?WWF2QmNkU2dLWEJJVGJqVWZxVG5EaS9SYjFTUlBObHpGNVBZcjFYT1IwaStw?=
 =?utf-8?B?Wnl6eEVldlJyN0M1ODlFeEFmcTlENlEwQXV1RHpwejhTOS8wOUdQUlVSd3ND?=
 =?utf-8?B?WXhNL1RVdVZxRVJFdTR1Y3lORVlwUHVZUDlFZm42bFV3SXVpN2VQTzREM0VO?=
 =?utf-8?B?eFZaaXhzYVZjSXc5UGhUZ1FLUHhsVzJJUW5GdkZmbEJ5RlpSWVhmTGZ4K0dG?=
 =?utf-8?B?djZrRENkTkVXMDgyU2RHMStoWm5RQkN3THhGUzJnWXdlbW9WdTZaZjJPZm83?=
 =?utf-8?B?cUJJa2EvcHFvL2Jxb3Z4d3hyTEhOU2J4TUlkYWFvcUViZW1JYlBSVFVvWHVX?=
 =?utf-8?B?RDV4Y2tNVURYZzM3WFZqdW8yQUZWWXBvZ1ZtMFl3NnRucno2UEUwY09IdUt1?=
 =?utf-8?B?YWtVYnFCNnJpRzVRNTd6MWhhQmJKZU9VQzRVMlFPZTJpN1BIVzB6d2N5dys0?=
 =?utf-8?B?b1IrSkwvb0piYWE4RlFIclJVRFRCWlRzbUUzU0ZLLzExZ1MzRmtPSnJYSDY3?=
 =?utf-8?B?dmtiNXg0dStNWWx5U25ONlQ5YWdBL1g5eFRJYi9yVk9pVFliU21aL3lxY3RN?=
 =?utf-8?B?eDJITUpiTmVMOWhqOWhKQmxPOHZ0MUhGVDllNGZuRWU0dUdmMXFkQ3hhZTRR?=
 =?utf-8?B?N3B1RzgwZUZpOFVXcEtmVWVLWEZZQ2JiWlNEQT09?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2025 08:31:53.5254
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 792df863-4017-4ef0-2e63-08dd9841f0d2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A107.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6842

On Tue, 20 May 2025 15:49:15 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.30 release.
> There are 143 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 22 May 2025 12:57:37 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.30-rc1.gz
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

Linux version:	6.12.30-rc1-g28ceb2ca3164
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
