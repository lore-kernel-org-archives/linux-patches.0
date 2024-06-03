Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2059.outbound.protection.outlook.com [40.107.94.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 274D082897;
	Mon,  3 Jun 2024 22:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717453902; cv=fail; b=gcuxOEmmWx7DuGRUOJ1P5iPDUic0I5QwezxX4/dzuJgCFn8ln40vCldQbY7jfxVNzoM4yr0hqV4mUbivXf3NuOrUMXsq457QFbEK40X42QROvT75uKxG/6kMHAXILEwCb7jLU2hmu3YK6cyzXzlkkE9FSqlpEarzftNy2URVQr4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717453902; c=relaxed/simple;
	bh=w9YttSRXWa6J80ZSiWUpdYRgDlf4rVtqY/L50NyHQx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HS9IK8hESJspuT4o0mXG5Gfl+NLoDaAVFWqq7FXjgtiaR887dzB6fm5+8bkC60QKTjJLJ+6uJSTEQ6ISvc/Vl3Z8iEJi4zpF+ywQwcs5CSUbQQMtbIj3JaNhIOTjfGJBwEzsRxJv1zYdH1FG6qbrfEj9o7DNPP5tgTpCRW5QBXw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=f5wnNlSK; arc=fail smtp.client-ip=40.107.94.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="f5wnNlSK"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h6S+JxHzqxhnNC2qeKQESGnQAfnH0XZ1z5y0LDatQwQICPIZm3jRSreqgsjQOpFK+bVavUzlQMweiV6FWmhbcNDq2CA7ane+0hETaeQilfXdodGiZi8U8pcesaWQYdAhaqI9LBjFuioxd7oD3e/MSYondnHgKEmAm9tl+kPoCKSwdGqOXI7uwxS45g0RcXzQPApED1f+1GED7vaiB8wZ+ZYAtR+NJ2YZYTACImd3g4kgGA+5mS68YTw3CJOfWofp1y9EiLYVRm80pqX1qQMQ8Hzm+5bQQw704wH1bUSEuT7r7I3UBEBF2XW9JkMAY57Tjh5EnTj06GuVGofPFuSJhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OnrP9TZNj45KWCa25TlWJpeIbyGKykmf/Au/wIHgTFI=;
 b=WdEBQ7svoBlPY7YFJ0PzT79U/KZ02LH4BENEvL6E7dp5A6A+eOxAx/Cv8jXtJDafw9CLV5Ae4OhPKXEHsn4sH5omC/Rtycl5tkCQl/EzZFt5DoZfvScK1Or0nYS6bMyBVN4AokJcjzOixU3OTJF88hftQDEIIsygXV/zuQKAye/huoOfK6Y5FGncVsGY1NMuEntqM63deP1SzsbVyIiuhcrY6hILvxhbemDz2/aZHTgZYqaE19bsDoHHmjv77CtoJ+fDdCUQMCTHP4yHeiCBE2qRv/LA1E2HuctlPKBKOvHOos5ZhGxJGBMYCYaeayEl1MHqjJB5ydvaFCgA3dUI2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OnrP9TZNj45KWCa25TlWJpeIbyGKykmf/Au/wIHgTFI=;
 b=f5wnNlSK5+tte1kDNIVxQ5nZ25REYk49B0XUqQFyQ9QkqcpzJxz7r7HjJJTTPHpJIYXYC4TFywLfC6aSJQLa5fbFnDgd00q13rmo7VuLu2GGmvaf9CL2pPwhi+zQn+PAakTuZulNUmfdjXYVjpPfmn62pAhQlfexmvWxts+257gmk+yMdApazWin/asv0cJQNdsGVuir62f1C9SE9wrQVv9YwfB1KoRPLbe7IHpzP9zOM03pDlkeAGBnYtXP8jcyi4ddhz6fL/zb0ofY6QtlsbjvaoZtpa7aiQePJ0QQQc24sJm1VkWWKw4K6PBpg6gG1JTHNd8HsoNCYsQKwkvXkA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by MW4PR12MB6778.namprd12.prod.outlook.com (2603:10b6:303:1e8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.25; Mon, 3 Jun
 2024 22:31:36 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7633.021; Mon, 3 Jun 2024
 22:31:36 +0000
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
Subject: [PATCH 7/7] iommu/arm-smmu-v3: Use the new rb tree helpers
Date: Mon,  3 Jun 2024 19:31:33 -0300
Message-ID: <7-v1-1b720dce51d1+4f44-smmuv3_tidy_jgg@nvidia.com>
In-Reply-To: <0-v1-1b720dce51d1+4f44-smmuv3_tidy_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR19CA0017.namprd19.prod.outlook.com
 (2603:10b6:208:178::30) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|MW4PR12MB6778:EE_
X-MS-Office365-Filtering-Correlation-Id: 25431cc5-bbc9-49f8-dd24-08dc841cece7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?GqHpijjXRAF8e7oPGbQOCTc8SgGfImMrIe09tt4R3d9epmOj9IQ6Ds0Jym8I?=
 =?us-ascii?Q?f5uPZ2H03+yxmVASKxBXfeWFUplG+OvlLVE6Zsewmrsr+AoPJ72iSM0oSzcB?=
 =?us-ascii?Q?Xys4wrqkIKgRVoTDYXuRNsKUYS9wptM2nNlfFKtbjLlsZl7zvxK8+njA1gLE?=
 =?us-ascii?Q?DI5ANEnAal4loN1YQcM9car4I3A2sIjT2lFjlE3YgtG2zaHnDZKCD2bz8qVD?=
 =?us-ascii?Q?0eDRVRb1fZv7I6BJv3fVrq29giBm9mppoP3y/KWr9Sh6oY9KmS41KAzb3Ug0?=
 =?us-ascii?Q?dRdoTZ2p/6CbzinhpFiJqKUtIm3vrVohXsq4y7SH2Iasn6anXbTfA1U7eF/D?=
 =?us-ascii?Q?XK071Nm5aA7//gcsQW2qJf3ZLH/Hr0w3BRJVuch02tXI/BfAz2nqAI0j/1B3?=
 =?us-ascii?Q?/XtL+GJy8hX9nafylPstGRFu38HIQNhp/ivWu/tMlUsFoYrycfRa9o4cvbDs?=
 =?us-ascii?Q?5xJtZrNuO4tJFjd8QrQfvGA3Ttt+6KIbdcm4pqkw7Gbru+nuA5ioL14ebSCM?=
 =?us-ascii?Q?LKCUUx2EbbWuUyxJbcp69aNm7eUavpsNZxSGHsHh4srlzOh+LCJrtoDKVPSI?=
 =?us-ascii?Q?dgphm2pRT7yZ2Euya4d8ifpEDaHNQccOmP3nj6cqDs0IvN1lUYNFLeOQ1BlH?=
 =?us-ascii?Q?jslEJsSYDkvxX4Yx8w0/jkbG0h2yzBPNB+kb9LjMKaS6Y2Emm9hsr2RqyB+Q?=
 =?us-ascii?Q?HufjCxMVyR0dMSLZFCQ55kfz5nSrwdMaKOM3zZ/VEvyqgKmYQeHYJtk2N6dg?=
 =?us-ascii?Q?ECejlwHA7R/rPsEaamB2E0QCBkqZyOsukNT7vTOG2bAB4D5aymu0Ar0Fg2yT?=
 =?us-ascii?Q?kSIkt2zy5YRKx9akZDqOgGrU8M4E5ZjM83DEDv4LffmzcjpIvPtbLV7RA4Uj?=
 =?us-ascii?Q?yJvZeJEoyvJZZ4S/NlOj3MjrU3WCkSgQ1NQ2dxZKOX3646D079WUvwntTMCZ?=
 =?us-ascii?Q?n4a0iUq3/ak/8HKjwDsfmZ11Ch7+kGuY1l7d7er1cmEYyU25HOU1LUnpo0n7?=
 =?us-ascii?Q?oYQ4Tfj+aLt25ArYEfGF8SHnvrT/2YSEWkDC3b0IjBtpafjhhsXXQKPgvXzY?=
 =?us-ascii?Q?q5nUkRKZinUg3OFBQEcZkHXiPWYySVpQVtmIaDF1eaTTpdOb07WLfGVLQnnE?=
 =?us-ascii?Q?M1Yu34K7H2uB8hTruGT89sOZovEGM476x+vsvp4lCCgljqglhoBUmNe3296u?=
 =?us-ascii?Q?MlfR6i5abSOTp0PExnl69ojSwrecYIezvQfoeaz8fOcBj92L1/GrQsp+WYIo?=
 =?us-ascii?Q?WUfAy65wP8IabbYbiUMHS9KVloRKYBC1r+UmZNAD4g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ectm4WMu4svWuY8uCpJkU6Rdz+C0U4qs8peWN5xJX+1LLO8XWbxLsxusuBfs?=
 =?us-ascii?Q?9WvXSiOmqIuFNhXH2gYWWiVav+JGfBf0iykCBnOlI79NYgunON9UtDyUvwQm?=
 =?us-ascii?Q?e43Ro0X3BtjBFszQaRrXViZWg6TBgrzxIGWVG+iQRBQzy1Y/RCvHcKs8SEwl?=
 =?us-ascii?Q?eAW/UdV1j358CanxCPwK1pTfr3+tz/KruLVf7R80LZLE/gpACJBMXMW8M49g?=
 =?us-ascii?Q?nB4Uy9+vV+MaR9iwFWNOcREkVyucZY00mpNh/cKmN8aoGnyW3A4pKaqaQsap?=
 =?us-ascii?Q?FCvWIUlQMMjGOS8jzTgAJ1f+2oTyy6MDGZuw3sW2MMIGGLKUVXFZgApIJt28?=
 =?us-ascii?Q?77CRwKjwpOJmq5QaaT8+HzpAm1cTad+x6RWClFUZfj+Bl6PUWontfgv4a7GF?=
 =?us-ascii?Q?k2DP5jQkAmItAz0scWwqt72h61jWefzJBxVkDGg8PFux6m6jLHBBXEB9Pn/Q?=
 =?us-ascii?Q?Wq7ewaQPapic0tlakRQsVJZKUrCgjUUbCvy8kjE+PEpbt07qZzjWRHSXXjzD?=
 =?us-ascii?Q?DCr2viUoSspo2QMdT27Vpcu6P9WEigCVPMiOvHOjIaD1+vP0iTWyljb9377Y?=
 =?us-ascii?Q?bc6JIktvNoB9uzuDjpSX9Llqi/N2hVgkZWqqcSOUXgkewt75d1wFzPDP+u62?=
 =?us-ascii?Q?DgO0qKBTFvoXYhKKwjpJE0XY2YfrqQaVb5i8AJvMHOgCVv6pJvcaH7694qNs?=
 =?us-ascii?Q?q/4uUpyQoByIIi3YTWtGsmtqrlOANuDrrq9jjROvQ2nI6RMn3p/MMZNdAbsc?=
 =?us-ascii?Q?n2E+nB8bcUCifPqNy8U/VlRYpCzKwlwoAoRQpwfsf6oCZyLUak0rEOp8Dsrj?=
 =?us-ascii?Q?RkSw4mDLyo51F9AZ8dNNrRRhwD+rTexJfgsKvcpWvyHTMM0ZN0A0dkysdgph?=
 =?us-ascii?Q?QRSbdhsbdf9KmBgYqb0RMWDvzviAAIKQmCTxJbftLpONd+mVXFcm16HeFF62?=
 =?us-ascii?Q?PRTHiep3JCLmoSGwqBVK7oeIiWmlqSf1s77uzHAlHmFUShVaDjCThBW1ECOV?=
 =?us-ascii?Q?iL3owzdyThmOCUfvRo7/t9gr7dBl6sfwK7P22qac0fjFHTd+dOZP8yEo349h?=
 =?us-ascii?Q?AFOj5OM6NHnHNETvOHUl/Fknrqfxf4tJvIyI9/J3frtX8iwaJD/AATvxdBze?=
 =?us-ascii?Q?qR4Mx6/VAwPR7WdkijyNzEEo6f7No/PqTNnS1SeWVbxgBSZIaW55fakfe2/H?=
 =?us-ascii?Q?psOQCWC2ix/8n2qte7Rkz6YvO3W8AuYa7qVBs8X0dXm7hQYqDVRndJi/pt8S?=
 =?us-ascii?Q?NPW/i/9ktHIdcLudNv7Rd8toRfftYylZPc+wouYaEYDdxVdOTM7THqrAr6sf?=
 =?us-ascii?Q?XN1qt6oLvXzA+npG+SneT76mKFcM/qHn+qpLjjR2BHJDI5IJg/SRCrZRFi5e?=
 =?us-ascii?Q?NVm9pNrchzB5tmTsr2yPCaOjzNfLYS+HfV3q4J3U6Nu/ihDvfkCqvcPmbPzS?=
 =?us-ascii?Q?Gze75WVzIujzkTHa2KtlV3WoHOo1gqPX3dDuEfF6aqrS+Fr04nqeNoYjIjOW?=
 =?us-ascii?Q?CEh+OvAAx0tomfR7BSIrDpUBnCSw1RsAm0TEXQFopg2GAS1m1v7goN+hxzdu?=
 =?us-ascii?Q?qYz8rZi5Hpntaw0ml/U=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25431cc5-bbc9-49f8-dd24-08dc841cece7
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2024 22:31:34.9784
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: juI/f0KTn+EYg3LHeCj34T+6+p0gZmkOaO1twWN414+viQxZsaAbHuTTR4uglotN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6778

Since v5.12 the rbtree has gained some simplifying helpers aimed at making
rb tree users write less convoluted boiler plate code. Instead the caller
provides a single comparison function and the helpers generate the prior
open-coded stuff.

Update smmu->streams to use rb_find_add() and rb_find().

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 68 ++++++++++-----------
 1 file changed, 31 insertions(+), 37 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 7a6c9aac4cd450..25bae0b05a488c 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1667,26 +1667,37 @@ static int arm_smmu_init_l2_strtab(struct arm_smmu_device *smmu, u32 sid)
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
@@ -2795,8 +2806,6 @@ static int arm_smmu_insert_master(struct arm_smmu_device *smmu,
 {
 	int i;
 	int ret = 0;
-	struct arm_smmu_stream *new_stream, *cur_stream;
-	struct rb_node **new_node, *parent_node = NULL;
 	struct iommu_fwspec *fwspec = dev_iommu_fwspec_get(master->dev);
 
 	master->streams = kcalloc(fwspec->num_ids, sizeof(*master->streams),
@@ -2807,9 +2816,9 @@ static int arm_smmu_insert_master(struct arm_smmu_device *smmu,
 
 	mutex_lock(&smmu->streams_mutex);
 	for (i = 0; i < fwspec->num_ids; i++) {
+		struct arm_smmu_stream *new_stream = &master->streams[i];
 		u32 sid = fwspec->ids[i];
 
-		new_stream = &master->streams[i];
 		new_stream->id = sid;
 		new_stream->master = master;
 
@@ -2818,28 +2827,13 @@ static int arm_smmu_insert_master(struct arm_smmu_device *smmu,
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
2.45.2

