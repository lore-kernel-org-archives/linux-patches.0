Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012061.outbound.protection.outlook.com [52.101.43.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FEEA348447;
	Thu, 23 Oct 2025 18:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761243770; cv=fail; b=iuAFEOIHEcXHw8sklULP0vcaoGnLO9l6M/JOY0MwmPXME3NKWVHP4luiHHetvL6gTfvRbcVO8/DpLGNJlyaXgtw3fcEwcQAvBZ8NBNOMoVQ7scsIgc2AQz6vuj/hs8iQ7sabLkK1FKjTcWjVg8J6odWFuZQ2Ef50A8JANIWZ/Hw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761243770; c=relaxed/simple;
	bh=tQ2quNZVHOP58NOPbuhI+La1SJnuAb4X7QDRJgQLKKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=StzdoN1GaV8dLrzfrSaJQh4vopjSXCJOOXLArNoj6gCq4HE/bzzS06bIAS/57r6s/QkPukZcK5QZu07r3rEkycKJf1CLrwke+ZCsbuN/C4gv08BJcfTC53MwDq5jOPMwL5q8FbKPy5DDcyZARbbmxqOc3ik3c87qLIwfJ9rO+BQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=iuIZcIS8; arc=fail smtp.client-ip=52.101.43.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="iuIZcIS8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BDXl7Vvk/A7HHYRo81ezF3/H0+NRM9UUfuUA8ikmPzQ8ngaEPoCBk1Imjyctts2+GK778Z+ItH3ivAETwtbEC/uWRXBMLAonX0cjiOwVbGFgAGMNZvCVUGOFA9lZT8hLLhHYN5QXJ7F8Lp1foiZKtgS2oKhMIW/N6bMDEj4Riz9GNzXa2fS6/n+H41ZM3LwR+pAxWTQifbXU/JMNAuNuA4BM6SdGavX1AS4/468LWqnV8viJeYanFrNh6WjS+3Yjhz4K8DW3cDVRa0SgbBEhRVG86rBl4QhSK7kI3eRP5JeB3FPQW5ZketwUiR7bNNqCwN/UL6oa7x6j30rLtCkgGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CDFPfxj1n+73FIsZ8QwXJaBhshe41fIFVxIEHlTrMYI=;
 b=XtEFHK29Pr4fS6tweWg9D+partw+61cof6HLx7GHrAftrtK4gg033tn6CSty+Z1xTqAxy8gHgpVnQ/IGJWGsjIVHJv3IhXiwD3Reqi5y8NlF1rqv4C41s9hPvWiYtxvhWvEBJcZj8mLtEw7YKrcaVRqIewB/OQBGGGCYEk7665wU1ZNVx8v++D8bTyFY2kC/E+xRBz5843QSdWr6v5pJnW/QdORI278quJYvGBM6I7WYnODEjqDVj8CDg8tg02LaQgvY1IgJInNtxrjlJPRnyEGCviA61FUwRcyXQZDLLItEgR1Hr0SxQmymANuWth13y83dw7eD50FK1lLBIOvDWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CDFPfxj1n+73FIsZ8QwXJaBhshe41fIFVxIEHlTrMYI=;
 b=iuIZcIS8eoY0NewRT3AmStjL4CmU2URRfz9SJv2IVKbjVZ9qH6x/39j+ZFMj9LK6pk6XV5msOQtSAM/icT8Aqr/RUTukkPlcrZVqRFf2uhL6jiAe3+wbgGvA9KA1SKwtAKtkzdRPLRsbv3PKUwj15iW/Ove4Ex6R5dVR13DBxJ6TiFwxidKyWejeDtDzxKDa08aX/Meb6iqw65uux/kVt9g0/nBnqN/vj+BHZhWZiCX5bwslX2goSvqhmquPgsu+ER9OZTm7RQ1l8CdnuibZRSazh7IN1ufB91wM0ChxfrjEV8NrxWPZy7w5ZAT40HMIr952t44Szc6SxkQbnofnkw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB3613.namprd12.prod.outlook.com (2603:10b6:208:c1::17)
 by IA1PR12MB6164.namprd12.prod.outlook.com (2603:10b6:208:3e8::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Thu, 23 Oct
 2025 18:22:42 +0000
Received: from MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b]) by MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b%4]) with mapi id 15.20.9253.011; Thu, 23 Oct 2025
 18:22:42 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: David Woodhouse <dwmw2@infradead.org>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	patches@lists.linux.dev,
	Tina Zhang <tina.zhang@intel.com>,
	Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH v3 02/10] iommupt: Add basic support for SW bits in the page table
