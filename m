Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2067.outbound.protection.outlook.com [40.107.93.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A6804A04;
	Tue,  4 Jun 2024 00:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717460180; cv=fail; b=dQcrLRn5Dv1aU5qUMjAcFn5gKJAAKEqe4QcKxHtandYRp4Hb3noIzdFV/2hWxdEZohZRyZ/yv9b3rubQmKnDsWjq78syI1SyfrOmYFyG8TGjXznKIQEI5687gTqjgQ+CPtAXSuOeDp56BX1OqpU6liOuBGVF2OgOoW2MiAvA2Tk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717460180; c=relaxed/simple;
	bh=xg5xWv2CANhyxH4a/pE9RIcV2tWOrqO+srV3UwL/ZYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=np992Bpnt7/yumwraY6gThw61m63s85HzznxIv7KD+LDyj1NG+3PyC9XUzFmg/8hX73F0ieP3iZ6HoTS02RjQJkMamF07RWb4wy+mp4Mk8P4GromComzCI8+6kiBr+IXz16X5c3MNAEEzBp8I4XEXUHuelgG3LYSp6wKe8mzMl8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=jJSbf79/; arc=fail smtp.client-ip=40.107.93.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jJSbf79/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mLccCi+LfVGcstxTvXOknJCg9MepLWrB1gLsdWOa0qaW0xDgK/Cyu+BkfDanKnYHhlu043QmC6Q0AYhTi73QG3FQJ6UBDkJmr84q1VcHymIcelci0xGpTHHZKCZ+d2pCqqNaUKlVp9ZAEx5jH1Filp3oivnZdAJldyulAlFAB+lFGrktPuyfw0rfAA5elWbJS+i8ci5UCmpr2T/LKZmZTSKwVZqpIKyZllIKQ0yPwpMHYLXCa+J/06QTdzT6A+hJ/MRkCFuwpgnaATig+MbLgA87p1UT1X9/ULCE1KlS5MVRZdUmyezeBW5sW+nOHDMFUQngSLLG/q6xXePvJVDKWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XoqgZ1Hungdfk0zBr3VeYdSIqPlnOd92FRLm/zECP3w=;
 b=PwmxeeIXQzyQdrSAwyx3nOd+VDRyi7l6AfAOmJVUyDYDftdAU81RFl4HAmwsGnxI2o+ygUZV0XnQb/C322i7srI8Rh/oHq9qP4OotIFQ/45+/CDRhS4KRGh+omf1vmGwxioXCfL/OvUBd+nGdH83GSECanE/xrCZvCkljyUezaiZYY9A1eMvji1zlQ683vtgAoUyBTKvXKdid2MPMFB/r/OBB+ajLUUOxZkALwhVzqk15Vegxm/6MH7Z8xyOPbJxXLlT79oJNGZ9D2hHV4PtzAek9oca5Qe9MqgWhH2HdJclPZsClqJH6G9DI5QAYl/TqzpdDWURoIw3akT5EVbmmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XoqgZ1Hungdfk0zBr3VeYdSIqPlnOd92FRLm/zECP3w=;
 b=jJSbf79/RpjA9AB4TfnPQVBOWBR7RBUbX+9xjLmJpDFWwzp1P174prxKZty/UPEfP5TxHQM3NrfuofHu1jTDGGFCQZDZuS9iSnaoS18Ga7f+77HTEpaA8Z/ElYbG+jFstfJsgCBvl/K2pY9MBpxnkRwlmxtUm2fongI1oHve4rR0H/T5QcycH2MNGDVXqyH9niCT8Qkddrt4UrlYEujt9vF/G4A1jtX07iDMyymE3qO2MCVXO9I1qQAjS3mlNG1ynNemlMHO5E//GZPnbTUaM9xbu8NkgYx+hSH4IOP9Qb+AbTFED94F22wwD83SnXmoNmESSL3rdvy6CvOUu4wUig==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by BL3PR12MB6451.namprd12.prod.outlook.com (2603:10b6:208:3ba::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.24; Tue, 4 Jun
 2024 00:16:08 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7633.021; Tue, 4 Jun 2024
 00:16:08 +0000
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
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH v8 01/14] iommu/arm-smmu-v3: Convert to domain_alloc_sva()
Date: Mon,  3 Jun 2024 21:15:46 -0300
Message-ID: <1-v8-6f85cdc10ce7+563e-smmuv3_newapi_p2b_jgg@nvidia.com>
In-Reply-To: <0-v8-6f85cdc10ce7+563e-smmuv3_newapi_p2b_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAP220CA0003.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::8) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|BL3PR12MB6451:EE_
X-MS-Office365-Filtering-Correlation-Id: 77b5f20f-df77-4817-a805-08dc842b880f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|7416005|1800799015|366007|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pHqrWkb4wBScz3/WtwIkwSrJuSW6XSzhR9jBf+46dexVTxemgHzBpjJOJaf3?=
 =?us-ascii?Q?/lkgUVXoZD6NaRV+MwEI2vEZDq4il+dDz2H4gkqhhAyk7izfOisXBC+53RAI?=
 =?us-ascii?Q?G0VsZYmScjushF7IexajtqCXKFaoRObh1E2lf3ImGPH7RMeZqIToItSbhH03?=
 =?us-ascii?Q?0n/FeW8sXKiFTr33NZyoEWGlmcAoZ9SpAKzB7c5Ee64SAFtJlH93F1Fwjnc5?=
 =?us-ascii?Q?k8M7DqDhf5nG7J8gDM3vlP8kQ8rmxFsdqq5GIvMs7Q1v5P9G3X44IFGAkM59?=
 =?us-ascii?Q?3QOUdgY5+qkR7c/elXCJWu2JGjEmCzPqksPD77KOgyOGZNGShuiEzQb1z7hW?=
 =?us-ascii?Q?oCVlNdB3H2XGhqVuQySE4lWIW3+AisjohUCo/CLhSUyD6kntVQGZANdrQ3/x?=
 =?us-ascii?Q?NF4Z4p4MVcl+hI/q2EU/VrzNbW2p9q58KyOrGcfk6Q0dfThKulswKa6q+A92?=
 =?us-ascii?Q?Le+8GsjFsehQiqWdW/xr0cW7yESlS699Y5uYS2fhxYtRuimAq88k3IpKNV5m?=
 =?us-ascii?Q?RN4fhzt+JSRdblK7adYyKz7Mk37NJLcRNMTLrHMfm3oxHMCz7YqKR7OWLxlG?=
 =?us-ascii?Q?s1rJh1qCEB776PDGY7Q++rlTiiOn0S2vxVHvJDFjjqpD6CutrXsrzzuYemIM?=
 =?us-ascii?Q?9CJVKd5vt1yIHKaky/3toseX3z44h0+ObfmQ+WTaEZQZqtqonlkMIQiRJWyM?=
 =?us-ascii?Q?NVvZ9LHJ4sBIp2npU9+JQlz/SQ6FEverZO2iFbeqOOlowUyg4fS6Aa5XdKhq?=
 =?us-ascii?Q?uhh7u8C1kFYThSEXm8BXdJTJJfi2ZIlQ3b2zaAF+XwGiWrEUgMheU2AE23LG?=
 =?us-ascii?Q?KYUam3Y3BtnvLk2A/ypeKH8WeLyqwdCB2yU8X1dx9DzRoCcHvgOxEIJLsGwE?=
 =?us-ascii?Q?hnksfbofOnpByNc8+mg24Ltbene6OMzTBpyzpVVjH4yflf5yrO4A/3i3AzPY?=
 =?us-ascii?Q?0VNAlIDbCcUzOlNddlhyXFZgv2pXDOeLIjOrHWrRJU/WEQAf/DSRKY6oGik9?=
 =?us-ascii?Q?10EWZrkJ3Kqi49+aOMxpcAkZtDuzLmX1rDudEK8duwNqhMSQD0KOCZH+W2Jm?=
 =?us-ascii?Q?PjtOazXg0/clkLjVgsav/ehUIAOCOuHyrZ/VbisRC+jIYpPTnmIOyfuR+MXm?=
 =?us-ascii?Q?wvag+Zso5Is8+OgygaM4S48eyoAA+j8Y0lM1z7Jcu6Y5lA4QAA/Y165Q346m?=
 =?us-ascii?Q?nJRN5bq0iWBZ7L2kEhXxZL/5Q3ZQDjImQCzUMaLe78FRN8xeKMsvK12ZZeYt?=
 =?us-ascii?Q?ZhqoJ0L2XY39nAWKvXG0byMO/iyHy52pb9LI554aVw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?J6ieUCiCcXcaHZW7R94U9JWlWBcMrM4IyBktGon1/8t8aiJRcEXZWiBdc5ON?=
 =?us-ascii?Q?KQIqqOBj7BBKCc0TwNewG2Ehd1synOM3c6TSCFpYiTqlRmyzrX+FbJSDsmhm?=
 =?us-ascii?Q?5Kv2jt4WzThwf3F4w1Bj+45MneekcP8TViPReZNh2b2qVSUhqTsDb6rvMJpy?=
 =?us-ascii?Q?nH6+y93N3secQjRN9VdqiZxR/Utb65Uz3KYNkPv0XVQmg0pF4f1ydhtJKr/Y?=
 =?us-ascii?Q?A6S4dcn0i5FxdID3ouAG67IIHI9pNuwteLCxwZgpCX2XWAOdXhROi8/+ERKk?=
 =?us-ascii?Q?ZEAAKgLz92D46ZbbiK+CODOTQ/qRJkGIL5pmZdskO5tF0ORctafBGqzxfc+S?=
 =?us-ascii?Q?lGpICgmEH94fDagb4/a6YdyA5j+5xJ0dCD/o7HnPphQrYQ4wb/NjfssCXBp6?=
 =?us-ascii?Q?wK+OHDsdd6BfwMa0kB8bTV+rqCYeF/7jow+z5iekk0o+BFs1QpARBWVWQfc3?=
 =?us-ascii?Q?Zo+qzQmlpXdAkws2GOsR7V2eAor0+V7Qx1dCdIFOBZOKmgTuszrUSm81xd8v?=
 =?us-ascii?Q?ldORCzdxx/U8GHnGA4LblYNojkmQyEE2HGKWQRTTy7SZY5iq0csOM7typ87Z?=
 =?us-ascii?Q?Gd52XL83j4WtqrBemy50LNmTM7pdtyUi+rxvTqpX3zWig4j9cX15hMGS1wqa?=
 =?us-ascii?Q?YmkV2Fue50vwJ/kkmSSVT79S6g9h0bi9PrR76+J4Ay0ETZRtBpDU2JQN8Kt6?=
 =?us-ascii?Q?kCEWbpLefDQX6ZkmM4YNEh1WynMQFEDCp0PX43VE746lRi7UvIBVdkijHMCo?=
 =?us-ascii?Q?A3fxI6ts8PaGJmW2SWPRdy3ICd11tzZ0DPBlwskWQnZAHHkKlweFPULZhV86?=
 =?us-ascii?Q?zY9nZ3kDVuyFZhCvkW71wMTmevyEZYkgQoJxLIHYp5FhheWD0Co/VMOvjgAU?=
 =?us-ascii?Q?6hLEAJ4bW6oFdxCj+feUTCVrTjLdKA8ldduXCcAlHPBT0A1jSwnt3TudHbK8?=
 =?us-ascii?Q?cHufZipHSBLiciOm6nWs3rFsEMCCpcVIfJS4qZTsO0ax1430xbWxlajntMvy?=
 =?us-ascii?Q?1wGmXH8TVwwxNA7CWSABw6fCZQVcBRXaNMqaF0sUkMq6YXUfm9rMi5QtENGS?=
 =?us-ascii?Q?54j+ra+upI/9Ld8907pDU57vvKTyf+ucAT9h1QkD8pinzFcFjCfOk5WfKSAs?=
 =?us-ascii?Q?6TxG4N2rLD5f8vOzWPRKmfkfdDdfxgXXSRjFXa9VTdOYeLH34P9wAfPQ4WXI?=
 =?us-ascii?Q?hMpBzASdMC7Jb9xzQrk17pFLc4m4q9uvttGa3x/96pkbA018E9YiLmNwf3Qk?=
 =?us-ascii?Q?KB1WxdcVxvOR1b0FK84VLtCP0+kcqDGXZZdVDCUXh+LH07i26KmeoItgGTkv?=
 =?us-ascii?Q?XZFiAaJSaxgrZcTKAlSjkWGvj2kiG8jIBvvKHx+mMhEOUSaGvmTaDTg33rER?=
 =?us-ascii?Q?MdjVmhx4Gl/2nw2ibWJYFSG7TB4T1M5C3GGoirXdt7tWB52tD+4QVKd/YAYP?=
 =?us-ascii?Q?8IUnZ8AIv1MEBtzLalmpTikfwYdAWyJC/KotlpNm80LBEgdr387X+EGjZPjC?=
 =?us-ascii?Q?3eM5OiHhPAs+vyeVKbBuOQjIL8nElW+omKlDYHKiiMko/cG1JZI0Z59VQQ2p?=
 =?us-ascii?Q?MFTo9Kp8D6mPk6rnfrc=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77b5f20f-df77-4817-a805-08dc842b880f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2024 00:16:08.1865
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oN7mKBuWz0PPTiERzGwxt/3O/ogbcO6L7MAl7j6MLmNVnOSFBMmspd0qUXXVwqWg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6451

