Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010056.outbound.protection.outlook.com [52.101.46.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9743815E8B;
	Thu, 23 Oct 2025 18:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761243775; cv=fail; b=mef5xiP2+bMMnt3U9pMxRRe7ID7W2D1pjLvL1Iy8G0/3GGexfG0QhJ+daEXToGmcTukEPBa+8KM8SgTXoTzMpnuLwoog/IfE5nMF6KPKOSNgUB3b5tnd8wSUoxAKQ1oJzWW/HezScIM+UbbyOnTlvBY0zKp4+wLT281heAoykYM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761243775; c=relaxed/simple;
	bh=eNcwSxQhG/FpvG2eyDGW6jQXZW3OirnpqYVh5Df8sjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jhEX2vEoMY4+Hz0NWO1JRwj/4NRPSahTAfuUt24NrbX/IMqBYUbhoOUl4GfP26i1cvCz9tBPm6FsFTrzBP/uW1RW/9PhqNDrLlSbTP2XFGOyrLMJqZtN2uG0srMsgOW2wyrGAj2rCfaovscGvq8JwDDCfD0j1fCClggvSIg9lXc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=DlDR/cvi; arc=fail smtp.client-ip=52.101.46.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="DlDR/cvi"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WV96mlGYOechwaopQD2sXPxN/UEohouvGbnibD+IMN7x+qN/WqAZVea3gIEsV+VCyXg+x1ycQnM+ymlL1x8cN9P+YsLn1Mve5ziCKll1RqeN2qRTr9rCFVuLjKDtUK/QsndwSA62xk/7LMMMstXmac84hZUc2B2QaXS/CjzL4Zx9XB6VhDq0Vdmfsn1365VrC5DkZbI4OOH4+xQp6FAYGNGICpzIeDE4DjAI2sgiZmunimOzuf1BlOTAFbJ1flUthYbEcKtfgzNrk5lAdlj5A1+1l1JL4iRxiTmdMMoM6B1nBvtpfQhzhxqvk5RzZ2/qG5bF7LM2klw3cNWPovaapg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yvWQhx5oK+PibSlm6HTjzhoAZ0tbJUWi4YXpXdyo220=;
 b=e3xGEnBnZsqazoOyjTvrZY7y6tKX8x18KaWRiI2DhSfpch5O9/xwV/AJjciVVnNv35Hd6iN8lsAMqrRt5Lzr/K1O7D2Z5XMNv/Xz5l+vqgWdmAokIyF7o8N/kbNdIJZC/Lt+4ycH+Tns7qznO/+gAT1wCPCBHwkJEjxDRY7CdOQExLRReujqv+QUGlRe5JiFySpUKUvJtPsE1IqOlng2nAqquy5EyVXhxrROHrgIZucLWih3IHK8C5hy3gwD3OOGClSM4XyQJ/xryhWdWhsi0RRE6nvypWJ8qOF/Y/qKZkUEsdAauDmssnE2VZjnfwToh8CuNGA32H0Y8DeObK4++A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yvWQhx5oK+PibSlm6HTjzhoAZ0tbJUWi4YXpXdyo220=;
 b=DlDR/cviTI3OY8GphdpPmeQOKyC2O6EcONd0RDIlwC5FCZIjj1j+sWPbJyJU6KkTA7Gd+GAsLog3zB3lLo4ULzCyDLQgTMf5e+oYGisKJn84brDVCQbNtCFmEHjEorY2XTqhVs3+q/CTOTrCZ/PzII8U4Wx810YUmKgaYs3FLgUCE4WWtpc5ewZYbyunUTu0Z8neQvH5A2A+7X8KcCaP0p9/sFykiecFSV8b8VQIXgCWgMSbr/vCHAwetpVpZ3KKwDNN0vCCRQmq/A04YPuPduq2uW3YfB386B0SexWZx37tod1nJCg7RIzI3t/6UC3+0hX4b1GM35biob1tMmaGLA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB3613.namprd12.prod.outlook.com (2603:10b6:208:c1::17)
 by IA1PR12MB6164.namprd12.prod.outlook.com (2603:10b6:208:3e8::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Thu, 23 Oct
 2025 18:22:45 +0000
Received: from MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b]) by MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b%4]) with mapi id 15.20.9253.011; Thu, 23 Oct 2025
 18:22:45 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: David Woodhouse <dwmw2@infradead.org>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	patches@lists.linux.dev,
	Tina Zhang <tina.zhang@intel.com>,
	Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH v3 07/10] iommupt/x86: Support SW bits and permit PT_FEAT_DMA_INCOHERENT
