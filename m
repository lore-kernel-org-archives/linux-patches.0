Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2088.outbound.protection.outlook.com [40.107.237.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2004820E028
	for <patches@lists.linux.dev>; Wed, 19 Mar 2025 19:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742412936; cv=fail; b=ffC7BZOlbe4Lk7CTp9vWJ+li9liONk64qzgsGC4+z3HbgwE97ozFrMimzZx5nDc82z4xY/taJLXL7+k0pUlzZb6WGIA2KBtb84uVlDZpqblFs4vmAiViqsmQidDnjN88slVWKz+7ve8Z769MIzxmeHFeKq9qNKTuLAnO0kKFRik=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742412936; c=relaxed/simple;
	bh=Q3JmqlWciMjUgTtB8GbD5uSqJkkoSaoetpITmId03QA=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=Q6xonxhikUjcdzx62f035hWXtJzS6q0kZnw63/+zkLq8ICsNbpy9njYIKGCtAJHfRjgEss8vBgbMaGIw9k+Mj4r2YE2u4eIa0LE3x6KwVZlS0jqBS0jAilQYdAXEqXxReRYhZi+jEAgkbGUgc1pTXrLpC+FcQXrcnQGPjKiXtGY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=EzvTfvyu; arc=fail smtp.client-ip=40.107.237.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="EzvTfvyu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Kx2PbbMhWdbVGE5n91vrQUelBS2adbmX4Vw2iXyaPkTuWIZUMuIHHBPBGQlh9eQMMzCPiIFxHva4GHKuxwrV/Y9oVgspUWV7lglydQxIHzz21gptq69QhE1j/ClkenNbVNncfyqLs/n2/23BeOtGJSlIR8vuXhSFvFbw88g9wUnyLMjhKP0UAFZWlKqmUlHFvwQFwB64UT1JqSmL/I+VyfOUFg0H5XlWPz6fVyU028rLGqAzX0zuJDWAm07cfRa7uUfvrzUo0L394Ju0p5d16MUJApm+ZZqMkWJj224ICLkxvT5uNXyk2kN9kwpL8E6NI6QKk3XvjAxTJaDZ9XkXlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q0LKo9ZzZSW81bHTbg5uQG5Osh4NIptlsNdhznzH4D0=;
 b=MmCJ6vOnP5sa7Uf8CUfmVk0Oq4eErZayLjbtSuIYnGIzwQ8MLL1rvdUY5EJKUIZk4PbHrHbGEYWhLo4Bxwg82cpkvtoS8kQU6KD/V3MJxSLDXI+xnrONXh2FiGopCPMgJT0KEkhKHTxSUiSD7jwjz68y5Dk51hs8Pub+x2pKJ4jj2szLCaq0KPPkhyhVkgnfu5YDMv+nNc8fhSZqJN1b/G/0gzTBhiV0thETmTAaoajuenbDl07BUBMnU7yOFlhE4YFqqjptAQjrVzkdNSJ0D72InfvPUgOHy95RxQtkJBZ3InZf0Qnan9OmoVyqQ/n6c8iiOyA9Q6aMhvDol4H2cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q0LKo9ZzZSW81bHTbg5uQG5Osh4NIptlsNdhznzH4D0=;
 b=EzvTfvyu8fvx7e4bBxSVmjRaW3idaJ1FPgRp5a7Jcer1fb9n5tBpvPt9JmbHtjgwyngI3fsOihxuN+oyKBuaoCwOi77hfZRyHDbxUpolwrL4mc1E6viG8qsjtC3dXe75Z2j2JZYYeFSJB7aN+ChQseCQxpqpJXCzkrs7JKOzK2aoSiyAKFqEN7MoESAdZawHUIiS7PjuAL9KprXomXdUXzsvnUqIugZNGF+6wSm+ufgnhgO/dVkaHlib8G5Y3BuRTroW9LZOBoX01cTBmNVqIJtMcybQLC2iWF7T25V9ymwmz2BeHUyd7nS2q97LMc1mym+rChqGpqOM1wXhv0n/Qg==
Received: from BN9PR03CA0242.namprd03.prod.outlook.com (2603:10b6:408:ff::7)
 by DM4PR12MB6231.namprd12.prod.outlook.com (2603:10b6:8:a6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.34; Wed, 19 Mar
 2025 19:35:27 +0000
Received: from BN1PEPF0000468E.namprd05.prod.outlook.com
 (2603:10b6:408:ff:cafe::7d) by BN9PR03CA0242.outlook.office365.com
 (2603:10b6:408:ff::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8534.33 via Frontend Transport; Wed,
 19 Mar 2025 19:35:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN1PEPF0000468E.mail.protection.outlook.com (10.167.243.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8534.20 via Frontend Transport; Wed, 19 Mar 2025 19:35:27 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 19 Mar
 2025 12:35:13 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 19 Mar
 2025 12:35:12 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 19 Mar 2025 12:35:12 -0700
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
Subject: Re: [PATCH 6.6 000/166] 6.6.84-rc1 review
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
References: <20250319143019.983527953@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <a8910b73-9e33-4b90-8430-5aa93728feb9@rnnvmail204.nvidia.com>
Date: Wed, 19 Mar 2025 12:35:12 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF0000468E:EE_|DM4PR12MB6231:EE_
X-MS-Office365-Filtering-Correlation-Id: 4409ee8b-e0fc-475b-b924-08dd671d33b1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|36860700013|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NExpWGI4cTRuVmpFa2p4QVBjVEpqVWgvUTdEZ2dqYVlERnZIU3A2ZmsvazRp?=
 =?utf-8?B?K01FMXhkdWQwbzBLNkphTDZLWmsvYmJOVUFPeHdUQTBZRnhONVltZFd6OEJ0?=
 =?utf-8?B?a1dSK0s4dkRERVNaZjduanVwNnZ5cUlkaXNFenU0M2xPWHlFbzFjbTBzeVBJ?=
 =?utf-8?B?b3o0K0cycEJBTGJIanA2VWQ1bTlTS3lGKzBKWUc2bnRaTFo1M3V6WjJQQlRy?=
 =?utf-8?B?MHRKU0ZnVlkxK3p1emVCTm45QWFzZW1JT0V1VytrbXM1NTJhZTFvZk9KbXA0?=
 =?utf-8?B?K3ZmcWk4RU1qYnRFTFZFdmxYREhhdk5ZbVNEMlpzOTNXNzZlaVNJVm9jTU9s?=
 =?utf-8?B?TytETWJMbWtFNE5PWlZDcHVyUnRVdlZiemluNXllMkJjNXkzaS9icnVNTVJL?=
 =?utf-8?B?ekJSMExEbG1rOGJBOHlQUHFUVHMvTzN3RFJYODI5RURZNStkUlVxMWlPb2VM?=
 =?utf-8?B?eDIrS01icXJlT05PRVlOcjhYbC9UOUFKM3BOb0xFZGRxMHU2MjEzbHFuc3FN?=
 =?utf-8?B?Rll3U1hhTkY2Yy9BWnhka3gyNUZRSVU4QWVITFQvc0pzb28rVjJMcWpiWGxQ?=
 =?utf-8?B?ZGxDc002YllDbnJtMEV3K01kVjlldzJpdTlUbzd0QXdGeTRKc1JLWWlQeTZz?=
 =?utf-8?B?ZVhCamhVaU1reTJXbmc4MmZPSEs5VXd5Mjg2TGhHWndOZ2ZQelJDOUFWd0ZL?=
 =?utf-8?B?T3B3bmVwaE5RaTg0N0pOQ2E4YnNBNitHN2doM1RqQVRCR1AzOVduVnF3SDhn?=
 =?utf-8?B?QzBGanRBVHRpU0dRdTNTc3ZyWENOMS9Zc0NITkh5bXUvTnFYZGpnTEpxQllY?=
 =?utf-8?B?dml6MjBKQ3JiMEloMkNYS2k1OHQrRjdhSDlpcGkyeEg1RE8wOS90cmR0OXhj?=
 =?utf-8?B?LytvSnlHUE16QkJES3hSUS9qcURpZmhXNHNseDZpUXRtbW1QT0JxQk55NVky?=
 =?utf-8?B?RjMwTFd0cTlLbWV2ZG9vVjBjRlBRM1VPY0pxbndEUnJwcVh5MEw5RmRhMWZx?=
 =?utf-8?B?elN3NlI1YXM5OGNGd3ZVeisxY1UyM0xCM0pmMndSTlJwSVBqVFVTTlI3THFE?=
 =?utf-8?B?ZnFDbWJmZUhlcE8rWC9VcElRMk02TWRjTFRwZzdrMU1UbHZRWnlxcHR3K0NG?=
 =?utf-8?B?WkpCeUFncEtrUGFxanJOdTVweDhrK1M0SnZCV3BxZ0ZHT2ZlbG1LdmRKVnFT?=
 =?utf-8?B?ZXhuKzJuck95RFVjTzNYU29UcTAzcXgvcXB2eUtiaTBTeFMrVlBKVm1NTklU?=
 =?utf-8?B?MmFZZUtMOU5qTmZjRUxIRWdKdEpwOHdjOURFN3ZFMXVLV1NHVEt4UHJESnVi?=
 =?utf-8?B?aFRDVHZqdEk2SHp6U0ZiOCt1cVpLZTBJVTR0S3FxbXlzNVBKUGhTOUIyemxl?=
 =?utf-8?B?blZUN1RNWWE4MlhWNVFSemsvMDZFaFFVeTQ3c2ZRemxRd3MxMmxLZDZLTTM1?=
 =?utf-8?B?anVtYXhLeHBlb09hUjA5NWhjdWgraEJQOXVwcGJnQ2MrL3VSSkREL1BZclE2?=
 =?utf-8?B?MU1CMmx2RXdtUk1xQ0t5aWFSVHl2WUUra0VLYlBwMTJraDZSZFNmMzVxaWt0?=
 =?utf-8?B?Ni8wN1dPc2IzaVJFODlMQktMT29vZE5hUGxpQThLa1lnMmdoN1VNUXhZQ3h1?=
 =?utf-8?B?TDZYOENYclBjYnZsbHZlUkZWeHlIbzFFWVpQRnZUNzl3SWEwVENjZWxUeGdo?=
 =?utf-8?B?NnFobnU1cFp0YnA4cFF1SE1DSUwrN2VxVXg3QjNkeURXWEZCNkYxU3NwVE11?=
 =?utf-8?B?djRNc203NU45L0VtUkxBeTFlK2xBUXE2d2g2Z011Lzl6cWE5VWhTcDJpQTZC?=
 =?utf-8?B?R0JKRS8rc2MrdzVFUHliQ29mOC9vZjhPTnp1YnhhNUpjeHZHRkwvTExHSmx4?=
 =?utf-8?B?MDNuK0dMVWw1d0swNGMxbW9aUkRJQW5wamFORGdlY0NaSGJ2Y3RUbklaREZU?=
 =?utf-8?B?eEd6WHpBNWFKd3ZnWitMZjh2Qmt4aThYb3l3Wk5CT1ZhZVJYdy90QTk0UHlx?=
 =?utf-8?Q?7OLnX3+v62/yLt6GQBOWeXGboxXPUM=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(36860700013)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2025 19:35:27.3601
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4409ee8b-e0fc-475b-b924-08dd671d33b1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF0000468E.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6231

On Wed, 19 Mar 2025 07:29:31 -0700, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.84 release.
> There are 166 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 21 Mar 2025 14:29:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.84-rc1.gz
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
    28 boots:	28 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.6.84-rc1-gd16a828e7b09
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
