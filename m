Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2089.outbound.protection.outlook.com [40.107.237.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3038020B12;
	Fri, 26 Jan 2024 18:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706292948; cv=fail; b=Xvnrc3HLAf0IIpJ/hsPBPh3gJJMRFBqaXR8OrHLWjoKe3JQ4GCijxN1VWdVqHzygw6EnTkkjj/Ekqg5zRanOCyrvAez9MdpCXc+3/ydSDVycr49bKMLyRV+t+kUkTCd77pKXeSBhny6YxAIKlz6NKcfhPoKe8vw92vTr9/PkPbs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706292948; c=relaxed/simple;
	bh=tNuHXCpRUWWLYX0nmLp/saQPXNZXt64Z60M5mgL/L1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jHxAnCVzkHjlB+KszbpqWkBVlTZA+Kd1AOrfvcP7QlGy943Giiqv8T2Ye+z1KhmgMC/3jvAZ+cPAs5wwpzcXeVv2oZRkSmhhmUQLP8hR4TRF7x6tTsMBKfl9+e5fbmZ8CtzWIKqSOERJpqXiHd1Dc7krVdO1Dg3/OkkPRYm2xqw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=XmSHzDMy; arc=fail smtp.client-ip=40.107.237.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="XmSHzDMy"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UEM59A2WL3Zi8tFrpkYYA8ZJumrPbbu0TvjF/baHazt2UUYC2aYtfVbXeE8wIxH02kf3cTVa/V9s5Y0yEdStR0gSjjbUMFwfLIdqE8W4JUAvNtcei5AQDcGIoRdkgM/uE6gFn4h0e1J6w+3bcPg8ledzXidzMNrsB75L1U+7tmShH4gv+XwEmEG1pNGwmNLQ4XqB5aLv8lKwH/Wu5Ya4ODYcPybiujjz8qqa/B9mxCkACOlqoiJHqUIbuiD9FsEKnHL1Lz3QZHpdqjHp+ZqlzbuGrUTZaWSPCuHRqFTyvSCx+Ihn9PHADeY6BgAQjr7S6ak76xrIE3+SFP2M1sDdIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZG8Z7xsZtWncmKTxyKkhc0a9fod1+LGP7jbslFJirno=;
 b=O24xPZwHul8N4I5i2y+hOAANs5AdwMCaXGXZVM1XpBj5qaJb2GYdvKKT0HrVpKN004Ue5Mq86wcvLm2C26WPRL5VUADqjxdm5yR9iBxmvV2JKadfY4p0SeTL36RTsdZ/5e3RmjmzijSBPME7Obcb5LL+9TgIUhRmHmoZ/e3c0BVh5gxC3LbXKeGz44tDVYRzxq+AMRIKdAqBKiXtReOtBHHId5asl2ZTbBP8Yy0QTZ3QX8YrDdQXvWFHaW9Ge3XmpSmy7Lod7HBDFWtVZ0o5hlfCA2gcIXP748bEJO0E/Lb4rHrhUEuE8ThUexPEAdbFUbZ/bYsjJNn2FeVE1e80zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZG8Z7xsZtWncmKTxyKkhc0a9fod1+LGP7jbslFJirno=;
 b=XmSHzDMyy6lNg7AEs+4EcK2ARnFqV4MQz1yw78OGJtxLDZS6DYTgfo0Bzd+ghIU4WKpVBwcmzT7QreWsUwDltUXb4laThEFPyY7EPUZIP4S2IXPiB6ar9RNT5NIQSPszgE5kMNUozRaS9EGkExu+BXEuBb06Pv7qgc+VwmXIAPgDUk182JRRIYGAJjVgckLsGqClKAz26hhsR/75WTeVcyzN2W+qUswR2uG8Op5geRyvE8VOYwmekoU5ZgQJE5G4fH8xt9KVHiem1aTV6GWByL3XCyvl6+of8qQiv/73UjkmanAF11erOJe5tESeaVfY9uQ8zOLQT3FUa6ogRq8bvQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH0PR12MB5186.namprd12.prod.outlook.com (2603:10b6:610:b9::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.28; Fri, 26 Jan
 2024 18:15:41 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7228.022; Fri, 26 Jan 2024
 18:15:41 +0000
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
Subject: [PATCH v4 13/27] iommu/arm-smmu-v3: Make smmu_domain->devices into an allocated list
Date: Fri, 26 Jan 2024 14:15:15 -0400
Message-ID: <13-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN7PR18CA0029.namprd18.prod.outlook.com
 (2603:10b6:806:f3::28) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH0PR12MB5186:EE_
X-MS-Office365-Filtering-Correlation-Id: b3f3c3e5-66c3-4557-6c5d-08dc1e9ac945
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	v+jsNjIQT6Aet2D/OorKR/m3IYYv7vpM4D+WDQ/cISHWr2OtsTK/dkbPF4jM4cKfIm7bPLMSvaCiE3mWrxyC/+1sRICL/oCKWPBzeVUaCFpN9HMUPT6V5kMzqi0vebzxFvEKOy9ZqvqTngqUdNG8IsOBuL/poDhKUIPuekttbG9SLu5QrPn4EZhbHuzAlKBcFlsLFOZXPM73OScKvsQ2up6J+qhKHx3RFFOxUjzX1FRKucxBK1yjDqBm28ZS9MQPKGMD8qlMcfhwnupcBr2zuW3IdGKeq/OHUzsrdVanIihyI1E6RLR33msmsWzPFHzk8sobSfrCc87HquuloO3Q9AnT7+ECcVEaNc86wYd7JEuIpES4PZGE4xArxouK6aPhB7pa6mA/Xp5r/WT+kbQlwjabgyd1SNPQItaxdasywDCl7VMMHlsW+GNdnZDuSAjKSXfZFe3yoL0aCk7NG4/IkMIE/6zPpCGWl1LA82TRuVxIshakraTN/6u/eFtLE6FPzPg6pobfg+eXuQr/w+x4sN/5omElLz7bgk1CLemkRYncykuBkT0enbmcpGdsWW4b
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(346002)(366004)(396003)(376002)(230922051799003)(186009)(64100799003)(451199024)(1800799012)(83380400001)(36756003)(86362001)(8936002)(8676002)(4326008)(5660300002)(26005)(2616005)(38100700002)(316002)(66946007)(54906003)(110136005)(66556008)(2906002)(7416002)(41300700001)(6506007)(66476007)(6512007)(6486002)(6666004)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xTdnKPKxKZ4gGlVj8V+KZll9VmEKVGpx03b+rE4x2jv3payxtFFtKY9rA9G/?=
 =?us-ascii?Q?97VYCxsSgxwRsmaIuTcZbew8fbDzrMYOWAeKs8BK5Kgg0vGezpOrdb4yDNyU?=
 =?us-ascii?Q?71hFfBpLdBnTq69KahlkrPb+L6F32NXE0/Pz92aXpGQ0bhnDqfu2bszqAizZ?=
 =?us-ascii?Q?q7cKE2+EFukFgjp6JpdBUBXLZbjlGV0CnT4uoPdk3CBTyPvXsv5IYhHSAEIx?=
 =?us-ascii?Q?E7b5birmmzVTmyD1Oq1LnxDlGDutO7WwOLOj30gBkYgEgVWmgi6YC9KHX2yW?=
 =?us-ascii?Q?VUhZ1cbfHL3lb5Pk6TbkI/DfuBNF6t1ty/LMngZ/56SrLlFOGMD+jnzm8qi+?=
 =?us-ascii?Q?UC40XhnacHPJflPZh10o7wMOFTjIaL8oZj7xWxgPvcJj6uTx9IiDJTThl5vd?=
 =?us-ascii?Q?q8/fISV1JzdBIeBoeJ2CYI5of7tCSCp3+hJmcZFq4r2qFoBv+DTMi1myDiDe?=
 =?us-ascii?Q?S+aNd+p+oYXN+3E7VU41XBKa8c50AgOgfSk0M+kPkdg7IkvxLDQK4B/UzKdV?=
 =?us-ascii?Q?5bGrcPqa88EfIwHO3u1htRsbuSVWkegahAK6Z1skLr0RUnBwUbHDEPY282JG?=
 =?us-ascii?Q?8BnFSDR7YN9zXDIc7lcTYk6VamfP6tf2M6hfrloNgRMVMP2qdO8jO9ZgREm5?=
 =?us-ascii?Q?rrUZreDFbJIuOTwW480akNLBQTiikIpxMCWRawI93cZA7OL254vVj7nMEfqr?=
 =?us-ascii?Q?P0Tul8M5u33APj5fxEEtkP+YGRvIxUfhiu5u6oJxCL6oVUauAqTx115EU+0C?=
 =?us-ascii?Q?qfKOT/yGUoChVWKEpkUDcokxT0aU1TTtD4Pg0/qmjqmSNPE0UoSFJVCl7U1d?=
 =?us-ascii?Q?bXes8HDFWLgl058J+T9CQixGGUAy5Q86K4MgOu2+LiPh81ix1BKcc3Qu17bu?=
 =?us-ascii?Q?9OL51cyVtMgYoD6HU3dpQQCwtrisU7FfWbIVaKfJNZnemM/Eqs0mesa7ApHa?=
 =?us-ascii?Q?EhaJz5s8WQurq+KNpua/v4tSv0Yvj4UeILd/FGpriebViDvIvyYpet1Smw0a?=
 =?us-ascii?Q?WO1PJmEupUV9DQUbQD5y7a99+OMR6NDlOc9ysWtOImJah/qyh5HzHgip5GCI?=
 =?us-ascii?Q?2I8y6hfWaPp0N0liTVfR3T5IbXmHjlOeSgrO+QGLX0CO5tadekHmbw4s4DhE?=
 =?us-ascii?Q?3TjzG99LlJmv4JxzTcS6/b8qn2weIEYLSPbdrCdIqai15WbVjaTMV1RmWney?=
 =?us-ascii?Q?UVt0yiGmh4WgEb6C4C1/+0lszAtvmze2qX2gIxIMgGrqAw9Wpa5Gp+/6eKuk?=
 =?us-ascii?Q?r1MI9lx4176GGlXzR1epMILj+5cNUsGCDafkNsBYDk1lg8NnpmaU1qu7qaQG?=
 =?us-ascii?Q?c3PJ43ldppjMeRBkgMTbFjfF72aMGDCX5Y2MCEomxR2BUUpEF8KCxfREvsNp?=
 =?us-ascii?Q?Sl/eu1vZkcJvwSzhzdRB2cmpkILU2OUx/UtdIK0HvsxPmibGQpQz11iiw/gW?=
 =?us-ascii?Q?J0qZfCKhJsAAMv0UeRC+byLzKD2WnuYnBZRSx/weOHzcXJs+UpEIWbSPw8vm?=
 =?us-ascii?Q?sUuQJO+jkEB/kyFfM1OH8BkxEtN6An1TD2DVPymmDL5gGK+w0tKTliFqLhSU?=
 =?us-ascii?Q?pxigMkIHjtkepWsY0G/vdyjgdd+WbnNgYJJJaX8c?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3f3c3e5-66c3-4557-6c5d-08dc1e9ac945
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 18:15:33.2273
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F7YaMH6IlDro0rC72kAbTOr7FO7QhzbRZbBE6JyA62aoNp6uPDASZaN2W7tZUA5e
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5186

The next patch will need to store the same master twice (with different
SSIDs), so allocate memory for each list element.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 11 ++++--
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 39 ++++++++++++++++---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  7 +++-
 3 files changed, 47 insertions(+), 10 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 973a5219c519cd..5c50254be4a373 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -38,12 +38,13 @@ static DEFINE_MUTEX(sva_lock);
 static void
 arm_smmu_update_s1_domain_cd_entry(struct arm_smmu_domain *smmu_domain)
 {
-	struct arm_smmu_master *master;
+	struct arm_smmu_master_domain *master_domain;
 	struct arm_smmu_cd target_cd;
 	unsigned long flags;
 
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
-	list_for_each_entry(master, &smmu_domain->devices, domain_head) {
+	list_for_each_entry(master_domain, &smmu_domain->devices, devices_elm) {
+		struct arm_smmu_master *master = master_domain->master;
 		struct arm_smmu_cd *cdptr;
 
 		/* S1 domains only support RID attachment right now */
@@ -300,7 +301,7 @@ static void arm_smmu_mm_release(struct mmu_notifier *mn, struct mm_struct *mm)
 {
 	struct arm_smmu_mmu_notifier *smmu_mn = mn_to_smmu(mn);
 	struct arm_smmu_domain *smmu_domain = smmu_mn->domain;
-	struct arm_smmu_master *master;
+	struct arm_smmu_master_domain *master_domain;
 	unsigned long flags;
 
 	mutex_lock(&sva_lock);
@@ -314,7 +315,9 @@ static void arm_smmu_mm_release(struct mmu_notifier *mn, struct mm_struct *mm)
 	 * but disable translation.
 	 */
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
-	list_for_each_entry(master, &smmu_domain->devices, domain_head) {
+	list_for_each_entry(master_domain, &smmu_domain->devices,
+			    devices_elm) {
+		struct arm_smmu_master *master = master_domain->master;
 		struct arm_smmu_cd target;
 		struct arm_smmu_cd *cdptr;
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 7e338664d7fea1..fcacf30a4698d7 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2020,10 +2020,10 @@ static int arm_smmu_atc_inv_master(struct arm_smmu_master *master)
 int arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain, int ssid,
 			    unsigned long iova, size_t size)
 {
+	struct arm_smmu_master_domain *master_domain;
 	int i;
 	unsigned long flags;
 	struct arm_smmu_cmdq_ent cmd;
-	struct arm_smmu_master *master;
 	struct arm_smmu_cmdq_batch cmds;
 
 	if (!(smmu_domain->smmu->features & ARM_SMMU_FEAT_ATS))
@@ -2051,7 +2051,10 @@ int arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain, int ssid,
 	cmds.num = 0;
 
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
-	list_for_each_entry(master, &smmu_domain->devices, domain_head) {
+	list_for_each_entry(master_domain, &smmu_domain->devices,
+			    devices_elm) {
+		struct arm_smmu_master *master = master_domain->master;
+
 		if (!master->ats_enabled)
 			continue;
 
@@ -2543,9 +2546,26 @@ static void arm_smmu_disable_pasid(struct arm_smmu_master *master)
 	pci_disable_pasid(pdev);
 }
 
+static struct arm_smmu_master_domain *
+arm_smmu_find_master_domain(struct arm_smmu_domain *smmu_domain,
+			    struct arm_smmu_master *master)
+{
+	struct arm_smmu_master_domain *master_domain;
+
+	lockdep_assert_held(&smmu_domain->devices_lock);
+
+	list_for_each_entry(master_domain, &smmu_domain->devices,
+			    devices_elm) {
+		if (master_domain->master == master)
+			return master_domain;
+	}
+	return NULL;
+}
+
 static void arm_smmu_detach_dev(struct arm_smmu_master *master)
 {
 	struct iommu_domain *domain = iommu_get_domain_for_dev(master->dev);
+	struct arm_smmu_master_domain *master_domain;
 	struct arm_smmu_domain *smmu_domain;
 	unsigned long flags;
 
@@ -2556,7 +2576,11 @@ static void arm_smmu_detach_dev(struct arm_smmu_master *master)
 	arm_smmu_disable_ats(master, smmu_domain);
 
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
-	list_del_init(&master->domain_head);
+	master_domain = arm_smmu_find_master_domain(smmu_domain, master);
+	if (master_domain) {
+		list_del(&master_domain->devices_elm);
+		kfree(master_domain);
+	}
 	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
 
 	master->ats_enabled = false;
@@ -2570,6 +2594,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	struct iommu_fwspec *fwspec = dev_iommu_fwspec_get(dev);
 	struct arm_smmu_device *smmu;
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
+	struct arm_smmu_master_domain *master_domain;
 	struct arm_smmu_master *master;
 	struct arm_smmu_cd *cdptr;
 
@@ -2606,6 +2631,11 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 			return -ENOMEM;
 	}
 
+	master_domain = kzalloc(sizeof(*master_domain), GFP_KERNEL);
+	if (!master_domain)
+		return -ENOMEM;
+	master_domain->master = master;
+
 	/*
 	 * Prevent arm_smmu_share_asid() from trying to change the ASID
 	 * of either the old or new domain while we are working on it.
@@ -2619,7 +2649,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	master->ats_enabled = arm_smmu_ats_supported(master);
 
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
-	list_add(&master->domain_head, &smmu_domain->devices);
+	list_add(&master_domain->devices_elm, &smmu_domain->devices);
 	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
 
 	switch (smmu_domain->stage) {
@@ -2938,7 +2968,6 @@ static struct iommu_device *arm_smmu_probe_device(struct device *dev)
 	master->dev = dev;
 	master->smmu = smmu;
 	INIT_LIST_HEAD(&master->bonds);
-	INIT_LIST_HEAD(&master->domain_head);
 	dev_iommu_priv_set(dev, master);
 
 	ret = arm_smmu_insert_master(smmu, master);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index a3ea078bba92ff..742f05df5e8b86 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -695,7 +695,6 @@ struct arm_smmu_stream {
 struct arm_smmu_master {
 	struct arm_smmu_device		*smmu;
 	struct device			*dev;
-	struct list_head		domain_head;
 	struct arm_smmu_stream		*streams;
 	/* Locked by the iommu core using the group mutex */
 	struct arm_smmu_ctx_desc_cfg	cd_table;
@@ -729,12 +728,18 @@ struct arm_smmu_domain {
 
 	struct iommu_domain		domain;
 
+	/* List of struct arm_smmu_master_domain */
 	struct list_head		devices;
 	spinlock_t			devices_lock;
 
 	struct list_head		mmu_notifiers;
 };
 
+struct arm_smmu_master_domain {
+	struct list_head devices_elm;
+	struct arm_smmu_master *master;
+};
+
 static inline struct arm_smmu_domain *to_smmu_domain(struct iommu_domain *dom)
 {
 	return container_of(dom, struct arm_smmu_domain, domain);
-- 
2.43.0

