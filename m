Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010025.outbound.protection.outlook.com [40.93.198.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D6E32E7193
	for <patches@lists.linux.dev>; Tue,  7 Oct 2025 16:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.25
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759853960; cv=fail; b=Arpk9wqKrcLIi+L/GC7tyCpw2Ez8Gf+fe3+Yo602v+XjK/QnA5EtR9ersbFBXk0imRt0o31gLA3YAQTV567R3T5DuCl9Eu+wEkI2ghqecLMEjX6j5Sz20AkXon3rRAKav+Qx+/VXdr+cpWvrNBXlCjmlf8ce8yPHfjl9WgSCbuU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759853960; c=relaxed/simple;
	bh=2tTdTraKXSISAZPF1w7rvJa9OSxJBbNH7ve66lbjYyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=a4wy1U538CPDpmllXIICWxstyXwrT/ohi4JCIet+O4lkRnxxtAl9Tpmf0sUmEdbySQDa2QgUGscRLWoCXdUweHlaySu6YFPCSLskyGLFPO762L6NxCIl4sXmk0MWuAG4ejqlQxfjpYLWErZdY4XGO8zO2EZbVyN1pz/cj2iTDVk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=gnXaqGmB; arc=fail smtp.client-ip=40.93.198.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="gnXaqGmB"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pLniYqDXMd/B8XS7/3iTgDO1Ojby9hzWJmv0GfpYNuV3isQpgmHRpk1I9XRtc8yAke1JCnv9O6eqrJFtqZRm/SV7N0lxptXu4n0Q4691Xlvwd16i3qQgpr1EeZmXgFg4tjA1S/DTtf/5+7+yOgI+eMkCD+LiozhM4JRDIu7Y5vD0KNUKQEcbwBk6s5gees5ydpjMe1VUlV34Q20qlsJ7r8tFZn62J32/cOczViUeZVNLxHpRNLBlprk4RkYqYwTVjKm1ABucdQl5ViofvR8o2IprLSK/WtbVsRPmmIMNin+5dvgU8qOvRXdwfWAsOUAhmstiIb/hvZaaCvHwJE8yDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TSVcwDhl8li9E71/6h9niKFfht5AO/9eZ/MTLa7O/iQ=;
 b=JvGD7cB9PtW+c60oon1NV/NCAZhXOcz0ntOajpnNfl+flN+u0HfiOLgSo60Rn7rpjf2e3RsMjdYHyQI9RUCmWegK/EbFhC1dUhFXQRAuEArCOrjUQdXC/VqQkh3by54BKec+oGCVowbBr4gwbKxeqUthE+3/Hb/BrPxk2Y8aNGrNLlfTeTrTbzRzBK8Ik4H8t35gLhJ3m/2fEHdRUogsG/Clos1Woh59b2P6AMLkraDBegJvNlkSAEY9a71rncXVP0dDk2fkoyG6IGbhZuze9Gp+aS4JO4tLnAMbNmpWHcxnBu0g3TqS/t4sCyuoOz/4agfpr4a07EnckElfQvrIUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TSVcwDhl8li9E71/6h9niKFfht5AO/9eZ/MTLa7O/iQ=;
 b=gnXaqGmBgjEdAwPBOlP3bcDS8AIbgX5XjMscN/6wGYErG9US5kvREu8sIIpTdR+kRowyWCUhvt4gaBY6/DV6zBTI6zFb/jFzjkDZ1Dc5+koPkK26DJqKw1PKUPoGbfiiBUEObJsyP9g7lD6dM8HmFp6BEZ6Ir0cEqv39NbNAglaKrkjRj06S6hZ0TQ+9yljBfGeJaVFK45/g5DwwDwfN98A2Bz1qKrZJEzrfZaztiecWRVQFJW6O8ELrmCP1k9HrIuKGLahceMYxQYEou1jOqPVRxODYR2DNRZgJsvQAH4BqE/V7pcw62K3tPROa9oMwCoMCVx/wNRT4QNdFuEzHyg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB3613.namprd12.prod.outlook.com (2603:10b6:208:c1::17)
 by CH3PR12MB9026.namprd12.prod.outlook.com (2603:10b6:610:125::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Tue, 7 Oct
 2025 16:19:04 +0000
Received: from MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b]) by MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b%4]) with mapi id 15.20.9182.017; Tue, 7 Oct 2025
 16:19:04 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Jonathan Corbet <corbet@lwn.net>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Justin Stitt <justinstitt@google.com>,
	Kevin Tian <kevin.tian@intel.com>,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	llvm@lists.linux.dev,
	Bill Wendling <morbo@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>
