Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2089.outbound.protection.outlook.com [40.107.237.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ABD381E;
	Fri, 30 Aug 2024 00:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724976395; cv=fail; b=NGqRxw2FrGzBCpaqWdClbAD869twHGZYXnHydHfM4FHUGfGLGnth3LbtxsspAbTP3WlJ/nDtQmwYYpr3ZkxNHnws+OfG5KRmVw02HieiXiWia8sXE+C5jpaoecGY1FVEO9mw4BiPZUjZ5ON1+kSX40zX71DvonYM0UvMtpV6KxI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724976395; c=relaxed/simple;
	bh=LbaD37GKeOqsrKUG9pROdW+J1rCfJBzse7agPsceFZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=I1O2zAF88BQHRoN0kffQ04eaOjKP4Eijkd+JDzxDZ5k+3KFhVI4qnqg2Vo5LAULFNzOElEaCYXKzff+N8Bapop00Rth6D2Rzbg0d27r3Zx4Ixhp++qrE6FvfC2rxdzVxuav2ZTbjarqTl1/iFnGHB7Ut/TIHLV3nx+1fpzxt7uY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BosTOMee; arc=fail smtp.client-ip=40.107.237.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BosTOMee"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I1yDKL9dPeWI60tdeeQgT6pgTaako5rQqsSzZgwKQw/U09ra3TGVR0cbF65K5h95T1HVWsdXi77bZG1GkwG9ND5PJJ2FWoDuJATXOJ69Mr0xIjb5RUwcD+4AabNzTqKRx2jdKV8CMne26oEAKtrBIomDKbJKifUHKP7uV/MaSiSkNROH0YnNorwLL7CSfB78wTF77w/js5Vffqq5RLkdagi7Q8w4VMsAK9eZlntxOfp6RFBchUUvE6xLCO5js8B83yCvX25OjaYwyP9XJValr5tJIiSFrG4MovPmvfB6JwHZ09k4vIJyiB+8i1pXZ+XR7gX222BpC8CXiuZx+onBVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A5ZyCKN+T6T35LKL9fJhUXdxog+eaF7GUaqrTnv4ZwY=;
 b=vOTlmE5BHszE6hgM8q/km02UWjxqAETMfI7P2wANDH1Owbwx3dpbr8G4oYLnqDAqegfErbEfcuiGaAnT57h0WS8OqKpgkXQOx7KvtfArp3Wsfl7AAqMkOPjUqVPO+iY6ucI8YkCqkJh7xPGR0olJx4o06cF7T2GK1f2mYan3Bo2/m6ki1p3uZyZkyQB0LxpVgbVVGW9W8IGDecskGN1bO+ruNMggxaLmU765TuBMKr65Zpz82oLC5WmPJfyANnXjpBHAMXf25HE93ZyL6MWkvRcN6nwzN/4KIb1a9RBU6XELWAwNqsu31ZoBEWRDq4V2BtRhGevA3mcZp09BaewsyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A5ZyCKN+T6T35LKL9fJhUXdxog+eaF7GUaqrTnv4ZwY=;
 b=BosTOMee3ZAB8oYEoYFl2YrWaJaU2jIu9PKefudZjLOiRqQFGBOLhW4uGCZtNhhncG7GprB1hR043j8GRbr9r3D1FUfPHqK7fYkUxw/xukGdIQAkelbNVMAJ6QMsOsqJm89kuVfiY9XbB8TV9aFwKs4MfV9wjP/t7nhV3YxDI7ZZvvm2k6u6Sddn16evYBMPTWJG4c7YRnh+bJ9zJ+8hxJs7XUoUQasOTtAw1l1rmM+fZZLdw/nl0cGfl59Sl+FhQoskrfnQ73jYrnZunvCH6yg+XZ1ofiwv+7ED7kie/z7TbRi42PDgzs85hMZQedCILnXp5CFpUeZ/qqkRsCpyPQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by CY8PR12MB7415.namprd12.prod.outlook.com (2603:10b6:930:5d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.20; Fri, 30 Aug
 2024 00:06:26 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7897.027; Fri, 30 Aug 2024
 00:06:25 +0000
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
Subject: [PATCH v2 01/14] iommu/amd: Move allocation of the top table into v1_alloc_pgtable
Date: Thu, 29 Aug 2024 21:06:10 -0300
Message-ID: <1-v2-831cdc4d00f3+1a315-amd_iopgtbl_jgg@nvidia.com>
In-Reply-To: <0-v2-831cdc4d00f3+1a315-amd_iopgtbl_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0783.namprd03.prod.outlook.com
 (2603:10b6:408:13f::8) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|CY8PR12MB7415:EE_
X-MS-Office365-Filtering-Correlation-Id: 029e24eb-195d-4fe2-673e-08dcc88795fd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?M9p9RhY+strQKsXq8TGRQG6o4sFc8IwrZUBKWOL0c+wZinfP7nmptWn0BE5T?=
 =?us-ascii?Q?ptrHHQQPrqPcAOFoJ7TFUx8OYOFvp3nIE2xsUfNLCkzvN6N0a/larUut8gMY?=
 =?us-ascii?Q?gxxFGsCxtWnr036Tcj4jWdP/WXRP+xMC0g6z7YNy/oeEvqYLZo1nHxXrejdO?=
 =?us-ascii?Q?k+k2DRIjVumd8N+cm7Rat6wolyk31aulPKDwK6oeZX57mDfdEDUNuKmi5RXp?=
 =?us-ascii?Q?ROnHFfkD2v5UdbLjlDCIpl8ICt9l/74p2IY/UZ/QQ3hFAbJ2E1mqJVrtojhJ?=
 =?us-ascii?Q?GMAPAZKGDYQnpIeAjJq4+CGKapepRfDuvZSAXc824NgvXT/10pln6yzJhfW+?=
 =?us-ascii?Q?hBLW7RH0ZjJ6yZq32m7oNPK5Y9AcipoWy4DZsARCGNKQTppmPGBB+EK5T82p?=
 =?us-ascii?Q?fknRvmy74Squs2UdV5OUAnNdirN6hLAm5slwv60uxfPeSOdsKnUB+aekSFlB?=
 =?us-ascii?Q?JEh2642faqbOepKfmkMDZEeireklLSUBZvcbDaNHa3gHavKs0PGXIQq/v0aU?=
 =?us-ascii?Q?PX8uuJYq5CsO3DIxBTezxRFf8roRupQsGS112XZwbaRGpMPlXUU5yllcqRLd?=
 =?us-ascii?Q?n8PqEgN/pbxqqjbcqXsPDJYJTjQ03HQ78XRsv3qnOcWH6yD06sRO02sm6EOV?=
 =?us-ascii?Q?yu/zi3sg/oP1Xb0Hrk9Fg6YlmJwMCPq/D7gvM80Cm5h4lJEpVVgpopaqD6vo?=
 =?us-ascii?Q?Angodb2EZ/DqVOFGk0dKw0s82U2eu97jLbjDRob1G28EvHbqzDVbprmP6GUF?=
 =?us-ascii?Q?JixZEEOdNpSR3jq6RhCTkSfKveMZlNnX6eDy3U5uH7baouFF8pPWZ60muCAp?=
 =?us-ascii?Q?Nmca8YUb3gbqxaWoIWz9k3WDHEF21pnlhErT1Hn55gvQecqMDRX7w6mriJ1s?=
 =?us-ascii?Q?gLmDmvk57zkFnEhdhOzcGvPtEHIyxEpCzx27kn3LKZUepu4sotXOqIJ4SK+N?=
 =?us-ascii?Q?XeMeJRXC7uH4Xj1jdEHdLcPP3NYjE673e5N7fkQaULf/+nLsW/YlXg1aQ5cz?=
 =?us-ascii?Q?il2B79+44j9dkm9JNTQj/4etVPEPn79DqgObm3fz8Ijkwot0Lwep0xvWVrnb?=
 =?us-ascii?Q?MVyoR3/sxoswBypRSiClpG4mHJyXNDSu4XrOJx27spfZoAoE3p7iV/SgXIYr?=
 =?us-ascii?Q?xSrO6rl7mMRCYi4LyFFfbyoDakDv9x10bXLxyoxw9/DvgUdb60SIiFYI9ATm?=
 =?us-ascii?Q?ntG/Hk6CSEV8R8HxiayPRr+L5DBTmFwDb1XudkarlzK9s3CMVp4dHJR1r2by?=
 =?us-ascii?Q?tGyh6MDYY9IufpIChJeYyO5SISTsCNJTJcCXmGKreGZEhMk39hFhmB3NlgsN?=
 =?us-ascii?Q?gmW/Tx/DFKfzR6DLBpzpPh5AouAsQyBEVSI2i1DpwhvPww=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?oeBToOkggAz6AerYeLjh1gKwQbNv7BE4eXYDxb8akUPYjdp+Rbzp7TFUS8rj?=
 =?us-ascii?Q?ueQVxvGk1m93SrucK9ByIafxRxzfiwTmcTxStn43z9+6+0SbtLVn12AW8mAK?=
 =?us-ascii?Q?5bmT9Gy0VfpvRinWFdz0hJB32LSAupmdqqwq9nUhDm6/Go8myg3vpGMb2WLa?=
 =?us-ascii?Q?FrTg1tLvuayr377GR5P99blmv/tmSKtRo83VOeBeyX1yeN/JRxH9QT/mxSG5?=
 =?us-ascii?Q?geVSTT6GlgrVh+7p0JgDtnRhW5b0fo3224tiBxIj/eVxLeYqND68de42aRZp?=
 =?us-ascii?Q?I6Q8QffjHdI6vUduTPKfJ5wNC3ggKkqg43cX154tZsa/dO5sbtyCmLzib4nF?=
 =?us-ascii?Q?vZUVg7M8quH3wQdYqNxQcgxC6FzwcdS2FLcpiz7opmV7nZcA8Q9sQ6r3qHtU?=
 =?us-ascii?Q?klSbhqHXTe1fBDT03x8yuO7HwFpLw3vN67QwHTOiCwlT8r9kdBKL7FQC16zT?=
 =?us-ascii?Q?84w6dC/ufYCGyDJhdYUz7pRqxz+dkGoyhC+Ag+K54tA2RxpdaaaAlwX6Ibds?=
 =?us-ascii?Q?cv8zZaLj50hsc62VNkKWc5IJagYgmG479sz79Bi7kKkdXPNlOL+dB0mKU4Gw?=
 =?us-ascii?Q?1HG0zn3Qr//7Ose6zz8Fla5HDcyfUI/a3MsbzVlREBNN3OrsL7wEIXOAV0cg?=
 =?us-ascii?Q?ir/Wr7kjTqEw2J625wB1GDd9qgcWhmSNas0jirdR09ePLikAyplSfyOoVbex?=
 =?us-ascii?Q?83CXfbL+3mZPII7z31eqsyVExKmd6cxlgTnwnkUXkbsx3RBM9G4JTg9TdgpY?=
 =?us-ascii?Q?ma6V+jytzW98XeDGP1owcJVwZnwEFMYfrJjYcq3lLIa9UsOIGZwLH8LoH+y4?=
 =?us-ascii?Q?YgP5fiNSeADqB21ijnt8GVjjeoRyrUda+IskzwQDLi8zn5zYiwByCqKp+VKG?=
 =?us-ascii?Q?4o0Bl5WUFwqpMRjdhN0MHRsuk43QAsIkiGp6cPaapvUyv+fwgFFTLmvEAQiu?=
 =?us-ascii?Q?oWqzzqY6Kx9kvpRvp5Ho+PBUPpIA2K3quBo9RPUWNCG4br/KZHdEV0peBRiu?=
 =?us-ascii?Q?IZKAKD9wyFHQwtj0usSaMRkUIEzc4B55u6QOiG4jDQ6UyixZHMFqjxdFBYlF?=
 =?us-ascii?Q?7/JAIIMvCPonu42IeZuaGehB524uQ7pDVEKxeZI+zeFcQgcMCCv3IzQrjy0z?=
 =?us-ascii?Q?gXYZ0i/hgOM2A/9jV6DVGg2QeW+NRmgHPI1UEmMPe3t0heekaA1/icGWgW1x?=
 =?us-ascii?Q?iknbaaUsNIiUhg6RhLO9dxKxAqMKvum+0+xtPnrbxssq9IREm8m/f3QbtClx?=
 =?us-ascii?Q?49AM49hxptif/1zlFBl1EQImfE2yOt18+hGU19L+FTBfUD/FI0pk2SM3IOQY?=
 =?us-ascii?Q?xaKiA/TquwwOHYY20svQOwoN6/u7pwn/4Himk7hFjfSOtqJ/rD+4z100A1mg?=
 =?us-ascii?Q?RLGsY6RLD3JTguHd0WuX3ezz4GMFYc2KyPACddrLjgQjki5MYqxnJMkI79oo?=
 =?us-ascii?Q?j7GYptAuAw7NeWAjREPv+npGG3hDS9IYYjLXC17mB2pVe4sfSYt4Oe+Wm9hy?=
 =?us-ascii?Q?JxqwvIT+6QkiE2FFZnlwpLiCE5JYbOE7OD135Rtdj7BMYuIAoyevnJYXy5Vr?=
 =?us-ascii?Q?FAWGrVypfF4UzxuA44txupJca3I1fWAWRzaRNtaV?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 029e24eb-195d-4fe2-673e-08dcc88795fd
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2024 00:06:24.3193
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mhxlauDaGkq5YRM8Xlhw64mer3EF/iq31Lph7VPbpt+cLADBt/33av8imf0/ZZl8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7415

All the page table memory should be allocated/free within the io_pgtable
struct. The v2 path is already doing this, make it consistent.

It is hard to see but the free of the root in protection_domain_free() is
a NOP on the success path because v1_free_pgtable() does
amd_iommu_domain_clr_pt_root().

The root memory is already freed because free_sub_pt() put it on the
freelist. The free path in protection_domain_free() is only used during
error unwind of protection_domain_alloc().

Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/io_pgtable.c |  8 ++++++--
 drivers/iommu/amd/iommu.c      | 21 ++-------------------
 2 files changed, 8 insertions(+), 21 deletions(-)

diff --git a/drivers/iommu/amd/io_pgtable.c b/drivers/iommu/amd/io_pgtable.c
index 1074ee25064d06..05aed3cb46f1bf 100644
--- a/drivers/iommu/amd/io_pgtable.c
+++ b/drivers/iommu/amd/io_pgtable.c
@@ -574,20 +574,24 @@ static void v1_free_pgtable(struct io_pgtable *iop)
 	       pgtable->mode > PAGE_MODE_6_LEVEL);
 
 	free_sub_pt(pgtable->root, pgtable->mode, &freelist);
+	iommu_put_pages_list(&freelist);
 
 	/* Update data structure */
 	amd_iommu_domain_clr_pt_root(dom);
 
 	/* Make changes visible to IOMMUs */
 	amd_iommu_domain_update(dom);
-
-	iommu_put_pages_list(&freelist);
 }
 
 static struct io_pgtable *v1_alloc_pgtable(struct io_pgtable_cfg *cfg, void *cookie)
 {
 	struct amd_io_pgtable *pgtable = io_pgtable_cfg_to_data(cfg);
 
+	pgtable->root = iommu_alloc_page(GFP_KERNEL);
+	if (!pgtable->root)
+		return NULL;
+	pgtable->mode = PAGE_MODE_3_LEVEL;
+
 	cfg->pgsize_bitmap  = AMD_IOMMU_PGSIZES;
 	cfg->ias            = IOMMU_IN_ADDR_BIT_SIZE;
 	cfg->oas            = IOMMU_OUT_ADDR_BIT_SIZE;
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index b19e8c0f48fa25..b42e695af6dbe9 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -52,8 +52,6 @@
 #define HT_RANGE_START		(0xfd00000000ULL)
 #define HT_RANGE_END		(0xffffffffffULL)
 
-#define DEFAULT_PGTABLE_LEVEL	PAGE_MODE_3_LEVEL
-
 static DEFINE_SPINLOCK(pd_bitmap_lock);
 
 LIST_HEAD(ioapic_map);
@@ -2265,30 +2263,15 @@ void protection_domain_free(struct protection_domain *domain)
 	if (domain->iop.pgtbl_cfg.tlb)
 		free_io_pgtable_ops(&domain->iop.iop.ops);
 
-	if (domain->iop.root)
-		iommu_free_page(domain->iop.root);
-
 	if (domain->id)
 		domain_id_free(domain->id);
 
 	kfree(domain);
 }
 
-static int protection_domain_init_v1(struct protection_domain *domain, int mode)
+static int protection_domain_init_v1(struct protection_domain *domain)
 {
-	u64 *pt_root = NULL;
-
-	BUG_ON(mode < PAGE_MODE_NONE || mode > PAGE_MODE_6_LEVEL);
-
-	if (mode != PAGE_MODE_NONE) {
-		pt_root = iommu_alloc_page(GFP_KERNEL);
-		if (!pt_root)
-			return -ENOMEM;
-	}
-
 	domain->pd_mode = PD_MODE_V1;
-	amd_iommu_domain_set_pgtable(domain, pt_root, mode);
-
 	return 0;
 }
 
@@ -2341,7 +2324,7 @@ struct protection_domain *protection_domain_alloc(unsigned int type)
 
 	switch (pgtable) {
 	case AMD_IOMMU_V1:
-		ret = protection_domain_init_v1(domain, DEFAULT_PGTABLE_LEVEL);
+		ret = protection_domain_init_v1(domain);
 		break;
 	case AMD_IOMMU_V2:
 		ret = protection_domain_init_v2(domain);
-- 
2.46.0

