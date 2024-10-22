Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2086.outbound.protection.outlook.com [40.107.244.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BC241C8FD8
	for <patches@lists.linux.dev>; Tue, 22 Oct 2024 17:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729619811; cv=fail; b=c2UgqoFOEqU6zpXYMaXJpvCewG/KN6TF3q7/MyyZt0b3c+CrJj46Oe/UTdhzIhTjC4x+qOzCi7TD9yO8+r07Ar+QQ8w95GdcwodAGtGmb0AFdAYaKtGMIK88rIwDVqTjl+o1tSXplCvZZHKFpWsuOrf2EixJV9dlhZULjS7Ha0A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729619811; c=relaxed/simple;
	bh=5aAfI986Vu7nkmddVdKrTh52JyDtm9qsT7CH/nCME3k=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=EQTLt+QDm9xPj0ykX1jfgtugJ0fYzdq9kMEm/QpymjKUo7wiBTtpyqKZUK9Owgbrm2tg4GoDBjygxSTsC/PCDjmfLAWFays1Uqfkw/Oxmm3vACQ0NI4BvIMyGzg1RYWgOGXcHK/QLWh1VUd5JddvVLoingWWL5IIez0jM1I6EKM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=G6POZJ8I; arc=fail smtp.client-ip=40.107.244.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="G6POZJ8I"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NU8N4nArlEQ5aoZI01AP+IJ/PFifZTB4RUl+lg3522ih16/+O7PMD6fvTQull6DLgnXB2fbEGco0xT7NjwQ520/KSXyiBcu4H2VX/N6BeqAEi3v1DVgG9KD6VFOqQ+NDHcaHs7ymZVhqkcT4CHgK66O2b8Qc0ZNhH9x2XTJvcV4x/ZLJxjBMuKccYFf3fRq63QOTfQwJuILm95u6SuvVZ0CLQ7RTqjcTtT9aa7JE7/DO68PkhllLf96dmGTQvsis1bARF69GyNjBjEf4q3iNYFZmlLRatQ1RK1I03Y8ZVtMwZyEh7fwM1q/GUAcJbM6v3yrFbHk8NKN9MJrlqJIPNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TK0BgIm7fx6fzoR1zXJq5XPlARf7BiKD8jP+0L57Pgg=;
 b=d3C1DAF6hvHGNqB8fqW52MhzmxP8k4IvUF8Wm6Blpwxsh4vI+v3Nlq2uGfKWbfrROY+im/e0jE517kczc5mnkLUT+rMh4gHd6Z9khZA4GW4zrKm8kjGqgSmiJMYFMM9cAYWMeUuFH41jnvj2DcElJSUNZcgB+Qqqc4CgXzPls2dwRLFTCd2nCQqKTOeSn4oaxgYRok4OxDkIiowZhtaGQiQhGYnlAPaUxQIpI5Lv1wTWrNxUZy4YoqYHhdJppoWITRflw0W5WtfIqUT2nAU0mMHO6LS50x/eO8L1Xrw+ErC52WAYkWCjwoB+6K6Vsrhbe8Tkg1SPDoVzmyyYX5cprw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TK0BgIm7fx6fzoR1zXJq5XPlARf7BiKD8jP+0L57Pgg=;
 b=G6POZJ8IpKBpj83gRrLb4Psif16xTMigR1IIxmK/J4A3Fv7R2WYL7UxbkDUwl+0l4cyMfjz6Wvh9uYwyh3VZ2M4W4k+jZcy00OVbx+knBIveQxYg5QiX2wtGXG1S9c6uoUf3NjpAvUtCiA7ThPwivXh2kLGS3SRZ4KS60TqpYv6QtAhW+TcTHJpFTqw3/zPOM1e0QyxRbTt4/A1T3jLTlgfEAWT91eTo2ezPgosMig59q7r/58HVKKjcae0n3fc7paXOSRNmTz2SoznzNA+9yqBj8xY9b9NTnQxdcJI1EMbKozGq2o+baijqeB5QdA19MObzvTYWDRh9TKtp2M+FpQ==
Received: from CH0PR03CA0280.namprd03.prod.outlook.com (2603:10b6:610:e6::15)
 by SA1PR12MB6678.namprd12.prod.outlook.com (2603:10b6:806:251::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.28; Tue, 22 Oct
 2024 17:56:46 +0000
Received: from CH1PEPF0000AD7E.namprd04.prod.outlook.com
 (2603:10b6:610:e6:cafe::17) by CH0PR03CA0280.outlook.office365.com
 (2603:10b6:610:e6::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.29 via Frontend
 Transport; Tue, 22 Oct 2024 17:56:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH1PEPF0000AD7E.mail.protection.outlook.com (10.167.244.87) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8093.14 via Frontend Transport; Tue, 22 Oct 2024 17:56:45 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 22 Oct
 2024 10:56:25 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 22 Oct
 2024 10:56:24 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Tue, 22 Oct 2024 10:56:24 -0700
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
Subject: Re: [PATCH 6.11 000/135] 6.11.5-rc1 review
In-Reply-To: <20241021102259.324175287@linuxfoundation.org>
References: <20241021102259.324175287@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <717bd11c-92c9-4a47-a277-d1f8a7e673b7@rnnvmail201.nvidia.com>
Date: Tue, 22 Oct 2024 10:56:24 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD7E:EE_|SA1PR12MB6678:EE_
X-MS-Office365-Filtering-Correlation-Id: c02e038a-78c4-4192-c5c9-08dcf2c2e4e0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|376014|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dVpTd29SUDBvTDVsZ1hMK1RROEYzVE5QWWJXVk1zL2RnaC9qMVpNTXNpOUNK?=
 =?utf-8?B?TW5WR0krWHYvNVEwVzBMUW1PU0JpYkxKbTNxSytUZ3BJYkRQWEltam1aenBB?=
 =?utf-8?B?eisvTUprZGVGclhWZnFUMGVTNytXV2V5SEJTbDBROThiYzN0dUhjMkg1TkxR?=
 =?utf-8?B?V2Z0Zng4d3pEcmdiRCtqWVZuSXdYd1RQTWsxZlZobmFkS0hmZ3JzR01jbmla?=
 =?utf-8?B?MkV0aWhUYTBEdWhDdlNjUG1JcVAvTHNkRXZ6UmZRcmdTYStSaEg3OFlsMjJw?=
 =?utf-8?B?ZCtxbTc1WENRVndZeFd5dFpQZ2hTYnU0ajdrSHpiV3hibXZHK1BSZTN3a3Rq?=
 =?utf-8?B?V1U2NlhFaHpIRjU2b3ExNXRPR1pBL3BSdEMvSUlGSlNVdmh1SW8rcXFrb09X?=
 =?utf-8?B?VFg2UTl2TmdPaVhXcGo1QTZuWWpNNnd2S05NTnUza2U2TVhRc0hzT3kzOEVm?=
 =?utf-8?B?cGl6dkxCblMwY0oxb2Q2TW5qQS9WTk10QWlCR1g4ZnRjUm81NkQwTUpUdnBp?=
 =?utf-8?B?bTQ1UjVsVFNMZjFHRHVQMzBRNnc3a1hmTEIwbzVLMnJxQk1WcUpwR09HQnov?=
 =?utf-8?B?UUJITmFONGVpNmtjYUFFNTY2Q0h0RHBhNkhHYTZjTHREUTd0MU9iK2FrNVlK?=
 =?utf-8?B?UG5yZFhKZENBL2lPdW9vMS9PUmJWY2E3dkJvL3Ixd1dqc2hzTGdHSjFGdVlx?=
 =?utf-8?B?L2lCMEMwb2xMTVVRclRpTmo3di9KckEya2J5ZitFM0k4N001RXJucHZ0Z3NE?=
 =?utf-8?B?U0hXb0FhTEJqMFlUQ0tlMW8vaDVwTCtIa3JhQWlRSEVxdzdDcG12Rm1BL1pK?=
 =?utf-8?B?TWJpQkl4YXFQR2NSWFAzUjF0eHlxTVdDdy85bVBIZGNaQ1hpZUR4clZManpk?=
 =?utf-8?B?V29JdzZ0YUlzcFM4WnMwdkRockFkSGlaRzN0N0NDZlA3dGt2UU5uWjNxZFoy?=
 =?utf-8?B?ZHBLOGl3V05RTnhaMEUzZ1Z1d2doZEIzR2gzTkdwaGErWk5ObmxkODlYRW8v?=
 =?utf-8?B?RGVGeGhWSFNQc3U3M2tyd0VvQ0pVdXh2TjN4R0I4UEZkR09xNEVsMDZnaWRT?=
 =?utf-8?B?OWdQckNVM3RZUXlLOFQ1aW40RitHTFB4L25BMlE3MEcyNStockpvaEltVFBy?=
 =?utf-8?B?UjBmSUM3cTlpcmxzS3FZOGsxWHBLUS9nQWM3MkY5Ri9nRUljU1hwamNDNHJX?=
 =?utf-8?B?ZWZSRzYvQk9YMXJ4bjlVMFA3VE1oa0ZWOW56Q09KQzUyVkRsU0FzS1VqNklR?=
 =?utf-8?B?VDlCdVRrSkdsNGl5djZDbFNFL2FhaTJpNjlQRDg1Z1VGZC8xYkJ3NktDa3N2?=
 =?utf-8?B?emNwclh5T1o2SDVwVncrUGlybE54YkpSRDN6c2VzaFQvTHV1ZnZzYXVqZjk0?=
 =?utf-8?B?R1lMZUM5c2Z0aGJkVVVEMm81QUJ3L0RvTE1hck50ZWRpdWlBY3VEcnYxSmkv?=
 =?utf-8?B?MHBtZG9Ja04wb3o1SEZPNE1wQkUwKzVtWkdLWjBoZkVyWmttbzY5cHYyTXV1?=
 =?utf-8?B?L0RmLzJ5bzB3SERlWWVRWFA1NDFGTVd0YXZjNi82ZDdieCt4bmtoWGk4NEoz?=
 =?utf-8?B?eGNtcENONlhXWTdsWld0aDhDaEtoeXQ2RE9zV1dPOS9JWFJvOEhhajhrdU9R?=
 =?utf-8?B?OVh6aXNCVVRrdS93eUp0NmFpdDZEbFh0KzgwMjdpbzFGR1Npdko1Um92R3RU?=
 =?utf-8?B?M3lwM2lVWFdHZ0toZEhhbm16WmRTZDViTzg1UGtNa3M4VUd3cDNQOVhvZi9N?=
 =?utf-8?B?QUlkZUFyN1V5azBYajBoWmhFRXYzL3NTTXoxL2JVU1VHRWVmWkZkY0RCdlIy?=
 =?utf-8?B?UHMvaGVEcFNTaXlmMjVhSnovVWNRVnNVMjhtOW1RR1I3cWR0Y2JQT3B3dFVu?=
 =?utf-8?B?cE1RaTcxNDhySFRnTS9YQTlwTmYvOW0vd3NuOWRhUnNFTkE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(376014)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2024 17:56:45.5562
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c02e038a-78c4-4192-c5c9-08dcf2c2e4e0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD7E.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6678

On Mon, 21 Oct 2024 12:22:36 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.11.5 release.
> There are 135 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Oct 2024 10:22:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.11.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.11.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.11:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.11.5-rc1-g96563e3507d7
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
