Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2084.outbound.protection.outlook.com [40.107.220.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F64821FF28
	for <patches@lists.linux.dev>; Mon,  9 Jun 2025 19:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749499122; cv=fail; b=bMBYtjAD1MMuOquMdw2UCy178HIkPC/pKvTna+ptKEgKpqOzambps/mH4RsL/7wQJiRm8+SeQpWOX8rjxev0XApawRxGB362e4uRm7c2Ab813vcEQHakDvKOXTvlrgy2vm4ueKREprMbd/6RWx9ou0QkZ3j0oQsyguKEUlH90Bc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749499122; c=relaxed/simple;
	bh=LbzU+8Dp+uF749sWyrWR6MzYsN+o7PPjC3jEkdIXOfU=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=DmFHQlHskHlsr+QIYKB9NOmlLckfqsdMK3ak8oW3teUXbsMqJMlpf+EpHNPLSU7XKkR0OBrYmyZ9Zl8rBXH/i3PcVLukE/pqJcBab5C/D3PrjRSeRkBdq/dWNpfk4F4ucJtgN5bgegqclBFCHXcp65RWscYWrediExbSndMl6rM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=agm3Ydjk; arc=fail smtp.client-ip=40.107.220.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="agm3Ydjk"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=soVjdRMQOPHy4J7LLAdvQTP7yx7X4on5yz1P77zXz/6wkrF/4i5ziJbD9FYGgNUY/vBkbdW4Ku5vhrNOFbT8tvFU/PmqkOw8zdY4YcxtxHC+zau2jH8YQML87QwpeZE0KXnoHOhexltpweVu8sYkhEo4mrzaYek+8q5XLv4b6gEcT/S36Vc38CwHAOalrPmbJitqyXPc7GiQBBV2Dxdh+3KD2L+v6pNEdniKHEphYHp99msrqvHM1SaEGzSwpBDzMU9bmS9sUyDB48RJKeJmmvHAZUTssYOEjmA5k0noGD4Z4CHHNjR4JLsciJYi5zkPUrNPC+CYDjyyECxDDI6bfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Aiwb/zXBJwqF3FxhT3w6sTuK30qLXVWIepw7LG4mrDk=;
 b=hu6nM7EPCNxyxEc6zd983+hSJsdOmzzb3O7MGXgT3l4ArjuqbdMOmOsDOZgiCGPgYSw3gxy8nnDnYbM9AshUTOUxF2Sh4h37y1H6aqt+fFci2YyB4S3yGQgtrB+AtYp+eGBd1GXA/SskUVPepAV5ThVNn5370XAp/NkuzN03TkjGqTuBwArIirRMKppCpeP6VTsBqYenjTabvp01NRKm05sgYd0tciYeEb9tV9M9V3Pxi4tGNYjADN9X48Xt8vwcKgZmB9kzZerqIOYtINbMl9U06cuXC7w+VIrsZmA1opyeBJzqn0QkSZD8+reLdsEqDdCBe403tHjcG16ECXUbSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Aiwb/zXBJwqF3FxhT3w6sTuK30qLXVWIepw7LG4mrDk=;
 b=agm3YdjkO1g5gNoNy3+OKb+kvcRa3TLER50ydz1D9jHAykyZTQhyuRCAgPT2XZ4ZK5XHjz4Q14QCHLi4PdRTq7rABGzgv1mP5WarxigK+KVDq6k2ratmxX9RKxBqBiTM1MjoMLjQt2i9g4sOfSmKvB5aL/1pF0zQzeZ1RdjyVV0gJolA7hUK0tndIKJua88twQuhIT7yTEGV0m+PhFbmkkc65i3GeAJEaETKG6tDqlzFbBSD2VvnQxjgsZAiBfph5UYh1uMxU18AJUwRgcbMy63C1IJrm+n/Ws+70MUZ6MHkuYwpjHfH58bFTP3YSO/slIph5NhsvJVwjyFCNiMEfQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DS0PR12MB6414.namprd12.prod.outlook.com (2603:10b6:8:cd::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Mon, 9 Jun
 2025 19:58:31 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8792.038; Mon, 9 Jun 2025
 19:58:30 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: patches@lists.linux.dev,
	Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH 0/7] Reorganize Intel VT-D to be ready for iommupt
Date: Mon,  9 Jun 2025 16:58:19 -0300
Message-ID: <0-v1-20c73f153f4c+1895-vtd_prep_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR15CA0051.namprd15.prod.outlook.com
 (2603:10b6:208:237::20) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DS0PR12MB6414:EE_
X-MS-Office365-Filtering-Correlation-Id: cf6f962a-0dcf-4d0d-beb3-08dda790008b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?339Ml0aU+gYPW1c7dfEMj1xjD6EE2ONnGw3pG1oa8MRAosiNHamb8H+t4qsd?=
 =?us-ascii?Q?bqHlKEi9KRlrCNux4xi0PD5oByW7w1tSpT6nnb9NXxMipPBVNRhN7kAgAHxm?=
 =?us-ascii?Q?4QRNHpFN83pcRpQ3g6Vdtj/lsuJOjuM1M3uqEo5m61FlskmBYRYzVB36/mhU?=
 =?us-ascii?Q?f8RZXSFVclY82DcvHjXZOp6JleyYQSWpfsD/I9LcAGs9wcSTr2KYlCFcQEe5?=
 =?us-ascii?Q?st6DZsMgjoFM9NJDiE2UuHFXwBmplowOCN+67z9WkgrpXtyimjO6+w6v30hZ?=
 =?us-ascii?Q?M9Gz22802TRgdTgsK9fmZGOJebwyq48et0rvg5igwwchg/UPltRID5tDFUY0?=
 =?us-ascii?Q?lwT7c1jHIdmLcX9zhYarkxirHjheOCvI3zQKWrwTL3QeF1oL38WeX2QRFKmv?=
 =?us-ascii?Q?7+kf2FxiOPp0x4xxJLRhp5JaEzR8sfSPMoTsWE/h8x9InitJ6PPhzexGZgF1?=
 =?us-ascii?Q?55J1WO94C474XjF5bBslnNRl8xvQbAJI7dV2SzJ2KfjytL0qqhKq+p2bAZEz?=
 =?us-ascii?Q?63TW5ljToYXW++BZlN7lGfnlIrnLYr/lB2hPbIBDDCulTnRV+Oc+8mDEt5dB?=
 =?us-ascii?Q?cLTE0tzr4/iFUHxSGUOmFp9Bk9haXzWqbSDmc0iudI4s82pDtXq6EU42YbUM?=
 =?us-ascii?Q?1+pexcYa72TZemqx90CIFB7pQH8uvUCLNu8ZeaD4AVB9cUg678FeuGkBRSpJ?=
 =?us-ascii?Q?KRRXIv2xU7HpuCLP8e4doyPkc4dxorIibMwe9DK4fWshfgYYx1m6fFkyv+Mk?=
 =?us-ascii?Q?cbToq+QzHLVK3quLzXbK2jz5tHMhBKH9NE2UoFhTN1ykyuZW4j9wfcORIpp1?=
 =?us-ascii?Q?2SjcB5TZyW7gxBSqa/uJFcdAaxbKxllOxplEZa6g4O2+RCeQMSRdQKhTXRfq?=
 =?us-ascii?Q?zR9+vteGDL4NXRl8RrouG3OYIopo+K1H2woV9tyxuq7f8OwH035VQ44irj+F?=
 =?us-ascii?Q?y2+C2I9MnW7Jvk2/RmgTgPFVdBWx345NWxeukigc6hGCAAMcLL60ta5EwfNJ?=
 =?us-ascii?Q?/5Lw19NhJyQK59Ln6LkDn7VMnfEGIjWEWaRWLgh5O13JCUGUKtfgkIpEG8Ye?=
 =?us-ascii?Q?Np09BnvqxMbSMNg3N24TT1G1p4PPN5TIWQ0rp2tdehNL4VArj+hAA2TZTnR9?=
 =?us-ascii?Q?bNhygle0GRZdhag3kBwbBi6Y2n/qie74fv3ZYRcsoZAAsGOb2kqKnVYuThEF?=
 =?us-ascii?Q?M4cU14pcUHwcv6+Toi+JfykiAONdAeQd4BKvj/WXiq8WOE9r6xlGNaQcmKbL?=
 =?us-ascii?Q?J1RKemaL0PGRKfJJSxMDS9mWRlMf5A74qy+UUd6/gHSnH7IIoaZ1yajxuWlY?=
 =?us-ascii?Q?gEI9Wh8D0KBdBGXFxYeXTex/iGItVs9/b5ArWi7yu9QXVLEr9b8lSII/iV7N?=
 =?us-ascii?Q?ov7EoPZJz+nCgMZUV9uB74P+6c2YstV0S3sSeWmhXSJQEicnrdBjsEzteQyk?=
 =?us-ascii?Q?wgn6jCKP7Lw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yBkpcHxkusa+zLspHR+AWU/zPrydGLgMZcPnApmlJdoRzXGuv86fWSIRvQ7N?=
 =?us-ascii?Q?eNPgwxP2jeEshdLXBEjpbk/XZ6B9z6ulcX4WZnulTwTd7J6/j6Nit5GPcv8G?=
 =?us-ascii?Q?nJneAmXs+IAQSEQ0Ue5cJRMQUpKnJJrfw5h0p7bENFlmkfv9dB5E077vVN1u?=
 =?us-ascii?Q?v+6XL7PxHxGgVKz6xhwgl+lGh5yB0jnpMMAfstTQKBL8lo7xXzPsJJ7ISRj0?=
 =?us-ascii?Q?AivPOYB4BnOkRqjdp6PQ/FWJNdw9KoebOMfyo6Y8rnOX93HXVXJYF6Fi6xOd?=
 =?us-ascii?Q?WDyzS67wm4Q5OUePUkCuSSxhLrld0sXq0viCjHElCTGiK+zV7r6ipkcZOol9?=
 =?us-ascii?Q?OYhK3zrhw4iZ56E3xoSvDEfFS1UlLp8e0KWvktj7I1fp7+SmDPfdjN6htggn?=
 =?us-ascii?Q?wE8SDtW/EFMDN/DbgewfVBoeIyE685caoP4ypWQSvPpJujHdDaFJMkr2gxIO?=
 =?us-ascii?Q?3nfXaSGDqeGFPX6QQmYEZaw6ZKt3O4X2zcGJQQeWtNW4bvEZX0qE97Oz8fOX?=
 =?us-ascii?Q?DUQEpdtLfldhRjeQj817JsScIuRHUANOYZ0PMY9bWuUSIVWZGUIVSyFK/wg4?=
 =?us-ascii?Q?V4sRgH6roO/ZSXsp8KD3uZ68zx+wOlv0InZOR7ZfFFjr438ObkCGhGKgNFpt?=
 =?us-ascii?Q?srgJXbMe7XtqOfG79v/MhUhmXu7FjjB0hTAcYTRwX2koDuxt+rE/Aline+gC?=
 =?us-ascii?Q?SiJtjWWgvd+FdPEyEt+0oOFYCm1BCQk/DfQjKUa3YmyZSjGHH368MVOzX8DN?=
 =?us-ascii?Q?AF9aFzLngc5h65LY7kDemasXG+y0xGoQpgHeQVASOZHi4xkR+6KuB3DyjOX+?=
 =?us-ascii?Q?y0fsWy6FGYBJD3isMwuFNKYHtmRz6XQ0y9JU7PGT/OT2Tm9DiZBV22Svlre3?=
 =?us-ascii?Q?+PlqfiQ2FWm85NDtgV/CAqGmVwc48i0cMX9dYRKLaC35Eund6swmZHP9FXWb?=
 =?us-ascii?Q?zDF9hVds38g2qMgrMfgjKgKXE14jdrmCcAKeOJCmQK5dD78jakGD1U+jgxb2?=
 =?us-ascii?Q?HP0jgL7gpM/5vdl5ucTJqZOjBMO8SUKuFPshG+YqPfIEkrKnLf37LDPxziOQ?=
 =?us-ascii?Q?5q+PAdX7QDhHdurBRPWwpyyeyu0alVKvL7NhTF3JAfaI+sqi7vvEExof+4cf?=
 =?us-ascii?Q?PqpziJK+RgZaxu7ORhIeegePxzkGaxLgHIbZj/3JdTj49ONP/SIVczFHzoKa?=
 =?us-ascii?Q?ddrCrxRTDR0am0U2PnVmPyAPiV4U0IdZm/MMqpsXLIkSncX52ooW5REUfgaZ?=
 =?us-ascii?Q?QvV9TG104QsIeJcC4aAS1lFLwIyTi3w6z2faMNQWXuhHCL9KV1xpWx6d1pBY?=
 =?us-ascii?Q?oIp73kWeUMqzoiCQRpw//suKWisXr4imNKro6KOUTG+G97pVIBfxTBuL7Xvs?=
 =?us-ascii?Q?Epm8d0ZMJLRikKa+xDFWu7bDpy1JzHjcyD/nfL0hynb7L6rv1VjjkRPsB85z?=
 =?us-ascii?Q?aUYHs2/hiYec4DWtPSnIahxRY+fe0t9UZ936xLQyigbBRuY3m75aAFNPoP9C?=
 =?us-ascii?Q?ydl6wk5Q/cga3zZea/be1LEfGrgukrGab2MzfCnLoEVWNSZEXEnvUyRkpBLg?=
 =?us-ascii?Q?8JDbfpQlGGjMdhUndBPAxVstXr63iCjmktGwt2da?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf6f962a-0dcf-4d0d-beb3-08dda790008b
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2025 19:58:28.5049
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l/aRGspXR2sGi6OOrbMRESd5bIGw+u2KcjG35W8nVKol+1XQAUISUmnue/3gYm+q
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6414

This is similar to a series I sent for AMD.

Lightly reorganize some of the page table related code so there is greater
isolation between the first and second stage logic. iommupt will introduce
distinct types and code flows for first and second stages, having them all
combined together is difficult.

Splitting actually makes things generally more understandable anyhow as
they do share only a little code. Most of the registers and logic are in
fact different. That was being obscured by small helper functions that
combine the first and second stage information.

This would replace some of the patches recently sent by Wei.

The full branch including the iommput conversion is here:

    https://github.com/jgunthorpe/linux/commits/iommu_pt_vtd

Jason Gunthorpe (7):
  iommu/vtd: Lift the __pa to
    domain_setup_first_level/intel_svm_set_dev_pasid()
  iommu/vtd: Fold domain_exit() into intel_iommu_domain_free()
  iommu/vtd: Do not wipe out the page table NID when devices detach
  iommu/vtd: Split intel_iommu_domain_alloc_paging_flags()
  iommu/vtd: Create unique domain ops for each stage
  iommu/vtd: Split intel_iommu_enforce_cache_coherency()
  iommu/vtd: Split paging_domain_compatible()

 drivers/iommu/intel/cache.c  |   5 +-
 drivers/iommu/intel/iommu.c  | 321 +++++++++++++++++++++--------------
 drivers/iommu/intel/iommu.h  |   9 +-
 drivers/iommu/intel/nested.c |   3 +-
 drivers/iommu/intel/pasid.c  |  17 +-
 drivers/iommu/intel/pasid.h  |  11 +-
 drivers/iommu/intel/svm.c    |   3 +-
 7 files changed, 221 insertions(+), 148 deletions(-)


base-commit: 19272b37aa4f83ca52bdf9c16d5d81bdd1354494
-- 
2.43.0

