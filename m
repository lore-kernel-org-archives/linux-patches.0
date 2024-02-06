Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2050.outbound.protection.outlook.com [40.107.237.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72A29131E56;
	Tue,  6 Feb 2024 15:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707232393; cv=fail; b=my2A7Zeeo5ZfXx4DbW2Sd9MD0lrlz24FKDa/w4PKU+ukevwbXKu1NY9qIsIE7nUrqVLZMG5Kdde2TUVw4glJZv5Y45RPLuJnGulOL8izb/AoblwcejBs1xvsxp11ryXJzb92pxJD45mZEe2k0gb1zO0YkrS91h19I+e87upw2UE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707232393; c=relaxed/simple;
	bh=O89l1xFYoXzHmo4EjTV3ub7wctxTKGNSnLkJvtwVUl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=b2YFAX8WOfwY/3BJ6HILM+I4SI9ixhiVW0Rf8Xq+29D1gH/tN5sNZxQbGT5oHWCNgbG8hKYvC9lw7nvkiz3QZ3cpguIfBDUeU4pfsvi1ZS2B49ksuGCfJAaS+w1rzDLjG+/gxIOIZhvqJUUicu+R2AnN6rSlMCp82nUGEmMdIFs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=UsCST/33; arc=fail smtp.client-ip=40.107.237.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="UsCST/33"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ii7rBI9JZiFn/eVJQx9I9EKmYmM+U72sEdt9nMm8DWSlqxmT4Fq/SzIbzwh9f7VCrxdX88renDPUWmrgeSXRStQQr0vBHUQ/OFdFvT37fWdeD0zlrzP4412fYxp1LcalugP2SMSABCsWOBEm8nzn95kklBUNknepXG+CjDQVI4JWkht3f0djMpzwhyVXPtahe3lnwYEb+vM8RFy7rQC6DrYBtz4OcJ7akQCBgJIzxomN/tKiUieLPovxHFHVHdH8viyLzueXQIRoGuJr/zodSvtF0MhidQNFxF/4/XHN23O17MyKCmnscxrU+IBkcgTd3As4mfYh/m8xiPh0E4xNWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qBx3y/XF/XyoM6h0gRPZSbM2AT00TTHUiueO5GMraww=;
 b=K+WZsEdT0/5Di/gM1oGvaUGwD414Q3oz9no0FFx4TaoGgJEh/8OhwHI8WkbQnfeT3uM6sUc9a+KgOXZEmh5kkUni4GndKdOOcRIVvH3d00DZUhQatk95WTopAXaGB0mOz/mQBxhoBkiMRZ7tyF9XU5ZJpV5slHnwOPvG86oMbSfgZEtSADBX9OiqarAd3N7I4F1AcoE7yw/vNqMpTECQRFTn6WkTmX97/7GMi0xML9G1/35ERbcakR6GYMhSlq5b4O2SS+/JZm/Qp633eOoa+82X3pxmazC7ODA3Cc1+n13UcKzRHV9KFC18bsm3VJRqfMg03hBN2F3JitZD/SsS5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qBx3y/XF/XyoM6h0gRPZSbM2AT00TTHUiueO5GMraww=;
 b=UsCST/33kvO7vfXVtUbhxM+wdaB3ec3uQabtHxFSxWJY9X5V/XNpYm2BB6hY2RlKTu39QaO3k1NmZQZz8WscOFU7ituUh5ZLdgkyYFSbNmuDIAgSdgokD7vo0NE/0DLcfhf7c8dT1ms3CYPw6ha+8cG65Mp0RJ3nayejyvjKyeYyuxjBsbdtEK4gVGpKWimjkKD25UC+qKDf4G7lHH+YcDOGsjqBtY5edD7WLmNMpHWV6cijkuW8yJJRrZWlj1ch1/oh74RPDpV2r3Nt+H9g5fOQ1SRezgXH8RbWmvFftNlhNmcg82WhCMiNzcrA1o642oI3m64pSVedO06YNoqB1A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ0PR12MB6733.namprd12.prod.outlook.com (2603:10b6:a03:477::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.16; Tue, 6 Feb
 2024 15:13:01 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7270.012; Tue, 6 Feb 2024
 15:13:01 +0000
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
Subject: [PATCH v5 12/17] iommu/arm-smmu-v3: Check that the RID domain is S1 in SVA
Date: Tue,  6 Feb 2024 11:12:49 -0400
Message-ID: <12-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
In-Reply-To: <0-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR15CA0055.namprd15.prod.outlook.com
 (2603:10b6:208:237::24) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ0PR12MB6733:EE_
X-MS-Office365-Filtering-Correlation-Id: 91cef892-e048-450d-73f5-08dc27261897
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	BTtGGSwfb8WUH9FmDvGWN8UH+8kT+mA7q5HOJi43CG5KQ/OvyZoBsl8nc0lLmLDKvZ9shCYIsJDJjpkrPMT9QlB/JFcEgSWuX2ZpYFCv9xhMbfIhp/m4FJq/1/7/cygM7e1JltiZRylRvJYU+U+s5Aa/3af2l0gV3sPNWDC3rV1P1hlhZJyBOL3rahpMSg6q6KZ+zgi/15K7KyLFoGqHflNEydbfyDdRWbiG0gAkLVv+sIxcqI9XG+ztGRQBvcsGxVI+cqc/8Cmr9JczaVza7c9Bbj5don+QMaQ/YJYiECKNL1bwxVVqtIicw5h/Ch8Zl1EbedQXtc1tnFnnE5DBhyogZcyamCOclczLjPB0b1VKoQVeDtqjo19G2KSI83HQ5mmqSKN6pAxsMNaCOL7cNOgeRx4NdV/IyEVIo4/4MnAdiBt3BSPM22b9LU4qDPiHUxkWKeVLDdYKbKV1Kuroa3ZAs0Ne+jDEEb89EvSpV8bkpZ8dpGsBNx3WORA54Zr/gOiifNXsjfwmIHQQZOMzxRxJg1Z3+TZHLYtwT2nIFwwMkpBIVBMgLeykwXalVZ86bLRjwdON2DeVIQnUlN0kqz6FRoJ5aiCu0hUHNFMtGHQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(39860400002)(366004)(376002)(396003)(136003)(230922051799003)(64100799003)(186009)(1800799012)(451199024)(54906003)(316002)(83380400001)(110136005)(38100700002)(2616005)(6506007)(6666004)(26005)(2906002)(7416002)(6512007)(6486002)(86362001)(5660300002)(966005)(478600001)(8676002)(66946007)(66556008)(4326008)(8936002)(36756003)(66476007)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JvCBl6mkDOzKFH6ZvaW1WEgttHoKI50tBf+x8S1KM2bF/v97M2JR09Qcxz5w?=
 =?us-ascii?Q?eOAJlNT9LJJPOXhvjB1EYTtsdBStjB+F66G0L0BvAQ3gEec9/8Vq243i3t1a?=
 =?us-ascii?Q?iet9orPoLB1vHsehHfR4ZxdqCPfvYtWsNbDXuwnhf2dG4RyTDldbXPvb9fQZ?=
 =?us-ascii?Q?0PCyZ0Z6PDupvADCT/V2qkP4N8J0wBVqRgZRI2ss+jDjWLtlUyzntXiFWxdq?=
 =?us-ascii?Q?jEd33ebWHjMT+QPnWMj64qMNh1MjCj2YPpVSh/dqATM+c0QcHFU809H6CAsM?=
 =?us-ascii?Q?W6soF6i9IIm2iVXae21c5eJaCRtlGpnz0cyc0M5SyKNkBwNplR6e68LfM+0y?=
 =?us-ascii?Q?usdJBHVfKh69VfBXycj18aqxayEm36s4DkE/fj0hkNVH1dWywHrwygKKnmbj?=
 =?us-ascii?Q?kFFM2Jeye/YTZylKUcakilJTCK8uEIWtTZsdgFEQ7sNMdcV3nsgwJjm1b8mp?=
 =?us-ascii?Q?IlNehYOr9uZ3az0JuEQ9DNpTkDcFtJulJne9PSvmBkGAiqfz2qysHPFN7+Ph?=
 =?us-ascii?Q?qiE3K81W3fIzbfZhtlsmle9GYVxsMt3bkg10GiZUY7deb0hmdz7bH+rS3/UK?=
 =?us-ascii?Q?fDrIXyNrQ8ShDJOzGSXPY6WOUez1fsT4MIj7Vb9nR3xXFWKef4QVxaJZBEzu?=
 =?us-ascii?Q?ucnK4xwlfd46ghU1hoe72P6eXw3IS7QmuSoaI1Vj7h9H2mHajQ7GAgOL+LBj?=
 =?us-ascii?Q?Jw9ad34X3CVx/4KlEAKhsQeIIeWlxH80sleyo4RPLfsKokqm/SrNeLhB4DYp?=
 =?us-ascii?Q?qlXrCb4Qf0THzWhqVZu7IH6M/K0YkrvKk275MTcqpwS08cTvCJKBvVAqXCRA?=
 =?us-ascii?Q?GZMUdoVJFHoDLlmgg2FvyEpFDlHU4YC04ZaGvWCxpI9tem8twiZKSqheZ7md?=
 =?us-ascii?Q?cIKFPHrY5+iDzwesmo/bA4oJ6K/1SmuBokVV74xQJ7az3eb4Q7IulG7C3mLS?=
 =?us-ascii?Q?kNVZxK5QSi5aPjYNFKkFxk24xcnee7yY6yITN1F7lI5MPzv8QgqmSIVeW4I/?=
 =?us-ascii?Q?L0tLN5grUjNQRxKkgSApvNq7p7nWprZIpvBM+EetbINe4jGOeK+Fqu5ABOfL?=
 =?us-ascii?Q?I8G8jRPb3SG+OmCHADQJhaDEEibr5gRt+5lp0bqR2KyKuLb7u32MslHjuPK4?=
 =?us-ascii?Q?3+5D+BmIihH++8b+YkjSvdYtSNkLnK9BgA89j7n2FYkQGg3DKcXSHe86nyZt?=
 =?us-ascii?Q?kJV/G+Q77Fwj6535vBsb7MjEGc3b0K3pAdpDarpKp3F1Q41s3PCNe9Ul15Ht?=
 =?us-ascii?Q?t3iwfFDMVqjUgU87Bwc0S2hDZFFmSLuoROmK+H2X+z6UUb4oC1FIhkV4cQIx?=
 =?us-ascii?Q?Yo3fBbVkVhxGh1ItWa9bfh+rGIeVlFBJWpNCiidRi18BJpQrIj5wtcCGEVsH?=
 =?us-ascii?Q?ITj2MAC7MVgVnivR4PqRNBeoiBuLALTr1JkkijljFU6CC5XDfoWYIwdi+UNw?=
 =?us-ascii?Q?guMYBVBRZIMgoWt7qVerpdJanlZKhDXg6ci+59mA3e/UWSRZdk2fZdPqaIrm?=
 =?us-ascii?Q?xx+EhmCm9X4UQTqHZtkX/sRBk8xit3MgpQG43bZi7iEKHJpUIE8KYPECAxs4?=
 =?us-ascii?Q?1lmQokqqls6DN2bmVu4yVkyFCTBRz0DF431r6UJ+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91cef892-e048-450d-73f5-08dc27261897
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2024 15:12:55.6007
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LrmafPwhvtAhOJRlORlY5196s0/QrJmtMztTIlW/+wAOPNIltkI8OAZd0+HKEEoG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6733

The SVA code only works if the RID domain is a S1 domain and has already
installed the cdtable.

Originally the check for this was in arm_smmu_sva_bind() but when the op
was removed the test didn't get copied over to the new
arm_smmu_sva_set_dev_pasid().

Without the test wrong usage usually will hit a WARN_ON() in
arm_smmu_write_ctx_desc() due to a missing ctx table.

However, the next patches wil change things so that an IDENTITY domain is
not a struct arm_smmu_domain and this will get into memory corruption if
the struct is wrongly casted.

Fail in arm_smmu_sva_set_dev_pasid() if the STE does not have a S1, which
is a proxy for the STE having a pointer to the CD table. Write it in a way
that will be compatible with the next patches.

Fixes: 386fa64fd52b ("arm-smmu-v3/sva: Add SVA domain support")
Reported-by: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Closes: https://lore.kernel.org/linux-iommu/2a828e481416405fb3a4cceb9e075a59@huawei.com/
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 05722121f00e70..540f524ecf018b 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -387,7 +387,13 @@ static int __arm_smmu_sva_bind(struct device *dev, struct mm_struct *mm)
 	struct arm_smmu_bond *bond;
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
 	struct iommu_domain *domain = iommu_get_domain_for_dev(dev);
-	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
+	struct arm_smmu_domain *smmu_domain;
+
+	if (!(domain->type & __IOMMU_DOMAIN_PAGING))
+		return -ENODEV;
+	smmu_domain = to_smmu_domain(domain);
+	if (smmu_domain->stage != ARM_SMMU_DOMAIN_S1)
+		return -ENODEV;
 
 	if (!master || !master->sva_enabled)
 		return -ENODEV;
-- 
2.43.0

