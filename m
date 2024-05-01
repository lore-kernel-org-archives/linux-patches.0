Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2064.outbound.protection.outlook.com [40.107.244.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19BB0804;
	Wed,  1 May 2024 00:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714521734; cv=fail; b=C19wcE+G6+cOuDgtLjJOQ7c7TuCqqA22/uoWu4biE+y934ur7UEnlOpEmeayc6PciOZ6nge6qvnRIC3Zxh6+oBmI7XzzxkRTOSp2dfJg92oweaE29JBV9fbWO2Q/WZ5j59Gfu5GAoBqhHjuYjzAXnSXogKMKeKO4CG9cizSUaPU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714521734; c=relaxed/simple;
	bh=Xox/N4fPp/aA+RBSnZRCvVRX+27pR2dQS7UpOKFliyQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=AGdOUuBWgk3bQ1y7TUaKh1XEeB8h7h+A7+J6/KHZtTdUyWuGjBhbuoxphFpCS38x7y+AF3yjuyFNkc0oxTRALlEOHfR5gxQLnnxFFrBST+Jj0w84aXZO/L0lAH2o9BSNn0aBK0u1DO92Iuf/sZLy4V26uvryIS8p9nejGAXSpPU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ELwTR/1D; arc=fail smtp.client-ip=40.107.244.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ELwTR/1D"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=crpLv5OB++L5AKCD9OGND3N0UoGtr/0uwEVinrnRL0a40U5b/E+mHzYVYoK+zfVW4Qg0CY8GSem1EscLUublQPJN/IAqPykEkJypMUw5L2Baf0WTjNolEbYgo1rwvtzHqn2s5iZuP2NSWoFPCgumfe71a6mNwcj1/OqCr1hPOkhCOqO2rWDyHLM/uYPd4vMBGxzyjt/jsCNnYTwljZk85RLa1MLIew3YDJbgE445rcsTJIBeDsqdK3h5eES40CdxSIywE2hur9Sf6Eio1ZW6glqd4j3ZERUIBwgi1DZwcRnMvoyBLZbOzZzwBAj2meM5uSrF04w2j7bz7+Xqbkm+Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o4aCIc648zWTpJHYGKUx8OWl2xNH1QvMyMB1K0E/dJs=;
 b=BDsaee/oQC+7aXbRd2E101F0Axrb3F8IHCtT+rqd3DrgQejdPSzrp3H9EvKCpX+LZ3aZcwLNsZHJtW/KbPXzCORDWtk5s2cQZydevtzUCyVBsLyLFJDORiJXqbiS4QXl1PSloVQ0FL4aFC0p42BlTdGORp6jYNlxvFCsh/MF5cGf/Oo+h4gtnMSR/IZrDJrhchhk18IQd5+sCOE1aBMaI9CVurbi17SxvAaXHZxP1CbVNFmapPbuugxJ3OOOLQ3nGPTndRlzHei6Bx5DRAm5C6VioG5tbmnG35v7JVBS9uppOGPxDw/+14XtSo1ZBov6K0KREDBvXPUq0z0tU3jtow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o4aCIc648zWTpJHYGKUx8OWl2xNH1QvMyMB1K0E/dJs=;
 b=ELwTR/1DPau0wVx2pyD8OLrZVwUFyh7LgUydw2yj009xM+XolQRWzs1yHJOAkwW9PG+HVz4CvpQDTidpD9XCB6m7XUN+W9sv3ZxUHZjUq2QyT1GPkHzj6lQvi6TRTt/H4gA6i0YmorogQt1YcU2tLGnNCioXUzHOvw5D1Y+z39FQQZO5/w9nzFMEnhtCZeOV50TSGALHc5njVnJFd4wliQQjmR6wHggU3dUHU/N3lMPBiJjkn4z2nVuLKKV8A7n1PvIJTgWrCugRUUSQ3loPkA4W3qzuOjAEIMnSPytgjOhlrWOfuBD6f7wT3KqUtAgZFyBvVdk3y5iz4M0MM0KlmA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by LV3PR12MB9353.namprd12.prod.outlook.com (2603:10b6:408:21b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.35; Wed, 1 May
 2024 00:02:08 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%3]) with mapi id 15.20.7519.031; Wed, 1 May 2024
 00:02:08 +0000
