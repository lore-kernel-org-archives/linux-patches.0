Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012027.outbound.protection.outlook.com [40.93.195.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E94B533E356;
	Tue,  4 Nov 2025 19:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.27
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762282866; cv=fail; b=n/T8aglEBgJDmh6sXvTMOShHbrwBQwKK5ZwId0UScu9mGAjDq+vm0+yC0fFTk9dQfBi5qj0Je4ZGrdZTgDKp0EfK3iToiJWF0ByGQGxwAQab6P1zg16LrAzuVvM3a2hVZLtWkmDRWNNFOTeUE63xzSk2uUav0CkhG/DT+F0JOd0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762282866; c=relaxed/simple;
	bh=dFqzdQK5EUxZfOTpTxI0DTak3MYrCPnkhis+SK095wI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KSDC95vScXEpPlPNJCt7PWsrsI/5nQveGxC2+qUAfFWFnd3m1Liru0caIvqG8k9REtGB9nPzGH6slpAbQyoQ3KYbkil3CU3l4PcPfMMsTA2ghFOWTeKfZzMYosDGTTqnrtd7/0JoL5JkFK5GT5vHUNzTpcisYmbWscew0GkM4mc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=sYYmPc3+; arc=fail smtp.client-ip=40.93.195.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="sYYmPc3+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=giTpZEh+wfjuqibzgbPW5clumft2jHtvbr0rNGM5IJmeKDGQ/matCsQdMRjBn7ebp7q2JuTAfryIQxhsGh+yViB8XhLWBJKGQiq9XwHHeK8Xla6aJhQA1tU2zqasOSmc6qtci7wJLiDdDpMIr2fDk/qJ9VGceAfbeQrViWgDerUKmY5Q3WPH5CXNIbODW/mW6IH8+wNzLWUcFxryofWJcDi49eZJ3eDGmE4T/1T2xKQ0Vi3qQka8QzitDjJuUXwAE1R7aeJscWnn7NBTY4n6Gk0Jtp70IDmzbOn4XbSLRqgqclxd9QzW/amIqeqHHlZWAi+0MqceNea74mgU7dcjZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TbuaTkV6fGzsyCu0VssFd3iB+xPzFeN7pE8YGL65phc=;
 b=gCh6DfogV59Cj5b8cfV30u2tcxmGAn4C0HGYZiIH4gx1Lu7LlMpD8MgDqtx5NNC1OiNhG0AYCZsHwwOa0LwJCZJfcz/Sbn4bUKRzAnB1VRKDjJOCY3gRdj/4n9abXHcyTtrdayv92MNbUjg3z4+NSChHAUUVUBn1G7oSfJ7nGaGmyr7f02cbHvUpV6RSYUoYzCiEs1gn8L6S4ARtsmlUq0nb5IYNVd2AI30AsMd/7xUJs7uy1g5aRGhDXU6GkHgfDrdWFBy/mIrq2GyMNSBiHuFHhpwl/+RO+1HebyZHBmcRSj+/cjF5HpTJ6W66R/fSeT0CjIv1mo3OslhIoP4scw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TbuaTkV6fGzsyCu0VssFd3iB+xPzFeN7pE8YGL65phc=;
 b=sYYmPc3+HiaEDWagX4vxWXiVw3HYifgKBL7z8pxzcb9i+yYxgNQqekfP7ohlLMgfXXXhJEM+iCojr6wGCIjHClIQOfmfyBY8r9O0TqwvIvOH8C1Bfc4o4Y7RwxW/FWdwHWGpDBrYUdO7wiwBfNKB3yIhPwHR2qi9uWGFBHT3ju8RcvN/ZitGK0I985ZkUbxrV8tm8g4izNhgQlQF6CP9lYvj2YMHxhb7wPQWBO+fCBGE6xQynA+5bd71nSyao7IdGUbvt8liym7rhRZCatRJWQ8aI6XZE5QKqNbBcKRqM9SHR+rlPXdJiy6IrVTxz/tiQCYxcIAi9kFpZ03E5QU7xA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB3613.namprd12.prod.outlook.com (2603:10b6:208:c1::17)
 by MW6PR12MB7071.namprd12.prod.outlook.com (2603:10b6:303:238::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.8; Tue, 4 Nov
 2025 19:00:48 +0000
Received: from MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b]) by MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b%4]) with mapi id 15.20.9298.006; Tue, 4 Nov 2025
 19:00:47 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alexandre Ghiti <alex@ghiti.fr>,
	Albert Ou <aou@eecs.berkeley.edu>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-riscv@lists.infradead.org,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Tomasz Jeznach <tjeznach@rivosinc.com>,
	Will Deacon <will@kernel.org>
