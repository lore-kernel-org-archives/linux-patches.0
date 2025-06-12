Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2053.outbound.protection.outlook.com [40.107.220.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CA5B19C560;
	Thu, 12 Jun 2025 14:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749738712; cv=fail; b=SjiOdNjiqH0zHzTAPzxIf1dTNaI8oBcA5bBimMcZaRmfUvMCQFUem1qhoXKZfa7028SozdgZcn2hnVcfexdJXnQ7UjOlsUpi9J6TjrxQ4NNttWZMW0w7N3veH1CCQc/vcYhzoIC7Y6dsfhilGCA3ByB9aP0Nemyiml/TgIxhQQQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749738712; c=relaxed/simple;
	bh=gEDRogAGW8tYqsBiEuIrDiox7w/JVdbDrKCivMeuIeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ZXI36cf2VD2Yw5hPc0Vvish4J2FAVVVPppPZz0nvgGVZ0uaheuJFJe9a5nFUsn8LHrHB9f8cSZgQXDO8X8g9j5Lc2b9HsaWqknjoEGK8l1iD+C44CBA4MDZ46c6Qir5QQqEariDz4oNjaB49mtpAgeIqp1/oZvJdleOgvO+zLGE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=h53fOz0h; arc=fail smtp.client-ip=40.107.220.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="h53fOz0h"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Xz/5B0DWTipF6LHdX0a8Kip/y9Mbwg+jlRNlXB24L1L82xw6QSgnRJV3sXroygAj/iHWXlNFgbz/N1W0E2+iGngPy/leONswSwqHfU/POOCddRIpNGFvxFapZlw2LY8/sVuak+47wk30yhgLX+svehc61nfbk4ciuT6MIoPhvWou7yV7bgZ17DgGoSmhZZXHcGdd9jzAbP4yTMEG9DIgp9ejP1cJ26yBFEbGPSotDpi7hBg/uw2K9fFIBMXvOFUDzrz4VU71uRu5ZEjq3FVqzXSudbrVX6GqslHSIKc9FAAenyPWHU8gnDvmhW9hvKmEYuCeGk63OpAPf3njVfLXyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x35sNBuCITQdTvQeOnXwZULMIJByao54g5E9v2FAeCo=;
 b=prxccTAt3Os8YmtVujiU/TZpAJAKPtdqKUf1dn1xG31n1V1xJOpX6y9Au58GJLS6Cz+qcZhirRnuOS5b394h1QQxp3jfLyp4iQ4rujWKG2m4CuiQSvvkmnOPlvUQOTsibXqSVmhWfPR8n1dswcMrQEfSg22FBuF2F62aNS3xi3kBWIvKc/XFa4JSRVxm5fdJtAY8dnKopr32DJ4iWifjkK6xFmkA0f3W3cTdmx/+XSbvpRMK4wel6E/Pl3bTL/Md5eFSmQrlhiYJlZCz+eOBmhSaNxEC0dYTlVM33kBNCKX4HpY4tcfDmiCzbjJTv9Q2HjNjeM1BtnK/uJwAVe8uEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x35sNBuCITQdTvQeOnXwZULMIJByao54g5E9v2FAeCo=;
 b=h53fOz0hy5TgMBnf+fdl0cCrHNU4dcrPFKQoJLiUvb7e5O5bCxP0jPHmUf3ztzaRHDT0ev+o3evhXEx4Lryluc46OrZ+fX0t6On3vSEkFJUjveokr8uA8ty+RwZrMqI3Uvd79XRtkxe1ZAPrHGBw1aeSwNn7r9+S4htYb+ajNTsTrB7q7papD80K7lU1ztiR5d3P5gXPvPHUPGCfHpT+tzma44HBZkLxllKE4bpI9GifxwdPK99rbzDX5cVyundjFDHo5zZO1P+yNxcS0GPzQLGR2urJ+MNNJ/zclxup9z6dd3R3YQQCV+s4KzmVw9Wah7YMisvQnliHM4Yr2haiWQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SJ2PR12MB9086.namprd12.prod.outlook.com (2603:10b6:a03:55f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.19; Thu, 12 Jun
 2025 14:31:42 +0000
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
Subject: [PATCH v2 5/7] iommu/vt-d: Create unique domain ops for each stage
Date: Thu, 12 Jun 2025 11:31:37 -0300
Message-ID: <5-v2-e5c01fc5ce82+26216-vtd_prep_jgg@nvidia.com>
In-Reply-To: <0-v2-e5c01fc5ce82+26216-vtd_prep_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0128.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d5::25) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SJ2PR12MB9086:EE_
X-MS-Office365-Filtering-Correlation-Id: d0f22d12-9840-4982-6206-08dda9bdd88a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?CC4urTfbMTRAwzOtSGqLGiztg5wF6P4Byl+ov63qw66zMKObWFZUIIPmHle0?=
 =?us-ascii?Q?wNatdCGXJOKpTH9rOfg2Ovle82M9oIhIhH9EYFEe1PnHvJPYkrrcGrZrlB9F?=
 =?us-ascii?Q?3X5QFlNhonzyTY3vp7A3QLFuE9Dw3GliNm/2Z5GKMCoSK5PyoPxLQ9jfRn9+?=
 =?us-ascii?Q?glPaRGpMYvGDqUyCd+V1TLTvlzxp3vruhwqvNchezE918G/GnDWxRuD70JJ6?=
 =?us-ascii?Q?B14hBdRbzqVR3iAXKePnzgM3aRyGUiba2hnrPFeLxeHoXvm3tu/92GqixP9q?=
 =?us-ascii?Q?78OQJ1PmEltUKceSO2xbVsYv0EzfbxkByHXZQD8J6BYkR7vb4GvzG2YWVSyR?=
 =?us-ascii?Q?bEeAb9d97vHSc/yN/mt+odTgobbia3sl1PH6l9T3k0kUL+/vIhwizqlBKN/W?=
 =?us-ascii?Q?SgGs/cy8oAm1qOpBO+zUPqsi/6JkpSJPfH9kxBHUq7S9+ap6n8kV99/7/NXZ?=
 =?us-ascii?Q?+WDUxvdMz72JZX7/tqUH9/b3bXeWwvCeBnkgNdlsMX/3GXbhpB0KOqNB9TGV?=
 =?us-ascii?Q?VwiJs1M9vkgzHBe+eVxUPGfafHtXrxx/3nwR+HLXawjJhdOBqgZ76cKAxIhZ?=
 =?us-ascii?Q?nn60neL27hgh0PhQj/RKn79Jp4pefIVsmfLQl2FWvsasP/mE7p4uV2sZujCP?=
 =?us-ascii?Q?W3XDW4H6InZiHlqEG2MdxnrKXAtQkYZ+lJv7Sz23cHiQndRXtEDNWi1hRJQz?=
 =?us-ascii?Q?6VuZQHu4h1VRZNf0ipARcyeVkVduXsEs0glcqT6EqPhlMA6BAYsHjp7ozauh?=
 =?us-ascii?Q?Q+dYMscY1M2UXccmxNaJb7DTrvgW/xPxaSYHlvFEpg7102wcI+1jUGyHH+P1?=
 =?us-ascii?Q?Ljo2UrlLlr5Fz2YMu+22AKJ+n8gp1EBUtNvQI0Wubvbm1+zgKlVGV5Wwz4iY?=
 =?us-ascii?Q?U0C0r96g7iEIO5GKiqcDeuHDfvxWmczMO/V7DmsCAboa06eW10gUwHlLjQJe?=
 =?us-ascii?Q?/LmQ31ieSyjq1UJX6rdefS8c9/2FtX7AJHdU9AbO59PD5Q2h+NoTzEie4uY8?=
 =?us-ascii?Q?mmnGLngRyNvuaXlBw0l3lEFIF5TzvmFLzE7wLnjn+Y3eXIV4NbF4Sqv6YNuW?=
 =?us-ascii?Q?Xxj09Ya2BzgAC27S6HlJV7SBM2anU3cBq0JM3iDBJuJjo8ChfIqPFynsG7oY?=
 =?us-ascii?Q?N3SFmXISc6ZQSfPAnzuFi/KPgSQb8qZbd1AHt8EPkvPZ54fa8okvAtHjj0tf?=
 =?us-ascii?Q?nrQa+z3L0WnyoF1TFkTr3GZoBwKFc/s3TT3edsVMNYYaH8hs0CqA1knDsBTa?=
 =?us-ascii?Q?uvgAJUKdzLL+TF0CzzqM/Obph4lLTSCH1nsHxznIhYB0hthY9rdtTfQ/AGFK?=
 =?us-ascii?Q?LUUkpn9/QIe/cQDpA28yJRNo1Oy9h0j0lxS74UWoxepSBPltnJuJDEIz/UUv?=
 =?us-ascii?Q?9cu7ttNbY4gL0bktfOwkHq0NpeNidkERvz6kT40n0A9N985B96xF19sFYnEp?=
 =?us-ascii?Q?swO7wGI/1LA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fxFIZsysHbjF9MSma1CPgYWHqFm3kDg3lxU+qqcyuOrL27hroufrdwz1xv9F?=
 =?us-ascii?Q?qqjTiVBy9S5iukZxdeOJ8tANqSerjQUlJ1H6vagh/DwOX270reIO4D2ouM1y?=
 =?us-ascii?Q?6Z6QE0MNHM4qySkdxR9GSFMtUl+udVHsPLsuVFVRZp25282cjUff/AEXAhGX?=
 =?us-ascii?Q?EY03fyHqVpwDVwnSTjJ5sdcwl9nlhxR7pZp/LNXh2gsjxjMJ9WHzErzeMnoN?=
 =?us-ascii?Q?YttSK5WYn0wl0d4TF9MfLS3zfn9rnmb6VamzyzfKHCBycli9pfShw3/iVXC2?=
 =?us-ascii?Q?OKgrbdKm1g6tb8pZ7o1YuO0AjbBBPJt7CwXoLt7U5+0/C826QOMIFDRwBPBU?=
 =?us-ascii?Q?0F13lKKk26kGVaZ/2rsJX/SstnbGIiTrXzJSS8bAFGNq/K7c5us13kBTKt7/?=
 =?us-ascii?Q?dwnSIE1KcGLiKOUBj7NKQ0QXlQFD7ST4rV6wSK0IyrWOBHF7KmSSEMUhRN+S?=
 =?us-ascii?Q?JviKsFIaCWyDWKIVToBEr2mMz7S2+0CdS0/WaYhlahGTe2p/orTOv35cLp6n?=
 =?us-ascii?Q?a6KsIxxDbpRSmmZceBPlpm3kj4ObGVWddmMHIBV/dpNeCvaK9x529EZgFnfO?=
 =?us-ascii?Q?0b428x2OzPB+00olZch42yO8VVC5gtPJ/XlHP3ihuHSQuvVVWukRuBEJ/ZgB?=
 =?us-ascii?Q?DgVFnTWjmRoz8P82z2eg1pl+OKNPzx7yIgjZaf6wN9zK8TiEi4aVQJI+z1G6?=
 =?us-ascii?Q?+vegndztlR4Y/lSr/qPdi/+Bt00mzrV+TPQlUsb48MPY2oGSqb7cTrco7tMb?=
 =?us-ascii?Q?8RWN0zRZzjiKLSadBEsOoxpa88cCOymg7O205kIzsyD1EP5Y19bTyMf6UMFa?=
 =?us-ascii?Q?46QcrDDyH6OIRjDUQZlb2IALoYH4Cn57RmQsGydEhIQ+xo5ymfyTnEPqK+5C?=
 =?us-ascii?Q?eZEd5NOExxwAnj6DtrBerlQ3HccTuxNOZuSJ3NBQm3iX0WCH4ZDp988efipX?=
 =?us-ascii?Q?0gdjCqF8JJdz8WiJSn6q5uhEiB/7q+H67ovJHkiOFZpu6Z/nHfuxlgi7N09X?=
 =?us-ascii?Q?dN9Ya9ZMNUpQUo2BUhC4G6nGIRdr9tPi45zigUXlEdmK0dnjFwJUZBcm/qZE?=
 =?us-ascii?Q?jf6hIaR32Kgoae5ATU/1rmZa/t0KBUMZ6e7wunKLyZ50hcZMR5mcig9os+9J?=
 =?us-ascii?Q?Jyt3E2RGa/voBZggwHokpZsKcdOe1n0xZrtLXGDkPQ5bInYeJFlheNFwo1NA?=
 =?us-ascii?Q?WMxMM644hybxFr6wAEyxgAjCZt8kppFDF7jti/1clNQ9DAAoHcgobs3fDe2h?=
 =?us-ascii?Q?LmlwFk6zs95HxuxICfLgtu48p7xmxo7jGjotkB64kRTCpw2fMU/vXn/krcU0?=
 =?us-ascii?Q?5QgF2FIbU7VA8q75n5vHE9tx/K2FonXxf/cVg2n1pf7bJkJxbhIsnqzf+TOE?=
 =?us-ascii?Q?QGCGkrvl3QqJ4/rlXT6g1slF8Vp+tCfsm5ZI5FpOS5Oat5vcFZkQYb5oTm8S?=
 =?us-ascii?Q?g/1zLn7bWD9biux9dbUd+TexwlB7CTjq5mhpEvsDOG3zJNOsPTyzXd88xi97?=
 =?us-ascii?Q?QkcGyCEYQ6FipN0uk4Z4S0YCV1/mQ/B5Q3UpYzDv11qvEARlSULSZ6T8v3wc?=
 =?us-ascii?Q?jr42T6YUCDf2vtmEt9ueBSOBQxxi8y52mSye2zlR?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0f22d12-9840-4982-6206-08dda9bdd88a
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2025 14:31:40.7719
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BWSjOTN4s+Hiq0axHTI/qjnG9DfPtirhq68cuq7VeAagS39ohGRhjP6zF0SHvqm+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9086

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
index 243e77d5a06aac..7a5c794e488614 100644
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
@@ -4081,12 +4088,15 @@ static int intel_iommu_set_dev_pasid(struct iommu_domain *domain,
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

