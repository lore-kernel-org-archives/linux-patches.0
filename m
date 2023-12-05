Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2040.outbound.protection.outlook.com [40.107.244.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F9C16D1C1;
	Tue,  5 Dec 2023 19:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="a5ew4ncH"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SxDrX3MZAvL4pqd6MNlXSFcvchhWyUGipLbXzlf7D7QMOtXIscliQ40K2iF00VUzV9lCRHLlCCfT34g4JUjAsIF7f152qFSBWpfIxt/nWuOL26kr8T/BP3rdIk1MHwopV5AUk0rR57eNDy6l/e9XDQAZ21S/QWU24eRAbs/Pw8ZGYnMT2Rm254dXPrC0aoUqE8BzdRNo/hUZezuQadYcuX0szoivYb/X75JQLKcqO1b3tRFD0fhw0hb3s+Xggf3lFg63l3VZPK2qyjAjXVWBbv3eQD+G59frUDT0ByHdDVl7NVUVbY7wMRaESq7gFpwOejCH60YQpJ6vfpiwU+AC1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hC5SwMIpqNeU8mteD41KXKEMKQt5VX7GFjjFy3njBsc=;
 b=QEQbhLFyld/xEWlxbBXsEVPEVdtG1UCShVtyqbYk4RK49p3pUpP6wP+pp4zEsGuQRiovSJwbtms5PNTUjczPPnGP5PINKRSlx8C8PvC9vQu2LrOzVJCATPSBY6fSApNNwPWoZfh6VJZS7OYWExPXinq5BZPSB1r2E/AFw+k5BbSzWqFGwoUAewI7EWpOc45/BLS22RKO97J5qs9wnvF3PdXDagw5YxCEXnE7bl7jxSzoJzgnC0hZD8U/h/MNj5t+rXNlOg3aFb3gsZ1oTMeRfMcUVTnLdAkMtNUpW1sm9o7AzzGcGGYaLquk4GDCB1T2OtCc+hZK5CuIoV9bEOumCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hC5SwMIpqNeU8mteD41KXKEMKQt5VX7GFjjFy3njBsc=;
 b=a5ew4ncH0KpOjkH7+Ulra4mMw1rXyorCb0C1fd+6mEIiQM9wg/6NQS1R1Vfq/J4+64RFVLTQzFk5/HscA8tv+A3UUSiEomns9jwibuHdt8h+iLcLANTIEJzlc/jpqcvec1MVDCUfxXHoUfoOXQ/jIxi+63F61YfXIFL6Bfn1JaTpj2MTkukFnwR7gVmlIpc4BXQ5qnReUPvTfwksq0/NLrsHvhKT5e0P2U8kcqtC156+826PLtEFoNdEkouK6egZtfpiNWuStT7yEcR5mWAYH8RM4Pf3+vNXADZOmXV+LMTokdpZAvBsiTyr8KFc96b37igtvPcZF+ZKkWDgIqvHNw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB6588.namprd12.prod.outlook.com (2603:10b6:510:210::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Tue, 5 Dec
 2023 19:14:58 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.034; Tue, 5 Dec 2023
 19:14:58 +0000
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
Subject: [PATCH v3 17/19] iommu/arm-smmu-v3: Use the identity/blocked domain during release
Date: Tue,  5 Dec 2023 15:14:49 -0400
Message-ID: <17-v3-d794f8d934da+411a-smmuv3_newapi_p1_jgg@nvidia.com>
In-Reply-To: <0-v3-d794f8d934da+411a-smmuv3_newapi_p1_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0127.namprd03.prod.outlook.com
 (2603:10b6:208:32e::12) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB6588:EE_
X-MS-Office365-Filtering-Correlation-Id: a03bc92f-562b-418d-aec0-08dbf5c67580
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	SKjkQfUCxYyiqJy2uQ6QCe0TGqSKDV3DN0TUADrkqB4vwLjrDeu2kN0vG4yp89Xac5PcAVrZy5BexYnNH371J2c3laLDReVUgNJDrAO6Atjyxhzrl8NIRFTRYg8vKoAYR6V/HLopvhJCV513daHHeUR7ZM0NEJ3d5gCagLYaah1SYaaBus83DTVKn+cN2hrw2KmoAjw/EUC8khyuEmrBOY1WD5kNH0PwyGkKJhchuxDXJGTiRTgD3bSC/LeLVCTu8znPim9nqAaRAuvfGCpSkFApktONbrmGNfSiADQ/dJRLQYhr12ityOx+Tj6ig4HVW5EUarBUhkt2DPjmKJ8lNmN5xFxRHQgMroY2vy5ZLHayUSbppbPmPDvG2W59s9re79zxJC2UErUbVR1ttmJhyV6edYGuSoAMoIXCWqrUymZ+U//6lAfD9A5gI1hjJeONFM1RqL/bU/83VuNARp5u5TGrw5Mmp6ISJwbCTypXyoSDJ3TX1RiVhN/yieDIZC1n7xTvzzIuhKB7Iinl9OTDdFXkWnLtNAR7F/PhHhthhNk6rkrQ+qbitJbOzQGWPWjf
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(136003)(396003)(346002)(376002)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(478600001)(6512007)(6506007)(8936002)(6486002)(2616005)(26005)(6666004)(54906003)(66476007)(110136005)(66556008)(8676002)(66946007)(4326008)(316002)(83380400001)(38100700002)(7416002)(36756003)(15650500001)(5660300002)(2906002)(86362001)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zFkqZqDhwmMqk+JWlwP1+x2fzgF6NDCLPrgCcgo7RryuhnfK0Gf9cvDNoH6c?=
 =?us-ascii?Q?i8N27EAmcigCH3JRXfwSYK/JshkesW/w8toxPQhN5yCxovOcr+P6oZzNvl6A?=
 =?us-ascii?Q?3jXk/NVOj8l4YY0pyqQaRQANschhFZ8owcP/mdl3D4ipWPopKBqZkzpqhcJy?=
 =?us-ascii?Q?FqIhxwx8JkCwMAkMB25n4zBrc2oZ/hERm5kF+Fimm+t8XIXLia/vMOY7DWMa?=
 =?us-ascii?Q?fI2woKUVpQjn8kL6jN6fvRnd2WcOr86j8L3Lxz1c9J01yWz+JSkpU4XwUDsJ?=
 =?us-ascii?Q?sDVKIadntDpJRCRG7I8vbk/MIso2gEPP8c0gJ6BsmAZxI1fpNGp3MSe5uwdN?=
 =?us-ascii?Q?i1sYuPlfWwMvtbKuSzN10G75IP+al8wdOC58sHmP0dDeXnkYZAtdl95vWEWV?=
 =?us-ascii?Q?/AAsn/3+eChg2PpMRaGV4E1PVf7ALGKdYi3otJq3BN+0eAhDonWaSLT3wJQ9?=
 =?us-ascii?Q?3zS4Gfkw9yB/2CoOnWIjdevkqDLVg//Q2tIArnIZzpuv0ToMZahsmPe+50CZ?=
 =?us-ascii?Q?XjJis0CJ1OCpJ0n6l9vq7g0eTxLD1RWW0Rs5tvz5CEEFkiGH3lvjvJKJec1B?=
 =?us-ascii?Q?XA2ZoTaUilv7QGkpUnBFRMuneKiA3xmOzikbezdGYRtASDKwos90ezAvoq7n?=
 =?us-ascii?Q?WKC63mFH0Wh9/yUNpv0TMLOFY7IeUFQCatrW3qzt2OZZqec9bXtFbY81wIHL?=
 =?us-ascii?Q?S2y3v3bfjAzRjmUWYc5P4p9cPA0vM/R25TsokUV2mc6PD7SjkR5ewgnviOO1?=
 =?us-ascii?Q?ioP7AxFN6rwdlhgGIbki8pOhmg5n0ZE+Xt1ZmJ1w//nbBtxqtirwjW9/OHvD?=
 =?us-ascii?Q?n4obztfHB7iKio9fI8eER0YXa5vR5K3kcT43ftmbpnikHQ8j1+c3i2+v9QXy?=
 =?us-ascii?Q?4mj8aayeRLZPm6TiCFZjzwaO9kIlBp+IIOBp3FfhYGqA94JMJefEzvJmmMhX?=
 =?us-ascii?Q?O28xGDy61ZqL9hUI/SXIZ7aKaFlXmJyVW/ifkoTKrxFAP/fLH0/ORkKJ0BX1?=
 =?us-ascii?Q?Dmn+R9pzqkhWAyhBD7jpAYGiQkNFmM8KlNXm+Ru/pAmi16tifnghjn9vhLbZ?=
 =?us-ascii?Q?cLDxghFXAz//9kyLPfSccNgLmiP6Lb3O5H0AtJ41wAsOQe8uH1QBR/RDRVhj?=
 =?us-ascii?Q?K015rWWPLAQ7cNt3NQx3xq+VcU8zqYDfWj8LFFj6YwaFKFmGu/ZY/Prt4UqY?=
 =?us-ascii?Q?erhHXmogbT5S59ghNT9qjmna8awxDx5uV2aRDX53bwy96S5Y5BCav0R2rQll?=
 =?us-ascii?Q?D5iLXyUrw132L+7T56Sc6gzNxoLdFJRCjh/EyfdN+3JXv2W5KlZ407gxWDy2?=
 =?us-ascii?Q?3bn0WKcQzHOBQeCqisQjuykJ0yapI6XzA+ksb37qKCn3ekTJ4Ux8VBpSRUyh?=
 =?us-ascii?Q?lT8/KD4+IyveYk/5ZSwR1cGDiLA9I5gHe3Bm+js+j8ADt0PKJAvVmB7LUh7k?=
 =?us-ascii?Q?Rn+XbYV/CRHCYKRHdeopIpDNQVWrtqiqso6z8ZHdBvpQkvgIrMKv/JPwF9pG?=
 =?us-ascii?Q?+s3/WX+Pe0RqFxsD98INFIebsha0+RzRbe79tMRyxLPL1XyBmLqyEHPGCRcK?=
 =?us-ascii?Q?NRzT8WLxCIVH5XdHNLsR9UvHd0I7Fuvunpteoytq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a03bc92f-562b-418d-aec0-08dbf5c67580
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2023 19:14:52.8253
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jo5CPGpjxc9fC4awmXGwZLqL/Kl0Dj7+tHFEcePdvohKBDDu5UBUPu+ysPVw6u+1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6588

Consolidate some more code by having release call
arm_smmu_attach_dev_identity/blocked() instead of open coding this.

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 386bf954542e7d..8269e2fed6038b 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2901,19 +2901,16 @@ static struct iommu_device *arm_smmu_probe_device(struct device *dev)
 static void arm_smmu_release_device(struct device *dev)
 {
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
-	struct arm_smmu_ste target;
 
 	if (WARN_ON(arm_smmu_master_sva_enabled(master)))
 		iopf_queue_remove_device(master->smmu->evtq.iopf, dev);
 
 	/* Put the STE back to what arm_smmu_init_strtab() sets */
 	if (disable_bypass && !dev->iommu->require_direct)
-		arm_smmu_make_abort_ste(&target);
+		arm_smmu_attach_dev_blocked(&arm_smmu_blocked_domain, dev);
 	else
-		arm_smmu_make_bypass_ste(&target);
-	arm_smmu_install_ste_for_dev(master, &target);
+		arm_smmu_attach_dev_identity(&arm_smmu_identity_domain, dev);
 
-	arm_smmu_detach_dev(master);
 	arm_smmu_disable_pasid(master);
 	arm_smmu_remove_master(master);
 	if (master->cd_table.cdtab)
-- 
2.43.0

