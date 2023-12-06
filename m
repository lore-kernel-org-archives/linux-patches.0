Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2044.outbound.protection.outlook.com [40.107.244.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E696A000;
	Wed,  6 Dec 2023 17:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ryITzgQR"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=InBaeYUL5y/l1ablo9joRlRY5b7q3oFjdmwMJbzssQ58KvP6/WyvO7uYe/nDSZE036+6ZkI8mnQ+0P+35jrKN86iKGUKlABNyWS6nc+cI8kZ7yPqNZbD9A8cdTWplb3+ojbPOxKBP+8Wh9CjWkjxoXXmqt/2VeVu+DyYWxDsQeEfu86IX6xbHYxUkMeFEPk/w9h0xcQFU4cwR6BsKTG7nGXZaSfHjOe6EqBcY6RLj1/Xip67BeCZxstLd6PIHgOEFW2jdEZtgsX3U4meA4APi0iHpFh1MMJQKJxeTiVcLSQnIKKKhWD2+2RS0BOTrD8ofJT2ZR8ov3OkdYme+ey0+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dE8YPqXFkgqbxJ+kWciNCG/M1/X9RBAap59Ml6R3fgs=;
 b=WfvZg12pOpod2vpZUAzaGFIxDSlkDhIQ0LE2BI5VJNC9wtTF12rsAwxG0VQu4QLeNKgmfRia6sffmKdbzuWrVu/w0CyTkKtWG39juPsuKpJxQWczfaKcf64zZr3E4DtU3LlVXZPqs3TYyhUSns43Kcro/mh3L4SFY5Hq1kW9nf7LyK5A51Y7TNfsKjdlzcQ7U6AbXd0lSYmxZnIG/uwngsdQyfTYVzN9W+5LT3t/ffSVFzZ8virA8R/M35GLr0vbmYJjNmUVkk8GREn9NAHiwlvsmFsXJIE2Ug4fJphY7RDh1wznSCLrjuIkzBFwCsACWIpFCayf2OR11sgD0osfLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dE8YPqXFkgqbxJ+kWciNCG/M1/X9RBAap59Ml6R3fgs=;
 b=ryITzgQRcqeKUM6Rrw3bNWt2dPUSxPemxdF+Q4h7ISleEq0ZHQw03JOwVOd5F2J2qGaTfdq0sX3CJo5l4a7pNMlujah/nzkgso0HRxbbK+C8izGahxFwFvjwCSn0F77oqminCJF6/rwXSOBK0qPJ6M2wfD/K+iOFwU635terDISNuJvTjVtgr1wZhGfgOXjTijDvD61OELeafcQwjl5X+tU/um17BTjS1x2F9WF51s2tP0VqPXIRljOnKJPKGrU5zzGbG/LSxoEDrDqRRG7t4Jk/Qi7ueQMbNI+HoT+raYM51YCQl1wypBb4Sf4gqHfCy7px13vc9uDT9Cf0TfrH1g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB8360.namprd12.prod.outlook.com (2603:10b6:208:3d8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Wed, 6 Dec
 2023 17:28:45 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.034; Wed, 6 Dec 2023
 17:28:45 +0000
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
Subject: [PATCH v3 26/27] iommu/arm-smmu-v3: Allow a PASID to be set when RID is IDENTITY/BLOCKED
Date: Wed,  6 Dec 2023 13:28:32 -0400
Message-ID: <26-v3-9083a9368a5c+23fb-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v3-9083a9368a5c+23fb-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR22CA0003.namprd22.prod.outlook.com
 (2603:10b6:208:238::8) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB8360:EE_
X-MS-Office365-Filtering-Correlation-Id: 58cb03a5-9387-45dd-6127-08dbf680c769
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	+Q111PE6d4t52VQh+D4wGVvnYgR9mUW9s4RKwUYTBoVbeWMzwTv7+c16EXs0PnWtHpU7HwSz9v0jgndyS8TtjJ0w5Mtstu/KNBoXeV/Apsa+D4tsENaCqMlfXx26IRJP0h38nVWv2jgWysKGX7LK08TlBSIH0yO+t6w1mXlDE1FAdzQcoZULU8322hCvdNRaryRsF/oahUPdv4lDYRMp2MqWwm9yxvGy/fTScJhZWbLtPE11uhW1Fb4uaMxUuDMDD3f4a7CLfprvGjaRRH+esPBouy2R2x+ySlhMOmMRhZ+xUVvYvhsTNricnPozdpK6DzdOxjtAQqZugloGUg6lXqtNmWwyGYMKtxx7ZVFETI9qnCp05PZvoOKwh42v3SPUDbWKfj00R9b+K3NEZspI+DlREx1NBMuDr56srAVYqL7Ky6eZ5VB0J5SzZQRG8RnN+F4DdqihWw1yt+tDK8Fl2zhlVSpyelII2aLrxf+JV5bpouVbIh/eYKxjHahrcyIKeDRCsmPXBdqnEO3eSyBdU+YTb1/Zqvo5tad+VvKsPwz8gbyZ9dNqDM1jcKp80EuOKfHCPErJfOknIJzqHRIGGbF5JBY237XnwFe+6lYzdoYX0v7HeyZHF5SCBblz6K2jDSIL72kGC0mBmIOHavqUzg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(376002)(136003)(366004)(396003)(230922051799003)(186009)(64100799003)(1800799012)(451199024)(6666004)(6486002)(478600001)(38100700002)(83380400001)(66946007)(6512007)(2616005)(66476007)(6506007)(8676002)(2906002)(4326008)(54906003)(7416002)(15650500001)(5660300002)(86362001)(36756003)(41300700001)(66556008)(8936002)(316002)(110136005)(26005)(414714003)(473944003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yGGlPx6FNTtFMS5cQ1O+tV3/WF/5ikQthUsH3T6pwjuljfoFzv6KJ4eqG1m8?=
 =?us-ascii?Q?2fDjIONHbdtr/QHuxmpMw+3enjK3e8GjJPqSrvT8okxvN/pwC2zHwFp/T8Fr?=
 =?us-ascii?Q?hFx007ebEAXP/c6V2WbtTZWW7BD0x7iViJkar5vOCgtvJm3cqoMoop8G0hRI?=
 =?us-ascii?Q?rAPSDOu2jeUEX15h72hFZ/aoltbjKiaIDvIdf3t759EBS2KstbhryB1RBg11?=
 =?us-ascii?Q?hxNaGUGf9xbKuzS3Nh1So9U1QCK5JpzIl7Aepvjce/UZAjD1EstJgAOgz/7M?=
 =?us-ascii?Q?iqBXkitHSZDfyWz5T8x/vc1dcGDfchio0x7kmfxRFujxcGQmVvPupNAiJRfN?=
 =?us-ascii?Q?xdRzhhBBjZIy0T6NikqY0r7E6SuD7ShAiICljIwrFk8zCd+E3LCmTyVbuwzw?=
 =?us-ascii?Q?qICDgb/ABHyBkvWKBfLl2Nz3rptGPoEqW4fPQzLvd0uR87kh+Dxh+XJRLBWa?=
 =?us-ascii?Q?K34WXyoJLQojSzdrpSUrRT0Z4rNMDvEu61V6qYRN4da2hl2XxYFyzgiJuYTC?=
 =?us-ascii?Q?+onVIvs3bDE5Xz/uO97uvp2dgAbOUlB5Rr5r51tz+bUcThNf2vB93XsU0BbW?=
 =?us-ascii?Q?Xrqva/25Za8ncxVQ2Cn41gRZ7F1JTmBkX9ERpPuQj2msZ1+3Cz6bgO18VDqN?=
 =?us-ascii?Q?sgWYDiP2uyNr1Vn4uEgj4H9OI5SjhEaedDxC5DUAIgSwwdHXnMc58xbqI4az?=
 =?us-ascii?Q?HV3ujGxmYiM6Ojnk7lCMqbbdKmFYbjtGDcEmbTOsKShmg/HHTet7QSsbgnhG?=
 =?us-ascii?Q?6JWhvpwLhRuCQtG3o3xLmc2Goa1b4K3LFB82xBtBQSv8wEAcEuisvy8MdSc2?=
 =?us-ascii?Q?kdvbfnJdaJSxQFsLgBGmg8Plk55e0SrdRv4KRqRaIDsy/r7kQpexd3nwtsf3?=
 =?us-ascii?Q?/PXwMwff/dWmYiAn1P5x9IOU4CVOR3u7K/gjRdmueuA64fC2appVnsgxo9JO?=
 =?us-ascii?Q?3M7PWZ8vmVUVQbPti6HWrLbBU4cO/o4t4aB4jviJ5VXX40ZWva2aFXkVQnhK?=
 =?us-ascii?Q?YIPaMyRFhR8IVDZShY3yhCV8F7E4gGHjydidVOfcas3uO3naJ8tsKKb5a3yA?=
 =?us-ascii?Q?jyJ5gpQiSuE6ezssBGrfc4pdhr6im+KCMcM6fCwqAMq+v1kEaPb5c18WN6uM?=
 =?us-ascii?Q?HjbwlBhSwvH/SG7e2BAIyLKDjcFboBL9sB1EfTHyCuNIN87K9BX/pTScfsOn?=
 =?us-ascii?Q?NYq6eMVS3ELLr1abyLBhj3CowLa14D1FJNvsvwqvIuO7CQhw0LGl24SBUak6?=
 =?us-ascii?Q?sWfZ2yqse2D7hYvOaxTSlEZJ+4tV0McD4u+6xT6ZQhXeWJIdoWbpnn7J1Jca?=
 =?us-ascii?Q?wrza6FlBPmfna/mjKiIog5lMcVzuHrm457jf5Oi9mbrdQIt4waLNNNRk3K1N?=
 =?us-ascii?Q?N2bVdrGGMj+A0YzAnF88JAa4FY6ExCKwzrkc/onwylFJcGce3jCk1Vjg9Iai?=
 =?us-ascii?Q?PfkO+ouzeVoet+aVgq3O8z3PbmMwTxx28ntxvQUUt5T7b/ljcYCy1UKMzQ2L?=
 =?us-ascii?Q?7u/OyZ/nKP6KbBooEmRdVbjEdKf/1/tBbiUfYGOIWFPF6al5lVPw+KJv71Ua?=
 =?us-ascii?Q?cO6tN7ldCIonQw+WweONIuq10oi9BkjWi/sNsgVI?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58cb03a5-9387-45dd-6127-08dbf680c769
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2023 17:28:36.6695
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VtIJX5MbGYFnZ6xQ1hEI5ikWAQBBJ7NwR7yotfOsxyZL7UAe137dyHyv66NrBcL7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8360

If the STE doesn't point to the CD table we can upgrade it by
reprogramming the STE with the appropriate S1DSS. We may also need to turn
on ATS at the same time.

Keep track if the installed STE is pointing at the cd_table and the ATS
state to trigger this path.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 57 +++++++++++++++++++--
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  6 ++-
 2 files changed, 56 insertions(+), 7 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index f97fac1de0b103..7e5721490b7f4c 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2385,6 +2385,13 @@ static void arm_smmu_install_ste_for_dev(struct arm_smmu_master *master,
 	int i, j;
 	struct arm_smmu_device *smmu = master->smmu;
 
+	master->cd_table.in_ste =
+		FIELD_GET(STRTAB_STE_0_CFG, le64_to_cpu(target->data[0])) ==
+		STRTAB_STE_0_CFG_S1_TRANS;
+	master->ste_ats_enabled =
+		FIELD_GET(STRTAB_STE_1_EATS, le64_to_cpu(target->data[1])) ==
+		STRTAB_STE_1_EATS_TRANS;
+
 	for (i = 0; i < master->num_streams; ++i) {
 		u32 sid = master->streams[i].id;
 		struct arm_smmu_ste *step =
@@ -2678,21 +2685,48 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	return 0;
 }
 
+static void arm_smmu_update_ste(struct arm_smmu_master *master,
+				struct iommu_domain *sid_domain,
+				bool want_ats)
+{
+	unsigned int s1dss = STRTAB_STE_1_S1DSS_TERMINATE;
+	struct arm_smmu_ste ste;
+
+	if (master->cd_table.in_ste && master->ste_ats_enabled == want_ats)
+		return;
+
+	if (sid_domain->type == IOMMU_DOMAIN_IDENTITY)
+		s1dss = STRTAB_STE_1_S1DSS_BYPASS;
+	else
+		WARN_ON(sid_domain->type != IOMMU_DOMAIN_BLOCKED);
+
+	/*
+	 * Change the STE into a cdtable one with SID IDENTITY/BLOCKED behavior
+	 * using s1dss if necessary. The cd_table is already installed then
+	 * the S1DSS is correct and this will just update the EATS. Otherwise
+	 * it installs the entire thing. This will be hitless.
+	 */
+	arm_smmu_make_cdtable_ste(&ste, master, &master->cd_table, want_ats,
+				  s1dss);
+	arm_smmu_install_ste_for_dev(master, &ste);
+}
+
 int arm_smmu_set_pasid(struct arm_smmu_master *master,
 		       struct arm_smmu_domain *smmu_domain, ioasid_t pasid,
 		       const struct arm_smmu_cd *cd)
 {
-	struct arm_smmu_domain *sid_smmu_domain =
-		to_smmu_domain_safe(iommu_get_domain_for_dev(master->dev));
+	struct iommu_domain *sid_domain = iommu_get_domain_for_dev(master->dev);
 	struct arm_smmu_cd *cdptr;
 	struct attach_state state;
 	int ret;
 
-	if (smmu_domain->smmu != master->smmu)
+	if (smmu_domain->smmu != master->smmu || pasid == IOMMU_NO_PASID)
 		return -EINVAL;
 
-	if (!sid_smmu_domain || !master->cd_table.used_sid)
-		return -ENODEV;
+	if (!master->cd_table.in_ste &&
+	    sid_domain->type != IOMMU_DOMAIN_IDENTITY &&
+	    sid_domain->type != IOMMU_DOMAIN_BLOCKED)
+		return -EINVAL;
 
 	cdptr = arm_smmu_get_cd_ptr(master, pasid);
 	if (!cdptr)
@@ -2704,6 +2738,7 @@ int arm_smmu_set_pasid(struct arm_smmu_master *master,
 		goto out_unlock;
 
 	arm_smmu_write_cd_entry(master, pasid, cdptr, cd);
+	arm_smmu_update_ste(master, sid_domain, state.want_ats);
 
 	arm_smmu_attach_commit(master, pasid, &state);
 
@@ -2717,6 +2752,7 @@ static void arm_smmu_remove_dev_pasid(struct device *dev, ioasid_t pasid)
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
 	struct arm_smmu_domain *smmu_domain;
 	struct iommu_domain *domain;
+	bool last_ssid = master->cd_table.used_ssids == 1;
 
 	domain = iommu_get_domain_for_dev_pasid(dev, pasid, IOMMU_DOMAIN_SVA);
 	if (WARN_ON(IS_ERR(domain)) || !domain)
@@ -2730,6 +2766,17 @@ static void arm_smmu_remove_dev_pasid(struct device *dev, ioasid_t pasid)
 		arm_smmu_atc_inv_master(master, pasid);
 	arm_smmu_remove_master_domain(master, smmu_domain, pasid);
 	mutex_unlock(&master->smmu->asid_lock);
+
+	/*
+	 * When the last user of the CD table goes away downgrade the STE back
+	 * to a non-cd_table one.
+	 */
+	if (last_ssid && !master->cd_table.used_sid) {
+		struct iommu_domain *sid_domain =
+			iommu_get_domain_for_dev(master->dev);
+
+		sid_domain->ops->attach_dev(sid_domain, master->dev);
+	}
 }
 
 static void arm_smmu_attach_dev_ste(struct device *dev,
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 96b01db47b0ea5..19628340ccd632 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -600,7 +600,8 @@ struct arm_smmu_ctx_desc_cfg {
 	struct arm_smmu_l1_ctx_desc	*l1_desc;
 	unsigned int			num_l1_ents;
 	unsigned int			used_ssids;
-	bool				used_sid;
+	u8				used_sid;
+	u8				in_ste;
 	u8				s1fmt;
 	/* log2 of the maximum number of CDs supported by this table */
 	u8				s1cdmax;
@@ -708,7 +709,8 @@ struct arm_smmu_master {
 	/* Locked by the iommu core using the group mutex */
 	struct arm_smmu_ctx_desc_cfg	cd_table;
 	unsigned int			num_streams;
-	bool				ats_enabled;
+	bool				ats_enabled : 1;
+	bool				ste_ats_enabled : 1;
 	bool				stall_enabled;
 	bool				sva_enabled;
 	bool				iopf_enabled;
-- 
2.43.0

