Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2053.outbound.protection.outlook.com [40.107.244.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D855B71750
	for <patches@lists.linux.dev>; Wed, 24 Jul 2024 07:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721806586; cv=fail; b=d/mvSKYJBc1otkqwtNoIQwjyGwGRhHDxqPSNSXDuvflRkci7Lyq3m2sm5U07Mt5TQbvff6EozzmCE6omVc/MT+IlL3Wd6tE41sya3Bc6aBXLsihFA2Q/FbnJW/dLjpZA3His9HxOhNb4roSXlu8CsFoN6dN3yRsEVNwSKukQakY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721806586; c=relaxed/simple;
	bh=lsvV+XBgNWu9nd9S/MID1gyszxki2gD0bHRFXYcOllk=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=pEbNkKMETOxy11KDIC7/u5VqdSkbvp8CHF+fj4dJymFMJ+NPgqYGP1oka4Zamomdt9aHcXN1vpp/WwHWlchumTObs9XhuqveR26ZX8yoWsfJiIRHivbLaXuyFFN/Z/2ikXUgTzS6d2wg/f2Jth3wiBgENXftmJ4EsJi6/V4p9zs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=pDkzHCeu; arc=fail smtp.client-ip=40.107.244.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="pDkzHCeu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Au5PePMpJCPjVUU/eoDDLl1XKkfxxObULtrw7FhC+p4zsjJwqg8BDQ6wUBPpzbmkv6xKLh8z0uQSNfqrKfJs5XouD0xfyrE97Fp+cwZpN8SBFq8BCrVyxgvnSNLY/4f6KzUB+SPp4xwKwOMU0Q4Qpzk7gKNnhGU74n3FU2lplPtkOXPfxkGcJ+Tq7DqYqiEm51TGSXtcV3JsS/R+aD2YRbA0IzpxeLfmPY5xK8eSWylYGYznr2DAliwpjVkLBdeMvkVcft4fhdPPF0oxwF9WrY1PwIWxY1z2MFobmczNGZlUq2JmYim89klXsnNrpbLLtRp4OdUfwuchEyN5pgB08Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P4V8Fdvge/kRWL9bnCJdBeZdbzCJemJ8RPEwdQZ5TX4=;
 b=R0Cy7i845QAVXu8VVgXspIXR+QwOxl2A6rCbff/MSpP3h9321A4vcpvAFjRQIRZ0aGKzhdxOV1PdmzO9KZBMFmkbjUqfKk57A88SnB3GfrK4iaDcFpeemwaHRei9IpBnWbhDu3j4LFy8do7E6GtO5I/M45eRWCAiXe+/kABl7GUT0O4YZ2TXYvqoq6ceWkFg82Nsg3s17jDDsp+3T1RzTdRBzM5gT7hPlRHITUHuMdUDWlGcTnVwAGuF10ZCt05oanE9rIJyH7EI2WmD+Xz+XmHbqn39k0z9YVggVVM8pVxWQ5ceBrt/ZlAsjvvh1HTlEo22DujNWOIg+IgSLuRhGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P4V8Fdvge/kRWL9bnCJdBeZdbzCJemJ8RPEwdQZ5TX4=;
 b=pDkzHCeubbCrZzRO0iWE6875kCwsjqS1nyWgHrw7jKquAfAH5ySRj9w1Ht3VIu+xLQFc3uQnOXApvOeJtTDtz70wIGoHtQRFSJspAYUbDjlw7uZJkdIhU1WggulAykP/hMy+x+niXf1MLw0gPk8I/LKoJRCrASunS77A73k1Cpo8U25jhnWYIYEyTuaW2k/1B3BkIPKuLeCDiEkxELlsV7avaRbJegr8e/AELvlTuMzq5ztsSF2EJkdxgBTaSLEO7Z+0q/llaTt3HfrL8LQB53686VgIbKQfDRZ0qPf1I+01z2VTUEeJftueOn3JWV7saeJr4ZvUqbXQH9nrsWcFNg==
Received: from CYXPR03CA0058.namprd03.prod.outlook.com (2603:10b6:930:d1::16)
 by CH3PR12MB9456.namprd12.prod.outlook.com (2603:10b6:610:1c2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.19; Wed, 24 Jul
 2024 07:36:21 +0000
Received: from CY4PEPF0000EE36.namprd05.prod.outlook.com
 (2603:10b6:930:d1:cafe::f4) by CYXPR03CA0058.outlook.office365.com
 (2603:10b6:930:d1::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.20 via Frontend
 Transport; Wed, 24 Jul 2024 07:36:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY4PEPF0000EE36.mail.protection.outlook.com (10.167.242.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7784.11 via Frontend Transport; Wed, 24 Jul 2024 07:36:21 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 24 Jul
 2024 00:36:05 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 24 Jul
 2024 00:36:05 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Wed, 24 Jul 2024 00:36:04 -0700
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
Subject: Re: [PATCH 6.10 00/11] 6.10.1-rc2 review
In-Reply-To: <20240723122838.406690588@linuxfoundation.org>
References: <20240723122838.406690588@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <a868725b-6a80-4764-9289-e70e7ffa8f35@rnnvmail203.nvidia.com>
Date: Wed, 24 Jul 2024 00:36:04 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE36:EE_|CH3PR12MB9456:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ef6edff-ba3b-4d6b-6a43-08dcabb35039
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Mll3MjB3NjJ4R0FYZEN3TmczYVAwU1JzUm1HdCt4aE02MFpTR0hiYURSMnBZ?=
 =?utf-8?B?aVVmUTBGMVlzZHlwLzhDZ2pVUTFmZFIyYjlJRXo5NHB4TFg2SHFRbGxJQUZh?=
 =?utf-8?B?WWxXMTNZWi9SL1QxNy94TjluU01SbC83WmtSZzJmRkFuZGNLMy9Ed1N1Uk1z?=
 =?utf-8?B?MkFEVkVNbUJTWGZ4c3N6RHRTb3QxK0ZBSDg0S0M5WHJQT0Z1QlF2b3BuYkZL?=
 =?utf-8?B?ZWZoK293Tjd0dGV3eWQ4V1dFQXNvcklUNVhpZElXRTR1bTBUUmVDb0l1Tjhk?=
 =?utf-8?B?Y3R2ZTNXd2Jrek1lUVI3RVdVcFhNWGJsbnBYbWFWUE1lMDZQelI1QTBhUXJV?=
 =?utf-8?B?eGxiUUlaY2k0RURWcmRuVm8xeE9ENmg0ZzN2b0RZZUtmY3BTZWIralBaWFNo?=
 =?utf-8?B?KzFLbHRhVHNxSVhTRWY0NEFHbWh5cHZ1MUZSOURKRnVxM0F3elNsSWxrMnI1?=
 =?utf-8?B?VllwN2NiZ3NWTmRibUErSS9qNkxnNWxnVkVOU3dlaDlwdk9UUlRZYll4NjFr?=
 =?utf-8?B?Mm1LcVNsMHpiS0FtV0lWdEk2UGFqNmFLSXBCUWs2NmVscklTMWNIbEJabzZE?=
 =?utf-8?B?TGZaOGZPVE9RaHdtYm53UXJqZEdvWFVVQXYwVmNzK0ZZREJMc0RvZnU1eEZF?=
 =?utf-8?B?OGI3ZFZXL1MzSElkSi9OZFptSEhXSWtaMTFmcVVPWmgvK3MxcWQzTjkxVHBP?=
 =?utf-8?B?Q3hSYmt6ZkdTZVl1Nml0ZVFoeSt2Qm91VmxKS2VGZ2ZOdlh1NWtJY01UVUth?=
 =?utf-8?B?SXBObXZhck5QYWVBT1lKVHB0Um5xaWVGNVYxWTVtNDRzTGg2ajZGZFdsekhU?=
 =?utf-8?B?V1pEeGxDWHlRYUdEUUpRdnJXd25rVm9aNGgwM0RjNEFvMkI4NDZFMWpwMm5w?=
 =?utf-8?B?MWFXMmVIdkNBU290OVlxZ1MzUy9CcXl2OHJCSExPWjVoUS83Tzhtc3AvRWVl?=
 =?utf-8?B?VC9wejFzOENHbHlwbGdiTEFQSkhvUmVQWHBEQm9JSFhuUXNoTjQxOFgybncv?=
 =?utf-8?B?d25BZEpzOXVqR2tLd3BFbmZXNDBpN3pkdkFvSHhMdTM1MzdoaURMQmF3OG92?=
 =?utf-8?B?Y3NnS2dNdDh1QVFseUtpMEQ0UU1xdEpYM3d0VS9oMjdzcXppMlBXUjljU0U4?=
 =?utf-8?B?V0tXaUpnY3ZRZk5uNDd0dWx5Tm9vL2FHeVFPQ0pILy83dlQ4a21EYVdvUklR?=
 =?utf-8?B?NEFmckZybk02dkgrdGlZc2VENWN0Q1hvSFdmb2lxdkFoYUd5NnVPTHlPN2dJ?=
 =?utf-8?B?eVNiNm4wRTdMaUYzdlErd2FYbm9PdVhZZkF4by9xdmhwcTk0NU1MRERDUXdD?=
 =?utf-8?B?R2c1c1lvTktkOW4wc0t2VVNhc2NHb2VPVEcvNmhTWFd0OWZaZmxWOG1SYUdy?=
 =?utf-8?B?NUdYR0xaV3ZkV3FYS0FwUzdBVit0Wnh3N1oxVkpuNllzTHIrRkdKZnFzdjNl?=
 =?utf-8?B?Qml5QUUyZkFvak4wRE84UXJPNmtJc0FtT1ltSlRKTDN1enVkMHBvWEkrQnJ5?=
 =?utf-8?B?d1hDNEdJSkd4eUExRmNEc29UMTRKQVYzSlUzckZ1OEVFTlRmNnJURHA5QjhD?=
 =?utf-8?B?RndwMlY1UGExMFJZbzhZTmRFK09TZFFlK3VQWEJLTHozZlNSbmR1aS9KT1Bm?=
 =?utf-8?B?MEtYL2lpbVRmRGp3SVI5Z2k0SVZjMi9HT3ZaMGF3WDlzZzJSK1QyeTlBYUVH?=
 =?utf-8?B?dGF6UlBiNE5TQkx4T0F2UVlNMFlDWWl6SUpaTVhJYlhqSTM4SWFTY0ExNzZK?=
 =?utf-8?B?VkdhdXRHZ1pMKzBoK2hzUVNXeG51VFJBSnJ5Y2hMdzQybTdGRVdOS1B4ZEpv?=
 =?utf-8?B?ejRrSUU0bGNjTW1tNi9JMlhCb2JJdXdRZTZ6TU51S0JkTHhtenJkYzI2TWxx?=
 =?utf-8?B?MWVCQXE1NlM0VnFpTjVXNlJBOFNCRDlpTUdkMUVSa1FtdFdxSlE1RWdFNDVU?=
 =?utf-8?Q?Cs8GmHfeYZjQf0CDBhXG3uiOkphH67/y?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2024 07:36:21.2109
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ef6edff-ba3b-4d6b-6a43-08dcabb35039
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE36.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9456

On Tue, 23 Jul 2024 14:28:51 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.10.1 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 25 Jul 2024 12:28:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.1-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.10:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.10.1-rc2-ge89ad42bf499
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
