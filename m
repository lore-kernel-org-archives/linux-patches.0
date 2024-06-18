Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2070.outbound.protection.outlook.com [40.107.94.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7EB314D446
	for <patches@lists.linux.dev>; Tue, 18 Jun 2024 21:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718744512; cv=fail; b=ElVK8fqpX/4LI8BsKaB1YFR0OO4b1o2NumzNOHwz+Zn4bg8QJCuHqTzuAmwzUrT3x8QGCVSyT1RpCfLxSa1MxFVt8p+MOCGfOdLZ59yz14pxP65KNAt85MYnmr68/6YAeOiD6UAyif0JPDv49n8RLAoBzJqRmlE9LRtLO+85GG8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718744512; c=relaxed/simple;
	bh=stFDNBtFAFQAf2plAmILi2B0vcOj/ahvJoh6qeCMXZg=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=b/SWS/tCNxiSjWzwpV8JgKdWKYIm7MJy9B08npvLvjcqmGDlaSfwy/grzcc3t978AYrSoUf+/McsvON8jQbViJqJIyqNGvBINDgwRx45lxBji6wqdi3OspbPgsJI57hPHJpDPbhUZMNEqyZo6hhgkNqBxlfDvlYRuHt8adVJgzs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=oV5gLgHv; arc=fail smtp.client-ip=40.107.94.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="oV5gLgHv"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OUPxTBwg5A4rz7FunT1VbvXokt/Psy7FxqHXH39yenTKKrpsm+M1ZJcMFypjcBK180MrlTarwoZdoE6wzF7X6dgEBV3+5QeN8n24bG6lMsHEcQul1zIbAicOAil+uk7+eJ4YncBTfnU8rfui3EdeGjnAfh5QBLWeQ9L6X7Ygo1AmYUPwdg4+st7R9kgBlZc9S9s+P26v7aaiO/yJ4QNushvpgt5e15g6jxDx9BNqfnX5D6hJAA8M1r7XEqo2XnQySfS0QwV7uxpNt2ohnt0AfJEQJnS1XmDSJ7hv8lU2IiI6hSiThxm526b8vRlW9H6X2ImOMcxeZIV96gN1zORD2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0ZPGy7nDEp8typY7dDi6nXbzxj7BeZLEF0piFhnbLxI=;
 b=DpMq5Bdi8xkxkRdaCMdUUvrxYepSwnSoVxcZrEqQuC0GvfEpkGKKghips575al4hVOLUPKNGSsn6d9G2YuCFXVwJWoZjc0tto6eDupn9By54W2UlhLrnLQRg8AXZj46m+YFAuHk0Tap3wVZhZ5cP2BAnSkNR/sFqdIcltMr+Rl8G0TZh/OGRo8nFeEwYYrQM8be0FA0HdL4rD4xPPvYf5GwVKy3Rm4GP2W1ht4ddybddqc36NSylUW6v2xVjTzrCDaL/eBIRDw6gFPTvNnD9Btf02VSf5l5IJfAokBTKJeBjiAkurJSKALA/2zON5ayGqqdtBrVYKLudhOHv+RoFxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0ZPGy7nDEp8typY7dDi6nXbzxj7BeZLEF0piFhnbLxI=;
 b=oV5gLgHvHd/CO/EskfhdmQ/SYlm0O6/fHNOs9I2lOuVIOB6gkdBpnl/6xN7H67/YpgXfuiwRn3rQF4gHtQFocT2f23fCrANKakMB6Z5S5jAaQh9k49jVugtxUVRkkVMBFvt/VlWc5scjhh56i0CcqpEtdTCOIxZXs8eGOboUPPLXkmbWi5umDqDD4G7gkt8rZN3Alx3nr+ZoldtH9oryzZJDwWU9ApnScBWwjshN4bykqHgWQt211Ilgyh9BLzOU4hGB3JKEpkv7eycBA/ayDFs4oTkMXoPyZ2uQCb1lTp4J7+GPUm0Q71BY3qTPs5HMPj5FGSgsCddq3wMCxNqMsQ==
Received: from BY3PR10CA0025.namprd10.prod.outlook.com (2603:10b6:a03:255::30)
 by MW5PR12MB5621.namprd12.prod.outlook.com (2603:10b6:303:193::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.30; Tue, 18 Jun
 2024 21:01:47 +0000
Received: from SJ5PEPF000001F3.namprd05.prod.outlook.com
 (2603:10b6:a03:255:cafe::20) by BY3PR10CA0025.outlook.office365.com
 (2603:10b6:a03:255::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.31 via Frontend
 Transport; Tue, 18 Jun 2024 21:01:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ5PEPF000001F3.mail.protection.outlook.com (10.167.242.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7677.15 via Frontend Transport; Tue, 18 Jun 2024 21:01:47 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 18 Jun
 2024 14:01:27 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 18 Jun
 2024 14:01:26 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Tue, 18 Jun 2024 14:01:26 -0700
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
Subject: Re: [PATCH 5.10 000/770] 5.10.220-rc1 review
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <40613d8f-b325-4a5c-b954-e03a7fc26af4@rnnvmail204.nvidia.com>
Date: Tue, 18 Jun 2024 14:01:26 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F3:EE_|MW5PR12MB5621:EE_
X-MS-Office365-Filtering-Correlation-Id: baddc833-1afb-41e0-0d84-08dc8fd9ddb9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230037|36860700010|376011|7416011|82310400023|1800799021;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WG0xckVEVjZHL29RdEI1eTJ0ZlVZU2txRXo0clVPQUFEV2lxVXJpNDRGVDla?=
 =?utf-8?B?VGxyaGU3VXhnMklkOTIyQUlyNUNhWDVHY3FuU0dMd2lUUDZhYUZwZ0cxeHFN?=
 =?utf-8?B?ZG9YTGg1Z2JZYmsrZE1qZHVOMUJWc2NPNXRQS25zcDVYV2UzZFR0Q3N2TG9v?=
 =?utf-8?B?RlJPVVdiYW9veldsY1VCeFZCSEdwWDg0cHEyVzMwelF3dEtua3BRV2Y5M2hW?=
 =?utf-8?B?TDFzUDk1VnBtR3ZDQzErRGltSGIrTVFKcU95QmJ5OUN0ZzIzb0NCOWs5d2xK?=
 =?utf-8?B?b25FcDhaZUdQbTlkNVAvblFYTVFCb0dqcmhZZ1BkbFB1aXNldDVlZkJrdy9a?=
 =?utf-8?B?TzhjOEFMWVV6S01saEY4b25RekNSZnA1NHFmSDg3TFp4OXRGZkduV1M0N1Vt?=
 =?utf-8?B?c0ZyTEJzb2VTdk1TcnlUOE5CRmlmbHd6M1U1Y3JOVFVVNmZVcUx5RTN4MVU4?=
 =?utf-8?B?aWVXMkthcjBZR0txMlFFd2RGZ0U2THFISXpkcEpQMmVueGg4U3BqdzBqcUhH?=
 =?utf-8?B?MU4wZVErOU5oZzlDYzQyWG14Qkd3a0J0TWJlUU81Nm54RnRLZ3lPS1NtWXBq?=
 =?utf-8?B?VHVDMmxFTGRrQm1XNnlic2RvWlQ3UlBzZC9QcGFIUzdHOGJkTkFTVktNR1VK?=
 =?utf-8?B?bGh0djltQkM1c2ZrVTQvclZtNXJZem1sRkxodVZDT3JzMHpteWNJUTBPM21y?=
 =?utf-8?B?R2JicVhoa1B2bS9DZEk5WUJYOVRJUEI4djJTTndiaXU0RGJxVlhUT0FHM0RD?=
 =?utf-8?B?bWpWMWovSjBCMWMyaFhhcTJibHIxVzJRak03OGg5QW0rUDI2Vmd1RXRHaHhT?=
 =?utf-8?B?T3BCUVhMVGZ2YUtiSTFPTVAzVnJPN05MRkdIelM0SWFpWWNEY1o3NDM4Y3VH?=
 =?utf-8?B?SzhzSzNJYVRneTVWVDcydUZoSzNKSitySS9PR3N1UnVoYk1TSERLcE4wSnhy?=
 =?utf-8?B?M3NOTitvMHhPYlpnNm9EYXRGcEZONWVyVG16TXpYT1hrcW9aOWRUa2VHcWxw?=
 =?utf-8?B?NGpkai9tS1JrY0wrL05ZNlBjMnFyL2JNNmVqbWd3bEtOV0E5ekxQbUxPdW5o?=
 =?utf-8?B?Tk84N2VVSWFvclUvdDBvNyt6VkNTK0pURVlSN3g3bCtISE11L1ltLzdSSXVi?=
 =?utf-8?B?UmxYNDRKYUVNb2g4SzJMa2NCVkFIMisrdFM0Y3VoR3BpSzR4TU90WEZzWnNl?=
 =?utf-8?B?SWtUSkpzLzFmSjVMcWZZcU1NM2tjZ0tGQ1ZhZ3gwWXU4VTVGQW1Lak5Ybytx?=
 =?utf-8?B?SmtTbUtGNHRFVlRmcTVnMjJycmlKR2RKMTkwR2JXSmxId2FKZktJVnc4bi9v?=
 =?utf-8?B?VE13VGloeHN6bVhwYit1UittaHFPYkUxNk5HemlrclBobCtIVi9iUDQxU1dy?=
 =?utf-8?B?R1VEeE9YdUtnL0hDL0FYOGU0RWFUYW1Sa1FEVmFtRW5CcEpLM3F1N1lhOGNm?=
 =?utf-8?B?RE9GM1pwY3pERDVST0YycjR6bVdWeUlFRmRHY3gzSzUyZFBETzNrYWZ4WXB5?=
 =?utf-8?B?ZGN5NDh0SlFWNXFYeDZ5aG04dmx0a0JtMFNFdmttYjdoSWh2eGtQOEd3MEhG?=
 =?utf-8?B?NjFEbmFiQU5vcTBub2h0bjlERnFOdFJMdDJXakdVVCs1VFUvVVR0UjR4WHdC?=
 =?utf-8?B?TWN3dStqd3hJM3hIVk16bDlhelFOa2NEbHpKa1hVb24weE5SRW8wc3pGN01t?=
 =?utf-8?B?dnRRS3ZqWnZuZHd5M3UreUluN2lTU0l3S01hZVFDQ3QxbU5sOUw3U21xU3BB?=
 =?utf-8?B?R3BIdWhKV203ZG0xSDR4c0krUWF1R3ppRzhBMTViczlTa2E2TDhzNVVvK2R2?=
 =?utf-8?B?UXhVQUp3TEJpZmp1YWsyUWZkeE85OFdNeENZSllLNkZndlY1WWRuOEt1NlNV?=
 =?utf-8?B?V05hOVFJWS9zeUp0MFUrd1NNR0hBQUtPV2h4TnBTWEs0SHc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230037)(36860700010)(376011)(7416011)(82310400023)(1800799021);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2024 21:01:47.0179
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: baddc833-1afb-41e0-0d84-08dc8fd9ddb9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5621

On Tue, 18 Jun 2024 14:27:33 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.220 release.
> There are 770 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 20 Jun 2024 12:32:00 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.220-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.10:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    68 tests:	68 pass, 0 fail

Linux version:	5.10.220-rc1-g7927147b02fc
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
