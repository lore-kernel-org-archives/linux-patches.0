Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2061.outbound.protection.outlook.com [40.107.100.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDAA11E516
	for <patches@lists.linux.dev>; Thu, 16 May 2024 12:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715862679; cv=fail; b=dKMCr7CwM83UK4zeU/AmtGQiiBHmavkPNHTbSH/rzDyvMzBvaOnPe4uUwBoSEmE99LynLqXfxPwUhYZm9MvRkfV6ZjZxovTL6oOf5dX19vG3igxdq5KnbPhhdeuzDkq+fEz/7Wnkz7MQeP/+eNFyDgKfiF1QT9yyrHV/QyOQGXE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715862679; c=relaxed/simple;
	bh=FCTj9xTN4M7H56MyqJncOPH02zs683hFjKyKE2auHes=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=dxfCRari7KQ7QFSQLlIc434Iji5iS8KksebamwZf/BgnpkHAfxI/1DBcC3rgYsrZjfTOpAJxSPKrKRcBu2SrICdG42WF9eyTHTE9OGvN/xBVGzEAZt2NNkXpDjfzzxWJzQjbKQ+bBp7FRZa0IpyicL4J/ICOR+CCA8ne6rp83nw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WVH4qF56; arc=fail smtp.client-ip=40.107.100.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WVH4qF56"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nyedGoQIFlelbayyvrBmNEmOKX9ayWiobelrLD8e9F0gkFvIHOL0PZNUpNbb/64sff9R6pah7u5N4V75pE7q/fJI7rMDXImnNuNDo+lwQZii0GKbpDrPIQf67YXbqVWUfJvPXfu44kbwdOUNEC3tNxB3zecJSF0MTUq8MD9dXTt/t4cDDsIF+YKfgKpPgaJD+96xgwjSf09Y3utvU7jG6xksOphAeJV5jh8w0mhymQWGC/cO6dx0V8B4G+ZIH5o+AgOqJKyCl/pdDhmOdPhv5JLQSG0+vq9XA6lvTaQpA9eR4HSO9Yb2GPM+UjDfaWhIZQUlzcQYTKQEguI+qV120Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FDdY+eiLXtX4h37A6o2ckvZSTyRZG1sn9nbwSswp8KU=;
 b=nTltfO0YLk3xxBmBACuWD6Rl/zKdfgIqVurmIXspXewiYr41PPZ25Xx7payvpYEZCTEjNilUT1zgU3x4ktguZNxGGHvml2Bj+tYbm2Ceth3Ps0TQRnxH7oJba5bE1zEB4wJ9s2Ri9IKkRUTg/OL8vznKVLWNhn0wLX6YCvZ3P7HreDLp2VuiY4J+b1OuJRtzCqq3As9pA5tocjnCb7oI+2nC13LgP1RGyM7gsvJ8NRfrHlc6ZD6JxF9LfJfLoelz6EXd95XdjAS0sTOyrgwFIGOHkLA5jUrp7H6eoFEN1/Qdj2DgeKwp7Wnee7MenXIyHqMRi/9yBl7rfsk4rdbpjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FDdY+eiLXtX4h37A6o2ckvZSTyRZG1sn9nbwSswp8KU=;
 b=WVH4qF56Wrvj9EhiRXIAkjWugg4pOPT3yNNcOY6GX2W78fXeHBsohV1NTGu5iSYbBIIQPxdIDMcIPOj3yiIqRIzSZ1sbrhZNSuae0LDAvkOAkahsoFl2zuMdqE3eGX+vO2wmHwVGyMNr+WRU1o/+5GKmHdHmGUF8FT7p9pyJrquABrabf8RPzLvj9gsoZ3XyDx2y/EdXwGlTDwHyjGXdsIlOSlGi7V9O9/dlc+trMM+gVPLzEDLudaFRtndUaw1k0r4i8yu9W5ZmqPv6J8zsTovso6Oak2FSAf3pH+6dOhNHIC4DD/xcdOL/BQUnj+30C8eyGNtnK/OYDCx9xDL1eA==
Received: from PH7PR13CA0016.namprd13.prod.outlook.com (2603:10b6:510:174::9)
 by MN2PR12MB4208.namprd12.prod.outlook.com (2603:10b6:208:1d0::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.29; Thu, 16 May
 2024 12:31:14 +0000
Received: from MWH0EPF000A672E.namprd04.prod.outlook.com
 (2603:10b6:510:174:cafe::62) by PH7PR13CA0016.outlook.office365.com
 (2603:10b6:510:174::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.11 via Frontend
 Transport; Thu, 16 May 2024 12:31:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MWH0EPF000A672E.mail.protection.outlook.com (10.167.249.20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7587.21 via Frontend Transport; Thu, 16 May 2024 12:31:13 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 16 May
 2024 05:30:49 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 16 May
 2024 05:30:49 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Thu, 16 May 2024 05:30:48 -0700
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
Subject: Re: [PATCH 5.4 00/84] 5.4.276-rc1 review
In-Reply-To: <20240514100951.686412426@linuxfoundation.org>
References: <20240514100951.686412426@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <4f2b0b8d-4e81-45b4-85fb-254e1c9cfd95@rnnvmail202.nvidia.com>
Date: Thu, 16 May 2024 05:30:48 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000A672E:EE_|MN2PR12MB4208:EE_
X-MS-Office365-Filtering-Correlation-Id: 0899d83b-6167-4c98-ad7f-08dc75a41318
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|82310400017|1800799015|7416005|376005|36860700004;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bk1MWXFPU25tU21kYlN0cVdNNkVJSjVmZ0NpbDluVFV4VkRsTmZXVXlNQ2ha?=
 =?utf-8?B?Tjk4QlFoT24yamZVblAzUGJHWlJFNzZSV1Z6UTZGdWhvL1pFWVFUSm1pODd6?=
 =?utf-8?B?d2oxS0w4SCt5Q09jcnI4bEgzOGNvbFFWMWtGQmhoaUZIVkdkV0FYZ1kyVktM?=
 =?utf-8?B?cVNUd1U3MCtDRk8yeG9iVk5qUHUveUdtZUNHQzRrSnlOb1JudlZxczl1R0tC?=
 =?utf-8?B?T0M2dkROR3hrR0o1Ylhvc0pZK2Z1SUpMZ215VFVjY2cybGZCWVpsMm8reWtO?=
 =?utf-8?B?S00rUUIyNlRoN2p0SmI3Q2svYTgxT2x4TW93ejhoeXBIbGRNYVd6dXU0OUJK?=
 =?utf-8?B?MzhTWWhCcDZzamRUZzZEdHo0S3dXSi9ic01oT0wxekpWdDdqVUhpL2tIM3g1?=
 =?utf-8?B?ODFlSk5uZlZZOEF5TmpJR3B3RWkzbnovcCtSUFU5dXZGdC9rVk5kd0V2YkJw?=
 =?utf-8?B?SkY4OEt0RmpQMEhJRHVzeG0wWjliemMvK04wa0lmSGR2Sk9YUFhtM2M1NE1Y?=
 =?utf-8?B?czhBOXkxRXZOZWZvTjZvY2JoTDh4RlF5c01xZFJOUkczQ0hXam4zZmxpSy9z?=
 =?utf-8?B?T0d2STl2dTltWWpTV3lSTTRvQ0JMZDlUekRkdWJrNW13ekdxMENKUFlWMU5P?=
 =?utf-8?B?MGl0RzNnSitmeXBocDl3ZGgxZkhLdEJtMklGajhLdklQcHZkdGNaQU5JTkNm?=
 =?utf-8?B?d1o2RytqNmVXbUlvc2pnV0pnUk5Bd2s0ZTJFUVgxR3FQQ1JDbXRJbXpUNUJ6?=
 =?utf-8?B?bjg0Y1dBMkJudTRKVXZjUVBqejNSQmxHQXdIVm9TMkFCZFkrbXJ3RjhKZ2pJ?=
 =?utf-8?B?S2g1NC9meHU3UmdibUVXdmNGTWtZYU9ybHMvcUFyWWJnazRycy9DZ0JQK2Fa?=
 =?utf-8?B?dW9qQXFnZkh2TTBsOXVFdnlGcURYWTFPbTFKaGZqeVJ2emxyQk92UmhkUC9N?=
 =?utf-8?B?SXpEYjZValB5U0xiY2Mrd1lRMmVaYm5hbStVWFVWTTlOaDIvT29XeXRzUXRK?=
 =?utf-8?B?QThLbTcyV29QaE5MbGlNVjBaQzJqQm9ONDQvWXdEZ0FraVZFM2lZSXlsU1BS?=
 =?utf-8?B?T0Q3bDFCeW1mWXU0VXRzNEFoOTJPbDhOQy9kT3haUmFIanVpdTFXMTBzNnlG?=
 =?utf-8?B?QWp2ZHdsTEE5MmxGZStwQWd3QnF4N0NVWGNod2VQV2JiektVQVhNbGozU24r?=
 =?utf-8?B?T1JNNnNhTGFjVjFMQ0ZOK1U1WXBSaFpmaW9Gb25kMStEdktpaDFBZXV6MkNP?=
 =?utf-8?B?K0IxOTFwQTl5VmI3MitTNWlFWEU2ZFhrbDJhTFJxeTR1SFdrZjR0ak9UWjBU?=
 =?utf-8?B?WEpIc0JrN285SFM5YzYvUTlDbE9INEJyenA3bnhyM3ZOM3huTmNpN2paYnpu?=
 =?utf-8?B?bzhMSjk3eTdhb3Rydzd3aElkNS9RV2U2N250LzcraEVTTXQ4Tkh0UTBaMjlT?=
 =?utf-8?B?dmFTOFE4WEFEVWdURHRSZzVwT3FJd3d5VGo4QTVxUVlGL2NFRzYyV2VoTEtK?=
 =?utf-8?B?U0ZhT01EUytOT05wZEVFaTQyc0RkZDFydzFsUTZqd3oveTJwZVdSTW9QVitC?=
 =?utf-8?B?eGFVUmhySjJ5TExBaWVLMHRwcUFUYmNtS1h1SWlVZHA0TzBudGVXQ0R5dHJM?=
 =?utf-8?B?L3V5ZVdGekt1U211SHJxbFQwMU90UzBSbUZxdWdocEVPNHRLUEltcEQrMnNW?=
 =?utf-8?B?V29yVGdQdEtnTmd0VjRIZkZuTHFsMmlxclY0N0ZzMTdSdmpCS2tYdWxyWFB4?=
 =?utf-8?B?WDc2SFJ2bzB0cFl1eXdlTHMvQk8yRVgrSHo2aHpYK1Vtelp2UVVIcDBoNWRx?=
 =?utf-8?B?OHJaa0x4eW1vOCtYMlFJY015enVmUGp2UkZ2a29BU3ArRzV1TEVnaDN5MWoz?=
 =?utf-8?Q?iybJ5TSMGIRcf?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(82310400017)(1800799015)(7416005)(376005)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2024 12:31:13.3675
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0899d83b-6167-4c98-ad7f-08dc75a41318
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A672E.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4208

On Tue, 14 May 2024 12:19:11 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.276 release.
> There are 84 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 16 May 2024 10:09:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.276-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    10 builds:	10 pass, 0 fail
    24 boots:	24 pass, 0 fail
    54 tests:	54 pass, 0 fail

Linux version:	5.4.276-rc1-gea8a1bc66159
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
