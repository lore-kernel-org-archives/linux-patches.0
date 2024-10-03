Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2088.outbound.protection.outlook.com [40.107.220.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B1CE19F13A
	for <patches@lists.linux.dev>; Thu,  3 Oct 2024 14:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727966444; cv=fail; b=mzQWQlfL3EpIQRVU/baJI/aMlB3giwVcOtSunAIVq+Iqjn20k1z7M6eeyMG9ZLP+NnMtWaZSEO7P6EsfmJbDTDsNCnkp2lgqLKFNRTm+GL2vYxX2Tlp0bMAt5iEnUyAOB1tkPakxVIly3aEGv8hHx1Wi5gqsrlxEfk7g38/MVro=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727966444; c=relaxed/simple;
	bh=pGZiRm6przuFx36Ojqktq8jmFhK3D7WFBnOEhCYV79c=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=rzfMsFlUn2ULlUMLJxBRLmVQEKa4yllklaSMxh9JZQxrA/7YKiv1ynK+HX8sR+pp+0JMzHF2e3Gn5faXX0nBvXXcrFH9rmpsF4H4mEb5NPHOj5DjNqoYgNO7lIpFT9RSrSQNA22uUBYYQjjsJYwyuqU4hwINFCLEkJjjq9dXFNU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Y7XxJc+H; arc=fail smtp.client-ip=40.107.220.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Y7XxJc+H"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tVoxv2AEucX4IntOVRfrDbAvCe00NRFbCQpG2Huz7uUAK6y7mAk7FRSQmDux55ymqZWaxvOEsxbEgfrfiQprmJbp2Q7Obi65YLqTjcEMlFOipd2Zigkx7z6EFVXoO125pLHfQeyOxR3Jy75I5cQ502JZZ1PohnoKiVR2EXmZ4Cbw5mfAUuKADTIogvl/JkZp03JvOvihcTpLNqA/Q7LOclh3T2m1+QB+n8EFoEYHzny4lip8w058Nv0NR+lrPvyqr4yE7BCV6ePk5EVHTQVFcVDQhtO37DIpZ2mc3M/L7GsVkDp4PGruC8lVQmsDNFa0aLrFNyNT61XjsRxtD6pIzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W/2fLYJYsDZSgNdLVAt5CPoRbQ8/fVWmT9i/6zSWOEk=;
 b=q3JZ4XFgbnqV/lC4Qf9DMy20axlxzj4qkz+Qm9FjlbvB4KWMHRwV8G3wNSzy4/6CuJ1rzL4f7Xku5nfxNlT0QskTWQzXIaHwlSnCPojpq5t/XQTG7/X1vGp6zaRL0aXaJDsp9ChtIzRQXHcgGeXQEqGp4Em4LwPAvw7ajuc32VDe0se7oKJCKCZ3Q3Hbt9HULOy9YnkgmGPq7WsGqfD7AEJv+czuE3FER/FMkn1XMfx0AHbC8iGVh1amyznmvYKaf2kXXQH/INVTTt3GIM3Z2IhZ24ZO343WOcx3fiW4r4FpYayw0mCS/dhdusjaZkPXwgOb0cc+hqgSMhrZgCnHsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W/2fLYJYsDZSgNdLVAt5CPoRbQ8/fVWmT9i/6zSWOEk=;
 b=Y7XxJc+HwxGwNhaUJNGX2M6DU/t/t6eSF33b0VPgGGZEd/GFsGGy28tJexvo3p9wbuHp2QLifAeQlaNr76meDwElwzcGViKhkaJ6Ah40m8TQykefpGdk1gS66OoBeIdOVvJIEfqG3Dzz+kzSdkpE8hdf5Kv7z8i1O2BkgLfZjhLn5G4YkOBF10LxZxPjiE61B1ZMZptpMGHYIoytDOYv4O+0OCCaI38Otyj8qFPU5BumDf1qFwYh7YdyekjsoDV9z9gqoJedpDP6wD/JXOaNEYhjkh6tpLPn/uysgJ4kmw5+xFt01E2dtJylCHVs8bC76YXjO7uS54Iun7X6RuHz4Q==
Received: from CH0P220CA0001.NAMP220.PROD.OUTLOOK.COM (2603:10b6:610:ef::19)
 by IA1PR12MB7759.namprd12.prod.outlook.com (2603:10b6:208:420::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.16; Thu, 3 Oct
 2024 14:40:37 +0000
Received: from CH2PEPF00000147.namprd02.prod.outlook.com
 (2603:10b6:610:ef:cafe::e9) by CH0P220CA0001.outlook.office365.com
 (2603:10b6:610:ef::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.17 via Frontend
 Transport; Thu, 3 Oct 2024 14:40:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH2PEPF00000147.mail.protection.outlook.com (10.167.244.104) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8026.11 via Frontend Transport; Thu, 3 Oct 2024 14:40:37 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 3 Oct 2024
 07:40:20 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 3 Oct 2024
 07:40:19 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Thu, 3 Oct 2024 07:40:18 -0700
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
Subject: Re: [PATCH 6.6 000/533] 6.6.54-rc2 review
In-Reply-To: <20241003103209.857606770@linuxfoundation.org>
References: <20241003103209.857606770@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <b5dce78c-2f39-4cf2-b653-067673000663@rnnvmail201.nvidia.com>
Date: Thu, 3 Oct 2024 07:40:18 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF00000147:EE_|IA1PR12MB7759:EE_
X-MS-Office365-Filtering-Correlation-Id: bcbe2e76-5be2-420c-c7ad-08dce3b95874
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cjAxdjdGMEladzVvd2djVDQxMjlodWpUVDRQL2FOdlVQdW45SHFQQnUrbWNr?=
 =?utf-8?B?MzlqMTNJaWVRNC9iSFdxNnR3RU82SjNLbHZsajZJV1F2NWZQWU4waitCN0dt?=
 =?utf-8?B?WWhuQVI1Z3NSTEI1MEwyeU1makg5VC9rbDRYS1cyYWIybmZXT012alA0eENZ?=
 =?utf-8?B?SFFKQTE2WnVNUkc1RHNMZUR2ZC9HSS9uSWFpVEZua0p3bGVNcXArOEZwa3Vy?=
 =?utf-8?B?U1VyNVY3ZVo3OU1tdERvUnRiRGlFV0c4eE5meURrTEtOQWdscFIyQjNDeE5E?=
 =?utf-8?B?OEZuMys2enk3Wm93enMxQVJhMEcwdXNwdjRWM0F4OGNrVEUrNzB0Nm1BOTR4?=
 =?utf-8?B?dTJEUWdiemRrN2p1dy9SdjgrUkxNV2d6YlF4WVFmTC9UQ3dGQVFsenpWNUtR?=
 =?utf-8?B?amJsLzFxdUlRa3JoejJBVUhGWjlrS1NsVCszQVZlSWxWZ0pUQy9RSkh0TlQ1?=
 =?utf-8?B?b2xVY2VhSEx0aGRVN2ZzSGVsZGJNL3BTMTJKMWxhbi94bkpKeHY4NGhxWFNL?=
 =?utf-8?B?bHVwVkFpeFZWcVdBVzJTQlErUjVvMkRtN2FmcVdSYkJtdXhCbFk2c093R2lR?=
 =?utf-8?B?OGI0RldPN0NmY3pESm5DdFRUZmltUmxKMUdjcUpXOGpYajZKRjFlZWZiMTJh?=
 =?utf-8?B?bmJyOEI1TUJWYytsOEUrdUtaUCtEcU5xcVlrQzEvQ3I4TWhIUnpqV0RBVnBP?=
 =?utf-8?B?d2p1ZjlZU3h5eTRSa2swK0l5S0V1NHllU0lGUHpkVXJ5MUhURFdWTDlTbkNY?=
 =?utf-8?B?Nk9RV051NHMwR1Q2b1YwS01nZGtPR2djaFpXeWFtQmJxYlhHaHIxS2hLL1c5?=
 =?utf-8?B?cFVFREM2TEZucHJxRDR4MEFPNm9RR2xLTWxlWk1nQUFrN0xSNWVHZEcwSEN2?=
 =?utf-8?B?a0owSmdxWXNKa2JrenVYdW5BK3VIOXY4OGw1Q01FUVFnV2trcmpRT1dqTVgx?=
 =?utf-8?B?NUttUnhCVXFQYXhOdFpGcVBuSWtpSHFaTE5ZSGVVVHU2N2w1cVJOaEFUM0NI?=
 =?utf-8?B?Q3NsZ2hyeE9KdFpwMDRuWFNoWFJMUzBUQXMrN1AyM2Q2cHFBMHF4N3RzdjRP?=
 =?utf-8?B?eUs5YWM0QVZVQXZRdzZBc2JNNzFYSVJZZGZZZVFiSWNCaDFVN3N0NWlHMlZB?=
 =?utf-8?B?RjBBU3J1MTF4bXRJOXljcm9jRTl0MDlMMVQwdUtYU0xCeVNLdTRZRXRZWVU4?=
 =?utf-8?B?SDE1ZTJFK29DY0c3UFZaRmhxRzZOQ1VNL2krTnVrSEdVVFdGVHZScEo3ZGNJ?=
 =?utf-8?B?dEYwaTZXdVBzb0s5OUVIN1FlL2pWT0IvTDN4eHdueUhnYXJtZ0ptNkVoTmYz?=
 =?utf-8?B?dzVWa2gybjRGNmN0NmYxNE1HbVZHS0FCRFNJeG43MndMbGVSNG1IblVjKzBi?=
 =?utf-8?B?M3ZSejF0Q1RWZ29KeWNrVythM1NVbGRZS3F3NVlETi9Pa1Fib1grbUZ0Zmxa?=
 =?utf-8?B?MTZPWTlidVUxNFRwdkF3bzhXcTI0anF1ZGxVSDJTQWNOUDljWC9SV2lyL2xB?=
 =?utf-8?B?cU1wR1JUZkJuSDJqK2hNbmFzOGpZeTB1Nk1LRnRlNVE1TjBCNGdWdm5IcVd3?=
 =?utf-8?B?MTB5eGthbXA1MmM2dG9jYmJURk1lbzVvbWZTeXlwTjZkRDlydE9MaVRSM290?=
 =?utf-8?B?TFN0ZnFCMFBwa2pOamVHVmhJMExLWEhNQWs4aEJKNEFSUklzTTh6UEFzYnFj?=
 =?utf-8?B?OWdWb0tlRHkzQ250RTU5Myt1M1EvMnZVRWtuYzdtTkUrTmhWNWs4WTdXZXRO?=
 =?utf-8?B?dkFkU0EwZlZCbzdkV1k2Z3c1ZWFKR3RFc241TUNWU1pTSkZSOXh5UFFLUEdq?=
 =?utf-8?B?RjgyL0RXb1I1V21Xc01aK1hJUjNScTlNQW1sL3I2eWFaNmNuQzN0dlI4enNr?=
 =?utf-8?Q?OeIJYc6dgJemO?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2024 14:40:37.0708
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bcbe2e76-5be2-420c-c7ad-08dce3b95874
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000147.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7759

On Thu, 03 Oct 2024 12:33:11 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.54 release.
> There are 533 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 05 Oct 2024 10:30:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.54-rc2.gz
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

Linux version:	6.6.54-rc2-g28c7e30f3bb6
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
