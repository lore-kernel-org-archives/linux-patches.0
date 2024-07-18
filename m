Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2063.outbound.protection.outlook.com [40.107.243.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2F6B12E1E9
	for <patches@lists.linux.dev>; Thu, 18 Jul 2024 09:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721296353; cv=fail; b=GLrmrwgokTkRqtV1hJ1tjwkQrlBy5f0fHEuzO/sVW9X6+IIcaExDbnKEMlmGGS1DX7qzXGR+j29+bXgYhPBbahExl6ZzS+MoagD/oGqPdb99HL6nwq8AfKK+Ymn6x7vgiuyiPlhhjQNoEbLEHsyxa5ndcZ/AkpQcwvX4APeQVk4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721296353; c=relaxed/simple;
	bh=kM4AyFEPYRW/K248tYGm5eb40BEs/m6ZOAqO6BpP0dA=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=TEGQahzHBJJ+99ZoLvIrfA+wEuuyhBLgJQHYul873RfLbiu7z75pOKBJ9eFTuJbwbjGkVnPe7g4TJ4YZhpBYZjwtwNSCVMMA0qGzWNzlFNYCeDYd/mOsjR4719Uqu7J/SPN7Id/oK4s0L7msbAZ5Z/KjS+V4b4BtiCbSt96Iwlk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nyFgLsYV; arc=fail smtp.client-ip=40.107.243.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nyFgLsYV"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B6g1ElQ2CFS+mta5x3vQp3J8EHJQs5eokBUq2z/76bE6tqm/t3ubBFHVMDsyTr6wrXKcKSd4cKbIac8rTmgaKajjhXeMbHEEjUeNConYLOq3HaDjCz4AgN9h0DEanYVEKBUGp9RHiDSJNvMETxchU8IKOSHExVzUXZRV8nrxhEFtEXVpF2M15MfPrz3RAhMX60jvqzQoAH1/cVrznO6Owm0sa2h3EsRHvdsaN47mXFe3j4sUewwLJ6TdWp/zbn8UlWZUIWUOtZFJ9n/bcMICv3LgLSKmEN6quIfoA68q1whwjltZKCmUwXFhL2i1/B/JeaA/ns7qZrXyYWUZHkuH+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RXAd3wyYyYrFT6pdBTfb6hOVx/cXPUM++6FszIbE94k=;
 b=tCcz+Hs3stDKL6wv5ifu7VXnugo4pNby0q0fEQgnrM3edx8ktz1D9blWBv5qhvX3bkp5zhc9X+rD2//Z7qxESsgjIt2b1LAVkjmwiFalKpa4/4zbofJ+ROOK1z5zHG9nf8L35WmYiAD6a9tIGg79Gw7f7BFU5qCrhZbORF/564CTBMGlPGprvLcDBhEs1O23K1xd3jbCDYka+hQ0I91hxTPm6zPHpd/LykMcrRbVs+b86/BeTw8mLow7nUZMhDDVULW6f9jS2VHhmL5K/VHm65GOnlufd/1QIT13nbqP9XkljEOydu2EPnPwXqr9AcnC1JEmx88zHsHynJzc8ryIvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RXAd3wyYyYrFT6pdBTfb6hOVx/cXPUM++6FszIbE94k=;
 b=nyFgLsYVCgqN73fJmuagSeeEgwaud8jLLNaeGJIArcTFNcUD8n1VeFJtp3JC9EfEclS7HvVRKT6HZt6uLvS/xHAwB5fWnzMpjnsDVwVVehXEPFZAIAB46AnMkwPVT8gJ7zzTGu5JzZ9AqDxYei2yj/HEpvbRizDaTAn/A1sOwBROWWKX5ce0UEE/gQx65amk5fquzO6dvlS3si1oWroElXnOS2L/GyrObjX5AapBMdwlF8Dxa+AM9GFPbAAKpA5h7Kz73fIKbsldsAeqKhRXOJLki2vCq8o6Dhmf19SV66UYSXBGEPxc0eTAECKjR9A/wRYT8Z2GZdNfphvsuCKTLQ==
Received: from DS7PR07CA0005.namprd07.prod.outlook.com (2603:10b6:5:3af::15)
 by DS7PR12MB5958.namprd12.prod.outlook.com (2603:10b6:8:7d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.16; Thu, 18 Jul
 2024 09:52:27 +0000
Received: from CY4PEPF0000FCC4.namprd03.prod.outlook.com
 (2603:10b6:5:3af:cafe::11) by DS7PR07CA0005.outlook.office365.com
 (2603:10b6:5:3af::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.14 via Frontend
 Transport; Thu, 18 Jul 2024 09:52:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CY4PEPF0000FCC4.mail.protection.outlook.com (10.167.242.106) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7784.11 via Frontend Transport; Thu, 18 Jul 2024 09:52:26 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 18 Jul
 2024 02:52:17 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Thu, 18 Jul 2024 02:52:17 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Thu, 18 Jul 2024 02:52:17 -0700
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
Subject: Re: [PATCH 6.6 000/122] 6.6.41-rc2 review
In-Reply-To: <20240717063802.663310305@linuxfoundation.org>
References: <20240717063802.663310305@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <82d8f6b3-b3f6-4bf1-8819-b5d473b144da@drhqmail203.nvidia.com>
Date: Thu, 18 Jul 2024 02:52:17 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC4:EE_|DS7PR12MB5958:EE_
X-MS-Office365-Filtering-Correlation-Id: 720fbf14-ad77-48d7-be61-08dca70f54eb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|7416014|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RFdhSnd0dENWQ05OWUxoYjBmVmlrMVdkcUZPUllxeXRFUWsyT21meFFHRzNn?=
 =?utf-8?B?MVFva3NlelZuSVg2TVR6QnUzdG9YLzRPcGlaaDlObWdHRmloQWZvZjV2cTVV?=
 =?utf-8?B?aWdUdWoxMU55aXhSU2hEWkR6eXg1QUV3RS9JSi9sTFBUenpUajh0dVBEdGhQ?=
 =?utf-8?B?djVRTDYyUjI4dC96ZEhhejJ4VEYvRHdiOERnSlF2b25tLzcxYjJFdVJtVTdU?=
 =?utf-8?B?cDl5MSs5ZlR6eS9IenpFbXgwa2Nad3RheEgvOE5yWUJpajNNTTl4ZVB1MmhU?=
 =?utf-8?B?TUMxejdmTkNHUUJIQVNSQTRhZTM0bEthV2JNN21XcCtwRW1tY3NxbTZnVE14?=
 =?utf-8?B?OVpMZXN2MmttM0dIcEpzM2gwSlNYZzAvVWI0M3F2MlBUejVsc3JxbUtMZTRT?=
 =?utf-8?B?TnhVdS95Z1BvL2pWbng4eW1kcytmN1d3OFBJWUZ1cjU3bG5oOXE0RzdFTmZD?=
 =?utf-8?B?TFlmaUplNGVQN21GdmliY0Z6Z204ek1LeHdlclhkM2Yya04rd21RbktSVXY4?=
 =?utf-8?B?eWtXTDZvVElEYjkvdHBHSVhDUnpjSkxDWmpKVG10ZDBzZ0w5VTk5dll2KytZ?=
 =?utf-8?B?MzFTeGxPdm1oOFV3c1Rkd0h5c2dyV2tmZU5PbEhXaitnSVJXdVZ2TnBxdzRt?=
 =?utf-8?B?V2JPQXEzK0ZaY0FXVEJPNjkvdkxrWmlQWVYrVzIwNmswWXZ2ZDQ1NnlnSG5y?=
 =?utf-8?B?OUhub1hiV3VuOEF4OG9oTnZkNGhsUExhVEdiTVJ5LzZSVjlaY1MvemZ0MzFz?=
 =?utf-8?B?ZTVWZXg1ZTk5V2NzZ2IxTEZpWmoySVRvUjF0Smp5OVRnTlFZZ29ZU05JYUZy?=
 =?utf-8?B?WlVqaWRTRG9IWGwxWHVxZGc3emhwZFNGQXd4c0JKZHNRK21aNThsVGRxQURp?=
 =?utf-8?B?TjdiTVJveFIvVi9HQ3ZKNkZMZHlpRnBLR0dYY3RpcUJiMVZjMEhQTzhIRjFM?=
 =?utf-8?B?ZG9nK21UNmExTEFuQXp6c2NBeXM5RFhnMnFNbVlVTUxCSEhXVXRJSlg0M2lT?=
 =?utf-8?B?NVo3TVJLYkpCcW1haWxCZFRVWlVaT29BTmVVZitpNEZIVFVNUUZhTE1qeWJt?=
 =?utf-8?B?c3lxL05vRDRWSDNycXYrWHhHTk9NQlU1Z240VVUvNFNLTGJVczl2cTFuMmlT?=
 =?utf-8?B?amdPSElFN2p5T0ZSOW9RYmc5Wkl6bUdrV01pTWY3eTlDUUdDa1FWem9vYzhn?=
 =?utf-8?B?TFg0TmJQb1U0eUtIaDZFWkdWYnpGNysyODFhVGI2N2M2Z2YxT3pGTm9IdDNn?=
 =?utf-8?B?OUJMaFZDR2tCWlJGMHhrTFIrdkJ5aURvUE1Cdmh1emxZNk1Dckc3cENET3R2?=
 =?utf-8?B?SFZSdlY1ZFMyTEwwdVNUL3hUMUJRYWgrQTJyVStGUUEyWU8xTllWSlFHLzN6?=
 =?utf-8?B?akJHN2tlaW1Fa3NqQmgyRGEwbm8yelRKRXN5eElZUHRkS3o1UU1lSDNQMFZO?=
 =?utf-8?B?dDhYcTJxdHBTTXBjUmp5ZjdtbzBCeGl6UExGbGNVMjdQNysxeGlmSmRmbTQ3?=
 =?utf-8?B?M0Q3RDRHcG1PWjF5MUVHbmtoZG5NeHI2YXpkWjBNa2w3Tng2eFc4bk8yUld2?=
 =?utf-8?B?Q3NxNTJVaTF5dFBqbDN3eFpYbjhqQ0FaUHdkM09zVEY2cVBGNVV0d05seUZ6?=
 =?utf-8?B?QzFMQk1DbExsSm91UDV1UW9SQnMyb2J2ajh6Z1VhSlI4TlRMaVhJVEN3cXdN?=
 =?utf-8?B?UXpJODRvc3Z4c2NvUEptdFdYSHNieTJJZjFVSUNQcjhnZ3BrME1VSlB3QkV0?=
 =?utf-8?B?NENHZ2lxQmNRYWdSM3NCUUpVS1NiRXRzWU5Ycko0bTI3RmpObnVWekdmQXdi?=
 =?utf-8?B?bEw0NHVJWDQ4Mk5TbU8rSXZ3ZUozbTFNYVlhVzhoTURPYWIwRUVGS3JGakJO?=
 =?utf-8?B?ZGIvSmZURGZ1ZHlSREJJRG1FUGJ3eTIyelE1UTV3ZVNUdGRGTmwxenRLdnFU?=
 =?utf-8?Q?M2IsqhIoGhZfe9fIf/FHUW+AWmLxczGm?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(7416014)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2024 09:52:26.9757
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 720fbf14-ad77-48d7-be61-08dca70f54eb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCC4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5958

On Wed, 17 Jul 2024 08:39:51 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.41 release.
> There are 122 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 19 Jul 2024 06:37:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.41-rc2.gz
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

Linux version:	6.6.41-rc2-g6b4f5445e6e6
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
