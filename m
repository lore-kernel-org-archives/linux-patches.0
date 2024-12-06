Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2056.outbound.protection.outlook.com [40.107.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B21468F5C;
	Fri,  6 Dec 2024 00:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733444634; cv=fail; b=suR8Lhu+YAPUhG/tDQX54QfNApVO+XNAUsaVEUFriyVq8cEXljW75VNHUMtKCaKi28uaoMcakb2LUgnyTNc3GGgMeVmx/FsTIuCaONtbkth1kLdhsG2RRYjvVEEDECTS98tQXjDYgZiBNXOYl57O0JCXE9VNT3nGJh5lU3Oeix0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733444634; c=relaxed/simple;
	bh=XEnCBDbu9QGRsTRZ4GoLWMF92Jc9F7xdQ3bLyl331qM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nP79NhBizA7U4eDnsCAXJJuXLe8u5PdrTpUauMTthnjzrNZnFmvBrlHze3IN+9tW/frdHV14uLGsm7H53E/3Q2QuCHjt0/cxjco6yCnEG89npqzuOlgFudGBPfYu2S6LdJ5pvKZ51qee4EXjTjbKISx9n+P6MtCKu2G2zvCeYYU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=EM2P27jm; arc=fail smtp.client-ip=40.107.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="EM2P27jm"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ShTuyBdIzLAHquGXhbBsDrZl9YdfIGICn/Jn8c2WazZgFMcvS9C2RbX/9fo+t0kK26TApISnU+ZGy4isi+bVpjQ0I3QS1dTPuuG+YI+myPJMbKLaXD4segA9Cv4B+/lJmBCmeRP5eLjn8M/7rKmn6GCm3wU2HC8MIpwXBn1samBbmadKwxA00nxUyWfcSCigxS6VIax1yyQPIkZAZJDWeGxgF8wW5B1/QeN/4smJp27WWAQKFuaudHeloI1febJ+idRUKdQp91k30w6u+z03TgYTLfyXF/xbjqrU+iukkKmkZ5FQrUmZhW6KLxpg515y6TOslDoXRQ8drZevEru3gA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uGj6mpZ+V3pzaUkfkdo7OOAmb122MadsVJDWqVN9Ztw=;
 b=FoEqeoMxisLWpLk1rUqSkWqJfUkV5zVcfyZXN/PGd2bAZQIcR546zM32i3NP0aCMBrcVqTL1etR2dr9j9kykkdRUSplZYV2BVBOPaGXPU/qhb5vRYpTojs+TzYLAfjJeD8L9EtF3jj4M9k1yVuEFRqCttKS1KVsf2+6s2+4zqlCMxpTRE7RUFMiQ02eY0Y/PIpMFl0cg5w/HWVYrhHQFquJ3ncXROTvPyynKPTaadKzR5YEi82zV+6U/kODiUcDuD2R2NXw2LiKezPxqKyOXAAJZDC6/7iZ7luq/HaQ/oEP58OKa480LXoT2W2H03az6x4z09344fOc/GAktyqffVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uGj6mpZ+V3pzaUkfkdo7OOAmb122MadsVJDWqVN9Ztw=;
 b=EM2P27jm4XQGPjKT/M9pcrAqknwu/vKK7rFBe7J/90/0Uvmsr8QCXWrQQkw6br102iFhHlRieNZo7OCQr6MypFIIAxW3kHLqCNOR4Hq6vDio6phwZosU0gAzomXRKRTtLf5HYqAmW+3n+L+LDf+jNtmG3q02eVE53GWiFJhOw1zG1dcPkN5tvRTn1NOTOHUw6RYSic7vP0Alqo/8b/DkJP6gV725+A+b5jjrp9IH1vvpZ6YyTJVhu9sTVG7/hL2Z9pmfGW8MIdI/Z1MSwXdv8Yh9Zl8XCptFg6lwu7JpVsiiledHhFRO49vxzO9AORaEEtzZZlgmxVNTT0vRISC+pw==
Received: from BL4PR12MB9480.namprd12.prod.outlook.com (2603:10b6:208:58d::7)
 by IA1PR12MB8224.namprd12.prod.outlook.com (2603:10b6:208:3f9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.20; Fri, 6 Dec
 2024 00:23:47 +0000
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
Subject: [PATCH 4/7] iommu/amd: Remove type argument from do_iommu_domain_alloc() and related
Date: Thu,  5 Dec 2024 20:23:39 -0400
Message-ID: <4-v1-cf88773f22d1+39bd-amd_paging_flags_jgg@nvidia.com>
In-Reply-To: <0-v1-cf88773f22d1+39bd-amd_paging_flags_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN0PR02CA0006.namprd02.prod.outlook.com
 (2603:10b6:408:e4::11) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic:
	CH3PR12MB8659:EE_|BL4PR12MB9480:EE_|IA1PR12MB8224:EE_
X-MS-Office365-Filtering-Correlation-Id: e501cb25-0b77-4a9b-ce2d-08dd158c3e58
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?UUDjHTxJ08ijlHouIRUX5c+z9wztmIu7kQo4nflN08ORZDzgZBjJYEoPCs4D?=
 =?us-ascii?Q?rvjUpiqBH9hwAw/VWeDJsc50f5oxlVHzjBrQybK8wQYWRkkaEsitPN6gp78u?=
 =?us-ascii?Q?bVBn9QQha56pN4RV4uMhaRbNXS3dbt2U/Av9WKW+y4xnQIpL/U3cTD31jo2P?=
 =?us-ascii?Q?gRZRvSlm5Jw78BJNJnMR8oAayuMmQZF6UCtVodSF6obdgmzvAAnYXDi22cF6?=
 =?us-ascii?Q?cNr112YoES9dawWRdStc1ZcP4OaHevcKg+m8KBddvFs98MDHLnb7dU60KeZ/?=
 =?us-ascii?Q?05ec9nWC2AAJccubCFmXj3nW9TSuCZ7niNlzKa7M+/FfxU+JCFRI1AACbuyg?=
 =?us-ascii?Q?EeLkXuO/O8C0gUxRTru7AJJaoIhInqOZiN+QU34mNwRDcsV/Hr+9gbuZ4X49?=
 =?us-ascii?Q?VKueP9eNuR2n86rKOfneah2yD86CJKOeMB0CpqtrxesO7J4iBaMyv17tWgjk?=
 =?us-ascii?Q?CWZEXebw1by94rkVy7q5FiY10LsbPwrLKFRGPXmKlQwwKeqyY8+JPD3yzENa?=
 =?us-ascii?Q?5U2fYuAPFAeBaoaicorGcpwumcu6MSmcSMtnQKMdz3BZBzauSBWHiClD9WQ3?=
 =?us-ascii?Q?PNxJrK8P5pWcm6cizMPGldzcoFIEZOSMKONsLX5KXx1zdIgPrBtk9GhkuPYj?=
 =?us-ascii?Q?9G4ySkBumePDCHTtWLYjVeFwOKHikcY9NyzeNvk3OACGUdAZcwnBaXOchiv3?=
 =?us-ascii?Q?K2CAhTtXw7P1V0woztDnxTxo2ugChqEo1u57q0R7n+K+iApIRlfJr5/fJU23?=
 =?us-ascii?Q?IoOaAKTzFFLPZlwYQsUU02zqgDDWv6DvPwZt1M1UnpJhSvkxfx85QICmME47?=
 =?us-ascii?Q?UBQ0HPLtSEMN8rj70OcHuWf8wicif/U+NeCIACcyhEiHSVIPm3N+oWNs9R1V?=
 =?us-ascii?Q?FNVcHzHT2tVDdNwPVAsgwzoNM9uCDqpeSN4QvZYMdgprYnc0gBRJ+go4hvPy?=
 =?us-ascii?Q?H4bnkbK4u3ZVP1Y+JmbyYS1s0jrizzcnaT/EUZIEt9TK2dK3+4g2QWljd4IE?=
 =?us-ascii?Q?7wZ+boqAbxYb6jY9YJsgrP4kovTk/AaKuh2c4uVD1SLDDZhyClFcI623UNCV?=
 =?us-ascii?Q?56vx9Qo3Lqxu8mTEZ26+SiX8DxQHbq9/bUfvZPlecS0ij+V80i1NmpnF7sdO?=
 =?us-ascii?Q?VGj6TyDX5aeNT0A5T9hMctGfsU/tZQ3YYK+lWTS1pncaEQhtbEkPVDCtas+l?=
 =?us-ascii?Q?e5e6/3ycZxIZPW2cPkPq8VCE91+58ghO6JyMEyvbv/2PQFgEwPsh/A7abV/2?=
 =?us-ascii?Q?NMm3oeko0Hd2GDALuDPZ36ir0riq04a7aeIWbvuiWcTRedhWBtYICoyj/DtH?=
 =?us-ascii?Q?yoExlq4F9ZbuT+n9M6oHHc4ZOnGF6qNCVIadYGeDh7Fv4A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR12MB9480.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?UL+T0KrmgXmRAt5lmAIB8DV2LKcICl5gBeFHHwJ/tZf2MJ1PA8J3OGseumA8?=
 =?us-ascii?Q?D70R2G93caAeTMZ4GfgpNkDYdElSbiRA5MfHQYnsprYWnIywqORBLyAyUeGi?=
 =?us-ascii?Q?AGcOeKq2pQ0JvoKWAl/iOzx+MSpBCbEsTGwvN+H58EMNhlroPFF1B3xFMgoq?=
 =?us-ascii?Q?/3vTW3NBLVzQLcZiFaiQGJr8mXch7w9bed60uy4za8NY3EgITYoAQHOKwFXC?=
 =?us-ascii?Q?jnref10Eqkkn8FVBZmOSWCBXUP22m/DabRNOkeCV7N3QKHf1zrRfgPXw9lxW?=
 =?us-ascii?Q?90uNgn7Xj3VIj+GrfosT641PHJ8rVtu/egfbeAHEcZcELtiVAO8RgwB4NtAK?=
 =?us-ascii?Q?oZ6NkElb7hEJh0AyBO4DYFi4SfXgCt3mDqum8UurHyHfcC+i051VqW0clqK7?=
 =?us-ascii?Q?LwJuQVUe8+NC7M5XJKqfn4UOicaP+eBZGKC6ZwOaSYcAF0Qmjpajqx1E8Ze0?=
 =?us-ascii?Q?dHM7Av2RQS/QnT5XBChhMXY3zA6jUinDANFYohky5wZT+JdhUoEPGauXb8Tq?=
 =?us-ascii?Q?yhl8d/9JjobODxhEGAe+SwgopkdamN5B1agIhXhvR34XDDAAjVMJbLRYcB3V?=
 =?us-ascii?Q?KmQzoK5p2nUQkHcq4xmKRzCRezSzSeDUQDG7eG4KOtuQkRxFNeY2T4UMYDIu?=
 =?us-ascii?Q?OxlXVtyE6hXvt0qyQ+JACOipsFcnQvKESO2bckESvNbQK3G52TdEzJW1p+KX?=
 =?us-ascii?Q?USI+0LghAebhjJF3jYEnPCZsJfxzqANRZ1shw3HjGGfTPwz3c9VkP5UGqImw?=
 =?us-ascii?Q?HHM1JFo4Tpu1rqEQQDbBCEH2nmLD/RWKF1EPEUFOG/KYXaKY4Wj4rvNXqnxd?=
 =?us-ascii?Q?EuPQi31cbUgKaJK6UgXIGBOi5rdtGZnlDBC1A4AJOPu0zZZC0XadkRQgrbwq?=
 =?us-ascii?Q?PtbluH3pc8mv/0Aa40VPb+kjrRFIq54Z8ruRTt9ukw2cXWgd1t36ySm+0iAt?=
 =?us-ascii?Q?GnNhE3zFARefMOVmNgSQyIIyHS6+u5vYxDHno1WGqHODTmEzzF6KuDotAVSX?=
 =?us-ascii?Q?twgf26JHC7pIFpyhlvH1TOtA2dW3ivCw83IbK/OLSYYj7fhnJf09ZTT27beW?=
 =?us-ascii?Q?sfkbYGxxEqnZX41Jh66/GCYz7YVkRQ14XSHeWaP2LumCfhSLAJmSM40Geuhh?=
 =?us-ascii?Q?XBNiW7ks2/7GIb670GUltWGQwtSzGia/YeXNlIk6ux9uOdZwM7/cRITnjXBX?=
 =?us-ascii?Q?2n8sbVyiSfFCFjYNcQCyHi36HmCyhMort//+4u1LazUciwm+Qg8lTUegtf5n?=
 =?us-ascii?Q?n4sV8syPtnVUaBFEhSHh34jf5xc8bZ9Q1e65k2zvK0qxwcfZV0+SLz4sifsR?=
 =?us-ascii?Q?+xWHRb5Pim+2j54AZWbGlV2eLsEJKq8CdcAxtYV6PtWuJcBsWtExayar+8dF?=
 =?us-ascii?Q?NI1X+8Ce+/AnkFz3ElBYNCJv0M4crFL1WisyhHqT0Yl13bFdYL17OXAhP7kN?=
 =?us-ascii?Q?8UN9LhOBOZ4L7e2haarF9y4m/MlvoQcGO8DApglMj/So6rictgwOEwkTMzfy?=
 =?us-ascii?Q?NprOmJjjZi/j0j8Jb6J3k7/R6TuMkvpX21GFBoD+bepj8Cp5b1bwpHEvhMwn?=
 =?us-ascii?Q?sm1lJ2QAH2s+mC9dByamUCUu5FfYbIXJgG2mh7YP?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e501cb25-0b77-4a9b-ce2d-08dd158c3e58
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2024 00:23:44.3341
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lov5cOSdBwT79ZGPIR5J2OkOu1VFRO4CGOwZogRXd5Fb2n534/T1ZU7DBMsc5DH8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8224

do_iommu_domain_alloc() is only called from
amd_iommu_domain_alloc_paging_flags() so type is always
IOMMU_DOMAIN_UNMANAGED. Remove type and all the dead conditionals checking
it.

The caller of protection_domain_alloc() should set the type, fix the miss
in the SVA code.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/amd_iommu.h |  2 +-
 drivers/iommu/amd/iommu.c     | 35 ++++++++++-------------------------
 drivers/iommu/amd/pasid.c     |  3 ++-
 3 files changed, 13 insertions(+), 27 deletions(-)

diff --git a/drivers/iommu/amd/amd_iommu.h b/drivers/iommu/amd/amd_iommu.h
index c38e02510cf737..1d384b2c6e28e7 100644
--- a/drivers/iommu/amd/amd_iommu.h
+++ b/drivers/iommu/amd/amd_iommu.h
@@ -47,7 +47,7 @@ extern unsigned long amd_iommu_pgsize_bitmap;
 
 /* Protection domain ops */
 void amd_iommu_init_identity_domain(void);
-struct protection_domain *protection_domain_alloc(unsigned int type, int nid);
+struct protection_domain *protection_domain_alloc(int nid);
 void protection_domain_free(struct protection_domain *domain);
 struct iommu_domain *amd_iommu_domain_alloc_sva(struct device *dev,
 						struct mm_struct *mm);
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 12c416abdce7dc..081a5dbe7ba7bb 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2276,7 +2276,7 @@ static void protection_domain_init(struct protection_domain *domain, int nid)
 	domain->iop.pgtbl.cfg.amd.nid = nid;
 }
 
-struct protection_domain *protection_domain_alloc(unsigned int type, int nid)
+struct protection_domain *protection_domain_alloc(int nid)
 {
 	struct protection_domain *domain;
 	int domid;
@@ -2297,15 +2297,10 @@ struct protection_domain *protection_domain_alloc(unsigned int type, int nid)
 	return domain;
 }
 
-static int pdom_setup_pgtable(struct protection_domain *domain,
-			      unsigned int type, int pgtable)
+static int pdom_setup_pgtable(struct protection_domain *domain, int pgtable)
 {
 	struct io_pgtable_ops *pgtbl_ops;
 
-	/* No need to allocate io pgtable ops in passthrough mode */
-	if (!(type & __IOMMU_DOMAIN_PAGING))
-		return 0;
-
 	switch (pgtable) {
 	case AMD_IOMMU_V1:
 		domain->pd_mode = PD_MODE_V1;
@@ -2339,27 +2334,19 @@ static bool amd_iommu_hd_support(struct amd_iommu *iommu)
 	return iommu && (iommu->features & FEATURE_HDSUP);
 }
 
-static struct iommu_domain *do_iommu_domain_alloc(unsigned int type,
-						  struct device *dev,
-						  u32 flags, int pgtable)
+static struct iommu_domain *do_iommu_domain_alloc(struct device *dev, u32 flags,
+						  int pgtable)
 {
 	bool dirty_tracking = flags & IOMMU_HWPT_ALLOC_DIRTY_TRACKING;
 	struct amd_iommu *iommu = get_amd_iommu_from_dev(dev);
 	struct protection_domain *domain;
 	int ret;
 
-	/*
-	 * Since DTE[Mode]=0 is prohibited on SNP-enabled system,
-	 * default to use IOMMU_DOMAIN_DMA[_FQ].
-	 */
-	if (amd_iommu_snp_en && (type == IOMMU_DOMAIN_IDENTITY))
-		return ERR_PTR(-EINVAL);
-
-	domain = protection_domain_alloc(type, dev_to_node(dev));
+	domain = protection_domain_alloc(dev_to_node(dev));
 	if (!domain)
 		return ERR_PTR(-ENOMEM);
 
-	ret = pdom_setup_pgtable(domain, type, pgtable);
+	ret = pdom_setup_pgtable(domain, pgtable);
 	if (ret) {
 		pdom_id_free(domain->id);
 		kfree(domain);
@@ -2371,7 +2358,7 @@ static struct iommu_domain *do_iommu_domain_alloc(unsigned int type,
 	domain->domain.geometry.force_aperture = true;
 	domain->domain.pgsize_bitmap = domain->iop.pgtbl.cfg.pgsize_bitmap;
 
-	domain->domain.type = type;
+	domain->domain.type = IOMMU_DOMAIN_UNMANAGED;
 	domain->domain.ops = iommu->iommu.ops->default_domain_ops;
 
 	if (dirty_tracking)
@@ -2385,7 +2372,6 @@ amd_iommu_domain_alloc_paging_flags(struct device *dev, u32 flags,
 				    const struct iommu_user_data *user_data)
 
 {
-	unsigned int type = IOMMU_DOMAIN_UNMANAGED;
 	struct amd_iommu *iommu = get_amd_iommu_from_dev(dev);
 	const u32 supported_flags = IOMMU_HWPT_ALLOC_DIRTY_TRACKING |
 						IOMMU_HWPT_ALLOC_PASID;
@@ -2398,20 +2384,19 @@ amd_iommu_domain_alloc_paging_flags(struct device *dev, u32 flags,
 		if (!amd_iommu_pasid_supported())
 			return ERR_PTR(-EOPNOTSUPP);
 
-		return do_iommu_domain_alloc(type, dev, flags, AMD_IOMMU_V2);
+		return do_iommu_domain_alloc(dev, flags, AMD_IOMMU_V2);
 	}
 
 	/* Allocate domain with v1 page table for dirty tracking */
 	if (flags & IOMMU_HWPT_ALLOC_DIRTY_TRACKING) {
 		if (amd_iommu_hd_support(iommu))
-			return do_iommu_domain_alloc(type, dev, flags,
-						     AMD_IOMMU_V1);
+			return do_iommu_domain_alloc(dev, flags, AMD_IOMMU_V1);
 
 		return ERR_PTR(-EOPNOTSUPP);
 	}
 
 	/* If nothing specific is required use the kernel commandline default */
-	return do_iommu_domain_alloc(type, dev, 0, amd_iommu_pgtable);
+	return do_iommu_domain_alloc(dev, 0, amd_iommu_pgtable);
 }
 
 void amd_iommu_domain_free(struct iommu_domain *dom)
diff --git a/drivers/iommu/amd/pasid.c b/drivers/iommu/amd/pasid.c
index 8c73a30c2800e7..9101d07b11d3f7 100644
--- a/drivers/iommu/amd/pasid.c
+++ b/drivers/iommu/amd/pasid.c
@@ -185,12 +185,13 @@ struct iommu_domain *amd_iommu_domain_alloc_sva(struct device *dev,
 	struct protection_domain *pdom;
 	int ret;
 
-	pdom = protection_domain_alloc(IOMMU_DOMAIN_SVA, dev_to_node(dev));
+	pdom = protection_domain_alloc(dev_to_node(dev));
 	if (!pdom)
 		return ERR_PTR(-ENOMEM);
 
 	pdom->domain.ops = &amd_sva_domain_ops;
 	pdom->mn.ops = &sva_mn;
+	pdom->domain.type = IOMMU_DOMAIN_SVA;
 
 	ret = mmu_notifier_register(&pdom->mn, mm);
 	if (ret) {
-- 
2.43.0

