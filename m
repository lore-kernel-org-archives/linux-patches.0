Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8953A7D3F4;
	Mon,  4 Mar 2024 23:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709595883; cv=fail; b=O2ZqORPt6GQnWqDFpoaeQWWqt3Ojf0r3lUlr5n0dN+anvlAjmKUS23N9f2EB30vorjuQzkjdIgZfuM9ffGvKDcX57lXurf70gzwLVlkHMqDCwLtxID/DVLxJLmsKfe5JZ69TuWRJLtRFU5JeYXMCw79SJM6BrNmhZFgc4sq9bbQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709595883; c=relaxed/simple;
	bh=ORmCjGgdTty0hgBZQOHyOWW1wDKpyWsZz5hVVsQWrPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TSgbMXu4aqRj+Pchls+y12jep00pMDhn2NfDM4SZWkXK1CWVFlxsynVJits+YbXzIVYch+zm77EtHgkBiyZkK8JeAnvxkehiI3CS/hCBUiFBUp3byM3vUCy/6LxkPDc98dwne2DleoXFl66f1u4WnlD+FRIgys6uLgl6CXnlEOE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ZTukxv7j; arc=fail smtp.client-ip=40.107.236.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ZTukxv7j"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H2PGcPrm/TsYVqNUvLushVQaMROU3Q2Oh+RYkB6Njqa2uwA7E+DBfBo03cJCVWF9Ld+q1/Cs//4+MqxRouNI5eOqMZQFbUt+xzfUrDkETIdGduLAXavX1HaOVLwJqVsN6eqN6sA7ZFmr704HHiLgCs29/nplYIK/P2gSsvjQKxHMqBusY+IzVUcNc0DMYn+WL76mnipQJ6w+9B2F+VoFN/GbGBqAmvJ/ZSJ/rJJNSkGn9KYhF6+gAJW1fQ07Nl5NG9YS8L4ajncS7DDlZdSKsBy5Z2iRfPNfkib6W3lsKaUFZ6dMEqagYM+omiL1jp3K6JYsgpbASCuz6KeQU/ls/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GElaMr4LLFHOstJvBBnhlT+J/qd/oGU07MDgIOFHA5o=;
 b=mmohnQwJf/+wcdlM4CLX+af6Ew16mSFgBtESFuvRJ8SEc5/+S0OtcZt/+YWQ7sRqg6aydqJquCRLHCVHnlI8K0Cl6C28dFTp0J4PPy8blLUh6nkMFWaNDy5lZLzGxM5EgnqLgDVL2JoMXlMNFkYDDib3Hn5IhDkjLsC72Btmiprdosusjqc0bg1l2OI+5JGG4kq7a8A9JEWL52Pt6Tq+1JSwnwlHH2xdqWX4p59n6lEoX8PVjXljSYuLZFJS0Gn+yQDzwqqoDV+kvHyTClUMYP1rhZEHeOB7harm0vN+fUPT9QfKZeGcqlFslkmNYM+OHO4p/3yzeZtyeaiJ9vzoag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GElaMr4LLFHOstJvBBnhlT+J/qd/oGU07MDgIOFHA5o=;
 b=ZTukxv7jrTV9RR3ItveMT+qwC3uaUN4m+peVSlp5GiX0hfKVgfCaIGb0n0mmCa7QKhSI5SY5O/+iIQ1DDwNUVrB7czjWLKMY9+Aleg2BZBb0F1EfKTdmTx/CkWUDG7d+7KS2IeV9xBsiJ8ECORlE+fCBPN+QNJ0GF8i3qWNIHxCO59Pw9EC5suNP7it2FBx29OOo++NOeJje6pjKB6I5r+MFZVJpFaqJCshRVpJ5sRzsPxHGyhHIwZbGzhdeXz1TpcIyw8DPpedZoo/mkov27yRoLJfAnVKBsNn1qIDC1ZvdTkBTEwoBGDXTppETOc5AMzW8Wsr1ViBU9POD57/urw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by DS0PR12MB6584.namprd12.prod.outlook.com (2603:10b6:8:d0::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7339.39; Mon, 4 Mar 2024 23:44:27 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c33c:18db:c570:33b3]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c33c:18db:c570:33b3%5]) with mapi id 15.20.7339.035; Mon, 4 Mar 2024
 23:44:26 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH v5 22/27] iommu/arm-smmu-v3: Consolidate freeing the ASID/VMID
