Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2061.outbound.protection.outlook.com [40.107.95.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6664D13A3E0
	for <patches@lists.linux.dev>; Wed,  3 Jul 2024 08:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719994400; cv=fail; b=BWDfDNkDGYipmjt3j9FVwj4AAm80IhOyoWycWpSdNg0/0GnU8tgzUYwxXSIotdqEDzD2hj7/t3FqJtU0RuOUMtY0D4lssKNWCR2Wq9K68LaauNxhqjQ2Yp9GKeWGfQcAW3SLalBkLd9lS6kQY2FFL7nTj77e0mkodggx6G/1/I0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719994400; c=relaxed/simple;
	bh=k75LQVKKW4UzGbV0S9M5vKOCw4Jfclokhs7WuhV5+d0=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=sA8is6Cv25xeWB9EBFO5yrWFJaqJI72JioUSyAJRhMSo3G5tGKhogxZq2BXYLeIFQnBy8QeAJ/dzgKRBT9YDrinOTPujouPLB10Mz9N1BasryZLUojbU/gQIXkVAf/6GvuE0R3ohXB79wPIeGquszv4ySX0Y5stWUhzrPlRNi3I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=JhFFf3lw; arc=fail smtp.client-ip=40.107.95.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="JhFFf3lw"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jwRh8WOHhyf/KdJcG40URoQ2ezb3Ebb7NYnkdQYHEoLK4AeTBqTDohxm6W1KCWZxEHueVoMecpy5Et2lqs74fs4SBHfiOYUS1fnvCFrqSlbTJ0lqNxc1e7V5CEb8vAie8a23CMr6aUKiyfKidj2FftUwJK34wqhK1DGJqWAHr6c+7vBKqKsCV0Gmh79zHYmdmDQVfhJEeHCQGUn+Nn/u9mqL1ieSFr7NO3J0ZLhlktGdb+vkDVdu6qMtw39x8itwZeTBjYkuHHCLpkvAwNa7zrkbyg9UDump5Q75wmOFuUFROYotfKGnPAKMP44X25HDVDD+vM5x8RF2XrK7oYP1rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V/pX08KSdW4IX/ceS2CgmsDWyX4u3hwZ6JIxI1uXeOA=;
 b=G2VFGxQNWK5WNxX6ZWqVZm0gfeUe8m8qUUxQgHzjeeEuCCtS89kFKKuRH4vVJWvcBv19KMlQkbtXA3FamCOJ3VDu41prfmpfz+vTdef0B08L2PFI1pMInq0mAWY+iyuZAHgm2X1rriPfy80E1s8sZx9D4fGroPFhQlC6AYNbAokLsGHM24GhkOLDPejOCQWSjN3uD+OMchOzdUytHYy0dtGJMT843rR912RW91Dd+QN6tJP2D0W3KzUUDgKFFr5z7f7UlUKU8sEgqHe6HAp2jSNz1utYMhz9TjVpamPruDFXxOAfOOlEMl5NtZBEOANJlhLyQ/m62xiTlcM6g/NHhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V/pX08KSdW4IX/ceS2CgmsDWyX4u3hwZ6JIxI1uXeOA=;
 b=JhFFf3lwZHVz/KvE3LxLzwGZMTQaMV9Vo5CYcxE5e9/MW+hYVQuLvWYpk5aOelDaecwWlwHil1KHInfyUJ6yycliECg+6ohWirOtbrmTWDtTDt1WX6NIzmMH+p2u+M1GufeC/KLhY1b4xTkzAUNKktabx4KrRT3N6QqarGk1zOWFJsHLFVIE8kc6n8rBMDY+PpZw4xaKYrwFcERCaybogHCxg47LDGZQjjDM9FkOBbWmmdnIZV5w2Hb2H/gHjB2HkPwY/CQrlNaCpanoAbqFH4pONi3l4c3NZlZRYiCi+W+qzImi+agW5ntGC89kBHy3f01qxdjUZbHZzy1iq4gj1w==
Received: from DM6PR02CA0042.namprd02.prod.outlook.com (2603:10b6:5:177::19)
 by SA1PR12MB8744.namprd12.prod.outlook.com (2603:10b6:806:38c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7719.33; Wed, 3 Jul
 2024 08:13:15 +0000
Received: from DS2PEPF00003448.namprd04.prod.outlook.com
 (2603:10b6:5:177:cafe::1) by DM6PR02CA0042.outlook.office365.com
 (2603:10b6:5:177::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.25 via Frontend
 Transport; Wed, 3 Jul 2024 08:13:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS2PEPF00003448.mail.protection.outlook.com (10.167.17.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7741.18 via Frontend Transport; Wed, 3 Jul 2024 08:13:15 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 3 Jul 2024
 01:13:02 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 3 Jul 2024
 01:13:02 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Wed, 3 Jul 2024 01:13:02 -0700
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
Subject: Re: [PATCH 6.6 000/163] 6.6.37-rc1 review
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <3b45059b-c2d8-4b4d-a5d1-7eba9a3ad0d8@rnnvmail203.nvidia.com>
Date: Wed, 3 Jul 2024 01:13:02 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF00003448:EE_|SA1PR12MB8744:EE_
X-MS-Office365-Filtering-Correlation-Id: f2030705-f6aa-4810-b9af-08dc9b37fd4b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|7416014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Y2IwMHJScnd5SWtBK1Y2QUVXSnVPRitDR2pFbUVmY3dpSlFNSG0rR1I4RlVL?=
 =?utf-8?B?eWlxQkZzWE51Y2ZyZElzTVpncHN1N3RPVlpyR2NEMXRzUWhUQ3VzWDVIUjRh?=
 =?utf-8?B?aHlQSWdCdC9IQ0UxYm5NZmt3TmRwSlkzd1A2MkZ4VFFFd0RGd1YxZlVwRTZB?=
 =?utf-8?B?YVJYbFp2Q2E5cExpTnp1RHhlN0VGY0VXb2RWdVVURlVSa1JaK0xFMFNzSW9O?=
 =?utf-8?B?NDI5M2d0WTN1NEFhNS9oeXNKU3ZURGtMS3FwQ0dTdC9xeTY2aFVydjd3c2xP?=
 =?utf-8?B?cEczV1lBOUZ5SnErR05yeHk4MFVSKzNZUzM1U0xwTTRqTzlqcWR5aDluSjVq?=
 =?utf-8?B?eUQwTGxDNHBrYTZoQ1FlWHdVcGlqV25WR2pnd1NBckV5VDArb2prYUhWOFF3?=
 =?utf-8?B?bkRnK3doWFJ1bUYwWXpsTVZtT250UWhsTFFwY2dDOGdNaytkeHEyaGVIMjFY?=
 =?utf-8?B?WlNxTG8xeGw1Q3ZGUVl1NjhzUExNWjVZWkw2K053WU1zUC9ndVR0RlJkZWhy?=
 =?utf-8?B?ZVJTSVRsUU1PL3dSSEpJdHY4TERXbnBYcitlVkd0dmRrdUlISGtCUHpXNGZ0?=
 =?utf-8?B?NDltQmt3c0IzWEh3b0Rja2wzM1ZROXN6c0xvVnZUS0JXVHczeFhCVzNCTEVS?=
 =?utf-8?B?NmdxVkRxYmFlLy83L05lSGNTTURPNDNVUmtxd1lTS0svZFFwMHgzM1FqVTdS?=
 =?utf-8?B?YnM2WUtYdC8reXRkQTFRMVkrTDAweGNrcGMzVFpqY09uNVNvZTVWNnNtTUhD?=
 =?utf-8?B?Y3d5eWRzNFJDZ05Ga2twdHRKVVNYeXFFRFRqcjBXa0Zva0pBNW9qVUlOSm9k?=
 =?utf-8?B?N3l5eW55Zy9qSDQvamhqZHE2YVdQenh3bHh0Q2JjWUlMYlcwZkQzN3FSdTAx?=
 =?utf-8?B?MFJncmh6bUZQalAxOE9RTEN4V1ZTVDcyRENwalFKYkFvb1BRYkpISTRkV0RO?=
 =?utf-8?B?alQzY1Z3NjN0UzVUK0xNVXh5cit1VzdLbHkwWFkwY0hMd0kwMFdOUExIOFY2?=
 =?utf-8?B?Q2tMWmtJZWZJaTdhaWV3VHlEYU82SnpDK3kydCtxZWdId3l1K2p0VWxhY0Mw?=
 =?utf-8?B?Uk52dDJCWVFwZ2lNc1d0Vk5Hc2t5dThHZnN1QS9jVUdPYjd4WWJPWDVSakQw?=
 =?utf-8?B?RnE1VXZvaGUwajlncHJvVm5CWGhBd0FrU0c1ZEFJNVFjcnJ1SnpOQUlPS0hn?=
 =?utf-8?B?UXZ0SmtmR1preGlTYTNpUEo2d0xxeElUMng5aEtMWjlJYzJTS2QvMFd5OEZh?=
 =?utf-8?B?YW1INlkyRi95cjE5WHZmZGRXVWo5MGdMTkl5ckV2V1BHUnh1S0FBbWkvTlFz?=
 =?utf-8?B?QnZsdFJjQ01tWjJkNFR4R0JzUXdkVWVNcG9xZ0VxMU5yeGpCS1l4UVpkd2JZ?=
 =?utf-8?B?Kzc2N2p6SzU1M29TVnAwQ2Y2L0g2dXlBODNpRmFweHp2WHkyWE1MNWpoK2tn?=
 =?utf-8?B?dm5BQUNLR0xyY2VJSjVYMXZLT2dFaWgxVVBKRkdkREt2SkVNRkNXYVZaN09z?=
 =?utf-8?B?anV6Q1BWZFUvNWxjNmRoYTUxcUNtM2FadEVzVnozdmh0alpRc1JZc0JxdU1T?=
 =?utf-8?B?c1NyRXZKM1lTQzcrSms3d3ZhZEt6NU5PdGZ1d2UwcDI3SC83WG9QbnE2bkVk?=
 =?utf-8?B?RE5nT1hjV3p0SXZPZ01Yc0VNN1hkRmcxWmVwVld1UlpSNDFaQ3AvZWFDcDBV?=
 =?utf-8?B?Qk9NaEwrbzFhMmhIMWdHcTNsN005TW90Qmd2Si96QnlIWjJ4Q09WZUZOUFlW?=
 =?utf-8?B?Qk92REt6TG9TUzdXNFpYaWlYTTdXQ1NZVk52dXNKRHJoUXpsQnlFSGZFRFN5?=
 =?utf-8?B?b3Q2KzhYMUdvNVhoY2pyaUdIcXp0Rmo0MkFGdmNTWXl1MEN5L1hLQi83NVJo?=
 =?utf-8?B?UkhNd21wN2JxTlJYQlRQUW41TG1MWWsybXpGT1ZaRVNRSlU4cnEzSmRNVFpF?=
 =?utf-8?Q?EU1/IX9yq1AKUe4jyBNuSe4Qi+6CmbYR?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(7416014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2024 08:13:15.3153
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f2030705-f6aa-4810-b9af-08dc9b37fd4b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF00003448.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8744

On Tue, 02 Jul 2024 19:01:54 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.37 release.
> There are 163 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Jul 2024 17:01:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.37-rc1.gz
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

Linux version:	6.6.37-rc1-gca32fab2f2f9
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
