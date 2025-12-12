Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013019.outbound.protection.outlook.com [40.93.201.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 933DA2E03F1
	for <patches@lists.linux.dev>; Fri, 12 Dec 2025 09:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765530564; cv=fail; b=MkMokxky+I25naJ5o49P3FpA9+7srsYalHLIkupFpnxj5nTDKdjo6UWDIGe4aYSlYhVhRU9E0EYF7h0h4EHUkQ+BLn0Dy5lJkjdQRwzG6frEPiZP+Uff4aLcmHgHFNgo4fj6cko1vLqcK0JqmnCxABkIfmKKVXy18otXQiPTNBg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765530564; c=relaxed/simple;
	bh=9FOgdPEgnWyaZlHDpJ1roFvTa2+GfiHWvEiJteTsNpo=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=NSbP3HYogkoXJa3AdACjTa/Q8FjpZy6kbf34xpbtyW1HPmKJ3PQKjyR+mGuLqUXmTtkVw+xDXzmTb9lj/k1VZmtFKdAz2GiyiqsQRwDGcQQbm5AOLj3i0gL08I4idX6WQLLH0AuYSfWwGBydzp/S4WcdSP1Zl2spL0EXoNLO9G0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=m9Q937sW; arc=fail smtp.client-ip=40.93.201.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="m9Q937sW"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N/xrhuzBW2sYR4qNGUXHaLheRGlG7y9LTYyJK/BC/lFhzFqbwa60T+NdxxM0TW7s65XBXWE4ZQHStMY0tjw5I22yWvOArW6M4lRN0PIWoBnTZkzEUXVlFMpB1ar0TixHdlrGSAlbW4R3lE++PdplGlu85zIXdW/V0VgrObtow6QOCADWB39fFpHy63hBxvnIBWvTHNVhhchD3T94dG/oqdcEfPm7oab1k0tmO2DSxLYyUFW4ROIQOnLStEEUYKXJi5S2pXwk5ico1chr7zpiHiPzCJ7FD/p7RPN3dO2v+W4nhmitc7Khsu5g4nKbNVwR4eKmOQBD//NJuj/hExGXQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kdRfFY5UsHkEWKv3OwkkrKPRWIDjKRTC1f2cITXtB/I=;
 b=WwIHKhExtoUUnzyQIjSm+OmfEvaHinzxt+uYcmyHBU6nN9+airhjiEP6JEU8yvtRSD2LEsvd8Sbw3kPzrT18NRorXGImjxXBgE7q/EyXrPy66yBwMh4GPf2oCEiZPwPe7nZprajFRrJysWuY5hOCTHhiChUdt/JckONAE6VmPnFTQSrWZgPn+8hJ+eD8l9DdW9N+v0RmXnVZ+cKzfg1fIolO1fzJ5y/94w+FkGgSBeuR4urpvVXt+VsNOBbAdvUfMZ7EeFZXTUWUKWIiUoUOguYlMz228k2rNTcbq2pyFgJZncze6pqiD3nFIxa8o5jc9EEPxZ8SMef3HSlng2GxQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kdRfFY5UsHkEWKv3OwkkrKPRWIDjKRTC1f2cITXtB/I=;
 b=m9Q937sW8N+KbXzcMKs9GlUelpMZ1R4/7JIhnGKJ+5HYkVKiYKSV/Mlcuka0x14a1msKaLHYgfI4ClWuqDqni55HOU1sbJxPglACui6zWxVnAghs0ESzv2U35Sr9avRTBhd9izA38V/Bfyj1VBo6Hmfo8FjpmS/kw8Sdjc7hk1l3lyUEqNY7OurBaXMT2mTCu8c+m00N6GkQpkQvIsYIcSdt24MRZy0isHG4qVztl/NAeqzZKhHDHpVM7OKlDov6GWqEQkDfTkcnckG6bOCGR4jMMCrPY4frW1Pl07sUQKtEAeSdnN9numD3rDR3XlaWSI9TaPd/aSlBKHOfGE1LkA==
Received: from PH8PR21CA0018.namprd21.prod.outlook.com (2603:10b6:510:2ce::8)
 by BL3PR12MB6377.namprd12.prod.outlook.com (2603:10b6:208:3b0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.10; Fri, 12 Dec
 2025 09:09:17 +0000
Received: from CY4PEPF0000E9DC.namprd05.prod.outlook.com
 (2603:10b6:510:2ce:cafe::12) by PH8PR21CA0018.outlook.office365.com
 (2603:10b6:510:2ce::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.5 via Frontend Transport; Fri,
 12 Dec 2025 09:09:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY4PEPF0000E9DC.mail.protection.outlook.com (10.167.241.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9412.4 via Frontend Transport; Fri, 12 Dec 2025 09:09:16 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 12 Dec
 2025 01:09:04 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 12 Dec
 2025 01:09:04 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Fri, 12 Dec 2025 01:09:03 -0800
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
Subject: Re: [PATCH 6.12 00/49] 6.12.62-rc1 review
In-Reply-To: <20251210072948.125620687@linuxfoundation.org>
References: <20251210072948.125620687@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <f5b94ea6-d391-4fce-a659-299e532ef0d8@rnnvmail202.nvidia.com>
Date: Fri, 12 Dec 2025 01:09:03 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9DC:EE_|BL3PR12MB6377:EE_
X-MS-Office365-Filtering-Correlation-Id: c8c55292-ae6d-4e1f-9833-08de395e206c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|82310400026|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MmZvbGFiRVZuRm5kTFdWNmVXeFh0cjlaR1VOTDB2ajlGakVHTUpLekpNTks0?=
 =?utf-8?B?b0orUFZ2RFc2NmdTVDJ2VlFKOWFnMEUwT0hWSzI2bXVKZCtmRTIrQ2J2Qito?=
 =?utf-8?B?ZE1uVlRiTWNib25ubnhlalM1bHc5ZkRWNGY3MHFSSE5TRUdQcnZOdFd2enJV?=
 =?utf-8?B?Y0dFOWM4RkxwTHBsVzUxYjljQjlJeU12dzNXL1BRUmxMQnY5R0pJRHMyY3R1?=
 =?utf-8?B?a0RjWWNDK1dhcnRKS1YrWTgyMHdpamtiTTJONHZzZEEzUkpsK25PdVBsUG5y?=
 =?utf-8?B?aVlrcnMzeW9oWldnSVV1SFNJZTFTVUJiMlRvUSs0b3hTVkowVDg0L0hXYlJC?=
 =?utf-8?B?dnJseTJwWmtINStkdWtGcXNSUi9Ucmc3TFFxMkFxSW5rOS9FNGRnK2Q1R3Iy?=
 =?utf-8?B?Z0RlVVgwaDdzVTNYUmxyUlpZYjBKSjdQdUprTm1NSkRCZE1mR0E5enVWdnA3?=
 =?utf-8?B?SndsZjNFVUNYekRRZm9NWlNmZThZaUJ4eSsrQ3hhbTZydDA0QjFRT3QwNzRI?=
 =?utf-8?B?TkV3emptaXIrUTAvcHRlUTVyWlFibTVSWEN0dTZQWWtZWmp0VUtUa1dRei8z?=
 =?utf-8?B?Ymo2b09jRHcwZlgwSE9md1dlUWFPOFMxOFRJcnZ0YStVbFBIcnFZcjFIRERo?=
 =?utf-8?B?Y0JiTUpyWWRJUmI4VnZHQ2o0NFRqNFEvM1g5TzV0ZFBKeXJwQzJIeTBTR3FL?=
 =?utf-8?B?b0hVUnlRWkJVYk1JaEtHYmkrYlNkNUFWOThtOExhRnRwYnZ3bXRIWW4zZVRI?=
 =?utf-8?B?bWtCUTFJa1Mvb1NpUGRpcWxQY3BrZUxmMUYrcytWeHlmNEVtd0JFdG1DVjE4?=
 =?utf-8?B?bEJCYW1XTjhSazh1WW1yL0EzeUNWSVFSdVlIRXNzaE1mQlY1NVhxc001WWtv?=
 =?utf-8?B?T3VvTnNnOXF2b1pON3lpYnJmYXBJWWw2eThsUmhHdkxSSkVKejZVR0JFYnhS?=
 =?utf-8?B?TUNSUktlTVlZdEVPSnlVU1VJM042TVROZzN3aDNJWUNOaEgvN00xZzJXdjBI?=
 =?utf-8?B?b0Mxd29yaFRiNXRmK2FHSy9iaXExcTgxU2U0R292WjRzNGdyYzROWXVLNzdB?=
 =?utf-8?B?OU9ia0ZsTVNpdzF6RVV6SlNXeUJzRERBUlNhVXdHOCtyU2JmUnY1MkdxdHlI?=
 =?utf-8?B?c0srajlQY0dsVnU2Q3lkUHB0MUJJN2F3cUJGUWVtOWNYenUvelNRQjc2WCtS?=
 =?utf-8?B?WkQwWFB1YTFEWHNYOHNXZVJJZ0tBc2twYnlYK2dRUE5JL0dFUnRXSDArU2VO?=
 =?utf-8?B?N1E2MDVJREtlRTV5Q21yZjhGRzlNbnlFSGVvU2VvTVRseGNqVVNHRWxjV0dw?=
 =?utf-8?B?MWJhSTVacHhWM0RKMEo4VkVQanJObi9TMFArMUFxY2NpcUlmWTlyTHMxK3o4?=
 =?utf-8?B?aXR2bkxGQW5TU25uRUVDL1BQNWlSTlFNemRuR2o4QUtsaG5PWTEzaUdSbWwr?=
 =?utf-8?B?eWNmUVE5b1pXTXNZOFduVFp6dWxXSnlHa3ZFSE0zRlVPNUM2dDJHaXlZZ3N1?=
 =?utf-8?B?ZWJRSExoemRGaEN4VmM0Zzk1bEhLWktzM1pWaHI1WTIvaFF1L2t5U0c1b2lV?=
 =?utf-8?B?T253RjVMWUt1M2VIQjFVak5tazhlN1hIQmRGMnJucUt4NVZJdHpRRHZuN1VG?=
 =?utf-8?B?elQvSXpDT1RFQzVSNUJhbjR2dTN3a2lxLzc1Ulo3dGFSM3l6eDJKdGJBMStp?=
 =?utf-8?B?Qmx0U3dweU1EbFNQZEFQd2RkdElGWWtuelQzQXUvUFVMNWhqZlk4TnhJeVZY?=
 =?utf-8?B?eDd2WWNMczhYQ3F1MmJxLy8xY3dvTnJWcWtwcWk2eHpjTnpTK29Ka0xhc2Yx?=
 =?utf-8?B?STY0Z0pGNlNUaFZ0eGx6VytlS3NrYnJ2Nno2a1lENzg5cTlrbG0yZTJuNlN6?=
 =?utf-8?B?ckdLaFlqYittRGNXTDlISXdsclhLVk9YaS9PNmphbUlLVkpiR09KL0NzcjVp?=
 =?utf-8?B?d2xsSmpBTENsUSt1VjZYMUt1NXQwd20rSHg1dkhqcExRS0lhb01MeTdEMUZY?=
 =?utf-8?B?YWZUYWZuQ1lxUExNYnMrZ1NPZnVsRTExUitjZ04wNjduZmZycUI2VE9NdWVx?=
 =?utf-8?B?emVoTTVRWVNkU2FUeEdpZXZNL1p5c2JvMFprZUpXNFhmNGRPcTRVam82c0F1?=
 =?utf-8?Q?cOfA=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(82310400026)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2025 09:09:16.6155
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c8c55292-ae6d-4e1f-9833-08de395e206c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9DC.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6377

On Wed, 10 Dec 2025 16:29:30 +0900, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.62 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 12 Dec 2025 07:29:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.62-rc1.gz
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
    28 boots:	28 pass, 0 fail
    120 tests:	120 pass, 0 fail

Linux version:	6.12.62-rc1-g4112049d7836
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
