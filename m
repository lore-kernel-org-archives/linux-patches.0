Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794785451;
	b=ccQXNb8LoPDFiOOCk+EG5w+BTNv2prRgZ3YIYJoCnbznXhEcXQD47O4tqeeCjz/TBBNb
	 dh7Ncc0qDwSbar007UPJnFp4VU8IklvtYfHMg9hS9CI5MofGZDu7uv3ZOUG186IcnhPvV
	 UpaFi53BKOSvFgqHGGXvVSG7cR+BQIMYWCc0aJfI9pLJI182H5VngfMAtSpgBo79H3mYC
	 JoCJvtCJImAfMlv70LXKP9HMpEAF0HX/WQuyCLJPMRbpJo8sBQ7XGJAtBiyD7Sd6OYwC0
	 gzSHb/i51DQOQHLqQ6+4usGH+GPiIdVpS5SFAGuL/fVJdtacmys6tZIE7Da7NqbuV2A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794785451;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:Content-Transfer-Encoding:Content-Type:
	 X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=UO3PRfCnPCwBTj9lwQoJXqEJRkOadv2HAShwIRQ+Kt4=;
	b=R4Jaf1U8uengpo5HzFbfJAmURJizfPzKq6wUVA/cFGvFU8b/78hPYRrA2rCddjLvPAbf
	 tTQA/p4WEAbqJHJ5/Pfoe359zNaw+4zYYfigkC8JYW/gPkj1C3yDvGJdfEoAEntQ+JuHr
	 3cOosVISh9AJEt6R8cgr3019dxTSyMo7DvcFbRI9ql0yH1GzDHmHewP8UYOxwZrtvVdOR
	 G0uayoG9MAMBkGJKXbMAedfWdu3GYqPd1kjlDkPsmtPbg9s6vWsokqWFJV/ArA/i7RkJz
	 8GHrKO8rHNVRGAmJJJJyUU78Ntafz7+XSOFN1RdwPDAjLfEeA5Vv0ZisXWQkQXJJz4A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ru4Sy6cT;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.51
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011051.outbound.protection.outlook.com [40.93.194.51])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79270606A334;
	Sun, 15 Nov 2026 23:30:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 79270606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ru4Sy6cT
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PgzA621aGpATDSAXLuQoUYBizaYD1l4eW5ll3NOzLFisMB4gmKbGrMfXp6m8izCAcEnS+lLG8QWMyqpbNy9Bz9UkQlfUE4bsQgCrIZ771OW0FrGsxDgBJgDr+sDrdIrsEHROkx8F5Ao8/bY3qIOO0TqSlPOLqXaqy/2HiP+TzBjwxoVDsq5HvoDBTLbIys+DvkvGooGlg6G+tup+8yUgKy/RU7XJJZwEAil4+FK4UBmD9mjSqoGXuPIHeAk7akyjr7iBymnuGfOPYYne+XYZ9qlZFoNAH+oXjdpyHwdjypIpBu7YXTk4G7qjJzJlNYGpZDAJt4jcbVRh1i9QhwyLCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UO3PRfCnPCwBTj9lwQoJXqEJRkOadv2HAShwIRQ+Kt4=;
 b=MN0z0tdOvk6yY3NPt8MuPIa94oYf7LqyDqYMuJiiMtA8uYhEB9sNINSfgLrCMllKdyL2L4AMfbrYe/mMYzljLVbtxXxIs957s7VcOkSikpCb+WPKCW4yEuw4ji0mkbnL+oYTjFosJKQHsAeMJpvEmhjxlw9/0/tp1xd7UefKDOEWRVilrrBW6/ZbmvIpriYCkrmu3LweAY3aWwzz+L5jkUjqqyiCt7s3u9HIctLACZ/ZfiKxbEEKGURyjerA1GEXksthk7vQLkqUVspSVVwNu6ESqXSdv2+P1dGILAwfJK1DJvYGNiC6rWbj92WIVCJzhVADwIcI5mBEUHmUJadp6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UO3PRfCnPCwBTj9lwQoJXqEJRkOadv2HAShwIRQ+Kt4=;
 b=ru4Sy6cTlWILgOmd2xRmxiRAGcuKJmrs3cU93CMSd+c4d6JW/7Hov99V/UAab0f7aOikdKn0bZ7IGLO9BU8Xl5frEZao8vCaiVYxuLhLVguuTTtws01TsowLLngWiXFwyizwM9c54U5BRwKNj+N5DzPS8FRc9M/kLX7nfM7/NXgeak2OhIcyLDxORxpefJ8Tvm1Ml65iYP663mLCWuDO378BNgjugxmCqD8R8tX+UqvuwP0eELCovIbqgXFAvsRL1sxkaHdkWbZv6zDqomRb+TtgTeQgT0Tmr09YazsaF1PPUV3Kj1Ecm2vPPsA39i1ZKnNsjeENUFXVUTszN6Fytw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by DS0PR12MB8815.namprd12.prod.outlook.com
 (2603:10b6:8:14f::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Sun, 15 Nov
 2026 23:30:44 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0615.013; Sun, 15 Nov 2026
 23:30:44 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: David Matlack <dmatlack@google.com>,
	John Garry <john.garry@arm.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v3 00/13] Use the generic iommu page table for SMMUv3
