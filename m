Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2069.outbound.protection.outlook.com [40.107.244.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 117521A8F6C;
	Wed,  4 Dec 2024 20:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733343225; cv=fail; b=eQ1jMLh+ejWtGAxN2TBrHhTCijlu4vZzVua45fePh3omzkMrYZDm81/gHkpImGW1Q2k7GGOGm1i7ylrmlD7+JhbIYSO0xffk8hRjNDGe/0DLq5X/l4pM0scWMt+eLKprY7Mq8f/ajjqE3Mf5+RU9deZf9H+ndV7KoFrymVmbfNY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733343225; c=relaxed/simple;
	bh=PesF1/O1Xx0X3c33P0R4/MGYhje2RSn/mvbFRGWafiU=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=QdAcenYVMlr2r6C14icQtL3L7xmZFuT3sFdHW+lmuGiGyZ0iBcJsutU/Lm3RwtwLIqtW8bjlQBQ+ASAmJyo7wqKlrBrfYTKSARnoUaBsbGhEJfEF2Mp0t2HPFaCycIg2zL+Ydbi29hGGJZOdnWQqCNKLDUJEsnJlIPZor4Rtkf4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=sWD2MpaU; arc=fail smtp.client-ip=40.107.244.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="sWD2MpaU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wwGYQgzfzoQrMLHcfJcq73Sow8ySWEkFQN+hTJ4LDdE4q4gUZUksdhA+wIzfbEtATyBJ4Qn8AFTTy59M10BHtm5VaLAYgMdQbgw0icVHIrwdQAa5P0ywb5245vX2o8hUmpPQmkQT/ALychbvFggPa5MlKC1A5JBq7zMaBHz4p2p9ckJwq9d98IpaP0Ff42k5qVn9YEZzYMiNYmb8oWG1IKZgtKj6K1i+K7v6l+AIb46pyb9wbwzuQLVNd/SWMIUJfZzllc79DDLRU3ijTPwhYaM4IVdO6kVSqhYMQqJ5oASwjx/2jkupABTO2JUtQWYjLZ7zWloZWufRruR72HJrqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2L/lET5BryDBLrkpIrNoKnQ23TVrQxyQVAgQZjnkLB8=;
 b=JAClHxL5/uGnzy1LDToeGxFkb8UNbW8/oR923IT47aacFY6wpNf610yE8HpzF7OiDCNvbHfOWAz/8SRijK3Tspar9uIKAW8kDyVjK0yzytUO28AstUKi70ll03YQiiK+HbplF46JZP+o+qlyZ7KbLccIl25P2g0ZRa7yJB0006t0tz6Rdzt4vryhZnsd7AoPE3BbrvyGqyv8Mjk5C25Gy8RmEtFEf4BY1soaL4ZD6yCiaJABCZMSk1mw0F3ni3lon6AoOwYvdglp6Zpf5gEjK3X5MpCCe0r4+YyfTeB1UN1d+WqyYcwd5oWQhPAJHOK3lj6Xa5ydBq60H6YIrwUGDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2L/lET5BryDBLrkpIrNoKnQ23TVrQxyQVAgQZjnkLB8=;
 b=sWD2MpaUDRQedxCBXZBSWzRWXwpTWf0Loks67ofGcz6+zWr7gIQUcQpV1yCgKHAXKCpOo93PmhPDCUyj+cT2qON4HU8ZaDLX8Zj+WB1KMAAqUdHNL39wWIQXymJA3XPQDX4OmHj+VIWDrVxZwIQY6mkRBoa29MuTnqHhkVIk5NlzVtGFnVzGquFtRltgn9EETnTQQVGUlZJkt6JuMS6Uqsiw8svXY8v1u+DYiVnHCwHuIxDWKpd0rJGdWQNLHOXAFWLBZDzjoDtXcN3odzZ+6dMFSExLIPeKjbGKslGOZk7PO9ACg/LHTH0zeKqRoodd8Y1w8rCzMaiCmRsssfvk4g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by MW4PR12MB7430.namprd12.prod.outlook.com (2603:10b6:303:224::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.19; Wed, 4 Dec
 2024 20:13:40 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%5]) with mapi id 15.20.8230.010; Wed, 4 Dec 2024
 20:13:40 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Kevin Tian <kevin.tian@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: patches@lists.linux.dev