Date: Mon,  4 Mar 2024 19:44:10 -0400
Message-ID: <22-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR20CA0041.namprd20.prod.outlook.com
 (2603:10b6:208:235::10) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|DS0PR12MB6584:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a3007f3-f315-4bf0-8d17-08dc3ca5025b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	dfO+MV7309QTtdrdUYfbW1kk/EMPp6S8nO9jMkS7n5F9YHZRVTVNv3VNrFVXnm4nYfCUliuCWr/6Q+g7dN8GWIpe6C/be7tAzBncVymEConMy/e8tIBWnGcX1x90FTftsTQxczgII7PmItyo7znE46D6ns4KM4L0wOdwrmzl2GP6iBfCGB1v6lyjn5IkQlTfY7TE9EmS2PJo/njiPw3579n92sGwz4935wCR0IUZWrQ2PCClBfflK4hSk8LoS+W8n26u8gHk1jd5p+Yb2gzEijHQeQL766vLG3biVivaw3Lj10fQpFDb5Y13C7QpDZKHO0R0PsJ6QYUkABcQ7giVlTgKt0dGbKK6aG66P/3mDtQcfEFfs269uGiCMpE8yxMl6T8LOG+nMPoHQ0pRIOt0SZNrA/natWJcSaqAd/Zv0dfnCyweB+e64LpsIpoBNWkh++vt8o7f3n48LY/PZkFuUeQ0o90VkU+sIPZCNoDgHndyH+THKWvxSUqZkDzasNed7JP0tmHTYa0OnZxhqFTUZyDbPZJm9PTC6am/sB35kmJhbvIyPgCYa5sUKWQP3dZBnTUYunytnFDNYDl5of1kv0VWZd+7QDDKFwt8iDYjADp7Bd5rMA9DUiXnMizaWEmwR72vZPlBLPdixm9pe1F8dHsIacP6JwCLM6A76xyoO0A=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NJ7hR1K8xgURxsRdC/Nt/pW9dU8Fy4gpcITTBws+0rBqFVdbPK5AxviqYKaC?=
 =?us-ascii?Q?d9TSYERsTl9vPnIzA/k8/k0sO5TqfXRpi/WcrU5jRAUDeczmhDjRoPH7oJA4?=
 =?us-ascii?Q?2nuRi8SyjT0KcCEN/wX6fkNgyN46TXRGMrE61kce6Uv4xS63Lvtatg8O6sdV?=
 =?us-ascii?Q?BpVDHoPwngwwVCjsVvzSKd0OHFwUMrE4tntE+SU2wne+OV3Dg9lq+hNpVlpt?=
 =?us-ascii?Q?5gVX1J6ri3tZ4sD7MidQcF1bOTdhBiZx2TFDOAgS93r2lpf+3BgG1y/qVf9L?=
 =?us-ascii?Q?dNidJvnkEPem+kGpEym/0uFVtfrSWVrSOD4b5zNnlqQ08MJvp3gfOFznpVwO?=
 =?us-ascii?Q?cBibSE2NIsWP3NjHDDDam/ssMUSscUdJVq0LtlYv8qLIkXCfntAQRc3paV9s?=
 =?us-ascii?Q?5JxsuJYU/oEdc+wBVKntZ4BlvF6knNKsiWKdxNnEjxe197zhoRmkPV/Ka4x1?=
 =?us-ascii?Q?PjRwTZzUrnlqbOm1basrkLjE6g2IVHTkBHPrtjiKF3/k1J29jM+iH5UTr8Np?=
 =?us-ascii?Q?6DehZn9WtPhqoC3pV2+7Nlr6TlFgDSf7K+QNATqJMJD1QEFrgHaD/nb84Fip?=
 =?us-ascii?Q?+jOX5PqHegae78lo7/NjfhDJuxGNk4TL31h9rKLDxAdlq0PfulOpdcdhN3x2?=
 =?us-ascii?Q?9OEH0o3lr0a0KsE5M6HPPriqpHS70rRuvu02BUJPnZGlsKty0vQiUbWTsKVw?=
 =?us-ascii?Q?DZpL3nGi/HS4qoFxWFFAeJvYT6nRlBPavqvIIfLUMsjs4Kip/08Y9wVfgg7G?=
 =?us-ascii?Q?4rNugYuDDVTpV/A6WJiWblnWfxpsxnAP4jpUcjG8qZlIziGT62jOMEP+DS/p?=
 =?us-ascii?Q?sxk9RlppDGx8x6t0o0zoY0BYxC3K1DquDM1xGurktbMiOiiCdDIkuOs3tGXW?=
 =?us-ascii?Q?AoSM7JtYsRWXmb0m1J7sd/83piBvGIuFAQ3Gk9Q5HiZEiXypVqUgpz/pgdVp?=
 =?us-ascii?Q?bm73C5f877pkphx8VfXKjrY1Bdjyk/6hD1v/MyMRvJRrCY3LC95eO/vxqo1q?=
 =?us-ascii?Q?NxLixBs+PooELBy1stTUfgKqH9e0lUl4coO0o2SRfCEwDDIGEmQMbfkuD3s8?=
 =?us-ascii?Q?gga/tLdMaANLdZp28QU5TSd2/U15bbls4RtcpzSppT6fBicWJwNHO+5u3A5q?=
 =?us-ascii?Q?F76QPyf4V2oRQ7YRy4pLtMTAY2bI0XbloBauApObMFtOjTrFp/B7Hq8HZoLr?=
 =?us-ascii?Q?rZU8G1IeWlk1Ghu43qJOJWZyhxeduAnhFNWZcouCUVo2THmh+ETnbEMMUnqn?=
 =?us-ascii?Q?MXSNh2cfOoKPPYKia0vitJ9td9eRIOqWZLKj9i4cb1qwAgmB6Pa5+zlGVtxu?=
 =?us-ascii?Q?SaW91Y8lnts2ikTiw/Amo2bzXMo97rl88lfbyfV+aGnTNxNQ80UMhhgpXJpM?=
 =?us-ascii?Q?V4nUkYWGBaYjt7fxZrM1eahslmSXtLS7JYyJ9GwlBWBXTbRnNwDcunUhth6Y?=
 =?us-ascii?Q?dtzXZd9cWPbs7zu/qBmOutCUTvpIcgTxd8GVcKqwc+hc1uy7lOoqyV27aV3v?=
 =?us-ascii?Q?/ACT9A9bC+sIADb0vUx0Jp0vY9YWhfXrWyYHrxRit79l4eagHnRVgmt7e07u?=
 =?us-ascii?Q?AEFjqhciWDtJVtpSOH6Eu781DccReMAH9krV4IQC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a3007f3-f315-4bf0-8d17-08dc3ca5025b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2024 23:44:18.7534
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GUcgaC2RQoLr1Bm8wq3/PqSG2EzA7sbEF0JTVTGQkFolPo7P9o5H11u5J5jG6v7Z
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6584

