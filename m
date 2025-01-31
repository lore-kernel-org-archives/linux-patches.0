Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2050.outbound.protection.outlook.com [40.107.93.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B04D418C31
	for <patches@lists.linux.dev>; Fri, 31 Jan 2025 05:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738301938; cv=fail; b=eM/1gxegM5Qm4c2LZbjCu+LWRaZed8cKfffQhnws0lNn3yEMFqsG0JzvkzGmrEy1UPKn2zi3pukWlgEkJNNvBtLhIG3oRNJ5XZMQYCYc4BaVEVTwM1jnJtYvbp0E0bR1aKXN3Y7UUT3F53IHNTlxYMUU0jrXOInzBaiTiqT5sy4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738301938; c=relaxed/simple;
	bh=EibCLfyPJVry0BKYOrtIZ8uZGs5PuyXGsNYSxCTmjo8=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=PcP+zMUiaZoJ7f+O77tNYGB/nrEzS8NjEoPocQ+u/i8ctZOLsiFcBMlKkCEu7wkW4hHMFnWHB5LS/KJUCq+YIzcxVhRi0fjFEq85o2GtlT84qpgPvA9v+DjWSYzMr91FLza+sZftU0zTwHgGVVnVz1gJEYtDTjp+8incwVQGbrE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=LZLTtaDQ; arc=fail smtp.client-ip=40.107.93.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="LZLTtaDQ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=taBhB4XQRDISAPp2HbH1+sj7Kxg+qdfelafFJVF/D0mhU8AFWmt/5r4jVArNn9t1D5p6DQSr7uQVCC7nejQ0sV7x2gfTt9ehRYZJh9B2cxDaghdh15IkRvUAfV78uKQ7q52FRaqKidiX9buwhM9U3WEJOvIj6x4SvlDwsqoF/GD229mUa++0T74xOREe1kUrMmiSDucIFfNQX1Tmf177Qgil+mb1gExVo/168RdQl1FV4E8LBDpooGE9F5dWjSosIK2Ot0TK1SyYCsVLXWoidNTXzYvqZKbHOziTrLMWI3ED/J0XHhLUWvdabcYCayOtI40RAZfJwb2kG76FIJBbkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cWf16owYbELbLZEK1keo5OlwB5zGTn6d9gKLINmOcvo=;
 b=tn8OsamsGcSU2j63CcSzTIN+8ekdJJ8rdIjJJp5Zq8yGeFuYqwKvkPp/P3u/mJFJTuI/pe03k7vsZx3fF2YolHWYQW2wFhsn9CkQdM9/y2ttjF0crXSmUpTgw5uVV3cc9cmX6f3b1vl2PynS83nEWIxrnNUeHdyIUez5TWp1c7pbUm6inE6csgQyqn3FlGWgDEgeHQ2UmcCsqGuQg5ENZl3kvrv6GHHtt64Ni1dfxUUi5T7PqVmcGeOa9A+sKO28B0JoKCV082Y6CB/6by/olrznJuD03akBbA2+IK4wxZUf2vjOSSMqee2UNzMl0nTiE3iF8ez2vokLNT5nurApUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cWf16owYbELbLZEK1keo5OlwB5zGTn6d9gKLINmOcvo=;
 b=LZLTtaDQwhR3RP9KiSuSqSIp8X6c/q7uQfWRFwZV8gi5x6nFyF3x8gv61glSwLvRJphhbuXN9EZYgPa7I5+5gckQy+aLK69Y/7P5k1a9uk+jTOvUzp5kPRx3VkCED9KYT4Dzc/IiiuMbcXB0MKtYTg1GKLOobn92yQxZuCfNHfXoZkARwxyCuusvIHfuiWUCYVw5rFyFrSQL7xVGQGFkICUozDwqzDSni+bVgaxzORUoL54Irr1Un1kMQDzlkYx+qYHDojXZ7mL1lloNWYgAFDAMp2wyy076cFv6YqUnfdgzax1yubBp0mRBOUvOU2JreLa0DRFMz6kEGehkf8OpYQ==
Received: from CH2PR03CA0026.namprd03.prod.outlook.com (2603:10b6:610:59::36)
 by DM4PR12MB5842.namprd12.prod.outlook.com (2603:10b6:8:65::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.18; Fri, 31 Jan
 2025 05:38:52 +0000
Received: from CH3PEPF00000013.namprd21.prod.outlook.com
 (2603:10b6:610:59:cafe::32) by CH2PR03CA0026.outlook.office365.com
 (2603:10b6:610:59::36) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8398.18 via Frontend Transport; Fri,
 31 Jan 2025 05:38:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CH3PEPF00000013.mail.protection.outlook.com (10.167.244.118) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8422.5 via Frontend Transport; Fri, 31 Jan 2025 05:38:52 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 30 Jan
 2025 21:38:48 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 30 Jan 2025 21:38:47 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Thu, 30 Jan 2025 21:38:47 -0800
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
Subject: Re: [PATCH 5.15 00/24] 5.15.178-rc1 review
In-Reply-To: <20250130140127.295114276@linuxfoundation.org>
References: <20250130140127.295114276@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <f2a51dd7-f973-492b-ac9e-73e8befda28c@drhqmail202.nvidia.com>
Date: Thu, 30 Jan 2025 21:38:47 -0800
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PEPF00000013:EE_|DM4PR12MB5842:EE_
X-MS-Office365-Filtering-Correlation-Id: 863bd610-b599-46e2-e6a3-08dd41b98b86
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|376014|7416014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cy93UFNpUVdJOVRTNnczN2w4YlBYMHRaREJJVlcwZExlMGFzTkZQZ3RVbEFk?=
 =?utf-8?B?TExlbmV6ZE1zZElRUTlCWUlZVzkwRHdRVHZEeEh0WXlWbEQ1VURmYlE4YlFM?=
 =?utf-8?B?YStqRUxYVjdLZzZJNVhpYWlUa2czcEg0WkloNHJ1WlNhekxuYnlwMUI1ZzR3?=
 =?utf-8?B?R3FHZ2Yva1ZPRnh4amhVcFViTlJLV3BvSGxndFg4Wi9yL2JzMDdaSGd1emVB?=
 =?utf-8?B?SWJUVHJiZm9KbWtINStFWjJhZVpnQzB5VmJqNzZWY09tclZRN29HbFdHVEtJ?=
 =?utf-8?B?YStmMW9zTGV2Y05PMVJMeC9VSm43Nkd1MEJ4Q3ZTSUhPQklqcm5aVUxvemVa?=
 =?utf-8?B?aWpBdVRZOG4zckl6K1V4emFhWFRMVjhpSGNOQU15My95Ymgzc1pNbDJmNVJE?=
 =?utf-8?B?bmc2YUg2YVZNS2xuODYvOUg1cHFNaGg2Mnpna0t2d1NlUXRPemcxd0w2ZlBz?=
 =?utf-8?B?SzB4ZTRKQ1d3d3ZkRkIzUU9hS1pGS2V3dENPWWk3M09OdmJpdkxreFAzdWtD?=
 =?utf-8?B?U0RRYzRUVUsrbFdKeEtEWkxja3FYazdPenRac1NFaVpvQlVxYkhWa3FyUGxL?=
 =?utf-8?B?RDNnZTkzNTJMM1FIdmxrUXIrUUhtMXNmK054NjhKOVA4ZzVJczlHckx3bGR5?=
 =?utf-8?B?NE5kRmFtTGRZRFNuOGcyakg4NGVKaHN6bjJlUzJzdG1UWW1vWjJ1ZWJOS1Nm?=
 =?utf-8?B?WmtFaFYzbHVoT2xZWXp0MWVvaG1jUWsvNkJ3U2lkMFd0T0JaZGJncURXNEhz?=
 =?utf-8?B?VXJ3bm42azUveWJ5ZTl4Q3RTYnpzejBjZDRqU0ttNk50Z0JkQm9wa2dMalVX?=
 =?utf-8?B?T3YybHZhc2hEQ2tOWUlYK0FaNmw2NnRyaXd6VVlIWStveW84bU5tZEtEdUVk?=
 =?utf-8?B?YVl3N2FtdmJhYVM5akZKTlVDSTd5T09xb2podVlycXFJVVlRbXl1dmw4aWdk?=
 =?utf-8?B?b2VkYXB4b0Y3Y2dIUXZGNFlmeG1FRU5MSEM4QmpmMnZ5UlFSMzYxMDBIdkVk?=
 =?utf-8?B?YmJHRmJCWFlQK2MvcW5vaE1MaWZTTzdKSk94TDM3Z3pWN0FDZi9OMk5FOUNx?=
 =?utf-8?B?TkQwcmVsdFNIb0FVK0lTckFtOUNqSGhkSzh2QlNqdGRQdDdRZXpsSVlyVkVF?=
 =?utf-8?B?QkNiWU92eWhxKzNTK2FuNkdHMlprK3hGejN3NW1XOFNLbHEraHk3UDF1SVBL?=
 =?utf-8?B?bzlEK2Y0K1o3d2ZTczE5Ukk1WWM0TFZqZEV2OGMvQ29xbnhaV1pHN3lTTzMy?=
 =?utf-8?B?MnNVMnkvczUyNDQ0eUNkUWlIL3dWWlU1RDdacTU4NTlLNUFiTFVqbUVHN0ta?=
 =?utf-8?B?ZnQ1Q3RObTFEWFBCSk92Z0VmdEx2bnQydkI4VFpHUXVscEZhVjcxQzZqeW9F?=
 =?utf-8?B?VFN3TmxwMU9nb0ozZU1jQTZnUlVEcHVOL0diWFoweUVYSXI4M1l2Q042VXYw?=
 =?utf-8?B?Q3RvQVRzRytaQ1NFUTBtbWpYdHU5NCs5L2QvQys4S2dUVjJ5dVlrQWlFM3dQ?=
 =?utf-8?B?NzN1RExxWlpxSzlCSERNclNndjFYMTl0MCtvb3dGR1o2MkJuTEV2S2NFRVM4?=
 =?utf-8?B?eEplUWhuM0p0SmVuUUlVUE5PVzVMZldlTHMyNmtsRzQvRVdhaTg4SXdCWjNj?=
 =?utf-8?B?bnU0VUVCNFN1YlRHdlM1T1ptWStDWFVlVWk0UFZEbHZVUGRUdkpRNHFTNnNa?=
 =?utf-8?B?N3c4dDNZRy9NTGlxV0tCUGhlVys1NmRlZnNKZE9LdjVjYnJ1eDdMSG1CanN1?=
 =?utf-8?B?Q0lMWFVwOUR4a2ZnQVpHODdGaWpGK1RTUm1QU1NJT1RFY0p3ZE0vMi9TMStX?=
 =?utf-8?B?V3pGVlFEMDBib2M2TENpczVSZlhyUDU3Rk4wTW02R3BhcGN5Q3o1anhvTFRZ?=
 =?utf-8?B?dXpGd0xiSC9yUThPdlNNUDUweGZKVHY1OFptaUVyQnU4M3hJaUFQdHlrVmNO?=
 =?utf-8?B?aDJXZzVFWlpoWm9MMldjQTN6M1BvTzlXMllZQkxVMVRKTWUrUmhXOTJmd0NB?=
 =?utf-8?Q?rAZkjkj/8dLMDz+EKUgJNAAoCdLTy0=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(376014)(7416014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2025 05:38:52.0701
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 863bd610-b599-46e2-e6a3-08dd41b98b86
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00000013.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5842

On Thu, 30 Jan 2025 15:01:52 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.178 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 01 Feb 2025 14:01:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.178-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.15:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    101 tests:	101 pass, 0 fail

Linux version:	5.15.178-rc1-gcd260dae49a3
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
