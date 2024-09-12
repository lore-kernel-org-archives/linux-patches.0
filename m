Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2057.outbound.protection.outlook.com [40.107.243.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7DB318BB89
	for <patches@lists.linux.dev>; Thu, 12 Sep 2024 07:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726125508; cv=fail; b=aEYhcVM7DwfJabgdiMjV6wyYRrEW25k5b7O3DzfyCXBn28vBmS479Cb3aGbeEd9OVZ9lwrMHEUuqpOEE4ES5mdVHMYnhkSjlAVZQ4rBLvBHs1p7KPtLqY1Tehu4TOQjHrPKFs6Vcs+kMyx37tzIlDb6lHK5yofLwnQtzeaPMA90=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726125508; c=relaxed/simple;
	bh=iarK1BJHKHAOypwofwjlfvOxT4XD2AcgkvKCxFpB4F4=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=EyA2nKnmZcfrILhMTKxbPRiQi9TZt964whPNDexhyPt682rwnqbPWOtLhy7xmkwdcuoGkVg5G51Ij02yfrxjO2olw9b5E4lcAFtLeyiR7U1XX/PQtoB2qkBpuRSfdkPTl1ApxaIZ0rY0i8A4sugtBasThYWdy2UJ8tDDpTx8VIQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=q09yaVg0; arc=fail smtp.client-ip=40.107.243.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="q09yaVg0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZGoA+agiFJRzK44NKuuuIOPO2jbTu3XDAT+U3rCchOB6lh+kd6YAyf0WD21AZCYOBEfSndBZKTGdxySHWWBb4Kif0fpVX2d/WM/1tZYmRY8tbBQ7Og/zscSEP86YN1ePVfH3P8IxyCUfoz0/6UePcytxFmm9dmKDtJw8CEyJEo+2tBRoI3aVQBI/0JtR5Hn+v1CXbgKkEht6j+IqfCQ0HNTkaC7qX3M2HEzKJAtyL+PDsufFFbKSfhorSeyzxm3rUUm8SirCwtrIMtUpH2jVQNC9AzGXWZ+YBFcIa5qXqcLMWlsDkV9Y+RqoZXZ8DurLOIsLqY+MCrkv2E8X+x2c7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RBODeiptA80xsrWm4aWdALLAcD3iS0vvUtU5t/b5+OE=;
 b=TOIwe+4Bh335FVqKfL5dFOvg1PmEYeRUOi1w+AMJ58J41SwBml5Kn3ydZnAbBa0vRcPnnV3+VWNu3W65vY4w51GmwuHMgLOx/mDehJxlmujvkXGt14LbvJBpRcJO8xuuYJc2IK08lP03scocfSIx6wtkAox5NWdLfaLJYnlB0MEFx3n2nVwVWOXB29RSUGNisM8KKmqgxzrsjBx6w+G2hgE+eRBj0LYV0ZAyzZokRYDlFpxEfZmzzsjhUv/kHLm8/KVwqgweEitz89TnvaL6GWVd96LLNjs9R7GxfT7ZOr0G1RJKSOlWd3j0gj3h6mjIKzNvcdVpMudm4Ag7hZfi9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RBODeiptA80xsrWm4aWdALLAcD3iS0vvUtU5t/b5+OE=;
 b=q09yaVg0fndjXHboQFhxoYH/RXL6G5FyFXejBix56zxkFXCTLGIvMAAdnfKK+rOr/8CLW34lP6ggHJ2kOyz4HTeqiN6ofoEfyBDwEsprv71shYqYEVna3VA20ljvgqYmXwC3RDp4lY6FnA6qJvs37Yc6lti0kHFG5YQ6d7pKiZuzr5mUA80rVYWPBzyFc/nblVoVG2+8yP1vbZ1qtGWGZqq7FoxWxmJ2sn3AeHvd0MlSBQ4hcbCSrnNy8aWGeSHNbLiy11f6uHrvdwsie4kYffPNjFD+fir9A1mtCANBot/kWRrN1GayO4Ews8fId66b6JLBSFv05Vm4rqTNshAchg==
Received: from MW4PR04CA0332.namprd04.prod.outlook.com (2603:10b6:303:8a::7)
 by CYXPR12MB9444.namprd12.prod.outlook.com (2603:10b6:930:d6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.28; Thu, 12 Sep
 2024 07:18:08 +0000
Received: from MWH0EPF000A6735.namprd04.prod.outlook.com
 (2603:10b6:303:8a:cafe::e) by MW4PR04CA0332.outlook.office365.com
 (2603:10b6:303:8a::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.24 via Frontend
 Transport; Thu, 12 Sep 2024 07:18:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MWH0EPF000A6735.mail.protection.outlook.com (10.167.249.27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Thu, 12 Sep 2024 07:18:05 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 12 Sep
 2024 00:17:50 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 12 Sep
 2024 00:17:49 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Thu, 12 Sep 2024 00:17:49 -0700
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
Subject: Re: [PATCH 4.19 00/95] 4.19.322-rc2 review
In-Reply-To: <20240910094253.246228054@linuxfoundation.org>
References: <20240910094253.246228054@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <58a4c4a6-5bcc-4cef-a274-57434f1e97f4@rnnvmail202.nvidia.com>
Date: Thu, 12 Sep 2024 00:17:49 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000A6735:EE_|CYXPR12MB9444:EE_
X-MS-Office365-Filtering-Correlation-Id: d6448d94-545b-44c3-a522-08dcd2fb0be2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?KzlKVEMwOC9NdmVQKzNYMkl5eENQQ2hyQW9pTlk5aUszZmRMVCtMeFIxS2o3?=
 =?utf-8?B?UzVFUEpHaXhTVUNINytSZXIyVWNBSE9IelBQaFRBSXdnaWJQbUhBSmxNcldB?=
 =?utf-8?B?aXNKdlpOT3I5T2VEd1RZSW0vaWdCRTA0SU1RSGVYUjQ1c2FWZHYyVCswaTBh?=
 =?utf-8?B?eGE2QkRPWWRGVTRvS2lVaDRhMWRNaWpwY0R1NnN2ZDI0NndjTWN0cTlaWjhG?=
 =?utf-8?B?SW4rK2dWZGVoMUM1d2pack9jVDB3cWNwOFpweTBFTmhEc21RRWIvTkM1bG5M?=
 =?utf-8?B?c1VxTlJ2K3ZTTjEyOEtLNjNWcjljaTRGUnY3V2tTNEJ1Wi9XbExhU0trQjRn?=
 =?utf-8?B?UXFmUHJQOThhbDF0NDRteWpqdG54amNlL2N4Ym5wSWdJaGxwR1Y2ZUlkQ2Vk?=
 =?utf-8?B?am9KNXJXWGNJME91Qk5OckZyUFJpOUMrQy92OXRjalZPTFJtT1RiNFhtUGJV?=
 =?utf-8?B?ZUpqVE5DYTlYT0gwVmc5OEZVNTB2TEYvQm5PODlaR3BoSXQxTDQrZ1JnVENV?=
 =?utf-8?B?QWRBNDdaTnRlUUlmMmZMM0gyYjFES1VzZFpldFIzdzcvdE1WUmRjRi9hS25t?=
 =?utf-8?B?ZW5kR0wrMzI3TWtuMjRwTjNrSU52aFRsVmtzVG5qc2piWnR4SkMyR2Q5OVlC?=
 =?utf-8?B?cDFUY1JXbWVubGRPZ0RHZC9zSy9OendVN0ZGK0pwRWd1ZnlZSlpVNWdxTWVL?=
 =?utf-8?B?ejRzbnBmYUFWMEJGV3JocVhJZ2MxRGpkZzlPWmNpZFQ2UGNzanY5WDh4cGJT?=
 =?utf-8?B?NkNBL3VQdURPWlY4ZjZVSDVSSGdHL3B3RTJBVzlPSHRsWGtOVzlwc3hUSENT?=
 =?utf-8?B?eHcyaE1zUzNWK3BhcFJyekhya1k0NkU0RGFtSjVLL0hpK0F4MHVCU09CVUll?=
 =?utf-8?B?M3RyMGc0WkVaUzVoTnBvZlRvZFhZQThUNHFkbzRFcGRpeFY3RnEzZlcwTGQ2?=
 =?utf-8?B?L1BtR29LVTdVWEJEZ2FoenZGY0gwaHBrVk9zTmZTckFzNWM2QXF4cGtzSnhs?=
 =?utf-8?B?aEF0cCtQdnBhZGdLajhCWHRDQTNIZlpqSXJpYk1nNnk3dFlBb3ZtQUFQNnM4?=
 =?utf-8?B?MWdDMnNIdGVvQVQ0aUdYMDBMNEloSFJ0a3M3b1ljYUFHQm41RVFac3R4dCtW?=
 =?utf-8?B?K1FGVmtFOHVDUE1aZlpuVEdxL2VScmVWdE1SUVBMUmk0bUpVT284U0o2WmFX?=
 =?utf-8?B?cFQ5S3lhTTJjN0tDQy8ybXk0ZkNDZlZTekN3ZHlzYUxObG43MnZFN1kzeGdR?=
 =?utf-8?B?NSt4N1orT2JjaHJDVGRJQ04yOEZmWEdtOFRvMXJpMjNjbjR3anFXNVZ1Lzdt?=
 =?utf-8?B?Q1MzNU1LZHRNWENhbWFnT1Fka29GbXZuSDFYdWYrQWgzczBKbzNYV0haendz?=
 =?utf-8?B?bmxvYXV5ZFF5STM5ZmQrYm45a0M5c0ZxY094OU1SWkpxQUp3TFE5SzhXVnJL?=
 =?utf-8?B?NFpHbkR1WjVWUER6MThHY2NZQ0xmdE5PdDVFM2VEUnBJSFZjd1IybzM5Qkpa?=
 =?utf-8?B?N2xiRUl4OTUxNWdhM1dLelF4NEdlL1RIdEVHU2JKTUV5RmhSQlN4eFdjbkNu?=
 =?utf-8?B?VDFyTDN0VEZkQlR5ODNpU0IzMVRCV3FIVzF6ZUg3K1V2VkNlZTVWSVQrN2JS?=
 =?utf-8?B?ZXVyUTZqTmlLdGkxZHI2MXF0aUZXM2NwVGdIRG5qM1pHM2E2dTN5dGpNU21n?=
 =?utf-8?B?WlQzRHdhdGdlOUFhbEFoNHNFb2xENUNRU2VrUlFRSlFuY1R4bUhleVlzTGJI?=
 =?utf-8?B?WlhqWjBjb2JMU2NvSWs3UU5jalc3ZXVwUTZzMWN5L3YyMzRjakc1Zk05VWtZ?=
 =?utf-8?B?clU1Vko0VlpGZzB4YmlZWVowcFFXY2xRZWJyQzNpdXBNTGpQZ1FCRisxaTAz?=
 =?utf-8?B?M3BuRzE1L3FqaVVpSTJiZStKdm9wazYyRWRVUitRdU1zeGp0SFZYV2R0aXZm?=
 =?utf-8?Q?Cgmvy7vpjV/lnr30Iy4zeLE4Ov33huZo?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2024 07:18:05.6388
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d6448d94-545b-44c3-a522-08dcd2fb0be2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A6735.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR12MB9444

On Tue, 10 Sep 2024 11:43:06 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.322 release.
> There are 95 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 Sep 2024 09:42:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.322-rc2.gz
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

Linux version:	4.19.322-rc2-g00a71bfa9b89
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
