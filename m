Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012027.outbound.protection.outlook.com [40.93.195.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 630533DEFE7;
	Wed,  5 Aug 2026 19:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.27
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785957354; cv=fail; b=TXYud1LcrwatWD8Yh8KXiHH4T+ze3iyW1YKtWKosCbemTm5kIvP54h+4SnMiAkS4anOU/wIiiUOXhdz9YoCalC0HaS9FSVt7yR4xS7CVcnc/9D6B3s8sTQppIB6Ngqil4RQ8HrlFvcsC9w9l5bTpcjZlk9XozxVoRr1QAU3EpZ8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785957354; c=relaxed/simple;
	bh=ha5Y37LLA3qGNCOiltwRsyNnk1vnyxRCFswrBQFHTXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sdoPP7sm6oWXh2AbjlfT3wVOE2yY5ike+1J0OK6wf+ymsxrtCy1w1QP5SmLBX4i0ly7N3OITy+ejUoK8hYJjahftyXfpWT60D6tLlgO597rE+Zj1beR375ANhkkmyu/8JFusps8fxKrju43eZJa/piB71BoRgjX4H3P5cIy6BEs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=b7nb55UN; arc=fail smtp.client-ip=40.93.195.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="b7nb55UN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Mn/kTIKS6FeHcYGfFedT82Uyq8e8GXl/vU/SEMCsLixw+OoiaJVDuhhJidyry/nAUApsyArZnRJmN45iE+eEB6lqMMASgAjbcatZREX22NrcF3TGqkCerfC1VkfE/axyu2vKNTlgmZm6oxEFhWESQVkTk8ewAVwNRfDKKVPhN/B4LLKp6GUGxL69p28kuMbst4W6AleScEG6JaojAo+yIldOGcrA0p8HLQBlzEDvHSaV8QcpM2aWmUfyMUc6ry9WZ8HipIXb8STY8ml7D/OjTsRaet8R3WcX9myRmcKinJdXCZDPkDRaIlx+BFmPep2nx3yMt31TTs2AmHJ7I0rMGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qi4Fj4ub9KfzRjHsoiLf7pXHBXjWNwwPIEFMT+/C7Gk=;
 b=tGmJc8ENR3iL/8MJKt1HUdBRYMKy0IL7OqIZM/HkMmgufmaEPDozcuhmk0n3FkSUU5+vQexNOdRmUU8gkKtLFg9lbP2zcPqAlvLv13ObEBqJP+MPHu0AxWqpaQUBYDJQwVZexjL2WdqjKAdzLzb1by8tYipE+9FzAvDuuOTnHH6KwY0xjRE6pYiKZMCrhunk5YqCAsPDAFX8XSpT/dYKmQCcVBImyakVXHFZW5sYpzLRbKgK0BpYvWJtQx1pur7xa7Mti/VxTn1+gl6Cu6o0X1Leajo5Myj0mu2xWW6eiV/ChtyOfeMxrxvUbwL8+BDJdVrbWIwXjFhRvvy7FrFoLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qi4Fj4ub9KfzRjHsoiLf7pXHBXjWNwwPIEFMT+/C7Gk=;
 b=b7nb55UNtPbc5+rzJnU/45CEu/S2DY6mKU1GlljhmyIc0iepuc0C7uTMsGB/NkbytT8J99MPYetSsaj7dCGgSXm5vY9Lhg4N9ZrSeg9yxjBcypb22dC44t1ZMcooDPAVDrsvJBupQWdY6nRKdu4xx1Qje6NuyvesGQSRlEQS/LTFhCoaoIuAI5TNqyzNiPSH5XDbQ/v4wcy1+eqmPY70qY6AR4MXFVN2rqzKnuFuBgvcsurMN18PtmHmjZg8epi55RXn9JfRD0ycR63gkQQyhNGl2dGEegWue3XsTzjQCKxZ7IWnkN78NWl6lBAauEO8rIZeWqIvIuS+J0ZSR/Qp9g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY1PR12MB9601.namprd12.prod.outlook.com (2603:10b6:930:107::16)
 by PH8PR12MB7157.namprd12.prod.outlook.com (2603:10b6:510:22b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.16; Wed, 5 Aug
 2026 19:15:28 +0000
Received: from CY1PR12MB9601.namprd12.prod.outlook.com
 ([fe80::cd76:b497:475f:4de3]) by CY1PR12MB9601.namprd12.prod.outlook.com
 ([fe80::cd76:b497:475f:4de3%4]) with mapi id 15.21.0270.017; Wed, 5 Aug 2026
 19:15:28 +0000
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
Subject: [PATCH v4 4/8] iommu/arm-smmu-v3: Keep track in the arm_smmu_invs if RIL is used
Date: Wed,  5 Aug 2026 16:15:22 -0300
Message-ID: <4-v4-1802653d8886+492-smmu_tlbi_jgg@nvidia.com>
In-Reply-To: <0-v4-1802653d8886+492-smmu_tlbi_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0012.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d1::13) To CY1PR12MB9601.namprd12.prod.outlook.com
 (2603:10b6:930:107::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY1PR12MB9601:EE_|PH8PR12MB7157:EE_
X-MS-Office365-Filtering-Correlation-Id: cc252ad3-9100-4450-3e34-08def325e894
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|23010399003|1800799024|56012099006|10067099003|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	SKx8RukTOKiosJffb98Tf2GAmLMPyqaYwckAxVYK0CqXFbGz81Xp0MBjglC1FdILbvAZlzLlDcT2aatgc7INjLd17JARyICt1VU9OGNix1pKpKrw7URx2nT9mQYnxx/8B8pE1st/VLyyCwgLyaJKFzX3KmZlNbaUwNB/PFdOoCXLBotucBRyGMkINaGAVQDWG3NVVll3rrTEKwkaLItQwWLH9ZoyUZaMT8rPXxrGLdftIIO2IDoQz//F2bBO0J7HEAhNT+jjNR0iVQuMdwqpDD2znjAAWDmwJZDvfIamt72gh9XF7UVVr30QwCEtzj6KKGK7uB9vePOj7KMcFFi+UuyYlk+6QakLfSpD2Q6qaXz27VVCNP5/X3d13t0KEHtPT0SDfvqQ8aCx38FnQBAhta7Vg8QFQN5rh8/ZpzPJbAbrFECUcBGXbzBdUNSC/9wJa5DnxJZ7w4tDeA9Xe/l47u1+31Yjp4i8wvGAZdK087UQtS3tQOZo9A/wf18PY4E9pWsVzAe4k8qBqqwJwvCBWOydpB9vS4P//tkkzhJ1JRFA47QmPShYBo3b4kTnlx5uC3VNBRcWftxDdfiN89nDkpPBkpYEcxA+N7k1w8YLooPgXHKJcMBWE+gvxRjA34xdg8niCWLVsVHXcGEL1DSyK6ENaWJ1OANPxB3Lq5QuEY8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY1PR12MB9601.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(23010399003)(1800799024)(56012099006)(10067099003)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Hc68NAPmDS4sUCzaWSGOtzj7lCLoTgF+Wm4HKqJX0wFZc/DXesOEr3//A0GS?=
 =?us-ascii?Q?YuFaJngM17DwZAvU4R74/MD80SnpLO4L0toiX8rW79bCu6oX0GL7V5L6CNSG?=
 =?us-ascii?Q?JEQfvZ+UrjUMNQtqCsBeRdBupwlDy8JBcKuIOM0MvTbVNXRcKiiarLZxc9ct?=
 =?us-ascii?Q?7Cx5gS8Sq4pi2ivwDOF8qkE4XFHkF4EfAqmmGgSNexSW/kkTDtTLW1hEjfWI?=
 =?us-ascii?Q?Y8OQ5n6pw9RhWAFAMrPoo0XWdLggJOSy3HEX4Vl/q9zZxZWEKLRCfRJVCNm3?=
 =?us-ascii?Q?Fl/EPYDqna2DT8rn+JgGhRMv01Un5/N4wu05IdCc7yB5Ljx464VuRXaSmdAf?=
 =?us-ascii?Q?6wxWht8QwjuvAJe3JXlQbhjzi380FFpVwj8yjfgN0Vx0XalqN8u+lSttHH4R?=
 =?us-ascii?Q?ATaZgS/n5QsQ+tfekhiTzL+CcPM3ZUM05xoHgTkCnjJhrvCDhaIm5Jg6ZSyh?=
 =?us-ascii?Q?0O9WJ3Tj9yVkPO88PzlrL9mAM8ensfaXNFnbYJWy2t/bYhL/VQ1CoHGnh2Lf?=
 =?us-ascii?Q?eySosl6Xho0/3h3PFodI08e8A/51PnXzlkXWqIqolkn7F3pYYvuvRTYqfgxY?=
 =?us-ascii?Q?KWgPzpdzEOXIlzUSXllNm5MU1d5V13o/qcF+hcigMZ3fhBMPE8BGZzIWAJVO?=
 =?us-ascii?Q?GqLyJo6wigtsw5n1y2/CWLIYZv147lxdIcBfVMVUhc1pYFS5gC2+pgWApreV?=
 =?us-ascii?Q?C8gFGqyOgEgK9d7l8AIM71IjbXlTTL9nxTxPdRaWmf/j29j5zTME3h/lX96r?=
 =?us-ascii?Q?OQOTagyjpzI4vBkUp3Bub1mCjsu9iP6WqYHg4jnkF+9KkoSsUfea5fe54KWV?=
 =?us-ascii?Q?clyftGFcmmedxmZsa5K3OyVFAmyDe0KmdZOeTAR57jZXFZaFbZXec9UeVrVU?=
 =?us-ascii?Q?kzChJQ8ZoWdk/xJbyjvwxKsvf8ZqahA5Hu0JpWEAtvZZUOctLzXsCxH6fvDV?=
 =?us-ascii?Q?K+9v+8qVSsj7DGAhVHf8M2aoMjymSfZcsgoCaBvXInrw9pojMIvUFafqwXH9?=
 =?us-ascii?Q?W7AOev1OJXHo6ubOJnmbl7eXFnHXk2XnucMpxQ6jpjcWbChg8WISbYjU/Q2n?=
 =?us-ascii?Q?KC6RQ3hwMP2cu+HMLpHI2kk+XjM0h7/XteUmWfmI3xCFUWFvEMgCUWoikkYN?=
 =?us-ascii?Q?N2FGSKVXSkTWTlLX4jMYUNgPsEqXX5TZlwsD6GZ3lD98yyaAng5rVrUZWUT9?=
 =?us-ascii?Q?q2+T3ImZOdgNpZe+qqX+ZJdWIiupXBB4BRXJMvZUoRg2npcYID/djsYIgDkO?=
 =?us-ascii?Q?4SsQxImZ9V9L8PG/shOXWFDFkW+A/8f//3cMVc6XlHx5WSIuM1Vn8jrGtfzd?=
 =?us-ascii?Q?7oXcwZCHC9bQhBSuGpahPQSl674I5Fa4hBVSKtoROW/WaLZWZ1Bp78fQw3pA?=
 =?us-ascii?Q?HVN+kXzyQ81OzHUhwLFhmle+pqHpWcQDsMfAZW4gj3dgx7Cqx42uYvzClfQW?=
 =?us-ascii?Q?DfTq4laUnNhi4ROizW5+fFWgNzlyVf8m1JH+Qj2+cqGT/rIesjjL10/iJ42j?=
 =?us-ascii?Q?K4cXTy9njSX3jFTNEGFKycQjTbnpI+ROLq7baY9dvijIN5UpAo5+l8BPOZ+6?=
 =?us-ascii?Q?CERuUjXEACdr23B7rWGKCBXJ00UcOPysZGf3va+YLOvpQrKADM5gHTH5K9WY?=
 =?us-ascii?Q?kZ8Naa+XJ8LtajYv2aBs6cc3HBlsoGpHaVksD9lXBnW/UzV7+R2/xHP8O3La?=
 =?us-ascii?Q?+iehFY0sn1/dmLV+2LKz+DWgeWMBF36V7GATMSB2OzFQIOt/F+bedyfAFxsi?=
 =?us-ascii?Q?nVygEtUKQA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc252ad3-9100-4450-3e34-08def325e894
X-MS-Exchange-CrossTenant-AuthSource: CY1PR12MB9601.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2026 19:15:27.6872
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0Jlq2vlGRyWm0T+YNzNJoY81dxxJuS6hYz1RuKdEkasNexqBLOG7dim//IWw2CpZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7157

Summarize if any of the inv entries will use RIL. The next patch will use
this to avoid RIL pre-calculations unless RIL is being used by the
invalidation.

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Mostafa Saleh <smostafa@google.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c  | 30 +++++++++----------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 18 ++++++++---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  2 ++
 3 files changed, 31 insertions(+), 19 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
index add671363c828c..785dd21bd68b7a 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
@@ -655,37 +655,37 @@ static void arm_smmu_v3_invs_test_verify(struct kunit *test,
 
 static struct arm_smmu_invs invs1 = {
 	.num_invs = 3,
-	.inv = { { .type = INV_TYPE_S2_VMID, .id = 1, },
-		 { .type = INV_TYPE_S2_VMID_S1_CLEAR, .id = 1, },
-		 { .type = INV_TYPE_ATS, .id = 3, }, },
+	.inv = { { .smmu = &smmu, .type = INV_TYPE_S2_VMID, .id = 1, },
+		 { .smmu = &smmu, .type = INV_TYPE_S2_VMID_S1_CLEAR, .id = 1, },
+		 { .smmu = &smmu, .type = INV_TYPE_ATS, .id = 3, }, },
 };
 
 static struct arm_smmu_invs invs2 = {
 	.num_invs = 3,
-	.inv = { { .type = INV_TYPE_S2_VMID, .id = 1, }, /* duplicated */
-		 { .type = INV_TYPE_ATS, .id = 4, },
-		 { .type = INV_TYPE_ATS, .id = 5, }, },
+	.inv = { { .smmu = &smmu, .type = INV_TYPE_S2_VMID, .id = 1, }, /* duplicated */
+		 { .smmu = &smmu, .type = INV_TYPE_ATS, .id = 4, },
+		 { .smmu = &smmu, .type = INV_TYPE_ATS, .id = 5, }, },
 };
 
 static struct arm_smmu_invs invs3 = {
 	.num_invs = 3,
-	.inv = { { .type = INV_TYPE_S2_VMID, .id = 1, }, /* duplicated */
-		 { .type = INV_TYPE_ATS, .id = 5, }, /* recover a trash */
-		 { .type = INV_TYPE_ATS, .id = 6, }, },
+	.inv = { { .smmu = &smmu, .type = INV_TYPE_S2_VMID, .id = 1, }, /* duplicated */
+		 { .smmu = &smmu, .type = INV_TYPE_ATS, .id = 5, }, /* recover a trash */
+		 { .smmu = &smmu, .type = INV_TYPE_ATS, .id = 6, }, },
 };
 
 static struct arm_smmu_invs invs4 = {
 	.num_invs = 3,
-	.inv = { { .type = INV_TYPE_ATS, .id = 10, .ssid = 1 },
-		 { .type = INV_TYPE_ATS, .id = 10, .ssid = 3 },
-		 { .type = INV_TYPE_ATS, .id = 12, .ssid = 1 }, },
+	.inv = { { .smmu = &smmu, .type = INV_TYPE_ATS, .id = 10, .ssid = 1 },
+		 { .smmu = &smmu, .type = INV_TYPE_ATS, .id = 10, .ssid = 3 },
+		 { .smmu = &smmu, .type = INV_TYPE_ATS, .id = 12, .ssid = 1 }, },
 };
 
 static struct arm_smmu_invs invs5 = {
 	.num_invs = 3,
-	.inv = { { .type = INV_TYPE_ATS, .id = 10, .ssid = 2 },
-		 { .type = INV_TYPE_ATS, .id = 10, .ssid = 3 }, /* duplicate */
-		 { .type = INV_TYPE_ATS, .id = 12, .ssid = 2 }, },
+	.inv = { { .smmu = &smmu, .type = INV_TYPE_ATS, .id = 10, .ssid = 2 },
+		 { .smmu = &smmu, .type = INV_TYPE_ATS, .id = 10, .ssid = 3 }, /* duplicate */
+		 { .smmu = &smmu, .type = INV_TYPE_ATS, .id = 12, .ssid = 2 }, },
 };
 
 static void arm_smmu_v3_invs_test(struct kunit *test)
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 643cb81c50e462..057e180bfe15be 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1053,6 +1053,18 @@ static inline int arm_smmu_invs_iter_next_cmp(struct arm_smmu_invs *invs_l,
 	return arm_smmu_inv_cmp(cur_l, &invs_r->inv[next_r]);
 }
 
+static void arm_smmu_invs_update_caps(struct arm_smmu_invs *invs,
+				      const struct arm_smmu_inv *inv)
+{
+	if (arm_smmu_inv_is_ats(inv))
+		invs->has_ats = true;
+
+	if (!(inv->smmu->features & ARM_SMMU_FEAT_RANGE_INV))
+		return;
+
+	invs->has_range_inv = true;
+}
+
 /**
  * arm_smmu_invs_for_each_cmp - Iterate over two sorted arrays computing for
  *                              arm_smmu_invs_merge() or arm_smmu_invs_unref()
@@ -1123,8 +1135,7 @@ struct arm_smmu_invs *arm_smmu_invs_merge(struct arm_smmu_invs *invs,
 		 */
 		if (new != new_invs->inv)
 			WARN_ON_ONCE(arm_smmu_inv_cmp(new - 1, new) == 1);
-		if (arm_smmu_inv_is_ats(new))
-			new_invs->has_ats = true;
+		arm_smmu_invs_update_caps(new_invs, new);
 		new++;
 	}
 
@@ -1234,8 +1245,7 @@ struct arm_smmu_invs *arm_smmu_invs_purge(struct arm_smmu_invs *invs)
 
 	arm_smmu_invs_for_each_entry(invs, i, inv) {
 		new_invs->inv[num_invs] = *inv;
-		if (arm_smmu_inv_is_ats(inv))
-			new_invs->has_ats = true;
+		arm_smmu_invs_update_caps(new_invs, inv);
 		num_invs++;
 	}
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 9bc655f25adcfd..fde1819148195a 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -758,6 +758,7 @@ static inline bool arm_smmu_inv_is_ats(const struct arm_smmu_inv *inv)
  *               Must not be greater than @num_invs
  * @rwlock: optional rwlock to fence ATS operations
  * @has_ats: flag if the array contains an INV_TYPE_ATS or INV_TYPE_ATS_FULL
+ * @has_range_inv: flag if any entry's SMMU supports range invalidation
  * @rcu: rcu head for kfree_rcu()
  * @inv: flexible invalidation array
  *
@@ -787,6 +788,7 @@ struct arm_smmu_invs {
 	size_t num_trashes;
 	rwlock_t rwlock;
 	bool has_ats;
+	bool has_range_inv;
 	struct rcu_head rcu;
 	struct arm_smmu_inv inv[] __counted_by(max_invs);
 };
-- 
2.43.0

