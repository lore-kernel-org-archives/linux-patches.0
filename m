Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010023.outbound.protection.outlook.com [52.101.193.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEEB537C103
	for <patches@lists.linux.dev>; Mon,  9 Feb 2026 20:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.23
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770670552; cv=fail; b=gPKYsAriBjNE25UhPqtnjdB/SwWG3AxsrKhZyA9XCAEZCzgGndli/q62PEcjiy2E7MGjlJ7OzXgGY8lu3QSebnmBxNaF2zZpX3YvNLEwMN3+SFW8QAgsIq56Sk1WmfvWRh/CwSdmAcnh/gtT7rXSH/CBBeA6/Ccyug459kJluo8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770670552; c=relaxed/simple;
	bh=VRcIyQcw+DhUuHC+XOjS7341l20HJ/FtR9/GrHe9lhE=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=RMQESDgB880DI6XiTyU49MygOsGmldQemyHSFUaeBAH3kbOv/zlakm9JYfqpPXRDm+2pReRcpf548jmHZA50n+Gs8ojDBLQ33hFBLPOwMJ2jTS5NtEKpT+TU4CJ879CmnuhBCRbe+ZCWv1fRqTwVrDFqzJ1swX4w2nC0+3qPB0c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=FyU5BF7g; arc=fail smtp.client-ip=52.101.193.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="FyU5BF7g"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TMgnqeu6FXSw8Z0gr7oV3Bbxsa9f6Jzg3cKkPbtJEseZJODSw8E9iWDq5tsruw04hFlqfL344lNEely6aqmRJC7u0UbZf4yhC7jIyaGVSZex4Pxq5V2Ke+iG0O8zSHqD5eJUs+Tv7lM1pB2b66MlmLgw3guXoT623ZORl+0tOKeeXkeLhxdTjjMNDpgBBhUyHimG3c1zfFt3FjTeG7AzFEbbmfpw1YcopFQtlxJY1HTrdUeZz4IM4fM6MPkfjVCDBhbQIkpiB4aNh2KMdjaKIbR+Ew63SJrtl3u/b+/J1O9c0GBi26n5H27Ap2Cl9y/Y/eUXmEyyHBp6aYzukFJrow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C9yUpAOmG0uEdse4BK969AEnHxZWvMlsdoAWl+ukeAY=;
 b=dnlg2y0KrHwYd+RJmDz8yhGYpYOmNgXSzIeeez1BOCpFdwYZ/xADYGKVUchQKP3RenTV0kS7nrh9vXR/otFnlJtFG8pSJIRCFMCFDTP5+/Xo+c9aNsA+A+wAJz0Vsu7MyA73giEk4hdX+HwqHWgScoYZnLCrhFv4Y4d52/wUxUQYjR7Ya3rFUKrveJa7gYaeMrSJYFx/K0KYogYkf86Z/MXT3riyIa3+QO8U+ocXAnCXgGj9EckTC8LVXHSO78gJHGQgsm/UWpeRjQ4mVPC2Ce4CqD+auIQ2cRfQrsr4m1CvBg69tezoUmdFHuVH1Ayg/ijM8pRNdrUtr9AOUgHcWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C9yUpAOmG0uEdse4BK969AEnHxZWvMlsdoAWl+ukeAY=;
 b=FyU5BF7gt4jdapc3yHM+1fIArwuW4cYrq/03vL2sqKK1Xb3o095zHVjqXNGkHL80FbrD5s3D94lekKRBDk7cA5+vDh6WrlbvC5XIwdieUOOT3MS2//dZYwwnFezZm3pft+X3Tr01HReReOKD7kAg/bwdT27ixbGjoIiJcXNZ0DDYhfJSuTLt5LSmiD4aAP0G6eJRWyN2JrqGkaTmmndE6iMbMD/MUpNtunysW1IFIPzzALNQdY1QOoefQiQTAm3ic7vqDv+t58N6rKFHhec62WyuxbEEWCsw/ymlTdyjuZBEkcvkrsH5vL4N7uYrNsNxuMkCjayf/5FYiyrFDQ5VWw==
Received: from PH7P221CA0042.NAMP221.PROD.OUTLOOK.COM (2603:10b6:510:33c::10)
 by CH8PR12MB9792.namprd12.prod.outlook.com (2603:10b6:610:2b5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.19; Mon, 9 Feb
 2026 20:55:41 +0000
Received: from SN1PEPF0002529E.namprd05.prod.outlook.com
 (2603:10b6:510:33c:cafe::b5) by PH7P221CA0042.outlook.office365.com
 (2603:10b6:510:33c::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9587.19 via Frontend Transport; Mon,
 9 Feb 2026 20:55:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SN1PEPF0002529E.mail.protection.outlook.com (10.167.242.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9611.8 via Frontend Transport; Mon, 9 Feb 2026 20:55:41 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 9 Feb
 2026 12:55:20 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 9 Feb
 2026 12:55:20 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Mon, 9 Feb 2026 12:55:19 -0800
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@nabladev.com>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <rwarsow@gmx.de>,
	<conor@kernel.org>, <hargar@microsoft.com>, <broonie@kernel.org>,
	<achill@achill.org>, <sr@sladewatkins.com>, <linux-tegra@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH 6.1 00/69] 6.1.163-rc1 review
In-Reply-To: <20260209142301.913348974@linuxfoundation.org>
References: <20260209142301.913348974@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <6d38663f-41e0-4d77-b928-55f295efd42f@rnnvmail202.nvidia.com>
Date: Mon, 9 Feb 2026 12:55:19 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002529E:EE_|CH8PR12MB9792:EE_
X-MS-Office365-Filtering-Correlation-Id: aac87ea5-9591-4042-d8c3-08de681d960f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700013|82310400026|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VzdjU1dCeGw3VVdjSFZYdUpFMWRNL0JpaG5FWDJ2d0NjS3lqTlR5SVRlOXZL?=
 =?utf-8?B?OFZVZGtpMjhEZ29yejNKeVJ1cjNSTnZLbUhPQTRnNnVsMGhGZGI5Lzh6VjBS?=
 =?utf-8?B?d1ZxUmdReWtiNzFIbFE2c2hsanpJeXlrdU0zUE41Qks4eHZTZVVzaU5pMFJo?=
 =?utf-8?B?Yk9PaVhISC95YkxQOTl0L2ZIcE9yQ0RoNVhsWTFYUzkySERObUVUdWx4STVV?=
 =?utf-8?B?eWd5bU9mb2ZoMm4vREFlT2F0dkJSZTlEYlUzZTQrMVM2NVB4MDhScnE3THh1?=
 =?utf-8?B?S3ExQ3NCS2M1dVgvTEpZNWtWNm9FZ0VVSU5wanJKVzQ4SHpaQS9SZk9GV3BW?=
 =?utf-8?B?b2p6WmVyek03ak9UeS9mY2Z4OTRWTTNSRHJIRXVmWDJPbWJFYVc3bnF5bmRp?=
 =?utf-8?B?WUlJTUY1MFNmZFl2aEpZYk05NmR5Mm03MmxWRmhNbmVHVmRQYS9BRmVXQ0N4?=
 =?utf-8?B?aGNqRE9JWjljWGx5VklhNVIzQ2FheUdiRnptWE5Zd2JER0FzY2N1emFvNFNm?=
 =?utf-8?B?RXBoZUQ1SXZocjhiZHU0bEUwNkNuc2E0VFE1Z0ZoSEViRFVPbktRaVR6ci8w?=
 =?utf-8?B?by96U2VTYkczRVdmY3luOHhja0dFZnpOc0Y5ZHUwVmJ1bnh5Szg0ZXJwYUpy?=
 =?utf-8?B?bkJzYVR6ZENaN0R6VGNRSE5lT1JqMC84STdSQUdBdHZOZ2pidStOMTU4ZzFP?=
 =?utf-8?B?N0xzQzF0aVErVFhDUjhzRjlWYW1rRG9VUklaZXBDb1J3bzhjNk81dUZCUjJO?=
 =?utf-8?B?c0t0dzJDSG1KdmNubDdNa2M0N0pzMVVxRUxlTHlnK1dad1oyYWhDeFVuZkxP?=
 =?utf-8?B?dllTZkN2cGl0VVQ5UFg5QjZnU0tJcFk2UGo3cjJkei9rZ2MxSExlcGltMXF2?=
 =?utf-8?B?QjM5Y0JialEzb0lpdGlpbUIxYmxheHU4TkMxN2tvNDR6cGZuR1dobVJ4ZTNr?=
 =?utf-8?B?UiswdUllNnNBRDN4SzJHZ0haaUZ2T3poaXFoS2hLOGZFd2FvWnRZUzExOUNQ?=
 =?utf-8?B?aWVERWNIeEQ3cy9oK2pmUGx0cnVGUUR0V3RScm9HWHY5SGZIcHU2bFYrdVJE?=
 =?utf-8?B?Y3ptL1d1YmJTUS9yTE1BOUd4a0RFNldRWUs3R1ZIWG1Jb3VxaDlvZk9zSmFP?=
 =?utf-8?B?emYxUDFUYmFuUDRRakV0Tm9xVWFUUnNDZTFIUXdKWVVkTmg2SEJ0clQ2WkdG?=
 =?utf-8?B?dUlHSCtMcldzTWNpcjB3TEhjNk51ZjgrZkIxZEdOYXFnTUpTczY0L0ZMTGZG?=
 =?utf-8?B?Z3dmR3grNGFRTzlBZWZLK2NCMFRlL1U0dXNmTlpNYisvWG00MGU1aUxwWmZP?=
 =?utf-8?B?bHNrTzlsRFdsQlNXUmhiV0pHOFJYY1ppVGYxcElYeFV1Z2xmRGFnTWhrYU93?=
 =?utf-8?B?bCtpeXhRUVZJVnRvekNPcUp3eU92SU9vTDVHTUpsalBZcVVQV0Yxc283bEpt?=
 =?utf-8?B?dmVkVldxS2k3NEVGQVA1TUZoRGZvN0hvRUs0N2Z5REdMTDZOcHIyd3p0NEJQ?=
 =?utf-8?B?ZDB1UHNTeWtKZFRFaGxxNERiVE9qYk8wZXhVWGYzOWtFWURldkFreHFiT0JQ?=
 =?utf-8?B?cUVCWGQxK0JLSU5oeVBwOWZOM1JZL0hXalJwV0ZaS0pOU25Jd2QzNFJQK2VL?=
 =?utf-8?B?MU1iazBrRTlSaGRrNjJhZERLaFJ2S1YrSDFUOVdJL0t1NVJqdkRnQ0tUMHlu?=
 =?utf-8?B?dWNrdk13Wjkwc2paT2ZVL08xcm1CTHZibG8rZkxudXJPN21CYWUzSTRBS3d0?=
 =?utf-8?B?UmF5WUFob0tPY0xra1o5V1IveUZHdExubmpDWWRhTHBRc2FCdWM4RTQzdVdM?=
 =?utf-8?B?ZUNUSWZIUVJuVkFoMTJ4Wk9nek1XV1pGSzRsMTZwWjlMb0NqczhiMGgwSkdD?=
 =?utf-8?B?TXNMUHpyNmV3M0x5NkJuN3FQamhqTXlTU3lEL2FUeWhxRDBrTS95M0phTS9t?=
 =?utf-8?B?bkxDbTNyZHcrVHZNL3FVaWdsL2Y3ZUl6NEhRSUdzdnJVMUFuNHJ5V0FpM2Q2?=
 =?utf-8?B?Skh4SmhPRXhwRGZqekZvWEZ0MnVwMzlIU0pGVDZxU1NnL2lMZGdjWllvRGEv?=
 =?utf-8?B?MHB2b2YvSWlmYjcyN1hqcUZaTGhXVzlCQm9VNlN1bGFYenFNVXBXVmZPb0VB?=
 =?utf-8?B?VmU0RmJnOGtvSjJreGlsSU1NbURGemJyZ09wQkNnL2R5VVUwb09wU0JSMiti?=
 =?utf-8?B?TXgzTlQ5Z1lUQmRLbFVrQ3RsUEhrd0J0enp2aHVzQnVmSWNhZGpoa1JwUlNO?=
 =?utf-8?B?MTFiSUVVS29HTWlySENtZ2kyTzhnPT0=?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700013)(82310400026)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	npB6lsfNKUjQWNISDSEaPjNEqKASgUo6tUw61mIrd7kcSTozXZpD2cKN9kQAPausrUZFG+BY7NNg1uNYtA19MRd1riR1ei0zwc0MtyA4rj7dZYgdo+098F0iH0ABOwDGzRjJh1H6QvmyRRZl8OS7JHPKi3Ul+GYX6LDJDTKhr/NGp1HIEggGY5rmoaE94yOm41auRNBlGLE+ZacdC8Zupt+c3SclQv9a69n2lOEkh5AJO9ILbKA1z16cANFZx/HRz0/dBqj8AWfZmwMFFHTUYPSOsieshKVNl2n1bqu5nb9jK91Yz51WJYA2s5Vs/weDj6h2Hwbj1xlD+OmBAGRz44A9x34wB4zd4Apf+1RYdmkp5AGW0lODtzgVRh/6dfRyy5tjEbma8ztVlnuPC3ErwDhntSRv2noCwleWCtkSuTC7RcOOEAueQWx5BP7Yh4cV
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2026 20:55:41.2735
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aac87ea5-9591-4042-d8c3-08de681d960f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002529E.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH8PR12MB9792

On Mon, 09 Feb 2026 15:23:28 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.163 release.
> There are 69 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 11 Feb 2026 14:22:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.163-rc1.gz
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
    132 tests:	132 pass, 0 fail

Linux version:	6.1.163-rc1-g62f87bbe8e73
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
