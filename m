Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2066.outbound.protection.outlook.com [40.107.220.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20BB434F48B
	for <patches@lists.linux.dev>; Tue, 26 Aug 2025 17:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756230281; cv=fail; b=m6P2+3BdMxhaJ7XRZAmufW/t178q+RSfw3PaReDMsxapreMOL374sJ2tPgBIlrQCDZZkxepq5w7MXfINidKaR3SzdbuzCvTUa5TsNMeyjqtzwPENZ596kKOpwrfyZEA3RdeehOH/otaM143v5zMSvH5K6ELBavU/njeSk/ozce8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756230281; c=relaxed/simple;
	bh=6UfNdF/Ih2zzzWZBMpPHH6EK/I0yfxlscT5FNQ+RLlQ=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=IzUOfbWhgkk5kXUqBn3Twr0UXlhOdz4+13cD4Shfucsg/Nj7a6Aj6pQkatRBcm724G5BJ2Ltj747ibaI2XCq4DQgTMhAVVk4FXPWEQ7CBLwkDoAEpKdz18EvBwAtjBSiGIsrurUd56rU9GXJwHGj8KAn4gHmRmtDvo+t1KhMCWw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=UugXvlkA; arc=fail smtp.client-ip=40.107.220.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="UugXvlkA"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YMOE+AnqYk0ULvSdKVcNaff9Dz/nxaDqX7baHf47i6fMROHv4v546hk6MDPutrIr1dfA9sWsilRliolqcqHbbb7Ehje1o7L0FMKPOj9dkMaBQf+b358cQSlbKfLelyA2r5nicK4XnElok5oGhYDNu804Z834fQ4rlbp5tFi1LPcH9D92cEP4ckkvOu4mu14775VPgeP/H28hKmyTu68NjYXu9jc8dfuBq9jhcbqrA8BfKU4xJsLanPZlkFZhH6VpGZ9hul4TM7wovPJd8U60E67yXrLjaAVr4wpzs4MZM1DIgVYhwTN/5GQNswp1WSajW8YOMi1GR3RbZIE39ctZ/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W79HztbyU6zGeC90fXqU/B/fxVbt64cFtM0qnuQ6TLc=;
 b=vbFRXB63mAe8UgpVcPvjuKETclDZObq5VV9lRfAUIcgMSMSuEIu6qzydpWhh6/F55fbrAEFRMk/DE2anExEOR2PplT2LkREqSXKYuV/A1nllP14itSGfGKa946ifXAy6JWybHEipKGVPAPHpj8Ru5lWEkdaY/G39ZhYkuoadE+A3H6xhzXwNZQUnHrpWUrMeeCGwf7GswG9r+gDqK8mm7MJWZpCDAMA3pzT2jQJU6CDARD2bBKS9gtVGqDIaOYCg83aHXxpShlXcgYeUxbWlk9UU8PgDYl++QAD4birFDbaxX2M9xwCxVcsjz1TwgYgw5kKoP2fpI0zcuvHZwAooFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W79HztbyU6zGeC90fXqU/B/fxVbt64cFtM0qnuQ6TLc=;
 b=UugXvlkAnGW38Q/KcEDIcXw7ZXwWerqfFhmJuo+j2DHx1YFVrxy7jFrhRAXen7xu4iduqR3xX4eWlLfqF5DoRSLedVeqMXhMFk8FyZje0aOfebE5USnTlhhKMSsg2TAJ5oZgBp1W1jJtds4+CXlcvL4kKljwFVNBxhdmA9/+QzgqgvLrVLCcrWtKQKbu5klpmT00tx+1AaqiMoWxLxWmq1ppyXOq9p+dWkNC24wnssyVhqEuoPfOPwu2akyajPyprZbepvdJY+Vp65zqBVF6udn0wYLKQR7sz3thRv3edUyRaH0SZS88BJhM2U843yUkZwr9SMX2zph59OEc0ZiOCw==
Received: from BN7PR06CA0043.namprd06.prod.outlook.com (2603:10b6:408:34::20)
 by CH8PR12MB9768.namprd12.prod.outlook.com (2603:10b6:610:260::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.13; Tue, 26 Aug
 2025 17:44:37 +0000
Received: from BL6PEPF0002256F.namprd02.prod.outlook.com
 (2603:10b6:408:34:cafe::24) by BN7PR06CA0043.outlook.office365.com
 (2603:10b6:408:34::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.14 via Frontend Transport; Tue,
 26 Aug 2025 17:44:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL6PEPF0002256F.mail.protection.outlook.com (10.167.249.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9052.8 via Frontend Transport; Tue, 26 Aug 2025 17:44:35 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Tue, 26 Aug
 2025 10:44:11 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Tue, 26 Aug
 2025 10:44:11 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Tue, 26 Aug 2025 10:44:11 -0700
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
	<rwarsow@gmx.de>, <conor@kernel.org>, <hargar@microsoft.com>,
	<broonie@kernel.org>, <achill@achill.org>, <linux-tegra@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH 6.16 000/457] 6.16.4-rc1 review
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <defcf464-ae07-4a63-9743-3814114fc1b0@rnnvmail201.nvidia.com>
Date: Tue, 26 Aug 2025 10:44:11 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0002256F:EE_|CH8PR12MB9768:EE_
X-MS-Office365-Filtering-Correlation-Id: 0cc48e07-6e09-4e2e-3f6b-08dde4c83926
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014|7416014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MXgxaElJWURydWdtSloreldPYU91dE90cHMxM3pzWldvZUxLUktPci9NbXVB?=
 =?utf-8?B?YnFBaHlyZWZsL1UwV2pDQ3JkVHQ3dlAxbEZoUkI2akxXaVNIdFpIcU5lY3BC?=
 =?utf-8?B?VTdYRjYwUnJUaytsZ2ZSRGdlQWExTWZmaHRxZHNJMUxLaVd0dDh0RmZTQlZH?=
 =?utf-8?B?YnVhOG9lSm9qUTAxMy8yK0F5WTRSN0N0S1pGTHpFNSt3MnhTVHpVV2VZSFlP?=
 =?utf-8?B?Sy9wSEtIVHlDeUxMUkVzKzRYeEpNYzU2eUNnVnFXNU4vbCtLYU9lYlRLNmtW?=
 =?utf-8?B?dmVvVmdHZXRDUkRCYktZQ1lWa3RwVGIyZEt4YW1QWU9TbFkraDkvUEExV3Uw?=
 =?utf-8?B?VnFERCtwR083TTZYV2FqMjcxVnZnbUlTZWpjR0s4Y2NTUUVTZGNETWlaNkhD?=
 =?utf-8?B?aEx4dWZtWjdYVXJPTEZOQkFML3p1UGRBVjBkUFZEb3RPWVpxRXVoUXVSTW5p?=
 =?utf-8?B?WkdIbDVxMFFzZFVlWm5kc2hPbW5aSDNYLzA1d1BvMldjUm03b0xHMFpjWjht?=
 =?utf-8?B?bnZhK2dka0RQMFppS05qWVgydXBiREZEL002VWJnNlRvWWFLM1VEaE8rOGpD?=
 =?utf-8?B?U04xMmplOVJlVGRQQnpieHZRSGs4Q1l5ODJwYXN0UjRlTThCQmhCZ3hMSytr?=
 =?utf-8?B?N2NtTmVaRkg1UVFtNjFZRkJuYUhYc1B1NU9CNkFYNTdXTW5ZZHFPYUtDb0s4?=
 =?utf-8?B?WnhudkNkakpmZldsQUs5N0NtOUJpbUZxRG9uRXBvcTZrYjBOOHQvczd4azB6?=
 =?utf-8?B?SzVFbnFXMEI0ZnB2cE1GNXZra2JzTVltcEFaR3Q4Z2pma0JLbC9lMzRIZU85?=
 =?utf-8?B?RlJUNUdvaFBwSk9TT1pkWjBxdWdUeHIrU2h1cEU2d2wxZW1hczNWL1FraC9z?=
 =?utf-8?B?Q2ROSTdidGx0ejZMWUY0dHFFbUZSdEdCR3ZRS3J2dE8vTjdWeWRkSWErNnBo?=
 =?utf-8?B?Q1phcjRheXBtSlFpNllUZyszcmV6bzY3VUhHSDBtR1d1MSt2cXE5WW5TOHlJ?=
 =?utf-8?B?WnZCRlRUbzdVVFFTSHZRc1NRU1h4cC9qWmpsTncwYkdlZytzZTkyZTh3Rk5B?=
 =?utf-8?B?Nk9LSFR2cnEwR1EzZU90MGJ6L3pPUlpGY2xsNzgrODBGN0h6MlA2QWdDOXYz?=
 =?utf-8?B?aGpzQUFaRE90dmR1ZmFLSmoxalQrUG9pTzdFSWNITzdPWnpGL1RFV0wvMjBZ?=
 =?utf-8?B?a3J2eGJZdnBaYXNLTHJkZ3pYWWtacDJSYk1oajUxaXZmSHVGM3lQQjZVY1l4?=
 =?utf-8?B?QnVWMjdvOGZzK1lNdEtZTWxPV3lDd043Qk5WNFI3MnprUmZsblRNLzFlTXZr?=
 =?utf-8?B?bzRndzNleDNsclBZNUVZdnNNbFE0SVZIUTd0TTBueGo0VHNrOTB0cnNqSlZt?=
 =?utf-8?B?YThqakVZUXV3dFlGdmdYL0VLOUsrYW1FRE1FZW9rTXpRNjZuNjAweFY5QjRz?=
 =?utf-8?B?T0gzOXFFSXFuQnZtZ3lncE9EcVp2eDUrV3hlNDlUWjBjeFh3Qy9GWTZtbUcx?=
 =?utf-8?B?dkdzNEE0eWtjQlJVK09UOE1aRVVzbkRsMFdNYkRNd2lzUnhNcjU0a0xzcWVN?=
 =?utf-8?B?eGhlY3krVUtZeHZmekcvTFN2MDAvNjI4NVhBQmdoSDN2YkV2dktLR1Jod2VV?=
 =?utf-8?B?WjY0ZDArS2ZZZVlWQWp1MEFXRWRpWWFzL3d0YVlyOUZXWFo4WVhnVXZSb216?=
 =?utf-8?B?N2xpcGQzUTY4OU1qWVlGYnV0N1VRdXIySFp6OEMxeGp2YVlieUF5dmxqaXpI?=
 =?utf-8?B?RlZPcnZSRHQ0ZThxQTluUnVsT1oxVFU5QkJtMCtsYStPWWJ0U2FZSFFOcHNP?=
 =?utf-8?B?VHByeXRwVVF1L0VkU0wvUW03Sk9ORWNrSSt4L3R6MXNXckVSdjJRaDdCMEtl?=
 =?utf-8?B?cFBKc3lOSlNMMlZvT2dBdFoxa3ZXMXB4ZTN0ekVRYzMwNWJIRjR3MXFwRWNt?=
 =?utf-8?B?QkZMenEwbTBvSkxMSjI1VzE0VzNrc20vZ0JNVVRENkEyRzNFeVc0cytsdkxF?=
 =?utf-8?B?Q0lYaUFEWGY2blhvbUhjS1RQcWQzaWVwZ0twMzRvM1g2QkVIUkdiMm1uc0RI?=
 =?utf-8?B?R3kramZnVnB3dnJURlhMRnd0dklzM3JyaTJnQT09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014)(7416014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2025 17:44:35.7937
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cc48e07-6e09-4e2e-3f6b-08dde4c83926
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0002256F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH8PR12MB9768

On Tue, 26 Aug 2025 13:04:44 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.16.4 release.
> There are 457 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 28 Aug 2025 11:08:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.16.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.16:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    120 tests:	120 pass, 0 fail

Linux version:	6.16.4-rc1-g2894c4c9dabd
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
