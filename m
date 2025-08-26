Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2054.outbound.protection.outlook.com [40.107.96.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15E792E7BD4;
	Tue, 26 Aug 2025 17:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756229214; cv=fail; b=GfDBI1in8wY9HxQkynEdvgyar7VpIqbtvG7mO86Dy/W8PVmXtY+Sa6taFmxDf8Rl2c1PqCiBdLc5XwLlfmzve47/9pVmk8nQvPip0A/oJ4KZ6JSmCRihJH0FTZxgnutEcvBtj0/HtJM0JNr2X7FOlSoWnno/nG5MUqbp2MP13HA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756229214; c=relaxed/simple;
	bh=HX3kSzlYXzesxCw6+7r/sO1Z3Fz6iC/gtkxRPzfKnkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=O2fRyxi+yW2T/+OfKn9qX5hRNPKxYTl/7Zmf83qDNe3rW+ySKDcLlnSOFh61WkzGrDihYUWDOYoZJ1pLqF2S3N1Lyhn1ctf6C6zallb2CPDm1eviLlfX/eYaM+0+HFIk72htT0wAtKG/cbPpOsq58FKFc1OxcFXF5KkW8E6/fWg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=W3PnpZc6; arc=fail smtp.client-ip=40.107.96.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="W3PnpZc6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dsAfxxDygRxe0sdqkj882hOqD+uMQrwJFAUx4rIU2+jLaEaMVZTL4rteQmINCuUagibZkN463Q4a3FjzXEbVeIbuu7QVhARm4jgsBAB8TPwUDOWFfBGPWO/WxCCulEFLVbGoODwwB7QZpS3aB2AH3Cbt81r1St0t6iDboQ5KcJGBhdeOWfYxHVPsiaEEcps+NLAVi6V36V+FcN78FbS1dCM/s100pdUAm8PvigRa+jsCGS1VPYHTBmhGRL7sP3dG53LCvmp+E5LtLcK6NEj1y4VWeEnhnnow0hK2yMsIQxb4VagMbeV7gLD/lmsOqiPv1xrWLUODHh8ZCz7p3Ql1vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AyH3kJVMeCf+C8zaBSX1ShjuJa8oGlsddsRqLwLap/Q=;
 b=Lkqwmp4WQftQvTp4YWLSbJyYn3eoZ5nR+FIvHIzTJTS4aTa8lCYAErR2UADamYDzqTQroRBziqoF+Vjq2t9NO7SOR8OqoUbZbjqSPsoKHeedJn+XIzoh4hMQl+QX4y+7nm89ffrNILfCU1p6xoBSSd/Dk1NNZtRbKTLIuzVaAUHeE1QxIh2y1cpDrZuZFdKeivFhL9E5DNW6xnmrJ6cMDCUNM4NxgruflGBKnYyIkquJvtLueKObkqgV1En7y3jxFw892R312U0hTKrQgD/Z66ndNUqSiverkE9iMq+vKExscjWwxkLn2ymMJkT7GIiOxt3qMJ/iXehmq+kyc5pakA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AyH3kJVMeCf+C8zaBSX1ShjuJa8oGlsddsRqLwLap/Q=;
 b=W3PnpZc6DOaWXikz3q7G16pEFnZZH7lmf9d72DDl2o9KFhqn15ogl6+xUwU+6GBr/7KRz3dHs26j/YAC23zJuh2KupPKrRVOyvzBhFQribjshJWQ5JkccvLXBKPWzmy4PGCpG3eif9bGFBosnUjKJdPoRPk8/tFYcNiyu6ujT9JuY4mSsmU5qtVIZiV2qX2z0/JEM6/QWtK0CeRdC6E+byyLpfxbt2n74m36p3eJAWxMDz0qlsoA4SOHHUncvbC8BsiR0S1Vu/bf7wcqEG6uKbpBpKQyWrx8deORKaaL6EZFlRMvGMnQ8FvinR+MYGsUpvK7qilOXgjvrXIXQjNKkw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA1PR12MB8641.namprd12.prod.outlook.com (2603:10b6:806:388::18)
 by MN2PR12MB4222.namprd12.prod.outlook.com (2603:10b6:208:19a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Tue, 26 Aug
 2025 17:26:43 +0000
Received: from SA1PR12MB8641.namprd12.prod.outlook.com
 ([fe80::9a57:92fa:9455:5bc0]) by SA1PR12MB8641.namprd12.prod.outlook.com
 ([fe80::9a57:92fa:9455:5bc0%4]) with mapi id 15.20.9052.019; Tue, 26 Aug 2025
 17:26:43 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Kevin Tian <kevin.tian@intel.com>,
	patches@lists.linux.dev,
	Tina Zhang <tina.zhang@intel.com>,
	Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH v2 04/10] iommupt: Flush the CPU cache after any writes to the page table
Date: Tue, 26 Aug 2025 14:26:27 -0300
Message-ID: <4-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
In-Reply-To: <0-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0003.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::16) To SA1PR12MB8641.namprd12.prod.outlook.com
 (2603:10b6:806:388::18)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR12MB8641:EE_|MN2PR12MB4222:EE_
