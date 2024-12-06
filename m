Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2041.outbound.protection.outlook.com [40.107.96.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C411B14F90;
	Fri,  6 Dec 2024 00:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733444637; cv=fail; b=M+dHNdgaWwKeOz+hW/FzU9RwtN3rmy7vBdlSpRpXagjVyX75DbwyUl0cLnPPWZ6KfG1QEguH2cOntJcaoII8Gs1UFUKed44LNVVBtBF3p0bX0UfLy4onbtgEVVbDQIxqr04pRa4ZszkTdgLfsMkpSjNdXA5J72CRGK0aTbAl6Vo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733444637; c=relaxed/simple;
	bh=DfoHoBWrfFfuPenph1rENso0DmZGNmwtuDGj0phNpGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=O83qJPJ5ypoe7+dHMzlnV6g+KnH+QfhnnSpzRDu/ZAjqQeb8Si1VwrXC0I2K71GMv3UN9j53eNETKoKT6fZHD9dVJfDxxLGMDH0yKRBIYHoYVtgqGwbT7hNdVjrXCer391cGh6yhi0/Bt4TWE++1T4oMg5ApgoBAQ6rugosypYo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=rhxfqkoR; arc=fail smtp.client-ip=40.107.96.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="rhxfqkoR"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mTOhZ1/vNlkngoQoeFp1S12K+ntvWngMxyY/Z6qqcE/iQ6GH+ht3DrLKAlReR/PIPOxHiqMBiZjZoMYXTocs8wirCAFpY/Kp/DygdPzKprtZb408Vai7rx8SJpXsF+tOFiKn2VMkV5+RZcWA1bsYnAZp0SDv7dCRDvD+aVwkIbQV4RNOqHXV0xje269rO0HWddZNyWfHpDfyaFjBQZm+SniAZX3F/w4LNOza8f3HEuCGqGrS1vAafcsgNw8ejm0tDdQKod1WcskOPCXgKKnqwNNgc+JnSekw9cmjqS2U0PKKhL3Z2fPY0yq8TYQKO9Yq/MHG7MuLXf5YHRl+/VEzfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gGn6DH6X+ALijyDdUm9oppELU7BGYxeFlFmYV1znihc=;
 b=dcELE5TJOTKfn9vLzV0IPay3id6t0opFkj25LAyl/geheIVlLdIPx6RACXeT49PgrKjs90ymYInomckDPkjpApIwdFLs9kVrI+iE/wC3RNWKBN45ZCl5ZnDu59VmiXpXtHCoWPfHNjgwdmsmLYT7qnSITAa7xhkPYcORas+GHLwgJGwy+6iEpgM566O8sBDNGhQdlrw4uNpa7nK7TKHTLyt2oxzJIlloDXlKYJSY1jkSI+/o/Vg9bNglICmkF6SeHLFHTX+gkEQBavX0t8UUPTceUHnaDHb1NSft2qp+Ltvv+rqsmWaMSo+N4eqwr2ZIQLgQBdB0kS+b0i3nYMIWTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gGn6DH6X+ALijyDdUm9oppELU7BGYxeFlFmYV1znihc=;
 b=rhxfqkoRzmjTWufZkPEIq2zS3+1uipw/LefxgkDKK6P/CIM7tZym/2l0ltcTLHObf0zzZAdofNKFKGo9JQUgijCWu4Gk0D5IKUdscFW2GzrvR/k8fdYcRo9RMKcPi4iWf1kSvzMxsLwa7oreo+BLjL6PPka77Y2N5z1uCzerwJZQpbAu7GKWdEVBgYPbjlc74VwyezyO9cQCcJdywQeR4M3fZSYmfIygDG7BEh6Jv6zenFTRDHItx5RNZnIPMsd7usEIPdxSOLRwZt/1+uVLTCAgiwdGtttW47IaRtu1pzxKckipH1AflnAqPNuoQsTgPdkXV7Z2MY8XrwcqKFdKoA==
Received: from BL4PR12MB9480.namprd12.prod.outlook.com (2603:10b6:208:58d::7)
 by DS7PR12MB9525.namprd12.prod.outlook.com (2603:10b6:8:251::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.11; Fri, 6 Dec
 2024 00:23:51 +0000
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by BL4PR12MB9480.namprd12.prod.outlook.com (2603:10b6:208:58d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.10; Fri, 6 Dec
 2024 00:23:46 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%5]) with mapi id 15.20.8230.010; Fri, 6 Dec 2024
 00:23:45 +0000
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
Subject: [PATCH 5/7] iommu/amd: Change amd_iommu_pgtable to use enum protection_domain_mode
Date: Thu,  5 Dec 2024 20:23:40 -0400
Message-ID: <5-v1-cf88773f22d1+39bd-amd_paging_flags_jgg@nvidia.com>
In-Reply-To: <0-v1-cf88773f22d1+39bd-amd_paging_flags_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN8PR07CA0023.namprd07.prod.outlook.com
 (2603:10b6:408:ac::36) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic:
	CH3PR12MB8659:EE_|BL4PR12MB9480:EE_|DS7PR12MB9525:EE_
X-MS-Office365-Filtering-Correlation-Id: 9fdf1c28-417a-439a-a315-08dd158c3e30
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/sbrv8Trn/d0AKPXBwdhQgf2Xqrrl0sR5R1D/lyl+bGHQBWjDNMxRyi3maBP?=
 =?us-ascii?Q?PMNI6qLSV0XBKRKailKXsgSzG1b4hLffyJXTFJUcJdkW3W0hfnHoaxOQaamA?=
 =?us-ascii?Q?r4UVtHGdXoFeL0Sbevyk219gZaNNkg4rUW5had9ME+h3FlLBytTl5Mgk1eFq?=
 =?us-ascii?Q?ZE3EQGpj353kTiab7DVLBF7Ijn/4yPHaTnH6GpY5O0MZjcmuLsJuTV1AtlD6?=
 =?us-ascii?Q?9HDdITdfWtVcyQuyNDtiVznEF0jPU3UXbZhbNBKk5unRiD/SocZNCDBZyKm2?=
 =?us-ascii?Q?mUo4si2G5ufbdDmxKEYEJKyxMBSuxPtE+4IXeV/fGs3ev1l+OlfPFWyOjGZv?=
 =?us-ascii?Q?M0gXjRVgFxxvunZKuq0+PnRemDdS/+8+/YQTDZOFzEeYmI9h1WW3psWSkvMi?=
 =?us-ascii?Q?vF79i5Qq4dnxDJETZGBPDbfH5YNqMjHkPG0v6Uryy+j801OhWjyT0B4RQlNr?=
 =?us-ascii?Q?ydrjyyGhOUY+sV807S2UnWo5uzr2amKc1Bl/f+QyrI3j5HuuUacznHzTyu2W?=
 =?us-ascii?Q?tw5NkMyfXYDWcM0RgPbVHSaiiVPNBclVZTmd7FUTfc0zMPLZ7C4xlEnnMzzH?=
 =?us-ascii?Q?AyqDwxLWzfsL0DDYAo0snpI89QCO9ryEa0FMFnwYwtpHtRjPmyYLUxZKi2TJ?=
 =?us-ascii?Q?fYzwm9YixnAw/rtWFQ2xtIF5sqijJxf/etynxPNnZdoKbN0ipxI0WDp0dRZv?=
 =?us-ascii?Q?1TjBqx1UiCtMsI+5OXJhqWchmIhlVHmE6kufJfcr3H00hwy4VHRqiOwd2cJ4?=
 =?us-ascii?Q?jqDcNM60+1bnONWGuj5IWuaHEe1QrzZrFeJqtnWO+lBjLoixFcAU2GHpMOzg?=
 =?us-ascii?Q?0CeT4rhQkRReeie0QFftVnKgCZS8vkYSEvRLXyOUuZEyU8GN7qK4rFXqiQDr?=
 =?us-ascii?Q?tNp8yyrwLoZzcYukAyW4Lh+QXmSUUZgO+a6ToniWq3j/mor9Q1hEYF+1kXRD?=
 =?us-ascii?Q?koPhPPhqfz3HIKysf9gjreJG9H89fiuL3TfoosNkcon9iPZTycu+jMdHBt93?=
 =?us-ascii?Q?NAdtjSJRfhxHzILYUDdE7DEN6deOCtZ180bxeZV7Xh2FHCwRne4x4HxXyava?=
 =?us-ascii?Q?61VoBQnQKfx6rWaFuPqV1GXk/Dl4p2v/RVuih6Tg00S748Kh7t4y/Lx6YHvt?=
 =?us-ascii?Q?x20BLQ77TgkSci/4KuPZhDbdzwHpFbyIjOsFbFTCPxzHMQ0qpCI02b8TtFPL?=
 =?us-ascii?Q?dNpCFVaYBe07hT2KhmLYupawVrUh5XTYJ9SHeIn6LHtYjL9vxfqi2FKX2XtF?=
 =?us-ascii?Q?VdzO47E6yFB9FqRLwdJ6/AngGoJc7HgVKO1Tf86sQPw/7gjIjgqnbqNNr7Fo?=
 =?us-ascii?Q?I5jqNRGE8kOuUoM9xaVflpPNI61bAwCcIOJDjoVGV6fk/g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR12MB9480.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?X/6J786RpOLOH+9WHeDacMYH6AtZf12ws0IFghPeXBmeRTxQaE2h33xEOTLN?=
 =?us-ascii?Q?j2mYq9KWMuWykXHl4Fn40MO7aIBLI+dZ2QsaDLEEncy8GnqoZK52AFudy5Gc?=
 =?us-ascii?Q?fgJxQisMdvG/n2KGdDESJaY6PbTgw5uyaDr60GOPVKJp/AvlAzToKg00eei9?=
 =?us-ascii?Q?fcI1C2sm9x0gwhb6kXCGGx9H3iCbuRBTSIDxuMKRNwLLQYM1nTJkKhKqWlyP?=
 =?us-ascii?Q?imX0NTdYOmghOpe8oc9TdXrQes2CpwBi9metz85z9lHbFkder9skpQivFmCb?=
 =?us-ascii?Q?C7rbSKqJkDuX/RH1RtU9Ony1MUx1U9eO896iVp1TBs4wuSU6cz9IOwSxZ48M?=
 =?us-ascii?Q?oRFORln4zyzSYwxhk2y7IAeNq4kpxVW1Pr8MExUoroiWN91CAoQ5ibbgVHfg?=
 =?us-ascii?Q?Igkqar/ymxlFaJedCfzYhJO1AHdYjoP823ESNyuLpUBcmzC6SFhHu7hxPPvH?=
 =?us-ascii?Q?ElqdZH9YwnzQxN5242+aybIFvldUQCHMTYt+xnfJ7u/zEJNmGhUPmrJF6TvH?=
 =?us-ascii?Q?APLB46j32JE0+UovlCf/RAkgsK++/JgwLtrCbf4pmiz7riqKXBaet6kEV3Nc?=
 =?us-ascii?Q?ssqzPivy4RINzsenF3V9tBwNOqwtvEAEamLCem4zAGT+c+iB32cowlOjMNbK?=
 =?us-ascii?Q?c7ilRMhPffmGYCnm2pAM/8EDrI2TJ1AjUzJNOV+rfn9kUqAbnFL8ZZjXT23c?=
 =?us-ascii?Q?BAoaxqiybeQKFhn29kBo3Gw+nNCzT7hGs6gdXpFirm95vGa6tfgdNvOAhFWS?=
 =?us-ascii?Q?WUUe00TKx9nwwpztifiL8HtbfoiuWPbHygmRqNAmxKQ6bAOTmtPY62lWlWQc?=
 =?us-ascii?Q?EpCaCFHkZZU3xFauG3+UOvfj/6PrxWTTxDRD8q2ltB9ZarNl1vVqs9XTHHPS?=
 =?us-ascii?Q?UFqV2A39XR70kIJ4RmNfDDenTNbq8O5oF6Ay3rMYwuvtIGHjKo6KmeRppCWk?=
 =?us-ascii?Q?8La7EbAAq93QLl/PmtedrXbG5Ek3uiGWTQHHzdvAteVrrSCjsNdPC7fSEZV/?=
 =?us-ascii?Q?e6GrXHfOHo1lwGZjjtcwUOgriIGNjQmNvyLNoKu90eaWbhPE/ZEOEYiLigy0?=
 =?us-ascii?Q?pqgxnEzDTJaFaRnIYiNikmKlrM460x4ppOA4f2GsvDeDiByNCRb5PnnTo3Cz?=
 =?us-ascii?Q?hfMEFFa4L1Gg7Tke+/7enQQp1OczNGvc4kxrULW/A1ZH6Ooi8TOZaXPgso+/?=
 =?us-ascii?Q?u2TOJ9iN7enOo92jhajBpudpl6VVOwJRxuJPuc9bZMJDv6BJp7si2hIEbd1U?=
 =?us-ascii?Q?2MMWMSjy6ZAoDDYn8Pk2vP+NuJVIiDz6QZrwXJOr/mmuUDCVVA2M0s90ByNe?=
 =?us-ascii?Q?ii9aUs95rQwnc50qbJOE9p69tRuTrzzBEg4McFl3s//U47+DVmaLbAaR+gN8?=
 =?us-ascii?Q?b8c+Nkoc0dqNpFjp0mbkyMrbessRs2KPc3nO2APt39ZfW/pEyQc6ZVv5Wk8e?=
 =?us-ascii?Q?SDUZGNS/gbWpI974I+a012uvF98/o1Frfk+ugnVpL4AhpbklGJeyixE8gXoT?=
 =?us-ascii?Q?QwUV48Dk0ZwJJfpMIuEP/4/3IxfhmZ6+jJNZZUuVHN8njf+5bcC73DiofIp/?=
 =?us-ascii?Q?eOBc2kJhUr8wt8H8MJeHsPaEEkdcwa1reh6HRZJB?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fdf1c28-417a-439a-a315-08dd158c3e30
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2024 00:23:44.1426
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1Fgkq0AL1iQuXHjbusY+bGksYgWPrHNpi8zHUMwe9d2BMT069Y1gkaX9v1d7U+VZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB9525

Currently it uses enum io_pgtable_fmt which is from the io pagetable code
and most of the enum values are invalid. protection_domain_mode is
internal the driver and has the only two valid values.

Fix some signatures and variables to use the right type as well.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/amd_iommu.h |  2 +-
 drivers/iommu/amd/init.c      | 14 +++++++-------
 drivers/iommu/amd/iommu.c     | 34 +++++++++++++++++-----------------
 3 files changed, 25 insertions(+), 25 deletions(-)

Aside from a cleanup getting enums instead of int in the various spots this
helps iommu_pt where it will remove the AMD io_pgtable code and these related
enum values entirely.

diff --git a/drivers/iommu/amd/amd_iommu.h b/drivers/iommu/amd/amd_iommu.h
index 1d384b2c6e28e7..6eb0af2e033907 100644
--- a/drivers/iommu/amd/amd_iommu.h
+++ b/drivers/iommu/amd/amd_iommu.h
@@ -41,7 +41,7 @@ void amd_iommu_disable(void);
 int amd_iommu_reenable(int mode);
 int amd_iommu_enable_faulting(unsigned int cpu);
 extern int amd_iommu_guest_ir;
-extern enum io_pgtable_fmt amd_iommu_pgtable;
+extern enum protection_domain_mode amd_iommu_pgtable;
 extern int amd_iommu_gpt_level;
 extern unsigned long amd_iommu_pgsize_bitmap;
 
diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 0e0a531042acb3..db4b52aae1fcf1 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -152,7 +152,7 @@ struct ivmd_header {
 bool amd_iommu_dump;
 bool amd_iommu_irq_remap __read_mostly;
 
-enum io_pgtable_fmt amd_iommu_pgtable = AMD_IOMMU_V1;
+enum protection_domain_mode amd_iommu_pgtable = PD_MODE_V1;
 /* Guest page table level */
 int amd_iommu_gpt_level = PAGE_MODE_4_LEVEL;
 
@@ -2145,7 +2145,7 @@ static void print_iommu_info(void)
 		if (amd_iommu_xt_mode == IRQ_REMAP_X2APIC_MODE)
 			pr_info("X2APIC enabled\n");
 	}
-	if (amd_iommu_pgtable == AMD_IOMMU_V2) {
+	if (amd_iommu_pgtable == PD_MODE_V2) {
 		pr_info("V2 page table enabled (Paging mode : %d level)\n",
 			amd_iommu_gpt_level);
 	}
@@ -3059,10 +3059,10 @@ static int __init early_amd_iommu_init(void)
 	    FIELD_GET(FEATURE_GATS, amd_iommu_efr) == GUEST_PGTABLE_5_LEVEL)
 		amd_iommu_gpt_level = PAGE_MODE_5_LEVEL;
 
-	if (amd_iommu_pgtable == AMD_IOMMU_V2) {
+	if (amd_iommu_pgtable == PD_MODE_V2) {
 		if (!amd_iommu_v2_pgtbl_supported()) {
 			pr_warn("Cannot enable v2 page table for DMA-API. Fallback to v1.\n");
-			amd_iommu_pgtable = AMD_IOMMU_V1;
+			amd_iommu_pgtable = PD_MODE_V1;
 		}
 	}
 
@@ -3185,7 +3185,7 @@ static void iommu_snp_enable(void)
 		goto disable_snp;
 	}
 
-	if (amd_iommu_pgtable != AMD_IOMMU_V1) {
+	if (amd_iommu_pgtable != PD_MODE_V1) {
 		pr_warn("SNP: IOMMU is configured with V2 page table mode, SNP cannot be supported.\n");
 		goto disable_snp;
 	}
@@ -3464,9 +3464,9 @@ static int __init parse_amd_iommu_options(char *str)
 		} else if (strncmp(str, "force_isolation", 15) == 0) {
 			amd_iommu_force_isolation = true;
 		} else if (strncmp(str, "pgtbl_v1", 8) == 0) {
-			amd_iommu_pgtable = AMD_IOMMU_V1;
+			amd_iommu_pgtable = PD_MODE_V1;
 		} else if (strncmp(str, "pgtbl_v2", 8) == 0) {
-			amd_iommu_pgtable = AMD_IOMMU_V2;
+			amd_iommu_pgtable = PD_MODE_V2;
 		} else if (strncmp(str, "irtcachedis", 11) == 0) {
 			amd_iommu_irtcachedis = true;
 		} else if (strncmp(str, "nohugepages", 11) == 0) {
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 081a5dbe7ba7bb..e0c12dc44340cd 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2297,32 +2297,30 @@ struct protection_domain *protection_domain_alloc(int nid)
 	return domain;
 }
 
-static int pdom_setup_pgtable(struct protection_domain *domain, int pgtable)
+static int pdom_setup_pgtable(struct protection_domain *domain)
 {
 	struct io_pgtable_ops *pgtbl_ops;
+	enum io_pgtable_fmt fmt;
 
-	switch (pgtable) {
-	case AMD_IOMMU_V1:
-		domain->pd_mode = PD_MODE_V1;
+	switch (domain->pd_mode) {
+	case PD_MODE_V1:
+		fmt = AMD_IOMMU_V1;
 		break;
-	case AMD_IOMMU_V2:
-		domain->pd_mode = PD_MODE_V2;
+	case PD_MODE_V2:
+		fmt = AMD_IOMMU_V2;
 		break;
-	default:
-		return -EINVAL;
 	}
 
-	pgtbl_ops =
-		alloc_io_pgtable_ops(pgtable, &domain->iop.pgtbl.cfg, domain);
+	pgtbl_ops = alloc_io_pgtable_ops(fmt, &domain->iop.pgtbl.cfg, domain);
 	if (!pgtbl_ops)
 		return -ENOMEM;
 
 	return 0;
 }
 
-static inline u64 dma_max_address(int pgtable)
+static inline u64 dma_max_address(enum protection_domain_mode pgtable)
 {
-	if (pgtable == AMD_IOMMU_V1)
+	if (pgtable == PD_MODE_V1)
 		return ~0ULL;
 
 	/* V2 with 4/5 level page table */
@@ -2334,8 +2332,9 @@ static bool amd_iommu_hd_support(struct amd_iommu *iommu)
 	return iommu && (iommu->features & FEATURE_HDSUP);
 }
 
-static struct iommu_domain *do_iommu_domain_alloc(struct device *dev, u32 flags,
-						  int pgtable)
+static struct iommu_domain *
+do_iommu_domain_alloc(struct device *dev, u32 flags,
+		      enum protection_domain_mode pgtable)
 {
 	bool dirty_tracking = flags & IOMMU_HWPT_ALLOC_DIRTY_TRACKING;
 	struct amd_iommu *iommu = get_amd_iommu_from_dev(dev);
@@ -2346,7 +2345,8 @@ static struct iommu_domain *do_iommu_domain_alloc(struct device *dev, u32 flags,
 	if (!domain)
 		return ERR_PTR(-ENOMEM);
 
-	ret = pdom_setup_pgtable(domain, pgtable);
+	domain->pd_mode = pgtable;
+	ret = pdom_setup_pgtable(domain);
 	if (ret) {
 		pdom_id_free(domain->id);
 		kfree(domain);
@@ -2384,13 +2384,13 @@ amd_iommu_domain_alloc_paging_flags(struct device *dev, u32 flags,
 		if (!amd_iommu_pasid_supported())
 			return ERR_PTR(-EOPNOTSUPP);
 
-		return do_iommu_domain_alloc(dev, flags, AMD_IOMMU_V2);
+		return do_iommu_domain_alloc(dev, flags, PD_MODE_V2);
 	}
 
 	/* Allocate domain with v1 page table for dirty tracking */
 	if (flags & IOMMU_HWPT_ALLOC_DIRTY_TRACKING) {
 		if (amd_iommu_hd_support(iommu))
-			return do_iommu_domain_alloc(dev, flags, AMD_IOMMU_V1);
+			return do_iommu_domain_alloc(dev, flags, PD_MODE_V1);
 
 		return ERR_PTR(-EOPNOTSUPP);
 	}
-- 
2.43.0

