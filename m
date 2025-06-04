Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2085.outbound.protection.outlook.com [40.107.237.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 493C528DB48
	for <patches@lists.linux.dev>; Wed,  4 Jun 2025 09:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749030046; cv=fail; b=jrJjX/5lYOe/bfPaacGqQwY4m7D5r69YFL24urF2MBN7vJbqkgJou6exznStwO3lT31JIbmdrt2qyExKKF8e77ZkiB/7EsFlniZBzC14F0Qe50fTbhxIF+2INyxvzqNTitsQK28W4bxo3MSNWj5qZNaAuPwsDd+sObl8EApSYe0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749030046; c=relaxed/simple;
	bh=TDDKXNbRg0Bo3gHRsxP1tvVjHLgzdCrpnOLhVhbhL84=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=kMdw+WDZiQjtW8fXH0nr8/vSxUUAhqBL20WBwgQdNfDGlBD6gAyKwj1pDY4F7IqhPMXQMMil7VmQ+wz1jufWIp8tZ8fP6tXRUp6vKTKLWeGmlIIGiaevzb50hrhfp0GavnumQNuJK+42BSctZnImv5XpOuvK5i0iVXP/o2b8jl4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=E07ZWgSh; arc=fail smtp.client-ip=40.107.237.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="E07ZWgSh"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g69YC8rsR2Ar0i30YgSCn3GURCXvxrIFv9ZEZdV37VPxgRG38sGXMIsBtC8mFTPFnBgACenQ8n3bGeWLOL8CYsmnzFikpLGnGMQA9XfgQmGp+oKXvWs+CR+Y6w3RHOhkl4hIKw+C3GNLiJy8OgTMbezU0EFBTWqk49lzRVlMnNIxA4dmS6uGl9nDej098UOwV3THpZ/PPokyWS/BC7q++v/FVowxm18QkOwYeVDaDfweN4nPubm1CHsFZoJQ5fJi4QZ6qlTSRGgAF7QGRu4a61tsXC0HF9CXswXHcM22qWcJP61Yhi7Nwhq+MroeF1HJ4iuUd7Va6jB+WpvDjv/Hdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7DgRXHcYSs528iW5Ol8nA2kVGmAbClJYznCyskK3bE4=;
 b=VTW0WIQnBGNm5P1W9NEkKdgvIgjb8kEaAlVUAACzTwU7ohP75UbjF8r3QoN0pVGutV0D6bXtn5twivnyRNhsAwwxoQm5y8c1t9oSc2SBCJRtLFNEPmaU+LIAyYbikBcwr1mvhhHC1Jsb+NpIWzKT4cklx2R865WO/i0kW1X7AAaMAhxQ8ZxpeEQXga2hwWgKzHX7U4+VFPfKO5VmZkDi5u5reZJuDMojxKSwgdu7GXBaPqfJ33Sjy/UxALd+sVdmEKekrz+FERoLVg1VTU22itde3Qd01LxVpnBzZlNbee8sLss7thChYaaqhejeSGvJs3wzBR6BhLY6Fw8qMYPkcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7DgRXHcYSs528iW5Ol8nA2kVGmAbClJYznCyskK3bE4=;
 b=E07ZWgShIZEZ8P5RHdOuQTrsQISeSKcgD+RXs7oxvXGPvDIxeHIc4T0diTutHT6ymZUg5bum0aHRssuaruvJQPArdpaGGXP8kiG77UkOosvMFCa0TJJ1oplSNmOhkgn9Ow0j2hIGKW0xxh/xgnlM2dI6+XNRL49DmVGxJ+dcCMtdb9Cy5c4Ustl/8TEOLCBv9lOSAd/nMqAedHSKov3tqqweUqszXCO/Yx4FgzSlw+8W5B5D3T9Qzb3L/AryPqO6OdOb2MQ7FtYH5RRvn0WPUlFz9zbRa+yu3hS8WvhTwvbNxO5iRkkqiHRBHZTxKS/JuMc/ZX9VHrtOq1aveqXU4A==
Received: from MW4PR03CA0032.namprd03.prod.outlook.com (2603:10b6:303:8e::7)
 by MW4PR12MB6998.namprd12.prod.outlook.com (2603:10b6:303:20a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.34; Wed, 4 Jun
 2025 09:40:41 +0000
Received: from SJ5PEPF000001D1.namprd05.prod.outlook.com
 (2603:10b6:303:8e:cafe::55) by MW4PR03CA0032.outlook.office365.com
 (2603:10b6:303:8e::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8769.19 via Frontend Transport; Wed,
 4 Jun 2025 09:40:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SJ5PEPF000001D1.mail.protection.outlook.com (10.167.242.53) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8792.29 via Frontend Transport; Wed, 4 Jun 2025 09:40:41 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 4 Jun 2025
 02:40:26 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 4 Jun 2025 02:40:26 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 4 Jun 2025 02:40:26 -0700
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
Subject: Re: [PATCH 6.1 000/325] 6.1.141-rc1 review
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <63e47cfa-380d-4cd6-8fc2-783dadd3514e@drhqmail202.nvidia.com>
Date: Wed, 4 Jun 2025 02:40:26 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001D1:EE_|MW4PR12MB6998:EE_
X-MS-Office365-Filtering-Correlation-Id: a1ed4643-f4ae-438f-c0a7-08dda34bdee7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|36860700013|82310400026|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aU9zeS9HcjI4TzZ2RUxWSVVjbmJKdTAyRHNzUDEwOXAwSlNlc21FVFNDUFR0?=
 =?utf-8?B?ckJFNlRFR1AwbzBJQUZGQW9TUzNycjN5TlBGc1ZjL3dWVFN3cFFVMkVnZWF4?=
 =?utf-8?B?Y3R1M2R1T1NEazlpWXg3b2xIZGZRbzJVaUFWVS94ZTNOdWRDaWw2MXEyb015?=
 =?utf-8?B?ek5QejV1MkhYdDZNOU1ueVhUWWtRZ0pwS2tVVVgwbE1HOTAzUENBK3Jpb3hY?=
 =?utf-8?B?bWxrMzQ2QXJwT3BhWlZJdThBVFVhWXFRYjVlTXdscUl3NGRJVEVGZ0o3bjVl?=
 =?utf-8?B?c1dldDhGby8zUjRtNmVsb2QwL0dESWRMZm8xMG1ERURhYWRCcnJDMzkrTkdh?=
 =?utf-8?B?Yldyd3hSM1M2M2oyaUIyK29GSXhpd1UxZFQvdnRVQVhtVVJrdTNhZEh5blNP?=
 =?utf-8?B?VXRVR0tzWU1ra1pFcmFxalJXZ0lrRWs2Q2xyeS9UU09zVVV6bWZwQzJHR0xv?=
 =?utf-8?B?MlZpblZ2anB2OTk4SEV3Z3RvN29GSTFPaEYwOFlhWUVSYURXcFUybzY2TGk1?=
 =?utf-8?B?ODRoYTNldFZXdXVCMVhjdE1VOGdCeXJFckZYUDNLN2I0YklwMmd6Q0FUalJ4?=
 =?utf-8?B?czUzMWkxRUNFODhUeGN1NnI4T3ZsWFhQa2Z2cHV3U1BLWUZqeWpVSnpTaGVv?=
 =?utf-8?B?ZU1UMkJHUzBNUkRDZjkvMnA3OGh5RmNOTkh4aUNlSU9MajNScFhFTEQzZjZ3?=
 =?utf-8?B?bmREVVdsM3J4cUxCZ093aGVtSWdlK1c0dUN1akFOVzN5K2Q3NUdQclRoY0hK?=
 =?utf-8?B?TWdlb2tWbVFBemx6UGhaSUpNMlpiOCswOHNiM1hRS0RVY041Yldzdll4TXNK?=
 =?utf-8?B?alprcUZNQjhybG51ZDRDSTBNQlZZL01DRjNjYVZGTU1BbTk5YllRWWNaaWNj?=
 =?utf-8?B?cHRtRUxtL29tRm4yTVZldEFWZjJaMkRielh5WEhtcDZrZG9XV2NqejNnNmFY?=
 =?utf-8?B?dElKa1p4L3BaakdqbjdNM0p4YXFrQlB3UTZIUHNMUXJnNFduQ2xKSUwxV2ZG?=
 =?utf-8?B?bjcxZXdYL01XY1piNndIbnV3UHhmQzhvZFkzL0g1M2M4M2lTWC9YWUwwT1lO?=
 =?utf-8?B?bUZtVHNadGJvWXlOZmZZY09mdkJhS2VDTEpMVmo2alU0MHVPbGtzVE1abU5n?=
 =?utf-8?B?eEhaN2hSUjB1ejNGREdORzhtK0JKeTkrblF4VDhaQmNOWkQwK0o0Z0E2eEZ1?=
 =?utf-8?B?Y0lwRWV4b0YvZkwzVFR1cjQzMjFMSUY0RVdFbWVTOEJxWE1SaTBjeUdyaS9T?=
 =?utf-8?B?dUNqRWp3VU1oOVROTGNRby9OTlVTTXpiNWMzV3JqWTdHUzlwc3BRdGduek1U?=
 =?utf-8?B?U210UFVvREtJS2JMSFRRRDZMOTk1N2tUZ3pvdUtvTk85MWRvcUR1Nms0Rnll?=
 =?utf-8?B?QmEvUWZvWGVzVGdtakZLY0Y5YUhVSzU4b1oyenlWOEdESGRsMGd5NFM1VG43?=
 =?utf-8?B?Y2RncHQ2SDhHSVR0eDY5TS9HbzY4aGcrZGxaTGN1S2ZFZE1wOU91Y0V5Y2VQ?=
 =?utf-8?B?WU03RlN3SVlYTENhV0tRZk5idEhvRU1RdzA3M3JHMzAzZFRtQ2lHUzcyUHF4?=
 =?utf-8?B?YTRJSW5RRnBoQnpydjFyKzBreVZqNmZvejB2K3FpRjhoWlNyUEJ3aXRkcjY4?=
 =?utf-8?B?NzNtMGZkUU95NE1GdXluajlrTk9oYnpFTUhacXB2TkM4Zk0yUWNYZDQ5aWZl?=
 =?utf-8?B?dXVqM1QwWUJab2FUbHBYaG5YVy9Sa3FnU00xTWlhZlZvN2RpVFRmbFhGQzhk?=
 =?utf-8?B?RWF6ZUdKVHhEcnc5VmRnaHVqM3RQZmYybHh4ZmMrRlVNUEJsUFhJVTFSV1Jq?=
 =?utf-8?B?YlhFbSt0TlU0dGpMRmVhall4TERJV3JEM3Y0L1kxV0lFdmoyaHpNSEhUa0ZY?=
 =?utf-8?B?SEZERW9hZ0IrMEJONnljZUM4UEMyUFVhT2djaXg3UnVVbnVNNGttYjVmSmZ5?=
 =?utf-8?B?ODEvT0JKWnJkdjZqd2hpejlheDUxN2drZlNDK1pKeGdQcnFIUktFclBocXRl?=
 =?utf-8?B?VFZOVUpSNkV6dzZhNWlHYVRuQTlVbzBKTExqeXg5MjNsRVVhK3ZSVlIweDZT?=
 =?utf-8?B?RENLamMzajJVOTZNanNJWG1zZGVvNG9vWEZTZz09?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(36860700013)(82310400026)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2025 09:40:41.3385
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a1ed4643-f4ae-438f-c0a7-08dda34bdee7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001D1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6998

On Mon, 02 Jun 2025 15:44:36 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.141 release.
> There are 325 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 04 Jun 2025 13:42:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.141-rc1.gz
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

Linux version:	6.1.141-rc1-g1c3f3a4d0cca
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
