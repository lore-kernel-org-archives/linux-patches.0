Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2042.outbound.protection.outlook.com [40.107.220.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE2021459F4
	for <patches@lists.linux.dev>; Thu, 16 May 2024 12:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715862896; cv=fail; b=cQUvuhRn53Go7cIRploV67rU8UoR+rGYa7728uNOuvZGYAhXhBk1IYd8URT7Gtjr+fndURaxmEcdtnDr90GOOVRLyKydC1pPpD32f72U8GkgTwFIDz/hjCUpRaFig9ZSAbhB+mIPfS/cYXQ6+UeHnv2Dv+ShCS7A5823VAD5ajY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715862896; c=relaxed/simple;
	bh=gAxAGagBOK0JK036ktWKW8LDEzKDzl64gyETwI1xtB8=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=Vhpbx6wAek98Ygcjp8RxHRatJ3HMaFNfO/k8kfuk33xgk2iRJf/Ieq/ON52Vi1RReUpmETnUFAXUibELdx3dYQcVGdY+4jxyz6YkAtRy15ksYsrM091tKgCt+YnyBxqY+4jbvfj2o99vPWAOip/IDSCCrWGnFO3eLs7Sq8Jrb+w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=s+Kh3hrN; arc=fail smtp.client-ip=40.107.220.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="s+Kh3hrN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kcIHGtj8GSsZlX2lcz1L4tT1JF5xIzj/6WT4lRp7xIQ4Vi3hDH0p5aEg6QlB7Q/kMpcq4Un/3065w9FJZfi/qcm+Y4eJVN/+GI4YAmONRfVu+AO++UxOVjaegrcMpX/2xbt/CfWUbDhIrc70IqozYoBR+drDFjktJiYL9zNRC4LJAulD4qLmJgfy69eFMkjPvxXHiGOnC9+cEpfObg+Nddi1RSMoGqrNYjGvFzB+7tHVYYlRBCLrgG8FN5MP8EPfYgL42B/YN8KpuTM6097E6+rkmyOXc9NRNi5y50c3cGidsgoIvHRY7J+S0Vp7uET/UpdwfqGS/yAXKZaqANP6NQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eYnF+6Ll+6hBFACzlRBHthEBvwLb2UoaNiUEjBTbF/0=;
 b=HraAltHBvUHqOmoojd/EdORw2UmqfM5BSsk1B0XbUl1kk3JYgC0sWmGvNkAEpbk+UZHYuQNVM+iO3qMVfRqSIhnBC4dY4Q0wOsqRQTxJTGWGJWQsF/Y9TDbckRDfAkwdMyBGVwgjwwu0ql3VPdxBNsuX+wvG2zpz6Xw1TdgnAoWelZy5A0AqxxNt1yqEMhu7H2bh8BOZAd6CDn1UmH5P1RrMFPyZ1ab3LoBcZuGvwQhgsuLW3fV046L98hM65Ki/YIZBfyEerNGUJ4lw0AMQVPe/Ix/jns/gZObr+gZK/ZF/bx5Xu1xNyJ98WC/qIuy6vo2bLDjHNJP+WLgP6bhE1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eYnF+6Ll+6hBFACzlRBHthEBvwLb2UoaNiUEjBTbF/0=;
 b=s+Kh3hrN2w3SXq/e0xrTrVaH+4W6aq4FMHeal1CQKgzJX1GpkdtVV8SEAYOO0mG2edNAE7Ia4L7Dj6i+Nk61cAS7cZNzk8Tbn6GurszmAPCg0bxgXAITcXJrQVYkosKy3aUV1wjEABMqKhcSSMamj4pIJSfdxV+s2GMn7XrhYyTvPN4HFQ81jFXSm74dp0Hgak9fIj7CTM28Eus3R+pUfKoVV2k/G5tTZJiwjrJkOSR8N1+DKMpX1354YEARWRgLreXy0Roxr+mxE54y5trzc0L5ee12Joo5q2z3lgNdD9JuOxdmPh/OQ9rAbJFEP0otuWj+ZkuluEHCQTMV7V9gcw==
Received: from DS7PR03CA0344.namprd03.prod.outlook.com (2603:10b6:8:55::28) by
 PH8PR12MB6891.namprd12.prod.outlook.com (2603:10b6:510:1cb::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.28; Thu, 16 May
 2024 12:34:49 +0000
Received: from CY4PEPF0000EE3E.namprd03.prod.outlook.com
 (2603:10b6:8:55:cafe::b1) by DS7PR03CA0344.outlook.office365.com
 (2603:10b6:8:55::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55 via Frontend
 Transport; Thu, 16 May 2024 12:34:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000EE3E.mail.protection.outlook.com (10.167.242.16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7587.21 via Frontend Transport; Thu, 16 May 2024 12:34:48 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 16 May
 2024 05:34:35 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 16 May
 2024 05:34:35 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Thu, 16 May 2024 05:34:34 -0700
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
Subject: Re: [PATCH 6.8 000/340] 6.8.10-rc2 review
In-Reply-To: <20240515082517.910544858@linuxfoundation.org>
References: <20240515082517.910544858@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <c12f6aeb-690c-47a4-af5c-972fd416cffd@rnnvmail202.nvidia.com>
Date: Thu, 16 May 2024 05:34:34 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE3E:EE_|PH8PR12MB6891:EE_
X-MS-Office365-Filtering-Correlation-Id: d44d0ca6-eb8a-4755-3fa3-08dc75a49392
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|1800799015|82310400017|7416005|36860700004|376005;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dis5UklZU1VZampuc0FSeXg2Yy95aXJWMFExMUp0N29zcWNMUndERVA1ODQw?=
 =?utf-8?B?d3BBVi9mZDFMZy9CSU9HOG4yUkNWbXFzZ3lRMHpNVFRqVWNEUmRXcWQveG9w?=
 =?utf-8?B?UjRuYUlhS0NPU3VFN1JuY0ZnSEMvTGNLZDFNWThyUzlCTGVPMTNvVVZpblZB?=
 =?utf-8?B?ak1ZQ0JkdkxjSm5YT09OVHJYUWtjTFEzSGpRZWlSTFlETWpTc0RHZ3FWc2pD?=
 =?utf-8?B?bUdZOE9NWTVscGs4M2Z5bjhuU0RKaUVDQW0wd3NyQitSTTg2QWc1V1gzVUZq?=
 =?utf-8?B?M2tWbHBVMURPaVFKZWdCVzRFZ1plTXloOTdTZG0rOFBpc0ZJOEpoU280SDdG?=
 =?utf-8?B?OXlOZ01uNGg2dHh0THN2WUwzUWtHbi93RURMNHVaZEdKZHlJWSs4Y0Q5SEF4?=
 =?utf-8?B?WnUxb1RMdXpEck05Y1pUSXNwd3doSUZLUWFuT1RnM3pzQXhkeEh3NnIrUGtR?=
 =?utf-8?B?S2RqOTdiSlpqMXBBdjFTMkFNSjd4VkM5NmVTRDRlRytwaEpXU0dYK1U3SElu?=
 =?utf-8?B?UXVJYkZuOHI0Mmd0OHcvU3UxZ1BjbzJXaStVdmM2ZjllVDdkUEwwVWU0SFFV?=
 =?utf-8?B?WXNyQ3dsZEIzNXpSRGUyeHArZ1pFZHU1S0UzbExYcHYwWVZtdXE1b1pOcThD?=
 =?utf-8?B?NTVjdWZDQ2dEdWpTR1M2cEhBSHkwdkI5WkE0dVRNcEFkWlo3SEJWV0grMzF0?=
 =?utf-8?B?TG1IQW8weElUejV3ejRKYnVRWGJ4ZnQ0NGM3QTdWQkowRUZIMTk2UDhrNlor?=
 =?utf-8?B?MjBzdzlGRzRVSU5SaVIxWjNDc2dTZ09FN1JWWE56ZW5UM0xwcGh6K3h0Z09Y?=
 =?utf-8?B?SmNqTzZ0aVpXRWhOaGY5enJmQzN1cndpRmpNTjIyb2ltYnk5eXFkajRRZHJJ?=
 =?utf-8?B?cXBISzJCYkl1R2dxSHhXUUM5K2ZRL2JLRjFKczltVkNRNk5TQUhNVG1rS20r?=
 =?utf-8?B?R3puWnNDTlFwKzNuL0JOU21uWnFobjVEdXhOcUJBcDBMRDFLZnZFOVpjeXMx?=
 =?utf-8?B?WVV5Y2tsSmJ3VFIvOXFTT0YrdkZ1OWxJQWJXWm5rbkNQUnpuOW94U2tlYTNN?=
 =?utf-8?B?YWxHemg1WXo5WnYyeEpUN0JvcGVUTWp4bFNRZ1ZibGtKc05lMm5mNzFWK2dR?=
 =?utf-8?B?blJMd1JBbGVwY2ZwajZkZnY5YnhtZHJkbi9YSTF0OGlUVnYvT2dGL1RXRzhj?=
 =?utf-8?B?YVVoU1I5SkVFMk10TzlrY2xwSTN0RDNNNUE0bHBQeFhDSmdaa3A1Zm8yS3kz?=
 =?utf-8?B?N1lrcmVWWHhWamEvRWUrYjNwdXVFamZBelBxeHM3VlphbVVEQkVuR25EcnhY?=
 =?utf-8?B?M1dlTWxvdFNXdHdRVVl5NmwrZkttb3FsMUtpVnp3TDRYMUpGdEVEdjhESWtI?=
 =?utf-8?B?QzdxdWhRemhVTm9YTk92Z0VmTjNFL2orTm5hMFpiemZNVk9RMmY0NlVMVFIz?=
 =?utf-8?B?NkxVRkhTVjFQT0xvalBxb3Uxc0xrcE5oV3Vjcm5kc2JKRGFNd3hTbHFWbmVk?=
 =?utf-8?B?Qm5MVnBiZi90Y2V6UHNabTBQa2hEZTIwcFhWTldua3cveFY5c2NvaUg1cDFm?=
 =?utf-8?B?VnNheWx1bi9iK0sxdnNWZGtSSEtXQXlzN0pXS2ZOT1VSTHhwWkMzckhOZFZS?=
 =?utf-8?B?Ym15ckszSml2M3VMSkVIOUQxZVZzUGxYYlFSR1FKakVXeGZCamNVT1NBYWRE?=
 =?utf-8?B?NFYyazh5ejk3KzZnWHJCWk5zcnVzV0E3NlV0MXlrNDA3UFVqRXNMSDQ1VW51?=
 =?utf-8?B?VHJ4ZHNPS291TXhJdWxJWFFFbzdtcVpPdTQxTHU4a0NqbjVIOUxPSWJzVUN4?=
 =?utf-8?B?ZWNWSDNUelJsK3pKMElaV0xBdUJwUWtQSkthVW9HVFR3bCt1Z3huNCtQNkRT?=
 =?utf-8?Q?gbYmofDzFyurd?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(1800799015)(82310400017)(7416005)(36860700004)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2024 12:34:48.9126
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d44d0ca6-eb8a-4755-3fa3-08dc75a49392
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE3E.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6891

On Wed, 15 May 2024 10:27:21 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.8.10 release.
> There are 340 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 May 2024 08:23:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.8.10-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.8.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.8:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.8.10-rc2-gcfe824b75b3d
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
