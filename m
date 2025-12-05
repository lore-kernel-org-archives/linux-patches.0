Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012004.outbound.protection.outlook.com [52.101.48.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C113161A8
	for <patches@lists.linux.dev>; Fri,  5 Dec 2025 10:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.4
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764932341; cv=fail; b=QjQAdlie3bpPsVGfuHvU1fmVUoR6Tnpr3bHTQJB5KAc1h9juQ2Wbc2NW6UorySVpRCTlEhh20T9/U6FuqZanGaa4n1noe6aj222U7vZohhnKrrP+tcvdc/EPFQLGSAk6ECRieIh8nSzpXAM5ZXofOicQfeq8Sax4RXMAmBZfQpE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764932341; c=relaxed/simple;
	bh=WZPtnpGyEoC2vXqdk5KVXlewZ2We/rdGAwc68Jy49qE=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=hfDJ7NATp1/4WSpefNF4jkN/Zh4S2KfkUL6rV5P688CbXKRvRmA4HFwWCbZNUvx7mlqhx1QqQq2/htLEhOltQ62c3PTQDZ1tF93O/61B1iFwSAj0KGsYwPE3uOnADKqI6cFgUyEQJL5SDsmGglb/WAl5nkqBn56rFdDRfEabqi4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=XzmrEU+o; arc=fail smtp.client-ip=52.101.48.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="XzmrEU+o"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=deLnZM2xXFZD2vH9cckIUQ/PvtaHp4VEI47xPLeFayiMRKhtyM7R1qtybBIPbsA++f9b7Ut1DAP70kpJ3tWPkRLoFHGiapKcZYQDgVQhHXwZskgpJGsnXXdjs8TKoB6vNiltoWOgEsq7ysy45VvBq133adQQwkt2H1SwePvuphDH93TSZOsy9I2EC3QepqUHu8GZoYDsTdkBnkELaU5o8HfYjkWAdZS3nubru4oBJcx29mtPqqrGGyE/xkZoSwMQYnATyPlA7K/mYRuzAuKn6lC1xd6dafrNULPBiaFHRd0wY4amsSmEAXgGxS5psCU6oSR6A3iTHtb2P9l3Li7Ncg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FvsKlr4qJNQ1h3qnSCaESA4sl5Y8i/vY1syLNXMfLoU=;
 b=t8TwyV1h+JA2xyNy/vSFwcDLHk4BjTmqqTxgxHpxWGo5lQqBoFNsPRLlLEokFbIjXCkA13ooEQG4Pr0ZoDkF1dI4/3kGDOmtqcnCocW9Uuh0Uoa1m0BSp1e7DwUiah0S60sUXKButk8CnWGipl5zQ1bZcxMvYpH/wqfETvEAlvEU2hwOCq7vqfrQA9s7pQQEmh5uJb3F2evW1kpaoxq575Vvxqo11vqDfKpwGIiYtDVuWPnxx8u1ceeXg8VyRzG0GO5z4XC3Bjk83X2Ae7p2027W2ZnR4HvgArylEhFJHFvE0Fuk4vIzAHI+nfZAAhD+DjX191T7ovXEDDtvLPclgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FvsKlr4qJNQ1h3qnSCaESA4sl5Y8i/vY1syLNXMfLoU=;
 b=XzmrEU+oa5jGSM0s1Q4bNcPwprYMV3V6WwcU7IjB/MeEMLtVOO8Yb9HfxAj7Qf9NXRgrRTn78t3ref7PCNDByBTA5a8qCTZXcsSSx6blapxFQW1A/5pnzEUJxicpFRu6y2AWUuXBWwHZl3tWQbC0Y4ixzDLb1EwySGnxaaz4TpnvHauCuGC+FaayQI97B5fwPe1zXmI5FvdjZDLlpRCAcnLH7ggh1Uu7REhmb7T5+RwzRsAkEjac5/ejZyA9pw25dtLMu0ygKUrcRtjlhfNRNvxTn6ODgl9YGxnxG0lroKA6dcZusel4VGCqSi2RJwUKv5ePs+yiGi9VT85thP8DHg==
Received: from SJ0PR13CA0227.namprd13.prod.outlook.com (2603:10b6:a03:2c1::22)
 by DS5PPFDF2DDE6CD.namprd12.prod.outlook.com (2603:10b6:f:fc00::665) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Fri, 5 Dec
 2025 10:58:51 +0000
Received: from SJ5PEPF000001D3.namprd05.prod.outlook.com
 (2603:10b6:a03:2c1:cafe::16) by SJ0PR13CA0227.outlook.office365.com
 (2603:10b6:a03:2c1::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.0 via Frontend Transport; Fri, 5
 Dec 2025 10:58:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SJ5PEPF000001D3.mail.protection.outlook.com (10.167.242.55) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9388.8 via Frontend Transport; Fri, 5 Dec 2025 10:58:51 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 5 Dec
 2025 02:58:48 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Fri, 5 Dec 2025 02:58:47 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Fri, 5 Dec 2025 02:58:47 -0800
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <rwarsow@gmx.de>,
	<conor@kernel.org>, <hargar@microsoft.com>, <broonie@kernel.org>,
	<achill@achill.org>, <sr@sladewatkins.com>, <linux-tegra@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH 6.1 000/567] 6.1.159-rc2 review
In-Reply-To: <20251204163841.693429967@linuxfoundation.org>
References: <20251204163841.693429967@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <a02d61e2-d838-453a-baeb-3c7acd18a28e@drhqmail201.nvidia.com>
Date: Fri, 5 Dec 2025 02:58:47 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001D3:EE_|DS5PPFDF2DDE6CD:EE_
X-MS-Office365-Filtering-Correlation-Id: 236821de-880f-47a8-6ef4-08de33ed4692
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|82310400026|36860700013|1800799024|376014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?blpkQXBjSHpwS3NmV3ZwcnpwM2VPUStQUWNQbFpvNm95MG1UUDFVamUvVTZn?=
 =?utf-8?B?OFRzVkZpcmxYQ3lqalBlMUU5UHFIWklSWkFwbUpkZFJNWWk3eUl5M2ZhSlNx?=
 =?utf-8?B?TGMvQzhwS3VYT1JJSVBsaTBQclVDaU51enArc1MvN2N4YnZaa0gzSXpwWFI3?=
 =?utf-8?B?REJsRGpFdWp5ejU3Kys2djVLQzcwa0dmbG5mTFhGbjBYSENWREYwYmp0NkFy?=
 =?utf-8?B?ejVXdzd2R1NDTG5wUjZhVkRHSmlKU1Q2Uk82YlQvM0RWanNmSVpobW1uVnRa?=
 =?utf-8?B?NlpTSmdCY2VzOTZXMVYwRFNkVnNDTXJ2OVJLeS9mVEdLaXVEV0pVSzgwdGRr?=
 =?utf-8?B?UCtRN3FxQU9BY3I0RVU4aWNrSnVkTEV5QzFEVDJQank5bWR4QndDazdSOE95?=
 =?utf-8?B?dzhsTWRVNEQ1NFQwWUlvVHVUcHJTT1BTRXpFUi9rSDBkZE4wbk5mQlVmbTRs?=
 =?utf-8?B?a0RqNXVPZk03TFE3U21CbFQxSE1LaFdzeEFvT3hsVXVTa1lvTk0vV044WTha?=
 =?utf-8?B?bU9PVnZtQ09qQWVKUnN3QmVUNGo1Q0tVVG80eUtoUUxNcm5pVVgvby9NZW1H?=
 =?utf-8?B?d1NGYU51TXdYVGRwcWZmU0pGK0NmS0t6VGIrTWJrWWVVMlZzY3hlU21wUUtR?=
 =?utf-8?B?M0FhWitrYm0wK3Z5dzBrOVU4TVNMeHQrajRKajdCcE1QMlQxUFdIdjlvZWtq?=
 =?utf-8?B?TEduK3AydXg4anlVM1YvMnlpU2hwVFpRbVZMK09KbE02UUlhZUZ2dE5iQkJl?=
 =?utf-8?B?OUxPRUx6WUVBS3B6MTFFU3cwM2UzalNEMnJJaXFiTE5vZm0rRFhtQk80Wmdm?=
 =?utf-8?B?RGNyU2R3SVhQbVhUK0RicWltRXlxZEtUTmVXNzRPK2NCS29Nc0tMNTB4MjFY?=
 =?utf-8?B?NzUwOUptUDFzY0pmcU1pSEc4NU5QZ2o1R0o4LzN0UlB4akxnSlRGZEhoK0Jj?=
 =?utf-8?B?eGVHNnc0Sk5rKzBpa2FsN0FsWjlicE5CN0JJNFZVTlRnUGRESHc0RTFNVCs1?=
 =?utf-8?B?WUR5Vzd5TzVKamtyMk1SRWIyTEUzOW9LWjIvbkluU0pWMVp1SmZacVIyNEwv?=
 =?utf-8?B?RFlsRzVCQU10UUttUisrRzNQSGZFRWVvdVROZk9qb3NWSk9FYVI4U1FqNUZl?=
 =?utf-8?B?SWk0eTBTeWV5TkFFczF3SVdCaHJHd0dNLzRRdGtvVFY2TnRpMjUrb0RoYm1r?=
 =?utf-8?B?d2tHeDZIRHIvZURLellOSHd6L2J2UUFRazQ3NG55VlZqd2FIWmdYYkpkV2U0?=
 =?utf-8?B?ekx1RjJVOHBreXQ0TVh6VVVIOHNQS0c5TFM0SGZleElEWlFjcERSK0VJZzha?=
 =?utf-8?B?aVRha0ZHa3R0VEJlVG1hMDRuQ0pzMk1HODg4TGtxOWZGZGlVeHlzWGxaZFVl?=
 =?utf-8?B?QVdka3o5ZCtRb1d6YjJjczBhckZkWGY5bFNLcUtPRFI4RnEyZ0dKOHZwVVM3?=
 =?utf-8?B?U3BQSG0xKzFTdUlUSFpDdk1lNjZab24wWmhld0kyTGtqbVBRYTg1VE1hSnEv?=
 =?utf-8?B?bUQ5RmoyYm9GOHVHYU54dVN5eWd2TDQ0YjY5cHpSR1JhRlQrdWl4djRPRFJC?=
 =?utf-8?B?eUZ4YXZ6WS83N29XWjNuNVRkRnpyRU50dDFIWXk2cURqUjdvcjVIbEwwOEwv?=
 =?utf-8?B?b3MvNGc1dTYwTWZJSHhCWlNyRzVJOUY2QmlDSlpEMThNSGpyY09ydW4yaFhw?=
 =?utf-8?B?cU9XTkQrVW1XejM4UWFCblk0MU9OYjdJaXhKdHA2UnMra1NnUnpUbDM1eG9S?=
 =?utf-8?B?dWpicXdtTzYwTjJkMHhwS3FTMm9tU0F5ZHdtVHl3cStDWDdkTTc4WnpzdkVh?=
 =?utf-8?B?VXpCTjVVdHNLTlZhUEEyclBPclc4OGp3dk9FTEQ2SE1tZ1FFSkJQLzZsdWlK?=
 =?utf-8?B?RVp5Y0o3azRORUUxTkM4aXoxRWRYQ1BhNVh3SDRBY0ZXUFQ3M2h5YmJYSVRn?=
 =?utf-8?B?MzQrSEFvYjg4eW9vKysybmdaQzAxWFJXdWprQXhtb1J4TUdrcUlIeHIyVTlN?=
 =?utf-8?B?bkNIN3ptdDQxbnZ3dS9NMHAyOHdkL0RINWZCd0Q3N1VYZFI4bkZBcXlKN3pu?=
 =?utf-8?B?eGVjaVlBemRLbE1TNDRUc2dSU2NpVmxpRVMwUXRlb0Z2NXZaV0QzNGVJbVFx?=
 =?utf-8?Q?MhsM=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(82310400026)(36860700013)(1800799024)(376014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2025 10:58:51.7142
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 236821de-880f-47a8-6ef4-08de33ed4692
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001D3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PPFDF2DDE6CD

On Thu, 04 Dec 2025 17:44:32 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.159 release.
> There are 567 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 06 Dec 2025 16:37:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.159-rc2.gz
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
    119 tests:	119 pass, 0 fail

Linux version:	6.1.159-rc2-g2ee6aa0943a7
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
