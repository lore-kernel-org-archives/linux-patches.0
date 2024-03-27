Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2087.outbound.protection.outlook.com [40.107.93.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E91EA14E2DF;
	Wed, 27 Mar 2024 18:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711562921; cv=fail; b=jo11M0hOJJHvQosQ57mFpW8N12N3+55XfE810prGn8Ifo4zAdyRvd5B8oXtPEPxyCXkQL1NTyJk1ceCX0oHq9d8nWSlYQuJw1/egW+IxIjxpIreIqYhSXTvPoAIrso7egOjAJqfuANmtvsUhosoEMVZjZ85uGxARGrpz87PB50w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711562921; c=relaxed/simple;
	bh=jk93EGEiPqSH4MkIyWcLDDA3CnH8UuEAhbIQqLdnaWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=se1IbIM2hI324P1IAhaHYLLgjY8h5vJDvAcfpzwRERLSEBy/+oTCTitgEpm31EjJZCAz1ILmTZq50c0efEk9Mi4q9Fdhjzys9XHhfL+14f3ozH3ofY33TqTeJ7U8rZKAp9TW+/KkG+cFDN7AsvX3EY34p66vSiaHtOdQ108G3oc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Hz/ezf5N; arc=fail smtp.client-ip=40.107.93.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Hz/ezf5N"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=StTmEQES0fDRsthy/LR30nSlRpfL7duFNAgHAY4A+YJS5N/2V89qhjvCHLr5EKso5VtnG4QOjAKuDUWENJY7sa4dF3gIEB/ckG+VjFpjYq7FLtcFOlu8CWIC8W1BBXwBPRDsmweyk7E7+3BJmW+P8LA1eslVhzp7KvRmjrnq4wKOciH/UyUW9LC1BQXKfj1d8/5aOs37CG31IahERcR4kosK8tmubz3SbZBa2tplu0sBQu2q5EUlVZ8zsTyeVBRVzLM0qzlEHGf+U+bi2j6OS/BWyxszuQG6cM9hMphofvvuNQuIs6r74DG0K3NwTntPNtwpUwMDoLZPgK6v3mGEeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yxSHe/Gm4v6Fx9FqWD10FkfN1pRoQw7ctPe0LMinBtQ=;
 b=c/nCsR8jaG838a+eI6u8UV1hm47ZlsVbtKKiEZAxIqQcMQJKxSQ6Mm+zWgZBvBvp/Hkm2LitULFY5SKaWvbjIkeIm6U4TPiGNBhk08KVsQIjvhdVI68Y8GDaL3N3jBINH0j0fz5AAluk4fpnZN4BSP/Ys6h9Im8v+DympqDNpDEbaxjvnBFtRIF9ml3y0V1AXDc11gSgPanFoUyuaU+HpgGPkK51uai15dUKJIff287VrNY4TxjEdL2HktPlLXPI49f4uOIyjBPsMpjEjjvw7qiWRt79HiLbyXIDzUPwU3d8GMtcSOmwfVAgjLUhbvqzfmUqegWf8424659SiVf4zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yxSHe/Gm4v6Fx9FqWD10FkfN1pRoQw7ctPe0LMinBtQ=;
 b=Hz/ezf5NjbA6zt+/ldV76OrrLtgq6CR/x9sn6+5/4vG1PBxz29df2n7qg6CIFTMl8t4BYEv6oese5iDt117yrDlFcsTSPzs9QYd3hRC4C3vp7NgPgM8TCAKsvFxr6vldc5NLbXZoEHdzFCkX2wnzr21ks896+f4D/15QvSjztmuDlhwkLmcqEl+kEt+3hayO9nYccmGGu4QlN6s1ySVJzVj5wJFnnux59TZ/l+N5TME61msTcwi2JNeKcTrmpPh/k7WMkh10OHP+hq4fd0kM9NuL0riPSKfkdmWRCGCfrsauW5kqKwe9naHpZn60VIxwaBRug5zRrwWY4y6LtZfxKA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by IA1PR12MB6044.namprd12.prod.outlook.com (2603:10b6:208:3d4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Wed, 27 Mar
 2024 18:08:32 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 18:08:32 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <jroedel@suse.de>,
	Kevin Tian <kevin.tian@intel.com>,
	kernel test robot <lkp@intel.com>,
	Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>,
	Tony Zhu <tony.zhu@intel.com>,
	Yi Liu <yi.l.liu@intel.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH v6 12/29] iommu/arm-smmu-v3: Move the CD generation for SVA into a function
Date: Wed, 27 Mar 2024 15:07:58 -0300
Message-ID: <12-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0310.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::15) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|IA1PR12MB6044:EE_
X-MS-Office365-Filtering-Correlation-Id: 14bde0c3-6555-4f01-320d-08dc4e88e1ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ITdkibXyS0OCZ8f77lv0nNPfcoTny3MV1/4l+vzC3+TLU/bD0Nrr67n8t0cAF9JJsrRQsgbuQp8AKBVHCmWE28TqPvNPkjjZlN8KPjXGt4vlJE3uSqBsTB5nNtldwG8wP3s4IoBGDoMK0ylNCzYjDdseoRteauH5s3dMcKu4laVZNY3nQzUYW8y4c4MGZ6nz03EuMrqdV7hbsfbhEootoYYDxthYdWiXBGzNNkyO9ixcnheYK4mE32fNndabyJx0t6jz3uUqaDM6Qmv8e99DcAk7kdUy7g6HRtmhw0r6wlkYzRsVqfMq2/vw7MP6tEUdSZNdWIfR8oXQsWDY2cCvHAjl6TOsYwd7/M7al8DbFbpHz8dhi0RspRTmjvxYPXQzVHAc2XY+/n9uaBd9KgCANo64n1v+N4RX365cXB8Adl4v5u031h4jtNNy+X9MyOKwYcSomdxXyVfr3mUw2wzyF5qk2vrskoBOhYj5Z+w7YVQtcWI8F7tL3oaE++OoNIV9rBmidY8rvL7mRmJi60IOKRnEUz/8R5JV7GNbktbmf3IFJmst9ZdREZ/v/m8+pUAhB9181LPt49znMJ1e3yrB2FJgBOYxXmYu86xnIQVKRC4HA3RLRLAAFPr9EJmdPh3y23oJ0DCt5zc4T3D7xk0gUvxJZcWF5SggY2trABS25wU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/2Z68MCYa99s6JvH0nd/BY+cRrRR7QQ3cuL0OxBOMHMXnx3U58qNKK/u4Xyz?=
 =?us-ascii?Q?y72ADwlqeq6HrbEGoVU4t1tUqsYyivbqzAGykFyuDf7sqdSQy+WQGYzaWRWN?=
 =?us-ascii?Q?MEnKoLbwDXPeDUdlabBDf9w4cT3nBVtMlfB75MsYWTH8455mMpWJAO8/UufX?=
 =?us-ascii?Q?LGs75VkR2uEqjmkI9ihb7HpPfrPhDtc1v93sGOQkpktwfbXHKU4/b65z+07D?=
 =?us-ascii?Q?wKek64SIzyOGvbAR7wh65OceI32RVLAuitEXgkXi20ijphRKe1RxNuHPGoCh?=
 =?us-ascii?Q?eKCvLyHWDBmptKCgmOvuj+BXkeR3GVg5pmG9n90F3iiS/dE0GFjB7s1DrASX?=
 =?us-ascii?Q?GgD0BTcgLwgPlodIk2jXYzolIe7Ikofn3EmdPJ6KmpIfHmSPKHmNL7M9I9mv?=
 =?us-ascii?Q?r4ElD/oBDFdz6odIqiVST8vc1sMrWIv719+u9pxDl3nAKNqgDUzBP5EMUtdV?=
 =?us-ascii?Q?GX0rjE1V8Km9lJPxsifUr/RIklj/1CwQCQMwTES2hJXSty+hwy9M3AxIMsOM?=
 =?us-ascii?Q?ZE89df2sqEVZQEVOC413D+aXF++YGLhgzR+UyOfKCOlHwqcJp95AIm6etjmN?=
 =?us-ascii?Q?f1vgU7fjuGZF8ft77jOej+R9B2OsmEu8bvCqMkSys2ug0y547teRUpIviUkz?=
 =?us-ascii?Q?3Mev1A7FlssfFGSVIB0cgTKOpKaz4jtfvkyn5fCDYjJI7WU5BUSN3LiSBQ9+?=
 =?us-ascii?Q?TrmM7FAmWTrlJEzNq8ICEh0WE4CKUdjucJ4ufOIHdtRk1gU5XUb+dFu2Kadd?=
 =?us-ascii?Q?7xqL4jFaWwFKcWZSUETKPVd8SnG1CyAR5EEXJVTbfUUGykMjel+zYOiXR8Rz?=
 =?us-ascii?Q?O1TG3GqyLsyD0x3Gd5za+gZ8h9DRc7DHIJAierAiH5Fn8G99Mby5AUBbZLvJ?=
 =?us-ascii?Q?Mi21DI5M7dQCTg/Q0Z1EjvHpTAp6sNKoYdZE8rHM/qIyox+UzH4RxcjYCdT3?=
 =?us-ascii?Q?RsRs3NbEXSUgkboUD/1WsYc7R+1OBtDiwNigjwYM1ZxdcGS91XXArTIEvBJL?=
 =?us-ascii?Q?2dFPtQLvqW8/YXnuziV+djr/MoRAnc1DjKw4cVH/HlDXkYbi4Zgd/ZsuTwwX?=
 =?us-ascii?Q?sKe9D/LQmzAT+nSW99F0tHDx6bUmAZh8AhDhPIlDYl7XCEovPvsDMnE+JXHc?=
 =?us-ascii?Q?c2hAnzC7x244ZKt5AKtszw4DMlLYJRtQ/6O8PFL8l8JeFH4Tl32Uwjqtnokc?=
 =?us-ascii?Q?bVw0Yc/WP7xJ+EV3PapvGjQsYofjNN/rP49TXBbLf+TvIlym3/UiNTK1lFuP?=
 =?us-ascii?Q?lHbi+b6SZh5tUN/JvLoOTeGuYnMls8sRLtaevHYnqPYdBcn0oMbg4gpx4OpJ?=
 =?us-ascii?Q?5XeARkOLi3abEiB8t3BC2DlsuRFKwGt1HyChWvc63bGSRyQBtrmPm75n9yEF?=
 =?us-ascii?Q?RoFPYQzsgoPhFXpwVZ3uU+FWJKU8VZPTJXaTVa305nwAtx9T9El1sLglLpkI?=
 =?us-ascii?Q?R/tgqWhquF0mzsnx+IJdku8xFKeq7lOvq1JwO//f24Pw2eE1X8D9rXom+OE5?=
 =?us-ascii?Q?x4f3lajc2KsBSWWg42+7Kijx9Jk4bVm4goT6UWEccsdAygoiVSKzYc04iNhd?=
 =?us-ascii?Q?xiy2NiZweciXeVt5lfIi8eLP0EcPdMYYIQO24UK/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14bde0c3-6555-4f01-320d-08dc4e88e1ff
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 18:08:19.6260
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Niu6dlZKAHYn4yQ/yeEDH6erPLIMU4C6qYFIwNkPUaJGCfTRrhbNBoTx2piaKdSC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6044

