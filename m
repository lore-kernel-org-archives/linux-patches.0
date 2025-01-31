Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2085.outbound.protection.outlook.com [40.107.96.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7C511474B8
	for <patches@lists.linux.dev>; Fri, 31 Jan 2025 05:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738301972; cv=fail; b=lgwIkyI2AYR/6AONTZTsk77BKuyOLkjXgxNFAX75hEY1ZnKnpQBilgN5+C0O6ja4xdO8tCPfqco0/HTtm3FlDnBUGZPtJCozudAYREVSwJyTi6rbx5E9SroUb84WOCRSF78Dww4t81WzUUfG2SzS/Hkv/5EtEvOzQfy3ZZshoCU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738301972; c=relaxed/simple;
	bh=yJdtiUrIqpHG3PMiodcj3v8gyzstUSi5xiM5Wo3nyY0=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=r4243mW5P79cOf8MMGGbtpxZyAQDff244/1EFzzStyPuX17/uO/Dvn8s4ttz23Yh59CkShaorT22PUeAwgg3oM9hiAMI+pntjkjxQ1W72GHfuxm7+NgdGCdrKeHMW8Xq1CTQEYrTJnagTQPB/MZv70fLaj6smSVfy6ILKZDOV1o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Uzvc3B4g; arc=fail smtp.client-ip=40.107.96.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Uzvc3B4g"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yJ6uUt99Yyg31mjz8KmCAviQU0+sb1azPNwa4q1KC5DST09/k7gNG+YaqS+rVmSHJW6v2GqR/6Y/V+yNjMPNKjjUE3QuqiV+qgbRwzvYNwZgyP6ECBpxiLGBqZseeFdeAJtr6M84TeFTJfyNBSpemo4CJt7Ll9NispaBle8AisW1m51XC7BtsXkLssaGen/XCY1UznsKxf8vOVfH3uHj+/dmVbyJdn3cVdkyUxjF0inlYOFApwCTGmwIRPjWz6FBD3WYjJgOyJXOe5tB7Cd3h661osS+gGIv+mZTzreFMha0eznppLNJuy3YsrXg7Nl31fvaUPRy9uAJclSLMeROKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aI7oJS0HrpeVwtZ6KL+e+Yz9wspodvO2gdFJiV13cbc=;
 b=rIGryyvOsnbkBQVEK2zINxLF1j/ezF196Ast+7R8GOHKj2pofdLWrh4jOObGZlKAr9qNelH3pd6xCemVabOhbiKL2hje5xU/nlfuDxb2vbR0VeEd56fhzqqpK6POq2sV1Jat6+VK8Rli6cIqR3Z89kWP6HXTvF99aiET9T4FiW0C7ILfL4O1yzG2Kk+zWIM5CfzdYt7Va04pazPK76cd2ekFk1zmgLL+l2/jO51w1z58niYlg3KJ0Y4CFstVPPeIY0kQFWriY0LGVCRNjVQX22ptckY5+j4YI3gGPReRBfrQ2ns6nBwzzYrotue266oOoL06qE6z/D2sFhjpx+MaNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aI7oJS0HrpeVwtZ6KL+e+Yz9wspodvO2gdFJiV13cbc=;
 b=Uzvc3B4g3qu9HHVdh7vz2Ewbp/nEd3Ceus/ozbb1B50MQE0Vs6c2pdokJD4RTGFf9gaTc/5r9ccECN7D/dPyWMPKylzVZRs2tSfaX8vH/nhlQffr9cYOQwpqJ5IbAFcLQv/q5Aa6zj62tkv80gCabtcsk3lcmlu2uajnmNChXqui0iVksK+0bAaoaid9cGeQLq+TMbSp2FLhvVgXh2Uh+IJdtkgswUt95HB0qlnGFFiTKmYd5jXgiWZHTd6dKV8KeViJKCRJUh/I/yeLO8WsZNUeU1Atpgqa/Vb4A16NSBfB3UcWWgq2gOS/Vmb32n/kpBn5kDjfRWqHB1rL9Jw7QQ==
Received: from SA9PR03CA0007.namprd03.prod.outlook.com (2603:10b6:806:20::12)
 by DM4PR12MB6470.namprd12.prod.outlook.com (2603:10b6:8:b8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.18; Fri, 31 Jan
 2025 05:39:27 +0000
Received: from SN1PEPF000397B0.namprd05.prod.outlook.com
 (2603:10b6:806:20:cafe::8e) by SA9PR03CA0007.outlook.office365.com
 (2603:10b6:806:20::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8398.18 via Frontend Transport; Fri,
 31 Jan 2025 05:39:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SN1PEPF000397B0.mail.protection.outlook.com (10.167.248.54) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8398.14 via Frontend Transport; Fri, 31 Jan 2025 05:39:26 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 30 Jan
 2025 21:39:11 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Thu, 30 Jan
 2025 21:39:10 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Thu, 30 Jan 2025 21:39:10 -0800
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
Subject: Re: [PATCH 6.12 00/41] 6.12.12-rc2 review
In-Reply-To: <20250130144136.126780286@linuxfoundation.org>
References: <20250130144136.126780286@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <cb5b3e63-a4b1-4e2b-b8b9-fdeb2f5c6042@rnnvmail205.nvidia.com>
Date: Thu, 30 Jan 2025 21:39:10 -0800
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000397B0:EE_|DM4PR12MB6470:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f3c9a61-f3e9-4590-5737-08dd41b9a020
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|36860700013|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UjQrV29QWC91dkdLRDJRYzF0Mm5Qb2VvVFhWMEhORE9LNC82NTFpbFBJOFRT?=
 =?utf-8?B?RUhwZDB5eEZGb2ZIRTljb0dDVjBUVTc2L29wY1ZFNHZLeVB1TG1xSTk2VWow?=
 =?utf-8?B?enJBVXpEMmlmak9uR2JTcGl2OUZheUN0aWZkN21kMUpmOGxYS0FTVGg1RVRS?=
 =?utf-8?B?WmJaaFY1ekJjTkltVXpwNzFneDRXYXc1ZnV0ck1zUEltanhWYTFpRlY4NEdU?=
 =?utf-8?B?eEEzNHdYU0NhdllQUFlrZXNyYmxkT01VcGNnMGNUaVVzd0Z3b3I1dlkzNzZY?=
 =?utf-8?B?aE4wbnVuT09WMmM4RTNvcUU1U1BYdHpmMUw0bDRzZEVKcGlQVlVyMWlaM2Rh?=
 =?utf-8?B?L0lDRDFSaWhCZTNzSnZMaTNObXdIcGUyVHU0dksxYTkrdFo1WmtXQjBxZG9i?=
 =?utf-8?B?dVFEUUJuNldxZEdUYlJXNEt3bnd0dnlxbU44ZHRtUnVYaE9nTEdYOXgrQkYw?=
 =?utf-8?B?SlEyS290cU12ay9FQ1g3amtFamdEUXZDWkNCN2N0djNPUjNwZ3dvdTBWRVFz?=
 =?utf-8?B?V2g3STNqb3ZpWmIwbXVhY2J5eFpZL2E3REQ3alJrUXl5VHczRVhpdlozcG5l?=
 =?utf-8?B?R29Bc3d2ZkFnUk1KMjZOdVBYWFBqdGJoK2x0MG03ekJOMEs4RGZ4VEFXR2c2?=
 =?utf-8?B?eWtpTjMrZ0pPS3F4MzhKM0pZcEZwK2gvanl5NTNyWUVoWmoveE5ZVkJHM1BI?=
 =?utf-8?B?UzFFUzRkVnlLS3BHSTVWWmhncUwvaFNJbGhqbUFhTlVqbHUzUnp2M3JwRVRz?=
 =?utf-8?B?TVF4aE9iTUNXRWZxd0dVanY3dWdXcm1CdWpFQmtRTkdQdXVCdU96Njh0RzRZ?=
 =?utf-8?B?cFhPVnJFWmtuQWVOMGtiMGZCN0tOb2YyZmQ5eHBQQTgxczRQb1BOYnJ2NGpT?=
 =?utf-8?B?YnJKb2xkbXJxMU9uYnFiYXVzdG1CMnVjUDZyc0lIUGZkMThlb3pyUGVYWTdP?=
 =?utf-8?B?Z1NEclFrY051M3hZZDIvOVF3aEFpSkE4T3ExcGNwSVpkeDNFU1E1NnhtQ2t4?=
 =?utf-8?B?bHIxaGF3NHZlV2pKeVJqaHE3dzV4K29KTVgxVm9Kcm54WFc5QnJnU0NTMHR1?=
 =?utf-8?B?VHV3Qm1ndi9kV2RDYUIwblEyTUdPYzRzSXdPNXdWS0dQdEkvSSt3NkdHcDlz?=
 =?utf-8?B?b3pFVnZrcEFUcjVIVmpoQXVVWFFnVUlKVFJiano3d01Tdi9KUGhjYkVFaE5j?=
 =?utf-8?B?WXZsd0RhUFJrVkt1dEVldVJNMERndzFidDQxemJZaEEyaTVsUkI4TThEalE5?=
 =?utf-8?B?eURGTjVDdXFIWHBBd1F2R3gyUnZpUVRNclZVK3BTTXBnTko0dklyS1pJT1N0?=
 =?utf-8?B?ZERRZUcvYkJiYzY1Skdla3JYa2ZheHg3Q3NGckU2bi9NNFZhYnp4Nm5vZkVx?=
 =?utf-8?B?bUkxc2c2K1pHaStXb3VBZ1FiTnlGU3hhZE5PUFFuRHpMdkFiS29JUVRTSUw5?=
 =?utf-8?B?U292OUFOR2pyWnhCdmlsQUZqbnVCeElzZnRUNVl5dGhoa0dqaW9FK2RJamNl?=
 =?utf-8?B?ZU5PUVBzRFRSVzFUckV2KzhPNi9BRTFkM0o5OVNZRVNhQXRWd0N5a21SYmRI?=
 =?utf-8?B?KzNtWWU0K0J2Q0ZGdk8yNytrNjJIR0RLbjBWWmxuVHlxMzdkcFRqVHFXUnlv?=
 =?utf-8?B?RUNzS2ZuTmliN1N1emhXOEowTURTS3VPVFVrRzV3ZTVVcnBFRXA4WUFmZ2V0?=
 =?utf-8?B?OHFTT0NEUDZCeCtUQ3A3MVdyODR6bnQ4OVJXaSt4WDNyMXBVUnVrMlhMeDRJ?=
 =?utf-8?B?MDFUcVNMY1g4VnB1K29oQUJON1ZzTDlsOENQOTZDcDRlZG03dFVKQ0kweXRq?=
 =?utf-8?B?VTVIRmw0NktuYU44UStQc1ZUS21WMG1UNzBHYzE4bVN0K05hOU9WcWwzR09I?=
 =?utf-8?B?RVJBOVUyWE5UcVZJZnlnVU1oWnJaQzZxS2RXakp0MU5mSmVvRDlCMlYreWRY?=
 =?utf-8?B?RTdBLzhFYlJWaitlNm44L1ZoMTd3U1NtOGtpNHd6eVBQUytZMGI5MWtSSUtX?=
 =?utf-8?Q?gkMzEqq+DsJLZDIz+VW5exodwXujRI=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(36860700013)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2025 05:39:26.6145
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f3c9a61-f3e9-4590-5737-08dd41b9a020
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000397B0.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6470

On Thu, 30 Jan 2025 15:41:57 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.12 release.
> There are 41 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 01 Feb 2025 14:41:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.12-rc2.gz
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
    26 boots:	26 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.12.12-rc2-g4d14e2486de5
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
