Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2078.outbound.protection.outlook.com [40.107.212.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89EC21E492
	for <patches@lists.linux.dev>; Wed, 13 Nov 2024 19:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731527962; cv=fail; b=tCz0fZk3RHeJtaCrfjp2MYwMtr+ARa/Q+H0hd27MoZkjO+bV71SQzkYAIxCqQj5e/tEDF27d5N4iIDRgQzgfmgBwmYv4HQwb15Yb2bhsyqAaVZeeHbsNaCyaGgUDYMbgYcK3muxzLYfYF7E2Os+RqRzUY+6EmGrGrUuPGuee3wg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731527962; c=relaxed/simple;
	bh=BYZFzHoJUY8wpchFFYf48a7g5cvB17seZG7x4ZkO2b4=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=JMOUEiZebEgFBUx2tGDB0xrtaoJPLiu+7uxzyg2b7RkOnIp4Z4sWDxenUmP3Di7dCmAuddE+QQvNjO2yUtLFi/8cebYurBv2SDO7Mbao9BOu48sPHHtnCukNCUzRF+MYxG9bcOFMBtO3MBduvbmkpbv93YgzEoMKw3KvPM+zEtg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=DSu8hJ81; arc=fail smtp.client-ip=40.107.212.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="DSu8hJ81"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nlTWPvqduMaw4Kirf3B8w7cDy81W2Yz0PadcFNiQHFcxlGsyBhQ37rM6rvv4yesdHZymnQYu21bwmIZ4sI3RjHhaRwRQaSOMvEwdDtefc82uHlidkOrIgpx5lIj3EvsxSI7C4seskQnBDm9DxHhqimmJzOBe4emRMb041mT/bUpDGILWDYc0l8noMCljgXUwx4az9KW2CCnpq8nmsomUUJJFpbou6qn0CiPdnB7QmU8csV9QMeSwo/aZ2DW6IwsDizKQAfkhq4tjOB0DyUkoKoCgielmflHi/T+TsAncMpLCHVQYs71uLhLz5UAJfUaPEB44KstNuW9sAb6obc8z6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kKWlHMaFLYjESgermDCyoCj49okEo6GKPFnNr8k2IUo=;
 b=AQAEy3074GoFFSKidFT8JcVouNZX3xVNJabtCK3LL68/dXJ1baEqaAqRP1j6sAE8yREwpT4MvLUAbcIfbZXeR0KvXdsmJOEdYFBA4ukYmq8lW8eLAX7P+0Tr4bocPALKBEhvGytITQtuRSvl2v2aoGqHjGsgbUTvQ1ZxoJOVJaZegSmrwwsrHTuTozD1EtLHklbxKaFpxV7t6wtWN7cxuvws4ju8aVj27wLYYx8AJitzX2GMSSBQYtg5sxPZAkyqXA1lf8Db1mD1INqO6X5R4YMCToEbXVwUp1jEev0GpwEqL04D48Tdw7k6cYLx2y17chH0PQw6laixdYb89ilEoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kKWlHMaFLYjESgermDCyoCj49okEo6GKPFnNr8k2IUo=;
 b=DSu8hJ81Mu5rz5q09gFeLzyLIiQ/lK/+2o6PfXgDiEKdGFj0Y0ODJtj4blhRJGQ6siWS6lqULWcatAhprjKAEU+/GfA9GpKHr5DZuvn4o+JPq9IaQQQKzebKOiDxA8CxXrzXYaDr94QOAhQhHnIfJXoo7QwtgBPlu1iTMt1/Q7Rt30ZDnJC/pHfsOA3UEzPE2G5LUuaDiomnXuVoPRTWBqhROesnyzsbP6v+YNiCCzxNsLUY6Bu03peepd9FV14kFkO3imqWjy2/2am5DYvRyZZMsEvvxbdVVszp5OTExnmcLBUG2aluqRvo4ZZ5yBC5NZbAoAt7RgA9Ata7w8Z3rg==
Received: from BYAPR06CA0032.namprd06.prod.outlook.com (2603:10b6:a03:d4::45)
 by CY8PR12MB8313.namprd12.prod.outlook.com (2603:10b6:930:7d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.17; Wed, 13 Nov
 2024 19:59:16 +0000
Received: from CO1PEPF000044F2.namprd05.prod.outlook.com
 (2603:10b6:a03:d4:cafe::15) by BYAPR06CA0032.outlook.office365.com
 (2603:10b6:a03:d4::45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.29 via Frontend
 Transport; Wed, 13 Nov 2024 19:59:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CO1PEPF000044F2.mail.protection.outlook.com (10.167.241.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8158.14 via Frontend Transport; Wed, 13 Nov 2024 19:59:16 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 13 Nov
 2024 11:58:59 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Wed, 13 Nov 2024 11:58:58 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Wed, 13 Nov 2024 11:58:58 -0800
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
Subject: Re: [PATCH 6.1 00/98] 6.1.117-rc1 review
In-Reply-To: <20241112101844.263449965@linuxfoundation.org>
References: <20241112101844.263449965@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <5913cc4b-44a3-4bb4-b487-872233d60a3c@drhqmail201.nvidia.com>
Date: Wed, 13 Nov 2024 11:58:58 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F2:EE_|CY8PR12MB8313:EE_
X-MS-Office365-Filtering-Correlation-Id: 735fc800-7b63-4f01-3ead-08dd041da77a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aGQ5WVVHa1RTb3dSM0pCRVEwTjBvclNITWFvYnJzYkNaY2dtcFRCWG5VajBB?=
 =?utf-8?B?SFFJRHU4Q0Z6ZkVqN2QzTUxNVlN0aENoUFdjMWhLT2FrWFBGTWNOWFRscnJY?=
 =?utf-8?B?akc3L2dLNmdxR21tMW1mVXpYSUpFTzdma0JDY3NvU05OWkFFRVVFYVZuNFVU?=
 =?utf-8?B?bXdDbXMvOVJmM0kxUUloaXZPdlVNMmRMRXM4T3JVQk1MbWNUUkRkeTRYZER6?=
 =?utf-8?B?QW9GUStKV3VtVENpOWJDYU1uL0tHRzhBT081d2hBL1pjWThRdFdaQjA1S2cz?=
 =?utf-8?B?L1krVmxSeDFYSHhDb0hIMGxCb1J5dXd4ZW1Eb2JZcHhrM2ZBdVV4cUkzOWhO?=
 =?utf-8?B?ZzR1ZnU2ZVJ0V3IwNHJJdXJaV0ZtbU9qdHlRVHpaRVYvcXZDWHhIMklNZUtv?=
 =?utf-8?B?SFhMRWNWVVFrTndhTnEyM2F3RlhRbENIZEdCSzVFZU5KRGZONzgybWdWM1Bt?=
 =?utf-8?B?TlhrTmR1WEJpUTBuMVFHQmwxanYwTWRTbzRPd3lyMStwTlRKTXp3bFYzMWhl?=
 =?utf-8?B?Y2M4T0V1TS9ZbGFYbG9VRVlkbHFXcnFic2R0MmRQQ3ZwOEt2c2JlbXJBRjlC?=
 =?utf-8?B?anAyZVpIZ0EwWHNnT2tycDRINGFWNFlZMEcwN3BsZXJaM3NNRHQ4QmVVN2Jo?=
 =?utf-8?B?UGc2NWRwSWZCQmZ6cjJFM2RLQ0puMUFGOHBSMXl6SlZOQTVlcUdVZmh3MXFm?=
 =?utf-8?B?T2VaMUJhZGJqT1lMMGVwYzRXOExKWW44ZXpQVUcwQzEzMXFtbGlWR2wvOHhL?=
 =?utf-8?B?a2xWYVpTa3ZKZVFoWGhRbXF0QzRmNnFVZHhESkxBUjhzalJPVy9VRmpOWDFO?=
 =?utf-8?B?U1pGZEJMbS9XYytzLzg3OUVuTW8wS2pxWE1rOWNqTUJiNnUwSFhlSzFFdCt3?=
 =?utf-8?B?ZjBhSXo1NXcwM2xDaTE2SURiVEc5VVpORnRFMUhoamRlUnRENHoyb3pzbGp6?=
 =?utf-8?B?ajRFVEFBMi82SUo3K05rQVVnR0JGdGkzSnFKY1o1cTMxRzdKNW1ndUpyM0dm?=
 =?utf-8?B?SjRjMGZYTCtqRjRmem8rYjNyUnhPNG9DblI2SjUwaDNzcE9xRXo5aTU2VkVB?=
 =?utf-8?B?L25oNEcrdmE0WStxb1dHUUpNU29Obzk0MTlNekUvcGRHa2FsNFdKWTU1ZGla?=
 =?utf-8?B?Q0Z5UVlIZndYQjRHOWY2RWNITW02a1ZndTR1WjNWSlk3VmNNMFkrTlJkVU9R?=
 =?utf-8?B?bCtFMlJzSENMa3VXUlJDNzMzZW9FclNlSmkrdjJPZ2M3MzloTXRJUHFWbEJu?=
 =?utf-8?B?UUIxMmRoWHJKdG1jRkh6L09PaEpJM2xhWWtBUWREVDlKY3JZN1phak0zV0V5?=
 =?utf-8?B?OUUxMmM3a3BpdFVKd2F3bndnYnZaYzcrS2ExTHE2UHUxOEdoM2NKWEFjRjhp?=
 =?utf-8?B?a1VSd1poOHM1SkhIMnZPdWswS25jVWZtZUlENmxobWtlMFlYZ09GS3lXK2hK?=
 =?utf-8?B?bGZVc1J4WkpSZ2NDblVxYnVETXJDZmpiR0dHandxWGQ2dzlJNWdlU2VVRjUv?=
 =?utf-8?B?UWk2Wk5WNEVmaWRGQ3hzRk9ScURUOTArSXI4WE5xQ3dZMFdZUEpSdzQrNWd0?=
 =?utf-8?B?N1Q5bXNOY1owY1lGeTl1WHVwZmtEYVlGaU5wcFFzby91V0JLM2JabWEyZFR3?=
 =?utf-8?B?dmt4UlNRYlJZVG9xYjVGTXE1Mkg2MGp5dE50UUh3d0lTRU9qeitUMDhuekxK?=
 =?utf-8?B?eWpQdVFwaWRGblFHM09mMXVNRmF4MnlHcnhZQWlHRGlNbWNvWXFwa0tJOEdB?=
 =?utf-8?B?T0d6QTdobSs2M3Fvd1RKMTVrcmovMEpvUmFjbkMxQUNKWmVOTk0yZWJkWXhn?=
 =?utf-8?B?bHFVMFpZb2djU2J0bG9pNzZJY2xaV1ZvUCtHa3Q1ajBEbFluOTVaM0thKzF2?=
 =?utf-8?B?V2dhRnFjaWpTQzg5RTZJMGVDWHl2S1dqV2Q1dmUwbXB5aGc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2024 19:59:16.6066
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 735fc800-7b63-4f01-3ead-08dd041da77a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F2.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8313

On Tue, 12 Nov 2024 11:20:15 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.117 release.
> There are 98 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Nov 2024 10:18:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.117-rc1.gz
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
    26 boots:	26 pass, 0 fail
    115 tests:	115 pass, 0 fail

Linux version:	6.1.117-rc1-g36678e7f8e1e
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
