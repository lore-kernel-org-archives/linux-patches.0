Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2040.outbound.protection.outlook.com [40.107.237.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAEB82BCF4B;
	Wed, 16 Jul 2025 19:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752695878; cv=fail; b=pdmMzET4qK5NHsGkLpv60boSPbWT5XkMFHtYHxqinQ0Ij8Zvdwt8Vqeo2PlO5SzeR/y1rgvmdDbxk9NYp+witC8Wh6Emvz1doRff6glgCmoxXJaY8n41RDMDsaA4GcLL0kPuk5w355fIm2s4qDFdaWyLP/neQ50r+TwOq0K55PY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752695878; c=relaxed/simple;
	bh=LuzdtbGX2kNsNI/TYAgIyEr7HrZ9oFk628gipw/+Vho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GKDEuBtw+9+JrrcBNeOh33vT9GWMKeEG2bhsZbsivrq4fuD+G5pdSz1RNTBII4g86RRAI8In9SpS2blC9tutT5Yq1IR2dfnDxkOML8BOlsplKZM9CL61wcaRBYDOlMP7P8+lEwR3HhUaLv1MYtQqMEnMIqfEuOj+EiLrleWVvng=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=RhUiZy+1; arc=fail smtp.client-ip=40.107.237.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="RhUiZy+1"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qPgNAqptc02H5K+9IwYlZENs3uiE2l1hWpsnVWooE2SV6fYyabbKBxLGFqawe2UxNQXLwlnd1YDcBEzV1GNEZddOBqwmEoKCJ7B4eZ/S6sGhAG5r7gs+kHSwQachAINjcYQZrei6KT8d9uVsrytWcPgv3AcyBQslU34knIACQMx5BdWFNf8MlzXKfkU6y4U1a3GNXNiPBCX0uLyeRMKFgDoYIoE45WgFRsBcHy9GT5sMgjYZSuxLFzw8+jZSCdPSYMNAciuQsecBpPGNmhZiIWhLSLC/hVmvR2w7FIeSFkB20gAnYuwooRNiE3VnT+Sff4hhNJrLnJ6zE0EdiI8KuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=atY7XkFQVVm0c4fEUtq51rY33tR08Y5X5HQj7WM1kA0=;
 b=SRqlLQNhOQJF7M3HBV9XjZVfKlmjzM3+ysmb92VPH/Xj6LLR5tpX7So4HxVTi1LaGQjgNlnn5bHY9xAHuIshrq2gpaEdIdvzuuMoL+EqvGsmA5gzJGqTJc+Zr+btjTK7AF6WGwgHztIZM3AZuB3vU2S4jrVTJmVEVVwm+hbuE4X6DNrKmx6Bz5o/pwzVbkUEqcEazx5fH4U/OCFAauGk2G9E9SDT49GQUFHv+PrVz1uhgPvzcM7ITA45YWUmC/tA45tZU8KdQT1nCWo1BFPtkBjCLna2EecbsIgoIrIG57a48Fi2FoJQXds9qkxvcbzo0rdkme/qGM9NtnT0COmo+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=atY7XkFQVVm0c4fEUtq51rY33tR08Y5X5HQj7WM1kA0=;
 b=RhUiZy+1CFd+l+Rpnu8x0c9W6Jyot1aG/eIkZ0H1DrHTbsQ2UdkkDp4qO2l61mlIsuJ6DaiofsIXcDEobEY0DboI7Po7/psuRFBMeeOce0HccH4vB27AwRRlo6CAXwe04PPWoGtfo30+b8YLiCUI09whDPr+vfw6gGWNsvPvf+5SGwVzGiBber++ikcwSB3Yy1YItzhZvp5jQyi78UEx0W/uRhJHoT54GD3uQEyr0l9rthOjcpgEo2J+nRykfOLkns+aVdW02WZRCoDDAakVP4cnbSzEPUaDMwSCSWG/AWy8qyQfkBjzs4uVK/S5Ma/OPEDIpjJKxyHQddNHppfnPw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CY5PR12MB6105.namprd12.prod.outlook.com (2603:10b6:930:2a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.33; Wed, 16 Jul
 2025 19:57:50 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8901.033; Wed, 16 Jul 2025
 19:57:49 +0000
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
Subject: [PATCH 4/9] iommupt: Flush the CPU cache after any writes to the page table
Date: Wed, 16 Jul 2025 16:57:40 -0300
Message-ID: <4-v1-bdb01ffac49c+be-iommu_pt_vtd_jgg@nvidia.com>
In-Reply-To: <0-v1-bdb01ffac49c+be-iommu_pt_vtd_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0296.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::31) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CY5PR12MB6105:EE_
X-MS-Office365-Filtering-Correlation-Id: adb794c5-ccf0-494f-e126-08ddc4a3097e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?rzo71MJtFqvJxlR74lQ3d89qqjIFE5Csly358OzbVUSxVY7ldrEznG5qeovf?=
 =?us-ascii?Q?1/hv9SBdsR0lNN0rVOVKsJTTncNgqDrA6DPIahgQrTSCMriF+AZ/y3ydMcU1?=
 =?us-ascii?Q?E+te8A8emjV0NBzcHeYNYLJmmgoTz+IUVqqBwkmvNSxkPogJzNjFqqtf0uoi?=
 =?us-ascii?Q?P6OysMrh//SlHS9QMGCCFkrSm8DapIFcIVBOehM5tOP805EouYb/+GLSNL1K?=
 =?us-ascii?Q?F020MRuF2ii7boKKBW+NkkPJAjxemUtKrgW5j7pJ+TWJqKGY6yHS0JQYBGzI?=
 =?us-ascii?Q?6sfFM5+NSouqGfZVjzRnorHw9eRLPAMgjF6qhl+yj78F/vmIlhIW0v3k9AJC?=
 =?us-ascii?Q?vHmwxvh2kq5ipifO4ksuMZpayCwSJFD8sbhQlrgXYYWujqv4G8JE1NiYhKW8?=
 =?us-ascii?Q?SGn51o8fYeB/ECmaoACoulQ9iyLlKNTGfF5BpL+Gf4IWXwArQIw8y+cCUpqE?=
 =?us-ascii?Q?ISS2e0jRTNLH9/uAiTSAvabSEGriEsTXP0KTS/wi8XcVuv1P4d+6dax3DMtD?=
 =?us-ascii?Q?t32kJ/GFb1I8Rxm0uOezK+PFQZK8S00foAJ/bZq38l/DM3y+ZFkNDFmMXjgT?=
 =?us-ascii?Q?AkoVXA4MgHIm8Mqy3VYIfC/DGs17SVKixJuD52mhZno7aKIIEXEtgqwCdQKH?=
 =?us-ascii?Q?D5K05j/9ELyknOgBXThYyLGHlNst+zBzJK6iQ4B/qReoaaLgfDXjcXdarF5o?=
 =?us-ascii?Q?HagOEEL3ypi4N0P4bwtaxu95Z90pudEhMPmE2HNnVhLF4drfF5FE5dGxkQFj?=
 =?us-ascii?Q?VJKa+HA/u44BDxVUOcJpWTXhjoAmL2MIlAHutHSZp1uMWE2xkjufXUzBcYgI?=
 =?us-ascii?Q?IBvl2XvvMGuKvdxRC/CwG15wq1x+ig0YnFSx0bjqCFr6eEipH+DTOVAD5Fha?=
 =?us-ascii?Q?YRdD6WB5ZRC7CY8R1R2DUOcfA1+UU7u/V/F4g+j10/S24mhTPDSDrqJ+lIpT?=
 =?us-ascii?Q?1hQf9RtvIrbC2AhP1lVJPZNVSyr0PVzJ/1EgzAKhP8EbB6BFF0OjxUqR0jH/?=
 =?us-ascii?Q?9Ru0F2S9jKQAMg2YE2fpnWkLJOUiMjMFOxN/Oq75xMJBAeuxFtrOtjuBaC6Q?=
 =?us-ascii?Q?Ojp+XWB2HVxi+Aj2buQVUQAH6xvwNL+zVgcmldtG2TCAd/bnUKCC0FaukVzQ?=
 =?us-ascii?Q?GpPaZS8VykuK8417tBJud1/462pkAdmpxgJtv5617RCT4weJTfJPUw9eUJe1?=
 =?us-ascii?Q?WdjWfllgjjsO7j64mHeqNBL4y2Z60QapNYIZHEq1Gkpt7X7TSzOell7kcFC0?=
 =?us-ascii?Q?vQJH2R4Q8WYfDimKFwwMaeWBzjGuKsL3DgZEbz9iC5ckwaDnCrP7HnG7WbVo?=
 =?us-ascii?Q?kHHs0zlb5Csa/JDdZHNWSRhjsOygO2EcQQPkY5dhTkaDlz6QFL3IuLqA4KYu?=
 =?us-ascii?Q?t9/opSulqBsaeWuFjE2+1fkjovP8PyC1SJR5cFrrRjGjdY33Ug=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?b/GMkmNmDN85tedmspuveQjDDaERYqBwI6MYLVvIfYLOpM4yGqbRss8pKQja?=
 =?us-ascii?Q?FgEIa4qlmJ2nizvnosMgbRU9WE6G7MQxxPn7HlM2+DXXsIUXmG+8V/NLaCeg?=
 =?us-ascii?Q?5ua8M1aShKLVz8Acuoc/Blg+SlaAuacc+kKquTlTc8HMqr27KsAK62HEKRln?=
 =?us-ascii?Q?3zGzZl1+K9GYEbhpnOLBDJ+wn4kWabefz49EJ/ti1aTsXV36/Yb7e0F/lVHv?=
 =?us-ascii?Q?sc7lJE28Dnm6kV7gyemS8MVB8DrKt+kXWJ7/i8fO22awtsWIMbhOjsL71MXN?=
 =?us-ascii?Q?E5QTf5PSUEoUDQ/gtn64jLu9VKvd4b+KVzGO6S2Gs5JSgyAMCcVPc/uVOWPB?=
 =?us-ascii?Q?Ao+MeOczudbYQldFlXNcj4UL9I6nwMf6Kf1/GtwoOe/GqyIpxREWzbQWfk4H?=
 =?us-ascii?Q?8eC5OjkoT2py6OB5aZbSatiDkpRxqYu5z9ckx6p/7TpIvHP8xvTMsN/YEhS7?=
 =?us-ascii?Q?G5N8YOp9VGMnzufv0rsT+iha+6T32UENQHyEgjIjfAAigGVfYE7bu/NBkKNj?=
 =?us-ascii?Q?F0+d6SaTx7a5RVq2wbUOQS3bSDdX3Y+jTF0fLMUOzFDhp18DqdZ+8LoLjgzy?=
 =?us-ascii?Q?ZwZ6HzPDG4LhgLhYb2STcNuilI1v/0ImwF+hxQHQLZJEi09sinZ2I/WJumzi?=
 =?us-ascii?Q?giA9FMfR4ojMkOled1y3zQEv3jHnQgrstC9BTRGs25/bM1yNABTTJOl+Np3n?=
 =?us-ascii?Q?lpljIOg2rutfRp4XLYPpYFUtQTUl+sRw6bedr2r+rXPWOaic45A9D/0xsooz?=
 =?us-ascii?Q?1yY4xrmey4nO3ipGr0AeG0sm9fWHuUdCOjhgZaX793EE0KGOvYyt9wvaiF4H?=
 =?us-ascii?Q?Z3L2yji3Gc+cImXi0bnZZQltupBj1pBmnMfis57OeNStoTGxuh1/WIARoBmM?=
 =?us-ascii?Q?7tqntVjVTN5aPFTSRf9Vy48JRoetLM3rj7gbCUpOc7DQaizWmSCq4w97OsHJ?=
 =?us-ascii?Q?WVkW6HILv3cE6rakw1t/8kdxGmXRj9tdRD9jGr4xrZ14+M/XJCOEgUvtMASg?=
 =?us-ascii?Q?GSpy0X8dt2GhmHsUpKvL0OA8nJ5BJDgBMupiC6p3jukXC3fxduUV124Q3vyj?=
 =?us-ascii?Q?rM9XrbzW/HcQQnXeJv+U37Q/tt2BJMmrLfpaJbyXfzWv9DWGhGboonNXBC5L?=
 =?us-ascii?Q?/rPkZGqUPZ77zdo4rNy7+2LjUdkJ0jjukiik5yHZZQw6VJaC30c7xXVAvzXN?=
 =?us-ascii?Q?sc1BpaC8mcUbHNQ8RY0gzuCmvITqRNiLtqDuKZ3HKALh0RgoKPNniIconNtD?=
 =?us-ascii?Q?a2aQKxKiv8dYwiNgKk6zODiNEzoRDbsk7NUfhjIfjz1pWaoYNKBqmuK1WKzs?=
 =?us-ascii?Q?qLFCTeugKeLyQBr/pXUzkciDL2yiWb2sge9VJOWV7R2VRgWWukg752a5+7id?=
 =?us-ascii?Q?rsN9qdIg96FFrPg39v32hvorYxZ1HKpS9jWQCVRGZ0Ajp5FbzuFvoJWuBjGB?=
 =?us-ascii?Q?7uBfjnfaPH4P4eDzbGXK71bm0f81qPzjGl1kSrsiqEUWxmZD02Kl2yJ18rSN?=
 =?us-ascii?Q?C4cfpBvG14PoJW7nkz+3QaZMI7/Pg9juKgAmClGKYw7nMqSXdi1Z22vPpRie?=
 =?us-ascii?Q?10nQvvEP6gWAKsRbjzBYqC2WItihPSdbkOhkl3VZ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: adb794c5-ccf0-494f-e126-08ddc4a3097e
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2025 19:57:47.8546
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2PVg23lcOJrBD6b2bfzlJp0Xs2j6JLSCFwmEuDNHyCwPo63SxR60I4eL62KCGV8T
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6105

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
index a22d45c95e1391..50d914037d2b0d 100644
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

