Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2088.outbound.protection.outlook.com [40.107.223.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 191D967E78;
	Wed,  6 Dec 2023 17:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="CZMHOntu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H2dNAWpUrM5T0J49BYecQIk5134YDBogTUXrqBN1UadjaY0FKiol9+MZh0NMCxSJibPpzGDu/dmgOE65zYRrPtq94AICSor6+AErYwFPJplNxhBZkEsrI3ioXUXEx0rKRIKaur5UzHYRKYNzhBdHFg0sitpQ4Dlm6f6DbyndIQF7GczpvEv1dR5ygNx/wNRvHRI4h+3W+GNsfDRsAryNVeTdCbBkew6bAxs/UBfTib3thZbzKN1hGUneQis5HLzRIwJPlTmD5Bw7L1cbmX6zrrXjSShHxStgGYTeHotBmoXFthrwBr+t8hQ4eRaAXbims1mG+66lS1M6W5YZGMaXSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9sjhrtrMLRm8dbYksvZfGbyaQVx7b30tXACD03u1ajc=;
 b=hnQWhNZJpW8rJqOaFgPscP7Rh4fAQI78gNt5j1DOC10Q8825dPLnvzwlwn55Hm+MRMqmc09VJoMZKXOOrMfjyl3fp31EzeFtl1Vr82JekUHDAnFsbJRUGjCj0ihfcKcRv31QQXAMD4qjeVcJNMPXNgidtIp5UrYSQM57kBnVj3eqZtS7suvnHZWTpxEKxqgiM2/iEmWOx4diZ7MJ1waYAEtYzF7IWJmgAMTBaV+ZBY4esy8MSt7FoerfL/BWS92zPH8qATGF6KObJjSA9MjhBtc8UhLkAYtkBKkzsdO/y77+XFLEflC8jUtJvlpL0vPP/oAZETKovRZQ/o9w6UO/pA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9sjhrtrMLRm8dbYksvZfGbyaQVx7b30tXACD03u1ajc=;
 b=CZMHOntumtRcrYWQV20libssDW3QtO5+VXNOxktxajfqRq3Y0mnc65RZ8hRFW+f3eESUe+jN5FpiPn7KTgTzYdDK60TE+uH2ivznLvbXv6VG/7JuQZiNPlrvG2W67xmGbrSBiYsW9Grb8gkTj0uRGxG2CtRN3l96ZVP/THMuzlMPBIdKvuIhpHvtcGspfhaMM+M8I6x4LvYZnZ8nI/lPbNxtQbNFhKT9ht1Dpxx3oNO3KLjRqoWMvwQcLNplVMcKtxlDBuakBGmjfg7J96dmBSwr1mhFCda4B5+6NasXiXTcS3epKqjme3Acr+75lo5Urou3skYtkphYc5ok6ijVXA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB8360.namprd12.prod.outlook.com (2603:10b6:208:3d8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Wed, 6 Dec
 2023 17:28:42 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.034; Wed, 6 Dec 2023
 17:28:42 +0000
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
Subject: [PATCH v3 19/27] iommu/arm-smmu-v3: Keep track of arm_smmu_master_domain for SVA
Date: Wed,  6 Dec 2023 13:28:25 -0400
Message-ID: <19-v3-9083a9368a5c+23fb-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v3-9083a9368a5c+23fb-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR1501CA0026.namprd15.prod.outlook.com
 (2603:10b6:207:17::39) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB8360:EE_
X-MS-Office365-Filtering-Correlation-Id: 688ca31d-d696-4777-cd16-08dbf680c692
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	4Y1xJIXs4nY7rMnDz+4DeLCaw9LrsmCjMHZCPiOXqrBS+4djbwfH48dccPwGVdJnW+f3K4+09K3KQJwNx4dPbjWoLa7dfZAGPBZKKvD85saQc+Xm+I1WSZvS3YSEC4Xn/rZzZggthYTiIj95nmn4UlRooBRSyXRj3eK5kxD84IyOXIbv5v2mwPX2KgtlHh0kx4dlDbvWFNqqESRcsVeO4Ief9DmHodlVRlJNWNCYwXvLAzwUdnhC/4d34rBx/5KtBm8zGElHrJZ65TExFHeaUdCIsPgcKP1BdAFvwS9IqDekFhdWnHFgjHtD6dINfabZrjC1tOUG8c+6dllXb+hLm+3IQp5y28BKo0PnGYVi+Aq9lDmgxPahu8POT0PKoAYo7vuRObseF4OhRnYPv5gM9Gf8JjpfNBODwWWvgUa5RLa9lEJ5QpCZ23eGrhMNcR57OOwWjoU2t129IUDHT5K9/EsZX2YEvDqBA4dgYWTKVr1wvmR5jAaQuEre4iDSJJhXBwXkDjI/QnN7rItivfyrrhMoUH54ZaITyUf4CIPk3g+JRCPhkwY1sEd9HRBrjm50
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(376002)(136003)(366004)(396003)(230922051799003)(186009)(64100799003)(1800799012)(451199024)(6666004)(6486002)(478600001)(38100700002)(83380400001)(66946007)(6512007)(2616005)(66476007)(6506007)(8676002)(2906002)(4326008)(54906003)(7416002)(5660300002)(86362001)(36756003)(41300700001)(66556008)(8936002)(316002)(110136005)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/1TSTdvP01GRDCWUYfogrcfxL0T6A0s8EOvJ0MdqL6P+RTz4ThgwiRd+R53P?=
 =?us-ascii?Q?uGc8tGAvF4AevjiZ+MvuM8/dQJdV3IXeDLN8Qlxt47smxZsDpEOABF8vAkGJ?=
 =?us-ascii?Q?2g2mVOsGJPgwOHBdQkJyC5012XbX9XdzN0Wxf1nK98eRu5gjkL6A9xUT21yb?=
 =?us-ascii?Q?ISiJM0UD/1NsUXTbt8Cwf1zi4X4MQbfaLb4gHkGIyhMnHpBRpIRxm9CPmeRn?=
 =?us-ascii?Q?rPsw+WqN+/H7/a0WTSoU0CjeoT+wN8kG9cv4GgC7groIedcQ2U3p7FDCimb4?=
 =?us-ascii?Q?yzfjwqKGnChMrRZq0yRvWqNZVrNAEKRLMOQqW6Vs5LdNEE24ayuWyqpWkaIF?=
 =?us-ascii?Q?mtVHWFwHFGUmkwa48TeE39gnHgPp9g8W2VbM1GdTtXHu7FZjkESi0xF4LN5M?=
 =?us-ascii?Q?QJvivmxbqfg6oaSOyBYzOuNzJ5TCkh9lhBvxfpgz2aiNMpk43ZI5LPUsweYL?=
 =?us-ascii?Q?wQYkKEBF0vJWgxoRsMzJUKED93K4O8wIHsGj7Em6tBZweuLyqU2/wj39VhXK?=
 =?us-ascii?Q?mm4VV0sN3nVLdDj7qsb7IZdTWHy/xb5oSG2p1MXWS4IR5Y15p8UQCa/Kpgf4?=
 =?us-ascii?Q?QuFMyXDFeHpdnZFqswEQ0Hrl6US3CUpaLD8zj7sm/AaprByn+dsYIQp4GjTe?=
 =?us-ascii?Q?gTuT5e3PN+PHggVhNYyVkKJ668yWx0m3tfQtOT1C72JbJHQE2Pe3pVAjOMzK?=
 =?us-ascii?Q?MinrLhUQUfNYedY2cs+aUpPK6nWgbd/uayWr33avCfT3DtIQ3rG6PsePMX14?=
 =?us-ascii?Q?k9oHmx+CiR/cmLJ/BmQNiracT8QVrKpPiVKqFqaiMHjd/Mg4kuraM5RHCX9Z?=
 =?us-ascii?Q?tnkkzp/a6X4DHIeK41Q0dVyzyc9bILc8XXxqhbDv4Q7eH4TUuuiqDC3sqvw1?=
 =?us-ascii?Q?nxuo/TAoh4NMt+a9P1iQkBGqr6jC2UzWoOA5h4ipHPHgR2ikG2Al4KwtA3k1?=
 =?us-ascii?Q?T4YMCMGVGn3pjsE+SIaFP313SCG5mfEapjeVGiNqJg1sWKCMASQbkWN2YcYr?=
 =?us-ascii?Q?9v+we0Fh5sEbUknlNCFRvFXgaR/0cBHQ0DsQajxg5G4SsdabaFhla2ffa93e?=
 =?us-ascii?Q?XxBOava/yopYMa7tSS/EWb9GzSUZBUc4af6TKimlS5AJPDdejakGPf+7nicY?=
 =?us-ascii?Q?0YZEnChi1aFLF8acyL3/LZZfKSsuj1O/gvB/3YavCiQPWmP9NXy742ZvMXsN?=
 =?us-ascii?Q?gL+s0AwNkqAQRFMkO6p+T4s2hknu7iLwoHWZdYjXg2A48mG7drAyDXj8woQk?=
 =?us-ascii?Q?vkehDSlUT7juBeUVQkBfmqHB41ZBQiyiaZidurwVcdC5TH3K8KBZvYfEtd5S?=
 =?us-ascii?Q?22cHtRFrJJPrk2+fnOlC8Dp0eWV3g/KkMgL3BudB64n9y1TXW3kGopblujxd?=
 =?us-ascii?Q?Gn5DE6GyE6ODMmueWkjYoXV9E7EEmC4GZeA0OlKWsmAgn7Imfzhrkn+WnZ4Q?=
 =?us-ascii?Q?J3poA1r074ySPIznF52+IQPBWx9DL8oZEY6Und3ekY9pvnxBVdeyoAOxKRwA?=
 =?us-ascii?Q?d7MVWTJzjY/+I/bmSqPrrZx6MoKovl3JN5LeUVIyQhDG9ASqD83OMmSm5GZN?=
 =?us-ascii?Q?HcKrnQ1GxCN1BgM4Pw5gyo2ze3ZPYj2ywwvKW473?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 688ca31d-d696-4777-cd16-08dbf680c692
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2023 17:28:35.2055
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Djhak9lsDLU+h9aKhRqOJxctTrhYSHaJPa4xqQE+CWGiMKul4web2Vpo2FPxHAeb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8360

Currently the smmu_domain->devices list is unused for SVA domains.
Fill it in with the SSID and master of every arm_smmu_set_pasid()
using the same logic as the RID attach.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 5db78e6e03dcfd..10dc7edd40e1b1 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2712,6 +2712,8 @@ int arm_smmu_set_pasid(struct arm_smmu_master *master,
 	struct arm_smmu_domain *sid_smmu_domain =
 		to_smmu_domain_safe(iommu_get_domain_for_dev(master->dev));
 	struct arm_smmu_cd *cdptr;
+	struct attach_state state;
+	int ret;
 
 	if (!sid_smmu_domain || sid_smmu_domain->stage != ARM_SMMU_DOMAIN_S1)
 		return -ENODEV;
@@ -2719,14 +2721,30 @@ int arm_smmu_set_pasid(struct arm_smmu_master *master,
 	cdptr = arm_smmu_get_cd_ptr(master, pasid);
 	if (!cdptr)
 		return -ENOMEM;
+
+	mutex_lock(&arm_smmu_asid_lock);
+	ret = arm_smmu_attach_prepare(master, smmu_domain, pasid, &state);
+	if (ret)
+		goto out_unlock;
+
 	arm_smmu_write_cd_entry(master, pasid, cdptr, cd);
-	return 0;
+
+	arm_smmu_attach_commit(master, pasid, &state);
+
+out_unlock:
+	mutex_unlock(&arm_smmu_asid_lock);
+	return ret;
 }
 
 void arm_smmu_remove_pasid(struct arm_smmu_master *master,
 			   struct arm_smmu_domain *smmu_domain, ioasid_t pasid)
 {
+	mutex_lock(&arm_smmu_asid_lock);
 	arm_smmu_clear_cd(master, pasid);
+	if (master->ats_enabled)
+		arm_smmu_atc_inv_master(master, pasid);
+	arm_smmu_remove_master_domain(master, smmu_domain, pasid);
+	mutex_unlock(&arm_smmu_asid_lock);
 }
 
 static int arm_smmu_attach_dev_ste(struct device *dev,
-- 
2.43.0

