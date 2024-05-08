Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2082.outbound.protection.outlook.com [40.107.223.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB0D012BF04;
	Wed,  8 May 2024 18:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715194659; cv=fail; b=qoug/UuZ9DontA58H5YErd528xby6KZxIecOUoMLj6yIgESOcWpuLKen2iR9NHCN2s4FVUGKxCElZm2ETLDdLpmoKqMjnu+N47xVDrPmYH+CH2iIrLV9UB5mLuv8Exiq6vTkUe2dHtm/hw3FK2iY2hYI1+Xu7jmMlM8pn8WcuL0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715194659; c=relaxed/simple;
	bh=vNV8cPzTcm4M3NHYWeds7LzDWJg83J6YAkguWn84ghk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=aRWWmJqHGCU51r1ZtDEtAycitZBn1ere0j2ahvUIBWkekQJVlqUUZr45LRyD+KVmAP97JkoWLw5yc//10QZ8v+h28GBiyTtSVTrODevULK+Ox8PpIDsjLozuXNfcG/M9xLo+zE0OyUGkpmwky2rKseQk8IJhnIeExDEQ26+2P58=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=pv5yALMM; arc=fail smtp.client-ip=40.107.223.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="pv5yALMM"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CZ0Xe0Kz2cgxKEmyXlF9SCNM7k2hkMghGi0lKR3+634d7oxR3EfXHJNiZV9VZQ73CuBDf+OCFwbFTaSnD1hWKg56fFJggqVhJ3eoDBhlDfW6xmCV8Bd3SPsP3kw0kYU/R+6GXe8DzJLMiXQjDGbuqKEZ6jkyZ163lYuN4JkO8zhVOnsHLB2DBF/VBMC/TRw8ydt5b/ekqdXnWlmfF8hN0y7EYqHxmpQRwAqZwCI3DoJkkCsSLzLpPzRfHHrUk+cxEJKo1nbhEM9xEIIiSHl84NCSP+74+9b/bxWmd/QcWSMnLfsJTCYMYGuQiDZii4fx112Ssb/k+bcJytb8j1AhWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O4YOnaEiRj6hBwAdgo+aFd8H2MqvXXS+W9MsIEdNjqQ=;
 b=IrJlDlJmKDm0oxBHaK1rP0o1rSwA0mIMepwplc4XtjGKR1U5+sCT+sHUoXRQwDXaEt1UtQJmhbn9GFyYwe+6SLuG93tLnmZpYVi9hyZatSuCruu9l6SM5XnhTFc4VHGDtbQkY58VwVOgtIyNJOnu6AdGkvUS9NATSNjq+u7ahrFLBIjASns953sMxr/2nzHgIitdQ0BmK4qqbJQd4yQe/p8emEvb6AEyJ+Pe0VlQlzm6lrM+GJTtuXM/35YbusLBaTtkow3PHIVOJGX/fd0EJLmr0XQysKau0xxg/CxY8HCxcSn7sDRl0kEsiLqBLqKffrqGrLjJdN7twEGUua/+tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O4YOnaEiRj6hBwAdgo+aFd8H2MqvXXS+W9MsIEdNjqQ=;
 b=pv5yALMMioFId1XxgZvQuN8dx5pm75PTEf3Uy3PyY6D/GnPV1vExPPkFZRHZkzNo2AtiCOBuyOb+d549Kum5ob8/4hg1x27W3Z3Di8ILnrvIkVKvpuDMet0tOglKiMMveFPXtIpJjLIsXEBTxIvqfmEbdGq6k3aBohfLO7ur/74R10sQbqz22rxa2NFcn9+R8qA4Y4/SfyTUNHICc80w6S9iZUnzov/3h8TTKwVRsN6CIBZFNm+8c8JMpqhcGQ72ewlc/MfZRA31i9dwCrBGs1gS+ad1L24s3LfKXsI9dXzQpuZ2PiUcQ045lSs7AfIInaJSM3aRv3z6P6XrU2XSxA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by CY8PR12MB7514.namprd12.prod.outlook.com (2603:10b6:930:92::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.46; Wed, 8 May
 2024 18:57:27 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%3]) with mapi id 15.20.7544.045; Wed, 8 May 2024
 18:57:27 +0000
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
Subject: [PATCH v7 05/14] iommu/arm-smmu-v3: Add ssid to struct arm_smmu_master_domain
Date: Wed,  8 May 2024 15:57:13 -0300
Message-ID: <5-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
In-Reply-To: <0-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P222CA0020.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::25) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|CY8PR12MB7514:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b727ee0-f716-4485-1694-08dc6f90b37d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|7416005|1800799015|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jS60I++WJloUYcN3RYPrjFSRiTS7hrjqswWTzd7B7GLjoBDeXpgUVFnQxWrS?=
 =?us-ascii?Q?0I1axOyTYAMwjQJlC1Ebqum6FTZlqfw93e1xd0dNUBdPHSLJazozCndglga7?=
 =?us-ascii?Q?vkGPeOMzGW3BjcqLusNI9BjU0bl1ayYx8sSN+4xFRj4488aGxn/KSyQzQJmm?=
 =?us-ascii?Q?bN+/xMdkdq1CchapY7nhEvuk1MSE22kW7X3tLWlt577W+4dCUe2RAdzh6IXT?=
 =?us-ascii?Q?ElOaVm8No9UoYFk4wcsRvBPdByYU4eAvCc3d5v5N9+2XjGX/GKSNaJVUnV8U?=
 =?us-ascii?Q?K2ir7MqA6gS2Y+OZZYX+CaDVsJMrEkxtYzHU/gIhrU3p/ePIjiAjeumYoB4y?=
 =?us-ascii?Q?3PwPJhynnl0MCjiP5CzxZYmeCXvT2RytjGsyamhkkAfaCYYme0fKjxfRSvGW?=
 =?us-ascii?Q?yPI/+mMqzlgBohs9FmuuZ3m0ocvrzMWHSs8yLECQKNuTNUvG4jvkkxAoRZFl?=
 =?us-ascii?Q?I9/Qv1eFZX0RZOHprd/8O+XUantrs5jvOauf7PJ7pqJaH/pTZ7Jrp0abOPIE?=
 =?us-ascii?Q?bQ84y2oEO8Kqu3EW6Fq4DsCPPBVITgzUFbZ029FW5A+Fh98Wo+aDSHcfxMVg?=
 =?us-ascii?Q?tt6NsMiJdynUTfc4sItkCq08NI3ApVBjZusaoFt5ypvx1Cv3ojzrOPW56lvf?=
 =?us-ascii?Q?a95VnsfhpGndKyTgMW84QJP5nIPdHRIXAhPKEjVo+RpQa84lvdNlKkrje2aO?=
 =?us-ascii?Q?fbnZPT9CUnOMsXhnyNQvYB5SuMBqt12tgMgSyz+nUyZmIHreNO+af3hmRWmu?=
 =?us-ascii?Q?RbvzXCsWdWcjR6ILm+V52CqPWMQI3EZ4Z7eq4e2jAnU2mmZTANtMwGrVzSSe?=
 =?us-ascii?Q?LHIujQH7pWtTNxqRZlSa3rFX7m/Ujascn6lJozvVS5LZlkI4tM8MDYiMPUI2?=
 =?us-ascii?Q?a9iMoQWEyKBogrT71CqRYcE+eHN5OS5BBxU4a79gp2k2fHYb5G+cSOCFoTIF?=
 =?us-ascii?Q?TgFLUWqvMhZY/mVdjDXBghuxCm7f/FidfMiqlZR22KyUjXF1Z9EoPABFBACU?=
 =?us-ascii?Q?6WXxzwYg04E7ipxfTiRQjYtk04/6HrIGh67PVsg0rnEoKKoaUdK8W1XBcbBC?=
 =?us-ascii?Q?Kcj5EXgAqE4rhr32wMzB8q6ZWQ7bLGWiuX7JW8jNqozxplAn/oJTo7D/xotN?=
 =?us-ascii?Q?HZigB0ssXYXhR4OYMxgxBd+UbJVLvd2yY/DyFPXM/z7tRu98JzXlbySeb3vT?=
 =?us-ascii?Q?LOyMMvmbO+ysqr9U5gToiGJFUDsWxYJP0CvVYDJtsUe1pqWEEI1XUMoEJ8y0?=
 =?us-ascii?Q?/KFtO6NpEKVe5m6yR/IqUX5SXFUv6Uw3VVnG4So+CQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7NBstXE2rWY9XfxOpMLc5Gokhp7azghRMZySfpvwmTBoDc7vH5Opcs8j6OsQ?=
 =?us-ascii?Q?YZbwXWDJkZAmo48DempSP8GpFkL6eV7w22aynLOmafrZ0GK4iFdF9g/01p6U?=
 =?us-ascii?Q?RTNibshcPx2m+dPjGHeH14ixVth4fYEkymNUWIm1Th7vtRyX+O13CF/w8ojt?=
 =?us-ascii?Q?lnC8PqvEUmuQzDo7CmJGYI3th8c0tPK1cqiZk2IWLE+j6hplaUbLOSeuOW+k?=
 =?us-ascii?Q?Yqz9cgajxpUGqCJjIq+MaNbbthr35bqt3SjR5PKH7ONhU7TIS4EBUMTO4epm?=
 =?us-ascii?Q?fiwo5762heM2L23dOvxSrwnLEiOrfkOxVspXf9EO4PFXzc5e57gGFkcZPeJI?=
 =?us-ascii?Q?54eK12Ndzs17OPuhsdsrd3lr6P3MFx39ZyPgGVCHHu+8NcKJwTcso1AyCeKq?=
 =?us-ascii?Q?45iG8sexWFxB/qVTYvzt2kx5re4dvTzQrq3ccuks+1XADffCfA5FKLAV/cg+?=
 =?us-ascii?Q?H/KF0mz+S/z83RbcVz4isKnf67fhIfyJSOktGCf601neHgUsPQvm+uh3eGRd?=
 =?us-ascii?Q?PkeWP7JUfe26oaZDGp38SetuUumqgJRG62dkc6UJufB0P+VrnULoPo80OuyL?=
 =?us-ascii?Q?5Pva2A/wtBEPogvNlshxPqccsABd3RrB2RB88HYqSELDqb45RiPUCw//G5m7?=
 =?us-ascii?Q?tP66tQsCE5AXaSCbSNm/nHcLafixiYR2397FYB4TK73zodETmhwTeUPiVq7g?=
 =?us-ascii?Q?3NCMSIpuC7NjivqdLKmjqqTnbvAbOCsbeT/kW+l1t8XXGiBFxEm//LkcPdpl?=
 =?us-ascii?Q?3jVzp8fEUeDHRMvOuc4+WYoe1mGYf9CAxaE5V4mod/HbiuV3C4sqVY19JF+2?=
 =?us-ascii?Q?6yoFUK2TYp1ecfDrt5J93LFmIewFea+4PTAmwJqQO9XugXjBG3DNE/ipAi63?=
 =?us-ascii?Q?ibFQuxXj47FZqB5og5v/odMv11+41fiZFGwWLDtj4/B3TIv/9tqAujz6TqE5?=
 =?us-ascii?Q?pKAdmmXKlutumrqOwOsfqKZQPkISoGqDEH9uOlelWiBtL1oF+zcF3Y4NgGCW?=
 =?us-ascii?Q?VY+C09Z7osgFsUQr2l6HGOxPM6Gf6aJ7yxirw1tkSUSPaKQXNiFTWS2MQOSC?=
 =?us-ascii?Q?+dcTZTXJxSYNeB0XNtTe6p+b5x0JFIAzKe/zfOCIIAuBIesX3Fltuf4wgRuh?=
 =?us-ascii?Q?oYiSG+aNtaK3971/+c9a2kT47OCquMSsVHCq5NS0wVAlT0RlGKEW29iFVVK1?=
 =?us-ascii?Q?UPLd3rROEWelmzcxFBKzDIyV85DmkYOKm6S49YOAfinX5XaLU8TkCOcWzI8O?=
 =?us-ascii?Q?TGvqjH0kXlfmRIfKgcT6YnvigYJpZazwvfW4cz9lneX+lKOXgZTiI8a4Czg0?=
 =?us-ascii?Q?9cQ75fhMSOrzbNfTMLKCkoY2hBtqlIMysKup1Bj71kFUB8Q/6nEx0oaUikun?=
 =?us-ascii?Q?tHILk7M+H1GBLODPMGg8TTjkjQ8FuNaxYZebPqTf/KPv3M+oKStrFwV4TR3z?=
 =?us-ascii?Q?6gsalsaZvasDVq8SQIXgzZBqIiDScOIRPSkQvNcIStxZ5LyLiSv6sh1HkjkW?=
 =?us-ascii?Q?1uxqovzu3KTjjrNJNUgQUmhOc79Z1xLS4tRQRTtIL01J3XzjSJeCk+5pJCjt?=
 =?us-ascii?Q?7PR13LS5ifG0z9Hea/zelVWcg2Iz8ZXpC/vACZra?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b727ee0-f716-4485-1694-08dc6f90b37d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2024 18:57:25.8719
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jg4AatnrH6c6ISUFoenZhWtq8uR84fS+7BzpwhIU2rOiO86l/xPgUhi/WFoUUrl3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7514

