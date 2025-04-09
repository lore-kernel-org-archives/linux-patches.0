Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2065.outbound.protection.outlook.com [40.107.243.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C957225C70D
	for <patches@lists.linux.dev>; Wed,  9 Apr 2025 08:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744185658; cv=fail; b=Dwd30eBG0j0ooXfpfgFhCfpiuKrZ1GW0XU/FikQBbQyzdPF/aN5/n1JTZH0t0RfhXtZEO3e6NjZNPeM7wMOVVODEAhKMf1FtlWEwLkptjtrMMiQ+dLlwj/QkwbDodPcu5HU9fXbjEE9mlldWtFt2Ju2fc7QxdaVFErZ3WQepbUU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744185658; c=relaxed/simple;
	bh=UXnBzu/P9Fc/UVHTthfMpmc8rxwVxIoi2rLdLplLhgE=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=BWmQ64leIW1UbZIFmYMmvAAqRAgfAc3XM2AlMpOosGTErTLtCOr9Qy0TkVOwFifRLX1ALMi4Nl3c/KwLmg7xUXcxNTBvOwhlUI9KEkbPSBoqQs0pRVm//BMCd73VwThIqH18JLEjBMmIlm8UAJyhdtO7P48rfPctFoG/tsRj1Ss=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ljQVSWW2; arc=fail smtp.client-ip=40.107.243.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ljQVSWW2"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aNHkZUoqKVIO6sz9rX6DDfxMPoOeh1h7ybpGjtwG89YlslMeuxk4lkv5OLhBv46/T0dnUOc+Msd2WJBZSDprPMznmDeDIqnSAjdXRVMEmPCYY1hDc7/fO41fCaiWW4akAN/09h345c/tesePyi6kiRLnUUz6qAvTij9w/asD2z4Sc36gRDdyHLSe3FEXyUFGYOfWa45Ue3k6Hi93jvY/vY13hHC343v94nnJtUHVmIlFFMO1qhSnBmtgcb17IvQoI+SZboKlYAiFpGCEnlH2u7SOUCFyFrmicDTWIHK9902I23iXrpUrnuEmGfMLCD3sJ09Ur7mdwds71lK0vPLUEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hKAwMB9/JkzJqtF/5S9PF1fcDoVfiD/kkI5UKERphqk=;
 b=sLV2WNArLn+bqHqxnjp2KjcChysNdfZ7zfiDpiHAfAT10/w2R+A/HkflwuzXySnrFnOukE1+8h41wwLIPMEHcNo7ahNHU2mvUfuxd9+1URVeb+ypjH6e9vT0ddrGQhCOqBcwB9oOnzNX+03DoNsWRM6ADO83qlXyzkyk+Jdc1CCm3syMQhbBgQqLqv4ycgIzEaoDFjR/X31HrNFOMMfT4VMHowz2Pe1NOs8EfQ9jG6QD7RtUaTeebN9g6vq1M5yv2LgfJ6SnZvQVlZGOGdhAHJv29iYlYxHDlefe877OC1i0jCEUC6afZcdRbOPHMtQxdCX3YfDA7ziqrn6FneF70A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hKAwMB9/JkzJqtF/5S9PF1fcDoVfiD/kkI5UKERphqk=;
 b=ljQVSWW2CfIcbZIVFb5dKBUmKuudgEaoRXKaOWVYwefW4Jav1d5WEXeUdvS8FtJTlvtO4qFevNkIoxdxO3JNJt+R7oAZhB19s3aTZ44HyDShrwdTDn/pY4KD2bETCWMw9Bi8KpfsK7RguSo+T8mHptF/3cd/JprmeKZq3RZy/ppmqv27C1okGxunD0dX5+TwODuwj9FSxfOwhCAphQHhW8PKH4bpBlYoCtfl/UjbdHSBBCeJsB31mrpND6Vcs1vPFyXuA7mgL+5lNslGEvDWF+7gkhr2E8oOF9lYCGIj1XsDgeg88iv76cBYI5vb+MOnQ6zocwggJkoulkWKpgSjsg==
Received: from DS7PR03CA0150.namprd03.prod.outlook.com (2603:10b6:5:3b4::35)
 by SA3PR12MB9228.namprd12.prod.outlook.com (2603:10b6:806:39c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.34; Wed, 9 Apr
 2025 08:00:51 +0000
Received: from CY4PEPF0000EDD1.namprd03.prod.outlook.com
 (2603:10b6:5:3b4:cafe::e2) by DS7PR03CA0150.outlook.office365.com
 (2603:10b6:5:3b4::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8606.36 via Frontend Transport; Wed,
 9 Apr 2025 08:00:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CY4PEPF0000EDD1.mail.protection.outlook.com (10.167.241.197) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8606.22 via Frontend Transport; Wed, 9 Apr 2025 08:00:51 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 9 Apr 2025
 01:00:33 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 9 Apr 2025 01:00:32 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 9 Apr 2025 01:00:32 -0700
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
Subject: Re: [PATCH 6.1 000/204] 6.1.134-rc1 review
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <5ead0cab-bb0e-44e4-91dc-d7d3406c9850@drhqmail202.nvidia.com>
Date: Wed, 9 Apr 2025 01:00:32 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD1:EE_|SA3PR12MB9228:EE_
X-MS-Office365-Filtering-Correlation-Id: c442c702-3c80-40ae-43d4-08dd773ca55c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|7416014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ellVdE9LRi9NaGh4czJabUFkR3BTdEhkTXQ0NVZnNTh2WDdrUDNSWjNmMWMr?=
 =?utf-8?B?a3FFeWxwRE8xSHlpcHdwVDU0VHZLWEJhY0VGYVpheG9aaEdKWGlEclhYQ0th?=
 =?utf-8?B?d1MrTGFkVVBrUG4zcWJ3WHhWbWhoRWU5R094eGRybkVBSXByT1RRcDBqTDJa?=
 =?utf-8?B?OWk1Vjl2eGIzd1VjTW1VcE1OL0txUy9qSVFwT0Fmb0Y1K3RGdGNoWkI3d20x?=
 =?utf-8?B?R2V0RDRMUG9TdmF1K2RzczFvWVhoaU9jZW1LL3E4bTFweHIvVUhyWlJZa1kw?=
 =?utf-8?B?WSs4OG0zRHI3TW12bUVVeHFwWEo1Q1RtQjRFbW1KdkRmdFlaWkoyNlFDbVd6?=
 =?utf-8?B?SGN3dXFDcmZ4UHQ1bXdGQzFkbUQ2ZWZkVzRTRkEwTkJ3M293UEs3OHNVYUVT?=
 =?utf-8?B?Q0lLZHpGazFIU3FlU3pBKzB3T2NTOTVxYXRsQ1crRWp3Syt5R1YvWXF0cjg5?=
 =?utf-8?B?ZlRKSFBUdzRHUE5CTEJJRTFBRFVHL3dieHFpSWZvOUFqYnNCMGpVc3hRVkNU?=
 =?utf-8?B?WmQzWWFLcWJpWUw1NjFvUlhwaC9hNXcrR29QQVNJd3U1a01zU3ByNjEzQ1J4?=
 =?utf-8?B?TlVOVCtNcDVwRjlJYUFFR3R0c0FZQXZPMVBPd1p3c01KL2hKYWVyajBMeU45?=
 =?utf-8?B?clFIWmdJVGx4VG0wWldrM1VGMnlnSDlJRm42cEJ0NHk4d3l5VWRqNDdLMUZ1?=
 =?utf-8?B?UTd2djduRGVHWmZQRGRXV2lXOGlLcXJncjRYR2d2WC9mMDhwR2t2Z1Vra21u?=
 =?utf-8?B?OWJNL3ZaSUtGbEoxTnRHd2ZXRStYeEpBSVJQRFI0VVFBSER0M0tZdHE2TEo4?=
 =?utf-8?B?L2ZIOVpYMmlRVFhlam1yMFgzQXEwaENCZnE4WUpXaVVBYWJlaVJ6MWFvOFFw?=
 =?utf-8?B?UVd6YzZ3SnB3VGc2YXlYM01ha1BBSFdSMVBISUttWnFFRVFtcDBMbkVRcUJ0?=
 =?utf-8?B?NjZwSi9HbjNEZVZMcE9DMnhLd3ZvdFJ2d1pTVUFrNEQxSjBiUGsvTlZnSlNE?=
 =?utf-8?B?c0FPNTVnVDRNajB1UzhDSUwzUTJBbUNCcVFTQ1o5cGRqSzN5NFl6TjE5R0tV?=
 =?utf-8?B?cmE4UllWblljdW1SZzJwYlRkYnlJY2FBVi9qbFI0cEVLRE1HU0lRNE1PZlpx?=
 =?utf-8?B?bHZLaDlDWEVjK1VkMnJhMkU0bFpXN1ZkZGh2NlZaNzBMQTRRbnl1cTBZN3ZH?=
 =?utf-8?B?S2dmblA2bGM3UlpQZlFEUUUvd0ZUWWEwRlRod2RiaHJuNTF5ZWlFbHJQRFJ1?=
 =?utf-8?B?QWNnbWNJa1p6SGV1YTBrWEZsMGJjNGZCVFFLWGFSZ1V5eUE1WVozKzZ1ZHhK?=
 =?utf-8?B?SHhtcGV5emNza08vbWxRKzU4TEpsd09kSXp6Q3hPaTZieE5SNllIVDRSakFI?=
 =?utf-8?B?ajNtR0kyTjBzRFZOeWVKbHg2Z0Eza3dpVjAxQkxvWHppM0l0Z05qQis2Nmtr?=
 =?utf-8?B?ZFZDNTMyTmQzdEcrakpDWllMT0RRWDhsQVZ1NjI1QUswREtDalI1YllRNTNM?=
 =?utf-8?B?MFVPelBvallVS0hYeHo1UmdIS1hZdGpobk41WGFLeTdzV21Za0xHVExjUk4z?=
 =?utf-8?B?WEdmUjR6KzVJOGxKQUZvMUhUWEdtVkNvMHlPazF1WmcvRW1QR0NlWHRHNlFG?=
 =?utf-8?B?WFMxZit1NkFYRHR0Tk9sM05iWGs3VjV3a2FmU2ZkRnhxZzF2NkR5akYzQWZy?=
 =?utf-8?B?OGVhQ0EwUm12dEhWajlFVUg3ZkQxeTZ4L04yMlkxVGY3c2tRa05DVTJFVldK?=
 =?utf-8?B?dHdqcGt4NTQyNlNzTnVrWkZzVkpic3VDNTZaZjgvWDNnRmFQQ3NvKzNacmRq?=
 =?utf-8?B?VDhnQm84d1RFeGNGL2VJVGpjMldlZUxVZERDN3FYTk4wcTVpNzBKQmFjMVZS?=
 =?utf-8?B?QUlvYXVuVG5HTzhoaXkzU21MeFF4N09TTGljcURRWVQ0N2l2cnpYOVl3eE9n?=
 =?utf-8?B?a2ZoVlFsNlQ2VFIzL0JXVy84Wkw2U0hPUkJDRzlydG1rNHY1enloejJHNGFT?=
 =?utf-8?Q?kxAVTcsqQyxfmmUdOyoBNOAB2/tZ5Q=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(7416014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2025 08:00:51.1415
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c442c702-3c80-40ae-43d4-08dd773ca55c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EDD1.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9228

On Tue, 08 Apr 2025 12:48:50 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.134 release.
> There are 204 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Apr 2025 10:47:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.134-rc1.gz
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
    115 tests:	115 pass, 0 fail

Linux version:	6.1.134-rc1-g41c273b7c6e5
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
