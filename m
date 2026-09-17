Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011046.outbound.protection.outlook.com [40.93.194.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5241C23E324;
	Thu, 17 Sep 2026 00:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789604883; cv=fail; b=E1DlpUvNX3WLlhqMgOfJLzv9lWCYAV3Ib37YHuV8EGODZiAiH/pP1qp4Gu+gBcyRAsVa+SPTHNkuasyNq8K5oPC2meK6kgURklN+2n0gmXpa5HoJqp7/Wuh6p//PQlr8av2+ulXHuvvETsgWgJXt8bEUxYIp7Ve/KPJQw/t6btA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789604883; c=relaxed/simple;
	bh=fM61xir1GVloycQUij2TurUE8mBjCRgGd/TDJYBgVsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=az5R0kTBsAOtIVjwd65NzXEwmwKsDwLwrKOWHW40VgsaSlpVi6N2/k1Yx6c/Jasdwx/muytFdCMuNbfwMZMWXs0qCkgE4Tp/OGLWKjNtHq8kVw2szlr+U37u9qHygdsMHU/Q2/zF28JC+rU1qHu27q+o/F46prO5jTYUT1IOMTM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=XIL5gI1Q; arc=fail smtp.client-ip=40.93.194.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="XIL5gI1Q"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u6vPbDZ2s1wjoVBl50uhY6FeTe1CLZwFU5QpbidxPVzy3igZgE1vc5vs8FyCXK20PJT8Ee/H1zB4pKy12UeblzWTEAEgXnRUEytn0rk8pW/GJQVgAjGqnDRKBrn3+ogy3Zd4ZQbybcpRBf4bt/TU8rmDGLFmFe2LcAsqgO5fHhAJwA+LAtjgR8TIJk9KlVvsaF5QALKzig6ETil9irFlz34jL7bx4+NCyY9enRM/VjrKUQhcvHHTrTZvFhyFYIdSkYKaoEg7PEDtRBKCjq4AHwE7/SY+VqHnUaoW8S0vXxFFFXxtpj5bEeXp0RBpC9Tz/DqtTHduyWaiJezYh/NgTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AySVB4v553kqphuWG8xXm3wL1/owIvmjA05C2iyVqWA=;
 b=pw6ctPzRhuIkONFWyo+FU9unkLETeg6wvGU4FAjphc/4xSxA2dl2NAVtktWDl2GvR8PCUsOms9+963+9zgC/8T7VtCLdZqZQk3xGoIXV2IWEW8qK0oKiS5A767s7f3vZg7yRfvY7nuUsyRUDkDB02CMDbVAd6Dy3TVWq0zsBBkqpEnQtZ9sggbl1DpoTPrBL4k2G0jtokbbP6ZTH4nXfr4i57ee4qdQY5nGQga9YS6zyZHdgHu6zst6cezLhtuJxgoEvdJUjoC1EZULxEBLvtkrHryQ6rrB9mSiu88yIszDxkWh3NaaZzwaQBZTKUtibtAtdWRq7Pn8f5uhkLTKqwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AySVB4v553kqphuWG8xXm3wL1/owIvmjA05C2iyVqWA=;
 b=XIL5gI1Q4A5yE4ro6AKKn/SIpElIVyZXD5vRGHsFq/3hIYZUznanRVMi9pCBqLRl6xzs4RpznvqF2zHjsagxYF4e8C5b3KCdskVDYFdy2f4eo0ea53DznhdS67k1buQXMNrOjGjVkUQ+mYQcmBj261SngKZpmMEuJ7LAcGf3CU5JcKosEtL6WMLlVg19l6IoCymb+F80SjHCI5vPuRWxJn4dGatntlzZ6Q+Yjf2Yg2GesVl8MKo5sutmKbI9p+bSbN6iBt8OlHBa5yDgpgKZtHt1NeTcTlWTMuZb6zz6PGj5XsHBEOUl/pa8zxurGQjxUq6B6Q74aCJf0YkckOWyjA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by LV3PR12MB9188.namprd12.prod.outlook.com
 (2603:10b6:408:19b::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Thu, 17 Sep
 2026 00:27:54 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0428.011; Thu, 17 Sep 2026
 00:27:54 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	iommu@lists.linux.dev,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org,
	Mark Rutland <mark.rutland@arm.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Will Deacon <will@kernel.org>
Cc: David Matlack <dmatlack@google.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	stable@vger.kernel.org,
	Vijayanand Jitta <vijayanand.jitta@oss.qualcomm.com>
Subject: [PATCH v6 8/9] iommu/arm-smmu-v3: Change how the tlbi describes the invalidation
Date: Wed, 16 Sep 2026 21:27:49 -0300
Message-ID: <8-v6-9cd17417d355+281836-smmu_tlbi_jgg@nvidia.com>
In-Reply-To: <0-v6-9cd17417d355+281836-smmu_tlbi_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR14CA0005.namprd14.prod.outlook.com
 (2603:10b6:208:23e::10) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|LV3PR12MB9188:EE_
X-MS-Office365-Filtering-Correlation-Id: 5171b7ce-e1bb-4497-f9fe-08df145282c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|23010399003|11063799006|3023799007|56012099006|6133799003|22082099003|18002099003|10067099003|921020;
X-Microsoft-Antispam-Message-Info:
	drB4YdxIBqi8oDkAP5FRTdQcqDXhCeK1SdTCAxXYCBM/l3YXl/gSjzCaytmowHNdP//fFNQI073osoDC/aXUt31pYJUoIRM6FbQpBdo79Y1AMl6mvRimXaNYx/OdesYVcWOaw16MSixgXtAE+ecv9xgyFHijGeGYsuCSm73EwMFXBhdxzLfRhGlS2kwfX1JDsG5icbJBMW4+rhQnAje0631YtuDiV6c6Q0M1B69zA0l34bXSiqkNgLNFQyOiYLGdwz6bMqMkWDFfA+E/5GoGqC53mg+wgBWhc3qL05imYcKfVoxu62yk+fsa0psyKrTzXwGBvEeaThN1FvqCJXc9EX9Yfdqo5+8oVd7zSQntwJ++RmQ4surpMK9V48EkFPV4Fr1mJAsudX2cQANC6H6PPXzwgPBf+Y9pQHDgQBd4m+pYqS11s1daHgvG4RydMuSb2eqGkD3B5o8n5U2cY/DfS5oLyo5+O59XtwXvVHWkKgBHvmX4A2O6EnjBbSwDXVumwvCbEO10gHsb5ZWl21SuQxjA16aXgIDh3nMg5AVD22POabJ27z6cG5ywQ8hLwI6g1HcbjWUUHIXpTkqyC9K2CgqwL8LG4Yv6fT8PQroj4hvVzFyBS0nquYOj6fKYuYNckfNEfyxJqShYaFdROFUdsoG+TiSlXf1W8Hel/3QgcLjA55pvDLcclr+L9EocyQyJs9kQeidit1CgnQsBgwTsAw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(23010399003)(11063799006)(3023799007)(56012099006)(6133799003)(22082099003)(18002099003)(10067099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Od1pGLqNQQCuYYAuDC8vY5PwDEPAkr0uEpue8fzFofV0Yk9KUPxCPuXtGcJo?=
 =?us-ascii?Q?7pEsAdUgto3n2SntyFdx6z1K9V4YXo0p/x7VcHkzO+oGUnwKT21luw2iLlZu?=
 =?us-ascii?Q?Mh+8a/LnexXYV7zD76xwdUszyOhGWBkeW3dzswbv8KRY1b5fONWy45ZjMT24?=
 =?us-ascii?Q?XF9FNm5+TIN0BhUmJzEnGeQkLvwE6Z5xgBW+y13w1v3A8C0blKPdBvuCgO6J?=
 =?us-ascii?Q?kzEM5ot8+lvD5+0yjNLwBwD8upemWCOB1e8AXn9IZmcXRLiNXVc32iAZj62R?=
 =?us-ascii?Q?QNm+0HXOay3n5NFqpuMIDb8ucghQ9IAsYTdfHGLSgJJg2giZL6tZiosfu8v+?=
 =?us-ascii?Q?XUoKQ0ac0jqE4mDLnTXZXO+WlGwJaB0DIHW6rLtKr9C/PUa9Wpm1eDIK3rhA?=
 =?us-ascii?Q?S59mYI9FIbZBd1McBRphBkWd7lYjnkAuLTgAKoqrrYbycAfLcd9iKDeyW/tU?=
 =?us-ascii?Q?KVwGSXYJEZHioVxKv+YOq3ks4a8pvBQu7Yyj6rKyMae9kjaU6C4axWbBxTSp?=
 =?us-ascii?Q?4jJAGcDoE/qavNCbsIZ6G1Zjb9SNyW6BGPhxVpZWNuaRJNTKHmaP1fVpRP5w?=
 =?us-ascii?Q?6ordYjsNnwNOsSRmn8ifECXU3mOSZJWDcxSuPqgpcjjRImnr6qsapQI/9d9E?=
 =?us-ascii?Q?GeWuSm4jFZoaZnAB3lnax79LQ1BxOz8kNDpVwNLXDo9XXTvnrrrML6w/lQaN?=
 =?us-ascii?Q?6/Ln0AMkSF3cLv3DBPfGxsGXFoX91vhwA0L1/ilmilkyOZz5dFBk1QRlJILy?=
 =?us-ascii?Q?nzkGU6SGFPJ7c7r6FE+PxCWiZCXfPIQlvoJisxDX1rBkbI0Fq10FaGIfPLq5?=
 =?us-ascii?Q?6zJVhWZXQqWGKOA+VUrs+3dNF7fFxyjn9NA4ZeLSq4Fv01J9z8QrrdeHzfNu?=
 =?us-ascii?Q?QrPngjmewCjJScd0T3cwLhUT/xMMaKxFJYamXjoZxUiNINdx33itw3rOz1Yn?=
 =?us-ascii?Q?r0yORZuwAMCBSvOmrzKPdS7LEpfCbsnXXnpN0C1/2sr0RqdaDX+teJWZz9kv?=
 =?us-ascii?Q?m21oh+ZVqYNcQL0ZojHyjDVNfORSy9c55uUXBjYpHBswhHtw5EAWyyuqbFzt?=
 =?us-ascii?Q?uF+oNc7MZGdldsQCZZbgJHcq46mlvw/qmMmH1sJtlDcg4JtUiNRV1w5nMihu?=
 =?us-ascii?Q?oBPvD30dTVCaWqXwjspccbbdG8Q+5WE9qsVzU/cSR/eNEVGec/WvzLd6Pp5F?=
 =?us-ascii?Q?iBxCW3QwDhYp3Gn03BDEoxFsDSk3KPYtMs4sjs3yJtY9w3XUW48c1OolTDap?=
 =?us-ascii?Q?YhNSDjgWAwvJcLl/fRYA+G6XZde05vVhMDSyGuEvmuVAS5B1h+cfynFtvjzn?=
 =?us-ascii?Q?wA80o8wI6kT6oOMxm12BxIrRCHSVOHjbPuGFVZIyNLQBZMIl+Hq4VVObA0qC?=
 =?us-ascii?Q?XVHjqPN8e71Vx0O9boNUFQ3370rIkapwlq2ps3YRg3Mvjyud+kImTOR7RWNe?=
 =?us-ascii?Q?ORGFlUEt+codFHkxyWv8fRC6DZTmxz+MtSDqEP4w8Rckqm/To2zs11FYmvvT?=
 =?us-ascii?Q?1o8Spm6W4yeHKSVgQnAQOZiCaM/L0SzSyH/RPnmhgoetwq5pTYDDaUgnm3TM?=
 =?us-ascii?Q?bikCN0eEO15RJGO47FBlX+bJ+RE/T6JmxQQRQyWLv3bpbTDw9vVlzyPqw6Ga?=
 =?us-ascii?Q?fSac5S+t2DNRt8pY1T1SwjB/L0PdJ4yS9PdDsa8UHSiwnAjMJ1ieQ1gregN1?=
 =?us-ascii?Q?wG/w2ZQZQLiPHtmL1S6+2F8HNFzX1Kk3L88XhjZwSUqFrNm7?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5171b7ce-e1bb-4497-f9fe-08df145282c0
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 00:27:52.5200
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nQsN3BZ2XBawG9LDbVpHoa56YHxPj62NxuQlXnSOs9fKnhaiXg56Lh1Ghim8rLli
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9188

The RIL logic has long had a FIXME that there is not enough
information to properly compute the RIL. There is also subtly not
enough information to properly compute the single stride either.

Change tlbi to use the information format that iommupt is going to
use for ARM. This prepares the invalidation code to support iommupt
and fixes two small limitations with the current code.

iommupt is designed to accumulate all invalidation into a single
gather, then the iommu driver should issue a small number of commands
to execute the gather to control invalidation latency. This is in
contrast to io-pgtable-arm.c which generates many gather flushes and
direct walk cache flushes as it progresses.

To accommodate this the gather will accumulate "damage" in bitmaps,
one for leaf changes and one for table changes. This is enough
information for SMMUv3 to compute the proper stride for single
invalidation and to generate ideal hints for range invalidation.

Change the inner workings of the tlbi process to directly use this
new-style gather description with the idea that the iommupt
conversion will just direct assign the gather fields to the tlbi.

Rework the three places creating the tlbi to express their needs in
terms of the new bitmaps.

1) Simple iotlb invalidation always gets a single range of leaf
   levels, so it can set a single leaf bit

2) Walk invalidation is expected to clear the table and all the leaves it
   could contain. Set a single table bit and all the leaf bits.

   There is a weakness in the existing io-pgtable where it double
   invalidates the leaves, once through the arm_smmu_tlb_inv_walk() then
   again through the gather. Since these are separate operations they are
   not capped by the invalidation count limits and a single unmap may end
   up doing thousands of tlbi commands. Eventually converting to iommupt's
   gather only approach will correct this.

