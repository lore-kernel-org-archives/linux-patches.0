Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2081.outbound.protection.outlook.com [40.107.236.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA5581386DF;
	Tue, 10 Sep 2024 20:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725998441; cv=fail; b=CJolkcHlwGDkMVapz/gemh4/y9kDBS8MGQLeKNUDnV3anV+uDTbPZroXqI1Vg29R1++qnENSxZeSYLoAGE3uMrE60aknICuIKOKgvgGD/HClr3U4qgtYZDlN4Tz8u2ccMJzN9LrvZohR+1dA0ESyBvGa0i5sSzbrbZ7A51VZvsI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725998441; c=relaxed/simple;
	bh=j/mT+S0TZcn+eotKT4kddagdE+XjdPAh3OEboux5RS0=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=HSa8zpt7cAnbECngUNiIl6/omZ1H/wOv1T0tIKyj5b2t1ZeYsIHrCBYayRNEcU7Op7goU9Y4rBC7dOISGwNnU9irAFhTmuAvm5OdEggiq744ONr2vxGLidaaWQJWLAEnPK0se3BM12w2w12QZUVpos6c0UhhM2ftU5BGLtPXUT4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=CiCUa4kO; arc=fail smtp.client-ip=40.107.236.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="CiCUa4kO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=duOLIvoTWtQtn48Psxa4i8MlpyqCsMlCmnAcWTcX4MaO4/Ydu1nKD7PwCKL7el+qxJePjk8HuNL4p6xftYY0YacqDuPL/h1rGZakS+H2yUZ25OmJdVaPq2e0EpQaUXz4wDQ8F2EcoHKemkPA1Fj7MVxIe0cEDicNb6agGCmexa5ucRt/9b9gQ89PW5EjKlej7cj775uTkxkPF9XUgfjNTRxg0zxPPO+fnGPCT7ATjpovNtrlBSCG805CFN7kOgCwoIFjnLynBiQ2VQL4YuHdGhfSWVcS9w39aqcJi1b7sWx4b5ThIRyu2dkoa1CUon1Mo6rfbMLGcx7HJbtt+ygU/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m4fH0STVbQZU0MIKNrZkBN9P2oCaiV2jbt83+lGRL/A=;
 b=BTBuQbC5mIwt1XDb7K47W2KloEIusfyQLQUoNnDKALuDiVHV3vzzbfJ8q5tBV05RodfDLx7uzDxuQ4ilAP05nWSE+28MXFBr87Hq/crCqkWyckSI67AET8sjnLjg8sDxS2GT1+Bn0iCwkXK0zUFhWjcI2QGq7BguzVCvS995204bSWfleWzQ8DfIKmmmS4i1RM3P6rogf57ADStKZBpnvGvPtA+d79wGwIEFVkUUIp5Z/i8g9R1R0D/I34AhzmpQ+DzLEk2lCVNcXjaScjuV+vVWtilt4GFn4tG71GKCByvm6N1pagB8zYtiWu/zF2FnrrTdS0WI7OZY1lQA7kmMAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m4fH0STVbQZU0MIKNrZkBN9P2oCaiV2jbt83+lGRL/A=;
 b=CiCUa4kOUwxGgjZHuGBapg+zluFpHdhBx9OQ784AoIoN2eQRYnKmig/hACjit6OE5X46v+K5WW+jQt8GfzOG+hR7gVZ1OxSFsi9eJAz+0V9y42UlTiw4Ov60Y1cxFaJArmY0T8d1bTXNICfNDQ6aqkn0GMqmOlyP2SepQuTb8lMtThoHmRWpWx0++3EfRAZjLBRWnoh9grkd5h41gh326nBxsQCfK0OWsuJd+cINuysoHF6e+sKyM7GnViXAxSxYYNgnIuy2c4zSAd7U3eWdHT3syyS7i8y9fqgNyYmzGeujIceqYSBVoL2BtWIhawdjtQzEgH1BQvn8qtPVtrjHBw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by PH7PR12MB8426.namprd12.prod.outlook.com (2603:10b6:510:241::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.18; Tue, 10 Sep
 2024 20:00:36 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%5]) with mapi id 15.20.7939.022; Tue, 10 Sep 2024
 20:00:35 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>
Cc: Joerg Roedel <jroedel@suse.de>,
	patches@lists.linux.dev,
	Vasant Hegde <vasant.hegde@amd.com>
