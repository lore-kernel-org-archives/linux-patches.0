Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2077.outbound.protection.outlook.com [40.107.236.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 380C11F3BB9
	for <patches@lists.linux.dev>; Wed, 26 Mar 2025 15:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743002905; cv=fail; b=bJ85+ryeB8F4lVSKLy5A3NjL7YnXP53sJgAUZpNRGkbz4pkxlwbtAQA6jUmov9VrGVP9myW6UI7nAnkld3mFWYzA4sPC5HNB2NCePSOLnzhNbKV0sJjpL3cXkkToQo7fgWjvWlLKYspL/WHwHl/Ou6wX/NUfzxeAIPxsFq8Ap5g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743002905; c=relaxed/simple;
	bh=3KSryb9hDaYyaP4W3qFZXy+K3aqDopEkKZjDNmNdVhA=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=mJ4fGhLDwPBfaM1JY2Nk2s9LCxUeHOQJfSHFknbjtyfCqCPaE4fXc3ixG6yFB+rBt3HXbv9YaCMWJYoALgPGZhTRzFiH9m5I04yPubHOZfN86oFpIISSnCZfMosRQ+j7Sd0VbtDUv+AHBWYTJJVKbgviB4GDYXMPx+Gd5ZM6CCs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=QQ7O7xJg; arc=fail smtp.client-ip=40.107.236.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="QQ7O7xJg"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LAhM0ZESpOtl7XASeR+t356DGvhGrZWwmh71KE7AH6ZJfFGiscnczbo8cVN2unRL9+Onfyco/I41b3ZFfMM3K9mPtk9t1ABXFd8PGg8WUKPo9OmKQr1tofDrlPxx80U6Wp6wgptieaYXBKgJgLEVSZoV6n0fJ4yTN/KgyYLspD7V6/CLyjPgv2E3SCidOj56GaLX6zn/XM1kt3c90cjb3rnJdD+FFyo92p0boM+WhhFxPOkdspMxt4JyY67a2eus/6IwiGp8tCQPP+JAJJ9tCS9XuG/Pl/6VFKytNLgDy6MxvxOuJsFx9MYbIOey+RR9U6UaNSn04pZDR4FXWKkzZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8mSpvjfeMUtsKKwNxI+JB9hzgTehgTHRcLIKK4rmVfU=;
 b=wFwa4yjI9MgJBuwk5eiXuiyHg7MOBKB+hODWAwqOwuGmAGEk98O5K0i96R/mcvdgEsYKIcLfM0AdOlVkVDWpQOE6mL/pkU0KSxzmo/hAxV9p15GAeQc6pjcSwM+g5rJMu1xr3sX3w7+H2+zLxcsYd+9gDxFqj4NAH1jSeAD7v/cRzaB5oqQDaF/Qhi8D4AbiSxNuAMwqRHQV+AahnkWx0VGk8ElgZlWqffXYJwifzNHUDp20bDFOpWiRdM2nC4ILOZ5erIY16EqZDzXEYisn5XEhyfnIHoty94Umlg3XkwgVdlfV6SQ6ogxYFf5C2amjStHisIG7fY4t9ShyBVpUTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8mSpvjfeMUtsKKwNxI+JB9hzgTehgTHRcLIKK4rmVfU=;
 b=QQ7O7xJgX+n8dIls3ABJrfU5ICX5Q+3Fe0UF0L1bMBO8jE6vLh+ohU84I7tQXYhp1qnHbR6bB26DNecceQdG/FKJAkH8MScEZxukyvArCI/hxtzFIRqledl09ixMPHVrqhRqPLELsJg11h5WmOkkcRsNUUvC2mGELWsAhFsN5ZfQ0BrPSrsdCylTCQ+1Xix9UhglItqlrL2PGIl9IH3y8WhIOgq7irUVDF6sadRxRoDw6aJLIHSD5DEYchKcJC39Ple3Vspyew4I7nMo60nOLkVyrff3OvqwfwhdDFnVxVEc6qWSd8xfOWWOaVQxIXvYWAIFbQICDElqQb/w1ZXiOQ==
Received: from SJ0PR05CA0083.namprd05.prod.outlook.com (2603:10b6:a03:332::28)
 by LV3PR12MB9353.namprd12.prod.outlook.com (2603:10b6:408:21b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Wed, 26 Mar
 2025 15:28:19 +0000
Received: from CO1PEPF000066EC.namprd05.prod.outlook.com
 (2603:10b6:a03:332:cafe::c0) by SJ0PR05CA0083.outlook.office365.com
 (2603:10b6:a03:332::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8583.26 via Frontend Transport; Wed,
 26 Mar 2025 15:28:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CO1PEPF000066EC.mail.protection.outlook.com (10.167.249.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8534.20 via Frontend Transport; Wed, 26 Mar 2025 15:28:18 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 26 Mar
 2025 08:28:04 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 26 Mar 2025 08:28:03 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 26 Mar 2025 08:28:03 -0700
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
Subject: Re: [PATCH 6.13 000/119] 6.13.9-rc1 review
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
References: <20250325122149.058346343@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <c97b0f39-5e2e-49e3-814a-58a02d855213@drhqmail202.nvidia.com>
Date: Wed, 26 Mar 2025 08:28:03 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000066EC:EE_|LV3PR12MB9353:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b734449-40c5-4fc2-15ac-08dd6c7ad5c7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|7416014|376014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MnBYR1R0ZXJuZXA4aEFHVDgvYXdGaWNHN2xycUR6NTZtN3F0Zk5rMkhHWkJU?=
 =?utf-8?B?TllxU0xqSnEyVmZTZFZJNVNKamtDd0hlZGtpUm4xWmJWRG1OaHdnWU9kMWxy?=
 =?utf-8?B?UGxNNEZ6Z0piOWxzZU12bFYwMzFZOFdPbS90d2hnMzl4K1VMa0EwZWg2Y1V3?=
 =?utf-8?B?STNySTNBMWpKVTJJWkpKRUJ4ZTVjU1A4Yi95dmdnMko2TS9RL3ZqL1hlVFlK?=
 =?utf-8?B?dnVTT0tvTTR6TGpQN3J2YXR1NjBqWVBodmtHbnNkNkY0eHFCWmRpblRxcFd6?=
 =?utf-8?B?bWpnMkxEK1F5K2lYaWxxR1FteDU2R1dRY01zVUgzMmxta0N0a2lOT1oweTBm?=
 =?utf-8?B?Sll1UFppWEo4eTNoZTY5MGpGR0N3a0ZtZ3B5SmI0RE9XTUNVTUR0WlIyRys0?=
 =?utf-8?B?TEI5NWxtdUJvY3FOeGxzem9kQXhUcnRhanVZYVV3RWlMcFljdCtxeHcwaDRj?=
 =?utf-8?B?d2pzNUtYbk9hZDJqd2hsRWRmWWR0Qnl5Wjg0bFBaeTRUdFBENW9BYVhBNi9E?=
 =?utf-8?B?WEsxaUhWRFpXK01Pdmd2RVZvSTBHTytnZFVkQ1Y5NjhHL1lkdXZXN3B2bmFQ?=
 =?utf-8?B?WlQxQURGWlNrOTFpZWFPeWNnLzhPZnVNVWFXWWdUVGpKNEJPNjB3R1JDamor?=
 =?utf-8?B?WCtCR1BRTXRuNlh5SGNnWkVVVkVTMk5lRDBGNzdKcU1tbjNHVWpCQ3FzMTdt?=
 =?utf-8?B?d3FvSWJUdm8rMEF2c0x6MytzQzJ1cnFMT3FxYVVkM3ZGdGkzSkZMRmt3ZXRI?=
 =?utf-8?B?bGprT240NHNveUUwK2VzSEJvR2g3U01MREd2ellkUzR0Y2RVMG1HQXp4a1Bq?=
 =?utf-8?B?WWxQRnI5ZHE2NFAwWUkvRGtrLzY1Vkd4aWRUZFEwbzVHNERoRFVhQ0FpSnIx?=
 =?utf-8?B?UG12YzRiZURUSzVsZUpjYzB5SHNXZXJlb1QwaExVbGZEU01lQmlnbGlZM1RP?=
 =?utf-8?B?VTBtdmhBV0JHM1NFN0tpS1MwQi9Fa2d5dEdUODZoT1Y0WnV6ZFdaVjZqaVZP?=
 =?utf-8?B?d3lVdDJ1d1JuVFJ3Qlg5ZzVrT0dMRWFGYjNFek5aeG9uZDdyM05XcFF2ZmhS?=
 =?utf-8?B?NWxCRDhoTWJ1OEhLbTAxbGM2bGFMVXVRcUFJT2xFK3pvWTJva1N1OW4yQnlT?=
 =?utf-8?B?VXBWNXFFWlZrL2Q4bWNvWGRDWUdMR0syZkM0V1hXdXN2UHN6MHlCZHZKQjJ5?=
 =?utf-8?B?WHkxQzlYbjNZVjBGOTl3dnFCSFhFbjRNV2M2WllHUkFnS2pEVk41NlN2WlFU?=
 =?utf-8?B?R1NaYWVKczM2ejlGM1hXdlhhMTYxbUNRZGpKcVdORE5PS2t4cHd0c2RIalhM?=
 =?utf-8?B?WWlYM3FaeFhMK1RFbGdIUTVQWWVGaDJuRTl2LzRUSUhZN1ZFVDIyWlJRT29M?=
 =?utf-8?B?MGc1TC9rRUdza1FDbEtSWTk1UkdLN0NIeElCWVNjSVp4SHhaWDVJSXJBK3A3?=
 =?utf-8?B?eU1WSlo0MXVVUXhZS0VFMkQrSTEwZjRTQTVta3E4bU8zbHFDL3BybU9GcVBV?=
 =?utf-8?B?Y3duOENxeFd4RC9uRTE0emJhZGZ6d2loYWgrZm9nZDk2QnJCbklXMFNYWFdT?=
 =?utf-8?B?eHZkd2tqT0xUeHVaRkk1NjBEUTY2K0Z5OE5Ndkt1eGg5QVVvTDZLb0ZIUFNn?=
 =?utf-8?B?U1VFdlRZVmE4L0k3eWdyTnVhcTBzT3Fra09aOGI1UDlneDM2N0JkUFhxY0pi?=
 =?utf-8?B?U081WGtJY2d6cjZ6bmhNSDFXVm5SbWZRNUM4M21XNEdWcjc1SjhzUWZvUWNl?=
 =?utf-8?B?Y09zUGEzZlRMQ093U0xieWpIRnlDdC9rNm1CRVJXS2xDWFduMU9sMkNFeXJJ?=
 =?utf-8?B?c2ovUTNvbW9UVHhZcllEWXNCbXl2OEFaMHV3Y0d6d2VUbGc0T0svUXdjR1RN?=
 =?utf-8?B?dlkyeVNzcTluc253amNaZ2YzY3dzYzY0czI4dStGMlBzQTdtT3d1a1lJYkNH?=
 =?utf-8?B?bWlwdW5nTUZhN3h4a1drY2dzZE5xVXM3M3Y2R1lnTjZYeHZvNk1SdmpLVENh?=
 =?utf-8?Q?acZoWZ/EQ/Fb9SSoSql64s4IqhsFu0=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(7416014)(376014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2025 15:28:18.3945
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b734449-40c5-4fc2-15ac-08dd6c7ad5c7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000066EC.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9353

On Tue, 25 Mar 2025 08:20:58 -0400, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.9 release.
> There are 119 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Mar 2025 12:21:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.13.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.13:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.13.9-rc1-g3d21aad34dfa
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
