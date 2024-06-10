Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2087.outbound.protection.outlook.com [40.107.94.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A11B813E8AE
	for <patches@lists.linux.dev>; Mon, 10 Jun 2024 15:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718034927; cv=fail; b=bIAoWa+h/hENhYnatXeJ66uB8y/JOZjnyZhVijac0RqVo2GU7uZfeYGTvf9pD3zqYLlx7tefgePEyKU6rtI1MkRu4ZcWzYAQlaNuUfn3lKD07yk/tJBd34/EvTRWLT1OJTfSB6TEqTXZMXXiVrv+MWXEewG3sjF7zMzpGiKNuJM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718034927; c=relaxed/simple;
	bh=nYdt36IHwlLuGBVBEgBa1XWia8RBdE+9mp9W+WRiI74=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=FQqnheHN6RqwRqEDppFuJ7Eruer7nDAFOtJIanEIjrt+cGU6SiSW1KfU4fXN59ptzQKzaG45vnuQYOffJytOKzp66WUlFyy8o8bKbcWtcstYz5DRvhzzg4oTdRTKRAQ3ltmr11iGBoszOtoyq209MQBK4+fSqW09LI0zteolGFc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kJOZ1qeH; arc=fail smtp.client-ip=40.107.94.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kJOZ1qeH"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BYtxUUGsP92qxs9LinOXDiZqPN6VUsqt62NXyszidHsApyPW3IFddgKJCgVyQQ3hv6UldjnbGHFYM3GOwKG5GnMYTz/JRr0w5TKPX8xWEUmyTncEmVfP0dHZpfVEGw4cXJcobWpzsj2m3ukuICUzZG3Sy5QpVjGznX5VNJi/6nP8USxAK7tDEsgy/LKbJ06mOc6rPB9qOkMrI0whyzxHe/qGG2cLsfjFJRMSTR0vPr2tzliE3iag71HriOqted2c7TAJbr8sMPams5EQQe8on3N9OWmgFBj/D2AoaU4hbOyYGWrq70X8evuG8l1KXVzSyjkcI97vm4p4TL+5oBiWVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0dhvEQxcSIk7DG5I41L0ymGAJIvLLroVSIE0eLTF9vY=;
 b=bk0A9Qo2pr5QDtNTapcdl/cFdAlYUiSjoVAWQFL5f0qzjmBct6+1YbgWGpnLv3Q+018EGxdUbsc4unAfu8QoXntzNPf+k5v8y07LjCmjHgE3ajpaXkrN3n0ROFY9NEGJpAzOLbOtU/K+LVV1Ip0v5OcumHS+jZ8if37OWPzk2e6KIZjyYvdF7EBShC3N5iuyv60DQ2jmJjoXI8audBOD/+usE9aTq7ofWlx1lF1dvqViPoAURuJ5guJEhmZxsPQVL9Tb2vBvwdTKxQ9lW0espipoE/NyeBB39KEYWvKXwuqJsI3xHwrb4OvLHkS8s6qksGAXb7N8ItobucO3OkEIcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0dhvEQxcSIk7DG5I41L0ymGAJIvLLroVSIE0eLTF9vY=;
 b=kJOZ1qeHCuBILejEQOhBkO5AGD9VdqeK5tUnpPYYlg1bifzchu2HBvnlCg7jxi64+4W5rTYbrIMhgvZdlvR5BiBnYWeHkOyAWCU/IbzciWoz3NEaF+yQCB5f/XV5EkQ7MN9tfr8Hv1h5cyCyxqD0dLfLV1dihoi7Cz0gFTfyySzUctIPTwuDVvVcez/VVWOOmFAAtoNWClduSKnPO7eLwGqMlrh2bN3LqPfNaAZSUdxX9ODy0x0wW7mC6Evn9JTLJ/a86qo3gbB1I31ObaVwn5krQQX8k6WOhxph35mlRDbUImacwwMnAP1/q56ns6JCqzBMjbQWtUinh0mEYcBZpA==
Received: from DM6PR03CA0041.namprd03.prod.outlook.com (2603:10b6:5:100::18)
 by PH7PR12MB7017.namprd12.prod.outlook.com (2603:10b6:510:1b7::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Mon, 10 Jun
 2024 15:55:20 +0000
Received: from CY4PEPF0000E9D3.namprd03.prod.outlook.com
 (2603:10b6:5:100:cafe::f0) by DM6PR03CA0041.outlook.office365.com
 (2603:10b6:5:100::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7656.25 via Frontend
 Transport; Mon, 10 Jun 2024 15:55:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY4PEPF0000E9D3.mail.protection.outlook.com (10.167.241.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7677.15 via Frontend Transport; Mon, 10 Jun 2024 15:55:19 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 10 Jun
 2024 08:54:58 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 10 Jun
 2024 08:54:58 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Mon, 10 Jun 2024 08:54:57 -0700
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
Subject: Re: [PATCH 6.1 000/470] 6.1.93-rc2 review
In-Reply-To: <20240609113816.092461948@linuxfoundation.org>
References: <20240609113816.092461948@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <785d13ba-8ea2-4e69-a102-43fa2979e7cb@rnnvmail201.nvidia.com>
Date: Mon, 10 Jun 2024 08:54:57 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D3:EE_|PH7PR12MB7017:EE_
X-MS-Office365-Filtering-Correlation-Id: 3fd7a1be-7503-444e-fda2-08dc8965ba8f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|82310400017|1800799015|7416005|376005|36860700004;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?b3J6QXYwdS91Ry9FOXczR1BvVU1yWlQ5QkVPUFhTZTRBMjJXTXFld091cVhH?=
 =?utf-8?B?VEdyRHozcElYUFlESUxJT1lxU3hkelRqcFVhVGZKanpYczVHdlRBalNoOW9z?=
 =?utf-8?B?dlI5T25sajFhc0pJWU1UQ1FabGsrbTBFU2pOVDlERXVYSjhJZlFVdncyY1h5?=
 =?utf-8?B?dWlSenJyUjIyY2JLWXp2eFQycUpEbU5MUXJaVHZHL0FFMmZtamlld3YzY3RK?=
 =?utf-8?B?bXhEVHlReGw3MitkTVAvVHA3Z2FuT0JVNzhnUkdqVUYxTldWWUVqRmc2UE5O?=
 =?utf-8?B?ajJjWjNUb3pSVGg1ZXRJbTdObTRPamhHSE5rRzdhcndUanZERkoyNlFKT21y?=
 =?utf-8?B?c2d0WXRsZStibnd4T0pUL2ZMOUkzcUF6cURqRHpMSlZFUlpOMG1Oc2ZxTzBN?=
 =?utf-8?B?L1pXYmpYRGcycklXdUJDOHcwa1JXUEZPYWxQV0pxaWFPR1dVN3BqRGZJYWht?=
 =?utf-8?B?cnpLOFlHdlM2bjBFWTc1ZkhuUFlDQ3N6am8yaTJzZDZES0JrdHJGelRyQ1Jn?=
 =?utf-8?B?eEV5VHRmRjFlQjRRWWU5N0dqSktFOStGbkp6U1JwMGJ3VHdGb3B0eFNITTlV?=
 =?utf-8?B?S1c3T3k3L2V1NXhaQVpMcDYwOERuRWs1N1gvUnpNMFJ5cFZFNldCbDJlK2Vu?=
 =?utf-8?B?TC92VENPZENhb2pHa1VBeXp6OHJxOVFzOGN0OHhYV05OVElob3pNTzZOUWc3?=
 =?utf-8?B?d2kySGRvT3BidUF2U05ZdGt5YkVrU3R4bnBJdjZlS2N1czBFcHlyMjgvd3h4?=
 =?utf-8?B?NzVtNW1qK2lIdzBWRWQzb2VKRjE2dXlQRUNsOHQ4b2dJRGtZUW5kS3ZoRTlz?=
 =?utf-8?B?YXo4N2oyUVRFTS90c3ROTXhabWNpK3RtQnZKSUw3SHc0MDV2RURkNmIvaC9D?=
 =?utf-8?B?ZnJmemZSWUNqWlVNWlVWdkc3ZUwzWTkvQlhlWW5lVTFZam03cndBMHJvKytw?=
 =?utf-8?B?VG5XS0pIWnVldXBqR2t4SXJkNHh5ZjV0ZlcvM2NwQ1VHMVR1ZmFJSVVnOFhj?=
 =?utf-8?B?TUlnay84MWNEL1pheWdFalJZZ2hVWE9yNmlkM3RJR3NKUUs3S2NyNVlXY2JV?=
 =?utf-8?B?Umg4ell6UjE0Q3VxeDloMGt1ZHRXcThCNWNwL0V3Sk14UWwzU0lId0RMV25N?=
 =?utf-8?B?UUszR2RaYU5CVTdLKytuRUl1d3FnYmF2anc1RzV6RlRpbkxMaUhyZkN6NFRM?=
 =?utf-8?B?ajA3TUtYWk9vVjBLVU5ZY1pGbHN5OGYvdUI1czhPZ0VqOHpyNUR0ekViQ0JY?=
 =?utf-8?B?QnJqcEVwdTNmUnIxWElRaVpsakdrajViRCtJd1MwUDQxNFpXMjBUZUFuUEdh?=
 =?utf-8?B?WEVEVUdtcWZxWGJoTVlOOHpZNEhyYTJLODU0Z3lCSmNWNml4MHBLZVBmK3NO?=
 =?utf-8?B?cU5WM3JpRWJUZTNhQU5PbURvZzU3aWVtQUxKMnZHUjlpZTlZc0NMNHNXUml0?=
 =?utf-8?B?NjgrZW5EVzk4TVF0WnVBcWM0ZnE4d0hDTlpjckhZZVRqU2poUmRFNWd3Znly?=
 =?utf-8?B?VzJHeTk2czhkU1hRWDk3eDV2OEM2R2tKVW9QZ0hmWVhVbFdGWUw2b2IwNmtr?=
 =?utf-8?B?YTV4c2dZMjlkUHVjRysydVNqYjRlVGEzRXBDNXhFZk1BbHNwcFlKWC9XMWhV?=
 =?utf-8?B?ai81RFFlcEsyVWFMNU45WjhBTDJKKzc0ZkpydUR2VHoralJMR1F5dmpGcC9C?=
 =?utf-8?B?b05XU0h1QTlZWnRteEdvS1dabkluR3NFamdpbWdYQUhXM2lJdTg0VnN4ZnQz?=
 =?utf-8?B?Y2ZVMlZYQjkrb01VZU4xVk1jMHJob2lHQTVRcHBwRk5EcGNLdjZTZzRobVFD?=
 =?utf-8?B?MTBPMm9zNWxueHlFNmZQaXUwNElsencvYXFoQ0dzWFJwUHNCS3JYUTE4TXk3?=
 =?utf-8?B?S1VncFlWVlRQWkRudzc1UE1vWW9GYm4xcDJueEFLVy92NFE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(82310400017)(1800799015)(7416005)(376005)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2024 15:55:19.2906
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fd7a1be-7503-444e-fda2-08dc8965ba8f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9D3.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7017

On Sun, 09 Jun 2024 13:41:02 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.93 release.
> There are 470 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 11 Jun 2024 11:36:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.93-rc2.gz
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
    102 tests:	102 pass, 0 fail

Linux version:	6.1.93-rc2-gbd8637d23a9e
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
