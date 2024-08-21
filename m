Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2062.outbound.protection.outlook.com [40.107.94.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E0921B3B22;
	Wed, 21 Aug 2024 17:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724261859; cv=fail; b=rm+YL3e9TtjSqFwTlMzJOhdh2yNtq5mBwm3VCwd5mT/bYyMb+FZ+0Mxik9bo5P+s7Kt76QfBG/4WxwizVIcHPuMqflrh/GNEXOpBMOIqrtJlx+Dex6rsO0Zy2Pt+VLfoDLTfTu4EBCrB99kSbek/tCoXFBuj6RjqU8U81TzFgqI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724261859; c=relaxed/simple;
	bh=SA5h6P8bENou/EYzAxI6b5/xZ4UmX0VHLBXjtwDIP8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fdunEbj9kuJqYnYnCxyPIM3DpkmtKq/b6DtxO4Xtu0XTHdu5aKn4X9oU7AYN330ZtA3kBkleXV/kfdVe1X1Tc5vaxjdug60qed/moAkhn4bhhpZGjhRj2VgPR29Q7SZr3vrrZ3W7qijJTw62hyunQqWLmQG6qqeyTuejIKPEcfg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Mnb3/7nR; arc=fail smtp.client-ip=40.107.94.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Mnb3/7nR"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d1w18ej9fHar44LLxR97Kqqey6qWdC/myQgz4EtEP2h7jhDeubhO+A6iEiZYcJwi2P3NbvclAp/41yygW/gfDusoDULcgKP0ioaKR0bbu7XKTTPLcWhlrDOKaG38rgJOWg/DMrIYViXP7CN4zGHTY/zRpvEWy2Fhnpvp8Azf6pMZFanXLZlOsO/uHe64a+uQQHthPlVMO0cGg9nodZz4E+WmJvsuaO7/DasEZeB2CTWx9fZhsvnItrK2AqD0RTgSTWlQluKkj4syvlKMNohqIxDulhI2yFHWxlgXQPjJq3zHxvRbKMxHPhqvfmqyVbHP5wcR+m/HKHZ5vtaHAY46PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9uwM3JUN9iQM/GtNPFKpJvV40ATKTCl0snU8AFMro8c=;
 b=hmZLZFtQLOyivmz8JXBiAXpFqJo7b+x/KAL1jGyPibrrVBh1DQ/S0SF/RywdUCoR4ehMi42uhkhd9yWeSqSMy4EZBEoNOlONMRSc8TOszOoC7Rp74ATE9b0Q6K6icH+PGvQVdROkHYxpTDV8FeVlv1VajKm/ltiQGKWauA8g/FeWVaJQtdllIFKXifiRiflZ7yfrNtxje3rWGQaFkwthKZyWctLa7VUfxd7A3NPBmcC5wDzEeiu0X+VT9fFRBH5bDX/Eu8BeMMQ/qU8vCTjbus+I/yqNXq/le2yaxtjQ7pIW9unW8TUxnbAisLqMR/iX3fLfU4TR7CJEp9PM86Z8NQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9uwM3JUN9iQM/GtNPFKpJvV40ATKTCl0snU8AFMro8c=;
 b=Mnb3/7nRDFU8JvH6YHt1JEwFK1Rg5hNv9WCyQZ+Y/b9kxZBxZ69CJkhsG0n6/csmuVlhNox8BhaW2Drj6m4RHD22HysTJSjnzAgVs2lAuWxp3I9NM1eb+9uA/x4Qsp305QY7C7E1mgw1gOy1Xp3dvvy5Ke6gDKLpKUgUjfQUI1cw9CsyY2LVcKaydfZoXszk715R/0RBwNsL4nmqnneQmEEpt98ZiZLePvyv2lpf5k+3dIaO6FqQzr3Q5p8jBndwSq4ScSbtmSBY7nUD4OEFDCO28OlLgjhgCF/Xz400gK+dI0xgvfx0g4JJ0gLdH00paD0bzsIcGL/3dqOc3JHP/Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by CH3PR12MB9098.namprd12.prod.outlook.com (2603:10b6:610:19e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.25; Wed, 21 Aug
 2024 17:37:25 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7875.023; Wed, 21 Aug 2024
 17:37:25 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	Joerg Roedel <jroedel@suse.de>,
	patches@lists.linux.dev,
	Vasant Hegde <vasant.hegde@amd.com>
Subject: [PATCH 07/14] iommu/amd: Remove amd_io_pgtable::pgtbl_cfg
Date: Wed, 21 Aug 2024 14:37:13 -0300
Message-ID: <7-v1-cdaaddf80abb+14190-amd_iopgtbl_jgg@nvidia.com>
In-Reply-To: <0-v1-cdaaddf80abb+14190-amd_iopgtbl_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL6PEPF00016417.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:22e:400:0:1004:0:5) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|CH3PR12MB9098:EE_
X-MS-Office365-Filtering-Correlation-Id: c2ad8e8c-b117-41ae-b03b-08dcc207e9d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Ma2pwy2v1YpPn4c5XHOxunhUUHumo7yl9wNDxUGdZ8rYYia55vkHILdT2N3d?=
 =?us-ascii?Q?Z2tX3YVcmHMDV4jPo1v5KNL704viQd8Wlhq41G2ALOd3rNWedhJkElNPxn1R?=
 =?us-ascii?Q?cXm8TKsvPTsjs1BJu/IrVKRskXITwIXgzNFgqVPgrbNVXo+jAuMkXzMmJsyP?=
 =?us-ascii?Q?8gsLIWhOQrFW4bRCCT9I9OOcp7ppxIh4uQTYx5cgvZEUzKLGVO8Gz44bDEJn?=
 =?us-ascii?Q?fpkhjVKTkQ5drT5h+KHhZEUk7xBu30tnGT9csXXmqGTthDaLdSWhNK5auXTS?=
 =?us-ascii?Q?R1rWNw5d7wfcCHlqZH6WTzsFpNjPE0nQVmTj4WY+oqYbL0EwhLu+w6si5thh?=
 =?us-ascii?Q?TA/2J7Gtnzbb1FktoIwAJhMrYkc5+AoqrtKw9Ut/8LLOzFiV6fhLts8cRNb8?=
 =?us-ascii?Q?Wi8kWyHfa0MWvfQ7SA8BVjvuXzI/FcMYtF5ri00sJsu/jxtOib/7Sm6b8lbx?=
 =?us-ascii?Q?/iWsAy8LHfIOEa50hS8tB/oN0ngMYLZZUrrnqfW4PlNoriADKslZQpU/qUOY?=
 =?us-ascii?Q?MxmdAjSpKTR1ij/ra5J6wcsltVdX2iYX7KEcyec7rF34yj5CerSG8KP/H3El?=
 =?us-ascii?Q?nLPr/OGLs8XLg7MikZHgISggsqUSaJzomqEw+ONQk29hOjW9IbbQAZEjdwoB?=
 =?us-ascii?Q?8ywHhUruyX+G2VKBCwBKLIeQJw0modhq1Bby81d7qW9HlBkFO3Y1ruBoo+iq?=
 =?us-ascii?Q?hbUZlhsIlSUcwD/FrSQnD14vgk2lNaWGl/vskifByBJQpo144f2ToWn1skpA?=
 =?us-ascii?Q?ApskdO9U7xSBjG1QHqRH+XHMsM5h4lU2mPKg1huGfQ6LPBbqvcb5b18LM/tx?=
 =?us-ascii?Q?rV8xO8Ve8ouzhvxhlgq81Ehn6576rfqtNT1KbCiLT5/pxHwV6ekk3/4j3Jtv?=
 =?us-ascii?Q?7Vw2LQ2X82NLolUfunJ3NYOz5UCrxvEj3j8gttA0OrkSnwrc0536Z3JNdR6i?=
 =?us-ascii?Q?clof/BzDEhPpJkcRBrJinBri0g6tlo2orO0ifs4TMuxaKdm90Dwy9xb3WCWs?=
 =?us-ascii?Q?Su6BZL9XJCESn/VdXR4rX+q/JJ38V7eGdKCOW0aI58h2m8oFkerSI811qIgY?=
 =?us-ascii?Q?sU/lglWUChrrKi3/2qyhmNVwf8US5Z7zxAUKqU1AnE4IyrAKgO1s0xHV0e4+?=
 =?us-ascii?Q?qmp9IDxaqhXXOHE+9l0XQ+c2lP9DsfUJYwrgsTSOdCXFOMDZ6rDxdBNSVZ6r?=
 =?us-ascii?Q?JkOyulRO7hFAJ3l9i24sGVZyN+rIb46pxWfEz9rVwQ077X8CtUYsnOB9T8md?=
 =?us-ascii?Q?ozA2ghuUrL9dADVUd90f50qSyh9fw0yjLCI8jeTxiTrUwWhyEw+fruUgFGTk?=
 =?us-ascii?Q?BIiYZUAcKiQXobYenN1giwLOMoXMZZrIZoNEVJQQFeGTvA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QhaEIG0hEG88Z4XzHNsq0shEurUNL+1E7hFvxv5Gwp0VUKh8tT/h37keo7mg?=
 =?us-ascii?Q?xVLlpg33AOv844WGmc4n3ZFCLi5Fu/FXDkaO8swkCPuNUDHTH8txvzlWXZB3?=
 =?us-ascii?Q?rI3Gw9WTlefKCXqgcKzsFmDdhq4d57Edq3xLI09Z3X6/KFe114Kg4CWHZpYq?=
 =?us-ascii?Q?otTQ6+GgsHIeNH9NgY1SdWP4LjWpqO7pEj8z2h9US3blfjB7dXhupCfrEQFI?=
 =?us-ascii?Q?JW2yvpCHTzvlD9jeX5eTjjDeMzkMis2M1XTWpmpB/nS44rK27OPjdmQ8TnAm?=
 =?us-ascii?Q?NfysX0RfQ+SJJ2zO6m2QOPrHfjoTrP12deIDKLListj0mSpQR7IfzwNkHq9h?=
 =?us-ascii?Q?HZLpBQiYPQ1Ps/OCC0l4MJeXybvve+PjbroO+vri57vT40xZCd+f4oscNxkJ?=
 =?us-ascii?Q?SYoEYph2Wcx8xgM+u5EPLmTFwS1O039VghL55Wh3L7Ox944tmNg13xtNgYKB?=
 =?us-ascii?Q?wJCHcVIkcASe99VELsxBAsQJjdhPppMCzRMAYEKCEP9o/qF+ye6ZzCRjivZb?=
 =?us-ascii?Q?oHNoUiioVMrRDhInzsAyIv+2yL3a3w5g1Fsg/fmFg3wJ+t2U7WKufB7OfPM2?=
 =?us-ascii?Q?J5pG8q/gomV1+gYj1qZPJr5WbVwae9WOzn4x+zjmuLIITrrePFA2iobjJuFK?=
 =?us-ascii?Q?AqIQtMyPQtSF7mtJPRkL2b6ZS+tsfAM+rmETF5xcZXmj7DnwG6a8SqbATyiW?=
 =?us-ascii?Q?MuZU+4cm8gHqDKauAA9PsxrlzWLiik3TE6HKtlrILJNi14NjX9YXywfQGs3a?=
 =?us-ascii?Q?tAJCcFL5EdPqqa7913VRTbgueGGqIQFciVU5xqid7JVw1Dshxw2FStWj3Myk?=
 =?us-ascii?Q?a+TnDfeZNA4yf2g9eceWUMw31nezF7n7unKlNoj/hI8dbbBVGDzMDKaqFwhJ?=
 =?us-ascii?Q?pnQ5mAYeWvqnU62810Nmt7g/ZXs4UDdj+UHVTb2AtuiHwpjNkKtwimq/ujDu?=
 =?us-ascii?Q?cIHcIEkdhCDfIfx1xA81AfF5ZzRHjbeHuJpxGlCmO6i8OtMukp73Tl6wa2cB?=
 =?us-ascii?Q?8KjYQ/gKuqd0rM3Wg1c4S26ne1c/nZije0LF1Bx3VCRNH8N64Zh0r5TIUKDN?=
 =?us-ascii?Q?afOZn5NPTQPQlYC0cwtiE+xOL6k04ZHjh1wwdBHFjEpyLFYtUGM86+FIdgPR?=
 =?us-ascii?Q?n3RcO7y4//yITe0udIm/8KJnFK8xwP03lYICyQczYS+whOkLR8wcVHDtixxx?=
 =?us-ascii?Q?Z2QxCBLKFZ6yLvO1u6ISsRxxv91B2m3+jZSSrHk2VyEohiGhDPDPvUPGFoYY?=
 =?us-ascii?Q?dg7CgcT+g/J6/K4lQFMEbl1W4/ILXvDmhqvLAhVGxqdNEl8Ux76NKJLXCTDa?=
 =?us-ascii?Q?chsCql3+L/wMvLcDTvHimx6VSYrxGwpsM7MTU1Pk3PcK/MgD6awVrJV2rrSW?=
 =?us-ascii?Q?HB0IQqybU0BGXPegtut0C7WMWpQc4zYibv/HRKSkezSUKu3b+eETqr7kXkPa?=
 =?us-ascii?Q?GSSpLjcbsAhe0E0f9MGTDvG7BW9201ofYSx7EI4uyDneCXbz/kIbmaHy5hAX?=
 =?us-ascii?Q?/zd02wIu629kDvbCZn22kgT/AKqaVwEjaZhNz//kBYUGpu8ID8S3Nlt2KZZ9?=
 =?us-ascii?Q?Km6uxKpXgfENI+hzypkFK6c07oh2rmiKmsUIamZ4?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2ad8e8c-b117-41ae-b03b-08dcc207e9d1
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2024 17:37:22.4107
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WE5Yz36GHWRmnQxTTCIGC6+eTwcaoq7odpPMYHPIDGY7qH1CCBP+a1hCujMv6nny
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9098

This struct is already in iop.cfg, we don't need two.

AMD is using this API sort of wrong, the cfg is supposed to be passed in
and then the allocation function will allocate ops memory and copy the
passed config into the new memory. Keep it kind of wrong and pass in the
cfg memory that is already part of the pagetable struct.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/amd_iommu_types.h | 3 +--
 drivers/iommu/amd/iommu.c           | 5 +++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/amd/amd_iommu_types.h b/drivers/iommu/amd/amd_iommu_types.h
index 90a2e4790bffdf..ef4c4887cbbbd5 100644
--- a/drivers/iommu/amd/amd_iommu_types.h
+++ b/drivers/iommu/amd/amd_iommu_types.h
@@ -537,7 +537,7 @@ struct amd_irte_ops;
 		     struct protection_domain, iop)
 
 #define io_pgtable_cfg_to_data(x) \
