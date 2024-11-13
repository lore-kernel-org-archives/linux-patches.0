Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2058.outbound.protection.outlook.com [40.107.95.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B78D41586CB
	for <patches@lists.linux.dev>; Wed, 13 Nov 2024 19:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731527931; cv=fail; b=FAwB5JLGizrudeNNT9QP7dnvaVG0tKlGY9gP37e3PboTrFlnpLXZDsk+qsaagUfjm42dgcIVN8hVT+XHeosgRpH5zQLAF/Jur9+sjJLpChMxNzCVAN8bh7COiS3R1UrxrbIuVNYe1fBRXpkiJ8NiAEoXxTOjjAYkR8K5YAVME/U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731527931; c=relaxed/simple;
	bh=hj9CF04ByYOE6P7VojOoqju4sg/ss3gix22LzNgRRw4=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=IX1IEkKfSHQNnWtyPHnACvmwIaPJ+YeEkjvb0QFUWZJ7vBBcVpE2MarReEEJ1S44bYlMFp5uoZ9UKU6zCx/5w1bCW1eNB7h71t64/H99ZuJGjxvC4XyyE+49wPOUq0H+3ZFJ4bjedCLjUSXg5QCe5b20VKnmY1vbumOfyCNozE4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=tCwV4Mg9; arc=fail smtp.client-ip=40.107.95.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="tCwV4Mg9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m1cbwrWwNmaRqt5zcHm9eqcxCRPeIwVGSJv2aitNQvzyYmHlURJwt1VrMAs/tamg9+QMK/p7Vecxw3Ku5gcXb4w0ukzUgPJHN/5WZGf8BDM9yvGd/riv0VFBLe/5W0l1XcLnJeKhr+1OeDnysQ4N4MHsK7Apt9xn+hJs3GBPxni2ZyW2gfxiixD5FdGsFdh3NOrAD8yZNnNzT0prv1S4eQgVO0Q/7wTf9mkAzu18OmCHCacP7aDaz6rPIcB15On2cDdooZVPmNDQPxyH8WVaA93hkr5xvxoj8tKuIe35nRXeD2ouNULmW8UT1I4NBV7J6IKaUkZ0eq5ZogQFWpr92A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lv1+Q68UPFQdg92QyLH2FGQoIWSp/dqmRvi2gnTfV/A=;
 b=PuPO0twhcAemZlc018IXeng69ogEL0UFBmfkrMp5vSGdzCR7X+iQydUdxtdipr7GQ8RuaM9brktbDC6Z2em8US+TgY368w3Vui8APHWyI7ipDCVqAhJpLYXjGABayoimqu01Hyb+OMKAbqX0WyBAc7mM8dNEtpM7nQMzVts/4kCTa7NgR0PPEXVFbyd2M2ffc+7eHGty9p6g1oqAwx8NKODniH77++XIx0kC0DjKDrGT2p2NySXCGaPlKal2/owswnwrVg5RNSe6+8P3A4KTo7UmRItOKiqgCqCMKx6fdifu2fMUI90osGZnSuKYlEdy2UKNJGrrihDtfTifsZZ2Pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lv1+Q68UPFQdg92QyLH2FGQoIWSp/dqmRvi2gnTfV/A=;
 b=tCwV4Mg9xZq1TmPthGS3nrXiJVw/f/LrfapEtxONWlGz0PY2jXdNscqspAkSCw81nlzdL1f3rsF6xm/VjJrYIs2I8v3l44X2vloq0vDWRTgwoLRLQ1vOcumn3E9SnRRNIrgxgJFLN6XfnullJ7/w6fDvo1lu2D7ObZD+Cg/9WAsczx9eJdNDLhR6qfuYArClOhvu3PIsnfuibXieyiVl/ac8CIxr1oufxdyxZ4i3fV0I0Qo6rmb8LjfLLPTmBvlBS+s35sRESnUHMVVQK1mwRFvuwKQR1SroGM8ZIHaBqohHlbsoFswmXv20Q+KeuIXapVWb6WQCDYOkfw7bQhlvLw==
Received: from BYAPR06CA0023.namprd06.prod.outlook.com (2603:10b6:a03:d4::36)
 by SA1PR12MB7293.namprd12.prod.outlook.com (2603:10b6:806:2b9::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.17; Wed, 13 Nov
 2024 19:58:45 +0000
Received: from CO1PEPF000044F2.namprd05.prod.outlook.com
 (2603:10b6:a03:d4:cafe::1c) by BYAPR06CA0023.outlook.office365.com
 (2603:10b6:a03:d4::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.29 via Frontend
 Transport; Wed, 13 Nov 2024 19:58:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CO1PEPF000044F2.mail.protection.outlook.com (10.167.241.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8158.14 via Frontend Transport; Wed, 13 Nov 2024 19:58:42 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 13 Nov
 2024 11:58:27 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Wed, 13 Nov 2024 11:58:26 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Wed, 13 Nov 2024 11:58:26 -0800
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
	<rwarsow@gmx.de>, <conor@kernel.org>, <hargar@microsoft.com>,
	<broonie@kernel.org>, <linux-tegra@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 5.15 00/76] 5.15.172-rc1 review
In-Reply-To: <20241112101839.777512218@linuxfoundation.org>
References: <20241112101839.777512218@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <dd95eeff-aa5a-439c-9460-8091dc0bc1ca@drhqmail201.nvidia.com>
Date: Wed, 13 Nov 2024 11:58:26 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F2:EE_|SA1PR12MB7293:EE_
X-MS-Office365-Filtering-Correlation-Id: 36d157a0-42a8-48f0-b7a9-08dd041d92ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?U1JmSnFYOENQeUpDZTB5OVBGU2ZqbDYxbzVPTVFrdEZ2QXVRa3RvN01FanR2?=
 =?utf-8?B?dU95VEJ0elluZHZPeTkvRnNoeHlOODVZWWptNk5GY0pDN3NwN05iSnR1NWxS?=
 =?utf-8?B?VnA5S0xzUXdaNExuM0oxa3VWS056bFAwcUZnWHhkb0ZveVF6UG9YK3piWC9R?=
 =?utf-8?B?Sjd3QXNza201em5sb2pZdEtaTlkxQjNvd2lHU0xJR3RaSlM3b3R0Yk5lMUta?=
 =?utf-8?B?dTJaRDd6RVhvQ1ZmcjNkY3orU01HeTFBZ3RhMXBKM1JVU2pkcHBzTGNiUTlL?=
 =?utf-8?B?dFYxVkY4OHJQMU50UnczSjAwQ0YzMkprU2dFclpRNUdzRXVkVFp4dUZkeWdG?=
 =?utf-8?B?Z0YyUVJWVFYwbGRJeDIvOGc1UlFKa3NVcEFsM205QWptTG1kdnROdVl0Rk9Y?=
 =?utf-8?B?S0psVld0M0s2OXU3S3hxYnFVaVU2RmJLWGxRdndNb2pxb3pTMVBGSC9JOGtB?=
 =?utf-8?B?Z21paUZ5ZTdqOEdJajE3a2xjam5xSXJDbjhJSEowdTBPZnAwd1AwMXdaMDc3?=
 =?utf-8?B?aGdSREFTY282MHJ2bGRWdTdZaU5PMzdlR1U3VTRnT0RBQ0JKSVlPcDhsNDFl?=
 =?utf-8?B?RDE5MXJST3I5N3RiakNUU3BPeGpoTEdING1meDhtYS9nbHVzOHVaditSSnk4?=
 =?utf-8?B?TWdQeVhiNGV2RlNCNjhwTEtFR1MyNzVLU1RsaXkwWjMzRlk5Vno1Tzk3d05F?=
 =?utf-8?B?YnMzMThvZXlYRnZIVSs5L0VsVnRJWXk0UHBteDVYSnBjUVA3QVcvRXY3Q3pw?=
 =?utf-8?B?QXVaWGkyaDA3dlhFNEVvWVk0SmVlSG9FbnQyQVgvMVFpV0NnQ05BSVpGVzlW?=
 =?utf-8?B?dkp2Qi81MnBvTExtM0NvNTlaQVRlcGYwWU43K3JobGEvWkZpc0ppWjNHbW5i?=
 =?utf-8?B?dm9WdnhHdDkvRnhjckJGYTBCcU1ONWVJM01JNlB6MUJtT2ZPb01xQkFGUWlt?=
 =?utf-8?B?NHFSakgrTy9qcGJxbExTQUZJeExYVENNU0FsL21yRDhKcXZHQ1lUY1lNZ1Fk?=
 =?utf-8?B?WlRBU0ZCUmsxeUtwTXVvdk5CVTNxcE9jeThCUjZmeHdBNDU3bHhuZ1hJdjhp?=
 =?utf-8?B?czF4SU5neHp5Q2tzYVFoZmRaYmlCYVEya2Jxc3dmS1Y4eEJCWlMwK205eHdK?=
 =?utf-8?B?U2ZTT0c4bldnN0ZHeFc3Szl4c1JjdzljZnRUS0N4M0lrZXkxdUFSSlpJTzA2?=
 =?utf-8?B?ZDMxL3RtN3YyMWwxQmJqRWE4Sy9JTTVGbDNSaU9Ic3ZwaTdPRWJzVWU0amUr?=
 =?utf-8?B?cEZHY1NCb1J6L0Y0UENvSWhWYTRUemhpZithbTlXeXdOZmhSaDBZMCtpT1Rx?=
 =?utf-8?B?Z1h1Z0VKRW5ST0dCZVkzMEpUK3ZtSTc2NXpFS1pPMTVtODJHQjZCNkNYdjRa?=
 =?utf-8?B?OXNlazJzOWg0bUJtSjBvSzhZeUJocU1UTVR2dWFUVUZVZzhNOFJmVW5ZU3Uz?=
 =?utf-8?B?em1Bd09CY1h0TGdmZ2FZYzdsbk1tUW5UY3RORmtTNGhFTldTVWR0TFFyQVBP?=
 =?utf-8?B?U210VU5VeThHSVd5dTJhbi8vNmNWd0YwYSsrbzBYeUlQWWJrZnNZZ1J1engw?=
 =?utf-8?B?c05lRSsvaStJRjlKWkcrMFA1K0YxaDFEa3UrR1dIbldPMWRxQ0I0Q2hSU1FF?=
 =?utf-8?B?enM3Uy9PU2MzaTVFb1FkVDl6Um5UWUtKMExxblJ4anZ0ZHhLUFNNSDZOdXVM?=
 =?utf-8?B?emlTcEVxT254cnJCb2lDd1AxRW1TUWlFcjFMbm1NbnRXdlc2SXFjTFVjME9F?=
 =?utf-8?B?Y2NHZEsxQ3g1R0x4eGQ0U0tMQ3VWeHFXT2RDWGxaV1BMVXpKL0lWSTdtQzJq?=
 =?utf-8?B?OTNwWVdOdWg0V1c5eE15RUFxK2U4eUhZZWhWL1NtMGY2V3FNLzRSU3V1NHFn?=
 =?utf-8?B?MkZyaENWa3RBSWVFSXNwNnlHRmtyMmk0MmZncmc3YjV1VXc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2024 19:58:42.1221
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 36d157a0-42a8-48f0-b7a9-08dd041d92ee
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F2.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7293

On Tue, 12 Nov 2024 11:20:25 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.172 release.
> There are 76 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Nov 2024 10:18:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.172-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.15:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    101 tests:	101 pass, 0 fail

Linux version:	5.15.172-rc1-g0ef052d947fe
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
