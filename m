Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011039.outbound.protection.outlook.com [40.107.208.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B8F733D4E2;
	Sat,  3 Oct 2026 01:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.39
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790990662; cv=fail; b=Oqq2amYhkzsaSi3TMLY3MihlnDJYLWlXhnKny/LfH3RyryRJpQmmtdijNwiP2VnoNolEWStmEemA9wACIQLL4AspPzvsYdofVieYBy4xb3ZXEyBm3Ri1JEkBNmPOIk+WpNCzIU1bmEA6QHWtPIz/ApAQxvkJumicJA4qMRWGD78=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790990662; c=relaxed/simple;
	bh=b/gxuUEh5CefnjoD1SIePdXx39WJTK8R1EP/qww3yss=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=qlObLt2z9mtUAaepbxScls8HzvINduwD4oainwna7ucREAefcI5pY7TXXlHy+nYz0NQimo1crLnuYYoOBK5MZjSPDVhBVIeTCb8X56tFN6pNS5a/9slBI/SfEvLxFK6sFVxGndr4eBQPR95rQ9Kr4bCJET+vLgWkobI7EBWe5bo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=YxSkaXUA; arc=fail smtp.client-ip=40.107.208.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YxSkaXUA"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Enidpcq5vWnsAkmzc1bNiw2Lp1ku5RatFFO2ZeKVZmhpFCcBCPtHOdsrsiI06lZdqWIwKOVKmjV0jcIzAuKQX38UGo+yTwRXJ7xnojPp1AcA6tRKDdBIMkeMzhSPnnEOr0qGlIrmPUwhs3dzv3GWh2Lu+yWf6v1Uv3qdxKHhwq/dSFKFScn4Rz+jeeHLD0z/rO/maOG++VMnXyRoeyUlbAuqQVJ0wdBtAkPFg2wan0TfgTtFxtksJEkBJyrXRooq6PRiWTUwymPuOjL7jsuyjLP5xFiksvdMNs7GkFh5o+l3aAcy5lUsJ85nWRsBw8KqT/37epGbdZASKHE00ZECHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QcyJYL8gAasVAWf4kbjvAZwkcxrDupGNjBA6llSwu/U=;
 b=ekkZQJtrZ776HAvej8MNgC41fUtQEogjWXXO57qE+p31GB+Tbrp4dG3nrzQZafzBacB6dKYO9oaR3hFmwYz5OY9OKhpe0xKqDdU5VHqeRNIwbUJ3qKnxWY5bnSCl/qbR651qTLsOwI180r+uywfwVqEGNlW9dVQ3w8JL5WtoaaZxEfksfQdQYvQE6IhYO7omV7Q8ZDcVlaKnk5imGPk+SJlskBvqyC4BWYPzcunzXUtWtjcszilg1cl/GEh7PvMcPW1h4Uu66NTxFEJDI1fA32jzdW+ZFzi1zmhLImIAEVFLKp95zRgoejfe/NTJ0HASleghvv3J2TpGg4lt1YZdug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QcyJYL8gAasVAWf4kbjvAZwkcxrDupGNjBA6llSwu/U=;
 b=YxSkaXUA1Q7eWDoLSW+GRHtQpskjpx6KpXsQYq8X4kEbQRRMOm+pZh2GANINLptqkl2N7BfKky2W3Oo0BAxX6exrG46hNMroNkivnXFqHPVGgs4mx3gVuNViIgTZyIvA735qMkbm867I6Kh93wCNCjpQWfEoGfgpF/tQt6eKxmWHRpHwzQMcgN7H8W1J8RptwdkEFzx6Xiqjz/+485iqm8fLs/9mQGzpYhmsSEp+txlOCPuT6OHBcn2o1x9/CGccsC9CJOdh1vBG5QpQdD/QGAgCryjhQThRWMKgG+F+Jucbvpv0XTWS4sQAesi2CtZCGQ7MedF/eDkTzbpSUE6mSA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by CH3PR12MB7641.namprd12.prod.outlook.com
 (2603:10b6:610:150::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.26; Sat, 3 Oct
 2026 01:23:31 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0472.016; Sat, 3 Oct 2026
 01:23:31 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	iommu@lists.linux.dev,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org,
	Mark Rutland <mark.rutland@arm.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Will Deacon <will@kernel.org>
Cc: David Matlack <dmatlack@google.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	Pranjal Shrivastava <peaan@google.com>,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	Vijayanand Jitta <vijayanand.jitta@oss.qualcomm.com>
Subject: [PATCH v8 0/9] Organize the SMMUv3 invalidation flow so iommupt can use it
Date: Fri,  2 Oct 2026 22:23:19 -0300
Message-ID: <0-v8-1eaaed5e0433+3d3d2d-smmu_tlbi_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR10CA0028.namprd10.prod.outlook.com
 (2603:10b6:a03:255::33) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|CH3PR12MB7641:EE_
X-MS-Office365-Filtering-Correlation-Id: bf564a5b-bc1c-4f95-3a24-08df20ecef74
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|23010399003|1800799024|5023799004|11063799006|10067099003|56012099006|18002099003|3023799007|921020;
X-Microsoft-Antispam-Message-Info:
	HXH6qlqOzJRefpf0quMdPm4caVSBEO1iwZmuC1h6OaqTLK3k1aethAkJD0k38WMG4SRVyPkK7bkHcIm81X4GAyfvwewxz6mkWGwbqo4L0G9kVRW+Eq8uijaFfkT4ODp2wUQ8dHYqVoySGEK8vbz0WPEqGXdbfwvSHH+N8vbe2wko0y45LI1StRRyaeI4618zxu49Azb6c6qoDKf3FHrx3sElNFTElP+NvbSsuoSgFJZYlGjemVQ5fw1YWTkvxaRNjZdYgpIXuDo1gv/fAFL2s0WnmYZPR5DMHqUgPt3amxDmZXO9djPlEUp9ng1wmk46fPLyneXq1/8EgkziqLF7tQHciUBsCDt4CnZY5g+wBj9j6ygw8LE0pcbu3TWh8XllJNFXSURPNMjFlGZspKbMcoVXyBLdu0EJFJrP8ZkG4HLJZ7DeaxWN+d1+vDaVKRla89yswzMdfIQGxFF4ziTGpThkuWsYpLTEewnhEahWD12QXK3ox1ETp6nZ0dYqRhTGLN7os5qBmEEKjaQPzdFfnc5d3MDfyQhVtuBG7URV74FmW6nRhdiWKebTyRxxk5XNASzkhYRmAeZCoUFMJuu06ukLYsr/kC1cMHb2w+QnH4zdKfqZcVpyJgyjn/pP62TFFr/sLJLxfvkBpqTLOCbqjuSq2tPZj1oubnXrOKP77F7dvZlZV34Xsfawbn9RICXbmz6vCVaQXH5OLHC2ioPJXw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(23010399003)(1800799024)(5023799004)(11063799006)(10067099003)(56012099006)(18002099003)(3023799007)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mWwcglvjpH0EB13WtRhmGvvRDCNKbzOz95CKjrGkRhsHlO27f7NzCKagYCq2?=
 =?us-ascii?Q?usRoS3zNKadp9V4T1BqJS/9JPETbPpKNKs4F5kWS8st8O9EJcUPHaiYw2YFX?=
 =?us-ascii?Q?PgJsWuz49pzkGDuaB9SBV3TNAZ9wzyWh3ocwRazdw+2tIwUMGZt+GP3Ps5E0?=
 =?us-ascii?Q?YJ+RZh05nLklneqwAFB1p6ZigNS5BGWgWGCfLtiS+Fc+C2UiO7ep8cAfHSgY?=
 =?us-ascii?Q?64gQeFkWBkst1E8xdUB6HbGDMB3hE6RNHePBYKk3rphQbtu6d5YO2i8Lww0z?=
 =?us-ascii?Q?2go1V2m4BLosiqSqm60hSXqFi+Sta6G31V1mrozGZKhSyEiSkwybp0qBkZUc?=
 =?us-ascii?Q?gcDyENKQQdXGQX8ZAHqw9M/PRWx5WbvIUQiTa5oj6VEsMNoodr5J20HE/61s?=
 =?us-ascii?Q?iz9cQaRHs86bmsBfvC3enJgJ90OglXqymWdw+GNKdWkmf6F91OBfqLjAcCpp?=
 =?us-ascii?Q?eKdnbC0BRwvFOqxPk8bUJ9knqpNqbUoD3Wcmkk2/+Xq1AUkey5CLicuj1EY8?=
 =?us-ascii?Q?aDUU/3cDOq+4sY33sQxstGbF0Gy2I2kKsoFGuO4NgMmgy4cfQR6+p94vjPCa?=
 =?us-ascii?Q?cJzyUXwElVKJsGuaRmkeZE9dcvcQkq8txpZ9S6AuC4RAjBR7ABX3GmP6eREz?=
 =?us-ascii?Q?ODjqls1UV5oK6vrUMyXA9zjHhKCo56XgQhiFQj5QYS0OKx0VAOC1ASoU6saP?=
 =?us-ascii?Q?/sgovKaAaRY2xAN3Ar0awvVdL98rB8qKZG8+eKvuCMBxbElroi5AkZGEJ8qN?=
 =?us-ascii?Q?6xnnxrkYHSvBnLLflv+0w3Bw3RN33mzU/seH9hDOHGcb/Hn44TuY0dc5nNwj?=
 =?us-ascii?Q?c/sxMQTrBgcfv25SjPunkSuwRRc4v6owsnkV42QlEn5mdiQcCPwMwVwDiTpe?=
 =?us-ascii?Q?YJlfwVGtxCTYev8VDterz4oXNZen779eIXWGVVYEYyqqBLC41huoFvnH342k?=
 =?us-ascii?Q?31y6u87gibWdqADS5JR14pl8dw47l9gqjk3TZmMiA1/4PjkAeuiBPxuM5CoX?=
 =?us-ascii?Q?lRo+oECGbIm0JgmoF5aNShIxwwhlYtZbX4wVqddY/SAfT8XYxoWiPyrz9gEC?=
 =?us-ascii?Q?tSDxnW8g+jQeWMkGeqNMB+/D3tJlbBAG8Bpgevmk74VHWznWDjGguYwu+gtD?=
 =?us-ascii?Q?qJAAg/gTMtFw/LATiCpfsPt+03BeoV0ay/XT/lFLR9XegvnPi+M7jdrUUPJz?=
 =?us-ascii?Q?L/5s00L3aJua1hB2aL3DMeb8NJUz74u01g7KJbyE6gDMfqeK82OJFjJlM6N8?=
 =?us-ascii?Q?kZcVcMf/NKFHyXRvXTRtpaiE1oympZEwaGezQrA46ClR79tnUfi8jS3UUt7b?=
 =?us-ascii?Q?COgXuPzTJ4QdFvTEaJsh74f3sMfhRDRfXrtD19js36byJGpqJ+CWiOyjwr7z?=
 =?us-ascii?Q?3gHNzr+kz3UYmVWc+VvGEOZHZDECbmPuTNfkVHk99eoi8Cx2CPcUMX+ZiK9F?=
 =?us-ascii?Q?P5ay7LDcuIiUbZ4mgReUSaimStsTCWmtXoXwym3SJQ8aU1hlbxhgSB921/oy?=
 =?us-ascii?Q?18Ixla0iQEPJNhMRzop7hzTvYqzx/mOIIFW3+SnQpnxCJQF0vMAMqf6im9KT?=
 =?us-ascii?Q?xLC/HGo7LGsXNbxLUrYltmE6Cz9/ubB4ZjuJWrePbdALOk6X2maQBepAQxZ6?=
 =?us-ascii?Q?l7juidteH6kDOgShk4bz2OYUKzLqQnMnCeSvbmgbZGfn+wMgQyOmK03PfA95?=
 =?us-ascii?Q?a+cDT3n/OqIhixHS5HON1wIKz4APUBA67J8BuN6PPN0QfGze?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf564a5b-bc1c-4f95-3a24-08df20ecef74
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2026 01:23:31.3186
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kvJ0wZ6q9JpkiNH5tcSeJWcoZ0QGEiZ1vUwzKxkgsJTW2xd3w/C0VnqMlNicneKe
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7641

[ This is part of the patch pile to move SMMUv3 over to the generic page
table, the precursor patches have been merged now. What's left:
 1) Organize the SMMUv3 invalidation flow so iommupt can use it
 2) Use the generic iommu page table for SMMUv3

The first patch should ideally go to -rc

The whole branch is here:
   https://github.com/jgunthorpe/linux/commits/iommu_pt_arm64/
]

