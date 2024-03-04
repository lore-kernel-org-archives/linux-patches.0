Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 168037D3EA;
	Mon,  4 Mar 2024 23:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709595874; cv=fail; b=pRQ32g1t9lnwd5oEesGuvNG0BHMcNekpkx7dXdUXXaUnJWFvHMPMzQOM59hn/BVrNcdR4nvdrgSUYwQ8eVLWdvvrhQvFXgcVVRJPXbeKMZNaphIC3Luvla4uzPP2wBHNlboRFi7s8RhG9ppi5BqbFvo2V/5/XvdVzrbSoLl2cGw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709595874; c=relaxed/simple;
	bh=bjubINUKER0wUkMVMJ+ik+v5x5VPvrs7Soc9P52yGKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JXpMni+0f+E/orOOffIPUthI9qPHo/p3u5yTSaonfyqBIXrpDsP9zkLVLUuwCO1qZiAhexSQjkFGpd9LzH0P0tmePtVgESzPKEc6FM0zxJUE2kFhK5V6Okon/Ei+eEjo+CAU+YyV48ZZLCajZErGf+MiqaIs9ssdZphSnxw6680=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qnerxKzg; arc=fail smtp.client-ip=40.107.236.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qnerxKzg"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RCrFlzIcWxz//Re6WeR+HZhZJNNQo6lAmYkpoEFGiT/8d7dhyZELTVUKDB9/KSU+yWo/AAwwLwy/wpfxlyBHmg7Ufw6uP8PObg+Oq6/O72nMcnl1RmtY92EGgFxECwOJNfsOUZ3n/KHFtlFYP9gjXah/O+RnU0aC97pxFiIDg8xhfUKq8g4R9ylgn8Q5nHuk6RCZPmrQ8h9TZY0DxEwNemDtNFZCno5LEcDkjADwipj33kZ6U9nXOhol4I2e1hTIIMbYewt1KOESYjSJbqDYgFrxB3T5LOgenFkxojanm2TSEey4n8+4T3keL5ACLIiWBq7mU8wcHrAu3m/eD3KZ3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CFph/WHFeYhFYNx4KhZm7hBg+/Ce5GYRWaxhmURxLIs=;
 b=HGoCGEC3iwlctUKmWjseKF8EJyVDkF2kEoaTpqZP8J8UhlXroX6Mul97gU0CE2RLECf9Kh7o/m5jYOud5MjLzajj7boO5rrb47SZSOeCikY5NsjFBeiYiBVg+srQkBKloebqbWrlFug4zpAPWem7ubTdVJCWtLAqk3LMglUKn/5+eN+uTNk2DsT7g39+wL62SfP32SZ9mmoA/0BqBQKWCdIfdRN69NnbRXKD5hnJsigrUv/aEdDZw2w1CHU5HMPvopmEZ/0duVs9m37rxWQwt3VHYE0gULrpQHt0v5gj1B8oX8Mzw7pxrPonxg8LRGmPTmlJL0vULLdO3GwAphfQ4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CFph/WHFeYhFYNx4KhZm7hBg+/Ce5GYRWaxhmURxLIs=;
 b=qnerxKzgIQzcME0KGrh+hbanJen0u5AsrbLwMc9m3HiHw11/s++MFeZY0GgbD/ulAbNPZW4STa4REg+skl3XRC6qR5r0UoqGSWvulw03cAyH8e3GmlHQNpavttvwEU/js45uMzLkkXhtjTGpO7ulPbnmLaxO9EBxttBllEk0+CC3AvRg+aWR5b3P1NC3wsvgzEI1wnZ6GmU9x5guwn4keeldqbnz6JtqQ+JmhNdFE1aIIx9doS1ZAC9JDSTQALYRnGimBpdLzmWgLb5uYCg8UCVmx72aPRuM21qgrkIaUhobDiZa+crfeUJgYJRLRo2r1zjkVHMdiJpI1NKTj+GmxQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by DS0PR12MB6584.namprd12.prod.outlook.com (2603:10b6:8:d0::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7339.39; Mon, 4 Mar 2024 23:44:24 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c33c:18db:c570:33b3]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c33c:18db:c570:33b3%5]) with mapi id 15.20.7339.035; Mon, 4 Mar 2024
 23:44:24 +0000
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
Subject: [PATCH v5 23/27] iommu/arm-smmu-v3: Move the arm_smmu_asid_xa to per-smmu like vmid
Date: Mon,  4 Mar 2024 19:44:11 -0400
Message-ID: <23-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL6PEPF00013DFC.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:22e:400:0:1001:0:21) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|DS0PR12MB6584:EE_
X-MS-Office365-Filtering-Correlation-Id: 38791586-145b-4802-2ed0-08dc3ca501b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	rv+PvqCaw2DB7JeNmVlUEnZx1lJm/0sIl/PLJEfGXbEQDcHXvH81pCGdLGgkwGSvMnyNzY17aD/paRrl64Zf8E7HL1uijHzBIJ0o3ECuQVKpyweMI1We5skGZlzK38cg7ylB2dsgrGTY/HeXJRt30+lseED3uc2z/ClrjzfXBezE+hMcx5bN0NC0Sk6SYPI/UJDoQJqS/X2nCRqJXgHSJcIizpnQOpRTv5iCnDYp9hc5+74CCKbPzRSg87+xXKbPCKv5ZjPlU56jV8JtOO7vDTXYmAn67C2VUVGP10euWZQgpSZZOErZjAmjOGf2qRX9LHmCjSGslDHBJuAvoThxWlTQ+3ML0yWsHCTG5e7vCqxI5huqkqG/uo7wUr+A+0igs8Azjui+LPN06HdUXo0ZDCw1BL2IcEqxP2Z/noDiEmcl6GO0XtRFKMT3k7J4G8pjnFWJZ4tiLcu0F8NW9gSQKRInlHLhueqeQC9slEmQEV8MLhcQwEQkWlsky2WkD7ilMS0NlFXgXZ9W6ObE+UcbansnSCcZQY6bjboCRa4v3z3xTqCdDH+WUs7oDgIvi4PunxpKF98/TMahjzA65+wVJaX7ZF5LaD5QpSRg5LJIK/bAJn+1TXrxfhUihujkZJrvLCd0ctkZfCEB00uRl4tq9UnFCYYDq3sPCrYRRqmFDfk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KHyuTQSWGcStnYiqj9QCVQpUM2Bcm1m4eDl9Gvcq1f/nO5oA1yLwTJTstnO2?=
 =?us-ascii?Q?HW9Rt049ZQokleFJLBW4u5DkMLTNGBK40f4XHO5BAOVYA32u1jEOCWHTEwMS?=
 =?us-ascii?Q?B2W6flymKHH5eTm4b4iG3wYO6d4LZ1fnx0KzqsJxJMFUo7cy+GiLpaX3kXDH?=
 =?us-ascii?Q?mT/atzgZFO4Tk5LJB6tGYcyfVbxlUrtN6EiH85rW+fDjes+mBaSzMB54LUjt?=
 =?us-ascii?Q?KZlb5fhWLWIlGbK+ZXRxhM/NGamXATViKVqFTNwhGTgXTB0C1wMWklfB7eXU?=
 =?us-ascii?Q?gN3gv3sel8X6CW/7vJTqKJhj5O16wMWyridDTAgkFkWqqh8Y+qJOorIpebWM?=
 =?us-ascii?Q?CbhGXUgDXnmYLO2BoM5HU5WXtsx/EZfPhh1DT+J1HDzspGR2XyPCHVeSv5QZ?=
 =?us-ascii?Q?qMWShKFMoveEUrkmzRbVVtsF6XB0afggIztf5yBf72xyTrI4yc4Z/LccPZjP?=
 =?us-ascii?Q?3JvLJwDSmhTlOjSBxI+xv9wAR/OUWOcgAUpKFl9pFfpnfRTQu6DMyWbrh/1D?=
 =?us-ascii?Q?ERGlixvNVtrBjGg47BIzmjn9D1eeZJFZRwpYVw2mu8RtlU8a6fylwYitg/sy?=
 =?us-ascii?Q?AeDy0R2ed7O+yZCd6HXTv0ACv0MVJemEA/FYC7ScgeBX6vvbztk52XUonowC?=
 =?us-ascii?Q?Mt3EuIobXLkm1KhkcqH9LmBi2O95MeS0WS0Wmt8BZfO1H01vzLyWH7gRslsE?=
 =?us-ascii?Q?B85N733hIxEP9dT51FeP8YdXTL81oni0WLk2M0tYBY4B1/1gWqndzlwuaO8T?=
 =?us-ascii?Q?GEfa/OPHcfacQOFkJShrDC7ueAqndlPsNHZA7Gx4T6dGAD0itAmmB+LT44td?=
 =?us-ascii?Q?iCMyeZfJNSaV0G7JT/ruWOjs9ejCslBqKMJIeTcFO9yF+9+bX/rHSO+n+eUs?=
 =?us-ascii?Q?pwBjx0AkLCjFwJzTqygJFKTL3WKJK2T1tnHi5mGgN9kK6k5VeMUPOqlnQAxr?=
 =?us-ascii?Q?LeXDnFOucM5FnUBQBg/88irAqv11oGh+0GOQ32o14hxUwKAzUfro+Bq3j8DC?=
 =?us-ascii?Q?BztDxRQZhLOiBdkJtjdw9oiuZvRrhY5YGlagJx0zt2pXtia80WEOZJKcxOAy?=
 =?us-ascii?Q?9KT0aPVLwkAcerd/n71SeuCRESPXMUXcpjXUWEf2iNcBM2S/ze0Bc3UBPEdR?=
 =?us-ascii?Q?cw5pAsoZLnvM5X5KyCQRsfSu1dzf3NUKIwJoKIY4rW7vK4fSgIxDUpZT6ufl?=
 =?us-ascii?Q?I2mP6AJgrSiBtJgX7YGRHjfkesRxLwz8HGO1EOdycqYlpjhcfZI5wI35ChUK?=
 =?us-ascii?Q?nRZtiygAsclATmNVf8AuYgCvt0s15JYV+0FLzh/sf7jkgG6N3RC+inAvxXvB?=
 =?us-ascii?Q?aOtWo6d1ebhwGFmgyBkk5fAMp2iPga5SfMDjKc2/Dyuu/HbcsC4c3GcAV5wf?=
 =?us-ascii?Q?05vimuUg/Rx30cZfmlFCv7snCRpUkm5CNVg2LiYkKAL+zdVh8+zI0tdbUhbg?=
 =?us-ascii?Q?P9P4tAqa2LLyIXyGze6sRu2H4yUdyhoAtA+fsVfQouNrEmKbE4QCoQXqwX1k?=
 =?us-ascii?Q?gB4CoC9tExakSOFOOHXgNFWPUooC8MB2OZGBlPtvVENr06l3rnvjyjfouH3G?=
 =?us-ascii?Q?rw6BDTvo2EVJ1msyQUgise5yEyeQuqc8pQ82E4ur?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38791586-145b-4802-2ed0-08dc3ca501b8
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2024 23:44:17.7455
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BVoeHVJx2E1MzimAz24LiHf790trkRXh36seuHliQdRwvoZ3CSm7UWyWkSen0U5E
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6584

