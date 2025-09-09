Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2041.outbound.protection.outlook.com [40.107.92.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A76D244664
	for <patches@lists.linux.dev>; Tue,  9 Sep 2025 08:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757405147; cv=fail; b=mChZ/8Ma2tymXOEuEBvCHzeEhkvKM48nj6CcF1I3MBnxokAIKDc9Mjfn0aWAzhxqiypTU/wP987eiQKE1cwGeFXXp4QJYskRprzAWSITaGewUhTZxubtBL79zDUHW3Wt/vZn83ndQl88LmCAtmOezPU1cYQW1hoLo7kdBWiomew=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757405147; c=relaxed/simple;
	bh=32BHqF04QEWLi75+bQJgG1OQ7ofpQB2EWClAAMkD0+8=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=qNghcletc6N9LmBQ2pjJjxNVItONGDa0n9SboLAJbBEKMlGwlObNUuOjJ1+1mzCbVjTmPaAdPZYCe+3CdkOAXh9hqOXQp0si0kziYiYh1D74Yv79ptbCh9/KYOrnUHO2RNOfh6Dh2gxGU4Oo4MiPbgSaZd3dnPi1zEIOaGXV41o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=VK75vdCU; arc=fail smtp.client-ip=40.107.92.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="VK75vdCU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K4bidSiGgMpeFyX1UxP0dMeHCZWwIgu2ovzGKfxT3RSFVusjIYFtvQ/JR6I3nOdP+Vt96EXNo/4633+nMaLI8tLb5a43S/X3AA0PF/al40OvdsJi+KY97FYr8gMkrKmcTaENg3cEmCFIOcDoXiGR3c9lfgQftKCOxq1nLMcdPQLl245cHAqMfHf0VmUDoqb+NuZyp6SRJE+sNIe+rnZSXQxlvyQQ9V7qnf6Zy4XSAGE4F/IvXvK0fiiQxCKOH7x6KSRS5iQpbQ5dOwx8M41RAaCn7G9BlT+tfG+X+NBanNZwGezdSPNomz5qRdm+4hr7uA5Xtb49M2U6WkU/n8oL6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7V8REQAuNTtCPjAQoYsGDP1Xy54/IObElTUYiwtp4s0=;
 b=EAJOqwm6DHDFiTR0ccyMOQHeuRxKJdkOerjPnNF8G0BLk4ZEtiP6HnizOQXhCr4TU1lAxQEci5IWJApGRtUsBFgck/vgUMIhLji/wdIiduJ0EH7c9w8et7yohdsBuK3gigtVQdR8A7ZitPATUmybdn9fJjCuLdQtDt4h+/0NGO/MhXxn7VjSUak03KoImkTnIKhhStXjFlQElr+aiU1Yf5XVNAiJUHXgv3oLfPT5Hbux1pN3VvIPsXqeRlmn/gzw6VNgdfwNkkW7lGYO2IxBuoCuLMfOAqTbh567GNl2UC2d+JA7KhxMW+IZNi5bBgtR7x2Jpf/hog3gxUBrtv2eNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7V8REQAuNTtCPjAQoYsGDP1Xy54/IObElTUYiwtp4s0=;
 b=VK75vdCUDKwdzwcOiSSTYGQM0vVITkGsiamhCrg+16/le1vzkuA6UGFKnDfJH9RQSYo6BwXtVzfTp5X+Wxh7T2YTeQb5R743+PwxbPPfYZ/03z6hccsQCw6ucHzse9rSMCwkstcLPw44SVWVO4YfTkOO7A35nDUu6uHluCARsMl6/SusuNJecdbz5o2sFc/+nE83DJMdO3rAAua7lO8hM/vkAIanh4tYaP039Tvap/Yb4YU8y4dqRPWhSFSPw8qRsDKOFDOSjv24+kKd4prmBic5YM71gBZnTp4jVU4KuNv0OMufm+K6CgRdBYV6/mS8GzXhp1DNhyASobJljE6yaQ==
Received: from SJ0PR03CA0009.namprd03.prod.outlook.com (2603:10b6:a03:33a::14)
 by MN6PR12MB8544.namprd12.prod.outlook.com (2603:10b6:208:47f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Tue, 9 Sep
 2025 08:05:40 +0000
Received: from CY4PEPF0000EDD7.namprd03.prod.outlook.com
 (2603:10b6:a03:33a:cafe::94) by SJ0PR03CA0009.outlook.office365.com
 (2603:10b6:a03:33a::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.22 via Frontend Transport; Tue,
 9 Sep 2025 08:05:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000EDD7.mail.protection.outlook.com (10.167.241.203) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9115.13 via Frontend Transport; Tue, 9 Sep 2025 08:05:39 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Tue, 9 Sep
 2025 01:05:20 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Tue, 9 Sep
 2025 01:05:20 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Tue, 9 Sep 2025 01:05:19 -0700
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
	<rwarsow@gmx.de>, <conor@kernel.org>, <hargar@microsoft.com>,
	<broonie@kernel.org>, <achill@achill.org>, <linux-tegra@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH 6.6 000/118] 6.6.105-rc2 review
In-Reply-To: <20250908151836.822240062@linuxfoundation.org>
References: <20250908151836.822240062@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <4aa900c7-ce32-4e34-b849-2d3c50ab1d2b@rnnvmail205.nvidia.com>
Date: Tue, 9 Sep 2025 01:05:19 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD7:EE_|MN6PR12MB8544:EE_
X-MS-Office365-Filtering-Correlation-Id: bed8da60-650a-4c31-fb55-08ddef77aa45
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|7416014|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MFlQWDZyT0VHaGFDWmJBVW1ZMDRIOVk4RW9ZbzNVenhHcVI1U2ZTTnhka0pu?=
 =?utf-8?B?SVFFUjV0Q05PS1ExeEFpd3RjRFJPWmlNeG95QzJTLzRhK3ovVEZVUDRPcVB0?=
 =?utf-8?B?U1NEaU82S2VWWEpUSTVkb3ZUTWFmZU0xa3pyVjk4eFpSSlROOG1yaWpIUHlJ?=
 =?utf-8?B?aUk2ZTlBbEVxa1JsWG93YlZ6WDB2OVJVL3k4MHQ5YWc4YnY2SytaaXh1aTZw?=
 =?utf-8?B?VTFjYWV4NXc2dU1abzMzZ0pXeDNHZUx0WTNyd1E5OXFWOW9oUElCc2JwWE5I?=
 =?utf-8?B?RmQxRTBGMHNMczhtUGZleEl0a3VteHh5YW4wb2kxMDdiZ2pYY3QyZERwbUFJ?=
 =?utf-8?B?NkNzTWNRbnUrT05US2hsY3lCNjh3amZ3VEE4RkRwTFBqMmx5Qnlmek9FRy9K?=
 =?utf-8?B?ZGJrR2orUkxCTVdkNGllOGRPeUgxaUYyMkVBTjg2TlJYMEh3SEdtNkN6Sk52?=
 =?utf-8?B?YUtlTTdzeUk0SFlzdkNmZkM4QnUwK3F6OHluN1pLOUlGRk1NdkxDU2gxZEtF?=
 =?utf-8?B?VnYxNTY4T2hvbDdYR2oxdDFVaU9Lak1qamtBSXBNcFdTc0NsRWl1NDYwTDNV?=
 =?utf-8?B?cnhpeDNVd0IzbEh3aTZWbVRGZFZFWW5sZnNzSmJZMDd0ZmdsajQzM0VGZ2Zt?=
 =?utf-8?B?LytiZzVZcFAxekxxUDQ3N001V2hlTk9tQ1RlZExMM3V0Rng1enBzaG9RWHlx?=
 =?utf-8?B?SDMrVDg4cTFzdVpVcEx6dkxnVUFVcldCYlY0cnpNT1ZvLzBYNStUMlB5K2hB?=
 =?utf-8?B?L090ZC9Ddm8yVDZycVRwSERpdm5ZQXF5VlM0enRVNEVwTytBT1JGanRUSyth?=
 =?utf-8?B?VTczcysvUHJhSmcxNHRGZnpwek9nNVpkY09lRUJCTDNSLzdMUTNNVXJMM1Vw?=
 =?utf-8?B?ay9IdDk2RHpKVVhsMTJvaGFXSmJESjdlVkdQeDZNaXBIV1ROT2VvS3FkQlFW?=
 =?utf-8?B?WGRBNzQ4Q2JiMkQzTWc0WEN1NTBDZ0VObG5raDNtSE9PNWpZQzc4QWpBZkdN?=
 =?utf-8?B?cW16L2tYUlh2eDcvSE1sTmc5S3VUOU1VOWRIK0RCczZ4K1ZzQ0wwbWpVWE50?=
 =?utf-8?B?SFRGcjhuT2NPQ2NOWXE5VE1Mc2ZQZC9CWGtNOHprZTduc2pDRHRWK1AxdStn?=
 =?utf-8?B?VFNYbTdLUitBQW00NVh6cFhiaW1xUUFxYVpEdTFHUjhYdEVOVVhzanlKRXNH?=
 =?utf-8?B?UWx1bU5RcXArN1RkbnQxTkRNT1lXQjNPb1pYZllaUWxjei9SMWtzTHBUU2dC?=
 =?utf-8?B?SEhheVJZemJmWUR2d0pnV1lUbUYySURVODJaa3ltdWVzMkZaMXNkaXNDaWww?=
 =?utf-8?B?WHVMQVB0Y01TZ2xIYmRYWUhVMG9OMjBDdmMwQzRaT3dobW9idC9iWnE2VG1o?=
 =?utf-8?B?Wk01RHpDbmVEclg1cXY1TEIxUG44a1daL1VXbVlJaDRSeGpsRUpSS21pQjJr?=
 =?utf-8?B?YnNTSC9hdHVUZEEvZTd6Q1J2cHZDV3VHZTJPeWY0MHpYT2NpZEFaUUhDTFIy?=
 =?utf-8?B?R2RiQlA3VGZaeVJZdlZ6UUdTbTNoM3JlMm5jRDhhdWhLUlFRdHZNZURsNmJU?=
 =?utf-8?B?bFc0SC8wQjNXUWx5ck5xVzk0a3ZHSnY3ZjgrZnFzNzdpNCtKaGJmQmYrcjJ6?=
 =?utf-8?B?Q1J2T0E1bkozenpRTzVhVzV1T3FyVmE2aitmTzBCV2l4Rkl4TzNqQ1lIeGFX?=
 =?utf-8?B?YnExWGtpYzN5aTNlRGZrbS9MWnFPZ0JKdndyc3pTUHZsQXNHaFQvQ0ZYeFd0?=
 =?utf-8?B?VjBDUS94aGVwZFVwdWxqK3hLUHZ0QmNQazg5bEF2bVRKdmcwQmpkcERjREZl?=
 =?utf-8?B?alZadHl4b0xiYWUveS9EUkN2emV4aGdFT1VPSWlUcW00YTU1ajlQSVRrekgy?=
 =?utf-8?B?aU1YY3FYZklGNCtHT2JadHpwK1BYNGwvcFM5TmhTamdOcVA0QldYcGIrYyt5?=
 =?utf-8?B?QzluOFJEQkxDRDhYNHNPMjUwZnAvTlVTZXBJSlJabllVanMrNzlhOHpvWEZw?=
 =?utf-8?B?dmE1Q1E2cHN4V0hGT3lvN1JhbUJRNUhvYnd5LzJKODVCOURQSGd2aWdXbG51?=
 =?utf-8?B?azNDcDZPS1E1eDVMTE1rQmhxcVlYUmpSMjd2dz09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(7416014)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2025 08:05:39.1880
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bed8da60-650a-4c31-fb55-08ddef77aa45
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EDD7.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8544

On Mon, 08 Sep 2025 18:05:07 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.105 release.
> There are 118 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 10 Sep 2025 15:18:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.105-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.6:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    120 tests:	120 pass, 0 fail

Linux version:	6.6.105-rc2-ga13907443c81
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
