Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010041.outbound.protection.outlook.com [52.101.201.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7BCD315D2B
	for <patches@lists.linux.dev>; Tue, 14 Oct 2025 13:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760447405; cv=fail; b=sZaTqe1dr3qCEUX2+MqkPd7a////NphMHa7/SvY4rgsfuoB7+tgroiavr7Wu+4jROpzrdcBQEeNtjCUppL/jKTqKSzz+kI5pHaN3PxlHtkzIPv8GhEW2wImENqDLUZUxmx4vswh5OT/ccm0jIBqCQ01k4V3W4QO3+zUiDEDNlGc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760447405; c=relaxed/simple;
	bh=5WrawJx19HGks7dX6NhkxoAVfeFYklboejcCC9sJsJM=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=mHFzrHPY1qZAj40rt211uIOn2v60Q3JH7zh222MAaFeDHCxuW9ajQg1Fs2x0aJSHzlixTUb2/t5bRjYxrcqYJzTL90yGubFUNwi6zQ+cauEm3RqW8yCfsaWfLll3osxZ1DXJneUyKFcf7oHHRhezwtkDm+bahznN6uU9qgzNhbE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ClwGZL1o; arc=fail smtp.client-ip=52.101.201.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ClwGZL1o"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ljCx6a0doe6Sy3VMYo9M3HjXXLRfkw8qFBa4dlFq/PUoUVbH2qM44hX1Gr3kCBxhW46HjCHaQE98PJSCxOLo7GGwjjeTtq5JVklb7NKw6+/hTw2/pljNKuMXxb6Tvf/PWm/t7aKRUmKm3MvmAiLos/apQuybL9k/n01eJ0rxIOawWiMcp6e+8cEYEpvizKPF1VMhgnDIDtYOvmASXLW6hHBbhOovcixyi6eg3WeKqgHkeFUJ7PLz8VCAcGQFp4qa90JC24pwalPiR/aS2SvBjed3KJ/B5/zGXU/bRppvxdE67YUg4ngdn3THYNfTR7Hb1Ffuxhicj1eFHFIEnvtDPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vdv6XaQoSAKbDidwEHpN2PHni3sZKYzPPAdKdke0WJ0=;
 b=wE1VsYoAN4HmO1a4nFxRfee1WTisNLN3nHQsQRh1rcp3bFzYTzKuL8hZMUpUzjwHzh8o7kBGU9V9zw2dum456pFjyzJTRTItGAFXFM9GZdGtGDmthxEMLAQ+MuqCwifNv1vTd1/1mTfUeylU/PyiAbdkQTxl4dxLU45QA6vTujgCI/MZsjEZTsjjEVAl2nS6UwofRbFy4QdDvn+0gQByaZT4HSOzBDiGh8b7iIdpoXb88k0+IBNwtyMNS0hwtZgqONY/QdOwO/74htXQYqENCfkGMlCWWduM4co4Zp6Ikg0Y6LTachC1tE9kbUD1dnkzZHiWZAxQLENDMtvLWr2tkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=temperror (sender ip
 is 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=temperror action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vdv6XaQoSAKbDidwEHpN2PHni3sZKYzPPAdKdke0WJ0=;
 b=ClwGZL1ogCOCLaso265GRLfiLnpRh395CdaAVtKb53nXfGz2SEzr7QroXqxiR8hO4jAxmG2l/KmhfemmXoJCEv07/SaxXJdpVGDKRh0bF6vA7pY5rHENSKHlk1p8YuJpFHlUVAK2oLUKoy9QW7nXMNrTfuQTth7M9u2PvRdqF3rtTBHpipOGxGq9CJSIrKnUkzaIUqYd70jfjzBOMd5rzucECW2COZdfZMPbRgnWkoEi21ZsXYoH/Ch+Iko7aUy1KdMhEbDtjA9sQp8tjUcRx75IccoOoeWtqGsgNNVz2Rj8z/RKsLgmso2tRciN6OJyWdrsD21Iwkxpf+PNateVng==
Received: from MN2PR16CA0053.namprd16.prod.outlook.com (2603:10b6:208:234::22)
 by IA1PR12MB9062.namprd12.prod.outlook.com (2603:10b6:208:3aa::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.12; Tue, 14 Oct
 2025 13:09:56 +0000
Received: from BL6PEPF0001AB58.namprd02.prod.outlook.com
 (2603:10b6:208:234:cafe::10) by MN2PR16CA0053.outlook.office365.com
 (2603:10b6:208:234::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9203.13 via Frontend Transport; Tue,
 14 Oct 2025 13:09:55 +0000
X-MS-Exchange-Authentication-Results: spf=temperror (sender IP is
 216.228.118.233) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=temperror action=none header.from=nvidia.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of nvidia.com: DNS Timeout)
Received: from mail.nvidia.com (216.228.118.233) by
 BL6PEPF0001AB58.mail.protection.outlook.com (10.167.241.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9228.7 via Frontend Transport; Tue, 14 Oct 2025 13:09:54 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Tue, 14 Oct
 2025 06:09:39 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Tue, 14 Oct 2025 06:09:39 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 14 Oct 2025 06:09:39 -0700
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <rwarsow@gmx.de>,
	<conor@kernel.org>, <hargar@microsoft.com>, <broonie@kernel.org>,
	<achill@achill.org>, <linux-tegra@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 6.17 000/563] 6.17.3-rc1 review
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <d420b656-424c-488f-8d1d-3d67bda19855@drhqmail201.nvidia.com>
Date: Tue, 14 Oct 2025 06:09:39 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB58:EE_|IA1PR12MB9062:EE_
X-MS-Office365-Filtering-Correlation-Id: 2eba1b2b-b3f8-4f61-1cb5-08de0b22f80e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|7416014|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?U0pzRjE0Q3ptNklIV3V1aTVrNzRuS2VRYjVVU2ZtMjBYN1ZlN0pWcFh2NmlP?=
 =?utf-8?B?Y01wS2lWcHU3b1huaXBZbFpoSmhOcllmdXZtU3Q4MGhKMktxQUhtV1V1amVq?=
 =?utf-8?B?bXM5VmtQa3NRVEE3TmpSZmRtMHZjYVV5TlVwZS9HWVd6eEV2c3ZXYkdQcm9u?=
 =?utf-8?B?SnJST2JtZUpCL1ZBYlErQzQ3Ly9TTzRvczJKc2x2Qm81TmRscER6Q3JBY3lJ?=
 =?utf-8?B?YkhGRzFDbTJ6bGd1ZDQvQXpwZkd3QUZFQTgwUEg1enVydS9NUVB3aFZ3MlV6?=
 =?utf-8?B?cnkzTDFGdFc5NUlVRDllSTNBK0E0TWhoVHk3aVVkd2VnQnpNc3lVVWZHclhm?=
 =?utf-8?B?Wm9Ed2JNZlpIdHNOMm9vVjJraXl0aHZIOTV1clNzR25WQzQxa3ZrVzdNM3Mw?=
 =?utf-8?B?eFBkbGFRM2hHNWFaYVFnaWo4TkRMTSt0MFVXWWNkWjhQekttbzhjbmUwTlhI?=
 =?utf-8?B?aVBoK3JGV3hhTy9oanhlU0VWR0tPR3MvUjVxUVFSTTljalI4NzVOeFBvMTh5?=
 =?utf-8?B?VVpUUjVYSHIxRm4zQXVrN1pNNWdic1RFSEpmeTlWbWwyamk5ZmtXSUtidFNs?=
 =?utf-8?B?T29PUktyaXdCQzdUcXZ6MERPMVFKWmoxUXlYTUpZbVQyQlhTUkxkOGFBTFhq?=
 =?utf-8?B?bmRaMW13Vm84SzFuaFlzVGR5M0pWVkZMcEZZdFpPdVp5OG1FRWN6WWtBT0tK?=
 =?utf-8?B?RFZDU0s0ZnVNY0kzeFlMU21GN2V0TjB3eVNwRGV5U3FXeTN1V2J5V2FUbjdY?=
 =?utf-8?B?ZnhvbmpXR2M2WFRHLzIyQTg0RmpaY1Azc2pCcWRxQ1I1dmlzVFF2U29wVno5?=
 =?utf-8?B?ZUF5MzNwMzlSMVR0RXBRdldXdmR5QjV1amhaOXZ0Zk0zMkk1L2VYQXFHYjh2?=
 =?utf-8?B?d3pIa1BsaEc4QmhqVzFqMnpueEZHSThOSEQ1VmNNcE1nZW5HOEF0d21jSlc3?=
 =?utf-8?B?Y2NYT2c3aVpPYll0VUdyZzZmcjRsUjBMTHZWVDZBTE1nT0p4cmxKbzAzTEtE?=
 =?utf-8?B?SnVjYUNlbDZJUmlZQjhydVYzcFBEeE5TbTkvOEQvTngxUnNSa3RUSld5a21k?=
 =?utf-8?B?dkEwMURkV1Naa2RhTXczOUlZbFNielhVWktmZ2ZVRnpXSWF6azdGdENxZ0Fh?=
 =?utf-8?B?UGRtS1dWUDZyYTlvT3RmQWZUK3c0OVRvU3ZEOEFzVk5ZWk9iUGlnUnZpdVE0?=
 =?utf-8?B?cmNJcTcxRXlRNFhHMVdHbVphVzN6TzFYb3czU2xqUWdhNVBaenkxZERsbzVa?=
 =?utf-8?B?MkZZcS9vNDAwbXdESFdzdWtJMkJyL2NWWEdQcjFsU3NwM21DK3NBQjNicWl0?=
 =?utf-8?B?K2E2dm9HcGgvZ3dCWDAwUERTeUZMMXhhV2UvRWhUZHlzTDBLWHJFb01NL0Zn?=
 =?utf-8?B?TGdaSXoyWnF1bEhXSTRmaXBxRm9zTTA4V3VsTVVObTQ4U2ZOeG9SS2VBUEgx?=
 =?utf-8?B?bjV1T05zYnFiY1pTTzc5ZDBuQWdFNmRhbWxqMVBnbktPZEJ6d1RJR3RTRmlD?=
 =?utf-8?B?WTIvUTVQcjVxWUg5OVpqcTNRRXJaQVVjZ3BESG13Lzc2ZVpjaXJlVEVnRGsz?=
 =?utf-8?B?YVp0bDU1aGtaQ212Q2pkOVRjcHJlQ21vZ09RSDNKU25PemVzWGZkWldWdlpv?=
 =?utf-8?B?WGxtMXFVL1NJMDJkUXFUdmw3N0xHWGl5ZVlJYVZPL1phRmN3c3NQMlh0R0Q3?=
 =?utf-8?B?Z0tocWFsQXBzN1lsYXZIUUFhbVZ5M2E1aURzc2d4eHE5ZEtDVlkzelhrWFIr?=
 =?utf-8?B?UFVOMit0QXJiYTVHMUVvZkg5cGJoOTZKRmhWL2N2MWRUY3ZRSVRkdVBJZmZl?=
 =?utf-8?B?VC9yTXVRR0VzZ0ExVnRMNHk1ekRzZzBkY2xUakkyV0JJMUpLR0FZemx5VGRs?=
 =?utf-8?B?OW4wM3NvNk0rekI0ek5jaFRsWjRiSURSN2hNSUxsbWtub3EzdE9pVFBBL05t?=
 =?utf-8?B?Q2hRQU52ZHVyNlE0YUxLNTR3aVVLeGtGV2JFV0VrS2w1OWR4NDJBWXZYdzdl?=
 =?utf-8?B?anJERzhTUGxQb0huRWN4dFphdnhjNGNYbzJLd2RsNWVxMEw0cllxZUFhbmtw?=
 =?utf-8?B?TUh1MXJKcElINzMwMG04eVNOT2FUaXRYeDJDalJack1MUVowbE05dkV5Mmt1?=
 =?utf-8?Q?CXXU=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(7416014)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2025 13:09:54.9924
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2eba1b2b-b3f8-4f61-1cb5-08de0b22f80e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB58.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB9062

On Mon, 13 Oct 2025 16:37:41 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.17.3 release.
> There are 563 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Oct 2025 14:42:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.17.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.17:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    120 tests:	120 pass, 0 fail

Linux version:	6.17.3-rc1-g99cf54e7bd2f
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
