Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2042.outbound.protection.outlook.com [40.107.94.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EFAA25EFB5
	for <patches@lists.linux.dev>; Wed, 19 Feb 2025 23:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740007770; cv=fail; b=pX5k5qSX8HImiS+Ijp5D31zzcPX82wU1ngD8uas2YqJNz0pfstqUzP2zRGU8tlN/OHuO/OKIrxUBZI09FlsqY4j3SBiQFso2YvNkSmCbIjktC/RCjEMLNTadmshDhuEIIVR8lkGakxEqsQZ+ARf3TsZJF6v3AYAkNBY9jvCUKaQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740007770; c=relaxed/simple;
	bh=POyZu5E74kLhZhjxSfJ/WgO57FkFxc9sRSQgCZ0+XEw=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=OVoakVW36Y13Hd93a54y54p3ZHZhIQBuMsthHW9U6lgOaarWDWU/a4/Y2lnOpOLmPQ6ziu6E3vPfFEhQhfoOGBTOQPZmb7LX/puLUXR3BSwSfcFUsrDBv045MdJBKxAgRlniyyzF8/sOOI6uHqpzU1hwupL1UaHgPbB4zgpNwzk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=eizMWr9S; arc=fail smtp.client-ip=40.107.94.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="eizMWr9S"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xEhrKhrZT2r0hmsiLSuuEaKPan8ZEjTTsQ41fls5VImGWdk8ArTFYESeoSew9D2vVV200+b0H7AyPv1XhxZn8E1am2uNuwp/bZ08jiUP8rfEEjF/jef/EUatU2b23XZ6jzs7iTaMzAyntjs2sfRMnMl3NKgjzZFi5jeStfYdpT5XHNFHmub1/9zLnVIbhHW7Ukw2KJpdhaFU2Rxt0b35QOs7Tj+ad9/KmgJYQMKFNkx/7Us4DXuG+5xAqAMF1JwaRBjPT7a9cs7OQYEisCT9YuMglXITpEYKpAxfKp7hC5aNwm+nWcaLW/NUCucW7KJl1y5sF91H9Ybg1N+tULsG3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NUlBjhS/dr7fgcuE6r+3alO+AsiUuBApgnO/I+hG2E4=;
 b=xiZGvtK6tXk08fvRzHj8ZsRgaqQPyqecbxCpWOwf1kQJ0V3qHFYt+VGMEFXvzloF5n+Z89lloPlreS5T2fH0C41OTem5UtNn4TblqC6efxCFLdPV8Guojfqsg4dgkitV4QKHyeHptEpusjUopWK1eno9Tb1jqX+jizP3gJldlzWjtUrpLWc7BWwcCd7RcSK8xUxFjfGtAZu1ITGQ6n6HRCuYCy+KqJE5e0V9PH08r2z137B4trEoalfb41/1baUWTwFr7QpUYQdPe3kI+fOvmmdUo2OSW7g4dopD4tmKBL2e2lyDJPnm1Uxbsq1uhC6SQGLlb71hREvMPwsY2gw+Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NUlBjhS/dr7fgcuE6r+3alO+AsiUuBApgnO/I+hG2E4=;
 b=eizMWr9ShtuDoza9FS9Q/7KFbX9NIkkxHD7uESnhadCc33VqDFQEEWgg78Mwn8KOyytLF57jQ8HS0FtrO8HhF7oi3imWGQnTrxZOYmnm3/LKWO2W80gsgUCpUdGXVmCv7llhiLHDuyUpPydwXH6Ya7Cdr10kDuSheDwkBfX9kVWsQJrFhsSLRw8naVW5mShkNywmk+aqeul0nrm4spJruqXPEKeC7U8MV2O11PK+BvJfNVE9wnlgKVKGa1LDH2MTzyaYevnjoVpsmqqvgc6uJ0EUzm3uqZLw/mZMnECygH7jIBIYf4WeI7RDjBVTmvbrvi4rqLF9VCkcqe0JYvaZ3w==
Received: from CY8PR12CA0008.namprd12.prod.outlook.com (2603:10b6:930:4e::12)
 by PH7PR12MB7795.namprd12.prod.outlook.com (2603:10b6:510:278::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.19; Wed, 19 Feb
 2025 23:29:23 +0000
Received: from CY4PEPF0000EE30.namprd05.prod.outlook.com
 (2603:10b6:930:4e:cafe::d8) by CY8PR12CA0008.outlook.office365.com
 (2603:10b6:930:4e::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8466.15 via Frontend Transport; Wed,
 19 Feb 2025 23:29:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CY4PEPF0000EE30.mail.protection.outlook.com (10.167.242.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8466.11 via Frontend Transport; Wed, 19 Feb 2025 23:29:23 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 19 Feb
 2025 15:29:14 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 19 Feb 2025 15:29:14 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 19 Feb 2025 15:29:14 -0800
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
Subject: Re: [PATCH 6.1 000/578] 6.1.129-rc1 review
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <ba978f1f-f3df-4a8a-a618-004c7abbafb9@drhqmail202.nvidia.com>
Date: Wed, 19 Feb 2025 15:29:14 -0800
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE30:EE_|PH7PR12MB7795:EE_
X-MS-Office365-Filtering-Correlation-Id: a28b6c00-9186-415a-01cf-08dd513d3e56
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|7416014|376014|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?clVuVHJPR1lyWEJ3K3NBWmNReVlGaCtKNUhEMU1sU1dMRGJuSVhBZkZ4NFBm?=
 =?utf-8?B?RSs3WVI2Y1JsYXRYS2RMdllydE9IaEM2cFF1ci9wTDFHZzlHSVVKNXMwVGQ1?=
 =?utf-8?B?ek41dGdkMXdqVEUwNHpVQ1VaZFFtS0pYM1dEQ2hqb3dFbWltdGZTUFVnbzBx?=
 =?utf-8?B?ZXRyUzNXSHdZZkZjTzVTUE1JcDFPbTdDai9pc25HUnd1THFIYmtoKzI1b0Fr?=
 =?utf-8?B?YjdpWFB0Z0Rma1YrUTV5MUxUaTcwakJBYjVXZloxTFBQSFJPa0VKcG1jZHZ3?=
 =?utf-8?B?NG5pZHY3cElGZ3JyTDNkOFo3cjZyUmZYM1NxM09zTi9mazdUZjJPYy8zLy81?=
 =?utf-8?B?QVFtN0ZRMnErSXVOcis5NUQ4UWw5MTJqUm8xZGdYZDcyKzBiNytxTy9NK0Zo?=
 =?utf-8?B?TzFrUENjYVo1S1A1K1FMUDhUUkFhMjZrMm9aMUltSGpCV0RLQXZiNzVGeGgx?=
 =?utf-8?B?ZEdvQ2FNVVU2ZWRTOHMzRDJNUkU2K3g1NExkMklCeGJhdXhwZnpJQmp6bEFh?=
 =?utf-8?B?SUxlOGlveUZXR2N2eXpyaWFZNXA5ZjVud1d5RTRabGE1dEloS096T1ZBZVcz?=
 =?utf-8?B?VFdFQ1M2R0ZFZmlTaEdLeFJHMUVIRHovMnNqd1FEY1N6cnpyMTV3Q2tMSFNY?=
 =?utf-8?B?UjNOa1lraG9sU25vYzY5b25SVFU1T3lFd2RzT3FYQk4xMXF1dHFrUWJVS3VR?=
 =?utf-8?B?MlBzbTJLUkdVWUUydzg0dU9mOHJMaW1UeUNxUDZDQjRseE8raW5qbFVQMDRz?=
 =?utf-8?B?SEU4UXpJN2xTZU9iUTVsZFpTUHhvWmJObDZJdlVkZUwrRlFZVG16ZkZIZ2FT?=
 =?utf-8?B?SzgvWnFGcnRzSGFmejk5RUhRRHFqNlNEMkdRNnVkVzdJUlRjRnI1WXBOYXVj?=
 =?utf-8?B?UkRtL2ZGTm0xOS9NZUxZajdUNXdTWlAreW5TSG1keFVFOEwwVjNWOE5CWVdu?=
 =?utf-8?B?cWg0MHFzcGxpSmRwdW9HSGFud09FZUh2d0VvN2E2cXpDbVAyRnJpdEVqcTho?=
 =?utf-8?B?Sk1QZ1l5SDZ2SVB3N1djUExyMnFaV3QxTkVJVjhmSG9vblBabTFyb1cyRkYv?=
 =?utf-8?B?WksyWGNCZkxtWXp1d3JWMEJWcWd1YW0rVUlFdGlLZnR3L1pxWkpsY0hGS3pI?=
 =?utf-8?B?N1JmYys4dHBvbis5NlFTd01XYnhPS1h0RGNTWWQ3M0d2Y3pqTGNGZytxYmJn?=
 =?utf-8?B?WHMzdlFZUEZlOUI5c2kvbnJaLzdrZVVXblhFV0VnYnMralBjbmhOcWVqdlZk?=
 =?utf-8?B?L0JXK095bGpCZWg2OGFXcXJBSXUva0FKbTZScFFua3dhNHZwV010Rm9VT28w?=
 =?utf-8?B?a2Q5MmtIZ0ErL3B0Mmh1ZzMzVFg0ZDlKMkpCMHUrYmZTYm9QKy9OQlBrcFFr?=
 =?utf-8?B?Y1RBczJUTEloTjRaWFNnZ2J5NzhUeWhxamtkSm9ZeWh2ZXhoNkIvYlJSQWtG?=
 =?utf-8?B?KzB0dUNMQm8rQWxGcE1yOXNuWnRJeXIxbFM4WXk3a01jU2dydXMyRmJvVjN1?=
 =?utf-8?B?ZGxkMHdNa2NHN01kREpGT1lpVkVoWW9zaEdPUEpoRGdxOU9oV1ZxUEg3VUx1?=
 =?utf-8?B?a1dxT3ZDVW10M2RYTVUvRVUvMktwNklONFpYWE5qWjZmam41K0hKQ3BCVWYx?=
 =?utf-8?B?RXZFWHFwdU9YV1pWdmdjaHFtZEgzZkgyeTVQNDlVUjUvYlBQVG9vQXRIMjhM?=
 =?utf-8?B?QTNPWGFlMDMwcE9ienhOVzc2dFRid2FCZXF0c3YyeEE0Y003Y0ZZWFZ2eUls?=
 =?utf-8?B?aldkRUdNWW41TDlNMHllUDN0Z2F0eDBUNUtVYzVYWVdBSUg5VHBRRTliSXdH?=
 =?utf-8?B?UFRwRnU1d2xWNXZ4UmkveTIzL2ZjR2tGRnZpRGtTZEY1a1ByQnhmNlE1MEls?=
 =?utf-8?B?VldMQlc1NDFKb2k5QU4yL3k1SkVnQllXYThJaXRkakk5QlU4cTNaVEJXaWM3?=
 =?utf-8?B?d1F1U0hTM2NWdXdNU3ltWWhkb0VPTWpoVXpudk9Ka0puSlg5OTVQVC9uendQ?=
 =?utf-8?Q?IlAtRlXkyeLm3knK4ds60JJ+levPhY=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(7416014)(376014)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2025 23:29:23.6063
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a28b6c00-9186-415a-01cf-08dd513d3e56
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE30.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7795

On Wed, 19 Feb 2025 09:20:04 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.129 release.
> There are 578 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 21 Feb 2025 08:25:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.129-rc1.gz
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

Linux version:	6.1.129-rc1-ga377a8af64e7
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
