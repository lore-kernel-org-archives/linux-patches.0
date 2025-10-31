Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012014.outbound.protection.outlook.com [52.101.48.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E8862FC01A
	for <patches@lists.linux.dev>; Fri, 31 Oct 2025 19:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761939322; cv=fail; b=gfNmrP0SEAl7Lm1SnYP0NQrX+1hQHnI3aCAezBydHcam9bDRPkDYvppNRxtvuqcRG3+wMJWab1q3NJsY6UZrJ1EjJ5Xf+Tg8qDrc4gxKooZD4BtUjyQSS2GR5FqToAonMR6QB3uCpF/krPRGaAina/PTpvDutODXDzKizA2NdxM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761939322; c=relaxed/simple;
	bh=sP6PmtE2i8zaTGDkrD+DM1Fkm++F0nlNt3KE+L6dT4Q=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=oeEVb6FOOAzzz9xadq9s/biyW7gSjBnAP9PFADJnMZ3Rct7MpH4E/8P0o1X06oP2WMOxf9YE07L28VepIn/tKitSYW8PHKF/L7GkQvZ7IjHAOHHjyNB0Y+4aAA8SlQkrUg/JGp7mDlPJ9I9njzfQueDiU7yKC+Q2mU89Hrfe1TY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hHar/7/O; arc=fail smtp.client-ip=52.101.48.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hHar/7/O"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TPwW73AZNB6XaFTwsVjT18rKZ57XRKarKITcw8Ulh/0+i//46whyPUm34Dbw394cjU7ZVKwtqSL8MVSIij2Cyc1IFCjTeUX+I7zYpfzIQsuCZyhYkf/imgXGaW03UEMrKkjZcbC8J2s1VnFvjHxvLf0ffRMsnVAteoxNtyiVPkiBFuzGIBgPaUIcoPdK0yAtYQpiB7+/zk0Y+BrmyxX2JaWno/cechEpy6BO10p0hS2w1i19mOVslSTkv1a1NaTvt61J3gF4Ppt7UpiIXaRhMbJiyt6ZaZXh+te+DcpQcqqlvwX5XjtwZmG2g5G0y9UUG0n8ZR7N4fSKhhBce7lIkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tmCJDhZ+kx5q0RrBrK6k3Z0OXGoWErGvqs2QScYGG0E=;
 b=uFK1s3PMhMCdpwmOUN4qUw6xofULmKlbc2N66keaMbHPI9Hehi9BEz5TQvpbqR2knJXBU8ZHyGQCVc4my6YcQ+e8ey68j60FB+nkw3e8KKhZtQ6ECKg1dq9tlPPMB2z740oKBa/MJzI7tE0eiZOsaWCxd/OYvRZyJkJgVlBD6wLAKftm3coXm4vyOzlm138gdQzLBps/DgCRifmBa1Yj6uR/KUxsNRPxGgvZiI022dv8BeUVBXiiPzIMgDzwiO2/TilCwXtFH2rER0/EGfUiq3rR2jzH7vHZdEdj0M1gsMUCoTThsOL6GzZf3Hk+RctKplCfEx8PksxIelrYnqcgAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tmCJDhZ+kx5q0RrBrK6k3Z0OXGoWErGvqs2QScYGG0E=;
 b=hHar/7/OajWOIySChybOgp/cIrsiVdAwsQnkWmE2htAsIKlnOAjUiCGeAtiC5qT90eSYL8ApwWVIE876IgmShUCjFEdy02vpWdhM7RzZMOCqBTE6gkKgVAsytkmN64D5D+nMaEhyPOzr8DeDZ4YPv3KM6Cc5sXmgPDLKcH6ilp+aMIELHzb2OTalme9nXJLITke2LJUgtEZI0s0G/YKyaJva9ZwTwa5kIjjqsQLerZl4h+lRl/0a+d5vtBua8fBMvz59a0TfQy3ns47mNuvYwYtjcPPFpK8hQ3yhFxs+LFfZO1pLPrAZyTyumtE716XfLBuDmQxLvh9QXBVwfKGlcw==
Received: from BN9PR03CA0772.namprd03.prod.outlook.com (2603:10b6:408:13a::27)
 by PH7PR12MB7282.namprd12.prod.outlook.com (2603:10b6:510:209::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.15; Fri, 31 Oct
 2025 19:35:15 +0000
Received: from BN1PEPF00004687.namprd05.prod.outlook.com
 (2603:10b6:408:13a:cafe::34) by BN9PR03CA0772.outlook.office365.com
 (2603:10b6:408:13a::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9275.15 via Frontend Transport; Fri,
 31 Oct 2025 19:35:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN1PEPF00004687.mail.protection.outlook.com (10.167.243.132) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9275.10 via Frontend Transport; Fri, 31 Oct 2025 19:35:13 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Fri, 31 Oct
 2025 12:35:00 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 31 Oct
 2025 12:35:00 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Fri, 31 Oct 2025 12:34:59 -0700
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
Subject: Re: [PATCH 6.12 00/40] 6.12.57-rc1 review
In-Reply-To: <20251031140043.939381518@linuxfoundation.org>
References: <20251031140043.939381518@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <615150b5-fbc4-483f-826c-ad1357573acf@rnnvmail204.nvidia.com>
Date: Fri, 31 Oct 2025 12:34:59 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00004687:EE_|PH7PR12MB7282:EE_
X-MS-Office365-Filtering-Correlation-Id: a9c82566-d80e-43b6-d7d5-08de18b49d0f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|36860700013|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MVhpVVlSL1pXM2xnYVhMbHc5N2FyL2E0eDl4MTk0RnFUWkpoZUV1cW8xSzMx?=
 =?utf-8?B?TlBwcmZPQ3cxM1RxRE5NcGFiODZrb1NWc2tRTkl4QVU5Y2ZhTmJMVDBVaEtZ?=
 =?utf-8?B?VE9NK05JVkdncStmWWZqRG1MTzhVVmNLYU1vV3N5NDZlRkg3c1RLNTIrL3lo?=
 =?utf-8?B?Qk0zUHdQdlpIUDBxemZoNFpGbzBxaVU3Rmg0bDdOaWNhaktoMTZWdUMxV1Vl?=
 =?utf-8?B?RUlSY1FZbU83WVcyNTRuSmNYWmd2dlhnaGdyRCt5L2p0THJyaEhKMXBPNTRM?=
 =?utf-8?B?WlM3SFFObnowem5tZWNDcUk1K3RoNWRFSVIxbXcrMHRlY21oRVFhdVB1eFk2?=
 =?utf-8?B?QURtbG51ZGtqcUhqWWY0c3hVczE3N0U2a0xlWStTdTZZNHlzOXI5bmJ4bDNL?=
 =?utf-8?B?Nkw0aHNIZk9idFNJcnkxb0RkdVJiRGd4SkEvWlFzYVpjeVNtbUZ0T2JFR1BG?=
 =?utf-8?B?bldGaFJ2UE54YndKcGhkcUF5K3FsdHFHVkVheGJSQnhMTEVhNzQ3VVZ2cGNC?=
 =?utf-8?B?QklGSklVRmZDV21nQW5laVdFQVpzZFJCRFkrc3FsaXdtdklEYWdVU3pSazRC?=
 =?utf-8?B?UHBNY1hkSWVYVlVrbVI4TERiTVZTcWhJL08yOXFGWVZjeXZndkcySnFVLzRW?=
 =?utf-8?B?dm8wUzhObThJL3lhZlVMNlM0cGQ2LyszRWtZa1M0Rm9IdVlCcHI5dXRNZWtK?=
 =?utf-8?B?RGlFM0dXNkxYQjZ5NUkxZnhMZWsraWt2dkllbmN6cXV2aVgyNm1qVGNDS1hs?=
 =?utf-8?B?YnNiN3dqYjZMSnQvb3VVNTl3NWQvbG9ORnlCSTdSaHRVOEdqVG10R245STI2?=
 =?utf-8?B?ZU03QkQvOGZpdVFUTHFRQ21HdkZLajdoZWNCUzdWZGdwR3YrT3J6Ty9NeWM0?=
 =?utf-8?B?YzJuMkRITlJ5VERjemhwRk5obDFVVTdRellsellUb2hTTUhLdTY2SEVWNWpm?=
 =?utf-8?B?azZ3QTFxQ1AyTVRoUUpDRnBWempoNjd4WSs0U2Z6dVNLRVAvVFRuQ2tEdmQr?=
 =?utf-8?B?UnZaaEMxUDkvQ3JiclplcllPSFhUR3BaNEtCRzhIMVh6VUxTWCtoQ052SHdx?=
 =?utf-8?B?OW0rYmNyenFWaWl0VGE1R3BhQVZWSFlkNmpkYy81YnpKaDMrSzZWZzIrOW8v?=
 =?utf-8?B?dTcwcjQ1TkNVZllvTERLcVlsaS9GbE43eXhCazFoV0o4Yi9YbStmQkV4YjFC?=
 =?utf-8?B?bkEvcE8zYUFJY3lKQ2Mrcnk1bk9VK0FFSk0yZ0dzV0RCK05SZjNQWXNmYlZI?=
 =?utf-8?B?S1k4aE9VbmladnlPd3hrQ2hmVnpZTGZiSnEySWp5UjlEcS9ocVVNU0g0ZWxD?=
 =?utf-8?B?cmh0Y0s1NnlZeCtYMys1UUI1ZEUvZ2FNNmVQMGs0QlJJN0NtN1pvZjdRcFht?=
 =?utf-8?B?ek0zNVFPVis5cnM5RlZzMjBmZi9xVkZHYjY5MExLdkNoSTJWWGtGRUpRZHA1?=
 =?utf-8?B?bCswejlFdHRydEFYZ29TcDFEbGZnM0Jtb3hwR0s0MjFDUTZzY1VnWTVuTy9a?=
 =?utf-8?B?eDZrMnFRR0Jkcm9SdmlnOVJ2b1dOK2l4MTRuWS81Ull3WGtoUzhMVWRuWkla?=
 =?utf-8?B?dXdFSFZ3V0lpaWxpZGs3TFhURFg3ZE1yUC9EZ1VHcDZnT3NUSXhxbWhzazJy?=
 =?utf-8?B?Tm91M1FzbzRCMDMveDRVeWRkL1F0R0FLbjlzN2NXTEdGS3RqeGRjcjVRYnBp?=
 =?utf-8?B?NUdoNEVGS1ZVZnd0SkFnQk5hcVpiSVJHMjFiSmtkTlA4a2Y2cFRiQmhIdWI0?=
 =?utf-8?B?Q3BtVkdDZ296VkNkWHZjVFFCd2NBVktUWnBra0dvbjBpeTE1anYwaGFYeGEy?=
 =?utf-8?B?Q0RtdzFZZlFkb29qMVBOd1I3Z1Q3RDAyOXNCSXFSWmozYVhLbzA4d0lXQUhV?=
 =?utf-8?B?YXE3M0FpTFNYUzhLRm9GUWlVQ3V0VGVERlVyRk9sZndVcnBZUnZnakJsSkQ0?=
 =?utf-8?B?MmZWSUh2VjA3d293ZUY0RmFzY0Nkb2p4MU96Y21ibTlWQzhaTFlKV2cwemNo?=
 =?utf-8?B?cmpkTVEzRnc1NGJYRlBDR3JDdWY1SmtDaXY4ajJHeEVWU0t2KytXZFg2ZjZT?=
 =?utf-8?B?Vk5nQkZsbDEyWHdrYUNuYUhzcHBQcUpiY2QwYXFTZ3JhWGxORXRqVm92L3h5?=
 =?utf-8?Q?qLLA=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(36860700013)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2025 19:35:13.9680
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a9c82566-d80e-43b6-d7d5-08de18b49d0f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004687.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7282

On Fri, 31 Oct 2025 15:00:53 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.57 release.
> There are 40 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 02 Nov 2025 14:00:34 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.57-rc1.gz
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
    120 tests:	120 pass, 0 fail

Linux version:	6.12.57-rc1-gc3010c2f692b
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
