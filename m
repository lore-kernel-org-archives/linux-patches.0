Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012069.outbound.protection.outlook.com [40.93.195.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03CAB33FE0C
	for <patches@lists.linux.dev>; Sat, 10 Jan 2026 12:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768049774; cv=fail; b=NKDi356h13mlnbJ6jOK0JkRkFovXHUotuiqE7zChkYZmPFbb+F2sZtYeowFDPs2ruTXheTNOB5olaJ5K+Hv/wYU7408s8AtwUV9mbFTfmqr7IZ10w+6Saw8IfWxtqZ5u2YTrX4R5TsMG73SNSmAEvaiEbfMt+E9c6hBH7qmhBLo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768049774; c=relaxed/simple;
	bh=oYmB9JpRjHDPM28UH8E6bQnh0H7jetRtEoQJFyA4+M4=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=Hei9k1meirq26fTPt1CCHGEQGevjhX99+RQ4Ymp6G8aGqT55xq92p8WcxqGhq3YPWCr4dwFafvSPc0AFrO6pUQhg+qeHLJxKryQGvTGKuTSMxgZ8cUdq9VOrNGrkcnWRF8T1JeTuZF98kKH5WjTjLMUbP1+oIewByYKJMdSMXxc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BQeFJ1sU; arc=fail smtp.client-ip=40.93.195.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BQeFJ1sU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T3UaVWpRBfbQXtuvnoASqydUWJ0fZWCKGL1w6MaIi+Kc8h/oDlEy0X2q4l5xu/5FDrh69l3A9kYDRz/NSiuU0s9GOf6lyuNyM3Ru1z+zqCEa/XZGXujZKDNJevrjumVhFnMfPndj1f5quKYLxY76vr274rWWOknutGUkrevJxlp6zzdVJKlhodpcPf/1NMm8LAyR3E4JeGkdiA9AG7Mi/dZWxdAJNHiTNpDtRQhVkY7l8DPTRFFWlxbfVltifabTiZ2yR47/6uUQW/IJW9Ol6SOK5PleWeTS7TNjGMnirceDd4XYcmPqr2QkM6gt1YErKGL9x4s963ldy0rVo4Nubg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q6OQIzKAnRwAjbE/38jsgw3mHphDB17TLmHpaFZ5u70=;
 b=B5IMyGTvv5B8ABwtnPICpWktCphhpwrOekfN2fGna3Y31wREN+Ovin8vPUUUMVOHAExrNZfYI8riZX17YWo3AjBdNQe70OdfTFqQIsV9HgOqLZpMO7DFYnZdPxD1+++ML6kZguZ4yKSqeTfiL1BK46J/IJBGTLlj094v8Dl+3gEGCcYnLHieI0OXK+Dt/XiVlqiNCdaX4kDv2P4d0l+51TuZ54JF2zWlF+kZDXliNmMDRJ9w5NNc8aPvdDheQ7Fpfse5CcbE04v9iEthvAMn9wRR1qB6ZlONN1dFZngZB8OIEBnIIC3HcwSs/whNqf0eM4jIu+3NoTVS6HKJauv3Iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q6OQIzKAnRwAjbE/38jsgw3mHphDB17TLmHpaFZ5u70=;
 b=BQeFJ1sU6KKT3OLUMxNVoKbdAqlnmk5CaU9fniZ6lPwPmoyg/cOfnynmgnVjTpKOIBGil2D3ZJZqvLSr5LMkh9BLzk+NxqboYIeJLSqG7SLsvEYxvxNqh6w/+l0PHN6X+Rt/8jui+na9L9QWHUBGjyxqo9UdZV0LzqclcjJvhwGMcU00wiZzIBMCGxT8jAJHBtGPIuYEghTqiCmVxKxXwuBDfddFsuRxiijk+la7Wwq/tJnGbldf47Kl2gRJr6rrC1UpbqMYtb+RdLqlA05ptEEnEEOKDJf/AQVJqERhgBYpS3Uzx1TGKTsv//PifXLYYS3Lk0fqddD/k9wi6FFMvA==
Received: from PH8PR05CA0016.namprd05.prod.outlook.com (2603:10b6:510:2cc::17)
 by SJ0PR12MB6853.namprd12.prod.outlook.com (2603:10b6:a03:47b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.6; Sat, 10 Jan
 2026 12:56:07 +0000
Received: from SN1PEPF000397B0.namprd05.prod.outlook.com
 (2603:10b6:510:2cc:cafe::e) by PH8PR05CA0016.outlook.office365.com
 (2603:10b6:510:2cc::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.2 via Frontend Transport; Sat,
 10 Jan 2026 12:56:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SN1PEPF000397B0.mail.protection.outlook.com (10.167.248.54) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.1 via Frontend Transport; Sat, 10 Jan 2026 12:56:06 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Sat, 10 Jan
 2026 04:55:56 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Sat, 10 Jan
 2026 04:55:56 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Sat, 10 Jan 2026 04:55:55 -0800
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <rwarsow@gmx.de>,
	<conor@kernel.org>, <hargar@microsoft.com>, <broonie@kernel.org>,
	<achill@achill.org>, <sr@sladewatkins.com>, <linux-tegra@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH 6.6 000/737] 6.6.120-rc1 review
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <3c764db9-d1ab-4d02-a4a2-68059c68bb36@rnnvmail205.nvidia.com>
Date: Sat, 10 Jan 2026 04:55:55 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000397B0:EE_|SJ0PR12MB6853:EE_
X-MS-Office365-Filtering-Correlation-Id: 4092e9e3-9f38-4bf6-83f9-08de50479eab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|36860700013|7416014|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?REovazFMcnliNFpaR240MTd0WHRyUDljQkt2dlhyS3M0ZW5qYXNkbWR3Vktp?=
 =?utf-8?B?ZFJwSXFLZGVEdUsrcTF0NnBoRE9qaVkxZmJXS0VNa1lqNVdTZUE3SGgwcnIz?=
 =?utf-8?B?cDhOczNIRUFJV1psR2pWTi9HcTBKOFIyU0xIVy93VTA0K1FRck1CVGlFRHZv?=
 =?utf-8?B?bEkyUk9oMW1ZZkpBWjBtc1hHYVBiTG1Qei9YSkxPYmZ4dXhCQld5c255eVZD?=
 =?utf-8?B?NmtRcW9PU05yVi9JR0FuUDlTMis2M05BMjJsMTV0NXkvRm04OFFLL2dMTHJJ?=
 =?utf-8?B?aFh4bUZZTlhGWWFwNXg4d2lmeU4rMVE0RkRVajcwMHBTeTF4MWM0NVBnVXpT?=
 =?utf-8?B?bkhHME1EalVEME1XSGRjUnRIRXRvNVlOTE8vbzlRdW9KNFR1ZnVpcGdZSTds?=
 =?utf-8?B?MGVpblhCYVBOSmdxNmpJSXllTGR0bW9ycVYrdUZsUm5wS3dsZ1RobUdUUzFP?=
 =?utf-8?B?aFppMjZ4QWVoTE9sNTVOWktSTUhWRUJXQVRzb2FDQzI3dkdSNGQrb05McTli?=
 =?utf-8?B?NWxZS25ZdmdHSmxWcnFFQkdhRE9RcHdtY0hra01NSHhobDNjcEpHZmFteTlD?=
 =?utf-8?B?MFMvamI1OVR2VTlWdUMzRHhCcDh3N0Y2aVorL2dXMUVyMVg1czNUTlpXdENP?=
 =?utf-8?B?ZW5iV202VXVyTTIrNUFqSW5uS1Z4VTJzTTAwTklIUWZEcUVtY3R1VWllWUNZ?=
 =?utf-8?B?b3VWa0FHRWN2bklZVFZvUUkvNW1BbXp4VnNjS09Cb0dKSEZyMEhJQjVuZGpZ?=
 =?utf-8?B?OEJSc1dBYUIrN2tkeXlrNGcxcnJyNzc2elNRVjJ5UXI4ZjZaSVp4TFUxMUpt?=
 =?utf-8?B?V0IzWkEvWlgvZHdvNG5WVm5WYVNFaURvY3VabUlEd2N3QWlDOFlXMktvbm5j?=
 =?utf-8?B?OFN1VWkvWWlLY3lSYm9qTklMUUduMUorWThZN3ZienhYcW04OWMrbWt6RjBE?=
 =?utf-8?B?VkJaQXlac0N2VThTTkphanE3RFlJb2hmZE9sZXBteVR1eVVBMVFHTDgyNVV5?=
 =?utf-8?B?RUcyall6cXpydU51RGpBK0FMdFZyckMwMGFPVXV1eXhER3l1cHZCemhHNDgy?=
 =?utf-8?B?VzlVTU0zRy9DbisyK0MrRzN3OEhYNTY0NElUbUNBenZrSDllNjkrMFR3am1B?=
 =?utf-8?B?U3ZQWkFDQk5TamJTZWJtVVlnTGR5QVkzdmRGNHRIcVFsZmpEem9TaHJsZ0d4?=
 =?utf-8?B?T0hhYjRUUjRNeXRlME9SRm8yY0FzVGZUZ1VNVk4zeWhWZEZtTk5uY3FTZGRt?=
 =?utf-8?B?RlprajZrelJ1d2tEVnRES1BRUXFERzRpa0h2L0xON2xUcWFhNlJTMHpuamh3?=
 =?utf-8?B?bUk5SUJvekNRY0lhbHNwUXJMY1JuOTBWYzNGU1g2Tkx2b1ZpNEJvb09kWGta?=
 =?utf-8?B?WldlVWxmMk5zL1RUOTI1MDUzVkp4S1RaYlFreDUwQkJJMlJxY2h0T3RTZDZY?=
 =?utf-8?B?S0lsVTBMYTlSSXZXTTd3TWFOYnNsV1FEUTZyLzFOSmVNU1A4SE02QUlPVGgz?=
 =?utf-8?B?V1VFNldzK2g5REMrQi85UktGTXdWa3lOMjRKMjRSejdOZVI5RzZBd1FhQkdZ?=
 =?utf-8?B?bHBUMGlwRXdkUHVTUzZtZVNCV0thSXZucWlEQkNnL21hMHAzTytGWEprUDdz?=
 =?utf-8?B?MGs4eWFweWVqU1ArWkpBTllsd05PQ1g4a2JzUnd4dTVIUnJMSjhQdjdyb3VJ?=
 =?utf-8?B?UURucnZGS216RGVnVjd0ZWQ0WGFFR2NCV0RqZTFuaXFiWWpnVy8yaEhZRFZD?=
 =?utf-8?B?M0oyelM2aFMzOTV5L2lNeUhDRjRwWklvTnJVUFJnZ3FNa3llUHQ0MU5NVTlM?=
 =?utf-8?B?WWNaRndrUGdERG9UbkM4dDFTK3c5M3F0Z0cycE5LNkFmY2lOZnhZOUVvUHFv?=
 =?utf-8?B?YlJNSS9abDJQa1Z1V2xHdHBuQUpUeTVpdnpsWXJ4dFc5dDdET0VvZERsZXVR?=
 =?utf-8?B?aXBSSmlVU2hiRlI5S04yK1o0aTMzcUN0L3Y3RUNqT1dmMDdZOStOYWR0RjJZ?=
 =?utf-8?B?ZHdYMjF5RnRYZDBwZHRnSktZejFsVFJvTkcrVFhYRmR2QUlVWjgxWlVXbkVj?=
 =?utf-8?B?OFVxSVRYcUFidVpFRDRIYWxiNXU3T3dUNFBLaS9CMEE3Vk0yT3RnVWY0U2ZM?=
 =?utf-8?Q?njls=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(1800799024)(36860700013)(7416014)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2026 12:56:06.6694
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4092e9e3-9f38-4bf6-83f9-08de50479eab
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000397B0.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6853

On Fri, 09 Jan 2026 12:32:19 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.120 release.
> There are 737 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 11 Jan 2026 11:19:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.120-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.6:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    120 tests:	120 pass, 0 fail

Linux version:	6.6.120-rc1-g00f48cae9e13
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
