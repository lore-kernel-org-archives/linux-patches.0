Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2052.outbound.protection.outlook.com [40.107.102.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91AF322FDE7;
	Tue,  8 Apr 2025 16:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744130166; cv=fail; b=AWnvesizCiEhrljBwGGGrxFkiFON7xWnTHI3/9uA0YGO2C0WwCqwhC5ICVDnT9UXA4rtHuHaYrht+RuihGV3squ1clIc8VrWnYLMMlOzFIRQaNNcp3x5sg6r6vahPglO+irQH9c0f86GX/VmMG2HfAk+oS563nM3ljBmknt9MlY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744130166; c=relaxed/simple;
	bh=yQBZmhJqlBiDSwfxcZFYOgFftLy8eI8lIhX80jRLzPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gOmIxi89ZskeDVepIIxmn3CPVTbIO++NQNFGwQGlGrWDeImQWymv9qOiSmLw3H0Eau3tV+wa2jNm4S/QOMfd8BkzF+7ylnvxYSGqBKTMF/H3lHJ0VgcDm8ong7jJc6VO71/wvb5LS0zcRKf4tq5e2VByIaq7gUYDMwF1m2D8Ypk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=IXjmj4vZ; arc=fail smtp.client-ip=40.107.102.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="IXjmj4vZ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hG154UCkY/0OYejF80S9cxlQFgBFSiym9biNVJ7hwe36CYMt15PexxgDg5lSGVm3Qh+yry5dlOQvpPBKVoI1SLn4FIOLsQciDqNNbaNBNxkyd9Qx3ZIhmZuriNF0rOFAYCYmrqfMLiCYWrZ123vVzMKz3CL0nqjSPrZIsfLdYM7X8ZryQmF/c4oP7Yq4c8k9eRFPGiinWbIAs5w1F/UyGzFujgEuzq4S8LL/ujdDZqnBKiGoTLkBzZpUhNywFMJJSYeiHM7bxVLgym+jY2ddEjPdmhTpvlBFv9BKtKTc83AIu9NFgHgMHglJD+UWO4P0cFSG+DlwrnaV11bpcyT5hA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hEdVo84R8lkMxMvYFjROiSxJxgBdzaEHnae+4aLOvsk=;
 b=s2OsrKTAAlXFTT10vKSZShJg5O3+RjFX/SR/Z4tFvenzKFA6I3HExORtwl+4cN/Vci+WqKlDUFrSw4cF0yIhJISPVCIxP5781JzO4xGV3h+YTHV7PAkaUVGG6mWfvGczyW4x0brz1+yCjgb3P+OsZ/w8lpSErcHzF6GRoQdq9dF6j50eOM34E7Vo2qlXiXDzZcYdVfZqHR1jUfNtuqMm7eGBRLHb9ZHaUBunwADP4T2uFP2uBG6yP91Zg3OO8h4SjD/vmA8jNNk9KdMRsExvnSSRIYpM9120j/YDMffEzckiTkacQ+C0Grl4ulNS3rpJQPyNbH5PRWdVmGtcKxLZaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hEdVo84R8lkMxMvYFjROiSxJxgBdzaEHnae+4aLOvsk=;
 b=IXjmj4vZPHimnk/t8DXw4sC77CLE5yZCQ3E7BXERQKFMYsXdO9B/irKe9EZ1FTWBo0qe59osAR7n7aVz9n2EOxi3p61YhW3PEsDO26ok/9/cMHZPuLz2SmWe312uugIS0/XVAZJO4KstjumEHlDLGLrGhDQ52zh9dY22LNPzJBR7BMao3m9oMYMp+tWldW9g6tnWaMS+6zSE9kGZNcuhpHJoHiqnDLWrPkGgJyGlkwR2CSklYICIZUCYLznAizcAAsZdXZZPkxs5feoBBVC1xe7v3wqCohtviy+1zjbaEjpCWQRhqGDXsX3OHvxGwLTPzJTcGFS5yca+LZdvhLxWRw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SN7PR12MB8001.namprd12.prod.outlook.com (2603:10b6:806:340::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.34; Tue, 8 Apr
 2025 16:35:53 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8606.028; Tue, 8 Apr 2025
 16:35:53 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	virtualization@lists.linux.dev,
	Will Deacon <will@kernel.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	patches@lists.linux.dev
Subject: [PATCH v4 3/5] iommu/virtio: Move to domain_alloc_paging()
Date: Tue,  8 Apr 2025 13:35:49 -0300
Message-ID: <3-v4-ff5fb6b03bd1+288-iommu_virtio_domains_jgg@nvidia.com>
In-Reply-To: <0-v4-ff5fb6b03bd1+288-iommu_virtio_domains_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0271.namprd03.prod.outlook.com
 (2603:10b6:408:f5::6) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SN7PR12MB8001:EE_
X-MS-Office365-Filtering-Correlation-Id: c63d2bb6-31c8-4fe4-8fed-08dd76bb6d8d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DHYU+ioPHMu/HuM8XYew02XHiGiQBskKjoERhsGQT5XUrDFDomeLvlCA5GEg?=
 =?us-ascii?Q?IlGiDrKAx977OABjsbzwjSr3W+uDjG0dcony+IjaL0h4jmvPVgzhS70mUyAB?=
 =?us-ascii?Q?T2rAXS9aR3uwKi8JeAnRWIW2scoQSECVD2dErnYCotTlRie0RkN2ONN5fKOD?=
 =?us-ascii?Q?nxI/4NaRkCbBHmAbPQEfZ8IwGUDDMSLnk5IGaAYT3CORUsy4dJjKv8lnxWxa?=
 =?us-ascii?Q?UzbxgwqmvoNKkx4Ni5fDD6WRYeco6vMeA7EG8pJnZ3pjtcwep6YyVaXj05DY?=
 =?us-ascii?Q?tWPlvvXy44bKrzwSSC+OJPAIJRJzbZkUemdJPVEqne3LUymFxPjZJ7RuopEh?=
 =?us-ascii?Q?NMXHiaXz9xyoPEKt/2CfDwUH7Jb1Xrgf19NJRPWSRvADVMWYlxTfhsXFGgyr?=
 =?us-ascii?Q?abBkl1gDkEgNjisDvlOtiTUWJLycLxC7xgLkFv8YNVMvsBpjLvv3o8R/mQxL?=
 =?us-ascii?Q?TWt5IhS4Lv0avzljZxBqKEZ0h5GOL18rShVGdy8HFkMyvbn74i/hZUeZNsPx?=
 =?us-ascii?Q?rlSAL1vcQJhS3afchRwYaCYeZ3xTa/wjZcuPvacRGklOCqtAmqTmLAgvmeF8?=
 =?us-ascii?Q?/F0orSwlDq/KiyKXmNGUP1cO7cA62zPNTSzwH+tZigsSKgAZ1nImTxLJVvPY?=
 =?us-ascii?Q?9WOuCtEhitJa9eRg280FHgDjUFVCr9vmhTOeFuxOAqQCGHJdWlDG+Q0YoLfw?=
 =?us-ascii?Q?Mhb7QrtggaRj9AdiV47xqaGPnHmszjlmg4gThWwwpIqbL5dbqGWBcI31YKDb?=
 =?us-ascii?Q?8+FbfynZBLQdYAJxk6ekg+vY1QN3UwAVocsfIHFMjNimnJnj1Oe+22/7aw6P?=
 =?us-ascii?Q?i6E7ppMYORtCtpwl1w3ngYoNwdqvfMVfxDFgVAGKSfEtcf4S70kcmEFOC/mY?=
 =?us-ascii?Q?oxw3frThzESH7MHQNC4s5c0uYuPSJHftfP0ttAsZQiHwM2jHmQqRhrFc02DT?=
 =?us-ascii?Q?X4DV3CymahIYRQXc3jcUCbBv1ZZnlR/0MslmHhLxH+mUW+3ZkRV/bdvrOfBH?=
 =?us-ascii?Q?UH64C93Fvd7DzuPK8q4Ud8mLLcsbgAq9oilY+UPT8zt6oBc8TnZCf9Z3zHy4?=
 =?us-ascii?Q?w99nav3fLp+KRDzbB4c7UOoueNHZrsSBw2HG28GdjZZPlpiMBx7xZz8dFJ6a?=
 =?us-ascii?Q?BslnBpjV4k43vT3Ezh5FDtRzE8MJ8uQzzEIH9d3P1xfLZx+q8/MIGvGdm3P4?=
 =?us-ascii?Q?XaYGoCt/ZcFEA3LsuC1dh8Yxebz5gyTKmtqTGh7LZnipRP9oERGz4lX5PesK?=
 =?us-ascii?Q?ejFId+yAqinir/yih7k+sg//0Wh7XHlkoJ4LYN05/ozppU82eju0MEpuIodc?=
 =?us-ascii?Q?o2/omjdjRiQ0ZSA5XjLAG7MST1cm7bJ4s1epT8fspALi2xliIEPvPz7ScCl0?=
 =?us-ascii?Q?3ZhEL1KqLZ52BynKHLMagFdiS0cJIiYINflL/wC8aayC1is2tOpBN/+IDJxf?=
 =?us-ascii?Q?H1qfYWgN3Fg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+aBPJu5RZGUjbw9vAhEicTw8X3Ct3TKn/OAgiB6yd6GPiAIFH213jFwX3uIA?=
 =?us-ascii?Q?Q5IlvzUMiFd0X7rf1m1eZjY34YzBoAK5W7UWSs2bLATgkztD+egcjQTkpK28?=
 =?us-ascii?Q?9NyERuKKkYPYPhVMSWUFzDpHgRJv+I9gF/DkZCH0y5UMsCYrirxfnu7u1kZn?=
 =?us-ascii?Q?A0UB2+6GhGq8bYycBeBRYLyBDBq2yPV/dLBs/gm5Ze254xzF8Z1ahv92qvKP?=
 =?us-ascii?Q?IckpG8ZSuAxg/+FDZg8z2SSPsS316asaQDcl4DDcEZ6GXfkiAZcPX+tMaNYK?=
 =?us-ascii?Q?ZgxVB/n78QcZZJf0FVIOAyoNaLRgB2ovMGDMBbMSELHbW7yPP+Cu7FUKQnZp?=
 =?us-ascii?Q?ONVvGEigjTiDjqXp5hf2n6aLDBhcRRdwt1F37CWxjJGwu1iO4ek7z2rIBh0n?=
 =?us-ascii?Q?M35gaoxzFWurMZvd4eEiqyZwJw72qbmTkiWW7Q6UE9zxoo0sZJKkE9Kdya21?=
 =?us-ascii?Q?28Ps13z20h6Ok5Z7/3Y6RZ9P1eKXwenMi3kBf2ySw+Jtem/W6exKrvgZwzwU?=
 =?us-ascii?Q?z152dAd2jKMWQmJh2iXiOTpEw9Afiqub0N/JUxBx0QWsnVdMSku+25MEO+mN?=
 =?us-ascii?Q?bd1+3V24NOsyQkO9AjENJOzAa2+UKREbA1B5r/o3oHAlT0gGsmwdKJju/RfD?=
 =?us-ascii?Q?ivyzIiVPWRTAvjAtvF7s4VTpJ4ynPMgfd+/AVXgqG3n17empkVCdKuU9Fa43?=
 =?us-ascii?Q?e1/cNTIdMrlD6ew83KuDyW1m6QCa/wt3wS6gsptPX8hCxIemo9XgTlknd9Ic?=
 =?us-ascii?Q?6wZ/LaqXG32QwNQuy3Y/PResIXimEQUAAM9uro6NYucAE8b8M2XXK0vDHGpn?=
 =?us-ascii?Q?qRYLcainFvGX6eh9hdlqnjXXwiaJz6D1ZIKzbK9cXTPMdENMNAIuvrzvDhcG?=
 =?us-ascii?Q?fQhyTAXYnJRrIz2WuTj0gEl38sMj/5n0JNRWeJ5E4yVHFRoR4W1zaW1VfMyW?=
 =?us-ascii?Q?jDKp/5nvWp6G4+qfigVwfHzQLOm9WJKlek1kEEntTgX/oTCssOCdYZDBblD8?=
 =?us-ascii?Q?a/KyBMbPTtmOeBW80Sc6LkjL+se37qdke7s7YbS9gDy9ChvdU951cqIZjyBN?=
 =?us-ascii?Q?k5CyjjGRDmkJ2TUix5QEtriMeGGaauEJx5kfnOzrW06xjvSP8FB4KzYxSjRc?=
 =?us-ascii?Q?MTt4G4FRE65IVYrpeHOzneZzl+4v4qFDdbWNzcUEtH0Hj8xrxqFQmuRgmbDV?=
 =?us-ascii?Q?u2HxAPhUl0Q4Z6ZbTMLCfeV79Nli4n5wd9ORVruY4QqkMqpmmUWHIlkTNMgA?=
 =?us-ascii?Q?D06gbuQ8U1NtD03AWYotkWXL/dQeG+Jp5dj3pwC1NJfmpkwQipRD3X2ow8Ea?=
 =?us-ascii?Q?5l6GAimuA9+S0q5qwKxm5UfAD06i5N22Lab5um6TzMWGf8WwhTd3W2ddI5Hi?=
 =?us-ascii?Q?mTRXLgjITgp2i1qZSTdxuKi5ViFZUtkQfdsLH+pGFF9JuCVmgzRLHgBVS3n7?=
 =?us-ascii?Q?qKQleeg3mk9i0goKoL4fyxUYWB9deWeD02diQ+rdtHJM6A+P1rUegu9C7zc9?=
 =?us-ascii?Q?sL4/R+99JKDXO59VfmDCggIHI3lCLL+RszGOVzZ9PHsc8bpvXbbG79rhHNY/?=
 =?us-ascii?Q?ItfSyU3uHzIsDcfRExg99VLXfLRyWqzFtGEUSdef?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c63d2bb6-31c8-4fe4-8fed-08dd76bb6d8d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2025 16:35:52.7762
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FQ9xuK2SyG6B3XYCYG+zX+cWz+gCbAMDh9gL5cbAveYl5ckTpSWbMRivllYhiXof
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8001

virtio has the complication that it sometimes wants to return a paging
domain for IDENTITY which makes this conversion a little different than
other drivers.

Add a viommu_domain_alloc_paging() that combines viommu_domain_alloc() and
viommu_domain_finalise() to always return a fully initialized and
finalized paging domain.

Use viommu_domain_alloc_identity() to implement the special non-bypass
IDENTITY flow by calling viommu_domain_alloc_paging() then
viommu_domain_map_identity().

Remove support for deferred finalize and the vdomain->mutex.

Remove core support for domain_alloc() IDENTITY as virtio was the last
driver using it.

Reviewed-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommu.c        |   6 --
 drivers/iommu/virtio-iommu.c | 121 +++++++++++++++--------------------
 2 files changed, 53 insertions(+), 74 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index a61cceb706ed43..3c32ca2d1aef10 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1630,12 +1630,6 @@ static struct iommu_domain *__iommu_alloc_identity_domain(struct device *dev)
 		domain = ops->domain_alloc_identity(dev);
 		if (IS_ERR(domain))
 			return domain;
-	} else if (ops->domain_alloc) {
-		domain = ops->domain_alloc(IOMMU_DOMAIN_IDENTITY);
-		if (!domain)
-			return ERR_PTR(-ENOMEM);
-		if (IS_ERR(domain))
-			return domain;
 	} else {
 		return ERR_PTR(-EOPNOTSUPP);
 	}
diff --git a/drivers/iommu/virtio-iommu.c b/drivers/iommu/virtio-iommu.c
index 55a2188197c621..ecd41fb03e5a51 100644
--- a/drivers/iommu/virtio-iommu.c
+++ b/drivers/iommu/virtio-iommu.c
@@ -63,7 +63,6 @@ struct viommu_mapping {
 struct viommu_domain {
 	struct iommu_domain		domain;
 	struct viommu_dev		*viommu;
-	struct mutex			mutex; /* protects viommu pointer */
 	unsigned int			id;
 	u32				map_flags;
 
@@ -97,6 +96,8 @@ struct viommu_event {
 	};
 };
 
+static struct viommu_domain viommu_identity_domain;
+
 #define to_viommu_domain(domain)	\
 	container_of(domain, struct viommu_domain, domain)
 
@@ -653,65 +654,45 @@ static void viommu_event_handler(struct virtqueue *vq)
 
 /* IOMMU API */
 
-static struct iommu_domain *viommu_domain_alloc(unsigned type)
+static struct iommu_domain *viommu_domain_alloc_paging(struct device *dev)
 {
-	struct viommu_domain *vdomain;
-
-	if (type != IOMMU_DOMAIN_UNMANAGED &&
-	    type != IOMMU_DOMAIN_DMA &&
-	    type != IOMMU_DOMAIN_IDENTITY)
-		return NULL;
-
-	vdomain = kzalloc(sizeof(*vdomain), GFP_KERNEL);
-	if (!vdomain)
-		return NULL;
-
-	mutex_init(&vdomain->mutex);
-	spin_lock_init(&vdomain->mappings_lock);
-	vdomain->mappings = RB_ROOT_CACHED;
-
-	return &vdomain->domain;
-}
-
-static int viommu_domain_finalise(struct viommu_endpoint *vdev,
-				  struct iommu_domain *domain)
-{
-	int ret;
-	unsigned long viommu_page_size;
+	struct viommu_endpoint *vdev = dev_iommu_priv_get(dev);
 	struct viommu_dev *viommu = vdev->viommu;
-	struct viommu_domain *vdomain = to_viommu_domain(domain);
+	unsigned long viommu_page_size;
+	struct viommu_domain *vdomain;
+	int ret;
 
 	viommu_page_size = 1UL << __ffs(viommu->pgsize_bitmap);
 	if (viommu_page_size > PAGE_SIZE) {
 		dev_err(vdev->dev,
 			"granule 0x%lx larger than system page size 0x%lx\n",
 			viommu_page_size, PAGE_SIZE);
-		return -ENODEV;
+		return ERR_PTR(-ENODEV);
 	}
 
+	vdomain = kzalloc(sizeof(*vdomain), GFP_KERNEL);
+	if (!vdomain)
+		return ERR_PTR(-ENOMEM);
+
+	spin_lock_init(&vdomain->mappings_lock);
+	vdomain->mappings = RB_ROOT_CACHED;
+
 	ret = ida_alloc_range(&viommu->domain_ids, viommu->first_domain,
 			      viommu->last_domain, GFP_KERNEL);
-	if (ret < 0)
-		return ret;
-
-	vdomain->id		= (unsigned int)ret;
-
-	domain->pgsize_bitmap	= viommu->pgsize_bitmap;
-	domain->geometry	= viommu->geometry;
-
-	vdomain->map_flags	= viommu->map_flags;
-	vdomain->viommu		= viommu;
-
-	if (domain->type == IOMMU_DOMAIN_IDENTITY) {
-		ret = viommu_domain_map_identity(vdev, vdomain);
-		if (ret) {
-			ida_free(&viommu->domain_ids, vdomain->id);
-			vdomain->viommu = NULL;
-			return ret;
-		}
+	if (ret < 0) {
+		kfree(vdomain);
+		return ERR_PTR(ret);
 	}
 
-	return 0;
+	vdomain->id = (unsigned int)ret;
+
+	vdomain->domain.pgsize_bitmap = viommu->pgsize_bitmap;
+	vdomain->domain.geometry = viommu->geometry;
+
+	vdomain->map_flags = viommu->map_flags;
+	vdomain->viommu = viommu;
+
+	return &vdomain->domain;
 }
 
 static void viommu_domain_free(struct iommu_domain *domain)
@@ -727,6 +708,28 @@ static void viommu_domain_free(struct iommu_domain *domain)
 	kfree(vdomain);
 }
 
+static struct iommu_domain *viommu_domain_alloc_identity(struct device *dev)
+{
+	struct viommu_endpoint *vdev = dev_iommu_priv_get(dev);
+	struct iommu_domain *domain;
+	int ret;
+
+	if (virtio_has_feature(vdev->viommu->vdev,
+			       VIRTIO_IOMMU_F_BYPASS_CONFIG))
+		return &viommu_identity_domain.domain;
+
+	domain = viommu_domain_alloc_paging(dev);
+	if (IS_ERR(domain))
+		return domain;
+
+	ret = viommu_domain_map_identity(vdev, to_viommu_domain(domain));
+	if (ret) {
+		viommu_domain_free(domain);
+		return ERR_PTR(ret);
+	}
+	return domain;
+}
+
 static int viommu_attach_dev(struct iommu_domain *domain, struct device *dev)
 {
 	int ret = 0;
@@ -734,20 +737,8 @@ static int viommu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	struct viommu_endpoint *vdev = dev_iommu_priv_get(dev);
 	struct viommu_domain *vdomain = to_viommu_domain(domain);
 
-	mutex_lock(&vdomain->mutex);
-	if (!vdomain->viommu) {
-		/*
-		 * Properly initialize the domain now that we know which viommu
-		 * owns it.
-		 */
-		ret = viommu_domain_finalise(vdev, domain);
-	} else if (vdomain->viommu != vdev->viommu) {
-		ret = -EINVAL;
-	}
-	mutex_unlock(&vdomain->mutex);
-
-	if (ret)
-		return ret;
+	if (vdomain->viommu != vdev->viommu)
+		return -EINVAL;
 
 	/*
 	 * In the virtio-iommu device, when attaching the endpoint to a new
@@ -1096,9 +1087,9 @@ static bool viommu_capable(struct device *dev, enum iommu_cap cap)
 }
 
 static struct iommu_ops viommu_ops = {
-	.identity_domain	= &viommu_identity_domain.domain,
 	.capable		= viommu_capable,
-	.domain_alloc		= viommu_domain_alloc,
+	.domain_alloc_identity	= viommu_domain_alloc_identity,
+	.domain_alloc_paging	= viommu_domain_alloc_paging,
 	.probe_device		= viommu_probe_device,
 	.release_device		= viommu_release_device,
 	.device_group		= viommu_device_group,
@@ -1224,12 +1215,6 @@ static int viommu_probe(struct virtio_device *vdev)
 	if (virtio_has_feature(viommu->vdev, VIRTIO_IOMMU_F_BYPASS_CONFIG)) {
 		viommu->identity_domain_id = viommu->first_domain;
 		viommu->first_domain++;
-	} else {
-		/*
-		 * Assume the VMM is sensible and it either supports bypass on
-		 * all instances or no instances.
-		 */
-		viommu_ops.identity_domain = NULL;
 	}
 
 	viommu_ops.pgsize_bitmap = viommu->pgsize_bitmap;
-- 
2.43.0

