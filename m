Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2057.outbound.protection.outlook.com [40.107.243.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B3BA17B4ED
	for <patches@lists.linux.dev>; Wed,  3 Jul 2024 13:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720013251; cv=fail; b=pexYBx/FE0Hj2zF+lQLWvGJHAqzaJXl30+QcYxCfHUzfzAYSQXB+BovjRxoVyjsm6eJcXO0NlZ/UClRkRpfp72j35JpamdZYax4foEahB8G8wArlbG3kVUkrMAJbxdxlGIMHUMNCvj7HqU7dpXzl53FEsq0JgTdDi3fZ4PYhD6w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720013251; c=relaxed/simple;
	bh=wG6NSR2OeLgKJVQSrUuZuI9labgBJCHIosZFpfCOgmY=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=V4vTY0JDGW+7GO6Ck+sHlSvVM9to2gtLNQQM3Dw4zX8OWYo8MgdRxUtHBUVW1+Ugam7TRfmIRvBW2B4lc/Zt+2OnSmhI7/2xi8CwCn0O49LcvHOQiMqSkw9hrj38Wg+3UYN/SoWRdR4G10ZBCiL77LJodwnU8pacZCAKX4IvvJ4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=E+SuontM; arc=fail smtp.client-ip=40.107.243.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="E+SuontM"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=brgPm5tCW2+wSdFombixIqA3StITEPIH1jcyJ74euSpfliY/Ad1wo+fNf7UjPOKR4T7pj4+Pz3N77dPODlD2axJZ1pETNLySmKF5ooB+0Tu//qx+QdHDz/9IoNlB2HGQL263Wh7WaPkV7k2oINfhGyq0Vs309VuTRlyc5xopW+/tQY1Mb0bhhmnk5lkUS0nGpxhY0R5dgs3FaJGrReX5yfVWNSo4wMYmpz0H2fUPybPE8RgmHXhZKzRzPlsjvCi5csROKln1qKITERkMeYss6WCTrr3QMQy+0rQIu5WR04nhD/pzkzUqCa/wEX9uZEVHFPMgvmgBC4s/tLEEIuPvow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dMzHUA7kTxkIvTeoafeWMf/saO5tTbVhQCyXjDefVpc=;
 b=PIWKzsKJMKxd0+WCJMgO0vvT2Hnam7/4ktAvNlE5kyCKWK22+VqqW6jQUt7QcCz9lgSC9PvaAPhWZ2HlisBidMj682nNodrz04EzpYA5+SMIcyyxpUxop7E5qE5XelUTavijSPR2gBKlMooXayty22iNWaZaBvp6q3eCXxvNL6S/s1bRvD9ARzSKB988rQJkMnODOKTzkrsE3Rq8ej49Y9r6ecfzZcf0DwWgd48QI9FoLA0pHMu+WSuusAfMb8FM52e2oWAkdZ+kfyH8DEdrRRgkeRcuvfwQ6B9xv1fbINlyr8LnEdAkUEmVTcZJ6kzRumxFsOCSzKMotk894CEGTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dMzHUA7kTxkIvTeoafeWMf/saO5tTbVhQCyXjDefVpc=;
 b=E+SuontMd+pDoJSDcSR1mYLn6EyAcvx2611juFu9mK3OCqKUb5ULLD+PvnQROAt4o4wdfUhCTjE4kqXqQmsDk0rEtYxyNtM/M1HONpbNZSA5d40LUb3TXu0T2CDk85UqFIYdCDdT96u8ajtHjxAH7zboM0NiXGwWfF6i0FFHvMoCf7ow+IDQGikrc4kTj+ocAIcfZG1u4Ux5EgxjAF+kPezaqLk8fRiK3JzJ+lvOi9Yeq2czc/ZWKRqGSQC6FXKrE2UoiryoUk3N/Pw93EaMzjsLxH9II/c5t0a9v6AAx9Kih4AW9xoRHlWkobXj4Xb2d2kd61IAwz1uzgDz5QyVEA==
Received: from BLAPR03CA0146.namprd03.prod.outlook.com (2603:10b6:208:32e::31)
 by IA1PR12MB6627.namprd12.prod.outlook.com (2603:10b6:208:3a1::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7719.29; Wed, 3 Jul
 2024 13:27:24 +0000
Received: from BL6PEPF0001AB57.namprd02.prod.outlook.com
 (2603:10b6:208:32e:cafe::30) by BLAPR03CA0146.outlook.office365.com
 (2603:10b6:208:32e::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.23 via Frontend
 Transport; Wed, 3 Jul 2024 13:27:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL6PEPF0001AB57.mail.protection.outlook.com (10.167.241.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7741.18 via Frontend Transport; Wed, 3 Jul 2024 13:27:24 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 3 Jul 2024
 06:27:06 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 3 Jul 2024
 06:27:05 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Wed, 3 Jul 2024 06:27:05 -0700
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
Subject: Re: [PATCH 4.19 000/139] 4.19.317-rc1 review
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <00efb5e8-dd97-4c48-9f4a-b24e61a0a17b@rnnvmail201.nvidia.com>
Date: Wed, 3 Jul 2024 06:27:05 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB57:EE_|IA1PR12MB6627:EE_
X-MS-Office365-Filtering-Correlation-Id: 5dd3510f-ee27-4b6f-31ab-08dc9b63e06d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aFphbVlyZzhnWlU5S1ZIK3pkWmRtL1hxWWw4SWNKZ3F4b0VNdVJFRmI3cS93?=
 =?utf-8?B?dExiZVh5aURwYXE1a2RVSlpXaHE4V2JzSXNhdlBTclkrRjBmQzFRR3Ivc09U?=
 =?utf-8?B?T0psWkhoSVl1Ym1YOVhsN3AxWFVGakhzU2tYOVR3dVFxdjV0d1ZQd3Y1K1dV?=
 =?utf-8?B?dzBvZDRCMG9mZFRzOVh4NFFxQXNGYnpWOWxsMGJzMFJYcE84cFpyTFRWVlpG?=
 =?utf-8?B?M0hIR2pvOHJuRnM5MGJBc0hTV3J5c3pwNnBjVmF3dlR4TjFjNkEyNU1HQzRW?=
 =?utf-8?B?NXlWRWdnbXluQkxEN09VbWluNThhYW1OTnBNN0NtdGE1eWFnUVFxUlVkb1da?=
 =?utf-8?B?c0o4dlJSZkx2dm1KVHFiZ0lpZHd1cjhFYXQzQXdZdVM1b3JNbmVodmxGcVlm?=
 =?utf-8?B?ODMxWmt4V0xvN29lK3UvSDdnZnNXMFRZbEFDNG8ycndrN1VLeisvK1NiZmFT?=
 =?utf-8?B?OFQwSlA4TTBDVjFFcHBHeW5pdlVUbmxadUlGZXRQSHdxYUtDdDk0MGtKZVk0?=
 =?utf-8?B?T2hlZjBkZERBb2FrdmV0M3hPNDNBUXZ3ak9FYklpM2VvRUgrVHV4cStPVzMr?=
 =?utf-8?B?eExIRGhiMm8rL3pFakNsM1dUMmw1cUZBeU5MQ3hzcm85cDhldmY0RERLRTAw?=
 =?utf-8?B?UlN4SEh6YklUMXRqSWNnSUtHaDNuOGx2VWdHeENBRmtSV0crYmlvSzJZUlg3?=
 =?utf-8?B?ZUVyRHk4L29DL0pRem94cHE0Wk16SElydjRaQ3NaZTBqTlpvZXcyNVpiRG5s?=
 =?utf-8?B?TG56YlNtZkpmbXZrc3hSem1CeVU1bGFmMUdJU29vRWU5eUZZODVFYmpTdU00?=
 =?utf-8?B?Mmo1Y0VOcEZZNnVjUytabTExWm1TcVZJU2YrU1YybVF4MXpCUTNmbDVEUUh3?=
 =?utf-8?B?RzRPdTErWGsvWjVRZ05pdzZSNzlXbFNwTXVZVTJLZG1LSUhuWWROZ0RPVWQx?=
 =?utf-8?B?NDZFVTZhK0t6eUlvRmVUQVRFSkhPZEJ4OHg1ZHdZT1RzUlNPb1VYMmNRYzZr?=
 =?utf-8?B?VGRyYVA0dWs4OUlLRFc2TmJPRzh5WmdkYkFGckd6ZUNzck1VVVdmV25udll4?=
 =?utf-8?B?Y0xFSmh6SDNrUHdSUWtpM1FOcG4rMWxoYzd4NzdDWEZuVmFCK1JpSVk0VlRH?=
 =?utf-8?B?cTlyNHZ3anNtUkJldUVrb2hpRnhjS0M2N2txU2FMUUhxMXBZSUdqaEVSU011?=
 =?utf-8?B?N2Rrb3g1MUVGOGd5ejVrYlVIQWZMcWUxcXBLTnREZll4QXc5TmhhV2RZaGVk?=
 =?utf-8?B?VktLeTkyYklMaXl3eno2UGkrNFZkUnZNMTNMa0J6bXNYL2VHZCtJZ0Q3ZHo0?=
 =?utf-8?B?T2dMWk90V0wrZEs2NkNiL3RacnRQWTB0WkhreTh2WHN1YTRQMStVeTJpQUp3?=
 =?utf-8?B?dUZEcFdWVExxWk1IZzRBUU4vaXJTbkxXQWFCcVU4dC92ZFdSeHhRKytjRjNr?=
 =?utf-8?B?SVRrZWRvY3NxMTlzcGJnSHVyWDFvN0RGcUppK3lvNWVPcjAzV3NEdTIvSXZm?=
 =?utf-8?B?RUJ4L2QxZjYwbFRCdFEwWWwxcnl3TVMzT0ZhZmNSRUVCRlNudUl1N0FaSms2?=
 =?utf-8?B?MEdxRWNxQkxieDJVYmpLYTBIb1YySW9CWFBmQUh3S2Eybk5oRG54SHQ5bXpU?=
 =?utf-8?B?aUJDWCtpM2dFQjRWejA3OHBSWTlmMytoTEF0RktZSmU1ZkZtdTdWOUNSZEMx?=
 =?utf-8?B?dk9kb01YbEFhVVdvVDNST25sNmh0V0xPdk5VSUt5UUxkaDd3bW5GUVlRR3lK?=
 =?utf-8?B?Z3pBcVpQNmpTOEI3MlJTREFjb01HOTZ1L1BCOGpkUGNsM003b1ZGZTFlZW5V?=
 =?utf-8?B?ak4xVjVFWm9zOXIyaDhMajBFbERhR1dyKzZmeGRJclBSbUFHc2pFa2xCazRw?=
 =?utf-8?B?Y0FyRDI0SXNQbWR0cW9TZXozNTFrbm4xeTkxSlNPWGdlNEQvVjVtd1laTisr?=
 =?utf-8?Q?+PbNC6b/DZzh/GI8qSN+hSCBs9dVHHye?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2024 13:27:24.7212
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5dd3510f-ee27-4b6f-31ab-08dc9b63e06d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB57.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6627

On Wed, 03 Jul 2024 12:38:17 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.317 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 05 Jul 2024 10:28:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.317-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.19:
    10 builds:	10 pass, 0 fail
    20 boots:	20 pass, 0 fail
    37 tests:	37 pass, 0 fail

Linux version:	4.19.317-rc1-g485999dcb7d9
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
