Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2048.outbound.protection.outlook.com [40.107.93.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83214209F3F
	for <patches@lists.linux.dev>; Thu,  6 Feb 2025 11:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738841892; cv=fail; b=GVVijWq2PPmzFbQZKvr0MSZmjBp9NECRny9GPqrg80uEToMdVSE0k8XdJ0fuA/AAXJGkVDiN7JP6pRdEDgZqVAanbbaiAoSAvJ2/67nIpBzlBeVMWr2dRSmTc5zooI8RDYoeUswrl0klpTeaJRlWjktsbaPL8rO7bOUBhDvn50s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738841892; c=relaxed/simple;
	bh=X+z7qFqA+i3306j0hVxxmEijWNq+7Qz+KpOcIndrfs8=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=Bs+zVapptU0UCcN5K3XfpeQVNFfmSSR0Oup2JsDR96yFfWCCtDwZB3JrKT7Jn06YvR4kAK1+JrqmG0aO1a+77tHIIDtz6CZuEhaOAqCF0xNVinCYScP3IsMtvFwP+Y/GDwz7KuaILJ7hQKSj7xQDcutKkb+j07+QVLcVatO+dAM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qrMjZArY; arc=fail smtp.client-ip=40.107.93.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qrMjZArY"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eWKoBATdSicX0SkKA7yXqEPWCC4aWpgIq2MaIwJbdJcRssUz6uopWyDrIJeZdrlkFiAf1duRzMxE/PdLJl5McEa1Ykoh1GAuedLx0FbP8CxO6CVZTG3rpFoY5ZC19opSMsjLWIz9u2xUjveNg1KFlxLAXmP1Xz1zpUIkis0H0SlqK1dOxjBeHE10T/eQSvmTFN/bYR46srcKgtFXmeAy32QtlJWqvKxonJPb84bxbok7xMqliqBoMV+Z8cj043OPOWF++3+pMgAwCxYiSGpAQzpeeCZaP9lkX0rOwYjaezSpSAzJYMTTrehJ+Qv8fv1yFE+Jmh1vcWNXx6FE/QBl2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sqf7zCZZOI4gH3ed8yHDBJhHSAX/lU5GKo3dRBYURA4=;
 b=B3orhnSJU86LIiItzaqT+RF6XERcS8fDBxj8ZA4wWPY6ghLhRkx2JWr+KTao35PsrDN/aa/TO6UHBM5KEYh6N6Kt3Ux1cVAz3uY8BRSkztic4tgno2gSL4K4EYaz9LvA0ayyNXExuwjfcy7kt1K9x12aqQr1T/c8XQyjestSxw2cEkHPp8vzyBbuv8vKzTlbcRzYU3e5JVUpi6ReAOZ5xEMqqpkBNy3jU50D5Ah0013ppD7mhR8llpMA8G+gKdaHm4AijoQ9Gf6oV3zXKbaap7hM29JTrm2nDAVqg7WAVubO7o5mnHa0jrg6f2kZzOS7HImlbRdJU1+RjEcFgF2vEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sqf7zCZZOI4gH3ed8yHDBJhHSAX/lU5GKo3dRBYURA4=;
 b=qrMjZArYe010nDAyybSBlphneFcGE/+ju6bEQ9iPoIHUhpoq8TJHRDHnMr6evFxxnH6g3dY+4NfMUEwsjkEcYTh/M09gjVKXnXhFr9hExz0t97l4li2xI2kxuhfdRaiZTM/pcBX1eQwqbIMKDJ8WR063wkKSBChR4Exlt5u4zCFhtaMzOK4sLirTdezP3bnFwq3oAMPSX9nkOFzgKRSZ0rjBg4aEJZf3omkDhXGWzsSkU/NNZwcNGYN4N3STM9kODYXIJbIqJePhoHB9RwDjODeOgEnJ7y/pBVS5qgcA7Vx8SV6VsJUwYRxoKmeLt2Uu+kAhjnUcN64Lgu9uMt4/sw==
Received: from SN1PR12CA0080.namprd12.prod.outlook.com (2603:10b6:802:21::15)
 by IA0PR12MB8647.namprd12.prod.outlook.com (2603:10b6:208:480::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.10; Thu, 6 Feb
 2025 11:38:05 +0000
Received: from SN1PEPF00036F3F.namprd05.prod.outlook.com
 (2603:10b6:802:21:cafe::48) by SN1PR12CA0080.outlook.office365.com
 (2603:10b6:802:21::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8398.29 via Frontend Transport; Thu,
 6 Feb 2025 11:38:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SN1PEPF00036F3F.mail.protection.outlook.com (10.167.248.23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8398.14 via Frontend Transport; Thu, 6 Feb 2025 11:38:05 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 6 Feb 2025
 03:37:57 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Thu, 6 Feb
 2025 03:37:57 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Thu, 6 Feb 2025 03:37:57 -0800
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
Subject: Re: [PATCH 6.12 000/590] 6.12.13-rc1 review
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <ea698e1c-02a8-47f8-a66c-b7e649dd417f@rnnvmail205.nvidia.com>
Date: Thu, 6 Feb 2025 03:37:57 -0800
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F3F:EE_|IA0PR12MB8647:EE_
X-MS-Office365-Filtering-Correlation-Id: 594f318d-beb5-41f6-eb84-08dd46a2b8ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|7416014|376014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Zit2dE5RTnZWK3JOTWl0dnlYUzFBd3FybHBkRFBCeTQ0Nkk0cS9jR3UvRjZQ?=
 =?utf-8?B?VHJ0OWc4c08rQjAvczMwaWM4RWdzRlgyc0FsT29WMEl1T2V3dWVUc2xhRnpp?=
 =?utf-8?B?bTJMS0dmeHd5ZEVvSFFVa1UrNVdVY0pwc1E2SmkzYnE5RmFDWUE3aFRUYlVU?=
 =?utf-8?B?N1ROeGo3UlJid0wyVjFYeThHWCtNZERZWXdGRFVYSFl2SUMxc0xSVGRkcUE0?=
 =?utf-8?B?cngzUmJPdTVVWkVWd25YdVMyRjljVXhCS2VSYWxJOW03amkrMjc0cUEvSjRE?=
 =?utf-8?B?aVF2enJRcDFCVXZ6MERlY2ZDTUhxemNsY2VxMkhlL0JtMVlPdHFiTHRjelVN?=
 =?utf-8?B?NEtqZmRJQWpsaWlZUk8vTzJCbnJxZW44WlY5UXpnSjNKeHVQQ1NsY3dSU1gw?=
 =?utf-8?B?ajFuVDdFLy92Y29MU1FQcDRUcm5TVUhFb3NZUlBna1dJTkxTZHJMdGUvNncy?=
 =?utf-8?B?b0Erdjg2SVYyZEQzLzhPdUFZQlJGUldnWHpROHVRN21udm1VQVY4V0xCMUx1?=
 =?utf-8?B?QTVuWjFlQXZ4OHFzcGYycEpaaG5pekhoYlp5MFo1S0xwZlJEaVVhK1hOUW0y?=
 =?utf-8?B?QXZoYW5hNjNGWlJNdmtSblRTWE9GZFV1ZWlpblhXRUlxRkE2N2JEOG9VMDlX?=
 =?utf-8?B?YzVXK0ZSOTdQd1hManBCemhrLzJ6UWw1aVk1OGM1NC9teGlnSWFRUW1iQzgx?=
 =?utf-8?B?cjF3cW9WQkVPMEdncDg1WngrRG5mL2JqR09pUUFzNlpjOW4yRXc3TVFWYWVW?=
 =?utf-8?B?OURMYmM0anJlYWNaME5TQjMzT2ZMbTN1V2xBU1BhNXhPYTIzSCt5cGEwMHRL?=
 =?utf-8?B?ZGd0S2wwVDZKSzVMRi9BNHpsVXI2QjJmZW1BeFZFUEVhQ2hvdklYbjg1ZTEw?=
 =?utf-8?B?dHd2Q2wzdzBxWUV4d093YUVtT3pyNGE5Y3dQSmRoMnlsL1VZTXlZeTJpTEJH?=
 =?utf-8?B?amFSRHM0ZTlyaHV0bzZnWTNxamVZUjREamovMjVsdmNBK3NweTQybHR2VVBP?=
 =?utf-8?B?cGVZdTZ1b1JyeFVlOGRwMFRyNlIyT013ZnlwYnh6Zm1tR3Bjd2JXdXV4bEUz?=
 =?utf-8?B?WVVORlVDUFFxczRjaXM0aFlnOWpzakdHVG45TFBtSFJoSGp5dWJxRUhMcjJH?=
 =?utf-8?B?aTBIU1gyeUJyWittRVNXNzY2UmNicGFkTTdPd0R3RUgzOEpYWXh2blFrTkZV?=
 =?utf-8?B?ck1aeDVhWUVYdXNIT1dLN1J1MEZ4NVpLQmVVUTREMHlaVnowUlZlYkJ6dlcr?=
 =?utf-8?B?SmZuWlhVUTBCTC8zN21jU05SR3pXSExSRmxOdUVwSmc5aW5WaE56WW94aW0x?=
 =?utf-8?B?SFptemwxL1M0blRaS3VBNFZSWlJNckRTU2xWaEVTMFpLVjNCUW1zRS9FVVM0?=
 =?utf-8?B?OHRYbjVOZ1pOM3pCbHM1eVFRRXlWVHNaREFlUW5NUThCMU5xU3VSTzJ0L0Rh?=
 =?utf-8?B?Z3prcEQ3N0Z6YTVhQjVoMHJXbWlHR1VJSHY5TE9CY2tJLzB2S0ptNkpNNW5K?=
 =?utf-8?B?U3c0K3JTaFJpbjlyTlNBRGRralRzZGp0ams0YjN3SDJReTZDc2lIeWNPTUI4?=
 =?utf-8?B?N2lVVkNUOEc1L2JCN29EQk9HTDVzNlRVMXpOcW9Xbjd4S2dqUXhpT01lNWxE?=
 =?utf-8?B?Y1ljR1g0T1VZclMzd09DSHVISTU3ekovYVNRc09hSmpsSUUrTHZFS05paU9k?=
 =?utf-8?B?Mm50WEZpcHlaWTZ0Kzl2dWFMZU54ZE5SL0N4eGNMdUhudlJRN1M3WXRYYjNN?=
 =?utf-8?B?WjVYelQ3RHpvblJyd0JmTHlyVHhmT2h3c2RRNW1VQlUycWMwTnhIMitaWFJI?=
 =?utf-8?B?bjhaRjVoS05WdklMb1NSRmVBdnF0TjM4M210cmxYd0FUdTEwRzJ6UG9JK2hQ?=
 =?utf-8?B?c3ZucVB2ekQyYThSS25yN0w5U3o5UlBLT1pNb1dMRTBWVVJEN2RGSXdCdnpT?=
 =?utf-8?B?RHRsOWhPREQwZS9PbFVqNEl2MUx5Q0xMUkdXK09JT1FLK0JlbHNrcUxNQ1A0?=
 =?utf-8?Q?3wi8iRNGhUaX1qx9xk08aA/GBeDkxY=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(7416014)(376014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2025 11:38:05.2976
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 594f318d-beb5-41f6-eb84-08dd46a2b8ba
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F3F.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8647

On Wed, 05 Feb 2025 14:35:55 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.13 release.
> There are 590 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 07 Feb 2025 13:43:01 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.13-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Failures detected for Tegra ...

Test results for stable-v6.12:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    116 tests:	115 pass, 1 fail

Linux version:	6.12.13-rc1-g9ca4cdc5e984
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Test failures:	tegra194-p2972-0000: pm-system-suspend.sh


Jon