Cc: lihangjing@bytedance.com,
	Xu Lu <luxu.kernel@bytedance.com>,
	patches@lists.linux.dev,
	xieyongji@bytedance.com
Subject: [PATCH 4/5] iommu/riscv: Enable SVNAPOT support for contiguous ptes
Date: Tue,  4 Nov 2025 15:00:43 -0400
Message-ID: <4-v1-d3317b0ee398+50-iommu_pt_riscv_jgg@nvidia.com>
In-Reply-To: <0-v1-d3317b0ee398+50-iommu_pt_riscv_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0324.namprd03.prod.outlook.com
 (2603:10b6:408:112::29) To MN2PR12MB3613.namprd12.prod.outlook.com
 (2603:10b6:208:c1::17)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB3613:EE_|MW6PR12MB7071:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d0d9ce5-16dd-40aa-dd66-08de1bd4762f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mH4sU1dToeA3lQhXlI6u1Th2DcTZXI00W1CqOvBnf0z95URkDMN9GUZSIErQ?=
 =?us-ascii?Q?G4MHVnyEqnyqoqX2e/0BK+HpVZYNAhqiva3Isx0DGVrDPdy6e/X3y3HUbS4G?=
 =?us-ascii?Q?obDNxhDH+zbwi8vcG/Zno6cVRRgGE5MEKbFzrcpACNXQtPHF54Q2auE8npsQ?=
 =?us-ascii?Q?+P9r+DF6kj2vuDbCBKYZ5/aDna/3ex3jDuXNo55QcXeE8yJrgHHJHS4jXgrZ?=
 =?us-ascii?Q?nGmIbya5+zAY1NrdQIhyk7Y9p4X4hIfb0NvMQz4Ij3jJmLTfUzDKGSn7XYcv?=
 =?us-ascii?Q?VCpBUzUm9Aqlx+z7x28yhblnVCQ6M1/cX1dwlUP1FxKQjBi3KyJNt8v51eRu?=
 =?us-ascii?Q?6/cX8OQ1t+/bw8Xx8ufd53JP2u0ROo23m+SdUdZp8Oqty+pJqCP3iPYtoRAU?=
 =?us-ascii?Q?3s4UiEn8KUNqaPp+ak7cf5kA2zaRhHhgdimxn9E6fdljOjsGoasSrH19XztF?=
 =?us-ascii?Q?yaWlEgWPTNk7rbFEe6rcy3eGRa+sUXA7gFowiK7uHEGHLFWeemT25lI7d6uI?=
 =?us-ascii?Q?pWet/b00ew5ekyouSBx9uskhvzVPPbXAirWCHtncpKnnl1T7EawnTAcNGe3c?=
 =?us-ascii?Q?auQWJ2I/NzisY92GmNL3N56bjuJghv4t3MQS3ndyAULe199q5itmg/TZhUd4?=
 =?us-ascii?Q?b1jc3/84dFh+F/piIgiNYXHkI9nYpiLj3UKOUr9+LBsYRRbu557jdRfRx9xa?=
 =?us-ascii?Q?HcnW8yIs6XmQwuVRuGXN53RaWrHp0GCDS8v+cZofhYyOOFaI9GGGXb+Goivi?=
 =?us-ascii?Q?2VyzlCRWCyQQ4SGCmL8A266cmGXpCu6UnkX+IwRbmeGwtJBxSB/C4mwQGgbR?=
 =?us-ascii?Q?VD2NOgyFfbWDeimxCHzyGyH6iJlYGphxEeZTHEGB4jPxaIQNOSOa7L/ax0om?=
 =?us-ascii?Q?Qcv5gQ3VOftIVI/nXfdujIBvIkOxxCXA5NfblrNGA23JGLHU9wB/nZHA7syl?=
 =?us-ascii?Q?aM2gJIoPqzJie+VHWKw0s0oouTwHdL8JutSg7nQbGotD8yEacEswCYsj5gvd?=
 =?us-ascii?Q?1kz/3v7BzvbyoPMzrdcpx9MP1xlFvoJUyokmOLcHe/D3cpozCCL25x48uXcJ?=
 =?us-ascii?Q?ppk1Di8/UqST2LFa/jDX5To+6dB90cqA9uXI0vsmS4XRyHreQuO8YBDr5RCL?=
 =?us-ascii?Q?GQeB+mHGAyr19J2dfr92/UcQkWmrB7kuheNJ2hV2N6i/8TYhe4pqK7RzH9VK?=
 =?us-ascii?Q?OI6cKGD4RcNSfUxPCtk8fmOOU9khRh302mKz3SkjsSmBAXUKYAZtjsCbqmm6?=
 =?us-ascii?Q?gkpX6ZG1noGi8nffIcRO0s5oRs50ry+w11diccpM9CwBgtA19IVIt8P+noAR?=
 =?us-ascii?Q?+zMbenfDWq6OVmHmISywx/RG8uCRGQDC6TjCMYTMGXUj9PKCI4m2r852oadd?=
 =?us-ascii?Q?vT+gW4g/eLU+zKaiIk9k+48lDKIRs5T5CYZJpQJ9qE003fLk0koXMxyqdOij?=
 =?us-ascii?Q?cNmAi31a90fHa0Tz7eLbjLt+Yk49W/g98Kgyu7AxB9hN4dvankbCDVoNPLI7?=
 =?us-ascii?Q?KVPCpH+Mxnhc4HY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3613.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?UOvPRNM6iDh/TCq/YgPHgYqthQNnyt6Tdi0yiseF3wLRNGSDfpoDg2qOVX4V?=
 =?us-ascii?Q?p8g0yfga64wWPX3gWZPGfGsycFzgJkPeAv6OeP8qOUzCMQ1aiGFcfYiuNWW4?=
 =?us-ascii?Q?somlMFQuWtUgt8MAlnldJsx1u5Zwri5ZW9q7f8uSjmBxc3aqn+pjBN0emuen?=
 =?us-ascii?Q?BU1XfiHu5LN5J0oK8pFsAWr3DTSgu/kdd1qQSUuKgw9xb0clnBehK49IHqC/?=
 =?us-ascii?Q?7IXlJ4w7x9RSAZ33dcbVWG8PDBTI1T2lQBN18NYItWJb9X/tjnnXxapc5cxC?=
 =?us-ascii?Q?evFxt/5jk9pmDn5ms8r3kah3L4Sv93Ccp9YH/+vKpJnudPlQd2ASw2KUb5B7?=
 =?us-ascii?Q?nyz9Xgqn/eVtmjd+twpukeNFXi4cZZKnJFv/XxTPUzBUoUP1ZQKWwScvcBTW?=
 =?us-ascii?Q?ZBOq1nA2av/anLiVCAc0ctO5RRDMugGGCVDBOqIRnSiaQfBZW0MT2Dy1Zzr1?=
 =?us-ascii?Q?26ciIbDKkPdCkMN0fUyixyyoDZhXdojXF13yV1Z8lXOy3/RP4GrQRC7fyvnV?=
 =?us-ascii?Q?If6d01Ydh7JOu6MN0XcyMq6mpajzAN05gFZjuaaJpkEXnhR8iGS+GoSGAikO?=
 =?us-ascii?Q?yGGRFnqwBjbbuuT9SbHH7P5d7X1LFW5aZPmyzYB0078Nwms9Vj4fo35Ksaae?=
 =?us-ascii?Q?SZnwqvGtFBKrtWUDfpTYNmVrLXkhpkuh7EftrpdRdl0u6GLa2fDiu0sYSAlG?=
 =?us-ascii?Q?f23DNuU/KIw/LMOhAjrl309SWOOjvPvChLuq5MKrp5ssDGnUICgtom8h0T0L?=
 =?us-ascii?Q?Z6k6s3MWdThlun/KWTDjkhqWd9lhu44mbrg4UluvUo3rb4UILquJWoKSCkg6?=
 =?us-ascii?Q?6aR8EQzXyl3rBTDLW2+iKA4oqwxZ3Ox94vTQUyw66dsL+nx43ThF/5xWuc/E?=
 =?us-ascii?Q?THhoT9uM6fC/too4M5/I1xv04rVqu9M1OeCpe7nawDgw8YFHEUN9dHhpQzDu?=
 =?us-ascii?Q?VURDjqqE0BHNFhpBpwAs2gczMzfX0NvkZqB3ph6bYwd6kkOorxnHPgZDxYT7?=
 =?us-ascii?Q?Bhfu0llVnVH23CvVFxBbq87dGnUm3i21PlORfEQKaSJljEcW5Etcx36UZe4z?=
 =?us-ascii?Q?cPmpcYdt88aV/GhckzTdIJVaH6vsgTXkkao9WNXLV1u3JXCr4qX4D64vgLEl?=
 =?us-ascii?Q?jGc20qrXGvpS7Y51gJPlR4ipYTBIaUldMteJV6ZwezmTrM3SCm+GyrZMIlKK?=
 =?us-ascii?Q?Z/hIn96XrCpILQzhOoX4r6xNP/Zd8JkpVCt4RcKsFpzdBqizzLO2PShRLUg/?=
 =?us-ascii?Q?yBzNl8tAztP45N5MjdnQ8ACeQESMdonBCfgpfwwH1gT20S1JdboDsW+5GtML?=
 =?us-ascii?Q?y8Q8wi5tLT5F3IKMLEd0egpYIIS4hAxjKb4E6XAaDkDvNTjvXiGq7tLFoQ+0?=
 =?us-ascii?Q?JC3yA1qZCTnQSjkdnS3syGjRHYqxu1VxibOPDRmb8EFuqNAM3n5c4cfhBFv6?=
 =?us-ascii?Q?U4envhjwAeHAuL6xDZPz/Yg4gSkQaMxHQNhyx4FqIS37XVCp7QCU8ox6Xhlc?=
 =?us-ascii?Q?YMV40vHdZQyS85HY4+crTIwoSni6TaT3+bO4f6HtJrbWHs3GEhI9weOgN79e?=
 =?us-ascii?Q?iyC/CeQwoRxSZ0JKpHY=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d0d9ce5-16dd-40aa-dd66-08de1bd4762f
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3613.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2025 19:00:46.4148
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +0RBS0n0fXZnW0SzOss6DLFxo5nAGlOpbi37H7lQv0It5+iS5I+ez3pkKXmNLJNO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB7071