Date: Thu, 23 Oct 2025 15:22:30 -0300
Message-ID: <2-v3-634ccd3efce0+16d38-iommu_pt_vtd_jgg@nvidia.com>
In-Reply-To: <0-v3-634ccd3efce0+16d38-iommu_pt_vtd_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0017.namprd05.prod.outlook.com
 (2603:10b6:a03:254::22) To MN2PR12MB3613.namprd12.prod.outlook.com
 (2603:10b6:208:c1::17)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB3613:EE_|IA1PR12MB6164:EE_
X-MS-Office365-Filtering-Correlation-Id: 691260ec-e14d-4bdb-d952-08de126127c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vxw6ATEHhMvZ9+JcEAVyQMOrSfuFLnDQ50+7iQIas75uHlmCyuss6/kkzlyU?=
 =?us-ascii?Q?y8VT3usK/VXjvARcjVqf9CCWwDCr9uxf18skiBJc4wkoY+zQqdHbgCoxFDlU?=
 =?us-ascii?Q?zZLSpfEynJTFhw4oNRzQjI1FRN+MGOHRhRelHSrYuOGT+cEdV2jW/q5ez/Sy?=
 =?us-ascii?Q?KM743Vr/SlU/ENedTUsXbbRbVYK4OK2Wo64r3q0mpTE4ZCKSOkVibTJ9RRs6?=
 =?us-ascii?Q?D+Df/+qmbnfg0PyPvfbH7lKq/JU0pjiCqMsLTa5+pDyMlGV4a/1kPFlDxQ2n?=
 =?us-ascii?Q?b8qvkO+cuHD4xETLSz50FQbqwZQwrUe+g9LYm/BZLXq9lcI8YaZa0OvuaQ1B?=
 =?us-ascii?Q?+Y+JV/Ti5bdOQ1mxCTQ9j8fmqcJB9ThcdcwDoZsJTUpMZoalE9id1rTHh4AH?=
 =?us-ascii?Q?BVCS9UrJJejQ/KDM3b4OzfdHz6KgRGMXSitn6a00fDy5NIiO/rwUdOOg4w/X?=
 =?us-ascii?Q?tpa2KIl7dVZR/29DZW+8QovmI1t58Q8u+WkgiipzQqX49t7ugokRHk0tGYop?=
 =?us-ascii?Q?KVpgz5GhTYGZllpINmMn1fBLkQ5asw4nNUHx2gI50CVbaXybVa97HrOG47HJ?=
 =?us-ascii?Q?WsIt+VPqC47j4A48oieoyJIgTW6oMOSsNVCMJVQ7DuYfYjFhx6+h9FOfGsGR?=
 =?us-ascii?Q?/al4VCzXGydrol0fQP3o1caRVihgbtdpaSZcUzDc7apREA1t6ZKXV/isE42n?=
 =?us-ascii?Q?POkeHY/gbIEMlmPdD2+DO7Anbq/YLre8ji0fDjF17bvOVyiOxCo4Balv5DMJ?=
 =?us-ascii?Q?lRr2J/Ir4lXfKcgxF8vL7SZsllJGXmhUGEd9qIk1ruEVWtD7Hd4W3IOyamyT?=
 =?us-ascii?Q?51gL6h/TLEL3oSFIL7G9o6acYzo32M1GFvfQjK4ox+IZ8pRtP9lBgISk05is?=
 =?us-ascii?Q?EutXV1ChfqXv7Fw7aOAw3jNr6vJi30XVoWkBj96KSvzODhu+tJGILHtWYSeE?=
 =?us-ascii?Q?ZzfNaBjNvkQZcWEbi01KkPbMax5b6iSN5W0NwjMYEO247LnhHRNDNIYVUoMr?=
 =?us-ascii?Q?mNL8wgFqdDCvvLdjGi4l0dAjT0dQYEXVznmC7f89dQF/Y9/wJCri75tExTsp?=
 =?us-ascii?Q?v/vumPbyaQNpERCNRUJILlqV9BkiB/CzT9Yg+SeZqQEJgRh+0WeOg6Gwm1MC?=
 =?us-ascii?Q?8J9Tn/ZArdwBh9r+UZq2Mzkt801lJ6W0A5kMDIwnV5DwUVo8xYrHNFrsw3I9?=
 =?us-ascii?Q?u68cFXVfu5pdqsLsPCv7T8GAsqRi+Om81QNFZa+79Kok8vctE/R8h834vI0b?=
 =?us-ascii?Q?FarYm9USJ5+q97mX0nCtgahJSRjGdInO2ulbtU5PRcukCg6rWg2cFlh3brIs?=
 =?us-ascii?Q?0+RfmrA4asHSkrRPr/HsHp39GvMX0/6v5eG8hWXyk9Ai78ZxrT6YA1DfShc7?=
 =?us-ascii?Q?J17/nTqhqdgA+0zSVbqhNKf3n/69vAwWvlgQOsqht0DKxXg1xba1NVKgJMjB?=
 =?us-ascii?Q?WHDOK+6nTnXOqIx6Dh2JroPzlQ1ERHSt?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3613.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Ry3Rp/hlrCkice2iZ5zj/R2v2X3EJFIMIEHKoFdkwtjKErm92CkswhKLONsh?=
 =?us-ascii?Q?3zGUb3zML/pRDraJV1QyGLHSghX3g4ywVq2bvVamVxoUZumvUQXfEhMJa/Gd?=
 =?us-ascii?Q?Irf4RYi7/IP3t5xW+Sg4N8NMuqR4zoasTtNvHXxhJ8057pBHp8Tqvq1S1NG7?=
 =?us-ascii?Q?1MlsmfHFk18BAzdsuWjDA2nTmfMfz9iNI0rbmGWgCNJ+6aOg79ZxyqGqu3mP?=
 =?us-ascii?Q?UCD0OZ0zkXENsVZhk65NcAW0ZUWhgEgRhHW5oeaAni7QtVyWJP+zslOdFDmn?=
 =?us-ascii?Q?FE24oE81++a58sfO9RHFs3KIQY2wLMJRXDxgHxwu61BWKCFLXKuVzed3T16j?=
 =?us-ascii?Q?b0ptkyOYIKg7LrnBO36p8oWNIOVn4DkHs34fjguG/SkCF0uw5UAVw2fYU0zQ?=
 =?us-ascii?Q?P+87owqNsSqdCYaHdLqjP5AW4IJcLRVyDQzoF5JxxVKjZdRR1PVsumC1DAhg?=
 =?us-ascii?Q?LU6oqJads0b9FJzGAzAB2EXkmNVfBeKF9WIa97ZFlxcKwfxACAK4nvCESlSs?=
 =?us-ascii?Q?So4u1GHZwyNWAkn4jVUDeqrx0FW8a+cag8Qora8odPCPnkAMFdlkw5eMmabj?=
 =?us-ascii?Q?TtSyXlvWV2pMi1sNa/lVkN/bYgg8EbBjoIaaAkW8g8ydv0xlZmq/SvFRftdx?=
 =?us-ascii?Q?BmE6jaoWpkD/CcouIVllWYm6ZQgK+ZixcNj4+E0XbBfdCovB5WJjRNvtNAL7?=
 =?us-ascii?Q?8FsnwHuZYq0iv6dJDDg164+HEMpTUTVJyk2lCefgN/sIy1VkakmypZ4LFXaN?=
 =?us-ascii?Q?NAQtgHDPlfRwUBdBXmU9lriY0n4fxRIl5z2y/9+wqokwaia4Al7DSRpVBm/x?=
 =?us-ascii?Q?VCa1wPUrjGV93O1SuVGCDgLsnzX5XppgW2qiC/2LDMshSNVnHsn9MJ+yQykr?=
 =?us-ascii?Q?ErRt+hcd46atEFENisM1yG0xANTZW90+MOht2awA90IedvWRemwtNS4DgqlB?=
 =?us-ascii?Q?6LzvW+a1YJqDXzSyA68YlZK46y5tUsC5M3J3qPf0oFxuDFyuRnsd/Ti5/GU7?=
 =?us-ascii?Q?yx+Kj8Hz45xA66aBP1otolhMn89NOAmN4lvrzzpyum7ghGolxFKV8gRz7DKM?=
 =?us-ascii?Q?BtwdJJv8tzPloqsr4DF6rHTPQCY7vL6AlUXqax2uldBzzHwWWeRmhqkGIn0l?=
 =?us-ascii?Q?iJcx+No2RcJT+6E2Dlr07g2BPpWyn5gWsyix+MagKJbM8I05H+RxJCBB9A+k?=
 =?us-ascii?Q?ANeDFK12hiSG1x5jb8wASJ/ujOf68lOWEv7tLFLxmQzIQvXfzh0WXnjXLONt?=
 =?us-ascii?Q?hEs2FtDXMh2+b6fCF70bS69uPa6DQxxmyg3HFKNsOyPjE9HGGeyk5K3u8n4l?=
 =?us-ascii?Q?sbxcOuy/GTkgeoxLdxbkWSaBObWEUK6m5fn3iamK4ZeosCxqYaJxmidQkqhu?=
 =?us-ascii?Q?be/VM2qa23ikiNa7fAni0UOYoBwyBhNCOfkhYSyR40x9/7c9Y8smCYEBpBfw?=
 =?us-ascii?Q?uI/Nndl7A/ZxqYggoJakhM/LLAZJWBSSCuIExbe2KT+GAp3SBFl1v2cghhMC?=
 =?us-ascii?Q?tmBgI6kfTaPd5zUVqqhpGRP2pP1efGtadBfFc4NGFMKYWj7TqYijYMgpB+Js?=
 =?us-ascii?Q?YTBVghbJvgPcFVAICBVrMWHzZ2JlBkAgpmtHS97r?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 691260ec-e14d-4bdb-d952-08de126127c9
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3613.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2025 18:22:42.4527
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t/Z2NWL8kOgvAeSrksByGfyUrQ8O4xYF4h5mqs+7tSaiq+Ifz25Le7a3XPm4ZHde
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6164