Date: Tue, 30 Apr 2024 21:02:06 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: Will Deacon <will@kernel.org>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Eric Auger <eric.auger@redhat.com>, Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>, patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v9 0/9] Make the SMMUv3 CD logic match the new STE design
 (part 2a/3)
Message-ID: <20240501000206.GX941030@nvidia.com>
References: <0-v9-5040dc602008+177d7-smmuv3_newapi_p2_jgg@nvidia.com>
 <ZjFeh68ozFHcQmk2@Asurada-Nvidia>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZjFeh68ozFHcQmk2@Asurada-Nvidia>
X-ClientProxiedBy: MN2PR01CA0040.prod.exchangelabs.com (2603:10b6:208:23f::9)
 To DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|LV3PR12MB9353:EE_
X-MS-Office365-Filtering-Correlation-Id: e05d0379-cc98-4a65-122b-08dc6971f184
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|7416005|366007|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?m+l9fgY3WYzETDxzLHh2xxA+osgtZYiswz92WsRWgVePaAWX7XR4k5h/uVtI?=
 =?us-ascii?Q?IowM2KCe1jOpmgz0KazP43Wbbhv0rfKg7wpvxtHCtM4jVaG17LcSMExqZg7t?=
 =?us-ascii?Q?VN6Pb7KBmo6D7RUij8nU3JhZqkTNNSZ/Wyqu3EOVP+OanKHfQjtcWB3RdO0j?=
 =?us-ascii?Q?JYbK+g7rvPa+X9IsfJGJCjB7zrI5Q2neN+1KVo9ln+oOuKWYupR/b9OkfsWK?=
 =?us-ascii?Q?jMLF3Jjb64Vg4V/1fQ1gEYSEULSSM7BqF+XIvJH0iZJIl/Ls8cxkXnwk+0ft?=
 =?us-ascii?Q?wyCGLtW4FvcoMkLauifUE6rmCfx8Blsvp5ziodcxSLwMf1u8a1OyF5RTZUy6?=
 =?us-ascii?Q?VcFxc4Oj6Rlwd5IvE+2bNhgwqUFzmeWJqQNiplUVDU7Qqy9PAeiEVgl0gQ7V?=
 =?us-ascii?Q?J5Cfzxm9hHW/3Dn2mQiLZy/fGp4HPbz2hhcYvrX4QLo87DyG47sOV12NnQL0?=
 =?us-ascii?Q?s51WVXxlRdyOwZYd8dpVrm3IRwsSpPwxx+XnzUSmVlFUSpD5Z6zwDZgJQjli?=
 =?us-ascii?Q?nc9+vn3/pX3fcaKWqUA/Vv0zArJ2cv/E4qwQGfTbD2ImlL+ddBX2mF/y7bel?=
 =?us-ascii?Q?QeJgH7z+/Orc13t+5bBPL1S1eXKyvK1MOg1sJU1IRVuMO/VdlrYDr6FxHky3?=
 =?us-ascii?Q?NtXuYWbBUr8PykFFNIRkP/WwKeGiEa+OMc0BVFUH+6hOql3V7UFIrt3l/kFI?=
 =?us-ascii?Q?DRniD+YJ/wmQ49+A1Yk/xSUoKlLRThfflRDWWiBgFYNavfeq5odADh9jNgYW?=
 =?us-ascii?Q?WCIUWGB2bU1Rvoq9roMFAP7spfE2WzvbI0Cpg8cyrTqS7O0UBMxfjo40nQAO?=
 =?us-ascii?Q?JVHPunX6PH2RvHb4pkKFzPHZFOQhUzL2plf0iLZbA2PmUutp3XhXkxlN02WM?=
 =?us-ascii?Q?/SIAbD3zxCFYENMRTGEROxUXMTQ/+jaJByPtvGZUFOaj/Vn04MzP6v3SNTUK?=
 =?us-ascii?Q?MedHA7njY0M/80gt0jc3+eEaz6DPDl4mMGCfiSq8hQjEYrHPKewkp5+VS+Qt?=
 =?us-ascii?Q?CISvqNVRR0It236bR9kL5uNxe+MrZiOorWQaT1dfUPtILg71lTAqI13cfGbd?=
 =?us-ascii?Q?OAHFe6z1454KDbr33o/Jq2lspu808SdrFYodys7x5JKOZTruLrJEUlqo20z9?=
 =?us-ascii?Q?SoWHCsvcb9OYHvRxoKqjt139kIOC5KN8fPWsddzrbA6qlq/gzEB+ghUvW2g/?=
 =?us-ascii?Q?D7ToEqJyz72HVXkCPAUSRDk+sCi3688cIje9cW+GQgb5JC7SkbygWShG9+NG?=
 =?us-ascii?Q?HSxqtMXJQGvuC+poBtCBN1nV/T1M5GAseQyPTooOVw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nkIFmOEPuKHfSEoqg2It2E9UWcMRKaxjdDjudgAoJ6cXjazNeVwTJyocs2Fu?=
 =?us-ascii?Q?6Ihd7UFxnzKozwCdWWcMPXy+3e1jygIL95+dFVbpSBvsYaBUWpZg4/AqnZOW?=
 =?us-ascii?Q?6d9EZvXQGV61AJ7ePHBKxPP1NNVhuEPBjQQ9urs3yP2qVCn1r0WOop5fGK81?=
 =?us-ascii?Q?DL8YEx3N0mRNXtyt8JV1UIWZ3cuctcHuf1rvjNSgZ3BAKMACfDCn8trWfglq?=
 =?us-ascii?Q?k7Bp8bvVZii0haLQxPj6qGEqd1B9vLtaTyXZLm8o5kKDqOFA19uAQYpaAERn?=
 =?us-ascii?Q?hdz4jKHKkj/J0vD4BAl48B+g7iFkPoRY+FN0hKFLU36ih7uxQbuStVhufhMr?=
 =?us-ascii?Q?BZseUUufBpBNKEtsYTpAiTWE+wdPZK61t8tR43EdIduvwAUnXlWJRPVEaA0W?=
 =?us-ascii?Q?nLApTKi6oZcZZq6+4fHcE/CL3GD03CAwUaAgdAYTEGoLCjjbRpvyH7mFb0p+?=
 =?us-ascii?Q?bAImnZRFsfqmb7eEvHdNPeEFPInXkqZQ6slpVh799jQg8Yg0Izt/ulgWGMA6?=
 =?us-ascii?Q?nkoshsu0co5Zhrqk4G4mpbac9g/cFygppfEY4oNDjLc0/Wurpu92ryBCXXzv?=
 =?us-ascii?Q?Ce2Cy2dzA9c+u2xd4AxfiGSgZvyRR/dIY+jdzunqu8VTHwzKvLIAihcfjMNV?=
 =?us-ascii?Q?6m7tLu5rSl4KRzbxyOgsGjzfZeOS7ToSKlZB6F3f6poYkZktN17vfcbx0EKL?=
 =?us-ascii?Q?JRkPO0YOQLQp3umPIOo13TbU6LVG2I3oQ/pD2PF6x/zwe5o1XFTO0UgtXlql?=
 =?us-ascii?Q?joWq8bDDEZvgDzDVl9qhNSg4VIrs0mMRXm4+oESieHoxeLWpgfPQgBai/wcC?=
 =?us-ascii?Q?cBGZAHhNhoDU2Qkrz8RDsq2YdJL1ELVNttLnEeUdhfogSCDL3ctbBEdiDbAC?=
 =?us-ascii?Q?fuxeXq3e/CQMh7nAbSoMcGOhKv3uWi/EhhilEqW92M9TQDNwUR0jcyDyphc3?=
 =?us-ascii?Q?SuuPQg2FVP8enN8xWO1KEKQEOT7E/GxnvfuCVN/zqTsbsJ99IixQWNdybvvW?=
 =?us-ascii?Q?1WgGeF1GSGCixFbBSWL7yhyVpu5zX+tKq7Zoos66lWcdf9qeWVlYcWA6ruBm?=
 =?us-ascii?Q?fjVlvdpJ5SNh14ggRpIWgTYZBjGeEbct5yMYKCM2aQD/z6NI/0HRZ7Thnwqt?=
 =?us-ascii?Q?3ARMLzpUluojWN5+jTca7hdc7zx4wKJVRoHk98Q8awCYEZYbxQmgOS/0YyEA?=
 =?us-ascii?Q?ur39jtB224XXZMZHXaXZ4Teyf3CLSyZMQnmPV9Y8vTq3HaJ89cRKF7lZob6H?=
 =?us-ascii?Q?2/xOLzYs1pr9pQ6e+IGdSJWzRYazkIvikwGfXAU77gxRsecS9TwBPKPLgAGa?=
 =?us-ascii?Q?GruxL9XbBkgO7BkZUUeK7YjL4jD5nLrlEmWGt6OSK3YXf8BSeHMlfBLLhdyH?=
 =?us-ascii?Q?7vWl4bB1C4SECf6R+xx3V7Hs5egCZshqbkIKi8gcJ2RoenjXuwxQ5s52iJfi?=
 =?us-ascii?Q?i8LLLn/TnDIumnEcFzcBv+RDPqBeF5VeHykFe+ZZWHgh3naDXXJz1XJN8T4b?=
 =?us-ascii?Q?NlDdzE75OaCz11L59TFvvHQSNa1CBeSLl/VA/oiTvKLw1+819nkFdDsNT6gq?=
 =?us-ascii?Q?pAonHiO5vtqjdgY9gEkYqLEuM5c7F/JW3ykUf10z?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e05d0379-cc98-4a65-122b-08dc6971f184
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2024 00:02:08.5697
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uvRnNIw9/gEfM96xIWMN2jN5ZhhZV5EVyGXkuDz+54OSbSlWU4LdkffxkDKJ9Zts
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9353

