Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2078.outbound.protection.outlook.com [40.107.220.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A976A8F4A
	for <patches@lists.linux.dev>; Wed, 25 Jun 2025 07:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750836252; cv=fail; b=E/TXwvqDOqnAv2Fpurei1iJbFLMPqhhsOwYdeaWiN6pRsAKtQv8wAnE9WI5zyliS89yyWsq6XK2fmQWKC8TdpeKvuzqeM0EEG+vCIHBBVSfBHJZ0mz9lh652wv5OPdVIlaMW03IZxbzFlMGaDWXfpHw7MNERAvBqfCR/ccm6uV8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750836252; c=relaxed/simple;
	bh=p3MjO+hNyh4Ewghw+Vgijk3exS9IwN3QY2P3vZv4kIc=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=IuBXhZgmFvkh+xpYlgxD0CvgvctPJU3XOxah3cyA5cHjivQdgahEhZO1FR9LrU8uRyv68kik4pXk3ntXsQlzEtgsdvxQC6ong3mNiDoTDRlMGfMITx+CpwVMkBejLwNC3iMak+ggMFB6VGQTn14+Q8Hjqq34gb4os7kny+dXDSg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=uHZjc81m; arc=fail smtp.client-ip=40.107.220.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="uHZjc81m"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Zs9L1hAA3KFX6VKA7ZeZKkLfNe1GOKgsxZokxQYQg7Xu9JPSRGIuENCozZ6KJinumDj8ggK5waOv7HFayyJQmvE7JhmGvjN2wdgZ3qfi+jDCBoUw1LanVJF82gh1A4pbH6nuaVieh48dw+AKwusW+UAtGVh6MtXI7O3yPhBT8HEK+lMneX0kE2Q2UCdJ5071pcbCV8ogqvBmKjzod455SQqmGW+mCaNyPP6IsFzSdAT9n/oaaYBSrDw+LrR1bx0IVn2IJ12Xs8RIU70lSikslivQ+AfRW7r5hhABXGz9yxfxk2D5hzfnsiDQd6O4YvZ/OR02Srir0XGj5ckkzDuHHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yr30JYQ2tUjLg07q5sIZmYWe2cX836KsiV/xPsFlWHQ=;
 b=rHyED/6KOoZIdOzBCXkFhZT26Ajo33GyiJPdkskCK+7TJ61/nFgzqWVkNBjUbbr9K/xaUbTq+qekqGN6pR6+WXrNnj9cOOE0vB6CEUkZZJzGGUaFiAUA+YCPwbw1fidab2p0U3EJA8ghtEIE0h8C8Wm8VKrSWh8xshIKFHVcrteyEXsOfFRkHPK/hYBypq7DexIG2Q03RRFgZ6w2vm6V7YBaJpZ/mSnMjp0/c84Uqqws6NnyRm2mm+BQHR2Jhi1Ml3mwyitQxqbRVp3XNEBG1HlFVNImG+ZY1tv0tvxcXwVh7pb7uMqm2A8bbt+F+iTAYbWjBFF7g+S79mJoqiZGqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yr30JYQ2tUjLg07q5sIZmYWe2cX836KsiV/xPsFlWHQ=;
 b=uHZjc81mYoFWVJ+BtUSeTkjelhBiAojbMLKVNUOV2YCIvasSX/kzdqqkvS/6k8xtjjtSICpRvtlljgZCIrvQy7q0NWdXlt1jdGF3L6rgbss2hU3fMqBr5h26Phc0RYRDnAA/HnaDBM54puGkv388h3BTfsrkwypylBIjmmOX2VmRggxLXJZVtVbPQKMoYRvf/NreeKOoRgSef3G8MFL75+Yb9eWyVysMzS6yoBleyHlWmeRkOFA4cjVL1+urUKlSVhvGPenqiCaXK6fiPZ4LKQjSHUxZNXK+mcK99aDdwIWzdG+BvVdcM1Yw86zPG1YoYLH1JVPo/99BiiNC8fzmfg==
Received: from BYAPR06CA0043.namprd06.prod.outlook.com (2603:10b6:a03:14b::20)
 by PH0PR12MB8097.namprd12.prod.outlook.com (2603:10b6:510:295::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.20; Wed, 25 Jun
 2025 07:24:05 +0000
Received: from SJ1PEPF000023D0.namprd02.prod.outlook.com
 (2603:10b6:a03:14b:cafe::7d) by BYAPR06CA0043.outlook.office365.com
 (2603:10b6:a03:14b::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8880.17 via Frontend Transport; Wed,
 25 Jun 2025 07:24:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SJ1PEPF000023D0.mail.protection.outlook.com (10.167.244.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8880.14 via Frontend Transport; Wed, 25 Jun 2025 07:24:05 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 25 Jun
 2025 00:23:51 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 25 Jun 2025 00:23:51 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 25 Jun 2025 00:23:50 -0700
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
Subject: Re: [PATCH 5.15 000/411] 5.15.186-rc1 review
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <340b761f-dccf-47a8-94b1-809e68910acc@drhqmail201.nvidia.com>
Date: Wed, 25 Jun 2025 00:23:50 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023D0:EE_|PH0PR12MB8097:EE_
X-MS-Office365-Filtering-Correlation-Id: d7f4a547-223c-43f8-e7bb-08ddb3b94442
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|7416014|36860700013|376014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OHA4KzhOeUxvUWxBMEtycTVRN0ZZcG1EU1NYQVkyeWZ2cWJoSk5WemVJSTlv?=
 =?utf-8?B?NElVQytLc2tJUXdKczNBK3oxU3FzWUdWRkxOWTRjNVMrWFBNMElBK3J6ZUV2?=
 =?utf-8?B?U0ZEOEkzSDFvb25QZnE0bjYzT3FkK0pFMW50NGFhNG55NmZmN0Q1N2s2M2sv?=
 =?utf-8?B?Ym81M2tvMWFLd1FUWGtBQ3lvaVlQRk9OTmF5bzhxd25VVVFBd3N5cFA2S3d2?=
 =?utf-8?B?bVJpc25VWkUyZ2ExR3lmbzVuN2NKOUMxT09yZ3VyZFprcFlCb2hnblYzQldt?=
 =?utf-8?B?R1A3ZUhaV1ZkNHZqajNZbmQ2bFEwZ0FrUW15OUpERWtHU28vOXRzeDdzRllO?=
 =?utf-8?B?YXI3SjVKU3pjcVBtaGdrTjZSS0tsQ0pZRmNQOHoxcmFnUzFaQmF1djgxanJ0?=
 =?utf-8?B?cVlFS29SNzBvdTI0dzlMTHpIam0zYWg5eFFPY0o3NU40SGJQcnJsY3dRdTRV?=
 =?utf-8?B?MGpXM1lOZGRUSThCS2VYek1HK3dldGJ0dVE4eFdDc21QYVFOanZMQnhZbU5l?=
 =?utf-8?B?VG55Q0p6cFRhUWFYYXNtSmFNOHYrbElWaHRKMldEb0ZKUmFqUG1GTWRSK1ZN?=
 =?utf-8?B?aE56Z2ErMjNlam9zQ3BDYklUb1FCUTNIU2hqSzdEOGRzUjdKZ3ordSswOE1D?=
 =?utf-8?B?Rmx1WHBkYmpwZS83OUFnbWZ5L2JKejJIcm05ZjFvMEpseFlqV0VOQWczNElp?=
 =?utf-8?B?VlJsMU1Pa2lwSTkvK2FMdHNKRC9Ld2ZwUEs3bXhPeVc4TExOM1ZTNGw1SmUy?=
 =?utf-8?B?T2N5R1F2V3V4ZE9Wck1rWkw0MVUzN2dpMkRRemQ0Mi9LbDlnRkdmYU16RGsy?=
 =?utf-8?B?TlJMVTVIdDNmQzVKNUU1K0poODBkSnB5UUF3V1UzcTM5SkNiT0ozYWJzdXZy?=
 =?utf-8?B?UFVqaGhLYi9Md3NRbWFqL3JuWWs0Q0pxWTJtcXRaVkFRbDFOT0NQbkZrME9X?=
 =?utf-8?B?dUhFUjY3TFVIUUhZVnlzcWlnLzlWWVVBN3RRMDdsbTAyRXJPRDN3akZzaVY3?=
 =?utf-8?B?WlZWVy9sTUFRZ3RkU1dRSTcyTCt5WGNwNUoxS0ptd2VMUGY5d2FiUzNzQ0pq?=
 =?utf-8?B?ODgyQ3ZNUTlNK1h5WDlUWXNJMFE0NHdtYldvTk1KU202MlF6L3Z2NGNWeW5D?=
 =?utf-8?B?WWFJbFZvc1RxbkZDQU0zQ2pYbjBTNEVlQ1d2UWpsdU5hRHhiSVRTelc2Ky9Q?=
 =?utf-8?B?TG1zV2V2Rm1ad0piU3drVHp5aEd3N05iTStxTzVUcHpRRVFMYVo5RVJteDNR?=
 =?utf-8?B?cjUyVHgwbDFJeFdLZ0Nxa0tuN2ZsTkVnaUR1cHVWZGFxcXhucktidTZCYk04?=
 =?utf-8?B?clQvNUk0SmpuVHhyb29rVStrUGE1YTlIN3IyR04wbXNlRXVmdlJFbFMwQkRO?=
 =?utf-8?B?aVJxUlVMM1dGSEFQNUgvb2FrZU1RR2laano5MFptbVgvRnZzandQMHJvTHhQ?=
 =?utf-8?B?bnU3SnlIRVdzMXRpK2g1aGtVVXc3T3kwY1lWbURkOVF6ZWIzNC81eDBNdkc3?=
 =?utf-8?B?QXNZT1BaSFNxYVQxKytJOGRhMVZOV1VISDY0TGJvMzB4c1RFQlpIRDhrNklV?=
 =?utf-8?B?Y0tWcVhOa2twcDBSSFFxb3VWYS9tTHdEdHVRQjIzTTljMjNuZzNtbElhb1dC?=
 =?utf-8?B?QlZHOXRNZW4vSHNlOWVKT0t1aUZldFp1VFJEVkQrZ1M5VWFDVWNGdTQ5RW1o?=
 =?utf-8?B?b25LOFpjV1lKd2pWdmpNNkl3M3R1bGpwMGRHWUdYVC9DTDV3U3NILzdVQnRx?=
 =?utf-8?B?MTZLREhacFE3UmRhdlFmSis5dVZIaUV3OVVIckJjSm42MWtoNnZXMytpdTJO?=
 =?utf-8?B?YTMyVmdVQno1MnRDZkZqRjhUcjBnSXVXL1ZMRFdHRXJuUmZ5emc4czUwRmUv?=
 =?utf-8?B?bEtBMEFKWmY2WkNDSmFxVnU1dFVQaDl5VVhjdWVISjg3SUZqR2NIMkt1U3Na?=
 =?utf-8?B?eXJIKzdjTERxaHl5cUdqWU56bkE1VG5EZmhkNFRBcmMyM1lQTjQ4WVBncWVp?=
 =?utf-8?B?WXlNV21CZGJkR1Fidm5HeDdyZzYwVHVrb2xDcFRrNTQxR2szNHFkMmJ6ZDVh?=
 =?utf-8?B?VXJKekg1ZkVJUGtITWNPbUpSMmFhbzRJMHFLZz09?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(7416014)(36860700013)(376014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2025 07:24:05.1701
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d7f4a547-223c-43f8-e7bb-08ddb3b94442
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023D0.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8097

On Mon, 23 Jun 2025 15:02:24 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.186 release.
> There are 411 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Jun 2025 13:05:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.186-rc1.gz
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
    105 tests:	105 pass, 0 fail

Linux version:	5.15.186-rc1-gcf95a0f111a6
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
