Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2087.outbound.protection.outlook.com [40.107.93.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7C2E219A6B
	for <patches@lists.linux.dev>; Thu,  5 Dec 2024 14:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733409582; cv=fail; b=gYyftDQZuJk02xkGGrXuFojger4+OSZuXWtHdp9hguaUdA6pBYrz3OOeN8juxkMYPGXgBumoQAbyKbEAWdN2Xz25zN/orx3SymJ52MDK0XVTJe6DLj34TcDbw/MH3O8qe+onTjAhDjVuo8NOc7OMdBLSoKdZ5vfpoKbrGvbRk4Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733409582; c=relaxed/simple;
	bh=f1EzZp9rUJ5f37jid95gqknzWN2c/zYfqfZNQyC7VlA=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=ZwEGZvrkEGC6dK+Y5XzOBGkuCIAKeaoGQsWyJemRTCGT3tfJIdgDUMDrfYxeS+hN3/rdfIrTAsQJk2dTm+Xi0wbNvFAuxUuZ1dZtsDA9IegweMseiNez9nSkn6euUhW6L8t0/quorx1XgMGcdNNUbevJUyvLc0RLXKmf0hDPqmU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=AcAkH6cR; arc=fail smtp.client-ip=40.107.93.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="AcAkH6cR"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VUAK4OMpndbYPVMq6g8dx4dqnkDifbsaCU9DwoqilG/SwTl+HRcBBwKJUfRAgyZi9BpRxaOWoKE7KazJOeG5ypBb7DW0OIP14EqgN98lxgwXioQ+GQUGALIc9E9LZNo7tseQGi/VTPqSYc1yt8IfmdzZok865pVckMTDALQxF9yK8m8u1ZhBqQpvo1ODuyt+DasMVjQl2aO3InQILZ/dismQ+RK5xIceT2XSHekArqqnARhSevtOY2L2qRcZbvpdu9xmkvedPruSy2DNNxSTE5cm3x413MocSpBLMKHKVCBXYg35Of0tLZgebJJ11tAvaH/u9a2uC9Rx12IcXwXszQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ubUS5EkHqjKUF+7IVvACM6+V8tkGVbBDMRIK+DxpBkM=;
 b=EmJUmJc/zKbrqtJlj+VJ8/edOYlXiptsRS/q8GslSFbCWlfg4q126MA0AoA76VBM/x3BNboTwUVV5J12dUveCvAVNECzsCgDobt+fP0BV0KKPzuHVyvfEBQCHvzM9aqRDKgdbLQFRoTBo4xASiCK2pf22dxoC24Y/hjtV2GA/lgd7SYFrZERnJlMjLNd/FvHZGZOeNKmK3PD4vf9FlvXqL/8fHe9EkKww5V9vWfUVEIJ2xOjpsr41LPPXYnaZi9mhoxsxhBBlUBJQon2TFVO8UYbxVuJnV+KsNLm6mcggpA//49fBVDiz9XQp+KTGNEefCGvOtG7kqbBJEYmdOb8OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ubUS5EkHqjKUF+7IVvACM6+V8tkGVbBDMRIK+DxpBkM=;
 b=AcAkH6cRv9Y5ybJ4vfpBKEHgtZKImNdpUftvzgyhK1a3kSeH2lazSRRcUx2tgXslnViIt0nX978pl/oEWiYZF3Yc0mLbbN1sjZj8OXhXEa7M4dFyh8rWbNTX3iGUzgA2GDsrv0kIYRMnICK2uyiXNEsvgHtlrk7na/DnIfJQwukr4bibafmUb/TRwNiBCnu9M1F5tv7kQ5Bqm4ZcxNgA6f7WM37XCWn97d9iQRM5/A3ZpTHWC15vrFzpwNALaAJOpP6okcQICWunojWpJ61GDIab0/pDQYxWVtKbtppg0oHSPlelTX9USeYHqWmTvUrOfW442GjTrCuUTm322fPkUw==
Received: from BN9PR03CA0388.namprd03.prod.outlook.com (2603:10b6:408:f7::33)
 by MN0PR12MB6246.namprd12.prod.outlook.com (2603:10b6:208:3c2::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.19; Thu, 5 Dec
 2024 14:39:33 +0000
Received: from BL02EPF00021F6B.namprd02.prod.outlook.com
 (2603:10b6:408:f7:cafe::32) by BN9PR03CA0388.outlook.office365.com
 (2603:10b6:408:f7::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8230.9 via Frontend Transport; Thu, 5
 Dec 2024 14:39:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BL02EPF00021F6B.mail.protection.outlook.com (10.167.249.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8230.7 via Frontend Transport; Thu, 5 Dec 2024 14:39:33 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 5 Dec 2024
 06:39:26 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Thu, 5 Dec 2024 06:39:26 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Thu, 5 Dec 2024 06:39:26 -0800
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
Subject: Re: [PATCH 6.12 000/826] 6.12.2-rc1 review
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <154b3d6f-0597-4ac8-ade1-f613f03804e2@drhqmail201.nvidia.com>
Date: Thu, 5 Dec 2024 06:39:26 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF00021F6B:EE_|MN0PR12MB6246:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e45c9b0-e271-4269-f78d-08dd153aa269
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|82310400026|376014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?U3Z3a3JCdEZ6c1hPTHdrbGh4cHJsSDJLaGlvd05IOWxOTUhsTUF3K2pJZkxj?=
 =?utf-8?B?cWUyWVptclV1ZkZjVmJ3c1A0STFKUTRER09sOWNrUnNkaFJYQkRSTGk2eDI0?=
 =?utf-8?B?bEZQa1QweFByODZVaVRRdTJNWG9WTk1rWXgxMmZpeGNaNzA2YUlCbzYrZ3hY?=
 =?utf-8?B?SUN1KzQ0bzdzODVEQjJvb1RURXRod0dmdFZRZW0rYnY3WEQra3ZCQlJncVpF?=
 =?utf-8?B?WlRqQlUrdW1Rbnc1VHcxSzJEODhjVm05OEUwcDJaajhjckdoT0N0enZCSEto?=
 =?utf-8?B?enRiRDA0R3RLQXNJK0dJMU84VGp2cHFYL2pFRlNTT0ZjcFpjWGRHcGhLUDll?=
 =?utf-8?B?YkJIeVIzMjhLM0RWSWtGSENsMlRlazlWZGJwRERxK3gxRkFEVnVRRTRvQlpS?=
 =?utf-8?B?MFFCYU9UMmptTUwzMnVqcFQ3T3BHVHlhVTFJNlhrNENYalpsR1RuYUs0WW5U?=
 =?utf-8?B?eTBqN3k4QUdLakdDK3FTTHdzVGdLNkZWUEhKcmxXb3FRK2QyUTcrWFFtdVBr?=
 =?utf-8?B?T0RXNWpURG9TbU1EWUZGMTlldjdkZ1RheDFmT0ZVZjUxUGxFcFVTYy9hR1M5?=
 =?utf-8?B?S21yS2dpK3BEaHZMNEhGSDRRck90KzFxaXNMUHV0QVlJampWY254UDdUNm9K?=
 =?utf-8?B?M09HeWV2djhjVmhyVWJqMFNpNWEySkk4WlNPTVpCZFlOUXQydnZsOUVHUHlv?=
 =?utf-8?B?eVFQdGRKOUs0NExUUUl2RnE0NWRyOS9jbjZsMEFGRjc2bm5FYlRZNnR5MDh5?=
 =?utf-8?B?cWVUb0pubk9YSFNXRnp0YTVoVk9GdVhHc20zNWhhYWlTOThuMHdDMFcwNnpG?=
 =?utf-8?B?UVNzM1l1WFNRMGNaY0luOGhNdTJDMFVUUDBGU1dxODRSOTc0UmlROEx0N3hX?=
 =?utf-8?B?Q0NuYjZRSGxMQ292a0xSUUt3WVBjL1J3V2ZMdjdoaWcybUoxL3ZIV25Zc2xk?=
 =?utf-8?B?MXAzZW54MnFWTmZNUkszSU16YUUvUEpTTlVNdGNQWGk2S3llaHNobkFwZUpw?=
 =?utf-8?B?K0pBY0p6dW5pZThub2hlSHAwRFVwejgreHJrQ1ZIengrMEJLcjZqWE9kcHVI?=
 =?utf-8?B?Yk55R09hU3ZvYmpzQ3F3RHhhNWU3U1p0ZHlnVEpvdkZha2NkYmJUQk9iQ2VH?=
 =?utf-8?B?V3kxczM5VDBUU2F2QmRKTC9ST2xzbVo2UTRIL2xsWFV1bHRhWkZobHVndDZB?=
 =?utf-8?B?WWxqQkVxNUZGWjEzWjdraWJIdlRBQ1RxYS80ZDdGOEtmNDF5dXB3ell6YllM?=
 =?utf-8?B?Z21zTkZTLzlUL2s5bm1CbzN6M3VueDl4R0REbm1qQlYvdmd2V3JuWWo1bi8r?=
 =?utf-8?B?T1hmSExnTHJhRVk2U2VLblAwOEY3b0hUM25Ua1NjcEZPOVdVVU9ReE84MmJU?=
 =?utf-8?B?YlVuRUJxcWJnNllTelFiQjhJOUNhbDZVSW8rK09yZGxEeGlQNmo2Z0lFeVUv?=
 =?utf-8?B?azlBTEpJUVAyNjNNclRRYnNQNHVmcmdhMHlyR1ZMSm9wSXBXcFB6OVBiU3N4?=
 =?utf-8?B?MlRCMDR0MjJjQU9zYjJDaVhZc3ovR29ORXpmZE9XWDN4V1NnbTVTZ05hYklt?=
 =?utf-8?B?MCtTSElQZ3lIZ2FHWjZiakxuZDVEdGoxZWVmT1poYVdJeXRJby9OdkgrTGY0?=
 =?utf-8?B?ckpWQmpuUGVFTHMzdlNpdnhUaEUxZENML0ozOWlKZWRqTmtmMXVKY2t3TE1W?=
 =?utf-8?B?UlQ0TWtxaEVvSWZUMk9ib3IxSUVhdnZGc3RaQ1JRZ2JMVkM1SkE0MVlGYXU2?=
 =?utf-8?B?RU1OcmRyLzh2eG1zTWEwc0hSbHlPRmhweERDYTM2V1ZwNmRWQVlaMHlFdGpz?=
 =?utf-8?B?V3ZhNnVhVmlqSTUvSGg1UmV5SjJoSzE5ZzRFR1VKMzQxREppQ0Q2UERzYTIw?=
 =?utf-8?B?U0ZvQlBmVmhlTkRmWVJncXBPZ0xYNEd4UThSV2s0RklVUnRRREl4R1NTU1Ar?=
 =?utf-8?Q?PlLugftbyAHfnrbjcmH2zkl4gx6W/0xB?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(82310400026)(376014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2024 14:39:33.1587
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e45c9b0-e271-4269-f78d-08dd153aa269
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00021F6B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6246

On Tue, 03 Dec 2024 15:35:27 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.2 release.
> There are 826 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 05 Dec 2024 14:45:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Failures detected for Tegra ...

Test results for stable-v6.12:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    116 tests:	115 pass, 1 fail

Linux version:	6.12.2-rc1-g1b3321bcbfba
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Test failures:	tegra186-p2771-0000: pm-system-suspend.sh


Jon
