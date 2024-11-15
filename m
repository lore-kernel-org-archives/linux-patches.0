Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2086.outbound.protection.outlook.com [40.107.95.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E971D8DE0
	for <patches@lists.linux.dev>; Fri, 15 Nov 2024 18:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731694308; cv=fail; b=Zrl3P8Ru2C94cSTXGbferBONDtf/fgUztm1YsI3sg+imAOJdp46B1XHgc3rDV890sGMH0JDGZldFjY0leTldoazIix7nBg3G42DjcmCoCLf9lpQmy6uUbb2pZ3K+0AKK4g4R/RQKmS2Gm5GQZ2s0dCN/0W+EKanl2OVNaydbH2Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731694308; c=relaxed/simple;
	bh=CX2/zagkZby9r7moKKAVfQYLC483GC7UPz3I11Agg90=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=Yowfi6H1BGJUetJMXY29rpY9SckurqrQqaWRQqXhMSyGfKPJBMcYfp0WJ9ruRwuoZh0I3NUug3dPEX2XZzTCMrAgSoiOiegI7h36eF9DthEI9ZTrsjegEi5y807ku/nM/Bilatfff8sHoyS3mDDPsMiZGhGTzI9CFR5h1+cE05I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kTTuCP2q; arc=fail smtp.client-ip=40.107.95.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kTTuCP2q"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LG0BVB5ZUzZCaL9IgGY88lgWnGELNthctMYbiijBUzWNnG3CUM0mKohwmRCcnYjeoJH1a5A6Wp9yvWAJuDweDbBPMXjIFIguwkjwQWcKUglOfMlbtG2if5MmjxPHOW3UNxJCxEmn7tps9PUzrrOreclHAVH7YIempMj0M0Lir93ll+TtETpBSXR4asHl6o6AbvdFrQ22uwtBR64ebZhv67OvvHxxPhQ3+EtkPNA/L4mOqQHNqnB/O8ZlqX7WQlRJ8x5bPVKd9fO6mfyN6iJ6yesutp+B0QL0w7Gkk4EUAvkWL4cfJfMcC7c+eBj2Th8tNtQHE8Qzrl78ajTyuCDQAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WGASD9eC/VwQqcBmNNsIWcX0n2aCgiNYHDkQaXtL4i8=;
 b=a47W9Jv55o3N9Zg38wieV5QKt+y9RbxGXmRghgh1tmTHe9+rHscjW1xeM745iQRcOlhqZIm3OBZD1Dy21IKEvQIJwuN4krs9meG6pixtAa2zOSQm/BGLWnmddOupairyBozGwTVVy8Q8j8fi4kT8W7XSwTCcmKzcXnZG5KJSZFoW1zebMBbDmrC0dNzSDnm/y37/jGWejdBN6oWwwT0S/Sv2z1yC0wa+YBqDjU+M0mNxyErLUXMKqk53CJiL24oMcBobvc/wzrJlI/HC9dk8107Ycn5KiUosYJP5ktTyWpca9t/nl7cSLtFl+/Ya35ZJeS68aE4JU5dqz4Jpth8+XA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WGASD9eC/VwQqcBmNNsIWcX0n2aCgiNYHDkQaXtL4i8=;
 b=kTTuCP2qclhg2HY4EZKsAHQMeVnd4E85z9xMtSmWT4ZJTuEwNpY5xRBDiN8/0AcXyM60XquxR6xrnVFnkSKQBHlpVGz6LmOik3Zfg4JYK+OrUn0I1RVjEH1N8APRxwwenLn5XIZHXLkwmcjyJEfx0Khd8JN4vuCefuUcGNCImfztLtelylL41BrrVRIXlJlJ5HSACI0T5sG3GEUJhWA09lQ45oBM1Qegw81nRjR10gzemaWuETuFX9aWdq2WfSpV8biXDE/Q0RJeNit77hOgZ8gX/9+yst2P/ZLmg0tQWX9OpU7MFBi4gJ49CkcWCWXotecXYYU57V1ZacKdeLk47g==
Received: from BYAPR11CA0101.namprd11.prod.outlook.com (2603:10b6:a03:f4::42)
 by CH3PR12MB8901.namprd12.prod.outlook.com (2603:10b6:610:180::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.17; Fri, 15 Nov
 2024 18:11:38 +0000
Received: from SJ5PEPF000001CC.namprd05.prod.outlook.com
 (2603:10b6:a03:f4:cafe::c1) by BYAPR11CA0101.outlook.office365.com
 (2603:10b6:a03:f4::42) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.16 via Frontend
 Transport; Fri, 15 Nov 2024 18:11:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SJ5PEPF000001CC.mail.protection.outlook.com (10.167.242.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8158.14 via Frontend Transport; Fri, 15 Nov 2024 18:11:38 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 15 Nov
 2024 10:11:34 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Fri, 15 Nov 2024 10:11:34 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Fri, 15 Nov 2024 10:11:34 -0800
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
Subject: Re: [PATCH 6.11 00/63] 6.11.9-rc1 review
In-Reply-To: <20241115063725.892410236@linuxfoundation.org>
References: <20241115063725.892410236@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <ca2cb367-103c-4547-bfad-2e015d77005f@drhqmail202.nvidia.com>
Date: Fri, 15 Nov 2024 10:11:34 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001CC:EE_|CH3PR12MB8901:EE_
X-MS-Office365-Filtering-Correlation-Id: f741ee07-cb05-4b6f-4b03-08dd05a0f2fb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MXl6QjBPc3BpS3VqT3BNUWt1V2JJbEZRQlkrU1JoRXg0MUk2bEE0NFd2TFd4?=
 =?utf-8?B?dW5aUTBGc042K2tPWnRQbUNOd2tGR2RmTWtVZWlLbG1MMjhSU2FJYjFWcVRZ?=
 =?utf-8?B?dmk2WWJ3UmdJU0FnRnBLemtuNGJrMFFlWXZPMTd0aDQyUUxUUVpZcVRycDhD?=
 =?utf-8?B?UDlRU2lOVEZXZjZOaFFWMlJLbDc3eHF1V21uV09nSldHOVdDanhZM1cwejhQ?=
 =?utf-8?B?RHZoVGYyVjlWU2ZjREgydklyMEhuaXpoTjY3cTQ5VjFsN3BLOXNId0ZGK1pz?=
 =?utf-8?B?TytTTnQ0SGFNK1R3ZzdDU2FxbHd1YmVDWEZCOXdhZFN0RjFRRlpXc0J0aVVQ?=
 =?utf-8?B?dSszM2NGeURUR1MxekYwS0ZDb0lnQUpmb25Uai9SYnQva0VUS01wdmVSU3lH?=
 =?utf-8?B?MTBncWhQQVMvSi9SVUVNZG4rSEVaSkgyVjB3dERPeTFhK2lPb0dOQml2aE5L?=
 =?utf-8?B?YW52MXVmcitsNC9tSjBmRTJnTi9ObVFBVDA5NkJ2bmlKY2c5ZTNIc2ZjWmdI?=
 =?utf-8?B?aVhQUUVPUjhTeUNZNmlFVmhsaEdmVGJxYVVYRytHR0M5MTkwZW9pRUxGa1Br?=
 =?utf-8?B?WURzNlRKMG95a3lTQURtY3Y4U0pTb3M3QTZzSHFndjRnSDVyV0dQUkh5Z2pX?=
 =?utf-8?B?RUZqOEtnOUlkcnl2WnpraWoyekJhWG13OHI5RVRYRWNSSDg0bmRIUmE2czg1?=
 =?utf-8?B?SjRnZnFJY3ptQi8rdytFWVl4ZEphTUptZHRia0xwSG1jNFNDOXdPV0JwblhL?=
 =?utf-8?B?T0lIZHhXZk1XUGRtdXE2QjlTNlRTWEgwNlliYTdBNnMxUng1TWExUk9DQmtu?=
 =?utf-8?B?c3ZpKzgxVVBpVW5oaHRwZldjNm11UWRJditjUlNzV3BqMlRNT1Y3eDd6S0NF?=
 =?utf-8?B?SnE5WWM1RlZNd09OMzQ0RkJhZWZROVVPdmt3QmloUWFYQndxMjZuSjZNVWwv?=
 =?utf-8?B?RTM5THI3MlJPOVZ5YjFGclBVaFRoNkw0bzhSZzRPcU0rODJ0QktuR0E5dlRs?=
 =?utf-8?B?WG9veGRFakI5S3pkUjRTcXJ3VFQxckdmUit3TFY2eVVHUG5Gc1hJK3FDUHlE?=
 =?utf-8?B?VHh2dndwQW9XbytsQURmTFBtQ2JGTmtvZm4yM25sNytsWHFDMEc1cWNpQlRr?=
 =?utf-8?B?SENYZFMrK1dwZHgyd1Roakl2UFhIZWFvSGxEZHg2MFpiQjBIb3VDRWdZWEVy?=
 =?utf-8?B?RXBVZy91QVpzR2QzUkFGbkpvblZZSVVkbTZ2eVBQT0FZTHdUL0U5Z1Y2NTJF?=
 =?utf-8?B?MFE2UVV0SmFuQ3JLeDJTYlJ3ckp4aW01dk50ajJVNUVibFhSUDBKempxTHBy?=
 =?utf-8?B?OWhVdGlKVHQ5aUFzelFnZnhDLzh4dGp4U0lmN0xaN0pGRXZEOWt4MFVxR29z?=
 =?utf-8?B?ZWVTY2lnTmVQYVhlbnJQb25namZTNjd4ZnA3bDRjNUxSYUFyWDRWSXlLb3Zs?=
 =?utf-8?B?eGgxUmRFRVpucWhLVko5YzlEcEZjZncxUkNlMEg1dWc0ZmFhclB1WmdyZkpM?=
 =?utf-8?B?OGlQUnVyVmxNTjZ6VEhOb0RSWHVYYmlwNHhlZkZHVUtUWVdZTGYwOU5YS09p?=
 =?utf-8?B?UXFoZzRPaUtNbFgzMDlUYldVR3ZGRU9HNnhERkgyWjRjVUdkbFRkYVFsNlFO?=
 =?utf-8?B?bExicVlnc21RbjVyZGJqSFZvV2greHFoV2hmMHRHNTgxNFc2QzNiZ2lCUDBN?=
 =?utf-8?B?c2xnZXNaZXhHMGhDUHpIa2tyV2hvZlArN1JRODVBUjNlUHlDRkxSNm9sYVB5?=
 =?utf-8?B?NjYvdHZ0N0dITmxUU2gwdEpXRC9Edm5SUHpxNFM2TURxUC9mdTYwcCtwQ3Bt?=
 =?utf-8?B?M3FDMzVRM2RscUt2UVBCRkgzek9RbDBVMWZhdkJBNnRHc0lKOHZuUUFqR1Rt?=
 =?utf-8?B?aFZ1d3U1NFMxQUE1RjZucnNUNmdGNW90ZStKRlZGMXl3aWc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2024 18:11:38.5627
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f741ee07-cb05-4b6f-4b03-08dd05a0f2fb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001CC.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8901

On Fri, 15 Nov 2024 07:37:23 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.11.9 release.
> There are 63 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 17 Nov 2024 06:37:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.11.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.11.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.11:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.11.9-rc1-g0862a6020163
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
