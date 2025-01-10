Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2070.outbound.protection.outlook.com [40.107.243.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86BA2205507;
	Fri, 10 Jan 2025 16:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736526915; cv=fail; b=aqLf0Z56Z+u1jaurwDuad3eaTIKvWD+7W2f08IeWwmkJ/eRjgAgG33WnscKZdKvlYO4U6Cl0h6wZ+oChCzrX0Ka/w8uY97FRjJa3Oj50QqD+fHLssCUWvnILinRvn3p3r7IID2jH3yNMh6pXBE7z9jg1zeKuphBQ5XriHYMaRv4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736526915; c=relaxed/simple;
	bh=S7Z9+NRwyY/s3Gwl5SL/SrwFYP/qhLBYyJsCM7a6Te4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=eXr6BzGnG/1o3PU9s+AoJqR4QIlOV6Dsd5WpAeX3DT3+k2TX1JpA2drFhQ6hkNvdZqL6nz6yDplVIbJnB7GKuW8K8cVc47UAqymL8AB9CVRQrNdU+ylU6xIuRdAPMeWRpHwWCwxPrdZqeMkDjTpdYsAjl+dnqoqrc7RkAexbEG0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=t7ZH/LP2; arc=fail smtp.client-ip=40.107.243.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="t7ZH/LP2"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PjH6sQjXEb4cBs0mFEiZSIQfT2PKLlqPVl2vIbfXbgtDOMsKMMGe7NVyJL3XMKysNOv8PXA0R4Bj1GoytcK5CdF3D+I7jhXO46dx9aURysviKyj3z+c203jTPYNPcuUP1lvJfBUgNxT45RFtZ5rykrjkmgu8JqcE2aRyl/J2alisoHehK660KStRg5SwHmaygvB51IYjV2bMyeSDBThbH75a8ypwlRdjFO+GNdrkC0y6E9fxtXyCfCyxED4+H2IiXGgE4c5YPjd+vd38Ua+6bgVRD2G0Msa8XE2I28QrXhBTkv3lPndEf3KH2IetyHzC70BwPEzsl6HgBZ+NGMZAcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FaDqK6jSpNS672Zv6jG5nBhdDMbkqWl1MY/hMzZu+GA=;
 b=kKenfVSzFj/JOTsrj+T/J65u9dU7lqoQeLjZuSUfSJ0wwwvOpW7feM5fMiHOFMutxN9KYGJCcABoFQGJzLmITlFgIDyHaB0QdbPvkiR/SY7geyYzURqKAJMXafS5HCACZ1ETPLNAABl6R3p+kmIkrWvbB5No8jg33NZqRyDjxzBMH2AorNSJ/yHhVhyQXbwhiePHWVxmuGZUqALbHU2SX/kL+rj2o2juJe8Pjagz/688ZD17m/G6wWagovSjX27KfeheuHx1EH2ufH5PAV1gAxdGlCcBmQb3CoaONEvgrTZpqZrx9/e/jtwUW0Z/uRswr5uslTvCFSDXCF+zOjSKvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FaDqK6jSpNS672Zv6jG5nBhdDMbkqWl1MY/hMzZu+GA=;
 b=t7ZH/LP2EwH/zE0C8mVF4SyD3tsfTY4G1wDMs3lcqi/Ae+3IPbUX+97iEUpavJt26I5f44cwhM3z8fJzwR1XTeumURE0VC9ip1jpuVW7ItsD75shZqfYDflqZH0vjAWtlWvPmmdAfQKTVOKYvbTut+qgLSuX5to8k208JLlDihcwB3gvivGvvIJ6LAYfYlnT4a/DR2EDXzIxoQgJeF11pDetyHAZXktKKRSHqacMRuE1jB7mkxH6JLod766M5jWrIw7dC5UR5Wjb6wUxSCQqYWZzMwryIBhXuyGj+HgpsANnwcRr63yNojLuC0s4BHmsWwHXDzMEtUQLDdvbxYL8yg==
Received: from DS7PR12MB6120.namprd12.prod.outlook.com (2603:10b6:8:98::5) by
 IA1PR12MB8311.namprd12.prod.outlook.com (2603:10b6:208:3fa::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.10; Fri, 10 Jan
 2025 16:35:09 +0000
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DS7PR12MB6120.namprd12.prod.outlook.com (2603:10b6:8:98::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8314.16; Fri, 10 Jan 2025 16:35:08 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8314.015; Fri, 10 Jan 2025
 16:35:08 +0000
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
Subject: [PATCH v2 6/7] iommu/amd: Move the nid to pdom_setup_pgtable()
Date: Fri, 10 Jan 2025 12:35:04 -0400
Message-ID: <6-v2-9776c53c2966+1c7-amd_paging_flags_jgg@nvidia.com>
In-Reply-To: <0-v2-9776c53c2966+1c7-amd_paging_flags_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN1PR14CA0014.namprd14.prod.outlook.com
 (2603:10b6:408:e3::19) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic:
	CH3PR12MB8659:EE_|DS7PR12MB6120:EE_|IA1PR12MB8311:EE_
X-MS-Office365-Filtering-Correlation-Id: cd7f964a-9ed4-458c-1683-08dd3194be37
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?68IxUXiFdLmBNBkX/WAZ/jwCdM5JoPK3xNRt6Gxd/KSmN/fsCppsLMAelsN1?=
 =?us-ascii?Q?ucFRI2tLfmXdzPcKGUwnOvJziF4CAOTr7n4zCu+/f2FK5MYjFqTzv0rHxtq4?=
 =?us-ascii?Q?BY0TEo1VOVDXVqNc72qdr20tjnMhSDVj7OIIJ+4dmvtY5RbtX98X8LPADGhy?=
 =?us-ascii?Q?gsOZSAJmR2ySJYbBXZGAvHR618472rXRw0LzHZIod+4qS9v6F41qQ1Z3y27U?=
 =?us-ascii?Q?CFsIV4KxESv15cWftJ7poNqHI7eMD5EQs2+EsI7RxtWdBFKMx5mDhWjlPw6t?=
 =?us-ascii?Q?E+cCLNlZ++NMvVtXpDZ5TbGJAyJZeF4ySzGM9Fyxi5AuHKPYxRlxRI3nvRN1?=
 =?us-ascii?Q?g6/2BurQ57rLWT4I7GoG9cEZATgbhPshixNtRoy2O0/Z0H1gtULaziPAeO4r?=
 =?us-ascii?Q?7o8aevRA1T2um+HkMDcWpfOzd6F1JT5uftt/EuPgNqVDUh0Ach97Sv7Ubsp0?=
 =?us-ascii?Q?HWWfkdTbDweR05lYGubWUYfGMhXQBOPquC3N0cIJDHgV9cG1g/kw28j39zvR?=
 =?us-ascii?Q?ZYRdvvS1a9JDWQyUwyTKF58jKI3Lh8v09+nnooU9NnXKr/COnTS1lWA0mu7G?=
 =?us-ascii?Q?gbbhsBYudv+1+/+JNxjnp8HWz3OV0F+LX9Jg79Yb2SZL7j20Yz9l7EMoBeKP?=
 =?us-ascii?Q?/mZzTtjjGU0wsEUCzWhFu0V5tqp8JL7YO8X8sq5zUbSCe4n2R/l8bLulNIBt?=
 =?us-ascii?Q?bYFkwTbiZ+8F3Ec0IMtBk9qBvqh4UrVQfSRd+6iZjg7+WYSUIyK1iuR2amzz?=
 =?us-ascii?Q?gffOwScNNR5LXIV0pOAPFTfcNmlQWbrS1yI1IfQ7PzCNFIoKydQi6F6BnDp9?=
 =?us-ascii?Q?t6n4pkEy4udOVAXcHkZjWHDICarhCTTvUpOTFRDJmPpjSD86n1z8qB9MhxuT?=
 =?us-ascii?Q?3vum8+YdkyWGt4Wt1hrQDPDAh2n8VoHQLoM4iYe/uDcVIvKKNSHI1QD83VJu?=
 =?us-ascii?Q?AVTRP0tzC7ZFdHJx8hTCITSPYg0lck0SAB2KZXcoCecrEKaYWr8/I2Kak7HT?=
 =?us-ascii?Q?PzdxuU5bHRx63p2JJiTVhk1gLS/zAClI/TnIpmS0fkeHvAi9hxzGn3WBfkp5?=
 =?us-ascii?Q?G37t53pQST9KT4BbuXGc+6K53jCTNnQTD5YGi1bLLS70+DqfLSRPXPhIvCfh?=
 =?us-ascii?Q?vxJezSEy7xkJuFcE60C84+k0Napkw31WNCEL13XaBvqQeLkEsXpsvyIJQJdh?=
 =?us-ascii?Q?jvJnp1tvRPUsz7dDzO8Bcj+RXtgZeTeyP6BQT0XAL0gVWfZO5gQ/vora19yA?=
 =?us-ascii?Q?wku4OnJRypsIHbQD/Ol6wh8impA5JPAQmGyEQydYxYNvRJJSr03Arsu5rvOY?=
 =?us-ascii?Q?55xq20r0Yj8vc4s4L5SCD9iRi7MNZ+exTN3JVyRsBDG3GOsqIne+9F3+yuHJ?=
 =?us-ascii?Q?LQJcOpH1qkalTNQNIkZgYEBbW3F1?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6120.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?synuxajaimYHjh4sO8frKdIiD3d9vyYvnLWnedLabD8zps0BiLfpnJENgtTH?=
 =?us-ascii?Q?eXAPmwLG2dZxG5/yfGHlchNXG6T71zRBWqOjFUyW/Cmrd4IrQytFrDvgL9Pp?=
 =?us-ascii?Q?ib0oorXkNfgEBn4u2TtvfoFxP8xNcZq34YPyFq4a7d0IsZlWgjF6igy/D8V/?=
 =?us-ascii?Q?QrN8nf+dyap4OhuxTBbfjpnpiT7ZqLCQ8PCVYGPte5twRP6Y9LvRfuWi3sL6?=
 =?us-ascii?Q?BUxYiEUW/1BcY1d/QbWERBP5B4fMmkEgZqJny/+7jf9qKd236k69GyC+N8Gx?=
 =?us-ascii?Q?DKIZ4SjZv+PqqGRAw/MiMpi8syv74PNBQCnbKUUR6u5RR+iqS1t7cjdZEJ4G?=
 =?us-ascii?Q?dpYFIIzYb1E6ltivT3iHzk60O/RlEcg0s04ir44Ojwa/1sKsRiTeVqisBJEu?=
 =?us-ascii?Q?3+9CCINFlZYbegHUKSSVSLslocHXu/Zzxc8yRK9Zlu4o3jsYpEuYjox06cth?=
 =?us-ascii?Q?7rNWU01UXMimIzd+pYg7j2z2Js23t6E/g2XkFb1OP7bAPr5kSUbktJStRcuC?=
 =?us-ascii?Q?GiJDU4XjJQ+KuZgBHvhPdYlVj1Iq19V3TEdvrmb7zRDJwjtRnstaGcuC5IyU?=
 =?us-ascii?Q?HIJNw9PqSnzzAhvrVreg1zNA/f7B6dNO3W7K/TPuXcAsDVPjS7NZ2XxlFNna?=
 =?us-ascii?Q?jBlvyORvOU9Tk+rlqFVBF5Dl2lOPirCoqEWbVHNN6FqOFdBHJlLemPIVODS7?=
 =?us-ascii?Q?lJj7AxXH3c1UchwcPCeupWvEWfAAWXZgPlsh3zZSr8mzeOjWrkyk+skj+JdM?=
 =?us-ascii?Q?bmpKqzbIclYw0Hd3haL+J0Y1IRptDLiA2ri+Qr0/m928Ng9LJiX5jp8TFtAg?=
 =?us-ascii?Q?Q5yPChOgkWxXaH1ryCrgei/CXM7B2qyA8jA/EMqqWEXmDHy0tVnl3Ax8oNiA?=
 =?us-ascii?Q?UhZ2d1zlDkzly/tbxtT9bdN4/0rVB4ALXaTZt195ipuhEClF7PYP1UyYUcJ2?=
 =?us-ascii?Q?02XUdbtM/nZcmmPgqEjJfuUm5u6/CwAd5USbwqcXjG9BG7k/rohbry/VwVt1?=
 =?us-ascii?Q?KwmURduIMyIOcXXHe938YUAkDo5jJkkqLq0fIwLFPnFpCAj5dkvdr167gSWf?=
 =?us-ascii?Q?usO2EeYEWnuaRMehQCHJgSJKraaYujSJ3pX9UJSuGlVmJyq+dJPkinXFk+SJ?=
 =?us-ascii?Q?cdIMqhZsRJDInJtMt53i+9wsV7QY5Akxc6m5HUZnMvBH3iUua2dctEVMaCj8?=
 =?us-ascii?Q?ZZjjxaS9t8GkyrOF1pmqTuc/IY+UCNk9/2uhDcsdEuh2hmPvqn49O7k/PlRz?=
 =?us-ascii?Q?PrRPMgZedLCU6ieZJIxrbEIeOubPmcO8I4raSX5HLL0ukeoEM+vyLF6NJftQ?=
 =?us-ascii?Q?zfyicOlQ0kSbwkFHKGd94mAYEeR/y94JcMTse3uOVDW6C9T3DYoUpY8RRHfR?=
 =?us-ascii?Q?f8Mrt+JdeJlVYy803aiEASKMEUAeiBGexLI4eh9KZJTo4sSuqe/rk9P98VNt?=
 =?us-ascii?Q?DCtAAdFhfawCFpQc+CMy1Uny+d1NQiIlyE9oqm4i1FQw+AFD9cGIM5wRxP+b?=
 =?us-ascii?Q?MwbDRLamshFdvEztGvrJshKqgcda7ENE784rkFp6x5QVF6t26zakgXyxsuWw?=
 =?us-ascii?Q?S3trhen8Rp+jsmfK7t8gicGlNUW+oAfdah2K0Kuw?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd7f964a-9ed4-458c-1683-08dd3194be37
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2025 16:35:07.4352
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3cj8+Sy262VTGK6Zz1HZEQnY3q3TwhiXgSVOYUV/x+T9D+T2san8mzq46ZvCC2YI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8311

The only thing that uses the nid is the io_pgtable code, and it should be
set before calling alloc_io_pgtable_ops() to ensure that the top levels
are allocated on the correct nid.

Since dev is never NULL now we can just do this trivially and remove the
other uses of nid. SVA and identity code paths never use it since they
don't use io_pgtable.

Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/amd_iommu.h |  2 +-
 drivers/iommu/amd/iommu.c     | 22 +++++++++-------------
 drivers/iommu/amd/pasid.c     |  2 +-
 3 files changed, 11 insertions(+), 15 deletions(-)

diff --git a/drivers/iommu/amd/amd_iommu.h b/drivers/iommu/amd/amd_iommu.h
index 0fb0c8392b5307..68debf5ee2d751 100644
--- a/drivers/iommu/amd/amd_iommu.h
+++ b/drivers/iommu/amd/amd_iommu.h
@@ -46,7 +46,7 @@ extern unsigned long amd_iommu_pgsize_bitmap;
 
 /* Protection domain ops */
 void amd_iommu_init_identity_domain(void);
-struct protection_domain *protection_domain_alloc(int nid);
+struct protection_domain *protection_domain_alloc(void);
 void protection_domain_free(struct protection_domain *domain);
 struct iommu_domain *amd_iommu_domain_alloc_sva(struct device *dev,
 						struct mm_struct *mm);
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 4ccf373e315da1..7d7317dae2528e 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2177,7 +2177,6 @@ static int pdom_attach_iommu(struct amd_iommu *iommu,
 			     struct protection_domain *pdom)
 {
 	struct pdom_iommu_info *pdom_iommu_info, *curr;
-	struct io_pgtable_cfg *cfg = &pdom->iop.pgtbl.cfg;
 	unsigned long flags;
 	int ret = 0;
 
@@ -2206,10 +2205,6 @@ static int pdom_attach_iommu(struct amd_iommu *iommu,
 		goto out_unlock;
 	}
 
-	/* Update NUMA Node ID */
-	if (cfg->amd.nid == NUMA_NO_NODE)
-		cfg->amd.nid = dev_to_node(&iommu->dev->dev);
-
 out_unlock:
 	spin_unlock_irqrestore(&pdom->lock, flags);
 	return ret;
@@ -2446,16 +2441,15 @@ void protection_domain_free(struct protection_domain *domain)
 	kfree(domain);
 }
 
-static void protection_domain_init(struct protection_domain *domain, int nid)
+static void protection_domain_init(struct protection_domain *domain)
 {
 	spin_lock_init(&domain->lock);
 	INIT_LIST_HEAD(&domain->dev_list);
 	INIT_LIST_HEAD(&domain->dev_data_list);
 	xa_init(&domain->iommu_array);
-	domain->iop.pgtbl.cfg.amd.nid = nid;
 }
 
-struct protection_domain *protection_domain_alloc(int nid)
+struct protection_domain *protection_domain_alloc(void)
 {
 	struct protection_domain *domain;
 	int domid;
@@ -2471,12 +2465,13 @@ struct protection_domain *protection_domain_alloc(int nid)
 	}
 	domain->id = domid;
 
-	protection_domain_init(domain, nid);
+	protection_domain_init(domain);
 
 	return domain;
 }
 
-static int pdom_setup_pgtable(struct protection_domain *domain)
+static int pdom_setup_pgtable(struct protection_domain *domain,
+			      struct device *dev)
 {
 	struct io_pgtable_ops *pgtbl_ops;
 	enum io_pgtable_fmt fmt;
@@ -2490,6 +2485,7 @@ static int pdom_setup_pgtable(struct protection_domain *domain)
 		break;
 	}
 
+	domain->iop.pgtbl.cfg.amd.nid = dev_to_node(dev);
 	pgtbl_ops = alloc_io_pgtable_ops(fmt, &domain->iop.pgtbl.cfg, domain);
 	if (!pgtbl_ops)
 		return -ENOMEM;
@@ -2520,12 +2516,12 @@ do_iommu_domain_alloc(struct device *dev, u32 flags,
 	struct protection_domain *domain;
 	int ret;
 
-	domain = protection_domain_alloc(dev_to_node(dev));
+	domain = protection_domain_alloc();
 	if (!domain)
 		return ERR_PTR(-ENOMEM);
 
 	domain->pd_mode = pgtable;
-	ret = pdom_setup_pgtable(domain);
+	ret = pdom_setup_pgtable(domain, dev);
 	if (ret) {
 		pdom_id_free(domain->id);
 		kfree(domain);
@@ -2633,7 +2629,7 @@ void amd_iommu_init_identity_domain(void)
 
 	identity_domain.id = pdom_id_alloc();
 
-	protection_domain_init(&identity_domain, NUMA_NO_NODE);
+	protection_domain_init(&identity_domain);
 }
 
 /* Same as blocked domain except it supports only ops->attach_dev() */
diff --git a/drivers/iommu/amd/pasid.c b/drivers/iommu/amd/pasid.c
index 9101d07b11d3f7..11150cfd67182d 100644
--- a/drivers/iommu/amd/pasid.c
+++ b/drivers/iommu/amd/pasid.c
@@ -185,7 +185,7 @@ struct iommu_domain *amd_iommu_domain_alloc_sva(struct device *dev,
 	struct protection_domain *pdom;
 	int ret;
 
-	pdom = protection_domain_alloc(dev_to_node(dev));
+	pdom = protection_domain_alloc();
 	if (!pdom)
 		return ERR_PTR(-ENOMEM);
 
-- 
2.43.0

