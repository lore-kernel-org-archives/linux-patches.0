Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2046.outbound.protection.outlook.com [40.107.220.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C685E182;
	Fri, 30 Aug 2024 00:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724976391; cv=fail; b=qP+grTAMd6itrLk3JX52+H6w+WlHLlh4VAgEbkbg1bjNCFJydRESnGg5FZxakzItF8em3Gz1yweeUUfmJkY2Wb6UcYnM7mNcRv2Me+GXUyPijUY2V0dC1yhfgktTnCCONBVnK3EKz/XHNyu8a8lWT/fzHDtfajNmOct5wxfxrG0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724976391; c=relaxed/simple;
	bh=dQF/BJWuYD5NsNrdTChgMsE2omHCyaq6JqiJYrUcFhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hPVDxAKhQh5dZEb0Z/LZrIiXpheNMRSU+32hWDfvSaJGdph+8TdM9v2XnJnLJl6cp+M9TYOyQmH+zR8sEu24qNYXUfy8VlMfisJUMT0ioOcU7zCEB1ejN1P190qFfkoAhIDH0/wl2RvvZVFgUPQGQCBrrJppTRf0JqftN3hONwA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=io1qjPdI; arc=fail smtp.client-ip=40.107.220.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="io1qjPdI"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G2MMk3KVG6c/E4G+EwQdwq2Ush5mjBmlxtNB1e8Bk+pDcb57zdl+mRMZznDvDVeYzMSQY0dZ8PxKYt8xr3pnWXrtgVPSssNbqlZm+PC9tQ9WFQYv9h6nK+xObMYKTBDO5/HVNwxa/48+FFEAehtn8g8qGp85eRJ4EKNowycJQW/j8xUQiLGEKYbnaoHv58jGenT+cob0w8AIEek/2/pRdL0TBqkJlskJZ3ZEp2AQtYBvH3y51nVAj/DBEcjw/x2B+MT+fj/6VR2DadujHVOP/8PrTQ9YXCZiI2YIHpAjScsHQbnCrrpVWiAPlbpvcxXwXV1+ZuOF5stQZOAcjhXv3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KbgRCdIRGRtW05ktzOFJoZ8KoQxcJIrJlGBeAgAlt2I=;
 b=LbZYrY1qm2dT0w84isdV+w/NXCYMdjIUFsOG9cpy8z/y4T9NfD94z9SxjveWd05Ge7SySdOpnZGBGX+JBq606cZf6mpDk5Bsl4a1uBVDZS6qI1RcyHHQrKOQnBCkwmn+JThFq6RiUS+sZ0pjKT6OizGXGZHEi6+kmBAOuGj5KKG5J4E8DxY3jxtQGGLQnkFilX5W1yvlidaVuUWw5eFzplA18T5SCjuMVWLCF3hMjconqNyt1mTYZmrx78DMCB9U00bEOKxB6GguzoZi3ZXDtTWq0mFYJ2/8iWyXExNZQ1F0laQsaNsrwGhe6yiYuDQ/lRb2w/pR+gmn6XKlZCImRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KbgRCdIRGRtW05ktzOFJoZ8KoQxcJIrJlGBeAgAlt2I=;
 b=io1qjPdIjK+POh0qxto9toaVaCQeHxTFrpjPRwz8NFUf95a7xA1EQm0DW1HPVsp0070GOp2NCL7Ykv4rdvU9taTOgt9Mf9GlKEHUMW9UhI1BYyZjYVo/ADTF70JrN6Jf3DHd/YkBxCgKr7C2YMhi+YJd6ak1HPN/Dl34/rBml7ART5vqtBGNnZwZoh+pbRmsI9Rah5QJb2We5avTECgKNf9C1A6NsjOM3VusKO6mUfCxtEwjMW+iirayBoXek6J3KI3wPAS3uCDoETwcir4thRMu4e0ImyfAw5G+p0uyofdc2qQmvSXxYZ+pLvgEVVIYNKQkX6GrmpNaKmAuI03GMA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by CY8PR12MB7415.namprd12.prod.outlook.com (2603:10b6:930:5d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.20; Fri, 30 Aug
 2024 00:06:25 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7897.027; Fri, 30 Aug 2024
 00:06:24 +0000
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
Subject: [PATCH v2 05/14] iommu/amd: Remove the amd_iommu_domain_set_pt_root() and related
Date: Thu, 29 Aug 2024 21:06:14 -0300
Message-ID: <5-v2-831cdc4d00f3+1a315-amd_iopgtbl_jgg@nvidia.com>
In-Reply-To: <0-v2-831cdc4d00f3+1a315-amd_iopgtbl_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0791.namprd03.prod.outlook.com
 (2603:10b6:408:13f::16) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|CY8PR12MB7415:EE_
X-MS-Office365-Filtering-Correlation-Id: 038825c4-8a05-49e7-0f41-08dcc88795ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qEuhUl7+N/LI++inopm0E9xnyOn0t7fW/v/ZtPkZZpphtCNuca/sAwlnDihX?=
 =?us-ascii?Q?Dm4K68PL/cM2tvaYBwurRWxFjSwWjhOOSgeDqbp0tLqMKq+oP7wg5QtL9eH0?=
 =?us-ascii?Q?tOlWKpq/6MEGiuDPXqXidt86CwWfBaWFf0wyovl92qHxzhQpL0oUFVW8E6fP?=
 =?us-ascii?Q?nH2pkoeLh9tNieGHEKkRxG8XxoNQO7Hn+qDoVjMdvVcKo5gPFobl10CLGaCO?=
 =?us-ascii?Q?6M4We+Z87dyz0/MUQMRmKSynalwzpnxI9Bj8AOJtYDKEtyCnyXX5qvN2iKw8?=
 =?us-ascii?Q?UlIjKVvj1zllEiq9sBVMuu+uDICfZmE2H94QERSGXZZOBJvXys78pYz4hzsC?=
 =?us-ascii?Q?aLkek2XaOsnAeivXgWtvnnP+Q/WAFl6FtlUiYhNXxqoTVEDrfhr7kAOjxwMN?=
 =?us-ascii?Q?Oxs4eaB/Vc1GqhhgyVI2MCDnJ8A1U4d9N+zLplrrDbcdyqB1cCH3UgrYeBLy?=
 =?us-ascii?Q?f4EP/jjirv5gbAGM6IrH0kg6t5dWXE2zRjvX0dC405PViW2loAuvLFfOibBc?=
 =?us-ascii?Q?FqlQCkINTkhJs3HRJVOLX6JKo0ngdn2qYW8Lr0CHHnPX2FE16TnqKsm0yoIA?=
 =?us-ascii?Q?zkro3Wg9kd2R9FhzBaXiwOsazKC1qx9TVAI20KVSKUXVOHBYRC3sP5mDdywI?=
 =?us-ascii?Q?uXqEKM0NhtzDf0mbj1p3pMnfjjuhBrMy5rujgx1e1qqDvGdoiqvxwAjGR+Eh?=
 =?us-ascii?Q?DGRcQQN1wtN0szbvWWAWR+G0nQcbm0MrwClnXXULihjyRLqKzTl6OUKisUYT?=
 =?us-ascii?Q?syVIpBleTc22BcNVSHc5rOJdfqU/17Z3ljEfEkA5c1PmTsI8D1pk5k3KnkN/?=
 =?us-ascii?Q?EQscJ7H1eauHhBu+OHfBEKGFtB2rnbkeuF2E43FMGClluPTqWmYnGC3M4ddL?=
 =?us-ascii?Q?RcJx98b0Cas8TzIktOdJ6c1V4ZhHHrqgsiOSy7gs8RwLnKi4QoXLdHlhbLra?=
 =?us-ascii?Q?nuWY/pEOMbIiaQddPX/04ebrHKn62y/PnLuxqYvHzB0ho10Af0uMiup69lDw?=
 =?us-ascii?Q?PB6WkonvmyHvmBwcyTNF0/SDfF+a+uOsJdy0/BkLOWC1zIUykCNM8qhrtZkS?=
 =?us-ascii?Q?mK8Z1ddELKIhIU71TRKVdUU+PNmYE0r+uIBvIjjy7vSdN/pcWfDapPteGdUz?=
 =?us-ascii?Q?M0f4x+apibymCe1stOF1BFD3vDdjdzLWDV1qs7Dgcm63jcXo1po9cntrJePW?=
 =?us-ascii?Q?KRm4rbq6EgQTwbtDXnZ23J1wqu3Pm1tKdtsY1Dv+uniX+ZYqUylDnyFJFGD7?=
 =?us-ascii?Q?2ij6dYlMNM9aC0qXW9f4Xr2UEU5nBwxr5lAjMalRZVMu2ePkHm0Lo0a6gK6p?=
 =?us-ascii?Q?R/Rt53E7uHEsV+Rd7TvY7YKGhwMFysASvIRdQBCufla2/g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xaNN6PbPN1LfmO3FSIKoRa7pkjBINqjFg4SQLp79lZerorSFdMxYmVF613wo?=
 =?us-ascii?Q?CX7vHM/NAo97NL7MwAh/9XYir4MC4m3ROscYlJ9VN1k5IoJJ3xpKJkKVChrq?=
 =?us-ascii?Q?Y/PyXEGdN6hTsSLTIlBqpq7jPFRWWwvQ8UhTGNpsjv1c8iiHiJ/ReCuauUEP?=
 =?us-ascii?Q?oU+6XRj0q79uBmq3K7V4VAoe+7OWErLpGVEXKbDJ3nMGgjMTB/jC2rWW8OKH?=
 =?us-ascii?Q?91g3D/3R5oiexk/SPx4UTVpM5p1nf4x07X5DuOZ9YYuzSk2mURGKTCMmZ9dn?=
 =?us-ascii?Q?ptOe0miSdqAuU5+ZkPI7oysOEdcjbxRmsyBpiNwhDxs+pgMaCXHy901jv5zN?=
 =?us-ascii?Q?VyCkkJFrzzIKKsjmKXrgQG9mgDwUw5PyC5ujPXz9Mww9o64gdNPacttkpRgF?=
 =?us-ascii?Q?oNDLhgAHyOAPj7dCShhimQrVla9HExi7FkRCEyQS0eDYUq/d161CGS64FNiN?=
 =?us-ascii?Q?91RAev/ZVDSTEaH2Cwb0qDvroPmsJDSIZJ4rztrk3V9zzw65n4nRVgdGWfFn?=
 =?us-ascii?Q?ZeaxvDRdfWZysoxf8OJw/PLIC3v7hWiknME8Bnlo6+IktHCusiJxg/kAXQKc?=
 =?us-ascii?Q?bUK5d1TYOSYhD2sGbYYgm+Md88Dbiy5Hvo15EcKA1hlUCZUUdZfAzZJ6wYvG?=
 =?us-ascii?Q?yqDjQhsC3ru7us5LOD9Nd+ME942Lev4+Md/fXKl9DJqAwX0qkF5jcDkbxqF8?=
 =?us-ascii?Q?FPZvgj4t5v7aERgVIrQ4VS0OzJBOhas58/uhzjUhQSm98R0hqupPwUN3Aoay?=
 =?us-ascii?Q?RYHpAVAy381KUi27V3OM1BlBp2TuK704oGWepqVVHZQH5ivJ/PdS/J3Glj65?=
 =?us-ascii?Q?yEgfzlcHCBy9kqWXgHWN6cmEVOY1PXaeS9yUiFQ8XxHrwpAJ4pbvt9qLCZhx?=
 =?us-ascii?Q?8tiWT9mrZVuvwXfOzP3+jAXBx+G2rCKj/q89LMSHTwGc5NE8clv97VuYP3k1?=
 =?us-ascii?Q?+vzc7EbhxLOUYFXvGoTaCCU7o7SEDge3udb5HQxpm6fjy7MawCZS00PLN5Fp?=
 =?us-ascii?Q?coDHwfdYpRqj3sYkEBdi23uXN10a3eeTcubIExpj4hlNVQDJT7a1qsDzIRvA?=
 =?us-ascii?Q?FHwAhTLHd2jOl5YqNDR1Dj/lLKVN/JTG929F1RQraiw/uXw/1hJ0c68lC76i?=
 =?us-ascii?Q?omfvcDPkK1lyTgrNdWaVxDBZXEZCykH8sOIdqYWsc1uVEszeokrPDTsFrBtb?=
 =?us-ascii?Q?HL8qCGHgEMftOUofeedMRzAdV9S7GDAhSeQA9SixGk719qXxCU1omoRfpgDv?=
 =?us-ascii?Q?r/5nGhYGfhN6imLqTv8WVxQJCTOpAalFRKUX5lN0em0cyStJYk5519FabYlA?=
 =?us-ascii?Q?nKvJnTCiRSiuYISoJwrvLbfqQEwTjTtOKHKOdrTDmK9NBhyIIhj9fZmpD47g?=
 =?us-ascii?Q?UqVyYh+RDjQVAl2Rn8RokQn+9epwOdLY0z2O1X2m5XVnhsUOICuzb0o7zbNM?=
 =?us-ascii?Q?NxjRPri7N00QoMUTTuhfxabi+VGNv8CNo6DUiZ0LnJ/bFGeiMrZKO+xTpYeP?=
 =?us-ascii?Q?leKTfJNwezvGFAq3yLXdP/7Gu8rOoTA3yQiYzUVRRBMYCkLZtGyfgoyH3BWE?=
 =?us-ascii?Q?5/82Z+79BOoC5kcQm6tfp2sdDfMsI/b0gmOIb//r?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 038825c4-8a05-49e7-0f41-08dcc88795ee
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2024 00:06:24.2472
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xgSiriXFBOE7j0DrAMuEdETRk+ZVRu94uJNK4pRbmL8EVZol9AjXoJ40sMBT1ohd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7415

Looks like many refactorings here have left this confused. There is only
one storage of the root/mode, it is in the iop struct.

increase_address_space() calls amd_iommu_domain_set_pgtable() with values
that it already stored in iop a few lines above.

amd_iommu_domain_clr_pt_root() is zero'ing memory we are about to free. It
used to protect against a double free of root, but that is gone now.

Remove amd_iommu_domain_set_pgtable(), amd_iommu_domain_set_pt_root(),
amd_iommu_domain_clr_pt_root() as they are all pointless.

Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/amd_iommu.h  | 13 -------------
 drivers/iommu/amd/io_pgtable.c | 24 ------------------------
 2 files changed, 37 deletions(-)

diff --git a/drivers/iommu/amd/amd_iommu.h b/drivers/iommu/amd/amd_iommu.h
index 2d5945c982bde5..5a050080d2e814 100644
--- a/drivers/iommu/amd/amd_iommu.h
+++ b/drivers/iommu/amd/amd_iommu.h
@@ -143,19 +143,6 @@ static inline void *iommu_phys_to_virt(unsigned long paddr)
 	return phys_to_virt(__sme_clr(paddr));
 }
 
-static inline
-void amd_iommu_domain_set_pt_root(struct protection_domain *domain, u64 root)
-{
-	domain->iop.root = (u64 *)(root & PAGE_MASK);
-	domain->iop.mode = root & 7; /* lowest 3 bits encode pgtable mode */
-}
-
-static inline
-void amd_iommu_domain_clr_pt_root(struct protection_domain *domain)
-{
-	amd_iommu_domain_set_pt_root(domain, 0);
-}
-
 static inline int get_pci_sbdf_id(struct pci_dev *pdev)
 {
 	int seg = pci_domain_nr(pdev->bus);
diff --git a/drivers/iommu/amd/io_pgtable.c b/drivers/iommu/amd/io_pgtable.c
index b3991ad1ae8ea3..5278ba3f676c45 100644
--- a/drivers/iommu/amd/io_pgtable.c
+++ b/drivers/iommu/amd/io_pgtable.c
@@ -132,18 +132,6 @@ static void free_sub_pt(u64 *root, int mode, struct list_head *freelist)
 	}
 }
 
