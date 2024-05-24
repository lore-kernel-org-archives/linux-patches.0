Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAFCC12C49D
	for <patches@lists.linux.dev>; Fri, 24 May 2024 15:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716564005; cv=fail; b=GnSBTlwI9FVTupKBXgbUlGGT7dm+VXjVxvehOq6dE8ul9UwNW1z3ra904rEaPYBHE1IQcneIz0fX/H0fSMPyR87ycl7qP9Co0hstz1fsDV5TaRLtvU5dg4cBwiWKjU0tZc3Pj2VTzXL36nOPYwX8JH75Le9Q1y4nnzmf8SIysa0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716564005; c=relaxed/simple;
	bh=i1lLw3Cq5IFZsVjWOR8/RaEwJIlyy65ckQdzx7H1fDQ=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=qpkP15eoxca/oI0b77J1gmybvxm9wki7UPpaBnep6ga1zsOhOU9VgG0jzZt0361GEQ356tK7KQN46RPYfm6JkjV8jCo7ElaTtlzRn7TkercMkYkFBPwtcHyujUKTg+hxP2eltSYKf8gOtoq3fZ0OJuei1PjxVb7Cl/O4s8Ilrt4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BBKg/XWr; arc=fail smtp.client-ip=40.107.236.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BBKg/XWr"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z+7GcaYGCVUdl0G5VxS5JJNdul1gqt/bBCFTT8xq2dYCR6V50hql58rPK6w6OxefI861ae2mad2rvUOrITKVvW/qRM18as+C3SJym+eVEfIlW07LDZg5ktORJs0v0mn5dIHt58y2jWIFg2540A6FJp4XOgRJTyY1lA7q+00C+XfnBJvynU1gLPjcYZhMrE696HpSyyPSfuEBC/NpZJ4Yc0Rc1L/H1xV119rsPmi2ECUEcoANAfuc7HzkHLwjOVZxNKEQmcE4cmNY2Xh2/NSyELQybfz1A7ZRB3G0geHILqeqxawsuWDbgLXHYgmjldwap1JLiFsyTqBC5KYqnGBYLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2nHCPaXYaN0rZ66WY7qD2RgDoP8+IQaF/Im0KLERxqw=;
 b=I6AzcBrHrUhNAELe8BzJG8xNVQ6XCx5OburEGjXDiHCWoe9aR0rhFghyoNnY62bvbn/5188BmG1sApDQNAt/7XsOkeP0rBIxnTo1IL1q82uj2szv8XU0+UMnXixe+RKCyOEbjR3C5NQJogYtEI/Kj688GA8hQaCCNw4pmxkI7BifXqW37RSwkQvFXrxcvXoz1ZWIAEHqVEWqNExCnSeUyF1JdyS5jEZRFimunFTjJ6SmYLD6f1qg9Ya9auKqwrty+eFFJQqBStMYZ25iVS3WSS4m3gHe3tk159+eMl13oFO5yyvL6+i/1xCITWHdZMkkT4m3ntWEQ0auwFFmDVL/bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2nHCPaXYaN0rZ66WY7qD2RgDoP8+IQaF/Im0KLERxqw=;
 b=BBKg/XWrd92JQ+3LOOoJniINvu4ibxCe6ae1gdnAZJvcsYLXMKlAlDrg7CFC1I/GMc+m8hc/jVloXMyOb/nuM7VbGPQKkS7FrN9fZssTdDLdddcyJIS6fm/R/f/keH65jqXAk4vqSiSsS9tYWamGDFlEECJBezHiiKUaA1dQTasfLhI/OvDEwd8SXdAZNsmrGhv9KyHJTOVSc2cIkrKL5xU5ynN3DIamc+XY5nPvG+A2IjScO0Q5Qk9gZGkOYPaup01Li01XiMOirJG6XpDvl8d0Lv/MhDP0lHYlbqVCmlNvhKNNpuEQoRr8pcobiC3rzwmijKEbp5MA0tUY3wPq6g==
