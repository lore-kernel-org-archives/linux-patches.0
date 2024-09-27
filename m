Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2058.outbound.protection.outlook.com [40.107.100.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69C771C1AD7
	for <patches@lists.linux.dev>; Fri, 27 Sep 2024 18:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727462204; cv=fail; b=GWZkmdd1cNmMIxVMcwxcvZOwYQjOwyaeYUlJN4sFc8jZLkNa6AKOX9wKXTka5q357Jr65jtjiLdQ0+OTrDfFZR6ZtupIScchmvN1frpwkXle568N0yAFHWrc10grQYPsOC9+OwNLRp+B/S4Jeiio3cA99pT+YgXKT2bai4uR0PU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727462204; c=relaxed/simple;
	bh=u+GOlfsYtn6YdWeGYUJ1jYBek5Fqp8KMVookXlhD9Ho=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=JnuOkRHnSNZ6uD4KlSojHY+o27lj9LrLU+/E+CAt4v5wBiwce4i6cSjuQ85hsX5jhSpjL0S7F//Q7mDhRCg+s4hX0o8dl1Bj0iFLXiXAkC1rbzvN4mSVdEx4XYq9IIgD+zHl9GUWmq37LtPRQdgF6c9N5zKfheslsgPCD3bDplE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Ptdka+kz; arc=fail smtp.client-ip=40.107.100.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Ptdka+kz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w3HmA+7e8v2GZZJxi+mhByAwQz4VeM7yv7s2xqSLkdOjFE9k0eiOFJKUD3QeBPZNmI62sqDJMHaZUWsNXk5LL2QB3XNpjaTXQVhXxGqUwzoUvrxasXYCqI+WvZgRblz9sg+/Gus7yLxRGVa+Zl5Vsv21mOhFjpffXlltvxtR6KkR3Ouro/qtZRaYf+0i7Hzpi0yo4hnNAJEYQfI5HLuJQhaZBTFBwgOqYxBJ6Fs/9O/efP9h+1aZuau7brtn6wMU1ykMzIpxQRdFMZT/llVSXItqT7X2qDCuJHX1SdqSDsRVEBg7hjq5Diim+iEbHIbfzP35nPqueM+6ppUH17jNEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6/CJcGs5UDmlJfve6o8o88pyp4G7aJit5emuBIi2Ntc=;
 b=tRr3TYICLNCIBF0PmFJHLSAuVd97Q24dgO059ND6QBkzZiy7Slt6mKCyqgxDNaqscqC/KwSrSnm4WwgWoTUZeVoNwAJpX2P2hjkTe1pj1ZO0G9rvedT8PJp0189us/VpKmDcr4sIdt6FpA8rJ6yfyUI0equsJJjY8nFoqbgujCaSvpqFy6m2iMRW5+lsjXK7bBqNXPWdBSIP2ShtFT1movyKhLnUag7solqJzTpOp96IV0n4U+U/7mSKJhCT10GhDn4AQU+dp+daEFOeU14k7LH98/mMRMuM0a3xDhWadwQIB5oY+lkRakWSl5I9ePn3/JlAstH19y6T4f6TsD8SBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6/CJcGs5UDmlJfve6o8o88pyp4G7aJit5emuBIi2Ntc=;
 b=Ptdka+kz7qShRJUPMnJmWQ1b18LltlJuE2l5bPwiHIvW5dJ8v7lMU+akrMSZIQZvHZL7kit6A/43y1N/sLkACxB1jDD4h27KYAIT5+MCuUzQ7a5tV9L5Ly5q9aZtASN+r2vsvdQCeoiFZo34C4QOlMpazSrfGDeVKZaMF1gjRmtju/Hjy27e1vmjAdahgsClj/0KYyO0qt5Rh5dSeHbc2zaBFgnjeM5mwIMKuzmvShBl7QIiTppV+P03w7aR6UaRRwkH/3O7halD3P39uDyNURcwYu4lwA5eaUAAXPonsYh6go0DeKVMSNOgJsfMejuy1D9sbshGAwwRF0cV0IPihQ==
Received: from CH0PR03CA0372.namprd03.prod.outlook.com (2603:10b6:610:119::10)
 by DM6PR12MB4252.namprd12.prod.outlook.com (2603:10b6:5:211::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.22; Fri, 27 Sep
 2024 18:36:37 +0000
Received: from CH2PEPF0000009E.namprd02.prod.outlook.com
 (2603:10b6:610:119:cafe::23) by CH0PR03CA0372.outlook.office365.com
 (2603:10b6:610:119::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.23 via Frontend
 Transport; Fri, 27 Sep 2024 18:36:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH2PEPF0000009E.mail.protection.outlook.com (10.167.244.27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8005.15 via Frontend Transport; Fri, 27 Sep 2024 18:36:36 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 27 Sep
 2024 11:36:28 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 27 Sep
 2024 11:36:28 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Fri, 27 Sep 2024 11:36:27 -0700
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
Subject: Re: [PATCH 6.11 00/12] 6.11.1-rc1 review
In-Reply-To: <20240927121715.213013166@linuxfoundation.org>
References: <20240927121715.213013166@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <5cdf2d5d-c9de-441e-8908-f2b1a07528e3@rnnvmail204.nvidia.com>
Date: Fri, 27 Sep 2024 11:36:27 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF0000009E:EE_|DM6PR12MB4252:EE_
X-MS-Office365-Filtering-Correlation-Id: 5209b7c0-addb-4831-3084-08dcdf2351e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UjhmK3d1N0xKTnV3bHpUSzMzOUZHZ25FOGpBUDkzeHNmRCtGS0FSdmc3RXMv?=
 =?utf-8?B?QXRZQm5abjN5MENkSUJFb0NyTUZmUzcvOG4zQ3VmZmNzUHhpZ3BydEpXZ0ti?=
 =?utf-8?B?Szc2enJCRXF1dUR6V0dFcnVCZE4zTlU5djU5T0NqdFNFcVpTanJFTGwvS0h3?=
 =?utf-8?B?aXlWdDA0WDBCeXhFeWEzM3dEbnBvZE9La1FQWlI4N0NRVUFYSzl1ZjI1bVJV?=
 =?utf-8?B?Rmp2VTZ1WEN3b1VJYzdJT2JvVmFRcjJMV1V2clVmYlZ1OXBiS3V4bnR0OUYr?=
 =?utf-8?B?SWN2aVM2STFlQWtNdE9pMXJqN2pDK1RRUVNVcWxuY0hQaE9qL1Mwck9OUVU3?=
 =?utf-8?B?RDFEZEkrVTRuQmVhSThyZWdTV3ZrcmduNlJBZS93a1dZalBsRXhYdWlhTmF5?=
 =?utf-8?B?K1VQeHdiK3BCNjBBM09zQTV6OTl4TW5YblBRZWJrRHBORTUyTFQ1amJjVnUw?=
 =?utf-8?B?QjNVQVQ1WjRDcUpQRC9iNVVmUlhxa2lscXBMNmorNEhKOUZoQUxhZEVJWTRX?=
 =?utf-8?B?QnZmd2xDYkxhbkhzNTZKQlNmOGFKYVdpcUV6U1UyaXU1WkpyeXZEdHo0SzNH?=
 =?utf-8?B?cDdINnFydVZjd0RPU2hOcmtod3ZPdlNOVngxVUErS1dOZy9GVjFUMlc3ZGhq?=
 =?utf-8?B?RGJwUndjZDVVTXFoLzFCa1NzbzhvTU5YeW1IY0FCQ3R1Rlp6c3p5WlRGbnI2?=
 =?utf-8?B?eEJlUThMVzNWMUl0TU9CbEdPaDYyUTZCdTlyQ3VCL3J5dGpIeTBtVXVGU2VR?=
 =?utf-8?B?TEJoc0hhWHphbVRuYUthMTMzem9mSk05NURqcFFIdC9qbVhPQytsZlQvUVZU?=
 =?utf-8?B?ekdwd0pSejJ2c0Zrb0N1RzZWTlZYOG50NzVOM2tsZHBmbmJWMTI4eGZvN1Yy?=
 =?utf-8?B?WTFBbFk2NUw0anI3QStob040enN5SVA3Y1MwdHVGV0xHR0ZxYXpyeHBQeEVI?=
 =?utf-8?B?eGhoZHRRRU5GUEI0dWYvVHpFa000M1NXR1RDa0Q4UlZyMGEzVXJBNmZ0Yklj?=
 =?utf-8?B?YzU5Q1psd3RjWFNSMURnNkM0S2FmZTk0bEF2YjZacnpQYWdGckplMUk4OGQ4?=
 =?utf-8?B?STEyYythUUIwVUhHU3hVbC9haUNCWDBXd08yamZDa3BLYnFqQ2hoQVRJc2o4?=
 =?utf-8?B?ZDJlbFdHVUp5bzJtV2RqUUVRbDM3Sm9JSVZtUjEvaGpFRkhVc00wbTRNUTg1?=
 =?utf-8?B?amd0YnRsMVI3MEJ3Nys1ckloUDBDYkZxQVlHbTB5bzBmOGs0TktCZUsvTWt3?=
 =?utf-8?B?T0dweS9pVUxzRUJUUzNDZ0V2U0NBbFRySGl4VWhvalVQMUw5cVNFZTdUVUF1?=
 =?utf-8?B?STZHTHh6NVp6V2FhT3paMko2aXVXaUNjRkNGSURxalpBZ3ZERkp1RUw4eWtw?=
 =?utf-8?B?QTlIZVdnMkdUa2hWd2ltcW5BSktlOHhaeGlJekFlM0M0b2tuK05OUGZteGk5?=
 =?utf-8?B?aXd3SnQ3emFIYU5TZEF1VDA3YVZEd0NkVzAvU1hFdENxS0ZYTVo1UllzZUZj?=
 =?utf-8?B?RU1nNjZWdDRSZjJwRDVEb0tzVEhnOHNJbmJQckQ3dFdrRmNuaFZ3TnhCUXhX?=
 =?utf-8?B?Q0NMY2VOSDk5eHphaWIyaEoyakVmSXUrMkYwcmdtUXZYSVRIaUMySXArTEQ4?=
 =?utf-8?B?Ymc3Y21lWGtWY1pWaDIvTi9hNzNEM1ZiUnhncVNXSlRkMU1KWVJaRy9EaE1B?=
 =?utf-8?B?SWMyTmR3YndGeVRscExNSG0xM1FBZVJyY3ErSlo2R01KN1pSSERMVmszRnk3?=
 =?utf-8?B?c2kyb201QlorSDdPREI5RlhPMFdOcjNkR001VC82bUpLQTBndHlqSU5vbWVQ?=
 =?utf-8?B?MHkyZHFrZUlybC9CQXo3K3FweFNOS3MwM1NBNXowYkpNN0xCbnV2STk4REg4?=
 =?utf-8?B?cG5aNUU2NlJXZGFSclNEZFQwQm55b0RoRzBJR2FIakdQWTlZbnVnWE56aUFE?=
 =?utf-8?Q?s0kGVZ1b9UsAqCz5gvcgHDnveyIHFq8u?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2024 18:36:36.9472
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5209b7c0-addb-4831-3084-08dcdf2351e7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000009E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4252

On Fri, 27 Sep 2024 14:24:03 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.11.1 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 29 Sep 2024 12:17:00 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.11.1-rc1.gz
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

Linux version:	6.11.1-rc1-gcecd751a2d94
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
