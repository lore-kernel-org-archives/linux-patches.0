Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2086.outbound.protection.outlook.com [40.107.237.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 829E3135A78;
	Tue,  6 Feb 2024 15:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707232403; cv=fail; b=Qrh9LimYyMeVVhcj8TWEZLs2CLYdyydTeWv2a1W+mDCLeCO459fj7MZ2W6wtszkBJtTx1P7vUUlGtHdmpfJ5mQzvOQcVVD7Rnm0r8muu78+ApUxKoIqnDrq+yERBU5kxRpxg+l3X2N3177hxUNjI6pFSDbjeIvANPdkwaKT+u1w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707232403; c=relaxed/simple;
	bh=4AYsKHLmRPQDrObW41MI8SD7PwCWxN4NN1cVybaSQpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TbKwTLe9Dag+iXSK8Qt5N7FIc6IhfuPQEMXHcu/g3y6ah/ljFVEzqFLGXRe27FXDSwJ1XyAgZ2wLto2jh3V6MpTPBYFf1DlK9vO71ovNLT25u2KA/LfWQzy3X/i0ItDFUmSmEfmhI4+j4NOpHd4dV3QmDOCCzFjvyFj6IFU+qHE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=IMXoIWFS; arc=fail smtp.client-ip=40.107.237.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="IMXoIWFS"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c4m60eudJXHaLWmRfCDReouaZUqPXgppU5mhzrmpiv3nLiwy97quMIo/BZ1p9zvT8j7cyvmbc/1fSocyXIy+QjTovraeArWxjBhvp4zpTQQtLy57BMMF4f3x/dPJwayGGk7NooH1M3I6krw7T4493XEUGlgJQn8f3SWhMqKhZNFgcfwEiWeFX1E8If1OdGHigcfTLls+cRBJqs6cPSa2XrKFTrB8eGq4aM2xFJ+f2PfLQBsLFfl0pmiipVZaQrjaF4r6GYh9Qx0Zi5nU3M6bfaVzDaDyc9umt0xhdyWmO7r2kO3Dgs3uKzVoTG6FiQ8uWIkwu+a+3xkjkw+MG7DmJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=neQ3Ln94OMYkFN41cp+XL2Ok9wGJ1AglbofXvFxu0uI=;
 b=kpRa+fa0LTd5QYt2c7B3IFaGcKENi4+v4E9Okf6UKXB8SXRu1bd/BMeIMbXbyAlZ30aCIzrBceyWWPQNO992MC8yeDEkmNwb4s4uw6bWPFnMkmJN6sntvCRviNYqjNXTJjxX1vd5WPtF+vTZ53EH5qns0matf3eH5ENgw6UtFEVl9oVrCk+Sie02vYtTKpVXlV728ibh2F6tUE0rtz85WM2QI3Lmw/yRUSmByDQ6S6iAz6E40qh2O3rLuGpd9FEZTPW5ZrjCvbUOQ/FcZ9+amuc2NUzOXKoQMtuwL1gWp3im1aolV1txfbFdcHLRalaevCSYz3rIzzbkBJwOrIgOQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=neQ3Ln94OMYkFN41cp+XL2Ok9wGJ1AglbofXvFxu0uI=;
 b=IMXoIWFSFt974ZhuoEb5sct+5/sV0yspZYo7g2NHD3v0DfFduXaGzFmxLNKobUgkyxXsTDZqY7GFcgtY62+ngCEBuFxkOkB9gHix4lYaSHITK9H5qK7imS7Yd3eZ5w/bVeR7ffM7sNa7V1Vw1IlxbwtxXAVWhCEgZ+QSFvXvMDcpg0Z9wCDUgnR5hee+R+J+wXFIZxAt4hp/1xuCGmYoi9Ksj0HhE6//ti6aeE6dD5XmsoOoyTZ19V1pDd2Ykowp1babtYCuGWYquAX0+yy11BT7SAFSysv9a0ARVrnmw+KL1iyMp/IH0mBUTwcEOUBy7IJMClOAm08sytzAWl17PA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ0PR12MB6733.namprd12.prod.outlook.com (2603:10b6:a03:477::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.16; Tue, 6 Feb
 2024 15:13:06 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7270.012; Tue, 6 Feb 2024
 15:13:06 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <jroedel@suse.de>,
	Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH v5 13/17] iommu/arm-smmu-v3: Add a global static IDENTITY domain
