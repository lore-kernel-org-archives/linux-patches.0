Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2063.outbound.protection.outlook.com [40.107.93.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8BFB12B148;
	Wed,  8 May 2024 18:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715194658; cv=fail; b=Z3/F2ffuOgSE8KKyhdEPkQIDiDfOJ5AjObYf0aaaZlE/1INxytyokO8FJ9QCXpm0wDyZao1YcXvRZaLL0QQl1MtwYbCjbQ/b/VS01e7rFnmSrGCkCxAw2wGEE90Vx0BJiMjOAQ0UxYvHzNkhKzmtVhCImllSAuOKwi8cTq2OAB0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715194658; c=relaxed/simple;
	bh=2oOKSIcst5crreRlJpawHpntVPQskyUxl5tQQl/dWNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pKdpcvVXuDdIQC94PSNhUWwhsu293ZPpP7E0Y2I/psuUXQtcItF+PC1P9Q8OPAHlqukR0oKSXcjDYVo8WUoseUgZ5qS8q1LBBdTYlMsbSlSGnd0xBH0Z2ueF7ZwmLJaAcfQRC0nZWqLLZDEKJ4644GlAG4ZdilcFIREtAfSAzbk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=EdguU+sR; arc=fail smtp.client-ip=40.107.93.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="EdguU+sR"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IrVhWNuAZ0MI0XoCvqCqAYXqcbkMnswbD5WT8BAxLiJZcnPQE0q0qkDXlhJTgzgEFk2yJV79nAKHXMqBlDZqIHZtGTwsvXyEC+r49vwzQZ8EzVca117DwI5htIjroi8XwUWYygx0JsjS0SMxXt4/HLDpdOhYI6x8YiV5Nem3JsVbBn2Ai/ixELg1CjtCKMYJbXF+Xm/VlYSa7jegLh9ZMJ9wY+8Qf+NPWdqf5TjkhmP8/ol2VbdCyfTDfs77AZlt244O6WRhRBaypLbY17E5uBHSmTe3B4nz0JM1MtR5yys50fzFZfJejom+uBlEJEmE0f/OcEu1tX5HaNcA9awlFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+ACxAnTnuYV0Dl/daixsQJNVd0lWjEHqwttskA5sfkE=;
 b=UakHfmv+PEHtsgMFRxrlE04qUPldWXmEh92Iv3u0KxiOn80MdvL5tuRMUgmB4RXKyFkbTazX+AkPZDYGZPDpib1oTU5Zx9p4QHnoDxdm06fadMgLktQp+4szInq8VkVFyJRrdB9cl9sdoqkOR8FUkWd3u7P+3nW/hODymitlbLvrmjQI7rtCnbBlFTY4T3KwLh+go50cI3BVjJjCDonIT9yW+B04c9Xsqcqqy6ex3Kl3F7ORIcn5vLf6KP3bkaZLuXviVIF/AH34HhmJLdhyF2iPpyDwplSzCXH+BudNfvopVcZZqsst5nNLJLSxJfEYS6tgo+z25phJ+z3/x+nhNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+ACxAnTnuYV0Dl/daixsQJNVd0lWjEHqwttskA5sfkE=;
 b=EdguU+sRZ+cPT4/W3KJ5nEAi7C1sgIzhICmMfBRVUbpRDEt0wJHC6tTpdy1NWmLV++0JdJN6Nm61mOz3OhN4CctiDoi/642YtzlkFjbpQOEGrJXGHrF1M4uGrAQnBKDASr6eiAqW81BsMn6MCWs+3pztUsR87GMRPejj/MkzFZx2cKKxJ1fPJypNp+P//XD4ttUehjgGOAw7QZg54BEM2UgKApeOdDBQk/DtKhacVcx2eaghSgTWJutkN1KHrMyCS2MTZF8w+CnQsyL/+iEt29Ox5JCZK7t4u3TqxxKnfhmE4CuCZuOgGslmL6UlXlvXHBZMB8rF8GHjoNx5OiR7EQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by CY8PR12MB7514.namprd12.prod.outlook.com (2603:10b6:930:92::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.46; Wed, 8 May
 2024 18:57:25 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%3]) with mapi id 15.20.7544.045; Wed, 8 May 2024
 18:57:25 +0000
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
Subject: [PATCH v7 10/14] iommu/arm-smmu-v3: Put the SVA mmu notifier in the smmu_domain
Date: Wed,  8 May 2024 15:57:18 -0300
Message-ID: <10-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
In-Reply-To: <0-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR03CA0025.namprd03.prod.outlook.com
 (2603:10b6:208:2d::38) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|CY8PR12MB7514:EE_
