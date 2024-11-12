Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2081.outbound.protection.outlook.com [40.107.94.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 705522178EE;
	Tue, 12 Nov 2024 18:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731437508; cv=fail; b=bJgcOuTGDEySzM5s+XMAOLNiM6JbASKZZ8iRxi4nFX1sklGybA3klStVHIrqwG2t0m8n5sgcEjMwU3iTAQojnzCZHK6UM5yFhw+qElaFMn6xP8wEYICXwp24VfwQSgLX4bCzQaEz2lBwuHFYIw4FjMZ98iViumzwo9aOXvIOY64=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731437508; c=relaxed/simple;
	bh=YwLxXyONxT57nSKd5dUNSSmXLzAWs7YnKy3Y9w7PjTY=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=u252s4MR75rZZ5yk5vLTRfpSw9+mLCS8D/GxU6FiZrHn+FnptMa5JNcle9UxLhh1KhQijrCn+hKrAkuxKwcS6bfivHzg072q7v6zjxvjrVi3sjDMXeug5uBgei85LrInhAetwnecRm/boAlyIL17JZe/uts3rJuD1NHlYJvGjY0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Or6r5CnV; arc=fail smtp.client-ip=40.107.94.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Or6r5CnV"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I7rYTqFLSBPgP94FZPgw9XsBm69Nyopv9Q7U+NSmWMAmQTCTYcPG0sh1dH/+Aw38gBLC2z82IkzjuKVgv1+yrRZC0i2b2oNh35BcuPHVj7n06TTMARfDE8Lpwp5XUWmUqL7dckQqJJjlmAVAELNRWC1RJPthWfKhSkV5N1G4P+KfN73TZmdtIiVPiwTnn4YB8tZOid93uQGvz+McDoo1wAXF1WLMmMf/B+LpbKOAWT674MJT0tMMztXJ7pbw3L/RqRw1NBWTZie9ZvWo+rOR4M3w4ZwPlo0KNaaYobM/oOGQLX1w8mPG3r7zBVVNfRNjgira0UTeEucb37Uoe/MwjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EGMUd8gDzf1tNAM8NDYrfFbVS4/2J94KgmvMGetROrs=;
 b=vdUHuG1bLk9jqLPijUTKNi7Mxc0+AOVtlXKFasqpjeAPUw4ExLrC7GoWYyZ7AOSs4Mfk57l+3lU5OUMJVycRrQfMnmAudT/62ynQiNEdgMq9cHW7BqeQappJbc2RUC/NEu8i3z5I6qZYNIXfs3gS4YeIm2PddEzIvvihRe0NoG0rrnuwxFZhUo1c4RyySv9g9KffI/dqI877ZzydTh8+xxkSmqZVw1lUEfFUCW7EwF4aPZMhI9KgeWI/fB52jOSuJUueUtzIoTf+0eebi3LxzHOKA7k7uEvWKUcHaS9YfFWJ0eIN/QGJpekn7WdjBO66LttcnBC+kIAaf20ubkTcag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EGMUd8gDzf1tNAM8NDYrfFbVS4/2J94KgmvMGetROrs=;
 b=Or6r5CnVs62PyGFz3ScJ6fGrADTSQ2yHkRmgtCGp8jnHYKpJzxQeNsxiNEJcZp5Oof0pvKWY3neBUpyvhE0xPeXB87+KWxJuzP1/OlFIPoxSENttMS6qWc5n1KuNWKhb8zsf5G5M6LJvk41azeYwpobTYu6PynQoDkXX2l+iFgzxiGyLKood81nbu3QoftZ2jp3j4HUT19Kr0Y0vWrLff6daem4o7J/nsrdhBP4s8Zxuq6ic3IJLdy6rme8gyHL9YrBPwG7ngIBCK7Tp8NGt7ENvkR0vi0zaefd7XiGI/9oWCj36IBV/reh7VnKP+ibYypYLPTxN06X5aiZN/snIOg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by IA0PR12MB8982.namprd12.prod.outlook.com (2603:10b6:208:481::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.28; Tue, 12 Nov
 2024 18:51:40 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8137.027; Tue, 12 Nov 2024
 18:51:37 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Kevin Tian <kevin.tian@intel.com>,
	Will Deacon <will@kernel.org>
Cc: patches@lists.linux.dev
Subject: [PATCH] iommu/arm-smmu-v3: Improve uAPI comment for IOMMU_HW_INFO_TYPE_ARM_SMMUV3
Date: Tue, 12 Nov 2024 14:51:36 -0400
Message-ID: <0-v1-191e5e24cec3+3b0-iommufd_smmuv3_hwinf_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN0P223CA0006.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:52b::6) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|IA0PR12MB8982:EE_
X-MS-Office365-Filtering-Correlation-Id: 7561f41a-345c-44b6-c8e4-08dd034b094f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?EKhJcUDrgVumKlq3YXN9iyMwNU2JXOmOh1rEZBhSwnHiqWn5zBQnOqk2xWze?=
 =?us-ascii?Q?Ktjz2JciPMXfb/saH9VVVg+XUyX524qZ8qdjtSaMsqETtuRmqNWMhw0UfZFc?=
 =?us-ascii?Q?0RFZn4z9MjH+ufpmLc6PXh87ICd+QTGuCS1hte1XIRpP0jS8WaFCKVHNs0CQ?=
 =?us-ascii?Q?6T1CT5Jb0g0BaGqIEOK/nMVdK7nhoyzJRkcRFj3MnrllraZOY0uVY8DtJtYG?=
 =?us-ascii?Q?Jk97hrKqPNu111H2nerQHmhAHLi9uvYV431096go9g4YeP9hwNkuOega16XQ?=
 =?us-ascii?Q?rX8egsK5PfNi7U8za3xzwiNCyR88/7cmfZxreIcOSPIbL+bOwsmnB869FcXI?=
 =?us-ascii?Q?lzvf9qUFcOm2arpgWjZNEjSnDALEa7KY/av7dfJuGS+ksQopViwgHl/whc2y?=
 =?us-ascii?Q?EeA+K43SQW7QFDbnovm7VDXZfJZlHz6QBE+m3yUAwGOFR43M/9LWPwPAhScZ?=
 =?us-ascii?Q?UA7PlaVFzmdW55CKAtNbWDM05lwcHhvSIhq1djTbYumGzRyVwlYoGuKUcL+J?=
 =?us-ascii?Q?vShtIvRlDzN50vRURyFaAnXDFEQ06XP5h8ylgKYm3J00y+q1mvsp1ugAn1E+?=
 =?us-ascii?Q?dpo6uzebaXc0kJ84ykVKG41+Vyl9VwlU+GhfpZQpwBBW3+TYaEUPif8s2RuJ?=
 =?us-ascii?Q?8D8z7fSX4QfryArj85xAdLGTCjC6ZidXjuDeJRumi7b9J5bIwajzfy25RQn9?=
 =?us-ascii?Q?RH9MmUWQdRKlT1sJnr1nOnQ5rw1FQBSaT5mSY1vTNxjevlrQP+ZQIZchtlNN?=
 =?us-ascii?Q?DXbY9aXGeT1wjraqmsl1xgyv9FnA3uRXAf2krqfRZv28NlXNd88NV6u9WmcH?=
 =?us-ascii?Q?X7jEEmTVBIe+AC0i4DPN5hcEmLxvrSWG9SLPBjYaP3pst7P9MuH7M3gg+tJc?=
 =?us-ascii?Q?hfRhiFrdxNEIILLBAKtSJ9jZZc0SUZvBiS8WWxR80kpRlimSPJ724iIMJS/L?=
 =?us-ascii?Q?YBVqj+aMp7AbwfpYQWYjoNQ68eIRFQOeWdfNaWkA7jJCQa/OK0RYxR4BZb3z?=
 =?us-ascii?Q?b/GKwC+f3alq5QhCq5PAlmWL3soPSN4lGNT5+tpzpRoJGvtyeRWrgTC7izxf?=
 =?us-ascii?Q?/YCt98cpo/LX7wQpHep6X3ouMO4pbLRYaVsc8hndNglzjuBPbmSsBttTYkuI?=
 =?us-ascii?Q?4qnhlDPKLk0mPvGaVlQVLbS9Nu+wjjsdt4nF8xJx4n+4UXfijyYVbGID4v8L?=
 =?us-ascii?Q?fRJHSN0bSJaCr4ieby37KcYU60DXB+YMdIgdy1sxJt8s6EDBjja8JpM3oxiG?=
 =?us-ascii?Q?RNKSlxHSeVdJcU8o5TOmhq85mX1B42xETpp+jyqk5mYaDb9gbemAIjFUBEk6?=
 =?us-ascii?Q?DuTXlksT943k6/nWLt5PmAep?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?UQtV4aZCLR8iFDnrUEE0YGP0qRJVQLdxQg9W6NMzZ3pq1im9D3OYro0eN4H0?=
 =?us-ascii?Q?34Q9nPDdd0+gEbmUBCp7B2TEaJdMmqT9RbeacjiA7lJvGmrb0xb5qLkT0+/8?=
 =?us-ascii?Q?NdBjyBwkhXjhpZn+L8qirG4dwQp7GK4tKnNXPUZ6g13IT4HJPef9W5tuLxun?=
 =?us-ascii?Q?lr2g8MRwS7MR+vercDRSBFGbsBN8xv5fB1PSeEUcZUin+TINq7xZSl5uZfIG?=
 =?us-ascii?Q?4GZNZc2tvGopTMhmL5Mf7hE5sXk3b2dHo8OMZx6V9S3a5JLexjuqabv54QfF?=
 =?us-ascii?Q?M1uLwe9xCOpu0XlzIPSnTQXbw2GQKenXJOHiyCjtLagGxAWXxxq/skT7L6gI?=
 =?us-ascii?Q?8//dkTZ7X8p1KKDKrcwzDMiomSr4oD37+4BhcSzm4gSPsD4Dbl7jnuwBCxNs?=
 =?us-ascii?Q?QQuT4RijGHWanPOkDOVwTiuxph9hlPzgMFpEqJTKN1jyIMMSlzqK5fEzfQRm?=
 =?us-ascii?Q?VW2LHZA62RB3GcCdGdLYNtNdscBoik+v+tfl4MdAwNHujUV2BJAynb6Bb4lx?=
 =?us-ascii?Q?NciUg3ej7+NwCc+7bdE+bAn991l7yS/QQSFS7teXKcru2tuklxlMegylgWRw?=
 =?us-ascii?Q?KnjFgp9mJSWcO3e+w8aYsuz8TVhhIOxOHjL09JpSMuxsReEuMLlHIhZO4XVB?=
 =?us-ascii?Q?HpuGVDd4GlM0BLbj8bZWsZNMEw887UyhxIzo/3x+ajioxgmGqn9rQnYXGz1R?=
 =?us-ascii?Q?IymTqK76u9NxTy4b3hYKSdUPboyUpFvsi15sVyz039EjkUYAud7erpXMC8De?=
 =?us-ascii?Q?zag1OR/OJGzlWo3CigrTEzuWiKh1HHLHXbaOQwIvN6vs0jZlde/EvQam3J0u?=
 =?us-ascii?Q?o7ULNcNnez8Hjkr9jRdDNBesdaPuvkcxUqrB7mlhHGy1WHfVq26d+qX0Fu6O?=
 =?us-ascii?Q?57A9KoXIUG2Q4v9pb3ODllIzvrJZDadEVnQOwEmxqJXgxDJYW05ZkgcCyzhl?=
 =?us-ascii?Q?9hw/7VH2gxMXFjsqxwFExxsBxKLR4iyCrZu12bnPOcrMR9JVV3dCLG/sBWcm?=
 =?us-ascii?Q?+VI6vzgucn44FyvFzly+lK3nIc2lzIqO8G1S3JWHm7V94/xTL9GPEGwRCQC1?=
 =?us-ascii?Q?2fWY8/N/cIgfrl9v+8+eYrhpMPgnCJFzrj2MA5zCDcSuGmduDF33/blhsTkF?=
 =?us-ascii?Q?HtL7Jn+rxiG7atln9XJUrd3Zn+H7X1s51saSZCanVqKTWts55K43YOhCuAYy?=
 =?us-ascii?Q?jwXwZjpBoEGo9dfKpjakuB3jOkewue/Y2F/Toe89SbftKXrA2DeKDS0A+k/m?=
 =?us-ascii?Q?eK9r40w1N1kEe2mTtyrC+WMilNDKRpm3dBPl9NAUOXEE0mkVu8Q1tyM90lBt?=
 =?us-ascii?Q?spzcV44Gkj3dXASt93/G5dE446g2TZgrA7pSuLc6Y/SP3VVVEbrEJqnAmVn6?=
 =?us-ascii?Q?AXVe2XJT0Lv1PTUZ/Jv6XaRsYUkTPpL+NVsyKWlseYWQtKqwhZcgu1xex9pq?=
 =?us-ascii?Q?CznVFWalwkhOOKaGxhp0OZjCiqz52ULrwpTe0rhcYJdtHg5RQ5JwphmaGzO/?=
 =?us-ascii?Q?MGGYIrl/CADA38ATVnYTHjDmP3SLHu1ZDsD5vAKShOydQPcDOCj5Y6YVmCkE?=
 =?us-ascii?Q?D8sUH/iFHADDsVEHNg41Zxb6p+rR9YaOXMf6Y6nA?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7561f41a-345c-44b6-c8e4-08dd034b094f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2024 18:51:37.2283
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iRvwhQUHAc0g5RU3pWaQrbvQYeSutNcUylJ4DUfY5S54yzrQ20o1JbARLpjtoi5m
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8982

Be specific about what fields should be accessed in the idr result and
give other guidance to the VMM on how it should generate the
vIDR. Discussion on the list, and review of the qmeu implementation
understood this needs to be clearer and more detailed.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 include/uapi/linux/iommufd.h | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

As posted in the other thread, it is a enough of an improvement I'd like to
pick it up for the iommufd PR.

Thanks,
Jason

diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
index 747d3d9baa3dda..1e0345a62a3ab8 100644
--- a/include/uapi/linux/iommufd.h
+++ b/include/uapi/linux/iommufd.h
@@ -549,16 +549,25 @@ struct iommu_hw_info_vtd {
  * For the details of @idr, @iidr and @aidr, please refer to the chapters
  * from 6.3.1 to 6.3.6 in the SMMUv3 Spec.
  *
- * User space should read the underlying ARM SMMUv3 hardware information for
- * the list of supported features.
+ * This reports the raw HW capability, and not all bits are meaningful to be
+ * read by userspace. Only the following fields should be used:
  *
- * Note that these values reflect the raw HW capability, without any insight if
- * any required kernel driver support is present. Bits may be set indicating the
- * HW has functionality that is lacking kernel software support, such as BTM. If
- * a VMM is using this information to construct emulated copies of these
- * registers it should only forward bits that it knows it can support.
+ * idr[0]: ST_LEVEL, TERM_MODEL, STALL_MODEL, TTENDIAN , CD2L, ASID16, TTF
+ * idr[1]: SIDSIZE, SSIDSIZE
+ * idr[3]: BBML, RIL
+ * idr[5]: VAX, GRAN64K, GRAN16K, GRAN4K
  *
- * In future, presence of required kernel support will be indicated in flags.
+ * - S1P should be assumed to be true if a NESTED HWPT can be created
+ * - VFIO/iommufd only support platforms with COHACC, it should be assumed to be
+ *   true.
+ * - ATS is a per-device property. If the VMM describes any devices as ATS
+ *   capable in ACPI/DT it should set the corresponding idr.
+ *
+ * This list may expand in future (eg E0PD, AIE, PBHA, D128, DS etc). It is
+ * important that VMMs do not read bits outside the list to allow for
+ * compatibility with future kernels. Several features in the SMMUv3
+ * architecture are not currently supported by the kernel for nesting: HTTU,
+ * BTM, MPAM and others.
  */
 struct iommu_hw_info_arm_smmuv3 {
 	__u32 flags;

base-commit: d68beb276ba26cec47350a6d468e967673ee0c56
-- 
2.43.0

