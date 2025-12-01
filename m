Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012042.outbound.protection.outlook.com [52.101.43.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 057F2337BBD
	for <patches@lists.linux.dev>; Mon,  1 Dec 2025 18:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764613172; cv=fail; b=H3Z+2FNYOuwP3etTUL6noS8T5sdE6PVDeSIHl8ENLt7Zbuo0qR35TwGKwznTxMHrXG0zoRFGFPF0vwDwM0Mj7ZRbxGGYjyXmSKh+npKDMo01DurwyMqxpMK25bnBFeld/P8825rln9bz/m8Op5kHzGQwF0auk+RHGOKhsd7pakQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764613172; c=relaxed/simple;
	bh=MVthdhDw6jWD4mMockBXVlBs2r3IRiA18Hj08kpKnF8=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=jdhvBI8y8fjsnFFzpAIV1JsbK1WAYG5NWQo8tF/dr+WkQHwGDFNr3PGz5OHcxa7dISH4S6iP3QaHdoLsMN1t1TbLuQQVRvSD0nRxQn5cB8mKUxWyiPaXZXg7DZGYxRpA6coVIVPxoUIjKKE/Hg4fbsfHbGr2zjWUVNwxWy95yZ4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Jl1TZSA5; arc=fail smtp.client-ip=52.101.43.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Jl1TZSA5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QuMfkor+FpXtw9CUuhRjfL5N/XILYXGLysH8zs3Ycjc+S2cxp+NrDYQWxqqtASRepewQa2MEcQWFEvODem7BM96JubcpugCZ8dfvlsZv6HOibSoYXVex1l/Mv6vyfgx9BAvM9FauRZeVx6e3ZVyPEBe/wTxOgejukEy6BQpakRa/divXzeQu3As1KDlmVl7Vy80uN0ZMYS8fH7Eh0n3c6lGYf34OmEywPuL9P9IvIGpzhdNGA0PYpNkovIeLNHrJGLseX8sedne3BAHyKlWyO0sXNKzFjLNxkhciRWZNxVqUAg4aflX18S4ofzHJX/6I6Uw/xXc6DpZjHWDKWVAk/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YvrZnzHmVp/UAWtXiZFhrcB1t72er6UOsnGPAHbg8J0=;
 b=BAjIyA8nnkjAHhouv/ArnreE2kR2pNuvyAHz8ALga6yeSeAuHloLRg8JtvIKZVhkdF9JMlZozZ1ymbGi9GCgEfw+KudSM4d/OUpnB9tZO//J8AjA+X63tYvJyuRTwNUoopIguLLMS0nfb988yot4eOKlFemzWTHW8FqE6FtImRaYdnZ5drTp5wXis9C6LQvnr2yLIQlN/5/RBalHJMitOeCJWKbNIFAp7/20IgJ/oydu2XDqsq9rBY0A78bAhz4L8s+9RRQ2bFUMzgMHRhgpsBaeV6deYf8+OfECRyLrUofiP8vNqz/7ni/Ohkctp4V+syhF/F+vik14EqHgAmJyfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YvrZnzHmVp/UAWtXiZFhrcB1t72er6UOsnGPAHbg8J0=;
 b=Jl1TZSA5e5q9kcONYUopPUOKpyExk7EEp1tbZDHldNbg104X+43YJIE7ZgTtehn68oXYOjaAgmvfNZ1pVeJ3mmOBkChURNpRf3QYJYpA62JY1XoAXLEOKwOQ6hZOJvTlVDdIe87xxn4IXXZROupAFIolhAKknI5bC8A16mHH4vgrUMNM5A8DlsPh4nj69S2rPg5pQ+EaVyNgsEdmAp2S5xTzkb/sE4TtFPWVCQQlDYuCWC0gkHNtbgejiS9xBbvWrfjsX1rPmQXL98HtfbHo3TUyy51J64LD0PzXRTnaNfHqlYhYVEwYYC4evZ23epf52xjJS5kmwuPvMIFUYSaDgw==
Received: from DS7PR03CA0273.namprd03.prod.outlook.com (2603:10b6:5:3ad::8) by
 SJ2PR12MB9209.namprd12.prod.outlook.com (2603:10b6:a03:558::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Mon, 1 Dec
 2025 18:19:26 +0000
Received: from CY4PEPF0000EE3D.namprd03.prod.outlook.com
 (2603:10b6:5:3ad:cafe::d) by DS7PR03CA0273.outlook.office365.com
 (2603:10b6:5:3ad::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9366.17 via Frontend Transport; Mon,
 1 Dec 2025 18:19:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000EE3D.mail.protection.outlook.com (10.167.242.15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9388.8 via Frontend Transport; Mon, 1 Dec 2025 18:19:25 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 1 Dec
 2025 10:19:08 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 1 Dec
 2025 10:19:08 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Mon, 1 Dec 2025 10:19:08 -0800
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <rwarsow@gmx.de>,
	<conor@kernel.org>, <hargar@microsoft.com>, <broonie@kernel.org>,
	<achill@achill.org>, <sr@sladewatkins.com>, <linux-tegra@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH 6.17 000/176] 6.17.10-rc2 review
In-Reply-To: <20251127150348.216197881@linuxfoundation.org>
References: <20251127150348.216197881@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <df226a14-cc8e-40fa-adf9-9ffa1df0b29f@rnnvmail205.nvidia.com>
Date: Mon, 1 Dec 2025 10:19:08 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE3D:EE_|SJ2PR12MB9209:EE_
X-MS-Office365-Filtering-Correlation-Id: 96799b92-e2f3-434a-cc01-08de310628dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|36860700013|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cnZNUk1Od0kwRnJTcUNqNEpYcVg4MmlHaFhldUp6QkxkMnJwRVZFMDZiQVR0?=
 =?utf-8?B?djlhNDZqRFhPRW5RYkNqL1JmWTgzMDlrdW11MVhuZy9Ca3dwbW0vNHhTWDc4?=
 =?utf-8?B?WjNtNVZHV1pLck81S2tWUk9RTitLL0tFcEpxbGpIZFNvWkhrcXBKdlZMcXNT?=
 =?utf-8?B?VWJUQWxmSk9LK0dpOTI0cmlxVGlwT3FZcWF0KzdMTGYrWC9oRXhhQzI5bnhZ?=
 =?utf-8?B?N2lQWnBORWZ4eldwSmRzU01jMmhLY25FVlV6VTM4NzYydTFHUXFFYzBxUUdH?=
 =?utf-8?B?WUhTcjA2cEZHVzBSVGZaNDZqRXhvK0pEeFBMeEJWSktKM2RTVW5JKzcxUVlq?=
 =?utf-8?B?YjM3M1J4WVJJMnlheGV3N0xMR3p1OFdCT1BDK0djYmRWaHVTMmhaWXRlbnQ0?=
 =?utf-8?B?bUtYOXZ4Y2x0anFDQUlqYzZCd1YrWjFZRTNIc1JJMERMWGhsV1ZaYXFFeHRo?=
 =?utf-8?B?a1FXZHM2UlFvbmJPNVJuM0xNQzJQMXhYN2VZSndjL3NyQitJaUxMYU5FcmM5?=
 =?utf-8?B?WUtGUlI5VmxyWm1nbXhIQU5sdnNMWWdNMUl3UEU1R3YzejQwRUM0SncyeHdi?=
 =?utf-8?B?citjdE5oSTNKMzBXT3hRNy9Na01ETlRKQkdTcjFoakovSUxQVTdKMlVaaHFE?=
 =?utf-8?B?Wmk3VTJweEZsd1hDVVFrYUZHRGVMSThWVlQxYncwRkVsWEF5a0FicjRwdS9L?=
 =?utf-8?B?NnJkbmNhTDI4bVhRV1UwUEFNWG92RmNWdUMrZlhKVU4rZXM2VjRBbEhuM0tN?=
 =?utf-8?B?WkNDNXVpbWwxY0NzT0dqWTN6Y1BmdVpPU1FrWnIwTEJSamdHKzV1ZDNPSENU?=
 =?utf-8?B?bXdpSWRlY1lIVFBoNjZkaGxTU3hvakZKNEtIWWIrYmtSTy9hZFhXYTE2UHdq?=
 =?utf-8?B?VFlUTFNTVXI1SDBrdlFxb1R1WkE4RjM2SDUxc1VLeW1PNlhObFlINHk4VHpS?=
 =?utf-8?B?djRjOW4vVFZDS3RBMWN1aUhLYW9ySUFpNUdzUmpEUHQySlg1UHA0OWI5ZUk1?=
 =?utf-8?B?Vkl2Mnk4d0U5MFNVajhsa2lMaEZoa3IzSm9ZVXhNbk5VTWY3dHdkUkgwemVs?=
 =?utf-8?B?MkxVeVpXSmpDVDBpdTV2YlcrRXdFeG9SMXEzNUVaQmRUcnA0Q2piMXEveG5a?=
 =?utf-8?B?cTVyRmlJV3IwUmxGbE8wZFNRQnh0eU5WOXgzRGc4clpPRTh5Qzd1VGp3Znc5?=
 =?utf-8?B?M0x2OENoS1kvd2wrQkRReEdMb1Y1WUViTHp2Zm13cHl1di9YTnpQdlBSTmpH?=
 =?utf-8?B?WDV2U2wzVHRmTnI2UlpENVA5c0RHeWZjTnlqWEFNVXBIUXVoNDhrS2F2dUFS?=
 =?utf-8?B?dnhqcG56OWRuN09haEdyVU5IYk9IdUZFWUFpT3puVTFPREJBQmYvemlRSEox?=
 =?utf-8?B?enNuTmZJMG1XTS94RXVpNmJ2UjR4WXgvMVFaV29aTWV6RVh3Zm42VmQ2STJ2?=
 =?utf-8?B?MVJtbHlUdUJQVDdSbGJCS2xWMWFDbXRHdGJDUzJPQW45RVQwQlZ4bUp5TGlo?=
 =?utf-8?B?aHQ5eVA0d3MxK1RMNjFVQkFSc0o3Wm5yRkEwN2YwUlJ5cWZCQmRNNXFFbUEx?=
 =?utf-8?B?cGpsQ1ZaZlhaa2JHSXZYMDIzaDhTcHdhd0R3THI4Vm96dmZDbUpaNHZURGhU?=
 =?utf-8?B?OU1DWTVIY2lQMWluUFM5cEp0emRKQjBERExDYklqdVl1LzVPYXVLdXUwS2JQ?=
 =?utf-8?B?UVVQSWx4YVIvaVluYjFTOEE0b0xGN1RCdE9peHF5VjdieThJaHhnMzU4MWln?=
 =?utf-8?B?QmxLM3IzZnROcHMxR1dRanZxUnNMb3lNeGU1cXo5Z0EzekRIb0xDU0pRRklz?=
 =?utf-8?B?YTZHY3A0bkY4ZnJZSjl4YzdHT0tydTRPZ2pJMHRpeXNXdFMwK0t1d2Z2Q0xV?=
 =?utf-8?B?STNxeFhySEN0RXB5bTZnZ1Y0WVhEUFRhTXJQRkVHL0EvME0rc0VvcVRpcmt0?=
 =?utf-8?B?RlJ5VWsrTjUvOWJPVXFRT1U5N1RaUk9VTUQ4b0ZRZGljUGhUUVRKT2dES1or?=
 =?utf-8?B?UTAyTElNTHdDbzBwdlpndlBsUXg4WDgrTjJhNEk3M09mMWFnY0RQNnZ0b3BY?=
 =?utf-8?B?TVArbS9pcVQ4djcrUzkxbCs3Uys4YlRvVWRwRVZjc1FpLzJNaUcvYlFYczgy?=
 =?utf-8?Q?vNj0=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(36860700013)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2025 18:19:25.7243
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 96799b92-e2f3-434a-cc01-08de310628dc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE3D.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9209

On Thu, 27 Nov 2025 16:04:09 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.17.10 release.
> There are 176 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 Nov 2025 15:03:13 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.10-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.17.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.17:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    120 tests:	120 pass, 0 fail

Linux version:	6.17.10-rc2-g6c8c6a34f518
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
