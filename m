Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2057.outbound.protection.outlook.com [40.107.92.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB2617556C;
	Tue,  6 Aug 2024 23:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722987106; cv=fail; b=XKzjhOheWx7Yw5Us9THl4ZHYwly5W/kY3ko4Gd4LKYENitfAXPKi4D/e7ipyVVqIqqpYeP0Yuc8nt6m4vgqm2oPVK7iaPf8q5bQryNRQb62RFhJNUPyyqR2/fpvuVdioqb8mCzRxKhRdy0EykuxfuSv3v8jMZECphJ1nRnq5bVE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722987106; c=relaxed/simple;
	bh=OF8T9hCC1Esjgrc7IMZubQvUriIkzP4hfPH2+i3eZiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HNs6haJ0y3o4xDKWV6RvzNPoDNZlqTM4Zz8rKVisIFltj/CyjUUD1guV05NbnJwr6GrqLNRnaGGdoSliF3KQ1h+cWq2Q9uqXrV9ZbWH1ZeVmfI1znKYgMGMeUv13Eiu5PLV96pW+BqZgRvHpPbGmPXEi/2y2HR9bn6h+J6nBypE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=m+pAYo2S; arc=fail smtp.client-ip=40.107.92.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="m+pAYo2S"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lAv2AsHA1NiHKtFYW70xkPWbbVc0KgJN289DERCPioFFhF6OfQnIbulBmSQd/n6Rgvq1sRShdyFnRrAnnP9CEadpPRbTethWNhi8jsHA/P2iZiYZ4/v7TrZn9mvxRejmE65MkYzV8QjQYQOvUosmO0/laERvwIFZz6Tt/F5iraNVL2vm/YpidD4rQZZd3DR3+sLEitLMWxzgjHknkWMotvS1IdK+9xLWsw4qkcYV/74vP1TKXgGyho43yDLq92aonV0+1feJy2Ay5TB2em+bFqqIq/73evGZdzSQIit2Fv7NctmqZhFcqp4XJZrXCU+0tUB3Lr9w/Bu2P8NxEZSHIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CfyBdVA/x16kGwnKRbwfMRQ5CJ0bzDTpS4paTmqFNMc=;
 b=kxKYlvvofUgp/dyWOXYlAxIvoaLoAP3tu0PIicQA0BDwvdKT6eKrVoMVa2M6hFRwrLDWVp2NrLtDsTVhHOUhAKpQXBWCHfgVLsX5xgl7gnWflFoG81xtkUKkqxzootRWE+NBYhbDYfA1C+pXAYOQn7i1OvjqqHUzw7ArnrldOswgV8vX6Yj/Sk5Gr8lu4pk8eym7kdIe25xebpJCFDHEIfV3BcgJnukfgTaehw2+S1UoEIm/68X+wFADBMOl+MdshIajoPzIR8hNS0yGZChEgNph5RwZRxqcpGBNAVm8utwpKd80Zv8QODeowj1WQQIj2ShT81VO/ykxZnhxK75nsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CfyBdVA/x16kGwnKRbwfMRQ5CJ0bzDTpS4paTmqFNMc=;
 b=m+pAYo2StUWh/voimbRoFdZMl7grkZ5de2PHSr2JfjqU92mf+lwsJSBEeX9wWJlF9XP+jPJmFT+xG83HNbcTqvq1qBY/Dqxrnu5ArgzZZXYDGDjX/tLjMvPakUbV1OtO0WTSisxDe0hj3j5oYZLcdbpCUbopjV6ADNghkMnVKEeFjH6R5p1teBLz3ELyg4bwkRdCUX+ab+P6GA71+b60coD+ivwUbht8/QRdse4BPMcNVUXWUzzBOssWQt+GgZOhY3BzQM5s8hY1CgJKUPRJ372lbV6iKHFKhsMMpf0Jw5C4+JAE029F3cEOmSt529PkeBufX90q/IH7tAuOzxEh+Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by PH0PR12MB7839.namprd12.prod.outlook.com (2603:10b6:510:286::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.23; Tue, 6 Aug
 2024 23:31:32 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7849.008; Tue, 6 Aug 2024
 23:31:32 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v3 1/9] iommu/arm-smmu-v3: Use the new rb tree helpers
Date: Tue,  6 Aug 2024 20:31:15 -0300
Message-ID: <1-v3-9fef8cdc2ff6+150d1-smmuv3_tidy_jgg@nvidia.com>
In-Reply-To: <0-v3-9fef8cdc2ff6+150d1-smmuv3_tidy_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0089.namprd03.prod.outlook.com
 (2603:10b6:408:fc::34) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|PH0PR12MB7839:EE_
X-MS-Office365-Filtering-Correlation-Id: 94bf0f7b-5870-4a0d-e50a-08dcb66fe49b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?rff6NF0ATZ//aEyoITPVxfCq6QqAMKMW6xzH849PtqTA1gx6SyxqrOyUm7TR?=
 =?us-ascii?Q?MPp0tsBWh1kHnlpVhWdp9YQM7JNu4EFmbKvnYrGuqsa255m59ZtjM0V/7tmv?=
 =?us-ascii?Q?3ydQZsjRWquy49eGB1GslaOI+UawLSPvmTDP4WkPu85HPCQbn7mdjfmGc+g3?=
 =?us-ascii?Q?T43WAgnM0OEKwNmEDfRi22Ue2uQQu9LjtTKrMevupFoxHGD4n8RZp/qAjbFr?=
 =?us-ascii?Q?OUFIUe3D2LUyyQ5ZFVF9rs6Y2kNjtBcI5GZzJWReOmI27ANQF44D37lo/dZ/?=
 =?us-ascii?Q?JKwR3Bokd/JHylmPEFwpXOfGs8yMtcyyUg/FcCFfes1pbhuOTXTpgd4CNzRu?=
 =?us-ascii?Q?Tci4r+P6NH9QT/24y9Lo+N+9eBoSrdzsiYvIpIhyQ9UgdAhDnISRfOfPP/pc?=
 =?us-ascii?Q?s2C+/zQKwxrpG5hdyVO5hOR2qhatTxuIqC/mHZ3R157KcGLykkK8XXyeey0H?=
 =?us-ascii?Q?dD2JngdWskzPP556K9MuIAB4zr+I46iWQU98kWw+bPuNQBA0+edH4YvenzL7?=
 =?us-ascii?Q?2Cj77lr2yssI3Q5r1AR+SRpN6j5e8W3wjGuJEJ8LGkRMNQ+epiFYo8klf8YZ?=
 =?us-ascii?Q?Ae0jQKkQGAqhqrZwftEnpxpRqzmcNmxH3soOA4t2H444nNxX35/01iRzncIu?=
 =?us-ascii?Q?4PyU7MJU38Ps/CD9Uk7laCt7vwA7/MAWqN3Wl+FUQw4p/gbkUzgDqr2TeTXO?=
 =?us-ascii?Q?AwZLhihVfA/ynjAappwHuvFHF8MTQf9pOL4TJb27iFoMEyDMQcEOn9Txvdg8?=
 =?us-ascii?Q?z5yWmRKE5UY1oABeeg5biioEf69Ar/SUWbrMJxAAAN6IfIOC9rp+QWK0m6wm?=
 =?us-ascii?Q?l9WJ1GeVUGOpEBbhQ8yrkcfatgW+IGnGbCapud1lTXVWlkxeZqsO6lUYaxfn?=
 =?us-ascii?Q?ktB/sRm7xGrPrc1hdG/xWOZ9aPSs6YXhEWARrTGEqD7nWdiL0hphz6Rp6pZX?=
 =?us-ascii?Q?4E+XB0Grombn2D/rxAw7YgNUNN2CTXwjm0xHNyM+kYW1whoZCYfghlXr6u/Z?=
 =?us-ascii?Q?GCtWL0D1liEhiyvZ2r0L9pEajI1F2WsWv2+hl06qISE9cg3gEzoJlG4lZcPl?=
 =?us-ascii?Q?Vj/1YejD9N99xhNLlYNG+Gpn3HARYzhDWae7dUH904j4Mmrh/1T6YDp7ZY5z?=
 =?us-ascii?Q?01VPzvF5xK2wExJuKPPfVPH81clGt5WCpK3ktQQbFQbUmX47S+8OQymt94Fo?=
 =?us-ascii?Q?rTW2/g5cc9WOBsEr2L/Gp61JT0xlDRZd8WCDIkdyn91TbXOpwYfbZSr15+vn?=
 =?us-ascii?Q?mOwZ7G1x2ixEeAz5xnTxbrOWJG6Sh/Zeadn/CLenQILdP0OY4G6ci+U13ZDx?=
 =?us-ascii?Q?3DEOa2NhVz91ckDUNhGryrriBnzbd15TOX8qRN3KhL/AzA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?W1XwVd7zpmn0QwkDuJcJqmhqy56DEYW+TaaPgd3BVlzzDbROx11I8bwI0g2H?=
 =?us-ascii?Q?ihoCyAE51NIsHqKlgbat/HWjca2HWcYwRE/4UbGLx2gzsx5uX/V3c8JH84ZG?=
 =?us-ascii?Q?k8Pca1iVqAMtc3qQ/ka2UwicY4qw8ZQwhAde1qqwJvqpvoJnpJDeKTq5DhoZ?=
 =?us-ascii?Q?Go2l7XmIom4CEF04BTg4ZnHiw/voZhtqfxrmVqLL9Fe2ba6gc2HZeaOZydRB?=
 =?us-ascii?Q?PX69n15DUVq9cF5Z/KEctGLzdLyjt/0GRFwECEKY0REF+u5Fum28HjZq6DKJ?=
 =?us-ascii?Q?3MN9XQM9NQOy9FkG/85cVmkTP9/ooWhctr7Ue9jkXTWQR3hwNyEiieGOT/pK?=
 =?us-ascii?Q?1AaEGfTI3s9/kdMM4DOdeWE9+ctbabSI5waD/0S3e7z32JWPdWZVQUV+1dO2?=
 =?us-ascii?Q?PXZJ5P0HFLX8HYjZ5YEI+VStkvYFpYuZRlsko22j2iSsen/1Ej2yZbK8QqYn?=
 =?us-ascii?Q?uA4ad6+4ICJBWms5gWqwUfr2jWPHEG7XTgA5Yliy3rnk6eNj2TzyiK3cCzvA?=
 =?us-ascii?Q?L5OY9aaz3OnBMDM4EdOlYssk/ClXlGT5QdThS+1eD3sp2oUmyAAt83FKzxKC?=
 =?us-ascii?Q?eEQ5JEHJk0OzgveDErBLVAsXth7jDAFBcU/dlJLmxjBwLA0i7PhtKfaiFF0b?=
 =?us-ascii?Q?kNw72Z76d4ik3XvJI1LqkKEJiHa/aryu+jMO8CgQMgMfDMMLBnlh9J0mreEO?=
 =?us-ascii?Q?6BGIB34ubcpU+gXuyquYVbWHDjNZBewKsyiiUSS03hxTrvq/yyUFRkR/osqg?=
 =?us-ascii?Q?d7ajHtIUMcayw9Jnqx4hR8fMMfK7PBUyeDOlrjdE8pG0+iXYF4LOUk3Id3M6?=
 =?us-ascii?Q?BLYme8mz7Y5cnAAwrhcBLwzB4wcqiGJ9mMvOZ2t/4CpmJmqYRk8kQhR69ecN?=
 =?us-ascii?Q?q+png46X4Iqg5nZlwrfkBXQlLsq6XqKnB9pp6QWlgpadXpn9sEVCfRbMVU4S?=
 =?us-ascii?Q?AyMqefO8wohXKujhdi3NrJ60sixr+hah04zFGgkgljBffKzAidTgHzSPfLGs?=
 =?us-ascii?Q?9nhtMczQ/52l3IBkP7K4ygtwuOuvqlYystbwrQhhwEU3TSW+UQo17HSqNqUN?=
 =?us-ascii?Q?h9lGPgXGgd7xWj6LxAgS486IuNLtZPWQBXDaqlPuNfBt4QWP7Bg9eJr7u2td?=
 =?us-ascii?Q?TdV8WOVf1RBzZg093lyEhLNja/ABWfvEeZeNsURvs9pMGsVMqiNbUQSaygQ5?=
 =?us-ascii?Q?8o0RPr/iUeRYBOqBM41uH1oTSV+F2lKGnhNeB9wvsZ8QIfTWjGvdJ9Yoo2++?=
 =?us-ascii?Q?ZCAZa0Hith8TTn5XOdHuUPyNmN7InGPXl1nVShjuw6YR9bYfBeygC/4pKLQh?=
 =?us-ascii?Q?ZEjcphhh6QVHInjzy10YkxguD7WDvbPwkWUDup7ISabZlYNvF1jCusTSTn79?=
 =?us-ascii?Q?RMlcOw9qvgCKyeS+8Ex8oY104ykIXLdl4nGTXeclO9tbuIReXpBhae9m+Qbd?=
 =?us-ascii?Q?+71GH6Zxd/hch3JY+G74so4IHNxL129ikr/omk0iQMdl2uTMNFPqtlO7t1CM?=
 =?us-ascii?Q?zsqBs0M8ZVzJqkBfClZluiAw3NTKQV4Xj2E70doMA2g9v48pY5+n1yyMTlp4?=
 =?us-ascii?Q?m1ZaKP57SaNkXk98cWk=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94bf0f7b-5870-4a0d-e50a-08dcb66fe49b
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2024 23:31:27.3678
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VpXrTgTz5jadElhcvFdxY/VfL7yE1lU/gMIOUgmduBMMDMWdBp2OJjuHizPHpodQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7839

Since v5.12 the rbtree has gained some simplifying helpers aimed at making
rb tree users write less convoluted boiler plate code. Instead the caller
provides a single comparison function and the helpers generate the prior
open-coded stuff.

Update smmu->streams to use rb_find_add() and rb_find().

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 68 ++++++++++-----------
 1 file changed, 31 insertions(+), 37 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index a31460f9f3d421..b80f3359a8d12b 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1696,26 +1696,37 @@ static int arm_smmu_init_l2_strtab(struct arm_smmu_device *smmu, u32 sid)
 	return 0;
 }
 