On Tue, Apr 30, 2024 at 02:11:35PM -0700, Nicolin Chen wrote:
> On Tue, Apr 30, 2024 at 02:21:32PM -0300, Jason Gunthorpe wrote:
> > v9:
> >  - Remove arm_smmu_clean_cd_entry() and instead zero the required CD bits
> >    inside arm_smmu_write_ctx_desc()
> 
> SVA sanity works well with v9 as my previous test on v7.

Yeah, very little changed in the main code after everything is
applied. Most of the edits were adjusting interior patches

Here is the diff from v7 to v9.

Thanks,
Jason

diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index 2e597102baf6e5..f872aeccd82041 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -411,8 +411,9 @@ config ARM_SMMU_V3_SVA
 	  and PRI.
 
 config ARM_SMMU_V3_KUNIT_TEST
-	tristate "KUnit tests for arm-smmu-v3 driver"  if !KUNIT_ALL_TESTS
+	bool "KUnit tests for arm-smmu-v3 driver"  if !KUNIT_ALL_TESTS
 	depends on KUNIT
+	depends on ARM_SMMU_V3_SVA
 	default KUNIT_ALL_TESTS
 	help
 	  Enable this option to unit-test arm-smmu-v3 driver functions.
diff --git a/drivers/iommu/arm/arm-smmu-v3/Makefile b/drivers/iommu/arm/arm-smmu-v3/Makefile
index 014a997753a8a2..0b97054b3929b7 100644
--- a/drivers/iommu/arm/arm-smmu-v3/Makefile
+++ b/drivers/iommu/arm/arm-smmu-v3/Makefile
@@ -2,6 +2,5 @@
 obj-$(CONFIG_ARM_SMMU_V3) += arm_smmu_v3.o
 arm_smmu_v3-objs-y += arm-smmu-v3.o
 arm_smmu_v3-objs-$(CONFIG_ARM_SMMU_V3_SVA) += arm-smmu-v3-sva.o
