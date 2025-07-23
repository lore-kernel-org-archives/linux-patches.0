Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2085.outbound.protection.outlook.com [40.107.243.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B612230268
	for <patches@lists.linux.dev>; Wed, 23 Jul 2025 11:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753270559; cv=fail; b=QoOa7DA66DRIKHWR8Bi7NUvBgBRJRFxP6KQSg8QVOOMmBgpLr0ueTW+dmiFkhFOIai4q1Why7Doj9/EKQBZ/JrFWWbeQQ/gcigr5q+cuxCq8Fr4RSkBIJGdFeSw6hmgSH3f2pruq/uCE/Hw5KLZaAfzhL5TiGUxbgy1+rjFebb8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753270559; c=relaxed/simple;
	bh=qT/gRDGfa/fQxXgfhAxQYmXN7vwGa3xmJGaDqPTwRJ0=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=cEuLfWnUn6lEEFEbeW8p/ci238anmJSIvjb9JHyz+RLGi2BVXdG5bgbEecxP/iNMnIl1WLADIz0q8GW/4gghW+FJy72RFbsCN8iaYk0eiu7iXYHuAekAcIZB7YZUBOqPvFZo0W3QlOd5LVXO/4YZKH1jP8V0+7mT62RaNJcffVM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=cA5PBwWp; arc=fail smtp.client-ip=40.107.243.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="cA5PBwWp"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n9d83Bd1yOD2M93kETRc7xSxhcNkWYhML7BbknXUDf7uL6O+Pgqm/n09JEN2D1RBZWTPx9mWGGQ1L5XUjV9gcGbfee5MDz3MoOf34WGP/wLxuTKzq4D5kWIW4Q/7Kj6NmddnmbWHZTCekhCOUF+tFHu/j0T9sA8H6nieN4TlqMk7WY3Xff3Sxy8pXp68JDPOtU4hpP+QJIOqZuW337/qFC4BjePFjAOOF1gkmSqbPAO/aLezsLw3Yyu2f/HvUGGp2h2NGhnNdpjIe0h4hNdkHyGp9aYN1sgdhja+0w66crMskS64LHRI8Yeob5RJFbYnPfqhcPiTtf2tGsKtAZ6uhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ajo6JIQPFqrYIo2IDu1jSzlla4mjlOWcN4M7fWLHW90=;
 b=sTk1cS7XvBwQ9dANYCgyMJgbRf1/iXs0tGxw2B5amPTwrXNs5o2Xi6THzilSszwVjzdybcWmklJtu0+at6/1lLPM78hr6+TCi8/pL4HbDfLxvp9s0LqaCtl5fTwWPZGxpU1RMwKw7cn+wKBjjI97tVoDokFuxzR4FuL6J1h8/3aITiIu7L6KF5+BchFxnFnUDhz/MX1n3UBX3SCE7d65QqFuJBRVwU9duu/NRzQbzsPBWApRnHepjXhMZ4LR2pRy6Wz2yYUcOyTjB0WH9csJB+k2AytAE7ha3pwGsZtVuoI2ilRWKOIyaySmoZZoX/8noBhuQE0JX9UL1oSx5rGa9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ajo6JIQPFqrYIo2IDu1jSzlla4mjlOWcN4M7fWLHW90=;
 b=cA5PBwWpDozNK9EVL76n+uGmuWslc3msc8Q2rcK6oKMTxzXlDYZrkeFMBiqbwLMw3lEY0RN+r1DLH0fSeP9MGGSNINCbjifx9Wb1NdSKLg9d7gwUI/Wlw9pOPwhWIPwC0XABI4GLTpvcHSSTI67vxQSe6hCLLMOHtxN+VoRizcffzUfnmZfXpcyhEGUn90Xtm8xW6yPR4yylnEvJYRvUiDpl167L/TLyMtRMvsl3S7dDlDx6Yqexc/CvI2Je24/SbTUH3Ir3YKN/oozkLciD5/mPboPbecBTd1bRkwcTBXsHIrXQse9T9IKyliKb6HktpTsPWQ1LCWOn9vI7GBY6zA==
Received: from BYAPR05CA0030.namprd05.prod.outlook.com (2603:10b6:a03:c0::43)
 by LV8PR12MB9230.namprd12.prod.outlook.com (2603:10b6:408:186::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.39; Wed, 23 Jul
 2025 11:35:54 +0000
Received: from SJ1PEPF00001CEA.namprd03.prod.outlook.com
 (2603:10b6:a03:c0:cafe::e9) by BYAPR05CA0030.outlook.office365.com
 (2603:10b6:a03:c0::43) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8964.21 via Frontend Transport; Wed,
 23 Jul 2025 11:35:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SJ1PEPF00001CEA.mail.protection.outlook.com (10.167.242.26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8964.20 via Frontend Transport; Wed, 23 Jul 2025 11:35:54 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 23 Jul
 2025 04:34:54 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 23 Jul 2025 04:34:53 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 23 Jul 2025 04:34:53 -0700
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
Subject: Re: [PATCH 6.12 000/158] 6.12.40-rc1 review
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <a4788430-a45b-48c7-aac0-51e2d4dc78b2@drhqmail201.nvidia.com>
Date: Wed, 23 Jul 2025 04:34:53 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CEA:EE_|LV8PR12MB9230:EE_
X-MS-Office365-Filtering-Correlation-Id: e4db08ce-a66d-4a14-17d0-08ddc9dd1581
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NVVKMmtWZTFTaHdER2xISjA1MUtUTXRXK1U4Ukc4cHFrWUFEeXFoSUxCTVBD?=
 =?utf-8?B?YkFkbHpqNlBGYnlGLy92YnpKMklVaUp6M2hrQTVnTzZNVysydGNRQmJ6d0F3?=
 =?utf-8?B?enB6N0lWRG1TYzJEaFM0cHVqSmxIem9PNmwzeEFtU0lCUGE0Mmw3c0oweEhP?=
 =?utf-8?B?OUVOSnM3RFpHNUNKYlgzemxyQnNPS1E3YWhXNlJ0ekZ4eDg3NVR3NHhNcGZa?=
 =?utf-8?B?RmJVNnZPWGRuVkxSOFFqWE9ja05LZXR6cStHSWVSK29BVFl6SXlSTkVyeVN5?=
 =?utf-8?B?NU8xSzYyQW1qaWJRNVhlekFPa1FHcDJKN1pKWktsWkdrWVlOWGxEeVFlcytE?=
 =?utf-8?B?eUdMWTdSYjRQWENEY3NHazI5SGN1VkNXQVdXc1kyRlNFMGY2WUxCMER4Rm1n?=
 =?utf-8?B?WlowZS9QVnBSU3J3LzhqVFFiTlZmdVoxTmZoRnRNSFNGdUpvaUdkWkhST0lv?=
 =?utf-8?B?OWNHL3ZXNjBqaDcwUWkxQjhGQXVEaFMvZXVJN2p2T0cwclRvMER3Uzd1dFFq?=
 =?utf-8?B?MDFzQTNldEJCa2c1SW0rdGpqK1AzZGU5b3FVcWRTb1ZsZXBodjgrcldONFdr?=
 =?utf-8?B?WnVBb0hBSDJDditUSUcwc1F1MjFJZHZKU3I0NEJPc2VZd3lESWkwUHhSVnhK?=
 =?utf-8?B?MWY3S1Q3VkNMcmVLRzRiUHpQaWN0RmpvSzk5Rk1UZk5UUUw4R3NLQ1NueG5X?=
 =?utf-8?B?c2cvMFo0SjNnUzJuaEt5eGxUam1MS2wweXJsNUp6YXNXeGdwcEl2OEpNRUlE?=
 =?utf-8?B?SWJ1Q21KRERXb3BXQUd3SVZvS2dlQnNnbk11bTJMcHFJc3d2dzRlOWNEQURY?=
 =?utf-8?B?K2hLelJHMmsvVHIzYU1FV1RYWmdkZ015TE5lTzBQTzBDTldlVnpSYVJnTWZq?=
 =?utf-8?B?azJkaTZ2WkhPd3B6TzNEOUUzWThWUHFIandXQTB4NXZoa2FnOExvVklPdWlT?=
 =?utf-8?B?bHcyMTlrazVsTDl4UHVVMmNPc245aVNIVnNDUjNtbVYvQTBJa2puZzdSRy9Q?=
 =?utf-8?B?ZEVHdTNtSEp1eGNUekgzemQrQUd3STJxbVVUQWxMK1dDYzgrdDVYZVU0ZUpL?=
 =?utf-8?B?NnZVeFdwZDQ1YVVoYVhydGpDMGtNVk5vU0F4RmlCWHp6YUIyN3J1TEZZYXl5?=
 =?utf-8?B?UmhtOE5hUHB5aGVYU3FvREZhclRQL0xYKzhQNU5YR29vTkg5U0c1UVFieWpN?=
 =?utf-8?B?WHZBSjNJUUsvKy95eWRERDB6ZFJxY2xvVjRjcUk4UGgxOWFtenlRYVNLcWdW?=
 =?utf-8?B?UG5pN0h0Slo4cHpoYXR1cThoUmNYYzh3RDZqdkxnQmFzWGNiREprQ1ExU090?=
 =?utf-8?B?UU5NTlVGKzZiR2xzK3UxS1oyRHB4d1Bqbi9aaWVUK2E3MFJmakw0eGt4MkR0?=
 =?utf-8?B?aGQ0cXBXYTh5YXk1bVBnb0FrNStzWTNtSFlQVDV3dzNla3Baaklna1dtNEdl?=
 =?utf-8?B?TGZLQWdYZHJSQ2FSN3VzMWtzOFN4bmNsOTlrRllZMlROTWsrL1FBakpzMnhp?=
 =?utf-8?B?R0VrSmdGdS9qM29jRDQrdHg1NWQ3WjB5Q2lUOFZqRjlzY2pDWC9UR1VZZEg5?=
 =?utf-8?B?bnBONFlodVNOeERWMlFseUR1OGNlUEpPNVFpTXVudzVkMTNkb3dMT0RnSGM0?=
 =?utf-8?B?c3d1OHRhQUFvNmtZa1NsUGExdlpBVE5ZUGo0czNySVZBUnAydkZwZ2kvRFFa?=
 =?utf-8?B?Qzl3RitIT1YzTEhzVUJ5YUtGdXRFdGF4OGhUMWs3WFVuaDdsdUtkM0xrekcr?=
 =?utf-8?B?Y1VLN2hueE4yOW5aL25xdU44aWxxQjR0dUYvcm1LK0VNNkc2dW5CZjlZSGd6?=
 =?utf-8?B?VmYveG9aTmNFR245NHJFZ21td2s4R2dETjVSSmhMNWIvblZud2VtU1I4d1FD?=
 =?utf-8?B?bW5OelJ4TzBmWDVGOWdTZndlOGpzSG9RdHJrV1RlZ0NnbFhzRW9sZmpET3ZV?=
 =?utf-8?B?SjJkVXFLQnJ5elZUYjB0WlYzKzM0Tm53ZktCcVo3Vks0SWwzMGYwWk1INmYx?=
 =?utf-8?B?Yng1YmRoTDBNa3IvN3p3cXZFaitOdE9WWnBMNFpvbFN5L2pIK1FGWXVGakpn?=
 =?utf-8?B?cUFrcXJFcEZWRkFYR04rWWxzOFNsTC9hTGJiQT09?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2025 11:35:54.1916
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e4db08ce-a66d-4a14-17d0-08ddc9dd1581
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CEA.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9230

On Tue, 22 Jul 2025 15:43:04 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.40 release.
> There are 158 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 24 Jul 2025 13:43:10 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.40-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.12:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    120 tests:	120 pass, 0 fail

Linux version:	6.12.40-rc1-g596aae841edf
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
