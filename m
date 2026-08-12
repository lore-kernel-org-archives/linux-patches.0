Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010069.outbound.protection.outlook.com [52.101.201.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C3E236196E;
	Wed, 12 Aug 2026 20:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786565396; cv=fail; b=LpxpOptDbFHiuFDQUuSY8JxAS3HHoeWRUGGAeuvbelMvtr5DjeE5BZf+Zml1U0xsmJzVupBPliZEfmtwwzw7bxjnmIjYmFLCeWszVkHCmzUdzjyiMOY53ob4EWoKAZMAH0HyVrghuX3YaPnho16aFtG/IHwm1uaA3eEKTjJh8e8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786565396; c=relaxed/simple;
	bh=M0GQpy3DRsxr9YyoAaTaLKVRpt5JMz8ES/aip+oPA0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UG7hskgm5rwHHQKKGvZ7GtmyexQkuSyKNKbLaStWtR/T1YbZFGjxNAbow46HBKhVZhQ/e90Av9z4gnkMLw2GvLzreFe4sK9eXkdpXgIohWK72l7v9HPChSIDGz+Has7e2OGmmBzM/4xPN9vWig+pydShgtuyuwbf0h7BY+hMtdw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=so8ta72L; arc=fail smtp.client-ip=52.101.201.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="so8ta72L"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QvOsJ9sBUFq56MCKsgTdt44g7kIhrP9oXVhq0Tpkk0HbNn8nSvYbZuI6hvz6LaoCk77yfkxkxxwSC8rKzy2/TWs97fWxAz4aAZQOsASEIqXuoXj+u5DDozpHBaMpmY/ivlT/gHamK8ckBq2xVk8EiM7XEpStIqOr56F7tu58LROLaox5swnfPBqiu6Pz3p3v0bDpO61UclerQg6dn37Qy7dwRZqKC7Zs9q4+zNnUE2074ltJFh61J73wY4CSpg9obMI7DEea/kud27jESbetum4R25CvhM42MW08fMwIOXEGTbNLmBQphOUbXwcb9TkAw8cbj7mn3+HG44pepSd5LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jZzOqZ6sUg3nZEKxgjj8w0ob5iPIoRJAxLZ9+RqzNZU=;
 b=zQAVu29Uqx88j120kU70zPNEb+G3Ftfou3egPelyOwdN3MA1JbBFq4Lx2zsYurx+VQkwx667HeBoADRwoR8jbiuQkUpW9g2L6cjgkzpfHZt2N1UZvJLXnLrCvLthfQOg4lxByq8grSrMNg1VidqZvn29z18e10oUN59nsx86YzcxyqVMWECJpPfTTShJyYBxkTUuLu8tch6n8B3jQd0gdSKp0fwsfyf26Y1RapvLTHmKDNujlIFegGHB4BY0YCt3v3J2EjRWICVnV5+0y0zYtusX3jWou8g/CmpoIuvoT5WJkAZ9N78FqJVIrm8HiyPXoUS9Ymv5Kkw2UwFS8KJeMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jZzOqZ6sUg3nZEKxgjj8w0ob5iPIoRJAxLZ9+RqzNZU=;
 b=so8ta72LwcO5aR5yFHlqPs0VLDalk0OgcAHTaRZSbQRrlFbsdOuVi7+pNA/6SN1CCBKSqLu/m/aaYbhgQCcgm47nFwzE+lsSGAsAJ48MqU9XQFKKsIsWq/gfSTdk5sq1vz1gfwNLmeraJz+46H4BoRG0vcyYbjfbdgFwcmW+z2wwr+hLKykc2hx9T2aFgcMecq5vT8DgflQDuo04U8ZmCeAK/47Pc7kkun5ynHKbfG29CGXc+Ao9xxeI5QS68hwLH2dh5Acq9Kyk7uOmjGgqSI/l1ht50ndfPzYzMwrroL55CP8FDjT5SsbgIVb0iKroo+qIh7NlmFoEseUKJiyCzA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by PH7PR12MB8121.namprd12.prod.outlook.com (2603:10b6:510:2b5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.19; Wed, 12 Aug
 2026 20:09:37 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0315.011; Wed, 12 Aug 2026
 20:09:36 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: David Matlack <dmatlack@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v2 5/9] iommupt/armv8: Implement the iommu specific components
Date: Wed, 12 Aug 2026 17:09:21 -0300
Message-ID: <5-v2-563ee63886f0+1209-iommupt_armv8_jgg@nvidia.com>
In-Reply-To: <0-v2-563ee63886f0+1209-iommupt_armv8_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4P288CA0025.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d3::10) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|PH7PR12MB8121:EE_
X-MS-Office365-Filtering-Correlation-Id: 10397d57-309c-48cb-4551-08def8ad9d13
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|23010399003|7416014|366016|11063799006|3023799007|56012099006|6133799003|18002099003|22082099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	Wb9KRmfxGC8IuNUM6YN5gMLrqZ77RsBSzILcjewLJ52noTyRo4uBm90dvMKR/trgc93Tel3RWz4nra75otWA302kGIT42rMZ8U7tudjqaYtEKIItfcLX5hPKmqzGCaoUs9saIbuldEOeiQwvhVsJU2x868B71mvSOpFA9XrdLpsxHlomBvoEkVo2D4FitX5mUevv7uqtwmUe+i0wMNhxhRPwcFWhEhp1jyVi25NmIPJObEMMugRVrTM58ofVaoCnaKqomxWdHcNRtdv87+nwe5WLLANBiu5WK8L53eGFAJ4k8nvvBk5uRacsdekfHZrGValSltHK3JMorRBuMSQVbMsfk0rSCUfkJ4xpmIWenSYg7jFUMKW1S0psjsLCSdT1OjOzYiMCcsXsFe7TeIZap5xpHh5aDhH25PqJJvatVzBnUqwqqiESqvnHb/abC98Y5eXQxFOat1ddFnNJwTi0Tvw/7C35t6fjwG7mXVESLymLNQoMJMxYpWQ0ZP3jUs3vXuJDp+egl7IuMAyyZpWthVKMDJ0lOakLeGOPyMudmugwjKJCO2B4rdFJMgyvblNheDz53UTfX2/Md9tssIjZiWj1HLywsUGKnnhXjf6dW7kz9isQXmlE9RKYFUjeGdNpzbtrHPoFZKpFRRn3gy1y9RPZpDcpZXWVAT0iFJB/3HY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(7416014)(366016)(11063799006)(3023799007)(56012099006)(6133799003)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?w6SPpSmBdE/BC2Nw3953gEj0cxpxISsi3TFPii2GtgwhBa83ryP1q7nkmUzH?=
 =?us-ascii?Q?MFOwd//wYKDmauSuxnf1ATvrFl041exLYjriqez3dCKgd9UOW3r7rV6SJ+ts?=
 =?us-ascii?Q?GqQg0THruG9ukTo5iFvEOA4G1UXmsdkxed1dEMb+tj/fJgBn5xVxl3aqEmqP?=
 =?us-ascii?Q?t1zSsBpP08Wi+jBLFyOzE5GZOHr9YzJwykF4Me7QTuDOWyKuQogsTh+ur94w?=
 =?us-ascii?Q?bp0d1iHCtQws4KL7tpa9JiLGTtWCeQfJhAMC+KYqdJQLnr+TZRFZK5ERRzOq?=
 =?us-ascii?Q?row5uBUasNuo0E6MvbUlEYR1tuDMSzfeDfGc33v2T2X0tmYJuEJAy7AbpZRM?=
 =?us-ascii?Q?hTu1kIZ0ymyZYgx2PT50YxcMrd0gIaZo6M3MwY4hd/ofzUdkomoivbKlqzFp?=
 =?us-ascii?Q?hYar/45gx15MKvu/pv+kvOt5WpatxFQYAgIR+yIhxOAWlRtMjunKQl7wiR+W?=
 =?us-ascii?Q?4dSmReiTST5TbCyGgeoyzBMVQRPLvrOaoeWuH/uYbIdkLnbZiakMhINw8Y2o?=
 =?us-ascii?Q?qLTunj/m/pQxu3K5gE2mQrv70qg6GlEsy7cgfPKZ4wPlog/s1KrrBW2z33KF?=
 =?us-ascii?Q?95e5KIEge7BKrvMuLPmoChtbsoAf/z94TywjcNqyzRhPLzzU+avaDoyihnLk?=
 =?us-ascii?Q?jlCK5MvRrV+J09KF0hY0343kyTRXDzBwXBIC+M7sDLkFmxAXDQnlojifZG1+?=
 =?us-ascii?Q?3OvojPNwf8nfLu1yVf1CdZLtTDcJ6mBqkvu2L8J9dsnkzLA8krVtR+Lz8rlG?=
 =?us-ascii?Q?WlMMbTCbtvOHm5i69etkRRy+WeP7RjnUJbsStcfMGLB9Qa/9LpS1O2JF/Rrr?=
 =?us-ascii?Q?/wWA8BhGvXVJyJei8nECtsyoX1potx0P9qYvjPvVBgeQ0bFk0kCHc6AF92DQ?=
 =?us-ascii?Q?8DxSOwHI78L76HIM6b75uzaV1pitOBWNvxjfKXdt3vLyf+r4AGp0ypbMe8mj?=
 =?us-ascii?Q?DLyhfieQtH/btUM76y7kN6q/rbtWJd6+meGGtBJ1J0VInmoBI5kOBrj6+iK5?=
 =?us-ascii?Q?zhN7XSxcIKfdQagAoBMzrqyIqiG1kjy7EIgRJFodzcQZ39bekuScyccEp3D3?=
 =?us-ascii?Q?Tj6GJrbAd9M16SI6ahTFbC8nE1/8jwZ6NRg3DvIxaA7Wk3PSI5zdripNHGMn?=
 =?us-ascii?Q?nwfCtDXDxSkvEsg3yB4kVs3zeL2QBnzFBplsjNb96sFISQJvouOA59MQBW4B?=
 =?us-ascii?Q?WR6+0Oc3HNjxi5y2RQbUB4UkgvUqOYqc773z3BWujQGEyT8v/PjlmQH6m8WZ?=
 =?us-ascii?Q?/+SQVYecap6p/JVhiRslNHZlck75PM0sTAkHxEaRRUemiP4AdFK6A6hW+6gF?=
 =?us-ascii?Q?XdliKrUy94gCYbMQTEj4A45S5A+aSrNnZJ/7cLYIEt9GeRZqIi6RE8r5GgbT?=
 =?us-ascii?Q?3sAnYuLZ2qiAl31CuxZmLC5O7uejojeEKRdZKfXEDJCthjWRQi9MiiEcFsTQ?=
 =?us-ascii?Q?yhjVNWuTGkW5p5oQUnIdDJTnGvCOX8mbKZMGD5yksSV3jsAGoTleBlgug5oY?=
 =?us-ascii?Q?z1vw/GiK7UukBS/sMUuBDIejr2jRohn11YNvWSYE7S7M1oELGzdVmP71TW0t?=
 =?us-ascii?Q?c8w5Vn1iH3RM8a7pdUcOTa6lroaHj+roFl5KwW2UXemSZ7kA+FfDB6KxmxnQ?=
 =?us-ascii?Q?h5HcBMvnDjNnXRfYU8PkJ/QZba9ZHF+haBdXJgHt7bExtIj8vQ+QxVLTflST?=
 =?us-ascii?Q?U1yzmcMiLBRcytHBZsNlKSINXBvIlYf6lfuKAVtv+jtznVGoHceC/ETXfa2N?=
 =?us-ascii?Q?8i8yYOfmpw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10397d57-309c-48cb-4551-08def8ad9d13
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2026 20:09:28.4700
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fUQ7q5P/OIum1sQD1cIRjj8c6aTvxdfNq/f0JrdyHKWKjese9jau4mw4UQCPtNip
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8121

