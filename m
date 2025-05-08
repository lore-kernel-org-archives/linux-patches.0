Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2071.outbound.protection.outlook.com [40.107.244.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2A8F2857FD
	for <patches@lists.linux.dev>; Thu,  8 May 2025 17:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746726116; cv=fail; b=ZhD4XAH9qnGx0j01OLlxMkaTP97SbTSZ4zE6zAYmOGgeDKnYh4hjqYf22ETNNB4cFmMKC+auYav9dKKty/0qHg746LsbQtPYldtKDKeRn9CsbrjRtj4BopmgqHCIueohqmrjG7GOPe+wQmY/4stJZhxyqkMEDkypT2fgNDx80Q4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746726116; c=relaxed/simple;
	bh=12VAo1Dby3D5PcMW/Gag0xt0r+v3UZqGLmX6fHDuFsE=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=d3qqOllZworZ7T0SU63iI+RuIY5GTOXnVR/cREpR9RMs1KbmmzwnGumWIg4tmozELNET+Qo/47c9Jgd8XADllro+JPQZa0yfqE/vwFef06I2F/GY1YluSyDhB9obs9vII8nIVQUQ/m9ImSFmvikjGTukjmn5D1Bw++MoqUEkMCw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=JgK11ybR; arc=fail smtp.client-ip=40.107.244.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="JgK11ybR"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YJE8taBkLzAEVILFkEs2dH8RZ+CK//k+bNtUVwSuQSmI3EbC3gq9eVkiovrJGrvfnYTilXV+L3J+J0SMIuFM1mKpjEGUDQXviHRkygiZX/OfY1bJsDXHIHfIHN9Kq87puImXN5D4153onE62rplLnGf0qm38TecdBMXQhsQQMj2F367DOgF0zL38OAxRdQbww9SShOqL1N0qQmMtIpA6MV8+7AvaZ6c4CNbK6D/DLi2NOH7zDXeHWGQjgVQWO8Of2mCKdqZu/248Qt6f0FhZWL35xcJOl1rcJJzqMg7a68rR3+QGTGMaNBUs4fBoPEmsz/mizI33W3f78MuYsHBuZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p329AFDNqhg1JD6DSwCEyyGfhBsxxQzBzJnnenP7xLM=;
 b=zLh0IR7KJusS2F6gLRcg/Ju2bsTEYhn2NYj58nwxySSjmWmoQwphsHIbokXd7QI39nDa8M2/nDzfpdDGgCVGfRbGRao0K2eTWMzJkfhBsJScdeA2DFs0bDN6SfLlRlETULLVradY+AYcjtMtQ8EnpLR7zbmoG+XG+3l7u9JTflbFOB/kgxDoozV4v+aFxMep8AqxthQWyuoZ86tJqbitou3QQzgicPQH3vcxwNsQ3I5/VlrhR4q7Z1QN/9DYBdbfKzoI1NiDqwygsjcS8kIDHL59MTXfXIHE2e0WMqpxRfoxhXIrphrSeMXU8o49g858PafqF34sy/aHXOZCOjHWgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p329AFDNqhg1JD6DSwCEyyGfhBsxxQzBzJnnenP7xLM=;
 b=JgK11ybR83fB0WzfTMsmlpPxahFa4TJ5lOZZpvnf73joPUZahzb4d7j4el6yHe/NkqGdkk3UFVTKRnnAytwqno8NewlpkgLv+T1hztwng4e/3VT/YArNAp96CZotLJ4Z2HEvjmqXQZZcW9APf6T8/0c9IEX/MXE2qegFDodjO4zLMIvpuDXRUVmdwg7HDCcXab35AfS99MLJ/PheIzJw1wvMQWn8ZSaPNM7VtP9Hqj23Q0hV+1IqtMkoN9zD0TILZRx41IxBWA+Xq3xBW4W6FjUPrECqWwhJuvA4/mrsyjfd0LW+w8GQ9BYP5eNo7g0QDVNdC3Dr9+Ybwh5fcKZhdQ==
Received: from DS7P220CA0068.NAMP220.PROD.OUTLOOK.COM (2603:10b6:8:224::23) by
 SJ5PPF3487F9737.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::990) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.31; Thu, 8 May
 2025 17:41:47 +0000
