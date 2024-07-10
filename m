Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2051.outbound.protection.outlook.com [40.107.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 884C812CDAE
	for <patches@lists.linux.dev>; Wed, 10 Jul 2024 08:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720600525; cv=fail; b=hsymwYzh4lo0+/7AYivS2RvvQ3cZL/2NHKpdby8j0vki1vVxR/uwva5qOOzOm/Tfyx+5PIrK0Gq0N6TZMSHPdtXADkko+VPXDjbS03CltqGL/DNmOa3NcFrRzLCcaMF0HphV4A/27RlE+15n4G2Z1aXYooshribN9eAhsIBzL5I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720600525; c=relaxed/simple;
	bh=S1+BDfWca66bHKzo1PotOkqtkKdRZl9tRuxi3BonPCU=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=FunJnrm+1p8IP615YIGLeALkzLojS/GeEPm2EnJ5e3Z86rQYsRA/Mg+NVkgpNDn2csvt/kMsWXxxaui64nyjEzxaaT6/xLuafHdCF4aIgB+7VUP6NfPCsifPnDWfdpXEYwPrbQ+lsIrvFaCscio3yttNoeoyFOE1gJ9Q8daU4JI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=DBTLulpk; arc=fail smtp.client-ip=40.107.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="DBTLulpk"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kDJgPBlfYc6grFX2QOmLxYrDp7jxX0/hsos3XSBfpFP450kWPezGbjpvora870AHBppfRS2cf1ujNmh7OjDAKn+ji8ubsSReK3RxgsgDIlSuJEqjLIYt8R7c3m30BgYaSac8b6CtPi02nbf4Mxqof5h/t+O9MoSwBtD9YsZSL+4h2EC+rUzNqo693C/MyYpPXlXg4LoFsfWY7QUqXM/ZICMsGTP8DT4iw2QUyrj/cA6UP4sSI4BKJTBHb3Epha0+vvgekw0VYmQV6NWVVZ5pn7MpnCTFXVo/Z84r3YI9tMtmbLDhaN6pkgg1wb8rAS2UQCxpfvOijabjySCwgsIpiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+Usu0glu3nUhayY7b1gdRNW5AEkFYvybLm8x3N2YyJU=;
 b=IObdnGGY06A2ph5PFayotlm8vzWvDDhNVTEsQ0HrxtIAQIqXQeTFBzBP6QG9QKsdRkuaGCVKqfhtVFkJxxwaNNxUPbpGTMJwwmX8G03BLHXD6Kq6NX9bjGPEhiJ9TI4slf0kEigCNl5xMuqJkpKg8OderBVr4HmAzqt5jsMFNlNPIlpatY+Lei+uJVF9283zB2FAq0FRWbxQsMfU69anHPtvN3fq78WsoYXr85W/zwqxWYjE7XYFIa2NH6PJEi6tvJZxYVX/7wtezP1nSp7Lr+zVhZWPlvmfe8mYzS6E5BZmCDMXg+JanwevJF6vRkE2Hs+KTniHM2msuGFVCAOUSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Usu0glu3nUhayY7b1gdRNW5AEkFYvybLm8x3N2YyJU=;
 b=DBTLulpk5fMw7pLg49i3Uq2zbBq3jkgiJdjWdNgjfH3xGnQCf0pmE/zaDs0zZssGR9Z0yuXe2ivhBasTokwLVxTwMgiARMmMVvL9zPrAH6uTvFCbXwdzeDi380c85UIltebT+4SkLEiTY/KqV+o0FwSDSRbgE2scWPzQc36VNLkHIQ5LUWaorkMa4HDDxjs8ad2sOwLjIB/ZWFb2qmZjo3su35KpvUasSFCqhhNGTiJi/hbAfmhqLGG6N/kg3W9QPIzG0NG2/5UiioCEEnAJnTDhp8/u9oHBbSGpXY75RnTQeJ3ZPfV6yPbzLAwGKZYDMdiLwAba+jo0A/7cKHkdXQ==
Received: from BLAPR05CA0010.namprd05.prod.outlook.com (2603:10b6:208:36e::19)
 by SJ0PR12MB8090.namprd12.prod.outlook.com (2603:10b6:a03:4ea::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.35; Wed, 10 Jul
 2024 08:35:19 +0000
Received: from BL6PEPF0001AB4A.namprd04.prod.outlook.com
 (2603:10b6:208:36e:cafe::56) by BLAPR05CA0010.outlook.office365.com
 (2603:10b6:208:36e::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.20 via Frontend
 Transport; Wed, 10 Jul 2024 08:35:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL6PEPF0001AB4A.mail.protection.outlook.com (10.167.242.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7762.17 via Frontend Transport; Wed, 10 Jul 2024 08:35:18 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 10 Jul
 2024 01:34:59 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 10 Jul
 2024 01:34:59 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Wed, 10 Jul 2024 01:34:58 -0700
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
Subject: Re: [PATCH 6.9 000/197] 6.9.9-rc1 review
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <543f6bf5-1190-41bb-81f7-d5fc7c8f343a@rnnvmail204.nvidia.com>
Date: Wed, 10 Jul 2024 01:34:58 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB4A:EE_|SJ0PR12MB8090:EE_
X-MS-Office365-Filtering-Correlation-Id: 142b03bb-63b8-407d-d70a-08dca0bb3acf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NVNEN2MxY3BjNHpQRXc2cGE4T1BydzBYRk84Z2xBTmRSZVNuZ2hEMlJIeGIw?=
 =?utf-8?B?Y2loeUFCUWc3MGNkT3JpRzhzbjJLbGRzQ2FUdkZLVmFocTZtTzRqZkcxc0VF?=
 =?utf-8?B?anJ6OXgxMnNwSUp0emVBanlxWm1NZlhyQ1VlM1kzdGhZWkdwNDdycldOWkVG?=
 =?utf-8?B?QThWL0RHSW40V09ZUnQ2VmJIL3l1b3hrVmZxR0RyMFY0ZmN1clgzUS9PWTNi?=
 =?utf-8?B?c1JaWlA3OU45ZnNHTmpydHMycWZSL3dGUzRoZjJTU28wVGtFZkd6UmZwS3B6?=
 =?utf-8?B?VzNrYXJHdGU3aUNtNFBhTHVNZGdFV0VGYnlqUHVLUUZwVWk4TTA1aHNNd2Z4?=
 =?utf-8?B?ZzRRQlN4VEdLZUdqMHJuSVJYcEZTbUVjdGlQTEJFeU45OUo0S0doZTFEeS81?=
 =?utf-8?B?ZWU5RncrMm84WWYvTkRIRzRHS1R4aW1aZ2VBRzZFTm9wNlI4YkdPTy92LzlN?=
 =?utf-8?B?OXNlcGNHeVVsdmk2QzBGZ2JqUG1WYW85WGtqMUMwUVpmbG5pRlBNZEdiL1RP?=
 =?utf-8?B?N0U1U2E4WXNld1BJVFc4VDFhK3ZPNzh2Qnh6YWhPZ3pMWm1wSzlaUjZOREJ1?=
 =?utf-8?B?ejNZbHZuaEFuK0NSZ3E3UWZpMW9sclZFT0c5ZU1GTldraDkzQ0I3aU01RFNO?=
 =?utf-8?B?M0tFV014U25GUzdDUkhKTHVLdnhvYmc1cUY4eTdxZXBBVStmMVF0Wk4yRlRv?=
 =?utf-8?B?YTJPVEFiaStRa0g4VnpiUUJYMDZRL0tMT0JGd2JRUWZENG1jc3E3c3dDQk5i?=
 =?utf-8?B?TFZndWpUZUw5bHo2RWZMMzh4YXVERk9ZbXpEMFBrVE9ZbEVkQjQ5cWR3RkhG?=
 =?utf-8?B?QVpEN2N6Wis4NVpxd3lFNC9yck5ma29uOENIVjZiTDU4SXA3VUFSNjVTWUlR?=
 =?utf-8?B?YUR6OUgraTVRY3MvWHhoeFlEcXU4RlE5LytUbG9VM05aTWNhc3ZGU25WYmlx?=
 =?utf-8?B?SS9weFNCR1Qvd2tDTHhJNUtBcm5EVEcrVml3MzB5enNDQWtnRitDMUtyVVVv?=
 =?utf-8?B?ajZPTmMrc1Y1RXBobDlVcDRHbFhrbVpyR1NpWXNaZ0RreEIzSGk4MkU0dEcr?=
 =?utf-8?B?aTlFVjlUNW1YN0dYcU9TWkQyTi9RZ0tJbXc3Z3JDbTV6UFY0NzBWZmVPaUZH?=
 =?utf-8?B?SEU3K3NPMFQwT3o3YUZDY21Wc1hoeS9Td1RKUVUzVWRXYXJJcDViZVd0VGpp?=
 =?utf-8?B?aUhQbWpqNFp0aVRFdWp5eU9oMzhwMlpBOW0vV0tCTWNUUGMyUG5iV0t1QlhW?=
 =?utf-8?B?VGd3V0VEVnd5TjhRcDQ4VGpRNnRqaEJoMnFObVZMMjFpN1ZUaUowcTJDOFYw?=
 =?utf-8?B?M0lKVHhtNzhXeEVrWTRGcC8vN285ZktXRTMyZGVHTVNOckVPdys1b1BIK2dZ?=
 =?utf-8?B?TTR5aUlKa1FLUzZ1UmFFRWdBMlNqNlhBWTVVd2hQSEZVOVNrZ21YeHNvemNu?=
 =?utf-8?B?T3NoNFN3R2pKYmZiOFhKYll3eVN4YmVGY1dNSWQvNkc5SVR4Q3RsMU1tcnRl?=
 =?utf-8?B?L0NqZDk1alY1alhZOTd5SnNYZFd2c2hsU1F6eks2NkZ0V0d6WUphS0hsTnlv?=
 =?utf-8?B?NzBBcXVOZ3gwY0tjUWFLNHF5TTRxMmYwNXBka2dHSldENHA2ZkY0S3JOdWpW?=
 =?utf-8?B?OFpzWHVqeU1NTDFSUXhxR0t4ZjRJVGczVnFxNWJlbUdJQVRPMDA4Z1kxeXNZ?=
 =?utf-8?B?T3huYVk0N2VDR1VWWkZxVzJTM2hVK250R1VNSGlSYVhmcDJyYndPTnNnZGk0?=
 =?utf-8?B?YVBIUHZiK1VaK3ExQ1pmRStFaDRwVXgxQ3BFMCtZWjBvVnA5b1hXSlVYVXhm?=
 =?utf-8?B?QVdLRi9TMVZvUngxZlE4bE1DK29ibFJSOTN5aXRhdVFHWnhkcTU2RTV0MHFn?=
 =?utf-8?B?NXMrbjhQdWhBbmZxL2tLdlIrOW14YzBSTjhjN1NDT3ZrVHpMWG1UZ0RDUHIr?=
 =?utf-8?Q?wKc7SUKpe17II8jzqN/KAIg8/6uan7Ox?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2024 08:35:18.3920
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 142b03bb-63b8-407d-d70a-08dca0bb3acf
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB4A.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB8090

On Tue, 09 Jul 2024 13:07:34 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.9.9 release.
> There are 197 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 Jul 2024 11:06:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.9:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    111 tests:	111 pass, 0 fail

Linux version:	6.9.9-rc1-g6ced42af8b2d
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
