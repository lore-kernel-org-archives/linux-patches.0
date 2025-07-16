Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2089.outbound.protection.outlook.com [40.107.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEFCB2F362B
	for <patches@lists.linux.dev>; Wed, 16 Jul 2025 10:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752660696; cv=fail; b=B3J31GRcVlmuivnvxIhnvdWHTF9gsa7cu+ho5aHQpkH45V4PTNVV64rR57qWIS6J2cbMgGgTBMu61Uwd2lgjMiwv6ZzAvWWVdWMI56c6Fwic2wKjb/Ldw/0kV4rbg/qnX3qBkNKdLH9LSmyEOFwp3LkBp9pLSh8+tvvXBn9vPR4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752660696; c=relaxed/simple;
	bh=vMz86n4remJy8u0dEvVoy+WBM3Gb3Noi4Eb3QcJIRu0=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=C2ezwL7ytCMe4RGOjPI9771TRJnmygvhRixuU1EnfoVdN67kx4E6r2JigLhHZ6XgluN3ia0fpA0QmGThsedKThObWRUZb7tOrtA1q25NYdXUESCSaC2Et8DvVgrriZczrwdpgoKY+gsoCtI2Fnls1osjeWT8rFJyqDuhPyNWajU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ZeF5Wi1U; arc=fail smtp.client-ip=40.107.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ZeF5Wi1U"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TjHMZ5lrO9oMSyqUEUW80u7MUF9Bn47YEQLnM6hfQKy4qNwPbUBaP8ch7OCMgqixu4G5jNU+mFi4YF6ilUgI3ZiJKvdRWSuMttKtcbmck+nGLsfvMmx3Jzc+qkRv0ldkV0qd7uFmGx/277BDoZsDqDFdIEjD0Fa6bvQoOUvb5SK9BkhpQxy0+AkyEIgQv8tuuU5Npj85fz4bGPNVL0FA0Ez/ugjWU85NOBBS4lVk/KP6+c956Xxr6Eft3s/78QOFztEvr38y40XSSgt4mtgYIM2U/Ox0QEbfG5MDaW6t7J5q49Dkc6JvkS9wefnciiGVYr2mXALE9svsiGSCQOC2PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gT30/+A725RaO2WeyQzztK+lclLE38cP3JavZOKpaDg=;
 b=McP0pa3JtsPmiiADEEnpM4YCSnN7o1QoG4UGL/7CNveVVN60YwDg68w1599hoiMM6BzR7w/PaES/u9tZIEbjM4kcDE65UKADkp8/53pCGEZCIpcfMBuvUvghmgtmmVFR+9mN5jxyzs25zUZu3TIE3BXwC8pBBamvAkhHr75sZR7U4e/yHjQ67zdP39ZqBBN2VaiwEyaCor1NAiLN+qkY9lNCIghCBAI+H1zUPs6jhw3mgBbQxnMPLRxhesRzmdK0icLGGMTkQqtUvbb2vAB6vRQqHTip75jvobsghlT41i5X4RR0QWAiaOeC4kO43DmHNm1GYUD5F09EsHX44s9AGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gT30/+A725RaO2WeyQzztK+lclLE38cP3JavZOKpaDg=;
 b=ZeF5Wi1UGCj381OU+bvOOjwkA4HuW+Wo+fWaSoTPG9z4HTDlcZWOoDJ7vQaItgPy52a8skJBeuxxw1wtPZH3rOLQfbVMg/a81nSFJGc7b+f0zP18N1E6WmrX7S0Wq5aXNB55/E0EkHLT5QlaZ/FFKoeKy5apPi/cjdMhXr3qaRQ+YOlIACYSnCHKM86ZKyph4B0/URwiVPLQaO034DyUf1yJP1trnhPHptgOBWqqzzGaK5MzeppMaRzgkcNVwSjjYW5lECi1xdgG9cmatlNd3ZNMaR7/VM9Gn/Svc2fy239P/iO/SyDkEAX5TQt77thFKqThMGixAJRDMPWYQ1vx7g==
Received: from MW2PR16CA0006.namprd16.prod.outlook.com (2603:10b6:907::19) by
 MW3PR12MB4377.namprd12.prod.outlook.com (2603:10b6:303:55::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8901.20; Wed, 16 Jul 2025 10:11:30 +0000
Received: from CO1PEPF000044EE.namprd05.prod.outlook.com
 (2603:10b6:907:0:cafe::cd) by MW2PR16CA0006.outlook.office365.com
 (2603:10b6:907::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8943.19 via Frontend Transport; Wed,
 16 Jul 2025 10:11:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1PEPF000044EE.mail.protection.outlook.com (10.167.241.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8922.22 via Frontend Transport; Wed, 16 Jul 2025 10:11:30 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 16 Jul
 2025 03:11:13 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 16 Jul
 2025 03:11:12 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 16 Jul 2025 03:11:12 -0700
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
Subject: Re: [PATCH 5.4 000/148] 5.4.296-rc1 review
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <451e4d80-d033-4a7e-a874-27ab053ef249@rnnvmail203.nvidia.com>
Date: Wed, 16 Jul 2025 03:11:12 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000044EE:EE_|MW3PR12MB4377:EE_
X-MS-Office365-Filtering-Correlation-Id: 76d7c75b-e155-439f-29fd-08ddc4512259
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014|7416014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QWh2QTdldEtock92VzdJQTIvZHdiVGVGNkQyV013RTZ3M2VyaDlBQ2xMc2c2?=
 =?utf-8?B?VjZGU0kvUVV5ZzJQdk9kdmtnSkkwbmRoRVl5dmhtcDFZSXlTWmJFbE5zRlVI?=
 =?utf-8?B?UkJDanBoOFQwUEZCNHo1T2xjamk1VXc1ZUkyOFBZN25UaFdjK3NKNXMwYXVC?=
 =?utf-8?B?TkpUMEVvbzEvWVJoUGZZV0k4SFMwanFKRmFMQ2hZRjRzMjd2T3YxN2FFVHF4?=
 =?utf-8?B?UW53andUQWpSRTBJdVdyTzBPbkErNzlMTDNZNEtvNzNlVFgvblFWSXFDTnpW?=
 =?utf-8?B?RWZXU1U3TDlYV1BGajNnRGgxRmNsTmdIb2JtVUpObEhJblFrSXN5KzdpckdE?=
 =?utf-8?B?YzhiWk4xYVBpOENBaDFqVXZ1c1JlSHlvQTdtOVR1ZlR3Vm5kdFczc1owbCtE?=
 =?utf-8?B?OURDaytaTEJaMWxjb2RudnkxM0VWM2dEMUlIZERScXd1T1F0cjFReVN6NTQx?=
 =?utf-8?B?VkkvZmxJWHg1SHcvb3JNQ090dC9LY2dSRms0ZUQ3Z3B3eEE1RFByNzR3SnhG?=
 =?utf-8?B?c0o1S2tNWGk5bUZNY2FLM3VsNkppZkF6Z2lFc3B0eHErOWZjK2lkZjQ1Vy9Y?=
 =?utf-8?B?MVdtMWtnYlYyVkxPWDRBbFBTSTlyM1F1d2VSZG9ZMjhma2xrZ0k0anlUV3Fv?=
 =?utf-8?B?ZW5IWGJraGw0YzV6UzRCbVJQcW85cDFPSWVjd3JwdVZ5MGZ0Mk10OUNXYm5l?=
 =?utf-8?B?V1phTnIraFE3N2FIcEV4NFczMlZtaGU4cS9tQlo4Q3djWWlqUnE0dXJudmcy?=
 =?utf-8?B?NnlkNTA4K3lEb3IzVHFWeXg4WXlnRkdwRk9xeERLOVZQRjZKV25wQUxSb0wx?=
 =?utf-8?B?OTB1MURCMGxlSXc4WlMxNUhmTEdnSXFZUUdXOHpXMFVzWEdkYVNHVFR4cDQ4?=
 =?utf-8?B?dnJsUE5NcncvTVgzcDRMbHZDOEJmbC9ray82RGc4NldldW1kL2NwTGszL0pa?=
 =?utf-8?B?NC9rNUJNQkJEbWJIaXU1M2ZvYkZLZEI5VU5VVFU5eXNybUxEOXVRVFJNa2Vi?=
 =?utf-8?B?L1pJUnJRaC83THFwdmJQd0xPVDBBSTY1ME5sdUF3RTJXdHF5R2M0dVNVZG90?=
 =?utf-8?B?b2ZkcTJqOEVPWUtNUVhaVEZuRllNMGtNRjlGMWs5dkFsQnFhRXFIQ3c1MUNX?=
 =?utf-8?B?azl4RmozQk03Yld2N3Yzb2I1L0o5YWhiS0E5TzljK29MM05sYUdWR045dDVa?=
 =?utf-8?B?UXliSnZsOC9lVEFnSDRJbEJuelc4dllCZGk2UVNHbVhPcDdlZStJVTNpY1hS?=
 =?utf-8?B?SWxjbnhraVlxcHo0ZEFTMjE2YjhyVThIb21lQUVONktER0hXTDRSeVNjNkNS?=
 =?utf-8?B?cTB6N2ZpUmpGTXpUVkhaVEt2aHJKb0J3bEtUTTllWmlhOERwQmVhOWFZcUpn?=
 =?utf-8?B?T2Y1d2wyanZlMHh5dDFkOWszN3hvMzVyUWZ2Yis5NzVUSDYrRGZTMnJIYTRH?=
 =?utf-8?B?Mk83cEdwdXZCWGZtTGhrZ1k2bG96bW4rZkVTcGxwbW8vTlR1ZGlwMldWZ0RD?=
 =?utf-8?B?R3E1Skx2Nk93R21wTEt2SCtMM1lNenpQdSs3dzBsekZTVjkxMG9RV2dpSWRq?=
 =?utf-8?B?Y3ZnY1lFb3kvcnVFUnlWNXN2WGZrd0FaQXE3OWY4d3pMN0dTM3VBcDI4UjU1?=
 =?utf-8?B?aU5Xb1ZUelFRV29KVlhsazFoUVFjdmw3UEk2MTFhUTIyNnhKM2tiOS9kelM5?=
 =?utf-8?B?ai8wTktvQ3JMWjMzZTlLeStrWHYwWklwdXhEWWtUeUw5QXh5NjBhakZXWkF0?=
 =?utf-8?B?bGVJZjFwaTFnYjh4UWZqTi9sd0pTeXN5N2RPNlg5bzZkNVlhdTlFK3JQdnJU?=
 =?utf-8?B?dTV4ZWMvb0xVZ0cvdDlibTB1OW13a0FUa09DQXdtbXRkVEdGNWNEbDRudFBt?=
 =?utf-8?B?aEJja0lNWFVXeGdVQWtDd3lIVHhzMVZhcXVVVktQOWJYeGdZTGRxTW5Dbmph?=
 =?utf-8?B?NENxTWhzOXd1VmVsR21GS0ljV1dnSlB2Q21CTnRYMFhkYmJXVnliVi82UnRp?=
 =?utf-8?B?Z0FRS2hOTDQ0OFk0MVB3L0NxOWxHaVdabThaam1kdmxtVzJZNU1VR3I0aTJI?=
 =?utf-8?B?Tk9RVWdpMEgzUnBYNmxQdVlFb0s2UnRSanBHUT09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014)(7416014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2025 10:11:30.2522
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 76d7c75b-e155-439f-29fd-08ddc4512259
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044EE.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4377

On Tue, 15 Jul 2025 15:12:02 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.296 release.
> There are 148 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 17 Jul 2025 13:07:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.296-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Failures detected for Tegra ...

Test results for stable-v5.4:
    10 builds:	10 pass, 0 fail
    24 boots:	24 pass, 0 fail
    54 tests:	53 pass, 1 fail

Linux version:	5.4.296-rc1-g53e64469ea49
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Test failures:	tegra194-p2972-0000: boot.py


Jon