Received: from DS2PEPF00003442.namprd04.prod.outlook.com
 (2603:10b6:8:224:cafe::29) by DS7P220CA0068.outlook.office365.com
 (2603:10b6:8:224::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8699.31 via Frontend Transport; Thu,
 8 May 2025 17:41:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS2PEPF00003442.mail.protection.outlook.com (10.167.17.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8722.18 via Frontend Transport; Thu, 8 May 2025 17:41:46 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 8 May 2025
 10:41:34 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Thu, 8 May
 2025 10:41:33 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Thu, 8 May 2025 10:41:33 -0700
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
Subject: Re: [PATCH 6.1 00/97] 6.1.138-rc2 review
In-Reply-To: <20250508112609.711621924@linuxfoundation.org>
References: <20250508112609.711621924@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <3af2bcb4-f08f-4645-97a6-7fa05bb9c69e@rnnvmail204.nvidia.com>
Date: Thu, 8 May 2025 10:41:33 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF00003442:EE_|SJ5PPF3487F9737:EE_
X-MS-Office365-Filtering-Correlation-Id: e6b89ce5-496f-42b5-ba55-08dd8e579af9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|376014|1800799024|7416014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dWdPZ0Y5SDVMTFp3ZzFIT3BRRTJmeXdEeTd5dm5FQnV0S3BQd1B1aUhaZklQ?=
 =?utf-8?B?bkNHU05uaktGZ1luTkNpdWV6WHhnc0hUTHVNV1Z4RHhQSDVDNkRJSEs5QzJL?=
 =?utf-8?B?K0NyczRDRVpTeEQ0U2pVYTB0cThCRG1EM1JNVDNCZmZUd3V2dzlRTk9SRURO?=
 =?utf-8?B?Zlg0ekxTQ2hSN3d1VU14VGU5S0V0amkvcXd6QlRuTXZ1eStMQ1BiSDlzeWNn?=
 =?utf-8?B?bFY1TXZoai9ycDBlNUpDeTE0K1NZV3pYN0NPVGZrSU9YZnhuWm03L2lHTzhk?=
 =?utf-8?B?cXpsUUxDNnAydnRqSmRSaDRJbmFBU1pjdWNIQ2x0NFJobmJSQVp3QUczTEJO?=
 =?utf-8?B?ZnY3MkdWSDNMOWZFZDExeTg2UXl6Sk1Md3gxQmQwN3VoMVUwQ05ia29BLzVH?=
 =?utf-8?B?NHBUMnA1QVZoMERyZE1JbWV0SXo1N0ZUbCtNNEJSV3RUMWNXd3QwSjRzT0t3?=
 =?utf-8?B?TytUMU5RTTErZVVSTmtESGo5QXNkMndjTUVCeWFBMHU0bXRIY09TOEZpaEdH?=
 =?utf-8?B?TStSTUlSZDQwcnE5anF4QXhCUjE0UlJGZXB3dmwxWnh5Z2VOTWwvdURoZm5n?=
 =?utf-8?B?dG1UVUMyTCt6ODRlMnIvQkhKaG1wZkdnQ0pkanEwTFowbGNmUGExVm56NXRa?=
 =?utf-8?B?am91TWI5YnA5bWxUNXd3M0F0UXNDMHU1bTdMVFpKa3hWaGxYYXNYSy9uUlJB?=
 =?utf-8?B?VEd6RHowNUphQjQ1cjNQR0FRRU5ybWhLaFZOc0JqdzhUZGRoQnYzaHVvVzRT?=
 =?utf-8?B?NUVPYU81bnRpbUJBQ01LS3ZuTHVITVhiNmJ0NjVUWXhZNFJKL2Rzd2w0UWRW?=
 =?utf-8?B?NldscTMyTGVPNVBDRExBNWtpUEZ2S3N5cUI3OFVGM1l4bCtzZnUwaCtVZXRt?=
 =?utf-8?B?RGwyamw5VnZMbEYrYmhTd2FVN1B3U2dUU0xuZUhhVStRYXZUbkpJTzVONDl4?=
 =?utf-8?B?V09FR1kzOUtNUE00amJPZlY2WVVHNm91dXdOay9EQzJEZEpBSTVyeUV0cXRQ?=
 =?utf-8?B?M01FS01zNHFMb3h5bkxKbWtVdmpJNkR3WndjTGFybm5XbDJuR0tvZURBZ3Mz?=
 =?utf-8?B?YTRINk1lT0wyVTI1YTBEVW9qb1V6bFVtcDB2MThxY00xV0drSnhoT1RoaXFZ?=
 =?utf-8?B?MUxZY0pVL1U4T1lWUW9pL1I3U25DL3MxL1ZEZlI5K0E3SVgxN2crLzdTK20z?=
 =?utf-8?B?c0x6cTBFU2NyM0RTaWhlOUtyU1I4dmQ5dWpBdHk0bXl0dit0aDlYNVExZnoz?=
 =?utf-8?B?MXZtRFNrTW9nTmhvNktmVDI0N1FUTDFxQVd4RXVnc09sNkNBRTZGRDNMTm5S?=
 =?utf-8?B?dGFDR3ZPa0RTZk5EL3B3bkJsRmljSEJaOEhkRjNXQkMwemZnRFF3SklRaWp5?=
 =?utf-8?B?ZmZyZ0xNQzJxQXR2a3V3NWFhUGZrMW5GYUpRK0c2Q0doRGdMUXN1SUh3cDI1?=
 =?utf-8?B?SGJtaWt3WnFPdGE1T0VDWWlvZkcwaDVWaEw3UERjeVpRV1dLZFJFVktpN1N4?=
 =?utf-8?B?MzVPcWxFNzFVZHl6WGlweG5aT2RzVHJUcjlJbWlJa3ZxekE4ZjIwcnZ2Mmgx?=
 =?utf-8?B?Y2ZQNG1FdjgraGg1V0dlRlhNcXNNeGJ4eWtTSU5mWjBtbm43TnVWdU02eWl1?=
 =?utf-8?B?TlNsOG5vWklGOEtnb1kvMDh3KzVDZVZYWVZyRnFuc1J3K0ZpSGkrY2xmTEN0?=
 =?utf-8?B?M2NpMlNkZVM5MVoxdFlIZVZQLzVyTk1SRmo1Q2NxK1FaRW9RYjFNbHVIUVZN?=
 =?utf-8?B?d1VVMi96WGdsV3B4WWRQa0Y0OWM1cFIvMzhZaDN2bUc3M3phalRSLzhpd2pT?=
 =?utf-8?B?aTVJWldzcUVrODgyMnU1c2FINDl5S1JST01BUzY5Zmk5bEZ2N3dpWE56Y2Zr?=
 =?utf-8?B?TE9SQmZibjd6d2p5dDhKbFB3U1Y3Qmt4MjhyUmhQYWNQQnJlTXpBZGxyeGNy?=
 =?utf-8?B?OFRleE14eGJqWWxBM0w3WDJUcWJONmhxeWRBbXZMNFRCNFU3bC8vNXVqSE1i?=
 =?utf-8?B?Y2FuWGJ4Tm5yMGpweWJSZmw5RmQycUp3RVRIT1lrYy9oMVVVdkVJdm9PeVpT?=
 =?utf-8?B?cXJzb1JVUkxMSVlCS1Y5bGk1RnFTbm92THlYUT09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(376014)(1800799024)(7416014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2025 17:41:46.8265
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e6b89ce5-496f-42b5-ba55-08dd8e579af9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF00003442.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF3487F9737

On Thu, 08 May 2025 13:30:23 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.138 release.
> There are 97 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 10 May 2025 11:25:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.138-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.1:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    115 tests:	115 pass, 0 fail

Linux version:	6.1.138-rc2-g7b2996f52bc8
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
