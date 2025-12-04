Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011007.outbound.protection.outlook.com [52.101.62.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09EFA2D8DCF
	for <patches@lists.linux.dev>; Thu,  4 Dec 2025 10:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764842475; cv=fail; b=PQESh8WF1Kg+LQkL/2aOEQea6acxTS8ryH6+4eEfGiJ0ahjRSoSIWT7bEbw1b4XLnNACcUWkuat5ETNZ2FwJpjNN5E89iHO/6jsNzTfxm6ZQET6Jo4TxU7Q8trFwjwULIQmbFg12zXFgCTTrO3ZTDM9WwgoEdnhJTdX0aMA3Uf4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764842475; c=relaxed/simple;
	bh=xCDtq8iVJoG/Ld2sO/8fRgTvcapiPyx9I6cUwGaHl9c=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=biA+Pk3Ma/ZVyViqNH/lIC7CP095kUZkFvvuqMwn8gh2bxNINzgmnTFsVyRWsVpsHDE5ULtz3aoSR+iGVoSErhm/OKITjs9eTkpV0VQC/l2464SjwuJcwY+tColPFDeByLgZMrij0tJEyZuSx+sZlG+Tde03XQAC3fPeG+HYg/M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BsVYuerA; arc=fail smtp.client-ip=52.101.62.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BsVYuerA"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Sbdedp7f9/F7f16JIi9U+vHOiLISWZr29iaqLFg1Af6D5MekfwxrC8bzxEgAZtWt6LVU20XzaNA2gyQIU0Dq+ZGhJBnUTsBGSj1l4vbz2YsmuzTIU5sSRy9riS3hW61fGUTJqu02Z0j50HkMBj3bQcyPpijXhyNv/v/afPmzbhBa/Zj7NSxcKKMEqd5ijpz4a12sTrVw9aoVFkOBdV94qKQpzQmo3glpDwh6ptuVW0XXMcn87PVHwuCEZOeKx80qDx9HZbIUgzr4iWA+eZWvmqOtK0AXwJ1lGapXjCtaAuft3xicAtFFM7n4wjcVrOJ6VlTWL9w9TadbMOqDpFenXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Du4XpxuT7RNO+q/Oq6PnmTJAbwGIJ5yv8GlMDb1fsdI=;
 b=lbQuVet02UU/CVrXubvvqXHheIUA6Unow1okN4bpxXfDmFhSouTSeuxzg++8e635umyYVT8R35tzBkNi+lu5AO2Xa0hieBHoVjIsqIwWrikZff80Ccv1XEvNxYdSlaDaSLZVO2wD9EMiQfKwUp9ibQuudbC+YOfg1vHiWEeZvAtnNA3vkfMVUDZI2R495dtzjlyeojYjo5tMbRdKwovKnqVkEk5D65dOCSA6FgxcHEPgQk9x9SsuULwDshUKDIXqvz3TulZjkXGSF2aggykApxkgMjk4C71rCRSzRZb7/e+1IgAbAPeqCS6jmGXxuSy6e0TfgTvZTd7pZ3V7w1CXfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Du4XpxuT7RNO+q/Oq6PnmTJAbwGIJ5yv8GlMDb1fsdI=;
 b=BsVYuerAMK9caTif3kMyP1CGnkgbPGmtXf0G6xBrL7PsKRoexkX8t+v4K8Lnf/HypXBTkfcx3YfyEQzQgJhKMFFO6gzOSRdbDN42SaBqcJVLmfUSS0gK0a9TrfvJgc4jPPyk9NtgnOMkmLZKa/QUH7iV7Kvr9P8ibzi/wDQnvnyO0pl5h2GxTCJbtA91n3A30gTiaXv6cluZm092yOh4JCUO+cKL+C3Fv7ZAAMBzsZLiB8qQn9E5aK3LjYRO4AKuuLNEqMYCEK6ojjfyo5xEQJ8AGBby8zgatRRrX6hWBg8y121lJ14R1iA/aqkVOjRZ+vw2qFKZY4QMHvBK5L6Kzg==
Received: from CH0P221CA0032.NAMP221.PROD.OUTLOOK.COM (2603:10b6:610:11d::11)
 by DM4PR12MB8558.namprd12.prod.outlook.com (2603:10b6:8:187::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.9; Thu, 4 Dec
 2025 10:01:11 +0000
Received: from CH1PEPF0000A34A.namprd04.prod.outlook.com
 (2603:10b6:610:11d:cafe::cd) by CH0P221CA0032.outlook.office365.com
 (2603:10b6:610:11d::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9388.11 via Frontend Transport; Thu,
 4 Dec 2025 10:01:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH1PEPF0000A34A.mail.protection.outlook.com (10.167.244.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9388.8 via Frontend Transport; Thu, 4 Dec 2025 10:01:10 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 4 Dec
 2025 02:00:54 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 4 Dec
 2025 02:00:54 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Thu, 4 Dec 2025 02:00:53 -0800
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
Subject: Re: [PATCH 6.12 000/132] 6.12.61-rc1 review
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <a09455f4-8b48-4a9b-977a-d8b99f18fc00@rnnvmail201.nvidia.com>
Date: Thu, 4 Dec 2025 02:00:53 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000A34A:EE_|DM4PR12MB8558:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d9fdb8f-5447-460c-f480-08de331c0d62
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TFpvSDQzUDA4RzVKbzJYcW9OVlVWU1Zhc24wd1ZuWEhIQThMU2xHNEtvRUVG?=
 =?utf-8?B?cm85TDF4VWcxYTZUK2N4N0lLQVU4L1dRTHhPVS9jYXhrbndnUitSWkRvNWtX?=
 =?utf-8?B?RFh5aU5PTEI3bjE0ekpTZTBvL1A3NWkwaUkvRWV5N1FPSWYzcXl6ZG92Y3M5?=
 =?utf-8?B?aTNULzUwc3lGVEROTWFGNzlJS1lvb2gvcnJIZENIUUVFa2VUZ01vWktpME1W?=
 =?utf-8?B?QkdoUUtDS0FVMDhZMXg5SVptQWNVVUJSNmZHNSttVnlBY1BHK1BxNjh5MFVE?=
 =?utf-8?B?R1lBZVgxT0VFNlJtR1pOREhuQkt1YU5meTVQeGNBdW9VNTIrNG5XYytUWkpO?=
 =?utf-8?B?V0RRcVdLbXR4TW5FdFhhbXNrbitlYmRrdXpQYnA0NVRsd2Roa2RXeWVmUWhi?=
 =?utf-8?B?QjNqSCsySytpcmdkeTVod3YrZWJZTGE4YWpzaUI0S1RSdjRDQ0htV21sckoy?=
 =?utf-8?B?K053YzdQRG1rL3B2NlVqYzcva3JKL2Zxc3FWZ0t6TUp5ZTdFZTZySnA2OENK?=
 =?utf-8?B?enAvbSt5bHZ5UjU5UXhjU1c2cmtvUi9GeG5GdUZJMUd6N0pMbE9wQVY2VTZ6?=
 =?utf-8?B?Z0xZR1BISWpscHJ5YVFxT0lzWDB1UmxyQ2N3TjhIZ292V3lCVnVHSERVTm9L?=
 =?utf-8?B?V05hWmdjZUoyd2hzajhMVTNrWjYrcm5CNktDcHJhRXN2VGdTMTd5VitMd2lK?=
 =?utf-8?B?aWd2UTJaSXh5cjJRaXFYWjFTdmpZdU5haXUrQS9ZdE5WYmIrdExlSDZYYUE2?=
 =?utf-8?B?amNVN2dkVWRZZEdoeEhqSHlpYlFPemJvK21Rbnh1bW5tdmpYNmkzRGw5SzhI?=
 =?utf-8?B?RXI0aFFlUXFQRXNlOUFYNEtCbG84QXpGTXlWdEVmajdOZDdqejlhZ0lDTHVS?=
 =?utf-8?B?cmtvNWtZSm5lUmhmbUMyZWJ5cm9lR2dkSTdxVGRVYVVnQ3FrSVlmMTV5RGg5?=
 =?utf-8?B?dU5YQjNya3dqQ011KzBBUDcwSHNVdFB2Q1NnS0F3ay81KyswbUtTeDIwL0xD?=
 =?utf-8?B?Z1NzYW9jUW56c1daSXIvVnF2cG1CeXZ2bTJaT21KaHVDWG13dXplVjliZTE4?=
 =?utf-8?B?SE1oOU1NaXRVNGRZbW0vR0F1U0FkNENrMG0vRWgvd2RiMmlIVzJGTWgyVWFJ?=
 =?utf-8?B?MitGSXZadWtLWUx0WTltQ0p0SE15bWZ0cHU0SGI2UHdkMEhncnJ5WStjNmNj?=
 =?utf-8?B?SmhzNTFkSjFxL3FhWXJhcXpmZXpQOWtYdDRBa0kvd2JCaEpIZUVWajB6RnNx?=
 =?utf-8?B?QTM3TFgxZ1ZyRHRhUHE3b3NMN1FmV1dnQzAvekpUdlh1TUpPbkRRdG5IdWVw?=
 =?utf-8?B?WXQvN3E0UHBmb1cxeVdtNXBkTUZUSjBjd1hjUzBSUGE1czl0UitMU0Zla0Z3?=
 =?utf-8?B?LzFzZDhDaVhUdnFJVWNnS04xWmsyU2dLZGVxa1A4NjRCL1JQbnp1NkJORTIy?=
 =?utf-8?B?OVExZHlDZUhsVWdnbE8yTmlrdWFNbVRVcno3RjZyeWVCRjBHcSt4YkpYa2R6?=
 =?utf-8?B?akRkVmN0VnVrUWN4SnYvZ1B6UlBzMTV5TXdnVElrQmNmN0dPN0RPcGFQVmw3?=
 =?utf-8?B?T3RxK2ExcHJtZVM4Z21MQWh1ek01cTR6R0xlNWtocklYQzViQW5SdE4xL3lI?=
 =?utf-8?B?RkU2TDlIY24wS1JNV2ZjWTFCQU0zNkdwUVd0Z3BIR1VzSFRYeFNXZ2xwWVlr?=
 =?utf-8?B?UlhTMm15TmpnYThZK3V5WmJaRmNOSGR6OVl6S1hrMDFxUEhseERBMC9NNXNy?=
 =?utf-8?B?YklnbG9OM0RvczJmejJuZlRwMFNuZ3B0OU9aaEJadDBFbmFJcVBGMlpoVGIz?=
 =?utf-8?B?dXYxVGVwcXkyKzZDd0pRajdOOVJLTWJzSm44V2Vhd21JbVdGOThOck1xcndk?=
 =?utf-8?B?WUNpNE50by9oRkw5WmM2dGhtQk1SVlFGY21iOWZaVGVtckZIbVNVbEVaU2RE?=
 =?utf-8?B?eEd5SUxkbkZQOFhrWi9KTkNFejdlTFpjQ3hVd3M1aHpmSGxnelYzR3JiY1Rx?=
 =?utf-8?B?UFRyS1FkYThaeEo0SEQ2dnVxN0dyQk1GYnc5OVdZaEFLY1hWRzhyRzU2YU53?=
 =?utf-8?B?NUh6ell6N1VwU2tYYjJrODFRNndiSWNvZkEzQWFEajRUU0RPdXR0RTBkQW5Z?=
 =?utf-8?Q?MTlU=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2025 10:01:10.7850
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d9fdb8f-5447-460c-f480-08de331c0d62
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000A34A.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8558

On Wed, 03 Dec 2025 16:27:59 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.61 release.
> There are 132 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 05 Dec 2025 15:23:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.61-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.12:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    120 tests:	120 pass, 0 fail

Linux version:	6.12.61-rc1-g8402b87f21e8
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
