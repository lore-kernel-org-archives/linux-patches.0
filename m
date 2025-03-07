Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2048.outbound.protection.outlook.com [40.107.223.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80A8823F296;
	Fri,  7 Mar 2025 18:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741371457; cv=fail; b=gNdD+AHSt4/hgJ7zA1TSuSpqV9qyi/fQ0XNMUv8sh4dwzYrXjssAOWovWL/jbeJmoFiAOUoCKJzbnfrez/wyAZieB/L5Tr968fQMB7an7ElAaVEr6VzdEikVsK6oB86DqSQEzIOgBCySB3dS0cAIJ+YokueN5hpDYjMYJximsrU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741371457; c=relaxed/simple;
	bh=zSrpSgZTONqhh416WQQl8DFEwGY7l7zZS+lS2vNcjhU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=iHBw/alHpxCOcL36zDB94oYlK3pNsIUamytTDmkAeRnMnEbg0382ajrEFC/iZ3gUadWY32tPoGaqDY879kUgIDidGd2ykQw3HX44xXQIlJ1KRhLdCd63eZPFznWP5jyaE3KroQB/o5EFc8IH5IR0dX9IFB5uz1dE8u0QHjKcYos=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=GkPtlVVI; arc=fail smtp.client-ip=40.107.223.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="GkPtlVVI"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iNSzyNuh27Nu2ktDYvN4z0i6DJNorEl2Cv1yapo/O46JOoeyLIwQHegODopWX1EiiWhj2M+nSpBwsJomulhgC1U59uB4aLTBG03nsQ69vXsIgUsw/m4DVptraWAjaT0QfJyug/6d5Uf9yf6bNiu1D2QsIAsqSbpa5W1hSAE7zxKjf6mdEjKU3H1qiPL4x9Z1H98su5ejN1O7MT7yn/zW+R0yzGUAMXDq5bxIrXcufQaU3UKzmYqhGtK14KBqktfnJAbsIWnyrF/V8i4TZFdvgw5KsN33FTtnNi1NkDs5Do3y3Qv7a4vGr8OB72oMM4RQ8kcjZhcaq8mLsS1NVXwSjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y+L4bGojV6K/KakVIMWPg83fie3RUC9OOWcwiSSPa2E=;
 b=jEfn0SkbX1CPRLVrHHciXwiF0XSupgJYf3okOzXwl2iiuBlBSrzG6ZK2eRkjv0rEBcQ83r62jmJNt1NkQHqRKCCNQ+jbh4M3uwmEwsMm2qNtePLX9fM8P0wuFpkTat1Bh+fM9dE9Xg+i6SvVG2J+yH0xy0bEWiWhb6FR4BlVgSlAAM2ZbEl6g7dyZzWHMVqP8BhBwdslb4ewwJ1TegFTkebwo7MEx+H2yFmgXIOH3Ac3RuGcInJRskwJtDzsBfUNC7yHGk0d41gne3FK0SkpY3a3PiPdA3NB+rXeOpoxb5VMXSy49c9vJtyX2+kr/eKXaaSXzkqvN42qBaBVT5N+mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y+L4bGojV6K/KakVIMWPg83fie3RUC9OOWcwiSSPa2E=;
 b=GkPtlVVIj3mJRJSBQgSWheP4cwqeVmJJEcb2xWqumIHEiTp+vxwzkgDaycEmGeZoVWwy3CCS/DnIAvjmHb6XKbDLqcOm6CpLRH/ObVJRJy9r9OX8UrACHy1jpiBZrGVjiUvkpHYqPZZ1CkpL9us/0ZvUVLEoSxHQdHiB+/43LEiIMVxpFKSBju0GboWwFEuZfLgxHoE1VxVJ8HT3XB+9O79P8+VbZ/IgrDn2v5kypddZJudmhOwtNY58pWdZlJbgvIxwHQoVvfHtcPgdj1vvVLdgy2f3CTFu0k3G4n/GzFEDUzhBkABTWsNHdtW579VkIuUPjwNvaNPBMyarr1e15g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MW6PR12MB8663.namprd12.prod.outlook.com (2603:10b6:303:240::9)
 by PH7PR12MB6539.namprd12.prod.outlook.com (2603:10b6:510:1f0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.18; Fri, 7 Mar
 2025 18:17:30 +0000
Received: from MW6PR12MB8663.namprd12.prod.outlook.com
 ([fe80::594:5be3:34d:77f]) by MW6PR12MB8663.namprd12.prod.outlook.com
 ([fe80::594:5be3:34d:77f%2]) with mapi id 15.20.8511.017; Fri, 7 Mar 2025
 18:17:30 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	virtualization@lists.linux.dev,
	Will Deacon <will@kernel.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	patches@lists.linux.dev
Subject: [PATCH v3 4/5] iommu: Do not call domain_alloc() in iommu_sva_domain_alloc()
Date: Fri,  7 Mar 2025 14:17:25 -0400
Message-ID: <4-v3-e005a650174b+53def-iommu_virtio_domains_jgg@nvidia.com>
In-Reply-To: <0-v3-e005a650174b+53def-iommu_virtio_domains_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0871.namprd03.prod.outlook.com
 (2603:10b6:408:13c::6) To MW6PR12MB8663.namprd12.prod.outlook.com
 (2603:10b6:303:240::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW6PR12MB8663:EE_|PH7PR12MB6539:EE_
X-MS-Office365-Filtering-Correlation-Id: 11814bb9-8d82-445c-91a8-08dd5da451c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Km6qQhWTWW7WeTqmRTLCllnP7g+jnK7lvN4RW/1oQVrZOe51wMNi1tg8YRa8?=
 =?us-ascii?Q?q+n+0TKfTunYptXt+sOhQEpaZLA45taCNgVdGqnE9Vpsdn22tXKnpZ6eIfI1?=
 =?us-ascii?Q?bWTWK8BzbYS7uKd+r6vZEh3J3g3pVtLtXkobTbUC/U2s2ese6EfXjX7RQP+f?=
 =?us-ascii?Q?Tl3M25I95HjJhSnscJtOVW3ClX3vlfcEJ649hi+8+TKNYQo52s5ATIxB/Isx?=
 =?us-ascii?Q?rR5eALaaYAMCbBQrEgZfB8M7aTabhhsKXApzNctoahd3uOI7f267ACImlzPk?=
 =?us-ascii?Q?lf7DAPv1fE+wZToBOW1VhqFN6hUnzgpy8BT7wO82QPZ+So/J5q0a+T3+wwur?=
 =?us-ascii?Q?if7QZLw9+wlcDvRJQMDHxm/RJEFyuREFrcqwsC0UAXaBGH8Woqs/pWeyW6kb?=
 =?us-ascii?Q?/LHwMH6etOZ7m2G2fftd1igxIzIz/ZQmEbSxi1QPLs4MRL7zaVZ2cYcI1xlg?=
 =?us-ascii?Q?1V/CAyzSYbztDe/buIP73HYo6NPl4n1BVByDoGOUYH4LTbPXcJfQ3i+00QUl?=
 =?us-ascii?Q?77TWa/QwN8sti3QWp+a4eeSPDXyOrvA93CAPTO0+OY8WBpJBBLqzFqZtcewa?=
 =?us-ascii?Q?ryuCGcqBka4Z5xH08g1A7CeZ7WJETCjbhg/PaR23R2DzjB5PkaqkPRIIBMaV?=
 =?us-ascii?Q?fd6Lnd7FC3vnXXSHNRDDSdHjGz8xkyNU3q6kfxECId9DohPjn9psSJH/G7P9?=
 =?us-ascii?Q?XJl80knEXFmuUbPBApjxMJxw4XAusWu12J056s/O/jbmRtXMSlp/9Nr8bB7Z?=
 =?us-ascii?Q?17fT+MP+1KVjlwBd1DRw2A1nhXge5cEBlB1CDRRTOlLj3hNQrYnq/LxrTyBW?=
 =?us-ascii?Q?wl42ostkp3pmXxLsg8ZnxxnNgFaR/dM/e8DkNRjORULo6PYzZayXV/RqFIVR?=
 =?us-ascii?Q?hNiz7YA7dsJCz+OFFVCPMq5QY0vkZvdDdQTmDEC/gopF5lQlNNYWheO0q5+L?=
 =?us-ascii?Q?ozQD5Y7j/YVubI3u2thQclSg2vn+Nf2+NioRVjQcsWpI9SwFSElVdHbKFqSu?=
 =?us-ascii?Q?e/R9XvXV1SrwXqxRPGlMnB8Ctjcj5SgBbU0LiuE7yHlt1iMwCPFgkDJ/L9z4?=
 =?us-ascii?Q?js77GwZAXiHLL4PKYqwJagBFDNUnToCGKsMqtkM5oaHIUcfBAtb9o8+5ITSa?=
 =?us-ascii?Q?hu5Afy6yVGGPCc/6L70S+w0PRxA498IixbHrG8XIiAwAXYIsvtcsZLfNssKe?=
 =?us-ascii?Q?48ZRzETOFpw+LZp9FDGdFdYRGry/eIMUD2DPqmsn904zgxMrisM9TNm8Htyc?=
 =?us-ascii?Q?kjL1XQKUc6dc6X1flDZbeOUcqfUijMKLqSCawHyQrGgtsWlZxoFd5yUrB5es?=
 =?us-ascii?Q?AJfdy5z8Em98ycBbO/CYRVmRA3+a8k+Y82RmHh4RDw6Ygu9Ufifv7EuZsXgq?=
 =?us-ascii?Q?tI3NU+wxkM/RBZ91pbbK8e/US6VB?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW6PR12MB8663.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cynLOOnuB2lcNLV3N2TnqkricsUWM5BlSy2hZPqc1iSqjhrtZCGL6ygtZNmE?=
 =?us-ascii?Q?OxB2O9Th7cfE+Rm4VZjiZzf4kuWtm6OF86ngziWX+oAYVj2vStQc2tFqzCvl?=
 =?us-ascii?Q?LP9XGnGNgU2z9Qohc9F3L37rEezdRlg/IlNHfQSooHSXgxp/p6gq+PQL62ZS?=
 =?us-ascii?Q?OMDZMafb9HDMZbYJLZJbx6NzUtmX5POzIu5YYLFNPCDlE7e5UKXipHEe7bTX?=
 =?us-ascii?Q?xwjHn8lQfx/3micYtnWHwev1Ui/PaRWjPcMlnsNnPw6MLvcQfjusCeWO9nF3?=
 =?us-ascii?Q?6Tqe4Sqvi6wp/6jwR2O0IREi6ssfGE8bQCukjJ6lKMV/5bq7TnLdzRmG2/Vm?=
 =?us-ascii?Q?ml7yRG5L5exFPYvOCcf8RyfYvZqVt0RqjUJXwobyicvQliB2KIMax2K1xBE5?=
 =?us-ascii?Q?SJgH23u15a3hsZ7+6n5RBHZcM00q09oW14JiYVBGPljiob4MmN6xShwNXdNR?=
 =?us-ascii?Q?WfVwVZzLCmMfRgvvTG7TbJVOv/O/6r9MKj3Jt6OMXTaQh33xPpxltkj5F2SY?=
 =?us-ascii?Q?aicVquRFUJRN+/wKpmxZID1R+F6Nx3UdJxRVXRuGfa5uGYsfoIDSEWCRi8Rf?=
 =?us-ascii?Q?Q9uJiIEesX0WW4QE41rWOmAcZP82GFmeR18BH+YbvAImPMkkJLbukjGH13gA?=
 =?us-ascii?Q?Q1t3e8Ri+7ya/VWup1/trZfWoGY0Tu5Og1vW3k68kZVuQoPkSWU9YPhC5us7?=
 =?us-ascii?Q?G9MQwakVDDUh2X9iEUzJNEe+8NLVsQIMgfCWtoJ6q2k/RfMBJTnrBwUTLmrm?=
 =?us-ascii?Q?CQC25zTC79HW8hQoMjHeuN6B2nwIC7CcNlGOSrcPo/IhIQ94DGhnK6eMmXhX?=
 =?us-ascii?Q?CaR1VgY6zp+iIpyp/W6YilCSx1T0qsjWu55/d00+Xc0MBGZtDF4mGblzRBH9?=
 =?us-ascii?Q?nUtBjKxk5r/073+poIafYvchboMNo80PqIGTbSnOr8aaPymvs0O5iCeLaqPX?=
 =?us-ascii?Q?JzL+EFdMnYIgmBIRhgA6YiLJz0O70t5sYX6INPHwxLY8KmURorL2aZO/Vwue?=
 =?us-ascii?Q?kLN9zC4whyR+xRHnn1ZsnRxeSBAhM0cXkbaqyInTn84VgrbuF2nJeD3Gme+t?=
 =?us-ascii?Q?TTf38WQwaDt/BRiIeySJHTBDSexbql1rWseixe9mXHJuTe9Dy3ZyZO9n7nI7?=
 =?us-ascii?Q?ykwH4swXIn1817IzTR8QEUtZlUcWdWsmhZMEc9IREtviGMg90xZa/xsaY1Ku?=
 =?us-ascii?Q?C37xOn/U712bLfWs05YkM/1UKXTEnYnLYD2bneyMvycmIaneEpTB66ALHzrX?=
 =?us-ascii?Q?wTe6yLWbkY+v7Bs8BHADy6IkVQJ6x81jz3dVJhnipDJlH7UleIgN43SY/thG?=
 =?us-ascii?Q?f1ilD79vso2iP9ZPSKmMqKLOeCmm1O6nTpKf0E8DU65+kKHBrpERENzyug7Z?=
 =?us-ascii?Q?egeIRW3rRgJxhTl3MmwB96JYzqp/7ODZ596rjUC7xIHhwmQmPjwePkt5QFwi?=
 =?us-ascii?Q?m4gxvk2/90JG1fDBIvlSgglujTSos65/dKcVeuw/nLRVLemFzt9t/nYu73fY?=
 =?us-ascii?Q?FFTlWTrd6FpJPALA5jwE9XeWW1M5uG2q5TLXXf+e836R0L5CxfMNsGZS5Vuh?=
 =?us-ascii?Q?e7z6/ftPIGmHkAzEJVa5X7F90jQZFYz3/qqo3Sgl?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11814bb9-8d82-445c-91a8-08dd5da451c2
X-MS-Exchange-CrossTenant-AuthSource: MW6PR12MB8663.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2025 18:17:28.5533
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cLpsT3k39bgx2JKxW2JPEoVgP7UtLasHwB8+SqtRdVKAW7gHMlMSGlSxCxeIWsye
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6539

No driver implements SVA under domain_alloc() anymore, this is dead
code.

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommu-sva.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/iommu/iommu-sva.c b/drivers/iommu/iommu-sva.c
index 503c5d23c1ea27..b1cd32e665b61c 100644
--- a/drivers/iommu/iommu-sva.c
+++ b/drivers/iommu/iommu-sva.c
@@ -299,15 +299,12 @@ static struct iommu_domain *iommu_sva_domain_alloc(struct device *dev,
 	const struct iommu_ops *ops = dev_iommu_ops(dev);
 	struct iommu_domain *domain;
 
-	if (ops->domain_alloc_sva) {
-		domain = ops->domain_alloc_sva(dev, mm);
-		if (IS_ERR(domain))
-			return domain;
-	} else {
-		domain = ops->domain_alloc(IOMMU_DOMAIN_SVA);
-		if (!domain)
-			return ERR_PTR(-ENOMEM);
-	}
+	if (!ops->domain_alloc_sva)
+		return ERR_PTR(-EOPNOTSUPP);
+
+	domain = ops->domain_alloc_sva(dev, mm);
+	if (IS_ERR(domain))
+		return domain;
 
 	domain->type = IOMMU_DOMAIN_SVA;
 	mmgrab(mm);
-- 
2.43.0