Date: Tue,  6 Feb 2024 11:12:50 -0400
Message-ID: <13-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
In-Reply-To: <0-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR13CA0015.namprd13.prod.outlook.com
 (2603:10b6:208:160::28) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ0PR12MB6733:EE_
X-MS-Office365-Filtering-Correlation-Id: b4dafb2d-3e26-4961-e89e-08dc2726192e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	iqxyVAIJxmazbk21KRSI+t07eRhVbHTUJ3Uv8zkWYi7faet1w36T47ZDr48xfKDsrTmxkXx7Plll9XnFRiQ+8P0PUo5Jiq/Q/mCB3FjW2CSX3EMyBZPJ2L8bnU+AMQx7WNuj1QB3KaF8ehgqcbbbRFOL1NZ+mJ9cjXImJ48VZgIiFwpIBjEeWVMBqVE+GM/nQEJPI45NRS1OSwlHHnkySwaDn/+flkZ6WZnvSY27XbRwqoVF6Cx42cJwI1OPU81DboCdA9EHHDoAgyuZf7OFJEK8fPhYMe5q/8MWxdTwbeZpKQ3JP8dENMWPYvm6zQeMNqxB31ltsrGSiVT8jZXi40gEqY8EVnDDELddy3AJBzEnukLQweblb8IIi5NN6EbvfBv8anX3Y2CTwOoEebPxwsW466ztra1oWoytKiW+MIbVU3bz9izIh3cq/lK5uaRKG8V3q6sqSWXQwB4YAD+MwIroioYo92KevRR64+5WhRMHrd/HGidbCOpiZAZfdDVRGXjodP+ED7DcrlrPzc+EqhavDFbt0Dkg/512upvncCm/aRlWk67p9Dh1y1UoVe7I
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(39860400002)(366004)(376002)(396003)(136003)(230922051799003)(64100799003)(186009)(1800799012)(451199024)(54906003)(316002)(83380400001)(110136005)(38100700002)(2616005)(6506007)(6666004)(26005)(2906002)(7416002)(6512007)(6486002)(86362001)(5660300002)(478600001)(8676002)(66946007)(66556008)(4326008)(8936002)(36756003)(66476007)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hblDwt2yvKqjcpZ7+MBppk/WXC3KJRpnAXAAtrfd+Lwov2a9ubyVGgwEC27+?=
 =?us-ascii?Q?4MAdnEWwL24lpacTO0ipCdrhNYodKsIKc/n0+MyfHnVrNhnxGE3wGfG7FSyI?=
 =?us-ascii?Q?W53cymhvsHl91s/qbkd96DNZmRII6iCPn6Von+a6KP0hfh6fkjmsEeCHBUgZ?=
 =?us-ascii?Q?m6GnRbOseaSKPXW8ow5LFC71I0PeAvE6k09eBfoMw3snLRMcMo1IGwHxHOXs?=
 =?us-ascii?Q?2BI1BlCqksGykE6Bzpn9Q6onRUM9at8dsRydzmhEg+drZ6OsXD4LgboVHBiZ?=
 =?us-ascii?Q?X6eG+fyUX+3AGsnctlAclolsY8boJZSgzzWrfb80Gjeer4TTGTy5dJOMsoc6?=
 =?us-ascii?Q?6Unh0RfpqZmKWUw//zPR/TB37tZiiCR+wlclBfLyRx/SOlrRH2PrwQaCBIhD?=
 =?us-ascii?Q?nfDATsKGTE4jw5Tnq+qwiHDJi4/rfNQbTVKsPM9zqhNr9eP7rj1Tr+4vRVSJ?=
 =?us-ascii?Q?7lGCb8kVuaiIPx51g8srilj6jPduKXxezQQHz/0PyQJygXz+dI+k2KLLvqUp?=
 =?us-ascii?Q?4Ly1TTy7MU8BT59GSK0NpnE1qAxNtW7e1hkoR3ebEsNuDUTR0GrhGEh+q+cP?=
 =?us-ascii?Q?kT+5be8Q2jT3w2YvwyGPMwHCDz8K8zJUVSMRoBh+HwsRW5XlILErXrPQDITa?=
 =?us-ascii?Q?9MThD0TlIl80bZ8vhXETRpqHJCbW/sXdkkVMrzmuJDCTRcxwDdmY+JFtmVmP?=
 =?us-ascii?Q?ImHR2CeP0T2iAtcwU9VAgkF4TgAjhfuvqDVZ1LHMhknFTsnuOfLtp7qFJ/ek?=
 =?us-ascii?Q?9W8zieDK+VQaNk3v6gHi0l3s9VWF9WsCe26yrIfYwoD2VzjpyMEAzPAkgWkv?=
 =?us-ascii?Q?rwVstqg4RC8o2IWf/Yun/xsatuWn0YWVXqcDdSTMTeS59AfDJxDBxWZm+Zi8?=
 =?us-ascii?Q?yx+8lx7duuOrIqLC71I+ICx+ZpZzNfEZMoIgD2HDlHsjN1RbLRRmimQHVy6T?=
 =?us-ascii?Q?kfD7XgU7H1TEuX+BokcxkiqoMC00HpN9EgPlAjGlbhnLDlqLgKkwS+6hI0w4?=
 =?us-ascii?Q?wvwg0zD4Jfe9YAFOVSFjL0FTHYPUxxH+xLQQWr6OaOlVna89Cu0hYSYGWf2I?=
 =?us-ascii?Q?qRF2cB9saWBsP3nciNHDiCIt1069BVIOc1baQTw53EopyXtG2Pf21XNqAhC2?=
 =?us-ascii?Q?oI2hFVj/RQknTDt1qv2TNfubX7It7MG+8qN8a5z0grsAK9xDDqdNwGxCAUp2?=
 =?us-ascii?Q?2Ywi5+gLVJlc15EI/u8yHolFiSfw4PUJj+6himLCv5lLupIMlmeUqIBw4hR+?=
 =?us-ascii?Q?nFC7AWNX8gIzQ0FL7hpD01q/84RKXeH53jOcNRJK2qEILT+T31pVj05tC/+b?=
 =?us-ascii?Q?TvNl8Y5G/AYEQHNaTDpFBCJ/QKNLwIVSaP2kg1WR21FFU2B9ApxPIaMuPRss?=
 =?us-ascii?Q?HUlyagXoBPtJnJLcxJyLpAQ5xlo1UAtkYteET0s3tgneEetzoe/bC0iCTLxG?=
 =?us-ascii?Q?qUf3h4fpodqWjfrAepwoNOHbY/BfpeyRTtpqHDlcnyAGP6zcsGnotwOOHFK+?=
 =?us-ascii?Q?r/mWhgkfgLOlbLC80X6NISCogAViGjF6NnJu3Z9m/vLRo3vFKTPXJoGwcS64?=
 =?us-ascii?Q?qd5XBqcDztVLgbkALucxPXZ9Z4XsQ1gI2AktqOaW?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4dafb2d-3e26-4961-e89e-08dc2726192e
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2024 15:12:56.5763
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qa/uK79N9VHqxdSblSqo3A6MWWrmBKzSG6IsMZjvpAUKClPdg553+4v9EdLVr/Dp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6733

