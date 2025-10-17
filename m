Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012048.outbound.protection.outlook.com [40.107.209.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70CBE335074
	for <patches@lists.linux.dev>; Fri, 17 Oct 2025 18:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760725321; cv=fail; b=nVr5IeKuxcQI/MI8/f1t1Ncd/fLBD2tfbgaJPi1Xk+WG0/ZhQiLBfoHbj3YCuGIWzqv9rYKqrJ08b5aFV/G2Zjm0Fcwx0ivfTISqINz2YT4+HmW8XF/p01fAeZAbYF8oVVn1dnjNqCW6e/mg1mhQ2xELrVZo+owdUD5zUyuzfy4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760725321; c=relaxed/simple;
	bh=qvU0d4HSg3Gw4JqsUprbwlPk2eSTYDLS/le/tteWM5I=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=BhnfkiZ2VKmkrtWRoChcrAdQT0Malz1Oj1vYds3WyOGav7k4vmASLgb45L4B8rre1cItsz1nC8FNEQzCAkabidaafmTSqvFWNFrYkexDJLqaTKvb1udXGKFeBZeSbSb3HY8TLGEAwXCGyo6XvbyM+QEcgElqNTjeHX/QNHUzsBE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=mBR6cl3F; arc=fail smtp.client-ip=40.107.209.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="mBR6cl3F"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Jx+mGI00oOqTVu6ml8OuRZD9yX3CKZdBKbV3Tn03xGGSC3+ho21mjSKGip+1fr1Iijyq8BSlUy0qerSsr6TfIp5WDGqJh7MNxcXehN4HA07UaI4S+DdNhpS+5xgKyRqFQ3LoGc70ymeodfE/o8CIRTDCPD44y7xFf1lcqEBQl5QaQm0CFW/pTKQwiGB3TRIxl38gX81C1/JCJfoVwrrQVK9V+ZgqJ93vRrfg0MduMV4pt0/t+sjVZR25WqCKs559edUoHzDr8ScF+G4Wo1VZER/vmMNj+FL1I1vANnFt1xilS+Qo9s1gXiy9xqdZgzNlKjsKa88Dtp7YYiFoLpbcJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7Nbq5yoiboJkAhbrP6QyQabuw1uq0pcNE3THCpjBfD0=;
 b=umArgrbbXXiPiL/lasMksPt3S4O2PNuOd0pxksuaBxgml8Mx0ep/vbO9h/w1iGRIgaE3lPrBJKHaQWuBWraV7KI/usboAEkMLkTEdzakQxZgoyjV5qUb+N/TBuBu5R0DLKBbrYz1f4TefN36XYHHkS9ZEPSssqSOrKOddOYMajReNBlgBfegJmSNHF+c9BVwV3w445K0RQ1t/8I4e8Jl8jRyB9yHE848oNR/QVJO3Rwin+JXJFqRA1NthRAAm+GgCUa3MDkui5wUnyRVxhuYUlbqWqo3UpnjokP5W8a7ZbKh7ZNFXZiXikS5RKcqSlW2EYa33j9s63j3qQtRmiXMbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Nbq5yoiboJkAhbrP6QyQabuw1uq0pcNE3THCpjBfD0=;
 b=mBR6cl3F7onC3OIElSApsk96WXmgJipxDZhbAEDBFfU1Bo+dgHh7bkUSqrDvxbCKM1XD/B6dcpJungLktDqVrvYORTRWLH1+pwYH8D67EkH5Ft40PWMa7nVNudZebjN5BC2l4vB3uZlb7fNQhrlJzQFJxUvf0DCEIUVgCMroC6AGTW2x9v2P/+qn/R5z/E/nkgKeQHDLMptQG7H3vak6/Nh9qqN/TKQJhPcqQpPpcS3qAM5M6q2HAZicwqk4uySWsP2olYp//9Qm5MhQpqcxiv+L6MgelO6PZYfR2kIWTUHLHGz+mFQdfV16FjYo49CsBkGsNGgwTZmVanrPQNNNlg==
Received: from CH0PR03CA0308.namprd03.prod.outlook.com (2603:10b6:610:118::10)
 by DS0PR12MB6413.namprd12.prod.outlook.com (2603:10b6:8:ce::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.12; Fri, 17 Oct
 2025 18:21:47 +0000
Received: from CH1PEPF0000A345.namprd04.prod.outlook.com
 (2603:10b6:610:118:cafe::18) by CH0PR03CA0308.outlook.office365.com
 (2603:10b6:610:118::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9228.13 via Frontend Transport; Fri,
 17 Oct 2025 18:21:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH1PEPF0000A345.mail.protection.outlook.com (10.167.244.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9253.7 via Frontend Transport; Fri, 17 Oct 2025 18:21:47 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Fri, 17 Oct
 2025 11:21:33 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 17 Oct
 2025 11:21:33 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Fri, 17 Oct 2025 11:21:32 -0700
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
Subject: Re: [PATCH 6.6 000/201] 6.6.113-rc1 review
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <eab884d8-76e7-455b-93de-80c67691c8e5@rnnvmail202.nvidia.com>
Date: Fri, 17 Oct 2025 11:21:32 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000A345:EE_|DS0PR12MB6413:EE_
X-MS-Office365-Filtering-Correlation-Id: 30617098-e686-4d5a-3304-08de0daa08b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aFo4LzBsMXBCc003MCtYMjJQREs4emZaZ2VJckNqVzl4ZFZxbncrSmFQTGhZ?=
 =?utf-8?B?SnEya09IZWgwaUdPL0wrMFdabzZ6NzhnNmtQMENOWnlOcWtkQnUzc21UUHVo?=
 =?utf-8?B?SWFMcFYxNFFySlRmVnFqYXdkaHdjWCt4T2QxUy9oSnlDdGRUdUE2YmRpbmRi?=
 =?utf-8?B?YWpwMVJnbFlpdU40WE1MVzhUekFnWlJNNDcxWldTRVMxT0RJUFk2VTdVenJ2?=
 =?utf-8?B?V0UzOVFBSXBaK2pvaEZNL2hCdUh0ZCs4L3grU2lRTDcyRTJ2c2dQOXZaeWNY?=
 =?utf-8?B?ZUs1eDNNamV6Vk9jZXJ2RTVWdlNmRkxsLzllV0JWbVl0V3prUXRITE16b1p5?=
 =?utf-8?B?ZEs3U2MrSlowYzJzM3lzcE5lcjZIblM1amZkVUQ1bWFrb2ZWenF5Tkg4eTdm?=
 =?utf-8?B?OWlodjAyQ0VWT1JuUTNvMWJxMGcrazhPRlJTYWxQcWZGTHd0dVB3Z2NXQVZJ?=
 =?utf-8?B?eDFacGV1bXpiOEVNR2c4bFRNV0hxcHNaZ3l6VlNkcko1WHM0UDI0cWxmdERG?=
 =?utf-8?B?ZEg5UzJMNHBKS25Tc3p5NzZlYjVIWVlIeXh2d1g1WndKa2FGa0Y5VjZwYWN2?=
 =?utf-8?B?bjNVeFRacGhqUVVraU1wWlFlMW1OUU8wTjBoc3FFS1p3eHpHLzhvcVJIS0lj?=
 =?utf-8?B?R09BR2RJNWJkVXAwZmQ3VEZvWnFIL1pEY2plcy8xenpUbHFzajNDZWs2ckpG?=
 =?utf-8?B?amZGSGhubFdENVhPNUNicThyaE1QOGt6cW1lc0xncmhOYTIySEpVdnY1ZzMz?=
 =?utf-8?B?MHRHdGtoUHZ1WWdPRzVtMVd5RFdSTU95S2FiMDRHbzJWRStvemtZNldpbDJa?=
 =?utf-8?B?MlNmWmxaaUU1YTJVc3lNUCtucjZnQUtNcUFQT1k2YllEUDdOYzhJaythaVc2?=
 =?utf-8?B?YU9TVXVLcUMwREhDWVJRRGx0cFlLS3cyWStLaFZia2pBZG0zaTc3ZjZUZkpN?=
 =?utf-8?B?eFY0SHBnbGNEbVlUVzJyY2tBN2tsWTBFd1RMTndLYWVPSXdORktIemFsekxx?=
 =?utf-8?B?Tk4wQWh5V0RvNHIzZCtvOVl3UVI4NHhMcVUrRkNkdmVvT1gvcHlMT3FJTllV?=
 =?utf-8?B?UW5xVlpNd00zeW5vVUJmalhMeWhoUHRud1o5Q3lEYWN3L3F5SFl6Z3d4c2p1?=
 =?utf-8?B?bE81a0V4MWxDbGVsMlVzZWpBNk1HQloxclNKaTZJRDJVUmJQMkF2Ri9IYnpI?=
 =?utf-8?B?NEx2aStycVJETDNkVTN1T3F1TUJiV2I3MHlTdEhQMmwyREpndjFVRXl4REFL?=
 =?utf-8?B?RlNYMHg1akRRTm5qWS9rS05hbGp1aU9zc0RwYlY4WFNEc0ZIK0dlL0JJczFC?=
 =?utf-8?B?S2ZJcEdEN2xyMWhJS2Z1Y0EvbmNwTGVXL2k0amlzNW0zUUlyMTRSQkpWOHo2?=
 =?utf-8?B?WktOeWt0OGRFMVN1UERmTEdlc1J1QXU4bVlzcjltZ0RqY3VuR0xZbDEyT0Jw?=
 =?utf-8?B?TnBRNENyUUsrZjJEYmNjN3NYYWRNSGs1TUovbytzYUI4TmxCeGI0N1BBUEk0?=
 =?utf-8?B?WmZOYzlzWHZ4Zml5d1d2QitMajVUcGNXd2FOT2ZyUzZHejJWRHZnVkxkVGx2?=
 =?utf-8?B?UEdtU3Z2Sk1kZ3hRZzM4Um54MTJQVDMxYVZObmdDTWxvbElNRnRZU29ZUFA2?=
 =?utf-8?B?Qlk3VkpIeC9mVzg1cXVGdkVYTmVIWGN4eGJxOFZEd3Jhb3BKeTVveC9mTnox?=
 =?utf-8?B?T05PNnFQdHUxbHpxckx5cVhHSS8zV3NLMFpiQWd5UkJkL05Id2VWUElPRWpJ?=
 =?utf-8?B?cm91MnlmSU1LZmJIZGJtVU1acmVjdlBWcDZ1azhKbXVlSVdJNkc4Sms0akRn?=
 =?utf-8?B?Q0t1K3B4R21NQTJ0MkQ5NXRIMTJnUVZZek0rSzIzRTByaFQxZHlyWm1IY2pK?=
 =?utf-8?B?RElJZFBEbjRKSW5ZZjhaRituUHplUnJsOFpsSitUTGdMSG96NDBYSlNoUjNa?=
 =?utf-8?B?Yk9wR0laQVhHdGUwcVJHamo2RmpMTlRwbXBCNm9TM0hiNGhtS2diVWZ6NkJa?=
 =?utf-8?B?UW9JL2hPNTZJODlHTWNtT25KOG9JWGRqdFNZWHkyZGFrMHluRWkvVHRMaEU2?=
 =?utf-8?B?V2tYYk81a2FaNEpjbklmQmM2UFpibW9DeGVPNU1ISFhlNW00bzdVSTV0SzRW?=
 =?utf-8?Q?Xt/4=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2025 18:21:47.3279
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 30617098-e686-4d5a-3304-08de0daa08b4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000A345.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6413

On Fri, 17 Oct 2025 16:51:01 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.113 release.
> There are 201 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 19 Oct 2025 14:50:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.113-rc1.gz
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

Linux version:	6.6.113-rc1-gef9fd03595ef
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
