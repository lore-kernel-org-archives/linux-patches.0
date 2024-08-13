Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2054.outbound.protection.outlook.com [40.107.236.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C78531A38E7
	for <patches@lists.linux.dev>; Tue, 13 Aug 2024 18:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723574435; cv=fail; b=LZmBV05XIo6jveZuSxqlIR5ZxEugO1Z1/vMl/A4Ht9ucHnUTbZG6DCQQCy2ZxfQPCNTdMEUETrC0mDaPPD/45XN6hrgq0zBPw64NPZraY0rL6FijkRzUIy8Mx/5CDj5k4pVc1mhFd8h6iHdtQOjnUPYnodEEhan8nmbgs5wCYwE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723574435; c=relaxed/simple;
	bh=ykZx7HvibJLciWyjI/k7/9U4wIu61goflXkRDLOVCDw=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=G4l44h2IEidsZtaVv9WQhZz1xixs3PSfRCn6BrgcP3eEUbh2FcbIDa5UTehux+0g1LS0ZUcjw4XEeqMurW8vQyuAxm6fFyWEz59yyjGDD+8QFMXAj5ZDlwqJ0UQ8a6ERG37nXdaxTQmGXfpXnZNhj/49gt7bTpi1YB+QrgWhdG8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=t6sJerDw; arc=fail smtp.client-ip=40.107.236.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="t6sJerDw"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HU4CqZ/dpIT/uOv0FbMaKiMCb0jtbdXc8Pnr/D9PjE7/YkfCaMQqJCXJKmWdSmvwdIWbX1WIJgicr+zPrb9ZFX3sG1C4mCqzUTfgfhcDqmj1qiouaHJBB6Cg6XJm3exv0vOe0BmdRc/Y8rzj1KBi4JJUnU3GR/I4JaTMCz30/CF1/qlsZhd25iEGY8rRsrAN55jXiNEiGaB6He02nvqYKdIbWH3279AXnfi75bp0o9zmgYqTwaCOf5GgIobcs8b/7tRowBno8BuJzG0LaBM8+aXJz9Vr6x3UA064Gqn/bTy+lFwSvCJ7pprueLYlmSb09C7OAfWV3GlqJ5WJVtK+Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U/1PCcrEegkt/+igFl9ilK8o7cxVo+jBD4e4lV8msMU=;
 b=LnhiV2rVfoJRmf36krNhnGWHJzlXp8G1aU1RXJ+uKlhD6QuXYo9j42HLrPolzcK1E051mImKZvGrwkj9YbHRAsy3UT+WyBgSVHTEBghMJAHnQL15i/3pMCeLpIK5vpvqYT/vCBLPd/T1yDP7ECCnngN1aYiqIyye+3bd1DKR5X1WgoTHgbGyXyUlSZDZ8waphl91wAaWKcQJtrI/8Oph8hWkz/7PjQEFVeSZK+bgCKFNAlMY9vWCPbp2+SXvsD3YVB/0doL4OXpGpq4FI+O8ET3BlaYCwdYVouzF+tJGMGQXzMH3E08REbN6fIgIJd4oMWp/UnPfe6vmt0TkTE2OCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U/1PCcrEegkt/+igFl9ilK8o7cxVo+jBD4e4lV8msMU=;
 b=t6sJerDwWFXL3akwPEwv0CuqwvxgcuVOB6DHwnrCGwaxdQ4cck2Q3P85a7MWMFHQDopGgPju+lBr+sMwpicmi5tt8O3dCqvjNwc7N6EGnsmVkzr/rj0SypMwFYKGdx2Sslza13cj7s7xMamsyB2xo/wvHUbEYai7JAeKRRip1eOkqjr1c/YRekxvwrzs0NRlP6wY68JY4eNeVifvoblfMuMoCsUH8e0gxyDaUkRpkgSvxbDaOJndVREdQSlmwzUzSMsNdp3yrqiShpUU84hHPrG7s82k3Mz5+uQhrZ0KdTJHrDloZSi6Zwhx2rkJX+UTEq8det9bhffV6D6+naa3DQ==
Received: from CH0PR03CA0245.namprd03.prod.outlook.com (2603:10b6:610:e5::10)
 by SJ2PR12MB9005.namprd12.prod.outlook.com (2603:10b6:a03:53d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.22; Tue, 13 Aug
 2024 18:40:26 +0000
Received: from DS3PEPF0000C381.namprd04.prod.outlook.com
 (2603:10b6:610:e5:cafe::ef) by CH0PR03CA0245.outlook.office365.com
 (2603:10b6:610:e5::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.33 via Frontend
 Transport; Tue, 13 Aug 2024 18:40:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS3PEPF0000C381.mail.protection.outlook.com (10.167.23.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7849.8 via Frontend Transport; Tue, 13 Aug 2024 18:40:25 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 13 Aug
 2024 11:40:07 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 13 Aug
 2024 11:40:07 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Tue, 13 Aug 2024 11:40:07 -0700
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
Subject: Re: [PATCH 6.6 000/189] 6.6.46-rc1 review
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <601ad07d-1bed-4b39-8e59-96552fd072a9@rnnvmail205.nvidia.com>
Date: Tue, 13 Aug 2024 11:40:07 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C381:EE_|SJ2PR12MB9005:EE_
X-MS-Office365-Filtering-Correlation-Id: 99b2b628-b7ae-4111-97dc-08dcbbc765c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dnA0Z0crUTd5SWluTzVSQksrbzV4OUFpRHFjWnB3aUI3TERiMnM0aml2bVJP?=
 =?utf-8?B?b29uVGxqdGNWUUEyUGdzVWhhVnRvOTNxbnVmK0ZYWkdtRk5tRlVZaGVjOUcx?=
 =?utf-8?B?UkEwUkJ6NnJXUVVEVy9wU2RmM1dMSHlFRWFGaWU0K2xWbGFwOFV4N2dBMFlC?=
 =?utf-8?B?MjQ2VVFQNzVOMGRGdzQyQVg4cE5nWFJNeWFTdGY2WllEWXY1a3ROVXZtUHAx?=
 =?utf-8?B?UDFHelFuK2ttV3lwUTg2RUVIWW5ZMnBCZWZHRjZHU0xNZkFlcGppMmVJQlJ6?=
 =?utf-8?B?b3NDS0x3VDc0K1RhTmdoQ2NzU3V5RnNRMVBhSGpscFM3cWo0VWpkME5YWWR4?=
 =?utf-8?B?cUcybEpWb1Yvc3VkU0FDcHdUVUZNWlNSclhwTHo5T3pmWW5NWGhjS2lEUlh0?=
 =?utf-8?B?czY1RzMyUDl5VTI5SllxeGRMNGdjU0lxazdPTEo1enFhTXpKUnRGaUprUDZh?=
 =?utf-8?B?V3EyNVlETWpITFlVSW9MRnEzbURHTHdyS3p3WEN6K2EwSnVEL2poY0tNeURm?=
 =?utf-8?B?K05abHJ1MEhyeExzVkZXQ3FUOFgvYXNVZkxLV1pIaW95cFJXSUZFSkU2bWJw?=
 =?utf-8?B?bWhMK3JaVnNUa0pUVWNjY1VFL0FtZ3labDdnSzUrOVRvaGxkQlVoTXFhWEN0?=
 =?utf-8?B?RG9MejJva2FmUktZTzZDaHMzSUJQRzJ3WmkvaXlGOUdGMWt1VFRObFpBdzU2?=
 =?utf-8?B?SlhYQ0VkTENGYjB6RlhZZkkyaHQyK25XS0ZVVlFYeVltaERpb2NhVVM3UVZu?=
 =?utf-8?B?ZllseFZFZDZ5VmtFL0NXMWFRRktFd2VFMjA5MmgzZlV1STE5Z0hNeXJqKzBO?=
 =?utf-8?B?T3BMRG54eHdobEhCOVA5NFpheW1BTExhMlZ1ZG1lOWFPZDVnUXZ6S3VkakxW?=
 =?utf-8?B?ZmFIQmFMT3drMGtBWE0wRWVKUVNleVdYSXBFNlp6L3dMRlNCaUNrSXJOV3BM?=
 =?utf-8?B?YVE4Uk80NTFBcTlnN2ZTUytLWXBnZHJpYnpCR3h2cUsxbS9MM3FFVHJiUksw?=
 =?utf-8?B?Z084YlRPMWRiWHA4ZG1abEN3VlhHa0dKZktMR05HdWM1SFUvTlZqejFvbk9Y?=
 =?utf-8?B?SEQzYVVCSmhobjFjSUZUR0o4QnV1UFY3cFJ3R0tONmZ6ejlyKy9xL2plVk5x?=
 =?utf-8?B?YnFqUytkNWlRL0d2NkMwSFlGTVpLNXdBMzRqaGlQUkg4S2NXTEw3VkdLRnBD?=
 =?utf-8?B?MXhtLzQ5Mk93MnNVRXVGUnoxNmxBS3FKZ3hRY1dkMXF6Y0E5c2Vmbmh1cW5S?=
 =?utf-8?B?eFFOL2lqRUJhZGx2QzQveFhsaG0xUlFuaHRpNndyR3VCV3FXWEM2ZUFNV0tw?=
 =?utf-8?B?OGtEUVNSOGJiT1hNMEY4Tkh0QTdDdUVVWFlCblEyY2p3TVF0bXYxbXQwWWp5?=
 =?utf-8?B?UDNzZ1JMVW4yQUM0ZUpwdzJEMlhXUVptWnhvbHIyRkpmeWJuSTNTVDBOcjVI?=
 =?utf-8?B?SXB5N3VDaDJuK1dVSHBoaG9Kbi9RMUdrSkRudTZGYlBpNzlabERNbThJa0xQ?=
 =?utf-8?B?bmN3RzBRNFpHc3gvRDZyUWwvMWJoVWNlOE94R0FXMW1DNVpSeW5VR0RhK3Jv?=
 =?utf-8?B?d1RBYnk4aXpneDhZcGVGUEtxekNTMUxINi8vRGx0eUVISHhjWWRmRVFIZDFa?=
 =?utf-8?B?eTJScWU4ZldwWjdkMUE3eU9MWm5lRmJER3Q4QWIweHhIbGlwTEJGcmFRdkdH?=
 =?utf-8?B?TjdSaFNLZ2cxQ25yRkJVWHhrdlg3OFBCaXRzSzhXRHZiRE5uaGtJYTg1SnVH?=
 =?utf-8?B?WkMvLzhXd2RCbFhlVGZrdU4xTWt3VkVoWkNGNVFCM3ZlaVhYbEFiT2J4MVJa?=
 =?utf-8?B?dUFHc2NxWktTNzhpSjcxRmp3Y1lIekRHOHpxbEVvRGJrL0JCbVJlU0FxRitZ?=
 =?utf-8?B?UGsrbEJYaGdEeEZqUnFVN0FmclVROEx5Ky9Sdjg3djhCS2c9PQ==?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2024 18:40:25.8474
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 99b2b628-b7ae-4111-97dc-08dcbbc765c4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C381.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9005

On Mon, 12 Aug 2024 18:00:56 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.46 release.
> There are 189 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Aug 2024 16:00:26 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.46-rc1.gz
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
    26 boots:	26 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.6.46-rc1-ga67ef85bc6ce
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
