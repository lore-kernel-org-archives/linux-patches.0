Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2085.outbound.protection.outlook.com [40.107.243.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8D65156883;
	Tue, 25 Jun 2024 12:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719319087; cv=fail; b=mNcp3ESNfbgcVLlMdiEjz0gIMIfDV20z+MQnozMCS2jAqN+ERFMVLUVoMCu4br8ZWy39BPsrDIMHpMO2gqmeZPtkw1SJgsEos6yYGnKHJ5xid6YQ4Pcc5a3Y4+xTZaGyUoZM8+ZpzdirFA5nPooZILKZIhJ4wXLcE8GkBKNWgX4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719319087; c=relaxed/simple;
	bh=GipMqG9UUK+gYMFHIhVLg58g87Td9kF5q4MK011vnI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JNGaNVRO16Pz8hThi3wjikQq6LSxdWlWHLi45jNpOE3Bkv6i9CD2DKeifz4lEbsHs4DRXnsZI03QclKX33noPg9vCGI71wGcfNWO6Xy1d1t7VRJ1BfH3bqQMunGHLIYJ4YsT/4aEgH5w5RS/HuCPaYmvBt/aU0p1ZslQpQyykLU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=NWrV9CKh; arc=fail smtp.client-ip=40.107.243.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="NWrV9CKh"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DZsWUV5cGaYiH61Sr7XJ4LufHH+7FUnR8DnVfxZmSZ9NW9w6SWO76iDQIhCRx79MCDCut/YH0ZBARoSLE7ljrm9rWL+Fd1PgCwxYGlH3cJ4esXY9EqioO2CEwwgOs9yCECY65Z4uIUOsxXnFdzbuB1uDWwg7LSySZ64fGSFKLCTAgWlcSyEkDyZxfTnXOVbjhogdT9H7AFSI4ugJEmXGAlzmRjzdol5gvb4ldam5vxiAyljRWy61yTH89YNN2UvjAX5GCJyYFay5j/RBjTqI4RzPz4Y54P/FuSMhl/fafoPMKjoHGY8GWoMgVgiruwOG1renoHEWSfp7XYIqK8W5kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B3zCRjUim5TZOGGBb5ABYfvdntY0XNoULhen5NYnvCs=;
 b=Bz4zJQc32odRNyKFHAv9u3xIY2ROR9eaGLU33ZHCC+ubqrsXgEg0q3767imp7lxSt/vbNPmNAgQoxpKxkWypnolBKW9gKH020jbbZK8+ZuKgegHmLmKyjAmy7b0ybsD5CZ3LVKvfg1Pd9kpvPewGsFMWVH5c9niaZUZphLs89GN5tE9GPVwVsB4zCPSILW2rUmHwXza1WBqLsWNak9oMNnbtfgUadkdS68/rDqLJts/xXovuYlhae4B09evHk3VgyVE/88MdaqVUbZQnJqvLlKXzbBqfQE6L4uiaENpsa0NAHU8/XqdoA1IZlyHZZJmwIPb6effzMbzI7ydcfX0IxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B3zCRjUim5TZOGGBb5ABYfvdntY0XNoULhen5NYnvCs=;
 b=NWrV9CKh6EGqwjqmDa1y2RiaNdksxofNWT0LE+lSVyIEVNLO+B+NATyGPEEolLiYwELNCs18ukK7zXvhLuhtvoX5hj4LZCpqEuqh0IBewlpMzs26P1eZZCyHMrxZ3yJ1QdE3VCaJNSnmFEV03LfLcAet3rhjIHtCDg7KviCVTw/2SmgE/iEFFrrejndE9yhd73Vzbc6lnrvMOr7hKEK9+MTofUT4ZXPzccd0izwQV2xyoDvdRQhCwnpQvpZwV5DFFyw3BubANZjsBfysI6ozRyz4Iaa7Pb1B4UJyZoM6plXUAMM30EEWVZU1xiUGu6Dg11d3nx4bIP3gIWjUrDcbOQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by SA1PR12MB8946.namprd12.prod.outlook.com (2603:10b6:806:375::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.26; Tue, 25 Jun
 2024 12:37:52 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%6]) with mapi id 15.20.7698.025; Tue, 25 Jun 2024
 12:37:52 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Jerry Snitselaar <jsnitsel@redhat.com>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH v9 11/14] iommu/arm-smmu-v3: Allow IDENTITY/BLOCKED to be set while PASID is used
