Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2070.outbound.protection.outlook.com [40.107.220.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EEA832C88;
	Fri,  2 Feb 2024 14:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706884095; cv=fail; b=W4ST6oNDTjZHOO6hK0eGRSPP3qQDjbHEnh6XrbzkDoJiB6c1jjE8jH58yMhV6sdhf4IALRmtiab0TG+ZQfM9Qxm3xhZgy2Q8rJhD5FR7rrzQz7O7AUaDGklVsScMoxDUPZge7EMZsm4vLKLpv640tQ6JQhiMekfSFJ7bdg4uJ2o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706884095; c=relaxed/simple;
	bh=xTHAwz9vXCe92OKeJq311EkzBpwU2/jIBO/Aj1SjjGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=UrIS4AsT6b4nzDxeGFUBeFxKQa2qWVXBn86qGh5fG0BcOdQClN4AzPW7rs4bovpOLHcJkVHiA4U50b4Xdce2stA6UfwDJD+dsz/NFY+IAPS3pw3WC9CFX5fdPQgu2bfXA9+v0WGy65lLIy+loVb/aWjrda4hFCjD7QwjpI7JMNY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=b99+KSud; arc=fail smtp.client-ip=40.107.220.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="b99+KSud"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hls91U731awv+s22U+VcWFzQ0kvYBZasOxhawZ/GF8y7e8G+jOcOdHoOrf7YwX21iB3zJZ3IiN3XOlbK5oemXcGlDRw8UIR1CrAgviHjVgenTzO30vH38kQ1C3SUVTd2ws9cWwOcv32kKhgpaAsf0TOZEoSunlFC9CjgaEc+UwcyEt8uKsHfHtWlNcDH6H9wWU6JniWwMtK+Bn1tfcoarKvEMSmsODQhhSDie7mbVfmArA+khODaGj8asDuTGhEBnG16M8IIpzi4PatHguDBkN1aseo5h6Hx0pWAxOFXcMxkYqR6qZ2expHcipQulEaOBtHHsoUxVeuzc65PrjuOlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9tEiWVNix5QPD8o/uAciPd/x08YdygzlMmzj0RLKG6Y=;
 b=Z7dL/jFm0haByFXhp7UBTW9zeGTAGMOJd4uZcYEXKifDrmncIAlsFCs39zoJxIJUmb25PE8y+ZaEMhrHGLa1bQDcZpCOZGmmUhvBknMxFBiAr2F4D0OFI9n8UQnXJgNZCQttaSG9UZgpb6ufbwtoBSQG5wSSN33b6s6q7DHLPnyeCGPuR6s9ris7VeB4vSZSakSWgtkRFMBp/m07/wm8eDvC3K81PHocxJjJdRTBB6OP+aKBFWGFE0MI9LWPK1jzP5tlYiGkUE0fid04ZHknLhkkidL2b0XFxRvcmz3YiazjJ9hoqCTeFecY4IxDN2tDGHDBapf0LD0Nua7tkJ31WQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9tEiWVNix5QPD8o/uAciPd/x08YdygzlMmzj0RLKG6Y=;
 b=b99+KSudBxQufmyiUFufk3zGUKxfCqbZovYM6vvgcXOGxn3jhuBBJuXAZQu85hHMUxZcdiPGN+hT4Q7DTsDJTfLYO+xSNreG7S7odaEelXn//yHm/LxOnqR8hendGIRDriTVVGEVmLVMYtkIyXIC8DLl5W3O0cOL0x9sX6nF/mdd1CfPlngzUj/dEPz8MWgHLKK7KB+gWqm+F1D/ubMNaDHbhh6t+ArmNcP1kVhRb2mH7miU9ZSl6mjB6wOKVqd568542p5q0MucKwar/FeGdondUAysVginXue+ScFvWJxWX5WLTVizG7btkcURYST/Fu2OD/bsxLa4zIuCbAeS2g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MW3PR12MB4524.namprd12.prod.outlook.com (2603:10b6:303:2d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.11; Fri, 2 Feb
 2024 14:28:06 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7228.029; Fri, 2 Feb 2024
 14:28:06 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Will Deacon <will@kernel.org>
Subject: [PATCH rc] iommu/arm-smmu-v3: Do not use GFP_KERNEL under as spinlock
Date: Fri,  2 Feb 2024 10:28:05 -0400
Message-ID: <0-v1-210234560de7+69a-smmu_cd_atomic_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0069.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::14) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MW3PR12MB4524:EE_
X-MS-Office365-Filtering-Correlation-Id: aa4154a6-9451-44c3-e4c4-08dc23fb2c24
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Mj6eCr+fgvV9g77AWshNhrvakL/XP45f99iDBNnujBxtgFkls39akidrTMiNJShKsGM4MIouhafEVvC9sP/VRY3RKNPHy5KiwiCI9J5ARzzrIPXJVKl8WGb9h7UNWPL3AZz7cYniZ85F52avl36NF8oiy22xVytRedPEr4Xw/gTkXe6l34bmCFENda/ci227MH7ZzCGq2O1w8ZMKyoxcHS39OLwWNdTt9hd3apaI5SOSJH9P/6Fsph78tKczlOwSowjFo6aKLqVYoDhE5OUcHmwgWNVYM2OfDTxX3/qgcRUNTSk1j1R2jTHi7BndflYcT8rVpssyKNM0RqxGAFYlck3ndYuTB33WCfksYMHIk+ROJWRPdugFeXYQf41c30YOsSyO3kfNqkzqSyiD5wqcJDNlPDGM3X2ayNTzM8GTQRe0nZGyh/+3kS/Qs6JeoodZz37zgllRN1852T/bSVNRad11apj6ItsSKAeVrtiRz+9kcQVbjtITFUCk6dU4ZqIyhoqLPc/k3S980rWQY6/WlsHNvE99Uc0SVsCB0zBu7AlTl/7iVt/Y7tqruUEB9KDiV+sWMXu5ws8cytMYuA88e30ZinAYvtwH4+hXLxLBlzC5ZSBp6CM1aU+NaiJVzp5U0oAddyuK1GlfZnUuJdzgspYCNQdYQYBdnlPdf4XlZFlq1v+00of6jlQt9DAUJEC5qa0Y8DaNIjsSoBrGERUlrQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(366004)(396003)(136003)(39860400002)(230173577357003)(230922051799003)(230273577357003)(186009)(1800799012)(64100799003)(451199024)(2906002)(478600001)(5660300002)(83380400001)(66476007)(6512007)(8936002)(66946007)(66556008)(316002)(8676002)(110136005)(36756003)(54906003)(966005)(4326008)(6486002)(86362001)(6506007)(2616005)(41300700001)(26005)(38100700002)(4216001)(473944003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HtVkQDBabuEV4d48pPsOKc/r4Le52VoO0F6o50VX78ZzbCYo0QG1/PXzW4F3?=
 =?us-ascii?Q?ZS8MAty7DmzKn4Vngj4hSBdw+iEJ4RivSOcEWu6IQjqD2ueAuqrVjdNGnLwo?=
 =?us-ascii?Q?PMwBqvI8N5WK9NwzE0ek/lxVPMYY8QVUrjoE8uPXGaZTT1g4SNUk/AK26En7?=
 =?us-ascii?Q?uwHZIROa54dOcqu0tNqG/WqjO0DVBUGxmNkh1Jhl8Ar/c2aDSBj93/SXOoI/?=
 =?us-ascii?Q?Ox3fMZKq0E7VWh/fO+xPyCRrxJjnb95j1Gi90ilkthYvz9UpWowxdJOG0G6W?=
 =?us-ascii?Q?lC9TfuppQE5dJ0Sb++11Hy2Py33aFskll6Kwao7zGBIuyEoLLEoiNrY8bKTZ?=
 =?us-ascii?Q?cnyjaG9EM+LTTJI3mFWGsUkE7dHS+hJJj5PixA+gU+lhFJnmsBGlu2AGax4j?=
 =?us-ascii?Q?bZW9ArreByndwAxXDo8I7D67wDTDmtmntTBzxzEN3L/2TV6WbkPX9AKOG7TZ?=
 =?us-ascii?Q?LHc+tG3LY7arKgm9sSdTu1+sDFCmhpQxf3WD1b7qpFWs1DOhq5MuaF6mdOHo?=
 =?us-ascii?Q?6c/6qtWdTtDP+rlLnO0t5e2qIdprsAoJdrYpSM/ROc4TG1sr3eM5+ByC2Nxj?=
 =?us-ascii?Q?wR0Cip2XGt0QkJmorTxW/M6wqFN1imzB35AzXzf3W280CjbkGlGLU1CnFHqC?=
 =?us-ascii?Q?qYs+b588gkKCL3SKb4TwNiSNQIY3mnWALYaH/EVlyfREKNfqyzHRs9ub1HtK?=
 =?us-ascii?Q?/88xQ2Ea7vrmMjwa+6x/GxmIVFg4xDHjFHt94ndolMO0RZQ+duH++fDC9DWS?=
 =?us-ascii?Q?IVbnYYdnmvUUQi4CcKjBHcYQEQRRxfKuvEoHPCfFmEBqtNAcNQSpEzfKfIrm?=
 =?us-ascii?Q?Ou/gsZ8RvPZXzs5rrQKcLTZQXi3F4HekRUH5W4ejfd9UcMsT0LqQJIfYxJDl?=
 =?us-ascii?Q?8io+4VwzITnxkAmfMIoXAxD4me5e0MlJzDZRvRZQBx/P8r1TXvD2wOK5+Qnl?=
 =?us-ascii?Q?Gp1CSBjYiONZUxGVA6rvw+aJgq4QvL4PvC8ecY/3uQNY8x+qi5RIE1e0ahsb?=
 =?us-ascii?Q?/9+MHUGEdKNuFi9PPVAHx62gWY9knUWzRYEfK6iH6fFrJxALM11LqL73sw4c?=
 =?us-ascii?Q?CmummFpXeZlkt09ePQXiE3M+aZtBIeYWKHqcitzkTrghcwGjQyU1AKN2oLVt?=
 =?us-ascii?Q?TUDACrI4IgKa85HZprgExf5VwH+b1CDGLqtu0l0oD2BYNd8LwEzslWMH3llg?=
 =?us-ascii?Q?6HvCboAdZzByCdXndADANvdDvnN9O6Q3RKtS3i1L8UAzJZKGZfS/fIh4krYB?=
 =?us-ascii?Q?p1uPVOaX1dMGDs0qHB6d0462uJ+Jlsji3KFXaLfh+LUhEm6GIXlt/7uRTbbE?=
 =?us-ascii?Q?Uk1sIkfwV9VHmjV8tfJx2f41wXM/6TJV85lywOUd6TvYi1XeQWKKGkaRNWpR?=
 =?us-ascii?Q?WdQpknatOm8rbsqEMXTafCtH7bjk7y+hf6LJ9uig8Y9uQCQMRftXc6gWlFo8?=
 =?us-ascii?Q?CK+lLT5cV/WzLAQYwrJofdIxXGNXF3bkwfmVg6CFWdNlIWqx/IJT42aVFU6R?=
 =?us-ascii?Q?GXKvytd8LnqmCGjuK38CsGSmg5mCAoQnje9Dz8RNhv/aZkeVU1jLCJPL19qQ?=
 =?us-ascii?Q?4z3kUtNu/ZBzKx0vocs=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa4154a6-9451-44c3-e4c4-08dc23fb2c24
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2024 14:28:06.5680
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NQKwJMeARC/Row0c/ZMYdNvUr5y2H6sC0k9wWTWhqqIsI6YBgoZk1WnXaipDU8b/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4524

If the SMMU is configured to use a two level CD table then
arm_smmu_write_ctx_desc() allocates a CD table leaf internally using
GFP_KERNEL. Due to recent changes this is being done under a spinlock to
iterate over the device list - thus it will trigger a sleeping while
atomic warning:

  arm_smmu_sva_set_dev_pasid()
    mutex_lock(&sva_lock);
    __arm_smmu_sva_bind()
     arm_smmu_mmu_notifier_get()
      spin_lock_irqsave()
      arm_smmu_write_ctx_desc()
	arm_smmu_get_cd_ptr()
         arm_smmu_alloc_cd_leaf_table()
	  dmam_alloc_coherent(GFP_KERNEL)

This is a 64K high order allocation and really should not be done
atomically.

The proper answer is to sequence CD programming in a way that does not
require the device list or a spinlock. Part two of my lager series does
this and already solves this bug.

In the mean time we can solve the functional issue by preallocating the CD
entry outside any locking. CD leafs are effectively never freed so this
guarantees the arm_smmu_write_ctx_desc() inside the lock will not take the
allocation path.

Fixes: 24503148c545 ("iommu/arm-smmu-v3: Refactor write_ctx_desc")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/all/4e25d161-0cf8-4050-9aa3-dfa21cd63e56@moroto.mountain/
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c | 5 +++++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c     | 2 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h     | 2 ++
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 05722121f00e70..068d60732e6481 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -588,6 +588,11 @@ static int arm_smmu_sva_set_dev_pasid(struct iommu_domain *domain,
 {
 	int ret = 0;
 	struct mm_struct *mm = domain->mm;
+	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
+
+	/* Preallocate the required leafs outside locks */
+	if (!arm_smmu_get_cd_ptr(master, id))
+		return -ENOMEM;
 
 	mutex_lock(&sva_lock);
 	ret = __arm_smmu_sva_bind(dev, mm);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 0ffb1cf17e0b2e..ec2bb8685bb50e 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1019,7 +1019,7 @@ static void arm_smmu_write_cd_l1_desc(__le64 *dst,
 	WRITE_ONCE(*dst, cpu_to_le64(val));
 }
 
-static __le64 *arm_smmu_get_cd_ptr(struct arm_smmu_master *master, u32 ssid)
+__le64 *arm_smmu_get_cd_ptr(struct arm_smmu_master *master, u32 ssid)
 {
 	__le64 *l1ptr;
 	unsigned int idx;
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 65fb388d51734d..fa0eeb3519ef28 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -748,6 +748,8 @@ extern struct xarray arm_smmu_asid_xa;
 extern struct mutex arm_smmu_asid_lock;
 extern struct arm_smmu_ctx_desc quiet_cd;
 
+__le64 *arm_smmu_get_cd_ptr(struct arm_smmu_master *master, u32 ssid);
+
 int arm_smmu_write_ctx_desc(struct arm_smmu_master *smmu_master, int ssid,
 			    struct arm_smmu_ctx_desc *cd);
 void arm_smmu_tlb_inv_asid(struct arm_smmu_device *smmu, u16 asid);

base-commit: c76c50cd425e574df5a071cd7e1805d0764aabff
-- 
2.43.0

