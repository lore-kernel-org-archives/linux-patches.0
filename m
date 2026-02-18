Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010008.outbound.protection.outlook.com [52.101.201.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC50328B7C
	for <patches@lists.linux.dev>; Wed, 18 Feb 2026 08:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771402991; cv=fail; b=VqR6Vc6Q1JfFL8OsAau/f3Fk62zSRoFllTUmt5Tbie8Ic/MbHhF9qSouJvMmJWI7+IVb+2uI2HxloL8Um3Rgg5AJizHN+pYPgoojBTpWyj7sWZxbwjyrDJffhQVhlksk4wGXVlMSSR4xCyxE3TZZkavwXxmafxA1gy9q30GFkdI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771402991; c=relaxed/simple;
	bh=VZrU++/NZoc832N3TOK69vKcA7xUySE3+Mmnl2mEuW8=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=QyUwQ6L5IUs8CZp87aRNI7oCyGQ9kTJ60MXQONwsE4RdXz8xKJTWbNbpQOlSdX0eWNWIAYhBDQaUesg0JI3F6PxjUHkoArHLE3/d8Nkb2Vl+T2fDMwHi4tQ/EazGgCS7gdqtUJdV4My//Vxa8L44B+P4taN9TttQKjTjk97fmyY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BD9rGowi; arc=fail smtp.client-ip=52.101.201.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BD9rGowi"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YRxuccXifLJd3PrdrokojTAxpw0us4HO5yxWWRyUzoCxySeAy8HOE0ErSSTijYVEzcCFPPBG6CPrI70hdv2HJXb2Zqtebmm6VNDGHAx3/Ie/JMIk6Jdp68iQshGP9wLwBNucIY5p0SI5Gi6QYRq1VUf0E77BVudyuITaIrpKj/txfOGB3M4kpKXVJax3lShaUNiayKwtXq2Me2lwW+21ZG0ly32HI8Ecob5y1DhV/DXEk90ZXudK06PeuvrS3tevtgE1cqjwaOaOD9kGRu+BN0/HpAGjxomVngvOX04LDawbS8A4LQHf0HZKiNXdrFtnMoGAT2w4U+N/GTftERZ+kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AUtmD0ue9BAduypfwQIWT55kHUa9OTnAhfMG1y3ED2c=;
 b=J66nhHJRrrT97x9SCdn0fhClLR3bZlPFZP63Vn30YqfdJljag0cI1FfIpe3ZZbDyZ0u8KugMnaGz7BIjq5LVreOub0RAH1MFFXmKWyo5A58yTsQ1NkdfkS1O9s4iqUag0ufZ4VH27R/FrQIhkDP7KFfg0dg3ZcJbfYmQi4R6G22uxTLo4nia9XDoYH2SZvHuR7Bkk11iE2+uzJBH4Ze5Od6dZyzluGWSGYKpwrJeC8IpjF++TVnpSSxBMUIuplXOXmitSzcYijNvDr/LMcBa8Q0kDnq9Logdsp8cvU8Hmy0PU4iuRvMN2F8Peto0WmyeuclCSwdbROlc6W4JxQzydg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AUtmD0ue9BAduypfwQIWT55kHUa9OTnAhfMG1y3ED2c=;
 b=BD9rGowij7+JG1jEL7WmvcZUC/cLtXBtXIIhCqjwrhXLmSV+4ZvIa/iIIo1pUnKX1aLuBfuSdnAS8pDtzjd7XxtUtys3JTweRv3MXJQ1OPu/SLG4UCpUQCPooreH4bFbfOs8/NH8bViiAGtmKOgH5BSWM8gnnNu4zyK5Pw99Qx8AzgKvDy6oKFoYtAXndw79fnzYKadQomFj4cW9Y+GO6VCblWp3HN+NYW3DaaudBnvsSl8GwUJjHw34LNnW/bB8XCYzq6ynjuMYeXtCldcnTHmduNOX+X5VWUmj+j/fxYpKpMK+0By18Xyqu9FjEgn7NpmgEBxvPFE5atWIPQlT5w==
Received: from MW4PR04CA0186.namprd04.prod.outlook.com (2603:10b6:303:86::11)
 by DS7PR12MB6165.namprd12.prod.outlook.com (2603:10b6:8:9a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.13; Wed, 18 Feb
 2026 08:23:01 +0000
Received: from CO1PEPF000044EF.namprd05.prod.outlook.com
 (2603:10b6:303:86:cafe::f0) by MW4PR04CA0186.outlook.office365.com
 (2603:10b6:303:86::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.13 via Frontend Transport; Wed,
 18 Feb 2026 08:23:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1PEPF000044EF.mail.protection.outlook.com (10.167.241.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Wed, 18 Feb 2026 08:23:01 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 18 Feb
 2026 00:22:50 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 18 Feb
 2026 00:22:49 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Wed, 18 Feb 2026 00:22:49 -0800
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
Subject: Re: [PATCH 6.6 00/39] 6.6.127-rc1 review
In-Reply-To: <20260217200004.221651386@linuxfoundation.org>
References: <20260217200004.221651386@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <e3d957ad-9d9b-4b4b-a332-c2eb4ab6c576@rnnvmail204.nvidia.com>
Date: Wed, 18 Feb 2026 00:22:49 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000044EF:EE_|DS7PR12MB6165:EE_
X-MS-Office365-Filtering-Correlation-Id: 519aaa62-cf86-4f6b-dfea-08de6ec6ee46
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|82310400026|1800799024|7416014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Ujc2bWxHdWJIem5JYkVTeVNhTGQ5MkdjSzduYkRmU2ROSjhlWEp6YkF4bkto?=
 =?utf-8?B?R2NQdm5VZWtHU280N253YkFrWWdRejJVY05SWWxBRWhYYWJxNkthVWdDL05R?=
 =?utf-8?B?ZHpwNkZHVjlOYTd2b1JlZElrc3pueWIweGhFemxNVlRuVzVoSHZFcTQyL1J2?=
 =?utf-8?B?eU9iTFdNMVBFWE80OXpMc2x0aUFSMFZ2Yll6ZjkxMU5YOUFTVXE2ZGc1Z1hO?=
 =?utf-8?B?UmFBNTk1T3pBb202Wm5tV0ZiajVDSFV3VW9ZVEZLQ203bnZ3aldwNkRQMFNy?=
 =?utf-8?B?czdRMU82VWNWWERHUFVXL2R2OWN4ZkQvTHFlZ29RZWNBdG5TRUxtWVh0ellv?=
 =?utf-8?B?bXlyNGJ1U2pZVy8zUjQ3eDB6dEJKMkM1QUQ4SEtIVVhUNTFzVkdEMDJuZnpp?=
 =?utf-8?B?Zlh0ZVlvRjdEV25mOWJRQmVJUHJRbzFXdmZOemlIYk5PdmcxVk5RQUlsejIz?=
 =?utf-8?B?eUlyYXBrMGV6Z01TMWhKTXlEUEllN2VPTzFiaStRK1ovSzF0NUpjWVBZZ2w4?=
 =?utf-8?B?dEt0NzRRNGdoZ1lzaUI4UHl6WjJjaVkyMEt4NHR4aWtBQkFlOHYvRk9zU3Qz?=
 =?utf-8?B?bDY4enJ0cTB1ODN5cHlML3NnNWVkb0hES0k0bEdxVjRvM0s3YmZCQ0VVRnFS?=
 =?utf-8?B?SndNZ1h3aU4xTFB5K0FubXRwM2ErMmQ4NzdUSzhJK0xtT2lsVjZ5b3hyOEVH?=
 =?utf-8?B?cUpwVTBuUmJBV0hHVGtnWFhGYWo4RzY4ck5jV2JQWlJiYmgrVDk2VTRZZHZw?=
 =?utf-8?B?RGl1cDFVcWsrRytxM1kvcEl0ektSbDFCY3ZpQU8rTzlVbkQ0Ty80MTVERjBl?=
 =?utf-8?B?ZTRGQ0dXanNRZnhremIrSGh4UzQ5amNLaWtRYmx4bTlRNnJmUDhGWWNNVm9U?=
 =?utf-8?B?dTQwVjMrbE43eUtTb1lsRkRpTUVHK1lvZS9MN0tKQjhoY2JseVI5Um9LOFhB?=
 =?utf-8?B?Uk1meVd2Y3NXeExZS0FpWVRsNDJGdi9BUW9hMEJUd2lZbWZPeXIwYUlGWUN3?=
 =?utf-8?B?M29KQWlicHR4N1B1V0pxYlpNMWlaOTQ2ZEVnVTNkTnJnSHpHc0hHZVk0UWlK?=
 =?utf-8?B?MVYzUVYzWEtXT1gxaVRCTTEwZVN5RDFDVlRVT3FWdkszVWdVaVVpMmdQdHN0?=
 =?utf-8?B?WGRQb0V5NVZuTnVuaVJGei9PTFE4RmliYURLT0J3TXVURHlNZ1dIVVpFK1Vn?=
 =?utf-8?B?eWptc2xaTklCS1Qweit5QUptOTN3WjN0WG4zNzFCS3lOa1RyNGtueCtqTm53?=
 =?utf-8?B?akNvZkxTbEJYZnZpbDBZdnRGald3SVg2aW5ncFNCNjQxdGNhU1prSDJ2SExZ?=
 =?utf-8?B?c3NtY251elovY1BabGtadmdXaWtDSWJSbVpscVpYbW41dWxHOVRGZHQ4WmUr?=
 =?utf-8?B?cEtod0tvKzFHMHpNaVNIMlhQTU02M0hrOHN2WTc2QXlncW5rcXE5MXlvUk9P?=
 =?utf-8?B?a2d6eFlYd1RhV2lPeTVMa08zYXVVcVZYb3hNWEJBRlBEdWlEcW1MRUh0MWxY?=
 =?utf-8?B?SG4zRkwyWUxaS3V3cXZZdmEzT2ttN2dHdVdNYnM1SFVFanhUUi82ZkpXYkxR?=
 =?utf-8?B?Uno2T2hUU2Z4cnBoRUYyTGoxam0zUFcyQzEvdVdzaEVJM2E1T0VEMlpWVWUz?=
 =?utf-8?B?ZkN4dllpNjM3ay9nNXhoWTE1RTEzN09vYjkyTFZMSkMwaXl1Q20wb0hsclVT?=
 =?utf-8?B?Mjl6eWNRR0hDbGFUVG5pTkEvcHo5VEZGWk5JZ3lpM1dTZW0xZEhMQ01hR0Qv?=
 =?utf-8?B?N3JHNTN3eDZGbkRqSHZjYktDYzJUTGhkeEM1eU01NDlwTit6dG1xdjlFMzBE?=
 =?utf-8?B?dFRMS2xwNmRFdmdxVDlnc1A2QlhQQWJZK1MrNjlsa3F0emF4SytrODBUeU9I?=
 =?utf-8?B?dzFqT2tJTnY0V3U4c3dXUXd0enoydVFrY1hESFdEdmtGRHdDUGZ3Ukl5elJu?=
 =?utf-8?B?UUtmSGoxRXpzQ05BNnJhcXZ0R0pxeURXSHFyYjJvQjNDNjNUSXJXU2RDem5B?=
 =?utf-8?B?ODBIVEpoWHFUTEoxWnJQUURXM2FpMEtUR05xbUNFcnJvSXlhY2swWFUvWHNa?=
 =?utf-8?B?M29nSFdXS1ZYbkVEV1BqVW5LaGk5KzcyZUhQRGdmOFhtRmI2QlRsTzcxU1JM?=
 =?utf-8?B?TitrR0ZwakxLWUlMT2Z1VFFJUTAvVVVEdTFGOTFQam52TGVSQTQ4STYwZUJ1?=
 =?utf-8?B?eGRtM3BqOVg4SE1aV2lkNXNjaFBOdkNmKzRQMnl1OUZtUVpzdHNOMFhjTzhP?=
 =?utf-8?B?UUZOUDVOYVJnNGloSDEycFBjWkFRPT0=?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(376014)(82310400026)(1800799024)(7416014)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	e5sYNVLr8HnKWNXXqz/gnVyeKFZDWb+r9CTs4yu9ZDhIGlRWskFyMv00+fyIwVcBsdgkMvT6cDlnMCZ9OR8CaRiXVSUlUSWjJL/jXP3EL8ZgHMOGZj1bBOCS4zB/SY7+q/uzCPHTemBZoxNSmfb1KIz0SHERAZkbFNy2TPmPV3xgwoPkQcI+qvushV0rd0ufLkbdZA/uHsrvJJYLAYDTfnUQaiQVBC/NIokDCp3WkZ23UyMikDTY7JV6I0GFyczkpWHuFpuNss1XDVw55129EFrAShLk+U2xMeV81pcxaQE6i8cY2SADmxclEgrKR/YVg0t2fq+YqJ7BAqQswxPXzK5Tdvdpxo8ARv5MY4vdY6jMR0gYqd5iIAQKoOvi2zRRjsg5EaU5ULp0q2UEF70ZjHx5mBjwgxbjqFXS/cGXKAj70kcRtIkssTvqGhebCPbR
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2026 08:23:01.2474
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 519aaa62-cf86-4f6b-dfea-08de6ec6ee46
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044EF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6165

On Tue, 17 Feb 2026 21:30:22 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.127 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Feb 2026 19:59:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.127-rc1.gz
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
    133 tests:	133 pass, 0 fail

Linux version:	6.6.127-rc1-g27a952792232
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