Move to the new static global for identity domains. Move all the logic out
of arm_smmu_attach_dev into an identity only function.

Reviewed-by: Michael Shavit <mshavit@google.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Moritz Fischer <moritzf@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 82 +++++++++++++++------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  1 -
 2 files changed, 58 insertions(+), 25 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index a98707cd1efccb..a940b5ff96843c 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2253,8 +2253,7 @@ static struct iommu_domain *arm_smmu_domain_alloc(unsigned type)
 		return arm_smmu_sva_domain_alloc();
 
 	if (type != IOMMU_DOMAIN_UNMANAGED &&
-	    type != IOMMU_DOMAIN_DMA &&
-	    type != IOMMU_DOMAIN_IDENTITY)
+	    type != IOMMU_DOMAIN_DMA)
 		return NULL;
 
 	/*
@@ -2362,11 +2361,6 @@ static int arm_smmu_domain_finalise(struct iommu_domain *domain)
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
 	struct arm_smmu_device *smmu = smmu_domain->smmu;
 
-	if (domain->type == IOMMU_DOMAIN_IDENTITY) {
-		smmu_domain->stage = ARM_SMMU_DOMAIN_BYPASS;
-		return 0;
-	}
-
 	/* Restrict the stage to what we can actually support */
 	if (!(smmu->features & ARM_SMMU_FEAT_TRANS_S1))
 		smmu_domain->stage = ARM_SMMU_DOMAIN_S2;
@@ -2564,7 +2558,7 @@ static void arm_smmu_detach_dev(struct arm_smmu_master *master)
 	struct arm_smmu_domain *smmu_domain;
 	unsigned long flags;
 
-	if (!domain)
+	if (!domain || !(domain->type & __IOMMU_DOMAIN_PAGING))
 		return;
 
 	smmu_domain = to_smmu_domain(domain);
