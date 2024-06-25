Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2050.outbound.protection.outlook.com [40.107.102.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE8C415884A;
	Tue, 25 Jun 2024 12:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719319079; cv=fail; b=t8Le4N3pso3cp2BEbwQA7Bd2VXk3LIChX985sXP7sGBBS9T9ECtcptsDgasnjcEyyyfSu/O9xuvjZfWYQeqTbEqzj2vUNpyAniF04XBqdAqx0OVCtZBTXu/5h/1ApLjzpzN0v7xfFxpuxZVKVTVgO/Gogt4PjoIJCCakxLyLODM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719319079; c=relaxed/simple;
	bh=CqZC9NM40+0rh/JKRgKVncaAbJttnYOaLUoa6sK6YKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IWfvB2IJ8rXAeMsK37gXDZ5VY7rbGkMliCvq1i3XoUdcN5ILJUyj8Fa2RKFyBdQT9DdHhZlJd79QMPBiSTVJbws/1gxbohhhsco7WpAmAdTOcEmuTxBYj5ys7HL7QKzKU2RkeVcnEH8KwnkQrT9FRbxkZqNax3CJCpsOZfq1jag=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=m3PKLgik; arc=fail smtp.client-ip=40.107.102.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="m3PKLgik"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fOMo4Ai391D3dmrbqOS0dsBmiSpsDf7YCiru5Wc1knjOz1vOTIdF+ISARb9Hje7WZE8sExpSGWuBja+cRQt/4Lh5d4jIGxiJfHmizgRZ/nkMTB9Qb3Q6jn4neE0JzsmKFzReWukevjBqtkpCUnB+9/5gXgGx13qdUqA97H28DcUo96IkapNjyhcp80ZY3GnHQM/ZtSinnsKdRQSZQiWQce/Tuq4N5rKDIzJqry37FT6xGwIxyZO//etMXeJH0U6qwsCC07vXfZO6gZxm9ucEuowbiIDDJXNYJAnFseJSotO+JQavgNbE/TGlWrDW6PrksG6g4e16Hlul9ch1wb3eBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vAZRBExWVoCMcRTBP9kntNfJ4lB3ba61O3KaTvFm1Vw=;
 b=dJKvhioSK3ej69RXStZ8IHElkSmKnHVFdgpphmXQEdIRVwvyZkR3KFsNijB0ITYTDyRuLhH1h5eSKkwv1AOq7QBbPWgR2dxLAcuxRMFKxrkSllaTKb61jXoBNmqzzy4hVU/CaN+/+n+gtwdYYiiPt6+zcgWyXhB/+A8swt47w8182NeizX+xoYbCpVTp/iSfFdmxixx/woBbx+O2OfAhue4ciWYWuM1kR/jTX+oWC0jmBlHLyzcMfBxstPfCI/merKYbUYzpQB9S1bYcJbU7V6IBg4qU9IUnWKC5IYWMv+XFrMYHBOsez8Ogo56XmwHRshK+MIOGAEnoC6ApXmXIRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vAZRBExWVoCMcRTBP9kntNfJ4lB3ba61O3KaTvFm1Vw=;
 b=m3PKLgikar4xn7BCqrR2ibK7EmljhLdksH9K/tkBeh5YfRgYYYpISchYf9PrSYgxenaIm+5fLUIghiB6mfsGSehd+vQHHNa+MRdUpleHJfUC/EBl0fEQnonj+W1bYAL0la/JqcBF8Ml5vbzPxlFjni9DW7neRxcSgEkV1SsD5hLsCtvN1iEOKq8YlGzxz5cnOa6i9BhI0CY9SM9hoRfNtgOEWQjk5xzDrx2l3/K/tveoBvjD2JtBVb8Zb8Fiqh1gf3e9GPnUHzsPr0BnS3zToudW+H7q+cCJtC77EBHbdVaCb3X7K1NbdM9KynWcMRTD8IDMsbCaR+Gx/gXYrmmD3g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by SA1PR12MB8946.namprd12.prod.outlook.com (2603:10b6:806:375::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.26; Tue, 25 Jun
 2024 12:37:48 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%6]) with mapi id 15.20.7698.025; Tue, 25 Jun 2024
 12:37:48 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Jerry Snitselaar <jsnitsel@redhat.com>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH v9 04/14] iommu/arm-smmu-v3: Make changing domains be hitless for ATS
