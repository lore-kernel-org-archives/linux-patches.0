Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2041.outbound.protection.outlook.com [40.107.92.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07ABA84FAD
	for <patches@lists.linux.dev>; Thu, 18 Jul 2024 09:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721296300; cv=fail; b=kBytsDSHVJVgPLqkALVe3kxlqg7G0Fm0zGPL9ow7zKvVu8iez3C0KrFkoro+O3MXD4vCuFMRe0YLj6h7ULl04rZtHyRGTpFDTwtcmPfwc8+/VhzX4NFkcHFINRZHyI47HSu0HeC4cl7AMgoTcYBXQ4vgSN32NnmKcI3if5oBPZI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721296300; c=relaxed/simple;
	bh=V2wmEk5sTTj/qOR9viIGN99qZ10BzQSlD7qz5LxPLe0=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=Am0jZK/DcwstTlrdb7KFyOgzTjpU6IicsQTWRv/d0dvjVgST4WwlvrsnThVYGQd/ro1EpIUAJ37Q8qRPWOBJmKjHYupyeqfdeSE10vVYK/3GCYn707LFHWOySJiY/W9oG38vUydNhnye29+lc1Dt6vQtg3R/kf0fiXzKTepJlew=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=rtOzOvSr; arc=fail smtp.client-ip=40.107.92.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="rtOzOvSr"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I7KQZm1pRX1gSJpuByA1Nd32iz0aD2KuNK6YQm/7toTBj6XQt+ZzOwtlmMUqa7zVf8PmjwHaLdOhBYdI4BEO5MK9OVMsqY9eWNiPAhbs6lCdeX1VL/XVndIXWRrCbOI+JnR8ZV1/AR4Q7h+C/yjn5rtpTAafW0Y+sKdnMOvzdh82oGti3HYx/Y5kYJ0OkXbKR7J+coppAzzbOavl/CTfP/zpvqw7CMGOZNuzbebRTNCfz5CQYkt3JACN5icMZ0bUrzH/DgZ34UGh+EODh4w8/CzjtGQ0EuLU1wqb0RAjETwBXyjs1plX8ciBtS1f5NpLVJ0mzTQZkMT8noTg8Kkf2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EHvYqt/mBFOKl481xqz7tMksv6Vayt/OaW2xD8F0Q9A=;
 b=knpWSyisnvaSh1JtopKoe0TYfJCk1/2fGufnViBgzV2b6D61WamX15JOtTSUeztSo+G/e281KyL/ev9f8RK0YShg7T0d/YXSME7YLi6oauZXUwvkVLUZEY+Pq/ns10DWXroZEmf+YU6i8OXhaYdoAPdPs23N95oke0BQvzs+PQURT0fWXY3tOIlk6SqVv6kB0r6o3CimjMMHU9gr1yWEJm47FEcXeBKKiHfSUpYukV6KFs8JLNFjUAcn905Gu7BQuZnnY5A9ZDwKclVDu4boWtwlgWKi1QIxDLhWAn0UWkU1fee7XZ+rV10G2HI4NAj9WJKqGpyeGw5QaYcRsPsivg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EHvYqt/mBFOKl481xqz7tMksv6Vayt/OaW2xD8F0Q9A=;
 b=rtOzOvSrBwzZHcT5OtFCb3BHI217zjlGW0JayQO+YjDQxSDWKgNKGxmTN+PSx9lrQm/2rifvlikplXcr9c64UEPsAMuhb/9WsBYl/fM172sstZK3F1WppUvHfY21xV+KtuTkT1D3KU4I8/LjAINHN5/A4hIsUpRn4vP3wy31W03oqxcnMZGdlKPcbj4cl0dTfRSwahJWGfJC1mWeYCslYKRtoFjIIfozvsFaU6ok9uupuTe7LAHlQNYQrr/WctdVe554EtJ6HsrOYteZK1JvjEd6/w2TfaWOA/OQ4/sOTYPzyGlL8ypUYEGcpLXqQea6UxZAw7qoBzz3VURXugSa+A==
Received: from DM5PR07CA0095.namprd07.prod.outlook.com (2603:10b6:4:ae::24) by
 PH8PR12MB7302.namprd12.prod.outlook.com (2603:10b6:510:221::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.14; Thu, 18 Jul
 2024 09:51:35 +0000
Received: from CY4PEPF0000FCC5.namprd03.prod.outlook.com
 (2603:10b6:4:ae:cafe::82) by DM5PR07CA0095.outlook.office365.com
 (2603:10b6:4:ae::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.28 via Frontend
 Transport; Thu, 18 Jul 2024 09:51:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CY4PEPF0000FCC5.mail.protection.outlook.com (10.167.242.107) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7784.11 via Frontend Transport; Thu, 18 Jul 2024 09:51:34 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 18 Jul
 2024 02:51:14 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Thu, 18 Jul 2024 02:51:14 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Thu, 18 Jul 2024 02:51:14 -0700
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
Subject: Re: [PATCH 4.19 00/66] 4.19.318-rc3 review
In-Reply-To: <20240717101028.579732070@linuxfoundation.org>
References: <20240717101028.579732070@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <b04f4a22-d40d-4824-ae6c-407b251194ca@drhqmail202.nvidia.com>
Date: Thu, 18 Jul 2024 02:51:14 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC5:EE_|PH8PR12MB7302:EE_
X-MS-Office365-Filtering-Correlation-Id: 96fd0012-3906-4094-47e7-08dca70f3578
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bkt2T0FMQ0JmQjJBTFJkZW5SWDdsbXhvaEdYOTRCdDhhV1ZESDRCb2FzT1Vy?=
 =?utf-8?B?MEEwMjE3Z3orVThZdndtNjNwcEpYOGV4V0VKUERMT2RaZjN4MkhZNlBjODF4?=
 =?utf-8?B?eElmcFZyOHhScDhQNllmdXpYeW05NStaVW9iSTgrVDZrbGJNNFVDYTlaQ2kr?=
 =?utf-8?B?WXkvbC82UmpTV2J6bnJIYy9wQnVxWEdta2RORzNTYjZxeUdTeE5CN2FkZm5P?=
 =?utf-8?B?TlJiZkRDQXg1Y21oNjFPZjRVNjUyNDVVWjFBK0xvMlVpaE8rUDJoaHlTU1JJ?=
 =?utf-8?B?bmJiWldoSmc4L1hWWElmZnMybURzaTlxZ1lwRWtHQW8wZVU4b2NzYjN2akND?=
 =?utf-8?B?RGpqd2lzSjUvQXZUcEExWmZZWER5SEpEVEhkNWJ0RFU5cjFmM2xmRGF4czli?=
 =?utf-8?B?UDF6ckVxVm9ocjlob3hiZUMvNGFNRGI0R1NhaWwwWXFHcm1FaHpVRnY1dEti?=
 =?utf-8?B?UlJoKzJabGVINHZsbEp4bjRkRThOc2Zyd1l1NGZUNlZWMGpsdGZMd1owV0tu?=
 =?utf-8?B?cmI5QkRhMnVEQmZucEhyUmIybk45OExyOEx0eXlERzZKQzBHWXV2K1Y1Wmg2?=
 =?utf-8?B?SFVvdlFnUXhta3FkdklkdHRrWDVNMjZza0U0UXNBekhLbFpkVCtJWjVmbUJX?=
 =?utf-8?B?MWhWZ09LcHVVc0ZLSTlxZkVVZUcvMlRYSUwyZ3lMWEhDb0dVbEFHU2NoaWo5?=
 =?utf-8?B?R2lIRG9GcWE1ajlkbkZKVjRTaDdPanFOdUJQMTNXYVpVT04zL1orVFp1clVv?=
 =?utf-8?B?a0xtL3Q5bmtLRVpHL0pKZU5ScUhuM3RIQ1ZzR3RrdDNCMFBUbjlzaUlsN2lS?=
 =?utf-8?B?S3pMZi9KWGw1R25HaWNkOFY3RHI3MGlCbGtNOVl1WDlSNnQ5U09SK2VycFo5?=
 =?utf-8?B?dWx0aUdXdCtNQkMyTEJJM2t1cDlrUUFGM3BUU1R3ZmVDaU5lazNyVCtOdGxF?=
 =?utf-8?B?SDZJdWNUUFJQaGtiWm11WmRSRnJpOUxDS2grRlVpTVU5eEsyUi80czFwRk82?=
 =?utf-8?B?amVDUzZFQ0FQSWNmOENwc1A0Yko3cmErT091cVpZOTZwcjZnY1o4bTNPUlQv?=
 =?utf-8?B?SmNzaVkxUzQ3REVxSHp5UHhzdE8xd1gzUlU5UEpCKzg0aXNsL3VrYnFWSmZY?=
 =?utf-8?B?QlNFZlFLL1drSUkyTWFHcWpXcVQ1VXkwb2JCVmlFdWRGM0ZFNTBpMzNGcTN5?=
 =?utf-8?B?Y2haVVo0TFYvd01POS8wZ1lBQ05PVkJjd3pUbjhuTjVaK25GNTg0VU5vVGhx?=
 =?utf-8?B?NFAveklUMm43MWFNZ1JKVzZKN01SWEU0V28zdllOQnk5aDhuVEtoRlBDTVhN?=
 =?utf-8?B?ang0L2tsR2k4RVg1bW1MWmFpV0wzcGpwUHV0MVQyM0FPOFEyam1tUmMzZFpS?=
 =?utf-8?B?MzY1NnFxMW5EQSt1cDZiOHI2NFF3NVFhNWNOVjlJQi80MDIvUWtrWnZqbS9B?=
 =?utf-8?B?ajZpODZDTGFXdlZZRVMwZi9QdFNRMTc3YTVpM3l0NTVkU1ZleVBsTUIvSlBP?=
 =?utf-8?B?Q2l2WHZsNDMxOGJ5RktjZE1mTkNnQU8rQ0JCbUNwbGhVRTY4aWhnYXdkVjdt?=
 =?utf-8?B?a1FHN3ZMTjVpbHJnOEU1OTN1ZGorR3A2Q3I1NW5CNS9tQkhZK0J6ajBRV3J3?=
 =?utf-8?B?TG5mTGIraXJWbENPQ0dROUVLcDUvWStKOEhUcTF0NTZWYWxLbms2Unc1M21w?=
 =?utf-8?B?eC9SamhTYkNrd1dGTDBWZHhGTWt6R1FHM2FkZjNidVJ6ZFhwdGVZUkx4ZTd0?=
 =?utf-8?B?aU5EenZsemVxYmY4bzRaOVpFR2dnWGxkUGZ2eHRZeUczNU5PTCtmTk1Laisx?=
 =?utf-8?B?ek9HL1lydkxkU0thd05RK1lVZHc1a0U2RU5BRWFJdUkrNVRocElaYjVHV3la?=
 =?utf-8?B?cWdDSzdTWERiUFBXODh3M2dMc3BSTHJLVHFvWEpmY0Y4eEIyNGlKT0U4YnR0?=
 =?utf-8?Q?083kOnctn3zbSHAUcOhfoIDm25FOi7bx?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2024 09:51:34.2097
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 96fd0012-3906-4094-47e7-08dca70f3578
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCC5.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7302

On Wed, 17 Jul 2024 12:12:44 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.318 release.
> There are 66 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 19 Jul 2024 10:10:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.318-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.19:
    10 builds:	10 pass, 0 fail
    20 boots:	20 pass, 0 fail
    37 tests:	37 pass, 0 fail

Linux version:	4.19.318-rc3-g8b5720263ede
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
