Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2049.outbound.protection.outlook.com [40.107.237.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A8DE1AA1DF;
	Thu, 14 Nov 2024 19:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731614142; cv=fail; b=V7sxEvdQ0HETITB05FqaBkAfmeQF97P3Nmp2gm/NtyTip2BUs/3kiq7L5eG+kRZsWY5p67eTzBmYqw1bsTFCAlAcF3J0+FdLbTVVNw0tgVQnE/Qi9JqgNkPZX3rChpgkhu+8tFo/Rz7uh74aRnBoa4QyAheYRgWA8iLBkgNGmcE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731614142; c=relaxed/simple;
	bh=WWACZIFS7CeoNHcdgNlqQg1IstE7N5NjB0Pmzap1hKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hFOo2vBVrcMWdnjOu+HfIxjPTm4eV79NDb5rC5TC7RkX4ly85lMSklAcHMovjOguUANGrt06/AXPOox7Rv4NtJgkDGJUjPOQbSltU3G+FNHl7kP0niu3FsVaYdvNo6j74CI6ucCp7k8w1MtV25chulESCVnQY/A32qm6QX7yL44=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=MkqMn9vO; arc=fail smtp.client-ip=40.107.237.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="MkqMn9vO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y/xYYOIo5m6f1tTq/eWASOBxbI0ZiDLh8rhKYIUAfN6MKDG026qrT2EwRr39WF5LBrb8La4D5f7/2V0sUq4Wud0Dg+dffgNmbDL+xUqcNxs9b0PQolLI4hjfEmoYj59G83DIozaS4RMu1duh57du4PDLTnlUJMJ0SS29qh7mxg3YGFaH1tbHsG1QNgbj59VVMSyTtHgiMtCw1VYUuVn6fKvl/lCa/v6jwCdm1zOejJ2tqsFhWYpXsX3mPsqJ/KgklDETePjuG9CEbPDIH8eNbj/LTTDsDDY5xUOoid+tmlnVTwIMJPUx6Vvbn2FYnznFY0XmQZPQorhYQgEF3gYBDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QQ6dLZTM2tm9BhyH0kaEKG/QfWSqlO/dOMydDacaC2g=;
 b=gRGW/meF96qKMo3TWXzieQtPnrOiyfmpGxXXg9iUpgobsJtGUBGF2pJBSsdxeyAav77O/PPw+Z4XF4yvOQ8kxsS5IqONrp00SXJbJ9HTzB4OgyvrwI3FPau+7UcX1cgw7533R51YAa0tOXb85HYA7Lof+QwxXUU86opZjEOnMp+/EeGID0aIs5d/+3kbpd1Mu4fosho/7+VIzM7oXqpWVzW+yfHcFckc7Ls5DZ0AlFp4NHieq6XLcSk1r9+d1kzyqf0HWNOVqoLNGJnbsYcNIR4/KQ2LkYjcSKXDKQ8NA7yojg73TxABIZqTUwOeBArU3NxVayl10P8dxM8F//bsvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QQ6dLZTM2tm9BhyH0kaEKG/QfWSqlO/dOMydDacaC2g=;
 b=MkqMn9vO9r7jfIGK7Ms2LSuj5kCmASV+UF98UQi7QmVfK2Rh0xRkxxCfksjkvKVl4fZDSZpLbvvo91eiW1tVAIYB39YK80wHTfCMHYGO7QSWILm6MbSD0Wwv5KJjlEOVSqLio+o4pg2Oi/B9TRobSqPPPYxpU+czEXWnJXBLBLJcgF4WjCRap9Zz2+OBuCCodxtn9pxmh6YbnXlWYYk4N8H6KPzvrYF5KVYops7JGQ3qQXBGX90vzWCTOC6p/tJtRz1UcSCT8dGyf5Kx0Bvm1K/7qK7MYhK4hIgLd3lYs/ikr5k3QZPH6d982YANh0Ciw5xwrj4J4+4LVM272h7s1A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by PH7PR12MB6563.namprd12.prod.outlook.com (2603:10b6:510:211::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.28; Thu, 14 Nov
 2024 19:55:33 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8137.027; Thu, 14 Nov 2024
 19:55:33 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Kevin Tian <kevin.tian@intel.com>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>
Cc: patches@lists.linux.dev
Subject: [PATCH 1/2] iommu: Add ops->domain_alloc_nested()
Date: Thu, 14 Nov 2024 15:55:30 -0400
Message-ID: <1-v1-c252ebdeb57b+329-iommu_paging_flags_jgg@nvidia.com>
In-Reply-To: <0-v1-c252ebdeb57b+329-iommu_paging_flags_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN0PR04CA0142.namprd04.prod.outlook.com
 (2603:10b6:408:ed::27) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|PH7PR12MB6563:EE_
X-MS-Office365-Filtering-Correlation-Id: f44f4ad3-ad18-4f50-9fa8-08dd04e64c3f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6Jx6WatVaiQzJtqosIG1M3wDRn29NOZIV7XQgTNZgJL1lmcxqUgiKPW0Xxp9?=
 =?us-ascii?Q?PnMrA6/H20OvJD8pRgwqs9+tE0DrhwIv/mElTrLALb5xlNAvmOwL7zPid+sU?=
 =?us-ascii?Q?ZQX0vmUErizQmvZu4knMiGLB8a1qxJfowXQ9qMF38dEob3kpm25Ultxecb+C?=
 =?us-ascii?Q?gvAQwIkuc3YhHjL8KSoMFvOXEYY549CFlVI5lIEw9oY+IduHnHRebnH9iCwE?=
 =?us-ascii?Q?7OpRw9bU2prBshrGK7neu0+/M68N5lRh1909ULplQnsaSPdsAVETlw6VuCjX?=
 =?us-ascii?Q?Lej92BuUGqJPkyh0M4NajpaopLg4U6SvX3u7tcoH6dtHY8Am8to/DhPnC3Zr?=
 =?us-ascii?Q?mTfPwcy6uu+9CIo1In8GHkalL6eelLUcOlpDsjVNRpf7NIxgatc9r7RqAZxi?=
 =?us-ascii?Q?BKPzpTb5xCziPMzfXd4gGDsiXOSJAKTEUvw1pTaopnBRXRwSWe+cGUMXX3oP?=
 =?us-ascii?Q?Uq5ZDLFWhMp+bk1FaO/VeGx5DT/XJNLAmS35pHogc6jFMKadZVIV0a5eJ56T?=
 =?us-ascii?Q?F65YZ66SXdPDrWjNQ2hAfIzGKByJR+SvhnTgdXhxw84iBLK1SK+51HMPgXoQ?=
 =?us-ascii?Q?yoLUgFWtheIdab8KPmSAgXQ8Zq8Oj3xsyFgDfHsGVWvmtBlFQDW6wfIJcf1q?=
 =?us-ascii?Q?6ObQDFmwij3FAiwRq+IJRC9ymmElS0o7+FQYuMC4ghuViZqaBKsb2Dy6h5D6?=
 =?us-ascii?Q?Rp1e1hyGqNF73dibFYJ9TDRmfZl1yBUJ55POjx1qRNmlju8NpO+F9OPRUIZd?=
 =?us-ascii?Q?3F6eV6lB/xuPZDRTIoYburVdQIBI/jnVRncYyfW6fjv4l02O/LuE7G/Vi5Ze?=
 =?us-ascii?Q?tlu7Xa6J1nNAJfwrk1sKsZUu746JP+ks67FasMrFlUDZgcRUIgyWBC6XWGp+?=
 =?us-ascii?Q?kqyiZY0a/RnleRqQ+DbJ9RbZtGDh9/USINxHQUHvHjXOIhLEk80f17rNOFDy?=
 =?us-ascii?Q?1S6TqAwy1yW8/1MGGko+trog3VYth038YtOvi/V7UfFULR4kKHy6x7XFbLPT?=
 =?us-ascii?Q?hCpypgViw2hAhk7ov9sPiU+pxKsgXFsKam9AJ/iZRugZQNq12prImZ3Hx0ku?=
 =?us-ascii?Q?Bl8cEfC6k0Iv4Upuhv5cJcW222Kc/mZSJfdNReTk+daA9lLHKU+Y8VnSeUc5?=
 =?us-ascii?Q?CLDzJXs5XKzXgsHuqBwmSNs8qABwe4gBNNHZmxJHvjbhHxyTYKBXanLqIFaB?=
 =?us-ascii?Q?/eu+n98EKO0XtKYZpTnSKtNPJnQQmSYPXIBQzlC+Px+Z+7qaVA83fZHRPMTu?=
 =?us-ascii?Q?2WinsMd9zCtXBBiUrVtKTpQ5a4dOnfSxeQiYVL2Y0af6tlE8lc1KuuoYsecU?=
 =?us-ascii?Q?xY6GJm1264hyaVuDrhHwqdp8?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/acb3p3QcaHjnfok9yUPzvQaGdPioXZr+D6t5FHi+o4zXdhhkQ2Qu5oB/UUg?=
 =?us-ascii?Q?B0d/xfVmec52xKCwutZyFvoevtZWVKacq38DOKl2KHmoGQauuyF3DfNFz9Z9?=
 =?us-ascii?Q?Uy303DEUp6EImKpn2vv/51lgGdZuUQnka2POTA/iMaaMZSnrWyY1q4u7RJdU?=
 =?us-ascii?Q?yOo8hVziebBAfBRl19neQuLlQCD7wPYJqEJZpfofptJ8ZpjGmYY5GIA5m4zV?=
 =?us-ascii?Q?ZJ0oazijcuQuTts+d7b7u15pYmlUm0dls9kkfF1pD/fqAeaC23Nbi+v7hudg?=
 =?us-ascii?Q?F8k0wmL8OqBVwSQFQElz0iwXdS7NOAtv1+kmFqwIxQCV4eWRayHxNhzAvmNQ?=
 =?us-ascii?Q?P4IsolMKVDwJIEwYntpTaqJB77cMYzFmi2ZMHxqYX0rWSG3t7noGGtxElguq?=
 =?us-ascii?Q?YBps/Mt4/NWnJ0lhDZnadkpucbhJhztLLaAMXYGKSVEGWHj0S2oJoQznE4e7?=
 =?us-ascii?Q?04RzjxnI3cAycikJTwEztAZB7dEO/Be+t8art4T3zW1gM3pOVHIOABUZm8ZU?=
 =?us-ascii?Q?CNS1O1vDHNWvXQ9Wdb5IroiTVYC0/HTND8Hj5ZafyUqL2vZLCxlZ8NR9tgOU?=
 =?us-ascii?Q?cBlNgEinjSxH3ONlwsFJWAIK4mznob1+Xdm3Z7GmR7QOczUoVyIwjOuU/DWV?=
 =?us-ascii?Q?nhmMwhsYzyR0FTBCBJHUtRUeC9M+NWQoxOY7v0bLddv6w4L3jG4mEmu0XthK?=
 =?us-ascii?Q?NUYBIwCrwoGccd6J+lFn8UIrEq2jDFZO+etvMUWDleZhIyO0Q4oCdWTjG1VN?=
 =?us-ascii?Q?iprVgMevvmvSn/LZWTSvlDf+MMYO2jsjY0h+lh5TqGpArqmT0OD+RvUk+RuV?=
 =?us-ascii?Q?7Sh0MsekqAfqVJWxRF0GTC+xADXIrRkGePGMtvp2Vk/b4fhzIH2bCj+mSsyY?=
 =?us-ascii?Q?KX2NKvQdygxVdxXovbdt43ucV1+VR5xcBtaIHUnYApdbFmv1HZsqmUy8Jb8l?=
 =?us-ascii?Q?5iwVtC78xrx4Wlvn3S/qRElrxjavSUUJnyp9UkQdYz+7DXnU2ug7hxG+GAq5?=
 =?us-ascii?Q?u19yAXPfcp+ej6/d3y014hFlfHOrGjFosD7C8CpHPwbr7GbWpGSjuO+EsiyX?=
 =?us-ascii?Q?v9IHiwlRncDdyzfoPaUZThpUwQRJ+VXPxVoVORH9kJjWwjozQYBVz5SJ6iU8?=
 =?us-ascii?Q?Rz+0huokbm8dlHirRdA4ZLLWa+YhtZkp4v67tCZcNbawGzhNEjpMQMQqQ5IZ?=
 =?us-ascii?Q?ChlvkH89t4VzP17mOwQlhsnG0bp7r0vltyqxKp4630kvt3U5vxxHaHm41Szo?=
 =?us-ascii?Q?4pa2AgRhbcHlsswnXRmNaFBgbBKCzc3V3FQquABS05hpRle3anUmqYI4elvc?=
 =?us-ascii?Q?+1NDB3BPjTmjCifz5r1wMMQFDjAHc9Uwy9qlbzyH4POrKdqzf5KFYvdmRs5A?=
 =?us-ascii?Q?2BLvk709D0Z5XprMCIm7wnkkIiLrK5z3lGMxrGYeCHswTVE9apJvZUmnqL6X?=
 =?us-ascii?Q?J3bMR3yUapkFrL23y8ls+mD4wU58136WmvgQxgtldx9BK0kXzqfN4HkW8qzO?=
 =?us-ascii?Q?BA19Gx/MzxvBX2q6V89lpzDV45PnN7r2Mc7T9Bj1O19r9+sCNlfrzGS5iJxS?=
 =?us-ascii?Q?k11QrzfsxKu/5/fBtbQ=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f44f4ad3-ad18-4f50-9fa8-08dd04e64c3f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2024 19:55:32.7152
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QO1IMG+bGxb/DQx+SWBwFO6o9ZdeXnE2dA8BKbDyPQKY55TnD5a8k8AmjQ17tQ/j
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6563

It turns out all the drivers that are using this immediately call into
another function, so just make that function directly into the op. This
makes paging=NULL for domain_alloc_user and we can remove the argument in
the next patch.

The function mirrors the similar op in the viommu that allocates a nested
domain on top of the viommu's nesting parent. This version supports cases
where a viommu is not being used.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/intel/iommu.c          |  9 +++------
 drivers/iommu/intel/iommu.h          |  6 ++++--
 drivers/iommu/intel/nested.c         | 11 +++++++++--
 drivers/iommu/iommufd/hw_pagetable.c |  8 ++++----
 drivers/iommu/iommufd/selftest.c     |  7 ++++---
 include/linux/iommu.h                |  9 +++++----
 6 files changed, 29 insertions(+), 21 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 527f6f89d8a1f5..6f11a075114f7a 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -3340,12 +3340,8 @@ intel_iommu_domain_alloc_user(struct device *dev, u32 flags,
 	struct iommu_domain *domain;
 	bool first_stage;
 
-	/* Must be NESTING domain */
-	if (parent) {
-		if (!nested_supported(iommu) || flags)
-			return ERR_PTR(-EOPNOTSUPP);
-		return intel_nested_domain_alloc(parent, user_data);
-	}
+	if (parent)
+		return ERR_PTR(-EOPNOTSUPP);
 
 	if (flags &
 	    (~(IOMMU_HWPT_ALLOC_NEST_PARENT | IOMMU_HWPT_ALLOC_DIRTY_TRACKING
@@ -4475,6 +4471,7 @@ const struct iommu_ops intel_iommu_ops = {
 	.domain_alloc_user	= intel_iommu_domain_alloc_user,
 	.domain_alloc_sva	= intel_svm_domain_alloc,
 	.domain_alloc_paging	= intel_iommu_domain_alloc_paging,
+	.domain_alloc_nested	= intel_iommu_domain_alloc_nested,
 	.probe_device		= intel_iommu_probe_device,
 	.release_device		= intel_iommu_release_device,
 	.get_resv_regions	= intel_iommu_get_resv_regions,
diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
index 2cca094c259dc1..6ea7bbe26b19d5 100644
--- a/drivers/iommu/intel/iommu.h
+++ b/drivers/iommu/intel/iommu.h
@@ -1265,8 +1265,10 @@ int __domain_setup_first_level(struct intel_iommu *iommu,
 int dmar_ir_support(void);
 
 void iommu_flush_write_buffer(struct intel_iommu *iommu);
-struct iommu_domain *intel_nested_domain_alloc(struct iommu_domain *parent,
-					       const struct iommu_user_data *user_data);
+struct iommu_domain *
+intel_iommu_domain_alloc_nested(struct device *dev, struct iommu_domain *parent,
+				u32 flags,
+				const struct iommu_user_data *user_data);
 struct device *device_rbtree_find(struct intel_iommu *iommu, u16 rid);
 
 enum cache_tag_type {
diff --git a/drivers/iommu/intel/nested.c b/drivers/iommu/intel/nested.c
index 42c4533a6ea21d..aba92c00b42740 100644
--- a/drivers/iommu/intel/nested.c
+++ b/drivers/iommu/intel/nested.c
@@ -186,14 +186,21 @@ static const struct iommu_domain_ops intel_nested_domain_ops = {
 	.cache_invalidate_user	= intel_nested_cache_invalidate_user,
 };
 
-struct iommu_domain *intel_nested_domain_alloc(struct iommu_domain *parent,
-					       const struct iommu_user_data *user_data)
+struct iommu_domain *
+intel_iommu_domain_alloc_nested(struct device *dev, struct iommu_domain *parent,
+				u32 flags,
+				const struct iommu_user_data *user_data)
 {
+	struct device_domain_info *info = dev_iommu_priv_get(dev);
 	struct dmar_domain *s2_domain = to_dmar_domain(parent);
+	struct intel_iommu *iommu = info->iommu;
 	struct iommu_hwpt_vtd_s1 vtd;
 	struct dmar_domain *domain;
 	int ret;
 
+	if (!nested_supported(iommu) || flags)
+		return ERR_PTR(-EOPNOTSUPP);
+
 	/* Must be nested domain */
 	if (user_data->type != IOMMU_HWPT_DATA_VTD_S1)
 		return ERR_PTR(-EOPNOTSUPP);
diff --git a/drivers/iommu/iommufd/hw_pagetable.c b/drivers/iommu/iommufd/hw_pagetable.c
index 9236e8ca9aa864..ec3c64a8c79633 100644
--- a/drivers/iommu/iommufd/hw_pagetable.c
+++ b/drivers/iommu/iommufd/hw_pagetable.c
@@ -227,7 +227,7 @@ iommufd_hwpt_nested_alloc(struct iommufd_ctx *ictx,
 	int rc;
 
 	if ((flags & ~IOMMU_HWPT_FAULT_ID_VALID) ||
-	    !user_data->len || !ops->domain_alloc_user)
+	    !user_data->len || !ops->domain_alloc_nested)
 		return ERR_PTR(-EOPNOTSUPP);
 	if (parent->auto_domain || !parent->nest_parent ||
 	    parent->common.domain->owner != ops)
@@ -242,9 +242,9 @@ iommufd_hwpt_nested_alloc(struct iommufd_ctx *ictx,
 	refcount_inc(&parent->common.obj.users);
 	hwpt_nested->parent = parent;
 
-	hwpt->domain = ops->domain_alloc_user(idev->dev,
-					      flags & ~IOMMU_HWPT_FAULT_ID_VALID,
-					      parent->common.domain, user_data);
+	hwpt->domain = ops->domain_alloc_nested(
+		idev->dev, parent->common.domain,
+		flags & ~IOMMU_HWPT_FAULT_ID_VALID, user_data);
 	if (IS_ERR(hwpt->domain)) {
 		rc = PTR_ERR(hwpt->domain);
 		hwpt->domain = NULL;
diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/selftest.c
index 2f9de177dffc79..c58083c3660aee 100644
--- a/drivers/iommu/iommufd/selftest.c
+++ b/drivers/iommu/iommufd/selftest.c
@@ -356,8 +356,8 @@ __mock_domain_alloc_nested(const struct iommu_user_data *user_data)
 }
 
 static struct iommu_domain *
-mock_domain_alloc_nested(struct iommu_domain *parent, u32 flags,
-			 const struct iommu_user_data *user_data)
+mock_domain_alloc_nested(struct device *dev, struct iommu_domain *parent,
+			 u32 flags, const struct iommu_user_data *user_data)
 {
 	struct mock_iommu_domain_nested *mock_nested;
 	struct mock_iommu_domain *mock_parent;
@@ -391,7 +391,7 @@ mock_domain_alloc_user(struct device *dev, u32 flags,
 	struct iommu_domain *domain;
 
 	if (parent)
-		return mock_domain_alloc_nested(parent, flags, user_data);
+		return ERR_PTR(-EOPNOTSUPP);
 
 	if (user_data)
 		return ERR_PTR(-EOPNOTSUPP);
@@ -719,6 +719,7 @@ static const struct iommu_ops mock_ops = {
 	.hw_info = mock_domain_hw_info,
 	.domain_alloc_paging = mock_domain_alloc_paging,
 	.domain_alloc_user = mock_domain_alloc_user,
+	.domain_alloc_nested = mock_domain_alloc_nested,
 	.capable = mock_domain_capable,
 	.device_group = generic_device_group,
 	.probe_device = mock_probe_device,
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index d6aaaec3caf462..0472cc1245192d 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -559,15 +559,13 @@ iommu_copy_struct_from_full_user_array(void *kdst, size_t kdst_entry_size,
  *                the caller iommu_domain_alloc() returns.
  * @domain_alloc_user: Allocate an iommu domain corresponding to the input
  *                     parameters as defined in include/uapi/linux/iommufd.h.
- *                     Upon success, if the @user_data is valid and the @parent
- *                     points to a kernel-managed domain, the new domain must be
- *                     IOMMU_DOMAIN_NESTED type; otherwise, the @parent must be
- *                     NULL while the @user_data can be optionally provided, the
+ *                     The @user_data can be optionally provided, the
  *                     new domain must support __IOMMU_DOMAIN_PAGING.
  *                     Upon failure, ERR_PTR must be returned.
  * @domain_alloc_paging: Allocate an iommu_domain that can be used for
  *                       UNMANAGED, DMA, and DMA_FQ domain types.
  * @domain_alloc_sva: Allocate an iommu_domain for Shared Virtual Addressing.
+ * @domain_alloc_nested: Allocate an iommu_domain for nested translation.
  * @probe_device: Add device to iommu driver handling
  * @release_device: Remove device from iommu driver handling
  * @probe_finalize: Do final setup work after the device is added to an IOMMU
@@ -622,6 +620,9 @@ struct iommu_ops {
 	struct iommu_domain *(*domain_alloc_paging)(struct device *dev);
 	struct iommu_domain *(*domain_alloc_sva)(struct device *dev,
 						 struct mm_struct *mm);
+	struct iommu_domain *(*domain_alloc_nested)(
+		struct device *dev, struct iommu_domain *parent, u32 flags,
+		const struct iommu_user_data *user_data);
 
 	struct iommu_device *(*probe_device)(struct device *dev);
 	void (*release_device)(struct device *dev);
-- 
2.43.0

