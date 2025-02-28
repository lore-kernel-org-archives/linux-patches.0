Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2053.outbound.protection.outlook.com [40.107.94.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3303B4A3E;
	Fri, 28 Feb 2025 00:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740702015; cv=fail; b=GJbON/ZyTL5WpU3oWeLbIR65ZmBUgiu1lH7CN3ijClnxjcE7xx+n3tf2YwzlfB5RPv4DKi3/SVi0XlPGWozm+mEUXAO622lhUkrNZwZBkzrPfSKNQaWx7caREtULt7+8ELYRPP0J0XlWLbkQKm47df/lze3mN1Rm6XgsyS+Om0o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740702015; c=relaxed/simple;
	bh=xMpziuwDlEcDtsvDnM9L2EsfwiGlvKJH2jRvifY0WhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=CAd+fxvkZe8YtmzoArGkHJYLxgYolZfbHWtC0yGNYE/Wn7peFciRjiSo21UDGIIWYtz+sPqj8fBWQDAZ5jUDOK/6w8CEdCe3H23NdxhghAvRSS5Qjh+60W+6RgsMQuvGrnIwWmBEp+yEWI4I/5Laq8KVtORZIPUogDymBUFFimE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Peo/uogd; arc=fail smtp.client-ip=40.107.94.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Peo/uogd"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IGJ/xiS01OOlnwo8ygAOv4PvI4a2BCEJM1eok7rFHiBftB3DCXUoxZ6HVS0i8peTJXyPRsURduqYweZTm+JwQQ4cD3EqdvtystJjv1aekFJVyYY+yHXSsryOJ95+QmbQTtFKXl2p8VqPpsgf5I4gRrjPrpZUKIN5judK3iO0CzyYZROQEkFmt1U9DpOpU+neWI34feX24PK9lHht8pswOpYEYyWy/XOMH2TdZQhAjH7O9RwPfZ2+BWMrtvQEdRp6wNKJh3bDlHgVaN9h+bS0UNKW/ncQ11HJDOsxI81OXfK5q9RoqsOkPcox2x23sXAhpvMmB/9P0y4MJ8Q11kVOaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z+86hRHj4xAEs7GuJljSW5ZbGQ0x5uhgu6ico2Fg85c=;
 b=YfsyablflkCqQhPkh5RNW4ryxEfwGhEqxXgmvUBMxnj/KqKitMd18LQoDy5IOiGMtwsjNGPTuCJioPGS+l4MU3EKz7HrMuvE3+UqEu2dbbUU5rG1s4nlR9Ahbt0FECgxbligRux7m5PuDvLU6pwCqRcT38rqiUF13VuTPBur08zVUmH4aE+Op+NHHeHlmFu1cjjni0t0/WQRLgTM4sA/AoEjvYh123AbZgZp5IV9cY8H44z/xcLO4lAObMn0dmH3nRnkJXpUiFuDQDmFkq9bHmHMFd3r1Egumo+ROK+kBBEdVMCzIL4fzeE9uvnSHDV7gM5rjupU4ASMJbRVf4socg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z+86hRHj4xAEs7GuJljSW5ZbGQ0x5uhgu6ico2Fg85c=;
 b=Peo/uogd7wdHWQSD9DLOL42Yn7kYsYcxzgHu5h1udmG84jObu2yyO5LXAwN5dxLHw8mqDCB4mAzg8AHPGUHj//JLNigaaPkfAGCsSXOG8VCy15Yseyl/q8lz91Ppa8AkjzfuonYyRxtg2A/EXHwg+2NH7O7SAPF4R63YNMLYVWIBrBtgJv9yerEk6UqacZPK/GFohrupNjWa9oVk2eYDrVwZ+zJ/IBneESfGcmZY+S+o+I09eLK3eSXFcon3AI6yvkl6SK3TLkJAuB1Ou4HrRe5FNBnm12oDphFmfK1EZPFTEJJzJvZIUlY1LZp+gPZ7Bts6xhtlkRZxr9LgZM+mZQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CY8PR12MB7433.namprd12.prod.outlook.com (2603:10b6:930:53::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.18; Fri, 28 Feb
 2025 00:20:07 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8489.021; Fri, 28 Feb 2025
 00:20:07 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	virtualization@lists.linux.dev,
	Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
	patches@lists.linux.dev
Subject: [PATCH v2 3/5] iommu/virtio: Move to domain_alloc_paging()
Date: Thu, 27 Feb 2025 20:20:01 -0400
Message-ID: <3-v2-a3b72fd4b99a+1b6-iommu_virtio_domains_jgg@nvidia.com>
In-Reply-To: <0-v2-a3b72fd4b99a+1b6-iommu_virtio_domains_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0144.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::29) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CY8PR12MB7433:EE_
X-MS-Office365-Filtering-Correlation-Id: d3350774-418c-440d-07b3-08dd578da73c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cXpvA3bTxbF+UVEQC3+q7NGayob3fTWaBk6FRpMNmb63QUm6RO9a43DtOJiJ?=
 =?us-ascii?Q?leVnKRvFKo5XLiWOvqJUOPssqnldaqcPe8V85DteUlnJgZ36ozGKCDLfF3EA?=
 =?us-ascii?Q?BWtHLwxJcqgrfCvRkYx+U3pUzWtJTC5u1YMo+gdr46PemfSP3sCfCPYi18qc?=
 =?us-ascii?Q?ExgGnrTOUXgHzzZ9OdAh+S6HYsaspUIv1kKkA4Oi1vPEpdadoaYBixswQVOm?=
 =?us-ascii?Q?cV9tvKz9GOBrxJYvgOb+3yPEdpdUbnBRt6cggxIMC6U9lu8oHfsryeFEzwkh?=
 =?us-ascii?Q?shevP87/AKJ5+kgQADGVpO1fOjNUtqvaIKLpqVS9y5KTsU00X1EZ+uz9qGci?=
 =?us-ascii?Q?7FrwLj2DOQ3YLnOmha1ktXH7PLJYifRaPhtlco6uib29m2esvTecsv7N1jMa?=
 =?us-ascii?Q?SRLMmL8gbS2Nk+DUA7HfjcBZY+Mb03geByVmemRpO+4VqVNmB8RXYBA26dUR?=
 =?us-ascii?Q?7cZLc+9lImlMjFXODyOs1WAPVe7boXag7ebaPFzZxCJHFxUY0QtckzpenzfT?=
 =?us-ascii?Q?FnsdCvDlZvv3/+v83b9AzFazpKQRjHSWcnfAhJopSkJ3due7cX/x32czdKLL?=
 =?us-ascii?Q?HFBl8Snb6qxCcv6xUkteTThP2I1//VBa2jtzkBF/sfJgHX/FPxoeKOCGBb14?=
 =?us-ascii?Q?hFI9BFxRcBwsicx9Gv+Sbf2A6pN4OzHwlUuOf4Nbu0uwNMd8fmmnmCgjYgME?=
 =?us-ascii?Q?gVO7HNPy5T4SS6TFC2KTvfBvExBCDtuvlFwJGMTuTX9TfyrDnwGBdnLlRMAE?=
 =?us-ascii?Q?ugrpChaVp/wVlp4iDebJyKFqgThf9xqCtwtp3fH2pn7zy8RrLB4oODUbPGSi?=
 =?us-ascii?Q?oTWZlkrz3I95GyT8H0ELuyB72QWG51sfjmcLH/UTk63DXKSVSGrWGboB7EzA?=
 =?us-ascii?Q?oJHEeRPJcVpfUmVqZj45XpKe2j2GQT3YtBZ/rJSscqKMD1Wh61dYU/cCyvLt?=
 =?us-ascii?Q?IQQz/e7xAKCUjaYd45rWJPnm3gJq6XIMgM9neBO87bJNHqBoXW9ODHs2r+J3?=
 =?us-ascii?Q?LKx6UKshb62t/AA1qcIg1j7DMLvn8nLrzh1lVNDKKCdRkFLHVhSfq5+ihcfl?=
 =?us-ascii?Q?yI6YgNLDgx+hw+Dm9luFqb+iYaw8N2bSYslrd7D4DgtR5Y6d4xZoDuRaxGzL?=
 =?us-ascii?Q?TTKuBO5fV3d12f2AgiqrxGP+c4RNSxR0yDtmzW/VnX7ALaILgsllehtMrUT2?=
 =?us-ascii?Q?ooTl9vz+TS5AtsWQO0lh7dXIwbkVCBKG7qA3naH0/5R63RxKc2upHPNDimDR?=
 =?us-ascii?Q?EffQC30JRDnjSHs0JPg05t0Aa3org1KUILmnESisKO65vEzVTc1uOFt37L1E?=
 =?us-ascii?Q?JpYTqtO02QaYtNDN5PH7/GIPKP91JwED0uYnKt3iRGqoeUK3BuU3Yculg37+?=
 =?us-ascii?Q?ZZr4bNpVfvU4+68mGz4E0wdM151R?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zbHaHSKz1h9ynhjogQO+es+zHXhy9AMFo7WA87NbDsUhmMxDupAOyEa4grnL?=
 =?us-ascii?Q?9HX4mR9k9o1oRimnSbCuuinmb2payaJUHeQh0KlUglbk4xJ4Fw12HojoBpU7?=
 =?us-ascii?Q?BVlMgyyXZzpgyVDK1zkATjhj/Ll64jkwjAXFjcNgCnMRMyDQW1OhCJln3XS2?=
 =?us-ascii?Q?KtEJ5wZz9xm7i1waVvGt+9eeWK268VGpYUiq5QnhdfH0AbvVCFXGjz0Y7Xiq?=
 =?us-ascii?Q?lY03SqtSMqevY2NNOHrOWwDFUxT/in+30KDaTfC0nWK0ICeEEz0YMxim6iPH?=
 =?us-ascii?Q?tXkqdVGNLuOcJ8sU2lhfAa9Y3mPozUpl7gwudl5RL9nlU/CaNBN8DM6DUpXI?=
 =?us-ascii?Q?Zub7/FYxW4SjVh4vQfRtQ81syMN8iHTfBFLwqGn2GVmHhKhb5bjTIJCG9YiK?=
 =?us-ascii?Q?1LALxX6ai+j7FE5Z2sbVpLdUxe4/G1ZBBiMuzA1yn/1hKvJL1vPzEy7hKI79?=
 =?us-ascii?Q?jRqTZfWWBdKEwv2y+XdkmrYN1cROxVMj75RZXe3BLMIvbcrlqjoKlssAcCgL?=
 =?us-ascii?Q?GOruK9SSKMhPIZnpLGCOoM1hqqTJ+bT495CGfrQtH+DyxPtJp7/DUJC8OpoD?=
 =?us-ascii?Q?/bx5PiCXyQiAeQvAGzIarTNv6qVfs4MVCJbDncFGqwUaxCdlTghG+pCclXO+?=
 =?us-ascii?Q?0BvFpZaj5ATBGXsKd4ABDgGIFQHRoy65g03yG3FxKBt5+2OpJ2sEx3Nq8w3t?=
 =?us-ascii?Q?3PNyvxi1W6d7lKuFLRMadKVqIHElOrvM+BdslSSM00q+62mMxHyUAqDogs12?=
 =?us-ascii?Q?4alVrxUwTmnklAaXBGdtTR7Y1Rxfg7b0eIX5w7rMHxHCoG4h+USjoGoMRYow?=
 =?us-ascii?Q?ssp6t+3zs4r6KJ9DrMIBlkTzCVd0cgRC7S+P3/3ezNYMQ99ejKrDoH+APMOb?=
 =?us-ascii?Q?JADxk04RJQXOclP4Gq1EWaveQ06ViudqcRPu9yd56M0lWvB5DFAJhL489Gkz?=
 =?us-ascii?Q?PycMElvjZ6rSNlV/15zgrUp6dsZX8Nnp2XnGDtAgPVey84z7zpSf7soFCgEg?=
 =?us-ascii?Q?QCR5rE9A++/mf2PHiW2mL2s6SBHSnZSv49zRYPVKuqWK/Q9m9MuO9bf4WWWX?=
 =?us-ascii?Q?Bih3uCPVjsAo/gevMS08vLdZBbNpTarrSVrwTjNmDgRaWnFn/AOpDGvE1ZLC?=
 =?us-ascii?Q?uu5BBh5aoEyc/yqjfvj1mPtqUDKhQgCZ6UOLX3v39zi9wHwCg0UI6sZEB4ey?=
 =?us-ascii?Q?ISNld+dTnAH9/6FQfjQhyopDy2D7GNmmpDucQQat5a/Dq2fbkVEwJL2qtnyt?=
 =?us-ascii?Q?JXG1o2eALwMMZBdm1Gb2H82U/UI8w3HRRlxEoGOsTLWToanXtiYh4jQSneam?=
 =?us-ascii?Q?rZPwUAXWjKEpmk3TBWCAEUS/NrP90ViKYK0/jChiANktYSz7ROWsoImy1fal?=
 =?us-ascii?Q?OX6WvpMAHgENzKJjq/fudLZKC1pmhOGzNyC4Ylxg4C5j10jQSw7JYz1GcA/f?=
 =?us-ascii?Q?XHgVum+Fsi8sgLSC23EhljfFWNzmhEQZzFnnXVHxShAKTPcolX2AFRGFV/D0?=
 =?us-ascii?Q?KFK7k1XG2Z5GfuWAgVK2CGvEgsfJLlG4rDMGr1l42HdLReLam9Cj0EncVu4E?=
 =?us-ascii?Q?zyFfg6Vr7E7RhlcK3ume1XGmcbuPGgiSzEzedjD2?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3350774-418c-440d-07b3-08dd578da73c
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2025 00:20:06.8009
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EiymTCEknKi5TGeA2m8deljEfiFTvLbww5TlKqHQaSXGl3tvz6g2Jas/d/3IVDP4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7433

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

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommu.c        |   6 --
 drivers/iommu/virtio-iommu.c | 114 ++++++++++++++++-------------------
 2 files changed, 53 insertions(+), 67 deletions(-)

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
index 2287b89967067d..cdb8034ece9bde 100644
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
@@ -1097,7 +1088,8 @@ static bool viommu_capable(struct device *dev, enum iommu_cap cap)
 
 static const struct iommu_ops viommu_ops = {
 	.capable		= viommu_capable,
-	.domain_alloc		= viommu_domain_alloc,
+	.domain_alloc_identity	= viommu_domain_alloc_identity,
+	.domain_alloc_paging	= viommu_domain_alloc_paging,
 	.probe_device		= viommu_probe_device,
 	.release_device		= viommu_release_device,
 	.device_group		= viommu_device_group,
-- 
2.43.0

