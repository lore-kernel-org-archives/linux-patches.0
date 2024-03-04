Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2075.outbound.protection.outlook.com [40.107.94.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7921E7D077;
	Mon,  4 Mar 2024 23:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709595869; cv=fail; b=giIxBU9UgEpCoL6Gzwy3qZFZVxYQdNIsQf9yhD01bkakXN3+qabOwciTxKCyDwBU5tkfaH5oYQLiUcC/0IgWMEXXiXzPAdXri37rY/0qnGjlU7bpT0xA9b2TdvB6ZLyASUowt6WkTggJ+w/U3IJvvVweM3W3ylFt6Mu1gQnYv7c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709595869; c=relaxed/simple;
	bh=js93wKrOYwtThL0+ku4AVLJKe2byW4DD7ABFM/Cni3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SJl//S1kdHzNb9A2HmT+lPqosvdXqDHPN7sWo5++S6ONzvQ69infpdgx4V9MRovH/jdbEjLl2m39ZTpuAKyGPLOGpBVYArRG07OdThe4CkwV8UE4MH1MqPoFTJROuU3aic+KSGiFnsBijxqF6PuGa5B1aqhuSe0MGL8h1SeV8q8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=NoUu+pz7; arc=fail smtp.client-ip=40.107.94.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="NoUu+pz7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BYJXLXIvHi9UQpXUANPBzT9WrHhmxgKJnwBkDX3EeJ8FsuDUTIYvZv/7UvOA4MV2nDmEDiG9QUxAsqwpOBmbW+p872fHm7OyPtTlz5gx7DBv4hO5oxcqoD6/XI09nQ7HAcYRmhLoGYqDHY7uSBMN62+SCiq8MSos2cdz2GaZK55sui8HT2ANJAVzqhRxDQhAJtm7WlKjh4KO1kcfj9LE9ax3f6nN0N4W8tAYofbrO9JjM9UqB8K/DSHIfsaqAJhANHNcPTryYx7G8tRTelGUw/7o9pnMajBsfrWoalMUoDMTrEXRJbPK9hwoYmgtA3tgaANdhOmTEbG2kSyAjEAY7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=72UrjlJ5czb8XbDtsDFdzYYNmht2iDBmTiCw+rKQc+0=;
 b=Qrt6Rxzrv268T50WKCeaZWgcsZ9EzS1giwY3B2yZ/bamc42+8Wg7Md4DibeM3ldMZ2Ot30HCKmbQV4bDVbsEPBy5KvMYJpeUDZSHTGuyPgOBb3Mf5xaOn8StHq3WHrDkWEZ0z2VMHd+8vjUqrU7IrigeR9Kymy4lsWjeDJnqz9Ks/Hu2ZFwIUYLiN3MenOa6gsWPtjBvRFDhcJKjQfzsrmKDcSDt0lV3Uj62KnnWwqDU+WCudkZFLH7xK7oXiIU2Vyi3hB9TgbNnxnaSsk/XIiYk9VdEI1FhwUKDcDtbBmPQHqgg010nZxeSPnA0IUCLTH5LKkRXFF9VsXzVP+XCaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=72UrjlJ5czb8XbDtsDFdzYYNmht2iDBmTiCw+rKQc+0=;
 b=NoUu+pz7Ohqut2y5aw9p6t/HdR7IHkcUZvc9gTOqKtvASK2HF0V/ziwY50B1Fxsr+WUkgE7T8/qiKOEQzQnOiuUmLOTyWbgsO9tGDx9hPbCCpr2rAtVHCOID7EQ53exGojHee3bzJWmh05HtNCEtnvsE9MxWKojvOsP10joXTZKOOLtRr4w8U0mHD4NBRoy0k1lZflRTKHu9Ub3syGA06L9PaporvlNpdUQlhLcbPnIZGpDe30KZdzalaPdVz9FUIULX57VLF8/TakpOAzonvRiXqpEAdUP31N1XiNLUa8hY/gwxzIdska46ku1HQk89s+dZcZmUXcl7Bn8q0klNtw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by MW6PR12MB8949.namprd12.prod.outlook.com (2603:10b6:303:248::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.38; Mon, 4 Mar
 2024 23:44:18 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c33c:18db:c570:33b3]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c33c:18db:c570:33b3%5]) with mapi id 15.20.7339.035; Mon, 4 Mar 2024
 23:44:18 +0000
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
Subject: [PATCH v5 26/27] iommu/arm-smmu-v3: Allow a PASID to be set when RID is IDENTITY/BLOCKED
Date: Mon,  4 Mar 2024 19:44:14 -0400
Message-ID: <26-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR1501CA0012.namprd15.prod.outlook.com
 (2603:10b6:207:17::25) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|MW6PR12MB8949:EE_
