Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2083.outbound.protection.outlook.com [40.107.101.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FE4628CF65
	for <patches@lists.linux.dev>; Wed,  4 Jun 2025 09:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749030032; cv=fail; b=m03+DZTSztTp5V2kkU5WA0ftbdhIgzOuEkwzanXdnPNfsA9rLXYlgSm9rtDfqsl6j7X4kpR2DOHs7Rv9bqLtjMygWx0bf/BVTQeTE8cDMMAgLHIFYL0jyMVb21lIg0G5q/dt7h+qY42CydJHaSVUNtwRrXEB8LYLxKZtyiWTAzs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749030032; c=relaxed/simple;
	bh=tWwLMPJz0bhHsojQifcK9zAR4tagvz1n6tbggRvddbs=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=q5ymUm9H2C7iTCJn210E37mEPo8CANXQMh1vIt4fFDgBHQqEoW616QJoxvE8eeeYekGIAfr3p9q3hSMYU2YYbAKWucDX5ssAhN/WcrcPFte4AJvTvx33zHwEz+y3snic1FqLEfPktoBXKbe/cf67FbWBDLNaPKq2voe7psy9SuM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hAZ2Vltk; arc=fail smtp.client-ip=40.107.101.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hAZ2Vltk"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vNgs7IiHdI8/tmCa262YYPB0Avdj4uc5BtWXQTcppIZp52c7HLaMT6YrMqJzvqZ5I9vw6va8P4CS1G+bGYMJSEj3P9s+tnD3KgsD9FQJDGpjcTWcfF5Jh/q/Y2ibxvPYGsjSBQP69/6ZgSfLEXUpZwqVkxv5XUMt7PtRMUzMJo7uOxPUjj9Pxwl5A8vV8fXHWCcKVM5/jd0KwZgRtR4+mXr21ityzVxEVCGQgPEuu47geZ9w/c91N5IJyLioKf8aMfu/TNoS8doKvEEOM2+8oyTo5OGvBWoWoTosGViS4s5F8KvqpF0mzMshG4kphbbXVH569nG3bzuPT+wc/DJIxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PjIokMaEVpnac7kQ5/CXrZenCEKSZMZB97AsYDRNUT4=;
 b=Bol35qE3sRiCFrkOY8oYtxCbha/mPth4bi0YzyiVmaD4ErLEY0aBz+4/bccLmpNiatvSHZLaSBfGSxE5EeXoIAMrwi0i8DP6WxyXBSD5NvtRtDoCKi3C9LjL+QCGnLRqPgGpZ+vXw4QYG0mSrCKBZqRwCx6gYznlC3U0q0Vk0SJpqRDc5GgFWgKtC/xh/AXpfo0+9lNRHhOYiNHo0tgF0g8YEEszEabXrUKWdN5qbPRd9QpSnNE8g28AMRpExoQgq2SR+dNkj5AvmoAioa9MJTgop/C5PVrzbh5LclSPT7s36OSLtd5lb58Pn8p9AZMTMbl0qRHO7+4lamxG5Wh/gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PjIokMaEVpnac7kQ5/CXrZenCEKSZMZB97AsYDRNUT4=;
 b=hAZ2VltkzLgQvncCe+A4ril/fjc7QUvcIbXwjdMGCo3OAB9cN/UUvK3h//DHAInebEHxYnqrkSd0SkVPNVhUQSSrGbjlorAl0yaTwlrmzrF9GdFaCatbczfq13KK6eHd987lDzTfp+xCj0B3nBjOTgc1knSCnFTgtm7k7KbHPCroHNyfWh55iRKNsrohGdNL8BJfHcbqJjBeM8cpJHTQ2PSGJrQ4O6rLMnIu84TclTEUASqgvsTaUxCaDiCrfeRpWoS2lZVyhBUkunq92Q2c4sT7S3LCe6D3lYTCjhRSjwzK+g7Doky+9JVkJpY/mkPpZ/7muHhGJjJLUqvchO5APQ==
Received: from SJ2PR07CA0017.namprd07.prod.outlook.com (2603:10b6:a03:505::17)
 by BY5PR12MB4210.namprd12.prod.outlook.com (2603:10b6:a03:203::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Wed, 4 Jun
 2025 09:40:27 +0000
Received: from CO1PEPF000066EC.namprd05.prod.outlook.com
 (2603:10b6:a03:505:cafe::4a) by SJ2PR07CA0017.outlook.office365.com
 (2603:10b6:a03:505::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8769.19 via Frontend Transport; Wed,
 4 Jun 2025 09:40:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1PEPF000066EC.mail.protection.outlook.com (10.167.249.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8792.29 via Frontend Transport; Wed, 4 Jun 2025 09:40:26 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 4 Jun 2025
 02:40:12 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 4 Jun
 2025 02:40:11 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 4 Jun 2025 02:40:11 -0700
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
Subject: Re: [PATCH 5.10 000/270] 5.10.238-rc1 review
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <935ef5b6-75f8-4348-ac2f-2d842e804f67@rnnvmail205.nvidia.com>
Date: Wed, 4 Jun 2025 02:40:11 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000066EC:EE_|BY5PR12MB4210:EE_
X-MS-Office365-Filtering-Correlation-Id: 749d17ff-a9bb-4558-5e98-08dda34bd63d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014|7416014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TnhSTFVrZnE0ZDdMMkVFaEJ1TjdNZm1uRGprQS9mcHVzdDZURkR1bEd0a2RO?=
 =?utf-8?B?RCt2VHZxQnh3bFRNclE0bm9QS2dlTy9jZzJWcUxBQ0RMZFZFM3dFRDBPVlJB?=
 =?utf-8?B?Z1hnM1l1UVRqWVBWUU9DR3lHT3dYYXZFRkxNVTRqeC96OFVhazRZWmppVEhK?=
 =?utf-8?B?aUpBTEd5TXprTkIvL0tNZmFMeU9oZXU1TjVTcmU1SU9CcGU4eHJUWjdmaG43?=
 =?utf-8?B?OXdLYXFjZ2JzUlBMcWNDTlA1dDAzTmJZODNWQzFtLzBIbmNDL0tvd3pUUFdT?=
 =?utf-8?B?TUlvTStvYkkvZjd5YkJoWFdUVkVFUG9vK1lLU1ZXYXNJSUoxcThWdmFmTy8v?=
 =?utf-8?B?elZ3bXptcFpkejN4N1YyY0RxSW5UNTRTNnZKTHdWM05nM3ZsV0czVmRIR2Nw?=
 =?utf-8?B?WENBZmxKSTg1Zm82Tkk5NlVCdXVnd3JsTUV0U1FRVnMzYUpYbS9oM3FNNld0?=
 =?utf-8?B?SUtHTzlRb0E2akROK3JDY0J4U3FSc2wwS0NZU2NKeWlDdnpURUFaUHlLRzJw?=
 =?utf-8?B?UjNxeGpvV0U2aEZUektIUDBsS0tzS1JHSm1od1luYmZ6bFhnQWExOHdrYW1v?=
 =?utf-8?B?V2ZLT1BYSFhiTnN6V1NxandwS1pUV2ExelY1eDU0aWZNUEcvNHFUeFVHeXNJ?=
 =?utf-8?B?ZHd3WSthaTZTaXFOcWtoVEhhVkJGRldKSG0zSGt5V3VVNTVpK2crMFpXZkhP?=
 =?utf-8?B?N1RVZkR6S01ZY3loMWFMTFZSL0JFWklsdGRacVRtcVlEenlSOUcvWUlaVWJB?=
 =?utf-8?B?VmRRM3BLRi9NMlZXQW1CVTdhREZGMitrR3A3WVpQRzZ1cnBkaCtFNFZtM3U0?=
 =?utf-8?B?VnJJSjQ4L2kwZU5rQnQ3SkdDbXFydjlVRHp1K2IySDE2bmIzT1ZpMkI2c253?=
 =?utf-8?B?TkdLZEwybWJ4V2x3djY1SjNNY0E4VmFramNKOTdUMVQ1UU82YkVvWFpVaHZD?=
 =?utf-8?B?Q3UreEJTV2phQzFkV1BLZ2JORFo1NXNNODk2T3ZCbmZOZ0ZRUThMak5ZMzA0?=
 =?utf-8?B?eU5ka2RmL2hDeU9sdERDK0pPUXZlNWR5cUpkeXR3T0t3VEZ6dmIrckM4Sjhs?=
 =?utf-8?B?TnZxN3NwZ1VXV0JCU1pGU01RY2VEVGNyR2V4YlN4cTlyZ0kybmc1U2JIb211?=
 =?utf-8?B?YXNGaE9nMXIrVm9VdXJiV1J1UVNqYkdGY0loaUZzQ3NLL3RxZndMTjZCU1NC?=
 =?utf-8?B?c0tmLzA1TVl5R2hDQmNuRkxJY2NTNks1dU0xS0lYN2dhMXUyVGU1T1NQVnA2?=
 =?utf-8?B?UHV5eUZzM0pIUDk3Vjc4OVV3RHM0Q0JEVW4xQ1UydWk3UGw0ZWFGdWY5aW1C?=
 =?utf-8?B?ci9kYVhKMDVBblNrdWhxS3lGVHB6WVJoY3NjWHl1ejJkellKZk1wNW5zYjJH?=
 =?utf-8?B?TFJqc2RNNlhYM0xtV204clA4NGcwWUo1aTRBTkRJYmR5MmtyYjNDK2JhRVI5?=
 =?utf-8?B?SXJucVlVRjVIc3RDTmx4SmpaNUttakgvSXlPMUovUlNQYm16MXNiNGRjbjNi?=
 =?utf-8?B?N0MyT2YzTFVqb1EwQU5OQ3R0c29HbmxYSmZzbnlnRHpzbGRkTkpFUmordFF1?=
 =?utf-8?B?TnZBZTByUExreG1FUC9Xb21pdnNJS1IzVlpYZjVubXRNdHkwNkQ3R3B2TC9F?=
 =?utf-8?B?SUpjck45b1FPbXNPR0lrQjl0bTNNVVNXQUYrbis1VmI0bGd5em44VDg2NkxT?=
 =?utf-8?B?aUtSZmhyNmRoYlZDQU40THJWRzgrU0FCTVE2QmNqR2pJclZ0ZDZ4K3ZHS2Zp?=
 =?utf-8?B?Y2RCUkp3UkxVMms5eU5yaUFJek5tdHdqenRTUE9WYnRRMVFWV0hGNTQ3Rmhu?=
 =?utf-8?B?WEttK0MzT0tuZ2dQWTBBbXlXNnRwOGRYTWlPaUh3VXY4ZnlhQjVQT0pnclVs?=
 =?utf-8?B?Znd0QklDbDltVHZuOFVKZis5SCsxRlVKWTBJRjZKRzc0Vi9pZHhsaXdnTkgw?=
 =?utf-8?B?L2Z3N1ZSaUJjWDdEWWlmWHZVODA0TlBFTFpjSWU5RDMyc2JjNXRVRnF6czJt?=
 =?utf-8?B?SmhFRlovbzFqVW1aa2hpYWRRNnc1cmFDYjFlQTNuakZ3U1J6bVVWcXVVN0V5?=
 =?utf-8?B?QjNnM3gremdwYWdRWkdwR202VzRaL29qZWtnQT09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014)(7416014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2025 09:40:26.7790
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 749d17ff-a9bb-4558-5e98-08dda34bd63d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000066EC.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4210

On Mon, 02 Jun 2025 15:44:45 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.238 release.
> There are 270 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 04 Jun 2025 13:42:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.238-rc1.gz
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
    67 tests:	67 pass, 0 fail

Linux version:	5.10.238-rc1-g8bfb88108193
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