Subject: [PATCH] iommufd/selftest: Remove domain_alloc_paging()
Date: Wed,  4 Dec 2024 16:13:39 -0400
Message-ID: <0-v1-8a3e7e21ff6a+1745d-iommufd_paging_flags_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0122.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::7) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|MW4PR12MB7430:EE_
X-MS-Office365-Filtering-Correlation-Id: 40da0b5e-b02d-40ed-2896-08dd14a024bb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?62nsOyt90a8frGUttebXaxrnp/vEiwhAB/sQgqcwDLoxShcEu3AO2QL1xHhU?=
 =?us-ascii?Q?Xygpw3QNrHS4FelUK+MgQ5lXJZHy5ByLsg9LsmrewGNNhJevdpns+RSnuJ4A?=
 =?us-ascii?Q?TWcmOr8k6PzEy0XuaIlLjPXHlynB2QunwuorFJNzEqTmuj7S3Je/2H4c9cHI?=
 =?us-ascii?Q?qFFZNhf3WUSkgSi0eE4u9RuyEcGqA+gaVv8aV+o67h3aMhZSBvcx/wjBXQUk?=
 =?us-ascii?Q?3vTPE7QwGvUShadOuzWMMaoMizhwupxfOYSs9RLk/ZiD03C+TsZ+sIqD6Eet?=
 =?us-ascii?Q?80y++0zBYMNByfzUtFPtzUhOj/hBXCkSQmatjWo6CzJ4PXaBGnHHYgkUvaXy?=
 =?us-ascii?Q?u66R1wCIDqqUbDYhcYMxOG3MFrDJ/KUgZieGSHXzC1OLSyNqpOE4GYOq/uEV?=
 =?us-ascii?Q?k7txUgORoVL4Xnc/kamvdKyngxtrKpJxyyaepBCZQ35FSWHZRakMqCZfJlR4?=
 =?us-ascii?Q?XWBJzF2zly8JoMnpBwoQ1S/RD5FKWwyzmW9CaNDFl3MyX8QLh7LvdFMjhLIh?=
 =?us-ascii?Q?YHmmNI7W4nsoiudkaoEmNo4y53ojny1QKSDimny1Vfa+JAzQhwKh9ZrD1JpR?=
 =?us-ascii?Q?N1g8giCL+mxsL46+l9QeHNWOjCK9TTGj8XLGlkpf2EreBsQutOu6bqPGN1h6?=
 =?us-ascii?Q?Tjm9GgMIzwUv0riKDHEPxCcUQnoVSPEx5Ma596605BhyKhm4sz7lG5D463/I?=
 =?us-ascii?Q?Og654La5hEtE0qnxOa1ch8t9vlnBfHJkZucNSYb1Kpj7YUAq2rukNXz+fhwO?=
 =?us-ascii?Q?Jz4gLPpXObU+i2ClAivfK5C3cdVmSom/5DzmxCssn8Rb09j5MnDVOSaCyL6Y?=
 =?us-ascii?Q?Oro5W7UxGvjA31fsvZ0ZzaEN9QGwDZDpJOPS1ouZIACa+xx1A5rjK+KHY78L?=
 =?us-ascii?Q?pxgCOYFnuxSyFrswMZK519fXPhjnTb4bGGva3AzjRkQ6e//FuPvJr3P4LhBW?=
 =?us-ascii?Q?04yFdoKXqcsqqdCjt4dqWPjDvC0sdqBBtQpSpZ7Vsb8CNa8O0gx7J5yKUoYC?=
 =?us-ascii?Q?nz3l+vv648qoOV7lYI/cP86J0aDQcJ5UdvubZS4Y8HCPVgmhWAKaD6KDkrqb?=
 =?us-ascii?Q?UITFL3CGJw+8694/VqVzlaR2FkXWACFnNhb9zjzpT6Fm0dp4nWce2hrmG1Nt?=
 =?us-ascii?Q?osqS7INqC02q6sbl0jxoo4m/3SukP7Vv5dgCQO4VFq4nGvqc+IffHvP844HP?=
 =?us-ascii?Q?BTTpjzTxoozk44OjExBgmIHm0uY5o+pnlB79rU82cpb2y6eGLK91o86KNf/a?=
 =?us-ascii?Q?SscMtXcYC5+ml5fvaYS9vJXbF2UoOYOYXETlNS2EBZNoZsPNlm8K9Ngf3VcB?=
 =?us-ascii?Q?dzaeucP9ZIspaWR3pysHc65jsojPaY9hBkhOIpEcHykXTQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VJLYOgGTVTw215GMcyUTlHZxz9eyXioFR+5JBpwnMnB2PQDv3zevdTPs0N3H?=
 =?us-ascii?Q?aT3vv9pC7+eXNZO3oRwxhGl7bJJnZy9CtZ0tHS/BeUItMEH5TQ7yJe4cR2Y2?=
 =?us-ascii?Q?lJMQKNTL1M6c/etThi2LXrkbRadxtUYPFFcrzvvxSVUkSzIa4wQS5q9Tic6v?=
 =?us-ascii?Q?WTP5g+khqHnBdUho4tdJ2MK9gQPxZvPnrS/oWdvPKbG3hiagLruIUxep10xA?=
 =?us-ascii?Q?HW1Ora1Mv1PhoOS9g8HT8BFHCn7EEgXhj1GXEYXZKakQ7hAqAKpbRvW32ut7?=
 =?us-ascii?Q?xRr16p1LJ11ed4BSTHysyv6yyLJiFBqFisv6J6dbYG7nt3OKkmqW2oexJJW5?=
 =?us-ascii?Q?wCNwMxa8TL5d+qTdtdPHItOvrlyqG1tULClB32GpS/kRv4tJ9UPghrNs+19W?=
 =?us-ascii?Q?AboeKpHzaPVc3tc3ImIp8B8vp7qF7wQKlpdLLIwKHz9kCa/BFpo3LG3cP+yo?=
 =?us-ascii?Q?2hCYNOQhhnkV+SiDdOE5bNZYU6vrABLF6/hDO5pDE4U1/xP7z8ihwouveEwb?=
 =?us-ascii?Q?Um1rzzQEC0yPd42KaqSDLXO1V898k4OCVipBa9gwH9iBNThNwYDw6hjuelBY?=
 =?us-ascii?Q?s2M2XokQ6DZLtgZfLCo5oPqFQGZ4qhBAGLgsKTJjudX0Q/kay27NN/8GZ1Qi?=
 =?us-ascii?Q?ljZjsaZ0xITgIN9MZKcTjSonAJXaT1gYuo01zEa+eWaZPkStRP8ST0TWciP/?=
 =?us-ascii?Q?aq8BoPT4Yx4+nNtBLcdHoQXVEPkM0Jn9N9AFr6K4wIssDfzTxjnmD5W4E0yt?=
 =?us-ascii?Q?NzzR2TnNXEqxdiVzM0offE1Y19hT5eC3gWm4qxIi5hYUGk8UiGyGHyIU+w3Q?=
 =?us-ascii?Q?1CGtYj+50nQTrZXeZ1dRj96cnWtaY7yXU82gDGlQKYKc1GRSkwk2TgaUqYa3?=
 =?us-ascii?Q?QzPHRaCh50vrj3XKydDB9h+3Y523ATw0fJohZOPq64iDdxDzu4b+oSFH8gSX?=
 =?us-ascii?Q?lTJMXKBGMaGtOzpbwuLkJ70wFisNse+TgRhLRogDM9JPbeewn0Dhem9n6ade?=
 =?us-ascii?Q?h3wBfisMeBpFGp/kXd6057SsK2W5TEA12S2rED6KFBYAk2lnQdfv8oQ1y0f7?=
 =?us-ascii?Q?l543Uy/MMZXssH7iUhc2k1VUaNXE/aYJBWBM3yLtaEwqYHnYZ+SxJjjPPDPN?=
 =?us-ascii?Q?OLYbVjRvPPEDNv27M5PCfqEkFQZxKVshxCFS/+XXms/E1cYmGK+AQLOhU2Wj?=
 =?us-ascii?Q?AL4Xi6X/ylZwSYUI5oUUU4GuK81nznpW4GMGd28ggVWnhnKSIUEauYmTdSTa?=
 =?us-ascii?Q?JDqMdnv/waO56EFGe6KflU2Nbgp0eOUBr0gG8VprGvM/3G9ncNbxB0vte8gD?=
 =?us-ascii?Q?z1B9bQZkuALe6U9pEO1FWIQSMJeDayMoVb+yiDZDBKPNIQwK+IAcB671vfwP?=
 =?us-ascii?Q?TDvxovLVYNMVS2nq4AszxnCfO9fNToGu1y0QNDnroTMZOeUShgVSNoRBwDjO?=
 =?us-ascii?Q?hgAJu42yKUIlx3v91SimJqVpoYWrHsdjkg1MMjNVLFuktoK1XBW/y3eVTmtr?=
 =?us-ascii?Q?8U2vArBlDF5FFFXRaJbkAcAfHSSRHZIIaYxD/suzMv2WfTcL4QIS15tI6BxL?=
 =?us-ascii?Q?rLJCB32jwMd6499e+MbcOf4Ik81ExELoA1fa6Kjd?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40da0b5e-b02d-40ed-2896-08dd14a024bb
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2024 20:13:40.1889
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A5a9H6qDPMOaXJqLUz4nRhMhOk6T4tMG1O98hmkTn+rM7iSfvP/mKVAOlm6DE9ME
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7430

