Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2075.outbound.protection.outlook.com [40.107.101.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4D5173502
	for <patches@lists.linux.dev>; Mon, 10 Jun 2024 09:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718013421; cv=fail; b=BX7rKRCZWuWyliZkk2WCWvMYEzyDqcN5/dNcnkPn1/kb/gkrs8tebPkBBiBD9UHXKAqAOwDVAL/2gAI63zRmKfss79Xu4Esa1O+NDceASyXYWhavJpfkS/gVl6j2ARWMi8MUosH4/ZqFxlpU/YUrmDw6+ICFHuu0LZ3WkgqK8ZU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718013421; c=relaxed/simple;
	bh=2+gM5B6OHxO88DWWN60o9FwTuKgwM8+lmwjCZUtM+4o=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=SpyzTs5qj2Mx6AqxjhMV0XEMwKWMuQtTXepH0wsBzgD7klnBxn7+PI4MckK0O9j75+Ccsxki9uvZc5evdFQATfODc74EyulXCFEvXg6jTHOyNYnJSA3pRl+aYpFCfOEzF0fXwUmRJzTAmQgpWt+6dO50m0AaUEeinUFYOhK0T9I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=VP6MXRfk; arc=fail smtp.client-ip=40.107.101.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="VP6MXRfk"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rf6vm/n0DeqPk5c+nwgdr3JGpL0gltP8Nim0cD78+Vuk6SiX9bfN4AsthJAD1cef2W++dbJLjxoD0sFj7Nnt5blnzZXyQ0t9ddDACS+N/BuUdJ1UGxhm/Ssb3Pk1A7kC0JMLfO/R/YBEmj1/2AUPUU0QZDvXdrfm7JlcLsJY/cdRqHT5zd5ZJmqH57+jvcYaU1IBA9OYLwGSek02BJwolRfJgnSolQKyqqTMrzFC32BM8lrX1HMaraul8X6MyEmLRdN2u6+K5ScH6dgBHQrVUVV4IZNsEndruBD+v6qRcGhEV/DerkkjHQPnsqP6TvaoekVznjGBkYPWauF8e7GtnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hw0YV3l9VvSx+5+SqyWCGxFN52y7oV0Xif5sLIFFWBI=;
 b=MHxGb7q3lxA73cREGHkoYiw9lIb38OsXKOCB6wDFLj5kmwluAAkzFfjsMLUlEfYPKH2epQ+dvlBUMBJMA4cJMvac2I4TNK+tp7VOfBk4gSDB9jNSRq9NKz0WkxlqSA4JfcCPAYUMeeFDTTfs3lxF85up5pk4sISeDdES6YkPBUgNG9DxeP27issp24rf2AIQq6auLwNptC2akoLVELQZn/2MsSyewOr6S3ufvqQYiu3dspLzWjKQ8XtOyyzzf0Vk2lMgQBd66QmxlKrBvasdxJxvxr8OFOSdzebnkKb2KnfHlhbcW7pK5yi34S8Ms4A1fgCrOrhkOoM+PpRUBCPDaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hw0YV3l9VvSx+5+SqyWCGxFN52y7oV0Xif5sLIFFWBI=;
 b=VP6MXRfk3Avo3vGlJwTIStx1yrSoVGmtzMVAJu2nwTW2DeqFPyHX1fceG2nDIEM1e/rNLNO32VzgEYAJIJPBTk/jfBrjv9ih9RrcbZOdOukbAHD4RmhId30SikCjK+Lco9F/DA+toPIPoTxVubJWrQmCdJbBdQWmPr2w63yhLjhV8I+Svog6bjcyvxl1EGf9HX2NW7D7h2yfGD37jC4/QFl/iKvQm2k+FJLwwoBpu9TxeExERAyskJ64qus190D4/YdGglf9XEFPVIt0erbWlns7XJvKEFzfdI8X9y7kqCeW3ag4oLw4ClZP7jNcsRRZHC1Ss0WscupqS8+t+IsIDw==
Received: from CH2PR05CA0021.namprd05.prod.outlook.com (2603:10b6:610::34) by
 SJ1PR12MB6196.namprd12.prod.outlook.com (2603:10b6:a03:456::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7633.36; Mon, 10 Jun 2024 09:56:56 +0000
Received: from CH3PEPF0000000F.namprd04.prod.outlook.com (2603:10b6:610::4) by
 CH2PR05CA0021.outlook.office365.com (2603:10b6:610::34) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7677.17 via Frontend Transport; Mon, 10 Jun 2024 09:56:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CH3PEPF0000000F.mail.protection.outlook.com (10.167.244.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7677.15 via Frontend Transport; Mon, 10 Jun 2024 09:56:56 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 10 Jun
 2024 02:56:48 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Mon, 10 Jun 2024 02:56:48 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Mon, 10 Jun 2024 02:56:48 -0700
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
Subject: Re: [PATCH 6.6 000/741] 6.6.33-rc2 review
In-Reply-To: <20240609113903.732882729@linuxfoundation.org>
References: <20240609113903.732882729@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <116d80cb-7dce-41d6-b279-90201e253d7e@drhqmail201.nvidia.com>
Date: Mon, 10 Jun 2024 02:56:48 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PEPF0000000F:EE_|SJ1PR12MB6196:EE_
X-MS-Office365-Filtering-Correlation-Id: 516b260e-407e-44e1-f09f-08dc8933a9c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|7416005|376005|36860700004|1800799015|82310400017;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?a0xXUVdpbWdRelZMQVJzczFBZlE4WXlIYW96c3Yyd010SW05WWhaYytBb21j?=
 =?utf-8?B?UzljTlF6YkszSE9sMDcwbnNpRXEvSVpFMkVlVmxxdTNXa0FGUTh0Z09CZTQ1?=
 =?utf-8?B?VE9TbDNpc2srbDJ2YXVxNmRkRC9PU1A4ZmhmQ3d2Y2Q3MDdSVnNsT2dPNFVt?=
 =?utf-8?B?eVEwbndRZXIwdEMyMlhpWmNDSDRtelVRTE02UDhmOThRYjJ0amxyNUkzbHd0?=
 =?utf-8?B?aVlzOFNSanhISHBsRnhXY0FDVzI3VnNESit4RFYxL3l4U3JFOHVXU1prUHEx?=
 =?utf-8?B?UlFGQ2c4aFJYN1liTnFDZ20yUnowTFRzT2E0MlZ5TWpOU1FmbndOUXFGMjNm?=
 =?utf-8?B?UzB4UGFQZlhGWll0QzY2TjViYUs1WW1MMVhGV2V0cDFYenJUMEhkM2tPZ3ND?=
 =?utf-8?B?TTk0d2ZQc3kyWmJkNUFWZjE3OGFwZnQ2WXlOcVJ3T2JLUzdyVXhWMzkremhB?=
 =?utf-8?B?a3BYemxiMmE0eTUzV1kzck5VYUk5QlhiZGVwRkZnd2YrQTlIWVRnTEIzTWl1?=
 =?utf-8?B?dDdta3pZckM4ZUIyTDU1b3NjL1ZzZGNQVmc1MG5wcVdwbVFxSWRIMVhBK3BR?=
 =?utf-8?B?Qk5qUG1hQkRvcWUxVUxxOERmb1FNem1ZZTVZSlRoZUJHNGpjZGo4UnZDUVc1?=
 =?utf-8?B?RkM1T0pBZGxaMUhianc5MHZFS0IyL0dzNmtkRVJwd2RTcTlFZWFkUDJZMXJM?=
 =?utf-8?B?VWlTQTVQMDVjUE1XQi9zK3ZLSGRHQW51Q0F6dTNpUnRiYzg3d0EwcUN0Zitw?=
 =?utf-8?B?aGJqQmx1VUdDcFRkMklVakJ0dzAvd2JiMFFIaTc5QTAwbXpxeDE0MUFHU0hh?=
 =?utf-8?B?LzYzWWxQMkFzNXJ0OUtwejd0eVJWUFppY3Vkd3lPM3lhS0JBOE94QXVRak1y?=
 =?utf-8?B?bDIxMFFzc0p2MitySWJLYzJZM0tnZnJpdnhSNG9ud1ZwV3hDRWc5YWdBL0hu?=
 =?utf-8?B?QzlNSVJVeGJYVUdLcUFHOHpJZW9CekkxMHNsRkV5YXM3VmY2NXhCUFk5ek1l?=
 =?utf-8?B?djlkK0wxVG5YaWMzUFl6T1ZmSG1tTzBrVTBwejVPaVNEbUdQM0REa3pPMFVF?=
 =?utf-8?B?T2xNSmYwWWtaYnBoWGRhY3ZXaXc3QWRXZ1lrajQ5MDBjZ3gwVUpPOWJDcWdp?=
 =?utf-8?B?RmJudjl3bjh1Wk9xYWdOUDlRajcwdmJuTnZwR0JnNFU2WDNTdzRSUFNPV3Qw?=
 =?utf-8?B?N1JsQmNaMFRCUGxlZWFpaE9nbGtIejhCQ1pPV2c5RFUwK3dUZTFVQ2x4VDlN?=
 =?utf-8?B?QlBaa0tRU2FBWjhVMG4zaVQvelYxRndCRVVFelNpTDFJclV6anEra2RFSGFV?=
 =?utf-8?B?RGs0RENQelgrelpCT09WNFdUcEVCK0Q0UHNxdk0zRmM0ZmNNVXQ2a1h2cDZ2?=
 =?utf-8?B?dXlMdFdmQmtvK0dQejhsUVFkUEF3b1VFTU8yODQ1MTdxTXMvR2wwMUJublhX?=
 =?utf-8?B?Und0NTJJbENxckh1aHQrdUpPemg4VEk1aDFIcG1qTkRnb0VtWGRtZzM0ekw5?=
 =?utf-8?B?V0QxNjhiQWpVRVhSemVVRGwxUk5wRURhWXZqMldmMXlCRnNMeVRCWU9hNjJZ?=
 =?utf-8?B?Mkl5OEVBU0VRM3pUNEkvdVdEbkpTYy9LUGRGNFdnMUJWOWJ1WjB6WVcyY1JM?=
 =?utf-8?B?TmxSUVV2cGhyK2FrR2pyRHVXSXRBMHBkbHZ6Q2NWS2xSRUl0QlJKWGhDUUtK?=
 =?utf-8?B?Tzh3cGRYeGdVZmVBZFhzdForRStQVUVNL3U0VEJQK0YycUltb0owbmtNcTFF?=
 =?utf-8?B?clJmQUw0ckQ3QWVUbGc1TzdEbU5FSkZHbTBOVnJKemw1RmE4S1FNZE5ONkZm?=
 =?utf-8?B?S2dWYlczYk9wVUZaMVBRQ0Y4cDhpUWJENzhKSHJYMjlHamI5bTVoVm9mMHQr?=
 =?utf-8?B?c1NiY1FYVDBNVS9yWWllWURUcjJBQ3VkQWJXQXNrV2xFQlE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230031)(7416005)(376005)(36860700004)(1800799015)(82310400017);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2024 09:56:56.2758
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 516b260e-407e-44e1-f09f-08dc8933a9c1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF0000000F.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6196

On Sun, 09 Jun 2024 13:41:16 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.33 release.
> There are 741 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 11 Jun 2024 11:36:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.33-rc2.gz
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

Linux version:	6.6.33-rc2-g7fa271200aef
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
