Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013005.outbound.protection.outlook.com [40.107.201.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D46B2641EE;
	Tue, 14 Jul 2026 18:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784054786; cv=fail; b=qnOP9V7roNilxPDkpLMXlvC1hM8rT52YfouQK1ImKjLyCw808tnGg7mWXn9+V+ltXVsyIKSyDfis+NWapNaKLvjSG/tOl4jkEtiWMvuima6x1vanpn3svZJR1rH2B5eTHKw1Q12XhP4hYCQLepKArK+9/NPuHkRsyrq7mtRdWvA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784054786; c=relaxed/simple;
	bh=ozNSF270kwycgj8uOkRjFVR/fDxF6t9NCItRqw9pnd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=M5sgjumGYE9DXIhmfJll9kvjAuQKCPGwMIrBO+luz5QntKWjKwvxRNyao7HH0ncjLNXioj+Y0sLeUTJu2z39fZcAr5ygM/D5sZJbmCfZf2ye+wEdtlhmCkuXi6k+1rHXbUvQeGR42oY7Eq+pHdDdaRRhjlNxBmW90COqcDD4XAA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=j9AxH/n5; arc=fail smtp.client-ip=40.107.201.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="j9AxH/n5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SnUWUdurNG4tvZC6x+7DcvYO/7GDIn0JyORZh7UHlkDdb0x6agyl64YBkB4mvhHvBwLQRHz/AmMYwTvkK6gO6CHh1qeNuzH+O+D/IYmwHh8RG2G7F5Y70tAtC6Un5Lpib4ctrdUulVSUcbVlHutKeb6JviJC32K3nu+aIDzwMg22F4CAPEScdWid9btmYi0rkiTicKU+KTdHjwRu021dpHhmkUaVeXWkFO9d8yVceuyvEeu8pF5Eqwi3WDPHecgAlIEEIH4VHyyPmxGjT7ZgwDtO8DQ2iV27Ka6iUIm8ubH93o7Pji9ta3kZPQeT53i/rQ7wXTSqo5n1T1NUSlywAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DGDXjPbLakX9O1R7sS/Zwy7iqIxQp1IJzzbQUIqjkHg=;
 b=YnoPIzR6hVLc2qxHAkomhwwlVQnRC0a3yILOr6n94WIf86OZDaAm/g5OH8+G+nm6R7tYbNvhVsgwuix8dmSMCzO32VniVoyaHARvlGqOqgtBFoWs08WcRULUyBpgMmr1NCUJPulgSjtopG2ZADt5tqp2NRmKoAIT3fLUSifuJbs0MraSJ/jwDIDFxpShNvGQXQkgyY5IcKCR9WBA9dxEQ+XgKufFtXQOsh5H8gUbMb6NY5ivbjWVlD4ghesSDsINXGij/AEsdC+zwk5Yzw2KsYePlWCJy9durAsVnznsYV72YXS3ZYGCJgODE490CgVa/nooqW7/bo3lqLpkQ3FQdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DGDXjPbLakX9O1R7sS/Zwy7iqIxQp1IJzzbQUIqjkHg=;
 b=j9AxH/n5MUKygZMvPolGZrXMTjXFI6CONEVlFza7m9A/fHzFOCv8Hk7QTQr3/CMqyi/sJexO++DQjNLIYqWTBzcm4cLmZAJpMT/PGH6zkLFt90RBpNi2w/b3S8HrMS3UJldt2Ktvmdx1qEJADHU8aCOHb0iQl7RExGXrNR5ACco2gTMblgMrwJ/Vlb8hdllyrbmes+9vxlYwRTMVx0ZoxoOCIwesovQ97UJ4l8rYx3J+ivXSPe1yOigdsyiCTIVgTFnFUeDZM+Lhj1bXrtczcyibuXnGAOs+/3tZ/P3gmALJvw7sgkY74GuLpMuKWzVLGW5cJuCQ2W7zvDOB2+RhiA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DS7PR12MB5933.namprd12.prod.outlook.com (2603:10b6:8:7c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.202.18; Tue, 14 Jul
 2026 18:46:12 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0202.014; Tue, 14 Jul 2026
 18:46:12 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: David Matlack <dmatlack@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v3 7/8] iommu/arm-smmu-v3: Change how the tlbi describes the invalidation
Date: Tue, 14 Jul 2026 15:46:07 -0300
Message-ID: <7-v3-4e7f64f4e094+85e-smmu_tlbi_jgg@nvidia.com>
In-Reply-To: <0-v3-4e7f64f4e094+85e-smmu_tlbi_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9P221CA0029.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:408:10a::27) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DS7PR12MB5933:EE_
X-MS-Office365-Filtering-Correlation-Id: 60561305-4414-4788-4941-08dee1d82bdc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|366016|1800799024|3023799007|6133799003|56012099006|22082099003|18002099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	uQsOXsYlDdOCi7YoLSxVFOnWZAZY/vp1TLrwwpP730Iq9OXtr5v8gFbLj4EdiX7YPZNV+F7W1YyWX89WLENaNxFdL9g3Pzy0MeP6cb9TmNSS8/LDlMdAMvsYvq5gEoBAbKFk759ByS2yYGElp70FKtLjgSLTBYPbDnpmaDGoJOxZNDICL5PeJO01pQPcvWBQUc88T/tGOqFR3nI6z0ziBO967aFnV5IpJPS6qwwrH7UI8lGI56pZ/tXs6MjR6a0/JBFcdxJaY77MwPhDjTsCSIK0DgZUTvrjwsy1YeWC7g5bTr9l/wOdjfOwEOHRwWCDv9woptIhBvQhJzcMW41O9mPNIuTtrico1mv/m63DGFBvyLdl5B6eqRh1seQjJdU7fQiOSxGh5Kakisi3msrRVktvm7UmKAfv3k8Sd67ycscVA1Dcr4UL/x23F9lYdU6/Ju1V9ZUhU9mHxkZkF3upJA2x6VU//RjuD+oNCcsmGAjDnPjWC7DieTRCAwiOVEzdZBoQPzBmABldNmsat9Nm8EEeRDr41Qeug1LWHtxhlRMpOns6sIxkTFUyi5Sn6x0nfgg5jbnyTMyNc7dQ/CcoWIAUgQx9WbDHhtoRA4jXZxwHbQHl6qaoSCxDQdwvqUjeoA60ImiVIlb7kP3B9xc69cxF6azky/Josy/GHyQB72M=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(366016)(1800799024)(3023799007)(6133799003)(56012099006)(22082099003)(18002099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PcZkEFgX4TpymtWw8fPkdVUGXZFI6XO3ETVM0g0pS4TvjulcuNbSFDB2OxV9?=
 =?us-ascii?Q?dDxWjMhR/RtBDEm1v5qfybUm+6EcGDGbEcvNbj2EIs1/r1ep5nhTAjW83eZw?=
 =?us-ascii?Q?vKz+G2A2fYSrrxgvOoTJsDyjOnq0ayn71TalWzKVxg8ao7kh8znhNrhPvqKr?=
 =?us-ascii?Q?O+1xJiW/nFmvXaYVoX7V62BycuKPwbNdIqLHfTnI4b1yRlAdCLqynOoXwV2w?=
 =?us-ascii?Q?kN/wKb02Q4npzXxpi6zm4PWD82Uqrux+blDRDEKhBUtVUQnPcL+Auu/m7+AA?=
 =?us-ascii?Q?rTnTJR2mzm2SDmIODpMJcRerMkTjdZ4gf8RxFvXupvn8JF/9uHCC8Ede0hZC?=
 =?us-ascii?Q?9zm27zu8rXgXsEF2GaL8YVo4l1Jjhz4dyaYWEvd/E/93dkd57cMNZCf7VNnC?=
 =?us-ascii?Q?/h45wOE7LMC/ukmj2Fu2MkamivRmlRZKZ12pogzUQJ22tC9oo1UVm2Bz693S?=
 =?us-ascii?Q?YaT+FOeoeEAFe8BzzKaT6/iku7bhDSp9bOd+IPsmQtnrqyA5vCq5P8hbUZmq?=
 =?us-ascii?Q?REGuPXzS2n/GhOgmC6BuTu+ZBZyaM08vRUO9u+kgnrNmF5d4/z/nyLMfH2Zs?=
 =?us-ascii?Q?rR14nGr4zlq4yEs40NT8Il53jFmiGna6/sGt75hpp+hnU21+sYK/VzfkuyfK?=
 =?us-ascii?Q?fS9sW7RR12c6Gp55YCLCdxQEWNmsjFIV6K74gpy98819WmLUygwf8fS4ipwn?=
 =?us-ascii?Q?337MP6gQWWAugbg3epBWiIPa+99IgNmcl0XTDWhdwS0Yp3mKkJ58/2/cfdrP?=
 =?us-ascii?Q?gQm/1I2HxZ5HTFhWQUKmZqf5SzSJdL2Bpli8C9M7HhXCZsZgwykZEOTZTX3g?=
 =?us-ascii?Q?rXaqzMyP9R0kBPWpqRmRvn8zJCY3inn64gNmTwbr5bqW+rWEvEtHxl1vzHEF?=
 =?us-ascii?Q?iLdbPgOhIjcxXRoaOonihWFcSaL1pyd9Un09LxrfwLGfXQY2cyHZvOs1qqg1?=
 =?us-ascii?Q?e0G1Wy1ynn4nPI2mgwZpL1GA+n4o6NzYOfDfZxjUofG5HH4CfSjI3WyOOIv4?=
 =?us-ascii?Q?FV/QwFCVUhC0qlDOCXo551brLnLiqQijY46IbuVd8/xNl5LGBKeqVbk/36Iq?=
 =?us-ascii?Q?3oXhRhJXxSBL6IkwPAKQnmTPX3B4D1F4J09ygd7g85q/F7VOe5te/opbNmmB?=
 =?us-ascii?Q?wcoGkyp8OBEqE9E0fVKKREM5JqR7U7AqyiQ5KrW3IDWmWX7VKkdK5Y4Rf22h?=
 =?us-ascii?Q?Lw6mUgKeA8PXDsWM2jMGKPkMc4JuX1fv3bgwq4odxGupq0IeyTRgHrTDiaTE?=
 =?us-ascii?Q?cuxdIRea2TgyFMNukd4m4pp7WdjQlw6LJrDqx2YTdOib07/vuvmbNYm/NVGZ?=
 =?us-ascii?Q?IPCYG948fddIILAYMT6W+3BNfW21j/sUp7TIVN8oV/QdH1Fs4Qjc1GCeO5lW?=
 =?us-ascii?Q?6/dyrjxDKkTxKsYrfKeUqRaDEb+Rm14G1GaMGb/uh7yQ0Q3aYAc+pg9BFqe/?=
 =?us-ascii?Q?CxqPylCDXBGaMk0EeuANmaTP2X8dp3n+S2eSkvl59eOm0YMsnOEHzS6gURel?=
 =?us-ascii?Q?A9srGiTp4rCR0GQl+1Wspvoa+MpDPpNJh4hUvsaBSALZ+FMmgcRmxnS7TH53?=
 =?us-ascii?Q?Auon+KCtsBvSD+sQyM7q4Mc8yel0MY2YjC3xbcpIk9R9Mx++CLoJ2kYyiQS/?=
 =?us-ascii?Q?xHUD+q4QcApN+odXMHs4BNa4GBSs6ZYqAt8KIa0N/BnjT+BpWEyHXquG0DaI?=
 =?us-ascii?Q?vEDvhWlSgK+IQd/JX8SK3H+cgjMXY1ngP3dx47uCzJ9eAdI5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60561305-4414-4788-4941-08dee1d82bdc
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2026 18:46:10.0901
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /KY5j5OdD54sPn/oJOEwEjU9H/mr88QZ86BUjxg4cCqpFZfL4Y/0c01I+Act4VYk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5933

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

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |  28 ++-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 165 ++++++++++++++----
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  23 ++-
 3 files changed, 168 insertions(+), 48 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 52f4afe3178d21..3b04de52e8c599 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -139,17 +139,33 @@ static void arm_smmu_mm_arch_invalidate_secondary_tlbs(struct mmu_notifier *mn,
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
+	u8 pmd_lg2sz = (tgsz_lg2 - 3) * 1 + tgsz_lg2;
+
+	/*
+	 * If the size is small then we can infer the invalidation is PTE only
+	 * and set the PTE level only. Otherwise it could be some other
+	 * combination so just set them all. This allows RIL to use TTL=3 in
+	 * cases of PTE only changes.
+	 */
+	if (end - start < BIT_U64(pmd_lg2sz))
+		tlbi.leaf_levels_bitmap = 1;
+	else
+		tlbi.leaf_levels_bitmap = 0xff;
 
 	arm_smmu_domain_tlbi(&tlbi, smmu_domain);
 }
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index c74da1a8ea54f9..d54fff36731116 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2331,8 +2331,8 @@ static struct arm_smmu_cmd arm_smmu_atc_inv_to_cmd(u32 sid, int ssid,
 	 * This has the unpleasant side-effect of invalidating all PASID-tagged
 	 * ATC entries within the address range.
 	 */
-	page_start = tlbi->iova >> inval_grain_shift;
-	page_end = (tlbi->iova + tlbi->size - 1) >> inval_grain_shift;
+	page_start = tlbi->start >> inval_grain_shift;
+	page_end = tlbi->last >> inval_grain_shift;
 
 	/*
 	 * In an ATS Invalidate Request, the address must be aligned on the
@@ -2418,7 +2418,69 @@ static bool arm_smmu_ttl_addr_aligned(u64 address, unsigned int tg,
 }
 
 /*
- * Generate a single range TLBI command covering [iova, iova+size). Sets
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
+		ttl = 3 - (int)__ffs(leaf_bitmap);
+		if (table_bitmap) {
+			int table_ttl = 3 - (int)__ffs(table_bitmap) + 1;
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
+		ttl = 3 - (int)__ffs(table_bitmap) + 1;
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
+ * Generate a single range TLBI command covering [start, last]. Sets
  * use_full_inv if the range is too large for a single command.
  *
  * The algorithm finds the smallest SCALE where the range (in tg-sized pages)
@@ -2428,32 +2490,29 @@ static bool arm_smmu_ttl_addr_aligned(u64 address, unsigned int tg,
 static void arm_smmu_tlbi_calc_range(struct arm_smmu_tlbi *tlbi)
 {
 	u8 tgsz_lg2 = tlbi->tgsz_lg2;
-	u64 cur_tg = tlbi->iova >> tgsz_lg2;
-	u64 last_tg = (tlbi->iova + tlbi->size - 1) >> tgsz_lg2;
+	unsigned int ttl = arm_smmu_compute_ttl(
+		tlbi->leaf_levels_bitmap, tlbi->table_levels_bitmap, tgsz_lg2);
+	u64 cur_tg = tlbi->start >> tgsz_lg2;
+	u64 last_tg = tlbi->last >> tgsz_lg2;
 	u64 num_tg = last_tg - cur_tg + 1;
 	u8 tg_enc = (tgsz_lg2 - 10) / 2;
 	unsigned int scale;
-	u8 ttl = 0;
 
 	tlbi->range.data1 =
-		FIELD_PREP(CMDQ_TLBI_1_LEAF, tlbi->leaf_only) |
+		FIELD_PREP(CMDQ_TLBI_1_LEAF, !tlbi->table_levels_bitmap) |
 		FIELD_PREP(CMDQ_TLBI_1_TG, tg_enc) | (cur_tg << tgsz_lg2);
 
 	/*
-	 * Determine what level the granule is at. For non-leaf, both
-	 * io-pgtable and SVA pass a nominal last-level granule because they
-	 * don't know what level(s) actually apply, so leave TTL=0.
-	 */
-	if (tlbi->leaf_only)
-		ttl = 4 - ((ilog2(tlbi->iopte_size) - 3) / (tgsz_lg2 - 3));
-
-	/*
-	 * SMMUv3 F.b Section 4.4.1: TG!=0, NUM==0, SCALE==0, TTL==0 is
+	 * SMMUv3 H.a Section 4.4.1.1: TG!=0, NUM==0, SCALE==0, TTL==0 is
 	 * Reserved and causes CERROR_ILL. Single page uses NUM=0, SCALE=0 with
 	 * a TTL hint to target only the exact leaf entry.
 	 */
 	if (num_tg == 1) {
-		if (!ttl)
+		/*
+		 * The two io-pgtable ops filling the tlbi won't generate ttl=0.
+		 * sva sets constants for single page that give ttl=3
+		 */
+		if (WARN_ON(!ttl))
 			ttl = 3;
 		tlbi->range.data0 = 0;
 		tlbi->range.data1 |= FIELD_PREP(CMDQ_TLBI_1_TTL, ttl);
@@ -2485,10 +2544,6 @@ static void arm_smmu_tlbi_calc_range(struct arm_smmu_tlbi *tlbi)
 		return;
 	}
 
-	/* 16K granule TTL=1 is reserved (Section 4.4.1) */
-	if (tgsz_lg2 == 14 && ttl == 1)
-		ttl = 0;
-
 	/* Verify address alignment for the TTL hint */
 	if (ttl &&
 	    !arm_smmu_ttl_addr_aligned(cur_tg << tgsz_lg2, tgsz_lg2, ttl))
@@ -2502,20 +2557,44 @@ static void arm_smmu_tlbi_calc_range(struct arm_smmu_tlbi *tlbi)
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
+	u8 tg_szlg2 = tlbi->tgsz_lg2;
+
+	if (!combined)
+		return U8_MAX;
+	return (tg_szlg2 - 3) * __ffs(combined) + tg_szlg2;
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
@@ -2535,7 +2614,7 @@ static bool arm_smmu_inv_to_cmdq_batch(struct arm_smmu_inv *inv,
 				       struct arm_smmu_cmd *cmd,
 				       struct arm_smmu_tlbi *tlbi)
 {
-	u64 iova = tlbi->iova;
+	u64 iova = tlbi->start;
 	unsigned int i;
 
 	if (inv->smmu->features & ARM_SMMU_FEAT_RANGE_INV) {
@@ -2555,9 +2634,10 @@ static bool arm_smmu_inv_to_cmdq_batch(struct arm_smmu_inv *inv,
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
@@ -2747,12 +2827,16 @@ static void arm_smmu_tlb_inv_walk(unsigned long iova, size_t size,
 				  size_t granule, void *cookie)
 {
 	struct arm_smmu_domain *smmu_domain = cookie;
+	u8 tgsz_lg2 = smmu_domain->tgsz_lg2;
 	struct arm_smmu_tlbi tlbi = {
 		.tgsz_lg2 = smmu_domain->tgsz_lg2,
-		.iova = iova,
-		.size = size,
-		.iopte_size = smmu_domain->tgsz_lg2,
+		.start = iova,
+		.last = iova + size - 1,
 	};
+	u8 table_levels = BIT((ilog2(size) - tgsz_lg2) / (tgsz_lg2 - 3));
+
+	tlbi.table_levels_bitmap = table_levels;
+	tlbi.leaf_levels_bitmap = table_levels - 1;
 
 	arm_smmu_domain_tlbi(&tlbi, smmu_domain);
 }
@@ -4018,21 +4102,28 @@ static void arm_smmu_flush_iotlb_all(struct iommu_domain *domain)
 		arm_smmu_tlb_inv_context(smmu_domain);
 }
 
+/*
+ * Called by io-pgtable-arm.c for each run of same pgsize leaf only
+ * invalidation. If it has to change to a different leaf level then it flushes
+ * the gather and starts a fresh one. Thus this always targets only a single
+ * leaf level.
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
 
+	tlbi.leaf_levels_bitmap = BIT((ilog2(gather->pgsize) - tg) / (tg - 3));
+
 	arm_smmu_domain_tlbi(&tlbi, smmu_domain);
 }
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 053288cdf48e87..ca6f0bd21d7df6 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -804,17 +804,28 @@ static inline struct arm_smmu_invs *arm_smmu_invs_alloc(size_t num_invs)
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
+	 * If leaf_levels_bitmap is 0 then this is a walk cache only
+	 * invalidation. If table_levels_bitmap is 0 then this is a leaf only
+	 * invalidation.
+	 */
+	u8 leaf_levels_bitmap;
+	u8 table_levels_bitmap;
 
 	struct {
 		bool use_full_inv;
 		u16 num;
+		u8 stride_lg2;
 	} single;
 
 	struct {
@@ -1178,6 +1189,8 @@ static inline void arm_smmu_domain_inv(struct arm_smmu_domain *smmu_domain)
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