X-MS-Office365-Filtering-Correlation-Id: 81912fa4-d7ec-4933-2d7b-08dde4c5b9a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?AVa3AyzlEyyyRXncz0Grb/Q7UeipYsjt+8KuJRx3GmSDjDTwYueiZkVRxL8F?=
 =?us-ascii?Q?UOI4TWQhuqXKHQQwajU8RP5ngO8IXmqidnJ6dQ/j1+ERlo7LMZCGgS4P/dnn?=
 =?us-ascii?Q?AcIB8vz4alu1eGT62I0xFks1Y3qpN0doAe/YCVCHWj9vbU+lH9eWo9KEOklO?=
 =?us-ascii?Q?wARycVywT04I75WDMgNl9sOpb41I6BJlKyK343zMBToanD/7OFimAoHAE+v2?=
 =?us-ascii?Q?vaYwFI/fbKnWDjqhm19RGIawwmsa1aIISsfx3OZRzwK3W/22gpimKWnHM6Jn?=
 =?us-ascii?Q?6E1EhO5u/yYbFt0ULjB5lgRaqzFU9WSpbAcVg8+UGpcw2HMYuMswSnzoJ2BF?=
 =?us-ascii?Q?nZGQXawdz345r6yHLcAYMO0AGxCepITiOMIUm2TIwm3NNSdJzhWLftqJ7sTp?=
 =?us-ascii?Q?HIw7FVeEyFwwylwAj4OlFn3IhB3y+lnEk/x5LgmIYNAszlD90NDxSzq++6aq?=
 =?us-ascii?Q?6Cp7XIQLL8XxCVaT/pMNvjiVu2fb1MYW1hFN4BW3Piiibjd84kR66FVtUljn?=
 =?us-ascii?Q?KZy+UNQczuHBHmxhX8tr+cO1Ox0actOW7KDOA7j6jlo4N7wSePMzqrJ3lbm4?=
 =?us-ascii?Q?L0HC2szjjoGP+XSPSTxqGAB8KIBnc1TfhCjQdyGer8FNKoyxOZ7YBXS0OAaI?=
 =?us-ascii?Q?H8VTZDV5f84XSTVos+6H4+D/Ku7F+F/OTmTRla+gfSUZn89Hd1Es+seA0Jpp?=
 =?us-ascii?Q?h5wjopaoBGSfZxOr/0lzUjey2hnrYi7XY9+KB7D7kWszQFpZZ6wMHSyFwkPg?=
 =?us-ascii?Q?vMV+aGb/51AgWKVMBcOZd8HKeWigUAiqE4fkAYX/Z4py/GIZvKcXEDpzCDk9?=
 =?us-ascii?Q?Kbk84QlFlkhSPU9mGpYIP12Knt1PwFtCQXzzZF7gfr1AeTQAHLCS+VqScuK5?=
 =?us-ascii?Q?k/VXwlsCdgz142KBU2mf8DjKPHikbhKSv2tCNoATD7PXza1yB0rWweQ26WYY?=
 =?us-ascii?Q?dX11fHRFX6uXqmLCnDI45QlJKlVTgpe378g3YsTxneQUOcBxWgDFxQ3+43uJ?=
 =?us-ascii?Q?2FlMEw8G4UDZeCYqwQ0mWuFveENiu/kPQTDXYvZiy76Ii+NqfeJj6gzKBxck?=
 =?us-ascii?Q?C3Laz+dl/gL62LPf+UCdFiEZy37tKIowxK//87SXkdGrm3BDJ85rrYXpJ0p8?=
 =?us-ascii?Q?z8TqCIPRCTI3mAgo8h2j8F3Chwk1NLyTFvclLsCRRU8KhnBP7E1elwRASeNz?=
 =?us-ascii?Q?Td4e8IVsnFrgOitFTXZ3UK7l4n5R10jiWfux5pY9QEyVE6MBE4Eyn8TiivM/?=
 =?us-ascii?Q?8xKVaoo8PqnwBrBiYfxShc5kks1eYB0M3xPc8NF0nUO0OooB0INngZ0UYEnj?=
 =?us-ascii?Q?6hQMZiKXFY8/FaBImQa+w/Uz2QEsgzY4ye2G1HsrSdV3z/WNbCDAbcXYGz6H?=
 =?us-ascii?Q?P9ikRbJmCjHY70n8heqt2lF/xoam0AV4fuhoAFEGqrV9s2tEjw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB8641.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?z+KTNYC7ug2RhhBQiGFfTlQHCLSWOOxpsCu+KhaN+hqX0gUkbGkMfxKLUDzp?=
 =?us-ascii?Q?hco2ZeLvtrHuaLIpJdGyAWbUORHmc6P+nzzQSeHkWIMt8VmVvXKL4El5iCU9?=
 =?us-ascii?Q?x5yd+iYgQosm/OzJzLEkHGBBXiuV500R7+2fSkJMRhY50rDhRG697s7OgI2j?=
 =?us-ascii?Q?Cmy81XXboXnJw9RaJIZAwc0bViIbo1rILjYYKpkNTw2EyRL9uIsy3lEWunMR?=
 =?us-ascii?Q?Bx2Pgi5kER7ARvKyg4zfUHIuMTH6sX+pY1dHyOdFGbI4SKXBFttbL4kCbwA5?=
 =?us-ascii?Q?8+3pjjraurwj+fi5jS+J2cs4wws3zDN3DlThkbV/8UF6PEJFFTFvEuw0Ws0X?=
 =?us-ascii?Q?Y8uy33HIq6KQHa8YCNaN4uzyQ6nsgjXVciOMW4GUGrlIPj9OTSpnJqiigeHT?=
 =?us-ascii?Q?wf4U9giCXvIW8BbOOez+igSS/1wi3geGV184QBmRIMAIdzTt91pZYn0FXJDi?=
 =?us-ascii?Q?oSaTJOWWGRLBadJWly+lB34u9ZR0R4a4yyR66KRW9z7iOgf/SEIFGfN60Tb6?=
 =?us-ascii?Q?IuvKKoePmiceScG93LPfeSjqz1lTTxKSLZ207wkrRidj5i85gsvbR9AMk2H8?=
 =?us-ascii?Q?RLPPqokKNtDDcDW0bbBqniWAClflqUFOzpj3J3629TwbmT4QBduOOfxwikzi?=
 =?us-ascii?Q?DU1HZu7P8Yqqr9ToJ4rsFRxo1FE0X4cPpM0Sgx2c1Ua1rqvL9ks1J6MQi5fy?=
 =?us-ascii?Q?Uk4PsI/CnEqWwXIsKQS/aXAjvyJgja5+2AaxhepCE+xDm9RSfYlzmfovspDA?=
 =?us-ascii?Q?BrPM1nMdHjf/aKMC5bNfbQDUhQxl3xHxdXD0URG8qdwm0X1beDEFjj29WeZw?=
 =?us-ascii?Q?I3joFcvuLBZxR74ttHnK6656CSDEUiOezbBZsytcwUSncUjOMSxFyTgE+kw6?=
 =?us-ascii?Q?tHN6imTXD8+f6neJLhkwIvigVkKGREbFKUQUuGxADYmbqI/VT+gs4blblvRQ?=
 =?us-ascii?Q?+6s8O4VdtS/4JGbml+F9PqJKmJMhwCLBg7Z2Fbi8KSoxNsPQMGupqavN64PG?=
 =?us-ascii?Q?HCDHb3HEqdbLeOHhIzNlaM32Q7zCA1Cg2y2yu4laauQQ5ePVI0UOf7JMCBp2?=
 =?us-ascii?Q?n446fPzk0UiAxSMzqVI9H16SddAhvFJ3jckkTNYSAATCiT9HdEGnp6eYBW8C?=
 =?us-ascii?Q?eNh20slBg08ZpdRd8+QCK3fguSZ0Bff7j5ZqQpyA90SBXYtNrcl1XJBZouba?=
 =?us-ascii?Q?WZGqk7XUwZJbnCupEqqd8nkX45+ekS41WVxsi5HcPUSgeiDoVHoehc/2SQc7?=
 =?us-ascii?Q?vfJS537esFfLHeotThFfITmm9m40GHurO70A7DSgVCTKHfmgscozHa1zISN4?=
 =?us-ascii?Q?AXoWNGBOSDgRwoKt9TokxY6M+l3lm7AEpoLVT1odXfmxWpykVnNk8Bl1AcoZ?=
 =?us-ascii?Q?faqjF98C3jn6KmX+BsD89vlDPk/gs846P9TYTi7+pGy7dZgRFAEQoGiEMUv6?=
 =?us-ascii?Q?uA1nO5Sbir1dCBt1R+dfpKjisjy5T66KABNzszYjpawdGUcjJ2tMG0vz1cfL?=
 =?us-ascii?Q?/pq4ymDkDWPKFEL9T2c0COX2rHbBsYXAoJc7FlRJah+9TvJGo+/+GtmrfZ+A?=
 =?us-ascii?Q?nZdM5vCmS1Ii2+s/FYBpXXQrFu9nywde20YH8ODH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81912fa4-d7ec-4933-2d7b-08dde4c5b9a4
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB8641.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2025 17:26:43.5346
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8FqnV8+Fi7wrWoVeWpi3jqDgCkvs0u1lBKBt9030hdLsb0F+S+sctHTku2cCvdxE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4222

