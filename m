Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2078.outbound.protection.outlook.com [40.107.102.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5EA22030A
	for <patches@lists.linux.dev>; Tue, 24 Dec 2024 13:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735046821; cv=fail; b=RjXjkts6UueX1V28KCkQNgmW3sDKGKzsNpAMlPKUC8QXUiQoXj+UgjW/BFBiWxLS8jQWSvAS1Q9U/trF9smUUEjf0QVg59qg84PyEev4xu1P2gQOzl/TmYS+XX+coNw9XlSLXDTedvZSDq2s6JL5SlDH+RR9qDfw1AL9xiK454Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735046821; c=relaxed/simple;
	bh=xmnbeSfi8uZxFfZtUIKS+0NuFNsq2vmRIROph2Vwe9I=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=eFrfO/kf6zBssn2lVBZC/hbJkHH115o8jUZzuBksPzOUkqatOpMFC0FMqi+q11ntrNa/TqNSJ5JHi4RVWssml52TuIGUNkXS0tUMLu2XYuqFLv43iJhRwf0cR/j41QbwQ8WV8Y2iLGn7JvjONnrTIvPlEfM6UAX1d5O1ePd6eHE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ZqyHqJk/; arc=fail smtp.client-ip=40.107.102.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ZqyHqJk/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RgRUKDbaehNiuUL0tRFTqMt7axGWzNSxrw1NV03Gs1ojzs70KO8e683Nx6OR0p5Wv3Xhk2spPdDtrgOuSKMKL7hFkz4iBAAebpIgcGm6CreLJNvKJWUAn0/Tx/rh6OhVFl5N3CrUk9jswZ4KIzj8oYuq9fpVDTV2dPLRJTIzROcgANUMDdJnPXx+77TIkdnV60E2rcRvXKjloOaYCglGcS89FbbgR5MQrR9RteJsZ8nly9ckOxDZDliDkyk8FAAR5eaJgyjxkJTnugK/T4h9cCICRJk59U2FtC633GJmjCq7HGQ0vbPsrWJZh2Y/UIloy7MWGr2eO3xfq82SIDbsjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zO1fMv2zly4bG/TjXZhRQuDogN0qPDbHWhgrAhbb3Zg=;
 b=TyD/9NW4ol+hBx4SL/voz5EDVY34vph7TeHdBaXCTg0T+p/2pTY+ndmnyCHSzfk5qrul/d2ZKsz6f7q1gJMvUemheKcGmso8lrOavwHrowf0zWOds/xzqbD2mzQMgE/RSCc7jAxZ88NJZYlojU4MgmxNLFainkm9SKw3nFPFdkOUPIGsZ7nTEK5kwmg5LyQ6zfU9FgQa3sfm3KFiVxY6sB2k1kfMy6J8lJAT+NfMco0a4e21OgZwMfaDKDBKDsRZSjrLYqLTgucXARiFbCZUcyXuIxa808HdGFJR5Af++98c2HRywtmqDjz5+c5ZpXWW5rlQLSBeC6VZJmtl8s91IA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zO1fMv2zly4bG/TjXZhRQuDogN0qPDbHWhgrAhbb3Zg=;
 b=ZqyHqJk/Gbkb8ygIShIY0tJobrFz1SwWIHdTMRUCqjJ/ldnKAjELcTAktTb44MvVdgCNFGQ6xvXcwMSJ26qUii3jzqzmGug/N0cSNfpCBFZfzhcCo4QqBbjVt4MTcKKFB1oeUzagmPyI0vWJoNLAoiCbPirMnZxrlerOVkAFl40T/IsFZno6fER8uZSBowQCMYSGobVBaBRSQQmIZt6V3OQUW5q14xcgA3uNiyF3sMMXgwPFh3Y6uAMlEQfhfYhPv9k4XAiMKzmmo2xE/2MJrYwetgiPFM4jg8gjW8nAfFydb6HiXABxRhk1b6/8Yb8R0lQi1IebGRcVE/VmrLd+7w==
Received: from CH2PR07CA0020.namprd07.prod.outlook.com (2603:10b6:610:20::33)
 by BL3PR12MB6617.namprd12.prod.outlook.com (2603:10b6:208:38c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8272.20; Tue, 24 Dec
 2024 13:26:52 +0000
Received: from CH1PEPF0000AD75.namprd04.prod.outlook.com
 (2603:10b6:610:20:cafe::c0) by CH2PR07CA0020.outlook.office365.com
 (2603:10b6:610:20::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8293.13 via Frontend Transport; Tue,
 24 Dec 2024 13:26:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH1PEPF0000AD75.mail.protection.outlook.com (10.167.244.54) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8293.12 via Frontend Transport; Tue, 24 Dec 2024 13:26:51 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 24 Dec
 2024 05:26:35 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 24 Dec
 2024 05:26:34 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Tue, 24 Dec 2024 05:26:34 -0800
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
Subject: Re: [PATCH 6.6 000/116] 6.6.68-rc1 review
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
References: <20241223155359.534468176@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <76bfc6fe-a150-4239-a8f0-f25d898ff209@rnnvmail203.nvidia.com>
Date: Tue, 24 Dec 2024 05:26:34 -0800
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD75:EE_|BL3PR12MB6617:EE_
X-MS-Office365-Filtering-Correlation-Id: 7eb3a284-d99d-4666-86f1-08dd241ea09a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?V1E4MHRXajNlQW9ZTGp4RkNWMndpRHpwSHpzdENpTkIxZHhrSlhYQjREeml1?=
 =?utf-8?B?UTFvWjNyeDYwZStuUEErencrY3lDNXUrZFFLWEZPeU1kUUx4OXJacGtDWFBC?=
 =?utf-8?B?UWtvK3VwZXd4RlNGSFNkNkhZeDV5MDRtWUtPbDY3Z2ZzVEYzT0dWOURDWjBr?=
 =?utf-8?B?QUh1NHl6bHJwMkpLT0dnRFZaa05URlhBNTFoUlhLTVkzZjgwVkN4YzhNYXpM?=
 =?utf-8?B?OHNrNWZFempZakdKNDBDUFNyUGlycjBvMzAycEdKYVROU2daQllNTzkyWEY0?=
 =?utf-8?B?MmxlTU8wS0h4bW0vQ1lKZWhCdVR0S0xrNEkxRFZIR1lTcHRZei9aczBLTWtn?=
 =?utf-8?B?QSs1b1lvUXgvZHJnckJSUXVNMlZYcUJQbmxaVWEvejJJc1JkL1Z6TE5zZ3JU?=
 =?utf-8?B?SW1CU21mUnRLbVlGOXZ5aEgxVDBPYlhwM0VtTDRpKzZ0MHp2UWhYdzFKUHJP?=
 =?utf-8?B?YTJqWWhMUlR2c1Jid0hCQ0h6Vmhxc0ZDbEc4emZ0S09DWWRuTTlJaUlvdG5Y?=
 =?utf-8?B?SXVzbWR2WkVXTWZOdWE0cU1VWHhqZzhYcmtOeG5SNzVwZDJLa2hLb1VIeE82?=
 =?utf-8?B?QVZXaHBsOGE2RjRyRkdKRyt0aHhoSWx0ajdRUmVxOVorR2hjaXVIS083bTQ0?=
 =?utf-8?B?b09rem5vVC8yWUhmMWc1enRGQjlGdkhxZTQweEtFRGtYcXFFN085Q25Xdnkr?=
 =?utf-8?B?SUJnZHZ6bWJNdTlQeHI5RXpvdHpMd1VHZ296SkdzcGR2MHlvQ29jdk95ejZH?=
 =?utf-8?B?SUlkVHd6TmdGeE1IOG1FdzhRbUV6aFhoR1JSbTVsOGxZcXRlOXBHaGt5ZThI?=
 =?utf-8?B?YVRCZ3ptSTA5RkFpbW1BajJ0WWw5Y2phQjRVQUpuRDg4bitjSHlhcGppSUQw?=
 =?utf-8?B?endmSUMxS2swbUoxNHJpZGtRZ3dDTmVHTzc5TmdZK3ZRdEhYM1VGNG9HN3dR?=
 =?utf-8?B?UC85VmpvRGh4a0tyVVFERWRUOUhNZFJsNGEwTGdmdTdRNUJ0RXJ4clB5ZUQw?=
 =?utf-8?B?S2FzdEl1cW1iM0poeE9jNnc3ZnpOWjkrODh5TFUxTHRZSDFkRGZHZmFzdGlm?=
 =?utf-8?B?T1BwTk5MN1l4blR2cDJQNmtlNEpmK1RON2wveTNtVnp4SFM1SlFyYzE1K3J0?=
 =?utf-8?B?UnNLcW0zVWVoOC82WHJVd1Ava2Y4MW5IZCsyMXhuZTR6MmRMTUJEdzZzUUxL?=
 =?utf-8?B?NWdVZkY5eDhrYnIzWFZHamVzbEM4SGF0eWdwekdXdVA5aHJsOC9vdUVvSjZz?=
 =?utf-8?B?R2lXcTRnUzNNY1VZUUdjQUpxRjU0WmZkRE5ucHN2ZVBsbmsxVTZxY3Z3enVw?=
 =?utf-8?B?MmZNam0xejl1bFBBVnF1eURldWlRVXU2SlhVaHRnMm1DTnFhaVhDQVI1Q29r?=
 =?utf-8?B?d2ZlTXFhWmFQbjFHdjRwaXB0TEZUcjdOUzhwUTdDQ2VsU3IzZWF2U0taZTlo?=
 =?utf-8?B?NzBpVHF4czBGQzg2OGIwY1cvN2wwVHJ2b3NKdzdJZ0VRLzl2c0thaXkwQXQ2?=
 =?utf-8?B?Y0d2UFkrT25NRU5tTmZGUnMvc3hlcnU5ZEN6RXg5SEVkcVpvaTFUVmwyQktB?=
 =?utf-8?B?MHZOV2VSUnczZGhVa1poSjZ6Q25BY0J5dlBsSDM4R29MN3AvanJKUzRhamVx?=
 =?utf-8?B?bnNaQWh0ekVvR2MxUUtGcjhMc0hnUG9xbXJDeVh5MnVKTjJ4UUFUd1BqMnVT?=
 =?utf-8?B?TENFbm9Bd0ZYMjNnblJML1NXQi9mV2lJN29hOXVsNDBVQWNMRGxRTnpEYXYy?=
 =?utf-8?B?M3d1TDFFbHFqenVpbnhlTVBsd0RUck93c2RIM2JaV0hvaXdJTVAzT21zQWtk?=
 =?utf-8?B?Z09ndzhXU3JMZWFFcE9KdjlnenZxSmd6UmxHNU5CZFRLQXg2cWpCTnNRV1Rs?=
 =?utf-8?B?WTVQd0JxOTdwaW1TY0wrVGs5SE1oUnAwWWdtK2JCNDBCLzR6QXJIeEYwZFU1?=
 =?utf-8?B?WnkwOG1seDU0L2hTZU8vbzhFaGhmelBBaWFNakI5ek9IdElJNUZJZEFxOXYx?=
 =?utf-8?Q?Zq7ZM6M+Mo2l2i/Rb9sOA4I2Qleniw=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Dec 2024 13:26:51.6860
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7eb3a284-d99d-4666-86f1-08dd241ea09a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD75.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6617

On Mon, 23 Dec 2024 16:57:50 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.68 release.
> There are 116 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 27 Dec 2024 15:53:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.68-rc1.gz
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

Linux version:	6.6.68-rc1-g6a86252ba24f
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