X-MS-Office365-Filtering-Correlation-Id: fee9ea69-3209-45f3-c58b-08dc6f90b29d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|7416005|1800799015|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?SFNUhcurUMcSTaMI3tJGiO4cjT+aUldiamWQUN+ePOpjjk6YjvIgyRH/3S4C?=
 =?us-ascii?Q?gGR5sNVxsfDdfWf2q80FE324AFd7GcT3GCoF6nbLO3z3Vpf/t3qzR6I80CLR?=
 =?us-ascii?Q?WC8lJixgF5DB+enxmBPLaGOW8LBpM2DGvetfeZl2oTzM1GO1ymYU5GzoSst8?=
 =?us-ascii?Q?zD+pJJJaEZwakQL9D4dLV9g6lbE0/ai5+VG/Q+tWtLGEekp0tqnE0LRZ1bkz?=
 =?us-ascii?Q?+4BQ3We0dAyvNyhUhfcfpuaTOQ/KSueB+KooALAAclBFfwic732cFf3NIsFy?=
 =?us-ascii?Q?GhNE/nBm4zYE+B0z3kNMcdYotmGLlnZUOop+lL4NrX68vgER1PFeMiO7PUrr?=
 =?us-ascii?Q?n8VYLsbsOu5UXdd6VdPflTX85msJd3OGzJDPDzGK9TcPysJ+ovfGVNHiaNEG?=
 =?us-ascii?Q?s3wppoQZTLeKpEyXWEB/VA67byFBgPth6UNCoJZT2VxcMl1yUSHW0QFb6iyI?=
 =?us-ascii?Q?KAh2miZp0tWGeDxtI6VE5CVZtxJ6jcWmfiaZsu4R9CQC5uy7I3UWb+laDNUe?=
 =?us-ascii?Q?GaccnTGoguCOQe0YYWRdj7y24WcIZa8wrC+b/UGMSlV78cgV2nN/0IG1Shjl?=
 =?us-ascii?Q?r8uq3jgAwRHAyH7OveSiGsT91FPIIwKyj4JX1pmbSXal7JG+5dUEyjKAUGf0?=
 =?us-ascii?Q?iFyoNotrWdkngQfQLD+VuGbXUuRwR3dP10y5KmWm2cwPf/bpgeHEMHmww/76?=
 =?us-ascii?Q?wune6EwoduxP7T2FLxyQk1kNhz1e1TNyz3YrYPcjw//qddxOJpzONOcA0pNH?=
 =?us-ascii?Q?dXghZWVYsCmBu7pV0l4TgKBQZwi3cL6LlykG4e2JHyZIAwl4dzTIZX+SsYlx?=
 =?us-ascii?Q?wbLJXaMI7Ed2nx56OfMDd6GEng5A5/7/0oyV4E24N7AbUifxTz4TExT8UNKh?=
 =?us-ascii?Q?wgZAWH9BtfD2ifP7GLNYaFymj0N2CDL4uxaYe3lmrY94FR5/VycdREhX6n+e?=
 =?us-ascii?Q?mHDtVgg4duqZfMbLR2hV8wq1FDFsNF3+2fMlBVhy2svemd9odo5Cgg2LT8Lm?=
 =?us-ascii?Q?GwvmGNx+5yW7TjQV8yDsR02Dt5/AuQzSk9FlFONZQx7PNhP+X8gLGjzvYv+j?=
 =?us-ascii?Q?qSaOFXb01thUJdX3PCAJOAhzR7E/YA9cMkmCGHBHxJa83BI4mGEe9GNXJIom?=
 =?us-ascii?Q?PN6qTo5qTNBUBJH6q1FqHI/wml2P3SYggGWVjbP7VFVF2XFQ9jMa5XfGn7gZ?=
 =?us-ascii?Q?ctHREB8AgxtL7m9001jVwIi8sOnA7zn5vv0aCdCmKbR6VOjX/UkenFMV/VOV?=
 =?us-ascii?Q?HIbX6RagV+b7A1/793q/7z0vcnPNvq3e6Onk04yh52Utr64AOQnQyKLHRrpq?=
 =?us-ascii?Q?4Mc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?q5ycyDKC0a000ZV66vy13T7JNpsb3g1RVmtpfBaZQUu9hFkl9U5fRMNVXGVz?=
 =?us-ascii?Q?cDF4aBcCYeCd00lIjwFeGDIl1TRiftkzsZxT7HRjIMJa1l+0+jLdcof5KpNa?=
 =?us-ascii?Q?xW5ekm9otmJOWvfm0f9opRpMnLeEurdyEC0w3fYofRLf9Nd2/TBO5WVz5YU7?=
 =?us-ascii?Q?lO0k61RAYglYjNdCyorLgTlgyg80GQvkgCQrrdzD9V0+qbbRM/0RauSXJwcQ?=
 =?us-ascii?Q?jAQJxiCU+FDQInXLyxch9IWiswOYdfY4Fsdp/WC2xrY9aEgWCMuCUgkLPIF0?=
 =?us-ascii?Q?9cMgy8lUlwtjjZmATZ44Ig+frgZDw+jwWdE/CEOuB8DVQedElCyfoqmdKK2H?=
 =?us-ascii?Q?2Hz6/RyUVrbMhnK7GoZiH9kqApQrqB5Mlb2FWUwMr1l+3oeVvxri+qmUL8P6?=
 =?us-ascii?Q?cmE3l/hFYFI+oybi9pPCknh85a1K9RjOYdkp2LGNvzfFaDZn2FUM0+6ud0sE?=
 =?us-ascii?Q?Y9TviVwOawrXqtjTlXpl0GBDMxnJQWSut8cXtfzX/MvOZUxCKKhB318YAb4w?=
 =?us-ascii?Q?irI+lJxMuq5ZTLciZ6NVJghCrbP4a9bcd4uAat7ZU18mEMrGKbKckeVw4+1G?=
 =?us-ascii?Q?+/WmbpXoKAOhWwIrgYg5Mo7tqE94/cZDm3uYHAU0EmszOKV8UgJ24Foq6yAe?=
 =?us-ascii?Q?07gKHMDbEAtmE/byHY06erlp+CqkxWFjZPeZUjPx1dWD2duz4RtgiISHD/lZ?=
 =?us-ascii?Q?KtwstjNGsUfz6OkSgCuU5P5/XpRbNjoaVK5tKDav38HXMqeC+G4INRQQHxBQ?=
 =?us-ascii?Q?OmiGgqVHohR8mo/+3bFHABisbEgiZY0bS+LwVUMq+Q+LlvxuC2fzT6xK9IKR?=
 =?us-ascii?Q?6NvK+uQTiK/2hJKs0AHR/8VOFRHAA6zb4Tj7WxxT+47UaOR3+Ff8DpP9mb+2?=
 =?us-ascii?Q?0ken19OSWvkNW8D8NG6qIWJVaNnSvbt5VQw+dEquL9YNtt1YLxK6eybhSVIW?=
 =?us-ascii?Q?KxuAIcmzpU9rOXOPSq2ULMfvxHbUY1thazgHGC4icKqbaifr4ejc5emRZWJA?=
 =?us-ascii?Q?xZsy9apIqwB0XOGSFk+RDhyoPmUZvmhC5qwRoyv4m3sFj6Aup01YR20J2SUj?=
 =?us-ascii?Q?936gjx8geSn3dlFUAWQUFA2MmUhIL8tQF8SmVvxsJ8t8WVmk/hUVy9FCSUt8?=
 =?us-ascii?Q?A528FOSPPmtT48ynflY8wMaH7fBJsiingCr2wpiMHUOTqwwd3QFIaNjzHtQP?=
 =?us-ascii?Q?vc/IRjISvTQ5oL5WHRC7KJNksbD56dBr4vkWG1RMYhqG+Y1k2MPmY5KsOdpe?=
 =?us-ascii?Q?wxpA1Pn/r+iLS1krAIcdOyo0Azeg+JXw9wwXhtDtI8ZTx9F70iot5kUXJXbE?=
 =?us-ascii?Q?MZcX+lNE1OVUAmWXu1fsPp6n8BFzSzzZNLePJ2bdsm5FoT46CAROrC5Ej41n?=
 =?us-ascii?Q?HYER7QhSTTB9ztnKj/BTwALnbIXQrtqLtbwHmSUp3mkrWDT41IV3I9kGZhKT?=
 =?us-ascii?Q?PNoQUwDGTbAZNnZWzshd+Zg+pm/pKuc+qa0nl8iLdJ3+xws6x+4G6RyN+34j?=
 =?us-ascii?Q?//fwUJtLLQA18q1Z8pkqW9GZY4g0gYKSk2i17YTM1UTm9Uz1xIMF8BetgVw0?=
 =?us-ascii?Q?AR6bTOar0D9fsY2P0zUNc7TEWmoSbo/VcGO/HRxo?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fee9ea69-3209-45f3-c58b-08dc6f90b29d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2024 18:57:24.5328
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2J4lWlhyGUBS0vkcg0js05Be7oTss/JZJ3E36gIpBvSmn0INX7+KeSHz9AhGl3Vj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7514