This allows the driver the receive the mm and always a device during
allocation. Later patches need this to properly setup the notifier when
the domain is first allocated.

Remove ops->domain_alloc() as SVA was the only remaining purpose.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Reviewed-by: Michael Shavit <mshavit@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c |  6 ++++--
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c     | 10 +---------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h     |  8 +++-----
 3 files changed, 8 insertions(+), 16 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index e490ffb3801545..28f8bf4327f69a 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -656,13 +656,15 @@ static const struct iommu_domain_ops arm_smmu_sva_domain_ops = {
 	.free			= arm_smmu_sva_domain_free
 };
 
-struct iommu_domain *arm_smmu_sva_domain_alloc(void)
+struct iommu_domain *arm_smmu_sva_domain_alloc(struct device *dev,
+					       struct mm_struct *mm)
 {
 	struct iommu_domain *domain;
 
 	domain = kzalloc(sizeof(*domain), GFP_KERNEL);
 	if (!domain)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
+	domain->type = IOMMU_DOMAIN_SVA;
 	domain->ops = &arm_smmu_sva_domain_ops;
 
 	return domain;
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index ab415e107054c1..bd79422f7b6f50 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2237,14 +2237,6 @@ static bool arm_smmu_capable(struct device *dev, enum iommu_cap cap)
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
 static struct iommu_domain *arm_smmu_domain_alloc_paging(struct device *dev)
 {
 	struct arm_smmu_domain *smmu_domain;
@@ -3097,8 +3089,8 @@ static struct iommu_ops arm_smmu_ops = {
 	.identity_domain	= &arm_smmu_identity_domain,
 	.blocked_domain		= &arm_smmu_blocked_domain,
 	.capable		= arm_smmu_capable,
-	.domain_alloc		= arm_smmu_domain_alloc,
 	.domain_alloc_paging    = arm_smmu_domain_alloc_paging,
+	.domain_alloc_sva       = arm_smmu_sva_domain_alloc,
 	.probe_device		= arm_smmu_probe_device,
 	.release_device		= arm_smmu_release_device,
 	.device_group		= arm_smmu_device_group,
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 1242a086c9f948..b10712d3de66a9 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -802,7 +802,8 @@ int arm_smmu_master_enable_sva(struct arm_smmu_master *master);
 int arm_smmu_master_disable_sva(struct arm_smmu_master *master);
 bool arm_smmu_master_iopf_supported(struct arm_smmu_master *master);
 void arm_smmu_sva_notifier_synchronize(void);
-struct iommu_domain *arm_smmu_sva_domain_alloc(void);
+struct iommu_domain *arm_smmu_sva_domain_alloc(struct device *dev,
+					       struct mm_struct *mm);
 void arm_smmu_sva_remove_dev_pasid(struct iommu_domain *domain,
 				   struct device *dev, ioasid_t id);
 #else /* CONFIG_ARM_SMMU_V3_SVA */
@@ -838,10 +839,7 @@ static inline bool arm_smmu_master_iopf_supported(struct arm_smmu_master *master
 
 static inline void arm_smmu_sva_notifier_synchronize(void) {}
 
-static inline struct iommu_domain *arm_smmu_sva_domain_alloc(void)
-{
-	return NULL;
-}
+#define arm_smmu_sva_domain_alloc NULL
 
 static inline void arm_smmu_sva_remove_dev_pasid(struct iommu_domain *domain,
 						 struct device *dev,
-- 
2.45.2

