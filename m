Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2040.outbound.protection.outlook.com [40.107.223.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 859B614E2E2
	for <patches@lists.linux.dev>; Fri, 31 Jan 2025 05:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738301958; cv=fail; b=IKxS+R7V9AbeeQCmyK3d1I9HfLnAztB9Wz9l91sQfZsRy/za68pKIpVCcPtZjTYJS7rCP8yhXGrcDhjftl5ehot7UuS21X3K3row+4bKf+3pg7hIidVHXXvuCbhuLdH6N686tuvwVDyafXBOXg+qiQtdvaDMZoQe6+ibquwt4/g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738301958; c=relaxed/simple;
	bh=xed24Qv8qp/bmWfbTo3u9LwTwTdfaAwQG8Ox4lDtdzU=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=PbX6WEO2g/SVoVMrO3e5CAN9IUkE/j61DG/I+IXLWAeB5fFHEGD6s7+UK5EiFfOTbH8tD2aZeh3fa/o25JqxOGuxKx/PldC0KNCepxgaduCc4MqFe75GVsx1OHfdhvCaT+ppL1H0C7LW7BvAalK3AGfo2fk10pjiAJe1CMbff4w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=KNIBqxd3; arc=fail smtp.client-ip=40.107.223.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KNIBqxd3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pqt0F7YwevPo7/KwUNLmclOI+46AQ/v19g8lN1CXFjLz7lKtc/N+4hQw3tKBxbWob6qMv/uYWeuprAsrlvgbXvwDUll8Uln7JOqXhd0NeYYVgcvRF9W09SIJ6EVlKc9SoN86QQsSrOChRUF+EWrnemuGlCIf8RPNngaQWKphMAsTnQh/O19wjqLxuByO2GpjAETIB0/6RoTRvd/FHmAJQPRi8TUYoCIBt6ZdvMcUCrjNMbtmv45XGS7rzW208R4ttAZNKPmvW8zzUWhiYbj2ZYIT/WRUb83tDZgd9BbJQF6g6VW9szl+FuZVUrccPqioKTip6zX1/iUtaY3gjpuJFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WRQwEVMeYjujB8XbMgnoypJxQdrmMnhNcRIc/BVfHL8=;
 b=SNvdNtcoUm3aKwosDzis4jj88R7dkaZWCPfPVNJuEbHqTR7rPOa+iQ2IraE2GX2kYyO+xEmehqXuZP8pyuWaxovtupuf+KO743P30hX1udPq72LW5ewTbOLIx26bnTDtv/vSd8Mlzdy+7VnYsHMTiXeTodj4WtghoXAlkHOtHj0Y/K8OOEO5iGO/KpNattRMKp9dqRAotcTuTauVLKN8+FIZ8EBCcZR0h+LEnBgin5+EupRwvVRmMMdv2u7CZeAIJ6QK58AYwGTow+Fm6Moos+/oT//+gki6hYwew+HO7f7My/EvFxwYWLCBdzBNuyvNY5nAYxILiubKA7ty5tRWJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WRQwEVMeYjujB8XbMgnoypJxQdrmMnhNcRIc/BVfHL8=;
 b=KNIBqxd3MLD8xYxoDRWib5W8eFMr7RL+zU0v/PGvhcpN3IqjYatAzM9qjvL2cJ3EVg799JDav4Xp1HE8sXdGmofL2HCLguY2hFskE/wzcUxWJsbPFWeerNd/kMJNazFvlD4BSjb3oq8k80wJNkyh98dqD/t/7ILYm17AMpAvfcldHfCSRp/uY0LifqFGffUHFdVRtey4mkAOoXCfUsRp2swLnnHOUGsrbz519+4kkwK0PmQkuKXgRkICd6xzFOoh6HUoTBNhSlN3IBLDQiQiMDVUgLjKLhwtXbTH8qGyt54EDdAe28Z5NyfYpLxawJcZWo8z7IBZ+PxAT+DStMcsGA==
Received: from SA1PR03CA0012.namprd03.prod.outlook.com (2603:10b6:806:2d3::15)
 by DS0PR12MB8788.namprd12.prod.outlook.com (2603:10b6:8:14f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.18; Fri, 31 Jan
 2025 05:39:12 +0000
Received: from SN1PEPF000397B5.namprd05.prod.outlook.com
 (2603:10b6:806:2d3:cafe::2e) by SA1PR03CA0012.outlook.office365.com
 (2603:10b6:806:2d3::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8398.20 via Frontend Transport; Fri,
 31 Jan 2025 05:39:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SN1PEPF000397B5.mail.protection.outlook.com (10.167.248.59) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8398.14 via Frontend Transport; Fri, 31 Jan 2025 05:39:12 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 30 Jan
 2025 21:38:56 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Thu, 30 Jan
 2025 21:38:56 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Thu, 30 Jan 2025 21:38:56 -0800
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
Subject: Re: [PATCH 6.1 00/49] 6.1.128-rc1 review
In-Reply-To: <20250130140133.825446496@linuxfoundation.org>
References: <20250130140133.825446496@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <11a113a4-722d-4650-99db-7ed2c5fbcc99@rnnvmail201.nvidia.com>
Date: Thu, 30 Jan 2025 21:38:56 -0800
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000397B5:EE_|DS0PR12MB8788:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c3949da-a4ca-4d28-86fc-08dd41b997b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014|7416014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?KzRhNmw3ZFovQlZTQlJrTzFONHlyY1RQS2RkZkR1OXc0SXdZc3hUb3lvc2pP?=
 =?utf-8?B?K1NTRXpCenFkelN3TG55dmpseXoxNStwWVdzSXV3YjBtVThFZFY5QUZMcGpw?=
 =?utf-8?B?YjZmY2FkSG54bm9yMjd5SFhRUWZwUHRpcEhIZ0ZOeWVnUlBNZWdxOHVpK21W?=
 =?utf-8?B?VTl4VUhHL3dUVjUyQ1lMWHptL0pFdytXTTM0RmRmZExhaWN0d3lBL3lXNzcw?=
 =?utf-8?B?VkxRWGxlUWthN3VXQ0ZLTWhBQkhnMGxKS3VoTGFYVHBYYUUyUE1lK05SblQz?=
 =?utf-8?B?SUxjSmpnRWRES2tWdkEwTnRqbkFLdG5lVGlSSlYvb1hkVkI1WGoyeGRPb29P?=
 =?utf-8?B?WjFGL3VlcThqUG5oUnVzd0FvOWFDSk1WSnJpUExmT2twbmJxQ0pzS2tIdGlz?=
 =?utf-8?B?RGdxLzMraDF2VmZzUnRQR1BMOTVBSU9PWnJrS2tvSVF6VWszMSsvVW9FWHcx?=
 =?utf-8?B?S0JQKzlOYkptaytUMGRFQWpCR0dSL0ozUVBjNndVbVozVmNKWE02TDZrYlc3?=
 =?utf-8?B?MUNJUHB6bjY4RjJnVUs4dHlIWHZIWk9BZytwUy9OaUZ5MG82K1hQMklFWVlL?=
 =?utf-8?B?YXZ3MVVDbE1GaUozMU9lUWt5cGxqd3pUemNDNm1uNlhiQnJvNzFkWURVZS9q?=
 =?utf-8?B?SGZOOWZCcWVOaEZ6aWVHR2s1WjZxYk92UkM0MTBjbVR1SFo0eTd5bTRxeHlK?=
 =?utf-8?B?SWxRY1NvWXVMdmhrM1ZrY1c1UmhmblcxRGRlRVcyTkFQSHpsR24rdFJNbUc2?=
 =?utf-8?B?bG5XSS9XYU90YnJQamRLaEtBM2NEcjlUU3FraThZbitFNE1FVlBLREhZTlll?=
 =?utf-8?B?dktFdk1JcEg0ZlBkZVp6L2pVY1ZsVWFKZUwwbFZqTkJLRmltLzA2VTlQcURz?=
 =?utf-8?B?WnFObVBzbkJvSTZueUpld1IrS1lEd1gzR21VR2g0V2hSSHZiQ2g3WXdoRXpz?=
 =?utf-8?B?S3dJMWd2ZjNSTXFzbWRHL0Z2SlBlTTg3eVB2djBMQjFuOEF0T3poVUk2MHhi?=
 =?utf-8?B?dlU0eDZVM1FLQzJUMmd0dU1ZZm5uUWphZ2l3S3grcW9ycHN4bXppNTY3SThT?=
 =?utf-8?B?RTVlc2x1U0o5b01Cb0M3R2JJUWZRR0o2bDRoNFdnQlVIWFBPOFVkUWZ3NFJy?=
 =?utf-8?B?Q3VnaGswL1dsdXc5Yk4yWjgveVdyQUNoRDRoY1JKOWJvcnphckpCWi9sQkhX?=
 =?utf-8?B?alJWSnM2dU9kQ0Z0b1RBQWplaE9EWkNlZExCaDVnU2loV1RkRTBjYzlpNVBN?=
 =?utf-8?B?d3ZKVmhhM2N2Sjh1WU9lVkNDWTA1UFVlVWU2Z0FUWkxVaWhmME9yNlJwbXVR?=
 =?utf-8?B?SS84ZzkwclJTb0YzTmdRaEtQcUxXVlhxems5QkZvakdzWkJvaTZzdzJ1RnU2?=
 =?utf-8?B?V1ZreTVsbzV3aWRSNURuZGxYWEdNZW0weS8vMkdIS0ZheHkzL2k5TFNVdFVF?=
 =?utf-8?B?NFAwM2wxTTg4RVkyYTZUZXBWYm05WGxoeGR0YUhwN2JKalNWTGFjODlPcUlo?=
 =?utf-8?B?dFVpTGVJZXBLQVk0bTlLSVNYN2hYNWE5NUJKZ2p0WjVnM1NaaE9HenRJUDdW?=
 =?utf-8?B?SzRsZW5YS1Q2M2U0MnpTK0xjY0s3cm5aS0Y0MFV6ZjJGa0p6L2RsVjZyMGpQ?=
 =?utf-8?B?Z0x2eWVHTGd2eHZnNzVqb2V0akJIblRKd0s5UVBYa1pkUVNobmx3SklIN2pi?=
 =?utf-8?B?OTlGOHBkVVBrQ2JZRUZEQjF4YnU2MFRVNUppcnJLeWY0bG01aThZVTN6ekw3?=
 =?utf-8?B?cm43K3I5RVQyL1phNnhwQ3ovTjVWR1Eyck1ZVDlLeTdpcVJIbHJLN0NMeVR6?=
 =?utf-8?B?ZHZiaVNpdlF6ZHpFMG9xT2RmZlZoN3h5cVE0Q2U1QlJLcHU1MnA1K25BdU5X?=
 =?utf-8?B?K2NnVnNsZmhQZWJUVmM5aWNjUnhaVkRVRFlicFRzVTdXSThhYzczeXA2dWZu?=
 =?utf-8?B?NXBCUnNCeVZpL2xtZVBHRzFoanB1NTNHcnRLSGMzWHFEQ0N6YjNkT0o2ZkZo?=
 =?utf-8?Q?lR5fZHaVYqp1c+FMEzeItCDW5Wpzxs=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014)(7416014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2025 05:39:12.4796
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c3949da-a4ca-4d28-86fc-08dd41b997b3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000397B5.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8788

On Thu, 30 Jan 2025 15:01:36 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.128 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 01 Feb 2025 14:01:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.128-rc1.gz
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

Linux version:	6.1.128-rc1-gda19df6ebb6c
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
