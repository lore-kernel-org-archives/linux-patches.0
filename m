Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2083.outbound.protection.outlook.com [40.107.236.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91C6B1E230D
	for <patches@lists.linux.dev>; Wed,  9 Oct 2024 16:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728491019; cv=fail; b=rOSXM0kkJB/RberHZKrey/1KuFtDyxgrkw83j0HriaHx7fa4cbI1rZRK3dZNO4f3hl3lNhWwsD1Ekw5lUptljHMySt5j3XuTpqlieH2inJ1s6PSiROTaleQW3geSEBPN0+LgfxfgL7NsRsQyZfaFvurWOqN/qLJO13lpw3/c+U8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728491019; c=relaxed/simple;
	bh=V2wjOx6gOKr155TZ6M3kkJiXVarvl9lBIltKidwRr4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=aRXBYEPtm1zHSFraFMZXzjTMiLaIpX1t4IU8veGM0gIk0klxXZlQCjS4Mf0jS+bttUdmomFlr1KToJoPvj2cQ/x82/fM0LktIGbHQzO+7G+fYs/0yOF9D5C6cVQAASlMPyX9IkHYnFDU0ueJgfFG2fONPOcBJgpgB03mIdT/iG4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WP59PQSV; arc=fail smtp.client-ip=40.107.236.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WP59PQSV"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q3ffQ8wN5NCwafWu0M3y5b8uPNOUYkYwcYukO9qzUAC9C1+m0QnoIpfErdHSyBNGLPjJ5WbEG7b3/aqYPXOk/0iK8ywO7tw2au5SjnuRCHIXyuLM+WGQeJ/Kw4URH8N3/aLeodTp9W96qETLdXOlQuwzznGt6ZoeD581zfDYtFQM3i+AdSQBn31piYcgcHmfS5fXnLD+aIeZMjldllKoaMnftZNeudaBUFRnYKHUsWzSH4gwhKpX0hNZskux5kPxlXrMNwyCBfBUdKUKbDsF5/ZwwepElNYoFr8Uhu6+MPcBeWsAGV7IxXyCrx/loNF5DDqmHry61uyauKqFFp2xUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AtyZeUfVqQGF+J92e/Ex+NfEnCO3YPW4rt3u8dymwIs=;
 b=lTw/3JxFls90gOSCxhhQdjLB/u9Y2WXoFTsnb9fqwGSnOQFSB42PFJdqu7g2eK8lt/12U/SsWFux1kLs+/GHHvTj78SBXoevKzJ1VF3bscSEURLlwxSKujrWTroquK3HQqptof+rO2eebJNX9DYt6LaIF5sfycPYd9Dlfq2bS6UjGCDMHXRh1w2CSmvKMchmj8j9c92Qm7J9eYIEMHF3gbk5BW1ZXJSlCvQGiSe8hT2b8E6wq58bZUB5IT5L2pGziOHvpWuqIlQE59ZfETXVKmQhm302uBxVKBC4BjGIsqKy2ndESAw9XHCtMFmFc+d84EWWnK0DuWTCXQNgXd8JBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AtyZeUfVqQGF+J92e/Ex+NfEnCO3YPW4rt3u8dymwIs=;
 b=WP59PQSVodu260F+XMV+x2ZpSxJW5tug+aRRPJlQUfOc+Y3OdkvSNrZH8fvNhRMu5FVPdjF3LopeI/uXEYCEMbfZcgjnbH52TPIq9vAGl10RPS8CS9Y/DZPlSs51/OoecXDk11NZcUnyuk3aIBWR13rc6AuhqrCb83Vt0OP0gBgmA57nHRksBhgGZtA+GoJMTmAX/Tho/mKd0oq4R8f8eArW3+Qs1qN1MkieYEOfG9ZRh3ZuWyzFrsyD3lKOG+DXIFIJmWFUP5C6D/9PUXclAYGDJwhTN+WpCQUUxMF2PVRNJ0mHTF5QENRTZpmMw0NmjYDxXEeakYxMYwDSrJ17ew==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DS0PR12MB8768.namprd12.prod.outlook.com (2603:10b6:8:14f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.16; Wed, 9 Oct
 2024 16:23:26 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8048.013; Wed, 9 Oct 2024
 16:23:26 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: acpica-devel@lists.linux.dev,
	Hanjun Guo <guohanjun@huawei.com>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org,
	Len Brown <lenb@kernel.org>,
	linux-acpi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Robert Moore <robert.moore@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v3 8/9] iommu/arm-smmu-v3: Support IOMMU_DOMAIN_NESTED
Date: Wed,  9 Oct 2024 13:23:14 -0300
Message-ID: <8-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>
In-Reply-To: <0-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR1501CA0028.namprd15.prod.outlook.com
 (2603:10b6:207:17::41) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DS0PR12MB8768:EE_
X-MS-Office365-Filtering-Correlation-Id: 5169e50c-ac4b-4924-1739-08dce87eaf90
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zAaMFOlmLGEZnv4vT9ewAsI5Izd3zAu7CeMfJgwwiY2e0IncwA6POHLZFh5w?=
 =?us-ascii?Q?l8qOqZzYbAw9P6dz29WowuhpDOoM2TA752CGfhzHWjekrwirGaunbqC1nXd+?=
 =?us-ascii?Q?B4QnYW2tY5Srtr15BUVT8E1qWch+1gbNU+zUu1YS0k0fcxlv5X1byF3Kp8A4?=
 =?us-ascii?Q?fU7pCh2LbF19woIPHhcPesyL63nmyOjKIUGLGhnxR04YjzkVZydRSrv/8bXU?=
 =?us-ascii?Q?wU4s3lzKc5o8v1NXXXvRpyzUfLgYaKivDZLCjS0bYAeFs6bjiWvGIuDRSGv1?=
 =?us-ascii?Q?qWfB5HnrFWChApAY27NcS2lGdudBYCir9XGCPSUUNYtLdeU392UghCI7UtoP?=
 =?us-ascii?Q?jkfUneeNcaqrqRQbqRZG1MJNjGz8mHf4VO2BugRiM53ApxVjbxF2d+2F1SfU?=
 =?us-ascii?Q?3tjx8e4a0mxGAmB8HBO9e++GqjKXggfVe/dMilncOVP/v4fIljuAee1UmZ0L?=
 =?us-ascii?Q?3qoZi48XKX0DMJrw0b/zw57/AXBSS0q2kaAsRKBu+V/3nWVo9nnbjwxxrFp0?=
 =?us-ascii?Q?gaMArRCHt3mgalhMK+NCglVN5YLzLNxERruBfEuKVJ8Zfz9tQ7CIa6fNCg9g?=
 =?us-ascii?Q?430iGRs4O/nRmF83Nn350xxgPM00p2a+L3RpleXbYGO63n/+B3ryzqCJIX8h?=
 =?us-ascii?Q?KTvJp3PskSW1RZPyVBKjDp819kF+1hF8ZXLu/XmbqlEGEYsl2g1bT3wGUvNy?=
 =?us-ascii?Q?LLxnHTnYeU9lU19EcA0350nf6/clL+kJr2bZNKVbIlAlIZTZnqZlk3tY4Ujc?=
 =?us-ascii?Q?loutum5wzujg+XcAfrc8kWG//ADVvZhMYQ7JCyUUVmiWEbu+dZTPARwZfPy5?=
 =?us-ascii?Q?YheQJtAtIQ608S668yed+Awx4eqNSqxR/Z0DzsiP20hjft3fAbxDfUJuKPpl?=
 =?us-ascii?Q?siYYutM0Y0cqvnUDlE8j7V5ufNCgj58uhY8jS0DauByhbwGswVVM8sS2YmW6?=
 =?us-ascii?Q?b4DG4LZdHEX/pEpx2a/auTiqKL7iWeANLTTRp1EQqC2IK/M59o4hcreigtWt?=
 =?us-ascii?Q?ZHAVuqDWt7ddFBWsRdgIQ9e0Um9M9IFJHKCeoLJV8CjzItyfOZv/fpEXQSeR?=
 =?us-ascii?Q?ak4N2hE7ss/QdjlUdj+bsWJ3Mex+8H4NnnAmqx6CxW9tkc8VvmA5f73YRdkc?=
 =?us-ascii?Q?drZCvc6QOBKMPqoEsurB1Fu3yNHGQG6djtUi16hOjoOM1u7DU4vatG/UXXBz?=
 =?us-ascii?Q?BDzOIFDdVNAwyaVUhzrlKLv3ZyZklGScdTWNpA7tBZae8KGNpHp4V3QzkgLL?=
 =?us-ascii?Q?wv3nMUYTcHdbZgADcR4uJTkSJuSm1utNrStY1uxX9Xm3U9KnYxQf40LcHFkG?=
 =?us-ascii?Q?hPpHKrLnv6Os1thHdMFxCJd4?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2w3m2xJsaUqy3A6iiIm2U1LqUqcO48UG07y/1UzV4Pwz0mJwK+5pvoIJIYtV?=
 =?us-ascii?Q?uG4ClzU6skd9RxMorDjt/+Ec0p4tT3GJX25R/5BciF6z5xU4BxtK2e4oKtee?=
 =?us-ascii?Q?Z94GNIKXVfuS/i+5q0M05ob2BstfeU1MggRV8P5LG8vNIsWMkU2P+QiPybGY?=
 =?us-ascii?Q?lgg7A+N8e/gk62awnYOYzlyWV+hynBt+vhKbCG9dwZ1DhqYNDkzpjNAEJooA?=
 =?us-ascii?Q?9H6XC59OjxspGSIbo9TdQBagXJ/n2TLfk8H1a//+naXe1cOM0AXBiQ4ZWWnT?=
 =?us-ascii?Q?Ywm5MfDkukHJcF6YgGWx20M6nJBsIKQr4rOejiW0uWZYpyZzlJu4mOvhZtUY?=
 =?us-ascii?Q?fKeYMw3WrVGWTjrK6rJ6Hu1tDsaDPd2P8+HdGzcco6lj9WR9mzulpv+bVhpX?=
 =?us-ascii?Q?tufBXq7I/Wb9QR1Zn6kPco+K0BYIVdwUhPgCCRFdKMnn8R2MDDBVVmXPsulg?=
 =?us-ascii?Q?YHpX1a9jmn4R4fmPNjskTaIgKTPRfR/NPfbbScvF9iNK/JL+brItkvCd3v8v?=
 =?us-ascii?Q?0bCW3nW4mJIXREnR60MoaRLEkD5UrcMtyChfrIP4gWtGoPq+jB5MOIcVSiOU?=
 =?us-ascii?Q?XErTQR2CSz/1kPeHy3QwwSUZSxrfiW+Xyyp6TPqxq7xNbMSYpwNusYi3E0hn?=
 =?us-ascii?Q?GmZM4O/KJ+cKYTxzu8z+jidTEDdvqMT/15KIKWt/Z/y1BDdgRZ6/t9tiIZQ7?=
 =?us-ascii?Q?dTK8D+iuFIuCNREHSjU6llBo5gjGlS+SUxyUqw9xb7MnjO2SKvtUB6YmexEH?=
 =?us-ascii?Q?uUYK0O7hxdobDFag5f08XmKstjOwmduwiMp98edrA9fc0vh+4CvkrFBN1Y5A?=
 =?us-ascii?Q?sEv8v6xNpJFg8rFx4MAiOntfBVFCRwaEaluHJzQeQFKsV4LMeH2oqrEQ+jwa?=
 =?us-ascii?Q?nNovaWC/JyviOHwi8vCsutNEuEN60ZcQSxaVZ4RFlopTndBxprq+OAJNhql0?=
 =?us-ascii?Q?C7eowaEPH51+NAqvbFg5OV4CRXSrrLAVR5NR6UO6k2PetJzjiYcBBGgsreDw?=
 =?us-ascii?Q?wA0K+NB2jEG884bRcFBodHEqfgq4a1cQmScebhG3wOxJzgQXJPhzQ6HfIJa8?=
 =?us-ascii?Q?2/2YSeLIRF5g7rg2mAwt0MTa1AF6UGMdGvWpbNYs0a62TjpgISkZGLwu6YhK?=
 =?us-ascii?Q?3SMUyPjhouasaT5Ov/1r8Gu5+uq0nAVL64rI5Ys4jlddrzky9YHyaJ9Xfemo?=
 =?us-ascii?Q?N9P5JJk7zUkZwRSj3eVrv74Fmz2CbQDzbPQpRjN5uaenQ2vEAfPKN4qtKvNW?=
 =?us-ascii?Q?okzzdhvxRe7VL1C5Acls+hBCeqpa82tiZphuoLClxOsIYUtjclpl2hy5hFhr?=
 =?us-ascii?Q?kbngBotZIDLfCmIhIMltN/kv3ocTmTceEBMoWpdDiA3q/kxJO/2GtyZN/3fc?=
 =?us-ascii?Q?tNNygGKgn1kkA18U+qe9EUlzfxpxPt97/FbAVUSp+mTHxSOi+anKsVdLX0tw?=
 =?us-ascii?Q?/nTeM424eWvNd0qu8ZbMZuVRlTGItrDSslUNuEC5ofQe/QJyA1dNxR7i5eaF?=
 =?us-ascii?Q?dS8/mqS9vfq2/hKAvkFwesxqpbJ7feeixtEcNPKJ+WqfprAizAz4r6wlXFEM?=
 =?us-ascii?Q?rZp5u849/sd5CeDdKtQ=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5169e50c-ac4b-4924-1739-08dce87eaf90
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2024 16:23:19.1190
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5MNiTylnS3cQBCB+BqExS24Dl58cU14txt43okQ6KOjbrvAtZo55MItJ5UZgFYxV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8768

For SMMUv3 a IOMMU_DOMAIN_NESTED is composed of a S2 iommu_domain acting
as the parent and a user provided STE fragment that defines the CD table
and related data with addresses translated by the S2 iommu_domain.

The kernel only permits userspace to control certain allowed bits of the
STE that are safe for user/guest control.

IOTLB maintenance is a bit subtle here, the S1 implicitly includes the S2
translation, but there is no way of knowing which S1 entries refer to a
range of S2.

For the IOTLB we follow ARM's guidance and issue a CMDQ_OP_TLBI_NH_ALL to
flush all ASIDs from the VMID after flushing the S2 on any change to the
S2.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../arm/arm-smmu-v3/arm-smmu-v3-iommufd.c     | 172 ++++++++++++++++++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  25 ++-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  37 ++++
 include/uapi/linux/iommufd.h                  |  20 ++
 4 files changed, 250 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
index 3d2671031c9bb5..a9aa7514e65ce4 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
@@ -29,3 +29,175 @@ void *arm_smmu_hw_info(struct device *dev, u32 *length, u32 *type)
 
 	return info;
 }
