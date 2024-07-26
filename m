Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2054.outbound.protection.outlook.com [40.107.237.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDEC517CA10
	for <patches@lists.linux.dev>; Fri, 26 Jul 2024 17:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722014340; cv=fail; b=NNqoZ66FicXQX2vE0CwfdGdzZKCTQnxAKkBCrmj7R0D0BJMeFdtif3TnVw8EJo2hsi6KjUOsydNObmWJ52c8yyf6v8u/YbnPwB7kozwHFX8MlYMQPRd1RO05LIAllOKV/8G1MeOEo0fRhidY9OQpOY+m8YBCku6kgMqV+6/gZFo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722014340; c=relaxed/simple;
	bh=8LI/Idw5pCe+NW1oot7lMzMOSlTo9zfSvAX0kgVL80c=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=iFHm9p5nlGl06v65/KZ4+5JVFF717kfYdl+FMX5BHW3JWFLXAj/sPxZsnwWaq1uLL4yPZ1y77F7+bn0IRuT3HfbE5Ar+DiIXSQzBP/SW6rYHv5D9CdFoUvRfEu+toYEinhulV53GcAC4aa3gC+ctBCD+Nd1kGzHebiHMErlxbUk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=L6prQDQ1; arc=fail smtp.client-ip=40.107.237.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="L6prQDQ1"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rDrhL3GoKbt6OyHYOXSHGOgW12rzrLqr55gufnnvzBRyptc/xkaeoQKABj7wHeaz8D19eAqssNbA4gDq4CyDmswQA3QSR+N4tPO9MpIPEhZjKBpdSiW5TmZuYn9zWN8xr/P1U1n80hwVBrLBzN2/LheguH0vxqZ6rP1QNhzexOd4X0rmaXStEUz0FAeILtLuVWn0y3g0Pdt09KMJPp136ZJMFI+HPg78LMklc+tDkD54sWEv9n/g35+CklNXCxtdkOrcp/sY2O3JPC2f/6DkyuZnrDbNK81z60gYhs6JDqvBsPHDqqRFOsnUms0L6CSMR4w4B0mlP/EuDY9ZE0NBKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ma+jrPCWNIG7ncNE7788i16i5jcxVbyC1bl4Y/Id7PQ=;
 b=ZQPXszWiaO60BYUZK9dHrFZxTT3WaZTWqPb4DSN+J5MMlcSA2dWbk+Hzo8LSBdkaFI6CefENot168qLMXIlTzMPlxZZ4h6Nr5QN2/KLwIS6AwPVLJgjXKf+MDG8+3VQfJFay3WzxjlvkeeWj0zwwJ1tipFZfdVAoX0IXJMg7FfpoDrJX+RLzQmpYO0v1ll2b6OcUw+vqwuwtet4dKDZ+Dn5LCF5PmOOi0bbE7wPziqc2ufQ+Z1/SY6yQFfmCv3ITIyisdX+3iXsF9dzHoubLEmFLwsQKI5FvQ2x49P+3AjDXEM58aRn0dymlJGQMAK4BNtuS5/N2YnfnC6U7l+h2ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ma+jrPCWNIG7ncNE7788i16i5jcxVbyC1bl4Y/Id7PQ=;
 b=L6prQDQ18cxxhX9aqJ8t9GpN//OcTbVAz6H+pTNsvQEChT2trUlNIHBbBEP7aP6ioR81fZUcjttYPm5kqEGXkDQXHEgBCi0dCfpfISBlyIZqZ1sxR8hDkp68XhkSVep5uV5pjL1wZ6Jggs9dYVu/qAkGedXUPlnYlVYHS8dRBrtnTkX/kvw2qkmYg04JtT7GhCbXQD/kImzRhwfWheqLKpThtD3Oi+uFGfhgocJg0Qbp4mf7g2qlbpd7ut4q5ckFgit59rmPvX5spAEg4nd7fhCMtGPSARW9tFdkEXnJibhF9HfGdw5LiAHFegnbO4y9x0HsFtpTZO+72Z6TrAYAIg==
Received: from CH2PR10CA0021.namprd10.prod.outlook.com (2603:10b6:610:4c::31)
 by LV8PR12MB9452.namprd12.prod.outlook.com (2603:10b6:408:200::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.20; Fri, 26 Jul
 2024 17:18:55 +0000
Received: from DS3PEPF000099D3.namprd04.prod.outlook.com
 (2603:10b6:610:4c:cafe::ca) by CH2PR10CA0021.outlook.office365.com
 (2603:10b6:610:4c::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.20 via Frontend
 Transport; Fri, 26 Jul 2024 17:18:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS3PEPF000099D3.mail.protection.outlook.com (10.167.17.4) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7784.11 via Frontend Transport; Fri, 26 Jul 2024 17:18:54 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 26 Jul
 2024 10:18:39 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 26 Jul
 2024 10:18:38 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Fri, 26 Jul 2024 10:18:38 -0700
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
Subject: Re: [PATCH 6.10 00/29] 6.10.2-rc1 review
In-Reply-To: <20240725142731.814288796@linuxfoundation.org>
References: <20240725142731.814288796@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <6652a0a9-8483-4265-9af5-b2c1b22334c8@rnnvmail201.nvidia.com>
Date: Fri, 26 Jul 2024 10:18:38 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D3:EE_|LV8PR12MB9452:EE_
X-MS-Office365-Filtering-Correlation-Id: 35eeaa0d-bdb4-4f62-7542-08dcad9706ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|1800799024|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?U0ZOaSsxRVphUFV3bktuM0JOejJja2lDQ0o2Y2xjQWlXVTVIOUhPNzVaRVR3?=
 =?utf-8?B?SWRsQjhIdzNRK0p2YlNvdXFoTzA0M0RLWVpDd01tUG56NnY3Um5jaTJuMEhS?=
 =?utf-8?B?KzJGQ21CNERiaG5XNnM0NngzY2o3d3VIb3lXcCtyS2ZqVHJQMUxVN3p4T0ZI?=
 =?utf-8?B?NDJrVGp2YzM0TW1pSlBpZkVKdVlFcXVmTU1PVFR6NFZibk5XeHZHYzZpR3B4?=
 =?utf-8?B?WkhpOXVDNHQ3bDhwbGVQVExOeTZEemwzWE42ZTh3TlVreU1sSWpxM0k2azlw?=
 =?utf-8?B?QmRjbTR6YjZ6ZGhCcGFFVnlBb0lCd0k2NUw0bXVoVnA3NFpuOW1oMCtGZldi?=
 =?utf-8?B?cFBsazR0YUhMRGRDMnJGODg4UTJlN3IzbzRVSEhKSE9uTldTOTRNdTNQQmti?=
 =?utf-8?B?ZHNEeHBCNTlQVVdUamVwWCtwSVdOVXlWcEQ2UlUvK05PaFNTRWNpcjJGRjFp?=
 =?utf-8?B?eVRETCtDYkM4d01CVVZvUjZTbmU4eUxDdG1oWGZId1FMVFlZUGtOZWVNR29Q?=
 =?utf-8?B?cFJxdVB5Y1BqNXgwNW1yNkh1SVptelpBUlJOeXF2NUJoWjU2eDhoV256SzRn?=
 =?utf-8?B?b2paTjl4a2svaExsZm5sc2pMckRFLzdwY3dZSTV4MzU3WFByRGlDZW1YVjhh?=
 =?utf-8?B?MG1IbEVKKytFRndBNmJ5cGJsRzFTYUx6c0tTd2R1aVV3bUFrSW15a3BBNnZG?=
 =?utf-8?B?SndPLzdkc0hBbVlLaG9iYVFvdWJxb2dEWHFyVXRZZmhweFp6SGZrYUNsUERK?=
 =?utf-8?B?SzIwa0F6eE8zdGdrajVZV01OOXc2aUx5VFZtMmJqQ0VxbWFGM3F1a0dKbWtu?=
 =?utf-8?B?b2djMFRBa3UzU3lUNGt6N3Rjdm1NajAyRGpFZVgraXhOSFJaUTViNnRBb0hu?=
 =?utf-8?B?STA3OUJMeXFrR0l2NHRFbjVqSkY2Tm9KYTZrUStXODUreUhYcHNQRFNUZjFu?=
 =?utf-8?B?S0N0OERaOGhyQVlRMWN2M25MSE9oTjFUZnBnRUNSRWtaNHBnRG9PcGlzOUo3?=
 =?utf-8?B?Z1VpK3ZTZmlyMWdOWUhEclpYME5rbUNTTGVScDkvK0tSYkVmcW1Ha2htdXZO?=
 =?utf-8?B?U08wMmRmMEZSWDd4K3FwWjh6WWV3V3BjYUJZWjJ0VndlR2RUTWlJclgrSmtQ?=
 =?utf-8?B?Z2VMOUdYSXdDNUFzR1pYTVFhQ1pRbnRVVGIvOFFiL3BoUFY4TEdlcGROZzlI?=
 =?utf-8?B?UHNKVC9URkZIajVUL0hiMkp0TCtsc0dqODBmNmM5TXE5c3JlWWFJOStmdkpX?=
 =?utf-8?B?MXdtSFJ1Q1VBc2h3OEpkaDBDbnk2L1VNbEF2YTcrdncvN1hKbmk3UlNLQ0sv?=
 =?utf-8?B?OUd2bHFYeTFqU2E4cUJhU3pJeGpUU1V3bXNSaHVWengrRnZidzdwS3JHazQ3?=
 =?utf-8?B?UWpuaGtvNlVsY3R4emtXN0xxNDBCRXM2ZWhOd0lqWFZkMU82Z3VKKys2K25X?=
 =?utf-8?B?ZWdPTWtwdDhIdTdjVmJhR0NJRjAwcHo5NkF4bDVaZzhpTUwzcG5aWVlHVkx0?=
 =?utf-8?B?dUlwME9mdE9UNHlpMWdIejRoenRwT2lzd1dFNW12TE1YWlFxRnBCUE5wNVEw?=
 =?utf-8?B?UG04Z0RSZzlyeEM2TmxsdDZEUzY3bVlES01SajZZNmlDeWNYdDRpckdXSHFY?=
 =?utf-8?B?RUlsK3FkTTIzc1VKdTVYcktrNnNVelYycWRjcEZmUTJLVlVuMWlLSE9TMThw?=
 =?utf-8?B?d3ZxZTMzUDdMMWpjc1BJbVIyNFkzN3NUeUxvTTBxaW84MWlkU3dhVmJQdmVx?=
 =?utf-8?B?ZUNRRjV4NEw5SDVkc1FkUG9iWHlQK2lubW1WMUNGalBrK1J1SXAyMVFDK3hD?=
 =?utf-8?B?U0lRU3B4NE1sTERmbkQ4cGx3ZEluaFk5NFJWRk9VaEJMUVA4Mi9MQzhkYnBV?=
 =?utf-8?B?NDlxSTZhUityby9VeDFzVW94LzIzN0k2OWpmdFgyRXJrRk9CVTRQL0dVQ3RL?=
 =?utf-8?Q?44rUsPL1ZQqWH9UHjKBRM0tk0GJnrolh?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(376014)(1800799024)(7416014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2024 17:18:54.6163
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 35eeaa0d-bdb4-4f62-7542-08dcad9706ee
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099D3.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9452

On Thu, 25 Jul 2024 16:36:16 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.10.2 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 27 Jul 2024 14:27:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.2-rc1.gz
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
    104 tests:	104 pass, 0 fail

Linux version:	6.10.2-rc1-gbdc32598d900
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