-	container_of((x), struct amd_io_pgtable, pgtbl_cfg)
+	container_of((x), struct amd_io_pgtable, pgtbl.cfg)
 
 struct gcr3_tbl_info {
 	u64	*gcr3_tbl;	/* Guest CR3 table */
@@ -547,7 +547,6 @@ struct gcr3_tbl_info {
 };
 
 struct amd_io_pgtable {
-	struct io_pgtable_cfg	pgtbl_cfg;
 	struct io_pgtable	pgtbl;
 	int			mode;
 	u64			*root;
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index e3e935b0fdf637..3840b3ede65d32 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2262,7 +2262,7 @@ void protection_domain_free(struct protection_domain *domain)
 
 	WARN_ON(!list_empty(&domain->dev_list));
 
-	if (domain->iop.pgtbl_cfg.tlb)
+	if (domain->iop.pgtbl.cfg.tlb)
 		free_io_pgtable_ops(&domain->iop.pgtbl.ops);
 
 	if (domain->id)
@@ -2320,7 +2320,8 @@ struct protection_domain *protection_domain_alloc(unsigned int type)
 		goto out_err;
 	}
 
-	pgtbl_ops = alloc_io_pgtable_ops(pgtable, &domain->iop.pgtbl_cfg, domain);
+	pgtbl_ops =
+		alloc_io_pgtable_ops(pgtable, &domain->iop.pgtbl.cfg, domain);
 	if (!pgtbl_ops)
 		goto out_err;
 
-- 
2.46.0

