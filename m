Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2089.outbound.protection.outlook.com [40.107.93.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 415E52638AC
	for <patches@lists.linux.dev>; Tue, 11 Mar 2025 18:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741716738; cv=fail; b=EpQiLKJDUzWXe98lYuXU6eqaYyiR7xnof5lNF4xAW75EUjzqC1WdT5VP0yqgJHMPBkbx+xPFePK81AFbjwfnqKlJ4GndYy9ZFVyUJ9bRsWkFVbvzC9f6s4GkPR4E7h4k0wTokwHjf0CVO/wTbrSjaUBFCUms7zeOaK6efhsJJD8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741716738; c=relaxed/simple;
	bh=wPnNsjfnA3TKbRve3N21AlDid/lwvRTVyIGuW1qFnBw=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=LQX01ovejDCDxrS0WdnyrrY+r+yxsM9FxeC6aQvlTCi8ULkIOoW2c+wCubGkq7v7N5b+AU2djw8wshoKHdUMhMlrCygnlrZeoiBt2oLjYiLujEHqlYJciCxinfGEdas3mOhSeYQCXwiCBx7zR6psjs/fiWUMDXUcKzTqaXs5Bz4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=XIPOdlwU; arc=fail smtp.client-ip=40.107.93.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="XIPOdlwU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kFSTqIixp4XXWVmHJH6ZKNejfTrIfdguaHk2DqmRDtcmKUxARNsaY/qb4oGvXWO7cXJmOPlORRaju0WyKePQm36i5zLhWKUYtqCo2MisxnHEkwcKRusCf7XwdapBRxV741GlbPXHcRzYidKxOXWVJ74F2IISu4AEsClCH9UH+SnOp0ToKpD7jrzdQNDwLxq5LQViKBfKdy8YhxZ/aX7Uc3cL1wTDTwXOkJDQqR6YghGEpinwYqoT0u4FvW1Yc9gIwAynurGm4gcPOh9GtWOS2Gztf47eCRsqXy2TOto01WOofU8ENWmXsxHZgrxMsREvpPra8aoOOlA+E4YV0+JQGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F7dlEtLV60dAY6s4ReonD+zoQFAnIXLJ+DWV7QMo10Q=;
 b=sNqbjQP49MaUU+f6Pughk9fccsZ19nH9So6tniQwBHmDpS+ShtIEf8Y0KQPOtYSKGIAv/UQtMiuiEiboJKss3CkcYh8z/a5AAtURE12rNvnM7YRbzTFOxu+rZ107LrvexYF9jv9aesh9Msl97n8X1UnYPppLEpMvG4wBcnMuHSEwo3QZy5CsQmdRihyTEqz3f2bACwkS9J+FrAc78u/msbikt3UclGlMxVIgLCJ+8X02n3ln/1QEKt/NeeYv5Wggss1HvFbnJR8nTVe+kdyi3nJar6d40u6afdkbLO4QtuXCgg2xK+5c21bE2T7pVeOcpRxULZO0C6YSE1juQ+KJfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F7dlEtLV60dAY6s4ReonD+zoQFAnIXLJ+DWV7QMo10Q=;
 b=XIPOdlwUBOwIeqauDGhAQWg+b2gN6ckkTGx0FrG607NREK2ZeJjP5fquh428PBTblL6YXlyqRMnJuPRJ+T2UaTVcOtF9LsK0otJe3KIMcX/bhXHA87Kd027n5pIjUeaViS6EqhOTZkzm3ZxB21gVSHeZf9jLMY7dX33AHBWGpJ7gS3d9OisxHcMjAF0fm4w4C3XReeCU5jNhqTooQaZJcxKUIzw+sdJt1cP5I2yScXnO3li33gNfM9XCLoVgHPoBQVdrXUsHLlCGFNEfQEXgGlHTdv95Rn+HDkcZ5JidlTYK6K8ED+gV/n9P8E7uoHx72B5w5ij050Z/b6fd1Sgz3w==
Received: from DM6PR11CA0041.namprd11.prod.outlook.com (2603:10b6:5:14c::18)
 by DS0PR12MB7701.namprd12.prod.outlook.com (2603:10b6:8:133::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.27; Tue, 11 Mar
 2025 18:12:08 +0000
Received: from DS2PEPF00003445.namprd04.prod.outlook.com
 (2603:10b6:5:14c:cafe::7b) by DM6PR11CA0041.outlook.office365.com
 (2603:10b6:5:14c::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8511.27 via Frontend Transport; Tue,
 11 Mar 2025 18:12:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DS2PEPF00003445.mail.protection.outlook.com (10.167.17.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8534.20 via Frontend Transport; Tue, 11 Mar 2025 18:12:07 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 11 Mar
 2025 11:11:58 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 11 Mar 2025 11:11:58 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Tue, 11 Mar 2025 11:11:58 -0700
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
Subject: Re: [PATCH 6.6 000/144] 6.6.83-rc2 review
In-Reply-To: <20250311135648.989667520@linuxfoundation.org>
References: <20250311135648.989667520@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <63a8f61a-210b-4549-a767-f806d919cfd8@drhqmail203.nvidia.com>
Date: Tue, 11 Mar 2025 11:11:58 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF00003445:EE_|DS0PR12MB7701:EE_
X-MS-Office365-Filtering-Correlation-Id: dbc1df50-b341-4eb7-3c35-08dd60c83bf2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|36860700013|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WDl0RU16a3FyOGxvWE1jQ0pOUDAwNnUwdE42eFhMbDViYjM4Y1I3MkloUlJa?=
 =?utf-8?B?KzN5NkkrRUNmY1A4dENVZS94MXR6YWF5bG1FTEIrT044dzhyK0tyeE13ODFa?=
 =?utf-8?B?SDBtbTJoUEZYeVArZDMyUmhTcy9rVjk3clNBTlIxb0Y4NDMrOXdlY2M5djE1?=
 =?utf-8?B?RUFIR2tsWjFGVmNDK2lRdURLMnVWSVUxUjFQZnkwWHZaT0FTZVZzVGhWYTZ4?=
 =?utf-8?B?NCtDQXRIeXl3VU9pakZyVjVrSlJiQjgvZU0zam8rQmdFQjN2WE16U0plamQy?=
 =?utf-8?B?ZDJuc0JvOFU5cnA4OTR1RkllUU5Ea0x3QVFuS1k2emdUU2hrMVA0bzYvV2JH?=
 =?utf-8?B?UUxDN002RW5PdVkxNGpmcm4zOXhpeVZ5bnFTOE9MNEg0Z3JiN0pQYWl2b2ds?=
 =?utf-8?B?TmphazQ1NHRHN3FOUS83OE9VWm9JWXlTSFZjVC9DK3JISVZZaEIvaE51OWlC?=
 =?utf-8?B?V0JxcEZhZUZrdWdSN25ZUG82SFNLcmp6TzNOcnZEUW54MGdRUmpLYUxyZ0tR?=
 =?utf-8?B?SHJhbUxLUzFsRTVZMjRpOHBrVGlNM0VpWmVmTGIyaHZPZGJTUDBZak0rZnFZ?=
 =?utf-8?B?U0xjSXJaeGo2WUxyZ2p4dU1pTjNBSjJkdTFuc1dFSFBya2Yrbkh6R0hRWFZk?=
 =?utf-8?B?eEJBVTBaKysxZ0VEU01aeXQ5RVp5RzF1aVZaMTVWN0FWdHNscmo1bzRhS1RI?=
 =?utf-8?B?MnM3dEFsMWJna2k3YjNYOU9TY0ZZWXJ0Z01NU2NJbml3SS9qZ3ZsVDZuUFRP?=
 =?utf-8?B?RlZHTHhQdzJuS3M3Tzg0dDUyM2VoakMwRzY5SHhFc01CY1M4NnA2MDZHWUJs?=
 =?utf-8?B?ZXkrdi85ZlZSSjArNGVsZnQ1MllPVFdBSkZQWVRicncrbDE5blQ0cGVGeGNU?=
 =?utf-8?B?MVRVbEdRbzJWNG4vT2NXY3BsZC9YWjk3R2xGVm4reldiSVRwcW84K09EY0gr?=
 =?utf-8?B?eW54Rmh1QUtrVVRsaGR4TnJzTEJ3VGRaaEIwL1FKa2dmYW5xSGVZRlp3UTUw?=
 =?utf-8?B?VVJLMWRmNTNyQ0Zuc1lkV014SVQxenp1cSt3U1dxaTgyKzRFdkx2R3ZrLzhk?=
 =?utf-8?B?VEN3RkVQVDg4OXNmU2kvd2R2UUcxUWxwVkxjOWFaRTZTVmVyd0Z5ejkwNEZ5?=
 =?utf-8?B?UGIzUFdrR3BmMFVxTHV5aDJoWVJPWFNUSTlNa1g3TDZPaXdLcUFpUzNDQ2l3?=
 =?utf-8?B?ajJEWExQNXUxMTUwY2NDMmhBRDM0ZlhESUdva1VWV1JBWU5mWW45VlFpNUpH?=
 =?utf-8?B?bEZYSTd6MzBZSTlqMWdBbjE2SEdRMHl3clRzSjlWMVl4aUlzMDZUNU51c2Vw?=
 =?utf-8?B?RnhTMVpXQ2JWSjFHVkdyMXEwcW1kV2pHZHJqdGRHUEVwU0M5Uy9Qelc5QmFL?=
 =?utf-8?B?NWY5aU1HV0ZPT0ZyTnJZaGc0eWVaT3liRjV4bFgzUXpjRTdYa0VpQXg4dnUz?=
 =?utf-8?B?VHNKeE1Tbm1zOGxXOHFKNVR6OXhoQ3hkL3BmODE3ZnY4ZXplejhSY0EvdUxa?=
 =?utf-8?B?eUk4czNoRVYyWDNKdHZMSEN0RSt4LzQrMGRLK0N2MjdGTFNYZ1FodG5BWGFG?=
 =?utf-8?B?L1JCc2pveVVTSnJnamRFTEVpeDBxVmt0R21vMEZYMTJ6dkt2QkxxaURxVWpZ?=
 =?utf-8?B?dXhUaTlwNlkvczBhKzBYcWFnT3RtYUZtc0taVDd5aHN0M21kcDkrbHR0aDRE?=
 =?utf-8?B?WlgrSXZOTWorV2FBTlZPNVYxNGYxTFNYSVZoNm50Q3c5ZHgvSm1HRkJ6RVB3?=
 =?utf-8?B?S3hWbU5rRmt6TmJnUi9sUHJzNWhmT1RJZktrYmYvb3ZmcXNBTUFPbkRVVisr?=
 =?utf-8?B?Yzkzc0ZWVFE2Sk1TVUhkTCtsVmJXY1RZRVB2U2JjU0NINGtMK2Y0elJSMTZm?=
 =?utf-8?B?dzk3QzJ3S0RPZ3A0YmdNUW03VHEybWM1TWRvOUw3S21Oek54NkJwZk5PZy9F?=
 =?utf-8?B?aU9QREFqNlR5NkRRczhxOGM2djFIWTVudnJpcHloc2JBYy80MTdGc0NqT20w?=
 =?utf-8?Q?6GfwZc5+BOKP5/vJtfLiIURjh7ahXU=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(36860700013)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2025 18:12:07.0528
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dbc1df50-b341-4eb7-3c35-08dd60c83bf2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF00003445.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7701

On Tue, 11 Mar 2025 15:02:03 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.83 release.
> There are 144 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 13 Mar 2025 13:56:12 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.83-rc2.gz
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
    116 tests:	116 pass, 0 fail

Linux version:	6.6.83-rc2-ge7347110295b
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
