Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2043.outbound.protection.outlook.com [40.107.94.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC847D400;
	Mon,  4 Mar 2024 23:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709595874; cv=fail; b=FIagOGSSZIChg73XMldJnAQbZUJpK1FdwwXeEg8AXMmqCwZclRv/Z7VkxRmvfarig7iQStOWTei7yAsjiFUyvGFbLoUOqglDgSF/3J+/qlG7YiuztaYclCpqBoWxVGnyayfqrdCZTSa8yqr4+x+uX/uGVFVPRxgD768G738Ny+M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709595874; c=relaxed/simple;
	bh=t2NEp77skkz725lOjk5yqXAkWiWAxOF58uFloI+M20o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IYwA7AHx2rwRBDsaLAdgU5UYUoOsu8GRjNuf4+82Q/DdwL/IoFTRVtaqgBpF7qY+d8n3NHc51hhg8zfual6Q6TxXnBH3+gvgfn5QmAaD5ECpf4QCZ/+7irfg5YrtxSCOR2Ju9zFWzd8d1XnQGnj5P9XtlGqVzBzas0iAINwdwrU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=PZhwUC6K; arc=fail smtp.client-ip=40.107.94.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="PZhwUC6K"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NSIeBxgouGpAbyqx+I9ym3RBEjlrA3vwHGPlRQOP2rAuudt52A43h1+HGh7Y/xtDsOSZcckYLC8L0X7rDs0h+1AJzXhBz9BztJIWjyjKT/XAl8Gm6drYS+8WXGTNx2Ml9kGNBqtla212vZoCNOFvCp+bo6Y5Zp1e+m0xFYjJK8rbej9SdEffUHf7QQA0BQnYPlhUqoZ+kPKFN5hnPJTaBWCWCzWHyk+CoBAqLdv7beJqqETsLk7jftme+45XtbhZYxvg4t9biY5xtJ1XdcQSv520PNdFGKd5FgHcIWQgVP7HZ4xDhik03hrik8kJGViTVpF1I+2QCd8eI98vWUYfdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LJG6ge+sxaoQOokliAV/M4mbEj0DyQrb+A1UnJUG6Rw=;
 b=X8t2A9Q8W0uet4dYV+JkooZI7/L+mdgYa8XGwSOiriPHuxdbrV+DvW2RIhPdus5/jKTNIHZxSTwnkEex3HogbQFALRa0YI4IVNiAeWW0Cyvy0Z0CYSERawJlstCv2FKx6W1Cjy/HfnJSyretZ8dJUTK7+i9ojd8GrsModU3A1V5d1rxpm4NX1laep3FI2SXr9d7xAygcfwPpTWwvbUqVdvaMEaeBs87TlCeyb0qdls25UudMdoqoslWRRxjDJQFRDFDGqrUPOVfyeXRbt5DRuTiHMx5UzyPxsu4KHFTTsTR0aX6mnPtohTvsgahCnq1QZv77LVcBTrC1xk+6Pl0qXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LJG6ge+sxaoQOokliAV/M4mbEj0DyQrb+A1UnJUG6Rw=;
 b=PZhwUC6KDeKKlhWLNxNgwEP6jUilLusyCk6rrbGKOWy1jdhe68VXb75t9NRQ8+VX0SF4Bvr6lPLy3IKH85UsdaKq9v8rSEJ7HC8BfTX79dhPWcCfK2b/bVP2UmnJXUt5GrIlbBWPRyXn1dbTWurYcIZ9CsfOZmXLqYCWYVPh7f/BfQOenwyPorU83QvgSV+HZCzOGV3BbR/vh3D7fdJ52bED6IbZWTm+QkPdEvWkFcQImhPbHjDiIbthp4u8cqcTOftk/kRGLjoRMN1p/4VkgoV/pSKv9QHClWOiHSdVIPp/APEnSmpjMyksfvGlR/q9IE+Re7+QAZQ7sIVSj5RIdQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by MW6PR12MB8949.namprd12.prod.outlook.com (2603:10b6:303:248::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.38; Mon, 4 Mar
 2024 23:44:21 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c33c:18db:c570:33b3]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c33c:18db:c570:33b3%5]) with mapi id 15.20.7339.035; Mon, 4 Mar 2024
 23:44:21 +0000
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
Subject: [PATCH v5 27/27] iommu/arm-smmu-v3: Allow setting a S1 domain to a PASID
Date: Mon,  4 Mar 2024 19:44:15 -0400
Message-ID: <27-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR1501CA0030.namprd15.prod.outlook.com
 (2603:10b6:207:17::43) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|MW6PR12MB8949:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f1b9904-46d0-4977-2b97-08dc3ca50133
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	N4LecfmD1ss1+MciqoHiZ5H/clLeuG2z/glHU96vqqM6TqUSF2J4t6kQnJ5KyWgFvRmeSzLRntZ3L6b6qn62IgwCTlkh5D/cZANXtCQ05TccDmtFxWPZpNeH4cZmY4A5eoDTMLEB3L6Kukpjtrfh855uH90fSLQyxU2eaFZE1qJvPV/4YTwwcBDAclvmlgsu5qlaujDyjTEewET2ke+V0mPz1mavSY1Nhj52cxqlMHwgnFGfJzRl5IkdQmHpjyClfcpAfg1e+d5oiwf33aXcdgUWZKlN7PQZalvLHdGP5FQDzfaCJq/KdVif++Zfil6odolPNUhberoM5IH85y4VbJ4rcJ+j70PdL8FaCBAVjT65TXOuZEX/a9d1bZ9hpGg4ieR2ctL+lYBOArxonTKgZKh8RceU9lqjQ60B1wMriD1xXSRXjrh5sphCTyzafzTqe7pDSKgQbjQFb2q85AAsC+iRGZBVqBmnMrzdGs9MUBwn2MVxDrv0AuOI292NuD73wOk20jTuzAx/dO6TdQosxn0HVN1sb/cy9loXtBKsCL30W2Bt9M/TP1Plu0wiVuKJBLDWVjeT+ZgoZDTTRh2srOpJMmcsb8CdlBCO3WPZMXKViTyXOzHJYPdpGL/N19nzfxHpoodqfPrCt0nRmqM9P+8iERahOvztJyUHatFN1SA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XAAUT6DXdopVWFhS7x3Bh5aQ3k279BgU++nvEEsRHJyzX/ufKD40DVUIjaH1?=
 =?us-ascii?Q?ROBl/YLSh9Z6d3ZzCqB9GDAXsnMKp+9/AKtlCt1/JKsudDoK+cEqy9Jg/xN+?=
 =?us-ascii?Q?xxyeTgbei9uTC9yJdIclz/UFcfbECvf+FJdrDCknwStgyDI97papS1LwqX/a?=
 =?us-ascii?Q?TRHLWHysCiMA6uhWtFBzW2koUGf4NHg2WOE+Xvx/GYfdruMTK7bKDjgJMcNI?=
 =?us-ascii?Q?tq8ZTZbCmxgxzixJiZup2xte/w8SA/xiMGx8YMUMnHcdnTq4cJ576AHPPZ5l?=
 =?us-ascii?Q?Y+Hp5wC1dS3qmOvw5YI8wdXnEFiEpOAdMnOTtVP0ZMaOu+SNXlL19qNQly0f?=
 =?us-ascii?Q?N3JtRtZ+KNNPtL8+nPDP9wmv8XzCT5DG6RUFmJQIr5Ze5LlWGKdzCyOzz0y8?=
 =?us-ascii?Q?x03IjpT4H/lz79CfMWFI/unUzE7mO7d3MxCXkWMghoFteCea02US+GIQb8Gr?=
 =?us-ascii?Q?plbfdICTwqUYJhKTVEDzgZwiRd9gmL0OQow5l45E4LD1tVXODyu8bv8REenR?=
 =?us-ascii?Q?mB0D5sUlabUwnB/N3Eg5yY9L+raTezbsXoO6aB/JQgd4wFhPv1cQewcH+2j/?=
 =?us-ascii?Q?Gep9MvsDkqRxs5e5g+mSbRsFVK0lL2UKDpVBt1O0CitBQzkSBbKfxokS6fds?=
 =?us-ascii?Q?3T3oau7+lTxkyn+MvhZ7A9QeVYTRHXvlezNDn493oRn69ge3mVjYXv8KGpQw?=
 =?us-ascii?Q?HDaOQYWXrZzsW5W3pmqvB9jjPf3KTRt+0FLMR4CSVzc6xQJ0m3WoDOPtZgDb?=
 =?us-ascii?Q?pY4L5W/+TEHLgFDeFGbP1RBgYANMD0P/8OhT26h9pfUZIFLfDSweO2PfePOB?=
 =?us-ascii?Q?kcUzyWMvir9/EBRL0qG4F/K/3F1e7m2Vf2IXilFY3dvkplbg2j8iFuuNQIQi?=
 =?us-ascii?Q?P6+V6LAP0UHlzA9VrAzrFgNrdELZp+wjrPsQeCRlKMog7DTjNqDrcrFm3Age?=
 =?us-ascii?Q?PZt+dxFWgoXSl/gQH2BCOhNetmQXg4kxMpvX5utT0+CgJjTF1i3QN8k7NDns?=
 =?us-ascii?Q?PMwlcDJLcE1R2petsQVnlrmjSxUYQpEqkuzcPRnbJwllo3gpsxyW0fXqiE8P?=
 =?us-ascii?Q?HlSmrwyhzU0h/kQ7CmiOXs9UID4yE9IBWnCy6Sod57SHc6TN9OYDsq+WN5Uc?=
 =?us-ascii?Q?npKtA5uxjJsw7AezmZ2VN0C2qhebAQx5WB1KiruGLFlaoPjqqTKrTsns+BJQ?=
 =?us-ascii?Q?62so+Z9XisyLuqs29sQFs4MlJ6vxoi7OQzLS/XFFtfXyhBH84Uolj3uxWyBt?=
 =?us-ascii?Q?qm2myfkt/XJ4Fo8Ftsi0s4rk50lrI5SRoxNyG93VmqUk7x3HyRUesHVTwpQZ?=
 =?us-ascii?Q?9QAuEfdJ2GC9sHQCs627Ks1AOKqL6yQiXHUMxPTzk8KE2AZuuOtoKCiB4vGh?=
 =?us-ascii?Q?DDqXl4hsXhlXQdHUYcYhJWkIpm+nlG6QByFYBZmTzHBIAg/732zz6Gol5RfP?=
 =?us-ascii?Q?DcDJeteFCt+Ay0m6wxH5TTMqzbC4kaq0ba2tPakkJeRjwvJp+DsST3ufz7oG?=
 =?us-ascii?Q?3QJmqkSu1j+H3492Rhd/09/oRBYk90mF1fenC9pSlLMCnGh5vUAaN+iZ3uLG?=
 =?us-ascii?Q?zF+WQo9P7jRPP+wc19fzc2MxUST9ldVyBjc3Hh8B?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f1b9904-46d0-4977-2b97-08dc3ca50133
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2024 23:44:16.8572
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E7f+9W5OJ5++vBX9IXzVIDr/lLK218trRvtkpP29wfXjnHjD4E5jRbpT6yMi83g5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8949

