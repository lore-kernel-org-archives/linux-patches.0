Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2082.outbound.protection.outlook.com [40.107.244.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB12986151;
	Tue, 30 Jan 2024 16:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706631184; cv=fail; b=kz8j8ClVF8N5jUn/8MUtCSyOkfUtaejyIdY43hTBAKPFLN0jq2Jt2rtMPMkvCi2TVnYcqbufs2HIxrpDdDv/S7osU+Jgj16wsC/JDeOIAZ5bsX46MDS9x3DICCE2E5xIyHAHNGm2hUrrGNNO9zZKcYju5T07GPT1OJaKy0Nenac=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706631184; c=relaxed/simple;
	bh=RECv07udSiOGXip60sABq3sXBNefR3kNy7Y2Tja2CJE=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=qfJzD9CI7DxE4z4fsxIbsfX0535aQAZcjV7sXOQqnH2k9JwmYqaDlZRqxwlud6IoW7o4gx56G19AwkJ/Tc28yOF9afcrhBVPXdGr2LhNsExTPFc2F6aHu2iLq51hDqzk7T7dExFSjsGtDra1EjjQHE//Br90S/pjh1tueuIT8ME=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=o1MWnhLx; arc=fail smtp.client-ip=40.107.244.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="o1MWnhLx"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pv5ELm2w8Py1saqqtXIQ0zq1J7xr6RzBJIG/hr7XQmWPipU55Oq4hoALBudfmvtWhbLQIAXPdSRSWeZMnr59aYuwm8MJbWoupv0OVf0U/08mclO5Ust6+q5fcUnn2Hvi9tRmMIxnZI7iDeQBvxHvxSI3rF6kLvarzeY8GdV4M1czxhyWGKCLkUkDWgsDsEJT/9XuPTogcogZd2Csrw7YLJGoS2nNUKpvGm7zBvdEGiWFk0714gXd92NTu075cNrYn73K55Sc17njk2oWrAHJkOfS3LXhWStFpDeonnCUkfcbDQuFhjmQWQ9f9xCoo133gzK6Uvcun0VyrfRcwSqGDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SnAE61WIm0TG9C/1RqPdt1qXJSLutgK8OVAx5/nBiNE=;
 b=UabKjbXQzyH05Nq2gByjntV73GMKlXc/1oY1DPESmon7P4OvO31yz0rFOEbsluAc5hclaLGLrBde6wCYyMTTgDXLecwtdEgVbALTgU73FVAgbfpni/Ytp3Qkd1jJ4GwEa1LXvyBr9shEXqTWDniFuCWuPuyZatijTbQVZV4i5qxxi0OiY8YjcQuHWU/q/upNiUQlrXFN+Vs/Fd2nH0lpjo+QYAfpgAYd3Vtpf22UErJ4oDFlle9Pv3dxObl0QZoY9NQli2/nZ0Yb3r0kS2IW0cv0tVM75vigyDWfvFYuwRQZS+r0ZwgoVxKAaZdJypZ31yP2jt0WveRyYEwMuZ08Jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SnAE61WIm0TG9C/1RqPdt1qXJSLutgK8OVAx5/nBiNE=;
 b=o1MWnhLx4QmJTCN+8+ulIJS4fdfkIKrOT9YYauHbAit8PsoCxFZGs0KQX42Nyiht0778gcmrYyusI7yF78H7eGyUGoENzvDeG4go5dgcLwoBCWhZtYDgnuCpqUb4f33pwBtfnY+lDV16plZf660z2TbSJwOooK7x0EWnHJjsOrXi5pwiI6mcHyuU/SCgLMSi4V5t1v/9XO8+LmEv0roHEiuyhz42i/VroAgp6C+0BMu3SSnaPbr+cc/BDJkwh50q8Kjc9QyKhGYLoI7gdJkZUstOHhDthQNtPgEYmbQPvyxLhfUgAlcb+fal/ClLUnqZZFfaAiRr4m5sopovqv7Dnw==
Received: from DM3PR12MB9287.namprd12.prod.outlook.com (2603:10b6:8:1ac::18)
 by DM4PR12MB6662.namprd12.prod.outlook.com (2603:10b6:8:b5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.34; Tue, 30 Jan
 2024 16:12:56 +0000
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM3PR12MB9287.namprd12.prod.outlook.com (2603:10b6:8:1ac::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.32; Tue, 30 Jan
 2024 16:12:54 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7228.029; Tue, 30 Jan 2024
 16:12:54 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Joerg Roedel <jroedel@suse.de>,
	Jerry Snitselaar <jsnitsel@redhat.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Ovidiu Panait <ovidiu.panait@windriver.com>,
	patches@lists.linux.dev,
	Shivaprasad G Bhat <sbhat@linux.ibm.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Steven Price <steven.price@arm.com>
Subject: [PATCH rc] iommu: Allow ops->default_domain to work when !CONFIG_IOMMU_DMA
Date: Tue, 30 Jan 2024 12:12:53 -0400
Message-ID: <0-v1-755bd21c4a64+525b8-iommu_def_dom_fix_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0167.namprd03.prod.outlook.com
 (2603:10b6:208:32f::23) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic:
	LV2PR12MB5869:EE_|DM3PR12MB9287:EE_|DM4PR12MB6662:EE_
X-MS-Office365-Filtering-Correlation-Id: 4fa624eb-2bc1-4c1d-2857-08dc21ae50c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ZPyrsv+qe49sqc6mLv0ZbJg6ii5H63b8+UAIUJ/jOk4Z9YbEQ8dgMsrWrlDKKe6pPMw6BWc2tbJGeFIdqADISx7oDhLaZ/CZjGBGESUqO3axnh/8+fKHLJy1ofBCWMANr+TFqfbOUeXorCKL0hKD1+hayVvUNB/31qjjWmHE2E46bt4Hy9NCODo5gEV3/r2JweVQwBO/Suqe4/vX7L6Bb0i6PSm4hlP3thGpWjU/V3jMp5u9Yf5GHBq5a1D3WalENl7vAQchEf8hAuSjgiAxn5194yg4wWBHALtM2CMa6clbig3n2Cb7r0qqzn7+HkX20QmdT0QgZZZMJT3PsD2d1zrVgZ9yOHVdkhPppSNcbQwYsad4z8mIa806Z9DvMFAwkmsSzM6CDfeuX7EX6nXnlEVGzujwjvieSPInYJRH2zkLZY3wdqtoB15rjb/gOMqaOBqD9fyRM2QKLSdTRfDl177ewQHT/imNLAjtkfCCJy0LwN1RL/6H9mBctgWOGnTHQ/vrbtzhmULUaSVLs6UqKWDLROvrFAq2xnKwePR/avPJgOL4ff7TwihcnJ+m7flJ1VZ+KDAe8JD8ZOnYTU/pK56r6nPdlZ5rXFdiCeqpHuE8p1LSSP+s7Z1RcE+d3+JA4zeZ89vPXvAE8CGqTSSpMg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR12MB9287.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(366004)(39860400002)(396003)(346002)(230922051799003)(64100799003)(1800799012)(451199024)(186009)(41300700001)(2616005)(26005)(83380400001)(966005)(36756003)(478600001)(6512007)(6506007)(38100700002)(6486002)(86362001)(2906002)(5660300002)(66476007)(66556008)(66946007)(316002)(54906003)(110136005)(7416002)(8676002)(8936002)(4326008)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cbdtDfp25VOP7ywOGoD5x1mT5WiNEvWNAUyQWJtT0dkYCONQndrPDme+nSTk?=
 =?us-ascii?Q?bV67sKOz+TdtgEdx+7niCNlzvTBwdsPDJbJTiaUjT4z04j2v76xFOzKamaOA?=
 =?us-ascii?Q?3+T6o0rknul2FtjP6qUm95rxLxfxfk8NCI/biYipT65le75Y/4+r12aZTA/x?=
 =?us-ascii?Q?qb7JlYvpz+kkGxVq0kVEl3ov7jfuydZ+bl1xwuGn83NrN0+KExpd5l2yp8uT?=
 =?us-ascii?Q?LWLVEPPV2SM5B9Rf88tSX2l1hPmdAlewvGvNYLLM0Tjb7o2f+zW3nZ2obxGu?=
 =?us-ascii?Q?vGH3VWsRhWSzFnQ8f7yp0FBIurugzMsg5atfOJp3jbqPrmCKBZOxWxILfndN?=
 =?us-ascii?Q?UjD56yQaNm0hRPFvSZsTEJBW/xqvIrGD0NEns0uu1xpNAS7fNSpyA9veJ48K?=
 =?us-ascii?Q?eczBmgGPOYSLE+dBxAAqExUFJgJ+jmov8ASsoMLrtQVrvQaUhXcEvZvuvpac?=
 =?us-ascii?Q?c/Ka/FZClhbrtBWZFvclcmHrIRtw5KvUiqRDDAPTvziP8uQMOQyoKeQexAut?=
 =?us-ascii?Q?AcuR6rN+ikAw5zeXyRLADx4Lq8ce3I7LJaON1PjWUFGQNIlMgLeCdOkvg4MY?=
 =?us-ascii?Q?bLY8gXL6bb3Yv0eO4eqHEOhCghd4fFiKLb4qTcq/R5jvcPvwAFJHbZ6rR0aL?=
 =?us-ascii?Q?QsEAPOD9anZSuuqIRJotyOFO7F+xrPCo9RMef+ScmfrN7WYaaMVk/mcWAKMm?=
 =?us-ascii?Q?/1qhYmmzBHlZ9XU4XURBGaLSR44BGqAZhzwgKa+ySR6yAf1+aWyF6rqy0KOZ?=
 =?us-ascii?Q?2ltmzkmYdxDrZNPAy1KHThHBXthWNcJ/HDs2N53fzz7dHTPO2EWCy/F2QCZP?=
 =?us-ascii?Q?SflETLv5s24tqx+ff6Q1Eak/OwBZkj+mRy4apPttG0lCCgNmZJ6KDz78iQEq?=
 =?us-ascii?Q?z+Zfp6VN+L9uNP4WgM0H0mi683CfJVNxQeWdXxP769x3N+L8uJV1Pwylnd75?=
 =?us-ascii?Q?cdET38A0XcQW8DLmJ5Ob2a57ZMzUtNsmz+5HTIHMRXcBoFJ+Lhs1QwLQFjSS?=
 =?us-ascii?Q?0xC1hpFVmDdqFd+b1lgKyiJ2VhNGMv1Mqkw1oDVjsVsIYnikC2VmM4f+pTXM?=
 =?us-ascii?Q?yzPynPqFb4Tkc5Y/6aJm2O2qyXd8bafS79F3OhgYr5qMwz8fvY0KJ2vML5J9?=
 =?us-ascii?Q?WnA5EJLNphgROHn9Il6gV0TrBhyq1JA4Hu7Td9czwiY8Xj1PKiagAimRrJ1P?=
 =?us-ascii?Q?kaK3q+fSlmCQCgsgaj+hejWvmMe9gQaUy7rRqlnI1s67g7lztG0JVz6c3d03?=
 =?us-ascii?Q?Fk3K3aLw8UHjatFPq4jGLJmX1P8W11L07mjaaACI2DwFj8KwHRfXHvjgeZuV?=
 =?us-ascii?Q?54PlyqdDUGL5qWqtHW4UTvRZIgISusEGeCVSPqrRyYPwPvIhTp18MlGr4ocF?=
 =?us-ascii?Q?wBw2qcCTQpu1RKXHegoQgiWO8R+hM737AwuGC/jfhXFKxM60ImIt9+ydgs3b?=
 =?us-ascii?Q?0OuUIDCq8s4KR8I63W/H7+mE6QCAwDe1V5DCfHcMmh/UGHWR5xZpx3tsGZHc?=
 =?us-ascii?Q?i0oVlAIgpIDFnUmblnDOjYYzsJwC3slFzcn6hFn4yHm649A5nqzhr/tgQVk5?=
 =?us-ascii?Q?NIsmqvlztdUknvtZLchnJwlocpHvgIJ7RgRxDjOQ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fa624eb-2bc1-4c1d-2857-08dc21ae50c3
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2024 16:12:54.3866
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K6+9z0hnt0g078N5nLcUbfig5zgO9iz3Rfmtz/tvqlin2c+S3SeldgWXnh8Kslzo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6662

The ops->default_domain flow used a 0 req_type to select the default
domain and this was enforced by iommu_group_alloc_default_domain().

When !CONFIG_IOMMU_DMA started forcing the old ARM32 drivers into IDENTITY
it also overroad the 0 req_type of the ops->default_domain drivers to
IDENTITY which ends up causing failures during device probe.

Make iommu_group_alloc_default_domain() accept a req_type that matches the
ops->default_domain and have iommu_group_alloc_default_domain() generate a
req_type that matches the default_domain.

This way the req_type always describes what kind of domain should be
attached and ops->default_domain overrides all other mechanisms to choose
the default domain.

Fixes: 2ad56efa80db ("powerpc/iommu: Setup a default domain and remove set_platform_dma_ops")
Fixes: 0f6a90436a57 ("iommu: Do not use IOMMU_DOMAIN_DMA if CONFIG_IOMMU_DMA is not enabled")
Reported-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Closes: https://lore.kernel.org/linux-iommu/20240123165829.630276-1-ovidiu.panait@windriver.com/
Reported-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
Closes: https://lore.kernel.org/linux-iommu/170618452753.3805.4425669653666211728.stgit@ltcd48-lp2.aus.stglab.ibm.com/
Tested-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Tested-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommu.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 68e648b5576706..d14413916f93a0 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1799,7 +1799,7 @@ iommu_group_alloc_default_domain(struct iommu_group *group, int req_type)
 	 * domain. Do not use in new drivers.
 	 */
 	if (ops->default_domain) {
-		if (req_type)
+		if (req_type != ops->default_domain->type)
 			return ERR_PTR(-EINVAL);
 		return ops->default_domain;
 	}
@@ -1871,10 +1871,18 @@ static int iommu_get_def_domain_type(struct iommu_group *group,
 	const struct iommu_ops *ops = dev_iommu_ops(dev);
 	int type;
 
-	if (!ops->def_domain_type)
-		return cur_type;
-
-	type = ops->def_domain_type(dev);
+	if (ops->default_domain) {
+		/*
+		 * Drivers that declare a global static default_domain will
+		 * always choose that.
+		 */
+		type = ops->default_domain->type;
+	} else {
+		if (ops->def_domain_type)
+			type = ops->def_domain_type(dev);
+		else
+			return cur_type;
+	}
 	if (!type || cur_type == type)
 		return cur_type;
 	if (!cur_type)

base-commit: 6613476e225e090cc9aad49be7fa504e290dd33d
-- 
2.43.0

