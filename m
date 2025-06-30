Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2069.outbound.protection.outlook.com [40.107.92.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FE3428C2A3;
	Mon, 30 Jun 2025 15:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751295852; cv=fail; b=DFLb5w0IzJin633+QIRfW/1QVj22kD6pdQearFaYQAW4Ng3WGaVlNdkodJrR8z0ppK/Dcji6SFE8jpuOspZD7FIyiuQNZT3D8pJiG8VpZM+8CpxR6u6VfxYQAgk4O8ETB8qnrhsIZ0OTi70/ZjeQSnHNpeXnM0Orqtu6lLk0wmk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751295852; c=relaxed/simple;
	bh=sPde78n4Ze+80HDo302HCWGe32TAjB0GmxUyslvZEz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dROJg6hKih/H8uM48Vo2wkgCs2AldNbv6Qsg5L+YmNbVypc5oLtA//DnDxg2k9t7eK+gzfS7kdPJiRJJmnqGiwMIHcU8ATSuGJxRwqrbssHxkWI93LVwHKCk6RTqr73QDjRVN8/8f3jgf+wWBmV9sijmCdWUO6A76Y0VogybcPA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lL2yMfe8; arc=fail smtp.client-ip=40.107.92.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lL2yMfe8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oRxc9H5BfAFKv0RPVBguJBdSvpQelBI9gcTwaV0T9ehzZBsVcHXCCthPKvD7jxlWco9C6uZPlb/LHZIdvyajQJF125u4zCkiu5NKPeqqqz3edSES+8snGVqEEnGm6HoJTYYX9H/28EG1nmatOUNnn433Ap2K3hIXQeJKiRWtKxc53qJtaZc9Os0dyM9xuheJP/O8UryKV+eetjbXJ5ZrPYy/AtIRid+t7kEnlGc9/a03ksQ1DeEvOcFuhVcMTPE16SBnud7q8qeO3S4RzR6ZZTL1xJtpFrR3UYt83S/d5DE2kyJxZ3/t9RcYHEPqJ3M3yh3KR454PTRFWkidW3FIcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HaAMJ2yOwQU0wJGWOTjLADXamm4qBevvZF3h9BGrXJM=;
 b=eloz2mygszZArdMm8WtzZuuMj+BBASAsP9xVEzWKoR7vnUhavIo3hH6HaMRfDUTQQkPqX9qFlEykm43n1YlmqACoEEkhtUBIkcY8nS4zQr4CvodjNPSPqzvc6zsthPbkehOWNOFTLQGKxQp0IkzwKx9AOm/vMkKgnco8fIMsLrGIKsIi25g5tkQWqzCGfk+NcDil3YaIzf5mkazFdtCo7fsK7GvVmlJmuDcY5or7Thv9eFfgFyiesyZVxGQux5t2OX39jB24KXydizYGZtqVF1DxufmTbzuaK044yhJ1L3cIlUGUDxP9vOQAccRtf+DCuB5ba42YQbWAooCngYI8lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HaAMJ2yOwQU0wJGWOTjLADXamm4qBevvZF3h9BGrXJM=;
 b=lL2yMfe8p1o/XJJ8a/ldHAc5Gr/Uhss0CJn7wISvbZoQ/j+oLcopzGQwyXuxVleeK9n7c8AE92vrDxef/RqWKBPNF4io0P/WUmkQFQgAPCnxocEbm046GfPq/2xqLG16V2MaBZPrCHpzxkkymbc3TL+hG/BPH5TUZnDLRr2nDetSphZmFbDbGQHXpbVIPEbxtNR8qCa+ygugxV30Hw3rVX4oKPcy2URcQXcjFJvlIXEVi3sRmiti9wpzWsIBtXVyLSQMFqFDEjklGPpAFgsZRch51U7ScPdhGnKDIH/UjmkDGFtfGSwn+9D5WrNJj6ut+M5NtM1YGBrQW2NMIVDcZQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by LV8PR12MB9643.namprd12.prod.outlook.com (2603:10b6:408:297::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.17; Mon, 30 Jun
 2025 15:04:02 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8880.030; Mon, 30 Jun 2025
 15:04:02 +0000
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
Subject: [PATCH v3 4/7] iommu/vt-d: Split intel_iommu_domain_alloc_paging_flags()
Date: Mon, 30 Jun 2025 12:03:54 -0300
Message-ID: <4-v3-dbbe6f7e7ae3+124ffe-vtd_prep_jgg@nvidia.com>
In-Reply-To: <0-v3-dbbe6f7e7ae3+124ffe-vtd_prep_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0005.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::10) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|LV8PR12MB9643:EE_
X-MS-Office365-Filtering-Correlation-Id: c42fa966-d3ba-4b97-0e6e-08ddb7e75928
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xdOZxP/QKz7qQx71x9Lh0zqDd/66Wp7b6Wfw3aFQW3V3OvNBoeZWekH8xeIR?=
 =?us-ascii?Q?mNQX7STDt2UFt69NArMeVph+6q/nZ0EFaBgXer3K7BymIzBUQShlXxKs22Mm?=
 =?us-ascii?Q?ZvI4i3pPgG9emfn2FVblO0a7dsUGvDTjU9nLSA0/zvA7+QJqarY/UtKfk9ZN?=
 =?us-ascii?Q?16qru5UDc/+c+6Jn1c52DR0iH+zA/mBg7oC/9GJsnkWHaobqBwgnMKfbf6Bt?=
 =?us-ascii?Q?9mgwbZwAf4mgnoZ/viTDHki4EiPYK3btn2B90lodFS9aQTotA/U9Vvs65FX2?=
 =?us-ascii?Q?DZDu0I68kyJNydRhGF2kB0SkXcYlyUqFzk2HwGmQBNbS5OsG+JJeH/UmOdSt?=
 =?us-ascii?Q?toiIl9VC0tnuK832YAEsZea6PSJr2+1Uh2egynebUIUHkl8lEsADUjxbsJ13?=
 =?us-ascii?Q?tRauRGfjk6rJojYhi+9LXsL3zD4RvsAId+vpGhDPUkokrTroaRegDfLZ/A2i?=
 =?us-ascii?Q?xBxDHiEafetkcndHea/IlXAiF8MXiSampMLJNQ+FTq4EdYD5Sp/GKfEvzEDf?=
 =?us-ascii?Q?lGtckYUagCoqpbVbEDUC4Z2ATnKEnMBl27hNABQSewGdGPKXAuSDAWMejt75?=
 =?us-ascii?Q?0exyamM9rXE7z5MlUnW6GTgo5H0Dn3XTO7Lcw1UQzRcKQFo2ponAqTJ1doua?=
 =?us-ascii?Q?PomeoRVTHMgLxEiH+wsqVLr3hayOUfo4tcPL0u/1Tm6FbDfgp2Of7GTgE7lV?=
 =?us-ascii?Q?SlTQWCJWYWonyKk5k7sBDxxgkIJkaRZ/ozYnr2D4PCfuUWsTTGiEWhMddV7D?=
 =?us-ascii?Q?Ee26kc5EXiDpXO82brF8dLp+V6i04ZFA8pM5P2lD9rThreAxPCXesvYrsKYI?=
 =?us-ascii?Q?72mZU0BNb7t2A5b/nLUgFU+Y88Gg5wiYwq6Kv2iH2HC0QXq7cob6RuQrH0cH?=
 =?us-ascii?Q?ZPmA4YUnU2gl7DB3OpmnxXLnMejfpIiW2YPJIAYvwQSauNcbsSSxscNSJMTV?=
 =?us-ascii?Q?Ci/UJtZh0ip17rUru+QBxC+iQlBp/O0IelPo5JE9bJ8uQDKyoAXjZGQ52+MP?=
 =?us-ascii?Q?bcPdo9VFKNFz68R5x3I4kOGk1qhvrZ3hcd9YFsnxqL5lW2Sad2C2xmM8aa2N?=
 =?us-ascii?Q?XiYOQq43nxDldPIww+wXYa0QzpmNPYE+l6QJPafivQ0vdzDhpgwWr1P9Filw?=
 =?us-ascii?Q?MsDBF6aQEePS2TZ+RAZ5u+Jel2aeyjwGnAp3D1x6z/lfrGtKPrCikrQ0qsei?=
 =?us-ascii?Q?8NEz4OVrXmTg2MGF8LfEvNdi4ofKdK4wDU6D30T7siaHASq0sALRUyR0D9ra?=
 =?us-ascii?Q?/p7nHy+B/00tZsbTLYmIl89y117mMEYvZ45fJrHGxps7FSbhkTjM3EUABG7r?=
 =?us-ascii?Q?b3Z63818Q3RqckXf0/8wsBG7bdy3xCM6XkHIUuKmqiGs48QFaT953GlFdpRU?=
 =?us-ascii?Q?sYWrKbGch5t9/4JODH5WwLizxktfz7G8O+nskF8rk0jbKYIcqlrUWvwQAilF?=
 =?us-ascii?Q?Cxo+9th6KLY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yim48HRAWAVNqBaulgvScRrhycyoffhEldprRii/DQYpvC6w7BV9m2B98Eh4?=
 =?us-ascii?Q?oIsi5vqfXUdp7jUvrDwh657s4JYpszGVJew3ct1Xye3dFAzDPIwuxSnks871?=
 =?us-ascii?Q?U9KHe/Edi+WqmsPoM/UoooKjbjD989Vo/umzY/meVf2NXTzzYvIQPDockf0s?=
 =?us-ascii?Q?b1eBiI/PiZXDnc60BYFT7jSYRGYOhi9VcAranRfhwsc7CZCCc96vOoxvsqv8?=
 =?us-ascii?Q?pwCGBZGoS5Y4Wkegt4GxvFwHwZhmEnhw9QKpNKKLHcwsw+ZENKCN2SMmHi3c?=
 =?us-ascii?Q?oxyAOXS6JUxw0m8E7aNZcVMLT3j6WaCl/LOfyJirLCl+P6v53xGKOMzknbF7?=
 =?us-ascii?Q?89s7TTe9PDQXELQq5EUVzOk4Y4iVuJHpLjb/NuUQfpPKPgQl2Lz4pNJxT2Ci?=
 =?us-ascii?Q?/Q9JFpocHXsSrbBTv5vcGRFLG76p0ZP5+PaixdXHjZBcBaZUV2wV/zaTxahE?=
 =?us-ascii?Q?d1hfp4Xjk4eK9ZgvoC6n87XTkZ6kB3CxnLLmow3k9baLCIVZBx+0VuiNoU16?=
 =?us-ascii?Q?dO6NemimltDuXexC5+00P00CSecIQ7blIub/6yyLanw/8wS5SE4MP9twH09r?=
 =?us-ascii?Q?3gDK8RIaDy1KPOVFnPqnEjDVm4pa1V3r5Ophh+7cC2Yt6hop+P8LFB3KEmEC?=
 =?us-ascii?Q?bJxW6j1Vsrh4qgHgCkHpAYj5pQWB2mqt8CKDsRIDKT5Sorlr2veKLLSD9Al/?=
 =?us-ascii?Q?RPBntRPDan8Nn4RxW8ALKd4MwA5ISHYUaVVj5mgdmjMoG9tr8Scgy4ZXaVQa?=
 =?us-ascii?Q?2IvweAhCGJe14AVkoSFyf9eDbfIHqBn2QkFWKvmydTiwJYyvol3S6OSNMuCY?=
 =?us-ascii?Q?Af0FwAWzytoq8hs+okZYdlIwVNRQtgo413VBloFQiptbY1muk5BOev1cWDdz?=
 =?us-ascii?Q?JIqtSu/WbSlRTvC5k6JjcrDdOalBsIl1CrmInM2/6IlPMFPKs6fUeCFlor21?=
 =?us-ascii?Q?AOX52JK0GQoMtVPw85n7QTdBpV5YWWXlXHyauuFGqTnUOmRmj3JjfB9M6Fvx?=
 =?us-ascii?Q?JRFRwbRNDxAFUE5XSaJB7N1PUdWgE+lF8cybS8aQwi7yz5W7mflOpLlSkhsW?=
 =?us-ascii?Q?O0oLOd+qwGCzZqqXtPXhvo+W9Fy7GJzt9UC9hxJ6hoFtUH0vlpUYTtWnFr7Q?=
 =?us-ascii?Q?Rx7IkWSgg42Euc/yf35kvzeejvlwjc/my/vRYoPkijSjqNgI+lc6zIOJa9Ky?=
 =?us-ascii?Q?JSIg+QIsbrEME6gnstwOfJH4/U7aLB38m2Zr/psbGt6b4+KiOmuPMuhTS2+a?=
 =?us-ascii?Q?U5TBvHMMJCoKE6YTHpQ3vQ4Wpv5w6dYKE5C9wcCvS1Un9ulYHyDCDLSfDaUu?=
 =?us-ascii?Q?biD2va2/a0oxNcac7QbS91EFqpzc8I06K7MbkTrSHXoTCm3kFq17EOgdM5jj?=
 =?us-ascii?Q?bZO5xrAArUUM3GzCx0INQbV9F3Pf7gNRKBfSaZWY/8twt1QPitu5V/UGNow8?=
 =?us-ascii?Q?o9wWxEYyQOt8TE7v9DCja3LUTzD6/62TR1X9FSLHiru//XgEeMjn7UyKloeP?=
 =?us-ascii?Q?YEQJFzO3Ijyrp48XMU6i6Jrd08sS2BPNUxbEIQaprt+mRUJUpOe4gWWrYOo1?=
 =?us-ascii?Q?3cGv4PYMoxnbjhJu0lC2IMPf3WCDl4frEsdwp/tI?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c42fa966-d3ba-4b97-0e6e-08ddb7e75928
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2025 15:04:02.1566
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MiYpNNOC7u9GUH0YolX3WOoWGSRXzq28J/VnQt8rs+pTlHZFzVn44NZVJqKpZhCC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9643

Create stage specific functions that check the stage specific conditions
if each stage can be supported.

Have intel_iommu_domain_alloc_paging_flags() call both stages in sequence
until one does not return EOPNOTSUPP and prefer to use the first stage if
available and suitable for the requested flags.

Move second stage only operations like nested_parent and dirty_tracking
into the second stage function for clarity.

Move initialization of the iommu_domain members into paging_domain_alloc().

Drop initialization of domain->owner as the callers all do it.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/intel/iommu.c | 98 +++++++++++++++++++++----------------
 1 file changed, 57 insertions(+), 41 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 00079c3e49f078..243e77d5a06aac 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -3267,10 +3267,15 @@ static struct dmar_domain *paging_domain_alloc(struct device *dev, bool first_st
 	spin_lock_init(&domain->lock);
 	spin_lock_init(&domain->cache_lock);
 	xa_init(&domain->iommu_array);
+	INIT_LIST_HEAD(&domain->s1_domains);
+	spin_lock_init(&domain->s1_lock);
 
 	domain->nid = dev_to_node(dev);
 	domain->use_first_level = first_stage;
 
+	domain->domain.type = IOMMU_DOMAIN_UNMANAGED;
+	domain->domain.ops = intel_iommu_ops.default_domain_ops;
+
 	/* calculate the address width */
 	addr_width = agaw_to_width(iommu->agaw);
 	if (addr_width > cap_mgaw(iommu->cap))
@@ -3312,62 +3317,73 @@ static struct dmar_domain *paging_domain_alloc(struct device *dev, bool first_st
 }
 
 static struct iommu_domain *
-intel_iommu_domain_alloc_paging_flags(struct device *dev, u32 flags,
-				      const struct iommu_user_data *user_data)
+intel_iommu_domain_alloc_first_stage(struct device *dev,
+				     struct intel_iommu *iommu, u32 flags)
+{
+	struct dmar_domain *dmar_domain;
+
+	if (flags & (~IOMMU_HWPT_ALLOC_PASID))
+		return ERR_PTR(-EOPNOTSUPP);
+
+	/* Only SL is available in legacy mode */
+	if (!sm_supported(iommu) || !ecap_flts(iommu->ecap))
+		return ERR_PTR(-EOPNOTSUPP);
+
+	dmar_domain = paging_domain_alloc(dev, true);
+	if (IS_ERR(dmar_domain))
+		return ERR_CAST(dmar_domain);
+	return &dmar_domain->domain;
+}
+
+static struct iommu_domain *
+intel_iommu_domain_alloc_second_stage(struct device *dev,
+				      struct intel_iommu *iommu, u32 flags)
 {
-	struct device_domain_info *info = dev_iommu_priv_get(dev);
-	bool dirty_tracking = flags & IOMMU_HWPT_ALLOC_DIRTY_TRACKING;
-	bool nested_parent = flags & IOMMU_HWPT_ALLOC_NEST_PARENT;
-	struct intel_iommu *iommu = info->iommu;
 	struct dmar_domain *dmar_domain;
-	struct iommu_domain *domain;
-	bool first_stage;
 
 	if (flags &
 	    (~(IOMMU_HWPT_ALLOC_NEST_PARENT | IOMMU_HWPT_ALLOC_DIRTY_TRACKING |
 	       IOMMU_HWPT_ALLOC_PASID)))
 		return ERR_PTR(-EOPNOTSUPP);
-	if (nested_parent && !nested_supported(iommu))
-		return ERR_PTR(-EOPNOTSUPP);
-	if (user_data || (dirty_tracking && !ssads_supported(iommu)))
+
+	if (((flags & IOMMU_HWPT_ALLOC_NEST_PARENT) &&
+	     !nested_supported(iommu)) ||
+	    ((flags & IOMMU_HWPT_ALLOC_DIRTY_TRACKING) &&
+	     !ssads_supported(iommu)))
 		return ERR_PTR(-EOPNOTSUPP);
 
-	/*
-	 * Always allocate the guest compatible page table unless
-	 * IOMMU_HWPT_ALLOC_NEST_PARENT or IOMMU_HWPT_ALLOC_DIRTY_TRACKING
-	 * is specified.
-	 */
-	if (nested_parent || dirty_tracking) {
-		if (!sm_supported(iommu) || !ecap_slts(iommu->ecap))
-			return ERR_PTR(-EOPNOTSUPP);
-		first_stage = false;
-	} else {
-		first_stage = first_level_by_default(iommu);
-	}
+	/* Legacy mode always supports second stage */
+	if (sm_supported(iommu) && !ecap_slts(iommu->ecap))
+		return ERR_PTR(-EOPNOTSUPP);
 
-	dmar_domain = paging_domain_alloc(dev, first_stage);
+	dmar_domain = paging_domain_alloc(dev, false);
 	if (IS_ERR(dmar_domain))
 		return ERR_CAST(dmar_domain);
-	domain = &dmar_domain->domain;
-	domain->type = IOMMU_DOMAIN_UNMANAGED;
-	domain->owner = &intel_iommu_ops;
-	domain->ops = intel_iommu_ops.default_domain_ops;
 
-	if (nested_parent) {
-		dmar_domain->nested_parent = true;
-		INIT_LIST_HEAD(&dmar_domain->s1_domains);
-		spin_lock_init(&dmar_domain->s1_lock);
-	}
+	dmar_domain->nested_parent = flags & IOMMU_HWPT_ALLOC_NEST_PARENT;
 
-	if (dirty_tracking) {
-		if (dmar_domain->use_first_level) {
-			iommu_domain_free(domain);
-			return ERR_PTR(-EOPNOTSUPP);
-		}
-		domain->dirty_ops = &intel_dirty_ops;
-	}
+	if (flags & IOMMU_HWPT_ALLOC_DIRTY_TRACKING)
+		dmar_domain->domain.dirty_ops = &intel_dirty_ops;
 
-	return domain;
+	return &dmar_domain->domain;
+}
+
+static struct iommu_domain *
+intel_iommu_domain_alloc_paging_flags(struct device *dev, u32 flags,
+				      const struct iommu_user_data *user_data)
+{
+	struct device_domain_info *info = dev_iommu_priv_get(dev);
+	struct intel_iommu *iommu = info->iommu;
+	struct iommu_domain *domain;
+
+	if (user_data)
+		return ERR_PTR(-EOPNOTSUPP);
+
+	/* Prefer first stage if possible by default. */
+	domain = intel_iommu_domain_alloc_first_stage(dev, iommu, flags);
+	if (domain != ERR_PTR(-EOPNOTSUPP))
+		return domain;
+	return intel_iommu_domain_alloc_second_stage(dev, iommu, flags);
 }
 
 static void intel_iommu_domain_free(struct iommu_domain *domain)
-- 
2.43.0

