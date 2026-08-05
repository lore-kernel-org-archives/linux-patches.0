Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012027.outbound.protection.outlook.com [40.93.195.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 315EA3E0C47;
	Wed,  5 Aug 2026 19:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.27
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785957369; cv=fail; b=dlAdTFP0g1Z2GxwvMjQ1grOzNC/QF/VXW+97Ou3NIBHfhyANt97pnVosB68eMmKGTF2Y3fFcHFJHXn7+Q3Jw28FlWr2ZAMUrPldM49QraUuJRjMG89d6o1p4+ER9GszYnPXqliV1SPjQ3dqtKPPeY2yXRFShPSyi86tMLZ8O4HI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785957369; c=relaxed/simple;
	bh=5NUZInnFsHFGLxixA/FHIiuWa5rbCUu1wrG495WABKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GVYHp0QhHyDXcE8bcyRz3ObALgmZIQsFTcMQOf9QmgH8xGYkD5NMv8qg8WkSpuJOyv0cWZmhhlGriBLjwLrBALg6K/ncvYcBjDFSJrHohNNx02YyaH4KHvO+00pVTVdfmSrXq7JAw9S4QyoRiHjnDfW1VTt1RXZ2z1xRymi3H/4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nSHyu8WT; arc=fail smtp.client-ip=40.93.195.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nSHyu8WT"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VlrorwMOeTehan5r83eHMSadUOVNC8G2zeEUfgeV8fURk3ezD1jAfTI9gwHiNZBdMDP8kftfTZ09VsR9yZaaCulgXDuPzLw9wQFm0xH5wJrsAEjctbwgFF1E/FMUdnIoIti9D2ZntFqXjSHc0oFL3JEqHIKt9ftYaIrjq7QqjCcNNBFr2neb4ayQZaKo3LZgwL+mhO2sPNsPcTrYcTeyvQUiDsVokcGjyuP2P2p0aersOxdFbhGjuAMDG4MfT3lsBAiGXCIcbXlZvnRD3XyFu/+nf0145RtqyPDlrG4NyffPehUauzd8WXsoEkSSBa1bVrNEdp+/mRMuxRy3HgQMig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qWP1NTRHKO63VLYgucueluECD+YjfAezQi448famuv0=;
 b=gSrKXUEwIqg9smS9ucYOE0emMFtJqTDg5Ss23MSnj2FeWNF7ycK6LHNUm2R+YBVy+ABsy/lGPdKod5tI425ssf/F5wP+pzVFRtT5aH5MawQ3784axcUg90tk7jrCOXIENJPxOFdY0E8UediTa79J1Q+2Ql2qFjV5HixvmRUcD8EJaNj7WAJ/iMECvDnb5jGgMkjg9t+mY4BbxAsXlS7J3nt5N9tGyLO6/jywzpXXSytLYmInBQPbFDMkr3lz6UgHUney0fP/rOmMrH8xfygdfeUReglP9davks3JigzkdHyLWFYokRijLtzxBWd+qhaT3zz3csj8vCRIvm6hSJbysA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qWP1NTRHKO63VLYgucueluECD+YjfAezQi448famuv0=;
 b=nSHyu8WTe57Tw+/XOsUhWx9LIxrNXPPaEwWzdvYekmoMdWxjgBxXmPTPZarFwA6QrbB4XlXUcNW2mtLh20DsyTe2t+0zijO6dyetMT7fKUCzk/E/tKxvseheDH/O+ESzph/D3vgiKHJ+nDrwzA7QVUjGJh9GOGRW4nXOt6mAq14stRc7S4l+3r2OpclxCekuw1DdCySFAUbE3PkktvywCgE/D7GEN3cIudRe5eidwXaTT3Vn27xvP3COv5ajhn3UQlbsdxk6DsP8llSCl/zAWCRFSj9iVRgTYnKkk/1K1Yoz+EZe3J+cAMKumRrclQzr6W8FlxnZ9VphUlinK9JMkQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY1PR12MB9601.namprd12.prod.outlook.com (2603:10b6:930:107::16)
 by PH8PR12MB7157.namprd12.prod.outlook.com (2603:10b6:510:22b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.16; Wed, 5 Aug
 2026 19:15:31 +0000
Received: from CY1PR12MB9601.namprd12.prod.outlook.com
 ([fe80::cd76:b497:475f:4de3]) by CY1PR12MB9601.namprd12.prod.outlook.com
 ([fe80::cd76:b497:475f:4de3%4]) with mapi id 15.21.0270.017; Wed, 5 Aug 2026
 19:15:31 +0000
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
Subject: [PATCH v4 7/8] iommu/arm-smmu-v3: Change how the tlbi describes the invalidation
Date: Wed,  5 Aug 2026 16:15:25 -0300
Message-ID: <7-v4-1802653d8886+492-smmu_tlbi_jgg@nvidia.com>
In-Reply-To: <0-v4-1802653d8886+492-smmu_tlbi_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4P288CA0022.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d4::20) To CY1PR12MB9601.namprd12.prod.outlook.com
 (2603:10b6:930:107::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY1PR12MB9601:EE_|PH8PR12MB7157:EE_
X-MS-Office365-Filtering-Correlation-Id: a2ed0d92-ab63-4a44-1fa9-08def325ea38
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|23010399003|1800799024|6133799003|56012099006|10067099003|11063799006|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	wwmB30pWf/3Q0pEvOSSP8s9ioM3Zeq3JHte3XSOyu4LbRji2nqeyz4rTa8VSZmUdIAPd6Ti7AvlpFZGSGtG7zIRa4wCp75Ak8271vL72XXZt4SJFRtj7ZkHPIRaPZPV2G0xWnXe8iOWJl51vzdqMRcQsKlU0hp92lzY8/lL9tVNK2sMKm/LrhnT4y+Oqb9RwoEh9F5HCFbjsz2dX2U86hie3M7NoQ+EWcsSYr8/oTwhXtwy1PPRowmBVsl9fwQIDIymRwxlmNw0nJHki1aQ8gNJNumkgoAkKwLZCnyAwVNx8QOzGwWS4toW2+bSW+P+hnIpTUvxns/JWGInejlSSutJow+BwoRYNhE46IXnZ0TAR4BdtMIEiVL/CL9nde0aDouRFBeTIVtkjOKnp1z3hGessX9dgIEwzAqG9UYGPUlqn9Hd5KoT1zIbrLHepg6382WEyeM+ZCY8NMaEeksNO0EhkQZ1h/uh9kdRKAcIjayhJbdZjx3uR7Xtdo/MHQx99oY7N0Nxe5QA2jO5CbS6GLp9qM1F05VWR65jXR9HlxjsNFgIsEHupILhgzCNUBxScN1wYwLD7u0sd9B8dl9gK0sYgGHErqDtvWzbWUZHbePtii2bJhQtEfvR28K1a5PFakMTeET8HrhOCFH/0eDz6eUK1wOTvxQXEF7zjw+sZqsY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY1PR12MB9601.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(23010399003)(1800799024)(6133799003)(56012099006)(10067099003)(11063799006)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FaiklEyGhMT5J7DPdB7JJlKBJg6lwo3T+1sFGgLqXCZQxtnxhRMVTj8aLymt?=
 =?us-ascii?Q?D+YkcPZgs/MftX0h/WFjCTYZ78A+rlMFuASK5QlQ8A4IdB+Fc9vyPEoTn5T4?=
 =?us-ascii?Q?Me8KMRg6FH+9m2eRXwmHRkYElRzKMeUGN/uEnfWaj2vCOz4RDROZ2bkevX/I?=
 =?us-ascii?Q?yWVIXTpump0VROMRUWQpRZ1An70Z4dH2xRT0uURcaK8HDKE9lxdBknM3GUS6?=
 =?us-ascii?Q?7sZQvonmZxcJ2uiH28tDKBUqJerR4tgRj9qQi0urtFZ/k+DkBLyW7u4skt/d?=
 =?us-ascii?Q?th5WnV1ut4fVH4+cpS2CKDabbnNOdSUrzlcDUJ60YmCL9QeVKObE9YV0crk6?=
 =?us-ascii?Q?abimqT/77U/JooW8TPBUeO6PKzuZ8n0s98b4nPYKpaQAVfefXK3u8juYM3H7?=
 =?us-ascii?Q?1uwO5tB/TDdvM3D/HypkhO1qSomEp0Qm2rP855p0a+QyIzfllCJNKpX463GU?=
 =?us-ascii?Q?VBUn2exD//TkS0cu6vG3st6U4wYufQ77DpiQ8oA+iHS8nCiYOOkhLqRdITD8?=
 =?us-ascii?Q?rMk08u/zk/gZ224ztdRxkHooDG7ak4nfk9u0xW0Qfs9cOcAH7pHvMSeGzk6V?=
 =?us-ascii?Q?94/E5s7f6NHOvkSVF188b8QbOeNY19rcRHninmXGRSUzYzQ7hzit78IcWhzw?=
 =?us-ascii?Q?lpQMR+ytXeHvMFq9WMrjLYEiVne0HauDvWDDLPIR78AoNLWw8xMckRhg1ZGj?=
 =?us-ascii?Q?Hv/Yy7TgqNFsDcu3/iPX/weUZsGaF7q10uYZynstHvu9ExY9IEdlXJF6nxP5?=
 =?us-ascii?Q?1FMXNmz3lUGOJ4Po+40s6INs3beBfT4OoLD9Xy5w2HcG01t2Vagel6w4ehvQ?=
 =?us-ascii?Q?y2XEjEkVaqOF8TNTgxZ3PfdvAkEmcv6QSF1rjfRsX37/mZlyFyKlglcU+o5x?=
 =?us-ascii?Q?9lRT9CqJLbagFryG3jK3JSlFb0XNeBPIQ2wkmZ/j7DNKCK+hx7a6oF1nj5YK?=
 =?us-ascii?Q?Ff5Uj6CUzw4mrQg3QQRuowHVLJBJ4K0lTUdiMN4qKOgo5yc0cVcnZ766CUAm?=
 =?us-ascii?Q?DKd68kHLmkUYxUoRJxkzmQs/yTP9sNxVpS14zOO1BAfu5PYzWTP1iPiJWtZb?=
 =?us-ascii?Q?me04/eW/g9V/VD9jE6EkkVvteRjAeVZNXW1Oa64qV/pDAeREmYq3OlKjB1Cw?=
 =?us-ascii?Q?GFOOSgodzFlnJVjaVIR17mFAKQTLSGEZs8NdYPgydJjT+MMJ6ji3Rf9MiQ8X?=
 =?us-ascii?Q?EYtklG7j1OtJ5FsjzzgxuvHIPQFOkoQZTrR7WOsxoUGoz4yHUDj9ECbtq+La?=
 =?us-ascii?Q?EkG9EGU2ZEaYDU0dKalCKMslSEBFUXN8WqAh/Yaat3NOOYmmanR8J4zJ9D/J?=
 =?us-ascii?Q?b83xxY859Gj2HkN7Cl2OBkvdR6jvtsJvLWK1TR4qoq5M3KRgHGd/bmcMHrjV?=
 =?us-ascii?Q?0Jf8EVMbcR6kyoilqc8+GUmCid1zVnHuGmGC2YYoOur5z39ftV0TdvV/q/5/?=
 =?us-ascii?Q?HN2NMYzFvPxehCzY25sEzzkVFJ7vBeYH2tsAoo6p4L2OxJFwjB4SBx+yjtZN?=
 =?us-ascii?Q?WY2buj9yYKfL75WKgzmlEi2xGew+adbUvGWlpgPqgIClDLreYqqj0A3Ty+HG?=
 =?us-ascii?Q?93drN9RK5WxlG2eyhMkGxnbreI67xPfCWhSJclw69Et/SMNWUzncunF9bBOS?=
 =?us-ascii?Q?tApzEunGpUCRmA4jvXx4cdtHl9XIEn8IMwpJA9voHa8G72lxjZLXXF6MpiT7?=
 =?us-ascii?Q?e2eCxX+30U1vo5Qb6g7vOpWj5n8FC90dTYxzYXitY986DMmrvZkCJ6vXhabZ?=
 =?us-ascii?Q?bk8pRMVdSA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2ed0d92-ab63-4a44-1fa9-08def325ea38
X-MS-Exchange-CrossTenant-AuthSource: CY1PR12MB9601.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2026 19:15:30.5549
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bJO9H1TEdbVAkJlFuZx65r3J7xhyQ4o+pSc9vQFAP5s+QfdjMO20DlP2c5jg2nRu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7157

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
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |  28 ++-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 171 ++++++++++++++----
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  25 ++-
 3 files changed, 176 insertions(+), 48 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 20f3ca7f5472c6..5a17172df381d5 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -140,17 +140,33 @@ static void arm_smmu_mm_arch_invalidate_secondary_tlbs(struct mmu_notifier *mn,
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
index 3c812df9d01473..5d3fed4d13a217 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2396,8 +2396,8 @@ static struct arm_smmu_cmd arm_smmu_atc_inv_to_cmd(u32 sid, int ssid,
 	 * This has the unpleasant side-effect of invalidating all PASID-tagged
 	 * ATC entries within the address range.
 	 */
-	page_start = tlbi->iova >> inval_grain_shift;
-	page_end = (tlbi->iova + tlbi->size - 1) >> inval_grain_shift;
+	page_start = tlbi->start >> inval_grain_shift;
+	page_end = tlbi->last >> inval_grain_shift;
 
 	/*
 	 * In an ATS Invalidate Request, the address must be aligned on the
@@ -2482,8 +2482,76 @@ static bool arm_smmu_ttl_addr_aligned(u64 address, unsigned int tg,
 	return !(address & GENMASK_U64(pgsz_lg2 - 1, 0));
 }
 
+static int arm_smmu_bitmap_to_level(u8 bitmap)
+{
+	return 3 - (int)__ffs(bitmap);
+}
+
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
+ * Generate a single range TLBI command covering [start, last]. Sets
  * use_full_inv if the range is too large for a single command.
  *
  * The algorithm finds the smallest SCALE where the range (in tg-sized pages)
@@ -2493,32 +2561,29 @@ static bool arm_smmu_ttl_addr_aligned(u64 address, unsigned int tg,
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
@@ -2550,10 +2615,6 @@ static void arm_smmu_tlbi_calc_range(struct arm_smmu_tlbi *tlbi)
 		return;
 	}
 
-	/* 16K granule TTL=1 is reserved (Section 4.4.1) */
-	if (tgsz_lg2 == 14 && ttl == 1)
-		ttl = 0;
-
 	/* Verify address alignment for the TTL hint */
 	if (ttl &&
 	    !arm_smmu_ttl_addr_aligned(cur_tg << tgsz_lg2, tgsz_lg2, ttl))
@@ -2567,20 +2628,44 @@ static void arm_smmu_tlbi_calc_range(struct arm_smmu_tlbi *tlbi)
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
+	if (WARN_ON(!combined))
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
@@ -2600,7 +2685,7 @@ static bool arm_smmu_inv_to_cmdq_batch(struct arm_smmu_inv *inv,
 				       struct arm_smmu_cmd *cmd,
 				       struct arm_smmu_tlbi *tlbi)
 {
-	u64 iova = tlbi->iova;
+	u64 iova = tlbi->start;
 	unsigned int i;
 
 	if (inv->smmu->features & ARM_SMMU_FEAT_RANGE_INV) {
@@ -2620,9 +2705,10 @@ static bool arm_smmu_inv_to_cmdq_batch(struct arm_smmu_inv *inv,
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
@@ -2812,12 +2898,16 @@ static void arm_smmu_tlb_inv_walk(unsigned long iova, size_t size,
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
+	u8 table_levels = BIT((ilog2(size) - tgsz_lg2) / (tgsz_lg2 - 3));
+
+	tlbi.table_levels_bitmap = table_levels;
+	tlbi.leaf_levels_bitmap = table_levels - 1;
 
 	arm_smmu_domain_tlbi(&tlbi, smmu_domain);
 }
@@ -4083,21 +4173,28 @@ static void arm_smmu_flush_iotlb_all(struct iommu_domain *domain)
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
index 187669b8e7e34a..e381fca5a2be6f 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -807,17 +807,30 @@ static inline struct arm_smmu_invs *arm_smmu_invs_alloc(size_t num_invs)
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
@@ -1184,6 +1197,8 @@ static inline void arm_smmu_domain_inv(struct arm_smmu_domain *smmu_domain)
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

