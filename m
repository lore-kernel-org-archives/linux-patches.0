Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2050.outbound.protection.outlook.com [40.107.93.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D14F14A09E
	for <patches@lists.linux.dev>; Fri, 31 Jan 2025 05:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738301944; cv=fail; b=bPohM4Pi4ErCYd9KeJZO2meI/mRalUmpQZ+pfyydq/6ELlu9aqBddgr6nDl4HWh6tZjWO8YxwTrs2Qpz0/TYxlhtD22/9RSvifhAKXUmQF+fDlYbZKGjDaweWVRknFApy9jpl2qQasdNPZlYwXWyKcxKrkJ7Wsa6mlylpKOtnCg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738301944; c=relaxed/simple;
	bh=4ypKbCOqbXDvHs/6I9izVnmyglsHj81NV4Mr89/3cK8=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=qBRWmOBm3MjoQXzEu3pJFngC1t8BloHyR2imgRbtC5Q+dSzzKsT111OV6VSBjEPintIqJjYeORMkMlgLTfweQfYE4mCDUQlwf1X82K9O41a+Djam4xGqXeGpweFBXYtctzEKJPyJzcPr6RcMJI/Y9OE7y5mfnK5VLVlL/Jhx2jY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=FhLHHE46; arc=fail smtp.client-ip=40.107.93.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="FhLHHE46"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RsWbuSVUv4aGYcYRRNh/oFZjp22Mx19cSmfZ4A8yi6jeWk5plASD98t/pPObe4L/6wc3jVJdDQ2fd2b3zjaecuC5Io+MpDnqm2kWB+V4aU/5BVCEilcfNJrdVcJHUuEXi5A1mGnMeXqWlGT4RgGbq9l/SouWhMTq0gG93EgA3QP/17SFGjJr1cLpBev51VCya91GsGOf2OC6tb9DabQEjvEkNlms1LFEseanNTXyVo16PbzFORfVPidcrnD5713vvcatE0xsfhBraez8h6voH/Xe+GQe/M5xanr4qOMTxrjxA5A1L6WZ+QGSGi/iYHlzBNaypuqjJZKLaBHNb60hVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ygwBlDtYqUVgoAVjz3MIas14S6OJiVrM1eHU0z77WgI=;
 b=Pv9sYA2VFEcr5eVVbWYk7HHVxrxpZjvtaeFeu9332+x3Hl37iwKnOVjYs0bbssy6aY1ftwC7b2UG7+DpWKQDSgIn4C3iBoGD0pwswdb1ZnfHNZ48e0eA8gg18dyk0y36VGZn9sIA/f1ILyX0e+P/u2Thc7W/KaG3xGP6Hj7+ILLYH3o+Vunribbmu0m0zOKk2FQAentGJiFJiRYlYeAxUE+LwL9Vhe0t7RmdRt6klntT5rtlvv2GxAb5kJD8XdIVPV/SEBr3eZey2WdangyrtXOTM5Ii1SzFTsKbhgwML87MsVkhmxtjiIchTRubJMxXJHfOttStmP8D8yaeEiSvVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ygwBlDtYqUVgoAVjz3MIas14S6OJiVrM1eHU0z77WgI=;
 b=FhLHHE46JFQ+0dtB3NSvSlxXcnBeFgvYs/qw26nTX06tTjIitPiSwA5Ov5l1lF2VYVj6unEn/Xb3uSYQ1OsvILawml/XXswhXBzVSG6/gfGlMuU8ZDFbI+3RnFYt/vYD52WjFUtojNa9a4e6pzQUbu/8CdgVQHmokknO19Fgzs/rjoMcccah5nHRH06cqOKHgbZljSyR0gcnKXDkAPUSr9w27VdxuhsqwMnw7DHgs43puqmqU2t/QJ0FlY8aEcWlvfqObuVP5ZEW824CNf8AAfxruLCbTUrpgMxiANDu5LPHwCyIx6k8zOuGLJPeL6a4nS1uTngK+J2Wm2DMyhF7Mg==
Received: from SA1P222CA0166.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:3c3::10)
 by LV3PR12MB9168.namprd12.prod.outlook.com (2603:10b6:408:19a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.20; Fri, 31 Jan
 2025 05:38:58 +0000
Received: from SN1PEPF000397AF.namprd05.prod.outlook.com
 (2603:10b6:806:3c3:cafe::ad) by SA1P222CA0166.outlook.office365.com
 (2603:10b6:806:3c3::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8398.20 via Frontend Transport; Fri,
 31 Jan 2025 05:38:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SN1PEPF000397AF.mail.protection.outlook.com (10.167.248.53) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8398.14 via Frontend Transport; Fri, 31 Jan 2025 05:38:58 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 30 Jan
 2025 21:38:42 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Thu, 30 Jan
 2025 21:38:41 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Thu, 30 Jan 2025 21:38:41 -0800
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
Subject: Re: [PATCH 5.10 000/133] 5.10.234-rc1 review
In-Reply-To: <20250130140142.491490528@linuxfoundation.org>
References: <20250130140142.491490528@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <6bca7dd2-cae6-4a6e-bfd9-1c85f50ef9f3@rnnvmail202.nvidia.com>
Date: Thu, 30 Jan 2025 21:38:41 -0800
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000397AF:EE_|LV3PR12MB9168:EE_
X-MS-Office365-Filtering-Correlation-Id: 249f3e4a-9a5f-46d4-c29e-08dd41b98f39
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014|7416014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bmFnRHA0NVJlZGV5dFJnNWdHU2U4NFZaTHRkamRXc21EWERBZTBlcFBTNkNL?=
 =?utf-8?B?WXBtWkY0RXcvbGZ4MG12OG1CODJZTVJoTnlKZ0xpODFvZy9qTzFhbVRVVDAv?=
 =?utf-8?B?K0ZpUTVGOGMyNzdjTUhZcjV2UWFTRkNjbWp1WlIwMDhjdlk5NmVQOG9BNFRC?=
 =?utf-8?B?M0RKUGhiaFFrOUdnZk5kRE1mT3lmU3owQVI4SWZLK2lpUllUa0lXemw5ZzlV?=
 =?utf-8?B?UWtCR1ZjM0xjNklRc2kvdi8xSW1uRTBYcEVsb0d6ZlFnOFd2VDU4NzlMR1N5?=
 =?utf-8?B?d0kyTmU3TE55WHVJL3ZwUkw1VGFiWHp2dEpnSWo3Um5iWTduVmVSMytxWXQ2?=
 =?utf-8?B?US9CZStqVTRpdjlWRHhSanpFeXRjcjVhVnJzSkkzeHplck9IQTFENGdFazlJ?=
 =?utf-8?B?cktwaXl3R1MrVkw4NWJPbllRYnNNbnorMmJ4YWlxWTk3OFY3WlRqY0lFNXRk?=
 =?utf-8?B?Y0V2TFhuZ3VUdndxclU1UWRpQkc4THpUQ2pvS2IxVU1MMnpmQ3NCRVdKTk1P?=
 =?utf-8?B?b1B0dFdFa2lBR1NZRnlpcWI0bUl5NXBzVnoydHlJdWM3Q2pndG1Cd29vdFlH?=
 =?utf-8?B?Vk83RGJnYjlKZzNHdmdkQjNjWEJZS2dhalAweExNdVhLWWdmYXJZamNKR3pH?=
 =?utf-8?B?bk1HT1ViTVB2RFZjT1BLeXQwb0htNWk4RHJmcDR2TWlYOHgxZ3RoUytEWGR3?=
 =?utf-8?B?WWc3Y1BFRk1tMzA1K2F0anc3bnJ0aXVBYXZoMkJzRjJhL29GU2FGYjg0Q0tH?=
 =?utf-8?B?aGt0bG5Hc2FwUVM4Y0UyajJRbERkdGRlclhSTFFuVVJBYThKeGFPYVFodEZV?=
 =?utf-8?B?OW1ic1dWRHdkSnVZTHpRUUVvOXQ4bGVyWFBvbklpY3RaU0ZSL0VCSFA0VGRZ?=
 =?utf-8?B?ZjBvY1NTK1hHdHUwczA1d1BLRDN4OVhEbFZQdVRON3UxUmRrcHB0TDJsNXps?=
 =?utf-8?B?M1NyWUZsWWtHQkVYbFJFSy9RQ24vYTJBSmtwWksrRUtzSHlXTUlPWDB6b2NV?=
 =?utf-8?B?TDdIVkRNUFphTlRPekovOSsxSUlQbTdaOUI4NThpbG1aemVBcFhMYUZHQWNo?=
 =?utf-8?B?UitEQ0RzR3hPSHFhZVlIalhQcXVmbml1OHBOQmhORklFU0FEbFp2QzdJQnJo?=
 =?utf-8?B?VUk3K1JVRWxoV0V4T3oxNHJZMjJLSkJFV0dJU3NoTzcxMzR0Qk1RZ0pET1hm?=
 =?utf-8?B?MDA0anN5TGkveVpEd0JoSFZsN21sRDc3ZUZUMDQ5UHR2Qld2Zy8wdFc1KzNM?=
 =?utf-8?B?ZEVydm4zR28zTU0rWGwwdk1rQytjU0RuM3B2cEFidXY2WWplYndZNzVob2V4?=
 =?utf-8?B?WDQ5OTA4NlpDMklqQW1mOUZ1U0FMQzcxemlLaWhUck93SEpzQVg1YmFOOEUx?=
 =?utf-8?B?elZpdzJFS2dzOUlnWVM5cm1hbUpIMmplcHVuQU1UK1pqZ3BmWm1jYmdCWkFF?=
 =?utf-8?B?YkNDZlNKV0ExR3pWSE5PNG1RTllOSTQ2SHNLcjhRREw2UU9IUkFMOFFjTVUz?=
 =?utf-8?B?MnJrWjJDZjY2bDdYTFNSSG1iQWdITlNPdTMzcGkxekw1REVZRW9pYnF6akZx?=
 =?utf-8?B?OTloZ1lORmFSN0pOL1pwSEw5a2FxbnlpbGdyYm54NC9xK1J5K0pxREt3UUsy?=
 =?utf-8?B?d0NqUEJtZGZ5eHNyWDg3eXIxaGlDNE5Wblprd09neVN3UjdmWVh1aDBUc0Zo?=
 =?utf-8?B?ZlEvc3BTVTA3QlJYU3hvc0JEWHhBb3U2L3ZsT0txbDJVSjNEb0s3YnZwZlZx?=
 =?utf-8?B?bGE4MEFtQjVLZE9MSWw5dHk1QXlIa2xiOE9KQUhPODE4NE9GR1hBaW9JMXFt?=
 =?utf-8?B?S3RVOWQ0WjA1dTZ1bHdMTUU1NVduekEzREgydzJDenVWQ1dPT2hyVUhSc3gv?=
 =?utf-8?B?dUp5a3l4ZFkzaVBkRHdON3FpNnFKZnRrQjkwQWZMUS9aaVlYbkliOG94YVYx?=
 =?utf-8?B?aHpwV2NQYlgyRktCTnZ5L1RTQ05jUHNyMnlqbUxRTGx1enRqWHI1cmE1K0xK?=
 =?utf-8?Q?EIXmH4F3KBPf6vW+0ZTQhLKSw9LOKs=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014)(7416014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2025 05:38:58.2910
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 249f3e4a-9a5f-46d4-c29e-08dd41b98f39
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000397AF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9168

On Thu, 30 Jan 2025 14:59:49 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.234 release.
> There are 133 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 01 Feb 2025 14:01:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.234-rc1.gz
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

Linux version:	5.10.234-rc1-gd215826da15b
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
