Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2069.outbound.protection.outlook.com [40.107.92.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D5CC25BF18;
	Mon, 30 Jun 2025 15:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751295846; cv=fail; b=o62NLRVI5VGG/O0VQsa4y2oU3f79C0j1qEVIwC0X6aeH5eZbxusflyBxgvQIJ9Rgdwkxgq3cv1m8Baoz4omIBkSaxLoFXkon6FUjciGPRDk8PbXEVm0IW8SR2ZR0YZhokdw/xAITLCqoBFyjA9FvYivOIwyETqfOMeyp0qiQhCc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751295846; c=relaxed/simple;
	bh=T6TaK1tBCy4kIlL1vAzYYdA2/oLGPgNPMEyQ463MLvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=i2v7K0Yisa53R0q6BTImX8Cniiz9gtIRCHzRB6/WUmOX0PyUaHxzOkMlCN4AcGXDY1OCSqAdNU0+oDVQghKe03cjyZ/uwXLdsnzOpivIesgBSAEjl2iJHb8vhOgcgcQOKLRo0D629oUXXChhy0br7vhmVC8roaQMH8qWDew3+Xs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=e81gfsQi; arc=fail smtp.client-ip=40.107.92.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="e81gfsQi"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bAhQzas9jKvxtWk7tzSOuXWWxlXpCcYFBdwV2VITaDjrx+KMp+yDrC+MhsgpOsxoiOzoP3O8dKCcbKmLEW+QhAckr/b+r2nYYVrxZbKn+kCgASeqyX5pxDjWpBsWQkOtyahq2IDFdRaKrGUaLdm2Is+ydZX0P2VaEsbOW2A7Y1eX7fGG2jV6GtXu3iw5iuNIJKMUWuXEhFWBAkkdYt+Tn/AEpRRywZCzocEmBVcphtO1pmLLXTgq8p1+Lcv+yAQO+pEDe1VRnyqy8DZsRLroDrrXM5URuTSoyjS7vVMTy/yHgAunGpe+PkYW/eMFgHCC7qVtbpCjA5JrJacJGFS4GA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RUP9r2is3dNJ/E8xjsExWsZ7yPY01voRAe5Nv0dGOuI=;
 b=ZiPwEopCHNbLKu3IuGugdEBxNeGJvkhM2+zuF1dYjqyhIIdk17VfL5jC6s12bIF+Si4KAPfnmuccDZZ3IyMXLPue70sugKq1m1LtMWmQ+YBBneupSGgKgh/qMhj/L2+KGEcIM8NyCjYzBTamACngZiqSNMnrmbj+kwDQlbxo8eS5bcGitFzq5TyMPG12D/xQr0mVo8xV0HAHqESSCAgLpLZ+thu5otq4dsNRbA26mGuBrczZ5jHqnyGQe8bkz/O9ulZb+Xd7xCY4O9u7S135sBPawKnDa8KIY/i7vg7pcK/eGC0mrkVN950JTDKoITu8HjVfcn4Dazuzl7SsBY0j1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RUP9r2is3dNJ/E8xjsExWsZ7yPY01voRAe5Nv0dGOuI=;
 b=e81gfsQi0tirUL4Mx9b+DdCI92A6Si0glbOvyVqbQmaCJFGMco0d8fE2ulqreRHQCCUIQqIp2+SBzRrA0ncAWZIz7PAZc/hqIJ8ZvgIIkk7AI24ClIGIAtMDnQY9C9CLu+3PKbEbdH03uU5lBK4WTanmtC2CpoIh08Ig+zXBDLq31JvWvzk5HHeaJjdueybrBdzdZC37ePu37wkZ2TKIjdCwekCjwKOLcv4v5mFRNRePjW0L8cinOdx3vddJqj8XYdFJr/QxQGLRZAseyiWHF/yUdjAeBUYS3Hz3STtBlo/2x3G8fHuTmVg0QqUZgtCew84kETw9DQp4HjTCwtVUUg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by LV8PR12MB9643.namprd12.prod.outlook.com (2603:10b6:408:297::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.17; Mon, 30 Jun
 2025 15:04:01 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8880.030; Mon, 30 Jun 2025
 15:04:01 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Kevin Tian <kevin.tian@intel.com>,
	patches@lists.linux.dev,
	Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH v3 3/7] iommu/vt-d: Do not wipe out the page table NID when devices detach
Date: Mon, 30 Jun 2025 12:03:53 -0300
Message-ID: <3-v3-dbbe6f7e7ae3+124ffe-vtd_prep_jgg@nvidia.com>
In-Reply-To: <0-v3-dbbe6f7e7ae3+124ffe-vtd_prep_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0130.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::15) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|LV8PR12MB9643:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d8090d8-c003-4ed6-45be-08ddb7e75795
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?nqNK6VjYi7yBAxjTy8OWSgb9mlVQ5cHlkIKKCSZEY4OV2nnvnSQIz4G2m6BM?=
 =?us-ascii?Q?2BIL0s1pqTEsF+5vLeehbxWCgzzcSDfvOwXU43FlQlDTh1LsH8jhEEXUri7p?=
 =?us-ascii?Q?uoo2TjUNEdEdIymlCLyVrz5CLpZsXmdme7NqccZJvAP4S/Z0B+BAqFw+ZFZ0?=
 =?us-ascii?Q?FPpCvy3t/qFQAZUds92+ywmOPP0blC/RaES2p0ybevuSEK3GLHCwvXK053x2?=
 =?us-ascii?Q?aTgAvBfFPLJfFRHuZpqoh3G3t58AZDPLpwfQtCM4gR7ow9u+MaZZrRz3V7N7?=
 =?us-ascii?Q?9IRaWiUr/Epbex9XRQuw1qDuHfDv2g2GCydTQSlZymaNYROD2oi/ZLQYY2Y+?=
 =?us-ascii?Q?uEsBqScXofrOgScy2ghPwgDEB1/3t/Ormc67YblmhtsPsmcG6XCNYcjjYJ5f?=
 =?us-ascii?Q?R+TXpPfy1UNlyUIss737i0J18WVPyoIj9YV4ngE2vNzMt926mm4BtXuyXO7P?=
 =?us-ascii?Q?29EEV4KfHp4radZmsQPnxxT76It+9h2QOT5hr75zP9e5uMePYUVHizhJK5VD?=
 =?us-ascii?Q?pE49YE4X0aTf/LUkJTYu6CQyfMQSMMcjxJq/Zv71yyp/md7wLsZFSfLBkKwI?=
 =?us-ascii?Q?LjEIIFay9DwdhU5jSRKrDxRezEyiIFoB29nncdsQuOsRG2lFnEkpUhGOK+4O?=
 =?us-ascii?Q?zhUL68bLK187tZH4klE1309Yr9FeFsYvS1hRSc940HJeQkb2jWqzyNnRjVri?=
 =?us-ascii?Q?qEp03SKdgL7o2Jt0I77vVzgZMgmTcrPiBONaygRyzBcRrO7WrU3OKZoRH2UW?=
 =?us-ascii?Q?XAuh4z5xKzbUP8Nwzcz+TQzTtIYfUgJwSDx0rb80R3wP5ksn2Z5g24sMDEIV?=
 =?us-ascii?Q?ia82D4qew7BSAFWSw5K95x+wsOEBCm2S92qWb3TmxA3Abak//Hl0P+7qBkAD?=
 =?us-ascii?Q?OwPYm38SC0ub5wDETvVr17g7hAXezavW1fgVU5ZF54MtFXj4GMmuQ1jk2R19?=
 =?us-ascii?Q?OdLsWDjtFqBzm+F/GWgg76juwHtg0hujZRQxJGRB6LhK4jb9aB8fSwNEzW8Y?=
 =?us-ascii?Q?Fo9YncWeLPIVD1x8lhx2EFz/EQA1SJ1FOcFXw+MImjqJKAdwVaB2cTBnyKrj?=
 =?us-ascii?Q?gd3sgpwInBjuZWT7IHm8IXQfz8jumAW0HmeC5vZ7Xv8UeNhgZqbDAAgQdlds?=
 =?us-ascii?Q?vvahJHA+TnomxGmEJl+3Z8cwdMtBnvqxqEGy80Bd38WH76m9L3y7t+jesvre?=
 =?us-ascii?Q?369HPdJ+dWjB4ecUEtb0DL3+uSlRXTKj/SdTJS6NpnMPANd5eTt8ARxQryPl?=
 =?us-ascii?Q?3nApUXw64FPUVwseJ5m2YQqfsIspwFLzbff5nwxOZo8BWVVuSE3w6YT7pj6g?=
 =?us-ascii?Q?FqBE9ju3GN5rWf3Gt7w3GmDMNIi6BHaXDsHYA9ERS+sqHsmWMDjKXEBRoWtW?=
 =?us-ascii?Q?P6HvQ9cT3kciu9QTNNVjGjai2x6Mw4oQ64BqWsCtO868T3VDK8v2dmj9K55w?=
 =?us-ascii?Q?Y9Zd9VjKTnM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jbrLh6FL/hNRPemKosVwcKEd7+Z4oryc5jsHynS9Chy0SSX2e6E5o5DmAAoQ?=
 =?us-ascii?Q?0Y9G4DGuiMbGQ6jsSMSG6upwT8EVxroGgF1hhrV2X3dNfyhgLxzgywqskgpz?=
 =?us-ascii?Q?KM3jKGNKEjyYlZvAHOMGtr/MydtNCLAglCRnk3xosn7OgHubfc2ANCtc7daT?=
 =?us-ascii?Q?QPSWWTgQfw2cjCB5tLcIvODAICvUE/ynG/fNRu88tZwUFl0oUwk+R/hta0Wb?=
 =?us-ascii?Q?YRdZoyKvJ0TgZARMdYFn6R3QKkcqPMYtoH2UjyixbYE64OIdfnLMMJ6h/RXU?=
 =?us-ascii?Q?nRa8qEi/5K/Gt8gVVfVVPijEW++evbvXzMN+Q95GbTsJoFLIWwhHsNf4ZFWR?=
 =?us-ascii?Q?5KZXEjjQMc9vgSanmoDc70qYYMOldNkudwBGc2sgp+ru/3Yefb/zp3liGCMv?=
 =?us-ascii?Q?ssfb6h+4tiCXn7XUXq71z3dJCPfMEyPZdglRnbcv7eSJSMpvFyNgrSis8rn7?=
 =?us-ascii?Q?zkz0Winj/+3xU4wT6VSMhFyLr3UWlSt4qLh0ChNVB+QKl8UdRpRTm4qDfvlV?=
 =?us-ascii?Q?vYYajOyoYrboy8Gj+anb4eCql4HLl5aG6DsIGwTZKOtO5VF0KQbm9I7+dLpm?=
 =?us-ascii?Q?/8DcYyANbsI5sQBWqH9vaV/i6ESWszOqKvBAiQFlOktoIUPQCTYgHMBiCYSq?=
 =?us-ascii?Q?ib2g9/a/iHcmv0A/1cuL865T5QJczAtplpwOoWXCF1nhBS4hYU4/FYvz9oTP?=
 =?us-ascii?Q?ullRJXXj/8Ma3F6G4gUNyYhJwSu8sml1jqx/5KaSk09ptufEojg7l0TC4wrh?=
 =?us-ascii?Q?/EgyaEfQscFop37vqAqxhPJdNCfNG4qzbU3RhGTdaELKfI5rNl5mbgxLZNnN?=
 =?us-ascii?Q?ylRZChcOtMmK8oLdcn2TDkg/LAkgya6/b2+0EOyUV2hl+Kdua+fDWq4ax7J2?=
 =?us-ascii?Q?gapp5jn2oKYrfKZJnvn+RdsEPUz2rOE2XE/iDzbvyhFdnFIGHoJ6uKY9Ap1H?=
 =?us-ascii?Q?tm1CrcdSCtTqMuKnZ3Rn863jaUhNtDXO9sUpnKWXykMW1e/42S4QxZsS+WXO?=
 =?us-ascii?Q?IkAw614WcbynYBlhYLGwF5w2/c3bcv1hwUJuX0gW8x7keHPZ9DaSnxPhBhdp?=
 =?us-ascii?Q?G1GqhONTpjjWeZ7IsZ1x6kb77S+EPTRJgqaRQDawD3iBQjMKn2tz5GUhrFj8?=
 =?us-ascii?Q?EVpstKoz2rmAkr3OnBOudK9M2TCOFoJvBS4K2ehVl0lQjIk3MhM43nblmZgu?=
 =?us-ascii?Q?m82+A0AfHL00TIsDpiQkk+gLJwGYHD1h4rCl0t62CFPj/G5RPJ0SFHsmI002?=
 =?us-ascii?Q?8jMF6uviinO/nXCs+BJv8/6vYQCHdxj0wZsyFkxDB5pkj/3avzYh+M4vdkNv?=
 =?us-ascii?Q?D6TzWPv9lEvMJRr4rXymKuYTIff5fETfAAW+3vja3jpGO2kTc6UGB1U42qRF?=
 =?us-ascii?Q?pFZxNpyrA5VBzTSeRN+7nwUOJurNUO4FN1OuX/cX+04D57MlFHkHoDnjRQZI?=
 =?us-ascii?Q?a6lunM3m9oyDUbSmoXP4zSV+UsbYxchWJ9/t9YbI05KKVvfXte2Fn6JZ9k2U?=
 =?us-ascii?Q?5o2kj+8VQjN9QcJdhFVms64f8VY64X5aruAuz6ZfkGQgnad17MBin/oau87B?=
 =?us-ascii?Q?UGsEYYO8Xb5dMDBuh35KYvzJLYHEhluy3dUgXSE3?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d8090d8-c003-4ed6-45be-08ddb7e75795
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2025 15:03:59.6103
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NI/+hXsdNe8+2DcE2FIymfG7DCLK2yZ84IonafpCKKsQv0YPIL5agLNK3IgZrW+f
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9643

The NID is used to control which NUMA node memory for the page table is
allocated it from. It should be a permanent property of the page table
when it was allocated and not change during attach/detach of devices.

Reviewed-by: Wei Wang <wei.w.wang@intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/intel/iommu.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 7119f4be1b1393..00079c3e49f078 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -1391,7 +1391,6 @@ void domain_detach_iommu(struct dmar_domain *domain, struct intel_iommu *iommu)
 	if (--info->refcnt == 0) {
 		ida_free(&iommu->domain_ida, info->did);
 		xa_erase(&domain->iommu_array, iommu->seq_id);
-		domain->nid = NUMA_NO_NODE;
 		kfree(info);
 	}
 }
-- 
2.43.0

