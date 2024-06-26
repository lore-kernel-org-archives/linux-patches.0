Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2083.outbound.protection.outlook.com [40.107.93.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C74313D2A4
	for <patches@lists.linux.dev>; Wed, 26 Jun 2024 08:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719388953; cv=fail; b=jk9Gs0DGTp5K7w2oO9yXRYUWQ4rgwRSI9cGBjPvK3qa2WE3eSPfT4s995os3rkUZl1eN6nuRle2QvLN1CFSSuZ72kfa05n6VfPkPbTbSpRPBIyYCq70doNhSM3pQnIvM8kMf7RZhH6dqFT4qakgbwU4L1iYIivTxLQyzoDtNTU8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719388953; c=relaxed/simple;
	bh=6K2IGpKLo4lExA5bypoL4mm3sXGXwMpgTcdh3eAaSqM=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=Bh4ejRjtzTBlqcDvmjVOhqu5dFLs3/KKT1wPbP9jaFfabVAXeBNjRJgIs2l62746kWFh5pcSJ++aGMlMfix8ecMhAl9aF03y6y7xlgpL13ltmtRF/CNi7FLeoLxlJ5gWsmrJnNIgLYNrRFgup8Mxk2IuTWcKTpqB0FLJhQTQ6TA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lfILmGdv; arc=fail smtp.client-ip=40.107.93.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lfILmGdv"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kIiuW3HG6Lwf+uVrVW39/EdS4rHiFCmaL6IrMLTBXMOZbuIzRK27fmydjJyjcJkXL/yGH3QglFkXtRiVrd3y+vSv5m0RzVzLJGaDp5it7iwkwCmILEQfguf7GDhTGOkUvB7hrSClC3QzbM/ZwGkviepw0F0e3sVBg1jM/X+e1PUVBsYj1oZ1d7EtjDZBZM6JG7GolgC24pJZzNlsmNullsBVGxSXicCaqvVjJbjNkfRM3fUeEof8sGM0bGCA8Inb3L0fmwdFrhntKSd+KoE3Lx1A3NNF2aqVf0H1R0qZ5enTWiEzM5D4D7xrLFPMbfkKLPCmVAJjFAmy+IT04SLKzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dAAHpavMy7SkQVL/scXV2vQXdlRoz9EyNQUetBhM2ic=;
 b=U/IE6AF4EyBiH9BjWXRaqqIDMYE4/KcxSq94KVzyMt6moRzKTRONdXYJ3mkUDsjvhxoMQV/VpZpq0e0lAYMMm0wSQxnBIzXbMqDx5+Jf8j3u84q8HYrXnJ2NyJm5YKbkwyqubTvsH8Yst8ug7kR2aqGzGyCAthrn0z7gzPChSWWCo7zlR/bE2MLXpd0ZNBoj9pxW6GXbgf9ombM0eLNv1sis/V3Y4oONQ7ajVo3orvvY9DoYCQ0EHGDJxI/hitUhUkIi16uAUE8e0VGorvOxUiZx3SXL8coYht6vHIvT06VurtBH9KdVtSChwYwpgpkgYF0ak+q+8SEtOHlgAcdyHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dAAHpavMy7SkQVL/scXV2vQXdlRoz9EyNQUetBhM2ic=;
 b=lfILmGdv+uWvC+VeUtLkSv3EVebO4Bm0bizHQfxBV4d5/NuJ+HmG6jfDEACki1YQi4hd5/5LLLIoXCc5+uvT/QEzSPaDmQaiaWxYtSwySNdgsxDJgyMdsA5HCYk3pNyrA1DoHqwJUIp5IRBNMK+pmty9dCUJRMHGA6Az4bcMAG0HfJP/ZnDCedJCdjSyIoFgghGE91svcQq+foh6kNqMS4x4KWMcGs0lfwkqXmXfjpIA0N8JumvqqVkHsJNyMuLXL6wPVjbWaQTaz0e3hqlPNmUtoM92l44qnwn4fGUqUReFuYbn8z5FBKXe/2MwBRpnT2dtzRdJk8Q+833EB8PpOg==
Received: from SA1P222CA0126.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:3c5::15)
 by MN0PR12MB5859.namprd12.prod.outlook.com (2603:10b6:208:37a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.32; Wed, 26 Jun
 2024 08:02:27 +0000
Received: from SA2PEPF00003F62.namprd04.prod.outlook.com
 (2603:10b6:806:3c5:cafe::73) by SA1P222CA0126.outlook.office365.com
 (2603:10b6:806:3c5::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7719.22 via Frontend
 Transport; Wed, 26 Jun 2024 08:02:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SA2PEPF00003F62.mail.protection.outlook.com (10.167.248.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7677.15 via Frontend Transport; Wed, 26 Jun 2024 08:02:27 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 26 Jun
 2024 01:02:16 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 26 Jun
 2024 01:02:16 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Wed, 26 Jun 2024 01:02:15 -0700
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
Subject: Re: [PATCH 6.1 000/131] 6.1.96-rc1 review
In-Reply-To: <20240625085525.931079317@linuxfoundation.org>
References: <20240625085525.931079317@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <9c7e07a4-0d8b-48d1-9fa6-bb9e5fdcf50e@rnnvmail201.nvidia.com>
Date: Wed, 26 Jun 2024 01:02:15 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00003F62:EE_|MN0PR12MB5859:EE_
X-MS-Office365-Filtering-Correlation-Id: ac08eacb-4cc4-41c4-a361-08dc95b65248
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230038|1800799022|36860700011|7416012|82310400024|376012;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ODd2YXUyRlpzS0xEdmcrU05jeE1RanhIeHhDTTlWbGo4dHNKRUczSEY2bFFL?=
 =?utf-8?B?Z3A1SDFlb3RweWlYK200R0pUejdsa2FRdDYyQU43Y1lCNTJ4TXVVTllINUNO?=
 =?utf-8?B?V1NHZ09hYXo4djhvcnpWTHJER0dpZTA0UUhYbVlZckpJN0pwSFc3ZlZ5Mjl6?=
 =?utf-8?B?dGlBUWxzYjhwMmg2cE9BcEY2eGZoUVhkeW9LUEd0aUtJNmhhdzVxSnlGR1Vw?=
 =?utf-8?B?OFRCREVmbHNKV1pVZU5aK3UyV2pJbDRSKzJmS0dDMU03Y28xeDI5SENUdTRG?=
 =?utf-8?B?WTdjbkY4Nm83c2hRMlRQclJUNFZadEVlUGk4a1ljdkhGT3hUcTFOOFZEbnJX?=
 =?utf-8?B?NHhLWHNkakM1WUpFbDVreXc4ZDBlUHhkZ1d1TkhYSkxzUzd0ZEk1UzBNcGVG?=
 =?utf-8?B?Sm1IQTBvdFlqVXB6bGJoYXlxeXVOTHlyRk5hN2lrY2xmR0dOQ1RBTCtZQ3Zy?=
 =?utf-8?B?c3pqUVhkRHdodmJnTU01enZabjdVdzdWOUcxYVJmVlhQcy9oVWN3cVZiNjV2?=
 =?utf-8?B?Y2s5QmM3dTBqdGdKYkFRcDVQOVJpVWZNaVhIbWVqZm1DOUJZb2JvVW40WHlo?=
 =?utf-8?B?amdCS2QvZHoyS0JzNHVaRVFrcGxGdjhRR0JJN0VLaXd4NVJaeHdtb0VmbWo4?=
 =?utf-8?B?a0lMbnlVR2ViT2lDUmZ2QjBaaFJVUFJXdUhabkxuUHY3WCtPNUtrcnhQbUk5?=
 =?utf-8?B?UENlQk1aUHNQUmhvTXVsNVJHOCtldkVVK2U2VnJXZXh0VVJ4eWp4RG5GbXF3?=
 =?utf-8?B?TExCSldlZHpkS0tMZXVWRjg1TDlWYUpta2FXNlJKUGgwMTdZek1mNmsrMm5N?=
 =?utf-8?B?ZXhzL3pIQ0RCOVNwS09kbk8zSk9JNk1DV1d4RDF2MlBwUnlyZFBVbXlHdUFP?=
 =?utf-8?B?a0JnMDY5YzdYKzhqektFdlExK21DYUVueXFld0d1WFBGTjhkNVNiOU51SXBE?=
 =?utf-8?B?UHhnQVpxYlA2MDZxdTZSTmZUSG9HUHNzSGRUNlpUaFJwdUdNVno2VnNtN3Ev?=
 =?utf-8?B?Lzh3MWxST2tncG03aTRjVUhPMU9Sa1BzZlNjckkzdldOVWJBN29XVnY5VDVw?=
 =?utf-8?B?K3ZuSFFjYlh2WG5zcG16UmtaS0NUc3FMTGNDcnArbTB6c0s2ZGY4SDNKQk5I?=
 =?utf-8?B?ZDZYT2M5b0hkY0xIYmJCYTB5b1FBMXI1YnRGK0NIOERRM2w5SFAzcFpUaHZm?=
 =?utf-8?B?d2djeDE2YTlXRVJjSTd6WHVjOEFGMkJjQ0lrUHd1eHBwU20vTFlyOGRXT0Zr?=
 =?utf-8?B?UUFYTjJ4SlpkbnM3TVVIVUk3ckdtcjRhN3BqWVlRbjNUYmxDalRKV1NCOWZx?=
 =?utf-8?B?NmpGZDRFN3J6TzdNWWl1L3ZPcm05SjRYREF1K0FJWncrTTVucHJmRzhPSlRV?=
 =?utf-8?B?dmVPZlhXZUF0THI5K28wc05CODBEMThEajNqWlV2SWd0bkhJUjFqYlV4N3pq?=
 =?utf-8?B?L0hYZWJXRm9YWGlYb1dtL3kvblRHVk1wL3Bxbk5iMWsrR24yMkVPUXM4cmgv?=
 =?utf-8?B?SzduWDZ1MnpaSlNoVzJkbENwelpkYjZwdWJLWWpiMTNFRGp2dnZlS3JuMnJI?=
 =?utf-8?B?bEtIRnVxSE5jQSt4M1N0N3R2emJGcGd6S3htSkcrMHUxNlVJWlFmMzNWVU1R?=
 =?utf-8?B?d1pwQWVOTHFudWJnREVIY0VMOWlmR0NhcG4zaXBaNWdNSGdqZ3hmNWxENlox?=
 =?utf-8?B?UXdPWFk4bE8rcHRXeEY0bFA0TWVQT3hOenJVYkxLdnpOVjZ1Qkw1dXFGM3Mr?=
 =?utf-8?B?cEhySXhvSkoxMENnSE9henpwS0h3WUpPc21qbldwVnBBZzE0cHBUc0ozdFVZ?=
 =?utf-8?B?c2pRSGdRYjN2QUhVeWtpWVhuYWlreUZFV21Rem4xV2FZMEo0aFZqTGJENzI1?=
 =?utf-8?B?alg3dmxhbWZQVFNKcXdwZDBieE16SVlITHBiV1ZIZlJqV1E9PQ==?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230038)(1800799022)(36860700011)(7416012)(82310400024)(376012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2024 08:02:27.5596
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ac08eacb-4cc4-41c4-a361-08dc95b65248
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003F62.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5859

On Tue, 25 Jun 2024 11:32:35 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.96 release.
> There are 131 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Jun 2024 08:54:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.96-rc1.gz
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
    116 tests:	116 pass, 0 fail

Linux version:	6.1.96-rc1-g80ee32f97e81
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