SW bits can be placed on items, including table entries, single OA's and
individual items within a contiguous OA. They are guaranteed to be ignored
by the HW. The API is very basic since the only use case so far is a
single bit.

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/generic_pt/pt_common.h       | 29 ++++++++++
 drivers/iommu/generic_pt/pt_fmt_defaults.h | 62 ++++++++++++++++++++++
 2 files changed, 91 insertions(+)

diff --git a/drivers/iommu/generic_pt/pt_common.h b/drivers/iommu/generic_pt/pt_common.h
index f64f800725dbb7..b5628f47e0db40 100644
--- a/drivers/iommu/generic_pt/pt_common.h
+++ b/drivers/iommu/generic_pt/pt_common.h
@@ -342,6 +342,35 @@ static inline struct pt_table_p *pt_table_ptr(const struct pt_state *pts)
 	return __va(pt_table_pa(pts));
 }
 
+/**
+ * pt_max_sw_bit() - Return the maximum software bit usable for any level and
+ *                   entry
+ * @common: Page table
+ *
+ * The swbit can be passed as bitnr to the other sw_bit functions.
+ */
+static inline unsigned int pt_max_sw_bit(struct pt_common *common);
+
+/**
+ * pt_test_sw_bit_acquire() - Read a software bit in an item
+ * @pts: Entry to set
+ *
+ * Software bits are ignored by HW and can be used for any purpose by the
+ * software. This does a test bit and acquire operation.
+ */
+static inline bool pt_test_sw_bit_acquire(struct pt_state *pts,
+					  unsigned int bitnr);
+
+/**
+ * pt_set_sw_bit_release() - Set a software bit in an item
+ * @pts: Entry to set
+ *
+ * Software bits are ignored by HW and can be used for any purpose by the
+ * software. This does a set bit and release operation.
+ */
+static inline void pt_set_sw_bit_release(struct pt_state *pts,
+					 unsigned int bitnr);
+
 /**
  * pt_load_entry() - Read from the location pts points at into the pts
  * @pts: Table index to load
diff --git a/drivers/iommu/generic_pt/pt_fmt_defaults.h b/drivers/iommu/generic_pt/pt_fmt_defaults.h
index 60d594bbb1063e..69fb7c2314ca10 100644
--- a/drivers/iommu/generic_pt/pt_fmt_defaults.h
+++ b/drivers/iommu/generic_pt/pt_fmt_defaults.h
@@ -202,6 +202,68 @@ static inline void pt_clear_entries(struct pt_state *pts,
 #define pt_clear_entries pt_clear_entries
 #endif
 
+/* If not supplied then SW bits are not supported */
+#ifdef pt_sw_bit
+static inline bool pt_test_sw_bit_acquire(struct pt_state *pts,
+					  unsigned int bitnr)
+{
+	/* Acquire, pairs with pt_set_sw_bit_release() */
+	smp_mb();
+	/* For a contiguous entry the sw bit is only stored in the first item. */
+	return pts->entry & pt_sw_bit(bitnr);
+}
+#define pt_test_sw_bit_acquire pt_test_sw_bit_acquire
+
+static inline void pt_set_sw_bit_release(struct pt_state *pts,
+					 unsigned int bitnr)
+{
+#if !IS_ENABLED(CONFIG_GENERIC_ATOMIC64)
+	if (PT_ITEM_WORD_SIZE == sizeof(u64)) {
+		u64 *entryp = pt_cur_table(pts, u64) + pts->index;
+		u64 old_entry = pts->entry;
+		u64 new_entry;
+
+		do {
+			new_entry = old_entry | pt_sw_bit(bitnr);
+		} while (!try_cmpxchg64_release(entryp, &old_entry, new_entry));
+		pts->entry = new_entry;
+		return;
+	}
+#endif
+	if (PT_ITEM_WORD_SIZE == sizeof(u32)) {
+		u32 *entryp = pt_cur_table(pts, u32) + pts->index;
+		u32 old_entry = pts->entry;
+		u32 new_entry;
+
+		do {
+			new_entry = old_entry | pt_sw_bit(bitnr);
+		} while (!try_cmpxchg_release(entryp, &old_entry, new_entry));
+		pts->entry = new_entry;
+	} else
+		BUILD_BUG();
+}
+#define pt_set_sw_bit_release pt_set_sw_bit_release
+#else
+static inline unsigned int pt_max_sw_bit(struct pt_common *common)
+{
+	return 0;
+}
+
+extern void __pt_no_sw_bit(void);
+static inline bool pt_test_sw_bit_acquire(struct pt_state *pts,
+					  unsigned int bitnr)
+{
+	__pt_no_sw_bit();
+	return false;
+}
+
+static inline void pt_set_sw_bit_release(struct pt_state *pts,
+					 unsigned int bitnr)
+{
+	__pt_no_sw_bit();
+}
+#endif
+
 /*
  * Format can call in the pt_install_leaf_entry() to check the arguments are all
  * aligned correctly.
-- 
2.43.0

