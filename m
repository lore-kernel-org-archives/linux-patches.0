Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2050.outbound.protection.outlook.com [40.107.237.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82A26135A7D;
	Tue,  6 Feb 2024 15:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707232402; cv=fail; b=CoZcLG+lxblILFBCT3ukZhjaJov5TxRgtbLCMgPfu4wFpAesW4OkEjpOoLBORyv9uq0HCRd0/Om13GkhDZi5Ejt7EiLKe3Hy64TufWBxxY/j4MLKIgAgUItyCvGNZSm0+Y1IR5m/9M6P6F3TPntf0qXGts9cljiORPGCLIWeGMw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707232402; c=relaxed/simple;
	bh=xgHRAVqW/cFgfV0cCwaamtIR/xYGIsknet0J5pUutQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RQOe5AKfhN/e1EQMALAoPVQGr5UzqVnIPBSwf+CLw7mXf4ATNbTTuXry3K1OLjES+noEI2vKMlEcZcpXJyJ4yXOiPeAYnI7z4WkpDGGhgjeydPq6X9et4hRiJEGQHDGr81fGvvUzDJfYlvorSoVr5XJvv94XZ3kpWnFHMZodzkE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=cJCvGka8; arc=fail smtp.client-ip=40.107.237.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="cJCvGka8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZOuT3pcjWutJC2gwLdSdEAYkaidxADTrIkwrbUK3KpY0YaO4R3f9MzE+4PFF0T2YPZ7COrqIJOV81EI2T9PxIcHoa5toaMaOZnk5pAkmcCjXK/axlZLxaEdWDUD9Fa7SbaFWIDVosnkko3LExJoEVC4Rk509Sd2+qDbQlqv/0wsgVzACH/uABQJT+WjSm6EY3cyOddW/5oSIhbIX+Z1zPGjhJxwVFU/cOWKPniQN5QWy7hhU+mucooJXR5UHieHvCUZnIVtmQPQ1GhNsyIn+hmQ2JhWDfwhRCPXIjNrqE/ta/+B9vlw38zG5YY+Dhg5CIXqMwITf/cRXUMbanM+G/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AmbBf6iGO/chNEbaaFsqN8af+lT4e4v8BQTAP2Gaddw=;
 b=JewzguSVJWK7b9OdNZSDxDKrvAK+7E2tdmjHEESkHhMOTZ5b9+1mF5tB5BMBldGJW855KRNKdQpKIXROP2o1g3NWAixQKpYGXgHF1TdP42WOq2x7FHcsYtsKpIgSuQU3tIaDnZudfOVFq/BYWkPtFk6IggzyJlwdVJxCM9LSo9Qz6490yBXBFofA1y38PKHzJ1v0+Ttu57KP2rhtSbX30qlq6x7bHUu6i57Gq7fSWuOCiTua55UhmcqCfkwp1Y9nqjHPGveuBXFPX4hP3Z9F6xWmKg94r1iHgzz6CLRqEuGueL22NGMWjIXDI8LWVsA75qb4/xzmQ5hqXlrn+i23CA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AmbBf6iGO/chNEbaaFsqN8af+lT4e4v8BQTAP2Gaddw=;
 b=cJCvGka8UuYZYAMU9bZ+yRIwwAwy14vaCqPvdXDukLYDPqcR9dy/q3IBSW6uXxI0RcHseDCqvSLXmybAw4YxKjBY2yRECFCRo5+7Bw7tPKolOAn7HPPT+De+8MYPeD94Py8H/HiznQ7aZ/K3RlMjiTXGq/jQpP4xdg/4NHnTmDofhhCcu7KDZ9kooqjj+ns6io/Rekkxak4wqZkUhLehIPTsjOsrlmohWOKyyfR7JVeC8xvZztkIkjHJU7nO27qcniSzBGMiHPhXiKL2nj+Cswh9giPielYTgumYCpm1Gleg1TZVDlsIxFg0pf6E+vqVAy9Y160H5+O/0+C4ZcWCEA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ0PR12MB6733.namprd12.prod.outlook.com (2603:10b6:a03:477::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.16; Tue, 6 Feb
 2024 15:13:06 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7270.012; Tue, 6 Feb 2024
 15:13:06 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <jroedel@suse.de>,
	Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH v5 06/17] iommu/arm-smmu-v3: Hold arm_smmu_asid_lock during all of attach_dev
Date: Tue,  6 Feb 2024 11:12:43 -0400
Message-ID: <6-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
In-Reply-To: <0-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR15CA0051.namprd15.prod.outlook.com
 (2603:10b6:208:237::20) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ0PR12MB6733:EE_
X-MS-Office365-Filtering-Correlation-Id: 0997f36e-eec0-4a52-94bf-08dc2726192e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	pxALT3K8oe7CU7pgoNLqTctQ8FUsORd82wiKL2VA46/S9w4jdE4SAY3A2ruiukXX8qgvFOvqgLdzd/58+tfcWFXDFq8VC19N/2knp6R7ATZv8aFKM6BqrHxmqTfCjvELwruXap/fLtdkeXglGe2XRo2Y4uquPulAYsNjAIW+nV2+yjHsCo9UITp01yn8qRQGd/pWB5vs+Qweks4ZcEueL+5PDa7HHkN1bvn5kCVRRLP8uo27UkZ46Bx0xfmqQ2cLjdTOZ/WAGlOxA2Nlh863Ne57HAEO/NJayuq9atm8DTor+d7OuW13iKeCx9YLVRh+moA2SHPQYC4zLcvPfRU8uk9KUAFcQ9xg9Gm49tWxzoB99QGvVkHcp/IUNC3PfQLIy3Obt195ki3GCVL/d5VISVDULjXhz2PacSlcegamL3JbyTvaE2rmLNtnojINZI8X2S+qcA2V7FvD1jUWjHppfRs4o8brPQhCX3cuVLp5WEcHdstY51XiXzurprgQyuU2Jj5MG5MaKkJeHGMCajTH3+5Emi6f6dtSqZIGHDx2jofWXbMeCssHKMpjaf/yyzACz78IjsvsPIWIjLot/al/k93vXKESPphSdvBA7U+J9hk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(39860400002)(366004)(376002)(396003)(136003)(230922051799003)(64100799003)(186009)(1800799012)(451199024)(54906003)(316002)(83380400001)(110136005)(38100700002)(2616005)(6506007)(6666004)(26005)(2906002)(7416002)(6512007)(6486002)(86362001)(5660300002)(478600001)(8676002)(66946007)(66556008)(4326008)(8936002)(36756003)(66476007)(41300700001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lmLi0yUOrbgd/w//zciqV5fz3a8v1Sv6owYpaZn8qsBLvFCMjKV7ABMOVgLw?=
 =?us-ascii?Q?wPhybehw9MaSGa2YHVyL5XDSwT+R0aAwGSFC4aNteg7OUKNr4NPNeu4CuAbg?=
 =?us-ascii?Q?oTzhugzxn+8Aw+bO9a7QeqBI0vCwWSbEzOmlteSnV+q7peK7b8Z/j0QCRUEh?=
 =?us-ascii?Q?ZkZIBnm65spLCnh2ZlEZshFkirB0ts+5zBBB6a0mc+fG15SQMg04FWdYVPcC?=
 =?us-ascii?Q?NJsp4npTuvtH5SX1sl1mN3dk+7CW8WlqpB8hTR4aKk/GZm0cWcuaa61o1484?=
 =?us-ascii?Q?TiUv9TndvqIf1bUo30DeAOabpEvoCEAbuwvA4mN1hRGjNFenY1mY+hm0Ewzw?=
 =?us-ascii?Q?b0q6taIJIOzeXWlFWfkNGfpN3/QIGAcBegT6L3YNu1SXG/d+zXKsfMe2OW5y?=
 =?us-ascii?Q?IsD5YmR/5nnU3xUVryivPjQlkhlGPH1krzy0IUOgwMpnE8F78pB2U5vaDleJ?=
 =?us-ascii?Q?BV1WJlpRXsxZ3VxrbNrv+R4m0uAsCIK5gHTdEDRiWSyOxAYnBMZGl75+4HJI?=
 =?us-ascii?Q?bCVpFAYW0GtZun7VNgFoSnS9NW1+M5BXztA5l8sbw2rs28YKvkcYvRNpaC+r?=
 =?us-ascii?Q?nRm/0CA9JGvddX2tvm/1zsHeeudqxIF1PJcuHtdeM1ZdIdWwhE70WHcgYqGK?=
 =?us-ascii?Q?JOTqorAPKl46o12OPQY2zdg+JNYFGS+xbsPvcndT09ZAlDM2UEdv8rfk/DJr?=
 =?us-ascii?Q?GJ09+wYiiCrvAjfGBcwOtiWn5Lw2hiKtjZUh/guWZRoNc6GEBg5B6guqMr5R?=
 =?us-ascii?Q?cfMeRzzAcyuR8p1LUGUgfkiqCucN0MewuKU90/kCp9cmowxJgCbzqxI/qAk/?=
 =?us-ascii?Q?eqH4BoMDi2N1xzD36cf2bcSjMaBurfRvqGKXtvhhQu0nxKTTjWH4TTiMo0Fq?=
 =?us-ascii?Q?x4eM9MYPPO8Ab1qmZZroo8frxfx1pZFmA/DeNl18c5OOUfivqbHprCsZokDd?=
 =?us-ascii?Q?TqZEc6cCacrrZp+9KpAHAGeY/0zqL/3EGPzOcaMTQXAB2lhtGpQKGqbKnLey?=
 =?us-ascii?Q?JS/qYC8ULIv54QHuscC9P6GKrBTz/FDeAPhdkWVAwTiwQBl0Oi2/JfbVikjm?=
 =?us-ascii?Q?bZ/I5es2cnEpUjwEGj2BwjeHgCxlRe8SeJlFEU+zN5ucD5Iyjf4o4EduqBBf?=
 =?us-ascii?Q?EpSO69XR9j1G/mVRAGsafeypXLxry0+dqq6nrJ6V40jxUk7v4FqM9W4Mfoxt?=
 =?us-ascii?Q?mf2u0FJ+5XbsM19UtaSTipi7enVjcj9wiI1Np4HypbGOE0fcBFm/J91FOTH+?=
 =?us-ascii?Q?+SWdvzYdZirMtWLqCzQd3t+v6TOg8zFbOVLrjvSmHKHkBE5/IuX9HO4FHl7j?=
 =?us-ascii?Q?wVun/U23cIhDyuNuqCi01oR5gNrWYmVZZnxV9Pn1hSM09kZmHqGvz5nBlurn?=
 =?us-ascii?Q?ka+6vtsHwfUwb4h78Yu4qarjSs4poaqUlvwbf9unGEoRswn54Xc2etuIwbZe?=
 =?us-ascii?Q?NL7pffsbTSyNh3EdHvpLpa6hMVQYg3ku7yMcaT72ZuB+3yndEa65FU4L5YID?=
 =?us-ascii?Q?S63Nkb0HStmKrvsJw1ewgvmkMUbcI1kUP7KxYHf7eImXlrD9FfqwtgQ3TrOb?=
 =?us-ascii?Q?I8D8hdoKk6DZhz0r1hag+xJloLcfAC+t0oB1OVWY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0997f36e-eec0-4a52-94bf-08dc2726192e
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2024 15:12:56.5541
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NloO1ve7PD+1JdDCEx6DOFnhNkKspeKkUVhb3lIDVClDy2xBbI721nygkBI6fB0N
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6733

The BTM support wants to be able to change the ASID of any smmu_domain.
When it goes to do this it holds the arm_smmu_asid_lock and iterates over
the target domain's devices list.

During attach of a S1 domain we must ensure that the devices list and
CD are in sync, otherwise we could miss CD updates or a parallel CD update
could push an out of date CD.

This is pretty complicated, and almost works today because
arm_smmu_detach_dev() removes the master from the linked list before
working on the CD entries, preventing parallel update of the CD.

However, it does have an issue where the CD can remain programed while the
domain appears to be unattached. arm_smmu_share_asid() will then not clear
any CD entriess and install its own CD entry with the same ASID
concurrently. This creates a small race window where the IOMMU can see two
ASIDs pointing to different translations.

Solve this by wrapping most of the attach flow in the
arm_smmu_asid_lock. This locks more than strictly needed to prepare for
the next patch which will reorganize the order of the linked list, STE and
CD changes.

Move arm_smmu_detach_dev() till after we have initialized the domain so
the lock can be held for less time.

Reviewed-by: Michael Shavit <mshavit@google.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Moritz Fischer <moritzf@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 22 ++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 417b2c877ff311..1229545ae6db4e 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2639,8 +2639,6 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 		return -EBUSY;
 	}
 
-	arm_smmu_detach_dev(master);
-
 	mutex_lock(&smmu_domain->init_mutex);
 
 	if (!smmu_domain->smmu) {
@@ -2655,6 +2653,16 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	if (ret)
 		return ret;
 
+	/*
+	 * Prevent arm_smmu_share_asid() from trying to change the ASID
+	 * of either the old or new domain while we are working on it.
+	 * This allows the STE and the smmu_domain->devices list to
+	 * be inconsistent during this routine.
+	 */
+	mutex_lock(&arm_smmu_asid_lock);
+
+	arm_smmu_detach_dev(master);
+
 	master->domain = smmu_domain;
 
 	/*
@@ -2680,13 +2688,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 			}
 		}
 
-		/*
-		 * Prevent SVA from concurrently modifying the CD or writing to
-		 * the CD entry
-		 */
-		mutex_lock(&arm_smmu_asid_lock);
 		ret = arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID, &smmu_domain->cd);
-		mutex_unlock(&arm_smmu_asid_lock);
 		if (ret) {
 			master->domain = NULL;
 			goto out_list_del;
@@ -2696,13 +2698,15 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	arm_smmu_install_ste_for_dev(master);
 
 	arm_smmu_enable_ats(master);
-	return 0;
+	goto out_unlock;
 
 out_list_del:
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
 	list_del(&master->domain_head);
 	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
 
+out_unlock:
+	mutex_unlock(&arm_smmu_asid_lock);
 	return ret;
 }
 
-- 
2.43.0