Date: Thu, 23 Oct 2025 15:22:35 -0300
Message-ID: <7-v3-634ccd3efce0+16d38-iommu_pt_vtd_jgg@nvidia.com>
In-Reply-To: <0-v3-634ccd3efce0+16d38-iommu_pt_vtd_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0036.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::11) To MN2PR12MB3613.namprd12.prod.outlook.com
 (2603:10b6:208:c1::17)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB3613:EE_|IA1PR12MB6164:EE_
X-MS-Office365-Filtering-Correlation-Id: 46a7f7a3-d096-4ffe-ed98-08de12612928
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wl+0XCWfn1v62NI7++tk08c0pNgFYvX7/R4OMhbBy5yoTxQESFyW9ETlBN1N?=
 =?us-ascii?Q?Kg1IWFBBknwsgwK4CT/TEdwTENDkA3tW3OZdzp58dHyKxGMV6aUEtzwFAF3e?=
 =?us-ascii?Q?VXNA/Z+NxYpx3JgmIaXEOwhEIYC1i39Ecb1iYvsw+nBHaFmYmlGrLWDAMXrn?=
 =?us-ascii?Q?OOJTYOECSG+wpm/nilttPwuA0pmc/YzemZPLmhJxRJf6HoVxW0ba8pk7y7Sq?=
 =?us-ascii?Q?R3s+O7p9YDLTDyDNUQFSXcFGbLlLsj3sbk5pwWyfEZ63jjlx9BwFice8opjs?=
 =?us-ascii?Q?5Rt/BuLyQB6kc4lZB1Xiaq2wH4OTsh6YnCy7wBgGd9Ohl5jwxUJRc0XxuKXb?=
 =?us-ascii?Q?zTUWLSs5jY3Ql0gVHjmN8qqqxIU5nGwiyLEji/Xu+VOMDN0r0+Mnuha3N0jN?=
 =?us-ascii?Q?IOtBKPRIxYGoOvPB43T1np56OsMC+KAMFuPAPfe6pgqn9w4qd1rBXgmZnbAo?=
 =?us-ascii?Q?RE3m7/0QikifNGb9xfRk42GKStgP72v7fjq1CU1zSY+A/McXatcnDWf4fnkW?=
 =?us-ascii?Q?0yN82Qj4B6ag251xG8PCtw+fCOwv+hl0RToGWUVBvN6ilsuickuf4Bvpa2ul?=
 =?us-ascii?Q?+w+3M+rG89Vfc8FjYiSGxVfESRl16VOSD9J8ykE3cHmqauVfmbkptbaKhrMT?=
 =?us-ascii?Q?SVwzUmuL9k6sX/LrjB217bIxhI2W4WLTakcyr1YvTn8xz5Srej1UyeLd/oG2?=
 =?us-ascii?Q?R6p3QHOK7qVxNBwTbcfTz1VDY+nCM4NZBvSZr9c0DwUh3MClHLboWbXjxyZf?=
 =?us-ascii?Q?suhaexMTM0/sW6UnwaW8L/NFu4Wi/rHNJ2dVcQxYEsuECDo7MyuDcRdfZO98?=
 =?us-ascii?Q?CPPBRMcoAr4Md3KmBeBKfpRTPwCN5QH7Uhstw7Bk9ZIHnxrjnphKZivdGV4O?=
 =?us-ascii?Q?W+KtYGf26dc9xQaaGlqtQw5q6ywvKQtQoaiR7X0V2DD8fyI2JJ1OX3C/acSH?=
 =?us-ascii?Q?sxBBVyOim1r0G14R8yGF9SFCpYDm/p47eht2RxawLQxoDnT4Yz9TVt+FeCxx?=
 =?us-ascii?Q?mX5gQC7r8PHrapQH4JtA+lHAX52mMYCNuugvwH1mCmngxk3BFQshg79YkY/a?=
 =?us-ascii?Q?I8iuQSKKkKlJ88FtdnxYSEeAOCrOUAkmLDym9Y1GA29XUKCUiYyYyv0zB7mN?=
 =?us-ascii?Q?g2Kobm251facUG1o5Bn49onNSJq0J7XcVhJD4VBOB4+Jw6QFUy3ALWYsvkIz?=
 =?us-ascii?Q?iyHvZSs6bYv3kja+BOUepggBq+7HLy/Lea3GV/iI+tSalJNhDGq9+nhdvXsh?=
 =?us-ascii?Q?h3ZnVYq4U3EYsJ4CM7waVEuAdvmN6Urwpo9b5ns55/4USFxqMqw0MMWUkXd9?=
 =?us-ascii?Q?4hbktxQ0DjvQFlnB7iNSA4bo2w497Xg2pVA2yiZjNyZ7OJ3TXjtiuGrEc9BB?=
 =?us-ascii?Q?CGLjEs1OGqNEJpbDNMksuVHKNKrbeR00/Ltx6maanu0JbrItA+dDsD+VK6RF?=
 =?us-ascii?Q?Y1lBGtURU07dAPo0H92MTNLeaK2ERn+W?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3613.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wvMOyiDec1uEqeIZLLD0UaJm5/odKfZZISnYL+gM5tb/fYh8RT2WE1P7/jGM?=
 =?us-ascii?Q?Oi/Eo+gFVpwoxECeWsJvN+3UcgRgzdILm4h0Yykw7c8QKDfGAx+xBet3PRve?=
 =?us-ascii?Q?+ONtNHsj1LfNZjBS71C2l4UzcBu4uemSnw2Z6ZMXBInfAIcOcB7+10XQ8LC/?=
 =?us-ascii?Q?bHnEpou3lYBiClueh1Yc3dDR4fiKVpIr5oHti1vuVnprshWXtqn0WVLp01mz?=
 =?us-ascii?Q?QphFqgqGnysNEiWrIXtlJRSV+4lesf3mJmhjeCCD2jz/JU9/M8G6kGXj/XGK?=
 =?us-ascii?Q?N7GAJot1FATcogLXoz4VsgiGtmXnJGHoTzcAt9li0pyLKa5NUTIqAIJOSfHI?=
 =?us-ascii?Q?FXt1sZIRW9MmWKqZPAD+1QLDxkZtjrMdtqJSVBsNthYnajUfnjQ1ypA36A5g?=
 =?us-ascii?Q?DifPVCtqIvSfDF15fMv761CccI86wonwXKLGFw1/ib3G8aauyVt4998YLDRo?=
 =?us-ascii?Q?6JhkSr+DMORxewpSPEtWGDykMPkrQXWykYtZGrBJ1mIpw+nci5NVuB4UeEef?=
 =?us-ascii?Q?ytB++cz7LmDHBWK3XBVoYmBrSs+6bu2uNJ8qMuwKlT2JcCkqG/LV8v+JXkPL?=
 =?us-ascii?Q?Qc6/EFH5XIkIB7Zp1/aset596KhoM70YiuhzWG0uOtMU1O5DcAvqwAP5EI6A?=
 =?us-ascii?Q?efEvEJXXR0p7I6mdKlcuXgldEOnDzcr8RPEipYQVlQjVEJgA9qtLCJJizY8k?=
 =?us-ascii?Q?vq3Lnz+N1DrskF+/q8M/XuBw6fy1V8N1KGWFyYSs21ZaF84V4TeEpsdnGom1?=
 =?us-ascii?Q?CneKp4HN2k1tB9KSbz5ew1hvkj4nbj48V2D4C8EmQByAObXNdvhcUD8woMHd?=
 =?us-ascii?Q?NO+qMIRwm3QoN2fAF2xe66Dxjd8ycTVk1OZpH2716YzDovD6ab+e/zIfJF9L?=
 =?us-ascii?Q?e+Igg6VfI2Tmv2zvwAhOYryDEdFYKYu4L3NmBBvUXisQwIe/QzpaOMKhB5pd?=
 =?us-ascii?Q?BtePShdmbmOqVKDR8CCIuAEfmE9an9bwc59wCfodJn/XPK7C2+KzlJk8oPUJ?=
 =?us-ascii?Q?EJKDNHljuSdrYBWXAGNtkDTFOWu27LiQffyJ+5b02IMNoat4h4gd0Tp5tfCW?=
 =?us-ascii?Q?zKmiGgAJlPj9J3SpOo5jAGkxExXaYUfUObOyJLThtv5TihL9QFclj3gU2+Z+?=
 =?us-ascii?Q?NXcUdX/ZdEjoP79imMSHY9Q5pYpOJbQF6zQ0UTtmaUPgwf7zt8brenJaY4Ns?=
 =?us-ascii?Q?yv+9G4R8xi2PA/wSnT2UfCTu4RZ40C6g8uvFgOJ2GYtfde87mynIDx81K5UB?=
 =?us-ascii?Q?osCAbQT1FKllYAJ0eYsARIgwNGbj6Fwlu9xCG2u352OvnGE5HPYqotiQGAQb?=
 =?us-ascii?Q?qlbbohulXJl66vuRwZxcWBzr/gXcmnp4+U26gi06yqA5ar+5BEBN1ead5yUF?=
 =?us-ascii?Q?L8r0NVNAooVIpcQ1z18aIGcwehbPNVrzPmsOVHcANgvPvbHjrLJrA7KumRu9?=
 =?us-ascii?Q?fmsaBeaSK+CtFNYoPyz/QqmnmXc/AmpZ3vGz4y2lTn0XICmJUuw/BICkk5vX?=
 =?us-ascii?Q?WvBq3s71dTFKByKKsRENFRCuApy/Pc1uMeOIxYbiZOlfkaWStDJR8p0LbAkR?=
 =?us-ascii?Q?pE9jqQCEcdRBovCSlMewI7dKKHWU5lgZGr4OAlyH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46a7f7a3-d096-4ffe-ed98-08de12612928
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3613.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2025 18:22:44.6454
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a0IBPnnYGCmyW3F9TVEgBkzVC1M+Fb0F8aB+H/59EVXxvDL6zMEj0wvRrxEK2+Sx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6164