This removes all the notifier de-duplication logic in the driver and
relies on the core code to de-duplicate and allocate only one SVA domain
per mm per smmu instance. This naturally gives a 1:1 relationship between
SVA domain and mmu notifier.

It is a significant simplication of the flow, as we end up with a single
struct arm_smmu_domain for each MM and the invalidation can then be
shifted to properly use the masters list like S1/S2 do.

Remove all of the previous mmu_notifier, bond, shared cd, and cd refcount
logic entirely.

The logic here is tightly wound together with the unusued BTM
support. Since the BTM logic requires holding all the iommu_domains in a
global ASID xarray it conflicts with the design to have a single SVA
domain per PASID, as multiple SMMU instances will need to have different
domains.

Following patches resolve this by making the ASID xarray per-instance
instead of global. However, converting the BTM code over to this
methodology requires many changes.

Thus, since ARM_SMMU_FEAT_BTM is never enabled, remove the parts of the
BTM support for ASID sharing that interact with SVA as well.

A followup series is already working on fully enabling the BTM support,
that requires iommufd's VIOMMU feature to bring in the KVM's VMID as
well. It will come with an already written patch to bring back the ASID
sharing using a per-instance ASID xarray.

https://lore.kernel.org/linux-iommu/20240208151837.35068-1-shameerali.kolothum.thodi@huawei.com/
https://lore.kernel.org/linux-iommu/26-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com/

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 398 ++++--------------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  69 +--
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  13 +-
 3 files changed, 89 insertions(+), 391 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 39ba6766513457..56871c67ba369a 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -13,29 +13,9 @@
 #include "arm-smmu-v3.h"
 #include "../../io-pgtable-arm.h"
 
-struct arm_smmu_mmu_notifier {
-	struct mmu_notifier		mn;
-	struct arm_smmu_ctx_desc	*cd;
-	bool				cleared;
-	refcount_t			refs;
-	struct list_head		list;
-	struct arm_smmu_domain		*domain;
-};
-
-#define mn_to_smmu(mn) container_of(mn, struct arm_smmu_mmu_notifier, mn)
-
-struct arm_smmu_bond {
-	struct mm_struct		*mm;
-	struct arm_smmu_mmu_notifier	*smmu_mn;
-	struct list_head		list;
-};
-
-#define sva_to_bond(handle) \
-	container_of(handle, struct arm_smmu_bond, sva)
-
 static DEFINE_MUTEX(sva_lock);
 
-static void
+static void __maybe_unused
 arm_smmu_update_s1_domain_cd_entry(struct arm_smmu_domain *smmu_domain)
 {
 	struct arm_smmu_master_domain *master_domain;
@@ -58,58 +38,6 @@ arm_smmu_update_s1_domain_cd_entry(struct arm_smmu_domain *smmu_domain)
 	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
 }
 
