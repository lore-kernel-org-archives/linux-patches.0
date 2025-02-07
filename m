Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2087.outbound.protection.outlook.com [40.107.220.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 615053DAC04;
	Fri,  7 Feb 2025 14:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738939577; cv=fail; b=rSCXS9QsStAi/Xq4VF1gCCTb+x2jLVn0Kw+Xg4/EyUVeANdprLru2aUmNkKJzjDFb3EZ3o5fjKgSOoDLpc88r+xhZWceu+jca4U6RBIrT8ZzdxhrODMYRMyThP/jjOOvqz26ucCRMpbAL9Lm+LTeryufPlwr2uWPgnZJqvW4jyk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738939577; c=relaxed/simple;
	bh=tEMW0gncoRPq7KJuxZjnrQ12NIwyXFkjCGV/s0b6EwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HNS8iu6V9UCrZeSh1Gr5tmqjHQtIpWYGU+qMydTLOwBqVCY5TwhSgVM9+69iDe0GXMPzQYs5zUkkIOuVvMWTNTfV90hmIgndztF6DSI6xQWLJx3BFuV2Tz9cSTpzj8y2/brBH+Md7TTwYHaaOYRjjeDprUl3VYjmvcDWz3jIgGo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=eglXdkKw; arc=fail smtp.client-ip=40.107.220.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="eglXdkKw"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tp5PjZxcN31JuyICRpzvdJVq7u2qDSIvR7tR+3T5GwgaoAxTypNmHdP8r0wVD3i+SYBDdx3ByCFo/etEHQVKFInVibDF0RajjTeX+T0ctDUk+50aXiFs6G473KW1nHVY7Z8/UoQEsC4vyqeBcm/I5CxhF/Kse4trE9hzqmjU1AmHBZnFv5GiW9iBdGj1RvNWkEIR9GwUqBkUYJ1PHk96J5Qt9ImQwQWyDDFIuz8jwbaTkEM9z9DrvToTZujC9KPO9hlCl39UPpzKiHFZq4Sw47xzP1R9J0s5L7MoUjMgm73j+Bv4/CCMZc9L1dlPs73rVHKs04J0+BxGdNMRy5GWFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pavGPDksNveDZZrz7m1pCDGCooo6ysoQEC6JratOmhg=;
 b=YyC9mizNAo/EdmGguKwxTuCLXUsJxi9mhZ3rGd9uFdfE2ULuUCx5bGjzccbDoVSfwDtpmuGZ82MGjDKZQbNCgHlHeM7EBCwdPujRYEEdzbA0PETWBzGZ65W+jBZH66hCTnywX3fPDCoVujgI9XYvlHWIfV5s9O0rWqGRM8BdHhWgAS/5joSNNRGppVNgjZ3Lc9sbelyFAR61/Dcy5SSzsv1pIrhbOt0pCNDbgBV/sOefwxmKl/y32GeaQBWrWzEuGyBBQt3ALtMu2eWJxUis4dR+aPJjki/7+mjBJN273EgfTQPWb1e8LBrdG0Zu9sPLGdYaa3DUMmqDBZrzhyC7CA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pavGPDksNveDZZrz7m1pCDGCooo6ysoQEC6JratOmhg=;
 b=eglXdkKwz8h3ITBgJFZLSOwcQsoXZshmEmyo0insXil29JtCXwmnYoGKnwUAEXcyV3zYmD5H5AXBkpVdvrvJ2P3trgoPCsjWGac2FuUqVXLA41ePzEpRkx9M66l85QhPQMmwVHvsZcTXTawuBbwt3CrbyAlJPYYDO9a95ng9i0EHozz99XQMAiPAgXJxHd6zRMRYZ+3l8Td3kXy7f30XqOXtGlUK1o+C7PAQ8acSq5LwY/uSdph5Yb4gaBw2xHhTfQLIct5lLgsMCrjScuz5xP3h+Q/lRD1Zf9A9EFjkPfHL05Y0iw7cU3yGSAlyX/7XVUUDvCMFT72n4zjq7zCYRw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by MW4PR12MB7029.namprd12.prod.outlook.com (2603:10b6:303:1eb::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.14; Fri, 7 Feb
 2025 14:46:08 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8422.011; Fri, 7 Feb 2025
 14:46:08 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	virtualization@lists.linux.dev,
	Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
	patches@lists.linux.dev
Subject: [PATCH 4/5] iommu: Do not call domain_alloc() in iommu_sva_domain_alloc()
Date: Fri,  7 Feb 2025 10:46:04 -0400
Message-ID: <4-v1-91eed9c8014a+53a37-iommu_virtio_domains_jgg@nvidia.com>
In-Reply-To: <0-v1-91eed9c8014a+53a37-iommu_virtio_domains_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN8PR15CA0022.namprd15.prod.outlook.com
 (2603:10b6:408:c0::35) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|MW4PR12MB7029:EE_
X-MS-Office365-Filtering-Correlation-Id: dfbd9c2e-52db-47af-fa59-08dd47862762
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FDU9e1SuwyzgUs4LLpP8e60vKnZ8/OVYIdTBIQtTZJ44v0jw8iXMZBMgNdr4?=
 =?us-ascii?Q?KkaZwhAlASjdL72BT04AgOU15pEQWui6HTNbc2hMNbV5Jl8dhclR9S39AkOu?=
 =?us-ascii?Q?M0RtBo6nfhO7Dgq+piGHyrfPzLvZEnitwQnAnl2RwEP2EG7XOF74jaQGVEGW?=
 =?us-ascii?Q?FC/zBwdHScIytu95hE3pQk79AJW0i24+2kOmY86vUHecABHR2OXd2dxlm6UG?=
 =?us-ascii?Q?gh4/fFvOBjzj8FPKnsYU5znuSmzyZB+6GguRRFlqmfUvS626fK95uaLPFQEQ?=
 =?us-ascii?Q?fSq83XNOU6QAp7wg8+bCPM0p5BtQ5R5wYgU3Esivg0tZW4EkIB2rzn1MyoQt?=
 =?us-ascii?Q?E1vqrIymJM5UloXIYp0k3Jt28oVtV2qLVC+PhP7wwe+vtPyaTrASKbvKtakY?=
 =?us-ascii?Q?5nWhVF+pTrPiHrGwPk+dfyOVzqLRi/y7iQoJBPuuZM6Lb8KpvkBmk5VgC0RC?=
 =?us-ascii?Q?plzJaGUcotaRTCXoYIEBzEs0YIdWYjvg4ypTurP7/2OGgyXeaGZ4kRihtYlY?=
 =?us-ascii?Q?/oroGNLcxxUpe3Prg40Ubc482mJIs6oOKK4ELidNkJPYMOsW9mtjlu+miJhI?=
 =?us-ascii?Q?qRVH96TWrozGPjQV328kDfDQcM/ZDvjWOlu518L7lh6cDZuXg7Ps9/MbmX3n?=
 =?us-ascii?Q?GMfLmI9C2F9nyQodDpzIaH8hAc1SFF2scIVajuXrC2K13yCQ3RGL8gHxCpCu?=
 =?us-ascii?Q?+fixZwXMR8HcjflGD8i7kLrLddpKjeA9qQg7BfSFocbHIJIvGmFTCJSe/DuC?=
 =?us-ascii?Q?lL1AvHnMZHr9XyFvhqDsn3EqFZ3bTXZoRZkg87OL2q/TNGrMoh7jHW8yokoR?=
 =?us-ascii?Q?261SS2dIESWQf9UUUMRSNgf8mYJy+B5rhFeazHUtxN1CqZ7leNgqoYH3eRbr?=
 =?us-ascii?Q?TZ6ZCRfr0u6kJgetV4aXx6MV0HIkC0JOUyylFUSGnqM/HZ4MJ2lTxCV3jKFx?=
 =?us-ascii?Q?8c/feGJBuogvqiIo52193eBkp1TBgovLA83hfFixVAy0wxwYqS+4PmktvGQf?=
 =?us-ascii?Q?i5i72YCz+ml8LJHQ6JUi58uabnsLlImtYH9rYzVL6VoEyCPntsK02aeywvQ4?=
 =?us-ascii?Q?epxrQ/WtpFhGRHhnUvtqtzsGOirF0+sQ4E/lTQ21cw1XMl/0bCphNWPo7lQt?=
 =?us-ascii?Q?WfJn2mfeoCghSDcqEXSvNt6K0XuyGRg0WZRfoEWFoMX+D09+JkVtkgYfmqj1?=
 =?us-ascii?Q?k57tOWewQ0lRPRjwJXCf8wa4LmBXFa3SCiFcWzoiH/qD8vsdqpMOMN85aDsY?=
 =?us-ascii?Q?S7tAiSbWNpmQR5+vVsNkIg2su5oQffrvNujkPwNib4BGwBNB+xldm/N1hhkO?=
 =?us-ascii?Q?axosAOQiDpWgpht7o/QoeJXO7e/whKvEVAIcy90m1qJlBCgyxV4sfv7Atgx0?=
 =?us-ascii?Q?EDRQvg18Qu1JdKWeOPiaZtk0fhFS?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?uWhap/+m/iL4FaDyA+A3bseABK4qWefF3xypvk472yu7jG/1TznDg9ZQGMUi?=
 =?us-ascii?Q?Mcgb6iSSSm6D3Uui3tqDD/wSVWKob8ABLMNXJFpAI1LkxydKyaMsPEi75Iux?=
 =?us-ascii?Q?WVTYtWNvR32JRTTeyV1MzNUZGfN7o8SRxvyi5mOhR2PWJB3nCFZJ07DV5AFw?=
 =?us-ascii?Q?w/pj4uj5xsydE4/9hhh77SuGfBeiz7HNfmOLkfuhrTB2Ai2RzIjX69jjNpks?=
 =?us-ascii?Q?t5NaHopkaDxVzd5HhAFGeAGCYVxsk3Kvz0iW5cq7PQ6jgmaLPBBZl3BmVu/C?=
 =?us-ascii?Q?W1Z6JhD0ob2lh3dlBl+L1XQLukAqnjEqOoUC10b/w9wULz416JN7qMK0/k6H?=
 =?us-ascii?Q?6h0Botz88WySFSPHIEXOT7JiT3/RjEQ/WZ+nHyMxs1FWtG7+RLhEbf0NcMvz?=
 =?us-ascii?Q?z/Ip/AN9ekrKYIRHlbKaLTonLFVe9zCij2oYVsZDHTOHSLvviDd5ry3qYszt?=
 =?us-ascii?Q?8GJ6yV6Wnhp8tZpED39ceC7jIlpZM5L+8SdrP1QncMPlN/UKV00G/vOnDTyN?=
 =?us-ascii?Q?RKyIL+10+VFiqjrUlnkzKDXtvuKN6bB/nfJkodwVpmGmSuL/QmLWNUEWtnMz?=
 =?us-ascii?Q?N8/JvBwFyWiTUfkmNCVaEaV4r2MRqMLC6kSvQm2pQ3AonUK1fBHVVV76dwCu?=
 =?us-ascii?Q?khj5+BdOBRpjn3/BYfeS4s8kp3cAuvS3cYwUvxph7D/j3n+D5FVAyggHiwb+?=
 =?us-ascii?Q?4PxmJihT//nZHJMe0CPDL3KdJHiID41igOjcatXIzRtzOz5ySNAeApnnKzWH?=
 =?us-ascii?Q?dhsaW1rci+6gQmBy885FMel6Id+OG2fLy9nfy/vhZ5cN81IK7IWyjMHyp6Dy?=
 =?us-ascii?Q?h5TuSed2SvP+U8i0jFcoctelmm+wqcNs2VFxdw5lSgRGtoGpIZ+83cWbB6HA?=
 =?us-ascii?Q?EnyhI0Fcm2CjJ3G9wUiLKbLYQlxTLLf3KcjiaSsvHNEti1ALZQxUAPpwqfhz?=
 =?us-ascii?Q?VJDSjUO8MbRU1MjnoLiVj267VZ3m4jtTvdjfeIX91cuByRWvrAxcxDHZLfsu?=
 =?us-ascii?Q?NBr5nmsRNd76lSZZ+TTjd8DzoHGYcYpsA40b7rjtLilZTdLJi8WXI7enTGlF?=
 =?us-ascii?Q?JM28G00TnvbJ9KDQnb/APrcPlyDfeqfIvRXCraXSHYGqzSj1EmOgDZF0JdJ/?=
 =?us-ascii?Q?9uZ8pwcSmztWqf8mJDfrugWC0DxxpwjrvdnMCMdzAIpB1w4wzCkCDpOpsSCj?=
 =?us-ascii?Q?2M3dG79dLt0HyxEdcUbrx+cbfkLFFxZvL9qSJ6PZjWkly8OiUAQwcox26YTT?=
 =?us-ascii?Q?hwCX68Nl/r8LkD44cxbs/Ip4H4DAtnL9sr9ez30gscyUzzdPh+B4dtI9Sitr?=
 =?us-ascii?Q?NXKtpnsapGMSDAhQERHqExBKJeZCpUz6GFxbMsHEiRJGK0cJbpxK3Ao5f+iW?=
 =?us-ascii?Q?if2xlGMTWjm4XjwH7vY6AfkAFKp8P+lOJ07q0yD0WF09MiHY2chvN2TYhVey?=
 =?us-ascii?Q?FEAazz0safYvvwqY8IV/23yiaWeMqA1uIXPzBmVIajI2OpY+o7oZo72bSNuC?=
 =?us-ascii?Q?3B3jWF2ymBWgTUJ2DjGDfj9gPcUr8IXbJl6tTN2Hikvd6Zb+cjfZvHEZCLuQ?=
 =?us-ascii?Q?6GuaCkoDiD+A4MvMK/BiB/b55DRQvlVAJRtxSvCk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dfbd9c2e-52db-47af-fa59-08dd47862762
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2025 14:46:06.9568
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CLtWJHbAEvMazszD6w8kJcMhOZ9QEP2C8pipTJcpV8kvGSYp1AcATJ684sfMfjaN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7029

No driver implements SVA under domain_alloc() anymore, this is dead
code.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommu-sva.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/iommu/iommu-sva.c b/drivers/iommu/iommu-sva.c
index 503c5d23c1ea27..b1cd32e665b61c 100644
--- a/drivers/iommu/iommu-sva.c
+++ b/drivers/iommu/iommu-sva.c
@@ -299,15 +299,12 @@ static struct iommu_domain *iommu_sva_domain_alloc(struct device *dev,
 	const struct iommu_ops *ops = dev_iommu_ops(dev);
 	struct iommu_domain *domain;
 
-	if (ops->domain_alloc_sva) {
-		domain = ops->domain_alloc_sva(dev, mm);
-		if (IS_ERR(domain))
-			return domain;
-	} else {
-		domain = ops->domain_alloc(IOMMU_DOMAIN_SVA);
-		if (!domain)
-			return ERR_PTR(-ENOMEM);
-	}
+	if (!ops->domain_alloc_sva)
+		return ERR_PTR(-EOPNOTSUPP);
+
+	domain = ops->domain_alloc_sva(dev, mm);
+	if (IS_ERR(domain))
+		return domain;
 
 	domain->type = IOMMU_DOMAIN_SVA;
 	mmgrab(mm);
-- 
2.43.0

