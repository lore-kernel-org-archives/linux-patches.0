Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2067.outbound.protection.outlook.com [40.107.244.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24473212F13
	for <patches@lists.linux.dev>; Wed,  2 Oct 2024 18:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727894181; cv=fail; b=qm9i7YRTtMNVmLMgWOs5aeqZ4ZVd52aCdQz3rQClIDDe1u9wXZ6Tb/wiSngrxgjuJLcpP0RbF9XaGcD/pmu26IdQ9kFkWPgMq5AdIscRrsX4dilCC3UpD+pmCMuhS4J0ng1QGFdL6jgP+azH7gfFFRq45MC8+FrGgxq6KwyeejY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727894181; c=relaxed/simple;
	bh=de6h1OlvB3QkQw2B3f/azYraEhSkhUB471EwpX+yYlk=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=cnwiYOT8RyiiVB1bnJN9TZ9oVdTDcO3ry829KphGladACTqE8LChLIqLSUPR4N9YP39nYAS7c+fC7LcyykMPDaf/c4jnzH7IUzqt1zlQPGb5dtnfMrzGEsGLkHjvAaZUHssJFZ0foLyk/qW6mr7YhkDkU+cMb4Ry42fNxg5yAqU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ExQIhgY6; arc=fail smtp.client-ip=40.107.244.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ExQIhgY6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GPtXJ8DCpSqtTJWS9QUIagw46Zv1YKX4kP6cAVL6GqM1fWkRul1y3bM8Hgw93T0PrgMR1EsMLsEsnFR2qeGTTSHKpdZfcMXQ+Ww/qQdZ7iT35t+B8vk4ofYAZGMQjCEh1uCXAOtbCYHKGT7H5bc5WcvAWY57h+lkbqGwfTDroB7J4ZP7UShTuEPkEsiziaM1CBkUm7Rz6uKAECdfJEZ9rc5aLGEnesyX30YyolK/tS2kiz+7iNWuLkAdUWqW44jeSbp8GoAwjeR7ldt0SvYDSdy9tR8HxZwFGXgcjJtl29MYdNtMxRGDq/chehVZAa53QBcnWVXZ2/MaUWEDuTk3Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EJks/1LDXAk1tGdN5CMxSI2IC/VGfXD4dLuW4ju2w14=;
 b=ACt6rXfnw2X+TJHXF8Sv/R16W5QIOV0nPx2mH1YakOmEUuy/fRRNY4YchhwNJHB0CecmHtLSzZU6Pp0TOFEgdVg0WZEZz2HvXF3yumx1Ze1W44Zkl0idSYmQ7Cd6zEtTLdBZC5ltbJOh/f8ZhxNXyErUlRLeLoJiP0P95LBX72Yoj9thjjZfb2m51srUWQ7X9FMuWI6aC6BUVbBRlYq9sw1SKMb9zoc2+ZM3QBVQDJPul3IDwEY5lSbJJaFlHf5C6S1pWAQgBbs7lOmGDfiHQYouvgAT7+dB7oBJaHYSf3vqK5W/0akR0TZ2B4/xr06n5kvDBLdPrAAeURWz8vxUQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EJks/1LDXAk1tGdN5CMxSI2IC/VGfXD4dLuW4ju2w14=;
 b=ExQIhgY6p6GADI1kQQ5ClAXLsvY7fhqafIxlWeQ8hYwS7qaIPLR/IDfK84KijXwC1uEPBloy92vxBw9+hSSoxLJ18/2/+VXc7IhkZQ9Ic/NKGQbb/XtzmQfEz1wtsX0SsTE9rj7c4bwKvg1jkPJky5DaG2Yv+ylmITcnLgvhtgb5CbgIH8uN2uprHsO81QAXfILwNKn0d4QI8IjiHcyvxxoEghx+A6Zcwt4LRGb01Q4NdqlLn/POzsUVgW51P1k/sbV8Ic53j4kTSrRlFF8q6Gfiu6lrOp3Zogcs4OuB0vefNqaJKpSi2x5PQhWo9N1pkTsaydcJKOputIwVsYDgzA==
Received: from MW4PR04CA0384.namprd04.prod.outlook.com (2603:10b6:303:81::29)
 by BL3PR12MB6452.namprd12.prod.outlook.com (2603:10b6:208:3bb::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.26; Wed, 2 Oct
 2024 18:36:14 +0000
Received: from CO1PEPF000044FC.namprd21.prod.outlook.com
 (2603:10b6:303:81:cafe::10) by MW4PR04CA0384.outlook.office365.com
 (2603:10b6:303:81::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.27 via Frontend
 Transport; Wed, 2 Oct 2024 18:36:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1PEPF000044FC.mail.protection.outlook.com (10.167.241.202) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8048.2 via Frontend Transport; Wed, 2 Oct 2024 18:36:13 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 2 Oct 2024
 11:35:52 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 2 Oct 2024
 11:35:52 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Wed, 2 Oct 2024 11:35:51 -0700
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
Subject: Re: [PATCH 6.11 000/695] 6.11.2-rc1 review
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <ba215dbd-58b7-49b9-bdea-37e74e28b2fd@rnnvmail201.nvidia.com>
Date: Wed, 2 Oct 2024 11:35:51 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000044FC:EE_|BL3PR12MB6452:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a8a3c82-d52b-47fc-3f21-08dce3111805
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|82310400026|376014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?N29vdWNLOWxpeEhqenJTanA4MUJrMXVUYk1pL2hmOEUrb1RoL01VcFdZZUJ3?=
 =?utf-8?B?ekVOaG9hOXpDOHdxMmJVUDBWQ2lleWw0OE8wM0hXR1lOVHlBTEdaQVBtWmRP?=
 =?utf-8?B?ZThQSjZ0Rjc3alQyak1NZDNJUFlTSmQxNE16VGw0anBwTmxhSGlyMHRscnR0?=
 =?utf-8?B?cXFNdE5EaDhLcjBDMnNNbzJDSW1ydDU1aDB4SmExbjA3ZWxPajgrZDhxK01Y?=
 =?utf-8?B?cEErVGhKUmpHM2xsR0dtOW1pU3pmRzd5V3Q0RkdyS3FXZzJod0N4U2Q2aU1B?=
 =?utf-8?B?NnVqZkxjOEZ5ZHhMaHgvVW9oOXhXYjA0d2Y3ODg2bUVuZG9tS1U1UXRqcFEr?=
 =?utf-8?B?cDE3LzNDd3BNR2lZV29vU1dwZnhzcWpCRG5Rekp3M2VhekhqWUZmT0NoWW1V?=
 =?utf-8?B?aENZQXEyUm02Rk5IS0dlcm0zVGhNVDVEeExydHlCTHdvNUVhVmZWb0k3L25x?=
 =?utf-8?B?OXhUS21sNytFdkp5QTI5ci8vaGF6V0EraGtBZ0dZbFlYV1o4L2ROMTBQUXFK?=
 =?utf-8?B?RmtIcFZIUC9DenJDZ043Vm5aZ2dPSS9saXNxb1BFUUJDd3kxNWpIQ1oyNkoz?=
 =?utf-8?B?L1NTY0hQcW5sdzQwWnI2RzhRWFg1WmMwMFlFR0c2UENBb2w3RDl1NzBONVha?=
 =?utf-8?B?ZEt2NXd2d2UwamVXRlladk1yUWVoN2R1OWtMQ28wN0hPUVRLQk5CWDB1Vm5s?=
 =?utf-8?B?NWhiNlZXKzhOSWlwcHMvbmE4V3diOU1ld08xTFlHOTdZQnY4RlJ4UHAzYStm?=
 =?utf-8?B?WW5LaFFGa0pKM0doaStXS0w0akNZM3J3SGZham5pWkFJMUtOL0NTc3FnTE5i?=
 =?utf-8?B?a01uVTVydDZZdUlQanZCMjJUWGs4bnJXY29XTG9xaEJ2Mm45NlVRUEFHNE9j?=
 =?utf-8?B?ZStRREtIVHpldVB6TjBFZEdHNkkxQzhkcXRHNHlQOGpLWk95dVlWeHFjek5K?=
 =?utf-8?B?MnV1OWlQZ2lMbG9PVjRSU09QS0thWkVOM3pmbmFCYjhiTWhyV1ZxUWtMR1Bp?=
 =?utf-8?B?YkF6SDFjZEZqdFk1RlArbFMwekpLUVBJWjRyUHF6V1RuNFl1R0wxcU84ZTJM?=
 =?utf-8?B?K2JkZG0yZkxZcWdybnZYbzJ1ajF2ejJIeW5WcW1oOGkzSzRXZUlhb2FDRVR4?=
 =?utf-8?B?V09hWHI3a2txS1gzSExhVFFmM21tT1JzTHBKMDZaT01hQjB5NEIxYjdONGNi?=
 =?utf-8?B?dWdRZDJ3NEpEdkFraHp3NWsrQ3Q2NjZjTmpsWmtIVGRFSGxUaXhnVHcxZVli?=
 =?utf-8?B?L2U3RXhWVTlNT2ZaQzVKdmkxRmhpTDRaMHJUdDIvd2pqZjRWbVRJN054SEs2?=
 =?utf-8?B?WXNUejJqRWJwZVh1VzhwNVlNaXpqanU0d0grYjh0Y0J0L2FvVFRQZjBHa05v?=
 =?utf-8?B?ckk3K1V4eEVDdDk4WUI4NXN1TFg2YXRoY1pnNjZrL0xmRkRhWlZDSXVDMFVQ?=
 =?utf-8?B?MHc0dnFFc3d2OXV4ajRxTWs3Q2p4cHN6TldIWmxzVmN1NklrWWxEUDhCZHNU?=
 =?utf-8?B?QU1oclQvRit1Nmh0eDJNOVpKUnpQalA0VGRhVTN6K0J5QWwwYU1WbDhKUStl?=
 =?utf-8?B?elNhU2tHM04wbUNKcjlpVzY4aFYwSmRtTFNmb3ByT0k1ZGIzMEtzWkVnRXAy?=
 =?utf-8?B?MFd2bU5KN3p6Nmd1NFhKeXNmdzhqZTNlQ0k1M2pOMUh6T1hmc1B2cGJWWnpK?=
 =?utf-8?B?WTArOG9yOEgxTStwbGlrN2tUQlhtcDRkWkpjbmptd0JjR2VxeTdremVlVnlB?=
 =?utf-8?B?R29wM3A0a2RpNmYwZjVuLzBaZHg4MXVwYkNwNXBhamRjTXZMUVcrRG5VcXhv?=
 =?utf-8?B?eGVpNTY3MVRqWlRvRVNPMCt5dTN5RkYreG0vSE1qcHMyc3A5ajBjNk5pNW9p?=
 =?utf-8?Q?+WKJgspfxvBXt?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(82310400026)(376014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2024 18:36:13.5306
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a8a3c82-d52b-47fc-3f21-08dce3111805
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044FC.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6452

On Wed, 02 Oct 2024 14:49:58 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.11.2 release.
> There are 695 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 04 Oct 2024 12:56:13 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.11.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.11.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.11:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    106 tests:	106 pass, 0 fail

Linux version:	6.11.2-rc1-g10e0eb4cf267
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