The iommu page table is built on top of the generic components, add the
peices required to turn that on for ARMv8
 - Makefile and kconfig
 - pt_iommu_* functions for ARMv8, including the complicated
   initialization of the level and structure from a typical pt_iommu cfg
 - pt_iommu_hw_info to return the field values program into the STE
 - 12 kunit patterns covering a range of operating modes

Include an inline helper pt_iommu_armv8_choose_granule_lg2sz() that does
similar to what iopgtbl does to select an appropriate translation granule
size.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/generic_pt/.kunitconfig      |   1 +
 drivers/iommu/generic_pt/Kconfig           |  12 +
 drivers/iommu/generic_pt/fmt/Makefile      |   2 +
 drivers/iommu/generic_pt/fmt/armv8.h       | 495 +++++++++++++++++++++
 drivers/iommu/generic_pt/fmt/iommu_armv8.c |  13 +
 include/linux/generic_pt/iommu.h           |  72 +++
 6 files changed, 595 insertions(+)
 create mode 100644 drivers/iommu/generic_pt/fmt/iommu_armv8.c

diff --git a/drivers/iommu/generic_pt/.kunitconfig b/drivers/iommu/generic_pt/.kunitconfig
index 0bb98fe581fe9c..08a0d07504d90f 100644
--- a/drivers/iommu/generic_pt/.kunitconfig
+++ b/drivers/iommu/generic_pt/.kunitconfig
@@ -4,6 +4,7 @@ CONFIG_GENERIC_PT=y
 CONFIG_DEBUG_GENERIC_PT=y
 CONFIG_IOMMU_PT=y
 CONFIG_IOMMU_PT_AMDV1=y
