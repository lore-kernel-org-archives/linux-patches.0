Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2053.outbound.protection.outlook.com [40.107.220.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA97C243379;
	Thu, 12 Jun 2025 14:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749738712; cv=fail; b=A4jpH4W9oSV2aTX71oobFEONKQPgAt8A/R2Xn3MVZh5JDQf0hP95/KvFYTEe8YAHYZPLDNBbi7Vml5TYaSp/lwA1EeKJb28eqP3eJq9aL1Qy82qw4G6iemyvVwUywgzebGEsBK/CymVn4PPf0UAEjvElDamxmdsG0oTrEhCqvZA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749738712; c=relaxed/simple;
	bh=WYSoWbeR869MsTCwCFD2JWFOnxWG34J4Dvphv3BNC28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Yr91o+vJIKTkGh+IGdgn7MF22jDtw99b4a/GMwXUR+DAqilsODek8B6elOQTod6yLG+qxN+iIPbBeZ+BIvHSoDb37khEV/YuzRQt4PKDj3pa2OwYa2BDNuDBT2v7xVZ0qmOKOZ/2olwaaXkCjMZCrAYN4fY8qAjzkia8iS1i4hI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=XD3a3xe7; arc=fail smtp.client-ip=40.107.220.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="XD3a3xe7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o34hnV6dIU+yTQ2yKYup8IQ1SAAA8PZFwyiirLdyQdr8Zw+3YfgVvLMtvJ/ZLJ4Y1Dl6MyAHbGUoDbXY6660/hMcgAHdBnNGVtfNbQQtD6StwW4N+ql4+Sqy9KzfecGv0KaMHEzLOyWI+DsvNY9/Nf/yV1WyzBfG86Xg4Cpg2t/AVKT3lWbPMiJwHrO4Zbn+UYdFtAkXHrThn9Sr+kC3K/NCI8LRUU1jAJaKubysfEGi68e1IlgHJ4GlOkWnDXaSWhF3xz1mCbNWXWZryuh+sfV15hs7/5+bEjpM5OTPBY2PxwUP5QDQkvv7051FO4A/YPoNe+LPgfhnYq/OWrNCKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6K/RN+SM7+XUbeDAIluzfnIbXLprJmznsXPKA+BECdE=;
 b=OAfuusLnABwrrUlDPhknI6anF1PW+SF/hw2FqJGH1j0SBp8tg7S8NiG7/6SAqhxMXPeg6fRsyMl/KJqDwEKNcdvX/10AzoYZZjuXrCLcNbKLUPiwhECN67gzcLfdscKIxyLgN93FzVrceoCzKJ+dnnYx0wlg7bTIawRT7UR+ttOpoI42bRhIFwe95qoOPpAseQph88l5Fgyx/+cuWh7y0sPOD0qqutRmmbG74OPA+tlPs/+Vw6pu0stNdz4iPy867BUCo7umcYV3RwWcEEFShZ6OMRPh63HYD7CTID3MtfIrn17sZ3mY5cZoxKzGOhf09gudhUdnLlV21hy3zyt5Bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6K/RN+SM7+XUbeDAIluzfnIbXLprJmznsXPKA+BECdE=;
 b=XD3a3xe7CtasoFfUOtbDmRFa5ry9KcHKNxdaCqgXZHqThYe9yRCnjjvrvIo4dENGwNvPH865FQuJkEvMBI/j5VqXhtExSVTgVBfTaUPdjjGSwROGN4k59Oam0Q2j4Q3hupq0Ysg7tt1dn7hv/llPRFjPBGg4+df5LwPJuMUAbRNjJly93uuSLGpXv9gkenpZU70wTOkH3rGvWq/0IGgINic3A5EsPmGKF3nXMVpIjJ2t6N4ncZlQhhesZgHr5Z+WTqVOdpIPUG/Y7Aw+0pngFnkRfPdbJ3JMCewuPSsMvtq5qUQsMm3nUql1+8YFS6yvSZAU9RQtZuBzWorNBth5eQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SJ2PR12MB9086.namprd12.prod.outlook.com (2603:10b6:a03:55f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.19; Thu, 12 Jun
 2025 14:31:42 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8792.038; Thu, 12 Jun 2025
 14:31:42 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: patches@lists.linux.dev,
	Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH v2 3/7] iommu/vt-d: Do not wipe out the page table NID when devices detach
Date: Thu, 12 Jun 2025 11:31:35 -0300
Message-ID: <3-v2-e5c01fc5ce82+26216-vtd_prep_jgg@nvidia.com>
In-Reply-To: <0-v2-e5c01fc5ce82+26216-vtd_prep_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0317.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10a::10) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SJ2PR12MB9086:EE_
X-MS-Office365-Filtering-Correlation-Id: c1eec5d5-bfc7-4253-f38d-08dda9bdd91e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QhsQYf6u3pDEyWj1bEAb8xWzEXwZPMn6IgjGZ3ZBuCsBhu2pQGQtwjm3TwtM?=
 =?us-ascii?Q?HbYlsXsNVwGC+OaoFMPUd9FgZD1N9NN5QkXcQysPEMb4W9RBnAjliV6D7In9?=
 =?us-ascii?Q?GKqKhuaZs7yXlRvWUz3TTMYCMBrLPP6aUrVGj7X/W8DR6o15ubM/wa9mcO/Z?=
 =?us-ascii?Q?4ZXQlOjNN+VF+d4KWORAC5Z2klhjl2kqI+/grLo1rsVBY0HUCoZ3xxSB1yio?=
 =?us-ascii?Q?BsEh4z7t0sbYMIX1/KWGVHwmNnZ7YOgcLXsvTe4ZOMv74ckusXobDnziaRL0?=
 =?us-ascii?Q?DFzfHR8WUU7PheZ2khU4okuu+iBiiIO03oPI1F6XxKQA3LMi2hT8sAL7g+v9?=
 =?us-ascii?Q?guN81hF6EZAKBTi8wXI/B6zncLwsCYVBGeLFAsSpYPrIwS7TREbqR/6a7zmZ?=
 =?us-ascii?Q?8MOi6tFcm5ZexnvpFjC/7Tn0SmUxcK/UQStXltqrz0HtfEfuUESJArj5bCOs?=
 =?us-ascii?Q?tPdj3OmpFozcBQ1F8CuwNqRE4K9Lcm914bUz+DYAUUlhXYwc7EKRjTd/UoGK?=
 =?us-ascii?Q?sjbBAwjTviGHMENVs7yOurg5Pla5VgwkZ6qCBkVzZNN6tlkEw7MiO5OCsWCj?=
 =?us-ascii?Q?DkWhlMIsUxXbqhpLiE4OwQujHPcO1Qx74rJ1bc4uXxyWy1SpE8sO9GjRJPyK?=
 =?us-ascii?Q?kOxT1w7g8OdxuHl7MJREduQhzC85I7PtiwN+0LEaaSjuGfjJSRVjQkIRvXe4?=
 =?us-ascii?Q?oYhAiPs4OysXOuMxFX60/qiaskbrfNOkdbpw/nRgeUOy7XFdzXAC98+W/l7f?=
 =?us-ascii?Q?OX5AFV15AQtY3rIKOh0PG44gDWDOacuAS+T8MWlIK7c9qrlpXThwX3fJO/x6?=
 =?us-ascii?Q?tNKIJ41nNSh0kWx588Qywi4Ew7/V4LecjP8aVUdvrQKYVUWJuKJrWVj2BuoD?=
 =?us-ascii?Q?HUveBfVeKZKhHrKnz7Z/0IK4oigAATNLOuDn2YC2goNWXlGQI+CesOduem+h?=
 =?us-ascii?Q?DdjNa19FkiYJdzB4AaBlOApiOK1w44hb6QlhGdEoU/8pNFXuzSuTUfjO/lYS?=
 =?us-ascii?Q?Vn3aK4rJmRN8hj6S/rPmsIZAGsG3p9sm2CB3VGgPpLviM6Nx8a1sy+UwzJcy?=
 =?us-ascii?Q?4o7ksbySdyvi4uNcFJjj2/yDu9qKexkBGS92TWNog2R9d7uLQYx+GD1Zl615?=
 =?us-ascii?Q?N2fP3jV7W4Limebio8KrEZQjRb5TpsQyf7+maPV4iK6uyzj1Jq7wVK3IsEt6?=
 =?us-ascii?Q?CQHFb72SxutmyuF2YCCQesvMumWZIrI5ptuTBrYhPkMk91uBmMjpC/SOtweu?=
 =?us-ascii?Q?XZGc502eBeK3Hzp+U1JKr+S6i1lvkfRpgVjNBJE1vlNSwiyPCn4E/z8Leimy?=
 =?us-ascii?Q?JQcPcc82bAKOCYf+xqdrRjqvMc8ZSde4srvKoOyXvzCJA5jR01xynqiQh1FB?=
 =?us-ascii?Q?l4H9FvtvUHRFN8ngQZKMEKH93KPej1p/sbwdqSTmlA60SBXDFnYip8kytyWi?=
 =?us-ascii?Q?yvxPy5az9+Q=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?u8r49iddASqr72rshGmDyHr3u9J8RzAMoUojJF+jvnCGjyo01W2h0FKyDKwE?=
 =?us-ascii?Q?NQV4kohFWpga/ki4RkHzmNJcLuGvvP3cUKB2i0hbcwTfxg7HSsL3lhDIrWAX?=
 =?us-ascii?Q?D0ZlP2fgTAk8o5chY2FWHQaFH1G0Kleosmnq1H2UnPrvywyw6F3GASslXiD/?=
 =?us-ascii?Q?c3rBXvknkEcEMinS1PWIac26psPa3URkBijSCcasr0IfKmz3rA8wmFJxQzB9?=
 =?us-ascii?Q?uKGyZFdj/m/eyrOTNzBwkK6d81SYwS72OBQ/pazV0EpGk91rL+MOBgwr++oq?=
 =?us-ascii?Q?SyL2+O2QP9gaZjZciFAmdbB5DwBQRgG8qcqWihmqkrpNltn/rGrzWZrG/ts+?=
 =?us-ascii?Q?JKPR0VjRWiTIB9xBcIlQ7fthtB2pb7vfYzSWO0j34BLzt3gvLyFFLpuxj9qa?=
 =?us-ascii?Q?xyYyObs5JQx6E92twBU3T5aZk5FR28hLb2lw202GYOdgt/Y4GUMEwYcN1nF/?=
 =?us-ascii?Q?0t7PaK9GoENTFRnJsYR9V9kFOz/ICrt4b1N005NRxK7DfN/cPZW+5Av8N4k6?=
 =?us-ascii?Q?XmmJ0/Brj4gpfe9I+IVcSJmshulAxMw3OiBOA8P6nutVLlapjCdQdjH9N69D?=
 =?us-ascii?Q?Q0EIyA91gzlZsgXccZ2M53wq726Yu6r3908ViRZNwx1AG4Pnm2ZbK1nnZhti?=
 =?us-ascii?Q?UEgwi0YY78yYuufecOQDxTmAjvqi+DILmF+dY5Upw0ZXGmejjFChtRY3ZhSb?=
 =?us-ascii?Q?7L5eogbA86ljdiiMMGci1jov8PJK8quJB6BD2xkMOd9wBD6y1T3qsTpKGziW?=
 =?us-ascii?Q?X8LXCccfTM1dqHb76i4/OL76L5SjEae4/Gy+i25whXoQiSxGIwZOCb8NRkX7?=
 =?us-ascii?Q?7vzFhCUHJMSrNvyyuNwb6QWNbKxKe4D3Ckek1p+0Crmx7WdPM9uZwAPnEgzi?=
 =?us-ascii?Q?ebvII27Ei7b8AvC529I9lb6wg9K7S6JYAfuGz43aqzfgigl+hQvWKcxBchT3?=
 =?us-ascii?Q?iY5PZUqKJz37JkgMjQhZJkzmN9G0QldXB8vdTwK2wtZ/20FROBEZRusg2X+K?=
 =?us-ascii?Q?LS/a5f9bi6U0IkbN0F24oYoiakjgj3glYIz0QhBqBfY0e36gA2GCxSRhwTIG?=
 =?us-ascii?Q?NJl54uw33aShScStCNcYEcbJmQWkPuB3tv9Wg8v2bCqJTak2/NbWwXKyjjY4?=
 =?us-ascii?Q?X7yAkXCA5XMEN1KFoOm4KEjQQL6ul6lkaQiSE2sfvabTG38XFXGIQYAP2msj?=
 =?us-ascii?Q?kOu8NAaiepX+P1X9l8YcCb2Mr2fVDYxHji/x8dxYiFDCbdpWCsPSqX4Mr4LC?=
 =?us-ascii?Q?JroYGPh41JMm+Ie4VPKDy/1ishWisrgJeO0sBMHNa+RbbfL8XqI2/me6/i+T?=
 =?us-ascii?Q?cpGiRie474Y92vUqQXrbfJmOVhLmz0nCE9n1ROs5ep87BcqrFXq7Il1og9eW?=
 =?us-ascii?Q?6IpzvVndOpdvEIVtpDstltov3vYKE6ic4CCJXQ0o7NYuFhuMXC6De56J1dlf?=
 =?us-ascii?Q?M7AU9FgQK2mml3mY7gl4JSrnIUHB/UO8zLMHRbjzULlHUIblrzO87uxziVto?=
 =?us-ascii?Q?HJFidvkET+dXK3nf77taKC/NMpdGigTozB8FLxLl16JVef5dP6zFUaGvnaRG?=
 =?us-ascii?Q?UydLur4XDrXOOvaIDEJcR4c6H10NDNqhoBH+RTnd?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1eec5d5-bfc7-4253-f38d-08dda9bdd91e
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2025 14:31:41.4870
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kujMA9Mba9F/A51NpYBY03ekE9EkH/XBUwB5DaiDXMw+0A0m2LcmlOCNZ3NAOttl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9086

The NID is used to control which NUMA node memory for the page table is
allocated it from. It should be a permanent property of the page table
when it was allocated and not change during attach/detach of devices.

Reviewed-by: Wei Wang <wei.w.wang@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/intel/iommu.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 7119f4be1b1393..00079c3e49f078 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -1391,7 +1391,6 @@ void domain_detach_iommu(struct dmar_domain *domain, struct intel_iommu *iommu)
 	if (--info->refcnt == 0) {
 		ida_free(&iommu->domain_ida, info->did);
 		xa_erase(&domain->iommu_array, iommu->seq_id);
-		domain->nid = NUMA_NO_NODE;
 		kfree(info);
 	}
 }
-- 
2.43.0

