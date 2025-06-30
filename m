Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2069.outbound.protection.outlook.com [40.107.92.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0258128C2A3;
	Mon, 30 Jun 2025 15:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751295849; cv=fail; b=shxLgKQd/90Do7e+rAAvQ46NQSFyJ27odmq2/HC692MJGjqui01NDYrXMcrGV9vvrnyuFch5kks2qwmE7Jd4lhNOvKHSiiSBeMo78aWPcVwOQyXKKKWrJIv1BD464IWPtdkmEFjHWfi1+8Yls0CyCr4F18OmfQcWDL9v9rryY6s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751295849; c=relaxed/simple;
	bh=h91BJWBu+dtJgo9JruxeW/P+fyTOE70qURvH9LJMnBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tcV6MkpghQLXgef8uglDRW6X/C0feqAZXizhxE3mv9PmBcex9GnON6opsz5DVXD3/VxSE1Fa2xL7iAEHqWM1B62RBArMdAw1X3F47CybYrUgJJ1+rxudtAB0VxzlBGf+7wfHrUr7C6b1LXXUZO9daxNmrqBlxgbAX3fwajq+NLM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kplNq8CE; arc=fail smtp.client-ip=40.107.92.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kplNq8CE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L00TwaajBoEdz3yJRyfDm1hXKNQbvTaPEEGOf/Kc5ieil8c8m2+8bDFKwY4sC8/HBzW5/dbTWoflZkH7eOZ1yILqoDxrVjFkBogFezuHgYc3BdKxXjJtLsHxwnItHa3jonRuoQWzT7CXXro3ZJ3jLyHvRf5famthC84kNSCKA7qvEBGo7g0VzrX0CRkhivJTiQwrYb7By6gxACSIkGiaXhBGTWjRrCWWHEJkXfQiUPxNVUsVdhFxQq6820oP+rN3fmpuDAt4vgdJjaPMG37djHm1vsXBhvIIK/ebYV5TnYq2f8NW0wFsWSk2gH/uscDocFmHFgoJAAAicod0RwpWuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B1h0Dd2yi7kxQIIP6oRdw0zHFGJT0WtTcRaMDUi59dY=;
 b=aax354TKZbk4IgiqZGqpWEj80os53XxXrjUVtm4Q5ai31gTlCMypH+z10ORgYMNlZWU6EKHjKwUL/PpXbB7cfzH81oQJP3izF1yg/oqpNvACNnNhpvbZdy5sl0B+9AP8SDavrHzdk7g5bFUu5q0ZGiqni38qTSTPS7+unQYy5kai6ugui1Ix6EIk7e+PipiT/B8zBGS7Rjg44fgt79QULIvawkTcw9//typWWryw+vCsdVx5N0kOJB9GfwCdOd7fe+sMPo6CQv2sb9UuViKNPPsM6FhFrNeekzKs2LElR2UjaNCPcRcFbhq+PNX/idZQmDIO+WoeeZ6BgVMFiDr5Wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B1h0Dd2yi7kxQIIP6oRdw0zHFGJT0WtTcRaMDUi59dY=;
 b=kplNq8CExVZIwHnIEVHEUm5rSasC9NFE9yAJUkzA6oeEj1l/u2ghMS/EHDUHG9f4/TWU9FYg2awINUdH5Z+o7ilgId2nK0oSKp1brMLPzWN/kxBdtMzv65KXBHXfM60eP1DDwJPVYLV8cBwrgL8fCbs9eor8E6D7moLJ6OnyLI813swJ1pGkXxpp41a3XLcLaLQXFZYBQZqHGNEMUrJfLDMCmb5oG73H0R74wQU3tLdxkiP6+HsZqrcN+/i2FMzh3px7GLkfVdPd1KzRnoHneel9mQQMMp4uSZ5PDn3crmx+czx5xeiuugNI5clfJBy3ogZfiE5jL7PPwStGtFxtEQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by LV8PR12MB9643.namprd12.prod.outlook.com (2603:10b6:408:297::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.17; Mon, 30 Jun
 2025 15:04:02 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8880.030; Mon, 30 Jun 2025
 15:04:02 +0000
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
Subject: [PATCH v3 7/7] iommu/vt-d: Split paging_domain_compatible()
Date: Mon, 30 Jun 2025 12:03:57 -0300
Message-ID: <7-v3-dbbe6f7e7ae3+124ffe-vtd_prep_jgg@nvidia.com>
In-Reply-To: <0-v3-dbbe6f7e7ae3+124ffe-vtd_prep_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0135.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::20) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|LV8PR12MB9643:EE_
X-MS-Office365-Filtering-Correlation-Id: 12e8f0d4-865b-4d85-b796-08ddb7e75903
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xvTYE3nQZv6HRgaZLnWWlj+x3S6841oq75YTqsqVZgYNUWdRf5PX2cVYPgHF?=
 =?us-ascii?Q?wrTB8/EhRPsq7krFfFdaaQ1BLY75ICPaW0lCrChKzuE21DYBnOO2E1heKoL0?=
 =?us-ascii?Q?0FHE6Q4Iq8pI/dO6legqxAioIBxTjYou2UKiNhrtJFSC/WAPIlBaLe0HzrGe?=
 =?us-ascii?Q?5cC07MOMuodfxdgFVzb13nPneDympa4JVQfhhGvbmuyWbHxWKVIi9Rl7828w?=
 =?us-ascii?Q?hUQZNAQN3hM8v6bQuBPFn3t1wfMBUl7otavL3N26VNt8lrrZiHw064+fTJaI?=
 =?us-ascii?Q?ngz4RKpTP94erir39ieyRmeVqWifZB9gVqgBn9C+U9CCtM2hF2SJTAz9dJog?=
 =?us-ascii?Q?q9w9wgXMi1RQCbpyvUu1/8cW4ZrxehbRs8g9KW3TA/GDxlDlzEJLFYyDWOzt?=
 =?us-ascii?Q?aepBXIAQhLgm9QF15/pWe/Ei9hgLcq1e4LLdUuHYsM73TfYBFONr8+ESgxK6?=
 =?us-ascii?Q?BybiAcGF9T0wfdyWgJdgV4HIKYpbPH8PqnMBgJ1XjLR4q1+w9G8nbN90rF4l?=
 =?us-ascii?Q?hsaxmZUh555vJcTE4olG5OX3ISOJTlLFPR+jZt2DoPx9xrGgU9FDX7GNAigX?=
 =?us-ascii?Q?0H+tTcP0hO37enkSBhu+gUmemxNZYoF4/pSqbIVT+KTxztyrJs7CWnlg+YJz?=
 =?us-ascii?Q?1q//ZdNThwd9ht8R3aesj+yt0c04iQgUisb8efwntHZwLpkx1aaIz+0MRsZo?=
 =?us-ascii?Q?glR78Mz1fzTtrI9OzCUJADPMAOH1rV3H7eRBpJ1qv1E5vTT20mlCLnaNj4XA?=
 =?us-ascii?Q?lzO6DL9447UBx5p0n4HGLuXVeZX7e2HcNzBKqU2FuOoHwZEpMNs9GtbfEsB+?=
 =?us-ascii?Q?5aOfM9SpDtW29RvKPq52TkcNLmWqn+lgMrfAkOxw+IsRkyaVYsKVhxyWTRtq?=
 =?us-ascii?Q?wDCBgTVb0SqbTa1Q7Soxp3QrZGOTY7864abHll2b/u83+sTPEqxfmMYp+Tqi?=
 =?us-ascii?Q?UAMMlIGK6zhwl+ksn54n5/GkmJUr48xS6wIXAK2jFoSuUy4cr/gnuOPOyrBL?=
 =?us-ascii?Q?aei5E6BcSmsbzDNTHNDDr3QE1o8BpVPTpALIWEl2bbJuvhE3JZEI1y8+gdh2?=
 =?us-ascii?Q?lzqy7mTGWrc3qe+mjrMoncezLkFvXYBsQ13AZupzCcXD490cxkxH2ld1pRUH?=
 =?us-ascii?Q?p0Q2HBJJZ43gr8kZUQoG5Zn1LCB7xHPT2C6f8amSzoAxH87Xn1niYKedr/gj?=
 =?us-ascii?Q?pj72Ll6VtGlRAHI1vRZV7bCbNupgmf1Bw8C3lCnDWOvWKvruTSIfQPrMv+IY?=
 =?us-ascii?Q?geacduaAkRkHB8JtrqZTD219IiO5nYC9kiz95xTs9Wa6bGA9s6Lf0Fvq5XbJ?=
 =?us-ascii?Q?mSyNQdtLFGZMTEq3k13hmLbf7p5y7xPRieOlru9X3BKYGFwDK0ogtunGF13l?=
 =?us-ascii?Q?s4Geij2fn4G6BHxF7cJmdjcpF1lTWlGocmK0UC1tNxGzAqrnGviwdLar9Ggz?=
 =?us-ascii?Q?bR9T8Uwera0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Ap5Uozka6NAzitt4J1onKw+WSW5KhiakJXRQNHhGzSTxZA90Skr194Ngsd8k?=
 =?us-ascii?Q?pppl0veibr5PlGjfd1Ryq8N8Dx9m5qu7pXq7KAIwzcjjtD+AbgrzQHs9EaDt?=
 =?us-ascii?Q?qfEpk++EopQMiFRfwP3U1ivYT/D7+3FWRawCYk6xD/EMge/hus5m1b46w8oa?=
 =?us-ascii?Q?NVaNygdYhEsFX9yHcAiKJPZV+zRNxztamuPeS2FOPopP33Z/2nAGTdYDcFzi?=
 =?us-ascii?Q?KW9Uf1Kq7Nc9eS1iz6wFlfQ6MT51dGt3C+O0AKeqpLMIm2SgCk6miDTt/AXN?=
 =?us-ascii?Q?TFjsjZQccEcNoxZwINWrK/5G22GQsi0oR51G+545VLkh1mpMqyfdmcU46vnP?=
 =?us-ascii?Q?5Y0r+BDB97QBf3bvDyW3AhjGaIHrp+Sf5b4Se63kny7rZuMH0CdOT+y1Tg6C?=
 =?us-ascii?Q?evN1GjRT+HtmQtZugypkUg6Vlp9GIsgihoEMA3Ckwhmh8+uqPqzUp7jtkgT0?=
 =?us-ascii?Q?z9Ynn39tuYbvfIYbj4QvCTWXbYJUn1RVex3GJyzrOW41T8lgR1ao5BblD3we?=
 =?us-ascii?Q?1WPWpK8ORnQieUTjHHmLw4qHOkMcH47ISOxH6WF6/fSJcdQWx8Wcz3MDAlse?=
 =?us-ascii?Q?GthP8VbiCijVuoqbcSvi2hZ0xbyPVk/zDHzuF/3xIWubxDAXMCB83CD4qZcu?=
 =?us-ascii?Q?i+YJ2GrjfKEiJLZFkPqSAsvIWDuSlFx0SpRq/iFIxOAsRHhWTjNQaX8QvKMO?=
 =?us-ascii?Q?Xc3XeiPQxQfTgwYQ8SY8c+GKb+wfD5MpTnyPCBjqiCB0jszN1IJlKjQhW2F0?=
 =?us-ascii?Q?f0dUlBDdWax2btr4xeVxPZ9rd4Ob17F6gurpn+SP2Lw13cPgeSY0f6T10Qe5?=
 =?us-ascii?Q?yhwBoqK9af7XN8czhP90/JwVa0uCMl2Pjwv+Tn1z2E56hvMIJR7xxgh5QggI?=
 =?us-ascii?Q?rhzJ7zPQDRLHAlJkFLG+qeFU6wn2tXhXEwwdUQ/1T/e0tN3meMl5YmoqEMjJ?=
 =?us-ascii?Q?0aVIDKXdC81F5WrTNq3o4k4pRAcarO54JOOm3/YrQzjEiKTRKfVG4GUPcx0W?=
 =?us-ascii?Q?w7SY/yxA0vg5m0qWXYzin3tjl4z6s08j+f8QilYRVG2wAWDjRK85+BEhIBSR?=
 =?us-ascii?Q?Elarg04nYG/8j9iJaMm2HSbiJv4wLGNTBldPWvgXGr74YbeKqChqXr0emm6X?=
 =?us-ascii?Q?QDA8/QQqTDqJmzl9LFAtiI4CYP5ZOjsmIGwuNPFvXDulewZqVj+nXn2IvLzI?=
 =?us-ascii?Q?ItDyqds8RbYGKDpwpwwLbClFQJ2BhrDNdt+be25ssF5T/E3Cszz80UceUpAX?=
 =?us-ascii?Q?Bi5ZWWQgKq/qDt0ELiuTZ01Jvm0RX9eJMW93gPxVSmLXrdYiYm2wnp+PZlJF?=
 =?us-ascii?Q?PUXsDAtAy0b2nbKnHzxJfAEx8wuAw01Bi++GeHgao8FvWCUTEy+7YNcJvjgt?=
 =?us-ascii?Q?NfF92bq/VzRF7weuvwRiXlSa4xQqFEUlY7UGavivrW8HW+SAdVPGQF4RHgnR?=
 =?us-ascii?Q?DxGMJwFSiNSipZIOVKatklzMD3Sl6zo6U9LNnSBe/ahrXmlsdo9bCs/Mnpvr?=
 =?us-ascii?Q?frorGLKEPfO6to2hg9BxHpZ9u1Mu+9ydSuw/jBHJUmhc0RvOXrE00v2JE+6h?=
 =?us-ascii?Q?4/45IHMf6oMJvTqfb74WVV3UQcJ+fo+mxk8kQS96?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12e8f0d4-865b-4d85-b796-08ddb7e75903
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2025 15:04:01.9419
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6Lf+Joj59G2VzT5UyGA+9wIMicgpHE/JCPnFZOOLh0L+40jPZxK204hfTwtjX9fB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9643

Make First/Second stage specific functions that follow the same pattern in
intel_iommu_domain_alloc_first/second_stage() for computing
EOPNOTSUPP. This makes the code easier to understand as if we couldn't
create a domain with the parameters for this IOMMU instance then we
certainly are not compatible with it.

Check superpage support directly against the per-stage cap bits and the
pgsize_bitmap.

Add a note that the force_snooping is read without locking. The locking
needs to cover the compatible check and the add of the device to the list.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/intel/iommu.c | 66 ++++++++++++++++++++++++++++++-------
 1 file changed, 54 insertions(+), 12 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 7ac267830bae93..134e489393f3d2 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -3417,33 +3417,75 @@ static void intel_iommu_domain_free(struct iommu_domain *domain)
 	kfree(dmar_domain);
 }
 
