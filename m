Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2041.outbound.protection.outlook.com [40.107.95.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3414BCA6B
	for <patches@lists.linux.dev>; Tue, 25 Feb 2025 00:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740441852; cv=fail; b=LjWVCSnwBfOzfnFC1su3I+FVXvYgiqEWSC+T3gCYLzPXqmPhXR0CXaAMo5Vl/VPb72iOpvT3npXBA82HEuw40YqsJUJeqId4egJXM+pa0nuWtVobb6UXc+ZcBMmwDiyJl9VQL57cZkDRzjws96/PyNnInxtBql+E48fRH3+Ez8E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740441852; c=relaxed/simple;
	bh=vrHTdseqXNpgOWmgRwHoveglqVqP95hf12x4PLGiFzs=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=H3lrU7s4GAC3e60PC85XSqyD8NPJDKTSJ79/xmyicwA0BUcGMjqm9bXci/gFWfOTBD+8bEornUiBRJ0Ds6tCo3x+stjThG+Nx6ofUw0h1yA+7AjDtJF/92KtPONoq2kHU/BBBGHRYH1fFKrRQEiM1D5/Viu4TeF2hcf34xRVG8o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lEPFzSGh; arc=fail smtp.client-ip=40.107.95.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lEPFzSGh"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lRBd8m/eqy/XiCKEwz4LY/wsAbxvqGLUFSXCr0eNa3l8ar2T1zATRYhbhU0Uj4CEhGYL+WUFGIHM229dZe4uVzhHGegTndO/Eh5xtxjUyFcyfNLydRp9WjAadxi7kLv6jw5Bth8q3Qk/2PMKhIXI7havxbc4XqYDKC199Ws8OiIEb95tWMW3PYr3CvqX8vZJwPu5+BMAmwOrS2GwynBSJ5Rx9nVQtHgHrkt/8MScDRKAHjjrgICwyBDpzz2iB/JPRBLjXVBiHd6cIZezJFuasd5OribptYYSZum239Bh4zyUVsnkjjN39qJ0DjQU1RT0l02NFS2FBQ6rgGsnh79fhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IAQle41JmikdlEl6r0QA8Dl1ON2FmzsJ/jvosCH5nbs=;
 b=HW5ASMyUV3DW1DfBElI0DkoJ4pi/acIhwYgsQXBGr3EqD6YQkyrXo8EpdJK2kKGYlmLsZ/ZnC6PBiFhR+ghb97AZDWKpopCSeKMluXEKzkHE1p02Ml0/9rD9TK8GUzwhuiW0hF7ZqGR9DFIrX0i7BCadr5cm1eRIdNdONScyrOW4TUBa6pi+mv6DY4qJRIXvOpXD8+4dI5uAsQLTBGA20AYixNW4X0HKl+bjvgW8eySi40oL0HvU2SPtXrnZpwZeLTs6lDbZazSF1I3knHACyyGMXgFcP5O+slJlJyDYb8yEoeoRaEsBmI4HlJdrY9teLX9MJOn/P/lAtLyXEBznFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IAQle41JmikdlEl6r0QA8Dl1ON2FmzsJ/jvosCH5nbs=;
 b=lEPFzSGhZGtNlyqwkX5ORV1QApu0v0efq1f7y7D5fsyjF9VLCylRIiIdeYlzDWC8/Ia1nP1fhYLWjpft3TGIqa5sub5SfK3WtqgyKEt6JgTy6r5+UwYQWzWhOHC2Upy9CTN+6YsH88jVLFniNhWrYROuObPdDbeqkpPyyAzh+cjoQqeHQ8JM7Q41MORy8qkxV+jXa1k5wPjljq8bk6GKPPaAo5wQs3tylYbvtAcvG5sg0HnA2PuJ+9nSWDUV+nbscoi4yG/aOBw3ROCMPire6AHjmVXuPD6wvYtXN+me8RnkVAui3VC3XjkJR18X4cga3FFoLXRF9pTIpHUtSAu6kw==
Received: from SJ0PR03CA0166.namprd03.prod.outlook.com (2603:10b6:a03:338::21)
 by SA1PR12MB5658.namprd12.prod.outlook.com (2603:10b6:806:235::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.20; Tue, 25 Feb
 2025 00:04:03 +0000
Received: from MWH0EPF000A6732.namprd04.prod.outlook.com
 (2603:10b6:a03:338:cafe::b3) by SJ0PR03CA0166.outlook.office365.com
 (2603:10b6:a03:338::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8466.20 via Frontend Transport; Tue,
 25 Feb 2025 00:04:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MWH0EPF000A6732.mail.protection.outlook.com (10.167.249.24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8489.16 via Frontend Transport; Tue, 25 Feb 2025 00:04:03 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 24 Feb
 2025 16:03:40 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Mon, 24 Feb
 2025 16:03:40 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Mon, 24 Feb 2025 16:03:40 -0800
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
Subject: Re: [PATCH 6.12 000/154] 6.12.17-rc1 review
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <a89ebd7b-4cbb-4427-9fcf-76a3737454c2@rnnvmail205.nvidia.com>
Date: Mon, 24 Feb 2025 16:03:40 -0800
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000A6732:EE_|SA1PR12MB5658:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ae60b92-c157-4921-03b8-08dd552fe9d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?a0ZKR0NvWnZNeXFBTkJyY1pjRTR4T1U3NHNNS1UxWm5hc0svMjM4emYxaG9Y?=
 =?utf-8?B?SmxIaEJLeUxKYkVtd1NXV3IyczNidmJrOVYxOFJSM0dLb2dXL3dNenRtVU5E?=
 =?utf-8?B?UzQ5Rlg4S1pPRE0rdWVyVWVicG5Tc0IrQlFrYllsTDkzNGdZVnRMWUo5QkVT?=
 =?utf-8?B?d0Myc21RRllDWXlmZHg2WGVYc0E3M2s5bFAwekRSL3ZWWXFReUc5UTN2VGpN?=
 =?utf-8?B?Z3VzMlN4NHFJTzdKUnlpNFpaYUo2dThRcEx0Vk9wYU1ycGJ0NjBZRHpwdjNF?=
 =?utf-8?B?eHpVUFk3ZUlMMkNhVnlFVnYxWWhVTkl2dTZpSnhmSTZTdW9VaTJUWVZTVDhT?=
 =?utf-8?B?OXFUUHNJd3BJNTdmZ0VWa2lEUXpaNUpQZ2dVZGlMVUFja0NWaDdaZ1dPT05D?=
 =?utf-8?B?Um1tT25LR1E5YUx5Wm0reG01T0JqNHdsd0tFVVdVc3dMMjVXV3liTUZRSlRw?=
 =?utf-8?B?VVhjVGZucnlWZXJtaDF5Ui9iOHFXZmRqamQyb2JKY1BBbEhiUGdHZ0ltWlB2?=
 =?utf-8?B?QUZ5ZjdERTZ5NEZPY2lxd20xc1lnVjdpMDFaOUdvbjFtc0NlaGFtL3lRYS9B?=
 =?utf-8?B?aUVaWDVlckUwSE5ZSFpEcTFLQnZuZzYyc0M1dFZ5RkhUK3E2dVByZ1paNEYv?=
 =?utf-8?B?STJjMWNkSFNvRjh4UzNpeFhoSEtKQ2M5bGVLMldFbGJVa0dsWit4SnNyTVB6?=
 =?utf-8?B?eXJDNFN6eXZ1ZjY1ekpJVEFwcTV5dzFzUzVTVTNEdjIrVHd6WmgxRlUxM3p5?=
 =?utf-8?B?WlRDYkY0dXZLbU1LeWRwOE1ONXhKOTlzN0RablZhWHVrTzhVY0M4UElkU3Vu?=
 =?utf-8?B?MU84TjF2OWFMcU1Yc3JUdWF1ZDFhdUVPYktxYlB4MHZ4NHgzK1h1aHZGYjFE?=
 =?utf-8?B?WFhKMDNuM3VjakVXZkljODlSOFN5TGJNc1pVZU1leDFrNHFCMHZ4UURUNUFq?=
 =?utf-8?B?MHZ5Zk0rMDZONTZPRXlsQVZPTFlnSTVXbndvMFFJTENRNVpaTWM1VnNpTTNj?=
 =?utf-8?B?REV5ektQNVJ4THZ3d1NGZktFQ1FZK25Ca3pnVWI5YURtQ0JaS2lJMThtRjE2?=
 =?utf-8?B?L3UvVkxwRFBCOHljcHBoL3NQZjhQa2I4b1c5YmhUa0FwaXgxQkQ4VDRUQUti?=
 =?utf-8?B?L2dDVy9FR3JKek1uclZUQjNsNnE5VW5jcjFZUmw4THI2bU10U3c2bWdqUnQ1?=
 =?utf-8?B?WTRaOGMxUHYxclJGb0RlNGt1WmVEcjNmQXlVcnE5NU5IOUNZaWxDNWF1dlN0?=
 =?utf-8?B?a1dzbUZoSmV4T3RQeWdzWHZYbVhDTEtuK2RpV2dXTEhSUUNoZjdJcStjemRD?=
 =?utf-8?B?ZkRITkt6alBKM1pjSkhEUjRXdU5tVmFBZmt1VjhpYXNlSXdILzdlTXd3MHRN?=
 =?utf-8?B?UkVpOXVFbWFCNVlUdVhWaERuQ3BKUlJtYytnQUpCeXZFTmxWc2R1UGVwNG9y?=
 =?utf-8?B?SEpXdmdiRWlKMU04WUl2M2pMM3hkb2E1cnp6U1pzWm5IUkVVdUUyUnErd0dB?=
 =?utf-8?B?d0FPdG5INnlqOVNJdWVCRGFVY2gwMWZ1UUU2WVhUa0pET05BRFRWalJYSlBl?=
 =?utf-8?B?YVAvMW9zTUlnOUM3aW9JTk90bG9yTEdBeDh1SE9wRGdYM1dBejJST1B5a2cw?=
 =?utf-8?B?VHpXU213OW01RzVxWmpwdHgwQ1M4bjJwVnIxc29uZ2xGeG8rZHA2a3RyU1dB?=
 =?utf-8?B?MDlTSVZTMGxWNERWMnZWWXBaYUlFZnUzbGxJUkkwREFHbjcvTGprYmpyUTFL?=
 =?utf-8?B?bFIrVEE2d3ZsWkFTMTBSbENsSGdxdHZnM2d4TXRQUXZHQ0ZDWDFVeWpDQmNX?=
 =?utf-8?B?UlZKT3pnT1crUFRnVTlnelNZVUtSU3pORXBXYjl3S1p5eGthSXhGU3ZydER4?=
 =?utf-8?B?Mjh1ZGxvRjZGSTVhYmk5akp5OElqejFROFBycDRTeHgzcXF1SDNSeFlleWpH?=
 =?utf-8?B?eHViU2Y0aFpZL1JPRWhoMSt5VXR3VVZZeklYZ01ubWdUTUJlNDNjeW9VaUtx?=
 =?utf-8?Q?qOvU2tJZJfXtHzaWhm88EPx2tLU0Oo=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2025 00:04:03.0169
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ae60b92-c157-4921-03b8-08dd552fe9d6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A6732.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5658

On Mon, 24 Feb 2025 15:33:19 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.17 release.
> There are 154 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Feb 2025 14:25:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.17-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Failures detected for Tegra ...

Test results for stable-v6.12:
    10 builds:	10 pass, 0 fail
    32 boots:	26 pass, 6 fail
    72 tests:	64 pass, 8 fail

Linux version:	6.12.17-rc1-g497e403c6ee0
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Boot failures:	tegra124-jetson-tk1, tegra210-p2371-2180,
                tegra30-cardhu-a04

Test failures:	tegra20-ventana: devices
                tegra20-ventana: tegra-audio-boot-sanity.sh
                tegra210-p3450-0000: devices
                tegra210-p3450-0000: mmc-dd-urandom.sh


Jon