iommupt has a design that focuses on building a single iommu_iotlb_gather
for arbitary batches of map/unmap operations. The gather uses the free
list and it captures invalidations of tables, leaves and supports mixed
levels.

The introduction of PT_FEAT_DETAILED_GATHER provides some additional
information that is useful for ARM: the damage bitmaps for the table and
leaf changes.

Prior to switching SMMUv3 over to use iommupt prepare for this by
reworking the internal invalidation to work on the same data format that
iommupt will produce. Bridge the invalidations generated by io-pgtable
into the new format. The conversion is simple enough, io-pgtable generates
invalidation operations that have only a single set bit in
table_levels_bitmap/leaf_levels_bitmap, so we can convert the io-pgtable
provided size into the proper level leaf or table bit.

When iommupt uses this mechanism it will fill in full bitmaps reflecting
the union of all invalidations contained in the gather, and this series
provides an implementation that can work this way.

Like the other drivers the general algorithm focuses on trying to issue a
quick range command per gather or at most 512 single invalidations. If
that isn't possible then it falls back to full invalidation. Since table
and leaf invalidation are combined together there is no waste of
invaliding tables prior to performing an eventual full invalidation.

On its own this provides value as the invalidation has a number of
rough spots:

 - Non-leaf invalidation actually expands into a TLBI for every
   translation granule because the inner logic doesn't special case the walk
   vs leaf condition. Now that a table_levels_bitmap is used to describe the
   walk invalidation it properly generates a range invalidation with optimal
   TTL or only one single invalidation.

 - Range invalidation doesn't calculate perfect hints for SVA because the
   SVA rules are different from the io-pgtable-arm rules that the
   range invalidation algorithm works with. SVA can now express the combined
   leaf and table invalidation that the MM callback represents and get the
   right TTL, with an optimization for the common 4k only scenario.

 - Range invalidation didn't generate a single invalidation like VT-d and
   AMD do, instead it tries to generate an exact coverage with many smaller
   invalidations. Switch it to more closely match the other drivers and
   produce at most 2 range invalidations.