+
+static void arm_smmu_make_nested_cd_table_ste(
+	struct arm_smmu_ste *target, struct arm_smmu_master *master,
+	struct arm_smmu_nested_domain *nested_domain, bool ats_enabled)
+{
+	arm_smmu_make_s2_domain_ste(target, master, nested_domain->s2_parent,
+				    ats_enabled);
+
+	target->data[0] = cpu_to_le64(STRTAB_STE_0_V |
+				      FIELD_PREP(STRTAB_STE_0_CFG,
+						 STRTAB_STE_0_CFG_NESTED));
+	target->data[0] |= nested_domain->ste[0] &
+			   ~cpu_to_le64(STRTAB_STE_0_CFG);
+	target->data[1] |= nested_domain->ste[1];
+}
+
+/*
+ * Create a physical STE from the virtual STE that userspace provided when it
+ * created the nested domain. Using the vSTE userspace can request:
+ * - Non-valid STE
+ * - Abort STE
+ * - Bypass STE (install the S2, no CD table)
+ * - CD table STE (install the S2 and the userspace CD table)
+ */
+static void arm_smmu_make_nested_domain_ste(
+	struct arm_smmu_ste *target, struct arm_smmu_master *master,
+	struct arm_smmu_nested_domain *nested_domain, bool ats_enabled)
+{
+	unsigned int cfg =
+		FIELD_GET(STRTAB_STE_0_CFG, le64_to_cpu(nested_domain->ste[0]));
+
+	/*
+	 * Userspace can request a non-valid STE through the nesting interface.
+	 * We relay that into an abort physical STE with the intention that
+	 * C_BAD_STE for this SID can be generated to userspace.
+	 */
+	if (!(nested_domain->ste[0] & cpu_to_le64(STRTAB_STE_0_V)))
+		cfg = STRTAB_STE_0_CFG_ABORT;
+
+	switch (cfg) {
+	case STRTAB_STE_0_CFG_S1_TRANS:
+		arm_smmu_make_nested_cd_table_ste(target, master, nested_domain,
+						  ats_enabled);
+		break;
+	case STRTAB_STE_0_CFG_BYPASS:
+		arm_smmu_make_s2_domain_ste(
+			target, master, nested_domain->s2_parent, ats_enabled);
+		break;
+	case STRTAB_STE_0_CFG_ABORT:
+	default:
+		arm_smmu_make_abort_ste(target);
+		break;
+	}
+}
+
+static int arm_smmu_attach_dev_nested(struct iommu_domain *domain,
+				      struct device *dev)
+{
+	struct arm_smmu_nested_domain *nested_domain =
+		to_smmu_nested_domain(domain);
+	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
+	struct arm_smmu_attach_state state = {
+		.master = master,
+		.old_domain = iommu_get_domain_for_dev(dev),
+		.ssid = IOMMU_NO_PASID,
+		/* Currently invalidation of ATC is not supported */
+		.disable_ats = true,
+	};
+	struct arm_smmu_ste ste;
+	int ret;
+
+	if (nested_domain->s2_parent->smmu != master->smmu)
+		return -EINVAL;
+	if (arm_smmu_ssids_in_use(&master->cd_table))
+		return -EBUSY;
+
+	mutex_lock(&arm_smmu_asid_lock);
+	ret = arm_smmu_attach_prepare(&state, domain);
+	if (ret) {
+		mutex_unlock(&arm_smmu_asid_lock);
+		return ret;
+	}
+
+	arm_smmu_make_nested_domain_ste(&ste, master, nested_domain,
+					state.ats_enabled);
+	arm_smmu_install_ste_for_dev(master, &ste);
+	arm_smmu_attach_commit(&state);
+	mutex_unlock(&arm_smmu_asid_lock);
+	return 0;
+}
+
+static void arm_smmu_domain_nested_free(struct iommu_domain *domain)
+{
+	kfree(to_smmu_nested_domain(domain));
+}
+
+static const struct iommu_domain_ops arm_smmu_nested_ops = {
+	.attach_dev = arm_smmu_attach_dev_nested,
+	.free = arm_smmu_domain_nested_free,
+};
+
+static int arm_smmu_validate_vste(struct iommu_hwpt_arm_smmuv3 *arg)
+{
+	unsigned int cfg;
+
+	if (!(arg->ste[0] & cpu_to_le64(STRTAB_STE_0_V))) {
+		memset(arg->ste, 0, sizeof(arg->ste));
+		return 0;
+	}
+
+	/* EIO is reserved for invalid STE data. */
+	if ((arg->ste[0] & ~STRTAB_STE_0_NESTING_ALLOWED) ||
+	    (arg->ste[1] & ~STRTAB_STE_1_NESTING_ALLOWED))
+		return -EIO;
+
+	cfg = FIELD_GET(STRTAB_STE_0_CFG, le64_to_cpu(arg->ste[0]));
+	if (cfg != STRTAB_STE_0_CFG_ABORT && cfg != STRTAB_STE_0_CFG_BYPASS &&
+	    cfg != STRTAB_STE_0_CFG_S1_TRANS)
+		return -EIO;
+	return 0;
+}
+
+struct iommu_domain *
+arm_smmu_domain_alloc_nesting(struct device *dev, u32 flags,
+			      struct iommu_domain *parent,
+			      const struct iommu_user_data *user_data)
+{
+	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
+	struct arm_smmu_nested_domain *nested_domain;
+	struct arm_smmu_domain *smmu_parent;
+	struct iommu_hwpt_arm_smmuv3 arg;
+	int ret;
+
+	if (flags || !(master->smmu->features & ARM_SMMU_FEAT_NESTING))
+		return ERR_PTR(-EOPNOTSUPP);
+
+	/*
+	 * Must support some way to prevent the VM from bypassing the cache
+	 * because VFIO currently does not do any cache maintenance.
+	 */
+	if (!arm_smmu_master_canwbs(master))
+		return ERR_PTR(-EOPNOTSUPP);
+
+	/*
+	 * The core code checks that parent was created with
+	 * IOMMU_HWPT_ALLOC_NEST_PARENT
+	 */
+	smmu_parent = to_smmu_domain(parent);
+	if (smmu_parent->smmu != master->smmu)
+		return ERR_PTR(-EINVAL);
+
+	ret = iommu_copy_struct_from_user(&arg, user_data,
+					  IOMMU_HWPT_DATA_ARM_SMMUV3, ste);
+	if (ret)
+		return ERR_PTR(ret);
+
+	ret = arm_smmu_validate_vste(&arg);
+	if (ret)
+		return ERR_PTR(ret);
+
+	nested_domain = kzalloc(sizeof(*nested_domain), GFP_KERNEL_ACCOUNT);
+	if (!nested_domain)
+		return ERR_PTR(-ENOMEM);
+
+	nested_domain->domain.type = IOMMU_DOMAIN_NESTED;
+	nested_domain->domain.ops = &arm_smmu_nested_ops;
+	nested_domain->s2_parent = smmu_parent;
+	nested_domain->ste[0] = arg.ste[0];
+	nested_domain->ste[1] = arg.ste[1] & ~cpu_to_le64(STRTAB_STE_1_EATS);
+
+	return &nested_domain->domain;
+}
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index b4b03206afbf48..eb401a4adfedc8 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -295,6 +295,7 @@ static int arm_smmu_cmdq_build_cmd(u64 *cmd, struct arm_smmu_cmdq_ent *ent)
 	case CMDQ_OP_TLBI_NH_ASID:
 		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_ASID, ent->tlbi.asid);
 		fallthrough;
