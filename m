Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2081.outbound.protection.outlook.com [40.107.92.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BCFA2DCF5B
	for <patches@lists.linux.dev>; Wed,  9 Jul 2025 13:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752068572; cv=fail; b=LawOtY7HvMB9N/CuuPc9QoWL+Hlye02r+hf/vbmLQYFSHsm9QkvPWW9gbqyRRABioghqo+cWLOGfQC2k2HHH42tsWOhgdguepVVA/wNXpADiZJPphxk9Hv4kFlbfXrmYLX2dJQHERhRQpcZeyTqDFe9B+23dYi5MQCd8ZimOrxg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752068572; c=relaxed/simple;
	bh=H740oRupNd3U+CSxrijw5JtZ6ZJAESAk3lgAF6Dm7Tc=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=MYNGc7rnkELVLqQbYhb9K6y+e6zOHQ2siWrJQoSPzs4RqQi/e9jrIMWG1kaZAnq/oyAAkOdujq5/CjAhaARSvEtgqxmjsE46hqd1Bn2q/aYpbSLjZ5zGH9pNugVU3WRR4tXl+h2b7wtXakGR+4af1ToGSNp9On/XSMv5Z0mAbpQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=FfsdHlBT; arc=fail smtp.client-ip=40.107.92.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="FfsdHlBT"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Zpznxa8bW5rzAJ7Z+/Gj6GvvrRrx0oK0ptnEmunPX1d/W2eDP7dt3hucbMv6lJI6IWhdES3x6PMrDu7ODVxjlyUPPROjfHyEcsIPdUgEJO1hRf/ElP/KfGEnonvDl5HUUnmhZcGk92HULldr9HjtcG0ajGD+Q5r+F7CbtOTF1BeuAA1P+2OQEQusrSH7JQLmrHZEIgfZUAgMyWNEr0ZDwZ+xzqAU40SxEFrRSkNUE8jpOCPA1BzZUy/zmiI7uQzwpAH2ekKVekORmmqJLebjuJuslMAV0GfjUMAekDnNQ14b0bgcq1dqIi05yfue0U2eEsFYZnYf/70VnzZxgP5lnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r8YNdB63+t0XExe81Y4KHSQEZFlQNAxWmpcC+vpo93E=;
 b=j4DLJBZgyOWos1jwMOoC5JaAz5NaOIyReK7nOsD/W/l00wsII8AGPWFb4a6e/DFG5BStrKERa/7HQkONpkNI7YItMbHh+SYG7OtNVqDnhM+ndT5uXJQJLwWfO3ojUNQDCIELVaAPjKK/L4Q9EOUDw7bw7nlySygZioPBzUesl6gDOmgikURalnHOGcafRuK/E21ZeoqzgbLjN3pmzHJ8vF/Ti1qkec1K5jwv7CsnVeY3w8P8Y7WwwRoznxRAf57ooH50V5cHvgdGkcc6l89D34OoKlYw9z2AeFGlHq6C5Qn6xcAgPJi84u+TP0LjO5l3YK7Drcc9OdGgxAXOApzt0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r8YNdB63+t0XExe81Y4KHSQEZFlQNAxWmpcC+vpo93E=;
 b=FfsdHlBTAIGwS1qMlHKQfqKRLEvlLco0vHVVl1hcQyKPHf6twcc5VgQ0zd4fMrfgeEmTo2+JaYIRyICmzpQvJ0byhs13mFqDcC2wSHa+lw0k4Db0YPRqbMSdx91ISbAsB8Pkn2b0Yt2f4Oykj4SuX49qoB4kkGTHsQmr42ESCDiMthULqbwusjKNMndslbMFabSI4xdF6wSLGCiBuuiKjK4f76bmUkeVpEbq+VNwLKdYQVtMVTxKDMcHvp8j1jfVISC+HhsE54HTnNVcQlR25BQb2EEdW4WP8PlIHFzqXQVZn/bTWvp1Hwfu2XtY9eNrwJDE+fdCd/oky9yQCSVQLQ==
Received: from CH0PR03CA0250.namprd03.prod.outlook.com (2603:10b6:610:e5::15)
 by SA1PR12MB7174.namprd12.prod.outlook.com (2603:10b6:806:2b1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.28; Wed, 9 Jul
 2025 13:42:45 +0000
Received: from CH3PEPF0000000B.namprd04.prod.outlook.com
 (2603:10b6:610:e5:cafe::44) by CH0PR03CA0250.outlook.office365.com
 (2603:10b6:610:e5::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8922.21 via Frontend Transport; Wed,
 9 Jul 2025 13:42:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CH3PEPF0000000B.mail.protection.outlook.com (10.167.244.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8901.20 via Frontend Transport; Wed, 9 Jul 2025 13:42:45 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 9 Jul 2025
 06:42:37 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 9 Jul 2025 06:42:37 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 9 Jul 2025 06:42:37 -0700
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
Subject: Re: [PATCH 6.15 000/178] 6.15.6-rc1 review
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <356870bb-a500-44a3-a0c4-6991544ce04a@drhqmail201.nvidia.com>
Date: Wed, 9 Jul 2025 06:42:37 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PEPF0000000B:EE_|SA1PR12MB7174:EE_
X-MS-Office365-Filtering-Correlation-Id: c4f65a18-a8ff-4238-b41a-08ddbeee7c64
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|7416014|376014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ckR3cUNzSjRtTjh5Um9GeUJWRFFWdnJJUmNES0dLZXFYZmd1aHVGU2p1cXFa?=
 =?utf-8?B?OUhRZHVlbHJZZGlaTkN0UXdqRndWY2tyK2wrSW85Wklxb29FZlV1S2tWK2pX?=
 =?utf-8?B?a3RocXNUQ2w0Q1VxRzdsbWdJZVptS0VhU3Z6NFlGQ1g4UTVpVG1rZWQrSXVF?=
 =?utf-8?B?V2JNcHM0cXJpNjlWQis4YlVFZERuTFpqOFJaQzV4bjlBTmRUYTltYk1sQ2FM?=
 =?utf-8?B?ZjRtZTdEVXdjTmt4QUtXZnkxQ3Z0RzUra1RPb2lSYzBMNm0wSURhQ28zMXJF?=
 =?utf-8?B?Q0tQdzBGWEdveGxJYnNtVGlrK0VQREdEcERTRjB3VlVQcTZBQjI2UWJVcGZn?=
 =?utf-8?B?d3FVclVjQnl2UGRObmNTZndvZjVJOE1zM0cxWElyT0JUb0o3b0IxaGxaVThM?=
 =?utf-8?B?NWJNTFMzVFg3Z25IYVVuMHRQUDBISnZRdTlYMWRJb0xxbkd3UEk4MVZFcnl4?=
 =?utf-8?B?aDAwRk5XWEpMZm1kejZwdERQQkFBL1BoYVVCVVV1S240Y0JqQnNoTmdIY0xs?=
 =?utf-8?B?SVVMSUVuWEJxS25SSjh6Rm5xMTVuRk1HeW1UUmMvR2VCNlpHbnAzWkt4NjMx?=
 =?utf-8?B?SUJVelFPcnZCOTByQ08xeXE0bjcyOE9wdjk5WmtxTk5tOC9pY0FWT2ZzNUNs?=
 =?utf-8?B?ck4raFdDd0dWMi9FdWxMaHAxWGhZZHc3UlVMelZQS1ovSk5WTzNLVW44UUUz?=
 =?utf-8?B?NHNBWFlBcUVnWWI4ekdEOUtOWXNSMUkrRnd2UUwvRGx1T1B3OGloNGs2ajZh?=
 =?utf-8?B?RndlRVFDNnhHdHdHdVZGam1kRjdwc3ZEQVlJdnRJMHJKZC95N3RBME96SitY?=
 =?utf-8?B?S0pobkQ4NElqaGUvemYxYnlyLzB5ZUwvR3dTVWJjdHFiUXB1VVhrZmRLNE5v?=
 =?utf-8?B?ZE5qWm8vV3d0MXlaemVpb0orTXRxKzg3QnZBb2RtbVkvVHkwZVc2YU4wc2ow?=
 =?utf-8?B?MlhaVXpqRWJqVGtMdC9OVi9xb2o1QTB3OThvYndPZjVROExWdXlrUVBhZXph?=
 =?utf-8?B?UGMxS0psNjd1RGtaZUxtN2t6ZzgrSEpjTVNzM0tvcDY3bFNKZHR4MzlxcGlT?=
 =?utf-8?B?bVJHN0J4cld2clVQZlhXSW5NZVRjUmVtcUZGT1U4YW0wYnAxYW1sNzFxN1FC?=
 =?utf-8?B?bmxpY2h1bjEvQXplNVpleVFnNUN4NmR3YUlrZjIxUUp0akt3R1ROQi85djF1?=
 =?utf-8?B?ckRHaG9heU5tWjVGaDNRRmgwbVlqclBydHpFaHkzU0YxdHFQcUdqQWgxRnFB?=
 =?utf-8?B?QlpiZnNLdTZyVDlpdHR4OSswRFNWWlh3UGx3cGVXaDJvL1djY01xQ2RrbkY4?=
 =?utf-8?B?eCtDWW9WK2VMZDQvanYyUEpRSElVK2ZoTEEycFhkdXgxenhDQTdVWW5wT2JP?=
 =?utf-8?B?ZFp6clhMQ0pyTjNRTHpHUzh5NW1Qbjd0Uk5DZDlRWGV1WGh6K3NKZ1VZR1or?=
 =?utf-8?B?WnduZzRnOGpOZ2xydnRtL3VEc2hlbDhwSmF0UVo2TEpNc2xPS1U1am1YUjls?=
 =?utf-8?B?Q1NkbmJ0Uld1K3RBZnRhK2J6emU3cXhEL0UzVVdUaXBBMDk1Zm1HZVVtMDB6?=
 =?utf-8?B?dU9zenQvN1lqcnhjbStFUGYyUkplQS9XZHovSm1xQ1lxRS9CWUxCYnk2S2la?=
 =?utf-8?B?eFRMNS9yNDh0OHB6Y1FmRXcxWkVWdTc0MUZQYUFrbGxkN01YMFdLQjdSK3pt?=
 =?utf-8?B?U1ZPeEZvaStTU1A3U0lZM0JGbXJpNHRQK3NpajdtdldsR2NseWkrTWE4YXN1?=
 =?utf-8?B?UWMxRjlIQ29PY2VhNC9oT2pGMldNeWNSUjlZWGwybzVwd24rL2ZTcnRrWWtV?=
 =?utf-8?B?b0FOS1JYVWsxQ05mMlZ2ZmVzZ24vQ0NVTGVwaUJwQVU5QXEyMTBwcGQrdC91?=
 =?utf-8?B?VnRNaWpKOTFYWENLbzNIajFuUlplL0FLMURkMXVQaUk1R01mRXh0dzdJaVl2?=
 =?utf-8?B?Y0xaQVFUdkFhTElpZnRvaU9IZDBqVmFRMWVCd3UwOWNENmRKa1BwOE5tTGlC?=
 =?utf-8?B?RS82TXo0Z2hRcWs3VW54czhLUDJBVmg0elh2L0pFbUZ5L1Q4VDlpdVAzdHlQ?=
 =?utf-8?B?OXN0dGl0Vm8rVzUyc3RLdU56MVpMdmtnVFVKUT09?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(7416014)(376014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 13:42:45.3530
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c4f65a18-a8ff-4238-b41a-08ddbeee7c64
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF0000000B.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7174

On Tue, 08 Jul 2025 18:20:37 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.15.6 release.
> There are 178 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Jul 2025 16:22:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.6-rc1.gz
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

Linux version:	6.15.6-rc1-gb283c37b8f14
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
