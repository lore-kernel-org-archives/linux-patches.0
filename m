Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2073.outbound.protection.outlook.com [40.107.243.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 961A720B11;
	Fri, 26 Jan 2024 18:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706292946; cv=fail; b=jMXEhTtGjE2LCIzf7CO+VlV48GnYsLE7d5hiMYZKCvOeEOpkSZQQrDxAbmixPkVvUfV0I0F37bg/B3+3OACo7j7SaWMIaLk+AF9VBPGr/uDnjCy82cde2abAXt/xrm+BipXDZizgSbMhHjTbyI1PxgzVdvRpwX+nMmk5o7qX+Xs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706292946; c=relaxed/simple;
	bh=ufgudzbkrvCSWiqDXLt90K6orWgNSJ5AXQKwUucyCh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dXxS17BoGso9XT+ZSBaIIFAcR9QpOY3ZRMibOVivkhRGI1yoTxisb8A3CRFJxhRSFX3BAlF3H2N2/g38vpu0ESjK8cqDpVnPJm8RCN73t0CWVwcFFqNc93KjJ1siRCWGv910AwfyCtXB4Z5Isa5zuNKwO8MZFNiQIO0tQpkaxeA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=QEpwZ/CE; arc=fail smtp.client-ip=40.107.243.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="QEpwZ/CE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T9n3mBRWxtn+QMD2GVALBJxusn85IgeH7Re8cRB4rK1/iKqF7ZUZE8rQZnprMYgT+AGKUL7jKKKXGHGc14cuPCglC0b5oYeH0BEcgR0nBCB1folTdEL5+hvPN0UvkiD1IjrNoqHnqVnoESG44eaPppHkLpxcjt7a/r9pJH+A1ZNvW4+ma6eGIjpLsOH87+Zlzfd1RBZ5Y8pfw9prFKrkfzVmm7F0k0W7RpYpmQ+OgkHBHhVyt6G/IK66ZxrA1KBjMC7SX0Cky8jCHl9HYgZJvObcjEmM/amgg58OEVfbyxGoF2Y1D4ByMAKSKU0xlV/UkPn0mXdZ7e47/f/R/RLdEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=roQg2tDJboKURfA9TrqNkPNL7aeVUAVLO8hVw983YzU=;
 b=VplN/6FDrKdnkZupiYs22O9nKEkeX7sIyIGsrHaKcq+pxeNjSI/IqFqrAyBaxnlWs3uL/Z5AXLKB4F73kiTceUrzzBNMcUDH/0E92aEzbTf25H9BmAK+6Hd2ZxRSkKgr2tJVtP/ia5aFg7n9p03Kxar+NAOdI4Y83tQypwB0twDGia1OKTdITs9mhrlSOs4WXwfunH15xjitd5gQsX496d1qZDcs+j1Cpau0QyvsdwyqiGNzxZRfqIgztvwjnriWPN8z7EDmgdGJrIpU5piVssDnWM/optmAsNTiGHsa9vjNwU276EK43922jVcVKG11s419zngN4j4lHsl4BLKbMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=roQg2tDJboKURfA9TrqNkPNL7aeVUAVLO8hVw983YzU=;
 b=QEpwZ/CEhqYNzRakMH22cUW+parab5zXSVckyQESDDiJ5neMt1qeW2O1oAOuKACGBdT4FBGkWEI4mmJeKaEgMS6sk3QOsfXRdVOVOTaKiCjOMFG66//EdsODYweDJ3fjjSuTG+SqcZ8ud832ql+FXnYgi/XayZfEP5tzdDwKDdnFmiYiNwItaISGg0asa3F2ZAdFi/J/X0VnollhoZK3vsQFJJeaSIRxkKI/mdcuht01gjX3ce5gF9PqyrOAIUXKL5B6Bhq+ziO1LjD9rFroRMW+NunJThg1U01u7EwMS+aCc0ZsxRLyNwLAFFe2zYAtPkEnC6Vptn3jLie0hyJPzg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB8079.namprd12.prod.outlook.com (2603:10b6:208:3fb::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.22; Fri, 26 Jan
 2024 18:15:34 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7228.022; Fri, 26 Jan 2024
 18:15:33 +0000
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
Subject: [PATCH v4 18/27] iommu/arm-smmu-v3: Make SVA allocate a normal arm_smmu_domain
Date: Fri, 26 Jan 2024 14:15:20 -0400
Message-ID: <18-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN6PR16CA0070.namprd16.prod.outlook.com
 (2603:10b6:805:ca::47) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB8079:EE_
X-MS-Office365-Filtering-Correlation-Id: c4d97cda-2e6e-4947-ce02-08dc1e9ac858
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	zH+cpbs5IjbPCWtnEbJ2g0mDZCj197s4JJu0duRq/cMuW5AniU8G/0nCYuMWACE+A2HRaelWfh3TuXzos3FA/AiH4xMKWSVaKqke5YpDAnDYaUXaVtZKLZwwZoNQTfFKxUUahuqMUplbyBVJekvRi3uSLtpXnNrBGA/XXlDUDA1y/kMtFizq/4fsa2xRMk3pqblzrL04W6CSv1ddFzRd62gBlH+iCElRU0z5nsCELxPiy6fJHZ85IghxCLSOw3YQgtzrrSqKNfhL8OXPRNoJDdIDVmj4qFhexxAXz3OlyzbTl/M3ZcrKbfgLdgpxqsgLt2zNvnxPTjEJGJ+pepBTQ7aZ0BYcjRcj4+eQk46hZ95jsPsZ19if7atlS+gYthZ4fqyC8e6zfm3AF2XS424D9UN6xw2ffKTVAygqhu6T7ytgj1rKVFggoM+iIXGiShHlS2KgLl4YFF73x4VnohPY/YuLU/5zsX4hcLrTwG+7sqHjry4ZxTM4AMWS0D/xhOH1BVrRj89SMXqR+WctQGpbqMIH12CNoCRCOoX4Zk7B8wyiOYVmuXoEmWW/tnIhr5t3
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(136003)(39860400002)(376002)(396003)(366004)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(83380400001)(6486002)(6512007)(38100700002)(54906003)(2616005)(5660300002)(8936002)(478600001)(2906002)(8676002)(4326008)(7416002)(110136005)(6666004)(6506007)(316002)(66476007)(66556008)(66946007)(36756003)(26005)(86362001)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qGfCGRWjmzg3wF64MtY+QaS2HBNuyMabLS6VqVCFxiQn8WazYEYC74YmoP9K?=
 =?us-ascii?Q?rTTRD792x3MaC+Si02YSk7+WXiSOD+FdO7XyNb+/G4s7UApGChjwxuNajwjT?=
 =?us-ascii?Q?QAfiCJxxbXjYeRNK9VLMkmmkXWtuwmGdKIBDc6yvgSmNtR/jT1Ufx0fvTXjD?=
 =?us-ascii?Q?d9ZGQGce1qDKiPC2g/0a74aSeHs3bEs47r+TNy9rokQyuUV5rQ6xVY/t60Oc?=
 =?us-ascii?Q?N/2tmxYZgPiP8b4km0TbxO1t1hWODPS1r8o0MnP3/tlxFAYFA5/QQx+1m+zL?=
 =?us-ascii?Q?b6+d6YfiomTxxSBwFFiJ0IEq+TdEFfMZrC0o33xjxyjMO1aytwiElfpKQOw+?=
 =?us-ascii?Q?D2/rdzfn2I0J03oD9CKAW/YaPi7AqGwAaXC4EtKojBVVGZgApumq6yJHt4yC?=
 =?us-ascii?Q?R4U+X7LkdN9yaYUwxOHVOVEMJpd/OK0DhN5znF8J+NWuJRzuS2lHpdbzgIeY?=
 =?us-ascii?Q?ekEtZcOWj3RWS5hbIAGYqDW9n6yK6+/R47svJezSeTgdzK7AhsVIpLV1rJ5G?=
 =?us-ascii?Q?LOWzBqm0ibgqxYsSqIosXWPrMG9L0XEAfuOsuqHE2OhGhxofEMRYpRrMBaY3?=
 =?us-ascii?Q?ZGZs3NbstaKEK+8RNytQ0Mn1xgCO+h7OBWSA8lrCUJSsdwXU4IYwv2Hid4vL?=
 =?us-ascii?Q?qzJxe5+Ry6jANqBJwQYYU4hte/ZOl7v8GSV4NX5Usf2DN6+vuO/hpmE8aic3?=
 =?us-ascii?Q?yRRiV+kdIPxHXdFKQcjnCbGoRt+/J6EXdY326lEVhPYsyz85C1uH6rdNpcC5?=
 =?us-ascii?Q?gIV2zHUOZ39XNN8Q5fSMSPTZ40d8yPgqqRSgiB3B3O2TAx3x1RVn85C7r+0E?=
 =?us-ascii?Q?WbAr2ZXfV6mrez8Gzotfluu3LPUuNYGTGbpDYUj3tB46Mtb6WfbDXdF9eQKQ?=
 =?us-ascii?Q?R2l7Pz/HCbhSpNRRYJiEnZG9TvDUhmxgQWb28HtkLNk2WXoak3s6zn//bQFd?=
 =?us-ascii?Q?Y/MOy4cUMQ0ilNNwyVyKk0Ln9lnCsW3zkOkCu5JOddSgRDASXAduJ0kOkKEZ?=
 =?us-ascii?Q?8JRcS8/e7MQqxpk08Vftr8C9OrBh51rd+cY3/FyAsZsTbmAr0UXowG64inaY?=
 =?us-ascii?Q?cCPOvkSCMPaw/NwPJceMDJt/vZWiEI/7o8lwlo69hA3e/TQIw2GirQxXyCDk?=
 =?us-ascii?Q?fIhPmGPPNmtsWAtDvJFnVkrNO5tTyxL6ieSVJOujJ32A/0m5QmA1GaOmIPYu?=
 =?us-ascii?Q?39d5r8+SqaHPFrqpV43Hs8wcICq3RG652GPVUx2UTD92LK7YLXhShAUCyR9V?=
 =?us-ascii?Q?seH4xhhJajnEICieUpIfUagj0aw7ARJgLT0P8tIvv9OXrcRkpqy33I6mwxGW?=
 =?us-ascii?Q?ifVa0mg+Ic7Qm1/w9De0Ps9SReCIToND8HevqRyWjK+QEBZB7VIJqN6Bysxm?=
 =?us-ascii?Q?9aHrD3Jw8+pwojY6NAVeQlWvfWs7deYb48Pzx6fNCg3J5l5CK/r/7NMeGrj+?=
 =?us-ascii?Q?dtVZaVVD3JCnHm9kBOrvANbP626qUzXer8qFIPD3wFdREJXtmOOSCezuja9H?=
 =?us-ascii?Q?ZEdgEDTfxAkQojkNhSmPaoSDJqqDTPnayxwhmwm2M5QJV6eX3X8oOfIaKB5p?=
 =?us-ascii?Q?xHatPD3V5k3h7F0a7g9Uvz9PIXUICzh1Emfn4G9H?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4d97cda-2e6e-4947-ce02-08dc1e9ac858
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 18:15:31.5814
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qmYPq2tmaeguVovHl5fd5kqm0daEDWqn5iMFnN8/gGHv31YRvnmNE9JOkt8sLMEQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8079

Currently the SVA domain is a naked struct iommu_domain, allocate a struct
arm_smmu_domain instead.

This is necessary to be able to use the struct arm_master_domain
mechanism.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 17 ++++++----
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 34 +++++++++++--------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  4 ++-
 3 files changed, 32 insertions(+), 23 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 6d54a6105ceadd..1163c7d70359f4 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -662,14 +662,17 @@ static const struct iommu_domain_ops arm_smmu_sva_domain_ops = {
 	.free			= arm_smmu_sva_domain_free
 };
 
-struct iommu_domain *arm_smmu_sva_domain_alloc(void)
+struct iommu_domain *arm_smmu_sva_domain_alloc(unsigned type)
 {
-	struct iommu_domain *domain;
+	struct arm_smmu_domain *smmu_domain;
 
-	domain = kzalloc(sizeof(*domain), GFP_KERNEL);
-	if (!domain)
-		return NULL;
-	domain->ops = &arm_smmu_sva_domain_ops;
+	if (type != IOMMU_DOMAIN_SVA)
+		return ERR_PTR(-EOPNOTSUPP);
 
-	return domain;
+	smmu_domain = arm_smmu_domain_alloc();
+	if (IS_ERR(smmu_domain))
+		return ERR_CAST(smmu_domain);
+	smmu_domain->domain.ops = &arm_smmu_sva_domain_ops;
+
+	return &smmu_domain->domain;
 }
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 21b0ab9c2ba763..a8e9276990b006 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2280,23 +2280,10 @@ static bool arm_smmu_capable(struct device *dev, enum iommu_cap cap)
 	}
 }
 
