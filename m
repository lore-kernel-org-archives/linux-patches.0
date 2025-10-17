Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011045.outbound.protection.outlook.com [52.101.62.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9CBF2561D1
	for <patches@lists.linux.dev>; Fri, 17 Oct 2025 18:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760725022; cv=fail; b=I9StZn6O0XO5uXXO90hcr5lndJajVNcDvkR8WOdWmtloxHr66+Ap/AhjtkJ8kuytN1wutGG7oRvHHXjuqDP1VWYUWJ06Fy71Z4SMRr9hoOE5aJ3qH+96hYz1BQaiBafIaCdjuGUfeWhiGHekPqMvHzTCkNtQxFkV/m1jhio54t8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760725022; c=relaxed/simple;
	bh=w6Uur/VeIn+ZU68m2rX34qNTqqKxIFIfG/IiKlgVCR8=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=TqA6VDqwRkpclpdURB8XbzOWLL0RVB9AUeUpMbIo+jB7SBXsPnPn2hVcMfw3D6jogvl8YFuW288vhAnQbRMxVaJoM7PibsIT9eVECVoSWvjeIjSzDrnbHsJlhDR4wERhUcbpUdEkuGjTmJOHAbOJiZp0+tmFWYpniwE6ln1T8+Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=taQj2hrJ; arc=fail smtp.client-ip=52.101.62.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="taQj2hrJ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yl5IDgBSCjkmG8AV4GIVkYfS3W+UeHANHa0OXrPyX3ZiPF4aMkriu7w9o9ZbytCAsT2UIRgDfON8rrpW8BOB2mgoqcEoxZ6q/GTlPf2Qm4P0pcZ4pKBeNaHZCtpUJVFDAtk98ARvF4TAiCbTKuuRb4XdgEumBB9s+whTEcYvOvCfNR4xb5UwoWynQWRNmI4NIFqcLqEv2txARX2rmhdgqQmEcm+Pw+m6K/UQ2/xOmTrIQsUo7vYlnU/gENED9AKn1/dAakdVRgfK0dRoyKpRljfiZ7fombvSENFAMpGAju1IzNGfb8OJIpZcAiunU99Ezhp0TJfGbPnmRbn2xypU1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UV4eW3qBg4/MZSSY3FoZgFPPy1QU+ZCe3Fol/IHbUfM=;
 b=wJXRBnp45nbXmhpSs0PHnOiBsILochwUBZzxNGfHGdhAzhHWDVcFe008UlxVtXgNrGczQ/nymFlWz3DYk4zANTTS9SrBmHEH5jshvAyIF+/oB6vWvsPW54/pfb6TG5N4TuPt1CPeDNEki4obHFseTXCuL0I3EfuyTbsUrDj3n8HhgzeNQxZQpEGRK0+lFVCj/oFRRoDay0j6v/boG3VBvvJraF3ImpsYL7gJg6hiumOhgS9wHbBoJ0xLogkowDnLMISFkq8vipYSwjckH/mXPf0ApMfb7B7+WXzjYxNSIvBBcFsmgsFlac3uevcbN/1If4INBChGfkY+2yeHjd+eog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UV4eW3qBg4/MZSSY3FoZgFPPy1QU+ZCe3Fol/IHbUfM=;
 b=taQj2hrJ4S9i0EZgd1S3iHf2QDbnDFYdLf2mncM0imxacl1+VCvpcNdZnG8oP+Ty+w1XBx73zEvDyFhvISilX6g4tEryM6EbmEzavuiHdtAmlnKiaAsD46U93rv4gpYYRXx76r7iUNb1CBo55KS3JWDOR+8pwCQoqZSowAvZghIXKLzb44XAAf24CR+gCs6J3km8mD28UGgVSkOCkQ3ib/ca1ujsC81WhKOjX0QrP/6tfr0vgMCch8p9ZurOX/Cm7e+DssfMkPuLUbkwfJn6rfdc0lZpMkXNqPziFffdXbZ8JZ99fbXRXtXTVX/ES4BjCrBdVq/b+MvxHER7FvokJA==
Received: from SJ0PR05CA0194.namprd05.prod.outlook.com (2603:10b6:a03:330::19)
 by SJ2PR12MB8692.namprd12.prod.outlook.com (2603:10b6:a03:543::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.13; Fri, 17 Oct
 2025 18:16:56 +0000
Received: from SJ5PEPF000001CA.namprd05.prod.outlook.com
 (2603:10b6:a03:330:cafe::bc) by SJ0PR05CA0194.outlook.office365.com
 (2603:10b6:a03:330::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9253.4 via Frontend Transport; Fri,
 17 Oct 2025 18:16:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ5PEPF000001CA.mail.protection.outlook.com (10.167.242.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9253.7 via Frontend Transport; Fri, 17 Oct 2025 18:16:56 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Fri, 17 Oct
 2025 11:16:46 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 17 Oct
 2025 11:16:46 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Fri, 17 Oct 2025 11:16:45 -0700
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
Subject: Re: [PATCH 6.1 000/168] 6.1.157-rc1 review
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <636e0f53-c5e7-4331-bd26-2640e14fed73@rnnvmail203.nvidia.com>
Date: Fri, 17 Oct 2025 11:16:45 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001CA:EE_|SJ2PR12MB8692:EE_
X-MS-Office365-Filtering-Correlation-Id: 47a065a3-bfbd-4cfb-bba3-08de0da95aff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?M1QrT3BqUmxMTm02VnpmenBSM3pNQWpLY1gya3NFaDNkYkRwaVIxVjhNNnJm?=
 =?utf-8?B?MjN0akRPZk95OVhQQUxsMEQ2Ly80WnJLSk9qWHh3cXZSNnR5ZGQyejZXb2hV?=
 =?utf-8?B?STJERm1PYWI4c0JLM05VL0hRRVJHTXM2MGVxdkFHL2Frc2FDdVZZWm1FVWtC?=
 =?utf-8?B?ZlgrSUZuZmw0bi9SWGNKVzNyM3hoMWZibTVadzlKTUxOTkZWSEV6Z2xocjYx?=
 =?utf-8?B?YjcweVZaWlNqTENZbjhJbTIxVkZEcy9ZclROaWJMTEZ0S05NTHBwTXVHRGRO?=
 =?utf-8?B?aFRxQkxpZ1MxMHRvMHhJZFY3c1BJOTF6UGlTNFJQTjFWKzBaaWlSK2dlTHM5?=
 =?utf-8?B?Q0lIUE44RFNCalppSjlNa1dvcmhQQi9QaENIaFNnSGVFcUFWOTFndzNVK2xR?=
 =?utf-8?B?K1VIR2xuRmUxenJDTEdxMlJNaWdKMVJpYllVTmNuYWtqUW85em43Z0NSQVFI?=
 =?utf-8?B?T25aZXVtYUV1U1Jtb29GTjdxTnk5TmJrN3RVNGlzazVIcFV4YWFZdnRlTmc4?=
 =?utf-8?B?a3RoeVYrRmRjSmlGL3l4Y290ZFd2N3J5ZVJJdVN2WERNMkY3cVFscFkxVTZ5?=
 =?utf-8?B?Mjd6WTR4dFhSZWt1a0s0Y05GRk5SWFQrVEZQQjA3M1lxRndYYnJ4UzFYL1lI?=
 =?utf-8?B?WllvK1VFTGRaeWkzZUdScEFVUTRWaXhJTmpZUXovTVk1aTNySEcvQ3VIUG5M?=
 =?utf-8?B?UmZMYjBXdUpiY3FtRU9tZWxKVTFiQTFwTHdOS3Uyd05vbWhXQlpzTk5qVk1B?=
 =?utf-8?B?S1c0aHNDQjI3Qi9UZjdwZHhLLzhqZE4xdEFpWFZBUkV1Yk5JSFBCWEJuM0Q4?=
 =?utf-8?B?VFk4SjFNNnk4ZkRWUFRTUjMvdTlVUDNkTmZla2d0RGtIUlhpUy9pSkpBMXl1?=
 =?utf-8?B?WkdrQU1FM2Vib281NldheW9OU0RheDRiaHVFL2w1WVd5N1E3Z3NFVHhEMGR2?=
 =?utf-8?B?dmF2ZHc5Z2U0VDJLYUZ0aEYxcGdZSUhMbzZPSnJWNjIwMnY2NXNyY29zTjgv?=
 =?utf-8?B?NkJEeDR2ZzJsZTZRd0phaktDTUtmOFVGdmh3eENnOXo2enEzQllteEtlZ2pS?=
 =?utf-8?B?ZDQwTnJrNTdTNzgrNTNkZHAxU3NreWw5c2xvZ2NYbGN0aGtnOGtTbjZ1c2tw?=
 =?utf-8?B?Zm1uWW9jZXZOWmRIaEVydlM0dVJ3UE5HOHJicEtiUzkreS9ZNk40MTJlSGs2?=
 =?utf-8?B?Z0d5M2hGd2FZOUlmYU9lT1dKa2U3cGY2Y3J3aWkrdlBRaVdRMGdON0NiM0E2?=
 =?utf-8?B?c2NIb1BPMEFRSXV1bTlhbkp3QksxSlRNNzhnTk9Od1hVM291S3dZNnFpSzEy?=
 =?utf-8?B?OHh5cGxTUUt2OCtYeVB3Q3NKQnZlT2ZZajRKUE9TYkJJQXNlVmI2bnlXaHYr?=
 =?utf-8?B?WktWS0FHVHNRckloam1WVGU3cTNVc0NTSFpWSWQrSnpYVyt5dWtJWVVCZDBt?=
 =?utf-8?B?Zk9EVFVwVWRER0U5WXljanBSaDRBQWpIb0V0LzNyT01ZbEF6OWlQZG9tek11?=
 =?utf-8?B?L1Vad1UxU0pBQ1djc254Ylo4R1FXQ29uSTVNeHZMLzVKeUQzcXdrOU9vYTk3?=
 =?utf-8?B?QnlGREMwZ0drbHJDeFYxb2NVQXlDck8veXBtR0NqcmY3d0VyallRSE9MeVNo?=
 =?utf-8?B?aEtQR2s5MW45ckh6cW9pTVBrVGNHU0VBZDc1R2Q4OWlzdWRCQSsrOE5Kdk1Z?=
 =?utf-8?B?ZWtPcmJqakV4Y3hvbEpRckQxMUJFczJCOGZzZkZTcUMvUUtja01WS25hdEJt?=
 =?utf-8?B?THBlRFJSSm9FcDVsQ2s2RTJ0bWhYRjhNd2JtWWpzOENFUVJaK0JISjIyRHQ3?=
 =?utf-8?B?NHZqMFlNQnBsMzdVWXFjdUthbUlNR0JhNzFGdjcyR0FKTUk4UlFVaVpvYXo3?=
 =?utf-8?B?OE9VTEtJME5NZnhvNzRhUXR4WG1kS0d6dnZuZ2tXZjVaOEdxK3gwaHR6UzZI?=
 =?utf-8?B?am93QWtNcVd4TmQvMDBuSXZxTXZXMUN6THg5STJmQStqUjl6SHZlSUtobkZa?=
 =?utf-8?B?VjZPSmYvRlVyZGRRU2sva0NZbWRvMmtkZ1N3Ujl0WEVSSW1TR0FxU0I4cnlx?=
 =?utf-8?B?Y3BCK3NmU1I2T2w2M2I0VUczcXkxUmZZQjBVTm9QVC9mdlhoMWppWC9KY2I0?=
 =?utf-8?Q?szSk=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2025 18:16:56.0198
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 47a065a3-bfbd-4cfb-bba3-08de0da95aff
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001CA.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8692

On Fri, 17 Oct 2025 16:51:19 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.157 release.
> There are 168 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 19 Oct 2025 14:50:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.157-rc1.gz
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
    119 tests:	119 pass, 0 fail

Linux version:	6.1.157-rc1-gec44a71e7948
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
