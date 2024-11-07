Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2063.outbound.protection.outlook.com [40.107.237.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B73932101BF
	for <patches@lists.linux.dev>; Thu,  7 Nov 2024 13:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730986999; cv=fail; b=HbSF6ToG1hk/DzeoTNyxwwkfFi4diyQ/YeV5Gc3wvVQhE/rIjJlKwNOJnGZV0Rsllj9l5c5CIJWF6Bn8/NhzIF5Lqf5PSG+o95/Kuwj9PtS1IRT6aD7RS4ewTYTOsxayn/Q4NihCQAuv/kF+OwgsjOC1WBfHXQQ9xfPLe8aUgk4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730986999; c=relaxed/simple;
	bh=Ji4beCvMM15FhyoQRFHN4xGOYxyY92KcJs9LzjWxlh8=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=JhTlSerT33z8xP5OLbmOHmbla+HPfwujQcaVVCmdJPOdoPLPufgzq0zAhu98Vamd+2TvboTP3C+p5c7UXI1jXpZ3P/mf4Bp6v/4VVhSIkwvqZ9+DorWYU2Ht1WVTDWDwx14fOJpumLuokmS6DIeTq3mlqbmVrWLgt2eafmun1tw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=p5gY6egR; arc=fail smtp.client-ip=40.107.237.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="p5gY6egR"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LEeIsVxYL/iJMI55XzcpTii4An+HAb6ROSBCwgrdOIOFiK4zNkyCGS4umpbFaAPG3KVLHg86YmxaN74278+jNgeJ1OyF2Z6E9FiyQ1zPyG09nbo44zrYN0LWHhbdl2a+3DtkDWDGJmEvRg9T5+3aTzxTAs3PsF9rf7dUaaUQbkcjmGQ2OuluJfaKfwmMLs5Rq9ED4nZMuwVQKinlB4gaK1NJFtt/9x4E8eJewaaMGmUZczWHWc9eK1Ifqxt6/mCWNIsk9LmrsC00E+HMSDIk3JJDGpB5L5gPj80Wqvmha47gvaisyHNCnCNKcfFMvLzMRa+2uV7p1yf942k/H0MR6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zdKFEjSItajQlLkKCpApRJl5Jy/Wlu3g+yfXFU8GXJM=;
 b=kQvrNbiVUOTl9dvLsHl0isnk6lftgUAK7gOQfOddDOxVFwTZR9mRgBtwBBNKJbaLX3cOiPudn1l1uJtG9DPV9EPTy4Fww/xyxptLmEAxR0/nfUKHg38OmbooSMEC7cwuqQIzD43i/SsCona1/var91HN5mZjimjnQ8IcPmMpaCjGvEIVYnYpRzFoeZGt/ZdKXRm2Gc+w7JL+iJQVoQSV8x9Go2xJkFvTD4pU6ErDkIXgdmp8GPqxcN+kg0nyFo6qRbVhfOI4oeIbZmTIDWNZUmmnJvuuE+UwtAdDPwS1HfJygu1KDOtxtR6kBkdz09eOVbMT5btd7/Q6kRoGUnkXmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zdKFEjSItajQlLkKCpApRJl5Jy/Wlu3g+yfXFU8GXJM=;
 b=p5gY6egRqUkEoxWrex+EcyLWcl8Chj2cGnmVnDWJUbA6T9s5vQQYIQi8umgnlTg7E+2gwBEUxq0+tclL+SHb/zDUZZlzVsdD2Tyt6B0e2EhZUDnJnnwkmo87cU7E5JB+4ye6+YfA8pD68neCVfk29tuhMD43cWtBbr3d3zoC2CIse/c4HhSnv6EW5Wz2VEr0AvmkIIlZUTAny3zkLtE+NyyCYVZKsn27LrnUicJjIp9Hjz03I3inU+U2qxm0yCIYm3R8nP3LWpbe2NxakE0yPpBb04tAmrXunqs8ZX+lmDY41+OGBm5Cusvu3jDWDIyn0amN0Pgc4/KiP4xRcex4eg==
Received: from BN9PR03CA0305.namprd03.prod.outlook.com (2603:10b6:408:112::10)
 by BN5PR12MB9510.namprd12.prod.outlook.com (2603:10b6:408:2ac::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.19; Thu, 7 Nov
 2024 13:43:14 +0000
Received: from BN1PEPF0000468E.namprd05.prod.outlook.com
 (2603:10b6:408:112:cafe::13) by BN9PR03CA0305.outlook.office365.com
 (2603:10b6:408:112::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.19 via Frontend
 Transport; Thu, 7 Nov 2024 13:43:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN1PEPF0000468E.mail.protection.outlook.com (10.167.243.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8137.17 via Frontend Transport; Thu, 7 Nov 2024 13:43:14 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 7 Nov 2024
 05:42:59 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Thu, 7 Nov 2024 05:42:59 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Thu, 7 Nov 2024 05:42:59 -0800
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
Subject: Re: [PATCH 5.15 00/73] 5.15.171-rc1 review
In-Reply-To: <20241106120259.955073160@linuxfoundation.org>
References: <20241106120259.955073160@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <66252331-e18c-4ac6-97ef-33d7b3437dbf@drhqmail201.nvidia.com>
Date: Thu, 7 Nov 2024 05:42:59 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF0000468E:EE_|BN5PR12MB9510:EE_
X-MS-Office365-Filtering-Correlation-Id: 990d66a2-6976-4c02-c29f-08dcff3220e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?M01nZU8vRWtVRUk1Q29rbkFwYkl2bUd2M0VES3FMTFRwNkdWblcvbmdnYXF6?=
 =?utf-8?B?NmZ4NUZjTzJKTXJDZ3J4RlE3cVljVk9HR0JVWmliaDR1aVE5a2NkSVRkYUVM?=
 =?utf-8?B?aHNpVFYrZ3BSSUx1dTkwQm8weUdMKzBOMXRiRTloVEVsRGJZZU9ZQ0ZCU2lz?=
 =?utf-8?B?UjM4L3NXV2wvL0hlUGQvYUpHZzk3TWRuMDkyaFJxM1ZJbHgvOTJVNVNmL0hS?=
 =?utf-8?B?ekxCZnczSnZiZ3F2QS9HRWRGcjFaYWplOVRvRFlkdFZRL01HWFRKYm5XSVYy?=
 =?utf-8?B?SVhodFM1UHlYTmU1WkxkMHUvRW5LQVFOTWxwZWlObmQ1bDdrZ0RtWklneisv?=
 =?utf-8?B?YmpRNzdpS3g3TGlOUDF3UTUwWUhoT0hjR0NJMGM5Sks2aklibU1BMjRMWDl3?=
 =?utf-8?B?aDZFNnVCVUtvQ3czMHFkOWdvTnpXWmo5YkNZL1F2OXpQZDJxbDBNVGJWWlMv?=
 =?utf-8?B?dEpyTmtPTitDdDA0TW4vTjZPSFVTUTdqTnFNaW5RQzVOY0VLZjRnYTVHWUND?=
 =?utf-8?B?UXFqR2NtanhoOXRYa2tob09zbEdOemlYL3FjZHVvRStSc1Z6ODNJQkZtSkZ4?=
 =?utf-8?B?TzhrdjBQbzQ2NzgrYzRWK2UrRS9MK041ZFBtVW94eTNXME52aWp0YmphZWRq?=
 =?utf-8?B?TDFaRWtqNEVwZFpGSFdFeXlGcE94K3A0Qm1mUUEya3VKMFIrWk1wSkU4UUth?=
 =?utf-8?B?REFzREpid1d0MkNQaTFMd1dlTHJ1bDdmQ3o1Zi9tcTVjbFlUeWxpRDJtNElG?=
 =?utf-8?B?Z2ZESW5BbEQ4cnpod1FxbnlvQ0RFOXRweGdkcDZnVXh6eXFENGdDQURhZWkx?=
 =?utf-8?B?UGRaYzFPbUppamh0SHptM1VxdmxJckxLYnFnWmVhL3NLM2g1WXZtM2RneXVm?=
 =?utf-8?B?VnZUbk53TTR2MzNsYlZ5dXByQlBmMnJRdkxtN1RKR2NRS3gzbkplRmVyOXh2?=
 =?utf-8?B?S01LN0o4em9TSHRjYnNna1g3ZEo4bVI3b3B2YW5SOGZBd1djWXNTcE5wVDZu?=
 =?utf-8?B?UGFjVlZRd2lXTVFpRWZaQkRwVmYxcVdmUkxodE9BZm15TXF6Rjh6U0hBODFu?=
 =?utf-8?B?WUdXZzBaSVZVTFFaY25vd084NlF6aGVjbjl4UmhFdVE2dDRid1QrbUd2eG5p?=
 =?utf-8?B?cGNDa3RFYzYzMjJ1RzJLUjZUb090YnZpUDdGZ1FFS2xOTUQ0bDExZzRyZnJl?=
 =?utf-8?B?aEJCc3NNcUFFK21HK2IzWnZZWEtiaDhqbUJpaktaUFlVK2hYZGVGZURwUEZC?=
 =?utf-8?B?bHB5OEpGUXRBdDdKUHoxQzBwc2wzYTVUcjY3SUlHQ2RuQ1dQbG5nN3R6dTVM?=
 =?utf-8?B?WFd2b2JqSlB5NDRueVJ2TzMwdVozZmdPMGVIQTZJZFFmR1owNlh3OHV3N1li?=
 =?utf-8?B?dHBXRmR3a3ErT2hyRGxxZUFuVXdCU1BzUkVaV1VXWE4rUFUwR0RiNEVIbnFq?=
 =?utf-8?B?aGdwVEtZWTY1OFh0RzVpd1FXWHoveC91elNFanh3a2dNMTNML0s0WHczZTN1?=
 =?utf-8?B?RGNnWWVTc3pSVVpEeHBLSm5nWFVtK3ZUdzN3UWkvTmVsdzdpdm5za1FuUUFR?=
 =?utf-8?B?ZTFZL2xySk9VM2lWWm02MEVheXZxaU9GWEdTdTBsVldUc2xoK0ZFajhEQldl?=
 =?utf-8?B?UVJOazNWNXViNHNOMDQ2b00vb2ZreUxGUEtzWE96TlN5cjVSRGJxTDNoaFRj?=
 =?utf-8?B?OHdySVFHVmtwV2ZhN1NWalhqZmtJTG5xYVBHRi9OL0RMUzhEaHZMekMxeUtr?=
 =?utf-8?B?c3l3bENLMDNBRzJjb0ZQZ2NRK0d2UjBlbWhMWUorTEpicXMxVFNnM3p5QmRP?=
 =?utf-8?B?Nk5mbjk1WFg4OUlRZ2xhd2lzOTVLRFl4VHhnWjN6bGo2Y0wyMEZBQ0ExeHVq?=
 =?utf-8?B?UVVHMTVLU3d3cVNLTjQ3c0ZEK2FFaUdyNGUxSEVsR2dWMFE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(7416014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2024 13:43:14.3072
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 990d66a2-6976-4c02-c29f-08dcff3220e2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF0000468E.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN5PR12MB9510

On Wed, 06 Nov 2024 13:05:04 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.171 release.
> There are 73 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 08 Nov 2024 12:02:47 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.171-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.15:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    101 tests:	101 pass, 0 fail

Linux version:	5.15.171-rc1-g31772df529ef
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
