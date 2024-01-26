Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2089.outbound.protection.outlook.com [40.107.237.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A92120B27;
	Fri, 26 Jan 2024 18:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706292951; cv=fail; b=qOXqofcxUYThh5nG7ecl1ME3cPcjDJsxQtvpultglE/bkqpfLeFl9lOIM7MvFuKD4kLp04Fjf0LVcig8Bw2MF3Hy6GquJFR7ake5RjOEZmR3/ZgjdDHTjMScqxNOkYj6bVYG+ak7mq7Tx9Im7vgNv0PWJijxO7eYKPUoqORhubU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706292951; c=relaxed/simple;
	bh=Ht2+pzU0ZuhOVi6wt3ucyiKnMuGEys1OkEiydLDnD8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YL8qNhLQOZF0jcBkBffT9sliWcfTvNtrr8KPfvNcMhuMi/CUrj22IK1Yf0XCqW7z8tfNj+reJd3lvUaKDNKNJMM/w+Am4lsa/iUf4P3QRxxLJmTZD+OXbawIJWLRjygw08EAjucTLwPwyvIiVXhOSJTHRSzXxrO357vvtrZgrow=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=e7FELPIe; arc=fail smtp.client-ip=40.107.237.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="e7FELPIe"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LuayLAXZ7zmaFNjxKOyQ9fWSo8Skgwwc0NXiKDL1vFAu8J+6yX12sURGfbpDXb1jtz+J91iZKJblZ5xw52NmOj/mPwqC4RCFTIHYWbg0kAEufoXy5ASJopsH/I4eGdrUgDtJjhELnK+p4GjE5UI2/FpIdFUsa8xdTDcMV0yWbbwb3gRABFbtTX8KyjcLXfSN1SZhiR5zcCWuFIk6f00GHGCEt/ailSODmEOyiGRzNLIXYfIm5ZW72ksd3c+5co6cTg5kM66R7K04GIx4MVAREtwhPWEl4+n1j06na5Q3141uMSh/S5QnMGzl93OGZBBEObOPM/kn0fzvU0Kjr/5Ovw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EAI10d1ZqPf6FpJhcLv8dUhoBM6CfFKGFC/Kx3f70lc=;
 b=hZCSB0ckQJaV7SrHijqN44gHX6Xlo7Txy1NsAFKdV0Bow6ggow1OZFMyFiyvXRKN14CglfGppThIsX31Vjq6jHSP+tkdj33ApITkRWQLWbWmbIW18L1RM6/Yv4M4j8KluakLo0hhk5zRnkum8vBsAIaEGtuw62udWfekJmbp0Q6zGEXXt/QtA6mRo3MeDUx64njwlvwVbB06PZqSIk5VR03HFIJ+8Rwnpf1WyoJG/dNGxFHijVWD0+p083K5CCDmobWuQCshIJSAszT2fiRDHooJ1fPRVKB0Ec8knvfAjD2LKz2fWYQEoze02EOvTqQ/+CTvDcF90IA7VQgB6ARi8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EAI10d1ZqPf6FpJhcLv8dUhoBM6CfFKGFC/Kx3f70lc=;
 b=e7FELPIeCMMksX5FbHUOGlBjqBps1xzyvTH8eNFqhOQpt6laLB2D4/o6khNeW0TQKKsHYD2FPQSAlxwUs3XJr8sISnUxyD/Eh11mJWP5VFKRFx+6ItmOpzOWS+0GFN94ldcuSFM2PiXw5tGw1vc6IwPhzorzykEsKo1kCFwrzjfkfRbGRqQiofrfWw9cQuURDGawN8rcm/c/MxpsUCHdO9Nv6HupM5kMddvJrpmXPmObIMNIE2McqrsWRR28z7jlggZOTM0Efe0EqFEw2wvtGTlX+gCzAzkPP1NjjvSJHkVXT0mCMJ8ognQTkX55JFBt0dqbTTixJ3Jy9yAJAhULUg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH0PR12MB5186.namprd12.prod.outlook.com (2603:10b6:610:b9::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.28; Fri, 26 Jan
 2024 18:15:42 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7228.022; Fri, 26 Jan 2024
 18:15:42 +0000
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
Subject: [PATCH v4 17/27] iommu/arm-smmu-v3: Thread SSID through the arm_smmu_attach_*() interface
Date: Fri, 26 Jan 2024 14:15:19 -0400
Message-ID: <17-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN7PR18CA0028.namprd18.prod.outlook.com
 (2603:10b6:806:f3::11) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH0PR12MB5186:EE_
X-MS-Office365-Filtering-Correlation-Id: f3c7c6b8-6867-4c6b-e847-08dc1e9aca0a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	z5Jpqq94yXBEFshrR30jSjTL3Vug4nikrZYmANMoMxFOF07qtIA2zUX6oBN5LCaGdXBwTtEiYFVE/X/Q8p8Oqc6IN2DBMiqNDv5CzJb3hjx36PYw8u39IQrtiPLnDinvyApN2CjkQPJId02r8zDPFgUsE1eNej0KLQoK9Nur6bL87aAHhEDDeNdJi2QAtt19xCcHVSF5UO/s7+YRLNXmGDWoCx/zLd62LNQN4h5PQYdiEAVuzZL6SNrtu8wckJYD9NJ452fzkrflLmkVeD0f9VckU+C5ftxWi1ZWOl9d/r9Oqgo9QswGg+BeqD4bg5XolkZw0/PJpn3Zwn1axF0PWnMuZ7q/y+qt/qGPtj28wfVUY8QwR9hi0bOB8aAKYDs/2MecsqGZonorfumumc693BJR4DwRSKnJ6U9y++T68jihYkZEQi41qJ3y/hwqtrKJYtE1GqfW6cJ1V7NQmUct3dbFvDbrQAYWtRT+1e5AGBZVXaXks0rS2P0KurgOYrU09L8LIst0mVOJbXOJRXlBrwLm6UWkj5YcP7qV4yS7ZHeBog1kLzlEm+Q3yCDmpQ3Y
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(346002)(366004)(396003)(376002)(230922051799003)(186009)(64100799003)(451199024)(1800799012)(83380400001)(36756003)(86362001)(8936002)(8676002)(4326008)(5660300002)(26005)(2616005)(38100700002)(316002)(66946007)(54906003)(110136005)(66556008)(2906002)(7416002)(41300700001)(6506007)(66476007)(6512007)(6486002)(6666004)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gbbJG9P3LpR+e2SNP2nmCeN9U9mzHxszWo/aenckQXnNGjFHyxk4QGAR/dA2?=
 =?us-ascii?Q?RC5cQlE+UfvRQ7yuZ1qvn576T+0D+wxIKV/p78kZagmSJ+ymEe5hVxes8/tG?=
 =?us-ascii?Q?1hAotfDq9MpQVgktjeb4/jsrf9rGH6jAXvrv63gvlSypNj7g6D7bl3b0HAQW?=
 =?us-ascii?Q?QGSDxpqOgkwyCeZS9v1rCmuJ6pqbtfyVro+IRrgMF9Ie/oCEwF6HbhgfCTXV?=
 =?us-ascii?Q?wNvUoGSzsuINCzRly5/x6tI4gQngFIvozq5dsN4maVtPtYnEGvY7M6N44O3O?=
 =?us-ascii?Q?QGbdEdO4ztt6gfL4QT00OT3UZaitYDF6PaTgkaRpn/dfV4OV356KQgvnVB26?=
 =?us-ascii?Q?yEkK4S3PSL897E1swYfaLZwK8qoYdmYK0fskx2TQpXfRcZV6+vXfCqCOYexw?=
 =?us-ascii?Q?tQ+dp0lIpinH+Vgc98Af93OTbqHN0QvW+M2LEPMt/LC0GpzxPC+5FOKesN60?=
 =?us-ascii?Q?bci/zMz7xXrVDQ2VEOGt4sKN7naV7KySnUEMohm0UghGiB3UnP6UxFCCXIJu?=
 =?us-ascii?Q?QL7/HhtlIrkzAvNE77sK80oOebr6i0J2032QniCUvxQ+wwpubP/jADXGUUOd?=
 =?us-ascii?Q?CPx2bg3AUg29dPnpSmWKBEqesjs3FZyIfQxbUYp6sGmHBHyQ2xrsWi6Qwr7n?=
 =?us-ascii?Q?zqlAxiU8dbVC9VbGz6xrGRK8nvdSkqm1D+wmg+Owa3+9XUSKl+cu39e30bs/?=
 =?us-ascii?Q?OBrA/co/iIayYeScoc32zXv+XUUG4Y29t+t5IsCk5B67PwTYO8kfw4JHSp/H?=
 =?us-ascii?Q?kadJUsSvIqZ/+/nIKXKfbx5AMtT2i3IcjGk0GkNqGX2tXcmmL/vrwgi0yd59?=
 =?us-ascii?Q?98amLffZd1AFFyiRpGvmaCUgQoOQgI/iA7oxSMjoGZHb9eAK4trgId/o5WPD?=
 =?us-ascii?Q?Cbh/0ILiKOLEBJ7pXTgBFR7dF1+p9+Hs+lUp+JHeC8tMbTsiKrhTLBc1z72J?=
 =?us-ascii?Q?Ip+KoirPFxfIk/rH89fJMdGHxCIfB+/BM4p2WmLZIwPdpb1qRR8Lvy2o7Geq?=
 =?us-ascii?Q?TSg2cH+HCZWvMniSOJKF/+3NuIo1vcILqy/ZKFpgVsuO/ne6Zz+IOH94wFIE?=
 =?us-ascii?Q?uTMGmy4E/iVYBVf5vZ7IPfW8tEPlZXlIs4gYMgSNgy2g4hYNjhsJVb5WetVm?=
 =?us-ascii?Q?dswdirAvOusjwjtLpwH4rF/5TCRU8jfzdc37rRY8cOk1Yix7roJOwYRwGLgc?=
 =?us-ascii?Q?2Vtg7ngP8b7AKRa3TCK2RYCLAj1HWdsyr7wJcc6hDtnisQPp21n4AX2FD7sh?=
 =?us-ascii?Q?casaUmHiMAeLPa6xK16Xaw6hEsmtBjqclVLdKyun1KtGpisfRm+FmgA+AZfE?=
 =?us-ascii?Q?q2E9vzrChb/VdbQDvzXOjED8m0Ygx769Ba0vv7bA6Q7+vaeDh5LU+X5kxrLY?=
 =?us-ascii?Q?H093DDx5oe7++1l/ByOWUGUw3+2L6VDn3l8TSa8eRsaTZVq6fKyy4mSb3Pxt?=
 =?us-ascii?Q?lk51zMuxZtI9XyhGEHEfmbZvN0+n3f6OxbRdrZukniBMje8JG4cAsI0vDkrN?=
 =?us-ascii?Q?vz54J9ZcpUtT/Deqge+DKAu/iyEln5iK224jiKONJ+p7FcmXFSY/q3A8FWwW?=
 =?us-ascii?Q?bRtFrF4X3BjxLV5rWFc+I3y3audHRAX9dBOBNLSR?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3c7c6b8-6867-4c6b-e847-08dc1e9aca0a
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 18:15:34.4350
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jltUHbsdPCFSHmUT6GXjct4dlbRC/I/mxLTppTjeBBpb3WhAUOC8pSvYYLgAB23n
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5186

Allow creating and managing arm_smmu_mater_domain's with a non-zero SSID
through the arm_smmu_attach_*() family of functions. This triggers ATC
invalidation for the correct SSID in PASID cases and tracks the
per-attachment SSID in the struct arm_smmu_master_domain.

Generalize arm_smmu_attach_remove() to be able to remove SSID's as well by
ensuring the ATC for the PASID is flushed properly.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 28 +++++++++++++--------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 0c134d535401e5..21b0ab9c2ba763 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2013,13 +2013,14 @@ arm_smmu_atc_inv_to_cmd(int ssid, unsigned long iova, size_t size,
 	cmd->atc.size	= log2_span;
 }
 
-static int arm_smmu_atc_inv_master(struct arm_smmu_master *master)
+static int arm_smmu_atc_inv_master(struct arm_smmu_master *master,
+				   ioasid_t ssid)
 {
 	int i;
 	struct arm_smmu_cmdq_ent cmd;
 	struct arm_smmu_cmdq_batch cmds;
 
-	arm_smmu_atc_inv_to_cmd(IOMMU_NO_PASID, 0, 0, &cmd);
+	arm_smmu_atc_inv_to_cmd(ssid, 0, 0, &cmd);
 
 	cmds.num = 0;
 	for (i = 0; i < master->num_streams; i++) {
@@ -2506,7 +2507,7 @@ static void arm_smmu_enable_ats(struct arm_smmu_master *master)
 	/*
 	 * ATC invalidation of PASID 0 causes the entire ATC to be flushed.
 	 */
-	arm_smmu_atc_inv_master(master);
+	arm_smmu_atc_inv_master(master, IOMMU_NO_PASID);
 	if (pci_enable_ats(pdev, stu))
 		dev_err(master->dev, "Failed to enable ATS (STU %zu)\n", stu);
 }
@@ -2593,7 +2594,8 @@ to_smmu_domain_devices(struct iommu_domain *domain)
 }
 
 static void arm_smmu_remove_master_domain(struct arm_smmu_master *master,
-					  struct iommu_domain *domain)
+					  struct iommu_domain *domain,
+					  ioasid_t ssid)
 {
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain_devices(domain);
 	struct arm_smmu_master_domain *master_domain;
@@ -2603,8 +2605,7 @@ static void arm_smmu_remove_master_domain(struct arm_smmu_master *master,
 		return;
 
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
-	master_domain = arm_smmu_find_master_domain(smmu_domain, master,
-						    IOMMU_NO_PASID);
+	master_domain = arm_smmu_find_master_domain(smmu_domain, master, ssid);
 	if (master_domain) {
 		list_del(&master_domain->devices_elm);
 		kfree(master_domain);
@@ -2617,6 +2618,7 @@ static void arm_smmu_remove_master_domain(struct arm_smmu_master *master,
 struct attach_state {
 	bool want_ats;
 	bool disable_ats;
+	ioasid_t ssid;
 };
 
 /*
@@ -2648,6 +2650,7 @@ static int arm_smmu_attach_prepare(struct arm_smmu_master *master,
 		if (!master_domain)
 			return -ENOMEM;
 		master_domain->master = master;
+		master_domain->ssid = state->ssid;
 
 		/*
 		 * During prepare we want the current smmu_domain and new
@@ -2700,12 +2703,15 @@ static void arm_smmu_attach_commit(struct arm_smmu_master *master,
 		 * SMMU is translating for the new domain and both the old&new
 		 * domain will issue invalidations.
 		 */
-		arm_smmu_atc_inv_master(master);
+		if (state->want_ats)
+			arm_smmu_atc_inv_master(master, state->ssid);
+		else
+			arm_smmu_atc_inv_master(master, IOMMU_NO_PASID);
 	}
 	master->ats_enabled = state->want_ats;
 
-	arm_smmu_remove_master_domain(master,
-				      iommu_get_domain_for_dev(master->dev));
+	arm_smmu_remove_master_domain(
+		master, iommu_get_domain_for_dev(master->dev), state->ssid);
 }
 
 static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
@@ -2715,7 +2721,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	struct iommu_fwspec *fwspec = dev_iommu_fwspec_get(dev);
 	struct arm_smmu_device *smmu;
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
-	struct attach_state state = {};
+	struct attach_state state = {.ssid = IOMMU_NO_PASID};
 	struct arm_smmu_master *master;
 	struct arm_smmu_cd *cdptr;
 
@@ -2815,7 +2821,7 @@ static int arm_smmu_attach_dev_ste(struct iommu_domain *domain,
 				   struct device *dev, struct arm_smmu_ste *ste)
 {
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
-	struct attach_state state = {};
+	struct attach_state state = {.ssid = IOMMU_NO_PASID};
 
 	if (arm_smmu_ssids_in_use(&master->cd_table))
 		return -EBUSY;
-- 
2.43.0

