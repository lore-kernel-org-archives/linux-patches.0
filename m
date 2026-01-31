Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011048.outbound.protection.outlook.com [40.107.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C7F14A60F;
	Sat, 31 Jan 2026 00:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769817656; cv=fail; b=VDrtYl3YduwFepWvY6Q56pce6BZSY7fyBimLUKIOWJBp5Pn9NquW8Gq5m0OLi4hB6fWia6zCfA2nEAf3K9JKFGMcMQZYr3vfR10ZQUdOAAV30PphQ9MoNhaTENBQru5enLj29HhwHmrJMLkNDoIfqnB3Vnnorhn6veyhmi7Oaps=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769817656; c=relaxed/simple;
	bh=tOvzeUN/NKk9b0xdTsy4Vc5N9xYds88yiGyQvPge+OE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XgSO1bjJXhIx/zl0kows/NyJb2zofjcKNAqbDhZ+Q2H7WBUf8HVZyBYIsP3i4DSx/9gXQ8roruFBXN1juRSWAlyA2DvI1y+268sytd2euHAjJ9KQTxmiSIgA4VUXQkf717ZiQk1phFXFthwcVlR5zbgsmM8hss72xjOGgfdfQdk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qQGXHCEr; arc=fail smtp.client-ip=40.107.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qQGXHCEr"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ps/It4c2Z1DusKQF8UEULX0LubHZFg0Lgzl7Mvg0u25w4Tb5Prwe6ZY48ghQIUxKB0kR4XU1XTWqip1rvDmwdyUDYPhEfwlvn3mQgj7kxbQe6CfEaNfj8EoKmN7j6hPfI3Jb5WqMbyQ5msD2qECjy7J2fkoj4oQ995Wlsh92PvvFjEV7SL28UbKAUrmYnb7E1ZPE/S6OPfkU+V6D2ouVgr1FLuLqKEhFcTAM1uSxx15hSIGkPQtoCiwDRIBdl9EwKox9rC6+MBUOVcGd7HXyPj4LJHOOmMmHXO+isewAK3b7e9/zCXp6nh6g2BOCsIMMRsBW4YWLj/vZsKJ47XEWnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JMKyyJZ5pmfvmF7G//vJWQ1T7lBtca/fwra/btaBOtg=;
 b=uIm1JBLJZnDo9L7zUUqRPHsm8UQlTiGIwqMteynDTZTqf2O0MlkiZzKE5R0E/KoaE6EwaAPahZVXMWasS92H2yHrZ/z/+JB+arFZNu8bMWdLapIZxYhkq6D7M8sPLCdG6Ve61DnbVx8fIAA4rfIrwfVNI3iCI0OVDkIeWwhkuQZN/2kswEDtA+STpis5BF2TM5kGeW9iWoeEcEMD3XL2VDrpnVBHhsAxZdxJwWvbJsOVtwYnMj9iuHGIx8gDVXJv2pKXS+do/vNTpF/qRfBrOg1M7mrtYBBvA66v/pXv9dt2kXp/p5szdNgA1Wr/ypf8mFowyvkmRXe/Wv0XeOWeKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JMKyyJZ5pmfvmF7G//vJWQ1T7lBtca/fwra/btaBOtg=;
 b=qQGXHCErQuNslXrxoc6ScR56bAsjoNTWrPc2KpE1S2YtlGU1uhh/2FQ1oxlHu5sNMW5zNiTRBR0dGQoul+ELIh/m6VNqwwK1ix9zVkvv68zJ/dAhRcT2tNMqz2CGii+VvKm5bLa+Dj8CEPDkZta+HyxSooScrQUn2x9WGrXdoiTrFDRpJZFnug6wENTz5vgL0zwfcNWCdT1mg6h0Tcu1KwlmXhygCtWhZBProJaTAKGG3WoXhjQ7lQkP4DjCzZlJHltz9rhdlUQrt03nJJt9Mf1Y2AZFHW2F9zx7OZyTYkXBTE58DBsQXxDmSQ+vYGV5eB9fcyRXluSEl1oVayt/ZQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CH1PR12MB9672.namprd12.prod.outlook.com (2603:10b6:610:2b0::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.8; Sat, 31 Jan
 2026 00:00:47 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9564.010; Sat, 31 Jan 2026
 00:00:47 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alexandre Ghiti <alex@ghiti.fr>,
	Albert Ou <aou@eecs.berkeley.edu>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-riscv@lists.infradead.org,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Tomasz Jeznach <tjeznach@rivosinc.com>,
	Will Deacon <will@kernel.org>
Cc: lihangjing@bytedance.com,
	Xu Lu <luxu.kernel@bytedance.com>,
	patches@lists.linux.dev,
	Paul Walmsley <pjw@kernel.org>,
	Vincent Chen <vincent.chen@sifive.com>,
	xieyongji@bytedance.com
Subject: [PATCH v3 2/5] iommu/riscv: Disable SADE
Date: Fri, 30 Jan 2026 20:00:42 -0400
Message-ID: <2-v3-9dbf0a72a51c+302-iommu_pt_riscv_jgg@nvidia.com>
In-Reply-To: <0-v3-9dbf0a72a51c+302-iommu_pt_riscv_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0171.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::26) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CH1PR12MB9672:EE_
X-MS-Office365-Filtering-Correlation-Id: e9038c92-49a9-4b7c-51c8-08de605bc8b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Ff3WAzBqMCEOHWR5FFpt0vV4M5juUNV7EBC7ga/53ChzxhiwSwDpUTjvZBLX?=
 =?us-ascii?Q?CxFCYvR5cVZCy1htrMIIGdGROaQTxD2p+RAnpIM0hrGQQkAyeSLZm/rIGvgO?=
 =?us-ascii?Q?G8mdg5JoGS+9HTdhBgZJNDXouBDTdxvZY+0TQ6WnhBXCNwx6PPJUO6dpqsxu?=
 =?us-ascii?Q?oXt0Yrf16gTFpPnsTHqDicLxVx10B384QGXbsZGi48V599qw8jhhhd8gw7Tq?=
 =?us-ascii?Q?hCh0UhBzWKt4tctcVFAIVNawVKKEExYgCaA3YyhDgP9uVmpkrj76CO7IPGpt?=
 =?us-ascii?Q?6R3EWDinTKPiQK/4hY9kyyLCQNJhM/Pw5S82o68woOkccRQG2ijOpCJDEstj?=
 =?us-ascii?Q?z/FY4gutpG8014Yf0EiMatVIQGCGyzMnigpEMw+iag7uHaWBkAy5/Rlhtl0Q?=
 =?us-ascii?Q?hdowk31vIF1Nv/xzpV931m1EFIi0zSIUvupzABYh5st6TRuwspjbW+DbRFbN?=
 =?us-ascii?Q?a8OQpKdnVXrCRE5prB7q3qnEPDkMMHxO8cujGGjArqjBM4TbdN3VclycKlQp?=
 =?us-ascii?Q?ApNnGpPdNdFLXzqKX5QaBdGZUfSDD4Wzg+iZa0/ieNw3huFJ5Xaj/N9JasoN?=
 =?us-ascii?Q?YUDsOlg4zfeNi9tqxKdZ9JLt07CE/q+DFUzeiheSRBj59laBBlsN9QMJG9LX?=
 =?us-ascii?Q?108tRcTzmDFMOtW3N1JREKQr5lvz2JQ6ZsgbjyDjPZVbAbfo2wa5+K40NEq0?=
 =?us-ascii?Q?ERpuSJ+kdPNKaUE8kRuoV/ZEcHVy4ZTqMwThhGojYfVABtdLNKXgIjAMnae7?=
 =?us-ascii?Q?IwRVdusfssqoxwcAub8/9JWMQncXiEhsIeWjKrPURy4fZ0qy9CK7cOOfAB/j?=
 =?us-ascii?Q?ML8TaALbgdfAQQr3OXy22toJJL2r6rd155iwzat2jRPIYgi6q9V8quGH+aph?=
 =?us-ascii?Q?M3y59gBxfNwyWajR2O1mfu2HDf/bzc2kbGkUog7VoTnnfF81igLGcevDQioc?=
 =?us-ascii?Q?0sY6StaXk4dDbMsT4dsurxymaap3EyQcL8E0xXSyVYNdcLAB/3vUA9UmawZ1?=
 =?us-ascii?Q?NLoIsse2zMPvvSKnicsrTheSFRRW5IRhmvyAc01+jd4o3mItxux7IuTdgSy7?=
 =?us-ascii?Q?W/hEXtoENy4+bMkszLiu1SGjG/jpdiopuTO9f8Zc3y2yQCLt9CpIK0MC5UDU?=
 =?us-ascii?Q?9brBDNYTbEFTQ9M0CTK0b7xFG/uIPRu/JBE4QgZdReyN6hnSSJv7yIgP2LoI?=
 =?us-ascii?Q?pHG/FewlgYWdEPIzVOyIMttdFq/Lfh96TXdBE4Z7H8uf6ZC4FS9Tq2T0KyH3?=
 =?us-ascii?Q?zL/+S9FtL0O0U2VZz51Z2Lu3AEXr2D17yo50brhfC1YLZAR7OOBxNSY57cPK?=
 =?us-ascii?Q?k3ICQTQrb8sUHAzvl/DKRgeGz08y3NAsQSQgGrrdcmptcRIrnNYU0e3cqkWO?=
 =?us-ascii?Q?avOSS8MJ//5YsecaTP0qmW6ODtWBaHGcnvd13RwymZEWtHRXYQCHCj+N8XoV?=
 =?us-ascii?Q?6bxn101AB3saVQQYtNyBR2jY36240+5yjbG3uiwVZWS4kJA59zNyDUqu6w9H?=
 =?us-ascii?Q?1wnvciDxVX032hTjVhPaa0hKz9YRMKGqhBjnLCaL6lhPsd3A3D0YdK3PbL/v?=
 =?us-ascii?Q?haozqT1Kr6/Fnu1P4bc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8z+ue8k57n0ahyrBwSdMxU0CtbYf3LmV2PitMEahV0UgiLNm4315TKf1/52T?=
 =?us-ascii?Q?7wIcDpdH+maN+dSeCr9hXtJchMZorrSoWAnvJsV3N7FVqTu4I0Mbj0X2aOhN?=
 =?us-ascii?Q?OOpPUwb4RjUUshZOUMYnO4XowHi+ZBlOLF3O6sZWHNZbOSADT0/e4E/wT8yx?=
 =?us-ascii?Q?rMzusQ6x/39DkENMrwb33NhCOde+1G1/D0FeQWc71mHyFwT+Entjk+Wbxc/k?=
 =?us-ascii?Q?4f1xkoOM4uCSvQxpQk0cUYupLL9FPACb9rmqXTAPg5PIqPGN1V7abwQdL98u?=
 =?us-ascii?Q?jaUaTnNEmCIeV07mNfzjxpAYj1WoUDsl50kwp4/vRKn5vEzVpBcvlLGlEbXv?=
 =?us-ascii?Q?0hV4cLo28nOPzCSbxLeWfbjoNmvtNzkjz2Qi5O2r2CDRC3eH8SQHUSBYkZAJ?=
 =?us-ascii?Q?qGNosw3ufdCi5rkTOcAyoT19DhWVIpxGmNPVlLQGM34qlrOnXpxtm6Gt2X7N?=
 =?us-ascii?Q?r0IMrp1lwMg7HQW0ZF1+5mtRpJAa5AW4DF7vd25pT901SyJ4UUdFJRHwwOiB?=
 =?us-ascii?Q?9P1jTdRICODieqqQ6Kc9Jp71KTjcpOxD+lQKwl4fC6nYB4cFda1AQmtV2fnd?=
 =?us-ascii?Q?gWzG0InwfAx0gUMhUyG4uh09fytLQzVtOuQljdt0MKyMkXw7YmEeovne1ptb?=
 =?us-ascii?Q?vjkqqG4hzfs2Y4p7qTfbh0glp4jcFr8c0/Q8cPvoEirml0FWet3Ev1aucS9X?=
 =?us-ascii?Q?Y/zLzIXF5y1GfddPpRigvRJUZbQccCK0EWFADg3m5ZD3OQoiNMWhlDul/4Te?=
 =?us-ascii?Q?vKABc6wuwIv7wiLoRvPoKfMfpOIr3DAhw283pUWCiuXQPu3j+0ZTBCT5XPTv?=
 =?us-ascii?Q?VWQFHvIA9E0t/A4NKLl9XSBho/dPOfrJblq0wD5lcqgwFc3eaugivC9gPQxc?=
 =?us-ascii?Q?s8Kip+lgWfkiCyHImsSOqy01l/EdYzgLGVuKWDg8Rv93wD6u8jA0bkXqRIz2?=
 =?us-ascii?Q?dokUf/b+4woRqH0AxJY0JC+I095zKveuKis88O5DDUrsPhJ6fYY/E7QMjNKO?=
 =?us-ascii?Q?CTqEPLNkvwVJaM5I/GcfjUGhrQjUnC6nvfoYkCB75eKrW7Vrn2a66WFXhO/J?=
 =?us-ascii?Q?7hPosM1d+zathul4/usz7VYKkrMLV4kvEAjfhZBocBSihIE5HEYyK7tYnoZT?=
 =?us-ascii?Q?RJkLHP2F4lN3g+ODTwBOo/coqpYbIRigRrwxDitTuj23W6KtseEz+mi5ZSIx?=
 =?us-ascii?Q?L2oxSyxHyilMqMwslPNqdSg15QwgWHHyE9+gUkRABDphKbfklm23+B50hqmM?=
 =?us-ascii?Q?y9E7k3XQJaesasy70eauy6/n3Nw/0byhEcsqD7AvSkLNnAandxUf3vpnDfjc?=
 =?us-ascii?Q?il9GlGZ2QzuXFt9+SytBW+9/x3tkg1oXA0FQj+J01RdKPfL3LpoXi+yBnv75?=
 =?us-ascii?Q?/gpcRhnrAKJiQtu2CpbjKTMN1F0toqis24lam0g23Bm1mVS+yDl2Vt8jpIW4?=
 =?us-ascii?Q?VrSWa9gX1P04B+d4rFPSqbKJeDuOrSgxceBYt+Y1NR9XtNCAp5sQfbPtGaDz?=
 =?us-ascii?Q?rFLxia0UDAkky/z67NvM7qTjTZPP2hohCJW5/ImEFFIYh5MS1+T0tqOZaRzK?=
 =?us-ascii?Q?V4c1HZAZp9oQL4fkWtcNsDA4TI+FJquJqjX7J6qt6AcgSaeEChl2yTJ1qhAT?=
 =?us-ascii?Q?Ee5yJ2vNKr4mwEtb/3b9fv+Jdwxm0q2y11GBgblXPDI7Gx3aYaMld7sHlNlL?=
 =?us-ascii?Q?dZb3V9CTXirQUJ/pqAuh5SNmdbAbPZBcL/uBYNw3fmO3DMUz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9038c92-49a9-4b7c-51c8-08de605bc8b2
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2026 00:00:46.6155
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f5CD7TEGWoXawb/GpnTGSBsFvbZ+3YquSlB4J3+6UlqGfNiNZzMcvwf4/2KOGbf5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PR12MB9672

In terms of the iommu subystem the SADE/GADE feature "3.4. IOMMU updating
of PTE accessed (A) and dirty (D) updates" is called dirty tracking.

There is no reason to enable HW support for this, and the HW cost
associated with it, unless dirty tracking is actually enabled through
iommufd. It should be a dynamic feature linked to user request.

Further, without implementing the read dirty ops the whole thing is
pointless.

Do not set DC.tc.SADE just because the HW has support for dirty tracking.

Tested-by: Vincent Chen <vincent.chen@sifive.com>
Acked-by: Paul Walmsley <pjw@kernel.org> # arch/riscv
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/riscv/iommu.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/iommu/riscv/iommu.c b/drivers/iommu/riscv/iommu.c
index d9429097a2b51b..f57a5b457076e0 100644
--- a/drivers/iommu/riscv/iommu.c
+++ b/drivers/iommu/riscv/iommu.c
@@ -810,7 +810,6 @@ struct riscv_iommu_domain {
 	struct list_head bonds;
 	spinlock_t lock;		/* protect bonds list updates. */
 	int pscid;
-	bool amo_enabled;
 	int numa_node;
 	unsigned int pgd_mode;
 	unsigned long *pgd_root;
@@ -1201,8 +1200,6 @@ static int riscv_iommu_map_pages(struct iommu_domain *iommu_domain,
 
 	if (!(prot & IOMMU_WRITE))
 		pte_prot = _PAGE_BASE | _PAGE_READ;
-	else if (domain->amo_enabled)
-		pte_prot = _PAGE_BASE | _PAGE_READ | _PAGE_WRITE;
 	else
 		pte_prot = _PAGE_BASE | _PAGE_READ | _PAGE_WRITE | _PAGE_DIRTY;
 
@@ -1387,7 +1384,6 @@ static struct iommu_domain *riscv_iommu_alloc_paging_domain(struct device *dev)
 	INIT_LIST_HEAD_RCU(&domain->bonds);
 	spin_lock_init(&domain->lock);
 	domain->numa_node = dev_to_node(iommu->dev);
-	domain->amo_enabled = !!(iommu->caps & RISCV_IOMMU_CAPABILITIES_AMO_HWAD);
 	domain->pgd_mode = pgd_mode;
 	domain->pgd_root = iommu_alloc_pages_node_sz(domain->numa_node,
 						     GFP_KERNEL_ACCOUNT, SZ_4K);
@@ -1512,8 +1508,6 @@ static struct iommu_device *riscv_iommu_probe_device(struct device *dev)
 	 * the device directory. Do not mark the context valid yet.
 	 */
 	tc = 0;
-	if (iommu->caps & RISCV_IOMMU_CAPABILITIES_AMO_HWAD)
-		tc |= RISCV_IOMMU_DC_TC_SADE;
 	for (i = 0; i < fwspec->num_ids; i++) {
 		dc = riscv_iommu_get_dc(iommu, fwspec->ids[i]);
 		if (!dc) {
-- 
2.43.0

