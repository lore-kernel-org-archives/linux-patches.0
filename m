Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2087.outbound.protection.outlook.com [40.107.93.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC51814EC46;
	Wed, 27 Mar 2024 18:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711562925; cv=fail; b=Q0B7S/ouRtw1vfP2VZ95faMyk33hBkYPaxruJJZEeZEBitcJzgZaNROQHWfsSFLSlSitxIaRRLQ+L6T6YIs32BDn57iS84Qm1x34t4uz2x4GjED7ZDMSLx+m6/M1ephulNLIiifwCwvLKyXUE8KpExsojvNfl2/aCe0cHxavHqA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711562925; c=relaxed/simple;
	bh=eAmlTrodYJKwMUaGgj5dklYImYuiD+tTL0IlU0ogXKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=olB+pZntYmGGm/Re3BEbvuBif14NozGxf/xVL17GP03U8LEXSwHr+iC6Lpai9zO75O4IDf0pCvyfwwCrZGzP/GtE16AxG5pg6UtarybtGIyKNYtzKHwHv8C1AmJoyLNWz5O8iCihxL0MDhEAqxMbliD41jLc4hFy4VBsKK/v0Cc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=stxiZhvP; arc=fail smtp.client-ip=40.107.93.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="stxiZhvP"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EJdIqfP1KPzr0zOVmxS6mxQ9ymq71lwRvhXBoGJYjp15lh3/OVNf9GntFf5kLMt/rqc5iOhdgW6YX+7tpTDtDHQcEAde+zip3zmwpomIySjlbqFsmgctpdmkLYixWVnG81IYua2MFgY2vdPsvQH/5WlrxmYqWDRAm1p8NSDoHGVeMlLCYz1GkRj08lY6O5pu4tJEZzO9T5+aYtbRQMs/UVb5qIYc15keVSxDQdVRb7g2Q5y5FL86sqikwYV0/HMz6u1vJibssVphSusZzmQR7UMbSXu9dsmG7Oy1G5evwuskfkCZyU5XwsbhaLPC5JM4ONVCBhjQYhGVOthB7+H1ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RfDowk3NmvxOw4FdVo6SbySPfzW2QPXgwjAU/zIKZGU=;
 b=JdJYEeedqnzfq8ZKIDeeBZiDlTkM3ognTfC0eQsJG7X4Dme0pwImiSbc+8mvU7rVjeaIZPZ3pCYqtM7jRVnlSAvcz3RH+PJJ+uGEZE0nlnpS6g0wJY3byDJdkm0l/FVh2hUflxxNIPlP/nYaJXuKZHWJniabyAwBqarUHj2ipWEBUCmbi2anvvAn0ShdkZfT+LU6prF3jHH10Cxt+i0Z7aIbALBJMpUe3frQ/KyEJ7vSOb3O3XApB9veW7rYcacgqwWAEUwPjONxUBvUwjCt3+bY/43WEec2PdD87Lktfeej7EeIqDKLGrM7u/PoDwBRbTB2qh4rWrhTGZk/F8ESFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RfDowk3NmvxOw4FdVo6SbySPfzW2QPXgwjAU/zIKZGU=;
 b=stxiZhvPzd5ouQ/XrR0+3B6u1SdADTeuZZYd8kO4Nq4sK+LutGFrJS3pfbU4DgZ9qD8sE+ayMLbYJLIh8K6fFT/iDzJQvVTvqKqqzwRCNSErX2POMsmhpI9RsWoDhhTfs9/Z/1sehSIIyEDW3jIM86Fk8wlw6WdxRKkULJfnOmUzqoLCmW7fXdqIrbcuBeVI0F5nJrCVs1hImcz2II2c12UHSMexVZruh0Voivlw3lxkdnKBxDLfQr3emjSNhGmZFsmT8f0vn6i5IZEQ0/LeeyRMNVekj5qkPfaBDwXviDMTBnN/lLvPwQI9PKtfgrRvQmIBYrIu/nFpLATFEUza/Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by IA1PR12MB6044.namprd12.prod.outlook.com (2603:10b6:208:3d4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Wed, 27 Mar
 2024 18:08:33 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 18:08:33 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <jroedel@suse.de>,
	Kevin Tian <kevin.tian@intel.com>,
	kernel test robot <lkp@intel.com>,
	Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>,
	Tony Zhu <tony.zhu@intel.com>,
	Yi Liu <yi.l.liu@intel.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH v6 28/29] iommu/arm-smmu-v3: Allow a PASID to be set when RID is IDENTITY/BLOCKED
Date: Wed, 27 Mar 2024 15:08:14 -0300
Message-ID: <28-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0317.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::22) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|IA1PR12MB6044:EE_
X-MS-Office365-Filtering-Correlation-Id: 6737e32d-1934-4597-e5d7-08dc4e88e245
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	nutWMHUWVb5xtTYMpX3NvkG6KiKAL+ahJRigleqSFo5LMZBTPXPtfwBrrD2OK2Ss+JYGuphED44xAgYN+1JSxw4VniXWTXJ6L42KoKfX6p9fZ56XI6z5eQChGcxTD4cINvhFLjJr4Sfbo52UQEK0o5vxjCKtvt12vrsQpZKaEJTNWEHo1n9RW5Av1Xvrbd1GEpzGqwT7DqUCoepXNFea43qvk/3kTnk5660NUzTWVta0lYegWeytF1Sqj+v7jWQmowoqmyR/jyEwsXRyNnX2hBtIbfgaTX7mPJJ4ldozwjefgG9DYhD9u7AwsGJ2aOJPolSnCWBhMHS+JYmtCoqD3M8BW+IWgzAH54h7hkfu89cPdQ7ERgC0AczHk8pPu7x9PUASunXMbWOJu7WenOTruIfLcqDpBvPBcrRHT8DMQ7/MY6+1bUbAFuMcB3f4yzJKt1JpADshH330kiPb1c81wUxwzADRDhjlnAEJfN4928MsM4lpaVYZ+M5gxWe4vysYoPtUnkq+G9TxfxFJIKDiqZUpIHlZIMi6axtK/jaJHjU1KwObtSWIUbgvxCwaNDK97v2HYVPJXk6hSsCJJc19em+RliTlhEmOAcKe4KzUURIYaMkWaj5vie8sBy7xnmGok81vvH3er1pNiLz0+gu813T1uiC4EknRkoL7a/hnA1Y=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?crcQugL9sZl7yo1Th6TQYB9OrwQugxpN0l1+9xw/7KzZ2sMPpC2ldfQbcQw7?=
 =?us-ascii?Q?ufEb+/ioVB1SpkDFyjRMYpl2yS2kxF3+p1S225W7PkaNhCtFnopSY0XhIeut?=
 =?us-ascii?Q?BWbE/PY4BvRbiRrOkm+t+HQATrlvq/EdFC6H7Ab6euoRxWv0VTthkzw4FnyG?=
 =?us-ascii?Q?8hbdhrpocfGBzoh3MLPjocMEeQPgve6NmdwXR4+ynv02HKXGkf7FhLI5JKV6?=
 =?us-ascii?Q?7wICNwRtkmGsodU11kmw6zunpM+3Cp8d9UK+/toiAMgL69fB1Gq/Ewduldhd?=
 =?us-ascii?Q?Exq3bRF6ZpHCf+uFKHHhzZYiCH4jvGlQsS3tpZ9WSnVkwtc1sXiw1Wd7pXVw?=
 =?us-ascii?Q?rFVYUqsn6nipceJ4OmFiNOc3+2FYv9kHK45YEtfj4K3m5WNXVKww4iM/wVpm?=
 =?us-ascii?Q?KNPzen2Aov8umvhqovmui7LNPAo/Ovyllib9slmceBkCEmhmyRQ4ScMtH5aF?=
 =?us-ascii?Q?sd8ALnbYimjO/ClFDI1rGqhfAyRCcQAELdIHZFVhds8ZigRX336/tYEkYKXU?=
 =?us-ascii?Q?D+L3ja+z8gWN7AUvO1vTCDj2VG5XpkyG0f6yuYJdxq3ZMrwX2cDhK32DPsfH?=
 =?us-ascii?Q?s6Eqn/U8jMzu9hVIzIJEPuwZr+J6DdRRAhv2WtO7aFYbzt+TW+xWlOKKaC3y?=
 =?us-ascii?Q?Ys+tSv6IflJthjxr1q6JHzc1gcw2TeXtswFTgYWnW/MEWGJc+fJJWW3ThAkd?=
 =?us-ascii?Q?Qu4F8PwpePYnnE3DewLUR4UxKWgjWXMGJK5dCyDphcEvqcvRmFSRsDuwvuXq?=
 =?us-ascii?Q?fFAhh5x8dNdywgnv0BXGbiHzKLdYrsjxK/eYwzM946R+7oiuKR15uL1J3+WQ?=
 =?us-ascii?Q?1lAsGdhTUrdfQC7eyjmB6yIqEuxTgoSETvOwzRWYCKo8/eKE89oSPTKFMl1s?=
 =?us-ascii?Q?7iUl9/LIG1L+udBMHYZ+xyHge5Nd49Kfn3UAki0EsxcnwSS3c8aRu7kF8lA9?=
 =?us-ascii?Q?F5Zy/9pBTm1zuL3fF/ogr2Hr1xbxzGQuPQ7ehNnoxt9KgkCsvcFJArDvuSjF?=
 =?us-ascii?Q?uA9qLkKxitIIj6JaOLNhoIJtlKG24ZY5E3XsGgDhQWdaXPlLTMu5IymH16vd?=
 =?us-ascii?Q?clNC+aiCD52evF4ViyVvV1ByWkvxAJnjPHNrQ30xOS5rDKQjwPXFM29V5cJW?=
 =?us-ascii?Q?pFRHmxdsCxvZGd9Am/ysYurV3BnCUCw72QN80mV8wz8W5VBXxESbheJOJPN3?=
 =?us-ascii?Q?OmHUZGlUoteuvUmLCWp1FSzJQEUt8YGhth3S4jJUJSeBjYb6oZR7jfuZ3aJ/?=
 =?us-ascii?Q?hWciMHTs7UffNUP6XIOQjHQ+gBscMrrcV32rC6+J0jXuJpDHZeFufSoTjb8m?=
 =?us-ascii?Q?zh7HAgWYa5R6rWpMT834DP/aIOiG4hMRnAWK9JNpCd1nyO6DpeQAWmbKbtRH?=
 =?us-ascii?Q?4T7jAQd+ouH/fLhfWlSLTnmm2tEKURttOeNKdhMxAJ8LMKcPaRquotGbEJXz?=
 =?us-ascii?Q?wi2InEpbSltzjC+mDG/OBm4tl3xIWNBJt8DTxAc+79B7BL3hw2iWeVuyVtZq?=
 =?us-ascii?Q?JESjtLolzZWfdT/+LnqqbgH6qyoeKhh1yS26Exg8Vv2CEPtI90YbjI7RMa4x?=
 =?us-ascii?Q?kCujpx+BZzFVA6rqZ5Zu99+RNdSpqgJigeDIO3dR?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6737e32d-1934-4597-e5d7-08dc4e88e245
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 18:08:19.9479
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o6BrWyifMEyllIBtEchuTbZsi9sHmE4Vg2NNMXKcOLaqpShNEiswdQsVoTnHb5xb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6044

