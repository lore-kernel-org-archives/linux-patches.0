Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011071.outbound.protection.outlook.com [52.101.62.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B577278779
	for <patches@lists.linux.dev>; Wed, 17 Sep 2025 20:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758139716; cv=fail; b=m098qJXUKENnW4Y3xexbep7mM+VXDZsqvqUf59qB3w7ywkQytGuXf5dCneXaEbiYAdk0I2PEzuZPOvrbtAN+Mlywe2uxwl4eETiujaTPIkZdXOqPZyFA5bcsk/IjruxsHQ3V4YTe4XyuJPmNn8aEMclWByrclnPgPtpV+iAiQ0U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758139716; c=relaxed/simple;
	bh=1NDJejMN/EdupTkGF7onrNOlXOJQ2Sl5IxQd3b/J8aY=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=ea/oZWjrHMjg7wAsqG19r0ibFiCmM2FaJCP69hG65MK17E1ZlKMRlSJR9ztjqdkgjh306OLioqQpKy3hFHea/ncS56F4gHqtFEIGMMfd9SNaSwvgyHewYHL1K7Gef6d7Y2cd1TqWD5mxPZH7rj9CfnlfZtC0htI4HBMSUROkqfQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=G8E/21lB; arc=fail smtp.client-ip=52.101.62.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="G8E/21lB"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ImUuBw2YvcJBg/CFj7qT4kJzxe5KBR4Jt+S930Q1fQGOtP615tKSaD15VOaOYCzM2//5y4lZhRf80ElNvtsld7pugk+yhw0PiudJmjRAK0DP7Paa6ZB3HmolYSTPLiy0x5oclaXAr9gEFHgE+F8V1nqbyrWB3CatwanbIjpgz6jdU/RO921h60oHHOfz9nYWkD6aKu9RUYU47C3u5k0Ov8ITwfcm4CS383P66B2mxuwWPMqHkHdzSCd2x3VCYqe9LgKJ4kDL1T7vYsQnrhQYp2UgenzXQUnIiqz9nAKYrPKcAD/Ym0Y6wraca48Gs5yEncVUERmU9ZgS8E7DsyO1lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BScIGFHc73nflkgQgBKCmW38zOWz1zsUJ3E3ObEjo70=;
 b=YMH6NJW9VSsCN3/3oHhYtLYlDQF/cvrF4236DeIT4RjuWer35no570ooa8NsQnifC+6RR7ooMMeYbWwJjXPhavNi2gX5dByM8HKkPJWMffB9on71h0RzUJ0pghNtJVyfSbRK0BOPmR3jWgWUl4A1RfPTs7jkEd6i666CBxMAglC0nRsebo+YteMIUhbnUr5MCQtmJoMd+hBON9lRQ3h389QZrT8Eo0+vzvdBaaRG0490p5W1eMiJV7mgumlU4VwHRGRUkbRbvjPpC/Yvnj+5fyIx6Y1/XUU0+JzSue2Gl9+xVfYGbZLi4s8Fnfvm8Mepv5r9Q+I4OPnUTBXip3/mTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BScIGFHc73nflkgQgBKCmW38zOWz1zsUJ3E3ObEjo70=;
 b=G8E/21lBrn3qInLbQoVbN8Eu2TaYyUXRU+W/wloyvgGXDBjvj/qKcrt5VUAgKB7t6oWpVbPxYMigGRPLUeaifaBVhMYOKN/iBJ1IA00QklPjK90bx0SljW9+0xfriKquNYNJvm72fq09wVafxDAX7sblkZuuwStaEKuf5WRJV4R4cO/lYICCZQngEiBo9ixuNNrMLC6Dk79L4Z9GuNIdqiwRjOejI9sTVVMNxnqfrR2qzaYSW95QI22q91tEDbXt4bYqYVaRe3ZSZY7IxVEmpDfE8N/yzXwe0opF9yDgwtnXNbYOv+cqolypJDy5c0S6eKnZ7n+ozQfJ5PocKIPW5Q==
Received: from BY3PR03CA0030.namprd03.prod.outlook.com (2603:10b6:a03:39a::35)
 by CH1PR12MB9720.namprd12.prod.outlook.com (2603:10b6:610:2b2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.23; Wed, 17 Sep
 2025 20:08:31 +0000
Received: from SN1PEPF000397B0.namprd05.prod.outlook.com
 (2603:10b6:a03:39a:cafe::6b) by BY3PR03CA0030.outlook.office365.com
 (2603:10b6:a03:39a::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.13 via Frontend Transport; Wed,
 17 Sep 2025 20:08:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SN1PEPF000397B0.mail.protection.outlook.com (10.167.248.54) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.12 via Frontend Transport; Wed, 17 Sep 2025 20:08:30 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 17 Sep
 2025 13:08:06 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 17 Sep
 2025 13:08:06 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 17 Sep 2025 13:08:06 -0700
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
	<rwarsow@gmx.de>, <conor@kernel.org>, <hargar@microsoft.com>,
	<broonie@kernel.org>, <achill@achill.org>, <linux-tegra@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH 6.1 00/78] 6.1.153-rc1 review
In-Reply-To: <20250917123329.576087662@linuxfoundation.org>
References: <20250917123329.576087662@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <85f0b77a-d651-4ec6-a20d-342793cdcc73@rnnvmail204.nvidia.com>
Date: Wed, 17 Sep 2025 13:08:06 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000397B0:EE_|CH1PR12MB9720:EE_
X-MS-Office365-Filtering-Correlation-Id: 57bb2f15-a4a0-4502-3687-08ddf625f8e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WVpLZzlnaU16c0lRQVhIcGpIWGhxSXZsSGdXV1oyRFU2SGl5TkpUSjdySmht?=
 =?utf-8?B?ZFpNY2ExckhkckpuaHpVc3lBSzdkdGlhbnllWlNsaFJqb1lUZzhIVkNaN3lY?=
 =?utf-8?B?ZjN1Z3JsTGhiUDN5YWdwMWlpbzdqU0oxeW1ua0lZbkZ3K2xhK016KzJlVysy?=
 =?utf-8?B?MEZQSEpkVUVadUhraE5PWDNDb00vWWtHT0lVNCtJN0xObjlTeWhhMk9paTJp?=
 =?utf-8?B?c3BhcmxnK09Yc2s4MzJMTGE5NVk3Z0JnemFqTmdWZFZUNVFLeW9BT25PZTI0?=
 =?utf-8?B?clBtbTdQTy9wR3ZpVkk0cWFyOXJwM0l6ZXVZWFl5ZGdHUkFxYm5DdnJCL3Mw?=
 =?utf-8?B?K3ZibG5vMkxZNDJlbk0vMkR4d3FGeWZKQVdNdU90ZG9rN0ViUGdTblRXVCtr?=
 =?utf-8?B?c0J6b0NZRTRibzJqaG0rUnpoUWZ6SjFrODFsemRxOElJd3MzK2hWUW1mRHRq?=
 =?utf-8?B?bTBqZmVCejl4VWZSWkVaOTcyVnpTeHdvbEhYN25OcnBDbDZwRGdRVHlWUHhy?=
 =?utf-8?B?N3oyN0NoMEFMVWNzWDV0OHEzYlhDaHRLU2p3ZDh3SE9kWWlQL0NRNmNIR2k2?=
 =?utf-8?B?b1BycjVBaFNnLy9TUmVKa0pJM1FleEkyRWY3VGtXT1pNblZ4eG9Wb0ZMYkpo?=
 =?utf-8?B?RUhqYjE4UEI1dGZZVnd1blR6UVhyYU5TaTVwcWpNbEY1SUxyd2RRVUdUQXNX?=
 =?utf-8?B?N2hWVE1hbVhaS2t3V1gya0VNeldNZVpid3V6VVpxY0pzVnFrNjN4UE81dm1Q?=
 =?utf-8?B?ekdBRjcyd1REWTdRaHZPT1Bsb1dYN3lkcHQzSnlZc1cwRlZBTWtOb3RHdVVD?=
 =?utf-8?B?MkpIektDaldKTWU2SnVQWUZycmVzRlA1YUdkajdXWFBzS21ITDZoMVQ1a3ZK?=
 =?utf-8?B?RktKOEVMTjB6eUFoa1pBQzc5RllQNHM0WnlPa05vb2o4R1ZWRWpkRkpuZVJU?=
 =?utf-8?B?SFZlRGNHTzViWVFJQnU5TklTYmp2T0JCTys5MVJybHZFTE1JRUd3R1JPcGw4?=
 =?utf-8?B?Mjh3blh2YUdoR2l0bFZvNmhqdnp5dHNRUWhBL2VXc2l3NmlqQWV1VUIrMDF3?=
 =?utf-8?B?VkFBSWxhVmtlbDlMU0hpV2Jac3RIOHhUWUdQd28ySFhVR0x3dndBN1JvUE1H?=
 =?utf-8?B?NjdLeEg3cFoyU3ZHaVF6dDNwMTM5cUQrTHZjSUFwZGljeVRjRVo4RFlJOVlo?=
 =?utf-8?B?RnpLWGxoY1haK2ZSNHJtMktnRnZLVEdtLzM5TExOSUdOWlBTMXIwd2FOQkpj?=
 =?utf-8?B?QUhGUm8zeTQ3NXZZdUZ3ZmJ2WUtMSDhYSFRJN00xWEExU1JBWGR2b0FsZ3JU?=
 =?utf-8?B?RWZSYWxBQXRhYVlmTEVlL0NMV2hRc2NOZE40UWYzOHZPVWxwdG1ORDk1bVlJ?=
 =?utf-8?B?R3JIY2t4OEM1UTh2SjRxVjZDYkJaS1E3bGFNeWZIVi9idmNnODdidXdIUGwv?=
 =?utf-8?B?QkE5dWhXQTNBSHgvS1VKSkRtQTlaS2svYW9xM21KLzdRSllIV0lURFE2OFZW?=
 =?utf-8?B?bjZiRnZMUnJHS21xNi9EQStpblNDa1NCcjdUMEZXOXJ0MGxQOGVnSnV4SEdt?=
 =?utf-8?B?YUNZMnRreW1DNVkxZTdPcTJFVGR1NlF4SlpSVUc3VTlnam1PdEk5WFczRjFK?=
 =?utf-8?B?dU13dFd2SzJkQVl6a1lKQVV4ZHRScjlYZ0JTVk16dnprN0EvcDZQWFJsQW50?=
 =?utf-8?B?bHpvMGlhN2Q2U1Fmb1hiUGFmdnhvU1RENHFVajlLZUYyY2NXRG5vL0xwZ0tB?=
 =?utf-8?B?WXBIV3Bpem9NdnZnbkYwYVVWSU5oSzlrazV0MVRyaFM5V2NCK2wrNzVPejd1?=
 =?utf-8?B?UEw5L0pGc1NaaUx6a21ZNzdrM2ZMSTZvSEFSa0hWcFBTM0VrdnNpMGJWdlZZ?=
 =?utf-8?B?djVDSExWcXlGbkl5YUJyS1lwQzg5TCsrQjNWNTZFTDA1NlZWcXA3d3kzeWpL?=
 =?utf-8?B?MU5rV3ArSTlBZWJqMGFJTWNleUtKZ25xL2lndjBxenhPbVNXcEdFUnc0eWVw?=
 =?utf-8?B?UXI5bTFzalJBUGlxOElXOTkrVE9DaXRnL1JVNWQ0ZjhIZVZLbUdWQ3ZaRXhR?=
 =?utf-8?B?RXJKWmNJOFVFVmRlcG1YTFNCM3BrdVNWcUYwUT09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2025 20:08:30.4907
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 57bb2f15-a4a0-4502-3687-08ddf625f8e4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000397B0.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PR12MB9720

On Wed, 17 Sep 2025 14:34:21 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.153 release.
> There are 78 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 19 Sep 2025 12:32:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.153-rc1.gz
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

Linux version:	6.1.153-rc1-gb31770c84f52
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
