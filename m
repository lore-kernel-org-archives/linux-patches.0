Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2042.outbound.protection.outlook.com [40.107.243.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1863B218E91
	for <patches@lists.linux.dev>; Thu, 24 Apr 2025 10:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745492080; cv=fail; b=ScXUdnxrei1tM2RDMCmbXt+VeY89+Vr5QtlVGWDGcZusJl8IzotnoKX8dyM044LyA1OdCVayU8of6mUJBkKJN+G9jWNYYgiPr4bSPMhkW74XBYDtw4ZqCkelUHvAzgdp3AJEXggASI1D4HioNnXR/LTzzsgsDMgh8pp2XJlJl1Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745492080; c=relaxed/simple;
	bh=CwvAOKJ/1CSOts9iQODEaXYeLjv1UWy3+NPB6vx7pMI=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=gMk5wJ2HgH1G14ZiaHxz2HxFIypBVrc4cldhfrCPrpcVRP2+4xKMX2jcJGe8OeVTSl+7+6LGX+j2t7sXZiRXfz17LNY4xFxfn8/rUMDlGK0vFaXNZtk2Uz2XrgAOndqONgI2HoQn3QIFl8bmS7/DBNCTiEnuSlj2S/4YrrLzh2I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qkjp4If1; arc=fail smtp.client-ip=40.107.243.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qkjp4If1"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ym1xyExIRzcbG84haqu4QVRQ0y/CrHJ9Z2sGt6/kzf03UTXsgNiSs13BKQi6Sgkpxg41dJaztc37PXDWQFAog+1FNWHYxBKwj3kRfHw9IXNVY8VAdatvw7QCYSD8mLDT+8s5BLHb/5jYKbuUNINEAYRPXWdJp7DuHl3z+cREenA8CbT6bhRcHojdztOkwyUNR3YjK4fmdgxoKnYvVCjkyk1TYL2OtvzrPo8l7dx5iyjymHolgqVHWYZEoSbb4o/dLNtcAsyBA4RdPsYSRlGPNW2WW1tVKa807dGk7hQvYFPSJEzIlI5dfNKdRZJ2MIqo+LbYwNDRtHGAorJwhvI2RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FWVIQAie1CkA45rsu/cm5AYP5wAYs/nGtpxHJOpN+aw=;
 b=EcfZtSfkh1lKJ6sjyVbYJS45JG6K5+qF31B2Q1dWdUXzhzB4zusUqyvytGqSYUDL9LoiKkhOheurXogCmjcsV1Aupo6PA6EwesWeas7KaKfiCmSHl5m62psPf1wHhqhxwEfLtUBuXfpM/b27MNapAcRqOQmXbhNbQC6IA6k02MBGcDYJzG2ZOPzY/0fjf2UsQYwCPVU1hstZhDTjCnxr1Xg+MU1kZJ+5Lyi/rDZp5oXpO346EDN1o6LrgAuQAasFxWHj3MBeAbrtKA49pJtJlJgdWvWBbPr0HWvMpxtAzRU9jLDZemtG3OAmOqRpvLYvH3yhjDsfqj4MUbIP31bEOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FWVIQAie1CkA45rsu/cm5AYP5wAYs/nGtpxHJOpN+aw=;
 b=qkjp4If19+UtC12QFgr96Etwlrscl8H7zHwVnPG0JmKSgoetiD22sEuc1B9UZHHHH/2Gr8ziKBar4kyiSX58YFo4oDWxcSnTIs4G17waWDXpnvHU05XXiGndUnFwgzJHDbjk9T+MmIkhb3d1HwX/TtiDFpgBjC8z//KYZpGt4y6BKsGncEa1ciHeQ6uhN3ETzhw12ajHlmjs1AVtES6rVJXM2/5o467fyT7OHwi/7p4uYim++CvUOlBYUW3V1/CIMC3jbKgLPbHSqLZQlwBX/3svkZYJjAGi06fxvPwMBRYQtHSb+brrsrcZF76ufLTVPsSkC9XdIobx4PV89zvTCA==
Received: from BY5PR17CA0053.namprd17.prod.outlook.com (2603:10b6:a03:167::30)
 by IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.23; Thu, 24 Apr
 2025 10:54:34 +0000
Received: from SJ1PEPF0000231E.namprd03.prod.outlook.com
 (2603:10b6:a03:167:cafe::b5) by BY5PR17CA0053.outlook.office365.com
 (2603:10b6:a03:167::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.33 via Frontend Transport; Thu,
 24 Apr 2025 10:54:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SJ1PEPF0000231E.mail.protection.outlook.com (10.167.242.230) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8655.12 via Frontend Transport; Thu, 24 Apr 2025 10:54:34 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 24 Apr
 2025 03:54:23 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 24 Apr 2025 03:54:22 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Thu, 24 Apr 2025 03:54:22 -0700
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
Subject: Re: [PATCH 6.12 000/223] 6.12.25-rc1 review
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <717dd414-2c81-4446-a2f3-b0c9b131161e@drhqmail203.nvidia.com>
Date: Thu, 24 Apr 2025 03:54:22 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF0000231E:EE_|IA0PR12MB8374:EE_
X-MS-Office365-Filtering-Correlation-Id: b066bcc1-0780-4bd8-30ca-08dd831e660c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|7416014|36860700013|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dDMvSWlXcGxaWm9LU0NWcjlvNm5YSTI0cThlVGVyUExQOTFwblQ4aVRNd25K?=
 =?utf-8?B?eGVLeDVTeStET0E1Q2h2elZmQlYwY2U5ZXJ4cjRjUXpFc2tmWDFuUkN5bC80?=
 =?utf-8?B?UFBMakxzOW9lcWI5ZTdlOHdCYldaTHdGUnNtWFBERmxCSCtwaCs2Y0ZhRmJZ?=
 =?utf-8?B?N2xJT2d6YnQ5WWpXUEtyN2gwL0puM1JvSWU4RkI3R1ROZGlSM21aekxOa2Zj?=
 =?utf-8?B?ZnEwNUNYU3hwR2JyTytrYnNTUFF3ZGhBMXlDWmhBdXFjd0dSOFhQNXV3bWR0?=
 =?utf-8?B?QUdkWnRPeW4vK2FKUmRMQkZZVG5LVFFsV3hjOWpDTXBzSWZ6NWduMmlqcnBi?=
 =?utf-8?B?bzdEZkZ5eGFaTkFOc3RSbjNuT1lOdVpsREdKTnAzeVVCdk92T0IvWlJRdUVC?=
 =?utf-8?B?aWp6ZGpKdlBua0t4dkcxSG5lWHkyemVFdCtyMXBZS3JObnRleUVSRVdmTGU3?=
 =?utf-8?B?WTRaR2RhOERoWmwyYmdQdXJFaXV6akExNDRlUW9abmtheVB2eGg4N2dzZGk3?=
 =?utf-8?B?anBWVDBsSkNKYnppdEdlVHRja3A4WVp1RU1DZDdkSVk2RkkyNDIyZEptTm9Q?=
 =?utf-8?B?OFJsMDNmb051dlZSa0hNUE9YRlBKZUhqRGJzbkw0anF5eGYvc1VCLzdUNDBs?=
 =?utf-8?B?NGh5OWdhVjBWM3VodklBTGs5T21ESXBSaVJPa0FsR3VnTmF6akZ6bFNXa083?=
 =?utf-8?B?dEZKSHVvZHFVNjRTRDluamV3eFFHSUlFRHBwcnp2VlhUSTJVRWl1Yy9Zc1B6?=
 =?utf-8?B?NUxIY01od2pJekQ3Z0t6UkxXZGdGWEVBUnRNQjlUSzlWZVNhRHp2R2JJOFcx?=
 =?utf-8?B?UEljcUNTYlBMTHVZK3dyTUdRYWdzS29jc1E0Q1E0QUNwNmNlaEE1QmM5UlNx?=
 =?utf-8?B?Nk8rSC8zTEc4MldjaHdiR3E5NU1vVHpUMDBsbkF0eTBnMVFQZU1uZGJvN3Uw?=
 =?utf-8?B?OEw5V3pLS1QxbEMxKzhtM1k3UlBweCswSTBiVnVHRi9wai9yVzZLRzBHZk9j?=
 =?utf-8?B?NG5MUTZKb1ovVHJiY1IzckVXYXp4VUt0TVQyZ2g1L1ZLdERjcUl6WjJzTlRP?=
 =?utf-8?B?S3lXUXIrY283Ulp3OXF0Vmtqdm9yMm44Nk9GUkdyNW50VWZuSDNEdUdpM0VW?=
 =?utf-8?B?QVBpOWI2cGtMZjdacWhhaHY3elBTUnAyVTN6cGEweDh5bnVubVpYQy9LdXJt?=
 =?utf-8?B?SS9idFJ2NHdzaWlQY2xyVTE0aWwxbkNiM0cwNFg5T2dROUtJcEhkbXhZcXVw?=
 =?utf-8?B?aG1Fb0FQZG9aYTlmSnlyWk9Fd0huSEtUYnpSWVVPbmFrUjU4bGdyRFpUZ3BL?=
 =?utf-8?B?RW9VU2NmMnhBZG5LRTZhejZsdi9sei9Mc3BKMm56R045YTEwM2ZmaDRFR1By?=
 =?utf-8?B?bDZkUFlrakt1d01rcUdhd3o2Q2pYWEhXZWVoSFBQOHBFRXJiTS9zM1U1YXk3?=
 =?utf-8?B?dWdWK2REaGFBamltRm1uU1hpYTdpVm52bEpkUlp3MlZySG1CMzQ4M3I4Mkkz?=
 =?utf-8?B?Uyt2QmpaRzRmY2I1TzZBdlpZb0dHc3pzd3FQRVZGVWw0Um1jZVFVYWZtT2VP?=
 =?utf-8?B?RHl4M1lsQnJmYW9WcEYyZE9rVHBHWTY4M1ltOVdKY2Z5QW1IdWtZV2JkbGxn?=
 =?utf-8?B?MitoTXBWaDUvK3hBeGRGbWh4cHFQRThmemh4eE5hczBDT2dSYzVxZGx1Yk9a?=
 =?utf-8?B?OTVqUmpjbENwZjZFZWQrTVpCNXVlVk5UUStrNXB3V1ZUMW8wSnpvbjlDU3Rl?=
 =?utf-8?B?MUw0SS9IVFdIWGNiL3ByU2pJZi85Y0N5U0YwUWtaNTJ5Vzh5eTZOR1lweGhK?=
 =?utf-8?B?TTd2cXFWRW1SK0FMTlkrdHFaUEl2RkphWmJaWnMzVmFlOEQramNtc1EvWjV6?=
 =?utf-8?B?VENvRXdSNHczWHRaV25TVkwzRTREeHNYS3lZazR5djRRbjY5SVROaks4Z3pR?=
 =?utf-8?B?OGNqUGpIQ0VrZW14Wnc4Y2N1MEVmeC96ODZ0aWRYUjlTUjhjSldaUGNzZm5W?=
 =?utf-8?B?cXluR0pCTU1JV1NPSDdMQUYwVHI5VlJTaXA1VkRGMUdBcU5pYkhJakM5NDVT?=
 =?utf-8?B?RkdKVVhJcmxZUGxwWXgxYWszWjJnRkdrbFkwUT09?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(82310400026)(7416014)(36860700013)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2025 10:54:34.0185
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b066bcc1-0780-4bd8-30ca-08dd831e660c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF0000231E.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8374

On Wed, 23 Apr 2025 16:41:12 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.25 release.
> There are 223 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 25 Apr 2025 14:25:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.25-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.12:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.12.25-rc1-g56d2398227a2
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
