Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012068.outbound.protection.outlook.com [40.107.209.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C83B331D730
	for <patches@lists.linux.dev>; Fri, 16 Jan 2026 10:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768559634; cv=fail; b=rxft+eJexNrwXToiC2Tb8Kimhm67rAQsgg8MSPakw2ioHJecq7jctMOGQBCfifKeWNwy+QFnpSgO4rLfWZWI5o05xUaGP//jBp1fUwiIccR2rr+Nfxc0DbPgl+373Oemd6d8ZudLLt17pRfTjNdjA/q7F1FTdODgq/hzIno3+9k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768559634; c=relaxed/simple;
	bh=L8KNnvxEzXSy1sS7I3Z2eFvvCGjkIeI5fpgOC1ffA2g=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=u8BH34gvDXPch5U1Tm8t30/6OJldvNZ75wuzfTkKIDjzM2py5Aq2bw5zo/JKZ904wfrw0yqkWI2s+3I1AQzxZsaM1Q1CW6ENcUtxFkJLBMzfVD4E4Gdch0FLeZzJRu6RNGWXVHUaSgGysBB/CqAh2pgpAS98E6d62j28bxOGQQI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=eHaOM67h; arc=fail smtp.client-ip=40.107.209.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="eHaOM67h"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bBF71Vp6Cp7JOXaGwH4aOK2DQYqH1NwBT5jABtyaz0Umd2NWQt7UA7cd7iJlTXHGEV7+au1NKwK8aYYlxr0dzVlWIEQ7VmBtRHBEkJHDr+RitPAQaVeSJQ2mfW2wuKA7mPkmb0k+nqS6cViNqHyTCDTGeJFofQVk7HhzuwKiltuJIaFEgI+kGyuqXRSNpTolY8twvN4h7xps8c9b8nHOAqYc3NPJD/Ou70XI7UucG5++9jiSdqnzJnaGAWPsFg2E7Vq5k4ViinIr6qW0N0X3MiZZRCzu8VD4In9VHStWI4IrQaEJKUje0ZBJXZQyzqn5Nv54ifuljisxLtLjB0cV2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/3IYpGswJkvT/UBtwgNTNDDY6lAmfA/lBNiTRuLlD4I=;
 b=qtvAhzVaNdSFDvfD9FSbKTaks3EKwQ1/am2cfa0gFgxZwKBSVnM9dVRC6jyNW0ChHh+pwpzFIF26+4mtuaiwKCvOX96y3seoC3Ew4ly+O2vkRNEGr4tV1y1eLT9CcYpXQavvVTDRMmmyJZO2nxPpwfPQLSnlystiyLtGZThLaSmYmNaX5gKJqYkukNvNror1Ztvy1kEPh1c+sHKHs42NYtjkrauQD3gLesoglgj9phhKvkcO16d4VijzMPexcyVv+SE06vylPWn39Mg5DyO7aIL+iqMqOUsCEdcwunUcxkUzJ1I4Pa+Ua+mWxeJrrcKStEOed0s1YH+xqQhmocgm7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/3IYpGswJkvT/UBtwgNTNDDY6lAmfA/lBNiTRuLlD4I=;
 b=eHaOM67hcKedVvHD9KxRM8cUCBNkK5XG4bWnPrpDQhmtI5DX7EzVD/Th6ZkCV4QZHhTvi9bR92YUuUp8qQTX+Fbx7dLMxxPZpe2S0wa0Tfj6WQ0uaRtbx0DdP3q35/T24fGk/YwqdIatqX6g4y8u+PCA+503nIm1dD5tTSBWWK26ESCPQNV2qzq8xYS/d6DVKffRWJU8J0ShqHwJ75n69No77/uUfXKxRjJeqAZxFQ8TS858wdAVqfhIpslL3NFbbZ2OmxDJR3+OCK4c01gamKApL/iHpPbIb0F6htXO32MiXU0W6C38b6KAggn0ndjj95aPd+eive4lm7t7VvzSYQ==
Received: from BYAPR03CA0033.namprd03.prod.outlook.com (2603:10b6:a02:a8::46)
 by DS0PR12MB7900.namprd12.prod.outlook.com (2603:10b6:8:14e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.7; Fri, 16 Jan
 2026 10:33:48 +0000
Received: from CO1PEPF000044EF.namprd05.prod.outlook.com
 (2603:10b6:a02:a8:cafe::26) by BYAPR03CA0033.outlook.office365.com
 (2603:10b6:a02:a8::46) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.8 via Frontend Transport; Fri,
 16 Jan 2026 10:33:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1PEPF000044EF.mail.protection.outlook.com (10.167.241.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.4 via Frontend Transport; Fri, 16 Jan 2026 10:33:48 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 16 Jan
 2026 02:33:29 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 16 Jan
 2026 02:33:28 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Fri, 16 Jan 2026 02:33:28 -0800
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
Subject: Re: [PATCH 6.1 00/72] 6.1.161-rc1 review
In-Reply-To: <20260115164143.482647486@linuxfoundation.org>
References: <20260115164143.482647486@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <ef03e7c3-c59a-414c-9ac2-bb52ee3c4668@rnnvmail204.nvidia.com>
Date: Fri, 16 Jan 2026 02:33:28 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000044EF:EE_|DS0PR12MB7900:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c3e6cfc-ffd7-4703-c4f6-08de54eabbdb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|36860700013|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RXc4SmU2L21oOHVlMlhsRW95UzVqbmtyUjR5MjFkcTlmaWNzTEI3emMyN21J?=
 =?utf-8?B?Uzg0b3FKcmlvOW91WkE1VElJL3p5RC9WVnhEUzVBcWYwTDVwUG9WWXVRVmhy?=
 =?utf-8?B?cEt5UTc5a2tndDhhbllkai9SNklRaHV4akQwS2VHNkpoalFNVGhVQjh6aEdL?=
 =?utf-8?B?Z3Nya3pYcTZDZ0xHOHFkU0V5T1JOb0trS2FXU1Q4bXhPWXJGTkNwcy9ad3g1?=
 =?utf-8?B?QkJvMzdKV0dIRTVuQWxCUHQvaGFYdzBmSkQ5eWhrTndCT1E4UVVEVCs4L1Mr?=
 =?utf-8?B?RnpMNEFVdVNEV253QXFFN0pxTkorRDdPUElOWVRYTCtMLzZSTnFNeGpOQjEz?=
 =?utf-8?B?WDZLOFJ5bzUvdVZURVFEM296MU85THZkaVpraVJOZG1TYXlxdjl2UUFUeFhO?=
 =?utf-8?B?RFJ5OTdVVkdRN0lzY0E5QXlDZnkxaGl4UVMxYitrb3ZHYkFuVHpzejROc3Fi?=
 =?utf-8?B?UW0wb0QwYmdhdGE0WmczN01CV3l5czBwc0VBV3VnVTVXS2g0NkROdFZrc0hB?=
 =?utf-8?B?Qlg4NGpYVzl1THlIc01mdjRBTTQwVjFoam9iUlFhN2JWTHZWQ0FZYURPczRW?=
 =?utf-8?B?YnFhV1c0QnlBOXlBVlIvRTA1KzgwQ3BobVZmZ3BQRElBVW5qcFp5ZDN2eU56?=
 =?utf-8?B?Q1FZcXd3QWhneUREU2p0b2c0WGtlYlNuZlZ0THluS3ZYT0NmTnBmdXRRb0VZ?=
 =?utf-8?B?TnI2SHYwUGd6VjhFc25Ub2YvZjZOZzVOVlQ0SnhoNVdYR1F0OWc5Y3o5bnUv?=
 =?utf-8?B?Q2pqQ1AxQ0pnMCtvdklDZlVyK3dlaC8rWWdpbTYrYW1FR0JRWHFqZUpNWGtJ?=
 =?utf-8?B?WDJ2RGVMVXYybWt3NTFWN0ExaVlkdHBFcEtJMVBsTFNtWXFoMzVHQkd0Z3Nr?=
 =?utf-8?B?SkRyTkhJY3FWRnZGcEtCcU9KTzAyRXQrVTNRMlNONE1sN1MraUR3bitxN2Ju?=
 =?utf-8?B?K3htMWVoTGZEWVFKRWV5UE1ucVZadFBvMEFyN0hBL3laSE55WkhBNi9UelR6?=
 =?utf-8?B?VUY1VzF2cllJdksxZHAycDdTYm5icS9pOTN0b2xTVURjYWFVNkZtWlUySUpC?=
 =?utf-8?B?WXo2WE42ZVJZOTBpUEcwWUFHYlRyeGREUGhla1J1V2ljZU5qYWNoYjl5WUYx?=
 =?utf-8?B?SmREeHUyb1htMUNUTG01NjFhNEVlVndmOURXRnc0cEVyckNJUmxKdEpCWS80?=
 =?utf-8?B?V2ZDTytIdjgwYmhoNkppT3ZMek9qNHphMDI0MUIyUDlIVVFTWWpRQzJYM3JR?=
 =?utf-8?B?eWZGMU9aRWRvQ1ZuWEcxTFkzN0huQVpPNDAxQ2FsYUdHNEI0aGtwUmowS0M1?=
 =?utf-8?B?TnBMK1dCeUY4dmRHTXRZRGFmNlV1L3VKN0psNk9ycWRJU1lUbEhTUGRpN05R?=
 =?utf-8?B?ZXcrT0Z2cEtxMmM3blNsZlpkV244R1YvK3g2VGtnLy8yRDlJUFRsaHg4R1hZ?=
 =?utf-8?B?SmtINWdCUnJrM0k1QWNYTXVjZ05MelVSd0JjSXltODkwdXluZmoyRzlXaytQ?=
 =?utf-8?B?NlVVaDJWajJndGxEVFJHT0xUT09BRFM1S1dwazJPVzNGNDU0ZWtHS0Q0aHpB?=
 =?utf-8?B?dW1LTEo5M0RLYm5DT1c2N1VlS1BwTExlandLTE1wQmhCM2VBVlM0Sy82c0hV?=
 =?utf-8?B?aGdMQThZY0tmYXo1dWk3WVJIR0pvRjFHQmx0aWd0QVA4dzVMeFhja2hrRGVC?=
 =?utf-8?B?OHBmN2ZNRy9CaWY5Mzh4cTNUaEdYTjQ1cXliSWh6b0loWC9TVXFZVWlzcWh1?=
 =?utf-8?B?VzFIczdxM05aU21QWUh6cktHZENZZW95Wk9ocE54ejdtN2hrV1U2bWlvUHBq?=
 =?utf-8?B?VTBHMW1aQ1B2N09WRXFwdFlEZXFwWFRaZ0ZVL3hJZjdCMDBiczQ0dDdSZGVw?=
 =?utf-8?B?a25QOE5kTTErRldrZnllV1QvUXdMb0c4ZnAxTS9JbG9SSldoVG5RcjdOMGdO?=
 =?utf-8?B?ajdvVm1pcEdnRk5mTDBydHFsb3NySHhRNGswa0taSUJFbmRVdHlML0tKSUwr?=
 =?utf-8?B?Z0JOQW45MVZHL2ZoeVNhY25TcmJnLzI0SG81Ym1hVkZsczVWMlBNSDY5TlpL?=
 =?utf-8?B?aG94SWswZURYSkN3ZEF1aXQ1aWYzNnJSc21SMGwycmNja3R1RzdGVWhGTlVW?=
 =?utf-8?B?Wms4bEljRTFhc0k3RDBEeVFLNW4xSFFaaUU4Rzc4RnpEMHF5eHU2QnVsb1FT?=
 =?utf-8?B?dVYvYncwUXVaOEZwbThYSHNIdjVuZDNZOHFuK0hRY0p4NXFMdDVoaUpQei9Y?=
 =?utf-8?B?M3orRUJ2M2FlallySWt2UXdBWFpRPT0=?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(36860700013)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 10:33:48.2919
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c3e6cfc-ffd7-4703-c4f6-08de54eabbdb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044EF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7900

On Thu, 15 Jan 2026 17:48:10 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.161 release.
> There are 72 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Jan 2026 16:41:26 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.161-rc1.gz
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

Linux version:	6.1.161-rc1-g9f1df8edf447
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
