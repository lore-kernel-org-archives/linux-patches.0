Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2060.outbound.protection.outlook.com [40.107.101.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96EAA21018E
	for <patches@lists.linux.dev>; Thu,  7 Nov 2024 13:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730986959; cv=fail; b=Fr2LV3wUWgbhUl0h9ofEuuPud9ANBDvUA48F4NCpuAVefY2kL36CL8EpIp/W199JVLIEmj+HwLQmIvEn/0DU/L1u25JWSexU/UIymSMgcUXJnsIlDNFiNKilNt4jtE9P8lM5XD7BbwqcU+zpMvpQhuX34AOnT5Jevtl8havwuHI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730986959; c=relaxed/simple;
	bh=/EnIth/omfkuZW1JxaOjCLm/j5JEDlPXGAVHYNW53is=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=pHwnbruSoRiJmPjYaSMMRYhH0KTkJePxHB34p69ijVjKLfSNNXIaEJ8qXyIl0z4DwvCF425orYO8LMikMJSyzFxqhVKlI17jioRJb61wL46wbUprc4SQ67UN73/ExQtJQ9e27L+U2TCGEeZVveNXcej12m5jSwkrh+dNqHd2Bu8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=leAOAteG; arc=fail smtp.client-ip=40.107.101.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="leAOAteG"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ObmlXJitpZ5KEKANenxQTHBFxrQWwmeNWPq+GMx4DEQ2miVzgfl98wRE3OdzVh9ykN/VXW4ZL9DciBAjrS5SkAbgpL/upaX+McAbeGk2virF5MYc+qaAoeXQ8GI4Y3qKtMa093yLuZYK9uqNnnJ07WIY7Natx6F8OgYiPiaHqNqTVbSp+9jIHSceTmifk4ueo3j/9BdRlfoUnhGYABeHdPgF5VDJ6m4wtlc7fwfWDphLbGuUbYLYGmEsc0WwwgEK2SJ/vdAF0kYiAaMt7K6qYdyvvn1mUfi2Fo6qnsFbFnia4+32VnCS2xzy1hd5l8ejbOL9Fs5n+OWWftkcMgRilg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N2DtNnyLRa0XwnxfCLGMp3FYxnsl2aIBEkNrcxjW8oM=;
 b=ENRhwpxxuNiXVUnB5E2h2KTzNFQDzehEXBZmcGcgn7ShlgTsMQsO6BIG2xuikBexQSpGwasET6t61udU9W7S/jX4AzdULjnZ6eiGOZUeTMx3guBSQJbH0wpLzyO9AY1RRuU7ipUCcUbH4gJJZFvPP7cyDKK4TGjIuvdX6fXvV5NBOZBpdduFm3d8jWz22G+dW36hTZ/Q2L45g5qUsmqnt5H+NqQmLEcikV/17exfqZXPGVmyPmIdMj5wK+Z4ntqe1oFTUbvhsf6gt4V1ATYX5rqQPATpX49ceHWFYzwa+sCUNbrxlX/vBgqhvCnbqDe3HHOXL/fe3hpybDDPoyi+1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N2DtNnyLRa0XwnxfCLGMp3FYxnsl2aIBEkNrcxjW8oM=;
 b=leAOAteGjWIyiT6GNh6Zs32gEIMA8SYfxstY4QIvoCpQITDjQ6tqUcH5ZJwZv2g7hANre3xbQ6MwpkI0AbD7xNuxrcL1Jf3mslWXiW/hek/ABDENBHI3RSdQfDtVJIVyQorUST45MTPayxZEwBjv5k2BOIKOWEFmtYgdAuXGZ6I5NIUkRh6r+DAIKXEdt73GYrPPegj4RP5CmQ89gkrepVkBCc4Rey7UXHSQsihxIrMKC5Shtk4E7aqpBhxbMgEnkcqe86zmv3VQmA/UjcAGVvBe7PI1P7QrODiHRN9BuNz5UlXEEo22B+zCM5zMj0g8J/X5Z9eFA/mxTs0PFEelBg==
Received: from SJ0PR03CA0376.namprd03.prod.outlook.com (2603:10b6:a03:3a1::21)
 by IA0PR12MB8908.namprd12.prod.outlook.com (2603:10b6:208:48a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.21; Thu, 7 Nov
 2024 13:42:32 +0000
Received: from SJ5PEPF000001CC.namprd05.prod.outlook.com
 (2603:10b6:a03:3a1:cafe::34) by SJ0PR03CA0376.outlook.office365.com
 (2603:10b6:a03:3a1::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.19 via Frontend
 Transport; Thu, 7 Nov 2024 13:42:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ5PEPF000001CC.mail.protection.outlook.com (10.167.242.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8137.17 via Frontend Transport; Thu, 7 Nov 2024 13:42:32 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 7 Nov 2024
 05:42:15 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 7 Nov 2024
 05:42:15 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Thu, 7 Nov 2024 05:42:14 -0800
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
	<rwarsow@gmx.de>, <conor@kernel.org>, <hagar@microsoft.com>,
	<broonie@kernel.org>, <linux-tegra@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 5.4 000/461] 5.4.285-rc2 review
In-Reply-To: <20241107063341.146657755@linuxfoundation.org>
References: <20241107063341.146657755@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <46dd7dbe-1ce5-4440-b1fe-7a91ccf26af4@rnnvmail202.nvidia.com>
Date: Thu, 7 Nov 2024 05:42:14 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001CC:EE_|IA0PR12MB8908:EE_
X-MS-Office365-Filtering-Correlation-Id: de41fbbe-ed9e-4bc1-2fae-08dcff3207ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Q1ptU2U3ajFpZjhNOVppeE5QblZxSFVqRFVvZ0g2cDYzT0lTNHVlYng1WkhV?=
 =?utf-8?B?ZWo5ZDZldldGMEdCSk1rTmw3bHhPYjU0SnlZVXQrOGgrdmtGRDJqNjlEQTNu?=
 =?utf-8?B?VTVmTCtGWFNCUWlmQ05mVithaHg5cUFrNDBXd1ZtdEpHT01haU5oSzdHQTFD?=
 =?utf-8?B?eHNPWnZwUGNuSzNkSk5udEwrdFp5Q3FlRXR0TDdCbUtPaVBYYnpaZ0NFRlJM?=
 =?utf-8?B?OEluZVAyL2xrd0d2cGRiV2JQUXkra2s2cE5yNndSUC91bERPSWJFczRsSlhI?=
 =?utf-8?B?NWlGenljS0FMWjE0b3ZINmsrQTdGWmtUWE1vS3ByYTJFTm43b0ZLKzdQTWc2?=
 =?utf-8?B?MEZ3RlRYcm9KTExRU0d1L2tqT21Cd3RVQVBnT21kWkhNOEUvd0xLbnVFeU1K?=
 =?utf-8?B?clZiWHdTVTREWlR0T3RpTHNFOWpybzZZWjk4Q1VCVWVubEFQQkhSWWxpZTls?=
 =?utf-8?B?WTNGeHJrVy9XM0pscnNlekdRR295Y0xFWFh0Tkp4cWR5U0I0eUFCNFN1bVUv?=
 =?utf-8?B?MzlPekVkTlRLMU1oMkNFaGIyNXdaOXdlL3F2UGRiNTFEaFo1Z3A2RG41L2Nr?=
 =?utf-8?B?QklMNlpxTkdvUVc0RVZrSm9SRzhOR3dHakNqM3pscURybXpzbDBoZkM5UG5T?=
 =?utf-8?B?cWFpbHVrNFd6V0pCSUVDTUxIc0hLUkZub1hWVjFsejZrbmlGU0lyajkzMkhV?=
 =?utf-8?B?WlJQbitIZGJwOHo5dGlvVXZMbHQ5cGJrZkdYSE82c3JiT1RydXZGZXZiYXhn?=
 =?utf-8?B?UlJlTzk1SFdrQzdKcUdqQ2R5L0I4ZXdYcVF5OWthNXY1eU56dkwzTDJCSHB4?=
 =?utf-8?B?d2crL3hpL0lyZ1hYTDlXamdZY08xMjd5bWozekdkS0dSZ1EzUEpiY0JydVBz?=
 =?utf-8?B?d25QTzBmTWF2SVRmY0ltQmFVNDFTenBRajhmYVJ2aHZWaFh5dmMwL2x0QmFv?=
 =?utf-8?B?WGxxM0VFL0xicFh3TXN5ZXBQNXhqTzJLR1dzQUdQZ0dmKy94a3g3L3RoY0l3?=
 =?utf-8?B?dTVGaENqQmRETXlBc0VwOUNIc2t6QjI1MEpRQ29oaEdzenR1UTFWUVdVRWwy?=
 =?utf-8?B?T0tMdCtTcFFBYVRXTVdXOUJxVHhvQnN1eWswMXoveTVkb04wTzJJQS9rbVJU?=
 =?utf-8?B?Z2M4emNOR3ZCSHpLOS9YMHhmWHArcW1ieU1uckEwWGg5MWVtQ1RaKzBoYzRk?=
 =?utf-8?B?THRsMDVpVVZsZVVidFNFbzZMNEdxMGlpaVZuTHNYZkc5SGhwUldFeXFoU1NO?=
 =?utf-8?B?NURpM0V3cWJYTU4yR0VmMjRROFNYZzhyNFNpZGQ0L0d0OG1FWVhOVmxmT2Qv?=
 =?utf-8?B?UUprZlIzRFllbUZKamR0N3R4c3UwcjZrL1JrQ1BsM2JDdDhZWFc3MFZzblVT?=
 =?utf-8?B?QTZNdFN4L2E1emVVYmoxaG4zM0FBMitaOWZWTzNvaEZVdWZWQzZES3Q3Zzl4?=
 =?utf-8?B?VldXN1crelpZWFBJQWtmVnZ1akVwck1STllZejBpcXkvWDdWODV5VnFxeWYw?=
 =?utf-8?B?em5zbzhOeHF2N0tIekJodFl3azF0eXpjWVRQQXZ3cjZaT1R1cmJlb2s0b2ZE?=
 =?utf-8?B?aDZLcjlYcmY2cENFVDRENXR3OXdaYjJseDMyNWoyT1oxYzRmYmU3SW9IaVNx?=
 =?utf-8?B?SzFtOC81VGphVkFObFRpTWxSYTRIRHNPZ2JoOHhmUEU2WDZydGFJSlJha2RU?=
 =?utf-8?B?eWdjdklBdUo0bmtLTmtRaUNoRlVFNVg4c2pZaXdJanFEZUk4Y3k3TFRmNkJL?=
 =?utf-8?B?SDA4dWUxd3YwbmVVMkI1R29NU2J6cUlKc0RMeUQ4NjhBTlRHUE9QbllEMGNM?=
 =?utf-8?B?WVZVWVVQMnZ5TCt4M1BnYU5SZG5BZmhxb1c2cXpvemhYY0tITXJNK1Avczdq?=
 =?utf-8?B?T0EzRHk1dkNGcWpuYzZ6Vm1zUXc2RWJjWWZwUkpmb3dnUXc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2024 13:42:32.1718
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: de41fbbe-ed9e-4bc1-2fae-08dcff3207ab
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001CC.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8908

On Thu, 07 Nov 2024 07:47:08 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.285 release.
> There are 461 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 09 Nov 2024 06:32:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.285-rc2.gz
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

Linux version:	5.4.285-rc2-g5dfaabbf946a
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
