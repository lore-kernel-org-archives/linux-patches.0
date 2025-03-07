Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2063.outbound.protection.outlook.com [40.107.93.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F1301DACB8
	for <patches@lists.linux.dev>; Fri,  7 Mar 2025 09:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741340838; cv=fail; b=CTjDZhbMUktSqrEW0i+9qiCpp5ZW+7IXEuc5y+Y18pIObSV1hKWKW4nWvgDrVk6ayB/b06hkrQKI9S5kYtIRXBWXO2B0DMaMKz5cmQe7EGwOjh5SMg+dGxhjjr0e9jU+AFLDbDvKTlaGudJWo78iR3yMieLv/t79CkB9orabmcI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741340838; c=relaxed/simple;
	bh=rqR6MfmvdswHdcjptanvhwAcf5ZdKJeigp0oiDxTg2c=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=Sq1TSqpkVOZQqRk9R8q0A0uDWmLayIx46adVleHLSV4v14JUY3xSO076vXPRfa8/VGQ3KKO9+P07G1026kj8XB3ASpRes8T07ikw+Jujzv1gemtZmw38ZbAe4O6HbiL83sBLLHRL1bGJr6zw48vTmAy2GJngw1FuafzXNTbDGw4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=TOTgTVr0; arc=fail smtp.client-ip=40.107.93.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="TOTgTVr0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H37WIir3s05/w0KggcvoIGwiSY64aq+5dswdOF3TupaDFmBx2v6lFnHbVee+wAFeXLmPtdd8MZlN2B2Lnx+VbOg4MtRUdyKnGJuQekZ4SaIWMV40JfRRwsUabeX6VB1/TVSL5z+jdswE5buY1z5ToaxRYlSb6OeAMKPDRDVgNAwaU7Se/onaSAHghqLbFj0YKi8frJWGqvsI5Efd+9nnaNtEO+qCtr3IKIE1MdTQTQKk999l0MUABk1zPqToTizAoivnIRScgVesxWCZyKq7g7fb+nn1wb016A+he0AguYqNROPXkg4dFqaLoN5SKHuq6YsDXldkHSFZ34rtYEkFpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iEjK4fi9VubC9/KVRgu4BLykwshlb+U3lKMiuX2sdNw=;
 b=GQ4UWrxPrivvYGpmMMrM1AjVk5PFtWE6PoQDDLC4ty7yd9YfzHSsb/f26GAF+Dg6Er/RRPhLtN9QgmwuRWBclp75qPDfiM/EvZiquW3ITV4VY5ezX0eJM+jDQPHcdg/G+/8/2AIBDUoKwV7dIwzkQ7zkSa1qT1JGOzPCpb0WLQRj6jsI7Sn4Np+yTJNiVWw9u5b2AUfMyjtMiw+LY80XvvQaMnz+p60l/z53d5/oIjjTfbgrfTH7ok9DI2gd9QZPZ+EQ8VI21nd4oQb/pOI9dPUJHK98oI89cRCCWGj6+ihmVSx6pJ1imq4CsJXv5GEOMfzrWCKSkPyHXqb7xDn3pQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iEjK4fi9VubC9/KVRgu4BLykwshlb+U3lKMiuX2sdNw=;
 b=TOTgTVr0EXt0VJGXzTjshKPI95LduB6pRHiufggqG7d2F94T2Fe6lPMSUwricLRGpXWpbwQS5cHqxib019kw10ETLSVbbpXrHigcmPjofXvlFY/IamwAaYZiFnVLw4s4VaL6o93mzS8VZY5fVsnfrGRUUmpJFnSyl0DiN24JCiYsQihq7fCSCZMXWSpg/Pvt69yVR+wdPTzRP5ogtXVVxcHL0xXtuYfIg8NaycHj4fYOM8WRKDRrz0ZR5Z/H2jo2AO1pJlmHcyOAnRXojos2s+IXE4CVdtp+64HDujTzVyE/H2EWBiH+ErwrQZALil67f9dmbSFzjBZ5/Ld6eWV6LQ==
Received: from BN0PR02CA0039.namprd02.prod.outlook.com (2603:10b6:408:e5::14)
 by DS0PR12MB7679.namprd12.prod.outlook.com (2603:10b6:8:134::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.24; Fri, 7 Mar
 2025 09:47:10 +0000
Received: from BL6PEPF0001AB56.namprd02.prod.outlook.com
 (2603:10b6:408:e5:cafe::8) by BN0PR02CA0039.outlook.office365.com
 (2603:10b6:408:e5::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8511.19 via Frontend Transport; Fri,
 7 Mar 2025 09:47:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BL6PEPF0001AB56.mail.protection.outlook.com (10.167.241.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8511.15 via Frontend Transport; Fri, 7 Mar 2025 09:47:10 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 7 Mar 2025
 01:47:01 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 7 Mar 2025 01:47:01 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Fri, 7 Mar 2025 01:47:01 -0800
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
Subject: Re: [PATCH 6.1 000/161] 6.1.130-rc2 review
In-Reply-To: <20250306151414.484343862@linuxfoundation.org>
References: <20250306151414.484343862@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <981bfe9e-f64f-4da9-b17c-0cb5b8d49874@drhqmail202.nvidia.com>
Date: Fri, 7 Mar 2025 01:47:01 -0800
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB56:EE_|DS0PR12MB7679:EE_
X-MS-Office365-Filtering-Correlation-Id: cda1e0d0-34e2-4441-be4d-08dd5d5d07f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|36860700013|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SXFlRmtSL1FvVEpyUTBkZmpCTThLSTlXRkY1aG8rTUhDV1RUUTJTSUJxajhN?=
 =?utf-8?B?T202OUVLcXdTTTZLVmdvMGVkbVdWaCtQZTYwMWdUV2hkWmg4MEo4UkNqdEJ0?=
 =?utf-8?B?L3VDdStGM2g1Y0N4b0ErUFh6bVJiQUd4OFV2SGk4b1h3azRCczI0N0Q5aHUx?=
 =?utf-8?B?RjFHM3VmKzZDYlRDYmhuWlBqSkxRYWZjb3hxNHBmRTBNQXpETW9XbE5NWWha?=
 =?utf-8?B?SG9nMURaNzM3eWhXc3JwRUhwZGx5M1J0cHNQWEZzK1RUc1ZObmZSM3FkTzl2?=
 =?utf-8?B?L0IycUxCK0QwbUcyTVZRQkxCRGdPcXNTemM4QXhnY00wdXc3ZWxGWTFtcjE4?=
 =?utf-8?B?V0ZwRmRpa0tjcDJWc0E5WmlNQzd5d3pqVkxqMnJaV3NqQ2JWUFdnb2QvcUNG?=
 =?utf-8?B?VlBSYnpEd2pSZXZ2ekIzenhFU0hEdUN3YVpPeEpkWFJDR3F6aXZuZDBKRDlR?=
 =?utf-8?B?WjdoeERuQmwreHowdG5EcC9nKzlDd2E5TVJhanZoRUJaemRMTlAraERZSFB6?=
 =?utf-8?B?VTRpU3QxSndHZ0E5MU1SRzJTWmM5My9FN1hhN0xBT1ZXVXNHb0I4RGQvaVFB?=
 =?utf-8?B?aGZVSUF2S2szU2N3MlU4U3NaaGdiakJYZjR2NUFObTRESDc0c25PWkhmdlJJ?=
 =?utf-8?B?YWRCOFY3RjU4U085ZVBqYnpkbmhhYnhPZmgybWN2M2FDb0UzN1JpYlhTRXdr?=
 =?utf-8?B?NEF4WGxuOElMRGFjWU1FOS9DaHJocnE0Sldyd1IxZGdlVmN6Ti9UQVJ2K29D?=
 =?utf-8?B?bkN4TGlPTjRrUEVKL3lkZHcwT3Nvc0tYNy9yMTI5SE5sTWR6d0xxQjZ6S1hs?=
 =?utf-8?B?UEJPek0vNDZLWjRtRk5nT2tHbmY1THBzMzdNdjk5SHhjYUZ6TklyWGdSc1U2?=
 =?utf-8?B?czBkaW1Tem9YVWpNU3Z5UWRJdEQwVUFIaTFNRlJKalNhOTk0cUh5N0lBZ0w4?=
 =?utf-8?B?RVVxbmtpZkJtK0dhUGtzY3duV2lSb2t4bnB1MnZnNCsxbVJLY1YranlCNHBH?=
 =?utf-8?B?NHBhbW45ZGdkYkdFZXpnZFQxaGMxRDY1SDBnRi9XUkJKZU9LeFQ0Y3k1WEY5?=
 =?utf-8?B?ZmtmOEM4QWpzUkRnTnZidDhXS1plMGpkRE1LNFBKajZQM3J6cHZOOWgxNkkr?=
 =?utf-8?B?Y05oQk50Um5KRHpFK0hBWVlqWWZnMDhPenE4Z1loM1FvMmJqV3BpN3lDVU9R?=
 =?utf-8?B?SVdLZklpTk9SWjRIelNiUTBJWG8vaUVJQTdBeFM1WUNRQTl2NjBqL2VuWkpJ?=
 =?utf-8?B?OU1zVkRVdWYzTEpKMUN4bVVodjRBOHhhdnBjSHdUUTkwMndFeTFHdDE1Ryth?=
 =?utf-8?B?RGR2Z1BIQXI4NEx0bHlPaFVFQTdyRkQwbGsrN2RENGYzVFlUL2M5TE45amxz?=
 =?utf-8?B?ZFNsNFFlaTBWUWNUL3J4WW1mRS9EUnBZK2xpMW5WNGFlRHlldnoxNk9hc3Q1?=
 =?utf-8?B?TGJSSktUU3dZczVQQTJqbnpPV0ZXaGVZbUo0L0t6eGF6cTh6YndCWWhJVVRK?=
 =?utf-8?B?SVhXdmh3eERGMG9uTllEL0FtazA0UWNYK3dSNlZUa25XV3FXNkEwQzJBVHdS?=
 =?utf-8?B?WTlPZEhTcFYrU09JdFR1eWFzRjV3VWhTd0lJSFMzSmEyY0ZENzVLQU9wRkN0?=
 =?utf-8?B?S3RIbmRCWTNwVEp4S2hsSkdHNEhUeVdJOHg4UG5KUHdJdnpqaXVuUFR1cW00?=
 =?utf-8?B?ekhiM3NnOEVoRVhNbXJXbSswa2hLeWIxWWo4VEZLWHNwYmsyU3NVdkRUVm9o?=
 =?utf-8?B?VzZuWmYwZVRVVHYyZjlXN1RrMDRib0FCU0c5b3lxYkJYTFRVcHN5RFZDR0hM?=
 =?utf-8?B?S1hFcy9MOUhlMTZidmNxVnRZYjRzZkV2ZGMzaTNNT3FOUmZDOHZxU01GZGx6?=
 =?utf-8?B?U1doOHQrT09JeWErRURCSGpwV1ZVMGpvaUVpOTFlU3ozZUd3NFc0QXNwbTZj?=
 =?utf-8?B?RTRjU1BaVHNjWkJFMlByeC85dTd5Zi9uL2UwVXdOSlhGYytUa3E4VGFiR1RN?=
 =?utf-8?Q?d3ppoGSoqX8cMnEn+h01XP19XiRJi8=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(36860700013)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2025 09:47:10.1399
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cda1e0d0-34e2-4441-be4d-08dd5d5d07f6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB56.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7679

On Thu, 06 Mar 2025 16:20:35 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.130 release.
> There are 161 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 08 Mar 2025 15:13:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.130-rc2.gz
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
    28 boots:	28 pass, 0 fail
    115 tests:	115 pass, 0 fail

Linux version:	6.1.130-rc2-g029e90ee47c2
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
