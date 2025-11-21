Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011016.outbound.protection.outlook.com [40.93.194.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35CA6349AF7
	for <patches@lists.linux.dev>; Fri, 21 Nov 2025 16:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763742525; cv=fail; b=cMfxvRuNEi1nFEepE9+6gV24JxttA/NgnSbASZilU+iVGPzZ6npJU684R02kP7/81n48A2ZJ4defHeE1F7jKijsDMvS3+pmJJL+Fg1LkdgxJxnfwN9yc0MwBZ5DlXZekPMf24gPZ3v8H5tyjkQ5Fwdio7zGiAaot5XdCDKuXZIk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763742525; c=relaxed/simple;
	bh=EgmkRbJg+vPzkNiAt9Q2Rtv8vqKndC2/fjx+r2vStiY=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=W2sCiLHq0oibYpKs3IDnVmGzVpOPcsVV9YH4vIuGoV39/LG+j9ncLQdbDA01bwzGGhYSohuzoDRUy+UqxKY413fz1y9Ccji/0H8fEn7tlx2tFPFVvvLRF7bPfJ/bND+L9QGcWtn/zHNN9D/BuQD8Tf6rSEXEFPe7Z+QXLAU51jY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=a3FiuBxt; arc=fail smtp.client-ip=40.93.194.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="a3FiuBxt"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cr9ceEcYRFtWN4oVPJCyK4joLx/WaaXLr20lwF5UfjLJOiBtuN/lqqCfP13LxT7LopzFyY3BEm24vWt5VFt9NnSOoPnAR1GgGI5eg/X+C9Pv3xA92Cgw2htlbWejQTfqV0Ycd0jK3hMwn98fqWCQ5UHAdZ07aTWlOD3mCup6jme4IEXoH0Veg7vvTy+L9VPMr+r75Fl4n4x5vd2lhSxeUcNFUZkWN1xZfcmaoCqEbWMNjMc3n7Tn6ZjytUCAqQ1xbu1/rV6yFKqtmlUIdCYj5k1rEqUBfUQn/Y1htvRHS4p3n0iu8u43HukS3RYQ5umjcRGW2/atUoGuyD2a2LPqeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jttk545N2L6DrIZ3R1YY/XIki1Yffdg8pHgZ7eKag0I=;
 b=oAgn3ZM8JchpWCpNw+3dmw+N63n+H4EpB6slPhhAROLLtx/3mPfbcruInhUDmVlaz87Em500SaAip/SZTceHxYj9bfJzlO5pJ5XVohZXlbuFFiDO4R8IO+ODOZVReE6JZ+Lf7osQy4HuY5TFvetC+kL/xX/i+gdG0ctvIyxMoBI/ERQyXL8MrqnA1eX5+3T/+5RGmzjVEaY4Q0d29APjiFDrYgeeN2fp8pL/Pc71ktvN2SyxYEB9GsFafLyYPRBidB93Y2Xs62qQm8wT7pYLulrRKAFya5KpDp68d3HEneEsC6UQmRLGoJlIBwQ2mP7lrNJbt+8FVQ4NBmgVKbS/RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jttk545N2L6DrIZ3R1YY/XIki1Yffdg8pHgZ7eKag0I=;
 b=a3FiuBxtyo5U9iuCdHALhKl5WLVBZEIlL9OjYMADTBp7qgYFs4UfNx7bXkQuyvF5YCvFt5NcyyjLv3ZwFY/uyeDHtMX/mCAfJVb/uW/IxV2PSVmQVQY2J/WyJgdMmk2Jgm7AGi9halAwVSxl0Y4cM00CoNDc5Yk/arAX/LscBr9QgOjs08xBV0lQiY/1Oo6hhpP0KBNryCRjE/rdCzbdZk7nZZnzoPGa0cB9U3mwnoiNPRZMpVmB8x4dYXQob0XOSny0QWYYQ1eoxAdqOFwWGFqWt19eoJx+pcH2Dq+mNEV8PJXgZ0ePLUCmEpP6wydryaUtzCluQQSdLZ+VwPuVCw==
Received: from MN0PR05CA0002.namprd05.prod.outlook.com (2603:10b6:208:52c::11)
 by PH7PR12MB5951.namprd12.prod.outlook.com (2603:10b6:510:1da::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Fri, 21 Nov
 2025 16:28:39 +0000
Received: from MN1PEPF0000F0E2.namprd04.prod.outlook.com
 (2603:10b6:208:52c:cafe::82) by MN0PR05CA0002.outlook.office365.com
 (2603:10b6:208:52c::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9366.5 via Frontend Transport; Fri,
 21 Nov 2025 16:28:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 MN1PEPF0000F0E2.mail.protection.outlook.com (10.167.242.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.9 via Frontend Transport; Fri, 21 Nov 2025 16:28:39 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 21 Nov
 2025 08:28:19 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 21 Nov
 2025 08:28:18 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Fri, 21 Nov 2025 08:28:18 -0800
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <rwarsow@gmx.de>,
	<conor@kernel.org>, <hargar@microsoft.com>, <broonie@kernel.org>,
	<achill@achill.org>, <sr@sladewatkins.com>, <linux-tegra@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH 6.17 000/247] 6.17.9-rc1 review
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <43113b72-0b8d-4ac6-957e-c0e6d93f1b5b@rnnvmail203.nvidia.com>
Date: Fri, 21 Nov 2025 08:28:18 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E2:EE_|PH7PR12MB5951:EE_
X-MS-Office365-Filtering-Correlation-Id: cc15897f-fc18-4004-a232-08de291b072a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|7416014|376014|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Y1FhbXluWGU4ZUVNUENDVjV4RzkzRGtRR3F5eFJWNithcVl5dThMSnlQRCtk?=
 =?utf-8?B?UlpyaEFIa1QrWnZQczZDbUZSOUFhWlo2OTMwUHBXVGJpNzJBbHBPdTNrbVNm?=
 =?utf-8?B?bHFyZEVwZjk1YmZVdTVvQWhXSVc2TGt4T0lVN0hmZEJzcE5DdjdkbkNWOERV?=
 =?utf-8?B?TUdMeHZYUUpEV2MxOXpmbHJuREJHZTN5WUQ1SlV3R2NITTVlQ0YvOWZDSzgx?=
 =?utf-8?B?aGRDTkZOUVZSYWQvS3hONmdOTHRxaXora3NNWVZJK0tldmlGZEZDdHJBU2l3?=
 =?utf-8?B?NU5UR1JjbjQrUUF5OVlXdkFUalFWTFE3aHI3c0NyaG81Zy9aMHFITXRjQXIy?=
 =?utf-8?B?Q01pMFlaZysrK0FaK2RFTmVwelBLd3YxVlpHYzFPTGNibXNVRkVuV1pJNEd1?=
 =?utf-8?B?a3E4aTdKRXZBRjJINURmWWJVMURPRjdOT1MzM2QvajVvOUpMaXdkY0RaK0Fa?=
 =?utf-8?B?NitNMTdUOUc1alhMdWNtcExhVGpTUHhkQzFtY1p4ZnVyR1VJSnZBdFhCMWRq?=
 =?utf-8?B?YkR2SGJHMUJaVHhhNGM0SmdzL05OL1BiOGNFei92K1A4VFNHeVhSVUtVWFky?=
 =?utf-8?B?ME9EYUpONkpTbFExMHFiWEx3RVlFcHNyYy9nYlNyR2xSZU5hNFgwNncrRmFG?=
 =?utf-8?B?OGxMOTFYWXo3ZHJRTXdsOHkwYzJVZlRwbHRlSjdWOEdkbTlOYjlGb2NvSnRV?=
 =?utf-8?B?MVFZU0JIOHBBakwrWnFqTnRVWERJc0dsa0RrTlhpeGJIQXlwYjA2M1NOcXRD?=
 =?utf-8?B?bGcxbWE0OWZaK0ZGbnlOZWxSWVFZY1gvOXQ4WmV3RkRlejB3ZkxmNityUDNk?=
 =?utf-8?B?NFFiVkt2TjhENHpINldrRDMrNUV1cGc3NFkxMk15WUVFNlpmOGw2RndpQnFu?=
 =?utf-8?B?UGxZanUrc1A4VzVjTU9jUG1UTVN5ZVhCckppcEoyY3ptRVNhVEpYNWtzRFli?=
 =?utf-8?B?bi9UMHJ2Y1Y3WDR5dWJzYlZGZ01wVmdhbWRrYkNzeUV3ZWJ2Vy9lSFd1ZGdM?=
 =?utf-8?B?bjEydmN3VHU1K0tTdGFSeHU5aWZKY2RCRnJSMmZ3SWtIN2pPY1FvVVR0WUxk?=
 =?utf-8?B?N3pobWx2TU9XQ013NC9raWJmR1JVcGRpOUFwbDFpbmdVZ0VLVHRtYi9xb290?=
 =?utf-8?B?MGhWcW0rR3RSRFloV01pZ0QzOFhVRllROEw2Q1hrUDV0Y1prTUZQMDJia1U4?=
 =?utf-8?B?MkY0c1o2YUs0OTQvNGx3S1NNN3JCTUVRUjRIV1FIRVBSSUZBVEJKaDZFSm96?=
 =?utf-8?B?UVRoa1RYeWRRZ3RTWU9CZVpCMEdhTGpITGFoa1hEWjNTS3FyQzRtR1doS1po?=
 =?utf-8?B?ODFxd040Z0xNcHhhUzR0d3pER0IzMFA2dHlJOTFXMCtGSDZJYjVidFpwRzdC?=
 =?utf-8?B?UXNPajNPSjg3M0Zsd3NLQWZUUVlqeC9VOEh0Yzd5VmtUWFFsTDU1clI2bE96?=
 =?utf-8?B?eEZsUXltcmxyQ1VyVjM3NTlMK2hRL1VmRkFQMEk3aDFvYXRuSmVqa0VtYWkw?=
 =?utf-8?B?c3hkM3E1c3FQdXYzazFpM0t4T1hOSUMveVdoa3daTkx4R2tzQlM1UDR3SGNo?=
 =?utf-8?B?Y0JWVXd2MGxuTDFsT01IWXR0N2ludWdhRWh0b095dmpzUy9jUTFpSVBiaDlp?=
 =?utf-8?B?OFYvMjRZVDM1NWVwSitNT05HZ3VnSURwRE5aY250OEVidVpLRHNOeERkUHFN?=
 =?utf-8?B?YllDSVJ0aVR6ZmRCQ0ZHdkhUcFZEZlh5OHRWQmI5STNtZXc3dllPUVFXWlhr?=
 =?utf-8?B?a0dxeW9kaVRMTnNTZmpEOGFSVmdqNDNpRUIySmdtSW8weU1Tb24vMlA4aXdq?=
 =?utf-8?B?dzViVldNZnNmVnhxWGs2S3FRRjBjbHRYN1BxTkd2MmRDbzcvWjF3Q2o0Vk9K?=
 =?utf-8?B?S0NWTzJrN2MzUUYxVlBVdFdFT0FMZmQ5YjRjYzJ2bnY5NlJXR3YxWnd3Umh1?=
 =?utf-8?B?SUovTWJFQnh6UFFVaXRoUjZNZk9Ed25TR3NGY0VVTndLc0FndkdwVVg4T1p3?=
 =?utf-8?B?NXJ1Ym0zbDNNOHdwN1R6QXFEbnZQbWlZOExxS0c0eldGMEpxbFAwMTRwcTRj?=
 =?utf-8?B?bEdsbElLYnRkTlp3WTFudDJzRkxJRnI1K0dUbCtOcWZXQWd6VURiQVBpVFhC?=
 =?utf-8?Q?cY5s=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(7416014)(376014)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2025 16:28:39.2428
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cc15897f-fc18-4004-a232-08de291b072a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E2.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5951

On Fri, 21 Nov 2025 14:09:07 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.17.9 release.
> There are 247 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 23 Nov 2025 13:01:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.17.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.17:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    120 tests:	120 pass, 0 fail

Linux version:	6.17.9-rc1-gc2a456a29ad6
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
