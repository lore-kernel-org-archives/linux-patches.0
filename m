Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2066.outbound.protection.outlook.com [40.107.94.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 303107D3EF
	for <patches@lists.linux.dev>; Thu, 18 Jul 2024 09:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721296348; cv=fail; b=GHTik9BHmcdr47wpWQXx5Zv6/pUoSBxmis7TkjmtM+6024HABIRipjW8vCySwcDJRfeV9aOhhN9mKsbH25EXu6vQD3Vs15cXBWSWDNShk9l7MauXoORK9ecMWYjbg9DuOI5POZv7rlX4RbmZ4+jNv8ibQ74EwMM2qj0gpX6Rcpk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721296348; c=relaxed/simple;
	bh=vN8eVhGmp5gd3bQNdwjIlExHQnORHb2CfkvshTru+yU=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=BNjPgHMCYtJ1Q++tC9P5dyTaCycTGVs9wAa5DhxHQHX93aRbszp3qSRI9/ochHcvDX2XWvFBvYTCSi7SYh3QM6YnHF4bpa3JSljIz++16Hm3tUbR9ud7D7Kq1XYb9uktEKAJRF1pcH2dPVMfg4I2MnDtZNDpVnjnu/Txfld3VvA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Rzc5BtLH; arc=fail smtp.client-ip=40.107.94.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Rzc5BtLH"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VY4iiI4NCsL9w/Pp9nauMz/ouI3nnEJcjTJ1O49Etes2MxEHcG0ue1boW3j/DfmGzro/F8Hsqy8HU4rN8TM3+WPwqTByuIjJY4O186L0iUeRV6cVhTOHh+fkXwacyuWsnqB852KhNoMq5Tsat9w2KHuec7EaMVNPkCj2ImLWcpriIbZyuJ9aaJJS/N28TtxiX4AYAz3tsCbGSH2+F28VyKIBYzje2OK0aNmPvzOcb/aRMmJ2hIChVIbZNcydZ9wI3NOTYSg8x08VbXgvBEeoBteisDF0/RnH+WlZVNifLvM6fyl/+nZwkf4EoYI6W0Df77hJ3SmYsIfiUGXnWiV34g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yKQo7oWphDnzG7X/6bONLQEEvuoEkkAHkF8Tcx51BTA=;
 b=OcJXURsiQx0rRmlxpYKgoMR2+GKP6LMh+836M8Kdp6UwDA2CM7BeTycAutd/iPe4z4OyTHOwJzLeyv+p4P6YtPe53KQZo4mJRF44wQHOEGxpH4CCGzyHP0yUiII2w7DIgL4X8+PegPDAQ18+pF5WN9ec7EuLSth1MOKesSvfyLNeL0I9L8qbJHVKLqM6OoMdkqNUYcJ/oWJkZTRVK/9e+/D7tMe/6tDUCJjDmYPg4l83MNnD9tpbCpFH5758NvRSUzi9sAlLE67NUm41qHrRqjsB98kNN6g+h47bBRMrSY2SiCiMS+WyhWQB5HzEkcqgvkEK5gA8Wvs/k3yQrOxSCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yKQo7oWphDnzG7X/6bONLQEEvuoEkkAHkF8Tcx51BTA=;
 b=Rzc5BtLHHjSGuEaXVuvnm9pAV6dVs/EtkYlSJYMEQdOOCyvMWbGSY/EpSZStaHrxiWlSgo+lmE72RO7KmovZ8iA8In8BajtRAjtsPsnrzK7NT8dAFgw0f7+trRM3PqLktiFbwOEuz0nz3JY48a6yFiGHj3uhtLFmAhxNioeFgSyS68ARgQzHC55PqJCtlMDqo4yFoyaBaWU2hljuunOhzipF3nyGiDQe1neASIarogM6tFRJJ4RR9sZeaOWQyfLpPYrulEsbUjE2xwx5C2S8haq72+/KgZDUKbkbAT+llAOHsyq5ETPstqSqGbWK7rmS2Ti3GyhlZu12TeQzmTeecA==
Received: from BN9PR03CA0541.namprd03.prod.outlook.com (2603:10b6:408:138::6)
 by MW6PR12MB7072.namprd12.prod.outlook.com (2603:10b6:303:238::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.18; Thu, 18 Jul
 2024 09:52:24 +0000
Received: from BN3PEPF0000B077.namprd04.prod.outlook.com
 (2603:10b6:408:138:cafe::43) by BN9PR03CA0541.outlook.office365.com
 (2603:10b6:408:138::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.14 via Frontend
 Transport; Thu, 18 Jul 2024 09:52:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN3PEPF0000B077.mail.protection.outlook.com (10.167.243.122) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7784.11 via Frontend Transport; Thu, 18 Jul 2024 09:52:23 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 18 Jul
 2024 02:52:12 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 18 Jul
 2024 02:52:12 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Thu, 18 Jul 2024 02:52:11 -0700
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
Subject: Re: [PATCH 5.10 000/109] 5.10.222-rc2 review
In-Reply-To: <20240717063758.061781150@linuxfoundation.org>
References: <20240717063758.061781150@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <3bb7e7f3-5d9f-4786-b6bc-8294ffe206f8@rnnvmail201.nvidia.com>
Date: Thu, 18 Jul 2024 02:52:11 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B077:EE_|MW6PR12MB7072:EE_
X-MS-Office365-Filtering-Correlation-Id: ce3ebc8b-0c38-408c-f778-08dca70f52c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|7416014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZFFFL1dlYTZTZDl1bkw1ckYxU2RxNnVBU3REYUhFbzFkcDRuUitXanFYbzFL?=
 =?utf-8?B?dlN0RHdoRDAvQmR0SDdFOWpXeFFUdjBBM0JtL1hSaXoxZmttZldOUloyaW05?=
 =?utf-8?B?bXNZcGw4WFZyRHZEeHNJclZDMnJYRzQyU05JOUpyOGlYSURqdWlaUVQvc3dh?=
 =?utf-8?B?TDlEa2hFNDFyQzIrSG1STmhtWTFRaTY2cWp4aG1CK0tqL0hSRWJISFlVOFFF?=
 =?utf-8?B?QlZ6TjR1YzVSdjFZODhvTmVmbTZrSkVSWnJCaWxtYkRKc2wvRi8yd3NMdCtp?=
 =?utf-8?B?Q2kvVk9rc0VMWU1ZaU0yTW5ycUYvUXNPMmtsa1g5SHN6UXJjblEwd2VpUnIr?=
 =?utf-8?B?SmtTS0xDTFQ0M2NocWpoZ2VvQ09YT245akg0SUJNUVIzZUdMZU80T1NGS1Y1?=
 =?utf-8?B?WVU3c1BZS1lzS1kzNlFMeEhpeGl3TkRlakhkbFJWWXlIblgrbnBjL0VUZ3JG?=
 =?utf-8?B?eTYwMnE5WGtDTHIyVStHZnVkQkNIb080cDdIT3pJVTdIOW9CVWhidnVwMFpu?=
 =?utf-8?B?V0YwKzRtZzZ3Tk1LRThnellKWkZlbDJvUkwrVzFDdTVFSExMTDZIUTZVUXhu?=
 =?utf-8?B?S3diaXVycEs0U1dzRE1mNnJSZ0ZzaFJEUWREUmE5Vjl1bmlOeTFhd3NUV3Y4?=
 =?utf-8?B?UVNEeTJtU2YvQ0tEWXZhc1p6MGsvSkRMTXprOTZ2UVQxUXFncXJkVTZMamFX?=
 =?utf-8?B?N0dyVkNjdlMxdmlvVk1UNW5RdjJXNWJyL1Rqb0crUHFyUFlxUjIzMzNCR2RF?=
 =?utf-8?B?OVBrT0NEb0FWV1I4QVlRemlxNmZFSUhmS0RmblpVUkxvTkI4UDdkTEJKdE9o?=
 =?utf-8?B?NUxiY1lHZ1V1bWNQalVlY016QVVQWmZKT0d1K3hNYWV6cEs3T0JzNklPV2l4?=
 =?utf-8?B?YTlWQVFCVXYxTUVMamhNSkZWZzA4aithdy9admtET2JJMkthbGd3cjBwMFV3?=
 =?utf-8?B?azVFT0hZdmhCa1hiaTZ1RDZzblZ6ZkJNQ1ZmaG9jSzVsbHlLV3lkVlJNbFMz?=
 =?utf-8?B?OWxNcGFRRGF4WEZvWTFocjVISkFwM1F4YXhnL3dmM1kvbUEvbzZuSG92Znpr?=
 =?utf-8?B?WmRRaEJGNWxkMFBEbnRySXY5U09BdWRWZnA2VUt2djdRK1hleFlSUHFNQ25q?=
 =?utf-8?B?OEgzSzkvRHpPNlJZa21sWkFINjcydXI2dWQ5ZUlqYjB6U2NpbnhlZFFYdnJT?=
 =?utf-8?B?b3ZNYWR6RFczb3ZGbitNMWN1SWwwbnJkYmZFZTFxdFI5aWtLYkFuSkZLMHVk?=
 =?utf-8?B?ZW5Bd3ZINWY0RXlnVDJRUWVUTEo3NFowWFZ5ZVFpNEwzd2Z3SSt6YXFYWnAw?=
 =?utf-8?B?NzVhZkY2bFJXYy9xZHNhMXRCd2RvUkJ6anJvS3picHNNL0o4a0NBSnR1bG9i?=
 =?utf-8?B?MEsrZU9LU2JCRGFOR2l3QU1BendEUWQ0T2pYL2ZOM0lxVkplNEJET2cyYSsx?=
 =?utf-8?B?ZEdESGc5N2NBcVlUSURaRGdQYUZaTVBrVU51YzEyUlZhUFU0ZzNKMWNOeWlB?=
 =?utf-8?B?RWljMVl1YmYvdGRqMDhUVXJTb1NTZlV5Z2gzUkxkN2xlTWZpOVBoTE92RjF0?=
 =?utf-8?B?Z2pEaWhPSTlLdGxSVHpwT21rRzVwS2JyVUxZK00zTUJpUW91dmRlK2c1RnNm?=
 =?utf-8?B?MVg3YVN2WGpvWm8zZ0VOTUlQMy9uUVoxSm9UeFo5dEJPRG5wRDVwTzBNelIw?=
 =?utf-8?B?TmdmTXRRL0RFbkN4cXFHVURrNGVBWitrVkVyZ1ltQlJYZDdxM2RFVU9GR1FU?=
 =?utf-8?B?d2FzZ1JUai9tYlRXc0NYOFdMRS9sS3Z3WmF4SktDTFlKU3dRVityRE9ZWlA3?=
 =?utf-8?B?ZFNXVEI4ek9aTFFEemh2ZWltemNWRGFEajBkSkNEc2dPWTcyVDFsWEErRURw?=
 =?utf-8?B?d3ZSTzJWL1hHZ0tVcFdNOTE3MzB0UVI5YkhHSEV6WlFBc1ZDTzBRWnlQYmJH?=
 =?utf-8?Q?hvpIOATsoCF2YLcNc0Noi/cvwCpge0rQ?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(7416014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2024 09:52:23.2462
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ce3ebc8b-0c38-408c-f778-08dca70f52c0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B077.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB7072

On Wed, 17 Jul 2024 08:39:31 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.222 release.
> There are 109 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 19 Jul 2024 06:37:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.222-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.10:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    68 tests:	68 pass, 0 fail

Linux version:	5.10.222-rc2-g3fac7bc30eab
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
