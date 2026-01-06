Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010028.outbound.protection.outlook.com [52.101.85.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A35F033D6F0;
	Tue,  6 Jan 2026 15:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767712035; cv=fail; b=mFThsu0HI/87vPyPk8wt45l1ePFfvSxgj4IXvRbwMz05LGkm550N2PCGJfXo1pDjDxUq+ZLtFNrj+HyyAwgcIw8rlvTTCw9waUb9ZelhNo5PH+aUGMwnmMF51eQvGvBr0jCQMaaZmakI357nxLxiomtNJ7+H4dV2bVByYYmqM1M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767712035; c=relaxed/simple;
	bh=ZMFA9CRXgFHPe0+OG3OriFe/y/lp8qmqWJoYomyjiGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LtJAu6QZ3t7T48qMZWCSEcKSL46tsr5JDTrMMHKLyfOZAd2jX/ddrGXjeHrQl/LcUjYjyN9xyOjtJnG9J2Rrus98vEeais/dGlyMgg33zM27URfZHlR4cmlczmyPaZEmiPHL+3UKWd5C3Nm/sTUIWSrrtCUQVvBGyVAVNb3PSLY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=YScdoypF; arc=fail smtp.client-ip=52.101.85.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YScdoypF"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pJbaY5TKbwW9WwVgyvmNmPzozUow8Giq/ynpmOXl3h3Y3QtRGhP+q/9hE40L4ZZMV1UrTLh1JtQyHi4e+RGtXDKw/+Nu50dHONkMZYLDMR6nkhqH6Gn0vnN01jvSX3EDpmfsKpmK9R/nOTkRe76pvhs2cEYs54hvoIY1f2e66KG0BKQxmrm6Q7hY+YVPoaIQfw0mex+MH+tRRL+StV2uEL5kx13juK1KZo4IArZBYzaSZMDiQk8KpeK8NYKM4UltoMHdxwPcyVqqEszWua/kd09IQa5C2qssLR20ixVCv8rCj8A60rfu7ICWx+Z9fsAFIdzCRFo0AXLBZQInK4o8Sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cp9MfGO+V/bZIg8JgQq5tGzSbu5jKDw/msLtUtQPP3s=;
 b=MVcm1w9vZUQCHTWIXRbPpkq7hqiInJFuoSJJn9ME2HvQeq6CzpRw1h29I0mLrbI/1PZ9ZVS9NQ5+onWzkgFbD/pUlIuP83t3UUAShdyzIbA87Hwd0rbtT1AVyOjdLFYg4koonMBgVREm6qrusgIQRdzHLzBZNrTGQsQabCthXZFdsF+Vzzk3MAdeo6T1R9FYXs4FCywV9iaACDub6kOT8p1JXAeDJ2thE2s3HuoJ8c5j74QzMyjOUfdqp36v8K4K/sZyJ6ei8ep0nAbARZG6XsaI2MigHgOqQBjZCWFRZwfbRDX7cigAvz/Fh/nGJnPuzvRiH2XeaDmvio5BhjtAzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cp9MfGO+V/bZIg8JgQq5tGzSbu5jKDw/msLtUtQPP3s=;
 b=YScdoypFfOdDVzGKXd9Eo+UQPXVpEeNQko3SmCI/4ukiIVxD5zNO8C/F75NAS60925dwtcPnIvj0HVyog//lNbvTKk002bSp5CunsEG0h3LHQBSJ9b541N5SX8id3SG2cE0YLBG2z34BNIv12ZwfWrJeX2JJSOGvphbpm52+u2azq5rkmxff7YPx5d8Fy7hI4l89Ok16E7gZcTbJweWq3KcqrhPwk6qdAegJB+8Xsmr1QlyySCtw9zIbPAilLAwqvFJemDhkzHQ37k/cX57ZCTHs35AWCJa4K8hO6lSXNzROURq3IjkdVYNYydoTplwyP/YWEvt49+8taNeBFvSbqQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by IA1PR12MB6434.namprd12.prod.outlook.com (2603:10b6:208:3ae::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Tue, 6 Jan
 2026 15:06:57 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9499.002; Tue, 6 Jan 2026
 15:06:57 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alexandre Ghiti <alex@ghiti.fr>,
	Albert Ou <aou@eecs.berkeley.edu>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-riscv@lists.infradead.org,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Tomasz Jeznach <tjeznach@rivosinc.com>,
	Will Deacon <will@kernel.org>
Cc: lihangjing@bytedance.com,
	Xu Lu <luxu.kernel@bytedance.com>,
	patches@lists.linux.dev,
	xieyongji@bytedance.com
Subject: [PATCH v2 2/5] iommu/riscv: Disable SADE
Date: Tue,  6 Jan 2026 11:06:46 -0400
Message-ID: <2-v2-b11ebca8abb6+c096-iommu_pt_riscv_jgg@nvidia.com>
In-Reply-To: <0-v2-b11ebca8abb6+c096-iommu_pt_riscv_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0072.namprd03.prod.outlook.com
 (2603:10b6:208:329::17) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|IA1PR12MB6434:EE_
X-MS-Office365-Filtering-Correlation-Id: 663a9346-4f62-4105-76fd-08de4d35396e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?nYUdatQQTqVbxGwqTd/X5doxEnPuYr3pCMhCbFa+3R3ATbjBm24lj0FHDEcA?=
 =?us-ascii?Q?OXGD02t6rHkvlPtwVhjn50L53pauDZfFnDCX+DwXhNXTgzY0zqX9UYc6Dp90?=
 =?us-ascii?Q?Ou3ZABubM7rOtTMEmfYw0Ny604PDwFrl47bOJhVhwj/kyqsag3zIYl49SMyi?=
 =?us-ascii?Q?Wmy2lBl2XJrJMuOiOntiJ2tAPvLo0cs3yjUTKTo/Ai4DqDVdSitTd7OEQZNB?=
 =?us-ascii?Q?AYaGxmnYPAkCuFxn/N//v4ksgfTeL7tdLAdIoHItQU4Zpk5hy1fGw+iKhYni?=
 =?us-ascii?Q?Ti0Ugk0KHZXq5HAQN4yxm82vDhIRiSw+l96I1Al0UH9A9TRq1TjR9B39Yoty?=
 =?us-ascii?Q?CPkfgyyTatwgKF0NmyaYaL6iOcF4z7Ka0uqYnyTC6YMb6TVKrPWSC7i5zk55?=
 =?us-ascii?Q?SOLx70RXix3MIWUIxny35Aqmb9ze0CqxXfZMP1XFVl8X4SDrXQFF+93w2fyF?=
 =?us-ascii?Q?7bfjfFCmqw5xH6V59ta6nPrDZspYIVCQ84dwhoeEaNLW98gGgNzM3whDko3H?=
 =?us-ascii?Q?lhTUDjlIa0iehfXrxT5pACIiAxQ6r2prhJzmuAH1AwPjF5PE+xvRel/03ZXK?=
 =?us-ascii?Q?yhbUbyeld9jleHo+b6f4wH86466Q6a/PtLae5o5MYK6exPH8BPUS+7/8a/bn?=
 =?us-ascii?Q?LVOk70MYWIaTTZfHo8ZPLf/rXpaPw839VVB0Lls9Dk+6NwLobokYbpaYX6rR?=
 =?us-ascii?Q?vkyaWaBXbDn3iue5hRHDu72qMAPTWSTjFfZpyLIP2PL1zpg4ZO+CRupSSLac?=
 =?us-ascii?Q?Jdt8iw7MDs+dmO9Z6fnhSVHzvlZrHTrO9ooKPyr3Bk8cwGUR7SKjEEhp3fO8?=
 =?us-ascii?Q?+ZVRxbUmT/JnWjxIW6mTNKfbhYE7Nww/L75zcmGz/mOAQKbFm/7X8FwiRAL6?=
 =?us-ascii?Q?MGKDpjDruzN1o5LMlj2BLhoekMByx/KJt4SxdoHXp1WTcrCuKdeaVbX1F9UY?=
 =?us-ascii?Q?fUEj0/KVeOatOo1Ib9j3UBLno1Q1feljsmDyL3pOs/wJ49hhvrSGCvitn9UB?=
 =?us-ascii?Q?1++K23OXFY2BWhQumkYAYP8v21Vk5zDdsYy/Hyeb00jITiJRhXfBNTCkCDxi?=
 =?us-ascii?Q?ku7OZp+57Ql7DpJQO8JqgX9Amr0+5TwIn6n/Rg7uhmrmoqFJDOntOpr4Mg8s?=
 =?us-ascii?Q?+e6OIZLK6xj3UnleohEpZjUfdan5UOOhmhTPV/0hcPcfu35FQHacCJKuj47C?=
 =?us-ascii?Q?g7sunwcDY6No3Ah3Uey8GLEz78Uuiwa9b0oyk4tGFaHQAN4/BJk/uNrbgCUE?=
 =?us-ascii?Q?Ag8iPgpxZi8p0ClUkmN9sM3Ons3ybqkXTYFPVVIDdtOccc72cmVOyzfm8jSp?=
 =?us-ascii?Q?4Yqp0092rqqDIU2tajglf/3a+ic7cMkyqgbdUCODh4DTqZAZhIKriPyW5r8u?=
 =?us-ascii?Q?jQaR3uAfkHh2QhLIlx1Yx+M6sL1GFoSczdj+xj6MAvaix44+oy5M23pGbo2l?=
 =?us-ascii?Q?jO3Md9uDhs3qJafUf3WWuvrfWMsEQiPpjy/07y+5AwQFReN3tCzh2Pg3gEl6?=
 =?us-ascii?Q?30Z0RufkQ22KrhI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qE5GUbRPZ9im19Y/Fzz4qbdjaUay//SG2CRJUoChxg2oiI9C4u2hJKXoncDG?=
 =?us-ascii?Q?lghDYxRYtlDOqBCtjIIKOAYrarGQROjK1x3GatErnnzKlVHwXVDprcI0rLOz?=
 =?us-ascii?Q?XwIpz1r3RQFGLwG94JoZnmdLJ0A4E9lxg77R4pthTpLolFvz75M/HgQBs/xy?=
 =?us-ascii?Q?5M88FezWNuX5sKIsjB4FGAUsstt3J4nPK91lbO8aSsFHIVaauI7hAWMY2+6S?=
 =?us-ascii?Q?0eqBkloEe2FjwEHGQuQic302UAhYL9BU0YsAxvPtoj1CzgLLqh4J+0E47qZx?=
 =?us-ascii?Q?ewaYPwF+8zbPiTDuHDqs6U9vO/kuGqbzA1kZAIu3xtX9iR4y92QmebRCiwRK?=
 =?us-ascii?Q?EuFzvn+jr5mwn6YYwUW2OLRVcv9VHPta1fX75yQPEebz70YpPPYYNlQsEBnc?=
 =?us-ascii?Q?UnJYNLW9cfe9bsDHWzKgAedZgOkoW5ToIz/ZDx+Cr5ZNn3QAG/CqtfsFtZD7?=
 =?us-ascii?Q?Z99xTvExxKMbEQgEKZqP5lNuvRBgLcjn0j+HSztkCo2HNbU9ZJxha3qcfaUL?=
 =?us-ascii?Q?GvHioNn+sBTIt/rRDdftqAglSrQSAOyfFGTsGnpk9wykDgKkvEhmdkrP1gg2?=
 =?us-ascii?Q?2ms83fi3dw2mlCQUXu0CBg0Sm/5H3RfAaiHpn8/mr25svT0aT/jqJ9Ec0j7f?=
 =?us-ascii?Q?huVUv2HjK9hbIBv25PMIEBmTyZHwNHAwW1XLpDAy+CCtknYWBR10O8q90HCz?=
 =?us-ascii?Q?v/S9Ccg39wzx9Vo5RTdz6IIuwrAMRSJpofod0G69oMfny5zwyQIpI0TtRJHi?=
 =?us-ascii?Q?KQ87dTlFgwv+8BXdGQu1w37VF4a52R+K+Db7FebKypI50l+o1gsQc/xLeWJ3?=
 =?us-ascii?Q?+Gvxf9NqJIt50wJq3pAZvd+aOit4ICwm1p4AlzVbvlzZwoFI+fLbnWL0jAi6?=
 =?us-ascii?Q?f9fieYGylkCm4ibl2GctUfeVDXiELsQlH2To2/RUCOuuHKzWPbLxUPs8qZum?=
 =?us-ascii?Q?UWMr62Q+f/wLhBQ9hRC/FvZNGxP/RD8rrj3tllmnMBYAnlyuHik4Af2Ctehu?=
 =?us-ascii?Q?yCQQJpvIn5b69OpCD4Ka0/UrEvAksiDcc6CCId3/M30rc+0CsBdZetAZkw+Z?=
 =?us-ascii?Q?kunsMSJnG49v81NnMyJST5JBgL1eXDTToWIaWte+G44vw9x6+rOM7+5djZ1y?=
 =?us-ascii?Q?ha2o+iRVneJqmtaIyUhsJri9Vt869GLyYy6rR9DpVhvlo5Zsrdif9sgeuenM?=
 =?us-ascii?Q?MMZ92MNWswaflKRyFBbXas26b6zm//7pPxCsxtdtsVzk4b44A48CFUA4oTry?=
 =?us-ascii?Q?KHdJpD6DJTdsg+6o53JHmfggOgYL45YA/ulCWk01rV+k7uOgCV6nyxAR/ROK?=
 =?us-ascii?Q?Eh0GnEInt2xfIaJQi5OkFzeMnyrsMmcDCDC50Zx+RX8XP+2/kenGok+pvQWc?=
 =?us-ascii?Q?Ysjg1O1UNtYXDS8hsvv2v8vTp2QWgCcv+jBTsyFGa7YcAQQSEZKgNJ8GSZ25?=
 =?us-ascii?Q?Z6DWhoeFY+KGOL2+B95iFHOL3ThxzhVLWaTLN7dGAU2jS+hwTpGnoMkNx9X/?=
 =?us-ascii?Q?21bhHg48zPRVYIFcQ73mfvbQVMF5DHmcaMMyjE8KI3agwf00j6YypjDUS/du?=
 =?us-ascii?Q?fp36XNJZqG1Puu+cIDyHMuOY+bny0ZZGT8pAtqnqSHuLrDB5AdS70M1QflaX?=
 =?us-ascii?Q?txgkEM4HHLMYlqCLdtOlxoZAGKCR/cVLUWJziUeqKV2kGBaDM1o46dP432RF?=
 =?us-ascii?Q?pAU+duXhV4l5IjYFIgrmCTIPQ2ldrsmuqDRHab1X5IIXiZsYdd53r9gtCxj+?=
 =?us-ascii?Q?GcGNnsIhCQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 663a9346-4f62-4105-76fd-08de4d35396e
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2026 15:06:52.9047
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6KBloeQU0MFIuyXslrs0cD+1r+ZzNGSTKA/Dm4sbg5WqOVaLoIGcmHv5g3lyuNd/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6434

In terms of the iommu subystem the SADE/GADE feature "3.4. IOMMU updating
of PTE accessed (A) and dirty (D) updates" is called dirty tracking.

There is no reason to enable HW support for this, and the HW cost
associated with it, unless dirty tracking is actually enabled through
iommufd. It should be a dynamic feature linked to user request.

Further, without implementing the read dirty ops the whole thing is
pointless.

Do not set DC.tc.SADE just because the HW has support for dirty tracking.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/riscv/iommu.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/iommu/riscv/iommu.c b/drivers/iommu/riscv/iommu.c
index d9429097a2b51b..f57a5b457076e0 100644
--- a/drivers/iommu/riscv/iommu.c
+++ b/drivers/iommu/riscv/iommu.c
@@ -810,7 +810,6 @@ struct riscv_iommu_domain {
 	struct list_head bonds;
 	spinlock_t lock;		/* protect bonds list updates. */
 	int pscid;
-	bool amo_enabled;
 	int numa_node;
 	unsigned int pgd_mode;
 	unsigned long *pgd_root;
@@ -1201,8 +1200,6 @@ static int riscv_iommu_map_pages(struct iommu_domain *iommu_domain,
 
 	if (!(prot & IOMMU_WRITE))
 		pte_prot = _PAGE_BASE | _PAGE_READ;
-	else if (domain->amo_enabled)
-		pte_prot = _PAGE_BASE | _PAGE_READ | _PAGE_WRITE;
 	else
 		pte_prot = _PAGE_BASE | _PAGE_READ | _PAGE_WRITE | _PAGE_DIRTY;
 
@@ -1387,7 +1384,6 @@ static struct iommu_domain *riscv_iommu_alloc_paging_domain(struct device *dev)
 	INIT_LIST_HEAD_RCU(&domain->bonds);
 	spin_lock_init(&domain->lock);
 	domain->numa_node = dev_to_node(iommu->dev);
-	domain->amo_enabled = !!(iommu->caps & RISCV_IOMMU_CAPABILITIES_AMO_HWAD);
 	domain->pgd_mode = pgd_mode;
 	domain->pgd_root = iommu_alloc_pages_node_sz(domain->numa_node,
 						     GFP_KERNEL_ACCOUNT, SZ_4K);
@@ -1512,8 +1508,6 @@ static struct iommu_device *riscv_iommu_probe_device(struct device *dev)
 	 * the device directory. Do not mark the context valid yet.
 	 */
 	tc = 0;
-	if (iommu->caps & RISCV_IOMMU_CAPABILITIES_AMO_HWAD)
-		tc |= RISCV_IOMMU_DC_TC_SADE;
 	for (i = 0; i < fwspec->num_ids; i++) {
 		dc = riscv_iommu_get_dc(iommu, fwspec->ids[i]);
 		if (!dc) {
-- 
2.43.0

