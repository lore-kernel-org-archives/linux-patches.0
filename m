Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2052.outbound.protection.outlook.com [40.107.93.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BD22131BCF;
	Wed, 27 Mar 2024 18:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711562907; cv=fail; b=RrUhZOS4sBkSP04YSAt1jVDwSofJ8MDRfAnEpAvGd/i/AQ5p7TesiVal1ZKRWIb0Of3Y+nNDITZqFweNDc4FalgAstcWNkAuy7wwy4OiS5i/FcTE2EceIsfsbBT8AncAPjdgF37JJn8OunSotYqjaGvb69W4SGTqQz+X+z/Mxx8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711562907; c=relaxed/simple;
	bh=sCsLybP65WiURtCGfNa6t1H0H1Ytugy5A2cOnRtczeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sFZKPw2M0bZDrMiLCgM1NEe6gwLkcaxMSmkofGQMWYGAzxEDmI985cnfwrLlQiX96K+mkwuOWx+jYgZPJPVWmo7NksFpEQjtHxur4XIwnV+ELV3+Ao36wBmC9iUeWwVHOTx+6/vVY8ex5C6oPJ3nXufEtLHgnhXPeSN17K11ODU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=K62c3gjl; arc=fail smtp.client-ip=40.107.93.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="K62c3gjl"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ScLtmvoskazURKW2S2d8JCMwxjS5yBzmkICCGVU4KiXbBHJcCD0sTZDNiRxj2mFcq3eD5IzkeYuu1HfrixRhDFyc/1gM7QH+GN68R1osKzybfmGN+m3EeT1eDskx2Oo2r+5Sc0FjaBrGFb3+7E27hZ9Yn8cRy1lnYa3uaU/pfJBvAspAknq21/wacfAZblXYcrBKuqMmcjDoEN++HwaB8XQK2E5YsutbITKkloYLsg+hjiYcU5tA9fAbvu4ZzbTNBig7mU0TT74xlR/zWbeRHld/Q7xqnlevRu7b/2q9OUFDzGX9jFoWhRBPmYDCUbJyMw3nRDmusvCHsVqs2Har7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ha5ibzzndNSjw2W4R5NZXWHSoUPZ4A4iPkuxRpGnbE8=;
 b=AJ7uYGsmHs5yvrj7HUBnwYqyr2g6ZgxjSC7Ypr2GNZ6d014HxJHEfQ5g8PNLF6iMWF/skG8wnCOkQaX/Opa5+AlNYX62nLOmRgfjgB4TTs//5Brj19VsrD92GCBjcqt9ONOKCuPNsyF/uq6BeVUrz95jgabRt7XSYfWmobCCXseEv+p0N3xpQ1IAwYpkxlF+a2sfiois0uXfqiY5nr/w7ke4oKtl+P37bE7qd3hoqjf/7LSFZtcCuPtg8Xm58lWmi3VCWpj4A7gbPipwoCvAZ1qaJN5ryjO1jDk6v0GMkLUU5tYi3OkRHYh5mIUEGQjClqoi0atyP+w0BjZfygcqZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ha5ibzzndNSjw2W4R5NZXWHSoUPZ4A4iPkuxRpGnbE8=;
 b=K62c3gjlj30narVNHOp/MplPIiXILx7XwfRa4B2X4BR2FY07M28ZBBvquBjDHU6Jct90WTGEFkwAEMl8RGxhy08t9qWVOv3FeO1XnIw/g/HF8AVX5zW8Qty/tYI4M787M28Hhx0Aw/Dsj0mrjJyFb8LYv6Nx6YRy784XEBNNpsvzY4glOQRKulcljtJH3OgQ25huxPnl6l4uLWBAt6sb/WYsE5n2vID63SXhlXVqhsJwPBSGQUNZC7qQ3+5PUTfp/La1dsXVdWA8MTis3FI3aIhHb8sIWMqOt2kvz1ZusNInLsM2bLpvJHEM/z4K8hmmMJ+Axy4UzIIpd2Gj6W7eVg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by CH0PR12MB8487.namprd12.prod.outlook.com (2603:10b6:610:18c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.32; Wed, 27 Mar
 2024 18:08:19 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 18:08:19 +0000
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
Subject: [PATCH v6 09/29] iommu/arm-smmu-v3: Consolidate clearing a CD table entry
Date: Wed, 27 Mar 2024 15:07:55 -0300
Message-ID: <9-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR20CA0010.namprd20.prod.outlook.com
 (2603:10b6:208:e8::23) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|CH0PR12MB8487:EE_
X-MS-Office365-Filtering-Correlation-Id: 28991e9a-530d-4184-57c6-08dc4e88e0db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	nEAGw/6ZMvsjmrqXPwLM6f9j8TCKXb4QsrjDkyCvG4mPf2ptSk6nfTub70zerccrwDftQhCHIl/PmZ8ZkQOTadMRtZJBEs//Ub3P95MgMqqpEMJUNnCem43NRFvq2kHf258kfl1B+NZap01RAAhwxQToUzCYbJ4Jawu7F193TKUZp/e/VWx10zvaX8R1AGmmicpC5hRQMatDai1b/ip2RnSBB9ShUI+FvBrUzr8JBr4KHvNJcvX+lJMezGNWj7yzhTAlKMMtUAq6QAw6Tw2fJ7Fs/P7lCfkFVy6BgiOxCwmONOfUJiFbFY7D4nt6m7QudVNgUlcrjHgfR/L6aJe3SgrtclkO/S4rVkPgc7PSC2qQn+elkFZt6HH94yj0gC8Mn3K9Zn8cpCjajCup4zRQjliUmsa2Sc71AXc/8TanJ0PTPNOKh/HBmCkXipaHZsIb5diVPkw+T3NQ+oPoAxd8Li+mKI44/GumhC0mc5vKI9Aliv19kKNI0tqx65Fu6q7S4EPLv+vGd1/sSghdddTkaDIhuhJSIxj3/yJx8hr/R0Nk4Yxz858Fn63en6rYwNpfnsKcKJPr6fhfYYyHI6MfuQ4DFoRpMDBHsFm4vAXZwXqUvkK0qi11MyfJgU/K3P7OKszPCBQ3SGaqgitT3zRLsLNk2VfxJl/J7MIXWTFSaHw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2ZFpQuy3utEgdLVcEcQvNbu2Hw6OKcLlZjHFx3AeLytcu/y0qv9qjk6Iotvd?=
 =?us-ascii?Q?M+JX0ofzeXXcJknuohQVIwnuFNQyIPrPJ1WytnqN30EC1AqxVuC4G1LxyBwD?=
 =?us-ascii?Q?pER9NSm+O/i4c4bLsfYahfwOHHIW5YRfPURqHfQabyvlTZKjY2lKV0Xc7D8N?=
 =?us-ascii?Q?2GQlgpp8XILNhgP2FnWDAzmxngdE4Hj+4+MJUBu4s9/Hpl+zHznqjijBQkpK?=
 =?us-ascii?Q?FGdDWt1/NtXl+5K3g4Lg+gWNhHUD6jew+AFgJsUcRlqEWrK4ZbqwA9JPXbqD?=
 =?us-ascii?Q?JGA/L6N21CB+xcrifHIleYHLhFiT/Q4etNKDgxEsQ8JnwquBAbEKp3HVhoO7?=
 =?us-ascii?Q?jVaG4CA57+px5GPssJTdrw5Ii2yt+PzsGi1C+WknDUJavMdnrUdTSFGaN2eM?=
 =?us-ascii?Q?d8XM3k7OJ+hsyUKYOrt21v/lugtozdUpWQ1tM5H5dS9uS5a7hpB0bKKbwOB/?=
 =?us-ascii?Q?ZOfxK/gVeyMpLpMz7tx7OfmJjrobKYulBHswFhdjTrff9nOFemqdwC31JLww?=
 =?us-ascii?Q?N8G6ffVl3uaoNLYmOhLWm2ETnolMuqCjEcIRoBpWC5qHfWfuR05SWNTmNzcI?=
 =?us-ascii?Q?LC5SZyDXBf3rL5zMIoTu0nmbdeEjCcGCLkirD/9aug7/83abEGmLAJUc3Br9?=
 =?us-ascii?Q?diLPPfRfzQQB0u3cDJR5SzeMXw8Q+mfsxBgNTlE2ozzMezf4Mx6PyoSG+Uup?=
 =?us-ascii?Q?AD5AzkufnSoX2e85oW+ecRqQv2BYAZ76qTzSPXiZ+N67UPaF7xzTyBSFsN9g?=
 =?us-ascii?Q?QdEW4/rCWPRkPxHZTmMB6HnEn+Jt2uSnPA1C0wgKtJfsRs4N23fqX9jIN6O4?=
 =?us-ascii?Q?pktFEIXT2Tv/KYuOUJ25iHbGOr9Vt57Tc6NLeay31387MY9E2X3bSjfJQixV?=
 =?us-ascii?Q?Cgl4q1R98Bto/LLs/NQsOLR3CdrM4R+FIWxEyhCDHgSasBJwqdG/zyed/nYV?=
 =?us-ascii?Q?FoHvaVOxBOPwGc1m+ROr5UVBGGcAbnTltyNCbKa9JpGpB8QoDCDYaf70PG1l?=
 =?us-ascii?Q?3JLsozSJlaW+U9WCHAoOaHrfLpw01Vw0RjdoZEsGCq3A5enmTIYjmDXjGWOE?=
 =?us-ascii?Q?AnFM0zxnNxWLVb8NP0+S/voQgY3gLIIaaEfN4XcmKf7diw637up/bG08nnl2?=
 =?us-ascii?Q?1KdRP1vNe3qotZRuKKwdfynkQRLj6HocaWLutHOdU05/jkVVf/pRqAxpRO2u?=
 =?us-ascii?Q?UrdPwEd4Nq1eSFfz7R3cfc9sLvWttV0Km+MhBZr45LH+gx0H6WXbSQKm7flH?=
 =?us-ascii?Q?ullMTZN81m26PBTdiS5WU4n4oxmQFhoPqMxsqvc5F8yKS9/+EY08JKWBELpN?=
 =?us-ascii?Q?WRe7FpHOuPIEJB4x41KDj6n35UwXKusHLc0sy310pDJlqdLnD909M5PrXWOB?=
 =?us-ascii?Q?92ocj2UX2SBP7MvvaJGZDLAsweOtXn8VjpyaKrUTKvhAILhck/I4zur6iL27?=
 =?us-ascii?Q?IFbUIOY+r6kiQw0V2u2V70bv2jSm1T3UAqoNLbeZC4Doj3QbI6FTjv0L4B2c?=
 =?us-ascii?Q?UO+zSrGNWc7CFVTcTDUZLKNWfmW6rvf9PBq9BZfkUytxOiENpN1R1Vcmj3WD?=
 =?us-ascii?Q?sXNdKcHin/6/K3YIko0Sz1ExwOPFj0I5a4krYAbY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28991e9a-530d-4184-57c6-08dc4e88e0db
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 18:08:17.5958
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g4GosL3pEHEhbo1vJ16ykvNDUmdIB6F9RzwPnQ7deA5009KvJpwwhMuKX5uThsBr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8487

A cleared entry is all 0's. Make arm_smmu_clear_cd() do this sequence.

If we are clearing an entry and for some reason it is not already
allocated in the CD table then something has gone wrong.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Reviewed-by: Michael Shavit <mshavit@google.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Moritz Fischer <moritzf@google.com>
Reviewed-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |  2 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 20 ++++++++++++++-----
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  1 +
 3 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index d159f60480935e..7cf286f7a009fb 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -569,7 +569,7 @@ void arm_smmu_sva_remove_dev_pasid(struct iommu_domain *domain,
 
 	mutex_lock(&sva_lock);
 
-	arm_smmu_write_ctx_desc(master, id, NULL);
+	arm_smmu_clear_cd(master, id);
 
 	list_for_each_entry(t, &master->bonds, list) {
 		if (t->mm == mm) {
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index fd1d4d774a7cf2..54571f2a4acd5b 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1314,6 +1314,19 @@ void arm_smmu_make_s1_cd(struct arm_smmu_cd *target,
 	target->data[3] = cpu_to_le64(cd->mair);
 }
 
+void arm_smmu_clear_cd(struct arm_smmu_master *master, ioasid_t ssid)
+{
+	struct arm_smmu_cd target = {};
+	struct arm_smmu_cd *cdptr;
+
+	if (!master->cd_table.cdtab)
+		return;
+	cdptr = arm_smmu_get_cd_ptr(master, ssid);
+	if (WARN_ON(!cdptr))
+		return;
+	arm_smmu_write_cd_entry(master, ssid, cdptr, &target);
+}
+
 static void arm_smmu_clean_cd_entry(struct arm_smmu_cd *target)
 {
 	struct arm_smmu_cd used = {};
@@ -2698,9 +2711,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	case ARM_SMMU_DOMAIN_S2:
 		arm_smmu_make_s2_domain_ste(&target, master, smmu_domain);
 		arm_smmu_install_ste_for_dev(master, &target);
-		if (master->cd_table.cdtab)
-			arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID,
-						      NULL);
+		arm_smmu_clear_cd(master, IOMMU_NO_PASID);
 		break;
 	}
 
@@ -2748,8 +2759,7 @@ static int arm_smmu_attach_dev_ste(struct device *dev,
 	 * arm_smmu_domain->devices to avoid races updating the same context
 	 * descriptor from arm_smmu_share_asid().
 	 */
-	if (master->cd_table.cdtab)
-		arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID, NULL);
+	arm_smmu_clear_cd(master, IOMMU_NO_PASID);
 	return 0;
 }
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 919f9f717bd3b2..d32da11058aab6 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -749,6 +749,7 @@ extern struct xarray arm_smmu_asid_xa;
 extern struct mutex arm_smmu_asid_lock;
 extern struct arm_smmu_ctx_desc quiet_cd;
 
+void arm_smmu_clear_cd(struct arm_smmu_master *master, ioasid_t ssid);
 struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
 					u32 ssid);
 void arm_smmu_make_s1_cd(struct arm_smmu_cd *target,
-- 
2.43.2

