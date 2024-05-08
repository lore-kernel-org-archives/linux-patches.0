Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2063.outbound.protection.outlook.com [40.107.93.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5364012D754;
	Wed,  8 May 2024 18:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715194667; cv=fail; b=fHSIQ01b9QZVvNxmYsZ6GRwgZCLaNmDVAIU6yyqYcGOAKHrP2ICTyn8MFIAKVfrG5pCW/N3A2YXfDY+L7zlj6jCL1mLwATnPq13rY1q4+bT7/Q6xvNdhufGyh50Q/tao8P/gcuwcvdVJQQeZ2ZRcR+++4VNQBR3esIQd6KOE4bc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715194667; c=relaxed/simple;
	bh=/evl8yk1+Z1ErJKWSuG7VUGntP3parGLQrhGGewgj1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=axJug7khCeeiyUxyrIt9SSnFS/nqxg6dHnyH5kNaBV5VuiUQL1tdp49cTYA1CldCPjExmrp2e/80TK/Zrd2M3QYvzk8MXFiCvBoUaosHDJtQf+tXlPE0FFDFpuSI4iDXWwdlNYejrnaph4/PjZYRyELXQZTsPl6CBTpcTU3zA7Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Yj2F9ciD; arc=fail smtp.client-ip=40.107.93.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Yj2F9ciD"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kMidHUhtRzeJ/t7mCm/b8xyhLofsMviwCIzas3SGIbNihQJKJ/lFX3LBv+hroaeXMTOaOnGrXEOxVXf3JmzmK+vOmB73VUFCDn+7vuDc4nveCaUdHYkc7BwyIZqfDtZzFu59hdi4aGms9XT/L+UCZa7hw+bYkHD3ejPThK/EJOJnXM0zvZKtoPg7uisZl4e9gUDBmtlSIoX34EP9KNfDbXvGpPW4TuSDaorC/ABo1Jf1fbgVdMBn+xRiJHc3Zh8iZPlkz0aWoZoxmJp6IH+mi87DTzhvkdvp/MMokc9Ie4cn2f1Asrz6u2BycyYWs4h6O5vglMH3jUcwjOJOP0mhqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7Yd2J89cHeZ+kwbtskl9Z/l3Yrj8Lj9Itg60NrwJzs0=;
 b=B7bE3cDy83ibQ8fvlURu6NdQ8hys2k253SRVp3xozxfeT3oNJ9He3pgVS7RmUEg4wruLDWN2Vw7SItfbKC054Ir77nI0QBo4kjax17R6gFO72HU+makbqjVS3950sL9plHIO/0Gd5/Nyfw993pRI8e0EpF1w9fx3+VHFDZmzWz0MSLAhUfWamUYUSz6nay6/aFP0sCexVH46o4lk7fVzASA8/6ag4AsiJM42xCt7A9igQIIB2fuLcdZXHUU6K0HcOdbBUVcdFMpFlKKqwvG45FnCBl+3N8ahvJ6P8HERx/IG8JhX+4mGxO1fpEhVr96vV0WRgU5Zp+ifh//QZo3GoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Yd2J89cHeZ+kwbtskl9Z/l3Yrj8Lj9Itg60NrwJzs0=;
 b=Yj2F9ciDgG2BJfzG3HqSHPufMpUJeaBUbx4aHC9jq7MnkqCYNlIVrR+wTy39F0k6xrtZkCxmljM2WEQEnIXCq4/tSUBH/1FifUDrLfaXzwlRi6npjT7o4xlH8piyMM+J0wb/y19Lx21ZrT7Br6ow59OcdI3ersXHJNpRzn25JcKHTgGWXmZvAqj211+FVjHPtJCnqofI8RbOvhbqXz/89po2juN26FpVH2Tz2junLGsTF7oheK5tcJkCLf/ze0q2JPH4lRPgZetV3qszMeCPKagiPcxZywu/7qr7CFeLssggOFtwJRopVC3wdEfHXaU0Hl+RZ795fz/R2X7H7dc5BQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by CY8PR12MB7514.namprd12.prod.outlook.com (2603:10b6:930:92::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.46; Wed, 8 May
 2024 18:57:29 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%3]) with mapi id 15.20.7544.045; Wed, 8 May 2024
 18:57:29 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH v7 13/14] iommu/arm-smmu-v3: Allow a PASID to be set when RID is IDENTITY/BLOCKED
Date: Wed,  8 May 2024 15:57:21 -0300
Message-ID: <13-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
In-Reply-To: <0-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR03CA0027.namprd03.prod.outlook.com
 (2603:10b6:208:2d::40) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|CY8PR12MB7514:EE_
