Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013005.outbound.protection.outlook.com [40.93.196.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96A8A3246F4;
	Thu, 27 Nov 2025 23:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764287657; cv=fail; b=av4athfFPYDI+W5poCEvKLYCiBGf0yzYC/uFlcDSxtnb6mzhdKomi37fuvmJJmfPcpWsAoTea40P6sJ53BpG5dVP8Q9u8ovOYw5Vm6oNx8wFl6R6t4M5VoDCm0N8/TTpblnJazvQO6oQDuWr4nUJZ3vZWaaJhDhwYWdQ8hPePZ0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764287657; c=relaxed/simple;
	bh=c4afCnkJnZHypHWynTAjWuvsedifq7oe5lF2Rt3GmU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=AI/bRMUuXr7w9BS/iv5DrhlaFDoU1+F4f7kDnDhq20s9XGrzQcUy7AtXFgjQcw7y0g7xvjJApchR0BPj/fK2LcyenUq7YpmTZ+IQqp77guaABSwwddOQPGOML5Z1YLVm4hOYEGJEw+jrprxNH7x1Jp4ZhnrNUqqKBJN6Rlnq7GM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kMsW4XBo; arc=fail smtp.client-ip=40.93.196.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kMsW4XBo"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L+SptHEoUJe4K5RCwF4tAlz6VnuUcno72CQJ82S6uCzSi9qsS51EoILc5k0Z4scSl/fxRNJAoNNDyulC5BG0/T8dPM9ofcpzWcjK9vEYqn4OazrZibfFK3hlG1YSKrYHBMZsiKgJ5lpFEV5PspaeLde6x4j/GZkoAviPNxj35y8eXloLHkni7A2jtvbZOSzcwRHvo/1VLsZltoAlaUiQ2xLYjXEpVP2e10ZRfx714OZtKCo6AUl79mqM6dr3dEdSwkwnoBErAlB3J8GRpLyExZuRTxMyykbUj4eJ0acN97eqeQ+gjKy3z+zd21h9SErzkcKMyM0sgd8QnoN2dB4OEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+mMureuZnPL65iUkMtXhBjsHWoxOZmK7u7wqy9h5KdA=;
 b=XJqxU3hQrbUj0bW3f8rhZ0KIJ4jedk6YLWgVYzZ1Ft/q7oFj41/DO5+fWHrf5Jqsg3+8MCgtEW6u2y0jpAN8h6pASs6WoWf7rqvpxZhJ3IFFI0b9QwnWN4ZvG9rlqLxeVJnG9aQ0E2UGWiCrLNwGqWGT2nF4W3jN7Ekm5G/no7c25wVRSzXtQsWBpXfyjp0s5mU/ENVAQ8TcBkcTn1yFrf7Xu1C6Lq+qWRLCJeWyM2Wvzuel6eWHHPkUE8lS/WWyZGADGVW4zSOTkZ0aR1vPkUMU2DJqRHTJRnEKSsvEmf74uYiuRT6tFk8QxmgkeS0u+FERZiclzsmUjaZDXrr+HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+mMureuZnPL65iUkMtXhBjsHWoxOZmK7u7wqy9h5KdA=;
 b=kMsW4XBoA4zuktSQdwhV2hjSS/+3+Zn8xfhfkXxCBC7Ro93sjscy0iNp5PoopFiDegGAuJ5H7ueKU5VCHe3+K9WdI9TW2GiYA6kA1x5Y5F1wxeLj51AKvc1pSAH4UAsjCcD1GH27H7TFrqebxD6c8yWxNC1LMixRVwq1vM+X94iN5X5IqhdkFGZH3YInjWhmb652DjRAK3poyx/d9kR9MdE51E5c2uj97n40rJ+udf2301B6M1m2q6yG8fLhU9jwRKQ9ajinDjNWyym1OphKf+77rRN/oOoga6LaYADT3bkNO2gQQ2r++LnM/wSNAQESaYQ1IQY394+UoPpqkiYgLA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB3613.namprd12.prod.outlook.com (2603:10b6:208:c1::17)
 by SJ0PR12MB6926.namprd12.prod.outlook.com (2603:10b6:a03:485::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.15; Thu, 27 Nov
 2025 23:54:10 +0000
Received: from MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b]) by MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b%4]) with mapi id 15.20.9366.012; Thu, 27 Nov 2025
 23:54:10 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: David Woodhouse <dwmw2@infradead.org>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	Calvin Owens <calvin@wbinvd.org>,
	Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Kevin Tian <kevin.tian@intel.com>,
	patches@lists.linux.dev,
	Tina Zhang <tina.zhang@intel.com>