Date: Sun, 15 Nov 2026 19:30:30 -0400
Message-ID: <0-v3-97feb2edfbab+748d0a-iommupt_armv8_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0447.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::32) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|DS0PR12MB8815:EE_
X-MS-Office365-Filtering-Correlation-Id: a39d7938-95b1-4d02-e841-08df4370785d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|23010399003|10067099003|11063799006|56012099006|261026121527099003|261026140227099003|261028144727099003|261022105027099003|261022075727099003|261021123027099003|261021121427099003|261102123227099003|261009223027099003|18002099003|6133799003|13003099007;
X-Microsoft-Antispam-Message-Info:
	FCefLwfoOZPFNRKM/s02YlrKiHuADfY/pZ1oP9CerjSYWJY2JbqGGUSFbcq86lm2kKIQFhi05pHN/tImw059WmIXoOeGpGWrgwQxZuH9XH4fJdFfs0RscOHJM2wpf71A3p7DRuakUXpf9ACqN/rsY8MylovFrW8/kPl39n3oKG4NFEJU/iLUkKEsaIOKsvF53X69sOn3+c9amjfgvgXSGtLOyy6FmSsbMqqjSG+YCGN2Llr8eSKtkdv9pgt9ERsBUKTp2trebEhmmlmXDwMQ7oRgBsfgPPwtzrfs5OsgyA6z1d4O3Pv75U8Wnv99D2tQRdbCHUoonbtBcr1kkw9Ai+O6Li6O1xDX64Lk8qkyv45E2/yeJsV3ZxYo5BM+F21k00LS7SRQpeYvVkrh38r/DGZdxuFySXw6PlvxykMnAa93RYJ0kxDXC2IXtoAmaz95J+Nq5dsUayPvlbRagPiZ57PIqdG4c2GVuEDkpr+y1jd2qZPUWv4FDXLXq2ozcDSEEe3tb/b6z+qPgAYyX4nI/I1fX7Iho8s31NJetWjMPfRGU/drdKbeqEDjdmtbFBGWHvgP4XQo0jF1ytuPnf5NVyaa1g8HiQzRLiv/oHandDTUPiGRjjI2PnXfH31bwpt1v5LrpagMMBmrYCjm9M7iCaSxy9O2zOi0DrL4WHvMMw8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(23010399003)(10067099003)(11063799006)(56012099006)(261026121527099003)(261026140227099003)(261028144727099003)(261022105027099003)(261022075727099003)(261021123027099003)(261021121427099003)(261102123227099003)(261009223027099003)(18002099003)(6133799003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kJ28UUC3CW1NaWmeKySHF4iPcvcUJztZR5PzDxD8UBrF5i/AWWT1rR8EyZ7X?=
 =?us-ascii?Q?B9jm6GMvDuV9hXs9DxO/awzGxwEdvJsYVBJSO20EtoycXAjHwIndol/GcD6E?=
 =?us-ascii?Q?5BKvM3+Zw90QkdSCZcduEf3n2k01+k38tGefUqOly9maWattmgTt16C0Cy0z?=
 =?us-ascii?Q?96ctUB6sX7PeJ5soLFSmvNgjMZ2AbvMwxqOTQFxwwKc4YBsX1qidvF22KO4v?=
 =?us-ascii?Q?2PVCZWw3KkUyLE1lc8brdy3cTPKgwtKxfiOjUQF8Sj2vfqlyov0t6pZ8Kduh?=
 =?us-ascii?Q?SpNqoDDahUGVC4Zztf8v66hbXylRDtGqzNJBDkLm3vyMk3ld2U2rNW5YJMmF?=
 =?us-ascii?Q?7FoRto7tisdWJ9lSGs1EZjlNuIK3UxNBaFaOpmqC9UANgDVX5T1DUzmbgCqf?=
 =?us-ascii?Q?Vv66n9wyNSB7PDwYAMtWQjRe3g1jHe8/4O42mkxdJ8HhPg1zzk+ZLRhg74lT?=
 =?us-ascii?Q?m0g1Tr2Mhg1oTjcCIwI94OuA4VuAs6NG/EAbhg59M0DGslpNXesJ7AJCFu5n?=
 =?us-ascii?Q?0cleTA3iWoCKUIxSMOygfU2t11z3qKanbhSc6u1ahWAVs+/sFqhVU3jHIIio?=
 =?us-ascii?Q?idCS/pJrz0KB+DXfKaVKXHdsRrlZ5dt2mDh7erX+c+bSecF/JNMVeLTVvScA?=
 =?us-ascii?Q?MBpfD8EGWXNNtSW3UVV/Qn7M7iEWygU3Racsby8ek+kL7swLn69Z8VL9eI1L?=
 =?us-ascii?Q?gKTvV45c/gUzWytmoJwB/3wRlsmoSThoh7Tn7Ho4vxDFNtcVyC38ldifaXDt?=
 =?us-ascii?Q?XMcR6LBA7crc4fO3LjpWSDoTq32767i7T/X5fvCISPhZomrWpK3zP5aub/OA?=
 =?us-ascii?Q?aFA0/67/Yy9175OWE8PvpkxjKj0dgTnEvNVJlw5huFSsgqwbSE76JI7OILDc?=
 =?us-ascii?Q?QobvtCubwVw+Y69ydmuAQnsU8LKwaSULpKQO97ltYkw9yNh2ibZTkLauB/Rb?=
 =?us-ascii?Q?CYu1tRTELNNbqys4aifnYmG4bg0DJYEICkWoalSMNQum518F5K9KayPoTeac?=
 =?us-ascii?Q?slj4ZPsqwNyt42SIeNzrChSIy5gDofujV91T49BkcvCaTUqKzoeq0CZHohNS?=
 =?us-ascii?Q?m7pVKL725ihY08BYXGpqDsvRT3gkv+YJlblxT7tcfz3jZH3LEwzus0htQ84O?=
 =?us-ascii?Q?KbqahGG77U/tLqD/bWTE+Iih2SWqCXVET3ryHbBqtdhBnzCpuEMg4Q+H1xsP?=
 =?us-ascii?Q?oPhigJRtKGbblBue2Rkqf9qYC0j6LTRyFsI4see6ly+QfSoTeB3N8xrv0gq9?=
 =?us-ascii?Q?ofaQ2k6DhMDxVHP2IKx3dY2kwn5YsojYh8zSMlAjgbt68KfoYstjq68XCBlq?=
 =?us-ascii?Q?B8GQ5C945D+sTSupAWQIG5OCol0ufdQYf29Fg3r361njK67y56U2W34yVSDi?=
 =?us-ascii?Q?nGzBoMvgA+TboKLO6+0uX1zNcHPLFwNEXiS4ycN4cgFBSQlUaZRA4vtwdj9t?=
 =?us-ascii?Q?h1GztgD9O8NZl4qdqRhTK2UIs8Vm7Gnr/M6KcMY+iE65aZK4AUvYyeuBVGdu?=
 =?us-ascii?Q?C/WbNjel2clFjksNz861fMmWrmnhQFEbOfhfDTo3L/7pYAFD70Jp9Nm3r8Ph?=
 =?us-ascii?Q?tegqP7v/lHGH85zJjJz1E3TFGkZL0744ihcHalEvHCVBW+nlc4K49Ye+CJXS?=
 =?us-ascii?Q?zNfrx5ycuDuRdvrpGHyvexdgYpx6ZbJfvIgW0clxf0u6EbjgFkNEm818X9xy?=
 =?us-ascii?Q?+K1PsUlpfrArTyN5+rlBILz6TVqY+xNMtjcfoArHfVI+msPu?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a39d7938-95b1-4d02-e841-08df4370785d
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2026 23:30:44.5640
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zEhn/n4ZkAT0dOq7tQVOwUNQDalSy0mWwTWrJb5mu3BHdPj3LhDqcm52iAEh7wP9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8815

[ This is the last series to move SMMUv3 over to the generic page
  table. The whole branch is here:
   https://github.com/jgunthorpe/linux/commits/iommu_pt_arm64/
]

Introduce the generic page table for what the ARM spec calls VMSAv8-64
(ie the long 64 bit PTE page table, io-pgtable-arm.c) and use it for
SMMUv3. ARM is by far the most complex page table of all the ones
implemented, it has the most runtime behavior variations and a lot of
features.

Like the othe architectures, the page table itself is supported by a kunit
compare test that runs operations through both io-pgtable-arm.c and the
new code then checks for identical PTEs. This is on the github link above
but I don't intend to merge it.

The existing kunit tests for iommupt will automatically cover the new
format as well.

This is the final series migrating the SMMUv3 driver over to use the new
functions and remove io-pgtable-arm.c usage. In principle the other iommu
drivers that use io-pgtable-arm could be converted someday as well.

Included is a mitigation for the CONT under invalidation errata, extended
to work with paging domains.

v3:
 - Rebase on v7.4-rc2
 - Split the armv8 patch into three parts, generic, db, and iommu
 - Clarify some comments, mark some more debug things as WARN_ON
 - Use tgsz instead of granule for consistency
 - Refactor checks into armv8pt_validate_features() and add more
 - Drop PT_FEAT_ARMV8_AARCH32
 - Fix make dirty logic
 - Use arch/arm64 constants instead of copying for SVA
 - Mitigate the CONT under invalidation errata
 - Pull in the left over two patches from v9 of the precursor series:
     https://patch.msgid.link/r/0-v9-e1637b95096d+d83ffe-smmu_tlbi_jgg@nvidia.com
v2: https://patch.msgid.link/r/0-v1-807e2d1a5efb+e1-iommupt_armv8_jgg@nvidia.com
 - Rename granule_lg2sz to tgsz_lg2 to represent the ARM translation granule
v1: https://patch.msgid.link/r/0-v1-807e2d1a5efb+e1-iommupt_armv8_jgg@nvidia.com

Jason Gunthorpe (13):
  iommu/arm-smmu-v3: Change how the tlbi describes the invalidation
  iommu/arm-smmu-v3: Support the DS expansion of range invalidation
    SCALE
  iommupt: Remove the sanity check for pt_num_items_lg2() at the top
    level
  iommupt/kunit: Do not test INCOHERENT on anything but x86
  iommupt/kunit: Skip test configs without supported features
  iommupt/armv8: Add the 64 bit ARMv8 page table format
  iommupt/armv8: Add DBM support
  iommupt/armv8: Implement the iommu specific components
  iommu/arm-smmu-v3: Remove io-pgtable-arm from sva.c
  iommu/arm-smmu-v3: Move the DMA API comment to flush_iotlb_all
  iommu/arm-smmu-v3: Support CONT in paging domains with errata
  iommu/arm-smmu-v3: Use the generic iommu page table
  iommu: Remove pgsize from iommu_iotlb_gather

 drivers/iommu/arm/Kconfig                     |    4 +-
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |   44 +-
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c  |   49 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  609 ++++++----
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |   49 +-
 drivers/iommu/generic_pt/.kunitconfig         |    1 +
 drivers/iommu/generic_pt/Kconfig              |   12 +
 drivers/iommu/generic_pt/fmt/Makefile         |    2 +
 drivers/iommu/generic_pt/fmt/armv8.h          | 1076 +++++++++++++++++
 drivers/iommu/generic_pt/fmt/defs_armv8.h     |   23 +
 drivers/iommu/generic_pt/fmt/iommu_armv8.c    |   13 +
 drivers/iommu/generic_pt/iommu_pt.h           |   14 -
 drivers/iommu/generic_pt/kunit_iommu.h        |   27 +-
 include/linux/generic_pt/common.h             |   38 +
 include/linux/generic_pt/iommu.h              |   72 ++
 include/linux/iommu.h                         |   62 +-
 16 files changed, 1738 insertions(+), 357 deletions(-)
 create mode 100644 drivers/iommu/generic_pt/fmt/armv8.h
 create mode 100644 drivers/iommu/generic_pt/fmt/defs_armv8.h
 create mode 100644 drivers/iommu/generic_pt/fmt/iommu_armv8.c


base-commit: 7475ea8b58616b33c04afb976cf0fbaad9dd63fb
-- 
2.43.0

