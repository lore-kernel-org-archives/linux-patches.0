Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2066.outbound.protection.outlook.com [40.107.220.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE1BB1C2333
	for <patches@lists.linux.dev>; Fri, 16 Aug 2024 19:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723837742; cv=fail; b=ogFrOJ/SpGsNCd1IG9Smm9fliFPyQEWTABvw0bieZ0gZvTk8gy4QL70VVyJlMNyPEOgduf5pCEc7m6JSU+/EEbwpuP5awyjHcEBgDf6Lzal1OcDhT71bqQ0ORiF+z5jqIioOwpbsv0PXWYA8BoYXATfGeK+iw5Gn/sfJV21kJPI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723837742; c=relaxed/simple;
	bh=SalAc4R4lCoRgckVX/gCoX2dCf4pXIcWXuIpEyuNAx4=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=bL/AvZODZ1OprR+4vHZqrjRcut0zqD7Y4TK8cMsp90pDXfU1X+Xk8W8ympm69sFt460xrotKDTesV+5rFNJZUkPQ9J3FuqRcPglbn/TBybaIPlKBy7XUFs05lHOj6QDvmKM7JcAWz6ne0jVGkurZKcBKNdstjXEVgmz/ThBW7eU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=oIxiLsng; arc=fail smtp.client-ip=40.107.220.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="oIxiLsng"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=djLkGYsDcVtrxCbYggIkWLXfXOdOMpFlu8h41RfWDm/JJVrVePeAs/dHptlw5LSj/IyA6lYVg25ct0QA6ri5XK/HBkOLWi9KgRa1CH+O2whSbLOFsXldqUOSAiER3Uq5kxJHTNF/9VKIchdRR/7dhTqmkHRjVaza+ebxnliVzBJ2zplZCZQ4xrkFhxoM5WpNgtWCNcEawgE2TfUY/uDodg7eK+PUGxcmIChSssXEj4WR+eOJJdof2cd40S/FWJnrXGw8gJL9n2EqtNpKMx+6RqQYHSlAyHsZ/GiqetzhZvUbPBJJ83Srf3lXd5XJ+CZjG7BzO9ANZJebNUeAQ1tFQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rb9dV+x/XGRNILSXyPvekTNRTZPWK7l2FUAX+5SSkfA=;
 b=RnEwIAKtQM18qKXG1kSI88LFi+YMeuqPD9BoUZl5B6efLfU9pB3Ab/afZacn9HLdJCXIwczVuJGRcJvlpa5X5f0Sx9K5Yq0JFFK298yloKs4D6U/cYhen4rSk1pBJE6jCuhT2M0m6hXpF6dLC258WD2YkOrjgJo/iVJ9dMCyTf63j/X+r6oLQiFxYYhVCkS7pdCJd14Y2g+SyGC0WTKEEvo9Z2OR1LcPNgAZBTDJGGgF+kx0IiYZ4noW7lNsl2SoD+PNfavbUvNCy1I0QVXnOkvorF1+vpPTx/YRDK7XehKBjW3udTjiFFEoraL4hBW3x8C8mHKpRHNWFZ3ezuCLTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rb9dV+x/XGRNILSXyPvekTNRTZPWK7l2FUAX+5SSkfA=;
 b=oIxiLsngdJsvqCS2HO7K8CvS346Tbz6AKSfhndyWYw4OPxGdktnrOnnleOXueMX8hdQBy9JXPObkUX6FobynXSRN4SlscqOJkHGL9gj7gPRCLqt0zlSVg9IPudaakBRVfGoQt1u8Uu3RaIertTE56OMqqv8hfklSaB0q5rXdpd/buPuM+rC1YHvbApMcrKcuF89LHtMXmEXngOFWyBpn2NHVkqYTI6YKMR2AKEVy40UF0tj0GYDl5KIvNJ8Xqo4vNzPW4PEkvQthk2uVaEmOFIzPfhtoyl1CKJaKZeEIkanMoiXozwJOIrIluBAZk8i/04hZI8788ekD3/GQExW8ZA==
Received: from DM6PR05CA0042.namprd05.prod.outlook.com (2603:10b6:5:335::11)
 by LV3PR12MB9166.namprd12.prod.outlook.com (2603:10b6:408:19c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.20; Fri, 16 Aug
 2024 19:48:55 +0000
Received: from CH3PEPF0000000E.namprd04.prod.outlook.com
 (2603:10b6:5:335:cafe::da) by DM6PR05CA0042.outlook.office365.com
 (2603:10b6:5:335::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.15 via Frontend
 Transport; Fri, 16 Aug 2024 19:48:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH3PEPF0000000E.mail.protection.outlook.com (10.167.244.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7849.8 via Frontend Transport; Fri, 16 Aug 2024 19:48:54 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 16 Aug
 2024 12:48:41 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 16 Aug
 2024 12:48:40 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Fri, 16 Aug 2024 12:48:40 -0700
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
Subject: Re: [PATCH 6.10 00/25] 6.10.6-rc2 review
In-Reply-To: <20240816085226.888902473@linuxfoundation.org>
References: <20240816085226.888902473@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <b61b875d-ea21-423c-820a-367aeca338d0@rnnvmail204.nvidia.com>
Date: Fri, 16 Aug 2024 12:48:40 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PEPF0000000E:EE_|LV3PR12MB9166:EE_
X-MS-Office365-Filtering-Correlation-Id: 4df36b64-7cdd-41c2-5810-08dcbe2c75ea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aWRBWWIzUUpnaGlIRnZXZjFNamYzYzJiWHc1ZmRFN1VtamUwa3dmTFRrVnQ3?=
 =?utf-8?B?Q2ZodGJsYmpadXVTOVoyQ2tzb2pCMlltVy85dENMaUF2SVlMTzVsaitkdXpq?=
 =?utf-8?B?N0pRZ3RvU2tHdEJXSzY3YWZCTk85Szhpb0cvYkJYU3NxNW80RnVWSElZSHRN?=
 =?utf-8?B?em85dmZwbUxUemFhT3BIWUpqaXZENXFQY2pHdFpFMW9JTjFtZ0o3NS9ZNkdL?=
 =?utf-8?B?NGRwUkRvUENLeUFvVDdBTDJpNkdTUEVFOVZGWlZDYkdaWENXNHFLR2NXbzZw?=
 =?utf-8?B?YlNsZlF3T0MzdWVrbFA5WjFoc2JhK3dkRDlVcU43TE8ybU1BczlDalpQQmR0?=
 =?utf-8?B?R1F5aWpRcGhDWmcwUFQ0ejNEaDZlZUlNTmFCNW82dEVaRHkrVXZyMW1wcnNJ?=
 =?utf-8?B?dFhJT0RCZ3YvcEZKTkZEd1dLdVF2Yzk2S00yaTI3c05xV1h3UzBTUm85NkVL?=
 =?utf-8?B?NWZFaWtkV0lzZlozQllSRVkzelA1S2lsOU1oSVEyZUo3MExTZzYwZTBRM1E0?=
 =?utf-8?B?Vmt2OEtPN2g1MHhUVUsrdm42YWViRWVMTVhPaDZ0Tm12QmRtRGFIaXBqdjYw?=
 =?utf-8?B?dy94KzFaMjc2UkdjckxwNlh2enY4VGVscDk2NWpFR3liN2orTWdJUEp1VTYw?=
 =?utf-8?B?RXhORDMxcEtGejJJaU14VVo1NzEyb0R1UThJK3dndkNpaVhLZjhYaGpZeXd6?=
 =?utf-8?B?WEJ0WEpaR3RUMG1ibnFFUG9pWk14UGxaRUtTT1M1bG1VSHZBc3BabkN4U1FQ?=
 =?utf-8?B?cGhyOWU0Zy9CK3NYaXlNZjVvemZlenZWQ3VFWVhCUlZPZ2VPekdvdEM4WEYz?=
 =?utf-8?B?bkxKWjVhOTlZS1hxTHBzd2dJcmdjYlRFbzZCMGhXaXRqYVdlRnNIaGNQRTlS?=
 =?utf-8?B?Wk10cnZSUGJDY0kyUDZDZFlyMEFKZncxbDI4L0pRZjcwTGUzTWdtcFZ2dXhI?=
 =?utf-8?B?dVEwUkozQzdrQWRBY0JWd3pSQXVJV1ZiZExlV00yZWNhRjdGMTF1MHYvVGQ1?=
 =?utf-8?B?NVpzQ0xrYWVpc0E0T1A2THBGNEliZkx2Mm5WKzZkdGp5QmJzclN0akhId09G?=
 =?utf-8?B?LzZzTkVXcHFtcVBUWUxyR3MyMndaaHJnWVRDOSsyVHBWVWRTQTNmS095d0li?=
 =?utf-8?B?K1lrYWtxSngrSEt4Z3RtWkhkWnFsakRRWml4T1hVUi9oc0dCNVJWRll4Q1lm?=
 =?utf-8?B?Z3ZFSStsMjdPb2Q4a1ozd0pCcVNqMEJRTlhVdEtFa3FvekdHdXZVVC9EYU1w?=
 =?utf-8?B?elEyZExzbExRQWV2VmdaSjlZeE9Bd2ExY0Jja0s4Q1Q0ZU9aL3JiMXhSdnRD?=
 =?utf-8?B?MG02LzMwdUE2bDNEMXpPVGl2bU9lRGdjQi9jS2NCNWZ6blBFelFKcWNrNmdx?=
 =?utf-8?B?M29qM0xNSkExSnJlSVdhOFNHWnhCTkRmOEtTOHk5OTVLTmtiYU5tQlZqOGxI?=
 =?utf-8?B?L1AzNVVXcHU5QjFHM2JwYUJacWdKQmhYYnRFZ2JEQngxNU13bmFab01sa0tI?=
 =?utf-8?B?bDQzMmhBV0FhSFd1aEF6WEVpc244TmRTa0dCRWVqSG5YYmxaRy91WU9YRnFx?=
 =?utf-8?B?WVZBQ3RPbFQyWWZSaVozTExPR3FpR29BWUR3V28vVjBCS0VoMk16YnJIOWpl?=
 =?utf-8?B?Z1l0Y21oVkR2NVVSdkp1T2xETzMyTWh6U3RTQjRTRFhlOTM3OW15MjI5MlVM?=
 =?utf-8?B?N25iUE9GTHd0MnM2SmlkSiswRUlHamIweEU4a01SWmFMbmNFWU5wajdjWk1G?=
 =?utf-8?B?Q1huQjFqdDhpK0c1dzVsSjFqUy8wcCt4bWQ4Y1lsa1FzSnpOQUhRbWxtNHMy?=
 =?utf-8?B?NG1adE1rdXMvSWlyWUtRK1Y4Y1U4dG9Ea3c5T2pMMVh6OG1zalhtUUJ4d3Qz?=
 =?utf-8?B?eUUzQko4cDh5eGJaNEcvY0ticklwM1lTUHdYaHNiVGR1T1BkMU9xN2tFaXdO?=
 =?utf-8?Q?idqvgGMY3OOnSeoJSlKnEbB9Vg0Z9vAQ?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2024 19:48:54.4023
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4df36b64-7cdd-41c2-5810-08dcbe2c75ea
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF0000000E.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9166

On Fri, 16 Aug 2024 11:42:18 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.10.6 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 18 Aug 2024 08:52:13 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.6-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.10:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.10.6-rc2-ga391301088d2
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
