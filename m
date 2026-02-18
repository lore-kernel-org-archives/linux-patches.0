Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010030.outbound.protection.outlook.com [52.101.201.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C461F31A57B
	for <patches@lists.linux.dev>; Wed, 18 Feb 2026 08:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771402973; cv=fail; b=UUpjzxANBWsLJ2ETM/kjU0UXUtrgvYkmEmKFwTyWxSmynp536vC+5G966jZaMrkAB8qT5oItfZwrdoLeSZ0AyGhR0opmwhbkHAg9ROFqgtSGNoNhR0w89DFjXdXnXX79HCGNXi8F/vhqj5aShGVQGJavfGfArUAOr/MProUpC7g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771402973; c=relaxed/simple;
	bh=U9VKfQIeiaenmdDyy+UafE2An3VOHKvATk/1f1JjdY0=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=A39mbxTl/Gx5Hs/BOH89nPlhi/IQ8gXuBjRDvXqkRNVmNCnqEASx39SKReE/uo0SuSR/W3b+ffHpbUQ52GRU1l39qOYik5PP2EJs7zhb3dVzkdAZeTP9cuYc5+BWTgAw7tBmDxuXeg7a+zhNOKC45a9X9DGjBn8yqn8FhkQHukY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Ao3v6Dqe; arc=fail smtp.client-ip=52.101.201.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Ao3v6Dqe"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lylQBmORiLcPGrxwODSWzfI80r0leOnqHL9mdD99THeQaI5SrA0gKnANav0/mwT62m+7NzaQCQwmQ78mVH/ls0IMqBjW6/bF+YJ8rOc8khaDBBb5yIVmKuxnP5yV8wBn1Qim4jIiU+6VROrHxmIF1YI/Ic13HtLOzm0YZlVJ+EW8e6WmRSGAVBSGZjkSzhBjGEScwWKqu7sJaKDn88TQwEfC6T7C3yOQYX/cQs9KHJYm0t2stczkgZc934hykp6NQgfxm+u7Uo5TBoBCUivBmR0C44Q4zkySWfEvYI/LgBV+LugR3gWGAFRGovKcHPAh+j8DWDsZ2YRTalgQ90g4gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qp85hxs6YLkEwtTEYNAZANL1GDaUF5rJT9XUhA+Qj1Q=;
 b=HjKG6I01VHsSHXMZmyV3iEa2BrKCbOFcF3jbLV3JlW/ZjnjCKzqD2xgbEZAePFhK+fdzWbc9CqVmJ8nYe+Dg8XMx1M1Jihj9q/Y7bcZ8Fynegwi5OOWZ5LTufo0mxJ6KrszHANdLw2lifCxYXbtpTis5V1adGzlF0QPC5vJ9xtJ1UdURXplOraDKva2Fn+GhVJr37ssLI2K0IzLsHe0lTHG6rILubIy1+Gv/VZwJF3i1Jwu9w7bDcYT2fzLPKS1LWWGovfW+CRhoIKX6i+l1/D0g6AKc4/3MQQJkfRnyjs4zxBG2LiJv5PNywc74+2BKmdVcb/FKN8FWyDvzc/huDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qp85hxs6YLkEwtTEYNAZANL1GDaUF5rJT9XUhA+Qj1Q=;
 b=Ao3v6DqekH54oMtuCB0MuEQysGSFaWXHrlJ6lVg2iNi4ukF+daeeGKx5TgAvTXEBS+BniHi49RpKcHwh6lFflRU4OhKKl3uZocbtAzp2Pao8/v7zs4wtckzezxvL2J3omttMctMST0XTQk2kuMcIMECKwpwi5GBGeajFLY4kxLC78kTAzMuSegUVCS8aOz5Ozl8QXRtT+KLWDWmuBvTCIdH5ucug++1ucg7EJM0EEHYXRBLaH2zpBDKTUt1bj49gZY7z2UW8/e2Zxhocmq4efPq5SRXOiVV9z0qdP3oYSY59F/1+1RVNRoes2cOwH4sovT5nFwUJ7pL5npGHDhUSuA==
Received: from PH7P220CA0005.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:326::22)
 by DS4PR12MB9588.namprd12.prod.outlook.com (2603:10b6:8:282::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.13; Wed, 18 Feb
 2026 08:22:45 +0000
Received: from SN1PEPF00036F3E.namprd05.prod.outlook.com
 (2603:10b6:510:326:cafe::d4) by PH7P220CA0005.outlook.office365.com
 (2603:10b6:510:326::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.13 via Frontend Transport; Wed,
 18 Feb 2026 08:22:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SN1PEPF00036F3E.mail.protection.outlook.com (10.167.248.22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Wed, 18 Feb 2026 08:22:44 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 18 Feb
 2026 00:22:32 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 18 Feb
 2026 00:22:31 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Wed, 18 Feb 2026 00:22:30 -0800
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@nabladev.com>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <rwarsow@gmx.de>,
	<conor@kernel.org>, <hargar@microsoft.com>, <broonie@kernel.org>,
	<achill@achill.org>, <sr@sladewatkins.com>, <linux-tegra@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH 5.15 00/39] 5.15.201-rc1 review
In-Reply-To: <20260217200002.929083107@linuxfoundation.org>
References: <20260217200002.929083107@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <7c4f4745-ae53-466d-a470-97f2c2b7161d@rnnvmail204.nvidia.com>
Date: Wed, 18 Feb 2026 00:22:30 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F3E:EE_|DS4PR12MB9588:EE_
X-MS-Office365-Filtering-Correlation-Id: 0eb53f55-6380-4863-fcc8-08de6ec6e47e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|376014|1800799024|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZmdNaHFzWEdjWm5sMHBXVU8zQnA1V3ZaNENIZTB5MXg3dDVqZnJ5dXZ1UEZy?=
 =?utf-8?B?cDVwdTQra3I1NFBNY3RBODR3Y05xK0xWYWxrOEUwbzNQZXRKaWQzc1JBQTFO?=
 =?utf-8?B?cW9Hc0IxL3VOa0szdXF2RUZqb2xUNm5wVVpNOTA4ZmYwc0kvTXNPNVhBVy9a?=
 =?utf-8?B?YjE1eGRacXlEc1dWaCtZWXRKdC9xMTY3dUJYenlNSDRWdWVlQU1GV254dWtK?=
 =?utf-8?B?Uk5FZkN5SHIwSGhZV2NMWnNNcjgyQXFZUU5kK2UvREo3YktWcDlzQ3dmR3M3?=
 =?utf-8?B?bW9wb0FzTFZvOGh4eG9jeXMxUGVvQW1wSThuQWZjak91UWFpZzBnQUUyVEtD?=
 =?utf-8?B?VExjVzB6eWdydVAzVHAwOTUyRy9MSjJXMEluLzhDTTJNTzBhOHpuc3ZSdDJB?=
 =?utf-8?B?aE94aC9UR2pDRGI2bFBIRUlmNXFza1N6Vk0zQ1g5Rm1RT2YrRlJ6Qk9kTC9n?=
 =?utf-8?B?THd4UWQ3K2lmSVpSQnh1Tytsc2NlYmthUGMyZTRsNkFaMTZhMFdaak5OWEkv?=
 =?utf-8?B?aDZnWGhTVC9JS3VDVzVkdGlBMnVPLzM1Z0ovR2w0V05TdU9qTlhWUzlieitM?=
 =?utf-8?B?MzkvdDFqdWhhM2x4cVpEdlBkVkRCSjE2NE1aV3Z0ME5ZclZtZHJmWGxDbVlD?=
 =?utf-8?B?dWFYUFV3cU9Tc1FxbURhTjFCK1Y2UVZZM0JuYStETkxFNS9jb0kzZkUxenJ0?=
 =?utf-8?B?UlZweHVvNGlOMkthcGUrYWZjUE8rWW9hWGU4ajJBbTIrS2t4T2lzRTlMQytx?=
 =?utf-8?B?Rmk3K1dOcE1veXUwWmN4cmliOFlIbHQ1Rlc1TzZRWC82RXZxQU9yalhMK1NL?=
 =?utf-8?B?QUROVVJLekZINDdGOWNvd3RsdjNMWWpiMzVEMU9rUnRhSG1GZlhjRlNGaEdI?=
 =?utf-8?B?blZxMHlzNlhUbjFCbGdBVUlQTUFCdEtSV0RMTzN4VFVySlVWMTBnMU1pTlNE?=
 =?utf-8?B?eWZUTC9vWjlaVkg2YmxXV09yQjdIaksyRitZUWViRXhRTnZ4NllDUE15aVE1?=
 =?utf-8?B?K0JRSzBDMTEyRmpLU2JOVFZ2S2FMaldmSXc0U0w1U0JCMGlrbmllTVZ4WDBE?=
 =?utf-8?B?R3ZyNFVaZVFxbzhLd21QaGpnR1hUaTgwMnYxWGw2TytuVkcwZzRENGRNc3hR?=
 =?utf-8?B?QnZtcFRYVWg2YjltbXRIQ200RE5MSE9BK1MwNmpLS0VVbjFWa0V4OTMzSkZz?=
 =?utf-8?B?NDB5Ym8yRE5pU1hmT0xmRU5hQWsveTZMejI2THB4OWwvSk56bi9UWElHajEz?=
 =?utf-8?B?T2VQQi9CRXBRZU5LaTVCam12NEtVMDY5eWJETFFSZG9vVkxwcERlVUpvTm5t?=
 =?utf-8?B?dG80Y1hjRk9WYUlEdUJpY1FuMCtOZDJzWkRNdWtpNjkxdUNsVFVPSzZxWWdt?=
 =?utf-8?B?ZTNlZ0RQMldRNXJhWXB3ck96WFNIc1Jha2VhZkFWaVJGNEJYdnhyV0VwMGFE?=
 =?utf-8?B?MjJ6NDFZbVpvK2hyYjhDc2VJeWlrZmtWMVlOOFVROFYzRkt0N216SFFlMzBx?=
 =?utf-8?B?MVJJaEF1Z1cvYTVkcVMxZ3VCSVBzWC9DaTJ1OHdYaEU3WUxIMDhiVnZLRFY2?=
 =?utf-8?B?bTk4Z1R6MnlIMnJZRzFSSDdsc01MLzRybTQ0eTRGc2Y2NjFPWmdWQmdRYVNa?=
 =?utf-8?B?U3NqR3JTOU90RXhBVDdmcjFCY2QzbGRlcy9zVUNVck0zazRSNXNWUTg4TzJn?=
 =?utf-8?B?NTVSd1pRZGpRWEV1OVNvYy96YkhxVk0vbDZRTlkzZWJHMWpJcERWTEpSRmhU?=
 =?utf-8?B?dUlScUpsWEZVUXA5emtXaktGTWRkbUdUZ1N3OFVmZTFhM3FCaDRwUFRsU05N?=
 =?utf-8?B?eXpRNlpuajVGZlcrYXRlcjEwRHdSbmhVMCtWak92a205R1lYQllYaVpSTWZJ?=
 =?utf-8?B?RmREWjk2S3RhRzk3UzVBM25vQjZaZ0ZIZWFDdTJwMmh6TytMMTJNaDZHWkUy?=
 =?utf-8?B?YU51V3Z6WEczdUg2TXNhRDdJemtvSldRak9FRzUwZityMENzY3EyZDJkY1hr?=
 =?utf-8?B?YUJTemFrWjZ0cHEwV0dqUm5ZcER1ZkNZNnE1MkRuUW1tWnVNTjhEQm9DUE9y?=
 =?utf-8?B?WTVTc3FQVjNqNGk1bjNVZW5ncEtLYm85a0FNMjJBM0NqNjA5NEhoK08xV2x0?=
 =?utf-8?B?OWhnRmdjeGMyMkhpL2lnb3dydEJJZkxjMnhvYUNCVDNsRVMxekt1WjYrSkR6?=
 =?utf-8?B?bng0L2llZkRobXo3em1zT1NBU0hZNVdEczc1ZTVSUWxqNW0xYkwvRnU2dEcr?=
 =?utf-8?B?dkVaRTFad1NOVU9ZOTMzb1pWYkZ3PT0=?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(376014)(1800799024)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	h9bnmag2w29VSXEj9BOYI+NeOVL5FI3hQewskC62fZwh1OrkPYE8+uu6EWeLSdnFNjIZGKZV2YkiblwlMb+0nZzGVHsZFR6BcvVNVo/qL7m+K0vMZABIYXyIXgnLS5nu/WYPkLrT/bCPRLLOIZGN8FwHocBrORjWxWqlSLcaWcZfx/m5C8+/BmVdT2j9P4lEVgxpacGb2sygpGhDX6ShEyBMxXEl9RA0Y69iA1+9my9Wz+XVK/W8iS3KpGuy+4+bpLF35WY+x+4V7j8IuZkJ0j5TSn7kbPR2OyKva6LDxsbLbveZVI2uvFhEnA2WxpmJJ+CEzqgpzOqdBVXsRoVHJ14Armm56UxzciehEo50J7ffY9SMvC4D5D3Hk0amq5HM9izgMM2BrxLHXIpjEWSehXRkSN4iOdlRpay8CWD6TLMlwe5e5YRrr8Tcu4wVUdKy
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2026 08:22:44.7794
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0eb53f55-6380-4863-fcc8-08de6ec6e47e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F3E.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9588

On Tue, 17 Feb 2026 21:31:09 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.201 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Feb 2026 19:59:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.201-rc1.gz
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
    118 tests:	118 pass, 0 fail

Linux version:	5.15.201-rc1-ge0006213afb7
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
