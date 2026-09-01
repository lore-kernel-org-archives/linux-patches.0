Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010066.outbound.protection.outlook.com [52.101.46.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4485483828;
	Tue,  1 Sep 2026 17:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788285008; cv=fail; b=HFD1c092kb1A+ThL7L1sqMaSYlHwG0mKZzldXZKMxss/2op+oRdSH7cpqDftXA2ISCsi32z4c42Rw8yaWh5UVx0Ppp1wSCyQtmWm9URrC6642Tx37DAEn7kd77Q1nQPyAJ7ziGG5Ws7f8OtZb8EtmRbuySFsY6Z/s2W4Z21oQ2g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788285008; c=relaxed/simple;
	bh=06DCS13S0h6M7csgKndj7SptiQTzh3s+tS8pHTllAV0=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=AsaleSfuSU8RzB+04WNKSN6g6n45xLfu3HASfBGra8tjwjAAV1ZCRyZIZQZp43K5MgXCKyk3/oMvvIus4MtDMrIREMgZrLSzwCLF6/KuNsemJTiOSKbkptWnzgjF79A4lmdQcAXwyViEnUDZaZvkRIOd8Cfrxz6O+57i9o5+m3M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ti1zbMB9; arc=fail smtp.client-ip=52.101.46.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ti1zbMB9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IGiHu3Ih4QdtJACu4gxHGAwMYxG+tHJQJcKZWgrxG/Jv2EfoZC7W01+CmeLQXdNq9DFBywCc6taNiFeGul4uIwY8TKRJ+zzFGALIoed76mp2DJpkCvuKFnBhEjKdYTort0tL67kK6wEIA/Qc3qy/G8dkMczJK/BiOf+aUTTSEI5qesBwRphRRefV+2NI5hCjOW5OPov1iToTsTe0s7EGpvpTQSAUz61rUaON7nrqfBqk1yu7yWyNbDvCICkAoPWhpRPgE7GnUibDoY8Pz43pBE1UMMj0+zigDdwQOoRCL4QUM119A16u4Uri96BGAI+SpP1kxAUHW9JAVzq1y5IP6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+g0adkGBux6M6lIMlJq6ue/zuWf/cAf12mmpYY1Y5Ko=;
 b=nxhTcNU98lGIGmfPZWMgaEvK9XsmqeByNssYsEMzp2PKcz16c08t/J8MAYplPe+3ffWNUhFcMuaCOOSYAjMSAu/73nY4IwBVJgahrLw4+930w5g+dX4HPoppFn6eg8wiLPvgxnyPLsCU6GeLildNHIFyp8O2SjKuf/8tZWDSUoN8mgcE4xyeGdVlEiFrCypQT/hVWlHQKL6GcRfZX+ZFy2VV/teZC0jgIaQVpNcVPlxt1zAmjP4yUl0nF2OyXzJzrg47uiSFI0cNb99rEfn4F0t+AitMoDIu2jN55htOkd2BzJZlt8Ecczcz6gjro2ynZssxFZk85+1Gm/g8FJVVMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+g0adkGBux6M6lIMlJq6ue/zuWf/cAf12mmpYY1Y5Ko=;
 b=ti1zbMB9Y0Av9fVpAjn5JeiywpgolcGr3Hx1CbcKr0LKFAGuspbPa6OHyvv8xG+NlnluYuCJt2WCG71EMp+xbwIkcpoOtGFuIeC99OtZGzmKXzzc9i3k5lj9Q4S2q8f2QKztm7YnmKXsrAZ4WCPlaCpTcESd6wVQWZrRPUNpxzFCJmZvEl4Z+K1Cy3SjEth6g6j/sIWOI2s3Xs+pV5ifW2MTZh454UVkDG6TIV0NZPkiz4uJ4MBJSNQpi5Im7sRisOTK/AWAhRQprokcb242WRWLQqz3D9/RX6x8X3ln8CE4JNHLeQW3ERWiT49n/bN/wUvFp0cxaGvym1e6ZEormw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CY1PR12MB9626.namprd12.prod.outlook.com (2603:10b6:930:106::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Tue, 1 Sep
 2026 17:50:00 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0360.008; Tue, 1 Sep 2026
 17:50:00 +0000
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
Subject: [PATCH v5 0/9] Organize the SMMUv3 invalidation flow so iommupt can use it
Date: Tue,  1 Sep 2026 14:49:49 -0300
Message-ID: <0-v5-b810cf379bfc+13d738-smmu_tlbi_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0482.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10c::20) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CY1PR12MB9626:EE_
X-MS-Office365-Filtering-Correlation-Id: 568eb458-cd09-4fde-d5f3-08df0851713e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|3023799007|11063799006|921020|10067099003|5023799004|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	+CQYygf7FQ8OMXqVB/WedkSU72WhxNrrw5W6gj7GvUR0PZrnM3X+HdPrD8pLe082LyJdFax0iXr5S5thhmIidldLnxZI6dccBqvYb7D0/cfAZD2BDq8DCoh78FNOm00C4PHMs82GC1TuUW0aN/QSFgQskgacjRkKKZ22GmqppbFEqTFEyy/1cQGN/c+zpcvVfsrZPDD9ZzfxT/JB16AUrFywcbBI/IVHVTXe1ZjkxoqVP36m+Spbgmt2fxbF3Hz2PE8pusuP71UbuiV+aDkDtUsW+B0ZNUm+15qG3+QzgX5SZbGGCjwXv3AdlgXkmRi5XQ6rzVqIH9z2iaHbQkvCm8RHIKASUGY5rc+L7lzNxvTS3CC1THH4OoAIvZ9HMzLl9ZyV+n7bTCpm9y5wuTpBUDebhf2MuJ97CD1qAi4U+ZVbPadnHLHF8OZYJWE+ImHAa0b05A6U7KCJukAuIDoOwYOPtGIA8Xs/a759huQocCBMCUcBoQ75oHISQmILBgBAdUlCWhqRxmrbtqHFRGYGFwxx/R5DEgi7fzUeFZamx6dgE2ZKJGCTIwf8/V4Sqa/iQ/ACoXifc3KI+WvY5yjoRAKmkis0vWq1fi7t/CWN1veX3oPIdudkjanEE5B8Mgzw0LTDvWOwPwO71mINy83TzjUcuUbAipLV8Q+JmJhTodVLEOf58iK3ZS8PUhYq17N+kzpGAKQyIntBuh522XsRSw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(3023799007)(11063799006)(921020)(10067099003)(5023799004)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3O6VZAgsRewtve94JyI9a2oooouN7MkwsZBVnKpnEZimJMjrrxp58rtM2q1F?=
 =?us-ascii?Q?vXUr/iH+JbkAcG3Es+RbGvCPz9SGkWbK8V98f4Y74E41f2B6gJ8a6aoILbp9?=
 =?us-ascii?Q?TkHshfW+7OTTy8hIIIRnuYtMNSwhNnb6VbKmcDPtzy5OZOmELa4fbsyPWZO2?=
 =?us-ascii?Q?G6mIFaHLJv15r9zUhiBP8ACn3fIxFYioR5lx6uHZWRXt0lgEQ+J0nLCAFyci?=
 =?us-ascii?Q?oiIsX9PWviARn4ktyBk23sNmIYuKWLwW3fFiIngqoDuHBR+2aTe6iIom57/l?=
 =?us-ascii?Q?f0kASBIi4KT7oSwNnXOEbkLW961PHHTD1UxIu8HQqSL5fjwJtg7uPZWoWzqu?=
 =?us-ascii?Q?cHgeiLqaJMeXR5FUzXOXPpXmAeHaqyTV6xhBkDyurAdrase+R+Wq9rtf8aVC?=
 =?us-ascii?Q?DjJo3gYyK/3iBxvy2/rHkzIAiVP4pT6zm3r+vKB3JNBbLdL3EP9QbHdQV3+C?=
 =?us-ascii?Q?4a0MgJ6BUzJ30Igl6Py2cCFaFmtEKlx+zX6IUbDnK+OobCN5rEaxVqSlD9MI?=
 =?us-ascii?Q?hlVznzTGUqByWxtYY0uBepdyx7+fFPsfKS8e6R8Am8LkFzaU+qHSvmUFRj6S?=
 =?us-ascii?Q?dT/UemJxquZbH+ldGX+kH9oHCZqKk2VDysDSWX29f11zFCeoSOq5IIWYAINL?=
 =?us-ascii?Q?/RT+kvZSZBIprJkgZukAF1PqLdLr+l2o8Mz2m1JgTmdSrhaFrP6KavjZm+1E?=
 =?us-ascii?Q?zqcFu5oPvm+FWlihODM+t1aXA52MlUOWIW8Z8rlxwvVd2wlLYpAuaMLXa2zC?=
 =?us-ascii?Q?dw3pkn049e5ho4DNuPXWimlhOfjNQiJKARrwrEq8AZsZx2haXX9pXAmgeaL0?=
 =?us-ascii?Q?KmFi63EQGTFPQ777uW8wVDRLNn1NzrkcViSsvZ2ZYTj2vhtxhCJeSq0/HZ+u?=
 =?us-ascii?Q?WX2uQWSa7S368fhxuLHD3biLUPhcKYSWFgVmbGpRhiny/xnyFDsE+2axUyk6?=
 =?us-ascii?Q?dwfehVjg8P7TNiklWmeYtXQ5JRpdRIDk/fc4m5vU4UHmHxBGvEFMiKNXFdaa?=
 =?us-ascii?Q?LHi66wbG8fZS9bZGaOXBsZvclafXnfWZJnN6cLC9qa3HjJuVE6n2OyIDH3hX?=
 =?us-ascii?Q?2llrSV5tB+b0M31HJgUfosmdU9V3SAWGMzuh0C6AObwyqx4CwmbxjixVgj5n?=
 =?us-ascii?Q?NInjSDxAR1bt028WSBZxjb70nFYWwlKOHOUqPf/j3W+gtwlZRKiwwbpWx8Nn?=
 =?us-ascii?Q?zfrgxhiI9dQ1VN7XvtGnT8elR+cmQDauHDQsSh/kMKfias/JxUZVLFTmqyVW?=
 =?us-ascii?Q?rGkIEN80WlwgqqBVWtXhYqt+UgzFun4jzP3Ruy3uL/QN2KDp3hVw6d9C6G/o?=
 =?us-ascii?Q?zhraC/s6Ccs6IGDCEnSNkk7y3LAkfr1AStxJ/hBsdy4HEW5GJlfgxIIs4gH8?=
 =?us-ascii?Q?FDv+A6EpWhwAHArUa7l8ihBq66JUXjOyEStCdcgX16lS/JD1SIBlAbbuqRdV?=
 =?us-ascii?Q?1Pqn84YuvgO8u/RdLoiqH6QkOlM9SQxcyy88QIbrrxIz9o+maRgvthJJRKXV?=
 =?us-ascii?Q?SP0w28WF8to66Il2YDS4/yQo2a3BV2w28Am5BzMkqUkFExuNw1sFY/V6YjD0?=
 =?us-ascii?Q?Gs5qtjD94HY2qGWUHQmuzdh1W3s7eYMSEoYBLaWqPk/O1Pn5pvgG7wP7iB/y?=
 =?us-ascii?Q?DQWFhinoa1ZgTzPQmHRGs45CJjtIEbRoUq1RYMR54la7ZG9ImeBckTZ+5P02?=
 =?us-ascii?Q?Nw2pvfH5DxG2LaanzchUZ6KbWoTf9jP0OGivLJPuLKYZ1J2d?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 568eb458-cd09-4fde-d5f3-08df0851713e
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2026 17:49:59.8845
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tYWSX/uzoo7EnOM+XJ0SZJbfkdGbcDVFbg6reUov7cfV3BSiMfiJoVjINyhfzgEZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR12MB9626

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

v5:
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
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 537 +++++++++++++-----
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  67 ++-
 5 files changed, 508 insertions(+), 177 deletions(-)


base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
-- 
2.43.0

