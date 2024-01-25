Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2060.outbound.protection.outlook.com [40.107.244.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54EB41B7FC;
	Thu, 25 Jan 2024 23:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706227062; cv=fail; b=frcOBJQeLWTIoTVPuXh69a8lr7KOl2ZdmlTCBMoK+Wm6bgkohUHa3z6dylihuPkSqwqovUQbDF6kG6Fk55TtA2HUQArum7iHSADFn8hLpg3DcP2zVsGae5cHrXdoU2rSiTdhP9hk+/yCURNL3KDP8gl06wxqWfqSnKc3fvR+gY0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706227062; c=relaxed/simple;
	bh=HZ9bbmqa1m45NzxjKEkx9O5oDW/UYTiQjm40hAENnXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=syvGjJbejitwXTIR3uAMc10/3pOxSUqVGgDAC21Nhs3/3CZh8n5YfnBLQoXxo/noiQn+aHhSuXAAD5QTax4xCLV6psJsdIiVUnrTDnxl+BCuH6U+e107n1/Ef7GH+hno2NP7Ya+fuA+L3QUtOVZt6iL0hc18hn7dJZdxMbR0g8w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=RmMai96X; arc=fail smtp.client-ip=40.107.244.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="RmMai96X"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SsDzhlcNeF2GPRI2Dhwy6+2zkOIFctG6+tlshNsf1G6hqCyz9FN+0v3/AW77WzQkKCmoEYduTaV3Aoj0n2TnTKXg365r5qGg7tDYGjtB8BH7zO2AW5/n9MdG+GrSrent92dN4GRUi5cpkSpMinAiYJU3jf1ll9AVkrwzN4gSRQsvF7x7woMTb3Z+ehoHMQRYbiplCgBppyYfo4CHGB1mtM0jNGZgC+fghJiwQjvXQaPSsSMKAJ68YvIhBtE67s+KE3sRuFC7kvBuxwPde71Q5g0pZ+XUPodHmlPZ3t89HI9uhIEJTu9+UbfPs8Z1N6QybydnMjmlTRVzKMJ/px8nZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nay4gjr6wba5e2ti9n+Ho2HOVD6oZCV///UMW2Nm2sY=;
 b=mu59LPneSTrS/8SFvJuOuiAeK/EdU+KFFeHKVEAa371831GNesUjlKdgX0t3h7Z0uPp6S6J/tUX4x0PFkYltYCowMFINXbeEnlJ1d63bntRDL9OkDhPIY/ZrdCRGHsY2FMOS80PZy3cuusADlXLrGP9nNPEGwd/LojBA0SlHCo9KVURoBwIlRN102MawXH8crCjmxzZbVTit12FJljydeH2L8qBh1B/ylBitEwxZrzQ4WfUK/Vy0sah1q32kvm/m//yRm2TdwsNU7EoVq3Bj+SV9ES62n4UGzL23OUuB6k/9Gn5OHkISwv1gdiLFKy5Zlgz3PxQm07N9nfVBc8JkmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nay4gjr6wba5e2ti9n+Ho2HOVD6oZCV///UMW2Nm2sY=;
 b=RmMai96XVEIAlTCy7ul87rk51CIE7kzdfKR0kV6DqWS63K7GxBdISXI2ESllY4/Ev08nNigb/6oC3eXYh6n/6PA5rp5xEkvcnNYUecA389UbKdBmDPlcXdiNIa4+yJFpnD5VLBRHLcZUTR0Pqkz4ecT589LvoWkPjFPUCCI9C3SURiPFGymx1NwenbyX38Ynk3iwu6C5HOBPoPM6sp3QBqNaBa5zjZM1PnSbudfZfs89Kz54LFeGeM/5JubPhBPLX+g5LCaa6rUN3PFkrtdlp+30VRM11ddJxItWqRgX70fYEhDMtQs97+XiZkWekCpkrJX6q+/mS5enSk23yUnQ0Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SN7PR12MB7881.namprd12.prod.outlook.com (2603:10b6:806:34a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.24; Thu, 25 Jan
 2024 23:57:34 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7228.022; Thu, 25 Jan 2024
 23:57:34 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH v4 09/16] iommu/arm-smmu-v3: Put writing the context descriptor in the right order
Date: Thu, 25 Jan 2024 19:57:19 -0400
Message-ID: <9-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>
In-Reply-To: <0-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA9PR11CA0030.namprd11.prod.outlook.com
 (2603:10b6:806:6e::35) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SN7PR12MB7881:EE_
X-MS-Office365-Filtering-Correlation-Id: fe0b80df-bbf4-4184-1809-08dc1e0163e0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	8IDKs9i7Is/UNNW8kXHG5GB+bq8AiWH3+jqJv6Vh6JSA6QWKd4DyhjFtnQP+3yxbRlDxj2c9TuZY2TG0Az5wEk/CBxfWFw1009rZcD0R0rUTteatO9JNxMukPqpJSsEEIBvGjTTnbW8+CkgIMW009fpNZpUYlpJyqM65arWxlfPEyrXT+q57uaJVyYC52al2VT/UdUt7dDPRrIo+r8OPyc/blsVMOPmZ+km9Nguo7E/2PHp4z7Wrv+8oTvQjsqnW8jXHq/5ExExg891HAp6ts4A47Crbw2V2M1OIfGfHYGiOu4KwasbmYODUkWkndBVmIbx3KgABpwU+F02/1eblEVxPVumYHUOQKGsmiqh2LZs9Iv6FnS+BAmLyyFaM+ihuiM3WVKDxX/yy0E67ngmLrjeQhtWiD7a5/FoZBdnA8Q9Sr6nIB5/VwHNNjxZFM6tSE6TF1GqbJ9icVkrIawQNm3jWLKIcm73N2XEG9LqdgkYUSqm7jcqJBeg4mmM5sUP/kwpNCz5GKXLaI8xdh37UuhWyeIDM6w28O7fuTiOQv3puj++80b/JqxMvFYk2bUaOsscySrsXaSWwsgAEC1PDuKqdq3dRRiFsf6tq2vj01pI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(396003)(346002)(39860400002)(366004)(230922051799003)(451199024)(64100799003)(1800799012)(186009)(83380400001)(36756003)(66556008)(86362001)(54906003)(110136005)(66946007)(66476007)(26005)(38100700002)(6512007)(2906002)(2616005)(7416002)(478600001)(6666004)(41300700001)(6506007)(6486002)(5660300002)(66899024)(316002)(8676002)(4326008)(8936002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kvvuxkt4f+ES4pfOFaqmgrfv2sPzokMl8U4pELWLD+01i0kO3+HMNujF01G0?=
 =?us-ascii?Q?82RooPIHLhUF2uxFA2J75fApzm1+F24WKTOYYa/6CzNcMc+iu36rv7djJnxL?=
 =?us-ascii?Q?mbYKksUgV026es9DcUH9Dcs+cNfTxp3VZcxboCj+I8vDhLW3UcVpEYerr2ol?=
 =?us-ascii?Q?aPyUJQu+BsvdTlTYOCaiChGH8OdBsmWl2YiHE6V358MzKez1rzX/cgk7CTEx?=
 =?us-ascii?Q?XEhY6hSJ2fbE0GMV1b7fCj2sKx+CrnJPhFwtY1iH5ZPKvmhZfkyDEnRZ2bxb?=
 =?us-ascii?Q?emurZFX3aVxyifVC6csHVoOJE3V6/73Zgp1RzRjap8I/f/FumyDLZB768O1j?=
 =?us-ascii?Q?3kSrcuwGzgnvN/2IgUHpy5Ucz/zdRZWF9JpzRZS4sR1qNrFyYka3kaiuofJ7?=
 =?us-ascii?Q?Vs4TQ8X8RwfZ2aDJAmYzk6ro1s37+haEcRpdrX0E+FfJuXcz0Ij2W1kvZIsO?=
 =?us-ascii?Q?nck7Vi0UwNh92fzANwzXHCIu2De2Z8cNOcsTMyv3Cvx50xC4oZJGvnxQJMOr?=
 =?us-ascii?Q?ahfrju98mTveE0Rx0lQaYl4OZqVI3mTZsJfS7V6r4nqQ/gyAPC3yJdFbPzbo?=
 =?us-ascii?Q?LcavJsXBfIj/bKN4aHyUoOG4oh2UNelAFNO6usrvogVO/yL19RX9leQ/8Bjc?=
 =?us-ascii?Q?K0NxId7iXEdKAgETw4kjAeiFrtwHMP3rQHO8qRfFNK8A4/Gws2Ecb+i8ByhY?=
 =?us-ascii?Q?GSYtMMn6S1gouXexdT6q6oO1VF3/6j0bPPDcYBVWM8/CuHtw78WUHdsdwqiL?=
 =?us-ascii?Q?hDYSidsSnvUqHgBir0eE2YhpyEgjyjAHOjrn5haoYHckadTVMnE3rEEGXIj0?=
 =?us-ascii?Q?l+CV+gYQEByP+PSAJB3es0JTm+gnGi7PHBYYxMYTQhydv/J/lj9rMBRSL4ke?=
 =?us-ascii?Q?CSsA/x92kY4XhrZqUm+uRxSWn2kI7G6dsDmGIke6Yogc+LIA2TZTJJ9uKZ/b?=
 =?us-ascii?Q?cfQHNKrtJW0yqHCWCqXPXYEa2JTE32b9+CnD0FdJweQW2t+sECDFYW65Sy2C?=
 =?us-ascii?Q?IEwDBzE1u8FC3O8JHNHWvRRTywQeh9tNmEGw9SztsFCvQD4y5961x1RT7f8y?=
 =?us-ascii?Q?40p64jIeoxjdrAYmr0X3EbpnEY073XogEsGbETjA9K/a/6/Zb0xnhOZ9wXqM?=
 =?us-ascii?Q?l6JTOVNbtekdNAxS+GsfbFsuvFzgf8TwXxCLnr6pzhhOdyQCvG3FeC904x75?=
 =?us-ascii?Q?MFN/CKNQDP4Hj/w0gm1bkgQqsP0AHqaPA+sFHjeARPHgKKQBsDpt4YWgsihx?=
 =?us-ascii?Q?tYZC71vIUh4974m1FdHnZVi1DkRSRO0oPiLt+S/JAjZlvSMVHvkDLjqsy0lT?=
 =?us-ascii?Q?AVjddZZqc0xnTBvF2AkwK9R8lSIDtuqOWRCS1GsGQxwHT2QNSlB/xSAoDXnw?=
 =?us-ascii?Q?9le/cINLKrWRKzDgSgxmPt8H01uy9pQDt+aOiQFyJkBtEqdtGFNV4J6IgJxn?=
 =?us-ascii?Q?WxBspbyjMT5RfbBD1OKsHVTQFnO8PQ10pDjW3mHknvGmvX0Td0hM35BrWcGB?=
 =?us-ascii?Q?mUoV5AL7XrWbFRz40EnkT32OIHXdvKea4IHlwdmWjs3kfq/6M4oaqlPIshS3?=
 =?us-ascii?Q?YpuQqyGnCqF5fylK2S6UdyfLHKXgjHoYarjP1P2/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe0b80df-bbf4-4184-1809-08dc1e0163e0
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2024 23:57:30.0179
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NYnoiNrHuRto8qnwsPo9TVDK6sszWNj8BEP2PwamchVe4B/GLRjaoGZ/7sc1tTP6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7881

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
Tested-by: Moritz Fischer <moritzf@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 29 ++++++++++++++-------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index bf5698643afc50..09b40ba35a9cee 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2548,14 +2548,6 @@ static void arm_smmu_detach_dev(struct arm_smmu_master *master)
 
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
@@ -2632,6 +2624,17 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
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
@@ -2641,15 +2644,23 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
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

