Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2076.outbound.protection.outlook.com [40.107.223.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C544B134CFE;
	Tue, 23 Apr 2024 13:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713878081; cv=fail; b=Q3xgjqG5jCrz2PAksx8hqtuSOzcKKQlYPQtPO/T24/DItcfDMx64ze2cXvcNV2aFvlxge+DRrkNT6mIKwHyiD/2F7/3xXW2Y1Oqb0a9kScwZy9UpEzOgR9tXG8kgDh0/5X1JQkE2ZS2TSz4IrU2hejOJOWJdxqy9GyZ3l2YgQyo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713878081; c=relaxed/simple;
	bh=QVjpXtofCfJLyzb5uabaSG9nnCOag0Neo2OumvAPo3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=CJGAYrWLwZZxt38bladGTeZd6s5Cg5S9offNPSr/JEVBMraImHoOqnMfRX8tIX1TAGLDbmHrcIrg6VHhUgCu3hzaOXwv6arsyBFFUbsQFnH1oB0UZcCsrb5CGs95HoRATfNYKRHYTrwZnLIUmm/wHHB92wO1AkgLmZSTV9Mf9mk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BrsW68Sm; arc=fail smtp.client-ip=40.107.223.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BrsW68Sm"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i1JiRTMG9ULnw5Wysy8ZVB2UIhAmb7o+PF1EnGchhr0PMsFIoSyukaakCVB15w1agHv5ESu8YBnXYwmRFBE/TczLo5BuCEoyvaagkCiKf8nakFFS+EmIXww1LD5hYz9HSz0OS7NnbEKs4408yc4hRFYgYveguTNdvl6hpyCB4n/9k5rQ8m5FJqGUw5xOxwL0H7OKpJ7DSgRriEh1oi0tGral3e9nBoEbJb3/CgZGXEKG7a5LX3aYGCI+2JiC+Mhb56XEzaWkYZIxcDxL2d6e78DHVxWk771+AxNHZXpTZ5SUrD8eGxbcb3Z+77rZT7x9TWSYVr+RD8LczEgJBOFVIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C3Kjb38NvPbvaxls64HEvyCmbmfH7U0ExoyBwEba8nQ=;
 b=YuygVhXooJjluaMsaObp8b4syCdCult8nolm+USIVenwAfYe/ZWt75dqILrYdHiBeMq/elWgmvp0QbdLbDX3jqhuvgr7khtmZmK2YZKe3MeMV5kQiWU8rU0885xn98mTma7fG7z9KGpBKIcIezTUQ1GQnQEwxKCV7dtuOBsWWta/VVlmFiPTRArgmaTZrnlTYOxTblQT8OBWCjxa1JZmGQS4pgZoA0IMN8cvU7txTWbU/Y0lUmx1ESB7fhhTvd7NzAQuRKf9RTqKpcXdItuVW/f8gw/9P7cr7B/NcCVZh2aTFA4HZOZ73D26y0w7vSiGd4Aimwsx9iJV/SRrro3z3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C3Kjb38NvPbvaxls64HEvyCmbmfH7U0ExoyBwEba8nQ=;
 b=BrsW68SmKIMtz4lM8TATbHsF3XRDZgo4N0L8yTEo4Q21uHXisJM4Ogk7sqN+nuyexJcVYsjWWHzZIgBc1jAjLrI/hrowkRQosdkas4dPWiAMi+cXoDIE8e3OLZIz7g+c/5HTeblUkWxWrnrvLruwyPxa3RDgsq9eok1xPzAvEcFPBYvBWmW20ik8QV/X8bkeZ2ei1R8YKt1jAFoann+h24ZzGK4GELv54l6fmo839AphfpowP4vmzbBYGwuJMmMj1lVHM7i7RFYhWhDhag9bzG7rOH7Gfwn8yx4ArMc+Xz5NNCxffKa715wPUs4vumUCYNFAOkVBPzEL1cekpRB4hg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by SA1PR12MB5672.namprd12.prod.outlook.com (2603:10b6:806:23c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Tue, 23 Apr
 2024 13:14:23 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%3]) with mapi id 15.20.7519.021; Tue, 23 Apr 2024
 13:14:23 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
	Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v8 3/9] iommu/arm-smmu-v3: Move the CD generation for S1 domains into a function