This turns on a 64k page size. The "RISC-V IOMMU Architecture
Specification" states:

  6.4 IOMMU capabilities
  [..]
  IOMMU implementations must support the Svnapot standard extension for
  NAPOT Translation Contiguity.

So just switch it on unconditionally.

Cc: Xu Lu <luxu.kernel@bytedance.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/riscv/iommu.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/riscv/iommu.c b/drivers/iommu/riscv/iommu.c
index 8fe0031f6cb665..014de227e6123f 100644
--- a/drivers/iommu/riscv/iommu.c
+++ b/drivers/iommu/riscv/iommu.c
@@ -1184,8 +1184,13 @@ static struct iommu_domain *riscv_iommu_alloc_paging_domain(struct device *dev)
 
 	INIT_LIST_HEAD_RCU(&domain->bonds);
 	spin_lock_init(&domain->lock);
+	/*
+	 * 6.4 IOMMU capabilities [..] IOMMU implementations must support the
+	 * Svnapot standard extension for NAPOT Translation Contiguity.
+	 */
 	cfg.common.features = BIT(PT_FEAT_SIGN_EXTEND) |
-			      BIT(PT_FEAT_FLUSH_RANGE);
+			      BIT(PT_FEAT_FLUSH_RANGE) |
+			      BIT(PT_FEAT_RSICV_SVNAPOT_64K);
 	domain->riscvpt.iommu.nid = dev_to_node(iommu->dev);
 	domain->domain.ops = &riscv_iommu_paging_domain_ops;
 
-- 
2.43.0

