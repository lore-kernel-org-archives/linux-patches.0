Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2072.outbound.protection.outlook.com [40.107.93.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C4D61B2EC1;
	Wed, 21 Aug 2024 17:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724261852; cv=fail; b=ImAguBEWLcKH1RXcG+9aVgU7bUrhkfN8IHW6BeXactqyebWci9ATt74jt2IjlFZzm7FY3qrHw1Ssb84kouLZlUUoElRSkJylDBXR6neDLTH+KkLGSGdSSfr3qYY6TZwGZQ7l1UVCLaNENH42BD7n6hgDI9nIim7DvmZ/Po8Y4x4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724261852; c=relaxed/simple;
	bh=LY1kCodQPF+hZOhkbtbF32pXSZtMJSZr0T4/rk9HAZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Mtv8/ZCg3/vyzei8MqeSCBrYSSVFER7KdC3JssTqPCy4xWTK1kz+RVFSs2csRjnkGL2LE79Vb5TqdwSBS1h2YV+uTqLcWBzhw6PkzRGJN33ImKO7UJcsZ+Db6qmCo4iZB0TRRWIsNzCVLJCqfDlXEZhksvQef3+Um/BwED0vO9k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=k5kzmBMT; arc=fail smtp.client-ip=40.107.93.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="k5kzmBMT"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iXa4SmTtjGV0HkJcQJ3uTXj1nbYA73gj5kH8JiD5EKErbWPMa7vZ0/TBZmFpGiP3thQDtJNrKC6jXpdVDwx/aO8V2C344YowDd46A5YhMwCT6Y5qDeGt9H+Ct49NiZIqt6U3q1FaH6Gr/j90YZzbjxnSfyGEUuJP9KDIcmvCIbMFqTjX8HHD59RgnvYf9v2SICpvVbAJ+x9rqi3OZbpzejNdouHos0qc9X9BBvQLNILlcKaMyct5jayO+1JXopga4naEsFH4gwnH5zwXhc+oFYv2waNRqk/rcwl2UBl++uUIAFH973l+NAf2XHcihSfrl0hoEEKMBaLKSJl262OCzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dx1DOUeaspXPIE4yf1p0KvTmwtAR3w3qyhAO5Pbqang=;
 b=hAsaFXOvqrl76xWWOfhfW8UVlpIeFEqJKSGMMdlEUm4lRNaksFVMtT7piQdt884eIlYRoKRxB8pptOAE+E3wnz+4DLG31xZbEumKAKBCr/ncZtI58AHd4JCAde+VLd83OSfbuH3PU2oVNe1sEf0dt7MLazmNrTaU/a5KC31lUb4T9p9EB45Au6/ywjC1Oyl5MuPPTZTllmZBRAK5mgpVvXQkhkQQxceniRayeswFDxpim1lQavlti3foHtUOf7XmdNYsUPv4/YwAEP6qfFaUI0deEXTO1k38aTUwY03Z5kvF0p/M7i3KPg1LzCgtc2W1VuEa56j8ySZXflA4lg/xHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dx1DOUeaspXPIE4yf1p0KvTmwtAR3w3qyhAO5Pbqang=;
 b=k5kzmBMTRg4ykECOeUX+YJsSHVZJIv3NneE2Q7R3Str2RpirOAKLakb0G3dW+ejRadZr6MeZ/tu6YAkqbAXHgSVfXc0vso2cPaXaE0g03F074eYh24MSPKHTAGtSfSN1n01SZYLmAgTcM/kJwzrCBr0xJn/sYuS4HR8YK9eQ2c5x/JcKFvY2O/3uHNgydaAAW9O9cpWGMFC99zYMgh09SWHHlij4eE/edS+CHUdr2QmCKuko7ALuL3Y9VBJEtOb4hxjEjDQ/GyT/e9FpJivApIYhDoslZwfOVX6FIZntNKUFNFUJguhNw0IYY95pYCz9N3UjNK46yyt6pQUjonwHbw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by CH3PR12MB9098.namprd12.prod.outlook.com (2603:10b6:610:19e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.25; Wed, 21 Aug
 2024 17:37:21 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7875.023; Wed, 21 Aug 2024
 17:37:21 +0000
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
Subject: [PATCH 08/14] iommu/amd: Store the nid in io_pgtable_cfg instead of the domain
Date: Wed, 21 Aug 2024 14:37:14 -0300
Message-ID: <8-v1-cdaaddf80abb+14190-amd_iopgtbl_jgg@nvidia.com>
In-Reply-To: <0-v1-cdaaddf80abb+14190-amd_iopgtbl_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR05CA0020.namprd05.prod.outlook.com
 (2603:10b6:208:36e::23) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|CH3PR12MB9098:EE_
X-MS-Office365-Filtering-Correlation-Id: 592b91ac-c655-4468-40d6-08dcc207e940
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5pSj7moxAS/gQXhSRlEWG/CDgN906XFhLlnhFrta65FeevFsdTj9htMckG0Q?=
 =?us-ascii?Q?F7hrIEZ5Fkpk/MpuIMHKtMF9bjuSLOyYKbdcbMgQ0lBFdQ1zpVJdsGkPg5VX?=
 =?us-ascii?Q?OXx03RRCorTsU8KAShUp9X8VYzF1T03u+IpKFwHrkWqVQ8aH+PJgdusGZvit?=
 =?us-ascii?Q?RGqDmwVEkx2QbXKc2sCvAHp4Yz1gqZMcNJJJ25xAx3PFU/+vbFfz9yT7uIji?=
 =?us-ascii?Q?YBF0Tqz0BS7W2YY7TPwhCDjpziMJYlke9/+npgWvCl1dbIORpKYyK+f6/KwN?=
 =?us-ascii?Q?SLlWetbLzUf6kaZBYwZqnhujSAYqwbT1fY0MvdGtvbtD8mGSicbG6hdIAHrS?=
 =?us-ascii?Q?21xOFdjA3hOXvaovPPRaCCRGUuLu8Gw1zXas0+WKrp87Kcw+l5hvCCFqnzJc?=
 =?us-ascii?Q?Sd2SL8jLLDH+UKObOHjpUlqoha3R2B7tZ/OG7kdNokmcQ5Ep9TZqAnHwsOO8?=
 =?us-ascii?Q?96RjohDuiNqHrJQmbRI0ntlmrFJSZA3Yc3eYLx/mUNkRsDTqnr4E8mtbPzwh?=
 =?us-ascii?Q?c59fT/QFB2JXArZMlyW+q5T+8P1IIMHSbctYEdbrBS6QMI/Z7Tv4PYVHHziS?=
 =?us-ascii?Q?PNXkEuUPce2k+gI/J4r2MhYtCmYMWDO+8ps09xF8hPHjphl8p2NNh+/xnwfC?=
 =?us-ascii?Q?Vpjl2DZz7JUh1iDn7cvc9ADNwehhTExA4Me3yN0j6v+zyBJE0MJTbhM2448e?=
 =?us-ascii?Q?k1im4AqIZMwKr6CGDPXVLzCi3t4V1CmxIWsR5ZmlpaxJJQpGh8zKVDFPSAXw?=
 =?us-ascii?Q?B7+Ss8LeKBSRARPUxhGp0ja/kFOij2l4qnT3hvvhiDpFtGbjVh68KwPR9bD1?=
 =?us-ascii?Q?Ek2sLPfXCBJx74mcb054zmv1EDSWrqlzLTgxjFfavVSP9+j4bOv5li5GFggU?=
 =?us-ascii?Q?6UfuzRRN2dPyPqzuZOnetDTY2wLPe1UWVfuLZwNYcpVbV5JnyG4zhckVQd72?=
 =?us-ascii?Q?IBM1muICVs8UxOOWI8Z2EKCPuVjBX75GKDMiJKR+JwlJQq+g1pX3Mxt+sOr5?=
 =?us-ascii?Q?u7wlZP8w2VmqcdcxxCIOywKMqd9pYpPEQILEw3wFtnyfSJ4oWto9BOKZeWbx?=
 =?us-ascii?Q?A2fCkaHy4vxvzrS8Yj0Kghsh7E6CnDuZnBpVTZC/tuYI0wilsrT6FOfH9IHc?=
 =?us-ascii?Q?xB+g8GhhazxqJ1FPQggLxNupef0XAx3qX91ck3fY8nGBWeGy/7ql9bC0sJU6?=
 =?us-ascii?Q?ijet7WO2cxEMMjKxn9jJ3h2sVFEF4JOafKmnoWNvmNWC/KSnNr53+Lrlw61S?=
 =?us-ascii?Q?himdKrUyN79NV/0xgVVKZ5BXZGQMvBk9MTWzt+G6bndTVqIrmhHxTMjVMx7+?=
 =?us-ascii?Q?OQlfLSq//qXksvgTR+9t1CCpSzinEOSE7n4xXUN2tFNKcg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8eYCousj+S6zBLEj83xSB2Rwg1FfoPbcLZZBJ+T6CjYEHoOZ72c7Z1kvUdmy?=
 =?us-ascii?Q?agSN3fRK+OAYlArTlEa+i5Y31nQ7gFbbdm9a+qWQkYBYheVsuNPA437qoXX+?=
 =?us-ascii?Q?0LJPBiP9OK7iy2+WXR2o7vRTxyxqX6wyEp4fzx7ImJ3wZzBdsR4+bTmVU4O1?=
 =?us-ascii?Q?EV/1QHl4R37zYN59LIwGp6/ctAoheZPBEaG/xjr9CaQ5RJUVpOpQW4DSZpZ5?=
 =?us-ascii?Q?y5z/dNwI6qaOmWHIUI21FzwriQp92CbCtPYXOKsAy/39F6B5VGQthPHCVDCc?=
 =?us-ascii?Q?pPp8Tx1a7O+Mtc4mZ5d4b5iarOdzuvA9Zm4nnaKBmKvqmVWATSVVJuMmSvii?=
 =?us-ascii?Q?Wfve6uiMR07ImR0xxcGy4WShTZqJKV30r0UVQ28rGSSjG7tGqU09pMJ5THyp?=
 =?us-ascii?Q?5sKoaYpxPX+LorVmVJfrMxqFqhqYvXIwuOvLXVsVYQjGZS5E1GpDyWwjlmTK?=
 =?us-ascii?Q?evGNcKbsIwquKkTVoj+u1UuGtvdo4k5S+tbT+VLXHd4QMWJ2BEOz2r/4/aR6?=
 =?us-ascii?Q?AGrDg2oA5b9/C9vIBnWFBXw7vx03rzyH298GIETX29jsYoXIZF8a/XZnugq4?=
 =?us-ascii?Q?KxblYMs8uYLu8JCsGaz5LVYC1rdPk7GpUBhEFJSNZyv17k3D5im0IBeEXoiz?=
 =?us-ascii?Q?lNboFiuZi4M+cN7WeKl6SNae7ZMVI7gKQXP3gvpeqmp02DXBx0zSV5i9cCdH?=
 =?us-ascii?Q?MD1JMIK1QWuKnEChKaVOgE7ZjBbydSSPDyElSVkBss7iXmj9cRs/3uw/gQVA?=
 =?us-ascii?Q?plfoTZUwvp+wqKDJQU+OXllJPKva8UgxdtTu+WBTru0QH01nB9pmaK4FUI07?=
 =?us-ascii?Q?NqdjhAmWBcf9/vroZTmowQLCJFkCfLbPSUER870MF4b7BFmQ7W8hDpfkEtv5?=
 =?us-ascii?Q?If+SrfiNnR7vxpzJ0pyRNKFhbGfn6XunirKJ8P8zLMySWyGgwsbipS6SdFgz?=
 =?us-ascii?Q?WYMOa9nhBxPMXdF7DGOzf1iyqNZw53Pt0Dla8vJihWlRId7cBCv3wLFYH3lI?=
 =?us-ascii?Q?F+y/hQccYhPhbJt0QRCD8j+bQXkeo2wvc2Q2UNVcipz0AfX3xS9DGdz1rb1O?=
 =?us-ascii?Q?+c4lQX92nBnyVYeUdYzfn4EDouruyPhsLC5qlrDlvjeqR8C9+rD9EA4/yFri?=
 =?us-ascii?Q?YQSvw8BGwm6+3EwiCSCiTI9CHCtIgeDzr+dlkKDXcP0Qs+YXzs8FZyvDI2Uo?=
 =?us-ascii?Q?NeS10Fs4zUeeGhB+u8c3KTdjBYPx8wSrjFvgA7ATzOh2rqKftoCJLy8pjHwP?=
 =?us-ascii?Q?5XfJ49ary9lW1TcJNbCmnv8cSvSpjeX3l6H5FO1fQcpSf0YmXsvHyQWghKsQ?=
 =?us-ascii?Q?Q3EyapsrwE38eZOQAerMPGeMls4ZEsqQkugsTHh/DumyacDlI1ztKKZpXcgk?=
 =?us-ascii?Q?HoJW3/3/EedBq5PZtKpaclEMM3KuRUOIsTG6UkidzUbVLga4X4hDBTzooZ8x?=
 =?us-ascii?Q?Xj3e6kWNKFOXP9DJYmBkKe5Bsm7jsDS5dHjW/LWA+afCD0Qsw99SyAXuzYmh?=
 =?us-ascii?Q?lXCnbT53SwDUvpJLtXnTPoLnZJgFtxsksY7a+dGGIk/XTdaNUKi+6DzOLWCe?=
 =?us-ascii?Q?CQd2duOSrOMXHjAFc2JvB3Ro2xwlnUglYJ3XA3ut?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 592b91ac-c655-4468-40d6-08dcc207e940
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2024 17:37:21.4588
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EaYhmCmASV7PiQ0Sot7v3S0bnE1MrIb2zOLcyaO4rCm2P1DU0vQCBZS17WYrkSHe
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9098

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
 drivers/iommu/amd/io_pgtable.c      |  7 ++++---
 drivers/iommu/amd/io_pgtable_v2.c   |  5 ++---
 drivers/iommu/amd/iommu.c           | 11 ++++++-----
 drivers/iommu/amd/pasid.c           |  2 +-
 include/linux/io-pgtable.h          |  4 ++++
 7 files changed, 18 insertions(+), 14 deletions(-)

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
index dab1cf53b1f3ff..d56be842c0b71e 100644
--- a/drivers/iommu/amd/io_pgtable.c
+++ b/drivers/iommu/amd/io_pgtable.c
@@ -145,7 +145,7 @@ static bool increase_address_space(struct protection_domain *domain,
 	bool ret = true;
 	u64 *pte;
 
-	pte = iommu_alloc_page_node(domain->nid, gfp);
+	pte = iommu_alloc_page_node(domain->iop.pgtbl.cfg.amd.nid, gfp);
 	if (!pte)
 		return false;
 
@@ -233,7 +233,8 @@ static u64 *alloc_pte(struct protection_domain *domain,
 
 		if (!IOMMU_PTE_PRESENT(__pte) ||
 		    pte_level == PAGE_MODE_NONE) {
-			page = iommu_alloc_page_node(domain->nid, gfp);
+			page = iommu_alloc_page_node(
+				domain->iop.pgtbl.cfg.amd.nid, gfp);
 
 			if (!page)
 				return NULL;
@@ -560,7 +561,7 @@ static struct io_pgtable *v1_alloc_pgtable(struct io_pgtable_cfg *cfg, void *coo
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
index 3840b3ede65d32..1cdd1675a01af2 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2037,8 +2037,8 @@ static int do_attach(struct iommu_dev_data *dev_data,
 	list_add(&dev_data->list, &domain->dev_list);
 
 	/* Update NUMA Node ID */
-	if (domain->nid == NUMA_NO_NODE)
-		domain->nid = dev_to_node(dev_data->dev);
+	if (domain->iop.pgtbl.cfg.amd.nid == NUMA_NO_NODE)
+		domain->iop.pgtbl.cfg.amd.nid = dev_to_node(dev_data->dev);
 
 	/* Do reference counting */
 	domain->dev_iommu[iommu->index] += 1;
@@ -2271,7 +2271,7 @@ void protection_domain_free(struct protection_domain *domain)
 	kfree(domain);
 }
 
-struct protection_domain *protection_domain_alloc(unsigned int type)
+struct protection_domain *protection_domain_alloc(unsigned int type, int nid)
 {
 	struct io_pgtable_ops *pgtbl_ops;
 	struct protection_domain *domain;
@@ -2288,7 +2288,7 @@ struct protection_domain *protection_domain_alloc(unsigned int type)
 	spin_lock_init(&domain->lock);
 	INIT_LIST_HEAD(&domain->dev_list);
 	INIT_LIST_HEAD(&domain->dev_data_list);
-	domain->nid = NUMA_NO_NODE;
+	domain->iop.pgtbl.cfg.amd.nid = nid;
 
 	switch (type) {
 	/* No need to allocate io pgtable ops in passthrough mode */
@@ -2365,7 +2365,8 @@ static struct iommu_domain *do_iommu_domain_alloc(unsigned int type,
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