-static struct iommu_domain *arm_smmu_domain_alloc(unsigned type)
-{
-
-	if (type == IOMMU_DOMAIN_SVA)
-		return arm_smmu_sva_domain_alloc();
-	return ERR_PTR(-EOPNOTSUPP);
-}
-
-static struct iommu_domain *arm_smmu_domain_alloc_paging(struct device *dev)
+struct arm_smmu_domain *arm_smmu_domain_alloc(void)
 {
 	struct arm_smmu_domain *smmu_domain;
 
-	/*
-	 * Allocate the domain and initialise some of its data structures.
-	 * We can't really do anything meaningful until we've added a
-	 * master.
-	 */
 	smmu_domain = kzalloc(sizeof(*smmu_domain), GFP_KERNEL);
 	if (!smmu_domain)
 		return ERR_PTR(-ENOMEM);
@@ -2306,6 +2293,23 @@ static struct iommu_domain *arm_smmu_domain_alloc_paging(struct device *dev)
 	spin_lock_init(&smmu_domain->devices_lock);
 	INIT_LIST_HEAD(&smmu_domain->mmu_notifiers);
 
+	return smmu_domain;
+}
+
+static struct iommu_domain *arm_smmu_domain_alloc_paging(struct device *dev)
+{
+	struct arm_smmu_domain *smmu_domain;
+
+	smmu_domain = arm_smmu_domain_alloc();
+	if (IS_ERR(smmu_domain))
+		return ERR_CAST(smmu_domain);
+
+	/*
+	 * Allocate the domain and initialise some of its data structures.
+	 * We can't really do anything meaningful until we've added a
+	 * master.
+	 */
+
 	if (dev) {
 		struct arm_smmu_master *master = dev_iommu_priv_get(dev);
 		int ret;
@@ -3278,7 +3282,7 @@ static struct iommu_ops arm_smmu_ops = {
 	.identity_domain	= &arm_smmu_identity_domain,
 	.blocked_domain		= &arm_smmu_blocked_domain,
 	.capable		= arm_smmu_capable,
-	.domain_alloc		= arm_smmu_domain_alloc,
+	.domain_alloc		= arm_smmu_sva_domain_alloc,
 	.domain_alloc_paging    = arm_smmu_domain_alloc_paging,
 	.probe_device		= arm_smmu_probe_device,
 	.release_device		= arm_smmu_release_device,
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 69351386dc1441..cb08b9305e0208 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -759,6 +759,8 @@ static inline struct arm_smmu_domain *to_smmu_domain(struct iommu_domain *dom)
 extern struct xarray arm_smmu_asid_xa;
 extern struct mutex arm_smmu_asid_lock;
 
+struct arm_smmu_domain *arm_smmu_domain_alloc(void);
+
 void arm_smmu_clear_cd(struct arm_smmu_master *master, int ssid);
 struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
 					u32 ssid);
@@ -791,7 +793,7 @@ int arm_smmu_master_enable_sva(struct arm_smmu_master *master);
 int arm_smmu_master_disable_sva(struct arm_smmu_master *master);
 bool arm_smmu_master_iopf_supported(struct arm_smmu_master *master);
 void arm_smmu_sva_notifier_synchronize(void);
-struct iommu_domain *arm_smmu_sva_domain_alloc(void);
+struct iommu_domain *arm_smmu_sva_domain_alloc(unsigned int type);
 void arm_smmu_sva_remove_dev_pasid(struct iommu_domain *domain,
 				   struct device *dev, ioasid_t id);
 #else /* CONFIG_ARM_SMMU_V3_SVA */
-- 
2.43.0

