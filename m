Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2056.outbound.protection.outlook.com [40.107.236.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35D14218AAF
	for <patches@lists.linux.dev>; Thu,  8 May 2025 17:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746726110; cv=fail; b=nsakdpiF5XxtQLy9YH+gcWUGxUn48MOcZmg8UBRoR9qOoG2dqUoyoX7iUv+OXFneekYHGtEXEtCuj94/QkwUL7+h8HLZBk6UiRn1ukkyTHAvMEYeqZJmeB22G1jawe/A4q+QAMndvABLdbiPE+l9ntdSOefSQRZRI5P/i+vBqw4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746726110; c=relaxed/simple;
	bh=GXsUtTuS5oMOJTCxiXyMfrJKhXggqSgcvzrtvAeQJiQ=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=OZJlrN9muwaTPRN4exgaNMU85RZ7eOcieVKQ4ji3pOyrZSNjyMNazSHIHpDFTgu69uc/tw1Pq/6yHUUHJ38xFGF1hcKP6Nlz4t5HmRt6sR4hNP79YIAWXxlFyynXLsl87xucvG2z8FWbAZM82Y0CFwzfV2BfzB7DChrOXSOEOXw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Y7ndtUxw; arc=fail smtp.client-ip=40.107.236.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Y7ndtUxw"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Sal2PbAzhaGFT6XNiva5+Sm51nbgvscf0FFxHmnGgDYI9UK7BDY+pplRTaSfeDRPQR6oaVdK/0JFxNfuiyDXT7uYN/nF1bHl5E1dmya+9EZtTZLEN0VaWwa+SWtfLxyzACXq/GSTTHJKLi1JKK/9s3YhTwdH1voblGaB+jbNuLVGnGYZNuBILty+MlUF2U2eiDIR5WBwl9Qflkik5nnpOqJP//wLUlgdeSb4IXvEjcIQX7WDQlAyI6c1xBa1KfQA5+C1hHQOxhACzVaJjjbhPKkYHPEULWaJFRoVuCQeWihcGQp8ClLCjSYXXkOykTgGMMtugbeEwOczcFu8DfbYCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w+FLM+FXOGqapWdrLW0ieTC02d/Ehv+6az/SnyXFkx0=;
 b=GcS48be6stUsem498H4ERDNlGZieonaiAvMMctwta8UCANr3ADPv6EWdY1o48+Yz170HT2cbJFnAydAIGnay7mS82p0H43V+Z4n7FZBuxu0j04H+XywAXA/N2Eo2BUcfEmIXTCtHnmmWcKC1K1H0ArEhHTAIAHpcmgp5haGMjxj2eT0xEI+4bdCGGVv/TQQW3SJXvn0cED350x8mF4uTFNcBJdBeq67CyCwTN8MQx+tezyviRAktE8gS2ywHvzwkjkwp48zWEv0FXB7vII9P3s6KAXM0z2Eikeqs45RTjSvnvzQ8ndT3YMpW33KInWaHRhINbCwXGopTYNjq7L2kgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w+FLM+FXOGqapWdrLW0ieTC02d/Ehv+6az/SnyXFkx0=;
 b=Y7ndtUxwjP4d/dXZMfTDv8o+oqPdS1Dzr3db0dwGzsmG01wPM3nUav1+M77NBhF/LjjgICjwngnPV+TSqnHSFudrHDvaONCLl+3scMldwz2US4Cc1/q1eTYCLfoRP4nvIaY0JiwBz9Y6Fa15gqZbarS6NJ/Pr5vYEFXR/c0sfvMybbsI+LfBVfhvdj+Vqx4C76rIruzN9mIHfZDiOvYjzTf7vCdVe3WIqREUtfzQg+46cogGcrRI4eEyFb70LlBRCtUxZeoi+SalcLLeaCf6jpkuw38kXw57IRpw5LEDW6vMDugklFyQOhWN56HPPA9oIEnJ5PgaPOwhLNGcn+F3rw==
Received: from MN0PR05CA0001.namprd05.prod.outlook.com (2603:10b6:208:52c::6)
 by CH3PR12MB9021.namprd12.prod.outlook.com (2603:10b6:610:173::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.21; Thu, 8 May
 2025 17:41:46 +0000
Received: from BN1PEPF00004687.namprd05.prod.outlook.com
 (2603:10b6:208:52c:cafe::57) by MN0PR05CA0001.outlook.office365.com
 (2603:10b6:208:52c::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8722.20 via Frontend Transport; Thu,
 8 May 2025 17:41:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN1PEPF00004687.mail.protection.outlook.com (10.167.243.132) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8722.18 via Frontend Transport; Thu, 8 May 2025 17:41:45 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 8 May 2025
 10:41:29 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Thu, 8 May
 2025 10:41:29 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Thu, 8 May 2025 10:41:28 -0700
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
Subject: Re: [PATCH 5.15 00/55] 5.15.182-rc2 review
In-Reply-To: <20250508112559.173535641@linuxfoundation.org>
References: <20250508112559.173535641@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <70206b58-e12c-4d14-af44-aad0c4536beb@rnnvmail205.nvidia.com>
Date: Thu, 8 May 2025 10:41:28 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00004687:EE_|CH3PR12MB9021:EE_
X-MS-Office365-Filtering-Correlation-Id: b3841f3f-d33f-4eed-fd05-08dd8e579a6c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|36860700013|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NzJPOTBScGt0RzBLR28vbjdoWU9TRkZvZ2hWMy9BVFJXajdxSEFhRjJ0VlFU?=
 =?utf-8?B?aVRSSGx2WmJoanBRdmtHNXlCOVRvSGdOSWtQaEdaUGJRRDU1VTdJUElycFBv?=
 =?utf-8?B?cUtmOVk0cmNSL1FoalR6TmtXdThYeC92STFFNVZqckNqV2hJK1FSbXR3SFRQ?=
 =?utf-8?B?TVY2WUgrdDNUYlZCR3RjQnozbENDa0V6WmV6Q2hZU3RtdzZtbFlXM0lXUU1S?=
 =?utf-8?B?b1JWWUtDRDgzRVZMWXVDQi9qODdYM2JRTVFVdkUwbDlQdmtORjdOTkkrc25Y?=
 =?utf-8?B?TFh0RHJrRmFmU3pnM0pRY2d5QWgrTTZVUTlUY1N4YTNJZ09xbE5Vajd1QWRu?=
 =?utf-8?B?b2c2WnpPQXhPb2ExcXZaTHlyZHZwSE5zSDVndnd1N1RIb01DRXdPQWpNeGl3?=
 =?utf-8?B?ZHRYUkhjdW02TXQxNW5EYmFWclhzdTU0SkRlYkIvZmx4U3J2aml2cXdrWFZI?=
 =?utf-8?B?b1NEZERyRFdmdFFzWmhaSjl5V3g4TmJrSlJWNXFCLzNrZ2svMndtenNub2RC?=
 =?utf-8?B?QlJwNUt2bzhHOUNrbVJEakVtZmxNSFF6ZTdvNW5SNzZZZ3RKQ04wc3BOOGd3?=
 =?utf-8?B?ZS9ZZ1lmcUhMK05ybjhURldPTDZzVXh5UjVNODMzZzNnZytBVzdWbWxvcVA2?=
 =?utf-8?B?ZEh2SGNnQ09FUVVPMVhvbWpEbHp2czZnb3J4eUtUZkVjRnVLVDFaeFRvOFFH?=
 =?utf-8?B?L0ZoeFdOMndaSHpId05rei9VVHhLWTZjRU41ZUtReTMyRkdtZW1ZZ0d4RXo2?=
 =?utf-8?B?ZjJBOEExcHl0Vmx4dHdBUy9mWmtzdGh5ays1U1g4dHFUQzVQZEgwenIwRjYx?=
 =?utf-8?B?RVlOcjRmRUNWeHNuQXYrd2ZKNm82UHVWVGNVa1RyL0hDZmR5bks3bEpKUURT?=
 =?utf-8?B?MHlHZXJFNmh6NmdqYzZmK0E5NHRKaXpQSW53blg4WGFybmg2ZWdncWpVWHQ1?=
 =?utf-8?B?ZWJ3eFdGU3QreUg2ZGcyZlVYTmUyV3ZsZGF4RWQ4N0d5UTM4WGlkUDJGSE04?=
 =?utf-8?B?TXBnK1JtWVRrWlFCWXBZL3JZVHFkbDYvcDRhREp0M0dJZWhkVjJkcDhrWkJQ?=
 =?utf-8?B?R0IzcE1GQ1RkY1dVK0NFcEtNNzkrU0FzdStwZ2thS2I2OHEwR2pRRE1MOE0x?=
 =?utf-8?B?ZkVWdE52Rm1GcXh6czlKVGQ4M0hLUEFLY25HNVFBSWZDbThwd2dJZFRZaTIz?=
 =?utf-8?B?OW1iMUI0VmswUW4xOGFZZFZ6amw3TVh0YjIrVWZLcjl4bkEweENqV1c1VVRW?=
 =?utf-8?B?ZWcxK3gwZnZ2THl6cnowUzg4MEpjcVMyaVFpUkxaV3o3WVFXMmxacHdYeEVJ?=
 =?utf-8?B?UFpjUjd1cWtoaUVsMCtVYTcvZnBNSE9jTUtBcmsxTXQrcWhRYUNrZkJLSXp6?=
 =?utf-8?B?VitOQlJYdTR2YWZiT1dxajNLTnBnd0dadDQwa1dGUHJEcHduK1lZLzdxajEx?=
 =?utf-8?B?Y1RidE1YVTZ5OGJYd1VoTEFjQ01KYlBmL2tEMUNXYXNwbG9OZXMrMDlkTmZs?=
 =?utf-8?B?dS9NWjhNNnFrU3cwV2VqejBFeVdHZGpaK3pxaGRFRHlRNUcyZ05hY1pLUnRs?=
 =?utf-8?B?aEMvSm9Qd1NXN2dvblNiTmFHa2xpZTVtT0gwK2FXWkJ6TnlaM1N6bU9halZm?=
 =?utf-8?B?RHY1N1VsbGVQTVFjQS8vUEVuTlZhL1c1VHNWb3ZDL0QzbTZySG5NTnNnY1J2?=
 =?utf-8?B?eVpydUgxT0lSTnZBbGh4RTZxM3B2VzBHcllXY0Rzc0dUc3pmL052cmFzQXF1?=
 =?utf-8?B?OWhPbUl4M1Q2TFdsdmhqRi9aaWdpeFB6UFZCd2VEdXA5QnFIc3lBbWM4aitB?=
 =?utf-8?B?OHAxcjU3Tk5LUDMvU3JFNjV0TnBNRFRUd2RLb2M4ZndzSHdpSG9jelU3Tmx5?=
 =?utf-8?B?R0tIUGtNcDhKdDlidkJ6SldsN0VwZTZZR0lkdVdqd09hZTdUQ2NaVjFqSXE0?=
 =?utf-8?B?aXhub2I2dC9QVVg5dmRtRGIzRTlBeVI5d2RGclFpbVFVNisxUGJQTVZDZVFw?=
 =?utf-8?B?azZ0QzdOWkZka2lBWitGMUxpQUduWXFiTFdQV05qVzZGRDFVUUJWd0xWeEhw?=
 =?utf-8?B?OTk3Q2xPM1FydjYzN3doWXoxeWVTejFFVmJYQT09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(36860700013)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2025 17:41:45.8408
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b3841f3f-d33f-4eed-fd05-08dd8e579a6c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004687.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9021

On Thu, 08 May 2025 13:30:13 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.182 release.
> There are 55 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 10 May 2025 11:25:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.182-rc2.gz
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
    28 boots:	28 pass, 0 fail
    101 tests:	101 pass, 0 fail

Linux version:	5.15.182-rc2-g364c50bdd7d2
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
