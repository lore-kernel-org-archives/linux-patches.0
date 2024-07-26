Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2058.outbound.protection.outlook.com [40.107.244.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 172DD17C7DA
	for <patches@lists.linux.dev>; Fri, 26 Jul 2024 17:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722014077; cv=fail; b=a3bw8SoCSL02ljTT8MML2NkLWX4ofkZx1SR38SBQ5n8KwCdlseoXQ15W2E9TnoOHE2tK4iqDDb4W5D2OM2LRu7qeesk5L3bp0kTrcZk+UwvrchxTulLulbmQRhDjbPggvqLjAw2GqMXr1DU7zhrtP5coHCB75+dcywhA1OD83no=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722014077; c=relaxed/simple;
	bh=JgonWANmBKNq4Zobs8w8evCLg33/BXJCwfDZtBUMoP8=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=K/TpmQ2veh284DbOxIkWlixFToADUK4vX0Ie/AuWNcsY+m4J2LAH0jQdtqkl4GZFQoLgGvYjt1smU1dgIk4vKxVjPRUQWoHbDq8oxWnwN9ELQ11IcpYEbbP4NOeqVEWxBxOHa3Yn8PbDVU2luHzVnOhveXjISkYku4ABjlrEwrU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lCEjZ9uf; arc=fail smtp.client-ip=40.107.244.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lCEjZ9uf"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Gvc5ynittfiCL0TrtKFCip6c8LuJEG7toIgWChQZToHv4UsYqG4QIjFeHA62VR2MPJ25kA5UQKUvFuSbnXyzg7lNitCeftQCoBoxuDIW7aPnIEaCcjquI8zF4UK3nPG+bz5Aa2txX264JgAZalstkhslbgkO60aNyrWIsUz4lwGM1OBKrlVHPRfWnhXtJPjY5n0WcmvMIsyJLAbcw7FAr/WdWM3qAhH5VLIWL5qYPeTjy66z7DuyWE9p2jEhSSY0wdRvtPTVvzPTJzA7jzUznNKXTSoXLahdphEC5YT/srRN0pU7pb2tIN3LWlINBTpmC7eUWBDa1ATcFVpHz61PsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e/dnQ70uL+DgNgeBGkx+cvjebm+1m4ZKf9c75pIzJs0=;
 b=S5xBAB/QO+yVKTex9bjajXbLvS9S2J85G7gIcvGMBR+qEP/cV9vMYFzgj1wqpSRSVqAb/rxmm8fxdfNydmUVQE/+DVCYL8+FWDCjW7CGK5gP32l2OUswzVdPhrP9c/IwNzsZQczebWX5fkkSFFmb9d9S6LdnXu6aHmw9dJ/KN0ulXULkidGS9drP/cXwFHX2L+0kNTmaE1KLingYz3DvfrzPHQaLvqPTWjy5tTQcAPaXfY8CeVzQ2MG7iW5T2IoAMmbfrDfXcbtGrA5ztjdmycH7gF1ry2sLCdbiux6ginan5TN5EP//AOAJDRCfUUrBbeOCWj+ZxieIyiiuL/NmRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e/dnQ70uL+DgNgeBGkx+cvjebm+1m4ZKf9c75pIzJs0=;
 b=lCEjZ9ufqXmoaYa/Jx57hOuMN9bJkS6XcIIWdivFudbhAV8vntsiORZzGvUFOBcZJYqWcC/FISDbjc0No0mr8aEgfyvA+OpGJ/AXK0QIpV1ZAmbRi7RNKgoKdQSq+mwhhwJ4IvHahpttz7C7b8UswxxW6646RCb0FB76GODJK5XjDwjhEKwLheetf7cBMlZHa0GICpvdZ1yLWPqIbYw6DwsATK5samdhWrk+Gbjm5eP7TyhGNnRGYFYJTmTPFsb1j6ZhEtXqO5Xf07B4CCeGdTpvEQBf4CBObmO5C/fB9rlBtBL7r3ac88uxO84GWcgUlZ7SZFH8Nitw2/VCFGp05Q==
Received: from MW4P221CA0004.NAMP221.PROD.OUTLOOK.COM (2603:10b6:303:8b::9) by
 CY5PR12MB6228.namprd12.prod.outlook.com (2603:10b6:930:20::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7784.28; Fri, 26 Jul 2024 17:14:32 +0000
Received: from MWH0EPF000971E7.namprd02.prod.outlook.com
 (2603:10b6:303:8b:cafe::7c) by MW4P221CA0004.outlook.office365.com
 (2603:10b6:303:8b::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.20 via Frontend
 Transport; Fri, 26 Jul 2024 17:14:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 MWH0EPF000971E7.mail.protection.outlook.com (10.167.243.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7784.11 via Frontend Transport; Fri, 26 Jul 2024 17:14:32 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 26 Jul
 2024 10:14:30 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Fri, 26 Jul 2024 10:14:29 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Fri, 26 Jul 2024 10:14:29 -0700
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
Subject: Re: [PATCH 6.6 00/16] 6.6.43-rc1 review
In-Reply-To: <20240725142728.905379352@linuxfoundation.org>
References: <20240725142728.905379352@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <49315694-da12-4493-a496-ab47fee63b46@drhqmail202.nvidia.com>
Date: Fri, 26 Jul 2024 10:14:29 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E7:EE_|CY5PR12MB6228:EE_
X-MS-Office365-Filtering-Correlation-Id: 85323be1-24d6-45f7-cc83-08dcad966a75
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?U2NnaXByektHTkVCVEhaSzV0OHBSb1dBQ0V0MFExa2tYdlpKTm1OdDZDWXFI?=
 =?utf-8?B?bEpqckJhYVVQb3VmVkt0VS9sd3NPZUFydEpyN2s4Y1N0M29DZUQ2ckoyV1M4?=
 =?utf-8?B?VGMxVWowQkNzeUNvdTNSdXdsclpLRGRBRzN5U0VKbVlDZUc0VUVrVHJJaWcw?=
 =?utf-8?B?T1dIckd4QnNWU1VIMytQeGh2R2Y5c3VDNnZuL2pXRHVCdVo0aEhrY2JWMjRN?=
 =?utf-8?B?aUMzOHZrUlJic0kySGwvVHJxdWxjVlh5RVhFQ1MwSDNwdXlkbmJiZTI0V3Rt?=
 =?utf-8?B?Y0xId3lWbU1OaTU4b3NISFBua3hNTWhpdU5wZExDNUxoeGF5aFJUWEZFNTBU?=
 =?utf-8?B?TnY5S1hjSW42WVRsMTRjdXZXZG9zQS9NTi9qajdaWXNaSGNEWjRheEl0Znht?=
 =?utf-8?B?ZmcwblVSWWR6bW9VVmdjV2pmR1lnL1FkV0ZUQytZMTFlRzE4MjZTbWVRNnNY?=
 =?utf-8?B?NGI4eHRHOXFQcmVhT2MwMW8wN2lCQmUzcmNEYWYzRnRNWW1sYm8wOGRSbGRj?=
 =?utf-8?B?TWFMclVoM2Z1WHR1ZFl3alBGVVNiV0tBWmlMTlpsZDdpV28xVWlaMjdtVEM3?=
 =?utf-8?B?STE1bWlQYWNkSlpGdlZUbkp6TlpvY3ZqNUZBUTNHdlZVRU95N3ZtQUJFb1d0?=
 =?utf-8?B?ZDVDMEpYWE9VUjZmQ3o2NEFsYy9Dbno5a0NVS1o3NGQ2QWhNb2RCOWFyUU10?=
 =?utf-8?B?Nmg5L2EzQWgwMzl0T2RNSDVnTk9hOG9FTzRFb2xaWUJaQlJWZFZ2M0ZIRGR4?=
 =?utf-8?B?bW1sSmVrNEdjYUROckhpSmttU00wbG8xTEdzVWF3ejk4VGd4R0F4S2xrNVdN?=
 =?utf-8?B?bEJOMm51b0VFR1hHVkR5QzZsYnBxQytud3Z6bkZaZEhZbUxoUlhrejAzNHFR?=
 =?utf-8?B?SmpJL0UvYkg3U0JpVmowMTNzRERrQUxWbVJITEVsMWRHdm14YkJPbVAxNnp4?=
 =?utf-8?B?MVNJOTNvMTRZWmJLSUU2Z1JRSUtpdEdVSEgvT3BOcm9YcUhxOUtNWVFvOVpB?=
 =?utf-8?B?MTdqMEdKNXBhY2IrUzB2RzFrRDI4aC8wcmRNWEJzcnNjdzcwYmtlQkErTFFq?=
 =?utf-8?B?d2JJUi9hdithNjNEVGVtbGx6djQ0a09BbmlDbE81bHZlNW9RU2I3amcrVzJV?=
 =?utf-8?B?Q09aVDI5aVJVK0Q3a3E5MEtpUkx4WnpWWG11NWFIZi9DZVlybTZQQ09hK2hG?=
 =?utf-8?B?TWRiTXRobG94c1JNSlRtUmRGbXlZTXFIRm9EUVVWaXhpQ2hwa3FIZWRpKzMx?=
 =?utf-8?B?RlBTcE1YUFk1d3A1Tnk4akpYa1FJdTFkbGRNN1VycHoydGVuUTlQQ01mUzdU?=
 =?utf-8?B?VlRoVjFadnYyZllUUDNpeEVvSHRpR2t0VXk4aUZRZTJlVldXY1E3d1p6cDZq?=
 =?utf-8?B?RGVDaWxXdndEU3dSSGUzeGNIRXMwQzU3R0IrZjNveHJUUTJ0Szl1Q1FOR2RV?=
 =?utf-8?B?cmJ1b3VCZ3pUMEpiYmdUZTRmZm82Rm4wL1JhaXM0dUxGa3JRcldWUFg4TFJp?=
 =?utf-8?B?REpLcTd5dWxEN0gyNHRJbzFPZ1paeTRLSmlpYVF4alRvWFU3VDRzK1BXZTZN?=
 =?utf-8?B?UlBKOU9uOXhuYS9Xb1psc21kTFNzTVVBRzJFWHp3WHFnd25LZjBxZmc3QVdB?=
 =?utf-8?B?eFlwR1VyM0xwODRaTjBmQ0hmbERvZ0RVVE9XRitSNGtzVThLejBNL2p6aVhs?=
 =?utf-8?B?Z0o4N3I4bzlSaU5kZG9tTEEyR2pPYVZQQW9CdDBWdTZSbUEvTE42YzUwME92?=
 =?utf-8?B?Y1pkUWFQa1F0bDlXUzlQUkZ0TW9PQThUcUdGc0VnK21KNFJ6WnFlRmt0VFNv?=
 =?utf-8?B?WEZUT09hWjhJTHBTM2sxeWpjRHY3dW5ZWGgyR29nNzh4S3paTk9mRE9pTzUz?=
 =?utf-8?B?N1BOcmNKTFpKQ29sZ1BrZTFhUXRiaGVoVVVDU1pFWXpDUGFPTmFOQ1FuVzhq?=
 =?utf-8?Q?Kh7/ElVLxx+cUctWyqftiBfItTX4095Z?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2024 17:14:32.1791
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 85323be1-24d6-45f7-cc83-08dcad966a75
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E7.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6228

On Thu, 25 Jul 2024 16:37:13 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.43 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 27 Jul 2024 14:27:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.43-rc1.gz
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

Linux version:	6.6.43-rc1-ge83c10183573
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