Prepare to allow a S1 domain to be attached to a PASID as well. Keep track
of the SSID the domain is using on each master in the
arm_smmu_master_domain.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Reviewed-by: Michael Shavit <mshavit@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 15 ++++---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 42 +++++++++++++++----
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  5 ++-
 3 files changed, 43 insertions(+), 19 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index cb3a0e4143c84a..d31caceb584984 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -47,13 +47,12 @@ arm_smmu_update_s1_domain_cd_entry(struct arm_smmu_domain *smmu_domain)
 		struct arm_smmu_master *master = master_domain->master;
 		struct arm_smmu_cd *cdptr;
 
-		/* S1 domains only support RID attachment right now */
-		cdptr = arm_smmu_get_cd_ptr(master, IOMMU_NO_PASID);
+		cdptr = arm_smmu_get_cd_ptr(master, master_domain->ssid);
 		if (WARN_ON(!cdptr))
 			continue;
 
 		arm_smmu_make_s1_cd(&target_cd, master, smmu_domain);
-		arm_smmu_write_cd_entry(master, IOMMU_NO_PASID, cdptr,
+		arm_smmu_write_cd_entry(master, master_domain->ssid, cdptr,
 					&target_cd);
 	}
 	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
@@ -294,8 +293,8 @@ static void arm_smmu_mm_arch_invalidate_secondary_tlbs(struct mmu_notifier *mn,
 						    smmu_domain);
 	}
 
