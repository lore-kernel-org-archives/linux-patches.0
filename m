Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010000.outbound.protection.outlook.com [52.101.46.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDCCA749C;
	Tue, 20 Jan 2026 00:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.0
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768868004; cv=fail; b=SLEWrw4TuQB/ycl0mrZQvaeONnt/QScgkzwnAVj9k2KZ0FqWvg+w+OFab49+ft3sIpYfgdfIPkLCDc2P6l5L2/i1PhdQe+xcCRWQrzFw+/+yB5Yo4TeiWu+ir9zGPDu5ngvSWJcYhzQrGyhmTHDif/d/uf9wMkmw/uhrM/vix1E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768868004; c=relaxed/simple;
	bh=ARub4G8teZ8Ptt2kQMp+69VvbBaFt0d7WpbtDkU2qd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fAwiXeN2SZT4Rjm2VI1RmlfI4BRlmonvKyQno2MbP7BUphva2oTrwzV90xWowC5qQmkV+piOCmAoTIzuLe2m9iUmZ3BvSzMPwuXdHgBKK438/S/7Mm17mGowk2SAPzQBLAEj/yMneSdUlnhJ7pMPeplBA0mcYJIfmSdHtUajxcU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=dTiDFx1E; arc=fail smtp.client-ip=52.101.46.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="dTiDFx1E"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nIxIU9ZilEcDZwa5QOfRgmZOUJgwVqQz1q4mfLzAlaq41vgpmey7EwWUhYVxCRpW4lxg6Kp0whW5DaRXioyBZ4tw1nlhGqj7ZHlSyiAKWDBMPBM6jFIIyUK0EG8P7iCkbImkYh49ZAxtwOtgqsvfsuIl5HsMM9aHB5NWpWtVuVpkjvV/HdA8ookfjk/EgdZSnxBZmZykXW5NtRM0GNkT/S+JjNvXuTP61qv2X0umAdb7uZQ3dMqqi/Q9oiVMs3AP6AOwUZ6B8sbCfshsEc0ZRmANymIuagpsvmTMq3HRqFnAuRKEryqHuEwL3G9ChACMKwNsb8w/yutb15UqbJdYDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B0RtiOQ59B2OCpgBwRliqETkuOi7Vz5lfbsSGGKoF0U=;
 b=RoUfZqs9bR7cqUgaRN1f6K3p4CsRU9u6mHFrZfH9dUpsznnITb+8BtytCyuxbOQOxOWU7rbkccFr87pd/ieRBJ5FWTISCL8DDFmo2eE6jYSqdSSZ0CGjqqtAjNa7urWVsaAzq7mM2j+4I6Rgd59XJPOee6UliHdVRf10SELlCguESl4JGrKOCV1LFsOzxiwm25TRWsb+5FUgb5V1phDGcwQ86OuVN1vqPjM6vuILzI2f7g6S7t9QfbjMRWMncFAVkwt9giTpMsLwMPSMsYz5vWab0knjlT7W+ZUek5t323maFoFeeUFa/CWH/Ii+gHAzM6e886X79NRG0KiypfJMSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B0RtiOQ59B2OCpgBwRliqETkuOi7Vz5lfbsSGGKoF0U=;
 b=dTiDFx1EpCwvlzWp7gNxyeILRzf57F6yS8yEvF+Mm4DSBZhz8RY6ebQt0o/zCOtKZkYpE8GVmTgqTuek54/qgx+ay8aqf2Ab+FSnelh3E6EI+tHKQy/3OPDvRnRBpb4WsQ6+FW8GuYcA8DJlzmkpmEocfOesN8Ohz0ZtVmAbKS6SqegCIcAQwMAEglakLo4IAopL7/BR+3MbpV7AddezvXoGntbsegKMKXmWRPhdb4FpediDTy2xMmiPgEeO1212JMNwq3SXNpuITbrBEOjKG7dMJME9ir/1zpmVjAb+WN6M66TDALkM+FuXHEvrRIbTYRu3wojsPQvEhdEIztWPYA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CH3PR12MB8234.namprd12.prod.outlook.com (2603:10b6:610:125::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.12; Tue, 20 Jan
 2026 00:13:17 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9520.011; Tue, 20 Jan 2026
 00:13:17 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Kevin Tian <kevin.tian@intel.com>,
	patches@lists.linux.dev,
	Samiullah Khawaja <skhawaja@google.com>
Subject: [PATCH v2 2/2] iommupt: Avoid rewalking during map
Date: Mon, 19 Jan 2026 20:13:15 -0400
Message-ID: <2-v2-973a6bdc820f+693-iommpt_map_direct_jgg@nvidia.com>
In-Reply-To: <0-v2-973a6bdc820f+693-iommpt_map_direct_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR19CA0063.namprd19.prod.outlook.com
 (2603:10b6:208:19b::40) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CH3PR12MB8234:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e088469-f78a-463b-bd4c-08de57b8b59a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FnpPAGM041CDoAIT+oVf+SuG1N6WgA/WKy9IQ3g5vVwVcUlgM3cDm6ym69ip?=
 =?us-ascii?Q?+Vr5Nc0SUC9EeMrN9zqJcAseyIROmRxB8TUvpDneswHJNUKvus4p7667CmUm?=
 =?us-ascii?Q?tSfwFJAKcXG8eIIZ65dqYgVio6T5OpyNefRGPoB/IxIPx/34uOPPAPQ4kluM?=
 =?us-ascii?Q?LwcXrShb59aP5O1Gfx9AO2k0Q+cCLHQB9adoF9YumlVEuP5cyCw1s1JPWuH3?=
 =?us-ascii?Q?WTCHJT/CVryGFqnw+qlxE3vjKn+zhRT/DufcOCJQepajnifp3UnRtWAYzpox?=
 =?us-ascii?Q?WPYsdRSfJdVdu9eB2Qd/ELiJhT8KpCWy2SbMErAE+WkVc/s4uusNfzkGhRIA?=
 =?us-ascii?Q?PsmdwqJfFk+ZN/qJxLMLQxsjozG04ICFafI8sujqJebs89FVFuOXL/9BBeb4?=
 =?us-ascii?Q?POT9H1KF/c3sLcsta5PvTbUgxoCHyCKuQauCZ9Q/yNWb1YTQbwhjy8HZk15c?=
 =?us-ascii?Q?utQ+ZKz27XUHn26cinyxbEtpNBxn7GQYbiwbraIdBlXdLRjb8ZNNZPy38XKg?=
 =?us-ascii?Q?ubaj4NOGTWi2UGKh04xASIPm/9+B7EwMj4ugaDN1aaFTHShYebv0rSBwkRFp?=
 =?us-ascii?Q?loSc2h1NO1iSGKuB1WNY78bU2ZScflUhKoI6B3a8/ANEfh9LfuZAhkVsnTLZ?=
 =?us-ascii?Q?gZVYLybuml2eNT/id7HzOg4LzZoTH3LalIDp/P7WG2v9/6e5I9Ewj/TP/gxz?=
 =?us-ascii?Q?mHKSdutA2HDTzVEnzvI+AaXBxlNYZJUFLuxaK3QV9GZKLCxKdz6UtqgTBdEl?=
 =?us-ascii?Q?LtSIxh9DLjweqORGSS4wlNgSiIepaIKJD2bWs5YwY/3Km5e7ZD0WWUlHamSx?=
 =?us-ascii?Q?N/RlfLhPeyxG7ZB+x90Pc6PY6SYGIKyYjvTRpqcKY0FxFWUIcafUTEyaEhf0?=
 =?us-ascii?Q?lUQJ38Iu4X0EbbNickE0DWd1A2wkX+bRW5m/nWn9+3aPbzXh+UrZARzv8Y4n?=
 =?us-ascii?Q?yqjXBZFnFPlfewWQo6n/AJv9DHSm4Se8QUL11bL5z/bdysNnbdr3QvLpgsuK?=
 =?us-ascii?Q?NeLKOzO7Ue0DoBqDlrsKeoE5Wj77y6ua7uLliqrXGxIxjbv6zD+XHoNkqDOf?=
 =?us-ascii?Q?6HKFi6kKP5f3zWtLAsCL6b376D3vXIiGandPbaQmn1MEd5zL4+H5a+I6MLur?=
 =?us-ascii?Q?m9Vs5Z6sfRyKYudnfxk74x8gPa5D0aZX1tKiQqLsNEq5g8OOvxSeCorRlz4s?=
 =?us-ascii?Q?9mJeCgD66LxwPUQKVO/HIvJFtAIxNDFpziiwU3pDeLLXvECN2jDS6Ds5wwjN?=
 =?us-ascii?Q?gsinSFV/reLAjs8JN7m5IGkwOYiEaxNak0KmUb6N5DztIJg8uLXpJE9D6TU5?=
 =?us-ascii?Q?97ft7/5BGA/95bnvsbj0U8+oDjGMsUzSoerQ4nsvU31xHg3ic/4MxFkZ5yTr?=
 =?us-ascii?Q?D3qpWub1eF6wqUXBGrttrvwyCYcbdRfgfuRsc+RVHxtqdxbmZZLc2XDsk4A9?=
 =?us-ascii?Q?VshSJOY/yNPyWNz7oDW09xxcR6PZxWZciAaV23aoTyrAp8xuI87bi0lRwl9w?=
 =?us-ascii?Q?CUpP7WlIGk5m8dEvsz4agt1KE6qHUEZnmaHOVFmA7r9L8vvbdKgSkQCKVuzq?=
 =?us-ascii?Q?2TnSECRptIrM1YF62C8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XOAf77uSCr4GIYWJ6bmzpKBGAsQg+RvZ6Mulk+hg6/rlfA02+9RzLiyZ+IpJ?=
 =?us-ascii?Q?/UekBJbiDtp4RVNf85iZD1KSMUf2Xb+CHYQ+zt05kaKMQLKntuCxyOG1+rBo?=
 =?us-ascii?Q?KZoWrZOX+pUNjc4dvZr3Lfh9fGvrwwjTKTItreAWVH2fekpE7+/LEfGBaxZ9?=
 =?us-ascii?Q?uwB/opqWyfApEdfbJWN87lVqP3JNEA5PEifhih2v9rnEeY9vttVnKfSWX2B9?=
 =?us-ascii?Q?1TKBCPbFDhI3i7kWKx+4s7j0YT+0rjy/XtWe0AB2EGegOh30F1KPEyWEALUx?=
 =?us-ascii?Q?ZzKEhEcRo4vSe48a3ZqwDyyBRdTpsm0qXoVMNk7BMxyp5sOWnUWeyZgG+HVY?=
 =?us-ascii?Q?+/reW2zr+Gh8zcFheuSZC8V8E+JWvjMkug3U0efhcGId8LJ8yXyevi6L4O1h?=
 =?us-ascii?Q?V4a5++nYAUnboLD4e5H1b40ZhzrVE275PrlpJTam19Rm75EiBgLj7L6FMG7G?=
 =?us-ascii?Q?98yylwYSaDCSej3WD0WSusw5GB0nCsmSeEuPGYZ5GrJbop585iZOEgU+dAPA?=
 =?us-ascii?Q?lFqH0qlNuQTPhmr8Bqy0r6mA8O731W3kl6ti9qXVL5mix+IySGQwaNDmBJQO?=
 =?us-ascii?Q?AvwO8fyWxHNKnWQiJMYzBxlezoi7mv0ePwQ/JQgk5f+l39UV+xyYMODkks9r?=
 =?us-ascii?Q?iHLJYp1ydl/9yHjcvvrw4YCd2tmfGNlxN8skzotFGoI6kKg+kTPiV6zkd/Mc?=
 =?us-ascii?Q?Pg5EqK0bzjdxgqvAPmm8cVG7Gp4u/+5S1gav2vpW0XW29Y3LrIfO+grzyulC?=
 =?us-ascii?Q?LMR67R1bhC3FT0Xt8t/wHZRAWNL/TxCqkVXz1J1NHmtBfeOzjkAEpPmpZ/OW?=
 =?us-ascii?Q?3+JPxzA+uhqeh/RhyiZz/sLgK3lMbkA11PPWRr/zlUiI8BvXVnis7vWh9IWJ?=
 =?us-ascii?Q?Zt7NMWxyYajgpjz3pwqaPEB8npxHd+004NgwQuO1z9MigEEtsF9X/wOsaGly?=
 =?us-ascii?Q?OivjD5I8pTgi14aY3o+yV45MgQxmnQNz01ykGI/srDWhshMuHvKxXlX/q+nl?=
 =?us-ascii?Q?wFsKCc9IrheOWlo5c7z3CnSenYJDVJfJkphQzkzqtYCw+/M4WvLQWQSMb1kf?=
 =?us-ascii?Q?QzNZ2Q15nKfUg09iwyRQbawhfl+66DIX+nEF7Egt4YZbTU+5qFU/x8HhCmI6?=
 =?us-ascii?Q?HMqfjzsaXPz/wj4krwM02XTAf7b9D9rT92wxgbucaeHJTMydNoFwfiMzzrq9?=
 =?us-ascii?Q?LLR2VXzonjNOosENyx6c/98bmeFQzEiwa9GUushLW3x2LFC/9RprRZuyvjWQ?=
 =?us-ascii?Q?zezYSiKC9S/oGXes2nc3LCGlUlkB+fko0fRuIZjprk3jnvSVCccNkrCSK4q9?=
 =?us-ascii?Q?lzYKOVG7goea8mhEVbaERNVafI+8BXrZsiRCKFwY94M4R9VJUwavUhuryWF9?=
 =?us-ascii?Q?lr25BMlsfzWBujv9Hxb1EPhNsbdW7MnkpqVBMQxSy8rl8MeL6g3RyKArqjmQ?=
 =?us-ascii?Q?kmCYnpW+CcUWUZZKaJJZ1Qg+PA3ayvUrYqxrAJnM3XbpSuvM8m0ijo1hAtAg?=
 =?us-ascii?Q?wQIQmr3BdHzZwtYutVh9O0ES09Xvtcz0jXeClBoqNSR2b9NNdXSzIhQBW1m5?=
 =?us-ascii?Q?5l8seSs73vW6bOjXjIglEAMqhnM/QzocTG0h0f+/zSJPSCeh0yz5rMM24YFH?=
 =?us-ascii?Q?aRPciFM+dYzqB+SNFabKROKabL803DMnlidEQl3msvyQNtZhAXAa/uc/mgkp?=
 =?us-ascii?Q?s0Cq76Gv2XbV/vPr+BuCFrNrZJy02B+1RGqGFT90vMXLBLioYRLPSeiYnQPZ?=
 =?us-ascii?Q?tfIvNQWX+A=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e088469-f78a-463b-bd4c-08de57b8b59a
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2026 00:13:16.8555
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Eo3BtJRs48o4K4g0z6sFWEgyMDoe2Xbo87893sPe/PJ4rrjSRtqmjr/vwq4YeFbK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8234

Currently the core code provides a simplified interface to drivers where
it fragments a requested multi-page map into single page size steps after
doing all the calculations to figure out what page size is
appropriate. Each step rewalks the page tables from the start.

Since iommupt has a single implementation of the mapping algorithm it can
internally compute each step as it goes while retaining its current
position in the walk.

Add a new function pt_pgsz_count() which computes the same page size
fragement of a large mapping operations.

Compute the next fragment when all the leaf entries of the current
fragement have been written, then continue walking from the current
point.

The function pointer is run through pt_iommu_ops instead of
iommu_domain_ops to discourage using it outside iommupt. All drivers with
their own page tables should continue to use the simplified map_pages()
style interfaces.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/generic_pt/iommu_pt.h         | 133 ++++++++++++--------
 drivers/iommu/generic_pt/kunit_generic_pt.h |  12 ++
 drivers/iommu/generic_pt/pt_iter.h          |  22 ++++
 drivers/iommu/iommu.c                       |  39 ++++--
 include/linux/generic_pt/iommu.h            |  34 ++++-
 5 files changed, 175 insertions(+), 65 deletions(-)

diff --git a/drivers/iommu/generic_pt/iommu_pt.h b/drivers/iommu/generic_pt/iommu_pt.h
index 5c898c01659798..22bae5bfeb0bac 100644
--- a/drivers/iommu/generic_pt/iommu_pt.h
+++ b/drivers/iommu/generic_pt/iommu_pt.h
@@ -467,6 +467,7 @@ struct pt_iommu_map_args {
 	pt_oaddr_t oa;
 	unsigned int leaf_pgsize_lg2;
 	unsigned int leaf_level;
+	pt_vaddr_t num_leaves;
 };
 
 /*
@@ -519,11 +520,15 @@ static int clear_contig(const struct pt_state *start_pts,
 static int __map_range_leaf(struct pt_range *range, void *arg,
 			    unsigned int level, struct pt_table_p *table)
 {
+	struct pt_iommu *iommu_table = iommu_from_common(range->common);
 	struct pt_state pts = pt_init(range, level, table);
 	struct pt_iommu_map_args *map = arg;
 	unsigned int leaf_pgsize_lg2 = map->leaf_pgsize_lg2;
 	unsigned int start_index;
 	pt_oaddr_t oa = map->oa;
+	unsigned int num_leaves;
+	unsigned int orig_end;
+	pt_vaddr_t last_va;
 	unsigned int step;
 	bool need_contig;
 	int ret = 0;
@@ -537,6 +542,15 @@ static int __map_range_leaf(struct pt_range *range, void *arg,
 
 	_pt_iter_first(&pts);
 	start_index = pts.index;
+	orig_end = pts.end_index;
+	if (pts.index + map->num_leaves < pts.end_index) {
+		/* Need to stop in the middle of the table to change sizes */
+		pts.end_index = pts.index + map->num_leaves;
+		num_leaves = 0;
+	} else {
+		num_leaves = map->num_leaves - (pts.end_index - pts.index);
+	}
+
 	do {
 		pts.type = pt_load_entry_raw(&pts);
 		if (pts.type != PT_ENTRY_EMPTY || need_contig) {
@@ -562,7 +576,40 @@ static int __map_range_leaf(struct pt_range *range, void *arg,
 	flush_writes_range(&pts, start_index, pts.index);
 
 	map->oa = oa;
-	return ret;
+	map->num_leaves = num_leaves;
+	if (ret || num_leaves)
+		return ret;
+
+	/* range->va is not valid if we reached the end of the table */
+	pts.index -= step;
+	pt_index_to_va(&pts);
+	pts.index += step;
+	last_va = range->va + log2_to_int(leaf_pgsize_lg2);
+
+	if (last_va - 1 == range->last_va) {
+		PT_WARN_ON(pts.index != orig_end);
+		return 0;
+	}
+
+	/*
+	 * Reached a point where the page size changed, compute the new
+	 * parameters.
+	 */
+	map->leaf_pgsize_lg2 = pt_compute_best_pgsize(
+		iommu_table->domain.pgsize_bitmap, last_va, range->last_va, oa);
+	map->leaf_level =
+		pt_pgsz_lg2_to_level(range->common, map->leaf_pgsize_lg2);
+	map->num_leaves = pt_pgsz_count(iommu_table->domain.pgsize_bitmap,
+					last_va, range->last_va, oa,
+					map->leaf_pgsize_lg2);
+
+	/* Didn't finish this table level, caller will repeat it */
+	if (pts.index != orig_end) {
+		if (pts.index != start_index)
+			pt_index_to_va(&pts);
+		return -EAGAIN;
+	}
+	return 0;
 }
 
 static int __map_range(struct pt_range *range, void *arg, unsigned int level,
@@ -585,14 +632,9 @@ static int __map_range(struct pt_range *range, void *arg, unsigned int level,
 			if (pts.type != PT_ENTRY_EMPTY)
 				return -EADDRINUSE;
 			ret = pt_iommu_new_table(&pts, &map->attrs);
-			if (ret) {
-				/*
-				 * Racing with another thread installing a table
-				 */
-				if (ret == -EAGAIN)
-					continue;
+			/* EAGAIN on a race will loop again */
+			if (ret)
 				return ret;
-			}
 		} else {
 			pts.table_lower = pt_table_ptr(&pts);
 			/*
@@ -616,10 +658,12 @@ static int __map_range(struct pt_range *range, void *arg, unsigned int level,
 		 * The already present table can possibly be shared with another
 		 * concurrent map.
 		 */
-		if (map->leaf_level == level - 1)
-			ret = pt_descend(&pts, arg, __map_range_leaf);
-		else
-			ret = pt_descend(&pts, arg, __map_range);
+		do {
+			if (map->leaf_level == level - 1)
+				ret = pt_descend(&pts, arg, __map_range_leaf);
+			else
+				ret = pt_descend(&pts, arg, __map_range);
+		} while (ret == -EAGAIN);
 		if (ret)
 			return ret;
 
@@ -627,6 +671,14 @@ static int __map_range(struct pt_range *range, void *arg, unsigned int level,
 		pt_index_to_va(&pts);
 		if (pts.index >= pts.end_index)
 			break;
+
+		/*
+		 * This level is currently running __map_range_leaf() which is
+		 * not correct if the target level has been updated to this
+		 * level. Have the caller invoke __map_range_leaf.
+		 */
+		if (map->leaf_level == level)
+			return -EAGAIN;
 	} while (true);
 	return 0;
 }
@@ -798,12 +850,13 @@ static int check_map_range(struct pt_iommu *iommu_table, struct pt_range *range,
 static int do_map(struct pt_range *range, struct pt_common *common,
 		  bool single_page, struct pt_iommu_map_args *map)
 {
+	int ret;
+
 	/*
 	 * The __map_single_page() fast path does not support DMA_INCOHERENT
 	 * flushing to keep its .text small.
 	 */
 	if (single_page && !pt_feature(common, PT_FEAT_DMA_INCOHERENT)) {
-		int ret;
 
 		ret = pt_walk_range(range, __map_single_page, map);
 		if (ret != -EAGAIN)
@@ -811,50 +864,25 @@ static int do_map(struct pt_range *range, struct pt_common *common,
 		/* EAGAIN falls through to the full path */
 	}
 
-	if (map->leaf_level == range->top_level)
-		return pt_walk_range(range, __map_range_leaf, map);
-	return pt_walk_range(range, __map_range, map);
+	do {
+		if (map->leaf_level == range->top_level)
+			ret = pt_walk_range(range, __map_range_leaf, map);
+		else
+			ret = pt_walk_range(range, __map_range, map);
+	} while (ret == -EAGAIN);
+	return ret;
 }
 
-/**
- * map_pages() - Install translation for an IOVA range
- * @domain: Domain to manipulate
- * @iova: IO virtual address to start
- * @paddr: Physical/Output address to start
- * @pgsize: Length of each page
- * @pgcount: Length of the range in pgsize units starting from @iova
- * @prot: A bitmap of IOMMU_READ/WRITE/CACHE/NOEXEC/MMIO
- * @gfp: GFP flags for any memory allocations
- * @mapped: Total bytes successfully mapped
- *
- * The range starting at IOVA will have paddr installed into it. The caller
- * must specify a valid pgsize and pgcount to segment the range into compatible
- * blocks.
- *
- * On error the caller will probably want to invoke unmap on the range from iova
- * up to the amount indicated by @mapped to return the table back to an
- * unchanged state.
- *
- * Context: The caller must hold a write range lock that includes the whole
- * range.
- *
- * Returns: -ERRNO on failure, 0 on success. The number of bytes of VA that were
- * mapped are added to @mapped, @mapped is not zerod first.
- */
-int DOMAIN_NS(map_pages)(struct iommu_domain *domain, unsigned long iova,
-			 phys_addr_t paddr, size_t pgsize, size_t pgcount,
-			 int prot, gfp_t gfp, size_t *mapped)
+static int NS(map_range)(struct pt_iommu *iommu_table, dma_addr_t iova,
+			 phys_addr_t paddr, dma_addr_t len, unsigned int prot,
+			 gfp_t gfp, size_t *mapped)
 {
-	struct pt_iommu *iommu_table =
-		container_of(domain, struct pt_iommu, domain);
 	pt_vaddr_t pgsize_bitmap = iommu_table->domain.pgsize_bitmap;
 	struct pt_common *common = common_from_iommu(iommu_table);
 	struct iommu_iotlb_gather iotlb_gather;
-	pt_vaddr_t len = pgsize * pgcount;
 	struct pt_iommu_map_args map = {
 		.iotlb_gather = &iotlb_gather,
 		.oa = paddr,
-		.leaf_pgsize_lg2 = vaffs(pgsize),
 	};
 	bool single_page = false;
 	struct pt_range range;
@@ -882,13 +910,13 @@ int DOMAIN_NS(map_pages)(struct iommu_domain *domain, unsigned long iova,
 		return ret;
 
 	/* Calculate target page size and level for the leaves */
-	if (pt_has_system_page_size(common) && pgsize == PAGE_SIZE &&
-	    pgcount == 1) {
+	if (pt_has_system_page_size(common) && len == PAGE_SIZE) {
 		PT_WARN_ON(!(pgsize_bitmap & PAGE_SIZE));
 		if (log2_mod(iova | paddr, PAGE_SHIFT))
 			return -ENXIO;
 		map.leaf_pgsize_lg2 = PAGE_SHIFT;
 		map.leaf_level = 0;
+		map.num_leaves = 1;
 		single_page = true;
 	} else {
 		map.leaf_pgsize_lg2 = pt_compute_best_pgsize(
@@ -897,6 +925,9 @@ int DOMAIN_NS(map_pages)(struct iommu_domain *domain, unsigned long iova,
 			return -ENXIO;
 		map.leaf_level =
 			pt_pgsz_lg2_to_level(common, map.leaf_pgsize_lg2);
+		map.num_leaves = pt_pgsz_count(pgsize_bitmap, range.va,
+					       range.last_va, paddr,
+					       map.leaf_pgsize_lg2);
 	}
 
 	ret = check_map_range(iommu_table, &range, &map);
@@ -919,7 +950,6 @@ int DOMAIN_NS(map_pages)(struct iommu_domain *domain, unsigned long iova,
 	*mapped += map.oa - paddr;
 	return ret;
 }
-EXPORT_SYMBOL_NS_GPL(DOMAIN_NS(map_pages), "GENERIC_PT_IOMMU");
 
 struct pt_unmap_args {
 	struct iommu_pages_list free_list;
@@ -1079,6 +1109,7 @@ static void NS(deinit)(struct pt_iommu *iommu_table)
 }
 
 static const struct pt_iommu_ops NS(ops) = {
+	.map_range = NS(map_range),
 	.unmap_range = NS(unmap_range),
 #if IS_ENABLED(CONFIG_IOMMUFD_DRIVER) && defined(pt_entry_is_write_dirty) && \
 	IS_ENABLED(CONFIG_IOMMUFD_TEST) && defined(pt_entry_make_write_dirty)
diff --git a/drivers/iommu/generic_pt/kunit_generic_pt.h b/drivers/iommu/generic_pt/kunit_generic_pt.h
index 68278bf15cfe07..374e475f591e15 100644
--- a/drivers/iommu/generic_pt/kunit_generic_pt.h
+++ b/drivers/iommu/generic_pt/kunit_generic_pt.h
@@ -312,6 +312,17 @@ static void test_best_pgsize(struct kunit *test)
 	}
 }
 
+static void test_pgsz_count(struct kunit *test)
+{
+	KUNIT_EXPECT_EQ(test,
+			pt_pgsz_count(SZ_4K, 0, SZ_1G - 1, 0, ilog2(SZ_4K)),
+			SZ_1G / SZ_4K);
+	KUNIT_EXPECT_EQ(test,
+			pt_pgsz_count(SZ_2M | SZ_4K, SZ_4K, SZ_1G - 1, SZ_4K,
+				      ilog2(SZ_4K)),
+			(SZ_2M - SZ_4K) / SZ_4K);
+}
+
 /*
  * Check that pt_install_table() and pt_table_pa() match
  */
@@ -770,6 +781,7 @@ static struct kunit_case generic_pt_test_cases[] = {
 	KUNIT_CASE_FMT(test_init),
 	KUNIT_CASE_FMT(test_bitops),
 	KUNIT_CASE_FMT(test_best_pgsize),
+	KUNIT_CASE_FMT(test_pgsz_count),
 	KUNIT_CASE_FMT(test_table_ptr),
 	KUNIT_CASE_FMT(test_max_va),
 	KUNIT_CASE_FMT(test_table_radix),
diff --git a/drivers/iommu/generic_pt/pt_iter.h b/drivers/iommu/generic_pt/pt_iter.h
index c0d8617cce2928..3e45dbde6b8327 100644
--- a/drivers/iommu/generic_pt/pt_iter.h
+++ b/drivers/iommu/generic_pt/pt_iter.h
@@ -569,6 +569,28 @@ static inline unsigned int pt_compute_best_pgsize(pt_vaddr_t pgsz_bitmap,
 	return pgsz_lg2;
 }
 
+/*
+ * Return the number of pgsize_lg2 leaf entries that can be mapped for
+ * va to oa. This accounts for any requirement to reduce or increase the page
+ * size across the VA range.
+ */
+static inline pt_vaddr_t pt_pgsz_count(pt_vaddr_t pgsz_bitmap, pt_vaddr_t va,
+				       pt_vaddr_t last_va, pt_oaddr_t oa,
+				       unsigned int pgsize_lg2)
+{
+	pt_vaddr_t len = last_va - va + 1;
+	pt_vaddr_t next_pgsizes = log2_set_mod(pgsz_bitmap, 0, pgsize_lg2 + 1);
+
+	if (next_pgsizes) {
+		unsigned int next_pgsize_lg2 = vaffs(next_pgsizes);
+
+		if (log2_mod(va ^ oa, next_pgsize_lg2) == 0)
+			len = min(len, log2_set_mod_max(va, next_pgsize_lg2) -
+					       va + 1);
+	}
+	return log2_div(len, pgsize_lg2);
+}
+
 #define _PT_MAKE_CALL_LEVEL(fn)                                          \
 	static __always_inline int fn(struct pt_range *range, void *arg, \
 				      unsigned int level,                \
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 916b68408463a8..ca9e90d80f7484 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -2569,14 +2569,14 @@ static size_t iommu_pgsize(struct iommu_domain *domain, unsigned long iova,
 	return pgsize;
 }
 
-int iommu_map_nosync(struct iommu_domain *domain, unsigned long iova,
-		phys_addr_t paddr, size_t size, int prot, gfp_t gfp)
+static int __iommu_map_domain_pgtbl(struct iommu_domain *domain,
+				    unsigned long iova, phys_addr_t paddr,
+				    size_t size, int prot, gfp_t gfp)
 {
 	const struct iommu_domain_ops *ops = domain->ops;
 	unsigned long orig_iova = iova;
 	unsigned int min_pagesz;
 	size_t orig_size = size;
-	phys_addr_t orig_paddr = paddr;
 	int ret = 0;
 
 	might_sleep_if(gfpflags_allow_blocking(gfp));
@@ -2633,12 +2633,9 @@ int iommu_map_nosync(struct iommu_domain *domain, unsigned long iova,
 	/* unroll mapping in case something went wrong */
 	if (ret) {
 		iommu_unmap(domain, orig_iova, orig_size - size);
-	} else {
-		trace_map(orig_iova, orig_paddr, orig_size);
-		iommu_debug_map(domain, orig_paddr, orig_size);
+		return ret;
 	}
-
-	return ret;
+	return 0;
 }
 
 int iommu_sync_map(struct iommu_domain *domain, unsigned long iova, size_t size)
@@ -2650,6 +2647,32 @@ int iommu_sync_map(struct iommu_domain *domain, unsigned long iova, size_t size)
 	return ops->iotlb_sync_map(domain, iova, size);
 }
 
+int iommu_map_nosync(struct iommu_domain *domain, unsigned long iova,
+		phys_addr_t paddr, size_t size, int prot, gfp_t gfp)
+{
+	struct pt_iommu *pt = iommupt_from_domain(domain);
+	int ret;
+
+	if (pt) {
+		size_t mapped = 0;
+
+		ret = pt->ops->map_range(pt, iova, paddr, size, prot, gfp,
+					 &mapped);
+		if (ret) {
+			iommu_unmap(domain, iova, mapped);
+			return ret;
+		}
+		return 0;
+	}
+	ret = __iommu_map_domain_pgtbl(domain, iova, paddr, size, prot, gfp);
+	if (!ret)
+		return ret;
+
+	trace_map(iova, paddr, size);
+	iommu_debug_map(domain, paddr, size);
+	return 0;
+}
+
 int iommu_map(struct iommu_domain *domain, unsigned long iova,
 	      phys_addr_t paddr, size_t size, int prot, gfp_t gfp)
 {
diff --git a/include/linux/generic_pt/iommu.h b/include/linux/generic_pt/iommu.h
index f094f8f44e4e8a..43cc98c9c55f70 100644
--- a/include/linux/generic_pt/iommu.h
+++ b/include/linux/generic_pt/iommu.h
@@ -87,6 +87,33 @@ struct pt_iommu_info {
 };
 
 struct pt_iommu_ops {
+	/**
+	 * @map_range: Install translation for an IOVA range
+	 * @iommu_table: Table to manipulate
+	 * @iova: IO virtual address to start
+	 * @paddr: Physical/Output address to start
+	 * @len: Length of the range starting from @iova
+	 * @prot: A bitmap of IOMMU_READ/WRITE/CACHE/NOEXEC/MMIO
+	 * @gfp: GFP flags for any memory allocations
+	 *
+	 * The range starting at IOVA will have paddr installed into it. The
+	 * rage is automatically segmented into optimally sized table entries,
+	 * and can have any valid alignment.
+	 *
+	 * On error the caller will probably want to invoke unmap on the range
+	 * from iova up to the amount indicated by @mapped to return the table
+	 * back to an unchanged state.
+	 *
+	 * Context: The caller must hold a write range lock that includes
+	 * the whole range.
+	 *
+	 * Returns: -ERRNO on failure, 0 on success. The number of bytes of VA
+	 * that were mapped are added to @mapped, @mapped is not zerod first.
+	 */
+	int (*map_range)(struct pt_iommu *iommu_table, dma_addr_t iova,
+			 phys_addr_t paddr, dma_addr_t len, unsigned int prot,
+			 gfp_t gfp, size_t *mapped);
+
 	/**
 	 * @unmap_range: Make a range of IOVA empty/not present
 	 * @iommu_table: Table to manipulate
@@ -224,10 +251,6 @@ struct pt_iommu_cfg {
 #define IOMMU_PROTOTYPES(fmt)                                                  \
 	phys_addr_t pt_iommu_##fmt##_iova_to_phys(struct iommu_domain *domain, \
 						  dma_addr_t iova);            \
-	int pt_iommu_##fmt##_map_pages(struct iommu_domain *domain,            \
-				       unsigned long iova, phys_addr_t paddr,  \
-				       size_t pgsize, size_t pgcount,          \
-				       int prot, gfp_t gfp, size_t *mapped);   \
 	int pt_iommu_##fmt##_read_and_clear_dirty(                             \
 		struct iommu_domain *domain, unsigned long iova, size_t size,  \
 		unsigned long flags, struct iommu_dirty_bitmap *dirty);        \
@@ -248,8 +271,7 @@ struct pt_iommu_cfg {
  * iommu_pt
  */
 #define IOMMU_PT_DOMAIN_OPS(fmt)                        \
-	.iova_to_phys = &pt_iommu_##fmt##_iova_to_phys, \
-	.map_pages = &pt_iommu_##fmt##_map_pages
+	.iova_to_phys = &pt_iommu_##fmt##_iova_to_phys
 #define IOMMU_PT_DIRTY_OPS(fmt) \
 	.read_and_clear_dirty = &pt_iommu_##fmt##_read_and_clear_dirty
 
-- 
2.43.0

