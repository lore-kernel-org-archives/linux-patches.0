Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2040.outbound.protection.outlook.com [40.107.92.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F62D149C64
	for <patches@lists.linux.dev>; Thu,  5 Dec 2024 14:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733409570; cv=fail; b=dtaIsRIfyABXYoAJ04fwUAONSvS/1KtMlwDI0VGtV+iqjKUhr0Ep4WKnsLandzJUUHuIZ3krs4oEqvOf+ktFOrHXrkpwbFT/mFfmVIFl/8w6RMHNf6MLF1+7p27o7CL97YoTPa85vX96in8AxvmLSt6bwkNoGXQD8/FfHhu3md8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733409570; c=relaxed/simple;
	bh=qWHQtgJ+b4winxbSHYhedtNfr5CD/eEkvGOXzzXsRgI=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=ikXEOpZeH774sHqjoDtXVKJkh9Hf5y5qzl4SmVqbqm55zniZ6xCWcIJ7e3SX44NEDdN1Q9T0A8F9Gezg/h4u8hi+k5Uhijeok81s8ddsX5QyOMspkBKG/lUX/My6FiNMwEC7FXM32yqkDVUIVpnQB2XlHlbqM6JuriNacQanJHY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=mJcclSOs; arc=fail smtp.client-ip=40.107.92.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="mJcclSOs"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KgF8SVyOD9Kyu/Chs8otC/erLIwQjlEpEOx8ZOJFyOvfMamxVU0XTwWguJP6+uO8+oih5ZEz5F+qL8rqmbHWuwbQ4taK91C2nRsPFswcnkUHbV+gapPan63ifsuWD0ve2b6z6IcB9O5CgP3QgnXGGIg4REWLDpunBYjSqOgs/DT5tSHyHnmgYYb/WteuGvsZFqubU54gwM08fTtW2qfu+7RifaPBSVtdYovAKZmoyzuU48psuxei3r6ySp+zxyd/I6JrcxnmtpV5IRCy1r3Nzf6vWufftlDOvoS34zlqBO2aa0ovbgeD5iEF3uCJvwyZStIBBPWas9HjA4L7XK7ysA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6anflDfq6nS/l4aCyGaEBthOjlmcmm8mzKj9u2SllNw=;
 b=aZxhA1qGGZM6fUmcm64KKVzGzp+lRKDrAn5HlsL2Tmw/kscQfcBfjiMXOvQL/4VTcC7BLM5TrkLS9BaqYKmUOTw7Sd4OEWrQ/mzrW42zUTpimtA+m+7c5opcU2ua84UsRHm68B5DsL2+m8Kg+yRiBgfouoWdB1NVEGnhoTX9TYuX+oynMc02o12ZCOWMjxiIz10zZlAZ3Dbgd3oj39LUGesi63u1nJ42kOCSdnQIx53ZC65D8r2TdBs25Wt1WnfVLm9VMve/Mu+UJryftKrztsOoumKrtdAseT0G431guSJ6beMJr+2lqxsxLbENs7afktOIgXnp//3uhuyQ1ECwdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6anflDfq6nS/l4aCyGaEBthOjlmcmm8mzKj9u2SllNw=;
 b=mJcclSOsSoNLFZz5Xla1BI1H2o8kN1NzicmuSe6OddyXplij7eSsU35SXGSUoRBlFRraN+B226sne5dC/75BYBCnaNVvL20AY/+BabjJ81eIFluIkXn0OrZcOprE+13dO4tyNX0It04p3UCDEyAk31hJOAed18ZTW34rUhDGW0SVwXg6WbQtvYHySr3RMhFNa95oiOV8h7+IrNXNEqZXy+lOCs6t5GxPIGaAqHTbSj3VoL2n49cbWLqM6L/L5k+w3pArcd4l0rk/3BrUqSDGNQ4gRRSaMNX5AZFY9Pn/+VoQReenaM4aRiSlZ03WliL66u4kqYjdOkUiGCIcvxNGOg==
Received: from CH0PR13CA0003.namprd13.prod.outlook.com (2603:10b6:610:b1::8)
 by MN2PR12MB4253.namprd12.prod.outlook.com (2603:10b6:208:1de::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.19; Thu, 5 Dec
 2024 14:39:23 +0000
Received: from DS2PEPF00003447.namprd04.prod.outlook.com
 (2603:10b6:610:b1:cafe::d5) by CH0PR13CA0003.outlook.office365.com
 (2603:10b6:610:b1::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8230.10 via Frontend Transport; Thu,
 5 Dec 2024 14:39:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DS2PEPF00003447.mail.protection.outlook.com (10.167.17.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8230.7 via Frontend Transport; Thu, 5 Dec 2024 14:39:22 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 5 Dec 2024
 06:39:22 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Thu, 5 Dec 2024 06:39:21 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Thu, 5 Dec 2024 06:39:21 -0800
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
Subject: Re: [PATCH 6.11 000/817] 6.11.11-rc1 review
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <525de045-eab9-4346-b4b2-b2111eac38ff@drhqmail201.nvidia.com>
Date: Thu, 5 Dec 2024 06:39:21 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF00003447:EE_|MN2PR12MB4253:EE_
X-MS-Office365-Filtering-Correlation-Id: 0cc678ff-3135-4ff0-80c4-08dd153a9c49
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|1800799024|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QmczL2lKVFk3K2RqTDFZTDZFWEVkdGhTS1kxTWtIODV1V1dmU0ZzVG43cVVm?=
 =?utf-8?B?NFdycTBNOWNRaTM3S2RDRldrSlJoQTltS2ZxR01WUEZzMXFCZFZDWlJkMi9D?=
 =?utf-8?B?L04ra0RnWnZtdktiVUN2MTVMckt4S3A0NlE5RDNYc3JqdFhudUdJVW1LQ3V6?=
 =?utf-8?B?VVQvWUlQcDVDNHVPYy9yVVFLWkFzK3pXWnAyREJBMVE4U1RtZE05bEJPaWl5?=
 =?utf-8?B?ZHA5UTVmaUJnYklVK2ZKc1ZoL0ZyR1JieWtGTENXU1VkNXU5SlE0TGVuYlRa?=
 =?utf-8?B?eGhEbzJkbnZZR1h0U3VSK2pjMFIxWWpsYXE1MkpoUVdKVkNkL1R6bytDeHRH?=
 =?utf-8?B?RGJzZjBHTVNTVnU5cCtJWWxabUFjR2cya0J4L2t1UU9JdHdpZ2V1elNJMEY2?=
 =?utf-8?B?ZW1YQ2FMejdsN2xUa3NLaVFyVGtBQW5BK2c2UzRVY1VtaDVCd1NmVkVrWlMy?=
 =?utf-8?B?Z0FjcHR0Q1B4cmlrWkNXWHNva2JOZTFpUUtZeU1zL2FFZU13QWhsL2pkTXJ5?=
 =?utf-8?B?eW9peUoxaXY4RnlEbkZOOWdKWE9SdnJIWkwvTU5rVjRGUkFmNC9rdlRiS0hP?=
 =?utf-8?B?Y1FPQ3VpZWJZVXpRdFAvaTljWWtjWkdhblZuSFhkT1dLNUZuQ3FPWnQrbHY5?=
 =?utf-8?B?V0NPc1dlcFhLYXpHUGRISkMwNlA2eEw1Q3loZGltSnUzeUtJVUUzYjhkZ0No?=
 =?utf-8?B?OStiYm1pclErVmdLTm52VWw2VTM4ZHdkK1hVMm5xM09YU2pjNFg1UkdCSWhS?=
 =?utf-8?B?bHBaV3VobGlBcGc4Znd6NUk5QjcwTmNXMUFWU09NeSt4M3Z2RzdhOVMzOHE4?=
 =?utf-8?B?M0xxdml5SFFzTEJXazlyaW03YWVqVWw0Mm1yWjV6ZXYvMkpHd2JhU2FYU1VD?=
 =?utf-8?B?ektPZk5kcmZldmlpblkvMkJEWGRWMEVCZ3Q2N2czNTJOSjV0bDA2QS9BNjRE?=
 =?utf-8?B?M2FyMGxDbk53MkZlNFYrMHhxZUJKNGlMc0FhYnY0M0s5ZDFzLzZXbVhmVVVa?=
 =?utf-8?B?aUljc3U4OS9QMzk1alFDUU9RdHgrT0RtUFJBRVkzVUtkWnFidFk5eGFnR0Ro?=
 =?utf-8?B?REIrRWt5V0x0aWtLaEJuWUVZWTVCdXJEdkxtMGdsR1pBaE0vdkFWZnpZNExB?=
 =?utf-8?B?U25sRG5ibXJoRFppMXN4bThaM2NUU2FIWHdsSTUrczBrODdiaUEyVmZzUmFo?=
 =?utf-8?B?Y0lyYXlnRHREdVc5NlkyQ2lNWVBhcWtBU2NIYllhZm9tcXdtTlIrby9hVHl5?=
 =?utf-8?B?WUoza3NYYmFoY01xZkx3ZHR0SnJmSEZhdXowTEVqaWdaMlVzekNTRWtsUUJh?=
 =?utf-8?B?eFJoMVFIYVlodmZXRE41UmI1amQrOVlvVHhpSnR6REtweDJqMXZnTERYcFM2?=
 =?utf-8?B?Z1RUVVNnRVl1Zk9nTFBXS1JKdjJMQzRRTXJ4cnRIQlVDb0VpV29rUmFqZGdr?=
 =?utf-8?B?VS9hTjE0UVlqbDBhejlYdnRuTzNPb29Pa0w1TnFmM1Rkb09WS0szdks3aDF3?=
 =?utf-8?B?MVlLMEI0MUxJU1ZubDlCb3hnbHBxbWg1M2RPTk02WHMwc3dBU01RQk9kTE1r?=
 =?utf-8?B?bWdjbDE3bkxqNVkrTWlOSjU5TEMzQUhJajBKMEJIeVhtT0xvdjhYbjNjRXNM?=
 =?utf-8?B?RE1nc2RmQWxKbVdITFhFOExEYUJDTkIrUWcva3A5Q3RSOFNmZzBQL0VZblBU?=
 =?utf-8?B?K3k2bVcyajJuc1MvaElHcUZmNkRLcUVUWHZ2bXRITFZRMHNWVHF3a2duR2Qy?=
 =?utf-8?B?Y0ZIdE9EVmc3SkZiU1MySDVrVWVGamN3eVFaNjJoRDZQSDZBdjRFMVZYdVRS?=
 =?utf-8?B?RXpkQldWUkswdSszc0F2VXlONm9tbkhyME1nbHNmYVVzRDVqcmJyenExK29q?=
 =?utf-8?B?bkhtdDQyTWNRcURzeHZFN1NCSlQ1ZElQRzAwbk13SGRmdzVFK1JKRkRHWEh0?=
 =?utf-8?Q?Y1D/Qlwg3u8a330KMfvptDl9L1cj4Rxy?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(1800799024)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2024 14:39:22.9265
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cc678ff-3135-4ff0-80c4-08dd153a9c49
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF00003447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4253

On Tue, 03 Dec 2024 15:32:52 +0100, Greg Kroah-Hartman wrote:
> -----------
> Note, this is will probably be the last 6.11.y kernel to be released.
> Please move to the 6.12.y branch at this time.
> -----------
> 
> This is the start of the stable review cycle for the 6.11.11 release.
> There are 817 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 05 Dec 2024 14:36:47 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.11.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.11.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Failures detected for Tegra ...

Test results for stable-v6.11:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    111 tests:	109 pass, 2 fail

Linux version:	6.11.11-rc1-g57f39ce086c9
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Test failures:	tegra186-p2771-0000: cpufreq
                tegra186-p2771-0000: mmc-dd-urandom.sh


Jon
