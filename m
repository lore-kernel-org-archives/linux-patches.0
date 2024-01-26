Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2073.outbound.protection.outlook.com [40.107.93.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65AD1208D9;
	Fri, 26 Jan 2024 18:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706292952; cv=fail; b=QyBGTaUVjw4Br1b7CXdQco291t69uxHwNAHAcS3KtDOppCJ7OrcjIa01xxGRqaiwZwEM+cMBFXt5P4u1P1QMEI/6e6EXw6mO3mpFvBbAoZnkIF8RmV9IDZy31vDAm26qBxR/ljQUx5zLley8CF3CHom/1AFqnICmkwVxR36o5sY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706292952; c=relaxed/simple;
	bh=7N+p7a2EhmIw8MwQK+RxpvvPZ5uAOT5QBaQwxVCzqZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gby6Idwk724o1cO9DNd13Rj5zuH5/wIgsw1P+XLGeLReoX5QRKIjInEOaDwoD24NopfNgP1Xz4z07Pcv3CqTtlOyGff//odxNvgvHTljTG3VFoiRFMiSJ83ZG3MqSSEIHiTJjCDR0X03F4/vlVesRnWYCAacOY6JGLzGzMk9TPI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=oy4xjMw9; arc=fail smtp.client-ip=40.107.93.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="oy4xjMw9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hgzZ/sIzDw5lGwzkJSk9EvqAFg42+/fI29thxtI3+emJqu1p8ezhazZsblobkyZRqIWLiTzTY7uXWz+J7Iw9eMnB9ZObU726Xpo91YcTbdTPmzco8JecVlP6G4fr5gwpx/I0oBO0BWXrBeImuuBKKszx4j3rv94yN0s5cr9UroH7fTJkYmQ0prL1FdU4otWBU2HH43Sp3DeOr7cGMliYS+xKGz/cvduQp0RrfOji3dQY2VIpWwHhKvS0k+LdDHzgGpslr+hw6i6pMWmT6OsdadiuwP9xE+QL1aRmK57h6MZiju0hmGPzjB4rDxa1ig2Nc7rtV4pMHJncrLTWUruqIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E1XnujJJDhRFthHtzz9WxxCn2XFq2wqVuwj2WMBztP4=;
 b=LDP1wp1LtroMvxebEKXb0yIW1+jNqVte3fi52kYEWMUfBb39d3wiG8nNy/4XS1fh7b+fzxdL3HNC2dYXJlEGxMvOmyOagM/5zQhSTNTcrXEQN3L+uuW7WDr5m7VeAVaTJGtQu+LCsAlEocu+j98bOETfzjIOFZ/oL8TCLHVjpYS/18NLzj8j6mFmPYCMyW2mCGf32msEYruomMEjk1Fk4f1enYNLD3r6w5wQqsQIh+VGsZysIP535KXgbxlivlFcgkBY75eHeCGQ2X29JeDPjEsG7M4OzFTRattBIleWJR2uQC26DG1+netDuR+8GcOerkar+dv8MB7evYrdaJvoqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E1XnujJJDhRFthHtzz9WxxCn2XFq2wqVuwj2WMBztP4=;
 b=oy4xjMw9oEiiI6+5SoD5s4JLo5Q5wsp4wSBFyn/wFhqi0L3DUup7/85vT6wP5dSyEqmVJ2zKnbl80wwztwiUu6fT+GWLHCO1N6BWI/vbP4WpabdYLxA1CF9nC0V1BRhuMjoOOOnr63FSZQSsNQqLwKDvOzLXmrOzwaJp+DL1ZWJlVVe9iicgvdYvHXM6biYmlKc0II/O1TCthfIJ+zWlmuYdIk9o8F19hp0lilCYJEfjLl6W82pzROkYvfzuFaAjsw9OShdgytecr8RmMmhlDj0zBmbXVM13y1/okq+gRkV915NKf4gecp4cdF9gwwOoWfDrDi7oOH29vLp7GDT68w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB7185.namprd12.prod.outlook.com (2603:10b6:510:201::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.29; Fri, 26 Jan
 2024 18:15:39 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7228.022; Fri, 26 Jan 2024
 18:15:39 +0000
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
Subject: [PATCH v4 12/27] iommu/arm-smmu-v3: Build the whole CD in arm_smmu_make_s1_cd()
Date: Fri, 26 Jan 2024 14:15:14 -0400
Message-ID: <12-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA9PR13CA0148.namprd13.prod.outlook.com
 (2603:10b6:806:27::33) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB7185:EE_
X-MS-Office365-Filtering-Correlation-Id: 995dcfe4-ac8e-4bc0-6bdc-08dc1e9ac936
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Lx/Jyum+aEum4b/6x5YFsZ70P8dKfAGShWDlrhX5lRx4MpYQKDRenS2s5Wow22iXDTEWST4Uh4xODHpnCGE3q5xIhji1z/bwJM1C0PUqZ/UG+fp0pQa4oL/jn3cbYo2godQHwglnjms7IpLJ59pbyoAw5yH9ENIkqOPovnjqjl3DxD3RziCNr8pA/LyKhXx9mHqZenSGW6iwFr3jTUHiFdhNE703ov0VSc3cee6MMOrwHB4t+oreoy9IwlT+DRnDVkfzOkOCozrmQ7t9ps4+PGgtlpVeCRCeGeFJDa7RdB+xIqfdoXdBR5lxHf0c0xS8NrNE5jG7D1CAgQl8C7cMvNf67+Rbc2zeXpMAINBbhmiPPSEA5h24LtU+6HFtf3L64BGFz7VoTIoOa2S+csq3acn8t92VCbNrYlMQZ0nNVbLnmykRlzDIisrLyLH7zbc+nkrbZ7YvUDru17EUJHg34Yh/L8RWdFrFSa8e0p1r4+WJZ0rUEOaAflC4oJ/rPaxePgIzf8tnC6s4SR7CQp6PwsC51f468W5eK44gZpchtVI+RjUPuxqWYbnecx6aEtEn
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(396003)(39860400002)(376002)(136003)(366004)(230922051799003)(1800799012)(186009)(451199024)(64100799003)(8676002)(5660300002)(66946007)(316002)(66476007)(478600001)(110136005)(54906003)(26005)(6486002)(6512007)(6666004)(2906002)(8936002)(7416002)(2616005)(66556008)(4326008)(6506007)(36756003)(38100700002)(83380400001)(41300700001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4FM/3QES1cYJL3unC+8H4czUDeuAAw673ob8ySGnNAguo75IEbAleGIMRHmS?=
 =?us-ascii?Q?6QpXcmRySiqj5brzyPSVC6jaUf8cai3Q7tJYu/qBcHTgSOX7ezc4/iQOmvIQ?=
 =?us-ascii?Q?Bdl9j1TyefBZXF7RBEn4x+HphF5y4UXslNhgwgGwK7/e3gb9VArEbSX2Bs1j?=
 =?us-ascii?Q?0f9smn/SYGcdCgzhisCntMYF+wx8jO4xJi/OhAsYjxftSmGFD2kwg/UH1QQ3?=
 =?us-ascii?Q?KK/GZQzqPgXmqKgdHi3D+7GkM+4Zs5zzwwjBRkh566zY/NDoUwI0zUwWpZHO?=
 =?us-ascii?Q?uyejpZBa8oCPYyKKgmsRhVz0wEEz5TRrTzp/Ye/khfJzhZvG4LkKreh38zLv?=
 =?us-ascii?Q?6r6yKUXcVjuQ5QM8DEKHuCjBuwoZh95B7DMjm4RMKriS8u8IlT6QBLRn3ZML?=
 =?us-ascii?Q?f7go+Ku4uI11X/uo+TurCCWG5B1XYtJIrkrmsvg+iQM7rFhW9mn/hJF4g40Y?=
 =?us-ascii?Q?C2Sr51ud0mufrI9h4OnYNgmrKdiPxsOBhJiD1OvkuGBySBam4BZAgGnfKKAE?=
 =?us-ascii?Q?LOQQkK+SHYnN94/wNTsvsLvcqxZRi5dlWHS6UthzHDCnbpXE8chIGar2QDB0?=
 =?us-ascii?Q?Fh7IWbizNrf0Qxe8KZK4dPZqqxA/3gh9Z5aBLPvrzDpVEMvbLXPnqbDds0Bp?=
 =?us-ascii?Q?cr8sdsIaw54oPH3Z4aaNxikMLiH0DnNtv+HSBs2zVN6lcZslZELCbsqfjsHU?=
 =?us-ascii?Q?hpzfOglP89jodcZVQybuwifwPkS0T+yc0bZnLPUsz9SLWYPOrBMXTdBX83hU?=
 =?us-ascii?Q?UNEK2F3X9O/QnvlTL52X7GZGdinNsY65XfrkRDjfCJ19y610bk3u7oOhJjly?=
 =?us-ascii?Q?tT451kBQamTzudCwzZ93ZwW/hBVCybDyZE38rpRe1R3BCPHYdNlPWWZkYo9v?=
 =?us-ascii?Q?9iULfMEwsQ5dlst68H9uOnyh8mh8lR39C0KMtB55Vsyxj1uOG9++dZ1fvZmG?=
 =?us-ascii?Q?H+39UAsGn6dORCxQSW43UYISCaJhF0U6V/naW+zydcxvOF892irw74RaxDy/?=
 =?us-ascii?Q?T3Wag71vft1R4b+9zqUvXHbP5xiBzXRQrJJf5G2mIsB6yNiWV/7vYid8Njs6?=
 =?us-ascii?Q?F6iqJnjS0TtkDGkAhkM8g5BqnT+QBrXVDUqOSwqJaO8+6oRLo1JG6mw2fujR?=
 =?us-ascii?Q?Qg7jw8J3LJHOry4lby4lBoq0ar0Hgpv6foKuxHZzzGBxTDx74M7jV8ZvOxoS?=
 =?us-ascii?Q?b2qpGw6hr0FygbimYbKGIR8c3eAqxgM7vD9uTSngdTrI8gkWPcRbsfSPoyXr?=
 =?us-ascii?Q?iqetHcU02ERg6/gBrDQu5hNCr1UBQL89eljo8hSTJDyUBMBs9IPu2aaAI5rJ?=
 =?us-ascii?Q?OiRs7BYjE+lTkFcuJe4FJag+3OFwQ/gNfJYkyo3qGqFqSe4T+ZOkQoNzhTgP?=
 =?us-ascii?Q?BAxlEPAiYDRh9RFr18aOaz2bqj5tymXaHPPxYmfAhy7yu9Vlhzt1t+M2MBNw?=
 =?us-ascii?Q?PDO4EJwpGy3szfeCn7PihAg9/kyXCIVD0Muj0jw+Lyl3VDeiYopJWsR5bl+G?=
 =?us-ascii?Q?H1rffkBqAaNCSui2NHEDYL4HFGesqPqh3fVFt5fqjp02/KLV5kDUj2zH+JNw?=
 =?us-ascii?Q?NP2nQSpzDMGcDpCrbSz6bg7faA1+LccKouhzteTk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 995dcfe4-ac8e-4bc0-6bdc-08dc1e9ac936
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 18:15:33.0117
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GR4TifDwWFNC8WUrpmRaUA8e75DgZOGSFE4eKkU6CxHM/pld3e/SREW9N3M7PRqc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7185

Half the code was living in arm_smmu_domain_finalise_s1(), just move it
here and take the values directly from the pgtbl_ops instead of storing
copies.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 47 ++++++++-------------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  3 --
 2 files changed, 18 insertions(+), 32 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 712795232fcfa9..7e338664d7fea1 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1261,15 +1261,25 @@ void arm_smmu_make_s1_cd(struct arm_smmu_cd *target,
 			 struct arm_smmu_domain *smmu_domain)
 {
 	struct arm_smmu_ctx_desc *cd = &smmu_domain->cd;
+	const struct io_pgtable_cfg *pgtbl_cfg =
+		&io_pgtable_ops_to_pgtable(smmu_domain->pgtbl_ops)->cfg;
+	typeof(&pgtbl_cfg->arm_lpae_s1_cfg.tcr) tcr =
+		&pgtbl_cfg->arm_lpae_s1_cfg.tcr;
 
 	memset(target, 0, sizeof(*target));
 
 	target->data[0] = cpu_to_le64(
-		cd->tcr |
+		FIELD_PREP(CTXDESC_CD_0_TCR_T0SZ, tcr->tsz) |
+		FIELD_PREP(CTXDESC_CD_0_TCR_TG0, tcr->tg) |
+		FIELD_PREP(CTXDESC_CD_0_TCR_IRGN0, tcr->irgn) |
+		FIELD_PREP(CTXDESC_CD_0_TCR_ORGN0, tcr->orgn) |
+		FIELD_PREP(CTXDESC_CD_0_TCR_SH0, tcr->sh) |
+		CTXDESC_CD_0_TCR_EPD1 |
 #ifdef __BIG_ENDIAN
 		CTXDESC_CD_0_ENDI |
 #endif
 		CTXDESC_CD_0_V |
+		FIELD_PREP(CTXDESC_CD_0_TCR_IPS, tcr->ips) |
 		CTXDESC_CD_0_AA64 |
 		(master->stall_enabled ? CTXDESC_CD_0_S : 0) |
 		CTXDESC_CD_0_R |
@@ -1277,9 +1287,9 @@ void arm_smmu_make_s1_cd(struct arm_smmu_cd *target,
 		CTXDESC_CD_0_ASET |
 		FIELD_PREP(CTXDESC_CD_0_ASID, cd->asid)
 		);
-
-	target->data[1] = cpu_to_le64(cd->ttbr & CTXDESC_CD_1_TTB0_MASK);
-	target->data[3] = cpu_to_le64(cd->mair);
+	target->data[1] = cpu_to_le64(pgtbl_cfg->arm_lpae_s1_cfg.ttbr &
+				      CTXDESC_CD_1_TTB0_MASK);
+	target->data[3] = cpu_to_le64(pgtbl_cfg->arm_lpae_s1_cfg.mair);
 }
 
 void arm_smmu_clear_cd(struct arm_smmu_master *master, int ssid)
@@ -2294,13 +2304,11 @@ static void arm_smmu_domain_free(struct iommu_domain *domain)
 }
 
 static int arm_smmu_domain_finalise_s1(struct arm_smmu_device *smmu,
-				       struct arm_smmu_domain *smmu_domain,
-				       struct io_pgtable_cfg *pgtbl_cfg)
+				       struct arm_smmu_domain *smmu_domain)
 {
 	int ret;
 	u32 asid;
 	struct arm_smmu_ctx_desc *cd = &smmu_domain->cd;
-	typeof(&pgtbl_cfg->arm_lpae_s1_cfg.tcr) tcr = &pgtbl_cfg->arm_lpae_s1_cfg.tcr;
 
 	refcount_set(&cd->refs, 1);
 
@@ -2308,31 +2316,13 @@ static int arm_smmu_domain_finalise_s1(struct arm_smmu_device *smmu,
 	mutex_lock(&arm_smmu_asid_lock);
 	ret = xa_alloc(&arm_smmu_asid_xa, &asid, cd,
 		       XA_LIMIT(1, (1 << smmu->asid_bits) - 1), GFP_KERNEL);
-	if (ret)
-		goto out_unlock;
-
 	cd->asid	= (u16)asid;
-	cd->ttbr	= pgtbl_cfg->arm_lpae_s1_cfg.ttbr;
-	cd->tcr		= FIELD_PREP(CTXDESC_CD_0_TCR_T0SZ, tcr->tsz) |
-			  FIELD_PREP(CTXDESC_CD_0_TCR_TG0, tcr->tg) |
-			  FIELD_PREP(CTXDESC_CD_0_TCR_IRGN0, tcr->irgn) |
-			  FIELD_PREP(CTXDESC_CD_0_TCR_ORGN0, tcr->orgn) |
-			  FIELD_PREP(CTXDESC_CD_0_TCR_SH0, tcr->sh) |
-			  FIELD_PREP(CTXDESC_CD_0_TCR_IPS, tcr->ips) |
-			  CTXDESC_CD_0_TCR_EPD1 | CTXDESC_CD_0_AA64;
-	cd->mair	= pgtbl_cfg->arm_lpae_s1_cfg.mair;
-
-	mutex_unlock(&arm_smmu_asid_lock);
-	return 0;
-
-out_unlock:
 	mutex_unlock(&arm_smmu_asid_lock);
 	return ret;
 }
 
 static int arm_smmu_domain_finalise_s2(struct arm_smmu_device *smmu,
-				       struct arm_smmu_domain *smmu_domain,
-				       struct io_pgtable_cfg *pgtbl_cfg)
+				       struct arm_smmu_domain *smmu_domain)
 {
 	int vmid;
 	struct arm_smmu_s2_cfg *cfg = &smmu_domain->s2_cfg;
@@ -2356,8 +2346,7 @@ static int arm_smmu_domain_finalise(struct arm_smmu_domain *smmu_domain,
 	struct io_pgtable_cfg pgtbl_cfg;
 	struct io_pgtable_ops *pgtbl_ops;
 	int (*finalise_stage_fn)(struct arm_smmu_device *smmu,
-				 struct arm_smmu_domain *smmu_domain,
-				 struct io_pgtable_cfg *pgtbl_cfg);
+				 struct arm_smmu_domain *smmu_domain);
 
 	/* Restrict the stage to what we can actually support */
 	if (!(smmu->features & ARM_SMMU_FEAT_TRANS_S1))
@@ -2400,7 +2389,7 @@ static int arm_smmu_domain_finalise(struct arm_smmu_domain *smmu_domain,
 	smmu_domain->domain.geometry.aperture_end = (1UL << pgtbl_cfg.ias) - 1;
 	smmu_domain->domain.geometry.force_aperture = true;
 
-	ret = finalise_stage_fn(smmu, smmu_domain, &pgtbl_cfg);
+	ret = finalise_stage_fn(smmu, smmu_domain);
 	if (ret < 0) {
 		free_io_pgtable_ops(pgtbl_ops);
 		return ret;
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index bc6fa08cc788a9..a3ea078bba92ff 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -587,9 +587,6 @@ struct arm_smmu_strtab_l1_desc {
 
 struct arm_smmu_ctx_desc {
 	u16				asid;
-	u64				ttbr;
-	u64				tcr;
-	u64				mair;
 
 	refcount_t			refs;
 	struct mm_struct		*mm;
-- 
2.43.0

