Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2059.outbound.protection.outlook.com [40.107.94.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0300F13BAE3
	for <patches@lists.linux.dev>; Fri,  4 Apr 2025 19:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743795018; cv=fail; b=XdARiSuHBOFwuNaAOo2oLDsHlOAaFk9ZIaz/vt0OdJjWt2LZl4Sr0vN7cbRSfUlKh+SxPZWgyGsQq0ur5G0h7jOuyMgFW1kBeX6evkE6muekg5TC929maLP6x351qiDnYBYEtrKgMv+QTQdF/F1onCVOyzZW6xaA1dd8KNx49vQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743795018; c=relaxed/simple;
	bh=vQ3tY09rg+Pi02Nv2bV73UiU2GCQCFu8Pim0HqBNyW8=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=dmJ4ZbS3gwUXzL9OKwWy6yU8N6iNcKDipqTAHVHbWgrhZV0mqeUD/p6fSLN2RXbzoeOgJyCSU0HKRTjKmpVrmk0zocQ19zIJEzOfZ8zpyRCdVDPOtJKLpnXD/Z9wZ01pnVc7yvchw4Ckrjd78uwtBMh7La6sr0tnaBWy1P9sI9M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=jwze3SOz; arc=fail smtp.client-ip=40.107.94.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jwze3SOz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mFNrQHvYlS2f4uxqSUgoLB5vUXBcDofQC/5qqWwcyZ4i/1FAIip5gqeoYojfNAEQHRDD2qrB+sgwHsATweuem/uF9frKt6vXEeL5ZAT/fQVBChDnUQBbqvN4Y8BrCy1FVN97HxXboefacRCbb1bOwkWdw5LMAB5UmaYkgRH6pY3B1HWbppZYGs80P1ZcsLGNbkn18zGsm3fid3KYC8lzJ7iRLwBnuqRDg5Skf0lo9wLr2vSF6xBTH7H0Xu+R/KHnSndAhrL94+z9C+r/LCFh7aIBN5rtAX3ybafTFYgwMfPWMdIJijrJTaZj2B63w5Ntp8KBaRvwrCG2gtcv7vVdnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UEzEBBci8YYRHBsW4svYHVeJ2LK0S3KGVsCwdI0+ZD8=;
 b=hjQhhWq4sxE6ZA5vZUQ1LCspAQT62NvYCmg+wuDJs/cKvT5Qwof56jVjWwfpzA4Ik+MwuaU51F5DR8Bwfos27K1AQuRz7PYkSkPL7nT+LQXRg7Ms4GxRFj5QyM/7HjzO14EQSNARfka5xNRKUE85Ro1/SEx44HfRWXxIgejKW0L6+Ze+rI6vc3jCgbVH2jyrIGpwzs7zQ1NoTxjCB1m1N4JR+phXkpbOrgLuH49S77QorzLdRDxY93wVy7sD/gSkbZ0F0s9YP6J6vX8ABMBMhltd2JwDUKF+L3R6ad3IA3mEC6iAka9hCQqOZATWcE7OzFKknTDkgEU8n2dMIPitYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UEzEBBci8YYRHBsW4svYHVeJ2LK0S3KGVsCwdI0+ZD8=;
 b=jwze3SOzCmq62WIQJ2Xfd626wYr3goFDgMG/gMQAIE9ACzDIWdWYNY+IopSutasIoNTYo9Zr5lXIinn/uht8/BJXaPLrhAHQR5Xl1oJlW8/rU1A6vcZqlNgQnenbSTWFq6mtLzu+yuukGQnHY2P0edtzGOclRIns37FXlBxspZyywrMAh+HX7cnsEZhu/kpJrxpUKGpEWo7zp59gPMS+exzxtUuI/OpsKvxqkrBAfJgdOmV0C82mad/RtLHK89wT5zphaTLtvCwa0aDVk0mdKP5uO4i2YX23/Fk2gbDr6fKgj9Mc6X+67/uTIF4k9FmnxDx0Lms5+MlB/VMYG3Tkkg==
Received: from PH7PR17CA0027.namprd17.prod.outlook.com (2603:10b6:510:323::13)
 by MW4PR12MB6755.namprd12.prod.outlook.com (2603:10b6:303:1ea::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.53; Fri, 4 Apr
 2025 19:30:13 +0000
Received: from SA2PEPF000015C8.namprd03.prod.outlook.com
 (2603:10b6:510:323:cafe::cd) by PH7PR17CA0027.outlook.office365.com
 (2603:10b6:510:323::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8606.27 via Frontend Transport; Fri,
 4 Apr 2025 19:30:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SA2PEPF000015C8.mail.protection.outlook.com (10.167.241.198) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8606.22 via Frontend Transport; Fri, 4 Apr 2025 19:30:12 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 4 Apr 2025
 12:29:57 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Fri, 4 Apr
 2025 12:29:56 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Fri, 4 Apr 2025 12:29:56 -0700
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
Subject: Re: [PATCH 6.1 00/22] 6.1.133-rc1 review
In-Reply-To: <20250403151620.960551909@linuxfoundation.org>
References: <20250403151620.960551909@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <0eaf3ae5-c371-4780-8c1e-5cd05087223b@rnnvmail204.nvidia.com>
Date: Fri, 4 Apr 2025 12:29:56 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF000015C8:EE_|MW4PR12MB6755:EE_
X-MS-Office365-Filtering-Correlation-Id: b28409ba-bb9d-48a8-96e0-08dd73af1ebe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NVE5Nm0rd3hxcFgzYlM2Yk5VbkpCSE1UMlNCSFZRQ1NRVHpNZm9DZllMQ2do?=
 =?utf-8?B?bURYbzhGS3BSWFFNbUtkWk1XVkQ1TzhVKzcrWjNndHIzZ3RFVjlDSjBwOENF?=
 =?utf-8?B?ODd3T3pLRUxjYlBxTDNCRHZ2MS9zOUJYcEVhU20yaTJ4TWdjQzFXVjBISU13?=
 =?utf-8?B?OGM2cU5iYjJWTjk4WDNDTGYrMXk3TExHRzFIeFBTY1A4TFVDaXU0NHdPc3V3?=
 =?utf-8?B?OXdpUDl6VkNRM29uaEM2NkRxZnQ5SXRrMjZoRU9ob0VqeVZPWSs0bGNlZ2VH?=
 =?utf-8?B?YUl4aXgxR0dEN3gwalorT0xrUnJobEI2M2xxMDB6TWN2dERWQnNLUzVub3lx?=
 =?utf-8?B?NzI5NDFXNUxWTGxNM3YydWoxWWZVWXkycTdTQlNLY0xFVE1FQkpXWGcvSmk3?=
 =?utf-8?B?dTJTRHVVQmtTQituSXMwVlFGcEY5U2tSQmsxaklmRjY3Z1h1MEZTWEUyWUNI?=
 =?utf-8?B?Wkp6TlRHVEV1U1pMZTNYUHJCYXlOcm1qWFkvWDF5UjNmWWlGZElBejBBaDhS?=
 =?utf-8?B?K2pPZnRHSmtmUVFUSVFnMDhQc0QrOWwwQlRRRzFRSlVKTTJwT21Kdk5RYkhZ?=
 =?utf-8?B?Qmw1bENXdEJmMm9JaXVYZnV0SW9lUEs1L0YvWlFrVEo1TGVZK0x1d05ERjda?=
 =?utf-8?B?bjF6T0hVOWQ1WnlMelYxWUR5ZTM4OUhRTjNCWXFnU3liQkpjeEdRbE9XQ0tU?=
 =?utf-8?B?M3d0OHlNWkJXYkdyWjF3R2pZT1JVcVFhMHROZkc3UWd3ZjVXU3NIYWQwYURr?=
 =?utf-8?B?RkFNajNnY3ZyVUtWMFFGNXUvTWFOeXNlMUpTUjk5L1BUdEZ6TUNRU3RzV3Yz?=
 =?utf-8?B?RG9UMGIxMGV4em55TGlSTlhyMXQrYmpLWlNzTmJJYlBETEt5aVZpMm1BRHRs?=
 =?utf-8?B?Qy9oV1IzT2tpN3lMYWNUUTR4eTJteUNyRjhXTjhwWitPcTU4NkpkVnN5MFNI?=
 =?utf-8?B?K2VkbUV2Smt1TG5vc1NSUUdxaUhyOUQvTHlpK3NHZG1tbTBCRlk3SmxTMFNU?=
 =?utf-8?B?V0tQcXBSM08ydmtqeVFVNjROWGsyeXB2Z3Y5U2o2OXFPK1hTK21pV0dLaURi?=
 =?utf-8?B?UzUrVkdCM1JvWXVNWmNMamx6ait5c1kxL1NCK0ZuZnFRbGdMSXFoZkhRZzVE?=
 =?utf-8?B?WC94ZWtMSW9TS0NnQUVXSWFhcjFWemkxV2RlU2d0L0tEQTR6cEJXUEJzZWJ3?=
 =?utf-8?B?RDljUTdXNlhNdDBEUTExM0diTE5kUWdOSnZ2QmxOOThIQ2tOU2lnVE5MeElo?=
 =?utf-8?B?bGFDWUgzSlV0aTloaFFVcWxTeHorM2FMU1ljblJLNHNqOTBXS0didkJhZTVn?=
 =?utf-8?B?S1RoWEJrY0FHYnVvSE4zY0hGdURMMzZxK1VrRlFUVWtuVTVoNDlkQzZTbFlW?=
 =?utf-8?B?aHkrS2daZndiRFB1d3RqMVZtMyt5WjdmZldEMlhlRkdCSEhTVkkzM0ZVOUlM?=
 =?utf-8?B?VzlnMDRPWDZtSW92UXM0VWMzNTk5dHp0VVM1bDZWWG5sU1MyRlhyeVl4SkRv?=
 =?utf-8?B?eXkrQmZoUEd0dTFCcEJRNFJEUDFQblplNDNyQmV2WW12a3doS2dud3JzclVh?=
 =?utf-8?B?YUNQQ1F0K2JiN3lRWDZVSml1TGFDL2NseEhyN1ZTOTBqSlMvSjRJbU9JM3di?=
 =?utf-8?B?ZFF2b3VaZFlrbnVRa25idi9BVnVnRmVwaGFwNldaM25XM2pqbXZWQ2lrMEs0?=
 =?utf-8?B?SW03MmpCU1VEVFJaY28xalZuYjNKWWZndHFGem1hOWVudDFBUHo1NmV1SjBj?=
 =?utf-8?B?bU5qNUN2RzZrekVtSVZtZXkzRDdWZUhqWkhHS3RuRzQ1QnVzTy9JY2x6ZXdU?=
 =?utf-8?B?Zy9pNTBlT045RXFDYVYxNTdvWVlPU3RNRXB3NTFRV0phRHgvYzQzWUo0NGcr?=
 =?utf-8?B?bzlocWxsY215N3JaYmJVNU9waEg5QlRQamJJVDFQcVdNSm5WZW1ieTlLSXY3?=
 =?utf-8?B?ZWxoTWZ2M1dRYkRUdUZObm1OaVBFSUZnOG1IdmtyU2F2R2h2dDZTQWdNcERn?=
 =?utf-8?B?VjBJdmIwZUlQRElrRjlNVktmd3JKS3NyV2NzTTBJL1dNVldwQUdQZmdINWF3?=
 =?utf-8?B?NWYzdm1XM2hCQ3FVK0lNcG9BUlowdjE2cys2Zz09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2025 19:30:12.6412
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b28409ba-bb9d-48a8-96e0-08dd73af1ebe
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF000015C8.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6755

On Thu, 03 Apr 2025 16:19:55 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.133 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 05 Apr 2025 15:16:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.133-rc1.gz
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

Linux version:	6.1.133-rc1-g819efe388d47
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