The approach is to introduce a new struct arm_smmu_tlbi which describes
the invalidation, pre-compute into the tlbi the single and range commands
from the start/last and bitmaps, and then apply the correct pre-computed
command to each of items in the invalidation list.

The range invalidation and single calculations are revised to use the new
bitmaps and accurately generate TTL/stride/etc. In the iommupt conversion
series the errata will be worked around in a way that is bounded to three
range invalidations using the damage bitmaps.

Some of this design is to support another series to remove the batch on
the stack. Now that we have the invalidation list and the tlbi it is
simple to just expand the invs list directly into commands instead of
using the temporary on-stack batch array. Eventually removing batch will
save ~1k of stack usage here.

v8:
 - Revise some comments/commit messages
 - Rebase onto smmu/updates and resolve a conflict
v7: https://patch.msgid.link/r/0-v7-e84261bbe7cd+2ea80b-smmu_tlbi_jgg@nvidia.com
 - Remove "RIL" in favor of "range inv" or "range invalidate"
 - No functional change, only renames, reflows, etc.
v6: https://patch.msgid.link/r/0-v6-9cd17417d355+281836-smmu_tlbi_jgg@nvidia.com
 - Rebase to v7.3-rc3
 - Add helpers arm_smmu_pt_level_to_lg2sz(), arm_smmu_pt_lg2sz_to_level(),
   arm_smmu_range_inv_calc_scale(), arm_smmu_range_inv_calc_num()
 - Remove unused leaf_only
 - Combine has_range_inv and range_inv_scale_max
 - Clarify comment on arm_smmu_iotlb_sync()