Date: Tue, 25 Jun 2024 09:37:35 -0300
Message-ID: <4-v9-5cd718286059+79186-smmuv3_newapi_p2b_jgg@nvidia.com>
In-Reply-To: <0-v9-5cd718286059+79186-smmuv3_newapi_p2b_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR08CA0029.namprd08.prod.outlook.com
 (2603:10b6:208:239::34) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|SA1PR12MB8946:EE_
X-MS-Office365-Filtering-Correlation-Id: 1bd8d07d-01a2-406d-b7f6-08dc95139dc8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|7416011|366013|1800799021|376011;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?JovNhJ/PFM7pzJf8RANSMqTNhf8RJM1CelivFZ56+oxcxDZeHfKfuv3i1hxH?=
 =?us-ascii?Q?OWCbl+d7ZA6glelYI/04JaYlXDzItlaGLihkM4mOy9ZTqNrtMS+p9Lz0g9xw?=
 =?us-ascii?Q?NIYgiPRi3gWc/wmxeej5Bkt7XhR440oFHSDbiUfarJFOM9yCDt2BHKDqvCnY?=
 =?us-ascii?Q?ZfhR/8MnNaWCD2mQ/OyDz0lWbrfnyaX5/BuxSOMRZ0AI3gw6CPuHEdOSEYoZ?=
 =?us-ascii?Q?O7RacCRkluYIIfP/WmgmgGq3YrVjPJoAEDU3eIF6/+y04Wxbfn78k62zK9Ux?=
 =?us-ascii?Q?jMXB1d4c6K6IbtsY0ZabCxtR1AEt1LoNSukJ2P/7XSdIH04hHl8KExQlfF6p?=
 =?us-ascii?Q?rT+0UZ+Cg9RJgQhf6JD0EL7fIOVVsBC7xVv7XwKz0ktLE0Fy8oqrnSh8ieWt?=
 =?us-ascii?Q?qnvjYQq+uFKKZEoJtaGb6MnyMHXWCLoSCjJGg8uliT+Sv2DDxxGCeEnYRAvl?=
 =?us-ascii?Q?09AgoNyAE6Pw4/xUtLHoRs0Kt8VJ70lTseAuhs/uYk94JCCQTeCHxCoTCD+v?=
 =?us-ascii?Q?RJPO4BLx/JGPECTJSdqyoyuHSCyPRXz1yWnxb9mvPHcp3v/8GoHlYwrlklFz?=
 =?us-ascii?Q?rjnOELe14Nu1df6eMweiKzy3yBmGFPj7hJivo6YcIL0v1hz/1/ELBh79Xu9O?=
 =?us-ascii?Q?iyLu1rVL/tf+oYxDSmk729AM6uTAGHTpNUqJp7LcuDxghhls3vfh3g9OUE9Q?=
 =?us-ascii?Q?Qq4z3o6G0Pc5q3tJYIyXDY1DmdF6erbTx3Z5S5lXFtP4qrIetrQYpFANHIuK?=
 =?us-ascii?Q?uq1/Dd6Zwjgbm10x020bsU+EK2WigFU8TbMJsvDMTw4mFGV3LYZoAfRDiONq?=
 =?us-ascii?Q?0ny6AFdsbz67DgbCTYDtrJdgiMZQ+Kw3gPLutnxjP0hvt3/5T5FjnYaMwBzX?=
 =?us-ascii?Q?kD+kKqG6mL5a5cJ9bLhlEmTUQw7BVPfnAjJ6tEH77cUQdLLLvabTh+jyJuvM?=
 =?us-ascii?Q?rHsPb+uvwxUFfY1YgsBjUYZIHfaxjavzBt0f4B2uFtJmuQSMHH/Um4e/uZ3S?=
 =?us-ascii?Q?iPsEGzwTEAfeDLtq0RcRwTRGn4cUrOqI17laYst4vWAVMIPGdzREzzD4V2us?=
 =?us-ascii?Q?4EcoSRbocQ034Yc2g0iQK1SNTpRfUe5L5IQI5VIJYxyK7/WPUi0YbHnFG/0a?=
 =?us-ascii?Q?PB83ePC5DSdteKEF4joTcC33iq4MM/nmECmMk6qkhkCdfNOdd/7jWCqKkz9i?=
 =?us-ascii?Q?s/+I0WP+JEa+WLXZNba3Kkskgke6VZXnMw1F14gAqOADQxvhEmwOB6GKtHbX?=
 =?us-ascii?Q?8KgkVYWiOQFhdfdzMsMjuwuna9v0TvvZELXl16D8/DlqJR+ellZ0dL3wHEOw?=
 =?us-ascii?Q?Igo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(7416011)(366013)(1800799021)(376011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Tp0SKVMNbP+O+z4qr+kHn0CmvTi0Z92jLDNhbolOt60U0n9XCGEzDofskHcy?=
 =?us-ascii?Q?nGVzL3ObLboj/HZOHX1ZkcZs6K1eoLkdEPpimFQLTc0UWnRf2SL1km4d4M0T?=
 =?us-ascii?Q?mjwDHwRvH0PBjNlJTnGZaqWcobimsdxecV18KJhTJ4b5ECng13BhEDdKppnd?=
 =?us-ascii?Q?xq5NJVLt6Aj48Rh+siF/t0sAuH65+4mxU2uuDvKg8rXeXPIRAY93yucakw/S?=
 =?us-ascii?Q?ygbQZp8bAnVkE+L2XGSLvOEr2C5zUlcnF6bUbW7Nhr7gElr6yT1cIoF7TIoy?=
 =?us-ascii?Q?W9CfezlgBEyqRY600oZ442klcQIwirvFlojIdJDd90mb31Cx/q/8xFdetjkT?=
 =?us-ascii?Q?s97V/XfQX6zhWxUEJoOr/OPvOoRkwVBtRqSDhE36SGGxhU+kx4bvzQ8g6Tjd?=
 =?us-ascii?Q?f/hGRYR/NKsX1OEUOIZjIgDUBgNR1BGFOFsY945lwFxxU07Nbs2LSNaEj1Kp?=
 =?us-ascii?Q?lyGUz6+EgAA5/m/BgA+CM16vNC/0g/aIk9F9WIeGOg1PSVfh6nyf6iqCWZDC?=
 =?us-ascii?Q?tdyFxDskQKtEBDb8pB8xs9A3SudZQ/WBx2JBP8uVqd2D10NxKoUFJsztKH5i?=
 =?us-ascii?Q?C7PX8CjmRVIV41hLFlgfqzwmteJiXcuMobWrHcuTZi05ZjPznIesf5Im0EFs?=
 =?us-ascii?Q?3AvujgxJmKSU26iGQAKtY1cri6fViKgvTheG7ny31tKTExiFoHSF7uefRr4V?=
 =?us-ascii?Q?F1uDPSvwsZh4/bg0KTzlWGf+e+FXS2/s08FU5by6u2yUgCbNgUVKEFdTgxue?=
 =?us-ascii?Q?l9WAF3S6e5zAN8dDawnJ0kZCWjyz6QXM0YR6PmGqZWriAlY07f5416KbS5G7?=
 =?us-ascii?Q?2cWLWuWdRUTMca1PDJF+hVYiS7kcTa3ces8qiusnG8goLkLG9dVLRR3pb/3Y?=
 =?us-ascii?Q?A5Z/LXiIR1g9FRD2xrgoqI8wdndE/hB2S2RAqqGnh3zpsFDIRc4Yz3fxpSRl?=
 =?us-ascii?Q?kOCtEzKJE9D4JWQXHquo7eciAJMugryjH6BCYMwPdEseXCgva0GTH09t8RMt?=
 =?us-ascii?Q?siZvMe4YB+yb/ORNFmSfaIusISPcfXXy/lsHd3m0QPsp8/MAT2R7FZZNlL4a?=
 =?us-ascii?Q?oCzNsxDzpeDgcwKO5Ac4LoZeoooyWaZdzIhKe/JkgkJ2eRB2YFeyIM6KbcpS?=
 =?us-ascii?Q?imLoXuQNcf+G9okzFxurghS3E0iV5I/gKVSRmXHoU23ubCVFqWjJDtEsY0Iq?=
 =?us-ascii?Q?O236EJAnv8tdmveWAY5PZt81cmAWN38Q51GMdOaAfdBYqoMJSsgFeR2bhvV7?=
 =?us-ascii?Q?QpI2LrwhkOaDfxoa5lbH0o5mIzzOhZQ21XY9dzHpA3JX8ysUHMZUBHEYAO1O?=
 =?us-ascii?Q?u2uyOCLxTD8+Sueh7tuCv8GJwd5kOVPxw3shII13Psnnjq5vlamvP/XhlLdp?=
 =?us-ascii?Q?MMYPF7GEXHeJInicQmw2w6GuhcUUJZ/IF6i0wzgGhen1VvAM1C7MYEabeDW3?=
 =?us-ascii?Q?0bP8x6VfkZw71Ww5z07MABjHVl3E7URurEIgfqsmw2rDQYQFa0j8ueC2Ul8e?=
 =?us-ascii?Q?8bZfITnmMdPWlF7sowELWUZqr20+CToGfIzXdEHBRkKPbWvB4leyVoxNAQbr?=
 =?us-ascii?Q?G2DpUmM5D/EXJ3ZZFd/3yY9ygVRSFw7Ysv4US579?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bd8d07d-01a2-406d-b7f6-08dc95139dc8
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2024 12:37:46.5566
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yysZfC0ySogr1sSEtx2gvuLJYaieLMu196H4a91K9mNG4BSdquh1iVcJ0GtRvmZG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8946

The core code allows the domain to be changed on the fly without a forced
stop in BLOCKED/IDENTITY. In this flow the driver should just continually
maintain the ATS with no change while the STE is updated.

ATS relies on a linked list smmu_domain->devices to keep track of which
masters have the domain programmed, but this list is also used by
arm_smmu_share_asid(), unrelated to ats.

Create two new functions to encapsulate this combined logic:
 arm_smmu_attach_prepare()
 <caller generates and sets the STE>
 arm_smmu_attach_commit()

The two functions can sequence both enabling ATS and disabling across
the STE store. Have every update of the STE use this sequence.

Installing a S1/S2 domain always enables the ATS if the PCIe device
supports it.

The enable flow is now ordered differently to allow it to be hitless:

 1) Add the master to the new smmu_domain->devices list
 2) Program the STE
 3) Enable ATS at PCIe
 4) Remove the master from the old smmu_domain

