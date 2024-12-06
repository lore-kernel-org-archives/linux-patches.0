Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2085.outbound.protection.outlook.com [40.107.94.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 731A58F40;
	Fri,  6 Dec 2024 00:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733444634; cv=fail; b=q6JKis06cqDiQe4QwePkBt1V/aCOoRHmAoq0q7C3Wge9aiGnV7UNoGME2RXK/krHIKZXn0HrsNIO0fKDJGmCSXPW8im+hkJdTZlIvuJ2vpHUL1UxxGmudGrLCnPl1Bq5gotKMSUZ3M6/QeGZ4IETKqnINSiLwgoDuHzSRbHtAvU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733444634; c=relaxed/simple;
	bh=fHrzZblC3APukV+1dTlrIcYkGibhQjtkxHD9wv9vc54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jRp5UL1SdqXrnMUDo5LaUgGCSU4QGEYLHWFIK03+qVtSHdWDiQ3nxao1yLZM2zcU06J7gRbUjOGV40rgemsoyOvgQHcWPsYtAB6/knGWZ4sKa4FSW5t5ztdMAI6ubYuyt+z9qWOs8QE4MCJVM3O3ufYdSvCSBYnBYEW6NRSFYOE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=mOY5Y4vX; arc=fail smtp.client-ip=40.107.94.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="mOY5Y4vX"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=surRSGyXX7+ey5KHcRQ2P4rZ0bdkwlpqeutCZxnuE/j7rzlZC5zkYptafz1SS50baR8vZwz0s9lYKJ2E2m565JABX0uATAjBQVoerzTMWfnX46C15bPP7NJYNyUsttpNzZP4I5ksk/unw2RDAGVh7bXArSjQ+oVfmPyx0Vk6BIJfacqPsh1Q3qxoOA31hxDZRz5PAK10/pkxd/ouK5p6iDyInqz7EcDUz30ED+veY0FjUvmWSiN7yxMYFvCMMPKXag0ir6aK3L3ybhz7gdJYog2J/mcF6RKa7Dlvq/mIVvkgXZHKOHM66YNtn2zI4WMkXQick9p1nCb0vGde1L9t3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GlHxqmm5FTgWQz/Ngk/cZnMwC6g4kg6oca1HQdb01yI=;
 b=C0+eBovVI2i8FufkGdRLhY+1NTcy6R2lROQhL0oHvZnQJMstsLepGYPglgvSERUcEWq5bc7rpWyzFMKSepQfGfalykVg38uURdt8b1Y3PDC7xcbyhjvdDNTA3jSdARy0ftdWztcXYHRZG7cd4y+qHdZMRCJBX6CZiXbudd1p3OQpB0O0clKGscPGSW/z2F2DKyViCjDBkYhRX2Yv24FD6f3tH+6EN8hLlny7gx2Vo99Uep6OwUUWjplLhYWeLox6dutyRf1tOwKdTNqwZxhF5lpXBbaV8F6XaM5XAPIMdHWuYxp5d6J18ebRfKTNHv7laEiCsj3hXUtddEn8sQROeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GlHxqmm5FTgWQz/Ngk/cZnMwC6g4kg6oca1HQdb01yI=;
 b=mOY5Y4vXDbTwQV5Qxbh9/SJ5AQHcZPcm07XGphvd9rjw4ru55EoyYC4aUIjsIpRHNw2AEyjBCcPaicf/NkLpvwbK1+g8XqN7rFCbRAD2SMJkPk2ZYSvMhlgAUHbrh6kXZTqvoQ65TuQIFQx+gl43H2/DcKwV77feWMZ280HznYlRV8e3WZKbEZ3R/BxWwFHRzb20dUOK5Gd9GxMhHYkTQm2myThS817/OZ/q+0UdMQ8G2vPBPNTGcEGbcNjTff3ln49Gb3wQYnHyTLVKe/L2lcoNZ8BUJWgC4tJwwlSQmmXFnkVxBEqfxZGXYOWqjRxQscQzoNJiRPMoGgcxCUZrfw==
Received: from BL4PR12MB9480.namprd12.prod.outlook.com (2603:10b6:208:58d::7)
 by CYYPR12MB8923.namprd12.prod.outlook.com (2603:10b6:930:bc::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.20; Fri, 6 Dec
 2024 00:23:51 +0000
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by BL4PR12MB9480.namprd12.prod.outlook.com (2603:10b6:208:58d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.10; Fri, 6 Dec
 2024 00:23:47 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%5]) with mapi id 15.20.8230.010; Fri, 6 Dec 2024
 00:23:47 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Joerg Roedel <jroedel@suse.de>,
	Kevin Tian <kevin.tian@intel.com>,
	patches@lists.linux.dev,
	Vasant Hegde <vasant.hegde@amd.com>
Subject: [PATCH 7/7] iommu/amd: Fully decode all combinations of alloc_paging_flags
Date: Thu,  5 Dec 2024 20:23:42 -0400
Message-ID: <7-v1-cf88773f22d1+39bd-amd_paging_flags_jgg@nvidia.com>
In-Reply-To: <0-v1-cf88773f22d1+39bd-amd_paging_flags_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN8PR07CA0028.namprd07.prod.outlook.com
 (2603:10b6:408:ac::41) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic:
	CH3PR12MB8659:EE_|BL4PR12MB9480:EE_|CYYPR12MB8923:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c519531-9ce2-4c1d-ad5c-08dd158c3e5c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?azLYdlSaSHHA4PfgQR82PVn9WLgbhY4jShpLfBgbsITFU507EwGndXPTxl6M?=
 =?us-ascii?Q?NE1vSia9GTz2DMF1XLk4LBg9gkblKho96ycbrmtNXG7MfTJRsI6+3xW30V5a?=
 =?us-ascii?Q?k8pRpOvIMS5tbRNwSkZiyk8OeU+IHrKbPECHz3uH3FwWL9bkKXGvZNGmAvXh?=
 =?us-ascii?Q?Mrr5hYpGbnhmSErHmBITprW0YZzabiVwD8cVaTfop84I37ZjRW0grGx40tzd?=
 =?us-ascii?Q?c5MFFNm8ohRPjKx4o3McJK+weDvr39/KTwuLmuwN5/NsB+4Xci+Mm2ENMdAa?=
 =?us-ascii?Q?9cNhn04+OkiWTdAQaoXwnbDNalEhwDiZcfOwE1y5NxH6NQqnRAeA/jrjYMQp?=
 =?us-ascii?Q?Ud5UTxa09jBvfLzdlpfdbmoN/MoWuvSrcSt1ygOyXiSecEtzybCpXazj2Xae?=
 =?us-ascii?Q?O/J6c+KURr2oinTerB7UArWAYs/K+Z+dUuC3/5XsiuHQo7pzld2bEv9griaw?=
 =?us-ascii?Q?nESaxpbxbFgFx2Mt8yLUkCT/AN2jRynI5mkLk1DqbTGAA19w6jFSyHXt4vNq?=
 =?us-ascii?Q?ot0KLiREH4UKhRkB8VGDCSzITcdCFemY6Y6FawtuMwjy+TBXD6I1MlO3hP1V?=
 =?us-ascii?Q?D7zLRXyNnDz7DyTMEesCw9sPSnqWSTDqdiUIWkme82z229zajnq8jwJ4Y9yh?=
 =?us-ascii?Q?JHG+UFVKh7Dwuf8EVUvmIWOp8T3oZSAYsFsmRJYvCpHAKkQnLCQEvqV7Pjq3?=
 =?us-ascii?Q?+HpT9DGpFOdjcI10T5sAs/E9XRSUnPIrvJWytWBRuZqCLSvgR1v1Bmvq9xvo?=
 =?us-ascii?Q?CkS+YzYxdHcC3qiCFogn4sn6GWhMadT9R4ZgwTRjEhaPWM617Yq/2GSG9XX7?=
 =?us-ascii?Q?jMsyDbCFtnQik2rSh69hnZLLVFlTjTO2PQZTK4vYiTc1UTz+rva+i8UZRP4i?=
 =?us-ascii?Q?zucq9DjHVTyfYhPcV/nEk/a0EeOYUGJPG03bGZrecZm9fClKXejG0PXPzx34?=
 =?us-ascii?Q?42ENAXxEM+7t5NHMdn8oM0QwGKP6HJAAuUaNN59H7wW/8sDu5mD4ymaAh7d4?=
 =?us-ascii?Q?zVIrCW+/OalEA0lqcq77T+a3yeOc6hYUnVervzzZgIu9AGcYZVtZmXx4CYHf?=
 =?us-ascii?Q?EgpYqP77WB3ZZvHxNDwF84WEHDzUmW+EfbUOQSJRzK5acq6M7jI9wdpXP3/3?=
 =?us-ascii?Q?niYpVM0uVjCYGNTdddiTYwobvz0nJih9ClN0JQ94pQp2f/jFabGCLV+FfYUR?=
 =?us-ascii?Q?mwjug4fNRoWpVrscFsiSGexg+c+olLJmrrHBf4G0/Fuefne7Q4vMyaoBm8ev?=
 =?us-ascii?Q?M+GbGihZc6I//3k0lx3bKHXRLwBSA7k3B86MpCgcwQu2m74vI+ajCO4ixF7w?=
 =?us-ascii?Q?biDnv5PoL/m76IcwO5qxIqaZuQbeOQ2DQTdLyxA69WEE0g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR12MB9480.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Rb9LlcxDGvJg0HUHbEfznVdUpEArn9f3/r2yLv+H74oOCsBaW+G8sEKc/Hpi?=
 =?us-ascii?Q?NNkRtzK0YClzyL7g5uvUS5j/GE2y02x+OpY3dr3SZAbL137kH0ws4WxshMsq?=
 =?us-ascii?Q?1pGBj3uMfA8AT9rqmfaCZuXyfMK7WHHp0a7zBcOia0KDZoLgB3LZ9p5DIISE?=
 =?us-ascii?Q?O7B0R4EbVGH+JfeotUmzWH8PhaMKiV07qhm5YndkmOTQbv/lxupH5jcwTeuu?=
 =?us-ascii?Q?Gns68ZXZtQ2owp24ILDJzQmI9uRGMnCWd5i8LFLoYPSf2K7Nz53hqjguTfEP?=
 =?us-ascii?Q?3Eje1KVNwRlAIzZ3Ct9rT7VSkwbWDKh+JgOIpm0XlmbtLMMd6uqu8qGKXiZU?=
 =?us-ascii?Q?rVZtg7wfO5VkUDzcwsVwCstxja39WGpQ8MWm3nCpk0lfhnnqt/E2HKcx4h+H?=
 =?us-ascii?Q?oFnAliRG4HRXXcc8Z54WoZY2kaG3lZpl6AkEVC14Gg5MkJuC7ASk8WymVJIv?=
 =?us-ascii?Q?rzhGleL7cal4iOPaxCqeZGA3/mNoPR8cgeUUb9NrBWJzBRKjJ+c1uAFWsXC9?=
 =?us-ascii?Q?j46A0QiZoq1S2HuX7viGCf/bkMk+GpKn9hBjV6A9LVEV9ETfd99H0lKYZzWa?=
 =?us-ascii?Q?xGIuqHfVd/bWWP76mmTlf1uzY87ZlkXekO9RqMaJZzZ6iWywmMgAha+ieqUo?=
 =?us-ascii?Q?bUFJA5CzR00Yy0ZFEfjMNQqGlX3F+TdigM9i6BbybPa/U/swBL2W0fKPVKlU?=
 =?us-ascii?Q?OVZQe6xFM8myvSW/tCWg4sNE+9OtdN60ctrGxFEmlGmAIgW5+6KVNs7/p6JP?=
 =?us-ascii?Q?mwn6FmQu3jqNzvtaJmx9K/ZGTuzRCCQgcEvZweZErsdFXYCujKJPD5t7n4mR?=
 =?us-ascii?Q?eEw4tu1yDarQ9STyxAWUNh5IQdT774CGovi6q1vocSlwCkhqLWYzvgwSxYAK?=
 =?us-ascii?Q?ffWx0vAaau/e6IYtcD0hg+KonKli5UamLT4qoTLD61V8nwC6SBqRPa8L1Akd?=
 =?us-ascii?Q?Nu8CUthVcqxKFClDPy5otAVy/a3Lutzcw0sjYLnYwLtzTl+mew0J+NUBipgQ?=
 =?us-ascii?Q?K4HJ2G6nwaTDbgFMMjzkraOsVpcwC9hIkxAN0dvU/yg4OIpT82zXfB8cddHJ?=
 =?us-ascii?Q?MRb/s925gxtvGg2zdCTS5A1+7jeDgacMWBXylmytaMhI8DtuhuPv0bHYGgLH?=
 =?us-ascii?Q?iJKRLmGZr7uDt5mtI/L1A8fcKC7659+YcfDzPFtJL2mwCAp48DsN69s+Mka4?=
 =?us-ascii?Q?BffUf3XdOKcJtrphAa/doqwqhNs+xxN/dNCeG4/Zs5nqAaBKajvDxPIgUx6t?=
 =?us-ascii?Q?TQPvelyWbC9S62tmYl80z0POd4aP0QRIIHNBNhyxKKhXQfP6QHpGLeoY43Py?=
 =?us-ascii?Q?sSq1jAsh/pnMmhBLYc39WjoCc7IMOoKQcrgjRSnV69xVIDJgCd9ZEt8i3PoH?=
 =?us-ascii?Q?A+Hc2dpwMVxUv1GvJSfVCr5i9aCpkZ8BqW5HbIG+U0OUf2ZU4ZPGrGGAn8L5?=
 =?us-ascii?Q?euJyLP98cJyHGxTZx/1Pwxo0UwmCp7hhHHB/A8lWRzFV7sBe76EAUFD1mNdu?=
 =?us-ascii?Q?vxYYrFX+YktiHIRrsYmE++5uw9MuiMXID9LSYGpcFKOeL7L+RS4Bmg5n30V3?=
 =?us-ascii?Q?U3TTPNXAQxorAKWdnphvZZIWREqjG2u9PBnest0i?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c519531-9ce2-4c1d-ad5c-08dd158c3e5c
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2024 00:23:44.3676
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zjnaByGG/Tp/wx8DuwaJWdFaN0fbuIU8Hh+lFxis355kWO26o177Rxzu4V+LNgDy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8923

Currently AMD does not support IOMMU_HWPT_ALLOC_PASID |
IOMMU_HWPT_ALLOC_DIRTY_TRACKING, it should be rejected. Instead it creates
a V1 domain without dirty tracking support.

Use a switch to fully decode the flags.

Fixes: ce2cd175469f ("iommu/amd: Enhance amd_iommu_domain_alloc_user()")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/iommu.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index c84eb3e7bd8bef..a418a1f48e7fa7 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2375,24 +2375,25 @@ amd_iommu_domain_alloc_paging_flags(struct device *dev, u32 flags,
 	if ((flags & ~supported_flags) || user_data)
 		return ERR_PTR(-EOPNOTSUPP);
 
-	/* Allocate domain with v2 page table if IOMMU supports PASID. */
-	if (flags & IOMMU_HWPT_ALLOC_PASID) {
+	switch (flags &
+		(IOMMU_HWPT_ALLOC_PASID | IOMMU_HWPT_ALLOC_DIRTY_TRACKING)) {
+	case IOMMU_HWPT_ALLOC_DIRTY_TRACKING:
+		/* Allocate domain with v1 page table for dirty tracking */
+		if (!amd_iommu_hd_support(iommu))
+			break;
+		return do_iommu_domain_alloc(dev, flags, PD_MODE_V1);
+	case IOMMU_HWPT_ALLOC_PASID:
+		/* Allocate domain with v2 page table if IOMMU supports PASID. */
 		if (!amd_iommu_pasid_supported())
-			return ERR_PTR(-EOPNOTSUPP);
-
+			break;
 		return do_iommu_domain_alloc(dev, flags, PD_MODE_V2);
+	case 0:
+		/* If nothing specific is required use the kernel commandline default */
+		return do_iommu_domain_alloc(dev, 0, amd_iommu_pgtable);
+	default:
+		break;
 	}
-
-	/* Allocate domain with v1 page table for dirty tracking */
-	if (flags & IOMMU_HWPT_ALLOC_DIRTY_TRACKING) {
-		if (amd_iommu_hd_support(iommu))
-			return do_iommu_domain_alloc(dev, flags, PD_MODE_V1);
-
-		return ERR_PTR(-EOPNOTSUPP);
-	}
-
-	/* If nothing specific is required use the kernel commandline default */
-	return do_iommu_domain_alloc(dev, 0, amd_iommu_pgtable);
+	return ERR_PTR(-EOPNOTSUPP);
 }
 
 void amd_iommu_domain_free(struct iommu_domain *dom)
-- 
2.43.0

