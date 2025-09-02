Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2053.outbound.protection.outlook.com [40.107.94.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8790346A05
	for <patches@lists.linux.dev>; Tue,  2 Sep 2025 18:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756836237; cv=fail; b=dthBrR6koTqv46z6uA3LHH4SGIEOpCbeY9f1c+eH/PUPcERAZsO7fgFYSNHIkqcm08MChCBUL5RH3AHBgOhNoqhizU8uHfIYinMZKp83Qu1TbvsKJ+ML8M+XZHHXGA0Hs+WrtgKmgcGutje+PVfb7I/ecf0i5Z2RxK5YZaS0F/4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756836237; c=relaxed/simple;
	bh=YYBpd3ZE057PIEMTGZ/R2omeFjf3J3VBgqp6N+Ya9GE=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=hyErWnVLLCyt03znbgF2yNC7qPRF4A8uplvU/2K5JCsV6WdtX366zzw2I4PVjrz8BuCYABHLAruNvsV2KbLF+ptfkbdscL4TxfSZojFTLgYDx11/NKIqnCiQpotZHHHNB74l1vWjVNhB6X1071oHXcU74Pfbgm8+mWAOAtU8HhI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=VNHGtVEy; arc=fail smtp.client-ip=40.107.94.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="VNHGtVEy"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tyDR/Y/WgpeksKCDrfXtPwkPJCXklluypvSo8JqwQ92D1EX7ndmIqjCkq8a25CDMrrXEzdC52kEmjy0BOPKexfOL8PDHVI4uKq6rDqySpUW/JFd/o+TmMVhcT7OstSLJ4lFpvDwwGPJr6M5iYUPw45mAoZnGwzPPIdnZ2XXmebdrXT78NqMqwwCNPlXDdDqhtXIBuWp9v5y2/nq037sOSQD9B2qbXtJzOEx10RkFxXqbNhObhwXHDULjXL2q/YvQzksedAZfLZGs9oACcjcOmB7yrvRyOjvdNzhntxfE4qrUr2ji7StBOWzDx0XU2xH5lvlZO0AwDBoh70rz3ickxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k8oxBkRCtr5XFvq9gxd/OArI7TgLkckHzZVMUI7glZw=;
 b=P0/Z+rIYPlIWIbYVXLFMvhfNMb/QSITOsSADDt47fx8VngumjykHU4T14KcjvJr2WQxAeQ9XCvLV0Q2MpumT24RU7LZyvtzss1eWZbOVwIhTBgAcNDLHW8uN7bxn5DaZyv9qPE6BpDvyhDB3bjLRBSoXOtXl+4bncLokZJOLRV1upiVUToVOgJcA7xMpjt5OT6JXMSmcblr58ji+tSJpikyMia+wYjSr8sL1ZdN4HjDJ6HVMPlD2inq7F7Fh0ucYmzbetmjrnSHPjwn9K5CR9/ssmsADm8NdD0m/0xabFjfiyZFcKSXzuSuNIpDRUjWay896DqGhaj2iQCA2SGECKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k8oxBkRCtr5XFvq9gxd/OArI7TgLkckHzZVMUI7glZw=;
 b=VNHGtVEy7rE3QccVmotrekdrt3+tQoDhkZHQtxtMpz32NqJC15piAbLruwhmexp+xblSyApqj+S1KGBIJpOZfwDDHgP0o6kBjDcSVk58TsF3ZSPVEQimijIr3dwTrV3Xn1TlThW3Z/nvu1eaJW0/b/TDcGs1wxW/jFBzxeyZXe73VgbG41+xh05BHXU9lh2Ss8WCiQ5d1qNvcmha/5vRjrS5CzN2fElVk6xSCHbTNVwwtREUIsZyxpYK4zUYZLxIOMrrQF3tKh7ao8bz+ocO0Hd287nwfmfH8Pw8e8jEpPqzM1cIDYmGzjLnN7Atr+JYVODmMLNIB2rJxHs9WzFHxw==
Received: from BN8PR16CA0033.namprd16.prod.outlook.com (2603:10b6:408:4c::46)
 by IA1PR12MB6065.namprd12.prod.outlook.com (2603:10b6:208:3ef::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Tue, 2 Sep
 2025 18:03:52 +0000
Received: from BN2PEPF000044A6.namprd04.prod.outlook.com
 (2603:10b6:408:4c:cafe::4e) by BN8PR16CA0033.outlook.office365.com
 (2603:10b6:408:4c::46) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.27 via Frontend Transport; Tue,
 2 Sep 2025 18:03:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN2PEPF000044A6.mail.protection.outlook.com (10.167.243.100) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9073.11 via Frontend Transport; Tue, 2 Sep 2025 18:03:51 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Tue, 2 Sep
 2025 11:03:24 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 2 Sep 2025 11:03:23 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Tue, 2 Sep 2025 11:03:23 -0700
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
Subject: Re: [PATCH 5.15 00/33] 5.15.191-rc1 review
In-Reply-To: <20250902131927.045875971@linuxfoundation.org>
References: <20250902131927.045875971@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <43682f4f-651a-4df2-9167-a5292e39c093@drhqmail203.nvidia.com>
Date: Tue, 2 Sep 2025 11:03:23 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A6:EE_|IA1PR12MB6065:EE_
X-MS-Office365-Filtering-Correlation-Id: 45339e7f-0382-4c12-88fa-08ddea4b131b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Q2tpeDY0dGt3SzNZWkxRdUt6UHFUWkViOEFjTHZTU3JuKytrUCtaNldHK1ZD?=
 =?utf-8?B?eFlQL0FDanJnVXppTWE2YlZ1OUtjZ0xuM2ZURDlrcitpMUJNUCs5OHBCZWJj?=
 =?utf-8?B?RHBLZ24xT2NwTGZWMEtTYk0vNGd6aWNrbXRoa1NrZ3gxSDU4RVFKY0Q4OU10?=
 =?utf-8?B?enc0akJGRXg5Y2ZYUnlwQURNNHpqc2RESlRxMFhHN1YxS1ZjTzQvMzV3Vmd3?=
 =?utf-8?B?Umd4MnBzOWs0T3BQR0UvakFhWUg4K003bVZVTk8vUTlKQUpUQjVQNXp3NXYw?=
 =?utf-8?B?ZXNncHVVSVhqNUExUGxKVkh0R3hNTFA3RG1jd2ZJZ2Z4WEZETXRFTnRtM0V3?=
 =?utf-8?B?bW82R3BSMlJnSVNockd6Umg0cWFDM3EzMkpqU3VuSnlXVmpZSGxYOHNmbFQy?=
 =?utf-8?B?U1ppT25GVlEzS2tuZUFzV1FhVzQ0L0I2OWJrcjJSVEIxVGNoSThmOFEvRE5Y?=
 =?utf-8?B?amkzVWdNZ25kT2xZbktQN0E4RHNIMlNUQmU3SUhIR1ozRWtkVThrNlB1NUlW?=
 =?utf-8?B?VmVyUlNsMlN3WU9ZVi91TFhYbHBmSHoxZFNJenFOQXJNVHpoR1dUQnNVT2o0?=
 =?utf-8?B?b1NJdTIvOXprelo2Y0JzMFlLWWVxTkVObWNzOEUxbUd2UTJnWkc4ajlVdFkz?=
 =?utf-8?B?dDJJeUZ4UEE2SENtMWxSaldsNUswVzhkVjFFaEI3cVVQUVhmYlExWWErTDRC?=
 =?utf-8?B?OEZoclNidXhSU3Z3QXJyN3NEQ2UzR1dsbkJiby9oUWtZdUJRWGd5OW9yQVJ1?=
 =?utf-8?B?RXdJczlYZnNIN3pkQ29yZDZ3ZlRUU0FNUVF5a2IyblpBbm0xaUFwSlh3dlFv?=
 =?utf-8?B?eEFHcWNhREFhc0srWS8ySXJwT3BpZWdYSVFUdUtLTUlaazR4UkVyMEFKcjNN?=
 =?utf-8?B?bE1HREZkbE5xVnhQMzRvczVIUy9ST1c5ZFhONzJySDZ3NmZLSnByZkluWjRw?=
 =?utf-8?B?NGNiR2FBeEV5eDgzMWhWd2N2MnJ6WU01UDVFeWw2TWQzNEoyVG9Bejk4TUh0?=
 =?utf-8?B?SzNXRldIN1d3WlRIU285OTJieUd1aXlTaWY4TkRLNXVSQWVVRjAvekhvSDVW?=
 =?utf-8?B?VzVmbGxNUUQ4SklyZkFvcUw0ZTFueFdyQlZRUmtqcTdDQWtHeUFsVnNrUlhv?=
 =?utf-8?B?NWlBc1lUbkpsOE40SFVHZHhvcUVsak9nOUhBc3dkZ3BndlFvdFRsZDI4d2kx?=
 =?utf-8?B?SVhVcXVFSC82TXJuNVZjYlE0Z1hIVlhQNmUrUFlMTUJ5QkFVR1lpaTNyZWZT?=
 =?utf-8?B?ejh3TXRwb3Z6WHVKT08yZUg3cGlrUVJvVG16d0VyY3drMFdlZ3pzem9ZWjdR?=
 =?utf-8?B?dG9sb2dMVEs3UFRjU29YYXAyVllZZVBrSFBPeWN2Z011TjBlRCtTSUt3bDBa?=
 =?utf-8?B?VnZjeFcrbmZPd25URjY1c2VyMWtOSEhjVjhUNDdkeXM1QnVic29rTmdZMEFq?=
 =?utf-8?B?U1JqUzIyVC9lN29qK2c3TUxUbEltejNQNDBLKzNjdWZUWVg4RXZBUWNFVXlj?=
 =?utf-8?B?V2JpVWJpMjA0YUlLd0g2Q0lIWVR1SzFWR2hlRGdnY3k2a2JxeFhuaHYzMC9v?=
 =?utf-8?B?OG1EdHFGcHBSMVRPSEppTDlJOU9jb2JxYnZkT3diYXRLWldFYk5yd0NnVndM?=
 =?utf-8?B?YW1ONUNEUzQ3R2VkTjFMM0d2STg5T1VMYUlzeXRIRnRuL0FUc1hrbHhZb3Z6?=
 =?utf-8?B?T0RqRkZ4MjBkRHdIRFRKSE50Um40bnR3WWRFeDUrK1NpNm9jM2FxeFg5VDhU?=
 =?utf-8?B?T0JDblF3Umgwczh6YkNaUC8rdC9oRHQrdHhxcWtxSXdDb0ZGbFloYWNRci90?=
 =?utf-8?B?Z3VidnovVGI2RmhSQitTQW8vZjhNNE5pM0g0emxHTkM5T1VNSWZzYkREZHZs?=
 =?utf-8?B?dmNCbUlvK0dVRjl2UWYvOXJhQ0pEWk9PMlhCcEx3Z1lQOU1rbVlidlpBMnpL?=
 =?utf-8?B?RE1zaSttbEJKdEtsOFhkbjNuemVsSm5zL211OE9LRVR0NEJXWDI0cXNsVGd0?=
 =?utf-8?B?QjhTSHV3OUE3aFB6c01yUktvNEROTHNzNFVhVzY0RzdINmJQekQ3R2JDRW16?=
 =?utf-8?B?UVIxTGIzNG5kR3ArU3dGNDV3bkpwNWlVa0tBUT09?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2025 18:03:51.8780
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 45339e7f-0382-4c12-88fa-08ddea4b131b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A6.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6065

On Tue, 02 Sep 2025 15:21:18 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.191 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Sep 2025 13:19:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.191-rc1.gz
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
    28 boots:	28 pass, 0 fail
    105 tests:	105 pass, 0 fail

Linux version:	5.15.191-rc1-g29918c0c5b35
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
