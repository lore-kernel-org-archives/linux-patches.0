Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013045.outbound.protection.outlook.com [40.107.201.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07A0630E0FC;
	Thu, 17 Sep 2026 00:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789604889; cv=fail; b=fBruxQBf9lmVi/Px3/eFtG6d0/RG4c7K6aqEL0e2G1ZaI8/yQagluElFU9GicBx6jrGnJsGF2rtul3akzqtRggFEu14yykIMZM12NPWN1VALbVtVvX08YrsoN7oGyxOIoqQTsXntom0YV1tKfSjWVeuLdzxRIWayG6sTYsG14Sw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789604889; c=relaxed/simple;
	bh=FauYPBKoylp/zb8D2kV2j1KTtDV/kcyplyu8wns+3+c=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=HfwugfCdlBYkoqS234zLFY2uM5VfHGpxF+YRi/fLy1AjXXbg0Y379tyU8P8jrtufA0U4cIjT0NjsKcQ82qTNtu/boompW1/YKXGg9wiqtdw6ysN1YYa5z0HebvFfMsVNnajMHa/hD90Q46UxJc7dAG3q5cyCn3cuItSZoNEMLIY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=CjxR4eiS; arc=fail smtp.client-ip=40.107.201.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="CjxR4eiS"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DwvIr/wNi9dTRBxNdai8FDJjwEWRhlJpmsxsTBtmZ5fSZHLHo0iCZ9dilFNIsLYkjG/377o4/nOYW+7D5WK3RbbgIZNeKgRsdMCxvfKbii66KbzJS+/NHkifLEZKixDJ1xmRlSnvQ4SywGo6syBZc8VI60JtIvGDmBm8s4M98cgh2K+d1pbef0P1hycnkot6Qa1UItI+odd+SL/iF3DHwy9eYaQBobA8hXp49/Fe0ThPBzMUU9noB55PSfHM2/is52xEfNfOxF8mY5R9WfLij+horMOgJomK9p9Xr1DSoolieYugSyMNJK/csfG5l3Q78hJM/ovrnSg8HWPEg7Y6kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oRvGTxMgqsy3se8wng8MQTs8orZ1o4xhlY8frOlwjaQ=;
 b=KecaJSIYqqsJilMEKaAYhbDIod/i/B0lStrD/93iApSwYRZsM1sV3wToR8vEwAvARNjUZCwKNix8zAs9Z513Hiv2CKO/mtRobpi9XjB9+9v7A5z1E91Dml3l3T+dpzWJnJLb9KZKsuRszgwzfIUzuKHeZHtcINAdfCGlZntQMjq298yJfTl+CVQrUfvnGH008AkevgLPuaQMay3aVUZEnQyRGpRUn9jmP7zmfNfBWEdEEx1aonNj4HidM0YFVjsn9qtpx2YUBvkslhnPXr7sFhW7v1AyFpx0bMu/vAjEjNQHOs7OuOfB80FCvTMsH7EMtiH8o6K8rTEn6AG4LkvVWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oRvGTxMgqsy3se8wng8MQTs8orZ1o4xhlY8frOlwjaQ=;
 b=CjxR4eiS2HIX6q8D9RhF4YwazmLeMpsMtSU/980Q2fFEiMV6c9v3Upd7PZjvnp/wOSCiedAfuJQGEqE6Pi/2MjXnuO+lozpGJcOPWE+7dx/5Y2QMneBYKRqXA6qkRIamU0HQ8Z2QEHdtduawSSjAkueYb3qII8bPKavxE+T6xM2azUL4bR3dLCZr8uXbbDPrhCeMtEuKor6w6pQWzUfqxRbYA/ojVBmZhe7y2Vj/LRAsCJyD0rCTlm+7lnfN2dFr8p1Lzu/x96Z7KKBkdqvuGaOpd1F4ecWCUvP6pLJ83C0LPsLjtXucLPhifIMoMyqcl2Q1EJl5yTMTRdUphZgpyw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by DM4PR12MB6160.namprd12.prod.outlook.com
 (2603:10b6:8:a7::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Thu, 17 Sep
 2026 00:27:52 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0428.011; Thu, 17 Sep 2026
 00:27:52 +0000
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
Subject: [PATCH v6 0/9] Organize the SMMUv3 invalidation flow so iommupt can use it
Date: Wed, 16 Sep 2026 21:27:41 -0300
Message-ID: <0-v6-9cd17417d355+281836-smmu_tlbi_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0155.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::10) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|DM4PR12MB6160:EE_
X-MS-Office365-Filtering-Correlation-Id: a86d9ae2-bedf-4ea8-46f7-08df14528296
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|366016|1800799024|921020|5023799004|11063799006|10067099003|18002099003|56012099006|3023799007;
X-Microsoft-Antispam-Message-Info:
	qKlhR69w7/92LgzZyBnP9GP1HibuPkGKRj2kdnzyN1iU0BZ3SXsIF+nqD6LHW1BvooaF1Ap8CGWc4sI8qyKQtzHVU0PeFWJNShjVVwzHWknORrZwbC88vY+B0tki26nplCaaOqAbULA2LXbCdIVVOT6ktNT/ZgU1rrxkXFvRMvqH/KZTTCZFIt4M5Dj05yg9LuUpGLdE+/NB8tRuvKgD3UuuZ0YPX81+mtpJtGfgu/n5VRfQU9oBfaG5S0qXPyeZF9p/RQ/12ECiZWDX4CB6a61XGOnzVq/UBSSG9hy4oz9/W0lfiFNQBMblSg2MYsnW5JrauNYPAHorx4pz0Zu9HkFxFXoGwyHIqewQei5dyFuL4BpExDELbRwgXnAjwjJR0/41V1uMSw7ENR1WkOk3AJS9CN/E/j5IwWrV3s18bTnd9eDV3gMn+C8GfYsLzjlNCEsBDivlSajbc7myxm/WwPJ8HVckQuOXyTo3w3ojuGm3RR4M7LHOmB8PSW8WYBqTPiUSFPW44yOo1CBknDSYpPcXpsIwc/KxyOJJCuPixrNu2ssQStKKJ4bAnXk1cHrOstWQyuGZIr9a8F9272YpMfPLSqylxAN0rkLnqQ2CEDjfIG1wbsk4QogVIelHKXth5ihYTYU7N6RDPT9iYNKGP8q6GI0pxR8cE3g6yclcUGEQC6JBSs28R8QmtV1sUJc2TBjIhDUCXbH0BngjoUZsJQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(366016)(1800799024)(921020)(5023799004)(11063799006)(10067099003)(18002099003)(56012099006)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9eY0ghTRZS/6v6LK8eijY6ud5RaMh5fH92lUs2EVdXoRj3x6OydVJI01ULiQ?=
 =?us-ascii?Q?NYCW0IEZlUzLwvIi7KmJKIKfiTcq2DF/iCTCYoRFDgLV2dJWNLKOSVGKwCC8?=
 =?us-ascii?Q?8XqQsQUBn7tuTer14Ny024A2/9n3PWlWoirB2tl6V8UTvSMHYH88EK/PBDLp?=
 =?us-ascii?Q?nFER950xvUczaH/N83GVDnUEMrAhXQW2HP7P+F6uNJgkL1StXT4AShDYHX/z?=
 =?us-ascii?Q?fzW3EZBTKNpbr8tPchJNIMCrFdLnakKTMaZWFswq2XfMZkRKCdn/gDeVKiLO?=
 =?us-ascii?Q?WOzZwTdwNRiHFHepPeKOmvT/Wig4Qml++eWejK0UgJRnkrOoESF4Wd+nste2?=
 =?us-ascii?Q?CLbyeBCAvqZmxp9MKrO4pzFZFNOwyok52uWqer0XJdO69Kjd8CrWVz0AW3ul?=
 =?us-ascii?Q?CcpiASJj6B8MhkxOoPqaGYKBYw//TCuUmD8m8cwp7wr7pBOKTHNlRsqdo3+r?=
 =?us-ascii?Q?o3OX8XEJWXu+AyK3YSCrrLR+S234DBn6hzYYEzK+6MnbJu+APpOmkQ5HV6la?=
 =?us-ascii?Q?h0Ekhsi6pmrm8kIQ3bw15eunL2LbIH6D2Imjq9YniHu9Xvpkw0AcT0bq4YgG?=
 =?us-ascii?Q?y/MgRgy6717c64o/5rabDfT4iLv12Avj/8TbngY8PeCHzjItGAp6lPvy7EFa?=
 =?us-ascii?Q?txjp4xb4SKhl88xKklwA0+2fDpkDAq8D5kNPJjfvxmsR4bo3UZu3guyobr1Q?=
 =?us-ascii?Q?4jxr2nkdBBR4GORR5XER8yKYhoxWtfxol9SVzjav4cDN/WRy0BH1tZ6r5BxM?=
 =?us-ascii?Q?iEdaTd+QmR91BqYGwbjyDzXAGkBRUjdnlXwKI6LlY8mIwh4OblvjPslbTlkz?=
 =?us-ascii?Q?yLOwXC++GyGY7nLsOVjbydsRFHJuIkRX/g5uvGsT/+StfjEs+e99xj8KfXLQ?=
 =?us-ascii?Q?1Dwj+uu9xT4HMSLgvCQlmTdU9qnCEFIhohPDeFRUpUY0g25NuH/gJYOPrpec?=
 =?us-ascii?Q?dasTeT1hyQgvgnoqM7F1zjCFbruV05wl/vu1QFXtPcjmc8JoZxfyrDTJT31S?=
 =?us-ascii?Q?NWdrFu122tyl4llOsGtbqwLVGKbGP2EnIyEgW34/mhqlSoPMyX1lzZCqy+LP?=
 =?us-ascii?Q?4+V7V5BUW1jGSa8W4mBsTWflvG8AoNwv18DxnOxTRxEbY1MmlOb9KLkSiGa3?=
 =?us-ascii?Q?K+lPa0jY8zlRdLpqvofrvMjgKM18VNUBgzvpKrq/vCq8c6kT+WbeJW52sw+X?=
 =?us-ascii?Q?WH7ewTMhffpQ0ulN+nrItVmgbA7jJOE/DBaxm+rI/Gl4UEjBN6vEFH7eYEE0?=
 =?us-ascii?Q?/YR2RUOYzlPwrsXMoMFudneA2+wK+6fSPBNpKqX7zFpArPGxuPKCaf/OsmZ1?=
 =?us-ascii?Q?muzsF3eF/4rna/2UzI9ksBzE97d8KQGkuDKVFUHo3V/49rHLjYs1RMU4pCvQ?=
 =?us-ascii?Q?OrdEc2tLPeawZoRUEEQ+x+iM+YsKRRp6+Q/OWkfclGJQUXXl0DaUzkIPTvyv?=
 =?us-ascii?Q?Wbec7S1qzUFbaqt7x/XWI4TRH59DPMdwSky17Ob5GVdPWJqF8iyGeCygmpRU?=
 =?us-ascii?Q?OScKSuhCTTj1n9o/dZ+3VzD+92fZsmYfDtYuWlq3peDIQFk8Hy7kleZuK5WC?=
 =?us-ascii?Q?EDAjTo6jfyrKhMbnlwaDl2jtbCeDqT30Qxniy+wPGjk333BiBbDuZOGthQ8R?=
 =?us-ascii?Q?/3G9vAdW7gRjBYcbuAgeIQMINJzB5Cij6Pkxd+RGVJfQVpBhKi2tNOlNYq9f?=
 =?us-ascii?Q?q3FK72xkiP05Aq1HBzj81bZCP6Q85nqnRczz4e6lsRkBQXYp?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a86d9ae2-bedf-4ea8-46f7-08df14528296
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 00:27:52.1465
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DN7OFDFfm3a7cfLiJyXFYJb42ts+QN/MFeICaNm/i+9e/0/6G16cCKpvT7+Lug07
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6160

[ This is part of the patch pile to move SMMUv3 over to the generic page
table, the precursor patches have been merged now:
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

Like the other drivers the general algorithm focuses on trying to issue a quick
range command per gather or at most 512 single invalidations. If that isn't
possible then it falls back to full invalidation. Since table and leaf
invalidation are combined together there is no waste of invaliding tables prior
to performing an eventual full invalidation.

On its own this provides value as the invalidation has a number of
rough spots:

 - Non-leaf invalidation actually expands into a TLBI for every
   translation granule because the inner logic doesn't special case the
   walk vs leaf condition. Now that a table_levels_bitmap is used to
   describe the walk invalidation it properly generates a RIL with optimal
   TTL or only one single invalidation.

 - RIL doesn't calculate perfect hints for SVA because the SVA rules are
   different from the io-pgtable-arm rules that the RIL algorithm works
   with. SVA can now express the combined leaf and table invalidation that
   the MM callback represents and get the right TTL, with an optimization
   for the common 4k only scenario.

 - RIL didn't generate a single invalidation like VT-d and AMD do, instead it
   tries to generate an exact coverage with many smaller invalidations. Switch
   it to more closely match the other drivers and produce at most 2 RILs.

The approach is to introduce a new struct arm_smmu_tlbi which
describes the invalidation, pre-compute into the tlbi the single and
range commands from the start/last and bitmaps, and then apply the
correct pre-computed command to each of items in the invalidation
list.

The RIL and single calculations are revised to use the new bitmaps and
accurately generate TTL/stride/etc. In the iommupt conversion series the
errata will be worked around in a way that is bounded to 3 RIL's using the
damage bitmaps.

Some of this design is to support another series to remove the batch on
the stack. Now that we have the invalidation list and the tlbi it is
simple to just expand the invs list directly into commands instead of
using the temporary on-stack batch array. Eventually removing batch will
save ~1k of stack usage here.

v6:
 - Rebase to v7.3-rc3
 - Add helpers arm_smmu_pt_level_to_lg2sz(), arm_smmu_pt_lg2sz_to_level(),
   arm_smmu_ril_calc_scale(), arm_smmu_ril_calc_num()
 - Remove unused leaf_only
 - Combine has_range_inv and range_inv_scale_max
 - Clarify comment on arm_smmu_iotlb_sync()
v5: https://patch.msgid.link/r/0-v5-b810cf379bfc+13d738-smmu_tlbi_jgg@nvidia.com
 - Rebase to v7.3-rc1
 - Fix the SVA CONT errata interaction
 - Remove over invalidation, instead use two overlapping RILs
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
  iommu/arm-smmu-v3: Keep track in the arm_smmu_invs if RIL is used
  iommu/arm-smmu-v3: Precompute the invalidation commands
  iommu/arm-smmu-v3: Populate the tlbi at the top of the call chain
  iommu/arm-smmu-v3: Change how the tlbi describes the invalidation
  iommu/arm-smmu-v3: Support the DS expansion of RIL's SCALE

 Documentation/arch/arm64/silicon-errata.rst   |   3 +-
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |  40 +-
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c  |  38 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 549 +++++++++++++-----
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  78 ++-
 5 files changed, 531 insertions(+), 177 deletions(-)


base-commit: fd73f4a6659897191fa0d40695fe370925dd3780
-- 
2.43.0

