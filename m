Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2088.outbound.protection.outlook.com [40.107.236.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 459D21AED59
	for <patches@lists.linux.dev>; Thu,  4 Jul 2024 14:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720102255; cv=fail; b=fO596pLDeId+qHLSUBnLMgmZF2Nt88F94gmWIV5vv5h2R+ZW15qMdRbj+y7FCqI1MCtousQ3YWmQpy/6Sp8B/m7MZngz27jXGDjFK0Rc7uVdxgEyCauxYS/XtGEEbAtMxOuG6x42dwphquobHXQ6dXpLIqMmfIAqUAGGolyxTQo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720102255; c=relaxed/simple;
	bh=en3cGpMzmz0BEMy9wk8n7gnN779UeCGd67BJnxhtQWo=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=anwSejw0a/hJWciPy1gYdxbPrQVWxCBiRyodG8fppJX/hfXES2D4aXBafxcRAxJJEPqsMc5Nh1oa/HSuGlm9klgmUsko4dNr4gUWaWpuZwiy5B1+Qe6UeVyniv5mWvagNg5EVC3i3fjMVib81P8jiWJOwcKMMhkyxAoWTLvk9jw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=PmgbC2uw; arc=fail smtp.client-ip=40.107.236.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="PmgbC2uw"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jG09YQzthp1Q6s9bSDwVC6An90wL/Wdh41MZ6YkhLGGmhZjgSxiIpOP/DGcQBMnSUbdCQ04PaAkh1Eiu4jzmg0DPIHTBHUlXqX1lRYk3ZP7R0E2uH2+Vqm+7rRmeyV59eQqyZtyKmAdl31MJFr5QNLEZsP1LZSAweEMAvya05+gqqz18L3YP5n0noxsuaKQ/CZQDlKfaiA9eOWPemHH+oOpmM0Vfo77HZ/zOUM58gAmAgQs+uyElxM63mzCgEJSs1Y5lRg9B57d6Uo1JjdxtenTr/2Vn0t7YrOvq+L+X52VMHu2rbcfQYM4ucBC0qJftwcVfgKUVDv3S9auQiChKQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PYA9bSUE8jaatM3JOa/bymQw4WT9YBRCu2Ep9mf9cnY=;
 b=F4l91S0KcllLqngvii0JkFWdRBPTVUjBz1tOCM2OCAOSigiSmKOK6yxprv5SslUF7e5wFHmNvsB6I8p/2NbbfMoRXTIwFTAVqYYan4bPAUJWaWqFpgYIebnYzF9gIYHOrbZ2fyxNoBmS0YJvKFV9rz4no/H1UyekDnhkokuJs0EffUTB+nOvU4XYGNfl+wsy7qqNFUBh/bTa1OY/bPX3Lpwb32UDUc9u0cj3c6+OCXWK0d6t99OIGJQZJd92hQ1MypQa+SBYawwdPmUIQFde16UApVuV1kc0FhcaTbaIBVpKNDTgV3poECkUj5SbnETs7HfE2Ys3WPhKCbte8rUx/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PYA9bSUE8jaatM3JOa/bymQw4WT9YBRCu2Ep9mf9cnY=;
 b=PmgbC2uwyjTpQICLx1uyQJyGqA4pZWwDGj/TPYHjB/OHJAUXAnn2CdPkBWLgqsvcaX4vRn18rCd6WIaC8uY/SlQ8Jm6iPr8/0sHsZ9pnosWdmFrX+9lAwtse/GPTHQOOZN5drKQ0KRWoIHdnoVLCEryZdjQ9f7WnFL8al4RJ+Be+XvoTBpYjY0t/lsSqYiW6kPgO+GFJtLkavMOgsda6/CTBRil5/pysMLTNbJKoQxaXXKA3jgvHln2sv5jDA8vnKYa/eyb+Awt0B6aB7bmSAR2UxgXApCdzv3Ipu4qinZ4QVfhQbqXL/CUeDH2vXb+/3o0GkvqCTB+TKCs1PaRsSQ==
Received: from BL0PR01CA0016.prod.exchangelabs.com (2603:10b6:208:71::29) by
 SA1PR12MB7221.namprd12.prod.outlook.com (2603:10b6:806:2bd::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7719.33; Thu, 4 Jul 2024 14:10:48 +0000
Received: from BN2PEPF000055DB.namprd21.prod.outlook.com
 (2603:10b6:208:71:cafe::bb) by BL0PR01CA0016.outlook.office365.com
 (2603:10b6:208:71::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.29 via Frontend
 Transport; Thu, 4 Jul 2024 14:10:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN2PEPF000055DB.mail.protection.outlook.com (10.167.245.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7762.1 via Frontend Transport; Thu, 4 Jul 2024 14:10:48 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 4 Jul 2024
 07:10:32 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Thu, 4 Jul 2024 07:10:31 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Thu, 4 Jul 2024 07:10:31 -0700
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
Subject: Re: [PATCH 5.4 000/183] 5.4.279-rc2 review
In-Reply-To: <20240704094447.657619578@linuxfoundation.org>
References: <20240704094447.657619578@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <c62ecd11-1a80-4610-8355-f513f82750df@drhqmail202.nvidia.com>
Date: Thu, 4 Jul 2024 07:10:31 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000055DB:EE_|SA1PR12MB7221:EE_
X-MS-Office365-Filtering-Correlation-Id: 89167c52-ecc8-4914-74ed-08dc9c331a88
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|36860700013|376014|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RVJsYzk1c1VUZ1lQK3A1SGJhb1E2a2U2a0RCbE1qRWZPcEpwdVlJQ1FaSkR4?=
 =?utf-8?B?d3ZCckxnK1BzRmJ3dGpkWTdSMVlCKzZnNWkxWlRrRnJwbTBmcHcvVkloQ3RW?=
 =?utf-8?B?eEZRT3FXMllNWTJvU1gvUGdNeTAvUzhyV1V2VERXR2NIVXZaanMrVlc4OFVQ?=
 =?utf-8?B?V2k0Ynd4K2JiUy9tQi94M2xkSCtLV3dIcit2by9kRnpVOGVRYjhJRTJpL05W?=
 =?utf-8?B?MlVwelI3UGJ3cXVhOVFqOTdVWG1LN0x1MEpKRTZyc0tkQ2pVU1VFN1B0cktH?=
 =?utf-8?B?KzdMUXJtanFKc1BxcGdHZzJjOHcvRTArVjFicFFiNllFaEwwc1NkU2VxTVJl?=
 =?utf-8?B?MS9UQ2pKKzRldjhqekxwc2VCaDNyKzN6MDRhLzRERk42NEZhbFVNL05SUWZa?=
 =?utf-8?B?ZVc4Z0UydVdyRFBiR2txRG13NmU2K1ozQ0phL0V3Q0p2V2ZHL1hzOE9RSHlC?=
 =?utf-8?B?bXlZalc0UXNoT3lFbVI1ZFlSb3UvZkZYRWFBNTl2ZWgvNzFDTDRmaXpTMDNk?=
 =?utf-8?B?U2dYU0JIbmZsSUt6ekU5bXpvdlZQbGJzY1BXVjY2TDVYUlJ3ZE82N3VsQVZt?=
 =?utf-8?B?dmo2OW1CSjdrUlZvMzlYTWEySU1SZnVORmhPVW10cTFtTW4yRmw0Q0tLQVBF?=
 =?utf-8?B?K2trcjBYQ1ZDT29ZOXBlYXpjTVZmVlpMN0tvRVlPWXlHRXpRblZHL1Q2L3hJ?=
 =?utf-8?B?aUtRZVdUU0o5THZyd25ORnNzMy9CN2p6QmV6N1FvRmdjVzN4cWg5Z2J5MDc5?=
 =?utf-8?B?VFZKRTAwb2JLMkdqMlV2WHhyTUFQUVF2Qk8rSzRGRi9zcW5ISTFnelBub2pa?=
 =?utf-8?B?REcvZ0NWMEpXU2VxUS9mVmJhY0I0a2ZCZTNZMlVkK1YrcHFmb2g2b1N4bmRk?=
 =?utf-8?B?dmVLRkdySUJWa1Rkb3VYS0ZKeityN3Q4VHJGY0MxUlpjTmNTUHdFN0FMbUoz?=
 =?utf-8?B?S1cwTk04QUFhRjlIV2RLMTVOSnlVTE9keVNNUElaYXJqR3R4eTB4citlWSsr?=
 =?utf-8?B?dGNMeXBBeUZXQ3R6ZTQ1MmdqNXZhVEk1T1dqNkNnNVJjWGdaVmwwVll6TXBr?=
 =?utf-8?B?SmRlaDdkQ3VPRWYrWjNTd2k3WFB3QkthZkpLckpsbFh1U3dEQ2hvNGRmY0Z2?=
 =?utf-8?B?WWY3cHYza0tnY1lOVUxJTVIvOW1pcnl6SmtReU1KNUhjcTY0eGFmNGExa0E2?=
 =?utf-8?B?VUZjSTdueXYwcnVCVkpLckRWWTE3ZjRWM2pnVVJCZWZJc01hMnV3SkhvcGFX?=
 =?utf-8?B?bWVPNjNCendVbUhvNGFKYmluMUkzSDc4cmtDemIzcjZtNFpKTm5lTjNYZHph?=
 =?utf-8?B?cElOWjU3SGRrK0VzVXgyRS9oM2RYQkNNVDZTUW8zSkZSZmYvU1I2MFNvZ0pL?=
 =?utf-8?B?T0hJV25PN0VMY3F3S3ZRUUI5Q1hWRzFrY2NHZUp3NUFpancrY1ZBSDEzNkdQ?=
 =?utf-8?B?UG05cTRQZGE1a210K2ZHak9NeUlxZ0NTNnZPSzZHRlNRcGVtcFgrdVR2TnRx?=
 =?utf-8?B?ZkszMnc5UGJWU0hQY0lDcmhhTEJwcGFDZDFOMHdrYXcwMmhLVTIrVU9GQnMv?=
 =?utf-8?B?dW9KLzRSNkVjU1dPeGt2TFhOK1BnRTFyZjJ3Q1NxdHZsZE9YTTN3OTlWTk51?=
 =?utf-8?B?NHdXOGt6QWI2U1FpZkV6YXhsYUNSeEN5OWplQWgrL2ZETmtBT0VqVUxqQ2hw?=
 =?utf-8?B?Skp5RmZ1ZUMwdFhqdS9tUDZMVDBEc09Dc2syQTJKWHNUbUhBeFlYTmdZYUdX?=
 =?utf-8?B?aXpsUzJIRzBRSGt2Si9LbTJ5TG5SMGVmK2MvcnlqQ2dwT2U2WVFndGk0aENu?=
 =?utf-8?B?YytSa0xnVWh4elFlY3Irem1vN3BpdUwzdlN1c0ZxQTZ5MlB5Q1NEa0tvZkNR?=
 =?utf-8?B?bHFCOEZFb1cveUh6c2swOVZLcU5Kcjh1M3djWWxVcldEb1lGMkZHVXJlQVA2?=
 =?utf-8?Q?jzpWnbOgZs/s1Mi9fVj87XxEsRk6dZRr?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(36860700013)(376014)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jul 2024 14:10:48.0308
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 89167c52-ecc8-4914-74ed-08dc9c331a88
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000055DB.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7221

On Thu, 04 Jul 2024 11:48:03 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.279 release.
> There are 183 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 06 Jul 2024 09:44:13 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.279-rc2.gz
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

Linux version:	5.4.279-rc2-geee0f6627f74
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
