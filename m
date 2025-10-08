Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010004.outbound.protection.outlook.com [52.101.193.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E468C296BDF;
	Wed,  8 Oct 2025 18:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.4
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759947450; cv=fail; b=I61uzysalGbrAx8nakfiZSURYr5dRn/DH/S6sUfp8rjtYWZg1SXhrlLhz4B2Zo6GcsHWxyPK2ly4gSNpmyFw/WYsxxKExJ7fIzl43VARX9uBrV2rHsPJf3AslFSKGR7f5DK9gdkuZsKcT0lkt7A7tNXLIohqOHXRDVexqx02nV4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759947450; c=relaxed/simple;
	bh=xWJlYQYdDkMEboa63CQ9vOZSqEWngvpEEA/nQFl6qsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=IK+Der7+degWWUIWd/TBQKLQaKjDpqcCRjCBt3lXSoJgR+o/eJ2jLfhMOM0zBm6V1VsXEzQ2t6tJ5lymDAi779yA8+mRx17iTt99SGongCsGSrpTiFfEW5UMEt04rhdqFmPX/CqORzbuiGOboFpvdhyRSdqyKO5ZmbdMFaNIOPM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WCS29yub; arc=fail smtp.client-ip=52.101.193.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WCS29yub"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MZhubLpYaIxKR90vpzQU47WNP+7utl1DxxdQ2iYRx3AB+gswwL2oNwSTcDUoe4GuCYFJBU4lZclvzTB8OQtXFPMfEHdGofMsLKFTUd3a2ZZn06Jkm363hpx0rLauh3We4t/t0jDyVQiqkwE/RuoPMyvt7oI3Pwu7XxH1PKyOPec/FSf4aCzpgL6oDEplIMb/4wzvk0u/UEQ/uBCMNHE2enZYbwL72GAoRQiPIzHMzprbe91a0NNyC2yDgVApsA5q+zAIa1slsDqQErojBsjQ1Hy7ClolzoKR8R2+sauteuuNXqEyTonlJkKE1qSA1yxMZeOknRDEY8+NFrnDw39cMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tuCv0BJBdG/lvRiIW8s3rSANqM4r3s39hwY+rH6jXv8=;
 b=jaRY3RtpHf3SIGP88JOEKWmNawZAbGqPWIdeRjy0V04uougdgYvjUxRd6cttW4yPxZ5xHvV1AbboVQ2RgbnbrAzLdYbHS+n4sGuOu2PcXFr+vja6XNMjnwEtNZTXWhKVdmQL5iaKikfiZYzEl4JWXrKwd9CZmq5Yq4MH9PH1FNgnGHolCYxD7wLVlgs7Y0ObWbW1TR05PfEewT2mx+TaFy47xnyhZ5Ftu+LyVbipDwTlHilzokCD+Qjze6LWD/2hQYHL0CSZi4a40qUHa7Wj7KNeTRe9zc1Rox3gHNEDC7cSAhnAxkGoFHpCK9vhTlgEBXTFzPHi/e7ISEvTAkYA/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tuCv0BJBdG/lvRiIW8s3rSANqM4r3s39hwY+rH6jXv8=;
 b=WCS29yub9mS7OKSvr/ckbY2wT7/2J2y65BY/8qmHK2zgg1orbupr2SNc4zw8a3NeJon9kchEaQGjZhbOtuY7aC733tQkKEGM5u1WNNMJ/ovwmWqxRUTGe0tb27Q3vSXliTKv1rAA7y7cgmOy7/Kwn6xiASaAE0NV2HQH+ce1p1IBmB6Q+r5q/Sa++KjR9KznVj8WkvGmNgGIPGzP4/2JMo0S65bQNrrFy7cyBfAUg7FZqsjWAf3roTyLroJJrkCS2Ageg/zNSPrZWdqHj6p2efVk772wjUDAI5ZmGn2KwgL+1tMbiTGhVPfTFaCROsXyKfVtlvwRMdu76v6WcQvZBA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BN8PR12MB3604.namprd12.prod.outlook.com (2603:10b6:408:45::31)
 by DM6PR12MB4122.namprd12.prod.outlook.com (2603:10b6:5:214::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Wed, 8 Oct
 2025 18:17:23 +0000
Received: from BN8PR12MB3604.namprd12.prod.outlook.com
 ([fe80::9629:2c9f:f386:841f]) by BN8PR12MB3604.namprd12.prod.outlook.com
 ([fe80::9629:2c9f:f386:841f%5]) with mapi id 15.20.9182.017; Wed, 8 Oct 2025
 18:17:23 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Kevin Tian <kevin.tian@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	patches@lists.linux.dev,
	stable@vger.kernel.org,
	syzbot+093a8a8b859472e6c257@syzkaller.appspotmail.com,
	Yishai Hadas <yishaih@nvidia.com>
Subject: [PATCH rc] iommufd: Don't overflow during division for dirty tracking
Date: Wed,  8 Oct 2025 15:17:18 -0300
Message-ID: <0-v1-663679b57226+172-iommufd_dirty_div0_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA1P222CA0023.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:22c::15) To BN8PR12MB3604.namprd12.prod.outlook.com
 (2603:10b6:408:45::31)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8PR12MB3604:EE_|DM6PR12MB4122:EE_
X-MS-Office365-Filtering-Correlation-Id: e6343b95-bce2-4ebf-a5ab-08de0696ed38
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1e2ineCndt0rSHDuZAdIDbevBtiRLPv5xYblENPlPcfIpe+3tnw5WWOxIcyR?=
 =?us-ascii?Q?ZMFqPUgux/p2+E8Wwvn0PdLDdTis9aMlozsnvjwgGictUGJIYh5dmT5fR9dU?=
 =?us-ascii?Q?yYH0LHL4YLtyKcTPWdx58ndhuYOt2gd4I5w94RtWlziOApH0jO5QTCQnTCsm?=
 =?us-ascii?Q?5z/JEwJvNDXqT6JG8MzpjUOP7GL/UJxHO8VwJ8k3wHwANaZK7weEQJ2Q3UhF?=
 =?us-ascii?Q?c5r8yY14MHYeMBMKy4Obq7FzdG8z7mmBzTbGf8gkQ5q78EJrLHrHxnsf5aIv?=
 =?us-ascii?Q?TcrmyJ94LP+MHIMVZ+NCLlYwd2dc5d4j0SYeby+7l/sNbLXUaGNmXppbCMdp?=
 =?us-ascii?Q?0ADe2U3+evqlpNLzIxZiqzCkDu77+ZnWiIdodEPH4k24Y1mvKXSgDPho165q?=
 =?us-ascii?Q?oJffJzihpaRb94MkXaDjfpvsK7wQLPgmTamMBqeTX6bJiJ9MfoZnzaWKts2i?=
 =?us-ascii?Q?mAvrH5/Caid0iBfGanAC7FjI2fgkRTaEieFl/wil1b7KpN8/vJGPkAmyhya1?=
 =?us-ascii?Q?TN/I4MSTfZUhkY/hQNUfR1wIskJ5jNHrj/QS71CnQuAFRm8y1qreEkKqXKrx?=
 =?us-ascii?Q?M2ONpwT5sewliAuRDXJcP7Qle0ftAem/C3FTjIGulAqWnBbfejC9e8J6Bf/G?=
 =?us-ascii?Q?KA9tmJr4EumC9Y3UqUJMq1eY5rw+G1/XkXxzBFm2ob9GYUaxAw2BdeM1Xzsf?=
 =?us-ascii?Q?t73QXMxlQg1U9GIvjy0GWyZRbMnsHlZxHsxb68//WNec7lsOUlmRNoLSY6P3?=
 =?us-ascii?Q?7ICbFS1QsjWfZq/wKLDDgASMOFp7+NI6MtswXCycuPT8OqXAHWDVBJm00MB9?=
 =?us-ascii?Q?9iD/A6beDnTtvCHT6/oHh6Ab1tjBA4coDhSyxW4w4l1AYHmZM/P5qSKI/wO/?=
 =?us-ascii?Q?lFxQumC2dQEJgyIvTbhMwKBWVv6dEI+P9gq0T3pTpP7ehgl3Vju9idlS/pJh?=
 =?us-ascii?Q?zZffPjjZD9tY6fhQdLDG68rW0vAmVyuhQjQbdC0BwKOIbD3J0pacBtiYaGFq?=
 =?us-ascii?Q?bznn3gCWVbV0akWAUH+UY7AQXU1YTOHP776ztNBvVh72AMtsx0OK0k5ldrx3?=
 =?us-ascii?Q?udhAGGmwvQBtkFYNHjujNri0D1EJzkTZvvzOWRZJbDdCxcnjDdiQjmIp2yZc?=
 =?us-ascii?Q?N0R/8+cf21QlBUNsmE/oFWrbW4wmED9hf6iEYgvoEF3sH6gYBzdatq4EFFhb?=
 =?us-ascii?Q?CHUm3YP1y/mGdcKNc9FFicve+gR1MZB5h9tMOa5fhZlIzyyqMjLeIgvMcI9p?=
 =?us-ascii?Q?a4P9SEFFQ2Mr/IoUPd8KGorDLbhk61F4PB4r5aBsMbR0i5LWmR9bnuzMIrRf?=
 =?us-ascii?Q?RuyuLv66V61QugZTTmuDgBP8YysZvjbJiNZHCQ/e7M70MAavdJ5ICTUpYgJ/?=
 =?us-ascii?Q?/Hk8kvfVjmCgxdcbAPszs0b8GE/hMfzkkOCShu1t6nCkY4vPw7gQ8AH+G/rr?=
 =?us-ascii?Q?7oFDmFOzE1It1KBMOmaJ89+zVg3inF513gELPDMqOwLoZ1yV72Lh9A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB3604.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NX7KszenU2enOZxdVQY25ZHVEdQjIkVdMxK+MwmSyzSfPLZdNffcSIn+0one?=
 =?us-ascii?Q?t2POYqJkhbW4rmBQ5YdZBLifDH+3Xh3b6WcmUPjN0QP1VSfPf23MlsRbWlwC?=
 =?us-ascii?Q?vjR4TTbvgMfMYAxxeTPtdg7jSm6LJ0HCas3FOCd8gYgQT6BtuyBHP6njYz+2?=
 =?us-ascii?Q?s6sFk9bHkNSbM0dhZVZaq7IGyle0Cma6cTts2fiEwGBBHvpD59Fgxkf4Yj+D?=
 =?us-ascii?Q?Oe62JR0UooHevvmM0S02dlMs43liEuf2Ctyv7sxe2x2Mpbwf5k/biOvXr40F?=
 =?us-ascii?Q?DaDKioYJxjFozuoHjuxkazz1DeUcxqK7c5SRBagdH9cV2ud+cDARQ0isBWIZ?=
 =?us-ascii?Q?VmhQ4fAk8GtQznBnSaguVNNTHvCWMBfC/qmTiI1SP47OW9AtjTV5ELVoYxQY?=
 =?us-ascii?Q?SDLCMg3J/O6yRnKlG3sCGRRFvbne/1kl4CuYT26Oam+TYF2Msy4uAfl0IfbM?=
 =?us-ascii?Q?/qkZxm9xMuYJF1T98AOFGMnzRNwTUKuP2fSUqSL4TKJ9E2H6bCOe/r9pTyCZ?=
 =?us-ascii?Q?PiJqqIw7bMwbpPRz89OWxZdYzjzwuY4lgWdMy2XKirrP649pwRENxZTL7h8l?=
 =?us-ascii?Q?L6dGOJCEhcXezOe3UbMLxm+aqvZK6ba9qsU0HhAi9UNdor7j0BBdiaUVRCQ4?=
 =?us-ascii?Q?Y+xuMsL+77Zlrob5n9EIS+IA9O3tw72kFIyYOaKiyusbEK5zZT9ClGx9NLQB?=
 =?us-ascii?Q?MVyNLl1q1Lrfr5Po/UbbIAN2gMSMmWQkjuUZ+fT2XwY19QPAXsaw4DIlmZ1q?=
 =?us-ascii?Q?G7gQwuP/spuvdq2/GJdm5izp/TYHQwtSvTgdTr0dwwySvoVfboeYFjBU9NWT?=
 =?us-ascii?Q?BARLNSr9xIOOIBIEWS5b5kpPJd7og6+fYc3WlYjuhTtNbeWx1T4NUOVYgpkt?=
 =?us-ascii?Q?6DmcbjpTviosjuQGHOgOTtgD10utYM/pilEsMHIBSIj5aThyipYCjmmHKcu9?=
 =?us-ascii?Q?OrYLNfjEhC09lKW8Zstna3J2ZLhW4DXqQr+XerOCwiwMIZ+bH8m2vmB1ovIV?=
 =?us-ascii?Q?eiZQTw0zKYm6TA1qDeNJsIdMo2XMu3lZgGqovatRultR+aHI8mNCaVY5G+iL?=
 =?us-ascii?Q?O4flV6HcGDt/b877vB0G5mNEMBsYJL3wiQXuBNefQO5WijOf9W4n73o/45r0?=
 =?us-ascii?Q?vHSeSiP1IsCPClFSLDLqP939e1aUHPu2nNBpVvcM1IHYjejmuSglZrPhR9Es?=
 =?us-ascii?Q?8nVRZtYoZcVaGdYgF01z99bmm0wWSYdw1YMO1n4Po3UbN8wj9VVYH90Crs3R?=
 =?us-ascii?Q?i/mMEYWoFO0XSzpsjzCsECJTY7yoeEGOg07tjGTRC0eFwVkiHZKwEDoftR+P?=
 =?us-ascii?Q?qUeg/sLBDAoYfYLEmf2oqkUaLUGA4CMmFXNEVYKDMXLv5KOhlU0aAq8MJDfM?=
 =?us-ascii?Q?jiSyot1guwWp0VikpKRT6AZCiE0BfScjqqjhBkOIZABOEYKViPovA8K9X5/B?=
 =?us-ascii?Q?6bc13SPl2yYPUegBlst0cu1j6yk/j/8s/98Amfz7Hkd4qj26C4pIroyyB4/V?=
 =?us-ascii?Q?uiPzrkxGFfsfgkn6EKYJe7xOgTFjNqZ6cS6MsQ9yf5Bs+HbS2zZBU0Inx/z6?=
 =?us-ascii?Q?EdvmCERTt/PJSTt7PdVDocILvD5LcNKUy4SHI9Vy?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6343b95-bce2-4ebf-a5ab-08de0696ed38
X-MS-Exchange-CrossTenant-AuthSource: BN8PR12MB3604.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2025 18:17:23.0800
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rru+A0DbkV9bWdrjETdphM8uLBLRngOWHlojb8/xZCHiDbzS4ruAfV4BgUk1FUIG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4122

If pgshift is 63 then BITS_PER_TYPE(*bitmap->bitmap) * pgsize will overflow
to 0 and this triggers divide by 0.

In this case the index should just be 0, so reorganize things to divide
by shift and avoid hitting any overflows.

Cc: stable@vger.kernel.org
Fixes: 58ccf0190d19 ("vfio: Add an IOVA bitmap support")
Reported-by: syzbot+093a8a8b859472e6c257@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=093a8a8b859472e6c257
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommufd/iova_bitmap.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/iommufd/iova_bitmap.c b/drivers/iommu/iommufd/iova_bitmap.c
index 4514575818fc07..b5b67a9d3fb35e 100644
--- a/drivers/iommu/iommufd/iova_bitmap.c
+++ b/drivers/iommu/iommufd/iova_bitmap.c
@@ -130,9 +130,8 @@ struct iova_bitmap {
 static unsigned long iova_bitmap_offset_to_index(struct iova_bitmap *bitmap,
 						 unsigned long iova)
 {
-	unsigned long pgsize = 1UL << bitmap->mapped.pgshift;
-
-	return iova / (BITS_PER_TYPE(*bitmap->bitmap) * pgsize);
+	return (iova >> bitmap->mapped.pgshift) /
+	       BITS_PER_TYPE(*bitmap->bitmap);
 }
 
 /*

base-commit: 2a918911ed3d0841923525ed0fe707762ee78844
-- 
2.43.0

