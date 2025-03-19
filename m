Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2049.outbound.protection.outlook.com [40.107.92.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 048F62144C1
	for <patches@lists.linux.dev>; Wed, 19 Mar 2025 19:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742412949; cv=fail; b=Cr8E2aOahfgksEs0/aUtjZlai5ZDhAujDXED0kzUvfiCcwy4JaS8JrY/ozL0DU9RIHeT/Xh1C5UYLGE/3hbeSX/m8VXiWDwpmrkF4/0Ko7h8KicJtfuBOJFBSdrtiNPZtvMB02PKMZUEQxNv0b1c80dDGKrTlSXdIK/gdaeyUiA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742412949; c=relaxed/simple;
	bh=3qEn6aTv123SNGKxLm4fThgv628TgLvkDRHrgN/joEo=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=g44oQ+ckDbN6mtMGcNCwRpk2/EfEtZ3ZBFJiN+Ove4gTLgJYbG+bVCKD02Z45nKxadAYsc8IIcoearEz0jtR+ai9JcSnm17My1CmIWHudbBS8UiRP8TMdJFhWHMjjwxCXrxSvbSaJJdJOkK0E8qj4EGGhy1Dryrh3FvzMS1WTZ8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=G6cvz8qO; arc=fail smtp.client-ip=40.107.92.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="G6cvz8qO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GCPly4d5UBNwoUdX41sfcrdco8NvoPMx7c11qXtMgpQuzIBJVYyaJ+OTU1KyUw69TlaDSOTxxlBXDOwgEIDBqGykL7CCkX3XkTNsYovHS989C2PId1kabkyhJf2o/Y2QPERzMVwoolYFquNqG0lUg5k1sWTlyeVs0T2qSQPIogUEwpr87RNY716E1iiqZ1Bd6YS9a2DL7UNptDVwK2c1EqBRpLJfdzHjt9ZPuvO8ZQBXt/mq0wV0AQDm3v/69Eu0oMsMdlb/L33LKPAaMUVf8ZOdEL4gLC9pRtEDjfcTPnPPuJj0b1r5MS4EpEddAymPKr+aRfbGXno+WAWd+AUGEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ylwxAkheF29WJEK2hKOwV4BJy931SNOnibRIIx6L2T8=;
 b=bUHkIpiWttkT+O0B0EiekwRXIa63/T2iX4vlQQD1IyH7GJWE7O7uY5RBbqQoJ97+40m5hpoF38nQ0oHUfAAHh6yAhkzvk8lVN72B6FsCuQwXOc2LYLBH9mlCnmBdVJOWYxuzzW9bxucUYSH26fY7y0jCX41AvUlyXtmz26tdalunoDVSTczGhHmmV0fpKmXeLBlZqfl7ifu9Fc7wEzzeiwqkneWx6IWbJJds3fE6QZdA0NEIvU/SnuQAsHY5oiTZuXiX/3p7HeTmPuXo8J+9graSl+ecllnh4VZ0olWmFd0lGD4+RMcVTkzQY2b2zGsuRmgL56RIhi+w56tPf40IUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ylwxAkheF29WJEK2hKOwV4BJy931SNOnibRIIx6L2T8=;
 b=G6cvz8qOtxgUfc2upnaJTxubYhAHRg8xw3WkyYe+Ex1Qs3PnVpSglplrG92SvjsI/H7t51C0BylBcgCh3WW7eOP1GrtmJgQFGLyvcGBN1EoggUeFWkPvXQmCNF8wUmOm3xr7Ih7cl7gFkGfVrHiNnGC6lYnKoxxM+uQi6r/YK1Y2TSSD7IYzM2VWfClhKpNHp0HqfZ9liLIAYNTr5bdGFA1dE0e0pA54OR6qTqsXpZ+4HRAyhJbJvu1CY9o2ZInyr1Kf37pLoP9TRSRFfC6o91VSIcVpKjGu2jdXXL/P3SPZrlea6zTDsM7LTKXhVNIyasiAVN+geLNqJxstGLDX7A==
Received: from SA9PR13CA0075.namprd13.prod.outlook.com (2603:10b6:806:23::20)
 by CY5PR12MB6454.namprd12.prod.outlook.com (2603:10b6:930:36::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.33; Wed, 19 Mar
 2025 19:35:42 +0000
Received: from SA2PEPF00003AE4.namprd02.prod.outlook.com
 (2603:10b6:806:23:cafe::b6) by SA9PR13CA0075.outlook.office365.com
 (2603:10b6:806:23::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8534.34 via Frontend Transport; Wed,
 19 Mar 2025 19:35:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SA2PEPF00003AE4.mail.protection.outlook.com (10.167.248.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8534.20 via Frontend Transport; Wed, 19 Mar 2025 19:35:42 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 19 Mar
 2025 12:35:27 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 19 Mar
 2025 12:35:26 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 19 Mar 2025 12:35:26 -0700
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
Subject: Re: [PATCH 6.13 000/241] 6.13.8-rc1 review
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <646038ff-3dd4-4cee-be2b-a8b5d9c65db9@rnnvmail203.nvidia.com>
Date: Wed, 19 Mar 2025 12:35:26 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00003AE4:EE_|CY5PR12MB6454:EE_
X-MS-Office365-Filtering-Correlation-Id: e64d9924-ada4-4ec7-6d42-08dd671d3c67
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|36860700013|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dDFhT2F5SldZajRZV0s3TzdmNTZ0OC9DTi9VUnZaanVZY2hqWXpFZ2JVNTla?=
 =?utf-8?B?WHYwU0VVYThYQjQ1SXVBS1hzWi9aSFl2OHpRRkVPZUdkb3pYdHdFemRUQXZx?=
 =?utf-8?B?Rm92UnpIS3AwLy9VYVowM1NyOUVMelA4SkNxeGFuRVIzeU1wMlhPTno3ZWc3?=
 =?utf-8?B?QnNKMlZFU3hLVy8zWE11M09aaE04SHdkWm94SXVFR25FTWNJS2tTN0FPa1hZ?=
 =?utf-8?B?R0U3cmtKTEs5LzBBc3V2eHVRNHRqdW1pbUJUYjhtVmdXckFwQUFDZ2wrWFNP?=
 =?utf-8?B?T2FwQnJ2QXNzc0dWdmREY3pORHZmK29LVi8zaTV2RWZFakx4OVZlaWl0RTZa?=
 =?utf-8?B?VXhsVGhQdm5FVXBYcVE1bHFiNUdhajFRdnREbTlrMWJ2ZjBwamU5ZC9iR1gv?=
 =?utf-8?B?NlFOUStaWUNNNzNwQ0FVU3BsNzFMajdsZTZaeGxWdThidU5KbHl5VjhVSTIy?=
 =?utf-8?B?RVFpUHRFSlZzcXY2a3BWeW9nLzM0d1NTVFJVaUVqenc0dUdtTG1JRkIzSzBT?=
 =?utf-8?B?QW96WWlPajZPY3NQMG1oV1UwODBsdVZrZTVQU2VDVzl1OXdZSzFUV01ySk81?=
 =?utf-8?B?UmU1WTF3enZiditiWXBsWm5lV0U3OVNQN2Q2TUQ1SENmbWVHY1BKc1RVNEVm?=
 =?utf-8?B?UXFiR2VZZ3AyZnFlTTJtSnVEakJEbGFVYUJ0Y1VHemVXY3RvZkZBaWdPa1BQ?=
 =?utf-8?B?b1hQVVlKWVpxWkg3eHQ1UXppdk04TXZKUWpKWFpPVXMwUTJTUVVac1kwcWU4?=
 =?utf-8?B?QWtDSXZjajNpRVMxamJBR0svVGlsci9kR0NXWDBoTisvWHVIcWZLVGFicFBx?=
 =?utf-8?B?bVJhOXF1a3IrYTVuL0Yya2hNdHBYbXNxNStGU2gvdTQ1WW5UeGx1TzREak9E?=
 =?utf-8?B?UHlBMit1UURZdkJ4L3JMM3A2LzI4VGRYNC84aTRwcVN5N2FPaWJBZkNENitB?=
 =?utf-8?B?a2RsYkJBUEg2MUk4ZWtWMFZDd3hadVQrZUNDYVJXZHlGVW9wNEFLNCs2R2x4?=
 =?utf-8?B?QU5zUlNCWlUwUWJuYnlmTzdET3FqcHg4NWNaVEx4YmtJV2o5VVBqYllGODdp?=
 =?utf-8?B?TnRFUFFHZ244VU0wcTVLR2NCd2p4d1hkWEZ3TTFLdGZDUnd3NmJtalR2VFlH?=
 =?utf-8?B?azVBMnIvVVFwRmVka2JyVVM4dlZjVFZoYndyMWZzL1Z0Q0pacUhTbmgvZFVR?=
 =?utf-8?B?aXVTV0t1Q0tscm4xYys0M092cjVnZ0hJcmprS2NEdHArTjk0T0RxYVRqS1U4?=
 =?utf-8?B?RmlkY2RSdlZqYzQwMjdpdzFYVnV5bmFUZGsxOEpQVExyemhjd004M2F6YUQx?=
 =?utf-8?B?V0xtTG5KekxMS0RrbWhndjk2V2xZRVBzbnV3b282Y0hQK0RpclFHRTFrejhW?=
 =?utf-8?B?aDcwQUZOdFZwQ1BWSkp1VEUvQjNxVjgzQklqU3pWR3BPbWt1a1lDUDJNcmx1?=
 =?utf-8?B?Z01xUVM3eVdMbmd3cTRWeERKVWhGWnBPclpTeExYUlAyTkRPUHY5VTZ5UUgz?=
 =?utf-8?B?ZVVyZTBKL1l2ZFd3SmlxeDhnZWJJcUlpdFNBMFNJTXRuNXFnZlU2R2c2UDFV?=
 =?utf-8?B?MjU0d0NpSzlrY3NmcFgwTWJGYUw1dHNTV0orbjd0TDVWMTNYUEdNSUJhMSts?=
 =?utf-8?B?ZUZCQjZNZEt2YUtiNjZmSlZFNWpYUmZCejNGamp5TzhaQ1pHZ2ZzZExtZzJC?=
 =?utf-8?B?bXdSRVE5aFV2QnUzU0cvMklmN25tam5NOE1RWHQ5TkRjakZQdkdwSkdDK3E3?=
 =?utf-8?B?ZmtjWXMvUm9tY3JBVE1Nb1M5MmVaL2hjYVZUajAzRTFMTnZ6bWRVUE1XN0Js?=
 =?utf-8?B?V0RWQWwvenJSLytmWStkS3dzZUlqRkVzRVVNNXdKVkQrdDlLUmtpWGlTZXBk?=
 =?utf-8?B?YXFNMmMxZkR6UlZtNXVXN2pGSHVKbUZCcUJUTEtTaGU2QzNPZk01bktqS3Ay?=
 =?utf-8?B?T0NBS2RuR3VqSmdOdWZkTTFJRTRTV1k2ZkkrYTBYeTRMb3VhWFVEREV6UjFx?=
 =?utf-8?Q?TTqAnKCJD2YrNz1ZXNfZ4x5suoTOG4=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(36860700013)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2025 19:35:42.0039
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e64d9924-ada4-4ec7-6d42-08dd671d3c67
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003AE4.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6454

On Wed, 19 Mar 2025 07:27:50 -0700, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.8 release.
> There are 241 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 21 Mar 2025 14:29:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.13.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.13:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.13.8-rc1-g14de9a7d510f
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
