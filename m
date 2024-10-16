Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2058.outbound.protection.outlook.com [40.107.237.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A39621E3DC
	for <patches@lists.linux.dev>; Wed, 16 Oct 2024 10:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729072920; cv=fail; b=ldp67/Q6BUvpkMN5P8J+DDhFB00bJlusUmmV/+7YsG+QT/NAIg4/4MqZx4nQQSn/pFHEDD28X5xTSIBuFLMO5xZnOgKYwSsreSsLSU9PAEl/Jvz7CAMZAi12APwh87sOUk7JEDOf5Mm7NM4KPuq/jtJJqXLy2IJUzxaSVTKNuE0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729072920; c=relaxed/simple;
	bh=qN3MPICrfgOBAI14hfCyJDNKhhE3BN7igOUW+LeZ7TM=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=Dljt5HRWpHboKakC1UIQZpa/E7J2FxqZxI/p+5QK9OSLM07pUbmQqoOozbWF5QVVXiaQcMInHuAEd8fO/vOJZlfMOjIEpUc/pVRc1J+hEMGMhlhms6b6hA70bIFajkPaYCzxbSGfJe0c9FJlSMHv+1DDpySMo0LYppttgYWky8c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=RQVEG22g; arc=fail smtp.client-ip=40.107.237.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="RQVEG22g"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uFJVu9W0fBnbT25oGFYKRp6viuJ7Lc2rX58LYNQIBdDySC4gL2ftZNrEJhIUfjkFxVOCCqSvFHaXveqZvAy4tXspsIGF23wn/Zv+S4PZYoYD6CMJ+eA6MiNngMbQiQeO4uNbamVzI4aUXZRyOxgeyE5fJB+YHKXunfxsx2EmND+lQmJBFvxRqwZgVJ2kJrWvAV6R1YF3uKBGPXNwH1s4Ii8yo/GlIuG+WWW80OF+YtZyrGHrw5bQpWiUYOmjMCdbhUmUnkriBto8V19buzrADwUCNC0FONBg75tZLiBegVP3ZMcP/lvcq0HTHaSuOFPKKVuW1qeNYC5JF+N+neK/TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OCxD/S3IfHJb5938ewxcPDhAXW2DC5+snrGOt6pD4uE=;
 b=cXhUN24nOygJLIoxhkqwGyHibwqshHkSVaz/no019YfzMtwRZOGFS02zoKu7ueoLV1zQIyPMx879LXbgPszN/0UHj1K3TYsIJvIBpuUOPBpcMKFrqlYuPCGrihaxazqcmI+iuxWyNL0REpIq34ohLYPx9YaWtz6eKgzlHFeOO5WAz9EWDvoDluXXPXb/8BLag4+xuJ4/jTfUmx4TEnBWgcBdp+8odb3N9WyH4RHPSPf9DMr+gR/2kco24+0jE6qcY31ZqzSWz2xp5NJ9QEV0oEH3E42zuAxNysarwetbKNMQSPNBXPGq15XFEDl2GBWtGHxUKOi++sfbAcDRx+vaBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OCxD/S3IfHJb5938ewxcPDhAXW2DC5+snrGOt6pD4uE=;
 b=RQVEG22gDJMv4HgJwUTT93Il6VTBQ47jp0ycPV8Hof9/CaCKUVAXMOa7mavSxClKU63cLnbPKEeIVdn1qJIb8KfgOqpWyJplREa/qtc6dQllEiVIsiujmYqiFEKtJ4m8umf1xMJp/jmAn7vwQ/O4yhoXoA2zeUnSXCFJGtisBKxYjCKetW0hHuDx7QNIcrzNU+e09727dXCltyHJv4rPjEhJ0mordR+Rar8OODBb38eNLWYlZxOYQnGDAyaRf4fg9EXjJ38+uzHvsccvQRRKLr/ZEoCN6Bsb2aBaLlmwLafaD/pwMcU9Cjr8Po3olWJiSdEgFmsGlGeP4FZ7rN1lhA==
Received: from BN1PR12CA0017.namprd12.prod.outlook.com (2603:10b6:408:e1::22)
 by IA1PR12MB6602.namprd12.prod.outlook.com (2603:10b6:208:3a2::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.27; Wed, 16 Oct
 2024 10:01:55 +0000
Received: from MN1PEPF0000ECDA.namprd02.prod.outlook.com
 (2603:10b6:408:e1:cafe::57) by BN1PR12CA0017.outlook.office365.com
 (2603:10b6:408:e1::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.27 via Frontend
 Transport; Wed, 16 Oct 2024 10:01:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 MN1PEPF0000ECDA.mail.protection.outlook.com (10.167.242.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8069.17 via Frontend Transport; Wed, 16 Oct 2024 10:01:54 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 16 Oct
 2024 03:01:43 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 16 Oct
 2024 03:01:42 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Wed, 16 Oct 2024 03:01:42 -0700
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
Subject: Re: [PATCH 6.1 000/791] 6.1.113-rc2 review
In-Reply-To: <20241015112501.498328041@linuxfoundation.org>
References: <20241015112501.498328041@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <4b6be5de-c225-47ee-88a9-d49112e2a98b@rnnvmail203.nvidia.com>
Date: Wed, 16 Oct 2024 03:01:42 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECDA:EE_|IA1PR12MB6602:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e903b29-147d-4f6d-b13b-08dcedc990b1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700013|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aFE3T3lDMFJFMkc1aHAxUVVWR1ZOSFgyODE1NHFrQVZKaE0xL1lFb29DeFBi?=
 =?utf-8?B?SmVRYmtjQlI2SkJCek5YeFAzT1JoZ0VzYnNYaXRLUktLR3hPbW9ZOFA5UVd6?=
 =?utf-8?B?bFpGZ3hYWVUvVjJMS2V3dGdYZE12ZjRpajhBVU55LytiYkJZRXhsdFBLYTI5?=
 =?utf-8?B?Sk92NHdvNFBkKzkzbmg2VHNUNko3NytlVVFadWtkclNYa0lMM25XeVZiUUVF?=
 =?utf-8?B?MTYrTUlhUjZlVFkzVjRmYm1tSldzRzFXc2dtaWlIcEhqQml3UzlGbEpPNnNa?=
 =?utf-8?B?Sit5TGRJZlcvVlZzRnlSZXlDRWhIY0dndXh3UUkrUkY1Q09rV2pOaGROWUY2?=
 =?utf-8?B?UGtmcXNzSDduSjVMbDN0cy9aZ0xLcXgvY051NDZnT092bWdHT3BXRzlRY25B?=
 =?utf-8?B?SWE2aXpVYmZsY2FXVCtSZ0QxU0ZrNU5ZdW40VjVOWjdwR1VVQ2lJS2graXpq?=
 =?utf-8?B?VGRTOXJiMkRGUmtXWVU5eEs4MkdwWHdCMnZTQmh6clRzc2pHV2lkUGV3Q3dy?=
 =?utf-8?B?VlZTeGRRazhBa3N3eVhPY3k0emJRSlBxYTJOWjc2WjYwcFNjLzlGU0cvNDRT?=
 =?utf-8?B?NS9kbXZEdG9jREpiOW9ab1lwdCtOQzlEN01pMWNsVGlWcDd0cWVNN0JadDUr?=
 =?utf-8?B?Q3JTMWZtK1B5TDZZMkliWlFXajRrSDhIWU5VQmJ2a2RQQ2hUeWwxdnJITDgx?=
 =?utf-8?B?OVNkWUg1b2dRbGlVa20xZFpLKzd5SDFuczI3OGVxRnB3VXNRQnpNcUdTQi9j?=
 =?utf-8?B?eHNHRUpKVEt3VnZkd3VCbi9kcDRBZjMxYy9sZnJpRzQ3dGNBUk1BV1RTOFlG?=
 =?utf-8?B?aEdqR05GR3BoVzFNTngxb2hQSXY4eFNhWXNueHFnTGI2dUU3WVkzQmFnSHJs?=
 =?utf-8?B?NG1SUkdsTldRVU1WRFFSWGpRSmd3M2N3UUE5bUQ0SGtoYkk4d09nTEU3UmNn?=
 =?utf-8?B?RmVaaFVaSUpuUTd3RmR5UjcyVFc4dzJYc0V5SUY2cnRlL05JSkZMNk0weXh6?=
 =?utf-8?B?Z3VuT1NPR1BNTEVYVnh0cHVPVUh4aE5SWVhKUnY3NjR2VHdCRVBqLzF1VVlp?=
 =?utf-8?B?WlpCVFByZ0FKNVIwdURXWGo2KzV1aWlXZGRNaGl4V25CNlFDN0VxQ0plVk40?=
 =?utf-8?B?aGliSXB2U0swUU5wY0xXcXhMRkNqb0tlUnlsMlpQNTdidW9DVHNXWXdYMXRm?=
 =?utf-8?B?UlhZZXNVTXBQRktZR3pZT2FsUTlYSjNONytkVEtNaWkxYTJkYlZwc0Z3S0Mz?=
 =?utf-8?B?b3J2RWNuUENwVitDQkVsTUZSTFBEemUwN2Y5ZFlFNXplWkRjYnFnUWJRZ1pk?=
 =?utf-8?B?SWJJbmRWalZoVTJZcHZHd0dZVXZ1b1oxQzBKaHRaYkx4NUNkREJZWFcxZ3lJ?=
 =?utf-8?B?NUJ2bk1SVHhOcFo0b29kRWpFNHR3N2tVK2pmS2tqMHd2ZTFmWkFzVlh2cTNJ?=
 =?utf-8?B?OWZicjNLWjh1MHdHS1hYUmY1RWxhSmJVaEpFekFkVmFXRE1ZdDEyOEpUQmtN?=
 =?utf-8?B?UW9XQmw4eUdYazBPMGRZcFFIT0wrSFlYUnFablNYM1dNM2NGK2VyKzNpZVlK?=
 =?utf-8?B?ekVxbDl0aENtU2NMQUZLT3JsaWZ1N21vSEFGTEVDWmNEMlNuanQxby92VDdw?=
 =?utf-8?B?OWJNdnBueEluRHhwTCtXaHkraHpzTjYvTGRQNWpoZnphc0J3MlFxVmtPRnZl?=
 =?utf-8?B?V1R3eFJtYWxIU3FyMlRTWEhWMlVnUnhSUG5DUVhSSFdUTC80VW5lNXRoNllC?=
 =?utf-8?B?dExGR0pHMGN5S3NTMnVzQmhVRHRUQ1lESXJRNXFweForZnVGMDJ6S1JCbjlw?=
 =?utf-8?B?RmQrRjh2aHpsU2hVSTFsZmorWlZHYXFYMExZTW9MUEJ6NUk5ZkJVV04yS05z?=
 =?utf-8?Q?QIYt1snkClHZy?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700013)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2024 10:01:54.9666
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e903b29-147d-4f6d-b13b-08dcedc990b1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000ECDA.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6602

On Tue, 15 Oct 2024 13:26:04 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.113 release.
> There are 791 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 17 Oct 2024 11:22:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.113-rc2.gz
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
    26 boots:	26 pass, 0 fail
    115 tests:	115 pass, 0 fail

Linux version:	6.1.113-rc2-g7e3aa874350e
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