@@ -2627,15 +2621,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 
 	arm_smmu_detach_dev(master);
 
-	/*
-	 * The SMMU does not support enabling ATS with bypass. When the STE is
-	 * in bypass (STE.Config[2:0] == 0b100), ATS Translation Requests and
-	 * Translated transactions are denied as though ATS is disabled for the
-	 * stream (STE.EATS == 0b00), causing F_BAD_ATS_TREQ and
-	 * F_TRANSL_FORBIDDEN events (IHI0070Ea 5.2 Stream Table Entry).
-	 */
-	if (smmu_domain->stage != ARM_SMMU_DOMAIN_BYPASS)
-		master->ats_enabled = arm_smmu_ats_supported(master);
+	master->ats_enabled = arm_smmu_ats_supported(master);
 
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
 	list_add(&master->domain_head, &smmu_domain->devices);
@@ -2672,13 +2658,6 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 			arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID,
 						      NULL);
 		break;
-	case ARM_SMMU_DOMAIN_BYPASS:
-		arm_smmu_make_bypass_ste(&target);
-		arm_smmu_install_ste_for_dev(master, &target);
-		if (master->cd_table.cdtab)
-			arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID,
-						      NULL);
-		break;
 	}
 
 	arm_smmu_enable_ats(master, smmu_domain);
@@ -2694,6 +2673,60 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	return ret;
 }
 
+static int arm_smmu_attach_dev_ste(struct device *dev,
+				   struct arm_smmu_ste *ste)
+{
+	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
+
+	if (arm_smmu_master_sva_enabled(master))
+		return -EBUSY;
+
+	/*
+	 * Do not allow any ASID to be changed while are working on the STE,
+	 * otherwise we could miss invalidations.
+	 */
+	mutex_lock(&arm_smmu_asid_lock);
+
+	/*
+	 * The SMMU does not support enabling ATS with bypass/abort. When the
+	 * STE is in bypass (STE.Config[2:0] == 0b100), ATS Translation Requests
+	 * and Translated transactions are denied as though ATS is disabled for
+	 * the stream (STE.EATS == 0b00), causing F_BAD_ATS_TREQ and
+	 * F_TRANSL_FORBIDDEN events (IHI0070Ea 5.2 Stream Table Entry).
+	 */
+	arm_smmu_detach_dev(master);
+
+	arm_smmu_install_ste_for_dev(master, ste);
+	mutex_unlock(&arm_smmu_asid_lock);
+
+	/*
+	 * This has to be done after removing the master from the
+	 * arm_smmu_domain->devices to avoid races updating the same context
+	 * descriptor from arm_smmu_share_asid().
+	 */
+	if (master->cd_table.cdtab)
+		arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID, NULL);
+	return 0;
+}
+
+static int arm_smmu_attach_dev_identity(struct iommu_domain *domain,
+					struct device *dev)
+{
+	struct arm_smmu_ste ste;
+
+	arm_smmu_make_bypass_ste(&ste);
+	return arm_smmu_attach_dev_ste(dev, &ste);
+}
+
+static const struct iommu_domain_ops arm_smmu_identity_ops = {
+	.attach_dev = arm_smmu_attach_dev_identity,
+};
+
+static struct iommu_domain arm_smmu_identity_domain = {
+	.type = IOMMU_DOMAIN_IDENTITY,
+	.ops = &arm_smmu_identity_ops,
+};
+
 static int arm_smmu_map_pages(struct iommu_domain *domain, unsigned long iova,
 			      phys_addr_t paddr, size_t pgsize, size_t pgcount,
 			      int prot, gfp_t gfp, size_t *mapped)
@@ -3083,6 +3116,7 @@ static void arm_smmu_remove_dev_pasid(struct device *dev, ioasid_t pasid)
 }
 
 static struct iommu_ops arm_smmu_ops = {
+	.identity_domain	= &arm_smmu_identity_domain,
 	.capable		= arm_smmu_capable,
 	.domain_alloc		= arm_smmu_domain_alloc,
 	.probe_device		= arm_smmu_probe_device,
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 587f99701ad30f..23d8ab9a937aa6 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -713,7 +713,6 @@ struct arm_smmu_master {
 enum arm_smmu_domain_stage {
 	ARM_SMMU_DOMAIN_S1 = 0,
 	ARM_SMMU_DOMAIN_S2,
-	ARM_SMMU_DOMAIN_BYPASS,
 };
 
 struct arm_smmu_domain {
-- 
2.43.0

