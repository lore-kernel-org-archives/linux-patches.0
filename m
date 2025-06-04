Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2060.outbound.protection.outlook.com [40.107.94.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D18EF28D82F
	for <patches@lists.linux.dev>; Wed,  4 Jun 2025 09:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749030042; cv=fail; b=ZOS4hRbfCoa1plTNrLUEnKgSubZ4Dryf1b5oMOleZKq2zfsA28hv7XM8gt82qXLidq/JCR1qDlktg4WareyuDb5M4IlckAjIF9WxIE9jSjOBG1nfpmvZlNgpS6cHNsWE+mzM7M1cs4ZdC4MWEoVnSw6/ov8rP6/qcMLLZHlzxuw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749030042; c=relaxed/simple;
	bh=UW5Dp8X5mJ8pcczzcxC8sBKTgVV/F+Yj1IMHc5hTaKc=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=CDykuvKkOp/atUXeJ3Q05Gles6XFKqRxtejXuacmuigyd9sNZBicm/TUFyNAwp6QJJFveZ4cknM8y/8lvW4CAdVVzc/5unCrnwqWGm6kWekZZ+qBgjNVW/kqsFF/jN3teGFxYEWWg+3gJDCwd1JhNOorarRxzaXEFT2y4PuowcA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=YXxHNM6N; arc=fail smtp.client-ip=40.107.94.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YXxHNM6N"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bQDGYBDV3p0lW4BrWeIz0YAEaojpcWwyPbBE5hKbJD8W3x7mgYJLf6+lVLxrMlmAhTE+KNQpDoQW++b3qvWEbKHHz2bM2NvnXuCP7UYGe38bZ3UBVop/ZPQGdIUnhtHzGhws/AB7J7OkbaRArbLVrN6/jUXNNQQXwYQHBQQSk0h9oY8E3Zjkripb3Wa/5WVEdgjAUqkmS05/hzPDmUB5bjjfXJmbSr9vRMWIVCq1xoR/qaUm+ePsB60Bk7rofI+d0pOxKxeBggDc5rQSdHa21CtqJTHpBh7qMnKkMeJCaGf+h9HXvbzMk34nEhUXmLSAHbJGiRnEYdS+NbQCcCIBCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0dElta1HShDX7+0U6oMXp0dU60khoikfu4e3dJcdskU=;
 b=IBxm9POiWPLm8R1tpBqcxiH/M7ZqSnHfVRRy8upPNBzDbepnbUR5vKl1sQOIyPwEbDKKUgI8RsuqgQp0ntlZ5cuHxQJJRankb0emflBoHvAjr8cRmuS7qFxzpTQ/4/23b1GArgGuMoUZ/UROfqDZrXE2VDRyf5wrchPcBvIVS3Ze8vbiU1AZmaUCAN4jAisQWRwW9fNlkS3abZ7HuRgEcahLWHR6bIqz8ktgH2lbyAPLg5tgJK/1hf/ZShpSWSGKsF6yqd1dYnwcJbzyKcQHd3X6EHUQqYrN710seruDoB9boVzL+04Swx19xOU0iv93n4AhVof/8SSve8qzf3BmjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0dElta1HShDX7+0U6oMXp0dU60khoikfu4e3dJcdskU=;
 b=YXxHNM6NBZMiZBrxlJK2dt30QMf5bZQ+zTungwbJCxaiC2LWZq/jp5qCa1Jy6+DUQOPXhI+qVUfL6QnddYLgxAOnXIvv7HMgAuyO5VScyX2jH0rhxfCBH7XC6U1VH6qBqtGKflotglQxIy63dVbE3Q73H2S+jS230XHuw/ZczLh5FiTj1+GShMH+6EsO3vVNgn4UFiQKwSb1cE6ODBIVx5blHjji/U6332+GhLwTWSO/KGpd7wOH6GFannwNGtOtmRJHFkba006tDzXJHD7FM7dtxB4VKRybK72dxrrLKYxyGJIunTtzIawG4W4pc8eWxu2DvXqJqKVU3Xv5g79nmw==
Received: from BN9PR03CA0741.namprd03.prod.outlook.com (2603:10b6:408:110::26)
 by BY5PR12MB4257.namprd12.prod.outlook.com (2603:10b6:a03:20f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.36; Wed, 4 Jun
 2025 09:40:35 +0000
Received: from MN1PEPF0000ECDA.namprd02.prod.outlook.com
 (2603:10b6:408:110:cafe::5f) by BN9PR03CA0741.outlook.office365.com
 (2603:10b6:408:110::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8699.27 via Frontend Transport; Wed,
 4 Jun 2025 09:40:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 MN1PEPF0000ECDA.mail.protection.outlook.com (10.167.242.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8792.29 via Frontend Transport; Wed, 4 Jun 2025 09:40:34 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 4 Jun 2025
 02:40:15 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 4 Jun
 2025 02:40:15 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 4 Jun 2025 02:40:15 -0700
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
Subject: Re: [PATCH 5.15 000/207] 5.15.185-rc1 review
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <dfa6195e-e0f8-440c-bde7-50b06d16fd9f@rnnvmail204.nvidia.com>
Date: Wed, 4 Jun 2025 02:40:15 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECDA:EE_|BY5PR12MB4257:EE_
X-MS-Office365-Filtering-Correlation-Id: a6ca06d6-ec3e-4fc1-f75f-08dda34bdab4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|82310400026|376014|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RExzWVVRS1VOejZMUjk0cXRld3VBaHl5OStmU2FCR1NTTDByRWIwNlpYaTUr?=
 =?utf-8?B?UjdwMThVOGFocE5JeVR6Zy91ZjZsT0U1QU4xaUM2VVR0R2dsWExQNExERUpH?=
 =?utf-8?B?NjhzOUtVQzFiMWNtdTZjamNCRzByaVFkZnhvb2JjSnBFTCt5OXpkOElkN3dI?=
 =?utf-8?B?czRka0QxVXA0Q2VpVzZwVUFXS0VSa3VDczBRSHJIR3llZHpxSFZRb0lXRElp?=
 =?utf-8?B?aVljaXpabFpucjJ1ZVg4a20zYmhkNFVJaEpqRWU1ZHlKb3FKRGZxbHlUcjFo?=
 =?utf-8?B?bW9ReHMxUy9YaWQ2TldLV2M3MUsxRzFGK0QzM1BDZ2RoVlZkZVo4QVJrTEtv?=
 =?utf-8?B?UDM1THUwK2J6bGk1V2VaeEwwcFg5bVJCejl2UXBKanhYNEU5cFFXUUpNN240?=
 =?utf-8?B?N1h1Zm1QZ2tpQnZMelJZZlk0ckswR3U3NFB5cE5zRnVkd0YrTlppYko4RENs?=
 =?utf-8?B?d2N4bkpaL1FJUzZuMjF0MmFURlZCUmZLRUczd25jd2hqNXQ0dnBTbFBod3hV?=
 =?utf-8?B?UEsxWDZ4NjhhM2RJdlRoUmJMOUNOS1ZLUDNmcGJEMURJVEpOQnZCdmg4enBB?=
 =?utf-8?B?M1RWcGhiSmlzZGxZTCtUR3lkMERGeDN6anZiZWt2UWRQMFp5L28xaFQzZWxx?=
 =?utf-8?B?TmR5azFYZUtDWHNBMzRQSmE1eHZ1RVZsc2V6ckplVmozN1hOdFJXaVpleW84?=
 =?utf-8?B?Mi9LWjJPaFNHZHp3UnRTL29hRHIxSE1sZzIzcGg1SEN6dkhOSTBLUGJGK2lr?=
 =?utf-8?B?WG1DazBrNk42SDhoQU1YcDNrSWEzSFdleWg5R25CaFFYOUh0V0EwNEFQOFRy?=
 =?utf-8?B?ZWtLQU1pd1g0L3NnWnFkSXlxY0c0REdCdVFPRFAyUUVPYXlrd2J0cE9WUGl0?=
 =?utf-8?B?TVZoL3JIR2pXdXZSL3l2ZmJCcUg5WGZjem5OYTY5R01ZaTM3WnVNd3pnL04r?=
 =?utf-8?B?S2VBNXN2Q1c0S2UycHo4VzJnSjFVSEc1MHMzWFFYUXoxZDRSVTFLN0xNR0Y3?=
 =?utf-8?B?RGUzRnJ1SGlQMkJLazFCMFVYQkFrVG9ZTkFjcnEvRjZHTDR1Vno5YXJBRlBB?=
 =?utf-8?B?MUFCN282QllUa0ZVNUY4YTF3N1NzUFpCbnUreUptbTBHdlRRZExjZy9WeTVH?=
 =?utf-8?B?QnE3VDlzWnRhcmVUQU96bzlRaGdpeWtrRTA3QjZBTHBCWDNMSTFLYkxIODc2?=
 =?utf-8?B?MTVST3djTmJZNFdPYTA5di9aaWVrOTV1aStZWktQdVhpVVNIOHVMcDJGb3po?=
 =?utf-8?B?bkljZk5nSkVDeXRsdlI5enJkZW5QUy9KdXliU1R2bzYvb3RmMDQ5SHhmK0RB?=
 =?utf-8?B?TzdDb2ZZbGtDYUZsYzBZOThWSDN5QWhkUk9BOGFGZHhBVXJ2aENCVU9JR3Vx?=
 =?utf-8?B?d291T0hzMlJGOWxDOGJxWmVlSDEvb29KandBNDNuV2JrN0RYWE9VZUVVY05M?=
 =?utf-8?B?cldzNXpUbmxlYzAvaGxxQjhva1hPOXhaU0RCQjB6VW9uK0UxaURjOHJ3dHpB?=
 =?utf-8?B?THY1K1N1a3ErUXRTSDhQbHY4RlRxVlZLcnFPV20rNFNCT1ZWbWR6ZFQ2cUti?=
 =?utf-8?B?VVpmS2pyNTVkVTdMb0hUejJvTzdNT3p3WXhFdTYrTitNNHlWb0lkdW9VSkEx?=
 =?utf-8?B?MlZ4SVBBL0dLbzl4UG5SUm4zcjhxMTBjMUVmdnVYd3Jra2dTajNRZmVjZUhT?=
 =?utf-8?B?bmRGYzJJV0dhcitwemppc0JTREhXaEF0MGhyRm1abmUrUEdBbkFMejNqUEU1?=
 =?utf-8?B?RkJNTVVNWC8xeHk3ZkVEWE5rcCsvYUt1Z0ZxWG4zZFVRdTU3dFFUU0VTdEcx?=
 =?utf-8?B?ZGg0WmtCNzFkSGY3eU9XdXRVN01ScGhKbWUyU0hqeHAzNEdFS3pER2V4eWFz?=
 =?utf-8?B?c3pJRS9ZS003aTB2TTg3YmNndXozUTljRDRibGJmK1V1MFJ3V3ZjRzgvTHZX?=
 =?utf-8?B?SnY2QzRrZFNJV3dxM01abVRPQUlLWDZWb3U2LzRmSFJlaWhXdVRWZnBnRTV1?=
 =?utf-8?B?Q2dsMnJpSTN6aWZhQVJJTVVudmJkMlkzT05TRkxIbzUxc01HT3VmekZobFF5?=
 =?utf-8?B?cWduNlZGRlVvREtvbWlEWnZwdVl1bTlSTnpyQT09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(82310400026)(376014)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2025 09:40:34.1656
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a6ca06d6-ec3e-4fc1-f75f-08dda34bdab4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000ECDA.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4257

On Mon, 02 Jun 2025 15:46:12 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.185 release.
> There are 207 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 04 Jun 2025 13:42:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.185-rc1.gz
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
    101 tests:	101 pass, 0 fail

Linux version:	5.15.185-rc1-g5f6a7d9dc0f9
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