Cc: Alexey Kardashevskiy <aik@amd.com>,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	James Gowans <jgowans@amazon.com>,
	Michael Roth <michael.roth@amd.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev
Subject: [PATCH v6 12/15] iommupt: Add the x86 64 bit page table format
Date: Tue,  7 Oct 2025 13:11:57 -0300
Message-ID: <12-v6-0fb54a1d9850+36b-iommu_pt_jgg@nvidia.com>
In-Reply-To: <0-v6-0fb54a1d9850+36b-iommu_pt_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0418.namprd13.prod.outlook.com
 (2603:10b6:208:2c2::33) To MN2PR12MB3613.namprd12.prod.outlook.com
 (2603:10b6:208:c1::17)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB3613:EE_|CH3PR12MB9026:EE_
X-MS-Office365-Filtering-Correlation-Id: c4d02d10-9ced-4c3e-31f2-08de05bd3b9b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?d/7RnWoWvlyKF5NHCHVkL7XLONUDlI0ssRQtZoh2otPxcGjE3iqjNAEFoqih?=
 =?us-ascii?Q?HrEVKedzoShtya0lq6191gDV9a2SR3enCMbtPDdn/Ne5kJuvvEFcaUBrsFee?=
 =?us-ascii?Q?JK/qQaUJfg1WCLR3TZmf8xdD35wc/DUezsUBVeXWUEKbmD2JggRDyMUXVwK4?=
 =?us-ascii?Q?6C/ci5j3SpRp78nTGRwcXr/+X98j2ZQ2/Obl078llHfkJb2I3LHmbulwPunU?=
 =?us-ascii?Q?7oeh6jr6cJWK21K5z/+GySkhljVUScgYkmJqIRfJSMCUIZ2tdKRJoSf8JScy?=
 =?us-ascii?Q?JoJZ36ldh4YI0ftWFR+dQv7N8Er9CWMoiEGPe38vUecWI+FL1cLdc12Z2D3x?=
 =?us-ascii?Q?kPPBDrI8EAbZXmgkuhB4CwxliL83m09SX/bH4qxW6z+vGJzfVAndhlbN66k6?=
 =?us-ascii?Q?2VC89lbGdeQH/Nca3gxALLcxHn3pSFmR1NlIpRNVPyJ3Wr3CsA8Luc5DOBiS?=
 =?us-ascii?Q?mhB/fjP7S/I+alv2XsM1qSIsoLOJGT8Nt5TTXoX3bKq65Z8tHytCPMG8+tAS?=
 =?us-ascii?Q?qVpgugXknbWzchRpFGLrpCEzBJZonry2zBlI2E5IZe10FxzvaTfWbIWGvGYV?=
 =?us-ascii?Q?anVQJYqtrkLA+7NHcb/p0qjhYVDTk7CQTRm8Ki1q+HT4hvr6VWyKoHf2IMgr?=
 =?us-ascii?Q?BCOiZIRZbifnm6jjvMdZuUY7g5aCIlAslml2CQneOPel9+oGuGTWH67QY6nL?=
 =?us-ascii?Q?MNf/jsjcgJOjEZB7eO2xQILJ1vYJEGg6mRv2VCp1J+uEDx4bEwrwGcc29BGl?=
 =?us-ascii?Q?ltl8Q91KHVEOAUfsjL3kMF0i5tqzhOmPl2vXFpDXZ2mLA7KcmL7iXa/Samst?=
 =?us-ascii?Q?F7x3oJRmf2jkOZIK9kU4/ShrofczCGGEjeMsG/E9p1sl2/LtF0p9dBQ22i2k?=
 =?us-ascii?Q?zcgH+wTdSxu6ee0YcWFlkKU6finACEkYzpesuSmsnNgUai/p9oQtQ/cwEZPS?=
 =?us-ascii?Q?+dk5I9bUHCZ+G+C+abR7JXF6vn1axFFa13cUTFf+H9lha0hpNI+pOJ2UA9WL?=
 =?us-ascii?Q?1scCVix2SpVWtjYThj3xXgZD6aRPpLfhtSCjfyMsvE1JFacLuKXXc7Isq6Bm?=
 =?us-ascii?Q?IZYTDVNntUVMX7aE7Vzhuuyb9W08yWAmHh6DVzppAHk3cGFbTz2j+3mRTczd?=
 =?us-ascii?Q?zYEE1qCn+JNqSDaWSrGyRsPxCHTXzVUbMr2kExn7rcZWW8vXZBVspaeA2T9+?=
 =?us-ascii?Q?FSuOSIMxIsnmikKicogPPdqqF2C9T6gr1JpVagywrBqg6m5wnDGdQ1HBpHWp?=
 =?us-ascii?Q?kDBHlH3aD/MZC4M+4WR/foUCv+CDRzJvOBpMjJweu+hUe34RNHpwVYQRwE6E?=
 =?us-ascii?Q?X2E5bCKcXOagrS2pX2GmdRmvVHLty8ebOqcVYf1tkErt+S8TwKS3jdgTj3LH?=
 =?us-ascii?Q?yb3DzqKxGy1ph5CNKeTlTARIMvWwtDIAejIy1gH/jTjcgnuOAJ1qTtlBK86u?=
 =?us-ascii?Q?KGDfMaApDSEi/C1sD8aNIJDKENXqrOCqI+s3QF9dEhMugwnr7YwRAV1/7SQX?=
 =?us-ascii?Q?gvcO8er1UyVRJKU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3613.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DCOUK3NvGFoDcQrn70xz7Faz8sJ+hkGHzV+lS8Wg18GEaXKkKarMOVYzVCvT?=
 =?us-ascii?Q?UFutQ2lUKdBP/wJtpvddOeEbyaq9G1pV6LpFTJ8f8tBNIiHCpNi+DRCrGodV?=
 =?us-ascii?Q?cm+VY3afmvfDVsCIxstDd/JPpWT2QKJzsDRHykeY/0LhwzsSHLN2xBBuxQNb?=
 =?us-ascii?Q?yW3DFdr+k2I4MavY+ndM1YH4karsdJL2Hs4d6xYBN5PN4rd2FZyNj5s5RAKH?=
 =?us-ascii?Q?WBLuQC5uu+Kf8gAPiILkLKj6gwmjNw1J89Q76bm6VrYLBSlUbNEqRrQ3iZIx?=
 =?us-ascii?Q?066EkNblg0JcKnabYzJZtx6I7Fy5DI/DuxbH6aMTQhmfeAemELVwY/V2/Z4E?=
 =?us-ascii?Q?zdo0YNF2iTbRm+4geqSGLveJf68sOprgoOzecNrs5FwOPY3vq3HP/D57Ek4W?=
 =?us-ascii?Q?NSK8u9rykDStfrFTzbJB8lK3oHnLwIQi3uvV6eIPle67lQRVkga18pXvEGmw?=
 =?us-ascii?Q?Jq7g2ztnICNYTToXvdV/Itwg9lMoh+QYtnH9+uDDuedMGRPlAzliFqBYt5qg?=
 =?us-ascii?Q?cZmKMCqDXCsmFIcEOC5XK9Ei/PBD+E8isY1HN+gXarGDb5Q3kfKii6YIGk51?=
 =?us-ascii?Q?rCbbU56t2dhswhuc6NN/Y18eElF8KPNIJqCyDYGMjR3f5iidw0RxiOb9e34y?=
 =?us-ascii?Q?xrTGxRH5yXbbnh+xvEod3Ujxop28zy+dt523Tl0qiv8sxZyxJt6Nid/b2MrJ?=
 =?us-ascii?Q?jDlArCn5Or+G7rXGtqVXpqzJGtkO6Wa0UQECkja1uKo41mnWIHHrszW0O7Mm?=
 =?us-ascii?Q?DDTZSF1qqn6unD5ANqdQpkhbLcGPu/xBxk56LmWsB19Z+3XeH4veRW+NnzE/?=
 =?us-ascii?Q?0JtMEQcIiRugJlcozkFJ4L+kR+miBtumziXg/qF8W9cI5wuOYZTTRPukYTtZ?=
 =?us-ascii?Q?f+Shzk/I2+9k0vh3oVRmu1DhJ+y1atRqzbxzS/lOZoPeFu6w2rU7TWcYkGS/?=
 =?us-ascii?Q?m3xmzvrtQzzCHBAWtRPhRSuHhbTr6UHXFgqNRTnJKwA1yyJrjQM/4328gs8W?=
 =?us-ascii?Q?jbW4VHv6MAnn+KHNJdDx1XSB03gKCAtQRJwcALGiV/2PAbBvfpbGzwassrQe?=
 =?us-ascii?Q?vZaB+324S6l/JskTJjttGvhXBnRu8hkp22PVGWCYk9ge8fCd6T7emaX0maTC?=
 =?us-ascii?Q?uOhI5yRRCs6n82XKh3enSWt/QekyEY9x4k6kTJMatmTGK4Bch4CRPz5YxWZH?=
 =?us-ascii?Q?Ns+siasp7NQ/daU/CHqpl7P5kaYiF1q9x0r+q2q2vAi0p3QVXosKmzbXLutS?=
 =?us-ascii?Q?zfEs5CcQUQFQaPuAFu8Kz6hB8ulxLu500YJ2Jg1+k6jEQPVmVKsxpgumhwCZ?=
 =?us-ascii?Q?+zHPp67Yw1nlOulJu6MqUd3JQd1uFqu+M/4XBcuBIuk8YUsYn8+QP65njTjS?=
 =?us-ascii?Q?U4KNuWMzqSbEBgoj+RpqBhcf0FFJe+AGuPkdr0Dtjys6B6ewbQvdK4w/A3xp?=
 =?us-ascii?Q?Hmx3009p/KJjN+JQcYO0WtZsF43HmKM02XYTGc96asrQfcRBPHvNESmh0JnY?=
 =?us-ascii?Q?5J52PqGHZfpY+kLFW2slLF9a8c4+7pNQtWH1l2tBdd3vI86cxisTWneXMdUb?=
 =?us-ascii?Q?gnvkRQaSg064UKhReIw=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4d02d10-9ced-4c3e-31f2-08de05bd3b9b
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3613.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2025 16:19:04.3867
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hf9lggsti4h8K0jLzSdW86YudF9yNFLPJHgM8Z+MeXW7Uy9hjcIHJ2tSWO+hpJ3Z
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9026

