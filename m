Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012027.outbound.protection.outlook.com [40.93.195.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E5D633F8BE;
	Tue,  4 Nov 2025 19:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.27
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762282854; cv=fail; b=LNsCAOqTyRJYPpf72diT+6gHYquqEst5F9cyVF35Z3IIeKLYksoMi3vRlXGaX/XdJH87hhN5rFKCV5IGv1ApJo10/4/unT3g1zbUcZQGHY/aRglDU1TRpjyQ4YzOriem2M/wDZfv5lMF0xm3oZEjRGQmAppqt1fk+CTmBwFRtY4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762282854; c=relaxed/simple;
	bh=FBbHguerJ3pyYOf9ujyNW4/go0kz8MIW4mx4Wx7FXE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pfUuyCcYcHVBl6B1RQIQA6LRmx6AHwjh6xZPNXpi2wXTXfdMRpHnllYe7PrBu8GOk9JNXZBAgBQJyP04Ij6mNI6Bn77eUHHK74SqN3n6DSEoQhyYrHJ4yo0me9Xw+y5JDeOwDUeaFvVvvSABWGPTGOUj8n/e/fYQHWBHAsiAn9w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Rv+f5ZcD; arc=fail smtp.client-ip=40.93.195.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Rv+f5ZcD"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K7UfZqzEUpXpFwzKvGIq2U30BblPIWCB1fXXNeqpLS+DlS3Ftghafm6r0Sx+SbDSS6uxonTU4mNM2BKuP4oqPk6Revlv7AOlbn9S48NBe9Ti5YOB7nWtElUt4bn1rMxpPfx4378xaOx7qVywNDet6BGCLY+8A1+agHB4iF5PjgefhCgp5kkIW5cY9cOdKQwNnxbVSvj5y7RSCLWeTYAF+oPjMp5fOO45ddb0D2xnV3f0CF/ZjTk1lzAQsffND3gPSU5NDKCX3uN45SQBzp/LEesVJkkVWrXAetUahvr4fLRug6Be1I1RNLKM6MlfAr7/ZjPq6sNzxVaPbp6wj3l+RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KuXs5Z09gO7EjFvIxmJX/0ZNROQwA4BsrEnB/jQvolM=;
 b=bSq+WQvaLFwbMCyBgEyIXxYxROuIJNKGwgfCI2OciE4QpPRbv/vU8/aCE+1Lh/8F9GhVn73ux6nNaFHXY12uhfktzRw1gkrVaX/TfudKF2tNr6lVgcJoyIrRMB7Z3Dwsbv0P3nmGYPywQ6aoL9KRhN7Pp82iqIbbM0IT3FNCo1WYzT8gtJZDxc8ZeFa/KNTdd1kkprEGA1zLg1a/SRDKNnIraCBr2Y7QSvTpj7qyq5m1Va4hOYeVVI+6fDcbCb5n62GTAqCsEHEB77EcxVJyHHI1aXqGtjBl+aDpRSH3D3wIzZghEiDyY1eZsTLQ8uhRnpYC20YrdU0sVHUAYkTDUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KuXs5Z09gO7EjFvIxmJX/0ZNROQwA4BsrEnB/jQvolM=;
 b=Rv+f5ZcDzE9/FrTK8w1zW39xjxRiYwW+IblkWpssCLysmxl8Q2XzYUK1nCk5AG7nfj4AkorceG4EKNr0l6z0NvpMnplNglKs5oQYxsx7nqSqaQVHUw5N1mr6v3MfsB4eXT8KBPSjfGkp9B0XXJQ78jTW4CBh4bpzfYiXgSF0iO8gHC8BXN//B8Y6jQ01IQGx6MWvYK05mhwou26HmFPLdv6ms8ieR9Zxk9q6J2QYxzmBWjtcLNTwc6slEQsYhlUC1DPpBpWjZWE0USmqhB5llgcTC7lAktucOIhSOFQOiEf21Yn2SdV/8HgChdICzhJxxm+0ap+5UMmJ72GjReW/Jg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB3613.namprd12.prod.outlook.com (2603:10b6:208:c1::17)
 by MW6PR12MB7071.namprd12.prod.outlook.com (2603:10b6:303:238::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.8; Tue, 4 Nov
 2025 19:00:46 +0000
Received: from MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b]) by MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b%4]) with mapi id 15.20.9298.006; Tue, 4 Nov 2025
 19:00:45 +0000
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
Subject: [PATCH 2/5] iommu/riscv: Disable SADE
Date: Tue,  4 Nov 2025 15:00:41 -0400
Message-ID: <2-v1-d3317b0ee398+50-iommu_pt_riscv_jgg@nvidia.com>
In-Reply-To: <0-v1-d3317b0ee398+50-iommu_pt_riscv_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0076.namprd03.prod.outlook.com
 (2603:10b6:408:fc::21) To MN2PR12MB3613.namprd12.prod.outlook.com
 (2603:10b6:208:c1::17)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB3613:EE_|MW6PR12MB7071:EE_
