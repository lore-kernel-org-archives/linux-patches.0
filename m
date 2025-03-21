Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2055.outbound.protection.outlook.com [40.107.223.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A5778F51
	for <patches@lists.linux.dev>; Fri, 21 Mar 2025 15:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742572156; cv=fail; b=jrEwG9d1U2Hn3o3ASnICninRjCHmpUte80TUd7GMafBCYjyTxY3ZDcI8omvTn55FPOLvOQMhHN3Qfx2mgWzxiKzcYV5RHXv5ISu/jx3KnYjqteKb8LTKqlG85OSBh34uz8azpw4DrA1MaC6k28G+uUpD4fQKA1k8EAWOQR/m03A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742572156; c=relaxed/simple;
	bh=3VaL5qc5a2UKUQNrlxx276ytrqi7/NM8luGI5WH9qbw=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=FbDsgQPIrCfmNh9nTWusKHv4QL9AjTG2751SbTRGF1YKHuV8hpycMeFO5ZzWt4tlK5UpuClttx74iaJL71Fee5sSJceXG1w/VbDkkjoAOtI7/9AoZUcyhAUc6kJV5vnln6LO4wl43Nbss/JaLrQCGrBYmCrKox5aR67QvT8S4T4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qyfwsxgH; arc=fail smtp.client-ip=40.107.223.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qyfwsxgH"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SF5c6/wP02Bhzo8IhY80GvbcEAWrUlTiAnUi9xQbNOGE2uOzHxmrDhsKwkySTzeyLej2FA4xiXsWAuMDSw57nQpYLd6fExdZTFzwiMNWWW/t7Ux11kh6PGbS6/W3dpyue2f9c3hcLKDcq3JLtTWj4wdGrlnJ2SpeonIFYYwxHGUVoJLfdmy8d3MG182iODcT++aoit8GA/XPM9sUl+qkt2riVAPqSEoJwx0IXS00ohY+XGMtoYwgB9emR9RZM3JonJ6ywRB3XMkrNE2wSeNwu70IOUffAYIG2SbKwIS2dxDIiP2kIss7WUVwvn9oYKg5fX7JoAq1BpqAn8gODt9tlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x/mGZYbzjvkXzi/Hc/UJytnF9weZ1//wxkbnMP3RiLc=;
 b=aHQU0tsE5mJwK/bgP/1Om80d53R6yPlGuUvL1qKDyctfbR0JneZQwaNwjbRVHHkFCv469jEoVYMw3cVQnr8bKGe7NLfLH2BMogNXTKVdSqszChf++KQgqe3b6y0xJHIcujOP4gL7WBlmmEzGKaByTjtthAnqlTlGWxdns35U4qjDIliXt1nO/UFc6sj1qz2FKIW6nb0ofL7CwN3JHLefxwbD7GNVmCIToPIv1razopeJkwLcN1FClmWFc4xaAEWd0pb20rQybHB6Ir27ei8ACNblHBJ63SNyjbfXH6ekdKJSrMbHf3ph+S39+c01f4IuEfC69CTwMqKjwb2ZJ1fazg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x/mGZYbzjvkXzi/Hc/UJytnF9weZ1//wxkbnMP3RiLc=;
 b=qyfwsxgHbrkr33OmKtYsrPu0SwuOmiqDzG5+fX+eWv7/PdfvB9WY1W9cX2qx4De0WRMJ+yjAKFQZkiuXJXf+2umCUN+NuuAlwiGjS36NupaLfw2YQRysQluyzOaxV9DmsLUR2n3I/9TH1pXYU/vxwnfXCVernmKPwQ5ZQt4rP0ZHzaOqRw0V0iJnI/MQ08T/eqAQYDs3Xg+/7/JYO05d2xk8D5DobseWRkTaIuu0VQTpNaxe3L2H3IfwksYMwrYRCyi6Ewd/CbL1x5mflNY29z0qjLU5FnapseihDOozZv2v/ToUJozZyPlCEFyTjoPTaBbXAYjRiEUcozsDjw+0jQ==
Received: from BN9PR03CA0199.namprd03.prod.outlook.com (2603:10b6:408:f9::24)
 by IA1PR12MB8261.namprd12.prod.outlook.com (2603:10b6:208:3f7::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.34; Fri, 21 Mar
 2025 15:49:10 +0000
Received: from BL6PEPF0001AB57.namprd02.prod.outlook.com
 (2603:10b6:408:f9:cafe::8) by BN9PR03CA0199.outlook.office365.com
 (2603:10b6:408:f9::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8534.35 via Frontend Transport; Fri,
 21 Mar 2025 15:49:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL6PEPF0001AB57.mail.protection.outlook.com (10.167.241.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8534.20 via Frontend Transport; Fri, 21 Mar 2025 15:49:10 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 21 Mar
 2025 08:48:57 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Fri, 21 Mar
 2025 08:48:56 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Fri, 21 Mar 2025 08:48:56 -0700
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
Subject: Re: [PATCH 6.6 000/166] 6.6.84-rc2 review
In-Reply-To: <20250320165654.807128435@linuxfoundation.org>
References: <20250320165654.807128435@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <f0eadca6-eeb8-497d-9022-c1bdffbd292a@rnnvmail201.nvidia.com>
Date: Fri, 21 Mar 2025 08:48:56 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB57:EE_|IA1PR12MB8261:EE_
X-MS-Office365-Filtering-Correlation-Id: aaee270e-3844-46dc-3ec4-08dd688febc3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|36860700013|82310400026|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?czIzZ0NUYUYwblY3WFdadlI5MEs4MnJXRlp4NnZNTUc1ck5VdzVXOHFZM3Fi?=
 =?utf-8?B?OHdtVnIrZVJFL05HQkZOVUxwTW1jM0xtTlFqWm50aUxObGR5Mlk3bEpkNlkr?=
 =?utf-8?B?T1ZiTzU3dFNId2ZLSSsrdXNOREdOdXR1MFJ4RjI4NXc3bDFpbHVNWUYwSG9M?=
 =?utf-8?B?TUJxeUtTa2s0amt6cDQzTTI5VjFvd1EvcFFoOEM0MHptUERaTmxzUzdCTkY5?=
 =?utf-8?B?YSsrc3B0dmE0MjhidGl2SVFCajIwdzA3YlYwZUc0Ujl4T2VvdmJ5NXNRY1RB?=
 =?utf-8?B?VStodVpDd3ZDMldrd3libUk4OFhlSUZTMnpQWm9PM3ZVamlDWTU4OEJUS1po?=
 =?utf-8?B?cWo3dlNyMm01b2NiMC82UkpyREkzNjlWSnYrcWZ0YWdIZXJYQTQ3cWhxUW4x?=
 =?utf-8?B?WFYwZk52b0pCTVE5ektKVUpNcndwcE9NckdrNzRmR2RvNmlhWWxEcG50a2dm?=
 =?utf-8?B?Y0RtMEJ0WjZ1TDY1RTNTeTArbTNGUE1rNW1Ib1U0YjhlQWRnbm5BeWwwUVQx?=
 =?utf-8?B?S3NETE1UYXhzK3F2YlRBVk9kMzhQeG4zV1A2VGVLZlU2Q3Y4MUkyRFJGWHJC?=
 =?utf-8?B?SmZlQUwxZVZ3N2czM1NkV0hVUnFvRHVaU2E0dGZ0SGx1WTVmQjJjY0ZaRjRX?=
 =?utf-8?B?Y21xMFBQNWVnYi9URGcyMnFPbjRoZmhmRnBRSTQ4T2VJdjcvdzF4eFdGVVZM?=
 =?utf-8?B?Q0JSQTRlMUNEWmN3eGZYRnY0bEkwRjVkOUxMb2luMlhZZGhRVDlpdG1TVk9I?=
 =?utf-8?B?QjMzNGR0SjFsdUw1WWZuais3Q2tvV3Q2NjZsQ2xQL2U2Wjhpb09zMFlsSFNy?=
 =?utf-8?B?MjU5bmlIL1JmY0J4MjEzV01tUUNIVm1uUlBMVUIzOHVlckNlVmJvUmU5SmZC?=
 =?utf-8?B?TjJXUVUxNExiOGxXMnU5REk0aFd6V1RTai9JRmpoaTg5NjNhSVpNQkxmQlpv?=
 =?utf-8?B?ME0rYVdlMlZrZ3k4SnhOd2lPOTZaUjBpcHBoRCtoVnhrMnFidmJPc3FQaytz?=
 =?utf-8?B?LzZUa3NlZ01KaWM0MzVGWXV2TWR1d2JmV2drUDR2aTI3R0xDL3VCS09WMXVx?=
 =?utf-8?B?MG93UVlIei9WZ2dhRTkzZTYzM0pNQlNjRGU5cXJ1eUFmM3hqckZiL1R6MDdt?=
 =?utf-8?B?Zjd5NUlSKzlVY1ZuL0oxVUMyci95cEQ1OExuWUZQeC9DTmFxVjNIS21UbS93?=
 =?utf-8?B?YWFxRm1jV1ZSdHZOYVMvY3U2YWRJVFBkS2RRcG9sbmtRYnBHWmJUclEvaEZR?=
 =?utf-8?B?NVRpcEpYVFBzbTM3VjRPYzhtMncvV09ENnBwczV4a3VBbi9EOURTbzUzbFdF?=
 =?utf-8?B?SnBkZTBpMGN4S2oydU9oSzR5eENyQlpUSVIzU3Z6MkJJSU1zSlhMekFBV1VE?=
 =?utf-8?B?ZUxDaGpkWDBOZlhhcUx1djZabEZ1NzNNQjJtRnV6Tld0UXRudTdLaGNwUWJI?=
 =?utf-8?B?T0dKR2RDMXJSbFFmcktjZ2VKZTc3VjE4SU5sbnZEVE5sS2FmdzU0RjV3ajFE?=
 =?utf-8?B?OTdkekNZWlhkQm00ajVTRkpjMFpuV0I3emQ3a0VZRm9hQ0xaOFlkTTdDbTBP?=
 =?utf-8?B?clg0d1lYd3dDK3NPU3ZhMnNWV2hIcXFWa3FKL0NneEhPSSttN1FTVDk1WDNu?=
 =?utf-8?B?R0dnaHIyS2RNSWhCUGxPZXJKMFdRMEx5eENsRFp5N2NHQmpqNHF4WElMeW1k?=
 =?utf-8?B?NkNFaUVRMkNKaStEZ1VrWmRNY1o2aHE5U3hVQ0ZZS29IdnZBNGV1N1hZUEwv?=
 =?utf-8?B?dlJMT1ZrZ0lUK0hhaTZoK0grbGZ5V0pNU0F4UG54aDkzZW9zK3VmUjJRQit2?=
 =?utf-8?B?SXVwbzYyQlF3WjhQWUlkOUNBSXFsK2RrNm1ObUdDemZGN0FQVCtUbkZXVCtq?=
 =?utf-8?B?RHNLd0tHaC9XRGZYdkNmNUJtdnhXbnhWNkFVbXlwK2lsWk5XekRNSUJZVTA1?=
 =?utf-8?B?S3FVMldwSmFNbFJnY2J1d3ByTUd1K3dpQlZienVuR05QODNLd2lUSUpIRlll?=
 =?utf-8?Q?E1Dl9rlp7r+b+4zNnwr9voWDItbH+Q=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(36860700013)(82310400026)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2025 15:49:10.0125
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aaee270e-3844-46dc-3ec4-08dd688febc3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB57.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8261

On Thu, 20 Mar 2025 09:57:50 -0700, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.84 release.
> There are 166 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 Mar 2025 16:56:28 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.84-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.6:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.6.84-rc2-gbddc6e932207
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
