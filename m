Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2042.outbound.protection.outlook.com [40.107.94.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B09E323DE;
	Fri, 28 Feb 2025 00:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740702013; cv=fail; b=Iq31aUSJEpkhyuMSrRauGY9Fso5h0psa3v+1+i4KEE3DTgwK4l6k2CbHZZCuDkmHRqQTNUOovtQqxOVOaGMV00+PwzFAjWjVmbfpavYMfPUt48DBTUToeX2NOoUA2EIRBIh9mfcly3/GVFaiPr+c3rEo8r5vS4aqTv+gLMsNOg4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740702013; c=relaxed/simple;
	bh=P3nxhsh9UZ2029Z/+D7Hs5/XH/mYA2+gPakPTo2Ro/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ojf/bdOsqV8l8YvSlAc5fcxI1N3+tabhjt6b3L+Efazmb7kofRIgs8m9VCBFnipVynXp8rfXUHO/MBOP1ebJdGXgrZLkZ8v7twX4JZuq53bcuDDVGj5J9UXta/JuRrDN3rEx1+IBU1UMvByzHUOVKc+XlNtdP4/9XFbk+k2ga/Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=K8XsfW2n; arc=fail smtp.client-ip=40.107.94.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="K8XsfW2n"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J/0OBwoFfOYQr2PzIlIVBnumz8wjKO+3I5oZW+vHXJtTYw5K3YNWG2Q0TBjipMcUWo3h5G/4sV8eTj5pRAzBuezqorboOMZ9lKHCeyArSs0IDfhvorD8oSAaL9czcy0ftq8DVl6RDQefK0mGi4IS4i05812ydkJK28PStntDmXyh1qGotS/V7/1KAL2Iot5ib+wAvBqw0qwMC16rcc1cAT94YzJzBl6aqBf+Tp/AzEW0/5SShR4ZWIwlnOIrz8SBYpu5bkgd0pO8vMitiqgW11gPyH+GuGCP6oqf0RVfUCZXO4QzyqoozjfLcCSbyPy3IL9Rtb950gDKdyx6XR9azg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3enVzVfea/GcMgcMICGS5TOHTfF+x7hNbg17rcVPTzU=;
 b=QsPR9dP53Rod24e2SG97ftd/5wYp9PImeDPZqyFAPxZb+pIOr6ANNxu0eWMl+djzycBoD24iFRfoRPvt2FikIz8eUQOYLWCunyyUJp/yjHOR2WiVX1y6htZCimAiswt2wQtUVSMTszT2XfZFhSTA+axwT6P0c08SMqCr6QStq0zWqVYt0+FuWkGElyWyXkXdm35cheLdqgF+sa2S6xCARm69gy7limBCyAET02OECyIXySvTQoN6LJyBfRbm3/n6wpiFsXyFxj7VIsiRo+fBd2MwQMRWVy60esMMfVN/l9DPnawTxFWzO/nObvoZAVkYjDmP0UHxs2qQ/xUkepc8zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3enVzVfea/GcMgcMICGS5TOHTfF+x7hNbg17rcVPTzU=;
 b=K8XsfW2njDkvrP5WGcGJKGNO4lib2L6578iI3TPwJfwlmUnf89RH88eaNM3ISBHLQFvN7X+IjSzUPhWOJrQQjwf7VA2JNM5kkMb0o+ejbLPBZBl44FoxeZb7HeHl/f2LtoxRKXg2t42ShygHTnBgkrpQpPREe9KWQpk9WkCAA7A49x1rjhW9M3DHiwxhl1o4QIJY/xbEHn33lQMWN4Fco5cf3JomzYtKg86yHCiZ9ga555LfF7zoE3DXtdZjjIxs0Xf9d/6y4su7WFFBHI2YqZZe8ESyy8VFwTWpp6FCqm2Iu8xpjU/l9mTEtDF1WO1+Mvftmx09spEEeszKFZCNTA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CY8PR12MB7433.namprd12.prod.outlook.com (2603:10b6:930:53::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.18; Fri, 28 Feb
 2025 00:20:05 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8489.021; Fri, 28 Feb 2025
 00:20:05 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	virtualization@lists.linux.dev,
	Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
	patches@lists.linux.dev
Subject: [PATCH v2 5/5] iommu: Hide ops.domain_alloc behind CONFIG_FSL_PAMU
Date: Thu, 27 Feb 2025 20:20:03 -0400
Message-ID: <5-v2-a3b72fd4b99a+1b6-iommu_virtio_domains_jgg@nvidia.com>
In-Reply-To: <0-v2-a3b72fd4b99a+1b6-iommu_virtio_domains_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN8PR15CA0060.namprd15.prod.outlook.com
 (2603:10b6:408:80::37) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CY8PR12MB7433:EE_
X-MS-Office365-Filtering-Correlation-Id: f5a31744-d09b-4e36-6630-08dd578da636
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?MmcJKN9gZ6icFz6AMg5NO7g0DexJIPL+ygN0P3K0LfEbcC6JmN0rzIZabVFK?=
 =?us-ascii?Q?pT+2dWPIwcyiTE7tc5hN1d1mApttXc+DFldqbd83jTJzSoBcy/0Wc8uL4k2E?=
 =?us-ascii?Q?9r1JyiI/jEShhod5DwNz+0i5YdoHvjAa8uxVUjLmKUzNhTQc8XPVLQQjhed8?=
 =?us-ascii?Q?sDp72YE2se8HMGv05XU8ONwcwjfpfiAgnqNLf8JT+qjKPSVx+IThZk31Cd52?=
 =?us-ascii?Q?vO1L8wPpoh72Vjklz0oQTIlFh9SiE5UwtapaBpcwx48bml/6yD9Be/6nVedx?=
 =?us-ascii?Q?nvsT6DTrMEyp03/FoCfKOO2x1qC0lm0mt49ku+Jx+ONI1PObuc4D1W4oY7ic?=
 =?us-ascii?Q?XmKC3BRGidAwkOy1yCEn2x80pQbrJoCngx1tr/7Lx2253EnN0C8BVHh//WWw?=
 =?us-ascii?Q?ovv+CL2adG5RbIdqZG0x6odE5PlKiQSbSz8vuolCUiwxGrTYpdBcMBfYs6eg?=
 =?us-ascii?Q?j39SujW2IQUnOSj9W8Mcg7O1TBOsHdJE1cJLeDgpX3kDvCsadbHTEataRWD0?=
 =?us-ascii?Q?z23EghlEoa4NshKsA7+kV7feExNlFcNkuNFAW1R8b6X/6ob1SBgtFJU3rl2v?=
 =?us-ascii?Q?Y3nSBWQKrL+m6+yRKmC9Fuii1xdSiglPvOop4ehG8MAYxaypjIp/xUu62AQl?=
 =?us-ascii?Q?iZEtzL9Ll+FkL46UfVdsGzoKDR9kY+xU0BBMGCDGEjJ+thmzC4Rozn7sx+ce?=
 =?us-ascii?Q?KTp8VEF7JCjczYBn1qaVSbdLol+W9s/w6sb4VHy9BVfJs+gJ+JyN1btAgNPK?=
 =?us-ascii?Q?KYpOd7nSdWR+46kwjMHRHqOpeami7uSKOmwQQY8/NU+6X26h6M4dOLG2CbHN?=
 =?us-ascii?Q?MLpKkkcc6+5XCHcmwEfwiYvn9rSoUXjp+PEVkmRUWCq2WO51EJ1dKBjVfoSt?=
 =?us-ascii?Q?H4K4QZWXtYA6KX7qgJMwWypb3DBneJV+TRNw5TeL9ps79TpMaZ5jy1/fBEOU?=
 =?us-ascii?Q?NoeFjdHslxLeABU/hJ+G4g8oflitx9XAWOHh5bTvHgsnGmyWhLijcO5+dKB/?=
 =?us-ascii?Q?lorDAOuz4/cSs59yPdHKpi97xtvA4OoNpb3Fjc4uwvhXAUjhjEyEkYszdmsW?=
 =?us-ascii?Q?eBHE9m+9pFCPmeL1zrqWoDLCO54T3AOgulY3VXSNVsJczJZwatGqBXaW2DyV?=
 =?us-ascii?Q?5cE/J2jB27c+Dr1aX0DjGlqntdFzmxRHQHOk62fx8Box1o3FeiwaklVIJTuI?=
 =?us-ascii?Q?dPDUbnq97D+iTiYS6lW1y9v9qzZ95N2Ms0EQZqk5T8dAgSStEVmjIHoQt6tr?=
 =?us-ascii?Q?SE6x0ym5ICWYd+b82HmyOrbyi9KPsMxErnSrL4UhEQQUlN4gTGaGtnf7dDpf?=
 =?us-ascii?Q?Tc37tCYVSJ/WHf7lkA84d/2y2iREYnRDiCZ5WFROhir9UdTDcdbY5it7uy7j?=
 =?us-ascii?Q?D5ATbBYhOwIFU94/v7dCup3Ec+cC?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/zK4w048ibBxBMXLdc6nSIFOohTp8hc4VibDWlVrw7Zf4njynaIVKYwi29+D?=
 =?us-ascii?Q?KiAx37qSdSthZYYKBWoa91fLeWSz/VdcyvyH9joQArh7hXKC4dnvZIfsLmcX?=
 =?us-ascii?Q?72DZz5d4vsvi/nx2MzUJiRR5cJslfTSLrpLV19L8dmSwee0SNvhDPWnOxMJv?=
 =?us-ascii?Q?F1TMNdF8k2IluEOTCKNkcuhQxoIbRur2XqdNod84WxM5MlPCMAaLmmwKc6xa?=
 =?us-ascii?Q?Jav7hCvgZ728xdmSD57LBIiFi3q2n0SZGlOmyKdTkgd5ouDIiSrLc2mT2AQb?=
 =?us-ascii?Q?JKA2EwWhqjVUoctmCUQC9DCxJT5WaysuT8dRc+D9TilxvAG0Zm9WQrWLo7CF?=
 =?us-ascii?Q?KmrR+DBZfS9JDDgY3aNtF+i39TVFVEQF6fKQHA69bt+0GhB750i8Mu2PxWBq?=
 =?us-ascii?Q?Kq8fXE+5FqKm6g7UfvUKcJUvEq+lu/zyjQwv4hLHYboA0tYT04uskRGOKXLp?=
 =?us-ascii?Q?GgMDfWyPEy2j4UleYBSA/M/OM+JEoNcGWcCx+SUgq8An4fPLrBedbEpbFkCh?=
 =?us-ascii?Q?DU6ayNrTyFA1XdLngTDNBW4YGgy/ggL3jyUdwRbGiuBrGCuNIa+/tqzQ0VW1?=
 =?us-ascii?Q?4CUgofLRYc8N7yDnYxPD411Pfy4VyNbXIwp1GnJQBxoww6YeHypbFk1iNe0V?=
 =?us-ascii?Q?1TtBVUzKrZmCnqM8hB0/EWdPd4YmaRmK9TI2XABArKxxIsVB9rfF9fvYlFyc?=
 =?us-ascii?Q?vfki7tCfnUCzuwOEdOsJACyitOklpKmlNkLS5DqI4LgTOQMu6eM+nv+bANeG?=
 =?us-ascii?Q?SAzDGee6Cko/+JbU7drVyL8F76VgMc4hUKAwIIgVu6S6msetB0fUrSuw5ttS?=
 =?us-ascii?Q?qB+Oo2L6dV00QNTgHieb/QGkfbjWpwx8XjIw41ozMP+T55NKUo9pyY+8G0u3?=
 =?us-ascii?Q?IWy07lI1DbEvnJus658PmGR3T05MLiEWWqaU7TnTpZBWrJp874AA/qDishYv?=
 =?us-ascii?Q?6u0WzJ0ZZaqSSCR8giHaYD5QrJypNUndkYYA2nkpIyqGW0DRz2qaR5d3hfso?=
 =?us-ascii?Q?HOzuPj/3mTH0exD2qnVPFopiYSoj5YDNt1xeO2vC4LlGqCD9c3D3imDgj5Jl?=
 =?us-ascii?Q?/reGf52U5bc6CbeG69UgYyKGw7A//ZtIu6TAKwNGVXVhiO9XuF7QWJQOzXlu?=
 =?us-ascii?Q?VFdXKyhaUOmgY0emvCSsLkkwMZ3jPiEalHYqQolHV42q2tqRdoKUKQy2vk2x?=
 =?us-ascii?Q?HkjZVF+Jxa52AhWx9rhsxxaDhv/aa5YSnZoq/nbuLQQgJZKquqJb6/zLZ62L?=
 =?us-ascii?Q?Ju8CgrzqvgPHvVsmTcOOIFVA9ehb4AMe9GNFlczPM5ux8RT+XC/vJNv8JuzT?=
 =?us-ascii?Q?pzWzQEvlE3irc5pKwO3ZiLqbWCn3lpiJiIAg/JGM3pO5saxl4orJguEvh2cg?=
 =?us-ascii?Q?EhDoPVY9dRN7vUhiVVhEMEk5Gd687fdEcECQSeUeUufhp7QKA9xm9y26FhnA?=
 =?us-ascii?Q?kKD5l7xEC1xvpia4CrhJ3y3Y5KqGJ89KSIpqiRo2MFUsahbDfeENTgIQTYQv?=
 =?us-ascii?Q?3A7o2Hd3EtY38jPXDm5tvE4jT924pdRsgOcp+uxd48U9oycajM3Fox3i2vgL?=
 =?us-ascii?Q?8KfPbgnsgJrxcC0hiqfi6dHWqi6LH2yKA70m4plJ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5a31744-d09b-4e36-6630-08dd578da636
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2025 00:20:04.9640
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uf23TfbopaLQjoLzUV8CSFsl08u4TSpGr9gdITT83Eos3ON8/w5hA6LW1jsrXLNv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7433

fsl_pamu is the last user of domain_alloc(), and it is using it to create
something weird that doesn't really fit into the iommu subsystem
architecture. It is a not a paging domain since it doesn't have any
map/unmap ops. It may be some special kind of identity domain.

For now just leave it as is. Wrap it's definition in CONFIG_FSL_PAMU to
discourage any new drivers from attempting to use it.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommu.c | 2 ++
 include/linux/iommu.h | 6 +++---
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 73a05b34de4768..b81a82df9fed25 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1987,8 +1987,10 @@ __iommu_paging_domain_alloc_flags(struct device *dev, unsigned int type,
 		domain = ops->domain_alloc_paging(dev);
 	else if (ops->domain_alloc_paging_flags)
 		domain = ops->domain_alloc_paging_flags(dev, flags, NULL);
+#if IS_ENABLED(CONFIG_FSL_PAMU)
 	else if (ops->domain_alloc && !flags)
 		domain = ops->domain_alloc(IOMMU_DOMAIN_UNMANAGED);
+#endif
 	else
 		return ERR_PTR(-EOPNOTSUPP);
 
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 6389d59178ba3f..55cc87bc62f5d0 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -554,9 +554,7 @@ iommu_copy_struct_from_full_user_array(void *kdst, size_t kdst_entry_size,
  *           op is allocated in the iommu driver and freed by the caller after
  *           use. The information type is one of enum iommu_hw_info_type defined
  *           in include/uapi/linux/iommufd.h.
- * @domain_alloc: allocate and return an iommu domain if success. Otherwise
- *                NULL is returned. The domain is not fully initialized until
- *                the caller iommu_domain_alloc() returns.
+ * @domain_alloc: Do not use in new drivers
  * @domain_alloc_identity: allocate an IDENTITY domain. Drivers should prefer to
  *                         use identity_domain instead. This should only be used
  *                         if dynamic logic is necessary.
@@ -617,7 +615,9 @@ struct iommu_ops {
 	void *(*hw_info)(struct device *dev, u32 *length, u32 *type);
 
 	/* Domain allocation and freeing by the iommu driver */
+#if IS_ENABLED(CONFIG_FSL_PAMU)
 	struct iommu_domain *(*domain_alloc)(unsigned iommu_domain_type);
+#endif
 	struct iommu_domain *(*domain_alloc_identity)(struct device *dev);
 	struct iommu_domain *(*domain_alloc_paging_flags)(
 		struct device *dev, u32 flags,
-- 
2.43.0