+CONFIG_IOMMU_PT_ARMV8=y
 CONFIG_IOMMU_PT_VTDSS=y
 CONFIG_IOMMU_PT_RISCV64=y
 CONFIG_IOMMU_PT_X86_64=y
diff --git a/drivers/iommu/generic_pt/Kconfig b/drivers/iommu/generic_pt/Kconfig
index f4ed1add58b749..4eb1af5953141b 100644
--- a/drivers/iommu/generic_pt/Kconfig
+++ b/drivers/iommu/generic_pt/Kconfig
@@ -42,6 +42,17 @@ config IOMMU_PT_AMDV1
 
 	  Selected automatically by an IOMMU driver that uses this format.
 
+config IOMMU_PT_ARMV8
+	tristate "IOMMU page table for 64 bit ARMv8"
+	depends on !GENERIC_ATOMIC64 # for cmpxchg64
+	help
+	  iommu_domain implementation for the ARMv8 VMSAv8-64 and the VMSAv8-32
+	  long descriptor pagetable format. This format supports both stage-1
+	  and stage-2, as well as address spaces up to 48-bits in size with
+	  4K, 16K, and 64K granule sizes.
+
+	  Selected automatically by an IOMMU driver that uses this format.
+
 config IOMMU_PT_VTDSS
        tristate "IOMMU page table for Intel VT-d Second Stage"
 	depends on !GENERIC_ATOMIC64 # for cmpxchg64
@@ -76,6 +87,7 @@ config IOMMU_PT_KUNIT_TEST
 	tristate "IOMMU Page Table KUnit Test" if !KUNIT_ALL_TESTS
 	depends on KUNIT
 	depends on IOMMU_PT_AMDV1 || !IOMMU_PT_AMDV1
+	depends on IOMMU_PT_ARMV8 || !IOMMU_PT_ARMV8
 	depends on IOMMU_PT_RISCV64 || !IOMMU_PT_RISCV64
 	depends on IOMMU_PT_X86_64 || !IOMMU_PT_X86_64
 	depends on IOMMU_PT_VTDSS || !IOMMU_PT_VTDSS
diff --git a/drivers/iommu/generic_pt/fmt/Makefile b/drivers/iommu/generic_pt/fmt/Makefile
index ea024d582594ee..6f0d69a72e7471 100644
--- a/drivers/iommu/generic_pt/fmt/Makefile
+++ b/drivers/iommu/generic_pt/fmt/Makefile
@@ -3,6 +3,8 @@
 iommu_pt_fmt-$(CONFIG_IOMMU_PT_AMDV1) += amdv1
 iommu_pt_fmt-$(CONFIG_IOMMUFD_TEST) += mock
 
+iommu_pt_fmt-$(CONFIG_IOMMU_PT_ARMV8) += armv8
+
 iommu_pt_fmt-$(CONFIG_IOMMU_PT_VTDSS) += vtdss
 
 iommu_pt_fmt-$(CONFIG_IOMMU_PT_RISCV64) += riscv64