+arm_smmu_v3-objs-$(CONFIG_ARM_SMMU_V3_KUNIT_TEST) += arm-smmu-v3-test.o
 arm_smmu_v3-objs := $(arm_smmu_v3-objs-y)
-
-obj-$(CONFIG_ARM_SMMU_V3_KUNIT_TEST) += arm-smmu-v3-test.o
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index f56a2d38012b5c..34a977a0767d46 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -8,6 +8,7 @@
 #include <linux/mmu_notifier.h>
 #include <linux/sched/mm.h>
 #include <linux/slab.h>
+#include <kunit/visibility.h>
 
 #include "arm-smmu-v3.h"
 #include "../../io-pgtable-arm.h"
@@ -120,6 +121,7 @@ static u64 page_size_to_cd(void)
 	return ARM_LPAE_TCR_TG0_4K;
 }
 
+VISIBLE_IF_KUNIT
 void arm_smmu_make_sva_cd(struct arm_smmu_cd *target,
 			  struct arm_smmu_master *master, struct mm_struct *mm,
 			  u16 asid)
@@ -172,8 +174,7 @@ void arm_smmu_make_sva_cd(struct arm_smmu_cd *target,
 		 * disable is permitted. This speeds up cleanup for an unclean
 		 * exit if the device is still doing a lot of DMA.
 		 */
-		if (master->stall_enabled &&
-		    !(master->smmu->features & ARM_SMMU_FEAT_STALL_FORCE))
+		if (!(master->smmu->features & ARM_SMMU_FEAT_STALL_FORCE))
 			target->data[0] &=
 				cpu_to_le64(~(CTXDESC_CD_0_S | CTXDESC_CD_0_R));
 	}
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
index 14c8e40712a70e..417804392ff089 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
@@ -26,6 +26,9 @@ static struct arm_smmu_ste abort_ste;
 static struct arm_smmu_device smmu = {
 	.features = ARM_SMMU_FEAT_STALLS | ARM_SMMU_FEAT_ATTR_TYPES_OVR
 };
