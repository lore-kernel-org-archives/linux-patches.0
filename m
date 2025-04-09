Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2067.outbound.protection.outlook.com [40.107.220.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FBAB25B691
	for <patches@lists.linux.dev>; Wed,  9 Apr 2025 08:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744185653; cv=fail; b=K4UdB0+YW8Y928D5hE2+V4ieUF2gPLCtWx622Tz9G1OPXfOPjZwfP5j1Ez+bveGypp5gKNM+AM5Z0SAlgwMBlsW8+LRzogfV5lK4kYTtWliUG9xxcSfDrjuPVoDqjtbDt02SDFtJtSDJJaAWZk7kql+gV3D3YLF6gwh8+gu9QJ4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744185653; c=relaxed/simple;
	bh=Y8WVqo9tDG+VcCIdo5MaRs8DMr0QuI7lFX0gBs+e1YY=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=fEWiXjZcNK/yl8/sUF64fD3c8YfwKu7Q2OYPzqSMUpGWN46eDRjg2d3SGZNrwYYXT9pcbTjNAwkWszb3VRe4lJpUcyKo5+ml5Xe0QKDrxtePYg60XcVuPsVKI8TFllhGGcRHG1GbaB1KH7RFFASxSBd7cmdHFEcXR7anpURsjrI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=VYkyI4pZ; arc=fail smtp.client-ip=40.107.220.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="VYkyI4pZ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=usUFtWyFPFvKTo45FVvrqGrLHVznHE8G+Nmg04ojR2vWuqiwICl3JCMZWCbiZa+MxR4XcfvfiNIID5IVT4YwGbXKsUqHpxpnekWcgaOrNrLc5XDBqIjxmTr5B8CE0XwDCDFCZZSrn5LXnt1+8WnX3eLqR+owQTlApwpP8vTiZGp5FOOqM/AD37g6i2AK8wNy1Rrl2uCEp4wlv1EB3UF2c1Ow0fgyz8Z0Ip/f06SdH3eRPYgkwg4GYaifTRmD1ADadyYoTM8wnbjP9jcwmKggyLgU4ExpbpRijs6lYGlYLnL+xiMWhAE6KnU4hioVSDFRZ737so1dFbKddeodE0wQgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CG+H48f5ghHaFbzK1NsTD8JkhLK56KUuqqGQjC2rBmo=;
 b=zSxYF8a30QS5RxqqObuoz9I2BIlxmBDUNm3CSlL4s1wdLi2lqzKD8/D2kGC1vnFWxaCI26JPBnpTG+Ht9A1w/1NIC18nXDo4E8Bh6SnBZvqgmwO8EKLgEnptZsklaTubXmYvr8qjbFDBkGWbUKPbyyEY/CkIoCS9qVE4g+A8RgTmbnH9umZybKiZ7CGU/nI0C59J2aGtWSTncTXyYWI6BDh0sP84B9ybT4kilFj8jb/ev4oSWR7nPEtGfA1i1o7rxWWmzjaR/peoHPuQM7O65bNYV/8FlIOqeuT0BODLqr2PQ9NlrTSjkwSkvZW9bpZEzBRYMHzfYrCCVc7mUbzILg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CG+H48f5ghHaFbzK1NsTD8JkhLK56KUuqqGQjC2rBmo=;
 b=VYkyI4pZhH+Qr6yvKyrdtEw8XCx8JZw4lq4RaTOIrB8aufyVx2/xeDAEzRxZphwvqfdaQthhZ8MU6VlzcexH60kPQ3jqOToapVmqRTmH5BR/M5DfX6AEdI1+uoxBP1w1/gubm2YF7wQHJHu6db5GFMMSIPnkIwfe1tkTuDYFQPXW75S1WQ+oIZwvgWj6LK9KPx2LkJ1pl0m69+QsBRccO8TpKU6vnXxhE4Jd5rwehzFAOg1lHv4+S8J/LwrFmi8K2sr1sl+A7+dCsaQiElJArZDutFUy/HI7W6LBZO273/Zp6H4N7kZZvmRQoreQUvK6pbMB8YFAAnuRDvmmqceKTA==
Received: from SJ0PR13CA0011.namprd13.prod.outlook.com (2603:10b6:a03:2c0::16)
 by CH3PR12MB8076.namprd12.prod.outlook.com (2603:10b6:610:127::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.22; Wed, 9 Apr
 2025 08:00:46 +0000
Received: from SJ1PEPF00002321.namprd03.prod.outlook.com
 (2603:10b6:a03:2c0:cafe::f1) by SJ0PR13CA0011.outlook.office365.com
 (2603:10b6:a03:2c0::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8632.19 via Frontend Transport; Wed,
 9 Apr 2025 08:00:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ1PEPF00002321.mail.protection.outlook.com (10.167.242.91) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8606.22 via Frontend Transport; Wed, 9 Apr 2025 08:00:46 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 9 Apr 2025
 01:00:20 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 9 Apr
 2025 01:00:19 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 9 Apr 2025 01:00:19 -0700
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
Subject: Re: [PATCH 5.10 000/227] 5.10.236-rc1 review
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <a1eb8487-c4df-4a13-b68e-ccf16ab07d79@rnnvmail202.nvidia.com>
Date: Wed, 9 Apr 2025 01:00:19 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002321:EE_|CH3PR12MB8076:EE_
X-MS-Office365-Filtering-Correlation-Id: b4b775ba-41ee-4222-525d-08dd773ca25c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SEx2cjByVGJmWFdmbjBkTEhDZ3hpM1dNWm4ydExmaDl2SncwZVdOcENMQUN1?=
 =?utf-8?B?Nmc3SHo0YjIvZ1Z0MlpScVdNR29VczJrUk9rSDdDdTV5U2YwT1MrMzl6aDcx?=
 =?utf-8?B?M0ZKcDRidkROc01iZEwrRzVkVlExZ0E4UTBqSFFSenhwTHVVSktINWVaZmVq?=
 =?utf-8?B?WWxVb3drR1FLMGcrUVBoYXZCU2VPU2ZKREwwUjJvYzZJV1dtS3dpUERLNnZX?=
 =?utf-8?B?Vm1lZWNZY2NzS3REYVJmYksvdGFkU1BXVTd3TlZSd0xyb0E3Q0ttZ1dDWVV2?=
 =?utf-8?B?NEhOQWd0MHVpemw5VndsbTBYN1RLS3BNdW56UGtrY0cyaDBha055aCtkMDIv?=
 =?utf-8?B?bUFZOHgwWHd3NjNlOWVUYTd1dVRUSW5xQWJ5ZEFiUXZsZHprcmlRTk96MWI1?=
 =?utf-8?B?MXhnRUNRbkZMNE45Q1FQSDJCVG9CZDh6ZGVMOFFwRFp0SDRpU3paSlM5cmxN?=
 =?utf-8?B?VTJ1UGtlVWxkNlkwZjNFUmQvb0UzN3l6MXJUNEQyOHV6TXpPN0EyZGcwbkVu?=
 =?utf-8?B?b250YlNxSTdIaU1wUGdjb1J1SlNDSWZuYzkrQmhqaWs3ZzJtQ1plWVg1RUl5?=
 =?utf-8?B?Y1VJd0hvSzN0UlBIcnRzRjFBaVowZitlUVB2L3FHQXN4N1JTMGxKTjRwYlBR?=
 =?utf-8?B?ZzlMdDc0dGxKeEp3V0RtdHp6RWNONGZPOGNYaTZFWmZTRnNhMG9iUDhkbkI2?=
 =?utf-8?B?emJsRklhay84T2FSYTRxNWsrTmVUNGcvVXd6ZmFZNTdvS09IMXZ0V0Q1bTYy?=
 =?utf-8?B?VXJML3hkeTVPMnFmVUg1cEs2TlVJNGZwZzhUc0FJSUUzWGdFNmNDNWNvSlJF?=
 =?utf-8?B?UERoSUJHU3NBNld6dStTbVU4dEZYRjhNbXZoQktUekxvVGs3UHdxMVh0cDE5?=
 =?utf-8?B?ZVlQaktJMTFwOVdabUhWZ1Yrb3c0dm9hN3hyaUtKcWZlYUJWd1c4MUVKa2RT?=
 =?utf-8?B?bDVBQjFjak42TU15MUY4SWtTSU5WempqVnVia2pqSVMzUGk5bllhSWd6d0ZQ?=
 =?utf-8?B?ZGZkdGNrdDhQK3p3SHZveUxrVUdSdDYzRkVndkR2TjM3RmV5TzFJK2dpM1Bw?=
 =?utf-8?B?ODB0OHdPaTlmWTRCRWhucG5uQTVkeGVJN1BmUmpEd3ZRWVRLQ3N1Y0FjOHNa?=
 =?utf-8?B?WmZyaVJqTGJYV3FHQ0FlYnNiSG5ZSUwydGhHcTE2Ym9LUEtRVnM0V2dhbStM?=
 =?utf-8?B?N05PTllVM0YzdmJtZ3hWclNBd0pYQ2V4WHN2ZWlWczR4cFg4VmZ5VkJFSEth?=
 =?utf-8?B?RjJ0aDBOaHB0WXhySlRLK2lLc3pSUmRWVCs3dnltVGt6NzZzSGZwV0VLM3Ar?=
 =?utf-8?B?T2ZGVlRrU0c0dEFxbWpObHlvREVLZW0xUi92MnV0UGx6TlFDZHdmZGZRUWIr?=
 =?utf-8?B?SllpeCtKNE5DSUlIOUdDWGIxbXBPV2VXa2hSZVhxZjlhMU9ubUNMZ0dzQlNQ?=
 =?utf-8?B?bXE5UjFmWFNEa2NXQ0pWbmJCZEJjWG9XYWNhWWFhaW9tOHZjSVoxTkZVaEla?=
 =?utf-8?B?cm1jRlg3bVplS3BFZ3UyWXFmdEtYS2FVQ0JmMGJlR0tjR21Oa25iTmVQVUJB?=
 =?utf-8?B?dEZIYWx4YmxLVkFjOU5IaGcwZmQxTm5NdW8vYnhQdUhtMlhYbnllTS96L3ZN?=
 =?utf-8?B?bXAwRWJMUHBjeGl1UkhxMHU4QjNXS3c2dVNDNHZ5eUlNSEpVV2NNc3BPRm1T?=
 =?utf-8?B?SGtQOGlUU3k1SjJZdTE1ek1iUElUS2NHK3h5b21qWWc2V1dGZlc0TmNmSXV2?=
 =?utf-8?B?ZFdsQkNYMnY0SkV1Y1RtQlIzd3o3Z0JJemRRUHJaTWZCeDdZTHZLSm84WWVE?=
 =?utf-8?B?a2JuNXRrMVI4SW41d0tWT1VSWnludmIvdU5mMkxKQTNSa0pVNHhDVGhsR1gz?=
 =?utf-8?B?SW0zNVMwY0RrenNybktKb1VuaDZubkRkQzdqNDRHbFRxSGVXejNRYVphSjZa?=
 =?utf-8?B?aS9GbEtQeUJkcWRkMWcyb1pFZUNndFAxMWhvbTd0cFNDOUxUbEs4MFdESTBI?=
 =?utf-8?Q?lCUZYwNhuq0joRcSAV0aSH8HesuxV0=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2025 08:00:46.1087
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b4b775ba-41ee-4222-525d-08dd773ca25c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002321.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8076

On Tue, 08 Apr 2025 12:46:18 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.236 release.
> There are 227 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Apr 2025 10:47:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.236-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.10:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    67 tests:	67 pass, 0 fail

Linux version:	5.10.236-rc1-g327fc1af5609
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
