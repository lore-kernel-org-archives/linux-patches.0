Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2067.outbound.protection.outlook.com [40.107.94.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8384E1E0DE6
	for <patches@lists.linux.dev>; Wed, 19 Feb 2025 13:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739970683; cv=fail; b=Oh57QRI0IcyqUIdevTsLvV2XGEQW2OUocuGgNik2PgJAFm4X5Sb3kAO2drQYjep77L15vckLO1rWZf4CtkSHCPF+2F8HUqEEk7vw22/4st9kumBTLQ/lLNUTPNbMvh85irlsu47kIUWy3kc7Mv6aRgFgxQUf2gDNYOl2meDY2ZE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739970683; c=relaxed/simple;
	bh=ro0vbjTZlLSHNpgErpZtpQBryLcDHoy0CM9BZrAd7hc=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=ZAshjEZ5tka6wkr0F3nEqKTaiaWphBIsX8ccTGIxTINaNBi+SlVtrQzcGkEGC68IWCfMunzbX7IVcIEiMYKhvqzyURlCpJG90iF18LDsyQYd0/mb2YmRc4fnwhxvOEbVZRvvFkleKjPApY31WY1Erf2A2waCcEIO9EXCPPKtp0E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=e9lUC+XE; arc=fail smtp.client-ip=40.107.94.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="e9lUC+XE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Xo5zAInVsv0pTsjueOEPTHuxYy1NWeHo7279tdE2HhrSL7YLap0P0ztMt6UaJLxF8Y5GRlXHmojT5yPGyxS1G+JrKxpDm06VYplNdlBFxDW+vEqSz2bRu9dAlIoQlorEj+s8cmJvYwhU/+Z3PpIVs8VSY80ORPPYtLb+h9HJQ+ofOstgieuvLwhSoG4qYHxY03L4qf3WekQQzcBfvzPb8M9UBgaDnQFBPhqb3PERNFLIw1ptFYUHalbPrFw+ZX5yRpABFts+B2P/nROPIYBHJjeMg4Lo+XMvumKpz3vD3HfSgOxMgOkLhCwQ+JI18iLTAVRyOZzDh09ZLkZ5l6GQHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UN6KRCD6QY6zws9n/+2hBboZo93CxnknC+zOgc9gS8k=;
 b=cS3/Fy5ihjojSlSBjjFK/hBkroOazwmU6wbLk0h8Rez+FKzq4uCPYUefd81Cs3RZR+dHwQEk7jKlxzlHceiLeL7eqIS04ZpSPbnwzfp2tzsZ3ja04Qd3zbip6vpZ/S9PMj11wZV0iNCeN6Lhkb4AmkbwSyYUDLW+AvlexiVuiDkL2tub7d5YwEaUyGldYD7ixciSWRLgC6DoLn2NxFbG1RtVLL1mXj8wvt1jtqefqAtqtn4z3xqtCqhMpjgu8Qlf2UEOClhGblKKqitbjzSqTn0ryiunAd/xVxRe+Sp6WQVLW97uDtwYSj/7w3Ilem0gZCKqy7mmMQO4R97kXOUKeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UN6KRCD6QY6zws9n/+2hBboZo93CxnknC+zOgc9gS8k=;
 b=e9lUC+XEX5ZKgO2NoMWE/BdRU1DbZgBVWPvfccxvTCGuMLiB71biO7zzn13hHKxlujS+od5M6A91iLPLZpixa0aT4HzOvNzVbl32+7N5ow4KayxxjJKQF5nje+KUzYxdPQxO/UozzkmBbmmQ5kf5iZlu2XmbO0RVsw3Tp9Z9Th6t7cz3N9P/+dPJWYV44o+FFa6yd0Rr+W1CCH6KFGwu5gZ45WRRty1wNECn3f97RWtLDX2bX7pAtccawLPB7lrK/XDLbahUT85klv67j9f/UH5O9h6r6eF+jAIs+858ixvK7ri1NnxbJoV6Zjbk8vERhjtkgW7fKdy/tnkb7y52IQ==
Received: from BN9PR03CA0137.namprd03.prod.outlook.com (2603:10b6:408:fe::22)
 by DM6PR12MB4218.namprd12.prod.outlook.com (2603:10b6:5:21b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.14; Wed, 19 Feb
 2025 13:11:15 +0000
Received: from BL6PEPF0001AB4E.namprd04.prod.outlook.com
 (2603:10b6:408:fe:cafe::d6) by BN9PR03CA0137.outlook.office365.com
 (2603:10b6:408:fe::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8445.19 via Frontend Transport; Wed,
 19 Feb 2025 13:11:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL6PEPF0001AB4E.mail.protection.outlook.com (10.167.242.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8466.11 via Frontend Transport; Wed, 19 Feb 2025 13:11:15 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 19 Feb
 2025 05:10:58 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 19 Feb
 2025 05:10:58 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 19 Feb 2025 05:10:57 -0800
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
Subject: Re: [PATCH 6.13 000/274] 6.13.4-rc1 review
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <8e95a8de-8c16-4119-9a8e-0475bc119d84@rnnvmail204.nvidia.com>
Date: Wed, 19 Feb 2025 05:10:57 -0800
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB4E:EE_|DM6PR12MB4218:EE_
X-MS-Office365-Filtering-Correlation-Id: 6af7c693-3949-4781-547b-08dd50e6e3f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|36860700013|1800799024|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bnpkdnFDa2xJY3IxSldhdHk0ODNvUDEreU04RGNaeHJMNzBiVTI0Q01GcGFJ?=
 =?utf-8?B?R0pDUFRIL003T2dieStLSUVBWXFXRUh2SUp0a2RaTFFiOG1DTzZHZE5lcWto?=
 =?utf-8?B?SytyZHZEWFV2MGl4MjVNeDEvODRRdGF1K3RSQlk0bnU1UFFiYjR6WWphQ1Nx?=
 =?utf-8?B?VE9ic3BkdlMzZU1zb1lLSHNub0VkT2lJZ3NNU1ArRjRCN3Jrd1QrNFZvVEJN?=
 =?utf-8?B?MDU5WDZiNjlXZGdhT0MxenZLZ1RiaklWakJiVHA2UTJjYVZySkw3czEyZzN6?=
 =?utf-8?B?dWVlb3AwKzJxYmZBSlhxZG1qd3VFZkJZY2UvaGVNekZBMGtXNEFMVUU3TXhG?=
 =?utf-8?B?WWRzT0dXd0pYR3V6WGtheFZHZVdYbXBUdTNsNG40ZWxKaXcySC9MZWZHbG5U?=
 =?utf-8?B?Yy9kdEFnTkM0TXV2S2d2VE5YSVdjalRzYkZBWnhQSk95OHZCNHYraDBDcUpj?=
 =?utf-8?B?bktWN2hQZFJGYTdMTzZqdHNrTlZTZjZudTV3NE1ESExWb09sZjJsSU84bEdK?=
 =?utf-8?B?eVpOY0ZjQlRFcTVUcHVKMXdnNmdPSmY1QndSekxoc25LRTFRQzJITmErTHVR?=
 =?utf-8?B?a2s2UmJvRzc1cktlZTZyQnZyZU5WYUdveVBQNWNNMmNONXB3cFFDbkowWjZ3?=
 =?utf-8?B?RlFFTUdFMHdiT2Q4Qi9aa29kUHdFQ0NRamlPNzg3dHlmaDFBNkV6N0dONU85?=
 =?utf-8?B?VEp2SDVENkgwbGF6ZHhMNlllT0dQTE9SbUZ3Sk1JUi9QNEpwYWoxeEptejgw?=
 =?utf-8?B?dnJXSEZ4SWRuWGEvazU3ZXFkQTlVczNYYk9jSFRnallvYU1TWHdLYzBoMEEx?=
 =?utf-8?B?Vmk3ejlHNlptQzY0V2ZBVjhGbnQwZ0szb1BRV0FYdTkxTU9wNWpZcll3SUV5?=
 =?utf-8?B?K0E0SXBXQzZvdWlWQmI1K2ZBNDcvR2lJNm12UmxOaks4cDRhSDZib0Z2UG0w?=
 =?utf-8?B?WUxEQlY5VjEvc05Eb3BZL2lMOWFuc3RCK3BOc2dxNW41cVNaVUQwNFNwWmxr?=
 =?utf-8?B?cFZ6ampCQ2lXanhWOFZtMk1YQXMrUldCNDZzSXZ6a3BEWisxT2ROOEFpTzM1?=
 =?utf-8?B?eVF4Y1JmcmxJY2QwRlM2aC9URm51YUJJeHBSMEJtc2ZYdEZDUDhRUmtxRUx1?=
 =?utf-8?B?a2NaYXcwNU9FUnAxUkwxMHpxVzhoRE1jelhqZWNZc2plaTZDdDZkRExPd2lj?=
 =?utf-8?B?RlFYbVFRTzNVbHhMU3pZajcrRzJMaDlidDduNU5Tbm1qaWlacm1TdWV5RlNh?=
 =?utf-8?B?ZmJveHlHUWdqanpHR3ZlSTFMYStnZXpBTmJmc05xb0dNb1RBSUdsUmRXbWtv?=
 =?utf-8?B?OFJjTXpCOVp0VWpTazFEZm9HZU4wQWVOK3R2M2RheWVIcUJ2T3VVVGZQQ25L?=
 =?utf-8?B?MCtwNFhmUHRuL0I0QW40MUdobkkxK2phSzZWdUpURTdlZ3lCOGNEMXZMYnEy?=
 =?utf-8?B?VVhGQ3hRVHJUZ0Qwa3dtcTVyVy9TU0p0RkIrKzE0RnFhSFQrMTZvVWl5VENV?=
 =?utf-8?B?WGFtOFNJWVQ4cFB3Ynp6TTJ6RzZQcDNFV3hVdFYwbTg2TXFLVGtpWC9haWRu?=
 =?utf-8?B?SnpQTjZVUFV3ODJibFVYbnZ6T2lTQWdmM2JKRGh0THhHVGhNWXU1L24zbmZ3?=
 =?utf-8?B?K0VtcEsyeVZwSFcvV3I3MVNmWFgyWm0vWVNja1A0dGdEaUh2RHZLNVc0RDd3?=
 =?utf-8?B?cVpTRUd3WEVPcXVtVlNnWFF3RHcrR3FvRThmenRwSVFvZTh1SVF0ZU8xK2Z2?=
 =?utf-8?B?eTgrWFhEUnhhQXA4bWMwTHhzWm9hbG9DYlo1cEhaRm93QUJUcjJBWWErTUk1?=
 =?utf-8?B?dG81SEZpZnJLTzFzZVI5MUwzc1UwVTdwTW4yYlJGZk9HNE9ibllGSGtWUEls?=
 =?utf-8?B?Qm5maVAzeER4VXpkM3k0Q2hVWkN0cFRwY1E4WG1QTUdrK3dHRUZ1cG1UYzZI?=
 =?utf-8?B?YldmakNQYnY5RDdNYS9GbFc2TC9pNTFMZitFT0QzdmR5VHFhMWFDZkk5cWJ6?=
 =?utf-8?Q?VsJInj1BAALoP4S3TFnw8Levuf99Mg=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(36860700013)(1800799024)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2025 13:11:15.1456
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6af7c693-3949-4781-547b-08dd50e6e3f2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB4E.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4218

On Wed, 19 Feb 2025 09:24:14 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.4 release.
> There are 274 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 21 Feb 2025 08:25:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.13.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Failures detected for Tegra ...

Test results for stable-v6.13:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    116 tests:	115 pass, 1 fail

Linux version:	6.13.4-rc1-gdf042386d398
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Test failures:	tegra186-p2771-0000: pm-system-suspend.sh


Jon
