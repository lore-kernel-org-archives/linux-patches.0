Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2077.outbound.protection.outlook.com [40.107.96.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F37E871B3A
	for <patches@lists.linux.dev>; Sun, 18 Aug 2024 15:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723994918; cv=fail; b=eQTX5x5OSdwI8kGqyxGj1yDquVKJAUu7phyNkg3Tk9BkShY/TeUBdpvHSn1b03m+vp8R//DbfMVzGzLRmSF8lG5Kzn0v7+4S4+pui7tPHWkAoiop8b7tJkx00SSP6J3L0fluQSdC+oUIn4H/m5Km+Oy1VPn/yup8C6SomG8aDGo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723994918; c=relaxed/simple;
	bh=/N8TXEXOoeGEo3937kzJPSuQ+gLbH1l/0U1hpA+1Oi4=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=eHuXMKnbbawhCIUT20y+j6vbATgGxDvY/II8HmLhyBXnWlkj/zoekqwaQUTxG5FWdpoKsL58qIc5Mg0QJwaeGNac9O+fes+nWiDCZAmvS6isjQ9X11kSkc0hJuS4kow8NntHe1PjVQebB+giS1oxci9u41uwKnvAh2aDlgl2c5w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=A6uG1X55; arc=fail smtp.client-ip=40.107.96.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="A6uG1X55"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yE04n4h5E0z9w5y185MLkTa7I6Wgq8GkuWEVcyp04X8C5GwgwBN3DgJbt52tjiEGrrl4yIejLGePqeFrLqQHU5WGGa1Z0IFI9inKwzZb2FAj3q8ftfYBOTMR1JsKApQ0O0VkwOBOhq57qbi+7NDCVh8sDE74oil6YXT1nHKW24gOkC8EmgrRTo40rXpRB/Ldv3y3PfR9y7Qp3Opy9pwjLG7pkG3FH/kKYpbApTGYmYvyFBPJe3V5RZRgQJ65u/0o/f2eQPtYKk/0Xopi6wTYk/t+3NJraRsN8H1cNCZSWkmessW48jHermgyP+Q02dzYbm1GrYAE21o6d9+5s4ORrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L/1x6UOeRkOW57AaSZQRqDmPq3VgP4Rhyco9oxAUyHg=;
 b=JwkuU067RdCBEtacwOZmZaFDy+sxXN8ZMauLsSSwRfO8mJqg/Cb6of+nzm1D7i01kX0/UauigULkm+qFcFrItfnHoFkJQa2OImdD7AEgNWSI0G2ZcH2YEw9+wPcntp8lzo4NP22h5IPbWZaDquAdSRGKb9iH7mnvSfIhPTtu2jj3WNDwcYZ2lpfdXhWK7d1B9ZC3TfdJJlMlBYAFP8Z5ge3+Br6PnrqEqwGDVN6TW7G2sqg+5Te/B7WRIoPLYUyPTi/4RJx1VZjU8tFLn7HXdyjIlYpGGWfXEQ6u9Y/9AeH1BhK82V9Tb7zGUO4/WXmay3fPmZwtzplDWlOams7a5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L/1x6UOeRkOW57AaSZQRqDmPq3VgP4Rhyco9oxAUyHg=;
 b=A6uG1X55S/7KZ2qrJjQDZpjVz1W8Tt9slNb2/D4X9RbYVcG+E2zTJ/VmyCUNYFcdmtHGlejBedf7w94aVbCY5zSFUUx9R50KAx9Det+xLQUyFnZ9bOuY953qvCESDU0y+EEURdyXIffBacxnK8Wz+Raa5pJqHXrTxzHYb+0YBFT32IImJxgIn5WJjiguR4VQfJLIWSSc8IFxPpaBwqbCgv3qtPmHvX+zKrDqzLhufVVYxUgPH50HArFiF3wMSZjH1GSrZjHCUcf0BUW5x8g2LXEa5lupco9t0QJQSqPPHxTOhREf3lwEDpi5FB2/tR1FYR91R2B1r3A+3j6lGeIiAA==
Received: from DS7PR07CA0018.namprd07.prod.outlook.com (2603:10b6:5:3af::27)
 by DM4PR12MB6349.namprd12.prod.outlook.com (2603:10b6:8:a4::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7875.21; Sun, 18 Aug 2024 15:28:32 +0000
Received: from DS1PEPF0001708F.namprd03.prod.outlook.com
 (2603:10b6:5:3af:cafe::e2) by DS7PR07CA0018.outlook.office365.com
 (2603:10b6:5:3af::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.21 via Frontend
 Transport; Sun, 18 Aug 2024 15:28:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS1PEPF0001708F.mail.protection.outlook.com (10.167.17.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7897.11 via Frontend Transport; Sun, 18 Aug 2024 15:28:32 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 18 Aug
 2024 08:28:26 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 18 Aug
 2024 08:28:25 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Sun, 18 Aug 2024 08:28:25 -0700
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
Subject: Re: [PATCH 6.10 00/25] 6.10.6-rc3 review
In-Reply-To: <20240817085406.129098889@linuxfoundation.org>
References: <20240817085406.129098889@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <3c677f8c-b97d-4061-a0a2-fe731be7758a@rnnvmail201.nvidia.com>
Date: Sun, 18 Aug 2024 08:28:25 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0001708F:EE_|DM4PR12MB6349:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d61529e-5829-40e7-bb5c-08dcbf9a6b43
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WGtFMG9Db2ZuWHZ0VlBDUWI1WitxODVmUkh6RGkrMzdWNUd3QUxKZ1ErY2RB?=
 =?utf-8?B?YkE3b0FSamJkdUhTOFgwQUg1MWl2SzZpT3RXTVQrNEJpbW5wZGZIUEtpV1Q5?=
 =?utf-8?B?YTZYMy80YnFpek9Bc2gva1NORFVPS1lLQnJwUVpyS1dtV1pnVmVraUVrU2tL?=
 =?utf-8?B?aHg3R0czOVpiWVN5bmtvK2xvMGcwc2lnbG1NMnBJM0FSV0V4VUdVU1hjZ0cr?=
 =?utf-8?B?TXhMbTEyYjNSWE1uWmxCdzBSMGxHZEhJZ1FCMWVNYkN0TWlhNEVXN2t0Q1RZ?=
 =?utf-8?B?WWl6YXBrODdGUXJKVjVYZVZPRGlIdUFCSjZJVGZYbmdzYng0SE9OZkVRL2Rw?=
 =?utf-8?B?Nm1DWUJhZ1ZIeTdNZHZWR2w0N2dDaFRUekR0aFc5S0Qza1k4TDVPb2lOcW95?=
 =?utf-8?B?ZTRJZDMyQXA5QS9SWDZIUDA0bE8rMENCcDd3eWlvT2svVDZlNVFyeEFtdGll?=
 =?utf-8?B?QmFaOFhGbnpRZkFIemtQaVYyQXRDOWRZM2Z6bjBITDErTzIwT1ludG0xSjV5?=
 =?utf-8?B?aHIweUlKYTBzeXFuZlBtbXM5MHpQV1NmY0NEMnNLTnR3K3dvd3MvallSYmwv?=
 =?utf-8?B?M1krQkErYk0xTVE5Vy9BVG8xdFpXdXJrWXlJbmFEQ2xUWXhQQVRQNHUxTDVQ?=
 =?utf-8?B?MTB1N1hJTExPTHpiS1ZJM2VWOUNPZDFSdGVmYXBwUDdObThuWkkzUEhHalY3?=
 =?utf-8?B?eHRwRkluRXFmeHNWQWk2RWEzbUNoVitjWUFESWk2ZUFtaVFQNzRTT0wrbUY2?=
 =?utf-8?B?QkN3aUl1aXVFMEZYQUtVK1UvUW9kdVdmS0dKYk9GSE1DQWJkcTNqVEtCRHpl?=
 =?utf-8?B?cFJ3T1ZHcmJyR0cvWEd2MURKRkgwUUxpUnRHTVNNVmVQUElWd2k0L213aUs3?=
 =?utf-8?B?L1dvSzNpaXEvQ3BnUHdpakFLK09ERVljMGc4SWRXUHJjd1h6eG5ETkZxNlNO?=
 =?utf-8?B?bDF6dUVqa1RzNjNRaHd6cDk5aHp0RmFZRHRpbWcxY2x0QWJFSy9ySmZRSURR?=
 =?utf-8?B?cDZPY0dXbUhIMW93bjRoV0Y5R05aS2ZhRHZoOXpQSjcyMjlXOStsQlVaWHEy?=
 =?utf-8?B?dGM1T29ETCs2dk9Md212R2Q5Tm9GMWxlSDZXY3FxUU5iY2pwUkxKZTA3MGZ5?=
 =?utf-8?B?cENtTTdlMGVPdHN6aUJwcE5SWDlKcmhJUC9hekdvU1Z2aHpNbHNTR2JUTmxj?=
 =?utf-8?B?djVXNDVYZ0lGVERZOG5YMHh1amVMSmZVV3JJSzM2STBJUEhuUFJUdDJpSVAw?=
 =?utf-8?B?b1FlTVlEQkdLaHViZ3UrTjc3eFpyd2U0QTZrMzZGQjdwOXg1ZFYzMTNCQWJ6?=
 =?utf-8?B?NkM2U0RISXBYa1hEY0tkaWYvaVE1Q2VObFJreEFYTVZMSi9tZWIvUVJYbWxZ?=
 =?utf-8?B?YlZlSnZBUU9EUy83V0E2d21Pb01sZ2YwNTBQSGVOMXZYbS9rOEsvNmVPbkFp?=
 =?utf-8?B?TDN4L3lOa21CeVd5Q2RaVFhaN2RmN3k4am9VbFVoZlpQRUJaZlBua3VjdmlD?=
 =?utf-8?B?a0NzckxoM1ZqNSsyVXRsL2pIUG9jMVBWZWZmL0VPWmJEdndXTGtNZHFnTU9F?=
 =?utf-8?B?d1Z5YjdTaDM4V3pWTGFKLzhjZHJIZUM4eHQwWEtzSzVZVjNON2lPeTRNNndn?=
 =?utf-8?B?Q2RvczZ1a09wakVhT3IxNjg2OEpPQlNncms4MTF6V29IMFAvQ1MzU1E4c0Qw?=
 =?utf-8?B?aFgvVW1LbThaVnJEQmlKWFVoYTI5MWJMeXQxR1J3dzBBbkYrRWhkRTdIRkgy?=
 =?utf-8?B?VXFMT3FwTXV0a2Y4VDh3VXQ0Q1hUVUIzdHF0N0tvYlFKV0haSW42Q3J4aTdO?=
 =?utf-8?B?Nm1SV09zbnljTjh5ekhJeEFWZ202QW5TY1MvZVlCRUt2ZW41ckxQd0hXTU1p?=
 =?utf-8?B?bzlOcEJ4OTJ5MHBLd0F5MENOc3lkWVN0ekVoN0VsQXdhc01Nd0k0S2RnSWJR?=
 =?utf-8?Q?siFsO8WO66BYMGS7PGUi9WPFgyc1TQ4k?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2024 15:28:32.3831
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d61529e-5829-40e7-bb5c-08dcbf9a6b43
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF0001708F.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6349

On Sun, 18 Aug 2024 10:53:45 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.10.6 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 19 Aug 2024 08:53:52 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.6-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.10:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    106 tests:	106 pass, 0 fail

Linux version:	6.10.6-rc3-ga522cad06418
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
