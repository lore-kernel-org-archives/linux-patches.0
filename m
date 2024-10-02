Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2060.outbound.protection.outlook.com [40.107.237.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8E561D14EE
	for <patches@lists.linux.dev>; Wed,  2 Oct 2024 18:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727893997; cv=fail; b=N1svCTvfdZMduj3Oh3yU7TdH53Bk4shAOCc660C+A8FmLJo19+LzO1PtMXI2OSgrTSiq2/DcxnCdgmAKrMs9IpjEIwgLRTKt6JAGLGdo29JKKwIH+dmH7QzCBRBbjUMJx3N1F1evhn/b5KaT9pSc4M8lAoSbHHf0pODIEVvFWUo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727893997; c=relaxed/simple;
	bh=g50vwNbRE3nVLvuz7WzF3HbJsTd2S1Hjl7QbRAeugig=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=BEd1bXJFlUzqorLrr231ZNTOfx1pGexu3T8DmJmAIpgU7GyI2WLDDxdCzsLLPe0zEqII8CNHK/e+l1sKFk9LHhdDklNCM9F9zF1ThrEjEy1sImFB9tZ9SNdPbyQMXSDggocBTjs6jD49Z61mHuOdcIBE3/DlXP4XXoUSVcFVxvQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=J+c4JxlC; arc=fail smtp.client-ip=40.107.237.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="J+c4JxlC"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=exNJtmiWZuyTdrhAyRbOatcVhy8vDIAhOve56ucWynUrgMk46v9p4VVn0l2+4Nd1mkS1U2qdUPWwSd/gDxAH8Gv6ESB2ST/MqqWZR3DbXnyToiyaoKsmUR/OWFsMtHv8mABCFcw6fEl3kvOeEer3vcLwOIrq9dGM3iJCdfmRNqf+NqvW//MH7Y5XCfjOe51YcVCFFgLwO14o2QVCMeImXnsiaj0eeX5TsBTrc4H81pr/zAGyDvG6TFWZKt0F5aRQ/+Beg0U93TjrpSFiZsuD9h5kbXeeIQyAVyFKB4MfDGeWoVablwEcMkIklJTVCO5gr5NmvISbMKpQAbMgkZ9wcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WkdN+5bnisouiUnU01m618YJKluN+axn7pSfJDM090Y=;
 b=Dsl9QqmmjlSrcb6hWBtS9nHgCV1dX/Z8AALnTnXRP90hm/6JMkrfTr8C1jR6PYoxtCO6AokwN2ctUi0aA4UWE6mjyUF8x3tcgA0M1MSrnfteK6oJjUJ2j+mL7P9ky7LfC9XBKjnDOxT7/Z/ndw1RNoyXCOPEr44RLlcAq+Re/KBV/eVeMrs9XZTqrFjU616N7/tx/y+O2FiTxVU0mk2wwPiVWRA9+hXCosJ6weqa0VJhkT9gX1jLIRDPgkOfU+I/cFvq8o1rI2133bu7YgwPRuHc7Ei0YoSqrJbBLRwZzGBHNCdC3ORVVU5VsY1OQifAZEO+/gSrRmPfdGbWZcO3EA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WkdN+5bnisouiUnU01m618YJKluN+axn7pSfJDM090Y=;
 b=J+c4JxlCN02nfRUS94mPp9QvLjEeO01w40L2q/Z+QhIYHWpWsm7MkRZwLDejukwkIRnLxS4E6fVsq0cFX0oXMidFDQL3kK08zw1v41FXn0t/4eGMvxkKMerK6qpXe2uJ2fcIsHKf6RJPfkGtK28Q2VrTdXWwy/BInDSrYYJlAl6UYteZ2BZH3hM4IJ4Y8QgEgWSYPMwhhGclHmULSqmKZ4Zcr5oI58+TCgTYfGZ6N2oq/pAt1rSnDq6uP9eHDMa9MN46T8+Eaiszo4QM8RUGHZZOIQPa2l/hJlAeyKpLFCz3xRwFfOQJgw0MSeMQ2etPi7DGLWvh+NtYRnZJLB8Rig==
Received: from SJ0PR03CA0069.namprd03.prod.outlook.com (2603:10b6:a03:331::14)
 by DM6PR12MB4386.namprd12.prod.outlook.com (2603:10b6:5:28f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.16; Wed, 2 Oct
 2024 18:33:08 +0000
Received: from SJ1PEPF000023CE.namprd02.prod.outlook.com
 (2603:10b6:a03:331:cafe::4f) by SJ0PR03CA0069.outlook.office365.com
 (2603:10b6:a03:331::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.27 via Frontend
 Transport; Wed, 2 Oct 2024 18:33:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SJ1PEPF000023CE.mail.protection.outlook.com (10.167.244.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8026.11 via Frontend Transport; Wed, 2 Oct 2024 18:33:07 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 2 Oct 2024
 11:32:52 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Wed, 2 Oct 2024 11:32:51 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Wed, 2 Oct 2024 11:32:51 -0700
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
Subject: Re: [PATCH 6.10 000/634] 6.10.13-rc1 review
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <895bae68-60b9-435b-9c37-99ac45020a4d@drhqmail202.nvidia.com>
Date: Wed, 2 Oct 2024 11:32:51 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023CE:EE_|DM6PR12MB4386:EE_
X-MS-Office365-Filtering-Correlation-Id: 94b5b991-7fc1-45eb-f69a-08dce310a8e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700013|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZDk3MXQzOEJhb1ZWaWNTcGt3WW1VSDRnRnhNWjhCZG9Wb0VQa2tLSHkwcWtK?=
 =?utf-8?B?c1NGdVFBNFdOQlA1VXNrcG9MdEZaUE81ZUZvaWV2WVZGVmVEQy9ZeGJTaGd0?=
 =?utf-8?B?elN6S3V6RnNqVEUrbEJ4UjhHNURLcDFIOFFDUlZJTzZjT25kcy9RREIza1Uv?=
 =?utf-8?B?TTREQnkvcjJQMUxWdmQ2MXMweldaSDNsVUZqZmhBc1I0cDB4VDhLQnVHUGUv?=
 =?utf-8?B?M1lTOHdHVFVMQWRYM0NZWlczdWN6YUJCeTRLNksvY01VOEYxMmdQQ3RXMTVO?=
 =?utf-8?B?ZzN3SzB6d3Qvam1rRmZoSG5zSDlqYXUyVlhRT3F4SWZFM1lTUHRTcmMyeUVy?=
 =?utf-8?B?KzJGTFFaUlM3WDViQ0ZkMXJLZFZ0MHo5VDd0ckJzUW83eE5kOG5HcHlGc2RF?=
 =?utf-8?B?ZmZia3loVkthVzFzV09ibWkyTkxPR0tFbjVadVUzeTBMV1RmT3hFcXhUbmd4?=
 =?utf-8?B?WkVPSU54cmJuT3NQNldXSm4zVDR1S0xVbThtNWVITk1QUXhDV2VSN2dsUjFY?=
 =?utf-8?B?WGM0OWFjWFFLT0doNFk4SjI5djVxSkdJNzFGcDAwZ1V3Ui9aZlV5YTN5TlRj?=
 =?utf-8?B?QU5zeFcxRkp3TEhZQ0diMFdHS0NsQWErN0doSzY2NjVaU2V6clpaQVNZTWFt?=
 =?utf-8?B?VDFCM3lRdXljUTI4SEVucmpwbHpPSnZ3cFdjSXZKVVNtUzJhcDhGK1ZpRFBr?=
 =?utf-8?B?aFkzdFB1aHB0N1RnWDlqNFlia3ZjaWhwMWE3azg0U0E1NWVST1VJQUVOTXJw?=
 =?utf-8?B?aXR2RWtaUzNyVndCUEo5dkw1NGczM2lWb3Y0SEtFN1hhbjJVRjlyUzc1aklz?=
 =?utf-8?B?NHc5U3lvTmZMa2d6OHdRYXRiemExd0VUT1U1OG83WWMwMUIwS3NpWUR2OUtM?=
 =?utf-8?B?YzJHYXptRktqSlF2NHQ4SmJ3S1lWbWsyeEtuamRrYWlkNytpQ3NxS21zOFQ0?=
 =?utf-8?B?dDU0Q1hDdmcwV09FSFNSeGhTVklyODN3dEFTdmdqRVRacXVTSHVMVldSQ0xK?=
 =?utf-8?B?Ym1yS2VUWU80cFZpWVlpY0crNlJqWkRjdmU0RU8vZ3hndHdXUU1yT1ZkeEJa?=
 =?utf-8?B?QjdjZFA4VmRXeCtUTXVLRUVlakZHbTZHZUdQQ0pvZGZTRGJycjVUWG1uQ1Zk?=
 =?utf-8?B?bmZmdWxFdnc2Y25sdmpKVzM4cFJYR29sZDNhZTZja1AvRWNRRGtCbTYvN0NC?=
 =?utf-8?B?b2NZeFVGZ2ZlcWhTNk1qQjdVUCtrcis1aVVibnVSbnpEb0hlaGlYSXEvUUFL?=
 =?utf-8?B?Mzdnek41V1ZMNURLUWJjeFZzWHlkd0crMGsyQnVPYVJDeThKNzAzWHpFajla?=
 =?utf-8?B?ZW54YTJZcnZ6Wnh6WUFvZ1lRbk5rZmEzaWxsMmVSakF0OWVOTlhleGtJb2Ux?=
 =?utf-8?B?UjF4VTFSa2NuYjlKQmluTW9nMjlEZVgzK056WFByRElJOEhrZ1U0UVU0MEs1?=
 =?utf-8?B?UDhYYnlhcVpIM2Flc245M0lmdTB0SVdib0FqWFBSM2NSbHJINFJvdTgveTNF?=
 =?utf-8?B?WHNzWmFJWnJwemxOSEEya0hVelkvUGcwVGV1RUNJQ1ZIa2xEUGhMVmNialBE?=
 =?utf-8?B?ZTUrUHVLeVNiQWkwdHBIVEZFb3UvMWFQczRVT0tHYlhheDJkQldxZms4N01Z?=
 =?utf-8?B?U05XbGxiRVVmK3JNSHJ3UXdJaCtubDNhalk3cmlXRUJHclhtKzFVY3VKeVdC?=
 =?utf-8?B?Y0RnMTBiMHJsUFpjY2hVa0lyejYxYmdYZERMbTZmR3Rxd3Rvd05XVmd0YVho?=
 =?utf-8?B?TkpzRmtURThlK3VWNUN4Z2RRUXJpK3pwQlNvYUY3QzIvUC9Qa1VQVlloaytP?=
 =?utf-8?B?Q0dGR2J6UDB0VklCWEQ0OHg3eFUyTFk0MVlzMlRRV2RUdzlzNXhhbDRZNTZn?=
 =?utf-8?Q?2x4qsmeTi1JPG?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700013)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2024 18:33:07.2145
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 94b5b991-7fc1-45eb-f69a-08dce310a8e6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023CE.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4386

On Wed, 02 Oct 2024 14:51:40 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.10.13 release.
> There are 634 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 04 Oct 2024 12:56:13 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.13-rc1.gz
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
    106 tests:	106 pass, 0 fail

Linux version:	6.10.13-rc1-gf5f9dc8965d5
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