Subject: [PATCH 1/2] iommupt/vtd: Allow VT-d to have a larger table top than the vasz requires
Date: Thu, 27 Nov 2025 19:54:07 -0400
Message-ID: <1-v1-ae5d7f0f2620+13b-vtd_mgaw_jgg@nvidia.com>
In-Reply-To: <0-v1-ae5d7f0f2620+13b-vtd_mgaw_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P222CA0027.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::32) To MN2PR12MB3613.namprd12.prod.outlook.com
 (2603:10b6:208:c1::17)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB3613:EE_|SJ0PR12MB6926:EE_
X-MS-Office365-Filtering-Correlation-Id: 458c278d-b43c-46e6-8c4a-08de2e104208
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?E36dz1GWYoAogsMDv8eaJ4ng8QmlPNncl3omEZ3r9+4/yESzgx6WsMqKv5Ml?=
 =?us-ascii?Q?pv0qmY7m40SOabuk0tT4RbNZ/qbQECYHtydKOi5cEHxCvi75mC8wT1YlxIK7?=
 =?us-ascii?Q?zSTs8+XSOOZJbLrzdusVhVuG45bgHF+OEk0CtxSf/YFaINYBnNZZlGC/Kge9?=
 =?us-ascii?Q?dhAWYuqRtbF02Wy3+O/3cTIP4q6rizNdMepIf7aE7VBQqG40nqqHm14yRYz2?=
 =?us-ascii?Q?c2R3gqrX4o5MfnmpaGMLl4RxY3prnRRRjBPBwfCaygj/yW1mSde/O2HqLeMG?=
 =?us-ascii?Q?wsUk5IHbw+hWMB/tvznLf7H3A7vN8F6dslbGQgy/aVB+FCqTDWAO4npKey1S?=
 =?us-ascii?Q?zX/ABRj4lFoOegsf8bJX3tf4FmFUlx/G+hugfzwIpekiKDiTp6hex6PbQJMQ?=
 =?us-ascii?Q?mJjsOHWTxPrkvP2ChVwR5daHa25JewNTH5ZWD/KwEaari/tlc2QtcyauuJEV?=
 =?us-ascii?Q?qGHYZ66o23Rb0ve+xHNFipVlCKbAzGyBnRlGh2A0d2EB2OghQ88t0MXrQTEm?=
 =?us-ascii?Q?w67PoUfQcTx+40zpLAQXFbDd1XB01+x0buV+EzfsMEYRCsnbV8TrnZpA30rt?=
 =?us-ascii?Q?0EZfwNRrIU8qJ6gHBtbqtrIf0jtaMFBtZ9yBZGHwHUPVmC0x4kJ80fkROTZx?=
 =?us-ascii?Q?7mDUbayakffUjyQEh1BFkzxyVTli+VvEVPu6oKTZgIy1n9XfY3PaCnkFyTqx?=
 =?us-ascii?Q?wTpY1CuGYzLkOcmVz32/QBi6QouCJ+Gbd+XHTMQiDa3NjjozAO+ZLqtN0AR9?=
 =?us-ascii?Q?c35U1qEkH+ELCNEseOHsZjRMriALdYl9tl54R6QXulCmLaOSXcbBcb/jQ3Hm?=
 =?us-ascii?Q?GJwlfRhlpYkabUUu3R7AE84SIbVQqo/djVN5ssGiN0XvFb5Km+4rc17ZKHAT?=
 =?us-ascii?Q?VV7iXPpVWy100SSesxtQ0Sqr+3A8nRzFEQ6yBAzQpmRiDRkDi2je2za1A/Tp?=
 =?us-ascii?Q?BQrpzJGrIcSAsMlY+549JWrLiQjK7MiwwylMOgA8CFcsM7eismExfmaxpBfZ?=
 =?us-ascii?Q?Or87UrCvggHfA7K2scB8aF8/JLMc7ClRUpcWKTnsZQ7FhdfynlAokZtQhInM?=
 =?us-ascii?Q?9ZeTXgzl8d+FpBYNDdWo0nOAHt+Wc+b+qbqQSTgnIHoQKdfV2XTAGJYN5vcj?=
 =?us-ascii?Q?kn1ppKRDGh8bETt026KVH27brMXAqWKIUpkp/SJzRdz9PcZwCPBPLOrI2lRu?=
 =?us-ascii?Q?aMFOuPw/qmEHiOuG4fgqqQRW2OCiTMUuMbCyAoZWAQ/giOQmZiVk5RNQWHmc?=
 =?us-ascii?Q?MvZTj7P+IvsQe0jxeBrRM5HHO4UJFQ0qQTJVxYriZ/dlF1AK5hYasI+GH/NY?=
 =?us-ascii?Q?veKagXEA8Iqp3w2YmO0kzMQTDzLF01PiRvKWGdaZps46nyf1g7WIXdwmJsMg?=
 =?us-ascii?Q?4jTnpbyZMYs0I2nr+nbJeqJYnUpLDZKA+0nOfA833RL9CvDkyk+HqMDCEZpF?=
 =?us-ascii?Q?EBOOIZP+aQ0UEdISfTvEHOgcAtwQ5KKSNf/siZuRMu5Oje503B/R9Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3613.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?A8iQPLegq2O9boNA7wOKMozKrdxdHqXB1sQAPE+fEDy1tJqRfoPS0wf5GyGX?=
 =?us-ascii?Q?4YXDhXVnxUBv3sHDnazNFi//zilUhyqQ9Xt+cvxygb+SSI1hyk7E8pf/TArQ?=
 =?us-ascii?Q?rdoR8Y7L9riefr9KoYpU94Zbxok8lzV8AYv5kl8X3LDGcJrsQhjeWwMf7pHL?=
 =?us-ascii?Q?8lxSE3Dm1oezZL4QcpDZaqmvkAlFzU7yC6eOVjLOU8CKD7jaQ5BP0Fdvg7iU?=
 =?us-ascii?Q?/eTGmbrS95xbzLQlM+7CJQyccnqKtKUKluwSngMyLTpcr3zZPCeaFiyAZtv/?=
 =?us-ascii?Q?opwibEkhEQZYVRh4h5KoM2PXgrBUEzYzwPKq3hAivRh8E+e8jHbm7FU3NIEA?=
 =?us-ascii?Q?MEzmvR4+aGW4sldguZ34qUs2vWQBG5lLzsKi7B6N03Wp7gxHO6t6Z3FY6V8A?=
 =?us-ascii?Q?ub3pJ9GDN6wGBbVJxmu3MyMjr+Zsw+VQIm56j3GevqzOizZODcwn9PbO0RTN?=
 =?us-ascii?Q?y8x0tYP5RoFs9apwEG9GWYbJf3utCpcQCbHutObW53wFgAeigxh4oJqVX9GC?=
 =?us-ascii?Q?BsC2GX9jeQP4Y1f1S3gzbMw+oH7EmpXr6UXv0mSFGNq2L9ZLJQxs4G4eU1x5?=
 =?us-ascii?Q?A3iuvavz4OON7Qpu8K82x/qoM+sUvlRopP1cC2jsnS2Zww4HpJc3uk26bBpb?=
 =?us-ascii?Q?0gK86dV0LG2kFQXXDCtd1G+aajlbIelVg5Ztb5ajrrpfuGGwvNdw+zD+56Ff?=
 =?us-ascii?Q?fWScYpFYeNdECrLn7EjhktQQWfbYhcZ5qHIikxHysT0ScRsRVIV1E7Qep0ei?=
 =?us-ascii?Q?FG5VDPmIIrotwCvPTIbR/hz9YxEoNKZyt1/UAnSVfm6Ld9QWCfrZ9JxRk6EQ?=
 =?us-ascii?Q?hIy991mFjqBgh/0SSIcx7d1JMjwcp6QZoTttSybx6m1EYrIGftC4AEbp/D0D?=
 =?us-ascii?Q?OjRtQQ/4pnEglRzQrAjURpvilXMFgvzwQUbLaBGpqMYcDAMDrbwMAf9Mn2AV?=
 =?us-ascii?Q?kPqY9iQnGRgEnFmfNY7XvnntMpTlwy494gv5P1CSuOas8jXi6lFowMvPsHtM?=
 =?us-ascii?Q?ogE4Nd/aHtyvkVLQJc4+H6ZmAu4Qs4QfZ0YFuyMvCK0+ZRYuaZRB1uki8t87?=
 =?us-ascii?Q?zrKS/gVLqjcxNxDlqOqa+lDv66Wmop45e3EVqMs06G5r67ZfQXAIOQCrmOaZ?=
 =?us-ascii?Q?B7oO3q6do/uaMv8Y6wPeSBbc+Tees7Ro+5jV+sG/Jr+GST+UPgnr5KL0hrkF?=
 =?us-ascii?Q?c0pRJQScXbDRA+L04Ct6kxkii9I/lpFZ9isCqHHcwqpvmDeIIfzGUh7Dwctm?=
 =?us-ascii?Q?IKPs54Nc0brK9oGOjFzHYMOfMsVmXUdYPPFCfX8NXvKqzXMGP0MCNLiCc5vV?=
 =?us-ascii?Q?jI1pBppNxUY55XvcKT0+1jiPEOZoePYdMLE+QbzKFHRLol8Dxl4HrjGzAXZP?=
 =?us-ascii?Q?GnNXdT9yeHo34JEYMZHI9Fl7Gd25M7gFKDKT8QDVwbIBU36/R0SMw+opxnzk?=
 =?us-ascii?Q?QTUzY0SRFPaPv7BRNLxMCD2LG6POZWVLvkOzzfhzdhHkZnIXVo6wXjAAIbX7?=
 =?us-ascii?Q?FgJYTpV7il87hdTTZKM8acCOhOp02Gdbn80RGcEpNw0Wqi6g8QsXYR6nxrZQ?=
 =?us-ascii?Q?nkED065CaU3qIgzaNSw=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 458c278d-b43c-46e6-8c4a-08de2e104208
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3613.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2025 23:54:09.6807
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I4fy0o6Rnf6ihhV0VOqpvfWew2VXuUh5Eq8EQbpfUQSUr9In00wPt5euOgPv9RLG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6926