The SVA BTM and shared cd code was the only thing keeping this as a global
array. Now that is out of the way we can move it to per-smmu.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |  2 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 39 +++++++++----------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  5 +--
 3 files changed, 22 insertions(+), 24 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 3a9f4ef47c6b6f..3acd699433b7d8 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -418,7 +418,7 @@ struct iommu_domain *arm_smmu_sva_domain_alloc(struct device *dev,
 	smmu_domain->domain.ops = &arm_smmu_sva_domain_ops;
 	smmu_domain->smmu = smmu;
 
-	ret = xa_alloc(&arm_smmu_asid_xa, &asid, smmu_domain,
+	ret = xa_alloc(&smmu->asid_map, &asid, smmu_domain,
 		       XA_LIMIT(1, (1 << smmu->asid_bits) - 1), GFP_KERNEL);
 	if (ret)
 		goto err_free;
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 4f22eb810c8dbd..1a72dd63e0ca14 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -88,9 +88,6 @@ struct arm_smmu_option_prop {
 	const char *prop;
 };
 
-DEFINE_XARRAY_ALLOC1(arm_smmu_asid_xa);
-DEFINE_MUTEX(arm_smmu_asid_lock);
-
 static struct arm_smmu_option_prop arm_smmu_options[] = {
 	{ ARM_SMMU_OPT_SKIP_PREFETCH, "hisilicon,broken-prefetch-cmd" },
 	{ ARM_SMMU_OPT_PAGE0_REGS_ONLY, "cavium,cn9900-broken-page1-regspace"},
@@ -2310,9 +2307,9 @@ void arm_smmu_domain_free_id(struct arm_smmu_domain *smmu_domain)
 		arm_smmu_tlb_inv_asid(smmu, smmu_domain->cd.asid);
 
 		/* Prevent SVA from touching the CD while we're freeing it */
-		mutex_lock(&arm_smmu_asid_lock);
-		xa_erase(&arm_smmu_asid_xa, smmu_domain->cd.asid);
-		mutex_unlock(&arm_smmu_asid_lock);
+		mutex_lock(&smmu->asid_lock);
+		xa_erase(&smmu->asid_map, smmu_domain->cd.asid);
+		mutex_unlock(&smmu->asid_lock);
 	} else if (smmu_domain->stage == ARM_SMMU_DOMAIN_S2 &&
 		   smmu_domain->s2_cfg.vmid) {
 		struct arm_smmu_cmdq_ent cmd = {
@@ -2342,11 +2339,11 @@ static int arm_smmu_domain_finalise_s1(struct arm_smmu_device *smmu,
 	struct arm_smmu_ctx_desc *cd = &smmu_domain->cd;
 
 	/* Prevent SVA from modifying the ASID until it is written to the CD */
-	mutex_lock(&arm_smmu_asid_lock);
-	ret = xa_alloc(&arm_smmu_asid_xa, &asid, smmu_domain,
+	mutex_lock(&smmu->asid_lock);
+	ret = xa_alloc(&smmu->asid_map, &asid, smmu_domain,
 		       XA_LIMIT(1, (1 << smmu->asid_bits) - 1), GFP_KERNEL);
 	cd->asid	= (u16)asid;
-	mutex_unlock(&arm_smmu_asid_lock);
+	mutex_unlock(&smmu->asid_lock);
 	return ret;
 }
 
@@ -2633,7 +2630,7 @@ static int arm_smmu_attach_prepare(struct arm_smmu_master *master,
 	 * arm_smmu_master_domain contents otherwise it could randomly write one
 	 * or the other to the CD.
 	 */
-	lockdep_assert_held(&arm_smmu_asid_lock);
+	lockdep_assert_held(&master->smmu->asid_lock);
 
 	state->want_ats = !state->disable_ats && arm_smmu_ats_supported(master);
 
@@ -2685,7 +2682,7 @@ static int arm_smmu_attach_prepare(struct arm_smmu_master *master,
 static void arm_smmu_attach_commit(struct arm_smmu_master *master,
 				   struct attach_state *state)
 {
-	lockdep_assert_held(&arm_smmu_asid_lock);
+	lockdep_assert_held(&master->smmu->asid_lock);
 
 	if (state->want_ats && !master->ats_enabled) {
 		arm_smmu_enable_ats(master);
@@ -2747,11 +2744,11 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	 * This allows the STE and the smmu_domain->devices list to
 	 * be inconsistent during this routine.
 	 */
-	mutex_lock(&arm_smmu_asid_lock);
+	mutex_lock(&smmu->asid_lock);
 
 	ret = arm_smmu_attach_prepare(master, domain, &state);
 	if (ret) {
-		mutex_unlock(&arm_smmu_asid_lock);
+		mutex_unlock(&smmu->asid_lock);
 		return ret;
 	}
 
@@ -2775,7 +2772,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	}
 
 	arm_smmu_attach_commit(master, &state);
-	mutex_unlock(&arm_smmu_asid_lock);
+	mutex_unlock(&smmu->asid_lock);
 	return 0;
 }
 
@@ -2805,7 +2802,7 @@ int arm_smmu_set_pasid(struct arm_smmu_master *master,
 	if (!cdptr)
 		return -ENOMEM;
 
-	mutex_lock(&arm_smmu_asid_lock);
+	mutex_lock(&master->smmu->asid_lock);
 	ret = arm_smmu_attach_prepare(master, &smmu_domain->domain, &state);
 	if (ret)
 		goto out_unlock;
@@ -2815,7 +2812,7 @@ int arm_smmu_set_pasid(struct arm_smmu_master *master,
 	arm_smmu_attach_commit(master, &state);
 
 out_unlock:
-	mutex_unlock(&arm_smmu_asid_lock);
+	mutex_unlock(&master->smmu->asid_lock);
 	return ret;
 }
 
@@ -2831,12 +2828,12 @@ static void arm_smmu_remove_dev_pasid(struct device *dev, ioasid_t pasid)
 
 	smmu_domain = to_smmu_domain(domain);
 
-	mutex_lock(&arm_smmu_asid_lock);
+	mutex_lock(&master->smmu->asid_lock);
 	arm_smmu_clear_cd(master, pasid);
 	if (master->ats_enabled)
 		arm_smmu_atc_inv_master(master, pasid);
 	arm_smmu_remove_master_domain(master, &smmu_domain->domain, pasid);
-	mutex_unlock(&arm_smmu_asid_lock);
+	mutex_unlock(&master->smmu->asid_lock);
 }
 
 static int arm_smmu_attach_dev_ste(struct iommu_domain *domain,
@@ -2852,7 +2849,7 @@ static int arm_smmu_attach_dev_ste(struct iommu_domain *domain,
 	 * Do not allow any ASID to be changed while are working on the STE,
 	 * otherwise we could miss invalidations.
 	 */
-	mutex_lock(&arm_smmu_asid_lock);
+	mutex_lock(&master->smmu->asid_lock);
 
 	/*
 	 * The SMMU does not support enabling ATS with bypass/abort. When the
@@ -2865,7 +2862,7 @@ static int arm_smmu_attach_dev_ste(struct iommu_domain *domain,
 	arm_smmu_attach_prepare(master, domain, &state);
 	arm_smmu_install_ste_for_dev(master, ste);
 	arm_smmu_attach_commit(master, &state);
-	mutex_unlock(&arm_smmu_asid_lock);
+	mutex_unlock(&master->smmu->asid_lock);
 
 	/*
 	 * This has to be done after removing the master from the
@@ -3516,6 +3513,8 @@ static int arm_smmu_init_strtab(struct arm_smmu_device *smmu)
 	smmu->strtab_cfg.strtab_base = reg;
 
 	ida_init(&smmu->vmid_map);
+	xa_init_flags(&smmu->asid_map, XA_FLAGS_ALLOC1);
+	mutex_init(&smmu->asid_lock);
 
 	return 0;
 }
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 4631f0ac396dc3..6becdbae905598 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -675,6 +675,8 @@ struct arm_smmu_device {
 
 #define ARM_SMMU_MAX_ASIDS		(1 << 16)
 	unsigned int			asid_bits;
+	struct xarray			asid_map;
+	struct mutex			asid_lock;
 
 #define ARM_SMMU_MAX_VMIDS		(1 << 16)
 	unsigned int			vmid_bits;
@@ -753,9 +755,6 @@ static inline struct arm_smmu_domain *to_smmu_domain(struct iommu_domain *dom)
 	return container_of(dom, struct arm_smmu_domain, domain);
 }
 
-extern struct xarray arm_smmu_asid_xa;
-extern struct mutex arm_smmu_asid_lock;
-
 struct arm_smmu_domain *arm_smmu_domain_alloc(void);
 
 void arm_smmu_clear_cd(struct arm_smmu_master *master, ioasid_t ssid);
-- 
2.43.2

