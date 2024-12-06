Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2048.outbound.protection.outlook.com [40.107.243.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08F3B1C27;
	Fri,  6 Dec 2024 00:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733444631; cv=fail; b=PQemBMzzQNmimc0rE9UvBRXIvl+u+2fcPI5+WLEuOBUp1cJFksTKZ/oVAWM/e9s5vHi2WteNiA9OjrY2KJZIkc0cp6i80783v6tW7Tqt33MhWityYqZxNsY0NhEh6OWxM4nrS5yQpS5yKGwCcLKltOLueYvSiVEfp0VMQ3dWRfk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733444631; c=relaxed/simple;
	bh=xzkYIfjRTz5ctLGoxY2ZVifEhh6R2ZQ6SP45uOz/QUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qisTxr72dfcdhPzENk1d9RuT1rBVkACDADsyJfT0+ecZO4iLb6dPdWOv5BZKFCkxJq5iJSeR4CQ/zFHCPN2geuqjlgQTqQBmhnBX4cmCWz0Ll2yAQixto5xZyl2qfJ82MuaWFH5OIWppNFJLooyvJCPy81hQhAd+eEuH/12TbEI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=M81AtBUI; arc=fail smtp.client-ip=40.107.243.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="M81AtBUI"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dVEcQOxBRn4cugFQXn5UN9DGg5yM2PZoY+GFCb2KQwFAOGO/GHBbPln/s7uYvtgwCAZF8wj/0uYtfdohWIyPBB6T8HazoOYAh0jXxCdZIT2Dq/CVNz6w9YHaE8P2Vw4Bv+3LjFyQlSMZJiw4B1PTq97iVVML106x8ugE0b5Ja4jX+4JY89ZbZ19YM+3a7So01ulVrUCgpKnG7Uf32Z8U+S6dfmYLw70DUZpBpjr3I4AIu4T/glm2Hpyfne6Wb3rfTE6t5StYbz8pKrZ7t9YVnhmjO0pmR88LdIZNbCVRk2/Ufrwsc+K5OYQWvNrIoqJAKyDALzQCrbcpzHUhvzVcQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZAFJ5vdl/45NT+WWl4qFaKzp+zOMtEhfi66fVd/j4G8=;
 b=og4aV7eRnPiUaLufB3g/H7Z1eS7f/InPK2MGhdmqxAiVQKjnU17WbtkXWdngqupONW5QKONVf5Y22BS15fSwT/1WqdzyhvYMhPpIPcI6AnZp/jG2bjWFLf+cuHC8SnOP5eh32/v7QggtKpOXJ4Ef00doQvtnVbgRpAlywrq9O+2TLbSSUT1mEifgd0mCOJ7Rgs8v1z5DFyqTibvocHwY1FSbClG47YvHpGurWLDjEoD1H9h5SSv7W+8eewOFb2862pi5cfLY6sfiQJgc+wrk7hTKCsYD7n0mpFxjKnKrnMnjlaXrINIQhZJwhS9ZX5KOTi9ZM30Ao9m9p4NhaI9slw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZAFJ5vdl/45NT+WWl4qFaKzp+zOMtEhfi66fVd/j4G8=;
 b=M81AtBUIGmdXvgdxZDgDvKXNyV4jnVW1ReXtVlDsGgJJt8sKIOyc0WTHcPe17PsgK3Iw1eQFuIX9Up56MRPCrAXFpA1fUbcJGVIxDppdRn3grDDLMpT3ON0d8aRzF54O5JZ0mlHahVr7WbQgkJE7w6v0nAOFv/KFN8iqEM6PsuNSNOsM74d1zLcc45QnhIow+yWJ68l4myun0TNpGWzGCEc2gvfY/SDZ3cqYH+WEo/98QWZqintofUZn10j9R2MpaBK+3gP4xlEa1y7gZthA3MoHyARMi8LltXHGaefMZdVCKJrtJIgc6Wq1ZiNBRSU2qtZWj4UL68CITEgKnggmow==
Received: from BL4PR12MB9480.namprd12.prod.outlook.com (2603:10b6:208:58d::7)
 by CY5PR12MB6084.namprd12.prod.outlook.com (2603:10b6:930:28::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.17; Fri, 6 Dec
 2024 00:23:46 +0000
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by BL4PR12MB9480.namprd12.prod.outlook.com (2603:10b6:208:58d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.10; Fri, 6 Dec
 2024 00:23:45 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%5]) with mapi id 15.20.8230.010; Fri, 6 Dec 2024
 00:23:44 +0000
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
Subject: [PATCH 3/7] iommu/amd: Remove dev == NULL checks
Date: Thu,  5 Dec 2024 20:23:38 -0400
Message-ID: <3-v1-cf88773f22d1+39bd-amd_paging_flags_jgg@nvidia.com>
In-Reply-To: <0-v1-cf88773f22d1+39bd-amd_paging_flags_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0931.namprd03.prod.outlook.com
 (2603:10b6:408:108::6) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic:
	CH3PR12MB8659:EE_|BL4PR12MB9480:EE_|CY5PR12MB6084:EE_
X-MS-Office365-Filtering-Correlation-Id: b190905d-d672-4a1c-a0c1-08dd158c3e02
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BgMeXKEVcwmcgSpZrI+Ff+K0FV6uQGJhiubcgURGyMbx7fD5H3Vo4AtgbhCv?=
 =?us-ascii?Q?K2cadpKVQwG5H6ay8X6cFBX/IubeEQCoNhv1tXhUjE4IQSCZI00an64eRbLx?=
 =?us-ascii?Q?oiusqH+XWekb2yVFOpRx5aVEj8IAVquwOMd1X+Xyss9BEcmJx8Raz51USfDI?=
 =?us-ascii?Q?z4zB7gE8NvWnVO63l2a/9MW0zHpSL7gXeePULLk/UxE0/clNiBQale4hDbrL?=
 =?us-ascii?Q?/q2Rt0BzLgaml/ij9mzwlQVDcQsWEHmjtDtOPS/fQrNv8YnWC3h5lLYK4cPO?=
 =?us-ascii?Q?z36nyUbXXylkpDJhPlDiR2zOOPnR3TXUkSYf3CgQbwOu+5EuhDwMFM0klcyC?=
 =?us-ascii?Q?3fXDuXyynFWfaho1+dn3ir3+mkThj4+T+Rr/BoWKQ8Ddt3itlro1YbdBQ40f?=
 =?us-ascii?Q?WG0sjs0a4Il1ZAh5KGA7Iz8MlNYAUVG3pZVTzYVgCjp3LMqve2LrowufRbQw?=
 =?us-ascii?Q?rvTIAECA8uFoU2jmAQRiHxye7BJu84KEBSQVxWxwy47fVycUzJXmRthzObOV?=
 =?us-ascii?Q?7bJKNVyy4Fbm/5QPJXpwk5tWOAoaPpSybgWEBKHy3OxUQ8KTMovsRMNiDv33?=
 =?us-ascii?Q?A/HAqI6vHDMfJwmaWBr4yx042FNs4+sFmm6kmmUR5rWYhD93LQvjyf4F0M4F?=
 =?us-ascii?Q?CiYoaBSmC7AC2ABEro8QbTjaewLos3LC5eUsXzenJ8Imv5XZo3MlUW6EIWVu?=
 =?us-ascii?Q?3O7mcGaOAC7ci8+QfD6wh0v32kFELu/tJ4lsVHfg4fme1s/uUrfsQsomjl1D?=
 =?us-ascii?Q?jgvRNageRqqFFW+MrknVELnC8QY++BQ0l5YAAFHpSJ95EXJhlpSBzpnaSCFG?=
 =?us-ascii?Q?jDLlxIOoSJGAVXZQf4byFkpw1h9Pmpl8xXIPtal6VIVasrg0iPhOfuMPCo0N?=
 =?us-ascii?Q?CwnDjl+KW102dOK8rAaLm1N0T73ctL+iH26JnSwOQx4KEWNgJGbUJ64PTbVg?=
 =?us-ascii?Q?HgHh+gz/F+WTCJ7OBu0ornsIOuseN6j3Hi2vSLpzh907fM7yV7SnXn6NkZNR?=
 =?us-ascii?Q?a0FkU9Rs1A+pyW7vBChlox+T3r7wcJhuY5Te3G56uS5k19HPbVh+ssFKzP5I?=
 =?us-ascii?Q?0NUbKNN4+eAa/oOw8oJZYGq/KGJZ7CHZbI4otvnSUk2xFpEgMvNFslmtwujv?=
 =?us-ascii?Q?67CIZb1PyKvhpNc2UFQjvtLdUsOVGkFFcsb3ZUNOX6N7AZ++8RdGno3AEmjE?=
 =?us-ascii?Q?3sK3RWBGbdbIYCgef81rMolozXIZ0q1Ub+C5Ism+Sop672Ak797VWOw5PVGq?=
 =?us-ascii?Q?hoR8qYkX4EPja5XX/0YfojwDVzJv7igIYlPQu+njs4xq6fNd4x0MivIBB8w0?=
 =?us-ascii?Q?Sf4U7gtXKC095sry7SPeUK71ybxsqvuN/HXNAxnxcDkPFA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR12MB9480.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jwCubuy3i+vzBz2UT141SKM42LVGV8OQ+AYftEGFEPXjU7l+C7t6THcS7SnL?=
 =?us-ascii?Q?JPgpClEMfEnoJ/7i3ENcD1Nm3TOjCMy8dl8x18V9DAPoNyxFmGw7qWORzQFh?=
 =?us-ascii?Q?9Fki2KkyrH+tIZjJdafbVRtCWc1uSERjpOS48kFHRGR2diDD9v824DOEld8x?=
 =?us-ascii?Q?5hGTNueG6HVJ9gIIGaBy99eJJVZfRsR5i3Xp9bkpz5br7yXQ7NKzM4/c+7Ys?=
 =?us-ascii?Q?khezyPQ1kztABFKWWp+GCvTXw1xik+lUij6ark1y7b1sKWNHEs41LUUdnUBh?=
 =?us-ascii?Q?dkdAYD2MeKU6y4oGyKDqWjXFt2UIaRRDEf6pm6m2i00IBsPPi28HGdk7rPga?=
 =?us-ascii?Q?RQu0FVj8rcRtxNcr1Jg26Bzfz8gybx+k/Wx/m7JzUU0j8hPkNKKF1F1mMo6h?=
 =?us-ascii?Q?29fo7woS5wtdV4AZ9SfD70P+trHLYj33/v43i+2hD5HkE53mlBmteyqwVZ3w?=
 =?us-ascii?Q?N+9BOGJJeqeylx1Jg6SUaynE5RPNM1XntwUf2ur2OsLCANvoC4zgXFFPh0x3?=
 =?us-ascii?Q?TYtqIwmecbAAeSp45aDHUWkluuAL8cQw8SM+8CCpsHIPquf50epBJmEjIgIJ?=
 =?us-ascii?Q?xvBCAuq/FFpsomgVBkwtpEkPFhd3ZZ0xrc8FY1kxA/oBvPlDdhAAqOyPYkV1?=
 =?us-ascii?Q?QPfI0oJnELjYUA4k3asUwbmhRInvUeaRHb9n+4xZLqxZgg52HeGP5iraJITU?=
 =?us-ascii?Q?2bS8kY9kXjoIp2cv6U7OasTcp49zP6K+Bgzn+SJ04b5RSHxyF59pvROJGhby?=
 =?us-ascii?Q?QKYat8ULvhwhwF8fu0PIF/CKhiAXmMTObFI/g9ILQn0jUTLKwRV7KOQcK/TY?=
 =?us-ascii?Q?sUjC4+azHMNOYT45CRBwDdkfTD1Pv+POSn89KiFjtD+JgqRgDZlvZ/GfjY2O?=
 =?us-ascii?Q?Psdn24tFX7XJEJdqxS+ExgJHQ8GLytiHqgGLOlfNu1chuBLyuzO1GGPZgmTa?=
 =?us-ascii?Q?O2GjNVAgKYLPspBnkaelpN/E8IHdGpzHj7tdq65KfDXbs2g+l1rZrt79hb3o?=
 =?us-ascii?Q?wVC1a6GnP5lvxQ++Hfc0ZAUNCayJdrKYRatX24IRvfRBtbAZtU8/KL4pRc1k?=
 =?us-ascii?Q?4bbDC4ktLfJ5WH6eT4tDINLEFHkQ2tSmLYLyVfpSuCvGR5UFFDorPZmsVzkx?=
 =?us-ascii?Q?dWR9LGgEIDfKlbyZyDm+QbTYRbOJuWptSqbQqx9hJvuTJocUnHHPEWcZXR2e?=
 =?us-ascii?Q?JgvQsKBKiZx38vo9S81dj8q3yq8Yxp9XKHXteyzmBORyqd1gVxQ8XtybmfWf?=
 =?us-ascii?Q?SglChc78JmnpEuoVLYz0umIw0WPHlc8pgYLEWbPHyWO3gp9eSyJDVs0GmBL5?=
 =?us-ascii?Q?h0HrQeLOfRTVCn4lqoEtJ9QjL/XTZDELg6mblIwRDKh7ETSDf0mGJ1DYlbc8?=
 =?us-ascii?Q?OMxO/LqWYka7XJpBsSEyJZkAJH4Q9qvl7vQY+6rCAnC8YltVmqrDuHtgF8rI?=
 =?us-ascii?Q?/ebXMBS94g+a8Wk4TnBEwQb/Xt0ehbzOOGTOnDTZVqQ/+1qIatJ8Z3QMqoJW?=
 =?us-ascii?Q?rVLWWlkFaD3a1elyO82MaJt3SnaXcIBypFQCNEhMMt5QsIfxEGSlkT9qHaDA?=
 =?us-ascii?Q?LDcQw+Qex8U7GzcEkHSnc/QgCuLOpZx2hKv9YwmG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b190905d-d672-4a1c-a0c1-08dd158c3e02
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2024 00:23:43.8025
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QygFfzBbtmWzAdqsBThlbnrnq4sO7yj6u4KUVWUItz4nzU6XiOwUJ5SffsGLvjS/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6084

This is no longer possible, amd_iommu_domain_alloc_paging_flags() is never
called with dev = NULL from the core code. Similarly
get_amd_iommu_from_dev() can never be NULL either.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/iommu.c | 30 ++++++++++--------------------
 1 file changed, 10 insertions(+), 20 deletions(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 96d87406f89467..12c416abdce7dc 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2344,13 +2344,10 @@ static struct iommu_domain *do_iommu_domain_alloc(unsigned int type,
 						  u32 flags, int pgtable)
 {
 	bool dirty_tracking = flags & IOMMU_HWPT_ALLOC_DIRTY_TRACKING;
+	struct amd_iommu *iommu = get_amd_iommu_from_dev(dev);
 	struct protection_domain *domain;
-	struct amd_iommu *iommu = NULL;
 	int ret;
 
-	if (dev)
-		iommu = get_amd_iommu_from_dev(dev);
-
 	/*
 	 * Since DTE[Mode]=0 is prohibited on SNP-enabled system,
 	 * default to use IOMMU_DOMAIN_DMA[_FQ].
@@ -2358,8 +2355,7 @@ static struct iommu_domain *do_iommu_domain_alloc(unsigned int type,
 	if (amd_iommu_snp_en && (type == IOMMU_DOMAIN_IDENTITY))
 		return ERR_PTR(-EINVAL);
 
-	domain = protection_domain_alloc(type,
-					 dev ? dev_to_node(dev) : NUMA_NO_NODE);
+	domain = protection_domain_alloc(type, dev_to_node(dev));
 	if (!domain)
 		return ERR_PTR(-ENOMEM);
 
@@ -2375,13 +2371,11 @@ static struct iommu_domain *do_iommu_domain_alloc(unsigned int type,
 	domain->domain.geometry.force_aperture = true;
 	domain->domain.pgsize_bitmap = domain->iop.pgtbl.cfg.pgsize_bitmap;
 
-	if (iommu) {
-		domain->domain.type = type;
-		domain->domain.ops = iommu->iommu.ops->default_domain_ops;
+	domain->domain.type = type;
+	domain->domain.ops = iommu->iommu.ops->default_domain_ops;
 
-		if (dirty_tracking)
-			domain->domain.dirty_ops = &amd_dirty_ops;
-	}
+	if (dirty_tracking)
+		domain->domain.dirty_ops = &amd_dirty_ops;
 
 	return &domain->domain;
 }
@@ -2392,13 +2386,10 @@ amd_iommu_domain_alloc_paging_flags(struct device *dev, u32 flags,
 
 {
 	unsigned int type = IOMMU_DOMAIN_UNMANAGED;
-	struct amd_iommu *iommu = NULL;
+	struct amd_iommu *iommu = get_amd_iommu_from_dev(dev);
 	const u32 supported_flags = IOMMU_HWPT_ALLOC_DIRTY_TRACKING |
 						IOMMU_HWPT_ALLOC_PASID;
 
-	if (dev)
-		iommu = get_amd_iommu_from_dev(dev);
-
 	if ((flags & ~supported_flags) || user_data)
 		return ERR_PTR(-EOPNOTSUPP);
 
@@ -2412,10 +2403,9 @@ amd_iommu_domain_alloc_paging_flags(struct device *dev, u32 flags,
 
 	/* Allocate domain with v1 page table for dirty tracking */
 	if (flags & IOMMU_HWPT_ALLOC_DIRTY_TRACKING) {
-		if (iommu && amd_iommu_hd_support(iommu)) {
-			return do_iommu_domain_alloc(type, dev,
-						     flags, AMD_IOMMU_V1);
-		}
+		if (amd_iommu_hd_support(iommu))
+			return do_iommu_domain_alloc(type, dev, flags,
+						     AMD_IOMMU_V1);
 
 		return ERR_PTR(-EOPNOTSUPP);
 	}
-- 
2.43.0

