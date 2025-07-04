Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2073.outbound.protection.outlook.com [40.107.244.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A47A2C15A1
	for <patches@lists.linux.dev>; Fri,  4 Jul 2025 11:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751627636; cv=fail; b=DVYVHl+ZiF8NHVQoXl15/b2qZaz+FSM3yLzHHnEWuFBIW8B1oEwG6kZ3IvKrGpgzr1qkcJiF3WmgbJetTE6Y1bAR0PMJboBBfL1Ku984zx3Cb37AEOHnsifuxu9WFrKmEoXEkJXTUfKZWuMq01iib3agSlxAB0lok12GbmJfZ48=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751627636; c=relaxed/simple;
	bh=sWIi9E+1IcPSn1IA5qgkYQd1WgdqwR4Zuck3IFbqBgk=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=r0RPzaDPlXWshgj/trMjGSPqJH8AoNp7t06elp+qf8sgY1ktKB2Oy0pC3Me10euU0P65RXaiAgvlKL5jL7VBpQdeVhpnN2Naj0Hsw1ZOexCDKkfBNkcRGRQ8UTfzTq4zWC4PN8KsMutNXxP84luNeT+tM9UmkiDJnIFZwj4oAJo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=uCnkGiF5; arc=fail smtp.client-ip=40.107.244.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="uCnkGiF5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BaxsGhzYMXC9hqwtS/rN6/bjtu38sBq96kPFfeoTZzN9UiagjD1wcRG2fzEOqzPNUMIEBtIGRWXQHQp444L60j4ZOqzSF9pyV6SqudCIdZu/TK6UtL/DPsJPFZh2L//obNLkiVxAzMVpyQqdVlleVsdW8InhbDFAbAn/M+bzskQG8avrGEf7/aC6yeqZBLg0y0BGDSQWISk2gziuWqITVkwypFGmzZCmqsaAr+gtAqMc5JzvNGqOkJuF61SXtBGWSONiQge7NoXWKQp0nQ+OUhcyMwzvMjBlVKrit+1QR27Q7vXPV/gpbZGVpMb6r3f2pjqAIs+MHg605mRngKGx4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OREXOXWdjxxceqbZP9C7q56SOy/PXtYNy7looBnWQBk=;
 b=QO/bU4rKNEAg9dVRsU4kyraHQV2Uw4ost5toT0UGCQRx0t0jfEg3FR3QbgYNxNczlgFPj29gI6chz4wU2vAsBpsqN6ACYSx7SK3wfWMe+scK6jQdkp0KnFkLsyPjL3YsCfCbf2y3E5C6umTq6aCS2rV59fMDTqWTcRsFX8FmVfY0CmQu44CQwxkHZXHN7l9R6qGYmV5W5mCHJc6P47FmAea0PCitgde8/K1ZXLg359lgLII0JMWN21YkMwiOW65kurCfT5ecrPwLHdz6OKmTzoNQRij36v0vqBLM3AnzZI5YR03/f8ihViNpMOm6JAHL/i+Eu6h4aRn7EdS12rRY0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OREXOXWdjxxceqbZP9C7q56SOy/PXtYNy7looBnWQBk=;
 b=uCnkGiF5jpzKRJ0aR5ySH09W9XfmpNBM/adR7qj6yj6e/97UGYASTS3/Tc/L1jXr5EUc8sM4BlA/+Y9IRuuBlkPsi9nok6y9NoYT9gYWfPIttOp5NpbJbHl6KzpW3c1f3fPaR4nE/sK+1h5xyb7wH6o+gkNjDV7MK8PGcJMx8W1zJVCT7j73Z84wvpW/iY6JlS7JgRoEi4SC5cIYxL5j6LUe+rDZ7Q7bcTcNIptFidKzQmsZNKiq1dPjUoBEsLCKyw4AuQ033sbkApPMJxnm3HgVhbySbelduQesRuiJ/a/+WFAteoM7OsFjd05lwcAtRW8FuR6BfF3aQl0SBPx66g==
Received: from SJ0PR03CA0006.namprd03.prod.outlook.com (2603:10b6:a03:33a::11)
 by SJ5PPF0AEDE5C3D.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::989) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.26; Fri, 4 Jul
 2025 11:13:50 +0000
