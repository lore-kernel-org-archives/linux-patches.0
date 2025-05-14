Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2068.outbound.protection.outlook.com [40.107.94.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05691202990;
	Wed, 14 May 2025 12:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747226942; cv=fail; b=rrD+gssNZgrC5Fx7acYIpIJHLf8v8tu0uyMc/7sokktc+e/7P7s7DnjWhMzWB1hGX174EQ0/mTTeeVuNBF+Ntkukr7oso8dG/yNsh+IswWi+Ix3q5HVJNC4tx/ZgCJnikqpdsNZCPvEQ/wTCjKXbI1jIAzYyuSUcI/OQ/MhhKNA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747226942; c=relaxed/simple;
	bh=4cvoqe+fhvo+fbJE0w4hFuqK1Fobst4enmNV2AZVV0g=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=I+HQeX4AxH0h5aFXGRCsKvpNS/aIszABK7v1nMtu2gIk0xa5HOyXBVZaF8/d8byBOodR8tRxIwEr+whK3iMY5kPQqnr41+pYnwA7itnLzasenDh/8WjiLiQKAmm/nllI/Ru1HSMCk7YQf6DEkk45ToThz9ZIn2Zuaq5cg0Ds3+w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=B7rzxeeV; arc=fail smtp.client-ip=40.107.94.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="B7rzxeeV"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J7ahF9nUTJiKkH1vaU0MaFYaIZNJ3NGOxmYXRrk3T7OXApOwImdZPflWNBeIE5P9pXU88E0fYncdkUnMNZbYIhv+rmH4oI9cP61jFgBR1yfTrhbs4qyTQRyEMY1iesanaAXK2p5P1SWzBuEXplVBlHp54KX+DJhauaKLDce3ITFYxOpcfdrRA4DZIiAGcH96osLByz/x1qIUvbCRbWGg0No7UBb/1WjFhOuhK9pG3XRKAig3waWHwxtSO3UGjb9Snov3IvcX0Kz1qD21twFgl3j2cthtuVvFzMZKkVn4sE3hx7xt84XhHS+5LIRZr2ha3/6uPo78bqy3JQD961oTyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7PDp0Aw/RoswancuynmxMnnSzqUBuDo889pp6Sg6oaQ=;
 b=XpRqcc+qCe8P82UBfAfuNv0fBNNkRQ3F4VFWmDM6ON4kV8HycsiEPivsyYqTwzg1lbEj55EmuZIvXWNSgvxSaLCnrIWCDRF0E10EmBVPD972EbhwilbFo77ouEKWACV4zUDOvZFHrEs9IEyqUX7KWugjRMS+89wqBBFJQzORylUHm78WUP7qvyqc3QkV1hJOCrg5zG+4afVKEHCoVfbMlxYS2wma7HSoyexVzaja/lpRaHJArx5l/vf0LNet3EK4lvYKR8Vvsa7rqHDl8IsSMWMinVZNv9KGSP/WiXKR7uup8M9gPMInf+RIRYq7r7uySeRAriN0rk5Wq3JMqKzWGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7PDp0Aw/RoswancuynmxMnnSzqUBuDo889pp6Sg6oaQ=;
 b=B7rzxeeVk6ihT3958ADmprEMxYXk8jbaGe0CKmQPzbvn3/5vKXvni+sap4zVNunv14JE069BZmZfhy6+NMl1EaH3908eWhYYr7YR8iNzbo6oTFdN+7F0H6RqfS7U8R96r+b5XhbNVw1LS9D4JgFLY60CXlQDJMUA4u/ey/gT47jIDKHysR6cLewnsMc9fNTQMTLhnTu6F8VFaQE4q5KkCiXaanRldfkdbT582lwegM8aHb+WI24UeLugNzJXMPyL1VQgYQZ0VjZmVoMyd6XGUPWSjQBPq8byg/iJsCKXLji5mH/KqiLfAC2x8FkLtKXOb8JssgcO4KpN5ZnlwRzhBg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DM6PR12MB4138.namprd12.prod.outlook.com (2603:10b6:5:220::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.33; Wed, 14 May
 2025 12:48:56 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8722.027; Wed, 14 May 2025
 12:48:56 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alexandre Ghiti <alex@ghiti.fr>,
	Albert Ou <aou@eecs.berkeley.edu>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	"Borah, Chaitanya Kumar" <chaitanya.kumar.borah@intel.com>,
	Joerg Roedel <jroedel@suse.de>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev
Subject: [PATCH] iommu: Clear the freelist after iommu_put_pages_list()
Date: Wed, 14 May 2025 09:48:55 -0300
Message-ID: <0-v1-7d4dfa6140f7+11f04-iommu_freelist_init_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0135.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::20) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DM6PR12MB4138:EE_
X-MS-Office365-Filtering-Correlation-Id: a0c13df9-c97a-4ca9-8828-08dd92e5b091
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vdA1AmQiuEkbWrNwzlvSplQAH8llpJ0IAu5r/IGTksO9wURON5tA9whvZb4K?=
 =?us-ascii?Q?VnnwO7rUka7Cex0ukxpWFsn6GuxQVNomsZv8roA/AKigvjsQ9fhPcZKIuB2r?=
 =?us-ascii?Q?SjGU1siYb1lPjTRd5xsthvxQMnJcgGsI8kOU1pbDFlZ89vX81h5n5CvHVUHi?=
 =?us-ascii?Q?foto1dsrim+5b1kyTxguZ5tR0fUsMvEKU92v4rfdJldbQgxSOKegMa+N8i7W?=
 =?us-ascii?Q?t0dBi8/vrUMUsepDQKiMNjCq64Tf+/qXukL/jSXj0PU7YlTaa7TssfU2GTp2?=
 =?us-ascii?Q?AwgROX6ceHotnx+f6CpCUlmNhhqSM7vDnXz9wxDKnskftYFdU1MHHwq+KLGe?=
 =?us-ascii?Q?2gQX1IKqLVbGjMMrbEextaVf8cLzXDMfC6+erfIgaOuU7UN464k8m08D3HOt?=
 =?us-ascii?Q?XNIfRgFHh+DEVpJd4NCg/yB0TuSEhmr4mSn6sLzmfYLBPAKIz1ZNUSZfCDh9?=
 =?us-ascii?Q?3oqBegL/MPEHM5yMQJltcfrnD79hL9LpKNBhtT5x3RCtUoSQ4GXVc/iZileH?=
 =?us-ascii?Q?UBlBqM14x8u21ktEhSc4xF+m1TTwtlh+MAxRdCZOA3md7NI/9ya5w5Eakbp9?=
 =?us-ascii?Q?jJevbAytaBH7b6CWBuTjqfpU9VcOoOgFHGa/OFyEMfW2Uhh4jvrvtyXk4iq6?=
 =?us-ascii?Q?asoKGLhu8BBU9gMjz+nCSzGHSGUTwdQb4rlz37LTWr8PPqIqWNBqQJtM/BrJ?=
 =?us-ascii?Q?Z/1BnPvy+hd+cXW4gk22/KAvgOf2+5jWZ8NL5ysrKFPLMZu2pxBc1kAGtQ7V?=
 =?us-ascii?Q?MkYpHZjIT/Z0u57QZBEhLwMlnYwiErXYO9e8+cfE34NXDWm6vx216aLZLTGn?=
 =?us-ascii?Q?LzGWlIzdpQmZg/w3KPVM6CkPNek8x+du526YoDV3dwxQRgGgw9YZe7PIG13w?=
 =?us-ascii?Q?yxJFigAYLDyARQ7Lf14vl5FeXjbUiDVEgW3nElsnA0K2BzPcKTwLW3x+xdYx?=
 =?us-ascii?Q?t3eEe/ehJ2lY7mgmWCTSdDN3gOhzO/uLCcz+mWZuHe15DHWYqVjqyvN0mryn?=
 =?us-ascii?Q?cJYXKyUBJ/b1zYcAhE0g8ZixgwN6LxD5DGveAHU8njlFO2Q7z0ebPShXhjyb?=
 =?us-ascii?Q?RiVNGtXFsHAPC7/ZuuNfpFJWmaxIPzDS5k4TG0vGvSZxKpRDCDoBOmQlV84d?=
 =?us-ascii?Q?5pw/HUX9ud8vkl0CwNX/o0+bx8yOw9T1cINT4X5jUndhkJV42LFTI+UyiY70?=
 =?us-ascii?Q?vp/s4V3mef82Xs87kvBWd01sye6AjDt93wXG8BKGiQOQGv28wzi/o0hZsj7a?=
 =?us-ascii?Q?9gtT4wrqaoXvj/a1IEQB/EwfDbjs7ciHfPnXuNZe20k3p/KNJ9w0BEas0AHs?=
 =?us-ascii?Q?U1acruZKKqdH3Hec1NlKleB/y/zXiZ5K71HPZntaItYwNJd7NUVp2hh9S6Li?=
 =?us-ascii?Q?Jj2emG93+OqS3/YkDEmAPmdP7Ll+IbiOJoxfblrqaczLb8CDwBItWkGqzjGz?=
 =?us-ascii?Q?BeVZ/nmNwTw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?N5v7+WWGACpjYLIz4xHGbhYTljc24Q8yEjyw6Y2FuXiWDa+Dj3z/HaPEcd2/?=
 =?us-ascii?Q?vKMjufdU42ryzCGVQgqoac7F7/CqiV2h7+k/wSusncc2DoUUqKJGxfKWA43I?=
 =?us-ascii?Q?e4uYps7z4oy87PaH5wAj5hJLWH+PnyN+UjfLvM1SUIarlfno+1Vxed67kK6/?=
 =?us-ascii?Q?Pn4eQMUahdav3zF5Yi8e+/f1CHHCwnAvz8KtPF+OvSTvvuzSpWMfG0CGsiTW?=
 =?us-ascii?Q?ReCvFlNobb4XJA7pbbGXiUg2PDCto4eRNmy2TpjLgiz4v8uEORWKoHQl8GED?=
 =?us-ascii?Q?GjlGAj8YUPsDBa8KQc6xymbMh3cHp2Bsvi65wW0wrn8OTrBFx13LXZRMxr3J?=
 =?us-ascii?Q?+K9SY8kN3LNj3SOdxZtzmulgKGyd3QFfIu7YocvRZ7lUIEPRyZEFAoVrG1Ia?=
 =?us-ascii?Q?56KP1yiPVOtlYOOjelO3LaPzUn+0/6CtpG1EzH6IKUaH4lKTLjSEN+ZNxvL5?=
 =?us-ascii?Q?HYOTa4YYo7P42GzrHc5wZ6xZHRFcSkvQ57z178LYQKAZgCpJ/TQUOy04wjgs?=
 =?us-ascii?Q?N842kFJdPX0bR1mnw4ZsnLWTuPCY6Q7/UV6gzuU2Yj4Eq2e/g7CxM3NtrmN8?=
 =?us-ascii?Q?Wv/Z6fQC37YZ2L+kn0PBRnUxP9X3jmt/93XYgUNGpztb/JmmdD38FZeoqLJg?=
 =?us-ascii?Q?nUfCOYJpa5FGrKev0NKHQz0bk9IFsF0R3cQ7Z3urkAAEdE2+AF0ho0T+2jWS?=
 =?us-ascii?Q?B/S6iI4ITJha1IonfTR7ZoJDlzd9pVuYhgAE9CF7hupRczsDsiJvDrcfRWGu?=
 =?us-ascii?Q?AM2M8hLU1DapSo2CBivS5YeEP8zBUyQctpXNAvh1Sk8r3PBC3Ns1ndQAa1gV?=
 =?us-ascii?Q?A/bSrAbeQWGmpc/C6pkcSMc9z7HejpFiNSl1dzqSF4uHtjMGMNgR2BfQkNjM?=
 =?us-ascii?Q?f/EUxf8lElkDAVwo004kuQvYCb4Oderd43le98QcBg+Mgn9OWnO3GYFwRTN/?=
 =?us-ascii?Q?IUKEouRXCS8k97wiGU0S236MJCe5kwwEg8R3RnBxaBDanvY0FT+85JRAARa2?=
 =?us-ascii?Q?nQsecZNKqc8y3B+e10UW+lpBI3JBvDn7+R0SHp2Ua5orJ3xX4V3cHqgUHGH8?=
 =?us-ascii?Q?Io0dwnci4tnrWeSf6RlHTHMqne8bl4GOB9ycwTYzxZWAcQSmzi2jpbolDmfK?=
 =?us-ascii?Q?oUzu7HF1YyQS5/Kl6oiDA/f+6eqwSUUEQPBV071W9Qcc+DCc8dtu1dYKoHdn?=
 =?us-ascii?Q?KmB2WSKeP8+KQ9w1B4nOV37pvKs+A9m3E4LQq/fcfSyjrncPmVECRkTjjeVE?=
 =?us-ascii?Q?qqZ2X1NMi3c9E4qKYr2UjvL1R39Qi76L86poxIsp/RwfIbsfYSnKKYnRPQZn?=
 =?us-ascii?Q?tnJSxZePjSs1yNYFPsjLpeUvLXdPHoUcQn8k1aG/fKQeyKg0ed0c6oyzsVxm?=
 =?us-ascii?Q?9AXD6RMHN9Hhcd7oCgJfjCoy4rBlHdnIvxcrgZKSALofplYcnIdFLkxQ3cPb?=
 =?us-ascii?Q?coeSoC1umdgn4c7+mwph8YxcuHR8mUgAYQEs2gf1/sXBOzTr6zwKsyEe1rUD?=
 =?us-ascii?Q?9csIkJNniAmR/8g6KcG34yPgsxgWajyBEGrhtpFXh7nFoSYuSjCmOxbuAw9I?=
 =?us-ascii?Q?UJ3Agya+MgIf3fhNNMOz9bFpQ1EXBsU2dsxw9uEs?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0c13df9-c97a-4ca9-8828-08dd92e5b091
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 12:48:56.6486
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0j6G7Y06MjIjG0Fk3LG77XjlCZxwPJBaf80JsszyfjRNVBYTFLqteY7Y9XpSl+xx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4138

The commit below reworked how iommu_put_pages_list() worked to not do
list_del() on every entry. This was done expecting all the callers to
already re-init the the list so doing a per-item deletion is not
efficient.

It was missed that fq_ring_free_locked() re-uses its list after calling
iomomu_put_pages_list() and so the leftover list reaches free'd struct
pages and will crash or WARN/BUG/etc.

Reinit the list to empty in fq_ring_free_locked() after calling
iommu_put_pages_list().

Audit to see if any other callers of iommu_put_pages_list() need the list
to be empty:

 - iommu_dma_free_fq_single() and iommu_dma_free_fq_percpu() immediately
   frees the memory

 - iommu_v1_map_pages(), v1_free_pgtable(), domain_exit(),
   riscv_iommu_map_pages() uses a stack variable which goes out of scope

 - intel_iommu_tlb_sync() uses a gather in a iotlb_sync() callback, the
   caller re-inits the gather

Fixes: 13f43d7cf3e0 ("iommu/pages: Formalize the freelist API")
Reported-by: "Borah, Chaitanya Kumar" <chaitanya.kumar.borah@intel.com>
Closes: https://lore.kernel.org/r/SJ1PR11MB61292CE72D7BE06B8810021CB997A@SJ1PR11MB6129.namprd11.prod.outlook.com
Tested-by: "Borah, Chaitanya Kumar" <chaitanya.kumar.borah@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/dma-iommu.c   | 2 ++
 drivers/iommu/iommu-pages.c | 4 +++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index 0af1ab36283cba..7d2b51a890c75a 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -154,6 +154,8 @@ static void fq_ring_free_locked(struct iommu_dma_cookie *cookie, struct iova_fq
 			       fq->entries[idx].iova_pfn,
 			       fq->entries[idx].pages);
 
+		fq->entries[idx].freelist =
+			IOMMU_PAGES_LIST_INIT(fq->entries[idx].freelist);
 		fq->head = (fq->head + 1) & fq->mod_mask;
 	}
 }
diff --git a/drivers/iommu/iommu-pages.c b/drivers/iommu/iommu-pages.c
index 4cc77fddfeeb47..238c09e5166b4d 100644
--- a/drivers/iommu/iommu-pages.c
+++ b/drivers/iommu/iommu-pages.c
@@ -105,7 +105,9 @@ EXPORT_SYMBOL_GPL(iommu_free_pages);
  * iommu_put_pages_list - free a list of pages.
  * @list: The list of pages to be freed
  *
- * Frees a list of pages allocated by iommu_alloc_pages_node_sz().
+ * Frees a list of pages allocated by iommu_alloc_pages_node_sz(). On return the
+ * passed list is invalid, the caller must use IOMMU_PAGES_LIST_INIT to reinit
+ * the list if it expects to use it again.
  */
 void iommu_put_pages_list(struct iommu_pages_list *list)
 {

base-commit: 53a79ce36c832fc4832a9c2c730a9b0f2a07189e
-- 
2.43.0