This is used by x86 CPUs and can be used in AMD/VT-D x86 IOMMUs. When a
x86 IOMMU is running SVA it is using this page table format.

This implementation follows the AMD v2 io-pgtable version.

There is nothing remarkable here, the format can have 4 or 5 levels and
limited support for different page sizes. No contiguous pages support.

x86 uses a sign extension mechanism where the top bits of the VA must
match the sign bit. The core code supports this through
PT_FEAT_SIGN_EXTEND which creates and upper and lower VA range. All the
new operations will work correctly in both spaces, however currently there
is no way to report the upper space to other layers. Future patches can
improve that.

In principle this can support 3 page tables levels matching the 32 bit PAE
table format, but no iommu driver needs this. The focus is on the modern
64 bit 4 and 5 level formats.

Comparing the performance of several operations to the existing version:

iommu_map()
   pgsz  ,avg new,old ns, min new,old ns  , min % (+ve is better)
     2^12,     71,61    ,      66,58      , -13.13
     2^21,     66,60    ,      61,55      , -10.10
     2^30,     59,56    ,      56,54      ,  -3.03
 256*2^12,    392,1360  ,     345,1289    ,  73.73
 256*2^21,    383,1159  ,     335,1145    ,  70.70
 256*2^30,    378,965   ,     331,892     ,  62.62

