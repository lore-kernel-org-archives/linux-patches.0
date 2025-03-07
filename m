Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2048.outbound.protection.outlook.com [40.107.223.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 355DD24166F;
	Fri,  7 Mar 2025 18:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741371458; cv=fail; b=YHKRRLZ0Dz+nzTRGD5b4ijSZR9zcbPinoeye5+MQF/uUJohRQcAKqlpzxnMWQ2hjxYAoy81pl72IiMle6CnYQWpGl3Z2h5QPRrM3T2nWjlKn40jfc89a+hAjve+v5DWQEwjwNzZTMYUyFcJ6bQt1gSz8WQjexRSo4fPLbXt0DC0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741371458; c=relaxed/simple;
	bh=3Z9xCVjTXBxpjJ4DbJhzOWjhLfGGwpoFJexsq5PRDw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=CdX/08Qwq4HvqltssZ6BMzl7JCuXoAL+kBnIDmgWwAo7hZbY5Io+4Y0J1LpYGcuUJbtgk/N14EbKjc1Jr6y3qnA6E1j4Tp6aHHOzNPDh6qw7hKDIflB+1HFHY79C8GlUbVPQT0cvURS8Jtx9uuzmcS3x8YSs70Fww1kAWUTFEWE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=g6pDaVnJ; arc=fail smtp.client-ip=40.107.223.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="g6pDaVnJ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dR8jeMY79PZtGeXENDVJR7vNo1c1TXVyTiFE8qwtkhfAVo3xIGuV+t4NRjQqYwhWuk8TgPncEegNl5e4OO5lmJLt5X8Cu2y8KulNrXqrS12+YIyF7pRGwo3m72Fph7hrzSqIP4OeQGL7ub8IK/GsWuVvxhOAcPE+obYqoG8KgqwqpS4ZS93fdab9hYfQ4v6+SyUV6i3Xaf1ERccnpGOj3WnTxqKbv1ARZTAG3Rv2aK1zRKiGK6gRPZUiOxczR9xd3/uA7/GLFumj/MibP3j7U0F3IlaOAxRVc4sRBpLiYuUkQ/K53kNsJS9qq47X/FY84H+tL9aI59UVBZm1Mx1ADQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IWAbtjqiGk4qxo1JQ5bwBPsxOOMR1mmFZQiycMJNAqU=;
 b=gOK7ABOywKVUlKschcd5G7HLjeGi4jr2CakSgo6q334vfDkcxMb57TsNZ8NS1E/mx1hkhIQVhUZ4lFX6nG36vlBDYcYJKy2ckoUjwoPOhXamZy3nPhdwZdxHzyOVfKqroLHBBeZoEpzM0lRBnGDI1nUxtF3LhS+n82ZUeyg1cW8bw9yNnsiW54U1ssJ47A9xDtduz0bczOkxJ3n4dFx7UYriN20OWCD+dcb5nJKneVTZ9h83oHEluK27c37sn8CYogVau3MQXqWDigEFQ3XGjLp2yJ6nJQ8H5woynozxCIRVefRGpuOEyGS3cg47wkqCMiYxVazmxk8sYb4aslZ/IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IWAbtjqiGk4qxo1JQ5bwBPsxOOMR1mmFZQiycMJNAqU=;
 b=g6pDaVnJKzf0vejp1uDKHKWHEnvqCZ/cGAA0ji98mk9wkZOuINP2pDCdfd4nf7z29XqsKnqjZfN7r8hUFZXY7UVt+V0Y7jTtQOabV6P3YPnzEEpoLi3Ssu+OykL4LiGR6uc9BMNhoRm2PRmSMAzr0Ke4Hd79t6FLr9NsHniV3uR/+F+M4v327s3Ia2XGRnNmUuLOElY5nqpOY5BhJVtOvoOTFryTfIhast6s5lSQkVZ9n3/n3FjYFUMhaNWXuqqD6WGR5pGRAxhppNYjh4GcqJ6XzkAh/ZGaUJm0mO4s9B5XBtKJlqSVDnjKwpA3FV+mSICc5VE0Tfwfgt8qivZOUg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MW6PR12MB8663.namprd12.prod.outlook.com (2603:10b6:303:240::9)
 by PH7PR12MB6539.namprd12.prod.outlook.com (2603:10b6:510:1f0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.18; Fri, 7 Mar
 2025 18:17:30 +0000
Received: from MW6PR12MB8663.namprd12.prod.outlook.com
 ([fe80::594:5be3:34d:77f]) by MW6PR12MB8663.namprd12.prod.outlook.com
 ([fe80::594:5be3:34d:77f%2]) with mapi id 15.20.8511.017; Fri, 7 Mar 2025
 18:17:30 +0000
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
Subject: [PATCH v3 3/5] iommu/virtio: Move to domain_alloc_paging()
Date: Fri,  7 Mar 2025 14:17:24 -0400
Message-ID: <3-v3-e005a650174b+53def-iommu_virtio_domains_jgg@nvidia.com>
In-Reply-To: <0-v3-e005a650174b+53def-iommu_virtio_domains_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0320.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::25) To MW6PR12MB8663.namprd12.prod.outlook.com
 (2603:10b6:303:240::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW6PR12MB8663:EE_|PH7PR12MB6539:EE_
X-MS-Office365-Filtering-Correlation-Id: a85acadb-ef7b-4436-bd07-08dd5da451d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?tIB6Z6gVPqxp1UhZarIXIFfYXm7MdqB8aSXBCn9XlTT/yy+H3zGqT1ddD0Qp?=
 =?us-ascii?Q?3G7LI1mEhaaKVVTNUQbQnuqeInfHeOzZ/OBWpHHIHP+lufj8nIIFo/WkJ8Kf?=
 =?us-ascii?Q?+ojcd4Apa4WMcu80XDaAJJNs5IuE1BBRdYoYLQw5r++30dC8IEXamor8nPvZ?=
 =?us-ascii?Q?FIX5lQMpStpeDeHuEFhvAyf06/TMhQ4VTqXAY8G0XTtKE7oKpA6I1QAGsSaz?=
 =?us-ascii?Q?5W0Q1QgIURCFDAeEQeytuPEoYT/hy3ooWmfbdgW9Vk/e5yy/wp98McUHw8S0?=
 =?us-ascii?Q?Ib+QWfhXL5WdPMz9bxVx+gct3YBcj2DIppTje5lpGshXiXN8Ji+SXpHhvMNe?=
 =?us-ascii?Q?cu1mibd5m5TIWOh4YzNEAJCoq2Pw1bDGgZy14Ifh6V0p8TIHu9OIA+ptz20X?=
 =?us-ascii?Q?3eXN/yaDt/7G2ojGZLC3gX5ZHDPbOq+B9IAz+6/eG3Ua1Kucs07f98lPrHzG?=
 =?us-ascii?Q?OAr59Lx1sXZEByUhnHsH1s18JCBkXMbSuXEQiyRCcr6068p2X5pvAUdJTO0B?=
 =?us-ascii?Q?nVi94N+LqDRONTKBdftIGtUt2I/HmE31QNFaVT5/DEP6atn/nLQaFinWlqBH?=
 =?us-ascii?Q?KeRWL7225Op9NcBVDTXnGmh+nC4Sg+PyP5oZ6JFe76Dp7FOWZLNpTQfu+Ln7?=
 =?us-ascii?Q?hwlBpsjfG+6MaguHNqqUxt/Tctzv9AOr2D3Vhpg0aeu2GQSZ9KEM1hBvujtl?=
 =?us-ascii?Q?DGYLYDebk+U7EtCmlcVT99XM4wpxUKj2BXdM1mKmLH1ct0vwU5O4VxozeEIP?=
 =?us-ascii?Q?/AT4YyjLI8lreNGDBLyjXKUdsiqp1iZ2mhNbaVGOuSyyfRoAO0vtyTxBR6Sc?=
 =?us-ascii?Q?67w48tD082Ug8YSmzTT9dSPJ16jD76D3PseXmguToXDiG8qccLcmjMSJ2/mJ?=
 =?us-ascii?Q?+m7JnGmLqHJ8z4y28OOuugEEtSim28v7r+mG1zQKIE82y+0IDPvbLyfcXHlG?=
 =?us-ascii?Q?IMdJ1X/NuQ7nT8FUzE6YKAnMMpDmI1o5epMpBcxjlrBzRcJPsryQGgKmL41+?=
 =?us-ascii?Q?fVBFI/hnepYaxxyhr4PaTazcSGY1j8R/qFfYUjQY8N68a5Bl2UHrU44HPtr+?=
 =?us-ascii?Q?Lh1wyDCN5DB7rRQHrKYDws+bPVTvR/f+juZJ5kWLYYoPJ5SRdwu9jQRj3Js5?=
 =?us-ascii?Q?yJMQ898NtKtrcbkkWYXjdmzr1Ol7llKCdxDO2mP0tiRuJrqI0cdjU/yQnUpu?=
 =?us-ascii?Q?BMSLEI0/9Je9TLrBrljWnIwlb01OrSUEPLa8mKLsXV8SCrES4OqR6HwZuF4r?=
 =?us-ascii?Q?GdWxIDAZJ2vgPwo9fNDIs997O4VhUWckdlRKRj9qJs7GQkEQXCeFRh3zQUBr?=
 =?us-ascii?Q?WnWNJGl5rPvNJG2ptMZfERUgFw8nAVqyVZWAG298ZH503ahTmMm9oAvsja7I?=
 =?us-ascii?Q?4aPjXnYaW6RsDqN0M+RRt6uG6C4X?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW6PR12MB8663.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bMDxNEpsBh/pB3iK2/Li7s6KlGJ6saGtNr+qGvb73LDadnocL06jFBHHzr0S?=
 =?us-ascii?Q?EuEQACOWaFU1BzXTasEzVTEo1r2yLzSX1YYnz0hneSOiHTjlHX3630TNcj5k?=
 =?us-ascii?Q?1qC1NjPiVsHh7HA0FNEyXtyhzkUMV7Qv0Q4wQBAX60VPyKTwwfhhonIzYCI3?=
 =?us-ascii?Q?Q+8iwjXq4mCivIBMcaUE398AKdhTntSiWf8jHvJca5ygfjhyuQjBwVOt3r2u?=
 =?us-ascii?Q?iDnPLkRXYvsVjxgd4HMEY+DtfSKm7akLK8MJPz7ses+p+kO0qVl1byrj6p1Y?=
 =?us-ascii?Q?b2zgktL+I9dpck3fh2rwdPKkCJ8WzukRb7/uDOxJpLdWS5myIiF2aa4Innmz?=
 =?us-ascii?Q?Y0NW7Km0lmFcxQinRCnoracjU/ikm0b2dJtaZT1x8Awtanahavc8uyKkp8tS?=
 =?us-ascii?Q?h3jZdLSocmMkLuMqTGnqGyvSJ0M/ASPQSMm4R19EpKHOhA17faJ9EEPPWzLC?=
 =?us-ascii?Q?uUPLNLhP+qq0pr7BHE6gPOV5aupobjCm266IygC7ozGgi2bUoYiXLFlpwNUY?=
 =?us-ascii?Q?xpvAlhq9YtV1zYH1aqf5H5HjQi7CMJVvLmFu65IiX8y+DsGybEFY8K9jfhGD?=
 =?us-ascii?Q?Xismzc5ljEXlf3AUPYf/ogDxPgX2b1SURIpg5B9XfH9d/c8pVaWtPXHMkPtv?=
 =?us-ascii?Q?iV1Eo9cWVzW6Z2gGJJR/6cgTGCZyGpU5xLdMyAJWmm8+TkHcvaa11t1cfx46?=
 =?us-ascii?Q?Ep+kvveFuO/+vVeW7TpqKsZq08sVI4VHVb4rB8V/rlbxMt2iVFU2DPvUjefU?=
 =?us-ascii?Q?MIW2RNdod4xt++imy1WjATHCGGuU1zGZVDNqPr7k6G1F6e8DfTHCEJpTQl4/?=
 =?us-ascii?Q?454RBR9I7R9SfYtzd3cGYJWzRxTqva9h3PHixvc2J0DYEYpXhvKcMwf8C3gs?=
 =?us-ascii?Q?jgTrWowTRSUkVZ2kCmjVuQAmf359I2s76d/hzjKQ9QjPuNt10cYGwlWo61Ep?=
 =?us-ascii?Q?71Vb1dKrJrTSACBc+px3lxsJ9WfrWKBOSxddwtm70jr2lbJSxjciBvVlMIQa?=
 =?us-ascii?Q?2wgfdzAgGD8J4ubQQv2p8xsntmTt+JlwtxbXK0JTSqN4Yo7PokPT6lH46xAc?=
 =?us-ascii?Q?HFfjrlzp9z8WNuXhSqs+r2W+c9CvZARcY0cZP6XQ4EsyJ7mmA33FdtMcr/Aq?=
 =?us-ascii?Q?VFbusEgjeGZPZLNZAlUrzVdkg7rUfjXlwv52CdRgkP94l7Kq56nQQWccb82Q?=
 =?us-ascii?Q?WzdIEWjkJ3CLz2oQBCXJEnPeKmTxrwIOz02QB3AQ7MQMesuL0LtnXlSMA5I+?=
 =?us-ascii?Q?hNJsUfKVPDrSGEaxciwVg0EhV1+QOwTRo/ZyIKgYbC4MknTr2JLlp3ESmv6i?=
 =?us-ascii?Q?HVvWufM2hyJIyZzdJ6x7m+VbiFnRw0ms8j0Fz8FuGQiz5h3pRUoAkxeUU3ny?=
 =?us-ascii?Q?K1/lAF8VlzWrO2xgZdUqXQvpC8Os5bP//up81jUaMRAgEysv/Y587eJjncZW?=
 =?us-ascii?Q?Gh7w2cWDuj7Nl1wmCy54xSCvHqZJvkAKuvHVtGGlR1Fu6JNz6823auTcMu6j?=
 =?us-ascii?Q?K+Xsd2YOeQk1I/7qIvJkBO3lb66NxWXvFu+vcI6xVdufv0qrIBOqZntyUjRh?=
 =?us-ascii?Q?HRGNarIaer34KBFvFSedSRbM1S7vtqUAZF80yTpf?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a85acadb-ef7b-4436-bd07-08dd5da451d2
X-MS-Exchange-CrossTenant-AuthSource: MW6PR12MB8663.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2025 18:17:28.6619
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f8gg13Gl1FlTQt881yrJV1wX6Qe0R/3A8bO4TH6IHAr8Wi8IMjoek4aoTsKmDryI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6539

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
index ee33d26dfcd40d..73a05b34de4768 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1599,12 +1599,6 @@ static struct iommu_domain *__iommu_alloc_identity_domain(struct device *dev)
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