+	case CMDQ_OP_TLBI_NH_ALL:
 	case CMDQ_OP_TLBI_S12_VMALL:
 		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_VMID, ent->tlbi.vmid);
 		break;
@@ -2230,6 +2231,15 @@ static void arm_smmu_tlb_inv_range_domain(unsigned long iova, size_t size,
 	}
 	__arm_smmu_tlb_inv_range(&cmd, iova, size, granule, smmu_domain);
 
+	if (smmu_domain->nest_parent) {
+		/*
+		 * When the S2 domain changes all the nested S1 ASIDs have to be
+		 * flushed too.
+		 */
+		cmd.opcode = CMDQ_OP_TLBI_NH_ALL;
+		arm_smmu_cmdq_issue_cmd_with_sync(smmu_domain->smmu, &cmd);
+	}
+
 	/*
 	 * Unfortunately, this can't be leaf-only since we may have
 	 * zapped an entire table.
@@ -2614,8 +2624,7 @@ static void arm_smmu_disable_pasid(struct arm_smmu_master *master)
 
 static struct arm_smmu_master_domain *
 arm_smmu_find_master_domain(struct arm_smmu_domain *smmu_domain,
-			    struct arm_smmu_master *master,
-			    ioasid_t ssid)
+			    struct arm_smmu_master *master, ioasid_t ssid)
 {
 	struct arm_smmu_master_domain *master_domain;
 
@@ -2644,6 +2653,8 @@ to_smmu_domain_devices(struct iommu_domain *domain)
 	if ((domain->type & __IOMMU_DOMAIN_PAGING) ||
 	    domain->type == IOMMU_DOMAIN_SVA)
 		return to_smmu_domain(domain);
+	if (domain->type == IOMMU_DOMAIN_NESTED)
+		return to_smmu_nested_domain(domain)->s2_parent;
 	return NULL;
 }
 
@@ -2716,7 +2727,8 @@ int arm_smmu_attach_prepare(struct arm_smmu_attach_state *state,
 		 * enabled if we have arm_smmu_domain, those always have page
 		 * tables.
 		 */
