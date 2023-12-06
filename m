Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2044.outbound.protection.outlook.com [40.107.244.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA49869289;
	Wed,  6 Dec 2023 17:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="RoBiKD0B"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LqesJlyxNnkVz1HWlSHSLAc6ghx1WmpfXP8FYotwu5cPZ1EraEAKv42tDbZ3zp9pe9gQPd2aTU0CxBZ+8PYLawP7iuXIiqTwn30uZk8z/lx+AenJ9Qp2fqesak/8G2zNnv3bjQYykyIKWriM0SQuMPPt7GJ+o9B/K4ks5fVpfkXepa2YiYFMg+bJnY0pySzHuxPIF0mn03t/LEkEe9hlG2/iaupF+CoMBX8yBf87c2FpIoeDo04o+boBAXeGYejl4bFRZsQTiK2pvQ0W13Y0W1G1ygrWpWFXtZGPPrLyB9sh2cw5vQHb9XKWsDNPe37fl5PCT19xCgMUx19cePVPRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UGD+ydkWK/CdvwN0X7mLTOXVK5t1R7pl0Hu7fIddLjk=;
 b=Ire812VwnO9BtaUNJ0fYwrnLia0S3S9tuFoM0Rie3xh6MXLfO3Y8+Bf8hnksuDdwmfCDcKFEyH16M7EWp03qREPKp4pkRWIQ2eBodqBSS9OT1DUauiFQgT+HcCYMX4VyTSaBrvOvAkqJCS1EvJUyTr927W6mEfGR5/xqE5HNMyzLaparh8f/694XfoJQzRsajW3nw/Bf7L/qzLmMP7BW6OKUqmgaM0KghQsvX1gBIUCo81+5ZnfGgB4oWZWEY38JN7xh3vf56MUBofvmI5maUCJw5Z2eLczyH30mc4/EaL9H2IhODjziglbWUvORoQIMsQbIBG2ewduQNv9bv4op7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UGD+ydkWK/CdvwN0X7mLTOXVK5t1R7pl0Hu7fIddLjk=;
 b=RoBiKD0BNxBQNUn53mMRXx47U8EE69Pnyk1WOsDD6GV3CJLKQVB75pOs/RXog09l7MekvNm6R478VVq40VsuXzgUG+OY1AIEOPqfdtiIDZbdOE7pM3p+NsMYtCRuz6iMRCQDRlMEURjgPasNmadCNcZy/GDBTFOSowfckZST7I/8eA/158XWv40CSOzbYK75buOXCwZmajN6omt4nKF2rkNom1ZZB+8DM97DrYWR2QRYhzgi4ecrk0F9bhibxhQRsea3SWsgxiHCKqqhnIiRPA2AiAJuke5195rA3iRCboKSZRokuKx72wWbxj1X8xZXnpHYdYL0E/k5ZuPrSpiKHQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB8360.namprd12.prod.outlook.com (2603:10b6:208:3d8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Wed, 6 Dec
 2023 17:28:41 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.034; Wed, 6 Dec 2023
 17:28:41 +0000
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
Subject: [PATCH v3 27/27] iommu/arm-smmu-v3: Allow setting a S1 domain to a PASID
Date: Wed,  6 Dec 2023 13:28:33 -0400
Message-ID: <27-v3-9083a9368a5c+23fb-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v3-9083a9368a5c+23fb-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR0102CA0037.prod.exchangelabs.com
 (2603:10b6:208:25::14) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB8360:EE_
X-MS-Office365-Filtering-Correlation-Id: 8da6173e-ef89-405c-8097-08dbf680c665
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	KnWPdkknfxsI8fVyZ+Q3CYlIT4frCIC7+PR4GSG6LsaqP1QvZb1lQl8/ZgFB/DmPby1TAhykAv6cE0CnEGBHPWMI8oZurHjT9wPS5V4Fx+JRsZDc0UzmjM6eulgT6KTP+6tDNaKwdes3seQNv02wvmF7Tl8dPD9HCbOG4B10HJzyvzGmwNPUiWGer+g3om7DWNMaUyvC/wkcfc1Y56WFihNgLpZ9K7y8+JgHEUQQ33fuUQAmyXFL8JZkIITrIaRQs4NdqT7Unh1i3V6aj4TJM3CBAOugio4dyoGk9M8Nu0bfjAkc5u71JwNbdjrSvJu7PAi7WTIF0kKa5VkIEyBpNjavLRzp7+RVtcWek0CqchDMtE8K+LoG/mFp/G7GvK29M7Kepce4Q5Cz+jWxxsvt7Dvl3xAPqdG7gQXrqscti+yhzM3Ic6YYKNkoPASuIXwiKA+uHnf5+l1s6gRS2uYGh1dO5qbYvKgP0WJhyGBbuEVqsx017JoeBTzBoA3TDpW3axZaIMM2morSPXWSdA9Rw/ZUy2sJojMe+VYxLqhjoVFyqaLK9OkmOst6X92pzUvp
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(376002)(136003)(366004)(396003)(230922051799003)(186009)(64100799003)(1800799012)(451199024)(6666004)(6486002)(478600001)(38100700002)(83380400001)(66946007)(6512007)(2616005)(66476007)(6506007)(8676002)(2906002)(4326008)(54906003)(7416002)(5660300002)(86362001)(36756003)(41300700001)(66556008)(8936002)(316002)(110136005)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?okknbTKUQuBKxdTKF5flvpOQODk3mlKr79avucgtD+oEvF5fl58q+V634DO9?=
 =?us-ascii?Q?VYadG/ZWW1eyKf0Cy9W0/1o1Nap++Q6U0g4X6OdjPGncGisr0Y7c2Jv/5bqW?=
 =?us-ascii?Q?29gFUDnqUWZM0ZFA9egB6wYegIOTXZSuBa0AGqIOYbxwxnMIZTNNwBI3rV0N?=
 =?us-ascii?Q?djiFJb3sOR6wihJ3uaRQ/12RNTvHDTa+biYE3kO0n/8vyJS2v2o1MyVFfcp5?=
 =?us-ascii?Q?J69Z8UEIqMXvA4R9bIp3GPG1FQ0Yub70vxsXomKgsGWjF38PuoNVVdzGYDPd?=
 =?us-ascii?Q?/lSPpSG5fu5lGn5IWFA5cKzW9zJ7ZJWV6aPEJ2gpGJzsb5pZzT8ZjaFeck6S?=
 =?us-ascii?Q?D2rLfTrMj0f/bMJKto2WMoXGuJIlHpioVK0XV2biahckPuKxCHf9TECKRO2m?=
 =?us-ascii?Q?VHLJ1EFfqTgSWm8Ssb/Rq+zeU5yb9ppLDtdG2ayRuMIJaZUdOO13h6wk1wBZ?=
 =?us-ascii?Q?QPtdPdbFK6fZRYojKmlx10EdemiGk2K5UTGb134W0b5Bn8RgEraZOMrT0hf3?=
 =?us-ascii?Q?FiKXt+yCdOvygbvIwUi1DA+2naJEdVxmBus13PSoKStmCNAQStUtOM5KKiLm?=
 =?us-ascii?Q?AED8ajnyH+fvkmqKI3J691nvLxPMCX44ZMkxkJdHE5mfMuHWcWuaFThtRVQs?=
 =?us-ascii?Q?sy7El9JQfZm9XG44TuX9OCymdDnkhuX25qitBUGN4jpAc6V7i/MefYNwYmPn?=
 =?us-ascii?Q?JgxnMfWu4xpSv5UvXyQlI63nCYdC0F9ga6vDRwLSywi5HtZ+cqHSH8wmWnX3?=
 =?us-ascii?Q?tGCHFejbbHKv4fu+Nnnf3XaPtKKvBLEo3ugX7A8/EnM5kJmpIHG2ZrY5mi8h?=
 =?us-ascii?Q?bv6Yn3W2sziLlIyK658pVlJvwhR2LzrLUgaZB8eATZHVAxl+ASAigtcEvt21?=
 =?us-ascii?Q?2uJe2QHUdWR6wJ5WrNKZp1HOdO+qWMGpz8BJJF5Hbei/E6z+g0oLPeEi3DZN?=
 =?us-ascii?Q?MoikYfkue6IsiGS5m8bblJP8i4p8g0JxTZvUr5HP3CFyvCLbMJV88EZ0XVcn?=
 =?us-ascii?Q?oTn4T3qlzdwRIt/TT0gZjZZozr/A6x6KLIatHlJFv4+R/kOtq8ASwpxYnJPB?=
 =?us-ascii?Q?FhX2AgqVJHXxlxU27TTOkhJme48VEzPGdVxy9P46JC/cNjw2DSZcZeKEhhlh?=
 =?us-ascii?Q?Jc9IlI+MahTLZqlmOTMDZN2Q5gA5H2MC+MzR9rdcDpfG71+3IqQLOYxR/ApW?=
 =?us-ascii?Q?k8nNjIWIbOKr3Ug2gE30jIkJRKTC7DXcHtAOLGkADacWDH3r/qRAkQCdvsZF?=
 =?us-ascii?Q?dOaud6zZHzF6MuaVkwKVNtJFryPPBhDEkX8ySL7Hn9AdqtAuzvFM20wvf2zV?=
 =?us-ascii?Q?HIsxIOnvr0R3GtQFJi93c5zHfoQzSpr+tcHuulCLY2iZHrIlEEfjXjHQ0s8z?=
 =?us-ascii?Q?Cj5LxW56PZ6Pb8ZHyBxIcqOh/+cqSPWhefxDDP3KoI7iAWbNEqw1BG+O0WQ5?=
 =?us-ascii?Q?DLZjoiUfScV25iLFhvvlZvhHOYnAUPFWKKH9x7Tucyu6E+/Ho924O5F/LoLx?=
 =?us-ascii?Q?1UcUEqI1WXJbcoz6eSYmladzfKAS7d2pM9XwaOC4IPXSUyugiNofpA/x4A/0?=
 =?us-ascii?Q?w0OCjw3+cllBCd2ev+BdJPwbhmN+vIPe+q+1OMK3?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8da6173e-ef89-405c-8097-08dbf680c665
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2023 17:28:34.9605
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: COJQFTrbj/HxR9Rg3YyJYbtwqVVPKRIHbZsJuASHKSMwIL3HwtmsS2K/NlkRMn24
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8360

The SVA cleanup made the SSID logic entirely general so all we need to do
is call it with the correct cd table entry for a S1 domain.

This is slightly tricky because of the ASID and how the locking works, the
simple fix is to just update the ASID once we get the right locks.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 45 +++++++++++++++++++--
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  2 +-
 2 files changed, 42 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 7e5721490b7f4c..5a0f0ea30c3f5b 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1217,8 +1217,6 @@ void arm_smmu_make_s1_cd(struct arm_smmu_cd *target,
 	typeof(&pgtbl_cfg->arm_lpae_s1_cfg.tcr) tcr =
 		&pgtbl_cfg->arm_lpae_s1_cfg.tcr;
 
-	lockdep_assert_held(&master->smmu->asid_lock);
-
 	memset(target, 0, sizeof(*target));
 
 	target->data[0] = cpu_to_le64(
@@ -2685,6 +2683,36 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	return 0;
 }
 
+static int arm_smmu_s1_set_dev_pasid(struct iommu_domain *domain,
+				      struct device *dev, ioasid_t id)
+{
+	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
+	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
+	struct arm_smmu_device *smmu = master->smmu;
+	struct arm_smmu_cd target_cd;
+	int ret = 0;
+
+	mutex_lock(&smmu_domain->init_mutex);
+	if (!smmu_domain->smmu)
+		ret = arm_smmu_domain_finalise(smmu_domain, smmu);
+	else if (smmu_domain->smmu != smmu)
+		ret = -EINVAL;
+	mutex_unlock(&smmu_domain->init_mutex);
+	if (ret)
+		return ret;
+
+	if (smmu_domain->stage != ARM_SMMU_DOMAIN_S1)
+		return -EINVAL;
+
+	/*
+	 * We can read cd.asid outside the lock because arm_smmu_set_pasid()
+	 * will fix it
+	 */
+	arm_smmu_make_s1_cd(&target_cd, master, smmu_domain);
+	return arm_smmu_set_pasid(master, to_smmu_domain(domain), id,
+				  &target_cd);
+}
+
 static void arm_smmu_update_ste(struct arm_smmu_master *master,
 				struct iommu_domain *sid_domain,
 				bool want_ats)
@@ -2713,7 +2741,7 @@ static void arm_smmu_update_ste(struct arm_smmu_master *master,
 
 int arm_smmu_set_pasid(struct arm_smmu_master *master,
 		       struct arm_smmu_domain *smmu_domain, ioasid_t pasid,
-		       const struct arm_smmu_cd *cd)
+		       struct arm_smmu_cd *cd)
 {
 	struct iommu_domain *sid_domain = iommu_get_domain_for_dev(master->dev);
 	struct arm_smmu_cd *cdptr;
@@ -2737,6 +2765,14 @@ int arm_smmu_set_pasid(struct arm_smmu_master *master,
 	if (ret)
 		goto out_unlock;
 
+	/*
+	 * We don't want to obtain to the asid_lock too early, so fix up the
+	 * caller set ASID under the lock in case it changed.
+	 */
+	cd->data[0] &= ~cpu_to_le64(CTXDESC_CD_0_ASID);
+	cd->data[0] |= cpu_to_le64(
+		FIELD_PREP(CTXDESC_CD_0_ASID, smmu_domain->cd.asid));
+
 	arm_smmu_write_cd_entry(master, pasid, cdptr, cd);
 	arm_smmu_update_ste(master, sid_domain, state.want_ats);
 
@@ -2754,7 +2790,7 @@ static void arm_smmu_remove_dev_pasid(struct device *dev, ioasid_t pasid)
 	struct iommu_domain *domain;
 	bool last_ssid = master->cd_table.used_ssids == 1;
 
-	domain = iommu_get_domain_for_dev_pasid(dev, pasid, IOMMU_DOMAIN_SVA);
+	domain = iommu_get_domain_for_dev_pasid(dev, pasid, 0);
 	if (WARN_ON(IS_ERR(domain)) || !domain)
 		return;
 
@@ -3280,6 +3316,7 @@ static struct iommu_ops arm_smmu_ops = {
 	.owner			= THIS_MODULE,
 	.default_domain_ops = &(const struct iommu_domain_ops) {
 		.attach_dev		= arm_smmu_attach_dev,
+		.set_dev_pasid		= arm_smmu_s1_set_dev_pasid,
 		.map_pages		= arm_smmu_map_pages,
 		.unmap_pages		= arm_smmu_unmap_pages,
 		.flush_iotlb_all	= arm_smmu_flush_iotlb_all,
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 19628340ccd632..91b23437f41055 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -786,7 +786,7 @@ void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
 
 int arm_smmu_set_pasid(struct arm_smmu_master *master,
 		       struct arm_smmu_domain *smmu_domain, ioasid_t pasid,
-		       const struct arm_smmu_cd *cd);
+		       struct arm_smmu_cd *cd);
 void arm_smmu_remove_pasid(struct arm_smmu_master *master,
 			   struct arm_smmu_domain *smmu_domain, ioasid_t pasid);
 
-- 
2.43.0

