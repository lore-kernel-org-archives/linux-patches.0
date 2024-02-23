Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2077.outbound.protection.outlook.com [40.107.93.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3990C143C40;
	Fri, 23 Feb 2024 18:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708713857; cv=fail; b=gPwIvLrPa1zzp7FuCZkRjtrMHkuVFcxoYccisAMWyUJztUb4CMgb+JxqJ0Kf1mGilIgMrYuSCllsHKfiwOyuhBhvJhEVIJU52ZvV8RJ4MbW3+tdlgUsAr0HinjShoovSetHFgjXW/6gsOEfatjsCAJeZ4pH3VM3booHgdOkBCW0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708713857; c=relaxed/simple;
	bh=LZCOn102Rcbdk9qnjWdoEZh+srOaQDNQ5p5f8nrmVxc=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=LmND2raADtcGSf+X3Hq8hzavPr+qW+GWj3y5tRV5lM0zpXbZrYOrwWLGRyib0VNLOv9Zz2L92oiZb2mOFkWDNtOFYm2JI00Cej2YSBn4kVPuhoK7+T0BtZtYT9SqfPUwfCXu/0S9NlodnkYT+0emNn/x35PWGXva5c3QXy67ZpE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=rolBw7oP; arc=fail smtp.client-ip=40.107.93.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="rolBw7oP"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LSi9HhNqSS/YcywcZf2ZvKmlPkyKttVK78XiF7QjU3LCFaorgwoc63V6hzLqTlYnRVceW6oscW71e/QEdBMcQYpt2mvFI0tgrGIHseuFhWRttlDvAG3NDGaWPTZnn1LH8qhLRXY1lJrDXNYLJSYzsY7F9nK/34RbktFXI5uZ+vina7zT5CeIcuuCrZXop2WmNFVvIaRvtofoscbStL25+Yt+6s/PS9ZqPVLSfzj3xPPv41TT6VXLdsXpMmlm1Q9PJRcJuS0XTQlkRJ0HWzzGVUOcDFyvQkiTFSS/yizf8WyDEObqp32IAhTgabn/pxtCt4QU0LqF/p66RVD/4mGaKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iqqeboJnwqWF84h/PAmxVpZuzFc9En4DRWDiyVj54t0=;
 b=N7iCGXcx6uV9f9eznulqYpdnpSwWzlXmNRYBt8xavzeJORB29uIJtu1PbcnbR3TUQmMIbW5AGk8bwvuoKjYfRJa4J5wzxqndK2CqFHR9+vM61R2GBgD3Y7wydaFNc2lJHYkozEBZ5VapoMQJjJeTbTRWq4cXQBS+oicmA8f3h0d31gyViQ3EQyTYgyf8faJkFbXe7CJ80wEC7uqHTNR/FDFO5U0iTa8EAWcXqZC6nGLayfhkk4PxBQ7HEgF9LdwFzLhgWvG63Bojp06ZCL1IClZvu4HfhMIkeugk+ogU2gVePcMciwzsqBMvQs0qjClHkCwyrobJnvhhGjJpeG2EFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iqqeboJnwqWF84h/PAmxVpZuzFc9En4DRWDiyVj54t0=;
 b=rolBw7oPg3yjA60JdR2hvEM1wmcH/7yifrvTLsezTOPMKBp27p3TIZpkfQspA4LvbV9NF+UEreQViYPhX309xzEBzQy7LBWgOqNr0ApPR6uO0WDMLt41hhMCcStL1xR0J7w+wPAy+BiXoJOsxIxwLFLN2DTj5/ItTxWW9med7HOSOYKuI6DSkORhFW02/lZcCsm+TShXkCBrGiO2i2TtmlzmgwN8nTKzX/2vcuqChz1lRA7c9SK5UQ/ArydARvwQUHcd32Cc69KXSeOYmEx0OoTv1MgkxITWIzkWHw/b61ShOcbKNfiaUmmsTVdsrfmilDJwnN7zB9tkKioSs5g3vw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MW4PR12MB7117.namprd12.prod.outlook.com (2603:10b6:303:221::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.30; Fri, 23 Feb
 2024 18:44:10 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7316.023; Fri, 23 Feb 2024
 18:44:09 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Kevin Tian <kevin.tian@intel.com>
Cc: Joao Martins <joao.m.martins@oracle.com>,
	patches@lists.linux.dev
Subject: [PATCH] iommufd/selftest: Don't check map/unmap pairing with HUGE_PAGES
Date: Fri, 23 Feb 2024 14:44:08 -0400
Message-ID: <0-v1-1e17e60a5c8a+103fb-iommufd_mock_hugepg_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR05CA0033.namprd05.prod.outlook.com
 (2603:10b6:208:335::14) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MW4PR12MB7117:EE_
X-MS-Office365-Filtering-Correlation-Id: 4513ee9b-699a-48ea-9bae-08dc349f6bdb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	c9i+QF06ZoY338nNE6jBSLDfH2Vm6fGZ8bbhcHVXRlcVjfWmO6mcBYpFmw8MSb/IhICQLsj4Go+MD0AFwCekd55ZQZ+eet7J1GdUcCdo8UFXPD5dQefy39/z2Il24LMtTKBQtX2tyKWEz5OvVn7LsSNNsCWbk3uLT9S9+Nn9w34ZUQ5DpLiAT+y0bOq/1CVEsr9KpkZyjz+KtznHnXRnWD9Jktojc0tn5LSDjB9QFuH/gaJLHOuMxSeh3TvxGjsQM1Ow4FESRB2y82P7m8uQrgZ7Ohsz/xjrpviMlxdh+ohD0kWfBrOwBK73O0qME++NgtWanpFlVxf7hZmt5tZr4MKoQ8NR5MDM9cf2EwAn7ehHwK8sw/pgIMUbMYoNCbFNJrM/t21jTZuygRjTovC+mLGp+OA2BaYtmka+eonIgiBXh4YiLJ2J4MTUVbxtt5+pWNWrHuXSPBnwkOW0BMYyvDJCZ52XxfLky9qHnBUHgakDJlX7x7F7/wIsPbnKxBPTUxAvgyrGEzA5v3KGE+jjVLm8tLtCazmCtOXLGkkxPIywB0fb3j0fDXhOOBrrlpuY
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(230273577357003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?31TAT221VazEFT7/HN3ZUPlDXYCXKGBIkGlHtAcWofQgmEy5UYI5atiOWCLc?=
 =?us-ascii?Q?f0k72Dr5Pmh1MO4dPYqX048epSezghTVsIvwWJjSwlHYa4mc9baf7lLKUoNC?=
 =?us-ascii?Q?RdarosyNRXtmdzlX2SyYMA2k9ue6C7BKAD1dxum5ITlBnWLOKZy08iWGMRDz?=
 =?us-ascii?Q?AgnVSsvERSDie/cU9r9wAL8CtwV/xXcdzaGNVfE3EWvfO9SyzZJuLnAzrHoO?=
 =?us-ascii?Q?U93I/FaCHzGnr2oRdCanesQ2WAtZ/Ecc1HiJHqHZtXy4SBRk9SJ7u6L+kwQV?=
 =?us-ascii?Q?MdZ2PzozHej7LqqeznXSMJ1aGEaNkojtFwi9L5pkL+U7iFgCXFo3jn7sP0I+?=
 =?us-ascii?Q?e1cSWPDBzwPEjWrib9FVd/hTQ0+VgaJ3zfbezEIUZbGsP2izQKal7M02KGEL?=
 =?us-ascii?Q?njcjGX3Zt8WyLCVOiLdqMH9cvgaXdhHYo8lpNh/G80/rk3lFC3EsvNmfwbiF?=
 =?us-ascii?Q?pVumGbt0YdtAx7qqKDdg07XPl3reQEtj7RhS0zTdPV0xjpaX+mcx0F+S4wLy?=
 =?us-ascii?Q?vL6VT62PSrZs3DAMtpG26Rny3WNv5rXQzciYfUYmhX1IqQ2kjZCO4in7wxCQ?=
 =?us-ascii?Q?cq8Z5DnkNhlajggD20vgAfx7uzc1vFqQ62K8Ndkasx19VtqQS1oPB1SmZEjZ?=
 =?us-ascii?Q?3D/2cd/HWPe+aCqfPbD88dNc+FYiQY6qrl3FmPEOFXUo3YeGZgp7yypHV+fY?=
 =?us-ascii?Q?SbvGWATHjUpljLrQyzPBCj0Wp4nSAkpMU/28mEtCuNBapgGLkTezkQI3cCFa?=
 =?us-ascii?Q?5d9cpP079w52OVDBtKlFqBGwgbwCYK51NRv8j5khB+tbCueut62VAVlMz61F?=
 =?us-ascii?Q?SSemHsd1q6TZ38nEy51RJ14/34eshnkC86WJf8LJeOHn3pg3rn+11il8LMHu?=
 =?us-ascii?Q?/DdQvM8/5exNSqTSgLfCUGVkmgkyGd1D5mEGrZkFwD65VIY8/cQ86v/g2pVA?=
 =?us-ascii?Q?o+K1OJ3hrpfqcsFi3EkGI8wprgOz9ANH2adDIvohJB75tEKcrn7OUlblhQsU?=
 =?us-ascii?Q?RD6NI1I1BDaTKTxbI7UR3t96OHUNuqwI1/weiSagEOP9ZcNgL0L2/BpsSy8p?=
 =?us-ascii?Q?HkyqfJWOGsUhUkGp71iDutG6wOK8I3eq7UtxCmmSZT5k+b6vqLqU5BZTgTEb?=
 =?us-ascii?Q?d1EEB7uupryZVlT3zyHmaVna5PdsVQM0OFru4zBYmYhdqY+EyeKYEs4pRsvW?=
 =?us-ascii?Q?PCMxitOaethxVOM1hZUtnGGJNOGLwzGUiISE1oSEWAzop3er88SRKPQvzoPg?=
 =?us-ascii?Q?W1eTuugIMOqqpFbBRYDUxBWP9HqESi6IlNNDc4WCpAd0oerhWKuoPlD/lxU0?=
 =?us-ascii?Q?1gDNb/7UMrOjtn8lPNr3gUQmgOMWQ2ExB4oh/vsX1hIhzqmmcg1V5IrMj1cU?=
 =?us-ascii?Q?gQYs4cfrgWDU2sBfU+1jTRs+y4EouegyZdXm6a4kAqAHcs0YpkVhPprmTw44?=
 =?us-ascii?Q?O8wOmFMhbFiAPbiZRrIk0FFDIX6rSWDaU4tvKl8vLgWhXhC4m7GzfCk1Ur+f?=
 =?us-ascii?Q?eruFcajMeRR+wHw1X+iMvp3yb2CIYJqlhLisXBp74wFmVtMFoWK7glr1OzyT?=
 =?us-ascii?Q?DjHhzdpY4sf2tOEEWSYxl0DmA7uSGgB2H1o+Qd03?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4513ee9b-699a-48ea-9bae-08dc349f6bdb
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2024 18:44:09.5145
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3Bb0HMqcIs47pkZbUKaLamU1eNiylrcjgSNjGp8kmDpUyUNaked3ZEUh6FUBpUW1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7117

Since MOCK_HUGE_PAGE_SIZE was introduced it allows the core code to invoke
mock with large page sizes. This confuses the validation logic that checks
that map/unmap are paired.

This is because the page size computed for map is based on the physical
address and in many cases will always be the base page size, however the
entire range generated by iommufd will be be passed to map.

Randomly iommufd can see small groups of physically contiguous pages,
(say 8k aligned and grouped together), but that group crosses a huge page
boundary. The map side will observe this as a contiguous run and mark it
accordingly, but there is a chance the unmap side will end up terminating
interior huge pages in the middle of that group and trigger a validation
failure. Meaning the validation only works if the core code passes the
iova/length directly from iommufd to mock.

syzkaller randomly hits this with failures like:

  WARNING: CPU: 0 PID: 11568 at drivers/iommu/iommufd/selftest.c:461 mock_domain_unmap_pages+0x1c0/0x250
  Modules linked in:
  CPU: 0 PID: 11568 Comm: syz-executor.0 Not tainted 6.8.0-rc3+ #4
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
  RIP: 0010:mock_domain_unmap_pages+0x1c0/0x250
  Code: 2b e8 94 37 0f ff 48 d1 eb 31 ff 48 b8 00 00 00 00 00 00 20 00 48 21 c3 48 89 de e8 aa 32 0f ff 48 85 db 75 07 e8 70 37 0f ff <0f> 0b e8 69 37 0f ff 31 f6 31 ff e8 90 32 0f ff e8 5b 37 0f ff 4c
  RSP: 0018:ffff88800e707490 EFLAGS: 00010293
  RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffff822dfae6
  RDX: ffff88800cf86400 RSI: ffffffff822dfaf0 RDI: 0000000000000007
  RBP: ffff88800e7074d8 R08: 0000000000000000 R09: ffffed1001167c90
  R10: 0000000000000000 R11: 0000000000000000 R12: 0000000001500000
  R13: 0000000000083000 R14: 0000000000000001 R15: 0000000000000800
  FS:  0000555556048480(0000) GS:ffff88806d400000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 0000001b2dc23000 CR3: 0000000008cbb000 CR4: 0000000000350eb0
  Call Trace:
   <TASK>
   __iommu_unmap+0x281/0x520
   iommu_unmap+0xc9/0x180
   iopt_area_unmap_domain_range+0x1b1/0x290
   iopt_area_unpin_domain+0x590/0x800
   __iopt_area_unfill_domain+0x22e/0x650
   iopt_area_unfill_domain+0x47/0x60
   iopt_unfill_domain+0x187/0x590
   iopt_table_remove_domain+0x267/0x2d0
   iommufd_hwpt_paging_destroy+0x1f1/0x370
   iommufd_object_remove+0x2a3/0x490
   iommufd_device_detach+0x23a/0x2c0
   iommufd_selftest_destroy+0x7a/0xf0
   iommufd_fops_release+0x1d3/0x340
   __fput+0x272/0xb50
   __fput_sync+0x4b/0x60
   __x64_sys_close+0x8b/0x110
   do_syscall_64+0x71/0x140
   entry_SYSCALL_64_after_hwframe+0x46/0x4e

Do the simple thing and just disable the validation when the huge page
tests are being run.

Fixes: 7db521e23fe9 ("iommufd/selftest: Hugepage mock domain support")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommufd/selftest.c | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/selftest.c
index d59e199a87055e..7a2199470f3121 100644
--- a/drivers/iommu/iommufd/selftest.c
+++ b/drivers/iommu/iommufd/selftest.c
@@ -446,20 +446,27 @@ static size_t mock_domain_unmap_pages(struct iommu_domain *domain,
 
 			/*
 			 * iommufd generates unmaps that must be a strict
-			 * superset of the map's performend So every starting
-			 * IOVA should have been an iova passed to map, and the
+			 * superset of the map's performend So every
+			 * starting/ending IOVA should have been an iova passed
+			 * to map.
 			 *
-			 * First IOVA must be present and have been a first IOVA
-			 * passed to map_pages
+			 * This simple logic doesn't work when the HUGE_PAGE is
+			 * turned on since the core code will automatically
+			 * switch between the two page sizes creating a break in
+			 * the unmap calls. The break can land in the middle of
+			 * contiguous IOVA.
 			 */
-			if (first) {
-				WARN_ON(ent && !(xa_to_value(ent) &
-						 MOCK_PFN_START_IOVA));
-				first = false;
+			if (!(domain->pgsize_bitmap & MOCK_HUGE_PAGE_SIZE)) {
+				if (first) {
+					WARN_ON(ent && !(xa_to_value(ent) &
+							 MOCK_PFN_START_IOVA));
+					first = false;
+				}
+				if (pgcount == 1 &&
+				    cur + MOCK_IO_PAGE_SIZE == pgsize)
+					WARN_ON(ent && !(xa_to_value(ent) &
+							 MOCK_PFN_LAST_IOVA));
 			}
-			if (pgcount == 1 && cur + MOCK_IO_PAGE_SIZE == pgsize)
-				WARN_ON(ent && !(xa_to_value(ent) &
-						 MOCK_PFN_LAST_IOVA));
 
 			iova += MOCK_IO_PAGE_SIZE;
 			ret += MOCK_IO_PAGE_SIZE;

base-commit: ad0b912913c0e21f217d5580289fda0819cd45ae
-- 
2.43.2

