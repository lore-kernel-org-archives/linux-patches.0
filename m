Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2060.outbound.protection.outlook.com [40.107.244.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 877CF13AA3A;
	Thu, 25 Jan 2024 23:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706227069; cv=fail; b=kFRVmEk58901YR5poabGAgjpBWRpG0HAZ8nNOboX0y4xReuZ1tJnnRjKMweYaEQk49djq7J2rDEWo8pVWCG37GxtMXJ6rOK/FYGq2Dye9410Vd5Nb5ZNdd3Jf1aO3klwMh//ZF9NZZpeVFfOxmMLfIRtSqJaWgREofghxH9vO4E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706227069; c=relaxed/simple;
	bh=5Mv/fJS1TjT1NQ+kC+88EKPdfqpWFNT+99xM/F05d9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DJrHPi1iy7WJau903g1fBEZrPJTuBJppwZ3D5yIISGFALXYm3ycxlzGwwRa+/iZ62h6YS+hCrSj3QQ12CoxdHBKvh50AZLBwRo3k0t37KYFr3WbilEsJ6NN1+REzx4ZEMt2mAR02GGeZ8tV3/jqcK4NgbOgdkFl4xXRxO5PKlx8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=gQWSzOwZ; arc=fail smtp.client-ip=40.107.244.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="gQWSzOwZ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iseWeOiNkHs3iNLiYdjJc964I5xMXH2FLtiYXzrN0DOQK6nXpJ5sY5rT8JTLOt10/Hg0FvGVtu1yF47Sxk5Zv4iGAeqyBBzEIsxdgv8/Ya4ZcpPH6P2hj5+94szNO7C1YEn1f5yq+vtD53JLZBdX9Df8iLu9JGYRpqFelIqsHaPgSGRy4Ro31W9D190cESAom4QEaYl7Kf1Kh++I1GAytIUsijxZyydOf1VDi5/aeJnsJ+aIWRYo38TW+niaytjl61zvA6gVMCU11omd2dViXByL9iaIDYXLyBXiSMAMFYVx8RunQaDdTZZV4h1C5wrcXaIjM595afNE/YsTPaRNqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KZMw1NPFKTEUTo9sC8m2eNQIR+/60UgUWx7GPJrxl/8=;
 b=TFW4vLBhimPnohwnLVnLP0x1pjNmyLjNnBrC8acm5qZ432g1sQqJG/eu9M5zfPFNQA25U8ZqEzSNVsfP2H8jaEqNzHbIZjWHa/jAikdpiSt29KZaR44YQtWqVGCR5/LwGf30zXKA+4D7BECLq3iOFCqeZc/iEi3nax5XrrYW4cXGXBuicirctbuKeenBxyvvrOg2rcQKZOOdFY0xnh1JP0KX0gFbo0hl4slrXqDsgoyQSPn//Vih8bLt21zWthAyKby5czxhOuDG/B3OwLXhrroDTPXMcJcwLFyiUe9HHoP4M3Ad983L1T2IvkaiPRo7OKdP1Eu4DOuJteTByneycQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KZMw1NPFKTEUTo9sC8m2eNQIR+/60UgUWx7GPJrxl/8=;
 b=gQWSzOwZyUrFMRqSZVAXlV0+ZWlK9PUzg8/zHlQhS/OUaM+V7OdmcaH/2JSD5Dkzv0yy/ncZ1Orw087kFvhTmiaNiEszXoZBspQebwGuZIiQ6ldUmmZWxkYoJESf6fpPbwOJIx4mPJB8B4gdymRUYiSjEDGqbzfLFwcu0C0QjHqFJ7pRXhFOFBU9Zvyc3EINPAx/DzggsZdsc1AuxdvbxWK7jdQzAMIa+u+NfF4DuRT+CCxM2qsE5WQwFILLp1+c9SGNqbeOINqgPN78hp6obla21TBKEkj8opRa6Tw2BPAp2FSmwQTy/paf9HENFzq6S3DG+M1k85SoH2vmytmJkw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SN7PR12MB7881.namprd12.prod.outlook.com (2603:10b6:806:34a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.24; Thu, 25 Jan
 2024 23:57:35 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7228.022; Thu, 25 Jan 2024
 23:57:35 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH v4 11/16] iommu/arm-smmu-v3: Remove arm_smmu_master->domain
Date: Thu, 25 Jan 2024 19:57:21 -0400
Message-ID: <11-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>
In-Reply-To: <0-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0056.namprd11.prod.outlook.com
 (2603:10b6:806:d0::31) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SN7PR12MB7881:EE_
X-MS-Office365-Filtering-Correlation-Id: 05609441-9ce1-4bd1-3a02-08dc1e016405
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	2wu+vFoeFcWzCQAHXLyARlMcxvDHq42Crbj3O2GUj23btEfeHKpS/AQv2iu9heyUekr0Ivyy04PLDzXQMASd3CMpl9/8g0Ylg3oGTJLi01ht3m+4/LV+uJvv9kytif6hFmHcc7VAft+hma2lrT2yH8DQZ9vcc/9gYPgKUrsUG1UDRudllc5OfNnu/moTVLUTvWQ137+RO+IRboAzEPkOPdYNc3qlr5mBVURGPuJm+95bBJx/h7b7oGGyWdkco+aWPcBPsmorAFLbOw1++SJrSpLV3+VlXmN2PB49g8nb5HzlEWn3FbgAnYfm0FQenIxXTsKUz3ivVW4V4yu3ZTbhbfnOY7OWSjxW+07pBVLeplchKRn3YM1ROF/iIb2hA0DLiFYk8GzXOf4taJ8R2sfV80s8ZPmfhJ8AyzYoclGprhTTqYn6VWE5mghBeotHOc9sX4Usp1rgE15aJ79Daq9eXQzp2oQo10ryWLntXeeSSuaSeQo2b/vh7Ctl0lJuvrBmkVrcEWRoIpiapZGiZ0x/2IRDvh+lG5q1AJq6ZDTSqL64fBAojYPnvVQv+I4O45X3
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(396003)(346002)(39860400002)(366004)(230922051799003)(451199024)(64100799003)(1800799012)(186009)(83380400001)(36756003)(66556008)(86362001)(54906003)(110136005)(66946007)(66476007)(26005)(38100700002)(6512007)(2906002)(2616005)(7416002)(478600001)(6666004)(41300700001)(6506007)(6486002)(5660300002)(316002)(8676002)(4326008)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?000sw2O9eSD1cN+kq2iM/n7liJDlfvgwU8xRN65g3HWdy9c6584E9PTCpdev?=
 =?us-ascii?Q?Pmw+FBePLd5UXcSE7ZqcRRGuquNleHz/sbA0DpuDe8GiVGMhwBtG7oSP1AV7?=
 =?us-ascii?Q?DtM3Bmy/aFRckcs5WDzYtcCCmmmPQIILKZn78XxU1W/OWv5XEkZYSYpqxOqL?=
 =?us-ascii?Q?I2DOBES//0VXxMSLGN+OxWCv0FkKyi5wJB93O/3J554tJzkPGywOnTAFKz75?=
 =?us-ascii?Q?OVXXZfcPemt7ctpUouq1JeyQJpyZ8C/PpqChHo2Myhj459BIF5tSVv8SFFur?=
 =?us-ascii?Q?28gUg5AnxRbxX9evKkjo9sZ21TnN9HHSdAMEOAs5s2D56XxKRrBQ5sn6x9ho?=
 =?us-ascii?Q?XoRMUo4Ob2VO9Ojvzm0qGGkwwOU4HTayuVhAsJKNloMBaoSXHY1it4s4LlHV?=
 =?us-ascii?Q?vEXLb9H+Hp1vbbpK4zT6MtueEAwNg+K5rEJsGqkVmpIYDua2giV/KovFWijs?=
 =?us-ascii?Q?AeBBq4imw4nQpv4iugR7yH95i8cGsWEF4+h5pzNAyqt4aLKqPUdgCpx975fx?=
 =?us-ascii?Q?+Hng1+imxnRlMRtxXUp+MKBBv8o8pvGohDV2J5JSyzHrPI21ycPFuDcSf0ZN?=
 =?us-ascii?Q?k5wY2uhC5acweuFnjQjUdPqFRYXJDi+QxwLCtSklDCMCQQnTS6qkNrqb6yxN?=
 =?us-ascii?Q?qImyrzkf2JhPD9dBZaIaJJWznm2fNCER3hdxBwX+KbgUZTWDi78QL7+Yka01?=
 =?us-ascii?Q?v0idTKXImPdQdm+XSSWCP24WrW7ePlNCx34mUgQVyZ5jYJ30KnNu9+asUVPb?=
 =?us-ascii?Q?ATNlD+CNoFftRE1ogY/otOAwfG4ElCmcwJlrZdFdUdorg9AheXPbecXylrt+?=
 =?us-ascii?Q?TJx7c89/zLcMtI6ObFaBOriAymGscIYXUn3mB5j9webbXnyIf20pvX0c4DMB?=
 =?us-ascii?Q?OnSVRnQku89FdGETagXV/YWg8kjFfaQA+xN13S9sHXSDFtzscWmHmzPmsuaS?=
 =?us-ascii?Q?1P+Smolm50lH+MY+2vmfg5lqD4FA5rCu6EQAaJJOdF6XPZZDqVVneNpga1d3?=
 =?us-ascii?Q?WG51JrLbvIUESu9ZSu42RYfyuiKziFJ37kGvKuGW9CgbKdSConDFe1cRovYj?=
 =?us-ascii?Q?OTMqb1PF0luomZI/eLF9dXcxghVpX3iXStT7BCS9l0fh6PYiH25BVZenBw54?=
 =?us-ascii?Q?zXuihGmG7mBoaqGBq8b+wZst1/SuB/tV/YyHGoypbbrvfE2Tm2sWtQJ2YhNO?=
 =?us-ascii?Q?EoJYjtnrhXGlx+htlzflCO9/kEcB02+u+R8GZaln+Ifq18fWwbBVYFIQp5/D?=
 =?us-ascii?Q?AaLBzQFRkb4xsdFpo5UL2Goy7lJGeA4RC6wGZ/NBRlHSoA2zgs0Tx82+oB9C?=
 =?us-ascii?Q?Fgo1EBTZohpy4YVUEN+cqSH7M2UtKVCDpqWr0uMXdowEIGTBW1IgXORXpisH?=
 =?us-ascii?Q?p3QKZo2QBCNBsfesJJQbZby9Ps9OHyM2vbJXMItoYKfbE2JknCJKLH19aGA9?=
 =?us-ascii?Q?OHI8An4rlf5N1BBNgNWdQ5vUrddr0JTDHnjHZt5nJ7ey0KcREYJLxLaKyX0O?=
 =?us-ascii?Q?/xZcNJoON9Cui4zBGhm1rmDyZGZW3lYbtu6BGVEjUiD5pXltLp4crO6LwfNW?=
 =?us-ascii?Q?YtU/yOUB6KK2dQ7/jaQtzLhNbYPY/4sfKk84KkZL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05609441-9ce1-4bd1-3a02-08dc1e016405
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2024 23:57:30.2676
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ShBlJCOuS8XOMndYTcONxdoCTKneUEvtMMwQ1DWkNNmtMXn3ovuzB+9oB06bd9oy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7881

Introducing global statics which are of type struct iommu_domain, not
struct arm_smmu_domain makes it difficult to retain
arm_smmu_master->domain, as it can no longer point to an IDENTITY or
BLOCKED domain.

The only place that uses the value is arm_smmu_detach_dev(). Change things
to work like other drivers and call iommu_get_domain_for_dev() to obtain
the current domain.

The master->domain is subtly protecting the domain_head against being
unused, change the domain_head to be INIT'd when the master is not
attached to a domain instead of garbage/zero.

Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Moritz Fischer <moritzf@google.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 26 ++++++++-------------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  1 -
 2 files changed, 10 insertions(+), 17 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index d7b0cea140f12b..f08cfa9b90b3eb 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2533,19 +2533,20 @@ static void arm_smmu_disable_pasid(struct arm_smmu_master *master)
 
 static void arm_smmu_detach_dev(struct arm_smmu_master *master)
 {
+	struct iommu_domain *domain = iommu_get_domain_for_dev(master->dev);
+	struct arm_smmu_domain *smmu_domain;
 	unsigned long flags;
-	struct arm_smmu_domain *smmu_domain = master->domain;
 
-	if (!smmu_domain)
+	if (!domain)
 		return;
 
+	smmu_domain = to_smmu_domain(domain);
 	arm_smmu_disable_ats(master, smmu_domain);
 
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
-	list_del(&master->domain_head);
+	list_del_init(&master->domain_head);
 	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
 
-	master->domain = NULL;
 	master->ats_enabled = false;
 }
 
@@ -2599,8 +2600,6 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 
 	arm_smmu_detach_dev(master);
 
-	master->domain = smmu_domain;
-
 	/*
 	 * The SMMU does not support enabling ATS with bypass. When the STE is
 	 * in bypass (STE.Config[2:0] == 0b100), ATS Translation Requests and
@@ -2619,10 +2618,8 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	case ARM_SMMU_DOMAIN_S1:
 		if (!master->cd_table.cdtab) {
 			ret = arm_smmu_alloc_cd_tables(master);
-			if (ret) {
-				master->domain = NULL;
+			if (ret)
 				goto out_list_del;
-			}
 		} else {
 			/*
 			 * arm_smmu_write_ctx_desc() relies on the entry being
@@ -2630,17 +2627,13 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 			 */
 			ret = arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID,
 						      NULL);