Date: Tue, 23 Apr 2024 10:14:08 -0300
Message-ID: <3-v8-4c4298c63951+13484-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v8-4c4298c63951+13484-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0366.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::11) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|SA1PR12MB5672:EE_
X-MS-Office365-Filtering-Correlation-Id: 3306f4cf-7ef5-413a-9263-08dc639746c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0GPSG44pNRhgeWKmOmhul8H/+U1wAPpM8BcsDutDkNJ5D0F+QlSVEdf/cwIQ?=
 =?us-ascii?Q?nauNmeyVNJMECtHFkHpKGXyIFSCQYaaf1wzOLM1KuMt50fFcfYHISDimx9s5?=
 =?us-ascii?Q?9rLp6RAXo1k2XCHaoFv1YweAvFsaf/Gau04SsiYvx550EqJ4bE7Z6dMFTbD9?=
 =?us-ascii?Q?/kujp3QBq3v8bJ6TdClfg+K11N6B11YJ1zgRMJrUz0RouM8tarTzAnd8PMCy?=
 =?us-ascii?Q?8BkxMFsDJQS1OV/UMkeAEIjsgFPMofjxCGhnDVynERa1H3fAj3yvmg7YtI5R?=
 =?us-ascii?Q?ZHtTJU5Hg9/FChIw7FEtT1jXYz6U549SOyniZJrfEDx9NzKefYTlpZub/JoJ?=
 =?us-ascii?Q?P2KiRXYSysY6Szgm27jDG78XGSvaN9cmYnemCzI4mp0D/JuvbTvhHxOwQr+8?=
 =?us-ascii?Q?hXl4cttyR4aYkWdT0slYVw0hrlnl2IWzSrGrlq4+Y+mrvsiMFj5sp/x+sZ2i?=
 =?us-ascii?Q?pwRDg1O04W4ky5iSxj/L55v41viZmwTmU21Zn9JpzzKlcc08YxNlAL4ah3pK?=
 =?us-ascii?Q?GnyMN4BRyij/0/m3U0kNCl4Fl5Y0aSw2rJrAINyvWRj+PhWywT3Buz60hpmw?=
 =?us-ascii?Q?F5/LYKWNCeDkXOjs3i3R++lPF6hPVp9rL/9uJpIkVQXXIPpO+Pjn65luZxOn?=
 =?us-ascii?Q?KIGn+k4ydNzYfQ6+wEDtQK1/R63BiHFsQmhw8JkzlcSB2Icdk7JPYB/4fa17?=
 =?us-ascii?Q?5Hm69ZodLUSDHqCNj85HtbyjjQ0ZuWsHdEYHz0lh3yMaG4Rw1ykRsq5IblGX?=
 =?us-ascii?Q?CApbCa9TUfXQBQMO4VEAwXR4JEHG6CYSl1OC6qylVxiNGM4ER1jno5e8CHHd?=
 =?us-ascii?Q?I2PXNua4XYVbkU9eC+nJXMpZ7ZVzR33EnTLs+SNvKONLJ3MppJsRdsJn+yD4?=
 =?us-ascii?Q?79mxGQWArl4kwiZdFU95oaaHL/BCyWd2jodfAB5xlDJCbz/vUOYZsuQDtMa6?=
 =?us-ascii?Q?YfdoScrGMtSm3s9fLfiBJLwfNP9M8AqlUCtkps9/ChoSnQa0GPS1xadHaSVx?=
 =?us-ascii?Q?gjzpGNyuObLchw5Hb1r5nUvC5t0+VVrIXhhp0fjkYjyUMGk/XF0taQz6mKVb?=
 =?us-ascii?Q?ECmDLzVoyW4sZFu6M42L7JQUvHP02DA/Tg1jPffvPkIPAMVG/FqU/U1rMc0S?=
 =?us-ascii?Q?kn5gmYTZ2VGo7SWjuZr9v3tyrz0AV3HciqTHnBrRkULPBRCL7X4ORySeHbNc?=
 =?us-ascii?Q?qm8BtELYXG9OBNKdAnljN5pnjQnfX1ASj0XgvJxfSWtYHy5C17Z+xi71Yf+/?=
 =?us-ascii?Q?OnDxqYhI5iHYGIvF3u3xivnG7uVZTBiISIjPbIPDOw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?J5KmM4bT4G6Hj6mMkLq58rJ275YaITkzo0pOMAbH6XJMCJmM0XO4Q3RTGuYj?=
 =?us-ascii?Q?3kFcgN2v2mFj6Mp/3yBpgprSp3jX+3+Sxfj7n1bn622tDhftN0RxzdMiy7Vv?=
 =?us-ascii?Q?1opvg4jpafpfRuiUMeOYlvJvRnYE3YyQa94l007D94GDgIWnuEm7LRHUEQPP?=
 =?us-ascii?Q?9yUZMD9vsorqXpDWlkDTabTfmjQv89Pj+o2/gb9rz+4+quWwwppNWeL170FH?=
 =?us-ascii?Q?frl33KextIUgwOPVAKhmglO/QYajzY5DgVK7X/FYUENds/EEZ9KbUIiCu2D5?=
 =?us-ascii?Q?ytC+J0mG1hLF/07A2h/bHSOqGxoXXv35R/KBtBB1v2Rt3SqIdvw4admzNK7U?=
 =?us-ascii?Q?uIWScfHQ7Xy0dURh9qvOYWkYcDYkd4UTEmmmQ+NFzVlTGJ9k298JC2mvkGSZ?=
 =?us-ascii?Q?srFEazQG8GYGhikts+Nm2zS/yy29R8ttCpv7UwFXb3UAx65/xCc9ZmkTALm0?=
 =?us-ascii?Q?O/VMSo9DZvZnPdYq23qsunDPRm35kxoCuWV8VQk+eNcjaUarWILM/ldprgyE?=
 =?us-ascii?Q?yXFw9k/Zxeb8dtsjcWU3FR8dF7m2ta9PnYV79N6Ci4Zq5lsdjTaB/eibHYSG?=
 =?us-ascii?Q?OSmi/38zjd5tveoDagOTQI81Ym+5a7woViMMoWAXM400LVfcDsuHf5uwGtkc?=
 =?us-ascii?Q?Ap5tTjm/wB+CMj14yzhp0kXgIQnTRmFkF4Va31wwXlJlGF4HAa1GF/hnCC0g?=
 =?us-ascii?Q?zzc7A0DdFdVWQW8JKm0w/nOucJY4uMpc4UO7Jkwn7/jkIteuhYUus/rSvkvi?=
 =?us-ascii?Q?mkLUhg4YV3I0wJAPOSS551x2QaZTH1evLi2SzXH+u9OwGJas+XKXlc416jZx?=
 =?us-ascii?Q?HwlV5qhtPRHqd+7J8d8SLYVlWEdm0x5GAbiIblAbvdI67BsfiQY493DAyZPs?=
 =?us-ascii?Q?z9RczF0Y+2N9brGL2or29n0AL+4+O0vIIcz3mm0Bwta4kMuWf+XPAqAUevca?=
 =?us-ascii?Q?rNxvAZ0V1FqYX75/quJjDPOmzDPUyRy5c42goS1mSKUJJHON6yNgn0g8wRQU?=
 =?us-ascii?Q?iljlcqZBPCupXHTy/fGCzwfhbCuXvu/iEdtdfB+Mk0ThcAgLXLKq+sQOff51?=
 =?us-ascii?Q?/8plp5aam9k7lqWds5ZoZJyXsEiH6WvGyoZ0Wl41QYSSZoA2I0d0+0puh+2a?=
 =?us-ascii?Q?4DRQEkSPockYBTI7fJabFGwgh0Ogw0NPAA638DOpq1483Flbn1mGPs9m4yaI?=
 =?us-ascii?Q?T2eY9Wsc4h3kOE6pTe+64hxriojkjmqpfYufjP+A5nloGP11QcfZaxbByduC?=
 =?us-ascii?Q?I6HyA/yxviEfT74gYWKMd3YygCqf7STUYUWInOfOobwWtQ+3x//vUqAmUsSE?=
 =?us-ascii?Q?C+hTpurZCAX6wcJBtxYkmQxpKkVV8T1EXitKIE99H29BZepMD+fUydnTJbr1?=
 =?us-ascii?Q?7U3BIzGby6gaDpI3v4mJmUfsF5lwJZnEMeuGYLG538eGr0eYgFd6vvMIZhtf?=
 =?us-ascii?Q?/RnF4Um7mtULCRGu9yqg0Ncua2Q11l0okGqIpxpAmABVWJqbNFeihrdensC3?=
 =?us-ascii?Q?+ooseOJ9odtToY4D2mnO6XeBqvN8wCqJ58OTfqg0rblXBBw3K5NkPx3/VK5a?=
 =?us-ascii?Q?+ME+QARe8CKp5D2rv7yGj6IOWsQ9ZXcJ2PLXpr7n?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3306f4cf-7ef5-413a-9263-08dc639746c3
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2024 13:14:16.0255
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mydxMhd7qxdd0M82R1UKTTO61iTVIYuNf90yYS+368Xd3qHxOMfj5FEx0WVrqw3d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5672

