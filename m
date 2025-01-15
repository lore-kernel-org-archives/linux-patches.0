Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2069.outbound.protection.outlook.com [40.107.223.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 794EE433C0
	for <patches@lists.linux.dev>; Wed, 15 Jan 2025 14:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736950437; cv=fail; b=oFzGDW/rJq6uAF8849DYXnJAMo2XlP4py5ktLCOURiwC5zSWQEjJgMVsdobWvdAuqZf2yTDNwS+qy+Jj4nGc+FNDyNuXbL8t1QYj/vpIBmQx1nXrbjv7roF0nes0HDMLgQJAjhX5EFJ04qMXli9D7UgphoUfto35e5V9ZAnQFbk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736950437; c=relaxed/simple;
	bh=jFo1xYQ4Los4DruwYbpXM6o/cLHTVantkr3sLm7gFvw=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=Gv75hpyguB2faJ1MjpTFI9guZqIOH49bikVQY1GVBTrFe05mx+2GFhALTG/fl3i8Mgu45lSbgBcZq8q+leKOgA8NW1eUmg5qF8QUopUn5JmG3zjNNzkQFL1XUg99z0XEwwjknP7QCzkuWm2r9/vyc0vCrJh0IIGMbIJR1hXjiMA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=VrvvLe5o; arc=fail smtp.client-ip=40.107.223.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="VrvvLe5o"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t+WcnpDjYFuOwpm/9E5RkQ8MMNyd0sxxtrMjgxVom2CvWAE6lfrs1Yu4XwMRUr4ksupVbZCjJDhCxfjTyEkAoCeD6aXeTcBoK+H4nrj0YVZNX7NgiQd4mijmor/+4XO1AtaKsw+z6WyQfVjw/5s3wMcINCE7PiKsWjDnRAR/E5xrf+8wgHAJ2N+3LXZ3pEHiajFK/OuN5ix6El4qeiuiDlv3seLoQ+JEbN+dPgbxkCkCQ9SJKCqiHidqB6Etnt7kI8eLfxFxMwmS/u3E6GBngPsiwv7cgyUHclj9Yh1cAuGFqKrlC3K+v2geEI/QgA5I4NlMoyUbYN5686iOLkG8UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4eTBXIZwtFlXFInzeDL2pCCqCDwT+avdbkmkjXBulHU=;
 b=YCDtkbigLGkS7Blbzg28knB3ARPRz2OLbCsoejYVwC3+sjDv+n90f3fWN+a831q61yqO6QiWZcpI8SlzmAmukRpbSzTLJAG3KbwAovuw0nR4dkyGLauNqXJDqTw24h4HwIW5Fhbnjt/AA8i7jOy9+B2ro7QsuJbtGqtjfgJvWs3bjqMNgMxd70bPU8xQIbw+QPXaZKV1qnxnDyXLSIIrkl9e8UvQ7UHZOabHqwhvOwppELkW4DDWM9ieHjU0LOm8OLfqmbjuWPUYhDx6SPjL1Tvx/tVvt/MeqQ12ci29I7NEe3CtVR21XPrL7Xidua1UX8O+V0jPKIxlJTEHkdB75w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4eTBXIZwtFlXFInzeDL2pCCqCDwT+avdbkmkjXBulHU=;
 b=VrvvLe5oaEMn6RSxUf5ohE8hSbsVtF9ABOFXmHkiwgXhDEuefxGSRRIt+edWyX+0crT+jWvgsT0Hdt0351X2uCB5Euq4hVU2a/4a7kyEiDNtbkIiHeBB416SCGbLayHySJGv4B6VZTEZ+sM4oja9NqMEiY6x78lUwtVWBV3sn2yzWMQag+7tytjHpF4lPlAaYutfl7lpTaRg1XPgqV2013bNEjAEYznvyp3xFj+vmujiOWzUOzYgSPXV3VlF65r0WBIUrhvh1oBadxJ1yUVP4+bdHVuAg3DoYoDiaiigVW8XNT3KPZbQlNjlJjSQSRn6I3EwpQ2ARuFK8iZcvCf7Rw==
Received: from PH8PR15CA0011.namprd15.prod.outlook.com (2603:10b6:510:2d2::28)
 by DS0PR12MB6558.namprd12.prod.outlook.com (2603:10b6:8:d2::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.13; Wed, 15 Jan
 2025 14:13:51 +0000
Received: from CY4PEPF0000EE34.namprd05.prod.outlook.com
 (2603:10b6:510:2d2:cafe::d0) by PH8PR15CA0011.outlook.office365.com
 (2603:10b6:510:2d2::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8356.13 via Frontend Transport; Wed,
 15 Jan 2025 14:13:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY4PEPF0000EE34.mail.protection.outlook.com (10.167.242.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8356.11 via Frontend Transport; Wed, 15 Jan 2025 14:13:50 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 15 Jan
 2025 06:13:38 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 15 Jan
 2025 06:13:37 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Wed, 15 Jan 2025 06:13:37 -0800
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
Subject: Re: [PATCH 6.6 000/129] 6.6.72-rc1 review
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <f91f535b-f4fa-455b-b845-5ca12008db32@rnnvmail202.nvidia.com>
Date: Wed, 15 Jan 2025 06:13:37 -0800
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE34:EE_|DS0PR12MB6558:EE_
X-MS-Office365-Filtering-Correlation-Id: dd751503-e510-42fe-57a4-08dd356ed5d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|36860700013|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Y3k5RFdQM3NaN1pGU2FCSm4vSlJFL2xiQnNlQ0FxcGJpTlBqd2xaSG5KbjJS?=
 =?utf-8?B?dTl4N2d5ajBLTFBIWUdlazlzekFNdVE4ODB5RkFzaU52NlVaV2pjV0NOd2xl?=
 =?utf-8?B?WW1weWd2VXMraTZGb0JZRTNIL2N3aFloc1pjRVR3VVRUbXAzL3BVM2hjVmdV?=
 =?utf-8?B?V2hDSHppd21kQXJnY1Y5UmlyS000RWxvTVhLZGR3QVFsMmR0S2Ftd2F3dVBF?=
 =?utf-8?B?TTRkT0Y3a0VUT2dPcUV1QVNtQi9GaEx2OERaRTZDK1hJcGJtdWxkWmNodm54?=
 =?utf-8?B?bHoyNDJ4WWpXVXBBdjZiL0NXNXRZMTl5cDVnZzJDemRUN2VlOHQ0S1ZwNkVH?=
 =?utf-8?B?bzd4SnBHR1VlUEFFVHhDeTh5YjBGRUVENzZ2VFpBeUtWbmd2SnY4ajZuc2hP?=
 =?utf-8?B?Uyt4RW9DZmFXMHE3TkpsZ1BjMmI1ZGxSa3JoMC9EaEdCblhyM01IdFdYd3ov?=
 =?utf-8?B?eGFzeUtwY3g4MXNxTVJPV3NUc2tYQm9DdTFCOEREZ0ZtbUs5bHFWMkp0M2lC?=
 =?utf-8?B?TVFqeWZwVWdWNVdUTlV5YUV3SndSQ0RObXRBWTdyT09zdHBkWHlOYXpvRStB?=
 =?utf-8?B?eEpjTHdKa2hjK3pHcDFqbFB4SllRdE85VWR5YVFDNU1ZN0pvdytURDB5WWlD?=
 =?utf-8?B?SmxhTFp5RUgyOHcxSnZrTEZFeENvODN5di91L3RNRnBvN2tnTnFsTTk4NXlC?=
 =?utf-8?B?VXdYdWxPc3JQYkZFWkh2UXJpRTFtcW9nTHkxUWQ5OHM4aGhEUktsdTJyYlNM?=
 =?utf-8?B?TjR0NzRNV1Q0VDFYem1ZK2M0bHY4NnZmbENPOWJsdnFNMXJpRDBzRkxHYTFs?=
 =?utf-8?B?b0NaMTkzb2pyMmhrZCtSUDAxWDV1Z3hVOGowbUVRVi9aSTE2QjVMMVJQSGd6?=
 =?utf-8?B?cDIxRUJWaGpwUHNwUWZ3bm1jSGVubUxtQ3llTlNDdFdUL3orNS85dnRacjVR?=
 =?utf-8?B?ZnZwQUxKeWtrc1dpRU1EcUpuRVhTK0JGbUZGQXp6QlRldHBNRWMrdVNhYzI5?=
 =?utf-8?B?cXRwcFladFdqd0RXdGJneHBUZDhYRWh6UE1XdmVCblVoZTg3YTdLcGV1S3dH?=
 =?utf-8?B?MXpFcWxrN2d4Z2ZSSnhkQW4wVXdCQnZmSjNaMUFXekRCL3VlTy9MV0NqU1Nm?=
 =?utf-8?B?eEsxQzZ4cTF2SDJ6eXJIQXltVVNYbUhJNUdpWElDS3I1Rkk5bXRxeFp0Y1hR?=
 =?utf-8?B?T2Z3R2ZpTW5hTDhSY2Mzbmd5Wi9NTGNzTkh0STMrR0JFRlU1a1FHdzVYWDlQ?=
 =?utf-8?B?WUlLRCtoSGhIcE9aZWE0M0tqKzJZb1NINlZPWmR5bXI1TzJRWEM3UU5vMWhS?=
 =?utf-8?B?SkZvRVdESHF4VEp4WUg0cXpNSjFWNk4zVkhYc0hPQllDZXRrcjBVZG9oQnRH?=
 =?utf-8?B?QTFabkJQbHBSOUJFNmZ0QnFwVThZKytCRFFPYXpxaDF0NHp4UWxSd0lUa1lQ?=
 =?utf-8?B?ZkFpb1dyNW40cWkwYisxOFJURHI0d1FiNEVlN3JSN3JaRXh6NUZWVGpMdkxa?=
 =?utf-8?B?YXc4OUhTa0JpcWhMZ2s4Mm9wbmpmSG5aTml5M3FUdEV1c1JCTXFLcDZyd0hY?=
 =?utf-8?B?b09vQURZZzBzU01ZQWp3WDFjeVFBbDY0ekNXTkpCd2RzWE9tV2tDWUt2RlVa?=
 =?utf-8?B?dXlERTBZV2h1ekJxdDhUMCtPNlltNE9ib0VUS1ZncGlQZENVWlZjQUlieGhO?=
 =?utf-8?B?TjJqQkcvaGpUR0JiZFBMQXNWc3RZSEtMWVFjL3lLRnZia0hzWUM1eDJnMEdI?=
 =?utf-8?B?NWRlbzdPbytXT0poaUJibW41RWtHUnBMVlZTdXlQTUs4RW9UUmxmR0VkUGEz?=
 =?utf-8?B?S1lKUUd6dDExNTVSWjQvQndYa2MwbW1peGMxUWcrbFV5a0FJMWdFWEJkUVls?=
 =?utf-8?B?UzhKQmZ6YWo2RFRZU1pPdjlzeGYyWGpXbW1tUlZYa3dBZlRtQTlmSXhWTlNx?=
 =?utf-8?B?ZDNTSExVMVp1RmQ4L2hvcm9abjd2cUhOUlpsbm9hM01OanJINWNKM2ZIZEpq?=
 =?utf-8?Q?nWKE9D4gmBTc9qbhLq2WBMmPL2vFDE=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(36860700013)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2025 14:13:50.5719
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dd751503-e510-42fe-57a4-08dd356ed5d7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE34.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6558

On Wed, 15 Jan 2025 11:36:15 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.72 release.
> There are 129 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 Jan 2025 10:34:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.72-rc1.gz
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

Linux version:	6.6.72-rc1-g6a7137c98fe3
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