+static int paging_domain_compatible_first_stage(struct dmar_domain *dmar_domain,
+						struct intel_iommu *iommu)
+{
+	if (WARN_ON(dmar_domain->domain.dirty_ops ||
+		    dmar_domain->nested_parent))
+		return -EINVAL;
+
+	/* Only SL is available in legacy mode */
+	if (!sm_supported(iommu) || !ecap_flts(iommu->ecap))
+		return -EINVAL;
+
+	/* Same page size support */
+	if (!cap_fl1gp_support(iommu->cap) &&
+	    (dmar_domain->domain.pgsize_bitmap & SZ_1G))
+		return -EINVAL;
+	return 0;
+}
+
+static int
+paging_domain_compatible_second_stage(struct dmar_domain *dmar_domain,
+				      struct intel_iommu *iommu)
+{
+	unsigned int sslps = cap_super_page_val(iommu->cap);
+
+	if (dmar_domain->domain.dirty_ops && !ssads_supported(iommu))
+		return -EINVAL;
+	if (dmar_domain->nested_parent && !nested_supported(iommu))
+		return -EINVAL;
+
+	/* Legacy mode always supports second stage */
+	if (sm_supported(iommu) && !ecap_slts(iommu->ecap))
+		return -EINVAL;
+
+	/* Same page size support */
+	if (!(sslps & BIT(0)) && (dmar_domain->domain.pgsize_bitmap & SZ_2M))
+		return -EINVAL;
+	if (!(sslps & BIT(1)) && (dmar_domain->domain.pgsize_bitmap & SZ_1G))
+		return -EINVAL;
+	return 0;
+}
+
 int paging_domain_compatible(struct iommu_domain *domain, struct device *dev)
 {
 	struct device_domain_info *info = dev_iommu_priv_get(dev);
 	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
 	struct intel_iommu *iommu = info->iommu;
+	int ret = -EINVAL;
 	int addr_width;
 
-	if (WARN_ON_ONCE(!(domain->type & __IOMMU_DOMAIN_PAGING)))
-		return -EPERM;
+	if (intel_domain_is_fs_paging(dmar_domain))
+		ret = paging_domain_compatible_first_stage(dmar_domain, iommu);
+	else if (intel_domain_is_ss_paging(dmar_domain))
+		ret = paging_domain_compatible_second_stage(dmar_domain, iommu);
+	else if (WARN_ON(true))
+		ret = -EINVAL;
+	if (ret)
+		return ret;
 
+	/*
+	 * FIXME this is locked wrong, it needs to be under the
+	 * dmar_domain->lock
+	 */
 	if (dmar_domain->force_snooping && !ecap_sc_support(iommu->ecap))
 		return -EINVAL;
 
-	if (domain->dirty_ops && !ssads_supported(iommu))
-		return -EINVAL;
-
 	if (dmar_domain->iommu_coherency !=
 			iommu_paging_structure_coherency(iommu))
 		return -EINVAL;
 
-	if (dmar_domain->iommu_superpage !=
-			iommu_superpage_capability(iommu, dmar_domain->use_first_level))
-		return -EINVAL;
-
-	if (dmar_domain->use_first_level &&
-	    (!sm_supported(iommu) || !ecap_flts(iommu->ecap)))
-		return -EINVAL;
 
 	/* check if this iommu agaw is sufficient for max mapped address */
 	addr_width = agaw_to_width(iommu->agaw);
-- 
2.43.0

