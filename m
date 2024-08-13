Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2053.outbound.protection.outlook.com [40.107.94.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 550021A01BD
	for <patches@lists.linux.dev>; Tue, 13 Aug 2024 18:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723574518; cv=fail; b=OJfk1lqlebY2ixKO4Acwf84NvoR8EvrhowuIGcgNUJuG9hAGzsc0AeW7hrJt5YX0Fqav2k8uacsWvKIMXAY8UE+OHXAO00Gmw2PE4145LXvnD46hvQWfinSVAaLrFybtL2IetRcrSrfGFylIezg1XDHamiTo4En/QOb4LlxzxH8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723574518; c=relaxed/simple;
	bh=se+oAMEAOt1RqTk4FQ7hu5ughJKjEhE+h4BgTUh7Lqw=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=pTVSgAgsOuhQIKV1RSpsAXCwN2PwTYeJkqmrFoQ6OsOOasyiiXTkZ+Ly0xmR1vHXjJSIcuEFuzRNihL1maYDcJ88wWAaBfD91YzqakljbGW55p6KjU0nuwDJgd248F0zvmwUii44bC+JZczOaYD4S3Jy5RNLbVVno9ZzvX3nWR0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=iWXVk+3H; arc=fail smtp.client-ip=40.107.94.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="iWXVk+3H"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Er1k91zioBsKwbrG/vGvhRz2rxkstgzbToV/W+dWUJmhmUxojsYnENW2HYpByva/Zw7E4Pwx0+9JkZ3ONSCVs6LfffrxA3brRQLt7CIVByBauHWuNF/q2uA7uVmt3rGqSnFqjF9mCz3XwVgO3n2df9nOORYzZA6D0GhOETI8ZrqoLyAltLrnvdP5WPvEbWguLht5caJCiq0ixMT5Huqug+8s0vb/5t91zqjLUpXJ5M9mX49hKnPYw/M/r101hsR/2rY2ChggpZiEKDCtc48aHhgy2INqxcQbMQfcLyPVM7MHDSnrq/YA6HdKdDFNt7vuVYrJY2cEVtEC8+8zmZhxmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RXtWlFa5q0taWi4mj5ia3XZNULqf7yNREgZYFeknyRY=;
 b=EacfIYd3bHgqKzzCdaWcxhJQq/glf8fUs4tYld9ieHXmFP+whwHsFYjXvD0/CwY5m7+1HTVSLFzXVUlU6+hb2WsIDvgV45rF7TxZnYBAjWRLbA+P5PeK0sfEOc8MLWq9phk0lYf7445Ag6Rzds2U11bN6pBQBsKTIWl0JAdFdiwlM3+GA+TojtHBaGS8M+XC96fGgrDHlccsXwT6SiQekTpV/HQq6wj+ol+XNsHWjwd6AP2+yBMsCWcoyb+++yItav2tNStDEL6G6Cx0muTQ4ca2CXn+xdPH6yZ0XqzJnfbPw82CNOge4Y6lx/iok557fgLSfXUt3uGqcVFbnDWzBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RXtWlFa5q0taWi4mj5ia3XZNULqf7yNREgZYFeknyRY=;
 b=iWXVk+3HKVCvB9R8n86qJYasTW3KSYctje4KW8Edk0MCtaJMrPNpEf466tuS26UAflfWCAaxwtutallkmRulddVoWsrgvc7s3mq3zQb0iMylgZ/KYbBUO45L/ErD8SzgtU8E5tP8QErc6eHOFatmt9IOS/K8iSy6AUUWmBvID+T6T+4dl30lJ1YUz4c+azoFXIie7sBF0fBRSgt3wFVs1idzySZv+PABZJY8LaQllFj1v2SNTIW0OVhULpab10zdSNqL4g0RIEhATf/fDVwOMNeVklNjabpY3I+11y935Jtk4/RjX0yjunzsxi+oCV7D+jSS6TYCUsxRdTqCZiB5xg==
Received: from CH3P221CA0023.NAMP221.PROD.OUTLOOK.COM (2603:10b6:610:1e7::23)
 by SN7PR12MB6932.namprd12.prod.outlook.com (2603:10b6:806:260::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.22; Tue, 13 Aug
 2024 18:41:52 +0000
Received: from DS3PEPF000099E2.namprd04.prod.outlook.com
 (2603:10b6:610:1e7:cafe::9a) by CH3P221CA0023.outlook.office365.com
 (2603:10b6:610:1e7::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.22 via Frontend
 Transport; Tue, 13 Aug 2024 18:41:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS3PEPF000099E2.mail.protection.outlook.com (10.167.17.201) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7849.8 via Frontend Transport; Tue, 13 Aug 2024 18:41:52 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 13 Aug
 2024 11:41:38 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 13 Aug
 2024 11:41:37 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Tue, 13 Aug 2024 11:41:37 -0700
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
Subject: Re: [PATCH 6.10 000/263] 6.10.5-rc1 review
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <a04f43da-f7d9-40ab-9f53-4913106f5eb9@rnnvmail204.nvidia.com>
Date: Tue, 13 Aug 2024 11:41:37 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF000099E2:EE_|SN7PR12MB6932:EE_
X-MS-Office365-Filtering-Correlation-Id: af4bc82f-9b7d-4dec-9add-08dcbbc79938
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|82310400026|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NjczOWFmdy9wMjJIOWRuZmVRUnBpR1FuWUJzY0FEeVdVRVpxUFZHVkVWMSs0?=
 =?utf-8?B?VmxodExjTjFlMllzUnpERURqcnFmV3V2YXh1aytUSW9JRWZaM25JT21jbWxq?=
 =?utf-8?B?MWM5bFE5WWpZdnNqdEdVUHN0dk1pNENzSDdCSTlWcSt4RVJMVW9NbEZhK0dH?=
 =?utf-8?B?bWl1ZFNRSncxNFVqTk5WNzRyZnlGMmFGNjR0aXFTaDd2RnhnR2MxaUJOWGI0?=
 =?utf-8?B?Rm95MkQ0REZpZ3ZWcDh4VjdXcDJMTllqMkxrQ3JEdnhta1V1RUdpbFdYeE03?=
 =?utf-8?B?M3J2T3oxQ2JGd0tYOFViQnFIWVJWTzNCQUZMYnJhWWw3REp4cmt3b09oMWxi?=
 =?utf-8?B?M1k5QmRwMTJhWTlNRGdyM016SlBUODJGVHB6S3J0UzlsdkZCWDhobGg1d1Iv?=
 =?utf-8?B?dk9UY3ZHajd6V243VzllOWZwb1hnU3dZUUdZbWVzVmFCcUVNZXhGNVE1bjJW?=
 =?utf-8?B?ZDloc2R5NUptS3RoT2lucEVsTUlHa3RjTjFLNkRPcVhSM296K2JDS25GYnpB?=
 =?utf-8?B?b3JGMjdvR3VOOGVtVTd4cCtROUMyYzY3b3Y4WVZWYTlYdW1IdG40bTB3VzZF?=
 =?utf-8?B?cERpdWZnZUJ0UVNRcjlxOHJsVGNLTmptdklwOWowei9QSjczVGk1Z2lwQzVx?=
 =?utf-8?B?M21yTnNkNG1jQmR5ci9oay9ENUZuYXVIN0pYczZFbG83eW5reWU2YXdQNjBE?=
 =?utf-8?B?UThXZzJBcEcyQlR2RHRSUi8wTTVZWnczamZYeHptZ3IvdlNJUmtLZUZTOWJP?=
 =?utf-8?B?M3V3R01pcno1RlozbWtndExBaklWSlE4eHdQWkthcnJoWHRlWTEreisvbkJN?=
 =?utf-8?B?NWlHMDRMSVkrVmowRi9jdFpmSlQvbjl0a09jcXRqMSs1RWZwZ0ptOHl2WVVV?=
 =?utf-8?B?T2VZTC94cTQ3V1dOckNrWDVTWTdXeGhIY0NRU2djdDFnN3k0SE04WlBrVUJR?=
 =?utf-8?B?Wm5IdzJQcVVDbFhEVVdFTmlBUmdJRlljdzUzZDVMaGR0clF1aWZLR1pQVkVD?=
 =?utf-8?B?c2ZlVFJvNUwvTGV4V3ZiUUtuZ0JNSTBpaU1DWVZVVndzUkJUTnJkSlRWVDk0?=
 =?utf-8?B?ZGRaMXdYNmxPR0xVQlI2MzBOYlpZWGZUNVY4SU5pVzZ0WXZpVURSZWk2ZEZZ?=
 =?utf-8?B?VzI0T2lQamVOSVZXVE1HWDVrcHpMM2tia2RIZU03M29saC9MSHcwa0NEd29X?=
 =?utf-8?B?dHFKT2wzYVJmV1FtYVIrV1R4K1ZlRDhlaU1OMmhydnBxaTRiTUpnUzBTRHRE?=
 =?utf-8?B?azBJZUkxTWZNN21hVUwyaElMd3I4cG84S0NqSWdKNnN6YjEzdW1Va0pKazB1?=
 =?utf-8?B?Sk5XdUY4T1FkYVNaK3pubE91Sk5vOFZyVDh4aUIzN09jR3pkZ2czOU8yREFZ?=
 =?utf-8?B?WXZEdGl4SmtVd2JzbFFkclZxUGEycDlSZi9wSnppZzZPK2haeXFnd2phc0VY?=
 =?utf-8?B?Vi8yaU1VQkhHMkdWUmFaWUJRMk9pazZnNlNCZXJyTE1kdnNLWk5lQ2tRNU81?=
 =?utf-8?B?QWt3WUJ4UU1wTkoyRlVCVy9DUmFYL1gvWG9qMk9ZRE5yY200bnQ4a0c3bWFT?=
 =?utf-8?B?QTJrUWZzWUY5ZGYyOVM4MFJhd1lHRktvcVhVV1FmL3VjaldyMS9IZVh2TTJT?=
 =?utf-8?B?cm94ZittU1l2bkoxbHcrdGw4bHVCNzFJSlJTM3pFVlI3a2l6b3luSjJjSnRL?=
 =?utf-8?B?cjc0bzR3QWxIUk5TSWtGYi9iSDlZa1NEeklHZ21YNnVNTkc1bU1xTGVtT0ht?=
 =?utf-8?B?eXlBckYxcUVEV1BvbGl2RWQ1S2xsbXh2VEJONjRFd09VbVkyRGZFcFBKeXNm?=
 =?utf-8?B?d1M2NnBMNHA2b3A4V0R1SVRrRTdVOTQ3TTVTSysxYnJyL1J4Vy9oSUx5VWp3?=
 =?utf-8?B?UGJmb1NXZlpMdVF1clpGN0xpY1JaUFFVS2t4Q1RLa1hMR3I3R2tHZURITWJB?=
 =?utf-8?Q?s575HVet8zyhxq1s0RhnJnAFmWF6eaam?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(82310400026)(1800799024)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2024 18:41:52.1715
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: af4bc82f-9b7d-4dec-9add-08dcbbc79938
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099E2.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6932

On Mon, 12 Aug 2024 18:00:01 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.10.5 release.
> There are 263 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Aug 2024 16:00:26 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.5-rc1.gz
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

Linux version:	6.10.5-rc1-gb18fc76fca1a
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
