Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2084.outbound.protection.outlook.com [40.107.223.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E47092E7BBB;
	Tue, 26 Aug 2025 17:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756229209; cv=fail; b=h/6dyN0fHYAiShbhmZ0XtLa2taa9jX1Au9cXk4cxz3dU3Rdl3+8fLD1ur7WFScFOQxLZls7rLPRptXpNTLnR3mRVoX5wSozkQU7nMgXy0H7r99kFihVyxqk0AXodBTQ+gvTnnmF7osya/QSVwFdgVfBxxOBCeSPQL6GU+SpjaYc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756229209; c=relaxed/simple;
	bh=gVDKp9wo4O2Ygli6KZw4+noaGsPZ8KU0ubkv775tCy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ZkwED+JtwHLCprNqkoxFppwEQwMdCzQB/Wlzpc7wjJN1WnvRk1h8vhOBEqhOATfJ5T0ZAMAMev9LzJ8x6FDIxvpj8ifEXlnKIzOrKKwZQY5Ep/bTEWqd7/Qg7Y2Gqh/aeGoirRHEmZquDRU0703t4KRYHyr7gzo9By9DySYYXL0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WxLhYl7V; arc=fail smtp.client-ip=40.107.223.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WxLhYl7V"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pa4KxVqHeFP862VUDGSzw/PqS/f8UfjxcYkMjQvwE3M6ZUwDbD8d0h2HHPEF691InYQD29PuCt8tNN33UQ6l4qzgR/EtkoCwNZgiA9EW6NrPqFLI/pt7ld6KMQ5Ya/c0nadi9OTLC5G7sjfhm2Cxi85+DWepbz9BVpEqOjGAjRM82eih3H+2l9g48AROIfzvxp28Hec/JzUywnlaj1dZf2xg5w+V6PQiOFGZOtkBD9cuOXmHkGHDt4w1ozNzdOrL2tLPtn9Y9Dy9eQFJ3g09LtbQWUlI/bEQi5v/1uATLG89bdzNPBptjubpeGKW2jo06ZKIq0qIP8pBaf0Df+OhDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jnHTriFoSJKFIGS9jKgasEY8FQWXC0mi4H1SFp7Iexc=;
 b=CMmLT62FLANTPqJeNCqgu+fwpfq+w9fAiGLvt/XOsVTmMfaRu4nsmLFYvoj0Th1qjnnEc03emfzT+939N4f0poxxjB1aFLAtcR8oYSJlhRtNKofLRD4ELDPKuNwJH+dR+hLJEG4oRhGnhR+9gGldgT/KCDhndxtdP+exRmkAkcgpcwTaQiGd7+8vr8CeP+fVIqeUfqG7PNDlyB5yagZmnuG7jT0ongu+WhvBGUOrFWy8INOM6gC0QcEa+jtfe+TRqDCR3vYAjCxHVE8efXae4s2av276BaFPJILUHq6BfPSY6RcibrjGsVePr7rUPjo/TmfKY8oe/cCDc4PXXvsrkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jnHTriFoSJKFIGS9jKgasEY8FQWXC0mi4H1SFp7Iexc=;
 b=WxLhYl7V4FpoQpbzAHyavGI7t5RiIM36BzKPw2pGpaR7RHS9LG0+La4uUI6ckbazGI+POZ1yw1fB2Ne7QAOoUTtOHjvsd/X6dupWKEg6mUgiGytHsqBOcmM0E9OnO7fFhgAxcwJfhhmpx9w3UckoouSdin+4BwvKkoAphbanU7z28YD8aBWhm7+xqmhWUT5OtGvDmbTRrsXLd3bYV7LKZAbnyYkS7zbd926cOmsAMvPaE4LKHtLbuwyzDQiBpCCyRqozGVIDnJgeKS/4rgl6dpqScIHiNALRpb0gr+r2i0zhVNSURorxqVwTBZIHtM98WOFCOSlCa/41u56JVFmyZA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA1PR12MB8641.namprd12.prod.outlook.com (2603:10b6:806:388::18)
 by MN2PR12MB4222.namprd12.prod.outlook.com (2603:10b6:208:19a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Tue, 26 Aug
 2025 17:26:40 +0000
Received: from SA1PR12MB8641.namprd12.prod.outlook.com
 ([fe80::9a57:92fa:9455:5bc0]) by SA1PR12MB8641.namprd12.prod.outlook.com
 ([fe80::9a57:92fa:9455:5bc0%4]) with mapi id 15.20.9052.019; Tue, 26 Aug 2025
 17:26:40 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Kevin Tian <kevin.tian@intel.com>,
	patches@lists.linux.dev,
	Tina Zhang <tina.zhang@intel.com>,
	Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH v2 09/10] iommu/vt-d: Follow PT_FEAT_DMA_INCOHERENT into the PASID entry
Date: Tue, 26 Aug 2025 14:26:32 -0300
Message-ID: <9-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
In-Reply-To: <0-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0041.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::16) To SA1PR12MB8641.namprd12.prod.outlook.com
 (2603:10b6:806:388::18)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR12MB8641:EE_|MN2PR12MB4222:EE_
