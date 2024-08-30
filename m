Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2046.outbound.protection.outlook.com [40.107.220.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8347837B;
	Fri, 30 Aug 2024 00:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724976393; cv=fail; b=aQopdmLHq4pZTk9Rc9ZYuYHSGDbVYLleajNUUultLEpVc1nGJURp++r7lRL7Eur92HXgySL0C6HNlWJ/NsJ6RVc5OInZUUTGIcY2LsONH5sV3d9wR/e9nGvr4/1x1Db8amXVP652mVHmFhdrQbPj/qW+npOK2ou/Y2tM0NMs5LI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724976393; c=relaxed/simple;
	bh=jXpaop4P7gIUSCaCD/GjqSyCdd5eTUGOD0fcpVJQIZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UNI9Fu+Q2wZGpZDIh7geCGv5BpV8DYAzHXSGfCnboZbgcGKKHQ99mifPYSC8cwkFPSDCkH29JunzJb3uITOJeY/oEA/+RoERDa/m/ERBXURaW82ZhsybBIf3uXhWeAV1Mz5myP/nrPZKiYH847O3MOkZKipdWtlDOexA1Sjz//w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Xir44TJX; arc=fail smtp.client-ip=40.107.220.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Xir44TJX"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kOUvkmWRcwoq9f5Fz3I17zdXeiKn5nvcDZqs/uwxnEMFIHqd3/77k2GsuZWkwY1wlTEX5DUyrLpoeXFeFm885p5mdfZVSoLlXOk/XflDJd+CZdIM2jHlnvvbCkVemRG0B45f+MQtKps7dLq01II0bNC56BwBgcTOKuFnDO9yVWo8fDWr8g5qRhEP4hdlBVhR5AHcLNUnh095LBGLSGYUzd9Kqv4t2SwE0xN6tufX7U35FeNEGZywhAan8mFUxRtpDzhBs1AbNJDYvvt/BmgkkAYZuFjucCyeIQAixP1p3CYPhIgUoON+4BD8NJUZMaeKmqPK6ZV/kRDKDX1hsgoo1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hln9Aqg7kId7A3g4eNyoVwmYu9EaGBdrJ3hJ+rW6Hqc=;
 b=H+5HxgpLc17EpUeD+69YCUwUgEw7uPBCCVQdRuEfnNaP/callco2D6f79Zvz7S/IYpAQJx6utXZcN+u8on71/UfpRUgpx4S19uzf9Ljb6WhC+o1H99avsRzRpcMlP3+xx1Tldev61vkbW/KDV48a6Ps3s2K0LxhTSQtLVBMBPwkMwjVQTg2j429y+DmIsQzpfFmze2G1+OjOQmvOa/KHGLLOlKXszZxIqvTI8fDaEXblvNy0+aTbcFAn25fIgvwtvPA3HrFIkgIcItzY5T4hSnAMDEunE2pYjkvHBU+y5HdFeoUIi49x9Pi/sgCNmypTlfWY/zU5DWKIzDYTf+b2YQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hln9Aqg7kId7A3g4eNyoVwmYu9EaGBdrJ3hJ+rW6Hqc=;
 b=Xir44TJXO1TOOlfOaZhFcQwUtH75SUWPlewI4pGbxg8EUnD7T1LeiI/7yQKLOmjiinQ6UYb0XjpX6X89LcSW7q/Lzy5UMoBoQQCWn8YzZrjPrusatzuDKaquV55ojvXFha/NHrgId9dePnLfqMzHD0wYhZhjUH/+uC5nATYdc/suChpYwruH7KkkZUsiWfTJTS/4/VCo6KDtdcuxgsrj9IkVQYFb6AN0ad59E/GbU2riISw4HF8fmfLdDsaq09lMTNIM+8sbqCS39Hz/P2yq12SegKuj0I4QmNFd5pcIUJby9ZNrjrz+wx3i3PjMgPgJtWAL8vAq10SQQP1vtPGMLg==
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
 00:06:26 +0000
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
Subject: [PATCH v2 09/14] iommu/amd: Narrow the use of struct protection_domain to invalidation
Date: Thu, 29 Aug 2024 21:06:18 -0300
Message-ID: <9-v2-831cdc4d00f3+1a315-amd_iopgtbl_jgg@nvidia.com>
In-Reply-To: <0-v2-831cdc4d00f3+1a315-amd_iopgtbl_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0930.namprd03.prod.outlook.com
 (2603:10b6:408:107::35) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|CY8PR12MB7415:EE_
X-MS-Office365-Filtering-Correlation-Id: 9639b76b-c672-4efe-d934-08dcc8879606
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?oX5OCpkoZwrN53dUD3PPpGcgptmi3EsfQjKsasQvHHdBh1B0g0/Ew9337TTB?=
 =?us-ascii?Q?s/whHXQl7SRweYvqiEV8zbXQ7xzPmUPHrIfLLRAwhj3XWaKGT80NuCq65kXu?=
 =?us-ascii?Q?yCZcdOXFTDW1OOd+SCYvmseeUuK9KPMWqX23SlORdSQOrA0sEhgOpjO0efTk?=
 =?us-ascii?Q?itvDEGTFjxLdc6L0H424YeJorswCB3Yom/13DaH9lh9X4MC1+vgaosJWX4eo?=
 =?us-ascii?Q?/kvnmCV14cozl1+g0vpqsckih1uDH3GDGbaUI4YpH9BsWVr4/l8q7rSGmwgX?=
 =?us-ascii?Q?M5G4Iu+q4xPDIalxGhHw42pD9oB/zWHW4sijSsHV2cvAXwr1hFftvsJW0M4E?=
 =?us-ascii?Q?URrJKIEN5EkttPVeycy+mlwmEW+vJEUZ7SrFxGPYnnXXx5vnvbNB3aO70hLd?=
 =?us-ascii?Q?GRbs0CKWNOQ/RYS/zCSHSN1Xn5c99OLv/DXoL6ibJl1ONaxIBfhW3kiJLSB5?=
 =?us-ascii?Q?2GWx+mwYam6IoSMXW/pGd9sqP12XraCIUBAeeKxDGivM8VjfwgsS1VAFKMNB?=
 =?us-ascii?Q?JnFnv6GROkjI/ew5a02EWvyQ/UvmrsgmxLo9CP9lr7w/5KRWbZZgneLwSs29?=
 =?us-ascii?Q?bHAKZG7DXT7ZJYXorXtm8H/GtfJUQhfxyrutnTEW0g/una3SRA6k0U1qEqsM?=
 =?us-ascii?Q?htiar2l950OYbHiE+XYVo6sOi7n3lMpEYJJWumsOxFZ+aouZqKJnrFzjsHEP?=
 =?us-ascii?Q?CS1cw9AhEJZLJYvjxDXMXQAB7vG8xPOK9bsobELBJc/fWetExY8YLDCeMebf?=
 =?us-ascii?Q?bahX8h2KKz1xqqpNln9SIP44yscJL9kFbD+1jBYes2jGdVioNl1krV0lSvbK?=
 =?us-ascii?Q?ti0VuQF+AjHu0c/vszaqIPu44d+20tmpseABr8xq9SCLALjE7ZFFWRMOboZe?=
 =?us-ascii?Q?4MTPcaEmHUdZbuDvgWqemzSgHhtCij37hVCrmeEuBtSRMRxkrOiENavj6EI8?=
 =?us-ascii?Q?viyBWsBXvAvsf+CZDbbd/1pA8mlHsVNpwx8IX9aKo/AeQdkNm7J/NXVqjx7C?=
 =?us-ascii?Q?4KgiydXnvXrL73glaXJTZuQK3wBD8xUmyNHhqmtjmPC2POID37R339+a21ta?=
 =?us-ascii?Q?/wSA1XbcIxzcJjDC0I4HB48HM5wDLhrKsSHirQHctkfYaX4Qo3+Vyi7WyZCj?=
 =?us-ascii?Q?E+ipyuJFmyGBVkZFsfOlHsvPNMfN4ysShpd0YFy9So+nJN6QPszU9FIVReZ4?=
 =?us-ascii?Q?zJqIpovWpN7rZ7RGnlDzml1vadtRGpq+v+EkLJc6VWKilg8cij6TuJrb4bfd?=
 =?us-ascii?Q?GWRCfeS1SBTAJ6rmhjWEls5WNDBn3g9r4+S3uYNsHm+pgXoiQXHTP40l6Ow4?=
 =?us-ascii?Q?EK+FZkDG79VwLIjeqoEOvT1UT688A9ycwIZ/epyN1S0rzA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mtOkbjEdk1WedemP3vPfAc/pbc/9/oh0hP9zNbtRf3zMbHOoRVxEG4VsaZVZ?=
 =?us-ascii?Q?/M2oIe4OP+aV5QBnNlltGIg/fW8foA7bLcdiXMcP4huuqDAviNl6Y8sV36yT?=
 =?us-ascii?Q?dqWcQnD72zKqM+AzUoUcPbAIRg6thTbL+vpG/x5SQfj4QA1hZg7bY/lpwRQP?=
 =?us-ascii?Q?oEZfetEgu+Ey3ofzTwBtsS1lU8iN/wACZP1z/qpRe8An+8Mibf3K2X8QPLWJ?=
 =?us-ascii?Q?SgxKfRGl53S4A+ZoECu+op47MqUIqobT+f2mGq3dxtOnn5TdETWILk/fvnI6?=
 =?us-ascii?Q?+wftljU2XUOMl6BKu4nCbLMPn4FUVkmfBJMutQgV+O9HXbhRB1CVf9Kcd93y?=
 =?us-ascii?Q?abBBrPMnaLzHpbPuUC5myWWhT4Yuo8DpHZkq3crRFrdXFFZgzdl5XY26A1CG?=
 =?us-ascii?Q?EexHoujpr942UD/s9kcClO1DeeTDGhll2QIRWA4zMiuHqvY2zhUcWIh7Djyn?=
 =?us-ascii?Q?pp20Of/8wVavisz0FEp17a09Fa0fF+Vii5Zgs3cQqLI1E9pr58fyW5vAMb08?=
 =?us-ascii?Q?hfWndlobbfu+CsGYISWQ9J2ada51KcL9kCAjLr86bEuTzuugCBy8AyaJ3PLQ?=
 =?us-ascii?Q?PZ/pUqeieISn99rWyFB/kMZwV6i1EO+B6eBvzib/AVZ7ZHiL1cy5ztSkwd6D?=
 =?us-ascii?Q?6jQUNmL8/3HHQhpK+k2UQ0ZmretYRv+uh9VGXqt5qLNb/6caDLp3YI+zClLb?=
 =?us-ascii?Q?F29hq+FpOLWVz8dygeIOAz+I2BJYIAAWQYBxufsWQ7TxxsF5l4Nr0ieeJBSi?=
 =?us-ascii?Q?+UwjxzlxgEN+OxOXknTSOrAhvvmgfUTXyOfmoHhx5n5iWDCqN3/1z/+JHWzK?=
 =?us-ascii?Q?0+/qShbeePxqFnLIQtOfCxevTqN+SueXHTq7nGlPDyk6KPmP9AQmSq0DptQb?=
 =?us-ascii?Q?3q7gbfTzxDnkPL5ga8qrHXrsA1T4NXwYYNVYna6YqDM9W5SmxJsqLwEbunvZ?=
 =?us-ascii?Q?0+dVJkqe6/E1vPBnZlxRm39R2ja8DIz77Nf5cnEpHJLYh/s8goqaOG0XrXnA?=
 =?us-ascii?Q?iPMTN6dpdtk3LzL5G1uQ7QTFLXpYmbeqtHLhT9IL23gOLHreFX2rYtTy/DL5?=
 =?us-ascii?Q?GgqVbJavrSjW0qDSbikBFeJacsZ54gZWzoP1swoHwFR2MSfgfaPdtjpyCO0L?=
 =?us-ascii?Q?OAIcxZ9Rt+D3eaqrE/0hSWXVueKBIUlSneOnBpNEM6l6c9Dbvb+GD/G/ENaj?=
 =?us-ascii?Q?Rcm+P8zPMiR+vn1NN2lp1kMiGZZnZjC+2orGalZrZNdL3AEwGox3VHAisaHR?=
 =?us-ascii?Q?5wOf/YU1jF+K/4Nhg9m1ktzgx4ROrUXaP2KVO1KRodBal3EF3CAyhDuu2U4V?=
 =?us-ascii?Q?XDjSaHBKaEwMMk/34eMX92xy5igxYt4HbB1+3s8grib1+GBeD3jp69XqXgIc?=
 =?us-ascii?Q?vfXxODmPbtmKV+46GProatTTXTEdFdies3unghhMKlGa2HjFYAClENz8pWQI?=
 =?us-ascii?Q?nqWgvn6w8xIfaSzpQeTKvfr2hOs5UBa2NO6ei4k2ysuTZVHxAUgpBS0YqapO?=
 =?us-ascii?Q?/ZVyNiHl6FQBoAP20hK3hTAJI5iq86B+csFSe5w1xnJgTuLf9NGVxsjjFOkY?=
 =?us-ascii?Q?cYQKZCE/3nZQhR50xN4OHoBTnKixdqaWFJM9zEov?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9639b76b-c672-4efe-d934-08dcc8879606
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2024 00:06:24.4105
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FWJoacr/80bca8NM5AfmfMtPiu8wyMhxuiiDjdPaYhwPw3Snz2VzcwjbikHYRcxN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7415

The AMD io_pgtable stuff doesn't implement the tlb ops callbacks, instead
it invokes the invalidation ops directly on the struct protection_domain.

Narrow the use of struct protection_domain to only those few code paths.
Make everything else properly use struct amd_io_pgtable through the call
chains, which is the correct modular type for an io-pgtable module.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/io_pgtable.c    | 33 +++++++++++++++++--------------
 drivers/iommu/amd/io_pgtable_v2.c | 11 +++++++----
 2 files changed, 25 insertions(+), 19 deletions(-)

diff --git a/drivers/iommu/amd/io_pgtable.c b/drivers/iommu/amd/io_pgtable.c
index f71140416fcf6c..667718db7ffde8 100644
--- a/drivers/iommu/amd/io_pgtable.c
+++ b/drivers/iommu/amd/io_pgtable.c
@@ -137,11 +137,13 @@ static void free_sub_pt(u64 *root, int mode, struct list_head *freelist)
  * another level increases the size of the address space by 9 bits to a size up
  * to 64 bits.
  */
-static bool increase_address_space(struct protection_domain *domain,
+static bool increase_address_space(struct amd_io_pgtable *pgtable,
 				   unsigned long address,
 				   gfp_t gfp)
 {
-	struct io_pgtable_cfg *cfg = &domain->iop.pgtbl.cfg;
+	struct io_pgtable_cfg *cfg = &pgtable->pgtbl.cfg;
+	struct protection_domain *domain =
+		container_of(pgtable, struct protection_domain, iop);
 	unsigned long flags;
 	bool ret = true;
 	u64 *pte;
@@ -152,17 +154,17 @@ static bool increase_address_space(struct protection_domain *domain,
 
 	spin_lock_irqsave(&domain->lock, flags);
 
-	if (address <= PM_LEVEL_SIZE(domain->iop.mode))
+	if (address <= PM_LEVEL_SIZE(pgtable->mode))
 		goto out;
 
 	ret = false;
-	if (WARN_ON_ONCE(domain->iop.mode == PAGE_MODE_6_LEVEL))
+	if (WARN_ON_ONCE(pgtable->mode == PAGE_MODE_6_LEVEL))
 		goto out;
 
-	*pte = PM_LEVEL_PDE(domain->iop.mode, iommu_virt_to_phys(domain->iop.root));
+	*pte = PM_LEVEL_PDE(pgtable->mode, iommu_virt_to_phys(pgtable->root));
 
-	domain->iop.root  = pte;
-	domain->iop.mode += 1;
+	pgtable->root  = pte;
+	pgtable->mode += 1;
 	amd_iommu_update_and_flush_device_table(domain);
 	amd_iommu_domain_flush_complete(domain);
 
@@ -176,31 +178,31 @@ static bool increase_address_space(struct protection_domain *domain,
 	return ret;
 }
 
-static u64 *alloc_pte(struct protection_domain *domain,
+static u64 *alloc_pte(struct amd_io_pgtable *pgtable,
 		      unsigned long address,
 		      unsigned long page_size,
 		      u64 **pte_page,
 		      gfp_t gfp,
 		      bool *updated)
 {
-	struct io_pgtable_cfg *cfg = &domain->iop.pgtbl.cfg;
+	struct io_pgtable_cfg *cfg = &pgtable->pgtbl.cfg;
 	int level, end_lvl;
 	u64 *pte, *page;
 
 	BUG_ON(!is_power_of_2(page_size));
 
-	while (address > PM_LEVEL_SIZE(domain->iop.mode)) {
+	while (address > PM_LEVEL_SIZE(pgtable->mode)) {
 		/*
 		 * Return an error if there is no memory to update the
 		 * page-table.
 		 */
-		if (!increase_address_space(domain, address, gfp))
+		if (!increase_address_space(pgtable, address, gfp))
 			return NULL;
 	}
 
 
-	level   = domain->iop.mode - 1;
-	pte     = &domain->iop.root[PM_LEVEL_INDEX(level, address)];
+	level   = pgtable->mode - 1;
+	pte     = &pgtable->root[PM_LEVEL_INDEX(level, address)];
 	address = PAGE_SIZE_ALIGN(address, page_size);
 	end_lvl = PAGE_SIZE_LEVEL(page_size);
 
@@ -349,7 +351,7 @@ static int iommu_v1_map_pages(struct io_pgtable_ops *ops, unsigned long iova,
 			      phys_addr_t paddr, size_t pgsize, size_t pgcount,
 			      int prot, gfp_t gfp, size_t *mapped)
 {
-	struct protection_domain *dom = io_pgtable_ops_to_domain(ops);
+	struct amd_io_pgtable *pgtable = io_pgtable_ops_to_data(ops);
 	LIST_HEAD(freelist);
 	bool updated = false;
 	u64 __pte, *pte;
@@ -366,7 +368,7 @@ static int iommu_v1_map_pages(struct io_pgtable_ops *ops, unsigned long iova,
 
 	while (pgcount > 0) {
 		count = PAGE_SIZE_PTE_COUNT(pgsize);
-		pte   = alloc_pte(dom, iova, pgsize, NULL, gfp, &updated);
+		pte   = alloc_pte(pgtable, iova, pgsize, NULL, gfp, &updated);
 
 		ret = -ENOMEM;
 		if (!pte)
@@ -403,6 +405,7 @@ static int iommu_v1_map_pages(struct io_pgtable_ops *ops, unsigned long iova,
 
 out:
 	if (updated) {
+		struct protection_domain *dom = io_pgtable_ops_to_domain(ops);
 		unsigned long flags;
 
 		spin_lock_irqsave(&dom->lock, flags);
diff --git a/drivers/iommu/amd/io_pgtable_v2.c b/drivers/iommu/amd/io_pgtable_v2.c
index 1e3be8c5312b87..ed2c1faae6d580 100644
--- a/drivers/iommu/amd/io_pgtable_v2.c
+++ b/drivers/iommu/amd/io_pgtable_v2.c
@@ -233,8 +233,8 @@ static int iommu_v2_map_pages(struct io_pgtable_ops *ops, unsigned long iova,
 			      phys_addr_t paddr, size_t pgsize, size_t pgcount,
 			      int prot, gfp_t gfp, size_t *mapped)
 {
-	struct protection_domain *pdom = io_pgtable_ops_to_domain(ops);
-	struct io_pgtable_cfg *cfg = &pdom->iop.pgtbl.cfg;
+	struct amd_io_pgtable *pgtable = io_pgtable_ops_to_data(ops);
+	struct io_pgtable_cfg *cfg = &pgtable->pgtbl.cfg;
 	u64 *pte;
 	unsigned long map_size;
 	unsigned long mapped_size = 0;
@@ -251,7 +251,7 @@ static int iommu_v2_map_pages(struct io_pgtable_ops *ops, unsigned long iova,
 
 	while (mapped_size < size) {
 		map_size = get_alloc_page_size(pgsize);
-		pte = v2_alloc_pte(cfg->amd.nid, pdom->iop.pgd,
+		pte = v2_alloc_pte(cfg->amd.nid, pgtable->pgd,
 				   iova, map_size, gfp, &updated);
 		if (!pte) {
 			ret = -EINVAL;
@@ -266,8 +266,11 @@ static int iommu_v2_map_pages(struct io_pgtable_ops *ops, unsigned long iova,
 	}
 
 out:
-	if (updated)
+	if (updated) {
+		struct protection_domain *pdom = io_pgtable_ops_to_domain(ops);
+
 		amd_iommu_domain_flush_pages(pdom, o_iova, size);
+	}
 
 	if (mapped)
 		*mapped += mapped_size;
-- 
2.46.0

