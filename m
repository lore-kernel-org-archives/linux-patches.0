Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2068.outbound.protection.outlook.com [40.107.94.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C75BF17F381;
	Tue, 30 Apr 2024 17:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714497716; cv=fail; b=c0vsoaz3E9AF2xq13LpalXAViFFzhgWc6TwyHiDDW0p88hSsfcXwDj2I9phIaunp2zSx8Wx7yAMiu9athlCiBti1bpGlhpjPVsQIXXLUDqs+8exDwpcynfxLwn6PyavRXY8I2NtWaYB08PHxXvX2z8ndxTZscOJEH9CRNRDI8UA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714497716; c=relaxed/simple;
	bh=r1Uoo8elV8eIRGwkDr1XQKQUgo773tQ7buKlZFFEUUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=drxDLZGTThzOibTzcgnncCQODN0x5WAu8k8STcemB75KNJo2UDOIBy1kZOqL2o3JHKr2If4n/PDzX1kTzmMqhPuL3d0JcM8fulZJVs4dqDbgL3+vyAykkJTVbQIHRDxBjSAOS1txQ8ZpO2H+VVtcNDdbZu1uEgMcgayY0HwsT4o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=fp1zuSWy; arc=fail smtp.client-ip=40.107.94.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="fp1zuSWy"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l8qniOxV27Aq56tCCAJAMw5rAm4cD2djMybN2WYoAF4c15q3FsjTN+OVkweN13M2baMZxZtRqwTnW7ReOAJor/s4oY9buTI01nhKAMYf4rKkitUkuQI24LDb5dQ9W09D4WKtNtlBh3UlsSzCciHTZeloZsbw7sQ7yxBmVESPY4ZO1uD+HRIgJEPbmPK/Ytcq6dEnj6xsvfPwIb+MeCIjq4blh3QXFyvONIaGyaPoEMXoavgBQApSNhvnUZ7YWsGEGnKoD5K4gtVzIM74aRwT0DHvEoRGpJnBeECBbXNudddgGKzxdZJuEN9wqY1T41AeGGrZLguCi2RzAZ4vRtvrWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rfiowHDG2quWv/lUvO0KpNtFbwdW1jxLsjjmq+AoO34=;
 b=gPqEK8zxfO8MMZWEpk02+7EEuB3mf6zLQQbgRgIxRePjjc0rGATXdbrvm8mlvDoHo5mtaHzz3N555B7E7TWfAkYbLlL/LciXzHC4h2i4l5un+9HJLE60m7v/YVCy/A/yzAhO0pzKoSIdPplGBXxsQepyH7hhohBnZVo7PEGW11UVEShRsGovzoZKp4JrGJpSR5+1NOjXkzij5wa3109TTq0BNLa1Gac7q8ogLfJrhEVzPOIWtYO0FGEI4hiqnFvV0iZ3jSdz2qhRHuHMsp+wp6cgToAl03c1/kMBt5kMfypaFvk+EF1EnvA3Po4Qdtr/S79taRwKyvGCDU3HC32Mlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rfiowHDG2quWv/lUvO0KpNtFbwdW1jxLsjjmq+AoO34=;
 b=fp1zuSWyzzu230r8mCJ3Uannj/xo6iz/e7mr/RiIHW+ygW2P3HvbCO8VnOua1rMEdWRYJiov0zGQxuanpSNgQaIzIPpui3u724sWE5ldI2tDfFPLNxj3lCtQQDXKuacuomzuy4gnImqmbx4UK5XvR7fk0R/iVS1oivOp5LBnIgnSyX47GjPFhSaqQFBoRCIU7oLEHsLHSCXhuwDSqcbFGTaJQBseyQuhl6eVPlCX9muWOGrCVxwX9i0kOWhmYnOwG5yGC4WkxF0yH1kosmFnJnX9Cy5OhxEmvgddPtS/9lgE6p/a098VG/9zqu6xAH01oUwVstb8YcBp1Q/FzaNouA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by DM6PR12MB4172.namprd12.prod.outlook.com (2603:10b6:5:212::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.35; Tue, 30 Apr
 2024 17:21:46 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%3]) with mapi id 15.20.7519.031; Tue, 30 Apr 2024
 17:21:46 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
	Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v9 3/9] iommu/arm-smmu-v3: Move the CD generation for S1 domains into a function
