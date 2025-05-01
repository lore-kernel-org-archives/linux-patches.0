Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2067.outbound.protection.outlook.com [40.107.243.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D41B82222C9
	for <patches@lists.linux.dev>; Thu,  1 May 2025 11:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746097677; cv=fail; b=LcvSCS8rxL3uLdR1WrAkZhCczTMDYCzV7413sCHo55amyO3mRFdOVBYJ712x07YEjf7FI8q2AeDOkCN0wbXak67PBZYucoTBH9lcpaN38uyJ2lRDF37dwZbCU2eGHsoOgYRKDwElE1e+yalyB03vKD7cOeS4FfSkVL4YRm3Vsw0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746097677; c=relaxed/simple;
	bh=HlTvxCZzGoo9EwJbJ1R9azCcSuubtXcfkI62+VxzBo4=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=SYYAuE4Lr7Cf20ZTCg14Py51uVeG9vHVzlX1R5Ojj02dmp0BvJQwW5jupmrmEM/tKplALXeqwQ936EJ8XyR7ixaQbe1Zb12MFV8EeucWQj3sKt61JdT/wcRAroXsS+7mj7Ah8nSdHZgoXOOl4uMjP9wDGHyxOn1CUZxRoJ3LV8M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hRFRxh7F; arc=fail smtp.client-ip=40.107.243.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hRFRxh7F"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AFaTmO028yOFE+8xwmSz4zfjO8Ft7yWcHnFN5qJkZfgISCaYAIKlYqGLGJZ7DbD6e6yKO5cN5maynU/jBps1mzv7nURfu4qCvav4Yb+Jjb2IZTGuQtUPmxyG6howHU0s1yLma51DD1Gk43gkreXX5O/KgFAHGJRcbgEfsKd8jTH/JYfMbKli/YxeU5r27EiJ0natRjK8jSu93V+Rvz/ymM+Xwe0DMY4xXw5Ilk0il11pr+ksmV/t/VYlBVBiI57XUVZYSpVJOO8g0b5bOnun+pPCAgx3ceGpweoVXeoXSDVDJP8JVWBBD7drc2rr2/dxuTQ6M74G7Rci5gyx22IUDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kn3fSA9i1dlW/BL89FYZimleEMYbrgqpLex1oiTzc5Q=;
 b=oHoBk2TJacJ8GwNH1hrb4PlqgZ0VWTHrciCd78/raBqJrSW9VqDTYoRFMGOA2uuJ+bmx5k14IqN+7Z6WQS2ZZG2AP/OlyN+GbeUo0bPW8hKtdtGf9nZ84ItWhPXsmp1geMVY3nppcTXOUPpIfhE91+3X6RZWAmjnOGL17k4/Ru5fFhh9F5ukobytengOy6MU/Rq13E+o/486ttYhklTUDwamahevhK8QtJ4TT9qsupoR9/Jt4ZQT4Ibdt5ehbii52/byVXEuWRHRlcjBRTzSHSERUy9ss0oM+R4Y8TByS8A7zuCsFdi5wvGulntzSeqqHXNCZU+c3MT69XB1ovSCyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kn3fSA9i1dlW/BL89FYZimleEMYbrgqpLex1oiTzc5Q=;
 b=hRFRxh7FZaolugD5Dv4WyyOwqhynYyNNS+vcs6OBT+NLqsb3c2u1HuzVNsqrwwvlOWzomDBf3Gf8nXfXE4loSQKercW1yLCQ41ker+OPrt+B8FCscR0+Up4rKmiO0gmizDH2p+MSiybCQ4l8jP1pd9PmfDQjvmRAqSyT9ZwihrpVo7zV3dy+JLsyqUhA532y8DaouEY9IIefMJFb9+aLAhUXxM3g7KrWtYZMbeHVuGYbe7uf0P4fER+yfQeg3zhRNV0XECi1LYlvbjjIeQOI7RWmuMD76vkESoFfDsGqpz2VmI9WBH8+F+k4ihEFIzYVlYH0hvVvZHaQB/lPJwYReQ==
Received: from BYAPR01CA0018.prod.exchangelabs.com (2603:10b6:a02:80::31) by
 PH7PR12MB5829.namprd12.prod.outlook.com (2603:10b6:510:1d4::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8699.20; Thu, 1 May 2025 11:07:52 +0000
Received: from CO1PEPF000075F0.namprd03.prod.outlook.com
 (2603:10b6:a02:80:cafe::cc) by BYAPR01CA0018.outlook.office365.com
 (2603:10b6:a02:80::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.41 via Frontend Transport; Thu,
 1 May 2025 11:07:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1PEPF000075F0.mail.protection.outlook.com (10.167.249.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8699.20 via Frontend Transport; Thu, 1 May 2025 11:07:51 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 1 May 2025
 04:07:35 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Thu, 1 May
 2025 04:07:35 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Thu, 1 May 2025 04:07:34 -0700
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
Subject: Re: [PATCH 6.1 000/157] 6.1.136-rc2 review
In-Reply-To: <20250501080849.930068482@linuxfoundation.org>
References: <20250501080849.930068482@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <28bb9577-0a7e-40a7-94e3-3621f8cf6c80@rnnvmail203.nvidia.com>
Date: Thu, 1 May 2025 04:07:34 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000075F0:EE_|PH7PR12MB5829:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b00ada4-4354-4e4c-726a-08dd88a06a6f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|1800799024|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NWNSRzhPSjltenRiUHpLK2ZlQy9VQ3RBMnRac0w4WnViUVIwK2tZWVp0UjhF?=
 =?utf-8?B?TTVKVEJsZXM2NXhudXhFZjI5TitESlpZNVNrTFM3eWxQRVRYMTc3UEE1MVRS?=
 =?utf-8?B?S3AydG9qQXBjaDZlbytOcXRlQ1Vtalh1U2J5bVdRUklmM3FlcVNDeHVvRXFl?=
 =?utf-8?B?UVhFOWJBenpEQlNZalFXMExkTTJWa1NxdHdNODdXT1BFL0R4cUtLUVM3QWVV?=
 =?utf-8?B?UENvZHNUZUtWa2RHcXBSaU5Eamg5bndnWUNiN200V1lENkNkdytsUWQ5eXdF?=
 =?utf-8?B?YXhzZDBaZXlzYW9sOWNsZnVQZzBvOG1HOFRhOGZmOW0wQjM4TzVybjNsT3FV?=
 =?utf-8?B?dTZXSVZFQndCdjFyTGxpNkNqSDBvc0tGRHhBY2taSmlDUGs3bDBBMHk1aWRQ?=
 =?utf-8?B?akx4ckZaQkQ4by9aUTdScVlkZnljd1JqcmVFekNjbkRWd0tmbnBJeWJ1WERW?=
 =?utf-8?B?WUxkVHdtaHozSFVaSGJhWXVWYlRrbUdpYk5obXBwYTF2VFZFNjJSamFxNkRz?=
 =?utf-8?B?SjYvNVB2Y2JQLzFuWitGVTBzWVJHdFZxUTIwQVFmdk92bkd3dUM2bjlsZkRa?=
 =?utf-8?B?Y3ZHd2xFRE5JbVhaR1MxV0p5U25LbUhWdFZ4ZUE1bURFS2FKM1dnNmF1YS9i?=
 =?utf-8?B?VWpucGFST01kS0ZEUEpUb3R5M2w4RWN6Z2VWMi9lQTJRd255cm5LZmFVNjNz?=
 =?utf-8?B?b0pBNzZPWXhnN3NNWmcvSStiTWNDK2ZpWWZhTjBZNHJTY0hYLzV4TEdQOE5t?=
 =?utf-8?B?UzlSOVZWaEUrSVpPU2VOeXRXMDNXeWlaYjRJcFdGUWVSWThiWklGc0F3Ykl0?=
 =?utf-8?B?YjhiZG96L2lJblRNa3ovbVFBRVgvSUgrMi9VamJ4d1h6U1IyUDB2QzZkL0g0?=
 =?utf-8?B?clM1cjRHTWc3bE9NZFVwVVBTR1I5aDhWL1VneWNENnlNTmFwaVovNjZobVFo?=
 =?utf-8?B?RUNIZkFkNnlwZGZKZ0pZMFBMU3VLQU5oTUIvc3R3bUVwclJ4Q1R0WXJFR1ow?=
 =?utf-8?B?SElqcmVoVDNEeGZvUG9GcWVUZDBwM2ZGaVc3TVFmQlFxaFNURit3bHJTVk1V?=
 =?utf-8?B?cXpxVkN6T3lmdTlnZFNXejBtSU9IUTU0R0tuUkJWMS83cDZSNzdBcmE2ZlBJ?=
 =?utf-8?B?M1crL2RLRUJLbWhFT2Jhei82Vit3ZGNlblVKUWlBVytzMys0WU13OXhlQzJO?=
 =?utf-8?B?SW9KREo3WXl1aE44U2d6QjZheWxsYW8yeUR1dUlLZ2QyZ2EyUWtteTFhL1BM?=
 =?utf-8?B?VDMwOVdXQ2N0bVhpTlpKcWRzdW1IRVB2MTdkQnYvNDloOVJWWjFkbExjM2x5?=
 =?utf-8?B?Q3NwUnM1elM0K3pFMlErZExwc3RsTHNoRHEzZDJkUVdRdFNyaFZGTHJTamVU?=
 =?utf-8?B?RzA4aHVGNVd0MndSWkNNN1krUndvcmNsb3VzajFYeGhpKzNtV0F0QTBPbjlF?=
 =?utf-8?B?SlAvYnE5aEhVK3FYenBRZGVvcVI5N3JSblQ1NDVnenpBTFF4aE5LYlpwUVBQ?=
 =?utf-8?B?cEVpTllqZmwwZDU4SFZEaW1BVFUrcVU5dnlnMDlXTjlYdk40b2g3WHpDMnZs?=
 =?utf-8?B?azhoK0FEWjZMVU55ejhSS051QU1sdDZ4d2ZMZU5JUnhIWWVrOEgyZDdHSFZj?=
 =?utf-8?B?b2RtMVdaMDA4NmUxTkY5Y2IxSlFtWE5GTTNNbkprTTRxU2YxTUR3RHF0clkx?=
 =?utf-8?B?Vm9GUVZNZ2JyUjNneHNVQ0JMSmFwY3M1bGdxM2FBLzJDQzgwTGZtR1BXb2cv?=
 =?utf-8?B?dHZvRWo2SmJHR0g4RUFURHFKTXJMVHlpNXNxZ0pxeDJRcGFFTlZIR3ZFbXAr?=
 =?utf-8?B?ZDlzTDdUcHFtUGI0M2RoeDRJcndkVnF6M3ExZ2tUVXR1b05CRU9PQ2JTb2h1?=
 =?utf-8?B?UGhpLzRqejAyZXU2aldtWjlVckE3My9RSi9JZmhIUTBROGtjTjdCOUNFWUpD?=
 =?utf-8?B?aTVBcUUyVmlKUTVXcjZuVjcxWU9rQVNZZVJmTWR3bUNsUGhmaUtKVnRPeElI?=
 =?utf-8?B?YkgvMGpSVlpVWG1BS2pqd09ncmlPS1BhTXJZSVpJd2krNVN2NllzcTZRblZO?=
 =?utf-8?B?bUU0WWt1eUR3S3JoSll5M1VpYTlpd256SzdzUT09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(1800799024)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2025 11:07:51.6769
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b00ada4-4354-4e4c-726a-08dd88a06a6f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000075F0.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5829

On Thu, 01 May 2025 10:14:15 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.136 release.
> There are 157 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 03 May 2025 08:08:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.136-rc2.gz
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

Linux version:	6.1.136-rc2-gcc42c3189901
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