Received: from BL1PR13CA0195.namprd13.prod.outlook.com (2603:10b6:208:2be::20)
 by IA1PR12MB8190.namprd12.prod.outlook.com (2603:10b6:208:3f2::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.36; Fri, 24 May
 2024 15:19:59 +0000
Received: from BL6PEPF0001AB4A.namprd04.prod.outlook.com
 (2603:10b6:208:2be:cafe::f6) by BL1PR13CA0195.outlook.office365.com
 (2603:10b6:208:2be::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.9 via Frontend
 Transport; Fri, 24 May 2024 15:19:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL6PEPF0001AB4A.mail.protection.outlook.com (10.167.242.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7611.14 via Frontend Transport; Fri, 24 May 2024 15:19:59 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 24 May
 2024 08:19:44 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 24 May
 2024 08:19:44 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Fri, 24 May 2024 08:19:44 -0700
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
Subject: Re: [PATCH 4.19 00/18] 4.19.315-rc1 review
In-Reply-To: <20240523130325.727602650@linuxfoundation.org>
References: <20240523130325.727602650@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <e2c8a3c0-ae85-4b19-b42c-96c159a03636@rnnvmail202.nvidia.com>
Date: Fri, 24 May 2024 08:19:44 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB4A:EE_|IA1PR12MB8190:EE_
X-MS-Office365-Filtering-Correlation-Id: d4e667c6-ff37-4d50-405c-08dc7c04fa09
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|36860700004|82310400017|1800799015|7416005|376005;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RVplSTYyMis3UlZadTd4R0o5UXdtaWRwZ0xnaGZQTzFHTzJXS1BncC9CVkVh?=
 =?utf-8?B?Lzh0WTlrOTB3b1pQZ1RzUFFYdkh6cEVsbnBaUUoyaVFXQW4zSHFVL3E2ZDJG?=
 =?utf-8?B?eU82dXZiOHRhbS9ieXVEUEhYSXc5OGsrOFBxUVpQNTIwTWpUR2RDVmVuQ1pX?=
 =?utf-8?B?cVdSK2Z0Y2ovNjhxSDUwM3duQURtMkRodkZpTkQ1SXQ5eUxGajZOTWI4OXhq?=
 =?utf-8?B?czBHSzNLUDFwY2lCdDNxcHk5VnUvbXlDdENsaGhDT3BVQ21zVlNYZENKZ2I0?=
 =?utf-8?B?b25RcDU3aTNSNGNXU2lxc1ZRd216WWZBaGlEWGY5UnV4WlltYk1qR3RmZXJT?=
 =?utf-8?B?YmpvajQ4UmlJSEZjYWg3eHFwaWROaVZrcCtaTVJIbE5keW1hTEw4bkk3T3h4?=
 =?utf-8?B?NFNPNEJveEJxWU42TmdNajc1bmNpcnYyR3MySFlZK3BxeGR5OTVXMndaUmxP?=
 =?utf-8?B?bzJzVHhlbEdSckh6VDExL0lKekNGU2tFaWVwK3o0RXN6UVFQS3ZEWUdBVUVN?=
 =?utf-8?B?MXZWT245bEE5UkJPd2RkVVBmdVpJQVlZQUhteDh6L3lmN2VXSklkWW1CTzJZ?=
 =?utf-8?B?alNJdGNvVVM2UEdBOUFOYWZYRkI4UjkxaW1WYWJRclI4T2VDZnhsRXBZWHBM?=
 =?utf-8?B?OHJuc3dyUHQ1ZjFBWWxlaXhlSGhhUy96ZVZ0TzE5a3JkUkk5cU1kVURVcUdU?=
 =?utf-8?B?NzNkTWpQVVR3QVVvdldoQXFsaUtLS1MwamNTek41cDhUOXpybjJaSGkwWk5q?=
 =?utf-8?B?ZzJ1aWNYaEhUNU5ZTkhNMDFxcFhBMDhNWU1saklGNkRSRzduSWxDRW05SlNi?=
 =?utf-8?B?bENoSWMrQzh2dVBpdXdMYmJMdnhxZVZLR255ZUowRjQ0WlU3d3p6djVYWDkz?=
 =?utf-8?B?b0I5OWhwNkN3b2d6QnE4SU8wczdML0dpTTlWRnBqRUt1MnIwNjFiMi9Nb0Fq?=
 =?utf-8?B?Tnh1Y0tJQlZSK1ZlcFdpUXFDMW1SM2lnNk5Fb3NYM0Myc1lIYjE4MitSNUhB?=
 =?utf-8?B?eDVlV2xRRVRYeFRpN1J0TU1JTG8ybS9LcndlVFJzZHJuWmgyaG5CUlVzYkNh?=
 =?utf-8?B?dXJQUzFoM1hmTzN4WGZFUTVubTAvS3BFazBGVlFlQVZzZHJoWFlTc3hEZ0hY?=
 =?utf-8?B?NDdVK25TdkhGVDByaUdtdmdrSHM1Qll3T0xkb3RpNVhDMU5QVERTSjdaOVZo?=
 =?utf-8?B?emlTWWgxUTcvU09rNFBCVlA3ZWZYYVlFNGgrWStrTlVrMStkZWtPN1VtZVdW?=
 =?utf-8?B?UEZ6UTZKUWh3MEg5OE81MW1jUm04blg5ZU1BSStxcEU5bGFKeGxjMG9PdHRl?=
 =?utf-8?B?ay8razZOMG5SWTgxNStNNUJsYlN2U1hEWEFSaEFTd0hya0Z1RzJ4NVpkUlNP?=
 =?utf-8?B?UFpEL05jcE5VcFdhOXRYcktUVjVRbTlvckZSZWpxbkdmU1ZGbG9TQ3A5Z3Js?=
 =?utf-8?B?ZHBFMXJ6T0lEc3ZZZjg1Z0NDTjZMczhwbWk4V3QxUVVXMG5WS09TRDBwaUpY?=
 =?utf-8?B?Mk0vQnZhdzVFTFJsbHI4a0dhaFBxWGdUcjEwZ0hNNmljRlRDVWxCWHcwbjJI?=
 =?utf-8?B?VkRDdGFHZFZkLzFJUC9EVTloTjlFb1ByYmMzOUZEODhWY2g1d3BqTXl2c1Jh?=
 =?utf-8?B?dFFEV3YvWGtHZ2c1eHBGK2xjU1JVQkttOU1rdzRTU2ErNEtXNHZibWsrV3BZ?=
 =?utf-8?B?RWpoMElPNFFPYmQyRzhLcjZPUzNldEJRcFFlaGVnWEZwQ2V2aTF1dnlHRHor?=
 =?utf-8?B?Y0F0OU9ML2NjSlZiSSs0TGcxVnhjKzJ2Z2tob2dpWkdEYU5HVjVwTHR6Y0ta?=
 =?utf-8?B?VFZoK3VSYjg3Nk13STI2ckZpN3RLVWlTbnRnV0RvN3o1ZGJGWFdhb2VFamta?=
 =?utf-8?Q?v9t0V5VST4SeO?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(36860700004)(82310400017)(1800799015)(7416005)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2024 15:19:59.4516
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d4e667c6-ff37-4d50-405c-08dc7c04fa09
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB4A.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8190

On Thu, 23 May 2024 15:12:23 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.315 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 May 2024 13:03:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.315-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.19:
    10 builds:	10 pass, 0 fail
    20 boots:	20 pass, 0 fail
    37 tests:	37 pass, 0 fail

Linux version:	4.19.315-rc1-g35248f5e8353
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