VT-d requires PT_FEAT_DMA_INCOHERENT for the x86 page table as well,
implement the required SW bits and enable the feature.

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/generic_pt/fmt/iommu_x86_64.c |  2 +-
 drivers/iommu/generic_pt/fmt/x86_64.h       | 27 +++++++++++++++++++++
 2 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/generic_pt/fmt/iommu_x86_64.c b/drivers/iommu/generic_pt/fmt/iommu_x86_64.c
index 5c5960d871a32f..5472660c2d7156 100644
--- a/drivers/iommu/generic_pt/fmt/iommu_x86_64.c
+++ b/drivers/iommu/generic_pt/fmt/iommu_x86_64.c
@@ -6,6 +6,6 @@
 #define PT_SUPPORTED_FEATURES                                  \
 	(BIT(PT_FEAT_SIGN_EXTEND) | BIT(PT_FEAT_FLUSH_RANGE) | \
 	 BIT(PT_FEAT_FLUSH_RANGE_NO_GAPS) |                    \
-	 BIT(PT_FEAT_X86_64_AMD_ENCRYPT_TABLES))
+	 BIT(PT_FEAT_X86_64_AMD_ENCRYPT_TABLES) | BIT(PT_FEAT_DMA_INCOHERENT))
 
 #include "iommu_template.h"
