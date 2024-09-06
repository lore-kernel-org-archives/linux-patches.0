Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2061.outbound.protection.outlook.com [40.107.244.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 723161D3191;
	Fri,  6 Sep 2024 15:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725637697; cv=fail; b=duRHrm1NoulghZwCHM9h8Mkk1s5mZOoOkGKa17RUXfvFzgbC10cwf/Ufy11xnkdOBr7uf88Bt7i6iNLZgd7MKwRxQ257bAc+vGcI14VJJv7MQ3v/rlUBNUaK/7fxh4k8t86gfoWY9fxk+ZcJ0bNQPxt0Nq7AO95rM27sJ84I+Pg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725637697; c=relaxed/simple;
	bh=U4wKgVXi88iDyU1b9LZTkzcs/PquxOGcVnckNI6se/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mn2JhNF+P7PMTQB1OkhgnzUYMclEgxunNgz6FsYNd+1NiEx9sDRyXd/LyImle7gk7/3yTyuGM9VE8dd//epODBMF386gUA1piep0sidV9h9HbXKjJjw/it7P6cAiP0FBaV066KOTxEafGNO8RKwz00J7e7gxEkrkdzkJ0wslhwg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Bz/q03hp; arc=fail smtp.client-ip=40.107.244.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Bz/q03hp"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h2uvx+c1lR8sk+kmC72OivjE7nUrLc1Vg+P7wf4WfQJASNfC4Xxp1AWPl6lMm2P4OUEfEku9dJpCvwOPkycnML9mwovJGRbRdIWlf8e6IF8fpUKTJtRCmX9OvYwCkTjy/sY3+q2h2PKJBU+pbtXz+4mijjBzdvOEqf9dGjHEqQTILd4P89il7YLBDUyRXqMdRCX/UcntyQ1epVbTtkS7MpYdD32qxmXZy++nxDzjHLe2Vzd9rvrucISkzIigZtsphzm49kzG4Xjo3OsTbGpaZysGZemttcuE/LPkbhIzqfNcPR3/YHF1BTkDt6prn5jm5VJjJnL4k/dVxGFVD9vGSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cPK+G/DRqkbiWej6K4XqotLhQ4Sg5GN2OAYLdilihFQ=;
 b=LWFawGMB5WX3xKSbTxgnPLYO/fqtUbNZzaCoaljn1GoApDqa8X4tJwjau622CJcAhXNwJr07GSgCaWJEygDIydX4yNwPq0r5z8cnoggU2FpKhNw+dzKjxzz0hsYYyaP27QWSVUHqGmtju8vZ19rD3rQQWifKwk1r7/FQgt5564P34gSbiwNyAc7xR7Uc7uvcyJmi/35Xrkb9JxL7KOOMZo4zR69QjzjLBcrMzgfMkV5exTlvSoCG5SkdgQIv5mLbnRwmr1fMfEWnMmTM5n8qFCtxyuALj9J2U7Y3HRqF94vp+nN44jDwJEAHc9khbrJLK6zSrRQ1NXD+0UOjAQOWTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cPK+G/DRqkbiWej6K4XqotLhQ4Sg5GN2OAYLdilihFQ=;
 b=Bz/q03hpBvfQmr2GMkKLuvG/kofJYlNZrT8w4TNGZx7eS4BDoQmu+FElmWgFcPtkhMDUJs/yJERtA0SNnffPIroGCKXxH6UGRT7Vh32eXGrCaaWvlqWW2wMvVAJ59tivppW2NQh0+afFRMmYceFITUc/E9Z+qK0ni8tgwTAqMr1kgVh/hHY4+k6Jj6Br37dxs2ueZbziyudHjCOCtSxN4sM1YFWMDeImiQJjQPVsNffMQhq/tLwu29h8wDL4C7tl76bHN6iA1Gx+ikN72bb1WWbZczMDiswM3ypvHYvmJs3x9APeORcWT+XyTTDIUDDaX2vVXci4PRlU1GSL23o/Wg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by SN7PR12MB6792.namprd12.prod.outlook.com (2603:10b6:806:267::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.28; Fri, 6 Sep
 2024 15:48:05 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7918.024; Fri, 6 Sep 2024
 15:48:05 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v4 7/8] iommu/arm-smmu-v3: Add types for each level of the CD table
Date: Fri,  6 Sep 2024 12:47:54 -0300
Message-ID: <7-v4-6416877274e1+1af-smmuv3_tidy_jgg@nvidia.com>
In-Reply-To: <0-v4-6416877274e1+1af-smmuv3_tidy_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR05CA0026.namprd05.prod.outlook.com
 (2603:10b6:208:335::8) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|SN7PR12MB6792:EE_
X-MS-Office365-Filtering-Correlation-Id: c19a4d5c-517f-4a55-4de9-08dcce8b4793
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?93qsWZ/0mi2MpGVnXplNV4lCIdcEYyFPgTlYjgs2PS/UnpjEuXOsP0jXCJFb?=
 =?us-ascii?Q?QTz+EZYDmyzhBBHCMopCQ9EBeF9U7RqW2tg9LvfBpSo73e0GBg9/6juoYxnA?=
 =?us-ascii?Q?VkdT94pVumDkG5mopXa8XRFMkOkPFYzczjWuPJhalrxBreodcXn5camBuicS?=
 =?us-ascii?Q?SNilL0jnYms0n8tvTDWXxDRumMzGlvqgnqsuGiLW5oirIMaxOFTs7Yv2Izu+?=
 =?us-ascii?Q?wS8ZY5B2hcG99RH/cq1jLj9J8EYsxWI8uS1WZHm6z0vB5dplecLnSrniKuno?=
 =?us-ascii?Q?rUnmPf6YKme4RuwXSK08oRWV9ygUjOskjFLpOra58TYd59I2h1/DfwR7/Fun?=
 =?us-ascii?Q?UM7jxci+cye27gi1PFAxTKQ2Hzy/QDqRclqSrn4CslgF+zIxPuP4N4cSDgmY?=
 =?us-ascii?Q?u+Eg3vxeV0Q3MZZka1r+M079xjb/plPUmhcuOPl+d9wB12xR7jyRAaofLY2z?=
 =?us-ascii?Q?FcIa2/n3kT3bMnYMIZlOjPUmRTc0dyWR/QgNmVF6E++Vov746JrfABwpYJa1?=
 =?us-ascii?Q?fF1vhOU0XuQievhM/ZcsO6NZfgxGJD8N5rULbXuXmow3zsUKCchR7omilxvo?=
 =?us-ascii?Q?L8YdBxs1txb5eeqd//dgg/VWRR+AoAABfSeau+qK/4Ri6uK8gwYFEQ134Cvi?=
 =?us-ascii?Q?cUWQlOWUPUlCWC9N4dM2X19kDcgB20p1jGYJtWPfQCYjEkegSEvRy4EGj7ET?=
 =?us-ascii?Q?tJ6xmxy1017hZsJqhjwqd+g31kamfA5UwDoMzfY39aLx9GEDKHuweGcpg/8E?=
 =?us-ascii?Q?La55AvQkj7D6pDDGVUnnkPcXu939aHO/Z4y3xdNxbpgsAQ3eXhKnxdoowVwB?=
 =?us-ascii?Q?3Fw1AMly8glXFAmMFQCbilhgLMQymdDQ+o8ae3zOlWr2HucQfu51kq0rKnTk?=
 =?us-ascii?Q?ODpfCusDyA11qZatUUtsPZHWpt/gRO4is+JWvyL5VtEsZytXpccu92/1GbKS?=
 =?us-ascii?Q?+ub4jDN2smoryJ41nf8YQEJFI1XZcpTh3No5Z+Ed8pLpz8P9zDLuQOS8v9Ua?=
 =?us-ascii?Q?y3jauVuHCsqL8glErazhK6pY7+cxXFizSSAsnc5uFcE3V/YW0m1Sv2mlYOlE?=
 =?us-ascii?Q?sxNi0lVXMxItwQfwcXEjUXrHIDIG23Tr799PeB0nFXNFZ231cCWPo585bent?=
 =?us-ascii?Q?5HzbCu210VLzdIrhbEbirf3+3+g9JOBXi8HeFvhkRyBZBedQfnZCBLfFiG8p?=
 =?us-ascii?Q?QlGegkiJdrcont2l9j2gKHLbgvZUw3veq3QJInCN2rHf33Do5P22bRlFoOHh?=
 =?us-ascii?Q?o/oucJBli46zpMWmYbhCxSEKzaqVbGYPd/u+9WYUg5P5fQxI+nCt7ktaayTY?=
 =?us-ascii?Q?HlqNRRNT7cX31BnbT7JLwr0qSHLErhqomaNPUJbcvENxAg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tJpOefLVyoeozMfvLNw7SiuD2SebLFXPs3aThnrHzxmtN6Z/dhPzW3wxE2W/?=
 =?us-ascii?Q?enlLTj1iRgy2HW7K0E0Etp7fVIvA8ATjow95EG6lBG5LcWmXg+Iq0ZTPnW8D?=
 =?us-ascii?Q?oZj6vhnloif0av1QSNA1WgMX8cIRwLCf6TsQkDOXwrfj+GouAjnePFeQZkLz?=
 =?us-ascii?Q?0Lns2Nra3DfS9+pOcbg1YDGlQ9aokBrEnhL0ciLjVqLIe4tnKOrHIy8r1TVZ?=
 =?us-ascii?Q?Oyh9VEeGiAi478qniiJgiRMOjPvBZcVc8QOeh48aOhMM9z4LEJxl4r71qgnU?=
 =?us-ascii?Q?D3+J/jpihT9y3qjbOc4KxozPk9XVjZBfH/X660//+vp1PCljKTvjdMMz2UDR?=
 =?us-ascii?Q?/9yEGUX5vi7aUZfAtOmo7cKJ80Yn8dEAjcyu9HeGdy4Aj0Y/tbf/c+5IlJBK?=
 =?us-ascii?Q?nukHJJCDLhiXhkngybkURU6wD7SYWWK6WWxE9KMKhoviENqoHnH0oN5JU6ga?=
 =?us-ascii?Q?vk0zwKsf/VUxwipAR13Oo8HoJX97Qu6kok7IJT8XV+uX1/enQHapF7Li6QNN?=
 =?us-ascii?Q?7GHrHsvgQcqtgNEywzhoWrRbIL6iHUNdfPYgr/OjDH39ILWcHmgjJFkfU7eh?=
 =?us-ascii?Q?z9gi/aDX46v0REJl8Z80ltSiXcLCn1leIv/kbjlGenmws7eTPuybf8+f1IsE?=
 =?us-ascii?Q?iHA3YhsN3UkQeu36WehPuIdqv1X8WjsmA9y+9CksfHXycdLmGgidZg4LiXz3?=
 =?us-ascii?Q?wXbLwpuXRG6/c34Kteux4gLy+9UrdKOphod1LnfhMMqH2b8RHQDjfnV2cEgz?=
 =?us-ascii?Q?WSKg5yY/bIHQgW0dAznLLXbG8d+bNn11LsG0XAeQUyfckOrfLgj6hm7Sa5j7?=
 =?us-ascii?Q?lVB+57AnMR1YLkp6Vn60lRGuDB484J3FWKspIQ3PcRxjoBwU6e/iFzkX5cH0?=
 =?us-ascii?Q?rubmiuVWNIQq0Q1JNxk2Az+QdgMbych93cMWxATHgYKjNN6zPPBYVQvlD4u+?=
 =?us-ascii?Q?zS4Zl0fW8iWA079CzfmgFHBZ0rWMURzgjmP1T2sQmBkIfV+GCeSmapCpAgJ0?=
 =?us-ascii?Q?WsOz35+gSKbjHuVmPxeThEtONwjYruDCyVzYjBmPgmHSSiPtVy37CD2RBU8m?=
 =?us-ascii?Q?ccWwJy41FVX3kX8Sw9pAz2dFRxa2stcWF/FBWjo+oyiQTsMU6xILFmPLTfJm?=
 =?us-ascii?Q?V/f5tb734pJ3ebl+hSBTewQCMVV6NO8NSQUCAmSPC4Ra50Dfu8py5defhr7B?=
 =?us-ascii?Q?7fEu8oIZ2hiOJAFH4LnswhKusteRnpBpniDxRrKnvqB6wgxbuTyDR/PVgnZe?=
 =?us-ascii?Q?Yex8TQT0TFEDEqTJnVxxcowuHkhCFOJa7HsqCx/Vj7WtWvMbULfmKwiyM0MH?=
 =?us-ascii?Q?YBjwwSVthZsZR/AIOlRSCIuREUtHKNJQOAkXJqyMWSSe2rcjuGnt5nOE4/zS?=
 =?us-ascii?Q?SchNlN2NIJ+x8kSo601Ehh9JrzE90bSC8pCsZPfsLzkA0exNDFp5bWKGe+nG?=
 =?us-ascii?Q?QXRr3Wx4MGdTks2UJEfefAOAjzMb5zi6FGUz9DSIQGPsj2108IreuJzAowSy?=
 =?us-ascii?Q?2wAQ9BhFCzDmPYd2hkP+Q9aCtZwJQUja/oeguvNm+4VqGxBChNE43xxbbfnc?=
 =?us-ascii?Q?iDLmmFkl3nGKHxpU8yksY7pXF7ERf64e76xX10Mt?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c19a4d5c-517f-4a55-4de9-08dcce8b4793
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2024 15:47:57.7600
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XxFuzHyLSJtKJiilISGECLDCvpi429s1YifSGQnc1t3AaMsR1aDkLXeR7wmDR/vD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6792

As well as indexing helpers arm_smmu_cdtab_l1/2_idx().

Remove CTXDESC_L1_DESC_DWORDS and CTXDESC_CD_DWORDS replacing them all
with type specific calculations.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 45 +++++++++++----------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h | 23 +++++++++--
 2 files changed, 44 insertions(+), 24 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 3c33ebffbe62de..534a2141445647 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1217,17 +1217,18 @@ static void arm_smmu_sync_cd(struct arm_smmu_master *master,
 	arm_smmu_cmdq_batch_submit(smmu, &cmds);
 }
 
-static void arm_smmu_write_cd_l1_desc(__le64 *dst, dma_addr_t l2ptr_dma)
+static void arm_smmu_write_cd_l1_desc(struct arm_smmu_cdtab_l1 *dst,
+				      dma_addr_t l2ptr_dma)
 {
 	u64 val = (l2ptr_dma & CTXDESC_L1_DESC_L2PTR_MASK) | CTXDESC_L1_DESC_V;
 
 	/* The HW has 64 bit atomicity with stores to the L2 CD table */
-	WRITE_ONCE(*dst, cpu_to_le64(val));
+	WRITE_ONCE(dst->l2ptr, cpu_to_le64(val));
 }
 
-static dma_addr_t arm_smmu_cd_l1_get_desc(const __le64 *src)
+static dma_addr_t arm_smmu_cd_l1_get_desc(const struct arm_smmu_cdtab_l1 *src)
 {
-	return le64_to_cpu(*src) & CTXDESC_L1_DESC_L2PTR_MASK;
+	return le64_to_cpu(src->l2ptr) & CTXDESC_L1_DESC_L2PTR_MASK;
 }
 
 struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
@@ -1240,13 +1241,12 @@ struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
 		return NULL;
 
 	if (cd_table->s1fmt == STRTAB_STE_0_S1FMT_LINEAR)
-		return (struct arm_smmu_cd *)(cd_table->cdtab +
-					      ssid * CTXDESC_CD_DWORDS);
+		return &((struct arm_smmu_cd *)cd_table->cdtab)[ssid];
 
-	l1_desc = &cd_table->l1_desc[ssid / CTXDESC_L2_ENTRIES];
+	l1_desc = &cd_table->l1_desc[arm_smmu_cdtab_l1_idx(ssid)];
 	if (!l1_desc->l2ptr)
 		return NULL;
-	return &l1_desc->l2ptr[ssid % CTXDESC_L2_ENTRIES];
+	return &l1_desc->l2ptr->cds[arm_smmu_cdtab_l2_idx(ssid)];
 }
 
 static struct arm_smmu_cd *arm_smmu_alloc_cd_ptr(struct arm_smmu_master *master,
@@ -1264,11 +1264,12 @@ static struct arm_smmu_cd *arm_smmu_alloc_cd_ptr(struct arm_smmu_master *master,
 	}
 
 	if (cd_table->s1fmt == STRTAB_STE_0_S1FMT_64K_L2) {
-		unsigned int idx = ssid / CTXDESC_L2_ENTRIES;
+		unsigned int idx = arm_smmu_cdtab_l1_idx(ssid);
 		struct arm_smmu_l1_ctx_desc *l1_desc;
 
 		l1_desc = &cd_table->l1_desc[idx];
 		if (!l1_desc->l2ptr) {
+			struct arm_smmu_cdtab_l1 *dst;
 			dma_addr_t l2ptr_dma;
 			size_t size;
 
@@ -1279,8 +1280,8 @@ static struct arm_smmu_cd *arm_smmu_alloc_cd_ptr(struct arm_smmu_master *master,
 			if (!l1_desc->l2ptr)
 				return NULL;
 
-			arm_smmu_write_cd_l1_desc(&cd_table->cdtab[idx],
-						  l2ptr_dma);
+			dst = &((struct arm_smmu_cdtab_l1 *)cd_table->cdtab)[idx];
+			arm_smmu_write_cd_l1_desc(dst, l2ptr_dma);
 			/* An invalid L1CD can be cached */
 			arm_smmu_sync_cd(master, ssid, false);
 		}
@@ -1424,7 +1425,7 @@ static int arm_smmu_alloc_cd_tables(struct arm_smmu_master *master)
 		cd_table->s1fmt = STRTAB_STE_0_S1FMT_LINEAR;
 		cd_table->num_l1_ents = max_contexts;
 
-		l1size = max_contexts * (CTXDESC_CD_DWORDS << 3);
+		l1size = max_contexts * sizeof(struct arm_smmu_cd);
 	} else {
 		cd_table->s1fmt = STRTAB_STE_0_S1FMT_64K_L2;
 		cd_table->num_l1_ents = DIV_ROUND_UP(max_contexts,
@@ -1436,7 +1437,7 @@ static int arm_smmu_alloc_cd_tables(struct arm_smmu_master *master)
 		if (!cd_table->l1_desc)
 			return -ENOMEM;
 
-		l1size = cd_table->num_l1_ents * (CTXDESC_L1_DESC_DWORDS << 3);
+		l1size = cd_table->num_l1_ents * sizeof(struct arm_smmu_cdtab_l1);
 	}
 
 	cd_table->cdtab = dma_alloc_coherent(smmu->dev, l1size,
@@ -1460,27 +1461,29 @@ static int arm_smmu_alloc_cd_tables(struct arm_smmu_master *master)
 static void arm_smmu_free_cd_tables(struct arm_smmu_master *master)
 {
 	int i;
-	size_t size, l1size;
+	size_t l1size;
 	struct arm_smmu_device *smmu = master->smmu;
 	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
 
 	if (cd_table->l1_desc) {
-		size = CTXDESC_L2_ENTRIES * (CTXDESC_CD_DWORDS << 3);
-
 		for (i = 0; i < cd_table->num_l1_ents; i++) {
+			dma_addr_t dma_handle;
+
 			if (!cd_table->l1_desc[i].l2ptr)
 				continue;
 
-			dma_free_coherent(smmu->dev, size,
+			dma_handle = arm_smmu_cd_l1_get_desc(&(
+				(struct arm_smmu_cdtab_l1 *)cd_table->cdtab)[i]);
+			dma_free_coherent(smmu->dev,
+					  sizeof(*cd_table->l1_desc[i].l2ptr),
 					  cd_table->l1_desc[i].l2ptr,
-					  arm_smmu_cd_l1_get_desc(
-						  &cd_table->cdtab[i]));
+					  dma_handle);
 		}
 		kfree(cd_table->l1_desc);
 
-		l1size = cd_table->num_l1_ents * (CTXDESC_L1_DESC_DWORDS << 3);
+		l1size = cd_table->num_l1_ents * sizeof(struct arm_smmu_cdtab_l1);
 	} else {
-		l1size = cd_table->num_l1_ents * (CTXDESC_CD_DWORDS << 3);
+		l1size = cd_table->num_l1_ents * sizeof(struct arm_smmu_cd);
 	}
 
 	dma_free_coherent(smmu->dev, l1size, cd_table->cdtab, cd_table->cdtab_dma);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 8b5628771b9671..6fe68f8b38408f 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -301,7 +301,6 @@ static inline u32 arm_smmu_strtab_l2_idx(u32 sid)
  */
 #define CTXDESC_L2_ENTRIES		1024
 
-#define CTXDESC_L1_DESC_DWORDS		1
 #define CTXDESC_L1_DESC_V		(1UL << 0)
 #define CTXDESC_L1_DESC_L2PTR_MASK	GENMASK_ULL(51, 12)
 
@@ -311,6 +310,24 @@ struct arm_smmu_cd {
 	__le64 data[CTXDESC_CD_DWORDS];
 };
 
+struct arm_smmu_cdtab_l2 {
+	struct arm_smmu_cd cds[CTXDESC_L2_ENTRIES];
+};
+
+struct arm_smmu_cdtab_l1 {
+	__le64 l2ptr;
+};
+
+static inline unsigned int arm_smmu_cdtab_l1_idx(unsigned int ssid)
+{
+	return ssid / CTXDESC_L2_ENTRIES;
+}
+
+static inline unsigned int arm_smmu_cdtab_l2_idx(unsigned int ssid)
+{
+	return ssid % CTXDESC_L2_ENTRIES;
+}
+
 #define CTXDESC_CD_0_TCR_T0SZ		GENMASK_ULL(5, 0)
 #define CTXDESC_CD_0_TCR_TG0		GENMASK_ULL(7, 6)
 #define CTXDESC_CD_0_TCR_IRGN0		GENMASK_ULL(9, 8)
@@ -341,7 +358,7 @@ struct arm_smmu_cd {
  * When the SMMU only supports linear context descriptor tables, pick a
  * reasonable size limit (64kB).
  */
-#define CTXDESC_LINEAR_CDMAX		ilog2(SZ_64K / (CTXDESC_CD_DWORDS << 3))
+#define CTXDESC_LINEAR_CDMAX		ilog2(SZ_64K / sizeof(struct arm_smmu_cd))
 
 /* Command queue */
 #define CMDQ_ENT_SZ_SHIFT		4
@@ -618,7 +635,7 @@ struct arm_smmu_ctx_desc {
 };
 
 struct arm_smmu_l1_ctx_desc {
-	struct arm_smmu_cd		*l2ptr;
+	struct arm_smmu_cdtab_l2	*l2ptr;
 };
 
 struct arm_smmu_ctx_desc_cfg {
-- 
2.46.0