-/*
- * Check if the CPU ASID is available on the SMMU side. If a private context
- * descriptor is using it, try to replace it.
- */
-static struct arm_smmu_ctx_desc *
-arm_smmu_share_asid(struct mm_struct *mm, u16 asid)
-{
-	int ret;
-	u32 new_asid;
-	struct arm_smmu_ctx_desc *cd;
-	struct arm_smmu_device *smmu;
-	struct arm_smmu_domain *smmu_domain;
-
-	cd = xa_load(&arm_smmu_asid_xa, asid);
-	if (!cd)
-		return NULL;
-
-	if (cd->mm) {
-		if (WARN_ON(cd->mm != mm))
-			return ERR_PTR(-EINVAL);
-		/* All devices bound to this mm use the same cd struct. */
-		refcount_inc(&cd->refs);
-		return cd;
-	}
-
-	smmu_domain = container_of(cd, struct arm_smmu_domain, cd);
-	smmu = smmu_domain->smmu;
-
-	ret = xa_alloc(&arm_smmu_asid_xa, &new_asid, cd,
-		       XA_LIMIT(1, (1 << smmu->asid_bits) - 1), GFP_KERNEL);
-	if (ret)
-		return ERR_PTR(-ENOSPC);
-	/*
-	 * Race with unmap: TLB invalidations will start targeting the new ASID,
-	 * which isn't assigned yet. We'll do an invalidate-all on the old ASID
-	 * later, so it doesn't matter.
-	 */
-	cd->asid = new_asid;
-	/*
-	 * Update ASID and invalidate CD in all associated masters. There will
-	 * be some overlap between use of both ASIDs, until we invalidate the
-	 * TLB.
-	 */
-	arm_smmu_update_s1_domain_cd_entry(smmu_domain);
-
-	/* Invalidate TLB entries previously associated with that context */
-	arm_smmu_tlb_inv_asid(smmu, asid);
-
-	xa_erase(&arm_smmu_asid_xa, asid);
-	return NULL;
-}
-
 static u64 page_size_to_cd(void)
 {
 	static_assert(PAGE_SIZE == SZ_4K || PAGE_SIZE == SZ_16K ||
@@ -187,69 +115,6 @@ void arm_smmu_make_sva_cd(struct arm_smmu_cd *target,
 }
 EXPORT_SYMBOL_IF_KUNIT(arm_smmu_make_sva_cd);
 
-static struct arm_smmu_ctx_desc *arm_smmu_alloc_shared_cd(struct mm_struct *mm)
-{
-	u16 asid;
-	int err = 0;
-	struct arm_smmu_ctx_desc *cd;
-	struct arm_smmu_ctx_desc *ret = NULL;
-
-	/* Don't free the mm until we release the ASID */
-	mmgrab(mm);
-
-	asid = arm64_mm_context_get(mm);
-	if (!asid) {
-		err = -ESRCH;
-		goto out_drop_mm;
-	}
-
-	cd = kzalloc(sizeof(*cd), GFP_KERNEL);
-	if (!cd) {
-		err = -ENOMEM;
-		goto out_put_context;
-	}
-
-	refcount_set(&cd->refs, 1);
-
-	mutex_lock(&arm_smmu_asid_lock);
-	ret = arm_smmu_share_asid(mm, asid);
-	if (ret) {
-		mutex_unlock(&arm_smmu_asid_lock);
-		goto out_free_cd;
-	}
-
-	err = xa_insert(&arm_smmu_asid_xa, asid, cd, GFP_KERNEL);
-	mutex_unlock(&arm_smmu_asid_lock);
-
-	if (err)
-		goto out_free_asid;
-
-	cd->asid = asid;
-	cd->mm = mm;
-
-	return cd;
-
-out_free_asid:
-	arm_smmu_free_asid(cd);
-out_free_cd:
-	kfree(cd);
-out_put_context:
-	arm64_mm_context_put(mm);
-out_drop_mm:
-	mmdrop(mm);
-	return err < 0 ? ERR_PTR(err) : ret;
-}
-
-static void arm_smmu_free_shared_cd(struct arm_smmu_ctx_desc *cd)
-{
-	if (arm_smmu_free_asid(cd)) {
-		/* Unpin ASID */
-		arm64_mm_context_put(cd->mm);
-		mmdrop(cd->mm);
-		kfree(cd);
-	}
-}
-
 /*
  * Cloned from the MAX_TLBI_OPS in arch/arm64/include/asm/tlbflush.h, this
  * is used as a threshold to replace per-page TLBI commands to issue in the
@@ -264,8 +129,8 @@ static void arm_smmu_mm_arch_invalidate_secondary_tlbs(struct mmu_notifier *mn,
 						unsigned long start,
 						unsigned long end)
 {
-	struct arm_smmu_mmu_notifier *smmu_mn = mn_to_smmu(mn);
-	struct arm_smmu_domain *smmu_domain = smmu_mn->domain;
+	struct arm_smmu_domain *smmu_domain =
+		container_of(mn, struct arm_smmu_domain, mmu_notifier);
 	size_t size;
 
 	/*
@@ -282,34 +147,22 @@ static void arm_smmu_mm_arch_invalidate_secondary_tlbs(struct mmu_notifier *mn,
 			size = 0;
 	}
 
-	if (!(smmu_domain->smmu->features & ARM_SMMU_FEAT_BTM)) {
-		if (!size)
-			arm_smmu_tlb_inv_asid(smmu_domain->smmu,
-					      smmu_mn->cd->asid);
-		else
-			arm_smmu_tlb_inv_range_asid(start, size,
-						    smmu_mn->cd->asid,
-						    PAGE_SIZE, false,
-						    smmu_domain);
-	}
+	if (!size)
+		arm_smmu_tlb_inv_asid(smmu_domain->smmu, smmu_domain->cd.asid);
+	else
+		arm_smmu_tlb_inv_range_asid(start, size, smmu_domain->cd.asid,
+					    PAGE_SIZE, false, smmu_domain);
 
-	arm_smmu_atc_inv_domain_sva(smmu_domain, mm_get_enqcmd_pasid(mm), start,
-				    size);
+	arm_smmu_atc_inv_domain(smmu_domain, start, size);
 }
 
 static void arm_smmu_mm_release(struct mmu_notifier *mn, struct mm_struct *mm)
 {
-	struct arm_smmu_mmu_notifier *smmu_mn = mn_to_smmu(mn);
-	struct arm_smmu_domain *smmu_domain = smmu_mn->domain;
+	struct arm_smmu_domain *smmu_domain =
+		container_of(mn, struct arm_smmu_domain, mmu_notifier);
 	struct arm_smmu_master_domain *master_domain;
 	unsigned long flags;
 
-	mutex_lock(&sva_lock);
-	if (smmu_mn->cleared) {
-		mutex_unlock(&sva_lock);
-		return;
-	}
-
 	/*
 	 * DMA may still be running. Keep the cd valid to avoid C_BAD_CD events,
 	 * but disable translation.
@@ -321,25 +174,26 @@ static void arm_smmu_mm_release(struct mmu_notifier *mn, struct mm_struct *mm)
 		struct arm_smmu_cd target;
 		struct arm_smmu_cd *cdptr;
 
-		cdptr = arm_smmu_get_cd_ptr(master, mm_get_enqcmd_pasid(mm));
+		cdptr = arm_smmu_get_cd_ptr(master, master_domain->ssid);
 		if (WARN_ON(!cdptr))
 			continue;
-		arm_smmu_make_sva_cd(&target, master, NULL, smmu_mn->cd->asid);
-		arm_smmu_write_cd_entry(master, mm_get_enqcmd_pasid(mm), cdptr,
+		arm_smmu_make_sva_cd(&target, master, NULL,
+				     smmu_domain->cd.asid);
+		arm_smmu_write_cd_entry(master, master_domain->ssid, cdptr,
 					&target);
 	}
 	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
 
-	arm_smmu_tlb_inv_asid(smmu_domain->smmu, smmu_mn->cd->asid);
-	arm_smmu_atc_inv_domain_sva(smmu_domain, mm_get_enqcmd_pasid(mm), 0, 0);
-
-	smmu_mn->cleared = true;
-	mutex_unlock(&sva_lock);
+	arm_smmu_tlb_inv_asid(smmu_domain->smmu, smmu_domain->cd.asid);
+	arm_smmu_atc_inv_domain(smmu_domain, 0, 0);
 }
 
 static void arm_smmu_mmu_notifier_free(struct mmu_notifier *mn)
 {
-	kfree(mn_to_smmu(mn));
+	struct arm_smmu_domain *smmu_domain =
+		container_of(mn, struct arm_smmu_domain, mmu_notifier);
+
+	kfree(smmu_domain);
 }
 
 static const struct mmu_notifier_ops arm_smmu_mmu_notifier_ops = {
@@ -348,115 +202,6 @@ static const struct mmu_notifier_ops arm_smmu_mmu_notifier_ops = {
 	.free_notifier			= arm_smmu_mmu_notifier_free,
 };
 
-/* Allocate or get existing MMU notifier for this {domain, mm} pair */
-static struct arm_smmu_mmu_notifier *
-arm_smmu_mmu_notifier_get(struct arm_smmu_domain *smmu_domain,
-			  struct mm_struct *mm)
-{
-	int ret;
-	struct arm_smmu_ctx_desc *cd;
-	struct arm_smmu_mmu_notifier *smmu_mn;
-
-	list_for_each_entry(smmu_mn, &smmu_domain->mmu_notifiers, list) {
-		if (smmu_mn->mn.mm == mm) {
-			refcount_inc(&smmu_mn->refs);
-			return smmu_mn;
-		}
-	}
-
-	cd = arm_smmu_alloc_shared_cd(mm);
-	if (IS_ERR(cd))
-		return ERR_CAST(cd);
-
-	smmu_mn = kzalloc(sizeof(*smmu_mn), GFP_KERNEL);
-	if (!smmu_mn) {
-		ret = -ENOMEM;
-		goto err_free_cd;
-	}
-
-	refcount_set(&smmu_mn->refs, 1);
-	smmu_mn->cd = cd;
-	smmu_mn->domain = smmu_domain;
-	smmu_mn->mn.ops = &arm_smmu_mmu_notifier_ops;
-
-	ret = mmu_notifier_register(&smmu_mn->mn, mm);
-	if (ret) {
-		kfree(smmu_mn);
-		goto err_free_cd;
-	}
-
-	list_add(&smmu_mn->list, &smmu_domain->mmu_notifiers);
-	return smmu_mn;
-
-err_free_cd:
-	arm_smmu_free_shared_cd(cd);
-	return ERR_PTR(ret);
-}
-
-static void arm_smmu_mmu_notifier_put(struct arm_smmu_mmu_notifier *smmu_mn)
-{
-	struct mm_struct *mm = smmu_mn->mn.mm;
-	struct arm_smmu_ctx_desc *cd = smmu_mn->cd;
-	struct arm_smmu_domain *smmu_domain = smmu_mn->domain;
-
-	if (!refcount_dec_and_test(&smmu_mn->refs))
-		return;
-
-	list_del(&smmu_mn->list);
-
-	/*
-	 * If we went through clear(), we've already invalidated, and no
-	 * new TLB entry can have been formed.
-	 */
-	if (!smmu_mn->cleared) {
-		arm_smmu_tlb_inv_asid(smmu_domain->smmu, cd->asid);
-		arm_smmu_atc_inv_domain_sva(smmu_domain,
-					    mm_get_enqcmd_pasid(mm), 0, 0);
-	}
-
-	/* Frees smmu_mn */
-	mmu_notifier_put(&smmu_mn->mn);
-	arm_smmu_free_shared_cd(cd);
-}
-
-static struct arm_smmu_bond *__arm_smmu_sva_bind(struct device *dev,
-						 struct mm_struct *mm)
-{
-	int ret;
-	struct arm_smmu_bond *bond;
-	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
-	struct iommu_domain *domain = iommu_get_domain_for_dev(dev);
-	struct arm_smmu_domain *smmu_domain;
-
-	if (!(domain->type & __IOMMU_DOMAIN_PAGING))
-		return ERR_PTR(-ENODEV);
-	smmu_domain = to_smmu_domain(domain);
-	if (smmu_domain->stage != ARM_SMMU_DOMAIN_S1)
-		return ERR_PTR(-ENODEV);
-
-	if (!master || !master->sva_enabled)
-		return ERR_PTR(-ENODEV);
-
-	bond = kzalloc(sizeof(*bond), GFP_KERNEL);
-	if (!bond)
-		return ERR_PTR(-ENOMEM);
-
-	bond->mm = mm;
-
-	bond->smmu_mn = arm_smmu_mmu_notifier_get(smmu_domain, mm);
-	if (IS_ERR(bond->smmu_mn)) {
-		ret = PTR_ERR(bond->smmu_mn);
-		goto err_free_bond;
-	}
-
-	list_add(&bond->list, &master->bonds);
-	return bond;
-
-err_free_bond:
-	kfree(bond);
-	return ERR_PTR(ret);
-}
-
 bool arm_smmu_sva_supported(struct arm_smmu_device *smmu)
 {
 	unsigned long reg, fld;
@@ -573,11 +318,6 @@ int arm_smmu_master_enable_sva(struct arm_smmu_master *master)
 int arm_smmu_master_disable_sva(struct arm_smmu_master *master)
 {
 	mutex_lock(&sva_lock);
-	if (!list_empty(&master->bonds)) {
-		dev_err(master->dev, "cannot disable SVA, device is bound\n");
-		mutex_unlock(&sva_lock);
-		return -EBUSY;
-	}
 	arm_smmu_master_sva_disable_iopf(master);
 	master->sva_enabled = false;
 	mutex_unlock(&sva_lock);
@@ -594,66 +334,51 @@ void arm_smmu_sva_notifier_synchronize(void)
 	mmu_notifier_synchronize();
 }
 
-void arm_smmu_sva_remove_dev_pasid(struct iommu_domain *domain,
-				   struct device *dev, ioasid_t id)
-{
-	struct mm_struct *mm = domain->mm;
-	struct arm_smmu_bond *bond = NULL, *t;
-	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
-
-	arm_smmu_remove_pasid(master, to_smmu_domain(domain), id);
-
-	mutex_lock(&sva_lock);
-	list_for_each_entry(t, &master->bonds, list) {
-		if (t->mm == mm) {
-			bond = t;
-			break;
-		}
-	}
-
-	if (!WARN_ON(!bond)) {
-		list_del(&bond->list);
-		arm_smmu_mmu_notifier_put(bond->smmu_mn);
-		kfree(bond);
-	}
-	mutex_unlock(&sva_lock);
-}
-
 static int arm_smmu_sva_set_dev_pasid(struct iommu_domain *domain,
 				      struct device *dev, ioasid_t id)
 {
+	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
-	struct mm_struct *mm = domain->mm;
-	struct arm_smmu_bond *bond;
 	struct arm_smmu_cd target;
 	int ret;
 
-	if (mm_get_enqcmd_pasid(mm) != id || !master->cd_table.in_ste)
+	/* Prevent arm_smmu_mm_release from being called while we are attaching */
+	if (!mmget_not_zero(domain->mm))
 		return -EINVAL;
 
-	mutex_lock(&sva_lock);
-	bond = __arm_smmu_sva_bind(dev, mm);
-	if (IS_ERR(bond)) {
-		mutex_unlock(&sva_lock);
-		return PTR_ERR(bond);
-	}
+	/*
+	 * This does not need the arm_smmu_asid_lock because SVA domains never
+	 * get reassigned
+	 */
+	arm_smmu_make_sva_cd(&target, master, domain->mm, smmu_domain->cd.asid);
+	ret = arm_smmu_set_pasid(master, smmu_domain, id, &target);
 
-	arm_smmu_make_sva_cd(&target, master, mm, bond->smmu_mn->cd->asid);
-	ret = arm_smmu_set_pasid(master, to_smmu_domain(domain), id, &target);
-	if (ret) {
-		list_del(&bond->list);
-		arm_smmu_mmu_notifier_put(bond->smmu_mn);
-		kfree(bond);
-		mutex_unlock(&sva_lock);
-		return ret;
-	}
-	mutex_unlock(&sva_lock);
-	return 0;
+	mmput(domain->mm);
+	return ret;
 }
 
 static void arm_smmu_sva_domain_free(struct iommu_domain *domain)
 {
-	kfree(to_smmu_domain(domain));
+	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
+
+	/*
+	 * Ensure the ASID is empty in the iommu cache before allowing reuse.
+	 */
+	arm_smmu_tlb_inv_asid(smmu_domain->smmu, smmu_domain->cd.asid);
+
+	/*
+	 * Notice that the arm_smmu_mm_arch_invalidate_secondary_tlbs op can
+	 * still be called/running at this point. We allow the ASID to be
+	 * reused, and if there is a race then it just suffers harmless
+	 * unnecessary invalidation.
+	 */
+	xa_erase(&arm_smmu_asid_xa, smmu_domain->cd.asid);
+
+	/*
+	 * Actual free is defered to the SRCU callback
+	 * arm_smmu_mmu_notifier_free()
+	 */
+	mmu_notifier_put(&smmu_domain->mmu_notifier);
 }
 
 static const struct iommu_domain_ops arm_smmu_sva_domain_ops = {
@@ -667,6 +392,8 @@ struct iommu_domain *arm_smmu_sva_domain_alloc(struct device *dev,
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
 	struct arm_smmu_device *smmu = master->smmu;
 	struct arm_smmu_domain *smmu_domain;
+	u32 asid;
+	int ret;
 
 	smmu_domain = arm_smmu_domain_alloc();
 	if (IS_ERR(smmu_domain))
@@ -675,5 +402,22 @@ struct iommu_domain *arm_smmu_sva_domain_alloc(struct device *dev,
 	smmu_domain->domain.ops = &arm_smmu_sva_domain_ops;
 	smmu_domain->smmu = smmu;
 
+	ret = xa_alloc(&arm_smmu_asid_xa, &asid, smmu_domain,
+		       XA_LIMIT(1, (1 << smmu->asid_bits) - 1), GFP_KERNEL);
+	if (ret)
+		goto err_free;
+
+	smmu_domain->cd.asid = asid;
+	smmu_domain->mmu_notifier.ops = &arm_smmu_mmu_notifier_ops;
+	ret = mmu_notifier_register(&smmu_domain->mmu_notifier, mm);
+	if (ret)
+		goto err_asid;
+
 	return &smmu_domain->domain;
+
+err_asid:
+	xa_erase(&arm_smmu_asid_xa, smmu_domain->cd.asid);
+err_free:
+	kfree(smmu_domain);
+	return ERR_PTR(ret);
 }
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 020e4efdf8fc06..15378c131a5bc7 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1439,22 +1439,6 @@ static void arm_smmu_free_cd_tables(struct arm_smmu_master *master)
 	cd_table->cdtab = NULL;
 }
 
-bool arm_smmu_free_asid(struct arm_smmu_ctx_desc *cd)
-{
-	bool free;
-	struct arm_smmu_ctx_desc *old_cd;
-
-	if (!cd->asid)
-		return false;
-
-	free = refcount_dec_and_test(&cd->refs);
-	if (free) {
-		old_cd = xa_erase(&arm_smmu_asid_xa, cd->asid);
-		WARN_ON(old_cd != cd);
-	}
-	return free;
-}
-
 /* Stream table manipulation functions */
 static void
 arm_smmu_write_strtab_l1_desc(__le64 *dst, struct arm_smmu_strtab_l1_desc *desc)
@@ -2023,8 +2007,8 @@ static int arm_smmu_atc_inv_master(struct arm_smmu_master *master,
 	return arm_smmu_cmdq_batch_submit(master->smmu, &cmds);
 }
 
-static int __arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain,
-				     ioasid_t ssid, unsigned long iova, size_t size)
+int arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain,
+			    unsigned long iova, size_t size)
 {
 	struct arm_smmu_master_domain *master_domain;
 	int i;
@@ -2062,15 +2046,7 @@ static int __arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain,
 		if (!master->ats_enabled)
 			continue;
 
-		/*
-		 * Non-zero ssid means SVA is co-opting the S1 domain to issue
-		 * invalidations for SVA PASIDs.
-		 */
-		if (ssid != IOMMU_NO_PASID)
-			arm_smmu_atc_inv_to_cmd(ssid, iova, size, &cmd);
-		else
-			arm_smmu_atc_inv_to_cmd(master_domain->ssid, iova, size,
-						&cmd);
+		arm_smmu_atc_inv_to_cmd(master_domain->ssid, iova, size, &cmd);
 
 		for (i = 0; i < master->num_streams; i++) {
 			cmd.atc.sid = master->streams[i].id;
@@ -2082,19 +2058,6 @@ static int __arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain,
 	return arm_smmu_cmdq_batch_submit(smmu_domain->smmu, &cmds);
 }
 
-static int arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain,
-				   unsigned long iova, size_t size)
-{
-	return __arm_smmu_atc_inv_domain(smmu_domain, IOMMU_NO_PASID, iova,
-					 size);
-}
-
-int arm_smmu_atc_inv_domain_sva(struct arm_smmu_domain *smmu_domain,
-				ioasid_t ssid, unsigned long iova, size_t size)
-{
-	return __arm_smmu_atc_inv_domain(smmu_domain, ssid, iova, size);
-}
-
 /* IO_PGTABLE API */
 static void arm_smmu_tlb_inv_context(void *cookie)
 {
@@ -2283,7 +2246,6 @@ struct arm_smmu_domain *arm_smmu_domain_alloc(void)
 	mutex_init(&smmu_domain->init_mutex);
 	INIT_LIST_HEAD(&smmu_domain->devices);
 	spin_lock_init(&smmu_domain->devices_lock);
-	INIT_LIST_HEAD(&smmu_domain->mmu_notifiers);
 
 	return smmu_domain;
 }
@@ -2325,7 +2287,7 @@ static void arm_smmu_domain_free_paging(struct iommu_domain *domain)
 	if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
 		/* Prevent SVA from touching the CD while we're freeing it */
 		mutex_lock(&arm_smmu_asid_lock);
-		arm_smmu_free_asid(&smmu_domain->cd);
+		xa_erase(&arm_smmu_asid_xa, smmu_domain->cd.asid);
 		mutex_unlock(&arm_smmu_asid_lock);
 	} else {
 		struct arm_smmu_s2_cfg *cfg = &smmu_domain->s2_cfg;
@@ -2343,11 +2305,9 @@ static int arm_smmu_domain_finalise_s1(struct arm_smmu_device *smmu,
 	u32 asid;
 	struct arm_smmu_ctx_desc *cd = &smmu_domain->cd;
 
-	refcount_set(&cd->refs, 1);
-
 	/* Prevent SVA from modifying the ASID until it is written to the CD */
 	mutex_lock(&arm_smmu_asid_lock);
-	ret = xa_alloc(&arm_smmu_asid_xa, &asid, cd,
+	ret = xa_alloc(&arm_smmu_asid_xa, &asid, smmu_domain,
 		       XA_LIMIT(1, (1 << smmu->asid_bits) - 1), GFP_KERNEL);
 	cd->asid	= (u16)asid;
 	mutex_unlock(&arm_smmu_asid_lock);
@@ -2806,6 +2766,9 @@ int arm_smmu_set_pasid(struct arm_smmu_master *master,
 
 	/* The core code validates pasid */
 
+	if (smmu_domain->smmu != master->smmu)
+		return -EINVAL;
+
 	if (!master->cd_table.in_ste)
 		return -ENODEV;
 
@@ -2827,9 +2790,14 @@ int arm_smmu_set_pasid(struct arm_smmu_master *master,
 	return ret;
 }
 
-void arm_smmu_remove_pasid(struct arm_smmu_master *master,
-			   struct arm_smmu_domain *smmu_domain, ioasid_t pasid)
+static void arm_smmu_remove_dev_pasid(struct device *dev, ioasid_t pasid,
+				      struct iommu_domain *domain)
 {
+	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
+	struct arm_smmu_domain *smmu_domain;
+
+	smmu_domain = to_smmu_domain(domain);
+
 	mutex_lock(&arm_smmu_asid_lock);
 	arm_smmu_clear_cd(master, pasid);
 	if (master->ats_enabled)
@@ -3107,7 +3075,6 @@ static struct iommu_device *arm_smmu_probe_device(struct device *dev)
 
 	master->dev = dev;
 	master->smmu = smmu;
-	INIT_LIST_HEAD(&master->bonds);
 	dev_iommu_priv_set(dev, master);
 
 	ret = arm_smmu_insert_master(smmu, master);
@@ -3289,12 +3256,6 @@ static int arm_smmu_def_domain_type(struct device *dev)
 	return 0;
 }
 
-static void arm_smmu_remove_dev_pasid(struct device *dev, ioasid_t pasid,
-				      struct iommu_domain *domain)
-{
-	arm_smmu_sva_remove_dev_pasid(domain, dev, pasid);
-}
-
 static struct iommu_ops arm_smmu_ops = {
 	.identity_domain	= &arm_smmu_identity_domain,
 	.blocked_domain		= &arm_smmu_blocked_domain,
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index a036610e50da14..100e6721e16131 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -587,9 +587,6 @@ struct arm_smmu_strtab_l1_desc {
 
 struct arm_smmu_ctx_desc {
 	u16				asid;
-
-	refcount_t			refs;
-	struct mm_struct		*mm;
 };
 
 struct arm_smmu_l1_ctx_desc {
@@ -712,7 +709,6 @@ struct arm_smmu_master {
 	bool				stall_enabled;
 	bool				sva_enabled;
 	bool				iopf_enabled;
-	struct list_head		bonds;
 	unsigned int			ssid_bits;
 };
 
@@ -741,7 +737,7 @@ struct arm_smmu_domain {
 	struct list_head		devices;
 	spinlock_t			devices_lock;
 
-	struct list_head		mmu_notifiers;
+	struct mmu_notifier		mmu_notifier;
 };
 
 /* The following are exposed for testing purposes. */
@@ -812,9 +808,8 @@ void arm_smmu_tlb_inv_asid(struct arm_smmu_device *smmu, u16 asid);
 void arm_smmu_tlb_inv_range_asid(unsigned long iova, size_t size, int asid,
 				 size_t granule, bool leaf,
 				 struct arm_smmu_domain *smmu_domain);
-bool arm_smmu_free_asid(struct arm_smmu_ctx_desc *cd);
-int arm_smmu_atc_inv_domain_sva(struct arm_smmu_domain *smmu_domain,
-				ioasid_t ssid, unsigned long iova, size_t size);
+int arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain,
+			    unsigned long iova, size_t size);
 
 #ifdef CONFIG_ARM_SMMU_V3_SVA
 bool arm_smmu_sva_supported(struct arm_smmu_device *smmu);
@@ -826,8 +821,6 @@ bool arm_smmu_master_iopf_supported(struct arm_smmu_master *master);
 void arm_smmu_sva_notifier_synchronize(void);
 struct iommu_domain *arm_smmu_sva_domain_alloc(struct device *dev,
 					       struct mm_struct *mm);
-void arm_smmu_sva_remove_dev_pasid(struct iommu_domain *domain,
-				   struct device *dev, ioasid_t id);
 #else /* CONFIG_ARM_SMMU_V3_SVA */
 static inline bool arm_smmu_sva_supported(struct arm_smmu_device *smmu)
 {
-- 
2.43.2