diff --git a/drivers/iommu/generic_pt/fmt/x86_64.h b/drivers/iommu/generic_pt/fmt/x86_64.h
index df1ec7426ad6e1..9ef0299407b14d 100644
--- a/drivers/iommu/generic_pt/fmt/x86_64.h
+++ b/drivers/iommu/generic_pt/fmt/x86_64.h
@@ -171,6 +171,33 @@ static inline void x86_64_pt_attr_from_entry(const struct pt_state *pts,
 }
 #define pt_attr_from_entry x86_64_pt_attr_from_entry
 
+static inline unsigned int x86_64_pt_max_sw_bit(struct pt_common *common)
+{
+	return 12;
+}
+#define pt_max_sw_bit x86_64_pt_max_sw_bit
+
+static inline u64 x86_64_pt_sw_bit(unsigned int bitnr)
+{
+	/* Bits marked Ignored/AVL in the specification */
+	switch (bitnr) {
+	case 0:
+		return BIT(9);
+	case 1:
+		return BIT(11);
+	case 2 ... 12:
+		return BIT_ULL((bitnr - 2) + 52);
+	/* Some bits in 8,6,4,3 are available in some entries */
+	default:
+		if (__builtin_constant_p(bitnr))
+			BUILD_BUG();
+		else
+			PT_WARN_ON(true);
+		return 0;
+	}
+}
+#define pt_sw_bit x86_64_pt_sw_bit
+
 /* --- iommu */
 #include <linux/generic_pt/iommu.h>
 #include <linux/iommu.h>
-- 
2.43.0