Subject: [PATCH] iommu/amd: Test for PAGING domains before freeing a domain
Date: Tue, 10 Sep 2024 17:00:34 -0300
Message-ID: <0-v1-ad9884ee5f5b+da-amd_iopgtbl_fix_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P223CA0001.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::6) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|PH7PR12MB8426:EE_
X-MS-Office365-Filtering-Correlation-Id: ca411671-e897-4bfb-b745-08dcd1d33c26
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?k1X8XiKJERitUqblhvLcbnbwYXGoGmpURTYaOipWemBrwodgrpUcZJ+B5A/g?=
 =?us-ascii?Q?08LOLZTi4sYlQYwL2TjdOEhc+mfbwLphb6OhEY3D2onF6/LtIF9QoMlG6q3u?=
 =?us-ascii?Q?Pn7/5S0b86ePwbFoo57QbO/llCa05Tv3K2RfyOoLkV57c1ohHyqFvowenOFl?=
 =?us-ascii?Q?HvH6m2ChkM3hnOcH+zt7qQfeqXt93ZbIYF/Xo625NGs7Gu4h59aVaY/Visof?=
 =?us-ascii?Q?ON9ultRlWu87Ql1V+B0PFHBH/+D+geq1I0+UD4sCbBurtDYqkw9fDl1fmdEy?=
 =?us-ascii?Q?HYDx2DMHE2USUtE21x5jLb4zErj5c7+Rlu9TNjceLwdMzOIirtSeZ+iFFgno?=
 =?us-ascii?Q?jt8ZYUV00N4aPdYCACrvfLg6zq1C9X09vFrmWWdU5h2EUV5lL2sf75pWyrsE?=
 =?us-ascii?Q?YqQuga2awplFYnAgoatasjMZcyyJykcNjeuZLijJ4Y3+i/TI5iBV6q30DxuS?=
 =?us-ascii?Q?bF6hYEe/gjXYWf2l6iW4HQl/zfArsTFPJZt6b3LliDS5iebCFEDCNDbnhI92?=
 =?us-ascii?Q?4jlrk0gX3jnsaN30Q52oX6JleaImkZqe75FvUPxCb+Y1VQMiwhV0YcK+R+v0?=
 =?us-ascii?Q?Gc1iyk0n+DcU4jIF2hYxTs80WNubESs6iVNUE3KcWoMbhUfaxhXQSFz/RmZd?=
 =?us-ascii?Q?Yc6QweKOyzYK0wUNdk/ueOihrfZaTobZ5vyFVVxelk80cSw7yLx9hd9AqP4t?=
 =?us-ascii?Q?VltVgC3TyJVMlxo7NvV854+zHZwaiknHNAYk0X7bqcztp8CdUg8wFGBwmL1n?=
 =?us-ascii?Q?+8f+xE26OLbh4fld/MCw7+RVzQR1IGYxAZVyHqCI/H3HNZVZAXQ+9Mbxy6cb?=
 =?us-ascii?Q?cBu2Hu0pNDXwdE+qhFUYi/JPikfslzYkAf/tYqXxewuD8SmMM5cikGjoJ4UO?=
 =?us-ascii?Q?PhxkRKgVLCJWc0rVzQCOT6I+jGiKKcQFkUaXklKzD0bjiGotVG35CjQFdbi+?=
 =?us-ascii?Q?BdQX4G47feULZZ4iiEsz5Y1ta6109XKqNa237yvzrObpn2fEGG+KD/4Yxv9E?=
 =?us-ascii?Q?DPKuc5WUnkcdLF95x3FdOWvQPH1ND3VR2Zv5z95GrMMiKfOVU6aEUdKUZsxk?=
 =?us-ascii?Q?s3KvcJ7Wl95j7fCBVnuSIjKl2rW3smuVhMsw2eFrYl4GMskNULVNMzzMCgCl?=
 =?us-ascii?Q?3ZbfQdvOGpKLQgBtd60s3CObeVaF3fdg9HpQMviFOjn/77woAXcQQReg97I7?=
 =?us-ascii?Q?iyKrsdpUvBr54SqRNtkTygXDL/eamPUf50iqYxf9UTAG1L0d0vEsIZqWj3GI?=
 =?us-ascii?Q?dtk0ZuFTbkaHPfzeeSROnlTvTkMSCOlpVfDzUOCBnUnAxlaDrbBi1nLm3dAG?=
 =?us-ascii?Q?gaLs265AsR5ak+KHbE1RCKnR0N3su3ajNdhPgOgnyrSlig=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?z8GJ6o/pbiaZ3laRRnLYqnEDQdOsyZepkBUNCBBaOVIFntjRW0i2mhkpx2zR?=
 =?us-ascii?Q?+ylISuwPDwn3am2e6WWcvbgVm50MhX5gnliGQZWaPOqqoKRTDzM3UgXrKc2V?=
 =?us-ascii?Q?cPsftj6/vYW3krbn3hzdsWBqWv7NMFJhufB8rf3rvMyF3KS8kNxfAE2s7FYh?=
 =?us-ascii?Q?k1UL67pOfG9R6XgdX5B88e16jxRT1c2fZw3nt+fVL+Mi1FjPPATScbjvDraq?=
 =?us-ascii?Q?FUxXBxJdrc9N9aGd55Qegy10c+orS99rU0JiRHC/pmaZaefTUJGE/fth8XHK?=
 =?us-ascii?Q?mYmytXAv+GsL6dJyIFgWxyOe0R5a5A5HBMmgVSjhwHZP+diq+hX5kaL20Vbs?=
 =?us-ascii?Q?/eV99jkqDdIGK2Y7AGdSh+BCQnvbt9qDWT1nKTRmA9Zh/lZmL8IFERRSsSI5?=
 =?us-ascii?Q?arzEIKBn1O/DBuK5+c7X7hdR8ZP9e8InKKwhyym0BvkKRvnfVj7KffEdf5nK?=
 =?us-ascii?Q?yo5ttI8lKGQOL69SjZUQUlqlbBCuYK9f/PSECmREMY4EylBUGQWBtVfovgKj?=
 =?us-ascii?Q?WzQrOl2aGExTzQgqt+DqAzQFyTuuLy+wa9jRO+CQEFINzqyGzmq2LJ+o6yGg?=
 =?us-ascii?Q?MHrzf78AK/RJUzLFUYCjBqnAKEPZCQCfEe+D4IuyUO9wLPXYHvPzUL+lJOnL?=
 =?us-ascii?Q?+rnSLgLU48txUNnC58l0vSyMZ8/1JXqjPFiYulfvV4G9RVh7Q7V6VEEbJ9JL?=
 =?us-ascii?Q?SYd+/v1P5BDBXS1/+oJGrnFU/J9JIzEuJR4GKFnvYmL1mkU6d3rOT+Qhnqwa?=
 =?us-ascii?Q?TGwINO6tNxmdDs1IIqmqTHiXlaDlb2tZKyCBphf7fxV/iojXO7nfuYBCn5W6?=
 =?us-ascii?Q?w5kmXTOyVBxGZer6g+vpgyjGxwukbrYbU79SuGHMbqn3VKCtap0LcxhrV6Lb?=
 =?us-ascii?Q?8FQvUj/fYsvqdX86m/k9HCmr9vU7dmHBq1eDLlVmXsIY3poFKPMi+NKUymx8?=
 =?us-ascii?Q?VagC+AmqxwgjcDxQCGVRgVtTT95gWYNmoeiPbeF+P8tBl1YTOSJ+BiGs/JRF?=
 =?us-ascii?Q?kWG2aRdS6tdp12R56MJoCHM/XlGUhmaf7ksuq+7kR6xQNLqTu1A47X6W1yu3?=
 =?us-ascii?Q?XTnSPUNAmjCbWnsnMRqdNoEKJ6BpJozRlFgbUK/ZwOeFvdXOpf8AdJtRsFKn?=
 =?us-ascii?Q?C5LE11AE4MfP08S92lcL2c+aupNn2NG5XCwV8Vc+JLVdQ0Uvxn+XAGH7jWTC?=
 =?us-ascii?Q?ptcF8AEyypDa5IuYqOYEDQrSkKWwMrRlAE3ElCphr9U9ZN1t+KBMPw0mOGaK?=
 =?us-ascii?Q?4IOO+XhKdASsOcZWoUIa6FUzPkfsVjFNJYRf0zIy/Vu19uJmsMK4uA+xKejt?=
 =?us-ascii?Q?1c/5s0IrX7TE7YA38M/lRezlt3KAOL9Dx6hZOuHCK/1mgDlY5FDS++NGXgTk?=
 =?us-ascii?Q?sqFDRW58/EWY4TLdC6yI4L74xrowHoeun11daTd59cgHoOzdt0VnxHCgYhay?=
 =?us-ascii?Q?kiQOcKUnFJl34t5Nz8H3neJJ1+Ov8bgsrsDioT8btGb9KpJkqwLJ5dbFkVmC?=
 =?us-ascii?Q?ORoWgvEW2XkzR2cnCaRliQwH4wKFp2AyKJrja4VuB4w/oJ3GJuMAKJ3wiUGD?=
 =?us-ascii?Q?E/IcntALBkfT7bpcD6Es1NScMwIrHJ8x2QUJUCzL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca411671-e897-4bfb-b745-08dcd1d33c26
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2024 20:00:35.8629
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OwPUoXIc1YAL+3z3chkTbNr4EbqgvVi9YMd6FWupeVFpM/X+/28d0WLotKyUPOg9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8426

This domain free function can be called for IDENTITY and SVA domains too,
and they don't have page tables. For now protect against this by checking
the type. Eventually the different types should have their own free
functions.

Fixes: 485534bfccb2 ("iommu/amd: Remove conditions from domain free paths")
Reported-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/iommu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Joerg please pick or squash for this cycle, thanks

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 2d0a681a205211..154f90e7b98e1d 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2257,7 +2257,8 @@ static void cleanup_domain(struct protection_domain *domain)
 void protection_domain_free(struct protection_domain *domain)
 {
 	WARN_ON(!list_empty(&domain->dev_list));
-	free_io_pgtable_ops(&domain->iop.pgtbl.ops);
+	if (domain->domain.type & __IOMMU_DOMAIN_PAGING)
+		free_io_pgtable_ops(&domain->iop.pgtbl.ops);
 	domain_id_free(domain->id);
 	kfree(domain);
 }

base-commit: 22c91287502b4bfc2899a1006709eec8273cf052
-- 
2.46.0