iommu_unmap()
   pgsz  ,avg new,old ns, min new,old ns  , min % (+ve is better)
     2^12,     77,71    ,      73,68      ,  -7.07
     2^21,     76,70    ,      70,66      ,  -6.06
     2^30,     69,66    ,      66,63      ,  -4.04
 256*2^12,    225,899   ,     210,870     ,  75.75
 256*2^21,    262,722   ,     248,710     ,  65.65
 256*2^30,    251,643   ,     244,634     ,  61.61

The small -ve values in the iommu_unmap() are due to the core code calling
iommu_pgsize() before invoking the domain op. This is unncessary with this
implementation. Future work optimizes this and gets to 2%, 4%, 3%.

Tested-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/generic_pt/.kunitconfig       |   1 +
 drivers/iommu/generic_pt/Kconfig            |  11 +
 drivers/iommu/generic_pt/fmt/Makefile       |   2 +
 drivers/iommu/generic_pt/fmt/defs_x86_64.h  |  21 ++
 drivers/iommu/generic_pt/fmt/iommu_x86_64.c |  11 +
 drivers/iommu/generic_pt/fmt/x86_64.h       | 251 ++++++++++++++++++++
 include/linux/generic_pt/common.h           |  13 +
 include/linux/generic_pt/iommu.h            |  11 +
 8 files changed, 321 insertions(+)
 create mode 100644 drivers/iommu/generic_pt/fmt/defs_x86_64.h
 create mode 100644 drivers/iommu/generic_pt/fmt/iommu_x86_64.c
 create mode 100644 drivers/iommu/generic_pt/fmt/x86_64.h

