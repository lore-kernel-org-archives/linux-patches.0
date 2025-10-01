Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010037.outbound.protection.outlook.com [52.101.61.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA11C2D94A8
	for <patches@lists.linux.dev>; Wed,  1 Oct 2025 09:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759309911; cv=fail; b=kgyT+6MvAwUbBE/tB4Bk0lYCPI9qyXSBIBQf+dVKwgbo22QkK7dPbPSYOR5lSWdkR+y8/YG78i4D9z3JDpHY5eMWhXNcATFlgPpMAcnHipz3XbjvyiWU6FNPK/gXPQXn39wrlwvm6RIHzDCY1CwjJmBjG8yDbjkVsPI4LpBn1t4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759309911; c=relaxed/simple;
	bh=cpnlZAcevt0UNVKE+iEp18Jsyuw9la3gxIQFYeekg8A=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=pU1uUgliBJ0xVlmZrbXrDlwSfken7O2qHKTKrhifNvC7ShCOMN68xzkDPGQfv6/dadfAsWo7Y2QmokE+gDnj7Mjz7ZDTFyMIAfHGyL5bYPhxQZzTnTrNCX9dhqWc6WJVunjfgBMWCiGRnKGkZTGe5k9koRzaI1MyRArzl1Gc994=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qoC1U2S+; arc=fail smtp.client-ip=52.101.61.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qoC1U2S+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NzY7ZruoXd2uWcRL9Ea+p1QY4i0XJUjFdkvOi7PRUSyhr3Gm0zkgprtL/Q5cstvJmykHjtSivth24//BVN0GsY6qzFDU4gr5DvSLyjQ8hY01ngcOfULSGIQbXX7Yo/e6LLk9Jq5PwDrueAh8zKfkAb4QS1C4xHv/fDWQwSbBm0/RlapxNEKF04uiNEtWgZLjYooyHrtMMjewupC61g8IExA/apY7A9br7Ib4Hjdyz17WwqIL62z7cOGrM6quDQ/BNtJ9nqcpFwlOisX9AcGTtvfinYHRRreysOxrrUgWY7hfr+DHL2ipm3em9kws4q0r7yPrHjU2h7LFHYhqxU+zsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YemrYt0rPpzqLIZsGBZFNUsbE7ANMBys7jDw8mHc5cI=;
 b=VF2aJD4jgo+NEeINxKXQAZ9r0PfYh9YHxqCQGwyx6uF8s2vweGbzdyI+mjfYJAyJj3pFgbdIhZcB7bGH4DnPC0/knoUT6yIWnC01Q5IqlY9aPXUdPg7p/Yf6Q/GHhg/HAe14H4vzlpei7PKxR3Y9PKEIMway8HfX0MryX1yifvpWNImIgTP85ntN8N2DxbN26X/sOghpoQ5PgWdielFwhSYQ8kCen48sCOJvmunVVVqiceIS8CuAweLYmxSFXhzU6k7SsfH+X86SCB+Ox6+CC0JqrVTIfD4rn/SiuRhi5WCLIo2iNxOJUasAFwsBbWNBbgawVDvUDasAtdyJHVQj+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YemrYt0rPpzqLIZsGBZFNUsbE7ANMBys7jDw8mHc5cI=;
 b=qoC1U2S+q2CjCIsGTzDQMsDTjMM00s2shKq2/37pvHPFaqAZ4FZ3pBigHy8Rno73jfCHCtDJjaTxgBoXyTFlty/rjTkBUAD8XqPkolSA2HWmWAnpMc3dAOy97ydKoLaaGrq68zjZQ65JRQHLkNf+GEZpYTWLgD6rbNpP8F1n5EOmelm2MzIiZlvpVbAnpcBW7C4t89DromEBW6hyB/J6zZtZqmVDARcl5so5GldiEYPoTrs9IJzceBLjatRmaloLs636rxr5wDEqNa+zlG7vpGitwv+Sw+PIBTMMxtP4Sl4EeR4/B2RDydHcs7Drt3O30uy6wqnTsBD5BT0wg4lnPA==
Received: from BN9PR03CA0279.namprd03.prod.outlook.com (2603:10b6:408:f5::14)
 by SA1PR12MB5639.namprd12.prod.outlook.com (2603:10b6:806:22b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.18; Wed, 1 Oct
 2025 09:11:44 +0000
Received: from BL6PEPF00022571.namprd02.prod.outlook.com
 (2603:10b6:408:f5:cafe::a) by BN9PR03CA0279.outlook.office365.com
 (2603:10b6:408:f5::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9160.15 via Frontend Transport; Wed,
 1 Oct 2025 09:11:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BL6PEPF00022571.mail.protection.outlook.com (10.167.249.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9182.15 via Frontend Transport; Wed, 1 Oct 2025 09:11:44 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 1 Oct
 2025 02:11:34 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Wed, 1 Oct 2025 02:11:34 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Wed, 1 Oct 2025 02:11:34 -0700
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
Subject: Re: [PATCH 5.4 00/81] 5.4.300-rc1 review
In-Reply-To: <20250930143819.654157320@linuxfoundation.org>
References: <20250930143819.654157320@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <42dc9bfb-8aeb-429e-adf2-5f1a000284e6@drhqmail202.nvidia.com>
Date: Wed, 1 Oct 2025 02:11:34 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF00022571:EE_|SA1PR12MB5639:EE_
X-MS-Office365-Filtering-Correlation-Id: 995c27df-d6b9-49a9-b7a2-08de00ca8ad7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|7416014|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZWg3Q0lkQTV4Q3lYVXpNMlduTCtGUEJ4aGVCYWl6T0NWK2lFL3U4ZTBrajBs?=
 =?utf-8?B?M3dZdUlJMzNXSWJoWDBkdzA5WHI0NFV0MTU1SVd3bTU4dWNXY3BUSlE1ZVBt?=
 =?utf-8?B?TTFuUzM3VDhOSmZrT1I5OXpOc0pEaEVPVnhEK2JCeTBibUIxUmhxOEZSclNT?=
 =?utf-8?B?V2JPYkFtZ3NZUzg0V2lCankrZXZNZFVDalFrWDRWbW56L1BNME5Ma2xWT1E5?=
 =?utf-8?B?Tm0ycTRNKzFNZ09Kd3JqQjJBV010RWN4eTY1SzY4S3ZpVE44WDVaNzVFRUlH?=
 =?utf-8?B?NGV4eC9FRzJKQitLczBmdFBKOHpkTUJZZFdHQVJCWGN2OW5IZGN0NEFjckFQ?=
 =?utf-8?B?YmQ4T05MTlRVTUo5NmlmZWtScGszaS9HekhzT05scXZIK0JvUGkzZlFSbGpm?=
 =?utf-8?B?aWQ0N0hRcWlQYWxCYWNIZnMyb0pOYjMzbzVLUjU4WlYrOTZYRE5HUVY0MVY5?=
 =?utf-8?B?Nlh3SlVJVmQwRHBoZ0hzaitBYW94Z3NoTDI3R2VxaTFyd2tLbmNIbnZMaUlW?=
 =?utf-8?B?NFJvRUFPMTJ6ZThpNVpZSDVJbmpFUU9FbWM2L0RNZjE0REppMzJkWUdYUEU5?=
 =?utf-8?B?WTd5dUNsVC9kZUhuNVNLenhUTGtabDBkVGtENHBCbjdaNDgxZU0zQnYrQk5R?=
 =?utf-8?B?bDJEc1F6SGJzcW1PVmt1ekltcVU1YTBSMmdtWUlrS0wzRUFBZmI2VUxDcVd4?=
 =?utf-8?B?UTRnOFFzMlg3Z0V5ZWVLVmxIUm53OHRsQ3E2M3R2blRkUWh6U1hHenBzTk1h?=
 =?utf-8?B?dElOZHp6amZaQWpKWCtoOVppcTJZdk9qSjJ5R0ZIbEp2ZW1yYnAyYzdJdUU0?=
 =?utf-8?B?L1EyTlQ4UFVxejBUbFQ5ZDkweHZLYTBiTEVDdHptZjl2dnJzOHFiK2RlT2la?=
 =?utf-8?B?bXQvZ2MvR2pjdThNczRmV3dOelhsamJjd2lxTkVCUFBsQnp6YnprVHozcEhy?=
 =?utf-8?B?dnVZajhTVHk4NmR2MmV0WXFuZ2x2UzVuTDJoaitQaTR4bnoySVRGVG9kU0RL?=
 =?utf-8?B?clBUV2IwbzBKeHczQU9SVFd2bzV2WHBpaDJ1ZHVQbkk4UlQwa3A2Q3o0K0Qr?=
 =?utf-8?B?TCt1a2lkcGFRaWtmelZKaFZ3Y0F0ZWNuYXM4RjZYZHY2ZDRheTNHZlNFWndY?=
 =?utf-8?B?TG0zT1dURWRtNmxHa0tPVkRmRmZhNkVkRkI2UjFaSzgxMFZFRlhYTXpnMkF6?=
 =?utf-8?B?NGpmWTN0b1ZLdURjMVo3MG1nYUc5QVBKWEpTdTE0VFBTeCtjTzI1UmRLUTdu?=
 =?utf-8?B?Qi9DcThmc3IvQzUrb0VDcU02cVhnZGY4d3dBQWZ6L29YZUpZN05KSEZ3VjFT?=
 =?utf-8?B?SFo4S0tKVGl4a3FsWGYzbWpib2w1RDRSZEhlTE41ZTkweHJEcGdCZU95MzJh?=
 =?utf-8?B?eDFBTHJxQ3RZaWVVcTdRTnBsQXEreHhOKzhKaThETk1Hb3RBTk42UmMwSTFz?=
 =?utf-8?B?RHR6aXZrdjhNV1daSXpQQnlVQU1DSU5CRktsWGt2ZmI0TFV1ZHdjYTI3ZFNq?=
 =?utf-8?B?L1ErYkZnb3hWWS9lRzJucDVRL2tOZWZVWUhYdnhRWldvcENiYW9RbVZpQUd1?=
 =?utf-8?B?UC9tYUFpQUFBem95Zm84M3F2V21GSVJjNFdreGJpbDRqTy92THFRTUExS3JD?=
 =?utf-8?B?UUtHOUE3aCttOGl1SEFGWkFrK0N6R2pTNXZ5bXg4elE1TUpJSy8wd0g0QU0x?=
 =?utf-8?B?U0dlUHJERFBGMUwwN3h3NGxZSWxjaVduYllRMHptdlRCdEFlNXhjQlBKTEFU?=
 =?utf-8?B?WEFIVDQxYWVFSXVHNi9vdXlYcU1iUGdTVWQyZkN1REhWaDlMblVOeWdiQUNn?=
 =?utf-8?B?cGNodDlSUU8vc2hFRjdyWlZHOWxFdkVtOXJ2ODFrU3k3OWcvMkt4bjFTTFQy?=
 =?utf-8?B?cmtxbDRUQkJUdW1nZ2RkY0xhd01TWmtLTjE1SXZjZkd0UTczVUNSWWszNDVN?=
 =?utf-8?B?MHp6bTR0aVU4ZEtQMnVzQnNXYzlRSzJXNUNSTzRPRlNQMVFUMFp6a0tacExm?=
 =?utf-8?B?L3RWdWpjQWQyOU1LdUhKbXRhWWtkbW5wMmthcHBBMytlakNNUlBxWmF3WU04?=
 =?utf-8?B?d2tPbU1tUkNSSEVUUGE1T09BL1ZuY2hkcFZsdjZLRnIza2x0dXNRR3NDdzN4?=
 =?utf-8?Q?TpOY=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(7416014)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2025 09:11:44.4182
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 995c27df-d6b9-49a9-b7a2-08de00ca8ad7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00022571.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5639

On Tue, 30 Sep 2025 16:46:02 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.300 release.
> There are 81 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 02 Oct 2025 14:37:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.300-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    10 builds:	10 pass, 0 fail
    24 boots:	24 pass, 0 fail
    54 tests:	54 pass, 0 fail

Linux version:	5.4.300-rc1-ge1a2ff52265e
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
