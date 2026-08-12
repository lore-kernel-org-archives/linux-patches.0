Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012036.outbound.protection.outlook.com [52.101.43.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52FF736492C;
	Wed, 12 Aug 2026 20:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786565378; cv=fail; b=W10tckQptFO2mofTndbX657hrWEfOAu8Q3oH++dXbeZ35HMecpAw+Qa6qUNQUJ3kzoTiExY4XA018KJq6VSG5Nr1FbHMDEmfes82gOt1BZtvD1jaeHTh6VwDGmrMD85Ny5pwsb4HLOoqP45aT3L5HThKMDSfF4TWKDsRJpNX+U4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786565378; c=relaxed/simple;
	bh=M5pRP0/9Vn/qsF0LK7OzkfFZaUzbebloD6WPOnMrZ8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=iSfnFRVTd9o3uGNku3A+NNqrnZeJZ33aNlT29h29bc5YGm7kjnOj2OZX0b4Lg/X6seUpiBkw62CztR/8u/nYEQ82seexczJfGyouBJoxWv6q5t3shmZILDhMeVWhKZREzugMahNimqY/Wiqz1imWD4EEF5R8xDuSE8RRyZrEePA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=aZfcUROk; arc=fail smtp.client-ip=52.101.43.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="aZfcUROk"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pD/djNpj6nwadD1n5IVScsUcGzmqvKKbpMB99B5xlLd03RoLDKomgogfCemENS89uf+57lqA7AaJENeqdniWxQkqySQEKD+BKKTeSxsSxEHC/JQgs4WWbYXeTatCqD5Wt+mWd5SytAfHBciGsTWYqtfJ+7+iOFl6EC6CeitW08CLsodEdflmR1ZWE1GW857aaVx77m4MmTtBPOdZsYW6t3yx2QAUeD3Bj2RgBeE63ZrMuX3aKR8kM4thTaa0jQL65+dKibg5LHTLulXlhvsTiINeaj3KXNIDlU9Rw92ES7e6mRQdxh6R/jy2erBu8HunhMJJHfPhq4a/VO/fZKKKgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sTyU2zYUUfDGf4WtZI90zIJL44TV+BAp5ZCGbhYY+NU=;
 b=ieABONSLocaiNODAPHmwjBYkK6MNN3aRcOEy75GAHn1CGn/p6ZY6OeKZqc4Zt5qe27LvKTkBfaMle3Vvls6u7ImGo1/KUtbJXhC4v/wbAlA94E13pZkA5uYfKR7SR1+4rKTvnHwrffKThPLT69+mpQK9jo0EAqnoWV5/82VDBmK202PCj8+T/3xBfhmhiz+p3LuS5PFaJ7MCTZDeQmsyM6AjK7+DyzfvmTIjn9bVemD3zrHS51V6J/eFkr7fULb6GKMjN1sWLzg2Wus09Hn8UymGi12a5UBcYVQi/po6OZrV+A2iUK341tm9ims0vnMWCHcO+vw/dQRGMUOTr7/cXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sTyU2zYUUfDGf4WtZI90zIJL44TV+BAp5ZCGbhYY+NU=;
 b=aZfcUROkyq86UcvHV/zF2Avjbp/cQhOcmc1gTn/EC+ctewxDZu1Q37Rz4ZdEMopFZSm32vDRVUhtA6PMHfBZVAKgrxxmWzcQgWb6IM+uo4IZGxUevEKERqI1VJYvzclOAfLiKDtIzB9Cms136Xnz5GITm9IwscLHZ6sKL7bOsChdDlssZs0yTKva8p1QPAT/jya+9xLD7wRSDVmyw+zzLEd2SFuY/r6REWXDwVsiMMFqMSgw/aGiWeVcCROxp8BfyN7iz7T8I5WsEsLobmhnnzygME8fgNBa3gKImnnlcMtD4ylEvBVXtFZp14m5FxqtpKwoqyqm6zoCLUJ6uoqKFg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CY3PR12MB9629.namprd12.prod.outlook.com (2603:10b6:930:101::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.13; Wed, 12 Aug
 2026 20:09:30 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0315.011; Wed, 12 Aug 2026
 20:09:30 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: David Matlack <dmatlack@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v2 1/9] iommupt: Remove the sanity check for pt_num_items_lg2() at the top level
Date: Wed, 12 Aug 2026 17:09:17 -0300
Message-ID: <1-v2-563ee63886f0+1209-iommupt_armv8_jgg@nvidia.com>
In-Reply-To: <0-v2-563ee63886f0+1209-iommupt_armv8_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0104.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d7::9) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CY3PR12MB9629:EE_
X-MS-Office365-Filtering-Correlation-Id: 17f10eac-6dd6-49fa-465a-08def8ad9c2e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|7416014|376014|22082099003|56012099006|10067099003|11063799006|18002099003;
X-Microsoft-Antispam-Message-Info:
	//fwJET1YaCyZZmCt8CJLN7FjQ6TgHmGm9y/WSnYGIWb5Hw2MWFExBhzbZxoleeC6LDuxcSHtu2aNuu+TgDOEPDKU8ojs21T/kcDDOaIfktraZOtvdubz5+9KLse1hYQWN6BHFc1bsjVaz4IxitWrurq2fz2PrJTX6gveG3QRB+tTO3Dq0QLjDGkVt41vDLgHwY2m7VTipo6iw0fi6rDDG2kOVgwaWhzqaQYPU8Pb1LN8ltYDJMI4APD5CLfOgFbV+V6ztB2jCKGyqTuQYdDNi1pgjWH/muPFTo5c3MdB9Eo0YaqqGOIpr/kq2wDvIrEaxhn7L8xpyv4q8xDHiU/3mTqoZ3v30qt/nlIbF5gIWynv9UXqG7sG2ENiV27UyooG5v/qAiuwk01GYjmfzCE5uA0sesQNUCCA7XnOfAnVnkjP1wZRT4dcUTmFA1+1ggvmbXM78wRnZot/lfiCWLQYCjp8cziKInDascT8sXF5HWIt3MERcwIDqWGPI6CxmiU9sGjbK642oDdrNFpn5oqOJYzfZjgZgOPrG8/K/2/oYq1FU9euCXfidXXiTik4tPyCWtwKJI8D8hiAxsfcJaARh7+QNPNtwbP4qbx4zPAa+EzTJGyxUhMoUtYOvrvySBPTgUBmhLkgo06alx+waUgi6y7m3MDNTy59SHm/knMrgM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(7416014)(376014)(22082099003)(56012099006)(10067099003)(11063799006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LOOO9C2/JrNgGNpdZtCuyV6Xppq6PiR0vFN8WQZvB2CXI4CHXoYKQTEmlm2I?=
 =?us-ascii?Q?ZAvo3QQlJilkwwuVuhUb3xzH48cNzHv8xp4H4ChJTn8djet3dDbLNASHcgbm?=
 =?us-ascii?Q?BXRrVcRraG4pEfCQz4De/GsNP6p8kQ832ngPSC/gN6FW0YHkwYPZs0Dqnn+p?=
 =?us-ascii?Q?uviiZLpJS8GLMwvJlKnFDMKtVXbjHo6+AK6z016nfwKtEWY8MqI8bckQECFZ?=
 =?us-ascii?Q?s83NDx0v1m3US5Y5OK++4s6Q//Tu9Jr38xtA4q9ZNAQWisfC2px+/yIhDv6o?=
 =?us-ascii?Q?A//ElzP4Orkb/VWuD8VZde657yRC9NumZh1Vl2X2dASAuR4nbizl6xtBP5ib?=
 =?us-ascii?Q?CJI/IcimYHx/bhk2Ip8+nVkmBEMfvI+PJ9Wu90iWTFJ6XFwPtO9NglZznAg1?=
 =?us-ascii?Q?kHU4aF73NPwagBw74E6YMF1rCptyQwI29LOhmKhfWf95EfnqXJX3wK4ByUYT?=
 =?us-ascii?Q?u9+V9Z68SlQIQKH35a6ftepB6Wk01YFoTsOfMhxhkdS1yz/VV0bFO3S0eVLC?=
 =?us-ascii?Q?mUtznbNN3o6Wpg3+s4gzTwKGf1VQ4uaerAEwCoifjriqMON7JZQA44lVWmew?=
 =?us-ascii?Q?kT79BFmad8Das0wK3W/Vk5eicVGrlKuSg1P7Ku2WAWr5+O7XxknYEln/CQ1T?=
 =?us-ascii?Q?5AQiGAquaPgs8imnYG3Nghnt1GRKQyedwP1QWDl8xh34cbH5bMJsBnB4sW4R?=
 =?us-ascii?Q?mlltmaaX05SdyN8x+gO+LUff5ivBNAiWizDZY07yuOk0+GKRfbpKdbXjAmtP?=
 =?us-ascii?Q?wI5qbxbw2I7p7RhRCtnajqAuCkJQUJIo+LiwBtTxXjxCmah0mSsFrtRJLKRl?=
 =?us-ascii?Q?sbUIi7W2eEZibYSypQDddljDG/97l1ptpBgT84CuP8n2WC89xlSkcW5p6t66?=
 =?us-ascii?Q?KUCAngL9HmIGl70BB6UBR3D5tbpFQ9MOzWcUkSicgb0y23vZn1TG+QluMZ2w?=
 =?us-ascii?Q?cZR1nyeS3KODdenUcsvYFzjFk8x9OXofaooXn63qL9u6u37wo7gCoGGIuwxg?=
 =?us-ascii?Q?2W7Hhc8lpuKdzOMoDZIkrtTxZqLC/JEcSY1ipAMn/Whv9SVjYeg63MvokvzY?=
 =?us-ascii?Q?awiUfNiimjFgFrHmDjCJiqJeE6yajwr5CRFnFi6YElr2FHbDZY1YqJFVc7dY?=
 =?us-ascii?Q?UkytbYUHAE2nJs3REZh1uHF4WADCGd8EsIyygq7R6c4n+f7kpAlhJ/rN3wYC?=
 =?us-ascii?Q?jwbEVuD6h4s+BSQFhfnGVFBkV7jIaLAwhPlsNjYC9N+cNQC1jEb9shtp0Dd5?=
 =?us-ascii?Q?kzG0mM3f6A67HR+gyDn926HC3zsefMCnSFe42Kz6kyc69pdVv7chZha8GEI+?=
 =?us-ascii?Q?KQkQMT5yOwKEQdyGDFFDfKQTZ0XBQAchnUb1s1KxF5J0RMSHrzknHeeSu8wF?=
 =?us-ascii?Q?sJzLoo04N7xMHsWdZeUAroftM+Th9q0/ijU80dEFpL2zP5x363XnW5mb64n2?=
 =?us-ascii?Q?EyQ1PlELf+zCgdzQJ272LO2/1mWYu0mZNzt98bVlhP4SKwICGqG4g41lafrK?=
 =?us-ascii?Q?ha3POPnRfQf044OJh+gAb3tUaQC7uLskIoyFdFWBnOH6qyklJmsUwYg4vAOe?=
 =?us-ascii?Q?z3GqziJ9FkuGBlkCLjfRGym5QLx1aKGLSnoAnuVOhORNx3b2K5c0ih8Jnb5t?=
 =?us-ascii?Q?P2fxFDt5+aqvamQicTYgYXt+bi3EfkgLySa1yYZgLrfpNs20nMjoKuk+amqh?=
 =?us-ascii?Q?V1FjScMfhrjhr9H6ntjKnazSr+/T1QwCa7oASqT5mUOJX30NaLr39a2zC8MP?=
 =?us-ascii?Q?iI01e8jQHA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17f10eac-6dd6-49fa-465a-08def8ad9c2e
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2026 20:09:26.9722
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PWwGgnTBhwmDY/BfLKnY1tz3P/x2iHe46grKFoo6qZs1aToRJjv5lsdDwk+6BgZt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY3PR12MB9629

