Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2057.outbound.protection.outlook.com [40.107.223.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E003620EA3C
	for <patches@lists.linux.dev>; Thu,  7 Nov 2024 13:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730987013; cv=fail; b=bJE/k/L6ZBbpGWVmbDf9yxNHmJ6ZhjeEw9ucoVY8t/U/j8fy4dUVJxm8A20YGM0ELC5FWf0LThHsdM8ikfOIjBssWFmOGrdKwnh/Bo1Ee0iP1MiCyEq7xfGo2qQMvZ3ALYEexpvQWbOULHqxTN8UylAtPMFaQuJrAGNRyz3ShbU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730987013; c=relaxed/simple;
	bh=s4KlbI3EEZT9FXUWs9A+PVXvZHEQ3u+hISC2TDPtXBY=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=Pd6ogtBzd44GR742GRlAx5hPf89sh4fTqRa/nBnquJNSqZcY0hBcL7UeCmwh4kD4oVfd9jomTINdm6/B4jy1+qTi60FkSRD/KdJ+K50PVoZTuPapzcAL8ZgoPr0HLGBrug8IpfISWjYso0HeKpt4EYRNKRKbv2cDclEwKNz8rLo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BCpPFDx5; arc=fail smtp.client-ip=40.107.223.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BCpPFDx5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KI4D55sNBTgjB5OPQi9uOmz3Fr1/PaXW98pgKEy9D+zKRgN9Xc316Pal7ieoJz6+RokqVt9icpadzAi6sQRqMlGfdpZ2RbwMCHSNSYDcnzvIsf1XyJDEFwaf0INQWKDNyEJKIisKDmCtRyN3aQFE7Yl+8XhulYzefxjeYQvWFiQizIVZ1ZyrSbdZ6CGt88FtsT0B6M6zxpk+fgGU21/f226M4cWpdgm7XkjUkyPb3Ud/P9xJ6AMLKl9Cu/ThLZPHh/lSvwCerJfAVTGogy3TIC6LL3FCi2y+20nAXxpJe8OifllyYYLPE4qp9u2+22JWlkRFq4li6EZZcA7dkIQqDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=93UCXQkMwVwp4J56ui9goz17DD5Hoky9whI5ha8M3qk=;
 b=PfIFweXUZmO+GSTQPsFwzthN173KZpgMQHDaqnXQzSdVS5NvFCQLUgmemlgCk0n2tQLkvj8Q7UOP574cDq2Wkh16+rf+YXycnfV9S1KRXJKkjuLJemiskKvdzqCwVxymz0vi0VNAgte4B1BpqYtjgQcujh+79sPV3H1ubAJRUq3yNr3+XTEdpeYbVLy5ZMW7nSrIgvIv1XaNHWkSMWTOtXs7ZbCrNZ68MkVkrgE6L1zMB+mKJkXgnsz4CtNhQ9mEZzcXVcLwZAF5OhsoasKFJzMdFtK2shP9TRwf8Fj+cZ7Q5m89D5lHZvoi9QZxgAEQzGPvnfBSHS9/RH+s944cBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=93UCXQkMwVwp4J56ui9goz17DD5Hoky9whI5ha8M3qk=;
 b=BCpPFDx57eocZQH+MTMaTIe/1kGo1uLgHlRCry0eHpldX0oOWRo6/3L6aIYD4k/vSBRS49W/zBj9xfrbUaykwL2GLCVmg5M1wumosv9WFSch1SVbnF4T7U7a7V3RCraIxxKTCIMW7Ctl0hyKZQhI1fdO5gD3ZdG6nPUjaVi4fpolfTao6JDXNrmK97nFiXT7dpfVisAx0dUqVGPnkq0SU629BB/ecDYv5M28hvf0UpkQQBU2wAv/sMx/JAbmxh7ljLc4R2fwnx/nvP+w0xZdUcxwERoy8qjHN0gyYQBvMO3mVTzHYt40LtABiJ27WxFkwgD0URbTyU1v9UwRRLdXQQ==
Received: from BN8PR15CA0061.namprd15.prod.outlook.com (2603:10b6:408:80::38)
 by PH0PR12MB7792.namprd12.prod.outlook.com (2603:10b6:510:281::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Thu, 7 Nov
 2024 13:43:27 +0000
Received: from BN3PEPF0000B06A.namprd21.prod.outlook.com
 (2603:10b6:408:80:cafe::7d) by BN8PR15CA0061.outlook.office365.com
 (2603:10b6:408:80::38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.18 via Frontend
 Transport; Thu, 7 Nov 2024 13:43:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN3PEPF0000B06A.mail.protection.outlook.com (10.167.243.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8158.0 via Frontend Transport; Thu, 7 Nov 2024 13:43:26 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 7 Nov 2024
 05:43:15 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Thu, 7 Nov 2024 05:43:15 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Thu, 7 Nov 2024 05:43:15 -0800
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
	<rwarsow@gmx.de>, <conor@kernel.org>, <hagar@microsoft.com>,
	<broonie@kernel.org>, <linux-tegra@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 6.1 000/126] 6.1.116-rc1 review
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
References: <20241106120306.038154857@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <51bf578e-4e91-4341-8b94-211d2dc79acb@drhqmail201.nvidia.com>
Date: Thu, 7 Nov 2024 05:43:15 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B06A:EE_|PH0PR12MB7792:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a29c921-226a-4bd0-1d47-08dcff32283c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZllqcktFbklZblBWbml4WkMyUGhpdEYrVlkrVXNwNFZSR0YvekRJMUhiSUNT?=
 =?utf-8?B?MER6SjNac01aTXVUWFBQUCtENVJRdUVNMWQyMEJCWjhYNEEyTDl6YWl5V3dX?=
 =?utf-8?B?aUE2RnU0aFJVMkZYNVlJVER2VitiSkRwR1N0SWNsdThaVWVKL3JKNUlXMXMw?=
 =?utf-8?B?dXFwNTIva1RIc2VVVjBIOWY3WDZzNHp3Z2N0eWtuSEFHR1c5MkVVUUdGZWw4?=
 =?utf-8?B?VjRzV0JINUxKK2N0RW4reGV6S0xSVFJyeFZ2MklrMWRtRndUaXhZMmlQdFNH?=
 =?utf-8?B?bVVnUVp2T2grQmVHVVI1ZzdyWWVzQUh3dHUvMHlWZGZHRGthODlmd2NVd3VF?=
 =?utf-8?B?eGtNZVREbkpnNFh6UXJKWnFEd2pUblY2RFNxcUNpNGF4ajE1MmtZenJnS3NO?=
 =?utf-8?B?aHM5YXRwUjRSbDc0K1d1WG1Td2xDemNiYkdQRURxR2N0UGFqWjdMUDdlQk9L?=
 =?utf-8?B?RTlRTEtHL2pjS013dC9FNTNybElTZUZDOEFTV3l3N3JHVU5XK3VJMWpwdXdB?=
 =?utf-8?B?NVFkaGQwSGFXMnpkSlB1U1oyNVI3RlE4c2tHRTVkalg1bG9Gc1lXN1BJUmpR?=
 =?utf-8?B?dDJmWnU3NEZNRkVzZkFkYkYyZlZnalFDMWxpbGJpZEw5dGpmZ3h4cjBVbkVw?=
 =?utf-8?B?cE9rZlVPdEI0S3o4VkcvNEs2OEZQMWRhM3pvdTlleXNhSk4xcUw0TXE4T3h5?=
 =?utf-8?B?YWkrS01wZmpVcGVNb3MrOGY0U0t6MmpPdUE4MDN5ZVUvU3BlYkpWSk4waGZ5?=
 =?utf-8?B?QWI1ZDZOcFllUDFsQ2FKeEJldlphRVlLbGZ5SVorRGFCNTFZc05pWi9TZTRO?=
 =?utf-8?B?cXVNZERobGFxaGpnK0lYbEFKZzhweXVTa2pKejVoVE1wRTJuR3hidkRUd1ZC?=
 =?utf-8?B?c1IxTWl1Wk5Pd1BBVE9xazluelN0VzNBQ21mV1hMUVVlWE15Ymg5ZnBSYzVi?=
 =?utf-8?B?bkNnZXRqWkI2QnRjNndaL2szUVdLMjdGNmdsNHZjdU1LZFk0YkdKOTdFeW0x?=
 =?utf-8?B?b3VhaUVtTVRmWTk5L0duR0hEWU1LTndwRmNPSExZUmVZc3R5TXB0MmQvT0VR?=
 =?utf-8?B?dXJjWWl6OXo0YkI3OWpPVWU2UmtBNzV6OFcxbHBCY0Y1eE15b3pHSFNRYWpD?=
 =?utf-8?B?VW5BYWFDWGpGYWRUUW1HL3hQNUxDZEVRYTI3dHpKU2pBbENwaGdidmc1YStm?=
 =?utf-8?B?UGN0QTNuM3N3Nkw2MDZaZG1TajgvNnFnTXZ0YjZPSGxTZ0pveWdjNzdsWVY3?=
 =?utf-8?B?WnJzbDdGV1ZYb1BFZlJ2cW5SQzQzN1dkSm81N0JBVGJLaEF3ajlYVWwvN1pT?=
 =?utf-8?B?aFlZaUVGR0loUG5VVFN1UzhsTFVxcDdwU0lUamFmSlNjT1BjZGtkR3Myc0RE?=
 =?utf-8?B?TjZtV2djMkN3cGpGZTZCWk5IRy9KMGpCQUtnblp1SEpUM1ZKZjQxaGJKVUxz?=
 =?utf-8?B?UFIyREtrVVJ5R2I3Yk5XeFRyZ0RUVlo2aU5XSC9Qd0lWTHd4RHJ3czNnV3VN?=
 =?utf-8?B?VGJSUVQ2TW54T1ROYlN5SllpSzJrUWNiOVI1dmxrWjJWaHp1YUl5cEJUTTZC?=
 =?utf-8?B?TzgrcnRma2dhczM1b3VvckFNbUl5WjYyTGlEU0xsblVjUDdORWNFZlk1a0RP?=
 =?utf-8?B?aDhHL0pvbkZEaVpTdlN0QTVmWTFwQitMSmZwZWZRSU9mczUzeExRMHhwR2o5?=
 =?utf-8?B?NWdzeDQxYTFWNUFiZ1NhK29UaWcvc3pqbWJQSTBOVGhwT2M1clRuT1NIeUhR?=
 =?utf-8?B?UmR1U2RSK0dIUTBDdWlDQUoyRTlJaDM3WjhycWxtdStDV29ENENSMjIySGYx?=
 =?utf-8?B?R09tdGM5RDdXYS80RjNBc3psZ1dUQTdVS3Q3VzRkaUtXZXQvQ00rRng1RnVE?=
 =?utf-8?B?NTV3STNGd0hWUjcrZ0l6VTVmSW1leGFNRXl1VEtNdkJZa3c9PQ==?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2024 13:43:26.6212
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a29c921-226a-4bd0-1d47-08dcff32283c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B06A.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7792

On Wed, 06 Nov 2024 13:03:21 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.116 release.
> There are 126 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 08 Nov 2024 12:02:47 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.116-rc1.gz
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
    26 boots:	26 pass, 0 fail
    115 tests:	115 pass, 0 fail

Linux version:	6.1.116-rc1-g17b301e6e4bc
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
