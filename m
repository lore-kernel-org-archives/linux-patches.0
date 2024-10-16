Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2066.outbound.protection.outlook.com [40.107.223.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0EF321E3A6
	for <patches@lists.linux.dev>; Wed, 16 Oct 2024 10:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729072894; cv=fail; b=B4JblnvoeBwwQCdoeFldTgTG3G8DNT6jthFcyDqZo434vcQpxM+PtjrHvsI0Xg5CS5orKGFDrQvVXOhgJEYYOqUBQwgFFqqZ77+kBVzO9vQVYfiDHnJxyUqWdkSIiU3SXvyrgtxHinOTSFumfjZV6zqXGTIYCfB4h5oAaJVjISo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729072894; c=relaxed/simple;
	bh=lH9p/0bTi92YayosEdv7CoRG6ObB1kZQXLpgHEqpm3E=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=IccIc0DsTYFMW5+5GbZR3LanqHDSPvCICaxDGWALsmC2w/XqcwZ/3PgOks79oZJUircjMrsLb/vSQBUTwG7RHl6DoVOeDlcEZS8IzdgCRQ6a1uJhsBBOA0wyQWD7l834SoNKTuCPRQ9FRCZEqLW2TtFT6zarwQfMTwGS4+6Uymw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=mDuUtcx/; arc=fail smtp.client-ip=40.107.223.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="mDuUtcx/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oDkO/JJYt89Ly+AC9Oxyi5qjkcdxoEEwHQw2id6YgnLJa+lgNddrSuvadezPmkxfOz5z2c0zuwrnJgJHkOIpzEJu6iq81vHvp8NE6wzqkjjwH6Qy1C2kNZKwwNaCRvELtXpOc+AvW0c2hcFfYaoVQRE+lo0T2HTVY9hOZSHZRMnXEodmb7UYIFq+PpaYOwNE6/Y/1y5iegK9hoTqEI1K21wzsk+7Ps1aZRHrAHY/1BSyeaYzOzAq5En/pOWatnhXLDsLyRmlfkmEy9UNoMTYRkOev5N8dVFmsqwD03I8qNoEN9Kh3Krtr40lR4ScDf6CZlgIbp71Tbs/BCjNFn31Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/d+41PXS2QXmbaH5/K7K4MnQ1JI1hGtT6DsivGcx7DA=;
 b=UzaWvf56V7f9GjizybxJi+MAQT4kHscv9Y88T1778rM8e5h1ph4YoFi7/QIFKJRij7Ic1DDfJyWIbV9FqVh7b1cGVd2jZjXFJ50xj4Aaq0TZGwWbEZCthivc4r3s6exZLxND+ylf3zTFSmlcwx1uAQKd6sG6L8e7GsvkH0uYgu4p7/cPIMzTi5N0SgI4AyalFRsF9r7Y5C21lIF58YeAJ+j6a+tWggTOAmwU+G9tl/pgrSdYRDP1YdFpyWrLclydh0lRUesu6uE7SKTqi92hfEzwdjnndAdEGZfHG7o02f6KuQ+tzovhSPyEXGmlYMW39vTz3QaTNwA4hqzm4F3gbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/d+41PXS2QXmbaH5/K7K4MnQ1JI1hGtT6DsivGcx7DA=;
 b=mDuUtcx/vnFO/zMlL+rFioeUC7Kk4td9wSeDvCyTLuz9xxRW4uEmovIYt3/KEIu7Vo2h5AZVJus7Aj6aZFCP8k0ct/enml4HP/2oeYxKh44cZwMjlRPz8k46zqNbAHqkgBUR8Z3VhuVkRDN/a7anZViIcLYNSyCITjweXaboMrTde7PteqGdcc16j0yH1ro3j1Ud+SpddMqclNTP6g04TXhZMrhKAIkHhfn8uR830zLZH9ytxe+qSkOcaBImCqPJasCfeXc2JdPatjNd8X8jUGVF1ZSpXYMOb3yNIVQPVYrLvUhmNyWO5Kb/ydZ7pY6y9U4BM6kw91jwOc9GyCFa+g==
Received: from CH2PR18CA0012.namprd18.prod.outlook.com (2603:10b6:610:4f::22)
 by MN2PR12MB4189.namprd12.prod.outlook.com (2603:10b6:208:1d8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.17; Wed, 16 Oct
 2024 10:01:27 +0000
Received: from DS2PEPF00003444.namprd04.prod.outlook.com
 (2603:10b6:610:4f:cafe::9c) by CH2PR18CA0012.outlook.office365.com
 (2603:10b6:610:4f::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.17 via Frontend
 Transport; Wed, 16 Oct 2024 10:01:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS2PEPF00003444.mail.protection.outlook.com (10.167.17.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8069.17 via Frontend Transport; Wed, 16 Oct 2024 10:01:27 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 16 Oct
 2024 03:01:10 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 16 Oct
 2024 03:01:10 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Wed, 16 Oct 2024 03:01:10 -0700
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
Subject: Re: [PATCH 5.10 000/518] 5.10.227-rc1 review
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <f195a0ed-7c26-4e56-87a9-1fb7f7be0971@rnnvmail204.nvidia.com>
Date: Wed, 16 Oct 2024 03:01:10 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF00003444:EE_|MN2PR12MB4189:EE_
X-MS-Office365-Filtering-Correlation-Id: a38bf494-bf4b-4803-caf8-08dcedc9800d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aHA5KzdjMGhYdWEvTWJyVVFvd293OHhJNFFwUXZIR2Q3cUNhS055SUVYZ2xP?=
 =?utf-8?B?dlhsQmk3WVlnby9TRzk1dzBleDQ4dmtLM05WZnZMN0ZaaWFrWThFbHU0TnFx?=
 =?utf-8?B?RjZzS2xtelowNy9Sbzl6N3ZDcDRPRi9RelBZam53WCtWK1VjZnRvd3huZWtV?=
 =?utf-8?B?dEt0T3dOUEM5QjRaV3BZRUQ3SENIaVFobjE0RWc3MWhwTWd4NXc2UmFoUnh4?=
 =?utf-8?B?L3FhZ1pKbVpyUGgySURJeERRb2QwUTZrUnJHN3JEUUtZL2NYZ3oxcTJ4a2RB?=
 =?utf-8?B?L1BtTC9TWkpWVkN6aVo5alBzb240MkFyWno3RVYxR2xLYzMwWDE0Y1lFWEZv?=
 =?utf-8?B?QVdsb01WdXgzdHEwWEtYeHk0ZkwvRHFaWXBrV2ZMWFVsZVVVeVJTaU1lUjV1?=
 =?utf-8?B?dGZna1UwV0UzVndTdy9vSW55dHRYNm9vVkM2dUs0czROMFJ3Y2NiVTlLQXZt?=
 =?utf-8?B?V3VxR2NWdTV4Z2J2UVFyZjUyREV3bWdDYmlrZG5VYnBrbkxTamY3Y1oxK0Jn?=
 =?utf-8?B?RTNkWjlIRDRqZENiUlFMSzc4MWgrOG4ybkdFcmdJS211MDMvSUplWnh6OEJu?=
 =?utf-8?B?TGdaY0Erb3BMRTM5SmdUa0p3UVlkajFaRDlhYjdIbDhaRjhRSmt3dW5WTlhh?=
 =?utf-8?B?MWFZbGlkQ2lkbk5IUmI3V3ZXdUlUMkNuV2twN0FhMUE2YkRMd2pvTnFIWHJ4?=
 =?utf-8?B?am0zL3Zybk15WlFrTVBabW9MTUs4VE9oNnMrcTVhak54bU5WNEgyR0ZKZnQ1?=
 =?utf-8?B?TG43SWo0enNTNVJ1ajBpbnpRZFY0VEh4Q1VnUEhvK3o5ZE1MRDV4b1cxQnFr?=
 =?utf-8?B?ZTFqUjZadFZ3cVZ0QmIra29jUnd1S2YrVzZQSnRHZXMvbUtKZUtPeWVFWUJj?=
 =?utf-8?B?SThzbGJYUVNhMkRrSXJZZjBvb3Nyam9lSlN4U1lSa2VTZHFxRGo3TkFFSUpl?=
 =?utf-8?B?aVNIcnJ2VzMzU1FpaEIvWG9Jc0x5b2tVTEpDZEhlZlh3K3JPU1dsSk41TnEr?=
 =?utf-8?B?UExLWVRqZjQyYUU2NlllNmQ5UDlDVGxQTHhodzRQd01NR2dWZ2RsK3RvekFW?=
 =?utf-8?B?RXEwMC9IYlMxdGRJQ2ErelVram9CZnJhTzZYY3lZVC9LazN5ZXRvSyt4ckpW?=
 =?utf-8?B?RHF2ZTk4SmsyWXVWMXBVdmxaWnRxdjVLMmY1REQrQ3FkYTgrTENRK0ZYTzQ3?=
 =?utf-8?B?ZVlaekR0K0VpQTFLZjA4MERudFk1Wmc1ZlNwQjg2clJmaEtGTjhUOG12TU4y?=
 =?utf-8?B?R0R3bEp4cGlnTUFsUFJoRzB2bVdPOEdkeUo1NXdETnloZ2RsWmF4NTlUc0Jn?=
 =?utf-8?B?THFiblBPUjBxOTFEUmRnYVk0cmdqVkR0SmpWdzlEanZWUDFLTzRpZk9IeDBy?=
 =?utf-8?B?RzVlSkFaYzF0ZFhRZlRzbXRXVW9RZnpnVjJORXMzUFBiRFpPUEtqNjlXZ1Nt?=
 =?utf-8?B?Vmg2Zy9udE42cndQWnVuV1UrOERKR1VNVmd3WlY1Rmx3M0RCeC9SeFZ4S3pY?=
 =?utf-8?B?Z3hDK09GSHNjMVVmT3dNdjBIRnROYXNjeThaTmQwSTdJOTUwUEtTTk5qS2Nz?=
 =?utf-8?B?L2VlSjlMd04zaXhnUlFuYk5jdHZGWWZTbGs2eDZHTGw3SFZYNzlCYlhVeEJp?=
 =?utf-8?B?U2VwdFJ6S1FMOHZDbnIxTG43Tk5ZKzdZY1dobk9PYkdpa3Q1S3IyWEVQak9C?=
 =?utf-8?B?NmR6cnlITVRJb1l5K2EraGZXYjBoVjVNOGpweUJVZGp4bm10cTV3M1pkTVE1?=
 =?utf-8?B?SU82R1ZRZ2VWQzh0YXUwUGhrYlRIVWZPWUt0bVMvbDludVBCWXI1M3drK00r?=
 =?utf-8?B?TkVVOHBvall1cVpJOHU2QnNEWWZQaFpYTW5zUi91OUkxM09BZGRTUFhjVDk3?=
 =?utf-8?Q?kSizBzWzHl66b?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2024 10:01:27.0489
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a38bf494-bf4b-4803-caf8-08dcedc9800d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF00003444.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4189

On Tue, 15 Oct 2024 14:38:24 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.227 release.
> There are 518 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 17 Oct 2024 12:37:45 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.227-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.10:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    67 tests:	67 pass, 0 fail

Linux version:	5.10.227-rc1-g5807510dd577
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