X-MS-Office365-Filtering-Correlation-Id: cdefe399-dde4-454c-2cab-08dc3ca500e0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	74O2D7IAUFAlDe+Z0fT8ZvG6PIXA9pAijEPpVasKzOBbhrDGr+goAujrQ/lqVPIBWlKA5UtEaiECZ+4CwgBp5QbPGw3zp2lskpWsWD+9nqs+VHK9YXTexuk82vD+38mSOGa1SUXT0klhdy6p+GN8V/FOGsJEOXEzkdeKumq49yzyE0PantyotUBYL2EvEyZTJYvbpnDzOJNEnXEm9vpMMMXd/f/D8c6/AQbHbKHc/pXEFDefPlc+GqcH7f+HTOw4e9jeN8aiZdAc0Y3WsIJogNgcqbUGJw62yGGMrirJ+OoeItJj2l8VOJDZMfHZ0Uy03ReOJtB2gaRbZHylxM9R75NUHayVeznpF+T7VDeEvDVYnjliztvjBiPa0g2sJN7p4kcB5qyxGKzSkb0585+wkPemr27Kwp08/3ARlUDNavZX8ciBQqPIl0jN8+ilCcnvuOzF6qWgZ6xQ8ebzemlgz1zoE4hd+wMA6gX91hc+NqNwDem+9eXiAEMYbDox3QLXv4ql487zrX7BvEIxY3XtWp68874G71HKP+Lh2p7n+ZXDH4I26CUS5HG8oolm/8lK+O1Vh9YiKaxm3JZ1MG/lFC0xWBXMNXHMbo3sTTwRM+pk2yq+l5bgLIgzb1s/FvV2l+X6y25gtV2gjyXBGjuBq8XB3JcGCJZxNLtgZ381PTY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xorAbTkJzOPBxy2CkaajjoQPSOYKQHRv6eJI1nzcKEHN8VVgTb9EYGZNccn8?=
 =?us-ascii?Q?Ns9tZNKAR7UzmsZg36XvMxCs6RHF2cgg/hGyal9WEyHzIwR7kLNFno5FSN7E?=
 =?us-ascii?Q?Xsjw/n5LHTlp0MeYmT0x2CSoZALWk2VMwgbuGiQ/RGL38sF/yli5/jQTfEzv?=
 =?us-ascii?Q?goUbaM3v95z6GojF/Zc5ft9ksZhHl8m4zWI9s2S6GC4hZ4Fan7NKtGATuGdk?=
 =?us-ascii?Q?TneOIJz1v14KfR/v/hceESrRNLLpag8M5PH+UgUT3qP0YHLKGtAGjZXa2WN2?=
 =?us-ascii?Q?eHKBwJTukR2d+svJPlW0BBKkZB1oC3JD37b3ayeF80daBrP6XXeAIrnaQAGB?=
 =?us-ascii?Q?h1iTZrmsSxKaPpUF1vhsaWSnCsaUYrOBmkgKytevOmuylJRk3iKjS7YWXuDj?=
 =?us-ascii?Q?Rc7UlY1lUikiLR3JOz4v/5vwewzU1qEfSVDpLQa5q32pGQA+k10que5OSRLM?=
 =?us-ascii?Q?j8f4P7e5D/I8Xd8R1zQH9TmGw3atrC32tfLDg/3UcLjUslJ+Ds/oEsOMME4n?=
 =?us-ascii?Q?hCFhPLPx2qRU6UKX+m9jar6EQ8a9eygbuG6aGGpnhPd45A8n/wWd59rnp7MH?=
 =?us-ascii?Q?6efVkdAF/BVNObGwKUFgzek64lpc7fak6qjhPBtwxqjLmn23zjzkZAKaLzPg?=
 =?us-ascii?Q?ue+J0ysz62cMP3bqUnZqqxR0zT6Domliv0i7M/aDive+YcYmAxfvZmoyPXGG?=
 =?us-ascii?Q?v2xGcL6o4RepbLFbs7DxoG0kr7zK2JtgSINom7kb1hfDm04LFGSFe+yhm8pO?=
 =?us-ascii?Q?8nxUW/tuUBCNb8bGQV2N7kWgP+xoJ5USzxhQ33w3NqAUH4Qx2GH8AVGgFDSa?=
 =?us-ascii?Q?coSJXthyKK5MWtWy8oxAxmatKwX9s0knTHfPATcsU2ybtAVQZPq4Tx/ycNUu?=
 =?us-ascii?Q?ZOjpVTn9zLwZjDk/A0xbm/wbx3k0ChkxTPpll1tfeXTpU3oq0+HOcgsK3DK2?=
 =?us-ascii?Q?+8zGXdz+fw6PVXRKlskXLM+p/LEP6yymtIREWstJ82pSSsh+zsKYtuuaU6UL?=
 =?us-ascii?Q?Rxv4lmBAt/DVW/rReE5vpu5q3jre8wqd4o/Aiby7h1HaLU+Y0zwtz+zKOvAM?=
 =?us-ascii?Q?bgLYkqbBkB5z2o20t/ZUvZOasO4/Mv+pfhCC3acjs5iEzB4876/wtxf1FxoF?=
 =?us-ascii?Q?4mPEnVKBGX9duMvy55pAr+rdEQZKo6atPTdVlFcmulBClpGcZb3Xv1KMpJq8?=
 =?us-ascii?Q?GHwSkySF1JgaQq4rooSwSGTZNo7f4T9EySv5ZCeCZZSFHQ3S6pl6RO/1F0Hn?=
 =?us-ascii?Q?+8EiGogg/9DwPT9csOrL80B6GkqhRSyad1/9qXuiMg05FZdwv55h3bltM8Ye?=
 =?us-ascii?Q?j6R2s8HA42KmHDfOX7skbsSHp6uZi5mbPEmSjPSGo7V/dw/m31ZAnfaCLelP?=
 =?us-ascii?Q?IWwBCCYGK0EfNEpI7AvFvVgloc0evD4SpWdSedq/0Uo/KEnxPr7oKFOjaLjQ?=
 =?us-ascii?Q?9i6zMy5cnrYQUb3L9m0alvFOqdtRN41GbW96OCO8bLxLd9XpuCW8mkIR5eEd?=
 =?us-ascii?Q?tP6xlvcVTxCaOPmBkDNKstT6F8JShOD11bu4vW1e8jxps712wJDJpVyp/aIy?=
 =?us-ascii?Q?g761N/Utbeb+x+EdYPzIN6EO4WcanxptXXp396H5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdefe399-dde4-454c-2cab-08dc3ca500e0
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2024 23:44:16.2854
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CrdFochSQgS9vn5DL3jvITuMJm9wXctOKsa9QJ8YCnliKlU0p9SRnNyQmR5UzPHO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8949

