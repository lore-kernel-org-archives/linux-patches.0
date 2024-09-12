Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2043.outbound.protection.outlook.com [40.107.100.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64328383
	for <patches@lists.linux.dev>; Thu, 12 Sep 2024 07:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726125529; cv=fail; b=b1GankkGMj81WrCwSXRTDUXgkXeWJwoiYL07eP7LPhY5GeiJ22fATNEba7bVZTkJiH21q3PdP+hFUYKZPpQGqlKjQw+ZHjrRF01swheAeddhqki+E7aXmy4LPAAhzOlUZGlxK75kyZIEn39XJs6Ak9JKhVh9sDw8Gv1EWwZZfxA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726125529; c=relaxed/simple;
	bh=969zPqwhR+VRNXc7346Mqf84qg+VMyL4o/zl8s94bD4=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=aTwBDRzTPVBgSP8Id3pGoNzAS7KDrUoLNL+D0IYjQDyoMqL6fRXEniKXzKUrCGkg71huHoDPRqrmBZPJvZvLS/xYFzzO/a6jZy5Y/W27MvFroAzGQjuFL4JLy+8OM05h/eX+o8THfB0eaRxGiN3/LD/vhmo4X/aLqNQRnSmayz8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=gDxN+Gqc; arc=fail smtp.client-ip=40.107.100.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="gDxN+Gqc"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OUsu64DPMwaj/Ot2QjSvp2QEkB5KMsl3LBIMYOIEOhUuZA0ZSuyKZq7a4GrHk18Kt6gxBMT8W2RtKQhY4Qf5mq46CY9As0LGEdPQz4HvSfGfQKuvXiof3+TRjbgtcAIjji9vgbFnmcOs5ioHSZK88W+qkyO3jH2B2pPwM814iUIM3NyUId8utbDq8HAu8QsekU+qKLlSBrVp+BTlhT/uDpVRv78UZ8YcJCmW5SOyvKbp0XRZ9bmayqkAPdZXfNarp4OfRfQQhhEKslktuur9JqlzMvcXcaFSA+KY+7Y0805yimdmlr6PMwyc+W8Wqu95DSsBua3QCMbzUz5WoDJs4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V7WfaxC7G58DyYJofX2n0EhHgwfgaOLLuuCsxaRS/K0=;
 b=hyhgn+Jg0qKwOnPZIMk9l3EcohJ038LQ7bcS4wqPE9GK6M7tWKvFKTu99D9RkdYv06EpOXDJyWGrjxuYF2lzxQJd6Qbd3b3PR8RxR2didCp1qAC6E+K/FROUIusiEPbp6r/A7oHF8DA5DiJlYeN6VFc0zFeKWnLWh4uCd98pR5rvxYijU3VkzQoAmG0h/4W5h+y/p8YXznqJurkd4m6qlLqaI39QhqOhWynv4/VM+Fv+kYdWfuMAzXbOcs2AApezsUrRwsBJdKjplOYKBz0jyEFpelB/1m7nRzV4AxjWulReRsVl2k4lcLONGMiiZeoR3GGXX2XrkRxCtT+ze/T76A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V7WfaxC7G58DyYJofX2n0EhHgwfgaOLLuuCsxaRS/K0=;
 b=gDxN+Gqc/hfBwknUMuRysAA3MxZTj8mXu+ju34ut74ChKA9x8EE5xnNQg607s3rzhwZzteU9nnSVm6v1jeqrPSzuIQaz7FmYpFTNaKc9kVS0HjrvZQpdpekRc6kZGEkdz/0NctwGKsA4/MEUvcbOClnCfB6WQZzO5vpICgK7xjVJn+KVY5GKBsyfgoRpcfXVSKy6s4n0wy5RDp9/igDPDz4T9OekgAGSj1GUn9rpn2qFEh4SjE2XtdZQrNJSxuTZttTcy+XgMIWWaB5d6sFriJz3pXFu/asnx5l+kxbCXE1x+ibRlqcH+b6Wa1j9nWfROGr7tif+l9UPeNYBd4s5Qw==
Received: from BN9PR03CA0568.namprd03.prod.outlook.com (2603:10b6:408:138::33)
 by CH2PR12MB4246.namprd12.prod.outlook.com (2603:10b6:610:a9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.17; Thu, 12 Sep
 2024 07:18:43 +0000
Received: from BL02EPF0001A103.namprd05.prod.outlook.com
 (2603:10b6:408:138:cafe::a1) by BN9PR03CA0568.outlook.office365.com
 (2603:10b6:408:138::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.26 via Frontend
 Transport; Thu, 12 Sep 2024 07:18:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BL02EPF0001A103.mail.protection.outlook.com (10.167.241.133) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Thu, 12 Sep 2024 07:18:42 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 12 Sep
 2024 00:18:39 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Thu, 12 Sep 2024 00:18:38 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Thu, 12 Sep 2024 00:18:38 -0700
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
Subject: Re: [PATCH 5.4 000/121] 5.4.284-rc2 review
In-Reply-To: <20240911130518.626277627@linuxfoundation.org>
References: <20240911130518.626277627@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <af41ec61-054d-477b-a234-aad63a77d00c@drhqmail201.nvidia.com>
Date: Thu, 12 Sep 2024 00:18:38 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A103:EE_|CH2PR12MB4246:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b370456-cc0c-4b76-ceed-08dcd2fb2221
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?L2VNYkNUUTgySXJMN1VqTW54Ykd6emVqK09kTkMwcmdTM0lZSmdBYTg1Mmdm?=
 =?utf-8?B?S2FQSFZZdE5QL3JMK0ZRYUhoeWNCbXl0VU9HV0hOWVZCc0NFbXdEV0hJeVNq?=
 =?utf-8?B?RTdFTzhjTlkzS2ZHc1ltOGN4KzFiUnRXeDlQejlQcTBJeENuMkh2MEZiVGh2?=
 =?utf-8?B?QTB4V21HMWM0VmExRVFuL2l1N2c5NUxYSm00ckgxUzgzTzMrVFQ0NndhM1lL?=
 =?utf-8?B?K0ZPRHpWQUI4QW5BbWNqSWNUbExRdU90cHg4Q0U4QURzOEVKQ1hSUWdwYW1w?=
 =?utf-8?B?NVd4b1NuN1poK0MwN01tQUZ5RnhlUVEySTNhZXlmUU5FRklmVDFiLzhyWHZJ?=
 =?utf-8?B?UDE2YXp4eFgyNUxNZVliOWxRVExTaStUeFlNMGUzN25tQUJ1eVhldTBPbUVH?=
 =?utf-8?B?NjU4b05rWGJhUW43RXNTMElrRkdIZ3Y3QzQxQmtyYklVWWJFdmIwRnBsbk1R?=
 =?utf-8?B?dTFTdEhUZ09EV0c0WjFzZStiZ1pOSkZuMCtSQ2FpSEVBR1VEWnFGUkdiQVM1?=
 =?utf-8?B?b1lZcURFZCtGVXJKWlhtaEtKQVFJMGlKaW9jeDlQUXI1TmpDeWdDaDhDOWp6?=
 =?utf-8?B?Y3ZybmlTbHRmWlo5Rnc0b3BYc0pKT205ajYzeFdGbDBJUFVQNU43VktJUm1z?=
 =?utf-8?B?M1p5bTM0eEtLWDBmRXZwbFE4RFEvSmdJZnZXNzBiWlo2YkhCeFdFTVBMaENn?=
 =?utf-8?B?eHMxZFVlWi9URGV6allDY3p5V3A0UXowWXFoU2NWcnRjY1dkZHZVbUg4a3Rx?=
 =?utf-8?B?OTlueHpmUTI5YU1yYkdWenNvZUU0STFVWmJyUDNLeUpRUVFWWDFiMUdZWjZ1?=
 =?utf-8?B?Zy82ZjRxaUUxNldER0g3cFFmZ0hvTVRpaUg1T1BoR3MvUDNwdzYrY1FaVVg3?=
 =?utf-8?B?UkVKd1NGbytJS1h1ZGg1dyt3U1EyRkt0L01RK0xGK3RZT25jbk9WRHZXYU1n?=
 =?utf-8?B?QVM3aWRtUjVIOTNpMGpiRy9COGZpQ3ExemhqZ1c4eGF0cHViSE5EaC9DSWNO?=
 =?utf-8?B?elJIS3o2eHZscTZrTkZCR2tIVG93clY0ZVZZenZGcm9iUUpVZGZtOU10eG53?=
 =?utf-8?B?RWdyMjhSeHBqaGhUQjhNc3B5Zjg5MVlXdjJJb1BndzQ3SGsxTzJPTGlRK2lJ?=
 =?utf-8?B?TllZa0xwR0N6N2wrVFBLZnBDTnJ2dVF2VERlT1NieDE0cTlKdGlNRWZtdzRW?=
 =?utf-8?B?bktYRm5aV2E5OWxoVkszSkZwblA1Rk9IU1RaY0tQZU4vdW0yV25aNzZrYUVh?=
 =?utf-8?B?TjlhNDhRWnFDT1Z3Z2NDZlpwNWc0djVpeTVVUHdHRUxTbXV5MzhNd0dHUjhW?=
 =?utf-8?B?UzRhbDllVDI2eHhwT2I2ZHBtaURnZmVSQ1ZGcEgrNWhvN0xESitvTEhsTGNW?=
 =?utf-8?B?bkdkekNFZ2k4TVhlSU00ZmN6MDVQOTlBRzNhdXVhaXlQblFvVWNzbnNvMUwr?=
 =?utf-8?B?NUxiNU5JbS9DeGFaNG1OYTVvNDlvUlRpMkhhUVRhU2d4dDhEbmZjaTNVeWlW?=
 =?utf-8?B?UWZQb2RrMUdEYlM3eG5IdU5jN0Z2ZndsbVM3RVlQVDd3SmptVGlpYloxMm9W?=
 =?utf-8?B?YVBzWFFiQXNFcVhYSHYzY3dHOEx0RkNxV2lUV0dQZVkyVGc5TjYvODJyeTNH?=
 =?utf-8?B?R2l5SmxMOEN0MFBycXZpZ2hScDM3NmpWOXorYm9vbkNHcGhRWDJQQXI5Ymdr?=
 =?utf-8?B?RzZDaFlPOEl2NGZYQkk3VnVybGdnNCtJTGlrWEVHU3lWT25TTUxSTUdqLzhj?=
 =?utf-8?B?WkpSWEFJSFU1QldQbFBoOXh0S2c5bUNPMXdsYW9leEFmVkZpYk5xSVlFWW5j?=
 =?utf-8?B?YTluQndaaUptbElCaHVxRlQxZ1VkQzFmYlJqR3hLRkZzL3FsSStxZFFvYlQ2?=
 =?utf-8?B?NXpUWXNOSFNpODh3d01BRis0d2NIZUoxK3B5bWF4WkhvT1E3K1NJNmtXWGsw?=
 =?utf-8?Q?U/hDMX5UnTl8qJu4u2IyGZqxdGubLJJ1?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2024 07:18:42.9159
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b370456-cc0c-4b76-ceed-08dcd2fb2221
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A103.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4246

On Wed, 11 Sep 2024 15:07:17 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.284 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 13 Sep 2024 13:05:00 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.284-rc2.gz
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

Linux version:	5.4.284-rc2-g10d97a96b444
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
