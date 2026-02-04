Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012025.outbound.protection.outlook.com [40.93.195.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B1E9347FDE
	for <patches@lists.linux.dev>; Wed,  4 Feb 2026 20:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.25
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770236891; cv=fail; b=CJsaSk9JM7j+3Rg3nCnBIG4Nj/Sz5ZaVDtFUWYyGvjwuZI8tO/4odRnlK3MLSpWRaBmYiC/7RNNTFJEzuPmWypnvZX8JKUELIxaXOrb0+/61QjuZnAsi0cDuryUMjtu+P6zg7nYFSPUC30IpuMczqp2ZtRN+hNxvtLTfHj6AHEY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770236891; c=relaxed/simple;
	bh=Ag71lAXVKEstosL1iXjezVlauZuTtZn7953Qk2bwZ+Q=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=W/A1T1yFKkXZrOhAxT4svcLMru+YU/AP1jEWfyLrL4yc/ptOqsyhDvje2HVPkvknUfArPOpDOM9Q/6m4bdl+FRe/CI0mA7SZRZRoWEmRAJvT9INkJVuoeV6isreTbDBUun3MGXfyDxNFfnR1SbZpkeJX9cBxl8fdw0UR8pnhVJ8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=SkZqQ3Xe; arc=fail smtp.client-ip=40.93.195.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="SkZqQ3Xe"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fspyyS2GjhLty/YnL9fCEyMFNep86olDxOUELUTQxbALFCWJP9meI1IM0+zauuxSIkpFFIhr5XfogT/PTHB2iz9w/W9BMunyrhb7M5F0GrXA67s2xZcU0mmH9DasdN2mj5XkQ+alm/8ussFP5nJjMn+WpW2WhIFRRJP65B3lB7Muva4RIjpzFafEN0+fiBcUjsSNhw2wpGQsBxEjzJ7pb5xBd1BAythFAxVJHNJ7sRNrjeEKi1YzGnIiy97f9p0iAeM34Ezy5xSpYMynvFoW9QJp5q13Imp0zNR4avlYzOCnSSPLx01o8d7GFXG0xHvKfONJN9uPPjFP00/TbpxhnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=map2LZHKhJ2/SUd/cAuMHTDV0LbVnftZsaihR/vfo6s=;
 b=m96KZn57Ro+EWQblIuTNODCzxCzSz2OvXSvMHpEQgVURV1khgMYdiVIDQzPbvZkoVNcjYum4c2RhPcC9grepFGld634+Wn394cD9PFXj4kRsMXGrtPijW2QJE7Q0mfqp7fek9Liny7FBkCMTw4mizENpTTgmxWe0x2LSxxwaswoJ5TiA4u50G98ebEr+iKeILtOFoto2t8TGK+IBYkActy5Wi6sniQ6jOY5Ejha3lL1e2cqfKo+oizzgAUhZns9+c8MlN//j83S6YouxLB/CBjgxlTsPZdMb+Z7rhaLkYzYoFwcxWvLSxyuIT8Hr8wny28RdeYZ9dStG8xw4pTQEig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=map2LZHKhJ2/SUd/cAuMHTDV0LbVnftZsaihR/vfo6s=;
 b=SkZqQ3XebqGaXv5VKbgt/pJCFsArKI2bYyfrOx/AbYODLAkpRRFVtvjgfuT7aaKIn4JZ2xbxnzRXXzIKhqHtsCCr5mTkNcVU64cGusVyl+R2bMoWaSFKhrZ3Hc5t67XuZXceAvgUy3q+Jne0Eo1lt9LikwT4ifsotWuWKFZzqGBKDrOBS2NsQBT175rCqzYvbgS8CWAyImqrakuwhJgjGquXzcOgus+5Hitdm3uYM/r3Jfs8hl37XoEspK4QmHop6gPwZT8o1bObu8KPJkBuTWVandtfd/RhEPJxlckOkQPpHZxVBrT8oqovnaaYjjcQDiQEKqy4XsZblrZpt4G4Ig==
Received: from SA9PR13CA0150.namprd13.prod.outlook.com (2603:10b6:806:27::35)
 by PH8PR12MB6964.namprd12.prod.outlook.com (2603:10b6:510:1bf::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.12; Wed, 4 Feb
 2026 20:28:04 +0000
Received: from SN1PEPF0002636B.namprd02.prod.outlook.com
 (2603:10b6:806:27:cafe::79) by SA9PR13CA0150.outlook.office365.com
 (2603:10b6:806:27::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9587.13 via Frontend Transport; Wed,
 4 Feb 2026 20:27:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SN1PEPF0002636B.mail.protection.outlook.com (10.167.241.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.10 via Frontend Transport; Wed, 4 Feb 2026 20:28:04 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 4 Feb
 2026 12:27:43 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 4 Feb
 2026 12:27:43 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Wed, 4 Feb 2026 12:27:42 -0800
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <rwarsow@gmx.de>,
	<conor@kernel.org>, <hargar@microsoft.com>, <broonie@kernel.org>,
	<achill@achill.org>, <sr@sladewatkins.com>, <linux-tegra@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH 6.18 000/122] 6.18.9-rc1 review
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
References: <20260204143851.857060534@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <833f7c38-7f4a-4455-8d42-bbf7d6f832ea@rnnvmail201.nvidia.com>
Date: Wed, 4 Feb 2026 12:27:42 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002636B:EE_|PH8PR12MB6964:EE_
X-MS-Office365-Filtering-Correlation-Id: afb24a61-6bad-40a3-71fb-08de642be635
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|36860700013|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VHBseG9nU09KM0EwcWQ5Qk9zN3VqOTdBWE5RQWIyeGNpbXBKYXRVbkxmK2J6?=
 =?utf-8?B?UXRneDgrV240VzRsV3FCNFcxR3JCaEx0aFI0N3pjWmdndGlWUkRLaitLcld4?=
 =?utf-8?B?VGFSUlp1bmdkUTc5enJFeGxoaXlHSng3L2cxMXR1a2grbTBLUStmMFpMcU81?=
 =?utf-8?B?NWVBMGFHWlBHQmlaYllOY0g5VUxKT1kzREpDU3pFc3R1ODRyWW9IQ00xVXFZ?=
 =?utf-8?B?c1VhT2x5Zks5Yy95S0s2NFk3dVVmTXNWaFBRU2xkTFR5TkpsRmJXWFFEa3Mr?=
 =?utf-8?B?azczRmVIZlhIMUtZcndaRGRHRC9YNVpGMUN6ZHhuUVhWeGV4NW5vT0NTeTY2?=
 =?utf-8?B?RWNRTng1NWgyOVdKei8xMVVnMEJOR3pSZU1rOUwzNUJjcDMwTjFqS05vcjIy?=
 =?utf-8?B?OUZwSVZmS3creEYrM25wS1hBRUNzaTdCVjZFcFJ2SS93dnFnOTQ3ZW42bElD?=
 =?utf-8?B?U25XZlVhYU5UeHd4WnFxZzBqL3pnMG1qdG9LamVIUU9FQ3dCb0gweUdSRXZZ?=
 =?utf-8?B?RFl4dTRBQVBpbDhrQmNCd3B1aHhrckNoam5mZW0yV3A4bk9jTjdHSlI4YmUv?=
 =?utf-8?B?Nmo5ekpVUjlyL3UyZHVQNTlvcVFwaU1xeHVGWGp6YzcyYlpRd1IzdFBXWi9p?=
 =?utf-8?B?bTg0NmN4NXI2NFdDR0laYzVvdmpuS1ZQcFNqOHlra3dhQkdkUno3bm9BMXZ4?=
 =?utf-8?B?dHNIVmpoV3ZtZWJNQmUvaGZxczNxdzN4L3F1QmFZRnFuZGxUTmZ6MGd6bnI5?=
 =?utf-8?B?OEh5WEttV0V2N3JieDhOL0J2cUxVdTUxY3YremxpS21jWE5CVjFIRE10cVYw?=
 =?utf-8?B?cjI0R1hieFo1YkcwcHNPWjFsNXloK0EvM2YxUjgwYUxSVGs1dG1jVUJiZ1pz?=
 =?utf-8?B?NWFNTkloOEVuNitNRUVwcTUyazB2ekVTanZTMHBIVkZ4UUdCQ2h2MjYxbC9T?=
 =?utf-8?B?T2hkajJUeUVyWXlaT3I0V01nRzcvcC9SNUErVGplakd5N1J3UnJVeDlkZGhX?=
 =?utf-8?B?Sk4weFlQNGxiOTd5U3h3THU3NlZvb0M4UDVCREVPUWpZMVZabEFvbE5mYTdC?=
 =?utf-8?B?eThVYk1BTzJjeCtHVUU3NjYxTDk1MHBJMnBzL1VndWU2UVZoZEV5TGMvdndn?=
 =?utf-8?B?TkltQ1RoZ29WOU5talUreDhGdjJrcGhVZ2h3TTlPYkwzTFB2R3lJSTBtUnFF?=
 =?utf-8?B?VGRIbFFud0FuaEtlcUhBb2EzQm1ENlU0ZkgwYmdrdWplbCsrdnZMRjlmQW1x?=
 =?utf-8?B?Sy94VHFUckhrbmdmYUF2V0doT2RUNHhPSDcraTVMV2xmYmlRUVBQRm1pUXJ1?=
 =?utf-8?B?THl2aVBUallOdFhNRldsZkkxVjh1d0JOQnZTZ2xEZzd4ZUxGZ0c4RGhyODE5?=
 =?utf-8?B?NEJObm1uSlVwdW9zd0xVelVJT29KZXpSMTFOZWQ5eWw2UnZwN1cra0NnTlhO?=
 =?utf-8?B?WjFjU1VxTUpaY1l6aDc5a2Z3bGdsczJFcmxmV2JaSmRKYlZ3MW5wVG04QWF3?=
 =?utf-8?B?VzRmeHZ2ZFZROXBDUHRLdmR3L0ZJUXF1dzFZRll1VVY0Wk54QVpreWtrOXJo?=
 =?utf-8?B?MGgwaUF5UGRTdElKZ29yWWllazF4eTdKZForY0Z3a1l1K1pxOTJ0clROeVhB?=
 =?utf-8?B?NXJkZ2JDMnliTm9ybzd5SVVmNDJ4bENnTFgzT29YYURyK2VVQkZWcFd6enNu?=
 =?utf-8?B?cWFSTEtOZVNiTGlUWVpCZmtUYlh5RVZYQ1IzR1F0WHdSb042b2tKV0FhaVZt?=
 =?utf-8?B?OUtieVZDY1JHUXp3bjZ3T3ZEcW5qZHVERmgybmFHbDRzV241bWFhcDEwSE1F?=
 =?utf-8?B?MTN0MENYZFduN0xwZEh4dDNYeUVDaHVMeS9ONDJzUjhTZ0RGMnI3VStFaTZq?=
 =?utf-8?B?ZEthYmRFTCtLSENIWHBzR09ONDF2QmV4U3A3Szg1ZlFTVVgxQzhRTHVWRDYw?=
 =?utf-8?B?bC9OaERHL3pBeFZ4Z0hUSVhLd1V0ZVJPN2k3L3g4VUx1RnYycjdBbGtlWStv?=
 =?utf-8?B?bUUxaDdpaFdueWNpblluS2RRNi9WdGxQbTdVL0czL0IzU3J1RFNGTjZXSXZl?=
 =?utf-8?B?YUI2WlBBSG5Nb21FMityaWc2UTRBRExoSjFQWUpFU2xuRVZXSzdKclFKQ01r?=
 =?utf-8?B?Ui85dmpsdTRZUWg4WmlSeWlDWEt5NHIvQkp3ZldYSEFnb0htU3hlTmtJSDc1?=
 =?utf-8?B?Wnp5QXdQMUlEMmNCRzRXOGZoNW84S25tTjNhNng0WERoVy8wL3Z5Smo2ZWxw?=
 =?utf-8?B?VVIvSXdndVdmYnZkM2Nia3dlK053PT0=?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(36860700013)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	QXYAjZ5Y0XG38DKP1qLtBx6PGk1+vMUNg2QNRUZaGfoD5t2eiUePBJBT1HwNdrMqMTImWmt4ei6R6eMhAwjkwsQMg39G+XDUe3F53AXCy1IaUHZQqkYz9lTGunaQUwJlD8uj1VL+Un1iiQktUHcpAJoSLoEHfs+79kqgKt8TXtzgC+xkpSh9iCrFIBSA7tHHuPeZqUdfmgq/0qEvBqW3b2UD2qO5QyKZGIRvEIc3rQ0Rs+QM33Gv/O87aQzmAC7awqzd7ynJRAqCEM4H9lCzhFZhHgWL1mfaavhLMKSGcey5IUmFYvHSGLPA0APnwAlvCSBizG3fsVP0JXJSGIhgtocO7pxR6lgf+xJKJtKOgvPLUQmo6SOiT3XDu7qOgL1/ziMjiM7BQAuYcy+F8gzanHpH+AhKV1JByG96ieCRZF/BhF9Iw6FWmt3C0r8ulmm0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2026 20:28:04.0353
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: afb24a61-6bad-40a3-71fb-08de642be635
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002636B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6964

On Wed, 04 Feb 2026 15:39:42 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.9 release.
> There are 122 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 06 Feb 2026 14:38:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.18:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    133 tests:	133 pass, 0 fail

Linux version:	6.18.9-rc1-gcc6f56fd087b
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
