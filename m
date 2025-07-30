Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2049.outbound.protection.outlook.com [40.107.212.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAF7E2D9EC5
	for <patches@lists.linux.dev>; Wed, 30 Jul 2025 14:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753884607; cv=fail; b=NzF5JWnIavKqi36UpkIVOZXHwFWGkXms1F7QfNM5P+9D3yZNjKxJfLmqnWtlFlQGkoyPYIZjqEqjvFpPKMQdqSvUDp2yLtHz6QfBdUBETWEmlBZIsUmVfP7o59H9gO4dh1m6K/EV8zEIP32nWEuruduZI1vP30qKab4ktNb7cl8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753884607; c=relaxed/simple;
	bh=vISSfpICkhKk/c23otBuf1LN6TbqU50kcFjqSGDNxL4=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=D63+9pJdPJZjTNtFzB9RuiC4ZrjHkIXoDyCENWz2vdQcsVXPkHZjVX8nkaWdWjDu0v08zEIj31z7911UfmJD0zkTG5cHc4XbDQVQQoI9w2LKEynMWbxOpHVnNDfK5lS/bUwvmYGtSzat2EG8nrsglPy5ntk5Wy4CUT9uosFSkls=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=CfkVPVtH; arc=fail smtp.client-ip=40.107.212.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="CfkVPVtH"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kOsaHMyxU2HR50QbEk2s7quqhl/cOWsIsHbBpzqjPOOOA+79eMKPNxs/5moM9q51IaefNi9cvVHIyqhPjX9/GX0cRc6GBmGrkQZwjoo8A5DKNoA32tw7v4HTqnZtcC2332aCTldrGdwaj88DD56NmuRdR/ZqiLov3Dz4uhx5S58DdGDc4Ztz8gH1DZ4mf4kcMRil3WYMU7Dsp/55Q8vuyxI3BDw17a1j84MskjAKYHQxSQCRmbW318t8krPleaTB8MApI7zyM+TXjRZzC72ekHOBEDWMSa8X5D+B2oBMPycj9fiAdH04czqGJFASrswvVx5fWj8Gtv4xwlCGpEBVQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JW9k6yOxNqzdVHAi7ILxZgTE3kBsMiYe+TIdNTYWayg=;
 b=SEXc8706mwuc4OWEvc6h+iW4GqzeIxDJsSNe5hmuaHxWW4JdBjE3IuFslDcrpgxS281hz5N6W/uT993+FTNsBr9ZLto+9j6WARfODIZlgOjf6f/FkH9X1UU52CxLJu+YuRC54R5XcQqvDSp/x/OcpsO6F5UtxhXuurOHusk9r2i/247vpOZqZqD9WssXC8V13r/ofZ8q9PWMSEXBAbmRCriS5dbOqUrvBlqpjlEqHZ/bIOdut4VbxjbFieJbQZwj0o3uNzyFhyPKQXqfwFv140nwcoLe8NdeDpXowBSH7D3QtqUILf8BRp64pXtx7hXSZOQz3+3E2epcNvzN1Qdawg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JW9k6yOxNqzdVHAi7ILxZgTE3kBsMiYe+TIdNTYWayg=;
 b=CfkVPVtHXwAoD8CePsDrJWc5UM2VSv47PImM3FzQFmYI7SbKZLwCQS3ox0Ohtz4W4c3N9yKSNY+bSxgdzM1Haaxo5foaTV1ayGBXVtChdiWOTSua+w8RjUIwio5lf3XTMEC80LtplParWMGAwSGd+snuymt4EsY1/DXoZNVbKuNxRok9S6yxEmigcPWvzMbXRmi2yjLPxQyDbBpXT6/yQpCQouzrXQL4ERHdaHRCM/C/mZaNi9wUG/687GAWfUmO8esKqIJ4FhcCnZNFeOl3AwoaPYxv/ZTlcTsYOCYGMh6kh05TPUA1LfyWgqE+bV5g8zKPZcbwjIKJ3U9Ee4IdHg==
Received: from BL1PR13CA0320.namprd13.prod.outlook.com (2603:10b6:208:2c1::25)
 by SA1PR12MB6797.namprd12.prod.outlook.com (2603:10b6:806:259::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.25; Wed, 30 Jul
 2025 14:09:51 +0000
Received: from BL6PEPF0001AB57.namprd02.prod.outlook.com
 (2603:10b6:208:2c1:cafe::7b) by BL1PR13CA0320.outlook.office365.com
 (2603:10b6:208:2c1::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8989.11 via Frontend Transport; Wed,
 30 Jul 2025 14:09:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL6PEPF0001AB57.mail.protection.outlook.com (10.167.241.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8989.10 via Frontend Transport; Wed, 30 Jul 2025 14:09:48 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 30 Jul
 2025 07:09:27 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 30 Jul
 2025 07:09:26 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 30 Jul 2025 07:09:26 -0700
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
Subject: Re: [PATCH 6.15 00/92] 6.15.9-rc1 review
In-Reply-To: <20250730093230.629234025@linuxfoundation.org>
References: <20250730093230.629234025@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <a786c786-dc7f-4318-91f2-b14f6644194d@rnnvmail203.nvidia.com>
Date: Wed, 30 Jul 2025 07:09:26 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB57:EE_|SA1PR12MB6797:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ebca432-bafc-43ba-9ca2-08ddcf72bf52
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|36860700013|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UnhQOCtUcUNlZ2MxSUFVeHpVVzlPTTYzbzVuRmhVQlJSNHB2YVFrREthZklT?=
 =?utf-8?B?U1piaHpDdEhGazNEQmdxRU5sZDFieUcyYjNTcDNBeDRCZ0pWZVpGTHpkMTk3?=
 =?utf-8?B?ak1WdnlLL2N3Q3orKzlGZ1cvZmdod1Z6b1dJSjdWZUFzZFZVSzR6Y2pzaElt?=
 =?utf-8?B?azVzMmVwMWFTZGlzSkRTUU41bExFNFY5blpEdyszeUdOWSs4bUNlQy9jZmVT?=
 =?utf-8?B?ZGJZckhSckpTbk1uMzZzOXNIMGFFd0ZMU2VZdzJBbWNFai9wMmc3WDVYZS9t?=
 =?utf-8?B?ZFA4MzBNeW1YYzZDTzAyQjdpdDBMS2NVQkE1cGFuTGh6OXBtYmxCeVFJU3NO?=
 =?utf-8?B?SG52T1RjcDhjbHk1VVN5dWptc0MvSFNYeU9zc0NQazdrMk5CVHFJZ1hEU0g3?=
 =?utf-8?B?Ymk3SjM0THRRc01kU3pBbUc2Q0Z5N2tRSXorVDY0WWMzdlhxL3BFS0pyK2p5?=
 =?utf-8?B?aks0OEJIeHBhcmwrU04xMTREYTJVUHdPSk9sRnA5SGdwMWZDaVJsdVlicHpG?=
 =?utf-8?B?WHBId2NqMEFxTm1scXQ0QmdUbEpuaW10aGFpZjdETjA4NkZPSW9YUi9pa01q?=
 =?utf-8?B?UzVud0ZSYWhMWDc0ZFBSMDFCYW5PT1hXaTgzQWRmcFNXSG1MWVZBSUJXc2Fy?=
 =?utf-8?B?cGRYT0dSY25QWldVOUlpL3dhd3d2a2NPQ3NXL3NkTXBpaUgwZWs2dWI0UGdp?=
 =?utf-8?B?b0tYMFBFaC9YZVpZQkFDYVBKUDFKUjZNeGxua0djZzNCU0JKSTVlcVZwRmNI?=
 =?utf-8?B?bmQ3VlovYW5WNHptR2lvSnZHT2lnNk9mUW1lcDBIcVhnRnVjMHVxSkVKSmd0?=
 =?utf-8?B?cE1VT1Y2Zzg5aC94SGlDb3pFdkE3dEV3VU9CL2VJbUVDSzFETEl6dlRER2Q5?=
 =?utf-8?B?TlVMb2RBd25UMHZOSFh4a0V2WS9hTEY1ZVl0WlV3am5WWTJ4U1graTd6UUVl?=
 =?utf-8?B?MlZYaE1OZTNQdW51SEJuTkdxTlVybXlLaFZsNStvV2ZjTWtlVW96bmpWeFli?=
 =?utf-8?B?c2d1Y0djQjZFQlRZVm9TMXNGdmlpbDBVQU13TmpVTmtreVh1VU9PQ3JhNXBS?=
 =?utf-8?B?S0NHQWV6Z1o4clErTGRPR0U2NGNiRE4wU0ZWcXZiNnhTSU9TOUdtRkhzeVpN?=
 =?utf-8?B?VUMyVVp2ZWF4UlNjY2ZtQW5xYURRQkRIQktMRzE5S240UmdoQS8yQzNNVm52?=
 =?utf-8?B?TGxnKzRrZG54U2JPOVNlT1pOamZWMUp6eTlibUk3Y3FCTHBXZUVnMWVOWWhV?=
 =?utf-8?B?MFZGOG1PL3BYSFg2M05TRjNPck4yb0c3cVZHRnJna3h6aFR0OFRNVTlTMVhr?=
 =?utf-8?B?VisxUVB6RnFVaTJUaGJhcUM5bDcvRy9hOHVJR1FqcVdIYWpQWFExTUhIMGRN?=
 =?utf-8?B?WjVyRDhXc1B6Q1JLV0tHQjFVYnI1cnMvanE4UlhvaUluaGRsMTkzVHNWNno5?=
 =?utf-8?B?akoyYTR5WnBEb2Y1V2N4QThLMjdhaGZzcU5pWTRRZVp5K2lRa2YwSHIxdE01?=
 =?utf-8?B?eXo1WGNZY2lkZTJoTG45S1NkTFlZOHUzdWRPeHVsdlJIUThGOHhJR01BTUtY?=
 =?utf-8?B?aVJwU3Z1NXZ3VmZ5VlQ0UkxLU21CS0tmM2RNOVpaa1gvYjdqMC9OUEFXQm5w?=
 =?utf-8?B?VDJrMUZHMEV5TVViMUxFQlQ2VnJJMkp4azdwVjd3aSswUkJ3S1lEYkRTZmFv?=
 =?utf-8?B?RlZPcXdHZkZhUEhaOGpRT0pIT0EzY2tOZFplTHhPM3hqOHRKei9yTjF5WStY?=
 =?utf-8?B?eXBhYlhBT2lndXVZSUJkVlRYdEYzUURzQ0RvcmdUZjlaQURKOEtXbEh1UFJz?=
 =?utf-8?B?K0ZYRjNsOTFiN2NCeVBHRlFaS3FRZi9pMHFhc3k5YW04QjBEaEpnNlErbXlx?=
 =?utf-8?B?TjloWlB0bSt3UitDYjk0U3pzVmZSYTQxWUxFN05rWm5rSEtVVkRrUDBBcm1n?=
 =?utf-8?B?MWNJZHp2SHpsTkxhbUkvR08yOXF5U2xVSlVxdi9YOU1UUkZTQTkyRk1DSklJ?=
 =?utf-8?B?UVcxWkUzS0MxNDY5S1hUeXh4T0lDb0h6R0RnVFM2c2JhanlpTGF1L0FrazFt?=
 =?utf-8?B?enBLWDhrL0NaR0dwaVVSMzRHZEpTN3RsRzcydz09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(36860700013)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2025 14:09:48.9846
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ebca432-bafc-43ba-9ca2-08ddcf72bf52
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB57.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6797

On Wed, 30 Jul 2025 11:35:08 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.15.9 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 01 Aug 2025 09:32:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.15:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    120 tests:	120 pass, 0 fail

Linux version:	6.15.9-rc1-gd9420fe2ce8c
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
