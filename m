Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2084.outbound.protection.outlook.com [40.107.220.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F1E022069F
	for <patches@lists.linux.dev>; Mon,  9 Jun 2025 19:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749499124; cv=fail; b=kuBt9XeCAeR7rQxdmu+gRsvleCgTCnHT3R07UcwzfsMEJ8u6TbKdVeEpgGkV/aS+nnvvWNSIdidRB6afQzIW5OblBjFUxtKCThKmeLb4AlKlZm8YA9AL5o8dggXHnNNnO5udT7DSOFnjr00sJQ6NnhQMTgehwkUuqq9TvLDAHsQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749499124; c=relaxed/simple;
	bh=I0T3sXx0mO/rhLh6vPjKp7DlRw7djKSXfA/3b1N0ue0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=FoiMfJxCCLYDzgDGnmQxXE/nlS4fdM7JEorD/x8MGHphc2dfuXQD5BBKDW5k4vGBZ+Q9MCzLag0MjNxKQR5+GviwEOLQE/FllGPZgpdmslO+NyGZNH3FgtgasQYZ/GlCGrTYYXfVQJp30E9vmWEYvqecYj/o4fMU5CwxuUqSZv8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=bI60P5Nz; arc=fail smtp.client-ip=40.107.220.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="bI60P5Nz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DR6Gsgnzj0jE+vWU+rM2RNnMX2A87s5ezRTbqXg/+qaecBhmcVhYn8bSD5v6c9mV5FSlgZEwCFFixB6qHacHIEaYyntqaQsaeQTIYojKjacZxM7oaf38a5uMIGKqOr8AK5VCiZ1hH99JRzS4pxMYrtuzvL/WBL6PkQpGEApjbndTyC1Dnnmj+A7S1EM7Ylja/iSMuH92kDZwFZwPpS94bQR5gKmVsxNS+oOx4eBRjhmTooZNNgoZ0/mQ+6caw24YoUDj9+dYScLYNQ0HkCExXk/KOCKVVUkVhS75xPp4csO+TGWB2dy+/PH/vj8MQtVQXu+fY+bZxRCw6tczSrChDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jJHEgYmesB5hW3J8MyUIjUqx0De4o4mEJaG0LfYUdRA=;
 b=bX4dgMEmudnczwBsVFD+hui0RW/RIDRPcJK2R44FeQnd63+VCxAf/fwp5HQtQ5nX8RDArRj7oX02J0vvpcvCrgHu9mQhak7fDsDySxW98hIZuUTxTYB8s16MGmBH4DyIJEBfpjqtoKdD4RtMSfB01dlFKapCa5FkPodKvdcbF/p/v9QgiMTKrljlB3rxRVfol+uuG2fLGJ58tHXYFfsjUhzDWPGyWvjBsgn0dYwpT+IMssuqRrjXh6FbTgq2Brn8jPQgPAKpi4bMdgcL5yMYi8oZxU0UYsp10zg8VkjXlMRF32YOqBYcI+fXNmDUAPetD2+eTV3LXIB/kMJ9rFiHRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jJHEgYmesB5hW3J8MyUIjUqx0De4o4mEJaG0LfYUdRA=;
 b=bI60P5NzAg7FyPsKsEWXJJGmGilFhs/TG6arIitfpYpPhis8scHdcOAB9cC+laIdoFI/x9JnqPMKVoUWjANInyfk/XZWxWcWYaa5KXN8S9TNjDietoAjxw9T+JPyxfei6WkQRpMX9hbrdXSumqhHIDFaWCeTpgJBImr4zGcbStnYnjQbZCAShnpMvwCa3HgHE6Ym5Z53yzGvTt3pbK1XfQEHSt3fo+IvSkOETEiuZuNwZr1DyH8zC3vefJa1AEFNbk/Q5njd1v15KY6LP0P63aNnZzbeNituKn7ra2/DNY9Pk3AZtTF0U5I0LEOS2RI4hSqRlFGaUZVr+2jLwK4oag==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DS0PR12MB6414.namprd12.prod.outlook.com (2603:10b6:8:cd::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Mon, 9 Jun
 2025 19:58:34 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8792.038; Mon, 9 Jun 2025
 19:58:34 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: patches@lists.linux.dev,
	Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH 4/7] iommu/vtd: Split intel_iommu_domain_alloc_paging_flags()
Date: Mon,  9 Jun 2025 16:58:23 -0300
Message-ID: <4-v1-20c73f153f4c+1895-vtd_prep_jgg@nvidia.com>
In-Reply-To: <0-v1-20c73f153f4c+1895-vtd_prep_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0299.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10e::14) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DS0PR12MB6414:EE_
X-MS-Office365-Filtering-Correlation-Id: 30e14f13-ecba-47f6-f7c2-08dda7900177
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?s1Q1no7j4MW8myxxliIAb6TEF6N9B8AMOwsm51dR0TfpGbp3cncJnv+dFZt2?=
 =?us-ascii?Q?KCHThTcnYUzjxFmXO6UBZ+JnRaPk+XmmtVYI98ZlrFZRvnEFIgWSaph/l7Cx?=
 =?us-ascii?Q?7n5WKe4yWw9f0TKwFVrq1UQULpHFbALOOYu9k1JvpDxHlyRYVP/jWeC7o+2G?=
 =?us-ascii?Q?aZLzQI0SeWBXPhdtqli4YP9VZxkYNLsqF8YyjJtRSpEXO1LvLdM7pxg1lZJX?=
 =?us-ascii?Q?z4OMXpv8M1DwBMJrii2JW3gcKX+oj7MlUCeC3y7nzLgmLCfSTNvCpDuWmmnN?=
 =?us-ascii?Q?oUUwPDPX024CNEH48BQhvlsaWWkSYHWGTIxJLpk8AHy9+4J6GJiR8fsfEoDj?=
 =?us-ascii?Q?GC9vidT+2X0fGwwkj1hbMa5853/9TD7segWZVaXn9J9R0B6gh4aYy9awFFDq?=
 =?us-ascii?Q?N7HL5qLNb/eB04zluZ5z3GxRLsH8LT+L8+IqG4k5kSdoythC+opfGFqWPV1a?=
 =?us-ascii?Q?7rf4lgeLe6nTVY8+godRhw9Uh2l81Vk/lUGm/Z3AtT5TzA53BKXmta9Pl4ON?=
 =?us-ascii?Q?a9pOqkPbYMrHuA1B7MUxltM/MhnKZMuDKGy+HK/PRINPzm0ZTGbd7Cxho9/T?=
 =?us-ascii?Q?YlvrvrigsQGdfkxt8CkwF30N763n4FIog/C6oD9Btxz+/+j8qbbThQL6CuZe?=
 =?us-ascii?Q?8C5nvESDH/o5o79G5i12yNrh+ZbV/abkZ7xgCE6uNKGCQy2xhAh4Yy5NCWDP?=
 =?us-ascii?Q?vjn/EJXt/nrK4PS292Jpcx9dxzbafd0OoWFQU7zjvZnpVzgmHArWGKTe2VAw?=
 =?us-ascii?Q?edJVURJGbdfLan4A6AQNSgmGlXzNK+XoBUtMZdj4ONS8JNftbXDZaTnBTLW7?=
 =?us-ascii?Q?nRlDP1n7JqNor3lukhbjeGo86mctAu8o1AvWtBNceWoXXH++N0RB302Xx10d?=
 =?us-ascii?Q?AE5+jK5HfKW9R5+ZAR+uG5mF8d4fRyUrebrq4tkYbXbWVBYlFz1lcURBV0Kk?=
 =?us-ascii?Q?jWOKsuDxJTQMe9ZxRFcJ6S3tTzcgkMKy8b1e9DNYKmW2uqpGLSghCJ8EwnkK?=
 =?us-ascii?Q?HSu4g1tu96fYZoXqiNsdU67X2M6KIkeoojwd3OEeKkt8GooMPYKGTIE6l67J?=
 =?us-ascii?Q?OCM7Wq2YD3qYUwEk6xy/FfWa8xCoYQh8YbDllCwg9dMd/KnrdtmkbOu7E3sa?=
 =?us-ascii?Q?Q/OQ+WVlUpsKh2KyvWLNyOv7wTUpZZFpE1w25FmmrnO5lR2gi1p09vvzE2L8?=
 =?us-ascii?Q?jyhzDZmXAU83vFOSjrUS2DT8QLVgT3xEIearNPpCba7+Vl/8Q4OJ1V2lP9Tq?=
 =?us-ascii?Q?+Uae3Lpebwb13yFHfLYu9Q7AmiM0viDq/MwzInE+26TLvwJU4RXHPowUgKrF?=
 =?us-ascii?Q?IB64SWXtlbyu8ZXbU6xAp07ZirmH3dz3bJt30Ph+JJm8tn4Y87tHfF8ucbLp?=
 =?us-ascii?Q?dAhq1QD1Ht8CKFOTeoQ80FFmaGaHi0HYWxg/wAN87pAc18UOge3DrYI1bmq1?=
 =?us-ascii?Q?2y9WSjCcxwE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?c+wvGeAmk/hgZaEOZML8qYR17lnA1HSmODaEmoIXZrlND88k3kJ2g4vuZGRT?=
 =?us-ascii?Q?TqRifEZGsdmzMwrhQIVxzi7jJ7mojNhDfTTbbryGC4/9lh7c860FnWy8x+Hm?=
 =?us-ascii?Q?Oppf0E2YOMoRqZ18NlZGtdx+lk2UUgNOiPZLKPGnGxCEacB+dSDfUK6/o4b3?=
 =?us-ascii?Q?AIqx2t1wR1gy6hZ2M0HW0NgvqlnHRyIV9Cu6C8++AWpFB65hsQF4x7DRDyaw?=
 =?us-ascii?Q?t23mrLbudeLOXEuX+sazls8VQuvtoMrmaPWBpiPklg8ZE8zAUiJF0clgJHtp?=
 =?us-ascii?Q?mgAFkLBrvjV31EpTJi0T+MUzf1npTUfueYFDi6WG8GQcs3609um+N6Wsn8pY?=
 =?us-ascii?Q?Mbm2m9BPAnVRTvxLz42dtuVkGqfY/tCQ0yHNZArqVv9x/Y3a/LVeXGpVSC3D?=
 =?us-ascii?Q?Srf/SHziJOCx7PasYsWO7h2VfsCx1k/HrP2sKVUXguO+21vnWIJqiP+Iq25E?=
 =?us-ascii?Q?lcWT2cINkUyojjTbx3nvSViAoFiedZhxZcrdvTrSw5Qd6fQ09kDUbOpvdmLQ?=
 =?us-ascii?Q?/K5eBIKcRdsikBIQ+5dI5zov1x3m9jBzLR/fZlu8SGtuPGNU3HGs58jT5T0W?=
 =?us-ascii?Q?ulA97CBzHkflnEIte/O2II+VUuslDeW06qc5WiEERyC6StZCqPf65M1OaSov?=
 =?us-ascii?Q?iGjYjvulrdPPjia0ngWflKIpkqXiD19St1ZeEtWbTcH6O90yU/8JrDoEQ1L2?=
 =?us-ascii?Q?5CDfGLgUfmmAhEHBfzqNRjd3doaDGMe69fQ8ckJv1F6/HHpP4HJN/vSEyWu4?=
 =?us-ascii?Q?ZCfXvr2bF6QBAKuHzVOyrYAUNe3YCs1J4pagsjzoPC5ooGl+ziB9DtgEW+b5?=
 =?us-ascii?Q?m90Kx+yh0qe2+hPhZZVceBqVXdzVVIQr/nj1dx4semIKJnhMHsORC9MT2xFz?=
 =?us-ascii?Q?X4j8msjjeC3WDmwFxjod+54LZV9vvuX/NR3R4FlutWj69c/0VPbgTH6ibUsH?=
 =?us-ascii?Q?16yKKbh/oo9f76PeD9LMoX9bw95skMbELYTC6VUACGe6+wjf7EvpDGkEPeSa?=
 =?us-ascii?Q?hFFIdU0UpPfCjHlLCADIqQ0y/lsKIU7cVfRBRZhvK1OAsX7Sfd59PFczkHji?=
 =?us-ascii?Q?ivXfYMZODbkcjddZpL5Me1hYEEfhevQH2Bj6XPotHm8jY000Of6sL6BH6CWZ?=
 =?us-ascii?Q?rOnBPYgyVU7RUWEuBXSx4Iy2TNnF1WVpQvDD4Jsc6Jj/jO7j+0DMK6iHp1bK?=
 =?us-ascii?Q?baquwCqXivNBvDWIfsfAaWb0rLpr+jehaToIbPrZ3TntetaFSsJAKDN7S8m9?=
 =?us-ascii?Q?zmjKYjYyxCsAj6X7gI2kOfRsUu7D0jYEQiE4zJ+pv+63ukc1ZwzDKUf3HD4/?=
 =?us-ascii?Q?j8zzLMzEDCU6opbMMKfIMJRPVpwhFs/1u6p/kTeOTS2wfpG1KhaQ++deJ3I9?=
 =?us-ascii?Q?XatVuMUDjkgFcB5c7N9+VeTeqZLcTYujgHFbooIb3IzgO2zlNmr9AfXeujHJ?=
 =?us-ascii?Q?qe8esBUHITg7+MTYYGbrWTL4bPlpHBeTglkMbi73HBzvGcoOhYvQKrt6F5AU?=
 =?us-ascii?Q?sJM3kYkOtMnLEAHcp3IGIpNt8Ihbz9+boWMZbGkVMROiiSOiYAgjj6yP6SIU?=
 =?us-ascii?Q?QXxMCr1AFBUL6uyKeihQnYeeRG+41w/9fdxGiUqc?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30e14f13-ecba-47f6-f7c2-08dda7900177
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2025 19:58:29.9959
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nBWf4M4AhKjs0ax46KMyPLfvbtKFlShSQi640xz7rY6J4YnlCkmnwp6SoRW8krIB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6414

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
index 72b0769c391008..6987a46c2e8421 100644
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
+	/* Prefer fist stage if possible by default. */
+	domain = intel_iommu_domain_alloc_first_stage(dev, iommu, flags);
+	if (domain != ERR_PTR(-EOPNOTSUPP))
+		return domain;
+	return intel_iommu_domain_alloc_second_stage(dev, iommu, flags);
 }
 
 static void intel_iommu_domain_free(struct iommu_domain *domain)
-- 
2.43.0

