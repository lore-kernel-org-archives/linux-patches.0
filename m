Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2067.outbound.protection.outlook.com [40.107.243.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E1D033EB13
	for <patches@lists.linux.dev>; Tue,  2 Sep 2025 18:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756836258; cv=fail; b=j7/ycGBIeEIP/9NUk99otqVwf/MyeQOtEYvEQ0ZTEByBes3bJxEE78rypPZqzh2JO6KBJvI9QxYhKKz8UtmxZmQFNS2M2AXm92K8nIMgCnz8PRfwtxl63tYIeR6CK2FitXg+QrTbEUUwfLg979+Hq2+404SSg6TmG69KCoscYtI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756836258; c=relaxed/simple;
	bh=dwZXgvnBR7RQzi/RzmQJzsX5LcDW0xu3BW3L4UUgHCI=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=ftu2IMz0KDawovUTN0SKT3lY+qxIRhKVPDBGF0uG7L4WbxcSwMPYBCmSIM38EMHOrgktQpvFm7MofO3Zo1hmuYkVkwaeraoC+oMUJDOsekwGZr+mzLk5UISAneUMBWHMGqqc/9ATGmgvttme5eHY2tBxqgfEskfBdsCy9kwuKWQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=bqEYr7R2; arc=fail smtp.client-ip=40.107.243.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="bqEYr7R2"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Zb3IuTU5VL4tcFLMWbUYoUNYZmexXQQhH3yu+kF6EpudG54/Tzt55MTH3IzbhmN5YpNZp92jzDlYjgl1mP1dXANGMFdx+0lc3/a94V1CNpjKWPIfD2U0Y9zIC6gK+ueSjFy+cNgHJ1B0JoUxNVnMQ9UlQiJbmgPPqElwUVJ7r+fxuvaFlSONP4Uk2tLyU8TfCN2H5uMYKjy/i5Qh9hHbgexhMQjglimLH19jgPIBpJMRsVYJCpAmPzC7760L4E8amwWsLUho7nvFql+FWULQcKOhaAO74Y+Y4TfHA6i65omtzwj/chzuiB+rAk4AqN/FtWN/9KLvhaNgb4KH3BJnDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VBS/gpG0RQSCKaqSK9QiP3MmA0ZcoSH/OcrIwS2U3tQ=;
 b=SHmcZBKR7rNUVuAWzWzinvZEMCl65Y+5UW9HY3uJVA7w+63jriQsPvL5sPOfA/0ASzG5eOQOEp5lHieY9UMNaX9Cys3JFD8cB0u7p5678Ppl0xZGzjerxyWdVozihb8oj/IY8ELS3OSx+EMe4Gy84VpCCa+YwsWqhtdW6UcJ6CGlKv4CjuXUY9cw0Dze9sa6XyrbGvSy8uvL0DbC6VURsq8oAuc0mlB3eh3yFPaY568NJBV29x5BLVznsxC+ZWgP4AV/3pLvQD4QusMmR3Tln5O/18qETtmHKbuGVd3L6hbbLNPwbAVm8v0bl2hrNvrOPyiTvlEBfQcvRF5vNXkrXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VBS/gpG0RQSCKaqSK9QiP3MmA0ZcoSH/OcrIwS2U3tQ=;
 b=bqEYr7R2KgOHCo6d5jPDRBItpY5W08d9H3oaqW9ruDnNTxeOA/mJUUzzC9hsdESFPOIGqd23yRwg99xYWSOAYYq/YJUpPPY7jXTKwhosgW+XIeLRyRl3oFnUYxBGj38y31vWAtXQbTysrrVY+h8aFie/tPm6tvXmWeUYzbApQVF9tUJubn2wXxHpuYgmj79bmhp9HUiCg7dDu2rdr8T4TWI6UIldWLoM/a3eZpWMT/KOFMZHnc2TqqjIKN3Ge/Gdcct59CvMzHapanpG4BjX6Nptw8ngjGJcRpRp65h/0eGCHlnL3kVEBThWgYV+Rgruv9e8bnJzojVxvgggz+o6Jg==
Received: from BL6PEPF00016411.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:22e:400:0:1004:0:9) by PH0PR12MB8798.namprd12.prod.outlook.com
 (2603:10b6:510:28d::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Tue, 2 Sep
 2025 18:04:09 +0000
Received: from BN2PEPF000044A8.namprd04.prod.outlook.com
 (2a01:111:f403:c803::6) by BL6PEPF00016411.outlook.office365.com
 (2603:1036:903:4::a) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.16 via Frontend Transport; Tue,
 2 Sep 2025 18:04:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN2PEPF000044A8.mail.protection.outlook.com (10.167.243.102) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9073.11 via Frontend Transport; Tue, 2 Sep 2025 18:04:08 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Tue, 2 Sep
 2025 11:03:39 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 2 Sep 2025 11:03:38 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Tue, 2 Sep 2025 11:03:38 -0700
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
Subject: Re: [PATCH 6.6 00/75] 6.6.104-rc1 review
In-Reply-To: <20250902131935.107897242@linuxfoundation.org>
References: <20250902131935.107897242@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <7cc1185e-aaba-49b7-8357-f55666e861f9@drhqmail201.nvidia.com>
Date: Tue, 2 Sep 2025 11:03:38 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A8:EE_|PH0PR12MB8798:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d36ac77-5fe7-443e-cb47-08ddea4b1d4b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eG9JeFgwSDlOc21BY25MVzBINklKQlhxSWdrYVhnMlJZK3dmVzExSEtOZlA1?=
 =?utf-8?B?NFk4YzZNVytLdGg3TWV0bDY3Y2YrZjVrMFR0citIS1pEMVpadDFhWFNqRldy?=
 =?utf-8?B?SlUwNEZVUnhja0dRU2ZxdEVBSEtvcWJtaHRrUnBJZ1hsVGNScGljRnkwRFVy?=
 =?utf-8?B?Sk9CNW9JZFZQMWdYcHFVWEU2bER3eGJSRGVJVUtJeGtPOEZKUTRVb0FJN0hi?=
 =?utf-8?B?L2NNZCs2VExKZ2FjZE16VnJseml0SmFUd21MTmZTOGM2UUgva2JYOVNXNDRW?=
 =?utf-8?B?T1NGaVVmbnRMQUNROXk1eFFHUVphMWd3NUsyMXZ3aTc5UEd6Zmw5RTdtQzIx?=
 =?utf-8?B?TjlsaTVhZVMyalVuQUw3RGRYR2hja3ZzUmtaSm9xVE43QzFocmZIcGNUZHh1?=
 =?utf-8?B?VlBKRE5pTG4za3Y1QytPamViVEhOZzZ4UTBteGp6UUp4UWtNMWFvSlprNFht?=
 =?utf-8?B?dUdnanRVTzIrZHM4dnRkUWZjcE5rcTE5TW01OFRvcFhxVGZpUjlyTTh2dGlz?=
 =?utf-8?B?bXN3MTRIU0tkNGYzd0RYUFh4TWhNbzRXOU1lWUw5emkrYnJDQ2hvajlIVzVN?=
 =?utf-8?B?TmRrbDlpdkwxSUVQTTVJSjgwYXB3UFlHSzBVV2FjNDN1SzNJYzlkeDlGb0Iw?=
 =?utf-8?B?ZjZGQWQ0V1FHc3Y5Ly82SlpKZjY4Zm1GaXlFc2RuN1VQV1VBZFVBc3JjTU1B?=
 =?utf-8?B?ZVZObml4QjY1WllkZjJkR2tDcEFWdHBLcHBWZCszQkNMZWpENmRLTWp5L0ZJ?=
 =?utf-8?B?U1RCZlJjZlZrYXlBbWZqcTdiUWZKd0MvSExZUzJyR3NBZXhybnBPMXdhWjVm?=
 =?utf-8?B?dzc3bjBVa0FxK2JWS3ZZZENzMWJ4a0pCZllobTIyZDVPK04yaVcxTEluQnNi?=
 =?utf-8?B?WHYzTkQ1R2xsM0xJV3I1MnRuY1EyNzVHSE1jUnA2enpaT3JJTFRha0cxc0lo?=
 =?utf-8?B?WGd0SlkwMUlCYWduRU42RHNYcHpEMnNFUlo1ZWFIamRmUzFWYm9NR0N4MVFt?=
 =?utf-8?B?OXhkY2FpS1ZqQ3BQZ1dOMkx2dEt2UGpDQm43aTR2aElMR3dmc0pqSW01ZDRs?=
 =?utf-8?B?U0Y3NEhqS3llOU5jQkEzeXRUL2lwUk1SYXZva3NmcDhMNWREZDVQb2VEQlFj?=
 =?utf-8?B?cUx0cGIvOThYM1U1MitDUDIrTHFjdHEwRnNQQy85SFA0NTVKWkxabUxSQXE5?=
 =?utf-8?B?My9sODRMMEk4eEt6R3NlSHpIeW0yVk5zbzVCYzdycFcrZ2JLNGFJNGlDZHov?=
 =?utf-8?B?NG5iaUR1SGtCbWt0VENtdkxibEpkWFdRQWF5U29OM0Zwc3hhODhNcTEzcHdZ?=
 =?utf-8?B?WnphMjRmOCs5MFpyOVhIYUJtaXFoajR3a01YbWxjZWk3d3lIaERORWhMOW1P?=
 =?utf-8?B?NFVhaElQNUFQLzFlUEFiUkhxUlBaaWVYRUJZSm05Z1FEUlczbWJJYmg1b1NQ?=
 =?utf-8?B?a0NYb0dFT1YxcUc1bWxGeVRaa0ljelJ3MkdTRjY3N1A1T1ZzNzIyTGk0S3k2?=
 =?utf-8?B?b3dwRVB5Y0V6RjhIRTBTTTVqLzE4SXZOK1pVMS9seUgrNU1FbDV5TDNlNGJ1?=
 =?utf-8?B?Y0dndUpUeWQxaVpmdFZuL1FsMXlENzRHbTVpRzlwVHBpRktkMkd0c2c2WllF?=
 =?utf-8?B?UndYQ3JvMm5ZV2RMdFQ5ZXRiRGU0eFlDWm5hS294R094ZExsQ09lTU12dGV4?=
 =?utf-8?B?VVJCbC83a1J1a2hvQlV1RGlEYXN2SDJ5azRrNWRidW1mbXJqa28yc0ZDTktq?=
 =?utf-8?B?MC8zUElVcmJvK1pQSk54eGsxMEc1Qmp2aDVXbThmcEp5TzgyWkQzcEt4UGUw?=
 =?utf-8?B?Z1JRVmlCOFUwUnNMNzFENGFIM1BaT2h5M2Y3a1RkR2NjUUVXUEw1VUZENlQv?=
 =?utf-8?B?ckdkeTM0VkFWZnpobXJXc1JPamk4eHl1UngyRGdOcGxvSDgva0hEc3lvQUFG?=
 =?utf-8?B?M2svZ2JrcVl1ekgvS281UzBYWG5aWnhWSDMzOVU3ZXZUWDRMYnkrckoxWWgx?=
 =?utf-8?B?R1ZhWVYzQk51YXQrV3BRUm82c1JvYkFaS1dtajVwY0tUYUdLTHp6QXp1Z0JN?=
 =?utf-8?B?a2ZJQzlFT3pYVEkrMGhnbm5FOHkzb0JVN2tyZz09?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2025 18:04:08.9656
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d36ac77-5fe7-443e-cb47-08ddea4b1d4b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A8.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8798

On Tue, 02 Sep 2025 15:20:12 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.104 release.
> There are 75 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Sep 2025 13:19:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.104-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.1:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    120 tests:	120 pass, 0 fail

Linux version:	6.6.104-rc1-g12cf6be144d1
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
