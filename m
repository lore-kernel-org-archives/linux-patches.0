Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2053.outbound.protection.outlook.com [40.107.92.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8401209F35
	for <patches@lists.linux.dev>; Fri, 21 Feb 2025 11:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740138826; cv=fail; b=KWcqYpEktnMr2d7Q1mezlutZ0iSoxCqo50Kv16tsRH3hF8c4TUgAgXb9tBCu+RWkiDc2L3YG52Y4VvVXcWx4KIeY8DsVtT6nhJX3e3LT51pTuc4zkwj0w/ntXbGYlujO55h8nzK65OzG/5Pg2XCuPr1xxgmrjNiy8sm8Ib2vw0I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740138826; c=relaxed/simple;
	bh=brzyZtbDMkbcDjbm7M4tMd4G+Wiv1yYYp3fLRe6ArXc=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=YhymxsCPE5UHddgVQFptTszw8INvMeJXus2UhsKCm5KZAYdO9zwesOKTe4YCobmYIPedaMI6aTIRQ9bqQKw751ZpzeqvthzPu99gMOLVYQp5iF5BsoK7Ol3/9fwHHiMH4brVIhSMq+VhpvEscC/fnkk+xn3tzX7VtmxKeKLx8nU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=VFbQslti; arc=fail smtp.client-ip=40.107.92.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="VFbQslti"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MSAAB3fUVbgezXjr0CQ/ya951OySHVOJ5vSMkwSkcdduVEsFONEstI7ZF/Aaa56gWzJh9XnfV2Cm28frZ03sm3nvrM1QOMQqd8W5B2ojMS2v+XavruaBPvWYD+gs61jylNAIttoVodVNaK46nBM2VquA4KGDBR8u98VEklxjyE20SQu8KWaEcPPzOBdX5CjAfQN+E0cmfbsEuwGhKmDMZkS2g9sMw0pKjzUU+0aR07b99VcCSjmhkokl9VYEun48Q4ZCa+qKgnaj0Vo7tgLLNXsRyDAOexyUGThU2tMPABXV56WwrArF9E6nhplqzVPeJM6L4Q3L9kQtav13/5PrTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i13mMxVLXMZcqEsCmsqaCYwLlMD/3C8P4Kq8D2tYUh8=;
 b=H4ZrDxSPAVXHtQAtkZd3wXa/ZAXfGUOkjylF6Aum4eH0G2fqT0lvdUrwOYZZd7cgFDK3sU/9iyCvf1GGgGtPkXDQpiZVDEkQMLqAISOdHQ52ymlQcO3JFmjbzfruzSUmpivEwREA5gjnzXURgz3Y/K6W6a4cMiT8DkhI4IEo0sHBpSEhO+s2tIyLYW5eYFDOHflP10baexApOHFHMIEiQIpxpsrY4nnWFPnuYUmO81A/abJxUGNlburzqfFQbIXuvtED3Y12QToHFYlTxWVKhRodXnrnilTN3IGqh++cvcV64wtsvw46Ut0Vj0WxSptGHu+uO6QJ6Y2nfCAD2oBxaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i13mMxVLXMZcqEsCmsqaCYwLlMD/3C8P4Kq8D2tYUh8=;
 b=VFbQsltithUKfpG8J/yUKsQoOciNxb29lm8SAdOHBmWOTzkN7sPv3jPYE82YkYUvP4FvXinauZkkSruzLr4Ck9lWLF5P0kFpTzCFvCZRN+dsg63suN+GVNu2D65t3cKaUnk2VLDeu1cXG+eV4ze05qq5cDbeVgKbnbj8k0L0o6RcW5z+PjotHVcev/a6X+f5M+JbnTRnyy5QD/vnSzb+BufBLF+0RozPxHVwR9/Hq4F8NkrAt3WPd4fRL0yZ8q2aKmX5P5csl1KCKuPpvERj9eU+3T0sIFgD2lUXF7ZAeBlzMBb+wWmM087qXDszz5E6K7uAkquvWKEWhDlCpGGXBw==
Received: from PH7P220CA0038.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:32b::21)
 by MN0PR12MB5811.namprd12.prod.outlook.com (2603:10b6:208:377::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.15; Fri, 21 Feb
 2025 11:53:40 +0000
Received: from SN1PEPF000252A3.namprd05.prod.outlook.com
 (2603:10b6:510:32b:cafe::f4) by PH7P220CA0038.outlook.office365.com
 (2603:10b6:510:32b::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8466.16 via Frontend Transport; Fri,
 21 Feb 2025 11:53:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SN1PEPF000252A3.mail.protection.outlook.com (10.167.242.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8466.11 via Frontend Transport; Fri, 21 Feb 2025 11:53:40 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 21 Feb
 2025 03:53:29 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Fri, 21 Feb
 2025 03:53:28 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Fri, 21 Feb 2025 03:53:28 -0800
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
Subject: Re: [PATCH 6.13 000/258] 6.13.4-rc2 review
In-Reply-To: <20250220104500.178420129@linuxfoundation.org>
References: <20250220104500.178420129@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <5aa81596-b54d-4022-afba-b4417fc5d2e8@rnnvmail203.nvidia.com>
Date: Fri, 21 Feb 2025 03:53:28 -0800
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000252A3:EE_|MN0PR12MB5811:EE_
X-MS-Office365-Filtering-Correlation-Id: ea8978ef-2162-45b3-971c-08dd526e6210
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|82310400026|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TEZrN2dxeTFiN0RXYXRJbllIRHVCSVJCa09meXVVdVpXOGJyV1VvRVVYRkRm?=
 =?utf-8?B?bDdlMjZNemEyMlhrSUJVVTJmaHpYa0U0MmpGQXZvYk1IWW82U28rWnZidk5M?=
 =?utf-8?B?NGFEb0xTVmUzNXZIWk9aRzRZN0JkMGRYSWV4VVZoMXRiMTd1VS9FeUs3b3ZU?=
 =?utf-8?B?QU1Xd1dqdjF6TndiNitEUFJiUjlGZGtuMHVmZjJjdTlMQ21hVkZMVXdHQVFE?=
 =?utf-8?B?M212c0lvTU5XbnBCeWFwaFBDU1oyRWJSaWJnUTlJTDA4aWpDSzVmdU95bWZT?=
 =?utf-8?B?THIreDFDbS93eTRIWEI2dzhrck9ETnBTSUdzbGsxQ0o4V2hldURubncxaDdL?=
 =?utf-8?B?SEhhN1hyejRibmZvZENwNDQ0N21haGVxd0RSYUM5MG9kY0JGZStuM1dFZG1w?=
 =?utf-8?B?K1NuYkQ3VjVwRVJjTXJGRStLWCt2VXBCYlE5eDBXRDNzN05pZVdDdWgzY2pN?=
 =?utf-8?B?bnlmalNyd2JkQjJhdDNheE92TnJYU1NEQjNJaGVoL2l0UEVZcVp6U3g1bWRW?=
 =?utf-8?B?azY4QXJmTHJKWTJRNUowNHdPcHdiOTE2L0VXcGhhVXlTZ0dISzhOb1BGdFcv?=
 =?utf-8?B?T1FGUEYybjZrVXFTU3lvdEwxOE5WL25zR2JlTklpbi9qblRsRzBpZHdKSjNz?=
 =?utf-8?B?cHFqWDJiL3lLeE15dlZCdTByeW9uUitwNGV1NHZrQ3VzYmVBWUsxUjFwaVk3?=
 =?utf-8?B?ZFFib25TbFhyMUQ5Q0xMMk8yeU5kQmRJR0dPYlU0MUJZWHRRblpUVkh1UHdJ?=
 =?utf-8?B?dDNPdWlhWE5VNXp3NlFRQ3VoeTZyYm9Wb1FzOXFrcnZ1d2U5QUp1Q2ZhUkFo?=
 =?utf-8?B?WS92bVZmUUJ4T21GY2FoVkhhc1hFLzhkdndMOGpQSXZvR2pCSFhDRzJMbVNn?=
 =?utf-8?B?WmpxWktWVWxDaTdBd016UHdjVFNMbjJxZE1OUFk3SDI3KzdBd2lmdjhOYnZE?=
 =?utf-8?B?MzhFekFHZ0tFblVnSjNnLyswK2JkSkJYdHE1RkFxU3VoY1pYbHhPZENVVHp0?=
 =?utf-8?B?aThaUXlrSjRGcUVQQUhtMTVqTkNzbWxJR3M5RGhzcDRxZ1M4eVB1M240Vlh0?=
 =?utf-8?B?elZnTFRKbjVyYVhsTkZQNVhjNTB5SW5MZEVkSEc0ejljWFJrNEFLbHJJRzE0?=
 =?utf-8?B?aU9UTmJzTUtTOXRLT0MrTy9mOU9TTUNyY0VjL1dGN0Y1QndtbmtFcjMydW45?=
 =?utf-8?B?ODBla0tpanRiMlNlZFRDaGdyY0VYa3B2WTJRZ0d6YlhVYkpNOHIzQ2o0bDQy?=
 =?utf-8?B?RVdKdUFKM0szb2U3bklJNHBod1p5TGRWWG4waUZzOFB3UGtkOUdmcXBhMHB2?=
 =?utf-8?B?TUtkdWRJNWNXMFcyOWZtRWlwb1NNcUtCV0U2L3hpSmJybVBjZVZwSFVQVFlD?=
 =?utf-8?B?a1dhTG1rc1BOVmpLSlhlQStRTU5HUXl5NlUzTHVHQXA4VUMxWkhkai9JL1ZW?=
 =?utf-8?B?N3Badk9pTVUxY0dUSGFOK0hsWGVyUFI3YTZ5d1lmaG5SMjBCcXVGTldGamph?=
 =?utf-8?B?MXRTNFV6cmxZR2xOMGIzNXU5SnJINlg4U0V2dmRrUFNKeG5UOUMySzhwOFRn?=
 =?utf-8?B?RFIzZm8xK3V0bHNTUVRyZ2MzMDg4alBaOTQ5ZWNiQ0EzUzE4Z1ZFeGc3TGJI?=
 =?utf-8?B?Y0hLWiswMExZTGF1eHVOb1M0bmtVRDhzSFFpT3MzbS93R3RXK2ZsYXRRQ3ov?=
 =?utf-8?B?clB2RTArZlg1eFBsNUlCd1I1dFlQbzhXN1NYRWw3RDlKdW9qQjBzRDJOdGlh?=
 =?utf-8?B?dm5VVXprekdXclVNUTgyZmlTcnFqWkptUVdwdzZZRlBxS2dHZzhBTXN4OGxz?=
 =?utf-8?B?TjgyL1F1eiszTWFvZU16bjNkbFZacmVldmtzdXdXZXBEdmR5NHZTeDZBN2dp?=
 =?utf-8?B?eE5hNjN3d3ZHL2ZQaW9rYXo2WkxOM0tTalN0VDJiMTRzSzVqY2lYMDhaYWxm?=
 =?utf-8?B?MWhqVmY4Q0FmTk9iKzg1UVpMSHlNcjJTVVFUMm1TNE1kR1pXc3pLUWhId2d5?=
 =?utf-8?Q?icw6ahuvQI6ibH5Z1DNhz/3SYIBtus=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(82310400026)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2025 11:53:40.0206
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ea8978ef-2162-45b3-971c-08dd526e6210
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000252A3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5811

On Thu, 20 Feb 2025 11:58:18 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.4 release.
> There are 258 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 Feb 2025 10:44:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.4-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.13.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.13:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.13.4-rc2-g191ccd3d65d1
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
