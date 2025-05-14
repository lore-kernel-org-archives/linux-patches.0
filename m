Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2046.outbound.protection.outlook.com [40.107.237.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B5E253933
	for <patches@lists.linux.dev>; Wed, 14 May 2025 15:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747236932; cv=fail; b=dtH3LWyiJ/f2CVx1qZVIQzkk6iwsWZ6mDAdGpJ/ofFQu7MxC46W/GMaYl+9tdaPJMSo0e/4a4puzWvXQu1s6hYM0TL1w1jSTayFVbUH2CNRsYFmEgkUcFggXD8yJ0L6u3t+qpjYNYBrYZCYMY8QgJ4tvIQpaicWDpcAEdflAsP8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747236932; c=relaxed/simple;
	bh=9VYzQV8EQxtpqecWjgXtXzJ+k6B1hGIIiTEHod7zQmI=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=dx+64J94ARj+a2J3dFgOt9rNinTDJEdWXsRcnNrpg/5Kdmx+9wfMGIVbbs9MgSPP/XMSThu0Os5PlKw3wNvqqPoJ+/BxuZSYX3D8Jgj7ZUwGjZYGh7Ic/ecp8P05pbVijyPmA63LMvsreH8R5JZo8YoWx3FxEgu2+RTkvllpDaU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BCL1wH6b; arc=fail smtp.client-ip=40.107.237.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BCL1wH6b"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cEg4hfUnzFQ/GSczuL1vBM0cwUJO5tRyoDuoTqBiXcVpAU1fLjr0uIVMO0oV0MtOdSFJICsy/hGcEF5dd/nAPBWJS1OLKaYt6sqf3c0y9D9YCuNKYyKL0LqGGYEOP+DOCSMPRcXODs8EnBb9UeaFGi0OieWfFnKIO/a0Wd8bLTZxESiQberYSHuFu6EXXKmEDHcoq0g1h70HLR/4bal2csiaIg4Rp7GcNSXY/IeSGiB04Rfv04vvtf/zKDXySqZVPy1BObLRf0bGZTjhHIDzwctccFY+vqbRzqvqxX/XXgTYGVMpbz3OAd1aoj+xpU11cH3RQzoDLw+R1SXu0awMUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RnAWgW9PvZNOc4G3L1Zwe1yvLRI+52lXgYjY1Um6LT8=;
 b=fo9vwDKEM9ec47glqo7i9EJpQdCMoUjlp4/uDLV5vgKSCg6nsZdddIXFGd4jeK4vuim12AlV6jBx+z+vMtDs8PuI/M5mMZP2YtoaD48L/0uktBnERLK2F1zqp4GXQtLN1kqOgFLjBkTVqk36Z5mAQMHAR9Q2w2Jf6y6XL1mAyqZJcaOa+LBwvqyTQe/a23cPYexe1bCY+GT7seY1JdWK+9qFz+ZEpKqw7I0zLLAfrFs8sMyIWKVxvP2fjOP5ZKb94Wq5d3lx55o5MllMm9rbPYInGcOLaBtVPEIKVpbucK5k15C4ydatrE0bD4nONQ3ql4b4AzthaW4UhKJabt19eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RnAWgW9PvZNOc4G3L1Zwe1yvLRI+52lXgYjY1Um6LT8=;
 b=BCL1wH6bMQQr4LXa0DJVjyRoruopkb4W9mNLnA63HwYxMiA1eUxBEOpd5AxPWsuw2XlCUlxA1SaTkUXcGkwhM3nplRqdfc7bExPiYBIi2M33UjyRXylxcYTSAkcQE8exeekIHs7syMfMb5SzcnlrumwEM4mf3ofoJdBR9bZELIdzNS4ZOg0pN+B8d/1MsuXNS27cystoF2LTLRVINTMDBmAkSgoHJc5yxhSHetufMxwI2puBLRnX+1/nEejE6iz+84suRfBk4jdU5/0s2rDw+GgHUBWl/CKzgxVGVSWfJQda3hGpY5JWF1fz4MAAUXyNSWR7tllyXVPbQl2kO9ICBA==
Received: from CH5P223CA0003.NAMP223.PROD.OUTLOOK.COM (2603:10b6:610:1f3::19)
 by MN0PR12MB6319.namprd12.prod.outlook.com (2603:10b6:208:3c0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.28; Wed, 14 May
 2025 15:35:26 +0000
Received: from CH2PEPF00000142.namprd02.prod.outlook.com
 (2603:10b6:610:1f3:cafe::a7) by CH5P223CA0003.outlook.office365.com
 (2603:10b6:610:1f3::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8746.16 via Frontend Transport; Wed,
 14 May 2025 15:35:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH2PEPF00000142.mail.protection.outlook.com (10.167.244.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8722.18 via Frontend Transport; Wed, 14 May 2025 15:35:26 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 14 May
 2025 08:35:12 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 14 May
 2025 08:35:12 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 14 May 2025 08:35:11 -0700
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
Subject: Re: [PATCH 6.14 000/197] 6.14.7-rc2 review
In-Reply-To: <20250514125625.496402993@linuxfoundation.org>
References: <20250514125625.496402993@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <b1132a97-768f-447e-bd84-7cb4c83e54df@rnnvmail204.nvidia.com>
Date: Wed, 14 May 2025 08:35:11 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF00000142:EE_|MN0PR12MB6319:EE_
X-MS-Office365-Filtering-Correlation-Id: 97a2b4b0-e23d-471e-c96e-08dd92fcf316
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MEwxWEZ4Zko4MUExSTFITENrTm1nRDN0TklXV0FMSWRzUUtSdTZvT3AzOWcv?=
 =?utf-8?B?TmVwWjlLMkYvS2EreUxTY1VvWlUwL1VYZ1NVVFdFRFJOQXRrWU4xKzFHZ3Bt?=
 =?utf-8?B?b1prdkFzcUF2bWVWZ0tWL201T2o4VmdGUGpLRnZhZ1dOQ3pSdTA5cjhDVmJI?=
 =?utf-8?B?R1gwSVErcloxM3QycHphRG1vdFdiemUxeTl2aGIwd3NDTlhoUHV3S0RZMkxO?=
 =?utf-8?B?NTlJQ2dQaGlMVWpIT3FHb0RhNWRsRnBsUk50SC95a3BmSVVZSzdkVXRlV3VU?=
 =?utf-8?B?ZTliRStjd2tDS0trNGxEWUlWV2N5NnBsbHMzQmdwSDZFRS9SeWR3ZzZiMUVE?=
 =?utf-8?B?Z1JwcDdtdEwvc1NBSVovZ3ZnZi9TbGQrUUsrQlo0dHUzWG12NTBGL01hQkFt?=
 =?utf-8?B?dzVlQ1BSaFIvWldoYWFGM0lYb0hqL1l0SmdVQlM3aW5HQkw3UlZEQmk1ZmJO?=
 =?utf-8?B?ZE9sZlNmekF6SGthek85ZG90K0pPM3pIQ1pPMEJ2Z3BXVWYzUVU4amQxb3Ev?=
 =?utf-8?B?T0c0R2lvdmZSeks3ZWdDUGVWWUdrbnA2UnQrVFJGbGZ4czdaVEVzdk5yaWZS?=
 =?utf-8?B?bGVPSnpXT2dzSE84bDlmM3ZVTG5sNDE3cVAyQVpuVGdWbU5IZFFpRDg2SFVK?=
 =?utf-8?B?T0NaazVYWjZsbDN2eEErRm1SUHRza2QreWdWbUllSUhYOURBR0NwVFplOE9D?=
 =?utf-8?B?M3d2UGQ4Ym5PNHpoME9CV1I5TkFMMHNVUy9ETlJnMU0wdHdFQ3JoMVkybDFB?=
 =?utf-8?B?WlpRVkUwa2Z4cWM4dm5oZXJpVzQ0N2VyNGFTWGF5dE52RGJNWXdOcFZ1WU5E?=
 =?utf-8?B?ZXpOcUpHUk9qaGZ2S0F0VTk4eU90ajNzZ0h1VFVwTzVabjBmYWVrV2lFcTE0?=
 =?utf-8?B?QlFUdWNFTTJma3A3c0F0QWJjb3VuU1ZYNEJRbm5Hc1cvRStTd2xUWVhEUlM2?=
 =?utf-8?B?TllZeW00NmNTY0g4NEI1OU0rTmROdTB5V3kvMEkrQmM4QnJkQWduUy81aHl5?=
 =?utf-8?B?L3k5WDA2UlVFWHprenRHQ0MxalZzVnVDbHhJTDBveFZnSVlCSlo1eForK0w5?=
 =?utf-8?B?VHBaRVdZU1RoNFpIYUk1RDdpS1dDdzZsb1VFdkdndFBzaGIxM1FEZTBhNjJJ?=
 =?utf-8?B?RTQ3Wi9DNC9ER3hpcEhINEJBa0tkOFhEZjhEQmRCbkhyUVA2WERKaFZKVmJQ?=
 =?utf-8?B?Zkc2LzBvWE1UbjhJdUtjc1ZCWXdjaVRhNTJlamlSdDAxS2RlVjVnR2h0UUN5?=
 =?utf-8?B?cXBFQnJDbTBnNWswVzlxMmR4UXJtQ3Jqdy9JQU51RWNwTjRRN1paZnlidXNk?=
 =?utf-8?B?ejA2RHgxVS9JS3FZbXQ4N3g5dzNtZ3dSVHFuTnQrR2hYMk8reTNhaERqYTRN?=
 =?utf-8?B?OFpzT2V1bkwya05RdWJZMTdTQ1VLZjBwNUloZzB1Sm94ejRyWUhzU0phcS9M?=
 =?utf-8?B?SFBrVXZkc0FkS29nbnVWTHpKanlRejdSTi96TnIwNmQ0TkdOTmZJSEpwZExV?=
 =?utf-8?B?Y1lzNDc2MDBraW51L0VpcHNpUHlqT2luOFBCUXdNc2h4UU5tZDVveDBUUHo4?=
 =?utf-8?B?K1JrVWpQRDBEbUxNMnVmZFZPMEd3RnE3K3BLbXc4L1oxUkM3eHpXNFdseFpO?=
 =?utf-8?B?ci90Z3BRM0JmTVdXMGIxZzd2cWhjNmo3Z3E0cXRWT2pzMlQwZlUzSHcreWRX?=
 =?utf-8?B?bGQ4ODE2ZC9JMEJwUXhOdkVKQmRsZ2VVRThpTklPOEpNWDFmMm14RVRTc2ZD?=
 =?utf-8?B?YVQzQ2ZyS2F3NDhuRW1sUzhQTUJWOExLS2dNZmFobUFJZ05EQktzd1lERUNB?=
 =?utf-8?B?UXNOSGNKUnBocHZQVllsa3pBUG8xandaTGZ5enk3RDFZajViZ1ZWTFRQbnAv?=
 =?utf-8?B?ZzM1MHc1b1hmYXg5ZHVVL25XMzVkSUlYRFNxbUxTVWlGaUlMbEl3ZFVwclpw?=
 =?utf-8?B?THQxaXMvTUZVUFU1Y3FZaHgvNmZSbGhCNDBGanZnZDZqcUpoQnB5U3BHMktU?=
 =?utf-8?B?QjY5ZkpQTGxZL1pqc1BhT0tHaFJhVUtzdlpDUTREbTRyUWIreTY2STV1UlJY?=
 =?utf-8?B?U2hRM25nWVovalJzdGVFU21XT3F2OXlXTVM2dz09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 15:35:26.2670
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 97a2b4b0-e23d-471e-c96e-08dd92fcf316
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000142.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6319

On Wed, 14 May 2025 15:04:16 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.14.7 release.
> There are 197 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 16 May 2025 12:55:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.14.7-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.14:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.14.7-rc2-g6f7a299729d3
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
