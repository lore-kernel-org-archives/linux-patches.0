Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010066.outbound.protection.outlook.com [52.101.46.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B582DA74C;
	Fri, 27 Feb 2026 15:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772206029; cv=fail; b=qRa/+OuHVzv6r4Eg76shFqos9zSTyLmuzNHk94vTF1uRMp5moCfCJE1VpIFFu3D1XUc9O3JbSNL9yTRsLXn3clXpGMtFAYNieoSr/thBwo9AaXUOxw2gXXoibWs9JlSRzCxZXI/lNo6y8fx4Xz3/s3t5IwEwV0S6E/nmLxXYlt0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772206029; c=relaxed/simple;
	bh=zU/6H2770twYjCJAUHPi1eZmgSpL08d/+/8kNkpAjpY=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=dnBuNJMNMiv+WPvYV/Ds32AApOFJVL9Uy16NMBpxNdndiQOQmvEfwmY/MwSmI3Ox+SIZTR1J2x4ajY3zOgunhBCkPiaElx5+kfEXwcG+FAt1XzjAOdqPSy9AT9rKzwCl/hlv1Lec2s7pEJOEgqCzQHILgz7/Z4DVniWWFm459RY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Sx9QxXsj; arc=fail smtp.client-ip=52.101.46.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Sx9QxXsj"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gfC51QLu7oTW0Z3x/7/tqcf/IakvaVi/vBaGwQnR8rM4n4IX7PaaleNZNUGq1xro2cRDiW8Sijh0lLE+UVMKpnpIb9Vop6wviLrUEHLFtG5hwRbSVdVQh3Tfpn1YQXg6HluvAzDBw4k+uGEp12Q3lGxnkKWPUy0MxzgpzqIoi8sjRgs2MFVwANBkiBi0fWoAWf1NeBBxgQYd7Bul7tPEEpuBIZ81UcTsyXU0y+SDf5mihPlgw3VC0nB54OKLrJTTvkqlmGU9Yk7rCXELd2g4lLypTbX2iGDz3vczPu8Uy/QuMJeHMGL7fRXBlDkgL42XVKvabsuFh4HlzcGs+sSsRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TUOBJSzI1lt+CZUurN7y6t3W0svAzGxebXjnfTjjPfQ=;
 b=uho0OZU3PGi+54LGi9Omm5ONvvByPbbZ/vfUPSWpqd/F9F4BrMStkVj2k9MtI9imQJiug8VOrNfpEs/FCXLYpjM85echngjONFKmvXohkBJkgUVfgew5zLwu1QpdgHQcig+LJ76KOyMYVKzmvBw95e2YPF+NSNRNenQocB94F8sqpCyczZPb6xqOZjjU1JR2ZeQUvAGeA/Eqd1rdZKQU/3JTH8NO3Ehb9n1k3qfXCk+doKcZ9lfiFlTiyA1l+Ymr9zIP0UpAJltzN0lz3uaBJ8k9R3XhUr1B343O328vyA4WvQVYQfhv0Ju6Q1+Jvroc2oTsWJAqLDBSr6U3icSjgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TUOBJSzI1lt+CZUurN7y6t3W0svAzGxebXjnfTjjPfQ=;
 b=Sx9QxXsj4eYIepg9z+g/STXGbGybfP0dEFOzwnuW04ATqpc/D173HrIXHmXOPhXrdK17c2TmdyARz7lLuI5aI/4i2O4MvexzkEt/FOVgy12fOf/4s8uQM1QM24wJoUINCpb6ewWui2VnOZx05svBeJnucQPtS2RnSjpgmfgsq7kdy1IHYGzw/s415i9HFg6IOqV2UF56yL9eBXGoaWGqR9zc/vg0HvGvs+sgNVOq1Zh/IEQqWT9pOTxKKlR7glB89ESz1qztASeqcH00za15I5Hh+rznTW6/I2nlssKotTU0hdFPX4K5mOmOcmIU8A4CKAqtPBpi0Rut1f8XMi63tA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CY5PR12MB6156.namprd12.prod.outlook.com (2603:10b6:930:24::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.16; Fri, 27 Feb
 2026 15:27:03 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9654.014; Fri, 27 Feb 2026
 15:27:03 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>
Cc: patches@lists.linux.dev,
	Robin Murphy <robin.murphy@arm.com>
Subject: [PATCH] iommupt: Optimize the gather processing for DMA-FQ mode
Date: Fri, 27 Feb 2026 11:27:02 -0400
Message-ID: <0-v1-37d146e56632+ce4-iommupt_no_gaps_fq_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR22CA0006.namprd22.prod.outlook.com
 (2603:10b6:208:238::11) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CY5PR12MB6156:EE_
X-MS-Office365-Filtering-Correlation-Id: 55b96531-4934-4476-8f2c-08de7614a866
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	2p5qhp4mSDIun3xWtAgBG+mMBTS/mAH5T3Y5dH7W5awaUBxjxTKMzwg4ib+COKrXxTjPaUZUKma/RdJoMpxpK+IvPP/CGjy1OfM1lRDQDJKWA027zE3GxtZCUE77Gz0cU58f8bPMCpb8qzVdDM79DjIZT7z/r6zceDQNOkcMlDPKBybUDGbtkkpYb5Mx0f5f7QEdn9AGgu5RMPi8DW6ETxhh88gTfZNiWIfdZYAn9UQ/gNTTB2HpP9FVbKTUhk1A5EtDz5K8kvdCAyi6r3f1fmS6TpLrH0cQJupGOy5pTFx+h4E9NmiL9ROSuk5ifY6iCRq8f5bXKEKxpNVv8zESB+jQVa6Q1evmFgTaYd65lF3X5CHmo/cNC1x3CfE6JxegThME6DQd5tOhlOLd3XW2rIm2XnFdKLHEFkEoG5cyAHEMqlH+yqPhCpJ1Tgfa6AVwDzuhxdvcCxZbjE/hmnZkjtX21hXZzt3HL7RHfjnlYg1+zRRcZ8IZl6TYsSWhXdcU2GQbir7TeUeyzgrpwj7n5Z3ikQexNi9zxwIM2O+Aqy5lgzZ+9rleQC2WRCu+dpv93VZeqZWOAKjo8UO0Ir/T+a0gpgHOAzss/UyfhVaO5mxMNikjcMVfYHva3SQJh9BMXMlwxXZk1hdHnQU//ZHSZb0UM57SKD7x2wdNbJAyU95LSFQ3AS98VWisO832o57I
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OLBGlXtSoA5kknN4mFiiemjODH88xq21xR6UB3VSAVeu5+7kczlc9D4vETT+?=
 =?us-ascii?Q?m2OIvyjWTD9cy09n1ivXYxM9DAHm1J6RWAV5G+ZGBvidvpawV5ac32sUSw2T?=
 =?us-ascii?Q?r3uTdZ+I6ECgzoNNLMK+3Jjo07lQCg84IvKLXTXrZMyyrDfXApiA1WPIeu/+?=
 =?us-ascii?Q?GRiLxNNTsewUD24ngt6jV8uQUgLDHzKmZ0GoLw9n5YWx0iUnk1W5xOJKA+0Y?=
 =?us-ascii?Q?6q3sxp9oegpXCWjQ6fTNIeM9qpBDSUMkEP8ORUIVk9lz/X6azWfs4Z+fnRt3?=
 =?us-ascii?Q?T4wT5Kjd1eC+Hp1KQLdJf/kd84PKWmpgGBBXUrVce6Xn9vYZWSbKiPkxk+nD?=
 =?us-ascii?Q?JTneBJr7EWlhkV+nPOq/Kw6arFsvHvje5HPmF5rv11EnPrIZ8L77unO5HWke?=
 =?us-ascii?Q?kHvVH51DrFzmg2jdrf7hvUt2yP8BowryhtECJofwb7vjGM2cseJ9SfAbrS0F?=
 =?us-ascii?Q?lnR53cKazpuCiQ69ts0EMJXtxLnDqdEoKRQPDQSQlPcWkZGkAviLPpRLqjua?=
 =?us-ascii?Q?C3kEBOZPQG9wecXbPuX3cqJ4F9QfGNUYzmh97omnD8T/K87WRKqp1mUjzuKV?=
 =?us-ascii?Q?lVezmKd9aIx19DArdh/tAaWlrw9WwjTvxPalbrtXad23JjFMqCcn08Dgzahz?=
 =?us-ascii?Q?WUwskXIj7dbDrkmFG+xTlFyJd5xhJnVS22HeZEMo3WiPbHKZv46cTrmtvo+B?=
 =?us-ascii?Q?nAcslMeGiq2JvOKRtD4qhb2ZzYz/jOJ7Kl9wZB1k9sVQ9vyIXMVwV+zhpuUP?=
 =?us-ascii?Q?mHROwCym2BON07NxIaMwdWbQcvXikubiixPVvEpwwdmp8jRwjBB/IcjUNaKU?=
 =?us-ascii?Q?RZTovd/go7PwgwulZAgwVOe/NUx82ZN0su6Vspki3FbI2IiZ5px4UXk297LZ?=
 =?us-ascii?Q?H7YB+cNeqmG5Zqqwg7zlcZTcKUGHlKWpKgDPOr7J3TSIVOEyUj2etNCy8QF2?=
 =?us-ascii?Q?+MmrZJplOfGxx22bcXDreO+rGl1MwJu5atvxsU0ZVHYO9XEfxND7jmb+kUg3?=
 =?us-ascii?Q?+Kg/0GP+u0qLVLIGOtSnoXoPd4LPoN3/q8WCp0cjgLba2zAyOt3ztksFDl9q?=
 =?us-ascii?Q?UAm1uZjzvhwtHM4shrnAcPLlZuWIjQxsi9r2irl1sfY6UveeLmLRl11QaHUp?=
 =?us-ascii?Q?7Ohbndafh+p+2eKZ0+t9s/LmYccSgcm+nbmDIAJk4tKZPNoYA4lk6F6nYO7e?=
 =?us-ascii?Q?YNjZEA+EcMKTZcR+jf/+bYGkbP/qXNS322zxGhB5vsgsdnuPbJ7kO/ihmc4T?=
 =?us-ascii?Q?G+zvs7Lh6pXduMZQevfG9oTaZ/p7ASe5i/wLnme+/Qsd+k4fr+RNJ34myg7A?=
 =?us-ascii?Q?RHLn8uCpEBObMuiNlgk4l8mR3kQhXSbjM2Xx/Amp0ZGEnhcmlp+wt3r6pzu8?=
 =?us-ascii?Q?YRU2ZollPrlSWyMpHZitXgg1mTyB+6YY2qoGy7XUhz0Fq7oDE0iaDc3FnylQ?=
 =?us-ascii?Q?NTNU3Q7SumQJUE+7M1nlozM+wy4SruHCVHEPyoZmRs1xuZVoA5NJsFiVMT54?=
 =?us-ascii?Q?Zyph7HPjUb4nBaAEjVvl/vIdEl6Pp9/BKEwrs3izyryfsRlWxFBLp3yIuZ7s?=
 =?us-ascii?Q?Kaluvc8r1Vs5ax1dc3jM0F7dvhMHAlx0rkImvUNr2w0x0Fxx4ixT0iQB/toK?=
 =?us-ascii?Q?nSQ8cGiNNrvVFPknGhD8vhfHgyr+6zhmViIg8ry4wL9rznolPI/R3BDpJPcl?=
 =?us-ascii?Q?9o5ts6AZGqzbTBC3HTBmZtSk0+pL/qgneBDfFOBMgjueoYVtFEgu0NXfEIzb?=
 =?us-ascii?Q?ZdszRpiEKQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55b96531-4934-4476-8f2c-08de7614a866
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2026 15:27:03.2080
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: drLZp8Y2VEFirYh/3yT6vsdOFA/Z1IYfdYToEgaDKxR4IDOTGyCoQCIsOk+2Zepy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6156

In PT_FEAT_FLUSH_RANGE mode the gather was accumulated but never flushed
and then the accumulated range was discarded by the dma-iommu code in
DMA-FQ mode. This is basically optimal.

However for PT_FEAT_FLUSH_RANGE_NO_GAPS the page table would push flushes
that are redundant with the flush all generated by the DMA-FQ mode.

Disable all range accumulation in the gather, and iommu_pt triggered
flushing when in iommu_iotlb_gather_queued() indicates it is in DMA-FQ
mode.

Reported-by: Robin Murphy <robin.murphy@arm.com>
Closes: https://lore.kernel.org/r/794b6121-b66b-4819-b291-9761ed21cd83@arm.com
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/generic_pt/iommu_pt.h | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/iommu/generic_pt/iommu_pt.h b/drivers/iommu/generic_pt/iommu_pt.h
index 3e33fe64feab22..9c08bb594e4173 100644
--- a/drivers/iommu/generic_pt/iommu_pt.h
+++ b/drivers/iommu/generic_pt/iommu_pt.h
@@ -51,16 +51,27 @@ static void gather_range_pages(struct iommu_iotlb_gather *iotlb_gather,
 		iommu_pages_stop_incoherent_list(free_list,
 						 iommu_table->iommu_device);
 
-	if (pt_feature(common, PT_FEAT_FLUSH_RANGE_NO_GAPS) &&
-	    iommu_iotlb_gather_is_disjoint(iotlb_gather, iova, len)) {
-		iommu_iotlb_sync(&iommu_table->domain, iotlb_gather);
-		/*
-		 * Note that the sync frees the gather's free list, so we must
-		 * not have any pages on that list that are covered by iova/len
-		 */
+	/*
+	 * If running in DMA-FQ mode then the unmap will be followed by an IOTLB
+	 * flush all so we need to optimize by never flushing the IOTLB here.
+	 *
+	 * For NO_GAPS the user gets to pick if flushing all or doing micro
+	 * flushes is better for their work load by choosing DMA vs DMA-FQ
+	 * operation. Drivers should also see shadow_on_flush.
+	 */
+	if (!iommu_iotlb_gather_queued(iotlb_gather)) {
+		if (pt_feature(common, PT_FEAT_FLUSH_RANGE_NO_GAPS) &&
+		    iommu_iotlb_gather_is_disjoint(iotlb_gather, iova, len)) {
+			iommu_iotlb_sync(&iommu_table->domain, iotlb_gather);
+			/*
+			 * Note that the sync frees the gather's free list, so
+			 * we must not have any pages on that list that are
+			 * covered by iova/len
+			 */
+		}
+		iommu_iotlb_gather_add_range(iotlb_gather, iova, len);
 	}
 
-	iommu_iotlb_gather_add_range(iotlb_gather, iova, len);
 	iommu_pages_list_splice(free_list, &iotlb_gather->freelist);
 }
 

base-commit: 851dbe76d47e790db0d6ac5151e7f22be357846a
-- 
2.43.0