Pull all the calculations for building the CD table entry for a mmu_struct
into arm_smmu_make_sva_cd().

Call it in the two places installing the SVA CD table entry.

Open code the last caller of arm_smmu_update_ctx_desc_devices() and remove
the function.

Remove arm_smmu_write_ctx_desc() since all callers are gone. Add the
locking assertions to arm_smmu_alloc_cd_ptr() since
arm_smmu_update_ctx_desc_devices() was the last problematic caller.

Remove quiet_cd since all users are gone, arm_smmu_make_sva_cd() creates
the same value.

The behavior of quiet_cd changes slightly, the old implementation edited
the CD in place to set CTXDESC_CD_0_TCR_EPD0 assuming it was a SVA CD
entry. This version generates a full CD entry with a 0 TTB0 and relies on
arm_smmu_write_cd_entry() to install it hitlessly.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 156 +++++++++++-------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 103 +-----------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |   7 +-
 3 files changed, 108 insertions(+), 158 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 7cf286f7a009fb..80a7d559ef2d3f 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -34,25 +34,6 @@ struct arm_smmu_bond {
 
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
@@ -128,11 +109,86 @@ arm_smmu_share_asid(struct mm_struct *mm, u16 asid)
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
+
+		/*
+		 * Disable stall and immediately generate an abort if stall
+		 * disable is permitted. This speeds up cleanup for an unclean
+		 * exit if the device is still doing a lot of DMA.
+		 */
+		if (master->stall_enabled &&
+		    !(master->smmu->features & ARM_SMMU_FEAT_STALL_FORCE))
+			target->data[0] &=
+				cpu_to_le64(~(CTXDESC_CD_0_S | CTXDESC_CD_0_R));
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
 
@@ -166,39 +222,6 @@ static struct arm_smmu_ctx_desc *arm_smmu_alloc_shared_cd(struct mm_struct *mm)
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
 
@@ -276,6 +299,8 @@ static void arm_smmu_mm_release(struct mmu_notifier *mn, struct mm_struct *mm)
 {
 	struct arm_smmu_mmu_notifier *smmu_mn = mn_to_smmu(mn);
 	struct arm_smmu_domain *smmu_domain = smmu_mn->domain;
+	struct arm_smmu_master *master;
+	unsigned long flags;
 
 	mutex_lock(&sva_lock);
 	if (smmu_mn->cleared) {
@@ -287,8 +312,19 @@ static void arm_smmu_mm_release(struct mmu_notifier *mn, struct mm_struct *mm)
 	 * DMA may still be running. Keep the cd valid to avoid C_BAD_CD events,
 	 * but disable translation.
 	 */
-	arm_smmu_update_ctx_desc_devices(smmu_domain, mm_get_enqcmd_pasid(mm),
-					 &quiet_cd);
+	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
+	list_for_each_entry(master, &smmu_domain->devices, domain_head) {
+		struct arm_smmu_cd target;
+		struct arm_smmu_cd *cdptr;
+
+		cdptr = arm_smmu_get_cd_ptr(master, mm_get_enqcmd_pasid(mm));
+		if (WARN_ON(!cdptr))
+			continue;
+		arm_smmu_make_sva_cd(&target, master, NULL, smmu_mn->cd->asid);
+		arm_smmu_write_cd_entry(master, mm_get_enqcmd_pasid(mm), cdptr,
+					&target);
+	}
+	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
 
 	arm_smmu_tlb_inv_asid(smmu_domain->smmu, smmu_mn->cd->asid);
 	arm_smmu_atc_inv_domain(smmu_domain, mm_get_enqcmd_pasid(mm), 0, 0);
@@ -383,6 +419,8 @@ static int __arm_smmu_sva_bind(struct device *dev, ioasid_t pasid,
 			       struct mm_struct *mm)
 {
 	int ret;
+	struct arm_smmu_cd target;
+	struct arm_smmu_cd *cdptr;
 	struct arm_smmu_bond *bond;
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
 	struct iommu_domain *domain = iommu_get_domain_for_dev(dev);
@@ -409,9 +447,13 @@ static int __arm_smmu_sva_bind(struct device *dev, ioasid_t pasid,
 		goto err_free_bond;
 	}
 
-	ret = arm_smmu_write_ctx_desc(master, pasid, bond->smmu_mn->cd);
-	if (ret)
+	cdptr = arm_smmu_alloc_cd_ptr(master, mm_get_enqcmd_pasid(mm));
+	if (!cdptr) {
+		ret = -ENOMEM;
 		goto err_put_notifier;
+	}
+	arm_smmu_make_sva_cd(&target, master, mm, bond->smmu_mn->cd->asid);
+	arm_smmu_write_cd_entry(master, pasid, cdptr, &target);
 
 	list_add(&bond->list, &master->bonds);
 	return 0;
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 2bf55ed4e32ced..af5ebedf0f0beb 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -89,12 +89,6 @@ struct arm_smmu_option_prop {
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
@@ -1206,7 +1200,7 @@ static void arm_smmu_write_cd_l1_desc(__le64 *dst,
 	u64 val = (l1_desc->l2ptr_dma & CTXDESC_L1_DESC_L2PTR_MASK) |
 		  CTXDESC_L1_DESC_V;
 
-	/* See comment in arm_smmu_write_ctx_desc() */
+	/* The HW has 64 bit atomicity with stores to the L2 CD table */
 	WRITE_ONCE(*dst, cpu_to_le64(val));
 }
 
@@ -1229,12 +1223,15 @@ struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
 	return &l1_desc->l2ptr[ssid % CTXDESC_L2_ENTRIES];
 }
 
-static struct arm_smmu_cd *arm_smmu_alloc_cd_ptr(struct arm_smmu_master *master,
-						 u32 ssid)
+struct arm_smmu_cd *arm_smmu_alloc_cd_ptr(struct arm_smmu_master *master,
+					  u32 ssid)
 {
 	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
 	struct arm_smmu_device *smmu = master->smmu;
 
+	might_sleep();
+	iommu_group_mutex_assert(master->dev);
+
 	if (!cd_table->cdtab) {
 		if (arm_smmu_alloc_cd_tables(master))
 			return NULL;
@@ -1350,91 +1347,6 @@ void arm_smmu_clear_cd(struct arm_smmu_master *master, ioasid_t ssid)
 	arm_smmu_write_cd_entry(master, ssid, cdptr, &target);
 }
 
-static void arm_smmu_clean_cd_entry(struct arm_smmu_cd *target)
-{
-	struct arm_smmu_cd used = {};
-	int i;
-
-	arm_smmu_get_cd_used(target->data, used.data);
-	for (i = 0; i != ARRAY_SIZE(target->data); i++)
-		target->data[i] &= used.data[i];
-}
-
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
-	struct arm_smmu_device *smmu = master->smmu;
-
-	if (WARN_ON(ssid >= (1 << cd_table->s1cdmax)))
-		return -E2BIG;
-
-	cd_table_entry = arm_smmu_alloc_cd_ptr(master, ssid);
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
-		if (!(smmu->features & ARM_SMMU_FEAT_STALL_FORCE))
-			val &= ~(CTXDESC_CD_0_S | CTXDESC_CD_0_R);
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
-	/*
-	 * Since the above is updating the CD entry based on the current value
-	 * without zeroing unused bits it needs fixing before being passed to
-	 * the programming logic.
-	 */
-	arm_smmu_clean_cd_entry(&target);
-	arm_smmu_write_cd_entry(master, ssid, cd_table_entry, &target);
-	return 0;
-}
-
 static int arm_smmu_alloc_cd_tables(struct arm_smmu_master *master)
 {
 	int ret;
@@ -1443,7 +1355,6 @@ static int arm_smmu_alloc_cd_tables(struct arm_smmu_master *master)
 	struct arm_smmu_device *smmu = master->smmu;
 	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
 
-	cd_table->stall_enabled = master->stall_enabled;
 	cd_table->s1cdmax = master->ssid_bits;
 	max_contexts = 1 << cd_table->s1cdmax;
 
@@ -1541,7 +1452,7 @@ arm_smmu_write_strtab_l1_desc(__le64 *dst, struct arm_smmu_strtab_l1_desc *desc)
 	val |= FIELD_PREP(STRTAB_L1_DESC_SPAN, desc->span);
 	val |= desc->l2ptr_dma & STRTAB_L1_DESC_L2PTR_MASK;
 
-	/* See comment in arm_smmu_write_ctx_desc() */
+	/* The HW has 64 bit atomicity with stores to the L2 STE table */
 	WRITE_ONCE(*dst, cpu_to_le64(val));
 }
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index d32da11058aab6..5aefb0ee2b9bb7 100644
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
@@ -747,11 +745,12 @@ static inline struct arm_smmu_domain *to_smmu_domain(struct iommu_domain *dom)
 
 extern struct xarray arm_smmu_asid_xa;
 extern struct mutex arm_smmu_asid_lock;
-extern struct arm_smmu_ctx_desc quiet_cd;
 
 void arm_smmu_clear_cd(struct arm_smmu_master *master, ioasid_t ssid);
 struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
 					u32 ssid);
+struct arm_smmu_cd *arm_smmu_alloc_cd_ptr(struct arm_smmu_master *master,
+					  u32 ssid);
 void arm_smmu_make_s1_cd(struct arm_smmu_cd *target,
 			 struct arm_smmu_master *master,
 			 struct arm_smmu_domain *smmu_domain);
@@ -759,8 +758,6 @@ void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
 			     struct arm_smmu_cd *cdptr,
 			     const struct arm_smmu_cd *target);
 
-int arm_smmu_write_ctx_desc(struct arm_smmu_master *smmu_master, int ssid,
-			    struct arm_smmu_ctx_desc *cd);
 void arm_smmu_tlb_inv_asid(struct arm_smmu_device *smmu, u16 asid);
 void arm_smmu_tlb_inv_range_asid(unsigned long iova, size_t size, int asid,
 				 size_t granule, bool leaf,
-- 
2.43.2

