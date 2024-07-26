Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2059.outbound.protection.outlook.com [40.107.220.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F44617C7B2
	for <patches@lists.linux.dev>; Fri, 26 Jul 2024 17:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722014067; cv=fail; b=Rgeoq/j46gUNAiwlpv978gTXEwQv+6D7OdguVyYtkuK/1FaQQBTrPubFImGFp1NaAi+0ibKpejjJ7cxd2DP9JaKYvcULgyq9FS/BZhwxaFYiWNkRMZ2rsV274pDxvABHUVcNJxZhmjuub4XEj81bsaCGUIf7mRaA2m2uKetVSK8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722014067; c=relaxed/simple;
	bh=QsJNNLqI8XhFiL+L+ialaHKnajYZYqf3vcjEKr2b0GM=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=D55JXxedCuwxjbStR+aDGD9goG1qa7jTXZhHD4wKMULHJkfcylOBtwwCpf0e7zX24ZPK/SwOILx4ZMhxrz2oFV3BhbYRg3R8XA11+ujRi10rBRVeqZ7wQM6rNj09jv05/yDTfhm4gxY2HHlQAm4xqY7MV6dLsdDk0aqAQsmagNY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=O04EVuBX; arc=fail smtp.client-ip=40.107.220.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="O04EVuBX"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y2aWBraqp7s46yhomuqGCVfW/4UNRU3xiR4VY1WcJWfnCJjQgIUan34sb/LtT2N6dSoHyLszuZKLnd+e18s26pkkIlG6BzAKTCU37z09uvV77Fnf+hqbsr99blHzUFv87tSQyFwEkhsixt+XOgM73qu6dfTVB5mOQFv5W/rEgjduV7BvFIw1wx6KH6Ih3xoSLLcNGrnZcqQjoxjWkSM/vqVL60tjeQLc0eDEMjGhyRbztcw75Lozyp/tZqkzT0JdEQG6az6XVmewKI73lBbUs2gvU96DNVG/dYohixT6+CbbP5eZPpMxa4WyzvZv6Ml598g0gSiwbJs938lgnn94Sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dp9SU1/zcWosSxcSF2G/3N8v3hoOdjFT60lz4IHyAuE=;
 b=AFNkDuofKMmpkA6DNjxMxc/mVa971f7FAGqrJpV7sBLFzX0IGlCK7dmNWBL22VUrPXlao/DOP+UtNmiYz4iMpYh3v1N+iHY8xZSl/24Fr0BrPATxI9ASWFMJqIotEDOwCazPEP2D+KH+9htaJzTnBeKYtXELGOYlpq2ycWTvT2ubjYZHh50WSw+Xwxz+lg85fpbn6+PE0nBsYx3g8uENNQrmFyIY2h9Izoioy2aEa4l4AGAzDYrFE2sbiy4KXu5ENOXJW63kJR6hlA6XmDP6tV/AeZNXR0YHed7PTuFK783+tng2uSI0bHNN9Ny8RATQwqdn3L4M+m6jLbJm1if9Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dp9SU1/zcWosSxcSF2G/3N8v3hoOdjFT60lz4IHyAuE=;
 b=O04EVuBXzf9wPZrzmNdXXsrFZn2L0IkEDly+hCkHrt+rxIY8zThvgffbKY7V8IlmEp1VBd5Ujw3kQyLdkNJjML76M/863kSw0OmYBRdtCGFEMiI64rDZnliMSlkwXBV/57lfnZSSXLpCTmg08ZuB9Od5ei5xXFnG70DJBOvKncMvjJIcbD1SAYhiOJUw4thocDi2G6d/wsMG9uN+1X/6ySvWKHbljS72fgaZTO3QFiES8Un+8AgUglVt8A8xYmxT8TaRPFsg70UeUii4glDFfppSAG7oMY6Ene5Ue4u5RyQn4lUcGTobVMdXY2GWk/mM29bv2PLnlcNRQYcQH2a/+g==
Received: from DM5PR08CA0042.namprd08.prod.outlook.com (2603:10b6:4:60::31) by
 SA1PR12MB7296.namprd12.prod.outlook.com (2603:10b6:806:2ba::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.29; Fri, 26 Jul
 2024 17:14:17 +0000
Received: from DS3PEPF000099D6.namprd04.prod.outlook.com
 (2603:10b6:4:60:cafe::a6) by DM5PR08CA0042.outlook.office365.com
 (2603:10b6:4:60::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.29 via Frontend
 Transport; Fri, 26 Jul 2024 17:14:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS3PEPF000099D6.mail.protection.outlook.com (10.167.17.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7784.11 via Frontend Transport; Fri, 26 Jul 2024 17:14:16 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 26 Jul
 2024 10:14:04 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 26 Jul
 2024 10:14:03 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Fri, 26 Jul 2024 10:14:03 -0700
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
Subject: Re: [PATCH 6.1 00/13] 6.1.102-rc1 review
In-Reply-To: <20240725142728.029052310@linuxfoundation.org>
References: <20240725142728.029052310@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <733bfea9-e3e6-4cc1-849c-e9212fe30cf0@rnnvmail201.nvidia.com>
Date: Fri, 26 Jul 2024 10:14:03 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D6:EE_|SA1PR12MB7296:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d60be1b-5062-4df9-b1ff-08dcad966171
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cmdXNXBQNE4yUmI4b3dGWnZxTFNxa3VOb1RUdGlWUmdhSW5FRHBBZWFFVTZo?=
 =?utf-8?B?enR2Y1djUGsvWW0wYWJkdldvcVdtR1hXOXcwdktGUUJpOWZLV3QycGZLRGRp?=
 =?utf-8?B?ejgvbXUyTVQ3Y0tUT2JGaXpCNlh2NW9xQ1VGUkRWNVRLTENROE5pQy9adE5U?=
 =?utf-8?B?NlhpRmdpOXhBMFMwdTk5MGw1QTd4WTFMZ2RCb1RDeU5NcGJ5SEZVMDVDZ1Js?=
 =?utf-8?B?cjNua0NHMTE5dzJsZ0lOOCtzaUE4UXpoSmRacWJPM1NFSW10Z05XZC9mZjdz?=
 =?utf-8?B?dVFBQ3VCT2gvWFhNWkhXWUZrZ3c3T0hxUVFHZXlMQWhxYk5NWlk0elh3dmt1?=
 =?utf-8?B?aXJTc2FSY09GR2sxSmRGYlE2Qk5JVWFFaXF4S2UzWFhOZTlBSGNaY1l1MUlm?=
 =?utf-8?B?R3ZGTE9IcXAwS1JqTzRJMmxsR0JjTzAvREdUdXkwQVF2aXRVaVpvUHhlYnVl?=
 =?utf-8?B?ZGhRM1NxeVVYOHJPdXl5Y2dmelhZYS9jZ3JNQmhIbXFYcE1ZZWEyMnRjWHRC?=
 =?utf-8?B?dWhYZFMybEt6S1hhamN4aW9xY0pvMmhZcWtrRWJkbFRGc2RSeCtUUm5md1hK?=
 =?utf-8?B?ckVKa1BINmIzNVZObzhsSGhwdEd1UWlZUjlzR3R4Mk1VVmlhSVhGNDFrRStj?=
 =?utf-8?B?YUlpSno2SHlGZGpUb3J3dHNLYlZ4UHIydzUrM2tSNE9FZ1F2UlI0NWFZK0NJ?=
 =?utf-8?B?R2E1SC9IRjFFWGt4QU5xOUgxSUFTZ0JTZnorSUp3aXdhelhQVE5aeVZsOVNk?=
 =?utf-8?B?aTZCd2xWVEtxV1pHKzhINkR2Yi9XcVFyV3FWRmxCcDYzdmlhcnRlcExyL29n?=
 =?utf-8?B?cFhQMHlPVC9HcHFpbHJwZHdJbHJ5Q2ZibksvekJ5RU51b083Yk1BSDRtWHFo?=
 =?utf-8?B?dVlRZjhPdnQrb09Hd3VZd29FeTVXWFdXSE9YRm9UWHdybS9yZjJRbGNzTjcr?=
 =?utf-8?B?dmhxakRCNVFEUWhRTzlvMWxGRnJGOUZCQnhqZUp3MTFBRHBVeG54UWNSMm1B?=
 =?utf-8?B?OEo0cC81SDZDSlRpL2JGNjk5eDduYllGZjlWU0ljRXczQ01jRVJsVzRlaStY?=
 =?utf-8?B?N0VFNjFIZWpVZ3hmRkJVT0FBVkxUVS9nbTlwTXFmVnNMSys5Q1hYejNWNm9R?=
 =?utf-8?B?bnB0cXVKOEExa0tOOHZZYkR5V093aWtDaHBSSnFtTHNnN3JuSkxMMXozbS8x?=
 =?utf-8?B?aVJUVkRMbGpmOU9JZm4reDluYTI1c1paNWt0cExvZnNXWU9hL1JBZjc3WHR1?=
 =?utf-8?B?R0pER0JyMEFJSzVtM2s4RksyTEw1QjExemo2NmNYTGlHcDZJcTNIMy9yZytr?=
 =?utf-8?B?SjR5QjVWSmMwaldUYVQ0c1hMNlV2b0swc25jeXFEWVhzN3I4THhMZWNKQzlz?=
 =?utf-8?B?cXlLanVMRXQzL3N1Uk9HOEQwNXZ0VGNDa2kzcVVVKzFuNWM4TEQrZU1uOG9W?=
 =?utf-8?B?NFoxWUxONDVvTzVQcTlNd2RDbkg5NkQ3eXk1VDk5SWluNDZ0UC9IYVpuejU4?=
 =?utf-8?B?TDIydEtnTldlVTcwWUNNQWNnMk4vc1J4K2pRbExQcUMxMFRpZDZvYzQ4SHFJ?=
 =?utf-8?B?Y3NXSXlrWDhxNVZIWWdiNS9OQnU3MXVWcGp1TjZabmE0UG9PUTJoYkpnU2Q0?=
 =?utf-8?B?VHJWVDJGTDJTZ1F6eWQ3cHhWRVVzMjRVbENwd0Iwd1VLZ3Z3WjdaQitaVlY4?=
 =?utf-8?B?UGVJZ09nRUdjSzI1UFJRN2ZuM2l0OFIvQUxtdDMvQlIwRGN6dW9UTVhHckR6?=
 =?utf-8?B?QnZhZ21zdEc4SkJ5WVFyS3RMczk4dmYxS3AvOVA1OWwzekV0R3pPcC9oRU1x?=
 =?utf-8?B?NEROeGkxM3FIaVlMLzVYbkphRlVsZElRc1dJTTl6MTBId1R4WFVYUEdXNHhz?=
 =?utf-8?B?SElESXM3Q3h2bFFZYmxNeS9wTkdwU09TdENrRURlUlZUbEd1a2FIbzhCb0ZY?=
 =?utf-8?Q?1fcpFqAb9tO3kNnfPPnsKM7TVpsXII/r?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2024 17:14:16.9746
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d60be1b-5062-4df9-b1ff-08dcad966171
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099D6.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7296

On Thu, 25 Jul 2024 16:37:09 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.102 release.
> There are 13 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 27 Jul 2024 14:27:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.102-rc1.gz
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
    116 tests:	116 pass, 0 fail

Linux version:	6.1.102-rc1-gdc0e6d516f8a
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