X-MS-Office365-Filtering-Correlation-Id: bf1c56e4-cbcc-44a0-86d4-08dc6f90b4be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|7416005|1800799015|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qquxx29URg7maX3kZp5oEqG2VslmBtMISDTRQ5NS4T8tuBAa5j+zBw8IiPle?=
 =?us-ascii?Q?UueAtEuZ6qRdFiF4fpfshyCToA37byl7n6rv90OWlQvSFWAWXHX0MGjzlm1s?=
 =?us-ascii?Q?7y5rixS7zNcJEZJ/3tXqxMKDZwKbSa0iUSW2rzEVp8kKHYGBP5vHZPZvQFn7?=
 =?us-ascii?Q?pOo2gKH3MbS7Xkh3VyVhg9hx0OldK6a1gFgWljUciz89eOcvcHZiQiha4j/G?=
 =?us-ascii?Q?MHuHyPzODac63sGu6ju6Vyu6vd4/M3HMxRBtJhpjPKf5Z8OxxFttiyCXLQD/?=
 =?us-ascii?Q?kkzFKyBq6JZ64WCYry1UbsW1uOmhLJUyh1nrCGvA7OxmrEj4DHIWL6cbab5n?=
 =?us-ascii?Q?kWceUksffm1+NJNlnfzQcIrBCKfE9z5RbNDZSc5Rv8CXt1cciLS19gEYJYEL?=
 =?us-ascii?Q?GduXZeNpUczxFJpStFBAWcf/ptfbQalLaCa7UCYwZMDVydVEdYD63rrBILC7?=
 =?us-ascii?Q?7HxUAxX6G/zNAzEq6F//dmyOB5pBJritpquJAnYfA9kwqQoz6eAB/V1oUHFJ?=
 =?us-ascii?Q?LwcqgDL+1lKX65fOMoakCthtEZJ3Kn33o4XYDTvXIUa4gxcEGerF2XytQxeu?=
 =?us-ascii?Q?b52jnBdv+UVEnx7uC3RgFOeiyeDPY+UtHjkMGqdpBBBZu/cnbPwlw0Etc6Xe?=
 =?us-ascii?Q?10YHmmi+Yyz7Gm3H4HjLOhOKjEbgNQ6zlj+vc0jyDjoSGk8lGsNDTjQeHAvy?=
 =?us-ascii?Q?P7lPYZbh/Qd3QWJkj6qVGf/dk1GahYM3zWhI2wShdkzU1dNVfrFpKiqYjkna?=
 =?us-ascii?Q?IW07Oa4777Py8KSlcgaELjbVlUOwJu9EVt56Jniq72dZM8RLmxmCvnnPzhkO?=
 =?us-ascii?Q?Y3uXGL5FVu49CFr89r8te2EnCepP2FWP1WiMH+HAftjQDAkySvwn3JXVDFtc?=
 =?us-ascii?Q?C1cjmYEkYYlnhh7gn4TCy3BsJ7059+z7xdtxCi2fwpxZ273kWdg+vll8CXtV?=
 =?us-ascii?Q?Epu0QPAvfdYlTFGt3vZ+9zF3JXLkQFQ9MVM0SS9B377DNUsm5Tsqs10/CfPp?=
 =?us-ascii?Q?5xEhHWbdt05OOWgZXwDHhCuvqiGnz4nyaS+QX+7mvXaD+Aor0/5QJOlapLTo?=
 =?us-ascii?Q?UAPb0rnBnHPdeX2Czphmkbxbdpv2cPjO/CaTzmgcUQsGi5EBbvVhnu0lBX7K?=
 =?us-ascii?Q?/jmd3nG+s3xon2nkAjUFpnfCwwJrGnGgtQfqFlA6MVNeHCt3iKOgGCvnTRjc?=
 =?us-ascii?Q?wuj2fjmYdXUuBuq547fZWLxOvgDZUfwui64JrU4xla+I0eX1lsOIxoRNJN29?=
 =?us-ascii?Q?X/jsq90kPtZvySTUf1OblBnGkTCIp+5X7tIaM3Mp/w=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DpoS5/8Zng6VywqfMWlYCx6wmvoxHyn/g7H2fc9j5nW5AY7d/YquUrrhikCd?=
 =?us-ascii?Q?y41UqVMj0bnLASWwdCjdEGjl0LhwzsxPE6UK62qvl7H4sl56QNI/lk7dEEQp?=
 =?us-ascii?Q?qoiN1qb+ZBtjWOIIfNJ1PEjgO+5E6U0QAYxi4lC68zMyaq/wEcfO0p26XBF8?=
 =?us-ascii?Q?XCLbjsXBE6gyj8YT21jkgr7zL0LmX8UyMkuDHfCZo6jgrZZDrEk3SsdPBGJx?=
 =?us-ascii?Q?OsZsIRBTLYskX4ZA6HjeBbHz1SSH0ytCD4SgzhKe/dvzQX+w4PPLFW8S0miM?=
 =?us-ascii?Q?+2R/ky2zF6bL1kg2iEOoaV4Mu1KWNFz1yRqRi68Bt7cgjNeWGSLSIS6guqxo?=
 =?us-ascii?Q?AZ6pWUH6JSzwuUMtph6sL5oryGhAZFjuSlSPWP+8S3b82Tt8DOMGyBEieYc9?=
 =?us-ascii?Q?yUInWJl7CrGXkU0WWwor4lSN6VV9rWg0brX8MQCnByO3/9Vu4IjENcHbMf1B?=
 =?us-ascii?Q?m0m087VRGl0Cj1VUNB+TSiP8B/mYeZ3Q0mrIDp/3W7OK9hLPAYfrHMxFdoRZ?=
 =?us-ascii?Q?2H/EAotZWlFR16y2mxu+9VBsU8+w1FABX2xsHOAh1Icgz7v7M/8JCZMZg7In?=
 =?us-ascii?Q?XyIkiKw5fEichznwZJHzYR94s/XUjUpjQTd8A7sfwTk14cvJFpZOAC9ZmqUY?=
 =?us-ascii?Q?Rqcx4YAcLYjyZBhMFLr2cfwA1IFKqfda6QGbmMIDiAhkGvBscwcRqy5HPcbu?=
 =?us-ascii?Q?Ser220HAVhylj4brtmFk0XvX9MkoFUZalkZT0kT4MnWtJl9tls8w3QdpuGPP?=
 =?us-ascii?Q?Y4fCQtADMdTLchP7E4NIb6K/tSLEXvNr/K0VgYUxvX5Y0QJNZ2a/PAPKQ0i6?=
 =?us-ascii?Q?dNk6wc52oIVJ1yc9FPJOH7xdPJVSdIvo1nQuW7hvYuj6/HVyW0E7l5FX7mz3?=
 =?us-ascii?Q?XfXGeeNHXt2nsq9b8sNtT0TudwIKHWCoanoy30rbHlW2ZnJrBbwaaC3077kC?=
 =?us-ascii?Q?+L6vO/Af49SrUi2JTTBAApFPhnTEUeC0iGeHyVps5w7quaTOnKwxjmFOb0Wb?=
 =?us-ascii?Q?EDnoR5HYFBb8IM9LedBIsKP5n18PdIlZ4brCa912Ev4vQ5uGFcnUCd/EttBj?=
 =?us-ascii?Q?/S15clhryaazAUcUVoe0p2UzVHVBZVaipAbmh8motdhSC9gHHFFtbZ8yY0cC?=
 =?us-ascii?Q?apbviIVr3GcBxspuYXkJzORzcfLDUE0Fp2iOgdQhMwyGYa+WvH3bvMkRy6Vw?=
 =?us-ascii?Q?TwfcSWgKGDNETNWLXGV2sUm8ypS88mS0rw0in9nU4w/4itWSkULU0sbF2tEv?=
 =?us-ascii?Q?cihAr8gh7apqzRkarmBLRJLD3kVGIki5gGgBRB60OFxIlCADpTSeQVUeeSjN?=
 =?us-ascii?Q?andYZEsg0mQYYJ2hQYQD2L74CjAGgqBGMH9DPMUK19NkhaxOEf7S9SDnTlAb?=
 =?us-ascii?Q?/zoBXIyyVQywX5nmgjg/1JnVLSKW4HyyHe4EcEu+dnQ1Icp3+nCWe2pu+T7X?=
 =?us-ascii?Q?HVhHCMxGVDWt8QRI+U5XtqofJbv6GqOhEqv593OpjOiTblpPdIsJVD1TE7Ll?=
 =?us-ascii?Q?JOB5+33b02uOkrZXTSMCK2wGmPPX59VX/tqH5Jc8FF30zK+2mMdUcofyNyyx?=
 =?us-ascii?Q?Ah74o5b/fIE5FQO6u/hZnQK2iwahpfgA7wP5RRbY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf1c56e4-cbcc-44a0-86d4-08dc6f90b4be
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2024 18:57:27.9222
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2fdFn9ZXcrkwJ0pg1MueKuLzrU7rdihs5Hx18hkiLidBgrm2LdGzgIa+ZC2mMWDs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7514

