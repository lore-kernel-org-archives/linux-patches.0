Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2080.outbound.protection.outlook.com [40.107.223.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E848167E93;
	Wed,  6 Dec 2023 17:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ElQuqOjj"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nVo+8foc5j+GTUetqKclUDV/L1lmlLnYxr789bEwEAY378dkWWoRMHWyrezjJEUpTRRe6QUZY0OjlcYx7IIiHaAlZ6kO0W/x1U28sGbzbHwJ1mi3lqqd5/cw4wz38IsF99dMYvKsDcRATOWFYjMbidAiFhiYtnf5XuecVBnRhumL+c1pJz60UXFQJ0kZM+VT8vgEcfUgMGkSvQgT6JPeemJplls7pBV+llL71mlB96rNbcFK6kNZEdd8mRcmNbHD3PXtA83FmjE9l4NCbL5hYppI5zmXXc6+D14EHGNA6Jcr7egh5tsOe3sapMZ9RaaiuXAjq1yUzRjMOi2t3olz2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EFCRnO21BqzYV20TDmy5w+rK5Gewr81V6zaew1sl+S8=;
 b=KejOpt6fwnWRnAYEgje3XRWGUXrlNIsGGNpwM4GnZhXJAFVD8lBkYVKaNyOYgJOw9bvaGreqZ+NEL9r7medtH9MrH3KimXVICMiMd+C5/lxUxweETCbU5g61/A2TCU8mTCY/puuVX90VjbplYOY5XhsrhU9OwTkXviTgQk0kMB9jGomBjxPEeTND9nwve85/DKCsSDcgAveFBRqps4Culm26XrEm5nBZPCMa+EoaNOhoCwzb1s9reU69TcNgV2LulIt0We7ImAXC8cYJ0x6dMp8TH1BNX4ucC7bxfFUv5NUvEAif/36TZ5mw27p2NQcr9F5wuk1q/kE2kkFnmbShPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EFCRnO21BqzYV20TDmy5w+rK5Gewr81V6zaew1sl+S8=;
 b=ElQuqOjjj8V9sXwtlWJlM4Hy/JW36CqdxsjFxP0c73RacyaVxEy7FEAKflm8yN7L2DXfKFj/MoJ2zTIetRdfejLkFbVUoeHck4g7IBQU5wF55xQ95+nBHlYWv7ZPtcPp4g1myrW6+QQGZgzumOE6XO4+c5HuZCRlIn93wESHIYmPMvZvFihIaoB/ZfZcuk2MuWDohjRlz0tivrOmTsTiNoxmkGkoZSQZneRW7oIjfHLy+ow4C+yHHjWbfadh56CMyOF+I8AXixJc5pxOv59WpgHZTZoWUqFLxEHrWHSmand4vrcfd7/azZSJIbQqkUKcgnE1lt0OY4nX+YcyIP94jQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CY8PR12MB7364.namprd12.prod.outlook.com (2603:10b6:930:50::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.25; Wed, 6 Dec
 2023 17:28:37 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.034; Wed, 6 Dec 2023
 17:28:37 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH v3 10/27] iommu/arm-smmu-v3: Move the CD generation for SVA into a function
Date: Wed,  6 Dec 2023 13:28:16 -0400
Message-ID: <10-v3-9083a9368a5c+23fb-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v3-9083a9368a5c+23fb-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR0102CA0059.prod.exchangelabs.com
 (2603:10b6:208:25::36) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CY8PR12MB7364:EE_
X-MS-Office365-Filtering-Correlation-Id: 86050df3-9827-4a3e-98c9-08dbf680c5fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	a4imQmv3CiLR8Tz9TpT7aI16qZtUfuv0v8VjRgz8ImEf0WFRdom6P/EQXSqiPNCSNJKKfhNgHuY4I5ZXogjhDLL9hkpE4hZvax0wlLKDBeSpwb+wfQHJAgpusREZ9TcjnhM28y/0wTvRFw6z2oiXakQPDvSwFid+Kr9yPlQ5lY65eZ6cU2xQU+k8FI9UvgHMyuCyaLaWEXh15OXk4NrZkatPYhBDUqUS/MgY3AaLYFZwnj1yK+MGHyakqo0xJyFOwudSveRo0iKiEympXeRjkGKFPCeft7U1S9M/GeNYKTme+7KG6GK/KEIBZ2RKv6t/Mg9C2VsDERR0ynXD7WK/gQrKl56WFKL5QkUAUMpwu+OH8OqLdf8oQJNtC6JblpgI3/sxG9Z/IpJAfajpBLG5oatH5gUy3yFYnKTJ+MKw4hkHEJ79dDDWM6WeDTBi8jJKIL+kK45sNKhrohYbUQeGddbL0MBIhawtwoBRj1zed1HlLkHLeR17Nng8Z56e8gm40OSuvP1kTRLsPJUK7rpo7lAGZSn5LvX+nWdEK39iVKmYis48tGE//CuENOeQsBtKeA1qpxQIbxbnsTuZVoaEmS9WGiEMJ0uugrqGdVwYEBu881qmUTEK3yildZuIerY8aon0zj+QkGze/HD4Y6yKuA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(346002)(396003)(39860400002)(376002)(136003)(230922051799003)(64100799003)(1800799012)(451199024)(186009)(8936002)(8676002)(4326008)(2906002)(38100700002)(83380400001)(7416002)(41300700001)(36756003)(86362001)(30864003)(5660300002)(6666004)(26005)(6512007)(66556008)(6486002)(478600001)(2616005)(66946007)(110136005)(54906003)(66476007)(6506007)(316002)(473944003)(414714003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PWdfn0/fmU6p9Jy9LVSW/YIeGli950ZCUdUV2p+TZI9EvfQ4X0fB4xTYg406?=
 =?us-ascii?Q?dcJoFKLOkW4sE5kcGUcveftNhQxhgnJYex9YeyTdbGf6OzrV+zza/NOH2g7X?=
 =?us-ascii?Q?r3wgdAtfsMSV2JX1c9g2TJTjSurN0KFZe9c4wlIjwewMu/g1u1YjIZc83Pj1?=
 =?us-ascii?Q?GoP5KhHy78Q//PQOwce928/kpXbQinylv18VAJ3Q/vo4zVvhSxG0JT+a73uj?=
 =?us-ascii?Q?m1W6bQOoD0Q5i8gkbmx0ZScslO4UOWlRNjZtf1WJx8UqiPGy3M8uPSu/0HB9?=
 =?us-ascii?Q?TrCM8wDtItPBxcDRMTfkzNxsWNYe1XZflhGtlPdkSJvtteG20NvUt4/BzMPq?=
 =?us-ascii?Q?PYlgPBb44KxdU6MqczVfZ6bxC/msQXdO2/jxjhtAgab51LbS7RHztlJ2bSvS?=
 =?us-ascii?Q?oYHPaGKGYGo4NZMwv7r4ajtTiQzR/n/NL8ng/2pgK2bk2+m+JK44LxNKSuhA?=
 =?us-ascii?Q?0GyKDPyVqoCl9Qg+M6ZDgtExb4HWNB71ueImah0Xc6lLNFh6r9ja+JzElt/J?=
 =?us-ascii?Q?d2ygVaYasJO0A1G0dsb6nrgxzYzpfvFbuGLUpuIAyYFaALYWXJQcBO644Qsn?=
 =?us-ascii?Q?K2xu4SdW0iC9mLtKwFmmtRPikH2XskulyRFpqRlTaGYlKOecckU7hYsABV5Y?=
 =?us-ascii?Q?PNUesPoenbtHCTuPrlWKaJyiMJlTybggYZE/CMRTBbefF85UWzIYvkrpihFH?=
 =?us-ascii?Q?vUVx5fAlKscFv0ZYlQgmx5v/99q1UPnXI8lK+LzvkrkES6X/fy86XyDHC2Jx?=
 =?us-ascii?Q?8LhWu/go3LLh2Nam8uvqMzZb17uNi2A14gk8J3YiQ5P4Bt3eqXkH1ySYCHxP?=
 =?us-ascii?Q?ZrB1J8SNOg/AQrMyH1q1fMsoTPeuMDAXgeSMreIq+JZNIT+swGQqOUlmqFDr?=
 =?us-ascii?Q?bXdMhpxdJcVvmXk3gBN/TxzLPYTJmmpTfLYo3y3XJVYxqMvV2mwnJOu4v4LR?=
 =?us-ascii?Q?NdRlkVeMWfBveKR/ykUk4azDG8veXjQR4YxMhO1mGUL1Fpmn57d8ZBbRMybw?=
 =?us-ascii?Q?zKe17zof1yuWtWpWgCD55aODXS0kJf1H5TdfYWsKqZkUnWSpEvZjiC/g36OG?=
 =?us-ascii?Q?pmyYZoaUmNHtUZNhcAKAy1V/C/xdseaxvB71qrN5I3M2S6fsZMjiwQjuWBZu?=
 =?us-ascii?Q?puqsH01EvjrITWHFO8XGt2vrqOmuM3SK6s42Cpz8lvc/kc8lsRoQEnIjG4T6?=
 =?us-ascii?Q?lvYMGgEc/jxxHfaCnjZr0t3TTUI0bTq9LW3SvEmE4TY3QxKAAd+a6Xq3yHFQ?=
 =?us-ascii?Q?ymhRP2FLwHCDed42Q7N56dQ3ZrP84p+qRJRstGNyVdceunU3UsTgT5SHsgSR?=
 =?us-ascii?Q?A3vypUHwbK0hy+HErUXn7LgOvGLdoMR8DrRG4K7qY8DO9i7AqGihs8Ed0OTJ?=
 =?us-ascii?Q?AgDpRWy8DysHSNFCBBITiMzaVo+uBy+eSFVxpUO4G2Ffiep+kAfZ9i1V37QV?=
 =?us-ascii?Q?ZqK+mSGV2vc+3VAQwQIsh379tKFKX6NyW6dZFw6cHf3gl3drBcpBTh6hMbST?=
 =?us-ascii?Q?8PcdLpI42D4Zh+cQ7wwa2s/5A6zTnS5GKhgT69iEiUS4izqxIFcxSQtDu4oW?=
 =?us-ascii?Q?nNfiNGf4h2sohD3IbcKnxR2rq8RBnxVXwlAYOY1y?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86050df3-9827-4a3e-98c9-08dbf680c5fc
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2023 17:28:34.2500
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9CTgAROdMx/WjLciow7oO42e9d+FRptXji5vKllbt/FsGueqmUuayUbTHV5nLanT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7364

Pull all the calculations for building the CD table entry for a mmu_struct
into arm_smmu_make_sva_cd().

Call it in the two places installing the SVA CD table entry.

Open code the last caller of arm_smmu_update_ctx_desc_devices() and remove
the function.

Remove arm_smmu_write_ctx_desc() since all callers are gone.

Remove quiet_cd since all users are gone, arm_smmu_make_sva_cd() creates
the same value.

The behavior of quiet_cd changes slightly, the old implementation edited
the CD in place to set CTXDESC_CD_0_TCR_EPD0 assuming it was a SVA CD
entry. This version generates a full CD entry with a 0 TTB0 and relies on
arm_smmu_write_cd_entry() to install it hitlessly.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 145 +++++++++++-------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  81 +---------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |   5 -
 3 files changed, 95 insertions(+), 136 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 04a807774402b2..1f0940b497f3c6 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -35,25 +35,6 @@ struct arm_smmu_bond {
 
 static DEFINE_MUTEX(sva_lock);
 
-/*
- * Write the CD to the CD tables for all masters that this domain is attached
- * to. Note that this is only used to update existing CD entries in the target
- * CD table, for which it's assumed that arm_smmu_write_ctx_desc can't fail.
- */
-static void arm_smmu_update_ctx_desc_devices(struct arm_smmu_domain *smmu_domain,
-					   int ssid,
-					   struct arm_smmu_ctx_desc *cd)
-{
-	struct arm_smmu_master *master;
-	unsigned long flags;
-
-	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
-	list_for_each_entry(master, &smmu_domain->devices, domain_head) {
-		arm_smmu_write_ctx_desc(master, ssid, cd);
-	}
-	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
-}
-
 static void
 arm_smmu_update_s1_domain_cd_entry(struct arm_smmu_domain *smmu_domain)
 {
@@ -129,11 +110,76 @@ arm_smmu_share_asid(struct mm_struct *mm, u16 asid)
 	return NULL;
 }
 
+static u64 page_size_to_cd(void)
+{
+	static_assert(PAGE_SIZE == SZ_4K || PAGE_SIZE == SZ_16K ||
+		      PAGE_SIZE == SZ_64K);
+	if (PAGE_SIZE == SZ_64K)
+		return ARM_LPAE_TCR_TG0_64K;
+	if (PAGE_SIZE == SZ_16K)
+		return ARM_LPAE_TCR_TG0_16K;
+	return ARM_LPAE_TCR_TG0_4K;
+}
+
+static void arm_smmu_make_sva_cd(struct arm_smmu_cd *target,
+				 struct arm_smmu_master *master,
+				 struct mm_struct *mm, u16 asid)
+{
+	u64 par;
+
+	memset(target, 0, sizeof(*target));
+
+	par = cpuid_feature_extract_unsigned_field(
+		read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1),
+		ID_AA64MMFR0_EL1_PARANGE_SHIFT);
+
+	target->data[0] = cpu_to_le64(
+		CTXDESC_CD_0_TCR_EPD1 |
+#ifdef __BIG_ENDIAN
+		CTXDESC_CD_0_ENDI |
+#endif
+		CTXDESC_CD_0_V |
+		FIELD_PREP(CTXDESC_CD_0_TCR_IPS, par) |
+		CTXDESC_CD_0_AA64 |
+		(master->stall_enabled ? CTXDESC_CD_0_S : 0) |
+		CTXDESC_CD_0_R |
+		CTXDESC_CD_0_A |
+		CTXDESC_CD_0_ASET |
+		FIELD_PREP(CTXDESC_CD_0_ASID, asid));
+
+	/*
+	 * If no MM is passed then this creates a SVA entry that faults
+	 * everything. arm_smmu_write_cd_entry() can hitlessly go between these
+	 * two entries types since TTB0 is ignored by HW when EPD0 is set.
+	 */
+	if (mm) {
+		target->data[0] |= cpu_to_le64(
+			FIELD_PREP(CTXDESC_CD_0_TCR_T0SZ,
+				   64ULL - vabits_actual) |
+			FIELD_PREP(CTXDESC_CD_0_TCR_TG0, page_size_to_cd()) |
+			FIELD_PREP(CTXDESC_CD_0_TCR_IRGN0,
+				   ARM_LPAE_TCR_RGN_WBWA) |
+			FIELD_PREP(CTXDESC_CD_0_TCR_ORGN0,
+				   ARM_LPAE_TCR_RGN_WBWA) |
+			FIELD_PREP(CTXDESC_CD_0_TCR_SH0, ARM_LPAE_TCR_SH_IS));
+
+		target->data[1] = cpu_to_le64(virt_to_phys(mm->pgd) &
+					      CTXDESC_CD_1_TTB0_MASK);
+	} else {
+		target->data[0] |= cpu_to_le64(CTXDESC_CD_0_TCR_EPD0);
+	}
+
+	/*
+	 * MAIR value is pretty much constant and global, so we can just get it
+	 * from the current CPU register
+	 */
+	target->data[3] = cpu_to_le64(read_sysreg(mair_el1));
+}
+
 static struct arm_smmu_ctx_desc *arm_smmu_alloc_shared_cd(struct mm_struct *mm)
 {
 	u16 asid;
 	int err = 0;
-	u64 tcr, par, reg;
 	struct arm_smmu_ctx_desc *cd;
 	struct arm_smmu_ctx_desc *ret = NULL;
 
@@ -167,39 +213,6 @@ static struct arm_smmu_ctx_desc *arm_smmu_alloc_shared_cd(struct mm_struct *mm)
 	if (err)
 		goto out_free_asid;
 
-	tcr = FIELD_PREP(CTXDESC_CD_0_TCR_T0SZ, 64ULL - vabits_actual) |
-	      FIELD_PREP(CTXDESC_CD_0_TCR_IRGN0, ARM_LPAE_TCR_RGN_WBWA) |
-	      FIELD_PREP(CTXDESC_CD_0_TCR_ORGN0, ARM_LPAE_TCR_RGN_WBWA) |
-	      FIELD_PREP(CTXDESC_CD_0_TCR_SH0, ARM_LPAE_TCR_SH_IS) |
-	      CTXDESC_CD_0_TCR_EPD1 | CTXDESC_CD_0_AA64;
-
-	switch (PAGE_SIZE) {
-	case SZ_4K:
-		tcr |= FIELD_PREP(CTXDESC_CD_0_TCR_TG0, ARM_LPAE_TCR_TG0_4K);
-		break;
-	case SZ_16K:
-		tcr |= FIELD_PREP(CTXDESC_CD_0_TCR_TG0, ARM_LPAE_TCR_TG0_16K);
-		break;
-	case SZ_64K:
-		tcr |= FIELD_PREP(CTXDESC_CD_0_TCR_TG0, ARM_LPAE_TCR_TG0_64K);
-		break;
-	default:
-		WARN_ON(1);
-		err = -EINVAL;
-		goto out_free_asid;
-	}
-
-	reg = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1);
-	par = cpuid_feature_extract_unsigned_field(reg, ID_AA64MMFR0_EL1_PARANGE_SHIFT);
-	tcr |= FIELD_PREP(CTXDESC_CD_0_TCR_IPS, par);
-
-	cd->ttbr = virt_to_phys(mm->pgd);
-	cd->tcr = tcr;
-	/*
-	 * MAIR value is pretty much constant and global, so we can just get it
-	 * from the current CPU register
-	 */
-	cd->mair = read_sysreg(mair_el1);
 	cd->asid = asid;
 	cd->mm = mm;
 
@@ -276,6 +289,8 @@ static void arm_smmu_mm_release(struct mmu_notifier *mn, struct mm_struct *mm)
 {
 	struct arm_smmu_mmu_notifier *smmu_mn = mn_to_smmu(mn);
 	struct arm_smmu_domain *smmu_domain = smmu_mn->domain;
+	struct arm_smmu_master *master;
+	unsigned long flags;
 
 	mutex_lock(&sva_lock);
 	if (smmu_mn->cleared) {
@@ -287,7 +302,18 @@ static void arm_smmu_mm_release(struct mmu_notifier *mn, struct mm_struct *mm)
 	 * DMA may still be running. Keep the cd valid to avoid C_BAD_CD events,
 	 * but disable translation.
 	 */
-	arm_smmu_update_ctx_desc_devices(smmu_domain, mm->pasid, &quiet_cd);
+	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
+	list_for_each_entry(master, &smmu_domain->devices, domain_head) {
+		struct arm_smmu_cd target;
+		struct arm_smmu_cd *cdptr;
+
+		cdptr = arm_smmu_get_cd_ptr(master, mm->pasid);
+		if (WARN_ON(!cdptr))
+			continue;
+		arm_smmu_make_sva_cd(&target, master, NULL, smmu_mn->cd->asid);
+		arm_smmu_write_cd_entry(master, mm->pasid, cdptr, &target);
+	}
+	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
 
 	arm_smmu_tlb_inv_asid(smmu_domain->smmu, smmu_mn->cd->asid);
 	arm_smmu_atc_inv_domain(smmu_domain, mm->pasid, 0, 0);
@@ -348,12 +374,19 @@ arm_smmu_mmu_notifier_get(struct arm_smmu_domain *smmu_domain,
 
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
 	list_for_each_entry(master, &smmu_domain->devices, domain_head) {
-		ret = arm_smmu_write_ctx_desc(master, mm->pasid, cd);
-		if (ret) {
+		struct arm_smmu_cd target;
+		struct arm_smmu_cd *cdptr;
+
+		cdptr = arm_smmu_get_cd_ptr(master, mm->pasid);
+		if (!cdptr) {
+			ret = -ENOMEM;
 			list_for_each_entry_from_reverse(master, &smmu_domain->devices, domain_head)
 				arm_smmu_clear_cd(master, mm->pasid);
 			break;
 		}
+
+		arm_smmu_make_sva_cd(&target, master, mm, cd->asid);
+		arm_smmu_write_cd_entry(master, mm->pasid, cdptr, &target);
 	}
 	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
 	if (ret)
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index eea561edaee908..824e725f905d71 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -74,12 +74,6 @@ struct arm_smmu_option_prop {
 DEFINE_XARRAY_ALLOC1(arm_smmu_asid_xa);
 DEFINE_MUTEX(arm_smmu_asid_lock);
 
-/*
- * Special value used by SVA when a process dies, to quiesce a CD without
- * disabling it.
- */
-struct arm_smmu_ctx_desc quiet_cd = { 0 };
-
 static struct arm_smmu_option_prop arm_smmu_options[] = {
 	{ ARM_SMMU_OPT_SKIP_PREFETCH, "hisilicon,broken-prefetch-cmd" },
 	{ ARM_SMMU_OPT_PAGE0_REGS_ONLY, "cavium,cn9900-broken-page1-regspace"},
@@ -1115,7 +1109,7 @@ static void arm_smmu_write_cd_l1_desc(__le64 *dst,
 	u64 val = (l1_desc->l2ptr_dma & CTXDESC_L1_DESC_L2PTR_MASK) |
 		  CTXDESC_L1_DESC_V;
 
-	/* See comment in arm_smmu_write_ctx_desc() */
+	/* The HW has 64 bit atomicity with stores to the L2 CD table */
 	WRITE_ONCE(*dst, cpu_to_le64(val));
 }
 
@@ -1192,8 +1186,12 @@ void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
 			     const struct arm_smmu_cd *target)
 {
 	struct arm_smmu_cd target_used;
+	int i;
 
 	arm_smmu_get_cd_used(target, &target_used);
+	/* Masks in arm_smmu_get_cd_used() are up to date */
+	for (i = 0; i != ARRAY_SIZE(target->data); i++)
+		WARN_ON_ONCE(target->data[i] & ~target_used.data[i]);
 	while (true) {
 		if (arm_smmu_write_cd_step(cdptr, target, &target_used))
 			break;
@@ -1240,72 +1238,6 @@ void arm_smmu_clear_cd(struct arm_smmu_master *master, int ssid)
 	arm_smmu_write_cd_entry(master, ssid, cdptr, &target);
 }
 
-int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
-			    struct arm_smmu_ctx_desc *cd)
-{
-	/*
-	 * This function handles the following cases:
-	 *
-	 * (1) Install primary CD, for normal DMA traffic (SSID = IOMMU_NO_PASID = 0).
-	 * (2) Install a secondary CD, for SID+SSID traffic.
-	 * (3) Update ASID of a CD. Atomically write the first 64 bits of the
-	 *     CD, then invalidate the old entry and mappings.
-	 * (4) Quiesce the context without clearing the valid bit. Disable
-	 *     translation, and ignore any translation fault.
-	 * (5) Remove a secondary CD.
-	 */
-	u64 val;
-	bool cd_live;
-	struct arm_smmu_cd target;
-	struct arm_smmu_cd *cdptr = &target;
-	struct arm_smmu_cd *cd_table_entry;
-	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
-
-	if (WARN_ON(ssid >= (1 << cd_table->s1cdmax)))
-		return -E2BIG;
-
-	cd_table_entry = arm_smmu_get_cd_ptr(master, ssid);
-	if (!cd_table_entry)
-		return -ENOMEM;
-
-	target = *cd_table_entry;
-	val = le64_to_cpu(cdptr->data[0]);
-	cd_live = !!(val & CTXDESC_CD_0_V);
-
-	if (!cd) { /* (5) */
-		val = 0;
-	} else if (cd == &quiet_cd) { /* (4) */
-		val |= CTXDESC_CD_0_TCR_EPD0;
-	} else if (cd_live) { /* (3) */
-		val &= ~CTXDESC_CD_0_ASID;
-		val |= FIELD_PREP(CTXDESC_CD_0_ASID, cd->asid);
-		/*
-		 * Until CD+TLB invalidation, both ASIDs may be used for tagging
-		 * this substream's traffic
-		 */
-	} else { /* (1) and (2) */
-		cdptr->data[1] = cpu_to_le64(cd->ttbr & CTXDESC_CD_1_TTB0_MASK);
-		cdptr->data[2] = 0;
-		cdptr->data[3] = cpu_to_le64(cd->mair);
-
-		val = cd->tcr |
-#ifdef __BIG_ENDIAN
-			CTXDESC_CD_0_ENDI |
-#endif
-			CTXDESC_CD_0_R | CTXDESC_CD_0_A |
-			(cd->mm ? 0 : CTXDESC_CD_0_ASET) |
-			CTXDESC_CD_0_AA64 |
-			FIELD_PREP(CTXDESC_CD_0_ASID, cd->asid) |
-			CTXDESC_CD_0_V;
-
-		if (cd_table->stall_enabled)
-			val |= CTXDESC_CD_0_S;
-	}
-	cdptr->data[0] = cpu_to_le64(val);
-	arm_smmu_write_cd_entry(master, ssid, cd_table_entry, &target);
-	return 0;
-}
-
 static int arm_smmu_alloc_cd_tables(struct arm_smmu_master *master)
 {
 	int ret;
@@ -1314,7 +1246,6 @@ static int arm_smmu_alloc_cd_tables(struct arm_smmu_master *master)
 	struct arm_smmu_device *smmu = master->smmu;
 	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
 
-	cd_table->stall_enabled = master->stall_enabled;
 	cd_table->s1cdmax = master->ssid_bits;
 	max_contexts = 1 << cd_table->s1cdmax;
 
@@ -1412,7 +1343,7 @@ arm_smmu_write_strtab_l1_desc(__le64 *dst, struct arm_smmu_strtab_l1_desc *desc)
 	val |= FIELD_PREP(STRTAB_L1_DESC_SPAN, desc->span);
 	val |= desc->l2ptr_dma & STRTAB_L1_DESC_L2PTR_MASK;
 
-	/* See comment in arm_smmu_write_ctx_desc() */
+	/* The HW has 64 bit atomicity with stores to the L2 STE table */
 	WRITE_ONCE(*dst, cpu_to_le64(val));
 }
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 950f5a08acda6d..6ed7645938a686 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -608,8 +608,6 @@ struct arm_smmu_ctx_desc_cfg {
 	u8				s1fmt;
 	/* log2 of the maximum number of CDs supported by this table */
 	u8				s1cdmax;
-	/* Whether CD entries in this table have the stall bit set. */
-	u8				stall_enabled:1;
 };
 
 struct arm_smmu_s2_cfg {
@@ -761,7 +759,6 @@ to_smmu_domain_safe(struct iommu_domain *domain)
 
 extern struct xarray arm_smmu_asid_xa;
 extern struct mutex arm_smmu_asid_lock;
-extern struct arm_smmu_ctx_desc quiet_cd;
 
 void arm_smmu_clear_cd(struct arm_smmu_master *master, int ssid);
 struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
@@ -773,8 +770,6 @@ void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
 			     struct arm_smmu_cd *cdptr,
 			     const struct arm_smmu_cd *target);
 
-int arm_smmu_write_ctx_desc(struct arm_smmu_master *smmu_master, int ssid,
-			    struct arm_smmu_ctx_desc *cd);
 void arm_smmu_tlb_inv_asid(struct arm_smmu_device *smmu, u16 asid);
 void arm_smmu_tlb_inv_range_asid(unsigned long iova, size_t size, int asid,
 				 size_t granule, bool leaf,
-- 
2.43.0