v5: https://patch.msgid.link/r/0-v5-b810cf379bfc+13d738-smmu_tlbi_jgg@nvidia.com
 - Rebase to v7.3-rc1
 - Fix the SVA CONT errata interaction
 - Remove over invalidation, instead use two overlapping range invalidations
 - Reflow patches around the errata work around
 - Fix a race when eliding INV_TYPE_S2_VMID_S1_CLEAR
v4: https://patch.msgid.link/r/0-v4-1802653d8886+492-smmu_tlbi_jgg@nvidia.com
 - Rebase on latest smmu branch (accomodate already merged IDR5_DS changes)
 - Fix iopte_size typo in interior patches
 - Tidy arm_smmu_ttl_addr_align() some more
v3: https://patch.msgid.link/r/0-v3-4e7f64f4e094+85e-smmu_tlbi_jgg@nvidia.com
 - Carry the base translation granule in the TLBI description and pass the
   domain separately
 - Invalidate the leaves when doing a table invalidation too, corrects a
   missed invalidation but means we don't do anything about the duplicate
   invalidations.
 - Simplify the control flow in a few places
 - Clarify the TTL derivation and accomodate DS
v2: https://patch.msgid.link/r/0-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com
 - Rebase to v7.2-rc1
v1: https://lore.kernel.org/all/0-v1-5b1ac97a5403+6588f-smmu_tlbi_jgg@nvidia.com/

Jason Gunthorpe (9):
  iommu/arm-smmu-v3: Handle ARM erratum for CONT under invalidation with
    SVA
  iommu/arm-smmu-v3: Pass the parameters for the invalidation in a
    struct
  iommu/arm-smmu-v3: Move pgsize out of arm_smmu_inv
  iommu/arm-smmu-v3: Optimize range invalidation for latency
  iommu/arm-smmu-v3: Keep track in arm_smmu_invs if range invalidation
    is used
  iommu/arm-smmu-v3: Precompute the invalidation commands
  iommu/arm-smmu-v3: Populate the tlbi at the top of the call chain
  iommu/arm-smmu-v3: Change how the tlbi describes the invalidation
  iommu/arm-smmu-v3: Support the DS expansion of range invalidation
    SCALE

 Documentation/arch/arm64/silicon-errata.rst   |   3 +-
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |  40 +-
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c  |  38 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 568 +++++++++++++-----
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  82 ++-
 5 files changed, 552 insertions(+), 179 deletions(-)


base-commit: b370a5e979f8bb8f34e30ad126ade734d8f128c0
-- 
2.43.0

