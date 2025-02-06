Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2070.outbound.protection.outlook.com [40.107.223.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D31B22ACCF
	for <patches@lists.linux.dev>; Thu,  6 Feb 2025 11:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738841894; cv=fail; b=Re1YO1gnpzhPyYlKAbqaMh4D9eptfgwAmvm1eDM+v08VGKcHYAgi3warsLjuqzAb2ci1hfbburiSWeYj8+FBoXwlGEJix1MBkAZhgxNZClWeNx51PkVy3Mp0Db/ZzgLjayR6C+owkDrjj0kvhc4DTC5YCkbNo5RWSj+Eaq7L0/M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738841894; c=relaxed/simple;
	bh=CzNUkDiKb0nqMFX6eCS2NA0P1241FhwHk8op7TjEZd0=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=cpx3ZEnHnhQtOlZLCf6rhNkAbaqfD4skdyNGvvnp2k8YcB8/xeFPFXufYsmfghAal9wXiBEZpu8xjum8sSp+hWS5MrT7OpShGtk+e1n3kEoJXfNPRDIyqvt5GU32eKzQnJyHbabBE+3h2hS8zSMhN5NWjFLFD0oKCsDKc6Sexw8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=p9pwKQ6x; arc=fail smtp.client-ip=40.107.223.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="p9pwKQ6x"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AaQi2wPrB8zWv9ke2FwVFdLyDg32gMC/Tr2eXKy8u4BVkgqnVt9KTJcTdFwJzi+GKbmUqiSqe+w6F+Sz7EKAg9mEGzcp79/d1XuiAR/NL9ZGxu7+fOHCQj9+3S5b+t/bssdMJ114ZUqnJrOkSLyBIEhiSdPbszDf+QXaOZnwnRtdJloFCA/i/IXlGXjTci/EE1boUS7pACMX5U3HmGQrtvYF5KKoTUMwTPg0Wij206Iqy3DSewUsvBZHfCKv17hcFaRm4ziVMOOkDNzXFjny25D/pQV1e77E+wZhJLZiFYn4CUY6Ep7x7c/Fo9RkurlwG+/U1FDdaDK2CU6Ua5LraQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w+48BfDRHRvhGMxiZpgslw2EKpdHZvBn8dGOgRRABOU=;
 b=CuxO8AA+TNtdqhMtKQUEl5ioktX0MAQOFsjrBGLd0plq+NcJtzjX2288f236MvMqlTifoJpys15iYlph4MWX4yF7CsEE3EwP7o8BGq8TFKUQKA7EEn9Hd+Ugwo6DPi14BJFD0M66boKj6uBhUdv6FJyLkqPCCN6m9c90/b2zmDoDnyKctAk+Y9dia7UJ90yt4+ZXDwXjHR0qUy6xylSJ1Uq+Ly4ZafN9jXRyB0d3El9vtkiYR7/OfTH9KR0Ydgr258ozoYb/4+bF0Boyljej/81dlu164eVY+B9O6ToIO/lmvSioiBbewvyE+3RZtksH5GrCjLjUDLnP+4UzbqMt/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w+48BfDRHRvhGMxiZpgslw2EKpdHZvBn8dGOgRRABOU=;
 b=p9pwKQ6xE0QnARsD6GdYnKsUE1qjJKusxH6OOfyLChKOmfOqAB/0AqFBZ0ruCWjG5e36Jh9q/NPgcn4AR8Bb8O52KyOjwSyMJ1w9OFYWXJxkLM+2dCWuiPizYScZTlNFC2FdOIr6LD9nmeKNVFR4LS1gPkS2vgI/PfSLyDQeAWwTuN2mFHL+2P/I5yZPYWP0NFx5K3gm73NcQVUvKCGvz0JXiXEpRw/ufKYx5sxzUda0T/TNLTvDEmc2tHkW0R8U4GKTgiYQoEBItQj8d4Eklkhlvpz49gQhu04qgWe0VeQy3wqXBsSI/e4fUQAzqrvh18nnL47e08bXuDbHdOnQMg==
Received: from BY3PR10CA0009.namprd10.prod.outlook.com (2603:10b6:a03:255::14)
 by BY5PR12MB4130.namprd12.prod.outlook.com (2603:10b6:a03:20b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.11; Thu, 6 Feb
 2025 11:38:09 +0000
Received: from SJ1PEPF00001CE5.namprd03.prod.outlook.com
 (2603:10b6:a03:255:cafe::fa) by BY3PR10CA0009.outlook.office365.com
 (2603:10b6:a03:255::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8398.24 via Frontend Transport; Thu,
 6 Feb 2025 11:38:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SJ1PEPF00001CE5.mail.protection.outlook.com (10.167.242.21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8398.14 via Frontend Transport; Thu, 6 Feb 2025 11:38:09 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 6 Feb 2025
 03:38:04 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 6 Feb 2025 03:38:04 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Thu, 6 Feb 2025 03:38:04 -0800
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
Subject: Re: [PATCH 6.13 000/623] 6.13.2-rc1 review
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <3d6efed5-b25b-4836-8063-fc53d6471e31@drhqmail203.nvidia.com>
Date: Thu, 6 Feb 2025 03:38:04 -0800
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE5:EE_|BY5PR12MB4130:EE_
X-MS-Office365-Filtering-Correlation-Id: b4c57d22-0126-4cc9-a9d0-08dd46a2bb2c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YmJNMDlqUjlUVFVxWXA0T2Jxb1hmWnhFLzlobExqVTdDWnFLaVhYYnZFNWdo?=
 =?utf-8?B?ZlhxQ0E4Y0ZhYXBpUkZsbXlLdHdPMCtBcjhiVEtsSFR6TCtiWEV5Y0RzSzRq?=
 =?utf-8?B?YVhWUVpjZHE4eDIwTDZiRUZEN3lTdDN1N095c25hL1BJS0VlMTV6Y3l6TXZn?=
 =?utf-8?B?Rk5uUkhZOXlXcUhqQWNpNWtmalZRRGxGMGRUWVFVY3VSTEJDL0pCU2dhNVlL?=
 =?utf-8?B?c3pPR3I3Q2NMUHQ4WmlCdlBwZURNZzZjVWM5VEl4TDZnRUtLZ1B2Zk1MZzdo?=
 =?utf-8?B?YzRlTUtUUEJvTDZJQkNKZzM2YWJjRDZ1Zm0yWC9XOHNDVVAyS01XRjNMVWZ6?=
 =?utf-8?B?TFNqUTJSY3BoVFNVTkV6TkpIWlFQNUo2clpnSk1WdklVY284YVFmVDlxZS90?=
 =?utf-8?B?ODhZUm0rMVFoZlduSDRtN3UwOHZKSGNKWGxXK0UyK3RIeVYyWmpUVXE2MnBQ?=
 =?utf-8?B?ZGZyQytMM0xYemxIUDFkWS8yTnV6YWZDeVJyRDVhV3YzaG50dUd4eHZiL2Q1?=
 =?utf-8?B?VHluemRORnRKRzhLUWRaSFFPWmZ1dWkrRjFpdUZ6M1pMaUszVHBIdjNsYnhZ?=
 =?utf-8?B?b2M1NWpDanYxb2VoTzdoMVE4SG9qQnpPaDBSTE5lbWRHUUc1Nk91V2hSWGlT?=
 =?utf-8?B?RGc4dTJ6L1B2Y2tEZk4xZ0RlTEswd21rc01FUVJDWWpDZWZxVDJ6Qm1Tc2pX?=
 =?utf-8?B?ZzFHNmxGd2tpZCtBYkVicG1zRk5ZeUZiMTJaWmZGY2ZIWjB1WjZWd0tHeDlG?=
 =?utf-8?B?S1loOTVMTmR4Ry8yY2FVcS91SURhY0lqRHM3d2xOeHg1U1J3WVpFczZvOHov?=
 =?utf-8?B?ZzdGUnRyMXZobHNINFEwS3ZtQ2FLenRBczBTdlFKYXJ2TTh4QkhhTGFHZTls?=
 =?utf-8?B?VFlvSEZMOW56K0FKcG9NVGMzS2M4QUdJTGx2VzBpaC9kajdMbWZoczdMODNi?=
 =?utf-8?B?d1JVbmg3Tm0yeXFmemwrbmtCUHlUSzA5NlRTMm9WNXpraVhrQUd5Z09kSndj?=
 =?utf-8?B?WlhtaG5lUnJNd0MwUHlCc1FCWHNSTkc4OTBPVjVtMG9LYlpGOGRsZUNBNkdU?=
 =?utf-8?B?cHpBUzlpMlVCc1lvWm43S3VmbElWK2YxRmtkSmtMMk1KZzRCaDY3WUFzaGwy?=
 =?utf-8?B?S01iVVFET1pmWVdWVWhMRGZiZHh5NGlTdGVaYy8yREtvMmFMOTBER2xiUGxE?=
 =?utf-8?B?WGJzaVRycXQ4K2ovT0VoSDFlR3E1UjZKY0ZMWXNRUzN6d094dkRpRk1lbDhx?=
 =?utf-8?B?MGp0ZzdoMUppdjVnZVFubndxeXFkQUM4dDAvSnFFOXJkTFBrRTZhRVNYUWhX?=
 =?utf-8?B?MFBFS01GQ2Y5SnRoZ0tkV2dZNHZBb0ZNMHcvZDZEVHo1eTR3R2QxeWNmSE9o?=
 =?utf-8?B?dXdrdGVlSFB4RU1DdnkvbkFmSWdkMTl2ZFZqTlRvYnJCSFNYUit4Z204NW8r?=
 =?utf-8?B?cDZHSjlFMzhGbXc0dUU0YzhvQVhGVTI0VXRSanltTTkvVDM4RWZxaXhaY0ov?=
 =?utf-8?B?ZmV6SWVuVFpiOG5ibGxabUhpMFlEWHl1TUVoZXVTWFZDTnZnODZERUg3TCtQ?=
 =?utf-8?B?Z3hXWVJzeEpCOHp3dXdmRGJyc1BoM1Z0dDgrTk1QZ2dLTGxuWnRUY2RRcjU3?=
 =?utf-8?B?U1FBWXBEZUY1YVh3YzZoOElhQWFNQlJIcmovMVJuSXhiT1o5YitqSzdSa2Vs?=
 =?utf-8?B?bTc5cjZMd3dIemMxL3k2OE80Mk5jeE05aE1BbXg1MDdxVHdKOTE0cWpZbk9W?=
 =?utf-8?B?Z2NrSzRZczRJUlZrVWIyblg4SzRqNksrSFlEM0V3amZkMUNMTWQ1UTA0UVUv?=
 =?utf-8?B?QnV2YlY4Y0lja2k2OGYvNVQ1UmFMK1d3VVUwRVp4NmZSNWdndW5ZVFZ4T0VF?=
 =?utf-8?B?NlQ5V1ZtbThmWUhXRW5VR0l4RThNbnZRckxMRkNPeWNISndGSU1OaGFTYWVL?=
 =?utf-8?B?a2hlOXgrMlRaQ0tad3hxU05ieG1BMEhWWSt0NkJ5bmdBSVJjbnF3L0xxbE8w?=
 =?utf-8?Q?weUlvTIqMn48awqn6vEiIyQDfSbtcE=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2025 11:38:09.5078
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b4c57d22-0126-4cc9-a9d0-08dd46a2bb2c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE5.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4130

On Wed, 05 Feb 2025 14:35:42 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.2 release.
> There are 623 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 07 Feb 2025 13:42:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.13.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Failures detected for Tegra ...

Test results for stable-v6.13:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    116 tests:	115 pass, 1 fail

Linux version:	6.13.2-rc1-g32cbb2e169ed
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Test failures:	tegra194-p2972-0000: pm-system-suspend.sh


Jon
