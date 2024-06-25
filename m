Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2085.outbound.protection.outlook.com [40.107.243.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FFDD1553A7;
	Tue, 25 Jun 2024 12:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719319085; cv=fail; b=kD0eNo2iPVjyJx46DJ491YOChNhjFVOg9TTXuoyaFA2Qm8m93Oq3S/Qe2xoVNWNJvDVY+H16OKp+JsYSBG2Ls32Q2dfLVzrNqL7ll3W6e8onGvjWgvmxZDjISlkKVrgk85hnTs/B6C95K1d8+LD/HtAUEVc8IFeMsDKEPsUWuk4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719319085; c=relaxed/simple;
	bh=SToa0tmmcySP+I+Cbxg9OwvHjzJbrtmp97g6G3JwqzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tNda7ftrdQ0cA5c8eyADACzBt1M4QPfJ7KvVSTkrIVsuzlF6hrLlYFva9h4VLLH9bzBYQh7ItpV630IPKdORSCd0fcP9wOBdUG7qe2N7JyC+X9SOKxR5YHb7dHJF+jHSkrat6l/NbVJ8B5z2sk8AXUrB/eKMSuz4qHXzAcU/ZKE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=bKd7V+F3; arc=fail smtp.client-ip=40.107.243.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="bKd7V+F3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JhqsO1w8ZWgCG8tkWEHtypO1vZwNuimAlgMMwCUXzSojG9d8VT7OCpcZXtcWX/Pry8ddH0iBQaFN4+QTiJF3LFr4LBNQHd7v84fWpcFMgOkMPA3VYC8EdvzY6JlZ+Wx7bFqWPGfkvUo60VM6f1R2+NFphny3HYxyvIHXEMYY/47Yi9RhN9qRB0bo+ssDEASanyOlOyCTDQJEYIIrci6nQdi+Wvx3u2VqyxHUGC/GsCVRVvZaf6U9S1tuhbaqX/E1F0CXxYalEUG72ORpNHRZBz6rI71HEyGssqavOvhcZ9/mGCh71NZeYge9XD0pwIRCAWaRnX2FdclNsbAugJvZcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xAjflk7emW4D2Zs/4PQo41aWLZyg3vDkN8uWjeOGRYo=;
 b=TEW+7VKZAkpf+uIGU5jfneWgit/A6/8x6eDQ+BhFDrh9lfz26xJisUw7E2yLHFBmTBe8WnCHv40LMDdn8+vJNOVjySIGnjTmHdgQBTY7P0rNRnpQK12V+ORXQMdSpUfu/++XjeZD8Vj2zYlJozFKix1viIbydRPQzkn7nAPnnIppmLlUdL7pS3dZfgEwZqPueXhs0oYmFxwQJOMCctTIDTYbCu0/U8oppdqNWf5mg1gDChmzwcsp+F698G2D9LDiNqzSkRu6wx0Xg1oXOErcwPjuuFjedz3LlPBQ1yQVCXIAcQzdNB5ZJTqaDLoqx2p402WWLgU9zBZlVaYijv1Ylg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xAjflk7emW4D2Zs/4PQo41aWLZyg3vDkN8uWjeOGRYo=;
 b=bKd7V+F3LNywXJsBgQFeQ8PNgX+7DvsydJ/3KUPoBzi0YhR9AD+BRMLxvFGhjus/7SnqOjx2fu1or/g1fkjOFXgfrdteKZfn7JdwMExGgTktlS+RVYXplshGfquki65xtsstuM9pzsoYv+JBC4IEx+Lxs3TjRI1gJ4ZP7EVKa8DOXtNEMgOcZToUHXpK3EWC1mNZO22iJW9wjM0GfyiPXEVGNZsY6TNAdw+voajj0et9nuepHyTLbdVL1OMhvLUjMUH03STGBa7+yiRYQAN0nu/h3PSjRGbID1PrZIen5wjEbRLF+xdq6PGJ/vhT/AbisopuUXvr2pKJ2QrUBz316g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by SA1PR12MB8946.namprd12.prod.outlook.com (2603:10b6:806:375::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.26; Tue, 25 Jun
 2024 12:37:50 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%6]) with mapi id 15.20.7698.025; Tue, 25 Jun 2024
 12:37:49 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Jerry Snitselaar <jsnitsel@redhat.com>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH v9 10/14] iommu/arm-smmu-v3: Put the SVA mmu notifier in the smmu_domain
