Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2086.outbound.protection.outlook.com [40.107.236.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6633C22F145
	for <patches@lists.linux.dev>; Tue, 11 Mar 2025 09:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741687189; cv=fail; b=uXHXcaRDV6xb9DAS6ivvB++Eko26K8yiUPxnZ7c30qGtiSOszPA4rKdl0FjCOKtcV6D6qwFSkp9HV1pcGPja1F7hRwyshQadiENtoBga+33UEOL86DMBUo6tQ4XZAWhaq4w2QiP266xBzvWpXw3rE22CXr7MePAjQq6dEXBoHxE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741687189; c=relaxed/simple;
	bh=Iv8n/BeYixegh11X/V6I1rSdEAoxW5BkjLXPBKaIW9c=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=clIRZCqu1v7Q8gL6W3y2EV/4x7F2CiJjOT5reP+OCw8LMm4oFnUGduCjsF2Xlfzxm7PCiUwjxMb/CrkD+acIxw94W6siWg7jZVTXxVSTbHyRgcvy5yr8e+DmivyhFHqx1R9I/RJR5Qnbvva5ihxwWehFxtNoutj7wnMDkwAxjxI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=sUcbYDTA; arc=fail smtp.client-ip=40.107.236.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="sUcbYDTA"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CbEut2Hurbkt7andYbbTPP/6wQwd0ke4RZj9wXCAUlGH4z/aLtxrJGBWM3XReOfQVfXSz21HjQ58BYMME2xjg/9SsgR5p0vMDYrI1lZBA54U9whwRY4vto60qRaPOkGSQTQXZx/8rQGRYS1ecSWybxZiDszAkblcZ8GRkrJ/J9W0Hk79Ndv9KMTn4hQ4KDcNQiyWu/PZemAAoKl+TUGHRvox5RbLokwCSluEKGFuZBR4ueuQQPwcTRh6Zr+WMkYISRrZ+rN7UwY88+WZaun/d6sWGUE+iZol4sy+sWhwO7f0cLplQoQJWniPYC5XcPvndkPyYGzaeYLDM1VAIK9LLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TC1VRL6PlCmIq/ZTolM0uwoLs5kBO5DVgR7tM77KzpQ=;
 b=GjbMGmdqBDL6NsiObVpFspJLKBtaPbNPv6mDKOYTiewWLh1CTt4spEYVfL/F730twVISrTetj+BNeg96UBX/MittplHG7jlSpoFpTdFQ51cxfTXWH1cA6wsBvUwyafr2nMQcd4VMaVp5/O4B5hM4T8vZpuDlSP1brxiq/kTFt4NNR0TmsBQdK4GBCaut74mEhJhWdh0ULcXgaWfR6muZhC2x4dft5ZmNYC9j/JJqn3WWwgg5dmKbWjSG5LKtYQdtKMB1x81wQK1J8RLC2+KRyokmWp/SSLibqS3Y2fcwc5eeaFM1FpCwr/uyIdAVS0T2i0M5q5NvEwAFqNiFQ96f7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TC1VRL6PlCmIq/ZTolM0uwoLs5kBO5DVgR7tM77KzpQ=;
 b=sUcbYDTA9cg5pHrvEFIYn6k9srU0ok4PpAna/Yja4LX4NxFSEWP5BzMCPEeG0g8Ky9OHXf/LSChlP3/2TgcTvA2RxzTqelasnTRmqN6oILUrntjmh9lFFWqiEideQ3kc44ixsX5hXTQIHswCIP6Rz0gld42Jbd4SKYzW8h6EjzK3uTwTryEi/DZofjIJ3VJFDODur+O/r0nvIGxm0ZwRbAiQRpJQbE8p8czt3nzgS0Ek2pmJyQfDikCmJ7Ds0/MqPR3JAMjUFLNLWhxBFWb/2z2CXXvGYVrHZ8+VeQxiGxNwPHlbbUoKDRIQN8D4uwS5FGfojURVCiyecDJeRdC9uQ==
Received: from PH7PR03CA0006.namprd03.prod.outlook.com (2603:10b6:510:339::25)
 by IA1PR12MB8080.namprd12.prod.outlook.com (2603:10b6:208:3fd::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.26; Tue, 11 Mar
 2025 09:59:44 +0000
Received: from SA2PEPF000015C9.namprd03.prod.outlook.com
 (2603:10b6:510:339:cafe::b7) by PH7PR03CA0006.outlook.office365.com
 (2603:10b6:510:339::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8511.16 via Frontend Transport; Tue,
 11 Mar 2025 09:59:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SA2PEPF000015C9.mail.protection.outlook.com (10.167.241.199) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8534.20 via Frontend Transport; Tue, 11 Mar 2025 09:59:43 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 11 Mar
 2025 02:59:29 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Tue, 11 Mar
 2025 02:59:29 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Tue, 11 Mar 2025 02:59:29 -0700
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
Subject: Re: [PATCH 6.13 000/207] 6.13.7-rc1 review
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <e696139f-a5df-4508-ab4a-564a75d11948@rnnvmail205.nvidia.com>
Date: Tue, 11 Mar 2025 02:59:29 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF000015C9:EE_|IA1PR12MB8080:EE_
X-MS-Office365-Filtering-Correlation-Id: a79fdf7d-fce6-41f7-d7f6-08dd608372cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?L0RieG1jTUtDRFlXMi9nN2lROXV4MS9CQjR3R2l5TzF0NzRxeUlDV0xqK2o2?=
 =?utf-8?B?eDFnaUJCdEhNUlQ3bjBnMGQxaGIxang0OWRLS1Bhb21VSklXNEJsclp1M3Bm?=
 =?utf-8?B?c1ZHa3F6TVBza3NoTnl5aFR1N0lvRmhpSm5sZjFQdzhKanRRN2VPMDBXMmlZ?=
 =?utf-8?B?ZjZScFI3aGRicW5kZGlPZG9STDdsenZMa3J6YUZGNUVmanpEYm83c0ZGKzBI?=
 =?utf-8?B?TnpDWC93elJsRnlySEkrTXlFcmlDVlhhNm5LVzA2MEZuQkVTM0IzeUt5Um1k?=
 =?utf-8?B?WHZaZXdzK0ZDSjJ6bWxnTEhncUVocnlnQ3NyQU1BVkp6T2drMjQ4cmFQUEl1?=
 =?utf-8?B?TnJjUyttRjFiUkdESFpZS1RjUUVQY1U1eGl2UGNiOERVWHRSSzBQckZVZXc2?=
 =?utf-8?B?WDF6Z1VRT0xFMkNwVTBvc1VncDBNbThMZGtQa0ZiaGlMU1FxcGhqYXd3Um1E?=
 =?utf-8?B?Q00vWGVQK0xDZGtITENSYmMyM2treXhLZEk4Z3NhU3Rha21GRXhubXI2ZUZa?=
 =?utf-8?B?WGFybDhaY3hzUmVZQzFnR05iNVd1TG5BOFZKTmR3L2R6cjU1cjZrVjVPZTJ1?=
 =?utf-8?B?dzEzRFJFTDk5TnlySTNOREk1emFhSnNqY0FxSXNleUVCV1EvS1RQODZFOHg4?=
 =?utf-8?B?dEZUMytlM2RiQzZKMzcyNS9jbHhJcVI4bS91QjlMOUdPOHVJV3NxRGtZbmpE?=
 =?utf-8?B?cEtTbWo0SUtSSG5KRU41VUdwMysxYTBwS0JnZEY0N1JEZ3prdkU1aFpFZjJJ?=
 =?utf-8?B?VEEyNkMxR0RUbzlFMXBlSGdyRWdqNVA5YVZmS0hDUS9TdlU5OFhtQTJzL0hh?=
 =?utf-8?B?ZkVvT1QvL2FrNmxvR1pLOGpacEJoRDJBSkFBdW13Qy8zMUdqZEh6UlhCSTNK?=
 =?utf-8?B?bXRkS1FmKzB1Q1YyQVVDU2tvZWJDakRvRXdTR3h0R00zc2phRC9DWXkvdVlF?=
 =?utf-8?B?dXRyNzd0Nk03WmlKRStkNzdGV2NUNEZwT2NQY0k0bE9IS3FNRDJNSUlYa3gy?=
 =?utf-8?B?ZGxobnNSRXV3bHFhZWt0dXRqUFZLUkFDTzdUdEtQc2gyclVGVVdkSEFEOGF6?=
 =?utf-8?B?OTJKVlVpNmp6czZ5Q1BWQ09jMlVKbThla2FsQlhGaUIzZ1lRQmZhZ2xlbnhp?=
 =?utf-8?B?aU5xRDZmZmwxY2hoRHhHZTZ1bUNYMUIrajd4TXNQcnlWRWtEajlDTy9RNzZ2?=
 =?utf-8?B?WlRoaEFpeGlaYTdUWEp4NC94N01wcHVMdy9kNklWV2ZKSVNRZ00ydTI2UE0z?=
 =?utf-8?B?VHRJWGZ0SE51R25pdU1vWnQzMmJBT1BIZk9HR2EyTEhqR1YwaDRMV281TDVZ?=
 =?utf-8?B?OS81UHBwS1JOeC9ENzJ1c1ZjbnlneFlaVVhVNnRTZHhZbWxqNTlmazJLTzhJ?=
 =?utf-8?B?aWVaN2Z2MGxtQisxNTNCWXNXV09Xd2dFK3ZJdXNnUEJZQmZ0RUN1a3FMekRD?=
 =?utf-8?B?bGhwaEtXQUJQTllOaEVBZ2tTQWpJUUlVRDIyYWVPcDNWSW9UYmNvQXIxOGpM?=
 =?utf-8?B?TXdMVGpUMTUyc0dKNGpnQjF0Vzd5UHFDYmswZmhtZE5HTm5YelE4Wms3KzFJ?=
 =?utf-8?B?NCtobWh1Q0hHVVJtTGVremhSL1J3U1B5MlpwdUs3RU9lSVh4eE8zZkczTExq?=
 =?utf-8?B?MytDbXNKbGJSeWNaNnZISG5Ibm9TT3p4Y0k1a3ZsRk9rVDdtMXRad1FGdW1M?=
 =?utf-8?B?ZXJDMjBYOXh2VUNxUnY3bDcvK1Z0Q2FNSU5KWTdyV3plNXAxaGdKTkhocmo2?=
 =?utf-8?B?OTBYdFNSV29lNnk3YmZYQ2tPVmxKZWVPUjR1RkdPcGNSdE5yc0VLS3Y0OXR3?=
 =?utf-8?B?clE3QjcvRHlzcUUzSFRlZVNXb2xRZyt3TXRSRU5HVHlscTNBSlVOKzRoZm9D?=
 =?utf-8?B?OExNSDhyYk9GUW9QWkJuVWRJOU1PTmh5SlZCbjhmbzI1RlZIN2dodVVnV3RP?=
 =?utf-8?B?T0VIaWNJb2pvK3JjOUc2OGJkNytwU01Sd2pXMGRwWmxvTzFuVkxnT0FVbjl2?=
 =?utf-8?Q?EiL8EjK1zG39S5nzmIJAzcTUrIO6bE=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2025 09:59:43.7925
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a79fdf7d-fce6-41f7-d7f6-08dd608372cc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF000015C9.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8080

On Mon, 10 Mar 2025 18:03:13 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.7 release.
> There are 207 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Mar 2025 17:04:00 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.13.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.13:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.13.7-rc1-g2fe515e18cba
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
