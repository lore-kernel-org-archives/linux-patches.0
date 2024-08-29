Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2048.outbound.protection.outlook.com [40.107.92.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1CE118EFE2
	for <patches@lists.linux.dev>; Thu, 29 Aug 2024 10:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724927080; cv=fail; b=eEw7GFxykHDLGy29cyKPnJPcmeS6F4LVhL7OpLlChPPWGPO5OK8+cUERUs/kf/vXdRn+hgAjwjtvtTujGPnerXByFxFqd25Li8Wt0uZtNxCz3/O4Aojxm6bERfg+cYxYYMRsEia7StgoDAghsb1Uh1rHAtJdoCQzuShuLxrX7ao=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724927080; c=relaxed/simple;
	bh=5/mNzLt1IJMglIgBN09uOPgSqzhTuvJm10bmtzQymls=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=CajwGu8WA+vBra84ywJD9obz2XQwymLz2d7vTaTSEFYnQ3gC+FtIFruW1I4OuAvh8hw3aU98tDbP1Qbe1dckTyBEjJiUE57SnMoty130udJbxBn6YOxU3WtgK6VTPRCJaM/ewSrM1QfBHrWGN+T7ml+JhtZXVHrNZUWLd42p3cw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=cvncQUAT; arc=fail smtp.client-ip=40.107.92.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="cvncQUAT"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wQbNRYKemk3tdQm/XtaGe9NGQFHYFRnlgwTbcTJdGzgndTBPxUF+rsk/nBNwp1kX7DZ4UosEl8cb5TDkViUbJfuftGB9SVFiTiZMz7b9qPmVaSl4QyyoG3xkNph8u66XpeUV5a8xobIBPdIPw6GPF6LUDcKMTQkY49HYRzqtjoI1NlTaRjKGj0NIHkEcDqS2rdmJPax3XZwcQhJGK3UuOgWLGGVeKy+ZTMYcnk0TRc9iDCL9GilXAIkI05dWVJTlGdb8+eIGG0jxSHCE9z66Mx9+NNMTf2V/Cf3YRoDpxjnu7tMQ9E+/6MTWD5bUeJ592pvJqyrLFj9MekAw/tloxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=10ohNTZY16fojLAe94De/dWvIbuOxKsjNjev2dXUksk=;
 b=Bg41CQhwMkMch0ju1OEbu0UKGLn/6ArkJjsXv0fzJLDzkNrVqApbdlhHi+t/QU1MedPYkZVtdQEjVeedYHonFUO95QRNl44Jm6xTWQ0y75DSR8SQ2bFTR7VEFu42TmiWPibNduHFleb1ultYRW5crSDos23AXyoXDg+5eWaMBjRZp4Vw4nVXCC4yGP1MbYX/zHYwbZD2uOltQ6yMq7riGKBwTLD0TMn+9roEcAmUT22A1feeOe4CQYT8gQOH9OR90JzvuhbkJygjazI7McM2LuXXHsRvz+tuHbmVrA4pFTc52OCX0uYF5W+NUARAWSks4M1i2K80MP6Pis2y6dwD3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=10ohNTZY16fojLAe94De/dWvIbuOxKsjNjev2dXUksk=;
 b=cvncQUATWodQ5oIrjRisX4+lGybfVdUlRAIC4cO5w5vB2N5mt6G5ZS9Mu/5smmtGQYrCelez8ER4bs42JVo0SuCudoiVVOHWmGge/Tl8Bo9eXc7Eh1grhYxxSrPa9MFVqSVkGnfgHVvv3Q12fejYFFTDTkwLUmLa+ZW8mMCx2jiUB1z1xSV5VCqQDXpz9FvG+B5e3lAo+BKC+8nzJpYc63HnTbLIFKfbWTqDlQmFitRi0ddLWXNgspOK9ePqrkbE8FeMM+xKWzJ9jXCm+7jY2yjt4KM9EnFUKqQ8j9rLWUB9wke20c557cdH1E14ynuStOiYFpcjHPBja2w1IyumEg==
Received: from BYAPR02CA0060.namprd02.prod.outlook.com (2603:10b6:a03:54::37)
 by CY8PR12MB7586.namprd12.prod.outlook.com (2603:10b6:930:99::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.27; Thu, 29 Aug
 2024 10:24:33 +0000
Received: from CO1PEPF000044F3.namprd05.prod.outlook.com
 (2603:10b6:a03:54:cafe::78) by BYAPR02CA0060.outlook.office365.com
 (2603:10b6:a03:54::37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.28 via Frontend
 Transport; Thu, 29 Aug 2024 10:24:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1PEPF000044F3.mail.protection.outlook.com (10.167.241.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Thu, 29 Aug 2024 10:24:32 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 29 Aug
 2024 03:24:21 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 29 Aug
 2024 03:24:20 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Thu, 29 Aug 2024 03:24:19 -0700
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
Subject: Re: [PATCH 6.6 000/341] 6.6.48-rc1 review
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <4677589a-1770-440f-b708-f827c6810dfa@rnnvmail205.nvidia.com>
Date: Thu, 29 Aug 2024 03:24:19 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F3:EE_|CY8PR12MB7586:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ce6df88-441d-4c84-b8c9-08dcc814c633
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?LzI4NHRQR2h4bWtIK2d2ZHh1bUE5am9MbkpIdVdYcGJHS1J0aG9ONm5qb0VD?=
 =?utf-8?B?YldsdXozUHBEaHRCdE1najhwUXZ3Sk94OU9mbkU0RmwxZ1p6Yit5YVJ4Szdh?=
 =?utf-8?B?a1g5L0NxVTRjRHZxK3dpTWlMQnlUNU5BaGpGdDVQZXYwaXlaQjNWbnRNbXFK?=
 =?utf-8?B?RlY0VkRSTFNYUmF4UXljKy9KcjhRd2IveEl2NEcwdDBvYW4xekZwWlJXaHpr?=
 =?utf-8?B?eXErZXRGb0c3d3pMS1puZTdTS3VSM3pzVHJnZmhXYlUyb0Rhbk95UitjdFVo?=
 =?utf-8?B?ZGhBYjVWMnZ1OVYvL2xDaEpHbWR1SnhTcEV4WEtvRndnS2ZYVEt1cVduekFw?=
 =?utf-8?B?ZTlSOWJHb3dRajVuME8vQ0Q3ZzViei9oSVV5S0EwM21QbTdpdi9pcHBtYVhn?=
 =?utf-8?B?bFZVc05BYVcyVmxyY0xuQjhiOXphZGh6SWE2bU4xbVdzWENUU0pzdHlZdGVt?=
 =?utf-8?B?cGZSdkR0STAzWjF5a0NxL2VuRFVSaG51VVRpdUJFbUdORFN0KzJXQ2N2bXlM?=
 =?utf-8?B?ZTBXNnVWNWVCL3dNV3FRU3owV2VycXBRNzRHbUErakJsRis5SEQrLzdZOEtk?=
 =?utf-8?B?eDhxWW9wYjdpbzYzWmVyMGRYYklTVm1uWGNhcVRFK21BSzNPVnNCSitzOGlS?=
 =?utf-8?B?UjZ2RmpUTUlMZ1dXemJyYjdaRCttMVBPbDFLbjczblh6OXR6WGpGVTFjVU9E?=
 =?utf-8?B?TzhLSWRDbEoxb2E0Q1NKVlg4Wm5YeVhxY2IyUVI3SnF1MXgwWDJTUkU1dDV4?=
 =?utf-8?B?WnJTTXZqZ1lhUlIxa3kzTXpEeURpOTNvSnJ6VGFDQkJ6SG1FMFVFSWNwamxH?=
 =?utf-8?B?eFZzM3FsM1VmWEZnTnRncUZlUjhTQU42SEVQeDYzNFMvSEM2Wm4rWkRyaUVm?=
 =?utf-8?B?WGFBWTF0K3FSbVUyMTdSdStFcmRJVTRTckhWTVdMcUFsN2o5MzhPSVdYTGdJ?=
 =?utf-8?B?aWdTMmxycDRPZFFjR29PR20vWmtnb2lWMlVsbGVUanp5WUlZWG9VYmc5V3Mz?=
 =?utf-8?B?SkNRNG55UTN4L3Fwd0Z0WHlPSndmanI3U050Wml3bmtKTnNZZmhKVWpGZEFU?=
 =?utf-8?B?T24yZmRuRWVGL2dqOVdqOEhzNFRrZzBOTUdRR3VFWjlWWUhrb0dsMDlOZkVG?=
 =?utf-8?B?RXJBcUxheHhFZ2QrbGN3amYvZkQvU0tTU2N0S0ZSOG5CUjA1QmtSdUF6cUY1?=
 =?utf-8?B?SVNQR3d0QUYvYjRnVDZZYkVOclZsbnAvSlhIZnJKUnV2YnlMUXl1c3VGQnBl?=
 =?utf-8?B?OFZiVlNzLytjeFBYb2srM1N2OWcyRlVZbldJVElWeHJFMVBtb3BPUml4M2RV?=
 =?utf-8?B?cFhZcHczRmxsbDFjL1cwS2QwQWhoZzEyM0pyT0pXVkgrS1NibWV6WU91Rmkr?=
 =?utf-8?B?T1NDV3p5Rm5nNHN3R09ySHVveTAxS2pnd2lBV2prcWlDZTBHV0tJVkdTWk5r?=
 =?utf-8?B?em1lWm0rb1pUamtWVnl1emgwaVR2T2ZHcEpKeEcwRmJwY09rbi9DOWJaU1hK?=
 =?utf-8?B?VXBNVHFvbzBQU1JuMkJzSXc4d1dZVUJSWmE0aGlSeDAwUGdnSDRBUzNwRlBE?=
 =?utf-8?B?ajZQSzJCMVhKbUpxaW5ScGd6TEI1Tm11eUFZeVhTR2hKNnQrU2h0TkVRL3Fx?=
 =?utf-8?B?bTgrZjRoVnNnRWYzUkQwblIrNG9Zc2Z0dFUwaTUyMDlzdFdZZkhuWDJGelJi?=
 =?utf-8?B?dkJlbk43ZUxHcyt3cHM5TnFhcmZ2bE5YSFFmVEQ2MlVtaU43VzlCUHdBcVFl?=
 =?utf-8?B?MVRmOTk5Wldlc1AvSmtKamZXMTZlRnJYcm52QTVVOGowZmdmM3p4ZGlISmtR?=
 =?utf-8?B?YWt0ajBaZ05CbmUxcjZVU3o1OVhqRURHdXVaQ0UrbVJRdExZQVNvcHZWQSt5?=
 =?utf-8?B?UHJyUUlXUHZvSnJXZ1pIb2FXNGhUYmxXemcwZ3p3TjdQNWVDcGY5RnpudUt3?=
 =?utf-8?Q?jxT2N/2vabJXh1b74bRohOt6T8rG9X3r?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2024 10:24:32.8541
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ce6df88-441d-4c84-b8c9-08dcc814c633
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7586

On Tue, 27 Aug 2024 16:33:51 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.48 release.
> There are 341 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 29 Aug 2024 14:37:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.48-rc1.gz
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
    26 boots:	26 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.6.48-rc1-g0ec2cf1e20ad
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
