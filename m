Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2053.outbound.protection.outlook.com [40.107.220.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 713A92417F0;
	Thu, 12 Jun 2025 14:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749738709; cv=fail; b=U0XtawUcSFzVUYQGnjyH0YijFr8wDiKqq8IGk36uIgSn9TsNJYKEOmrxW+GwzPhOOm56/YUrKynsr/XOjhOFGxNpNG1npkDywWHaHMqutN9X9AFJU68cS5uhPp31576GBLFyGEd1zu1YfmKNIjNBpFk1H3YtzZPb+xqNVIprqIA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749738709; c=relaxed/simple;
	bh=j8exF/AslqXaD3ENkJFoykfK4BeCBSLvKKH6EoJlkXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hdWXdML50vsFclwN6A8HkAO9FrmTbp1PTWlFbtKw+eCbVgeub97pYGAFLbEKMtnrfpVgDbnJouAGBpSDfCCGEB1QiLWrB9T602aKWjc74Y7l8YeFcbDVmsaUquiFhjtUZ9nkaBZ7VBWb1rmvg6OGgElSbSRyooKZdH+fvYllWc4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=NHmFT6wF; arc=fail smtp.client-ip=40.107.220.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="NHmFT6wF"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NkJf2qCZdZ5i0taWN2nCcl+AGQ/pTGgu3h3flC4F2Nw86Sk8HohN9EBVnIGhBPDz+RkVwsx6+FqOdy/r/yL/dHSCOPFpyQEEl4TzFW94HYqoAIiIu3GvtMKbKOM5ERq/4URl/HiDsCQou2zHUTCxffaxFd+NUw+68hR3W38G2apwcdtuEkNjH3uqPON4g7ylUuElbkzn6zfhb3+AsNFcm2kJH3vVHEBFzJKzwz9bWgJw8b+8G/OQsDHAr/aCVc+EyvGDIIOS2uFhTbopNyUIQxqnxKxGhgzddZASp4Ou9s407RxVJYpYaVqSRF6ShX1C7ZxWMNqg/+TM7yHSjlACpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hqKmgLei1APHT5fmcEOsSfhn9nyH45NXzTCAj5xu75o=;
 b=eV8PHIk09YO1PViFevFN/vwoJT1EHib8mGAk0E6Q6QCC4EXKXmDr2vWEUK/IuY+G4L2LCgkmZpO/nJtV26z48h6kQx4CAOxXBmT8upwINgqCviFo9n8w2BKsuLMf0ArDKHbHFWiVQBUs4Ymc/hqsc1S4SAg/1FeMWkbD/ypmlHAcvFCxAnlutTw1UZsdkksih0yT6lAe+SJd894g+RKBARtgxLqsNqmLvmMv7ioXaSaMpv2AGZLYtvkHLnVXD9lDMeXO/6L6UDvs/Mx3CgCxOygRt1l0EtKU8Pzrk70onYqRHwggH9W+XS3xXUBxOWVDKluToQwMSUXOl4JAgy4e0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hqKmgLei1APHT5fmcEOsSfhn9nyH45NXzTCAj5xu75o=;
 b=NHmFT6wFuXoVSTj7JkS8+oNrzSLd0uS0UfUcGfcEGHlmzUpFQxzUKFn7qsHvj/fW0DrGOykMwn6xJf6NHRkt7PzDdfuWyDnhr8wVYyp6NPzyZToxLi6wpH4rxV/DQS8gz3X8lSzFAouhIRaV5aOVB42v6LXu5/K1x7w1APOTxjrDuLqqyfGMC+76RFAYb0mxUu/tHoz1Jxk6Wu6ZxQOsbX7H3uVwL3DeIupdCN3CldrqoAqIlIbfcfjSvTE4bb9oXcstYEUq+wlVm1+DV+wu6uHRyJKqhYxdd+7TA3q/7YrK3BefyMxi0L1deB+N728JZgoQSFfG+UcPsTYjk7QAdw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SJ2PR12MB9086.namprd12.prod.outlook.com (2603:10b6:a03:55f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.19; Thu, 12 Jun
 2025 14:31:41 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8792.038; Thu, 12 Jun 2025
 14:31:41 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: patches@lists.linux.dev,
	Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH v2 4/7] iommu/vt-d: Split intel_iommu_domain_alloc_paging_flags()
Date: Thu, 12 Jun 2025 11:31:36 -0300
Message-ID: <4-v2-e5c01fc5ce82+26216-vtd_prep_jgg@nvidia.com>
In-Reply-To: <0-v2-e5c01fc5ce82+26216-vtd_prep_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0324.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10a::24) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SJ2PR12MB9086:EE_
X-MS-Office365-Filtering-Correlation-Id: c8a68840-5edd-4ad2-2c8d-08dda9bdd88a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?sabMm6U5wfg9hzJ9gj+xUkg+jZnq9HPstytocZAVkXgg1cb7No//qgWWdE2v?=
 =?us-ascii?Q?9npbC8m78ASuJ50G6F+7Jve36qfIK2Gqv/HFK5hJBboFJgLaNrospgO3EzAs?=
 =?us-ascii?Q?WqZwHxuqs9QPxwKN0KjnSeQv3YgCCvSv0ZAaHlgKn2sGquSH/IdK37456qXJ?=
 =?us-ascii?Q?w8UyB929TljuQX/TDTlrS47t9KUOElm3+Efyf/C7a2ySn3YvpQN5UAuw4W6m?=
 =?us-ascii?Q?SPSNBfQKk+d9m5vKHvsSQ8N/0GazDo7gx+CXch1oJ9TPBJri0W4Pcl/qCF+i?=
 =?us-ascii?Q?GH/sxrf9ooBPU00FA3ybOOKzFaPTOejR2GscGhiI9ORZXMQXz2tNEP9n1jq8?=
 =?us-ascii?Q?nw6g3Yln/sNEhrvbXfQWQaSWxXSo+0weRzduNZvMClexo7T4OwFhAM2Gif6r?=
 =?us-ascii?Q?wflNcxs/4+uAsNd3fm725/maH8wqyhWX7Re7lPS8PKl/NrhiHMOHr0OFL4HQ?=
 =?us-ascii?Q?XhD9ppPGOFpr2O53QrBf7hdIQacALM7W4Z3hbI7is0AeIuCFXv/pP2DKnHOJ?=
 =?us-ascii?Q?aN98dWMKnWwI7Asotnnv2gbCuA/wGSkhQwz8e5r0h3SxNtSb2q+iAydcd0+F?=
 =?us-ascii?Q?37Q1fDO5yCcVdWn3kA6dZA6RRETyEcgi3XerNbojMzVl2U5jhf9i7GWMuWOQ?=
 =?us-ascii?Q?zE6xG1S9/fumEKrzz+VcyGmjlKacni+svOJ75b3Vf1ajiFL8QTSHY6+y9HZx?=
 =?us-ascii?Q?3hPcIHSkFP4G/BuU2g0f9cIyt4FKr+2wwRcbZSUQLA5mDhPgl2cVnw59eGDx?=
 =?us-ascii?Q?2zTlBkTkzyQxbLh0cmxU54djTXqqx/CnMJGQrDOhO8RBnQLuvF95ygYRxvlu?=
 =?us-ascii?Q?DxtC8f3RFlycCdmJCNk7O2byg1FSFssbwyXsV4g8DjnhZmDkNytDFSEiF5ft?=
 =?us-ascii?Q?QOAXwDQjAYnSfM7huEJTp3tNnqn5Cpraw5ArDV3PPUzDPPiTkbKxnXvnUGs3?=
 =?us-ascii?Q?cFQY2iSGqHFsdCWeI9k+A7vpaIYNi0xcEaNJA6mn/58y71dK+9GQXAc+cQvk?=
 =?us-ascii?Q?KPWeI1W3mYKN4uwm18m/FhXUa6fqglB2orc66ZgLI61yJKBZ7vN3iKQquhAy?=
 =?us-ascii?Q?6yAQHqAMpv2WXA+fETkSBfBysKLwJnuruMIl+5R1yYcHUpG8gOgwi/EVEFs3?=
 =?us-ascii?Q?1W42RYFkARlzt+jG8su6HBiHDbsUzGRQmG4aYEQ0fkmRfuJQaRjI3+EGdujw?=
 =?us-ascii?Q?z/3YHcyG+ipTMiw8SJYH7zh7OJ7YdlHZwbipHiSuMesDOt97jaIqy29E+uy3?=
 =?us-ascii?Q?Ay8KVsGr24R9axSebhG9Z/V+LlS5851rLqYRVauckmOPYx+M9qujGjpu1+pN?=
 =?us-ascii?Q?4nxPoPYD+V82FqN2TVCOcDtiOLofSOfccVrFVOKfZ9Cu7lQEhphaar1nVSsZ?=
 =?us-ascii?Q?FRYkRYKVL7Pptay0F/ez91Mb7ZcqVmYbq3/qM9s9BxnJfYqtfJvoNMXYiizI?=
 =?us-ascii?Q?0a3UoujDDBA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?iZn81XvXW7qr1GrQDxqfYaRg46Ix5cF0rTk3tAK0CoxVtXy1ZTCPJAzcDURf?=
 =?us-ascii?Q?No+yG40jZ68ZV36WJsyQd5GFiaGZb9FrWWWR9cvESaqEFEm7KsvVxzlWVoXM?=
 =?us-ascii?Q?6gyfH/Z209/uRm4ZUDn/tyOS9zkrT1sq7cBDU6PVjO31QBVcUuKRtYbzlXeh?=
 =?us-ascii?Q?n+RF8dcyBNM1kNs6dPnxSZkZRCq1fN5zy/xKa4sp+VWfRTvmcAECYC3I6DTb?=
 =?us-ascii?Q?ngQyoEj9d6qOqbFbcNfIXDSQpCZBEUM77DGn84OS/pOcngg3DLE+jEeFez5n?=
 =?us-ascii?Q?mAEYZvGMpz9Y+v8+umzoLxE/hK442fhmKmMUS4KYg3E9WOWlHOi3hO2GcpMM?=
 =?us-ascii?Q?OVq0yvByLkbpCYZqDjIR705M0R4uf85/y6Fyn1M4qYbS0LX4kGtDFQCWOIgY?=
 =?us-ascii?Q?HhkHPDyLGxfTc9X0yOn2FE9L/G9Mj19Wf9FVYWeb5unYvwMxiQ9OJBx2rHQ/?=
 =?us-ascii?Q?aUiH6DVUAopT4xJDv7EMRkNrPWoGkWunTYOkGH2y15GQ7F4NSLUOY90dHukN?=
 =?us-ascii?Q?wNLbw39dJBHaaepEduzLKTiDja/nBhkWPlKo2FmD5t+HtR0qtSWnBxjxrf4F?=
 =?us-ascii?Q?v9b+BybIO1h/1lD/uW2nq2jQ/G98Umre12vjzPxZp2a3RvC4F26L+7CrDI/X?=
 =?us-ascii?Q?3cQxHqeP2nWmnSNkR7E9GG87Nrz51ZJ6PFmQjrEMDZJVxR3L/V6Jcujs2kGt?=
 =?us-ascii?Q?6hsKupFxr5Iwytiaqw25wXN9tltbUd4V2zpEMkLTMW4bJ7RnCjkeJJMf3CJ2?=
 =?us-ascii?Q?02RjZ9kUSQGrxek4iqRRxPfwX7X3X5fBs6HnBAoO2yWYgBBjVKcjdnbC7gJW?=
 =?us-ascii?Q?UjatosFC7xK25BG4lO0jqQSDF3VAxkj/s8f/xFCp6U6kzxYJbQ4Jn2/DjtdU?=
 =?us-ascii?Q?daU4R4QyZ+EMBAViN8jFCJDq3y/6LUGpmWgY0G5WRzlXUCWbFU3SoeGFC+6E?=
 =?us-ascii?Q?7a+xCWK+kL7K1VxTNd5MuKETNdIwXONjbt4ZbUx2mrFLxuEWc5Zf+Vr34O2K?=
 =?us-ascii?Q?jvI2+fRbWZQ8h+h8T+y+x+zlFWAXPR47KSK1Ht3l7qKDtzEYUyR9CUmo7/yk?=
 =?us-ascii?Q?CocPSk9pfrI3A2+QFZMgN0yozg5wb8Se1FqS0MhAbUgyccRkQsDEIvsoOh/j?=
 =?us-ascii?Q?CdPuYBZ7fGmWZlVx7fJWqrXI4q0u1AW5wCnaWHlSCaI5uYy0rtZV9O4XJXme?=
 =?us-ascii?Q?lj7DcsbIV33FFtu4YIXYrBSj4mskM8bn6weP5P+IXGwsw7iKHMw4taXAemZp?=
 =?us-ascii?Q?keoO07JaqW0J97qXWZhR+qyhp+oOJ2tK6lgt4u/dS4h8yXnwGMbtutQ8lJLL?=
 =?us-ascii?Q?qiQ/+ETvzHSQdpAuZ0F7NpK+1XyHg7nzHHZu913nRNB8cOmjbbyHZy41scZ6?=
 =?us-ascii?Q?8l+woWqmFS3CIRk2WooL6kSnLR7wH8REnwkDhSACiPlkvKBn33CoGK0x1AIi?=
 =?us-ascii?Q?AKMyEWYVOD4kAC74Z6qlNY4KRTV+XELxHf5GZg+LYsRoAA9pgHYlCaeg9H0n?=
 =?us-ascii?Q?FmegNH9U39ItidLLFLXwBbbePL0sXJmFbz8qlZgbUcGHnBcHEtGTfi496ViB?=
 =?us-ascii?Q?/fzszKCT8Z/DqL9VgnViqO+VJzZA1YSPiZ0LhaZo?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8a68840-5edd-4ad2-2c8d-08dda9bdd88a
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2025 14:31:40.5959
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uhVbe1xio6X3l5vf9FX53izxdRBFaOjezXpBx40WlyEnus7z0Nmy1pFJB6rYXjo6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9086

