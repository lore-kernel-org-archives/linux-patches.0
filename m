Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2072.outbound.protection.outlook.com [40.107.94.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC9F2335B5
	for <patches@lists.linux.dev>; Thu, 16 May 2024 12:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715862757; cv=fail; b=jvhX5CcfuiyjJKFsecA1JmjPpsgugze1g1F0SbTorb5jEy5U9673Wcq5gigeriF+/WhxNZbbwN7iD1mSVgkauHqIu9+gzEXP93vifi8oQsRmGGKph7UV61U0WBuDHI3FZFX7oRdeEvd/OW+iwL2DHMzr6p/j59DF3sEZvpnmuqk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715862757; c=relaxed/simple;
	bh=5yMsk6WRtCaGL/Qql6A6wXwZNVzcxzXXlNSvLsq9cg8=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=PK0+WWgeO+861Q66wCU3Z6HkaBOySwSM5/LN6rQB9b3BSxJI0GjRoq7Je5hYjbe+RnwRqbd7KqJO1fprkZQCplB3EhW64Px5lercJeLuNXK4Wtc1EqUNSDLF0rP2GkfCChf4nPHBDbR3JxGAzX4BKI/RjgtgO4N/5j49bXBF1AE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=S+DRQ/CB; arc=fail smtp.client-ip=40.107.94.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="S+DRQ/CB"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KZiUlgtPCbpTykt+Cn5Qirg3ZIvGRDhvXWO3h9H1OQjKqM6lQu8g4npTvS+1C1GgC7T0MpKjN987c9ejn9CuYR2jZmAQPoX8b1WkZUrGciFvEgLJ1TZTXHNb0dsNLEUoahOvOKNsCOSYd3j61p+6IrG/YCtx7GgqbKjec9ti1g3D3aZILkIiVu5fcMwdGyGF4ih+tybqD5rcX6slLLt63PZN6kA/7NtLzRurEfL62Y6afy8TOpSnOf8ZQFldJwsq8XGlSw6qV3h5V28cswa7Brss7BGspcvQ0RRtkJfhENsB41BCu8vumMY/AToQUnFSTqntcgjZOMJM0ZApONM3Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u/80DdB+I/ferVuLe0jmHl2cZ8y3KZm4FE2hySmIHAQ=;
 b=V247ekDg03IgHOULbh1z2WSbWnpDUEqQjEBTfWmmBpAfX7VKBxClolpaitZtjQhAgQu5L7Gc7sK43zxD10cVMglPwa3cijdyZHPwHRGeSO9nodPluP1vsYP2T9vQo+pTF4QHynmak8g+XCkqs4tctg2kXeZahVshzsja0lRt5WaLhavUTZVRSkAVJ+CZBBkAdn6nysK4hHCsuxWoxRiD7yG0xRsrpAwOzreippZbTVn86enJFHCqEeQkC9sF3pigAsrvrLauP/nA81JfSsy49A7IPN9n8cNJeR5to+g32wNA1gs3bf+tHmxztKJxyLul7oRcSTDINzzET1iyViTxUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u/80DdB+I/ferVuLe0jmHl2cZ8y3KZm4FE2hySmIHAQ=;
 b=S+DRQ/CB78mN60MdrM3hNwRJkaOTKmL0rxF+npk7Cj22ngvyC+p/CLdY5tGRweTX/RGE7/xaFhMduiUEl2e+kF13xSBLaoUbNkO7wAFgqHhk/a7elJ1JuleQib+oJ76YIeTXhZZd1uwJa9X3XRwvaTxyj40toZxOeW/m4AHbaSud4jhD4wiYNWUgtnYbXFJtRTMwFMVLRPxdahkts4y7a8GA2LFQ6WR/E/QQBVxdKkl3vrUFkv12zGm3WZVCM8Q6BkBYSvBTed3xbvh/xIt+N7qCd/MyMdu9bpEyuMPho3mf9LeFhLv0ECTx1G0dFdOM7ctufwwxv3XdB5TETDiBOg==
Received: from BN9PR03CA0198.namprd03.prod.outlook.com (2603:10b6:408:f9::23)
 by DS0PR12MB8317.namprd12.prod.outlook.com (2603:10b6:8:f4::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Thu, 16 May
 2024 12:32:27 +0000
Received: from BN3PEPF0000B36F.namprd21.prod.outlook.com
 (2603:10b6:408:f9:cafe::d7) by BN9PR03CA0198.outlook.office365.com
 (2603:10b6:408:f9::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.29 via Frontend
 Transport; Thu, 16 May 2024 12:32:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN3PEPF0000B36F.mail.protection.outlook.com (10.167.243.166) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7587.0 via Frontend Transport; Thu, 16 May 2024 12:32:26 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 16 May
 2024 05:32:13 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Thu, 16 May 2024 05:32:13 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Thu, 16 May 2024 05:32:13 -0700
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
Subject: Re: [PATCH 5.15 000/168] 5.15.159-rc2 review
In-Reply-To: <20240515082414.316080594@linuxfoundation.org>
References: <20240515082414.316080594@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <a2af43ad-ee16-4fa5-9abe-74167d080f3d@drhqmail202.nvidia.com>
Date: Thu, 16 May 2024 05:32:13 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B36F:EE_|DS0PR12MB8317:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b1026f6-c97a-4474-3738-08dc75a43ed0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|36860700004|7416005|1800799015|82310400017|376005;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YzBCMitQM1pzdkczc3djVXV1eEJXb2FCVzdaTEE4cHQ1TUNWUkVEcnFsQm5i?=
 =?utf-8?B?OVkvOHllbWFzWDFTT1dEdHhZQWMrTVNFYVVrY2YycjFpcThFUnUvRGhocXYz?=
 =?utf-8?B?cFhxTlowV0Q4ZDVPSGp0Nmx3SEVCc1VKS3MzZ0UxSDJ6RE5PcDdaWVc2bE1D?=
 =?utf-8?B?TXJ2SjdCTGQ0eksySHZDVExNSDgrdkhlQms3dE10MzRDQkswZFRrbDA5SE16?=
 =?utf-8?B?NzRDblhxcm5uNmRBM1cyQzdqUTh2b3dDbldBam1RNzVha2pjUE84VUFCNGpn?=
 =?utf-8?B?bDUxTnlxYWNNQXJ6VGZsQVJueHQxcDdhaHZRUU9uVTZxYWkrWXpseUJ5ZURx?=
 =?utf-8?B?VVFtWmR0UW1tN3pUSFI0MlRLYURQb0lnei9rUTJ5alc4N0J6MHExUFpVbzUr?=
 =?utf-8?B?ODd3cjhiQjBqNWdLM1JGdktSTHp5WlZuRDdQUFM0T1JqNW9UYTBTWTQvRXJC?=
 =?utf-8?B?Sk1rbHNUcGtYYm1nOEEvblF5aWRHMUN1WExxV1NwQmJQZE93NVoyUURhbThW?=
 =?utf-8?B?OFJRdUN5NU5sc3RUbWtSTEVValZZb2hXOEgraW04TWEvbWVFTVd6YkxoczYy?=
 =?utf-8?B?V3VnUDlqNEl4dnFTVUpyQVFFY3FFejk5MlJWc3c3anBxRDJ4Nm00OEJZZWdM?=
 =?utf-8?B?K2VJNC9UYnhhYVRiZVJ1V2I2V2dVRDVWeDEzWTExMDhzWCt3Z3VTOUo4TXNC?=
 =?utf-8?B?bTVycTVmMHQ4RDVoYytYSmpoem1DM0NJVnZLbzJFbldTMkRBQ2JpU0F4TE9T?=
 =?utf-8?B?RlhWcTZNVlN5TGxqaVk3MkptWkZqalVBc1ByY25EaVd3NEJlVFQ2NXh4blJM?=
 =?utf-8?B?alhWWU5jMlFCZVY0Ri9WMFhTYVR5dUp2Z2V4bDBXV3BlYzJ1dmdyUHZNaEw1?=
 =?utf-8?B?aUpab2ZHWXBLR2dQWnkxQzJMVThxTGkvY1Q0bmltZGI4L0dBcGYyWTFReDNQ?=
 =?utf-8?B?VXhYUmFBMnBEeCtKWitpZ2FUZ1d4SHpmeWdGUklMV0d3QXFGbzFZT0pEUDFV?=
 =?utf-8?B?SmJNTlBtQ0l5bjQ5bmhlSXBCcjZKckQ0ZEU0am1vR0lueWwwNkdWV3hITFh1?=
 =?utf-8?B?THpFTHZ4VEFMTzhiYXhvbzl1aVlMd3hjYXFwR1ZHU3ROVXNueXM5bzlvZ1cv?=
 =?utf-8?B?eTJlS3EvNnhmOTdLU0lhQkczUlBlRjJBU1ZNZFNNdHJhTGs4Yk1GRzJGZnBt?=
 =?utf-8?B?dTV4ODVJTFNLeXJ1TG9pUmxVNDl3ZUM1eENKUUYxU1pYREZwK2orU0s3MU5I?=
 =?utf-8?B?cURnSzk0RG1Ha1crRm1SK1EvMDBpWFcwNHJQYzhma3V5aEFpRHlQS2Z2cGE3?=
 =?utf-8?B?Rm4yRzZQUGZDOVU1WXc0b2ZWTElJaFRsLzdkak1WaTlBZFdBMXNXcXJuMjNF?=
 =?utf-8?B?cXcwMENqZ1F3bXg0U3doc3k0RzBqbHlMdkNpam5UeTBzUnBnMkdxcG9OOUZO?=
 =?utf-8?B?ZnZCd204Z3pOckxJYzVldG1oTzVpWlMwcU9Vd2RPMTdYaGxuR0NsOEh1cjRU?=
 =?utf-8?B?Qk1lN050SjJJRGg3TTJCL2Q2eFZNTnpIMjVaSHhjd0V2R2FjUURIekl3ZHAy?=
 =?utf-8?B?cVUydGRJbFhPdHV1OXNNOVJaemZpNTBSdHFya202R0h5RDBtcFE2OW5JdDF0?=
 =?utf-8?B?WHF3T3VTZHhPQ3F4QTdySktrcnFpRktKS2taRkI3TEx0VXBDdXRTWkU4MUNy?=
 =?utf-8?B?dXUwNjVQcVNZSkNBWlBkQ1pnTkh1QkpZM2Rpakkxa1pSL1NhenZDNlN3a1lu?=
 =?utf-8?B?dWNsSnFFZ240VXd5STZIV3B2ZjFscVdOM2tNWG4xUnIrTXZYYnZmRFdTRDlv?=
 =?utf-8?B?RmVEVjVJUFVrZDhQYWtHU1k5L3VnbE1OTC9QbnRncTZBMUhWemZ5eFZuRytH?=
 =?utf-8?Q?WO1tzQS1V+Kr6?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230031)(36860700004)(7416005)(1800799015)(82310400017)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2024 12:32:26.6655
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b1026f6-c97a-4474-3738-08dc75a43ed0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B36F.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8317

On Wed, 15 May 2024 10:27:48 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.159 release.
> There are 168 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 May 2024 08:23:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.159-rc2.gz
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
    26 boots:	26 pass, 0 fail
    102 tests:	102 pass, 0 fail

Linux version:	5.15.159-rc2-g1238a9b23a79
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