-void amd_iommu_domain_set_pgtable(struct protection_domain *domain,
-				  u64 *root, int mode)
-{
-	u64 pt_root;
-
-	/* lowest 3 bits encode pgtable mode */
-	pt_root = mode & 7;
-	pt_root |= (u64)root;
-
-	amd_iommu_domain_set_pt_root(domain, pt_root);
-}
-
 /*
  * This function is used to add another level to an IO page table. Adding
  * another level increases the size of the address space by 9 bits to a size up
@@ -177,12 +165,6 @@ static bool increase_address_space(struct protection_domain *domain,
 	amd_iommu_update_and_flush_device_table(domain);
 	amd_iommu_domain_flush_complete(domain);
 
-	/*
-	 * Device Table needs to be updated and flushed before the new root can
-	 * be published.
-	 */
-	amd_iommu_domain_set_pgtable(domain, pte, domain->iop.mode);
-
 	pte = NULL;
 	ret = true;
 
@@ -561,23 +543,17 @@ static int iommu_v1_read_and_clear_dirty(struct io_pgtable_ops *ops,
 static void v1_free_pgtable(struct io_pgtable *iop)
 {
 	struct amd_io_pgtable *pgtable = container_of(iop, struct amd_io_pgtable, iop);
-	struct protection_domain *dom;
 	LIST_HEAD(freelist);
 
 	if (pgtable->mode == PAGE_MODE_NONE)
 		return;
 
-	dom = container_of(pgtable, struct protection_domain, iop);
-
 	/* Page-table is not visible to IOMMU anymore, so free it */
 	BUG_ON(pgtable->mode < PAGE_MODE_NONE ||
 	       pgtable->mode > PAGE_MODE_6_LEVEL);
 
 	free_sub_pt(pgtable->root, pgtable->mode, &freelist);
 	iommu_put_pages_list(&freelist);
-
-	/* Update data structure */
-	amd_iommu_domain_clr_pt_root(dom);
 }
 
 static struct io_pgtable *v1_alloc_pgtable(struct io_pgtable_cfg *cfg, void *cookie)
-- 
2.46.0

