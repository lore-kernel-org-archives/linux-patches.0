Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010069.outbound.protection.outlook.com [52.101.56.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6FA248F037;
	Fri,  9 Oct 2026 20:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791576872; cv=fail; b=HQ2v6rB3qmZh/MRwNExC2azaE5wrg4XqXlUwcOOgFDh4/lm9Qup/roHU47V8m602A9FMdERWaVx56yOdIFkjQ8Qc8Za3bANEBX246WjRFwQ4Vs0PyX94Hase+zjgETLdDRqo+GniDo8kNzwoSddh2l614ja5hRXpcqA3PXJgJEI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791576872; c=relaxed/simple;
	bh=liX1Hty4DMeQylcBu52I5LcPE91/6Uai91FrgRqdmyo=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=HzBpluJZrrMfgLr0QT5FDmKVQBnB9NZL3S4oLeXIe/98y9+RVnu7Tfhx6H04c26vNnwKw1S3+h1574UNQd8gld08xdSYpW46Iuwsa5FfA1ykUOv/AQwRvxoD1Oquf+bFOjlQ+YbX1JmtG2F2jfjlTO2a4Z03xlx7h/N9N3Irp4s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=VXWtIH3R; arc=fail smtp.client-ip=52.101.56.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="VXWtIH3R"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a4kMo2Q7SBy+J99almDm6wH6JkoYbn2DofDprpPJEnLBuauHXtJB5/32o//+2a0y/TCXcNuzsk+giHQjBSpFgumZqNKkSnwIVg+gStXCUSlaxN/e2llSH6gVR82jeU3g06z3GgcFHW72khUUN8BjTkRy6S9/h515vzfRl5AbEOGpnd5YtFpPYGgOmf2urWf2YZRxi0WeXMTDLDgl0vmqEjDt9Ruq7jrJF64I5Jo9LgJa4ZAFIouML7AP1pGsanUzFARclBHsQ6vUkRLDMCKZ47lPl8bBjEHqJaqj7Bx2AfLa+uHK4NaVvwRXw+39OEhBKn2zxelMLXgF4bO/6hu2Wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JOy64R0Gz8R1ySh+N9HQKp03yGpLj9V8yqeWTPH3KCg=;
 b=K8e3WV10KgfRK2TExZpl1yt5uVqk6HsbZSfRdLc1M1gTcNeSMaVHU5QuefvNO0H7Oau1x3OQKol1odMlqndGpsqcMou58jp7d3xy2RKBy6Uti3aNCvD/JSkUvPqidGANdyVO+U6uosiu//wpvxw6dpE8MxEkHMKggCO18MFHBlxGUTbMErXH/+leJn0x2laz9R+TwBRQERxwXGF2uwzWu4CHbly0nEcPsO/q7yAd3iRH/qOIFDDGj45/spDMGHezPzfnuhn2oiVakthKpBfD08D2sLkbdIbzaewQkJA1Y5mUhstSISW7sK/jhxBmWmMZ+2G48/5Gg3efwQDrJ4JNMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JOy64R0Gz8R1ySh+N9HQKp03yGpLj9V8yqeWTPH3KCg=;
 b=VXWtIH3RI4hQuYtYHXdqKa7AopctGgfWC0Bix01WkFVuWEEwsB25Njh43OQLPq/geQAQcvuDhFm1dP38I6o+LGF4jhTP0LtmzsWmnnHGpvadpO8W7mRWIVevXHJS8cnJE3Iss0eEE8lG7coaS/IMzP92/xU/tCgJeNyGJLg6Nkc0n6YQGOCOxbhvBzMlrM6sSUXGUOm5l+1v4yTS9q/m1qTw7F8PnH4b1OBZTUDs2FozdQ/G1yhzSPcn9lJq9Qkh2oVmaWEIYjhKtx1+Aupy9A8etV8/+v5LAfVH9ewhf44EKkEfLbHQBSXWVrgUR79JoXoHsrM4G4/Ibf8JZYu65w==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by DSVPR12MB999174.namprd12.prod.outlook.com
 (2603:10b6:8:389::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.17; Fri, 9 Oct
 2026 20:14:21 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0496.015; Fri, 9 Oct 2026
 20:14:21 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: David Matlack <dmatlack@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v9 0/2] Organize the SMMUv3 invalidation flow so iommupt can use it
Date: Fri,  9 Oct 2026 17:14:16 -0300
Message-ID: <0-v9-e1637b95096d+d83ffe-smmu_tlbi_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0033.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:fe::12) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|DSVPR12MB999174:EE_
X-MS-Office365-Filtering-Correlation-Id: cf8bd756-f98f-481b-1cbc-08df2641e6eb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|366016|1800799024|10067099003|18002099003|13003099007|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	mUXShd++X7vE6DqaGlI8P3RbDp9LVsvL0R9gzWxin7clBZJhkF31mroLbIp2BYk5ldTyLEq0d9CiF7MXcMynHAORsohxZ0/6TOimmziSJGfDHkqBWU0VUVWLNfjmN3mZkf53Ur2CNy3gRl9E6/U82u0JxwHTwqjoPnfH04heKHtV4gRaLRwKQgvfzqLjBKpdPu8Gkb2Rf0hFvxw9R2E0ANgov7pOVzm6nvdBVaiMqYBBpFuX81K4Odt/FGk0zVUyPvt7D6qkRwyeD/7fwAGrHtvROknu5NEFcfTzVd+3Aclf4f8C9xNsPaATM+hdPamSWqUK51czQ8nrCgeBKSzyyNp7YlUsxQ7+bKI8noe6GInoKR/dEMwzidJ8U9WI23m4ScuwdgfG2BooYX6tnnZmlA25PwB3zjl0S0AyT0kiZOdCA1/u4SgrEgc8553EFGuLkt8NwgAQp1XPOYQ/CGjwd1TyXjym97RRu9Cxb5hzGrGsFARkzo5szR9dhCQFQFwD4YsBIfde/k+HCey00dhEYNpEanhcqJf7QZg5Ug8bR31bB0+njPFObZR+j9OS20w8LgXvf1Ih+GwRltfWL7wKAMvnLcM/5QO+sVKtnFuW7oYxe9bvjjDpD2gxmYuMmy7GjUxOj9Qa5W3vd3TwoskZ0oEqXqsQvYiIPdpJp0bbXss=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(366016)(1800799024)(10067099003)(18002099003)(13003099007)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?I4Vqil3bcxz6B6YblAE1+rFtQETCPMt+GKsWEaEKcjxMLGEYuLmyynrXVg2l?=
 =?us-ascii?Q?VmHCeYhNpr2/bB0VMqTcc0lf9BIaLrOawQMXI8pwwjO8HmRqdHtP8901K1ie?=
 =?us-ascii?Q?XJ7dRjZJVbS7AKOxlPZwEw1Lpe/kVdk2bNnSesLayTYW5WP5I+7YmiUpmW2w?=
 =?us-ascii?Q?CtfWy3pBgS4nk6wZMnnaZqepdc1eOyZeh0GPtDs09OzqQYBp2VXsbAD8nr2+?=
 =?us-ascii?Q?kq+Y9HGtG5HVfY3jS4SeGptGzEKnYIXXotCz0PNMBMw4vYTzMrYiB7urhIb0?=
 =?us-ascii?Q?yb7fAKjdgZuQjkaC9e0hQ8tHSkFIYMlq9CDndaB4X2IrdECaNEOfCPoEsDS4?=
 =?us-ascii?Q?KpnV1Zu1lN4u9BcCM8JF9FQHv62cPnAkbwKDoCBzmebcqvsQljuaAOSRTD9M?=
 =?us-ascii?Q?Aal0ZEUMXoeWdmWXtwVnCSW0Pc9BbwHM4EJqldN7lRgXU5WzOuNtqrvifTZ9?=
 =?us-ascii?Q?k2ykq0fmLtshv6hnWGHRJh51RABKhk5haEwPDxGGhgiCQxcEMfsGP1SYSpek?=
 =?us-ascii?Q?l1D8XtgWOo1dSdKGQETJCV795h2xXm+t9RgHhr43vDY+yBfQ88AJbGFEHkLl?=
 =?us-ascii?Q?8qkL7miB6myIMPeXWhidUY+o4CTjEM3CEX/keiGkxMb3m3pF6RoRGFO8L9Id?=
 =?us-ascii?Q?qgYl10clbrCJoMfKRe/JkrUMuu+mpCz3ZT5enffFDn6NApNROYAb/w5ltQtH?=
 =?us-ascii?Q?xnBPB/34KEnViSCiXv9Ww7L+yC4m74lsaGAoul9uakMmpFYi8wVf+oKWgiLA?=
 =?us-ascii?Q?2PhUzF+8aJNsBfuMyhL/8BaCrJtK8mFDsWb35y2VbXlpU/emb/EjEsDegN+c?=
 =?us-ascii?Q?PSFY/g9UR79Eo/LCp6PXiV59MQrji0ik2lZ10zVgisADDHXMucBYt+pP8s7q?=
 =?us-ascii?Q?A3fF2lYE0dn8OVmDTi+ksxJqGpWecbzoJvGWKnLUglgh7Ti8DNLY4Hv/WHD8?=
 =?us-ascii?Q?vMwsh32unZIm4jAC0XPwFQBwTYpMGNM+yEx0jC9lSna7QZ92jejCjnCxiTTM?=
 =?us-ascii?Q?YfVYqDV00TEPVaLDAHiwBk8X+EdiSvxnRno+fAPKHma6bnxg8pP4D4TtAoNS?=
 =?us-ascii?Q?0H4tagkcrjOQzTf6/8WcbJfFHRloPHcvN3jcvOReSHV3uy6kj+8V/j62xGlG?=
 =?us-ascii?Q?UxyHN5wPABivNGpmlOq7dcHooaWhGfcu8aAAGkzWqnkQHfCmFhVyXHGYCTaZ?=
 =?us-ascii?Q?PouwsRiICVCVwCqNmDdfMMUMIUcvZumGUvJ18VRkSNn04kCJYH9Woq0yVq+J?=
 =?us-ascii?Q?ylGF0vGrOOyLqagFlCCoGvBqNyseX4dHSnluOYx4a1ekDu7psX2ekfFr+XTe?=
 =?us-ascii?Q?LsR5L4fUZUfpava9ieobIwYez10p0kljfapifUAP7mnCCphODTsmsS0hPOTn?=
 =?us-ascii?Q?XJ9ArTi0+ym8oBr39RZ+yXCqlejYkHSD4XltKmE3OIqwjjj/8j08z7ULCwru?=
 =?us-ascii?Q?xmUjeq5810spMRkVTNW3mteJ+1HZiHpytAn8shS31UrS2Y/NCF/LVlGl+TZF?=
 =?us-ascii?Q?vRjsgG85I4ViPQ7Ubxil9R4UUFt5p9Rm6jzBnL/0rg3c16/GpsVSrqGecx3k?=
 =?us-ascii?Q?16FH6abaigPpCNADFtJNQhORDfog/uIMsQ6IdHXbnNFmoLJD7YvlMEhguoMx?=
 =?us-ascii?Q?XYYzi2wkQmRgJVSrY2TSEb15gW4DrPc5PtUx/LVEbHtyXqVUE3o/48iMlO48?=
 =?us-ascii?Q?cTSF8+GXsdflAlfdCCrnxqVH9eTiuRRA2CJuZdgsyjAZsDls?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf8bd756-f98f-481b-1cbc-08df2641e6eb
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2026 20:14:19.9641
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zcoNIWvUIC2HprDr7WU/jE6IRfNUwUmwi3ulsWqtDMDsMSK1pgN+8Bb5g7W0eF4i
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSVPR12MB999174

This is the last two patches Will didn't pick up from this series

See the original cover letter at:

 https://patch.msgid.link/r/0-v8-1eaaed5e0433+3d3d2d-smmu_tlbi_jgg@nvidia.com

v9:
 - Rename arm_smmu_compute_ttl() to arm_smmu_compute_range_ttl() for
   clarity
 - Fix the arm_smmu_tlb_inv_walk() to compute
      tlbi.table_levels_bitmap = GENMASK(level, 1);
   To be clear what the call contract is
 - No functional change, rebase on latest smmu/updates
v8: https://patch.msgid.link/r/0-v8-1eaaed5e0433+3d3d2d-smmu_tlbi_jgg@nvidia.com
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

Jason Gunthorpe (2):
  iommu/arm-smmu-v3: Change how the tlbi describes the invalidation
  iommu/arm-smmu-v3: Support the DS expansion of range invalidation
    SCALE

 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |  29 ++-
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c  |   4 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 215 +++++++++++++-----
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  30 ++-
 4 files changed, 210 insertions(+), 68 deletions(-)


base-commit: 2888520bdcbe0599cfc77b2fad8dc6c95505a3cb
-- 
2.43.0