Date: Tue, 25 Jun 2024 09:37:41 -0300
Message-ID: <10-v9-5cd718286059+79186-smmuv3_newapi_p2b_jgg@nvidia.com>
In-Reply-To: <0-v9-5cd718286059+79186-smmuv3_newapi_p2b_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR13CA0001.namprd13.prod.outlook.com
 (2603:10b6:208:160::14) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|SA1PR12MB8946:EE_
X-MS-Office365-Filtering-Correlation-Id: 5559c07a-a011-47fd-f4ce-08dc95139e4f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|7416011|366013|1800799021|376011;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pPVCrhyip2Uh26VEyvnFtDUoUlkMAn605azhwDPx/QLeFK4bf9AE7QUtQ9mR?=
 =?us-ascii?Q?GPUN0c4xDls2qhzj/ElCFfiHBdw57QEDZqaJNYPFxevuPAGBkB+hxdPvyJdx?=
 =?us-ascii?Q?VNNfaFN9vYgPDBvxqG3bry9cwHYiEdN0ZlZ9QGo8xEvqbKMWAfz0PsT4Okwj?=
 =?us-ascii?Q?P9ocQ52yptpOkcjGIzvKjAlrl1J8gNFTFlEfuRppHsWXQXuYggKxnPvx/R8M?=
 =?us-ascii?Q?b19bjI00xI6M1qRIHt2rM1NmR5GerTKbECXCP4g/vUHZoRRxB6SUYjcRLlek?=
 =?us-ascii?Q?a3du2Zrwi7JSiYgPBvCRA3xmuSnkOk1NtKxN1cVcupsXSaAApxXx5ExV3MRY?=
 =?us-ascii?Q?qmPpZ9afoPjOvcIry9yzB++WG3wWUp5B691AZFlhNjndijW4B82LuS7iWrOc?=
 =?us-ascii?Q?AmBfR+wB4ZvpQzIy1rN4Qf/hXRRcgqKQQnttbg2wHGZAiB3rvA8O/DGdgeyk?=
 =?us-ascii?Q?+R+BfVbQjsKQDGmhRFDnvje5aWmbx8KllPFy8ACvAQA9MVgUrjKMjXrwIK0d?=
 =?us-ascii?Q?6Wb48Dq2tPmqS+ueTvvT2bA1Gj7+IojEOsC4HdIpfEXH1ZIaBfRWTlXDnV+p?=
 =?us-ascii?Q?LUODBjz4PVThpGr+Rb/XQ8wxe8zrRM5NU0UuJPP5wKHifJn3HkdeisZQGcFl?=
 =?us-ascii?Q?2UjaVWXapUOseqoeFVRUDtJnS83UGqoHcinbneGXdeKYbNFzjCFLXIQkcyJJ?=
 =?us-ascii?Q?kWX90rn7e/I5in8j3IMgHkxTU9GkSRritdXvPQzdvJ/tDlwBkFtdWygS2WT/?=
 =?us-ascii?Q?8FOtx66mUdm5OZMlA/xpwNDiZ9i7jGAAtyUkApom1B3cVYsrYJ2jyVkDT3Gz?=
 =?us-ascii?Q?ZVmB+ybGHZ9CzxqY3H1L/t40A/lZLWC9aYVdlxRqjyd5d/M8OFZf42mNjkaC?=
 =?us-ascii?Q?fMScnHls5dnF0aaEuSgmLxkZEhMpxfrAehwUE3/wPDKLf8mi5uWTDloKVOkz?=
 =?us-ascii?Q?A+WA3vKf5KM8pjw5n48CexXALUixXpW36Uwiak1mV5lu0GajzBT2ECAGS8xR?=
 =?us-ascii?Q?x7ZY8uE/EzS11KQqbI4vZnBoycjfNKzI6F5eQAdHPpr9sLQT/X4X8Vp5Da/Q?=
 =?us-ascii?Q?ifCHXRZjkNKqobRyla40AItDw+r3WGf+NRrGt+7s3NLF+IT/FeTcjTKNh2a6?=
 =?us-ascii?Q?sB8wb6ItIJwrUWZZqRYj4jP9uldMK3Y617iS1WqApG9iwL1VEzVhPLixbJXE?=
 =?us-ascii?Q?hyUErRabdw5vcii2KBBaaxASsjmlKhJ2eMtxMZRkObozpeBX93cU/eskIJTs?=
 =?us-ascii?Q?PpibPzRxeiNg9PUrD2Ufw6NryFfumJny987oK6LOZ/ndy76EHsOXxqfc1n91?=
 =?us-ascii?Q?1A5HjAsKGLj5fFkQDNUzJNm+?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(7416011)(366013)(1800799021)(376011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?agpDSL0Y6a3LCg0bfQ1j62oqvcJOBIowChIwjWIJ+XnaGTsZ2kT9Y0R2Iu68?=
 =?us-ascii?Q?KFR1B9sUAV8vSOBj3T9D3nu4LE91mvF6bbjdsNQEl4JTS4XCq/RTbnqrCb2r?=
 =?us-ascii?Q?FXxeZ7IcassEXUtHbg0l8wHO7207cO7xskKofpFJjI6dR9vFSqTVW07i2ipL?=
 =?us-ascii?Q?uj7h6ESstSB/VxQlIKBnm9+Nv+ttRH2lgZ0dY8Ft03N+gQyf7tQu9irZE3/7?=
 =?us-ascii?Q?kwYT8pshceJMsW/nNERMtvW2jAQUUUtq9RTsuacOlgnGJUM2K1OKvHeiVwHc?=
 =?us-ascii?Q?rS3M+U57GM7KK3zTfTydbA9gPZ+cSmtGV/2jbccmByFkk34HD5S3XLYbZfy/?=
 =?us-ascii?Q?Ugm/q6NbDlsCx/7hs8ZFH17Wh/cc/KbkpCyRw9IbvF6ElxC3/SMSPCrd7H8r?=
 =?us-ascii?Q?UCWe7TTHsk8211JYX/6hQh9+4lTi62475qL26gQ1vrQwEtFzFUdSmmgMjCqF?=
 =?us-ascii?Q?JHAL2R+KBxBRUnINn6mwft6P6Cl3v4/b/6fB7M2ReEGUEiSJdforYWiRZkQu?=
 =?us-ascii?Q?jFAevtSjUR6NYBD/ZsEu4Q78HPLpfWKlfdVuarZTRZuVgZ7OuTBwta5/Crft?=
 =?us-ascii?Q?pdJJ5gt9XfhzCVe2XkPOffl1LYw+y28nk/IlF7Mjpm8ZXoHhzGsYSsenedg0?=
 =?us-ascii?Q?eqi/2YwBFr2vz3uEQGnaVRUIbiIeNPloT9iHX506NrCmsszopQjjDFi1eyDt?=
 =?us-ascii?Q?O+lecebu7IQukVv2i/gf6UZd/CuiaouhQfY30+22xNuy8qQBzBMGjQ11oQIL?=
 =?us-ascii?Q?o5jOotBkAwqCaKZKluq1cCYJd9AYRXSHLP4gxvqWd5OZTYwXczIdu+YroC3q?=
 =?us-ascii?Q?gfogLkvOy52GH8Puef0vsY58PZGsrg1iktPcvl0AbhhUANFJgiQePvm+PSeM?=
 =?us-ascii?Q?S/8pc9q0WYU5b2pahy5zf8ljnpnNVJ/gSUHxBEc9WzSQUSIOcUMogllLqxX0?=
 =?us-ascii?Q?MGqtcz95sW7fjm35f+R3CrmklN/ADtZ18Ou3LJzkXmkcSrxJrNkzt+WOAkjc?=
 =?us-ascii?Q?umb8qghq4f2ogMkAnWHpgR2Rv2glSh+y1OiwctXhIvuBBAz/uX0sGL56jWWx?=
 =?us-ascii?Q?7eF33tQHu2EMCnk+eeiGNiVYYG1jTmHQBpkCTihwFnZPwMs4eK6KtH/5TAbK?=
 =?us-ascii?Q?AVjnsURlmaD8tWCe10sqdNn8frOlRb8Jyrtg5q+JrKEPukqfrgN6oNNFRq/+?=
 =?us-ascii?Q?pt1CXxxCZyu9ILaX6WjRaWvVwG0QDOfub09fM/U/ot9iV4jORCVdniRtfCW8?=
 =?us-ascii?Q?VoukUDnt1cRohtJLedAPCbU5elmfo4zgbeN/9WrCOoF9TALaG+rKC40KHNB/?=
 =?us-ascii?Q?JS9c3L5d1mZPEPpWDrd2cQogFg9vDKo/0ChkSFllgR+tn2oxKDUu8hKxahPV?=
 =?us-ascii?Q?ZAF2/W0fZF32Wv/9GGKIRnzkmW+MrZEwzNxrSomFmkId0WK1g46k1K0mNV2U?=
 =?us-ascii?Q?rChB0H7mI40zHGECzyXEM9Hpy5/Df+zHMe07LULqx63qQrswnSj+9dI0apW6?=
 =?us-ascii?Q?ykUWbJqgD9OVKGa/j2mEMdeWVVI5cJnWoobmu8lVobRxHx/Oum8PXZ9bgAZB?=
 =?us-ascii?Q?CJQOp1ODvmTw9DursdPv4RQPFqLVTcDazLjLGUSo?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5559c07a-a011-47fd-f4ce-08dc95139e4f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2024 12:37:47.4743
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lTpsjSk5GCdz/HnHLyfGBWZehfwwvEzfmLF2WFtNIx48/MOdKIlsOin+GxakbJqC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8946

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
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Michael Shavit <mshavit@google.com>
Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 395 +++---------------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  69 +--
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  15 +-
 3 files changed, 86 insertions(+), 393 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index aa033cd65adc5a..a7c36654dee5a5 100644
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
@@ -321,25 +174,23 @@ static void arm_smmu_mm_release(struct mmu_notifier *mn, struct mm_struct *mm)
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
+	kfree(container_of(mn, struct arm_smmu_domain, mmu_notifier));
 }
 
 static const struct mmu_notifier_ops arm_smmu_mmu_notifier_ops = {
@@ -348,115 +199,6 @@ static const struct mmu_notifier_ops arm_smmu_mmu_notifier_ops = {
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
@@ -573,11 +315,6 @@ int arm_smmu_master_enable_sva(struct arm_smmu_master *master)
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
@@ -594,66 +331,51 @@ void arm_smmu_sva_notifier_synchronize(void)
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
 
-	if (mm_get_enqcmd_pasid(mm) != id)
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
@@ -667,6 +389,8 @@ struct iommu_domain *arm_smmu_sva_domain_alloc(struct device *dev,
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
 	struct arm_smmu_device *smmu = master->smmu;
 	struct arm_smmu_domain *smmu_domain;
+	u32 asid;
+	int ret;
 
 	smmu_domain = arm_smmu_domain_alloc();
 	if (IS_ERR(smmu_domain))
@@ -675,5 +399,22 @@ struct iommu_domain *arm_smmu_sva_domain_alloc(struct device *dev,
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
index 527560b36b3993..26d597f608e3b5 100644
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
@@ -2834,6 +2794,9 @@ int arm_smmu_set_pasid(struct arm_smmu_master *master,
 
 	/* The core code validates pasid */
 
+	if (smmu_domain->smmu != master->smmu)
+		return -EINVAL;
+
 	if (!master->cd_table.in_ste)
 		return -ENODEV;
 
@@ -2855,9 +2818,14 @@ int arm_smmu_set_pasid(struct arm_smmu_master *master,
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
@@ -3128,7 +3096,6 @@ static struct iommu_device *arm_smmu_probe_device(struct device *dev)
 
 	master->dev = dev;
 	master->smmu = smmu;
-	INIT_LIST_HEAD(&master->bonds);
 	dev_iommu_priv_set(dev, master);
 
 	ret = arm_smmu_insert_master(smmu, master);
@@ -3310,12 +3277,6 @@ static int arm_smmu_def_domain_type(struct device *dev)
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
index 212c18c70fa03e..d175d9eee6c61b 100644
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
@@ -805,16 +801,13 @@ void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
 int arm_smmu_set_pasid(struct arm_smmu_master *master,
 		       struct arm_smmu_domain *smmu_domain, ioasid_t pasid,
 		       const struct arm_smmu_cd *cd);
-void arm_smmu_remove_pasid(struct arm_smmu_master *master,
-			   struct arm_smmu_domain *smmu_domain, ioasid_t pasid);
 
 void arm_smmu_tlb_inv_asid(struct arm_smmu_device *smmu, u16 asid);
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
@@ -826,8 +819,6 @@ bool arm_smmu_master_iopf_supported(struct arm_smmu_master *master);
 void arm_smmu_sva_notifier_synchronize(void);
 struct iommu_domain *arm_smmu_sva_domain_alloc(struct device *dev,
 					       struct mm_struct *mm);
-void arm_smmu_sva_remove_dev_pasid(struct iommu_domain *domain,
-				   struct device *dev, ioasid_t id);
 #else /* CONFIG_ARM_SMMU_V3_SVA */
 static inline bool arm_smmu_sva_supported(struct arm_smmu_device *smmu)
 {
-- 
2.45.2

