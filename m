Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2084.outbound.protection.outlook.com [40.107.220.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EDF121E0BE;
	Mon,  9 Jun 2025 19:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749499127; cv=fail; b=E564Y/ZW53n5kjX4jErcOlYJU+bjDHQfMphmSMwsF3CMaFGFOIkXsnNKG9lgsnOJYAm9c0JwvbcBrVs2lqHfVmYCB3snU6Kz5xs4CyeWZdE8zFZJnEn4whR9Kar1OwnRtt/XjQ32ettkuImih/gZHfnHBaoUibzrlvYMBaDtx7E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749499127; c=relaxed/simple;
	bh=2v6XsXrenKRLJ2ZiJMb9v6ouSodrAOtMdBUBVwAcFY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=moif//zZT7gq6YviZwhnKifhxxm9ODr7BWxNicec1F0UihJghXAV9NNPeRA1xrLrdUUOR9cg11EeM9zZQG7PJm++r45qmjnlfxTIuFGndMBgT8LniKS9+JuWyNWDKjOOMaqndPYfS0kqngYfBs6NCNa0jgU3yqfowL0K1vyoLyQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=jj7qa4qU; arc=fail smtp.client-ip=40.107.220.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jj7qa4qU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v3nUr6Qu6lFtoOMLPkXhXXTAZN6xUUyIsGzL2AR5b5qI0L96GcYESyqs+GRZwJMakEo4Gm7jc8+Jzsx6dM/ZIHKND2I4KnpoobxukIY3sJ+ARyvR2/Rb/1Xls5XBjfI7lVIlg33R7du1EMaml3f0fj7S44tePI5tkezUIPBQU3kM3hP/XDMvILu271GgMfqHXj9KWQEf/aanyXnUUh9XY+MVJnT5Nz6IE/gS2PQTxEKCvQW8xeZ8yLqdd04j1nUfr5FIiPByVlkCkHRwWEZKy5oNO8V+ghXrSlYf6INOZDfzYEsUI4rgsVjnEKZ++hzfH5F5G53Ld5znDclMRQ1MQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fThvq5gUT5Xlw2uDFX4InTHqQsWBOd4R0SRwsdWAABM=;
 b=j4UaVyVcZB9KhoVsWIg6qtttj6nIGKVlBPc3ehw6Djs1Qov/Bo/+ysqhpRBIhOhq92u6Jqezlq37OU4nnBG7ajzfCJ5ycYOLlidvqAHzrhBDktSE1Sg2j1vwgRGfVijiV+MQ4ktXeXDviMMsEd2UETODpO7pKk4rJ4TBYCYwESZCKse4VNtwbCU9DDyUDyu2zGTEitwGmQeRSieMqz+t+D22w1uLiPJnRPZPXeRvAr/mfUnP3th05vxn9fNSYrOVr2GNZ8tFZQfMvThSSE9o14Bl6T8bmhltUgiUrU8p0+IiPw/oggbMmwfVr8TjjeSbMUg98iu0hlc3vIpL+V3KMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fThvq5gUT5Xlw2uDFX4InTHqQsWBOd4R0SRwsdWAABM=;
 b=jj7qa4qUYlfuadn5ms5o5vuu05HW+mwkt2/0BTi1RAAY/mzx5almxXi3hYWZNMqV/7iDXbOFCEaOzQVS7YbVXHpgEQd32Nu9lOT2ynwTyz+nIwdMCh/Fv/EBh6pRupfpJsfc0DbcG8qMSNgLaDmZvU1kNxDpJbJOoHe8GhALimHnQ0dLUYUCn9TwT45QuFA2gGweruaNoEQYYCphBTCRAhMTD2TnQMTveOB/lDFcoJ2TG03hHOO3x+a4kZjsJumRngYg1F9Fbjxbx3TQVV+EMn6FI6wDW9+GmbzQylQ5vm6YgSQZUSNvzpv6zQTysEB6sGgG3/OTecPPzwTsSHLtyA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DS0PR12MB6414.namprd12.prod.outlook.com (2603:10b6:8:cd::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Mon, 9 Jun
 2025 19:58:35 +0000
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
Subject: [PATCH 5/7] iommu/vtd: Create unique domain ops for each stage
Date: Mon,  9 Jun 2025 16:58:24 -0300
Message-ID: <5-v1-20c73f153f4c+1895-vtd_prep_jgg@nvidia.com>
In-Reply-To: <0-v1-20c73f153f4c+1895-vtd_prep_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT1PR01CA0044.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2e::13) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DS0PR12MB6414:EE_
X-MS-Office365-Filtering-Correlation-Id: f3dcc06d-9f2b-4627-6b29-08dda7900212
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zFPnmnHPb1CiErh+9NOE/GYc+tJk5EF1Pd2MOfLZdgsAsOOVAfH/U/wPPFH6?=
 =?us-ascii?Q?C33KMNyqoA9tsvN9jSyK6oRP1uXGuONV1Dv3h4zpsd0VYoOF5BqSyyXyHQWv?=
 =?us-ascii?Q?HdqEqXVo/LirNf+JGClJA6JX62lpM3/c4JQwaG0MgAbtBudodb2J8H3evoUS?=
 =?us-ascii?Q?KFhqpB5vco/ZI+n9/ZQfmYTrt5x72SsjGrbnw7V4shabu+OyWE2x/ELR+TiD?=
 =?us-ascii?Q?oHko+J/EttFgH2Vx08xqR3x/T8+v2n1kRB+cKKQhjBpcQKyo3sfs6j0Y9EFj?=
 =?us-ascii?Q?448yxafzFQZqhS7M0k/M4/46YmnZxI/viiAJUxfseAy55yVoLX7aiYbvM+GP?=
 =?us-ascii?Q?vMvgBgFykXI0OyPLoBegCLDIBPe++ifJsSG0RPfUqL4K8Jpv0rTd3izZ/Cyw?=
 =?us-ascii?Q?ErzP0e0G+w7mjOFltelePOp04TBc+vSMUwnCQE4G0cEIkWxnBkZFyCWaQ39n?=
 =?us-ascii?Q?LBUQmvWnaZv82c7RC7zgvTNPoVESuPWm61qnTNeVX8sXrCTuqx3C0xsvRniw?=
 =?us-ascii?Q?VCS1OkOaiY1C0NhP6MScI6bxbVX2OJol5+UEJ/nf8zSRmTRpFqTLOI314BjR?=
 =?us-ascii?Q?6TMi3okoYnQtb+KzPHlj+qJXW+1CPiyn73QH3zhTA7KHxDJ1qf0YFgGBAIKF?=
 =?us-ascii?Q?2PGpCu1lA/USLrriN/fYlkAQHIVJTFSobHDEZMcCsGmQjR2k7jxgTGanWrmb?=
 =?us-ascii?Q?nLcvI6p9g+78hJksuLlq6IDKLCU0Mdvxdcs2Y5RkvKCLqayvcwqE6YlehE2b?=
 =?us-ascii?Q?5Oq//h0cEbWLgjhfkWJgvT2w3kFdhgMh5NC6XmRPfATUk0DweKjTcgXQkW07?=
 =?us-ascii?Q?Pto33rnyQh6jZ/UA83U1gojxsF7aRyv+QVYyZu+8blV6Pqe3019JXx9hvE8D?=
 =?us-ascii?Q?DtgUnKhWJU6NzIfCpbegMdeWhOnmjZRe1HTDVZFCIE+MpcCkZ0vFquFdKVaU?=
 =?us-ascii?Q?gKaRygAzI0XbrxGuKi15yJsVd0UtbPUhhW0UmzCfpHf3zH+WVaKjfo77DbhA?=
 =?us-ascii?Q?aIrs6e0D/1Mu/JpWL7IIAyJO+J32VVq69BhgQ8J2iCzV6woRXhcNx1dpJiuQ?=
 =?us-ascii?Q?+e9nvbiD2+HIzGdLDCGBEWHZqvZKRoX+hAUcI6lr1tMDR7UR62u284VquFE9?=
 =?us-ascii?Q?YTTO4THWUDW514r/Z67AX5N1vdG9Xejn/s+lsWmdeML4xDt4/u0BkkS5ZG17?=
 =?us-ascii?Q?U5SAjCWOyObKHXfOXayI9GkXzT9DdqNB87M6ykHg6NP1MLTi7TesLWrDTt6n?=
 =?us-ascii?Q?Jgm2DIOoWPpkaFhoLBMGtPEUCFnlYPy0ZwGpzoXQjaX+XuHQ9ncsQkZ/h3RR?=
 =?us-ascii?Q?gE0smpih+2GTd/6oP5fuR9lKAaHQG9m6k7yLPn4wAoeLAf0LeuTyt1zvnbjv?=
 =?us-ascii?Q?hd936JNa4SBlhGJff0xdbgb17Y+ubMGZ49xQZYLpz2gdfjlPRij8/XZqHzwb?=
 =?us-ascii?Q?suDLwm6fywI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8fg2bMcY61yomsmP8zB8SDsyu3qXcnZ9gsWvzTYy2n7WhSIU8Y9BVYTD9URq?=
 =?us-ascii?Q?smlIXpWSjwdFDDy0HM9yDSprU9pTAPG13OS4R0cpDrjxwFaBBVv7I/45BhO7?=
 =?us-ascii?Q?b81aB6h9mFzJsaBN5XZmRmYgooaTME+4RfGfIZ6gDZRj/vEV5M6AqYYNyopm?=
 =?us-ascii?Q?b9UrPbR8bN7fLk+h09jcagqM8SjqSbCOU1Jz3NCR7zNIEyZ/u10jvWW7uzYF?=
 =?us-ascii?Q?eo1wvirPhNiGa6xYoRaPtYZETXykgyzqtFCEdMkUnu+gSAnnwYd+oOsdefrX?=
 =?us-ascii?Q?KZcMvN0UrMs+YHnnbmUl0I9AcJ0QaLs1GDLakDwXYC/YtLrzVBoAOxGnoS+3?=
 =?us-ascii?Q?1msazr5s2ECPRpQTyHjpUHUbehDLhCICxsupQJuZXXbD79xyAelqSug5uWBy?=
 =?us-ascii?Q?GHyKt58rOkGsvAy2AAnn3WDEt0HyXVkVUv87jo1RA0jWhZbe2vYCpBZW3toT?=
 =?us-ascii?Q?k95VCt8zLLN1NY5fAHEHjQRneKIrKtwv9BngEQW07TAOj7fHXidh2c/zDBaw?=
 =?us-ascii?Q?/OS73HySBSYNAyFdoVyiVGUnA6wgz5OQ2P9Mn3nZaoJKX2EwdNprm1YrSR2n?=
 =?us-ascii?Q?mMuXBzl/MAL8ip6l9YdgIqMPVbu9xdFojM0KYkiNe/+tUUABLmEu03ZaUqP5?=
 =?us-ascii?Q?SUa4SUPSLHW5L2aKvEOZiiJWWuwFfmWdfCoXGMbi+yeNgBN+6NjCbOcYK6LP?=
 =?us-ascii?Q?TxCwSBXGWEBGljv5f67DSIBaNBwek2YgS56l51+VDuHOWxydKzhLQb6StTFP?=
 =?us-ascii?Q?G8dOONWE3tgpuga2q7f4CHjIGxKJ0YvHBRUDgiFJGkayRfTxwBSIrlLp9mwZ?=
 =?us-ascii?Q?GAP2ZxQoGGd4+yyjkQP47luucYhMOZH0Y08WO5gYif0PTVfE0vpr0aFIAoCc?=
 =?us-ascii?Q?bzYGPYhqXCiJg3z4u4ZC5TOwfCvZd0eFC4nzKJ4RXHu8Tm+cX+CiXuI+UsvE?=
 =?us-ascii?Q?jTWzSzzuYD0Lq4/BC95V1nhKetrzCFrS5v6w2EyM5eKQ0zt406lk0MUn9vEz?=
 =?us-ascii?Q?ObNAWTy/L+RHTlYPtxyzympzrKUjwf7v86n9xTooTkiThpTg9rsmm7Bmr7F7?=
 =?us-ascii?Q?qHWCudXEBgGfLJhoT7yhxLTYbwm/63txGTrfKgmP01UZkj4DMcns1PINZ/CU?=
 =?us-ascii?Q?/rDY4mCoa4r1SZaDXs0UJ5mpZCgDDM3d9y27/mKRo4yGedqKgbcP9xc8MmWE?=
 =?us-ascii?Q?e41n2elHiffarAHpxKbThlYBNee8v0bWfDL0WRr0C9vsN9Pp0mmetvJaWZ7w?=
 =?us-ascii?Q?O+gG+V561DDPbr3nbDSRzUN3yHPJpeb5l7xv5invjMnt7hQc9+LXtiDJAQuw?=
 =?us-ascii?Q?DQEb9+V1viC/Hj9+DA+zUkhKELWP8Dt6SSW+UR1WcT4gwd6k+6qU1jndXYvw?=
 =?us-ascii?Q?VEhORu02puoeRtGLc6qsYWU3ZNUiR0m03fWzNRXfrJybzD8r4qgoBcTZEoO1?=
 =?us-ascii?Q?9NvOWDtinpS7cDMkAB2zVs6l5Do2RI3IfWlKVr4YJ71pzWQKuKNzQ4Y4DFpW?=
 =?us-ascii?Q?1eX77OxwRDGZncySycLQ+Bps4a+riNlv+8uvYetqJ5WgGkaqYaVbPf9qWmt9?=
 =?us-ascii?Q?TZ2jVFca/YrTw81a3KjToU4c1cym49wVXe4InSsP?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3dcc06d-9f2b-4627-6b29-08dda7900212
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2025 19:58:31.0605
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7zKeCVqBSjflLPiKeFeD6v5WudDAfXdpTjaTAKbd0YATkg0x+gImAym6Q4NQqRLy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6414

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

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/intel/cache.c  |  5 ++--
 drivers/iommu/intel/iommu.c  | 58 +++++++++++++++++++++++++-----------
 drivers/iommu/intel/iommu.h  |  2 ++
 drivers/iommu/intel/nested.c |  3 +-
 drivers/iommu/intel/svm.c    |  1 -
 5 files changed, 47 insertions(+), 22 deletions(-)

diff --git a/drivers/iommu/intel/cache.c b/drivers/iommu/intel/cache.c
index fc35cba5914532..29b8af6487512c 100644
--- a/drivers/iommu/intel/cache.c
+++ b/drivers/iommu/intel/cache.c
@@ -371,7 +371,7 @@ static void cache_tag_flush_iotlb(struct dmar_domain *domain, struct cache_tag *
 	struct intel_iommu *iommu = tag->iommu;
 	u64 type = DMA_TLB_PSI_FLUSH;
 
-	if (domain->use_first_level) {
+	if (domain->domain.ops == &intel_fs_paging_domain_ops) {
 		qi_batch_add_piotlb(iommu, tag->domain_id, tag->pasid, addr,
 				    pages, ih, domain->qi_batch);
 		return;
@@ -546,7 +546,8 @@ void cache_tag_flush_range_np(struct dmar_domain *domain, unsigned long start,
 			qi_batch_flush_descs(iommu, domain->qi_batch);
 		iommu = tag->iommu;
 
-		if (!cap_caching_mode(iommu->cap) || domain->use_first_level) {
+		if (!cap_caching_mode(iommu->cap) ||
+		    domain->domain.ops == &intel_fs_paging_domain_ops) {
 			iommu_flush_write_buffer(iommu);
 			continue;
 		}
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 6987a46c2e8421..820a4ef9396d68 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -1462,6 +1462,9 @@ static int domain_context_mapping_one(struct dmar_domain *domain,
 	struct context_entry *context;
 	int ret;
 
+	if (WARN_ON(domain->domain.ops != &intel_ss_paging_domain_ops))
+		return -EINVAL;
+
 	pr_debug("Set context mapping for %02x:%02x.%d\n",
 		bus, PCI_SLOT(devfn), PCI_FUNC(devfn));
 
@@ -1800,12 +1803,14 @@ static int dmar_domain_attach_device(struct dmar_domain *domain,
 
 	if (!sm_supported(iommu))
 		ret = domain_context_mapping(domain, dev);
-	else if (domain->use_first_level)
+	else if (domain->domain.ops == &intel_fs_paging_domain_ops)
 		ret = domain_setup_first_level(iommu, domain, dev,
 					       IOMMU_NO_PASID, NULL);
-	else
+	else if (domain->domain.ops == &intel_ss_paging_domain_ops)
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
@@ -4080,12 +4087,15 @@ static int intel_iommu_set_dev_pasid(struct iommu_domain *domain,
 	if (ret)
 		goto out_remove_dev_pasid;
 
-	if (dmar_domain->use_first_level)
+	if (domain->ops == &intel_fs_paging_domain_ops)
 		ret = domain_setup_first_level(iommu, dmar_domain,
 					       dev, pasid, old);
-	else
+	else if (domain->ops == &intel_ss_paging_domain_ops)
 		ret = domain_setup_second_level(iommu, dmar_domain,
 						dev, pasid, old);
+	else if (WARN_ON(true))
+		ret = -EINVAL;
+
 	if (ret)
 		goto out_unwind_iopf;
 
@@ -4360,6 +4370,32 @@ static struct iommu_domain identity_domain = {
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
@@ -4378,18 +4414,6 @@ const struct iommu_ops intel_iommu_ops = {
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
index ca6843973d4393..9b9e5fde4a3062 100644
--- a/drivers/iommu/intel/iommu.h
+++ b/drivers/iommu/intel/iommu.h
@@ -1375,6 +1375,8 @@ struct context_entry *iommu_context_addr(struct intel_iommu *iommu, u8 bus,
 					 u8 devfn, int alloc);
 
 extern const struct iommu_ops intel_iommu_ops;
+extern const struct iommu_domain_ops intel_fs_paging_domain_ops;
+extern const struct iommu_domain_ops intel_ss_paging_domain_ops;
 
 #ifdef CONFIG_INTEL_IOMMU
 extern int intel_iommu_sm;
diff --git a/drivers/iommu/intel/nested.c b/drivers/iommu/intel/nested.c
index fc312f649f9ef0..d976d6b6188d3f 100644
--- a/drivers/iommu/intel/nested.c
+++ b/drivers/iommu/intel/nested.c
@@ -216,7 +216,7 @@ intel_iommu_domain_alloc_nested(struct device *dev, struct iommu_domain *parent,
 	/* Must be nested domain */
 	if (user_data->type != IOMMU_HWPT_DATA_VTD_S1)
 		return ERR_PTR(-EOPNOTSUPP);
-	if (parent->ops != intel_iommu_ops.default_domain_ops ||
+	if (parent->ops != &intel_ss_paging_domain_ops ||
 	    !s2_domain->nested_parent)
 		return ERR_PTR(-EINVAL);
 
@@ -229,7 +229,6 @@ intel_iommu_domain_alloc_nested(struct device *dev, struct iommu_domain *parent,
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