If the STE doesn't point to the CD table we can upgrade it by
reprogramming the STE with the appropriate S1DSS. We may also need to turn
on ATS at the same time.

Keep track if the installed STE is pointing at the cd_table and the ATS
state to trigger this path.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 56 ++++++++++++++++++---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  6 ++-
 2 files changed, 52 insertions(+), 10 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 6b5a30c86dda2d..535b28d13da5c4 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2458,6 +2458,13 @@ static void arm_smmu_install_ste_for_dev(struct arm_smmu_master *master,
 	int i, j;
 	struct arm_smmu_device *smmu = master->smmu;
 
+	master->cd_table.in_ste =
+		FIELD_GET(STRTAB_STE_0_CFG, le64_to_cpu(target->data[0])) ==
+		STRTAB_STE_0_CFG_S1_TRANS;
+	master->ste_ats_enabled =
+		FIELD_GET(STRTAB_STE_1_EATS, le64_to_cpu(target->data[1])) ==
+		STRTAB_STE_1_EATS_TRANS;
+
 	for (i = 0; i < master->num_streams; ++i) {
 		u32 sid = master->streams[i].id;
 		struct arm_smmu_ste *step =
@@ -2784,27 +2791,47 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	return 0;
 }
 
-static bool arm_smmu_is_s1_domain(struct iommu_domain *domain)
+static void arm_smmu_update_ste(struct arm_smmu_master *master,
+				struct iommu_domain *sid_domain,
+				bool want_ats)
 {
-	if (!domain || !(domain->type & __IOMMU_DOMAIN_PAGING))
-		return false;
-	return to_smmu_domain(domain)->stage == ARM_SMMU_DOMAIN_S1;
+	unsigned int s1dss = STRTAB_STE_1_S1DSS_TERMINATE;
+	struct arm_smmu_ste ste;
+
+	if (master->cd_table.in_ste && master->ste_ats_enabled == want_ats)
+		return;
+
+	if (sid_domain->type == IOMMU_DOMAIN_IDENTITY)
+		s1dss = STRTAB_STE_1_S1DSS_BYPASS;
+	else
+		WARN_ON(sid_domain->type != IOMMU_DOMAIN_BLOCKED);
+
+	/*
+	 * Change the STE into a cdtable one with SID IDENTITY/BLOCKED behavior
+	 * using s1dss if necessary. The cd_table is already installed then
+	 * the S1DSS is correct and this will just update the EATS. Otherwise
+	 * it installs the entire thing. This will be hitless.
+	 */
+	arm_smmu_make_cdtable_ste(&ste, master, want_ats, s1dss);
+	arm_smmu_install_ste_for_dev(master, &ste);
 }
 
 int arm_smmu_set_pasid(struct arm_smmu_master *master,
 		       struct arm_smmu_domain *smmu_domain, ioasid_t pasid,
 		       const struct arm_smmu_cd *cd)
 {
+	struct iommu_domain *sid_domain = iommu_get_domain_for_dev(master->dev);
 	struct attach_state state = {.ssid = pasid};
 	struct arm_smmu_cd *cdptr;
 	int ret;
 
-	if (smmu_domain->smmu != master->smmu)
+	if (smmu_domain->smmu != master->smmu || pasid == IOMMU_NO_PASID)
 		return -EINVAL;
 
-	if (!arm_smmu_is_s1_domain(iommu_get_domain_for_dev(master->dev)) ||
-	    !master->cd_table.used_sid)
-		return -ENODEV;
+	if (!master->cd_table.in_ste &&
+	    sid_domain->type != IOMMU_DOMAIN_IDENTITY &&
+	    sid_domain->type != IOMMU_DOMAIN_BLOCKED)
+		return -EINVAL;
 
 	cdptr = arm_smmu_get_cd_ptr(master, pasid);
 	if (!cdptr)
@@ -2816,6 +2843,7 @@ int arm_smmu_set_pasid(struct arm_smmu_master *master,
 		goto out_unlock;
 
 	arm_smmu_write_cd_entry(master, pasid, cdptr, cd);
+	arm_smmu_update_ste(master, sid_domain, state.want_ats);
 
 	arm_smmu_attach_commit(master, &state);
 
@@ -2829,6 +2857,7 @@ static void arm_smmu_remove_dev_pasid(struct device *dev, ioasid_t pasid)
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
 	struct arm_smmu_domain *smmu_domain;
 	struct iommu_domain *domain;
+	bool last_ssid = master->cd_table.used_ssids == 1;
 
 	domain = iommu_get_domain_for_dev_pasid(dev, pasid, IOMMU_DOMAIN_SVA);
 	if (WARN_ON(IS_ERR(domain)) || !domain)
@@ -2842,6 +2871,17 @@ static void arm_smmu_remove_dev_pasid(struct device *dev, ioasid_t pasid)
 		arm_smmu_atc_inv_master(master, pasid);
 	arm_smmu_remove_master_domain(master, &smmu_domain->domain, pasid);
 	mutex_unlock(&master->smmu->asid_lock);
+
+	/*
+	 * When the last user of the CD table goes away downgrade the STE back
+	 * to a non-cd_table one.
+	 */
+	if (last_ssid && !master->cd_table.used_sid) {
+		struct iommu_domain *sid_domain =
+			iommu_get_domain_for_dev(master->dev);
+
+		sid_domain->ops->attach_dev(sid_domain, master->dev);
+	}
 }
 
 static void arm_smmu_attach_dev_ste(struct iommu_domain *domain,
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index a23593f1830106..92bff64eef644b 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -600,7 +600,8 @@ struct arm_smmu_ctx_desc_cfg {
 	struct arm_smmu_l1_ctx_desc	*l1_desc;
 	unsigned int			num_l1_ents;
 	unsigned int			used_ssids;
-	bool				used_sid;
+	u8				used_sid;
+	u8				in_ste;
 	u8				s1fmt;
 	/* log2 of the maximum number of CDs supported by this table */
 	u8				s1cdmax;
@@ -708,7 +709,8 @@ struct arm_smmu_master {
 	/* Locked by the iommu core using the group mutex */
 	struct arm_smmu_ctx_desc_cfg	cd_table;
 	unsigned int			num_streams;
-	bool				ats_enabled;
+	bool				ats_enabled : 1;
+	bool				ste_ats_enabled : 1;
 	bool				stall_enabled;
 	bool				sva_enabled;
 	bool				iopf_enabled;
-- 
2.43.2