3) SVA invalidation has no idea what the MM did, so it will set all
   the bits in the bitmaps.

   This corrects another weakness where the RIL invalidation logic
   was generating hints assuming the #2 rules which isn't correct
   for SVA.

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |  29 ++-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 179 ++++++++++++++----
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  25 ++-
 3 files changed, 180 insertions(+), 53 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 47eba08bd1161f..fc9622cdbac808 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -140,17 +140,34 @@ static void arm_smmu_mm_arch_invalidate_secondary_tlbs(struct mmu_notifier *mn,
 {
 	struct arm_smmu_domain *smmu_domain =
 		container_of(mn, struct arm_smmu_domain, mmu_notifier);
+	u8 tgsz_lg2 = smmu_domain->tgsz_lg2;
 	struct arm_smmu_tlbi tlbi = {
 		.tgsz_lg2 = smmu_domain->tgsz_lg2,
-		.iova = start,
+		.start = start,
+		.last = end - 1,
 		/*
-		 * The mm_types defines vm_end as the first byte after the end
-		 * address, different from IOMMU subsystem using the last
-		 * address of an address range.
+		 * No information comes from the mm, assume the worst case that
+		 * it changed every table level. The way this is hooked into the
+		 * mm is tricky, the range won't be expanded to include an
+		 * entire table level if one was removed like the iommu gather
+		 * does. Thus even if this is a 4k invalidation it may be
+		 * including any table level too.
 		 */
-		.size = end - start,
-		.iopte_size = PAGE_SIZE,
+		.table_levels_bitmap = 0xfe,
 	};
+	u8 pmd_lg2sz = arm_smmu_pt_level_to_lg2sz(tgsz_lg2, 1);
+
+	/*
+	 * If the size is small then we can infer the invalidation is PTE only
+	 * and set the PTE level only. Otherwise it could be some other
+	 * combination so just set them all. This allows RIL to use TTL=3 in
+	 * cases of PTE only changes. The mm must not try to partially
+	 * invalidate pmd/etc.
+	 */
+	if (end - start < BIT_U64(pmd_lg2sz))
+		tlbi.leaf_levels_bitmap = 1;
+	else
+		tlbi.leaf_levels_bitmap = 0xff;
 
 	arm_smmu_domain_tlbi(&tlbi, smmu_domain);
 }
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index f7f08e6991fa7d..21d340c1a90de8 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2397,8 +2397,8 @@ static struct arm_smmu_cmd arm_smmu_atc_inv_to_cmd(u32 sid, int ssid,
 	 * This has the unpleasant side-effect of invalidating all PASID-tagged
 	 * ATC entries within the address range.
 	 */
-	page_start = tlbi->iova >> inval_grain_shift;
-	page_end = (tlbi->iova + tlbi->size - 1) >> inval_grain_shift;
+	page_start = tlbi->start >> inval_grain_shift;
+	page_end = tlbi->last >> inval_grain_shift;
 
 	/*
 	 * In an ATS Invalidate Request, the address must be aligned on the
@@ -2522,16 +2522,11 @@ static void arm_smmu_tlbi_add_range_cmd(struct arm_smmu_tlbi *tlbi,
 {
 	struct arm_smmu_cmd *cmd =
 		&tlbi->range.cmds[tlbi->range.num_cmds++];
-	unsigned int tgsz_lg2 = tg_enc * 2 + 10;
-	u64 iova = ril->start_tg << tgsz_lg2;
+	u64 iova = ril->start_tg << tlbi->tgsz_lg2;
 	unsigned int num = ril->num - 1;
 
-	/* 16K granule TTL=1 is reserved (Section 4.4.1) */
-	if (WARN_ON(tgsz_lg2 == 14 && ttl == 1))
-		ttl = 0;
-
 	/* Verify address alignment for the TTL hint */
-	if (ttl && !arm_smmu_ttl_addr_aligned(iova, tgsz_lg2, ttl))
+	if (ttl && !arm_smmu_ttl_addr_aligned(iova, tlbi->tgsz_lg2, ttl))
 		ttl = 0;
 
 	/*
@@ -2539,9 +2534,8 @@ static void arm_smmu_tlbi_add_range_cmd(struct arm_smmu_tlbi *tlbi,
 	 * and causes CERROR_ILL. Single tg uses NUM=0, SCALE=0 with a TTL hint
 	 * to target only the exact leaf entry.
 	 *
-	 * For a single tg invalidation a 0 TTL can come from places like the
-	 * SVA path that don't have enough information to get a TTL, or as a
-	 * side of effect of the splitting.
+	 * For a single tg invalidation a 0 TTL can come as a side of effect of
+	 * the splitting.
 	 *
 	 * A single-TG invalidation cannot reach this point if it is part of a
 	 * CONT group, so it is safe to transform it into a single invalidation.
@@ -2552,14 +2546,83 @@ static void arm_smmu_tlbi_add_range_cmd(struct arm_smmu_tlbi *tlbi,
 
 	cmd->data[0] = FIELD_PREP(CMDQ_TLBI_0_NUM, num) |
 		       FIELD_PREP(CMDQ_TLBI_0_SCALE, ril->scale);
-	cmd->data[1] = FIELD_PREP(CMDQ_TLBI_1_LEAF, tlbi->leaf_only) |
+	cmd->data[1] = FIELD_PREP(CMDQ_TLBI_1_LEAF,
+				  !tlbi->table_levels_bitmap) |
 		       FIELD_PREP(CMDQ_TLBI_1_TTL, ttl) |
 		       FIELD_PREP(CMDQ_TLBI_1_TG, tg_enc) | iova;
 }
 
+static int arm_smmu_bitmap_to_level(u8 bitmap)
+{
+	return 3 - (int)__ffs(bitmap);
+}
+
 /*
- * Generate up to two range TLBI command payloads covering [iova, iova+size).
- * Sets use_full_inv if the range is too large to represent.
+ * Compute the TTL hint from leaf/table level bitmaps. 0 ttl means no hint
+ * invalidate all levels.
+ */
+static unsigned int arm_smmu_compute_ttl(u8 leaf_bitmap, u8 table_bitmap,
+					 u8 tgsz_lg2)
+{
+	int ttl;
+
+	if (leaf_bitmap) {
+		/* If TTL is used then only leaves at the TTL are invalidated */
+		if (!is_power_of_2(leaf_bitmap))
+			return 0;
+
+		ttl = arm_smmu_bitmap_to_level(leaf_bitmap);
+		if (table_bitmap) {
+			int table_ttl = arm_smmu_bitmap_to_level(table_bitmap) + 1;
+
+			/*
+			 * A RIL invalidation with !leaf_only clears out all
+			 * table levels above the leaf level ttl only.
+			 */
+			if (table_ttl > ttl)
+				return 0;
+		}
+	} else if (table_bitmap) {
+		/*
+		 * Table-only invalidation. Spec says:
+		 *  For operations with Leaf=0, invalidation of cached Table
+		 *  descriptors for the address and scope additionally occurs at
+		 *  levels between the start of the walk and the level before
+		 *  the last level given by TTL.
+		 * Choose a TTL hint that covers the only target table
+		 * descriptor levels.
+		 */
+		ttl = arm_smmu_bitmap_to_level(table_bitmap) + 1;
+
+		/*
+		 * 16K granule, ARM TTL=1 is reserved (SMMUv3 H.a Section
+		 * 4.4.1.1) if DS=0, avoid it always for table invalidations
+		 * since we don't know what instance this will be applied to
+		 * yet.
+		 */
+		if (tgsz_lg2 == 14 && ttl == 1)
+			return 0;
+	} else {
+		/* Both bitmaps zero is not allowed */
+		WARN_ON(true);
+		return 0;
+	}
+
+	/*
+	 * Assumes the page table is formed properly and does not trigger the
+	 * 16k TTL=1 condition for leaf-only unless DS is enabled.
+	 *
+	 * ARM level -1 never has a leaf so something has gone wrong. ARM Level
+	 * 0 cannot be hinted because ttl=0 means no-hint.
+	 */
+	if (WARN_ON(ttl < 0))
+		return 0;
+	return ttl;
+}
+
+/*
+ * Generate up to two range TLBI command payloads covering [start, last]. Sets
+ * use_full_inv if the range is too large to represent.
  *
  * Normally the first RIL is the largest representable span which does not
  * exceed the requested range. If necessary, the second RIL is the smallest
@@ -2575,21 +2638,14 @@ static void arm_smmu_tlbi_calc_range(struct arm_smmu_tlbi *tlbi,
 				     bool single_ril)
 {
 	u8 tgsz_lg2 = tlbi->tgsz_lg2;
-	struct arm_smmu_ril_range first = { .start_tg = tlbi->iova >>
+	unsigned int ttl = arm_smmu_compute_ttl(
+		tlbi->leaf_levels_bitmap, tlbi->table_levels_bitmap, tgsz_lg2);
+	struct arm_smmu_ril_range first = { .start_tg = tlbi->start >>
 							tgsz_lg2 };
-	u64 last_tg = (tlbi->iova + tlbi->size - 1) >> tgsz_lg2;
+	u64 last_tg = tlbi->last >> tgsz_lg2;
 	u64 num_tg = last_tg - first.start_tg + 1;
 	u8 tg_enc = (tgsz_lg2 - 10) / 2;
 	struct arm_smmu_ril_range trail;
-	u8 ttl = 0;
-
-	/*
-	 * Determine what level the granule is at. For non-leaf, both
-	 * io-pgtable and SVA pass a nominal last-level granule because they
-	 * don't know what level(s) actually apply, so leave TTL=0.
-	 */
-	if (tlbi->leaf_only)
-		ttl = 4 - ((ilog2(tlbi->iopte_size) - 3) / (tgsz_lg2 - 3));
 
 	/*
 	 * The spec defines the invalidated range as:
@@ -2630,20 +2686,43 @@ static void arm_smmu_tlbi_calc_range(struct arm_smmu_tlbi *tlbi,
 }
 
 /*
- * One TLBI command per IOTLB entry, assuming the entries are all at least
- * iopte_granule sized. Sets use_full_inv if too many commands would be needed
- * which indicates too high a latency. The threshold is similar to MAX_DVM_OPS
- * in arch/arm64/include/asm/tlbflush.h for the 4k PAGE_SIZE.
+ * Compute the stride for non-RIL single-page invalidation. Returns the log2
+ * stride of the lowest affected level. Single invalidation removes all IOPTEs
+ * that contain the IOVA invalidated, and we can reliably assume that the
+ * architected page size and table sizes (not contiguous!) are reflected in the
+ * IOTLB. Thus if there is a 2M leaf entry we only need to issue a single IOTLB
+ * invalidation within that 2M IOVA.
+ */
+static u8 arm_smmu_tlbi_calc_stride(struct arm_smmu_tlbi *tlbi)
+{
+	u8 combined = tlbi->table_levels_bitmap | tlbi->leaf_levels_bitmap;
+
+	if (WARN_ON(!combined))
+		return U8_MAX;
+	return arm_smmu_pt_level_to_lg2sz(tlbi->tgsz_lg2, __ffs(combined));
+}
+
+/*
+ * One TLBI command per stride-sized entry. Sets use_full_inv if too many
+ * commands would be needed. The threshold is similar to MAX_DVM_OPS in
+ * arch/arm64/include/asm/tlbflush.h.
  */
 static void arm_smmu_tlbi_calc_single(struct arm_smmu_tlbi *tlbi)
 {
-	unsigned long num_ops = tlbi->size / tlbi->iopte_size;
+	u8 stride_lg2 = arm_smmu_tlbi_calc_stride(tlbi);
+	unsigned long num_ops;
 
+	if (stride_lg2 == U8_MAX) {
+		tlbi->single.use_full_inv = true;
+		return;
+	}
+	num_ops = (tlbi->last - tlbi->start + 1) >> stride_lg2;
 	if (!num_ops || num_ops > 512) {
 		tlbi->single.use_full_inv = true;
 		return;
 	}
 	tlbi->single.num = num_ops;
+	tlbi->single.stride_lg2 = stride_lg2;
 }
 
 static void arm_smmu_inv_all_cmd(struct arm_smmu_inv *inv,
@@ -2663,7 +2742,7 @@ static bool arm_smmu_inv_to_cmdq_batch(struct arm_smmu_inv *inv,
 				       struct arm_smmu_cmd *cmd,
 				       struct arm_smmu_tlbi *tlbi)
 {
-	u64 iova = tlbi->iova;
+	u64 iova = tlbi->start;
 	unsigned int i;
 
 	if (inv->smmu->features & ARM_SMMU_FEAT_RANGE_INV) {
@@ -2688,9 +2767,10 @@ static bool arm_smmu_inv_to_cmdq_batch(struct arm_smmu_inv *inv,
 	}
 
 	for (i = 0; i < tlbi->single.num; i++) {
-		cmd->data[1] = FIELD_PREP(CMDQ_TLBI_1_LEAF, tlbi->leaf_only) |
+		cmd->data[1] = FIELD_PREP(CMDQ_TLBI_1_LEAF,
+					  !tlbi->table_levels_bitmap) |
 			       (iova & ~GENMASK_U64(11, 0));
-		iova += tlbi->iopte_size;
+		iova += BIT_U64(tlbi->single.stride_lg2);
 		arm_smmu_cmdq_batch_add_cmd_p(inv->smmu, cmds, cmd);
 	}
 	return false;
@@ -2886,12 +2966,17 @@ static void arm_smmu_tlb_inv_walk(unsigned long iova, size_t size,
 				  size_t granule, void *cookie)
 {
 	struct arm_smmu_domain *smmu_domain = cookie;
+	u8 tgsz_lg2 = smmu_domain->tgsz_lg2;
 	struct arm_smmu_tlbi tlbi = {
 		.tgsz_lg2 = smmu_domain->tgsz_lg2,
-		.iova = iova,
-		.size = size,
-		.iopte_size = 1 << smmu_domain->tgsz_lg2,
+		.start = iova,
+		.last = iova + size - 1,
 	};
+	u8 table_levels =
+		BIT(arm_smmu_pt_lg2sz_to_level(tgsz_lg2, ilog2(size)));
+
+	tlbi.table_levels_bitmap = table_levels;
+	tlbi.leaf_levels_bitmap = table_levels - 1;
 
 	arm_smmu_domain_tlbi(&tlbi, smmu_domain);
 }
@@ -4162,21 +4247,31 @@ static void arm_smmu_flush_iotlb_all(struct iommu_domain *domain)
 		arm_smmu_tlb_inv_context(smmu_domain);
 }
 
+/*
+ * io-pgtable-arm.c calls this function either under
+ * arm_smmu_tlb_inv_page_nosync() or via the normal iommu code to flush the
+ * gather. Due to how iommu_iotlb_gather_add_page() works the gather will end up
+ * with a single uniform pgsize leaf. If it has to change to a different leaf
+ * level then it flushes the gather and starts a fresh one. Thus this always
+ * targets only a single leaf level.
+ */
 static void arm_smmu_iotlb_sync(struct iommu_domain *domain,
 				struct iommu_iotlb_gather *gather)
 {
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
+	unsigned int tg = smmu_domain->tgsz_lg2;
 	struct arm_smmu_tlbi tlbi = {
 		.tgsz_lg2 = smmu_domain->tgsz_lg2,
-		.iova = gather->start,
-		.size = gather->end - gather->start + 1,
-		.iopte_size = gather->pgsize,
-		.leaf_only = true,
+		.start = gather->start,
+		.last = gather->end,
 	};
 
-	if (!gather->pgsize)
+	if (WARN_ON(gather->pgsize < BIT(tg)))
 		return;
 
+	tlbi.leaf_levels_bitmap =
+		BIT(arm_smmu_pt_lg2sz_to_level(tg, ilog2(gather->pgsize)));
+
 	arm_smmu_domain_tlbi(&tlbi, smmu_domain);
 }
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index e0af6eaf62b3c4..3f701a6d917647 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -822,17 +822,30 @@ static inline unsigned int arm_smmu_pt_lg2sz_to_level(unsigned int tgsz_lg2,
 }
 
 struct arm_smmu_tlbi {
-	unsigned long iova;
-	size_t size;
-	/* page or block size of the leaf iopte */
-	unsigned int iopte_size;
+	unsigned long start;
+	unsigned long last;
 	/* Base Translation Granule of the page table */
 	u8 tgsz_lg2;
-	bool leaf_only;
+	/*
+	 * Level bitmaps use iommupt numbering: bit 0 is the leaf-only level
+	 * (ARM level 3), bit 1 is the next level up (ARM level 2), etc. These
+	 * match the iommu_iotlb_gather.pt fields. Each set bit indicates a
+	 * change at that level. The contiguous hint has no effect on
+	 * invalidation processing because HW can ignore the hint.
+	 *
+	 * The pair selects the invalidation scope:
+	 *   table!=0, leaf==0 : walk cache only
+	 *   table==0, leaf!=0 : leaves only
+	 *   table!=0, leaf!=0 : walk cache + all leaves
+	 *   table==0, leaf==0 : illegal
+	 */
+	u8 leaf_levels_bitmap;
+	u8 table_levels_bitmap;
 
 	struct {
 		bool use_full_inv;
 		u16 num;
+		u8 stride_lg2;
 	} single;
 
 	struct {
@@ -1201,6 +1214,8 @@ static inline void arm_smmu_domain_inv(struct arm_smmu_domain *smmu_domain)
 {
 	/* Prefilled for invalidate all */
 	struct arm_smmu_tlbi tlbi = {
+		.start = 0,
+		.last = ULONG_MAX,
 		.tgsz_lg2 = smmu_domain->tgsz_lg2,
 		.single.use_full_inv = true,
 		.range.use_full_inv = true,
-- 
2.43.0