-	arm_smmu_atc_inv_domain(smmu_domain, mm_get_enqcmd_pasid(mm), start,
-				size);
+	arm_smmu_atc_inv_domain_sva(smmu_domain, mm_get_enqcmd_pasid(mm), start,
+				    size);
 }
 
 static void arm_smmu_mm_release(struct mmu_notifier *mn, struct mm_struct *mm)
@@ -332,7 +331,7 @@ static void arm_smmu_mm_release(struct mmu_notifier *mn, struct mm_struct *mm)
 	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
 
 	arm_smmu_tlb_inv_asid(smmu_domain->smmu, smmu_mn->cd->asid);
-	arm_smmu_atc_inv_domain(smmu_domain, mm_get_enqcmd_pasid(mm), 0, 0);
+	arm_smmu_atc_inv_domain_sva(smmu_domain, mm_get_enqcmd_pasid(mm), 0, 0);
 
 	smmu_mn->cleared = true;
 	mutex_unlock(&sva_lock);
@@ -411,8 +410,8 @@ static void arm_smmu_mmu_notifier_put(struct arm_smmu_mmu_notifier *smmu_mn)
 	 */
 	if (!smmu_mn->cleared) {
 		arm_smmu_tlb_inv_asid(smmu_domain->smmu, cd->asid);
-		arm_smmu_atc_inv_domain(smmu_domain, mm_get_enqcmd_pasid(mm), 0,
-					0);
+		arm_smmu_atc_inv_domain_sva(smmu_domain,
+					    mm_get_enqcmd_pasid(mm), 0, 0);
 	}
 
 	/* Frees smmu_mn */
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 01e970f6ee4363..3a7ef73994b57b 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2013,8 +2013,8 @@ static int arm_smmu_atc_inv_master(struct arm_smmu_master *master)
 	return arm_smmu_cmdq_batch_submit(master->smmu, &cmds);
 }
 
