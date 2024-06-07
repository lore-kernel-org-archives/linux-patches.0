Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2082.outbound.protection.outlook.com [40.107.244.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA42158D6C
	for <patches@lists.linux.dev>; Fri,  7 Jun 2024 09:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717750938; cv=fail; b=Z3m33APrngSrFIi2CVjA31yJxGUtkJ5Lzx6dYRGvWlHjtyMBhqqnfxnAzq/2BKkcsUz+wsYwUgwdp6IbM4st8/G9OnznKvGccbiLfhsod88fULz2hKEDavKuJFexcLjkcOHfaKHCsH+jeiuxDOAZUvVfV9XF8Uhwo1ZNd1Qzbro=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717750938; c=relaxed/simple;
	bh=uipOWUvAJm5iiIJYHejUG9NqbuKc7/wfFq8KMHGDzcY=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=XJ5XFFobaukU7rdguqanfgMhVN8NO7bOMpn/k6i6Zmu1FIUWNeGUV3FCpPc4+7xbj0xflL7GVrhmSXlakyLXm0KcQT4MQrdfhBDhZAXPh/CrDrZVo0iSjtM21okicbga50bucevqPbhFrb2JLTIXNONhqEg8Yd2szMKHVnrerLY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=L4lhslcO; arc=fail smtp.client-ip=40.107.244.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="L4lhslcO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QNfCfTbhgAVCgxTfyJj/ziWxH/mC+FB3yqSGGIG3ZDZ2qbQK6tYCMDkkNMAnOyRXznpruZ+iXPC+hJCp6XPm2fr8KgtPsIdR5FHdxaGgVKcbo1DSh7pj1wslM4+KM/2nl9U0Cg3qQqEuVFDM+XoEyATDEYnIcBOnPapoq0P4qc9YEHPGW9MUQt6YdnvrGISLebrXundLRj7ab9y6ix7QDqAelXc68yk5K122iopy14cOTizGcOUesTyws1Y9H2x8aCPn5JW7vhCfr6XWt+RcJI9x0tGfWIOE4j3HPvlpsXYRXtVfDGF0AzmUckWfuTF+miDvRwvR9yG9S+8JOEqQVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OVsiLSxSp6tJ1WZ680pm4SWu2UQR0VZeFFDKhUV7SQ4=;
 b=mRxm65F5KVNyBgAroGByTzhaD0RK8NnBKOIdTeeN3mE06y3RrY+Pcluh/KQDI3BzAXWnIfhoZzqo3fRi2cervv9jx+VTEgEdbwnRNs7qkCkJTLFxnxduLQp/2gT1wLeppfH5TwU/wOUrzxEx2OqCXYNCJHKY4NTfKcA3iu0DVjIsar3PsTIKZkCfqp3DwgGYPLCm/hvinFbvH37A7/bPABlQTmzfpMH/IsSrMCLNdR9s/Iw9G7cmEm1rB9ApiimwjsczYTooKNdnLkgJeoq3OiHOdwBRJkoF56E4dcqEzFenDA+VoD5f3XWq6W18dM+N2q8EBy/uXU5pJCrn8MRA0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OVsiLSxSp6tJ1WZ680pm4SWu2UQR0VZeFFDKhUV7SQ4=;
 b=L4lhslcOKe8Ryi74xMWmiPXaRQubl4/e8CrYP+XFH1/fnefsik/JzdJfLhqfltxCp5mfXzzhgo7gqHd2hC/eEqEgRKDiFcjfMu3QpJyGIU7ydrCYpFGpZKVgWAkicG+BqHGkguAFadqrwKAWKIuDEBX4iu5JMrmz/zrJ3yYhNiWLW4tRVyD/Siggw/Du89vjtvVKvCaZdY0w0gwK2ceSKSKn7zrUYuYQaH2wi7zQL/FhxG60LMEpSBTdKkBKIldatWPyYfQbEgDLQwOo0xeKrQpwkU5RjfUQLfpDzA3B2SBTDK4rJtSRMK7G4ukxBmQCtksxCGeav5eRW9q3YDBlbQ==
Received: from PH7P222CA0001.NAMP222.PROD.OUTLOOK.COM (2603:10b6:510:33a::14)
 by IA0PR12MB8278.namprd12.prod.outlook.com (2603:10b6:208:3dc::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.33; Fri, 7 Jun
 2024 09:02:08 +0000
Received: from CY4PEPF0000EE36.namprd05.prod.outlook.com
 (2603:10b6:510:33a:cafe::a6) by PH7P222CA0001.outlook.office365.com
 (2603:10b6:510:33a::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7656.21 via Frontend
 Transport; Fri, 7 Jun 2024 09:02:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000EE36.mail.protection.outlook.com (10.167.242.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7633.15 via Frontend Transport; Fri, 7 Jun 2024 09:02:07 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 7 Jun 2024
 02:01:53 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 7 Jun 2024
 02:01:53 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Fri, 7 Jun 2024 02:01:52 -0700
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
Subject: Re: [PATCH 6.1 000/473] 6.1.93-rc1 review
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <9310e83e-1301-494c-bd1e-2cf9321f99ab@rnnvmail204.nvidia.com>
Date: Fri, 7 Jun 2024 02:01:52 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE36:EE_|IA0PR12MB8278:EE_
X-MS-Office365-Filtering-Correlation-Id: aaf3eb54-a3a0-44f8-457e-08dc86d08288
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|36860700004|7416005|1800799015|376005|82310400017;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Q3dPTHd1b0JTWTdIaXVBcDNaV1NZWXFNaktKM1RSL2ZxUVkrOHZIL2JJSWN5?=
 =?utf-8?B?dVlUZ2UvbkZ3cXA1N3NGL3Q1STlYa0VyTXlOclF2MmZaUktIdm02ZHNhcnNC?=
 =?utf-8?B?TDlzZU9MV3UrV1FTNUgrVUtVUy9xcnF2TXRDOEJhMzF4MS9qYVF3d1p6dEx1?=
 =?utf-8?B?OG5ZMkJ6YWFhUXRubFZ4NWs3SEJqVkVJOHRjbjIwTUN0a1l1QnFxaEc4UlJq?=
 =?utf-8?B?NzcweVRXaVZpdG5BTTBwNTczTnZsYXdpOFVzNk10NWdzdGZ4Sk40TlYwaGFE?=
 =?utf-8?B?dTM2bytuc2tucE1uNlBsYjhpMG5sTFBEcElvakR3ZXpoU3crWjZudDVUK3lp?=
 =?utf-8?B?MVBsaVYzL2JiYml1OFZ0c0VrRnRCV1NmOHdsY0JoSHRIemMrV1dBRi85L081?=
 =?utf-8?B?ODZ6OWlFdHA1VDVVdGlxTW1XV0lPWVd2bUQvTkRnSnUzRzdtQ0NUeXN1bnE4?=
 =?utf-8?B?Sm5HcU5HeGIvaUtUNWpBNlRKd1RsM3c0aTNYcXZmeS9McTRYaFE0TEt2ZlZJ?=
 =?utf-8?B?ajQ0dGgrMk9lVCtuVHFiS0Zad3lEcWdQUzl4eUhPQUZ5UjFSNURzNlh5UjRD?=
 =?utf-8?B?aWw2Y1hsc015SklCa0d4RTJhNk5IUi90K3hyWEpzMFlzcEFBWktZUndhQUlD?=
 =?utf-8?B?eTFnaHBPUS9ablExeUsxU3loNFdPQlZXOHZBTGlsMFF3R1RXNFY4OUVIbldr?=
 =?utf-8?B?Zm1uVjlpZHM4T2hOcVJiU1BnclNLWHZvU3M0OUFNMWFrOUdDN1B3N2trZm8y?=
 =?utf-8?B?dzYvNXlPc3hRQjFaWjBpck9GalZZVVVwR3cwYlZocVJzazdCeUlxN1hRNGpn?=
 =?utf-8?B?RTlCeHNpbzNxZmo4SzZtU3I5ZkxoTGloOGRLa1k0SGFRUXdnaDVHQXN6bzhF?=
 =?utf-8?B?RU9WcktnZFF1S0greFdvTU1sUFRNeFQwQjlpTVBUUFo2aXdFZmJKOVlWak83?=
 =?utf-8?B?TXhCSGNwdjZLVWR2dFEyWXpDTUsyY0VVMXdSb29LSWk4ck9wTmx6TGdyNDZX?=
 =?utf-8?B?cXVxMnV2OXFzeWtNNWtyUXZEVVlSZW80NkdWQzVlMVRWNmhhdW5mcXZVWnI0?=
 =?utf-8?B?ZHRDTmRiU0NHeXE5cWN0TDVNaXZ0SFlqU0EyUHZ6eXlVSHE4bUludlRSU2w3?=
 =?utf-8?B?R0xXWHd4S1Vka05GZWNlSE8xeDJoQ1daMmhGYXdPQ3pyRlZ4R296NnByYVp5?=
 =?utf-8?B?ZlQvbXIrYlY3UHBici9JMlFqK3ZBcEpCWkJUZTNlMTFNSjRTcE9wYitWOXRl?=
 =?utf-8?B?Mm05V0dKMTRYVmtaQzBJQkQvdndYamNHZllxZmVqbHV2eWpCbzBWSkdPaEIv?=
 =?utf-8?B?eTdWRUQxUW9DUkxRNSt0Z3JzVExtZTU4ZlBSUDdLR0E1VmpRVVZnbk82eW9P?=
 =?utf-8?B?aXhsTnZLcFN0RmJWSE9CaXRXRnI2N1JMdURlVTF0elRTUmF6clFyRjFmVzEr?=
 =?utf-8?B?TUtBQW1FWkZESlpBVXFUZVI0QUwzTnNOVHB5SU16RkV6MkEzTzNtOWg4MTRG?=
 =?utf-8?B?NnBFWUZtd2tUQ1IrSTNoRVV3YmwrRGl1RjZvdG9FcHZtTC9ycVh6NnhwWU51?=
 =?utf-8?B?SzhhQXpuWGRPVDhXYitoVjMrV29TczREL2ZKbVhYdjd0Q2FxNFJmNEZ6UzFh?=
 =?utf-8?B?b2NKeWV2Y0V3WmNvWkhhd2ZkWFJ3d2FuSVlscjhleWRNQXlJWCtoUmkyeEhC?=
 =?utf-8?B?LytHbzZpR05kWVJvOVBac1JxZGlGTFgvbUR4cHNnQ29jMk1INVJYVTFtN1Ni?=
 =?utf-8?B?KzRUeThxRHhwQmQ3N1pBclFhcU5ZdmxpZkgxU3M3bXVFTW1yeWx5VTNCNDdW?=
 =?utf-8?B?SmFTREdwSS84N0krOG1zMWdMS0gyK0FIRVZoaDVybXNBOWNjblBQVzMvV21M?=
 =?utf-8?B?QXJzNkNHL1NRTjZmcGZzWFJXbG5PK3JwSDhwY3BGd1hFN1E9PQ==?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(36860700004)(7416005)(1800799015)(376005)(82310400017);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2024 09:02:07.9649
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aaf3eb54-a3a0-44f8-457e-08dc86d08288
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE36.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8278

On Thu, 06 Jun 2024 15:58:49 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.93 release.
> There are 473 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 08 Jun 2024 13:15:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.93-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.1:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.1.93-rc1-gd2106b62e226
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