+static struct mm_struct sva_mm = {
+	.pgd = (void *)0xdaedbeefdeadbeefULL,
+};
 
 static bool arm_smmu_entry_differs_in_used_bits(const __le64 *entry,
 						const __le64 *used_bits,
@@ -61,7 +64,7 @@ arm_smmu_test_writer_record_syncs(struct arm_smmu_entry_writer *writer)
 			     false);
 
 	test_writer->num_syncs += 1;
-	if (!(test_writer->entry[0] & writer->ops->v_bit)) {
+	if (!test_writer->entry[0]) {
 		test_writer->invalid_entry_written = true;
 	} else {
 		/*
@@ -96,13 +99,11 @@ arm_smmu_v3_test_debug_print_used_bits(struct arm_smmu_entry_writer *writer,
 }
 
 static const struct arm_smmu_entry_writer_ops test_ste_ops = {
-	.v_bit = cpu_to_le64(STRTAB_STE_0_V),
 	.sync = arm_smmu_test_writer_record_syncs,
 	.get_used = arm_smmu_get_ste_used,
 };
 
 static const struct arm_smmu_entry_writer_ops test_cd_ops = {
-	.v_bit = cpu_to_le64(CTXDESC_CD_0_V),
 	.sync = arm_smmu_test_writer_record_syncs,
 	.get_used = arm_smmu_get_cd_used,
 };
@@ -392,11 +393,8 @@ static void arm_smmu_test_make_sva_cd(struct arm_smmu_cd *cd, unsigned int asid)
 	struct arm_smmu_master master = {
 		.smmu = &smmu,
 	};
-	struct mm_struct mm = {
-		.pgd = (void *)0xdaedbeefdeadbeefULL,
-	};
 
-	arm_smmu_make_sva_cd(cd, &master, &mm, asid);
+	arm_smmu_make_sva_cd(cd, &master, &sva_mm, asid);
 }
 
 static void arm_smmu_test_make_sva_release_cd(struct arm_smmu_cd *cd,
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 3ffaa3b34b44bf..15bad76cf84a61 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -26,6 +26,7 @@
 #include <linux/pci.h>
 #include <linux/pci-ats.h>
 #include <linux/platform_device.h>
+#include <kunit/visibility.h>
 
 #include "arm-smmu-v3.h"
 #include "../../dma-iommu.h"
@@ -968,6 +969,7 @@ void arm_smmu_tlb_inv_asid(struct arm_smmu_device *smmu, u16 asid)
  * would be nice if this was complete according to the spec, but minimally it
  * has to capture the bits this driver uses.
  */
+VISIBLE_IF_KUNIT
 void arm_smmu_get_ste_used(const __le64 *ent, __le64 *used_bits)
 {
 	unsigned int cfg = FIELD_GET(STRTAB_STE_0_CFG, le64_to_cpu(ent[0]));
@@ -1090,6 +1092,7 @@ static bool entry_set(struct arm_smmu_entry_writer *writer, __le64 *entry,
  * V=0 process. This relies on the IGNORED behavior described in the
  * specification.
  */
+VISIBLE_IF_KUNIT
 void arm_smmu_write_entry(struct arm_smmu_entry_writer *writer, __le64 *entry,
 			  const __le64 *target)
 {
@@ -1124,7 +1127,7 @@ void arm_smmu_write_entry(struct arm_smmu_entry_writer *writer, __le64 *entry,
 		 * requires a breaking update, zero the V bit, write all qwords
 		 * but 0, then set qword 0
 		 */
-		unused_update[0] = entry[0] & (~writer->ops->v_bit);
+		unused_update[0] = 0;
 		entry_set(writer, entry, unused_update, 0, 1);
 		entry_set(writer, entry, target, 1, NUM_ENTRY_QWORDS - 1);
 		entry_set(writer, entry, target, 0, 1);
@@ -1221,7 +1224,7 @@ struct arm_smmu_cd *arm_smmu_alloc_cd_ptr(struct arm_smmu_master *master,
 	}
 
 	if (cd_table->s1fmt == STRTAB_STE_0_S1FMT_64K_L2) {
-		unsigned int idx = ssid >> CTXDESC_SPLIT;
+		unsigned int idx = ssid / CTXDESC_L2_ENTRIES;
 		struct arm_smmu_l1_ctx_desc *l1_desc;
 
 		l1_desc = &cd_table->l1_desc[idx];
@@ -1245,6 +1248,7 @@ struct arm_smmu_cd_writer {
 	unsigned int ssid;
 };
 
+VISIBLE_IF_KUNIT
 void arm_smmu_get_cd_used(const __le64 *ent, __le64 *used_bits)
 {
 	used_bits[0] = cpu_to_le64(CTXDESC_CD_0_V);
@@ -1252,7 +1256,10 @@ void arm_smmu_get_cd_used(const __le64 *ent, __le64 *used_bits)
 		return;
 	memset(used_bits, 0xFF, sizeof(struct arm_smmu_cd));
 
-	/* EPD0 means T0SZ/TG0/IR0/OR0/SH0/TTB0 are IGNORED */
+	/*
+	 * If EPD0 is set by the make function it means
+	 * T0SZ/TG0/IR0/OR0/SH0/TTB0 are IGNORED
+	 */
 	if (ent[0] & cpu_to_le64(CTXDESC_CD_0_TCR_EPD0)) {
 		used_bits[0] &= ~cpu_to_le64(
 			CTXDESC_CD_0_TCR_T0SZ | CTXDESC_CD_0_TCR_TG0 |
@@ -1273,7 +1280,6 @@ static void arm_smmu_cd_writer_sync_entry(struct arm_smmu_entry_writer *writer)
 static const struct arm_smmu_entry_writer_ops arm_smmu_cd_writer_ops = {
 	.sync = arm_smmu_cd_writer_sync_entry,
 	.get_used = arm_smmu_get_cd_used,
-	.v_bit = cpu_to_le64(CTXDESC_CD_0_V),
 };
 
 void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
@@ -1472,7 +1478,6 @@ static void arm_smmu_ste_writer_sync_entry(struct arm_smmu_entry_writer *writer)
 static const struct arm_smmu_entry_writer_ops arm_smmu_ste_writer_ops = {
 	.sync = arm_smmu_ste_writer_sync_entry,
 	.get_used = arm_smmu_get_ste_used,
-	.v_bit = cpu_to_le64(STRTAB_STE_0_V),
 };
 
 static void arm_smmu_write_ste(struct arm_smmu_master *master, u32 sid,
@@ -1502,6 +1507,7 @@ static void arm_smmu_write_ste(struct arm_smmu_master *master, u32 sid,
 	}
 }
 
+VISIBLE_IF_KUNIT
 void arm_smmu_make_abort_ste(struct arm_smmu_ste *target)
 {
 	memset(target, 0, sizeof(*target));
@@ -1510,6 +1516,7 @@ void arm_smmu_make_abort_ste(struct arm_smmu_ste *target)
 		FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_ABORT));
 }
 
+VISIBLE_IF_KUNIT
 void arm_smmu_make_bypass_ste(struct arm_smmu_device *smmu,
 			      struct arm_smmu_ste *target)
 {
@@ -1523,6 +1530,7 @@ void arm_smmu_make_bypass_ste(struct arm_smmu_device *smmu,
 							 STRTAB_STE_1_SHCFG_INCOMING));
 }
 
+VISIBLE_IF_KUNIT
 void arm_smmu_make_cdtable_ste(struct arm_smmu_ste *target,
 			       struct arm_smmu_master *master)
 {
@@ -1573,6 +1581,7 @@ void arm_smmu_make_cdtable_ste(struct arm_smmu_ste *target,
 	}
 }
 
+VISIBLE_IF_KUNIT
 void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
 				 struct arm_smmu_master *master,
 				 struct arm_smmu_domain *smmu_domain)
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 0455498d24c730..1242a086c9f948 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -275,8 +275,7 @@ struct arm_smmu_ste {
  * 2lvl: at most 1024 L1 entries,
  *       1024 lazy entries per table.
  */
-#define CTXDESC_SPLIT			10
-#define CTXDESC_L2_ENTRIES		(1 << CTXDESC_SPLIT)
+#define CTXDESC_L2_ENTRIES		1024
 
 #define CTXDESC_L1_DESC_DWORDS		1
 #define CTXDESC_L1_DESC_V		(1UL << 0)
@@ -745,16 +744,15 @@ struct arm_smmu_entry_writer {
 };
 
 struct arm_smmu_entry_writer_ops {
-	__le64 v_bit;
 	void (*get_used)(const __le64 *entry, __le64 *used);
 	void (*sync)(struct arm_smmu_entry_writer *writer);
 };
 
+#if IS_ENABLED(CONFIG_KUNIT)
 void arm_smmu_get_ste_used(const __le64 *ent, __le64 *used_bits);
-void arm_smmu_get_cd_used(const __le64 *ent, __le64 *used_bits);
 void arm_smmu_write_entry(struct arm_smmu_entry_writer *writer, __le64 *cur,
 			  const __le64 *target);
-
+void arm_smmu_get_cd_used(const __le64 *ent, __le64 *used_bits);
 void arm_smmu_make_abort_ste(struct arm_smmu_ste *target);
 void arm_smmu_make_bypass_ste(struct arm_smmu_device *smmu,
 			      struct arm_smmu_ste *target);
@@ -766,6 +764,7 @@ void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
 void arm_smmu_make_sva_cd(struct arm_smmu_cd *target,
 			  struct arm_smmu_master *master, struct mm_struct *mm,
 			  u16 asid);
+#endif
 
 static inline struct arm_smmu_domain *to_smmu_domain(struct iommu_domain *dom)
 {
