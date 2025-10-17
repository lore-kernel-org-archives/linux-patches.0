Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010014.outbound.protection.outlook.com [52.101.201.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E31F332900
	for <patches@lists.linux.dev>; Fri, 17 Oct 2025 18:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760725319; cv=fail; b=XZOg5qBRV09eXzhlbGJjD48WvZxrHQ/YHTBm/VfiAgTHAMPcFkSE88p7Z0GFyAUA1u9gZ5JaOtwwvIzwLZSrBxUqtFQc0gWImWC83m5SKR52EktkRY6+nV/ZQ9TsP8ptnXwgMMtsyBqVRi3Fg4ZsH2UwzvlMP9vzGpyKp42mT8o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760725319; c=relaxed/simple;
	bh=qU3PbQEvUDGZtdN1EtEsakQeyDIP7QCIr2TSB/o71QE=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=cYrYPbg0MfcJxRUMQvGfU8gMDIxXxnNptlHs0yKai0TknAfeiupELIN1KNJYvC93elVVPSZO69entoZO8+b5ZfsIgulcjZ8KcYjI12vqH4u/5TtzZjLsdzMV20zhpWqFBWq2/FWkp6yn1yWZjCsoVqdtCpaJD/O2XX89jERF5PA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=bjLftBVZ; arc=fail smtp.client-ip=52.101.201.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="bjLftBVZ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U5c6m2rz2fDljMJ+nu7fqlUgfKCI00PzLnZXWgsc0IfCL2aNdYdXO59OHJ6qmsUYqat+C4B5CEXBGGWKvUsEBUlR9nEsAw4D7qQ9Ij7Na14wGtqesODBLrwXnZhMZ2t8QB7Lhq59j9H2TBqnhki6nrxnq3Bvr+X1LXjy7utrBjKk5MpLSPF1rEqncgce73GlkTbEDk4V6Nj6Mls83P9VMM5HBr1albyl4FjdKtQ4FCUWzWHUtpViOReJ5Wkuj+8Z48+wyA1eRR2J/5BnuzaICrJZdWNDNOf478UhsEd37y1ZQ+CZX3z3zVvpOrJ4MClP5h6pco4Y3i+eObGLRmsISg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OodYNZNHRM3Mi7a8P9HlkKy1xwKqzBhA7PZlETDLhEU=;
 b=mdOXI1ndb08JUrwjnGeO449axS9I+6YU/UF/njsUm6H+UVMHRIrgOKerye1L7oEGcuh/o+E1XhaW1U2x3gRBzRt+3GiCWuGhgtzcvfxdLYQb1wdQBJhhSCPlZTlkIg5QJyIA0iuoJaMnPFD6ZJRq34d9Dwsk3/WjjXqLQtWrD/Z/gtrmWVhlfsmmpZaHQohj9Y3NPSKNmJr456Bs18EfanvG+GdWcB79/HFDsB0tgY7B8v1NgLjsfJeXtlkpOgToWqJYUyxOV2MLMlrVlSvC8fIyf7vNTBcKciJPzRWWlI1kJ337UU8f/o/usJ2cqdwHWdZ3On8Yfxz3Xft6N5xyNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OodYNZNHRM3Mi7a8P9HlkKy1xwKqzBhA7PZlETDLhEU=;
 b=bjLftBVZd6Kedl7O3q1OV1AAOaBC4nU+lBQQo4inWX6ENWSvPIoVViGnM6Zgl1na72vheEDQ/0e67yBSLaIRz4+4o5Ubu/ueFemMAG5NqY8lTHhS7MKcDUTTnMYRSPuIg7ZRnBXRM0A4PeiXmRo10b0CfzIFlJOLREmCfk+2AaJkOdPN62w31AEp7SzclV5A/M2zWxIDskDZMVFYWtz6cUsE1iZi0P1ddi3eVKgDU6KLZhbi9Ko62NWau5DcyEUR1rnj1+gpWPTfOChnoY8OxfoYepz2+mpgSb7Ti8SW9ujw+mcY1R21luzNI8wKiJNGRXEJhaWRRsq3u8FT6jWfGA==
Received: from BLAPR03CA0118.namprd03.prod.outlook.com (2603:10b6:208:32a::33)
 by DS2PR12MB9822.namprd12.prod.outlook.com (2603:10b6:8:2ba::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.12; Fri, 17 Oct
 2025 18:21:55 +0000
Received: from BN2PEPF0000449D.namprd02.prod.outlook.com
 (2603:10b6:208:32a:cafe::b2) by BLAPR03CA0118.outlook.office365.com
 (2603:10b6:208:32a::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9228.13 via Frontend Transport; Fri,
 17 Oct 2025 18:21:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN2PEPF0000449D.mail.protection.outlook.com (10.167.243.148) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9253.7 via Frontend Transport; Fri, 17 Oct 2025 18:21:54 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Fri, 17 Oct
 2025 11:21:42 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Fri, 17 Oct 2025 11:21:42 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Fri, 17 Oct 2025 11:21:41 -0700
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
Subject: Re: [PATCH 6.17 000/371] 6.17.4-rc1 review
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <0a345e04-6c9f-4aca-8f85-bddbf7eb7c99@drhqmail203.nvidia.com>
Date: Fri, 17 Oct 2025 11:21:41 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF0000449D:EE_|DS2PR12MB9822:EE_
X-MS-Office365-Filtering-Correlation-Id: 11af3212-0cf5-4967-1de0-08de0daa0d0b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|82310400026|376014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZFVkM1hQc1F5azNQOE9kdnJyeXNueVRBNEVUY2I5Z3lCZG5vdmswK2RjVlR3?=
 =?utf-8?B?a1hPa3A3WFNHREhOVGZ4MlREMWVuWE5vc1NBalNyYTd3S0ZHdy8zMzltZVFy?=
 =?utf-8?B?WHdtR2lBSlhtUmczdmpQeFZCNUVQWVlobXNIOVFLNjlyQ1NyWERnejdGQ2R1?=
 =?utf-8?B?aXI4a2l2Ykt3QU5PYnA4U3FhdUorVFZMNmxUbkNyR0wxV25WZWtQNHY5RkE2?=
 =?utf-8?B?UnZBbnhvMk9wVml2R0VlbTRtVGxGMWdZZjVveDV0U3BHdDZCUkpzNTdKRW1o?=
 =?utf-8?B?clFUY2gzTVBVTDhDeTJrTFI3WkNQOHhTVDNKYmNqZDhESzFnMmM5R1N5QWlp?=
 =?utf-8?B?QXp4UnVvcEV0NS85emI5QWlodHVwVU91cjBkZlE3b0pUbDR4aDU1bHZvc0Jo?=
 =?utf-8?B?cEJBYlFra0RmaG9JZHkyTlhDcloxc1VpMzlMQXZuSWlYZUdCQnBaRjBlZklk?=
 =?utf-8?B?b2F3SitXS1J5TEFnNThTemxJT0k5Y3VnMjdocDA0YlhPdXFLUkJjMjErdEZj?=
 =?utf-8?B?K2VoU1BveTFRRVV0cTE0WkQ5TFhOeVB2Y09TQTZLRnZzMTVvT1NBTEJjMVQw?=
 =?utf-8?B?R250L1U2d2Y0bmhaeGtBZWRZM1ZNZEJtck9Xb3o4eGVPNC9oa1c5UmlTRDFP?=
 =?utf-8?B?cjhKQk5OOFBVV1BtbFVWWGhlL3lNbFBjWnlYRXFHUkdOR1hqMDVTNXVCUVZH?=
 =?utf-8?B?ZEtGRkpTbW5aZnB5cXA3WWYxSzA1aWpLeEFDeVZDWWM4cElrYXJaLzArQlVH?=
 =?utf-8?B?UjI0ZzRIVWdBZkZoSHlTeVZhUGJPbENWODlKQmlUdUxVR1NrRVR3NVRmMHZR?=
 =?utf-8?B?blR4emU0MGlESzFUOG1QNlVjcmFxUW1MOEFiL0xwWXJBV3RQRXhHcmVqdFJ5?=
 =?utf-8?B?SDVtSW9nUzdoTythWEJrcm84dmhjaUoxRGxGMWd4RjZlYWtzRUw0UDFtU1Ro?=
 =?utf-8?B?VFFWOTVmN1BmMEdyemFVcWloTTN4T21nRElDNWI3M0pOVXoxRnV3Z0luMzVL?=
 =?utf-8?B?RkVENFhoKzFtQ3k4N04yUDZMU1VKOG82OG9MR2tFTXluZU03OVZGNTRkaVFk?=
 =?utf-8?B?MklRM3VPaVFGL1BQMDBwaDczb2xVa1J3eVVHVVkyTE11MlgybUhEcDc2enBz?=
 =?utf-8?B?cU5oMXpFRGxSUXlnVG9WYTBvOXFncXVCS2JMY3VFTGRCQ1dxNGowNi8yeGgv?=
 =?utf-8?B?cmVuNklQb2tVZ21JZTllQnBMQXFhN0JwN1BndTVib0dGVDNtZGpYdFZ2YXhn?=
 =?utf-8?B?UmVxbUp0WWN0N3NCYnNyeWgrSW56aklGZE1scmN3QTZCM1pIZ3Y1VjdwR0pV?=
 =?utf-8?B?NjhLNEJIL1dvRE8wd1ZXb3h2TzZVSWRtQTFkT2UyNy8xeDZUQVI1NitCOFd5?=
 =?utf-8?B?ME9FK2tZSWZnRFNYb1lKam4ycjZ0djJ3bkNwclFzc2JmdVRFVXRaUTIwY05C?=
 =?utf-8?B?Q3Buc2oxbGYvSmVuSXliODRIeHhhdmdjZU0xNm93OE0zbFRaSHd2aldDd29o?=
 =?utf-8?B?SGhWV3lJZjVvRGFtZTNkYXBYbWZTUHdiWVUzaTE5bEIyUzNFWUN3M1lKTnc5?=
 =?utf-8?B?bkZkekN1RUMxZDFsWHV4TmZqMG1xM0dRR083dGs2YzNWdUVXbkhQWjloODVR?=
 =?utf-8?B?YW14dHY5M0FuR3gxTWh2MjZZUG40SGVadHFGaWJsSDZYazVpOFlmQXluTmk5?=
 =?utf-8?B?RG40N0lhZ0k2YUwraEhYY1RSZlpuZGxKMlVKVzh6TjZycTR6Kzhya212QmR2?=
 =?utf-8?B?QnBUeW9YelFBNnh1cjFqWDEreGhuZ2pFbHc5SlhCYlVxSWhTcVRsWk11WGgz?=
 =?utf-8?B?d09mM2pDUldnUHR1ZTVCQ3J2WUdvZW1VRk8xbVU3c3ZEYXBXazVYYXdVUjYz?=
 =?utf-8?B?S1JNdlRyRzBUcXFVQVJpYytqaFVQTHExZEdOaWhoNTcrUCtyYzdRLzc2MzNX?=
 =?utf-8?B?SXBYYWNPMVRMKzZjcGI3LzNQWi94aDVuZUZiQWtpODFhTTZySklqYStaRW9I?=
 =?utf-8?B?VFBHR1k4S2hHL1FTa2tsSG1ONnNFTllnWVVRZDh2ZjRzb25KN2xZL0ZHL1FD?=
 =?utf-8?B?MzFCVEoyNXJhOEZneVd1M0dkeUFOc0szdk0rdzZLYk5jbFZ5NFl5Y0dPS1hw?=
 =?utf-8?Q?4VUs=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(82310400026)(376014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2025 18:21:54.5822
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 11af3212-0cf5-4967-1de0-08de0daa0d0b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF0000449D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB9822

On Fri, 17 Oct 2025 16:49:35 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.17.4 release.
> There are 371 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 19 Oct 2025 14:50:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.17.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.17:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    120 tests:	120 pass, 0 fail

Linux version:	6.17.4-rc1-g396c6daa5f57
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
