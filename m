Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2083.outbound.protection.outlook.com [40.107.94.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BAD5312814
	for <patches@lists.linux.dev>; Tue, 26 Aug 2025 17:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756230267; cv=fail; b=Icpf11rIyg5eWyuN7Y2sAhfQcNb5UpttY/4gtquI9RqTGpsZVxRU6mAe/x/zzqg/tzK8qMH/9ciQoL/9vjwV57TkDiTXeCiD0kDJk8CN1jheoz85T4y9va0okpzGcxwjoBTVvZDD/Ehb0O3sUzBrrBZu12iKybVu99ydN8kUjM0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756230267; c=relaxed/simple;
	bh=AQC6fy2uV4fTvwX8xreH7qUqB+Dkqh2gZ57MZBZL1GU=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=erc60gU0kVdPbFu9WiBOQXWqVpuRVFyAMHQrccVxf+uDmZvq4Sk0SHxL4IvNSosjvusHVb0vcmrgz0m5IhjfjqX1vLztGhE6wy3bC+C0tmFzyGmaEF6Xa94ULIQzDQlh1nc4eQb2+8kjpccwnvyCLv1K43r51PzJk/xrNqrkm5E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=b2TPef04; arc=fail smtp.client-ip=40.107.94.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="b2TPef04"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wydkPLPdBTJ4YcnrzJea/Tqn05+UxOrTOyTZl/MucaxmbASQz0bWQSvBM06b/V3CabvL1QZnA2Xw77Q31ShwTsnQh1yJqooFziFIH90GVFQj38EG+M19O3/IAVKpDdwm3QaeooeqTJxI0UV5EP7W9xTB7N9s9amQpA9xUgtMlQgDIGAXxqzEdAtRUxdObvI6qQpASazVpaBx7R1ygd7Gn6dVtbXQBhIut3dy9mlRBybClXWSniZZCcNEYLP2H3Z7k1HScgpKIqGVTZ7BajsBd//G9ssoLCsngTGmMNwIgtsv38qk+f4GWw6dwn0CzCDva/Nw6OxnZFnQjGS/6B2FZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h1TfE2lmeg4maVD2icQx+fyjThJqDI/Wn0YwMj/GO+M=;
 b=gQeT6/AJxMlogx5HakIjmkKSSRV4MvGCNp1On5EZfjc3u8qYAzXl520WhHxJ3CeezzS3ci8yvCxhyOwpHcEWAX89FeP4tHg4bDsyNbC8tF/EDypkaMNRn6QnMEzTRogU4mP8kGdn7aJmBbpL5P+N8ngXLOhjgYSG71Sd34VrVbRkDjmec+WndDwNyBTxqV1jprxycljzrV1x9Hd2ANcMpwbNFtrse9i8fXkieUc7UuKJgtSWEoYtRR9S4GtSOSSKquL6Emu4OoFoa7YooOx2crZw/0VTKJVN+DCLlsqqSfIx9M2QUCOd5IfKJrG+gDcL1uZRq8xlOxW5FLszjNjfYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h1TfE2lmeg4maVD2icQx+fyjThJqDI/Wn0YwMj/GO+M=;
 b=b2TPef04th3wZqjTIj88Hcxpy1PeU5SErOw/OmIkepdC1g8i1kwIfllLczVXZqeSOZSymMFM9yib8j/YLZiT9YissaTL/AwVFZXiUfKWT/WWVwSsyLuIplBWIewgfmxPuU64prAJqClT4qYyDoJzw0uxWdzjHGexUOkx2dMcuTpFzQC7BbhTjURpedFK9c5iimeZBDasT00KTL55jon5+MVXHbCGEH9Dv47aXi8KrPH3wgKVZjdSojhk2eQDU9xzf9VnvmWJ2FwxBmjDZp7St9aC4Y1fTmzakrwv8azKgO4lw6WD1MWkFqjKJmZ0sZ4Bs6YhOYPyaluSciS4j2/V2g==
Received: from BN7PR06CA0072.namprd06.prod.outlook.com (2603:10b6:408:34::49)
 by IA1PR12MB7663.namprd12.prod.outlook.com (2603:10b6:208:424::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.13; Tue, 26 Aug
 2025 17:44:23 +0000
Received: from BL6PEPF0002256F.namprd02.prod.outlook.com
 (2603:10b6:408:34:cafe::29) by BN7PR06CA0072.outlook.office365.com
 (2603:10b6:408:34::49) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.13 via Frontend Transport; Tue,
 26 Aug 2025 17:44:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL6PEPF0002256F.mail.protection.outlook.com (10.167.249.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9052.8 via Frontend Transport; Tue, 26 Aug 2025 17:44:21 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Tue, 26 Aug
 2025 10:43:58 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Tue, 26 Aug
 2025 10:43:58 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Tue, 26 Aug 2025 10:43:57 -0700
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
Subject: Re: [PATCH 6.6 000/587] 6.6.103-rc1 review
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <23b4f4d1-04bc-49b7-88bd-02b1db22a304@rnnvmail205.nvidia.com>
Date: Tue, 26 Aug 2025 10:43:57 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0002256F:EE_|IA1PR12MB7663:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ef8e5a7-3463-44f5-b3cb-08dde4c830b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?djFRL2dJUzRGaUdJdGVYSEZhN29hUWpCeFJ5UmxaWHp2cENKbGVCM3g5R1BP?=
 =?utf-8?B?V3IwbElXZ0Zvc1lKeVM1SnVXOE8zenp1ZjlnenVhRkFSNzNDeHBYc0JRRDhY?=
 =?utf-8?B?VmhQRkxyNHZzTUpFZ3RPWkpwVFBVTEJzbElVVE5jMUc0dDRRL3RJTHk4MnhO?=
 =?utf-8?B?VTEzeWRZVkZGQS96UG5BK3VJQ0tPL2ZuR2RpY0NBa0h5YTZpODMxeXdPekdr?=
 =?utf-8?B?Q1FSZlIxZHRTa2QwRTNZNHlSem02WWdqRWFsUHVIM1prdFArbUNhL1JrUWJI?=
 =?utf-8?B?TEZCUndDb3RqZ01kRlBlc2xIN1lRL3VHdWRIREdlRGVwdEx3dlVkazR3M0ZK?=
 =?utf-8?B?L1BkbEtxMjNiQ3JrdFM1N0JQMCtwTFVHc0JZNkZ2VWhoNzh6MGFYRmFVY042?=
 =?utf-8?B?NFF0c3pxalo0QklYSlFnUmxjUnVMaUR1ZGxQKytadkNtREc4anVGVnlRRTRt?=
 =?utf-8?B?VEN4VnhWbUVPU2NFbElPTitKcUJmK0t3M2FodkxFUXM4Z1loT2l4eDY0NnNn?=
 =?utf-8?B?MDJBaldhT2dEYWViRkY2NksrNzE3c1p0QkUxZURnMG42T0VPMURYSGRzbkJ0?=
 =?utf-8?B?U1lGMGpNd09FVk5XOFZUVE1idkR4eVJZd1p5M3FiZXE5WURrV2NWWnZVTHV6?=
 =?utf-8?B?REcvUDRremp3U2VhaTFaZGtHZG5YdGtoV0FJeXYxY0JyYlV4OU52WlBURnJk?=
 =?utf-8?B?dVMrN2Z5andKOTVIbXhmcVhQUXFTa00wSzBaNWhRazBCVmJYRUVkK2t5bklY?=
 =?utf-8?B?S3ZDV2RtcUFuQk1ITE91ZkVnTFJWaGpHM2FKUlR2UEVmNzBjV0xIMDNBeHJ3?=
 =?utf-8?B?d1FYTkg4YXJPL0F1Z3BzdHQ5dHFvUEtNSXVJRldtZThPL1ZiL0x0ZGVJWmF3?=
 =?utf-8?B?RldoMnVISERxTzdOUFE2bnYwVitmZnpvQkttdkRnd00rUFRoQWE3dXZVQlhQ?=
 =?utf-8?B?dWJHbEZ0VnVaZk9LejA0ZnZYc053Wmp4N2oyRzJMcHBKc3BaeWw3RVBGYTlC?=
 =?utf-8?B?dFdxNHpTYUdOYllKSXBtNWRnbnllNmdHNFFFT1FOOEhmdzU2OHdYM1dId2NV?=
 =?utf-8?B?Q25WVzhzckxTN3RSOVZSbXlaQzZyQmpHelBiMUwxcFhPNlIxTXVmSHI1N2h1?=
 =?utf-8?B?S3I1NDR3NnEyQisvekNHQWV3cUFSblEvb2Z6RmpxUTBtZ1p2UytRZGdRWTJP?=
 =?utf-8?B?S3F1WkFnS3RxLzhZenVWUXBBbVlQOFVFUndQWWcwNW82enJ6cSs5NVBZeGlv?=
 =?utf-8?B?NFRwRGhjL2FCY3FZZ3N5Q0ZudEtWSVRHWjV4aHVHQllpaWNHLzlWOXRQZHU4?=
 =?utf-8?B?MTd3bEwxK0E0QUhncU9iTGZ5S0VSa05LV0tGU0ROemh4YlNYZnh1dE1UWjd2?=
 =?utf-8?B?UjNTTFBFSjF3dGQ3OEVnamtKZWtQd2liNFFiclM1aHkrellEdGNIQ0s1VG9t?=
 =?utf-8?B?SlFUdHJtSU9yVldobUdTR2h4OGRIeFBpREVTVG5oQnBWZFNOZjYxSnk2VThW?=
 =?utf-8?B?dk91dmZ1Z29TTkV2cWx5cnd4Y3hKT2ZCK3JOTnFQQXpTb2ZXTGtzOW1CdGZr?=
 =?utf-8?B?bVo0QUE5K1puYkdTNFJTbnFQVEV6TEs3Wnc5eDduSGRVenhQNWlJVnpicXdF?=
 =?utf-8?B?NHdwamlDRVVEYldYTzRreDJyUEpxa2dnK29IMzdsQ3hVazVNekR5cWlXZCti?=
 =?utf-8?B?NUJUVDJuU3NuRlg4OHVjQmliSzdPSjhZb2M3VnNtVFVyNmtJSVYxK3B5eVQ0?=
 =?utf-8?B?RTQzd0hqeDlFODVVRUZQSVRQcnc2Skx6bXl2T3NBeEZJTzI0RmtsZU9lc3Jy?=
 =?utf-8?B?Qk5pSms2aitoNWdvbnlnK24yWVozaDZzRThUNS9yMnBsMG5OSG9UZUNqamRv?=
 =?utf-8?B?cFNZYnJrUmZ3dFlJdmxxbFVpLzJKRmIwVkgrQjJuS3JtUWpVeWFMU3Q0aTJG?=
 =?utf-8?B?MVlNVVhPWjRwOHQyQUs0bnI2eE9BSUhORWVPVmc5Nm5vUlZuYkpRb3JQV2cw?=
 =?utf-8?B?SWYvd0NvZjZiSVVGQ2o3T1lOSlJMRFN4ZThPRTZsMzcxMlJXdUxIWEloM0Zo?=
 =?utf-8?B?NG0xK0dNT2J3aXh3d1I2bmNJUUZHazNUMlFiZz09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2025 17:44:21.6471
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ef8e5a7-3463-44f5-b3cb-08dde4c830b8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0002256F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7663

On Tue, 26 Aug 2025 13:02:29 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.103 release.
> There are 587 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 28 Aug 2025 11:08:24 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.103-rc1.gz
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
    120 tests:	120 pass, 0 fail

Linux version:	6.6.103-rc1-gdd454ff512a6
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
