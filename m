Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010020.outbound.protection.outlook.com [52.101.61.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 455552F1FFA
	for <patches@lists.linux.dev>; Fri, 31 Oct 2025 19:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761939313; cv=fail; b=L4gwF1lVapsiOGdNmlZdKyRr9wJsUg5NSDr353Dm3Zl4FQkYCH2uXGuNylNJEqmXhoLpylAKnxywXSaOamOiSq5qBwedU1rmR5jRYxozaCUkglTwRzkUTDmR1ZZxhJ4BJ/po3VZpez7RcX59Ikm1AZfauOw6eVHwvSMsHEOR9TU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761939313; c=relaxed/simple;
	bh=MBx3JsuflW2AeT/mcnkFIm0BF6J7cb8hXX//az9t4Vk=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=EFJ5HB6sEx1ATT8pATdteqCmnkVkjRmp2rMKts6SZ7+aIrhiDCOwf+wIRlOLWlU+tIjKba55aCoJ4/06J5PglM3EKSHnn8RtkqAWFbH/2hpqQbQlBEWo3AO6PYyv+cSGfoewFYV+GLDle74Ebp9WuMAglG5h2/4K5JnAUBbF8II=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=D17PIVvw; arc=fail smtp.client-ip=52.101.61.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="D17PIVvw"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JVzquZZnYQ+U0PaAZN8tHDglvH1DnyeRC79f5kU4W9+dcWw58KgWJ/NnanBRlg/hZC9NMIn29qJWeJBJrqoSbivagSPrhqx09ZQc++W8pICqCm9f13DRhXoM2yRv1cWmuGaFyLOFmmId5v1z0Eb/oS0iVISe3W9051wWne0tLR5M05GfE13DfjMUuG7IiQiWNji2wp1VqVExYKriLOCURnyxGdscsJ2aFHZcmOjzgSV/32DI4lHUy6XHfU5ZQK2ngslm5HArJNN+iPHa0R1gYnbAYEJDVhUgw42sp4iAdcuLu2tr63TWk3vlTQ4OFA0xoAruvQfwZTjlUcjqBxic/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hT0CX2w6ANqj4jXwQuBtzr4i3O2GOkPZvXu9UEhqwyA=;
 b=wtIEfQk8ed4l/Jh/XgRqDO3EotV8rte/ujUSnO3wuDEAov1QqTqUwqnapTYS5xRAMECRAA51zIfHGS+d8DD4wnDPJQkVbS7Ew0YDgBGLPegD5VEynkz7fdRRfSnia6F9uuu+aTEqmqcr1S5BpCv1W8Be0yCC8F3jErv6mw3s5dxmgqpXDVajrD8uxNABMcl1gaG3SeFVuHi2+2BaAdBOJgJWnYtLmsdjdRuWrP6cjCVtaywxM1/63ZoET8NV800w+ihJQEYqTE5xNgwPlPNZ00iqeWe0adPYskl3y3ZHuASH2rEhvoxcSbk018n/zm7+2VCMPS/DbxjAHbO8Q/lF/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hT0CX2w6ANqj4jXwQuBtzr4i3O2GOkPZvXu9UEhqwyA=;
 b=D17PIVvwst7PDzuGQIftrT4eacjwY5msFnOz/xF6MnHdjftOJlPZ7onlV5UrOFXQ5WS/C/e8bAPEnWuwDnlAJOOs8AsWnalKCtg+C0KUhOsHl/+OjpTBp2tpWAg7CNbZd3fxb+aVoj8JjBJvjuq6fJGmDh8et20Fol55mb66vWQrQ2+UkHPNtX/+RTpCoPr1YcWpE4FdWi/WwQYHjMiJm4HxCYcPL4R2zetYbnbEro/H8Gf8oEfI2acIIyA+PFjl9Y/hQ4tMmS/qnrlkHV4aunolF4Na8q7NqU45qhg8u/1RtumIzoprrPLa+IegBwj/jooCU2+YTDNLSrFf1Uh9cw==
Received: from BN9PR03CA0762.namprd03.prod.outlook.com (2603:10b6:408:13a::17)
 by LV8PR12MB9642.namprd12.prod.outlook.com (2603:10b6:408:295::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.17; Fri, 31 Oct
 2025 19:35:09 +0000
Received: from BN1PEPF00004687.namprd05.prod.outlook.com
 (2603:10b6:408:13a:cafe::b1) by BN9PR03CA0762.outlook.office365.com
 (2603:10b6:408:13a::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9275.15 via Frontend Transport; Fri,
 31 Oct 2025 19:35:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN1PEPF00004687.mail.protection.outlook.com (10.167.243.132) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9275.10 via Frontend Transport; Fri, 31 Oct 2025 19:35:08 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Fri, 31 Oct
 2025 12:34:52 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 31 Oct
 2025 12:34:52 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Fri, 31 Oct 2025 12:34:51 -0700
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
Subject: Re: [PATCH 6.6 00/32] 6.6.116-rc1 review
In-Reply-To: <20251031140042.387255981@linuxfoundation.org>
References: <20251031140042.387255981@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <97e0c06f-8728-4ca7-8b79-92d67f3370bc@rnnvmail201.nvidia.com>
Date: Fri, 31 Oct 2025 12:34:51 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00004687:EE_|LV8PR12MB9642:EE_
X-MS-Office365-Filtering-Correlation-Id: 2eeaa22e-1a50-490a-54b1-08de18b499ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?STBsQ21pWDE2MWF2Z28vM3F1S2ZHUTAvUUwwQkJRanFKREw0R2JqZVh0Vkw0?=
 =?utf-8?B?a1htRHJIeTVwWWxaV2ZtOG9VU1lQNDNQbWpCQUxQcTl5S09SSEVmY2tKUE9Y?=
 =?utf-8?B?NU9tQzlQTDJZWWNBVlBPTEVRS2M5cnVrMm5tZk5QWXRmSjBVZFg0bVJSKzUr?=
 =?utf-8?B?MlQ1dmcvU0phTHFoYStoa0RxdzlDd2lVN3o0MTRDMm5wODg2WGlaZWMrWjFm?=
 =?utf-8?B?R2FtUnJJSkpJZnR2U2FwWXBXY2lTekVOR1NuMW5Ec3h3ZDZ4S0Q1WU1MNmhL?=
 =?utf-8?B?V1JpQTZKQjZPbkdlV1d0UGhXYndISC9lU3JIUENFNEZEY0hFcXUzTUFQY1ds?=
 =?utf-8?B?SVE3MW5OeGZod3g1MGFmT2R3NzNvWmx1bHZHVzNHMkpOMFJ5VXJlOXFLTEU3?=
 =?utf-8?B?V3IreXdmVDU2K3Q4Qm9jU2RyR3FESjdFMHZYa3JOQ200cm51L2hLdlVUMGRz?=
 =?utf-8?B?c3A3RHhMQTJpai9aMitPYlNOMnI3Y2hqclJxVzlwYklDR20zOHAraEtZNTRV?=
 =?utf-8?B?eUJ3STRFaGZWeG83YTNsUXJsVnlFa3lnNzY2alhsTlFNTklhelJlYklCRWsx?=
 =?utf-8?B?TTB4UlB3cXArNUpBalA0UmdBSDhRbU1NV1pMejNtV2s1UStyOGVyY1VDUVM0?=
 =?utf-8?B?MWttSzFtTTRBMEVXRmhWZTFIamthcUpNcWVsaGR3V2RCcWpZT0hIcXFSVldR?=
 =?utf-8?B?eEJFbThtR2xjaEhjalZOWXVWcnNOT294bTNBMXYyb1JKeXNwdTVNaFpONjZ6?=
 =?utf-8?B?bzdlMVFHbFF3dE5DeFNIdnJFdmQzRWF3Z1VRUnN0RWFTaGVhdWFrd2VpcDN5?=
 =?utf-8?B?bHp3TkNIeVk3ZUN3dXJua2NZREJwWEVmQVlYRjdSL1cxcngrYUxSampINXkw?=
 =?utf-8?B?eTF5MmF1RithTEFFN2p4dHp2RzZ4RStkbW96SXRzdGk2bFJvTUNuZlByU3VS?=
 =?utf-8?B?YStnaG5QTEdKc0JhZVlUS0dwaHN2QlNJa2Y1aTIzZDlBN3Nlb0JuSUt5QXk0?=
 =?utf-8?B?cmhuODQ5a1lFWEZCK20zWm9tZDh2NG0yVWt6d2xQUWRad1ljamt6K0wvUVRY?=
 =?utf-8?B?NHpXMHFDUnpHeEIzVzZCc0l5ckxUZWZYZ2VOUm1VQk8rc3ZSM3FNeWNUdFJK?=
 =?utf-8?B?WHhwZ2tLOTY5UzYvR1QvOUU5cWN0K2xzTjBleFJxdExKemFoOEYzM0lRVEIx?=
 =?utf-8?B?dFNoazY3aExPVmlST0NwbzJUMStZQ1VIMDNnVU51ejE2RS9IQi90Y3ZZSWRB?=
 =?utf-8?B?aUUzc01JVHVNR1drU2tEYWRuZ0ovRU5OcldBeWxucVBFcWFSSytqSDVsWlBa?=
 =?utf-8?B?cWd1VmpDM0pvNFA5R2gzWEVpcVdtVWM4ZGtuNG1CNm9BRmp3TXBScENlR3pE?=
 =?utf-8?B?UDNhS20rcmdxaU93SXYrU2tvYmNTYjNHU3VkcjFsMVE1K2JKZmtHbW16U1dD?=
 =?utf-8?B?SFJ3eExqZzFjNzZ3SFM2b2hNcnltOEw4K2wzeVg5OW9sUVVTL0Q3ZjR2bUUy?=
 =?utf-8?B?L052NHpIM2R3MXc3S0FJeXNXRjZQdUpkdVAvUm5ZRTNBV0c5N29Rdm5NaXBO?=
 =?utf-8?B?dllLYjVKMGswNTk5bUVocXZ2UENZL0V6YTNndjQxK29iZ2x2SnNTcDdrV2dp?=
 =?utf-8?B?RTdTYWZyOWFPUWdoM0g2Wi9Bd3c5UU1JcXhyZVpVR1Y1WjdiWWdpOXRaYkVa?=
 =?utf-8?B?OEVXdlliK29hakRjVER3NnlzaEw5cHdFSjdwSkNzRjNTTldFUmVncmw3SDNk?=
 =?utf-8?B?bHhLbHdGS0dnaGVNOG5Qd0tmZVBHakRQcno0dXpzeVRGR2F0dVljcWEwV01h?=
 =?utf-8?B?c1dFUHFxaU5rZWpmVlF0b0pJalo4WlFLTXUrTFVPWm96ZjFUejFyTzJlNEt4?=
 =?utf-8?B?T3RZKzFXMGVNdmQ2OGZPblZKWVY4aWlyd2ZQTDN4RFBUa2MxZXg2Y1ZKTVAy?=
 =?utf-8?B?ajlQb0RVbWI0cEdiTXU2eUZ3aHEzTjJiNE9GQnBuV3FIWHowcSszYXBFK040?=
 =?utf-8?B?bDk0ZEZmRWxhSFI5UXRabzc1NTF3V0hwcnNSZ2NFVURLczZNYjd4VkFXWmVX?=
 =?utf-8?B?MzgxVU1rU0EyR0hCaXFKVEYyS2czdVcvSmx5dlNVMmtKK3EyUThQV01IclhU?=
 =?utf-8?Q?YUZ8=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2025 19:35:08.6999
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2eeaa22e-1a50-490a-54b1-08de18b499ec
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004687.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9642

On Fri, 31 Oct 2025 15:00:54 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.116 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 02 Nov 2025 14:00:34 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.116-rc1.gz
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

Linux version:	6.6.116-rc1-g2c2875b5e101
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
