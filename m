Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2066.outbound.protection.outlook.com [40.107.223.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B879C19F436
	for <patches@lists.linux.dev>; Tue,  3 Sep 2024 08:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725353030; cv=fail; b=hM4cNM6gsbapvuYitUIiap2SwshHwKF5SAKTjH6T1HvfOyX6scdeeuvKEn3UKhf40hOXjL46OF/JzWpwPPL2bgge7GCHRVpVELVO6/3ZcHi7CL+JNzvCZKPTWowRclLQ4YK4pQ1MBBA5p2p7iND8iBl6boX10DgKofygQQ001ho=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725353030; c=relaxed/simple;
	bh=Qo2UCDt9MOkuUibP0AjhCfRsOiMvDWHJhw6s3Dm6w2E=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=La01YlWG7cS3f0w1ejvYA6TBelqA4soSSpxQr4LMpzMTE1YEReSJm6lcru6jHseUe3bx0PnM3ozGlEFZzwqfFiDVH4OgP+ZkjHmdMjQte6owldI5lzukksNL6Fnkl06SCO++cKGaH3DtRCBrnZbJCtLWo8avuPehykC/IrHnCVo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=c8wkVBX2; arc=fail smtp.client-ip=40.107.223.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="c8wkVBX2"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q2+M9r/x4yGLbt6Pbhdgplj88eJnIX+I2FMYR0dYCg+mMLQZ7uhiHEtGlKn+SvsqZSG+x7uuRfof8vfmxOtEekB6LmSZuO/7UXPaX7lNvKbVdtQG6oUoazzB6HsR4EWT3nfCusVX05h2Pcus7CglGBESRCFAr21XaO3ApXH6oEa7EY6J22m8JVKM14C8IrjJOqnn7knze14wkK4Ia0mzlyWIbq8+XNfsgn3wk/eqeqlVePebNF5K+Uzy6WRxPqXEpJPenAao+sTJW+6qnBELbieSJEaeRvl1WbAHYcrvBUr64pM2faCr4rbQHDKfp/xnEtmOcvW+hWMMJw14KLR2uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ylYG4lWMIMJMseaEjnGbfZaiUF+ATAdwoNxaNK5QLFg=;
 b=wZzUFBxt/nvKxqzpwQzE/su4uxiYNnFQoipkcMthMHksxRqDzFHrrb6ZOct5iyVhLBf8E7Moq9NqftskEHsQaihZ1JUr564xR/h/yPnITzFTpI2IarRM/tXqkrkIKfql0jqzy1D5HE8IdnndJQpOVcqjUYtDVJueHoQdLKUip7EvNHWu5d3ufg5gEN68Lu3vihNrnOxGDoq4wcsow7KJ+SECjhioPKRVZuzUW2w8KZn5SD253/sFXur83kl0QueW0Idnqoz5FqT3RrWhYdo+a3fKCeS3h8jydhmMatf6sB2pJ17NZdatfaWH5p9NWpRPI3x0mnSeKwE0AGNJfdlE1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ylYG4lWMIMJMseaEjnGbfZaiUF+ATAdwoNxaNK5QLFg=;
 b=c8wkVBX2ZOmiveTjrRYEquBiLyi19qeUR6c7s0kWz29V3k1GKraESebvRcJahVtJ3UJlTVx8scCjPeHLb3poscFMemkscpujnBYymgucq2nnZMM3MxA+i3Jib9+S4C49lW5DsqCxVUnEvqDnmF/QkW/5/jVgSyxlKM5oAVz6+3apsGoI6v2KGUKQ3/LSNwYbc1jn0ztxPSDY6t+NSRUOheyqEiLri7SmDCUu07K7py6ChfHR5rQaPVU3e7sfvZGbLktaYv2vur3NFPERINYWUjqL8hDic5kt3bON8yZ94AbzlZxGHn2xCjYVnSdMr8ctCxltlDHxS/f9RWNM/6vBNA==
Received: from MW4PR03CA0301.namprd03.prod.outlook.com (2603:10b6:303:dd::6)
 by SA3PR12MB7878.namprd12.prod.outlook.com (2603:10b6:806:31e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.25; Tue, 3 Sep
 2024 08:43:43 +0000
Received: from CY4PEPF0000EDD3.namprd03.prod.outlook.com
 (2603:10b6:303:dd:cafe::54) by MW4PR03CA0301.outlook.office365.com
 (2603:10b6:303:dd::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.27 via Frontend
 Transport; Tue, 3 Sep 2024 08:43:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000EDD3.mail.protection.outlook.com (10.167.241.199) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Tue, 3 Sep 2024 08:43:43 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 3 Sep 2024
 01:43:32 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 3 Sep 2024
 01:43:31 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Tue, 3 Sep 2024 01:43:31 -0700
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
Subject: Re: [PATCH 5.4 000/134] 5.4.283-rc1 review
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <62b5754e-a745-4e12-8479-4ae87a98c373@rnnvmail205.nvidia.com>
Date: Tue, 3 Sep 2024 01:43:31 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD3:EE_|SA3PR12MB7878:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ed6c129-0c36-4a70-aab5-08dccbf48469
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Y0pGRkZ1b1E1QjVZMTNRc0NRT1Y4c3RWMUoxWWd0L3VMQ2NreUFId1N6cTVQ?=
 =?utf-8?B?L2RkYktxZ1NBUXh4eUMvZStQSGxFSWEwWFVkYTBFWk9CRnJYZkxUMHFBWWhD?=
 =?utf-8?B?MVpkMGlDekIrQWJGb2VOSnJEN1Z2U3dHOUlUV3lwcVZVMmxNVzVaWkt5MjNu?=
 =?utf-8?B?d1NJUnFuTU5mVVUzMHhlUHRySWQ1QlAwQ0kyNEdQNW1hazNXNkNxcnhsTk1i?=
 =?utf-8?B?MnlOR1dEeHFBdFRFbEtnbmhpbWJMb0RTVXdrcmJ4VXNrMC9ldGlRZ0hUZlBi?=
 =?utf-8?B?UFVweG1DR3FlSGIyL3JJWTZvSHluR3Q4L09Zck03RzE3T0RrZG9iUFdaZDJp?=
 =?utf-8?B?TnBHYXhIeCtuZFkyeFI3cldoVExmbzBzWjhwU2RQL3FXbk1rN1hNc0xvSmE5?=
 =?utf-8?B?WEIzOUpaZFJpdE5TYS9aQ2lMS0RjbktyblI2aytaUTNaOXlRYURZSkFTQUgx?=
 =?utf-8?B?dU55cUFkOU9YcnMxOXZWSXFRVWl0ZC8rUVFYVjhWUS8yejliWmQ3eTJvNWdx?=
 =?utf-8?B?T2FZMUdQR0FFaldiYzhmcGxVWkpBb1hkTmdpSjJDZjZBY0hPSkxnWnN3ZVBs?=
 =?utf-8?B?Y1gvNFFKeUlySWlDZmVCU3Eza2U0Ty83RkZsMHFSeFNSNmlNVE80STVlMERh?=
 =?utf-8?B?d2NBRjlyeEpEM1RkQzhxVW9LSS9jajA4SkpLMUU0aGI0djVMVHlacndzTG1k?=
 =?utf-8?B?cGRZak9hWjJqMzRxQVdodTVBWkN1RU5xWUZxTUZTMklsTGNLRjBvc3JPRE9v?=
 =?utf-8?B?eGlhR0FISno1UVR6ZXdid3g2TWtyTlFMRGk1K2Z1Z1kxRXo1bVJwUHJYOTN1?=
 =?utf-8?B?NnAzV3dBVVFDYU5LV1g3Nncwb1crZzVhWjBTd2xuaUdNR21JYXJrUXFVUnM0?=
 =?utf-8?B?eGtvUkswOE9WUEQ1cHNJVzJnNDArYXN0N3l1VVFzOGxWdkpWbUwyWE0wSXZq?=
 =?utf-8?B?aDFvdkVsajQwM0tuakRmVkxrNTdPaW9wVm5ZcHphamNSclkzTTB4U3ViUmw2?=
 =?utf-8?B?ck5HYTZqNHk2WitXNFJMelRmd2FVZVRaQXM4T0xPeWpOMFpnSFNGb21kVDNm?=
 =?utf-8?B?LzRuK1V2OE9CRnEwWmpFZk5lTGxhQ1N4bHBjK25zOU4reVl5bERKUE9GN2Jj?=
 =?utf-8?B?S1hZN2xTRHQ0U0N5Q1BtcHlsSFFpVnBKUmdpY09kV1VyVUZMMVU1UWxWN1pq?=
 =?utf-8?B?UkZGbnNaYjF1ZFJhM01sQStZRWZRbGdZbHBObkZnbGxoT0wzOGdJZ1JrNDNQ?=
 =?utf-8?B?RERaRUJybkZZd2hSeFoyU0RpcEZ3emx1THVaVU1RdzE1ZE41UFJIUFdwYjgx?=
 =?utf-8?B?V041ME9NeWdJczJGZHlrNjVHRmZaOVNaRmxtRzNCNFZmWkdiT3hNOU1zNEQy?=
 =?utf-8?B?elQ4N0ZtRmhBZ2x0QkVGMkZISlRhV2ZYUUpVYTBiK3RmdTErZzJJMG9CUVpX?=
 =?utf-8?B?L3dZcDJzNlNTajkzYTNjYlBBVG5FNlBaTGFSbTNmSGtHcGVQV3BRZ2E1VG5p?=
 =?utf-8?B?OEZmSkJaZmtFemJzYVQ2NW5oV0ZvUXdkM2p4YWVaVk9CTzlSeHgxdEwxeEtx?=
 =?utf-8?B?V2RDR3U3bjB4YmhLMW5QQWpCdlh0Vk00eC9hWndSNlhhOEtTcU5YYmwrSWdm?=
 =?utf-8?B?dWRhenJMM0s4bVJHUDdFbklKUUxVRGtFVlQrYVJDdnVJNU5VMkZQUmV0L1Zo?=
 =?utf-8?B?S1hlbVE3bzNtMFpDSis3QmxKeDZhKzZNYVVQWlYzcVJwRC9jN0FITGRoMW9m?=
 =?utf-8?B?RG9TNVV0V2RsUTg1MVppTndkRGFEMnZ0UWtpRnhnNDNYNnBmLzJlc1hRK0xs?=
 =?utf-8?B?NzJDQXVHbXYzOC9uQlR2SXVsRmdveGQ1VytwUHZDOUFVN3ZoT3RUQ1FXRWVV?=
 =?utf-8?B?WjZURDZXZWI5bzJBZ3lpUTkzTUhJaTBwSnJORy93WTN6cHhIN0FacEo4cDZI?=
 =?utf-8?Q?w1+RxsxCRetCPlkM9qHU2sfBYamDuPgp?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2024 08:43:43.2337
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ed6c129-0c36-4a70-aab5-08dccbf48469
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EDD3.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7878

On Sun, 01 Sep 2024 18:15:46 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.283 release.
> There are 134 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 03 Sep 2024 16:07:34 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.283-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    10 builds:	10 pass, 0 fail
    24 boots:	24 pass, 0 fail
    54 tests:	54 pass, 0 fail

Linux version:	5.4.283-rc1-g6561e7052c34
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
