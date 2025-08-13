Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2055.outbound.protection.outlook.com [40.107.93.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8335020D4E9
	for <patches@lists.linux.dev>; Wed, 13 Aug 2025 15:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755100121; cv=fail; b=e2eXqB17SCTVGvUghFW2eXybasLBhGQSpr8UZWR9LpE95A/JkIMw9UFhoZhGSBkzuRYzSLD567CGU1uF3gi78/Js79CmXAuHAfrGGuIE+5mfST2aPyZgLXrrDNEjYI+KM7sk3L+mDJOPfLzkQxeHrD1qimm5bdyL8mar4cFlghA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755100121; c=relaxed/simple;
	bh=jhq3qN6r8z8Gs5q7vpcUP1YtzlkDFBxTCwEiX/02G2A=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=XaXSrlcfST3jICjbLvdAKt9ANxqig2KguIP0rd27LS1YPZiNt69swqQB/099Yx5eSfMhej3TtiYKMmAq1Ylk/k0cqU4no6JZ9QpJSZTzMifEBNYQWSY2nwNdKQyXnYqRx3UWGBZ2A4q8JMEZVZhQTBgs4vmhAJjhFDwB6GTsdlE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=V2rQxNdS; arc=fail smtp.client-ip=40.107.93.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="V2rQxNdS"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MQTo4TqLpDJ9YAU5geWBOSr2+ig2KLdyVFjrZ+mfQeDMrNlhu9jUIv83ksrg226gJiAsQj0PatIVmz/MPJqcjJijrNaWkmo2vKLgbv3jfZY6WZEDOMEyg+sY3+yebutFyxN0VxpbfU+BMD0YvSOWxBB5x3I4YDubd+OG+TY4Q3j+jiUpv/W1QqyfyjmiTIjYxfJ2MELRBrDwVS/NH6yrXOmrNnZaIG4rm3Bnk5XNvE9PoT/I5WlX0CKE13SlHt5w+A5hM3JgtzI1qQS4KEG8z/G1rbs5Azy5JtQWv33rjKr/AidJXVfVfwVLsSkkpJBMkVcydQ5u7xINYxO264qBKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0bIk++xjJ5/YZmpbgwByOqiA6xBsg7suh6cTbOR+ajc=;
 b=vdYuSDnMAB45K4y7iBlsBdbDosQm7x6MFHShCeeD05Rgd3MJPhu02CeDIIWzNY5VF62x03wDdT0d3fwlySd7TB6YVQt/yw+bflrARcLXvFH8b83ACFBcVWCwPtFT9b1uE7u0Ct3MiW9tMcFIMHdPD36SaJMBjzv0noeTgim7+4r16K558OpxdYWhEdLg4Wx89i08uVKXu/B3XU9KVtI09/YXk7k6HwhxQwQ7mJg4zG7XC2QHo/1rd0sTMpHJhuYn2821gq664olNKWwoa100FFfunCm/fgkGC+tXhQoMfBXWYoiX8ckVb08jquRGoXoen63nOB9I/OAs7HCsvW+IKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0bIk++xjJ5/YZmpbgwByOqiA6xBsg7suh6cTbOR+ajc=;
 b=V2rQxNdSiAPr3qzK+QcOd4CqGKiE0PHRfUhsgzDRT3xbg3B9DLE7dTpoINz+FV0gl1kCgOEwCkcXciGZABnxro9frhREu2bu74qZSRGd7TQGhMfCB/4lPuQLAmrnatUcziDvEZDQfyBzxLHNd+Gxxk8zPSjR1/XmubFHZgB2EIATyKaCThPO78wuTsZVkHv7c615jM6vyQoTBbPKd7piqulyEEskYyDKrO826lzRXEiwxqjLpXFOh9pdJ1Oh4edycRaWLUSLbrZqsPP/L2EgcWGfc5vnWHoZ39Ap09rLfhJBErt2gUMoRmeaQQYFjhS5Dltby0DvX0JwlPrU7/mIBg==
Received: from PH8PR05CA0016.namprd05.prod.outlook.com (2603:10b6:510:2cc::17)
 by CY3PR12MB9654.namprd12.prod.outlook.com (2603:10b6:930:ff::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.21; Wed, 13 Aug
 2025 15:48:36 +0000
Received: from CY4PEPF0000FCC0.namprd03.prod.outlook.com
 (2603:10b6:510:2cc:cafe::ef) by PH8PR05CA0016.outlook.office365.com
 (2603:10b6:510:2cc::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.16 via Frontend Transport; Wed,
 13 Aug 2025 15:48:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000FCC0.mail.protection.outlook.com (10.167.242.102) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9031.11 via Frontend Transport; Wed, 13 Aug 2025 15:48:35 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 13 Aug
 2025 08:48:06 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 13 Aug
 2025 08:48:05 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 13 Aug 2025 08:48:04 -0700
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
	<rwarsow@gmx.de>, <conor@kernel.org>, <hargar@microsoft.com>,
	<broonie@kernel.org>, <achill@achill.org>, <linux-tegra@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH 6.6 000/262] 6.6.102-rc1 review
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <59a0837e-a2a2-4c6a-9e60-3797039ff163@rnnvmail201.nvidia.com>
Date: Wed, 13 Aug 2025 08:48:04 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC0:EE_|CY3PR12MB9654:EE_
X-MS-Office365-Filtering-Correlation-Id: 33bc40b1-0278-4975-d4e0-08ddda80dce0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|7416014|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZXZ4bXJPVlBONk1ybGtSWllZTXJrUkRuakJ0ZENOYXpYclpTSlo0Q0NHRWpW?=
 =?utf-8?B?c3BLbW04UG9hQmJnUWdWTW1rTE5FYWRPM21oZkFEWE90eGE0WUthWG4rQUcx?=
 =?utf-8?B?ckZNNUZJWHFQdEdMbit2WDdLM3QvSk1XZ2NWOC9nT0NLbkpvWjk3QVkwSCsv?=
 =?utf-8?B?cm1XR00va0t0Z3hPUWdVOG5IMTdxMjVVQVVYQ3o1V3RPVjQzTlBScTRUdVY3?=
 =?utf-8?B?ek9WNnVTNzFQaGZUeWkwbStGZm95bWRIS28wSW11ZFhpUS80OHEwbkZjZTFz?=
 =?utf-8?B?VTRxTk4xbjZBL0ZmMWpvbHRGM0FOb3NrZVRyS1lhaWV0Znk5UTI2THFpWE04?=
 =?utf-8?B?VTZYejZjYW8rY3dkZ2o2aVkrMHZERWo2RjMrYlBtVG1LY0hIU2QwaXJHODVU?=
 =?utf-8?B?YTR4RHFvSnRkSFFvZmxhd1dsNmRvUDVYYlZZN3hJL2JLeEhORW1CY2J0bTVB?=
 =?utf-8?B?YjJXOXNHK2pMRWV1OTFGSG44UFgwa3VMY3kwL1FSMThrUGl5a0hnRTdZZUFx?=
 =?utf-8?B?VG8xbkY1Qm5MRFpHalBxODhxSWRKSS9aaUJZak1DRGtTelBLNlNlQVFXT0N0?=
 =?utf-8?B?eTIvUnhiZ0F2TGoweVRaK3UyZHZlWWZ0eFMrOFBWeDVXcm5tUUpuYWU4YW5Q?=
 =?utf-8?B?MzdIUCtjTjdGVy9PUC9hNkpSbTBQMU9kYzRZbjJ0MmM2SGxLanluV0s5aDdp?=
 =?utf-8?B?VUtWdHJ1NzJPUHZ2VGMwbXBpSjZQL1k3aFVybFZGT2xEWk93LzZlbTJtNzht?=
 =?utf-8?B?ZEVCWFdrN1lHN0Q5ekVpbTVicXlrdjVYcXNuaGhySEwraTNqamVRTHp5MnYy?=
 =?utf-8?B?M2lWdUNnZ3FXM0lMcGp6WWVXU3JPRmhhNUV6TVh3cEtQVFRBeE42aGZzTStS?=
 =?utf-8?B?M1RiazRpYjdoVXVpcmdlMnBzbXdUaUhsNDlvOGwyZ2ZqcXlrdWFPOHd6Z29y?=
 =?utf-8?B?aHNHenNIN3d5bmZBdmZHcU5kQTQxaEVpYS9POFdPdWZDQVdnQlkydlJuOFoy?=
 =?utf-8?B?NzFodVNxVjNQOHFMdzRMMkxpSFkxQXI4ejdsMXhjZS9yazdodHQxSjRaYXpa?=
 =?utf-8?B?MFVtTVZPV2ZnV093WU04UFdOQk1QbU1KOWRTWTdvb2Q3L1hxZkZXTjB6T2hK?=
 =?utf-8?B?eThpc01wTzJvRisrR1A1azJTSDhSc3BmVlNvR3JrUU1TN21Jd0s4RHMwWVR1?=
 =?utf-8?B?QkFYZ0VUSDhVMldFSGhQYXBUWVVocVZGVkd0L1Q0VEFJbTMza1k3ZVMxcE1M?=
 =?utf-8?B?VEhKU2tMZk5nZUNqZXlVU3l5SmNEUUp4UXRZYml2cnVJZERQYTA1RHFOQmh4?=
 =?utf-8?B?aWc4STVMKzFPdmJXRUxxWVlIKzJIR3hDZTlkVGxRellXUks1NVdhT1JNaFlM?=
 =?utf-8?B?c2M4N3VQcjVpR2pCOFpTSzZKS2lnbTdZazFWMzQrU21TZHRGRTR6ZEVKTFl3?=
 =?utf-8?B?K0ZvcEoyWkUxaGtFRUVUWnV3YlN4MjV3MDJRUDJ2NFFwNDR3aWcrZ2NkeTUw?=
 =?utf-8?B?Z2F1OHlNN1puQ2ZlNi9CTzZtS3laU1VYWUJXTFZtbml3NnZEenhXOWdGL3ZI?=
 =?utf-8?B?S0pnVDlTMTEzUS9nbU9HbTlXTzE2VzhUa1ZUWDIra3JSZExiSFl3by9MdC9I?=
 =?utf-8?B?RUxGUDRncE1xV0wwbjQvSFBLb01BMVV4ZURGcWJTbU13cUJOeEFTa0x6QTV5?=
 =?utf-8?B?NzkraVBwZHVxR1FkQ0dIanliR3BxL2cyRm4rL1FhUlhLNWkxamk0d2duVXox?=
 =?utf-8?B?cVRHTm95clA2VjBmRDlUdzlZNWw5VmpTcHF3ZVRhUW9UUGVBV3BVejAyT3Fk?=
 =?utf-8?B?ZHBiSWZnK1A1S2FvZHlWOGJIRHRSNzFYSHU5ZzJXQW1xaHRtV2VpZ2Z0Y053?=
 =?utf-8?B?U0tCM1E2MVN0R0FZME1KS1A3YWlrL2Q4bGRJOVpnSHFiN0VJWmxWUnphMGNt?=
 =?utf-8?B?QVZ3TTg0SnVwbGkzWU5uY2NkR1UwMklRRENZcW1ZSk1tdzVPUFZJOC9QTDVv?=
 =?utf-8?B?cWxUc0dxbjJWYW1yQmhCREl0QjVHMUR0bjI3Tzd4QmJPRTduWjFLTFYvQWpz?=
 =?utf-8?B?SlNCZUc3NWNIZHFyb2VuM0xlWGxrbXpVZUtWZz09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(36860700013)(7416014)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2025 15:48:35.0873
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 33bc40b1-0278-4975-d4e0-08ddda80dce0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCC0.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY3PR12MB9654

On Tue, 12 Aug 2025 19:26:28 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.102 release.
> There are 262 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Aug 2025 17:27:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.102-rc1.gz
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
    28 boots:	28 pass, 0 fail
    120 tests:	120 pass, 0 fail

Linux version:	6.6.102-rc1-g7ec7f0298ca2
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