+static int arm_smmu_streams_cmp_key(const void *lhs, const struct rb_node *rhs)
+{
+	struct arm_smmu_stream *stream_rhs =
+		rb_entry(rhs, struct arm_smmu_stream, node);
+	const u32 *sid_lhs = lhs;
+
+	if (*sid_lhs < stream_rhs->id)
+		return -1;
+	if (*sid_lhs > stream_rhs->id)
+		return 1;
+	return 0;
+}
+
+static int arm_smmu_streams_cmp_node(struct rb_node *lhs,
+				     const struct rb_node *rhs)
+{
+	return arm_smmu_streams_cmp_key(
+		&rb_entry(lhs, struct arm_smmu_stream, node)->id, rhs);
+}
+
 static struct arm_smmu_master *
 arm_smmu_find_master(struct arm_smmu_device *smmu, u32 sid)
 {
 	struct rb_node *node;
-	struct arm_smmu_stream *stream;
 
 	lockdep_assert_held(&smmu->streams_mutex);
 
-	node = smmu->streams.rb_node;
-	while (node) {
-		stream = rb_entry(node, struct arm_smmu_stream, node);
-		if (stream->id < sid)
-			node = node->rb_right;
-		else if (stream->id > sid)
-			node = node->rb_left;
-		else
-			return stream->master;
-	}
-
-	return NULL;
+	node = rb_find(&sid, &smmu->streams, arm_smmu_streams_cmp_key);
+	if (!node)
+		return NULL;
+	return rb_entry(node, struct arm_smmu_stream, node)->master;
 }
 
 /* IRQ and event handlers */
