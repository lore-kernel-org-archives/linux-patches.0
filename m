Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013019.outbound.protection.outlook.com [40.107.201.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B223E43C053;
	Fri, 27 Feb 2026 15:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772205953; cv=fail; b=u1ATtf7tpkHNf4AyXXVjKdnr0yg9UfjlBLOcDGUoGa5wHbJJJ+/hagpbufCOWtKhqKTJ34ZEa22vt7DtnJU3jUI5UuMZ1dy6RU9jkXQR4if9uCoMlAeQmjt5i1w2iXGKMAzzYSvftwEc2GoeG0zT9O04tAOZvUK/fuWuX2kDG+Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772205953; c=relaxed/simple;
	bh=W//oKs1bKDFISqzCarPVXb+nNl7g+WlaL6QhiK0d0zA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UwPWAfrIXoDjQBBrfJI9iWGEXsuM8mNzgMhBvCy2VoqhgZ9Zjwiug9hWA1kv8mP3TRFlZ0l3FQllXIyr6bCY/Q+P1cRho72TgZmDd1eFd0dHuScDqcSdUOR7mveTL15ylUwUT/sEz3zv6Ya7d1iTezkWsVLvP/At/wzMdfdrawQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Qj6ivrSl; arc=fail smtp.client-ip=40.107.201.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Qj6ivrSl"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NpFIPrIN8ZJl7iRTXk8MxTcHmkrPvkUMHXpV+wBdpLS1sgpA9HXL9ygzG+79J+aYYVSeUzzf4mdtm6dH1YXJjs0LQN3WRdC385tS+YcnRXObqmDESKIEyWm4IcJkmJ6wks0F1QPukyKPMm5iVyTF8N81Zeu/6Bi2fkiuMZnURZLqiKzvYQ6N9qozSu0NeAlDI+8UMwR050fmidCAcvI12nxeyFVdr9lKw2XRW4M4k8PLf+Wq5Of5L4X55/t2v85FS657Vqi3QQ6oLP8x6seOAjwAmwrJebzmv4BgCR1xdWW7qNP9zWeAw2qs+/HNJjsWY7ParTYmUL8T9orQ8ymG7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V7JzGAs0REpXH3rIS7voE2bb0ysSVs9/LaVMI0LtKlk=;
 b=QBR34Q0Sw2EFBVL9o3H9rtOZdtZgTrQx3PSl5Pw0RIkvwTR0Vef/+njyWgJo7sTQ6erZNf8GZpD9dD4wkwzhLkVQIE1c/XkZ03UX/ReU2Qf8tJrEolPkTqS7rkSduMxVW9GCh38Uew7Kuj57QcXwT9vbw+G1UZSQFPf6mrOtL3oU8RG16QBFAdjgzDDPeCh0aWXtKhUKMoDON3JFy7h1EMxilKPbtt9nxn+OW++b9UQQNuzA2lLIi1y+7tthc1NWApiarvxg5jgba2FNK5+Kbek92eHchuDEfB38eQMiC0d3s3UBCbfcg2z4PhvdltI+wIZJlmXBAcS+JDxfIKclcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V7JzGAs0REpXH3rIS7voE2bb0ysSVs9/LaVMI0LtKlk=;
 b=Qj6ivrSlH4iughmWudAHFGYI/9S3DD+btCCKM/ctidNOmFjUHXGH77ykxLH9zALCMc8iwBteGsaPD4TJx4LdUJ4HRPZW9UHhH+yfCahykW7o54HiBTeqBQSZNxPGQel1E+9it0KY8K/Deh5wDcwLQ3qZeO7OtpTMDaWILHtbKKLLJ02wSnuiRYhPUOzeD0toJbSYYY074d1hwLeeyKnRGQkSZThu8sZnxuuJyRdFEuUXoLaZ8x5yPPd7RnY8mGVp2nYxS0uVl8KJ809gnU4CdXBVtRyFH63qgVqr4RajXl+/U+R15iJL0xUW2Am20vy+Wb2KxnH6xvVJKIxJwZuhfA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CY5PR12MB6156.namprd12.prod.outlook.com (2603:10b6:930:24::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.16; Fri, 27 Feb
 2026 15:25:42 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9654.014; Fri, 27 Feb 2026
 15:25:42 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alexandre Ghiti <alex@ghiti.fr>,
	Albert Ou <aou@eecs.berkeley.edu>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-riscv@lists.infradead.org,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Andrew Jones <ajones@ventanamicro.com>,
	Joerg Roedel <jroedel@suse.de>,
	lihangjing@bytedance.com,
	Xu Lu <luxu.kernel@bytedance.com>,
	patches@lists.linux.dev,
	Tomasz Jeznach <tjeznach@rivosinc.com>,
	Vincent Chen <vincent.chen@sifive.com>,
	xieyongji@bytedance.com
Subject: [PATCH v4 2/6] iommu/riscv: Disable SADE
Date: Fri, 27 Feb 2026 11:25:37 -0400
Message-ID: <2-v4-5a9ca1a9b7a5+5f2-iommu_pt_riscv_jgg@nvidia.com>
In-Reply-To: <0-v4-5a9ca1a9b7a5+5f2-iommu_pt_riscv_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR08CA0011.namprd08.prod.outlook.com
 (2603:10b6:208:239::16) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CY5PR12MB6156:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e960ec4-5812-4630-6fb8-08de7614780e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	s/Q/CVvfbBvOuUfxhVqcBSb8TVjVc0r6+U9zoJSOGtlKtGLgK3yryx8m2Qwpejyt8qL4HcL3ggA9FxY+8cb6kvctyVkzEuT3ABqCDXwcRz3NeNlNgGsvvCHdaMbsVroxcwMqyBaidlbS87uXmseeINdzX8CLz68kRpbTHOBfy/nhl02k7c4yrEZsjIlXLoxHT8OgLowbaVc0OXIUpRmkmt3SviSJe5RNo+lUB95v8ZS4uGKjx1a60eevDgyEIfARDlBtodtRROCUQa2wtzaQIzeACblJcejwMwqTx2rFoU+O4ThojCYVu52sD85tbxdwEDgwQzPmcdIh4zI8TkVnWc5PkAPWjqlR3tXCRutoPDZsE6f3pc86sCPWnZUB8yEnIzPPALREA50nfac13oLZCrBITenXfm2D5JKHe827ryForYZUUWEjOwJx/blrWQnLQbGXZ73phHGg9YyjDDRaw1kM/tyA1LGOJ1PpueWD2RLFjDOYo37BgDwzK+KQQg2mAjzRzzUFEEwsOe79oBMqJDvxI5pKx7loO60H37fT9yKdG6WtpuGl3LBYGz6CXeVfxw5pKw6ItRQxE4j9TqpPk9fefyO1GZOgpPFxRVO1Sd3yWAs5dNwA2vtT4A2MNNnkHBiMnfznTWN0UsO9Yk57SgPYvfU7Qwym0EhLRmVEp/oXc6fQyjE1D0cA/mnL41ehJ8M0HT9EdRqxiFf13UBUhZLmSuhP0ZBrI1MspVRXFVw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?48F+xLxl5A4ZoXighFEU5z98l/ZnzRXoimBSu3Nh5EWdIn2M9ogEzqXy+YY0?=
 =?us-ascii?Q?XbY1Drmc8FCBzEKEratrreZjo2nWQIXeJF04DSzH5U3su+vQSXG/7R8nt7Ik?=
 =?us-ascii?Q?lzsNmr7t01w+oY6oQSMlJhrmTvj61BgCvnf0OAqy5S1mlpbbHv3HSxRPIqRf?=
 =?us-ascii?Q?bfogrWfwwQsJvp8p8wjUJKTn+FO5NuJWCV/k7pAmFQGD7/wVtUGtR3LeyOlT?=
 =?us-ascii?Q?8Bpp6wmqLKon49mIZ4iQbr4NUUPFiO0pNTyTHn0QdDncTFHyuKOH3fRBG/XF?=
 =?us-ascii?Q?z1J+TFKZmslmNrOLbw66LkVfMwrerD588+tRDQs2TxOotA4Hojhv8fAwPEz4?=
 =?us-ascii?Q?fNHzMvSw5eQR1eWK9ryEw+qKaXZNCLl1gZB9mh7abtgrSPAlN7Yse1H5a0De?=
 =?us-ascii?Q?S2IrRhUNTuXYg7QKnZdxA7v+h5rAdOBmEY1nZU3JZDPvOOUSHp9w4AiIawmB?=
 =?us-ascii?Q?zAJUTb3NJffShFuNVOvefL8ZFtzErd6+Hf45QqcBf3rctVQSKbB6yPSqt+uS?=
 =?us-ascii?Q?hH9j0QSjPulJGNC/W2WwbA70Cprzi2BroSXvMe5g1g4IUSFNv+pEjAMGPB6p?=
 =?us-ascii?Q?XJv/bWy/lfJTgY6Nfnz97SfnmiacNdyctDxUuQcSy0MdiMtz/l0Cb9oWnbXl?=
 =?us-ascii?Q?Hi1MfAIDvPBoT+3W00rEsXDkrrda0+8uu0WgeJD/9Ptn6nWcrOsWuZ9CbxVj?=
 =?us-ascii?Q?a0VxEQia3wX5exlVd8B8GmcLSvPkIAgl/+qQw3s2sLE2qL207sIQHug9aSZZ?=
 =?us-ascii?Q?VUFyx9NF5yVTaUUeq7RJZEA/HxH2b7O/OC5tjcSExND0JMvPob3vAsjKQ70Q?=
 =?us-ascii?Q?K4819qhojKqHvlbzKfm35iioiKr89iWqAr9MHJUh9pdoHJfbuTzmtIrre4XR?=
 =?us-ascii?Q?bha5qo6DBoEG54WtfoUPBzVzWE+VBZzrRjPFqHXv85aSXzKeG+0k4ik3zbrk?=
 =?us-ascii?Q?HNIGtD67wA4UXzkf8LQ3ygy7BCK3qizDnLMOWEDIsFD241HolxxTWKGIJml2?=
 =?us-ascii?Q?Cw505eObXIHYCyXA4be1FiqVjqE0hbi2EW1RA+SEFC+d/vtvUtQDUhRwAmvy?=
 =?us-ascii?Q?goLy/CHVUfpd3Z+m/X+0i9HsThZul683gPG7QNwaw0LeCAeMs/BWmDx0r0Oy?=
 =?us-ascii?Q?VTpA1WoKDgXLNPVlBPrggDxDeFcvrjxCt+KD9gAZTLAUM2suWNwY3Cz7GjgN?=
 =?us-ascii?Q?ThIeMg+X9c+ginAp5khMKHhIrkTNiQ7Y62bRz4cjjIcRXThBPsQrhtDLMfc2?=
 =?us-ascii?Q?ytHFfYh8uUCPOJRu38Y0R3pHSTaQRDDcsFpXnVHd7cVK5vJUsj29vh6JZFRo?=
 =?us-ascii?Q?Hkm9HtlMDxhFqMaLHWrVUnkcvFNoPducmkcOxcArXMzXxflHVgP5nsmSIWgm?=
 =?us-ascii?Q?X5IiqQSnowP/w8+k7bJXJGo0TyTdiYX1aI+62Z2e+qXVdGIaWwp6/sxsYmOY?=
 =?us-ascii?Q?FP+5Rs79qS5v4ptbwO/y+Y7P2r7wa5fLMU2k2BfYWDmx+zBB6cm6TTcCwOjA?=
 =?us-ascii?Q?71fHao1QhumaTS5bSYKFZ2mJuykdYqIBC8VlYbKthohdbDGl+oCPaj0PHefy?=
 =?us-ascii?Q?b3gbgR7Iqx6eOmNGj7BU0GpWNNc3YFjWiLASwn6EqcJzLj/4HR3/gJGd/Ous?=
 =?us-ascii?Q?YpllKet2PD0FfgT5euyT5zPd0KVW+i91wukYNvmMB+EozPV2NpCYnq7AEn9f?=
 =?us-ascii?Q?rBpqFV3z/mOitR007kYAj0hHvUolCxiQDVDorRDnN80UtacGndjS7PIv0okf?=
 =?us-ascii?Q?zkmFdUjR+A=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e960ec4-5812-4630-6fb8-08de7614780e
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2026 15:25:42.1068
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Spw47C2hi1NFArJkT89/mIsmfBB47XgCA3kcCLS+fZuQq61um3jfCLooT6c77bFm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6156

In terms of the iommu subystem the SADE/GADE feature "3.4. IOMMU updating
of PTE accessed (A) and dirty (D) updates" is called dirty tracking.

There is no reason to enable HW support for this, and the HW cost
associated with it, unless dirty tracking is actually enabled through
iommufd. It should be a dynamic feature linked to user request.

Further, without implementing the read dirty ops the whole thing is
pointless.

Do not set DC.tc.SADE just because the HW has support for dirty tracking.

Tested-by: Vincent Chen <vincent.chen@sifive.com>
Acked-by: Paul Walmsley <pjw@kernel.org> # arch/riscv
Reviewed-by: Tomasz Jeznach <tjeznach@rivosinc.com>
Tested-by: Tomasz Jeznach <tjeznach@rivosinc.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/riscv/iommu.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/iommu/riscv/iommu.c b/drivers/iommu/riscv/iommu.c
index fa2ebfd2f912e1..0b290337247044 100644
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