diff --git a/drivers/iommu/generic_pt/.kunitconfig b/drivers/iommu/generic_pt/.kunitconfig
index 936c327f0661cf..2016c5e5ac0fe9 100644
--- a/drivers/iommu/generic_pt/.kunitconfig
+++ b/drivers/iommu/generic_pt/.kunitconfig
@@ -3,6 +3,7 @@ CONFIG_GENERIC_PT=y
 CONFIG_DEBUG_GENERIC_PT=y
 CONFIG_IOMMU_PT=y
 CONFIG_IOMMU_PT_AMDV1=y
+CONFIG_IOMMU_PT_X86_64=y
 CONFIG_IOMMU_PT_KUNIT_TEST=y
 
 CONFIG_IOMMUFD=y
diff --git a/drivers/iommu/generic_pt/Kconfig b/drivers/iommu/generic_pt/Kconfig
index a117cc23a1c328..5a93df987e8728 100644
--- a/drivers/iommu/generic_pt/Kconfig
+++ b/drivers/iommu/generic_pt/Kconfig
@@ -41,10 +41,21 @@ config IOMMU_PT_AMDV1
 
 	  Selected automatically by an IOMMU driver that uses this format.
 
+config IOMMU_PT_X86_64
+	tristate "IOMMU page table for x86 64-bit, 4/5 levels"
+	depends on !GENERIC_ATOMIC64 # for cmpxchg64
+	help
+	  iommu_domain implementation for the x86 64-bit 4/5 level page table.
+	  It supports 4K/2M/1G page sizes and can decode a sign-extended
+	  portion of the 64-bit IOVA space.
+
+	  Selected automatically by an IOMMU driver that uses this format.
+
 config IOMMU_PT_KUNIT_TEST
 	tristate "IOMMU Page Table KUnit Test" if !KUNIT_ALL_TESTS
 	depends on KUNIT
 	depends on IOMMU_PT_AMDV1 || !IOMMU_PT_AMDV1
+	depends on IOMMU_PT_X86_64 || !IOMMU_PT_X86_64
 	default KUNIT_ALL_TESTS
 	help
 	  Enable kunit tests for GENERIC_PT and IOMMU_PT that covers all the
diff --git a/drivers/iommu/generic_pt/fmt/Makefile b/drivers/iommu/generic_pt/fmt/Makefile
index f0c22cf5f7bee6..5a3379107999f5 100644
--- a/drivers/iommu/generic_pt/fmt/Makefile
+++ b/drivers/iommu/generic_pt/fmt/Makefile
@@ -3,6 +3,8 @@
 iommu_pt_fmt-$(CONFIG_IOMMU_PT_AMDV1) += amdv1
 iommu_pt_fmt-$(CONFIG_IOMMUFD_TEST) += mock
 
+iommu_pt_fmt-$(CONFIG_IOMMU_PT_X86_64) += x86_64
+
 IOMMU_PT_KUNIT_TEST :=
 define create_format
 obj-$(2) += iommu_$(1).o
