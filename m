Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2066.outbound.protection.outlook.com [40.107.223.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D72C48F4A
	for <patches@lists.linux.dev>; Wed, 25 Jun 2025 07:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750836272; cv=fail; b=eDqgKTZ6pB/Aeu/C1Wh7tO4/cm7SBoPY5CDl6XBTpcE7i9qTBkltcQ94b3uaomKmJvvd9Au3u6nk67NWGum15oCi3uv8cwsSp8o6hnfpCDvS5F4LEelFqnruXV/lU2CYz2KHoagjzcVF61iqfQ0mdwQavt4NtI3qb840JWDR+m4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750836272; c=relaxed/simple;
	bh=Y/zkOOO2mgze64NU2Z1cKrSkOIzNQwcfXhgvs+zQ/ms=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=DetRJqQSbjbdJFEQrY/l+tDA3rqSdxKSCOfA8rQFkxBL5eqzQhBHzfqErhdb3gnvHevzupKxyUQ18yLkYVAHfWaxfaanaGDErobF3KrgMg5vaVEaLKZPfBzO12mOJL264tbW7wEazAmVEZ/kGTPQq8CoX+BMuRjMc02gOCWEAIc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BBKV63TV; arc=fail smtp.client-ip=40.107.223.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BBKV63TV"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jTV8/2I2STMyK6H8iq/tWR8R8TcUAAI9H4XUd8UNxKtY/L4SrcZG5ELbzaAUYk6FhySsYlTdMqNm1u5adX5i8GTg4tHsFPZJs7LscuM6BUVkKudxeBT3K72n0ExGvSwy3nJugt4xq/gK6Ihl46TPMQWBCR4I99PaWSYCsC6vRhobVhIKH+n2+FgvsIrAVbWa0erKNZELQeMJAwFBWMc1AESS4DEsfBlcUUB0F6u6qRtzm6g5CHgGgSLWO/XdoF1RynfZSF6AgTSOKwWRCOnJNG6/xfveU0QVYtbA1ySWEE8JfKOyBuboFMOuvpkslc58IKJbsr1j4ckOOk/9T3cEOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x3daLUSUy5KAcTegmCUnN5GBjM72MSNrzjYBYY/OQOw=;
 b=N2bHCWn4Ek8lgIVqg+qIMyM+J1EAFNxVK3MQqzr7nMvdXoB1LMxlnfzEldvq6zMNBHgZmqJ/QOBQR7zi4yYnwHbk+lIHy3YjLUxC0iNMISHjtN9gp3SGyiT99K+BfJftCW2J+yoYHnGsi0/yW8VqAGgRCGZgWhCAmmY3PNYk26ufK0aIhWRwC2CCLqn5lFS5AYVT/Zaa3zjL75socI9pkyaNDnAKe3sl8OodmHD3HYn8rqNr8IV8cX9KUqjKesvs3kav8FzMefMEpVaPCNKlsg2e5IexcDcztBoiiwmOFkVJPumdlF2itM9FFPBylqJotmfBqh5N5fYH4APlb82Vsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x3daLUSUy5KAcTegmCUnN5GBjM72MSNrzjYBYY/OQOw=;
 b=BBKV63TV/W9E1yX3zpiQ/lTD4O2KGjKNdeseYoQKqlJC+NKaPeJD0FMHn/tpII0gRqH5kCjB0Kn+AJc78P9SGeBD7egIYOkRdKvNmDKmxL+XiYf4s31AmF9+u0dUVekITdVTQVxS/kBfOcjKcw20HBm5QjNmXl7HzMZ8J+pgsAVu/u80uPInZ1voRzd0+sQE/50QJ/UPdob+3WsLOKH09CLiTJDHEhuIb8pxCyc6mt4q8TV3NxoLHSNbnCG95saMAoMi/ws6n7WEezT+m33BUKBFuP96VqCdJVtqU50AKOVIcy227nJx/ep47HkwADc8Wehb/BtmmP55jVfMp0vFBQ==
Received: from BY3PR03CA0010.namprd03.prod.outlook.com (2603:10b6:a03:39a::15)
 by IA1PR12MB8586.namprd12.prod.outlook.com (2603:10b6:208:44e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.29; Wed, 25 Jun
 2025 07:24:26 +0000
Received: from CY4PEPF0000EDD4.namprd03.prod.outlook.com
 (2603:10b6:a03:39a:cafe::c7) by BY3PR03CA0010.outlook.office365.com
 (2603:10b6:a03:39a::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8857.30 via Frontend Transport; Wed,
 25 Jun 2025 07:24:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY4PEPF0000EDD4.mail.protection.outlook.com (10.167.241.200) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8880.14 via Frontend Transport; Wed, 25 Jun 2025 07:24:25 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 25 Jun
 2025 00:24:09 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 25 Jun
 2025 00:24:08 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 25 Jun 2025 00:24:08 -0700
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
Subject: Re: [PATCH 6.12 000/413] 6.12.35-rc2 review
In-Reply-To: <20250624121426.466976226@linuxfoundation.org>
References: <20250624121426.466976226@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <413a2d85-a9a0-4639-8dae-643b1af6f9fa@rnnvmail205.nvidia.com>
Date: Wed, 25 Jun 2025 00:24:08 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD4:EE_|IA1PR12MB8586:EE_
X-MS-Office365-Filtering-Correlation-Id: e9daa5fd-c53c-4988-d79e-08ddb3b9502e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|7416014|1800799024|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VW9nUHh4NGkyaGdxUkNYZ0FzOVViM0JIcGFiUldQdEJSQzcvdmsrQXd3Zzg3?=
 =?utf-8?B?UnUvSkJ4QmtEUklHbTBLK1lvTndXdUJ0UXFYaFBkY3BrMDFjcXNFNTJ5UXhN?=
 =?utf-8?B?Tit2RDNvbGZJMTMxUVhiRVEwZzdpVjZTRG5KMSt0UEVNdklSdWFQa3pMbGh1?=
 =?utf-8?B?UUpxU0NvYUpoQWZYYXdrQ0JDSE8yTW9IWXlaT0l4OGF2c1pyUmxGUG1POTZk?=
 =?utf-8?B?K1pQVGEyck1Lb05vb0YrSjNBaFY0aHUramlJaUpkRlJJSmxTeWloRWdMN1dj?=
 =?utf-8?B?VWtKemtuSnBBZ0ltOFUxeG54V2FVUzkxbnlKQjZHeHlRN0hIZXZLODZzNGhG?=
 =?utf-8?B?WGR2SHYydmxGSm5QeXFzU2l3ZUd1VC83c1Y1d0NRMjJ3dVM1YVFaOWwrQThJ?=
 =?utf-8?B?LytPM1VqcHRidlBnOGRrV2hKWTRWcDZnbk5LVDhTdm9NSzVNeUcyNUNKM0x2?=
 =?utf-8?B?S3BXWFl6bDhKeUptV0VnSm1tbnRIdDlKSDFBR29HQ0x3VTNHbXVMU3N6VmpZ?=
 =?utf-8?B?cjRuL3RMVlAraXcyQVkrdnVJaWxTZkYzZlpmb3RtY0QyMEF3b0xHNTlvU2dL?=
 =?utf-8?B?ZGxFcFhxdmJpM21KaTZNNmZ4Mk1USTZSQThHUUJmNEJ4UVlRVlJWcWt0dWZ0?=
 =?utf-8?B?V3phSW9ZR0c5b1RheXRSNXJMRk42K251Sm82ODR0clFVQXFXbWpWNVFyeVVZ?=
 =?utf-8?B?VktYbFZkZlVFYnk3b2xCMytoRGhORk1LVGpQQlpURkRVUnlNTEtmUVhPeWh5?=
 =?utf-8?B?RlQxelRiTnZ2dWJiSGFNMkhLSHFLK3d1bWhqc2t6SHdYV3Vkdmk3L2ZhL3lK?=
 =?utf-8?B?eXg5cGxicEp1a09zNVR4aFAwOFF5NHhZVW1lRWJucHhGM3dmV2JYWGxiNGNC?=
 =?utf-8?B?dTZyVFVkclFsOTBKV2FQSVpwdWVmNkl4WHN5TDRjaDk1Q0plZnEyWjB0S3J3?=
 =?utf-8?B?L2ZLeFVua2xDU1RaRmpGbWgxaVVzR1p4Tk9BcUhPcXZqS0w0WTlRbEFrS2tn?=
 =?utf-8?B?RjhCMXVZM2R6aUhERmZkNXp4Z1JkeTk5NW9GR3FLMGpOVnhuZXdBOW1VTU5v?=
 =?utf-8?B?TU45cXlpQlJ6ZndyU0NkRVErZkhaT25IVzZacWVNb1dUcG9UQjZ6THBvOHBX?=
 =?utf-8?B?N3dYY3pNdDdRenQzL3o4bUxSSHpLM1N3WUN4NkZFMkdCalpoZS9IUm1BZDFo?=
 =?utf-8?B?NzNpZXM5WlV2MHFMUmtvYUdFKzVHTDM5bE1tZjcwbCt3RVJGYXUwajNtSU0v?=
 =?utf-8?B?djNtRWxuR1NYZDJUNHlRSVI1UzloQStZSUxDQnAvb0RQQ20zRmd1OWtWTjAv?=
 =?utf-8?B?eFFpN2Y5TzhNeUJML0IreUgyUnVXb1FVTmt2MmZKNnIxMVNhYUlCSU15YmEx?=
 =?utf-8?B?L1U4V1ZlZVc1emd4dzFKVDlMdWVSRFdCRFV0aXFDeTFJMXI4Skk0OGFsN2o0?=
 =?utf-8?B?Tmo2K1pOdTFFbC9QaWpDZU5JYW9vV1RtOEQ3Z1dIdDFjRElhMmFES1piTHZX?=
 =?utf-8?B?ZFNvRXc5Y2NrVUtYNXhNSzM4dEFaOTJ0bW9YWGYyeXJsVXVHNDRKcFNtd2FM?=
 =?utf-8?B?OVQwQkRhL2dKY21iMTRkM0cvbTBXUGEvTEZEM3VEYTNDQzVZbDI1QjNZbXpD?=
 =?utf-8?B?Z1d0ZE15SC96ZkZMZVU3TGFOWHJYMWgzbTgxci94bytJbkdXSnJBQ1RucGQr?=
 =?utf-8?B?Nks3WW1jTW90bHc0YlZDNzhDd1ZzUWhENE1WWlpZVk5xcnpucFF5OU55STBw?=
 =?utf-8?B?Snp5RDhwaEM0UytWaGFOdUZrRkwzOGQ0dE41OTE0N3RzQ3RVdHdOWUhqMnRt?=
 =?utf-8?B?R3p1cFFsbi96ZkJ2T2lCcjdEVThTeEoxMUcvaDJmTEg4T3BvV3I4Q2QzOGNj?=
 =?utf-8?B?cStDa2FuVXdGTWRTelNLeGx3YXN2ZWNia2tlOE9BU25vb3d6N1gyWXNQeEl4?=
 =?utf-8?B?dURaRnBmVGZoSlI0RFFBeXR6QWdJMDR6UnZJeHNpYmVIdXJoVHRtRzFjbUZM?=
 =?utf-8?B?V0FocTNXYVpMSEF2YVBQclhKRVhCOEgvY28wSis3WEpFUEw0QTdBWlpyRU5C?=
 =?utf-8?B?eVNaU3R5dUZGUHYvaDh0UWZIYzJlOEhiTGNzQT09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(376014)(7416014)(1800799024)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2025 07:24:25.0718
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e9daa5fd-c53c-4988-d79e-08ddb3b9502e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EDD4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8586

On Tue, 24 Jun 2025 13:29:53 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.35 release.
> There are 413 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 26 Jun 2025 12:13:28 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.35-rc2.gz
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

Linux version:	6.12.35-rc2-g7ea56ae300ce
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
