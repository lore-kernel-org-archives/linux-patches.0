Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2078.outbound.protection.outlook.com [40.107.93.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D4051E885C
	for <patches@lists.linux.dev>; Tue,  7 Jan 2025 12:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736253868; cv=fail; b=QynHQYmLDRePN/F41QlCw77aBcL2H1QBMzZC87YUAGthynRULDjbmlOT+hNsVSRM6ukgguoHrreCnBcSacrSkpceo6+wc7tkXWrOpd6AW7ElULPoPJx7SltjY/XWupi0EYDFW21Y3DnC9zdASGryDVQE8yPT/939j943i6vWBx8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736253868; c=relaxed/simple;
	bh=prV6LH2ZK1VDScRk/v0dL4kxaEgMTId0Ya7YgPncels=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=sYG4/ik2ri6fVnLFCgklsCVv5/tA7wnihbQWzi22wMIRSmGnMLuvwemzPa6NztG9v4DssWeTKsPQtuHdst+AnOhSQUrSex2L9+eg/UevbC6/fHGUcK3XcSnNO663H0mgKYKU02bKO2aRsKCWBpc1C/5HFaj6lwMoZbkuKE+UUJ4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=K+ev5hki; arc=fail smtp.client-ip=40.107.93.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="K+ev5hki"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kDe0u+QHfa8Lf/qXqHUbkpfGF0hWiPTDosno2tBU1KDgrZKO2DRNjQEmwnDejkQjHgaezEFQD/rEa/owOWsU1A6plfNhkb1UVgIeXB4Rknv30lxsmpPermAs98QH9fyNygO2UmiHpllW+ccOb4qSFDVho4VQ8VCirn69+bwvZuWQB+fkz9xYhaCTPI3FGTbPP9WPOhekhnI0r51ArGN7H+JsFJxll1UUU62w47bP5txQgEZixo6/7mTKVj3RNqoHxdHY4LYoqEKr3mwMbWGBta9fIdKOaZHaecXJOc/c9kNsB0Z++xd9ANqmu6yPbK1j78U9vs8TUgfjpOPeS3uEDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1dUICC8E32NJuVJX5u4f8k2YJ91DhzbcJaD3/rvtj1o=;
 b=yLFpYySrPAG9Qs3hPmmdI7YYTXOf9Y+gymYM2NhvZ2oHtT72vCV9GEDSpIfJ0kJC97Xx6hKOLyA/Cix7/0c/GKhfNE1AcNzaJBRA8YnebSMAXQk9v27z2k1aX3eqLqQwfGrf8shOg+gePytEhKShiOIhdhmsx9GM1/Q/UYavf4X9HjsIB847W1z9M1lf8XU047lsMYHYISnbnx19x3+fH5gBCK7q58Tl7LswHhN0D2DTQPzfE0vPwqY/Mp8+3mBIYKswKYBVqC1JC3/rZcOQM/tR+KZT6A3D8uYOlCTL5qbdZaMkKJkG27OCLqmvP1ZhpNnMeDQtOpbM67qJ0Kk8pQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1dUICC8E32NJuVJX5u4f8k2YJ91DhzbcJaD3/rvtj1o=;
 b=K+ev5hkisJqwknNphtNbiVe92wFcaaNgXPBz6rd++cH7fMkB7rJDDfuH0fuldgq96+JQvQ7+oiixKAXcJNb+nHFRHJtuvtg49LX16aGEVRvqMjEr7PH4kq4jFOPSygZna0CtCfLnHDRHEdooLvZjdZUlNiWuJSKZWVv2XKztAO7KYeOMMZ327VbyRzDCM7ITrlfg5b25SCsal1toX5eCMSLvd+l7S7h1JhviDaC6CaglDyhas+nJmR79wWjsWcKLzCLC69uJ2iJ1EiyXPjzo7IBjbKUFFIzet00zo2TabtfL1WtTlzz4VyWFc4sNcvn8orRmDBHOIlAU8PFDY/ROHw==
Received: from DM6PR08CA0053.namprd08.prod.outlook.com (2603:10b6:5:1e0::27)
 by CYYPR12MB8922.namprd12.prod.outlook.com (2603:10b6:930:b8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.17; Tue, 7 Jan
 2025 12:44:19 +0000
Received: from CY4PEPF0000EE3F.namprd03.prod.outlook.com
 (2603:10b6:5:1e0:cafe::57) by DM6PR08CA0053.outlook.office365.com
 (2603:10b6:5:1e0::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8314.17 via Frontend Transport; Tue,
 7 Jan 2025 12:44:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CY4PEPF0000EE3F.mail.protection.outlook.com (10.167.242.17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8335.7 via Frontend Transport; Tue, 7 Jan 2025 12:44:19 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 7 Jan 2025
 04:44:12 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Tue, 7 Jan 2025 04:44:12 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Tue, 7 Jan 2025 04:44:12 -0800
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
Subject: Re: [PATCH 5.15 000/168] 5.15.176-rc1 review
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <80d19a2a-6de0-4b1a-b2c8-9fdf47dd4fc5@drhqmail203.nvidia.com>
Date: Tue, 7 Jan 2025 04:44:12 -0800
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE3F:EE_|CYYPR12MB8922:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a31247f-293f-477d-e5fc-08dd2f190125
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UFRBc0hpdjlTd3JHWnhEdk5BYW0vOCs4TXFDSHdtRTlSSzc3eEFKWk1Ddjls?=
 =?utf-8?B?RndZMUhWYllSNmpHeTdIV0owdlNWNS8wK1NKck0rRVJyaE10MW16Y2ovM1Ux?=
 =?utf-8?B?UkcvSy8wZlZ6OUhpaldVZ3QvY3QySldjcjFPTnZ0RW16UDRxd2I1RXU0UjRL?=
 =?utf-8?B?ZndmSWZ6QWtXR2dMVzNLSms1Tm9FblFqREFyOVNGZEtmY1pLWHNuc0NCUUFC?=
 =?utf-8?B?NmN5eFBOZGV2WnJUd2pFY2NlblRWaG5LVnc1YnVScHhSS2ZZSGpZMC9kZU5k?=
 =?utf-8?B?Ty9iNFZIamFITFEyZHpoa3hyNkZWUlRVQmVBOUtCUXJ5ZDNnSHN3VXQ1bzF0?=
 =?utf-8?B?UklEWHlibzR6Y3dsQktpRkFOMmVhN3U4dGxQSzV1TGdlckxzMXdDVEt0SlYv?=
 =?utf-8?B?NDZxa2xSNXhuakhVUUw5OVlYc0RnV3o4NFpDT2dGMUl5azBIR2dKajN4UEsw?=
 =?utf-8?B?WUdjcURQQlJ5Rkp1emhsb2tabmtKREEvMXZrbXE0WVJTTDVQZ0l1VTRFRmpo?=
 =?utf-8?B?UklISzY3MFpFSG5iY1VJU0pEUExHMEZhM05xcHQ0bzROOVRJV3o0WVBKY0hn?=
 =?utf-8?B?akFrQkRLU1dGVUs1SGE2azMxd2kwTkd1VThlZ21zdFVNdFRsL1o1RTlEYVNy?=
 =?utf-8?B?WXR3Wm5naHFDSEhWRyt4Szh4bW1Cek9yMDRtbzlWallUZ2h0UmpwOHpDOFlH?=
 =?utf-8?B?N3VrelAxdTdyZlkwRXJnRTVhalM5T2QrcjNCcDlEaHpkSmI2YXpVNTk1dUVK?=
 =?utf-8?B?cmkzQlJrL29pUVVoU09GZlNaVkZMRHRiZE1yOTlPekdTWVVIS04wbEpYbU4v?=
 =?utf-8?B?MEZhcWhUbUVEZVcyQWFHM25MRndhcnAwRURrazdlWHBsaEdsTWsySkE4Nmd6?=
 =?utf-8?B?SWk1SWpFaGJOTlViQzNTUTRHMk1kRTB2N1lYT2hBMHNSZGRkR08rdHZTem94?=
 =?utf-8?B?VmRuTFlmY3ZhZ2ErZE1Fd2ZrdVZLQm5HUThPTjMzRmRFSDlaRTQ5Uktjbk51?=
 =?utf-8?B?WVJMMVU4dVJWd2NTcHFLbW4wcmZFQ0lzMUNtZ1ExeWtIdnJFd2dEelU1RlJL?=
 =?utf-8?B?aXJYUnM3dCs2aWxkdVZ6NG9ENmNJQXphWVJKR0xEaUs1NU9TYldaOHZkaVF2?=
 =?utf-8?B?MUliNTdycHBhUmFDZDIwTWxQMnQxSS9LZG5ac2lsS1o3ZTB2cDk3R05LM2gw?=
 =?utf-8?B?VUVXaHJVS1JxandmZ2pPTjZzNHFDYW4ydHNFK1NOSzlnVG9MakZwOC95OVFj?=
 =?utf-8?B?aEdKM200bld1M2d0NnNlUmV2QjZ5aDA4QkVNSEhEY2xGckVBNE1QcXE3akJo?=
 =?utf-8?B?YlNieW5oRU9sS0JXSnNpdWZVUHpoUEtBZWNwTnVwK3UrK3ZobmZIdTEwZ05t?=
 =?utf-8?B?UHcyc2xUNTJMK1JiWGZoYWljdklPL0N4VVh0cEs2d3dPUXM0RFJsRVFiTFdB?=
 =?utf-8?B?VVNacmhaRHJjNDF2VUl4dzBJTEc1Y1JGdEkwd3g4dmVuejVjZXI5SjdIcjVM?=
 =?utf-8?B?aHdhQkN3MjU4MDhiZnlNamlSaUJrY1ZKajJnNncwT29pNEVtM1JsTHZLV2dE?=
 =?utf-8?B?U0RYQlh4WjBnNDZTVjJFeUdxMlR1RDRvbUpYSkd4MFZqOU9KZ2tYajFKZlFZ?=
 =?utf-8?B?TVByQ1ZyNk1qTWxISkNFN3FKOUtQdUN6RWNYM2tQMVZ6ZjBOTjBXa0Joc2R4?=
 =?utf-8?B?QUlrdEo0OUIxSEl0OThjd3ZxckY4bmZydi9WVHJGRksrYUFreGYvQWliQlZB?=
 =?utf-8?B?cmhmSldlRyswY2ZpdlhDdkVjRmo2VXFLU25WbjNlV3U5TFNTSXJidElWaElF?=
 =?utf-8?B?eGhJRElseFRGMjVCNHZWMmxsNkUxVUFMRGxydENFWW03Nm1aU29WdkViZmlO?=
 =?utf-8?B?UU0zcmRudWQxazRWbnl4ME9sNFlxemN1aWdGNk56TEptSTVpMTVZK1FPSlZv?=
 =?utf-8?B?NDZ5eWpXU2pLa0plQ2s5aEZSWm1ETGl0dnd6emhoNWNVTEFtUmRpZ3dsUG5z?=
 =?utf-8?Q?e3BDw9ZLszTDU4v66b2O2fVTNJevw0=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2025 12:44:19.5177
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a31247f-293f-477d-e5fc-08dd2f190125
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE3F.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8922

On Mon, 06 Jan 2025 16:15:08 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.176 release.
> There are 168 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Jan 2025 15:11:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.176-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.15:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    101 tests:	101 pass, 0 fail

Linux version:	5.15.176-rc1-gbcfd1339c90c
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
