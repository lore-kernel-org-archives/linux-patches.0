Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2052.outbound.protection.outlook.com [40.107.92.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B69418787A
	for <patches@lists.linux.dev>; Wed, 14 May 2025 15:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747236921; cv=fail; b=RA4uTV0gPAgNnJbxG7sP/AxBSjzfR9obnYFgHDiI1Q0eFm7ZcP4EJ2KahfHs3LJ9C/b7E+GPpW7eeiJGT7U+eQUoO1K9zTqIlcmdILiHaluMEu5qDwRaSke705mIs7+MthB2+7QSInrKJuXA5X1eQ/4/PmlKtpkPItZ1u4q8DkU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747236921; c=relaxed/simple;
	bh=QovBLeFf/aQKcJWW4LutqNQVvEgQWi7rEHPwiQq7q/Q=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=WCqHbc7NOhgQlrOuA0HXLkDI5vZa3Q7q4ilXk5gb2W+xHW4rUNPwFbw1BIlhyfGXBmGKSsHK/CwghJjsCtZAFUptoEg0EmJCBtQ+pI5S2Ouv56o/DYdMy5J+JnZ6Je4SsgoDHBUbAI+VtJRQQYz3aO9EghZq2xSOLnNAiDt6GN4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=fGqlQCeL; arc=fail smtp.client-ip=40.107.92.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="fGqlQCeL"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m9hbCfPoxkniHP2xlieZLbvy7KHT+VQzI7r6ZwubW3l5Hg7JVrM+B2q1mjmhU63ti8lUtUQEo+3u4/krN4dUUpeNwnWbJZCKmazENX91xew4isr/XL40uK1a6cX9d3pocYPI/kkZrF43h75HrwS2bfG+914MjbsOsJl395fztl9f8bKt1dbLHztGG8h+NsKvlZj1dVhm8VkU0Q4NCgRpmNopXgwcgNSySdsAPn+56skcoP0M7AWyd1CqMcqGGnUUs6+dcEdcAxAUL5C4A1aJJXwHSWrHsw56sULBnQAup3Pox7JOFpfq3yCiXXvCb4ppS3LVZ9BHYsSFduNIbqEODQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jzw/RJX1V3Rh5Eaug/ksVgIPied1Rvme6db4qgCCgYw=;
 b=yQO+TD7+65Qpya0y/TbPBIrFKco4GNcZ96PbSb4vPCPKrse5FqRcRS36Y/Fiw852QEf+B85KSiCfAL3G+LqmbQ7MrKdsYNe3jWEGnTdX/P+h0vWYR+WRcPxugknrlugWyQV4yUjjDOdE5k6sJEX6zAvWWbvJuWdseh0jgNlZbg6jIOGRcgEOjuLgRXQPMjbERRX+cUAFs5Mj6YkKpPeXg4xqVN8h+M7GQ1dGVJ1m2sEaHVOU8Kx9/qJ3ncTXMTh/ybTFDsOv4aK2pWyyXs4dvetuGrTS7Y6lLVwRIb2KSPJocgdTN6Wlp96XRuYUyNuUfcC1W/E1XHRDpwNiZKCSmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jzw/RJX1V3Rh5Eaug/ksVgIPied1Rvme6db4qgCCgYw=;
 b=fGqlQCeLotI89X9uUDYsL7vEVk0oIbBmUvqAMzjTwBNk5Rzzu9Eqv7w98F7mGpGBVdV3pg3JqAEgoZ1b81+qFTrbTHYiwNEAj8WROvuiOzGTRs6BaYRPjvtucQXr75elFdR89oYRXN5E/ZXOSJJO3QYxfXnd6VFp+dKXNDpeKyyZFAPg8gpP+PTbUM/xj/QM8rZf9Kt4heLjNPGTnuHW24VWVTnlImK6o4EDQ8uh+4HcpggPnLZxkVGIJvMLQHjppalaYSUzvQvlj0r0xn6iSDc9IVEot4qcpBKnSr/hY7SLPUyOyjRzH+v7xlrA0w0NXcOVTRlJmj6JyxSbBUBbHg==
Received: from CH5PR02CA0017.namprd02.prod.outlook.com (2603:10b6:610:1ed::19)
 by IA0PR12MB7700.namprd12.prod.outlook.com (2603:10b6:208:430::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.30; Wed, 14 May
 2025 15:35:13 +0000
Received: from CH2PEPF00000141.namprd02.prod.outlook.com
 (2603:10b6:610:1ed:cafe::7f) by CH5PR02CA0017.outlook.office365.com
 (2603:10b6:610:1ed::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8722.28 via Frontend Transport; Wed,
 14 May 2025 15:35:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH2PEPF00000141.mail.protection.outlook.com (10.167.244.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8722.18 via Frontend Transport; Wed, 14 May 2025 15:35:13 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 14 May
 2025 08:35:00 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 14 May
 2025 08:35:00 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 14 May 2025 08:34:59 -0700
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
Subject: Re: [PATCH 6.6 000/113] 6.6.91-rc2 review
In-Reply-To: <20250514125617.240903002@linuxfoundation.org>
References: <20250514125617.240903002@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <42d6e79c-2894-4d38-b31a-39eba9c0126f@rnnvmail202.nvidia.com>
Date: Wed, 14 May 2025 08:34:59 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF00000141:EE_|IA0PR12MB7700:EE_
X-MS-Office365-Filtering-Correlation-Id: eccaa562-fb5a-4625-ecb2-08dd92fceb35
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?K0dsbGtZWHJ3UENMK1ZENXhOSGNCSXdiZ0ExN1ZEN2FvT0hiQjBDMk16NzVs?=
 =?utf-8?B?cXFJcm1POFlDNVRxcFNjMHFSQmpiM2Q2ZDNJNjJRbjZ6YlRIYzNobGFIcXN2?=
 =?utf-8?B?dkJLa2xkZGlEeXlXU2cxWHBkUzMzQ1JlTFFUMTFYWFpJalZNRTVqb0ZRY2VW?=
 =?utf-8?B?TEY3NHVndkFKMVhsWis4WEhTa0V3UVJwZFlPSm9kQ3RsK3VaL2JoVjRNL0p3?=
 =?utf-8?B?OTJyYWJqWU1zNGhJVW03bk9nVStYcFE0RkF2MWQ1RXJyNG9hNk0zWS83MjVR?=
 =?utf-8?B?akhiN2hDbEtOZXNKVXNsVU5LMHdhaDM3dHpJVEczRStaZ0d2dDZNQkZZVlNM?=
 =?utf-8?B?blA3NU9SRlFFMm92WFM1WDlGenlTT043b1hHQ1k2aTFWOG12WjZDQ09RL1NM?=
 =?utf-8?B?bmt1OTJqdkd5L3FvYzhFMmt1VFd5TyttMXN5V20yRjE3Z3ZLd21rbjhDZXlu?=
 =?utf-8?B?WlJ4d0tCZ092VFI5L21GdkFqdkVxZHZKWkZjTGVET29nRzUyaUdLYjV5K05P?=
 =?utf-8?B?OTRVKy9kRlVoVGhndXRuYVR5VEJTalJpM0g2L0tnN2RqbjFlanhBUG5aamEz?=
 =?utf-8?B?ZWVFczFpVHd0UGRMUXA1V09FQ0llaWdPOXd3a3h4K2d2blNIc3JPdFdBZDk0?=
 =?utf-8?B?VnB5V2dXOTZtRWpSWGh6OXh1VFEzVllCUUh3Y0EvQWpWbE10RXZ0YjRaUFdS?=
 =?utf-8?B?UDNqRG9haGxuVFdyeWNKb3Z2U3FYRmR3Y1F4R01TdjBoaEVmN2FrM0Z0azIw?=
 =?utf-8?B?dkFlbm5xQnhUR0Q3VHFFOHhSeG5aK0doS1hiQWo2QzIrUlN4UnRGNWFxUExl?=
 =?utf-8?B?ZXd5NktKWklmaFljZisydjF5bkNSMkd2Y3JmK296SFI4WDJxYUIwRE9nVDho?=
 =?utf-8?B?c2pWQ0MyQXV3SlRaaENIV1BrNjg3anlnUW9IUG40ZEI3NXpzNjVmU1BsRExl?=
 =?utf-8?B?MUNYZS9CUkJRRU1Yd1pYYTVlNFNscjVybUJURFViSW1rVWkzUFVRaG41cjRk?=
 =?utf-8?B?SzBSOGJHNEt4TjFsSUhlQ3pZSzlET2ErS24rSkxOUHFCTWlnL0twbWFrMlJV?=
 =?utf-8?B?SGZXK3RFQTFiaGhYYXFsWTgxcXJ5NldJTGg2TVpwRFZyMFE3VHM5dzhhc1V4?=
 =?utf-8?B?b2EzMWRzWk8rUlJLK2RONkVzZFdCZUVoTTlLeVAwWVZadnlhak9lYkY3QzZJ?=
 =?utf-8?B?UVB0bWlGak1ibjdqREJWVWQ4WktMZk9zRXJMbk5SZXZodmVpeGQzdkVaVkZv?=
 =?utf-8?B?K1Y2Sm00VksxZVVCck5rUjIybjkwb01Fc2tCZEJjaVcxajYzZXZPc3NrN2Iv?=
 =?utf-8?B?NEdqWExxUnVCQ2VUY3l3Z2s3a0dXbEIyREhNOHNobDU0b3ZuM00xTmprRVo3?=
 =?utf-8?B?bU8yQUt4QnBPeFZQb2tkbndySUM0NnhlOERLVXpJRkNyK3FSUG9hUElodHBG?=
 =?utf-8?B?cUZzYWdiMTViS1F3MjZiUXBiY2hTL2NSbXF5aWhnK0ZRbk0yaFE3S2hkcFFW?=
 =?utf-8?B?TWxMUGpNWWZNeDNBYkR2UDhqbnZkSEY1MVFhekYwOEhXcXp1a0JkSXFVdXZW?=
 =?utf-8?B?Q0J1THhJVWl4WEFDZUp6ajk1TEMySWpaZExRNFpJelZSNElUU05nS213OEF2?=
 =?utf-8?B?TU9nZS8xdm1yOFJ0TFhYQzRHU0poZWtZWDVSWXN3Myt5Tm95Yi9odVFjbmMr?=
 =?utf-8?B?b2pYK0VqVUJPdHh5YXZZdlJCLzg3RlUwT2t6b0xxcE1MWElRdVNja3RDQnJT?=
 =?utf-8?B?M3FKN3FYdFc2K29zL2M3UTZPWkdoQXQxUCszUDNJMjdXc1Z3MTZocTVza0hu?=
 =?utf-8?B?OFRnb2kwRmdlRGNnTERudDBZeElCRXVBMUpsWEtLSkhjblM4b2lLMDhrRWJl?=
 =?utf-8?B?MC9oSDRXVXU2SDFZbHkrQ3FDVDVMMmVYZXNjb3JNT1JlazBnT1hIK2k3WldM?=
 =?utf-8?B?bzlNMVhNNVg3U3VIVCt6aUZPRDM2M2NKTVlBYjltZ1BjNXM4YnlYNWovQnJL?=
 =?utf-8?B?WmdwNFM4RkxTRkgxbkVkWHlDTmZmaUl1TkJqd2dFR2p6ei92Q0g4bmMwTjBj?=
 =?utf-8?B?REtwNmtFVHBuNkEzeDZsVzlmRHo3MzZjd2R2dz09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 15:35:13.0577
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: eccaa562-fb5a-4625-ecb2-08dd92fceb35
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000141.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7700

On Wed, 14 May 2025 15:04:06 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.91 release.
> There are 113 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 16 May 2025 12:55:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.91-rc2.gz
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
    116 tests:	116 pass, 0 fail

Linux version:	6.6.91-rc2-g477cfead3566
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
