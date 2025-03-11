Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2052.outbound.protection.outlook.com [40.107.243.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30CAB263881
	for <patches@lists.linux.dev>; Tue, 11 Mar 2025 18:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741716738; cv=fail; b=pJY9fn/LmR82IMno7eZuqeCo76gR84UpLYQm2tsxABqB/8g58A9wykEMLgf5SHTKncsgY9crq210YsS1ueeMEABuqpoLm/1b4sIGxG02Ws/hh3qQ/zm4al0wSKAujT4QkaeaY0qcyZ0pRkqvrYV/fMGaSAv+Y54mtqgNlAXd+C4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741716738; c=relaxed/simple;
	bh=QtAf7AImmvantJBNxEQDqkLpHFvoAQuOjKdLlFNJI+E=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=o2FMqlpOdPRlH0CIaHDsj9eqjTHxlyLGCdHBU0vvWoLA8Hfkr5ldW9YLYzxISaSgiAKc6QV+ggcDx9wfBDVTTo423y7gDK2H3q73p0lDS/4XIwBrUqUt8OuLDJl2Wbsil9zH9IM57CdzgwKLVv+X1vjzK4IwIG3XBdcyvJUMIms=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=YkAoY4JW; arc=fail smtp.client-ip=40.107.243.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YkAoY4JW"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R4S/jzerfz3Zrcp8z5xDqf3ELnijOmC+rnQEDzu7tdRI5Yi+CJjYLC2+z3gPiQxD6TiWAbSfL0QZuPfriQpTeZRROJn020RJHVh71x99GWRgpYpiR1EkxLZl0rWCfMJr5m66UZTQFIqO3BXFDx6In8ktMMAoG/IaBcznpJwxD3/D9ff9dOx6tS1lpRfIfYPwQbCzzOGxcOnRfWJJedBrrJfYfYdieknbBdMWI/T7a1A1PP+8v/AonJvqB5VIxqlBi1C/wEy7ypmS0GqEMcSa1W4AAsWf/oKCpS7weu7UJivuWUoFezoG3gwYD9GGlMQzbrhb3pQYqoNkAnEibhT82Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nj52lecxhBq4joVxg3wVkf6kwbB0clieIL1gmO4Kjio=;
 b=Ffj+9dLtrKTLvlwJkI2FXSW0Mcuvm46G458MxR5ZnyH1tdKwvelZN/bug+6oHlRCKaymOnn7dPISfRl8ZetOes6jWRAjHG9Uf4d/5mLKjS6vy9W6kchuyC9i+2FELHImpq0+GqL/xZl3YN0KPAuyKVzaxELWnQy7MdznqbpguaUa8VxWIS1QO5OYqX3MhIM8SRsV9mTqwe4AOyrC0fQoEr92zuBR1yrUsVVxo9UgdEUY5kkcbgRdqzHFgcV1Xdn5oc6DtpruUcd/csI0R3yZ9VpeqHuIJewrhn59JQfh+voUzoaIyCEdEmspFqdYMrttO/zDCwDryKxIrse2Ruz9LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nj52lecxhBq4joVxg3wVkf6kwbB0clieIL1gmO4Kjio=;
 b=YkAoY4JW/LUQQfLBsuZWilVDbWAC5tFp+3tpeIrvLGz/GcMlbqE4zohMLvFjxdlai35vf4gRBLPVFKJjkwL6plTWTVhcod8lrINlzYmuFx6eToxgQwklrZNGVmFpnkHETV7rpsf6RISvEcvhQfRJZquubQKrrw+O1z+f1FmIDHhKBKewvhzinuRLM5K4UyEZchqGahl0uWd1xNFpKIk9ZvCW1LrFX/4nfpvHatCcH5pgQ4iI4V5bpkgYpI2n9eeOXJ5t5LxCoR5ue0t3fVboyME0iEc2a7do/WSausTUoxl9qQPhWI+RrpdWBa89BB5oclJz1EJ8WUI76Cn7ZAb+DQ==
Received: from CH3P220CA0027.NAMP220.PROD.OUTLOOK.COM (2603:10b6:610:1e8::25)
 by SA1PR12MB9002.namprd12.prod.outlook.com (2603:10b6:806:38b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.27; Tue, 11 Mar
 2025 18:12:12 +0000
Received: from DS2PEPF00003444.namprd04.prod.outlook.com
 (2603:10b6:610:1e8:cafe::ae) by CH3P220CA0027.outlook.office365.com
 (2603:10b6:610:1e8::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8511.26 via Frontend Transport; Tue,
 11 Mar 2025 18:12:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DS2PEPF00003444.mail.protection.outlook.com (10.167.17.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8534.20 via Frontend Transport; Tue, 11 Mar 2025 18:12:11 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 11 Mar
 2025 11:12:02 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 11 Mar 2025 11:12:01 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Tue, 11 Mar 2025 11:12:01 -0700
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
Subject: Re: [PATCH 6.13 000/197] 6.13.7-rc2 review
In-Reply-To: <20250311144241.070217339@linuxfoundation.org>
References: <20250311144241.070217339@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <2b269f01-e508-4940-81ea-31c5cd961bb1@drhqmail201.nvidia.com>
Date: Tue, 11 Mar 2025 11:12:01 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF00003444:EE_|SA1PR12MB9002:EE_
X-MS-Office365-Filtering-Correlation-Id: 59caad17-f978-4948-2369-08dd60c83e93
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?anplWTR3N1lBOE5JZFRPeEd6SWtXVk5KMXFRTVJxN0trN1NIRzlhS2U5bHdr?=
 =?utf-8?B?Q2F2bkRKK2tFSGduZ0VPVHZBUzBaOE1lYUdCclk4SUFyWnJQb2dXMUpRUTJJ?=
 =?utf-8?B?a3BDR2ZtK0xaS3BTdWpxRjF2WmlHcVVmNk0yaWNGd0RyVmUvWGd2T2taY3ZB?=
 =?utf-8?B?QVEySkVsVmtlc1lkeXNqUVRZSkRQNDh2dVRDWnBURVVZWnJHelBEdEdkWTZZ?=
 =?utf-8?B?N2hSMW02QWRiYS9Zd2NIMDlpT1RwK0ZOL0VIWndqV1cxYk1vbXZlTUR3MUJn?=
 =?utf-8?B?MlRpUjg4eDU2QnI5UEh0NHZ1WEtKeFVJNm1WUTI5Y0NDSDRTR1Y0SXE2SmhG?=
 =?utf-8?B?RWdNVHdpZXcrVTB6b3h1a2kzV2lYQTNNZm92VXVSTU51eHV5cXQ1Z1V0Mmli?=
 =?utf-8?B?TkRacTdrekdhc05OMTlxK3hpR1VmdXlrWmUvR3l4NFNmZllVQVd0UE1zYlBZ?=
 =?utf-8?B?Z1NEMzVRSFUxQjRsRWg3eDJhRllpMTBwYkx3bWRBT2xVQXJBMFVJS0FTakwv?=
 =?utf-8?B?bE5aNW00TjMvYi9lWGhsU0JMZEN6YWVYR2paSWdkSFZUUU5VVzZHcmR1Y2No?=
 =?utf-8?B?M2FzNkJPRk5tL3BncEl2K2g0d1VXMnBVVjdMTVBYN1Qwa1FHeFlQWmFDc3g5?=
 =?utf-8?B?dE95d1lETkUwUzZmRDdvMVFCM3lKMWtreWI4L2ttMTRYSXpPZnlDOHJDVFNp?=
 =?utf-8?B?Ri9kNzljUHpHOG1rWU51bUhxcGplQ3M4YzhQdWZ2V1JHa1NKUFA2U05yTEls?=
 =?utf-8?B?d040a0RmbjZ2UTF3Sms1d0lTZDBtc3c3QWloK3FTYjdaZzNqNlhzRWpRUnNz?=
 =?utf-8?B?VnhDRGdsandPSkprREthdWRhNGZUVjZlRTNFcGJIbktISDk2U2NmWThvK3BV?=
 =?utf-8?B?M3ErY2dlNDF1eSs5bTQ0a2ZjNkVQb01aa2JMSDFjdlpJcng2SDJWZzhpZHBO?=
 =?utf-8?B?N1lhcVpwTHlOcmZhREVBUy9tQ210cHdoaUtTKzJROG1HYW5IaEhJM0JiWndM?=
 =?utf-8?B?Nm5HRW1Lam00Z3B1MDVranAxaDNUajNORk5HVDNkK0owRXRZMHgwZnExL2l0?=
 =?utf-8?B?Z2xORVJPUUFUWnpjTGhjM2liQUd3akRKNnpUKzczOWJEazdQSS9tejBZdWJn?=
 =?utf-8?B?anBveWhUUGs5REl5STY2TlRLS1MyU1AzODVUUUYzUzVwdE5jMkdwMTZpVDR3?=
 =?utf-8?B?TkE5SHU1ZVA0VUxGNStsREFXWjNxUXNWdjVKUTEwSFlRSC9qOUxKc2VIcU5P?=
 =?utf-8?B?MEZrUTF4aTZ2ekh2Q0JrMXhKL2lQS25Sb0pVbE5ZL3NSWno1RTlsaWErV2kw?=
 =?utf-8?B?YmdUb2F5UXJveUdsQkxGWjVFWnBzUlplK2kweDJlWHBtK0Q0TVRVQ050ZVhT?=
 =?utf-8?B?Q2lndExjUGhSTkRlZGNaaUlZZUVEZVJuK0wrbTU0TGRjUWZDckhxWVlPZllu?=
 =?utf-8?B?aStzbTNxTmNUcVN3allLenNMV1Y2ckwwSlJPRHNlRUxvREdlZjU2cnlZM3B0?=
 =?utf-8?B?c3ZHbVlCbW0yK2JYMTFZd2VoYlJOZHY4Z2JRNk9VT0ZTVUdFb3poeEpqS3R0?=
 =?utf-8?B?RkZueHQ3MkZGWVlyRjZJb0JFSDFUdFNpMlc3ZzYwTnRxSWUrTjBJSUI2NVpO?=
 =?utf-8?B?SnlMdm8zZm5pS1JDd2MyS2lSRFRaY2FVcW4xTytKUThnZFVNK1VpR2ppKzMv?=
 =?utf-8?B?bHhvdkFpbWZ6d1d1dDdSR3hERHYxeml1RTJtMGl2ZFFpVCtvcFFMbDNCOHI1?=
 =?utf-8?B?TXBSU1dNTm9hY0UxYW82MEhoMmQwUEM3UC8wNHlkSmNXejFPRG1LakhwdGdq?=
 =?utf-8?B?K2VXM2ZnWjFqOTgzQmxFcDc5SmVBbVM0NUhDdkhRWlVzRHNqSldvbVpNUEFi?=
 =?utf-8?B?ZTJ0dTdtS0F1bUh5SU5BS3QwRGhEZStVbU92UEF2c2FHeXZBYnhIdjFiS2Z0?=
 =?utf-8?B?QmdDaTg1S0hVa2kvUkZydmpsOWk3WVVFaVVDcmswZ1hyT1NtWEl6cWcxRmJ4?=
 =?utf-8?Q?uUMbcwgDT3EQ5+A1mPn6N34WTwtj3U=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2025 18:12:11.5096
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 59caad17-f978-4948-2369-08dd60c83e93
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF00003444.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB9002

On Tue, 11 Mar 2025 15:48:06 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.7 release.
> There are 197 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 13 Mar 2025 14:41:52 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.7-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.13.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.13:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.13.7-rc2-gfca1356f3f51
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