VT-d second stage HW specifies both the maximum IOVA and the supported
table walk starting points. Weirdly there is HW that only supports a 4
level walk but has a maximum IOVA that only needs 3.

The current code miscalculates this and creates a wrongly sized page table
which ultimately fails the compatability check for number of levels.

This is fixed by allowing the page table to be created with both a vasz
and top_level input. The vasz will set the aperture for the domain while
the top_level will set the page table geometry.

Add top_level to vtdss and correct the logic in VT-d to generate the right
top_level and vasz from mgaw and sagaw.

Fixes: d373449d8e97 ("iommu/vt-d: Use the generic iommu page table")
Reported-by: Calvin Owens <calvin@wbinvd.org>
Closes: https://lore.kernel.org/r/8f257d2651eb8a4358fcbd47b0145002e5f1d638.1764237717.git.calvin@wbinvd.org
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/generic_pt/fmt/vtdss.h | 19 ++++++-------------
 drivers/iommu/generic_pt/iommu_pt.h  | 14 ++++++++++++++
 drivers/iommu/intel/iommu.c          | 20 +++++++++++++-------
 include/linux/generic_pt/iommu.h     |  2 ++
 4 files changed, 35 insertions(+), 20 deletions(-)

diff --git a/drivers/iommu/generic_pt/fmt/vtdss.h b/drivers/iommu/generic_pt/fmt/vtdss.h
index 50ffed9d0e508f..f5f8981edde72e 100644
--- a/drivers/iommu/generic_pt/fmt/vtdss.h
+++ b/drivers/iommu/generic_pt/fmt/vtdss.h
@@ -248,18 +248,11 @@ static inline int vtdss_pt_iommu_fmt_init(struct pt_iommu_vtdss *iommu_table,
 					  const struct pt_iommu_vtdss_cfg *cfg)
 {
 	struct pt_vtdss *table = &iommu_table->vtdss_pt;
-	unsigned int vasz_lg2 = cfg->common.hw_max_vasz_lg2;
 
-	if (vasz_lg2 > PT_MAX_VA_ADDRESS_LG2)
-		return -EOPNOTSUPP;
-	else if (vasz_lg2 > 48)
-		pt_top_set_level(&table->common, 4);
-	else if (vasz_lg2 > 39)
-		pt_top_set_level(&table->common, 3);
-	else if (vasz_lg2 > 30)
-		pt_top_set_level(&table->common, 2);
-	else
+	if (cfg->top_level > 4 || cfg->top_level < 2)
 		return -EOPNOTSUPP;
+
+	pt_top_set_level(&table->common, cfg->top_level);
 	return 0;
 }
 #define pt_iommu_fmt_init vtdss_pt_iommu_fmt_init