If the STE doesn't point to the CD table we can upgrade it by
reprogramming the STE with the appropriate S1DSS. We may also need to turn
on ATS at the same time.

Keep track if the installed STE is pointing at the cd_table and the ATS
state to trigger this path.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 49 ++++++++++++++++++++-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  3 +-
 2 files changed, 49 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 69b628c4aaacdf..f87525225c8a50 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2432,6 +2432,9 @@ static void arm_smmu_install_ste_for_dev(struct arm_smmu_master *master,
 	master->cd_table.in_ste =
 		FIELD_GET(STRTAB_STE_0_CFG, le64_to_cpu(target->data[0])) ==
 		STRTAB_STE_0_CFG_S1_TRANS;
+	master->ste_ats_enabled =
+		FIELD_GET(STRTAB_STE_1_EATS, le64_to_cpu(target->data[1])) ==
+		STRTAB_STE_1_EATS_TRANS;
 
 	for (i = 0; i < master->num_streams; ++i) {
 		u32 sid = master->streams[i].id;
@@ -2762,10 +2765,36 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
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
+	arm_smmu_make_cdtable_ste(&ste, master, want_ats, s1dss);
+	arm_smmu_install_ste_for_dev(master, &ste);
+}
+
 int arm_smmu_set_pasid(struct arm_smmu_master *master,
 		       struct arm_smmu_domain *smmu_domain, ioasid_t pasid,
 		       const struct arm_smmu_cd *cd)
 {
+	struct iommu_domain *sid_domain = iommu_get_domain_for_dev(master->dev);
 	struct attach_state state = {
 		/*
 		 * For now the core code prevents calling this when a domain is
@@ -2781,8 +2810,10 @@ int arm_smmu_set_pasid(struct arm_smmu_master *master,
 	if (smmu_domain->smmu != master->smmu)
 		return -EINVAL;
 
-	if (!master->cd_table.in_ste)
-		return -ENODEV;
+	if (!master->cd_table.in_ste &&
+	    sid_domain->type != IOMMU_DOMAIN_IDENTITY &&
+	    sid_domain->type != IOMMU_DOMAIN_BLOCKED)
+		return -EINVAL;
 
 	cdptr = arm_smmu_alloc_cd_ptr(master, pasid);
 	if (!cdptr)
@@ -2794,6 +2825,7 @@ int arm_smmu_set_pasid(struct arm_smmu_master *master,
 		goto out_unlock;
 
 	arm_smmu_write_cd_entry(master, pasid, cdptr, cd);
+	arm_smmu_update_ste(master, sid_domain, state.want_ats);
 
 	arm_smmu_attach_commit(master, &state);
 
@@ -2820,6 +2852,19 @@ static void arm_smmu_remove_dev_pasid(struct device *dev, ioasid_t pasid)
 		arm_smmu_atc_inv_master(master, pasid);
 	arm_smmu_remove_master_domain(master, &smmu_domain->domain, pasid);
 	mutex_unlock(&master->smmu->asid_lock);
+
+	/*
+	 * When the last user of the CD table goes away downgrade the STE back
+	 * to a non-cd_table one.
+	 */
+	if (!arm_smmu_ssids_in_use(&master->cd_table)) {
+		struct iommu_domain *sid_domain =
+			iommu_get_domain_for_dev(master->dev);
+
+		if (domain->type == IOMMU_DOMAIN_IDENTITY ||
+		    domain->type == IOMMU_DOMAIN_BLOCKED)
+			sid_domain->ops->attach_dev(sid_domain, dev);
+	}
 }
 
 static void arm_smmu_attach_dev_ste(struct iommu_domain *domain,
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 12eabafbb70c9c..853cd17d06e671 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -706,7 +706,8 @@ struct arm_smmu_master {
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
2.43.2

