Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2048.outbound.protection.outlook.com [40.107.100.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F56B261573
	for <patches@lists.linux.dev>; Wed, 14 May 2025 15:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747236928; cv=fail; b=WHhm9O8ZM2ssSDQL3GRn9JfDa37EzGqBt77jUXht+f4HABFuiLOW6m+UHrjiFcupXkih2VMT+zyeq/lW/r5y081gCi7pjIuIGP2rFHzz7xPFMKlfFrOSO/wxaaO4jccnAXlPmR7ISin3teJ+eA6wYz7NL/nZOh7JLjA3WdLvV6Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747236928; c=relaxed/simple;
	bh=a4iZknHilvqVyGoLaZrmykkv8iYvRODMdhLg/qY2Ae8=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=TJbTWMRhDUQTrFD8BovFSperFVc+V5ui4s+oYlEvQMhSBWUeZRsoUsF68lJV0W+M+/bj895yPcoiKU98lQ6PdM2UHHSsRqkRNxFYtWDp9qzWCjTHoYvTbWp1FOyy5RNWAG3udrKxiaU4Jqr0u8dnJU8HHCadohqlmXp7rOi7ASc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BGNE+aNG; arc=fail smtp.client-ip=40.107.100.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BGNE+aNG"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vP8o8PUaGr0OvYOhsPyBuJ6pyQW2lhkd71f3DNZbGYshGnZFUB+uFDf40akjc+OMhJMkCf1KgxuqLW1qO/sHJq0GYz6lVTab2YwdNTRtiw71njqsHd3HxH89bYzw4IZnKa37F5WfsfTUjn1mOsLJ+C7QcHDxbhOUD++Ldo0UbnHKikCq8iQbL0bA6HfWs5dGgYLkM+1NGGbwoImm4z0q4GvotNK93WoVMsxDUUbHyWcETxBhuAUIJlEPrGtdyYNsU97+MHTc7X2ZLR67PCstQrRtGCn9+V2prCvPjlL8dqWN9LZ5TtADAVLiWKGmX/RNCKglUsGSrq3kIvydQZDwwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n592IKgeyOSDcJHtSfJpHw1EPthsPizc906ru1HkcKM=;
 b=mhwg/ODwzD8k+/plLRPK0IdD62dIhpEezuEFdJXxZqfW2c8kXzdUAWzGXPdVFQ9OjoPnBme98GEHdZvSoVU+yfX7gYK99kzlrmUNbqejYEMWceVg/VEokSZkEW+w3/hStLD2f54xLYDL5oXibY1pavwWGPmQzY4oopzmnjvpP9pPHlWuartaF8ISXDpl6LevCGTIAZVCPuQftRL7W9GE0ewzsL+aglfIq3MA0nv95dDMW00n5dVEg2b7BHSftjsnLuqeHYGf5aEueuIMqWxQcZqT7AooEDmMu6O3jSCufJHx0g6jo4gTCBVdHIY/EEpMsOzwFXlBjh78VSjMMeRcbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n592IKgeyOSDcJHtSfJpHw1EPthsPizc906ru1HkcKM=;
 b=BGNE+aNGG2zR0mhh+CewVZSZU6YJhq5sQQB1sNiN/HRJPJpFvYIpAItYVFnLx1sTiv+SFEn5OiP+J/N6VsqURElfUK4F9X5iG8snoisPII9zKXSwnD9teCGr8J2TnIYag5O2l6/iEEz9llj6Ou+vELUyeJivw88ofn88I6T45o653CsYnpTvc5A0KQBH89PksNiIK+CpscZh9Wp3Gytt0bXSPaRSmHpklaWH6oHAXPp8g50uC/gSFnoWNk5BRVcSO/FUzLVdWNyrkOIbt8c0s29WwAlYCaq/YsWFrYlw19fwXwNBhuWqoIksCDPjVRCC6kwPvVU+pkOqbyoQokNMcQ==
Received: from BN1PR13CA0030.namprd13.prod.outlook.com (2603:10b6:408:e2::35)
 by PH8PR12MB7376.namprd12.prod.outlook.com (2603:10b6:510:214::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.29; Wed, 14 May
 2025 15:35:22 +0000
Received: from BL6PEPF00020E63.namprd04.prod.outlook.com
 (2603:10b6:408:e2:cafe::ae) by BN1PR13CA0030.outlook.office365.com
 (2603:10b6:408:e2::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8722.20 via Frontend Transport; Wed,
 14 May 2025 15:35:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BL6PEPF00020E63.mail.protection.outlook.com (10.167.249.24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8722.18 via Frontend Transport; Wed, 14 May 2025 15:35:21 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 14 May
 2025 08:35:06 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 14 May 2025 08:35:06 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 14 May 2025 08:35:06 -0700
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
Subject: Re: [PATCH 6.12 000/184] 6.12.29-rc2 review
In-Reply-To: <20250514125624.330060065@linuxfoundation.org>
References: <20250514125624.330060065@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <f1752185-d3ae-4439-98ef-07f3bb0e1013@drhqmail201.nvidia.com>
Date: Wed, 14 May 2025 08:35:06 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E63:EE_|PH8PR12MB7376:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d5a5ae7-1379-40e3-9f57-08dd92fcf08d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZVE5ZVJlbnZNbU9WK3dMb3Y2TSthMTVzeVhXWnVyMHpTb0pMZHRkWEFENkRk?=
 =?utf-8?B?T3VQZTdsSE45ZE9NUENLVCtpNFNmWTZpTWNNVm15ZG9KcThPV1hDNHZpSjVi?=
 =?utf-8?B?dkZ3bENLK3FyQVRzNmhtVXIwbEVLN01rdGNCSTBBaFhZVlNKNm5xK0trQ2NY?=
 =?utf-8?B?ZGR6dVVmQ1pmaFpIaE9GZFozTFFtTkJ0T2wvRkFRWTNnNkJWQ21JaTBVQ3Rs?=
 =?utf-8?B?WDhrRHc0UThXRzJVcEMwUXg0WkpsTm1YOW9jbHFRako3Q0o0ZUhMQ1BiamlF?=
 =?utf-8?B?d1ViU3hKdlVZdVBSYVBZQmhiVU5jTHJLL3U4OThJU3NYd25VRTZFQlF1VlVk?=
 =?utf-8?B?YmxpSndHbGZKNDlXL3hUbTY0VFU4N1FlTXZkazJzd3BhWWljb3p6L3dHTGI4?=
 =?utf-8?B?M0d6QTlxQkJtbi9NUStQcmZYVmVPWXlkZXc3bGRieUppeU1aaWJoKzA5OU5Z?=
 =?utf-8?B?ek1UMGZjRER5Sm1rZlU3Z1FweEFxdktBSHFDbmZPVG1uNUpHMlVNSjd5VWkr?=
 =?utf-8?B?c04yb1lDVlIvZG1IU0phdmlxWlVDNlBqVXZWNExjdldzTWxwNHVBR3djUUtu?=
 =?utf-8?B?L2NVaHZMRzFLR2FRa2xYMFFDVnhrY3hDTzNGd1pYQVZ1N3VTQ2hackJldTNq?=
 =?utf-8?B?ODdZemR4Yk8rN0xGNVRvRW8xRThFUDF0ZitZS0M0Yk4wb1JnRkQreUNBSXFF?=
 =?utf-8?B?bU9tcVVmRUlHNGpBSGRPM0JKU0ZFQlZWWlBtZE9VREN6bkQ5Mi95Ym1jOVFW?=
 =?utf-8?B?UEZaS3lVT3BndWhkN2VjYTQybW40ZWU2b3hCMmxNMjFiZlp1TVA1UmtidTEz?=
 =?utf-8?B?NDQ2WDg4NXdTUWtkTE11bEZ3U3Z5cGE2Y0FoZnlPRGZiNjNDR0JwNUp4YjEv?=
 =?utf-8?B?azQrSk1HUFJWVkFWaFB3L2xLZzRDZ1FwaDh4MVRHM21SZVd1UitYU0hWVytt?=
 =?utf-8?B?am9qdkRpT3VKZHhNNklqaWEzWDVYVkNzWmpoblpnOTlZVWt6UE5laDNtdFBK?=
 =?utf-8?B?N095dVVHbWpETXNHUjRDVElhbjJpRjZVOU1JZkIvdnBWQitNRVZQUUIraVAz?=
 =?utf-8?B?UFJOdklBMjM2cGh1bzc5empIcUZqYUVtSUhSUW1qOHoyT2QzSDlYWmNZYjVS?=
 =?utf-8?B?WnhOWE54QWVqb044VUtSUktQRHdrdGpGSzQ0aVVoelRVaXRPdFdMakRQVUsr?=
 =?utf-8?B?bmJzVXJEdmExenp0b2NFYXcxUmJsVWFDczU1bDQ5Ly94OWEvbDhVcGdpQ00v?=
 =?utf-8?B?QnhzWlZtdXBmYlVyTmxoOEYvSW9hNm1NaG4zdU0vK1Y4emZ5N29JeStOMFVQ?=
 =?utf-8?B?SDdKcWNkVjZBZzF5dGtQd1ZIbkxFTkNnR0trRVJwRnFNZ0ZpL0Jsc25jUk92?=
 =?utf-8?B?R2xML0NKM2FRVVRGZzBIMlhKblJlNFFCeDZ3T09LZmRtUGZGKzJwdmtIZGpv?=
 =?utf-8?B?M3FBWE44aEVKQWxmYTA1djdoN1BsNW1DNnk2N21DcCtqS1ZGR1N6QmFtZG03?=
 =?utf-8?B?UkhkRUYwY2pISmpBeUJqZXRBRmRsU1Vrc2loZm1xclV3VGg3RVVBTmlVUVhV?=
 =?utf-8?B?M0toQ0FFQ0VjN0JFWEJZS1pCMzRXUWtzcUtrVXNiVGc0ejIwVkVEd1Bnd0E5?=
 =?utf-8?B?bUZjQXZaU1lmMkI5SHA4MWpHYXdLVUlyUjdCTXkxYmZjcFdGa3pMMmovMVhr?=
 =?utf-8?B?cjBWVGh3dnNIb1pibUhrUG1lMXVFNW9ITExnS3lWeUlrTGM4ZXFpZWpKNGtx?=
 =?utf-8?B?M1piekppR1g1QWdJVGduMU5STmlYSmhxQXR6Qk9lMjFSRHg5YUJoOThKenV1?=
 =?utf-8?B?U1dyVWJ2ckF6bmpwdUNCcWlTQ3lZU0dvTGZoMGIvbEN6VE5JRERxOUZxODBm?=
 =?utf-8?B?ek9KUWU1QWNqSUh4ZzBkb3MwT1BPTnIzY1k3NWYyMlQyTGV4WkJZVmFwQzhY?=
 =?utf-8?B?OU9ZZUtPck85K01ZUm9OY3BlSE9GUk5lNUw5WlN5SUZicXJ4NDhSN1dQci9q?=
 =?utf-8?B?RHNBeEJpYk04Y0U1SUFnL08ycXZYakxnWEdSd1VCMHdLcmVxRFo3UFZGM0Zk?=
 =?utf-8?B?c3hLalFiY1NNaDZpYi9Qc0tLeWR3cDA3Szhjdz09?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 15:35:21.9764
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d5a5ae7-1379-40e3-9f57-08dd92fcf08d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E63.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7376

On Wed, 14 May 2025 15:03:56 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.29 release.
> There are 184 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 16 May 2025 12:55:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.29-rc2.gz
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
    28 boots:	28 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.12.29-rc2-gf7cb35cbafc5
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
