Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2050.outbound.protection.outlook.com [40.107.93.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65D666D1B1;
	Tue,  5 Dec 2023 19:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="RCemtAPX"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fQJsGvjiOniKQzbYH7euyGT7wQHGPVeto1HQ6PxeiAwN9/vGtanX4082FmnJ43PQXzBFBC9cn5pYGWyNi2IlcSZsj1mc9ifYvI1nBmzz0tat3AhmUYVI6ray9NYPgQ2lnR0kHmupIStntV4YBWtytVBWWZ/s0LzKOSv2MTzYgLtzD9Ca92+rGCAuy3t7VSgIKhknWkh8EAdB4bEtR5POvPY52nqBOUB84lrzNtXxtcZFfe+OmQNRNt3TAS09nNl7lLlKlKokC/xIBbgRzhsCyIRCB/llBg3JwuNoe+3JvqLxFu2M75woRwATAw7tAfB390CY1x0kxeJNnyjXvOfENQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/P+xRDL1hFq6O0slHrQTmESYC6RS2yOnjrTq5qWmSvU=;
 b=LI1dzHPYLB3hp5BbFRYjcCzroBVsY/8iHcxdlBSrFJfYJwa/MPoXLpmItITD0jjnltSPIqZj1QHG8VSF9Lx8w6B7EUlDVKo3vamgV8DEqMFLVYGEn76yd16jxs0eUlGTjcTPn7XaqBlI8P67NrzvbpJFYvXIqNs8bEdTmG2yQlWZ2+d/0fonPpo+pebsaht0Zu/CIBWQW6n5wsNfWupmZMt2Uu7E5c8zbRS2fRuHDjM1WUiQs8T9XmMs884EeXRCimWt+w9M5+jrJ0FY9aePuo0tTIX1dwuWIaCWpUTh3ZA+iYl+a+ZJTnJ1NhfBKAR+5I/MxjJc0tJCHEBe3fhHTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/P+xRDL1hFq6O0slHrQTmESYC6RS2yOnjrTq5qWmSvU=;
 b=RCemtAPXPgLojkCk1MJWymzirQ1N5OXD/n5B6I/FRIgFQsPv/hsi37vIpqTywkakGFcjEa6oi8TsEJYPzSHCed4Szj1giKPMcR6HAiyBm8xNLrVLjltxl0sgsdBU2SltUocOyTtkH9Xnpy2JzgSey9MfA2XKyK/jPKleQr+F5uS0dVSI+1sIO8F4U9AgXKWpB72G+YCAy3v/VmzrkAz9uv30Tgao7b63Y8v3r63r7Im8nS9pRtVceV8W4Aozn/wuWx9Bzs0C7OJWHRE3Tqs3/XFVjpZYrMOOElEKVnanHeYyZQ5E7TNbqM7FVr1LJPJlikBF23NiIBhsLVr9BZm6XA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB6588.namprd12.prod.outlook.com (2603:10b6:510:210::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Tue, 5 Dec
 2023 19:14:54 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.034; Tue, 5 Dec 2023
 19:14:54 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH v3 12/19] iommu/arm-smmu-v3: Put writing the context descriptor in the right order
Date: Tue,  5 Dec 2023 15:14:44 -0400
Message-ID: <12-v3-d794f8d934da+411a-smmuv3_newapi_p1_jgg@nvidia.com>
In-Reply-To: <0-v3-d794f8d934da+411a-smmuv3_newapi_p1_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0141.namprd03.prod.outlook.com
 (2603:10b6:208:32e::26) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB6588:EE_
X-MS-Office365-Filtering-Correlation-Id: 78b1f8c4-5095-4e90-164d-08dbf5c67507
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	zN5Sg5bbrcosMasubHDtLAgITU8lTUnaocuQGTkMFQ32L03tqyJ6S8wyShexxAcXvlCxD7z80vwY5o5lqVrVrttJCvMzCUxXu/bQ5ZFOZAmQKQXgat8RPO2A55gEQu/sHezLZpSvdzkDrqS0K1qVwRSiy1B1uYsq4KqP8ZQ2u5E4jG4LkKnnoYdzyNqLT1Yo/LfAv3m/bQqJlz9K/o+4RY+v4gnKD08VfbPztrs2sFD+0/TC7PvmcGbnmngUU0Opp68gFPLkp62pj5FOVCNdfu1EROFyuOJTSNVUI5mSIdW7v66Z6+IM3xBYVe1lSg5yWOnlmRjV5yc/WFZyp2z0kG6ovw+YrHe4hs1OhVWcHyCURvSM6XoZO+6vTFqIxHRtm/rLd/5mq8yf46sNEEufWnE+N0Yhtpa+u0zJJqWzZfW7eh0S2evw1cLYTdPlwfMhvEMHjtjDOcxIo+a8dzjXNwWSyQrBCD+Ov/BN15nzrlfHJ9pkY+Bupg18q9mk3kXaBY1Q9u46JVTIRQzBehup5lN4TtS35Q0yZr/DrMEFfNpbHcmFDjkpfVYFg+XLpDRu
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(136003)(396003)(346002)(376002)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(66899024)(478600001)(6512007)(6506007)(8936002)(6486002)(2616005)(26005)(6666004)(54906003)(66476007)(110136005)(66556008)(8676002)(66946007)(4326008)(316002)(83380400001)(38100700002)(7416002)(36756003)(5660300002)(2906002)(86362001)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zP1uuT4epV2xfIGefRDx399/KXN1bbCRgiwks/WrfQNXgXsJMNbXBHSNskNf?=
 =?us-ascii?Q?YACEMUoFuuc9D5ua5d8Az9tLq/vgPw0uUWBlCCQjdsJaArlBU/mShnNiz5mW?=
 =?us-ascii?Q?dLzBMtDgm8WWP3Rq5iy3zTimA69iNBhdsBCGLLgFNdviP9nKpLTbx+ETENrP?=
 =?us-ascii?Q?dKkJ/u7Tra5xlqgXwgH/NAamyIPuy1rQjd0K+HGsqNLWnpXmwY2mc3QC6BB5?=
 =?us-ascii?Q?Qtww4opdNcH1vw1OEBxBaUNYm0/wCFmiEU13aKdE20IomkylHFkx+eOaTT0d?=
 =?us-ascii?Q?syBZJc2t2FcHCVxNmUO55d4ec+j9Z0abj+iBS4gD4kczCYWu8k4NQTyJa/qN?=
 =?us-ascii?Q?y/wRf7dSfWXhstLlEF56Atee9PQE02Zg42swGu8SEfc5Vr0Toi5/B6q6BcCj?=
 =?us-ascii?Q?AS31JEbIHeGipp7Uo4R/m8ALAq8NHMACAHiTe/cRFB7RGCsQmEobq+gm6t8W?=
 =?us-ascii?Q?drZ1t+li8MNBTwTPnLKB09zjeoWZRctLE/3RDrMUq2GDFDr46bHH9IueJKyW?=
 =?us-ascii?Q?0/PVJaWvDkRWqZ9bG+SQe6ERWbkfGBGivnybwhvJvOVCWTSTjSDDPKueoAwy?=
 =?us-ascii?Q?jwVCROW9VXbpBA25QUriJkTTXsViYLvtA0I/57rvAElh1dq3av3BAmzKPixu?=
 =?us-ascii?Q?lo4wG0ovm3w2swJw/qHUHtgsHbFTfaCvRrHI/qkCs3vhWnCKQjmuBarHssCG?=
 =?us-ascii?Q?KJxhRJxWGzg9WGm1+BIpAp4zsMHBGvaMkKX0zsFZAKKTMZAsbHilHnC2aYMZ?=
 =?us-ascii?Q?wXDfjy79G5WjZ+jtr6CLtph0W64Tc56IdDt1k/2UtRfyVZw4StrQugWJzJNp?=
 =?us-ascii?Q?HHzXSxGqm/Ol75HC01flnjcz9MqWRv7Z37jJETnChySzjBUHowEtOV6ArCDh?=
 =?us-ascii?Q?jeTR9AuH+gRALkeULhfX5+zIArfhxoP5YDgEK/OAt/wnaJz1lq5sxgwnux+o?=
 =?us-ascii?Q?rsPykxeeXazHB+qN/Bl+lV6ihw1LB5ReGSoquqRk/JBNaP8i9DF+7lUj6gHm?=
 =?us-ascii?Q?J2OPXGWxs/9qwKdXayEdG4x7RpZtZWutN3l2nTdButabIUt7xhnUwzDt+3+v?=
 =?us-ascii?Q?fep9pYCJL0XRmSGbVdjP9iDmWfMbkHbmkTnKaJYDfM0Oyo13k8AYmu/yfURG?=
 =?us-ascii?Q?Dk5KnEorpiADxGhsIj4Gw1y4bkMz9bW8i8UVKQ4rZUBjMlGEHem/Ufyyg2am?=
 =?us-ascii?Q?toKQlc+0/Pev6jISbivDfTxUijjEBuCxyAghA3RA+vsPZUTZKZZxiw+C6t0z?=
 =?us-ascii?Q?XhYH5x5086CMQuZZqe89E4f1pY91nu6Kf77fiU7zlQP87b6FmQ1aKWh+qRtm?=
 =?us-ascii?Q?OsxG6uPuX78PTWv/tZUcfEIiEd7XOIqvFwGez21k6wRP4XWAG/J5Yv649LYC?=
 =?us-ascii?Q?UpyjoE6qO65UrApdwf25z6P5zQ0HU9dadFtyOOARU8/mmu3oQuhRmdbRNvmo?=
 =?us-ascii?Q?+ROwvAKTbVPn/HYO9HEUbX3DxmFA1/g7lVwBMRG2GR7FPTBagy0/WJJD5A+b?=
 =?us-ascii?Q?vRHvya1HDBvX72w4FgGEfIN2/cjGaEaRsfp8UZnHXZL0pckKz4vG3aTcA9O5?=
 =?us-ascii?Q?3HtoP18BVZsNDdNSlBqSE3mjdhWDd+KNsd+sg4ci?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78b1f8c4-5095-4e90-164d-08dbf5c67507
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2023 19:14:52.0461
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /oF9QaYujYgR2EMHSGfXzogfKrkGxjT2YuzuQFbh5L4wsoKMluSs1E8pvc6IcyfM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6588

Get closer to the IOMMU API ideal that changes between domains can be
hitless. The ordering for the CD table entry is not entirely clean from
this perspective.

When switching away from a STE with a CD table programmed in it we should
write the new STE first, then clear any old data in the CD entry.

If we are programming a CD table for the first time to a STE then the CD
entry should be programmed before the STE is loaded.

If we are replacing a CD table entry when the STE already points at the CD
entry then we just need to do the make/break sequence.

Lift this code out of arm_smmu_detach_dev() so it can all be sequenced
properly. The only other caller is arm_smmu_release_device() and it is
going to free the cdtable anyhow, so it doesn't matter what is in it.

Reviewed-by: Michael Shavit <mshavit@google.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 29 ++++++++++++++-------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 7b1f7fa27b3df0..212d0ad7e5f911 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2495,14 +2495,6 @@ static void arm_smmu_detach_dev(struct arm_smmu_master *master)
 
 	master->domain = NULL;
 	master->ats_enabled = false;
-	/*
-	 * Clearing the CD entry isn't strictly required to detach the domain
-	 * since the table is uninstalled anyway, but it helps avoid confusion
-	 * in the call to arm_smmu_write_ctx_desc on the next attach (which
-	 * expects the entry to be empty).
-	 */
-	if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1 && master->cd_table.cdtab)
-		arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID, NULL);
 }
 
 static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
