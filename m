Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2054.outbound.protection.outlook.com [40.107.237.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8982720605E
	for <patches@lists.linux.dev>; Wed, 13 Nov 2024 19:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731527996; cv=fail; b=JNo6cmE3HC+BsfpQUJms0U4NuEuu5KLj/ZmQbzGXwJmqeCKMmQKOtCNyXGTD0gIwTAejWFga1XofFah4T5orVgO3Rwg1EzESe/7t5xtHVrdRMYxfltb+l57NhGi75yl4rG7ouOZ+P8oC5Cv7NlDft096OIg8pU12ZGTY7MicYHQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731527996; c=relaxed/simple;
	bh=ACR3ZW8ECwn/yux/gPJRVuUEya7e8+Kt1yq2nlE8j60=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=dmhaAUsvC7j3tbRr0dvNTycMNR/c90M6XeIK9NOFcJNmvPVJ25pJse+TEZw0rOSLAl9C3/Usj8hEp8lnrr4HF650iQ7c3c7WJVFc3sTp9ZvLKdoQP72pHs8H4taWh8B7p/nzorz7qrf5PclHoCkIL6zvayH7rFU2xAOYMJZY5n0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=iotk3lXO; arc=fail smtp.client-ip=40.107.237.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="iotk3lXO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y+oFWwyAAIWNVqQoOClZ3Pyfyse+EKQT/zEQS/JEbh3LkAGKcj7YNk78cwSvnHUBLgTPSXRONaSsUOqDpIIM5cIIF7O9oHCZ0rsUmm14tpBcH9CujbmnfSyGtW7YCPWT+CGeDqLxjxEMlAS3GD+mT+P99pVfY8+6wiXl4lAjyc3ET5TBWFn73d59fz0GaFr2kd4wYo5tXuxGKctfbcg/s7VXnEP/j7XPBdkuiSfaBtissq6IT91eIacLVfmS43Gn0mjHM5GES/9btJR5STBjHsM+oUpbzNMa5KYRatBDLz0LcG4kSk34M6AjTCPUnfmgP3psyRZv1llsItMXFD2E+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AA41M/uw4W+ULHMM7LWWAlKQvQWv/jw/rnH0mob9vio=;
 b=b3wgr2eNdYTCw5Gv8boQzmschKdlhv3GzFXz3h5GW2G+BYf5z+zRCR/u/CNVr1m0KiT8nYzmKfcCcNfYsdWPQCk9m9g7H38a6iD0o748LeKZ94B0vYpIinusMqWRaolZZbMKdpGHGo3xTnW0Rkk2GWZjtdcafbLXJwQRJC5ZmySgR2V+JRoJ2uFUdll3bycga8dAnBfLDatskQZeaO31rL3kyDJ1AMpHxnTffhLo0oTjgHoymlYJZQp4pBB7AU1PTleu3AdkxQr1Z4MubOGaaNew6Id+qjgLj+PNYkFUHhsqmHdGYph2cJo7FiNezz8JV39V0mkMpJ2JiaDrUjAXyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AA41M/uw4W+ULHMM7LWWAlKQvQWv/jw/rnH0mob9vio=;
 b=iotk3lXOOfBQA6IBkJZSxkxuI37G/9WYt7FzMpM4oXmeyu+jy17+o6A4iej4TdGQasHVBYHaizcauxd+VwmWarorzqD8pLtYm836Y6RJLLb/4C838L8VKjJPVNB3WcZTlgUD0Jxpf2YzGrGn1C6zUoe0xiv/r+nqfiQCrEc0HA5jRGcEmKz+KKAb9szBY7sv1BgQfuJKXUPrE+vBJyUFm9uCMPoAPIg50fHO5GIFpXyGTo6pF978eJQCgO8ODMD7S5LUf/ftYVkc3PSWTMbk4UtKh/1f7psijdTcm+yE3JQbtRwENtP/cRBXWWyroz6zA4MiJRkJAZY4fO13HNkGXQ==
Received: from PH8PR22CA0002.namprd22.prod.outlook.com (2603:10b6:510:2d1::26)
 by BY5PR12MB4050.namprd12.prod.outlook.com (2603:10b6:a03:207::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.17; Wed, 13 Nov
 2024 19:59:49 +0000
Received: from SA2PEPF000015CC.namprd03.prod.outlook.com
 (2603:10b6:510:2d1:cafe::b9) by PH8PR22CA0002.outlook.office365.com
 (2603:10b6:510:2d1::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.17 via Frontend
 Transport; Wed, 13 Nov 2024 19:59:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SA2PEPF000015CC.mail.protection.outlook.com (10.167.241.202) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8158.14 via Frontend Transport; Wed, 13 Nov 2024 19:59:49 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 13 Nov
 2024 11:59:37 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Wed, 13 Nov 2024 11:59:36 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Wed, 13 Nov 2024 11:59:36 -0800
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
Subject: Re: [PATCH 6.11 000/184] 6.11.8-rc1 review
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <574b5a81-6eef-4afe-81f8-cdd90fe9607b@drhqmail201.nvidia.com>
Date: Wed, 13 Nov 2024 11:59:36 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF000015CC:EE_|BY5PR12MB4050:EE_
X-MS-Office365-Filtering-Correlation-Id: 2da423ec-c547-4c82-7a8a-08dd041dbae1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|82310400026|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dXNnVmZ0RTdIdnRaaEhMSUFPcjI0VnFxT0tuT0FKTk1sU3JicnREZWhqb1pG?=
 =?utf-8?B?ZjFVOVR2K1lRQ0d6WHJodmpOemNpaWpNRU43YmlWTVR2bmx3RkhLeHh6cGp4?=
 =?utf-8?B?YW5IZjVGMUhGT0kxbnpCNjZMeHpRWmRaZEZSdis4c0FSSjIrR2lvT1lQNlp2?=
 =?utf-8?B?M2lpQ3hGODB2ajFhVG1DbWRxTlVScklGM0w2dFZGbzBZV2RnNVBZQmlQQ2dj?=
 =?utf-8?B?T1F0N09PWmhSR01acnVWQi9jd01SWmNDUC9oUkhQdUZBWE5SZXEyaXRVcEVP?=
 =?utf-8?B?UWlBcUkrOHpoSVFUMlViblpZK0o1aW1EVXJKbFdpS3V4eEFESlhDRnFWRlF0?=
 =?utf-8?B?OHo1djRhaDhLS2I1S1pISGhCb1NNbWkxdUljY2ZIYml1VUhXeThWUUZwbXhV?=
 =?utf-8?B?ZzhJa3hVQUc0bFhyMUJ3OHVIUyt5U214d3cyTEtyMkswbUdBOVFiNFhyaGNr?=
 =?utf-8?B?RytzamJHeDZnSkE3NVlCazIyOU1FVnlPa1pJUlVqMGhwSFJ2Z0RnQXNycU5j?=
 =?utf-8?B?UUtkZm9JcldDR0MzK2d5NDRlUEVEQ2VvL1dxTlN2SzBoMkpaWDZhbGo3RHVS?=
 =?utf-8?B?cGlWSGoydEhkTlFuc3JlWElnM2ltdWpqYm1wUWdaeEF4TFlWY1J0dEVZaGth?=
 =?utf-8?B?L1dsWW82bXNJWWc4NmQ5NGhWcUhMRGZEbTJTdDluV0hFR0hxY3ZHbUR4Y2Nn?=
 =?utf-8?B?TXlta3BJWkhEK0tTVlMyYS9MNmdLOHBtUk8wd1VoWm1GaktPbWhHeG4wd3Nv?=
 =?utf-8?B?UjZ4Rk8wc2Vod2xqS3NEWHZ0ejdBajR2TWViWmI0N0JPTFlCZG1OTUJDZGJx?=
 =?utf-8?B?dnZjYnRwWWlGRjBSRWM0SU1ZaVphd3RIcFR1NVIwV2dzc0lhdVZnOTZ5YXc3?=
 =?utf-8?B?dEZRSnhMaWM1cE9UUkJlMDZtejhWd2tMR0tTMmJwRTFPV3ArU0NveXExbDlS?=
 =?utf-8?B?bWRXMjBsL0NoczVTcjhVVk5qd1FmcDk3NHgvOSt5Rk1rMWZ5TWVrclIyVUt0?=
 =?utf-8?B?YnU1aUhOYW1vSmNpdFZnZGdUOGVVdmRRU1FVa1lTYlU5c0pLbTVQVFdDUVVx?=
 =?utf-8?B?YmtKSUJta2RnWGVSY2FZRGtyWExGMlB1NDJ2TjgyZk9VVUUyVnBnTG8yQTVC?=
 =?utf-8?B?RTJ2eEw0UzBsejF0ejRIM2lyQzRvRytCYXpNMFVpNUJtdkJ4ZVRZeTl1NmdO?=
 =?utf-8?B?SWY3SC95Z05HOU5hREdJQjY3cWJmS3l5Q0Nta1cvdkpjOFlKdXBhT2c3alJL?=
 =?utf-8?B?TnpjbWNmck9CZEpHQUpOQ3ArdGRLSFcrUDYwK1R0NFpiRDRtNXNVcWZQd2Jj?=
 =?utf-8?B?RDQ4L05LeFhEd3g0TTFSc3NORjVnWVVnM2pvaUl1alNhNXJTd3dIU2xNWW5E?=
 =?utf-8?B?NmExdDRzUFFkMzFBMjZzOFdDUEhFZk45Z3RKaFlCSE1VL2FuM0VRRDdNQ1hR?=
 =?utf-8?B?SkRaU05SbUVXdG1MN1hQU1JRM3VwejhjUlFSZGZNZnN1dW5vSTc1Mk9pdDY1?=
 =?utf-8?B?amJmQ1ZXSHVoL3NQSk9YQkpBeUdRaDF0MzF0QnJlRmQxMWRwL0MvVXNWREtJ?=
 =?utf-8?B?QThIdURyYkZRUUFURlFwMUM0Qk1HK0k5VGhscGhlbUgySzJET0dVaytTeWJa?=
 =?utf-8?B?MTNmVkh0SXZQQU13QUErYlZPelVYRG9TR28vNFpGQlYreDhtbUhFY2hzM0l3?=
 =?utf-8?B?MnYvY1h0N3NvZC83MytPQXNiZEp5NXY4VzFORzRvK0R5UGJwMFZpZHdmc2Ro?=
 =?utf-8?B?dFR6N1dlbEFlQTVrM0xxV2szdEFKT2xFRnZlbkN1d3B6bkdhRW5wR3c0bWtY?=
 =?utf-8?B?dWJMN3daSHNhTm5XdDA4eUJTQjI0Z1hnbmsrR1c1UDMwKzFqWlBXaG8rOW5h?=
 =?utf-8?B?dlZXNFBEMDNxNEJuQXQvNnlMNTZ2Zis1M3F6MFp5L0JBOWc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(376014)(82310400026)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2024 19:59:49.1130
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2da423ec-c547-4c82-7a8a-08dd041dbae1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF000015CC.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4050

On Tue, 12 Nov 2024 11:19:18 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.11.8 release.
> There are 184 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Nov 2024 10:18:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.11.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.11.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.11:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.11.8-rc1-ga5b459e185d1
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
