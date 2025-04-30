Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2079.outbound.protection.outlook.com [40.107.236.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7973F1B6D01
	for <patches@lists.linux.dev>; Wed, 30 Apr 2025 15:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746025462; cv=fail; b=ouZT8yvBfsGqZA1rzD5l6dIDs4eARe9qLn1SzCq14kgJrjzjZO+lZUmzD9c6ygbNtBUpkl41kwi+nIlvxGOdhUxWWqlS9GEPe60oGRuvqZBW56eyfvijcp1KJ3+cky0jRMM9mxpdYD/ris8OWIcgdx5wK33VKTXORdshQ2xIvxI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746025462; c=relaxed/simple;
	bh=a2AzQkx0oYQTTxwrrRsZLFBWWnS5h+AP0sXfZFRtXP4=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=J+GodIfFs37lV+5F9J2PoGJVKSx9YydH3lqSWRjMJIrsKUNAHqfRJ4VHepF7IdU7khbBf3ZL9rxC1rMbKM/f6SaF6kAdM0ZuCLXMwYHXcagLY5VKZPpzRRrjtKUMqeQPh5vtVQRGX6vcn80t/dLdLMEFArefs99shZqxpff0/yk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=tqx7ubKm; arc=fail smtp.client-ip=40.107.236.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="tqx7ubKm"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pnAs4HEpGNWaagKSL8chWkF69N8wbBDCJPYOKyKu+KqDR56U+OQEl2+wk4naenQ1dZSeb+/kqe7YmG/KZHb3S7p/Iq3vALIxm7BH0Wjl2bJ1XNX4EQaMHwRN+i3/fXwO1DcYeoBsZTn2GMl0KEK6Cv+/ZBAViAsx+Ds+8nY4/U5eDF57LwEhIQhlubO60tFqvPvFZBFQwbP4BYFWZQzEf5tf9Qc/nHbdkhV+XF7rtell5xmTBCLOchzNCYOcqlKSl77h+fOkzmbcESaUE0vocEIbWviZIMbjlR9tyjCHwtLBJn6hyiYfDQTNW4dnTTURz9aJoiPpKWtGjyG2DCQzeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QH7qJYNe7m8tv+g7599lUv8SWHnMepDc7+x6Pz4KAHw=;
 b=aSOi7S9UA/p4giIwPWh0eT/wmOgqkM167YFbvQB5N17VKaqs+iRTIYOOxDOyYFE72OQLGOxVDVTDa2otLyydzpmkG0f4Hh8odZ92Aatye5Vem1pacVxszzYQknhP7VPVMkiAo8mBL6TxG/Tkl3V3X4DzBKQgePTP/k670Jq1PKQ3ruhmJyitqyIYlabyOZFwLGR7gkRAumzcCDA9OooMBOca7LkL3BfVMMEDQS1XuEE+63XkBXOOyIEA7N7enVuK+lBHIrEE/36rrmtBpy8FAP13ueYa7lBv50dAkGlhXxObN0N69SgO3B6BNhQsaSryKhYHvynt8G1Ga9mup57v9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QH7qJYNe7m8tv+g7599lUv8SWHnMepDc7+x6Pz4KAHw=;
 b=tqx7ubKmcFc/DqIID5JJoRFRr/vW1nTtfX/KX7sPn+/TzhZJ8/jtTrXjK9RBciUpyF+2uTUPg456QWciWlX7RarSoucz6vXHsBBRrSul9Elr+339M/pPxaRcYfjkfZQHXSxkZzPJTdx4CWvDFaL3bqKLbIN1ez5VBvGVS2ridP+MUxBDjjzpTn6pMOgVIWnO3HFEcErqKP7ewRRg1ZtDTVhkVsi2/DX1SxQwFpMJxrRc7PXqvU3yDfrBDEOG4YMkxVvLcHjz54Dqrmtpm8LJrGGuzQ/OLv5+c9UbnliwzjlrO6cVveMh71Y74ha/vXv5J/F/z1a+U959IDGL9pSQ8g==
Received: from SJ0PR05CA0144.namprd05.prod.outlook.com (2603:10b6:a03:33d::29)
 by CH3PR12MB9432.namprd12.prod.outlook.com (2603:10b6:610:1c7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.19; Wed, 30 Apr
 2025 15:04:16 +0000
Received: from SJ1PEPF000023D9.namprd21.prod.outlook.com
 (2603:10b6:a03:33d:cafe::e8) by SJ0PR05CA0144.outlook.office365.com
 (2603:10b6:a03:33d::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.33 via Frontend Transport; Wed,
 30 Apr 2025 15:04:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ1PEPF000023D9.mail.protection.outlook.com (10.167.244.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8722.2 via Frontend Transport; Wed, 30 Apr 2025 15:04:15 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 30 Apr
 2025 08:04:04 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 30 Apr
 2025 08:04:03 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 30 Apr 2025 08:04:03 -0700
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
Subject: Re: [PATCH 6.1 000/167] 6.1.136-rc1 review
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <3403e756-077f-4a6d-b26c-72fed355d117@rnnvmail201.nvidia.com>
Date: Wed, 30 Apr 2025 08:04:03 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023D9:EE_|CH3PR12MB9432:EE_
X-MS-Office365-Filtering-Correlation-Id: 64829540-3a40-4bd4-2715-08dd87f8467c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MWgrZWNQb2JabjU3RDZ5Z3dYNFFVQzFYNWRVRk8yaEdJV2ErZWVGUG9pUWN3?=
 =?utf-8?B?SmZkWGxUeHdJR0JUTG1qeU95VGxsYnpXUFBKZ3ZPY3hhYVNtQVlOcitWeDll?=
 =?utf-8?B?L2ZqVGtKYmxVYmh6MkRYNkFSV3VpdFdJQW1CU0hmdk9zSUhSN1Z0VFN4L3hp?=
 =?utf-8?B?bmMvTzBjMDJFV2Y3Y2YvNjN5L3dVMWhtU0l0dGRmcCswZVg5RUQ1Qk0vVXd0?=
 =?utf-8?B?azFsWFRaQlovcDFpaXhyY1FCUkh1US9NR2x5N2tLTVByUU9wVlpya1Q3Nkgy?=
 =?utf-8?B?UWRYYzN2c1VLcUNUNWpWR3VKSmhzbVFMRWZGUTBTcCtRRmVRcGR0RmJmTHJS?=
 =?utf-8?B?dS9ITzVPOTN6ZUlKU2VyNFlsN3J5cGl6dVEzNm9GVlB6N2hQMkhhY21ZWnRM?=
 =?utf-8?B?cG90eTE2NDB4ckRrWWJOa0t5anJWTGZ3NXorQjI2NE94ZExBWUlBc3Z5ekVm?=
 =?utf-8?B?YmRPK0tyYVVSVDh1RnpaNGR4RzlFbC9ONmxTRE40WFErQ2JGUjVxR2NpSWgz?=
 =?utf-8?B?R2RYcTAwMTdHUkNXbUd1d2E2OUZaaHB0dHN3L2ZITms4aThtYmQ5QmtPWW1T?=
 =?utf-8?B?SmZIK0p1dEZtMjZ4OFRKVHpxZWg1WU9YY3RPQ2RjTTNYOG5Nbnk2bnBYTmNo?=
 =?utf-8?B?ZUREZU9RSzZiUFJKSVBVV1NTaVJGcy9EU01oVXN4NHlyOTlTc283Zy9vLzdm?=
 =?utf-8?B?eVV5MHE5T2gwZzFjK29UNWxkL3ByTkw5djRUZk4wa3RBcjIydVFOdWE4NXRY?=
 =?utf-8?B?UXZjUFUxdmVSZVl1dFZtVW53b3YydzJPbzRjQ2dXS2VZais4RHV1MERwOUhY?=
 =?utf-8?B?V3RHNms0bVpRanErOVhUQ29vSTZ6TTlXNm1TSEJBcmNUdUVoUUd2cFhUcTNL?=
 =?utf-8?B?ZldWYmJyT0Vzejc4aUI1Zlp4ZzJQZzJsSjdqbUV1NUY5VEZ4cE1XQjRlR3A0?=
 =?utf-8?B?Y2d4cEtlNndFZWRpTUpVeW9zNlBoR3k0OGIxNjRIa25lL1Z2cCtEbW1GR0J4?=
 =?utf-8?B?RW1aSUVrOEJXY2srYU0zdjAwTFRqSXlsR2drMlorOHdHZFptbHg0V2VGTTlo?=
 =?utf-8?B?ODF1RnJYcXljcnI2Zlg5Rnp1MlR2Q0xLTW5IZWlPNUcwbENFMFUxRkZXcnNq?=
 =?utf-8?B?Z0hvbjh2U1FwWElueTVFek5UanlVck1hWEQvN3ZTVXJCSEVwV2ZqKzcvVVh4?=
 =?utf-8?B?ZVoydkI3bUE4ZVd4NFN4bGx6OTZFWU9DdUg1cU0xWUx5STV3S2FsQnJvc3Uw?=
 =?utf-8?B?bmUvNEJhRjR5a0piN3J2UnNhR2VkRyszeWJGZW55aGtpSmEzbkV5ZFdVUmgx?=
 =?utf-8?B?elZNellPajM0S1RRVUFkNFpyblRkbXpiS2dlVTVPWkw0MzdlbUV4eWkvc2lG?=
 =?utf-8?B?dGtKZ1FLZmp1emwxSkEyTWNoVXRKQUs3b1VYUFBUOElTaHV0bE5zNzBBT0Zr?=
 =?utf-8?B?blpZWlVjMzljSUcrVWtkbWNPWUFRUDZKRGJpU3l3QWVEWG42R083Q0s4NFBR?=
 =?utf-8?B?VHZHb0p2K2V4Q29VeXRLemRHb0lOOE9Sbjl4RWl0Mk9PeURsaHRQanZWT0l5?=
 =?utf-8?B?U0tRd2tsM010NW5nZkdaRDJWdkNaVWVmemFYS251QXh4NFJKRlA0QTJubVcy?=
 =?utf-8?B?ME9ISmg2cXdXWjdWdjJ4MGRuV0JCMmk4RUVZTWtxZG5rWThqdGY3YmFSMHZV?=
 =?utf-8?B?emNYYzliWW5kemtyZ1FMaVczMXdQYTFGaHJqQ0RoekgwS0RIdXZVaHppU1ow?=
 =?utf-8?B?RitJb2p6bDBRWVVLZEd6MTNqcmx2cWFKUU8vaVV6LzFFbjdqSDI1bGVtcTVV?=
 =?utf-8?B?QXpkZDRkTTU0RmRZcmg5VWdsMEFNRUVIRTJGejQyK01BR3ZPOVVjZ2QvNFZG?=
 =?utf-8?B?a0NsWktkZlh3OFFwR0ZNd1htWm9vS2JtZ1FXZnpNSW1hR2pEd25xQ25kL05X?=
 =?utf-8?B?dFpVZnM2NXpJajFoR0M1b2xLeWZTSEhmaGhGZVdHZVQ2TmZNZ2VQWU12b1Bl?=
 =?utf-8?B?Tm0wMDV0a01WOVdXc2NUakU5N2pyWlJSc1A3U0JSRGlnNGZLdG5udW5Ea1hR?=
 =?utf-8?B?QWFpNll5SGg2ZEhWckVwWmIrR3NMZlFvdDJyUT09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2025 15:04:15.9376
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 64829540-3a40-4bd4-2715-08dd87f8467c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023D9.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9432

On Tue, 29 Apr 2025 18:41:48 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.136 release.
> There are 167 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 01 May 2025 16:10:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.136-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Failures detected for Tegra ...

Test results for stable-v6.1:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    105 tests:	100 pass, 5 fail

Linux version:	6.1.136-rc1-g961a5173f29d
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Test failures:	tegra186-p2771-0000: cpu-hotplug
                tegra194-p2972-0000: pm-system-suspend.sh
                tegra210-p2371-2180: cpu-hotplug
                tegra210-p3450-0000: cpu-hotplug


Jon