Date: Tue, 30 Apr 2024 14:21:35 -0300
Message-ID: <3-v9-5040dc602008+177d7-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v9-5040dc602008+177d7-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR17CA0027.namprd17.prod.outlook.com
 (2603:10b6:208:15e::40) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|DM6PR12MB4172:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e38b2ed-f088-4dd3-3242-08dc693a01b9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|376005|7416005|366007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DSPquYM2oG3Q9bJxjivAyKg8A9gqmxwHNa3f0xHaG7P3GYd1qoppEbxz+WkR?=
 =?us-ascii?Q?fYaJ2myQyhpx70UyQncfgwzHOHv4Vkn8GSbivokV70k+gPmtqwDqZYLUrCr5?=
 =?us-ascii?Q?zem16x7G+f2jhA+duKHW9kSrQlcaN8/5VRNEl46GC0LOLEh2b01JmG6l9ALI?=
 =?us-ascii?Q?kTZXJo9x4pf26SkbtSE//azfRSz99sb4mHehgq8Ry6rRnHkdJT2XYGMpblI0?=
 =?us-ascii?Q?7tgcRv/RNnOhw+Xqg/IfB+kQ7IkMIB3jBxn64KwDBYT+mRZv2dWHAlKew6bn?=
 =?us-ascii?Q?z1OLQBfB//N4uz1xVrePd/G8N3HtZavEL9sGWMat80ewE4HgbK6D+LvKW722?=
 =?us-ascii?Q?qZiJh4tSZ7drF81sjaMUZ7Tae6SL9sERAKaHSrBLTKQJX9KxGRpJoNEYgrsf?=
 =?us-ascii?Q?zo9EKiBgRyxT5hjxtkoKxV+JaJrM8i1snYf43CUgb8Eaz2ORtAU/VPW9krvc?=
 =?us-ascii?Q?QC/Ef3w16tAeqtRnR+wgTPj9tju98AgI6bgia270sPCGtz46x/0VZh+sjwUj?=
 =?us-ascii?Q?sPaYddkRfJOuHEI1Lu+Hifz4ZrB5eiN0L+bsO+J9odPnZJJlHhjZ4aVPIU89?=
 =?us-ascii?Q?1W89WLDbMxhWJpYrJzPONJXsclSab+CpKNIFUbbKzaHIpUP+xutE655aaJhL?=
 =?us-ascii?Q?p+qls4jV2NNus3Azag7789l7s7Obnk3798C5syN4BP8OvF9eNBqXdF8C8839?=
 =?us-ascii?Q?xDgDtOVxQFdWeWA3NHPBukQ9T+LIfRLjQb7Pg6HekX5nSRi3gQytFNcgCQJF?=
 =?us-ascii?Q?um0HDjqBMLFuG4YTXlaLswlHWaSZi87pLfPjOfUpZMcdx8ie1y8Gn7N5c1Ou?=
 =?us-ascii?Q?z5od35j4ZZxOIeJru6LSo0EsKmuwQnsfotvLfmOenVSD3/M+pBoH6qfwdNHq?=
 =?us-ascii?Q?xgIMy2QGTxM4Zg0BJtA0Ykvgz2UZs0tOkZZ5QBOqBfvS11xjkl1929ZPtLn9?=
 =?us-ascii?Q?Yn0dgSfSV7cYEugs/wGL7dzE0RVvk5MTTxi5rOgv8jIhnS0O2k6WFlBuRiTT?=
 =?us-ascii?Q?vHiGCLur51iPvcO3gEqMR+9Vx2dOZ3V+29RnCF8OHYnVnwDThimsPKv8yYiy?=
 =?us-ascii?Q?tjh1oja+eiwNr1TlRzOUMJlCQHg2bio9ScqtJane4DBKJqfXvDRIZcOx5dH0?=
 =?us-ascii?Q?IRzyKoTDiv5abe4RwcPUsXF8Nw3BMLu4w4KpmypfS6EcvSKdhQ5YYZy627Vy?=
 =?us-ascii?Q?syOigmMKRTmZ1wZn5m+QFHoFdoNB8LcVNcB4utB+V4yoF/+msouWMUM2mT2K?=
 =?us-ascii?Q?7yYdKcVYeJ73Fj8wDXoVB758W7QrldfU4YdalET2LQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(7416005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Ug1MMhX6RdaTlK68cp9+VInfuYDv0xn4lr3Fgfs+bcJFmbZx7lWxCeOPpCJj?=
 =?us-ascii?Q?QySbhloNiqE1izZ5Fzs0dkjOHevXfrO7m/h8YEflkkTMRiUmGmpIm8A/3kYD?=
 =?us-ascii?Q?fg+yM3IJu5/hylk89St2nrmXbIA+8n9vVxHJutv2QILzN7jzlfirMDpiKSl3?=
 =?us-ascii?Q?OEp4sy+hebXa1AR79YLK0uP0mjcQleuRFC6dbL1GmCh8jL9FhiP4iBwXiN8k?=
 =?us-ascii?Q?4TIqKPAFWN68YQPz9ZTRGd1bELYKNL3BvEkdUhRj4NhNIN3ytRR2/6vW2fu9?=
 =?us-ascii?Q?uEBTATUHhFQkTqFJbhQ5QB6UjE6ivZrFtR5puP50UYSigkvnvTwH5H7Yvor6?=
 =?us-ascii?Q?he3BvGlGpyu9glqz+FdLgEPD9l7K8SwbeicO4+uC8kSm29ahQ/oxi3lK0P5b?=
 =?us-ascii?Q?WJmS1HepEvnLRD0fQZ6o10O9OWailRRPPiQT8Om3OjNbK8/bAFnvgIxq/u1r?=
 =?us-ascii?Q?A2hwrWS3m9kUG6R0pcv9IJaTR/R6WSQfwVWFq3pOLyrRGLvglYPgKgXgmPGk?=
 =?us-ascii?Q?JltN8neA3oj44yUnP0Xy8c2l1VJuDEpYyvpu9wcE0B81NVy2rt2g8B8BYK6g?=
 =?us-ascii?Q?HF/cb3GkhiBeUd+Zz0WpqL1nHvvPXAROI08yl+hrCObn0RpYdXa2PRbhfxFV?=
 =?us-ascii?Q?M5vdxlNudfNIN8ylyW7ho1GvdSKC+FXFtSz56vvnfX6MvfEP0+6QlTISgcXw?=
 =?us-ascii?Q?P3+OtnUJE6hk4BlT9VGhazb9pzWwKiRvIfvdzZYLQqZdHJyMrdt34cnNjDYr?=
 =?us-ascii?Q?fnBKd30PNgkH0R9Q52cfYwB1W7V/47IaVBt7BU8B8LlpOFrnag84gP/zHG2O?=
 =?us-ascii?Q?3jEMKpWSej7EaOq3V6HtieICCEqS3JX6QplKdAaFtL9AcnogEg/fKeZ9p7xF?=
 =?us-ascii?Q?3uYCOxUynZx+3yCgvn4NObMqvDJ0mU+LZMJLidY1ZzfPE0sISRILYkl1JIx4?=
 =?us-ascii?Q?r87WUpIrOz6HXzBZZvopgl7cZWcxgU2RAzwoDC54X2tKlnB5dMvgCKEXEu4N?=
 =?us-ascii?Q?vFoLQr3i8+bcZCc/g9tSoDBeeYzHFquWd8Jizcic8ar/E9TgsLF28cGoI3GZ?=
 =?us-ascii?Q?XnJKgNnwL+tcLiWalNlHP5G5LXV8Dt9BlYE3WOGqfBACJxo7iafvwawqQetL?=
 =?us-ascii?Q?BMjEdNtC1ns54Eu0LDN+YZclfdYIXl99iWe8YBosEYQ3es4qq/0QqinUbVfw?=
 =?us-ascii?Q?Vj9J1V2VGUlrED9fryOT7or0H4Nm8EEhRZEvrzGZaMOE1s6ehn8tbaVVih5m?=
 =?us-ascii?Q?HebnHR7pUFKL7UknBKuoC3+96D5p+EDpc+1NbaHosCZTimfbYUNn9EIBicoY?=
 =?us-ascii?Q?uJFQ/pCU2+mV7YsyfKjAQ8mQ8UWsPAFKpIC/FOwRf5QgqEAujRxxp2P/WJji?=
 =?us-ascii?Q?CvOzUfYqbjY7031dZSO49y6wmZaYuxNjh6XnJjUita36A9a2HzJoKbqdgd3u?=
 =?us-ascii?Q?3bZbWZF8vW5Ju0NFkqf2RDZ06JsrwlCzUrXhQ9aEWU4qiKT/0v9Q4AShOxY1?=
 =?us-ascii?Q?N7Q2qbkAAB8E/gly1G0+jb37ABLOj77y5hcLC+Hz63fZ5iZme12BRi14ttfy?=
 =?us-ascii?Q?mEqQTRrFY/d/oanW2R+GRmIrVFfSaFxq3T/9TqV3?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e38b2ed-f088-4dd3-3242-08dc693a01b9
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2024 17:21:43.9917
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7PJomkDWRupVB8uiu6bHgI8Zh576DxqQdWAbmXVLl8nxSqiU673VW04tz0YJuNQO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4172

Introduce arm_smmu_make_s1_cd() to build the CD from the paging S1 domain,
and reorganize all the places programming S1 domain CD table entries to
call it.

Split arm_smmu_update_s1_domain_cd_entry() from
arm_smmu_update_ctx_desc_devices() so that the S1 path has its own call
chain separate from the unrelated SVA path.

arm_smmu_update_s1_domain_cd_entry() only works on S1 domains attached to
RIDs and refreshes all their CDs. Remove case (3) from
arm_smmu_write_ctx_desc() as it is now handled by directly calling
arm_smmu_write_cd_entry().

Remove the forced clear of the CD during S1 domain attach,
arm_smmu_write_cd_entry() will do this automatically if necessary.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Reviewed-by: Michael Shavit <mshavit@google.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 25 +++++-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 81 ++++++++++++-------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  9 +++
 3 files changed, 86 insertions(+), 29 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 41b44baef15e80..d159f60480935e 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -53,6 +53,29 @@ static void arm_smmu_update_ctx_desc_devices(struct arm_smmu_domain *smmu_domain
 	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
 }
 
+static void
+arm_smmu_update_s1_domain_cd_entry(struct arm_smmu_domain *smmu_domain)
+{
+	struct arm_smmu_master *master;
+	struct arm_smmu_cd target_cd;
+	unsigned long flags;
+
+	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
+	list_for_each_entry(master, &smmu_domain->devices, domain_head) {
+		struct arm_smmu_cd *cdptr;
+
+		/* S1 domains only support RID attachment right now */
+		cdptr = arm_smmu_get_cd_ptr(master, IOMMU_NO_PASID);
+		if (WARN_ON(!cdptr))
+			continue;
+
+		arm_smmu_make_s1_cd(&target_cd, master, smmu_domain);
+		arm_smmu_write_cd_entry(master, IOMMU_NO_PASID, cdptr,
+					&target_cd);
+	}
+	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
+}
+
 /*
  * Check if the CPU ASID is available on the SMMU side. If a private context
  * descriptor is using it, try to replace it.
@@ -96,7 +119,7 @@ arm_smmu_share_asid(struct mm_struct *mm, u16 asid)
 	 * be some overlap between use of both ASIDs, until we invalidate the
 	 * TLB.
 	 */
-	arm_smmu_update_ctx_desc_devices(smmu_domain, IOMMU_NO_PASID, cd);
+	arm_smmu_update_s1_domain_cd_entry(smmu_domain);
 
 	/* Invalidate TLB entries previously associated with that context */
 	arm_smmu_tlb_inv_asid(smmu, asid);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 3504c25de4306b..a80758d72d6a7b 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1203,8 +1203,8 @@ static void arm_smmu_write_cd_l1_desc(__le64 *dst,
 	WRITE_ONCE(*dst, cpu_to_le64(val));
 }
 
-static struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
-					       u32 ssid)
+struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
+					u32 ssid)
 {
 	__le64 *l1ptr;
 	unsigned int idx;
@@ -1269,9 +1269,9 @@ static const struct arm_smmu_entry_writer_ops arm_smmu_cd_writer_ops = {
 	.get_used = arm_smmu_get_cd_used,
 };
 
-static void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
-				    struct arm_smmu_cd *cdptr,
-				    const struct arm_smmu_cd *target)
+void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
+			     struct arm_smmu_cd *cdptr,
+			     const struct arm_smmu_cd *target)
 {
 	struct arm_smmu_cd_writer cd_writer = {
 		.writer = {
@@ -1284,6 +1284,42 @@ static void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
 	arm_smmu_write_entry(&cd_writer.writer, cdptr->data, target->data);
 }
 
+void arm_smmu_make_s1_cd(struct arm_smmu_cd *target,
+			 struct arm_smmu_master *master,
+			 struct arm_smmu_domain *smmu_domain)
+{
+	struct arm_smmu_ctx_desc *cd = &smmu_domain->cd;
+
+	memset(target, 0, sizeof(*target));
+
+	target->data[0] = cpu_to_le64(
+		cd->tcr |
+#ifdef __BIG_ENDIAN
+		CTXDESC_CD_0_ENDI |
+#endif
+		CTXDESC_CD_0_V |
+		CTXDESC_CD_0_AA64 |
+		(master->stall_enabled ? CTXDESC_CD_0_S : 0) |
+		CTXDESC_CD_0_R |
+		CTXDESC_CD_0_A |
+		CTXDESC_CD_0_ASET |
+		FIELD_PREP(CTXDESC_CD_0_ASID, cd->asid)
+		);
+
+	target->data[1] = cpu_to_le64(cd->ttbr & CTXDESC_CD_1_TTB0_MASK);
+	target->data[3] = cpu_to_le64(cd->mair);
+}
+
+static void arm_smmu_clean_cd_entry(struct arm_smmu_cd *target)
+{
+	struct arm_smmu_cd used = {};
+	int i;
+
+	arm_smmu_get_cd_used(target->data, used.data);
+	for (i = 0; i != ARRAY_SIZE(target->data); i++)
+		target->data[i] &= used.data[i];
+}
+
 int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
 			    struct arm_smmu_ctx_desc *cd)
 {
@@ -1292,14 +1328,11 @@ int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
 	 *
 	 * (1) Install primary CD, for normal DMA traffic (SSID = IOMMU_NO_PASID = 0).
 	 * (2) Install a secondary CD, for SID+SSID traffic.
-	 * (3) Update ASID of a CD. Atomically write the first 64 bits of the
-	 *     CD, then invalidate the old entry and mappings.
 	 * (4) Quiesce the context without clearing the valid bit. Disable
 	 *     translation, and ignore any translation fault.
 	 * (5) Remove a secondary CD.
 	 */
 	u64 val;
-	bool cd_live;
 	struct arm_smmu_cd target;
 	struct arm_smmu_cd *cdptr = &target;
 	struct arm_smmu_cd *cd_table_entry;
@@ -1315,7 +1348,6 @@ int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
 
 	target = *cd_table_entry;
 	val = le64_to_cpu(cdptr->data[0]);
-	cd_live = !!(val & CTXDESC_CD_0_V);
 
 	if (!cd) { /* (5) */
 		memset(cdptr, 0, sizeof(*cdptr));
@@ -1328,13 +1360,6 @@ int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
 			val &= ~(CTXDESC_CD_0_S | CTXDESC_CD_0_R);
 		val |= CTXDESC_CD_0_TCR_EPD0;
 		cdptr->data[1] &= ~cpu_to_le64(CTXDESC_CD_1_TTB0_MASK);
-	} else if (cd_live) { /* (3) */
-		val &= ~CTXDESC_CD_0_ASID;
-		val |= FIELD_PREP(CTXDESC_CD_0_ASID, cd->asid);
-		/*
-		 * Until CD+TLB invalidation, both ASIDs may be used for tagging
-		 * this substream's traffic
-		 */
 	} else { /* (1) and (2) */
 		cdptr->data[1] = cpu_to_le64(cd->ttbr & CTXDESC_CD_1_TTB0_MASK);
 		cdptr->data[2] = 0;
@@ -2633,29 +2658,29 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
 
 	switch (smmu_domain->stage) {
-	case ARM_SMMU_DOMAIN_S1:
+	case ARM_SMMU_DOMAIN_S1: {
+		struct arm_smmu_cd target_cd;
+		struct arm_smmu_cd *cdptr;
+
 		if (!master->cd_table.cdtab) {
 			ret = arm_smmu_alloc_cd_tables(master);
 			if (ret)
 				goto out_list_del;
-		} else {
-			/*
-			 * arm_smmu_write_ctx_desc() relies on the entry being
-			 * invalid to work, clear any existing entry.
-			 */
-			ret = arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID,
-						      NULL);
-			if (ret)
-				goto out_list_del;
 		}
 
-		ret = arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID, &smmu_domain->cd);
-		if (ret)
+		cdptr = arm_smmu_get_cd_ptr(master, IOMMU_NO_PASID);
+		if (!cdptr) {
+			ret = -ENOMEM;
 			goto out_list_del;
+		}
 
+		arm_smmu_make_s1_cd(&target_cd, master, smmu_domain);
+		arm_smmu_write_cd_entry(master, IOMMU_NO_PASID, cdptr,
+					&target_cd);
 		arm_smmu_make_cdtable_ste(&target, master);
 		arm_smmu_install_ste_for_dev(master, &target);
 		break;
+	}
 	case ARM_SMMU_DOMAIN_S2:
 		arm_smmu_make_s2_domain_ste(&target, master, smmu_domain);
 		arm_smmu_install_ste_for_dev(master, &target);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 4b767e0eeeb682..bb08f087ba39e4 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -751,6 +751,15 @@ extern struct xarray arm_smmu_asid_xa;
 extern struct mutex arm_smmu_asid_lock;
 extern struct arm_smmu_ctx_desc quiet_cd;
 
+struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
+					u32 ssid);
+void arm_smmu_make_s1_cd(struct arm_smmu_cd *target,
+			 struct arm_smmu_master *master,
+			 struct arm_smmu_domain *smmu_domain);
+void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
+			     struct arm_smmu_cd *cdptr,
+			     const struct arm_smmu_cd *target);
+
 int arm_smmu_write_ctx_desc(struct arm_smmu_master *smmu_master, int ssid,
 			    struct arm_smmu_ctx_desc *cd);
 void arm_smmu_tlb_inv_asid(struct arm_smmu_device *smmu, u16 asid);
-- 
2.43.2

