Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013045.outbound.protection.outlook.com [40.107.201.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8853331AA8F;
	Thu, 17 Sep 2026 00:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789604885; cv=fail; b=pjqTBfD2e7sNJJFbnc+lDNhf1hCLe48JFq84A7c6BbwLfbFc7Jsz86UQSgbk7rzjjk19j1oiPYuCe2kg9IND6UNaqfqioS8I580HZ1o5eIIgEDZcqvW/abW6aEWYc0iLScoNdPf2PNR2lxkIgxTtOLfIC6menaJC98avRh/bAiI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789604885; c=relaxed/simple;
	bh=MmZ7aTOHkoqFXU4xCIomDnQ5XusoRPh9aZxB0sDYWfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YjEx75+it1yK2lY4JnHaAJmp75dhRvqmcLVU/p83scWPTsYyKnD614N6x7jvQbEbkj6NCnUDn29XasehYgsQfQ5dsRL9MNcPf7pwttnKWiVKc+olFQVbzrRYjRWgDQdFB/IAIV0JcHxb6tUUOW0PanWev+GT76R+NovG6Ij+Vs8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=rC+JfVE+; arc=fail smtp.client-ip=40.107.201.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="rC+JfVE+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pZ4IuVOY568kgXmJ/YdQpXPPEQEFst4vTN509sGyz6Yui6btmiIOlLYCtTjY0Ftm4OlD4vozRmhrsZCZIql8aBI9Krdpbcw+LPXILZxPRsapBgwBlqmq3D7VH2GgcRVfdEFm2sW33ibVI/q5JebvmfrGwaWujGwS0FoO8cplKSHcCvz6FkFRTS7lG2LqlVYmLNSRGnFPu5w7X+0f08txTphJWpo1qK+Bhhiya3VGpgp8p4xtZa4fQK/AWZx1NmfDR1tmr+LcIufe435XlH807QRSN5VkoVoBO5YjfiIgmAJW0Si1fd3LVIwggu2NusQkonQbljBABk6Z7TdIyFo8zA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sBdLUDZMDY+8JNwW30l7OsIqRp3msvOu3IuDTbQIcS0=;
 b=T7EiY8cIGis/un9y0deJ/13Aky9Xqv8BmWWjpQU4zFJZtj7Lwt0LPsNMYlUpx5oHacmLU1ETW5e2kPjw2Ng+WZUpTd14xV0wUnmsWUyU1OxscJo1HYExN9yRQIcwLaK/YvODzClWxKLSbLGEtxEI6oyK75Q5kJjRG+7Lhi81xa6wHoRGfGovgp9y6kS3aIVphhod9LuFHHWrFFxxIyr81mjgwcEzga0VYp2+1W6HtuqAHvGzOzTLscqSx7JlW9OpARQlmbHas0pp0ZHkDxUVqL8ixNkKN9Z0oe/XlUThjniOhddqdn29e1r0JZjPURNZLWaIryNpOU15JsK4zIFhAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sBdLUDZMDY+8JNwW30l7OsIqRp3msvOu3IuDTbQIcS0=;
 b=rC+JfVE+mrghuvsQywZHHyfyH9dIY/g8UVJeBwBClW2BlJnT21PNGH9Lb5QxPVWiMLRYZ2v3GjT/2Fa3g+ASKO1tjLyoCf14e2QqZuh3xv6dr6KEzW4laYfZB6Yea8fG4btrLV7CBz7ABk3ZCJ5mm6Y9pv/d0E9t6NGImq/uy3kGajtk6h1jpmstOKwnoF3vXHJiWdUCKESbb6R8qWkifKx88deKa+Jpx+LI2HHR1P9SBFl5g9fiQmRP5Nq90mDBodCE6IMFPnplgzhpge+PPKtMQQGh0Wl9Iwu33+0xsDs9WFn/3/xK0ZG6fD4a8AGDump9iVn9ETwugvejMhKmlQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by DM4PR12MB6160.namprd12.prod.outlook.com
 (2603:10b6:8:a7::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Thu, 17 Sep
 2026 00:27:53 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0428.011; Thu, 17 Sep 2026
 00:27:53 +0000
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
Subject: [PATCH v6 5/9] iommu/arm-smmu-v3: Keep track in the arm_smmu_invs if RIL is used
Date: Wed, 16 Sep 2026 21:27:46 -0300
Message-ID: <5-v6-9cd17417d355+281836-smmu_tlbi_jgg@nvidia.com>
In-Reply-To: <0-v6-9cd17417d355+281836-smmu_tlbi_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR14CA0030.namprd14.prod.outlook.com
 (2603:10b6:208:23e::35) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|DM4PR12MB6160:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c0d07a9-19aa-4a40-49a1-08df1452829d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|366016|1800799024|921020|11063799006|10067099003|18002099003|56012099006|22082099003;
X-Microsoft-Antispam-Message-Info:
	LGreC2H8ovXcQpM1c3/VibalORrfExpHFwyXwk7bGk7i96RRY8Rw0mqZJLDPbpFxGotXkjQJ5F9gKuyJA5LKwBSWlO6ZncYM9KjkjWe551uS53fMXIr/q6r27qkk/gRdvbwSP9SFHo8KIlUrxcDxH0KJlE8zTQIEtW9HLGYBax88Py9s0Vp3CvhjqoL/sOYZUH1VM3WzekzYZwR5HPbVOtDTWH1lGFVAcVDCVFGmcTwsitw1suaBU/jzMUPm0ZsOGlY/ejd2II/Ejm/6q1k9v56CGDOjx1JYPJ8qbaBq3iZfPtjAvH/kD5ZR+Li+ml+emEcR11ER1uvtkpN7JOHsgBFABNSxggQFDzCHAXiai//u+aYDR1w73eJkLe1S7AvwQ4UE2q9A/3O5mNpXXma1nWfImKtElqRDUC0qQwfxXTKwZ0lj7vgNnIxo6NRzeBFKHdOrU2mjP5Ng2iYfDHYbT2K8xzLHxu25nwM1xjh3fmCauzrrzT9kCxH8YU/AceoZxdisWj0sQ17oyeBM/UnvXaDf95orCO4RvYYN03/+J1P9aH58lFwqvbcP9Wpqth7CLbCWz4HtyZSJFaILIO5ndX61GSXlGu/fQBzlrqJGNQSUN8pfCqP/MYSPhhIkdzsGbjYVIoBUqW/6XLbX1GFD/5LUMOiZtpIsdYnjO6lSJ3waVXzWNB2cpn82+x3b8GifhusFcpF629GmJ9+ayTlPFw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(366016)(1800799024)(921020)(11063799006)(10067099003)(18002099003)(56012099006)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7ejoGg53MKUWcLApBqPDmrZ1QoECNrdI3MwvbulYxIxKauzxWLlSnKTyOaTo?=
 =?us-ascii?Q?O+WIf0LWQUCn0IA3QB+FnE8idT+q7JmlNEr6boUxqswBFzzuKBO7ZWkun5gv?=
 =?us-ascii?Q?RsOvnQ6m9EzeBu8aZHcHDf9bgGao1BUUdbux34FJjKMQBv8J94ZXhYcWJkfz?=
 =?us-ascii?Q?5rB49w/j7NGkb6+G9Ncj2UtUCcDLTZswuQ3ff3fi1LEc95X3PHwWcWgn8yL7?=
 =?us-ascii?Q?x49FRCkzgNiC1G5bLbOga+swreqdkjskRSSwbenwGdrCCNjNf64nfEHrYTt+?=
 =?us-ascii?Q?gIfLpqok0HS6d03JF3LTecdhK9QY2rm9ceS8qtr3JQHbkQ7bW5GVEj89mw5s?=
 =?us-ascii?Q?mlWu1xDt9ttB58LDIQ+ew/ixOOIl5fbtdmNDmNqoRQfoZSayGiyoCoWbkYDq?=
 =?us-ascii?Q?8ZF0giTwgAplDsnDmCSI1lvFh3x005ci5hDQgLlZCB2SmfYWDPL8WgZq1ZVt?=
 =?us-ascii?Q?VmkIqDCAKG+1Bnpff5+mVlTKxnzVseMhpanbwEjpUwA0Z4w8kHgyo0rArEgS?=
 =?us-ascii?Q?JRQdeuSeYXmNjRJ5HL6z9OJFq8FVXHgoCMFJiOqI/UkuEOgA9j5gfTduGnNC?=
 =?us-ascii?Q?EzrXI87I+DfFpG7R7n0FmZ06cNU1/PNwFzd+X6Z4kQWxbtmppRumIL/48x23?=
 =?us-ascii?Q?nAcGSHNcXv6WguQ7L/0Atm2Tjrdgba0tmNe2+XrYdq7vjVyejgyc3bdza5Kf?=
 =?us-ascii?Q?VVEFTfCd3OlY1bSOYcXvc9vpYkImM1wD45gnOUPsWep2Ndmwgc9/NdZ9bKt0?=
 =?us-ascii?Q?w3aIXc/38e7FZ0nTYa2XVroyoefvnIsSTWVNc3ng3MnsG6E5Sbo52bnCUeEt?=
 =?us-ascii?Q?Hl6t7aqx/vy9NBL9u3P16e+MT9J4R1n2FkwhiDq+JJJi+Zht5mWZqe6+jgd8?=
 =?us-ascii?Q?uDxbAvKaUewpKTN2KuO6UC4GOkwPB6N6iq1rbbRahVr/RsvhEtz0HtS7XheH?=
 =?us-ascii?Q?91lBHZQN+eIUUo82OOrBs2cSJrefV57/W7qijj/GiOHYHfMldmEytwnL/0tK?=
 =?us-ascii?Q?tGIiccYjSMDpzJ+uqq1OruTOiaghOC3YoWMlXHuey2UZEJen0WUwNy3okJbP?=
 =?us-ascii?Q?gvmI/d/uXFx80IoNug8s6cmJy8ZPSIeqS/K/G1vkh+KtV7CEHvzFofbRO1iN?=
 =?us-ascii?Q?wbcBwS2Be1F+feiY+rZFOpp74c5GT/i+4Eq2Zr3xjFe/zeHBO7Mb742HVj7t?=
 =?us-ascii?Q?iNWfmznqV4ZGIQVpREEGyM5bPEBHCOJKi1ASqNgkBnI7DiG2FKeIVWD/Rzwb?=
 =?us-ascii?Q?0ClcsS9KZWqUdxEgaepEzU+xlOoPID1qxK7E/PT1ZkJZPpeXvwBKxAROUUUm?=
 =?us-ascii?Q?11OGaa6msqwAs7MESiGBD/zSIJ/NWumZeHtfOnpt/B1Yxb+jx6Be+0ilOZjI?=
 =?us-ascii?Q?gZ2Uzj9Ngct64ffu8PXM2CCy++wX+Y3lo7hWXYM3qCmoMwBTRSM7fOoMiTPb?=
 =?us-ascii?Q?aDLtx4iMgehGiGwi+Lj0jCiOwyG1Up2TXxxM8iNZtks6nZNf1csa4/dp9Mqd?=
 =?us-ascii?Q?P3ViVPVxPN4ufqBEC4duveHvuCvWem6A5xiogHHXgfe0OygMB6eMWA8u1CQC?=
 =?us-ascii?Q?elvnN3MPt7LLWjfMQ/LA+PpNna1hRwi4I34RthEcy84FSYWqtaXjDDRZGE8G?=
 =?us-ascii?Q?k+7AL0xfmi5h/2FUfz+zcOia2tLG6NUv4m28mg89CzPTxefDOzTH+4rVzkni?=
 =?us-ascii?Q?KIKbGvjjGkdlQzK7W0bEWPIdv0k2WsY58UFc9Y5tkdwZ7QAh?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c0d07a9-19aa-4a40-49a1-08df1452829d
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 00:27:52.2380
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: COLndsJsDsrcNHRG8vWGPO5NNK6x+qMGvcdS2Dg1zyjk3salr/1kxi6cvxf4P9Hm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6160

Summarize if any of the inv entries will use RIL and if any need
ARM_SMMU_OPT_FULL_CONT_RIL. The next patch will use this to avoid RIL
pre-calculations unless RIL is being used by the invalidation.

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Mostafa Saleh <smostafa@google.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c  | 38 +++++++++++--------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 19 ++++++++--
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  4 ++
 3 files changed, 41 insertions(+), 20 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
index add671363c828c..6f8917ff33a02b 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
@@ -24,7 +24,9 @@ struct arm_smmu_test_writer {
 static struct arm_smmu_ste bypass_ste;
 static struct arm_smmu_ste abort_ste;
 static struct arm_smmu_device smmu = {
-	.features = ARM_SMMU_FEAT_STALLS | ARM_SMMU_FEAT_ATTR_TYPES_OVR
+	.features = ARM_SMMU_FEAT_STALLS | ARM_SMMU_FEAT_ATTR_TYPES_OVR |
+		    ARM_SMMU_FEAT_RANGE_INV,
+	.options = ARM_SMMU_OPT_FULL_CONT_RIL,
 };
 static struct mm_struct sva_mm = {
 	.pgd = (void *)0xdaedbeefdeadbeefULL,
@@ -645,6 +647,8 @@ static void arm_smmu_v3_invs_test_verify(struct kunit *test,
 {
 	KUNIT_EXPECT_EQ(test, invs->num_invs, num_invs);
 	KUNIT_EXPECT_EQ(test, invs->num_trashes, num_trashes);
+	KUNIT_EXPECT_TRUE(test, invs->has_range_inv);
+	KUNIT_EXPECT_TRUE(test, invs->has_full_cont_ril);
 	while (num_invs--) {
 		KUNIT_EXPECT_EQ(test, invs->inv[num_invs].id, ids[num_invs]);
 		KUNIT_EXPECT_EQ(test, READ_ONCE(invs->inv[num_invs].users),
@@ -655,37 +659,37 @@ static void arm_smmu_v3_invs_test_verify(struct kunit *test,
 
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
@@ -705,6 +709,8 @@ static void arm_smmu_v3_invs_test(struct kunit *test)
 	/* New array */
 	test_a = arm_smmu_invs_alloc(0);
 	KUNIT_EXPECT_EQ(test, test_a->num_invs, 0);
+	KUNIT_EXPECT_FALSE(test, test_a->has_range_inv);
+	KUNIT_EXPECT_FALSE(test, test_a->has_full_cont_ril);
 
 	/* Test1: merge invs1 (new array) */
 	test_b = arm_smmu_invs_merge(test_a, &invs1);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 4db8ad6f775a55..670ffa87c076ef 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1053,6 +1053,19 @@ static inline int arm_smmu_invs_iter_next_cmp(struct arm_smmu_invs *invs_l,
 	return arm_smmu_inv_cmp(cur_l, &invs_r->inv[next_r]);
 }
 
+static void arm_smmu_invs_update_caps(struct arm_smmu_invs *invs,
+				      const struct arm_smmu_inv *inv)
+{
+	if (arm_smmu_inv_is_ats(inv))
+		invs->has_ats = true;
+
+	if (inv->smmu->features & ARM_SMMU_FEAT_RANGE_INV) {
+		invs->has_range_inv = true;
+		if (inv->smmu->options & ARM_SMMU_OPT_FULL_CONT_RIL)
+			invs->has_full_cont_ril = true;
+	}
+}
+
 /**
  * arm_smmu_invs_for_each_cmp - Iterate over two sorted arrays computing for
  *                              arm_smmu_invs_merge() or arm_smmu_invs_unref()
@@ -1123,8 +1136,7 @@ struct arm_smmu_invs *arm_smmu_invs_merge(struct arm_smmu_invs *invs,
 		 */
 		if (new != new_invs->inv)
 			WARN_ON_ONCE(arm_smmu_inv_cmp(new - 1, new) == 1);
-		if (arm_smmu_inv_is_ats(new))
-			new_invs->has_ats = true;
+		arm_smmu_invs_update_caps(new_invs, new);
 		new++;
 	}
 
@@ -1234,8 +1246,7 @@ struct arm_smmu_invs *arm_smmu_invs_purge(struct arm_smmu_invs *invs)
 
 	arm_smmu_invs_for_each_entry(invs, i, inv) {
 		new_invs->inv[num_invs] = *inv;
-		if (arm_smmu_inv_is_ats(inv))
-			new_invs->has_ats = true;
+		arm_smmu_invs_update_caps(new_invs, inv);
 		num_invs++;
 	}
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 054ca19dde0502..d38cc176c2ce6d 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -758,6 +758,8 @@ static inline bool arm_smmu_inv_is_ats(const struct arm_smmu_inv *inv)
  *               Must not be greater than @num_invs
  * @rwlock: optional rwlock to fence ATS operations
  * @has_ats: flag if the array contains an INV_TYPE_ATS or INV_TYPE_ATS_FULL
+ * @has_range_inv: flag if any entry's SMMU supports range invalidation
+ * @has_full_cont_ril: flag if any entry's SMMU requires the CONT RIL workaround
  * @rcu: rcu head for kfree_rcu()
  * @inv: flexible invalidation array
  *
@@ -787,6 +789,8 @@ struct arm_smmu_invs {
 	size_t num_trashes;
 	rwlock_t rwlock;
 	bool has_ats;
+	bool has_range_inv;
+	bool has_full_cont_ril;
 	struct rcu_head rcu;
 	struct arm_smmu_inv inv[] __counted_by(max_invs);
 };
-- 
2.43.0