This was ill conceived, the existing formats work OK because they
happen to support pt_num_items_lg2() at the top level. However the
documentation is clear that is not permitted because ARMv8 has
concatenated top levels and we do not want to calculate an exact
pt_num_items_lg2() for the top level special case.

The logic to compute the number of items of the top level is shown in
pt_top_memsize_lg2() which is:

	num_items_lg2 = common->max_vasz_lg2 - pt_table_item_lg2sz(&pts);

Which is pointless to try and sanity check.

Reviewed-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/generic_pt/iommu_pt.h | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/iommu/generic_pt/iommu_pt.h b/drivers/iommu/generic_pt/iommu_pt.h
index c2752151c80af1..f1320c7e88dbbb 100644
--- a/drivers/iommu/generic_pt/iommu_pt.h
+++ b/drivers/iommu/generic_pt/iommu_pt.h
@@ -1207,20 +1207,6 @@ static int pt_init_common(struct pt_common *common)
 		     PT_FORCE_ENABLED_FEATURES))
 		return -EOPNOTSUPP;
 
-	/*
-	 * Check if the top level of the page table is too small to hold the
-	 * specified maxvasz.
-	 */
-	if (!pt_feature(common, PT_FEAT_DYNAMIC_TOP) &&
-	    top_range.top_level != PT_MAX_TOP_LEVEL) {
-		struct pt_state pts = { .range = &top_range,
-					.level = top_range.top_level };
-
-		if (common->max_vasz_lg2 >
-		    pt_num_items_lg2(&pts) + pt_table_item_lg2sz(&pts))
-			return -EOPNOTSUPP;
-	}
-
 	if (common->max_oasz_lg2 == 0)
 		common->max_oasz_lg2 = pt_max_oa_lg2(common);
 	else
-- 
2.43.0