Date: Tue, 25 Jun 2024 09:37:42 -0300
Message-ID: <11-v9-5cd718286059+79186-smmuv3_newapi_p2b_jgg@nvidia.com>
In-Reply-To: <0-v9-5cd718286059+79186-smmuv3_newapi_p2b_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR05CA0038.namprd05.prod.outlook.com
 (2603:10b6:208:335::19) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|SA1PR12MB8946:EE_
X-MS-Office365-Filtering-Correlation-Id: f2041cbe-f284-409a-783f-08dc95139f07
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|7416011|366013|1800799021|376011;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?TLAqR7TMAeBSWJHLXsEZFG+HSJaXCP3uIDGByPN4V9HFlw9QhuHW177GuAB3?=
 =?us-ascii?Q?yKVArjX9AGaZXO306vxYSatmgmoKWx4+dg7wW5qJeFsIivIca4BZiALOL63S?=
 =?us-ascii?Q?C7Y0v1mCOceG7bqY2tPcYAB+UoLTSn3iucJbVWi+rP4ICfyH59hhLo9pVyqE?=
 =?us-ascii?Q?KmyG7y+QAuYIdSIYYsWNgGWBUprgMbsxB0DqdJXfUbzobGjfRwbSXh5gw0I+?=
 =?us-ascii?Q?m8PF8TKAGJjtGc4FKsWcctAYa0YAFFF6PDeazxLWLwx1JzIFJtr5xRv7cf/M?=
 =?us-ascii?Q?sF8m7gvC8IycNBVT/oXg/1lvx4HZeIwzTIawXqne1ftmyOfe3/OQtqFlu36Y?=
 =?us-ascii?Q?1sqIed7BPxXDuqPvlDnkKXwg55j/WTcL+8T8hc1G9T7Thn8jsspRNvMj3Dus?=
 =?us-ascii?Q?fuM0XfCWiGw8mLWku4EeyBDhncoHYnUUhQTKfQT1lbaWz6oXZwcPZIBDcBv4?=
 =?us-ascii?Q?NQLItbbexsNQ9a40ZcDLr3JtmkPrtL2jQKGjVsSQRTQMSrMDUA8elz35Kh04?=
 =?us-ascii?Q?EWt58pDm3FW0a/fo8OLXrXaK1LAb/aDglqh1KQ8VBMn7dHUVW+fY/DFugMh6?=
 =?us-ascii?Q?SNOlWMdojPZz291TyqqbTXeoLxgMeLzrVWdhHMKZRYzFaVbYO12SBu6Zniru?=
 =?us-ascii?Q?0PO01aWwYr2jYoi202AJQG7RHV/IgR9Gp4+UCb0QHZDXwpLhih5dCsTeN4Dd?=
 =?us-ascii?Q?5cllYgpr43z6uoW9HbKrlFuvpG5gONevX1m3objDQXz1zL6dgk2lzQAapZ4j?=
 =?us-ascii?Q?9nXZj1JPY6yFzqg2yGMNrQGRfRIX5bsMJtAcc1jsIb+LqMYg+uMn+5FEZpWd?=
 =?us-ascii?Q?PZxb2V9LALZbY5MlZAMW5lrVbvgvLn3KRjdCWLGlJAvaI5UH3GOUzzpoTzX0?=
 =?us-ascii?Q?DJ461v+lcftVMHLdS6ThCwydasHFFOYad2k17kssftgKaOSoGRAT8bRCRi2h?=
 =?us-ascii?Q?Eh8dbSFO46L+AbJKdZCTfL7yXyuHHuO20T11yPKSRaDyaajPZ87tOvNQLpa+?=
 =?us-ascii?Q?9L9toRxiYSZ12qaSz32qjG/iI8KwUSyib/RvadHYCTXoZDky30jfG79EitsN?=
 =?us-ascii?Q?VjEvenCdaWv+YYgFkDuGjKRu8smuuy++e6Ifo2u/Jz/4DUZyyLqPxrh6IVff?=
 =?us-ascii?Q?I5BQD+Oyu9CK+bzxPAGv+Ufov/Xn//+RFFb4hyjFHikk82CnlvmIs9AY1f/k?=
 =?us-ascii?Q?T0mTjKNXnPm+Mc7JfiMdzxtKVFFL2x5+IXcuvk16ahhSoLpMQK3AwtQckNj+?=
 =?us-ascii?Q?aM30aKRAnzGSJ5glnK7Nt/puVZsQMEbfm+fa9tdJ1sfsA8Bk9YdRHcWi5LAb?=
 =?us-ascii?Q?W7U=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(7416011)(366013)(1800799021)(376011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1FwqdBpsz/Ach4h0lODWQvksZ6+XmPv6Sz7Xynu5HXqWYr1qh49LqvOzRDDl?=
 =?us-ascii?Q?GireNN9TEfsvfDsWpYeTpy7iFmWKnXUnLJBOf1rE6NxFE5nVEuGnk5POn90q?=
 =?us-ascii?Q?tKzjLmxy7ayoKiXNcfoZ/KryUutszQmCJ2M5C789GIXDqdffEjSes/A61RfG?=
 =?us-ascii?Q?MRVPTRadeeZR7aFXBCHTPS+nvmXlN4bYk+NIZhL2u7/8X/0Wegb0lruqcUF4?=
 =?us-ascii?Q?+taBgxEEBTT+wENzkQOPIqHLT5hepnuKN0op8t2bFU+453EdFRlFSrzEr0gH?=
 =?us-ascii?Q?fv6lSPlCHEBb+z0Bip6uir1+2UFW0g+auBYtoC0H8EN71nuSfmPY0oxEu2fK?=
 =?us-ascii?Q?DbhFwhldSkanNRjl6NmYFXJnFknlWHBxAyr7u6d+Dc2Hr+CXjnaphvEP3h9D?=
 =?us-ascii?Q?i19H3PO3pjOM9ISMABoBK9T0DJvj77vZtGZpfqRSUdWDvHmW/zdoRdL0zAnu?=
 =?us-ascii?Q?6pBBwLFYZP+aQKkdv8zG1TvSVORzfGZFDQEW0pJCZwsf8OTep+DClARJ2dmS?=
 =?us-ascii?Q?8rswTB35rfCN67dohmHf3N5+2hPxNorfkwWNnScPiu5jPDXbnj7xV7dOJeAU?=
 =?us-ascii?Q?vnNnpRsX0HuOuSts6Y+3I39HLEIk46S00T4UP6YoRqeoGss0z5tbqUif7lFN?=
 =?us-ascii?Q?TN98fIT++pqcTg7zkX1ucFiHE/eWnp5HAJr+7W13CzTzyjQifbLoYYbP8GMM?=
 =?us-ascii?Q?Czy8q5Yh1bjEzWxJjQPYNSSSsUMWJsGZrleDVQQZp9paA5sbYWsm20wyHdtl?=
 =?us-ascii?Q?WvEVtntzlUKdsWMx0FktW1nDIQjdvHsud9YOq99fuO371p6zWZo5COMkGBF8?=
 =?us-ascii?Q?bFLVhdFt8i9QmsV8P/P8y/0CLDeXU6pwhXCXKi+vI19qSiQ4uqE+MyP7cMbT?=
 =?us-ascii?Q?hIkRLXw/zSoZmsZ7oimWPZ7rTPHV/eKn5bxChpw6bqJ/PpM9a5hIErru1CRq?=
 =?us-ascii?Q?vew1cjthaGWX5tkfFry3jaldyzbCz0Bmzpfwyre2fXbODaBhHABFfU2zNNQ9?=
 =?us-ascii?Q?u5l7MW2b7o9iXZdvmKbSC6K2907WSfEMhwwc63ubgZFqydjaq70g73+mC/d3?=
 =?us-ascii?Q?h96bMxKXQGltJ5VcQQp6N1LYknEe1Za6qOrNu+U48xRlUecZ/sDmsNVIoxDL?=
 =?us-ascii?Q?XBlBwaXHLZEbMWipanKrYtJwj2OPnGvWRTbA3q/lskMXdHozpwSP/5VaIgg3?=
 =?us-ascii?Q?rO4pEvmeKu0aaCXyUQ4NsO2dPekBl+sMsgRCPW0stG+yp0QCVlXRBcJIvkjk?=
 =?us-ascii?Q?h0ZLgdEclRfZyOtji5D2EBS5knATR1rpMrJzIFa26ehj1A99g54yB15AR3H8?=
 =?us-ascii?Q?WJynViVg9gIP21X63vTq8UDFE93rha2qz7s1YRCC+4wR4dukaJu0WwIh7Cpc?=
 =?us-ascii?Q?+t0aG5PUS2DPIjRX3mBXyJ4fHKJv+EXkIdgpv+yzujqnsf2tKM79xPRIVhwO?=
 =?us-ascii?Q?VbIGulquWZtrtl5AxYf6lX78AIVmaD6tYSbz3s+Mv7tnVkr2AYFab8tFnkeL?=
 =?us-ascii?Q?UgWrGHp4zzYUnyEXSZgE1dxD8XetFv+O8edIW//xQ7yj8VGrqYyBoEN/6GpX?=
 =?us-ascii?Q?ZLQ22CrP+Pu3UqFx/LZ6JGBJr31XspA9mTmt4Ajo?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2041cbe-f284-409a-783f-08dc95139f07
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2024 12:37:48.6748
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5PRvwTefO0A1drrH8TUaBOWZmO84EyWU0lapnBd/bS2bcv0b8v4O01P/e6UONz2k
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8946

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
Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
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
index 26d597f608e3b5..10d140a5cd0f38 100644
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
@@ -2620,7 +2635,7 @@ static int arm_smmu_attach_prepare(struct arm_smmu_attach_state *state,
 	 */
 	lockdep_assert_held(&arm_smmu_asid_lock);
 
-	if (smmu_domain) {
+	if (smmu_domain || state->cd_needs_ats) {
 		/*
 		 * The SMMU does not support enabling ATS with bypass/abort.
 		 * When the STE is in bypass (STE.Config[2:0] == 0b100), ATS
@@ -2632,7 +2647,9 @@ static int arm_smmu_attach_prepare(struct arm_smmu_attach_state *state,
 		 * tables.
 		 */
 		state->ats_enabled = arm_smmu_ats_supported(master);
+	}
 
+	if (smmu_domain) {
 		master_domain = kzalloc(sizeof(*master_domain), GFP_KERNEL);
 		if (!master_domain)
 			return -ENOMEM;
@@ -2760,7 +2777,8 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 		arm_smmu_make_s1_cd(&target_cd, master, smmu_domain);
 		arm_smmu_write_cd_entry(master, IOMMU_NO_PASID, cdptr,
 					&target_cd);
-		arm_smmu_make_cdtable_ste(&target, master, state.ats_enabled);
+		arm_smmu_make_cdtable_ste(&target, master, state.ats_enabled,
+					  STRTAB_STE_1_S1DSS_SSID0);
 		arm_smmu_install_ste_for_dev(master, &target);
 		break;
 	}
@@ -2834,8 +2852,10 @@ static void arm_smmu_remove_dev_pasid(struct device *dev, ioasid_t pasid,
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
@@ -2844,16 +2864,28 @@ static int arm_smmu_attach_dev_ste(struct iommu_domain *domain,
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
@@ -2864,7 +2896,6 @@ static int arm_smmu_attach_dev_ste(struct iommu_domain *domain,
 	 * descriptor from arm_smmu_share_asid().
 	 */
 	arm_smmu_clear_cd(master, IOMMU_NO_PASID);
-	return 0;
 }
 
 static int arm_smmu_attach_dev_identity(struct iommu_domain *domain,
@@ -2874,7 +2905,8 @@ static int arm_smmu_attach_dev_identity(struct iommu_domain *domain,
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
 
 	arm_smmu_make_bypass_ste(master->smmu, &ste);
-	return arm_smmu_attach_dev_ste(domain, dev, &ste);
+	arm_smmu_attach_dev_ste(domain, dev, &ste, STRTAB_STE_1_S1DSS_BYPASS);
+	return 0;
 }
 
 static const struct iommu_domain_ops arm_smmu_identity_ops = {
@@ -2892,7 +2924,9 @@ static int arm_smmu_attach_dev_blocked(struct iommu_domain *domain,
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