Flush the CPU cache for the page table memory after each set of writes to
the page table. The iommu should have visibility to the updated entries as
soon as the map/unmap/etc operations return, like normal coherent hardware
does.

The caches also have to be flushed before any gather can be submitted to
the driver.

Implement the same solution to the race as io-pgtable-arm by using a
software PTE bit to track if a table entry has been flushed or not. If
another thread is still flushing then another concurrent map operation
could return without IOMMU visibility to a required table entry. The SW
bit will tell the second thread to also flush the cache.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/generic_pt/iommu_pt.h | 56 ++++++++++++++++++++++++++++-
 1 file changed, 55 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/generic_pt/iommu_pt.h b/drivers/iommu/generic_pt/iommu_pt.h
index 4789fe5361cb3a..c04c6750d0e250 100644
--- a/drivers/iommu/generic_pt/iommu_pt.h
+++ b/drivers/iommu/generic_pt/iommu_pt.h
@@ -17,6 +17,29 @@
 #include <linux/cleanup.h>
 #include <linux/dma-mapping.h>
 
+enum {
+	SW_BIT_CACHE_FLUSH_DONE = 0,
+};
+
+static void flush_writes_range(const struct pt_state *pts,
+			       unsigned int start_index, unsigned int end_index)
+{
+	if (pts_feature(pts, PT_FEAT_DMA_INCOHERENT))
+		iommu_pages_flush_incoherent(
+			iommu_from_common(pts->range->common)->iommu_device,
+			pts->table, start_index * PT_ITEM_WORD_SIZE,
+			(end_index - start_index) * PT_ITEM_WORD_SIZE);
+}
+
+static void flush_writes_item(const struct pt_state *pts)
+{
+	if (pts_feature(pts, PT_FEAT_DMA_INCOHERENT))
+		iommu_pages_flush_incoherent(
+			iommu_from_common(pts->range->common)->iommu_device,
+			pts->table, pts->index * PT_ITEM_WORD_SIZE,
+			PT_ITEM_WORD_SIZE);
+}
+
 static void gather_range_pages(struct iommu_iotlb_gather *iotlb_gather,
 			       struct pt_iommu *iommu_table, pt_vaddr_t iova,
 			       pt_vaddr_t len,
@@ -195,6 +218,10 @@ static void record_dirty(struct pt_state *pts,
 				dirty_len);
 
 	if (!(dirty->flags & IOMMU_DIRTY_NO_CLEAR)) {
+		/*
+		 * No write log required because DMA incoherence and atomic
+		 * dirty tracking bits can't work together
+		 */
 		pt_entry_set_write_clean(pts);
 		iommu_iotlb_gather_add_range(dirty->dirty->gather,
 					     pts->range->va, dirty_len);
@@ -402,6 +429,11 @@ static inline int pt_iommu_new_table(struct pt_state *pts,
 		return -EAGAIN;
 	}
 
+	if (pts_feature(pts, PT_FEAT_DMA_INCOHERENT)) {
+		flush_writes_item(pts);
+		pt_set_sw_bit_release(pts, SW_BIT_CACHE_FLUSH_DONE);
+	}
+
 	if (IS_ENABLED(CONFIG_DEBUG_GENERIC_PT)) {
 		/*
 		 * The underlying table can't store the physical table address.
@@ -461,6 +493,7 @@ static int clear_contig(const struct pt_state *start_pts,
 			 * the gather
 			 */
 			pt_clear_entry(&pts, ilog2(1));
+			flush_writes_item(&pts);
 
 			iommu_pages_list_add(&collect.free_list,
 					     pt_table_ptr(&pts));
@@ -515,6 +548,8 @@ static int __map_range_leaf(struct pt_range *range, void *arg,
 		pts.index += step;
 	} while (pts.index < pts.end_index);
 
+	flush_writes_range(&pts, start_index, pts.index);
+
 	map->oa = oa;
 	return ret;
 }
@@ -549,6 +584,21 @@ static int __map_range(struct pt_range *range, void *arg, unsigned int level,
 			}
 		} else {
 			pts.table_lower = pt_table_ptr(&pts);
+			/*
+			 * Racing with a shared pt_iommu_new_table()? The other
+			 * thread is still flushing the cache, so we have to
+			 * also flush it to ensure that when our thread's map
+			 * completes all the table items leading to our mapping
+			 * are visible.
+			 *
+			 * This requires the pt_set_bit_release() to be a
+			 * release of the cache flush so that this can acquire
+			 * visibility at the iommu.
+			 */
+			if (pts_feature(&pts, PT_FEAT_DMA_INCOHERENT) &&
+			    !pt_test_sw_bit_acquire(&pts,
+						    SW_BIT_CACHE_FLUSH_DONE))
+				flush_writes_item(&pts);
 		}
 
 		/*
@@ -585,6 +635,7 @@ static __always_inline int __do_map_single_page(struct pt_range *range,
 			return -EADDRINUSE;
 		pt_install_leaf_entry(&pts, map->oa, PAGE_SHIFT,
 				      &map->attrs);
+		/* No flush, not used when incoherent */
 		map->oa += PAGE_SIZE;
 		return 0;
 	}
@@ -811,7 +862,8 @@ int DOMAIN_NS(map_pages)(struct iommu_domain *domain, unsigned long iova,
 	PT_WARN_ON(map.leaf_level > range.top_level);
 
 	do {
-		if (single_page) {
+		if (single_page &&
+		    !pt_feature(common, PT_FEAT_DMA_INCOHERENT)) {
 			ret = pt_walk_range(&range, __map_single_page, &map);
 			if (ret != -EAGAIN)
 				break;
@@ -922,6 +974,8 @@ static __maybe_unused int __unmap_range(struct pt_range *range, void *arg,
 	} while (true);
 
 	unmap->unmapped += log2_mul(num_oas, pt_table_item_lg2sz(&pts));
+	flush_writes_range(&pts, start_index, pts.index);
+
 	return ret;
 }
 
-- 
2.43.0

