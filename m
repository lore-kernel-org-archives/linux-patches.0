Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2062.outbound.protection.outlook.com [40.107.94.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 176D01B3B15;
	Wed, 21 Aug 2024 17:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724261862; cv=fail; b=JfcKI5vG4Mwvl3XY3Bal+6F0H7owMgBGo+OlXZA9MKghA6VON8KbUsN8K9Wq6dSL8jcgK5Iy5IMNTAAqNo1fFACdNXk5837KguGVnCP3qT86ez9/FVYcMpiC1vBDJSDhS6Rau2QcIMpTJk8lrDlZT2y4AfY07tgCezrgvH28I9w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724261862; c=relaxed/simple;
	bh=d8tsDj+AicfubWNKV1X3oII7K0BS/xnaM7my5V/NbXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pJtoTGRhFKB2+22dv1MgXsbJRQZ6n0uEwyAoWGXavYTbb5/JZBk2Hn/6blmj7l+Uea/4ZIP/I08vNvfVc7jwpKRxXYqgyW7FHUAj1BvJ7tnkKeNseu6iiQqPME1fdIiZS4el1sEES3M43NE63tW9i+9H8CTpWr/fw8z2vJZhFc4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=eWMfyvuu; arc=fail smtp.client-ip=40.107.94.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="eWMfyvuu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FLO93TNyeZobtC9J3kbYHrsoLe9xdTPTce+aVLlJoCyDAoqvZ9WW8ZimWTN1ZVm0oYEAvlDX/Lif8awR8Z+G8LppuE5SFbQ/xDdiwDKtJ0dn1FnRyd8Hjzj7GUOHGz3677Pxa3V59EXuvFBx2VtPkq0CgPj6+OrYLzCCNEgI2BCbmf22Xpl6gKloD8pTcM5hdik/4IkKIbqyME8jhcMlbzkmg/aqaHELEYmIkeaKP2kmIfz+yGk+RNE0Cleezii4bfqdASXYCtJgR3erV5yPMUX4AT8Lw8AQYuQTGV6IlIh9iTkKIb2Ccg0lKvQqJzjrfx45IEnyPInfY1qpEbUZOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9Zyx11oF91ZvusZFs/qEBPYI6SpJgBrK1dB/ZbqddxI=;
 b=xSF/weONu3HURAGDUj9x/+0Q3Q9lIQ5zhMczyNJNbdR9vfgxnUz/nHksxw8FOqzQRDlue9scZuC1ge0JyU3JD7dxHwrX8h+TiL4k0EsL2B17ZqrhQVtJujL2VUt/eG6YoJg/iM3P/LkzpErR5xXB7gjeFzQfzrzArb5SOo0kVR8K+r0rRYOC/Uw5a9ZicqvxTOwVWzxYoCnSa5p8YpWJi0k4G8VvOLCLm3TIhZC9y3/VI6bOcBabA2YuMslvZtYm24jZqFyGjwakqqxYAK4bGWiwnBXtsQqWGYCG8X87mytgc92Ywq/S+vZXNG+wlh00x4Xg6MDEz1s34U/flRfAyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Zyx11oF91ZvusZFs/qEBPYI6SpJgBrK1dB/ZbqddxI=;
 b=eWMfyvuus887aG6I92tOss7mK8ek4w23v4shMZPAoCnmyEysUA+nGG9fTgmV0o5irmuLraDy2ALpxqGAgj5zN3dG4SqTdXS7yZtAXJskhdM189ZQGF+RkIMdd2vWWKbaX3PsUZjWTg8Wn85ak5NEiAT7hkRX/7zYGlovEIF8iCBefN9Z7s4+ghHDbFIEFN10HE1fvr4O0/3n1+R6GMn1fjpQqLKG1tJwKm7xhoZIMYOWtNgFeqE/TuLxGpOI14e9Eo1d/6NhRUsGFxUms1dZ1L3Od2xnjy79qSXFRuSianMfHpU3ijr2WZh6ZxEd1N1eZgvMw/aUP0fwmez2ZwCh9g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by CH3PR12MB9098.namprd12.prod.outlook.com (2603:10b6:610:19e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.25; Wed, 21 Aug
 2024 17:37:26 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7875.023; Wed, 21 Aug 2024
 17:37:26 +0000
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
Subject: [PATCH 10/14] iommu/amd: Remove conditions from domain free paths
Date: Wed, 21 Aug 2024 14:37:16 -0300
Message-ID: <10-v1-cdaaddf80abb+14190-amd_iopgtbl_jgg@nvidia.com>
In-Reply-To: <0-v1-cdaaddf80abb+14190-amd_iopgtbl_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR05CA0022.namprd05.prod.outlook.com
 (2603:10b6:208:36e::27) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|CH3PR12MB9098:EE_
X-MS-Office365-Filtering-Correlation-Id: c2bb0fad-948a-426f-7c03-08dcc207e9e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1bi2V8tSNcCNF7Moyy1oFIRUt8pnUfBayhekiGzl64ku+gfeUz23Qau3GFcZ?=
 =?us-ascii?Q?kaV7JS7ZqixkoAX7gTbt6xfjT1mfOP3zbnEgpuYB2aeQU+wz+8ANjcF3G9hY?=
 =?us-ascii?Q?zR0o9NirnVusXaekEXrtb78VwpbfW3ntxihH97XaW1DeK0BGWdNGKJ40dk2x?=
 =?us-ascii?Q?G3sCC/udpTcOBk4mvfRSrkTgIvOpYS3DFuxJiBejfCaqEhjE3GgoKxyCNVSX?=
 =?us-ascii?Q?9Ps2naDe9LqqEkEN1RdND/tLxRLaQzkpbRYnn5U4tqglMjfjvW9V7mjIb8L/?=
 =?us-ascii?Q?oq6gL9zHzqdbvXqr66xUafpxNoOaOON6mT59G8KwDGEBZjZeMFH9rqzziXG9?=
 =?us-ascii?Q?px4qlMbyqZuLpSLhVosVsXMTp9N8GXBeAFPP2ttId61ISZhgYiQ34pntyf+b?=
 =?us-ascii?Q?3Mz4ETHIhRkb559W4y+SjuoQjn+jtrBIVK17ktfCo5ldcWolyVSo4RPqZrPX?=
 =?us-ascii?Q?1G0GbjUvqs4SAN+BCtreRdtlS9hfqJsbt2xKvArhUX3Mk/lTQ9ENQgtGjbtt?=
 =?us-ascii?Q?6Bv2FXSCYKoiM2MikmQW/HSISdlcrH3PdgH5NBfvK3Clvq4iycZB/wA7syVq?=
 =?us-ascii?Q?4ancq+H+Zc4K9TMSrGpavzoZAgqHIpn0BPcVJuJvq6C67iClE6Aqo4k1za86?=
 =?us-ascii?Q?Ak2niNxPyQ+r1PbDjh3aFv1PNwqQLkpCwSs7chDMbVqKR9FcaMwbA6QmX1TX?=
 =?us-ascii?Q?zZRISM0bAZqvA6cpsqDXgte3iS3MU8NOWZx6zF5Hqwo0hCX3SaZ2KQvdIJPO?=
 =?us-ascii?Q?xtd50tvTomUZMt1VLuFd0+wtDPbi0B6y2YKelNM6FkdSPMsvEbcq/5lDDZ+x?=
 =?us-ascii?Q?7sL3UnAwTCEH81fhq1BuBfdW8UNQQqxz0pcsvVQccj/x7rwZ1NQIpvXn7dDF?=
 =?us-ascii?Q?7PTX7XVK81wNFsdHGvQwe562Eu2IdXRXRiB8MDLAYPJU0ErbRQ6d2Eq2WxNY?=
 =?us-ascii?Q?nEDGTBIHOuEdwtdGSGCDHgLMvazFgypc0cw9qYlYJ2LTASM6Xs/DSjfCynTG?=
 =?us-ascii?Q?fkBXWrxH1NRmaXbH3gZGUfve1q8EsJW7ACgWjGfJs0mbd1l1VWNnzY6a9s6H?=
 =?us-ascii?Q?B+Xwe7rON4AGnzB+LxujYk90dlaldbkQ8JNjxQZeuyCsu3xwq7sN94+DhpUE?=
 =?us-ascii?Q?dyYehO4rEPOzPI3+o0kQCFDBiSyXhJ+a659ObshqzDv9iDCno//TRbzVDsGl?=
 =?us-ascii?Q?ISHkBn+XkFQmHC5GM22fDJbBWQFxdnF4Td2tAoltmGlOGK/lLxBpRORUXF/6?=
 =?us-ascii?Q?5O/oCJIMtYtgOep9C9U7VE+nnqUYzlVAr/trVm1hmd8K085EXNHwtXBbBxtV?=
 =?us-ascii?Q?qPVXR0F/jHAaJK5FR6iuyqdT9/9cxIr0S+9z7v3IxAoCDA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?O+W/WvFNiAMkdIq3SItylGy2Fro092RAF+0RWpzYe594NuXDvaoJYAj/7jvj?=
 =?us-ascii?Q?Zznh4qU14mx4aANUrZ2oowdFZgJjO3qcEK6R0wiPVQre7wnzJoOKTexLBcy/?=
 =?us-ascii?Q?etCydUlh3BF55WHJ8npTVhFLBVLn8yy3D6UA+Ms0z9r4UDnitvGSq5lyIOQK?=
 =?us-ascii?Q?SHYU5mTiCjJX6WRhC7AG2UGgZQLij/1ig/uvj4b6w8hrOJiaop29qM/1yJHN?=
 =?us-ascii?Q?ABc8B7Lyptc7+fKKl8lS+sJcXHtz7s4BzBtM9w7hgMMbLxMmWvopbr+rnYer?=
 =?us-ascii?Q?ueK5uMylDW7AQDCRnWkb3zdVfo4DxKLOb6rPhDDFcO3hId+/MdRL7TTysskZ?=
 =?us-ascii?Q?4mhJ7Mx0eU3EMTHIP4GEj3ji/pDvjuOgikSh2HyM2ny2/DQAdCkjroHgT4n8?=
 =?us-ascii?Q?2ccGRPzR76VFM57QBh1Kvk94hgj+CwPelIZGr6cySJaDOVCcVkKY8RMRSDc1?=
 =?us-ascii?Q?DvWLxajBCCKu+V/6HDUEurmd7G6QydZHy5fLy49ryQIGkseqTmtxogLfdIqO?=
 =?us-ascii?Q?XJxCsPUfR0lgAGww32+mJ2iS7hwUlBBfpKnG0+kEP9cg4BmIA8rl6ZlP5EgL?=
 =?us-ascii?Q?7YLFc3wtCDl26xyT8vy17QiU4bzvD2eo71bkdoqyj5KHaEW+dQ/8rZ6AcGac?=
 =?us-ascii?Q?loM4vChPLfuIU9m8CL7YO5hVhUzN93gX+sIhv7LQaA24zvYTuYwE38hs+CYU?=
 =?us-ascii?Q?uDOVIX6JD61j0fwHficC/kFWT8WQphcvA9LVjjSRibreJQTo3CQyiKVZb4sA?=
 =?us-ascii?Q?rDgl5JljH7YPB8O1WTwEFnT25JQoSiIkCxQl+yFNZRpTDo8RXHM6LYTdSpmc?=
 =?us-ascii?Q?F+Zh+auov3OK8u+evqoRxSM+Jiqhhm4AatzCYW/zcGTav16as7zUCHQmFSyL?=
 =?us-ascii?Q?7eLHhF3u7kEp7wepfJ2oaNF+pcpJ5q1nQOE7mqVYWPOP2esbcOk5ZwxGmCAk?=
 =?us-ascii?Q?oYKj6EUI0uEbWnfOZN93BMQf9fig0O5GcojrlII3q/V1GPxrfVJmjKmWIjsc?=
 =?us-ascii?Q?9OXmuCiY7hvKYTYiUmgZKsSUamKGqrTXapRp+CmUgPAv/DtHS27t5xD101gV?=
 =?us-ascii?Q?ZHOiDimVt9rHs5MV9/u5FP6x7MA8XzFMsxj6nLAN85zvsALi3emONXYphX8j?=
 =?us-ascii?Q?aLmL+Epim2J2KVig2YYkUc/keWzLHlq72lX94NcUDBCynqQZDE9uO0FjeN/U?=
 =?us-ascii?Q?AFIahHkfJRoCxWpEeS17xDcP303qQG/SE8c2PfZP4VbEYm5IRGLqCekTAodJ?=
 =?us-ascii?Q?69WePZDXfOpao7sAHjd/E5N2zYznvjlYbeNwl69sSS4JjoZ3zlBbp7tYbNoC?=
 =?us-ascii?Q?qkpXAFRUUUxk0rpHDeWOU4pShUO4HW9xczVkH3kO4bFMI9C5sY+RRHLseC0Q?=
 =?us-ascii?Q?T7Quj9pgm0nHaI+8EnuqGvHoDxpAgWKgRbfqD48tlBudsz2F3ho13rk4CHVb?=
 =?us-ascii?Q?ybA5FkTgOvKykvJJh+Lg9iU/uKEX1SZOST7WpRDWeb6srhPXu8/j9jW/xtXr?=
 =?us-ascii?Q?ykpFDEsl6UW6uGosiYKr4pQTELpSeac2wlfiHcS5OrVqhML/5hl5gikzuhYo?=
 =?us-ascii?Q?gsft6BW66m8ITwpWWZXyC76n5AzKKttM+gEE5Pu9?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2bb0fad-948a-426f-7c03-08dcc207e9e5
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2024 17:37:22.5315
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lc56rA/HyltgQlXvYJg3X5sDhY1BowxClGx4NIuc4DOk46feKzuNx1iE46Y39Efl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9098

Don't use tlb as some flag to indicate if protection_domain_alloc()
completed. Have protection_domain_alloc() unwind itself in the normal
kernel style and require protection_domain_free() only be called on
successful results of protection_domain_alloc().

Also, the amd_iommu_domain_free() op is never called by the core code with
a NULL argument, so remove all the NULL tests as well.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/iommu.c | 29 ++++++++++-------------------
 1 file changed, 10 insertions(+), 19 deletions(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 1cdd1675a01af2..1e62e880131940 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2257,17 +2257,9 @@ static void cleanup_domain(struct protection_domain *domain)
 
 void protection_domain_free(struct protection_domain *domain)
 {
-	if (!domain)
-		return;
-
 	WARN_ON(!list_empty(&domain->dev_list));
-
-	if (domain->iop.pgtbl.cfg.tlb)
-		free_io_pgtable_ops(&domain->iop.pgtbl.ops);
-
-	if (domain->id)
-		domain_id_free(domain->id);
-
+	free_io_pgtable_ops(&domain->iop.pgtbl.ops);
+	domain_id_free(domain->id);
 	kfree(domain);
 }
 
@@ -2283,7 +2275,7 @@ struct protection_domain *protection_domain_alloc(unsigned int type, int nid)
 
 	domain->id = domain_id_alloc();
 	if (!domain->id)
-		goto out_err;
+		goto err_free;
 
 	spin_lock_init(&domain->lock);
 	INIT_LIST_HEAD(&domain->dev_list);
@@ -2306,7 +2298,7 @@ struct protection_domain *protection_domain_alloc(unsigned int type, int nid)
 		pgtable = AMD_IOMMU_V1;
 		break;
 	default:
-		goto out_err;
+		goto err_id;
 	}
 
 	switch (pgtable) {
@@ -2317,17 +2309,19 @@ struct protection_domain *protection_domain_alloc(unsigned int type, int nid)
 		domain->pd_mode = PD_MODE_V2;
 		break;
 	default:
-		goto out_err;
+		goto err_id;
 	}
 
 	pgtbl_ops =
 		alloc_io_pgtable_ops(pgtable, &domain->iop.pgtbl.cfg, domain);
 	if (!pgtbl_ops)
-		goto out_err;
+		goto err_id;
 
 	return domain;
-out_err:
-	protection_domain_free(domain);
+err_id:
+	domain_id_free(domain->id);
+err_free:
+	kfree(domain);
 	return NULL;
 }
 
@@ -2416,9 +2410,6 @@ void amd_iommu_domain_free(struct iommu_domain *dom)
 	struct protection_domain *domain;
 	unsigned long flags;
 
-	if (!dom)
-		return;
-
 	domain = to_pdomain(dom);
 
 	spin_lock_irqsave(&domain->lock, flags);
-- 
2.46.0