diff --git a/drivers/iommu/generic_pt/fmt/defs_x86_64.h b/drivers/iommu/generic_pt/fmt/defs_x86_64.h
new file mode 100644
index 00000000000000..6f589e1f55d35a
--- /dev/null
+++ b/drivers/iommu/generic_pt/fmt/defs_x86_64.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2024-2025, NVIDIA CORPORATION & AFFILIATES
+ *
+ */
+#ifndef __GENERIC_PT_FMT_DEFS_X86_64_H
+#define __GENERIC_PT_FMT_DEFS_X86_64_H
+
+#include <linux/generic_pt/common.h>
+#include <linux/types.h>
+
+typedef u64 pt_vaddr_t;
+typedef u64 pt_oaddr_t;
+
+struct x86_64_pt_write_attrs {
+	u64 descriptor_bits;
+	gfp_t gfp;
+};
+#define pt_write_attrs x86_64_pt_write_attrs
+
+#endif
diff --git a/drivers/iommu/generic_pt/fmt/iommu_x86_64.c b/drivers/iommu/generic_pt/fmt/iommu_x86_64.c
new file mode 100644
index 00000000000000..5c5960d871a32f
--- /dev/null
+++ b/drivers/iommu/generic_pt/fmt/iommu_x86_64.c
@@ -0,0 +1,11 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2024-2025, NVIDIA CORPORATION & AFFILIATES
+ */
+#define PT_FMT x86_64
+#define PT_SUPPORTED_FEATURES                                  \
+	(BIT(PT_FEAT_SIGN_EXTEND) | BIT(PT_FEAT_FLUSH_RANGE) | \
+	 BIT(PT_FEAT_FLUSH_RANGE_NO_GAPS) |                    \
+	 BIT(PT_FEAT_X86_64_AMD_ENCRYPT_TABLES))
+
+#include "iommu_template.h"
diff --git a/drivers/iommu/generic_pt/fmt/x86_64.h b/drivers/iommu/generic_pt/fmt/x86_64.h
new file mode 100644
index 00000000000000..a8d99c0553c7b4
--- /dev/null
+++ b/drivers/iommu/generic_pt/fmt/x86_64.h
@@ -0,0 +1,251 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2024-2025, NVIDIA CORPORATION & AFFILIATES
+ *
+ * x86 page table. Supports the 4 and 5 level variations.
+ *
+ * The 4 and 5 level version is described in:
+ *   Section "4.4 4-Level Paging and 5-Level Paging" of the Intel Software
+ *   Developer's Manual Volume 3
+ *
+ *   Section "9.7 First-Stage Paging Entries" of the "Intel Virtualization
+ *   Technology for Directed I/O Architecture Specification"
+ *
+ *   Section "2.2.6 I/O Page Tables for Guest Translations" of the "AMD I/O
+ *   Virtualization Technology (IOMMU) Specification"
+ *
+ * It is used by x86 CPUs, AMD and VT-D IOMMU HW.
+ *
+ * Note the 3 level format is very similar and almost implemented here. The
+ * reserved/ignored layout is different and there are functional bit
+ * differences.
+ *
+ * This format uses PT_FEAT_SIGN_EXTEND to have a upper/non-canonical/lower
+ * split. PT_FEAT_SIGN_EXTEND is optional as AMD IOMMU sometimes uses non-sign
+ * extended addressing with this page table format.
+ *
+ * The named levels in the spec map to the pts->level as:
+ *   Table/PTE - 0
+ *   Directory/PDE - 1
+ *   Directory Ptr/PDPTE - 2
+ *   PML4/PML4E - 3
+ *   PML5/PML5E - 4
+ */
+#ifndef __GENERIC_PT_FMT_X86_64_H
+#define __GENERIC_PT_FMT_X86_64_H
+
+#include "defs_x86_64.h"
+#include "../pt_defs.h"
+
+#include <linux/bitfield.h>
+#include <linux/container_of.h>
+#include <linux/log2.h>
+#include <linux/mem_encrypt.h>
+
+enum {
+	PT_MAX_OUTPUT_ADDRESS_LG2 = 52,
+	PT_MAX_VA_ADDRESS_LG2 = 57,
+	PT_ITEM_WORD_SIZE = sizeof(u64),
+	PT_MAX_TOP_LEVEL = 4,
+	PT_GRANULE_LG2SZ = 12,
+	PT_TABLEMEM_LG2SZ = 12,
+
+	/*
+	 * For AMD the GCR3 Base only has these bits. For VT-D FSPTPTR is 4k
+	 * aligned and is limited by the architected HAW
+	 */
+	PT_TOP_PHYS_MASK = GENMASK_ULL(51, 12),
+};
+
+/* Shared descriptor bits */
+enum {
+	X86_64_FMT_P = BIT(0),
+	X86_64_FMT_RW = BIT(1),
+	X86_64_FMT_U = BIT(2),
+	X86_64_FMT_A = BIT(5),
+	X86_64_FMT_D = BIT(6),
+	X86_64_FMT_OA = GENMASK_ULL(51, 12),
+	X86_64_FMT_XD = BIT_ULL(63),
+};
+
+/* PDPTE/PDE */
+enum {
+	X86_64_FMT_PS = BIT(7),
+};
+
+#define common_to_x86_64_pt(common_ptr) \
+	container_of_const(common_ptr, struct pt_x86_64, common)
+#define to_x86_64_pt(pts) common_to_x86_64_pt((pts)->range->common)
+
+static inline pt_oaddr_t x86_64_pt_table_pa(const struct pt_state *pts)
+{
+	return oalog2_mul(FIELD_GET(X86_64_FMT_OA, pts->entry),
+			  PT_TABLEMEM_LG2SZ);
+}
+#define pt_table_pa x86_64_pt_table_pa
+
+static inline pt_oaddr_t x86_64_pt_entry_oa(const struct pt_state *pts)
+{
+	return oalog2_mul(FIELD_GET(X86_64_FMT_OA, pts->entry),
+			  PT_GRANULE_LG2SZ);
+}
+#define pt_entry_oa x86_64_pt_entry_oa
+
+static inline bool x86_64_pt_can_have_leaf(const struct pt_state *pts)
+{
+	return pts->level <= 2;
+}
+#define pt_can_have_leaf x86_64_pt_can_have_leaf
+
+static inline unsigned int x86_64_pt_num_items_lg2(const struct pt_state *pts)
+{
+	return PT_TABLEMEM_LG2SZ - ilog2(sizeof(u64));
+}
+#define pt_num_items_lg2 x86_64_pt_num_items_lg2
+
+static inline enum pt_entry_type x86_64_pt_load_entry_raw(struct pt_state *pts)
+{
+	const u64 *tablep = pt_cur_table(pts, u64);
+	u64 entry;
+
+	pts->entry = entry = READ_ONCE(tablep[pts->index]);
+	if (!(entry & X86_64_FMT_P))
+		return PT_ENTRY_EMPTY;
+	if (pts->level == 0 ||
+	    (x86_64_pt_can_have_leaf(pts) && (entry & X86_64_FMT_PS)))
+		return PT_ENTRY_OA;
+	return PT_ENTRY_TABLE;
+}
+#define pt_load_entry_raw x86_64_pt_load_entry_raw
+
+static inline void
+x86_64_pt_install_leaf_entry(struct pt_state *pts, pt_oaddr_t oa,
+			     unsigned int oasz_lg2,
+			     const struct pt_write_attrs *attrs)
+{
+	u64 *tablep = pt_cur_table(pts, u64);
+	u64 entry;
+
+	if (!pt_check_install_leaf_args(pts, oa, oasz_lg2))
+		return;
+
+	entry = X86_64_FMT_P |
+		FIELD_PREP(X86_64_FMT_OA, log2_div(oa, PT_GRANULE_LG2SZ)) |
+		attrs->descriptor_bits;
+	if (pts->level != 0)
+		entry |= X86_64_FMT_PS;
+
+	WRITE_ONCE(tablep[pts->index], entry);
+	pts->entry = entry;
+}
+#define pt_install_leaf_entry x86_64_pt_install_leaf_entry
+
+static inline bool x86_64_pt_install_table(struct pt_state *pts,
+					   pt_oaddr_t table_pa,
+					   const struct pt_write_attrs *attrs)
+{
+	u64 entry;
+
+	entry = X86_64_FMT_P | X86_64_FMT_RW | X86_64_FMT_U | X86_64_FMT_A |
+		FIELD_PREP(X86_64_FMT_OA, log2_div(table_pa, PT_GRANULE_LG2SZ));
+	if (pts_feature(pts, PT_FEAT_X86_64_AMD_ENCRYPT_TABLES))
+		entry = __sme_set(entry);
+	return pt_table_install64(pts, entry);
+}
+#define pt_install_table x86_64_pt_install_table
+
+static inline void x86_64_pt_attr_from_entry(const struct pt_state *pts,
+					     struct pt_write_attrs *attrs)
+{
+	attrs->descriptor_bits = pts->entry &
+				 (X86_64_FMT_RW | X86_64_FMT_U | X86_64_FMT_A |
+				  X86_64_FMT_D | X86_64_FMT_XD);
+}
+#define pt_attr_from_entry x86_64_pt_attr_from_entry
+
+/* --- iommu */
+#include <linux/generic_pt/iommu.h>
+#include <linux/iommu.h>
+
+#define pt_iommu_table pt_iommu_x86_64
+
+/* The common struct is in the per-format common struct */
+static inline struct pt_common *common_from_iommu(struct pt_iommu *iommu_table)
+{
+	return &container_of(iommu_table, struct pt_iommu_table, iommu)
+			->x86_64_pt.common;
+}
+
+static inline struct pt_iommu *iommu_from_common(struct pt_common *common)
+{
+	return &container_of(common, struct pt_iommu_table, x86_64_pt.common)
+			->iommu;
+}
+
+static inline int x86_64_pt_iommu_set_prot(struct pt_common *common,
+					   struct pt_write_attrs *attrs,
+					   unsigned int iommu_prot)
+{
+	u64 pte;
+
+	pte = X86_64_FMT_U | X86_64_FMT_A | X86_64_FMT_D;
+	if (iommu_prot & IOMMU_WRITE)
+		pte |= X86_64_FMT_RW;
+
+	/*
+	 * Ideally we'd have an IOMMU_ENCRYPTED flag set by higher levels to
+	 * control this. For now if the tables use sme_set then so do the ptes.
+	 */
+	if (pt_feature(common, PT_FEAT_X86_64_AMD_ENCRYPT_TABLES))
+		pte = __sme_set(pte);
+
+	attrs->descriptor_bits = pte;
+	return 0;
+}
+#define pt_iommu_set_prot x86_64_pt_iommu_set_prot
+
+static inline int
+x86_64_pt_iommu_fmt_init(struct pt_iommu_x86_64 *iommu_table,
+			 const struct pt_iommu_x86_64_cfg *cfg)
+{
+	struct pt_x86_64 *table = &iommu_table->x86_64_pt;
+
+	if (cfg->common.hw_max_vasz_lg2 < 31 ||
+	    cfg->common.hw_max_vasz_lg2 > 57)
+		return -EINVAL;
+
+	/* Top of 2, 3, 4 */
+	pt_top_set_level(&table->common,
+			 (cfg->common.hw_max_vasz_lg2 - 31) / 9 + 2);
+
+	table->common.max_oasz_lg2 =
+		min(PT_MAX_OUTPUT_ADDRESS_LG2, cfg->common.hw_max_oasz_lg2);
+	return 0;
+}
+#define pt_iommu_fmt_init x86_64_pt_iommu_fmt_init
+
+static inline void
+x86_64_pt_iommu_fmt_hw_info(struct pt_iommu_x86_64 *table,
+			    const struct pt_range *top_range,
+			    struct pt_iommu_x86_64_hw_info *info)
+{
+	info->gcr3_pt = virt_to_phys(top_range->top_table);
+	PT_WARN_ON(info->gcr3_pt & ~PT_TOP_PHYS_MASK);
+	info->levels = top_range->top_level + 1;
+}
+#define pt_iommu_fmt_hw_info x86_64_pt_iommu_fmt_hw_info
+
+#if defined(GENERIC_PT_KUNIT)
+static const struct pt_iommu_x86_64_cfg x86_64_kunit_fmt_cfgs[] = {
+	[0] = { .common.features = BIT(PT_FEAT_SIGN_EXTEND),
+		.common.hw_max_vasz_lg2 = 48 },
+	[1] = { .common.features = BIT(PT_FEAT_SIGN_EXTEND),
+		.common.hw_max_vasz_lg2 = 57 },
+	/* AMD IOMMU PASID 0 formats with no SIGN_EXTEND */
+	[2] = { .common.hw_max_vasz_lg2 = 47 },
+	[3] = { .common.hw_max_vasz_lg2 = 56 },
+};
+#define kunit_fmt_cfgs x86_64_kunit_fmt_cfgs
+enum { KUNIT_FMT_FEATURES =  BIT(PT_FEAT_SIGN_EXTEND)};
+#endif
+#endif
diff --git a/include/linux/generic_pt/common.h b/include/linux/generic_pt/common.h
index 21e33489cbf20d..96f8a6a7d60e10 100644
--- a/include/linux/generic_pt/common.h
+++ b/include/linux/generic_pt/common.h
@@ -151,4 +151,17 @@ enum {
 	PT_FEAT_AMDV1_FORCE_COHERENCE,
 };
 