Create stage specific functions that check the stage specific conditions
if each stage can be supported.

Have intel_iommu_domain_alloc_paging_flags() call both stages in sequence
until one does not return EOPNOTSUPP and prefer to use the first stage if
available and suitable for the requested flags.

Move second stage only operations like nested_parent and dirty_tracking
into the second stage function for clarity.

Move initialization of the iommu_domain members into paging_domain_alloc().

Drop initialization of domain->owner as the callers all do it.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/intel/iommu.c | 98 +++++++++++++++++++++----------------
 1 file changed, 57 insertions(+), 41 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 00079c3e49f078..243e77d5a06aac 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -3267,10 +3267,15 @@ static struct dmar_domain *paging_domain_alloc(struct device *dev, bool first_st
 	spin_lock_init(&domain->lock);
 	spin_lock_init(&domain->cache_lock);
 	xa_init(&domain->iommu_array);
+	INIT_LIST_HEAD(&domain->s1_domains);
+	spin_lock_init(&domain->s1_lock);
 
 	domain->nid = dev_to_node(dev);
 	domain->use_first_level = first_stage;
 
+	domain->domain.type = IOMMU_DOMAIN_UNMANAGED;
+	domain->domain.ops = intel_iommu_ops.default_domain_ops;
+
 	/* calculate the address width */
 	addr_width = agaw_to_width(iommu->agaw);
 	if (addr_width > cap_mgaw(iommu->cap))
@@ -3312,62 +3317,73 @@ static struct dmar_domain *paging_domain_alloc(struct device *dev, bool first_st
 }
 
 static struct iommu_domain *
-intel_iommu_domain_alloc_paging_flags(struct device *dev, u32 flags,
-				      const struct iommu_user_data *user_data)
+intel_iommu_domain_alloc_first_stage(struct device *dev,
+				     struct intel_iommu *iommu, u32 flags)
+{
+	struct dmar_domain *dmar_domain;
+
+	if (flags & (~IOMMU_HWPT_ALLOC_PASID))
+		return ERR_PTR(-EOPNOTSUPP);
+
+	/* Only SL is available in legacy mode */
+	if (!sm_supported(iommu) || !ecap_flts(iommu->ecap))
+		return ERR_PTR(-EOPNOTSUPP);
+
+	dmar_domain = paging_domain_alloc(dev, true);
+	if (IS_ERR(dmar_domain))
+		return ERR_CAST(dmar_domain);
+	return &dmar_domain->domain;
+}
+
+static struct iommu_domain *
+intel_iommu_domain_alloc_second_stage(struct device *dev,
+				      struct intel_iommu *iommu, u32 flags)
 {
-	struct device_domain_info *info = dev_iommu_priv_get(dev);
-	bool dirty_tracking = flags & IOMMU_HWPT_ALLOC_DIRTY_TRACKING;
-	bool nested_parent = flags & IOMMU_HWPT_ALLOC_NEST_PARENT;
-	struct intel_iommu *iommu = info->iommu;
 	struct dmar_domain *dmar_domain;
-	struct iommu_domain *domain;
-	bool first_stage;
 
 	if (flags &
 	    (~(IOMMU_HWPT_ALLOC_NEST_PARENT | IOMMU_HWPT_ALLOC_DIRTY_TRACKING |
 	       IOMMU_HWPT_ALLOC_PASID)))
 		return ERR_PTR(-EOPNOTSUPP);
-	if (nested_parent && !nested_supported(iommu))
-		return ERR_PTR(-EOPNOTSUPP);
-	if (user_data || (dirty_tracking && !ssads_supported(iommu)))
+
+	if (((flags & IOMMU_HWPT_ALLOC_NEST_PARENT) &&
+	     !nested_supported(iommu)) ||
+	    ((flags & IOMMU_HWPT_ALLOC_DIRTY_TRACKING) &&
+	     !ssads_supported(iommu)))
 		return ERR_PTR(-EOPNOTSUPP);
 
-	/*
-	 * Always allocate the guest compatible page table unless
-	 * IOMMU_HWPT_ALLOC_NEST_PARENT or IOMMU_HWPT_ALLOC_DIRTY_TRACKING
-	 * is specified.
-	 */
-	if (nested_parent || dirty_tracking) {
-		if (!sm_supported(iommu) || !ecap_slts(iommu->ecap))
-			return ERR_PTR(-EOPNOTSUPP);
-		first_stage = false;
-	} else {
-		first_stage = first_level_by_default(iommu);
-	}
+	/* Legacy mode always supports second stage */
+	if (sm_supported(iommu) && !ecap_slts(iommu->ecap))
+		return ERR_PTR(-EOPNOTSUPP);
 
-	dmar_domain = paging_domain_alloc(dev, first_stage);
+	dmar_domain = paging_domain_alloc(dev, false);
 	if (IS_ERR(dmar_domain))
 		return ERR_CAST(dmar_domain);
-	domain = &dmar_domain->domain;
-	domain->type = IOMMU_DOMAIN_UNMANAGED;
-	domain->owner = &intel_iommu_ops;
-	domain->ops = intel_iommu_ops.default_domain_ops;
 
-	if (nested_parent) {
-		dmar_domain->nested_parent = true;
-		INIT_LIST_HEAD(&dmar_domain->s1_domains);
-		spin_lock_init(&dmar_domain->s1_lock);
-	}
+	dmar_domain->nested_parent = flags & IOMMU_HWPT_ALLOC_NEST_PARENT;
 
-	if (dirty_tracking) {
-		if (dmar_domain->use_first_level) {
-			iommu_domain_free(domain);
-			return ERR_PTR(-EOPNOTSUPP);
-		}
-		domain->dirty_ops = &intel_dirty_ops;
-	}
+	if (flags & IOMMU_HWPT_ALLOC_DIRTY_TRACKING)
+		dmar_domain->domain.dirty_ops = &intel_dirty_ops;
 
-	return domain;
+	return &dmar_domain->domain;
+}
+
+static struct iommu_domain *
+intel_iommu_domain_alloc_paging_flags(struct device *dev, u32 flags,
+				      const struct iommu_user_data *user_data)
+{
+	struct device_domain_info *info = dev_iommu_priv_get(dev);
+	struct intel_iommu *iommu = info->iommu;
+	struct iommu_domain *domain;
+
+	if (user_data)
+		return ERR_PTR(-EOPNOTSUPP);
+
+	/* Prefer first stage if possible by default. */
+	domain = intel_iommu_domain_alloc_first_stage(dev, iommu, flags);
+	if (domain != ERR_PTR(-EOPNOTSUPP))
+		return domain;
+	return intel_iommu_domain_alloc_second_stage(dev, iommu, flags);
 }
 
 static void intel_iommu_domain_free(struct iommu_domain *domain)
-- 
2.43.0