The SVA cleanup made the SSID logic entirely general so all we need to do
is call it with the correct cd table entry for a S1 domain.

This is slightly tricky because of the ASID and how the locking works, the
simple fix is to just update the ASID once we get the right locks.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 45 +++++++++++++++++++--
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  2 +-
 2 files changed, 42 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 535b28d13da5c4..5788998025c89d 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1322,8 +1322,6 @@ void arm_smmu_make_s1_cd(struct arm_smmu_cd *target,
 	typeof(&pgtbl_cfg->arm_lpae_s1_cfg.tcr) tcr =
 		&pgtbl_cfg->arm_lpae_s1_cfg.tcr;
 
-	lockdep_assert_held(&master->smmu->asid_lock);
-
 	memset(target, 0, sizeof(*target));
 
 	target->data[0] = cpu_to_le64(
@@ -2791,6 +2789,36 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
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
@@ -2818,7 +2846,7 @@ static void arm_smmu_update_ste(struct arm_smmu_master *master,
 
 int arm_smmu_set_pasid(struct arm_smmu_master *master,
 		       struct arm_smmu_domain *smmu_domain, ioasid_t pasid,
-		       const struct arm_smmu_cd *cd)
+		       struct arm_smmu_cd *cd)
 {
 	struct iommu_domain *sid_domain = iommu_get_domain_for_dev(master->dev);
 	struct attach_state state = {.ssid = pasid};
@@ -2842,6 +2870,14 @@ int arm_smmu_set_pasid(struct arm_smmu_master *master,
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
 
@@ -2859,7 +2895,7 @@ static void arm_smmu_remove_dev_pasid(struct device *dev, ioasid_t pasid)
 	struct iommu_domain *domain;
 	bool last_ssid = master->cd_table.used_ssids == 1;
 
-	domain = iommu_get_domain_for_dev_pasid(dev, pasid, IOMMU_DOMAIN_SVA);
+	domain = iommu_get_domain_for_dev_pasid(dev, pasid, 0);
 	if (WARN_ON(IS_ERR(domain)) || !domain)
 		return;
 
@@ -3365,6 +3401,7 @@ static struct iommu_ops arm_smmu_ops = {
 	.owner			= THIS_MODULE,
 	.default_domain_ops = &(const struct iommu_domain_ops) {
 		.attach_dev		= arm_smmu_attach_dev,
+		.set_dev_pasid		= arm_smmu_s1_set_dev_pasid,
 		.map_pages		= arm_smmu_map_pages,
 		.unmap_pages		= arm_smmu_unmap_pages,
 		.flush_iotlb_all	= arm_smmu_flush_iotlb_all,
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 92bff64eef644b..1acafd5c494971 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -771,7 +771,7 @@ void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
 
 int arm_smmu_set_pasid(struct arm_smmu_master *master,
 		       struct arm_smmu_domain *smmu_domain, ioasid_t pasid,
-		       const struct arm_smmu_cd *cd);
+		       struct arm_smmu_cd *cd);
 void arm_smmu_remove_pasid(struct arm_smmu_master *master,
 			   struct arm_smmu_domain *smmu_domain, ioasid_t pasid);
 
-- 
2.43.2

