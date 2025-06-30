Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2073.outbound.protection.outlook.com [40.107.93.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3782A28C2D3;
	Mon, 30 Jun 2025 15:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751295855; cv=fail; b=TLHpN2X5MSG7Ri7WBOT1CUotzP7Pmu2YZR2pgg3nf6jDryXW9Rf8tz+xJVHQ/1wtfWZ8RJT5D/UAZ5uvEHImQBlX7fcdCaWzgJEwHV3Xa80obzqB3VzBbZS/1otDPepwRhba9zo1FajpQ/cRTLejv3abEM5Lg1gNJMHXejUeWsY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751295855; c=relaxed/simple;
	bh=IjPcCY167N/BFJymAIU9v0O1nk/pU+wZob8w41eB9N8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=acys7bfP7MfhCQKbytoDwMrhyORZkbX7NauPARI5PNo3i/Q3FSPMcv+3iFx5kx22KEgx2rco7srvD9NcX/zWDVOi29Gw5uyK2p58htxthCWkeXtm5OhdWynGPHzwQGI2WsVqhKinC6YSbqBtpZjdGpVmUk+ZpK5lngHdJHvcaAc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=AexQR9mU; arc=fail smtp.client-ip=40.107.93.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="AexQR9mU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=auDXNul/6eVDAKx48m0ru/XQvPszC0SPVh6qujbat0xAA+AdwgoFMcH7mNEKYoIuDaBZtkcDFVfc/o3U7sDigJ0skRkDjc0wbtzjKoAsEHawgZKC+TwD9yVEMiwYDBjCwiQSyzPpKhpyy3M12xbvxqVegSSLxYDEWaPRxJa52y8a7Ftu2GAzJVZsQ2xpYdiAbkjnkiSKMCFczV7Z/s8emykYqGyPZKBpFYgUq8MQRw/E+2q6cF6N3r2XxAFaaNv/XAiTCM/r+IEqVs+dQZVwDR9D4kD6FAHqaoPKQm2SH39eHYTdYv6JlLesUzUYDi9hJyLFEZLnKiCFbxZni2+7CQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZDmkR0gID5rbOx4X7FvZC1Fr7wINyLAbWiZLN93Ad5I=;
 b=kbqDCaNxmpOfBj6PlyWeqU4ztZkIcrHan0q+RtFTrhozKoNUzYYK5erZpgcaXZVlkO8PQ8PSH5EtbUGddzxe4dEIm7eO1Dn35d2ZWGPChe0ilQ16m0Rm8T8ruAYMB2Ctv/1HYM5vTY8F7iP1Vvj39oF3ZhBnk+nHQk7JNVGjcT2cNQGwvPT3qOOIm8lmrjloCf/3j928Rn+kjzRrvbHaGq2LZI7p4cs3LhUWYFkww+qZ9xp2aNxsgLAkThMBB+4gvYBc5kX17gl1h78SauYaxcNA6QAB8xNstoByjJwXCb7cE6/gkBgTzL6te9RVR1RIfP00blzoA4fLrMbm/v7i+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZDmkR0gID5rbOx4X7FvZC1Fr7wINyLAbWiZLN93Ad5I=;
 b=AexQR9mUxmI0fgSCk3x4lQC9uxjfak2XypDgNqQG4rokxkz/2L5Dy9x4ETfUaiTSygZ9nVKVCBpcko4lkzqAace0hV7r4AoKckyGQ6BsoulVr/BbDWdJ4fAnzjC1E5WOhWEoGDWEKGla8OYJ7jzkt+CBHjQ1Qu4qXat07w+J1PJykyjQW/e7IxnAIbBZPtv3r21M8GN5/Hnpsg5HQ8Q6QccqktZhBCQh3ITz7mA/RBhdv4NNpzkU/Q8Wv4QERgGfKOwzDNMJHLE1w0DWNIYTwHKHkao/2V48uUXo+SLQ23aZO3JfrE5SllURlSaWt3ahUbVGXQ0T9+1XJ5kwnB7kpw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by LV8PR12MB9643.namprd12.prod.outlook.com (2603:10b6:408:297::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.17; Mon, 30 Jun
 2025 15:04:05 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8880.030; Mon, 30 Jun 2025
 15:04:05 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Kevin Tian <kevin.tian@intel.com>,
	patches@lists.linux.dev,
	Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH v3 5/7] iommu/vt-d: Create unique domain ops for each stage
Date: Mon, 30 Jun 2025 12:03:55 -0300
Message-ID: <5-v3-dbbe6f7e7ae3+124ffe-vtd_prep_jgg@nvidia.com>
In-Reply-To: <0-v3-dbbe6f7e7ae3+124ffe-vtd_prep_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0028.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::41) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|LV8PR12MB9643:EE_
X-MS-Office365-Filtering-Correlation-Id: 8acb8fe1-0c2d-4aa8-32ce-08ddb7e75aca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0Wlc5w4VU3oCoi6DwlsqsLFcuvhB83Hb1PY+fZ1nlfA0NFiGx67xWNZYVRah?=
 =?us-ascii?Q?OwZHqJHVDdakl3XgaG+JOmmEvhDFP5dwt5XZ4odc1P682TCbIrd0BddoO1LN?=
 =?us-ascii?Q?KnnZxK8GtzRReNooUoN62xBqf/lvwKSIR0SAo8QOPxn3i86xAbBo84YvoZWp?=
 =?us-ascii?Q?6uX205eLkLrZMNP1N2zU3xGhk2Sb5OEgOIyUlukGkuDwngNv46OgL+QxoL4S?=
 =?us-ascii?Q?4RFQogWf0B1ojp1lNtC+H7SzPaC0g4kMz51ujCMwIUIfqTyBiUQ/XnY6K6fT?=
 =?us-ascii?Q?c9mIojt1mbnWAjDUR7Q1C2Rt6QN2HzDSp2tyvKacm3rRbAT+feVT2iPlfoFB?=
 =?us-ascii?Q?YStVe3NclnpfayWUFmumvWMt8wpgcv7OqPzCGT4mYkV/GS1qweykg2mwm0+8?=
 =?us-ascii?Q?u5P5mQ4RMClGlF06usJm2itBa2OUqLBlj3ZMMtM/oL82HzhsLq9Fs+NUyHkM?=
 =?us-ascii?Q?Rf97+SYpZLS7OG0kY8zeIGeCWasvYDLQFIAo/sCPS+YyLId231BfajThGARe?=
 =?us-ascii?Q?mdTPwji9+AFulE8oP5tWBjE1SgOv6MMBBo3NB9OchD/N/BvFpt4s+XiVrU9/?=
 =?us-ascii?Q?T/pjSkagQrAhup/R+RwEFx0eUYWSQXpKu7FblbaZeKj5tjNb03n1bdJgs3ZD?=
 =?us-ascii?Q?ob6eYpni42MAyHwTDOjuMW8iTg04flTRr/t4ozbFx6XVAguZba7QtHVbe3XZ?=
 =?us-ascii?Q?h6GcDtXwb7TK/+AJFTYmgPPLQus6SjwzBtFWrfexpBwN8VF1ywFP/+DyfH6c?=
 =?us-ascii?Q?AQ969rDuBhkGhUFpfDBy6MFyxaXsz2AHJp5zdWLagQao36+VSzKPhiAkSx8i?=
 =?us-ascii?Q?ekrLyhOD+70rfC+bPBjJzNwkDGh9Ksd+f4qY6icM64QFLlYOgdvf9qhFOa5F?=
 =?us-ascii?Q?tYKWDFPXzeljUw8SmwQ1r2wL2nEmJ5aDWlrLeRo8jNFZONhD+0JOLtNZ5PAV?=
 =?us-ascii?Q?mCDhJY9cExFL9ISEdG3KyCQaJnZLzRINps8gAcZuYNVG+Dd6QbDBzk2/+b7q?=
 =?us-ascii?Q?huebsdoi1LRncK0GYa4ysM2alKw5bNBrsFOzpLHtP48bqLmzRlvZGBDeGe9R?=
 =?us-ascii?Q?+HGu5rL8YniMxDtl/aMA0DdPBEMnWBZZk74O1z50ZqDHFT8NJFB06iz0q3lb?=
 =?us-ascii?Q?mMg30EinGvA1ro8pf6/IXZ8lonBs6s/IzYOIQtfaWk4dHqbMctOS0CcuSY5X?=
 =?us-ascii?Q?QrXWHJDfgkAC08i9ncQMvSi2O9zuEVMZcsEVcGLcFW3QlWAbq4Ymf7ykec0J?=
 =?us-ascii?Q?fHa9wt8KEaUbux8rsERqsNHDapko+mH4U9eu3HEmb8eLhUR3WMujgjQKUEOz?=
 =?us-ascii?Q?upajVfFjerKvj1+KuqP5xbti9ckKxANSmbPhfUJCsD75k8zFv+DFTdwE19vG?=
 =?us-ascii?Q?gR5PyMRzO7LwDL4Ts5DFG0S3UyO3AlJmPm5+LISonWJoSHyEtLERgowmvjGv?=
 =?us-ascii?Q?4F1evBYn4r4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zSI0k1T04IhgHhTFalGJ4INATRA8mvtfBcEsLMz3ZlbQgE1zBDl3BBbok/jR?=
 =?us-ascii?Q?gFeRgsyKrFZL2aAa8PKMdXOvouIEjwnfWsKSqqTm8u4oVqfAM7n9pdmeKuql?=
 =?us-ascii?Q?YZdDNPU+/3xd+H5JmlP0L4HRFttaS9QjeHSbr4vo8mW+G5c0Z/ISz96wERDS?=
 =?us-ascii?Q?SL88+E9KyOMAzwC1zcleuoOcQ5yeCWkDbD11Yz2FWy538TUAqAXkVp+KI9id?=
 =?us-ascii?Q?FoXOIpItqLYGU8hkDO4pt9kR/NoTobETBdZJbkJU4g8ri4XVA2biZsinDSb1?=
 =?us-ascii?Q?KhZ1QdrjcT2zLuiqsADQl73mZptImtxHsyF6SqwCazgewLn5EMPf9s6AMHt4?=
 =?us-ascii?Q?dgv+1ZE+D+zBLM5uIwUxXQRgn9e7T8CMcZkcI/hGLiQRLTGVenxqB1cekMl7?=
 =?us-ascii?Q?VCVwtBrkkFS/efkw63fvZ/hPLP/vjdPnBHHLvOhZf7I2INrXS+275p7L7OyP?=
 =?us-ascii?Q?yWG9c/J0/2cwzPvUIy3GymIQ99kMUi785ZMG4j4lKNBzoOq++aamseJbbD8k?=
 =?us-ascii?Q?JI43/iltk5asgFycyQNoGWQtZ21UF8DY4eS2XRiJim/VAGasNLaqIFCscXLJ?=
 =?us-ascii?Q?KpjtRnJF+P94LE9VrDJQTcrXH99sOLctI8EvOqWlrM0Z+kpV08bwG80BLKAi?=
 =?us-ascii?Q?8O+CSs4QCI3kCQ5rp0wZAzEAJCYHMWOZ5u0mDR5JebIo+2gn9nc9rYj+CXqx?=
 =?us-ascii?Q?Pb1XWWUJ9qWnKRZywo4UK222Jq0FyqC/0uvPSrYAaql7RZIRImPKiPPPsjkI?=
 =?us-ascii?Q?w1syQM9NX2s2oNHLTU74p412+5PyXlWbJHdj1wcZMSrvWr/Lq/oVtEMXfUHV?=
 =?us-ascii?Q?lsI8Bk0LTMaSvpInAxQQM9UVTDGyeNI74/uDA3o73mStBz7yGNNK3NL7MZJo?=
 =?us-ascii?Q?d8xD92503jipOtexxtHeKdA5kA3nbX/o12ytgxB7Teau6L6GLnDdh2enIkTV?=
 =?us-ascii?Q?2zrz5b98uQpCTr5i9zRXvXMHllZ9JMEa0smduOl/O0VaLRjtDqU+ej1ZWkx+?=
 =?us-ascii?Q?YUjNXm44YbTvSCxrtqoHPuucSE66coRtiRoFueXlFP+60sS47U62yWZmeCZ5?=
 =?us-ascii?Q?0FNCGQ5aA8rF4j3LD0gFCC3OWmeVHGyWDgBlHUKoGJCMu3/aCUzZ1AQ85+em?=
 =?us-ascii?Q?ZE7B0FHxg5u16ei0nLiAk+mntGzdplKkqtIejfUtrmLhssDoa2bK0/oDohvX?=
 =?us-ascii?Q?PfWUenEnOl7dYKZf53rv9ZP/WQU6R9u0DHLF20GCfbFISG7zH0dC1muHY/Vw?=
 =?us-ascii?Q?DQjQk+vUaH15LhrGKwcjlCxnynZOlnD0u2E/VeGWw14eaC++8oXx81kghp7r?=
 =?us-ascii?Q?3z3T7chU8acixYSzZYqhh+47nFeGGPyKKyZPZbZKFIgxqlGzRaOwLYGaoGUN?=
 =?us-ascii?Q?YohfJYxwIFk10vZa/w/kME4yrfbYSvjRjYwn1WuFyqG2k8uvDBSt2zsihoz5?=
 =?us-ascii?Q?q59IMmzYbVkPB8YzNh0ayCajI6jTAZPCwN4DaQEt1vR/1ROBYu8dyIbciT5b?=
 =?us-ascii?Q?vmQOQYkcJye71qYKPiJj+T04izpOcg9ooNvxnTzgopEkD64lOrprsWl/LNuf?=
 =?us-ascii?Q?UySxSagvAt73y2zFuXdZfXctRNuIMHl1IOefuElU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8acb8fe1-0c2d-4aa8-32ce-08ddb7e75aca
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2025 15:04:05.1758
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7C68Btjvxk3yym3MU4JQai6JwqDfqf6xM7FG7//wwPxH1TDx7cPXpd+MQWhDFJ6v
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9643

