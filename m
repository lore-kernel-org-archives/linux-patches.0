Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2074.outbound.protection.outlook.com [40.107.94.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E32E13C47B
	for <patches@lists.linux.dev>; Wed, 15 Jan 2025 14:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736950429; cv=fail; b=m14DgLIT3pRZYccKc7CuYmXzqrj8T8+fvnX0hpQaHMzw2109465IoGQiqyItLgwNU9+kPwlAWpl0Si0GtE+1xBohkz1oPdZnXzKY+7xDWlQxzcx0NosDKjPhOGK1rqgEv+lqdeGtvQkdtDkHMyrXYJa6cBWsokkE6K6YcjOgzjA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736950429; c=relaxed/simple;
	bh=tJ3BFrtKYFPsIL0yNSBeGHcKodExpR2K1JGs5fZYs0I=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=ArvWUnojJuGh1tkfeGc4R7D9npfmwW1qYs/U+v4QLOHcyh2/E32x1aXIxI4Qc248aIsCogZ7Ct2hTyvVYVIUn9E0ccJIsBw2XGpbupSn8U4S4HnptLDt4fak+UuJywrs0iQc3CRREdAKFQSiOY2paN7wdn1hHmY8eIxVzcMFzLU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=QpR6I/xy; arc=fail smtp.client-ip=40.107.94.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="QpR6I/xy"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BQ5s7ln7FEc6Akx1921bLuxqLfxP6Ro4oTjFpB/W3ftOK22Ja5KoYOJjd97GhpBXe0DY6cvN5c4YocYKagMN1dgpTFIDYnGjeudlLHTshRhFMlFJLuUYeGVEjhPTSUGfxXUkFVIfE1Thela0EtGTUuMXrroKRyhzDYzYA3YO+NEoI5ZTgnC1VDLE82TIkh0OCDiIF9iyCxzjOfrVNM6Hx/ku5Hson7E4GJj9AmFBzGcAweSIbLsZUJCYQ7kQmtE4ANeCjLUrPgg9uDLJnqJGJ70xaFGE95TSbGZmi9vJVGFYtMLbpYjjdSLfMLo8fiUuetO6ltxlhLJh5tVueGKqDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y7BPxbMc1GIPl3t7+z2vZ3hHy6JAkySAFPegvR30UCw=;
 b=JZ13VZOhC2UDc62NBGsNf/ZLGB06yurKAoHFsrc4LvKBG3FPf29uaWktM+c4i1byc3AT/qBl+cUAEvRjJ5iuP2jrSQiMsJiQymN8016XgMqLfxTLoJiEjY18wxkOaVOI3MuKxNJqrtF1GSB7HmHJuTqElYRNPgp1GhfJARNvqFomF+464+Dhr4ChErkY36sX83T+sbd/gj72pkZ5JCLuBvrsHc9dHHVjvQ5J1t9AznVCZXBpyObtukC0KH+0cP18yS1rdvGewTXeJjWND7ieMJ9L/ys1HBXivNs+pv0vUDlhWBrt0GTg4+U8JhSfurcXjJsSf3syIvKq/NOptmJaLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y7BPxbMc1GIPl3t7+z2vZ3hHy6JAkySAFPegvR30UCw=;
 b=QpR6I/xyQQla64UvM/u/pg/I5X+AvUGUoZoS0Q/4xVuuzpSs0YsilZ4eMERpLGzt5O9paGrKqCcN5nkAQvNVwaUSxQSpZuryqAWhsw/f7CaVPh1dvAMwbujtoD1NnKf3jd0vit+V6ek1LPIOnolFX7OlfbNb6QuqowUx4XOvguToYciNLKXUwIv0Oqtcz/jN9imK2iQHewWOFtFB+glrHYA9zt5Q3RVlyx8uXLextz7Zavc3E4ONxIByv8zFh6lP/I6LtCbcaOiBqk3JePQ13fCrX33ueqcjtQjP11LC+u5uEvJuhAs0Grvu0gVI+whm8Yk0Luudyga9ArkYrqQO9g==
Received: from SJ0PR05CA0063.namprd05.prod.outlook.com (2603:10b6:a03:332::8)
 by IA1PR12MB6091.namprd12.prod.outlook.com (2603:10b6:208:3ed::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.18; Wed, 15 Jan
 2025 14:13:42 +0000
Received: from CO1PEPF000066EA.namprd05.prod.outlook.com
 (2603:10b6:a03:332:cafe::7a) by SJ0PR05CA0063.outlook.office365.com
 (2603:10b6:a03:332::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8356.13 via Frontend Transport; Wed,
 15 Jan 2025 14:13:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1PEPF000066EA.mail.protection.outlook.com (10.167.249.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8356.11 via Frontend Transport; Wed, 15 Jan 2025 14:13:41 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 15 Jan
 2025 06:13:21 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 15 Jan
 2025 06:13:20 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Wed, 15 Jan 2025 06:13:20 -0800
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
Subject: Re: [PATCH 6.1 00/92] 6.1.125-rc1 review
In-Reply-To: <20250115103547.522503305@linuxfoundation.org>
References: <20250115103547.522503305@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <ed9c22ac-0d73-4056-b3f9-4bc02b3bf1cf@rnnvmail202.nvidia.com>
Date: Wed, 15 Jan 2025 06:13:20 -0800
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000066EA:EE_|IA1PR12MB6091:EE_
X-MS-Office365-Filtering-Correlation-Id: 125370ea-5a53-46f1-6f7f-08dd356ed06d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RjlnbndmSmJIcW5Ba1podWdtL01Zc3ArNzBOdFFkSm9DNlRGTGZ2eGJsRjRq?=
 =?utf-8?B?NGpDdWIvZkU1K1dxd0lKeHBkSTRxbTl4cHZOdFYvZHNxTEN2cEtNWVM5d3Bo?=
 =?utf-8?B?bUIwQjRQSkxRcUdkSEdKV0VHUW1oa25JSGg3eHZiSjhCY3lCVGNlNHF3T2Fz?=
 =?utf-8?B?TXVZeW5OcDM0OHJSUVZOYkdGOW9MZ3VrMy8yVTlyLzhkb05HR2R5ektJMDFu?=
 =?utf-8?B?REJvMXJLVGhEb3hEeWdJRGNlbEFDT1RtZjJsdTNaOFRiWVoyZDNGWnBOR0JT?=
 =?utf-8?B?R21xak95VEIrOGVQUHpqUHlPcUhwY0xwQTJCdlphUXhnZm1QQlpoTEVtZU5P?=
 =?utf-8?B?VXUzVkJ4UmZITWdQeU56aUdJTEtqUXc2akhWUzY5Si8zOWtvcnRCUnM3a256?=
 =?utf-8?B?YkpjME1XcUxQVHhYTy9sZko0a0dLRjM3UkVScnVhWnVFLzNHZGhrWkVlcFZj?=
 =?utf-8?B?SDZmUEVWR0dFZFVCVHlxckp0eEI5ZFpPMlgwOTVvSVlmMHh3ZnpuVVo2U08y?=
 =?utf-8?B?aUN2dkZxVm9pY080QXVjdm1ZUVhOM1hOVHpYZVhBVkR4MWh4d0VuSEJiNEdn?=
 =?utf-8?B?dDExVTlENkdMcG02VFFvK1VxZ0VSSEpFR2M2aXBjL3NOb2JCZVVOOEZtUWwx?=
 =?utf-8?B?elQ4VEFGVnUrM1RaQ013Z2s0NzZtR1pSei8vazJRdlo2RWxnZUNXNFlYSkhI?=
 =?utf-8?B?MFlvcmxRRDJHN01CdUtKSUZNbmpuT0FpbkFWRWZhRUI4QWxUQnI2SmYzaUJL?=
 =?utf-8?B?YnQ1L0k0K0ZvWjlxWHhQNldxMHVsVll2UnBvSVJxTzZjbkhVY0NiUTVNNnV1?=
 =?utf-8?B?dE1PREZTRHpLMlBIWTR1SjJCdk1HTEtkeU5RZzRjdmlKaU9idHc5cjRiUWlC?=
 =?utf-8?B?bTBRakRHREpSREIxeGNVWjhTVzlDM3J4dUFrRGhaS0NGWmFFb2dscTZDWGhO?=
 =?utf-8?B?ajVUTlU4MFRLNEE3T1h3VkYwbzc1TXFvMTJVYTVYbWI3ZE5jWnE5WE40UzlL?=
 =?utf-8?B?b2FpclJ3aEJUZlRxbkJadWFmZDJrNU5JOGRGcTA2eWE5Q2hhOHRzSW1hak5y?=
 =?utf-8?B?QVZNVGFZQ1RtYUpVUmFOWjRnV1U5S3krRkNKUlcwMmJJbGRqMVRMVVRCMS9q?=
 =?utf-8?B?UFNmdnVMaEhWVWRvenppSVh5ejNrUjc3MmMvbExVZVFYV05TQ2JPUndGVXNo?=
 =?utf-8?B?a0wzb1g5alhYWHFKN2VUaFY5b2dzWGhNV094WmhhNFczaG1hQmlnUGJraVpr?=
 =?utf-8?B?QkFHS3BzUUR1cmJKUmhQck9adVR6c1ZNa1BZVVJnWjFGSHdnM1Y4S2JQaHdD?=
 =?utf-8?B?bWhpK0d1aisxalozRGVUWVUwK1FpaWMrTWpmSE93ajJoYjBFZElHakt4ZVVv?=
 =?utf-8?B?RTlrV25BWktURU5SS29UdlI4VnNuYUxPdjhQSDJ2UjNuMDRuQUMxSXMrcnZC?=
 =?utf-8?B?UlI3S2ZMY0VGTnV3emJEeUxuZjhEVmZrUHhiaWpsWDJuTHp3NjVUVk4vMjhD?=
 =?utf-8?B?U2V4N21KdUpVckVzSCtCVG1Yem94WFJkZlVIdmRzWXRQQXdVcmFVa2ZIVmtW?=
 =?utf-8?B?VzMraDFBbWhKL2J2VkZsV29ONEZiM3VJdEcvcWswRE5oTjNNTnJmQ0FjdmdK?=
 =?utf-8?B?WlN2eTdHMnE4QXpOalFUS0ZmV1BkcGk4aHMxRzRFaUFKZktFQkw3WUh3KzRS?=
 =?utf-8?B?RnZFK3JEV0VMdUViNURxVVJtd3RBZ3F2UUtuZ01yeXJkNytxUGtaY3BidFB4?=
 =?utf-8?B?YU5Jb2ROZnFrK1QwcUs2eXRHSm1aYVE1K3E4VWZPRXNHcS8zZHJmaklzODdI?=
 =?utf-8?B?ZkExM3ZGamhwMmhlQkNtUnpUTVRsZzBjYlQ2QW1JamNheW5KTTB3OTVFUWpu?=
 =?utf-8?B?VjNwRkUxSXNpWWVOYUhiRVJHZWpzdVZLM2xTTmhCTldieFhPaktRbjRudTFs?=
 =?utf-8?B?encxelpCSDhmUkhuaHUxWEZvbVdMbTZUVmhyVGEvOG1nNWFWS1NsT3lmWUUw?=
 =?utf-8?Q?QKhSjwaidfoR/Ga6gHaSOCOgrHpHY0=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2025 14:13:41.4579
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 125370ea-5a53-46f1-6f7f-08dd356ed06d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000066EA.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6091

On Wed, 15 Jan 2025 11:36:18 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.125 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 Jan 2025 10:34:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.125-rc1.gz
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

Linux version:	6.1.125-rc1-gf121d22cf28e
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