-			if (ret) {
-				master->domain = NULL;
+			if (ret)
 				goto out_list_del;
-			}
 		}
 
 		ret = arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID, &smmu_domain->cd);
-		if (ret) {
-			master->domain = NULL;
+		if (ret)
 			goto out_list_del;
-		}
 
 		arm_smmu_make_cdtable_ste(&target, master, &master->cd_table);
 		arm_smmu_install_ste_for_dev(master, &target);
@@ -2666,7 +2659,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 
 out_list_del:
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
-	list_del(&master->domain_head);
+	list_del_init(&master->domain_head);
 	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
 
 out_unlock:
@@ -2867,6 +2860,7 @@ static struct iommu_device *arm_smmu_probe_device(struct device *dev)
 	master->dev = dev;
 	master->smmu = smmu;
 	INIT_LIST_HEAD(&master->bonds);
+	INIT_LIST_HEAD(&master->domain_head);
 	dev_iommu_priv_set(dev, master);
 
 	ret = arm_smmu_insert_master(smmu, master);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index eb669121f1954d..6b63ea7dae72da 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -695,7 +695,6 @@ struct arm_smmu_stream {
 struct arm_smmu_master {
 	struct arm_smmu_device		*smmu;
 	struct device			*dev;
-	struct arm_smmu_domain		*domain;
 	struct list_head		domain_head;
 	struct arm_smmu_stream		*streams;
 	/* Locked by the iommu core using the group mutex */
-- 
2.43.0

