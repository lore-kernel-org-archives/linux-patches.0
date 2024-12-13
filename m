Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2058.outbound.protection.outlook.com [40.107.93.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 375471DFE09
	for <patches@lists.linux.dev>; Fri, 13 Dec 2024 16:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734109051; cv=fail; b=NnX4z1pU0X4CIjxKldzWJGQnh/5LbGH1aNftccGagLyzRA04lWYFD8ogoIdbHoTXMqmsFf+3Kg04rVIW1/TMPerZL837edaopYO0y2JxkywQq7F/IBEejQ6PN8rrQOo1SLO+1V0aHwrxIkY98oLxm3DixQM3p+/lJDt1DXBuqmQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734109051; c=relaxed/simple;
	bh=r1tsV8rOT/iT5Gy5s9kOqBvXCSIrYclt8JoVxDwWE5E=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=glbnjv6g+Wv+pgfaux7E8fSQniCsqjImANL5UQwmoBExpVOYrUuUZn0oBanOAahqa1XhzQkl2wsiMqRlSovhJltbTcX7GXmWsAz/9ifwBUnuHIuhKpVHIlso5cCuyWfn5xy4sSZAW7i31OuR8vTgSLt6bP9SpeLs9e/6efsCyvw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=HzOYI5ZX; arc=fail smtp.client-ip=40.107.93.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="HzOYI5ZX"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EH/EfXSo5lJ+JFO6bVtsOo1glyp5EOsVisA7LY/WjAMsZd1lfngTsbeF5MEEVClt4jPJRIbfKCmO6Z6rWcQzFJZYppTcejiANMc74pIWBGEpTXgHRuTw3EoeVIWJP3CVMX2u257xtIeoKJ+14npxeFkFOCJkLtNrvEjp4aKbZOeMzeefGmtPh6Ph0VvBhETdcHPUxIcRznqARoUye14MlG8W+YjdVrbLESjKUPWrwhyB3Bv1zKEickPxZKpCX2hWhfinekR1fPnJTjBCifxpMz1+T9maV55znVxsR5EYr6vajnRn6wpOTmYYQtXpcZLUurAKtDMh2s48RKGmEm3jsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UGs66Fm32JtkgGVeJd/ROGiK9BMtxJ9oneD85H7sMh4=;
 b=IUETWWd+geiJamvD7VAMaiRu8iPqIjgn+ynbAkvCvmYerLIgfFPdbnOIIH8mi0W2v8XdQnaFvbmHJs5qLv9eXFme0ih5SfdHx5hxnU3iPk8Av8IrSyb+qgyKkC7cQtaBrMX2qHAeTYN4bR9xYtYVn9Mri7mSy6J2gwt48AEAqwuuUpHbxn59dHw3yk+lqQTp6sSh+GeXxp0XUGY0bvrritUfSU12xGH2lGFEl3ASaj3FIEmvcWWvK64XLrrRpo6hVZ40l7TyyPoIoYCu3eki8jQW7aU6ABmbR9Fdcw4l2s9Ak69y/6hcoySe+CV6S6mEW87tRYwo1J+l2YIgbjsoYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UGs66Fm32JtkgGVeJd/ROGiK9BMtxJ9oneD85H7sMh4=;
 b=HzOYI5ZXITZ1hyx5H//mzuuuwx7QSdUpasRddx5r77iWwJcKwPLt3YFhBRUkedt2WqbE9zgh5C/7/bzgCg8JWLlXnpvST2apij8x0uJK4sOgHTogs5lkYT4D6tIELKhGH05o1yt3YdIBO5puyPgF2qCZsXA1SYHWs46zsU0M4gIcCObjN+AugjyhLhfpM3HFJxk+vnbhZDYu0Bds5tGkmCymNvDurFRPOPk+9bSdwR4qmBY50fFX57Elk2m67EtOgM5a45LIF4WjCj0vh7h6MXpoRxTn+caT2vMC0jaOVoG6cOkQwjCPP36BHEm2FVRHYqDLRqNGFvuMH/NVHLnuCg==
Received: from BL1PR13CA0105.namprd13.prod.outlook.com (2603:10b6:208:2b9::20)
 by MW4PR12MB6923.namprd12.prod.outlook.com (2603:10b6:303:208::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.18; Fri, 13 Dec
 2024 16:57:26 +0000
Received: from BN1PEPF00004685.namprd03.prod.outlook.com
 (2603:10b6:208:2b9:cafe::55) by BL1PR13CA0105.outlook.office365.com
 (2603:10b6:208:2b9::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8272.5 via Frontend Transport; Fri,
 13 Dec 2024 16:57:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN1PEPF00004685.mail.protection.outlook.com (10.167.243.86) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8251.15 via Frontend Transport; Fri, 13 Dec 2024 16:57:25 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 13 Dec
 2024 08:57:12 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 13 Dec
 2024 08:57:11 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Fri, 13 Dec 2024 08:57:11 -0800
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
Subject: Re: [PATCH 5.4 000/316] 5.4.287-rc2 review
In-Reply-To: <20241213145847.112340475@linuxfoundation.org>
References: <20241213145847.112340475@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <aab56c3a-0830-40bd-968c-d442cbd041fb@rnnvmail201.nvidia.com>
Date: Fri, 13 Dec 2024 08:57:11 -0800
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00004685:EE_|MW4PR12MB6923:EE_
X-MS-Office365-Filtering-Correlation-Id: ba7bb9b0-7e4e-4fb8-1a7c-08dd1b9738a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|7416014|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WHJQekgxR2t6ZnYwdUJzbUdVUE9mRThMVTUwQ2VmQVFXSmdyVlkwSVBYb3RN?=
 =?utf-8?B?SDA5cTI5VnovOFV5T1UxNGRxTFhsZ09JQ0N1M29CSXU5RHFYNjc4K3ZyRkY2?=
 =?utf-8?B?ekNrZkdHUm51dlYzSDk0Mzk2WVRNMG1ZTUcvNERKMW5PUXlQbjA3dWgvWnpz?=
 =?utf-8?B?NnZDYVltN0g2SUU2bVJmajFMTHF1ZmdnZ0NOYzNYU3YzdFRveXJ0c1JpakVl?=
 =?utf-8?B?MnB6UTRqY0dOalJReS9ud1lpMk9WcHQ4WGs3MnFPTVI4dXMrSDMxcFBxS1d1?=
 =?utf-8?B?aXNGaVlLTTNSWVR0SXlwcUs2K2VyS01kMHBBWjVNTXhtTjZEUFJTekM5d1h3?=
 =?utf-8?B?QUpvM2RUVVNDcGUyMmJOYTcvU2Z2ODlmL1NFUUF6YlhtUjJOSktXbGZlN1d1?=
 =?utf-8?B?YkQ1QmRDaTlHc1VLTVUxSzZuSnpML3Y2ZytQbFZ4cXc0dVdpSTFQdXRZMWo3?=
 =?utf-8?B?YWYwMnlLVFBDV3NhcXoyQ1IrT1FPSitRS1BYNWJ4OHpyeEtjY2poRFY2MWQ4?=
 =?utf-8?B?NHFZOGNNSVBZMTVnVVdmZWlodG80TVBjODlmMGh5YnB6cjdia1VtU1RRTUNM?=
 =?utf-8?B?NlltT0NvUkF4L0I3QVBFTXcyTFo1U1hvZnZWdjFMSWdFRkl1Y1FINXk3dDFH?=
 =?utf-8?B?RmJRaC9ocnQ2N1AwVisyV3ZQUE1zSlU4K2ViQU9nb1UyOUIvY2o0eWVVcVps?=
 =?utf-8?B?UkcwTzd6TWRDcDBOMXh5L3BPdmE1ayt4bFNsejdFVTB1dlNlRGZQUmZIRnpF?=
 =?utf-8?B?L3M0RmJzS2p2TnRjbkJZTThSYk1uUUtSZlBNeFFldGtyYkpPakY2U2FGamQ1?=
 =?utf-8?B?MEpZYlV3Ymp0WGl4bkgxcFVBeE45N21aNGhLOVpHbGgyU1hDVnRPQ2d6OXFN?=
 =?utf-8?B?NXhLMTNuTzYwUysyODFlb0dXbFczY2g1c25EWTFFK1ZaR3Q0VHNYckNTTVVD?=
 =?utf-8?B?TjdBQVVRcW1DeDcya3FKZndkYmR3blU4RUlkSUducW5wZngxTDAzZG0zbzdx?=
 =?utf-8?B?czNTcnpFSVJ3NTRCakVMU2I2bHBqaHlSbTU0Uk03S2NFdkJGRmNkd3VLK0Y3?=
 =?utf-8?B?ZzEvb3NXVll6MFN1K0w5NTF5MS9jQ1VjTTVRUWM3dER2NFE3ZlVydndrSUhO?=
 =?utf-8?B?NXlhbzR3TDZqeGlaVjltaHF5Y2d2bHZjcThiL3dkRWE3SEF0cGJxb21yVXA3?=
 =?utf-8?B?UXYzT1duVzFnQW8zelNSSXF0U0xxUXhSaEFVU0RLQWl4dVhsWUovcjZyUnR3?=
 =?utf-8?B?UFdocGN5ZVVOcWNxcEtxTUM3bmlyNjRBczdYTEthZFJRWkN5Y3kyMU9xMnJw?=
 =?utf-8?B?cVNWTG94V3R3NXMzQXRGWWlkeFJhZFF0bkdMS3ZZL1dSV2RDOEZsVDYyKzZu?=
 =?utf-8?B?aExtZi9hRTBVbDI4Ymk0Mm9MKzFGOHdwNlpmVnloVHlrbUxaRU9tbzdXWWZ3?=
 =?utf-8?B?RHZEeDd4OVhyM2NWc1lDbCtMMjlzdm5hMU5aVEh6L1hNaklPY284c3NMVnBx?=
 =?utf-8?B?WU5BWWRtNjh3QzQ5Mk5uQU1sUTRLT2EzKzBDVUU3a1dIM0w1WUlDZDVDb1pp?=
 =?utf-8?B?ajBCYkx5UlNLc201bzE2N2JlenBWdlR3dFoxcmlJaUNGZEQvVUpmZFZ2dVRD?=
 =?utf-8?B?SktFVkZXNWR2aTVZZ201REk0TDNEL1N3bFVJZ0VuN1JBTFQ5OE5kaHo1Um9U?=
 =?utf-8?B?cWhWRVd0c0NUYVNOeDhxVm5FcGhmTUVVOVVRSzhxQ3ZZMDJqUWdkNUI4bTRF?=
 =?utf-8?B?MkhONXFKbWxDYnBlSStDTHRHdUJ5K08rNVpHL3pkYzZDMkJjZ2NuYnhYU2hO?=
 =?utf-8?B?UjQzeG1SVjdqNWNGOUJib0cyaDU5OHc0YVk4RFVLek9xZmNrQko0cE9zSDQr?=
 =?utf-8?B?ckNteFBzWFVZNjFwbWt3dkRvVkZpNmppaXplWFdFeHZJcEZRSHppRUZVVWdW?=
 =?utf-8?Q?Q/j1B6Ife7ZUKnoNwrYqKmNcHofXrKWC?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(376014)(7416014)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2024 16:57:25.8934
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ba7bb9b0-7e4e-4fb8-1a7c-08dd1b9738a7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004685.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6923

On Fri, 13 Dec 2024 16:03:38 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.287 release.
> There are 316 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 Dec 2024 14:57:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.287-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    10 builds:	10 pass, 0 fail
    24 boots:	24 pass, 0 fail
    54 tests:	54 pass, 0 fail

Linux version:	5.4.287-rc2-gce5516b3ce83
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
