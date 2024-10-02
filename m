Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2040.outbound.protection.outlook.com [40.107.93.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51C23212F13
	for <patches@lists.linux.dev>; Wed,  2 Oct 2024 18:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727894154; cv=fail; b=VTPwywyuM9sZX2AcslUx6BoloW4eyZPRWJbjDUcM18H7ZYihY34f7jbzZV5x7k+noZLK6he2Lo16AozPjqe+LkGXSu5O5sihod2N+tlxi8LckBh8ij070n/QoBjw03/IH9djX8NhJad3WULHx6tGlBiN1LM4jSYFKRdCMUxhz0w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727894154; c=relaxed/simple;
	bh=XruOlCmm1csSUoiOhZVZtLY7w+zxHXrC1KSIrEqBq8I=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=cx6yY8PrAFjI+5La/S9Y2T1UElxOpitOoAK/lO1lY7BOrqkcoFBtnMqiBk6bBsweqFN22BanYk6Q1xjn8aRPKUBnaS6WOclSbSKjVeDisZjIXowiXRCSGd5pV3y4EfjC5BHUEaJefhqmLKzNMwcrtdNYeEhc2zEbvLw/s4CoKcg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=QIxyy8WS; arc=fail smtp.client-ip=40.107.93.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="QIxyy8WS"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lSL0zd3KG7Pxwh1KLj27Begoq7y2I6PL6ulhVMhzY0AwWMBgavhtsCHn3ZkyKtxE7Itsaa6LpUWNuuBSFrcOGYyvnISiN4a09K6hYFyyemtc/MDgpcAmsOkSW2CJxJRLVN57h6REwl1CjHqctQkNK8zZDcl2bvPPwxJik9SLs2MCyKGERq0+L0COQQ1besW9ChNxKE1LGmkfSULGptRLm7qv9PnU9XoiyNImB7yPRMEVqmgWGcWfIJHrRpp05vpxLWR0po6SaZmWkAKIBFRT0ATKOcmUsEicVJn+zPQQ06lW3i7+UNR+FF7Z8S8jdm6vXuX7IAxltIEO6bnQYkFHmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6wWiOd89VsbJSG64Elf6ItaihDHIMb1D2fQxIYO/cLA=;
 b=BQWIHKVhBb2+4cf+VOnBphBc5bZQYr3ZPapzTGcvTTvBkIgUUQhGN5GMw9IX3pQag5lklktUQ9zdPzz9FVjnlOK1t08FxxSagsMvv+m8kqoWhtcGJF11KsdlP8VgEGxziT/LaW/GnEB1M9C+qurXnfBTUs2ig+L9G8vBLsBnU0KUqWmiiPUcPG1y50hQp8OgdMcxhr+j9mFmj8bdFKT0gA2XXcuUgbaxGZ/oHFiE01ocWJ6wNqWctoainmRDaYxvk0dPvUOjifwv1aztIm7cFkO6ug2mlhR3cWiNdyUuZTlmfU44o6zfUYBQHAV3Nie8qQXvZgyf/1WUo10OVEkSZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6wWiOd89VsbJSG64Elf6ItaihDHIMb1D2fQxIYO/cLA=;
 b=QIxyy8WSp7/MxW5qqdQb3snaq10CNf6/dTVzgOi9OJZmj+U9FjO5GxlWGYm8dhe7DG+ubQ+RNlAstX+4AlbwLP3xy51NlID34TAIl0Dj2/JB/PEYakk3qP4ZS7WMnpqEnyBmei8d1ItOQIrIqO1x/TQUFYppO2/IIaE8HLcB37TY70dx4gifnmJnSBgC2/NfY5rwQMNij6UjDrfYvHSLU/EvAw8010Tdq+sODe0/HzOfnHvctPGnVJjEo/lYwkf/mB88QvS4rLTlT8QZ54kJo2efVEzepYXO2B/lc5QpwKeqUVAgaWDJ8yymLKdumLbGmDvmJlUkIyAvWzjOqkLvkw==
Received: from BN9P221CA0007.NAMP221.PROD.OUTLOOK.COM (2603:10b6:408:10a::26)
 by SJ2PR12MB7895.namprd12.prod.outlook.com (2603:10b6:a03:4c6::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.16; Wed, 2 Oct
 2024 18:35:49 +0000
Received: from BN1PEPF00004689.namprd05.prod.outlook.com
 (2603:10b6:408:10a:cafe::1a) by BN9P221CA0007.outlook.office365.com
 (2603:10b6:408:10a::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.17 via Frontend
 Transport; Wed, 2 Oct 2024 18:35:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN1PEPF00004689.mail.protection.outlook.com (10.167.243.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8026.11 via Frontend Transport; Wed, 2 Oct 2024 18:35:48 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 2 Oct 2024
 11:35:29 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 2 Oct 2024
 11:35:28 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Wed, 2 Oct 2024 11:35:28 -0700
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
Subject: Re: [PATCH 6.6 000/538] 6.6.54-rc1 review
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <b8ab145a-e267-40f3-88cc-ba6dfdf68343@rnnvmail205.nvidia.com>
Date: Wed, 2 Oct 2024 11:35:28 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00004689:EE_|SJ2PR12MB7895:EE_
X-MS-Office365-Filtering-Correlation-Id: f40f7840-a335-4070-1257-08dce311092c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bWxpVXZyTTZlbGluRlMyRW0yZ254ZHJ5OWpxNEtEMzRmZkF4eWVkaFc1akVx?=
 =?utf-8?B?TWRJZ05OQ3JSTXJxN1huYnJQNWt0ejJxVyt5b0Roc1lzWGN1VnE1MlAyY3lL?=
 =?utf-8?B?dS90TDNYUk04UmtnOVBoT1grc0tVZlBkT1lJdU8rakpzU2o5T080My9XV2di?=
 =?utf-8?B?dzdvaVF0amJFRnErYXdlMVdRcVBKdGhZUEt1MFFmb1BWeS9KWWx6bnhMUnpr?=
 =?utf-8?B?Z3h4OXhkc3ZRczR0NzdXMTg1N0JROSs0UDd1TTI3V2xWQzc2WlBUYUMyK0hB?=
 =?utf-8?B?N2E1QWFXemRsdEN4VEpndWFDZDZwVDIwckNYR1h4MGVseUl6d1NWMnJTOTJl?=
 =?utf-8?B?VTRwUU0rVW8ySXZNNlc0TXVMZkt6ekRid1U1SDZjVVJ6YnE2aUZKUk1id01y?=
 =?utf-8?B?YmFoWWFTdENKeWZmbzcveiswL0Y0b1J0R09BdzlvUE5RVEJVenBaQVBjRlkr?=
 =?utf-8?B?bzJhRWlXS2VwSnprdExYVzA1S01BRFd2dTR5bjlBZWszSVFFTm5uZklPS1c4?=
 =?utf-8?B?em1sN29nR1ZhaTFBcm1lMEUwQUJYRkkveGZ6WGVVOFdnei9hVXNaSFovWHE0?=
 =?utf-8?B?U2tCOGpyMDViUmlUSklxSGdnTmpvYlUxVjk3SWJoNTA1UHBGWFNabFVONWg3?=
 =?utf-8?B?UEdWcEd3WUZzdDZuVzBDbVJ2ZEJ2Ny9zRkZ5eXZySzRBQ2dPNG1hd0MvMUdw?=
 =?utf-8?B?OWNVWlN5Y0Zza3BZck1LMEptOG9FeGd3cFQwWFNjT3l6V0lBemNPS0tKYXFm?=
 =?utf-8?B?T2VwUUdKb09qMDQxTThhdWRGaW4xMkI4WWVtVnZLZUVRY1NkaUkrMWMvejFC?=
 =?utf-8?B?WnhFWllvTmpvenVOT3hreU5Bc1h0RGtsL20ybzlwdDFhMktUd3o0a05BT2Fv?=
 =?utf-8?B?QzlSSFAzRlQ5ZE1INERUSnBlWVFDSDZJcS9FSWpDRXNRYkF3R0cvazZqcW44?=
 =?utf-8?B?WlFMcktWVy93VE5JdXNYN1MwdGF3OGorRno5TkZiOVFPRGF4cm1qOStIQkYz?=
 =?utf-8?B?cmFRaWtZa3hseXRad0RsV3NNdkFrNlpaVDVDYzhxaDFVV3pUNEtUVlpsbWtv?=
 =?utf-8?B?YXEvRWV3V0ZjTDcvNmRxT0RWNStGUHNrY0c1WG5SSjVONlUvMHFNUGRZU1NB?=
 =?utf-8?B?TUI4YkIxSUpaZkFxa1NXcXk5c3FmZmdiOXBKcnBDSlVpclA3RVFreWROVnBI?=
 =?utf-8?B?ajVTTkQ0WTlCRGJWYzhRZXNjWWcvRytVbXE3N1pyU0NPSm9CRWtzYnF6M2Jn?=
 =?utf-8?B?NnBDbXZHMEpqN0VUaW9FeHlTY1FQL0VXYzU1bFZycDh6RHdTMjdwSVRka3cy?=
 =?utf-8?B?bWVtZ1BLcmF0UzdMbmJKcDRsTEFTV0pQdTFOeUFaeGZXQ3hqUytXQ3N2RXBE?=
 =?utf-8?B?SzhRdnJsNTJveElBS0xYTFZsTjR2cTdXR3J0VUczWVBkNW5UUDM3ajlzckx4?=
 =?utf-8?B?bFpJZWZLOEhEcEFBRlFYV3AzdlZvRE1idVppS0kxRFVTclhJTDdIQktac2NH?=
 =?utf-8?B?OS94bUozWmlIV1lRUVE2WXhvRE5hTXFmK1NpTi9maHlkUHlnZzA5RHJvaGdk?=
 =?utf-8?B?SnhzSk5lZUc0T2J1ZEQzaHU3V0ZEQ0daeWpOUjFpRUhaRVplclU5WHhSRXNm?=
 =?utf-8?B?SjNWMXJpOXFYdCtkNnBnMGdhZlBYejk0bzRCa0U3V2RSSlF5Qkx3MFVrMTRI?=
 =?utf-8?B?R3poU1VabUlhWGx4djJ0N0NLSys4NE94eXpVb0lMUncxaTg0djBLSjFsV3JY?=
 =?utf-8?B?ZjdZczZSL1d4cFZPTDByK2Y1Nm9BWW1Dc3diaHJUZFovOUo0cVZIZWVWMDhM?=
 =?utf-8?B?V2k0Uy8xZWVaQ2U4eVdEVjFWVHNmMmRsaFVnRXpERHRxdmYxUFR2OGxEVDhq?=
 =?utf-8?Q?2aTty9tPv7FLS?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2024 18:35:48.5568
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f40f7840-a335-4070-1257-08dce311092c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004689.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7895

On Wed, 02 Oct 2024 14:53:59 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.54 release.
> There are 538 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 04 Oct 2024 12:56:13 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.54-rc1.gz
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

Linux version:	6.6.54-rc1-g1bbd78667e8e
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
