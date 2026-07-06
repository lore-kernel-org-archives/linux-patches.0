Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010038.outbound.protection.outlook.com [52.101.61.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD18A434E25;
	Mon,  6 Jul 2026 16:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.38
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783355367; cv=fail; b=Bd1bcS7yTiEO/qX2GfG/b+tqDhNXgTXdp9WwXX1jnK9gttEYI1HPlB9DEdlN7LY+YY2RCZQWSeBNHnNw4Gh+tt4aYcPJgnF67xq4LvTxREBfHc7avFQaB+XraC8U/StkbcoEFcbPq8epxl3dnB1pCGPMpuTCwmdBstOth8pdOB4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783355367; c=relaxed/simple;
	bh=swfuJA0KYlctfn59r4ArGz1LRyRZK8uU4C1b3CtByQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YkxpudluLyQGC5jQ5n43GNmcPN8iyRVZxKsDqlENBeZFhhockuVfOn0xBVlMrSjrydfEphZp7aFVH/qsoExktehrAEUQGvCIZyVZN13t+T6hN1KswQOCc2eMwB9PmlKcU85hTV5dKtAXhgkblLEmLmnIXN7SosU4y9iZ0w8hTJw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=gQTgNzHZ; arc=fail smtp.client-ip=52.101.61.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="gQTgNzHZ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y0PKBgb5uCE1OMzsXRuIbqP6FQS0v12odnFw63ywfokR3k/iU1SCpt0b+X6gYI9dFnRC8G088B1g5KyGhAZ5vUZ/KrriVcnNRXPEBj/eloTTnbMT1NUrMZeePjVdsphY/GiT2q0QU7uvOJh/VJidRcqJyBB8f34kBdWv+OcJljdx9Ghi8G+DLi5qu40Tyt9lYc1JpzkXjDUkP6WY979GQQAZb4XdsIgiuRer+4GnBpG+tUZjW3ltvu4IDUjPn/PNbmbDEeLl8JQpuv+7bWpA3MzluHdh4isdC1KhX9H2JH3Rie9r9X0uXFIMvsw7WgOFW+hVLMd+6goYzID79h1JMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=StyIco0k9cjVpsLGu5TgW1gfrpZ82Fyuhg730WwydnE=;
 b=Qm36UX1mXO6HMIWiwHi5EwMb+lDtcFHFfzeA42NanyojPdRliR+Z0WzqUS9ROBw+s06P25x2KcwbC/Xs00IvO1fzGJk/OIizVVkt55uy+/2FVw/gvT7NlzeYxV363ixxjiaYwG1O9+nQCeynLy7E7CQE3V/iI0FkJjRraZ3IN6AtixZHqPemDyrIrqS9ctU9EipGFDKEnFr3kzodWoSrXSk9ndOSTkmBGZ/vN4GYkC00tGHuvZRTTihwRTEK9gCy7FDdnFiQi29tTE8fD5TOgCS7OV94cXjhI+71oO4blOke1sMObTPcOFljM3bXbSTCHWoahh0VCxaiCClH4CJ+SA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=StyIco0k9cjVpsLGu5TgW1gfrpZ82Fyuhg730WwydnE=;
 b=gQTgNzHZH3HcCrwecTeJq5GdxBUVOG8bMmXVcWkcRotybzKu7fj8mFZdZssEQ7HTD1P1ch3s9lwaS3xW2wz1D2P+lStWNa/vm+MNmtxExnwdNzSGJ0UUtMSOmFeWggTzkISsNZ/iVjsdKoXzISGHtin+tAhoTSTznh3L2qgbaXASYUXE/1+ax3vLKr4iNOct0lu3nA0bTJktlmswcLi74gl9cphhKWdbKcQ0ucIiZIBUqUxDJa8zh8JNHdzVqYVn89tq/S0nj1vANjkUrgKWlHHHacR7eCiZr4hBvpaTvadE5FMm0Tfocz7bLurqMcixx41wD36RiA3T5mdN+6G0FA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SN7PR12MB7956.namprd12.prod.outlook.com (2603:10b6:806:328::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Mon, 6 Jul
 2026 16:29:15 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0181.008; Mon, 6 Jul 2026
 16:29:14 +0000
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
Subject: [PATCH 2/7] iommupt/kunit: Skip test configs without supported features
Date: Mon,  6 Jul 2026 13:29:08 -0300
Message-ID: <2-v1-807e2d1a5efb+e1-iommupt_armv8_jgg@nvidia.com>
In-Reply-To: <0-v1-807e2d1a5efb+e1-iommupt_armv8_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR20CA0038.namprd20.prod.outlook.com
 (2603:10b6:208:235::7) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SN7PR12MB7956:EE_
X-MS-Office365-Filtering-Correlation-Id: 271991fa-daac-4836-2c83-08dedb7bb7e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|7416014|1800799024|366016|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	sut1+ZYH7QN/2BgewJXIMVrYj1hIK7KJEuJawSlekd7siqSkJWXn7QfbQLRf9jo7OpW6DC+QApr73BxdVIix0WvRdgYU5y2NWK9zwaNAuC35ZtJGYl2CSgsVLr0TjlJEfBsm3nQfKVlKUvOfUtuZyw6tl1B2OOLbh7EY48+VQz9O3vZTQXn8dRuM11OJ1LLgJkrdylLP2Hf1cMxSes4UfaaeXiFhIngfBU+LX7QY6V1r+ky15eaHvsH5PtNHE0IUsT9YS/3uGsJRYnVT8qdZk8eDDwpqHP/4zeM9vHc6u9KTm1vzdIO6jN3KZduh1HFpv73XvZsBbKOv9XcNRvbbWvXWyWA6XQLOrBUoDx2zsOw9253V9Zc06dPTcmQTSl649Ep2WHEBEQFYwlRv2iOxUDnF62Q27wy9+OFWPyz/XgLaoSTWOjO8CKrGA5M27gSRVKBvpR/ktQoRglvNAui9NNrllH1x/MaDd3ExCY5LF2XQoqWAKJIxdhMU+GKGlQAbiMRujAX6e0hfaZFfcR6lDcZn82Aa9ovv6M1YQt2Uqjh5/7naORI1ocWkd2kg5BgvDUJfZUdPtg1wtiQuLATBu6GCbni0y4Q8MTEiRwMAoUR4I1vnNAXLsDsoNWHIkvFaHp8r7eFjtaCNke0X2p+whUeE9UV+PaTEDfORdlMnckY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(1800799024)(366016)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7klT7Cna065fgqL8iiMXb1j4yZNhMKAx5eeh/4crWbi3IDum78kAbfPDzKi8?=
 =?us-ascii?Q?LnRXuCYV/I30KkcyOsty7dOoGbOFw386quEyJqsHsjIFqd1smM0IJglxr/Ql?=
 =?us-ascii?Q?oI1engDzWi4SXLcYVy5Xog+09g2z8ozNOO8yv9qAPwP0Lo9Amp2NdIYK05Nq?=
 =?us-ascii?Q?GqsZSQPvux8rLEIW8Zu3i/MfNFerK3CZJdUVQsntoFl1kxE5FcpNLsgHlgub?=
 =?us-ascii?Q?bCh2WZwhfBUBwrfIPgcZGZOTEL32el03LjjBEDspNUEX7cFXvJBBqWBR0YbR?=
 =?us-ascii?Q?KTF+1MgBZ9j8D7tAFYqGJjjRFJW/xr4rKmpYLt+2o7xIplqIrcyFrNxcKAzH?=
 =?us-ascii?Q?0xNh5YMK1vqHBRcdAImA3nm+m65AEyrzA3GliJtU2zGJ6c7BITyjqHoWOPtU?=
 =?us-ascii?Q?t2g9jwL5f+vYPuPqdAqCQMx2Jo57puEkTTrOLRq0XdvIgAusLzePbQvGdqQZ?=
 =?us-ascii?Q?VW/4kJDVK4uYwqV1tYAI8MAU5m7GFgqXlzowvHCjD+F1upqpe4e9TUnOlnnx?=
 =?us-ascii?Q?foCaQpNO1KLBmNEDmZjqdcwPYcWTi2PP8eE1Adyrs3hjbCoieSoldEPzjDVA?=
 =?us-ascii?Q?5gr+n7rtXLV9248M3d+vfuFh+qI57oZDwq2UHEo3mAL+iPpD6lR7E54giUF3?=
 =?us-ascii?Q?0bi9THHprv3jPLfVnUxu1dzDhvUn6hoRQx92CgcC3mG8aaw2NffSk2NtZjwh?=
 =?us-ascii?Q?I3Kr4/dNpuaBqxxG4e2lHnwqRHn7R3q4s9PUVu/rYYbdY+RTkjLjkxJhPRQW?=
 =?us-ascii?Q?wDF1SrSeK9gg7/oLFchh+4Z0GF8stEoj3o898xJrTvST/sXWQjFn+N7avlXU?=
 =?us-ascii?Q?YseDC8Ol2/iSi8zMQ/4T8ZfMsArxHjuUQqOUeLcAVjKwXyhgVB8zh7gcrgpv?=
 =?us-ascii?Q?vSN2qtPiSzzoSBKseub8PO1aXdj7CY2Q/bqQB8sk42qLCMzxzwLOfBSml09x?=
 =?us-ascii?Q?SCRSxU9GgnZxthigTR75G13zVQzU6bWnxZGVGQEy1arfEXeLV6H/LwnkxxBE?=
 =?us-ascii?Q?B61QbSUkK9rbh6x0PR80i54tmX2aawwlC8Wb1PQK4i5wcF0ckyRJcTWNOpEQ?=
 =?us-ascii?Q?t5zDuV6tWBDXOoHkjWjtZ0D4qgJzDl9bxRn9e/5eW0Baux1ScxclxEkqPsHE?=
 =?us-ascii?Q?d7WrEwJHdIYYu2ERcym0kWX4GSB9OEnA3A96fRHlQM3ijmGcedWT0NzB3f9j?=
 =?us-ascii?Q?xkpuliJKgZuL3belpsG1ZV/oc9C3fRvn2fcEYlH8ebfRpMJl/eEOStjkHdoS?=
 =?us-ascii?Q?lLEygnVmL45KmoDVJbLTWTyY9LQ8QhvYfKG2g2Dj/LmnA6QPqxD1sdVjKGPW?=
 =?us-ascii?Q?xkDTxwAZP347paguVwwWTeYoKq5rx2E5ip6cydbS97Wj5C1NAeOHASjcCvK2?=
 =?us-ascii?Q?widEBRqZVhPCTzcg62UyUufSJRp9Qq4g8eLvYvcP/wPajrK+K+r0UJ3irIRf?=
 =?us-ascii?Q?gj4vZF6Plk6p/CJK4ZuKoZ2NYDgkYtGfAYlhfbgvzdZwKQFcyv+kHp3uZ2FP?=
 =?us-ascii?Q?7yD2KFkEMtPDECkiG9bzNS39FfRWbrXsZKOQ3Sm8lgHEtTJ8ww3oH5CFvU9s?=
 =?us-ascii?Q?H3j1uJEOzS6n+uJVPxphAYmgVJyusUO5lDx9yGxAHaukgqbG6eh28ZojiIFp?=
 =?us-ascii?Q?mR/28JluZRMdBwmK8/MMqJezmFHgDYtgw/aF9AJ+9vMyzStfFYZJ40/8LcYv?=
 =?us-ascii?Q?STAe+s4o6wPW8T3nvO5moBnG7mIHxOP9N/4MsWmP8VkKYA3c?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 271991fa-daac-4836-2c83-08dedb7bb7e2
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2026 16:29:14.8469
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c27HU7fdgNgPI0YCMGb/YGc72rNuHCO+wRUvlDXRL5EV4a2tIM7AC7bLWcu8KXct
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7956

Some of the tests configs can test features we don't currently enable,
like TTBR1 on ARMv8. Instead of blowing up, skip the test. When
CONFIG_DEBUG_GENERIC_PT is set all features are force enabled during
the build so everything can be tested. That is the normal mode for the
kunit.py runner.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/generic_pt/kunit_iommu.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/iommu/generic_pt/kunit_iommu.h b/drivers/iommu/generic_pt/kunit_iommu.h
index 79d7f9c8e7868f..558e161eacb05f 100644
--- a/drivers/iommu/generic_pt/kunit_iommu.h
+++ b/drivers/iommu/generic_pt/kunit_iommu.h
@@ -134,6 +134,16 @@ static int pt_kunit_priv_init(struct kunit *test, struct kunit_iommu_priv *priv)
 
 #ifdef kunit_fmt_cfgs
 	priv->cfg = kunit_fmt_cfgs[((uintptr_t)test->param_value) - 1];
+	/*
+	 * Without CONFIG_DEBUG_GENERIC_PT only the format's compiled-in
+	 * PT_SUPPORTED_FEATURES are available, so cfgs requesting bits outside
+	 * that set cannot be tested.
+	 */
+	if (priv->cfg.common.features & ~KUNIT_PT_SUPPORTED_FEATURES)
+		kunit_skip(
+			test,
+			"cfg requires features not built into this format (enable CONFIG_DEBUG_GENERIC_PT)");
+
 	/*
 	 * The format can set a list of features that the kunit_fmt_cfgs
 	 * controls, other features are default to on.
-- 
2.43.0