-		state->ats_enabled = arm_smmu_ats_supported(master);
+		state->ats_enabled = !state->disable_ats &&
+				     arm_smmu_ats_supported(master);
 	}
 
 	if (smmu_domain) {
@@ -3107,9 +3119,13 @@ arm_smmu_domain_alloc_user(struct device *dev, u32 flags,
 	struct arm_smmu_domain *smmu_domain;
 	int ret;
 
+	if (parent)
+		return arm_smmu_domain_alloc_nesting(dev, flags, parent,
+						     user_data);
+
 	if (flags & ~PAGING_FLAGS)
 		return ERR_PTR(-EOPNOTSUPP);
-	if (parent || user_data)
+	if (user_data)
 		return ERR_PTR(-EOPNOTSUPP);
 
 	smmu_domain = arm_smmu_domain_alloc();
@@ -3122,6 +3138,7 @@ arm_smmu_domain_alloc_user(struct device *dev, u32 flags,
 			goto err_free;
 		}
 		smmu_domain->stage = ARM_SMMU_DOMAIN_S2;
+		smmu_domain->nest_parent = true;
 	}
 
 	smmu_domain->domain.type = IOMMU_DOMAIN_UNMANAGED;
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index c9e5290e995a64..b5dbf5acbfc4db 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -243,6 +243,7 @@ static inline u32 arm_smmu_strtab_l2_idx(u32 sid)
 #define STRTAB_STE_0_CFG_BYPASS		4
 #define STRTAB_STE_0_CFG_S1_TRANS	5
 #define STRTAB_STE_0_CFG_S2_TRANS	6
+#define STRTAB_STE_0_CFG_NESTED		7
 
 #define STRTAB_STE_0_S1FMT		GENMASK_ULL(5, 4)
 #define STRTAB_STE_0_S1FMT_LINEAR	0
@@ -294,6 +295,15 @@ static inline u32 arm_smmu_strtab_l2_idx(u32 sid)
 
 #define STRTAB_STE_3_S2TTB_MASK		GENMASK_ULL(51, 4)
 
+/* These bits can be controlled by userspace for STRTAB_STE_0_CFG_NESTED */
+#define STRTAB_STE_0_NESTING_ALLOWED                                         \
+	cpu_to_le64(STRTAB_STE_0_V | STRTAB_STE_0_CFG | STRTAB_STE_0_S1FMT | \
+		    STRTAB_STE_0_S1CTXPTR_MASK | STRTAB_STE_0_S1CDMAX)
+#define STRTAB_STE_1_NESTING_ALLOWED                            \
+	cpu_to_le64(STRTAB_STE_1_S1DSS | STRTAB_STE_1_S1CIR |   \
+		    STRTAB_STE_1_S1COR | STRTAB_STE_1_S1CSH |   \
+		    STRTAB_STE_1_S1STALLD)
+
 /*
  * Context descriptors.
  *
@@ -513,6 +523,7 @@ struct arm_smmu_cmdq_ent {
 			};
 		} cfgi;
 
+		#define CMDQ_OP_TLBI_NH_ALL     0x10
 		#define CMDQ_OP_TLBI_NH_ASID	0x11
 		#define CMDQ_OP_TLBI_NH_VA	0x12
 		#define CMDQ_OP_TLBI_EL2_ALL	0x20
@@ -814,10 +825,18 @@ struct arm_smmu_domain {
 	struct list_head		devices;
 	spinlock_t			devices_lock;
 	bool				enforce_cache_coherency : 1;
+	bool				nest_parent : 1;
 
 	struct mmu_notifier		mmu_notifier;
 };
 
+struct arm_smmu_nested_domain {
+	struct iommu_domain domain;
+	struct arm_smmu_domain *s2_parent;
+
+	__le64 ste[2];
+};
+
 /* The following are exposed for testing purposes. */
 struct arm_smmu_entry_writer_ops;
 struct arm_smmu_entry_writer {
@@ -862,6 +881,12 @@ static inline struct arm_smmu_domain *to_smmu_domain(struct iommu_domain *dom)
 	return container_of(dom, struct arm_smmu_domain, domain);
 }
 
+static inline struct arm_smmu_nested_domain *
+to_smmu_nested_domain(struct iommu_domain *dom)
+{
+	return container_of(dom, struct arm_smmu_nested_domain, domain);
+}
+
 extern struct xarray arm_smmu_asid_xa;
 extern struct mutex arm_smmu_asid_lock;
 
@@ -908,6 +933,7 @@ struct arm_smmu_attach_state {
 	struct iommu_domain *old_domain;
 	struct arm_smmu_master *master;
 	bool cd_needs_ats;
+	bool disable_ats;
 	ioasid_t ssid;
 	/* Resulting state */
 	bool ats_enabled;
@@ -978,8 +1004,19 @@ tegra241_cmdqv_probe(struct arm_smmu_device *smmu)
 
 #if IS_ENABLED(CONFIG_ARM_SMMU_V3_IOMMUFD)
 void *arm_smmu_hw_info(struct device *dev, u32 *length, u32 *type);
+struct iommu_domain *
+arm_smmu_domain_alloc_nesting(struct device *dev, u32 flags,
+			      struct iommu_domain *parent,
+			      const struct iommu_user_data *user_data);
 #else
 #define arm_smmu_hw_info NULL
+static inline struct iommu_domain *
+arm_smmu_domain_alloc_nesting(struct device *dev, u32 flags,
+			      struct iommu_domain *parent,
+			      const struct iommu_user_data *user_data)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
 #endif /* CONFIG_ARM_SMMU_V3_IOMMUFD */
 
 #endif /* _ARM_SMMU_V3_H */
diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
index b5c94fecb94ca5..cd4920886ad05e 100644
--- a/include/uapi/linux/iommufd.h
+++ b/include/uapi/linux/iommufd.h
@@ -394,14 +394,34 @@ struct iommu_hwpt_vtd_s1 {
 	__u32 __reserved;
 };
 
+/**
+ * struct iommu_hwpt_arm_smmuv3 - ARM SMMUv3 Context Descriptor Table info
+ *                                (IOMMU_HWPT_DATA_ARM_SMMUV3)
+ *
+ * @ste: The first two double words of the user space Stream Table Entry for
+ *       a user stage-1 Context Descriptor Table. Must be little-endian.
+ *       Allowed fields: (Refer to "5.2 Stream Table Entry" in SMMUv3 HW Spec)
+ *       - word-0: V, Cfg, S1Fmt, S1ContextPtr, S1CDMax
+ *       - word-1: S1DSS, S1CIR, S1COR, S1CSH, S1STALLD
+ *
+ * -EIO will be returned if @ste is not legal or contains any non-allowed field.
+ * Cfg can be used to select a S1, Bypass or Abort configuration. A Bypass
+ * nested domain will translate the same as the nesting parent.
+ */
+struct iommu_hwpt_arm_smmuv3 {
+	__aligned_le64 ste[2];
+};
+
 /**
  * enum iommu_hwpt_data_type - IOMMU HWPT Data Type
  * @IOMMU_HWPT_DATA_NONE: no data
  * @IOMMU_HWPT_DATA_VTD_S1: Intel VT-d stage-1 page table
+ * @IOMMU_HWPT_DATA_ARM_SMMUV3: ARM SMMUv3 Context Descriptor Table
  */
 enum iommu_hwpt_data_type {
 	IOMMU_HWPT_DATA_NONE = 0,
 	IOMMU_HWPT_DATA_VTD_S1 = 1,
+	IOMMU_HWPT_DATA_ARM_SMMUV3 = 2,
 };
 
 /**
-- 
2.46.2