diff --git a/drivers/iommu/generic_pt/fmt/armv8.h b/drivers/iommu/generic_pt/fmt/armv8.h
index 6bff34a0ebb59b..9ed192dfe272af 100644
--- a/drivers/iommu/generic_pt/fmt/armv8.h
+++ b/drivers/iommu/generic_pt/fmt/armv8.h
@@ -575,3 +575,498 @@ static inline u64 armv8pt_sw_bit(unsigned int bitnr)
 	}
 }
 #define pt_sw_bit armv8pt_sw_bit
+
+/* --- iommu */
+#include <linux/generic_pt/iommu.h>
+#include <linux/iommu.h>
+
+#define pt_iommu_table pt_iommu_armv8
+
+/* The common struct is in the per-format common struct */
+static inline struct pt_common *common_from_iommu(struct pt_iommu *iommu_table)
+{
+	return &container_of(iommu_table, struct pt_iommu_table, iommu)
+			->armpt.common;
+}
+
+static inline struct pt_iommu *iommu_from_common(struct pt_common *common)
+{
+	return &container_of(common, struct pt_iommu_table, armpt.common)->iommu;
+}
+
+static inline int armv8pt_iommu_set_prot(struct pt_common *common,
+					 struct pt_write_attrs *attrs,
+					 unsigned int iommu_prot)
+{
+	bool is_s1 = !pt_feature(common, PT_FEAT_ARMV8_S2);
+	u64 pte = 0;
+
+	if (is_s1) {
+		u64 ap = 0;
+
+		if (!(iommu_prot & IOMMU_WRITE) && (iommu_prot & IOMMU_READ))
+			ap |= ARMV8PT_AP_RDONLY;
+		if (!(iommu_prot & IOMMU_PRIV))
+			ap |= ARMV8PT_AP_UNPRIV;
+		pte = ARMV8PT_FMT_nG | FIELD_PREP(ARMV8PT_FMT_AP, ap);
+
+		if (iommu_prot & IOMMU_MMIO)
+			pte |= FIELD_PREP(ARMV8PT_FMT_ATTRINDX,
+					  ARMV8PT_MAIR_ATTR_IDX_DEV);
+		else if (iommu_prot & IOMMU_CACHE)
+			pte |= FIELD_PREP(ARMV8PT_FMT_ATTRINDX,
+					  ARMV8PT_MAIR_ATTR_IDX_CACHE);
+		else
+			pte |= FIELD_PREP(ARMV8PT_FMT_ATTRINDX,
+					  ARMV8PT_MAIR_ATTR_IDX_NC);
+	} else {
+		u64 s2ap = 0;
+
+		if (iommu_prot & IOMMU_READ)
+			s2ap |= ARMV8PT_S2AP_READ;
+		if (iommu_prot & IOMMU_WRITE)
+			s2ap |= ARMV8PT_S2AP_WRITE;
+		pte = FIELD_PREP(ARMV8PT_FMT_S2AP, s2ap);
+
+		if (iommu_prot & IOMMU_MMIO)
+			pte |= FIELD_PREP(ARMV8PT_FMT_S2MEMATTR,
+					  ARMV8PT_MEMATTR_DEV);
+		else if ((iommu_prot & IOMMU_CACHE) &&
+			 pt_feature(common, PT_FEAT_ARMV8_S2FWB))
+			pte |= FIELD_PREP(ARMV8PT_FMT_S2MEMATTR,
+					  ARMV8PT_MEMATTR_FWB_WB);
+		else if (iommu_prot & IOMMU_CACHE)
+			pte |= FIELD_PREP(ARMV8PT_FMT_S2MEMATTR,
+					  ARMV8PT_MEMATTR_OIWB);
+		else
+			pte |= FIELD_PREP(ARMV8PT_FMT_S2MEMATTR,
+					  ARMV8PT_MEMATTR_NC);
+	}
+
+	/*
+	 * For DBM the writable entry starts out dirty to avoid the HW doing
+	 * memory accesses to dirty it. We can just leave the DBM bit
+	 * permanently set with no cost.
+	 */
+	if (pt_feature(common, PT_FEAT_ARMV8_DBM) && (iommu_prot & IOMMU_WRITE))
+		pte |= ARMV8PT_FMT_DBM;
+
+	/* Tables D8-52/53: with LPA2 bits [9:8] are OA[51:50], not SH */
+	if (!pt_feature(common, PT_FEAT_ARMV8_LPA2)) {
+		if (iommu_prot & IOMMU_CACHE)
+			pte |= FIELD_PREP(ARMV8PT_FMT_SH, ARMV8PT_SH_IS);
+		else
+			pte |= FIELD_PREP(ARMV8PT_FMT_SH, ARMV8PT_SH_OS);
+	}
+
+	if (iommu_prot & IOMMU_NOEXEC)
+		pte |= ARMV8PT_FMT_PXN;
+
+	pte |= ARMV8PT_FMT_AF;
+
+	attrs->descriptor_bits = pte;
+	return 0;
+}
+#define pt_iommu_set_prot armv8pt_iommu_set_prot
+
+static inline unsigned int armv8pt_max_top_level(unsigned int tgsz_lg2,
+						 unsigned int features)
+{
+	if (tgsz_lg2 == SZLG2_64K)
+		return ARML1;
+	if (tgsz_lg2 == SZLG2_4K && (features & BIT(PT_FEAT_ARMV8_LPA2)))
+		return ARMLn1;
+	return ARML0;
+}
+
+/*
+ * Debugging validation of the S2 initial lookup level against D8.2.
+ *
+ *   Table D8-8: "Effective minimum value of T0SZ" (R_DTLMN)
+ *   Table D8-9: "Implications of the effective minimum T0SZ value
+ *                on the initial stage 2 lookup level" (R_TDJSG)
+ *
+ * ARM initial lookup level = 3 - top_level. Table D8-9 constrains the
+ * shallowest allowed initial lookup level per PA size and granule:
+ *
+ *   4K:  ARM level 0 (top_level 3) requires PA >= 44
+ *   16K: ARM level 1 (top_level 2) requires PA >= 42
+ *   64K: ARM level 1 (top_level 2) requires PA >= 44
+ *
+ * The valid level set grows monotonically with PA size, so checking
+ * against IAS (vasz_lg2 <= PA size) is conservative.
+ *
+ * R_SRKBC: 4K granule at ARM level 3 (single entry level) requires
+ * FEAT_TTST.
+ */
+static inline void armv8pt_s2_validate_level(unsigned int top_level,
+					     unsigned int tgsz_lg2,
+					     unsigned int vasz_lg2, bool lpa2)
+{
+	unsigned int max_top_level;
+
+	switch (tgsz_lg2) {
+	case SZLG2_4K:
+		if (lpa2)
+			max_top_level =
+				vasz_lg2 >= 52 ?
+					ARMLn1 :
+					(vasz_lg2 >= 44 ? ARML0 : ARML1);
+		else
+			max_top_level = vasz_lg2 >= 44 ? ARML0 : ARML1;
+		break;
+	case SZLG2_16K: /* ARM level 1 requires PA >= 42 */
+		max_top_level = vasz_lg2 >= 42 ? ARML1 : ARML2;
+		break;
+	case SZLG2_64K: /* ARM level 1 requires PA >= 44 */
+		max_top_level = vasz_lg2 >= 44 ? ARML1 : ARML2;
+		break;
+	default:
+		return;
+	}
+
+	PT_WARN_ON(top_level > max_top_level);
+}
+
+/*
+ * It is a bug for a caller to pass in an illegal combination of features and
+ * tgsz.
+ */
+static inline bool armv8pt_validate_features(const struct pt_common *common,
+					     unsigned int tgsz_lg2)
+{
+	/* TTBR1 is S1 only */
+	if (pt_feature(common, PT_FEAT_ARMV8_S2) &&
+	    pt_feature(common, PT_FEAT_ARMV8_TTBR1))
+		return false;
+
+	/* S2FWB is S2 only */
+	if (pt_feature(common, PT_FEAT_ARMV8_S2FWB) &&
+	    !pt_feature(common, PT_FEAT_ARMV8_S2))
+		return false;
+
+	/* LPA2 (DS=1) is only valid for 4K and 16K granules */
+	if (pt_feature(common, PT_FEAT_ARMV8_LPA2) &&
+	    tgsz_lg2 == SZLG2_64K)
+		return false;
+
+	/* LPA is only valid for the 64K granule */
+	if (pt_feature(common, PT_FEAT_ARMV8_LPA) &&
+	    tgsz_lg2 != SZLG2_64K)
+		return false;
+
+	/* LVA is only valid for 64K granule Stage 1 */
+	if (pt_feature(common, PT_FEAT_ARMV8_LVA) &&
+	    (tgsz_lg2 != SZLG2_64K ||
+	     pt_feature(common, PT_FEAT_ARMV8_S2)))
+		return false;
+
+	return true;
+}
+
+static inline int armv8pt_oasz_to_ps(unsigned int oasz_lg2)
+{
+	/* Stream Table Entry: S2PS section, Context Descriptor: IPS section */
+	switch (oasz_lg2) {
+	case 32:
+		return 0;
+	case 36:
+		return 1;
+	case 40:
+		return 2;
+	case 42:
+		return 3;
+	case 44:
+		return 4;
+	case 48:
+		return 5;
+	case 52:
+		return 6;
+	default:
+		return -1;
+	}
+}
+
+static inline int armv8pt_iommu_fmt_init(struct pt_iommu_armv8 *iommu_table,
+					 const struct pt_iommu_armv8_cfg *cfg)
+{
+	struct pt_armv8 *armv8pt = &iommu_table->armpt;
+	unsigned int vasz_lg2 = cfg->common.hw_max_vasz_lg2;
+	unsigned int oasz_lg2 = cfg->common.hw_max_oasz_lg2;
+	unsigned int tgsz_lg2 = cfg->tgsz_lg2;
+	unsigned int max_top_level;
+	unsigned int levels;
+
+	if (tgsz_lg2 != SZLG2_4K && tgsz_lg2 != SZLG2_16K &&
+	    tgsz_lg2 != SZLG2_64K)
+		return -EOPNOTSUPP;
+
+	armv8pt->tgsz_lg2 = tgsz_lg2;
+	max_top_level =
+		armv8pt_max_top_level(tgsz_lg2, armv8pt->common.features);
+
+	if (WARN_ON(!armv8pt_validate_features(&armv8pt->common, tgsz_lg2)))
+		return -EOPNOTSUPP;
+	if (WARN_ON(vasz_lg2 <= tgsz_lg2))
+		return -EINVAL;
+
+	/* R_QQQSJ: Limit the OA to what the format supports */
+	if (pt_feature(&armv8pt->common, PT_FEAT_ARMV8_LPA2) ||
+	    pt_feature(&armv8pt->common, PT_FEAT_ARMV8_LPA))
+		armv8pt->common.max_oasz_lg2 = min(52, oasz_lg2);
+	else
+		armv8pt->common.max_oasz_lg2 = min(48, oasz_lg2);
+
+	if (armv8pt_oasz_to_ps(armv8pt->common.max_oasz_lg2) < 0)
+		return -EOPNOTSUPP;
+
+	if (WARN_ON(armv8pt->common.max_oasz_lg2 > PT_MAX_OUTPUT_ADDRESS_LG2))
+		return -EOPNOTSUPP;
+
+	/*
+	 * Limit the VA/IPA to what the format supports:
+	 *  - LPA2: 52-bit VA for 4K/16K (S1 and S2)
+	 *  - LVA:  52-bit VA for 64K S1
+	 *  - LPA:  52-bit IPA for 64K S2
+	 */
+	if (pt_feature(&armv8pt->common, PT_FEAT_ARMV8_LPA2) ||
+	    pt_feature(&armv8pt->common, PT_FEAT_ARMV8_LVA) ||
+	    (pt_feature(&armv8pt->common, PT_FEAT_ARMV8_S2) &&
+	     pt_feature(&armv8pt->common, PT_FEAT_ARMV8_LPA)))
+		armv8pt->common.max_vasz_lg2 = min(52, vasz_lg2);
+	else
+		armv8pt->common.max_vasz_lg2 = min(48, vasz_lg2);
+	vasz_lg2 = armv8pt->common.max_vasz_lg2;
+
+	levels = DIV_ROUND_UP(vasz_lg2 - tgsz_lg2,
+			      tgsz_lg2 - ilog2(PT_ITEM_WORD_SIZE));
+	if (levels > max_top_level + 1)
+		return -EINVAL;
+
+	/*
+	 * R_SRKBC: For the 4KB granule, an initial lookup level of 3 is
+	 * only supported if FEAT_TTST is implemented. See Table D8-9 and
+	 * Table D8-24. FEAT_TTST is not supported.
+	 */
+	if (pt_feature(&armv8pt->common, PT_FEAT_ARMV8_S2) &&
+	    tgsz_lg2 == SZLG2_4K && levels == 1)
+		return -EINVAL;
+
+	/*
+	 * D8.2.2: Always use the S2 concatenated tables feature (I_TDMHR)
+	 * to fold a top level of up to 16 tables into the next lower
+	 * level. Since FEAT_TTST is not supported single level cannot be
+	 * selected here either. Notice that there are a number of cases
+	 * in the spec that require concatenated tables (eg R_DXBSH),
+	 * since this always uses them it is OK. See commit 4dcac8407fe1
+	 * ("iommu/io-pgtable-arm: Fix stage-2 concatenation with 16K")
+	 */
+	if (!pt_feature(&armv8pt->common, PT_FEAT_DYNAMIC_TOP) &&
+	    pt_feature(&armv8pt->common, PT_FEAT_ARMV8_S2) && levels > 1) {
+		unsigned int topsz_lg2 =
+			vasz_lg2 - (tgsz_lg2 + (tgsz_lg2 - ilog2(sizeof(u64))) *
+						       (levels - 1));
+		if (topsz_lg2 <= ilog2(16))
+			levels--;
+	}
+
+	if (pt_feature(&armv8pt->common, PT_FEAT_ARMV8_S2))
+		armv8pt_s2_validate_level(levels - 1, tgsz_lg2, vasz_lg2,
+					  pt_feature(&armv8pt->common,
+						     PT_FEAT_ARMV8_LPA2));
+	pt_top_set_level(&armv8pt->common, levels - 1);
+	return 0;
+}
+#define pt_iommu_fmt_init armv8pt_iommu_fmt_init
+
+static inline void
+armv8pt_iommu_fmt_hw_info(struct pt_iommu_armv8 *table,
+			  const struct pt_range *top_range,
+			  struct pt_iommu_armv8_hw_info *info)
+{
+	struct pt_common *common = &table->armpt.common;
+	unsigned int tgsz_lg2 = table->armpt.tgsz_lg2;
+
+#ifdef __BIG_ENDIAN
+	info->endi = 1;
+#else
+	info->endi = 0;
+#endif
+
+	info->ttb = virt_to_phys(top_range->top_table);
+	WARN_ON(info->ttb & ~PT_TOP_PHYS_MASK);
+
+	/* D24.2.210 T0SZ: The region size is 2^(64-T0SZ) bytes. */
+	info->tsz = 64 - common->max_vasz_lg2;
+
+	/*
+	 * Context Descriptor TG0/TG1 use different encodings
+	 * Stream Table Entry S2TG is the same as TG0
+	 */
+	if (pt_feature(common, PT_FEAT_ARMV8_TTBR1)) {
+		switch (tgsz_lg2) {
+		case SZLG2_4K:
+			info->tg = 2;
+			break;
+		case SZLG2_16K:
+			info->tg = 1;
+			break;
+		case SZLG2_64K:
+			info->tg = 3;
+			break;
+		}
+	} else {
+		switch (tgsz_lg2) {
+		case SZLG2_4K:
+			info->tg = 0;
+			break;
+		case SZLG2_16K:
+			info->tg = 2;
+			break;
+		case SZLG2_64K:
+			info->tg = 1;
+			break;
+		}
+	}
+
+	info->ps = armv8pt_oasz_to_ps(common->max_oasz_lg2);
+	info->ds = pt_feature(common, PT_FEAT_ARMV8_LPA2);
+
+	if (pt_feature(common, PT_FEAT_DMA_INCOHERENT)) {
+		info->sh = ARMV8PT_SH_OS;
+		info->irgn = ARMV8PT_RGN_NC;
+		info->orgn = ARMV8PT_RGN_NC;
+	} else {
+		info->sh = ARMV8PT_SH_IS;
+		info->irgn = ARMV8PT_RGN_WBWA;
+		info->orgn = ARMV8PT_RGN_WBWA;
+	}
+
+	if (pt_feature(common, PT_FEAT_ARMV8_S2)) {
+		/*
+		 * STE S2SL0/S2SL2: Starting level in VTCR_EL2.SL0/SL2
+		 * encoding. Table from D24.2.210 SL0:
+		 *
+		 * 4K:  top_level  ARMLx    S2SL0  S2SL2
+		 *      1          ARML2    0      0
+		 *      2          ARML1    1      0
+		 *      3          ARML0    2      0
+		 *      4          ARMLn1   0      1      (FEAT_LPA2)
+		 *
+		 * 16K/64K:
+		 *      0          ARML3    0
+		 *      1          ARML2    1
+		 *      2          ARML1    2
+		 */
+		info->s2.sl2 = 0;
+		if (tgsz_lg2 == SZLG2_4K) {
+			if (top_range->top_level == ARMLn1) {
+				info->s2.sl0 = 0;
+				info->s2.sl2 = 1;
+			} else {
+				info->s2.sl0 = top_range->top_level - 1;
+			}
+		} else {
+			info->s2.sl0 = top_range->top_level;
+		}
+	} else {
+		info->s1.tbix = 0;
+		if (pt_feature(common, PT_FEAT_ARMV8_TTBR1)) {
+			info->s1.epd0 = 1;
+			info->s1.epd1 = 0;
+		} else {
+			info->s1.epd0 = 0;
+			info->s1.epd1 = 1;
+		}
+
+		/*
+		 * MAIR value for S1 page tables. Matches what io-pgtable-arm
+		 * used.
+		 */
+		info->s1.mair =
+			FIELD_PREP(ARMV8PT_MAIR_ITEM
+					   << (ARMV8PT_MAIR_ATTR_IDX_NC * 8),
+				   ARMV8PT_MAIR_ATTR_NC) |
+			FIELD_PREP(ARMV8PT_MAIR_ITEM
+					   << (ARMV8PT_MAIR_ATTR_IDX_CACHE * 8),
+				   ARMV8PT_MAIR_ATTR_WBRWA) |
+			FIELD_PREP(ARMV8PT_MAIR_ITEM
+					   << (ARMV8PT_MAIR_ATTR_IDX_DEV * 8),
+				   ARMV8PT_MAIR_ATTR_DEVICE) |
+			FIELD_PREP(
+				ARMV8PT_MAIR_ITEM
+					<< (ARMV8PT_MAIR_ATTR_IDX_INC_OCACHE *
+					    8),
+				ARMV8PT_MAIR_ATTR_INC_OWBRWA);
+	}
+}
+#define pt_iommu_fmt_hw_info armv8pt_iommu_fmt_hw_info
+
+#if defined(GENERIC_PT_KUNIT)
+static const struct pt_iommu_armv8_cfg armv8_kunit_fmt_cfgs[] = {
+	/* 4K granule */
+	[0] = { .tgsz_lg2 = 12,
+		.common.features = BIT(PT_FEAT_ARMV8_DBM),
+		.common.hw_max_oasz_lg2 = 48,
+		.common.hw_max_vasz_lg2 = 48 },
+	[1] = { .tgsz_lg2 = 12,
+		.common.features = BIT(PT_FEAT_ARMV8_S2),
+		.common.hw_max_oasz_lg2 = 48,
+		.common.hw_max_vasz_lg2 = 48 },
+	[2] = { .tgsz_lg2 = 12,
+		.common.features = BIT(PT_FEAT_ARMV8_TTBR1),
+		.common.hw_max_oasz_lg2 = 48,
+		.common.hw_max_vasz_lg2 = 48 },
+	/* 16K granule */
+	[3] = { .tgsz_lg2 = 14,
+		.common.features = BIT(PT_FEAT_ARMV8_DBM),
+		.common.hw_max_oasz_lg2 = 48,
+		.common.hw_max_vasz_lg2 = 48 },
+	/*
+	 * See R_DXBSH: 16K granule + 48-bit S2 is required to start at level 1
+	 * with 2 concatenated tables.
+	 */
+	[4] = { .tgsz_lg2 = 14,
+		.common.features = BIT(PT_FEAT_ARMV8_S2),
+		.common.hw_max_oasz_lg2 = 48,
+		.common.hw_max_vasz_lg2 = 48 },
+	[5] = { .tgsz_lg2 = 14,
+		.common.features = BIT(PT_FEAT_ARMV8_TTBR1),
+		.common.hw_max_oasz_lg2 = 48,
+		.common.hw_max_vasz_lg2 = 48 },
+	/* 64K granule */
+	[6] = { .tgsz_lg2 = 16,
+		.common.features = BIT(PT_FEAT_ARMV8_DBM),
+		.common.hw_max_oasz_lg2 = 48,
+		.common.hw_max_vasz_lg2 = 48 },
+	[7] = { .tgsz_lg2 = 16,
+		.common.features = BIT(PT_FEAT_ARMV8_S2),
+		.common.hw_max_oasz_lg2 = 48,
+		.common.hw_max_vasz_lg2 = 48 },
+	[8] = { .tgsz_lg2 = 16,
+		.common.features = BIT(PT_FEAT_ARMV8_TTBR1),
+		.common.hw_max_oasz_lg2 = 48,
+		.common.hw_max_vasz_lg2 = 48 },
+	/* S2 concatenated table configurations at smaller IPA sizes */
+	[9] = { .tgsz_lg2 = 12,
+		.common.features = BIT(PT_FEAT_ARMV8_S2),
+		.common.hw_max_oasz_lg2 = 40,
+		.common.hw_max_vasz_lg2 = 40 },
+	[10] = { .tgsz_lg2 = 12,
+		 .common.features = BIT(PT_FEAT_ARMV8_S2),
+		 .common.hw_max_oasz_lg2 = 42,
+		 .common.hw_max_vasz_lg2 = 42 },
+	[11] = { .tgsz_lg2 = 14,
+		 .common.features = BIT(PT_FEAT_ARMV8_S2),
+		 .common.hw_max_oasz_lg2 = 40,
+		 .common.hw_max_vasz_lg2 = 40 },
+};
+#define kunit_fmt_cfgs armv8_kunit_fmt_cfgs
+enum {
+	KUNIT_FMT_FEATURES = BIT(PT_FEAT_ARMV8_TTBR1) | BIT(PT_FEAT_ARMV8_S2) |
+			     BIT(PT_FEAT_ARMV8_DBM) | BIT(PT_FEAT_ARMV8_S2FWB) |
+			     BIT(PT_FEAT_DYNAMIC_TOP) | BIT(PT_FEAT_ARMV8_LPA) |
+			     BIT(PT_FEAT_ARMV8_LPA2) | BIT(PT_FEAT_ARMV8_LVA)
+};
+#endif
+#endif
diff --git a/drivers/iommu/generic_pt/fmt/iommu_armv8.c b/drivers/iommu/generic_pt/fmt/iommu_armv8.c
new file mode 100644
index 00000000000000..95878105d35e18
--- /dev/null
+++ b/drivers/iommu/generic_pt/fmt/iommu_armv8.c
@@ -0,0 +1,13 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2024-2026, NVIDIA CORPORATION & AFFILIATES
+ */
+#define PT_FMT armv8
+#define PT_SUPPORTED_FEATURES                                  \
+	(BIT(PT_FEAT_DMA_INCOHERENT) | BIT(PT_FEAT_ARMV8_S2) | \
+	 BIT(PT_FEAT_ARMV8_LVA) |                              \
+	 BIT(PT_FEAT_ARMV8_DBM) | BIT(PT_FEAT_ARMV8_S2FWB) |  \
+	 BIT(PT_FEAT_DETAILED_GATHER))
+#define PT_FORCE_ENABLED_FEATURES BIT(PT_FEAT_DETAILED_GATHER)
+
+#include "iommu_template.h"
diff --git a/include/linux/generic_pt/iommu.h b/include/linux/generic_pt/iommu.h
index dd0edd02a48a24..20d6ca9a9d39e6 100644
--- a/include/linux/generic_pt/iommu.h
+++ b/include/linux/generic_pt/iommu.h
@@ -309,6 +309,78 @@ IOMMU_FORMAT(amdv1, amdpt);
 struct pt_iommu_amdv1_mock_hw_info;
 IOMMU_PROTOTYPES(amdv1_mock);
 
