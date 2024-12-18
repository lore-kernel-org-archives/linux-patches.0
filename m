Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2064.outbound.protection.outlook.com [40.107.220.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C1C51FA257
	for <patches@lists.linux.dev>; Wed, 18 Dec 2024 17:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734542486; cv=fail; b=oRkq3PBAYZa4rHyQQy4o13ChONIWoCq0SeK1eDeT6Jg/EohT5+KagX5aLfUBcK1IAwwMyTsPHz31gDSWRZ2hAoa6nq6iT6xPNZp3JALtbPUCIBcBHJTKRaCz7fjA9QdkIz8LRop3sQS32nUsak5AvgvxRfH2D0w+oo+uQ6JLJPU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734542486; c=relaxed/simple;
	bh=4a1vpV8ey2KEjJcOneYRwcoKbIWQcKbTHqihpv6zcxE=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=ZPmAodLa+Fb4BFSOuEttEESmNCms+YT+jMXbScHiTAQKT/iCVh1gXQmD1DDVlQlm6BQXTMGYpQSNq3OUjpt8hhVkZys5WCaj/lkJpjuQ1Stc8wEXHzquyLbM2pUjG4o5AZmOzacVB9WpCQgahObEyktMEg1nqmeF1mgdiuAd4Sw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=CIBiDZrs; arc=fail smtp.client-ip=40.107.220.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="CIBiDZrs"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S3gyqvxzzzej06gmR3YaqbL0/4vlIk4CpCDptvuxPLtwGPj4GvE8njwL56Pxi6aph1j4BacDyf/QuAIWxuxxgv9fbtXlCRo+zSkayz2HG26fGAPTXbG1hNlsxe6p3TKywe6CbmzEHjw2H+XGdLP4xs7sG563ai2Gx+zFFhcsuE/jizhe57ht/3/Lg25ZWV4e4OoulAvX1A0Tzb1ZRn13Ld81vIDp3pTAUrVNcB+ZC2gfGKEsTAc1ewFXY9pJCt6FsHqAGPku/Si6nUnp4bzX7cVGuVpCYh637YXPKL4O/+GglZ46CM/xdALrr6tOpgfHP7Qa4iaci6aklZcyhzxNpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bovg2biqRYYR2p9vUnZvWedaS3rzrLbnuRor42T/uJs=;
 b=TygpbmkY6PEhCnVd1q1GZ+0/S1lC2qyfNnK7erKNWKJVO7wak8V/e6G2Zdghy6AQOceQMAwULgYs/+PdxeSJfkvjqgyhR7FGn1SosLR1gK7usLOLM5SK6hKk+IPGSUNKFBilLjgHAyLZYaFCQqvxPQO0VmHezWb4U15s5gfx5DusoM9gxKkVGOACtf5iQ6MYbI911mi8M3Glyw31kajdJz3ZqsErnyoc9BVr4blLhL6R72ZU1jhrWOZGvyANfCh4L1Dz946O5rbbmEp0B4g2a5UJVSLs16iuGBbbkH/F7SA8FKWnsTLJd2TFpXP66DBCzC3JpJpcoVLbp7yuPQlwbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bovg2biqRYYR2p9vUnZvWedaS3rzrLbnuRor42T/uJs=;
 b=CIBiDZrsKL+g8TwtFGlD/BavYHqbAvLEYe/EYQs3SDM/tYKZG3kS5lN9DSzegDFP2PCorjQFd5KMf8MEVdIXMwnrccBBAHjdyQ6G6+CqqAAkx0vfKK1J3NDATFYobIBHdxYQDu6A2PWnE0vmd8hijShhRYhX9xuYOGjmtXks6zISkpmJJxXYchlvymfxp6oqbT4tNX4xp9zniqHZ3eaV5qE3O6VOZ53J3VZoHyvtGZSXQrL61w8/+WrsskhW5kVkSKoWpxGK10mUF8lGqDsepK8nejunwhDY/6inRxm/63CXVdq4F70ar4uoVo4U+LBoDJaXwdgoOlnWYNN3wTX0Bw==
Received: from SN7PR04CA0206.namprd04.prod.outlook.com (2603:10b6:806:126::31)
 by PH7PR12MB7307.namprd12.prod.outlook.com (2603:10b6:510:20b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.24; Wed, 18 Dec
 2024 17:21:20 +0000
Received: from SN1PEPF0002636C.namprd02.prod.outlook.com
 (2603:10b6:806:126:cafe::29) by SN7PR04CA0206.outlook.office365.com
 (2603:10b6:806:126::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8251.22 via Frontend Transport; Wed,
 18 Dec 2024 17:21:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SN1PEPF0002636C.mail.protection.outlook.com (10.167.241.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8251.15 via Frontend Transport; Wed, 18 Dec 2024 17:21:20 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 18 Dec
 2024 09:21:08 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Wed, 18 Dec 2024 09:21:08 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Wed, 18 Dec 2024 09:21:08 -0800
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
Subject: Re: [PATCH 6.12 000/172] 6.12.6-rc1 review
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <3361a2ed-8bac-410b-8197-4fc94a95b5b2@drhqmail202.nvidia.com>
Date: Wed, 18 Dec 2024 09:21:08 -0800
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002636C:EE_|PH7PR12MB7307:EE_
X-MS-Office365-Filtering-Correlation-Id: b8b62743-b576-4a74-4522-08dd1f886389
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|36860700013|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UVNETGVrK1ljODhVSzh2NXFHYi8wSkt5US9ySzJKcFlobmtsdUd5N2Joa2p3?=
 =?utf-8?B?eTVLb2VlMVhNbkR1cjNyMXY4SjQ5SmRQOGhVeEt5SmdwT2VGVklaVFkxZFpH?=
 =?utf-8?B?M3Y3UnRkRWllek40MUZxWlgrcFcxQUk5THJaZzd1eU9sNmxQYVNnL0ZNdEZT?=
 =?utf-8?B?Z1ZtZGpLZnMzMDFrVEp6Vi9iNUp2V0xvVFNjaWlrR0NWZGM4U2dXTEZUMC9K?=
 =?utf-8?B?emppN2REYTMxZUZkSk5Oc0o4L3ZteU9FaGVKU3hTWUlDWGJYa0xJWkFFTnVi?=
 =?utf-8?B?T002d0lxWDUvSFExNXNxaGJHaGRkZUJISWhaUkpzVzdGeHZ2bktrcW50UGt5?=
 =?utf-8?B?dlhOOUFMRzAva0FsK2E2UWJWanFmOS96dVJld1IvbUw5RHFlRmRMYkRETEpH?=
 =?utf-8?B?aldENjBZa1VNUU82VCswMWYzcUx2NEVJclRqTjV1bTFrdUU5OVk1WVF2WGRy?=
 =?utf-8?B?YzhIK2J2UEhEMHJSbS9RNDJ3WlVoN3JacGRXZEVWUGZjVmVFZHpndTlKVnR6?=
 =?utf-8?B?REpOZnhpWTc5Sm9qUjM0MlU1dUY5VTVENTNKamFsNUttWHBSZ1dhaWtLTk8r?=
 =?utf-8?B?THFrTDQwb2lTUnZmZUVHVW5DQmxoS3N1SXNETTFkMHlJS0R0aHJNMVVsVFA4?=
 =?utf-8?B?N1EzRjZrTGtXRlBEVDRSU3I1TURQK1NNaThsMjFvcU5xeXkrbVRwUnZBVGlX?=
 =?utf-8?B?azYvQmpLZlFUemtYZlgxQUhoZFFRdkRYSEVwcWtFRnFyaUs2T3pQcnQ4aUNr?=
 =?utf-8?B?MVR4am04aFdNbU8yYVdnazAwNVB0cGJMQ05md0NLM3VGM1VidGdhK1N5aEJj?=
 =?utf-8?B?QXk1ZUx4M0dmNHYwM2w1dTBJRFpSRnpEMGE5YkhxOUtZeDdESXhwWVczYkJL?=
 =?utf-8?B?R1hzdzZGSkxhQkZtNU1RWnJPZWVjQmJGN29iZTR6WjFNbXBzNHdOS1BOODZJ?=
 =?utf-8?B?a01JOEhPSzhsTi9SVi9lMDhOblpETGhMbDBOS1ptcTR6L205UERrTXVJemFi?=
 =?utf-8?B?Y1BWWWZYcjhIMndYejhrSStRL0xRSC9VdndQSTRiWGxwb2NkbFNMNUtDcGVa?=
 =?utf-8?B?ZnRFNFlvVHgvK3J2WWRkRHZzUUo5SVNBeUduOUl2SjBhdDJqWkdlUmN3ck1i?=
 =?utf-8?B?c3QyTkJ3LzBrczFWK3ZYcXdPRjBDVzd0U0hqVXAzZisvZFJPeFl5RUowV2d0?=
 =?utf-8?B?bGs4bDRoa1NNUXhGN3pIRHhMVGhHNjJTYmdjMzJPSGVBeSt6bHFVODJvSmVh?=
 =?utf-8?B?bGRPSFc2YkVUZlFHK0JCWDhKRTNkeEREV2FsdmlKOWx4M2dUYzlFaWNwY2pC?=
 =?utf-8?B?STlXK1l3OEFmZndLN3diamcwSUUwZlZJdi9rUWM5a0tEVHE4MG93RFQwdDhk?=
 =?utf-8?B?M25BUlhBby9BelhVMlFzQjdldzlUeUF0cy9VUU5aS0FKSFE4ME9TRWxqYjRD?=
 =?utf-8?B?NHhMaU10T1RXbWYvMDQ2MStiMTRuYi9lOFU2anlzZTQ1TGJtMm53RGFzOW9H?=
 =?utf-8?B?bWY0V3MwQnN5QVlOTzFZM2ZKdmM1cnhwTzlnNEI4VDRmMDRBRkkxK1Zpa2xp?=
 =?utf-8?B?dnM1ZC9jK2ZZZlJyMFBpS0M4cWVqQWZGRmhyTHZBaHlXOG85M1gyK2FYdnJH?=
 =?utf-8?B?SzFoellheDcrWHZzbTJnYjc4ZURkWGs0NVBrZTRZL1lQN0dxV2c2MTNIRzFB?=
 =?utf-8?B?YVoxek1SRTd2bFRwNVR1VHFNQ0dXMy9VcE9ocGlXZ295dnhOVi9jMHdPYUlM?=
 =?utf-8?B?V1JpR0haZ2tUbFUxSGQ1bU51R3g2N09wMnlvUEJBMktucjJDQjZsa244QS9h?=
 =?utf-8?B?OUFrRWpiWmFFeS93dFA5c0FkaStEN0N2WEtsSGpKNU9Ya2lFYm9XcWZhc29B?=
 =?utf-8?B?OVJzUFM0bzlISDU2T1U5aEdUclFhMFhUblZFcDl1NXRkODZZRHlycEdPT2h4?=
 =?utf-8?B?RlFlVjlWTG83SnNURzZYNGluRER2ckN5Tk9FNFlFOHdCSnB1aUdDc01sMk5F?=
 =?utf-8?Q?WJmcLcYygVDpOdbUnbNetT7rJrriPg=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(36860700013)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2024 17:21:20.1025
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b8b62743-b576-4a74-4522-08dd1f886389
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002636C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7307

On Tue, 17 Dec 2024 18:05:56 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.6 release.
> There are 172 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Dec 2024 17:05:03 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.12:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.12.6-rc1-g83a2a70d2d65
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