@@ -282,9 +275,9 @@ vtdss_pt_iommu_fmt_hw_info(struct pt_iommu_vtdss *table,
 
 #if defined(GENERIC_PT_KUNIT)
 static const struct pt_iommu_vtdss_cfg vtdss_kunit_fmt_cfgs[] = {
-	[0] = { .common.hw_max_vasz_lg2 = 39 },
-	[1] = { .common.hw_max_vasz_lg2 = 48 },
-	[2] = { .common.hw_max_vasz_lg2 = 57 },
+	[0] = { .common.hw_max_vasz_lg2 = 39, .top_level = 2},
+	[1] = { .common.hw_max_vasz_lg2 = 48, .top_level = 3},
+	[2] = { .common.hw_max_vasz_lg2 = 57, .top_level = 4},
 };
 #define kunit_fmt_cfgs vtdss_kunit_fmt_cfgs
 enum { KUNIT_FMT_FEATURES = BIT(PT_FEAT_VTDSS_FORCE_WRITEABLE) };
diff --git a/drivers/iommu/generic_pt/iommu_pt.h b/drivers/iommu/generic_pt/iommu_pt.h
index 032d04ec7b568d..97aeda1ad01cca 100644
--- a/drivers/iommu/generic_pt/iommu_pt.h
+++ b/drivers/iommu/generic_pt/iommu_pt.h
@@ -1128,6 +1128,20 @@ static int pt_init_common(struct pt_common *common)
 		     PT_FORCE_ENABLED_FEATURES))
 		return -EOPNOTSUPP;
 