-int arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain, int ssid,
-			    unsigned long iova, size_t size)
+static int __arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain,
+				     ioasid_t ssid, unsigned long iova, size_t size)
 {
 	struct arm_smmu_master_domain *master_domain;
 	int i;
@@ -2042,8 +2042,6 @@ int arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain, int ssid,
 	if (!atomic_read(&smmu_domain->nr_ats_masters))
 		return 0;
 
-	arm_smmu_atc_inv_to_cmd(ssid, iova, size, &cmd);
-
 	cmds.num = 0;
 
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
@@ -2054,6 +2052,16 @@ int arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain, int ssid,
 		if (!master->ats_enabled)
 			continue;
 
+		/*
+		 * Non-zero ssid means SVA is co-opting the S1 domain to issue
+		 * invalidations for SVA PASIDs.
+		 */
+		if (ssid != IOMMU_NO_PASID)
+			arm_smmu_atc_inv_to_cmd(ssid, iova, size, &cmd);
+		else
+			arm_smmu_atc_inv_to_cmd(master_domain->ssid, iova, size,
+						&cmd);
+
 		for (i = 0; i < master->num_streams; i++) {
 			cmd.atc.sid = master->streams[i].id;
 			arm_smmu_cmdq_batch_add(smmu_domain->smmu, &cmds, &cmd);
@@ -2064,6 +2072,19 @@ int arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain, int ssid,
 	return arm_smmu_cmdq_batch_submit(smmu_domain->smmu, &cmds);
 }
 
+static int arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain,
+				   unsigned long iova, size_t size)
+{
+	return __arm_smmu_atc_inv_domain(smmu_domain, IOMMU_NO_PASID, iova,
+					 size);
+}
+
+int arm_smmu_atc_inv_domain_sva(struct arm_smmu_domain *smmu_domain,
+				ioasid_t ssid, unsigned long iova, size_t size)
+{
+	return __arm_smmu_atc_inv_domain(smmu_domain, ssid, iova, size);
+}
+
 /* IO_PGTABLE API */
 static void arm_smmu_tlb_inv_context(void *cookie)
 {
@@ -2085,7 +2106,7 @@ static void arm_smmu_tlb_inv_context(void *cookie)
 		cmd.tlbi.vmid	= smmu_domain->s2_cfg.vmid;
 		arm_smmu_cmdq_issue_cmd_with_sync(smmu, &cmd);
 	}
