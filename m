Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2043.outbound.protection.outlook.com [40.107.212.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01EA41C8715
	for <patches@lists.linux.dev>; Fri,  6 Sep 2024 10:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725616971; cv=fail; b=GgBCWG4j6BgM+8I/IhYf9XyU56chcxkZf2EKXw5Wqug/Cr2rV0iMhrBFCQ1YTWR8hSTQUXu1fWJw26Hpg5TCxHWLj/ICxJ6w822cLS8BVUgEQnJ1FvW3Ll5/qIj+2CxIm2BqwHFA2YC8yLCyliI1WFZI+K23TDWIEx1uVytjaPM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725616971; c=relaxed/simple;
	bh=SYPUjYoky/0jQrbM2SWThQDwpv3XJFQmCDLpKZof5Dw=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=SvxGvGJtemWgFiyo2PWkiCuisxMFQhOJd/vb2s0GHwNi4MTxg5zfODiOzDVFw+9fiUk6LVkRBYsUy75wW6W8QOzt2PJkhRv2Leiw70/37+/BzVArJmGrLZ5d3I+TwCfPJBienQ+KZmU1Nuwj37fM7XYCmbLf9RPTXyQUmpOG/tM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=XO4Vdkrf; arc=fail smtp.client-ip=40.107.212.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="XO4Vdkrf"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pvCoGa3+SaWYg61ZYzW9NHESFcdloe1HWIq6ehDhR9GQALL/FtOJFX+LIBrFun6lb4geNhmRSgtyuITXTfAN6ib+M+lXub2kCec++ZQH/zv3rBs9Z6YLcrb/ta44YTtTlTK2GU46OZOGiEAxssMqyR4wvmYtTln1kbKhGX2fN8r7PU7mWQfsUs3sQaQ30hPAYtHLcRrGQXLM4lBlQCx+N8Ey6Lubr+9vOapaqHZYOrYUhoNSCisnKUvjjmh+Leqp0CUmztX9a9YDmwK/gEFExOdw/4xz71i40U00luiM1XQ6AlHypMcF8H1Ek6zsd8mZxyUxYtdBZECxJToBFlpBIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h35WWT+KrkG2iml8EqZc0kwgSkYC0svx7nxj1cuwRvw=;
 b=mTtZr9AhFsCIYhR8TSb24MmJxkMsk3Y8aN3+0yf44UjcZcduW1qzMFjBqyBi+RmyazNcBCsGxbmDV0a5bOBqL4cx+FEiHFCKqZfmcgsbjTYe8ljJl1cspY+GeKk6DdtPmdQISUeUpMXilKOZY7jERUrvFp3UGO3F3w1fEBGDxtb7cn+Fk2u0WEJxWMtYMYFMq9xvv3jBQwLw1oQUwgTLp0QWmbWkgNXSv0uU534da+omD2e0wsX6hfxy7ds1VPY1U6bk7PiitYZFlwGfiyDH8ebHAgWFgPSMCnLCYl8dCenLqLYlHcXfsn1bwOey2VqN/0nPQJfGQ5CgypkW6s2Ghg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h35WWT+KrkG2iml8EqZc0kwgSkYC0svx7nxj1cuwRvw=;
 b=XO4VdkrfWFSTms11aNCQEUmvu0uBHSM4kr2kmWQUvJ7vBHiapziAmtfUAPNfi8vA5NKuF6K9RGuL7d6rbMu0gGMy1mRa2WsANzGc715Zb6g5VwQvr0/m8X3iXBRWz8Iju0be+Jru5xrbpurHILj1WPppd3fv/FukJI9vtNw9h8fpGg394Iu9vArXY3zyJHyHDiYk1LNBgcHSkDW/j9Sr/3xrivUSktEFaDdY3ywzqTFGNIv+/VoN9ghNkqp4PQJyDLvL8Hm56SwVvsFbayrUI/RGrB7YXo6g+gj8OMtpqKddPOTqFsmmhpTi2JLiB3sqq4pMW12wtXMscr2DXf+XHA==
Received: from PH7PR17CA0040.namprd17.prod.outlook.com (2603:10b6:510:323::26)
 by PH7PR12MB7188.namprd12.prod.outlook.com (2603:10b6:510:204::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.28; Fri, 6 Sep
 2024 10:02:44 +0000
Received: from SN1PEPF000397B2.namprd05.prod.outlook.com
 (2603:10b6:510:323:cafe::c4) by PH7PR17CA0040.outlook.office365.com
 (2603:10b6:510:323::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.17 via Frontend
 Transport; Fri, 6 Sep 2024 10:02:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SN1PEPF000397B2.mail.protection.outlook.com (10.167.248.56) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Fri, 6 Sep 2024 10:02:43 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 6 Sep 2024
 03:02:34 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 6 Sep 2024
 03:02:33 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Fri, 6 Sep 2024 03:02:33 -0700
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
Subject: Re: [PATCH 6.10 000/183] 6.10.9-rc2 review
In-Reply-To: <20240905163542.314666063@linuxfoundation.org>
References: <20240905163542.314666063@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <2c401a69-56ea-4e36-8e28-4b97e0fa07df@rnnvmail202.nvidia.com>
Date: Fri, 6 Sep 2024 03:02:33 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000397B2:EE_|PH7PR12MB7188:EE_
X-MS-Office365-Filtering-Correlation-Id: b2d04b1e-06c9-4b47-b2dd-08dcce5b0d4e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?d0lkYTNpcTZ2Z24xMEFtNmRUSk5Mb3FzeUJYaDZwZm5aM00zMjRrVWdHeGV4?=
 =?utf-8?B?NmFaSE95SXFFRldGUWNwT2pVeFJxT2tmdU4vVGdhbkJRZlRCczBlVGpVYVJH?=
 =?utf-8?B?NFg2YTN6bGZDdnpzWUJ6Z29XcHVLdEdXbTNhRlZnWEEwdzBQbG4zL2V1RXgx?=
 =?utf-8?B?RGJzMkJUMm5IdllmTzBTWlhHZmZTdzNBV2FvclgxVllnSENsSUNYR2JqejNF?=
 =?utf-8?B?YmFCMkRrTDNiQkVYdFk4YmJSbXZDNWV6c05mQ2FZU1dSU2lrL3M3UnA2N3dm?=
 =?utf-8?B?NENjN1hGOG5wNmNpREh0THk3Z2xUdDJIY2NHMTlBNURmQXlvS016Q2Vla1V6?=
 =?utf-8?B?a0svOWEvRVRINHM1OWIzeTI4cjE1ZkozT2ZHUVJZUG94dWMrOXAyQWVWS0Jl?=
 =?utf-8?B?ZXZqa2JJSExiZEdWemczdEVnbmprOWtQMFVhT0xYZlVRYTRrdWI5bWVlcjhh?=
 =?utf-8?B?a1dlKzJIMUd4S0dHMytLbjVhalNob201WjJnejBDSDhNV3pXc3ZaMDQxSm1u?=
 =?utf-8?B?MDZpczFpbjFyU0V2NmNDMTdkdUgyenlQdnRXc2txOHVvRjJ3aWp2NlltNTZu?=
 =?utf-8?B?MVFyOVFVaU83V0VxTzNmZnZZa2llVkhvZHhlU29yNzlrVUVCUnVtQ0NRemZX?=
 =?utf-8?B?YUdGK1NUQ1BmWm8vTThOSXRkdlhnZkNKUDVFTkNobUNyRlNCTG52ckt1bW8y?=
 =?utf-8?B?bWxuZmVNblQrOXlrdmF5eWpVMzlHN2lCbzJHYmhWMXBDZDMrVXptbFh1VXhU?=
 =?utf-8?B?YTcrZ2xmcklHMVZsQU84cWpUYmVVOFMreWx1QjkxU2lpTlpWZ3dQZ1VrR0lo?=
 =?utf-8?B?OEpud2YxbXdmVCtpemRyM1IvVEF5M245QnlQUnNGVFd6Mko2Umsxem1aMTRI?=
 =?utf-8?B?eFBJS2pmbXN5cTByWUh3cW5xdVd0N2kzL1BndC9tZ0xmZjVrTGU0QWM2dTFZ?=
 =?utf-8?B?NW1OU3hzOCtmTHdjN2dRaFFhbm9JaW1MNWEvMjBxRzl1VjhjamlNVHJQZStq?=
 =?utf-8?B?SXozUUNaMXJWZFAxOXpHWnlqa3VnYVhsNndXak95RFdhV21EaElCTjV5QlJZ?=
 =?utf-8?B?TysvS1NuTE9zcis2R2VPd1I1NU9qV0dNOC9qSWUrVEREUUZOVDk1cXk4Zlpa?=
 =?utf-8?B?a3lvUHhBdUIralB1dkl5M3IvOXBlVlU0SHVWSDNjNE56RFpUZHFUUHJEeGwv?=
 =?utf-8?B?NkRyV2tjVE5TNG50NDN5YXRLKzM0OUZ2aXIwd3NMQWEzYkQvWnNsVE5pck1T?=
 =?utf-8?B?RkY4b3RRcy9HZ3hKMDJKTEQxWC8zdy9id2JUMGZoTTJZMTdDb3RsOHlTdmVY?=
 =?utf-8?B?RDZjODErSEp2cXl4MWo2WHcvS1grR0xQV1Vkd1lxZDI3T3lubGtWUnFRVjVS?=
 =?utf-8?B?Y2lpTTZhcTRyZ1BMcTFaSnV4dEg1aEJnYmFuMjNxbXovckdZSnJ3SzRUdjk2?=
 =?utf-8?B?dCt5Ky9IQ09vM1IxbHpra29KNE1rdnNtenBkSVVvMTE3N2FySVVWMmc0b0hl?=
 =?utf-8?B?TzA2ZVJ0M2JycVJtb3pFTnE3UWFoek1XMjFuNmFaRTdySE9jQUNuaVVaeXhM?=
 =?utf-8?B?cVF0R1dKeWszTnFjbTJ1Sjk3enF6SVdDTURHOG9LQkpLSTZlUEkzNEJ6WWpY?=
 =?utf-8?B?M2FRY29FRmlsUUk0M2IwT3hDL3hvaldBdXdCbyt3bWRJNk1ZalFKUUI4YmZ0?=
 =?utf-8?B?ZGNicGJkc2Q0NkgwT21KL3l4U3gweEwrc25BQUNackVmQ1hjZHp3eGtCYnVs?=
 =?utf-8?B?U2tEZUtKcldFaGJ0YWp1UFVZU2d1azdrelhIa01BWG9UTkhMUy92RzkxV3Vi?=
 =?utf-8?B?REpORlZ2RmVkQTJwc1o4eDFnS00vTXpmdTZtVnNXcitFREFNZFFUZ20vWUd4?=
 =?utf-8?B?UC8yYThZdzZNZ0JoQjhxOHIwZmRaMXovVDRyeFRpUEsyS2ErMVBtNDIzczRh?=
 =?utf-8?Q?ObMVfxn2gHTugxifnWkB13Lc9ZWa+8M8?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2024 10:02:43.8968
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b2d04b1e-06c9-4b47-b2dd-08dcce5b0d4e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000397B2.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7188

On Thu, 05 Sep 2024 18:36:28 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.10.9 release.
> There are 183 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 07 Sep 2024 16:35:01 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.9-rc2.gz
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

Linux version:	6.10.9-rc2-g1f09204bb539
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