+	/*
+	 * Check if the top level of the page table is too small to hold the
+	 * specified maxvasz.
+	 */
+	if (!pt_feature(common, PT_FEAT_DYNAMIC_TOP) &&
+	    top_range.top_level != PT_MAX_TOP_LEVEL) {
+		struct pt_state pts = { .range = &top_range,
+					.level = top_range.top_level };
+
+		if (common->max_vasz_lg2 >
+		    pt_num_items_lg2(&pts) + pt_table_item_lg2sz(&pts))
+			return -EOPNOTSUPP;
+	}
+
 	if (common->max_oasz_lg2 == 0)
 		common->max_oasz_lg2 = pt_max_oa_lg2(common);
 	else
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 7b3016491ca586..f117349d67dbf8 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -2858,22 +2858,28 @@ intel_iommu_domain_alloc_first_stage(struct device *dev,
 	return &dmar_domain->domain;
 }
 
-static int compute_vasz_lg2_ss(struct intel_iommu *iommu)
+static unsigned int compute_vasz_lg2_ss(struct intel_iommu *iommu,
+					unsigned int *top_level)
 {
 	unsigned int sagaw = cap_sagaw(iommu->cap);
 	unsigned int mgaw = cap_mgaw(iommu->cap);
 
 	/*
 	 * Find the largest table size that both the mgaw and sagaw support.
-	 * This sets both the number of table levels and the valid range of
-	 * IOVA.
+	 * This sets the valid range of IOVA and the top starting level.
+	 * Some HW may only support a 4 or 5 level walk but must limit IOVA to
+	 * 3 levels.
 	 */
-	if (mgaw >= 48 && (sagaw & BIT(3)))
+	if (mgaw > 48 && sagaw >= BIT(3)) {
+		*top_level = 4;
 		return min(57, mgaw);
-	else if (mgaw >= 39 && (sagaw & BIT(2)))
+	} else if (mgaw > 39 && sagaw >= BIT(2)) {
+		*top_level = 3 + ffs(sagaw >> 3);
 		return min(48, mgaw);
-	else if (mgaw >= 30 && (sagaw & BIT(1)))
+	} else if (mgaw > 30 && sagaw >= BIT(1)) {
+		*top_level = 2 + ffs(sagaw >> 2);
 		return min(39, mgaw);
+	}
 	return 0;
 }
 
@@ -2910,7 +2916,7 @@ intel_iommu_domain_alloc_second_stage(struct device *dev,
 	if (IS_ERR(dmar_domain))
 		return ERR_CAST(dmar_domain);
 
-	cfg.common.hw_max_vasz_lg2 = compute_vasz_lg2_ss(iommu);
+	cfg.common.hw_max_vasz_lg2 = compute_vasz_lg2_ss(iommu, &cfg.top_level);
 	cfg.common.hw_max_oasz_lg2 = 52;
 	cfg.common.features = BIT(PT_FEAT_FLUSH_RANGE);
 
diff --git a/include/linux/generic_pt/iommu.h b/include/linux/generic_pt/iommu.h
index cfe05a77f86b05..c134132ed10f89 100644
--- a/include/linux/generic_pt/iommu.h
+++ b/include/linux/generic_pt/iommu.h
@@ -264,6 +264,8 @@ IOMMU_PROTOTYPES(amdv1_mock);
 
 struct pt_iommu_vtdss_cfg {
 	struct pt_iommu_cfg common;
+	/* 4 is a 57 bit 5 level table */
+	unsigned int top_level;
 };
 
 struct pt_iommu_vtdss_hw_info {
-- 
2.43.0

