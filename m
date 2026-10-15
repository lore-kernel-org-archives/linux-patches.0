Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010059.outbound.protection.outlook.com [52.101.85.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE28C2F8EBE;
	Thu, 15 Oct 2026 17:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792084831; cv=fail; b=jMs63jpREuhyjKvXfemQa4nFe7dy11F74v9XMGKvp3KqLfdEd7DIu22323MeZkACViqb3KcSKs+EKYkR5TY8iB2j6yLDTF0lOHo4uazhXnNiQxoA9tkrqLoItlxojjcCV3SgowjVkAG7hqNyIzTQ+ajWC0mk11Flvp4nhQSu0Fo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792084831; c=relaxed/simple;
	bh=QorRlWhKYujns+kciTqiNjBV9Vr3+1YAakFlUlEkgu0=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=NuSYRh6A4AWZLaYyarQ26ftVir4G//Ud8VURu5AcNZuY1CYGPM4TNl/0fR0J+vq4EBMd65BHXwbqfupNwRGP+n3FGKSbRnvWVm9hbk213biixRaPu/zRu0gxDM9GrwNAocqUsoX+UOlR4ctwngqb9Kcg3GeFpdUBBIfhFq4t/1o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=fDLokvSx; arc=fail smtp.client-ip=52.101.85.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="fDLokvSx"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TfI/PYI7LB2WFEDDJqsXg7pRdrLIW41oR9iPwsI7+q/uRqia39b03bqR5y3JkN/pCWlHEmq3Q4U6oA98Od6WpQcuzD2aLSQIw6aYUtixDnwYooG9V0nzXBpeSx9MB7pr/aXly9parCNRUmH0DB2rMV/C16rXvtqJhala/BTFTkR2Gtb7amejabUgiLfzoOAVskz+R2R6y8pZ1PeRSQVGVrycNPQSfs9/b5ap1w0aIqcHZeA5rJbc9v+XBb9kRHhqcA916Y97E5Nzf31qJccGf8OONawBaMMGpr4rRNZ0apIqRaT29jbO1SU5X0lyezBYwv2280g1gGql/IHPhk6w+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nYgPKeh1pANm6V6yGqkoKLySIr3DAS7fl8Bx2wmiGeI=;
 b=BUOZI6Y1kD0tBnxMCNfopCysKn087cdtcJAiwNGpJT7SPJ1dYD7GLkmTJgR0AB13MTr7HOu00yTHLhG93jiIpEMs+H4zBdFbbJidIyyfzOURoK36NM8ToHX04wpGKJ0dyq29HzmdT6UMto3QejZICH9+81/2UPN/2Qom4mc1qpbAHHc6S1tN/p/fRFRekc66NNRay9SeaCX5j6JFImrPqru7jcdRGn4BeCGoN9CmA1j0K6VlbsU4fz5NBWrcdAUq+s3KN90in0yqC5eQBAHqVmpWjnrtiHdEsNH5pzp+fH1FVzVHnDfoJCKqWpeDKnW7wrqff0kGJdsh6euWThou0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nYgPKeh1pANm6V6yGqkoKLySIr3DAS7fl8Bx2wmiGeI=;
 b=fDLokvSx0pEQU3GAjutFBrqYkbtZW6cU56ycC2f0BpJAeVEp710RxHHZA9FJ3rEDe16SLL3QF7TSQa/JLi9/SMbTxQOG5Iv5gvaWZKkJLwaHpdVkw6ucIgY3yGVINovhFYkTnzs1rissCAy1u3MJAnBxONC159OUSSVVKT+V2/wwuzJRTRRGBSagoHONol+y25vdoxBuIJg/hWGqSCSFSSDicsxPhz1oJPXA35+VuIioykVbWH25Kg1IuZYb4M4UiMlPQqSiv9dW2iQ1xwQk0wZdmInR8IC25iuXJ3PU8sbxLywfIn3oeUFhZ+3leUXTyMbLffk8yvJPlmrgNgOhJQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by BL3PR12MB6427.namprd12.prod.outlook.com
 (2603:10b6:208:3b6::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.23; Thu, 15 Oct
 2026 17:20:11 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0522.013; Thu, 15 Oct 2026
 17:20:11 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	linux-kselftest@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	Samarth Narang <samarth.colleges@gmail.com>,
	Samiullah Khawaja <skhawaja@google.com>
Subject: [PATCH] iommupt: Do not allow PTEs to be split when dirty logging
Date: Thu, 15 Oct 2026 14:20:10 -0300
Message-ID: <0-v1-5bb926ff73ec+576-iommufd_dirty_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN0P220CA0006.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:52e::30) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|BL3PR12MB6427:EE_
X-MS-Office365-Filtering-Correlation-Id: b8293ef5-130e-4785-6ba1-08df2ae0918a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|23010399003|376014|366016|10067099003|56012099006|261009223027099003|11063799006|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	9KZztzo8Rx1h24tLAjsvbcjXYFO5wXGS+SwXuxSYWGyquRtQVwe+mqxmUSWCqrU1ugaHfczimyl354sfhsY6eGsIOVheo5eBrupRiBhsGL3NoIpZn2kTx6q+bstP1smsDIF6tt9UZuc6QJKhrs8Zzw0uEFKrmu8x62WA7jqzVWhEUHAFGEandirc38StER0nQbs16T+Ab+pXQWtU4xw67N/nhEkpEYl2Up2Js2/DTSWL7MJj6c0LfFLl2vweuXLrNLpxcmE9pbotf9ceioFzactJvyqeMYzXxsKLQT7qTrHC3x/s/HHIc8aeCkcVerHgoYYGmc1Hm31+x0mHZbFvA93Xo1f/nC9Gf7gq/WDmm1WkRFgKkYj3CYuHs7wFcGByLqeF9ORBKRqnstX0Gt6/EBAK2YGceMldWarIkUZodVga45xJJXzT+Aaoo357BdaaOGiCBYaEZvYE6WLlZ+QSgntg3idV0LYNzdO2XjKA0SfVoofhWhJrSOjUSC5axNlnRGoZMQURoNz1la5vUHyNs3JZRzAfL+MxwAw0XJUncZnPw0RRd21nwDHDQZHLimrLnkkzLg/3FbnF0XNUFI1WFOmJe6204a4lwAHKIdmf7LxQFHB0ny682zY7lFhC3h/O7nRRL7CnC6VCQkQuIrhVwFM9N5zojSl00O2n7gQI/Xg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(23010399003)(376014)(366016)(10067099003)(56012099006)(261009223027099003)(11063799006)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vXkFeCl7zBEYBs6kHOabW29QPqJQqCUH3H5sMw2juX6WXzt1k1E3RREfjXd9?=
 =?us-ascii?Q?PSgiFT3lWWrLRwAzL0oQb+FlcY6iR5L5WB+MFJ6JBSJYNsLj9BJ/fg/54koi?=
 =?us-ascii?Q?hOo37j8pFvVpcjEJh6AcjOygHJahfG1bgH4X5yqc/wN9nDxy7oPvtFJ4Wdeu?=
 =?us-ascii?Q?yvPNkgZwsEY688+/YWeT4cUCd91ToGWfksxPxkZCwcqcw5li8we3k8+vcsAt?=
 =?us-ascii?Q?/tREap7wY5U35Wuc4g0Aj2cfVt9czMNBR+R6rwWfjSoAA10ai3NE3tzTC1Em?=
 =?us-ascii?Q?9d00reTd+wgRdTi0FFMRb0CogLGZxhAUflAF2q4cbWykgUXluFrjEE1g4U5g?=
 =?us-ascii?Q?samQ1Dw+IEN9HuFG95c1X1Z4RiEpehF80aCAA1+USx3j3cspL2avuok9tFdH?=
 =?us-ascii?Q?oIefUuqOhweeMcVCZv/DQ14j4fr1thpsXfm1yxEf0C2LJYR7Y3HI+TZxcVmt?=
 =?us-ascii?Q?GEt6wTi2WhV6YWg653dqNaFZGq/w1HfHT4NOMKqaWITvvvfGoPNTM0lXiGCI?=
 =?us-ascii?Q?0KVSGpZEEqtbutqpp2NIR34o38KtUQFk6zGGyJotZXwuT4maEP8PeKdt8+On?=
 =?us-ascii?Q?Z4n+8bi9qQXso17Lhqz8oPhU1BsaXwwnljwdq4JcIiHvs/8C2OFq+K2jUTcO?=
 =?us-ascii?Q?DJx0B/X7pE8jvol+pkdKjygSylVx5qWd1zuY7+75mTLKp2dBrlmNysp1ssU0?=
 =?us-ascii?Q?EHwGoUHCYX9hoML4piSYjwO6wGzHYjTR/YNcdw/d8uM1OF3cxeUHv9+qZZCD?=
 =?us-ascii?Q?+kR7LBSDCK6gTzutvinFi0FUTgsl8K8tKOB/xSBfPn0VzBRbEGRsVZTDifF0?=
 =?us-ascii?Q?iRXBgw9uuLD0Q3mRQQPkbalrhOBYxV0VpLYqcyvoPJh1nvA0dqYzLP/Wh2TM?=
 =?us-ascii?Q?yddXV8HbCgEgs3KLNt9AsgcEJn5Pgk+6raTkgGVxmjBPBaZ4MSsZ8k4nsYUV?=
 =?us-ascii?Q?qPCFOePE90nqpYg+sTgIUuCre/Aj10vNhQpR+HNpm+S/FqkNfURjRIkCUJFg?=
 =?us-ascii?Q?dN6+wLJzPa5pOyLUAz3vziGFLu6pp+URsfXVR+MB0fKYsz1UY+3xDUrhrm8Z?=
 =?us-ascii?Q?fxQgjOMt/6geRrYeTKf4zM6HLPjHArYtjTOkHKBZgUyfFo24t6HtLcHpryPd?=
 =?us-ascii?Q?kMnK5LASWIJfQikE3GpR0dOD/ULuqRV+2VvJ6rMLXyRr1ONnnFKrGFjqLbff?=
 =?us-ascii?Q?Y41PK+skqdz059jR82qV/WfzApBWyMoDu17eQRRjUxTqhhd7A126fMbq0mC/?=
 =?us-ascii?Q?d94XphgXvIXYrcDng4hDnxpsbqqv8PTKK31PRN445PSUZvf+RrflEVV/2ztX?=
 =?us-ascii?Q?XSW0cXbrswOU/xiQ3KEEYKqatuEVusY8Sv4yuNGqTE5uViMY8AK/9mlu48O0?=
 =?us-ascii?Q?avHMGpwCmSWyPo+5jfVZP8TYL34bvCxo7lnc+umh7cexm8tGzD97HMTeTuH+?=
 =?us-ascii?Q?JmAv17fzBwopu3rThbTTTjX54z7Ld8bgSsifTMayQlr+0l1lkYkAEeL5JTzR?=
 =?us-ascii?Q?DAA0GdnBRH/OAGgqNa9japQS/S1oL/bp5zcTFuBPX9wDWOvKNQFJicTYDY62?=
 =?us-ascii?Q?jmzmjKiT0tysAIIzm5ALvW1AiyEv/RNo1VLWJOqmUPzlEdTU9ide0XaRMzh2?=
 =?us-ascii?Q?wJcBQe/GQuNVVP5SjGwzm9mfRDnE+lSIRhwrQgf8Z8Q8+pg/MJZYnE+tPTJ+?=
 =?us-ascii?Q?uRC+swT4eWwuHiS5Gnbz9yXpyKj9BxhmJCVxDcKOC8XgCC33?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8293ef5-130e-4785-6ba1-08df2ae0918a
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2026 17:20:11.3501
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JcDE4wW39OP2yeIsdfwM8WVE7371S81hT2KBy7xFpz3CPlky3hlTiCsNC6k4VD0q
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6427

If a single PTE cannot be stored in the current bitmap that should be a
failure and reported back to userspace. Allowing a PTE to be split creates
a possibility that dirty memory will be reported as clean.

The gather must also cover the entire PTE that is being cleaned, not just
the part that fits within the bitmap.

Fix both issues by computing the full IOVA range of every PTE and using
that to update the bitmap and the gather. The bitmap code now rejects
ranges that don't fit in it, and the gather always combined ranges.

The selftest quietly relied on a bug where the CONT was split, that is why
the half page size for the mock domain saw alternating dirties. Increase
the dirty test page size to PAGE_SIZE so it still works as intended.

Cc: stable@vger.kernel.org
Fixes: 4a00f9434891 ("iommupt: Add read_and_clear_dirty op")
Reported-by: Samarth Narang <samarth.colleges@gmail.com>
Closes: https://lore.kernel.org/all/20261013165814.309255
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/generic_pt/iommu_pt.h     | 30 +++++++------------------
 tools/testing/selftests/iommu/iommufd.c | 10 ++++-----
 2 files changed, 13 insertions(+), 27 deletions(-)

This relies on other changes in the iommufd tree so I will take it

diff --git a/drivers/iommu/generic_pt/iommu_pt.h b/drivers/iommu/generic_pt/iommu_pt.h
index 07ec2b3ab986a6..837d835e4fad8e 100644
--- a/drivers/iommu/generic_pt/iommu_pt.h
+++ b/drivers/iommu/generic_pt/iommu_pt.h
@@ -240,27 +240,14 @@ struct pt_iommu_dirty_args {
 };
 
 static void record_dirty(struct pt_state *pts,
-			 struct pt_iommu_dirty_args *dirty,
-			 unsigned int num_contig_lg2)
+			 struct pt_iommu_dirty_args *dirty)
 {
-	pt_vaddr_t dirty_len;
-
-	if (num_contig_lg2 != ilog2(1)) {
-		unsigned int index = pts->index;
-		unsigned int end_index = log2_set_mod_max_t(
-			unsigned int, pts->index, num_contig_lg2);
-
-		/* Adjust for being contained inside a contiguous page */
-		end_index = min(end_index, pts->end_index);
-		dirty_len = (end_index - index) *
-				log2_to_int(pt_table_item_lg2sz(pts));
-	} else {
-		dirty_len = log2_to_int(pt_table_item_lg2sz(pts));
-	}
+	unsigned int lg2sz = pt_entry_oa_lg2sz(pts);
+	pt_vaddr_t start_va = log2_set_mod(pts->range->va, 0, lg2sz);
+	pt_vaddr_t dirty_len = log2_to_int(lg2sz);
 
 	if (dirty->dirty->bitmap)
-		iova_bitmap_set(dirty->dirty->bitmap, pts->range->va,
-				dirty_len);
+		iova_bitmap_set(dirty->dirty->bitmap, start_va, dirty_len);
 
 	if (!(dirty->flags & IOMMU_DIRTY_NO_CLEAR)) {
 		/*
@@ -268,8 +255,8 @@ static void record_dirty(struct pt_state *pts,
 		 * dirty tracking bits can't work together
 		 */
 		pt_entry_make_write_clean(pts);
-		iommu_iotlb_gather_add_range(dirty->dirty->gather,
-					     pts->range->va, dirty_len);
+		iommu_iotlb_gather_add_range(dirty->dirty->gather, start_va,
+					     dirty_len);
 	}
 }
 
