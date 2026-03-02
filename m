Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012025.outbound.protection.outlook.com [52.101.53.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0205131E820;
	Mon,  2 Mar 2026 22:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.25
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772490187; cv=fail; b=K7JEHBM9m07YLlNfk3oUb9CLhJnxKDXUP7g5cGCMPuI2n29EQIoMbOtNYUhbvI1Y6qBg0+2luE+08PLR82xt4UFOdjerRnP+Bw8k2LG9hFBsPtTKmqNd6I54600Kq8WZcsY81fGHh/yXBUb+sEMLxZ3WG3pRtMVC33QQjoT11FM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772490187; c=relaxed/simple;
	bh=lPJRzlnlYOdZxAnt2k14NtMIs7COedYNLN/yNQNYZso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PMtqPsluphmefTsVoHttScjDzCopHGzFkM6HQnyD9ydauLuRrpm/QT+cKzIfJPLXIOOCSFYhW9ZEPMdrBDL464uQs9t/UamBd0Es8KqtyNLQpoCeMq34PbiAanOnwCAmxAvLcbzWAw6Pur121/UEmGpbrlRGT2Cjmw/cBtEdbv8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=i1AHVjce; arc=fail smtp.client-ip=52.101.53.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="i1AHVjce"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ELi7VR4o0ne4bqlLxapqLfLtc9JOjbHyMKYou7eF2Qsu/Z11JnHJ8A+IruiOBr5OkH39Fdxdi5qYh+Okxvkssg0y5DebkqBSOYDubcFN4mFEU2AZnSc+3VfN1jO1o66P9RMyigeKzl8+3G1pQ8GKr+vzXTsieWmYKGIbQpgblKZAcVIumda0QXRiIM0GoKX23glyEvfrzon+0ufwydeJHLcK7tDGrUPAYOsAX/nnR3BPemG962/oEZ3n4aIWrfonzDs7HmK5WCzymzyceXArqBfCglXckAX2SBXTc3EogIo6ef5l5aEsWDsWZAQYAjH8I9+uSNVbFg5R6JAlh/w4OA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qe8hjKY1BvWFwKpQLmno931eVW4ECnDSHoqlzOaeGqY=;
 b=ZeF2d1gN/tzNB8Zr594NtHOkO74q22hvEDoewhMTDvd4U0UPRh2Q0UyFS6v+Dh3sfqCVJq9fGVje8YnyvVZARpiKUovl5aDSoaA+fbcOo7RZ2UO02UYFXmbc5Pc8Xexgiy3293ggnpW2tlSYpPjuedJQxllZqk2vp1Fbzz5SHZUEOpaIATCFZXgKA1HyCiBnSAF8DiuUAQbEQpqmq1Zc+UVSqEeUpZ1MaRMnUplkOnfoq2ZN+DDc9ediLXHiqjdXWTCLpQe031hV799pACdXqsZB3587gOGEy8gAPKhX78tC+Yg52+yuey55klFjnOKfkA+hcqC4h14Fy92xng/3Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qe8hjKY1BvWFwKpQLmno931eVW4ECnDSHoqlzOaeGqY=;
 b=i1AHVjceUJFUgoGz5HllGyPOB1+6OiWjGh2XORThRq0f/dUaR6bm9p5tCP1/NVZA+KeERO+OJgXtDIKr/1rDaBUuOpSyR+N+ZCVsHMeYwm8RdLWu9svjCp2zrinVpe0wLHhjH61z5t7PRp24XXYinywe4P4+/mwRqQX3R4ezggx8w5pDAftZhLGxqdcHiRIxrcUxCXi4FE40YyoD2tAhZX97zoDHH++XSDcmUyeBX1xplsgRe8X2yFaUhbuSc/vHrqv+m2Y9CVJ4yRoaaw5NYjvtYhbtC0ZjzR7tItnHHdFtmnyfMsvx2LxMiUkn76qFcDFX4KHJeQnUnzdSrL4v+g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by BL3PR12MB6473.namprd12.prod.outlook.com (2603:10b6:208:3b9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.18; Mon, 2 Mar
 2026 22:22:59 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9654.014; Mon, 2 Mar 2026
 22:22:59 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	Samiullah Khawaja <skhawaja@google.com>,
	stable@vger.kernel.org
Subject: [PATCH rc 1/2] iommu: Do not call drivers for empty gathers
Date: Mon,  2 Mar 2026 18:22:52 -0400
Message-ID: <1-v1-13a02eb0e031+a5-iommu_gather_jgg@nvidia.com>
In-Reply-To: <0-v1-13a02eb0e031+a5-iommu_gather_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0174.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::29) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|BL3PR12MB6473:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c3de512-c53b-40d4-5b0a-08de78aa4019
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	PziPGC3hPQOEwh2b8+oQblhMKn1Z1LwACpM+8jUOYJCogrzi2mcRhIP2mopBANn7NnWA88VePv6DAOyWVj4JNuPia4+zmNQMqeXA1NQiYvJ+oad/AaSNWpeJRb5JRlbI4azXcJWqvPfF++6pV5NAVNjT/1kWt2ymPB9ftzBOu+yUW1iEP3MdGkjrFxix8qKm2O0TPGGrEh/aZePIgpVDXKxpwaBIRbsp/hRc5PY2d//CRtQCGS1NxIBCus79zeTgwqSkUwOwzFw0M7WLq41cnc58CcwrcTqMwRkgu1jPz4mp8+jBJC2/zuYwe1/3d8RsZ5Hi/2Sx5VwIs794rmxUBQQD898+w7BAJ+9yNPDdXOL67mZSDNCRGeRh52Pbg5ZJJYMr9ZWB+pI0M5YgC9ltyN5I2KcqaZ51xrTWtTI52pfMvpC+u4hgjcgJDyGmSJMSwqKi02GKev01TFJ3ss68iTsS1/uMdGbRHn0+i5AP8z+DMnYJsOB6+CFBYRT3AlmZbnR6uXfJt2Vzyd6Oslq6bvQGLNzeY/yYELSXzh6MxXULFYJZFUnpMct+h74OGKeJCaAKeSU64DUabKTCg1xT+lDlExFfMDO26yayPDkPQuD2avRqJh8+jfl3HMk7TvWt5g7G6SDltc7/+ZSDoDKg5B9the1aVKqR6KKi3ZP0zZId6+d5ZxG6Ff64dr1VD5D+nsOcmgv3Jiqwyvnk1wc3SUrourfr3KdSb0//3oOnnws=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9KxCR6h0NndX0ZcVEkl8wFmWlqw6u2NRNgo7Q+bmSMn7kpThIRvvsRpBjnQT?=
 =?us-ascii?Q?kyXlN9/3Dq2mGyYzpjEcdqDmMiX852ZJFIoRXKGJAb1vayEPiAEy/hy5T2wT?=
 =?us-ascii?Q?GNKj2cEMY+OR6zVvyoE/DVM+cdnar9KLX5cQkEL8ts70M/6SumtsQzbLPLxe?=
 =?us-ascii?Q?hM3c/8Nmyo9bakV5bvECaFxH2YOC1RoVL1ndHSBmDodAv4RqKY4M5FYvbPca?=
 =?us-ascii?Q?woKJdgcIF/sa5bbbvwnWeUZ/SVpwTtXXmcsoJAyKwy8+hpKJdcoH4RPIHa2k?=
 =?us-ascii?Q?gqYXK+1PBjhqkXq86dII7nXhYQeSem1FC3TMGyhuLUw6XmXRu/dXgn9TBO2E?=
 =?us-ascii?Q?ot5ebkMoXDuQdR/jA0ivA8d05qQVotiwIb6SKhCw9X+rjmyQohauwvZQCyCQ?=
 =?us-ascii?Q?Hq3GqFBiGhlg5qd2WQueZim1VWVbq1qvmCRkbV0sDutr7Treq0nAR5kss720?=
 =?us-ascii?Q?RRdt5FEewEqFMHzdugEhrAtlWwYxTkwQZ0hxoSPY7lb3LpSnd6Apq3IFhhLK?=
 =?us-ascii?Q?JXzKjWJqW19jOYMrhJPv0/fPFl1UpJJ3/BpFHffblWWsT0bc1wSwM/C9wnve?=
 =?us-ascii?Q?A2zgOeGhTBeFQzP+8MK0sZKMCNz3uxBzDbeaiU+vyY4d02/c3z676RMiZ+Xr?=
 =?us-ascii?Q?njvxjbAW/tbX0nb3pvAdcNw2cwr0P3PrThiHRg6FNy9Pngu4Hq0FMsq0PkiI?=
 =?us-ascii?Q?WSjJpMDIZxcaQcPqQmGWr3gI2y/FlyNhS6VuRztiuFXW/bG7v5e0PfCavLas?=
 =?us-ascii?Q?Q3VtcL/QkTjY3AWVEHSG1HGY6JXwVc7sDX5aHa/ZuGTachw5yIyP2mMpVueq?=
 =?us-ascii?Q?7YGJT31koubCKl4uZN8NQNRo0NZCtVokhmkDEJ2WPghvho6w6SwJHI3fzFOf?=
 =?us-ascii?Q?rJ77MqP0UMOtiYNEM94poGjceykvCawgnpeBOhspE7lB0UcFl9p7jfeC1RBh?=
 =?us-ascii?Q?cKssiEls0vQtZmhmzbK328D4MmwcsiFEzqO9dddWm3ThSb9/ghf5yzb7zQau?=
 =?us-ascii?Q?lmEH4nTZFQ3Kdb1sRFuEoVv+7i8YwqZLglvYtPasiUmkOtTQvwxmplYUse/z?=
 =?us-ascii?Q?kvwPAYUeydc9gQHwNQhpZwIYeGXMM/nhywkFg8iAsziud8piiR72ZmbMHY2h?=
 =?us-ascii?Q?JQCK/ZOLIBc3D4BTSj8JTOA7BVdcSMNPceIVkDYKWp5/V8LY/5OabageeGcl?=
 =?us-ascii?Q?MCG/+JnqdsEEPTP0Gv9ONFdeJR5YJh/sdxeMBp2+5/fPLlEf/Rn7B0wCx/bC?=
 =?us-ascii?Q?wdTTBnRUgFJWDV2oSUYJEMM/jZdjNd6jHUJoK5uA36D22ZZ6+fAybb2xqFzR?=
 =?us-ascii?Q?VDHqwyZpvD86AepfN1GtMeHZsMeFUTdJizsNR2oLgWFdIsA4M8ZnU7NxV7MX?=
 =?us-ascii?Q?aXm9Nxi93EeGYb8a2ROWfouCZuhkSnaCUPFckrp8IRj90jJirQUKywLbOZX6?=
 =?us-ascii?Q?DQSH0yDkNOtSdhapBEGj8nKCOvTr6yKGIXyl4lzKhTjFB/Ym5UuzVwfJuuOf?=
 =?us-ascii?Q?/O27Q9gNG+jQf3clWmXJ5GDO5dJ96i81SmOnTD3yQT+IjAiwXYDDkgAF5GTC?=
 =?us-ascii?Q?5hYzKlRuZ/0hfiQRA129tyABlIRs3aMXEbLHOpIZ6dypfK7LOQSPSdJzx1CC?=
 =?us-ascii?Q?ypCGHWVV9aCCHhoSe4mMGAfWSNPp36xjMN9Rvjq6UACyZGq/LgKTwsQK7iS6?=
 =?us-ascii?Q?Re/XUeuBYTlP5eX1hCS8oYTBbqBGe8Lp0byW5ttrx6IxLa/7klaXi0r+oFYz?=
 =?us-ascii?Q?WlheYyTJCQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c3de512-c53b-40d4-5b0a-08de78aa4019
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 22:22:55.2802
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S2MgJMRaGVslQ7W1xKqkjGEy3mVdJ+w3JeasPNCOREoieal3qo3b5OqCDn6zr5wG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6473

An empty gather is coded with start=U64_MAX, end=0 and several drivers go
on to convert that to a size with:

 end - start + 1

Which gives 2 for an empty gather. This then causes Weird Stuff to
happen (for example an UBSAN splat in VT-d) that is hopefully harmless,
but maybe not.

Prevent drivers from being called right in iommu_iotlb_sync().

Auditing shows that AMD, Intel, Mediatek and RSIC-V drivers all do things
on these empty gathers.

Further, there are several callers that can trigger empty gathers,
especially in unusual conditions. For example iommu_map_nosync() will call
a 0 size unmap on some error paths. Also in VFIO, iommupt and other
places.

Cc: stable@vger.kernel.org
Reported-by: Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>
Closes: https://lore.kernel.org/r/11145826.aFP6jjVeTY@jkrzyszt-mobl2.ger.corp.intel.com
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 include/linux/iommu.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 54b8b48c762e88..555597b54083cd 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -980,7 +980,8 @@ static inline void iommu_flush_iotlb_all(struct iommu_domain *domain)
 static inline void iommu_iotlb_sync(struct iommu_domain *domain,
 				  struct iommu_iotlb_gather *iotlb_gather)
 {
-	if (domain->ops->iotlb_sync)
+	if (domain->ops->iotlb_sync &&
+	    likely(iotlb_gather->start < iotlb_gather->end))
 		domain->ops->iotlb_sync(domain, iotlb_gather);
 
 	iommu_iotlb_gather_init(iotlb_gather);
-- 
2.43.0

