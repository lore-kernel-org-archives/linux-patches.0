Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2084.outbound.protection.outlook.com [40.107.100.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 680F31C7B63;
	Tue, 27 Aug 2024 17:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724780789; cv=fail; b=eQBfawvN+irLuLzkd91bVTc0nKSns6aNSsbdk8ZdZnT8Ud3R1wNfj3KWMli2ZvlPWq3Sg5aJlBsRZ8kSierXripXua0JiVa7ZaH5v26aIKOQbeaHXxCf/h0JQnmzGrqzNe5YbZGy3qFxLqCJwjjVSIA2WWoP0DdByWOm2fWIhpU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724780789; c=relaxed/simple;
	bh=v2soILAJ8nrh7qdnR0HH8Q6sZ5lo4SBo3tmlAXY9c2Y=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VmGlqmWLEiA9DILJE/MfRsu53CD+IPDRWLZiI9aujp9xpX+EodCF85nBmqyzP00JJuaUGT5u3tMQf0yxa2RihFNV/OxrCAWUbO9U58xDwPov9txumN/6oxIQC+ufM1N8Br3+IeTK2yuj50aKIUN81e6f6jHlWkRoDXlV++znNvA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=NVHCzQQc; arc=fail smtp.client-ip=40.107.100.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="NVHCzQQc"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wkptewcFe6tM6JGUQygOvMFdkaj57KQSXe8IyDnoMZR/SCYDqU2gzzWnWheXGgAapSOFDM9L/13tvvTZY3tsmM7QrNCCdJ0mfA3K2ZJqnv298ecmvGdXyKSx5aKyLY/0KbZwLhZUe8CYmQP1Ko8rJqcHmbFK24/MbL6d5c1mnIlXRUxKiIvyLASQRiLOZn45Jn7xG7L68cId/YPYu3On8XhjTwj4rulMz1iTQ5eS1UirK6ETbbbCs7bYkVq87d+06whKOVoOKKnTbpT+XnwsRJuMKpuX1UL8J9vilAXQEcm5lky+mB4e73Y7tNl4DrNHMgfjEyODdsaUcnEoO0ALCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vD2zmlmdvDTu0H4US+KFADD3/tMk/DvA9o20gLw1Vlk=;
 b=HKp+QblSC2rRW//RbhYw8PD01ApvFOvsUuI2ZiAv9KThUgnTsaAqoVXcAEmJYB3S0ndoqTGNz9brzxBvU2f+DSMh2Hj3/eYzAtIhAgbNRweWe4DhMwaJHCKLFrRvhLHCBOLWerRugN02CKxDZOPq0Ni2xWgaZN53lGIDXZq5H55O6BiPACr4zAL/Y8TMTkfPZqlOq8SB/tic1ZFE2NKx5hN7EjiBgMUIjh2iyNd117wODnLIZndYeaBq3nrCRgpvDIOi7NSmdXzzrHva4k/eyxXq3fVpoCI1Lz1f02qoz7okv5VHruGenf3Y2yrQ+Hpt5SBnER5YPqPIuW3Ujhvr8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vD2zmlmdvDTu0H4US+KFADD3/tMk/DvA9o20gLw1Vlk=;
 b=NVHCzQQchgdX9ZFKMo9fG+yruK/kPxcIXd4o4VLaZPyRJjVx9LEJqqWdM83v0n6P0JhC8aCrW9vhRZCOjrtKGtd62FXZUkcobs3TjP6P8aVdUre98q6XzzyyNkZ6MXL6XAeyuIHsNjW7yNpoEuSO4Dw/oJ9D18616SGLaFhYAwOAM4lKA31eNSNlmgE96Pu10jMKZs/UEkNfkn165aXamMnXIrpVjnviDo/baimyhXizBdWh/3uy/JCZ0Dz6DDBOlqchEFzFQ4tQClXUPyHGtFQXC7HBjgkEZLfzul7gA/ZpD+eaXoaW0Gx1B+Ee3lMEvxtqnD804Ijy80fl9Rug+Q==
Received: from CY8PR12CA0064.namprd12.prod.outlook.com (2603:10b6:930:4c::10)
 by PH8PR12MB7304.namprd12.prod.outlook.com (2603:10b6:510:217::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.25; Tue, 27 Aug
 2024 17:46:21 +0000
Received: from CY4PEPF0000E9DA.namprd05.prod.outlook.com
 (2603:10b6:930:4c:cafe::4b) by CY8PR12CA0064.outlook.office365.com
 (2603:10b6:930:4c::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.26 via Frontend
 Transport; Tue, 27 Aug 2024 17:46:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CY4PEPF0000E9DA.mail.protection.outlook.com (10.167.241.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Tue, 27 Aug 2024 17:46:20 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 27 Aug
 2024 10:46:10 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Tue, 27 Aug 2024 10:46:09 -0700
Received: from Asurada-Nvidia (10.127.8.13) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Tue, 27 Aug 2024 10:46:09 -0700
Date: Tue, 27 Aug 2024 10:46:08 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>, Kevin Tian
	<kevin.tian@intel.com>, Lixiao Yang <lixiao.yang@intel.com>, Matthew Rosato
	<mjrosato@linux.ibm.com>, <patches@lists.linux.dev>,
	<syzbot+16073ebbc4c64b819b47@syzkaller.appspotmail.com>, Yi Liu
	<yi.l.liu@intel.com>
Subject: Re: [PATCH] iommufd: Protect against overflow of ALIGN() during iova
 allocation
Message-ID: <Zs4Q4JRz1z3AFI2f@Asurada-Nvidia>
References: <0-v1-8009738b9891+1f7-iommufd_align_overflow_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0-v1-8009738b9891+1f7-iommufd_align_overflow_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9DA:EE_|PH8PR12MB7304:EE_
X-MS-Office365-Filtering-Correlation-Id: 6dc4cffe-3e3e-44d2-fc65-08dcc6c02950
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?olGEXkc5Qe2cEev6eO9Xh+WXENTMZj2h5sWuk9eN3HP8G8x0Rh9d4N+sgaaU?=
 =?us-ascii?Q?9zIvnFPjK2Pzs6y+Z6gdp8BJxkDC/ZUrgDlUDqt6U8WUH+akra2kmCvgG6IZ?=
 =?us-ascii?Q?yo7SabLQ+lhnhwcuO4GG/bq1PwDH7DLVnfWj8qWv/eDDM+6FKHiNN5G2y/H1?=
 =?us-ascii?Q?OcxOO8xZJNamh6Ag+OZaUsgxW962+hMg+Z9g9XBZ9imY2u13dd6/uhttScV7?=
 =?us-ascii?Q?72VcuvZDpaQyg5ZhpTDPpVksdEk9XFqSBzLdVHg528ZeuKpxYtepdrERCkO2?=
 =?us-ascii?Q?0J1ll8sYnRDsVnyNi1A7HnXQ4vdoX8MfbcPQKQDlATWT6UFEdGq1dhK/dfDq?=
 =?us-ascii?Q?hd2/mgS+cIgjX4UTKAIK1lahy/QtR4tFcgzyforVJx/DQwqDnXpryAgPo693?=
 =?us-ascii?Q?4/r0AYF/ZQNElPl7xbrVbFeweW5aVeF5OWV+XSk1Huhke8u5pRuSlvguz7Wt?=
 =?us-ascii?Q?nBG0JvFZSY6IVbrBvnPYUYjCuTUTOCzruUk5/dOUHdsBe4RL4/KmKMyP54Ai?=
 =?us-ascii?Q?9fUdjSr3x77sTgtwCVbJgQAJ1+W7kaitheiebuLB9ICM93/4W2hsee1/5u9v?=
 =?us-ascii?Q?hKvTmkt6zdw446ghoRTeV9j0gT13Ft0hdKLkFkhApYe706nOW1uZG0QSnj1O?=
 =?us-ascii?Q?xPADwMwzFTkluQKRf2tRj8hr8U3Ekq5sziO6Crdwd82KTZnghbudq/hj8SRe?=
 =?us-ascii?Q?7rdWeijuu8PtgkZXXPgYC0J/fq2kWFRjJZArymzdmi13ScAsY71tgfq4H6Fa?=
 =?us-ascii?Q?WWr1XnP3XQ8/5hZ6fpeiWLr5j9/8NI/4NrpqYd3YteoyYWNE6Q+c4XpECOaC?=
 =?us-ascii?Q?i5l2laRe4z4jRjmepz1CQf+PrhAm6UlfTJr8dEMAcy+qbu/6IU30AW142hAj?=
 =?us-ascii?Q?PcntrcU3n24Y1AKa2Ww+H1EwzxnuZSrrf+RXeceVzI5o+PUxcTt+ov7/JOVG?=
 =?us-ascii?Q?pc7yHDvQ7jKrpYRNc2ZlFoJEALzgoX3GNOOkDTlMnD0ENtErOik1yACuhuRA?=
 =?us-ascii?Q?EAbC+D30IupNoEW91jHvOnpf8RrsPJSeZ9JoqA8leFS2ijyCu0f+iMmbjSvB?=
 =?us-ascii?Q?1xJMdStLCZgkjeemUZiHZhEX1RQULfGBRyBrNrqgiT/yZ5Mlq/wfoO4uxXeE?=
 =?us-ascii?Q?8rc0xcq+baZH4NkgQZwEwA/RQv7hcBLumSE2QS1okYT1iU6xrNBmFRWlzpHb?=
 =?us-ascii?Q?U8sdvtQ18/ljkIw91KWB4XX6ITkrqhuN+G3ORJrO9Wk+kKxPsAMgerrtUJ0u?=
 =?us-ascii?Q?QfnS5P+gLIrWfTee0fg7mqDAS2ggq+oqqA8H7OW6IHosrrb45xcNpcHpkuFQ?=
 =?us-ascii?Q?4IJlYWA0t/88aQX6usnO7JahLeSKNHrV5TtYn+fk54p+pLVAWK6hDN/teh0K?=
 =?us-ascii?Q?VyJGhuyQ8ZZhwILXiqmA2Nws3kpDn+hv2lgtcx965eZSC/CT2TybbCf/uOV0?=
 =?us-ascii?Q?P/RjiR/v+d2Frpo5H2ivBbJb6HZKvFgS?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2024 17:46:20.7867
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6dc4cffe-3e3e-44d2-fc65-08dcc6c02950
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000E9DA.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7304

On Tue, Aug 27, 2024 at 01:46:45PM -0300, Jason Gunthorpe wrote:
> Userspace can supply an iova and uptr such that the target iova alignment
> becomes really big and ALIGN() overflows which corrupts the selected area
> range during allocation. CONFIG_IOMMUFD_TEST can detect this:
> 
>    WARNING: CPU: 1 PID: 5092 at drivers/iommu/iommufd/io_pagetable.c:268 iopt_alloc_area_pages drivers/iommu/iommufd/io_pagetable.c:268 [inline]
>    WARNING: CPU: 1 PID: 5092 at drivers/iommu/iommufd/io_pagetable.c:268 iopt_map_pages+0xf95/0x1050 drivers/iommu/iommufd/io_pagetable.c:352
>    Modules linked in:
>    CPU: 1 PID: 5092 Comm: syz-executor294 Not tainted 6.10.0-rc5-syzkaller-00294-g3ffea9a7a6f7 #0
>    Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/07/2024
>    RIP: 0010:iopt_alloc_area_pages drivers/iommu/iommufd/io_pagetable.c:268 [inline]
>    RIP: 0010:iopt_map_pages+0xf95/0x1050 drivers/iommu/iommufd/io_pagetable.c:352
>    Code: fc e9 a4 f3 ff ff e8 1a 8b 4c fc 41 be e4 ff ff ff e9 8a f3 ff ff e8 0a 8b 4c fc 90 0f 0b 90 e9 37 f5 ff ff e8 fc 8a 4c fc 90 <0f> 0b 90 e9 68 f3 ff ff 48 c7 c1 ec 82 ad 8f 80 e1 07 80 c1 03 38
>    RSP: 0018:ffffc90003ebf9e0 EFLAGS: 00010293
>    RAX: ffffffff85499fa4 RBX: 00000000ffffffef RCX: ffff888079b49e00
>    RDX: 0000000000000000 RSI: 00000000ffffffef RDI: 0000000000000000
>    RBP: ffffc90003ebfc50 R08: ffffffff85499b30 R09: ffffffff85499942
>    R10: 0000000000000002 R11: ffff888079b49e00 R12: ffff8880228e0010
>    R13: 0000000000000000 R14: 1ffff920007d7f68 R15: ffffc90003ebfd00
>    FS:  000055557d760380(0000) GS:ffff8880b9500000(0000) knlGS:0000000000000000
>    CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>    CR2: 00000000005fdeb8 CR3: 000000007404a000 CR4: 00000000003506f0
>    DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>    DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>    Call Trace:
>     <TASK>
>     iommufd_ioas_copy+0x610/0x7b0 drivers/iommu/iommufd/ioas.c:274
>     iommufd_fops_ioctl+0x4d9/0x5a0 drivers/iommu/iommufd/main.c:421
>     vfs_ioctl fs/ioctl.c:51 [inline]
>     __do_sys_ioctl fs/ioctl.c:907 [inline]
>     __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:893
>     do_syscall_x64 arch/x86/entry/common.c:52 [inline]
>     do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
>     entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> Cap the automatic alignment to the huge page size, which is probably a
> better idea overall. Huge automatic alignments can fragment and chew up
> the available IOVA space without any reason.
> 
> Cc: stable@vger.kernel.org
> Fixes: 51fe6141f0f6 ("iommufd: Data structure to provide IOVA to PFN mapping")
> Reported-by: syzbot+16073ebbc4c64b819b47@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/r/000000000000388410061a74f014@google.com
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
