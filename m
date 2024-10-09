Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2065.outbound.protection.outlook.com [40.107.94.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD1E01A0BFA
	for <patches@lists.linux.dev>; Wed,  9 Oct 2024 14:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728485962; cv=fail; b=HJ9/CI7/NCMg9fcz6c6LTiq3xkW8unUM1ac1dTn93UhjO+vT6AsMe3kaDUuh8tQj8T65EiZ1syDgkXpIwtPyPAv0dHsKKuP15l1auDeMDOxv+Is+YZQJaYLEbZKBYSCaefGN4t7Shs/gLTdMse5NLStld0IMX7UJOFGqpQHqpt0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728485962; c=relaxed/simple;
	bh=aqlmeT4N5vy5qZiV//XuBJthPATT9W0p7ICuJifGWjs=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=ZVXx92xpK++6QVGseH2r8VQsbg0d1eH1FW5HGxxlDoMj3DbM3cAUZMj2/8rk3W6JzHGtBiT9Gd4AeRb12klolEI1HFUTaSD/N4fuuPwbnSZJMDIZxet3EdTSY/MjmbLT4EA/3s4BdGvDERY6WzZ5jsvmG9WFGjikfzSuE85RsiA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=tsIZDQXc; arc=fail smtp.client-ip=40.107.94.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="tsIZDQXc"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uJ9mFgsIT47tJVMQa4mrCJsRchOg+snS2rX+1S4ScLnGepn7yQYHA+1zv0jwtgo8eE/4i6b4NCLn0zjc9B0ay5uQUFnKds0ZekdjikFR/Xrb/RIsghg6Het6FJdGkOvNqVlGJwtGxjYjGO/P6RWhSBwPL8GHitYfmIYSvW2Ru4Uxd8+62AJ6DUBZINrImVRNfcra+kAnjDMm9m3GO8Y6zNusWCd8fZh+LAe7/2TYtJVneORny98CbwR7TCr/Iq2+DYhXBWGkdR5KhpsUtF8Emqson0LJPkxagUwIl7JMpSJX7onnfk5sL/2GlakiUAgGNoHxS3Fn+6qaTcCid26HNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xdTYZ7Fkft3d5aRrcZ66k0w0W5+hLIAloQvRDw7C/2o=;
 b=a2giiKu1QDPr0UnEnIPI5fvvmX9SaQ/8h+5AYSWCqAZTqy5vreO9IOyORfOZOJYuQ7gNjF/cGUmRWMqPW6WUUoP8gZdWrWHL1ENlfD5vRT2Gj0FotTSccXSQbTEpOu6B3Cflu00pEY58eBBN0bTxu1PHtQPFhxE/MwSGghp/BEg4c2JUyCrxESd69Yi+rqZQTsSYka/n0FYyE00Dt3izAgzI1R9KwSRoqc9334l5qzGoBxZa4eJdXR4AYnIutQTpohaLZVp3Cp4kC2U1F/Lfy548MjaBHebKYMd9QLzE43sxhANo20cQksnAwlkD5O1wltZpNiGU4ce0FIP+bbSR2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xdTYZ7Fkft3d5aRrcZ66k0w0W5+hLIAloQvRDw7C/2o=;
 b=tsIZDQXc/gnOSE31ZKJyOSAom+MQ5766SzW1L6/XCt2ofdytbRrfdei3Ea7KaNHeNzXwLip2BEGmnnItzIubOXHpViZzZXtG6/EcpnqyYpyxnby8TZx78XjEIi5EBa7xhqASdTVZZRhhhQa2gfOfHkX7OMau8C4gPvZqMquRKOmZv0dJD96sTfGwIERzVXekeuQHmTkW5tjf3aVRvNwRb7g+JwFe/w6/FNKcvzoE20mGLgITSH+zI7BmioHCgDlzZolidr/oReYr265G2nT2UAmBKRK7rfUr7BPUxBHGG1CRu6da/eTp0eOBEIqlkhusTRkghW0t2vOnuDt9ux++9Q==
Received: from BN9PR03CA0074.namprd03.prod.outlook.com (2603:10b6:408:fc::19)
 by CYYPR12MB8872.namprd12.prod.outlook.com (2603:10b6:930:c8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.24; Wed, 9 Oct
 2024 14:59:11 +0000
Received: from BN3PEPF0000B36D.namprd21.prod.outlook.com
 (2603:10b6:408:fc:cafe::9b) by BN9PR03CA0074.outlook.office365.com
 (2603:10b6:408:fc::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.17 via Frontend
 Transport; Wed, 9 Oct 2024 14:59:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN3PEPF0000B36D.mail.protection.outlook.com (10.167.243.164) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8069.0 via Frontend Transport; Wed, 9 Oct 2024 14:59:11 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 9 Oct 2024
 07:58:56 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 9 Oct 2024
 07:58:55 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Wed, 9 Oct 2024 07:58:55 -0700
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
Subject: Re: [PATCH 6.10 000/482] 6.10.14-rc1 review
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <50b64beb-ba52-4238-a916-33f825c751d9@rnnvmail201.nvidia.com>
Date: Wed, 9 Oct 2024 07:58:55 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B36D:EE_|CYYPR12MB8872:EE_
X-MS-Office365-Filtering-Correlation-Id: bea51899-af3a-444a-b115-08dce872ef31
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WVZVYWFNNmo0RDcrb3B0N1hSNzR5Y3VldE41ZDhNV2N6VTh0dDF3Z3dKSEhY?=
 =?utf-8?B?ejN6WkQ1ZEp6RkxndWkwYVVQWk9pcTBsV1VRR3hybVVvN0tiTHpsMWNzWHZr?=
 =?utf-8?B?QzdNTDhpTUVROVRLajdGWjBsVWRTbWJiTSs2WUFKS3U3Q2JOMkgxYXkzSGQw?=
 =?utf-8?B?ZnhXU1hDWXdOQW9MMUFyUE5JUnAzdXBaTkZNQ2M3d2pTQmxsOEN1RzRlcHJs?=
 =?utf-8?B?enhPOENzdmxvdE5pUU1UWC9BMTk5Y0M3ekN2eERYSUlwWEp2L25DSWlzZ2pR?=
 =?utf-8?B?ZENydWFhVzNCanpnQTJaTEFrRk9vZ0YvM2xZNnBKZlVpYUNlQW8rd3pRNzlk?=
 =?utf-8?B?UnpEQ0xMMDZkSnN5cUxuRGY2ejAyamdGalc1RVEvTmVHSmdtU29jUW1WTmRL?=
 =?utf-8?B?cFhVbmc1cmVJdnQ1Q3VnTU1LRVdZa25GbjA0Y0RsRStXQ0pHZWxBNHBQUjlK?=
 =?utf-8?B?TmVtM1F3VVB4N09WZ2VFNm9XekJYUGVKVmxCbks0TjNsQXNkdzEyWU9MZVow?=
 =?utf-8?B?eVVleTdodloxa0wzUWVIbVRmTkFEQXBlY0o0bkcvc0l3a08wNk9JNHFyeFU4?=
 =?utf-8?B?MzhTOU9xbzQ1Z1lwLzVXSEhtMDk0Z0ZzcmMyeHFFUDR4L2hGUzJBNjU1UDFD?=
 =?utf-8?B?ZnQyRHVaN2cvWWxmZWFpVUd2cVZpaW5ZOCtXZ01GcGNRTW1aZDFVVko1VWF2?=
 =?utf-8?B?clhtS2VmbW43WEFURXlYOVgrTHpscFhzUkJ0R04vYkFzbGkrNXFsUUhTOFRx?=
 =?utf-8?B?Y0ZMbVNRVmxDNjFrY1hXQ2dxZ3NHeHpPNkZVMUtQR29XdFRXcHRVMUJEL1hQ?=
 =?utf-8?B?NjNzQ3d4RzV1d1BVQUtlb2hSdFA2aktZYW9wdnVpVk9mMXpXQ0tVV042RUp5?=
 =?utf-8?B?ZHRGQjBQREl0UEpacDBGWWQzS3FNNGozQzdWOFFKMFFMcXNOWFRhTURkcll0?=
 =?utf-8?B?Q09IVWRHZTlqZ0pHc2ZPa01uL2VvemhMdy9PNERGVk8ySFlmamJMSmlpUWN1?=
 =?utf-8?B?U2dLTEFzbEtGbXZDZlhIdHdYNHQ3Z1lYbkFueWFpS3J2ZElDT1QxTTRtU1pt?=
 =?utf-8?B?OStwTXhhQk1kWjhsQ3J2bUUvajdtR01OK3BNMzhHTHVSZE9tRUpEV2o1d200?=
 =?utf-8?B?QUVlOEVuTlF2RjVHUDlTamdjaUUvTWtUT0p5dmZlQUtGUUUxc3laWWJHaXJT?=
 =?utf-8?B?bkc4QVNYQ1UrMEFVSGZ5b2F1MzQrVmZGejlDYWZWd09MeXA1bTJoaXFzQWhS?=
 =?utf-8?B?SHdlWFExd0I4cG45ZGQ4a1RuaXFsTjdqS3l1N1NTcytkN3EySDVPSTZ3SHpm?=
 =?utf-8?B?SW5PQjJISUNaUzdoak1tc240Ny90RmkraHNIUUF5TXc1UW9XQWFUTFE3dmNa?=
 =?utf-8?B?OG82VjJFMUJDeTBkbEJRUThpQjBCZkR2T05LaDExUm1sWGtxTklnczZqbGRO?=
 =?utf-8?B?aW15OTRpTENEcHZvMUQ1Q2d1SkNjM0xmTUZpbERCOVN6NGlCb2hGcGQ0RnAv?=
 =?utf-8?B?T1BGWUg1ZmNBaTlIV01DVVV0RXJodk90ZWFEaFdTVXhQR3NMNkpwV3VIMDho?=
 =?utf-8?B?VnBVYm91SDFHZUUxRXVnZ3pKY1JsWS8yaG8xeVh2Q3RRUE9IQVNNTGo4SVk0?=
 =?utf-8?B?Sm1ZSDhxVnIwTG9hNTJ5aUprSnMzNlBUSzdsV2VRcjd0ZU1FL1hxS0lJelMr?=
 =?utf-8?B?eDZ6Uk5KZlg5M0pNTDBCOU84a0ZubkFORTQ4SlBma3pqdkFoTTBBLzlyNUFM?=
 =?utf-8?B?aWVkRE9lVjVXREdodlkzSXB0bkVwUVcwY01RTnpIRVA2MEhoSzRXNjVSMTJ1?=
 =?utf-8?B?bFErVEhwMDB5RUprdmFvTm1Zb2lhRFI2Tml3UWpNVzNZQlpXVm42Vy9Kbysy?=
 =?utf-8?Q?D1oRCc5pW0gv3?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2024 14:59:11.4663
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bea51899-af3a-444a-b115-08dce872ef31
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B36D.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8872

On Tue, 08 Oct 2024 14:01:03 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.10.14 release.
> There are 482 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Oct 2024 11:55:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.14-rc1.gz
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

Linux version:	6.10.14-rc1-gd44129966591
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
