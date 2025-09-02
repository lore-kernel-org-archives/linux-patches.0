Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2045.outbound.protection.outlook.com [40.107.95.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69FAD231827
	for <patches@lists.linux.dev>; Tue,  2 Sep 2025 18:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756836246; cv=fail; b=bNWNAdXZtqNMrwyooA5ATv5njq1rw8DTBuzDqdBt8Tq/GbWoSOUHfxxds67Q0N4WziyiY7Z3HjVMG3QBLacHp0xV3ccHqe30vr+eT/YpoVMDNde6s+qb7wD0LIg3TjMXuYJ+UAjmSe4xzGUBJwUPZLR8L1kweR6yNs4FztdI2Mo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756836246; c=relaxed/simple;
	bh=yvXpTqJZZ4Wp77Dh9kiCTA8PV5daAfF9b5h/6Il2TOY=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=GgDxFfqMOfbZ9pwMdTLuhxN6wL6bXoi+eEoA7mQiwpVF7eIlQXMURHyMM5bnU027sBORl4N6yg0RCPNHYhhbhtfXJa6Xd/O+LaxE5jtneflVXXDMMdtOZuSsysidKUlt23P+MdXksOlcxM21FFhw3Aq0aFt+CeVukgu15k+ygWU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Z8wr10hf; arc=fail smtp.client-ip=40.107.95.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Z8wr10hf"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fW/EmorMcVwBZK+H+jgjSMWwbl7NxDymtEEeNncmdOaqjZdFT0Xc5NXwFctEX7A8DArt7BflbWXPeSyyRscrUiCcGXEj82PWrOITKXz903tEE51zpzgw15Tmout+ES1MInA1pDOgHNsSoVEeOymmFYOteoBkDVWnwAfg4KBi3NPnddQGv/xSqQO7/QakzQ704nC56KgAtJTJV6cV2cj1Omq2LhPQeiGCSq3BUmGbEevkotDrgEbdhfKaUFMTBiyCJuFOXWPdPMJZ9WXSu3u17ivIjZ8nKgOa/Weda/wUhr/stEc/G/D1bfzPdHRJEUmLrgymhbg0xIcVXdcdBQn/LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9+aX2KpcosPupDZNByD5wqvkBeNzDcC+N4rhkWCBppA=;
 b=xe735wXc9uEH0C3ESlVgt3R4VTijFGcUnDG1AWZY6NV0onSuHxgwa/sWT8FQOcNeGS/Dq6qoJ9/0Ro2MqU3RjOp2hZUWufWI6iDKwtevo1WfjNgalSVyZz7hrNhHzcOvqBKVF59YMBKSZJ57tN9VZ/n7TkSlRLO0SFd+TAkRd8ExJ9/7MsB2N73zxTHU4tRy82b+NpZmaGIG5IiCFMNSKfL3CKbceZ85yQqpr/AlDFldvzFfSnZ+ZU2YiEv/eYqI++iOGWmgC9nRmqbfYi6qm+SgIW5QhZ6JV07KSwpAR6qgxSaoKxrp6JU2KtVerexVSpU364WA6snMQkpSCquTzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9+aX2KpcosPupDZNByD5wqvkBeNzDcC+N4rhkWCBppA=;
 b=Z8wr10hfAuTgdGDqrURjz8FedhuYlTFXjGHbdLkU+D6GRqvvKdcRZTX+hys4X9I2a9q2pIQmvK2K1TVgEs2zcPh3utBfdEmgSvaM4z4w6kT+CZ/a/DGwsaQnmvF8FYEtzyTkj/YEXh6pqCJesCHa9O/dbKcCG4sLEILzEwYq03K6m/8kFCwExZUqgGsWsxCtmmp6eQ60M8Re1CxsPlu7aRUrWClNUsgitKKodMU4obGZDNIS3FJ7USPcHvCJqO3qQ/0Ek4hJNJx09g9rZsMVN8ZoiWmshBpwSecT+wVkXow+06/JjFrBT0wS0xMBDmIkTCotA+gBm8FcMLTS0l8hVQ==
Received: from BN8PR16CA0031.namprd16.prod.outlook.com (2603:10b6:408:4c::44)
 by DS7PR12MB8229.namprd12.prod.outlook.com (2603:10b6:8:ea::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Tue, 2 Sep
 2025 18:04:00 +0000
Received: from BN2PEPF000044A6.namprd04.prod.outlook.com
 (2603:10b6:408:4c:cafe::be) by BN8PR16CA0031.outlook.office365.com
 (2603:10b6:408:4c::44) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.17 via Frontend Transport; Tue,
 2 Sep 2025 18:04:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN2PEPF000044A6.mail.protection.outlook.com (10.167.243.100) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9073.11 via Frontend Transport; Tue, 2 Sep 2025 18:04:00 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Tue, 2 Sep
 2025 11:03:32 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 2 Sep 2025 11:03:32 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Tue, 2 Sep 2025 11:03:32 -0700
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
Subject: Re: [PATCH 6.1 00/50] 6.1.150-rc1 review
In-Reply-To: <20250902131930.509077918@linuxfoundation.org>
References: <20250902131930.509077918@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <1403771c-22d1-44c5-8ce5-5510ae07c51a@drhqmail203.nvidia.com>
Date: Tue, 2 Sep 2025 11:03:32 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A6:EE_|DS7PR12MB8229:EE_
X-MS-Office365-Filtering-Correlation-Id: a9070c36-7ce9-48ab-6d41-08ddea4b181b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YjJmMU8xdWxiUXVrNXZYS3JWM3N6bHFCcU5uS0pRSVNaVHBDZlJSZ1RCQjZG?=
 =?utf-8?B?cW9nRXBPWnRFNzBTMTZEVDJNYkpteEkxWTRLRWNGL2xqTkc5SjJKcXNUUDRW?=
 =?utf-8?B?Mk5kQUVoMEk3c0VpZ1o2bGpEb0Zkdml6UlZ0Q0pMYjhwSThYUloxYUN6SkQr?=
 =?utf-8?B?a1V2dDY3dkU2QmwvMzBvOElVWFU4Y0RyUG9OQzRMMzBhdHQrWmYzMUJMUklr?=
 =?utf-8?B?SXk5aTBORDNPL2xxU3BOZmJhd3dYTG1IRytRditkWmJhNTMxMHpqRHpWK1Y5?=
 =?utf-8?B?ME4rTU9QZEpHMldZR0pEUEQ1b01LbERQbG5wSFMraGpzaE1waVlGZ200aHp0?=
 =?utf-8?B?amNlL0M5b3dPSXlwZktVNzU1Rkg3WDB4T01HV0NsVG01aHY4Wmp5RVlFbWJ0?=
 =?utf-8?B?YlJDdnlyWHFIaDhwY3ZYR0paT0N6R0dKUHd3RGxYNWJOOHY5ZDY2RjRNUTlk?=
 =?utf-8?B?K1V2STQwaFQyUU9DNkR4TmFEQlJFMjZ2U0V1cmltaFZhYmRkZnU1MW1FK3lh?=
 =?utf-8?B?elpoM2ZWRGptSTkrQVVIV0UxMEpEM1VvRVpvTzNBMEJudUZ2NnhES2wyYVZn?=
 =?utf-8?B?SlRTVVo1RFU5U1ZNbU9JZ25qSU5UWWpybzlhNHdKSUkva1NGZVhKWU5UcW5Y?=
 =?utf-8?B?Tm9EcTRwV05tc0R6MjRlQS9Va2pERHRZRmcxWlA5alBjS2JRTklqclZzMGox?=
 =?utf-8?B?S0d2Ky9aRDNPbzk0M055TWtLamYrUThkMXRxTlZMVDZRaVd6L0pjeDNSMGwy?=
 =?utf-8?B?VTlGaytOQ2d5Qkk0MzNHR3dJMXlnTEtVL1NUV2Zyd2YzeE4vNnEvei9uMjBT?=
 =?utf-8?B?SFYrajJSb1NSVy95MWoyQVh5R3dlb1BFTDNNMit5Rjd1ZXV3V1RuUnNBWm01?=
 =?utf-8?B?T1FUTWFHalRyNDRpWVRoMEtBZ1RLRWYxMkxBbTBQMklBQWdMQ1ZTanJYUm5j?=
 =?utf-8?B?UTZwRDRPMUt3S1V6VXdmZ1hYakUvSktuQ1hma1NscWdNbkNva0l0R2JNT1ox?=
 =?utf-8?B?WXNlaDVlTzJ2cklkbjlwU1NjQXRiTTdQRHdvN25hNHJtNitQVDBGRkZXZHBQ?=
 =?utf-8?B?dEl6NnRteXB6Y1czeWRMUXl5djJZRzVmaHlRSXBWMmNtMWxVSno0Tmo3UjlX?=
 =?utf-8?B?Z0tycis5eEU4MEtOdys1MkRYalp0SEk5RHQwcWJNYUM5ajU2d05YallWWXZ5?=
 =?utf-8?B?NEtET0IxMFVyK0lmSmt1OEVCRlBrNm9Edm0yUjhPZ1VwS1RZUTRZUTNZanJn?=
 =?utf-8?B?VFZTbnVFQUdBc25GZVhmM2Vad2VKRytRZWVYa3JDUWM5R2p3czFlSEkrNkhH?=
 =?utf-8?B?WldLME9JL0NiczNnVDJKdzNYd3E0MXNKQkErcmtlRTdLQ3lON2VrZGRIU0Iz?=
 =?utf-8?B?RXNkK2kwVVJHVVBlTysyRWM3dlRSSndBS09hemJTbk5vYlphMUw4bGU5ak5r?=
 =?utf-8?B?Y2paYVZUNnNuWi9JUEVpOXFOakhYWDJ2L3ZSNjRPYm1NKzBIWFJENHhSUmFJ?=
 =?utf-8?B?dE1CRkZYaEV3Z1d5b1VGU3JVcldRSDVjUVhPWkZub1pLUEhNSWpESUM5aTFM?=
 =?utf-8?B?d0s2a0loWGFsSjRpVkowcUV0Zm50N2xBZEhGRFh4WXltZ2dVVGlkbklxL3cw?=
 =?utf-8?B?TWhVL0w2N0dmTDkvOXhsUnlrRXhOQytSU2NSNnRVdUZ2RlpUdGl6NE9iTWtu?=
 =?utf-8?B?N1I4aFRxUWhMcVV1QVhkUGdMZ1Qya1E4WVhtTUo2RHJIL2ZKdEdTaDMvcGRn?=
 =?utf-8?B?bnhuQ0NiaGZ3Qnoyb1dJSEhBNktNUjFoOVh1dEEzbUxNMG9PS1M5UUdVVVJ5?=
 =?utf-8?B?TzIzSEQ5dlhLMk91VUJ6VGZOdDlQcGpPU1BhSlpoc21pUzM0UDBPbmFmSTJI?=
 =?utf-8?B?eHJVMTB3Wms5Q0JjZGtzOGNMNHlna2FadWRmOWJHQktnRDdJV0RoTDQzb25Y?=
 =?utf-8?B?cFdiL0ZQKzRlUVFud2syMzVIdUdzTVlHenpLN0txYTFDdUtiTUdzTVZDd3lh?=
 =?utf-8?B?OFlmL01uSldSTVFKRFc1QTlHVUZpdUs0M1ZBVWZ2OE5za1crbzFrNk5Oc1hX?=
 =?utf-8?B?eld0UE96M290cnRKcFNDRjNHVmY2UTFXeHFHQT09?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2025 18:04:00.2505
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a9070c36-7ce9-48ab-6d41-08ddea4b181b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A6.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8229

On Tue, 02 Sep 2025 15:20:51 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.150 release.
> There are 50 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Sep 2025 13:19:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.150-rc1.gz
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

Linux version:	6.1.150-rc1-gcdcdd968ff27
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
