Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2060.outbound.protection.outlook.com [40.107.100.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4555E138490
	for <patches@lists.linux.dev>; Thu, 18 Jul 2024 09:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721296357; cv=fail; b=l2pgwme1mvGLraEcQ1423Olms1P0Rljty1Azn57LtHgYMpW+dGYA9r1eLFmeBSBzMZCAnG/DEbNQB/A38ECsfBZB/2R16fu9CLlxD4fBA8nB2tjhs1jMM2lAyocYEjdM8XwN6NeYPa6U8VoW5rfy50L5F1yqdd/4NHB3VWN19JE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721296357; c=relaxed/simple;
	bh=udaNN+4MPswiv7eqWZRG2xU/5TeH/hB1nB3lz5OQ7NU=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=Bt8vKaBkEgEMZqZB7h3XkpxRxmiUaeddOj8tbNGREbepsXAgLKxf5wcBuJrFqBYbEvq4CKz50Fn210tPWia6WzVpD5Y45xcs3QAKxOCkAibCKDta6fefYsMEh1+6wIn+TE2MwUI/OZxaM3vRbFYzPIPTxEyPYGyeYR6jEulVu/w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=YQRGUJ6U; arc=fail smtp.client-ip=40.107.100.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YQRGUJ6U"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y4B9u1Zgaqip1PDPOBikVxTjKRE5MWt2GHuFy+ywHNHWN22Mgz/odQxg8zdLYZBoXBHKWZrI34lXY25aMD1g+OwNHKDsC6abbkdzjFl0ZdBbPa++/92kDKKkX3OYQssD/UnYQrU4+vTOOHp9Sbhqom1gQIRb56Om/dj4u41lCsMyowF0jjDFpuFVlF9k2REmY8qLOKUgsSuLf8RGxoQt6Qo3jBpccJnC4Ug6NI4sLexIxOuFH9dmWKQ4FjUbVL1Dq8+QxE7sLLW4kYQwNbNpp2H1rYgOV85v99iTuHvVocHr8viEj6bxr6VLKpmz/CQhWwAN9YFd1HMTrjngacNe4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NjjZjWiW+imRVXZVBCUeZ7Em7LS5ZhFXVXr6Hw06DcE=;
 b=oXVATkgH3mbwcRzKTN2ihEvSRoUh89cPj0MrHI4nsFQw4OYQ2uvjvjVcrB0baTilnZPb7rdzk5wI8SR5jYWstKPHDcCVWzhk+EUmwBsb083Hb6mifFTIrONX46e/4tprp13BaX37hMWcYQW8FvXHVDvZib0+0ScaF/pmty1mQ6arJYHh+5YL7E9UPL6hGT9KD2neqwnBC26uKaQ+QV9nC2o1sN3DAU/dqr0N6xSx1KtqAO3ZF+Qs5CUOLvL3E9ce7mKxOB8aK/0KO7RnlcwYqWfNA0KDMpQRBuFnRzjJLYxRvGcmZVmDo4zPAnaFyhj962s+FAiJ/Ltpw4vlWyjvkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NjjZjWiW+imRVXZVBCUeZ7Em7LS5ZhFXVXr6Hw06DcE=;
 b=YQRGUJ6UiBgnXc4alM5/UCYOULmeJ0nroSW/gks8D+7S5hE+//eOdi+3av2xY5R/C3RCXyyQCw2U+r1n5IrRQh+Bld6xcb/vAh6dRyD5753blkbZUGflDLtNqts4JwP1aU7qo6EkR7q2MxUg/R8WGiBlFnh7irRZVSDZyA7ScJIDp6BcHxmjUaQWBfbXnlQrSKR4H8ZoJ7JNQ8NQ0AgeWMcUNlrO2KxfbTeEo3bVIHruqpeNhxfFmyqE4es/9fWk0Ax7ykzkNq/P9LUvwfFFCDI+SY4nJZP7dzEK+jC51RaZcFn7Jlg0aX06Tp4NYRP5lUEIg/pDRfJ8QtFi6Ex/YA==
Received: from MN2PR12CA0030.namprd12.prod.outlook.com (2603:10b6:208:a8::43)
 by DS0PR12MB7927.namprd12.prod.outlook.com (2603:10b6:8:147::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.16; Thu, 18 Jul
 2024 09:52:32 +0000
Received: from BN3PEPF0000B071.namprd04.prod.outlook.com
 (2603:10b6:208:a8:cafe::78) by MN2PR12CA0030.outlook.office365.com
 (2603:10b6:208:a8::43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.29 via Frontend
 Transport; Thu, 18 Jul 2024 09:52:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN3PEPF0000B071.mail.protection.outlook.com (10.167.243.116) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7784.11 via Frontend Transport; Thu, 18 Jul 2024 09:52:31 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 18 Jul
 2024 02:52:16 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 18 Jul
 2024 02:52:16 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Thu, 18 Jul 2024 02:52:15 -0700
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
Subject: Re: [PATCH 6.1 00/95] 6.1.100-rc2 review
In-Reply-To: <20240717063758.086668888@linuxfoundation.org>
References: <20240717063758.086668888@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <3c3e800a-aa51-45be-ae0c-6f114a278706@rnnvmail201.nvidia.com>
Date: Thu, 18 Jul 2024 02:52:15 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B071:EE_|DS0PR12MB7927:EE_
X-MS-Office365-Filtering-Correlation-Id: 29ceb63a-9f26-4405-f954-08dca70f57af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eWRwVHc5WmZPTS9zeHFKKzNUSUtYMmtlQzJkY1NYN0wwbUd0WVF5ZDdrdzdj?=
 =?utf-8?B?akFGejZyM3g3L1UxNzlncGtmbjByNXM0UlUwWExZZVZOV2pBck5kU21Tc3lJ?=
 =?utf-8?B?ZFhpWGFGaVp4S3JkWXJ5SmhKaXJWZjB6RmlPUHZKUVdQRXNhcWZodUJzcmox?=
 =?utf-8?B?cjZ1SGZ0M1JTTGNPdGplelZZaGNrbkFSbStLWEpEd1hUZFpYMDcybWhsSktp?=
 =?utf-8?B?T1FYL0lhMTBEVy8rM3czK01Mc01GNldSKzdOZVFrL1d2SmdDRHY4TlByOE92?=
 =?utf-8?B?UWhYWTRhOTdFcDNxbjlob3dPS2ttZ2FBQVA2UmVwRXRLdWd0SnNjRlYweDRv?=
 =?utf-8?B?TXJLalZqOExVeDdBQjhEbE1kdlJZNUF4U1RBV213MlVuQklXaTQza0J6MXJK?=
 =?utf-8?B?Tndka1kxejVWeVZZekdvNExvQURHZ0VHSU1ZZUM4QlNFTjdiZnZlSGNSTnNk?=
 =?utf-8?B?UEdOUTdQVllSVnNRQU1GQnhKWFQ5SVVCTFl3bWxkRERqa2tHSmtEM3N2NkIr?=
 =?utf-8?B?Z041QWFKWmR6Z0NIM0ZnMkt5R29sVHRPclF4SS9hMWV1c2tOemhPMER2aHJD?=
 =?utf-8?B?cTdodVpuL0ZlY2JZdEhkakVwbkhnaDJML1JDNnlUZm5pdEg5YkdrakNtb1hn?=
 =?utf-8?B?UERiZGFHdUdkR3NqeVNhZHJjY1ZDS2JjRTJxWEJ6SXY3aTRFMjIyK09sU0tU?=
 =?utf-8?B?cERxL0FNS1ZrVU43WnBFeEpOSklGWjY5WlZ5VVEzdGZBQk9SQ1ZMQjMzY3gz?=
 =?utf-8?B?OWJXMVRCMHByZytSa1ZBbzhDNGZua3UyOW42OWhjOVFESlNNRFVSbVhRTEJB?=
 =?utf-8?B?VUZhNmlaalZTem5SN0haTXpNWUlFV0pOenI5RDIzaWRDWWJSeUR0UEtxVkZ0?=
 =?utf-8?B?NHlyOVVacW5TM2x0TDBlaUZ5eFNyNjh1YVVHM2lqZjhsOG5PV1RaQ3RmZ3ZX?=
 =?utf-8?B?bkR0Z3lIVkVhdnRENTlSYWtHMDZZeXBGWDV3eFBuaU1hTTVqSStKcEFQWkpK?=
 =?utf-8?B?aXNCTVRhUFh2SUhBQ3pVeHhpN2tGRnBCWjBsc1VwZ0dvZ0NFcGlMZDJaVkNr?=
 =?utf-8?B?dEVOZXlrMmM5MExKVFhpeXBvMnAyVVdtZkNENzF0SVhlcVZheGFVcGNQNndE?=
 =?utf-8?B?TExycFk5UVE4YTMxeTQyTGUwY2NRVzlwUyttUXczSVhEajZWZUVxMW4wNlJO?=
 =?utf-8?B?dU1sbXVEaWFYQVZYM3VWV21MaElKVUsxdEJWSXpOMFJ4RGVSZGZzK0dpQm03?=
 =?utf-8?B?RW5oQUVPSGpMb3d3M3M3ZGthNG9mdEtqUmhVUVc1Y3JjeGs3TnE1aWZPcTJr?=
 =?utf-8?B?eStmQ3M4VjIxVENxcTZNa3M3WmNhNzVWRDRxVEVqVi9Da3h3RXJ6dWcrejlQ?=
 =?utf-8?B?d1R5TnpKZFl6M0t3T1pwNDJFZ0Fnd0xROWJWUm40MmNyY0RMbEpmQm5xTWky?=
 =?utf-8?B?QnlWeUZrRlJJa2VCdVA1K2lFV2ZzdmJlSDBTTURRbmh1RHlyOXREUVdEeHBH?=
 =?utf-8?B?d0g2aklMb0pZRVpZTnpaeFRrRFQ0ZXFEQ3BwRHV0UUg4OUtvZGtJNkU5c1hk?=
 =?utf-8?B?azl0dW1YakRuOStnY3Y3MFJOVjlFcmZSbnAvOGpKVURCMkpBc0QvR1hZK2FF?=
 =?utf-8?B?QnllZk42Q2huc2E2Y3FVSi9DcjJHU2k0a1hlWnpseStWTG5wdHZ2UUp5NmNL?=
 =?utf-8?B?QjZCdWZqVG1UOStLOU9VYjhuQlZaSHYyd0c2Vzh1Y0NuVXdSWW5VSTBZdjNq?=
 =?utf-8?B?ODVTN0JYTk1ob1lsYjhDY0FGQi9vMkphYSs2NHV0eE5vQjZjSnJoaWYrQ3hj?=
 =?utf-8?B?V0gycTgrZmZqNlVjNFNDZnVpR3RvQ3RLbExiTmRhUTVFazhiQnJNakg2VDZr?=
 =?utf-8?B?U2IwM1JTTlZVS2JFTXRzYWZ1Q3NpSm9tZEI3QzRLeHk4OTN1dVFmUFhlZXhm?=
 =?utf-8?Q?O7x34i9GpVJjVd4jBo6LhPVRYcYerzhx?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2024 09:52:31.5235
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 29ceb63a-9f26-4405-f954-08dca70f57af
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B071.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7927

On Wed, 17 Jul 2024 08:39:41 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.100 release.
> There are 95 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 19 Jul 2024 06:37:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.100-rc2.gz
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

Linux version:	6.1.100-rc2-gc434647e253a
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
