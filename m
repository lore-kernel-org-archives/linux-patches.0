Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2046.outbound.protection.outlook.com [40.107.94.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1757012E1DE
	for <patches@lists.linux.dev>; Fri, 24 May 2024 15:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716564036; cv=fail; b=GzXt6FXDN4pU4adRqp9/yRC8u8TF+2oRI8sBHlyKUH4QI7o4MehJ0f8rEjvWnAR+WjpENazzdd6qqKfTl9/FinajY/A9oKjR/XNh2BHk2YA3X5vihOcHtdqHPN1Pv8Pj8qj0b59KB4jE9nmrKuhTQB+VPQmDkOeunZTdb8aMTOo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716564036; c=relaxed/simple;
	bh=KTok+VVEV7U5u5leAfpiOJ6FVUQ7KRMMvd89X+CTP7E=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=VTGyK1I+DOYa07mnGFvsTuJphRuYKDuZQrvkUpumwURclY7JlxdiWo9XfhCg2P4opHUJbRqTFCb2FWfiaiN9yLwOhkI3Z5eS7odTG97b+D2MMlczmeuwMM/HSUVJx2UN3AbsQokuxwoBesMsiw4mBFfvOfJMSdjduQkFHuxMyh0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=IuET18lG; arc=fail smtp.client-ip=40.107.94.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="IuET18lG"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OS3jTrwzNEpGYpi+WCLp6eRGzIsKtw6Yc0VhhoNLBo02vxweVc/7skg/avF+Xa/x7g0zARd/WHdUaTs8va+Ny5gtdBAiExNHsAFOoA9jEZFZ25hspzEzPcOlUmYTJwHKgu2MjXVC5jpeEVYpgmxjaGo6nMymobDb+HUfat4H3+gra3U3vx2/27vGZQs0GsKjmz+xETe9T78crwC03Z5q9p1o4nfLI0cJYMoHer0RED0PKRv/FfMUh/PCsmxSTfU8h4GRyCfByhAwpyGwDEc7rDC8cdrJJuKBv682BL6fUHmUz9dgtuWQf46KYzsk6Ue4hxzmMdh/OV+aUYlrjdNHFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GyscnMihJUFh5Rma6ypPmu540+M5ZIA2qyiYB//Yous=;
 b=aKD1zMMhkZNdSbzzsSfSQkU/U7UZeFqQ0s1yc0JgG6JnGJKbb08tjTIei/Ba5BMcOUSbrRc4roNiQhByXFa3V2CLPJbqJXi3Yyv1RUDdXpCM3mMRKrWrIklfKZkZ/Q01fdCV1zC9nfjAQl+C/tJtTM2Wc6ekoR5s9fKmA94j3vAtkZ4Oi6v2UqFrWsWDEOlocBiIz+W27J4qaKQ88HQciLHAOWHIvOScCwQhrrXqE4/3RVgBqvlkM6dSuhEZFVrnBqeH7vDd84JBlJtrpCSf94kImOOcBG0A79qBZhnzX/vlr0t/OLDZLfDIVhc72lqTn+luMxDMmBfzV3GUWtyO1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GyscnMihJUFh5Rma6ypPmu540+M5ZIA2qyiYB//Yous=;
 b=IuET18lGJqSxcpdbTs7lSXpTEjYP95/2Q8YdKSBGeTS97g+VoG2UnRtOdihUPodkITsP1YTmX7td+BtIYMlfDBQKCzx2FGSviICCEbwp98p0eYY634H7J2mcMH4tNTAnkQmD/FNzrvlwbgWusbbOkmxDWTuDadInZps9TEw/f5tHrv7bnDXOleCBwrs7H8oR0CsTLR4WH6hrTG9FSOhMp+MKPsVkvOlK8892tiY5/BySN3Q8uIKi+sR4BA1DYhKQpyRh/9zOr4OCVFfcDTVRIhytXr7FXXfE04cMLDiNupcyeno4Q3Px964WlKg2k40uSsyMfLQDVH7b0sN/HOTSSQ==
Received: from BL1PR13CA0282.namprd13.prod.outlook.com (2603:10b6:208:2bc::17)
 by SJ0PR12MB6855.namprd12.prod.outlook.com (2603:10b6:a03:47e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.22; Fri, 24 May
 2024 15:20:31 +0000
Received: from BL6PEPF0001AB51.namprd04.prod.outlook.com
 (2603:10b6:208:2bc:cafe::4b) by BL1PR13CA0282.outlook.office365.com
 (2603:10b6:208:2bc::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.9 via Frontend
 Transport; Fri, 24 May 2024 15:20:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL6PEPF0001AB51.mail.protection.outlook.com (10.167.242.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7611.14 via Frontend Transport; Fri, 24 May 2024 15:20:30 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 24 May
 2024 08:20:13 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 24 May
 2024 08:20:13 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Fri, 24 May 2024 08:20:12 -0700
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
Subject: Re: [PATCH 5.10 00/15] 5.10.218-rc1 review
In-Reply-To: <20240523130326.451548488@linuxfoundation.org>
References: <20240523130326.451548488@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <66467156-d26f-4d50-bb1f-4750bfedda75@rnnvmail204.nvidia.com>
Date: Fri, 24 May 2024 08:20:12 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB51:EE_|SJ0PR12MB6855:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f7fa4c7-c5ea-4c04-e206-08dc7c050cb7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|376005|36860700004|1800799015|7416005|82310400017;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?enRJcXV4RVpWM3ltV24ybHFxQnp3bHVLREgxcmd5SmFBeFQ2ZkIzM1EwMS9E?=
 =?utf-8?B?Q3daWks4RDRWTlpsdmxsY29RWWxmYkdOVi9zZXhlU2ZpUVp2eGQzb0JKY0t1?=
 =?utf-8?B?NkNBN2pRcDhPM1o5RWd4VitMazZYM1hjTmNzK2RTZHdCU2tQSU0yM0lrK1NY?=
 =?utf-8?B?bEpXNkRmRHl0QjVpNmY4eUhOWXh6c1NxbWppUUx2NCswZU9HNTh1ZjlUR2FJ?=
 =?utf-8?B?RWF0czdDRFkyUDJ5OUhkeTVvSVZyb0xXdjdxTzRkQlpGeVZQSGorUFNUV0c5?=
 =?utf-8?B?Z1BvZUlIOU00Z1pSZmh0bWxINWswU0lkcW12N3RiMG1MZUxvZFA5UDY3VnR4?=
 =?utf-8?B?Sy9makt6OWtiNEhQSkRBeEcwZ0RLSDdJd0tsb01ucnRXVE1Bd0dRcGFuWHAr?=
 =?utf-8?B?ZmxsU1FVTmM0K01YaTM2N3Ava1E5TUF2cUV5VExCZ2NsRXM0b3IrOGVDSTRl?=
 =?utf-8?B?VEFpNGl5NVJ2aHNSZS9xYStYeU1NSG0xV1lrcXdsMnIybWJwQU5IWE9MaDR2?=
 =?utf-8?B?NE94UzgrMVp3QWtEOFE5QWZsYWc5WVZyd0szanZwUWpUaUZkRlNFSGpSZE1T?=
 =?utf-8?B?cGdUMVFlOHk3SVd6a1NQUXE0SUFsMnIyczhMSzlRb29ZNUNLYThSSm1NYlg5?=
 =?utf-8?B?QnhqeVIwekxnRnJJVkYzUE04SmVBak5FRExkbGw0QWJjV0pJQzN2RTVMU251?=
 =?utf-8?B?MVkyM1dJeEJqQTJFdEs0aGRnWmViYlJRUG02dDI4a0JlNWQ5Q2V6MWdIRzB6?=
 =?utf-8?B?UlZkNzNDRGlvOWdYZXdYY0RHclk1UDhXQStJY2lsRjBQK0RDeExhM0xIcTBI?=
 =?utf-8?B?UkNMQUJGdWJqRDRMMGI1VGxTZDVqL1pLbk43UVE3V3NpYi83OVJkWFVsa280?=
 =?utf-8?B?dkVFVzRvZmVvZTJ4aFpva1BDM1Rvd0hrYStOc1J2SlJQRHhCRHNjaFA0anJ3?=
 =?utf-8?B?MXpXbVpiVGd4ZkpWSkRYdFZiMlhudExJVmtsay9hdU5ocm42NmhBWHdFaWZJ?=
 =?utf-8?B?V3JEaU1Ya2lQcmloNVNIY0lkQW5XUm5OU2JSalZtMUlHRXBVdGZMMGhadnMw?=
 =?utf-8?B?aEt4NmxwRnVkcU9ueklXZ2krd1RpKzF4RXVUdFdza0hmYVM2L3dHS21STi9y?=
 =?utf-8?B?TGwrYVZPZDRONzVNZ292OGhyUDhkcGRyWlA0NForOWQzWmJ1M21YTXA3VlJW?=
 =?utf-8?B?TlhvbVFUV2xxdmxXRW4rM2s3V2kxQUR5NHY3WWpXTFlzZElHTVYzVkxPekQ2?=
 =?utf-8?B?ZjdtblFEeGFXektBQWlhSFUwcDR5djFBNHdLVmVsYnlRRkZnMUtOc0FFZGFa?=
 =?utf-8?B?NERqZnUySnBjUlJOSEJKRmVNSE1iaDR4c0pwK2hGUTd2cDAxVW1jZ3V0WXlI?=
 =?utf-8?B?OTVBNmdjZVpxSjE3Z09USnF5cjUvOEIzdkhtS09iYjNicjhSSmZ5MThVbnJh?=
 =?utf-8?B?WFcrNmtKYVNPaVZ4VUp5bUFHVkNBSHZXMzk4eThTNGdrMnowRzR2akxyY1RD?=
 =?utf-8?B?ZXdGUE1uaTFJL2F3ZDZYbGl3amN5K2NVZlhibjkzeG1GNkh2M3FBMzlTbEFw?=
 =?utf-8?B?aUwzRmlNM3JId3FYZ3c4T3hWVHdTTmI5YjJQUWxBSzMyOXVHSTg1cWs4eWtz?=
 =?utf-8?B?YVBNU0NHUWVDdE9Ydlpla2RmVFQwbTJqZ0F2ZzBieHc3L2RiMG1ZYit0ZTVU?=
 =?utf-8?B?dlZNUkVuSkFDZ213SEZsU1pqT3RRanc4RFBJYUM2VUF1T1c4emZiL2lqS3Q3?=
 =?utf-8?B?QWlPQkF2RUJmR3NyQ1RRV0FnRXc4alhnYi9KM1pueXVSQUNuTmRuY2xtbWpm?=
 =?utf-8?B?U1o3L29rTlBMMzBYcVFmSVhZT3g5NkdjS2lJVjl5YTlEUW0xSjN6cDRBL2t6?=
 =?utf-8?Q?dlkoQQiU5bO/u?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(376005)(36860700004)(1800799015)(7416005)(82310400017);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2024 15:20:30.7794
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f7fa4c7-c5ea-4c04-e206-08dc7c050cb7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB51.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6855

On Thu, 23 May 2024 15:12:42 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.218 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 May 2024 13:03:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.218-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.10:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    61 tests:	61 pass, 0 fail

Linux version:	5.10.218-rc1-gbc8c5267b8b7
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
