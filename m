Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2069.outbound.protection.outlook.com [40.107.102.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 685C92770B
	for <patches@lists.linux.dev>; Tue, 25 Feb 2025 09:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740475831; cv=fail; b=BqDc20tu4xyjoAEkd6kb3LcppNM1PoitP+VHqoW3J9Ebd7V5wxvwlVWSyMsyq8JAbpeSpPRTcwyhOO8LIC9skQwCnBYjPpp9NOcKgKJoAysKrZwAJd+OqEDE4hdnuzuxPQYD5M3nkw9fnQN+7wsVMG9TCeg0xEHeDAHq8mCKORM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740475831; c=relaxed/simple;
	bh=LRHUXbeVwtbI6a6l1ATCpE83Xv5BOI19Xm5XiRUP6Wc=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=qpSzSakhDzrpcAE7Q9qOPkiVgsgjtVT6SD1oFsKC7+RQSaEc/Tz2nUqJRcMV/Wiuy5HZj98J171o3/klPmllLi/HylaQu2/z64Da4/nhMRlv43iwuQIL0vFl9QngWibOA8iMDEq0m7kyPUAzsRlG/TOWH7GbUOLvmeClUAxomgE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=eP28KjLf; arc=fail smtp.client-ip=40.107.102.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="eP28KjLf"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aT3G4WUbZRE6Wf8lPEmbBSgJiUh1FSp2azWk7PmenSqBS5k4SQtScJnywop6GoUuHTZ083+H42ADF9lt1tEkTMTiHDtcWNsvSa951zNiWvH0p8vq/TjL+xQ7rRX76jPXONMlnfbyVFiZw6z4kMK8DMubUDdXfF4g+ntwkxKiv/K47yKV8rDRbmzTxqOs3n9bAkNhwM5MCAi9io5318p/z2HM/QLouF1BWGmRxMI2bGOZ6ZKRsV/CHu6/Zl4FOrdBsH4oBwrKMBu+JFatrIAiRC2jfVfchnTBDbOS9A6mcvF2OCD8hctCsj7U5kcWfvQmu8Lp1GRNsNFdbMpu7lFRDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fBZIidM59/PsAHxaWx6tM/AFvY3X183Ba7anuUxlnfQ=;
 b=qiQ7HunlKmxO/0+UI8s9KeN9X5C98jtIX90VXolmvLbPl6tmJ+layR4A5+An9/fFozX8+hBIEjuMwi+RjCO5pL6iuR1I2pAM0HwmLfdzT3Bztn++X6RsH5/Dckyu4CGoFUJFWv2edXODVgoZ/GfuLPl7nNEN4sUJi145v3RAR1qt05Cqaglrdq3ylVZ6qzfH1idtAvl/80RiK6F4EyD7905E66tPnd5lQ2a49GjVaQnho+SkGiE/QzGL+37ezVxdP/2VfZL9YkXiCFgEXlzc/lxyscJSUDcFwXc6+pT+sSWvyri9D8O9CK+2Tm+3J70HFFfBzpPvhrjX7LTMpg+WiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fBZIidM59/PsAHxaWx6tM/AFvY3X183Ba7anuUxlnfQ=;
 b=eP28KjLfyeIFDmn+mrr0hr2Jk+1mEv2iCDHp6wfDDT9+3esH/mb/sU3v1cvQQR756PG8YYcghGNpEEicJnQYb6PVokq69O8fRqdiNzGpkXLmf6mXGbJ+H2xwCfmhfgor74WdmOAKJfSfmX4IyfpaX3To8Il03iAcEtvaWllEwjgFV2PJrK9TDCjXiZ86mn3GD5VALCSwJ4eQP+Iuy/1SfspwnQsMaNPQ18YzOqWdbbyWBk8QRPYSXyoLaIqemeeUK1LAKj1OgZnB6dx2LoD7aogdm6NUZpnJFd+fcG9jU07TOnHwB6u+x5wm7xwzu/R3m7K945i72hmbggqM6KGT+A==
Received: from MW3PR06CA0012.namprd06.prod.outlook.com (2603:10b6:303:2a::17)
 by PH0PR12MB8151.namprd12.prod.outlook.com (2603:10b6:510:299::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.20; Tue, 25 Feb
 2025 09:30:26 +0000
Received: from CO1PEPF000044F3.namprd05.prod.outlook.com
 (2603:10b6:303:2a:cafe::ea) by MW3PR06CA0012.outlook.office365.com
 (2603:10b6:303:2a::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8466.20 via Frontend Transport; Tue,
 25 Feb 2025 09:30:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1PEPF000044F3.mail.protection.outlook.com (10.167.241.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8489.16 via Frontend Transport; Tue, 25 Feb 2025 09:30:26 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 25 Feb
 2025 01:30:09 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Tue, 25 Feb
 2025 01:30:08 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Tue, 25 Feb 2025 01:30:08 -0800
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
Subject: Re: [PATCH 6.13 000/137] 6.13.5-rc2 review
In-Reply-To: <20250225064750.953124108@linuxfoundation.org>
References: <20250225064750.953124108@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <e8372ca2-1f23-447e-a8c9-7afc7a19bc74@rnnvmail204.nvidia.com>
Date: Tue, 25 Feb 2025 01:30:08 -0800
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F3:EE_|PH0PR12MB8151:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d0db391-e969-484d-ec2b-08dd557f0963
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|7416014|376014|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aEtJb3lSRlp3ZkdXZ3VPMExPUk1KTEk4UXJFQkxvdGRVQkdWMWZNcmhKaUlq?=
 =?utf-8?B?bXp3TytaQXh3VGJxR29MWVd0TGpTUFhydEJOU0ZzV0NJVDNZWUpSY1FxWGk3?=
 =?utf-8?B?Y3lad2xvSDZMZUI2Z2lPSmVwY2I0aXBJbFlNM1dnU05FTk4zNVpMV1lGQnFM?=
 =?utf-8?B?OWFFVE9DYzkzOGlENE8wSHlFUm93MVJSd3ZiV2RaSktLN09WODJLNEJJWkgw?=
 =?utf-8?B?RUI2aElPN0FScUU2dUZMaGRYRU5LOWdKQ3E4RXVSTFM5V1Fud3E2Q3p6MXEv?=
 =?utf-8?B?YnhVVkNVZmhBaEZFZkw2UVFSSlk3WDBqcFNMeVpaaGZjaGkvMFRzdmp1b2w5?=
 =?utf-8?B?RkNZVWZ0WGxvWXBWdEVmbHB4b0J5QlNDS1J0VXB5SmE3cHhMNEtZdSt0L1RN?=
 =?utf-8?B?am9MN2haN3F3WUFDQUxnVUlEd1NJa3RUUEhzajdkZk9obzZYSStCTEkzK2xJ?=
 =?utf-8?B?ci96bDZRMjhZbVRkVzU0QXJyR1VnZmpSSVlkd2UxbW13R05aTVBEaEx1a1hu?=
 =?utf-8?B?cE1FQjdjN2NCWUszbDh6S2VnY3YwKzhGVFlxVGozVUhUMVBlNUhuSzd0aW5p?=
 =?utf-8?B?QWtPUFdqa2FxczhFUVJqT0doRUZPcHJHQ1AxdUIvWko5ZUd5ZlBzMDdDNlh2?=
 =?utf-8?B?V0tWV2h0R21FYUhDeTJFOCtyQzE1aTF1S3FRK0Y1VlJTVllISUtza1BRQXlY?=
 =?utf-8?B?cUlFcU54L2tUTHMxT0JkTmsxUTgwSzhxSDgxWXB4TE8xZ291cy9PK3gycTV4?=
 =?utf-8?B?bEorQVo1d1YxeXZHRkFERkM0aWJCWHV1SnF0aWhyZ0FLK3haSjladk9CTkVm?=
 =?utf-8?B?akwxQi8zdCtiYW9ON2NCcUcvblBJUjl2di96LzQ3bDBsdWZrc0JRSjdvaDF6?=
 =?utf-8?B?bnRyeW83ZzBpRUY0NzQwcmNsK2pJd0FBY1pWbG1pRU9sNGsyZm5tTnJYQ1Nl?=
 =?utf-8?B?cHkvTUpvS21NcDFzVFJ6R2VKdkIyODArSkkzTEV5MDQvT2lSbHJ0T2Rsbnk0?=
 =?utf-8?B?VGdjQ3hWVThIT2hnTE5rYStJcjZrencvZHlnNnc2eW5xSnF1ZWFzdUVqZmVL?=
 =?utf-8?B?OTY3akNCcktwOFBueDRhcC9yR0V0TmtyTkNoNFM2QlpRN2NkR3dCWGNGeDRx?=
 =?utf-8?B?YlZHRkJPOVNjMi84NGR3VlVmUHJXV2lEM004OHVWa0ZKSGR0SnhKb1BQclVm?=
 =?utf-8?B?dU9vbW9BRFJMRnVhTXNxUmJIcFdHdWJzcEdobjMvenAraVVqNVBLYmJsR3Vx?=
 =?utf-8?B?eEozUHEyOUlVMFdDNFc2VXRvU25RU0txNkRXMXVGUXZ0ejJna3ZOZjcxZmdD?=
 =?utf-8?B?MWlRZG1RRXhFZ3I4UjQ3anBKKzlLeDRuajBWU0RNaERGTGFLWlY3bCsxMUdN?=
 =?utf-8?B?UlZEN1d0VG01Mkp6L2dLeTlVV2JHVHJmQlpBMkIwN2lBVU4zcnhRb01OeUVV?=
 =?utf-8?B?WFVnZkxheHhITGxXaEFSNDhQNG9HbGZKcE9XK0ZRbU94RGFQMWZncFZXRmtH?=
 =?utf-8?B?VkpHQmM2Q0dDR2hSYXhDbW5PenBYek5ibVhWbS9zQ01HMUZPK1lqMnJhbW9P?=
 =?utf-8?B?c2I0YmIzOWdPRGUzSWlSVHZ4dUZzS3FxVzZDRjdZM1lvUTVzOE4wR3dHdzI0?=
 =?utf-8?B?cS9KcUZxSG9BQ3VIblR0ck1yMWJEYjBTZkF4dmFIZ21TNXpDVUtYZ2JuWVBj?=
 =?utf-8?B?cjFaNWpIaEtYQUEzYnRKaXlMeWsvOXBHb1QzT3ZURDhwM3M4WlpINmhBbjN1?=
 =?utf-8?B?bFBtODFCbXYzU3NnZnVXRjk1aVo2a0FBUDEzVXVkT2dmMmprOURiTTkyMDBw?=
 =?utf-8?B?NGZGamd4WTR2YjIxU1FsZCtJa2xsSHY2RFVJSW5kdHY4MFNkYXdxcldBbHFF?=
 =?utf-8?B?Q05Ia2U1NmVZUEFpdkQ0OVFieDNSQkIvYjRWTENPUzNUNTd1SWtiMjJFcExB?=
 =?utf-8?B?ZlNraDdrRVVpQXY3TFMyeE9UbkJ1Rk1HZ3NrL2JrUmlHSlF2T212VlI0WTYv?=
 =?utf-8?Q?RHc9NVHJsH0GBIjbw1bbEjQ74tbPJo=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(7416014)(376014)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2025 09:30:26.1666
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d0db391-e969-484d-ec2b-08dd557f0963
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8151

On Tue, 25 Feb 2025 07:49:18 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.5 release.
> There are 137 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Feb 2025 06:47:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.5-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.13.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.13:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.13.5-rc2-g1a0f764e17e3
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