If the STE doesn't point to the CD table we can upgrade it by
reprogramming the STE with the appropriate S1DSS. We may also need to turn
on ATS at the same time.

Keep track if the installed STE is pointing at the cd_table and the ATS
state to trigger this path.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 49 ++++++++++++++++++++-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  3 +-
 2 files changed, 49 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 41d7a0664a445d..ccc10ad3ab996d 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2435,6 +2435,9 @@ static void arm_smmu_install_ste_for_dev(struct arm_smmu_master *master,
 	master->cd_table.in_ste =
 		FIELD_GET(STRTAB_STE_0_CFG, le64_to_cpu(target->data[0])) ==
 		STRTAB_STE_0_CFG_S1_TRANS;
+	master->ste_ats_enabled =
+		FIELD_GET(STRTAB_STE_1_EATS, le64_to_cpu(target->data[1])) ==
+		STRTAB_STE_1_EATS_TRANS;
 
 	for (i = 0; i < master->num_streams; ++i) {
 		u32 sid = master->streams[i].id;
@@ -2765,10 +2768,36 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	return 0;
 }
 
+static void arm_smmu_update_ste(struct arm_smmu_master *master,
+				struct iommu_domain *sid_domain,
+				bool want_ats)
+{
+	unsigned int s1dss = STRTAB_STE_1_S1DSS_TERMINATE;
+	struct arm_smmu_ste ste;
+
+	if (master->cd_table.in_ste && master->ste_ats_enabled == want_ats)
+		return;
+
+	if (sid_domain->type == IOMMU_DOMAIN_IDENTITY)
+		s1dss = STRTAB_STE_1_S1DSS_BYPASS;
+	else
+		WARN_ON(sid_domain->type != IOMMU_DOMAIN_BLOCKED);
+
+	/*
+	 * Change the STE into a cdtable one with SID IDENTITY/BLOCKED behavior
+	 * using s1dss if necessary. The cd_table is already installed then
+	 * the S1DSS is correct and this will just update the EATS. Otherwise
+	 * it installs the entire thing. This will be hitless.
+	 */
+	arm_smmu_make_cdtable_ste(&ste, master, want_ats, s1dss);
+	arm_smmu_install_ste_for_dev(master, &ste);
+}
+
 int arm_smmu_set_pasid(struct arm_smmu_master *master,
 		       struct arm_smmu_domain *smmu_domain, ioasid_t pasid,
 		       const struct arm_smmu_cd *cd)
 {
+	struct iommu_domain *sid_domain = iommu_get_domain_for_dev(master->dev);
 	struct attach_state state = {
 		/*
 		 * For now the core code prevents calling this when a domain is
@@ -2784,8 +2813,10 @@ int arm_smmu_set_pasid(struct arm_smmu_master *master,
 	if (smmu_domain->smmu != master->smmu)
 		return -EINVAL;
 
-	if (!master->cd_table.in_ste)
-		return -ENODEV;
+	if (!master->cd_table.in_ste &&
+	    sid_domain->type != IOMMU_DOMAIN_IDENTITY &&
+	    sid_domain->type != IOMMU_DOMAIN_BLOCKED)
+		return -EINVAL;
 
 	cdptr = arm_smmu_alloc_cd_ptr(master, pasid);
 	if (!cdptr)
@@ -2797,6 +2828,7 @@ int arm_smmu_set_pasid(struct arm_smmu_master *master,
 		goto out_unlock;
 
 	arm_smmu_write_cd_entry(master, pasid, cdptr, cd);
+	arm_smmu_update_ste(master, sid_domain, state.want_ats);
 
 	arm_smmu_attach_commit(master, &state);
 
@@ -2819,6 +2851,19 @@ static void arm_smmu_remove_dev_pasid(struct device *dev, ioasid_t pasid,
 		arm_smmu_atc_inv_master(master, pasid);
 	arm_smmu_remove_master_domain(master, &smmu_domain->domain, pasid);
 	mutex_unlock(&arm_smmu_asid_lock);
+
+	/*
+	 * When the last user of the CD table goes away downgrade the STE back
+	 * to a non-cd_table one.
+	 */
+	if (!arm_smmu_ssids_in_use(&master->cd_table)) {
+		struct iommu_domain *sid_domain =
+			iommu_get_domain_for_dev(master->dev);
+
+		if (domain->type == IOMMU_DOMAIN_IDENTITY ||
+		    domain->type == IOMMU_DOMAIN_BLOCKED)
+			sid_domain->ops->attach_dev(sid_domain, dev);
+	}
 }
 
 static void arm_smmu_attach_dev_ste(struct iommu_domain *domain,
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 71ecced1db0226..3c189a48e29757 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -705,7 +705,8 @@ struct arm_smmu_master {
 	/* Locked by the iommu core using the group mutex */
 	struct arm_smmu_ctx_desc_cfg	cd_table;
 	unsigned int			num_streams;
-	bool				ats_enabled;
+	bool				ats_enabled : 1;
+	bool				ste_ats_enabled : 1;
 	bool				stall_enabled;
 	bool				sva_enabled;
 	bool				iopf_enabled;
-- 
2.43.2

