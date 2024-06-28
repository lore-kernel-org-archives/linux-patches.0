Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2078.outbound.protection.outlook.com [40.107.92.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A6F11C9EAD;
	Fri, 28 Jun 2024 16:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719591082; cv=fail; b=Mp9pJf/f7d0nOrB4Mu3VCDK1b/Ur3br4xWPEIDgxtrr7tDZYTqcM/GpZTFsT2gaOhMYHH3yNli8sTEV6wbzmK8WqXh3VKWne/nOgiECjFvJ2fCDVgHey9kMnr90Y0qy2dOA6TSgAeG0WV92er7h6/uiHF3nUu1KySfKfm5gfuco=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719591082; c=relaxed/simple;
	bh=cZy+QwAjqDrBPJhikODp0YVuOIHSvblTMsoqlbfyLGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=OuFL2m/09ZfvSYv2OQwq3TZ3Ykm6aGE+yTH3BeEtGPq0MnR9+njeFMfJV5kbE4f73ZudsJpCOKdAnUR9G4HJJLRQp76EnKi59TvNppnMMy36G2vqmBVPQTmooiBttc002ykdYHXrtdkRasqQvY9Zx/BVmcaP6BGXoWJoRl3YTQ4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=TslpZelp; arc=fail smtp.client-ip=40.107.92.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="TslpZelp"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fVzgax7f8XRKUQ7X6ho50ZMnzjtssFi2MjhMel7Z5D2iKBIU88y3vqQ7rRl8EKIo2cc/QmsWXH2Clityc+wwfEPCwWS+XEX31ZIf16iy1pQpnzEkdClsQoAQCG/bjDsEtrsLLE1rl1rFmxB89LM4TC4VY3Oq339wXssLtu12gyyiGQSytyTth0JJFp4MzndMrjYMrf1lVMiukAAtYUfCrRJ1lAkTXYPcK1b9kzpIQSTHtSNeHJWA1GhsNwM7caAiGh5Xqw1fvaDGcNzic8Xa7UcR4+QhRKLQSKGx5wZalQ1TynLG2Eor8RmSyrmDow2oyh8MPEuUIbSw9gGViMdn/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9hGres8Magncu4ptNYvk6Wf9mG9WQCiWvLprw5xbCmQ=;
 b=DJ50JDPTuVZD9aPrvfZLeDKBMxp4szxiIvenvhGBXRtodLtCsaJ1bz6u51UoQOuy1+BI3qDjmvnbQPw1jvMom/1X1rWm0c3m7P+G5Kk2qMreyYORCk/6737wQMjW3v0O9UA/96m1UO/QyHKwEV0K3LgzwYkt0q4JnINVDcb6u6Xzo7/hjvwDpJzAMm6jtssHFAsNEbU5T9JpFtusWgq/UevA2udyfQ+Q8aFUdheM5jksUvaPZP4fYV50B1QBO3/qK5Ui/n06fo+jgtxlT/bWtTnwPZjl//tny3FocGxMyhxEEntTK6Ih83Y0VcNTcw70GVnaXl7WiJuFSlM6dEHvAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9hGres8Magncu4ptNYvk6Wf9mG9WQCiWvLprw5xbCmQ=;
 b=TslpZelpoEpQQ3IKtsR/o9eyKDqHKAxGo+X1Xi4+SPwuaMeU71xMabNtGvqXSedVCwFOpfgQqUpE9CiF2k5YAMchICSc0BLKxXGXhtVU5uk8ZyJQjELr+ju7tJMmX9F94QIZVZN9/0D2vdBT2jW6gj0HBl+lFsyqUKWALK1eLkihoYhqjm3uDuqytYq2k2DJ+kuO2PK9JikJr84Qb8AzAPydgllCkTJNbUkArv5aoNSeUr44iMpBJ6OaKaZXDyLm8604+y6PKVKaURWPfwzETh4Pmo0NmUe4Bg0c3HWMWRiwZwjv8EDG2KSWlccvvQ+8vB9NpSeSiZVCUI+dVWxSbQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by IA0PR12MB8325.namprd12.prod.outlook.com (2603:10b6:208:407::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7719.27; Fri, 28 Jun
 2024 16:11:13 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%6]) with mapi id 15.20.7719.022; Fri, 28 Jun 2024
 16:11:13 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev
Cc: Kevin Tian <kevin.tian@intel.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Yi Liu <yi.l.liu@intel.com>
Subject: [PATCH] iommufd: Require drivers to supply the cache_invalidate_user ops
Date: Fri, 28 Jun 2024 13:11:11 -0300
Message-ID: <0-v1-e153859bd707+61-iommufd_check_ops_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0009.namprd02.prod.outlook.com
 (2603:10b6:207:3c::22) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|IA0PR12MB8325:EE_
X-MS-Office365-Filtering-Correlation-Id: 0334df3b-0c9c-4eaf-af5d-08dc978cee6d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uVw7VPuyoipaVtXKziejreJ+VpnhT0eM3l+pzRAw90YL1w6Ko48BCo6ZVitL?=
 =?us-ascii?Q?SSWg0io37xBhYjwnyXrzgc22Yr4xfI3WkZJUsRfSq+RAyVh6RzhIJSZqF6Sa?=
 =?us-ascii?Q?iT0qzGI6MKhYQcE9ao/4pc0rVRpjXK1KJlAmwODLCbVIwMP4Rd++/NIEUvV+?=
 =?us-ascii?Q?37kSBhKFLVUBlAMwcr490a2PIGB/fOcqOfbVXpyYPHrnxwQejIAszNhwCQuj?=
 =?us-ascii?Q?lYhYlu5/qUiuINkjuWRNYbV/t4taYBODsmT8d4O9Xhp7uBSrPilaAm2wKMX1?=
 =?us-ascii?Q?E91mocrlin1oLM6/Ux0CHyq+F+rMhWq85LJWeHl+J2hXngVhfN1W/q0+uICK?=
 =?us-ascii?Q?2vwi57p2kA87Ti2NP7iHaAzapyX+C7JAARLHhOZ+xC3UWiTQhYHRE4WbCBLV?=
 =?us-ascii?Q?ymES151bgEVBDKdmtLIu9VTLFVM5mwHmzQdI9+E5L1MdpdOMcNDhr2j8X67i?=
 =?us-ascii?Q?srLlKk5S1vN2/eqwbw+EyJ/h5vSUmYT89VnvHyOvUvIXv30H9M9phsgFcWwZ?=
 =?us-ascii?Q?qcoh0svw09dmeT/ODXMD1IcGoG9ZcamS+n6Bsds7wxUHUpIe9+l6gwZ92yh9?=
 =?us-ascii?Q?U6oLskwv1z8sBRUwsD3bFuN/gmXAvp1H6urB8lHaGxb5YDQwQwPqKZwGy3O7?=
 =?us-ascii?Q?F1VTB966TvsQ29rcmDMwVNALp8qOocXdQ/IR87Ep/lHbl4qgm11p0MxzB1cw?=
 =?us-ascii?Q?nBmo3QZcn2SB0cS/Up7Pq1wjn9s+xo4GjkqOD/K+2T3pdKUN6Ps5gH8iLhgu?=
 =?us-ascii?Q?hmtTgzQOi6ZBdK4nBiU6O5UdF0q0d21vM5MZ1HQ09ccP9KX6nEuTZGRoxKai?=
 =?us-ascii?Q?ZOEq1PR3N5xug+JGJ0ZwEdMz4j1KtK6w6A8++2XjcmgPkgVf+pUR8W5Ebc0q?=
 =?us-ascii?Q?5oeNn8wX6rFZxf2egfUBLOthf6l/5Arpo4DZTWa/faI4Uum7BUrOiOCpi+gF?=
 =?us-ascii?Q?DBVZ5HeAITYZ0VqqptPw6UCD37EDp+f4W3zmGpFGzLdSlNoO4zRgOzuVq7Io?=
 =?us-ascii?Q?JMtTnP39sQOED41iwG+0gwz9gE7zPt7tavdSP6JnXyPf7HYEaoJ76F48Lc3P?=
 =?us-ascii?Q?+h37WxsYRyiqRjwIZPWF0pDl2i5fCHrIv8eZTdeX79g+3HVaU0R8Pj9hgvS/?=
 =?us-ascii?Q?wm/8ZyOzZG4AmScwe0afHXKKRaAuImgewiR012ly/NxbaCFkVs+RJTSzeUh6?=
 =?us-ascii?Q?6fWwp+IHi1Zq9N5SgR+6keZsw0DlXYIxi0V3hmcojV/dgG5Ph3etkKM5pGVI?=
 =?us-ascii?Q?YKxT8fcjtCehXu7k4D3axJCwof714G0YquhLKTjz5jTowoO0m59N5vdLrw9A?=
 =?us-ascii?Q?3G5JPCwvgyV14rFbg3gP1BHi4tD9JTL+m0/WRFHfx687AA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qiTB0sX4nz5soqvKmVdiloIknBqk02AX8m4OKoes1ZOJmdM7I2KrLNcC094f?=
 =?us-ascii?Q?tiNbDMgUGMrSE76KThO2qcu9mnOiwZYpKahDjAmgzP7hzl9GS5J3OqtnM2en?=
 =?us-ascii?Q?LCYuqpHPlU4oL7L8TI19CWzIT2TF1aYulyzXi9s0bFhtAbQeTpZ6hVyrKj8D?=
 =?us-ascii?Q?kfkDq+lYK4fVnzBF8B6GYmhw1bnleZ87vMS81b2kTsCBIOECH3Ib7TYFzy5Y?=
 =?us-ascii?Q?jiK+l63cEvt5uHe79JAnCBVWSgxg9KPItR+9AcIApO64PhEtZO3sUW3uQyzl?=
 =?us-ascii?Q?S9dEkMZ3bSg6Yqx6xafvl1PlSTbxQxzbFKXON2tXQTaKPKHtt5lYstkMyCqT?=
 =?us-ascii?Q?49tvmrhn9FTerCLDpaD5N3FTTJjpiivpICPcnfeIeXLYhX1b1qSJTHE63m5x?=
 =?us-ascii?Q?xocPIWtToA83ICWUP81UdU704t6Kx5RAhvX5ibxSLw2u6EROVKasQxzFaohf?=
 =?us-ascii?Q?gL4XpQivGTDl410oVd8iZzNRrtOpLMmmFa4iW/t5LHrSU75Ay/GHfKsZ+YgV?=
 =?us-ascii?Q?o5fDnZ01YG74kW3tw1Su5DWdbAges5obBiTRJd/fK2FyBQiItFkPdGelGHE1?=
 =?us-ascii?Q?jMU+GXdsUw6B8TNGIktPpkjXkW2ANw3Kuwd54qUPxCAAWHlfQ54Jcis7FAxf?=
 =?us-ascii?Q?GldCiD0IhcE9UWr4E3nRDH76SH036g9L/SMqukiH6cY7sF4w1jOTsX91EZ17?=
 =?us-ascii?Q?1Ng/db95HIb9xeTtJFLfs5QBee++8K8/DQzXbWtdxmtgBruUzpmgeCPTYL+a?=
 =?us-ascii?Q?aWlwRoS2qkhZEEwgcT2/wz/iXZriPZXwpHFVm4x2dwgLuL6KZoC9O5X2+aok?=
 =?us-ascii?Q?DTXdNoLd9/NZcdBTzD6PZnD7R13V5HMfvrlThJ7L5dvdiagEUv0S6/ybVl76?=
 =?us-ascii?Q?B0bjKQn2pLPRXHmqRYY+24WJQqFLowe617iTAi5slvTnk+QwDqq2oeiilnqL?=
 =?us-ascii?Q?hg591wMlLyNqFd63F0ZX2XZO5ph/FQBleb1nBKJ0SVWjqRXAIZvVk4o0ajbR?=
 =?us-ascii?Q?SUh6nUDDbuME2ctke21uBYo88RR0SD3umtle7dnHpZGe/0Lcu4Uf+ExnqCWs?=
 =?us-ascii?Q?vzLYyXUU+rucutHZe4Uywk2Fb6xw4I/gmt0HOYgLCI/eXFN8zt8bziznvEGb?=
 =?us-ascii?Q?PMVEyiWAEPMOHqlyAYUpj0ZB0YmAWeGMY3ZlY8dsvtYwc2EF+RE4CQdNzPCc?=
 =?us-ascii?Q?C145sEuZl/iJZjK4VoFeYPTc753KfGd5HGLQAjCDYV5d537fPioVvIvQN1/b?=
 =?us-ascii?Q?SDCulDmIVHw4ahwAxeWRNhTLb0jVZC/6/Lu+m+ishFCV67FqWQxOnpRe9MHn?=
 =?us-ascii?Q?bSUOI66lkeyu3aV0WZWeUaNyTPp2Pf9pAffWZzvA/W/p/PaSzmCFLxZGHTz2?=
 =?us-ascii?Q?5kste4wP+I1O+RV3XOs96LWqCxFJMFgyxP1LbMd2CVW6dYtzBr3tiKzuic1V?=
 =?us-ascii?Q?xptrZBLvt44PizzxZbKNol8JlOrmTo+9JyDqwcZKUGd0kAMtMM8PF/Zk0RcW?=
 =?us-ascii?Q?2ZlDhdlGHqa/+Fn+Hakaxw8nLzkwOrUA9+Pae2YHIoshP2jbB+wOqCrzeqsd?=
 =?us-ascii?Q?9tLWObEURL5S5wi+74e79lDAUG08neSfRoBU9XcJ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0334df3b-0c9c-4eaf-af5d-08dc978cee6d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2024 16:11:13.1975
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qe30eT0ydM5oc4oMj7Exyefft4TRbUo9zpxyjGrbzyF2e+dJt+IDOoLhdPqSWV+B
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8325

