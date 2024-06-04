Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2043.outbound.protection.outlook.com [40.107.93.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6B26817;
	Tue,  4 Jun 2024 00:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717460174; cv=fail; b=BTP3STA1EMbVVSmDgnEDsY7QPkTaCNCVAlvHwy4Gj35Ek2Up2JNylxq/hbAcv7Z+oLmPAA7a3nbuJRRxTAdSm5oNQDjhh50TTpSkYkQ3yuUBh/5Xx4v+uscrorKquXBwnsXDH/ghOhS3FfxprQEfRXHweEakZvE1mrjEKD3wiHo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717460174; c=relaxed/simple;
	bh=PGHWFhcg4Ka7nYXx3IlHEL2FJfMz/adb60AtquVMxTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Y0vpI817HMLSYBp8wtmCVTqPFVgXzYHnKZeDDY8Co8B9lIdsLS3JsWeCddtYcumKvIS36fUqXsj3m7M81q2VLy//czOPybARyYMLTb1p27XTeBKbb0K7bAVp7Yh18RQ5R+yVHSp3Exc5Lzvwf9NOmUIU885bfBoxKh54XdaOcIU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=MedyiXXu; arc=fail smtp.client-ip=40.107.93.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="MedyiXXu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hrWKFWbyZndVVvfpdjjcJeflH5J5+VMn6cSylbPNBtEjEG6Z2YJ85SNNSh6844rHuymayiyt+J0OnBzuvNp1HJuGM599ASe6rqT+Dd42Dz1HxRWez5tLjqxGUxLyDtWUdRRtGVXKlevgvSgyu4BvZqNibhbLc4tr83WyYP/26Hvpp3oTqZdo1hbUQEzrTVkbagy20+s1UUH9Nud8OLlDzzbeHEYsf1Sg0EzvLIQjBGB3E0mMesVr+aJD1zOzjxlQsGEGcl5c8MjyuwtcjLoYfcSarHHlnt3iJ/RswC2RkKCCFgetD2K0L+A9Ot7c0Nb3PjdJwg+TeWQ94EoEpHZ42w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LFGnmC08nDxpDc7TIKR3BN1D1je7H6LGFfYUsnAkzC0=;
 b=ftTwUCo+l+Mzc8jESGVfpfQjSLZBh4zaGuR++Jnf/z0/ir7tFyhK3e4clWax/cz1tKLG5p/yLLVKkQgJEPKAAsXKZQGJOK9wlpfFfA5agvn4AZobZZeauIsZ8Cab8ohmIMPx/6IRiZ7pB46Gi4j41G5yr7TkTi8P/dFHmv1z0tP50taP9rKAEgKZfhp0YgOW3hL5RuNSu6JSTkfWUCiAAg/dn2fUUMaSCm4YG7oW5oxMqnkLH/88bNIbl8RLMkNKlOzQ7oFzle0Q72avNf+95siv+banKnCt4Sh+Tx/3lZs9LF+HHzhlMRJl0ETM377To41GhnD1mLUn93O6Ffj5tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LFGnmC08nDxpDc7TIKR3BN1D1je7H6LGFfYUsnAkzC0=;
 b=MedyiXXuJimlwYVPUaYGrSU3y3ynF539SkRxeT25/5rjA530j4uR7aZaFjc9U36jXCqL6aYsn5dccysBaeREnBUkWbchonC15zO95Myrw4BsQ6Mz+hRFlOe9OlKebS7eQrM4I+ZufnmN9hNIhMJmSJiUEMHQ9aTNFpf8OngrEJEoOwPp4qjTP+335+RjOCcmnnrFZBA11vOjPOY2Qcc0JQTiIUAA5gm+Oj98W+4j8VbgKkiQdUPDiMh4GsRr7QHEQUrJ8g5wrHffYr21IoWxGGUIt4xpjZ2pUb8+lukxOwgnJ1aZ6AXzRIif5uKK1IEriC40EnaDeZNr0YE756kzew==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by MN0PR12MB6296.namprd12.prod.outlook.com (2603:10b6:208:3d3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.21; Tue, 4 Jun
 2024 00:16:03 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7633.021; Tue, 4 Jun 2024
 00:16:03 +0000
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
Subject: [PATCH v8 11/14] iommu/arm-smmu-v3: Allow IDENTITY/BLOCKED to be set while PASID is used
Date: Mon,  3 Jun 2024 21:15:56 -0300
Message-ID: <11-v8-6f85cdc10ce7+563e-smmuv3_newapi_p2b_jgg@nvidia.com>
In-Reply-To: <0-v8-6f85cdc10ce7+563e-smmuv3_newapi_p2b_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAP220CA0010.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::15) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|MN0PR12MB6296:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c4e506b-01ed-423f-b758-08dc842b8497
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|7416005|1800799015|366007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IKaH3MVcGUdDq2q7Grc7jfaWx6nmvoG7q/86E6UOJ987vv01ZQalMx455bYO?=
 =?us-ascii?Q?ei3w57D/lZu2iZi30K6HAzrDwoBhaiFo/MyO+soWaPlkERqgxHaSlRdCjkVj?=
 =?us-ascii?Q?Nq5A8r+GISkp1v/U3OG0olr+xRtrc/0wM1UR5uYvUN8YXkvY4glZEOcmUnSr?=
 =?us-ascii?Q?r5L0W5p7jYVnAhW3glPgOI9PxwEnflTltzjonaBFOso9PBU2+Hz9pWmxqHtt?=
 =?us-ascii?Q?fDm9ciDXQqujc+QYL1FU2W/eOpYeYb4Bdv3mGu7jRCsSWGKi3Mitzq3xrzOu?=
 =?us-ascii?Q?+Z13fupeB8WpsxwkgY7pgFpz30Mwy0dI9Onb2YAITvmp01giOiA3DAINaXqF?=
 =?us-ascii?Q?gnjxdoinzLrtLpJ2ryr785k3bvKpONVJl0247bhIhcYzuPCgfKOMNMGeEyAS?=
 =?us-ascii?Q?vhptfoYEFNRthM+aNkRUBAjpoWHUW9XcZxd3tJl2J2G9gC6A8Gescz67PVLW?=
 =?us-ascii?Q?ckaXkhMPTc+nCf5RwldyGN0rxFvZsCF6F+ejxY3zcg7OKeEpXKw9yxHXb1Ms?=
 =?us-ascii?Q?f1wH9sWmoSWISlBMqc7+BV5gE78TMbOGcO1beiSe/7tfOGjGRggLKI73+Vfa?=
 =?us-ascii?Q?6DuY2D2FfDbliaGNniYkpr6vSmU2ftoTyK1A/9/n8bx7X25CQcrVw0Q4QDns?=
 =?us-ascii?Q?C7CbftuIsczTedfCGXUTeth2H6CJHhhXKMI2yghCfFzHdBKS2pT7orW9ickC?=
 =?us-ascii?Q?6STKpPsHAh6eRAy1xVA35B7r3CFvbWVA+1yntLwUVL3Y9S7b4WodbIwrxOZ+?=
 =?us-ascii?Q?ohwIBv9xAsyUHpo6icx0FweImPAtZfamj9YDgyELvP+aH5J1xvXvmT/VQozA?=
 =?us-ascii?Q?lvcH9qT1/pvdaxC9wEXrbCv5xV3I/Mud2TJM4K46PRcjpg03DMjidTkln5Al?=
 =?us-ascii?Q?Bepr34Zc5hbR7uCQMU5tb3vNIE3YEUrMGS7gbzuTDr1gnyg7jIdtE6yKNvEC?=
 =?us-ascii?Q?O6MKhOuO75a7Imj+CI1E5RCRXuFlENh4ApVoniN7tPm3SrhWZQhLCyEuB6p5?=
 =?us-ascii?Q?Jkd3C3pjH6vw6Yl3lY5cEmPiAjs2EaYC/FCIR5b5R1IlPu/A3HX8dbwRAkJG?=
 =?us-ascii?Q?9t+mwD5q34/1aQWEdU9TVBrsfSngPmp3ubeNo0z947bWjV0Kv+Ms1Gd0z4UO?=
 =?us-ascii?Q?V/z9gMR5WVgrXL3aFGUuDMMebc5fO6CWNViVrbgXlFEskT6TlyNbL5mHO8oa?=
 =?us-ascii?Q?8L0+jQs377132BNYjwbKphavxLsM/aGvU3ROxs63yI74Xhzc13nZCPy9TFPL?=
 =?us-ascii?Q?lrM6V3oud7XTi2uwgzyVDswXvISp+fhEh/osD+27qw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HB5WbFNTUpp2QXWUqLviWSVD8yQ6ti7i0bzbto37GLr4wH4fOPoU+G/4myL4?=
 =?us-ascii?Q?L0gYgsM7qhQfg3QSDOdjbH9da7hxueMQrB4j0485ckIEUESc6E/5UGOajQk1?=
 =?us-ascii?Q?NGjpbgvg617gfXepMefQzLX6Ji0u4uq/JXCyf+iXwdWYri6cEd0y6y1j7onQ?=
 =?us-ascii?Q?BKp6+0e0cuV/k1j/eA72eUlSjAuJJpmS8iOKQ58Bn1LpJ4vfL3oHMvN/OYY7?=
 =?us-ascii?Q?cA0WVVRWgRjXdaCv6Y/FNomRxdTUjdDrRYxDGwo96zzs6qoUZ/HeJVgczlAU?=
 =?us-ascii?Q?JNNw2T8TJfgEpL3daXBDnNjsE50QH9qTkYKM/ua9joytV+kgqF75JTJ6flf5?=
 =?us-ascii?Q?7BPpWcMRgbwNddOBmGkufORqfBsrm3ew+H7E6RTtY+gDWcGMqCEY1do7+y0U?=
 =?us-ascii?Q?1+c+JQruHO7aTT+0s9SbiQPGoSL9tASzNy+gk1WsR2q1WGy131xBthnlAV07?=
 =?us-ascii?Q?3x3lGliNKoSq+UlNMOnG9xKTmuIhXZqrH4UG39HckUnHP/ii+VWJF8NLC1K1?=
 =?us-ascii?Q?YlWjSBYa/u5VEblaYo0RDoBiP90jCnK2JnwKAZJSqcoAMM4ApVrvsASWf5IH?=
 =?us-ascii?Q?sVsgHNTPh7TkmT2vNPsF+kx3WpeBu3rCClifS6IzWj0RoB8DWqcP3n91uN/6?=
 =?us-ascii?Q?9v7s2TbM+ndZT0+aICPA65Otszq9tbMzKIcUoCSU6BsPJKy9RGKNOdcl6l24?=
 =?us-ascii?Q?LeLRRsGDc1tcjMtHQCxQtt26PR4j/PYrYM3f6J5kXyNh/EW7lyzeF+8AkYDn?=
 =?us-ascii?Q?wPJBDnjFIrJC9p5Y9vebZUpTU76jEt5v54uGoQzhcvoLXepHhdFJ1Xl8UlAG?=
 =?us-ascii?Q?LvEbOvL73yfCMJ6KiaKGDxhYAyTbPLJnKu+M0K5bhriV36lenlNtKZJwx3AR?=
 =?us-ascii?Q?GP+ZfRl3bVIfPo0HgzE+PwiPRVCpMxBFfO65o1Sbsv14a3Q96B+mG0NQbb48?=
 =?us-ascii?Q?J0800E/Nq60LDD9YLXk3X6jbjbcTD+oM+PWLcc2Qe1Lx7s3AW0K17dhk8+49?=
 =?us-ascii?Q?9FTE6nv8FIciNJn3FY4QC3FGWGQ/VPFu5RPQnJrP6SPJJPuexIWM+ilHWhOj?=
 =?us-ascii?Q?xwBymb46GsN6SiuaFC82oBysZY7R6bFq3GhAAkPVvMvgpetrsmDV6p7ir9gt?=
 =?us-ascii?Q?t+Q2AHN8giOPC1SfFIW6lYD7JJknm7KerTezEZ3SR4GodLorZlwctx3Xf571?=
 =?us-ascii?Q?zUxox+b7m32fu0V19ZGxWUvemO8R05u3+WAOYzeL737kl+Mx1EbJhViC3zMV?=
 =?us-ascii?Q?oqmWMygXAXgyjz9WnyrmCloeZJ9HgHEBXaRKygYZAVqamcEcyplrc+Nrm2qa?=
 =?us-ascii?Q?wFhsJw7EG3kQMb7g1jgveRa1QxJFpgSgoLDad2mVMlR3yzw1r/f2nLJYdYpL?=
 =?us-ascii?Q?GaOzMvIjoAUX/by4hxZ5S5olmxIY8EjV2v2NCGQXx7pGkQi4cmv5/osmoGzT?=
 =?us-ascii?Q?RBBt0jVEPry1EUE3QLUHG4P5PcUJdmkwhw0E4Jj6NCj6Ffh2HNALoeEWn28y?=
 =?us-ascii?Q?fncMvarBRZd4g9ayETwNcswMFp057Ahwe64OHbYzpGnyuV/fVcYFDz7kyBRO?=
 =?us-ascii?Q?K/wxO6vPRyL68Wtfvyo=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c4e506b-01ed-423f-b758-08dc842b8497
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2024 00:16:02.5058
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H3yhqUf49YxXQWR0X7pZreXwOVShFD7bF5SNk57oMjgJ1j5dUezd5I2JPLQQWjto
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6296

The HW supports this, use the S1DSS bits to configure the behavior
of SSID=0 which is the RID's translation.

If SSID's are currently being used in the CD table then just update the
S1DSS bits in the STE, remove the master_domain and leave ATS alone.

For iommufd the driver design has a small problem that all the unused CD
table entries are set with V=0 which will generate an event if VFIO
userspace tries to use the CD entry. This patch extends this problem to
include the RID as well if PASID is being used.

For BLOCKED with used PASIDs the
F_STREAM_DISABLED (STRTAB_STE_1_S1DSS_TERMINATE) event is generated on
untagged traffic and a substream CD table entry with V=0 (removed pasid)
will generate C_BAD_CD. Arguably there is no advantage to using S1DSS over
the CD entry 0 with V=0.

As we don't yet support PASID in iommufd this is a problem to resolve
later, possibly by using EPD0 for unused CD table entries instead of V=0,
and not using S1DSS for BLOCKED.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c  |  2 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 60 +++++++++++++++----
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  4 +-
 3 files changed, 50 insertions(+), 16 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
index a460b71f585789..d7e022bb9df530 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
@@ -164,7 +164,7 @@ static void arm_smmu_test_make_cdtable_ste(struct arm_smmu_ste *ste,
 		.smmu = &smmu,
 	};
 
-	arm_smmu_make_cdtable_ste(ste, &master, true);
+	arm_smmu_make_cdtable_ste(ste, &master, true, STRTAB_STE_1_S1DSS_SSID0);
 }
 
 static void arm_smmu_v3_write_ste_test_bypass_to_abort(struct kunit *test)
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 2a845ab6d53b57..1b43fc1fe85387 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -991,6 +991,14 @@ void arm_smmu_get_ste_used(const __le64 *ent, __le64 *used_bits)
 				    STRTAB_STE_1_S1STALLD | STRTAB_STE_1_STRW |
 				    STRTAB_STE_1_EATS);
 		used_bits[2] |= cpu_to_le64(STRTAB_STE_2_S2VMID);