+struct pt_iommu_armv8_cfg {
+	struct pt_iommu_cfg common;
+	/* Base translation granule for the page table */
+	u8 tgsz_lg2;
+};
+
+struct pt_iommu_armv8_hw_info {
+	/* translation table base: ttb0, ttb1, s2ttb */
+	u64 ttb;
+	/* physical address size: ips, s2ps*/
+	u8 ps;
+	/* input size: t0sz, t1sz, s2t0sz */
+	u8 tsz;
+	/* translation granule: tg1, tg0, s2tg */
+	u8 tg;
+	/* 52-bit OA / LPA2 PTE encoding enable: ds, s2ds */
+	u8 ds;
+	/* endian: endi, s2endi */
+	u8 endi;
+	/* shareability: sh0, s2sh0 */
+	u8 sh;
+	/* inner cacheability: irgn0, s2ir0 */
+	u8 irgn;
+	/* outer cacheability: orgn0, s2or0 */
+	u8 orgn;
+
+	union {
+		struct {
+			/* top byte ignore */
+			u8 tbix;
+			/* translation table walk disable */
+			u8 epd0;
+			u8 epd1;
+			u32 mair;
+		} s1;
+		struct {
+			/* start level */
+			u8 sl0;
+			u8 sl2;
+		} s2;
+	};
+};
+
+IOMMU_FORMAT(armv8, armpt);
+
+/**
+ * pt_iommu_armv8_choose_granule_lg2sz - Select the best granule size
+ * @hw_granules: Bitmask of hardware supported granule sizes
+ *
+ * Used by IOMMU drivers to automatically select the best granule size from
+ * their HW support. iommu_domain works best when the granule is the same as
+ * PAGE_SIZE, it works well if it is less than PAGE_SIZE and greater is not well
+ * supported.
+ *
+ * Return: 0 if none of the HW values are supportable.
+ */
+static inline unsigned int pt_iommu_armv8_choose_granule_lg2sz(u64 hw_granules)
+{
+	/* pt_iommu_armv8 always supports these */
+	hw_granules &= SZ_4K | SZ_16K | SZ_64K;
+	if (!hw_granules)
+		return 0;
+
+	if (hw_granules & PAGE_SIZE)
+		return PAGE_SHIFT;
+
+	if (hw_granules % PAGE_SIZE)
+		return ilog2(rounddown_pow_of_two(hw_granules % PAGE_SIZE));
+
+	return __ffs(hw_granules);
+}
+
 struct pt_iommu_vtdss_cfg {
 	struct pt_iommu_cfg common;
 	/* 4 is a 57 bit 5 level table */
-- 
2.43.0