This flow ensures that invalidations to either domain will generate an ATC
invalidation to the device while the STE is being switched. Thus we don't
need to turn off the ATS anymore for correctness.

The disable flow is the reverse:
 1) Disable ATS at PCIe
 2) Program the STE
 3) Invalidate the ATC
 4) Remove the master from the old smmu_domain

Move the nr_ats_masters adjustments to be close to the list
manipulations. It is a count of the number of ATS enabled masters
currently in the list. This is stricly before and after the STE/CD are
revised, and done under the list's spin_lock.

This is part of the bigger picture to allow changing the RID domain while
a PASID is in use. If a SVA PASID is relying on ATS to function then
changing the RID domain cannot just temporarily toggle ATS off without
also wrecking the SVA PASID. The new infrastructure here is organized so
that the PASID attach/detach flows will make use of it as well in
following patches.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Michael Shavit <mshavit@google.com>
Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c  |   5 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 237 +++++++++++++-----
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |   6 +-
 3 files changed, 177 insertions(+), 71 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
index 315e487fd990eb..a460b71f585789 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
@@ -164,7 +164,7 @@ static void arm_smmu_test_make_cdtable_ste(struct arm_smmu_ste *ste,
 		.smmu = &smmu,
 	};
 
-	arm_smmu_make_cdtable_ste(ste, &master);
+	arm_smmu_make_cdtable_ste(ste, &master, true);
 }
 
 static void arm_smmu_v3_write_ste_test_bypass_to_abort(struct kunit *test)
