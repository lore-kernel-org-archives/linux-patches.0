Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011067.outbound.protection.outlook.com [52.101.52.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2F2927E1C8
	for <patches@lists.linux.dev>; Wed, 17 Sep 2025 20:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758139725; cv=fail; b=NIN+HNGiPM0Dsr7P7q8IGPJiGMtTbnbAiB/4V25w5anXt8lYY2dpGrdBMCf52jn7lYtLGidqfdvo3P5W3w+6Zt4Ia7T/dt1eottFjrJoQgJiV0VoTQ1xwmQ8XaWWaP9beLn+eOV+1EKwmge8+LUca5nzfi7XqFaVyGhHPMuRjR0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758139725; c=relaxed/simple;
	bh=Gilftmz7cRzsoZ8DkyccsLA/QAiL3UboPFqvmxkbGhQ=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=IztBWPRCDqR+jJEIPksX/KEevQXt7EwXirtFOphLUE5PH1lizzsT+mpWwJi6923exqm2tuSDVC9OzfFG+6FS9tlYn1brbYD2Xwin6H3gpGvHrIEZpetYTywXzo4VR4UTxKq+fF5G6XshuzE15uP5NZQ0sjw+KmPgENST38G3WZo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ky283DZn; arc=fail smtp.client-ip=52.101.52.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ky283DZn"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dWKNU/G03l21ETzSyClsABI8tPTv4y/AKbs5kGIjfJh+ISGYdRtW9Cn2QUR/eGCfky6WPPzDaDSzy3bgkZ2DELTSfC4cA3E3o+7X5h6836wjt3jkn1pOOHyMWT0urqj4sXj8FrAI5545BGBRidCshM6Et/MfVwrXJB0n5w8kXdQQYxKCv+F3sJ1c6urPOd7LdxIqWWU5xvAvKGBVPv1xqGoetZvDoMi64blColJhmgQPvDttFnVnHN5O8XT62MX7UgTfVUcmzEweVLKKtYjzY2fTdxj8W+cOvlzh8aZN795Veyivh8DwLF/ClHWAKQ/sg8ld7u9EM1SNLGpR2exZzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YvpPJ2du6id/Z46SUmEKMmDF9xgQmdTUxyri1aRxPQ0=;
 b=fMIn9Lf8E1Ij2vyqHKw7oJieKRSLly9kgi1QWhagffxVwUjS2AIR1Nqq/9fdTKXNR+HxtxGAbtHlgWQTUyslLWxOSHPOczG4p5qdIM3SY5LOgUgzhj9JVyvSJPJLAVHZ7fGC+K5aH68Bnag+y2r53CpoSPX0oehE0GWDAV0Hr7CbisPO802RlAQHOXOv9hTyasYX7CDD/wOcqnnoX9LUsHdjUltPv7+wxeLgJtJ4EikzQNt0SVGeO1uZW1KOeocbKWesVI9kc07HgB/V9iKYAhNFleYz7zBEwqg0owrJp2w+B/qtcAldVXakkY2KZ9+2qw7QeHrzx8yo0sbJmOZrZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YvpPJ2du6id/Z46SUmEKMmDF9xgQmdTUxyri1aRxPQ0=;
 b=ky283DZnJfZ8fX5nI4QV4E3bj4+5XLsEuiiokpvP5nu8fVdEqAoukibWefoco6rJiyuHk6FCmaS+qIBWif6kjSP1q1fJIMI4Za90lcpOiA7l5rY3gxLsHp3tnFiAEM3xrTV8+v8xPbNdUPutPo1OpeFjWwfeX6kAsnNQoazKmikcOUf3N2gT5T/8nJr+z7T0FDG9tgWT7+5slbTcY3+8pPLbOrJb6YSmuIgS4lfNER3tyZ+jPF/lhcL3FWIey2rt89pX48ez/NwjGQ3Yx7AjDvmnEsxyh7Uw8Lg4w184fDDL+vSeDzrXgtt1mergCl7PyUKXslg6sGzjP+ESOcMtaQ==
Received: from SA1P222CA0134.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:3c2::7)
 by DS0PR12MB7512.namprd12.prod.outlook.com (2603:10b6:8:13a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.23; Wed, 17 Sep
 2025 20:08:37 +0000
Received: from SN1PEPF000397B5.namprd05.prod.outlook.com
 (2603:10b6:806:3c2:cafe::91) by SA1P222CA0134.outlook.office365.com
 (2603:10b6:806:3c2::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.14 via Frontend Transport; Wed,
 17 Sep 2025 20:08:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SN1PEPF000397B5.mail.protection.outlook.com (10.167.248.59) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.12 via Frontend Transport; Wed, 17 Sep 2025 20:08:37 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 17 Sep
 2025 13:08:15 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 17 Sep
 2025 13:08:14 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 17 Sep 2025 13:08:14 -0700
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
	<rwarsow@gmx.de>, <conor@kernel.org>, <hargar@microsoft.com>,
	<broonie@kernel.org>, <achill@achill.org>, <linux-tegra@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH 6.6 000/101] 6.6.107-rc1 review
In-Reply-To: <20250917123336.863698492@linuxfoundation.org>
References: <20250917123336.863698492@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <a67264bd-e207-4cef-a3ad-edf15390365c@rnnvmail205.nvidia.com>
Date: Wed, 17 Sep 2025 13:08:14 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000397B5:EE_|DS0PR12MB7512:EE_
X-MS-Office365-Filtering-Correlation-Id: 8982ae90-d815-4c1f-0997-08ddf625fcdd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|7416014|376014|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?b3ErdjJGN0xFRHg2ZTRxRHhKekdzQS8rSWtTK1dkdWNHQjRBaEV4QmdZbFNW?=
 =?utf-8?B?ZzJWNHYwR1N5eWlGZENRMjFrRHR2Y2dEZXpNVDFsSC9wbHFreGQza1B4ZDVC?=
 =?utf-8?B?aEYzWWxDT0ZBaVJKbUhtQk5Gc0dQK2pRQ29HQngwMTdvWWRnTFY1b1AyaE9z?=
 =?utf-8?B?WStRbmR1NWlmcFpzOVhUaDdSa0piQWo5NEZ6Z2ZUMEhzSnNqSzRrSm83ZEI3?=
 =?utf-8?B?ZFpJMnM1cDVyci9DZUxCc1c5aTFGdXBNN2xCNXQwZ0FzV3ZKUkJrNjRlSWVF?=
 =?utf-8?B?d2JVVWN6VTNYOUxwYjdJTWVtNFRiRzNZbFRVMk9UR3J2dG91OU1CckFPeDBM?=
 =?utf-8?B?MGNnSSs0Qmg2eWkrb2d0T1Y0K1hOdlRGcWlXQmhTSmx6cG9kakFVTXNjcysy?=
 =?utf-8?B?Uk5iMEFieDNvejNOSkNCNG9wemg5bjZBZWRtcFhkcGN5SlRSOTkyTnhYdlQv?=
 =?utf-8?B?Y1ZVQWVKYTdITk92dThFais5d1pxaFZrRlA3czIyUEErN1gwdDR5V3BzMnd3?=
 =?utf-8?B?eWlZZm1INTZBVDhyQmNjQnY3NDVaeFBTZzc2RVdqMll4YjVNNmU3b0VaWldl?=
 =?utf-8?B?RnJUSVlabHVGd2dxRTVKRmFlckd1cDZiNmZ5YlozeUxjaWNrL25FUENpWmZH?=
 =?utf-8?B?ektmVWN3L1VmRWU3UDVxc2xxTWI1TkQ0ZDBtMnJLMzhxd0FMdFVEZUpTeUhL?=
 =?utf-8?B?MkRjTzFzKzRxUWR2UkhEMXk1Tkh3emYySlBMRXBqZytjUXhxekpROUF0eEFj?=
 =?utf-8?B?RElmc0FPZko0RHJONWU0M3JkOHd3MWszeVUwTDRYWlh4WTVqTjhnMnlEeFBt?=
 =?utf-8?B?ZEVtUGtKWFlSYVlzOHVEenpEN2lxWWFtbU9HVHA1VUdvRzBJYzVIR0ZmdndQ?=
 =?utf-8?B?YURGME0vc041cGRmcnhIdTJHY2orYWRwTGRNdENmOEQvQ1hxb2dleERNUTh0?=
 =?utf-8?B?NlJoS0pBWVUrRm5MTmRFWXhDVzMzb3EvazF6R3N4NFlDazNSTUU2eTJWNGVZ?=
 =?utf-8?B?cng0aGtWQjgxVmFxdzZ1Q0ZjOGFJdWw5b0hiY3FoZVpNNTE3MnVwY2JDTXJa?=
 =?utf-8?B?WHVOSkF3QnNlajNWWnl3RkxkMEZoajlZTlRYL1I1TkowRWFrdkRSMTJ3OHlB?=
 =?utf-8?B?TkNiUWJsdkJzMlhiVjIvUy9vYkRLOHFHWjRsMUdndE1vTlV6UVdaT1VKK1FM?=
 =?utf-8?B?T0djb0k2MDc3TnJRRTh5dkErSy9pbXRlVW5XRVdFcnhPd3BHdEVNSmwycS92?=
 =?utf-8?B?ZGY1UkJVTzd2c2sycjBSakkwcFJrdlBod29LSWpTY3ZhU3hGTnNrZEZ1cmhv?=
 =?utf-8?B?ZStvV2lsU2R2MUNQdVpKS0VKajVjT1JDeG80VDNlRzRvcHNJdytaY05DZjRG?=
 =?utf-8?B?dFEwZk9rNXJyeGF0VU5rUVBnTjN0cVBab2dISFVJSk9tUWNiZDFTQlpaSFh6?=
 =?utf-8?B?cHdYZU5qc1JuVElWb2dEeXhYdHdqd01Ra0JaQkxyODkrZEI5TnpvallLYkJk?=
 =?utf-8?B?VDRWQXVmNVphdXdaZXVUL3hzakRHU0piazU0eklqT0NORW1vdXJXUUozTXdI?=
 =?utf-8?B?NmE1QmMzRDhNcDF4Yjc2T29wV3Q5UkVSWUtiKzVBa0hMRHNNMm1NcFpPZUs4?=
 =?utf-8?B?SXNGWXUwa0w5OFJmdy80ZDNRcXlEQ1pQTkhUMERoQy9Jbk1jL1A3WG9iVFh4?=
 =?utf-8?B?ak5tQ0gvcWJHUUYyc1dCSzA2eUpMT2VsalNsR205aE5JNDhROU45RHdVS25F?=
 =?utf-8?B?VERxWkdQVHZLeG02Uldac2FPZ21uUndKNkNUdmxFZytTZkMxSWlJSGVTam5R?=
 =?utf-8?B?Qm5pNm5wWU5qQStnSWgvTnQ2QXdHQ2ZNSW5mT2I5SHRHQSthVWNnazM1ZWt4?=
 =?utf-8?B?bEViM1h0ZWZ6aFQzbVhkTXRicUI2QzkwZkFYNHV0ZEVSa0F6V1FhZWxsR1FB?=
 =?utf-8?B?Z2R3U2s1MnVwSDV6YkV0THBRMDcxYW9VVXVDM2NjdTd2ZUNVdjJjWmZQTlls?=
 =?utf-8?B?NGo4ZUpwbkJ2S2s0MEZ4cDdvdHgrS3htM3VqLzVxTXBXL0hSQS9XYUVqV0dz?=
 =?utf-8?B?SGk0dTc2Uko0alZhOGZBbkRzYXA5WWFLa1Yrdz09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(7416014)(376014)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2025 20:08:37.1482
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8982ae90-d815-4c1f-0997-08ddf625fcdd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000397B5.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7512

On Wed, 17 Sep 2025 14:33:43 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.107 release.
> There are 101 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 19 Sep 2025 12:32:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.107-rc1.gz
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

Linux version:	6.6.107-rc1-g08094cf55442
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
