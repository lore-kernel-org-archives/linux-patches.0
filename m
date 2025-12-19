Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010046.outbound.protection.outlook.com [52.101.193.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2D1F3314A8;
	Fri, 19 Dec 2025 17:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766163962; cv=fail; b=MIMPdW6gko9aOubBsSr3GMVZLe43lCMj0ZrEfq/uZeSXrLBuAaa4la4NASnB61Ghhva/Wsg7/6ZkSiF2lPDnSW9GLNTpZdlO6ROlcQu4bLBhPEVfNyISQPP5KVwOO+hLveFTrx4Op3Sb8UuTAYKSNL4DhE5YLrSErpEcLokKZGU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766163962; c=relaxed/simple;
	bh=dyTafrnHFtW5vhgIXbXIfLXfC0qfDBW7fmUwwkn/Mlg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=eh9Zm4b1uvcSVwGPZR17NyT7SQC+IBkuOaNXqKsVdwszH0O9KpWzaovgbQtUVpfWmyHdO+giSCLERlxqr/Rv637Bfg47w73vNzAM6f9zXnCU9IkkxhqyttoHa1ABi+3ty+sv3vASIj9vamu11fOm4Rmb3DRN3Yi3yf4bvWyX6VM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=EGa9d05+; arc=fail smtp.client-ip=52.101.193.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="EGa9d05+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mAgJkO12Nozps/VSAuSER7Kxj+zsmMJ+AcfeujI55JjSJ1b5dqICqBFo39/6mcV1hsDFvrvfQj1j2sd+yipYpdII48fyOOo2MOUOSZIu48BgsXL9vRENqPVFw25FW03mduc1SAUIbLekhdGjHY8ZvHHzJ7uP0gagXVkcahQs2HadN7wnJsJdIaKfY09aB0W7giIapSwAf8JLZ2NdJp0YBfyFGYFEamWmuwNMAE1eiNh/eJWpKh8fpaz1yHwa7KihcdxQZECYOxNgTa03EV3f6w268qFpvjfSZ05cgRVlX6qp+x7lNkOeZuWR2D0hLIrm5CxmGDB53fNvNASrVR60UQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2dVlFRr2lEx82GmrT/rriFHv/wLJCyh0fU2bF/NcbiE=;
 b=rE7GqgzqhnsslhWUOg5xCHloTfnPgKUodTTQaML3ZMHGD3OLREf6v/MEVy6rQTCXFe2r8LMT6o93/HA6wvFzawW9YLKDoYrf6FcsTXAW4x0ozEW6XDMenV+XclONaW83kTrASVbM9AWF/hpBD1eDJ9Sk+jtoyjyN9QgiZUWDPWrzMX7knXoZ/pakVncH4tn3zW9K4Y/Nazn9JmdBzntOyUvrU5L4tb+2IB9XZvZC+Dv3GTWTRbOXhuD4PPU9/p1I05JpHEBWASWVmOOFrKcui+bFbxyiBJaK03TfGGdJapTWbIh2+RoiqlVgimGlAXIGIX6LegrPWq/ohgL3FsZreg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2dVlFRr2lEx82GmrT/rriFHv/wLJCyh0fU2bF/NcbiE=;
 b=EGa9d05+c0JBKm6jajb4GUv8Vf4oTNH/2m4KazHkMsS7VE4SEvf+lF3OsWvsEGh9tYXggmdIRe6+8W7jfDIT7/ons1ebUvTbttzsyDC36AjKbe7F6FZoaGuRwTuTjA+Yb1aBIvdGt0itsdAgmILpavG2QxIVQxEr1QDHivG92xCHdsMn/nHISM/dJvPwWJcvOyG4rsS5JygFLriDltLQH8D6j+HxnrNAv+mbLaOVHMIO2M06c6wKGhoO0lMmxVYnZZegnnoSLxhzaXRWLq5ahTW+PqBAyJq1nhfhYpmF+7pRpq9pW7Oxo8vOteKYp9f3bD28oNEXMoeF3gMCQ2R8Sg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DM6PR12MB4153.namprd12.prod.outlook.com (2603:10b6:5:212::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.9; Fri, 19 Dec
 2025 17:05:53 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9434.009; Fri, 19 Dec 2025
 17:05:52 +0000
Date: Fri, 19 Dec 2025 13:05:51 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: will@kernel.org, robin.murphy@arm.com, joro@8bytes.org, jpb@kernel.org,
	praan@google.com, miko.lenczewski@arm.com,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v1 2/9] iommu/arm-smmu-v3: Add alloc_id/free_id functions
 to arm_smmu_invs
Message-ID: <20251219170551.GF254720@nvidia.com>
References: <cover.1766088962.git.nicolinc@nvidia.com>
 <1541ea4a9e9c935c2f907c0c5f13a4af2bdc2114.1766088962.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1541ea4a9e9c935c2f907c0c5f13a4af2bdc2114.1766088962.git.nicolinc@nvidia.com>
X-ClientProxiedBy: MN0PR03CA0001.namprd03.prod.outlook.com
 (2603:10b6:208:52f::28) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DM6PR12MB4153:EE_
X-MS-Office365-Filtering-Correlation-Id: 4139a3d2-ed37-4358-8763-08de3f20ddcf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Pmif2lvALPFttVnlORZY7CptK+WNY0B0ilUH9HqNk9KWPOVUyZEMZw3OhTFJ?=
 =?us-ascii?Q?BQ2k9bY9z6HSawXMZPrAdR5i+amaRD7AKYo0dN9+UgMM2QVt4O+MqkqyxRrw?=
 =?us-ascii?Q?sniwby6rE3y/764NlE46EAo1WD8byxsvRdd1crCxwLERhDFweamPLiH3N2/V?=
 =?us-ascii?Q?ckQg78AW6ZLk+O1SXSIKYqsvevBvRv566nXs3QxnbJrJtaeBSRGgM52JHsMS?=
 =?us-ascii?Q?Kfx601p+LPtrNDCDMJnJqKLKrjJKQuVa+k93PBSYJReeFKmlEDcXp+4LXRM5?=
 =?us-ascii?Q?yQd952ALv+JUPDWN5QXuNCGIiVkZW01hhHHmItIHJNNnU1KU0h9USNqYBWZs?=
 =?us-ascii?Q?CHjrKnvrrJqKuluArMgNfcZmiOoogdNy9SN+MUDhiIHOlDysgT/NHPI7ZJhF?=
 =?us-ascii?Q?PUiZMyQ4MOHY21AgSfjyQZsZhDQJtcztwdq5wWMV1YeSu+OmdrFEJX2RA9Fm?=
 =?us-ascii?Q?85tRjBdx0+EeOZuNptR9FgrV99rQAIYGwc/1z12qE+ZMID6aVq8Pq+COpjvP?=
 =?us-ascii?Q?63NrRc+ve8S7eY1g1hR3N5gC/7ZfvJO8pXiptE/d7SudkIbAHAGKco1zoPMI?=
 =?us-ascii?Q?vqmUkL+3uyPoJtauBYF46vmzwz3SOhreth/zhqTLo5WK7R5KrQHqFvDeEsvM?=
 =?us-ascii?Q?xgdNtLJka4S+lyaVBnbSF0OdFM5U2lgFpoGH0kxqDddPSBwZVqFonq2e9Pgb?=
 =?us-ascii?Q?3/xDhDE+txH1s4oHl6ES7O3HM2qNI/o277n9Pnftpeh5v+xxlv52trP7h+ED?=
 =?us-ascii?Q?Du/aL2rdiknvV0N34/aJUScaSkuKnAODVEzTwiys7C5xW+WkU1b6cXu89yVJ?=
 =?us-ascii?Q?Zp45IfZh2AFh/9fsfLjM1XtrC02T7OvZLWND8rmEE8eus2NAa8aAipdGcUmg?=
 =?us-ascii?Q?nHMvLjGxRLwbjUncMaTMyuAuPTjQfLHdu1ioQPMvcEUthHDMsD3Uz9Olh+vu?=
 =?us-ascii?Q?9cbub4FGmltriDibJT902Vp7MFh24c0cHkzGZ/3Eq5G8dhhMe1vGeH4lFi+w?=
 =?us-ascii?Q?stITyNS71uVQZiBaI4shzAV0gbDkv+cq22Q43IfQ96oihR3TNMxSQaVhENTT?=
 =?us-ascii?Q?vC0/eWPR5uela4bFhwiunZQBL98QwgAs6zn8ELBnjrnV68XqgAAJYy/9dRln?=
 =?us-ascii?Q?dj4Z8upab2F/Pgned6LYVrnV/5MeW5OSIq+EnMErkSU3MrsCh2/5L5cA+bME?=
 =?us-ascii?Q?WgYMS0r5Bld1KROOjdmnyUiUXBz4vHgu259q4Q9W4sOq+DQZyUXKEGp/yD7S?=
 =?us-ascii?Q?mllp5qA2UOjz7XUB7aLa9suZIL244RYUpBJ+dc6hqfB+rOR5qRVqrtNbf8+q?=
 =?us-ascii?Q?+4AuDwjVJj+95Vl2akMSSW71DBLPVTFPHOYaCbTWlNWCFXUmsSmbUGtixItg?=
 =?us-ascii?Q?kLtUpJHEdtcnoHxZUOA6ijUM0BNVDPeIKxD9c+s3vGrxOKgh1j7SyoXMB7HP?=
 =?us-ascii?Q?UsuVuQaV3ZFVJi2E09D8JADlEsIJY9DJ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?f2FGsW8VhXxMAWaE909GX0KW4j+OHcXqyexqMdLUwhsjgnM1NOdP5khNo+2Y?=
 =?us-ascii?Q?GiQUUea9AWCCNcBtXxxDdCenTuIyChliu/AGHWqMIiFDpfONSsUc+S/Z8cRq?=
 =?us-ascii?Q?o4mcCObX5LDIudRJK2gHh0dfHdkIsmycVLVYzUz4ugXhtfh7RsJSSWSQ+Qz0?=
 =?us-ascii?Q?Qk9QAB32VGO++hBFSOV6xFHNnBSlYNmWeg+Cydzh5NZxtETgIGPUl193GV7G?=
 =?us-ascii?Q?dBluRxoMPYJEHVPccYA/j14Ftzp9iyP2hdcAIq+BW+BE+5wuXCUUAM50+snU?=
 =?us-ascii?Q?2XOtHP7ERTpt4g+ogfjrSTC7gN99exFXR0xujN8GyuEkBSHtv8sEpjLRR9SO?=
 =?us-ascii?Q?XDFCVsI5FOMNCijLhqMIbLVLAvKJZpt65jNOYT6zfeFP+nsKOKPliy2msrzA?=
 =?us-ascii?Q?CIaqKf9RTjSxrKrOf1bsQTQxHvDJoqL/b7nVU2YiR9jPsJxR1zBfNAtX+DsR?=
 =?us-ascii?Q?GkqLq3ZCHPtN5XHgbGz+0HkNiM1QpuTUX8uXbzJUvl+N73MCzO/cVlVUsBHa?=
 =?us-ascii?Q?0vTyh88TLqnfq7SkspQK9tGXKSsB2YcSxgVThaMeNRGGieeWs9pnVHyb7Eq4?=
 =?us-ascii?Q?txppNfUQilnktF0M37gRDHzhupy+ZsfHEbsJmUCq0ipx+7r9qRCYPNmUtnXG?=
 =?us-ascii?Q?VEtIb5hFkirPyEU/NTe/k2Ue6iJFywxYzMW+wOt6nbCd+nhMLpDb82dOzR4c?=
 =?us-ascii?Q?i0kSNKuz5Wo9hp5ZySK66oXRZ0hP84+GCSxXl2d5156Mef5JAiWAbvNirde4?=
 =?us-ascii?Q?WeXdkHA43gcgQyOJnXujgAp74KlR0P8nC+KR8MXtm0IfveXtj0g9YducLEov?=
 =?us-ascii?Q?rtWBd4kCJVI22a3eyIoMPv+MkTmiN/l1di4QjQH4vUCsO1hueRoxqf53goNd?=
 =?us-ascii?Q?viP1oraToYdSdKktsihblAkLsz3IXYj3VUcB8yCIg6HTlglxCS3vcvakmXk9?=
 =?us-ascii?Q?QriAaae1GY5R1eWqILxY/CpbkNls55lIyi4zv5waYuk8m70jrz51C4Cbavtl?=
 =?us-ascii?Q?sxGMR6ltzOdnBCYk3C2IYHiFfmcV8mBzwyKIz9O9f8ZrMycGzyyolCJjT9oF?=
 =?us-ascii?Q?2lHD4zHsBf/SOUfDjS6rZqTtKBTU6+HiQ7LUqkl1ueR5qPvRzdbaimVeo4JZ?=
 =?us-ascii?Q?iBIDaSgCg3GSKChpwkjKq4wvQo0FKbXrJcAXSeU7XVjFlIS+y1dlrJ+Xpn3S?=
 =?us-ascii?Q?IqiC0fpejxbR5Gx8a9djP+Hs7bmvgdUKQfSB1+d13aCORxsNINP8mrbJH9QV?=
 =?us-ascii?Q?MaWHg1+D5Hax6z5yeXuRQ2fkwCJZ8p8iz1jg+yRYjGSzgas6k6z2p8J5dx5j?=
 =?us-ascii?Q?zzR6htwBYlOB1dfSdYgEDMmrYRm8n+5CtG1HGuSebTqhbibNFxub2wXCN7RV?=
 =?us-ascii?Q?iykFgZcl828eKz51637QAZHW0OqLo0nRSRS9hBqjyydo3ihk+4zAzbKcg63H?=
 =?us-ascii?Q?oknOHOtkHhIXS+edVEtUFurkfwOgqs+NKJ1WGB0P+NjQHAb+v6JB6uOexSZA?=
 =?us-ascii?Q?7X8yKl11kB+GUScdsrXQWXd/G6shl4eL3zda3Z/cagbZDa6KsEO1Z3KsVH/K?=
 =?us-ascii?Q?y9pdQRCfw/kIxsi2stn6bmHf2nryT1JBoYKe1r3aN5nZhDl7ZMJm893Evgbo?=
 =?us-ascii?Q?pP0DTPRpaNErCDaEAk3LtsyjmEP18Rgfb0LOpU7/4qBPDwM5DJOQHDCU1jlp?=
 =?us-ascii?Q?2u3LOKJSg4DEZdU/o3dpyT0m8y5GHYN57sA+ypDpy3xTNO9L?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4139a3d2-ed37-4358-8763-08de3f20ddcf
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 17:05:52.8451
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qpRmGIatpXKm1kpl1dFRwycEFjnnVE127s/VyBWHcXKjGK743oxJC4UBhgpKabVP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4153

On Thu, Dec 18, 2025 at 12:26:48PM -0800, Nicolin Chen wrote:
> @@ -720,6 +723,9 @@ struct arm_smmu_invs {
>  	rwlock_t rwlock;
>  	bool has_ats;
>  	struct rcu_head rcu;
> +	struct arm_smmu_domain *smmu_domain;
> +	int (*alloc_id)(struct arm_smmu_inv *inv, void *data);
> +	void (*free_id)(struct arm_smmu_inv *inv, bool flush);
>  	struct arm_smmu_inv inv[] __counted_by(max_invs);
>  };

I'm not keen on this at all..

On the allocation side everything should be stored inside the
invalidation list, we don't need function callbacks, just get the
information from the list in the first place.

You could probably split it up a bit, introduce arm_smmu_iotlb_tag
first and spread it around, filling it from the domain, then the below
to use the invs array to fill it. But this whole series
should basically just be this:

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index d7c492ee093602..5cd71a9690e292 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1188,8 +1188,7 @@ EXPORT_SYMBOL_IF_KUNIT(arm_smmu_invs_merge);
  */
 VISIBLE_IF_KUNIT
 void arm_smmu_invs_unref(struct arm_smmu_invs *invs,
-			 struct arm_smmu_invs *to_unref,
-			 void (*free_fn)(struct arm_smmu_inv *inv))
+			 struct arm_smmu_invs *to_unref)
 {
 	unsigned long flags;
 	size_t num_invs = 0;
@@ -1200,16 +1199,16 @@ void arm_smmu_invs_unref(struct arm_smmu_invs *invs,
 		if (cmp < 0) {
 			/* not found in to_unref, leave alone */
 			num_invs = i + 1;
+			refcount_set(&to_unref->inv[j].users, 1);
 		} else if (cmp == 0) {
 			/* same item */
 			if (!refcount_dec_and_test(&invs->inv[i].users)) {
 				num_invs = i + 1;
+				refcount_set(&to_unref->inv[j].users, 1);
 				continue;
 			}
 
-			/* KUNIT test doesn't pass in a free_fn */
-			if (free_fn)
-				free_fn(&invs->inv[i]);
+			refcount_set(&to_unref->inv[j].users, 0);
 			invs->num_trashes++;
 		} else {
 			/* item in to_unref is not in invs or already a trash */
@@ -3046,6 +3045,13 @@ arm_smmu_find_master_domain(struct arm_smmu_domain *smmu_domain,
 	return NULL;
 }
 
+static struct arm_vsmmu *to_vsmmu(struct iommu_domain *domain)
+{
+	if (domain->type == IOMMU_DOMAIN_NESTED)
+		return to_smmu_nested_domain(domain)->vsmmu;
+	return NULL;
+}
+
 /*
  * If the domain uses the smmu_domain->devices list return the arm_smmu_domain
  * structure, otherwise NULL. These domains track attached devices so they can
@@ -3156,12 +3162,136 @@ arm_smmu_master_build_inv(struct arm_smmu_master *master,
 	case INV_TYPE_ATS:
 	case INV_TYPE_ATS_FULL:
 		cur->size_opcode = cur->nsize_opcode = CMDQ_OP_ATC_INV;
+		cur->ssid = ssid;
 		break;
 	}
 
 	return cur;
 }
 
+static int arm_smmu_get_id_from_invs(struct arm_smmu_domain *smmu_domain,
+				     struct arm_smmu_device *smmu,
+				     unsigned int type)
+{
+	struct arm_smmu_invs *invs = rcu_dereference_protected(
+		smmu_domain->invs, lockdep_is_held(&arm_smmu_asid_lock));
+	size_t i;
+
+	for (i = 0; i != invs->num_invs; i++) {
+		if (invs->inv[i].type == type &&
+		    invs->inv[i].smmu == smmu &&
+		    refcount_read(&invs->inv[i].users))
+		    return invs->inv[i].id;
+	}
+
+	return -ENOENT;
+}
+
+static int arm_smmu_get_tag(struct arm_smmu_domain *smmu_domain,
+			    struct arm_smmu_master *master,
+			    struct arm_vsmmu *vsmmu,
+			    struct arm_smmu_iotlb_tag *tag, bool no_alloc)
+{
+	struct arm_smmu_device *smmu = master->smmu;
+	int ret;
+	int id;
+
+	lockdep_assert_held(&arm_smmu_asid_lock);
+
+	switch (smmu_domain->stage) {
+	case ARM_SMMU_DOMAIN_SVA:
+	case ARM_SMMU_DOMAIN_S1: {
+		u32 asid;
+
+		if (WARN_ON(vsmmu))
+			return -EINVAL;
+
+		id = arm_smmu_get_id_from_invs(smmu_domain, smmu,
+					       INV_TYPE_S1_ASID);
+		if (id > 0) {
+			tag->asid = id;
+			return 0;
+		}
+
+		if (no_alloc)
+			return -ENOENT;
+
+		ret = xa_alloc(&arm_smmu_asid_xa, &asid, smmu_domain,
+			       XA_LIMIT(1, (1 << smmu->asid_bits) - 1),
+			       GFP_KERNEL);
+		if (ret)
+			return ret;
+		tag->asid = asid;
+		tag->need_free = 1;
+		return 0;
+	}
+
+	case ARM_SMMU_DOMAIN_S2:
+		if (smmu_domain->nest_parent) {
+			/* FIXME we can support attaching a nest_parent without
+			 * a vsmmu, but to do that we need to fix
+			 * arm_smmu_get_id_from_invs() to never return the vmid
+			 * of a vsmmu. Probably by making a
+			 * INV_TYPE_S2_VMID_VSMMU */
+			id = vsmmu->vmid;
+			return 0;
+		}
+
+		id = arm_smmu_get_id_from_invs(smmu_domain, smmu,
+					       INV_TYPE_S2_VMID);
+		if (id > 0) {
+			tag->vmid = id;
+			break;
+		}
+
+		if (no_alloc)
+			return -ENOENT;
+
+		/* Reserve VMID 0 for stage-2 bypass STEs */
+		id = ida_alloc_range(&smmu->vmid_map, 1,
+				     (1 << smmu->vmid_bits) - 1, GFP_KERNEL);
+		if (id < 0)
+			return id;
+		tag->vmid = id;
+		tag->need_free = 1;
+		return 0;
+	}
+	return -EINVAL;
+}
+
+static void arm_smmu_free_tag(struct arm_smmu_master *master,
+			      struct arm_smmu_domain *smmu_domain,
+			      struct arm_smmu_iotlb_tag *tag,
+			      struct arm_smmu_inv *inv)
+{
+	struct arm_smmu_device *smmu = master->smmu;
+	struct arm_smmu_cmdq_ent cmd = {};
+
+	switch (smmu_domain->stage) {
+	case ARM_SMMU_DOMAIN_SVA:
+	case ARM_SMMU_DOMAIN_S1:
+		cmd.opcode = inv->nsize_opcode;
+		cmd.tlbi.asid = tag->asid;
+		arm_smmu_cmdq_issue_cmd_with_sync(smmu, &cmd);
+		xa_erase(&arm_smmu_asid_xa, tag->asid);
+		return;
+
+	case ARM_SMMU_DOMAIN_S2:
+		cmd.opcode = inv->nsize_opcode;
+		cmd.tlbi.vmid = tag->vmid;
+		arm_smmu_cmdq_issue_cmd_with_sync(smmu, &cmd);
+
+		/*
+		 * Even though the VMID remains with the viommu and is not freed
+		 * we are stopping invalidations of it so it has to be cleared.
+		 */
+		if (smmu_domain->nest_parent)
+			return;
+		ida_free(&smmu->vmid_map, tag->vmid);
+		return;
+	}
+}
+
 /*
  * Use the preallocated scratch array at master->build_invs, to build a to_merge
  * or to_unref array, to pass into a following arm_smmu_invs_merge/unref() call.
@@ -3171,7 +3301,8 @@ arm_smmu_master_build_inv(struct arm_smmu_master *master,
  */
 static struct arm_smmu_invs *
 arm_smmu_master_build_invs(struct arm_smmu_master *master, bool ats_enabled,
-			   ioasid_t ssid, struct arm_smmu_domain *smmu_domain)
+			   ioasid_t ssid, struct arm_smmu_domain *smmu_domain,
+			   struct arm_smmu_iotlb_tag *tag)
 {
 	const bool nesting = smmu_domain->nest_parent;
 	size_t pgsize = 0, i;
@@ -3188,14 +3319,14 @@ arm_smmu_master_build_invs(struct arm_smmu_master *master, bool ats_enabled,
 	case ARM_SMMU_DOMAIN_SVA:
 	case ARM_SMMU_DOMAIN_S1:
 		if (!arm_smmu_master_build_inv(master, INV_TYPE_S1_ASID,
-					       smmu_domain->cd.asid,
-					       IOMMU_NO_PASID, pgsize))
+					       tag->asid, IOMMU_NO_PASID,
+					       pgsize))
 			return NULL;
 		break;
 	case ARM_SMMU_DOMAIN_S2:
 		if (!arm_smmu_master_build_inv(master, INV_TYPE_S2_VMID,
-					       smmu_domain->s2_cfg.vmid,
-					       IOMMU_NO_PASID, pgsize))
+					       tag->vmid, IOMMU_NO_PASID,
+					       pgsize))
 			return NULL;
 		break;
 	default:
@@ -3205,9 +3336,9 @@ arm_smmu_master_build_invs(struct arm_smmu_master *master, bool ats_enabled,
 
 	/* All the nested S1 ASIDs have to be flushed when S2 parent changes */
 	if (nesting) {
-		if (!arm_smmu_master_build_inv(
-			    master, INV_TYPE_S2_VMID_S1_CLEAR,
-			    smmu_domain->s2_cfg.vmid, IOMMU_NO_PASID, 0))
+		if (!arm_smmu_master_build_inv(master,
+					       INV_TYPE_S2_VMID_S1_CLEAR,
+					       tag->vmid, IOMMU_NO_PASID, 0))
 			return NULL;
 	}
 
@@ -3270,12 +3401,14 @@ static void arm_smmu_remove_master_domain(struct arm_smmu_master *master,
  * we are sequencing to update them.
  */
 static int arm_smmu_attach_prepare_invs(struct arm_smmu_attach_state *state,
+					struct iommu_domain *new_domain,
 					struct arm_smmu_domain *new_smmu_domain)
 {
 	struct arm_smmu_domain *old_smmu_domain =
 		to_smmu_domain_devices(state->old_domain);
 	struct arm_smmu_master *master = state->master;
 	ioasid_t ssid = state->ssid;
+	int ret;
 
 	/*
 	 * At this point a NULL domain indicates the domain doesn't use the
@@ -3289,8 +3422,18 @@ static int arm_smmu_attach_prepare_invs(struct arm_smmu_attach_state *state,
 		invst->old_invs = rcu_dereference_protected(
 			new_smmu_domain->invs,
 			lockdep_is_held(&arm_smmu_asid_lock));
-		build_invs = arm_smmu_master_build_invs(
-			master, state->ats_enabled, ssid, new_smmu_domain);
+
+		/* Re-use or allocate an IOTLB cache tag */
+		ret = arm_smmu_get_tag(new_smmu_domain, master,
+				       to_vsmmu(new_domain), &invst->tag,
+				       false);
+		if (ret)
+			return ret;
+
+		build_invs = arm_smmu_master_build_invs(master,
+							state->ats_enabled,
+							ssid, new_smmu_domain,
+							&invst->tag);
 		if (!build_invs)
 			return -EINVAL;
 
@@ -3311,9 +3454,18 @@ static int arm_smmu_attach_prepare_invs(struct arm_smmu_attach_state *state,
 			invst->old_invs = rcu_dereference_protected(
 				old_smmu_domain->invs,
 				lockdep_is_held(&arm_smmu_asid_lock));
+
+		/* Find the IOTLB cache tag this master was using */
+		ret = arm_smmu_get_tag(old_smmu_domain, master,
+				       to_vsmmu(state->old_domain), &invst->tag,
+				       true);
+		if (WARN_ON(ret))
+			return ret;
+
 		/* For old_smmu_domain, new_invs points to master->build_invs */
 		invst->new_invs = arm_smmu_master_build_invs(
-			master, master->ats_enabled, ssid, old_smmu_domain);
+			master, master->ats_enabled, ssid, old_smmu_domain,
+			&invst->tag);
 	}
 
 	return 0;
@@ -3349,36 +3501,13 @@ arm_smmu_install_new_domain_invs(struct arm_smmu_attach_state *state)
 	kfree_rcu(invst->old_invs, rcu);
 }
 
-/*
- * When an array entry's users count reaches zero, it means the ASID/VMID is no
- * longer being invalidated by map/unmap and must be cleaned. The rule is that
- * all ASIDs/VMIDs not in an invalidation array are left cleared in the IOTLB.
- */
-static void arm_smmu_inv_flush_iotlb_tag(struct arm_smmu_inv *inv)
-{
-	struct arm_smmu_cmdq_ent cmd = {};
-
-	switch (inv->type) {
-	case INV_TYPE_S1_ASID:
-		cmd.tlbi.asid = inv->id;
-		break;
-	case INV_TYPE_S2_VMID:
-		/* S2_VMID using nsize_opcode covers S2_VMID_S1_CLEAR */
-		cmd.tlbi.vmid = inv->id;
-		break;
-	default:
-		return;
-	}
-
-	cmd.opcode = inv->nsize_opcode;
-	arm_smmu_cmdq_issue_cmd_with_sync(inv->smmu, &cmd);
-}
-
 /* Should be installed after arm_smmu_install_ste_for_dev() */
 static void
 arm_smmu_install_old_domain_invs(struct arm_smmu_attach_state *state)
 {
 	struct arm_smmu_inv_state *invst = &state->old_domain_invst;
+	struct arm_smmu_domain *old_smmu_domain =
+		to_smmu_domain_devices(state->old_domain);
 	struct arm_smmu_invs *old_invs = invst->old_invs;
 	struct arm_smmu_invs *new_invs;
 
@@ -3387,8 +3516,10 @@ arm_smmu_install_old_domain_invs(struct arm_smmu_attach_state *state)
 	if (!invst->invs_ptr)
 		return;
 
-	arm_smmu_invs_unref(old_invs, invst->new_invs,
-			    arm_smmu_inv_flush_iotlb_tag);
+	arm_smmu_invs_unref(old_invs, invst->new_invs);
+	if (old_smmu_domain && !refcount_read(&invst->new_invs->inv[0].users))
+		arm_smmu_free_tag(state->master, old_smmu_domain, &invst->tag,
+				  invst->new_invs->inv);
 
 	new_invs = arm_smmu_invs_purge(old_invs);
 	if (!new_invs)
@@ -3472,9 +3603,9 @@ int arm_smmu_attach_prepare(struct arm_smmu_attach_state *state,
 				     arm_smmu_ats_supported(master);
 	}
 
-	ret = arm_smmu_attach_prepare_invs(state, smmu_domain);
+	ret = arm_smmu_attach_prepare_invs(state, new_domain, smmu_domain);
 	if (ret)
-		return ret;
+		goto err_unprepare_invs;
 
 	if (smmu_domain) {
 		if (new_domain->type == IOMMU_DOMAIN_NESTED) {
@@ -3551,6 +3682,10 @@ int arm_smmu_attach_prepare(struct arm_smmu_attach_state *state,
 err_free_vmaster:
 	kfree(state->vmaster);
 err_unprepare_invs:
+	if (state->new_domain_invst.tag.need_free)
+		arm_smmu_free_tag(master, smmu_domain,
+				  &state->new_domain_invst.tag,
+				  state->new_domain_invst.new_invs.inv);
 	kfree(state->new_domain_invst.new_invs);
 	return ret;
 }
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 4f104c1baa67a2..689b5ca7d61525 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -1103,6 +1103,12 @@ static inline bool arm_smmu_master_canwbs(struct arm_smmu_master *master)
 	       IOMMU_FWSPEC_PCI_RC_CANWBS;
 }
 
+struct arm_smmu_iotlb_tag {
+	u16 need_free : 1;
+	u16 asid;
+	u16 vmid;
+};
+
 /**
  * struct arm_smmu_inv_state - Per-domain invalidation array state
  * @invs_ptr: points to the domain->invs (unwinding nesting/etc.) or is NULL if
@@ -1116,6 +1122,7 @@ struct arm_smmu_inv_state {
 	struct arm_smmu_invs __rcu **invs_ptr;
 	struct arm_smmu_invs *old_invs;
 	struct arm_smmu_invs *new_invs;
+	struct arm_smmu_iotlb_tag tag;
 };
 
 struct arm_smmu_attach_state {
