Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2067.outbound.protection.outlook.com [40.107.93.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ACEA20E3;
	Tue,  4 Jun 2024 00:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717460176; cv=fail; b=t9c9tkMFo6aElLajqHJincKbkXdK+/UDUutnf23w6lEn5/LIg+G4RVdMT6dsuGPdBL5g3mhBmos4pop2l+4T/MXZZmbhrtBBI7ayReq/RjQ31lK5r8zbdx7dFyFjnwhrv/nVXevlZK13lHW735u+e09BresajnQm+3BIdqg2KvQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717460176; c=relaxed/simple;
	bh=NzOy2NEEiZXXajeiokchQOSKosV6cdsddOzyj3Yk77M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bwcEVzl39MqMXQTLYltMcRYPsIIp3dfKs0FbfAJ3NC1IvP6qwPZ5ORzL/xtMZ84Y/fPA/DYiRL03FVkN0CTysB4epZxqulPlKw5QmmIEhzXgBjqaBQGhSSaEtBhdpCRPU8IZz9tSzZXUQv09jNopbARmkXi3n/y3rXooel/h9Ak=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=X4HX8iN8; arc=fail smtp.client-ip=40.107.93.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="X4HX8iN8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UcE86rvtS2vbpjdEk3PwQwhoCINqcsySXdBVc7uCCMyChPbkXaIC8j9EhiODs3oJ9MmA1XNuDVX2iiojEr2lkl/+rtj+NDWkrAt51p1b3tHqW5woUlMACWZQM4o+O0W0kQE80VgTwBrfgvjkgkGQHQlxEgtZjej44KvCFEKhtZibQNT9iPuWpCbfb27/9HcTms1AeSdNQ6zogaPJPdd/BgWUsG691YVDDQ/Kb4caCShf6i2HpY4xck87TEcBcYJ3UFGXGHCJwugk5nSxW0deGXGGoYelNs79MGQSwnpHD8xBCewn90wEnbHXwCqJSsCXvkav+zdXAAzkjBnIbOJuww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H7RA9pcPidzQQWuFFcNv9fvfaIwjby+gEoYGK6Dfg9M=;
 b=G5ARW14+H+VmWpCplvcnZqVMc4YayeHUBc8yCZRevPndWwnmXz4Kgtxmpqt8TMTLFgv/gQZ6zwsnniZ1a4A2kMIdh4zU3+S76XX7bY51mZRDLk/uoh7BtdnWuHdsDaAKqP3OvA4TrVTIOviwKRIhK+NsJtey+/GA+y/vxp5qQ8IjPX3VdAWaHey+PgYf8o8yG93pU2pxCVq2CXmjeepPjdlU6/4KLxQUk2wo1GUFL4KZfHzuS2EO/gxDjUseOwv5OjjSDQac5KSa1s2Updr9AvTdQTDaZVTsEnTzqihvSrI2bhjeeINgUneqkhMmg3q7Ugf/BkQNAv3fI8uNseTGXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H7RA9pcPidzQQWuFFcNv9fvfaIwjby+gEoYGK6Dfg9M=;
 b=X4HX8iN8v9gLajka7E1fvEshxMPgNRn1Vp4rMzco4Hb4SzE3J7o37NYM9U6HpUJivtu3F4yj7mIo8LG4CQV3mp39VLhzB6WWS2yQdMU2PAlBhydQoZWocYIaxXKULDrAB2RkSIWKgi9G0bULNfCbAttaUDyTIGWiQ/W61x8CcEcTS8hxy3dYJ2cZBJsZ2nidyVTGHtQsTAb2OKC68kLbbr/Bi4R6dSazwzPD8GMBSf2kCgk89qTLygSt2lIIyKS3VlF3mYRvgDj33Hvl8/LAno+qoPOosMa6pPl/qjFcsaQc6gIjP8HecsoMupvIhrVD32Z7c3emhevVtCp37J3ONQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by BL3PR12MB6451.namprd12.prod.outlook.com (2603:10b6:208:3ba::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.24; Tue, 4 Jun
 2024 00:16:07 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7633.021; Tue, 4 Jun 2024
 00:16:07 +0000
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
Subject: [PATCH v8 13/14] iommu/arm-smmu-v3: Allow a PASID to be set when RID is IDENTITY/BLOCKED
Date: Mon,  3 Jun 2024 21:15:58 -0300
Message-ID: <13-v8-6f85cdc10ce7+563e-smmuv3_newapi_p2b_jgg@nvidia.com>
In-Reply-To: <0-v8-6f85cdc10ce7+563e-smmuv3_newapi_p2b_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0441.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::26) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|BL3PR12MB6451:EE_
X-MS-Office365-Filtering-Correlation-Id: bf738b78-abd2-4810-1a9d-08dc842b85b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|7416005|1800799015|366007|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?V7yAFgD3H/8ORCshwo3zxLmUiMUvbs8HS/Ci3dcUNzRkh3785+hPgdEIJ40e?=
 =?us-ascii?Q?rS6zN/K53StnFX/6yYCd7wAV9a067adn3DKIVcpzqjZFyvBA8gqmZ2Vj2wQ2?=
 =?us-ascii?Q?6DxURs7Z71ajraGmv5fIPM+u0rlVZFUdPwAP40RoozU9RhjzjfeYxYtRX0gz?=
 =?us-ascii?Q?XfciqTOvBzwCbtUIdcU+oV1OWu612o2Z/U6Hmquck1+J4lI4m3JCrLEklQYl?=
 =?us-ascii?Q?UzANJ6fmiMORKQn1jDbGuGIxcJikrENqkelJ7Bw12nNY3m5xcjDJ0X6EQBOS?=
 =?us-ascii?Q?xEfHKpDSbOb4uITR3+Ng19pjWbGoR92mIoDLnM630wq7wDl7jlyscAvaBol+?=
 =?us-ascii?Q?TMvPiMRr8rY9snJ6QFR7+sAt3lMlvc4z5efatK1Exaqa3mlg3uv6NED8jJ3/?=
 =?us-ascii?Q?0mUJCwt7PcX3pW2Q5hUxJJGgpWFBAtCT9qdr2vssylyudK8Mnq4xqNpocM1Z?=
 =?us-ascii?Q?oChoSXd1Pfy3MiZNZFJdee5PAnbIytHhKh90ySEeqtNuAAFRIzj7oLjdATTu?=
 =?us-ascii?Q?mvJ4jXNjg9zaH0cfACDF1bfmIt6HqgNAjSFCrzvokcA2+ZfiYHVDGGozM5PC?=
 =?us-ascii?Q?sr0f1fG854IiEEw4FrKdTWgssspe1mdUhGxVbwqvxyiuovJ9HZHCpmwmN9Py?=
 =?us-ascii?Q?zWkphbaxksMeyNCKXzJd9azxZvwVcD0/jfjHm3FV6scBGix6CdPG2niVYL58?=
 =?us-ascii?Q?2civLUR4th4zJ50eOIu172BJtIxLFoUhZDtwIruzLSuJvZHSbNIeO1Tk0p+A?=
 =?us-ascii?Q?xHPC3l8vxfPOqErhunMP9c6/jZwlaNopee2Fd8OUEkrHvZxuJWV9fkPOp+OC?=
 =?us-ascii?Q?vEeWtMzN/vnegW9IN8r9zyk2MN5Va2wW4aan2AR1WlyK1elU0QS90BOONqWn?=
 =?us-ascii?Q?2qXQtk1HMIVz5Sw/3JO02k9asOr4mJrkKNdjXN7psAT9RumHwjc9da0w5GAf?=
 =?us-ascii?Q?I4EgW60kXfirVUKO9BtCKemxdJ3Q5xXsl3vpGhs/q6CRg/vHVbzGWBN5uqCD?=
 =?us-ascii?Q?+VIWmoQikNsKTiPdSeuFpcfxCrFNJZWGcms+ZFsFJ5x/ZSVt+4o2BJ2ubrLh?=
 =?us-ascii?Q?rjj+mFRFGIpdUDF3lt8ArvJGWWmFRL+pigvHtk2YXSCZpaVYsV//ULjA6FlS?=
 =?us-ascii?Q?LKzHwxQG/ji7MuH7d+tS99GnWzD8yIjYxYume3OEfr4F3kmvV/RXwdEPIUJ7?=
 =?us-ascii?Q?iGRgJVHGShlBox/MRMuTF7/TpmFhPo3LF5ayvxIlDW7lxNmHmSNnebjjY7OM?=
 =?us-ascii?Q?778gXJ80nQ8IXvtUP1iD8vQQoEmX4zP8oXnqNcsu9w=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Nb2PR3ciPiAoNmYfK6miQMnbkWkAlzcUfSAtM6nn745sNtJiZwwx5eUbXCR4?=
 =?us-ascii?Q?ZAnPS38sNQleOtSeBNUnRC41kpXK3Av3HwU8YVCtiTJdwi6pChxtFNy6xLP4?=
 =?us-ascii?Q?WcjTfFQCbd1oQYfjYn3tVnS7Sc8uYzL7me1ALDNCTsqVRDpTAUj2lkeEmBeF?=
 =?us-ascii?Q?qQJYDMogDpYJqz1vNVDJzvySuX8wqOZthP6c5w63i5H4MZm+vPWyVHzoFSps?=
 =?us-ascii?Q?9TK4ZjAdayj06mXqeQHq1AkQcrISGhRnxXNaDuXyd7uew+UJ1dNMBC/5YFVL?=
 =?us-ascii?Q?MTBxuoRFEi5WOtmnA0rCE+5LcmLgHvazJGgej2mnw3ijjHaz7ayo2TH1BJxh?=
 =?us-ascii?Q?73qm3xsB9xevCHumiAoqtxhFcbxqOsfVS60HZC6K4RUGGXJD1ufvVYKjloLK?=
 =?us-ascii?Q?fjkoTbUwqBpFoCQDxp7/+vC9q+azD6t7jqwy9OGJXOGIasYuCbL5cHGZxJgX?=
 =?us-ascii?Q?mx/pBWW8hn/D6bso5ALCzTq11dv/FepUvDS2oe4iBSvhYsOX2Vii6NmomseO?=
 =?us-ascii?Q?/PbPvaEJR9N2mhiZZteKwpX3DcQ+s6hbaSC8PAzLLZ6h1fGMbVQpFgLLcw+6?=
 =?us-ascii?Q?MxBzJLlA7j/Mh5W0O7ZRajzZKHF0QJGneLEFy3VQ3kDjDsKpsnSp675kYR0x?=
 =?us-ascii?Q?UA4DJyCf5OIJpG86m/f4KOb2S+6qjf7plNmdW14VMRzze5iW/br8NDd/waJ3?=
 =?us-ascii?Q?oXfx8hJUrvrddt7g1Ni++CQGnvRbZSP+EMFJhJD4Tqxy0GYl82cb17aSiZ2R?=
 =?us-ascii?Q?KjtSJOxUfkEqfMchcrxCPHGNzYKGNZuOYPLcNerBqXHD10/WVHSuAtTqHUTo?=
 =?us-ascii?Q?0ujQ3l6sI9cMWG3QnMkRNbimxnVb14us/5PJx2HKlkd2KJQ2bah9sML3pBsd?=
 =?us-ascii?Q?0PzoYkXBG81jKk/jN6V5PSGu7/q9g+gyR109yhB0HIjEMCyAMY89dYRkspRj?=
 =?us-ascii?Q?0DzIFIilmqeIk3R6XgsS/gzVCwCiJjnCOW6EMZMl2OU/w3Bhu+I8SB5RKleI?=
 =?us-ascii?Q?6L+lAA1JkuPgpPD0m1N97fVb8GlyJJMZ5JRqaCRWFdwd5MRdHwxzqzDz/kFp?=
 =?us-ascii?Q?Y/AGHJpk+Km5sCnxajoA5hBmCm/6C7dccjV6r5M2caP+MDSPClcwbH30HWIl?=
 =?us-ascii?Q?nQhdWEf6PZudObnp2AO9LPuSdTVbKK6ebpe5QMgIc4rCrkOdl4wzxyfYuL2x?=
 =?us-ascii?Q?nQSruvSXssokY199pp9UqELmB6l5D3/5AeRssf0k17c9egQbaE5Zp4T8jr5U?=
 =?us-ascii?Q?1/GCaEoINxkpDqGpB0vjLfhZyvLlqoUvVgmgXvAIUX/dUJSCKRo/pFLvfiOU?=
 =?us-ascii?Q?gIVbnOirlfJ+niBeXTpUPJWuciUFHTJDktqJjoxq2ipQ4iJxSP3d/jijPMk4?=
 =?us-ascii?Q?D5obAfJfPjWH6npuFSKmpWnXs0FS7P26FitmT+bnd2rIF7pFcl6LmWBxmAZ7?=
 =?us-ascii?Q?Q72tfn0gce19nhZjVRj8y9QxGXkDoAoZVyZ0qbaSxzjLwX5Ql12Z5OwsfoiP?=
 =?us-ascii?Q?v8+gS3+E/bFDXzHZ3ALwNW9y9rqoWhJhS2aDjtR8ZNLNsU+WhNcRZtNs3XH7?=
 =?us-ascii?Q?jBo3w1yK7LD2C3DwYdU=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf738b78-abd2-4810-1a9d-08dc842b85b7
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2024 00:16:04.2481
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0OJ/xmpQNZr8mLe0f2LiqwdegTV+7CzI9oHpMzH5XI4ghH+1dhzElaiaX10wgCRh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6451

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
index 1b43fc1fe85387..f54be4f32d30d1 100644
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
@@ -2796,10 +2799,36 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	return 0;
 }
 
