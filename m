Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2048.outbound.protection.outlook.com [40.107.212.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F22971922FD
	for <patches@lists.linux.dev>; Fri,  6 Sep 2024 10:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725616956; cv=fail; b=qnVsoio5umgvfFuFHWWP/XtAz6SSWEg7hNrcp8igJUKlSlxL8hnMrBeHL416YYmmSNJyjP4yxtHdhnmeoxFxfbrJuakj9KJdwqHD75mf/9ivfCgxO664aYHyhZrDT+poMCmrxKbrsDyKBOzk1siadmGYSWykNyWhLoA6TSIu9iw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725616956; c=relaxed/simple;
	bh=CP5fsdIFmQxCgQ+QFVt+f675kXJooknGO2DmKcyRk0c=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=Ej8K+vg0I9ShjxwrZPH9CcOJZ2l4vW5d10sdvZX5KKNyzvonFvc3vaC2kQuVIQT/jKHEKngq7Gk98NL3/WYhOPbqy4wbUL+4Y19zeqBi4herwq3cZZ7lHT6T8V7rRWTfNt1xZhl8TPQixieeU5h25fo4NzTorhb/EdLKBmtDU88=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ivofrHKq; arc=fail smtp.client-ip=40.107.212.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ivofrHKq"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uslw79fIgeuECHvge5u017hveovSR9mOADmEucwLj+4hcyQn8XDEB3favprS7+3r8go1GgwsbAt0gF2fTUtgHHRKyEJ18zC2oPOz3LjBge8tVEeDNZT6w6HhpxA+x0U6vjGEkxgxzOIbt7YlgRaQB91G7zGscsDddFtk0rCMJy4HiiR6el0ltP18qDt/6UdCQVAEzzwT0xtSmJPemgrWnWuZhXPdNjnljtTCkh3siMxha/509S/6UPbiBtHNsmdQo1Thhs6m+N5p8xnJl20Wd9AmN6cjB+KG7j6hAXmX6tVfFddw+TWBJW6Y82gMt3k0wLRueqTtZ9J6ic7Q7QxHPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HtaQjlPQOMd5/SxFwm340D/Lz8r7wWIfaAuL5Ok7seA=;
 b=Ri9c+wQqIk+nDndfjuXrSY8Uj/hV+++m/eDapjop0/vC1HN2cQr2Bb6kcEwOpFv5m0ZPH6wMp0UcXwifTUMIotwe4fcVc9OVxHmIDEkYp04ZdJRFU7zW502WUXdxVcppdMEJciU5TU88z950Z559n8Z90Mx0gp3itzG/9KgLI/+NCtpR69lTfIflXm0EiGsKZeLZdjgGYp9HBw1t9Iehv6BiOmsHO6WQxUZWhvHstoWmIElbGQAtWIgR4ViQG675j1H5E8v0r80oUrH5yUNMPeX7J+oRfsCRTCRTxm5asOHAep+J9QrcnKBQT0HYq4VpWQoLkVi9r/TnCSjlj/f11g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HtaQjlPQOMd5/SxFwm340D/Lz8r7wWIfaAuL5Ok7seA=;
 b=ivofrHKq/MxaPVKSk6DnZHnHhkjju8o1e0zhjDuQS4sO4vt/Hm6gh5iooBCjdzBKzBtdBIRYpblaGwUgHZqOJVUyR/23xkc75j+ElPPhomlmoEjct0xasT2DFckfxcqz6uc9dNZu31zTF2lf0Rs4xr5CBV4Vz06hzvvcQgKRKZGOMg7YIQRB+CEoy1fhAOUUYxJNxkuuU6wwlx0G9ndiWBDKsaiVx4qPAxdyo2XoN+TJsbFIiuYg04cKuoYL6uEHls8Pr2jOgVkMa4QRIk9TyBvd4dhDuG4fwxna1SOONPFMpkYJk4Oh8q4SIh5otxTIhTCgWkxII0tbeGXDk6WQrA==
Received: from PH7P221CA0005.NAMP221.PROD.OUTLOOK.COM (2603:10b6:510:32a::22)
 by SJ1PR12MB6337.namprd12.prod.outlook.com (2603:10b6:a03:456::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.25; Fri, 6 Sep
 2024 10:02:28 +0000
Received: from SN1PEPF0002BA50.namprd03.prod.outlook.com
 (2603:10b6:510:32a:cafe::2d) by PH7P221CA0005.outlook.office365.com
 (2603:10b6:510:32a::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.14 via Frontend
 Transport; Fri, 6 Sep 2024 10:02:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SN1PEPF0002BA50.mail.protection.outlook.com (10.167.242.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Fri, 6 Sep 2024 10:02:28 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 6 Sep 2024
 03:02:22 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Fri, 6 Sep 2024 03:02:21 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Fri, 6 Sep 2024 03:02:21 -0700
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
Subject: Re: [PATCH 6.6 000/131] 6.6.50-rc2 review
In-Reply-To: <20240905163540.863769972@linuxfoundation.org>
References: <20240905163540.863769972@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <109adbc9-2a30-47b9-b290-909ffe9ff4dd@drhqmail202.nvidia.com>
Date: Fri, 6 Sep 2024 03:02:21 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA50:EE_|SJ1PR12MB6337:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e338aa8-1d34-44a6-5dad-08dcce5b0415
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|7416014|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YTVMcnpWNlJ0UVUyZ0l6cE5OMnRGTzZBRnFqWHdQK0NEc0RYbE1FYXRVUFcr?=
 =?utf-8?B?VjJSdmFmN2VkYnJOVmx5eEVOeTdseVlzaTRFQ0R3bTMrTE5LV0doU2hHYUxK?=
 =?utf-8?B?Yi8vOTBUQzhBU1hkZEIva1FwT1FIWEhqTE9JT0UwYU1kWVF4VDRORDg5Zi9N?=
 =?utf-8?B?ZjhUTlV0bkEzcCs0SEJpZ0d4OStGTmxXZUl6WFpZdTVkZUVkU1BqVHJSMERX?=
 =?utf-8?B?VWE2ZE1WbVlKdWNTTlg3QjhiOGJvM3lzeW9rWWxBTVJHMkttbVFkb1JlaWF4?=
 =?utf-8?B?a0lVNUZOYkI0S1ZoV2N6OFdCaXczbmhleGgzeTByUys0K0x6VGdHQ28yNHVL?=
 =?utf-8?B?ek8yWDl5RDJLZ0REZVh2Ty9iT3NIUVJIT21PemNWK2xKRDBpYXRtSlNSc3FF?=
 =?utf-8?B?T3Z4cm5TRDRFNTc4R3B5NzBidXJsdFNoalRyQ0ZuR200VDdDaE9QTEZqTTRC?=
 =?utf-8?B?WVJVZkhlTHdZN0xIYk81ZnpPYlR6MHZzSkI4VWtSZ0ZaWmUvemJ3citLVmtm?=
 =?utf-8?B?L3R4dmtUb0xwWEpqcU4zR0xWSnJjY2NTc0dWTmRwb1FlZ3o4c2oyZThPWThN?=
 =?utf-8?B?ZHc0ZmtZQkxKQmVOakdFdm12aHlGUm1qRnVpMkE0bWEyS1puN0lvd053MVp4?=
 =?utf-8?B?VnNsY0VUVC9QOWIxRTQveHc3a3lsZ0NLa1NFSEx3SFF3VUlJci9HOUU0K0hz?=
 =?utf-8?B?L3U4UjhSTzg3bkt3NnppSnVKdXVQV2JkWEZQVSsyd2FScGdxbEdkSlhFb01Q?=
 =?utf-8?B?SWJUVWtKMkRvalhLOHVONWxzZnJCTHZwMDhhajFuWE13Wmdpb1lKVURxckl5?=
 =?utf-8?B?SlhEQ0NhbkRjeklHRXZtQVhhMlB5NzBXNlpjQU0yZEtjYW55NStjOUYxNXB3?=
 =?utf-8?B?emVpTGtMZzROdk8xK1RHWXNUK0RKQi9LbHVjanVHWnFkcithODhEZlBNQ0Ir?=
 =?utf-8?B?NEprdTYwOFBFUE55VUdxRDNueUJ2WThyUkZ1U3FsMlUzY2l0SEZzRGE1c3Vh?=
 =?utf-8?B?WFlCN1I2SFNRWFdiS0FHeXYyWHhlN2lNYlhzRG94Z2JRSTRoSGM2RGJMeWZC?=
 =?utf-8?B?Q2x3VFhDZ1IwTzgyUUF2cGtiRUV6MG41bDdXNFNuK1NybXhPenZOUVRUWWZ6?=
 =?utf-8?B?enRFTzZaalI0Z3pldktLT0gzSndpN0psbkw0MWpaLzRVQWFpQXA2MG5GSlpp?=
 =?utf-8?B?dG9MSTFZS1ZqV2tJbEplQzR0WDJLWitLQlYwNWhKWXBXa0poTEg3SzkzUWEw?=
 =?utf-8?B?UmNXNndXTDhZVnNCWmxFMy9SYjkxODZueXBjYnlZZ2NJdzRlSG9oQWpaZnhv?=
 =?utf-8?B?d3dQNWJKRU80K2NtKzVzajZ5RWc2dmJYQit6Y3RXS2F1VkVXM1VTZjFwdlhT?=
 =?utf-8?B?dVJzb2VaV1hmVjZwcVhYaW9qektmZWlwb0FSSWVTdzhHK1huRm5XZVpWL2dE?=
 =?utf-8?B?dExLOGZ3ckYvWEVjNFRwZUdsSitSUCtBZS9jYWFycE5JRkRSVys5WjZmYm51?=
 =?utf-8?B?WUQwcnp5MFhJZEYwRWRNb2tZWXBmZ0xFa2krVk1qSVBQRkZLOXdHbEUrdXhz?=
 =?utf-8?B?ZG9vQXVmdm5vZHVOdlBveUdDY0UwUzg4NW1KNUFsWjVVUHdCbnVXOUV4SHFJ?=
 =?utf-8?B?ZDE2TXo2YmdWN1ljbUQrc2lsME1SV2RvNVhaNzlqZGx3MXpzMW92bzRLa2h6?=
 =?utf-8?B?Z0xLcHFJdy9FSng0NDVIM3hDQWhoQXE1Y0dUam5NRm5MVXZqdHRjaE9SRHBT?=
 =?utf-8?B?M2ZwQ08yWW1qNE55M2NsajhPZUFsOGlUSjVhZnhKNEY2UlU2YUxFQlQ0b1BM?=
 =?utf-8?B?U0dOck5SN09xNFNBNk9yQVdWVGNjT2RWaTA1YnFCSE5OeWZyS3FKbUl1Y1Za?=
 =?utf-8?B?NmlIYWdIQjd5QVpuaHl1NmVuZlo4VkQzWG9Ic1FlbXFvVVd6R0Z0dU56Wmkx?=
 =?utf-8?Q?lwPBEoB4U628PnZp953pmA4c/5iaFHrZ?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(7416014)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2024 10:02:28.4685
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e338aa8-1d34-44a6-5dad-08dcce5b0415
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA50.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6337

On Thu, 05 Sep 2024 18:36:33 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.50 release.
> There are 131 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 07 Sep 2024 16:35:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.50-rc2.gz
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

Linux version:	6.6.50-rc2-g89740cbd04a6
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