-	arm_smmu_atc_inv_domain(smmu_domain, IOMMU_NO_PASID, 0, 0);
+	arm_smmu_atc_inv_domain(smmu_domain, 0, 0);
 }
 
 static void __arm_smmu_tlb_inv_range(struct arm_smmu_cmdq_ent *cmd,
@@ -2183,7 +2204,7 @@ static void arm_smmu_tlb_inv_range_domain(unsigned long iova, size_t size,
 	 * Unfortunately, this can't be leaf-only since we may have
 	 * zapped an entire table.
 	 */
-	arm_smmu_atc_inv_domain(smmu_domain, IOMMU_NO_PASID, iova, size);
+	arm_smmu_atc_inv_domain(smmu_domain, iova, size);
 }
 
 void arm_smmu_tlb_inv_range_asid(unsigned long iova, size_t size, int asid,
@@ -2518,7 +2539,8 @@ static void arm_smmu_disable_pasid(struct arm_smmu_master *master)
 
 static struct arm_smmu_master_domain *
 arm_smmu_find_master_domain(struct arm_smmu_domain *smmu_domain,
-			    struct arm_smmu_master *master)
+			    struct arm_smmu_master *master,
+			    ioasid_t ssid)
 {
 	struct arm_smmu_master_domain *master_domain;
 
@@ -2526,7 +2548,8 @@ arm_smmu_find_master_domain(struct arm_smmu_domain *smmu_domain,
 
 	list_for_each_entry(master_domain, &smmu_domain->devices,
 			    devices_elm) {
-		if (master_domain->master == master)
+		if (master_domain->master == master &&
+		    master_domain->ssid == ssid)
 			return master_domain;
 	}
 	return NULL;
@@ -2559,7 +2582,8 @@ static void arm_smmu_remove_master_domain(struct arm_smmu_master *master,
 		return;
 
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
-	master_domain = arm_smmu_find_master_domain(smmu_domain, master);
+	master_domain = arm_smmu_find_master_domain(smmu_domain, master,
+						    IOMMU_NO_PASID);
 	if (master_domain) {
 		list_del(&master_domain->devices_elm);
 		kfree(master_domain);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index ce01d3fc768ad6..23d8a5b7912069 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -772,6 +772,7 @@ void arm_smmu_make_sva_cd(struct arm_smmu_cd *target,
 struct arm_smmu_master_domain {
 	struct list_head devices_elm;
 	struct arm_smmu_master *master;
+	ioasid_t ssid;
 };
 
 static inline struct arm_smmu_domain *to_smmu_domain(struct iommu_domain *dom)
@@ -803,8 +804,8 @@ void arm_smmu_tlb_inv_range_asid(unsigned long iova, size_t size, int asid,
 				 size_t granule, bool leaf,
 				 struct arm_smmu_domain *smmu_domain);
 bool arm_smmu_free_asid(struct arm_smmu_ctx_desc *cd);
-int arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain, int ssid,
-			    unsigned long iova, size_t size);
+int arm_smmu_atc_inv_domain_sva(struct arm_smmu_domain *smmu_domain,
+				ioasid_t ssid, unsigned long iova, size_t size);
 
 #ifdef CONFIG_ARM_SMMU_V3_SVA
 bool arm_smmu_sva_supported(struct arm_smmu_device *smmu);
-- 
2.43.2