+
+		/*
+		 * See 13.5 Summary of attribute/permission configuration fields
+		 * for the SHCFG behavior.
+		 */
+		if (FIELD_GET(STRTAB_STE_1_S1DSS, le64_to_cpu(ent[1])) ==
+		    STRTAB_STE_1_S1DSS_BYPASS)
+			used_bits[1] |= cpu_to_le64(STRTAB_STE_1_SHCFG);
 	}
 
 	/* S2 translates */
@@ -1531,7 +1539,8 @@ EXPORT_SYMBOL_IF_KUNIT(arm_smmu_make_bypass_ste);
 
 VISIBLE_IF_KUNIT
 void arm_smmu_make_cdtable_ste(struct arm_smmu_ste *target,
-			       struct arm_smmu_master *master, bool ats_enabled)
+			       struct arm_smmu_master *master, bool ats_enabled,
+			       unsigned int s1dss)
 {
 	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
 	struct arm_smmu_device *smmu = master->smmu;
@@ -1545,7 +1554,7 @@ void arm_smmu_make_cdtable_ste(struct arm_smmu_ste *target,
 		FIELD_PREP(STRTAB_STE_0_S1CDMAX, cd_table->s1cdmax));
 
 	target->data[1] = cpu_to_le64(
-		FIELD_PREP(STRTAB_STE_1_S1DSS, STRTAB_STE_1_S1DSS_SSID0) |
+		FIELD_PREP(STRTAB_STE_1_S1DSS, s1dss) |
 		FIELD_PREP(STRTAB_STE_1_S1CIR, STRTAB_STE_1_S1C_CACHE_WBRA) |
 		FIELD_PREP(STRTAB_STE_1_S1COR, STRTAB_STE_1_S1C_CACHE_WBRA) |
 		FIELD_PREP(STRTAB_STE_1_S1CSH, ARM_SMMU_SH_ISH) |
@@ -1556,6 +1565,11 @@ void arm_smmu_make_cdtable_ste(struct arm_smmu_ste *target,
 		FIELD_PREP(STRTAB_STE_1_EATS,
 			   ats_enabled ? STRTAB_STE_1_EATS_TRANS : 0));
 
+	if ((smmu->features & ARM_SMMU_FEAT_ATTR_TYPES_OVR) &&
+	    s1dss == STRTAB_STE_1_S1DSS_BYPASS)
+		target->data[1] |= cpu_to_le64(FIELD_PREP(
+			STRTAB_STE_1_SHCFG, STRTAB_STE_1_SHCFG_INCOMING));
+
 	if (smmu->features & ARM_SMMU_FEAT_E2H) {
 		/*
 		 * To support BTM the streamworld needs to match the
@@ -2579,6 +2593,7 @@ struct arm_smmu_attach_state {
 	/* Inputs */
 	struct iommu_domain *old_domain;
 	struct arm_smmu_master *master;
+	bool cd_needs_ats;
 	ioasid_t ssid;
 	/* Resulting state */
 	bool ats_enabled;
@@ -2621,7 +2636,7 @@ static int arm_smmu_attach_prepare(struct arm_smmu_attach_state *state,
 	 */
 	lockdep_assert_held(&arm_smmu_asid_lock);
 
-	if (smmu_domain) {
+	if (smmu_domain || state->cd_needs_ats) {
 		/*
 		 * The SMMU does not support enabling ATS with bypass/abort.
 		 * When the STE is in bypass (STE.Config[2:0] == 0b100), ATS
@@ -2633,7 +2648,9 @@ static int arm_smmu_attach_prepare(struct arm_smmu_attach_state *state,
 		 * tables.
 		 */
 		state->ats_enabled = arm_smmu_ats_supported(master);
+	}
 
+	if (smmu_domain) {
 		master_domain = kzalloc(sizeof(*master_domain), GFP_KERNEL);
 		if (!master_domain)
 			return -ENOMEM;
@@ -2761,7 +2778,8 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 		arm_smmu_make_s1_cd(&target_cd, master, smmu_domain);
 		arm_smmu_write_cd_entry(master, IOMMU_NO_PASID, cdptr,
 					&target_cd);
-		arm_smmu_make_cdtable_ste(&target, master, state.ats_enabled);
+		arm_smmu_make_cdtable_ste(&target, master, state.ats_enabled,
+					  STRTAB_STE_1_S1DSS_SSID0);
 		arm_smmu_install_ste_for_dev(master, &target);
 		break;
 	}
@@ -2835,8 +2853,10 @@ static void arm_smmu_remove_dev_pasid(struct device *dev, ioasid_t pasid,
 	mutex_unlock(&arm_smmu_asid_lock);
 }
 
-static int arm_smmu_attach_dev_ste(struct iommu_domain *domain,
-				   struct device *dev, struct arm_smmu_ste *ste)
+static void arm_smmu_attach_dev_ste(struct iommu_domain *domain,
+				    struct device *dev,
+				    struct arm_smmu_ste *ste,
+				    unsigned int s1dss)
 {
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
 	struct arm_smmu_attach_state state = {
@@ -2845,16 +2865,28 @@ static int arm_smmu_attach_dev_ste(struct iommu_domain *domain,
 		.ssid = IOMMU_NO_PASID,
 	};
 
-	if (arm_smmu_ssids_in_use(&master->cd_table))
-		return -EBUSY;
-
 	/*
 	 * Do not allow any ASID to be changed while are working on the STE,
 	 * otherwise we could miss invalidations.
 	 */
 	mutex_lock(&arm_smmu_asid_lock);
 
-	arm_smmu_attach_prepare(&state, domain);
+	/*
+	 * If the CD table is not in use we can use the provided STE, otherwise
+	 * we use a cdtable STE with the provided S1DSS.
+	 */
+	if (arm_smmu_ssids_in_use(&master->cd_table)) {
+		/*
+		 * If a CD table has to be present then we need to run with ATS
+		 * on even though the RID will fail ATS queries with UR. This is
+		 * because we have no idea what the PASID's need.
+		 */
+		state.cd_needs_ats = true;
+		arm_smmu_attach_prepare(&state, domain);
+		arm_smmu_make_cdtable_ste(ste, master, state.ats_enabled, s1dss);
+	} else {
+		arm_smmu_attach_prepare(&state, domain);
+	}
 	arm_smmu_install_ste_for_dev(master, ste);
 	arm_smmu_attach_commit(&state);
 	mutex_unlock(&arm_smmu_asid_lock);
@@ -2865,7 +2897,6 @@ static int arm_smmu_attach_dev_ste(struct iommu_domain *domain,
 	 * descriptor from arm_smmu_share_asid().
 	 */
 	arm_smmu_clear_cd(master, IOMMU_NO_PASID);
-	return 0;
 }
 
 static int arm_smmu_attach_dev_identity(struct iommu_domain *domain,
@@ -2875,7 +2906,8 @@ static int arm_smmu_attach_dev_identity(struct iommu_domain *domain,
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
 
 	arm_smmu_make_bypass_ste(master->smmu, &ste);
-	return arm_smmu_attach_dev_ste(domain, dev, &ste);
+	arm_smmu_attach_dev_ste(domain, dev, &ste, STRTAB_STE_1_S1DSS_BYPASS);
+	return 0;
 }
 
 static const struct iommu_domain_ops arm_smmu_identity_ops = {
@@ -2893,7 +2925,9 @@ static int arm_smmu_attach_dev_blocked(struct iommu_domain *domain,
 	struct arm_smmu_ste ste;
 
 	arm_smmu_make_abort_ste(&ste);
-	return arm_smmu_attach_dev_ste(domain, dev, &ste);
+	arm_smmu_attach_dev_ste(domain, dev, &ste,
+				STRTAB_STE_1_S1DSS_TERMINATE);
+	return 0;
 }
 
 static const struct iommu_domain_ops arm_smmu_blocked_ops = {
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index d175d9eee6c61b..30459a800c7b2d 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -761,8 +761,8 @@ void arm_smmu_make_abort_ste(struct arm_smmu_ste *target);
 void arm_smmu_make_bypass_ste(struct arm_smmu_device *smmu,
 			      struct arm_smmu_ste *target);
 void arm_smmu_make_cdtable_ste(struct arm_smmu_ste *target,
-			       struct arm_smmu_master *master,
-			       bool ats_enabled);
+			       struct arm_smmu_master *master, bool ats_enabled,
+			       unsigned int s1dss);
 void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
 				 struct arm_smmu_master *master,
 				 struct arm_smmu_domain *smmu_domain,
-- 
2.45.2

