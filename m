Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012036.outbound.protection.outlook.com [52.101.48.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D25261B6E;
	Tue, 16 Sep 2025 16:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758039018; cv=fail; b=hNrm/SWumOeZekZCk5naM7M4Pcp0TaSNuAI8Rmmbon2qFn66b7o5Z0PvHOdPQ24JMFKmxIDI0mBRJlE6Yp/bDLtFR40GmJeAuDctjv5O11LxIuuFDgOTrhf8YzuPOK7r0eCUB6H3nkkkbyizz9JTZ2souuA9LWbc5jIY/ENJOmU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758039018; c=relaxed/simple;
	bh=Cy0AlA7nIVbX/0t2dyrOSgR1okGu9doXOU+Fl+KnwpE=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=esOO4E22I2ltBxDtW5aP823aUmAUM+R0/rE7haaFlXzTupGUokhu3b1/k9g2II7hYkRan/D60f+g+K0Flb3xlhGCRxbZ+IrlLHN7B0921+tahmtg5vwbp3ludJD8e1cEOBwvRiOyUg/JgW0UJGnT0cNBAbObb7ECgpFnYOJHU4M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=sVxu7Fxq; arc=fail smtp.client-ip=52.101.48.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="sVxu7Fxq"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LXARbHG7aVHjmqJbFX+ao2TuLZzlRlDoB3N4tMfJLubeFAan2fa8xKx1YLhVCn+OAd1sIi7Em8k0u5jhkRlmgSZ6xS+B7pU2tVDfzzmK6Nd/ceT5wOxdN0rOSWzcHs7WipmzV1XwKK+j3/s7M0m6imkct3xzNaz918wcgKZZINo7x3nGPGerewxdd/7q4mJp5F/NPhDBAcNsFYNxqJ+s/L6N0kbh7mXYAzn8Xq37JB3lUvPIKDIQB/ygPQjHuVfCfhPr8RC2tWx2wBZ5THwzlTOy7MuC6T/ZlnJqyttf8lPiIU2P1P5Rw8AizpFCmuDp91l6haGlqdnu2RC1goUa4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F1pQ0oY5uPUIrKI7bEeJylxnUGhJ3nWXIVSE+g12tTg=;
 b=KHxeP0vKNbLhlXe7egU6E1sSXmzgDu8JB6dc+EnmsKN+TL/XODsdygshZpDbRYZAEL2wW8GWIiDsMkVYRXkd9uRXaiTZUFNyKiLZK+N0be8hye942uicCqnPnQWqB4PJQHLbE8T1mD54jHaEjyb8btDgsbkxwqKH0GtNoBXfSqzRUN0XvLHDsG2tb8j07tv7TqmLPTlnjDKouNKs9zb5QVOzdkN3KqS6p41sCwnA/HXIPbPouJC6WCwMwsO2r76miXyzKdVYqVFUPog+Hz3eMsuzVmyhCAu7WKcP0jb64qjWW3MbSrqII1xTj8/ccyEFYfdVYvbRBU+T4s+fJXDaqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F1pQ0oY5uPUIrKI7bEeJylxnUGhJ3nWXIVSE+g12tTg=;
 b=sVxu7Fxqa8ArKqesFnWiFj6ZaYzBiynm8wGs9ozENWPege5ugzvq+j3JzvAjeEzI3Fm9ajrSdMJt85esAA9dGSz9W58qpr2P6neZDv5aG10A07hGGNphEpjtpz8dRcJBsobVHd1LFgeLqjuCYsT2/L+U390ZnZTTnvvaf3mJol60Cbc5ledfs3Vdt32yyOootHzGx4UcTtEc1A1RiBwUwcRAAob0fIAw0/vG++rVBqMZGDNlk8blhyciUs2oF/hxqb+PIyw3GsvMr5LnKUO5i2b6wWUOPIsnhKNZ1qpOiQgX90nMDC/Gx59mChTXunYdQxLx/E7KAVP3rwz0zsV2Gw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by DS0PR12MB7535.namprd12.prod.outlook.com (2603:10b6:8:13a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Tue, 16 Sep
 2025 16:10:09 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9115.022; Tue, 16 Sep 2025
 16:10:09 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>
Subject: [PATCH] iommufd: Fix refcounting race during mmap
Date: Tue, 16 Sep 2025 13:10:07 -0300
Message-ID: <0-v1-e6faace50971+3cc-iommufd_mmap_fix_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0045.namprd03.prod.outlook.com
 (2603:10b6:408:fb::20) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|DS0PR12MB7535:EE_
X-MS-Office365-Filtering-Correlation-Id: 34bfe648-f65f-46c3-3eb2-08ddf53b81f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?iePcyxDYpQiaxq8vFHia9rgE3rAPtcEyW+rpfFizErBwS9prFRwbvjsy4Ng5?=
 =?us-ascii?Q?EKDdQ5lgOh7HGt2s7wFl1YkeCcUIlMOlO1f0JY46HBY6+6VWnmxGas658qDW?=
 =?us-ascii?Q?hGSIR35rYvugNV8zoaSHY2oUQ8P9kUTSvtqy3mV9Z3PL83iv8/C7aNR7b3W9?=
 =?us-ascii?Q?Hvp3KKoW7/mxK1kLYsoT5yv92nafqdHDHaqqBuVsFsGKmhdSHkFMtdORCYp9?=
 =?us-ascii?Q?+PyaIQ5kodeVrrUbonmplimPwB751Xx11KrZDZfgyuF+QQw8wEgj38/Edkbb?=
 =?us-ascii?Q?QJiE6gJsPPkySpCM5gCalUAoCyAqufSDUC0ve8irVS7N2uVwMac/NgEVjO6r?=
 =?us-ascii?Q?gWHAv1KAki/2S23A/cP5gKxq6EdVDqwNxu4OZA2HrxZoKKrSqIBGgCn9pU5g?=
 =?us-ascii?Q?7WmQ1FECTLBDnVAW7SNNn0lvg9iudOPWQn3aL82Ge4EVd1VESSQUxjZszEpD?=
 =?us-ascii?Q?N+ISx2cKMcRonF/hX+NvD/7+0ALAcfluQDToe7NTekBx3eF5BN/6hmBiCXe0?=
 =?us-ascii?Q?nVGN5OXyPrWSKSTD7hTFJVyixvyrBMmopXKc1I1zqsyF0FGAPsOxE8X8HDcA?=
 =?us-ascii?Q?E31fFOjAZOWdUZFzy/9ffcGiXLnXLkRSU328Hma0p3S8gzpJIQY2XDLcaKZj?=
 =?us-ascii?Q?9XgszVMEJFpjCFu1YbJPH4dXOvuB1RwKZTs36zAt2O994LZrfl7elwbFStEo?=
 =?us-ascii?Q?m4+jKA07OqvMTZIxTRbjVQUZ7cmKSVXun7AqutRqDn9LtuxmHbwWOEOO0tQ2?=
 =?us-ascii?Q?yldSXMgs9dXOz9dlLq/plw/7KCJLab+ySwN1L4r4Peaa4zWJzOB2UQH+9OtT?=
 =?us-ascii?Q?Y9CmsPfW3fpSRiNj7iG+k3iHFmKPf6JOalsAoujc5SSwLgKzs8SR9w7axs59?=
 =?us-ascii?Q?Z+g9bLrI8utV9eN/R7u7EtKAd/KZffraSJFh4iQwSZtiWfVsuCJc8omS9xnA?=
 =?us-ascii?Q?riefuzKP1YmyGJNl+cc0wA01+ckm2iZAMPiVZ32RIuf0SCfBR9HEj5t6NS5d?=
 =?us-ascii?Q?1BUQVICRxajoJV4BizJ3PPNiXsYoY5psDtwVeUuwaGZ+vbh5XRkZWT4W+c7H?=
 =?us-ascii?Q?pstbehlxY5uNvPBS28NjCEBAaE090JitnSVuk+e5tGmLzSYkd9FXAR178Ns+?=
 =?us-ascii?Q?zXSobpd54qnzlBpDhvUsH+titdFNgE0owTKh6Ti9O9K7yKZzQrEh6p9pb5lJ?=
 =?us-ascii?Q?oWv3Ro/xfvJmeMqu9wWQGzX/X4KcC1KqZ8TOrp4BDHIMWtH7KeXIA7HSRq2E?=
 =?us-ascii?Q?K0J3RcRPbDD3s6WXGcOwQwFyBVViWv6deVESiYka56tuNKaq/8u6gFljndmN?=
 =?us-ascii?Q?4UYnjSTKjpsQVtlWAbn6GpBc0jJfXeOpiAJ0iBenl2wyvmhkDnvhZ4j2OksI?=
 =?us-ascii?Q?DkmZcJKF5w5JcyhYcuJgUKs8IOPYuwa1Hd4tMnSx7y6BZjFIw2b9tciqgDmS?=
 =?us-ascii?Q?VND6Zsjndfs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gI3B2xWQ81jwgPRJiEBfr67QzokJoKDT/ds/GlCgU0imD1Y5i9xv0oeq1RT8?=
 =?us-ascii?Q?89Tuf7apKytN4u6GIugsKs86CPD+bo24kgMDg1VGwjAGzVyrFj/G3z1WiQBA?=
 =?us-ascii?Q?jikSTmZJ05IP+olvtCla3FUyeXAQ/fvsVTefbhq+eFtCgh5x2oMGTtun3KtD?=
 =?us-ascii?Q?5lfWw1dGyKeZj1MYTU3oMgjYRokQYdcbaTxscw2zGOfsAmfb8oz6h++ynpZv?=
 =?us-ascii?Q?JGKYmUq70vRDzKDJRpzWMknzRleNcpcOJhJtTU4VY+oOagwPjuEJgWekru97?=
 =?us-ascii?Q?NLby6mmju9Pio1dupAgEmMqsRo3a6jGQKGr3c0ZodgjpMQgpjliiSjLJCtFv?=
 =?us-ascii?Q?Gj52cAijV1m7bZ5rfu6qNGVG04E5JeE1jRS7CuI6RKvqO0tbgcB5qluOgbrK?=
 =?us-ascii?Q?aFHDFdmXttPr8H/4W+PkZ3x+nsVp3sTAdSdffYLP08wbyZ/FOpqVTZ/oAfpw?=
 =?us-ascii?Q?aHfo8P88QhBaYawKMOOi+NCr9KiKWPHnPLLQspb0gSTul7i3KMB0wR3WkmOg?=
 =?us-ascii?Q?Pg5LGyptMjVbjfamS6D6oCIniCTLfsDeLw/iE1HQqkj/AO/106Km9uJk1y+/?=
 =?us-ascii?Q?zad4dcJEpSkOV6jzAWcUoqWJSTibQGA9T/t7HSXvi25MJ0yr5tQTbF9EDC3g?=
 =?us-ascii?Q?M6yBi4Uf26vo2SpA8nZV/maIZrn/hqmfvj5KFnStM+mhTCek5I0TKHrLmaEU?=
 =?us-ascii?Q?DeF6PPyzJwVlna4DSOWE+oDyKUwsGtd+x5wuxn0sDJ+1bb9+B/um4ZiQAMy8?=
 =?us-ascii?Q?7P9rkPzrjZSrK3HlcaQKIK/UvD7Z5dlq7MM9L2yNwms0m5TtVsJX5vnCPr6G?=
 =?us-ascii?Q?bY+bdQy+a/D2X3srI2BoS03RAm43i0pbOfaJe0QusSE3nymDpwy3dvnOa6vc?=
 =?us-ascii?Q?wzSI8xtsaAuA9NMAvKgSZ4xcCvypWrjPAvZgQrJdykhUhO1GWQdpCjXEseP+?=
 =?us-ascii?Q?7x+AzQOy3CzwhPppPFXooEe1YUPA1UKsiXn8c00dnKU/2qJsid1k6PrlEhUv?=
 =?us-ascii?Q?QiJU2zkn5bxauv+flzWyrbRC82GgHENlm2Tr9XQ96jfdlQZws1LnU2Mttpco?=
 =?us-ascii?Q?gWrwvsaBNaHuEjz5sLQR8RLrnTtvs7vzTN0UXpi9pj145Rg9klkdv6eCe2E1?=
 =?us-ascii?Q?YAX/qfMuA9w1wuUQtrkJjAr69JbWhOHsKlQvhkb4wg10MYLgTCun4TzRbl2R?=
 =?us-ascii?Q?Gw+rk3KGUoP6LalGKLFRYSEkh1zXMufXB6pXnHvpfGXSMr7ncwrQzWC9GE1F?=
 =?us-ascii?Q?BeqQq4HLxQvsonsDEPK5uijVM+iQNsexH6OsGDtiaobWxHzuCCGaseJMEz6C?=
 =?us-ascii?Q?9qyY7RSqlc4Pvn3Z/5SCf/RFRRmdMwSHfHo+CTuLpmx3jeE5iA76zEspb5b8?=
 =?us-ascii?Q?VrzehcebikZl5k3h66ems6bEIVCgPX/0DH9oUAi1rE1Rus9TcWL5vFccmdGl?=
 =?us-ascii?Q?nHYr7s49lzwShKuINa4imfmRvc1Wi/kfJZ9yeZ47hfe3WUxXcOzCRzT5zS5w?=
 =?us-ascii?Q?riZqlCd0EBs2fQBP7DvCAF61LSnwZvc1gmBe1npk8iCF8Tux0WA6mApLMs3h?=
 =?us-ascii?Q?3XAT//9kLbJ/GUg4t1hOTFBMjwZu1j7uTWK2pRKH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34bfe648-f65f-46c3-3eb2-08ddf53b81f4
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 16:10:09.0103
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ojkqdGQgujwRHApJYdUVh8ELzG9Nl3UB1DCihX3cEFhuvvPuhmLAKoPBRp05hhe5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7535

The owner object of the imap can be destroyed while the imap remains in
the mtree. So access to the imap pointer without holding locks is racy
with destruction.

The imap is safe to access outside the lock once a users refcount is
obtained, the owner object cannot start destruction until users is 0.

Thus the users refcount should not be obtained at the end of
iommufd_fops_mmap() but instead inside the mtree lock held around the
mtree_load(). Move the refcount there and use refcount_inc_not_zero() as
we can have a 0 refcount inside the mtree during destruction races.

Cc: stable@vger.kernel.org
Fixes: 56e9a0d8e53f ("iommufd: Add mmap interface")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommufd/main.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/iommufd/main.c b/drivers/iommu/iommufd/main.c
index 15af7ced0501d6..109de747e8b3ed 100644
--- a/drivers/iommu/iommufd/main.c
+++ b/drivers/iommu/iommufd/main.c
@@ -551,15 +551,22 @@ static int iommufd_fops_mmap(struct file *filp, struct vm_area_struct *vma)
 		return -EPERM;
 
 	/* vma->vm_pgoff carries a page-shifted start position to an immap */
+	mtree_lock(&ictx->mt_mmap);
 	immap = mtree_load(&ictx->mt_mmap, vma->vm_pgoff << PAGE_SHIFT);
-	if (!immap)
+	if (!immap || !refcount_inc_not_zero(&immap->owner->users)) {
+		mtree_unlock(&ictx->mt_mmap);
 		return -ENXIO;
+	}
+	mtree_unlock(&ictx->mt_mmap);
+
 	/*
 	 * mtree_load() returns the immap for any contained mmio_addr, so only
 	 * allow the exact immap thing to be mapped
 	 */
-	if (vma->vm_pgoff != immap->vm_pgoff || length != immap->length)
-		return -ENXIO;
+	if (vma->vm_pgoff != immap->vm_pgoff || length != immap->length) {
+		rc = -ENXIO;
+		goto err_refcount;
+	}
 
 	vma->vm_pgoff = 0;
 	vma->vm_private_data = immap;
@@ -570,10 +577,11 @@ static int iommufd_fops_mmap(struct file *filp, struct vm_area_struct *vma)
 				immap->mmio_addr >> PAGE_SHIFT, length,
 				vma->vm_page_prot);
 	if (rc)
-		return rc;
+		goto err_refcount;
+	return 0;
 
-	/* vm_ops.open won't be called for mmap itself. */
-	refcount_inc(&immap->owner->users);
+err_refcount:
+	refcount_dec(&immap->owner->users);
 	return rc;
 }
 

base-commit: 8f5ae30d69d7543eee0d70083daf4de8fe15d585
-- 
2.43.0

