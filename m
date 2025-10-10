Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011037.outbound.protection.outlook.com [52.101.52.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14A8521D3DF
	for <patches@lists.linux.dev>; Fri, 10 Oct 2025 17:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760116544; cv=fail; b=Z0nInnHx9MnhT2h9UqDnBmFJI+PQJTOgvoUJasGaukxzxJ+xkLkWw7nYj7iMJ5Di5q1xSax3waH8qcJ1QA8Oh74F8Ht0A4dWqSEYTF+zbi6U6Y7CGTzGXDF9/28KQMV5kqYt3Sy9lNlpElNfhKL38klnoVkPyycOUTWeojg+zHs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760116544; c=relaxed/simple;
	bh=kkVtSxK0hEHTLonGYTSeCog7ezV/+UiDhGiF0XTy6yo=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=RtEfwOzzCkORiwNdVpDdQDkzzENC1yFQlpl1GPXsBsayJnxjU5rapjlEGUi90qNkpq+16h60PSylL2aHVcSJU0EsGXo+teRB/SwCogMZTPrFW5OZC6iuxS2ZDScpBrA19aOye4NZrGA/VD+CncIYU3lrbtlwqhM0Q73dRpjvpew=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=D9/NGMXC; arc=fail smtp.client-ip=52.101.52.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="D9/NGMXC"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yn/mCyqzn4tw0qyiGFxhc1iV5KGcKib/qVNtdNhmJhd/3khsCg0ICJ8/XeTHmQb3DYT2dfcAYim3D0HHvzvmBQgQmUfz1nRkaAcmpUcbtiJFUdu+7/P6ve2ooPYl0fuLBX4CuE/0mVpKQULQsymDNtBWSE7Fcp8IV/eJ2fDjLX3fpvy0gt/3TPJw5evURnBmZC1XL/eR5kQ+kSv4ANoXHKWCajHCw+wz9Lgu7g/2ECoVn1iDyXwIo1sRWo2SWjgbiMllkujyQLCeha79dT7Nluf6d5sz/i8re/niOpqqSYFUz6Bs6l8UR95y6mhUPcFd2aVdP5L2lxwbhD1ockyheQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eiwDX2EggIEPHowAIdvW/4WfQYapt0ZCUxS6D602Tuo=;
 b=LxByFpBXRnw2ky/aCtKonSNt+ZQwkgnuvRh4WJyxTun+FFsQ02VZBfAzlNa25F7SVT6jTDCSO+aKebXCrPBc7A352G/D7K0UEddpOQHqqRivBFrsjZezs0xXjJdmnxSkir5+XPm9RMafsndrdUZkdiSRKzDXPEtTY7rh31pRv1qrnOhrcAMRC9qRdVB//IBbTAfBao4XfxiHUWZBeggjEUXNUXROKPxVhTYibUaoB4ub0hbU1VTifGfCLVKpIMPEAWHtp6auaPoBzITgU+l1GJoi+AMYQ+eKcqzwuklAmqQ9Te+1IDseYjouYoPrZYf00t9DTMoV/Uuevfh+IoLyvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eiwDX2EggIEPHowAIdvW/4WfQYapt0ZCUxS6D602Tuo=;
 b=D9/NGMXCFywrUZdo33uUWb3feWJYsKk159Efj8t1uxciXNL2MxkBSy9bebkRUP71zrdsn3AsALNkjBm/S5TabxujqBWADmY/DhWzKJ/cSPhE9KBXrB7dht8oef7L0GtjkN1ooQXuEKoOWy0d6BOyI3gLf3fq7ML6UH3rvpdGKG0gA1Q7TkFEjK5aaF1Hrleyj/dUJeAezaq8St6RG6QEoja2qarFnwo3nBcCwMSHoZM/Vifec9i8TKjUmCQf5b5Hjy08/xQr//ijEWkp8QV7y45gSr97l9G/d+pC3suD+WMq9BnJZvOTroFhDTY/Amgs0J4QErxPmXDep1W8oggvAw==
Received: from BY1P220CA0022.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:5c3::14)
 by SA1PR12MB8644.namprd12.prod.outlook.com (2603:10b6:806:384::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.9; Fri, 10 Oct
 2025 17:15:38 +0000
Received: from BY1PEPF0001AE1A.namprd04.prod.outlook.com
 (2603:10b6:a03:5c3:cafe::c6) by BY1P220CA0022.outlook.office365.com
 (2603:10b6:a03:5c3::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9203.10 via Frontend Transport; Fri,
 10 Oct 2025 17:15:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BY1PEPF0001AE1A.mail.protection.outlook.com (10.167.242.102) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9203.9 via Frontend Transport; Fri, 10 Oct 2025 17:15:37 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Fri, 10 Oct
 2025 10:15:15 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Fri, 10 Oct 2025 10:15:14 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Fri, 10 Oct 2025 10:15:14 -0700
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <rwarsow@gmx.de>,
	<conor@kernel.org>, <hargar@microsoft.com>, <broonie@kernel.org>,
	<achill@achill.org>, <linux-tegra@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 6.16 00/41] 6.16.12-rc1 review
In-Reply-To: <20251010131333.420766773@linuxfoundation.org>
References: <20251010131333.420766773@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <0adb2187-7d7d-4bf9-8c52-afcd9f1ca022@drhqmail202.nvidia.com>
Date: Fri, 10 Oct 2025 10:15:14 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY1PEPF0001AE1A:EE_|SA1PR12MB8644:EE_
X-MS-Office365-Filtering-Correlation-Id: a3b137d2-3980-43ec-ed82-08de0820a1d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|82310400026|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZUVCRHZWOVZUb0ljdVg3OTFYT1RYRjIxYXF2d292aDcyQkdud2E1N3JTZlFO?=
 =?utf-8?B?THJRcTZaZzdFUnJtQk1wYklwZjNrK015TWVrQUQ4TEl1SXN4ck1MRFhNU3U3?=
 =?utf-8?B?OUtPOTc1ZG1qLzhRTis1dlRBbGQrOWpWcU11R08ybW1mLzltSml6V3lHT0hN?=
 =?utf-8?B?cVZkdmk1OVEza1V2MVNqM2xRNWNFdjgvTFNzZ1RwUVJaaFRndm9YOEltWENM?=
 =?utf-8?B?ckFTZmFUUE13U05kV0xGTjViVlova2pTVWhPQjhXWXBmTUY4cFdrRVpOK25E?=
 =?utf-8?B?WS9WNkVzeTZXRW9uRmJGRzE1RnVrVVNyUzIxbmQwZFBUcGltS3U2azNkQlNP?=
 =?utf-8?B?MFAxL1RyTFFzRHhwZVhGdjE4Z2lPTkVWd2Fpall6YlpkS1FCUU9ESUhQR2xr?=
 =?utf-8?B?WTREejRNTHI0a1dwVEp4bmhzZTlRVHp6SXRaZElyTDZZN0p2TURRc1ovR2hr?=
 =?utf-8?B?T1JZOElSYlR2RThISHBWREZmc2F5c1lPbnQ3S0RCNHcwbzI1NTAxZnF2Y0Vq?=
 =?utf-8?B?Y0JYaFVJZ3VrMlM1emdRUzlzdGxMT3FkNklxalp6ek9PVjY1eEtHdFJQSWpL?=
 =?utf-8?B?ZGF1aXJNN05HaGdqcTI2N0ljSC9Ga09uL2Zpc1dEb0ZvLzMvazAzMys5ck5D?=
 =?utf-8?B?OGQ5ZHZUcVZya0YrR1k0RU5Cd0piK0pQQzFPRUpPUE1WNlRoVmxELzdBUFhu?=
 =?utf-8?B?emc1N0xQZ0JYRE9EbXFqZmYyUy9KQW5Eb1k5YzdKV1BSdHQ1a3dWODAwWWFJ?=
 =?utf-8?B?aDJYdHVicjhRcStyUTdpOUQ0TmVKT2VaMXloclhpMkV0NDNYNFNJTGVTUlIz?=
 =?utf-8?B?L1owbFg0MDQ1SnFWcE1OLzR2WmRURkpnYjRTNFUwVWUrNkVLTE1vNEdlZFM2?=
 =?utf-8?B?MjZhS2pIbFd3bGliQUZrNkRMWEt0YmwyQzZBVTYrQXRTZGxkZFlWVUZJOGlH?=
 =?utf-8?B?cVdhdVI1NGtvYlQvTnE1OG9lNnhOemdHR0NwdGJxcnlGeFJmMi9ydnhvOHRE?=
 =?utf-8?B?Y1VRUktXaER2ZU9ES0pkRlZaTUgzVFRWSFhtTVV2Y0JYajdtZjBjcHNxTFcr?=
 =?utf-8?B?cTRSa0R3ZWVTUG91dnJaNlF5Zzh2TkRKRkNNaFBHbXNqbU5JMDBYSDJxRHNo?=
 =?utf-8?B?WnpIS3NCeTllMzdEQ0ViTUI3SEJqaVIvWnBrRFEwcmY2NjdYS2RZa0JjdkZ0?=
 =?utf-8?B?b3ZNdDFXOGx5cFFWdVM5TFpjMTF6QWJDaDBidVN5S1M1UGpGbTQvQ2ExQVRp?=
 =?utf-8?B?bVNNMnpLaGFZQ0xsZDhhRzlLY0FMNFBMVDR4aWVSUmRYQVB4TDZnVHVsalNY?=
 =?utf-8?B?cFZZVGFhSXJBVjJpQVc4d2hOY2xoSkhPdis5b0s2clRleHhHWUxxVVMzWVg1?=
 =?utf-8?B?a2thZWVaMC9jbEY4SFhySytDSlRsdnZEc2h6UENPTEZhaVpwSEsxRlFhTC9o?=
 =?utf-8?B?N01qVUFYTThqbXd0Wi9TZ0tzVzF0dzhRQnlOOEVvQWFMYTRwb3l1NXpwdUNV?=
 =?utf-8?B?cDR5VUlLSGhPS3QzOXdwNTY0bE1tVnhnenY3eTZHMjNIc0lrT1NBY1E5dlBp?=
 =?utf-8?B?VlJlcHNna0NNdHdnYm5NbDZJVEdHZUdVa1ZjRFhqV3F6Wmo0R2d3TmJJVFpm?=
 =?utf-8?B?UUc1STBiUnIxZFpCd05RZkxNcW5JS2FXUmhKWkowNncwNHN0THJVdGRTc243?=
 =?utf-8?B?OE5jeW54eFFHRm1QWWZIWG1TakdJMUYzR2hJZnVaS3FpeStPZkdDcGhYOU1j?=
 =?utf-8?B?cVpTZ1d4RjJTQm1IbEtWa0tRWlhEUzFyOUdUOWkrZVg5SG8rODgxWUwxb3VC?=
 =?utf-8?B?ZlZzWnpYVVZDOG85TGZTWUdxK243cGVUMTd3MTZjTUp6NTdxb1kwb0NleDB6?=
 =?utf-8?B?MEo4MUhDbXBXREhpNm5NdUt0MkE4YU5rRWRxdnZFL0k3SUJLRFRWZzZHRnl6?=
 =?utf-8?B?cmUrcWllNkpOWnpweDZ3Z3dRazg3clZqUE0wMnArUkE4SUowNUpyWXNBMjhK?=
 =?utf-8?B?Ulkrb2ZyS1BxaTFXOTAwVGpBRGJ5d1gyYVBpYTYwVjhHQUxvSVFrVHJBQU5n?=
 =?utf-8?B?WHdBbmRKWFY4elhIbFFZRS9sdllybFV3ai9aOFl1TkxJcjhvTWszTWMzSGdL?=
 =?utf-8?Q?CJv8=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(82310400026)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2025 17:15:37.9649
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a3b137d2-3980-43ec-ed82-08de0820a1d0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BY1PEPF0001AE1A.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8644

On Fri, 10 Oct 2025 15:15:48 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.16.12 release.
> There are 41 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 12 Oct 2025 13:13:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.16.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.16:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    109 tests:	109 pass, 0 fail

Linux version:	6.16.12-rc1-ge006d63d59f2
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
