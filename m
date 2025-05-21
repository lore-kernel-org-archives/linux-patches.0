Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2062.outbound.protection.outlook.com [40.107.96.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD9627080E
	for <patches@lists.linux.dev>; Wed, 21 May 2025 08:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747816281; cv=fail; b=A3VR/jXrIuJYezy1zuyD6XHvY5jeKXnmQJCi0H7zPiT/XVqa6hb30KL0NTMoVYo3xPpjlwLrnlWnfwLGkEJqwGIEKtXbySGThsYADJz1vrno3gKksiMmJRZenc0UCT66J+iqnfxcD6I6AsveZHNJu++QyQmVSZeAkypaN8Qmii8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747816281; c=relaxed/simple;
	bh=IZWjZtQXbBsdjgZLAuJGXO5ftJ/Kh+FzT9C54mDFT34=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=O30x5BSzgw5SKMmiFvyWVFkhXC9gWq482Nuof2iRZ7pO5hizrucJksmaJQfud3b4nxc83ML6ad8dL+JzslJ6Gxp6PUJ641HE/6o3IIDC6x5pJVz9F1pTlEQJe91S4AZ4qX27mIK/655ta2KLWLIYZbXpNQYMD8xoM8oJ7icQmY4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=P2B0khVA; arc=fail smtp.client-ip=40.107.96.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="P2B0khVA"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iMCPMtvWCfy8+kMyKTq3CJc+zdq+Y86Xk0Aun1tpSWnddJqL3ZYf/n5pvPfr5ljrT6Bx6QO8paLcF1DVPHqVpeZVuctQo2SAQYVD4K8NOAEHaREJ1ZqTD8mcuiiUARBMFuEeuqOFHTOMeYtdHBifm1KO7texwuJ1M8dYmdRxm1l9VDundhRvAoWKoqH784qz1cUjyncwp3BiWCF2MuMgpv385twbx67RgVfvw+mfHmk6E8Kr/KSFhV6WOCT7tJz4+Okt1Zx48UfiB2HiZIlLSagCdYGLyauRBEhzuABERqT+dn98G6tK3k3TRpm8/a/BSTfa7c+gTERykgZfZsAlGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ae7kyfqNjTBSTfygKDMPCjnzFkaO+Bn1MFFiTrLVi64=;
 b=Bw4P5S2+Xr2EbdfzlvBf9ZYaCYI2aCNAv7yHQBsKB3nugZ66w913KYiJcKXofOiBFSFheGzHwruwgJfdW245hUE9S1ytytkFhLngXb/0TOS+rxuRxnXWYOwzSOiz24w7DuD18c3t41OYekqIO45B2T8eHsvcAsfHWWSA4CwlbfPSEHFjflVTPJ/GSlyzh6YiHbZGQlQrmjr+L4YeiBtwchh2xOC0twgE/sHAkf+xiOdZnwi379RpPMQ6LxyPTU3nk172MfdQopYBc9jduuxTzCuGR9A/cmMyMwifDLZ/iJ3xy/BPLBnrd1mm7R+Kk5UrnjI04vjY+Z7bWRL0KLCTOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ae7kyfqNjTBSTfygKDMPCjnzFkaO+Bn1MFFiTrLVi64=;
 b=P2B0khVA1PbhJZTSTxlJKFEJxdfDZuNN8rVjsO19d8qZM1W/ymkMCahdur9kEq9li56gN21tBBHSyqsNQLhX+slv9fDGSdXIIz+OAKL5l3U9M68LOyLxt+xMPg58g90bosb+QdV1N6A4r9wlasmQRRppa5y/vcLQKzk10R2m7KPpA4XrUNWP3AOFSs++B7JONKoS2N1JmyjiXucoK3xpGav0AIixnqxeZ6wTL9ydnm1qFvnj7cfS62MCnu6pQIw1QDaaUpGHx0AY1bECDwAqBGhJBHhpi0UoLDg4Q4QdKW0VNYd8oWrPAAM9gRy39+JymnzmPN6m4lfmeKOAmruCZg==
Received: from MN2PR07CA0004.namprd07.prod.outlook.com (2603:10b6:208:1a0::14)
 by LV2PR12MB5823.namprd12.prod.outlook.com (2603:10b6:408:178::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.30; Wed, 21 May
 2025 08:31:10 +0000
Received: from BL02EPF0001A107.namprd05.prod.outlook.com
 (2603:10b6:208:1a0:cafe::f8) by MN2PR07CA0004.outlook.office365.com
 (2603:10b6:208:1a0::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8746.29 via Frontend Transport; Wed,
 21 May 2025 08:31:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BL02EPF0001A107.mail.protection.outlook.com (10.167.241.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8769.18 via Frontend Transport; Wed, 21 May 2025 08:31:10 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 21 May
 2025 01:30:58 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 21 May 2025 01:30:58 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 21 May 2025 01:30:58 -0700
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
Subject: Re: [PATCH 5.15 00/59] 5.15.184-rc1 review
In-Reply-To: <20250520125753.836407405@linuxfoundation.org>
References: <20250520125753.836407405@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <95fcdba4-4336-405e-83f0-7343951f0ffd@drhqmail203.nvidia.com>
Date: Wed, 21 May 2025 01:30:58 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A107:EE_|LV2PR12MB5823:EE_
X-MS-Office365-Filtering-Correlation-Id: 298791be-a846-4300-a34d-08dd9841d704
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|36860700013|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TEpMU2JXVTRGb3Z4Rm8vaXhnQkN4YmpYd0J5VWJUaG1Nall3WFh4U2JwSklD?=
 =?utf-8?B?eGhSZHQ4NWZHRjAvZGp5bldCbExZQjMyV0RKZnhiK0tha1p3amQ0Nnh6ZnF6?=
 =?utf-8?B?STZMMW9MTUhXM2RlQTUxRHhIVHgzMGc4c3lpTzBsNFY4RHdsa2d3Zlp5eWpw?=
 =?utf-8?B?bGJJM09YZnNZWS9jY2xDUCtpb21jWjNVWWhuSmxQZGJXeGpQQS9IWnhNTEQv?=
 =?utf-8?B?VjN4bUVCYVJQZjNZT3F0TUdPMzlHd242UWZISXdMS2wxNjZVcElIZzE1RGRr?=
 =?utf-8?B?QUpHRVdqQ3V4TkcvRXhtWUJ0OEI1K3R5bzdWVEQ2YkVNM2I4ZUpSd2hHZ1Nq?=
 =?utf-8?B?YSs3cStNU25SZlVaQzZwMWNacThiNTFoVWIvUVdSbzdhcUtTZHlPZWdrWlA1?=
 =?utf-8?B?bXFDQXdLMjdEOHJpRW1KZDMweXhEYWJKOW5wdEEvVXlraW8vL29TVnM1aVk2?=
 =?utf-8?B?dGtHcHR1RUttN0J2b2dDY2lOb01QSERTQndEZzFRNC9vQ3ROY0pFVmtsM3FL?=
 =?utf-8?B?TC9IZVFtNnhWTUg4dmE2ZWJ0MUk0S1JUbldaS0hiQmp5S0swNUVoeVM0bWNs?=
 =?utf-8?B?akpoVEJBU3hvR3NFTnBMdDVTdll0QUVrTGprNG14aDJFRnhNWkxEZG9DV01I?=
 =?utf-8?B?WVczREVadmlCQms4VkhWRDVxOWxmWUJGR0UyRzFQYi9lNGowNDBQSkdVdkF6?=
 =?utf-8?B?VUNJWGthRkZWbWlyKzhKdmh3WllUV1JkUVJvcHlON2JQbkk4ZUoyQ2VUNlBV?=
 =?utf-8?B?cEFnQ3RWRXlROGFCVi9LcVNPdDJScWhBc2FMeWhhaklGRlpaenc1N0liQ3dF?=
 =?utf-8?B?UlhZckNEbksyTVlISkdBcjlwOEJ3b3E0em9mYm9neUV1L2hvNmhScmdoRDAv?=
 =?utf-8?B?aGJwRm13eGtkVzQrRnRKL0p1TFlucDZBUUlDU0lDS0ZvejRCRE11QTFZSWR2?=
 =?utf-8?B?S2hOMGoxMlkwSG5tT0ZTMDliQVpaaGZRdUoxMURPL3FnaGVaRjdMQXpKSFB2?=
 =?utf-8?B?NGNSQy84Z0NhM25nRUk4bEt3NDdoY3FjckRXNE12T0RXMWFQa3JLb1FIRUtV?=
 =?utf-8?B?ZnB2Mmo2bXgwaFA0bUhCVU4rajFwV2k0dWpaN1Iya2h4czhKTjcyZ2hGblRi?=
 =?utf-8?B?cWFvY3RMYTVKTGtlMExrcWFPdnRRWXdRSkhwakRXR0M3QmNjQXlSVmJrM2Zn?=
 =?utf-8?B?RUZ6QlAwNWpWMWZVdG1WeDhuOFlvUENCdXZmVlJKOElYYnJiUWxYWDNQQXA4?=
 =?utf-8?B?V1dmZGtZTjdUNHJsSGJIOUxXK0NqUjBUWVkxY1p2N2VFQUJ2ME9RSTJjbXhi?=
 =?utf-8?B?MktmMzdUUUZtRHBCUmE2MFkxV0dNUndLZk1nMDRjQmVob3A4RzVHOU1TZ1dv?=
 =?utf-8?B?MFVwVGhjRTJqU3ZLRlAya0UzdzJnTVZtVjZ4NkFRS1RjN2NYWVRkOUUxbzdH?=
 =?utf-8?B?MXIrZHQ4YkV0U1lFWlM2aG5qTWpTRERmLzVibDBod2NyYnppZngrcUFkWEI4?=
 =?utf-8?B?cGkvdEc3MWVhNW1xTkJpdEFUR09QZ3Zsc3NETWE4cTNOaW1vc2I5dGNwb1ZN?=
 =?utf-8?B?anBqMjRqRWxPZ0VIT3FOTTNwSE1HaWRkOTluNWN4b044MXhOMVk4YndzcEZ3?=
 =?utf-8?B?ZkhWTXdFdkNRbWIzR2gzRk9aNi9RMVZySHpjcSswSGplaVdrQk9aZTdCTEtj?=
 =?utf-8?B?b3oza0dITXEvaWs5bnQ2MmNsdXlXMFlvNkV4cnIzSVFuMjA4eG1tbmx5NEJB?=
 =?utf-8?B?blRuTlZ0YXVDb3g1TERCWjdTQlA5QTlRaXpBLzlFMEYvMXZmN0Rmdkc0cHpX?=
 =?utf-8?B?Uk1WbU9FTVBiSFR3QklLZENieEVVbVUzSFFYK3V2L0FnTjJFazhpV0FPMXZn?=
 =?utf-8?B?bE0xcXJsbzVDZG1LWHl2WlcxdHN0RmtBK1dRWGQvNzNNeHNlcDB5emVPazBJ?=
 =?utf-8?B?STQ5V2pNMDZSOFpKbm5qc201Nm8yVXROdmRvL2xGZmdWMjR6WVJ4R1dNUDM5?=
 =?utf-8?B?NzJPd0dDWUZhUXIrQ2VrSlZYUFpUUkV0TlRsWFhtK3I3bFpRdVFCbnA2YVVt?=
 =?utf-8?Q?RfHr/X?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(36860700013)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2025 08:31:10.2207
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 298791be-a846-4300-a34d-08dd9841d704
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A107.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5823

On Tue, 20 May 2025 15:49:51 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.184 release.
> There are 59 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 22 May 2025 12:57:37 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.184-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.15:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    101 tests:	101 pass, 0 fail

Linux version:	5.15.184-rc1-gba6ee53cdfad
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