@@ -3173,8 +3184,6 @@ static int arm_smmu_insert_master(struct arm_smmu_device *smmu,
 {
 	int i;
 	int ret = 0;
-	struct arm_smmu_stream *new_stream, *cur_stream;
-	struct rb_node **new_node, *parent_node = NULL;
 	struct iommu_fwspec *fwspec = dev_iommu_fwspec_get(master->dev);
 
 	master->streams = kcalloc(fwspec->num_ids, sizeof(*master->streams),
@@ -3185,9 +3194,9 @@ static int arm_smmu_insert_master(struct arm_smmu_device *smmu,
 
 	mutex_lock(&smmu->streams_mutex);
 	for (i = 0; i < fwspec->num_ids; i++) {
+		struct arm_smmu_stream *new_stream = &master->streams[i];
 		u32 sid = fwspec->ids[i];
 
-		new_stream = &master->streams[i];
 		new_stream->id = sid;
 		new_stream->master = master;
 
@@ -3196,28 +3205,13 @@ static int arm_smmu_insert_master(struct arm_smmu_device *smmu,
 			break;
 
 		/* Insert into SID tree */
-		new_node = &(smmu->streams.rb_node);
-		while (*new_node) {
-			cur_stream = rb_entry(*new_node, struct arm_smmu_stream,
-					      node);
-			parent_node = *new_node;
-			if (cur_stream->id > new_stream->id) {
-				new_node = &((*new_node)->rb_left);
-			} else if (cur_stream->id < new_stream->id) {
-				new_node = &((*new_node)->rb_right);
-			} else {
-				dev_warn(master->dev,
-					 "stream %u already in tree\n",
-					 cur_stream->id);
-				ret = -EINVAL;
-				break;
-			}
-		}
-		if (ret)
+		if (rb_find_add(&new_stream->node, &smmu->streams,
+				arm_smmu_streams_cmp_node)) {
+			dev_warn(master->dev, "stream %u already in tree\n",
+				 sid);
+			ret = -EINVAL;
 			break;
-
-		rb_link_node(&new_stream->node, parent_node, new_node);
-		rb_insert_color(&new_stream->node, &smmu->streams);
+		}
 	}
 
 	if (ret) {
-- 
2.46.0

