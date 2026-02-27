Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010011.outbound.protection.outlook.com [40.93.198.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6256C44DB88;
	Fri, 27 Feb 2026 19:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772220709; cv=fail; b=dNwjUSRo4NkX6kMAU+IPIkqYT7ZNmb3yBuoagwHTQ77v8aEQvWq4gLOZ6hQGsF2TGpyGmdMyRJexTTyCm3TZpPWc9APC4I3Ol+g/CzqDwLFXg2SKQU5h9LNlUtXL0xcoTu5O6+qHPy4SUu/IzjXakkp3NHwZc4rsav7yORyBPXQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772220709; c=relaxed/simple;
	bh=9IAd3NFaOQ/yzs0liFFS7ux/WM5xKVnQZg7VAT0H0+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pIdhxLUi5dZV0NML4nJtoqS//m+Hf9zhDS9Y+AroNPlRigbuPxmja+VMN+q6zYCCwc7M7+LC2BXeFj5Hw+jHSAg01shcy+cAnSvRRAPDtmI52+RI/37XbVY0iuXnFVgFuj3jYJqd5AKmRKZruhVKHWqXsbrqKx0cN410s4K4pGc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=FIEIuB1W; arc=fail smtp.client-ip=40.93.198.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="FIEIuB1W"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GEPLR/K11kKm9sErZbGQSt5H9bfyMgzk+fXl4F0pXPH1wrTB+moVOjPCwR9kFsdI10Di2cPotMdBoRlXPUKvwhPaGY4E+MSfS/dIMJZgxUAkrpDdybYfxAsKmeoYeICFYGz7BaAK/mF7jTgG4pTOCYaVGnVujafKtnqfcZfzOLKJ5q6XUx7/DAIDb+5CEALomQCbku5ahczAsn1p9f58rjA5rhJcwNVamM4rCpUJB4qsFXAhkQ0MxQsWvhuHiPUsW+ctUZeCtNfTkZYew6UepleO5YOmgWSa/IxkiXaweUI3Xrgh0MO/SzsLLp9abUgDTt322XDciUEtcDIlKmNnOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eUijPpNp/ATmu0IQgfBFR0oLKR3Ef1xFK7iMyF/Oz/A=;
 b=Afx0ZGdSUYOCsHhtbZ7Vy5Ul/XJVKlM/mnPyJI9OK8qEcwB4adg+c5ToI8ZPYZUE+e4b5mmm2Fy3vonwSp+o/nGjN7rr5HbDMFptpLVfDmmjG0yLA7IdkRwpX2wagh+gUM+ssy9WomFGDolVf3Egw/qcm7i02XalkxWWXdK4hmFZR+AdoSVQxUpGwHKVhLu/jZKkmXSH32khQOPOPEjXug/1geT2sm7fHZFg7TzSF9KmybG1RCSFeOyJhpiFVldYgJT8oFBh9E4C41EVdegGCWt4EeuNVmOqzjquG9clIYTqDjVTXW8I/N3jVyYUbfLNUHFDRTGYVOIEjA6eKdPNPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eUijPpNp/ATmu0IQgfBFR0oLKR3Ef1xFK7iMyF/Oz/A=;
 b=FIEIuB1WWeel4ofEs+vlUoqokbykNb/8YBxfRVyvAYyc0p541J734vXltBKvZchPcRs4hXhe9nWYG5M5rBDbrW2iEQiwSf2mtCEsjNSGSOaLmRLxfdKTYqNO969liu2tdapPUkgvY/fph6L6tLw8urr3pS/MvYHgQdayO5GwQ2XK/oAineHFO+nrT3dOphAbezh9Io5v0i4q1Zg6wva1xhakA+kdNpp1NBxXeLkQtas35bUC2qGzxgy2iYRnv8sVcgBXGdH80TDFg1oSocjcjJnrVwLXqHJYmEAqUS7aKlF4dDw32eKkB4jbjRM8cWPWVH98XtkVcpPL/SHrzzTGpw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SA5PPF3C36BFCB5.namprd12.prod.outlook.com (2603:10b6:80f:fc04::8c7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Fri, 27 Feb
 2026 19:30:14 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9654.014; Fri, 27 Feb 2026
 19:30:14 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Kevin Tian <kevin.tian@intel.com>,
	patches@lists.linux.dev,
	Samiullah Khawaja <skhawaja@google.com>
Subject: [PATCH v3 2/2] iommupt: Avoid rewalking during map
Date: Fri, 27 Feb 2026 15:30:11 -0400
Message-ID: <2-v3-a1777ea76519+370f-iommpt_map_direct_jgg@nvidia.com>
In-Reply-To: <0-v3-a1777ea76519+370f-iommpt_map_direct_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN0PR05CA0027.namprd05.prod.outlook.com
 (2603:10b6:208:52c::24) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SA5PPF3C36BFCB5:EE_
X-MS-Office365-Filtering-Correlation-Id: d0c2eaa2-0e49-418c-bf0a-08de7636a027
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	bi4thsPF+d4aHqV5wuRtc1sgbO7ylJ7IYgJe7wPs2ruBCx9LNBsDRjfu5bfeKGP4Vzx2ulu0SQU+UaE4eU2D9Vla0P1UYh+4RdF1oX/efHKCDP6kPegUHE1H3SLmf0ssjycvPVJ+gJ0nb2ikFWMPcgfM9QqoYPZJ4cftc6E4sX1Fmw6ykc6p79ATQtabfLVKAgEYFWsjMyXJHsvlM1Nrh4v5z1ZTck/yeatu6cQrBKEApMtz6ZlZpqj4yDrKMiSKUCQOey9RXXD8+QJQ5aUOBcsjdNaeIZAhJWMdi5QDbYInGKhMv4b7fWwL2hkX1wqnd1JJOj3jN/xhBPxx1twkc/KWLYNv8CEa5J30rh2jyCSy7DI0ZnAzRWcoPk+4/w6nTXlAvw6mMFUhCukrgEWv+f9GZywPWM3qadTF6KR4g0LvZaOJbQmbntp/TE2lfNjeSzX7EB2m+rl5MzFN/473CLT6hL+fACIuPDzH3AbYSve8sQIyy6nksVlM6iMA+J8rRIC5ZtU9ioEf2vS6iZ6fGDUYm1x0iB1gErmJwwiYy4tCZIsT8YdER1uR9BpSHKXVhdDnMNjS+tsHY1u79kf9rpWv6GiFveJ2IVp+YKmJdFQ5VFG+B9KKm+eaXbuikuNtTQaxx02s3+W9lEroMIWpWGu0wKnrEghsq5k4fcB99FbNqr1E7H8VX9XqyLhHPRPX946EJZ0m57ktxPSnlFkNaG8GWTxUEroBAkcVgGQYQkU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XlWd9760yVjPKnznqnzDJQ1WrGunibDznkTgP0X1/N8TcIEU7Lme/Lome2e7?=
 =?us-ascii?Q?2nnOG7DX07orhIS8acE0j9d4ncsc9DFxtjHkVXNeM1Fdj+vkINK6zpb486H5?=
 =?us-ascii?Q?WrCR1J9Zr8vD8mNikkb6HKAwEGSOC6kMlFTRyZZriLHpeFNqok69bkXnXNtM?=
 =?us-ascii?Q?wBHiGTSqQHkdR6xbQ6/4gaHYBtXQkx5IZVj0+kkN0GUPSjCWMHiPlbzqz1ju?=
 =?us-ascii?Q?Lrev0F2p6gk3U0JiOnkQOU6LJeU6yon3n2G2zGWOnlJVVADWUOyswCD/EiMZ?=
 =?us-ascii?Q?l9FP2xg4uVfmCxPjotUNG1uMSNn7zccDdeyH8ovxqvTWs5cj2E5XJKZD7SlJ?=
 =?us-ascii?Q?CLA9M31LuzwUJBLXSMdqc/HRmJovKhBjoBL8vbFLRQ3XBln0AQ/WQV/J9hZt?=
 =?us-ascii?Q?gmSALdAwwDlWv8GDOH2s59EC1TWK3BwEyuhkXGrxzFZh+chzaSbdGzlc6J2x?=
 =?us-ascii?Q?Y3E2qss8k9z7n+nKaMyckqfRuRKByAocJAXyxzLZi2X7lBmpKBfShhy3u+WF?=
 =?us-ascii?Q?NpBLmeEWPFvF1eV7JO0IskXYxWlnSW/h17OAVu6zUyje1qeyemevKwe1MfJv?=
 =?us-ascii?Q?7XK4cxXTFZqSk2AHf+aZd2pVktOG5FQg1YFCa9V4E2iCxB4Ecah4BkURwL73?=
 =?us-ascii?Q?N9vJZEfUX9ujeM9FqxDiQThc37yiDBqJL+Av4qS/HesDP2mk64tAT9joqqD4?=
 =?us-ascii?Q?F03tarcHYhy3iD+Fx3rLeL7uYL/96Hp8dcraLvdnFZOxp6J/jeqXxxo8SQgI?=
 =?us-ascii?Q?tc7asGPR/OA93Tf6evr6PPjXmG/8wWNGEH3hCfB47eaLefupytJYhq8R+SOr?=
 =?us-ascii?Q?d7W3vWn56Itlk8JfBAFNLSrEU1lB0fHYgYUBsK8eGfwJPeaMyr1jqtpox+zm?=
 =?us-ascii?Q?2RN84Xei/hbJ46gj2RAOuSZ000bcTY/nvUW522StLdyVPCbzViHvf+ZFMD0z?=
 =?us-ascii?Q?WWiBvvp9MYaWxicPEQit9UTpPTA6yX/F93Wim6Vti9VQ+9sDOHlQPA8BxKBF?=
 =?us-ascii?Q?YfxIeXZAKq5AMQ056wCqoAo7hGtrDoFZuwGTeodR6Bf5NrJGELN6Kz7E+9tH?=
 =?us-ascii?Q?vjtbgj0HqISp09AdhdH0kx90pHMX7AUPj7sPVg/6ZsR1CslNcoqgwuta/UmG?=
 =?us-ascii?Q?/HX6bQAbpprxyXXp2M/StHv3J5rE8DuEfCagxQYXOk8Z8VJMsGt2xXkRC/SS?=
 =?us-ascii?Q?rt6vWQR4snrugY3G0gzgno94rgtxfVLCl4FSQUAc5/RMbVDPfTJ6m81yjalL?=
 =?us-ascii?Q?mHDT10Q/ltskFSjdZGxw67bC3TIV7GjO59kO0A8smOxArqZVYii43NSWc0tF?=
 =?us-ascii?Q?7ard0q9vHkx+B0sBLHhaBSEP3mrc6O03Iz68HUqoLt1/qbTwnDIOOTPKN/G/?=
 =?us-ascii?Q?bz/U4/GAqgtF8Q7bnvbLA3S9R/HXtXKAl8tsc2ALb5xTm851/F5FYBA/mcbZ?=
 =?us-ascii?Q?67cyUn95ls+dxeQqgDMiwrZkuv2Zl76OXXD0kGp+KwpIYD47Y9MW1wbaI9OZ?=
 =?us-ascii?Q?DU8NyZCaWm8ShDWGSUb6Tbz86MH8MMAtMpf9zn3WujSoVDvV9sNCW+E3Z4Hy?=
 =?us-ascii?Q?tPZUsf00GydmTbH86H5ZNHIb3+iJXVL7JGaoob7Gu3ae3nHJCncYNIEh4O1X?=
 =?us-ascii?Q?QmvgaxbIA1iZ4/UD6qmuqreC1JMSnudZr8VK9aF2NbpOFvh5OtDrk13zrNNi?=
 =?us-ascii?Q?rmnP1succNH3tN4BLZ47eTmtNoTXem6KoiIRT/DR77Hj9+Ra8MLKf7QKikeN?=
 =?us-ascii?Q?qSzwJ+g38w=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0c2eaa2-0e49-418c-bf0a-08de7636a027
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2026 19:30:12.5692
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PxnPD4gvtgRcCO7H3+NS6qNdoAmOEpnrIYjQ1Y8L64btZhMTYNWxotkEutCbdtrd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA5PPF3C36BFCB5

Currently the core code provides a simplified interface to drivers where
it fragments a requested multi-page map into single page size steps after
doing all the calculations to figure out what page size is
appropriate. Each step rewalks the page tables from the start.

Since iommupt has a single implementation of the mapping algorithm it can
internally compute each step as it goes while retaining its current
position in the walk.

Add a new function pt_pgsz_count() which computes the same page size
fragement of a large mapping operations.

Compute the next fragment when all the leaf entries of the current
fragement have been written, then continue walking from the current
point.

The function pointer is run through pt_iommu_ops instead of
iommu_domain_ops to discourage using it outside iommupt. All drivers with
their own page tables should continue to use the simplified map_pages()
style interfaces.

Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/generic_pt/iommu_pt.h         | 133 ++++++++++++--------
 drivers/iommu/generic_pt/kunit_generic_pt.h |  12 ++
 drivers/iommu/generic_pt/pt_iter.h          |  22 ++++
 drivers/iommu/iommu.c                       |  39 ++++--
 include/linux/generic_pt/iommu.h            |  34 ++++-
 5 files changed, 175 insertions(+), 65 deletions(-)

diff --git a/drivers/iommu/generic_pt/iommu_pt.h b/drivers/iommu/generic_pt/iommu_pt.h
index 62d6ae2a97ba63..d67bc5a09fccb3 100644
--- a/drivers/iommu/generic_pt/iommu_pt.h
+++ b/drivers/iommu/generic_pt/iommu_pt.h
@@ -466,6 +466,7 @@ struct pt_iommu_map_args {
 	pt_oaddr_t oa;
 	unsigned int leaf_pgsize_lg2;
 	unsigned int leaf_level;
+	pt_vaddr_t num_leaves;
 };
 
 /*
@@ -518,11 +519,15 @@ static int clear_contig(const struct pt_state *start_pts,
 static int __map_range_leaf(struct pt_range *range, void *arg,
 			    unsigned int level, struct pt_table_p *table)
 {
+	struct pt_iommu *iommu_table = iommu_from_common(range->common);
 	struct pt_state pts = pt_init(range, level, table);
 	struct pt_iommu_map_args *map = arg;
 	unsigned int leaf_pgsize_lg2 = map->leaf_pgsize_lg2;
 	unsigned int start_index;
 	pt_oaddr_t oa = map->oa;
+	unsigned int num_leaves;
+	unsigned int orig_end;
+	pt_vaddr_t last_va;
 	unsigned int step;
 	bool need_contig;
 	int ret = 0;
@@ -536,6 +541,15 @@ static int __map_range_leaf(struct pt_range *range, void *arg,
 
 	_pt_iter_first(&pts);
 	start_index = pts.index;
+	orig_end = pts.end_index;
+	if (pts.index + map->num_leaves < pts.end_index) {
+		/* Need to stop in the middle of the table to change sizes */
+		pts.end_index = pts.index + map->num_leaves;
+		num_leaves = 0;
+	} else {
+		num_leaves = map->num_leaves - (pts.end_index - pts.index);
+	}
+
 	do {
 		pts.type = pt_load_entry_raw(&pts);
 		if (pts.type != PT_ENTRY_EMPTY || need_contig) {
@@ -561,7 +575,40 @@ static int __map_range_leaf(struct pt_range *range, void *arg,
 	flush_writes_range(&pts, start_index, pts.index);
 
 	map->oa = oa;
-	return ret;
+	map->num_leaves = num_leaves;
+	if (ret || num_leaves)
+		return ret;
+
+	/* range->va is not valid if we reached the end of the table */
+	pts.index -= step;
+	pt_index_to_va(&pts);
+	pts.index += step;
+	last_va = range->va + log2_to_int(leaf_pgsize_lg2);
+
+	if (last_va - 1 == range->last_va) {
+		PT_WARN_ON(pts.index != orig_end);
+		return 0;
+	}
+
+	/*
+	 * Reached a point where the page size changed, compute the new
+	 * parameters.
+	 */
+	map->leaf_pgsize_lg2 = pt_compute_best_pgsize(
+		iommu_table->domain.pgsize_bitmap, last_va, range->last_va, oa);
+	map->leaf_level =
+		pt_pgsz_lg2_to_level(range->common, map->leaf_pgsize_lg2);
+	map->num_leaves = pt_pgsz_count(iommu_table->domain.pgsize_bitmap,
+					last_va, range->last_va, oa,
+					map->leaf_pgsize_lg2);
+
+	/* Didn't finish this table level, caller will repeat it */
+	if (pts.index != orig_end) {
+		if (pts.index != start_index)
+			pt_index_to_va(&pts);
+		return -EAGAIN;
+	}
+	return 0;
 }
 
 static int __map_range(struct pt_range *range, void *arg, unsigned int level,
@@ -584,14 +631,9 @@ static int __map_range(struct pt_range *range, void *arg, unsigned int level,
 			if (pts.type != PT_ENTRY_EMPTY)
 				return -EADDRINUSE;
 			ret = pt_iommu_new_table(&pts, &map->attrs);
-			if (ret) {
-				/*
-				 * Racing with another thread installing a table
-				 */
-				if (ret == -EAGAIN)
-					continue;
+			/* EAGAIN on a race will loop again */
+			if (ret)
 				return ret;
-			}
 		} else {
 			pts.table_lower = pt_table_ptr(&pts);
 			/*
@@ -615,10 +657,12 @@ static int __map_range(struct pt_range *range, void *arg, unsigned int level,
 		 * The already present table can possibly be shared with another
 		 * concurrent map.
 		 */
-		if (map->leaf_level == level - 1)
-			ret = pt_descend(&pts, arg, __map_range_leaf);
-		else
-			ret = pt_descend(&pts, arg, __map_range);
+		do {
+			if (map->leaf_level == level - 1)
+				ret = pt_descend(&pts, arg, __map_range_leaf);
+			else
+				ret = pt_descend(&pts, arg, __map_range);
+		} while (ret == -EAGAIN);
 		if (ret)
 			return ret;
 
@@ -626,6 +670,14 @@ static int __map_range(struct pt_range *range, void *arg, unsigned int level,
 		pt_index_to_va(&pts);
 		if (pts.index >= pts.end_index)
 			break;
+
+		/*
+		 * This level is currently running __map_range_leaf() which is
+		 * not correct if the target level has been updated to this
+		 * level. Have the caller invoke __map_range_leaf.
+		 */
+		if (map->leaf_level == level)
+			return -EAGAIN;
 	} while (true);
 	return 0;
 }
@@ -797,12 +849,13 @@ static int check_map_range(struct pt_iommu *iommu_table, struct pt_range *range,
 static int do_map(struct pt_range *range, struct pt_common *common,
 		  bool single_page, struct pt_iommu_map_args *map)
 {
+	int ret;
+
 	/*
 	 * The __map_single_page() fast path does not support DMA_INCOHERENT
 	 * flushing to keep its .text small.
 	 */
 	if (single_page && !pt_feature(common, PT_FEAT_DMA_INCOHERENT)) {
-		int ret;
 
 		ret = pt_walk_range(range, __map_single_page, map);
 		if (ret != -EAGAIN)
@@ -810,50 +863,25 @@ static int do_map(struct pt_range *range, struct pt_common *common,
 		/* EAGAIN falls through to the full path */
 	}
 
-	if (map->leaf_level == range->top_level)
-		return pt_walk_range(range, __map_range_leaf, map);
-	return pt_walk_range(range, __map_range, map);
+	do {
+		if (map->leaf_level == range->top_level)
+			ret = pt_walk_range(range, __map_range_leaf, map);
+		else
+			ret = pt_walk_range(range, __map_range, map);
+	} while (ret == -EAGAIN);
+	return ret;
 }
 
-/**
- * map_pages() - Install translation for an IOVA range
- * @domain: Domain to manipulate
- * @iova: IO virtual address to start
- * @paddr: Physical/Output address to start
- * @pgsize: Length of each page
- * @pgcount: Length of the range in pgsize units starting from @iova
- * @prot: A bitmap of IOMMU_READ/WRITE/CACHE/NOEXEC/MMIO
- * @gfp: GFP flags for any memory allocations
- * @mapped: Total bytes successfully mapped
- *
- * The range starting at IOVA will have paddr installed into it. The caller
- * must specify a valid pgsize and pgcount to segment the range into compatible
- * blocks.
- *
- * On error the caller will probably want to invoke unmap on the range from iova
- * up to the amount indicated by @mapped to return the table back to an
- * unchanged state.
- *
- * Context: The caller must hold a write range lock that includes the whole
- * range.
- *
- * Returns: -ERRNO on failure, 0 on success. The number of bytes of VA that were
- * mapped are added to @mapped, @mapped is not zerod first.
- */
-int DOMAIN_NS(map_pages)(struct iommu_domain *domain, unsigned long iova,
-			 phys_addr_t paddr, size_t pgsize, size_t pgcount,
-			 int prot, gfp_t gfp, size_t *mapped)
+static int NS(map_range)(struct pt_iommu *iommu_table, dma_addr_t iova,
+			 phys_addr_t paddr, dma_addr_t len, unsigned int prot,
+			 gfp_t gfp, size_t *mapped)
 {
-	struct pt_iommu *iommu_table =
-		container_of(domain, struct pt_iommu, domain);
 	pt_vaddr_t pgsize_bitmap = iommu_table->domain.pgsize_bitmap;
 	struct pt_common *common = common_from_iommu(iommu_table);
 	struct iommu_iotlb_gather iotlb_gather;
-	pt_vaddr_t len = pgsize * pgcount;
 	struct pt_iommu_map_args map = {
 		.iotlb_gather = &iotlb_gather,
 		.oa = paddr,
-		.leaf_pgsize_lg2 = vaffs(pgsize),
 	};
 	bool single_page = false;
 	struct pt_range range;
@@ -881,13 +909,13 @@ int DOMAIN_NS(map_pages)(struct iommu_domain *domain, unsigned long iova,
 		return ret;
 
 	/* Calculate target page size and level for the leaves */
-	if (pt_has_system_page_size(common) && pgsize == PAGE_SIZE &&
-	    pgcount == 1) {
+	if (pt_has_system_page_size(common) && len == PAGE_SIZE) {
 		PT_WARN_ON(!(pgsize_bitmap & PAGE_SIZE));
 		if (log2_mod(iova | paddr, PAGE_SHIFT))
 			return -ENXIO;
 		map.leaf_pgsize_lg2 = PAGE_SHIFT;
 		map.leaf_level = 0;
+		map.num_leaves = 1;
 		single_page = true;
 	} else {
 		map.leaf_pgsize_lg2 = pt_compute_best_pgsize(
@@ -896,6 +924,9 @@ int DOMAIN_NS(map_pages)(struct iommu_domain *domain, unsigned long iova,
 			return -ENXIO;
 		map.leaf_level =
 			pt_pgsz_lg2_to_level(common, map.leaf_pgsize_lg2);
+		map.num_leaves = pt_pgsz_count(pgsize_bitmap, range.va,
+					       range.last_va, paddr,
+					       map.leaf_pgsize_lg2);
 	}
 
 	ret = check_map_range(iommu_table, &range, &map);
@@ -918,7 +949,6 @@ int DOMAIN_NS(map_pages)(struct iommu_domain *domain, unsigned long iova,
 	*mapped += map.oa - paddr;
 	return ret;
 }
-EXPORT_SYMBOL_NS_GPL(DOMAIN_NS(map_pages), "GENERIC_PT_IOMMU");
 
 struct pt_unmap_args {
 	struct iommu_pages_list free_list;
@@ -1087,6 +1117,7 @@ static void NS(deinit)(struct pt_iommu *iommu_table)
 }
 
 static const struct pt_iommu_ops NS(ops) = {
+	.map_range = NS(map_range),
 	.unmap_range = NS(unmap_range),
 #if IS_ENABLED(CONFIG_IOMMUFD_DRIVER) && defined(pt_entry_is_write_dirty) && \
 	IS_ENABLED(CONFIG_IOMMUFD_TEST) && defined(pt_entry_make_write_dirty)
diff --git a/drivers/iommu/generic_pt/kunit_generic_pt.h b/drivers/iommu/generic_pt/kunit_generic_pt.h
index 68278bf15cfe07..374e475f591e15 100644
--- a/drivers/iommu/generic_pt/kunit_generic_pt.h
+++ b/drivers/iommu/generic_pt/kunit_generic_pt.h
@@ -312,6 +312,17 @@ static void test_best_pgsize(struct kunit *test)
 	}
 }
 
+static void test_pgsz_count(struct kunit *test)
+{
+	KUNIT_EXPECT_EQ(test,
+			pt_pgsz_count(SZ_4K, 0, SZ_1G - 1, 0, ilog2(SZ_4K)),
+			SZ_1G / SZ_4K);
+	KUNIT_EXPECT_EQ(test,
+			pt_pgsz_count(SZ_2M | SZ_4K, SZ_4K, SZ_1G - 1, SZ_4K,
+				      ilog2(SZ_4K)),
+			(SZ_2M - SZ_4K) / SZ_4K);
+}
+
 /*
  * Check that pt_install_table() and pt_table_pa() match
  */
@@ -770,6 +781,7 @@ static struct kunit_case generic_pt_test_cases[] = {
 	KUNIT_CASE_FMT(test_init),
 	KUNIT_CASE_FMT(test_bitops),
 	KUNIT_CASE_FMT(test_best_pgsize),
+	KUNIT_CASE_FMT(test_pgsz_count),
 	KUNIT_CASE_FMT(test_table_ptr),
 	KUNIT_CASE_FMT(test_max_va),
 	KUNIT_CASE_FMT(test_table_radix),
diff --git a/drivers/iommu/generic_pt/pt_iter.h b/drivers/iommu/generic_pt/pt_iter.h
index c0d8617cce2928..3e45dbde6b8327 100644
--- a/drivers/iommu/generic_pt/pt_iter.h
+++ b/drivers/iommu/generic_pt/pt_iter.h
@@ -569,6 +569,28 @@ static inline unsigned int pt_compute_best_pgsize(pt_vaddr_t pgsz_bitmap,
 	return pgsz_lg2;
 }
 
+/*
+ * Return the number of pgsize_lg2 leaf entries that can be mapped for
+ * va to oa. This accounts for any requirement to reduce or increase the page
+ * size across the VA range.
+ */
+static inline pt_vaddr_t pt_pgsz_count(pt_vaddr_t pgsz_bitmap, pt_vaddr_t va,
+				       pt_vaddr_t last_va, pt_oaddr_t oa,
+				       unsigned int pgsize_lg2)
+{
+	pt_vaddr_t len = last_va - va + 1;
+	pt_vaddr_t next_pgsizes = log2_set_mod(pgsz_bitmap, 0, pgsize_lg2 + 1);
+
+	if (next_pgsizes) {
+		unsigned int next_pgsize_lg2 = vaffs(next_pgsizes);
+
+		if (log2_mod(va ^ oa, next_pgsize_lg2) == 0)
+			len = min(len, log2_set_mod_max(va, next_pgsize_lg2) -
+					       va + 1);
+	}
+	return log2_div(len, pgsize_lg2);
+}
+
 #define _PT_MAKE_CALL_LEVEL(fn)                                          \
 	static __always_inline int fn(struct pt_range *range, void *arg, \
 				      unsigned int level,                \
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index f68269707101a3..33cee64686e3ed 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -2569,14 +2569,14 @@ static size_t iommu_pgsize(struct iommu_domain *domain, unsigned long iova,
 	return pgsize;
 }
 
-int iommu_map_nosync(struct iommu_domain *domain, unsigned long iova,
-		phys_addr_t paddr, size_t size, int prot, gfp_t gfp)
+static int __iommu_map_domain_pgtbl(struct iommu_domain *domain,
+				    unsigned long iova, phys_addr_t paddr,
+				    size_t size, int prot, gfp_t gfp)
 {
 	const struct iommu_domain_ops *ops = domain->ops;
 	unsigned long orig_iova = iova;
 	unsigned int min_pagesz;
 	size_t orig_size = size;
-	phys_addr_t orig_paddr = paddr;
 	int ret = 0;
 
 	might_sleep_if(gfpflags_allow_blocking(gfp));
@@ -2633,12 +2633,9 @@ int iommu_map_nosync(struct iommu_domain *domain, unsigned long iova,
 	/* unroll mapping in case something went wrong */
 	if (ret) {
 		iommu_unmap(domain, orig_iova, orig_size - size);
-	} else {
-		trace_map(orig_iova, orig_paddr, orig_size);
-		iommu_debug_map(domain, orig_paddr, orig_size);
+		return ret;
 	}
-
-	return ret;
+	return 0;
 }
 
 int iommu_sync_map(struct iommu_domain *domain, unsigned long iova, size_t size)
@@ -2650,6 +2647,32 @@ int iommu_sync_map(struct iommu_domain *domain, unsigned long iova, size_t size)
 	return ops->iotlb_sync_map(domain, iova, size);
 }
 
+int iommu_map_nosync(struct iommu_domain *domain, unsigned long iova,
+		phys_addr_t paddr, size_t size, int prot, gfp_t gfp)
+{
+	struct pt_iommu *pt = iommupt_from_domain(domain);
+	int ret;
+
+	if (pt) {
+		size_t mapped = 0;
+
+		ret = pt->ops->map_range(pt, iova, paddr, size, prot, gfp,
+					 &mapped);
+		if (ret) {
+			iommu_unmap(domain, iova, mapped);
+			return ret;
+		}
+		return 0;
+	}
+	ret = __iommu_map_domain_pgtbl(domain, iova, paddr, size, prot, gfp);
+	if (!ret)
+		return ret;
+
+	trace_map(iova, paddr, size);
+	iommu_debug_map(domain, paddr, size);
+	return 0;
+}
+
 int iommu_map(struct iommu_domain *domain, unsigned long iova,
 	      phys_addr_t paddr, size_t size, int prot, gfp_t gfp)
 {
diff --git a/include/linux/generic_pt/iommu.h b/include/linux/generic_pt/iommu.h
index f094f8f44e4e8a..43cc98c9c55f70 100644
--- a/include/linux/generic_pt/iommu.h
+++ b/include/linux/generic_pt/iommu.h
@@ -87,6 +87,33 @@ struct pt_iommu_info {
 };
 
 struct pt_iommu_ops {
+	/**
+	 * @map_range: Install translation for an IOVA range
+	 * @iommu_table: Table to manipulate
+	 * @iova: IO virtual address to start
+	 * @paddr: Physical/Output address to start
+	 * @len: Length of the range starting from @iova
+	 * @prot: A bitmap of IOMMU_READ/WRITE/CACHE/NOEXEC/MMIO
+	 * @gfp: GFP flags for any memory allocations
+	 *
+	 * The range starting at IOVA will have paddr installed into it. The
+	 * rage is automatically segmented into optimally sized table entries,
+	 * and can have any valid alignment.
+	 *
+	 * On error the caller will probably want to invoke unmap on the range
+	 * from iova up to the amount indicated by @mapped to return the table
+	 * back to an unchanged state.
+	 *
+	 * Context: The caller must hold a write range lock that includes
+	 * the whole range.
+	 *
+	 * Returns: -ERRNO on failure, 0 on success. The number of bytes of VA
+	 * that were mapped are added to @mapped, @mapped is not zerod first.
+	 */
+	int (*map_range)(struct pt_iommu *iommu_table, dma_addr_t iova,
+			 phys_addr_t paddr, dma_addr_t len, unsigned int prot,
+			 gfp_t gfp, size_t *mapped);
+
 	/**
 	 * @unmap_range: Make a range of IOVA empty/not present
 	 * @iommu_table: Table to manipulate
@@ -224,10 +251,6 @@ struct pt_iommu_cfg {
 #define IOMMU_PROTOTYPES(fmt)                                                  \
 	phys_addr_t pt_iommu_##fmt##_iova_to_phys(struct iommu_domain *domain, \
 						  dma_addr_t iova);            \
-	int pt_iommu_##fmt##_map_pages(struct iommu_domain *domain,            \
-				       unsigned long iova, phys_addr_t paddr,  \
-				       size_t pgsize, size_t pgcount,          \
-				       int prot, gfp_t gfp, size_t *mapped);   \
 	int pt_iommu_##fmt##_read_and_clear_dirty(                             \
 		struct iommu_domain *domain, unsigned long iova, size_t size,  \
 		unsigned long flags, struct iommu_dirty_bitmap *dirty);        \
@@ -248,8 +271,7 @@ struct pt_iommu_cfg {
  * iommu_pt
  */
 #define IOMMU_PT_DOMAIN_OPS(fmt)                        \
-	.iova_to_phys = &pt_iommu_##fmt##_iova_to_phys, \
-	.map_pages = &pt_iommu_##fmt##_map_pages
+	.iova_to_phys = &pt_iommu_##fmt##_iova_to_phys
 #define IOMMU_PT_DIRTY_OPS(fmt) \
 	.read_and_clear_dirty = &pt_iommu_##fmt##_read_and_clear_dirty
 
-- 
2.43.0