+static void arm_smmu_update_ste(struct arm_smmu_master *master,
+				struct iommu_domain *sid_domain,
+				bool ats_enabled)
+{
+	unsigned int s1dss = STRTAB_STE_1_S1DSS_TERMINATE;
+	struct arm_smmu_ste ste;
+
+	if (master->cd_table.in_ste && master->ste_ats_enabled == ats_enabled)
+		return;
+
+	if (sid_domain->type == IOMMU_DOMAIN_IDENTITY)
+		s1dss = STRTAB_STE_1_S1DSS_BYPASS;
+	else
+		WARN_ON(sid_domain->type != IOMMU_DOMAIN_BLOCKED);
+
+	/*
+	 * Change the STE into a cdtable one with SID IDENTITY/BLOCKED behavior
+	 * using s1dss if necessary. If the cd_table is already installed then
+	 * the S1DSS is correct and this will just update the EATS. Otherwise it
+	 * installs the entire thing. This will be hitless.
+	 */
+	arm_smmu_make_cdtable_ste(&ste, master, ats_enabled, s1dss);
+	arm_smmu_install_ste_for_dev(master, &ste);
+}
+
 int arm_smmu_set_pasid(struct arm_smmu_master *master,
 		       struct arm_smmu_domain *smmu_domain, ioasid_t pasid,
 		       const struct arm_smmu_cd *cd)
 {
+	struct iommu_domain *sid_domain = iommu_get_domain_for_dev(master->dev);
 	struct arm_smmu_attach_state state = {
 		.master = master,
 		/*
@@ -2816,8 +2845,10 @@ int arm_smmu_set_pasid(struct arm_smmu_master *master,
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
@@ -2829,6 +2860,7 @@ int arm_smmu_set_pasid(struct arm_smmu_master *master,
 		goto out_unlock;
 
 	arm_smmu_write_cd_entry(master, pasid, cdptr, cd);
+	arm_smmu_update_ste(master, sid_domain, state.ats_enabled);
 
 	arm_smmu_attach_commit(&state);
 
@@ -2851,6 +2883,19 @@ static void arm_smmu_remove_dev_pasid(struct device *dev, ioasid_t pasid,
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
+		if (sid_domain->type == IOMMU_DOMAIN_IDENTITY ||
+		    sid_domain->type == IOMMU_DOMAIN_BLOCKED)
+			sid_domain->ops->attach_dev(sid_domain, dev);
+	}
 }
 
 static void arm_smmu_attach_dev_ste(struct iommu_domain *domain,
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 30459a800c7b2d..cdd426efb384d2 100644
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
2.45.2

