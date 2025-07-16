Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2074.outbound.protection.outlook.com [40.107.243.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE8312F3C1B
	for <patches@lists.linux.dev>; Wed, 16 Jul 2025 10:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752660991; cv=fail; b=c8z21QxCjVygzQwbZCaL6rh8S0zViZQJE54F5K3BVBIlK9KxASsowChJCAyFOUh+FcF2Bm87ehL58Icv2+VG6wsf1xUojfzb6tEKe7h2e94kwrd8Ixdx7m4iQc8XiPbGPZ/71wnonqvHcdh/U5v9dEE2cRaPZ1zs42ux1ZPnZh4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752660991; c=relaxed/simple;
	bh=BYHhDPo3ssNjNwO5m/7wPCIu3Q2yFne76mz9JpiaMl4=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=aeGYvn91W+nWwM/U8bbKdjgst85kQvH27/P7fflmdJsr66pT3mqvzwNoxsd6zUG8fQK5+QzDCm+sDsGUcMi+O70ouCowVBIqp9BzKv14GjjBVAq6ss/YNULNwILLfMuFkVlCckTUMXQuOdiJTguWW5bxLVeQcC81cJQWMwncgoY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=RdutOVWY; arc=fail smtp.client-ip=40.107.243.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="RdutOVWY"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SBbBVctB+bfgqMoR7xKXevjZGPNBBplEtsjccselvpD7ZSbucgmFRLaGQe6Pn/zLwQDOYqLloKfSB4FggMcBKpkzduuO9+RTpECiUIfECAPqx7Q8iT1qaHhfLNl8j5SZter2MstzPdc9XqU9KueOjh49jf+PM0XRpMoqnXLBqB8x+UvpiPYFMl5HsBTPjLWzx75Sf5EIiQXgechZhmuhIj8UHoipvxxNyyiSFC1Yvv5+3Z8cQzSl+mL4K9UnrOgm9/lUbixuoEN4iw/LwyBwvdRgFpb7ew6Mi8Cih1H5zUGnMosBQWplkD/PGYr8hUTBB3rNQ02khKJtBxWFXic9fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ywiAitI2t0lUZhUlIMpjlNFKuvOQc2wE4Q6QJswnDVM=;
 b=deMIvMg1xm8ShKVshbowZddQJbPBoBdWss/B2yK6QFyInZ5S2MkIUsjI7LbQ0fREh4aBQRD6Q1G02Ar7XN28odXZNN3l5B9k+MkVH+2TXb0iLmdHgSDP50N5MeujVDzVFShmeuAF+D2k9cpP1xrEkkRO3nfAMcp6Mfm1HmnoAm27J/aQ9mAeQWf9QxbW4WeoJaeRfpTNGKczTPjy5fb71mTTBrJ5Lz28+KiWp5JatWf6qx4W3PMj/zR+Z33ZmzOY21rynWPh810Ma1RyUfTLefhnA/CwmpCAcqXTtxBAUcEu/nh2lO4wvsIhlz4ckPj8j8j9A3Py2Rtwv+NBHj6DZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ywiAitI2t0lUZhUlIMpjlNFKuvOQc2wE4Q6QJswnDVM=;
 b=RdutOVWYkLQ847xLRKGt3xmYM4awA9pTNtFKViuO4Vh1P6UpcGI9tZ53sce81U/UpM9Uicho3nOzDRq0BC42uSPALHYuj9YPZhjNcYUz9x2WFBB2UlhezBdobvvUK5Vgj+a6BJZaev9y67Tc/0XWT6jCZkCfAjSYQg4bWhiNtx3se3Qkv4J00OoyZ3+7fAb5Hc+BVoz37NW7KuoqUDs94lunMBxSv156eq60fvd0DSDDx5WW69yHuvIN4N5N42TDhuy1ixIborVo8v3iockc3Z4U2M99s51XQx7RshUu8fiBrciQoV32Nb20V7GJhlcu82C/TzXtU7FJs8TXEemrGA==
Received: from BN1PR12CA0006.namprd12.prod.outlook.com (2603:10b6:408:e1::11)
 by DS0PR12MB7704.namprd12.prod.outlook.com (2603:10b6:8:138::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.20; Wed, 16 Jul
 2025 10:16:26 +0000
Received: from BL02EPF0001A0FC.namprd03.prod.outlook.com
 (2603:10b6:408:e1:cafe::2e) by BN1PR12CA0006.outlook.office365.com
 (2603:10b6:408:e1::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8943.20 via Frontend Transport; Wed,
 16 Jul 2025 10:16:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL02EPF0001A0FC.mail.protection.outlook.com (10.167.242.103) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8922.22 via Frontend Transport; Wed, 16 Jul 2025 10:16:26 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 16 Jul
 2025 03:16:13 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 16 Jul
 2025 03:16:12 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 16 Jul 2025 03:16:12 -0700
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
	<rwarsow@gmx.de>, <conor@kernel.org>, <hargar@microsoft.com>,
	<broonie@kernel.org>, Jann Horn <jannh@google.com>, Alexander Viro
	<viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara
	<jack@suse.cz>, <linux-tegra@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 6.6 000/111] 6.6.99-rc2 review
In-Reply-To: <20250715163542.059429276@linuxfoundation.org>
References: <20250715163542.059429276@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <713dc91b-f77d-4364-9d22-89551f665647@rnnvmail202.nvidia.com>
Date: Wed, 16 Jul 2025 03:16:12 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A0FC:EE_|DS0PR12MB7704:EE_
X-MS-Office365-Filtering-Correlation-Id: 7fff1147-1b57-4e97-a494-08ddc451d2d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|7416014|82310400026|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?alhkVUZmb1dKK2FjWkgxdzhXZVRHTHdQZHQzRkRWVnRHVTRYc2ZRRzM3bGM3?=
 =?utf-8?B?Y3FXTExPV3BDSHhlUTlUbWVtOEd4UklJbm9SOXlrVXFvNDdvVHZsbTBZWHBa?=
 =?utf-8?B?VWxpQjBZdVlzRmUvZCsyd1B3b1JiMWh5R3U3L3kweitZRnF2dVZVQXhkd0Zq?=
 =?utf-8?B?ZHA4cGpRNTBOUnFDRmRJei9TWVlkUEd0RERHZWZlNm9EbFBZcndXMWdGbXd1?=
 =?utf-8?B?Z2FmMTNPRDR1dnV1ZEFoWEdnMVIyMER6OEJlVTlhWEJzOUxMV2JoRnlCOGVr?=
 =?utf-8?B?d1plUmJGaTZEWitJYURGYml1Q2JQb0xReTRuSE1sYTdLc20yQjhyQ3dHUlZU?=
 =?utf-8?B?Q2tvZzd1TjAwN05DREx0b2hkQTNHMEppOFI2ZUNTYXQ0dFA4TVlhSW8wYWxW?=
 =?utf-8?B?UHBGRng1OTBlYzhWVnlrZ2ZqWnNzWnE1aXZ0MTc0eFhDN083bzYzSTNERVBS?=
 =?utf-8?B?Ymh4dTA5UWE5OThuNURHSmtjS3hNNkFMYWlvbklJTGt0YnJPeWdvOEVzc3Nh?=
 =?utf-8?B?cmlHSXJ2d2phbTFMVFRMTXZucWs1VW5aV1RmYWxxeG8wL1daL0Q0YjJLa3I3?=
 =?utf-8?B?UGhYRzVnQ1ZPamdzUmpFdnJodlhVNG5kNG5tanhCSTlIVE8vL0M5Z05QY2xS?=
 =?utf-8?B?T2FLeG9PVHRpU2p6S1hLU3hkQmMzWGhZZnpKYWN3MXpmNzhuZ3VlQ1lPeTJl?=
 =?utf-8?B?Zk1iTXpOcWw5SFFkR1NhcWh3dUZmODMyZ2NpM3J2Y2pGVTB1R3djcFM5a21T?=
 =?utf-8?B?UDlTQ21IdEk1bnRiTzltNFdMRUlaSUY3NGwxL0ZnVjVMSlZ3ZlNLSGxpRDNM?=
 =?utf-8?B?dXl5WHBFcTVWMzIzV0s5UVoybGxCZTBCT2V3cXphdmxpa1RHV1lmUnZibnFP?=
 =?utf-8?B?dWRHTmhLMUpoYW5kTGpia0grQTBaQWR3bEUvT1BzTFQyRnJtWllya09qM3NJ?=
 =?utf-8?B?REpJVytuNXR2dDgwemlnZkx0MWthMGNOOHZ4dU1makZnd1lLZmQvL1NSaVoy?=
 =?utf-8?B?WVR1MURLbnEzQkV3QXJEK3hPUEdVcDNIYU4vM0x1cVBMb0Q0N21tZVdad09r?=
 =?utf-8?B?Z3dHOUszcUlKczI5TXJLVzVxOFdzYVhJSFBRU3FEL0R0aERRRjdsSnYrWDQw?=
 =?utf-8?B?MWFmOXQrZms1VGlUZlRuNVp6L0hnRW5WKzhmU292VGx0bEVzS2ppTlhBRTdX?=
 =?utf-8?B?endHL3lhMklqUHlVSDA4VWhOZ2lMTFhoSUZzWW83S3NtSjFzdURNbEp2S0x2?=
 =?utf-8?B?U2FmOW5HdVRpdUMxTEhkeWRJR3psQlpyRElBNmhwODB5WGorbEtZYVNzVW9m?=
 =?utf-8?B?cHVTOXdya2JtRjdGbWZzRER2Z2MvNGYybVk3cng3cHZIMWUrQ0Y5K1dVeXVJ?=
 =?utf-8?B?a1huRis1NSszby9KT2FFbHpGcy9iOFowSWE3Nnl5Sytsekh3SnNWNnFCWTFm?=
 =?utf-8?B?dmhKNlJPUEJkOEx1WnlsOE9jSkpqVk5pOS9UVVBUT2N6aWFrQ2h1dE5YdFB4?=
 =?utf-8?B?Q3dvdi81dGh5NEkvTjZDNGRkUkN5K2ZuVktRQUNucmc4VTczTG9xK2l2ZWRK?=
 =?utf-8?B?bkNkbEZkaDBDTXdBaU1DU3J6UWx1czE2RXFwSjcwRGQ0dE9JQmhSdmJ0MGV2?=
 =?utf-8?B?WnNtKzlmdnhnL0g3b2ZxWkZRbGVLSi9rNzNnWGEvUnVzRWFWWVFlNVQwZUFB?=
 =?utf-8?B?UG5yamRYcy8wOXZ2K0k2OVFmSXpVZVBsb3RWclFPSjRKK0FuOThUQXN5VGpE?=
 =?utf-8?B?RUFuSitmYU1SdWYzT012ZjI5am94SVViL0tPSEdxK051UFNWU2gweExIeEdV?=
 =?utf-8?B?RUNXZ0VMaVEyak5QSG1MWGhyWDVaM0ZaOVl1cmhJS21XUFRTeUZvaVpxUU9O?=
 =?utf-8?B?TDIxWnlub0hvMktFU3l0ZFNKRXppcm1kU1VvdnY5UGFSajhEZGRIbzU5d3Zz?=
 =?utf-8?B?R0RBTk50dFdKa1hZMmtGNXlTN01SVEVNVmp5ODlNbTFibjFud1pRcXdSa3By?=
 =?utf-8?B?ZGN0TlZFaW1xa2w5c051aUtXRVh6NWs5K29jU0tEdzlGRzB1QUQra2NtR0hn?=
 =?utf-8?B?dVJWODVTT3FwSGJBLzUveDB2WW0wR3cvM2VrQT09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(376014)(7416014)(82310400026)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2025 10:16:26.3718
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fff1147-1b57-4e97-a494-08ddc451d2d4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A0FC.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7704

On Tue, 15 Jul 2025 18:37:11 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.99 release.
> There are 111 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 17 Jul 2025 16:35:12 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.99-rc2.gz
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

Linux version:	6.6.99-rc2-g9e2d450b5706
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
