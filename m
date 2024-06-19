Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2075.outbound.protection.outlook.com [40.107.94.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F80C155759
	for <patches@lists.linux.dev>; Wed, 19 Jun 2024 19:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718824763; cv=fail; b=D3erHgx2LzuyUgWDNG3Urs9flUEtX/Ofql41MT9RMlIDsUtj0ovdY2ofSbsemneS5VDv16u1eg7ZBs4rwtZ1elmTnLaxOmf38iJ+QJ44dInvJH6T9bpeux4AzRKCo0GFZ/LEJZzsm0uD/EZCRgYkrSNFn62b07ESgfttubiYpB4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718824763; c=relaxed/simple;
	bh=lhTRrAsaFuTGw8OyA46t9N2xrgXap59nEuqtCwI73E8=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=EG8Cgf1rPhMkW6jcbxJ09ROPQ38XTS/UgoyW02wCxdDuYYzSnUUFRf586BRAdrQDYg2K9/jPP6Lorb6L+VYOw/u9d0Oi7GVacpbt/Wzc+WduVAJnM5wV5DJKxf28KwD9Ed67IlHMBa6k/GsJqjmzYPXhllpjnr4J++px+MdfT6U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lgdapaXc; arc=fail smtp.client-ip=40.107.94.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lgdapaXc"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ll1Nifp+BlbJGwmxhjOXeQb4G8YY8P5CXwYM0qgci6K9vbJ4j5Ka0ljYzH+mYonV3/KtTO3VHIA/cO3mesyEupwCdFLi+RATgCPmTVR8E7vYHx6GNZFHaI7s/WiZIIAfDjocAP3lBtzr4Rbi/dnuky0UtA4mrkZRxWr2pXvo9cKXztil1czrdAg0ZNRSvxMe/+5TS/ZZhcvOD/tXfZS57gYdTX2QMg56PGL7ljIeoT5QnkYurRb3qfDeeHj+hHahOM+fpDNl4/4xD1oHj9H/ubIvIFQ7ll7d9e8ll+HwWLnc8v4/nGyaScllTpQxwuPnRISwKjjLRl8iciWO495jxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ucc+jsNg+2j5ak/hCJKDb7a4efrG+MRL187/wRxASUM=;
 b=Iv1qZFP4do/Gue08V/8ze8owztPEQYr3pMOfwMYwLCN7W/XDqONS9KKhpVUwi1DfuOPExDn8Q29BqMaDgQSuJJkAyWmZEFcK/Vdz1lSTh989p6j3OgqCccwOWZwOsGoYmBVkAwwS7yZ1UqTm9QPHEkEKoxQ/p4ZsULn5WKmndPq+lPe/t4743BrRAagX9WZ7BZvGrc8ZBSBfB9lhecVU+Gxes1VJSBED6aTnPBFyqiLn7UwoXYqVGfBpWfVfWIQd0vJiPhfl3xIDv1UYckmDTYYoiGjxnI+FBBLlhBEPRUazA37Zppt0rDWNzb9KZVNfcmrY2DaaRT0T3NlEdL7+bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ucc+jsNg+2j5ak/hCJKDb7a4efrG+MRL187/wRxASUM=;
 b=lgdapaXcvckwV4wDUS+AlL6Mk77+uACR0aZQUZ9L6Bdv6zSb2mfQ5iws8XHwAaFpm+NLkmFT+7AEbaARi9usZ/m10rnnWEh9sVEdLbejwhFXuI2123nf29qpLIbR2fvkO1UFyRvxd2xZCSyKUwm8Vg9lqhMI7f420/FdfxJ0ariUrBaUt8f4bZhhh+BwvpGgHqJo1eYsmbBp8DBDmYgXL9wHbmbvDSNwq9WgsnWfB0jHi72OyN3wHr2TMXB3Xj5lIf6GV8sHhXc9ZRzA55pPvR58GiIp6Xg2Z4jaWJIo5DL0TIpgKPPUyug6fN/A3KMkAVtVrd6NC9DEtN9yIfgKNQ==
Received: from DS7PR03CA0011.namprd03.prod.outlook.com (2603:10b6:5:3b8::16)
 by MN0PR12MB5980.namprd12.prod.outlook.com (2603:10b6:208:37f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.30; Wed, 19 Jun
 2024 19:19:16 +0000
Received: from CY4PEPF0000EDD0.namprd03.prod.outlook.com
 (2603:10b6:5:3b8:cafe::87) by DS7PR03CA0011.outlook.office365.com
 (2603:10b6:5:3b8::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.32 via Frontend
 Transport; Wed, 19 Jun 2024 19:19:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CY4PEPF0000EDD0.mail.protection.outlook.com (10.167.241.196) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7677.15 via Frontend Transport; Wed, 19 Jun 2024 19:19:15 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 19 Jun
 2024 12:19:10 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Wed, 19 Jun 2024 12:19:10 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Wed, 19 Jun 2024 12:19:10 -0700
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
Subject: Re: [PATCH 6.6 000/267] 6.6.35-rc1 review
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <73dd0b80-5427-4558-ba97-af9d1e37053b@drhqmail203.nvidia.com>
Date: Wed, 19 Jun 2024 12:19:10 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD0:EE_|MN0PR12MB5980:EE_
X-MS-Office365-Filtering-Correlation-Id: bfd1af6f-93fd-463f-b00b-08dc9094b5c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230037|1800799021|36860700010|376011|82310400023|7416011;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Q0xEN0tvK3lMNE1VbjZieDkrVlZLbXc3OUZ4dVU3UXk5cjNCRlJZeGYwYS9h?=
 =?utf-8?B?QlpDdnRRSHVEL25KNEJLcWpIWUkxM1pJOUNVZ3R0V0ZMQkRUbDdsUlFvcWVt?=
 =?utf-8?B?aFlIWndzZFhyb2JGRUNSdTl4Nkk2ZnVGOTJMcUNzbGdTQ2NLclZhNTl4MTFP?=
 =?utf-8?B?MmFpRFFXUmZjZEJmaC81Y1pZQ2VHMzFYWjFlS2t0ZXN3NW9rZmlVcFlRdkZ5?=
 =?utf-8?B?WmF0bDFNS21Bbmx2ZGdJZzJSQ2NYMzZJd3RoYjFvbUlvelN2WmIvTk92MTRp?=
 =?utf-8?B?MkpFd0RXeFNGdmpjTExKa2tvWGRxSjV5OFEyZm0xRjFMUVFRcTV5WTNoN0li?=
 =?utf-8?B?bE9qSCtZYzZwUFZIUmREaDU4VTl1NjlKK3NabkxoUEwrRFZ0M1FvVXh3b1I5?=
 =?utf-8?B?VVBQak5lWWZ4MW5DTmVDbWFVcmNUTXhEczdZMUpOYXlHRSt1TFhKeDc3MmNp?=
 =?utf-8?B?WHVmTkNlUXhlQ3NQQnJKWWdUOFpLMUF2a2JYZzdRTFpzNkR4aFZEMFFscDlT?=
 =?utf-8?B?UlNxTjBvS0g5OUpSSS9vNVdDL1RRQU1UbXZDM3dQV3c4VWFSeHhlbTZwR1hy?=
 =?utf-8?B?Wk9wbGRkaVlYbzdlQ1RHM1Zqd2lIWGpjRFBwdTNJMzRXcHFpUERmWVRsaExx?=
 =?utf-8?B?SFdsOEN3M25lNk94cGIvbmVxZ0l4L2JOQmZ5dkRQMXpZWlZQM3RCbVdZOXlF?=
 =?utf-8?B?RzBPUmhWVHN5UURzRGRLMFFrVHNUcnJCOXhGV0thY01Wc3ZIaGVsVklORGxT?=
 =?utf-8?B?aXQzanFnWURJUGlRcUljMXdMZFJWc2NURzdjU0FrTEtjcVNJYVN5Z05nOHRH?=
 =?utf-8?B?bVhNSGJNRE1pUU9Vb3lTSFNsUWVYaVI5N1pSZTVMUkhxMkFQSTBWSm1TNGJL?=
 =?utf-8?B?N3JERWQ1QVlvWGNUTnZCbWFzM1FVUEtzdzZ2eXQxb1YzbTBFaDdCc1VXSWpO?=
 =?utf-8?B?M29VSE5DNExmaWJkaFpvS2lpOHZqN202dlB4U2Z4b2hpaEZQWmlvNkZ1Z2lO?=
 =?utf-8?B?b25xSjgwNGpQWDR0UDltQ0JDanJQRVZNY3VMYmkrMkZJQnRITkRpRHgyVVpR?=
 =?utf-8?B?WjRpcEJJeVNLbVFON3AzYlkzV2pRYUR4VC9ESVVQZm02cWZZV3I3eVlhT1BF?=
 =?utf-8?B?Q2ZyNW9Zck9PN3FtYmthN0NjWUtLKzhnelpxZHIvRGYyQVlOVGVaeDVPVEFq?=
 =?utf-8?B?c2dXUGcyVHBHMXQ4M0cyY21qZ0UvRXdUc1pUdUFJK0h1SXY5YlYwT0cvQWZR?=
 =?utf-8?B?VnVpa0tHbjZaTXYwR1NTL2luVEJEWTFRVElZcXdmcXlBUmRhL05TKzNINTdk?=
 =?utf-8?B?cW85MjB5V2o0RGFiSUNzK0lLY05tWnZMVHl5akF6YlpzcjJwR2V2eGtxSEhO?=
 =?utf-8?B?aFI3MnZUcXpCQkVyUThKckoxK1VZMTlNeFUwV29zV1lZekQyTHF4bjM3cGkr?=
 =?utf-8?B?Y1U2Y2hBdFhQUmVkbjZOUCtjUm5UYWZCNzJRS2YySldzU3A0R3h0ZFRNV2cy?=
 =?utf-8?B?ZFVnZ3N1TTA1THhxV0RxbnhoV2FrSDN4aWV3K0RTdEI3NWM5WnU4YlZPYUly?=
 =?utf-8?B?bmFxN3ovVzZUSXpRTHduZFpFd3lNd3pybjE4NE1uWkpWS04vNWhRUHRoOS96?=
 =?utf-8?B?ZE5lVWNrSzByajVOUEpxdjlSR044c0ErWDR5WTFRNEpjK2N1MFlmWGVaNks0?=
 =?utf-8?B?VEd5Qy9tMDlwcjNUNWZRWGtTbHU3akpacUZUTS9OdGljb0lKMmltWFRScFdz?=
 =?utf-8?B?b1hoRXZwZTJtMmptTmZYTkZUSkROZDZudGxWSUY5UzBEQ0hkb0xUUm1QK2dv?=
 =?utf-8?B?YWM3ekgwK1NGTkR5dmV2VWZXYTFydXRCMlpxTXBSbVZuMUtOZUc3MGltS1ZL?=
 =?utf-8?B?NjRERTdoRzR1dEhXbXFVVmdyZ2RmaWdOMHlXOEljcjM5dUE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230037)(1800799021)(36860700010)(376011)(82310400023)(7416011);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2024 19:19:15.7603
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bfd1af6f-93fd-463f-b00b-08dc9094b5c1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EDD0.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5980

On Wed, 19 Jun 2024 14:52:31 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.35 release.
> There are 267 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 21 Jun 2024 12:55:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.35-rc1.gz
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
    26 boots:	26 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.6.35-rc1-g0db1e58b51e3
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