Since this implements domain_alloc_paging_flags() it only needs one
op. Fold mock_domain_alloc_paging() into mock_domain_alloc_paging_flags().

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommufd/selftest.c | 43 ++++++++++++--------------------
 1 file changed, 16 insertions(+), 27 deletions(-)

diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/selftest.c
index a0de6d6d4e689c..6512c1d163481f 100644
--- a/drivers/iommu/iommufd/selftest.c
+++ b/drivers/iommu/iommufd/selftest.c
@@ -311,25 +311,6 @@ static const struct iommu_dirty_ops dirty_ops = {
 	.read_and_clear_dirty = mock_domain_read_and_clear_dirty,
 };
 
-static struct iommu_domain *mock_domain_alloc_paging(struct device *dev)
-{
-	struct mock_dev *mdev = to_mock_dev(dev);
-	struct mock_iommu_domain *mock;
-
-	mock = kzalloc(sizeof(*mock), GFP_KERNEL);
-	if (!mock)
-		return NULL;
-	mock->domain.geometry.aperture_start = MOCK_APERTURE_START;
-	mock->domain.geometry.aperture_end = MOCK_APERTURE_LAST;
-	mock->domain.pgsize_bitmap = MOCK_IO_PAGE_SIZE;
-	if (dev && mdev->flags & MOCK_FLAGS_DEVICE_HUGE_IOVA)
-		mock->domain.pgsize_bitmap |= MOCK_HUGE_PAGE_SIZE;
-	mock->domain.ops = mock_ops.default_domain_ops;
-	mock->domain.type = IOMMU_DOMAIN_UNMANAGED;
-	xa_init(&mock->pfns);
-	return &mock->domain;
-}
-
 static struct mock_iommu_domain_nested *
 __mock_domain_alloc_nested(const struct iommu_user_data *user_data)
 {
@@ -385,21 +366,30 @@ mock_domain_alloc_paging_flags(struct device *dev, u32 flags,
 	bool has_dirty_flag = flags & IOMMU_HWPT_ALLOC_DIRTY_TRACKING;
 	const u32 PAGING_FLAGS = IOMMU_HWPT_ALLOC_DIRTY_TRACKING |
 				 IOMMU_HWPT_ALLOC_NEST_PARENT;
-	bool no_dirty_ops = to_mock_dev(dev)->flags &
-			    MOCK_FLAGS_DEVICE_NO_DIRTY;
-	struct iommu_domain *domain;
+	struct mock_dev *mdev = to_mock_dev(dev);
+	bool no_dirty_ops = mdev->flags & MOCK_FLAGS_DEVICE_NO_DIRTY;
+	struct mock_iommu_domain *mock;
 
 	if (user_data)
 		return ERR_PTR(-EOPNOTSUPP);
 	if ((flags & ~PAGING_FLAGS) || (has_dirty_flag && no_dirty_ops))
 		return ERR_PTR(-EOPNOTSUPP);
 
-	domain = mock_domain_alloc_paging(dev);
-	if (!domain)
+	mock = kzalloc(sizeof(*mock), GFP_KERNEL);
+	if (!mock)
 		return ERR_PTR(-ENOMEM);
+	mock->domain.geometry.aperture_start = MOCK_APERTURE_START;
+	mock->domain.geometry.aperture_end = MOCK_APERTURE_LAST;
+	mock->domain.pgsize_bitmap = MOCK_IO_PAGE_SIZE;
+	if (dev && mdev->flags & MOCK_FLAGS_DEVICE_HUGE_IOVA)
+		mock->domain.pgsize_bitmap |= MOCK_HUGE_PAGE_SIZE;
+	mock->domain.ops = mock_ops.default_domain_ops;
+	mock->domain.type = IOMMU_DOMAIN_UNMANAGED;
+	xa_init(&mock->pfns);
+
 	if (has_dirty_flag)
-		domain->dirty_ops = &dirty_ops;
-	return domain;
+		mock->domain.dirty_ops = &dirty_ops;
+	return &mock->domain;
 }
 
 static void mock_domain_free(struct iommu_domain *domain)
@@ -713,7 +703,6 @@ static const struct iommu_ops mock_ops = {
 	.owner = THIS_MODULE,
 	.pgsize_bitmap = MOCK_IO_PAGE_SIZE,
 	.hw_info = mock_domain_hw_info,
-	.domain_alloc_paging = mock_domain_alloc_paging,
 	.domain_alloc_paging_flags = mock_domain_alloc_paging_flags,
 	.domain_alloc_nested = mock_domain_alloc_nested,
 	.capable = mock_domain_capable,

base-commit: 40384c840ea1944d7c5a392e8975ed088ecf0b37
-- 
2.43.0