X-MS-Office365-Filtering-Correlation-Id: 90ae0c76-d64d-4c47-f9ec-08dde4c5b725
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6dsmYQUK5TLuQMmle/VEclpd59rUT+S1j5ZFAbxHI5SG7Xs1A7ru9cfSRgLK?=
 =?us-ascii?Q?ADKDDWnLkspe1BI+ZCfGdDOZtcaEUzqtrHv9HSMUA+NyJcp4/yptJeZOkn/h?=
 =?us-ascii?Q?4xEiDfi2CP6g/12tb18UI7lRQHexWZnaAqLOqnss0fiVciO34LcmexMeyWaa?=
 =?us-ascii?Q?DTYo6Sffoy46I/5b8+aHQiuR0xh36Xn74wF6N4Gi/4dtjdy/3w4mEj9mHydi?=
 =?us-ascii?Q?670h+dltFdmrsZgg9wn45VxmfXDIN+YMToJIQCeHusu7KZPY8LerGZIqSJ2z?=
 =?us-ascii?Q?yIoMowYD3n4viV98Na9CWU//eyI5z0qs3uiyNXvECRZkGxIMaJt+/eKOSl5X?=
 =?us-ascii?Q?b6hWKhGHLQ4X1nD+DQlvVn5iyr95MnzdSCS184e/o+0P9NDNVXiSymPV6nbA?=
 =?us-ascii?Q?POPjPLVp0vzB5/5pID/FP2PULBlZ42fvQicD9x8JKqxvSUvCUa7WDihfsKjw?=
 =?us-ascii?Q?hUQ/muyTCas2YQNqzJS6PUciXzy35VW+KxDUjqviSbUJ4sz6QnbK0O3/NAAs?=
 =?us-ascii?Q?yD5aOWUn8rFskbTj5W5tqV7NzFay0CMU+gDxVYD3LrwcESyB0BggeEUgjKFi?=
 =?us-ascii?Q?I6MKmvWuc3S8QeEGJZQFMVxwDgdoJOosWGuYpbVaqAGq+Nj22qW7j1sYy2dV?=
 =?us-ascii?Q?sRSetKZtRgASLvZNn/93OwNFKtgWhQxEwMZqB4+40liF25QcP8nDBUsTr2Cf?=
 =?us-ascii?Q?VHs+IvDtBlknmuzs3E6l69h8AqIVhHE9aLvsktRSc64PB/pkBOw+6Ir3rAYO?=
 =?us-ascii?Q?9zZUIp9H/d0zz6usV51d1E/Fvocd+076ix1BdqTTizS/EYgfSg5SHV28IcTD?=
 =?us-ascii?Q?8TV9RnPpSUSiaGGVSU7EfuKxm/XP/0fftyaq/AGO04V5Jfj1gQFKtWtVjwFC?=
 =?us-ascii?Q?ocjaTE2zCg2XI+qJTgSTfP5gwgGkYioUe7ASX/VrlS5W1rHKXLKN75ZpUnWE?=
 =?us-ascii?Q?P5KJkKuoiPV1VUiajEOYS/+pIKSiwraYXRfS67mcSD+Cr8W5oITYpW4B1PZI?=
 =?us-ascii?Q?1uBLKcESfabIGtyS+ZICBOIM7Yaa83T6kq/nlRxCgrOg7kGSSNNOBl9M3+xS?=
 =?us-ascii?Q?MwtXs4S1cuFCA/PRy9LI111uuqeBUYUHrqlnOaYRgb11uepUR8YcCYwwWrsh?=
 =?us-ascii?Q?fc6ttRE/zD6MPh1hcZnOaOBav4J1CEpk0tnuqxVK0jph7NGCC69ulxtAl5ad?=
 =?us-ascii?Q?L0m9MWvC/YRpyRisaE1bbxnTTw/AadjFYRdkdpUi13Ap+9OUDrpeMm2Nglbe?=
 =?us-ascii?Q?fjDx8fabV3PKomBHNzGklXaUQxQrTC40R2UTTiH+RkTvsfuf7/JR9Bna2lPI?=
 =?us-ascii?Q?PzzKhS8wGXdCV6ah/PGi8tFLgVpdRJiu9wfzF+FcxbFAIxBDuRehK1Xymrzx?=
 =?us-ascii?Q?c5L1ffeThnTLxPkajFcIdFgITQfGOqGn6WF6is3xUPEuNxh1hw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB8641.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?UefI01zAot4Kp8fvAQC9TMDiPWK/LeSgbKJ/39uwwkUC3hwIlzIpBU+ZGg1q?=
 =?us-ascii?Q?LZ1O2Mv7nli5oTH5vM11fLvyBZsfa6A+SH+LZQ2I44nCN7qICFQZEVuA+G8D?=
 =?us-ascii?Q?IiHZ8D8hIT6EnzK5vxPMNdTdgpZdeyMOCQ71875K3ct6ccArXPuZvKvhIp0W?=
 =?us-ascii?Q?6Mv77Q47Cfb0Ovv2HV7Yl64PDXGihjQQnrB+hjlOOdjid//h7cB81PHfwiFk?=
 =?us-ascii?Q?/7/rx5KoFWfM0w8+OcvkUwCktbDEDBGTcqYOidVhPI4Fss9KSo9Ub8hagRbC?=
 =?us-ascii?Q?6CGNNdyWoQmBn4FJvCbCR/kymmTtq0KEvbIYPpu/tw1nsLlPTckVNOlHA0vZ?=
 =?us-ascii?Q?tC1ezZ3YShKkj3ERnElY9XkYU1bMGPxGP6J1+d6Bqw6xj66OOjdp3DduuOV7?=
 =?us-ascii?Q?2WlE/ljGZT4BHLEYr3T+o/YHCSx5TxiwxIYn1IgCVhkI1Auro29DAqkyX6wp?=
 =?us-ascii?Q?1467URY0iA6W4+/X3mcJ+Ef47kH3aLOc4NqXdST9FT0Ow+QWvikdUxSPNB8F?=
 =?us-ascii?Q?twNvHkRNPszkNI9hQ3ZzdJQ/5mvF/+qWceadSuo4IL1w4ixa31vkold8dSoG?=
 =?us-ascii?Q?+WXPOr4h3MuKzbepatbSE6aOweOvt6K7wLygaMSm8ULPyv85n+f2VTNoJS0F?=
 =?us-ascii?Q?NtkAPYsVIAxfgjmrKXNRNsa6J43tDeFPGLHRGs8Y+bnO5KczMxZ7dpRibRIA?=
 =?us-ascii?Q?8oWAq6/7akyaw6gEIl6KvaSkEh0j5WTyGDOXKYHWSOmB41NjRvHcXknTxNto?=
 =?us-ascii?Q?nHgJIvsyuQtQpVMlUz3ufBF9vlmnjz9Nx6XZ/3Q3N00BwoFF+UskvVjJiYuP?=
 =?us-ascii?Q?W/ke9W+OU+rqlFQfW0+iTg5ZLgZWcTeTp6lGRvlUpB2kZdEYWIUv8VgiqbLO?=
 =?us-ascii?Q?ud6FDsYTuRjH9GPufzZNQK4+rWVwJRxw8PFN5VA1A7g/W/uDmmB1PamVTfTm?=
 =?us-ascii?Q?J1VcX29eicXSLkWyR2H1LHAmvZPss2M+AY5QArcopf1IHbg4azMX3qw7zvhP?=
 =?us-ascii?Q?Kr/LylMohqruokEqlU0gPreFgfiXQR6VqSTbeMMiBaTAKJ4JiBlYhmK02vNo?=
 =?us-ascii?Q?61f8ahROUKTtDEx5PQ0RCeDWsVVD2/YfWgMPmWS/zu2z7rpQJzfqu45KYTxG?=
 =?us-ascii?Q?n7Yc4GbY0hn7pws7G3ha56ORtnMFtdO/j0mXrliN88RnC/9tq1qvXZSJaLia?=
 =?us-ascii?Q?b5PXNaph9DU35qRPgcXgOzn4Q9ixV703OTa0GoP84KF8tyxo/eKhfdWI7gF2?=
 =?us-ascii?Q?WAzPPzr/VGUhW7FtoLy6T/82vOzG7RxXI7OS6MnCAEkctp+F7ZWL6pTgBCKr?=
 =?us-ascii?Q?aYkQBikK19uTtJjo67wnUN5zRnPojs/uBgI8stjP4YP6ZmgWlHN9t5KL1uO9?=
 =?us-ascii?Q?9JSQjS+JutL+yEPrfFuycQxgZRu78bbJmvyRr+YBQMvvslYT153X4UcpRbw+?=
 =?us-ascii?Q?WH+flFYKRLJSxJPqDwxU7eCs3+Pn/VHpgXtqNjJcSDoCjG0BS7qNrkGi1a/D?=
 =?us-ascii?Q?HSkamF1WZlQzIEZXdP7IN1CZesLr7wGqvH9TNL7/erFRL/fe7Jx7C4IhNAFX?=
 =?us-ascii?Q?JnN8X9uYXqhAjVqepo6sGGdc8Jtf4OShlV/Yxji8?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90ae0c76-d64d-4c47-f9ec-08dde4c5b725
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB8641.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2025 17:26:39.2828
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cWh/A+5ZEbjSh32HblqY51vUA/YHDylbUdI8iJ+BgwaxzUW5PLffjfeH8dqBTgCX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4222

