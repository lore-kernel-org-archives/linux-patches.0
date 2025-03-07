Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2041.outbound.protection.outlook.com [40.107.223.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9FB619D89E;
	Fri,  7 Mar 2025 18:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741371458; cv=fail; b=gTaXr2FbqltwVlfPWOhqII+BcxRCKoKDwvhNK6z0DjegDA+IB6U51blnH1N2VTpHFb01HPRKig3c2KBrKvXnMkm0lKwjfPwp5T9s6azJv4qcy5hi9EkBIpm/Fb1C7IkBg8Gn61vJ+I4e4Ln2Ykp9v4haj31acRcG1ejlpks6ICQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741371458; c=relaxed/simple;
	bh=qQZnGiEi9gFCmOI/jmcvYAHK2UKTWBTzd9AdZ65fp7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=i/AouhjsnjxnDIsJUQp+Tuur3dmGPO4jUsCcPgNlzzZ6oG2WpvSDH1CrMNJJGtkzpGmSguxTsQY/tPN7TqaAyQ3GRiCur/EqhaQ8ckevw5q9rlKrlyDLjwIhiNA375pvmk6bJQR4KxTprc0TPf29IKfAZo3rmDj4+LDiXNUAlKg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=QSka4T+5; arc=fail smtp.client-ip=40.107.223.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="QSka4T+5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gUV60ewLKIX++UCihKec4vwJ2JO4m/gkt1HkfApZ6AN7QDcbhJZ1vzyCil5d1M0cXc7DQ6tGRYCDtihUN6GSWL0PhFlhqYBIQov4uDJZ+trrJb0K4jVAh/fAPQAs4IVTsyid1E6kdf7CF419ceVGuyujxdi3l4lKHhfFEr1x6O4189VLhjtLyDfdzmuzQ0VGS6Mg43MNZvM6jcKH6xsVBxmeH3pgBtaovleI2AnwmjRt0NQ/lWXxyaFhG6h20nWEmAPKKt2KY1ANTi3ds7ioVOhuOph9kMrvJNxgCtAZwOlhOpfm+UGTZkhuNGJnHbrIT9JvA2RbM0pEh7YvzlgShw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HJnP4WjUpu44Fe8BYdDD8ZV2kCUz86ZpZpsOeuHKZJ4=;
 b=RVwgFIFtwFBAUIkfy5OpQyHXC8kYGBnCXhZ6ZHTGkRwcVbQm6/HyitnZHSQ3cNBJCI7E+IhQrtreum/Gh6P0DAuR0x9YOG1Id0tVfpt2shyj4Lajh+/Yl/d8JvvDMFuS8Gj/VINUvrRFWBqLoEDnRlKWVJwMJ9MANMoiZrn5m5uKTkAA3AvFebbztDlRz5P/V1AFCakyRoj0LoCfMSbOeB6r/OEDpHg8/5JHcfQl0EBRpyrMI8TrFTkEo63agtn8omRz/CeQ6F9TIYhxa0EOrpCfRlX/i6XMkvJ/tA9Pn4V9peqwAiJ/YUt/Hh5BOt4hqfK5i9sLoaaUCKj9Xy9KDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HJnP4WjUpu44Fe8BYdDD8ZV2kCUz86ZpZpsOeuHKZJ4=;
 b=QSka4T+50RcodwCtdvsSXz5CO3UDVsYg20T4jWlBj6kWTQpr1yUk8SsKq+xaa4EEiQlVU5K6DzdR85/DFaovsZqrTJj2tP0hiBioiqeeHJpkypIvodsIM+/4eITdnMaqwTSEDtWdWeLMt/Vs1iIXGVbNes1sApi6zoGXWomzET7n6spg2gDsxUCYyBLWQyNl6/jf5GVzgOpJH273HMc8BZnfeCho5PtXty97oQ6hc3syesWhyqlRDnMyg5u+7oaClEkWQdKR26wOdXNpanBCY8F1q9/oF/kCAUnDdXESrysFIpIKSrnUawZPBb2q7TAWam1E9v2Lz38B/kxkKauhNQ==
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
 18:17:28 +0000
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
Subject: [PATCH v3 2/5] iommu: Add domain_alloc_identity()
Date: Fri,  7 Mar 2025 14:17:23 -0400
Message-ID: <2-v3-e005a650174b+53def-iommu_virtio_domains_jgg@nvidia.com>
In-Reply-To: <0-v3-e005a650174b+53def-iommu_virtio_domains_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0308.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::13) To MW6PR12MB8663.namprd12.prod.outlook.com
 (2603:10b6:303:240::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW6PR12MB8663:EE_|PH7PR12MB6539:EE_
X-MS-Office365-Filtering-Correlation-Id: ec6084f3-e0a7-4885-fa89-08dd5da451b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6U623G2ssWdk4DgqQJ3OeSBjW2QWOSwH/EYGwz+56CLjSpWGqgKWWEfvlEEU?=
 =?us-ascii?Q?hLe2zoi4Zvoa28fzeIqqneTawnJynqfzC2YMjtlVz/HeM1JEkcAjytzRCKh2?=
 =?us-ascii?Q?Sia9apOOLT+5jvlYFHS4cxur59VJzK9cCUoYZx+JM+0Us+WnY7IoJCgCkxff?=
 =?us-ascii?Q?ys7tkNIuMU4MfeYXuPrrTZ057h68nxXqPwY2WMkm+Ov1hUpVQnjjo+1jtEif?=
 =?us-ascii?Q?/561brymLaau32nwinXZdrQz6au1nMGvxBX/IIuY7u8V0trxAtZIWHQv1sun?=
 =?us-ascii?Q?8ijjAACAHDk2zlqWwIhK0a/FftYEYMK8iVC2+XGBWRM1YVHtEYZKh4vEBtGx?=
 =?us-ascii?Q?mG3M8+nTnT1q5+AVAoGwk5IaVMfGtI35ZYmKy+YstoxkU0jRJBNRP8ZyANYn?=
 =?us-ascii?Q?u5yEoLrKt7MsnePxahxtjXqC/nBQnXmPmiw/Yq57RPVmGnaQ1OZEFryC/uxM?=
 =?us-ascii?Q?bzBWGQC3gWbsq/OUlBEc2y0xk/MJWBfbgVGJeKMQi+F/qtvgnafk9FmvX+31?=
 =?us-ascii?Q?o0GMQRxISgbj4POh7ZTtVz5gyodNWE+6CkJDbK46HsN2FAm4L/PupJ4jnvDL?=
 =?us-ascii?Q?r0Ieb1f/hHe2g5QuVXIeq8R7qOJuYlbR+aXPW9YdlPCeuOYOiNTy7e795QlF?=
 =?us-ascii?Q?XRG6BhySwgMmNyKABizIe7nABCQ/aM1ywQ19U5E5/jQyvCldKNvD7swqK8K5?=
 =?us-ascii?Q?0g8SGLpcd/YLh99gdEh5AEQFFAcee2vcuzPJySXeivpoXzWKTqnoxbBPsPKG?=
 =?us-ascii?Q?OwCK9SPVfhCl+HvUdEgWgIyUGKJyILGQtk2HEFwgQqPjxjODOWLUSnamqX9g?=
 =?us-ascii?Q?Y1aguxJKdGEaKGQyITe1Izk3kM0H63ijCs8VDh9hIvRzbeXBr8287+SAapy/?=
 =?us-ascii?Q?ovWky5CFnT9MZc7wAT2ZxluvRrAHGspBiyvP/Nx5w4H0/OxRBvT/58fE1JnS?=
 =?us-ascii?Q?D/CLF64AGsTxczOQxdzXvfVH02QljRZM1F2woIX0UdyawgVwaJ9/d/B0ORx8?=
 =?us-ascii?Q?GITPSnus/J5n4kD/kjVp9MKp6GSOwgfJ92nRlJ0s6ojANQPcG/gJpck+fKrM?=
 =?us-ascii?Q?kg+yKLNV/ZkOTBQGhDNsI7dTcM2gid3+O7mtYxZMja6/ZAcDumdhoXMVCwCV?=
 =?us-ascii?Q?/lKx74THmZ3D/ctMm4kMHE0eSoHe8C1uxw/HjqlV5oOYWG8Pt+7z5JZoKIgY?=
 =?us-ascii?Q?0sqDDJfAH1g1/+bfjiwmtM50yNmr+F3Lx7251+ezxwjj/WGlID4ViHhAKx2f?=
 =?us-ascii?Q?m6/0ApYgQBuCwVzDJlMeeJqwQPZA1JXIFiheqjsOoJYuxT6hQuWKbNZhSMwh?=
 =?us-ascii?Q?1c2QIKZPWZWtqV0TqRCoJCgLm9G8aVdY528+GaetHbtpdVSWNURFXbsFIudp?=
 =?us-ascii?Q?o5oWRaWXf/GY03LZmOVE7RxfzpEr?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW6PR12MB8663.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zW3doV/0DFG0Xw5lR6blke6YTt2reAEY+7KuA01qmmla8sRqBVO9tJ2zgqa0?=
 =?us-ascii?Q?08iUp1yTogHUBFLhR9DXzgRY6l4uKwFa2vkZMGT4ecTGnYKn80fORuEQxeCL?=
 =?us-ascii?Q?Y20AairHupgxN23ZIcbiPWZWs73jTuuh1GQ62qJCzmSqm+dRsa+Uw1k9oUX0?=
 =?us-ascii?Q?Jz828XkzTvOoDAgFSkIhbqPmTV4QSj9ZOTkrHmu0iDaZTuw1DgEfeezSXz9d?=
 =?us-ascii?Q?h7q2PPWmAdacBIn05fRA5CoUpFRXmdSumfp31zriEssiAqkTzRBR2br7Wk6j?=
 =?us-ascii?Q?THn0/6gol2x9K7hopZ2mcz99fO6XxxWqdt86H+LjFkrJ5SXcYFNEkC7B3zQz?=
 =?us-ascii?Q?/6W8Gh5SgmmlP39YuoFsc/IFnFKcOZUyyjeUR84ACukDOmcxsbek8Ef995/L?=
 =?us-ascii?Q?kdXqmmUKamtHElCCtXE1aKnvlbIxubAxaeB6pmOGW7clf0nWMTTe8V2BbXAC?=
 =?us-ascii?Q?afqC5WDEWw2kNFhPAr5LgXHRy66AKdQMSSNdefVrYRZUy+ukri17guK87gzg?=
 =?us-ascii?Q?7OQMfQkq4TT55GVZhPI7CmOfFW8zFrh5qLKqoenwaXt+nK75JxP5Gh13j8Tu?=
 =?us-ascii?Q?1PNzJ+h42fEUPSSpqqvpZvcDEoOwd+QOW+nnoDNoMct8N4Ca3mtWb4pJQC5E?=
 =?us-ascii?Q?hi2lwq8X2OGq3Y10cEWA3ib7PLYoWuaFux5mkJzbGJ9D0x3JUi2N3xI/EdKM?=
 =?us-ascii?Q?Bs3FSndt/eipfT9QNCCxr5JyuKhzfBk2vVIVbfcG+pJlo3BvLyjF6aOnRrqc?=
 =?us-ascii?Q?jn9+/LC6N4TxHjB+JTj4deZA2ORwjODTD5B9F7gduLHT7f8b8mGCYHg2wkyM?=
 =?us-ascii?Q?84Af7XCD7ZrO7pXhgm8CLqKS1V03+XS9oEyO5CQrGzuGeMJolYPtqnRomIQr?=
 =?us-ascii?Q?E9rW9oza4iwfxToreZfLodERjAyIcTFSxr/yNwPLTpN3Teff8RWkFfbtD10J?=
 =?us-ascii?Q?hNvN9id5sTCBF7cGLbrIFMPHKEL7DpWaJPYP8odt9WOR5Jj8Jgpml4FkbO3M?=
 =?us-ascii?Q?WLWUZa5MDkU9QivxGWjnsca8Xz9o0w/fXm5ynR9GZV1mLAtVCLGm+OzEGx91?=
 =?us-ascii?Q?duxaIfFEa8oZqSQvwrj5DxcSTLG4QVQXts+ojbsaPEgUQTgC+Jb9tEPzYRdY?=
 =?us-ascii?Q?9QrH7e/Dsg0jrE0i8+1jaW64VGIFoX2dyvoR8UNo+6hQUtsqLD1zZ4f5zLqk?=
 =?us-ascii?Q?v5TPtLnKUpaEMiV4gLy2BZnFfFfh7BktwCjM6vxlhdDnnOmfxSrjVHU0UwBd?=
 =?us-ascii?Q?iCehaFvJum1NDyRT4QqkSIgids4o/fDM/bXbvkkut4vtVXFWRiwryf7CBlhq?=
 =?us-ascii?Q?DznIVrUm+LND+T583pWpQINj/+jxdu7nSrELmBGCjvRWWmi+kP6Lj5YpoAck?=
 =?us-ascii?Q?AqxXWkdIXCHFCpKTIdT7rxcHj3iPOwohd4bngyzI6KtmJHwptzVqxZ8seTUR?=
 =?us-ascii?Q?pWb7j8vdYXhD7qQWGx8tqjks4uOoVcEI9eUL0uIhJtbb52PQwJTA9em1jYDE?=
 =?us-ascii?Q?VD7ThLUtC1rHBLCPNogMJUAU/jiERzLZE6tAaMq8ieRBKbwS0TcFm8kyrwlQ?=
 =?us-ascii?Q?xmIWfPYDfW4pLjXjAGZ6wcf4tj2Wr5es5uYYr1sP?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec6084f3-e0a7-4885-fa89-08dd5da451b5
X-MS-Exchange-CrossTenant-AuthSource: MW6PR12MB8663.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2025 18:17:28.4498
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MjyUvmYnY3zm/iuiOXGRTMdB/5rl8YYpPlVFyfHhhtAwx7csmYBp0+XbvBHF0rKB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6539

virtio-iommu has a mode where the IDENTITY domain is actually a paging
domain with an identity mapping covering some of the system address
space manually created.

To support this add a new domain_alloc_identity() op that accepts
the struct device so that virtio can allocate and fully finalize a
paging domain to return.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommu.c | 20 ++++++++++++--------
 include/linux/iommu.h |  4 ++++
 2 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 870c3cdbd0f622..ee33d26dfcd40d 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1595,15 +1595,19 @@ static struct iommu_domain *__iommu_alloc_identity_domain(struct device *dev)
 	if (ops->identity_domain)
 		return ops->identity_domain;
 
-	/* Older drivers create the identity domain via ops->domain_alloc() */
-	if (!ops->domain_alloc)
+	if (ops->domain_alloc_identity) {
+		domain = ops->domain_alloc_identity(dev);
+		if (IS_ERR(domain))
+			return domain;
+	} else if (ops->domain_alloc) {
+		domain = ops->domain_alloc(IOMMU_DOMAIN_IDENTITY);
+		if (!domain)
+			return ERR_PTR(-ENOMEM);
+		if (IS_ERR(domain))
+			return domain;
+	} else {
 		return ERR_PTR(-EOPNOTSUPP);
-
-	domain = ops->domain_alloc(IOMMU_DOMAIN_IDENTITY);
-	if (IS_ERR(domain))
-		return domain;
-	if (!domain)
-		return ERR_PTR(-ENOMEM);
+	}
 
 	iommu_domain_init(domain, IOMMU_DOMAIN_IDENTITY, ops);
 	return domain;
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 38c65e92ecd091..6389d59178ba3f 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -557,6 +557,9 @@ iommu_copy_struct_from_full_user_array(void *kdst, size_t kdst_entry_size,
  * @domain_alloc: allocate and return an iommu domain if success. Otherwise
  *                NULL is returned. The domain is not fully initialized until
  *                the caller iommu_domain_alloc() returns.
+ * @domain_alloc_identity: allocate an IDENTITY domain. Drivers should prefer to
+ *                         use identity_domain instead. This should only be used
+ *                         if dynamic logic is necessary.
  * @domain_alloc_paging_flags: Allocate an iommu domain corresponding to the
  *                     input parameters as defined in
  *                     include/uapi/linux/iommufd.h. The @user_data can be
@@ -615,6 +618,7 @@ struct iommu_ops {
 
 	/* Domain allocation and freeing by the iommu driver */
 	struct iommu_domain *(*domain_alloc)(unsigned iommu_domain_type);
+	struct iommu_domain *(*domain_alloc_identity)(struct device *dev);
 	struct iommu_domain *(*domain_alloc_paging_flags)(
 		struct device *dev, u32 flags,
 		const struct iommu_user_data *user_data);
-- 
2.43.0

