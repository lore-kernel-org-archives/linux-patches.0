Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010045.outbound.protection.outlook.com [40.93.198.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D00852DA743
	for <patches@lists.linux.dev>; Wed,  1 Oct 2025 09:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759309934; cv=fail; b=Vk9lMGkmoSvHMCt1HPFkbtF+QfZ2sdyyiZ0KLV5OSHk4TxDm46M5n1fTEJ1T+Cr7jLPs+debz9YGxwAKFnv/n+mLRbuGIfkclVeba4CQkbcx6Ts2izYgSaTMmlKBx4ceG6zIukiQL3mhyNZviuvYstvjonxGdZlX4G7semDDs7w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759309934; c=relaxed/simple;
	bh=1abSlV1Pu/2XsAVfqJl+iJ8Y+iOSADrIMucoQmqPm8Q=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=K9/Drpxr7tHwjoaT1JxF0147zte1suQn7CXBZLAT0+db+3fx3P4Dh/q/rHIU0vNQ9OOk4ZWaYevPzhHXQJAkNNQBDSAFGSZRNv/T15SpfN6UEecYY1R+wOGijtXas2S2vj7xxdJolpFSm8uJh+EJhoKDW7Swu9FOZ6q8YI4QuEI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BHZ8tOXR; arc=fail smtp.client-ip=40.93.198.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BHZ8tOXR"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tkCOilqwhQqBwesOFCw+485FHhmpMJZa+VeH6BFmx5zUQELQGBGVswy6mVKdt+7xfEWdOQOhPyzR1S9EutFniteMQND4FW/KlzPXWtxdMpdp2Ou7HrovLkXGiwHI+BKCt+4Mw2zfzwQNm7iGIgdoRkzYVl66zxBdOj5TlcS7XLJzPPf5l68lE8Z+FEzSx4uGiICfpAxfKvzc99W9nL/1I7CsUows8rzjgeYdxtjm3UuWkyKTg8xXCgg63xplj+Oxr9Z8Yi4tNSJXYpKyf4ww2VGAv5sq3zknqODYWuC8TtA5rkecB9vjidH3/nNuN1N+PsxJevX6xUSUVaYxsLRqLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qb2L3h15YWlKafnJ7MZZeQVexFxoP6N1NYgwtJV+U18=;
 b=wtQKvYOA9iPWjXV4BQmsnBCKRpYCNVEKHRlQx4G1o8sETAqjsE/N9Bdzo5yV8LRioRz4J3Wv2mdRSnFhwdn6CCjkOBr5PqKQ4SPFTYzwybxz8FOyi4ged94k33UWvf+u4N+GK85LDepbWvI14zgWDv8AIBR3tqK4ZcL5HoSMK4vBSIPi5+rZrPbRf7TKtNnQR4ASHbd7ioUvFBw0GdWRI6Whe7LP4Ymxa/piB78UcidfnkqyhsWL3fn8giUeZv/ML+IsZSVIK1gTyECwpKATbUhcutrH5VnUv5WqmFeJDI4QUCWJAzpxzSg1WPzpz80hgd8opsLrX2sYtfsgq/NaVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qb2L3h15YWlKafnJ7MZZeQVexFxoP6N1NYgwtJV+U18=;
 b=BHZ8tOXR1zpvKj+/E+8SQ4jeFgLY3yOGlLZiiEG1sed22ooTt9U5leDRydQhQ3WGCVbwblUGm6cD/E4HKhEOPPCQtuUOSCbtoqaJOvsd4merXBRWZ0taE76QEMvscwEcT+UnvPRvXGoqS22qMPMd2vVkAC2YyNKD5ob5J0gzfqzwVIch94Uld/pT41jFIttz8Ok2WV3nMywc6oiZVylOb+0tQjkfQeuaLw0LEvFeSZJl0TzePIZWXXB5jdzYTFwMuP0WHxmYYEcPtaRgv5btMPJh7CCa7SvxRcYHDG1vD73n+8UWDneEcspX5vLvRe96h+StsQhuPlh6OmbySWweEg==
Received: from SN7PR04CA0107.namprd04.prod.outlook.com (2603:10b6:806:122::22)
 by BY5PR12MB4147.namprd12.prod.outlook.com (2603:10b6:a03:205::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.17; Wed, 1 Oct
 2025 09:12:05 +0000
Received: from SA2PEPF00003AE5.namprd02.prod.outlook.com
 (2603:10b6:806:122:cafe::8c) by SN7PR04CA0107.outlook.office365.com
 (2603:10b6:806:122::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9182.14 via Frontend Transport; Wed,
 1 Oct 2025 09:12:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SA2PEPF00003AE5.mail.protection.outlook.com (10.167.248.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9160.9 via Frontend Transport; Wed, 1 Oct 2025 09:12:03 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 1 Oct
 2025 02:11:52 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 1 Oct
 2025 02:11:51 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Wed, 1 Oct 2025 02:11:51 -0700
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <rwarsow@gmx.de>,
	<conor@kernel.org>, <hargar@microsoft.com>, <broonie@kernel.org>,
	<achill@achill.org>, <linux-tegra@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 6.1 00/73] 6.1.155-rc1 review
In-Reply-To: <20250930143820.537407601@linuxfoundation.org>
References: <20250930143820.537407601@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <4ddfa698-bac8-4efe-9e7c-aa917617b36c@rnnvmail205.nvidia.com>
Date: Wed, 1 Oct 2025 02:11:51 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00003AE5:EE_|BY5PR12MB4147:EE_
X-MS-Office365-Filtering-Correlation-Id: cbcd2fe3-0eb1-4481-9deb-08de00ca9667
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|82310400026|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cUQ2enNnR1Z2NTIwOUpiKzhTcWM3bklDVGFVODZPOVJDZ3RiWnJKd3FGditY?=
 =?utf-8?B?TVBGbUdmZVR6eldWYXJqL0xnYWs3dGpWUCs4T2JaZmFJY3VkSXdMMHg5anN3?=
 =?utf-8?B?YjlTMEJVd2lTQk9pU1ZTdWdyeXFIWThtM2JvdnpqOTJMSHIrSWl4Ylo5dW4r?=
 =?utf-8?B?UDFGU1pxNXlrd3RUem5ISm5BUW9FbG1zakEyU1hWOTFCS2NGNzhKUEdKcS9u?=
 =?utf-8?B?bC9lRmhOSHFuM0pMeEQ3cW1CMXVRUWJucmZBVDd1ZGR6UmVWQWNoNGtsSXVs?=
 =?utf-8?B?TUF1NVJiQXFGampORDgxcjc2Nmk5aHRqTXFFKzVISkZMREg4ZzFHZUYzWmVa?=
 =?utf-8?B?aG43RWpsMlEzRmZ5Z3ltZ3l3aEVjSFBrNGk5aENnMy8zcjNybG14OXljWUlI?=
 =?utf-8?B?Q0NHQTBNT0JQUXZPMExKRHFITzRoWmtYZzVNV3ZZTXY0UnpveFZlNC9nclc5?=
 =?utf-8?B?dk9MRTZVTmlkK3pVVGRXb1ZiZEhROEcrRW8zRWJwSjJGbklVdi90UXl6VU5S?=
 =?utf-8?B?ODVWMmxBZlZrV2xQd2lvL2YwMko1RkpzOWVjTk5WdFgvNzFTT3NDcWJhVlJz?=
 =?utf-8?B?WTR2bm42bklsb1Rqa3IrZTNmUFZMZm5YRlJWdzVGWERaWmc1WkZKYW9hRTNj?=
 =?utf-8?B?a0htOXBocHNjb2JOOUZWL2ROd3FsSlNRNXNJZG9DQ2FiYk1UN2l4MjJYN1pj?=
 =?utf-8?B?bkpJOU9mS0xMdFJ2bFFNa3IvVmhXRk53eEx4N1B4NE9PWWlsRGhIbnVON0pP?=
 =?utf-8?B?aUI5SXlxVHZ3aEsyTGd0aHQrYTBBakMwWmtpWlZRZDdhdzVTVHZUcmZGVFpv?=
 =?utf-8?B?MUYrak1RcC9LbGhGMExZWVVWNXBJRnJwcWtHL1JCdE1xNS9kRHN0VmpJcXdP?=
 =?utf-8?B?ZGVrMHpybFJna2JNS2lzNitsUEJHT21KeXpsMVp1MVM5VC9ZWFNyS3FQSjlV?=
 =?utf-8?B?bGVqR0cyMGw4NXF4UENpVkFteENxUkhUdWRhTnVxcHJ0eVNuN0djbTNnY2h5?=
 =?utf-8?B?aTQ3ekkvMWdHK2MyaVhXVjB5cklmaVRYYmRwNzQwb08xREczMXU4c0JDekJi?=
 =?utf-8?B?b1NYQUdmclNxMitjVjRpYVFPUkJzMks4VW1PczdDTFdDUURsd1Z1UE9zVXQ2?=
 =?utf-8?B?YVhvNEJZMHF0WVA3YndqSVhvVnZNNFJyU3hVeW00MGg0UHIxaVVCN0w0Wmdp?=
 =?utf-8?B?dGdHazhwOFB3RzV1WjBvUlgyd1JvbFVKVktzaFhzSHltajFIdEp0VEtSVE9N?=
 =?utf-8?B?L2lnUitOb0ZWNEkwbCt6QnlxNXM0NE9YS0prWGNleitja3o5R2EyZzhRc01s?=
 =?utf-8?B?eXFOY2dhcnAzUXZVQTVSbHlmeUdSMlV3VnhKWHViZHBGRHp1MXFtcWJzQzhp?=
 =?utf-8?B?OFFMcG9yWUlOUnU1VlR1TGhncHFxZ0hFYXdVRHdsWmtnOTd0ektkeEhTQXhy?=
 =?utf-8?B?VC9SUUtCWmlPNjEzSUJLVFRyVlZSR0ZVekRnQVplZFA1c05EMW9EakZ1bFBw?=
 =?utf-8?B?eEZCRkQvb3VIcVpGNkRhVHJlYlpNbGR0bFdBSVF5eGRWTW9VVVFPa0MwZ09x?=
 =?utf-8?B?S1NFOWY2N0thSVlrSGVjV1Z5NFR3NllSbmwvTHRza1dCdWswL3VscldtdkJz?=
 =?utf-8?B?U1JjTXNtOU9UbHEvQXJQa1pXQXBZc3FsV1FXbGkxVy9hT083NXJzeVpwaW1j?=
 =?utf-8?B?RjdUOW1uUWs1TkxsaHdWZnU0M0w5bjZMM0ZOY1lrUUp5ZW04UDdsdC82Y0pT?=
 =?utf-8?B?QlJQVWZJK1RBbDZnRnNabHJEeTZiUjJjYnBJSVE2TEZYTStqSXIwdWpxR2lU?=
 =?utf-8?B?TDFBWUhGOVJ6aGtlOGl6OE1Hc1dSdGRRd280RU1NWmJiZ2JHME9jTFllSWQ4?=
 =?utf-8?B?OU1SR1FWbndWRlVxb282dmthL2tPWnVzWDBQOElHeU51enlhMWNYUzNNdFdG?=
 =?utf-8?B?TllJMWZpaytCVUJqaFdnYjc1VUFad3ZIa3AvQ2lCYnpVQnNkVTlscWkwSzFw?=
 =?utf-8?B?VGZQeXNURG13bEszOGFYT0NhUTZ6blAvV09vMkFET1MrNlFUNVdnSkVrZ0k5?=
 =?utf-8?B?eWlNcktCazVUR3VkZ1B0TnA4Q0l4b2ZGYnlpL2hlOW9UdTNoY1JpUFl2Qkt2?=
 =?utf-8?Q?ji9A=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(82310400026)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2025 09:12:03.8456
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cbcd2fe3-0eb1-4481-9deb-08de00ca9667
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003AE5.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4147

On Tue, 30 Sep 2025 16:47:04 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.155 release.
> There are 73 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 02 Oct 2025 14:37:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.155-rc1.gz
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

Linux version:	6.1.155-rc1-g8a8cf3637b17
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