@@ -289,8 +276,7 @@ static inline int __read_and_clear_dirty(struct pt_range *range, void *arg,
 			continue;
 		}
 		if (pts.type == PT_ENTRY_OA && pt_entry_is_write_dirty(&pts))
-			record_dirty(&pts, dirty,
-				     pt_entry_num_contig_lg2(&pts));
+			record_dirty(&pts, dirty);
 	}
 	return 0;
 }
diff --git a/tools/testing/selftests/iommu/iommufd.c b/tools/testing/selftests/iommu/iommufd.c
index 44193d171ba98d..ca2b35e9d443a1 100644
--- a/tools/testing/selftests/iommu/iommufd.c
+++ b/tools/testing/selftests/iommu/iommufd.c
@@ -2175,9 +2175,9 @@ FIXTURE_SETUP(iommufd_dirty_tracking)
 	test_ioctl_ioas_alloc(&self->ioas_id);
 
 	/*
-	 * For dirty testing it is important that the page size fed into
-	 * the iommu page tables matches the size the dirty logic
-	 * expects, or set_dirty can touch too much stuff.
+	 * Disabling huge pages maps in PAGE_SIZE units, which can span
+	 * multiple contiguous MOCK_PAGE_SIZE entries. The dirty tests must
+	 * expect the entire mapping to be reported dirty.
 	 */
 	cmd.object_id = self->ioas_id;
 	if (!variant->hugepages)
@@ -2335,7 +2335,7 @@ TEST_F(iommufd_dirty_tracking, device_dirty_capability)
 
 TEST_F(iommufd_dirty_tracking, get_dirty_bitmap)
 {
-	uint32_t page_size = MOCK_PAGE_SIZE;
+	uint32_t page_size = PAGE_SIZE;
 	uint32_t ioas_id = self->ioas_id;
 	uint32_t hwpt_id;
 
@@ -2377,7 +2377,7 @@ TEST_F(iommufd_dirty_tracking, get_dirty_bitmap)
 
 TEST_F(iommufd_dirty_tracking, get_dirty_bitmap_no_clear)
 {
-	uint32_t page_size = MOCK_PAGE_SIZE;
+	uint32_t page_size = PAGE_SIZE;
 	uint32_t ioas_id = self->ioas_id;
 	uint32_t hwpt_id;
 

base-commit: e21952d72b4740f08a272d694cca223b6b0099ca
-- 
2.43.0

