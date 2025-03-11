Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2058.outbound.protection.outlook.com [40.107.223.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F77222F145
	for <patches@lists.linux.dev>; Tue, 11 Mar 2025 09:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741687159; cv=fail; b=svPxeOL5ToeLHeB0+OZ0HVc5EZhzQPFN5H2HwxMhZ4UVVf9mbl1I42XExU39vzD6zFYq0PNQsSCvApMCV4t0+gR13C3D5nTidv5S5MXTu25e7ugTjXGbW4VzYbpUCZGY8P1XSxNAQlkNI9sJjv57AAVtUN/EvBA1chGvvwtU7OE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741687159; c=relaxed/simple;
	bh=lG5OSe0gBrn26mAg6koLsJ/5qgfAmtAivNtK9vGFC8E=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=rJnILhWQqj5kga1Hd6p9JA7sJF3+tOAP7GrhB0Xpg/0bn+uV8AhUFIlMvGlyKBEomfVTBHxJYFp36qg84ylJWZvlEdIxqImgMq/iWi1NXtdjaItqLe2N5Knz09AAhRWYNLiclr//3ShLwmP5TA1MUrVLPbPW6UIfpERzxxFi5BU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ZwpxdVhv; arc=fail smtp.client-ip=40.107.223.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ZwpxdVhv"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FVu94rUBu1+5DJmJzW0IlMxAGQaVjGx9fJCeLmAwlSuJdCBKVd2NHbOAtLBTOHZsUmF3jbvqG3LPiiFfFEYnK0/JSYWBQv8py/iqK1Kb8f1YimtBx4Jl2u9kIixguF3wmMgVC13ZLnBYw4XZFkGPgR51FOji2UjSIFlWcjlJoUptdVCJgBb78fP6M6omAjlwX2K5dYcvj06/HwRvTbMSjgLREWEw/K/knA7g5/M7lw3A/a2XAPbli5pi3famLKlSBGPiPy3Ap8hOYctPpyrKMqWFLWpc72QGiWIt12OkoZD6Qefj/XG4VjHbkNdBt6/OoKku8/umspWzZKGOB9f2YQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1YjaDcJ12x/kGIzKYEMABDfGjcSHgl5PSUEc90YtuUc=;
 b=WgIRvhQdYAz20WuP4OZBTNDq01d/9GTuA46KuL2PPU66rh6LV+2crqN3ttM7bI2yGw7IEMw9Nex2j4ik0b/NKDJ8g7KBS/ruz57FFh1tiBvY9q/dwdoeHDX6l3cMT9DGSDeA8UgdsGlooXDbgpVg55fSWUeV0w2PsuM4LDaiKazkrO65uz79l5WRddKaUleCbbC/ZB3MuRmk0tPeoPirqHXGDlIC7pvs1xJ6g+BdQ/OXJvIQN8n+oS1uMNA+yVS70nzqVwL2KRb0jYaonxXITGPLInbfpKZzOgb5YP+cRb6uTWK7+U4puSWL60yxoGBFzbQVOZnuuVkA6xTZ96Xtlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1YjaDcJ12x/kGIzKYEMABDfGjcSHgl5PSUEc90YtuUc=;
 b=ZwpxdVhvTL2fMa/htmSl8xp/Pp1d86vt1eGk+45lQcrZ51TkhTesCF0aKHpLXxIrVaoHGV0XCsxxBa1cQ1J2RTTCu0oRPS98ugQUzICyccXleLriCj3hMhJ3bqjVTav+aV2l83HXjsJ1SlLb3mhzNohLqfHMJqipMmlhevt31ExDtHsGCS+I6g2q1kIk2sMB6d1olsOaLoiYDze51Z+8ppEljEPSmYJEpTGcCtWyLUIw7jBYucMVE7s2fb29u96XqWJi5DfL4zZ/nCkFS8Utf5V34hgdxunmq+bZyFW3DxhOfdiRqKrU6LK1TTQzYO9zkg1E5xR70dxXhy935Vl0eA==
Received: from SA0PR11CA0082.namprd11.prod.outlook.com (2603:10b6:806:d2::27)
 by BY5PR12MB4276.namprd12.prod.outlook.com (2603:10b6:a03:20f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.27; Tue, 11 Mar
 2025 09:59:12 +0000
Received: from SN1PEPF000397AF.namprd05.prod.outlook.com
 (2603:10b6:806:d2:cafe::51) by SA0PR11CA0082.outlook.office365.com
 (2603:10b6:806:d2::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8511.27 via Frontend Transport; Tue,
 11 Mar 2025 09:59:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SN1PEPF000397AF.mail.protection.outlook.com (10.167.248.53) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8534.20 via Frontend Transport; Tue, 11 Mar 2025 09:59:11 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 11 Mar
 2025 02:58:58 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Tue, 11 Mar
 2025 02:58:58 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Tue, 11 Mar 2025 02:58:57 -0700
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
Subject: Re: [PATCH 6.12 000/269] 6.12.19-rc1 review
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <e17db3e7-7263-46d9-88e7-0f096405f651@rnnvmail204.nvidia.com>
Date: Tue, 11 Mar 2025 02:58:57 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000397AF:EE_|BY5PR12MB4276:EE_
X-MS-Office365-Filtering-Correlation-Id: b736dbdd-a413-4200-87a9-08dd60835fa3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dU8zdk5xSWtiK1ZpR2M5OS9SYllrek5xaTJkMkkyR1dKQlFPQ1RPNzZueWZX?=
 =?utf-8?B?aUdUQktNbXNvcGU3QnE5cjVBbVh3Wi9YUHplbjlOZWUxY1N3bWlheVdSMzIw?=
 =?utf-8?B?Sk9VVlcxSXlUVHhTMDNEY1VkYVhYeWtDdUlYYU15Z2luSlZTcDJES29FMFNY?=
 =?utf-8?B?bnA4S0FxYmltOUNuYk5hVkwrOW4wakhxOEdPRGhodW5jZGxZdnhsWnR3Rmli?=
 =?utf-8?B?YXB1UFlRZ3lVK1p4dnNGbnRxWG9qZHZrNnN6V0ZiT3lJcVFtYWJoTmRadlRQ?=
 =?utf-8?B?ajZ1R2N0VmpNQ25YUUpoYjJqQzRKMFcyRGdGOEQyUkFpYk1GRXFPL3JwdGtC?=
 =?utf-8?B?VFptVEF5dEJRd1ltMGQ4V2pYRStnd01XeUpLNmc3SUpMdkdBcTRtbml5eVZN?=
 =?utf-8?B?U1lyQnA3bHFaVEVzTlJCU0UvbjVoelBiY1VRaTY2b2dPalc1L1F0SGdCWjg3?=
 =?utf-8?B?L0czRzQ5NXFTNmovZlk5dEpLZDZNdjBtWGZXVWIyUHVqYkIxZlE2bjlveUgx?=
 =?utf-8?B?Rm51bDFtWjlJTVZtQklnVzVFSnRmcHoxcHhBN0xsSkZ1aXVWeEl1TnFHOWZu?=
 =?utf-8?B?Tk9URy9WVjl6TXNvR0Z2ditUMHY0b1VKd1FFRXlMc280ekp1SldaRGdIbnNX?=
 =?utf-8?B?RWJsSnVqYW0weTRnWGNqQUdaRnE2dGNKbnVkbHl0ZzFMU0k0Q1dXSFZjMnVH?=
 =?utf-8?B?OGZlSiszT0x3bHRlRCtxYTdXYVhjdXN0S1g2MzNocWNwcXJMMUs2bWNRWE9J?=
 =?utf-8?B?RmVGVXNmN0JwZGdJZ3phS1NsNEpBMUFUK25zZElSbVU4REc0OHJ1N0dsMGV3?=
 =?utf-8?B?T3MwT0hrNkVHRG9SSXJmUFVDeEtxTDlYZk9DaWp4NTVVYk5lRzl1U3VKaGJG?=
 =?utf-8?B?UEFDekpSSEpzY25WdjVuS1Y0em1rZWRJUTZCS0grVkdDTmtQbStiMitUVVFV?=
 =?utf-8?B?NkNpTWVtdHZ0ejZPMDRHb2EvYk1Xbi8vTE1ZcUhlZXNRVnRRVXo2ZDMvNUp5?=
 =?utf-8?B?cEpoOTQ4b0VTZWllRzEzTzREVUl3MnlDVGZEeWhlNElQYUlHWmhxKzR3Y0cv?=
 =?utf-8?B?S1B3Sno4TE50ekN0Lzc1RWx4Um03d2M0M0RWVFIzSFJsMU1MWGx2RlRCYlpE?=
 =?utf-8?B?MG44ak1ZS05RcjRTV1FJS2Q2SUlzck5zUlVMVWRhKy9ZYU9oZGNnZjhYZEl1?=
 =?utf-8?B?RUN3VlRncUtzQU1TOFhtT0cvc3FwS1BjY2JUVTJDSzJDNFAyN1JvSUtnTnRj?=
 =?utf-8?B?dFRZUTY4UUtDcVdMR1hEb2NoUUFmOURBWjRtdWpub3RSZE1lbHRSYi85U0o1?=
 =?utf-8?B?bXlMQW93SE8yOUJ3cHNFbHJOZkNOY09zMEY1cUQwOXpvZTVnQzhTS1Fsb1Zm?=
 =?utf-8?B?Z2xUZnl0a01yd3p3SnQrZ1ZsNnM2cE1DUEtUUDMwaE9tdDlEa1JLcnpnb3FR?=
 =?utf-8?B?WTlGenhyWnpaRHZVTHp3OWxmMjVZd05MT0I4aGpIenpxeGY3K0pWMm05RkFI?=
 =?utf-8?B?cEdIMkRVbGRnU1VvZTZzeTlCdm1wMkkzQ0Q1Ti90M1lwWWoyanlHNjRXdTFu?=
 =?utf-8?B?RlVHc1VoNXF0SENOUFNXMVBaQ2pTTHVHTERYRnZPbUxndUZKSlhaM0liNlp0?=
 =?utf-8?B?ZG5rQUxmWUQxVEZoOHR3bjBQWnh3ZHZMYlg2RVFVSDNvK3FDaUhWRE1BTjZW?=
 =?utf-8?B?ZU1mekFtZ1dVazdKMTF2dCtiK210MDNmT2RQZTY3ZGxIYndVVDJBNlR3M05S?=
 =?utf-8?B?a3FvUExhNU1LeTROcG9uSEU0eVJWVVBiM0g5UHo1blZCNDgxWldmdlYybWx2?=
 =?utf-8?B?M0pOV09rWDVETHJBOGtxd2N6K2pCaGxEeDIrNFJ4MkVRZkszTUl1aEMxYlpW?=
 =?utf-8?B?b1JYWU5aRkxkTUM1RTR6Ry9UT1VRUEp5MWVMU0lQQmhVVlRFUHY5cnNLVklJ?=
 =?utf-8?B?YkMrODdmMFM3Rk9mamZQUDBtalZKbWdWMlZqbnQ2MkltQnNVcUtMdWd1aXRn?=
 =?utf-8?Q?wWrO2Jhy92gV68Z6tApwNyRAa+FVoY=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2025 09:59:11.6763
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b736dbdd-a413-4200-87a9-08dd60835fa3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000397AF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4276

On Mon, 10 Mar 2025 18:02:33 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.19 release.
> There are 269 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Mar 2025 17:04:00 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.19-rc1.gz
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
    116 tests:	116 pass, 0 fail

Linux version:	6.12.19-rc1-g53db7cb59db6
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
