Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2086.outbound.protection.outlook.com [40.107.93.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 785A6208D4;
	Fri, 26 Jan 2024 18:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706292944; cv=fail; b=uJoeL7WChhV4g45bllWbbwc9KFoaW/gpGNRHvsq5NmBQsrokCy6CeIclXijOCl77M19Un3yHIjER/NGjYQ/SswF3HsKHPupJCeRM3MXMNFUSY66PM2QFLk+0kBEwMxT7KJ+Dxlz6sxOEnJJHOaZhV4Mu/r7dqdURtdbaLQSWnns=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706292944; c=relaxed/simple;
	bh=J8eZ2w7QAaSPAvrEzaFVIan4F4KtnS4+gWiqZ3Dsb3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=i3qi9BEneW8vDVWpWcgicvG+Ct0HiKUwlmAhbWbk5FtVcftLIkTwf+xm5I4eBzAp3ftwgjeca1lzYBTcydKnAXvFyfPWpeb+9CqhJQKqXfGZ9o/yrpnvpRmdFV/MbD7qaD9tqCSlUlO55cC8BQ9RO/S34rpIjP4KOnUIjqXrQCg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hFfZqh6W; arc=fail smtp.client-ip=40.107.93.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hFfZqh6W"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QbcSx4a+IniydqltHPZwf7skJRfVtt3MwtYY2Ii6sJnvRoCdCHsUQ3zH7dnRZRXc6UAd8Nang/AaqSxv4IWfYvGHjNx3xuhZ3+JoB2pr1X5cTXlJwz0zQ9JDSFHS7Py0EVlsppO9r/EZ8S0LxsLQoE5Kn9azIJlokPewKVo7kCZuJplFXhGBpQPe+iGOJpxbswfc29OkfAPLC62eQlqli1YG8HBNLb3blqOaLoaCFNpCdoCYENFWz3B5GzSWf/TSfBuZGYH+xPmHOPqQdLj0z0lIdEZofW0TxMNozm5Wrc2nhh9MMeTbAc7i9X0gdFvbBc4khsDFYHpOH4Cc8DTiEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wrm2JbyZjdm8aedWVNAJCmnFDn6ouiS3bj+AajKavEs=;
 b=HzyQLDb2lX0900PLZ21ENxjFZ72tAS8zd/Ljx3vD0g5ClFdCJqXE8WBf+hAt+/0zVrivOf3uXUXMx9BPLUPe07o9Fn1e6+UqnncrqbKoTLDRYbha3Lke/+PsfUDHlcWxtDtA00zNYMG/X2QZqlEC3lRlcuRVRzJgQm67GLACZTbdGB5bbqQw9yc1ayCi2JxI/Vx/UPmX1CiX41VRcm3blE7PCkO+IRrjeQupSCJl9Rr2QBwURp3RUZ+OKkGvCBntWhmL4U3HYVXm2gf5koGWn2Doq0FxI3sik9GvEdQtwkTTFZf2nn5FXKGo1elBljQgKF3o4z9p0JNe8Yf5Mlv4pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wrm2JbyZjdm8aedWVNAJCmnFDn6ouiS3bj+AajKavEs=;
 b=hFfZqh6WwqwgBoL/vt4Gb9USxOo1pb1yFnltXsuT8B9zVBqXu3VXMJPyaCnWMzs75JqzFzasz/HBT7FwYYizuZI2R5Cr4Y51AhXF6yauWV57nK4BjVSQGmHZ4tCh5KsXW2G6xc6kIIha3b+j1F2VYWvKpD1EWXyowWrrsIsYXOAiFUoZ5Gw5Au2UDZnMmy2C2+MDonKc5ZPEO889FG5+j74Og11owl1bjtDMvG4pMc1wkWMClHD2BXT5iSHQgA5wtu4e04r3XzcBfqtfcAPcNnIzHypDQsXaYnzwayl3ACz0CzKagty5uEctGeVKo8r4X3pQa28HhusQOUv2Ivpsew==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB7185.namprd12.prod.outlook.com (2603:10b6:510:201::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.29; Fri, 26 Jan
 2024 18:15:37 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7228.022; Fri, 26 Jan 2024
 18:15:37 +0000
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
Subject: [PATCH v4 16/27] iommu/arm-smmu-v3: Keep track of valid CD entries in the cd_table
Date: Fri, 26 Jan 2024 14:15:18 -0400
Message-ID: <16-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN7PR04CA0229.namprd04.prod.outlook.com
 (2603:10b6:806:127::24) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB7185:EE_
X-MS-Office365-Filtering-Correlation-Id: a27fed98-b192-46d9-9f52-08dc1e9ac90d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	SgiQXfLYZ1Zn5hj9aZtPzN0ypsFEsTgqyN/2LPxaYeL+DUP8Cg/oAw8WCatAlwhYZHq5sEsqjySB3lIcE3eWNmA960uipjHvrpMVx5gHaAHoNnl+LNMtTkTX8iAPT1jj4Hs+yE7RV7BCbofyLymm2WjnI8B+XTV5UEZcK6sLG/0GBm8iOHCNLdUbzqp1ILxl2m9ayVdgnlSMbjb2m9l/0IO7BTHPnm1TbriC2Oj4XsqiGXI/KitwpxZKhKkmiLpEUAG4Oz8UdQjg74SKznWk267Kx3NqJ0ptLQW3IxZ12MV0z3ZvvjN4WQh1+AwMUOBlUfhs5P8f6wc2zpgyPCMRa/b4uQNRoXxHgnV1t2jf/wAwP1LhIyMg30cJ3B+C+i+u6AWPfDry1+qaJKNOJ7dgW9CHGyUftI0fwqKWLnrmP3e267WzZXQj1SM1oc/UH0Q1iFvSm7974Rlm7792s4HV9keWumsIY+tHN0T4+KLrek50YONIWiRaPP5Fi4VLH/Uq1bUI4imzIoBFjV36+VRUWHxB1BMpVKv56ItzGwgR4FT931ZtShTz41gsFAfr/kyBpo1QiTUjQeTysqN+8xjQQ71zivGXSfOmQ9jaunUY3fH3VNAtgO12wFPLR95VQUZCtgHEurZuvV+1ovPDdh8K/g==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(396003)(39860400002)(376002)(136003)(366004)(230922051799003)(1800799012)(186009)(451199024)(64100799003)(8676002)(5660300002)(66946007)(316002)(66476007)(478600001)(110136005)(54906003)(26005)(6486002)(6512007)(6666004)(2906002)(8936002)(7416002)(2616005)(66556008)(4326008)(6506007)(36756003)(38100700002)(83380400001)(41300700001)(86362001)(473944003)(414714003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rhRtxSn6SYUSQ4Ow+WkojAPUbvqBAMucOpUFFcb6yUG5Ef3oNspDN8z3fNhx?=
 =?us-ascii?Q?AhXJEe1HpU5sGkOPPlfyQOpk5nFw8EU1Gd6QKCMrddKu/jjdSmikTq0z1fGH?=
 =?us-ascii?Q?7CYgjPwuD0GK1VgscpFFltAKFtiXu0xVEuM62iLVfNa9ibkzdXwPvb9txSsD?=
 =?us-ascii?Q?kkdpU7vKpYCT8iTP5q82sxvCNf0F7bsfETYg04lkGha4lJcG2FfF8k719LzH?=
 =?us-ascii?Q?lbRqZ5xmIndTetO7gYNmHfqjl9gxuJNBfx9HQUXBDeRHhNLWk/t3iR5jgmKa?=
 =?us-ascii?Q?9hc7iAlJyIf6ArdGg4eF7SfWDVv+B4VEfpmL8W5okgg9F+/pCQsyAPg67XPE?=
 =?us-ascii?Q?4/gGjv7Q/ueQoOkpc3K0nbB6ZCrV+nC+yf/lXvfqpjR0y5oiBjjmz5tqyTVV?=
 =?us-ascii?Q?BuuSuuFmQb9EojFdAEk4l195MW7b2d/qPLmgdS/HsmgCAOGYZUAhFg8dggKY?=
 =?us-ascii?Q?YGeWzFwL/qL/uvddfjVPGzh1eKvDEtmSKdSSiGd/6cbQQFGJR2PpgbJ10uqi?=
 =?us-ascii?Q?lOZzipbKq+9ZG6Gjn1+IHw8wQMjydA/ZG81BOcIDjLb4qxU6lzZXeKUKR+fU?=
 =?us-ascii?Q?AYoPT83jCPHgDUwqjk+UuovzkX+5GS45tjFtdmni3HsVDUqkA7lSQ06nBbuD?=
 =?us-ascii?Q?tPz6hhb3FktOTTfoGLLapGakwbwqhveHdh23ldfNFTD5yVzEe+fuEumBa5k7?=
 =?us-ascii?Q?ZarT77rVUS1RfkZ83c7p5HNImsr3xBR95yr6LFpDGNPe5rqQWCJ3hZ/mcdqO?=
 =?us-ascii?Q?pcdBCDMjIvRcrJXCmFRt9BqPRYAcUoO5O1NZV7dUhSsn6dri5EG4ctjzmhyn?=
 =?us-ascii?Q?QT4C9O9G4vNJNzb7keRJsH4XiwqbGQ7kFPQCzH8PlgxObvDO6s2mGVPJ0CJP?=
 =?us-ascii?Q?KKp3T+6McWKqwBCJeEbrl6NvKIaYvgf6ObBmmsjUFfmguFqYC7+IC05GaB5d?=
 =?us-ascii?Q?Moygm1visKzjoNm+DhlvuYDpA1UxK544hxpGGugbs8my8Cegyuke/d+vSvw0?=
 =?us-ascii?Q?OfcKBg0DCEwoe5OeZi6TsbxV9tSj4GHGoQe6uVLX+8U7wKtjoUIJUk2G4K3J?=
 =?us-ascii?Q?9DP6s+hRUp4qsgBxwVkYJPHeG3YnuNAElJMWyv+050reZFsdeCcK+kHMTtFa?=
 =?us-ascii?Q?r0vAOomg7O184ChsX/drJMszFIwZZKJ4+KIgnuebvWRMYJYHE+zVwjBe4NRA?=
 =?us-ascii?Q?+ooP+JaEqlUywwM5HXJnm2TEEF86IjN2QKTf5Ccuo6kdhiieL/77lRA/6ID1?=
 =?us-ascii?Q?0r/78Wr7AIUIqnfq1c++X7gxXn2K8g90a4TxiGwsTiZ17jzBC5lusIc5Xm1j?=
 =?us-ascii?Q?HZvrKC/2A7QTb+zSL/KgB5QaxkzNM/O5wz4tYW4bTK7JYMV4vxJrwjNs2FK7?=
 =?us-ascii?Q?AzCSeUpkopn3KG44+zRfb6P6fqjbWp8s5PRC2OiUIwx4MCmw7T1gjNGx31Um?=
 =?us-ascii?Q?Kttuan6cK7RMjQ/0PF7fH4ZJ/31Tb9tf+hRjrKmMci9czvbRR0ovYDvd5DRW?=
 =?us-ascii?Q?GMfbc2MBiXBA7nfMk644LkyunUA5VzREHfTYuMvrpvgaW7zGHxi8cs2T2TMN?=
 =?us-ascii?Q?xr+qbImKDU0WtMovjPUlVuAofSBRQaP4PsHTTUvT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a27fed98-b192-46d9-9f52-08dc1e9ac90d
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 18:15:32.7768
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: on/gjXXAKK2nVrySuYA6QXXBllXQhycp9cJO0Ub5EVLT0yt8KZz8vMDHzMPU8Vh+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7185

We no longer need a master->sva_enable to control what attaches are
allowed.

Instead keep track inside the cd_table how many valid CD entries exist,
and if the RID has a valid entry.

Replace all the attach focused master->sva_enabled tests with a check if
the CD has valid entries (or not). If there are any valid entries then the
CD table must be currently programmed to the STE.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |  5 +---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 26 ++++++++++---------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   | 10 +++++++
 3 files changed, 25 insertions(+), 16 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index cd0a8c721d9fba..6d54a6105ceadd 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -433,9 +433,6 @@ static int __arm_smmu_sva_bind(struct device *dev, struct mm_struct *mm,
 	if (smmu_domain->stage != ARM_SMMU_DOMAIN_S1)
 		return -ENODEV;
 
-	if (!master || !master->sva_enabled)
-		return -ENODEV;
-
 	bond = kzalloc(sizeof(*bond), GFP_KERNEL);
 	if (!bond)
 		return -ENOMEM;
@@ -638,7 +635,7 @@ static int arm_smmu_sva_set_dev_pasid(struct iommu_domain *domain,
 	struct mm_struct *mm = domain->mm;
 	struct arm_smmu_cd target;
 
-	if (mm_get_enqcmd_pasid(mm) != id)
+	if (mm_get_enqcmd_pasid(mm) != id || !master->cd_table.used_sid)
 		return -EINVAL;
 
 	if (!arm_smmu_get_cd_ptr(master, id))
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 53b2d2b35a440b..0c134d535401e5 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1245,6 +1245,8 @@ void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
 			     struct arm_smmu_cd *cdptr,
 			     const struct arm_smmu_cd *target)
 {
+	bool target_valid = target->data[0] & cpu_to_le64(CTXDESC_CD_0_V);
+	bool cur_valid = cdptr->data[0] & cpu_to_le64(CTXDESC_CD_0_V);
 	struct arm_smmu_cd_writer cd_writer = {
 		.writer = {
 			.ops = &arm_smmu_cd_writer_ops,
@@ -1253,6 +1255,15 @@ void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
 		.ssid = ssid,
 	};
 
+	if (cur_valid != target_valid) {
+		if (cur_valid)
+			master->cd_table.used_ssids--;
+		else
+			master->cd_table.used_ssids++;
+	}
+	if (ssid == IOMMU_NO_PASID)
+		master->cd_table.used_sid = target_valid;
+
 	arm_smmu_write_entry(&cd_writer.writer, cdptr->data, target->data);
 }
 
@@ -2714,16 +2725,6 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	master = dev_iommu_priv_get(dev);
 	smmu = master->smmu;
 
-	/*
-	 * Checking that SVA is disabled ensures that this device isn't bound to
-	 * any mm, and can be safely detached from its old domain. Bonds cannot
-	 * be removed concurrently since we're holding the group mutex.
-	 */
-	if (arm_smmu_master_sva_enabled(master)) {
-		dev_err(dev, "cannot attach - SVA enabled\n");
-		return -EBUSY;
-	}
-
 	mutex_lock(&smmu_domain->init_mutex);
 
 	if (!smmu_domain->smmu) {
@@ -2739,7 +2740,8 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 		cdptr = arm_smmu_get_cd_ptr(master, IOMMU_NO_PASID);
 		if (!cdptr)
 			return -ENOMEM;
-	}
+	} else if (arm_smmu_ssids_in_use(&master->cd_table))
+		return -EBUSY;
 
 	/*
 	 * Prevent arm_smmu_share_asid() from trying to change the ASID
@@ -2815,7 +2817,7 @@ static int arm_smmu_attach_dev_ste(struct iommu_domain *domain,
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
 	struct attach_state state = {};
 
-	if (arm_smmu_master_sva_enabled(master))
+	if (arm_smmu_ssids_in_use(&master->cd_table))
 		return -EBUSY;
 
 	/*
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 174e9f080066cc..69351386dc1441 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -602,11 +602,21 @@ struct arm_smmu_ctx_desc_cfg {
 	dma_addr_t			cdtab_dma;
 	struct arm_smmu_l1_ctx_desc	*l1_desc;
 	unsigned int			num_l1_ents;
+	unsigned int			used_ssids;
+	bool				used_sid;
 	u8				s1fmt;
 	/* log2 of the maximum number of CDs supported by this table */
 	u8				s1cdmax;
 };
 
+/* True if the cd table has SSIDS > 0 in use. */
+static inline bool arm_smmu_ssids_in_use(struct arm_smmu_ctx_desc_cfg *cd_table)
+{
+	if (cd_table->used_sid)
+		return cd_table->used_ssids > 1;
+	return cd_table->used_ssids;
+}
+
 struct arm_smmu_s2_cfg {
 	u16				vmid;
 };
-- 
2.43.0

