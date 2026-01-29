Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010014.outbound.protection.outlook.com [52.101.193.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D95C126C17
	for <patches@lists.linux.dev>; Thu, 29 Jan 2026 09:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769680164; cv=fail; b=u5DqyDghobTm7DgV01393UNFHzN1KLsnPD/Ljvx6anXr3jAvbv5OHkFTcbGRXPewhneQzTtSh2QZZiu3LZEddAjpRy096xVlcSojA8Q4qHEVO1RteExAa/GpQ2hOscmr5aj2LFEUy7bnSxZwWXALSLVyrm0luc/UWZl0gH7OTzU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769680164; c=relaxed/simple;
	bh=rkxnuu0Ek4mw7tFzjaADbCk41I0jNV7bdsFkxHjWIE4=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=jJiZ1h1ljageI+VBB/YPdQMNDMk+j7YislbBFPdZorbl3FLajbj4vfwo7tYylyJsIkGTOLqAw6e7cD8TBIZl15wEiK6urPArzecP46AiKJtW+2IGx+UrvvZ3rk7Pj5vE7bbY+blAQZ5N/+1T7cXO7EI5cge4hWUdJzgD1HOGTXs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hCpYgD6N; arc=fail smtp.client-ip=52.101.193.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hCpYgD6N"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SYsD8dievktDStCZrDPswFPISQ3eRcR9TyRoodf99JdZ2Jize/lytM1KL0jGCHlMYm1tfE6JkKOD/EJUqU1XQcOtFUsVPNzuPw/2GdMfqfun0I/LmnxES3SFTU+g2Lx6iKwo91dNGAXNpEZPwTcGbUobH1oVNXL1kRBkZZFkxH3FWnG8QFFytQy3XxJ/EX4fEtJsTGaQkZTYyCfaj4WVKaeIhgVcC4mv8551MhPBNU9IbD/0NX4BsjLlYedwx/jlVFu83gFKX0yuiuisA1ybruBcbMsTCCsfF/5Xg3MYt73gQwzOzcYySSQGNFVa7TYKt8nM/1qGVEP+gu12ePFxDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I8aBsdYBk1T1JTxczCsz9hOYEfmv6tLa5LbTgHo2tMQ=;
 b=ItLciPKekmGc+HdNeXaikPRDmXxG+unlk6dGVbWdbUAj2PI+UcXrrE35TPqdYo0YQGl49CVZ56MVq1nRB2J35FUY6fNq9cFgP+HHLgjpBj4VGLUFD13ZqxPBd0doqOZ0QBjbkX0k5R4uSbPG5LbD30fqp2nr0vDpzfuJqKZL+XDvDoFiy2UghMN0Z0ctZ+uymoA2iyhRRC3RQx/ZGx/tDTVGKO0b0ubrtuo7Z9cGyrwGNSTagZgngBXtuC6S8w23S827B2y1IBlLovjA8TsbSC/UyCxy7SeLv85Q4e2tTTZQa+ZXXBTzXplLHnd4BBfU5YZFxoGb/xJirvTyFlZ8/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I8aBsdYBk1T1JTxczCsz9hOYEfmv6tLa5LbTgHo2tMQ=;
 b=hCpYgD6NuF+VgEaqtJb48eZlOpigo/FstAm8GzxWhYlnRMNjLZjn9DamUXq4hzEjzg34jJIFGonnNIHojLFAt8TgoBuUbaPJtUETLMOfdlbIQU3kZGrJEvPgsGeC7ao3CSx5PyYaNC84lFEA6hxedfiOCG7tm7VQuI4JCg0LMPFf8s+6jC66fVtEl6maXrl7v/3rP9m4D9NzNm4FQOIZ8hCvdxiNFeEqRBSLxWiqNmI6Uf6+7jsHkhQBJYn4XrJjb3hKs8rA2/vGo6IayIfvcTIzC2bT7Z6V8MXNVmDSC9Loor7YEzHlc8cgEAxZvaYX6KHmykubOWYuso3JiX5xng==
Received: from BY3PR04CA0022.namprd04.prod.outlook.com (2603:10b6:a03:217::27)
 by PH7PR12MB5975.namprd12.prod.outlook.com (2603:10b6:510:1da::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Thu, 29 Jan
 2026 09:49:17 +0000
Received: from SJ5PEPF000001D4.namprd05.prod.outlook.com
 (2603:10b6:a03:217:cafe::5c) by BY3PR04CA0022.outlook.office365.com
 (2603:10b6:a03:217::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.8 via Frontend Transport; Thu,
 29 Jan 2026 09:49:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ5PEPF000001D4.mail.protection.outlook.com (10.167.242.56) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.3 via Frontend Transport; Thu, 29 Jan 2026 09:49:17 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 29 Jan
 2026 01:49:01 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 29 Jan
 2026 01:49:00 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Thu, 29 Jan 2026 01:49:00 -0800
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
Subject: Re: [PATCH 6.12 000/169] 6.12.68-rc1 review
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
References: <20260128145334.006287341@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <6ac08aaf-e877-4b07-ab00-3fea8daaade6@rnnvmail203.nvidia.com>
Date: Thu, 29 Jan 2026 01:49:00 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001D4:EE_|PH7PR12MB5975:EE_
X-MS-Office365-Filtering-Correlation-Id: 70ea1ffa-eb73-4a61-9313-08de5f1bab59
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|376014|7416014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VnRxY3lSUElFM2pkN01yVFgxbGJleWN5UU5iU00rVWJ3YnRJVkNHbXYwbnhB?=
 =?utf-8?B?OHBackF1NGpCYnNsak40N1lGYWV4T2lqZ2dsY0pOTlV3bHhUZ2FZcGd4UTUz?=
 =?utf-8?B?WjVlekEvZ25naFJ1Z0RHYU5ocXVLZklDdGtod1dlcHMwd01EY01FL2dyeCsv?=
 =?utf-8?B?RHdqM0s0UjBmYWpPNHBxYVdqcmxBOVBNMldDYWg0SmJGWDNqM2pvL1p1MWJS?=
 =?utf-8?B?a0xNT1NlZXRPYVJJdjNnUHduOU11N2QwTGNISWY3MFQyajZUTmVxMFhlbGhk?=
 =?utf-8?B?MkRidkgyQ3dnLzZvdThHbUkxRHpvWk1tOUhIaU80VTIwTjNpRWF2V1N4UXdL?=
 =?utf-8?B?dWdsQ2RSUk80cU1Cb2lRWnlSS25Tb1dFWUhrb0RXSVdKeFFmQ0hnWlRzMnA1?=
 =?utf-8?B?TVBGeDRORzcwQlB5TWZ5eXp2V1BoYm1kdlZRRk5pVzZLbWU3UVBRcXVkTnlH?=
 =?utf-8?B?Q1F5dEFHcXczbHBpYUk3cE1VSVREcmo2WjkzaTk2MVNWTGQ0em16K3NwWnl2?=
 =?utf-8?B?QXBSWURiMW1yd2JzUkc2NjRMUmZhQStmTjNYSGRsTzhyV0hJMlRDRmNSTjJx?=
 =?utf-8?B?dUZJaC9WWFVOYlllYmVXYjZmVEY3QkFMa2pLb2gxQUdnNDJPOG1VQW1pcGpw?=
 =?utf-8?B?VnZ0d1BKblFoWTl6U21RQ3J4bitsZEhiaHcvSzMrd0NwelJsQVluQjMvbXFT?=
 =?utf-8?B?NzlmcmRMeklSa1MrZWtCSkpHNFRHT08zaWpyby91RkhmVGU5MU1raWpjSVJ4?=
 =?utf-8?B?YXdPdVh4bSsxVGhXSEdNVXAxeFVOclROSU9WdHI1Y1N6ZnV3dzR5N2ZPUjFG?=
 =?utf-8?B?KzNHZDZycWNrWWxiTWhwWTMzdXRkKzZTMkpGNWdqODV4cFdLWnFKMHlwOTlP?=
 =?utf-8?B?WEl0UDlxQVFNUXlvVEpTZDdwS3k3U25WZm1IYkVYY0pNaUtscGpHbFlROFRt?=
 =?utf-8?B?MWtIV0tZSXRueTYreU91dFUrT0UveDNTU0c4bzdQVWYrYXJkR0VCZHVDTll3?=
 =?utf-8?B?cmVyZHc4bDNacStWMlBwT3ltOENBMld4UHcreExqSXJmTDJjRHl5VlAzNU0w?=
 =?utf-8?B?UGFEdGFkVCtSNGdwOEdpZmdjNHd0UWMvdDdIeHNnc1RPdVA0MTBhbHBsNGhl?=
 =?utf-8?B?bDBwY2hqSStxNjJPaHBUbXpxdG5EZmlZYzNHS3Q0UmVzUlNmU1pEdWZJd1Nm?=
 =?utf-8?B?clBSVW40ZC9vWlg5TWszQlhnVTB6MzNwbGRqQ0gzZ3k1TWxBYkkxK0diZkdF?=
 =?utf-8?B?WW5Kb0NCdUJZdjYrSjRuWTZxdzFHZEpwVll0bGo3WDBrcWVxdkVoeE1peWRC?=
 =?utf-8?B?LzR4MkNCUCs0R0xoL0xyQmM1Sm54Zm5wUWV3YWFZNFh0ckxtSkJJYVBJQzBF?=
 =?utf-8?B?THZ0c2RzZk9tczdiRGEyRS9YYXBqYUVYQ29pM0hRa01rQkxFWU1odG0yRVBS?=
 =?utf-8?B?eUF3NmZYT0lFTU9yUHdUM09zeUdMVXk1ZWVjN3NCMmN2SzVVa2FINVZVSk16?=
 =?utf-8?B?T3huTm1ENUdrZ0lyTVhzeWFqQW42STlad2pmUjBIemR6N0FQenY2bENRQjNk?=
 =?utf-8?B?MXp5dldVWk5Fa0FvV1hxT0s3MVVPY1RjdFVTdWhSSlpiSm52MU90T3hQZ0o0?=
 =?utf-8?B?dDM1QnNnVW00UkdKdFZQQVBHU29ha1gzaUZGNlFlVDZoYWZ0RC83YzRVN0Z2?=
 =?utf-8?B?Tjl4V2FXaU1LTWtOMCtMSWpEL2pudE5aRVl0SkQ2UkFJUnc3TlhHZ0FGTG1I?=
 =?utf-8?B?aVQ0YlNPM3lURVBQT3dMR0R5ZWVrMm8rZVFHMldpM0pZdGtYL1lkUFNtbHc2?=
 =?utf-8?B?VTJ3cllpQU9xcFhoSThDZWRYSzNWQ1EvN05XVWZ4QzN6aEtRZ0JwS040Z0Jh?=
 =?utf-8?B?bGxBalFvenRlVXpkQnZkRDU2SzFrR29iY0Vjc0MrZzN0MW1MTVV0MmxoYkdq?=
 =?utf-8?B?VUwxZGpPb1dRZy9SaGhEWDFjQlE4Zkt2dlErYUtzc2NYeTM0VkVnQkRCcGll?=
 =?utf-8?B?elVaeitKSG1mUWpuS0gwaERVU20vcGdoR1FEOExjS0lVYzVzSjI1MGlZMlBN?=
 =?utf-8?B?ZFdxRklhdytYeGd6MEZ3OUNNOEs2WlFJNmNZOTNnejZnMlRFK05VNUNwZVpx?=
 =?utf-8?B?TkoweDdmcXhxRTlaL2Q0a3lkUURXdnNmRmVQTllUMHpremh6TDVxdFZROGdv?=
 =?utf-8?B?TWd5aWNIbFJ4Yzg4MnpRUVJNdk5ZYzViaE5LRDdRZkJNUzdlYTFtZi8wcHB4?=
 =?utf-8?B?ZkVEeXBrM1FSZmFQSjdDTGJiOWNRPT0=?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(376014)(7416014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2026 09:49:17.5388
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 70ea1ffa-eb73-4a61-9313-08de5f1bab59
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001D4.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5975

On Wed, 28 Jan 2026 16:21:23 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.68 release.
> There are 169 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 30 Jan 2026 14:53:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.68-rc1.gz
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
    133 tests:	133 pass, 0 fail

Linux version:	6.12.68-rc1-g559b99a93134
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
