Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2062.outbound.protection.outlook.com [40.107.236.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E851C200A9
	for <patches@lists.linux.dev>; Fri, 17 May 2024 09:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715938093; cv=fail; b=tnesXqsopuTYV4doTQqBrgZwqoLYbmAB8iIqRdx2n2jHaMM7mKrieWnbqJPz5La7KkZca27Z8urWcAba2JkUEZjL5lUVMKH8Tleql95MCE4OYlacpkaGu16yjq83XNqhldSfeHgR2ESDyUUqMwZKPAF4RE09by73lrL+1DtMcX0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715938093; c=relaxed/simple;
	bh=3u6y0NK+THjT3oRtLScr+u4WuEc9M8bcyEHSluKFnWo=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=kInQ3IW61/1GLy8dojEAfL7m/9f7LMpCpPsM7tnldOg6BNM19eZftVRRh8KHX1g+yPnN/0Y8tqRmnIxHrObbsmlNlPIvB8h8pIp6T+KkOjdQk2sG8v98qF1mDT9o4ZT3SjQswRbbgqp34aLfiA/g8mRwTQ9hIzQEInET3ZArlsY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=k4OEynk8; arc=fail smtp.client-ip=40.107.236.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="k4OEynk8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nzoo494ny9nYZiW28BlFyTtghyD2wYAfplUMiKDHJlg2YfB+OO12ba1/wG0YPAgB42w9WmXOlO6RnCYq9EZ5fAT+QafWAMPuI+p6x2WsqgE3Ho/DQXy1pwJPaucJyre0UmIFzyz+LniKKZYZkMMon3kXF8oRu3am2hATnqMG9sh0+CNGEjn/XRl6t0NaGbAqxYPjdsHiGo5nBXA9VvMmF6a+93pLUjGhrzab2uhVvcXJ4LOMreHYRiYT2OUGHXHNPKEx78WaCWNzjX5efgzhC1ROUMNQ6Co8xe99+XT98Vvuo+QFj8c320/lHneWqKSPLYA4df3o2TNCujdd3MedGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xfqQLp9+uA4iqSLQjwA+B/iJffOT/OkB0z+mV8S52Sk=;
 b=dAyF6yDP5AaPddiBaes0bHatRAZ7f79RBd4BNFRQsQ4BGrwW5bKTCpHQvERcY0KQYZaLZZshlRJczvXWOUY1ekpUIdbEoMvv9zCNWqtMjbB8AvyXBXoEjt1MPdUvmA7CNXn7NJKUF3l+x0G6C0y/zzhYdjRnxz40naksZby5CPPA76i9v/AxVhORsNwksMPae/DiGXceEazQBQ1eRkr28Jc3z+qlNKsdLqMEsBQhljUey8K4/i/VntzSkuXkL8fCfZQFpZbFJnpK4sLimxB4O7NpcJalyJIw5XFrZCx5KgC9cCenDWR9rO1X+puG0CWgXg8rIoVztho6LEGgDd6sDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xfqQLp9+uA4iqSLQjwA+B/iJffOT/OkB0z+mV8S52Sk=;
 b=k4OEynk8oXMac8SY3Jfk7yxU7yIyShNm/lNMUoqPHGZOP9Q5SgVHbJECfFj5xZBiqhPEUbibGmG4waVgANVAMl63LUIdBiO0YxLxVNWheZcr0zLEM0m2MW7dmUqRzT8ePmjnT5qR+1tgEcBB7hDwDtOys6DTBM73R+kmsucPX3RrKkAwqImxDo77+fswkGOR4s+N+5zSwOE1w9WDONcw5ijeepNSqLBCsotjdq9i/uU6tkxxRMa6codD0C3GbNqJoizMxPKhtbk40zEbOYKt8u1VGH/cJj/APsL1Q5H3aUUBqY+Sz50yBbNwiD50Tw32g3xh/9vS2CKpQh1qtl9PGg==
Received: from BLAPR05CA0005.namprd05.prod.outlook.com (2603:10b6:208:36e::14)
 by IA0PR12MB8932.namprd12.prod.outlook.com (2603:10b6:208:492::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.30; Fri, 17 May
 2024 09:28:08 +0000
Received: from BN3PEPF0000B36D.namprd21.prod.outlook.com
 (2603:10b6:208:36e:cafe::7d) by BLAPR05CA0005.outlook.office365.com
 (2603:10b6:208:36e::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.13 via Frontend
 Transport; Fri, 17 May 2024 09:28:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN3PEPF0000B36D.mail.protection.outlook.com (10.167.243.164) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7587.0 via Frontend Transport; Fri, 17 May 2024 09:28:08 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 17 May
 2024 02:27:50 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 17 May
 2024 02:27:50 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Fri, 17 May 2024 02:27:50 -0700
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
Subject: Re: [PATCH 6.8 000/339] 6.8.10-rc3 review
In-Reply-To: <20240516121349.430565475@linuxfoundation.org>
References: <20240516121349.430565475@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <c0bda358-1480-47d5-80c9-4dfeada1edee@rnnvmail204.nvidia.com>
Date: Fri, 17 May 2024 02:27:50 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B36D:EE_|IA0PR12MB8932:EE_
X-MS-Office365-Filtering-Correlation-Id: c2e586eb-43e1-4efb-fc75-08dc7653a9d8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|36860700004|1800799015|376005|82310400017|7416005;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SUs1YlFzOHJyTTBNODBHWW9SZ0wraDNZT3hob0tiSm5oSFFYK0NpUFdMQi93?=
 =?utf-8?B?Vzl5N1JxNjhlWFNCOUVSWm41QjBNeXlhVy9sd2VjNHA4c0JJV3VSNTcvakJP?=
 =?utf-8?B?Y0dWR3BFMWQzWDhoV2oxMWdYTExMNzF1WFI2U285bml0N2FhMWtpQXY0NUo2?=
 =?utf-8?B?Y2kzL0NCUzUwbUZaTlZDL3hwK3RrUWdIV2RQL042a05vZ2RHblRwTHZINmkz?=
 =?utf-8?B?enV0VVJvaXkrRDZ2RzIxdmZVaUJhWk83Z1FKZHJlV3I1MGtwSTRGTnd4Wnpi?=
 =?utf-8?B?UEJSdEZuaXZLZ3liS1hOT1dPQkpjUEk5RHhVZS96SmZqaDFsdHBvYzByUzA0?=
 =?utf-8?B?M25GdkYvMk1wV0VpSjNCbmVPNnltb1ZJTWsrc0JHbDM3YjcxNko2UklNb0hX?=
 =?utf-8?B?WXpRNE4vQ05qT0UzUWFMUGhPZVlIaDhsaHNjbnI4T1Y4THFXQVdoeENiT1Rn?=
 =?utf-8?B?b2xKZ2Z4R29rZWpwc2lFYlQ3UnF6K2F0dEVYS2drVG8zQlpJMVc5YmxncUpJ?=
 =?utf-8?B?OE1xRjdJQVltVlJ4czcwelEybVE2dnRITXp1MEJGemdXZ2puVkhJZjZxS082?=
 =?utf-8?B?NWxRRnlya3hMVEVPRms4MXRUUHBoWFJQemxqUFVINTVpd1VFN0tkZ1pCL0hH?=
 =?utf-8?B?UTc4VmdLSHVTNVJJVE4vNnlHMkI0Q1ozYmRZVFRHbGszZHFkTm4yTFBYb0Qw?=
 =?utf-8?B?RWhGOUFwQXg3V2lRblVOOTR0TXBDTEN0UzhWLzVVUWpsN0FGUTh2RWNtbm43?=
 =?utf-8?B?cEw5akVFZDlGMHJENzRQZ0NYa3ErWUZVUFFJOVJwWk44eVd3cnIxNHFDWnd1?=
 =?utf-8?B?dEpyWjk1NU9meEkzbGhwV2NNUE94a1pXKytwRG83NUlJSU5DN2M1RGNkRURC?=
 =?utf-8?B?MWRPemRteUFmSVU1T0hVNmRqblRDeE1FZDM4QWpndnlKV0h0N3l1eW1OdHlR?=
 =?utf-8?B?UkZlckJ6TlRIUlZubE5GWWVaUnprbHAzL1VUQUJyVEtBSjBDN2Vsd2tHTnRp?=
 =?utf-8?B?dzdIQUErdXlxL0NYbnRJNCtjOGgrcVFvMUVBdFVXS29nR3JPWHFPR0pKbm9N?=
 =?utf-8?B?dHN3UytMSG9wbm5YUVhLYWZOWWRicHRERThnV1JBbXhxUGJnS0d6dVpQZ1J6?=
 =?utf-8?B?MlJiOE9XQk1YM25ZbXh5UEtEd29xT1hMc09WZk92ZjlwbHhWTHJGZi83T3Bz?=
 =?utf-8?B?S1h3cTNBQnB0aEROcnRpWVZzZld1VkRNeUoxNXVNejFMbEJUdUR6RE52ZElF?=
 =?utf-8?B?clJpMmV1MjlzRzRyWGloSmtZNmFoUCt1SWZZSWlERDBSNHBTRVY5Smc1SEk5?=
 =?utf-8?B?b25LdDkxcmdyQmF2SXRLODNaSkE1eVJuZmh0Q3A2S3BZU0lwQVVDRXI2bDdC?=
 =?utf-8?B?NncxQUtJODU3dnpNc3dmVUxVbUl0WHBFL0k5NTF3YW0yOE4wVlc0L0ZPSnpQ?=
 =?utf-8?B?Z0xITkgxanRYL0hNY2RsdWJpVjN6cnlBa08vNDhEcUtaS1FBakJ1SWZJcVN6?=
 =?utf-8?B?Sk5UK0pnRVYwQXVMeHhpWlBjR1Y2NTZKbUV5T1hOU0czNHFZWWdYRENUZjh6?=
 =?utf-8?B?SmpOclRDZFB4VDdXVWZicUlaUDF4KzVJL2ZYc0NRL1J0WHgzclh4Y2taeXFC?=
 =?utf-8?B?SEpvc3A5YTJPLzNLdjNUbTU2ZGFXNzVhN3Y1UWFBWHRMNXc4WU0vdVFTcDBB?=
 =?utf-8?B?aXdtZ1ZJNWZTbzNuZW91M2owRHRWeTZmR2xnRitqQkhiaEdQbDBKdS9UeVpr?=
 =?utf-8?B?SHordnQzTUowMEFsT3NYb0dhOUtVN3hpWGMvM01mZjYrVkZqcWpaOFB4M1o1?=
 =?utf-8?B?QXlOQ0pXbklHb0hGK0tLS2xxT1pBVjhLYXNqN241S09EdGNFeDBSb0hPNm1s?=
 =?utf-8?Q?ZwJVx4nmm/p8O?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(36860700004)(1800799015)(376005)(82310400017)(7416005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2024 09:28:08.1669
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c2e586eb-43e1-4efb-fc75-08dc7653a9d8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B36D.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8932

On Thu, 16 May 2024 14:14:57 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.8.10 release.
> There are 339 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 May 2024 12:12:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.8.10-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.8.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.8:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.8.10-rc3-gcb6ab33e1bb7
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
