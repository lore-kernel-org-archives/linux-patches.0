Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2089.outbound.protection.outlook.com [40.107.223.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6979173336
	for <patches@lists.linux.dev>; Wed,  3 Jul 2024 13:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720013244; cv=fail; b=hi3S2tN5krxJs6JFjlxEL075CHzHO9S36q99mN2/kLLjyDsgFsqp628mUFgjNDJCO1yIaqgLd+6oK7EETsKEgX8SIAquPAnwVvdv1GTzDM6JSLbj/Yd2txm3K2NIUGDryId9JRIJ6UHDpm7F1U5RxDtfVYXVWqhi17d1WeN8eyE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720013244; c=relaxed/simple;
	bh=8NvWYVZJJQitZM9LaanIE1Ex0OehJdEm1SCFPr/YPVY=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=s2BCz11mA/3gTXexkBCwP0imeS7HsJLMFt0GLHltLDRETgYn7qnTxOnrEKOxiW9yxwQubvTZab0yrq8/DXbMfC7iCuhFt9lMssomFA2A5Xjl0JjsiqL8EH5MbhYDf4yagjq+W230M8J7BSghSieinNzk4Q18yjj5/J3V6boyd/k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=TpgH6gDr; arc=fail smtp.client-ip=40.107.223.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="TpgH6gDr"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cLTb2XOADQmsWskelSxGvR79lLuK0ryyMVz+d0gde+cVPdxR9BmUshmLsCWG9kKw1fQZd5/wJS2nCUpa0fs17hP6Gz+2RRYPECmGbGQGZ5FkhPdSr9KDR1CLf7Rl/X8VQUm7VrlUhSI5r9xrLYRuPbwZXpU2dD4YZoq0HLdEH4k0UgZFRPiwyUat06B3LgQszIHBtZxr04CSe3YPnHtrUMjnlGBRUPB8/z/dIcEr+AQjg3lCWgdKqLl4Sp6jGj3tU0OSe1LpdaMBXvtTlrbuNQcIZubDpntDt8pmmK8CfYNMVFFGVWkEp6q3wAkhSh9p2LVAO1nFc2V9itKeSaGgUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r80PCs3Bor7U5jDGvGZd0SHlyYMU7FwXUvtOe2ZLFvY=;
 b=R8DO3hw47a73e24uLOx0yeTg3MSFo6X9A6Qh9/VydY3r9w5kqPao7ZDD3QNxt1ara6RbndGLdAaJX7sIthavpkUmyJP9VZRipa+7yO+AcMHyfqSjs0wQB10xGbJmSCgDtJHbABCvksIJBKHsKZIITH2xYxbKHLxCPnKwbxFqD+rcTUWNUkRALnhka1Y0MrfLqxyB7Fc9mK54h635iVCWHrcspW94bNdW3fQPc7HoDDb1A6t4XRJVEFxfq1RtzFMEFgjqsEyuO0QN1SfZjBQpZ0Zt8XMpcizQxrrohyTu6Ez2Rw9WCREIOwsZ4FJxv5vZcPK/QqDK0ttw3nTTNLbpXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r80PCs3Bor7U5jDGvGZd0SHlyYMU7FwXUvtOe2ZLFvY=;
 b=TpgH6gDrZNSn23wrdI4tzY1I0jhF527d2krD0guHx/n6rL3FIWyomiZzgrS8J004hhErNj1BcbY6FD19qs2uBrvFPZlbnfzOBu08oZWIQ1vZ+X4Bxe+m6se2DSaKroz2/HnbwDwMXAHF5mJ+7cjKLacyUNBSEpMrGaZOrcVVdKG+PQG1YBqaPQJHan2+hztw/zWFesozzBlf1jEv9FdHA4CWCVgFUf+fwXHm4Fe6c3L3R/1lhkb7l5TPF86xHDS2iSSLCCOIaspsykkzWDq/JNbBAtDgoGCsmz+NTGTBbusel/pl2TuxOLkOgUruiAZi+vxTNhmUvi60REHCqfXKCw==
Received: from MN2PR06CA0024.namprd06.prod.outlook.com (2603:10b6:208:23d::29)
 by IA0PR12MB8973.namprd12.prod.outlook.com (2603:10b6:208:48e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7719.29; Wed, 3 Jul
 2024 13:27:19 +0000
Received: from BL02EPF0001A0FE.namprd03.prod.outlook.com
 (2603:10b6:208:23d:cafe::d7) by MN2PR06CA0024.outlook.office365.com
 (2603:10b6:208:23d::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.25 via Frontend
 Transport; Wed, 3 Jul 2024 13:27:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BL02EPF0001A0FE.mail.protection.outlook.com (10.167.242.105) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7741.18 via Frontend Transport; Wed, 3 Jul 2024 13:27:19 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 3 Jul 2024
 06:27:07 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Wed, 3 Jul 2024 06:27:06 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Wed, 3 Jul 2024 06:27:06 -0700
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
Subject: Re: [PATCH 5.4 000/189] 5.4.279-rc1 review
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <b95b57ee-4f94-4b3e-8245-a7f09ea4f721@drhqmail201.nvidia.com>
Date: Wed, 3 Jul 2024 06:27:06 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A0FE:EE_|IA0PR12MB8973:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d0684fd-05ca-4c02-fca8-08dc9b63dd06
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eVk2ZjVmNU1NNjJFY2FDdVdsbWVuU01UTlRSSFF6VUhxVWlDZXU2MGF1cmJj?=
 =?utf-8?B?T24xeEUwNnNWQktpcDczNVZSOWg1UXFOUmthcGVDbjJaYUVJNEtrN3Z0Mmdi?=
 =?utf-8?B?alZzQlhoWWpFQm0yU1dMeHpwbEI5S2tnbUtYM3ZRNktFNlJVVTVGZjNQSlp4?=
 =?utf-8?B?QzFOQWQwblh5djBMNWlqdnlsMFV6eHRhZFFkbUplUFB2WGJFcFcyWCtSbHVB?=
 =?utf-8?B?MlQ5WlRPaENVMkQzU2NTUW9XKzZtc2djWERvemhqS1VReG5hbEpSdVRsYk9U?=
 =?utf-8?B?UUVVZWM1eXhHOHZIOHhVd1d5cmNQdEphTGp0WFVSbzl1R1JjTDZaQitEd0Vl?=
 =?utf-8?B?b3JlOGJPU0pIbVJUYmNVQk91R3JYakZwOHBGV2RCR1dJdXM2VnlCMU9aeldO?=
 =?utf-8?B?bnJiREszSWFESmdURWhJK0t5S0hyRmNGODl0L3RLR2VHQUJjbFNMRExlV3c2?=
 =?utf-8?B?cjBFSHV5aHdKM3lOR3pMOWVROEEzNTBnVTZwUFAyN0lHMmdIMDZsaG9tOXhn?=
 =?utf-8?B?Z09TUzM3RkxJdmFYWWwzYTlHNzkydkZPV1hkU21zeVkzcGp3UnU4bktCNk8x?=
 =?utf-8?B?ZWd4b2NsdkNubzVoSzVtQWdtR25Vd2EwdGdYRGZjK241Mk0vWmROdjI1Tm1a?=
 =?utf-8?B?WmZPVzhiOGNDbjRWTXlQL0JrUGdPV2ExSy9hNEszaTJybXJMbHdqS3N2VHFj?=
 =?utf-8?B?UmhKblVlY0ppWnpsYlBrQXpIZk9FTDExMTRhYXZTSGZ5UXpoaEwzVFBpTTZq?=
 =?utf-8?B?RjNRRXBlVTdaUlduVEZyL0tycWY0SkN2WjdjdTl2UEdiMkt0WllkK3JMNDhJ?=
 =?utf-8?B?cVpMOURiYXdtNEw4RnFoeitPTCtlMW1EZUJoclNwZWM3MlA4d1o4QkhGSjAx?=
 =?utf-8?B?amRpVUx1azlUdW5xdDJyL1pMTWpnNmNMNkxPZU1lM2taeU9aN1Z1KzRPSm9R?=
 =?utf-8?B?TEVOalpueVFWcTJxRVJzWVFLSHRvdDdqam1JYVhTVWMrZGFLWDlGaUlYRGRG?=
 =?utf-8?B?ZHBsTzRlOE5rN2U5ZDVUTkJkMExCY1RqVElDdHRYVEF5SkNaeTBLWmRRZUNw?=
 =?utf-8?B?eUtvd0xDd3lwWDE3Q3VjUUFjRENtd21Mc3BNdjVIVzRybjVUdTUrOFJmUHRq?=
 =?utf-8?B?ZEJRMlozQUFMYk5RV2RqMzFSTTJHbEE0bFRtZlE0eUZGUTBDMjBCaDkvcU9m?=
 =?utf-8?B?Y0RzWU52YUllOUFsODc5ZDdJNFRqdXZRL0dsSGR1d0dXL0RSZ0U4eWQwSytp?=
 =?utf-8?B?WWEzSHYrNHY4WGFlZ1U0amI5MDQ2Y2NDMnhTMDA2eHpwUHJzTGN1RGl0MDJ2?=
 =?utf-8?B?d1lDMkZLN3ZCZndnWDcydTdaRnYzYUdvelE0ZGxwdnRMU2JTWTJYME5YUi9D?=
 =?utf-8?B?ZERoWGlxSVVweGVmUmdlVm0wdWhvTWMyWWVKcGhpK1Qzbm5NNTZOS21KSlRS?=
 =?utf-8?B?MnpRZys2blc2QmRNTURrRjBFaTlxWmtWZkhkZnN0NTdKQ1F1Zmc5a0w2YlBw?=
 =?utf-8?B?ampSb3NZNWtHc0lvSCtLMjhMbjhFa0xzREVMNEF6emh5dk5GaUdjT0dPcUdz?=
 =?utf-8?B?TGRLRm1xM0s2eFNJZS9GSWI1RFJIcFh6T0dUdjErTXV5L2NRand6MXBxQ3hy?=
 =?utf-8?B?OEhMdER3ZDA4SUJEUkYrMmFaK2E2dXRyeXJlY1B5K1kyRGF6OW1rQ0ZIejI4?=
 =?utf-8?B?NFNkUDN4b09DV0YzU2g3OVdNMlZVaXU5NjhXUEx3K1dVTzEwZ3k1dDdoNEQz?=
 =?utf-8?B?bUZQT253SWdJRURGTDU4elZ2ZU9wOFd4UHVlWXRQdTVJS01XclhzQTlvMDE4?=
 =?utf-8?B?cGk3bjgzR3FyUldBTEFNaDhFK0R3TkxFVGVsRXY1RCtxbjQ5Tmdud3RXcnVp?=
 =?utf-8?B?MU5uQlFDbVFsUzdRYjFGcHd4czhXbkVBb0p0TGc2QnJHRHRJdUdXWVRyWklk?=
 =?utf-8?Q?5oTgjgi4m7rzZHNSckUDCuVex9byhufi?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2024 13:27:19.0182
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d0684fd-05ca-4c02-fca8-08dc9b63dd06
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A0FE.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8973

On Wed, 03 Jul 2024 12:37:41 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.279 release.
> There are 189 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 05 Jul 2024 10:28:06 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.279-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    10 builds:	10 pass, 0 fail
    24 boots:	24 pass, 0 fail
    54 tests:	54 pass, 0 fail

Linux version:	5.4.279-rc1-gccd91126c63d
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
