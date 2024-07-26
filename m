Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2072.outbound.protection.outlook.com [40.107.94.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7A4521364
	for <patches@lists.linux.dev>; Fri, 26 Jul 2024 17:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722013963; cv=fail; b=HwwGQlk0xAB1ATqmvY/d/vGBY+CNaRsWvxcsM+DHZ2Y7A0G1ZNq7vjaSc/XP22i3C/CjZIQISLX6czYnVZYCS64mHo0IamLnf3PQAvjH+zkPG/sToadawcrr2G6pGt5gsQLurjdNwKqlRsEcU2aNgC0gFpBxf1pVdO31r6x8yUI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722013963; c=relaxed/simple;
	bh=8tZXjA+o4aK3+KIyflFwMHYpdPpdsV9z05SDBGA4Go8=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=h7UHb2WB5V7H9oTmLOWob1/JTJV9yOo5UHZX+FeDgWuTXkLBeumZgUTJ0jVL70AwfO7V52cAP3Dfu2waso+5WuGMATsF4ic2B7/52qQWnmcmqtMyAcKXbiEAVPvuh5O3JdQYwxpQqc7RvLssz2RFxi0nMPkRQjp/uXssgKIZE0Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=mmgLY8j7; arc=fail smtp.client-ip=40.107.94.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="mmgLY8j7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Nfl89tvKElvXX8lh0xT9/regubSX8dm7ssbzkQimddFDzDmq/MFabeoNkBgA9snOv1uul96PkaOpQxLqgk8abrN81sKJpfcJtPck8Y9JVrVUOT8F7Igv5B68Cq1sf2YVh30SSDswL9Q7bW24RosZasQNIYaOhw4v6PT3hBmVnr+9QUc9gGJZVSpckJsHXtOpkVmrH29becLFIl4RQFWYJMYYJ0ZaNQ4d2GRkx/X4yxqJTmXV0YnwbhvPBcFXmh2NuuUz+nf/u5SjenECDk9ejb+0hCv9u0fv95ctsPA9c0eDDRZKES2Ca97d1j8E1gwxJxYV5BwUZJKth57TwGD07g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NZRAxmde7P77v3W0WEIkh7fGK5TLubK83GYw75Zrefw=;
 b=V7rWfxj/qrTYmDGRHQ3o3y+mqTHozUIyF7evxKvbwJIymfeD7sy/HvsFqX6zA6zpdHsCB451oKrYmayn1XoKxVBeAWFLL+XXXq//xfe0FY2sSGVR1lM3wjMVMvQqR5Piz5PwWeQBbMBjBnJA057SYqoJ7/eLePqK1DH4Pn+9XrFt8i0zlQy9J3qyYBpXApfDEb0mN20imhr7aPGqi3BFHjbQbUqoYnuLAK9AG3FhKdJzXNOCfnhVxHNtn32g/PYiTi/qOsJf7As0i3rmz/Or/Of0CpecBbowYkHYM33ZtYlG/wEtTT3A1ZixJufyGK4I6Z7UlUynQj/ZUDZA/9f6GA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NZRAxmde7P77v3W0WEIkh7fGK5TLubK83GYw75Zrefw=;
 b=mmgLY8j7fFPmBwBJjQUa7AYHHU1jSedmAiJMu2uOPYThacYziqq9g58wbOW6KL8GtdlvJLAEopNBlVRT+ApcU7qwRlADFKV/+n3Y58fU6kHu0N9X2B2RvMWWCe5zFgpAV7EoW/B/8G2lBTUtam4rKCAnP369iUYx0aRW0JiazrXbqD19+TJd6xaht4KG2qMXYITK8a4F7FGy0T4Hl7xPXEpGowjEBwzMsA3bQGdx/FAIXlmF1CJh3ytkdGwapKi0pfvgXzd5/vFmIQBsc7Yb7glcawCtJHZbDswMm1re5Qg+I9v9XRpOxJjwt4S6KrG7anqW+fbQDQUXVQQS7IckPw==
Received: from MN0P222CA0016.NAMP222.PROD.OUTLOOK.COM (2603:10b6:208:531::14)
 by CH2PR12MB4309.namprd12.prod.outlook.com (2603:10b6:610:a4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.29; Fri, 26 Jul
 2024 17:12:36 +0000
Received: from MN1PEPF0000F0E1.namprd04.prod.outlook.com
 (2603:10b6:208:531:cafe::a7) by MN0P222CA0016.outlook.office365.com
 (2603:10b6:208:531::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.31 via Frontend
 Transport; Fri, 26 Jul 2024 17:12:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 MN1PEPF0000F0E1.mail.protection.outlook.com (10.167.242.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7784.11 via Frontend Transport; Fri, 26 Jul 2024 17:12:35 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 26 Jul
 2024 10:12:22 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Fri, 26 Jul 2024 10:12:21 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Fri, 26 Jul 2024 10:12:21 -0700
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
Subject: Re: [PATCH 5.10 00/59] 5.10.223-rc1 review
In-Reply-To: <20240725142733.262322603@linuxfoundation.org>
References: <20240725142733.262322603@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <5bf178e6-31f1-42cf-b5f1-cbe4d6ba07d1@drhqmail203.nvidia.com>
Date: Fri, 26 Jul 2024 10:12:21 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E1:EE_|CH2PR12MB4309:EE_
X-MS-Office365-Filtering-Correlation-Id: fd3dadc4-29c1-47c6-a10d-08dcad9624f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700013|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cGt3SE42akNBU3F5dXJvUmNIK3FlakwwUHJMWThOV25raTBMWEJVUi9td3BD?=
 =?utf-8?B?MGVrQWtIYmdWbm1YQ0N5SWNXaXFKZVh5NkNHVWpyUFowcGo5c3NyRlFvYmRF?=
 =?utf-8?B?UmlpK0dNdFlickY3SFYzYmNPWHpTM3R2UTZzUVZYdHMvQ1IxeWUxdmU4L0ht?=
 =?utf-8?B?MDRvZVBSd0RiS3h2NVlEc2xieFc0am5ocjhGdVdXaTd5MWtpSUkyRjVZazVQ?=
 =?utf-8?B?akVOSnphSjd2VGFrY0RJbHhkNVRCUUtuOHprRXF2N2E3VVowbDh3bDNJbmRx?=
 =?utf-8?B?RUlFSlExdmppaWJ2WGxJSDI1RmtndUNnUVV3d3lkVDNFZkVMVzl0VDY2NHE1?=
 =?utf-8?B?OVBnMFRaRFRDOTV0U1RWKzEvc1hhZkFNRWJ4RGxBd1hhMTc0T2ZxWmtrYzZG?=
 =?utf-8?B?MW9LeVE0WDY5REhnWkYyeU1Fc25jdU1YZWlWRDczQ21qTUZTNTlwWHc1LzZl?=
 =?utf-8?B?elF0UHp2d3hqZ2c0ZElYSnloZUF0anZmdFV1emNBckcxa2lUaDdhd1VveGwy?=
 =?utf-8?B?Q2o0dFFBc2ZWVjZad1dXZExOOWRhcDhKbXphWW9OMjJEcnJBQTJpTGhjNzJU?=
 =?utf-8?B?UkR3d0Y4WUQydEMrRTFYWXBLYUlQaDkwdGppSER6SEd2Nk9nT1NMNU04Z2dS?=
 =?utf-8?B?NjNmcHIwZ290STY0RVFaeFRibTAzZkxadHp3TTN0ZjhGQmRqT25oOElSNEJY?=
 =?utf-8?B?Vmw4NTk2MjJpTk54WmJDbytFazNRUEc5Q0xud0JXT1hhUms5MS8zbkRxeUxG?=
 =?utf-8?B?dXp5L2lQTXZyNXAwbSsvNmYxMkM5RkZRZld4cTJDYjNnL2xUODM2d1gwam93?=
 =?utf-8?B?N3dWeVJWeWRodGM5LzlxRXU0V2l6dEszL2xPRVFlZWFqL1FQdlRYeTU4SmFa?=
 =?utf-8?B?QUhLTVNNMXdrNHZ5ZjZEdkhxMk9qQnc5aENCMFBnM1RUdDN1ZW5LZkNKcW9K?=
 =?utf-8?B?N1pvTk8zdnRnMUNncHVQMWYzM0p1U3NGRktoenZ1dUV4dmJraXJka3UzejMv?=
 =?utf-8?B?NUl2Y0tTNThGTDltSUNYYzFKVDFXaDk2d0dSMXhqbThxN0MzRVFOOUtNR3M1?=
 =?utf-8?B?Rk1MSVc2citXWDU4Mjd4ZzNDajRqd2R1S3JTY29qSWQvL1JDRXROeEhSTmp1?=
 =?utf-8?B?SXRHTnA0UGcwUFpwNko3ZnNwWXowa1YzVW9kbWlvSHUzK0lWbjlDaXh6eGM4?=
 =?utf-8?B?c0k0T2d1WmhKSXpZMDkyQ3p0N0Q3MXZEM05CZlZNV0F2T01ONjlFTS82ZDMw?=
 =?utf-8?B?SExrRjBBWHpDOGRhR0FyUERZd1lFTm9HbHpUZFh5c25TdGZ5ZStMejh3VGw3?=
 =?utf-8?B?eDltZ2ZIU2Mrd2JJR0o0MnpxSW53V01najRlMVp5T2FYbXpFck1RQlFOVlUv?=
 =?utf-8?B?QWFPajMwbFplR05xRG5pclZ6aWEzbjVQTzh5clVMVFZFUXN2eVR4L05XekVp?=
 =?utf-8?B?MGliTmc5TVJjRFpNb04vZEVxdWMrMDNJYTJEQWdXbzFERkMyVHNQalpydVBs?=
 =?utf-8?B?ZEMwYmJySnRpL2xPNEt3enh5RTBXQndpUWp2Tlo5L2Y2L2QzSi96anYrbGtD?=
 =?utf-8?B?OUc1UGd4MkZobk1scWJRUkdNZkVwbThRbmJCYWRLeWU0RENIZmNWOHFpY3Ri?=
 =?utf-8?B?TlJnbnpVQ3paVm4zb2pCKzBxV2RONjhRR0h0RnY4VlM2bktYVXFia25kN3BX?=
 =?utf-8?B?UFRUTDgvWGQ1VUtwNGFrRUJhSjRVZDZ6TW5ETk5aS0Z1WlR6UjQ5ZVZrYmJD?=
 =?utf-8?B?c1U3alo2TVRUQ2RTV3c3dCtHcUtPRHpTOFArTFVnaXdsaHZPbE1zZ1FPOUtq?=
 =?utf-8?B?U0JzUTJTcTNIcEVOSjkrN29BY0MreHoyZVh3bnFYeWVYdHNBMzVnMU9aOVkx?=
 =?utf-8?B?MFB6Yi9NSVRzdUdhN2lyZldqa1lVc3hFTWZ0d3lTU1dDMWIreTRhWmFkZno4?=
 =?utf-8?Q?osgDyCHBT80nXaplk0fvDc7aWvAthP9n?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700013)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2024 17:12:35.4447
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fd3dadc4-29c1-47c6-a10d-08dcad9624f4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E1.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4309

On Thu, 25 Jul 2024 16:36:50 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.223 release.
> There are 59 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 27 Jul 2024 14:27:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.223-rc1.gz
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
    68 tests:	68 pass, 0 fail

Linux version:	5.10.223-rc1-g0f0134bb137e
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
