Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2056.outbound.protection.outlook.com [40.107.236.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1B8221858D
	for <patches@lists.linux.dev>; Thu, 27 Mar 2025 14:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743085979; cv=fail; b=ZvZT4kXyQlGu0BlrZp3oWxKU8jhrjCH5/RvCM+PE5aj23u8S+QKjp6zCzOTlZ6fQMxBdcVXZlFxqH3XPG9Fx1Aw/hCIIAMi7/ikF7TfbAt9KuKjWxId2fnDgQRvZHIA5CY/81TuYyWu5gcXv5pjy83U77xvUZO3MkBteibDw0VQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743085979; c=relaxed/simple;
	bh=brIzTXXdb1piVaDOWOLlS0jzgxbeDv40GWsQsh5VTyA=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=BP4EPLdV/xXHm7FknuINLvTDIiflI5mkeukIuJ7B5rUzvKKLMBJPXCkwf0GY5j9BT0+13vVo2jbWf/k06HH60qD+PtCHtoec6OjxMasB+FfkKaBpWd62Ig6RdkkPycgF4qaExxuqxUTHvve7IcqKMbK7w/YTHkzLoxzbirTqJAI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=k/no/Wvl; arc=fail smtp.client-ip=40.107.236.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="k/no/Wvl"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m7kwfYayWol4lqKHW/vH7LmhcGne1fOwszhpXPjq2xIFnipSYHpnBU96YJXm/qj8+z1Pefud6NzJiS9hiwjY7ejccM813FlVLEQJBzn0X8yniBUjERSTUsas8xv1mj+zIO1t7LztUoiMOCL2ScpJB6kzHVDLVAPmoK+hJ0Qn9cQa1nqY33z6xwFu2B7zU9H8XeurCUXMIAMhGYKCOf+m7xiYbPmIfmwvw833zkY8uVUiPYeRYXVulJa4Yp8nMtr0Ey1qSvqvrXslGrZXEEx18tDHV1+VteBBOtn4LgvhXRiXJukeI2PFlSJXxCE86EBnbLHtZUp6IFQ/lcKRE+o4+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LJ2X9Zlrv0bYG+gJW4rd4s4iMWjWmWm0w/5Z1KVQvp4=;
 b=oXX5NaYTQnR8oPfBkzJjmdlba6qqeKHjwq5Tp4EF2gkaiIjWX9arXLez52auNKn9RpGmkwHvpmoTl8hucjjLmHJy8wVYHvI788TZJwx6u3VooAtRFr9okihFctapTSyTk0sK4edqRxbFp1SM4GYN3P6DlCKeW4+kn9O9KG1DnsapDfKnewEy8tQOm+nyH+zqH5XK7RBLV1NT66q87zADaDL7akbH0JjS4Q0lESoRpH0sOEDVU7ryD65kCJjzjC/zk/btSXURjBtBqdF3AU840K/MyIolYxLKTdoPjDUtBUzHb0YQBGmtcuIjNPq8pWvL+qL79xGQhzIPTN6udr261Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LJ2X9Zlrv0bYG+gJW4rd4s4iMWjWmWm0w/5Z1KVQvp4=;
 b=k/no/Wvl8nAKImrP6czlp8gDW8Pemb9cvcR3HQ+nhpXkLPwJOU9GEZ/AyRFyLN7QaFuT6m5KmSszH5HWtmavZ+5BuwZdIWtdQTbndPwD4Ij27hZPGAB40Nu0J5d559GKG0gDbxClRjlakQllIM0c7O/CexI6p3YVwDPRzsOxAjPW+5mNYm+xg6Vib8WEkMtQzO/j6YcUzMTLS+GCZ3aApv33AV1dS8n1CRxWskhiqOTq2NV3oiKJ3s8uCDUIjTAUgj1b3Q4T2WuVLaq81mqLX/vU3nLG4KXwjjDfuaFiWNNh7JlPUiNnVehrAgcgNIR1v31tl8wz4aKPloqNSAsqmA==
Received: from MN0PR04CA0012.namprd04.prod.outlook.com (2603:10b6:208:52d::31)
 by DS0PR12MB9039.namprd12.prod.outlook.com (2603:10b6:8:de::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Thu, 27 Mar
 2025 14:32:53 +0000
Received: from BL02EPF0002992B.namprd02.prod.outlook.com
 (2603:10b6:208:52d:cafe::81) by MN0PR04CA0012.outlook.office365.com
 (2603:10b6:208:52d::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8534.44 via Frontend Transport; Thu,
 27 Mar 2025 14:32:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BL02EPF0002992B.mail.protection.outlook.com (10.167.249.56) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8534.20 via Frontend Transport; Thu, 27 Mar 2025 14:32:52 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 27 Mar
 2025 07:32:44 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 27 Mar 2025 07:32:44 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Thu, 27 Mar 2025 07:32:44 -0700
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
Subject: Re: [PATCH 6.1 000/197] 6.1.132-rc2 review
In-Reply-To: <20250326154349.272647840@linuxfoundation.org>
References: <20250326154349.272647840@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <b93abaf4-1dd5-42be-afa3-539172fbdd77@drhqmail202.nvidia.com>
Date: Thu, 27 Mar 2025 07:32:44 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0002992B:EE_|DS0PR12MB9039:EE_
X-MS-Office365-Filtering-Correlation-Id: 510e7562-6401-4d22-d2e8-08dd6d3c41e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SC95UnMzdnhFdUd3c2ZkSmtzZFpCTjlkdXQ4NXhlZ04yVklIRXRzY2dUK2VY?=
 =?utf-8?B?Y1JzemdoUWk5My83TVA1d2pxRGRoMHBwWVBoQklUVHY2VXhHbEZrQkE2UXhG?=
 =?utf-8?B?YThDWkhxWXo2NGd0QUlISFJMZkptYTc5U1lFaUlyWjMra09rR2RtdDVwdU5R?=
 =?utf-8?B?Umh3N3c1TmpTOEF4a2xVTGRGU3lRTmVlZXdWamorUmVkd1NDNVoxSHM0NFlL?=
 =?utf-8?B?LzdKRWZKd2VKVUtGZVFGVWNYMGlOVXZhNjhiNzh5aURnWTNHSXQ3WTM3ZzVh?=
 =?utf-8?B?bGR3MjFNdS9GWVR5SHZ5TWs4SXRQU2RGMkhUaDd3QWFZaUsvY3lwMWVVYktX?=
 =?utf-8?B?T1RvTDZGWG1ma3JvV1NwalozM1d4L0JYRCtBY2tyTFZERTFkZlZLbGZ3Zi9N?=
 =?utf-8?B?T0hIUTE5WkxuQ2xFUmpwNGd3ZzhBUzBrVDM0RUpLZjRNZGtWTXFXUWZhSHlH?=
 =?utf-8?B?UkRSM0o2Y2dYckZrT0hDNzI2cmszOXY1Y2g0b0RyVDh4YWNVQVpuR1puVm9r?=
 =?utf-8?B?ekM0SWxXWU9sK0gvamVwVnBSZHdNY2tDbjlydFBZdjJzeHpBU3RUdGZuWTJs?=
 =?utf-8?B?VzBubno3blI5Y2hvLzI2UnlieUY3SFREZTR4WWZJL0ExS1dlWUNTRDhEN0sw?=
 =?utf-8?B?UzY2akFvcjlaNzhBQnNEV1BmS0taeFZiVzIrRkJTSHRGdStYMHpIRWExZWZQ?=
 =?utf-8?B?R3EyZVdKdGNXLzNKVUdGNFJ4RmsyZ1lsZFQ4UmVpVEhqY1hQRUlxc3RRc0NE?=
 =?utf-8?B?Y1dNN2dPT203dVg0ZHJTZTlzT0VOY1NkNnRpeTJsN0RnUC9kMHJtUmt6ZGds?=
 =?utf-8?B?Z295dnR2dkRndS9DeGNyUGFXVE1BUUt5ZmkzYUdDQkhnQ1cxa0NYMVBwcFJV?=
 =?utf-8?B?U0lvNkRTSzJJSEVET0J0OWRKUitTeEVJRnlxN25xZzVSTW1uSHVDYTJnZ1Nx?=
 =?utf-8?B?anNmZ1RzYkNKeHdSelhWRE52bjRCNFFuaUtqYmhsTWJKZkN6T2FaZW1BenBU?=
 =?utf-8?B?SjFrRDQzbW9rVkVsdWY4THhRUjZsYjdDdjBzaTNrQVBqZGJ4Yk8wcStwRVhw?=
 =?utf-8?B?Q1E1MURZWEdGa3JmRnArbW1mRGYxb3lieEMyQTdhanFjSjlaOVhkTjJ1aVFz?=
 =?utf-8?B?TEZ2M1VndHFhdmtlemIrZXZsNkVpeVQydU82MnM3TjNWbWxSNlNWYjBFVWJw?=
 =?utf-8?B?K2VkWDhveWFOVkdsVWllbkx3My93Z2NNMTBkaWFTekhkTGU4SEYycXFQRG5z?=
 =?utf-8?B?RGtGcmltNHJIbnl5b3lwK2lMY2d0RHpMUVlHUkt5Q0VaRW5DQVBGckpTZ3Bt?=
 =?utf-8?B?SnB4SXRRYUpJYkZiVkRPM3ZuV2lVbjBmdTVlelQ5eTNPcVAwVEV4YWZzQ2tv?=
 =?utf-8?B?bU4zS3JiUWZ5ZUdHMzBnR3RKTmtCRGZmOHp2Qk9wdFNyeVRlNzFHZGlhejVH?=
 =?utf-8?B?UlladlhxZXZ5T0pJZG1sbGo3OHR2RTd0enJEQktqdG1xdzg2UGZKblVwTHlx?=
 =?utf-8?B?b0JmQUdxZGV4dTVPVmJ3S2E1NXNmZUhkWWhoRFhnNC9qaDdPZC9nV1J5WU9Q?=
 =?utf-8?B?SmR2dHVFVXJOYis0TFFEa2JMY2FCUHp0a2FhcUpKcWd5SUs0U2pON3d1cGth?=
 =?utf-8?B?RzZVS25ZWmttYW0wRG1tUnNiRlBxWlRwdW9kM3lkT2dibTRBcWMxRHd5WnRu?=
 =?utf-8?B?RUNQYjlHeGF6S0ZaM0hmbXFWQitBZW42SkhmR0N4eTg1VmFLT3lhWXllR1My?=
 =?utf-8?B?QnpQTHZ5c295em1UdWd0Y0g2S0VhT092VCs3OFovN2NYRUNhTTBXcnFvc3Er?=
 =?utf-8?B?RVBsb0hDM1hQVVYxT3RFQ3pjc0FNbk9yS09sYlByYUt4bm9GdDB5MVZITzRU?=
 =?utf-8?B?UWt3b04yYXkwSXNVS1VwMExDNU1SWXhuL0VlT0s5S3pRcEJqRkVqZE5UK0Zk?=
 =?utf-8?B?ZFhvK1FaSFNGRTJTbHJNWWY5ejNRdGllN1p6c2N0L0c1QVQrbDl6WE9iYi84?=
 =?utf-8?Q?wZmz+ooBHS1FrNjLXK84E80LbT62Hc=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2025 14:32:52.6067
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 510e7562-6401-4d22-d2e8-08dd6d3c41e9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0002992B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9039

On Wed, 26 Mar 2025 11:44:27 -0400, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.132 release.
> There are 197 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 28 Mar 2025 15:43:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.132-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Failures detected for Tegra ...

Test results for stable-v6.1:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    115 tests:	109 pass, 6 fail

Linux version:	6.1.132-rc2-gf5ad54ef021f
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Test failures:	tegra186-p2771-0000: cpu-hotplug
                tegra194-p2972-0000: pm-system-suspend.sh
                tegra210-p2371-2180: cpu-hotplug
                tegra210-p3450-0000: cpu-hotplug


Jon
