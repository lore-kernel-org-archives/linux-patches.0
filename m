Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2040.outbound.protection.outlook.com [40.107.244.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E26E86D1B8;
	Tue,  5 Dec 2023 19:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="eZRAbNP9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g0DtNyNnoJOmgdAWiunZXDZDYoaKdHNAtOv4J3/EXOsikt0h2k5JgKzMbgduLcPav9QlDDjtK7a120+BR9aF9Cm1YFiocGttZ/t8RDJA4C2Uqq/i1ExbOBAzeYC3LcK3wl4XrkUn3BciftSs/yGspZYqOdKqO+uOXzGiB5BpUZS/dR2AF12OBCpR8mMIpZabqIT2vWlwiZNIh7IVMIYExkkffUVMOCYtisBe5IajQXcs3PgdeeP4p4VcrgMaP6tUxrg9Zmrqzxwm5DwjHCNUle67/wZKyy3oZamkpEGVuyS0kSrAycdD7F7f1WO3UAXgi/w/IET13fQ39dJg7FKb0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8eIQmUzP0O/mO7GvmBmw5epn598QLWV/13gSPogNoQI=;
 b=RrTNDkr0Qt4UzicdWT2AtWneBWpC3jtZ0W+L/O3ndU3jyP60u9GqriGSI6aUaPw1enbAAd+3S3s5LiQ3okduy/LMpLbxwpJYBkChX/q5ZsXj0fR1oKz1vSsrFIBdcTXDnpFu8tiIYpjQLY23JD0z6WUWsraShizOSoMrgsVnuxc6xPCuOwxN0zlfO5waH/+bTur6Adj27r8sBxT2kHbbe7YGj58PGjIi0ZT1xMe6XsU+BP4UU/0yeAIuKa+2CFC6QGw8gxk+WJXzgGyDuZ9dYuF58FtjbY30BMPTlG6bc8kRICEXODehQGgM67xrKhcXZ1CJwSfNclefj+EzoQxsGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8eIQmUzP0O/mO7GvmBmw5epn598QLWV/13gSPogNoQI=;
 b=eZRAbNP9oTSm5jDKJChQJe4Hhmmh4rkIuFUoyeRpp2VGTSsdpmYu4bZHIB8oYDaFlaM4Idln9+lhY8YRXHCzGR97tZmg/l0OmxO0oFNnp0O5ocWsCRl30hvaokNOQXH8P+qRIp5vM0P7cri6GKTjOwYZ47R27ctaelzjTawFVZuSRh1aW79gnyfc/dBOq2gKlU+loelggDnXKvItI0i9WRfQxovkQcqC/ODNat4vZxJEb7qY4sZG/IDMiRBsG4B4Lmni44vqUK4XIxYK0UmMbHEYtAXTYiSV0t2n5mitjjRt01iqO0R3tGZhY7yLcx+SyEGGFpXsSNYuHC5yW540XQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB6588.namprd12.prod.outlook.com (2603:10b6:510:210::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Tue, 5 Dec
 2023 19:14:59 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.034; Tue, 5 Dec 2023
 19:14:59 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH v3 14/19] iommu/arm-smmu-v3: Remove arm_smmu_master->domain
Date: Tue,  5 Dec 2023 15:14:46 -0400
Message-ID: <14-v3-d794f8d934da+411a-smmuv3_newapi_p1_jgg@nvidia.com>
In-Reply-To: <0-v3-d794f8d934da+411a-smmuv3_newapi_p1_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL6PEPF00013E00.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:22e:400:0:1001:0:1a) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB6588:EE_
X-MS-Office365-Filtering-Correlation-Id: 9bf36191-fddb-4f1e-5f03-08dbf5c67591
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	bNRUfq2NAK5Y2zGzCggfXGUPt1CneAq7egTeqoHPcRXlXWbsuduO16WW+UGrJNYm1RMUwMNKqiKpMVk25FyKnPKcCXnS5Pw46yF+jcfZP+YkRt06robb94OV9ZhWNqiWGsZZfwkw+1nFj61jg8qLWZWCJ2DJugl0ib2cN14rA6CEczZ42vxOmIxwCe2J6YiH9zIuD4PHS5OfW60lvtTeGKxswPfLS26lrKvVYR+1djrUSh53E44onHgW9u2k+ZF2GLxAKQlG3pgEPpmQSk6zHFmp619pRXb87Ep4LJtQMSTlLWoLysnOZkxpL8+wGm2FIbrCX2APiqdTLljwloHPBKmsiaX+EkXSCTUZr1hSbZGZAcWqujYaDtmqFmnm4mpjxMjWa+nCX43+lZE446ug9muEcectqLjgnxI5Jktrdg1VLs2aMl0LgyBRU9qkKcDk1emnr9jge05Evn+/ijsGRxuHYC0312l1zxKpWgI5CJurv2BiDvUo28K9p6p87cfPZQ2J4haaU1jXpMB6JaAmmZ7Qc8x3ssAEbpF5taFxSlTGB5v1fMNsyudIxvYU5WYM
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(136003)(396003)(346002)(376002)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(478600001)(6512007)(6506007)(8936002)(6486002)(2616005)(26005)(6666004)(54906003)(66476007)(110136005)(66556008)(8676002)(66946007)(4326008)(316002)(83380400001)(38100700002)(7416002)(36756003)(5660300002)(2906002)(86362001)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7s29WrsdmJIvPssZ+WaKXAbGqRD09NxBmPpg0t1R9JypvVq4V+L96Fn7Ceul?=
 =?us-ascii?Q?BburJatUL0JO3yG3u7AxmdO4B3CU0xAfoHyk8itCXf1bDnalhjIH9u8gTtpn?=
 =?us-ascii?Q?gQRvB9FMXgFVjIRDwFByDghFYa/ORB1vvGuA/eAoZjBAJnbWDTWks2dy0fzZ?=
 =?us-ascii?Q?+A7i8wpJ9wouiacAAL5LrD02yFM/JuywM4R2V6QeB0hgxh9UvrXiapWimGG4?=
 =?us-ascii?Q?+o5DzUe7dkclH9fSKK1UGguPFfSzFaOs17pd7BMZnFCNeddbWP1k9yZm5oik?=
 =?us-ascii?Q?Xt9F9CZUKhWZ1B6Ht+NDx+ECN3m9lkC0xwFC5FividTKAj92CxsoMoYM7uel?=
 =?us-ascii?Q?ObEK3Ce4z38V74psP69XZjyrUzJYDA0cHDPz90KXt1ACm1PnEwtN2yojIwYa?=
 =?us-ascii?Q?KqwdwtKmCJmOwkN777Qy7z8K//pFfs694PW0J5uc02+E//C9whGW53Po+FeH?=
 =?us-ascii?Q?RHRISAN6xe2WVmE3xROcANFC7z7F+XTO81/hoTP3BoLJC9CqjMhM3UPGfkna?=
 =?us-ascii?Q?gXMoGHloTS/avMYUupfoARXyf0J9BDXH9BEWmv0h3m7mSoO2P2ztpyeepHSp?=
 =?us-ascii?Q?U/XNy7uWp6K38XLAIl6NaQKyUu538uPOUZ7AAJ5dYXnsWdFt343WURTPCZij?=
 =?us-ascii?Q?L69LVyNKcORUR/8Rs8rIPO8uCv9dLXk8/YKCCHBao9cquWgaUHMpxZhzISnP?=
 =?us-ascii?Q?lOVgoAngXvEuKJSvazvT9ktU42ygyil/2QsYLyUvJStaHOaS8juRD153VoXD?=
 =?us-ascii?Q?udSmixPwTdHhthw5gZFhBv6nwHlXtdZoGqmKoNN+GQIdjQYB+yfi8/s/QQLf?=
 =?us-ascii?Q?2guOzrQahLUOFbEQBOT5brxviAADk50MA73jNK9/nBbEqUv8FcqvtpYfhoRp?=
 =?us-ascii?Q?na91tDcHz6O8tGQwlPn9KBEol4yKYG+EAlQf9hZjwIffqQbobxhlo6CXYJaF?=
 =?us-ascii?Q?jU62jhIrdLMGEpxPGB7BIG52zZiepVU+dY6jAyV1s29zY19arB+1kqGaHBYh?=
 =?us-ascii?Q?XiTGP0eNnpNyfPIXCbqrX0bWx7SUYqXoF3RJNn6+VAm2FiUEVHfGEjU0kSpa?=
 =?us-ascii?Q?Tyqo30EcvF65iGjQ+sYE2iVspNEC2TcvyqKNmPw+CDdYq/WvUGLBsKLuTpow?=
 =?us-ascii?Q?oIjENyY4H8vtUXCx9l1TegqWeXCTdk5dn+IaTMkXMbOcNmw6PjvkT+5avbxG?=
 =?us-ascii?Q?CjugAHdg2fyRc7dvUygfH92Y8UXwUWgUOGdTAVXPz21kIItkWS07J3pOSGoJ?=
 =?us-ascii?Q?MfT+C3NY/kEpvgelmcv/10D5oDdGKI9J/AJVwChNXy+9YlUFnmuvAajDwFie?=
 =?us-ascii?Q?3u4LUEPYItUK4FukvN8HfTNIFAq7oz03PrSaiWvFBX3bJCS7oOwgaL/fmIkR?=
 =?us-ascii?Q?N63BDP2twgssAO7YLHMyPAJD8ruBK9BQ/JSWRJ540SWyZyCR5/+wmb7UtTIw?=
 =?us-ascii?Q?kATB3srzV6uJZxyVb1rkHrYQ26CYvc2PwoSFZIOsRs3yv0t/h+yWLBrgiKZv?=
 =?us-ascii?Q?i3VABBXJz4fB3sFdddXDhwuKtPggB2LQ464lZY+pBdjNXdvN0wGzJ8t3/WFJ?=
 =?us-ascii?Q?N7BkV5uySOD9HM4aM4WSaD55d950PC3K7qttQkvk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bf36191-fddb-4f1e-5f03-08dbf5c67591
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2023 19:14:52.9408
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ggXFbnbY42SgkXE6zr0tiTL4EqXqahh/yevDucw4/z3w4QXMX2WDHlSvZnbnlzEO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6588

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
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 26 ++++++++-------------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  1 -
 2 files changed, 10 insertions(+), 17 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index e1de2799310961..525048a79e8a90 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2480,19 +2480,20 @@ static void arm_smmu_disable_pasid(struct arm_smmu_master *master)
 
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
 
@@ -2546,8 +2547,6 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 
 	arm_smmu_detach_dev(master);
 
-	master->domain = smmu_domain;
-
 	/*
 	 * The SMMU does not support enabling ATS with bypass. When the STE is
 	 * in bypass (STE.Config[2:0] == 0b100), ATS Translation Requests and
@@ -2566,10 +2565,8 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
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
@@ -2577,17 +2574,13 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
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
@@ -2613,7 +2606,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 
 out_list_del:
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
-	list_del(&master->domain_head);
+	list_del_init(&master->domain_head);
 	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
 
 out_unlock:
@@ -2817,6 +2810,7 @@ static struct iommu_device *arm_smmu_probe_device(struct device *dev)
 	master->dev = dev;
 	master->smmu = smmu;
 	INIT_LIST_HEAD(&master->bonds);
+	INIT_LIST_HEAD(&master->domain_head);
 	dev_iommu_priv_set(dev, master);
 
 	ret = arm_smmu_insert_master(smmu, master);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 1be0c1151c50c3..21f2f73501019a 100644
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

