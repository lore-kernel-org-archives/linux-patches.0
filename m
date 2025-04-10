Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2045.outbound.protection.outlook.com [40.107.244.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620AA284B57
	for <patches@lists.linux.dev>; Thu, 10 Apr 2025 12:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744286841; cv=fail; b=M1yDcBoaGFjr3LmpTj6+gAQ0iqYZUHH76sGPgETjDrgktMVNULfZBCgtMJPqAxBShshdq4Us7Ca5Q6kuMSbPCfv+miunWl9HCiD82nAMi+kSG+hqGgafuQZv88m2wLs24cLO9GwILv5XON9nX7UNpSiyhVvx3mbfURVWPTdqcR0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744286841; c=relaxed/simple;
	bh=G/ukteSjJEOgycxBlYSUJoyGg9CIFMn6w5WhIchOzQY=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=kvIuRvL6NySjyeMaXx9Q8/PZC68jPJfzeqj3KsDx1GdA+0sJ7kWyhulsKRtk0bBZp5Cep4y8p0MSgZbsJxoQhEx0Pyp6H3/ca+rE549cq5Km1mxDeNW5Sf9niJjHb7C0To4p9q7dwiHYrXxPpiuYzycPLMOZ9wT5HlbScuqO840=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lqRt4y3s; arc=fail smtp.client-ip=40.107.244.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lqRt4y3s"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a42EDiX870wZbbXtWmMUXgRwTnbAo14raK5JYu8Ie0F5Dmx59ywjdV9uWdVuvl9dNCJH2kinGP104T3aiCsdSyjCn3Yh2mDT/fU9F7WthICKT52Nmp1xoDTCI3lL2vKCNsbyR1Wbav6GsHe7FcbqIkdZEdtNedtKsTXJKrHiju9mKEFOLSFtMe9HMsv27EBEXiy58KMwJakyKsYwlbZXyF0XQES0KczRHYjJ0sVbayjBR7jDrFH4qUo7Q6gvrHGNXuB7bbu0TSMD3UycDzLt2U/rlCwZ6QPPEkDkkhmbzYimH839u/oMobXgr0iiqLI7T28Dq0z/jO1Me55vTb5YlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aGqQ7yQ1zBPWn++5p9V7Gdl48zQP01hZ+niGfD9YhZY=;
 b=gPAezZmeCPIHuxjVhE1eilUVRBwYja/bdOr6DivO++8U3HteLhZtWvWy+vUZd+2sUDY5ZQCUDZ0r+c8TsYe6Etp6SJo7dGcDktQLgwl+hbnTsQvwM7Oj5hw8v7C0WJe0DFz81jryO+pS3A8xgkAbXvWaA5FivzY7wjjEs7dBzYbaYxqZrlXXPbIN1mDxFKY5IUKd/ZhbB6+KdUs0LWW2UZ71ObtlOnG+OZVsK57LP2QCI2GIeKyCqAtlZAHy+N5pD5o9Sn78WyYSlJHTQBdQTjRx/9etYWcn1MUJ+ltTrbYsZHnRjJNMOa/61cYz2HeLu3BJ0uShM154plmCGDf5RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aGqQ7yQ1zBPWn++5p9V7Gdl48zQP01hZ+niGfD9YhZY=;
 b=lqRt4y3sEC1KI5h5OIP/gGSsyGWmmHd/wG5m5WXHInR9grCkH8OZyubwE77GKL+da2BFAusq8YLrsx7nzcG12oaRT3/PVUyCGl91iGukZwPQ1LATMBydF0hBGUCMBQK8Yom3kHopigkXk0+6u1WJgxhnheaCxAziEhlZSCQ6DdI3pIknHOg9OzKQXt5KUa+DejILV0GJiyphydfDLCHLxWIB7HtQPy8UpYbBSOsPiFaJWgB1oDDGjBcXWK+KSiSg9So4bdyuTZF4WA05G/AnnLEieE9r2Q+xusvCECV1HU81+dMUUf/k2NsXaJCmczfjJ3b0UQCd2VQQ/AiMoaTNZA==
Received: from MW4PR04CA0373.namprd04.prod.outlook.com (2603:10b6:303:81::18)
 by MN2PR12MB4334.namprd12.prod.outlook.com (2603:10b6:208:1d1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.22; Thu, 10 Apr
 2025 12:07:12 +0000
Received: from MWH0EPF000971E9.namprd02.prod.outlook.com
 (2603:10b6:303:81:cafe::46) by MW4PR04CA0373.outlook.office365.com
 (2603:10b6:303:81::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8632.23 via Frontend Transport; Thu,
 10 Apr 2025 12:07:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 MWH0EPF000971E9.mail.protection.outlook.com (10.167.243.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8632.13 via Frontend Transport; Thu, 10 Apr 2025 12:07:11 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 10 Apr
 2025 05:07:01 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 10 Apr 2025 05:07:01 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Thu, 10 Apr 2025 05:07:01 -0700
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
Subject: Re: [PATCH 5.15 000/281] 5.15.180-rc2 review
In-Reply-To: <20250409115832.538646489@linuxfoundation.org>
References: <20250409115832.538646489@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <491886c8-fa89-4118-8d2e-3d202eb93790@drhqmail202.nvidia.com>
Date: Thu, 10 Apr 2025 05:07:01 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E9:EE_|MN2PR12MB4334:EE_
X-MS-Office365-Filtering-Correlation-Id: c8a13a5f-65c0-4fef-aaa9-08dd782839cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|1800799024|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RWMwQ0ppb1p6T1JCTnFyMGRuTWk3bDZFbHFFY2JKQUp5SWNnWHFnSVhsaFg5?=
 =?utf-8?B?TFVCTzdWRUllRVdRWndxSXVjUnRPYXNRVmlWNzRwalhoMDJkWnJsc3R0MEgy?=
 =?utf-8?B?REMreDVMUENONGZycVFRQ3lSdG01LzA4MlJVSjVJYVgzMFpTMmZ5ZUdkQUxz?=
 =?utf-8?B?R3RKek02WEhDZVlFbUlwMHVTTXZKck14bnRHWWFDVlBWWHk0aHpjc1NLV2Z4?=
 =?utf-8?B?NXFvOUEvR0VybEk4dUFsWS8vcWVmZW1NRUN1dGlvWlBQMVJlTEw2QWlEM1lw?=
 =?utf-8?B?eEpVMmNXbURuTUFNMFBYVEpOVlRPa3ErT3Y0ek5TWlJUdHZGdnp5ZGdObmxB?=
 =?utf-8?B?eUs2aDdIWmk0cVlMTmdvSFNvZTl3QmcwK25KbjNrWEo4YyswT1ZXOUlQbWNw?=
 =?utf-8?B?UlkvaUJsVWNhSForV3ZLemJVZUNhZ3pTSmNOYU40VEVuek8xTy9ZWTRsYTMy?=
 =?utf-8?B?aVRhK01WUFp6aXIySkZLSWZEVlhPNzlSOGhPVkcyakNHTEdWc2dyK3d0V1NM?=
 =?utf-8?B?amYzRnJ3Nkd4RWlCL0ZFdGFCRVRHVVVmSGZxTDlKWUxHVTltNm5BWDBHYkpL?=
 =?utf-8?B?bml2RGE0ZjFQbHFTb3FOZUY1MTB3SDdNZkxydzF5NTJjQUF4QS9QMHhMKzBF?=
 =?utf-8?B?NitZSzNMQ3JLY050QTVGTGtOVlhkdEdmSC85VXpGZDBhaU1ERTZIdy96cUhQ?=
 =?utf-8?B?c25UT1Bua3VhOXlQSm55VEt1UjlkTkVqSWJiWHZXbmdPd0Y5M3FaRTc0OVUv?=
 =?utf-8?B?RERHdDROc3phZEluUlhUdUJxT2doeDJEck1OczVqeEt3MUJla3hxMHB3ejdy?=
 =?utf-8?B?N2xrbzRZTWlIVThOMjlGM3FTR1Y2Z3VwTXdsS1dHNkJDQ1JZUnBWR0VNTjU3?=
 =?utf-8?B?S095a3N3ZmhMeFdtOS9nTDIvZUNwdm00U1hHM2l2RU1DU3dEOWxiZHVJcEtI?=
 =?utf-8?B?QUN5M1ZNWGhaWHQyZDU2a1hYeGJFRnBXMEREZDAwajhLcTA1Ly9QcGhHKzJq?=
 =?utf-8?B?MjdzenhvLzV4cU1pRiswV1lFRU9iYmNWc3ZuREI0RHdDd0ozMHJGRW14RHRt?=
 =?utf-8?B?YmRBaGNaYVlvdlJQcE5IUVAzTDBVcWtoeHNEbSs1OE1YQmhEbE5kRm9CVGFL?=
 =?utf-8?B?TXBPVlpTcU0vQkRqZGk5VzZFSythaVM2djJXK3cxSDRuNXJXQTZVOGhJVlY0?=
 =?utf-8?B?R09zUG9VM1QzRFlYU2RXYkhoSFBqUzNQaEtCWi9Wb0Nndk9tUlNtWlhNRFVP?=
 =?utf-8?B?dlV1KzEvSU4xZ0VmWklzemEySStjQXNZVWYxVXphVk9JNVN4alhTRStKSjRU?=
 =?utf-8?B?MTJwenQxU1F5VDdObHJNM25KbUlUK3ZUbmQzODZlU3NXcHN3bmpQcEd0QXdS?=
 =?utf-8?B?N293R1g2dkJ1NlR4bk9qbDBCdmcyM1RmZzR2aGk1MlVvb2tGKzM4MWxMckNJ?=
 =?utf-8?B?WGdCbHZCMlcvMVprdmRIQy9yYWU0NVN4VjNmcVZCUk01MVJtZHJ0UVhuRG90?=
 =?utf-8?B?ajdJYVcvcmFqRzF1RUlOS2YxcHBSMzlFbXhtdk90dklQMjlQM1JGRU1SRk5D?=
 =?utf-8?B?NDdTamgyVFFmTGdGbjE5WmZPcWo3bUxyRWYzS1BzYzVOQjJNYU9BTFRLL0NB?=
 =?utf-8?B?ZDI5WXRkaDlncE5mblBoZFhCM1NSNTJ4Q3J5d0xlOElmSFlDNkdid3ZCSDRs?=
 =?utf-8?B?OUNhNEwzQ0RQSjdzQWlNZmpnNTRDdW1tUXhDSmJyOTdFNVhFb1FYbk90cVlh?=
 =?utf-8?B?YldlTTRPSFRYVlFQOWsvRXAxQS9GdVgwL25vZTA1OHNPV0M4cjI0NnVQWkFu?=
 =?utf-8?B?UHZWOXVDMVozWWZyNlgyWC9OUGtQMUFRRlMrNG1lVy9CMmg2K2J4ZE5ac2Ns?=
 =?utf-8?B?MHRJbW9RMnQ2ZDJncFZDV0xjY2VuT2Q2WUxhYnBCbys4blRsOTRPSWhBWHFD?=
 =?utf-8?B?NHJHY3BkclYvby9maFhtSU9YdWUxMGlqbmd0N0lxanlSRUQ0ZzlFRjFaY3FZ?=
 =?utf-8?B?SXRvMGpTbW54TmRzelo0RCtURElqMnc5b3R0c1NudU5LR0tIZy9QeWJ6a1V6?=
 =?utf-8?B?RFgzME41TEtYMk1xQkowZ3Q1M2V4YUZDaDRtZz09?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(1800799024)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2025 12:07:11.9527
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c8a13a5f-65c0-4fef-aaa9-08dd782839cb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E9.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4334

On Wed, 09 Apr 2025 14:02:21 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.180 release.
> There are 281 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Apr 2025 11:58:00 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.180-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.15:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    101 tests:	101 pass, 0 fail

Linux version:	5.15.180-rc2-g20340c8f4f00
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