If drivers don't do this then iommufd will oops invalidation ioctls with
something like:

  Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
  Mem abort info:
    ESR = 0x0000000086000004
    EC = 0x21: IABT (current EL), IL = 32 bits
    SET = 0, FnV = 0
    EA = 0, S1PTW = 0
    FSC = 0x04: level 0 translation fault
  user pgtable: 4k pages, 48-bit VAs, pgdp=0000000101059000
  [0000000000000000] pgd=0000000000000000, p4d=0000000000000000
  Internal error: Oops: 0000000086000004 [#1] PREEMPT SMP
  Modules linked in:
  CPU: 2 PID: 371 Comm: qemu-system-aar Not tainted 6.8.0-rc7-gde77230ac23a #9
  Hardware name: linux,dummy-virt (DT)
  pstate: 81400809 (Nzcv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=-c)
  pc : 0x0
  lr : iommufd_hwpt_invalidate+0xa4/0x204
  sp : ffff800080f3bcc0
  x29: ffff800080f3bcf0 x28: ffff0000c369b300 x27: 0000000000000000
  x26: 0000000000000000 x25: 0000000000000000 x24: 0000000000000000
  x23: 0000000000000000 x22: 00000000c1e334a0 x21: ffff0000c1e334a0
  x20: ffff800080f3bd38 x19: ffff800080f3bd58 x18: 0000000000000000
  x17: 0000000000000000 x16: 0000000000000000 x15: 0000ffff8240d6d8
  x14: 0000000000000000 x13: 0000000000000000 x12: 0000000000000000
  x11: 0000000000000000 x10: 0000000000000000 x9 : 0000000000000000
  x8 : 0000001000000002 x7 : 0000fffeac1ec950 x6 : 0000000000000000
  x5 : ffff800080f3bd78 x4 : 0000000000000003 x3 : 0000000000000002
  x2 : 0000000000000000 x1 : ffff800080f3bcc8 x0 : ffff0000c6034d80
  Call trace:
   0x0
   iommufd_fops_ioctl+0x154/0x274
   __arm64_sys_ioctl+0xac/0xf0
   invoke_syscall+0x48/0x110
   el0_svc_common.constprop.0+0x40/0xe0
   do_el0_svc+0x1c/0x28
   el0_svc+0x34/0xb4
   el0t_64_sync_handler+0x120/0x12c
   el0t_64_sync+0x190/0x194

All existing drivers implement this op for nesting, this is mostly a
bisection aid.

Fixes: 8c6eabae3807 ("iommufd: Add IOMMU_HWPT_INVALIDATE")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommufd/hw_pagetable.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/iommufd/hw_pagetable.c b/drivers/iommu/iommufd/hw_pagetable.c
index 33d142f8057d70..a9f1fe44c4c0bd 100644
--- a/drivers/iommu/iommufd/hw_pagetable.c
+++ b/drivers/iommu/iommufd/hw_pagetable.c
@@ -236,7 +236,8 @@ iommufd_hwpt_nested_alloc(struct iommufd_ctx *ictx,
 	}
 	hwpt->domain->owner = ops;
 
-	if (WARN_ON_ONCE(hwpt->domain->type != IOMMU_DOMAIN_NESTED)) {
+	if (WARN_ON_ONCE(hwpt->domain->type != IOMMU_DOMAIN_NESTED ||
+			 !hwpt->domain->ops->cache_invalidate_user)) {
 		rc = -EINVAL;
 		goto out_abort;
 	}

base-commit: f2661062f16b2de5d7b6a5c42a9a5c96326b8454
-- 
2.45.2