Introduce arm_smmu_make_s1_cd() to build the CD from the paging S1 domain,
and reorganize all the places programming S1 domain CD table entries to
call it.

Split arm_smmu_update_s1_domain_cd_entry() from
arm_smmu_update_ctx_desc_devices() so that the S1 path has its own call
chain separate from the unrelated SVA path.

arm_smmu_update_s1_domain_cd_entry() only works on S1 domains attached to
RIDs and refreshes all their CDs. Remove case (3) from
arm_smmu_write_ctx_desc() as it is now handled by directly calling
arm_smmu_write_cd_entry().

Remove the forced clear of the CD during S1 domain attach,
arm_smmu_write_cd_entry() will do this automatically if necessary.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Reviewed-by: Michael Shavit <mshavit@google.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 25 ++++++-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 71 +++++++++++--------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  9 +++
 3 files changed, 76 insertions(+), 29 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 41b44baef15e80..d159f60480935e 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -53,6 +53,29 @@ static void arm_smmu_update_ctx_desc_devices(struct arm_smmu_domain *smmu_domain
 	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
 }
 
+static void
+arm_smmu_update_s1_domain_cd_entry(struct arm_smmu_domain *smmu_domain)
+{
+	struct arm_smmu_master *master;
+	struct arm_smmu_cd target_cd;
+	unsigned long flags;
+
+	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
+	list_for_each_entry(master, &smmu_domain->devices, domain_head) {
+		struct arm_smmu_cd *cdptr;
+
+		/* S1 domains only support RID attachment right now */
+		cdptr = arm_smmu_get_cd_ptr(master, IOMMU_NO_PASID);
+		if (WARN_ON(!cdptr))
+			continue;
+
+		arm_smmu_make_s1_cd(&target_cd, master, smmu_domain);
+		arm_smmu_write_cd_entry(master, IOMMU_NO_PASID, cdptr,
+					&target_cd);
+	}
+	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
+}
+
 /*
  * Check if the CPU ASID is available on the SMMU side. If a private context
  * descriptor is using it, try to replace it.
@@ -96,7 +119,7 @@ arm_smmu_share_asid(struct mm_struct *mm, u16 asid)
 	 * be some overlap between use of both ASIDs, until we invalidate the
 	 * TLB.
 	 */
