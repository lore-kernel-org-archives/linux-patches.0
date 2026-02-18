Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010039.outbound.protection.outlook.com [52.101.201.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB1EB31AAA7
	for <patches@lists.linux.dev>; Wed, 18 Feb 2026 08:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.39
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771402950; cv=fail; b=bDm16NXQTH52uq7V/qYKnjB7xqZ5s/No2p5rezIQbYAIwatBr+K3DVKzADLMS0KCbqpHuEGTZWw9M8yWkU0d/fEd55pdUgMhXF2Oo/XJm8ASV2UQfnSb2aJUFbURbi5KuOsIYXEsBYQrHb2+a1kaUAXNK/nOwEHC7w5HQtx70J8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771402950; c=relaxed/simple;
	bh=Y4eTHarAkP2WaJJHMTDtZ5DFsSKpyfKAD83aSNE7jEE=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=VWiVq0WkzKrkSNN9at+IbTa2tIldYqyRefCkb118fAqlg0uzD68ePPjYMV65d+IJn4H+YpY/9GYDAkPlZB3kjtuut4vYTJwLm9xhg9PGSU7vVmwCIG/36B9f3a+dWfxTvP1/W3svoEvcYjkZNq270sE2AqMs2fqYCLNI3A/DUXQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ts5PkWVh; arc=fail smtp.client-ip=52.101.201.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ts5PkWVh"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vY39+9U2K2MPRbeeUnlyE/la8ZPH1LuFHfe4l9MRZ3wL4UMUYYDeNVbKzOh7Zic5L8AbHxRdmYdWW3pUpuaIxEoYab3+KnoMUUjL8Jls+77jJ22XYDIronHTiMh57PnSW6nhzPlzPkK3ttLmQ5dFwP/vGxf/0QNgr5bYEj0QuTbkbMUSoBR+sHCepFG2w5PHnQgbmOrW2BEFEEpUTv/esOpU/s3QMrfkIxQPbSRrIADw4YjggLSJetfJXVvI1Pk0eByEfcxm8ZgLWLg6zuEK9C3AReJGgfReq6Ol3NoCEi35Jop5KWyFMsyVhbGffcwMYAzQZavZ4VpAWsvtxXvpeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rU3G6PP2l2uWgXyO5t6LY6NczxDY/IFgEHTsymyRvrg=;
 b=Yx28r7GfXS+qwKXgJoMh7dXInzdhOGHS+afl0+8AYp36keez+V36rWD4xNR1PFsG8zHhQyqdeyBH33MpCx6OMij7FSQAeevN3nw9VYjxIQypCxcu8SKb3UGpvEsoFI47ZxEph5cDFG0GwV+Vko+P+CtG8syGh8IONNrf6bKrmvVM70dL+NtAMa8DoLYkyHS6/YFgT7z5/BS3AFU5iJTXzS8aPXwUhK16A3izD/KhsbeQu7yRFG5iYNOO+dfwQUWDFOE6TOZt31S+sieiO5EBVyqZht7aJH5k+f9RiXSB5be4GEojf0BQdQ3+smIZ/jiLl3g6CGCdALoEBSDpVSRysA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rU3G6PP2l2uWgXyO5t6LY6NczxDY/IFgEHTsymyRvrg=;
 b=ts5PkWVhz3ngON3bisthND6i5IJcTyZtXuM0LdXNv5d4ENbhMFis7ZKpoDNZzKNAY5N1YaL1/8pfBkj8pZNN3dpY69df4ubcAEl8mzNDR8x92i1iUErQh8iEREF2RAfjoHglThoXx+Ieho/GiI5BpziUiXvu3m/MmaXltHYkbl7tRpv/jGLsNc7ftlLLfLvTA9LfUQWK3PBqx9RoOFTrefNVk6dKYZlzoFOtJB7xNmOS0jA30ml9mM6PFXy3oCR+P2AmtM7TUiZBVrO/qmOzCvWMBW1cbLSqSC8nj+GBacwgOSTsvdQzDYcGlVIXnKeDzVU2niGgHTBsjB4dFTtyWg==
Received: from SA1PR02CA0011.namprd02.prod.outlook.com (2603:10b6:806:2cf::28)
 by IA0PPF80FB91A80.namprd12.prod.outlook.com (2603:10b6:20f:fc04::bd5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.15; Wed, 18 Feb
 2026 08:22:23 +0000
Received: from SN1PEPF00036F3C.namprd05.prod.outlook.com
 (2603:10b6:806:2cf:cafe::91) by SA1PR02CA0011.outlook.office365.com
 (2603:10b6:806:2cf::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.14 via Frontend Transport; Wed,
 18 Feb 2026 08:22:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SN1PEPF00036F3C.mail.protection.outlook.com (10.167.248.20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Wed, 18 Feb 2026 08:22:23 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 18 Feb
 2026 00:22:11 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 18 Feb
 2026 00:22:10 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Wed, 18 Feb 2026 00:22:09 -0800
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@nabladev.com>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <rwarsow@gmx.de>,
	<conor@kernel.org>, <hargar@microsoft.com>, <broonie@kernel.org>,
	<achill@achill.org>, <sr@sladewatkins.com>, <linux-tegra@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH 5.10 00/24] 5.10.251-rc1 review
In-Reply-To: <20260217200000.708219618@linuxfoundation.org>
References: <20260217200000.708219618@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <30a1b1cb-1fc8-441d-a018-45993867bc50@rnnvmail205.nvidia.com>
Date: Wed, 18 Feb 2026 00:22:09 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F3C:EE_|IA0PPF80FB91A80:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b3f8fd0-fa48-456f-4531-08de6ec6d79d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|36860700013|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cENJbU1OcS9laG5DSm5SeWZQU3JNWGsxVnVvVlo0ci9JMVNDZ1JwdnVFTzhG?=
 =?utf-8?B?TXBEVjBUQlpaZGdBUlZmUkxHb0ZEdGxxMTVZcll1TlJUdFU4SWVuOElLVWRN?=
 =?utf-8?B?bnNROXg2VXExc0RVSVZvSEpxQm1YaGNwR2VFZ2NHb2ZGaHpGNTI3b29mQ1ll?=
 =?utf-8?B?WTBzeUdEOUMvK2xPbkxMVGZjMVVicFJPR0NJcmdvQzBHb1o1bDVBYS8ydGUr?=
 =?utf-8?B?VUdZaEF2bzVBSUVVbVJiWXQrYktTZ2J3MHFrTUJkUWtpdW4xVkh2YTF0VUhx?=
 =?utf-8?B?VUpYcG9NWXUrWVJrSEIrY01Kb3gwakc4bk1zOC80QjRobEMvYWJMYTVYQi9G?=
 =?utf-8?B?RXVmR3lyM2cwQllTeHdVM1E5VEJEQ2I3SkRIMS9KbHNRS1JxNlh5QzhPdllD?=
 =?utf-8?B?ZFEydGVNNzU1Rkh3KzVtZDM1RG5DRFdocDY5UE1MOG0zYi9VOVlYTlBJeUsr?=
 =?utf-8?B?UFBsL001eUk4ZWNoNVFyTEtmaGlQeGp0TTdsaXowNTgzYVhLVG5zeXZ3UUR4?=
 =?utf-8?B?eUN3bTdUKzBvQ2dPc3c1dmxPR0dya1ZkaFdsamVWMXg3OUFGUU95SUlGUFdV?=
 =?utf-8?B?ZlFrT29OdW5zZHFVWmFQTTVRZUF5SDFIcGprbG8wZ3NlbHlSTW9JUmRPWFZi?=
 =?utf-8?B?ekZ6WU45ZU04MmNZNzMwd1dsTnREdForYWs3MVp4dEdrUnFkMFUyZXk2L0xu?=
 =?utf-8?B?d0FPeG95NjhhTitjb2lEcTlCM0k3V0o0TmZvaG9sU0k2VjBCWWFpNEZ0YnEy?=
 =?utf-8?B?NURZdFJHS3JjWmZQcDVhMlVXbjRqNUxydXZIcEhyQlMwOHcwR1NVTzhGTDNJ?=
 =?utf-8?B?SkxnMUVOVzMwV2FPWUhuT2tYTzZ6UWVUZjRPMTZkSlhNRW4xNzdyR3BxcnlF?=
 =?utf-8?B?dExNZWZORjJGRnEwS2tXbnlmSzYrVlNYRHhjWkh3dHFjWWIvRGswV1pkcDVM?=
 =?utf-8?B?L2ovMFBma0dJM0VpQ1Q2OHhxblpGaUdtanl1eUxlRFFWaXhrWDA3UW55aFh1?=
 =?utf-8?B?VVlrMUFiSE5QT04vakZSdGdJTW5LbzYxbTBzUmxldEU2OVlySjIvT09PVDJC?=
 =?utf-8?B?Z1BralRZRlUwUkZsQ1dsV0ZObXNKWUkwMEEwbTBHNi9sd2c5b1dPcFYzM1Zk?=
 =?utf-8?B?SEI0Ykg1V2JUanVEOWhyRFk4aVNJT0IvOGpoRTlHazNYYUpaUUFnSkJ3MnR6?=
 =?utf-8?B?bXVFTCtVdWNkYUNETGtMaDd3aXdrL0ZMMzRmWmhnaTFhVEFZM09RdnhXTWQ5?=
 =?utf-8?B?aWtRMDJOVHdCYmlrSC9VUk9xM0plcXEya3h2eUlyWFhiM2oySEs4VVJPanA1?=
 =?utf-8?B?MHBEY285OGU2b3V3aW9NNVhiRjZlSUJSWFJLQk8wdmYySC9TNmsrYjNqMHZZ?=
 =?utf-8?B?Yi9Ka0FGL3RqekluZE84YkxMemI5VDhQWkpyampNckFDT2QwYnNkL0c3WWFU?=
 =?utf-8?B?Y0w1UkZTaXJVanFFTVo1eUZ6WlFvNDhyZ0EwMjVGRCtwekRYSGwzak1PaWFt?=
 =?utf-8?B?ZFBPemNtZ2F0SkhZYWFiREErRkJESVIzcGI0M0ZWenNCZEZDSHBsTHRsblJU?=
 =?utf-8?B?KzlobjJUS0NRUUZsY2dONlE1dlVIbEdCaVpGSk5tNDFEdk9KQjUvTlp2YXJo?=
 =?utf-8?B?VW5CbXJCc0REQmdGUWRNSWhZWUdKcy9BakRjOUE2cmRyeGdGNDN2UUx3aks0?=
 =?utf-8?B?SnZyZkk1cUh1SUdvV0FmNSt0YnlOWmhQUXI1QjFiZCtrUGZoNFovQTc1Qm8y?=
 =?utf-8?B?Zy9SdkMzNGlob2VCdDNWOUd0cUE4cER4a2VMSmo0TVM4UUVudW9NNlo0eWE5?=
 =?utf-8?B?czlBYndKbjBKUm5wMndzTlJyYWloRzVIbThUbDVNR25laTgxTGt0amFQYTIr?=
 =?utf-8?B?TEtNYWZBZVVJY05MclQ1UGVjQmxNVWVwMUhnNUl6WXpITDJjbU9qeVZkVEkv?=
 =?utf-8?B?T2FqajR2OEJtb2NIYlZudGRhMXAxVG83WUt6MFJucmRoQmtZMzhsSnZUWFh6?=
 =?utf-8?B?S3EyYmV1ZGVKcVk3aVNPbWFQQzdkUGdhWlNLR1Q1eUoxWmx1RldnTjhHV1Nj?=
 =?utf-8?B?R0N3K1N1b1B0R0xSRDRRQndOYmluUzRmd2FvbFREVHF3dG1oNDRCZjJyd0U4?=
 =?utf-8?B?d1lad1ppT2UxRHNXR1RtdGJCYnh1WXI0VW8weEJQNVVQeWFLckhiMnRCRWR4?=
 =?utf-8?B?S3ZUd0NyYVhYcXlBRTZ1Y3BDWVMyMlkxeUUwZ05UT0gvVVlFUlhpeGhSVGh0?=
 =?utf-8?B?M0tvRTRiYzlCSGNyNzFISlNnbkJnPT0=?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(36860700013)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	tvM2gJzngv/er2luikFIcPKsdC0Tu6sems8X8Tb9z5J44AXgdh5tXVkz/ZDE4hRNxkSAjHV904tuj92QSO6Yp9Xgw1FvCakbkf986KM4ajv3JhJQzPdQoR+6Lg10D6bIvg8FpVqgKS1/oE/Pl60MHnAN2FJYd8SGa4uDkiZOK4vmh9473BnLOJc4wAyu4nQomN6wqH1iWifHrIzsdpC2ioIGIyuWw0IO1xfX8lpkTcHdnSqnEKQVwoh8bORMNYaBq2dO68IjQCC2n18IT2fJT9YIAQqHlvzIEjrRTRpZ9+fmRP/MXM5DsbXHviP62+Lm44WbaQ4Fyrvhx6o3tV8/3xDvHr7Jnk0ddTrGUnrc2i+DkPRRbF5q1/VktUxlHq67RligIiObzAcaFE5EL99djvlWQoSMU9QshprGcAnKbpNJDuhd2P1VPpUZ9iZ2JTVo
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2026 08:22:23.1944
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b3f8fd0-fa48-456f-4531-08de6ec6d79d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F3C.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PPF80FB91A80

On Tue, 17 Feb 2026 21:31:13 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.251 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Feb 2026 19:59:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.251-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.10:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    80 tests:	80 pass, 0 fail

Linux version:	5.10.251-rc1-g25b86d4e088d
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