@@ -231,7 +231,6 @@ static void arm_smmu_test_make_s2_ste(struct arm_smmu_ste *ste,
 {
 	struct arm_smmu_master master = {
 		.smmu = &smmu,
-		.ats_enabled = ats_enabled,
 	};
 	struct io_pgtable io_pgtable = {};
 	struct arm_smmu_domain smmu_domain = {
@@ -247,7 +246,7 @@ static void arm_smmu_test_make_s2_ste(struct arm_smmu_ste *ste,
 	io_pgtable.cfg.arm_lpae_s2_cfg.vtcr.sl = 3;
 	io_pgtable.cfg.arm_lpae_s2_cfg.vtcr.tsz = 4;
 
-	arm_smmu_make_s2_domain_ste(ste, &master, &smmu_domain);
+	arm_smmu_make_s2_domain_ste(ste, &master, &smmu_domain, ats_enabled);
 }
 
 static void arm_smmu_v3_write_ste_test_s2_to_abort(struct kunit *test)
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 532fe17f28bfe5..d33d97496a03fb 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1538,7 +1538,7 @@ EXPORT_SYMBOL_IF_KUNIT(arm_smmu_make_bypass_ste);
 
 VISIBLE_IF_KUNIT
 void arm_smmu_make_cdtable_ste(struct arm_smmu_ste *target,
-			       struct arm_smmu_master *master)
+			       struct arm_smmu_master *master, bool ats_enabled)
 {
 	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
 	struct arm_smmu_device *smmu = master->smmu;
@@ -1561,7 +1561,7 @@ void arm_smmu_make_cdtable_ste(struct arm_smmu_ste *target,
 			 STRTAB_STE_1_S1STALLD :
 			 0) |
 		FIELD_PREP(STRTAB_STE_1_EATS,
-			   master->ats_enabled ? STRTAB_STE_1_EATS_TRANS : 0));
+			   ats_enabled ? STRTAB_STE_1_EATS_TRANS : 0));
 
 	if (smmu->features & ARM_SMMU_FEAT_E2H) {
 		/*
@@ -1591,7 +1591,8 @@ EXPORT_SYMBOL_IF_KUNIT(arm_smmu_make_cdtable_ste);
 VISIBLE_IF_KUNIT
 void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
 				 struct arm_smmu_master *master,
-				 struct arm_smmu_domain *smmu_domain)
+				 struct arm_smmu_domain *smmu_domain,
+				 bool ats_enabled)
 {
 	struct arm_smmu_s2_cfg *s2_cfg = &smmu_domain->s2_cfg;
 	const struct io_pgtable_cfg *pgtbl_cfg =
@@ -1608,7 +1609,7 @@ void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
 
 	target->data[1] = cpu_to_le64(
 		FIELD_PREP(STRTAB_STE_1_EATS,
-			   master->ats_enabled ? STRTAB_STE_1_EATS_TRANS : 0));
+			   ats_enabled ? STRTAB_STE_1_EATS_TRANS : 0));
 
 	if (smmu->features & ARM_SMMU_FEAT_ATTR_TYPES_OVR)
 		target->data[1] |= cpu_to_le64(FIELD_PREP(STRTAB_STE_1_SHCFG,
@@ -2450,22 +2451,16 @@ static bool arm_smmu_ats_supported(struct arm_smmu_master *master)
 	return dev_is_pci(dev) && pci_ats_supported(to_pci_dev(dev));
 }
 
-static void arm_smmu_enable_ats(struct arm_smmu_master *master,
-				struct arm_smmu_domain *smmu_domain)
+static void arm_smmu_enable_ats(struct arm_smmu_master *master)
 {
 	size_t stu;
 	struct pci_dev *pdev;
 	struct arm_smmu_device *smmu = master->smmu;
 
-	/* Don't enable ATS at the endpoint if it's not enabled in the STE */
-	if (!master->ats_enabled)
-		return;
-
 	/* Smallest Translation Unit: log2 of the smallest supported granule */
 	stu = __ffs(smmu->pgsize_bitmap);
 	pdev = to_pci_dev(master->dev);
 
-	atomic_inc(&smmu_domain->nr_ats_masters);
 	/*
 	 * ATC invalidation of PASID 0 causes the entire ATC to be flushed.
 	 */
@@ -2474,22 +2469,6 @@ static void arm_smmu_enable_ats(struct arm_smmu_master *master,
 		dev_err(master->dev, "Failed to enable ATS (STU %zu)\n", stu);
 }
 
-static void arm_smmu_disable_ats(struct arm_smmu_master *master,
-				 struct arm_smmu_domain *smmu_domain)
-{
-	if (!master->ats_enabled)
-		return;
-
-	pci_disable_ats(to_pci_dev(master->dev));
-	/*
-	 * Ensure ATS is disabled at the endpoint before we issue the
-	 * ATC invalidation via the SMMU.
-	 */
-	wmb();
-	arm_smmu_atc_inv_master(master);
-	atomic_dec(&smmu_domain->nr_ats_masters);
-}
-
 static int arm_smmu_enable_pasid(struct arm_smmu_master *master)
 {
 	int ret;
@@ -2553,46 +2532,181 @@ arm_smmu_find_master_domain(struct arm_smmu_domain *smmu_domain,
 	return NULL;
 }
 
-static void arm_smmu_detach_dev(struct arm_smmu_master *master)
+/*
+ * If the domain uses the smmu_domain->devices list return the arm_smmu_domain
+ * structure, otherwise NULL. These domains track attached devices so they can
+ * issue invalidations.
+ */
+static struct arm_smmu_domain *
+to_smmu_domain_devices(struct iommu_domain *domain)
 {
-	struct iommu_domain *domain = iommu_get_domain_for_dev(master->dev);
+	/* The domain can be NULL only when processing the first attach */
+	if (!domain)
+		return NULL;
+	if (domain->type & __IOMMU_DOMAIN_PAGING)
+		return to_smmu_domain(domain);
+	return NULL;
+}
+
+static void arm_smmu_remove_master_domain(struct arm_smmu_master *master,
+					  struct iommu_domain *domain)
+{
+	struct arm_smmu_domain *smmu_domain = to_smmu_domain_devices(domain);
 	struct arm_smmu_master_domain *master_domain;
-	struct arm_smmu_domain *smmu_domain;
 	unsigned long flags;
 
-	if (!domain || !(domain->type & __IOMMU_DOMAIN_PAGING))
+	if (!smmu_domain)
 		return;
 
-	smmu_domain = to_smmu_domain(domain);
-	arm_smmu_disable_ats(master, smmu_domain);
-
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
 	master_domain = arm_smmu_find_master_domain(smmu_domain, master);
 	if (master_domain) {
 		list_del(&master_domain->devices_elm);
 		kfree(master_domain);
+		if (master->ats_enabled)
+			atomic_dec(&smmu_domain->nr_ats_masters);
 	}
 	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
+}
 
-	master->ats_enabled = false;
+struct arm_smmu_attach_state {
+	/* Inputs */
+	struct iommu_domain *old_domain;
+	struct arm_smmu_master *master;
+	/* Resulting state */
+	bool ats_enabled;
+};
+
+/*
+ * Start the sequence to attach a domain to a master. The sequence contains three
+ * steps:
+ *  arm_smmu_attach_prepare()
+ *  arm_smmu_install_ste_for_dev()
+ *  arm_smmu_attach_commit()
+ *
+ * If prepare succeeds then the sequence must be completed. The STE installed
+ * must set the STE.EATS field according to state.ats_enabled.
+ *
+ * If the device supports ATS then this determines if EATS should be enabled
+ * in the STE, and starts sequencing EATS disable if required.
+ *
+ * The change of the EATS in the STE and the PCI ATS config space is managed by
+ * this sequence to be in the right order so that if PCI ATS is enabled then
+ * STE.ETAS is enabled.
+ *
+ * new_domain can be a non-paging domain. In this case ATS will not be enabled,
+ * and invalidations won't be tracked.
+ */
+static int arm_smmu_attach_prepare(struct arm_smmu_attach_state *state,
+				   struct iommu_domain *new_domain)
+{
+	struct arm_smmu_master *master = state->master;
+	struct arm_smmu_master_domain *master_domain;
+	struct arm_smmu_domain *smmu_domain =
+		to_smmu_domain_devices(new_domain);
+	unsigned long flags;
+
+	/*
+	 * arm_smmu_share_asid() must not see two domains pointing to the same
+	 * arm_smmu_master_domain contents otherwise it could randomly write one
+	 * or the other to the CD.
+	 */
+	lockdep_assert_held(&arm_smmu_asid_lock);
+
+	if (smmu_domain) {
+		/*
+		 * The SMMU does not support enabling ATS with bypass/abort.
+		 * When the STE is in bypass (STE.Config[2:0] == 0b100), ATS
+		 * Translation Requests and Translated transactions are denied
+		 * as though ATS is disabled for the stream (STE.EATS == 0b00),
+		 * causing F_BAD_ATS_TREQ and F_TRANSL_FORBIDDEN events
+		 * (IHI0070Ea 5.2 Stream Table Entry). Thus ATS can only be
+		 * enabled if we have arm_smmu_domain, those always have page
+		 * tables.
+		 */
+		state->ats_enabled = arm_smmu_ats_supported(master);
+
+		master_domain = kzalloc(sizeof(*master_domain), GFP_KERNEL);
+		if (!master_domain)
+			return -ENOMEM;
+		master_domain->master = master;
+
+		/*
+		 * During prepare we want the current smmu_domain and new
+		 * smmu_domain to be in the devices list before we change any
+		 * HW. This ensures that both domains will send ATS
+		 * invalidations to the master until we are done.
+		 *
+		 * It is tempting to make this list only track masters that are
+		 * using ATS, but arm_smmu_share_asid() also uses this to change
+		 * the ASID of a domain, unrelated to ATS.
+		 *
+		 * Notice if we are re-attaching the same domain then the list
+		 * will have two identical entries and commit will remove only
+		 * one of them.
+		 */
+		spin_lock_irqsave(&smmu_domain->devices_lock, flags);
+		if (state->ats_enabled)
+			atomic_inc(&smmu_domain->nr_ats_masters);
+		list_add(&master_domain->devices_elm, &smmu_domain->devices);
+		spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
+	}
+
+	if (!state->ats_enabled && master->ats_enabled) {
+		pci_disable_ats(to_pci_dev(master->dev));
+		/*
+		 * This is probably overkill, but the config write for disabling
+		 * ATS should complete before the STE is configured to generate
+		 * UR to avoid AER noise.
+		 */
+		wmb();
+	}
+	return 0;
+}
+
+/*
+ * Commit is done after the STE/CD are configured with the EATS setting. It
+ * completes synchronizing the PCI device's ATC and finishes manipulating the
+ * smmu_domain->devices list.
+ */
+static void arm_smmu_attach_commit(struct arm_smmu_attach_state *state)
+{
+	struct arm_smmu_master *master = state->master;
+
+	lockdep_assert_held(&arm_smmu_asid_lock);
+
+	if (state->ats_enabled && !master->ats_enabled) {
+		arm_smmu_enable_ats(master);
+	} else if (master->ats_enabled) {
+		/*
+		 * The translation has changed, flush the ATC. At this point the
+		 * SMMU is translating for the new domain and both the old&new
+		 * domain will issue invalidations.
+		 */
+		arm_smmu_atc_inv_master(master);
+	}
+	master->ats_enabled = state->ats_enabled;
+
+	arm_smmu_remove_master_domain(master, state->old_domain);
 }
 
 static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 {
 	int ret = 0;
-	unsigned long flags;
 	struct arm_smmu_ste target;
 	struct iommu_fwspec *fwspec = dev_iommu_fwspec_get(dev);
 	struct arm_smmu_device *smmu;
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
-	struct arm_smmu_master_domain *master_domain;
+	struct arm_smmu_attach_state state = {
+		.old_domain = iommu_get_domain_for_dev(dev),
+	};
 	struct arm_smmu_master *master;
 	struct arm_smmu_cd *cdptr;
 
 	if (!fwspec)
 		return -ENOENT;
 
-	master = dev_iommu_priv_get(dev);
+	state.master = master = dev_iommu_priv_get(dev);
 	smmu = master->smmu;
 
 	/*
@@ -2622,11 +2736,6 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 			return -ENOMEM;
 	}
 
-	master_domain = kzalloc(sizeof(*master_domain), GFP_KERNEL);
-	if (!master_domain)
-		return -ENOMEM;
-	master_domain->master = master;
-
 	/*
 	 * Prevent arm_smmu_share_asid() from trying to change the ASID
 	 * of either the old or new domain while we are working on it.
@@ -2635,13 +2744,11 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	 */
 	mutex_lock(&arm_smmu_asid_lock);
 
-	arm_smmu_detach_dev(master);
-
-	master->ats_enabled = arm_smmu_ats_supported(master);
-
-	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
-	list_add(&master_domain->devices_elm, &smmu_domain->devices);
-	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
+	ret = arm_smmu_attach_prepare(&state, domain);
+	if (ret) {
+		mutex_unlock(&arm_smmu_asid_lock);
+		return ret;
+	}
 
 	switch (smmu_domain->stage) {
 	case ARM_SMMU_DOMAIN_S1: {
@@ -2650,18 +2757,19 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 		arm_smmu_make_s1_cd(&target_cd, master, smmu_domain);
 		arm_smmu_write_cd_entry(master, IOMMU_NO_PASID, cdptr,
 					&target_cd);
-		arm_smmu_make_cdtable_ste(&target, master);
+		arm_smmu_make_cdtable_ste(&target, master, state.ats_enabled);
 		arm_smmu_install_ste_for_dev(master, &target);
 		break;
 	}
 	case ARM_SMMU_DOMAIN_S2:
-		arm_smmu_make_s2_domain_ste(&target, master, smmu_domain);
+		arm_smmu_make_s2_domain_ste(&target, master, smmu_domain,
+					    state.ats_enabled);
 		arm_smmu_install_ste_for_dev(master, &target);
 		arm_smmu_clear_cd(master, IOMMU_NO_PASID);
 		break;
 	}
 
-	arm_smmu_enable_ats(master, smmu_domain);
+	arm_smmu_attach_commit(&state);
 	mutex_unlock(&arm_smmu_asid_lock);
 	return 0;
 }
@@ -2690,10 +2798,14 @@ void arm_smmu_remove_pasid(struct arm_smmu_master *master,
 	arm_smmu_clear_cd(master, pasid);
 }
 
-static int arm_smmu_attach_dev_ste(struct device *dev,
-				   struct arm_smmu_ste *ste)
+static int arm_smmu_attach_dev_ste(struct iommu_domain *domain,
+				   struct device *dev, struct arm_smmu_ste *ste)
 {
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
+	struct arm_smmu_attach_state state = {
+		.master = master,
+		.old_domain = iommu_get_domain_for_dev(dev),
+	};
 
 	if (arm_smmu_master_sva_enabled(master))
 		return -EBUSY;
@@ -2704,16 +2816,9 @@ static int arm_smmu_attach_dev_ste(struct device *dev,
 	 */
 	mutex_lock(&arm_smmu_asid_lock);
 
-	/*
-	 * The SMMU does not support enabling ATS with bypass/abort. When the
-	 * STE is in bypass (STE.Config[2:0] == 0b100), ATS Translation Requests
-	 * and Translated transactions are denied as though ATS is disabled for
-	 * the stream (STE.EATS == 0b00), causing F_BAD_ATS_TREQ and
-	 * F_TRANSL_FORBIDDEN events (IHI0070Ea 5.2 Stream Table Entry).
-	 */
-	arm_smmu_detach_dev(master);
-
+	arm_smmu_attach_prepare(&state, domain);
 	arm_smmu_install_ste_for_dev(master, ste);
+	arm_smmu_attach_commit(&state);
 	mutex_unlock(&arm_smmu_asid_lock);
 
 	/*
@@ -2732,7 +2837,7 @@ static int arm_smmu_attach_dev_identity(struct iommu_domain *domain,
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
 
 	arm_smmu_make_bypass_ste(master->smmu, &ste);
-	return arm_smmu_attach_dev_ste(dev, &ste);
+	return arm_smmu_attach_dev_ste(domain, dev, &ste);
 }
 
 static const struct iommu_domain_ops arm_smmu_identity_ops = {
@@ -2750,7 +2855,7 @@ static int arm_smmu_attach_dev_blocked(struct iommu_domain *domain,
 	struct arm_smmu_ste ste;
 
 	arm_smmu_make_abort_ste(&ste);
-	return arm_smmu_attach_dev_ste(dev, &ste);
+	return arm_smmu_attach_dev_ste(domain, dev, &ste);
 }
 
 static const struct iommu_domain_ops arm_smmu_blocked_ops = {
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 01769b5286a83a..f9b4bfb2e6b723 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -758,10 +758,12 @@ void arm_smmu_make_abort_ste(struct arm_smmu_ste *target);
 void arm_smmu_make_bypass_ste(struct arm_smmu_device *smmu,
 			      struct arm_smmu_ste *target);
 void arm_smmu_make_cdtable_ste(struct arm_smmu_ste *target,
-			       struct arm_smmu_master *master);
+			       struct arm_smmu_master *master,
+			       bool ats_enabled);
 void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
 				 struct arm_smmu_master *master,
-				 struct arm_smmu_domain *smmu_domain);
+				 struct arm_smmu_domain *smmu_domain,
+				 bool ats_enabled);
 void arm_smmu_make_sva_cd(struct arm_smmu_cd *target,
 			  struct arm_smmu_master *master, struct mm_struct *mm,
 			  u16 asid);
-- 
2.45.2

