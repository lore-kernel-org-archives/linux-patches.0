Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2079.outbound.protection.outlook.com [40.107.236.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80BE8207A26
	for <patches@lists.linux.dev>; Wed, 25 Jun 2025 07:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750836260; cv=fail; b=WdAVKpslLkffiVJaIqw7YyGD8sQvPNv+P4533srY4rapqQPzX+2ship/Xc4dLeYmxHu43EiaebUO0pPnk/qDUUR0P9dm/mToMFpi8oKs2STHNebMTHFDzVSSYQpZMhpWHXFMHg0Vo8NXRUbOZ96gvRCtRfJYEWlhYGz6AUrqByE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750836260; c=relaxed/simple;
	bh=HLD5vZgqdmamdqJR5XZydRGy+Lr4XuWVNLkPTc2+gec=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=agUUydJiuFC+w7SSGrH14vu03484V0YRcsa71LoUEjb1QzPojBnrzpACPVM/SscdSv3S8AYhIMLYQyirF7c6QHTn4Fg2JXQyeJuNxZkrLi7JFTsUi8AOKnciq8YvMDZD142P35+FXKPMC2B4W+Gmr80jQyj0EEcuc+UgJJelT74=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=S9RvsIO5; arc=fail smtp.client-ip=40.107.236.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="S9RvsIO5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k81b7x8s76iljfOEz/QoRBd1l+0Iblr5ZxYhMpLi5eDEs0EIW0N3SlCVHdP+Q5Xj7UR/d506weg8MC+CXiRSt8GqC4ghZ12zRA9zOFaVmsICWzaWY9uF1rfXVFDgdqcLz90XhxeFl6WYxonhDDAkmldG68VForoqAQfGrZJeINlLj+cdvTiXiGcLyB23LROCym0vaYRnSLh74rLq7puGv+C/elkLuUgySdMbW14/frea/xUnwOmr7eJjTeDndui1G+Kq2EEHOXNIZZ4i8ugRy8hz+8TVrfBMbFZjC+r0BGHNzGbYQcU4fL6K+xqu55nZDHe6zcp//As31vfQw5PS9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jzE7e1aWiVl5AipMwATRSiGkoPX3RXO9tRmKnjgEUu4=;
 b=am2E/1PUr2ghJmIOFf+mfljfGhq1Pi8O6W/nJF7sApS1P8Nb95OQm9klnzOYCy2JpnnYbd/i6lXHOOZLJyGcdQTHNC1uDI46ddt5pxfl1T409AqSkRa7XjHfqEJ9N5tjAqhO7jsIg0BJHlv0zZ+1xqfVyj4E0gL7tXY+DTfzZwqVO8j37K8UMCOspl5n8jYs5dADkkrlZAj3DsjKann02fWRBFB8yeLcbMhnf0U9prBddOdg1MJ3l6Dty0GnJCiQUYJgCMpwhXn4t5SOEff2HocHfyJ1/kqyntVhHCt7zONKXaExMrVJnCMSAQzu0Cbv0ptannt0zKAzz1fNgbk4Cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jzE7e1aWiVl5AipMwATRSiGkoPX3RXO9tRmKnjgEUu4=;
 b=S9RvsIO50gcKu2g3MsBINtIl4tqzitpGVJNRmbCUvxuhFfOqjh3d73QgAOnKMsio9wB7O+Zkx0hiZge4CIN6aGC5hxCIjB9TUKpQAUKWnH23iGU41xpfdSji6G2HXRv93Pf9MbsrkjKlEe2gK/cd/RTnf0iTVbDGHKLRUfxYb0kWUFlr/6hjx7R3eLXvG6GDUH1gVCoEYt/SmXduNA6gcN0EGodxGYOqpzwUuHykJyfeMjpm+X/T1ocKMDpmNGD4WuNBsbTh8HRijvyBKIxVQE7wn1GME1X15oYiVKvYopuPi/Ls+VeqVgglY9Y/4NzLzdPd5CUShkdJN9ri7hmVWw==
Received: from BYAPR02CA0035.namprd02.prod.outlook.com (2603:10b6:a02:ee::48)
 by SJ1PR12MB6052.namprd12.prod.outlook.com (2603:10b6:a03:489::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.25; Wed, 25 Jun
 2025 07:24:12 +0000
Received: from SJ5PEPF00000203.namprd05.prod.outlook.com
 (2603:10b6:a02:ee:cafe::b9) by BYAPR02CA0035.outlook.office365.com
 (2603:10b6:a02:ee::48) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8880.17 via Frontend Transport; Wed,
 25 Jun 2025 07:24:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ5PEPF00000203.mail.protection.outlook.com (10.167.244.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8880.14 via Frontend Transport; Wed, 25 Jun 2025 07:24:12 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 25 Jun
 2025 00:24:04 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 25 Jun
 2025 00:24:02 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 25 Jun 2025 00:24:02 -0700
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
Subject: Re: [PATCH 6.6 000/288] 6.6.95-rc2 review
In-Reply-To: <20250624121409.093630364@linuxfoundation.org>
References: <20250624121409.093630364@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <b160e2e6-e311-4b53-9e04-b3e2864a9e10@rnnvmail204.nvidia.com>
Date: Wed, 25 Jun 2025 00:24:02 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF00000203:EE_|SJ1PR12MB6052:EE_
X-MS-Office365-Filtering-Correlation-Id: 46c0392b-cada-49e4-f3b2-08ddb3b948a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|1800799024|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UytZOGpQT2h3TXNoN1AyRWRMRlphbHBib0k1M3ErdmhrLzRyUitOb3FHazdx?=
 =?utf-8?B?a0ZBbk50K3EvVUVOQTJ5TmwwSUlaY285K1dndE90ZnNVVXJQbFNtZnJZbGtD?=
 =?utf-8?B?WW1qRU1zVzZlODZyOW5wVndDL0NKbHhBYVRRTlMxOHdrN2xlMEMwY00wMURU?=
 =?utf-8?B?VW8zZFZZck85Q09LMld1Z3FFemZuRE12UzdvUTdxSVM1MTRmeTRBSzRXUDdi?=
 =?utf-8?B?dWI4ZkFVQ2lyNDBPc2FrK1JQZHZoWXRZVENGai9kWHdiQXRqTjRxZkU3U0k1?=
 =?utf-8?B?RVM2SGZwU1NrS0NWc2drYWxKb2VBOE11ajJwRmtJb29EQUFlUUpabElrQTgr?=
 =?utf-8?B?ZUVDWnQ3QStMbDcydzRKZnFWdTZRQ2dwVVVWMFhJTVluVDRZTEZ0TUljMEov?=
 =?utf-8?B?bTB1cE1ndjl4VVdVYXlLaDQ0YUNmMjViUWFpdTQzVWhyR0FiaXBRdCt0TnVz?=
 =?utf-8?B?bmpYeFhscGk1b0puWm96aUIzRTJlU0o4bUJWK0Y1dlB2Vm9Kc1U4b2VQaW0v?=
 =?utf-8?B?NHVQS0hjSHhUcG1hVW5GZktpN2RjbVlPK2pMYVl3TnVOUlF5M3VrakwzM21V?=
 =?utf-8?B?djZIZGdRQkRmeU1zUm9vQXkxQ1l6V1JnMUlIZG1vY0R2MTAvc0Zrbjd1WDB4?=
 =?utf-8?B?UUVhTHZmT3diTEl3MnlqSXpJSzRSTXdZQUY5Um1LOHVvSzluT2MyTEpnWXdT?=
 =?utf-8?B?Q0JLV0g1bU8wNC9xUjUrWWJ3a3BWQXV6dlJLSnp6NWprVy9wbkcrTDhQN29J?=
 =?utf-8?B?MjlkSFZCV1duMGxhaklLTlJ3WUk1UmpCd3p1QUlaS0RYWEFNYkRYYmJKZklC?=
 =?utf-8?B?OExYWGVaci9teXM2M3M0RWpvWk1jSFB6cVVtTkhmVnhjZ1NzNG00TWZRT011?=
 =?utf-8?B?ZGhWZDFnRnlYQWFwVFpyS2JHMG92UjhZTll0empIenEybHpNVTZXK05mV0ds?=
 =?utf-8?B?anR1ZlFhQ0ZMRW9JaDhkT0Q4N0V4b2JOb0dmVjBUeDQvQzFQUnlGQ3kycjNJ?=
 =?utf-8?B?Z2tWK1dIMXVEb0lJMjRSNFNuWXFDaDk2ZHJwRVFRclBKcXFXdFp1cklzQm1s?=
 =?utf-8?B?OTlDUkVjOFV4UmdWYVVxdHF2Y2NSdDZvbGNWdFdMUzdZZ0FjSDRibEl0K0R3?=
 =?utf-8?B?WW5pZnVJbllHY1BlS3VzdStIWldDVDV3c0Z3My9EdU14WlAwRThjMDZtakpr?=
 =?utf-8?B?MWxEd3BVaDYxLytRZ1hrMlozNHJhdE93ZVJlMGtCL21IYStRek5UUTd5Q1RZ?=
 =?utf-8?B?Y203a1FxMk1tbEJ6TkM1MDBYSEhHRFZEZlE5NnN0SDkzaDRNZU5tZVhsU3po?=
 =?utf-8?B?V0NtdlFLQWJvS2VQajhWUGpiZXlwckZIcDNDNk1DRGw0Z0RkTCtQYkZvS3F0?=
 =?utf-8?B?UndKTFk4aFJGNjcwSytoSiswbzIzbnJoNFM3b3hkRm5XQzBwU2hoRm5FN1Vu?=
 =?utf-8?B?S2wvNWg1ZXd3VDJ3MnZPRDRiWlhYUHBacDVUd2Y3UTVvQVBBNENxT0pObGZy?=
 =?utf-8?B?RloxTWJFVTdCLyt3ODBRRHdkSkNKbitOUFlJVCtpZHh3dWtHL3R2UE54Ykcx?=
 =?utf-8?B?SWF0QzI0ckJkUGlyS3JuVVdKL25kMGFWS0RXYU9MTzNJdW9PT2NjWm45NFp6?=
 =?utf-8?B?bVlycktCQk9rN2hGdXpUM0xVSFVsd0tnOFl3VGJQbGJFMzdPMU4zNldoak1J?=
 =?utf-8?B?NHRHYnhNZ0hFWmdtNzA1TW4wc0xqamQzZ00wM0JDaGNMQjRhWjAxUXRMQkM3?=
 =?utf-8?B?TWViVWN2aHZmK1RWckl3V3IwOTROOWMxRm5IK1BpSm1oWHJpUnZ1WnBwL29B?=
 =?utf-8?B?U2pZZVNuQmIyenRpZXE5U1Y2SjdFaXNVTGpnS0VqR3UxOHUxV2M5TzZVc1RR?=
 =?utf-8?B?WmhML3VCTFgwclNsQ3dZZUZkZHlsalJQT1YrbFpjVldsTGhMeVBKQXF0WEhr?=
 =?utf-8?B?bHJNV1FFb1RjYm5nNk1HN3hPbzRJYjU1YThtZkpia0xLYU11dzlESEZWalJq?=
 =?utf-8?B?d1FySDZxS2pZYk4wcEwyVHlhTkc2enhLUkdKVUoxL2s4QlRtNm10UzZSQmlK?=
 =?utf-8?B?SGp3c3o1MDFsc1IyejRoU2FRVm51UjZhYlRTQT09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(1800799024)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2025 07:24:12.5176
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 46c0392b-cada-49e4-f3b2-08ddb3b948a2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF00000203.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6052

On Tue, 24 Jun 2025 13:29:03 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.95 release.
> There are 288 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 26 Jun 2025 12:13:28 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.95-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.6:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    120 tests:	120 pass, 0 fail

Linux version:	6.6.95-rc2-g33e06c71265b
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
