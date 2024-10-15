Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2064.outbound.protection.outlook.com [40.107.101.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB8AF185920
	for <patches@lists.linux.dev>; Tue, 15 Oct 2024 06:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728972485; cv=fail; b=hezP91zc1PFS9XhMxO/XQSYbOrfqR0yM3KTh/pOyqDN9rec8oBwl9fkg0aWiXGyEx92vmaitEgwzjy1efRWbf8ex6tUWs2m/GYNpbhJtSsH8HME2toUaCrzk+ImbbRyX4spn1SisI8nAgFHARjyXvqEPrkEY7L3QMbJ+CxD5SkI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728972485; c=relaxed/simple;
	bh=6rnQ0I60jnOqGc9FQHaMJEnMutdhkhPv0gxCeOiTv18=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=nte7usv/3WV9ZS3gwKWgdxrKMR82BQcdYc69UgQfA0B+h/wS8xgfuq7wFRiIIuvdyepLyKecBX3i42myO7k2Jg7olNUQTnwxqoD2DdWqQaoUYcPFUwBVppjEvGIS7jG79f6Lan3FkbEuDfI4XtJ9JP8iDqYfqA/53xZ7v9oaPho=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=fmznJw9X; arc=fail smtp.client-ip=40.107.101.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="fmznJw9X"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h4qXNoiuysImoisQX/BYn8lURn1GwhMyoeIC4Mq1FXFd+/cSQGIzfwAZWfcL44mryEZtvaYx3d3L3U7DfDFQKQL3eI4+B9s2h2wUEza2f3f+JmCMQ/LxubBpJOUVYdLnrw+H9x+Z999oSwRL5lhYajc2eV+9MgRyIQJY9hgsauiOr2eKdaWlrngoJsafikkv+ojN+NztzS81hO6Y5pzam9Ph/X+oUHD0VLv1rTAHx9lofuzy4QEbVBXvpBB4H5XRqRLW0LY6IUdHtaB9Hr52nFyfKlDx5Z5k6ZPLLOJf0XWlOJAfS+oFEVpOopuRVugE6dHEZLYzcdVlFeMYDY+pyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PtT9+wjuOmc8f/Q9byRfZmHurO5Bebc928sTxgJ/kZs=;
 b=paW5xQjLKf7hWy37y/PYpggQCwVgPBca/DV50zWE/ety/6A9Y94jmK6vXCzX+hRO/T3CHjhO1Qa3drUh7nR/Rc08wfHHp2gBh14/ZdS3rdkW6m0Lvb7N7rKc7cA0edT89OQdvsKdm8rebPJp/FActZNOjUX8k3tkXAX8Yn2YUQbYznV2w287WinHNk4cpfYwr8OQQqPAnLFmNdtvY31sTtLeJ7HkvIYCSukHS7KTjNJD5fodMbWEpWGvJOUG4xY2XLkiFVoDm05brsDJl2gTjwRuE0hSK67Kzv7k9FbqSfPVmOdJjz+lmnOqhqsdnKmvziDj/NVa0yDW/bkUaeAsbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PtT9+wjuOmc8f/Q9byRfZmHurO5Bebc928sTxgJ/kZs=;
 b=fmznJw9X8YfUc6sNsmHLCgqj94jPPpEez4fbR9aLOqkVWCuhstA5PFzmpkQs/enHLl6bOpiyGdRMxwI89OH/qd8HcjJMzf1VVW8rkZir52L05QedgHf+95/PWdQEtec/I7jjHaQI4HvTzjc8/yifUx8C7KjDJevWrItqnCUG/3PjxYxCOFoRx3/lKFN3JrkWyZFs1amlprB3mGPGtmpxpq1bdQ/WR83HXhKs30Dvvs9XHiCL2U+AZkzqqeXUPGH7IncCn3Z8Ejrt2Kv848DnAFdQ0MRQ+MtubTxhbOd73fCP75sV8+4W8dU4c5kv9QegEkhDD4/F4EBHA58XpxFB8A==
Received: from MW4P220CA0024.NAMP220.PROD.OUTLOOK.COM (2603:10b6:303:115::29)
 by CY8PR12MB7682.namprd12.prod.outlook.com (2603:10b6:930:85::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.27; Tue, 15 Oct
 2024 06:07:59 +0000
Received: from SJ5PEPF000001CA.namprd05.prod.outlook.com
 (2603:10b6:303:115:cafe::76) by MW4P220CA0024.outlook.office365.com
 (2603:10b6:303:115::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.26 via Frontend
 Transport; Tue, 15 Oct 2024 06:07:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SJ5PEPF000001CA.mail.protection.outlook.com (10.167.242.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8069.17 via Frontend Transport; Tue, 15 Oct 2024 06:07:59 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 14 Oct
 2024 23:07:50 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Mon, 14 Oct 2024 23:07:50 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Mon, 14 Oct 2024 23:07:50 -0700
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
Subject: Re: [PATCH 6.6 000/213] 6.6.57-rc1 review
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <6c4b417e-e5ed-4f16-91a0-3063f45de716@drhqmail202.nvidia.com>
Date: Mon, 14 Oct 2024 23:07:50 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001CA:EE_|CY8PR12MB7682:EE_
X-MS-Office365-Filtering-Correlation-Id: c59ad78d-a62b-4c2b-9577-08dcecdfb846
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|1800799024|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZHA2bGJ4Qjd2RElidVVZbkxiWjdNc0VsUEpBaXBUeWtqY3lmeC9HUDQ2WXNO?=
 =?utf-8?B?WjFsaVQ0YzZEa1V3R216U2RyYTU0eWVoRTgyVTUyK1lweHl2TzRsRVF4NTRo?=
 =?utf-8?B?QlRUTmNhYytWdW5IYTVSWTB0N3ArNjhOMkhVaFVCa3dhZWx1TVFzS2tQUVA2?=
 =?utf-8?B?Snp6QzhlSTlWUTVnemZWYm1hMEF2S3NmSTF3TDFiSUJEY01lcStlenZBNVFk?=
 =?utf-8?B?aUtLNXFXc3dSN3B4d2Y0Z2UyOStwUmRGRzFmWHZFcmN0NzZ1WkhCMkhSdjNl?=
 =?utf-8?B?aXZLS1F6eXFuQTg4RXp1U0l2QjI3azIvdHFMYXJ1RnJiSDBGamJPSmFSMUdG?=
 =?utf-8?B?Tmw0TnBiQ2FvQ3kyNEErTTNoMW5TdGZmMHFZWE81NEJ1QlI1SnZ5WUw4VTNS?=
 =?utf-8?B?T3FLQU45Z1Y3VXdEem9mM09tTGFpMVpOSXdZRWJhZ041Z3lyWGlOQWNMU1N3?=
 =?utf-8?B?WHhRMkFUemJpOTVRbW9IMEFJaUk0Lzl1ZjdOaDFYV1N2Q3ZPdWljK1RkM0F1?=
 =?utf-8?B?UEFwelJiTjZFOXhwRmMybFNub1dHcFhPUXNZUVdWL2NzTEVVSWhrQmtrY2pO?=
 =?utf-8?B?NVlYQittaEZqZ0tYK2lFeERDRDNTY0Fic0pDTkExMnFPWGoxU3ljZ1V0Y013?=
 =?utf-8?B?THV1bUcwMHRIYUFvcDhHOUlQVmt1R0xCSmx3UGZudzlOcFJIdXRoR2tCeEtz?=
 =?utf-8?B?M0t4T05kUjl4NDFidE1UVTVmYmF0Q2p1TUdzb0c5elhFMEV0MjRGcTJVcGdT?=
 =?utf-8?B?MmJUdDhhQTFiTVRZQVFYZWNaUDJ0Q050U2hacnZNb2ZuQ0oydmtoMmZQdXRW?=
 =?utf-8?B?UlRLdFllbmRidlRjckROVTQ3bkNrSWN0WS9TUlArakNpSUFEcWplMEJjMW9n?=
 =?utf-8?B?cHlGWkNyQnVrS25OREdFY2hjZ0xyZEwyNFg5VmJ4NUpFbjdHaEJPUU1MSUU3?=
 =?utf-8?B?S2VoQ3JmcFcvbWdIK1Q3M28yUHRSbi9lakNJTWRJTlZKWGJyNk5RcEJiZlcy?=
 =?utf-8?B?dVV4MFFLSUFRMnRhQ3VnSE9aQ0hRYk9qQlRqbHAvNm9halBJeERnRC93WVpO?=
 =?utf-8?B?c2cvUEg4dmdRdmg5VmN5aE5PMHJ1RkJJM1lmbVVrOEZJN1AvQ2Ewb0haeTdC?=
 =?utf-8?B?MDVqc3R5U05Yd0RianhmZGRVRmwwajg2bmozR0g2OWVwd1JsWEpCTTJmcklu?=
 =?utf-8?B?NGNmWmRUeFI0VDJCRzdwMFJ0TjdaVnpUUmpBUTluR2JnMEdxSGxwVUxWa3BC?=
 =?utf-8?B?NlpHOG9HVWVsbnZ4andadkJuYlZKN0NiVjZsYlYvM0R2R2xqOXorMW02S0RZ?=
 =?utf-8?B?Tm5SR3FuZGFuOGtVdGlPV3EzOTluS0pEeWw1K3JZeTlYT21YR1hvNUl0TmNU?=
 =?utf-8?B?Y3JOczRpTjN5R2FuRGFhdmVGamg2OE9xYnJrbnpjVHNiMU5JaU5CdVZrazBQ?=
 =?utf-8?B?UTVtUDhiSkJ4eWFuWDIxZ2dvdXA0UGJHb3ZSMXFPU1lsbk5zMUdrUDNJVGNw?=
 =?utf-8?B?ZU1WcEY2aElvTGNSSUhhcUdwODYzK3NvWC85ZFd1dTVWL2QyMW41NThrSnAv?=
 =?utf-8?B?S2Q5QzFQWm40eDBSK1pWTUhlcU1BdmlxZW1hV3hTZDJEaGJkV2JmcWorTVBV?=
 =?utf-8?B?ZUE5aEVsOGVnM1ZjOVNaWE1uY0RkYXNxNXZHdEJrWE56NXFjSXZOeUd3eitI?=
 =?utf-8?B?TjdjSWdBWTZIYnYwdkZ3ODB4NDlmSnkwSFA1ZVpHUmo4Q3NzSFZzb0JUb1pQ?=
 =?utf-8?B?Smc1VXhDc0NHYUkxQkRLWjBtMWVsZHh2L3RybE56SmtiK0tYcjUydDIreUow?=
 =?utf-8?B?Vk9rTlNQOVQ2NkVHU0lRQXlnRHdXQzFIOStpWXdWdXRrdE9QTkdkcnhjaWRL?=
 =?utf-8?Q?DbeOiNb6nWjIO?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(376014)(1800799024)(7416014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2024 06:07:59.2950
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c59ad78d-a62b-4c2b-9577-08dcecdfb846
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001CA.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7682

On Mon, 14 Oct 2024 16:18:26 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.57 release.
> There are 213 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Oct 2024 14:09:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.57-rc1.gz
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
    26 boots:	26 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.6.57-rc1-g8a7bf87a1018
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
