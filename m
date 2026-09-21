Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011029.outbound.protection.outlook.com [40.93.194.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AC26479869;
	Mon, 21 Sep 2026 23:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.29
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790034941; cv=fail; b=r7IBecksMDirNA6SalU2fnRS5/FXIemFeJRXrn9azFq9n/rGzPiKzj/FkpD27+eI2Dso21Q0cnoUEsGHZDUdJ7kGrwIJGsMmLHAYF8XvydgGIr2pHG6hfZxXdIfdrzhHU9K1r1zC+J4tF5IIt4z0s8KIMiepE4ogc6fCPXV0Eb0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790034941; c=relaxed/simple;
	bh=qYQfLNUulRJU5pY1+CizUMzm9Zwprr88JrwRIXt2WhE=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=I62VquDHG+uZfN0rIFnYu+0kpbeCFJYMfYqfv2zCndIXty40UVc1jtMIBxXmWqzUv6a4o9aizlonC8NExfXRW9ahM5oRHrdMJrdt0yp6dvzc+eo4YzBhuDWRdLEVa4OZt0sm2+5OPQWSMP+dOjSrVHlxeCehOW7guWQNeJYbcg4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=sQFCxlDE; arc=fail smtp.client-ip=40.93.194.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="sQFCxlDE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v9ScNRBKm5ej66KS7615/h+xlLdIqIyu+Us73Mm3uASSVTiMLZ4A3R1tH60O20RJNVkiTmlsZ4kz1Xivxg82mBpu9P4vc+PgiOr7PExSi6FUy0Sh5VXe6yPwujcW1UxKidd6wbLDzIqWlq1IIWupfOUjhQGY+NAlG7eMQjdUXk8aBhXVGEFQYRwxRfwzQ6h8NyradMPhEGTHg74crxknSuVwr0GDe4kk1T3SSLxbuKQhc/HOprUYvSe6yB+4qngsqS4sAMM+8SkdW6wh++XRa8+ojrfX7uokNfzhHoJGzOxnQ13ojSQ/fMV/aRd2u9k/ByYpTZ1PJetLQ5TTC4SGTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cOTF9LeT6YI2sIeJjTqKbP7GaOjq42GmArok6chGsqU=;
 b=qpFTcGoAB3OTweDndWNfRH9EQeHA03DH89gBxODP0OUHfpyk0JPpwyc2rbVogMckSjmbVwbionfUKsj8MXGNSuzxvopbN6xSeNH0KgAbd9u//wkDfcrWkQkSt9MK2sBvjQ7U83pq5fy8HVue+/KnPEod2DrruYlDFCAw650a61t7+6AiDGFgDAqOglj5TjCEDTOMvZhUO8cALPN3Ntaue3//ch8Wj02SZSwZfseRWVBrcFldinL/3/HQLPGNuirRjXP5AKrTnDQABWhpGocL0ejH/Kw7N1nb4XDZ8PSyyKrEPvs/mW27cLzLk4Jd3gzCLbo1kWs948pzrLnIBmIYdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cOTF9LeT6YI2sIeJjTqKbP7GaOjq42GmArok6chGsqU=;
 b=sQFCxlDEO1bk+mrD+jCSfShQOSJ01dWZLUjy6ng4dTDfHSHmTcHwZ6Vq778gn10RD7Et/dX5oMWF+UTbSgo5RgTu8pFV//ZR/CqlyvTPOK2yM42w6CSdfiPtk7w2s9RSOj/u7QxDa8ByK596IxHsXWlijcrT0iMDliuiHJShzmr/9MLaCiq5GB3z29XwEkjtsmdmmN/vpKY3+pndl3MAjGwOysh9KgBCPO9BtNluCYQ5VqWfkuDbgIGmp5nk/rEbVINMKfnZR0JUoeX8PW7AZMQq+g6V/El8VIOS6j/tn7eRPmFlP8qZ3VTQGUoGTV5eXtuyRL0Pj1OAfH9LStyxew==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LY0PR12MB325698.namprd12.prod.outlook.com
 (2603:10b6:408:3bb::14) by CH0PR12MB8487.namprd12.prod.outlook.com
 (2603:10b6:610:18c::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.13; Mon, 21 Sep
 2026 23:55:22 +0000
Received: from LY0PR12MB325698.namprd12.prod.outlook.com
 ([fe80::b65f:1548:5b35:e2b5]) by LY0PR12MB325698.namprd12.prod.outlook.com
 ([fe80::b65f:1548:5b35:e2b5%5]) with mapi id 15.21.0428.015; Mon, 21 Sep 2026
 23:55:19 +0000
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
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	stable@vger.kernel.org,
	Vijayanand Jitta <vijayanand.jitta@oss.qualcomm.com>
Subject: [PATCH v7 0/9] Organize the SMMUv3 invalidation flow so iommupt can use it
Date: Mon, 21 Sep 2026 20:55:08 -0300
Message-ID: <0-v7-e84261bbe7cd+2ea80b-smmu_tlbi_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA1PR02CA0007.namprd02.prod.outlook.com
 (2603:10b6:806:2cf::18) To LY0PR12MB325698.namprd12.prod.outlook.com
 (2603:10b6:408:3bb::14)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LY0PR12MB325698:EE_|CH0PR12MB8487:EE_
X-MS-Office365-Filtering-Correlation-Id: b4a0d1b8-0875-4bcc-5fa0-08df183bca96
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|7416014|366016|10067099003|56012099006|11063799006|5023799004|3023799007|18002099003|921020;
X-Microsoft-Antispam-Message-Info:
	/o0lhKY0uZt6IOAWf2/S8dC/09zIJUJlVkBcZBZ2pV5X5PlgDpiRac3nMcVsjlUtgL+iNtYoSDIWQ5XQBwk1uEscbGl2H1uRnuEK2q/hMC8GxVUffWqXhccJEKckjnzSZc8O1OjPfmEzlh14pOX2q8HNfyQGPbgbc0fH/8MBNAfGKMO4+nhL+IqW0wAp43w2whxWB9xeUJtEuqv63fElUxxkyCnLIQzRfLiEo+JL9Mvb0zm5+fFOyen4otUMfcYI3PgAeU++MTfETsDH1IOV0aSmFeTG/wjtxVnsLtryn5MgVu/UJ1kyG0a+MJr+B+IFv0zKYnkpLIv50liOP0NZGfgpt4YuIQksvDWcJpD9zEY9cPnzQGL0wgxoBOpzcV8HPz8ApMlqQA+rr9rSu5zz+Coo4I1CSbxgMRs8ZQlT6wO7S4vxAUTbnvizzukbIGJeknUHZGxMzrcHqWBycFIfUzqTn+CZ3E/IaANaWktD8Xqu/aU6KJwqgg9tnIzebrOfoUztXpgSOR6oG2p55Qg8p5+acFxWA97B3h4syh9l/VeOvdHY0mZO2UHSxvc+KrL8pRimTpgH800AMWIUSbzB3eOI1Wsyyk4tj3t5CZIVA6GZV9qJhuEDMcS4cBccs5ND+NFqv85tGBnfM3qbnPRV9jL+PkTqm43WHSwJ4LHFKY7+pYQXOx686jvZZkYX64RD5Fk8Nj4EtuFNFWI136zFHA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LY0PR12MB325698.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(7416014)(366016)(10067099003)(56012099006)(11063799006)(5023799004)(3023799007)(18002099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tzD8XNXgankXkDSEJPSR3Ylr2f2xLkrDcse/6dcrEp6/0T6/UqOjpLtZ55Vg?=
 =?us-ascii?Q?hQ5nhpqkCY3xWz2DA8x4LDC8QaFiy9JINnlt2FhaMKzVoY3XLgW+zEJLSfjJ?=
 =?us-ascii?Q?bataNDeO/C5sJleuNH8t5mGCOONjmvkUUCg9Nn6lw0Ybnk/b98pqnzQAgW/O?=
 =?us-ascii?Q?0WFsKtXOc7dt4VTD/GLTxRp7aynPnClAHKvImw+afEXL7/VDFe7fDUWBS7gV?=
 =?us-ascii?Q?g0paTdAxpMvKcuPGKKEp5LHAz74ZpXo7hIzqlfcTiJYnz3pdkhOl2AJDkHoe?=
 =?us-ascii?Q?NLRKIFsDnmjdU5F4vIcW7M8xS2FK3+Y+7vksHwheXUHAIDR9aKmxJuMZJ6X/?=
 =?us-ascii?Q?gr73qNFHX1ZY8rQHUU2Pe4rce246WiexFyPbH22DllSntBrf10dm0E4h00GR?=
 =?us-ascii?Q?VlEHyY2KhsXheBC/02c/YUv1nFCNDY1CEa5K+4mredjyN5XYIxGN27J6pdc4?=
 =?us-ascii?Q?H5QJKY+CsRA8TPNgFTvModNtziIgpUhIKb6oXS0n0PdTFFi015rd2VTw/wAT?=
 =?us-ascii?Q?AjLcRRQQwNx9pjbEE/nhtnXKNGHGTdSKMQmID9Yku9hzjFDj4UMlXV7Th1SC?=
 =?us-ascii?Q?vmI9H+33Izos+4wceCoj5URJk4nJCE7M/Gl6drW6r2eDJklRta7m5Ftg9CX9?=
 =?us-ascii?Q?xwGO/2AfdxAFq7Nnvl/WtIeI+iyiIBraVnzXCMbFMcfPU4WSY4yJ5Lv4XLkS?=
 =?us-ascii?Q?OAc+wS86q8Av/at/T6il0GeFcysgA+AQmk0ZYAXG7ST4F8iglxv8Q2VectjP?=
 =?us-ascii?Q?oN2HAZLHH3FYin9m/1zzykI+UIyJdzl+RELsWwXRQCrr5ZOokDKCJzSh4qNP?=
 =?us-ascii?Q?msDPzFa2Nmbw9JlXdyNYmjCMY8STZSB4kGS94v2Tmj9PMGTnXLgYQGJIrmDz?=
 =?us-ascii?Q?zlqz6LoS5/6qhZqW2t/DMKxUGeGNAH+L1Ys4to5D/nfUySXHjlQeAq76E5HD?=
 =?us-ascii?Q?lJUqGgNmkfqo4911Q3YmSiMXwfUiOWty0daG9JSrAxAM+7Xd2je5PmMFmrXc?=
 =?us-ascii?Q?wORpfy2tcFLkaq4lQNxdKhEHxDutRYgoV6WlJUMTmZKOFYkhgiFvA6cD1Vpd?=
 =?us-ascii?Q?mts9Dam5OrrOsQv2s7kS0NJOMwWpuyO0hes31ZPLJ6kYOGxY9TZ7tkskjm40?=
 =?us-ascii?Q?VBFydsZyopY6UbB3naYzqki8vIFWpZbMnn/CR9bUimL5DAYNGmebm3h2fuY9?=
 =?us-ascii?Q?GxT1aArozPoRuyuEUJmw2D1vQqKRPRaupurq8YNhnhaLATPsGP8wNBiiJvvn?=
 =?us-ascii?Q?HxTCPBatr3JkPpzgYNZkW9njUeKR1F44ps/ij7eDLzWSRz20tkPHNrpipkQs?=
 =?us-ascii?Q?7R0qaDCt33m3nPsn35kYiqVkS2Jt4Iu89pt1ZdQpOKGYh7aPClqFfQ66DjHW?=
 =?us-ascii?Q?gubkHJNFwZr4jWEooyJ47UobpHvMWGSr2tKGduKdnng3cJ6MYuxZWjOB7cyv?=
 =?us-ascii?Q?nWRAcyyW40OjBvb891Xmru1HBV/6G+a0Yt4DqMmmlcnEKTwnwe4AXKAj40OK?=
 =?us-ascii?Q?ljrP2iremGIQFLQDE7hl3I4VSOc+OvPFMagUP0vSZXRqAL32HZ9ppsLQ5Y1F?=
 =?us-ascii?Q?usBmbsjOCDQyov6aJ2fS34SHpm0ljmkpd85Sa1woslFDwFVtn9mKmTjXQVly?=
 =?us-ascii?Q?/UwdGvAUYTtx+/vDGmU1bBj3JNkEeY8gn48jeqOz01I4Nnaj9x477NxP+QTx?=
 =?us-ascii?Q?VAXPPjsKzGNM3j72YH63Z/K48HuQ5IqcvlgQCOOsdK7lO3NE?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4a0d1b8-0875-4bcc-5fa0-08df183bca96
X-MS-Exchange-CrossTenant-AuthSource: LY0PR12MB325698.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 23:55:19.1792
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qFdcYajRBF7DR1tokUArmR6ON+8dBPaR1xT3heSmgcUUpiyZvWzDNfa3xCwTox49
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8487

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

v7:
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
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 558 +++++++++++++-----
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  82 ++-
 5 files changed, 542 insertions(+), 179 deletions(-)


base-commit: fd73f4a6659897191fa0d40695fe370925dd3780
-- 
2.43.0

