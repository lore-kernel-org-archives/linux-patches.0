Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2085.outbound.protection.outlook.com [40.107.220.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C821286D45
	for <patches@lists.linux.dev>; Wed, 13 Aug 2025 15:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755100094; cv=fail; b=I7vripMZD5mTLh4bgHgC9BuLldGdemqGbfkEE1dXmtLYAfq8hxN4c7uPBUb7278/PVf6g9xbInIcjD55IlBU+5E8aURyiBFBF9OG/Wrmy9x8wj6jbsWwc6YjRiPiU8Ld8BoKwi3AgPc3EOoJO7F6dgPbWWSDK0DxzsOroc4aOtQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755100094; c=relaxed/simple;
	bh=OwJwLhtjwpB0yE5p73nXqs3hyAn7B8GBVrtdNjiDhoI=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=B9RE4eB7nrCusQL2T7HrgLEyD7wfgwE5M7RsDIYGsVmojoJCltGuU/wq/EE//UWPWbKEOHeQeEuup46KKvCg+x84AoqTfvRGXM/eEUsDI4/wP5BmlMsy0GVhRLOPfgEPldS4zvUyeZn8HZIPOBxTrhT3E14CBBMvkJT7fWAsa0s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=YKa12+g7; arc=fail smtp.client-ip=40.107.220.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YKa12+g7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UVq9LNr7teu9aFn1HKA/QiLpa9yByQASa3G39L52IevyicEc85oCvdP9mn2bV7jxtIMcaEbLGwsetHu6PZeHOjT7CQNYvB71El8e6+p2gV/UCvgjpb5+nBD+eH2HVBJNn2GDW4OiagHAeYeoAVZqgfH9ctWg94kM9HfxNJ1SPKgv+fwaszbdhGsF32mupm03pO78Vs+XzccKjscr1F8WiIxNGr0W4gMcaIMC/9tjSTN4HPiBXKTiI5wgII6vzaAV916Nvzjay9w0xlbnn0Z8UoZ1emXlXLblo7KB0vMN+QqWs/rHAsYFgOywo8CzleM+VBqxwIqIGuUF4hYTgYERfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j1AYzArpDB2nJtsLwajLpk8Y3LJoPb1a4WxIZWpFqmE=;
 b=lf/D9L3n6VIxKAmy4mIePty6AVRJkSUiZuq/MXqll8CERD6HO9i9uWhwpo6VT9bHDsJsrutLlGDePqdBpHgdkVBALqxyOxjEfPwkeMnJm3R2erzsER4mKt7788wNDoCQaoyUlpRtGjj4wydY2G+GTGBoL0QrzmEljK/jxHuH1Iis13YUrjxqRP3sv/h8ko+pUIJ3BKHmoxDDsZm6/yPR6pGKclco3vH5e9IhMyJ2f5ESFvBAYuRZgPqjQKUie0HNLrdJ8plHmm3NMRfHCFKqyQYSP8mzj81Q5b8PKd3xhZciN6JhpMKoDp3+t0wVmbUX2rpz0Gh1lqZ979e4Zyj6pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j1AYzArpDB2nJtsLwajLpk8Y3LJoPb1a4WxIZWpFqmE=;
 b=YKa12+g7eoAHcpAxVVOv+yX/MRKm5K0lZScOILT1puV+5QoAvYj7A1Z8g5/YcqOM8yWYKEINSdnoj4xlg1BUfIeEd4HA4hJ4ejGwlM1978geTMZXF7C11A4pwNJekL2KlhT30CgYU4mkN64BC0gRBCVzQd9dVHWMrPjs4hGcMxhnO3qrAWZI2tfNkNt5bOUhDtVMIm8mQuh1H2SCT95Pswg2ROpUNf5xHgHSN2a1cpbS4nifUoGR3LHMpMjnNbw+Kc4ipLBjAzvQ95n1PsIp95tCWPFYu52Qpl4FhHu4hNiZTa4uD4CvpBmG9gOTxEPN6vw072wpIacqbY1Ihc9ScA==
Received: from MW4PR03CA0017.namprd03.prod.outlook.com (2603:10b6:303:8f::22)
 by MN2PR12MB4077.namprd12.prod.outlook.com (2603:10b6:208:1da::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.15; Wed, 13 Aug
 2025 15:48:09 +0000
Received: from SJ1PEPF00001CEB.namprd03.prod.outlook.com
 (2603:10b6:303:8f:cafe::30) by MW4PR03CA0017.outlook.office365.com
 (2603:10b6:303:8f::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9009.14 via Frontend Transport; Wed,
 13 Aug 2025 15:48:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ1PEPF00001CEB.mail.protection.outlook.com (10.167.242.27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9031.11 via Frontend Transport; Wed, 13 Aug 2025 15:48:08 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 13 Aug
 2025 08:47:54 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 13 Aug
 2025 08:47:43 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 13 Aug 2025 08:47:43 -0700
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
Subject: Re: [PATCH 6.1 000/253] 6.1.148-rc1 review
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <5d8c35fc-0764-4905-9ca6-9232c3d816fa@rnnvmail203.nvidia.com>
Date: Wed, 13 Aug 2025 08:47:43 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CEB:EE_|MN2PR12MB4077:EE_
X-MS-Office365-Filtering-Correlation-Id: 1dd3c6c8-9548-448d-2f3b-08ddda80ccf9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|82310400026|1800799024|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZWk4RENMdFpXRVZuSUtyalkvc0lQcEQzcW9DNVhIeDVtdmFGR0w4dGJxYW4y?=
 =?utf-8?B?N05ydlFiVE03NDU2VDY4SmdjendmZFdQR2VzNWVoZmZ2VFdScERFQXpxVSsw?=
 =?utf-8?B?UmorNUZOVVVCbGFSOWljdzFWOWx5djVQU2NTUElRZ1RHRDZCVHlvV2pCa3Q3?=
 =?utf-8?B?NkJxaGdyaEhsZ0phV0xSM1FzaTc0N2xYdVlpdG84UHNvVXdPbzFWVFFnMkpF?=
 =?utf-8?B?bzFVZ0ZBS1hVb0EzcUw5cUZCcnJjeHdPemloVFltdTZtTnNsK3U2elNuYkFX?=
 =?utf-8?B?dFdzcS9iak1vb2ZzczFwcjdEQncvMHlYaEJkUnZQOEFMTGJoTVdxREV3YzFk?=
 =?utf-8?B?NS9yZUN4QXJlcnQySjJGazZmU29ZMEpvb3I5RGd1NlNob01aMkd3bTFVekhW?=
 =?utf-8?B?QTZNTDVpdEVXL0lNT1BJb0NCS2NTanA5cDFIaGpBcHBXVlA4N3hCZUhiQ0hu?=
 =?utf-8?B?TUF3bS9icDRlTUIwemJEZWFxbWVNM0lTWDZlcVRzZ2lBVTJrTnVPcE9QSmtR?=
 =?utf-8?B?YnNCSi9mVTMrak5aLzI3QXpaY3A1VHkzVHgwZ1o3TkZYMWFnNTVZZEduTGMw?=
 =?utf-8?B?R0drNzB5K0gyRThKL2NaUG4wckxzZkRiK2pXdVpiaG1QekVQWnlUU3A3NGpJ?=
 =?utf-8?B?YTFzbkJkWDlKVDYwNzBQRXdHVFp5cG56Q0tldGE3SkZqc2FLUzk1ZUUxVlNj?=
 =?utf-8?B?MStvMGZVc25HQmREZXNINTlkV2RlWExuMDNIWEFncHBZQy8zOFJYUkhzYk9a?=
 =?utf-8?B?bThXV2FjV2w1RDY4djJ0NXd0TXVxOGIxRFFsNDFoRjU3WER6QTc3bWRKUys3?=
 =?utf-8?B?Q3pIVjNjZW0yTXNyaDhDN0hyYjBnZ3NQVlNhRmlpV0JHMHFuOU5GZi9pTG42?=
 =?utf-8?B?aVJ2Mk9ldU9YcEVCa2c0cGdtUU9IVmpyNnkvd053Q1JTMUFOeDFRKzlTOEF4?=
 =?utf-8?B?VDQ2ZmdkVXZTYjhSY01aVG1YRUlMdmZvTGxMeGNPS2RNb29IRW0rM0pUaStN?=
 =?utf-8?B?VkVGYkJrbjRDekp2TkhEQ3BIejBVMlE2b2xOS050Rk56cTdaRTVtd0xUUEFn?=
 =?utf-8?B?c0hBNlU3Q3NVbnZUdU1DN1owcUVKOGVOVnE4V0sxaTdKeTRuYjcwamV1TnVu?=
 =?utf-8?B?WmtxSzc1eWROYktCeWxUeHg2UWt1cDFLNHZONytBZzlybWVkbkxYNDBkR2hV?=
 =?utf-8?B?YTdsUnNTT1VmY2o0T21UNytQVDRUOEp3SzZycTdtTWVSWDRuckFDRnYxajBw?=
 =?utf-8?B?V0tPYUFMOG1HS3VxcEwzOVJOKzFvN2NyWDZUV2hjL2JyMGg3UjZnenBZNDdl?=
 =?utf-8?B?Q1B4SGRrQW5KazNpZy9kZnpjTHZac1lNV0NoSHZVczBkbVpkMnlNQk00SkV0?=
 =?utf-8?B?UC9KT1BoQXZpNVhJVUtZM2lDWlkreUdKaWVpK2h4M00zRVltOGhJcjJXU281?=
 =?utf-8?B?TUFESVJGZ1dOejlhNXFxenBTOVd2VHhpZUU0eVJkeitUQmZUK1NRclVRcDRX?=
 =?utf-8?B?RkZ3Nlo0c2hncCtCOFNYMjhDZzRZY1lrSDJjRFg2bGFGK21CcG8yOStrbE8r?=
 =?utf-8?B?d3ZManlSRExJQWxHWU1GWjZBcFFIS0pQNC9TallJcU9OYXl5MkFwR3ZueWUy?=
 =?utf-8?B?SWExNm85dE9RYjRtcXczc0NKTVBVVlRkSndyMEVPQ2dSU3ZLT3loeFFDRmM5?=
 =?utf-8?B?RktUVDlxclZxN0NUNlExY3NMeUo1NDZyQXhmRllYLzhVek1zdjVqeHVWSmli?=
 =?utf-8?B?WXFpT0FicjZQOWtOSjg3aTZwRDZxRmp0ckxmeWtqNldwTUMxTWxKd09YUmcw?=
 =?utf-8?B?R042U012a2FFL3RKSkt2YmdGRmNRUWp6TGdEWVh3RzAyUzgreDZqYjJJemNF?=
 =?utf-8?B?Ty9OREpyUEpTRmdXWDhiVmNrTmJobHBXU09DaFl6ZW1ic0d6UnRqZURlRGZr?=
 =?utf-8?B?UlVWamc2NWtPb1d0eXJUNG1sR0VCQ0swQlVFUzZHQThTZDIwN0FBQWFTYW1m?=
 =?utf-8?B?dXVLZTMyRDZza2U3K0dmVGNDWG5YYjdYcGZTamljT0JpVXlpcERLVE11ajFo?=
 =?utf-8?B?T09OWnJiK0pKNmRMSUo4azJIZE9RK25kNm5Jdz09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(82310400026)(1800799024)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2025 15:48:08.5365
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1dd3c6c8-9548-448d-2f3b-08ddda80ccf9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CEB.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4077

On Tue, 12 Aug 2025 19:26:28 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.148 release.
> There are 253 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Aug 2025 17:27:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.148-rc1.gz
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

Linux version:	6.1.148-rc1-g7bc1f1e9d73f
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
