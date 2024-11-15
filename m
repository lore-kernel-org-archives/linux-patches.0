Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2060.outbound.protection.outlook.com [40.107.93.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 988A11D6DB1
	for <patches@lists.linux.dev>; Fri, 15 Nov 2024 18:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731694284; cv=fail; b=nbvPfXa13QkF1CwUll1LQPFCFMbHHC4PowYMQIOV0YQMmtct9bYne/4jaVIhu/wnrCLv2VtZeKHd0s33388UYvIPI9jsWtriL4uZ8kYk/DeYhde6auNl7TnKYyW8L583LvEO5GbxYybDhfafAnyBatSz9fZC3DQri8bFK1dPgJg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731694284; c=relaxed/simple;
	bh=LEs83nTmhu0G3ziG+k036W48dbK3uEbeXjPV+mBjikE=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=uSO/WQB4GtcIleXVrTiLchWLkd+2D7kav/vsiJ3JglCyKy6pjImihoeFrJOzxB0Hbju6AnKRiejRca5Rf0IzW8OR4slW3AZNBhtwJ9H+A2DwRzB02a5RE73F3y/i49lTuDxKZ/L8dNe5eRq7zug4SMX3uEIW/fhLOTuF1u7XX2Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Nz2QNFaO; arc=fail smtp.client-ip=40.107.93.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Nz2QNFaO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qHsb9/x8SfGV0uxC7AxMMwD0tDJvbMdMqV1WAFfZp/ctRFsL3RnyMLzDkbua43D4RmxOSyDY+mJMti9YcvBZu4fckrmqr+4YM7D1j5TUUW9KhItDBhvA7dlc7bXbRlDGmqOI6cEDagLJAaRS4UQRw8qZ5a2UncGcM3TikcyPgUBTKc6v/7CO22d/D6yoDBdcIYx+frJy31sXnJQgO0K6muNxZXXv0Fi52FHk+TvidLJgnk4E2Av7FUa9SW7+WqFGG5S2h6F4bMHRnmkDUHYgnnAsHPHcsyWapU5Ve+X18reFj3qZFikC/cRUkLx+/ITT8Va3xjMNwvYvCoPQO7qPpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=isxoLdE0V2Wtf/C8AWC/17kyNkhVMXoaQ5ovS++iVKY=;
 b=PtqIQCyMlYsMCzvajNvmAmnFU45CGkdi+wny/2jfSKS1fbce2I36FAgJV7f1pY0SrYvUxpzadZXWM/xShDYBqwtGjrG5NgO+tZaVpEqjqHZkHMlLswG+Q6LnnvajS8OMvGp8XljeNYPu3f4ffiGOWUBhTyJGud2AYXNJKS4JZsJfW60/ApvNu/Q7BGGLeEZ0TkdObRVUT938YsOcUfCRV0Z1LWF6CFj4I514Jvew4GI0dS4mpBQe4gFQr067mrDZMSWT8QPlNLJoH90gKeuH/hSb3miKbHtKi2Y2NHLxPBWI/IvppB7qJWIA8iJwux7eiT++WxKVzTvSzoHXYJuhYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=isxoLdE0V2Wtf/C8AWC/17kyNkhVMXoaQ5ovS++iVKY=;
 b=Nz2QNFaOL2OZpbJgZhw+FOSsdYWm5khpDea1kNMXWEffWPnArRv8bviZsDZasH21JoHFxOVyENroUHCgJZUUy38z1kmHZl9aOYaMXVNUj7CCIkhx7mA+6RsOYWGbQ4sNEttXL7MADqhgwr2g1bPqMSwiRR9t93Qj0MldGkDldQTGmSf7sJD6RtDYlFluQecONyoaxYKJXAOgbjA7j4Y918qZ8OH/hTINrTwNm/eyFhMHsX//HXWgA+NRz9/4bYvRUrF4FhMLpzKCHXWypZ94c3b/9kaaQiQZHRVk6oAOQIrOjO3A5JPasLQhlELwsIsqs3G4sW2ir80jMdIlkDB7ig==
Received: from CH0PR03CA0041.namprd03.prod.outlook.com (2603:10b6:610:b3::16)
 by PH7PR12MB9254.namprd12.prod.outlook.com (2603:10b6:510:308::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.20; Fri, 15 Nov
 2024 18:11:19 +0000
Received: from CH2PEPF0000009D.namprd02.prod.outlook.com
 (2603:10b6:610:b3:cafe::1d) by CH0PR03CA0041.outlook.office365.com
 (2603:10b6:610:b3::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.17 via Frontend
 Transport; Fri, 15 Nov 2024 18:11:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH2PEPF0000009D.mail.protection.outlook.com (10.167.244.25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8158.14 via Frontend Transport; Fri, 15 Nov 2024 18:11:18 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 15 Nov
 2024 10:11:04 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 15 Nov
 2024 10:11:03 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Fri, 15 Nov 2024 10:11:03 -0800
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
Subject: Re: [PATCH 6.1 00/39] 6.1.118-rc1 review
In-Reply-To: <20241115063722.599985562@linuxfoundation.org>
References: <20241115063722.599985562@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <b031f5ed-a7ed-418f-9865-20a0aa933c73@rnnvmail203.nvidia.com>
Date: Fri, 15 Nov 2024 10:11:03 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF0000009D:EE_|PH7PR12MB9254:EE_
X-MS-Office365-Filtering-Correlation-Id: abfd35fc-4d1a-4bcb-7042-08dd05a0e71b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|7416014|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WGE5aUhSdGY0VFlwQ1VBNDBydmc1T1BacFJqMzl0NS9OU3JNVm5MdEpheGlR?=
 =?utf-8?B?eXRWTFZ1ZnlTNDFLdEJRZndFVjZaeXBxV053Z1JHMFBYWW1zTks1SE0xVG1H?=
 =?utf-8?B?bGYzdGp1R2dwaFhneitmU256My9zcGR1c0Yxc2l6Qm5rTnExdE95SGRFMGlC?=
 =?utf-8?B?ekJaRXBZTGZibW90aHA1VHZvclZUQkhQeVN4T3dscDViRmxIaWV6eWhBRmhU?=
 =?utf-8?B?b0JNYStncUdHckl2WTVyRkRLd2ZxQUUxcy9yT0pNWVNYblE5RmkxZXBjM2ZE?=
 =?utf-8?B?OXJYbmFuR0M1YnEwZ0FPdXNpOEdKREU1c29nQ1cxRDBTbFl0ZG5xOVgxTDBK?=
 =?utf-8?B?UzhhUGhucE9PbFQ5Y0tVVjBua3Rzdzh4a0YrcktwTmp6Tzl1Zi9FNEh1dG40?=
 =?utf-8?B?ZFZyeWRlTko1QUVjSS9ib1lsbE5pTlkxd0hzTHlVdnNIT2tWcU16TkNLeGFI?=
 =?utf-8?B?V3Y3b1ZIUUd4Y3JDQWQwT1FHSlQvQk5NWUo1NncvNFAzQUZEeHNEVjdKNDJa?=
 =?utf-8?B?NG9qMk0vaWl5ZjErZ3pFeFFHdytoMWh4T2Y3eXdzVHdjWko1WkI4akhEYkdW?=
 =?utf-8?B?Y3JrbUg0V3dUMWVPR0JuNGRCWFZzR1ZrRmwzMFloaDMwcjU3cklTVEFoTE5w?=
 =?utf-8?B?Uk5TR1BYWGtSNjZPc2oyNnQxU0tCWDY4eGc3NnllTzliRktaQ2NzN2hKdGVm?=
 =?utf-8?B?Y2VPN08vNllTRzVIZlYrdWtCc3dHZFFCQURVcXdxSWtsL1pvbEpHK3F0VlRu?=
 =?utf-8?B?Y0xPU0ZUVTU5dFM4M2ZoN3FRcEtwLzUzRW5ET1YvVmhQWnRUUFprVlUwdTQ4?=
 =?utf-8?B?dmRkY0YveUcrWlcycXQvY1BlazFwT1ZSOXRML3VYSUJLYmdIeEloTnVjMDAv?=
 =?utf-8?B?dUw5QmMxZi90WXl1SmlxdC9HUm9kcVlLMU5YdXV3MWY2U0tjdW9aajU2ZWIw?=
 =?utf-8?B?RStSUFlMbkhtaXVsL1JOSzJacGJPZVp0V294b1daeHNnVU5kMmxKYlJMSUVh?=
 =?utf-8?B?UU1Md2c4MWZ4YVZzZ1Y5WkFzRlJJVkQ1UDBjSUVLaHhuM2krQ0FndzQxc1Yr?=
 =?utf-8?B?dWE3dnhmTWUyWGdLMG12U2xjcW9kNGJCYkppbmVzVUtLZmlaamZKMkxyNjVO?=
 =?utf-8?B?S1hzUllZNlFxMzBrc1VWQUUranIwbGNqSnJjcHVJZHNnYWZEL2V6bGVPZlNz?=
 =?utf-8?B?TDNCa2ZtN2l6TXZlTXI2ME9Ya2h3eWN5cmovMWtjMGwwRExuQUhtbmw3MzFp?=
 =?utf-8?B?M2J4VjI0QUN1Znd4UW1iNVZ0WnRUT0kxeXNjUllRYTRoWngrdXNZZ2czMVFz?=
 =?utf-8?B?by82TDhWRGt5cmdOZzJVYXNyajRYL3RRZG5sNWpic1RGMGlib2xOOFVpRWhn?=
 =?utf-8?B?L1FDK2lMNGF2ZVFPQ3pHWlVaN2dWMUQrZytlcHlyQ29nanNJVWlabXB6NXNC?=
 =?utf-8?B?dHN2cENRNG93NmY0WnZOK2ZiekF1VXYzcHdaVTIzdit0RStyMG1zeFRJR0pj?=
 =?utf-8?B?S3JaS0FRWVNYTXhjTGxTZi9zWlhUTExOaWxkSC9tZmptV3Z3dWJnOTBpcGxE?=
 =?utf-8?B?OC9pNk5FeHlIR3YwUXBWNkRNSFRBOTB4UWE3YVJlT0lWZW5ZRUlsWldWOTNz?=
 =?utf-8?B?WXVCN3dvN1cwa3p3U28wU3h1VjM0WjFOWTc1djZYeFpqbGcrdTZVTHV1TFg1?=
 =?utf-8?B?Q21LWEZhSW95eU5oa1JIV3ZJVGNFSjJlcWdpQ0R6UGgwTmtsU3p0WkVrdzFI?=
 =?utf-8?B?cFV6a0ZCZ1Rja1NPdWdTcEhpK3dTeTExU0F6MGJBRGs5Y2RRaVl1QkJ2OWd2?=
 =?utf-8?B?YXlnTDRPUVlKL0Rjb3lhTnI1ZGdHa1FVSTYrY1k3eHJ4OFFHNWJRN0hCNE9u?=
 =?utf-8?B?MjNoUjlEMjMwWXVSQ0szN3lNQ25OU1pxbzdGUjZBR3NLRHc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(7416014)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2024 18:11:18.5469
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: abfd35fc-4d1a-4bcb-7042-08dd05a0e71b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000009D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9254

On Fri, 15 Nov 2024 07:38:10 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.118 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 17 Nov 2024 06:37:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.118-rc1.gz
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

Linux version:	6.1.118-rc1-gb9e54d0ed258
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