-	arm_smmu_update_ctx_desc_devices(smmu_domain, IOMMU_NO_PASID, cd);
+	arm_smmu_update_s1_domain_cd_entry(smmu_domain);
 
 	/* Invalidate TLB entries previously associated with that context */
 	arm_smmu_tlb_inv_asid(smmu, asid);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 1a61b47eeefe2d..0f4d275fff67b0 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1203,8 +1203,8 @@ static void arm_smmu_write_cd_l1_desc(__le64 *dst,
 	WRITE_ONCE(*dst, cpu_to_le64(val));
 }
 
-static struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
-					       u32 ssid)
+struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
+					u32 ssid)
 {
 	__le64 *l1ptr;
 	unsigned int idx;
@@ -1269,9 +1269,9 @@ static const struct arm_smmu_entry_writer_ops arm_smmu_cd_writer_ops = {
 	.get_used = arm_smmu_get_cd_used,
 };
 
-static void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
-				    struct arm_smmu_cd *cdptr,
-				    const struct arm_smmu_cd *target)
+void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
+			     struct arm_smmu_cd *cdptr,
+			     const struct arm_smmu_cd *target)
 {
 	struct arm_smmu_cd_writer cd_writer = {
 		.writer = {
@@ -1284,6 +1284,32 @@ static void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
 	arm_smmu_write_entry(&cd_writer.writer, cdptr->data, target->data);
 }
 
+void arm_smmu_make_s1_cd(struct arm_smmu_cd *target,
+			 struct arm_smmu_master *master,
+			 struct arm_smmu_domain *smmu_domain)
+{
+	struct arm_smmu_ctx_desc *cd = &smmu_domain->cd;
+
+	memset(target, 0, sizeof(*target));
+
+	target->data[0] = cpu_to_le64(
+		cd->tcr |
+#ifdef __BIG_ENDIAN
+		CTXDESC_CD_0_ENDI |
+#endif
+		CTXDESC_CD_0_V |
+		CTXDESC_CD_0_AA64 |
+		(master->stall_enabled ? CTXDESC_CD_0_S : 0) |
+		CTXDESC_CD_0_R |
+		CTXDESC_CD_0_A |
+		CTXDESC_CD_0_ASET |
+		FIELD_PREP(CTXDESC_CD_0_ASID, cd->asid)
+		);
+
+	target->data[1] = cpu_to_le64(cd->ttbr & CTXDESC_CD_1_TTB0_MASK);
+	target->data[3] = cpu_to_le64(cd->mair);
+}
+
 static void arm_smmu_clean_cd_entry(struct arm_smmu_cd *target)
 {
 	struct arm_smmu_cd used = {};
@@ -1302,14 +1328,11 @@ int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
 	 *
 	 * (1) Install primary CD, for normal DMA traffic (SSID = IOMMU_NO_PASID = 0).
 	 * (2) Install a secondary CD, for SID+SSID traffic.
-	 * (3) Update ASID of a CD. Atomically write the first 64 bits of the
-	 *     CD, then invalidate the old entry and mappings.
 	 * (4) Quiesce the context without clearing the valid bit. Disable
 	 *     translation, and ignore any translation fault.
 	 * (5) Remove a secondary CD.
 	 */
 	u64 val;
-	bool cd_live;
 	struct arm_smmu_cd target;
 	struct arm_smmu_cd *cdptr = &target;
 	struct arm_smmu_cd *cd_table_entry;
@@ -1325,7 +1348,6 @@ int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
 
 	target = *cd_table_entry;
 	val = le64_to_cpu(cdptr->data[0]);
-	cd_live = !!(val & CTXDESC_CD_0_V);
 
 	if (!cd) { /* (5) */
 		val = 0;
@@ -1333,13 +1355,6 @@ int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
 		if (!(smmu->features & ARM_SMMU_FEAT_STALL_FORCE))
 			val &= ~(CTXDESC_CD_0_S | CTXDESC_CD_0_R);
 		val |= CTXDESC_CD_0_TCR_EPD0;
-	} else if (cd_live) { /* (3) */
-		val &= ~CTXDESC_CD_0_ASID;
-		val |= FIELD_PREP(CTXDESC_CD_0_ASID, cd->asid);
-		/*
-		 * Until CD+TLB invalidation, both ASIDs may be used for tagging
-		 * this substream's traffic
-		 */
 	} else { /* (1) and (2) */
 		cdptr->data[1] = cpu_to_le64(cd->ttbr & CTXDESC_CD_1_TTB0_MASK);
 		cdptr->data[2] = 0;
@@ -2644,29 +2659,29 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
 
 	switch (smmu_domain->stage) {
-	case ARM_SMMU_DOMAIN_S1:
+	case ARM_SMMU_DOMAIN_S1: {
+		struct arm_smmu_cd target_cd;
+		struct arm_smmu_cd *cdptr;
+
 		if (!master->cd_table.cdtab) {
 			ret = arm_smmu_alloc_cd_tables(master);
 			if (ret)
 				goto out_list_del;
-		} else {
-			/*
-			 * arm_smmu_write_ctx_desc() relies on the entry being
-			 * invalid to work, clear any existing entry.
-			 */
-			ret = arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID,
-						      NULL);
-			if (ret)
-				goto out_list_del;
 		}
 
-		ret = arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID, &smmu_domain->cd);
-		if (ret)
+		cdptr = arm_smmu_get_cd_ptr(master, IOMMU_NO_PASID);
+		if (!cdptr) {
+			ret = -ENOMEM;
 			goto out_list_del;
+		}
 
+		arm_smmu_make_s1_cd(&target_cd, master, smmu_domain);
+		arm_smmu_write_cd_entry(master, IOMMU_NO_PASID, cdptr,
+					&target_cd);
 		arm_smmu_make_cdtable_ste(&target, master);
 		arm_smmu_install_ste_for_dev(master, &target);
 		break;
+	}
 	case ARM_SMMU_DOMAIN_S2:
 		arm_smmu_make_s2_domain_ste(&target, master, smmu_domain);
 		arm_smmu_install_ste_for_dev(master, &target);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 4b767e0eeeb682..bb08f087ba39e4 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -751,6 +751,15 @@ extern struct xarray arm_smmu_asid_xa;
 extern struct mutex arm_smmu_asid_lock;
 extern struct arm_smmu_ctx_desc quiet_cd;
 
+struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
+					u32 ssid);
+void arm_smmu_make_s1_cd(struct arm_smmu_cd *target,
+			 struct arm_smmu_master *master,
+			 struct arm_smmu_domain *smmu_domain);
+void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
+			     struct arm_smmu_cd *cdptr,
+			     const struct arm_smmu_cd *target);
+
 int arm_smmu_write_ctx_desc(struct arm_smmu_master *smmu_master, int ssid,
 			    struct arm_smmu_ctx_desc *cd);
 void arm_smmu_tlb_inv_asid(struct arm_smmu_device *smmu, u16 asid);
-- 
2.43.2