The SMMUv3 IOTLB is tagged with a VMID/ASID cache tag. Any time the
underlying translation is changed these need to be invalidated. At boot
time the IOTLB starts out empty and all cache tags are available for
allocation.

When a tag is taken out of the allocator the code assumes the IOTLB
doesn't reference it, and immediately programs it into a STE/CD. If the
cache is referencing the tag then it will have stale data and IOMMU will
become incoherent.

Thus, whenever an ASID/VMID is freed back to the allocator we need to know
that the IOTLB doesn't have any references to it. The SVA code correctly
had an invalidation here, but the paging code does not.

Consolidate freeing the VMID/ASID to one place and consistently flush both
ID types before returning to their allocators.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |  9 ++---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 36 +++++++++++++------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  1 +
 3 files changed, 29 insertions(+), 17 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index cb0da4e5a5517a..3a9f4ef47c6b6f 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -381,18 +381,13 @@ static void arm_smmu_sva_domain_free(struct iommu_domain *domain)
 {
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
 
-	/*
-	 * Ensure the ASID is empty in the iommu cache before allowing reuse.
-	 */
-	arm_smmu_tlb_inv_asid(smmu_domain->smmu, smmu_domain->cd.asid);
-
 	/*
 	 * Notice that the arm_smmu_mm_arch_invalidate_secondary_tlbs op can
 	 * still be called/running at this point. We allow the ASID to be
 	 * reused, and if there is a race then it just suffers harmless
 	 * unnecessary invalidation.
 	 */
-	xa_erase(&arm_smmu_asid_xa, smmu_domain->cd.asid);
+	arm_smmu_domain_free_id(smmu_domain);
 
 	/*
 	 * Actual free is defered to the SRCU callback
@@ -437,7 +432,7 @@ struct iommu_domain *arm_smmu_sva_domain_alloc(struct device *dev,
 	return &smmu_domain->domain;
 
 err_asid:
-	xa_erase(&arm_smmu_asid_xa, smmu_domain->cd.asid);
+	arm_smmu_domain_free_id(smmu_domain);
 err_free:
 	kfree(smmu_domain);
 	return ERR_PTR(ret);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 5642321b2124d9..4f22eb810c8dbd 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2296,25 +2296,41 @@ static struct iommu_domain *arm_smmu_domain_alloc_paging(struct device *dev)
 	return &smmu_domain->domain;
 }
 
-static void arm_smmu_domain_free(struct iommu_domain *domain)
+/*
+ * Return the domain's ASID or VMID back to the allocator. All IDs in the
+ * allocator do not have an IOTLB entries referencing them.
+ */
+void arm_smmu_domain_free_id(struct arm_smmu_domain *smmu_domain)
 {
-	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
 	struct arm_smmu_device *smmu = smmu_domain->smmu;
 
-	free_io_pgtable_ops(smmu_domain->pgtbl_ops);
+	if ((smmu_domain->stage == ARM_SMMU_DOMAIN_S1 ||
+	     smmu_domain->domain.type == IOMMU_DOMAIN_SVA) &&
+	    smmu_domain->cd.asid) {
+		arm_smmu_tlb_inv_asid(smmu, smmu_domain->cd.asid);
 
-	/* Free the ASID or VMID */
-	if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
 		/* Prevent SVA from touching the CD while we're freeing it */
 		mutex_lock(&arm_smmu_asid_lock);
 		xa_erase(&arm_smmu_asid_xa, smmu_domain->cd.asid);
 		mutex_unlock(&arm_smmu_asid_lock);
-	} else {
-		struct arm_smmu_s2_cfg *cfg = &smmu_domain->s2_cfg;
-		if (cfg->vmid)
-			ida_free(&smmu->vmid_map, cfg->vmid);
-	}
+	} else if (smmu_domain->stage == ARM_SMMU_DOMAIN_S2 &&
+		   smmu_domain->s2_cfg.vmid) {
+		struct arm_smmu_cmdq_ent cmd = {
+			.opcode = CMDQ_OP_TLBI_S12_VMALL,
+			.tlbi.vmid = smmu_domain->s2_cfg.vmid
+		};
 
+		arm_smmu_cmdq_issue_cmd_with_sync(smmu, &cmd);
+		ida_free(&smmu->vmid_map, smmu_domain->s2_cfg.vmid);
+	}
+}
+
+static void arm_smmu_domain_free(struct iommu_domain *domain)
+{
+	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
+
+	free_io_pgtable_ops(smmu_domain->pgtbl_ops);
+	arm_smmu_domain_free_id(smmu_domain);
 	kfree(smmu_domain);
 }
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index cfae4d69cd810c..4631f0ac396dc3 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -774,6 +774,7 @@ int arm_smmu_set_pasid(struct arm_smmu_master *master,
 void arm_smmu_remove_pasid(struct arm_smmu_master *master,
 			   struct arm_smmu_domain *smmu_domain, ioasid_t pasid);
 
+void arm_smmu_domain_free_id(struct arm_smmu_domain *smmu_domain);
 void arm_smmu_tlb_inv_asid(struct arm_smmu_device *smmu, u16 asid);
 void arm_smmu_tlb_inv_range_asid(unsigned long iova, size_t size, int asid,
 				 size_t granule, bool leaf,
-- 
2.43.2

