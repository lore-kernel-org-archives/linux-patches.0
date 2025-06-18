Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2066.outbound.protection.outlook.com [40.107.92.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E8F207E1D
	for <patches@lists.linux.dev>; Wed, 18 Jun 2025 06:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750228941; cv=fail; b=reoFLYBXfidKWk6AflP5Mli1HDNMOnH76mp1BBefy15Cym8zCJa/Qswn3PoVCXu+UhNkUgzUib8VSi3ub10RcI7b9hZ11TrXUVrR4jUGC8JDRmBgzzn+Lu5vCTI4twxUYVljLOYbgvmbR2PNBVtdG/0FgJC6te8GXStg1uy3MJ8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750228941; c=relaxed/simple;
	bh=byDDNfttx7aI4gJOV+uBrxxwKxwyWKI4QM397WooJ0M=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=aByzmJsIi3yPuYIYUlCUoA3bPjopAGk2GhVqdrlnHaqrsoYVMixtnZTqXhW2P+JPOGWXavxayGVa6+69QFvWAp9OJsqLJNt7CFKKhu/Gxenh0eZ47Fw7TV7eVfgvyjAo443k0wHxTua/JQ337GfcJsSqm+S80pwPwNOyrQLPMqU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=U9ZvRog0; arc=fail smtp.client-ip=40.107.92.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="U9ZvRog0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=APuSsz6bB3KAF9l1VqMfVF7ipiuIfeB2cdzWjgojuFVZ0Yti5xHYkx9zE0QRr1T/+bD++FKGQGaUVX2q1X+7vt21bLLy5/RBe0iWSEfVQn/iC0dSSvetEdBdltkdynAjDTyJ1hn5sBpsINP0HsS1W3kuFhwnB+SxFUO33TvN0E3/HUvF3n4Hi39KId4yInLopgK4B037DHeJ7WutviLseiP2WOjYPNfMwkPQAuk5+KKbNqV0MjOdEXodC+jf8tEKaXCj2AT9Ja0lZZMVe/8zGm1zwLBYjCbaXpt1Ml6QPTada0nOODWJ7qShiAhEdGsdhCvGVVBr+kFkLerz5W9rmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G+EKLyX8Bv1TiU1yWH5NMi2Rrk9bRKZyvAioejWMlYc=;
 b=S8dVDGJjvO1PQMHNuZ/OrpvUv9U7aGiHX4nNVHBA/DxacKfrgBGhS+x++xRGspQQ123Fo9pr3omSAjOipc0qMcykdZ7fNA759nfIeyFsuLepcN85buAmYoUUNN50uyYEOH+uGDd/8S8bRNZCDCxIP87E6HbkWFZw9k9SkgHrBg0MvUyvARj32J0Pyp0xEk2YKJwVAYEJzjyR++zUFvtlWDPkCO6f5gjGHS3UDRX42/a0bL6KYpJohAQ3l1RSOn+VImeqZ5acdvval5OeocFHGyoTGtvrkd1VKGU8RMe+K4CApyxrGjB+o3tzKNPUOYm+aUcs0yM9SbOTZ5Gq0TrvzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G+EKLyX8Bv1TiU1yWH5NMi2Rrk9bRKZyvAioejWMlYc=;
 b=U9ZvRog0xtNX1AcPog9tiCGVd9T4+vRtF56SXcqRRCRoXMHEvbLUWicSsjXn5HGfN4NPkX5QvZIvqH5mFffBT+LgvUCX9O3o2VhQ3eQZAWz6l/HEtaDlyeVrTDGPZCUUfZBqa/HLhhc2zB4ctRszNwRgpwCJTXk4Nfe/h28y6v/TKbHIDD4o1RwFh8tn9YXsgLPvao+FkFzdAzZYNFmC4B9Q4Gly2XOXN29lPFdgvbWZtZmg9BBirJcU2ZJhW+42VJrpyEJeUJ0J4CIVXi+1mwv4PbTLOzO3r7wEEm/ebgsJRepULaPRUlN+om7Zr8Bd9caSfKymCp6y9LjFnav2Hw==
Received: from SJ0PR05CA0098.namprd05.prod.outlook.com (2603:10b6:a03:334::13)
 by CH2PR12MB4071.namprd12.prod.outlook.com (2603:10b6:610:7b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.19; Wed, 18 Jun
 2025 06:42:15 +0000
Received: from CO1PEPF000075F1.namprd03.prod.outlook.com
 (2603:10b6:a03:334:cafe::84) by SJ0PR05CA0098.outlook.office365.com
 (2603:10b6:a03:334::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8835.22 via Frontend Transport; Wed,
 18 Jun 2025 06:42:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1PEPF000075F1.mail.protection.outlook.com (10.167.249.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8857.21 via Frontend Transport; Wed, 18 Jun 2025 06:42:15 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 17 Jun
 2025 23:42:02 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Tue, 17 Jun
 2025 23:42:01 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Tue, 17 Jun 2025 23:42:01 -0700
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
Subject: Re: [PATCH 6.15 000/780] 6.15.3-rc1 review
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <9b1de6e8-b07b-4c92-8234-5ed25b9f85ca@rnnvmail203.nvidia.com>
Date: Tue, 17 Jun 2025 23:42:01 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000075F1:EE_|CH2PR12MB4071:EE_
X-MS-Office365-Filtering-Correlation-Id: b9d86965-41a3-49c1-292e-08ddae334351
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|7416014|82310400026|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aEw0ZUJQTFlmZE1qbFVPOWY5V3ArQnczZ1dwWll6MDNnWXZaYW5ON1AwSnFl?=
 =?utf-8?B?RnN2Sjc1bmI1UCtDWTUxMVJ1VFNxS3RvbjZOb0E5WkNPYUJ2Mm9zejdLUVpW?=
 =?utf-8?B?MVI0MzJCcE5aTEdNbksvMm95d1pGSE1WdWIvd2QwQjhuWnBrTWhqU0tlNm9l?=
 =?utf-8?B?cTN6OURTM0pZeHBPSzZkUmpBYVhvYWJuRjM0Y0xWTzNMTC9yUlVNZjhxeUdM?=
 =?utf-8?B?VC9GeHpwZW0vSGxaYW5PMk9jcHZ6K2xiZFU5KzNGb041aUVSS2Q5M2JqanZy?=
 =?utf-8?B?NllBY3FpSlVxcmZKZGF4ZHJzbUdvaWdjUnVDanpiZE1wR3dmMnF0RENEaVhy?=
 =?utf-8?B?aXp4YVVOS1c4K0dVWnlOaGJMV2I5cGNuWFN1ZWIvbWlHMTF1MHBWTjFWQlFa?=
 =?utf-8?B?ekNIU1lnWWtsTVdnL3lKeTYycStBeWF2OXliVGlPd3hucUF4Mi9zS0IxNXJu?=
 =?utf-8?B?dlN3cmpRSm1NdThpaVZST3lhTll5WlJWZEdLeUVmSmlYWEJydFAwKzcza3JP?=
 =?utf-8?B?ZTlmaDFza3daRGJlZE90VFBhd0ViRnBKc2ttS3VCajVBOHRGcm5oZ3lRMjcr?=
 =?utf-8?B?YUZaM1pobHhmTjZJd284SjFqbmJ0MkZvODFWVHBDdHNQdENGdUFoaVdkQnVU?=
 =?utf-8?B?WXJsaDBnekE5MEFoU0JTVitJSUJwN2lwaUJJcmVOM1JjTkdvVXh4MURlbjl5?=
 =?utf-8?B?WDhHcnVlUjJ0aDkxWUlFdXFMN1hNYmZZalBLRFNjUFh1WVR3dHBJQnBYN0ov?=
 =?utf-8?B?empNcDNsMEl1NElhWFd3cE91SGVQTFpXKy9GeGNNQzVhWlg5Y0p6T3FxNWtx?=
 =?utf-8?B?d014TzVzUzFsRDExSUROTmY2cTlrcVo2VWNJU1FqWldHbml2dlNndkpEelMy?=
 =?utf-8?B?NW5ZR0VZeFJnZ1ZWUmx5TDA5T0dVZzVNb0Rpc1RjWEY5S1RITXgxOUtacTRx?=
 =?utf-8?B?T3JPaC9hWGlaTEV1MG5LOGFCbHZkMjVWSkdDODlKc3lpa1g1T3VZbTc0YzRU?=
 =?utf-8?B?U1ZmNDdqR3N0RFpZbE8xZjdXZzJIWEtuUUpYNkZyMUJYZ0N4QXJ4YTJveG1Y?=
 =?utf-8?B?bmNXcnJ1MGs1RzZyWVRKL28zdG5Ha0N0SzNWNHpMSUxHcnp3V09vRDdJWlRH?=
 =?utf-8?B?VFFraVc1cWlUNFFpbWJqd294NVhDYklkOGFjc0ZpNUNVdUw5OUs2YXZUWE1k?=
 =?utf-8?B?Ym9JUXIxNHdKZ2dqYTc4QlhvbXNieVJtMXdpc3JsUmZnTXcxNzhQejZ6Q3ov?=
 =?utf-8?B?cTRIdTM5UEZ3K2N1SEYwcmVCbVc2dGhldXRWWWV2T2NNM2NtWllsZDNrZ2NY?=
 =?utf-8?B?RHp1OWdCc1BGRmV6YVhKRHlDdmtwWFNtZHZmUW5yay9WT3lMZEJlWkJDN3Q4?=
 =?utf-8?B?UWxxLzlScjNkb1JYNHc2cGF1NFFiTVNleXVDdE5obVRKcWczMmRybWdGckx5?=
 =?utf-8?B?T2dranZJWmNDRUt3ZFdmUWZpdzB1M1U0R2lHcnBEZkg1T3B4ZFZHbGRIZFhi?=
 =?utf-8?B?eVVhM2JCM1FIRGFVUHRBbnBEZ1lvTVM5bFhBRlI0UlZXVmlkRE53VE9XN0RP?=
 =?utf-8?B?eVcvL0M4NHhTNHg4d2ZDZlRlWDZEMHZUZkFqSXZWY0xQbVRtYTIwZGREejdU?=
 =?utf-8?B?ZWpiK3JpeGI1eUtxNkltaUtXWEFEK3lrWFZoUjk5cmM5UlRZOWpaOHpSZjhl?=
 =?utf-8?B?ZVJrMllMcFJFZytTc21BYUUvQ0daOXgwVzMrcFRyaEVJdUhtelpQQVloTW51?=
 =?utf-8?B?T0lmaTNCUUw2bXNwUzJVR05tNWhUWnZKek0vQ0ZiQlJQcFVaWUdJdEJVdUNJ?=
 =?utf-8?B?SmFJOTNXL09nbk9QcmNEQ3Z1RWFnKzBoN3B3WXBmZm1JVkRoNUk3V1lnM1Rh?=
 =?utf-8?B?UkJUM01QSFlOUVJ3TzdsQU8xbC9CUVNIRkFETHRCaFZ0Kzg4N2xkc1FWNStm?=
 =?utf-8?B?M2FKZk5nTy9veDNhTXBueW9SZGxGS3Vobjl5ZEZiaUFYeUxnOTJUTkdrWGFp?=
 =?utf-8?B?OTJzSk9ycGR5cCtlSUxUejRTSW5Jb2QzWk5OSmpUUmd2QTkwSlNURHJNTXJV?=
 =?utf-8?B?MkNpZENlc01jRGdzVkRhc0FxMGdWRkt0Ulc2dz09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(376014)(7416014)(82310400026)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2025 06:42:15.1431
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b9d86965-41a3-49c1-292e-08ddae334351
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000075F1.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4071

On Tue, 17 Jun 2025 17:15:08 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.15.3 release.
> There are 780 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Jun 2025 15:22:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.15:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    120 tests:	120 pass, 0 fail

Linux version:	6.15.3-rc1-gd878a60be557
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
