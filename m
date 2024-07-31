Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2052.outbound.protection.outlook.com [40.107.220.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 722751799F
	for <patches@lists.linux.dev>; Wed, 31 Jul 2024 16:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722443334; cv=fail; b=C2qwfz9xXcRVCsefFOU7mdHJD1jTHSy7BB60BgN9LB1kI1bhC2kSF+1nHWqNMx8RC1lEihiv1hE3pFDhwL7yWlArf8lgwrBf5XnGDSLFqMCoTVd9vZ/+6eo8lGJ/PnXfX6lWrHR+lYWDqu84EZO6FUya8jNhDEg9MU6daHp0Nzg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722443334; c=relaxed/simple;
	bh=d3lUjivM5eTo4hCnLENRI+CpxRp00fmwU6wPcpI8FdE=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=WhnqLQAybHt+teXcz9xugqD+q1InRdp1UoGJoDgSqzAgvpgnhnLsvK7/n/9aczifx/AZwOA74OWrSnEehAmAtdsqiUh7OH4x0DZQEkoghk9ihLB2kPlhq3Gc5LvuvHVYhijK9E+U8jDKRybpZgTcNynqk3cI+uoQd05REGX1A/U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ePR6w0jU; arc=fail smtp.client-ip=40.107.220.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ePR6w0jU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tUwYSIZ7oQ9EVt7aqqdnz3Eup5Ptd1I2XOpLB7Jxcfd0gf3CGFFNiPH8nb3mIKkXKtTVg7scfiodkiucwdiWZqjuGCY+rqLtQHxyvhR08d0xLVpBkLGTojcZ5009u2VnzBxBw0lSJ0dXS2TwMCHFbgsQMYsRbR3ui4FxIha3grT+VYev/TvKJJJElK1FfgtoC4Ff+KWVIFKZuT+2gZQVM107pgepSUc2JJT9IaccYjwVQ3DMBFbkuEp+Yo9i3S7ktJb7Wjv3B8Bt4sasa6yhlrxO3kT3UFP442tVrHkTz/tNV98CiVjnLdak6zUnbiqzg9Fz7qxSvQdSyZg4EwysDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=blTY2mdJ9rQHN5B88x89UGxAaUoTNunRHxZZt7QZZuw=;
 b=RscvpRccvKYuGIykw/eAq2hYHS/NPOE1Oxn5r8CDwLoTVniRnr//Y7zRuuCcwQHY2wcrifiIR6s1TaC0OZg6/pKtTt6R0UJZVhRgC8dulhZNHFlUffL4qwH2WIX2MRTGD71SMdLftupkzi4j7RW4t0zK8jiAwcoLlEMJnGpBirc9IAN+s8/MZp6Vy3FyYbFqvLtG5BVqOsu6m7UhzodYxmRhKIcPa+KG1oJuuV/CIv7xZMmgJCUJo9cFJQg9tOJAE6yjm5h2X0flHuc173Jtuh92DDqW9T2kuCVXUxJAjVoy1Y7znuokwBUNLHRR23R8JvTIUv1BgaBvURPALbu1dA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=blTY2mdJ9rQHN5B88x89UGxAaUoTNunRHxZZt7QZZuw=;
 b=ePR6w0jUR3Z5SLjSZuOJfxHXx/2NFnjl8Pc26bmYe1pupVmhRpSkw96oe6ofbRbdWhm1gX20C4DeW5K4A5KLt+aBeCS53xiiDqI7e3ljQQr4wi5xxngw20S/6Lc2TYWbRxO0lYd0nvH5uCK7i/f45SQKZMEU5SgTvrt0z0Lg506Ch/5sUIPhrvS0hnjgL8W3klWK/4V6EENMnqeoozKr0BF4Xa3TlGr7vV1aN4WxABSETHHdnYLsYnUk2dFHOqc7woFXGzeJamfyTK1NnCaGhWIKMe96rNm2gLaQjMtMq44r2oMMVmcfHw1CuUiZwvwm+equ9UGsHhY2g2e/qaBqKg==
Received: from SN6PR04CA0107.namprd04.prod.outlook.com (2603:10b6:805:f2::48)
 by SJ2PR12MB8978.namprd12.prod.outlook.com (2603:10b6:a03:545::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7807.28; Wed, 31 Jul
 2024 16:28:48 +0000
Received: from SA2PEPF000015CC.namprd03.prod.outlook.com
 (2603:10b6:805:f2:cafe::1e) by SN6PR04CA0107.outlook.office365.com
 (2603:10b6:805:f2::48) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.21 via Frontend
 Transport; Wed, 31 Jul 2024 16:28:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SA2PEPF000015CC.mail.protection.outlook.com (10.167.241.202) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7828.19 via Frontend Transport; Wed, 31 Jul 2024 16:28:48 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 31 Jul
 2024 09:28:42 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Wed, 31 Jul 2024 09:28:42 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Wed, 31 Jul 2024 09:28:42 -0700
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
Subject: Re: [PATCH 6.6 000/568] 6.6.44-rc1 review
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <142c0f04-1bc4-488a-8366-3c93a52c42d3@drhqmail201.nvidia.com>
Date: Wed, 31 Jul 2024 09:28:42 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF000015CC:EE_|SJ2PR12MB8978:EE_
X-MS-Office365-Filtering-Correlation-Id: 97ba0ff8-ddc4-4806-2997-08dcb17ddb09
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dmpRVWQ2MVRHa1ZQVk84TmlVcXYrQUp0YytTVmdQOHNicjN2R1BabDZRVXA3?=
 =?utf-8?B?VDlnUjFZcGN5enZGU1E5UG1jbmNudk9OL09kOXJWZWRDOHVSTHQ2akRSUGIx?=
 =?utf-8?B?MlhZb0hoRmRIK2tVYmhqNVBMWTNFVXdDNTlrZmNHUlR1ZFFIRjcxS3BPWlJK?=
 =?utf-8?B?dW9CdktRUHpxaVVSaGJjckpkUEZQSXd5T0VCeHlZS3pjY0NZUmhGMVp5WmF3?=
 =?utf-8?B?WGFyRG5rM1VmTkRCaE9YWXdFeUtHYVdNbXlheHI3MmJyWGx5YWVSUmNYL1p3?=
 =?utf-8?B?eEl6MnhBY0NLWWZSUU9DMUVBcXNJTWtKSk5iTjdWeU9OZWVRT1R3dVF3NVhy?=
 =?utf-8?B?T0VSTWtJdHNpM24wVHRNOGN2d0IzSldnMWh2Vm8xVVB5M2plNzRtdHlqcUgr?=
 =?utf-8?B?bHFPOGREQWo0QWt0WmloSXJoZ3VMaXJyVS8zcFh4SGVIWkxoL0IydHo3VGFT?=
 =?utf-8?B?ZDBNTTZXNDM1cVJ2dUJnelVCckV5cDBoZklxbnBNdktCN1M0b25aK2F0cWZu?=
 =?utf-8?B?c0wzSnpCTlo3TmtPd3NWVGl1R0dOU2ZESzdvelFoMVhleWlVMTkxTUIrSE53?=
 =?utf-8?B?ZHpQVkV3aVZoSm9obFdCNHJaQzNmVWhMWk9obHRUNGtsWVNpM0VTL0grN1F1?=
 =?utf-8?B?T3B1WURUYTk0bG9rM1NhWnJOeDIzL3R6U2gxakVTK2VpZ2YvTVpvcTFYNG5F?=
 =?utf-8?B?WFNGTFhOTXZNVm95Y0VyMTNURUtQUnAzNlg1eUp3M1puU2Jkb0ZUVk5PamhL?=
 =?utf-8?B?bWNucnNLT2ljbUlWU3M4K3pDdTVraml4ZVFPOGkxRzF5blNMemhJUkJUck9L?=
 =?utf-8?B?dlc0MndpeDhDRFJOQXM0NEp3Q3ROQlVra3NZWVJXVC9wUnUxRHJEaHBoVGM1?=
 =?utf-8?B?VFB1V3YyaG1nNFc3ZVhpZFBWeklSTU9ROXcvWktsQnA0bStPVWpNNFhEU2My?=
 =?utf-8?B?VjkwdExVMnZETk9ibFAyL2U3M3c3NHNMZC9mbXNwcitCcEZnMkxhK0VwQjBX?=
 =?utf-8?B?VCtSYmdkMkJaYTlCK1pkUFd5WjcrQ3V4eXZCaXV0SFNXTDRnK3FHQXF0Uk92?=
 =?utf-8?B?TlFxdzhRd0t6RjZETGx3ekNKcVM3MDB1UExoVGRWOGFkR2IyK2tDVHdRVXRP?=
 =?utf-8?B?N2lSVnp2cUVwMnNQc1haeTJvQ21qYkJRYmxiSjZWU3pKMmFGamo0YXFjSk9t?=
 =?utf-8?B?R3NSc3k4WWJQeFU2dmJFOVAzTUJhb2FIZjE4NFZMSnkydlVreU9ZTE1zdjZG?=
 =?utf-8?B?RFpMbC9VMmNJNGhUREN0ZFlSWTl2cC9kcGkraDYzYzB3M1hiRVNBZzdyeXBD?=
 =?utf-8?B?a2I1R2pYa1dNZ2R4a0dDcHNJZjYrS2w3SGlDQXdFM0xwVzVjN2svajdVQkNR?=
 =?utf-8?B?Yk5hNkN1NUs0KzFqcFBuZVJBdG16RkFtU0JEMmliQWE1STZoVEZJMzhXVUh1?=
 =?utf-8?B?ZC96Y1hjQU5TRmIxdUVxMXdKaFJoSjJuTTNLL3c2V2VMUm9KYVF4WldsRk1Y?=
 =?utf-8?B?ZGFLUk1DQUJnQ0pCYms2aGNGSGk4RmtvNUwwSko2QUQyRm9hanYvK24zWTYz?=
 =?utf-8?B?SDBBV05tSG0rL05JZU85YmZ5OHhCUEkxL1FacWdnWDBFcENzVlRHL0M4UHZa?=
 =?utf-8?B?TXhlNG93WFBDOHJLRU9LUlhQVkltdTZMamlMQnF5bjdOTXFXeXhRQ1d2WVBk?=
 =?utf-8?B?SVRia1RDU3gzTVhkTlFGMmhIa012SVYzVnA1Z3FvemU3SE84dWpKQ2xVTWx1?=
 =?utf-8?B?NDQydXZnWWJYQnNnSWgxSjRJb2lPYU5EbExBSThYSnlrZ1lKYW1HOXEzcTR5?=
 =?utf-8?B?aTBoMDVoa2IzVnV2UU1jN2lqMDFtTlVURTRqQlRGVVRZSGF1d2Y3czNrdUJt?=
 =?utf-8?B?dm9OOVQybDh3eURpanU0UDRFMWZTUVFGZmFwbzRaekhZcHE1c2dvUGZEdzdI?=
 =?utf-8?Q?1Yd22TYLQtA5Wf9pkjbCdxSZzBVSFF3S?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2024 16:28:48.2825
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 97ba0ff8-ddc4-4806-2997-08dcb17ddb09
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF000015CC.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8978

On Tue, 30 Jul 2024 17:41:47 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.44 release.
> There are 568 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 01 Aug 2024 15:14:54 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.44-rc1.gz
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

Linux version:	6.6.44-rc1-g7d0be44d622f
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