Currently a incoherent walk domain cannot be attached do a coherent
capable iommu. Kevin says HW probably doesn't exist with such a mixture,
but make the driver make logical sense anyhow.

When building the PASID entry the PWSNP (Page Walk Snoop) bit tells the HW
if it should issue snoops. If the page table is cache flushed because of
PT_FEAT_DMA_INCOHERENT then it is fine to set this bit to 0 even if the HW
supports 1.

Weaken the compatible check to permit a coherent instance to accept an
incoherent table and fix the PASID table construction to set PWSNP from
PT_FEAT_DMA_INCOHERENT.

SVA always sets PWSNP.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/intel/iommu.c |  8 ++++++--
 drivers/iommu/intel/pasid.c | 31 ++++++++++++++-----------------
 drivers/iommu/intel/pasid.h |  1 +
 drivers/iommu/intel/svm.c   |  1 +
 4 files changed, 22 insertions(+), 19 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 6a269d201a614b..b9c69c43ca8dcf 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -1300,6 +1300,10 @@ static int domain_setup_first_level(struct intel_iommu *iommu,
 	if (domain->force_snooping)
 		flags |= PASID_FLAG_PAGE_SNOOP;
 
+	if (!(domain->fspt.x86_64_pt.common.features &
+	      BIT(PT_FEAT_DMA_INCOHERENT)))
+		flags |= PASID_FLAG_PWSNP;
+
 	return __domain_setup_first_level(iommu, dev, pasid,
 					  domain_id_iommu(domain, iommu),
 					  pt_info.gcr3_pt, flags, old);
@@ -2989,7 +2993,7 @@ static int paging_domain_compatible_first_stage(struct dmar_domain *dmar_domain,
 	if (!sm_supported(iommu) || !ecap_flts(iommu->ecap))
 		return -EINVAL;
 
-	if (!!ecap_smpwc(iommu->ecap) !=
+	if (!ecap_smpwc(iommu->ecap) &&
 	    !(dmar_domain->fspt.x86_64_pt.common.features &
 	      BIT(PT_FEAT_DMA_INCOHERENT)))
 		return -EINVAL;
@@ -3030,7 +3034,7 @@ paging_domain_compatible_second_stage(struct dmar_domain *dmar_domain,
 	if (sm_supported(iommu) && !ecap_slts(iommu->ecap))
 		return -EINVAL;
 
-	if (iommu_paging_structure_coherency(iommu) !=
+	if (!iommu_paging_structure_coherency(iommu) &&
 	    !(dmar_domain->sspt.vtdss_pt.common.features &
 	      BIT(PT_FEAT_DMA_INCOHERENT)))
 		return -EINVAL;
diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
index b03da83583ac3a..3e2255057079c5 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -366,7 +366,7 @@ static void pasid_pte_config_first_level(struct intel_iommu *iommu,
 
 	pasid_set_domain_id(pte, did);
 	pasid_set_address_width(pte, iommu->agaw);
-	pasid_set_page_snoop(pte, !!ecap_smpwc(iommu->ecap));
+	pasid_set_page_snoop(pte, flags & PASID_FLAG_PWSNP);
 
 	/* Setup Present and PASID Granular Transfer Type: */
 	pasid_set_translation_type(pte, PASID_ENTRY_PGTT_FL_ONLY);
@@ -461,19 +461,22 @@ int intel_pasid_replace_first_level(struct intel_iommu *iommu,
  */
 static void pasid_pte_config_second_level(struct intel_iommu *iommu,
 					  struct pasid_entry *pte,
-					  u64 pgd_val, int agaw, u16 did,
-					  bool dirty_tracking)
+					  struct dmar_domain *domain, u16 did)
 {
+	struct pt_iommu_vtdss_hw_info pt_info;
+
 	lockdep_assert_held(&iommu->lock);
 
+	pt_iommu_vtdss_hw_info(&domain->sspt, &pt_info);
 	pasid_clear_entry(pte);
 	pasid_set_domain_id(pte, did);
-	pasid_set_slptr(pte, pgd_val);
-	pasid_set_address_width(pte, agaw);
+	pasid_set_slptr(pte, pt_info.ssptptr);
+	pasid_set_address_width(pte, pt_info.aw);
 	pasid_set_translation_type(pte, PASID_ENTRY_PGTT_SL_ONLY);
 	pasid_set_fault_enable(pte);
-	pasid_set_page_snoop(pte, !!ecap_smpwc(iommu->ecap));
-	if (dirty_tracking)
+	pasid_set_page_snoop(pte, !(domain->sspt.vtdss_pt.common.features &
+				    BIT(PT_FEAT_DMA_INCOHERENT)));
+	if (domain->dirty_tracking)
 		pasid_set_ssade(pte);
 
 	pasid_set_present(pte);
@@ -483,11 +486,9 @@ int intel_pasid_setup_second_level(struct intel_iommu *iommu,
 				   struct dmar_domain *domain,
 				   struct device *dev, u32 pasid)
 {
-	struct pt_iommu_vtdss_hw_info pt_info;
 	struct pasid_entry *pte;
 	u16 did;
 
-	pt_iommu_vtdss_hw_info(&domain->sspt, &pt_info);
 
 	/*
 	 * If hardware advertises no support for second level
@@ -513,8 +514,7 @@ int intel_pasid_setup_second_level(struct intel_iommu *iommu,
 		return -EBUSY;
 	}
 
-	pasid_pte_config_second_level(iommu, pte, pt_info.ssptptr, pt_info.aw,
-				      did, domain->dirty_tracking);
+	pasid_pte_config_second_level(iommu, pte, domain, did);
 	spin_unlock(&iommu->lock);
 
 	pasid_flush_caches(iommu, pte, pasid, did);
@@ -527,12 +527,9 @@ int intel_pasid_replace_second_level(struct intel_iommu *iommu,
 				     struct device *dev, u16 old_did,
 				     u32 pasid)
 {
-	struct pt_iommu_vtdss_hw_info pt_info;
 	struct pasid_entry *pte, new_pte;
 	u16 did;
 
-	pt_iommu_vtdss_hw_info(&domain->sspt, &pt_info);
-
 	/*
 	 * If hardware advertises no support for second level
 	 * translation, return directly.
@@ -545,8 +542,7 @@ int intel_pasid_replace_second_level(struct intel_iommu *iommu,
 
 	did = domain_id_iommu(domain, iommu);
 
-	pasid_pte_config_second_level(iommu, &new_pte, pt_info.ssptptr,
-				      pt_info.aw, did, domain->dirty_tracking);
+	pasid_pte_config_second_level(iommu, &new_pte, domain, did);
 
 	spin_lock(&iommu->lock);
 	pte = intel_pasid_get_entry(dev, pasid);
@@ -773,7 +769,8 @@ static void pasid_pte_config_nestd(struct intel_iommu *iommu,
 	pasid_set_fault_enable(pte);
 	pasid_set_domain_id(pte, did);
 	pasid_set_address_width(pte, pt_info.aw);
-	pasid_set_page_snoop(pte, !!ecap_smpwc(iommu->ecap));
+	pasid_set_page_snoop(pte, !(s2_domain->sspt.vtdss_pt.common.features &
+				    BIT(PT_FEAT_DMA_INCOHERENT)));
 	if (s2_domain->dirty_tracking)
 		pasid_set_ssade(pte);
 	pasid_set_translation_type(pte, PASID_ENTRY_PGTT_NESTED);
diff --git a/drivers/iommu/intel/pasid.h b/drivers/iommu/intel/pasid.h
index a771a77d4239c4..b4c85242dc7962 100644
--- a/drivers/iommu/intel/pasid.h
+++ b/drivers/iommu/intel/pasid.h
@@ -24,6 +24,7 @@
 
 #define PASID_FLAG_NESTED		BIT(1)
 #define PASID_FLAG_PAGE_SNOOP		BIT(2)
+#define PASID_FLAG_PWSNP		BIT(2)
 
 /*
  * The PASID_FLAG_FL5LP flag Indicates using 5-level paging for first-
diff --git a/drivers/iommu/intel/svm.c b/drivers/iommu/intel/svm.c
index e147f71f91b722..71de7947971f82 100644
--- a/drivers/iommu/intel/svm.c
+++ b/drivers/iommu/intel/svm.c
@@ -170,6 +170,7 @@ static int intel_svm_set_dev_pasid(struct iommu_domain *domain,
 
 	/* Setup the pasid table: */
 	sflags = cpu_feature_enabled(X86_FEATURE_LA57) ? PASID_FLAG_FL5LP : 0;
+	sflags |= PASID_FLAG_PWSNP;
 	ret = __domain_setup_first_level(iommu, dev, pasid,
 					 FLPT_DEFAULT_DID, __pa(mm->pgd),
 					 sflags, old);
-- 
2.43.0

