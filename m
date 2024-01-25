Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2074.outbound.protection.outlook.com [40.107.243.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3EF313AA4B;
	Thu, 25 Jan 2024 23:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706227072; cv=fail; b=Plev4y2Xt0lzJtv++prMP7hmxQwI305NY8HcZ8zJE8SOiEsCB3Zfo8b3uajGVbOjVG8J/M0p+3aAJtXlCe5SUD8rS+lOsL12Pyyzxmy0RtVoX5V/S0FPatvgLQtfRGz3BeF55rqGs1ECNOMijSc4uvyVkMeAXQDdIK+mifXg2OY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706227072; c=relaxed/simple;
	bh=fNW6yebHATTwznzPInFSg3FUwl5ttBVeAMXYf5RXJEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IngEcsoB+FWFjpPDpBMSsAE1p3dar9uCMkgrI1KtEqkCr9DAeWMb/m2dHvWnHiU5vMSKFG/0a9nSc4U9CtTBo2JKevALOWAfQCi5/L2vSg4csExhORyH/+u9rnP2MrIaLzjqSDNi2D2A6m6dGLAPUFyuLHclASVxVlp6dXJtSA0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=dm/nLXw8; arc=fail smtp.client-ip=40.107.243.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="dm/nLXw8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jGRc94xt/e8FUJGyag5J3gaJ8IJeLzUQcZ82HnoFBUodkNrfjwliZzao6sZAZdb8KJD9JuVO001+Bdq/ohO0ccVP6ip5kbSDcAbptNBWS+XLH8kCpUpjnRiY+IBv0LzmEVpl0v2llAZphODjHZVXxSTla3HNwqOgx14cHtwqMzoSoY1DCWu9K8eZDpjrrcHJJ+gTUCm9Rdc7R/rpKEkMuhLziST8Wn9ENAej2B1rzC+hOFVHWP7ixDOBU+Wm0N84GYPQ+QCALerOXtur+Y5e40RU/v9qWSeBeLN94tc71tzNq6UYK2b/9ATNPBdqUS879KcFmVC0FeA8oaSiOSKNhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t0sjiFmQcOdhTZybnjaAJAn6dKmD6B1S8xkpM0HlFxQ=;
 b=HTyXT9oj+Q9nA6pCySTZQAWdNz6wMjGOue6fVA+mO+c34oDGpOEI9Ux2oBzGaNQlsR7jvHweBL1DPwCTa8ogVBelWs7Zl54m5CnoxNIMLNlpAnl4wv+Twlz5Q8WvuaIyvfl21FU6CI9QU3FGwgLSeW/Z7KSrk0MDtLvQQD0qxTHxROUZFQ7y3cJq0wvMmwIdr0AmMSC9Jg1beCV2wadL/gnZtsGEuU+BqZhE7PLA2NPnM5V3XnC2eRL6kN2gu5Ll3QTZa9AdPWVDtF9uXYdiDhZJi8I7l+5r7S2I/s2l7CwkepFtCAec+479weydscuze9NQyb6REJAqVwR/L/LkGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t0sjiFmQcOdhTZybnjaAJAn6dKmD6B1S8xkpM0HlFxQ=;
 b=dm/nLXw8hfZ/o7pnD0Hqc9cM4+ykeGjgXeaaL4T+yNxf6iPLrD/nfd70cQ7fNj32wzwvmb1uMxyYb9P0BV/eYEHr1lp/URCQp3gZw03/RZNXwB75+9c3FB1RAMvuLE9XWsSdkt6JB7mliXJzkm28FP5S8gQ/xnI1b6y7KH8cwEZCBK/ulgkR3WPF+D5/mLQQNG8nkW5Xh6WzTmzWNZwWAVil49s+04uH4dGajf83cBmbUrl8AAGCe9LOCS3+S5GTIDZIK0FjvpkIeqlO97t/WZpVM+HqxQDsV05tk+lRKzUmaXxAdI7vSUbOeDWHahg9hhy4NWJbUO2PWWTAGzfkDw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SN7PR12MB7881.namprd12.prod.outlook.com (2603:10b6:806:34a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.24; Thu, 25 Jan
 2024 23:57:37 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7228.022; Thu, 25 Jan 2024
 23:57:37 +0000
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
Subject: [PATCH v4 16/16] iommu/arm-smmu-v3: Convert to domain_alloc_paging()
Date: Thu, 25 Jan 2024 19:57:26 -0400
Message-ID: <16-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>
In-Reply-To: <0-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN7PR04CA0027.namprd04.prod.outlook.com
 (2603:10b6:806:f2::32) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SN7PR12MB7881:EE_
X-MS-Office365-Filtering-Correlation-Id: 1aedae19-ff85-4a0f-9337-08dc1e0164de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	J3LHKOVCHhCQInVruJVO1n6Jp6NIQce/35rI+6p95k7V0aRoyEs4JK4JCTRvzffQ2GVDE4rVVe8spvrzmB/y0fO50mG0skNCwi1j9WZIBiT65TGoDFB/xP8xaHk9wxRESKEWKy8Dp4jl3L/XBlhuRBmYq98Fgk+FhKUVyB44EHPplphq+L9GQk651a1FxyE+feWSmrUgV5pg4n6gCpUN4qqfP3CE7T1gURS6ULSeiaFgQP1IDZWts8wPfoTyVYGgxo4Zsfy+WYmKBBNRllhY8lrvY1/onTWx1k035WVVwzbP+jPQ33I/lLNJGTeid9bentcgU3K5KK8HVWHzHEJ1I8CkTBmgjCzVY0bPmMdIu+m+qTCFmFVsL3s3irO+3aBpU3LerkCStmTXYHM9DoG9HtBBEzRO28eE0KHhJgJGcPsGhOgxE8+Tzdpyf2VFn9LlVWfJG9qVegWcGugrrcANKHUxoTZtCDM+rSq4O2lKtUGWgVV5S2VgqHojjR0DORgj2mx29o715eCNoaecsdEVO5fQOOTTjXBnMChxMiQVCVljAAjTYXOoRKH+Io8WjiCX
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(396003)(346002)(39860400002)(366004)(230922051799003)(451199024)(64100799003)(1800799012)(186009)(83380400001)(36756003)(66556008)(86362001)(54906003)(110136005)(66946007)(66476007)(26005)(38100700002)(6512007)(2906002)(2616005)(7416002)(478600001)(6666004)(41300700001)(6506007)(6486002)(5660300002)(316002)(8676002)(4326008)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?aeDImkjH72kbDhBfQvPg/Tfjugjn+RsT57aZj2l3Su08IDAXYnCO1ThJA0AK?=
 =?us-ascii?Q?6+b7zgaEY5Cevjq0mxUa5ca5Mnf/JkpO408ivzl3ge2fWT4TBQ5HwT7iPJh7?=
 =?us-ascii?Q?7uOZqCBjtHyb4mg5/jTCKaoIP1zUNzwQIJUuGe4VgD7JVJfzy8KA63jdgG4L?=
 =?us-ascii?Q?UeeKnJ94Qyi/DFNfFia+hW5Gm92spOaPEMgGjQtvo5g8fbSBaaG8780bKR/5?=
 =?us-ascii?Q?x/r8+8BZKTOD0t1iFC76J+EOKGDslNJXbFYiUmu+5gBDLdlbZgNTwRme7y63?=
 =?us-ascii?Q?P0lJCztS82Kqaub9nWbBpOSiRAqUBtW6IQ/g0uPKW28GlT1hOl6RAhVyfaR/?=
 =?us-ascii?Q?ApVG9tIgjpD2Q9VtkKBmHV/iV/2O7Y4Aco9lriEevAZxCdRQBoowI5djErZD?=
 =?us-ascii?Q?j7ofFOCrjzMWJStHfKDu9dEg/aYST6JB3WSdUgE8WnT7vk3tCii9wxk+YRfo?=
 =?us-ascii?Q?aMHtULduhU5mjjuvUKGRiIeeqUsORjoeckqrScNS1baoO7p4/fgjJxhgCzsS?=
 =?us-ascii?Q?6xj1LoaPPIawpMlCk2C74dOy5JdO2zp6TkDN8QQSdpHB8Dkg6fbUVCzDdSCw?=
 =?us-ascii?Q?wsPME/kQg0tAUlXR+vqTGfBa+9xOK3UuzJPDYhgjO5Y0yWyglMqte6MZq+mo?=
 =?us-ascii?Q?w/kU0DcgbN39+MNDG7zpyhZYdB38gHWKCTnMcpm7Xs/qWQKF1lZr/+kJYl9J?=
 =?us-ascii?Q?U2TSQiF6qks5d0ehJlQbWeZdlxoDO1kRixpRn08XusQbkpYL8rngAP79UYjF?=
 =?us-ascii?Q?TEK4w5kmy5/Jd9VWiH0NClFRJuwGZkCYLh8LdP/aSG18JyXIcN5qkEegPMpO?=
 =?us-ascii?Q?VKkWRD0a16/KFJvR8n+wz+xyfkHQYqKGtALMEtKrmlPEomnH3B13EEzJ1Si6?=
 =?us-ascii?Q?d7wRCIRuRP1jOvAK42rFTWxrvLY0wrv7sPU2aCHSVjk9FBpGvinRr+3GML9T?=
 =?us-ascii?Q?DyvuqE67euJntr7DX/SIr0lBbLketGs4qhSG4+Ftaenj1XRPU3GyTKglife3?=
 =?us-ascii?Q?s681ui5cXvJUt8YvBucLR5zGOy2JpQz0dXNARNUs8pv3DCg1W5CDHMGGxGYT?=
 =?us-ascii?Q?8TnuCaVfSasRHNBuQlxH251uyIUs7nC1oRcKD33noev1hISQqgI+CLyZidme?=
 =?us-ascii?Q?/oszemOgsb2AflbxWsl7pqPgU27lJ5bi1Dhd+2mxPWEcr67+ilIp6INICS1A?=
 =?us-ascii?Q?hxHFpiGz3Y9djcqXxGRDrnw8gHMMODihpLCfNt37YGWIOc3usfv7gYZlSli5?=
 =?us-ascii?Q?LFeIFS4I/Cl/ROnIHC4wM0JPvhqXxm1zyY9l/l+x3ywJAcIGhpkhVJQZTcFG?=
 =?us-ascii?Q?0RjDVr6rrnd/CYrf8KrDjMobajc1LkB3ifY6A2433CB8GWOvsX4+vGqMa5/r?=
 =?us-ascii?Q?fkTO12TEGoms7/3vEAzweDlmevDbjEy9DNsjByAnmKI3fZv6yIP3juQ+vNQQ?=
 =?us-ascii?Q?bFDvSlhgB4TZUOUF1fWQoTO9j2Qncgfcn4NUtCiAX/SF1Kich0pYQ9SF4GJh?=
 =?us-ascii?Q?KSPy/6cD1MVXLtT6Rh9H4qcUBKPkoV9nHsuRq6GjyjcCaQhEBRKSQjoOJbq8?=
 =?us-ascii?Q?DWM50iYhmk5FNhQf7gO9LgZ2d4TB0HJuk9XkL1Jt?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1aedae19-ff85-4a0f-9337-08dc1e0164de
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2024 23:57:31.6551
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2B1j2l0BCkqDSuRKn75SFnqPvRUjabj38fZ27mZM71W4QBBsKmQLoMm3hdX9tBab
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7881

Now that the BLOCKED and IDENTITY behaviors are managed with their own
domains change to the domain_alloc_paging() op.

For now SVA remains using the old interface, eventually it will get its
own op that can pass in the device and mm_struct which will let us have a
sane lifetime for the mmu_notifier.

Call arm_smmu_domain_finalise() early if dev is available.

Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Moritz Fischer <moritzf@google.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 22 ++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index f4543bf0c18a49..f890abe95e57f7 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2222,14 +2222,15 @@ static bool arm_smmu_capable(struct device *dev, enum iommu_cap cap)
 
 static struct iommu_domain *arm_smmu_domain_alloc(unsigned type)
 {
-	struct arm_smmu_domain *smmu_domain;
 
 	if (type == IOMMU_DOMAIN_SVA)
 		return arm_smmu_sva_domain_alloc();
+	return ERR_PTR(-EOPNOTSUPP);
+}
 
-	if (type != IOMMU_DOMAIN_UNMANAGED &&
-	    type != IOMMU_DOMAIN_DMA)
-		return NULL;
+static struct iommu_domain *arm_smmu_domain_alloc_paging(struct device *dev)
+{
+	struct arm_smmu_domain *smmu_domain;
 
 	/*
 	 * Allocate the domain and initialise some of its data structures.
@@ -2238,13 +2239,23 @@ static struct iommu_domain *arm_smmu_domain_alloc(unsigned type)
 	 */
 	smmu_domain = kzalloc(sizeof(*smmu_domain), GFP_KERNEL);
 	if (!smmu_domain)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	mutex_init(&smmu_domain->init_mutex);
 	INIT_LIST_HEAD(&smmu_domain->devices);
 	spin_lock_init(&smmu_domain->devices_lock);
 	INIT_LIST_HEAD(&smmu_domain->mmu_notifiers);
 
+	if (dev) {
+		struct arm_smmu_master *master = dev_iommu_priv_get(dev);
+		int ret;
+
+		ret = arm_smmu_domain_finalise(smmu_domain, master->smmu);
+		if (ret) {
+			kfree(smmu_domain);
+			return ERR_PTR(ret);
+		}
+	}
 	return &smmu_domain->domain;
 }
 
@@ -3108,6 +3119,7 @@ static struct iommu_ops arm_smmu_ops = {
 	.blocked_domain		= &arm_smmu_blocked_domain,
 	.capable		= arm_smmu_capable,
 	.domain_alloc		= arm_smmu_domain_alloc,
+	.domain_alloc_paging    = arm_smmu_domain_alloc_paging,
 	.probe_device		= arm_smmu_probe_device,
 	.release_device		= arm_smmu_release_device,
 	.device_group		= arm_smmu_device_group,
-- 
2.43.0