@@ -2579,6 +2571,17 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 				master->domain = NULL;
 				goto out_list_del;
 			}
+		} else {
+			/*
+			 * arm_smmu_write_ctx_desc() relies on the entry being
+			 * invalid to work, clear any existing entry.
+			 */
+			ret = arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID,
+						      NULL);
+			if (ret) {
+				master->domain = NULL;
+				goto out_list_del;
+			}
 		}
 
 		ret = arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID, &smmu_domain->cd);
@@ -2588,15 +2591,23 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 		}
 
 		arm_smmu_make_cdtable_ste(&target, master, &master->cd_table);
+		arm_smmu_install_ste_for_dev(master, &target);
 		break;
 	case ARM_SMMU_DOMAIN_S2:
 		arm_smmu_make_s2_domain_ste(&target, master, smmu_domain);
+		arm_smmu_install_ste_for_dev(master, &target);
+		if (master->cd_table.cdtab)
+			arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID,
+						      NULL);
 		break;
 	case ARM_SMMU_DOMAIN_BYPASS:
 		arm_smmu_make_bypass_ste(&target);
+		arm_smmu_install_ste_for_dev(master, &target);
+		if (master->cd_table.cdtab)
+			arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID,
+						      NULL);
 		break;
 	}
-	arm_smmu_install_ste_for_dev(master, &target);
 
 	arm_smmu_enable_ats(master);
 	goto out_unlock;
-- 
2.43.0