+struct pt_x86_64 {
+	struct pt_common common;
+};
+
+enum {
+	/*
+	 * The memory backing the tables is encrypted. Use __sme_set() to adjust
+	 * the page table pointers in the tree. This only works with
+	 * CONFIG_AMD_MEM_ENCRYPT.
+	 */
+	PT_FEAT_X86_64_AMD_ENCRYPT_TABLES = PT_FEAT_FMT_START,
+};
+
 #endif
diff --git a/include/linux/generic_pt/iommu.h b/include/linux/generic_pt/iommu.h
index fc38d788f3b2a7..9dfe7a22e76319 100644
--- a/include/linux/generic_pt/iommu.h
+++ b/include/linux/generic_pt/iommu.h
@@ -254,6 +254,17 @@ IOMMU_FORMAT(amdv1, amdpt);
 struct pt_iommu_amdv1_mock_hw_info;
 IOMMU_PROTOTYPES(amdv1_mock);
 
+struct pt_iommu_x86_64_cfg {
+	struct pt_iommu_cfg common;
+};
+
+struct pt_iommu_x86_64_hw_info {
+	u64 gcr3_pt;
+	u8 levels;
+};
+
+IOMMU_FORMAT(x86_64, x86_64_pt);
+
 #undef IOMMU_PROTOTYPES
 #undef IOMMU_FORMAT
 #endif
-- 
2.43.0

