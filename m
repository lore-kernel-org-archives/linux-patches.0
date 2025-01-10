Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2080.outbound.protection.outlook.com [40.107.243.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA5AC211A13;
	Fri, 10 Jan 2025 16:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736526913; cv=fail; b=cwGxK3kgE3B5hc2Hr7u/XDXl4lYP902Xgn8ssxwEoKtoRqX1JEw3S4+PBSnzmoRStkZyhmCNhWX0tq456TuaagcsFVcXgA2iD4VG3fwQrWSlSotGnQ6tTMVHUi0fU9Xxe0v3tvwuSuTV763AVVY5QXt18Xu43Ru07zOYeWW8FOE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736526913; c=relaxed/simple;
	bh=xSeBbg/PfeY4h8aa+9cGui+vIdd+CyOxrCpwdZsJU5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HhbO5/5iFFMZqt4uSsx+ZQ+JL8k1TW4hobsKTdJra2LUeM/2LFaJmzVboxdGiURK0hUFHQIBvl6DDEUUvspVVWALcb7V2kXanJQQylb7W8MTcxHzNj1kKScjJFNznD0t0NG6TFCOci2G6hZoozuj+mGQV76LElhdxNSfvL2E1PU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Fu9rg0ls; arc=fail smtp.client-ip=40.107.243.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Fu9rg0ls"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TdoaizpJ5iHatM5PiQ5cu8HqRIxS3SxnFovhJCRV3KtiO58cbKL2uDNwo4VwTEGI7m5sffy25KiNkdKaUKBsMhz2xmAhlaRPkvHmMOb0gy2hMjEezAX86uVuRsL0YW6eo/ZtCjSkLIK++WGVPvQptpdHwG8s2LsPwD4Rt6+LFMwsOFkiFEOm5/ctfelnZF/ykI9buf0PnlZF6j0EhCfmtoCB/ECNVAvfsMQNkThx3CoEMd2yRi8fRja7VlVMoM+mfRrck8kjxnS1/pEwqm3DFa0MY88wPmYY1OKRgn35czlTMLld/JblRK2imRNFDmYqLQdooGxpeUb8ccL3cPC7jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6P7B/St9S4AeyTS0cIp0DHUBNc+akO1K2chxn/lN7Zo=;
 b=rs+UBIGxTNQNDE+4QG46p/QdOoSR5vo4RahKx3gYkw+hc35XF0AXVqA82hHu7Ck03zWSp5h72y7SUdgw0T35Kac+8wNSjlJNbsrMaXqvzgdnKhgOX+23GIKykVK3zZwTznCW+yJIH1ZmI0gwwJNc78SkOrOEgv7XZHNszDvDaUIbz5EX2G/eUUOmdXYe4qio7xcsdHrstQNmCkvPPv6n1zsZp7ydDqSZyqu/ctRATfNbGz7vxlofAQB2dKS4UAfyCORSiVPxMpSfIY182uZ7kCa+OXsBiGXLcBRHRgVi9PXHYe064fgP4efvsJv56Ir5P8ZUYFHnafIjBrI/8+Hamg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6P7B/St9S4AeyTS0cIp0DHUBNc+akO1K2chxn/lN7Zo=;
 b=Fu9rg0lsiCf5FlK+TYEOXlKWsaj1m06v+p3hYsK5IlWhCFBiuqZtPTpkr2xh2xx3rFurZ8350GG3AiA0lhZeZKYJ7IiaF68lUAH20KMT6Bw3yEP5ZQ5hVkDAv1VZV5XwdT1w/B7tSxZls0edPwYIg9I+VKCmokwV8nNNvGwz2vHQrCACaresLlEDkE9+diJv5uU2rMflxU4CPzeG4CcdkiMXJFsW2qUAkgEf0Lq+MtHA08D1O7nZmNJpEPk1mDnMkVp8L6Ug9oGPE9yXH/YaUCAkrQhQci95pZCrc6yeoIcV/L2o4GS+SpD83wskCZcfN6cqTtE1f96pNdgJJ0R6bw==
Received: from DS7PR12MB6120.namprd12.prod.outlook.com (2603:10b6:8:98::5) by
 DM4PR12MB7599.namprd12.prod.outlook.com (2603:10b6:8:109::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8335.13; Fri, 10 Jan 2025 16:35:09 +0000
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DS7PR12MB6120.namprd12.prod.outlook.com (2603:10b6:8:98::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8314.16; Fri, 10 Jan 2025 16:35:09 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8314.015; Fri, 10 Jan 2025
 16:35:09 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Joerg Roedel <jroedel@suse.de>,
	Kevin Tian <kevin.tian@intel.com>,
	patches@lists.linux.dev,
	Vasant Hegde <vasant.hegde@amd.com>
Subject: [PATCH v2 4/7] iommu/amd: Remove type argument from do_iommu_domain_alloc() and related
Date: Fri, 10 Jan 2025 12:35:02 -0400
Message-ID: <4-v2-9776c53c2966+1c7-amd_paging_flags_jgg@nvidia.com>
In-Reply-To: <0-v2-9776c53c2966+1c7-amd_paging_flags_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0343.namprd03.prod.outlook.com
 (2603:10b6:408:f6::18) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic:
	CH3PR12MB8659:EE_|DS7PR12MB6120:EE_|DM4PR12MB7599:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b00f315-3953-48f7-23a7-08dd3194be3f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cerA3b66B+T2RR9GIltDwWtdh4UXv1fGoc4OUjxGRKU56doGvpi/+Ei2+ulF?=
 =?us-ascii?Q?U+bMwBHJ6L0aUhwwzA4xj3VipVU7TQGeE6mai51ZUihAvmoQg+VCavMjF2qs?=
 =?us-ascii?Q?h71/zqU4MYTT3dVDY3NSIv8wYUHMycGe3703R7XHQvawE077U5x/3iIJHl6e?=
 =?us-ascii?Q?HG6czYnjdLcAVBGENyO5sGbi30B2EeyCaPN2aVWzRqD0YLhsi4uBXzImBraT?=
 =?us-ascii?Q?3bPxSzOOh0akUNcMNVMOG0SGXb9tlH/wRo0QOGxreb8NFSILP98wGkhX0Taz?=
 =?us-ascii?Q?Xgk3qLeuHlPFX7cAe/QZ4Fd9t6UEl4m/oNseNdkvtMSNFQWGeczQBaxVKg4D?=
 =?us-ascii?Q?VV/rFhRDhhbdTB+iW0T9FeaRLZ+KR61BOqB5O2HiqO9A1ho5Cx3f0uhdzmGB?=
 =?us-ascii?Q?nOTqIDS6kA0Q33ZenhwLHZ7oUzClyOOpRSb3ItiRu7MB277CUTvBJ6YRytUs?=
 =?us-ascii?Q?o/1jNL+ihL+vVnY7SwFCn9AcM1IuIDxfyCa+J/Rdi384R9Lz8qKsqjQfgp5O?=
 =?us-ascii?Q?vvFYbLP7ksyGzTc+GKCLff4RhOGb5n+ZG354qr36lhdLMH+JWbMQ9I9KSuoN?=
 =?us-ascii?Q?VKmVoX/ibFvaBcAMF1jdw2/nsQboig4rO07PsCMUligMf8Yq8pVH50IWcBwS?=
 =?us-ascii?Q?KOhjgC2Ss4UKrISdpCFx6op3+9/OSpkyhPH+FA5xikTZnqTIOXsaro6L9KBx?=
 =?us-ascii?Q?d2Y5arKOnzLuJbwQhnYUTtvDedw/wzEo2cu0LcjnBtwIEG+qDtB+cHv5ZHKZ?=
 =?us-ascii?Q?wuf8QuR7xPFeerFPGrIqVsNPS5ASRKkd/Ull+9023/0qz+Vp0Df4S2rPd5Ty?=
 =?us-ascii?Q?eR+1/9mHuf/43ZOnlyS0xrtnZYjZzeM5VdPOgCs8cc6/qwU8NruO8k4vMSBa?=
 =?us-ascii?Q?2JD9hkJ/505MworQOf9WX3m+J+Ag4LLtRuXP7HQVIrl5/Arr0bR4wKURM6oG?=
 =?us-ascii?Q?M35sqpPbGuELiIt5Rryg01y0Ar4sX40wrKGTc4qlAEgLu9TD9Tbsb5bfPzvi?=
 =?us-ascii?Q?sx7Nw7cY9AjhyWLNnff2o3SjTm9AEiRpH6XgI0tuX64a24dnjacqYI9t+r5L?=
 =?us-ascii?Q?SzI7kh5+9/f+T6By60ZTL2fXfJRWDveDUFHfZCmycKbdXfo0YR+lCZPRG0FC?=
 =?us-ascii?Q?M+PQS037EpEGVREzHBcpY78e63c4XDaJ1YycxxCgsPVrcdzLPncMD/onqw8Q?=
 =?us-ascii?Q?bhaFnrfOW3qpRyDs9lfR8W49EslTmqjCPB2DszvfSPNOKd+mZR6L9qX88qrW?=
 =?us-ascii?Q?wuju8Cwe1f+nevZ/gYGhrBHmCdTCNtH76W8hz7+aEdjuZ4UCC7ti44g2qtgO?=
 =?us-ascii?Q?HYcGTNIT0EgvpkSxsDv1F8c4Z+kdY6rljc4Mv+kGMsNrHfoEM+3JvJZF1zC1?=
 =?us-ascii?Q?mElm9qhtC6TG38XOJYyK+yuvmZua?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6120.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WfGE1oRVsi5yjcggZJRpRQPts7QI0VPC7exiryaT2zQzkdmxzy0psGW9R3g5?=
 =?us-ascii?Q?NJXuuXihBsclWhE3Q+fshfOrA8UUKIe2oeK3mkrhWGhkehvwYz1u4Rcw8HKp?=
 =?us-ascii?Q?YVbG78Ujcf6fj6US2pr2JbN4wj8v7JCPtHwqHeI3PLixkManOG8yBvQ5DpLl?=
 =?us-ascii?Q?Lf9HRuO/uaZVygs3HeuEwdxa/MjyOqhcRGJfzOfBFMhn4UjXKTS0NYD8BO5b?=
 =?us-ascii?Q?h/BIl7v3GNLz+hguTyEumSTD9MjwXQwuGQ/cefGHAR7Uv8DhGqQWDHIEwAjK?=
 =?us-ascii?Q?2hqA0L1xJTNf9xlkBMkF48ftBxm0aiT4kh/25p0/MfQvK8/eCd6rB8Up27hU?=
 =?us-ascii?Q?vOBSyeCMbP02M0d5o+EzpcFh1GRoSCQYHHT/SunzbQtxffYS+qXEawYcgvGg?=
 =?us-ascii?Q?5WenTMxKPGy5Nz3nFXoMo8tp9h///Otp8keiELIV/v8TorJG4IueVrg/NsQy?=
 =?us-ascii?Q?j5Xr0F4ur5R3dUvFM7NykFess5jZ6mUYdAmdRp3b5VAinlEcObVbpksDXsB/?=
 =?us-ascii?Q?AFn/HCyOUB2jPa8H7KpnqwsVZe6OKBb4A4Xai6hn8CX9w5GDEeZvmQmyP+OR?=
 =?us-ascii?Q?WqVhHvV/Bpe6/KGDyW9OSSxcDQcJSbu/qspUqjTx/E52yBaWzU6LMJWI7O8F?=
 =?us-ascii?Q?RKejDrfFKSxHe8RCRdr49MibWaZqwIPqdBvBU0D4bzut6AYh9Uf+QkHBpp7v?=
 =?us-ascii?Q?L5xBENyc8KxxYBRg3OYPpJtN8tg1AbSTcLXQp/mWKOa08vLnu4E7kAXjvms2?=
 =?us-ascii?Q?8XorU+E3bs7mb7qTFPIIgPxUmk8Mbhy+SK/reUESjl9/ElEoPgZ7WGOzsbLq?=
 =?us-ascii?Q?fKncf9AwxwHoWq3tLQBmY0DqlZlkxYPc6I1paKuRLCREpAdQOvZV2I2TLVVV?=
 =?us-ascii?Q?Hc5cLW2aP/2QN3mrmNF4XhCVpT9uK9B5bc5xWxnx5XlOLI8JqaUhdQSX+Sip?=
 =?us-ascii?Q?w/bDuYv1YVfag8GPwMcvpTBHy+eTVUocQaN2erGFduyZb05cVHcyI37LXz/I?=
 =?us-ascii?Q?jYAi/UqMlhY4JF34J1+lkknJplmNmLJTebIKmWx9QHDwpWGL+fz4pyz+lzy8?=
 =?us-ascii?Q?EL9LW+bA5lSJep5FghnjYLD48KaIUy7vGrMEutoH0e5QUqtzT8419Y2CFEdp?=
 =?us-ascii?Q?4QXXt3BIHccMfac4l3FonbdHeJWjTDeIMQw7V+X2RvluSEEdPf3U6s2VeIBk?=
 =?us-ascii?Q?07lIxp6fmlRrLDP/7PVqvH4tNiVXgvt3p/mIaW3hnNTKNdsMcYQGxqMFs55e?=
 =?us-ascii?Q?WwABhx49oJs8gh4vQHLD1v7T55rgP+h6v7ODvpKJrwS+U3NXK8int769EBZV?=
 =?us-ascii?Q?e7VJFhlgAKDxCr9fvzmU4VNwW5SmeTtd9OxAi1tBtVsp11+mdL5ikNhQwHf1?=
 =?us-ascii?Q?Wu597TIKKl0BffbE9WIG3Bqx3SDO9ykQyl9FCONGJlU2ilMcZOnIoT0uXX0G?=
 =?us-ascii?Q?sOT8QEirTysv7l/97CBbAADFk4zN0yQJYwDcwX5L02E+RT3V+unwqFaBz50s?=
 =?us-ascii?Q?o/FOoksfEabquMkYgIFeD/gF09xgffDouNu20inN6eYj7+96i/Wg0wsqn4M/?=
 =?us-ascii?Q?LLZ4js3ECvrxssDyPyq2j1FLTYmjPKMwTEBGUIub?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b00f315-3953-48f7-23a7-08dd3194be3f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2025 16:35:07.4890
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HLaJicDf8pKrpRhM6Tow12bASolOnW6beP8+kuCa5+LuZ4gBFhbx/eT/6P5oaiTa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7599

do_iommu_domain_alloc() is only called from
amd_iommu_domain_alloc_paging_flags() so type is always
IOMMU_DOMAIN_UNMANAGED. Remove type and all the dead conditionals checking
it.

IOMMU_DOMAIN_IDENTITY checks are similarly obsolete as the conversion to
the global static identity domain removed those call paths.

The caller of protection_domain_alloc() should set the type, fix the miss
in the SVA code.

Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/amd_iommu.h |  2 +-
 drivers/iommu/amd/iommu.c     | 35 ++++++++++-------------------------
 drivers/iommu/amd/pasid.c     |  3 ++-
 3 files changed, 13 insertions(+), 27 deletions(-)

diff --git a/drivers/iommu/amd/amd_iommu.h b/drivers/iommu/amd/amd_iommu.h
index cdbfa5f096dd81..d6f4cf8235992d 100644
--- a/drivers/iommu/amd/amd_iommu.h
+++ b/drivers/iommu/amd/amd_iommu.h
@@ -46,7 +46,7 @@ extern unsigned long amd_iommu_pgsize_bitmap;
 
 /* Protection domain ops */
 void amd_iommu_init_identity_domain(void);
-struct protection_domain *protection_domain_alloc(unsigned int type, int nid);
+struct protection_domain *protection_domain_alloc(int nid);
 void protection_domain_free(struct protection_domain *domain);
 struct iommu_domain *amd_iommu_domain_alloc_sva(struct device *dev,
 						struct mm_struct *mm);
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index a439dc9aefec54..e2d2cab4f8324b 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2455,7 +2455,7 @@ static void protection_domain_init(struct protection_domain *domain, int nid)
 	domain->iop.pgtbl.cfg.amd.nid = nid;
 }
 
-struct protection_domain *protection_domain_alloc(unsigned int type, int nid)
+struct protection_domain *protection_domain_alloc(int nid)
 {
 	struct protection_domain *domain;
 	int domid;
@@ -2476,15 +2476,10 @@ struct protection_domain *protection_domain_alloc(unsigned int type, int nid)
 	return domain;
 }
 
-static int pdom_setup_pgtable(struct protection_domain *domain,
-			      unsigned int type, int pgtable)
+static int pdom_setup_pgtable(struct protection_domain *domain, int pgtable)
 {
 	struct io_pgtable_ops *pgtbl_ops;
 
-	/* No need to allocate io pgtable ops in passthrough mode */
-	if (!(type & __IOMMU_DOMAIN_PAGING))
-		return 0;
-
 	switch (pgtable) {
 	case AMD_IOMMU_V1:
 		domain->pd_mode = PD_MODE_V1;
@@ -2518,27 +2513,19 @@ static bool amd_iommu_hd_support(struct amd_iommu *iommu)
 	return iommu && (iommu->features & FEATURE_HDSUP);
 }
 
-static struct iommu_domain *do_iommu_domain_alloc(unsigned int type,
-						  struct device *dev,
-						  u32 flags, int pgtable)
+static struct iommu_domain *do_iommu_domain_alloc(struct device *dev, u32 flags,
+						  int pgtable)
 {
 	bool dirty_tracking = flags & IOMMU_HWPT_ALLOC_DIRTY_TRACKING;
 	struct amd_iommu *iommu = get_amd_iommu_from_dev(dev);
 	struct protection_domain *domain;
 	int ret;
 
-	/*
-	 * Since DTE[Mode]=0 is prohibited on SNP-enabled system,
-	 * default to use IOMMU_DOMAIN_DMA[_FQ].
-	 */
-	if (amd_iommu_snp_en && (type == IOMMU_DOMAIN_IDENTITY))
-		return ERR_PTR(-EINVAL);
-
-	domain = protection_domain_alloc(type, dev_to_node(dev));
+	domain = protection_domain_alloc(dev_to_node(dev));
 	if (!domain)
 		return ERR_PTR(-ENOMEM);
 
-	ret = pdom_setup_pgtable(domain, type, pgtable);
+	ret = pdom_setup_pgtable(domain, pgtable);
 	if (ret) {
 		pdom_id_free(domain->id);
 		kfree(domain);
@@ -2550,7 +2537,7 @@ static struct iommu_domain *do_iommu_domain_alloc(unsigned int type,
 	domain->domain.geometry.force_aperture = true;
 	domain->domain.pgsize_bitmap = domain->iop.pgtbl.cfg.pgsize_bitmap;
 
-	domain->domain.type = type;
+	domain->domain.type = IOMMU_DOMAIN_UNMANAGED;
 	domain->domain.ops = iommu->iommu.ops->default_domain_ops;
 
 	if (dirty_tracking)
@@ -2564,7 +2551,6 @@ amd_iommu_domain_alloc_paging_flags(struct device *dev, u32 flags,
 				    const struct iommu_user_data *user_data)
 
 {
-	unsigned int type = IOMMU_DOMAIN_UNMANAGED;
 	struct amd_iommu *iommu = get_amd_iommu_from_dev(dev);
 	const u32 supported_flags = IOMMU_HWPT_ALLOC_DIRTY_TRACKING |
 						IOMMU_HWPT_ALLOC_PASID;
@@ -2577,20 +2563,19 @@ amd_iommu_domain_alloc_paging_flags(struct device *dev, u32 flags,
 		if (!amd_iommu_pasid_supported())
 			return ERR_PTR(-EOPNOTSUPP);
 
-		return do_iommu_domain_alloc(type, dev, flags, AMD_IOMMU_V2);
+		return do_iommu_domain_alloc(dev, flags, AMD_IOMMU_V2);
 	}
 
 	/* Allocate domain with v1 page table for dirty tracking */
 	if (flags & IOMMU_HWPT_ALLOC_DIRTY_TRACKING) {
 		if (amd_iommu_hd_support(iommu))
-			return do_iommu_domain_alloc(type, dev, flags,
-						     AMD_IOMMU_V1);
+			return do_iommu_domain_alloc(dev, flags, AMD_IOMMU_V1);
 
 		return ERR_PTR(-EOPNOTSUPP);
 	}
 
 	/* If nothing specific is required use the kernel commandline default */
-	return do_iommu_domain_alloc(type, dev, 0, amd_iommu_pgtable);
+	return do_iommu_domain_alloc(dev, 0, amd_iommu_pgtable);
 }
 
 void amd_iommu_domain_free(struct iommu_domain *dom)
diff --git a/drivers/iommu/amd/pasid.c b/drivers/iommu/amd/pasid.c
index 8c73a30c2800e7..9101d07b11d3f7 100644
--- a/drivers/iommu/amd/pasid.c
+++ b/drivers/iommu/amd/pasid.c
@@ -185,12 +185,13 @@ struct iommu_domain *amd_iommu_domain_alloc_sva(struct device *dev,
 	struct protection_domain *pdom;
 	int ret;
 
-	pdom = protection_domain_alloc(IOMMU_DOMAIN_SVA, dev_to_node(dev));
+	pdom = protection_domain_alloc(dev_to_node(dev));
 	if (!pdom)
 		return ERR_PTR(-ENOMEM);
 
 	pdom->domain.ops = &amd_sva_domain_ops;
 	pdom->mn.ops = &sva_mn;
+	pdom->domain.type = IOMMU_DOMAIN_SVA;
 
 	ret = mmu_notifier_register(&pdom->mn, mm);
 	if (ret) {
-- 
2.43.0

