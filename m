Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2057.outbound.protection.outlook.com [40.107.243.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 598A1380;
	Fri, 30 Aug 2024 00:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724976394; cv=fail; b=cv5v3W41ByuidB8nE+jIs70JF7qrCzRGI3Zrusp2pxy18Rivl51rswoConx7sFqio3+UyWVYerdT0aTyk6Mf/onz9AXw84mpSw639w+uYNaJn7mOoMayG+pYHEPGSDWzyl6SEh9VqpjM3m+70Su1n4qObzSkE/ibOWgHZD1Wcgo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724976394; c=relaxed/simple;
	bh=2Aj7GHBLQQWkiW6m1a2SGihhCGTDiOXtat8ae+l5Fy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=m+q1I6TwPPK1moKYohxS2hUGI84F8lLq2BOsw6rsbBZT3RbjcTnqzL+L9S6FlRs7Fajxra73v9lZ9PmyhdQKZCbdzGX+aJZJW4thsEXTSXglJlR35TGL/JtHkGBHgfWQAa5bWXolOZXoOGsOUk4OLHcE8Cu0kbf24s0TTKWjSS8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=oRpsh+jE; arc=fail smtp.client-ip=40.107.243.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="oRpsh+jE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HpJFrWWZZwGL61sg6iiNlkfe9Pm8rAVSiYi5Qidmuyp5SDdvkT655vz4r+knI3kLVnpPjO7f54MqV/gJuz+ycWvCKZ4KC8y4seuogPO/CtkHk73SCZIjX943U9FIO6U9mjgPrSpz1Bp1EfSydF3Nfh3xjonNPxMxRZXZ0n5yTxoQJo+ki2iQsv/VpCOCpNH1g3ma4JvFzG0F067bjUbhRhp4dfUAay7gTeSM2SKb6JsRubpKc5FkU2DEXG1VkzHMRbnWuHN0XKxAC/r8pz4LsQnhWrgpkpgAmQWM27BwP7MiJqJhiSr49gibky3L5dpJo62CJmk6mv+w4JqkpSV3eQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=69B5bEdQJjNmxbUgdTE4HNoDDQJ4R+TtDnvcCBPJhzk=;
 b=iLDlYvBA5rKFB1B5YVtc+CTIbFXJ6cAmgboWenWCHZeVb7vl49SzfwjZj795Jae4qPdqb7cB2ZvCuysnMMOJ7z7Au9OOKr7kyGsTdXDGCkrurLniYIlfHbS6esWrLiDy186VdG5mxKBYgaxcJ3Vfi1C4RyBPnn28jcN9p0TN3Jaa0lCkvydczoBstl5ITjJQy764xmvzH/9ufW7Nsz674Wjida+LA/6s+meEYT1FSNP7bgf75KD8lqaKKX0zcow4VcIhGZqLxQDFKwZ8/qCGkaDA5Q34fkAPo1krLsVpHRtbwc/7gduJglQoQvWRPPhnoU2Xl0FHTd8qVsU0dvXMJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=69B5bEdQJjNmxbUgdTE4HNoDDQJ4R+TtDnvcCBPJhzk=;
 b=oRpsh+jEKbbDX+FTjJfrbx0uqAGIdlCOaS8Rjb9iqKHB4I4yt2P/6yNdz8P6xFtKNOL498IkuBW0sCCxUgrQyF2n0ayuRwMrXF45pFQRDhDSpahX+5Y6Ms5ti30oNqEUkmEYyiS+7v0scyQ0/cbSqUN0oADHLhaHC1NwJGxcLY42ftn07H4tTt7cZLRtRPYqJMNn0cy0S+x+rVLfEN+3ZHxrKQ5jT2oEZPHH/8mCiaRzf1MQf+vhlp5nARIdZRqUpMicpPR9KjbXm/q8j2t7zJDb0oq0yy0Hq84rHhMBYqd49QZq8EGr6wvYSiCFHKC+ksP0JKh/6Y2DUcaY7h9xIw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by PH8PR12MB8431.namprd12.prod.outlook.com (2603:10b6:510:25a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.28; Fri, 30 Aug
 2024 00:06:28 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7897.027; Fri, 30 Aug 2024
 00:06:27 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	Joerg Roedel <jroedel@suse.de>,
	patches@lists.linux.dev,
	Vasant Hegde <vasant.hegde@amd.com>
Subject: [PATCH v2 08/14] iommu/amd: Store the nid in io_pgtable_cfg instead of the domain
Date: Thu, 29 Aug 2024 21:06:17 -0300
Message-ID: <8-v2-831cdc4d00f3+1a315-amd_iopgtbl_jgg@nvidia.com>
In-Reply-To: <0-v2-831cdc4d00f3+1a315-amd_iopgtbl_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0784.namprd03.prod.outlook.com
 (2603:10b6:408:13f::9) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|PH8PR12MB8431:EE_
X-MS-Office365-Filtering-Correlation-Id: c16c0b73-08a3-408b-57cf-08dcc887961e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1aJYeo9p90Qmrc5ScXs1ECcauajRQ3EREzQbm6Ifkp0LE6lkvLl6VnwtzrFl?=
 =?us-ascii?Q?LNU0igRCViX0C/YPQhB7gkdfIb58JiF4e1y0Ekq6m/bF6gP4rYSUFjUXoUH/?=
 =?us-ascii?Q?Q5Ay2pQU+ZJ8jhjzkSPU3bneDxCADr9nlAZvZoWDl06mk9HGAwzEjjrrpUyf?=
 =?us-ascii?Q?jTNk9AB11e2skBBSw5InW350InDQoRBLRRL/du7eILvcNbBkbrG9NT3eB/Z+?=
 =?us-ascii?Q?HhW1czWzsvwEk+cTVdcp6roNdXyzCgvQNqrpAJRYiNE/0IejN6pEhjSggbPj?=
 =?us-ascii?Q?SANjVOAy0EfNhE74UeZjYD+DykkrnBr8cFSEDP8+bQb8Oa9H5nA3536wYLNd?=
 =?us-ascii?Q?DH8zh12sQ6LHVHxwfykSaMOsiY9dT84vPmQxmUpCLSvs2KLMa81rD4Tsqcma?=
 =?us-ascii?Q?AJ1B5OQMyCyzpmjbWzRlex3ueM98DSpc860+wTSgc2tK2jqRg7OCGlSjODLc?=
 =?us-ascii?Q?NZu6uVVpI84p3H6x+QVmyW3XN6N8I94UGYOqRSCzyrKB6Dvv7Owos+RUy1QX?=
 =?us-ascii?Q?BgtQ1hY2WGnqJoPl3FPWYOuPntgUwsShSoa8MEq8NcPhvknWyoXSyP/ZFpU+?=
 =?us-ascii?Q?6RflejzGAMA1jW0+BLLGMrNVSXn0P81L17W1yT7IWbjPYj1nqp1vvH3VhMvI?=
 =?us-ascii?Q?AN1PuNk7TSDqByoJaeKxmwY+uYOoOLKbaKmc5x/iAqca23d82Pegd7Zes+Bh?=
 =?us-ascii?Q?ffze7q++bPUeGZuqjm42hAsg4tIEkTGx2U704KM1CI8J5UPdcDJFFy32MvN5?=
 =?us-ascii?Q?Rn02IJdmD9+3uRh2wxOAVRiyG/8k9nb/Szk9k05CTxBm29GxCR8GRdIqaGRf?=
 =?us-ascii?Q?4ZvYhvF3pTXpYYtSqh7yk97gqu/LgNRETxOebQ9Jpzf9SJwn5SXx9UoZYN4W?=
 =?us-ascii?Q?VD3GeKxKcXFwtuVREx032SpdECDxuKR8yDThS41wcK1ywWJBWhMrHRUIslzw?=
 =?us-ascii?Q?FA6hBjBbDOBMkofkgP81tju1TKo/+bm+OOObu4eyO6+ZpWJ4RgXyr//IxYI5?=
 =?us-ascii?Q?ZJS4KJBDHLu8xpmuhNjpPIzJoCX0vV9H1iohqkYoOAzbDTvJHZjEn1VBz70K?=
 =?us-ascii?Q?ewwlAqlBWgWMmTAZSUzML53WGqm36TayOtZTAk9tf8jndoe2uceTVKhxATro?=
 =?us-ascii?Q?HftVLUImtEr/HvBIB3oNKoYggM3aRyLpbjW3rzgo84LgsFUZJySDF6uR5wgQ?=
 =?us-ascii?Q?xqs5aEmcS6PPCUYFMXFxNsxX5Q0eOGBvZW5rZRrLXIVUPKn1CMNJmzusNEud?=
 =?us-ascii?Q?MwUc0NeSKO+0wZ1usr1h/Boo9hyJUYumzz8Mpc7OTBJbehBqpPTMooF5tkaP?=
 =?us-ascii?Q?9C3F8/h6MC0wWNKGHhQmyp5p64r6Ri/5nqMBtR7Oj4AZwg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tjnSo8MWuN6hUC6b9f1DCl3vsZuNwLnkMpHlyrvHpOECM0fk6tsGAcHTLM5u?=
 =?us-ascii?Q?oOkYCiSCUQSj2YfPCsBvDOX47llP4VZ0SqIwJ3C9iWLgftmf3s5F1LD1NLxX?=
 =?us-ascii?Q?Gx6UdnawEFByMIed0dY4mOXiBOFXv4+aSyoIKKzD3K4+X+q8dXPSUOAZ9vJP?=
 =?us-ascii?Q?xin/O9dNAUScNDB0Sau4sNsZgZpIDwsrSbKRG4fidHqKB8Opf/vsg/Qu3OcE?=
 =?us-ascii?Q?GDPmYLpBS58fIqGCf4ADGLMI3/L4KKFKvrEMQ1J5+dvR20Qf2z4K7Gh0Wehv?=
 =?us-ascii?Q?X4Zl4GSpxclEOQyxV0HbHVpfj0rXgcR/lvGird4BKSGEdKIMWL0PMHtV36eS?=
 =?us-ascii?Q?7uLidaAJYhPreiewA01UqUf6lL4uFbnWbE7VF/5f6H0xmyCk/RPzw4tw8LHm?=
 =?us-ascii?Q?NIM2B+SLx4RV1ljWqSCuPRvBQmjVpFeyHDF/H2BgjRfnwoxqwkMdCWEq6Us8?=
 =?us-ascii?Q?YfM+kX9UHaGF2vSlgjbtsgkh9idyNzWzlqFU2t5aMvSoAVMz6kVOnSkzDEl+?=
 =?us-ascii?Q?X9w9CK7bGce5QIaRKqbijphKIDs3KCDDBlGLaUSUPsJZxLyz3tIM4PhIBki4?=
 =?us-ascii?Q?t9zSp+gEH39sKC/3y4UIRboZ0oesIUTI+Xfr413LTsgoANQGxMGyWxI8cf/3?=
 =?us-ascii?Q?hj1WmWbTtLO7e56PmvWSQ5pm9ENLdTrlGOINrAwdwCvG1MCDCB3Ex2M+RE6O?=
 =?us-ascii?Q?RxY6SMxtEi7NeymZKPgbxEFqdRiBdiF3Nx1GxhirNfJtHxf7WxyjBLmXtHb4?=
 =?us-ascii?Q?Lq8WVPWgbl2S8oowhcYTKlftEtSWQjf1AWnbAKa9cOLI4RNQby0nRmbCRcR5?=
 =?us-ascii?Q?SJEwwR99u5d8+quJv8gauL/qZzeDwdnSYR9BX3SDRIlKGqly0wXukEeusu9L?=
 =?us-ascii?Q?pn877HaOa1kMJcK8KJw/wsV3O0rl5Ob0MPmrNSuVrG1DjG3be+wGp1LFqyOB?=
 =?us-ascii?Q?uED5tXhd5uOtyoR3+jZiUXuukjQKs117bT+x1anwOz561087JQKRuHXlE/c9?=
 =?us-ascii?Q?pwNAze8CcLnc58VgiZX7rGkGJIZombxU+dYE7N8xqWg//omfQbzGXmQ5La07?=
 =?us-ascii?Q?tdYIO0EGWRAiIXBAr4ILvgJhcaoeltqERnY+ZV65/XxCP3DBPrgC7qwtTqum?=
 =?us-ascii?Q?f97wFNxH7rI5Cr4GGXLnV58+E5m+H6wtLaNaTtHuVX8vmG4KKVprBWbPDgbd?=
 =?us-ascii?Q?3nJYOwcTwN7+X7FvyE3KPc8XYcdYuhM9lXPxTOs7lxzsdiq4eP6jmCu5S9q4?=
 =?us-ascii?Q?VPepcPAKMt7EqSeJgMQP7skTk1SLBZ/yqRgokbjxGICwgC8xoQQgK7BGwIig?=
 =?us-ascii?Q?vvDxR+1uBPkuXx0cxOdU8xOARkVFlWct9PPEOm5RbWYHJd0geQ4u2TbLu2o9?=
 =?us-ascii?Q?RCfC7AH1pBgr+ZlwsuiMckKx92ZJhI9bxk/q3YC7BGcysrztfAaDEQrgcR7O?=
 =?us-ascii?Q?Oa3sxHC3VVfdlVMcVBPeLmYhRPh+15BR0IUORIQI7Jv+PE8i7DPBVCMscG7S?=
 =?us-ascii?Q?e/bwJqlGSytSIprDPB+cDbjFQad1rqVXiLCmgtg9tJ3p7qrrdiTlhKCggJkq?=
 =?us-ascii?Q?paD6fW9zuhj2rG5LrbZFIyend33txDTDzMRmuw8b?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c16c0b73-08a3-408b-57cf-08dcc887961e
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2024 00:06:24.5866
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vNO2kLyU04LK3bLegvf5zY/mTOFDebeuL38FOaTO9j9sqHRnQI55+HpK+uy0Dblm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB8431

We already have memory in the union here that is being wasted in AMD's
case, use it to store the nid.

Putting the nid here further isolates the io_pgtable code from the struct
protection_domain.

Fixup protection_domain_alloc so that the NID from the device is provided,
at this point dev is never NULL for AMD so this will now allocate the
first table pointer on the correct NUMA node.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/amd_iommu.h       |  2 +-
 drivers/iommu/amd/amd_iommu_types.h |  1 -
 drivers/iommu/amd/io_pgtable.c      |  8 +++++---
 drivers/iommu/amd/io_pgtable_v2.c   |  5 ++---
 drivers/iommu/amd/iommu.c           | 12 +++++++-----
 drivers/iommu/amd/pasid.c           |  2 +-
 include/linux/io-pgtable.h          |  4 ++++
 7 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/drivers/iommu/amd/amd_iommu.h b/drivers/iommu/amd/amd_iommu.h
index 5a050080d2e814..5459f726fb29d6 100644
--- a/drivers/iommu/amd/amd_iommu.h
+++ b/drivers/iommu/amd/amd_iommu.h
@@ -45,7 +45,7 @@ extern enum io_pgtable_fmt amd_iommu_pgtable;
 extern int amd_iommu_gpt_level;
 
 /* Protection domain ops */
-struct protection_domain *protection_domain_alloc(unsigned int type);
+struct protection_domain *protection_domain_alloc(unsigned int type, int nid);
 void protection_domain_free(struct protection_domain *domain);
 struct iommu_domain *amd_iommu_domain_alloc_sva(struct device *dev,
 						struct mm_struct *mm);
diff --git a/drivers/iommu/amd/amd_iommu_types.h b/drivers/iommu/amd/amd_iommu_types.h
index ef4c4887cbbbd5..74dc003f5b7815 100644
--- a/drivers/iommu/amd/amd_iommu_types.h
+++ b/drivers/iommu/amd/amd_iommu_types.h
@@ -579,7 +579,6 @@ struct protection_domain {
 	struct amd_io_pgtable iop;
 	spinlock_t lock;	/* mostly used to lock the page table*/
 	u16 id;			/* the domain id written to the device table */
-	int nid;		/* Node ID */
 	enum protection_domain_mode pd_mode; /* Track page table type */
 	bool dirty_tracking;	/* dirty tracking is enabled in the domain */
 	unsigned dev_cnt;	/* devices assigned to this domain */
diff --git a/drivers/iommu/amd/io_pgtable.c b/drivers/iommu/amd/io_pgtable.c
index dab1cf53b1f3ff..f71140416fcf6c 100644
--- a/drivers/iommu/amd/io_pgtable.c
+++ b/drivers/iommu/amd/io_pgtable.c
@@ -141,11 +141,12 @@ static bool increase_address_space(struct protection_domain *domain,
 				   unsigned long address,
 				   gfp_t gfp)
 {
+	struct io_pgtable_cfg *cfg = &domain->iop.pgtbl.cfg;
 	unsigned long flags;
 	bool ret = true;
 	u64 *pte;
 
-	pte = iommu_alloc_page_node(domain->nid, gfp);
+	pte = iommu_alloc_page_node(cfg->amd.nid, gfp);
 	if (!pte)
 		return false;
 
@@ -182,6 +183,7 @@ static u64 *alloc_pte(struct protection_domain *domain,
 		      gfp_t gfp,
 		      bool *updated)
 {
+	struct io_pgtable_cfg *cfg = &domain->iop.pgtbl.cfg;
 	int level, end_lvl;
 	u64 *pte, *page;
 
@@ -233,7 +235,7 @@ static u64 *alloc_pte(struct protection_domain *domain,
 
 		if (!IOMMU_PTE_PRESENT(__pte) ||
 		    pte_level == PAGE_MODE_NONE) {
-			page = iommu_alloc_page_node(domain->nid, gfp);
+			page = iommu_alloc_page_node(cfg->amd.nid, gfp);
 
 			if (!page)
 				return NULL;
@@ -560,7 +562,7 @@ static struct io_pgtable *v1_alloc_pgtable(struct io_pgtable_cfg *cfg, void *coo
 {
 	struct amd_io_pgtable *pgtable = io_pgtable_cfg_to_data(cfg);
 
-	pgtable->root = iommu_alloc_page(GFP_KERNEL);
+	pgtable->root = iommu_alloc_page_node(cfg->amd.nid, GFP_KERNEL);
 	if (!pgtable->root)
 		return NULL;
 	pgtable->mode = PAGE_MODE_3_LEVEL;
diff --git a/drivers/iommu/amd/io_pgtable_v2.c b/drivers/iommu/amd/io_pgtable_v2.c
index 45a6bc3326397f..1e3be8c5312b87 100644
--- a/drivers/iommu/amd/io_pgtable_v2.c
+++ b/drivers/iommu/amd/io_pgtable_v2.c
@@ -251,7 +251,7 @@ static int iommu_v2_map_pages(struct io_pgtable_ops *ops, unsigned long iova,
 
 	while (mapped_size < size) {
 		map_size = get_alloc_page_size(pgsize);
-		pte = v2_alloc_pte(pdom->nid, pdom->iop.pgd,
+		pte = v2_alloc_pte(cfg->amd.nid, pdom->iop.pgd,
 				   iova, map_size, gfp, &updated);
 		if (!pte) {
 			ret = -EINVAL;
@@ -359,10 +359,9 @@ static void v2_free_pgtable(struct io_pgtable *iop)
 static struct io_pgtable *v2_alloc_pgtable(struct io_pgtable_cfg *cfg, void *cookie)
 {
 	struct amd_io_pgtable *pgtable = io_pgtable_cfg_to_data(cfg);
-	struct protection_domain *pdom = (struct protection_domain *)cookie;
 	int ias = IOMMU_IN_ADDR_BIT_SIZE;
 
-	pgtable->pgd = iommu_alloc_page_node(pdom->nid, GFP_KERNEL);
+	pgtable->pgd = iommu_alloc_page_node(cfg->amd.nid, GFP_KERNEL);
 	if (!pgtable->pgd)
 		return NULL;
 
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 3840b3ede65d32..806156632bf70a 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2030,6 +2030,7 @@ static int do_attach(struct iommu_dev_data *dev_data,
 		     struct protection_domain *domain)
 {
 	struct amd_iommu *iommu = get_amd_iommu_from_dev_data(dev_data);
+	struct io_pgtable_cfg *cfg = &domain->iop.pgtbl.cfg;
 	int ret = 0;
 
 	/* Update data structures */
@@ -2037,8 +2038,8 @@ static int do_attach(struct iommu_dev_data *dev_data,
 	list_add(&dev_data->list, &domain->dev_list);
 
 	/* Update NUMA Node ID */
-	if (domain->nid == NUMA_NO_NODE)
-		domain->nid = dev_to_node(dev_data->dev);
+	if (cfg->amd.nid == NUMA_NO_NODE)
+		cfg->amd.nid = dev_to_node(dev_data->dev);
 
 	/* Do reference counting */
 	domain->dev_iommu[iommu->index] += 1;
@@ -2271,7 +2272,7 @@ void protection_domain_free(struct protection_domain *domain)
 	kfree(domain);
 }
 
-struct protection_domain *protection_domain_alloc(unsigned int type)
+struct protection_domain *protection_domain_alloc(unsigned int type, int nid)
 {
 	struct io_pgtable_ops *pgtbl_ops;
 	struct protection_domain *domain;
@@ -2288,7 +2289,7 @@ struct protection_domain *protection_domain_alloc(unsigned int type)
 	spin_lock_init(&domain->lock);
 	INIT_LIST_HEAD(&domain->dev_list);
 	INIT_LIST_HEAD(&domain->dev_data_list);
-	domain->nid = NUMA_NO_NODE;
+	domain->iop.pgtbl.cfg.amd.nid = nid;
 
 	switch (type) {
 	/* No need to allocate io pgtable ops in passthrough mode */
@@ -2365,7 +2366,8 @@ static struct iommu_domain *do_iommu_domain_alloc(unsigned int type,
 	if (dirty_tracking && !amd_iommu_hd_support(iommu))
 		return ERR_PTR(-EOPNOTSUPP);
 
-	domain = protection_domain_alloc(type);
+	domain = protection_domain_alloc(type,
+					 dev ? dev_to_node(dev) : NUMA_NO_NODE);
 	if (!domain)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/drivers/iommu/amd/pasid.c b/drivers/iommu/amd/pasid.c
index a68215f2b3e1d6..0657b9373be547 100644
--- a/drivers/iommu/amd/pasid.c
+++ b/drivers/iommu/amd/pasid.c
@@ -181,7 +181,7 @@ struct iommu_domain *amd_iommu_domain_alloc_sva(struct device *dev,
 	struct protection_domain *pdom;
 	int ret;
 
-	pdom = protection_domain_alloc(IOMMU_DOMAIN_SVA);
+	pdom = protection_domain_alloc(IOMMU_DOMAIN_SVA, dev_to_node(dev));
 	if (!pdom)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/include/linux/io-pgtable.h b/include/linux/io-pgtable.h
index f9a81761bfceda..b1ecfc3cd5bcc0 100644
--- a/include/linux/io-pgtable.h
+++ b/include/linux/io-pgtable.h
@@ -171,6 +171,10 @@ struct io_pgtable_cfg {
 			u64 ttbr[4];
 			u32 n_ttbrs;
 		} apple_dart_cfg;
+
+		struct {
+			int nid;
+		} amd;
 	};
 };
 
-- 
2.46.0

