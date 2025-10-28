Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010058.outbound.protection.outlook.com [52.101.193.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E1C30C363
	for <patches@lists.linux.dev>; Tue, 28 Oct 2025 11:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761650955; cv=fail; b=XD8rOqtOWIVyxnwkbo4dpr0DTz6soUFlvwAPzCQ47eDTlFY2AOWWtETlq7cDVYTSwPUw3TgNQs+9VjEHUA+b+B8TXZrQCHWZN5TRwc9OATNF4lo0XSEpriospF3Hkg20kuQeUfzvbR68Es13bzLEBBN37p2xazQPCYpQtSI7cdg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761650955; c=relaxed/simple;
	bh=5naYLSXV3eYu5ECd0SBlOmoTEJjsblXdnhWEO3RgC+U=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=W7NHR0eKnBufrz68twlQ1AyIYb51m5QJzErHRAem5a42N2vbVO9BAYuFZqhhp8fgloWWgqJapsLMYwTeEf5oTkHhuyengE61mcUkQphQwt6UgxyLc2d4XtINOTR7L+WKF+i/jRSeHssg2NKZJMwvshgPIarS6UgmBrq/qyvWuH4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=M4TaSHk9; arc=fail smtp.client-ip=52.101.193.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="M4TaSHk9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qzi6AaHfa9sYyLDnkj+n1S3uD8/69A0y8DsBXgdrYm8BWc0IsShVLM+YM412mXHRcT7S1WsYVZ3wTs2JFC6emA3VodT0Jk7qXmdsYqTHk6a6Hi5Lu7scpPEQZ1/RvxT9yL0J56zuDF77jBGmk3t3oWoj5YRQlCSZXn2B63OZnD+vn8X6LI70UB9JSab8O4E6ojeszZB6nNcKWJKy+G0vi6xFm9aA9vCEJaLas5yu00/8RVOFQhgNgE9uz7xpBnyckjcpDhbxfWpam6QebbYeVo/3tdv3+HYrqXa8qDOAMg60Vu6fBFqTBvbbmc7xHgr3CYwvJTs6Pa8fwpwVSMG6bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p9alndM8DXGTrE3US5wZpweEQIe4xPaqEKBVfrbz4wU=;
 b=iD3FOJiAmc31A7RpiMtJhqh1UPVMAq16fJJKn/V4c6miE9VhLcn8J5+Ap4jYhRJZe+cPNkZmL5Di7TZFCDDo139AgGPXKHHJHDj4pp8WFfW5X/bwMsCa82AVmMOyXOoWzEnoAylPKzUVU/AnyeLUHS1XjruDyCyjWLgUe1U7mHEbp/QaNcfqm0vcy7e9WWL6xNOYVkbOEUq8raCfn35E3KrdlbYfzQ+8YKVoZ8KngXB0gp2mKkagO8bQHSMd5PyPoSaml7XXjMHbPoEjP+jpRYwH9amGcgc0jLOLjCsxlu5fF0zb3LjukZmz/GKch9kI2wpLj3w1NE1jYTiKuOubZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p9alndM8DXGTrE3US5wZpweEQIe4xPaqEKBVfrbz4wU=;
 b=M4TaSHk9gBTUBgO84qMOAFGFEygz5SArZw2rDDj0tRnqgpEOtEWymNbm9zW/GlK+v66unnCeHvl597uNNCaUzW+Bp6nzGsUPE8I73sSuQlSXRvkKi94APsFkjcZF/CQlPhtCgb6/PRc58uZnefP8Ndj6zEkqFRJXNuUr1Pak0fKkQ+xQO9MtvQNBsnNLeoRq+uq1imBKr+huD7RFV3eKIsGV8j6TBLi+TaAC5Tlk5LpJVSh0f5fg/zzctq1NYJmr6G8gbAEYrVGHpJqmb0X+MU3LWHWzbixlpyRM1VgGFGM3I2pXfkED0c2RETmeUD9pUcXcAse5Rj8uPR/A7myHUg==
Received: from MW4P222CA0023.NAMP222.PROD.OUTLOOK.COM (2603:10b6:303:114::28)
 by DS0PR12MB6487.namprd12.prod.outlook.com (2603:10b6:8:c4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.17; Tue, 28 Oct
 2025 11:29:08 +0000
Received: from SJ5PEPF000001C8.namprd05.prod.outlook.com
 (2603:10b6:303:114:cafe::3f) by MW4P222CA0023.outlook.office365.com
 (2603:10b6:303:114::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9253.18 via Frontend Transport; Tue,
 28 Oct 2025 11:29:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ5PEPF000001C8.mail.protection.outlook.com (10.167.242.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9275.10 via Frontend Transport; Tue, 28 Oct 2025 11:29:07 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Tue, 28 Oct
 2025 04:28:53 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 28 Oct
 2025 04:28:52 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 28 Oct 2025 04:28:52 -0700
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <rwarsow@gmx.de>,
	<conor@kernel.org>, <hargar@microsoft.com>, <broonie@kernel.org>,
	<achill@achill.org>, <sr@sladewatkins.com>, <linux-tegra@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH 6.1 000/157] 6.1.158-rc1 review
In-Reply-To: <20251027183501.227243846@linuxfoundation.org>
References: <20251027183501.227243846@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <3264777f-8822-49ed-8bd9-6fe8961aeef1@rnnvmail203.nvidia.com>
Date: Tue, 28 Oct 2025 04:28:52 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001C8:EE_|DS0PR12MB6487:EE_
X-MS-Office365-Filtering-Correlation-Id: d5d83f7a-95ca-4525-85be-08de1615355b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OFdQR3RMZU1zb0ZwcGhCVEF0QkRGNnlkYlJLbytTMEVZVkdHcjRlTkNMaHJT?=
 =?utf-8?B?S09aQmxzNU56cEdWbUxKWHNTNHY5czFLNWg2SmlMc2tZSmtVYUNISnFIOHRG?=
 =?utf-8?B?Y3paTWovQWFQbm1iOVlUeE9nQUZnQWhHSjRvSVlCMFhnaHFINXQxUFBqb0cv?=
 =?utf-8?B?dG5ZbXZVNnNoSm1tbkFhYXVZMWxGVWpmMVJhNjZMS2dpam9WSXJ4TmY3Y2d6?=
 =?utf-8?B?L2Znd2dNVEhSRWp5QWEzTGtxWk9xQ1hIUHRBa2sraU9SbnJ1RmpsT1UvbjFl?=
 =?utf-8?B?OU8zNHF5ZnZwNTRNM0w5b1Q4R2tGSXNPSDVqeEpIZkF1ODZZVTBEeVYvMGtk?=
 =?utf-8?B?ZDcrMmk1ZkJwMUtHYVJ6SE9qMXc4UGt6YWRsUlJhUFFtNW1ZTWhJVUF4WkMz?=
 =?utf-8?B?dm9WWFFMUkJUVFBpOFo3RW5KVm0yUU1GSDhnNnBHL0NWalBCampkSFZ2c3Ux?=
 =?utf-8?B?a2c4clU0d29XbGlhZzhkT1RMTDNPNm02LytEYnNGOG5Qbjk1V2JPb0k3dDFa?=
 =?utf-8?B?SFMvZTFpQXJyZkdDQi8vb3EvK014MnhEWmVMZk15aDBadGNyMDNFS0YxOWhP?=
 =?utf-8?B?bE0zTVgxVXdmZ1NNalBxQ1NicWl1anE2WE5pakNsY3FHNnF0cGV4ZVdrQ3RE?=
 =?utf-8?B?aG1Tdlp3RDJld29rMkZKaW1YMVRXY0cxUDE4clpmbDVnNHBTNFphZ25HY0Zq?=
 =?utf-8?B?bk84Q1hHUUtURHY4cituRzdJOGdLS2hWaEFmVmh6NjR1ZHNCYTFDYkVjQjk1?=
 =?utf-8?B?WGV5cEQwUzhlZG9CaERsRE1Oa2hlRnBaVmJjUk9TcEhkU0dHejRGY1d0SEhs?=
 =?utf-8?B?NGU5UkJsUWVOY3BPdnd0dlNMRnVOVzhINGsyMFBXZXAzRjJQZllnMFBqRnla?=
 =?utf-8?B?VWszZk8wMGdhS2ZKVTQ5UkhhMzA2Yk0xYnRtRzBETHJPY0ZJV1Roc1VCekRi?=
 =?utf-8?B?aEl1ejM4K001VmRKSDVPUU1MWXk0SWdXazI4RmtwMTVpekRRbHBWRjZjQVBD?=
 =?utf-8?B?QlZQR2J6U0dPVHJtNEtGMHhUSzQ4RGl0Y2wxSGlMZmc1cThkNnRoYXo3bUFp?=
 =?utf-8?B?eDVlN24wYTE4K0syQ1VTSjNGbERDTmdrdXgwOWptN3BnQjNYS0R0dlFCakhT?=
 =?utf-8?B?VFExNGVicDkxblFlSHM1NXIrNlM1V2ROWGIyaTF0VGVPWGkyTVBreTRzRGV3?=
 =?utf-8?B?UUw2ZGRoQmlmQTJmRnZJUWMwWVRBMHR4RWgrQ3FJN29xaHMwWGxETlUyR0d2?=
 =?utf-8?B?UHdsTnJzRk1pVVlHdGlXQ0J0NXMwaE5TUmRxNkNpSnMxNjdRV0J2dzBJNDVJ?=
 =?utf-8?B?cXYxU0R4VlBQUGJBTTZTN3hWZFBlSVNiNytQTUJSWnpDOFpiK2tsWTl2V3o3?=
 =?utf-8?B?MFdqdzIrV2pZZTZicHdkNk1KLzQ5OGZRdUpLQWFabE1IQys5MVRVdDJCd2hl?=
 =?utf-8?B?VW00NHlTY2xFOU5jTXRpODQxY216OWhxUXZHbDg0MlRUZGRIUWpOVEw0R0tT?=
 =?utf-8?B?MUdzVmdpckNPTFcydWpxOHBwcG9HVmRZd2c1dmd3VThFY3hvNUtaOWlsc0dX?=
 =?utf-8?B?VDdkWDZMdkw0VEpmdFhqVisyMGZpT0FuS1lyVEx0bjU4aUw4UU5IU1laUFE5?=
 =?utf-8?B?VWtDcTlPdWVURXR3WnRUdFRpSmR6akVQbHhTQUhTS3BRSWt4dmRlTGRZS1pw?=
 =?utf-8?B?ZkJycGM3ckJrK1JlZlMyQVJBVGFGd3VMK0xnRnFNSUFFK1lvdWgzZUYvU3A0?=
 =?utf-8?B?MUJBckUvOGlXcVVFNGtXOFozbGZuYUdvSkZac2l6YlJFZ29vSzlDd1hZRkdw?=
 =?utf-8?B?SnFEa2VmRzF5NlQyMGFWYnBsejhmUHhyNGZXZ1YvUGdKNGR3RVg5NnphYnJj?=
 =?utf-8?B?T1A0VmYyVHhRWmRoN1hNQ3JXR3RhQ3FRSjJrelNXUUZ6VHJHSGsvUWo4Slhl?=
 =?utf-8?B?Q1RKTXJXVFcvc1ZRWU54Vm5tQzlEUkZtUzczcFhDZS9xSmlsSGNjK3ljeTB5?=
 =?utf-8?B?VVJnMVBEbE1oc1JBWVRSeUFNNzgwL254OVY5TFFrUzI5K001dS9wTDZDbXo3?=
 =?utf-8?B?Qi9td2JMNUhmVkNKWkhXU1dYTmg3M0lKM2E1eVd5cEk2eVVUWkFQSUk4R2hL?=
 =?utf-8?Q?eh5o=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2025 11:29:07.8121
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d5d83f7a-95ca-4525-85be-08de1615355b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001C8.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6487

On Mon, 27 Oct 2025 19:34:21 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.158 release.
> There are 157 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Oct 2025 18:34:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.158-rc1.gz
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

Linux version:	6.1.158-rc1-gf6fcaf2c6b7f
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