Received: from SJ1PEPF000023D7.namprd21.prod.outlook.com
 (2603:10b6:a03:33a:cafe::65) by SJ0PR03CA0006.outlook.office365.com
 (2603:10b6:a03:33a::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8901.20 via Frontend Transport; Fri,
 4 Jul 2025 11:13:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SJ1PEPF000023D7.mail.protection.outlook.com (10.167.244.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8922.1 via Frontend Transport; Fri, 4 Jul 2025 11:13:50 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 4 Jul 2025
 04:13:44 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 4 Jul 2025 04:13:43 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Fri, 4 Jul 2025 04:13:43 -0700
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
Subject: Re: [PATCH 6.15 000/263] 6.15.5-rc1 review
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <94e8d435-650e-49f6-b957-ea60a0986024@drhqmail202.nvidia.com>
Date: Fri, 4 Jul 2025 04:13:43 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023D7:EE_|SJ5PPF0AEDE5C3D:EE_
X-MS-Office365-Filtering-Correlation-Id: 49eea55c-7701-49d2-e771-08ddbaebda87
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014|7416014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?czNaTG1vNUNENW10V1JWMEszUzVvdGx3VXZFZGJhZHZSa2NiYXJVY0FqZ3VL?=
 =?utf-8?B?bDZMVHlFRmZuL3lvRFBmcEJWMytkOFRtVjhUeTBsV3ZabFA0V2lFbDBPMytD?=
 =?utf-8?B?VWpXcVNkS1RKMFVEc1RFNGtlRkdPUGx6QWY4Wm1XYnBrd2tEcXBjL1ZKeG5v?=
 =?utf-8?B?QWREQTlCc3NVNU9iT3ZyelB1cEtIOFBub0tORDJuUnVvdEhFQWQwQ3ZLK0FM?=
 =?utf-8?B?TXNDeVhmNGVjcENUWXBKczI5RjFMcCs5OFVzRmIzUy9YRTN5Y2FkR0JsS211?=
 =?utf-8?B?QVFhWkdqMDFvbHhvNVFQSDdnb0NST3FXYkFreFp0S3NGU0FOaWNtVVlDejFL?=
 =?utf-8?B?N1ZXWGN6TXhoYjFlT01yM3pYc1R5bWVVMG0wZmpBdlpqZEFmWnBMY3hFZk8v?=
 =?utf-8?B?ZjAvd3ZEeGwyeGNPOUlGK1FtWmgrL1lhWTBnUENUMUFQNEJhUmtvcElPMnl5?=
 =?utf-8?B?eWE4NXJtcjV1S3R6STFLYzU1L1ZtREJuN2srOGR4NzFTWWtiZHhyQmt6R041?=
 =?utf-8?B?U01Bci9tbVhHbW5MS05mU2ZtY1RIWlVnSHFLMWVUZHAvZlIxNUkyK0NTUDBW?=
 =?utf-8?B?amt5b2ZWeStBS3huQ3h0NlhVZFpaN0phRVhMdjhtZ1ljRjk5dW5aWHVPWDdi?=
 =?utf-8?B?N2xaVDFyQXZlbm0vQkd0SHN3alV2SFMyV2xnRUdKZ3VBd0dML1huclQ2UndT?=
 =?utf-8?B?QSt3L0pKdS84aGJLWVp3WHpsWnRpeTZBUzBDU1g3elRHNDNMRG5iUExhRk5h?=
 =?utf-8?B?WVZCL2NienVQL0tSMFUwczRRTmFNT2QvcWV0N0pQTTFCU3NzM0dydTF1bnJ5?=
 =?utf-8?B?dk9uRWlsUDNiRnV3ZWU3UG83Zm5mWk9VQ3ZrWGV5dmRta2lmNzhVYmx0ZXZY?=
 =?utf-8?B?cldmci9RS3I5NHJDOHprTHNJdDJaUTA4RjRUUE4wdW5aSXZ2Yk9JalBBMTVJ?=
 =?utf-8?B?QWROeEJBTTUwZzdheGFjTFZyWGY3S2l3bG1Ic1U3QmM1bmsxM1g4RkNsalZi?=
 =?utf-8?B?SHlQaDd2Q3BxV0VHcllhZURwdFI4TTQ1S21vazFBWUVzb24xQ201SGRCb3Q2?=
 =?utf-8?B?eFJJVnJaMU0vdkVXK3RZNTl1cDI2alNJU3kwNmlVVm8yTVdEOE82aExGVUxJ?=
 =?utf-8?B?VFcwcEZsNDJkczFtbEVUTW10MTQrZzZyY2g2R3hQY0w4YkN0MXZib0hTV1ZV?=
 =?utf-8?B?RU9DSUx5c3E3VERGdG5zNlJ0YXZQdFphUkVPYXZpU3JrcTA2eXJsbGZYVnBG?=
 =?utf-8?B?OGFzK0Q4bHZXZ1p4K1ZTY0RhVWhUck1HVC9nUFFEUnlyWVRmZUtIUHRmSFgx?=
 =?utf-8?B?enFuNm9VT2lUWjIxSlFHZHRxaUVmSnR1VlcwVUNjbTluckFXYmgxNmhMbDBh?=
 =?utf-8?B?SmJoOEFhaHFkdGl6aFlCY3ZJZnFFTlF6Sk1GQ0QwQ3NJblFlNXl1V0g1V2tv?=
 =?utf-8?B?R3JJUHNpTjZBYVdQMkRDdXkvM3BPWU5ubDFKR0N6dEFtU1E0Rk9wQldtQ0U5?=
 =?utf-8?B?OFNpNWpYbWtZaGJNK1RJUDJ0NnN2TkxBSEJVWnpKdkxvYUgrQVg1RERrTGph?=
 =?utf-8?B?bFhXOUNQenlGMllFTkpMRGpyWGxUQ0UxZVVhY21TS0RSM2NYMHZxZVgyWUp0?=
 =?utf-8?B?UEFaRUFadEhudGhyUE56VnU1dUVEUGJnWWtmMDVlVHI0Mlc2aWNwRVYyR0Nh?=
 =?utf-8?B?RzRBcFNWbHJuTzNvSUFSR3hmSWd2RXpPRmdjVVFoM3JnNEVRTjdUaktJQWF0?=
 =?utf-8?B?UG5PbHZOWlA2SlRyeTVkUVBhcFBmTSs1WmkvZ0E5VU5xME0xc2h3OUFnZjNz?=
 =?utf-8?B?NE9OdTBjamJCYU5mV3Y0UHQrT2NiS2V1Sm5OVG1HNTArS29iYnAyYUllRDM4?=
 =?utf-8?B?YVJtS21nMHY5dWtMeHJUcXlmQ2lNdDBzSEMrdnZoODJZZW12OG9mWlBDQ2px?=
 =?utf-8?B?OXRnVGtTZlZkbW5zQmUxT1g4cmdjeXdvc1ZVUS80MEZLckl6d1ZIeU1ka2cx?=
 =?utf-8?B?K2JCQUVzR1I2SnJoNzM4R3JXSldVemkrdmFlK1YrOVBBWDI0RDV2TTV6U2Z4?=
 =?utf-8?B?YXhnekM4ZnR0TjFqNzcvMEFsS3EvdTg4ek52UT09?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014)(7416014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jul 2025 11:13:50.2546
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 49eea55c-7701-49d2-e771-08ddbaebda87
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023D7.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF0AEDE5C3D

On Thu, 03 Jul 2025 16:38:40 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.15.5 release.
> There are 263 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 05 Jul 2025 14:39:10 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.5-rc1.gz
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

Linux version:	6.15.5-rc1-gd5e6f0c9ca48
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