Use the domain ops pointer to tell what kind of domain it is instead of
the internal use_first_level indication. This also protects against
wrongly using a SVA/nested/IDENTITY/BLOCKED domain type in places they
should not be.

The only remaining uses of use_first_level outside the paging domain are in
paging_domain_compatible() and intel_iommu_enforce_cache_coherency().

Thus, remove the useless sets of use_first_level in
intel_svm_domain_alloc() and intel_iommu_domain_alloc_nested(). None of
the unique ops for these domain types ever reference it on their call
chains.

Add a WARN_ON() check in domain_context_mapping_one() as it only works
with second stage.

This is preparation for iommupt which will have different ops for each of
the stages.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/intel/cache.c  |  5 ++--
 drivers/iommu/intel/iommu.c  | 58 +++++++++++++++++++++++++-----------
 drivers/iommu/intel/iommu.h  | 12 ++++++++
 drivers/iommu/intel/nested.c |  4 +--
 drivers/iommu/intel/svm.c    |  1 -
 5 files changed, 57 insertions(+), 23 deletions(-)

diff --git a/drivers/iommu/intel/cache.c b/drivers/iommu/intel/cache.c
index fc35cba5914532..f8bcc5f674630d 100644
--- a/drivers/iommu/intel/cache.c
+++ b/drivers/iommu/intel/cache.c
@@ -371,7 +371,7 @@ static void cache_tag_flush_iotlb(struct dmar_domain *domain, struct cache_tag *
 	struct intel_iommu *iommu = tag->iommu;
 	u64 type = DMA_TLB_PSI_FLUSH;
 
-	if (domain->use_first_level) {
+	if (intel_domain_is_fs_paging(domain)) {
 		qi_batch_add_piotlb(iommu, tag->domain_id, tag->pasid, addr,
 				    pages, ih, domain->qi_batch);
 		return;
@@ -546,7 +546,8 @@ void cache_tag_flush_range_np(struct dmar_domain *domain, unsigned long start,
 			qi_batch_flush_descs(iommu, domain->qi_batch);
 		iommu = tag->iommu;
 
-		if (!cap_caching_mode(iommu->cap) || domain->use_first_level) {
+		if (!cap_caching_mode(iommu->cap) ||
+		    intel_domain_is_fs_paging(domain)) {
 			iommu_flush_write_buffer(iommu);
 			continue;
 		}
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 243e77d5a06aac..d32dc0c301633c 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -1462,6 +1462,9 @@ static int domain_context_mapping_one(struct dmar_domain *domain,
 	struct context_entry *context;
 	int ret;
 
+	if (WARN_ON(!intel_domain_is_ss_paging(domain)))
+		return -EINVAL;
+
 	pr_debug("Set context mapping for %02x:%02x.%d\n",
 		bus, PCI_SLOT(devfn), PCI_FUNC(devfn));
 
@@ -1800,12 +1803,14 @@ static int dmar_domain_attach_device(struct dmar_domain *domain,
 
 	if (!sm_supported(iommu))
 		ret = domain_context_mapping(domain, dev);
-	else if (domain->use_first_level)
+	else if (intel_domain_is_fs_paging(domain))
 		ret = domain_setup_first_level(iommu, domain, dev,
 					       IOMMU_NO_PASID, NULL);
-	else
+	else if (intel_domain_is_ss_paging(domain))
 		ret = domain_setup_second_level(iommu, domain, dev,
 						IOMMU_NO_PASID, NULL);
+	else if (WARN_ON(true))
+		ret = -EINVAL;
 
 	if (ret)
 		goto out_block_translation;
@@ -3274,7 +3279,6 @@ static struct dmar_domain *paging_domain_alloc(struct device *dev, bool first_st
 	domain->use_first_level = first_stage;
 
 	domain->domain.type = IOMMU_DOMAIN_UNMANAGED;
-	domain->domain.ops = intel_iommu_ops.default_domain_ops;
 
 	/* calculate the address width */
 	addr_width = agaw_to_width(iommu->agaw);
@@ -3332,6 +3336,8 @@ intel_iommu_domain_alloc_first_stage(struct device *dev,
 	dmar_domain = paging_domain_alloc(dev, true);
 	if (IS_ERR(dmar_domain))
 		return ERR_CAST(dmar_domain);
+
+	dmar_domain->domain.ops = &intel_fs_paging_domain_ops;
 	return &dmar_domain->domain;
 }
 
@@ -3360,6 +3366,7 @@ intel_iommu_domain_alloc_second_stage(struct device *dev,
 	if (IS_ERR(dmar_domain))
 		return ERR_CAST(dmar_domain);
 
+	dmar_domain->domain.ops = &intel_ss_paging_domain_ops;
 	dmar_domain->nested_parent = flags & IOMMU_HWPT_ALLOC_NEST_PARENT;
 
 	if (flags & IOMMU_HWPT_ALLOC_DIRTY_TRACKING)
@@ -4081,12 +4088,15 @@ static int intel_iommu_set_dev_pasid(struct iommu_domain *domain,
 	if (ret)
 		goto out_remove_dev_pasid;
 
-	if (dmar_domain->use_first_level)
+	if (intel_domain_is_fs_paging(dmar_domain))
 		ret = domain_setup_first_level(iommu, dmar_domain,
 					       dev, pasid, old);
-	else
+	else if (intel_domain_is_ss_paging(dmar_domain))
 		ret = domain_setup_second_level(iommu, dmar_domain,
 						dev, pasid, old);
+	else if (WARN_ON(true))
+		ret = -EINVAL;
+
 	if (ret)
 		goto out_unwind_iopf;
 
@@ -4361,6 +4371,32 @@ static struct iommu_domain identity_domain = {
 	},
 };
 
+const struct iommu_domain_ops intel_fs_paging_domain_ops = {
+	.attach_dev = intel_iommu_attach_device,
+	.set_dev_pasid = intel_iommu_set_dev_pasid,
+	.map_pages = intel_iommu_map_pages,
+	.unmap_pages = intel_iommu_unmap_pages,
+	.iotlb_sync_map = intel_iommu_iotlb_sync_map,
+	.flush_iotlb_all = intel_flush_iotlb_all,
+	.iotlb_sync = intel_iommu_tlb_sync,
+	.iova_to_phys = intel_iommu_iova_to_phys,
+	.free = intel_iommu_domain_free,
+	.enforce_cache_coherency = intel_iommu_enforce_cache_coherency,
+};
+
+const struct iommu_domain_ops intel_ss_paging_domain_ops = {
+	.attach_dev = intel_iommu_attach_device,
+	.set_dev_pasid = intel_iommu_set_dev_pasid,
+	.map_pages = intel_iommu_map_pages,
+	.unmap_pages = intel_iommu_unmap_pages,
+	.iotlb_sync_map = intel_iommu_iotlb_sync_map,
+	.flush_iotlb_all = intel_flush_iotlb_all,
+	.iotlb_sync = intel_iommu_tlb_sync,
+	.iova_to_phys = intel_iommu_iova_to_phys,
+	.free = intel_iommu_domain_free,
+	.enforce_cache_coherency = intel_iommu_enforce_cache_coherency,
+};
+
 const struct iommu_ops intel_iommu_ops = {
 	.blocked_domain		= &blocking_domain,
 	.release_domain		= &blocking_domain,
@@ -4379,18 +4415,6 @@ const struct iommu_ops intel_iommu_ops = {
 	.def_domain_type	= device_def_domain_type,
 	.pgsize_bitmap		= SZ_4K,
 	.page_response		= intel_iommu_page_response,
-	.default_domain_ops = &(const struct iommu_domain_ops) {
-		.attach_dev		= intel_iommu_attach_device,
-		.set_dev_pasid		= intel_iommu_set_dev_pasid,
-		.map_pages		= intel_iommu_map_pages,
-		.unmap_pages		= intel_iommu_unmap_pages,
-		.iotlb_sync_map		= intel_iommu_iotlb_sync_map,
-		.flush_iotlb_all        = intel_flush_iotlb_all,
-		.iotlb_sync		= intel_iommu_tlb_sync,
-		.iova_to_phys		= intel_iommu_iova_to_phys,
-		.free			= intel_iommu_domain_free,
-		.enforce_cache_coherency = intel_iommu_enforce_cache_coherency,
-	}
 };
 
 static void quirk_iommu_igfx(struct pci_dev *dev)
diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
index ca6843973d4393..2538da6c800959 100644
--- a/drivers/iommu/intel/iommu.h
+++ b/drivers/iommu/intel/iommu.h
@@ -1375,6 +1375,18 @@ struct context_entry *iommu_context_addr(struct intel_iommu *iommu, u8 bus,
 					 u8 devfn, int alloc);
 
 extern const struct iommu_ops intel_iommu_ops;
+extern const struct iommu_domain_ops intel_fs_paging_domain_ops;
+extern const struct iommu_domain_ops intel_ss_paging_domain_ops;
+
+static inline bool intel_domain_is_fs_paging(struct dmar_domain *domain)
+{
+	return domain->domain.ops == &intel_fs_paging_domain_ops;
+}
+
+static inline bool intel_domain_is_ss_paging(struct dmar_domain *domain)
+{
+	return domain->domain.ops == &intel_ss_paging_domain_ops;
+}
 
 #ifdef CONFIG_INTEL_IOMMU
 extern int intel_iommu_sm;
diff --git a/drivers/iommu/intel/nested.c b/drivers/iommu/intel/nested.c
index fc312f649f9ef0..1b6ad9c900a5ad 100644
--- a/drivers/iommu/intel/nested.c
+++ b/drivers/iommu/intel/nested.c
@@ -216,8 +216,7 @@ intel_iommu_domain_alloc_nested(struct device *dev, struct iommu_domain *parent,
 	/* Must be nested domain */
 	if (user_data->type != IOMMU_HWPT_DATA_VTD_S1)
 		return ERR_PTR(-EOPNOTSUPP);
-	if (parent->ops != intel_iommu_ops.default_domain_ops ||
-	    !s2_domain->nested_parent)
+	if (!intel_domain_is_ss_paging(s2_domain) || !s2_domain->nested_parent)
 		return ERR_PTR(-EINVAL);
 
 	ret = iommu_copy_struct_from_user(&vtd, user_data,
@@ -229,7 +228,6 @@ intel_iommu_domain_alloc_nested(struct device *dev, struct iommu_domain *parent,
 	if (!domain)
 		return ERR_PTR(-ENOMEM);
 
-	domain->use_first_level = true;
 	domain->s2_domain = s2_domain;
 	domain->s1_cfg = vtd;
 	domain->domain.ops = &intel_nested_domain_ops;
diff --git a/drivers/iommu/intel/svm.c b/drivers/iommu/intel/svm.c
index 8c0bed36c58777..e147f71f91b722 100644
--- a/drivers/iommu/intel/svm.c
+++ b/drivers/iommu/intel/svm.c
@@ -214,7 +214,6 @@ struct iommu_domain *intel_svm_domain_alloc(struct device *dev,
 		return ERR_PTR(-ENOMEM);
 
 	domain->domain.ops = &intel_svm_domain_ops;
-	domain->use_first_level = true;
 	INIT_LIST_HEAD(&domain->dev_pasids);
 	INIT_LIST_HEAD(&domain->cache_tags);
 	spin_lock_init(&domain->cache_lock);
-- 
2.43.0

