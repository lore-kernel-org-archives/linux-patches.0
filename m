Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2053.outbound.protection.outlook.com [40.107.220.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B6C2DAFB4
	for <patches@lists.linux.dev>; Wed,  9 Jul 2025 13:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752068433; cv=fail; b=eSzbkJk3gkP9KpXrHgBlHiP6s1uV+uvd9E26NiZK6gii6FnvyW3psBEC+LjUSPP2TfzhDQcWJnvPSULbgvE9w36fIgzGW/xZAD53DuGHWVZ+vueEebFcp831YEQGKE7NmBDfLRrBHbhk3ly4SXDm2r/dcbOpDPP7RL3A+NNqXw0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752068433; c=relaxed/simple;
	bh=TkJ+9byByR50nZGld0K83kzDzvxqeneYve6/kxN6QYE=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=sLAWYcuN6iq8DHLiw2cgbuMTCdy7m/u0n0hZ4jAnhYnE0BgM0mw6y0DCPgQEYeiuBOADEueQiQgQHg0ChjwryVrYdD1w3AOfnoNhQd1IHeW5un717HV+JplcTgENadd4OW7otVpaihqzdPIzOKcDXf0urO7Kw/rqtQssZ9yRlFM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=H+9asrn/; arc=fail smtp.client-ip=40.107.220.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="H+9asrn/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tWtor81uwgQk9okJ+973G62eLcqreEviyBZ9Xpeib0HcIBcnPQ0lnvG0lxJWOtcxUaOV09lporfCeW6U1fL0j/R3GNflxnOvAW6FvWW+ILKR4jAx+kIKbMDR0zUSiS8CrJpbkeUdAGjK7N/pxvGnEqY2lUInDvXgSHZwemqIEd9Nm9q69vBRj6p8r3sccZBUCVUU/MN9BCvuMRR64gDxLNqZRkF0N1PE894bQHzkQ9f8ppxAqYS0kJX/NQNOic8AUmyHjDXq1cublmA7ez+GC+CoSfKBPS+jlbslH/MaPzMFk2KxapiHwt/+2oeIUXyA9TIG6ooqNSFivvxYfFW84w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QHU//8X/mt2oSYqPhEwC29WsXOS0EA7kf85TL+t6Zeg=;
 b=HxAtTWFKk2Hn2DgyzzbmrKn8bX1PiC2oNTHR00eaziWu2+TG2kYo5t1Mjit6TQBNdlvL9/zQIcaJUVZvGH/i+UdoH0N4ZRDBwtXghcmlVctOsOEL5ksvH1FgA4NPuvwZfJcrPYuyxCtuf3m1QFCtebcdjTgDTN9hEO547qpEiL6cwDNDsBWJAqNJjH/XZRSLGkKSHy2FtLR7ll8Jz3ITfu3ggg23oL/i6sFpwd5mGgdH+9wXboVnVOleCG7+gSQ2RpTbtx2J80zaieomPxV5xxovFpPxUUcjBHmDgUp0oXjeWmht8slH5IZXk1rDYX4r2wFD5ds2oQWHIJjAmRCTzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QHU//8X/mt2oSYqPhEwC29WsXOS0EA7kf85TL+t6Zeg=;
 b=H+9asrn/DUcXza+88/CXni9DmD+WUgLi11PSidTdExZnAK5+i0ZLe3uheP90DCNpTIF/CWJ9JBfaNQ415lLMIvWhYa7NcYXIFAqUnIk1azhGrCxzJZsZX8AE9eY2xsw60WpVB0LjeJMbU8B5580lf8COe7W9z7BZR6z+Ma6FejaYsvw+b7l1zVOnpbVPHvT40sjZLTRW5ya4Dazljp6N1/hz1bfdZOWB1J2ZH1Qfg25XNftwOog+DbQC+Te5NWStSKN0KGmL6xD5vBdBuY/sxCIrjYzAeTBKdzzah5Xr40/TjIhA73+hRKUKubnhaMEiYnQh+iLDFs8DZ6VCmwfldw==
Received: from CY8PR10CA0020.namprd10.prod.outlook.com (2603:10b6:930:4f::10)
 by SJ0PR12MB6989.namprd12.prod.outlook.com (2603:10b6:a03:448::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.24; Wed, 9 Jul
 2025 13:40:26 +0000
Received: from CY4PEPF0000E9D4.namprd03.prod.outlook.com
 (2603:10b6:930:4f:cafe::58) by CY8PR10CA0020.outlook.office365.com
 (2603:10b6:930:4f::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8922.22 via Frontend Transport; Wed,
 9 Jul 2025 13:40:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000E9D4.mail.protection.outlook.com (10.167.241.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8922.22 via Frontend Transport; Wed, 9 Jul 2025 13:40:25 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 9 Jul 2025
 06:40:09 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 9 Jul
 2025 06:40:08 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 9 Jul 2025 06:40:08 -0700
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
Subject: Re: [PATCH 6.6 000/130] 6.6.97-rc2 review
In-Reply-To: <20250708183253.753837521@linuxfoundation.org>
References: <20250708183253.753837521@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <91e42796-9606-4e11-bf52-df2b696aabae@rnnvmail202.nvidia.com>
Date: Wed, 9 Jul 2025 06:40:08 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D4:EE_|SJ0PR12MB6989:EE_
X-MS-Office365-Filtering-Correlation-Id: c6c82a7c-b5b9-45ca-a960-08ddbeee293a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eGdpNkxWL0t1UFJWTW5CdDd3ZjhQcjV3NU5HejUydkR6MVdXNTdTOEZtVGJZ?=
 =?utf-8?B?YkJRSS80UEJ3YjBxUUtocFJTNnYydHZSQVR5OWw1cUpRek55TzV3L0tDemZ4?=
 =?utf-8?B?VFlKQ09QakhHWk9WeTBtRm5lL1djUVVqKy9ydFFWSWVjNkF5cTZTK29xYWl2?=
 =?utf-8?B?MGsyaWs5SGZEdlczVzZEVlhaUktnOE1xVGx3dDU3VDMvWi9nTzhvUzlFSWhL?=
 =?utf-8?B?UUxuVU8vekFuaTRzUWd1eDU2SG8zc2NLcll1aVl3TERRSVREcm90U1ZpUlRj?=
 =?utf-8?B?aDdBS2pzZjUrVllDTHBmNEgwZWhqM2ZyU054aGdYazA2dVF2M0ZZdTV2KzBu?=
 =?utf-8?B?T2JWdnFkaVphTXo5OGtiVUx6R0YvOU1Xa0VWSVB1SmNmUUNNdTZTZ0M5YnFx?=
 =?utf-8?B?OCtWc3FrSXRiUzhaalA3WVZtcStJZkxyMHl5bzFFTXFtTHBLUlR5YWtNeG5M?=
 =?utf-8?B?YmxSWmF3bUdJNHc4cEYzZGd2eTVtdFBjVzVKYlZubHNnQXg5ajB0empLUnFW?=
 =?utf-8?B?QVZYNjVUWWlnU3laNzZzS1I5TVdXN0FqNTVHa210QU9BNEdMem16OWJDbzMx?=
 =?utf-8?B?cVpMY1dXVTFxWXcxWm43bXZTRzYzM3k3YzQrWndDRDNYVy9LTU5peDRsUW1j?=
 =?utf-8?B?dTdTa2lxWHFTMUpZTnBLOFd2Sm0vV1o1TDdlU01HZ0JvdHZOQm81V1JTRU1y?=
 =?utf-8?B?eUI0NUtZY01CdFg3MXZqV2ZudmxnMjBORmxmK2QvbGRMR0xmZXY2OXdNRS9n?=
 =?utf-8?B?YVVtcmVrdXR2TWlZdFVMSEE3Z00zVDgrUmV5UmRpTjV3ajRIMmc2VkEzOVkz?=
 =?utf-8?B?SmNsMm9TWDBzaXg4OW5ieVd2YXBEZ2cvZjJjUnUwc1VpbnJ1SjQvdUxhQzdh?=
 =?utf-8?B?OHhvSWlkR2h5Vk1YN1JLN05sNUhwSG5DTk1oYnlheE5ldU1rbndsNy9JdXM3?=
 =?utf-8?B?b0x6UklrUGhwcWh2TnNxNlY1NFhKMTdzMG93dDJBc0hxb1pNTHVXdGpML0ZK?=
 =?utf-8?B?VWNmMFFmUHErdkVyc1krQVZWc0R0cFVPTytOUzl2UjNzT3kyNm54VEo1MGpW?=
 =?utf-8?B?OVhIL0RrWmUyU1N3cWdZOGc0UjJadVZFbnNQazU3YkN6SkFKTlI4R291ZUhF?=
 =?utf-8?B?bnBTODZORmlUMkJpVlQ2bGRhUG5KaXlTY2hGU29CaytNaUlmQ1pKeG5NdXZz?=
 =?utf-8?B?QVVrUmZDcHMrOUJLOTMvZHRybmV2eTRnK0tnbGp2b1YvczlXMDRHZEVrd1pX?=
 =?utf-8?B?ekJxNnhka1BvU1ZLcVNrSVkraHlFSXZzWVdTYkN5UWdCTUZoYUY4bUt2Ynh0?=
 =?utf-8?B?YTZJSjc1TWszWnFXWk1QYysyYWYrUE43WUxsYXhBdXd4MDc5MkdHSWhZbXVX?=
 =?utf-8?B?Z1ZZSk1oWSsvdjVsait1aEF4NGRybFVJQStwS0NuWFJRS3dQakRCczNmKzFr?=
 =?utf-8?B?TWlncmJJWlJTMktNenFkL2ZBbVl2TFkvb2RZa0JTeFJGdkwzV29TMENUMTNU?=
 =?utf-8?B?REJVTTY5Rll2anFKQ0NFSkNiQVZvZzMwMmgvMnpKWGdhdG1ETWkvMEI2K2NX?=
 =?utf-8?B?WEc3WEUxeE5XUkFmR0U3SDllZkEweEFjQlNGeGVuVGZnd0luYW1USXh2VUc5?=
 =?utf-8?B?cEJDUnZiZjVjYmduRmlVNGJLd0dicHYwUHJPemMzOUR3OTN6Ny8xaHN6c1lO?=
 =?utf-8?B?a3AxVFdRaTRudWJHb04xRm9XUUptU3lHaE9Jdkk1RklHRlpZS0RFVXAxM0lj?=
 =?utf-8?B?ajFFNmRkWjdmbGdUQ1ZaQ1VxbTk0QnlEakJNZ3ZFMi9PMXk5V1piYkRzdEUw?=
 =?utf-8?B?RktCb21lQmQ4ZXBEeUZyQWVvWjNSZy9uNm1udTlxbEREcmNLa29RSVgyY1hw?=
 =?utf-8?B?bUFKanUzc0dxVUNVSys4dGJxY05ScmFTakJNbXRMcXAxakpiUTlnc2lvVWpB?=
 =?utf-8?B?NCs4M3JuQk9YZytlOTdvRUkzSXI3WnhiRzg5KytnYjl3dEF1YU51SXVadmJB?=
 =?utf-8?B?YlEySmtDcEVIKytWSzVjUEtqeFI0OVdmdzU5TjJ2TENTc25sZ3BJSlVJVGUr?=
 =?utf-8?B?bFZvTWVtbGRlQTRlK2crTTNCbm1Vd1BMeGtLZz09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 13:40:25.8328
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c6c82a7c-b5b9-45ca-a960-08ddbeee293a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9D4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6989

On Tue, 08 Jul 2025 20:33:42 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.97 release.
> There are 130 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Jul 2025 18:32:37 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.97-rc2.gz
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
    120 tests:	120 pass, 0 fail

Linux version:	6.6.97-rc2-g7b8f53dba183
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