X-MS-Office365-Filtering-Correlation-Id: cebc3fe0-ed09-4188-8923-08de1bd475bb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Oy9DS4tUQ8k7Yql1odTN1FZGVaEdEg0nNHY2pIW6YbyT7XoyaAFjDvH/hRii?=
 =?us-ascii?Q?wZ/XLErbKwcP39nm66gkijO3nvcxq5e5ybPNPwd4G1NHQ5SuGE9HNkG84bWu?=
 =?us-ascii?Q?J/E3UbY7CRamDO49qzXIhYF0hz0KkenifmBGk5783mVAtbfrNNrHa+JBwbCO?=
 =?us-ascii?Q?7UdHm0roEOCfy2wirFB9KXCyuo5AjIVV2DzMo/0Komxez20KP8pIZY1y8gBY?=
 =?us-ascii?Q?gQt1+oFmW30Evr4J6rKgz5X/dNzx4fFwlgvxocG7PPJKcomcsNK1yHOks14j?=
 =?us-ascii?Q?MPJrUX/FVkJKU2tp4HQvqKd4ru6GbWQbGaJDtFRwx9271JrWzCZte5BLGvlg?=
 =?us-ascii?Q?2t5v2DfZbtB1wWtkosTR2qn4pVSzCmPBQyJ7IWdZ6Z5kgK4EF/4ucgm9Lwcc?=
 =?us-ascii?Q?MYBd7M9ys8JT+3CVg5GPJNFFaGHpTLDDg/gYnND3ViDuOvSD94TGIr2mBWPJ?=
 =?us-ascii?Q?cmeAeOO7vYYuSyAUNZI8lkuAQGgwMxWNgHqy7Sn5UB1scdiwOdDPbT/h1TxE?=
 =?us-ascii?Q?RGzX1eohN99/qR0yMRDp0CFHbGoWbYe3GRi257+p8Rk8f8YNFRiTnuv3bE+V?=
 =?us-ascii?Q?Rth8kHke4hww0lVwCk/1rDU9jB1ABxXtT8Z//YrEAJ5WSp+h2lrLA976uSDa?=
 =?us-ascii?Q?8iyM4pK0v9DnuFrQKLixxwbHzUwdb0YvaG0va+EAIpWCqtXtj7EB+GDVCHiA?=
 =?us-ascii?Q?FBU2NYwj2IHagH1vuFluK36Nf3a6tYe+plqjiEAj1TbuRm6Y8G1xTccocPI3?=
 =?us-ascii?Q?vkq3qIQVeKGg2D+MZ2IBnJAmYEY92KV5yIFYJsS7KYAkzWEcs+KQO1/dOZe1?=
 =?us-ascii?Q?1zj7SWpwFItzpRcYwolCndQLLgk18se05M9CTfc0fGBXoTms/tMAcfoaFuni?=
 =?us-ascii?Q?v15BOtsNGhm8MYqAG4SxM69BkumOMaNcYUZpP72cuQzlBFhaDI95sHs6jzWb?=
 =?us-ascii?Q?D2XYx5Mme6EUfIAZI/fuBbw6mCy/COle7Fqs2qmPMZh5hCFt28lGUDsejtPb?=
 =?us-ascii?Q?AJgJGRf9Ktmf8xji26JmjArU24XoKkZ/T32sEK2095kIHaYQrzfyxQ9WFYHa?=
 =?us-ascii?Q?/+vZgOn5csdjLM2MvJQ4DyGlcvAEDbbZVltMfnRKFchnYfV6AJ01GlTyelVc?=
 =?us-ascii?Q?dxukylWj9W8ADuoyKaio006FPWmca1tS3rw1opUGewLs1BVVtF+dwJuhkSa+?=
 =?us-ascii?Q?PKMacQo/5xupXLN3MgcuGVSkInZlbBx3SPAHVZLYdvx7pxNYMXBY2NjgKTu7?=
 =?us-ascii?Q?7O6hJO0DLvQb1GWOxQutCCZ2gBWFUxUQQke1Bgs19MK6vpijq7hLe4BrKgUu?=
 =?us-ascii?Q?ZMyk8VoUelSN7vkijouk/6A1u4HilbWyUGgO2ZoWd1nMON/0jQ9j/kF9uvZb?=
 =?us-ascii?Q?XexI9H7xhRrYF5O9w7gNsA2t+N9+bpDyyR/IYSD+mm1vyUh0M9zhE2eDfG9u?=
 =?us-ascii?Q?Abl0TOoPpxWDYde8d41IuotiPgScdxENsCy2I6HoGd31UyFR1eYw08zv68/g?=
 =?us-ascii?Q?c/YDm2ZXRuJSwxw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3613.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NCqn51B/RhAmMhtSCqinSgy/vHNVZVk4X0gsiCCrl4wJbJAqd6XoJeYcs/kI?=
 =?us-ascii?Q?DagmjDOTd8EV+xWAnJx4wkjqrqQH0Pcz5sS6ZB6Nkun7b3l0lLTq3UNoqGIM?=
 =?us-ascii?Q?Y1luVkaPgAf1ljLznNDxJASvA73tkoU1W/09xHXyIwXHMjQ0t9M5buTaCT7z?=
 =?us-ascii?Q?JJSqWXHdhGR0VJ7IrZfj/8d6PiM4/R+zXn6cUf2tohwO4CJMqmnScQneaRH+?=
 =?us-ascii?Q?cfyb6S1jvVMpM73NfTFHH74w4iGIRLQipTHsjY0TVhJsMs5R7kf5U5s4tKX4?=
 =?us-ascii?Q?ClzIkiguyk5JGbdizdkRruT012NjtK4EsvkOaMejMx+vtuWCRblVmyhfqlB5?=
 =?us-ascii?Q?6G8gNO6h9c9WmElCNVoK1wrT31uz0x4R81B7mqRDe8Xz+wRS4472MuFRSWDi?=
 =?us-ascii?Q?5EhtQA7new/B4rodqjJ/Gf+AALDy1olTgfmW76jmi1t4WmBfKNzpajRdOC2b?=
 =?us-ascii?Q?rKp3QG3ChxOFpC7E1bU3yXPfPR/0036HeCYyDwh3K5v5Hv3Lefu/jixPZDUS?=
 =?us-ascii?Q?0IRAjNCctkbzNaa5y5deu0VWrSsu7YHO0rKewDcycgCJ3mr16Pg99SuMDm1V?=
 =?us-ascii?Q?EbP73EZa586TyAOf0DD26N/4wV9Lyem17h1wRyDaVTRQ2szzf1a13yxhnlEt?=
 =?us-ascii?Q?9H/bsXuSmI5Iw+Dj4nShbHZMxQm/yn6uy5mZoK0OWvYUDQlZQseVNe9wsnMR?=
 =?us-ascii?Q?BS+KgoFdQWFHUEYuCnfoPtu6HtZeDvbWb/m3Y8d+0tTpzo7jbIen3iOmmyoz?=
 =?us-ascii?Q?vJ51Btfx5twdQfP6jmYBMKCfkD8d5MLPlbbEtcNdhL4j23C++3nj9qHPZsnT?=
 =?us-ascii?Q?X8Ko98ED23d0WYm9Wp/DPdtZK0Q6QCsdy/dB533eOZ7xN/8FaHBmibngiEGT?=
 =?us-ascii?Q?ykrXO4QD7OEdUcyZ9EYkIxR2XlNmnPPt2pkeTFHvPfemI8jo47ChywCZKfn7?=
 =?us-ascii?Q?ER9+HHCt0ZOA096vhHw/SZ5e+6m4s27wLhK/V0qdeMLOVrCBztAxCRZwQ0in?=
 =?us-ascii?Q?wZ7zm9spn6hw1BRQmcoZRLz+ruI7lLwRxjqJVfTaSy3gMAt0LJgLdT73bfeW?=
 =?us-ascii?Q?aRvnK7VwcIdFLwLfjE5I/HmjlxccGYY2Z+E3bWa+9LpAruJqiB+KrMA/pUTH?=
 =?us-ascii?Q?CYeey2cet4s+RQIBEEh/6XgzXIhNuJhXvd3QFp8fPudGFIaPez1GUeMBpd02?=
 =?us-ascii?Q?uE+Tg+s1dMKoLaHWtObAGgfzQD2W2KIMfkj4KvHglEcppEQMNB1jKXfP0QyL?=
 =?us-ascii?Q?n1v9IE+d/n1yEUMVYTHp+/7jof0A0FEaihE9QEGZxpztn54e9XjihSyUAHEW?=
 =?us-ascii?Q?KJ8rm7SzwVICVbpcIIJRp7jt3bGyT8YAynAQB9e6KL3l7mMfya6aUxUJIa5w?=
 =?us-ascii?Q?SXK64J0cVGAtfNj2t4V5GocoRPjRe7yN64hAUv0OEL7OtcAoFkn4iM73rGAH?=
 =?us-ascii?Q?Xn4fLVTcsEUy6vSqFfDZOeeQ2OKmSppaHOgK4c6JcJaOifWfD3QFqWH5evNq?=
 =?us-ascii?Q?UoV6+Z0kSPvlDBeDQm/UlvEAp2SgYUIKYKwrzkXDK0HDJcWsBXdl2fuooO5g?=
 =?us-ascii?Q?fKdnsYN773EeEoCmQ0M=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cebc3fe0-ed09-4188-8923-08de1bd475bb
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3613.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2025 19:00:45.7804
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lNuwrNfjCk7PIbvJaFapp4Ec+dts0XlvXmYR/WFOrpXzDV/Ichi7rgdEPPsgjqKp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB7071

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
index ebb22979075df6..3a29b31d53bbf7 100644
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
 
@@ -1386,7 +1383,6 @@ static struct iommu_domain *riscv_iommu_alloc_paging_domain(struct device *dev)
 	INIT_LIST_HEAD_RCU(&domain->bonds);
 	spin_lock_init(&domain->lock);
 	domain->numa_node = dev_to_node(iommu->dev);
-	domain->amo_enabled = !!(iommu->caps & RISCV_IOMMU_CAPABILITIES_AMO_HWAD);
 	domain->pgd_mode = pgd_mode;
 	domain->pgd_root = iommu_alloc_pages_node_sz(domain->numa_node,
 						     GFP_KERNEL_ACCOUNT, SZ_4K);
@@ -1509,8 +1505,6 @@ static struct iommu_device *riscv_iommu_probe_device(struct device *dev)
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

