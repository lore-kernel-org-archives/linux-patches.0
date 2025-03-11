Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2066.outbound.protection.outlook.com [40.107.237.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CD461EB18C
	for <patches@lists.linux.dev>; Tue, 11 Mar 2025 09:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741687115; cv=fail; b=F9ksoQqkOezCXZZ9E57y2BNcIjWvJEaCGFML3EFhjSsudGO9gfDFNN9c2a+PUPM54RNmUP/ctbcs+VG8xeJOpSoEvrQ6wcGhpKdPGmQsU3CgUY0h7Lu/fDUZtqTg3eV6Jya4ULrWIFeiXwxJQ7h4cIROQwIHmJxgS0fLucspZHQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741687115; c=relaxed/simple;
	bh=chj5vwpG0FXHuGRpHYtcejdR6RW0VuvGVylaqVV5eCo=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=cMQIePixluR3BGJ7ujQQNxYOj+wv6r2/sgrICwoxodEy6CLECeA8hyDegcMS6+wRCbOanRnyaefrLgD7SOfEJovIW9NWohx5y9redRDZ/4Ca5L3vI4TqCl+QMEEqfEajzQrCwTLKZH0kvXgs0+vL7AL7mbA/06VtIIhlEI+lS9c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=aEtmfrfW; arc=fail smtp.client-ip=40.107.237.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="aEtmfrfW"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xdcuy5LM2DRVC+96ruMFOD9AmDscP4pUdOmKPPpCPdxlVxI9uIce8By6rmDlYHhyWa5WxHE1lL5/WCZyl8QX3LMAvLF/u+EIPBch7HkWR1tb7QR+TcILRvoWzvHpwd9y7EfEa7UqtwM5HTt4ZEcayJOT6p3ak2B5DGf7dZ5cLuWaxclbGzRi805VRDJI2OB1S26tCueW1JKNzvOVlmX2sRawiSlOw+TQeQMhtibqmb9bHSmFMFQ8ztZO0YlHR4bSYn0/U1YSsKL2AXL/mxUpM35rmGj9jTKOjeghujqjbvb0pEqI7oL/HcVe+MShe49v+Tvl0h/as0VVwvwj6Zi7cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l9W3i5AU17tHKpQy9FGUDjx9KmF+HJ+lEbSDCmSzpDM=;
 b=qbfz+5n1In4fhe9lS63kuTxvoeTkth49iVUmINYM8Ege6tpwaqWoP8nu0Yl2Y15VWXNscH8VPWrgrkTNK0TMLFlVXiWxQeuxw1vBQ4SljSuYTJJSw9EReKSmcro47YiWIJpDuBHhqSW5ht8IL2VAyq/jY0XGLHpdJQ5PlkyIfGZsmddNpxsVYAdfA/rh6ZuF8xoH+KBuq0dlkiX06IETHkRti5TifsD3R+r79GLMIottpdcwfhyIDszoPZTNYuUQNnnZBXLS/bow4Q0AFnErHhoOz4IUB2kY+MnLRkO5CqN5nVyyVdwiS0zryEyn8aVNTX8OjGnVy9kSc5XcAVHrxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l9W3i5AU17tHKpQy9FGUDjx9KmF+HJ+lEbSDCmSzpDM=;
 b=aEtmfrfWW99luEdM5WowkG1eL0cwS5gxzhwPW8JfZazVb3EgNxRsNkDbceU8xqYievpo9aCd8BRNR8Gw2o79HSBM9JmYOCihvjJaIGUq/P/Q7Ga4SVKqL5LM724ozl+dvPQSEF8KnZsp0RvAIequx3GPe715ebxI67tapSduOLizNFxPdVag00RIiQ/NGAilZ5nt0EeuYaB/Ws+tkb9O5FNHFSvBq1N6OZn0xrlZePpQUu6tyBSw2qrBmKRVYqWnhS79bSd+bpFNKUG2S6gi0IvS4T+Gvra/IG3hWYKhfIZtXfdHAKMHTmVPRMaNlnkd+NuJ5V1e05JSKVQ2Os1tkQ==
Received: from CH5PR03CA0006.namprd03.prod.outlook.com (2603:10b6:610:1f1::7)
 by DM6PR12MB4283.namprd12.prod.outlook.com (2603:10b6:5:211::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.27; Tue, 11 Mar
 2025 09:58:29 +0000
Received: from CH2PEPF0000009B.namprd02.prod.outlook.com
 (2603:10b6:610:1f1:cafe::55) by CH5PR03CA0006.outlook.office365.com
 (2603:10b6:610:1f1::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8511.27 via Frontend Transport; Tue,
 11 Mar 2025 09:58:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CH2PEPF0000009B.mail.protection.outlook.com (10.167.244.23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8534.20 via Frontend Transport; Tue, 11 Mar 2025 09:58:29 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 11 Mar
 2025 02:58:21 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 11 Mar 2025 02:58:20 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Tue, 11 Mar 2025 02:58:20 -0700
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
Subject: Re: [PATCH 6.1 000/109] 6.1.131-rc1 review
In-Reply-To: <20250310170427.529761261@linuxfoundation.org>
References: <20250310170427.529761261@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <ef389637-802a-43ed-a3eb-a5b98e8babd5@drhqmail202.nvidia.com>
Date: Tue, 11 Mar 2025 02:58:20 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF0000009B:EE_|DM6PR12MB4283:EE_
X-MS-Office365-Filtering-Correlation-Id: fdba28e4-1b1e-4e4e-2a2e-08dd60834692
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|36860700013|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YXNPb0tESjNXYW5GNlhSMlB5WkZOOUlWRTNkbUkvSU5jQWR4OUpYMFhtMXd4?=
 =?utf-8?B?UE1LZnNNYk9QNjNVVnZQcDN1a2xSaDhtT3RzWTdVVkd5Z3hHQUlyOW9hNTFz?=
 =?utf-8?B?TXNsVXIrRFBFVGhzaHpjWHJBZ1VVMHhVWC9qVFpxdmUzSDBMQUQ3OFQwYzZn?=
 =?utf-8?B?TzJFUnpPb0cwNmVPc1FrZDJVeWswWW13bUdKRC9iNEVKM0RUK2Rib0UxWTFn?=
 =?utf-8?B?WHl2c0Fxc2ppQXdJWUZ0MGM3bmd4dTFrTGczTFFtNVNCdmV5blF1dU00clpJ?=
 =?utf-8?B?VmR4c1ErbkdlZSsreDFKRS9SaWRWaWtQRXRnTTlhWEpReGRXMXQ3OXJUQWNC?=
 =?utf-8?B?eXVYcDNRY3NTQ09GMUdUUUtFdE9FYmpRTlY3OHNidGVySjVkRnFUSFZkWHZB?=
 =?utf-8?B?dVlmU1BmcG5FSVFMclpIVWNuUEp5ZXJNZVFHejAyd2JYa2EvT0l5aUp5akx1?=
 =?utf-8?B?STNPWmY4UXJLZzZjSnR4d2toSHZNTnRaKzFNMHpsZDhNekVwUW9qTVNSSTJu?=
 =?utf-8?B?YkVqb0NQRTZnU0FHZ0FGVmtCWmFPQVJoTVVEMGx0NTcvajBhQ1Avb1VYVGxZ?=
 =?utf-8?B?dlZSV2FJTmdSMjJ2ODIrY1lpdmlLeUR0U1QyNStlRk5ibS9BZTFWak5uaWhG?=
 =?utf-8?B?TjlXSHdQM0RzSE9xYVpyMzlhQXdVckh4V2pxbXZoUTZoNTBuSzg4YlJVQ3VH?=
 =?utf-8?B?bmtObkdtcVh6NTJsN2hybjIzbURKcVVJdEZWMUpIU1hpWHNSc2xrbTFmNXlL?=
 =?utf-8?B?VWdQeCtUWCtMcXAzWGFjY3FGWlI1Sm9BOWRpSVo0UDVyU0tIOVdJa1BVNzV4?=
 =?utf-8?B?UTMzRVhiT3IrRXlybFBMbnh4b2J6Mi9icmkzWHBCU1crQm5XcnRaZ2crL1A5?=
 =?utf-8?B?VWJsWWk5aC9IK01tSmsvakgyMi9oS1JBb0lBOVJTenRoSjlwbFA5SDBXOFQ4?=
 =?utf-8?B?N1JvMHNlWTY1dXJaWHZtUGNRTGI5WEh2VXZhSlRJcU5YVEsvRDBLcGlOWkhl?=
 =?utf-8?B?bFAxTTBKdXBOdTV4VkF6U001YmFhSGNpRXpXOUFmZzJiWHQrQW11d2ljV1JH?=
 =?utf-8?B?SVV3WFF2R3BFMzJtR0s2RjgwaTlNTU1WRDdsd3VwUUxteHQxWnpvYWROcE9Z?=
 =?utf-8?B?Q0FCcUpMUzh5cHZTUG5CMlUyVDJNbS84NVVianpTY3l1S3J6TFJSQjEwc2ZQ?=
 =?utf-8?B?Rk9ieDkweWZaMVpla3JrdHhrU29BQVRPZ1RXMnVMM3FlU2pCejYwd2hsdW5u?=
 =?utf-8?B?bW1FUS81T05MSnlrQXBqaHp1Ny9TOXBiTFVkcDA1ZytVY3RSMjdyYldmdmFa?=
 =?utf-8?B?Z2VuTDdVYlVxSnRoNWNtK0h0NUdXZlpWQVB0Z2hwMy9iUzhOS2MvL3hyemJW?=
 =?utf-8?B?TWxzaEdZYWxHRTNKRkhhTlM1aG00emRMcXoyWE9rK0dWdUg5YlI1cjljZmM4?=
 =?utf-8?B?TnZIUy9xck5aT053VHVxMGNsMi9idTVrbWtTTGszSEd5QWRabFpHejBTTDJD?=
 =?utf-8?B?VFIxVWhheGd2NDFmVHN4Mkw2dWlGQ1RONlVIckppTFlLM05pZWZzN1Z6YUVN?=
 =?utf-8?B?S09ScXBHWVJyS3BtL29yb2hVNkJFQmNaY21kcS9UL2NpYWd6QVY0eGI3RXYz?=
 =?utf-8?B?ME9aVFNUS2ppdGppNGZzY050ZDMxYzdJUjRtNHhObHZaZFZLLzZ3QUFVNzVm?=
 =?utf-8?B?SjcvdGMxVEJDYWlKWjBTMnl3Q3dRQmt2Qm8yV1U3U2JkWFZwdnJsZWpoczZY?=
 =?utf-8?B?ZURTcmVZK0htRWNJMkJoazgwTlB5d1VHQW9TZDZwamt4eUoxR1pVL1V6dTF4?=
 =?utf-8?B?cWRySW1BbC9NQi8xd29CSXl2ZGRGR3R2R3BKYkZRQ1dETWo1aUNHN0ZEUXBa?=
 =?utf-8?B?SlF5VGRoNE51QVd2RkdES0ROQ0xjSUVBb0trYXpScS9va2lnSVMrMGZmS3N1?=
 =?utf-8?B?ZW85UzF1bVNRdWZ2bHRYbHhGQTU1d2p4MTg1QmRPTWhCaWdvM1g4WGd0QnFR?=
 =?utf-8?Q?5e3KcY1ycPZvARkGLs1PEI+pGvdnX8=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(36860700013)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2025 09:58:29.5882
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fdba28e4-1b1e-4e4e-2a2e-08dd60834692
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000009B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4283

On Mon, 10 Mar 2025 18:05:44 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.131 release.
> There are 109 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Mar 2025 17:04:00 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.131-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.1:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    115 tests:	115 pass, 0 fail

Linux version:	6.1.131-rc1-g5ccfb4c1075f
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
