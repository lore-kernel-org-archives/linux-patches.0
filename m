Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012042.outbound.protection.outlook.com [40.107.209.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8886B34C994
	for <patches@lists.linux.dev>; Wed, 22 Oct 2025 15:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761145554; cv=fail; b=mvU0/DDIdKNay4x87Y/HXdPjM9RQtqufloQyZ2ySsvLDURjtSJrx9ml8A8fQM5PG/gll5QfbaXlbFlHJt/MN/KwQHUi3yeN4M7DyOtwAJlBhN4BVsZvyuDPFvzRaRYa+m7LExlyrvdTs58OfSL7espX0Ee582uxb2cwIXr+6uXM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761145554; c=relaxed/simple;
	bh=DAnpa6QAPZ94YsClP66Lzcb9Od8oOeNW1O+ztS6wOhY=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=VWhYyVBZ0mR8YJd+5H+2yiHBdP4t891HWIPfvudiSa72lPn3sNpHLQGkLq+5MatOxrAjWgyI9/VOvTuq0V2YZCEXWXPJT7YPsj9zx+mmVtZ33xQ+vmrBGsuhjUz5/fG8TDLZEjuJjrhBn+lbySrod4rJtJIaFoQiquVdd8KWv2k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=RnhNOxNG; arc=fail smtp.client-ip=40.107.209.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="RnhNOxNG"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LupYF1BqXQAJFnpJo8JtdE6yYwjk97uD/CZgsoZnvH9SKYs0Qs/7sX76dpMjvLPakcEcy7RytT2VY+jAUED3B7/Ith/KxC7taxVBh9cJX181/wGclEAcq4KYmeMWyjstAj/3MnpuC7zStfPnW1V25AKB6b2R7TrVk+tEmyZnSiCC4xhO3ghTXI2VpayNKCIkuBGkVu/wKsyBdvKhuVwhVxHpqB0MF+pd7wTnHDVD/raHHJtDTOp1ObPODweefy63BlM2DNMKj07OhQbinokTjEi5oTtBy61U6e+z9Y2EONF24dM/QTyBG74AezPI9XIeTKG+Wh3OTPEOxlbtb1hPjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E9S7FfN0BJmtykzzp94v9InAbGmuhFHyZyR6uLZJmYY=;
 b=Bq2Rxz7UgER3yh0w2vlyX2QNzE/yI1sS7+hWJYugv+xpIBcYDNeLZLFkMZleBUi7sAMxhfIASdn9CMx+94pWzrSZCgOMiyWu7VyY3TaNA39bQ/sCQYafiCXunBdGPGTE+8V0r3Dr9DjQlJc/S+S/JPwmUr4p0Ubww5Oz3M2PgDRjxSin5km5fUnU1z7+nf4w44mTLQY7/G6NAuin3Tu+0SUWxIj4K6jyEcA6mtvGyovu3zLVycPh+zaSzeO7FTcsAKs43DrlRp7hEt2NjEUEKVZpzsPEisxx7NzdOH3gynTesCTy+V0TUSMZ7Ki8WviyUmZ+uHOhr5IGo9dacxyBOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E9S7FfN0BJmtykzzp94v9InAbGmuhFHyZyR6uLZJmYY=;
 b=RnhNOxNGWphdn9iYICwXADLmxWW8LVEV2XHnsZgOr1iQT89XHMA0dM7urXQQ7mIChtoy7bAIt5ibw/hNmjDU1WoxFd429ZjzX9Z2BZAUFI3CZgCoXzn8pJgbJN2DMUXisJtJUZpHiu+Jmh5gS7U8Ak0dJThnr7Wsr3drYJZkgPsZZYGu9x0BJzozhqL/WEtqHQsypIBA0WdwTp8a6c7FNdHLshCBxToBs72LhGmqC0YQle+1AXrZ+eVkvBVUmpJ0HkTjcfH8XRV0vVHNcOJwuaM82KarazM59sA/aVp8avHmAYvrOU2lED+/bBs+Xi1t0Y0SVYvVX+tfglJOUzz9tw==
Received: from SJ0PR13CA0141.namprd13.prod.outlook.com (2603:10b6:a03:2c6::26)
 by IA4PR12MB9836.namprd12.prod.outlook.com (2603:10b6:208:5d0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Wed, 22 Oct
 2025 15:05:44 +0000
Received: from CO1PEPF000042AE.namprd03.prod.outlook.com
 (2603:10b6:a03:2c6:cafe::ab) by SJ0PR13CA0141.outlook.office365.com
 (2603:10b6:a03:2c6::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9253.12 via Frontend Transport; Wed,
 22 Oct 2025 15:05:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1PEPF000042AE.mail.protection.outlook.com (10.167.243.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9253.7 via Frontend Transport; Wed, 22 Oct 2025 15:05:43 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 22 Oct
 2025 08:05:14 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 22 Oct
 2025 08:05:13 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Wed, 22 Oct 2025 08:05:12 -0700
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <rwarsow@gmx.de>,
	<conor@kernel.org>, <hargar@microsoft.com>, <broonie@kernel.org>,
	<achill@achill.org>, <linux-tegra@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 6.12 000/135] 6.12.55-rc2 review
In-Reply-To: <20251022060141.370358070@linuxfoundation.org>
References: <20251022060141.370358070@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <a5461269-7a7a-4c91-a95a-0fd3b6777a05@rnnvmail202.nvidia.com>
Date: Wed, 22 Oct 2025 08:05:12 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000042AE:EE_|IA4PR12MB9836:EE_
X-MS-Office365-Filtering-Correlation-Id: 096d0707-31d5-44e1-6180-08de117c790b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NWVIdnc5UnBLeEN6NVlDb05RV09kNVd4TmVCRE1sRXRYYXRib1JWZUVENll0?=
 =?utf-8?B?RlZPMWIwVXZzZmxoUUE0UVA1a1dJMEtuNlMxaWFaMG9aTFhJMmZJQWJEYm9J?=
 =?utf-8?B?dDFvaVhoQkxPT2xVUFZFbW9YS0V3THFzWTR3OFhHYktLL1grL3BtMzZOV1FG?=
 =?utf-8?B?S3c2VWhoZUVCSmVlTFFXbzJZZXNFWEsyWVY2Y2M0VUN2a1RGTG55RGFWSC9K?=
 =?utf-8?B?djhCbXRINUtPdVRUMVMxTXFMTFBkc29OcFpwK2U1S2ROaGpjMXNZM21KbEkv?=
 =?utf-8?B?aFpDdDZLdEZJZ3c2OEpiMk45MStTRUhJOFZ5RThFYXNPZi92TUxGa1BlVWpY?=
 =?utf-8?B?SkZpekVrWWdKZnhrYnNUUXIwK2tVdFNkaDJkWFpSSVh3OUhnYjdZYXU5a3Jo?=
 =?utf-8?B?OVRUL1B0RUlUWjdRL242SjF3Y0szUzh3L0ZiRXlzMlR6OHJ2SG5HL0NHR0xN?=
 =?utf-8?B?cU9FRldwWXdweElIN1RxWXc2YUlLWUJrS0ZwN0NzRW44T2NZZTFkWFVKQ2Ex?=
 =?utf-8?B?Vk90bDkyc2d2OWVHSjNsaS9INFJJMEp2KzArVWhqTnkrM2lVT3RpdkFvUzBI?=
 =?utf-8?B?RkFNWlhvS2Z5aUQxL2FXejhLZDBPVEdaVmFDalNuK3REblRqYldTWDZWMEJW?=
 =?utf-8?B?VGM2THFHSXExQm9iV2gxblZ4MXg0K0NYaVE1SU1jZzhLYUF0M21LVGNmOTMy?=
 =?utf-8?B?U1owcWFoc3ExeXhxVDVTeWxqL0hYZkl1SkxFVU5tT243eHkvcnE3RDNoVkVw?=
 =?utf-8?B?ai9WSjg0ckdjRWJuNUV1VXdBdWdsdUlhNVBFSU91aEthVkJpM3hrK3lVODdV?=
 =?utf-8?B?eHhCNTV5akxmcGZrZTZmclptdi9TSGxSWU5FSWY5ZVRLTlVEMW5FYUlrRjhx?=
 =?utf-8?B?Tll3c2RNN0h4cFRNaDk4N1JHL1h0TEg4MlRaMFZLc25IVytZQ1RmYmJScEY0?=
 =?utf-8?B?R1ROUFJlNlZBcWdpbEQ0NW9TWDlNYU9vMXRMNlBqZXEzL1ppR1ZLb2NMUWdB?=
 =?utf-8?B?WGZFWDFXU1A3QzRTRDVnOUVHL2VtVTYyN0MvRmF6SzMyM01wU0kvaVZ4czE0?=
 =?utf-8?B?TTJuUXpNWWNsWU9hWVpoa1ZmaWRxamdobDBCUXlYOU9USS9ZdU44bGw3cjFC?=
 =?utf-8?B?bURmdk1kUVJYZ3NyNVlBY1ZQOGVKVm4xaXNKbzFmZ0RDQ1hIMS8xajlkMlZm?=
 =?utf-8?B?OGEvMGN3SjBJSFJqYU5zd0lKRmlCYS9PUDJVWE5wMTBGaUhoUnVPS2o5aHFt?=
 =?utf-8?B?dzFkWEVZcTAzNkV1bjZSdC9yZG1QZDdESy9CeVRCblVEK0ZWUHdjZXJHRkZK?=
 =?utf-8?B?VVN6RE5rNzZLK1I4MkxlNkVmU04rd2trL2VodDY2REhBRDZPQkp5WHU0ZnFi?=
 =?utf-8?B?OXhYdEp1QTJraGUwR1B2Q0hqSXltZEYxZnFUMlFRWTAzWmQzT2JoR1FKUGhQ?=
 =?utf-8?B?V2hsRnNmWWpSOEpYdm9aYzBBdis4UG9CQUFIK1hkWDdxZzJORkdVOGNzcHRM?=
 =?utf-8?B?bWVaWHhwYzY3dzNPakY5eTJ2UmVMRGdlVGV4YjV2UUlkSThPRTdDSjdYbHpN?=
 =?utf-8?B?M0Q5SzJCWHYyR1g5a09vK0lXdGlJNGtOMkcveVRqNXVCQ1plckUyL0FLbGtU?=
 =?utf-8?B?S3JXd0I5V05YWWdQa0lFWWFCdU14eGJmci8zM214WGE4VE0rS2xlbFptZUln?=
 =?utf-8?B?ODNmY0FZMlZUQzlyQzQ5N2ZEZmQ5TEVaLzVkQUh1YVhGRDRJZHQwaU81bVRZ?=
 =?utf-8?B?d1RMMUNtY3plVDBadVN1YjJXdTRHY2piSGMrTlZWbysvV2lVZkw4bkdaTFhI?=
 =?utf-8?B?bEtzY2NxWWZSb2dFSGVwNjNGQTJ2T2tPc1R4b0xCZTQxVzNiRm4vb0JvY0gy?=
 =?utf-8?B?aGwwL3FDK3FvbFBwekpFWEZyWmF2UXMwNC9tbGNZQit4dzRQdVlZcnEzb1px?=
 =?utf-8?B?L0F1UldiSlBzeElUK0o4WEczZThWakRGTVZaU2hQdDlsQ3lRTFprYmhNN0NS?=
 =?utf-8?B?K0Vja1ZYZFI4eldIZWtGdGNtaDExZXdCSis0L0pOTWk0QlRGalU1a0xkTUFw?=
 =?utf-8?B?Tlh1M3Y2Rm9Rc3FKVlFPWkhtZEZvTFM5dzc3M1ZLL2dhVjk3NXg5NHl5VlA0?=
 =?utf-8?Q?ezxE=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2025 15:05:43.6107
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 096d0707-31d5-44e1-6180-08de117c790b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000042AE.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR12MB9836

On Wed, 22 Oct 2025 10:19:29 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.55 release.
> There are 135 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 24 Oct 2025 06:01:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.55-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.12:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    120 tests:	120 pass, 0 fail

Linux version:	6.12.55-rc2-gbd9af5ba3026
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
