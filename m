Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2073.outbound.protection.outlook.com [40.107.236.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B24418BC1E
	for <patches@lists.linux.dev>; Fri, 22 Nov 2024 08:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732262822; cv=fail; b=jf/SYaWYqBOtrEhG34eVzYkJjWYKL5HK2WMMVcT6XZ73uKfVf4NyK824hrkLc+Xmpvm/vXQC4yUhLxFJiIQ0rHcQBb6q7+83yw98qFS1OBmjjVehdE5oUJahNYsrBD5Ug4kYeQpCntv+wEnU1x1jhDgBNtNGQPL/yc9RbTRnapo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732262822; c=relaxed/simple;
	bh=ERJnHrEivan+3bdtCK30fcRjAKL6mRWZLZ3zVbTvb+U=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=JGhvTysSCdRvIFx9DZotx3V1YxEYbWYTzRmebTyfPFH7qOvlR4jz2bq+GsC2vldK/Upzq5GRRsq3+ldP23Rzq0P7lOtPq+8KHR3NvN3ceFy+YgngZ5ajDpZvPxVi5vBVpB42XMxY0xw2/6S2vIX5p4Mdb5a7j6DrorVx5clxXOM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=edvwVN81; arc=fail smtp.client-ip=40.107.236.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="edvwVN81"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q/+JUyui4VpBYjgrpCLy6nlnChIZB7e41oIiaihZZx5rGN4UU6ltwXhs8wj2+ZpJMreAihKGPp4QRhZuWN2+maA9iQWQW0Vk3qIrWRhtW3eZGF8PnjJONScpyjLJWDkSCYkNbbKaxX0XJSB7I/7cIkxVkx+Uf0KK776d//z6GRIuENR7P65Df9xqYbPQwxJp8XCg850riditwFuhhH42clXFQSE1SJSCoDlkxuX73QB56NVKt/KRB1OODvgLumfPPiZlz1gJ1DxEekh7oZmgkUsINxbRnkS7BAm7mr8oreyBme1IHF7R98BshQs+EdDDPAumM0C4JV+XgjTyKj/B7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h4VYLIb2sQjWaIWIrQXQgRnpBfqXxrx2zByIGKlK9Fs=;
 b=HxFOgli4z955dALKZNOX5e4r3WCkdqU9FdDZRSfZ0mIKUcRxGxyn5D2WimwVEqTxQN5sjeZ8wh1PdDp9H7fJB20sDTHNqpvHjt6jAbt3/Judb29TWJdy6BCLOCVbP83mRyzJV8JyUvYrr6Bdml7aW0/CpzYOTPDrYece508FP3OmvD/b8BnLlkqvbu/E+AFmxzrp5uxQwduLMfq4Gw8gA1X2q2Qy5U4uXs1COyKa4+be2ivzJj5/MgFr6ayuAoKdM2q9FYpF1Y4YlqzKXtlBv4UisD3OF6nxqPa+y6lJrTlV2ePJaEqmH6CdYpkGNVn0u1PZEQPoGmbv5MBEbHiYcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h4VYLIb2sQjWaIWIrQXQgRnpBfqXxrx2zByIGKlK9Fs=;
 b=edvwVN81tiOISKCR4gDTgN+axMNgHbwlr/IvfNNgKQsdAJqUNFJ4FtgXsxNPHSn88LkHyJqj9IuTF3FiC99xL+9F1cr0/UXjj/goJWxi9xwYNWseC4UBxsGaKw+GzBRf6QOws8U8vjrEW6tr6KF2X0QkmiPnciiCnGMV/CKAOO2LW2RSolaqCLbgwESS6kCSgnTF3alNDWvliKahllvOfiQ0pRBegZZ8KsDq8QmWjNqZH5cmxkdutG4DxXKLLe9yxsW2pV8e8tS1O8xcfkFRzi3Ru5Fan8X4PpO1/LC0qBvWVHPTUgoW2Z8vxPxDDVPr2bgigtL2YPU7Ax3FtuSkzw==
Received: from CH2PR04CA0027.namprd04.prod.outlook.com (2603:10b6:610:52::37)
 by CH2PR12MB4277.namprd12.prod.outlook.com (2603:10b6:610:ae::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.23; Fri, 22 Nov
 2024 08:06:56 +0000
Received: from CH2PEPF0000013B.namprd02.prod.outlook.com
 (2603:10b6:610:52:cafe::fd) by CH2PR04CA0027.outlook.office365.com
 (2603:10b6:610:52::37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.15 via Frontend
 Transport; Fri, 22 Nov 2024 08:06:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CH2PEPF0000013B.mail.protection.outlook.com (10.167.244.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8182.16 via Frontend Transport; Fri, 22 Nov 2024 08:06:55 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 22 Nov
 2024 00:06:44 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Fri, 22 Nov 2024 00:06:44 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Fri, 22 Nov 2024 00:06:44 -0800
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
Subject: Re: [PATCH 6.11 000/107] 6.11.10-rc1 review
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
References: <20241120125629.681745345@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <0ba6eac5-541a-44df-a234-842bbcc433b0@drhqmail201.nvidia.com>
Date: Fri, 22 Nov 2024 00:06:44 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF0000013B:EE_|CH2PR12MB4277:EE_
X-MS-Office365-Filtering-Correlation-Id: 18b603a6-06b3-414a-da17-08dd0acca1c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WDdoZFdUWWFTSHhYakgzOEVCb3FYQ3k5SzZ4bldLS3NlMFJBQmR5YkdTTzBx?=
 =?utf-8?B?NklRUGFOS3FPLzFDcCsxOVdDdnByc243ZUtpN2hzaUNzK0tEd3VPZ1FUQmxL?=
 =?utf-8?B?b3JKUnB2TFB3WWhzTVlrL3YyZnBaSmZ2RzZVampnQUhQN1l6dHlLMFdCTk5i?=
 =?utf-8?B?aTdLZ2RQWUV4aXlrWXFBQVlrK294bFg1SjNWd1FubXNmSW04TnhrYW8wY2V5?=
 =?utf-8?B?R1g2N1FkazgyZCsyOGFwR0phSTFOdzlqM0w1UHF6dmM1WjBuclNYbTFJeGhn?=
 =?utf-8?B?UmUzMWJsMzYyNUpLeGxrcXRQRG9DMzR2ZWc1NUxOdzhCSEtwaGEwVDBjdWJl?=
 =?utf-8?B?VEdjcWZESTFRRlhkWjkyWTcwOVJMMTRUMEJNRWJHNVRxYUIxWU5uR3JTZXUw?=
 =?utf-8?B?aUtvVitLclNmTVcxTVRVeWpuU3hNdFpEOWN5UjNvNlpabjRJdFRTUDZOZHh5?=
 =?utf-8?B?blI5ckRCaVJBVktYQkFxRm1SdnhXWnlyZWovaHdhVFdVR2lmYjA4MW9vWGhy?=
 =?utf-8?B?N2NtSXVvVFBBNDdCNW1qc2dwdThIaVNGaFFXVkZQNVdTaGZJamVwbTMzZnlu?=
 =?utf-8?B?SFQxRTBCMkQzbnQ2aVZjempBRmFkWnhCSTZRTFJkcEJWT3l1NUFVT0xMVnFO?=
 =?utf-8?B?MDFnNG1QeGpBL25CR2FMQ281Njh3eUEvc1NiTkcxMXRXRk1CUXVXdFVFSGpG?=
 =?utf-8?B?T0JUMUZ1aVZtQkpvOHB4TFYrRVdQVlpFRnJYVzBZNkJhWi9SZFVwMm1CRUIr?=
 =?utf-8?B?TUpsUDJIWVVKbVRxSHlLNmFzWmdhNExaYWdzRTZiOXlFQU5RMUdLeFFXVk5z?=
 =?utf-8?B?eUJBaGhSdm9mTkFJN3VFdEw3L29hZGRIUVJ5QVZjUnUrYlMrMndOZU5Eek16?=
 =?utf-8?B?a1hlT1F5VTVNWFltMFBSRWRZdElSc1lKaWVCRGlBeWtPYVNZOWM5NUkrUGZa?=
 =?utf-8?B?aENwMUlmYThqUzQ5OFZ2K2VIQk5WM0tkcVJpTlJMbnZ4SGprdXVEeXpleDFr?=
 =?utf-8?B?Nmhmc3FyTk9YYWRUQ0hQODJTcWVKazJyc1YyYTlpUlNQZjhDMW5iY1JPL3lI?=
 =?utf-8?B?M3VUS1VJQW9QbkE3NERFS2dJT0pHbUt1SkdsWUNJN25tWFErM0lNVjdKVFF2?=
 =?utf-8?B?ZGs4WnFVK0t1NEYyN1VkRWxMMkNTRGdzclJrSnFUNHQwbzdXTTlQV3c4RUJK?=
 =?utf-8?B?SVpUeVhQcmI1aSs1MlVOdjR6SmVLVTRLMm1HR1c5VEVUaVVDVmhnOFZvbE5X?=
 =?utf-8?B?b0xBRUJhS3JLQkxqU0ZMM1lTYVNHZ3E1b0JLczlyVXgyRWNVb3VnS2s0UHI4?=
 =?utf-8?B?SGdqcGYzVkJCK2V3RWRoMWZVN0x3U0hRVDFzMlh5c2tjVmttVm95VGU3YjhJ?=
 =?utf-8?B?MTRBREhIM1pnUm5OWmRSR3dGY0w3V0RVUXl1U1B6NWQzZDV2QlNEcS9nRUto?=
 =?utf-8?B?aUd5UXFhOTJwK21NZFg1eFdQMURhVHM3Qk9wS3l6d3lUSUdJUGJnUm1tTDU5?=
 =?utf-8?B?MWVOMnZkWDBtSWZNRjRkTlNiRy9nVlBrL3oybDNTQW52dlBZQXFhTGgxb290?=
 =?utf-8?B?NzV2MDFyQUl2OXA3MmtPclQ1bFNwOWlTdmoxazIxbm1VKzFZNW4xMEo2QmY5?=
 =?utf-8?B?aExUN2FCOGhUSThVYXJ4Y1VIMC9qOVRBVkJlc1RjalQ4QWVSZU52SGMyOGNK?=
 =?utf-8?B?OUJ4alpyMkNIUlZCWTdEYWZxTURlUjdtRFBHWnM0RmF4NmtoS0lGMFZ6cHda?=
 =?utf-8?B?S0x6bFV6Uzk0NFZkcmlpU0wxU0JOYlhoVk02WTQxVmNZbzk5eTR0NExFbzVr?=
 =?utf-8?B?R2hOT3lCUDZQQzArUHd4VUpjVTF1dlNQTU5jK3RrV3JtNW0rRkxMeVRqeHho?=
 =?utf-8?B?cWIra3dCTUVYc2FWdkhDR3BtVnhzZGVaNUN0dzlsZDVYZEE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2024 08:06:55.8554
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 18b603a6-06b3-414a-da17-08dd0acca1c4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000013B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4277

On Wed, 20 Nov 2024 13:55:35 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.11.10 release.
> There are 107 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 22 Nov 2024 12:56:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.11.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.11.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.11:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    107 tests:	107 pass, 0 fail

Linux version:	6.11.10-rc1-gc9b39c48bf4a
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
