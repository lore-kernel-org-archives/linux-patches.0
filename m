Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2055.outbound.protection.outlook.com [40.107.93.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49C0814D29C;
	Wed, 27 Mar 2024 18:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711562916; cv=fail; b=VtDctZhq+ks0ddTEEY1nO5MvjrxCVwfyTk0vK46e2Imz+nm+zhacyf+vSQY4SjWkVjVNovULlBytDX3MTYRWcs1CCuhHjPesKSbfpNuRceQ8nW8fu7vzA9QuiWifSK6lx13LXCBwVCIDxhM+Ut/HClvrA8eXUBfRSDfdb59FZR8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711562916; c=relaxed/simple;
	bh=Cz/csfOR8od7MNr+GZvC287TqxNObpodH9XDfD9wVRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UmKKHp/AFMa+Di7/gshTs1D72KYwgMPtw+RncoJ++Ob14Z8inGIfPH1eanCsBBcmqSt9zAU0gpXe+Fp8PM46TlAVpprcOeCHjrd1iUmU39esv2f2ZzGSYWZ30dPtm052v8dF+GML14dBRBMqBwfhT0fXp3MtETYpYek++DSc9Bs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=OCqhxdCI; arc=fail smtp.client-ip=40.107.93.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="OCqhxdCI"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mYHFioXMR+BXyIJDH0YLCGJO3a0Cjl4HEIGTYJJq2EvgmQcI/+oNxOzbtYXl83jyNYG9V3UmRGETyAmluO/7f1caozw2NKqrHdClNrNZVoOcRZbzXjHEZFd+0FEl32oIeR+4qXn0Stbi2VNGhuQZJC6248fwTl1PPRWC+6ayZypu3bm4RqL3DJm9xQPnA2Q18EBZqmC4ijGIuLspZF8MnTYSyE/6BJdaEV8kmsjKpkX5t8abiibnfxxdJJ7PxhPOziRUJ1rw2yYNX7yBAhwgTQC/KkEw66L3gztA6hstInY4otarwYRNSQpMPvcLILs4d92GjDiQT/dFEtgdH5w2wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JS8oOgns0RpldlkoAuexcNfWp7baY2eah7vEr5Y/FZs=;
 b=BPVA8PqEb10smbfi6MQ5xnyVpnkAJT9+4Hchp4gLlJxlnJYVi3DwzXJ/N9l+VCFBRCgfW4OkFV1z1tw9dKApDkxrA3d7cgXa7N7SLqWUmb3k2Qic28Ocswj85bMaW+SsWgIYrO6OoEecY36vPTp/4Wda3YnUj3k7UwYETgjEY/aZm5MeiR2j8C8Ezx1rQgQtfq10jnmVL72TJ1SD2R7YJSJ6btInjqbdZXndYHFJ/K3NBztKk05HRwOsAmlWyGw5lDK4SpGY9bjTe+QBYMvnc18J8Mu0QQTnvjaM788u8RffAAezDN3SN6DuekmAp6YGRFvC6dNi7KZT/u4qxVTD7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JS8oOgns0RpldlkoAuexcNfWp7baY2eah7vEr5Y/FZs=;
 b=OCqhxdCIc6w2jmv3x9egU9si4PfeRxGA1WjlrdH10MlcABtTtmzkkbRBz0XiPkKz2v7iNHgRYxFbiX3TdcoOROoXuBDq5v/nAaCpckxJ8wfa8zbtYahfrf/kR5RlRPTDtfpyEev25+G3R3a9UMqclb8RprJSO7t6eT3plq1MFnODcMAf99Sl2V/6WycPWy4NSyWxEBKPWFWWPR+Y3i0xsLNuPVAZEeAS5Q50NYNoRjoDxyLXOmuZh3vEuCK7Oip3AovH2ZqH6ygrIu6CFQIvNxVQRgjH0LtUqK+OnQILV4e2YLZSRLTCdO5sLt3EcFSk3wwq9bLxvasFq3qHzDSHZg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by CH0PR12MB8487.namprd12.prod.outlook.com (2603:10b6:610:18c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.32; Wed, 27 Mar
 2024 18:08:27 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 18:08:27 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <jroedel@suse.de>,
	Kevin Tian <kevin.tian@intel.com>,
	kernel test robot <lkp@intel.com>,
	Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>,
	Tony Zhu <tony.zhu@intel.com>,
	Yi Liu <yi.l.liu@intel.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH v6 29/29] iommu/arm-smmu-v3: Allow setting a S1 domain to a PASID
Date: Wed, 27 Mar 2024 15:08:15 -0300
Message-ID: <29-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR05CA0064.namprd05.prod.outlook.com
 (2603:10b6:208:236::33) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|CH0PR12MB8487:EE_
X-MS-Office365-Filtering-Correlation-Id: 13c07355-e622-4bb9-bc27-08dc4e88e17d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ANcPo2CZJHEEFlwK+AL3s2Uv59HhScPGKmsg7RHo1pTLAjlpO9/7k+QDrEdXneUh831s27m8S0myLwoDADchuOkaGerCEIVmTEmm6DDr36rl6OacADbuPwIOG5t5hg5PVe00S5D5EfTTeLfoaC1yIo3aCA2gqDIW+UJhlDTWgGi4GPblF1IItIYWq8fHQJptCzxP4gmHfQPu+7E7QICogsMUyzHwB4zT1NgTQk4SWY1QZC+g+rXYfo8Q1WeYLGVn0H+tOsAqTAYLTJVpE+6OxrZ8xk+pKTGaci+e3cSQwe+/wwSJvhyZciwoNEK2SBZlMkF9DqA9cUyg+PVKKxPcqILvnEK3cNIAxOSdZPFTSvyqSrA2292jn/vkFwek6UviQSFkjdW0jlhFScDNWUgJ3ikcMvSKlXXlROuA7kid3sQD3hyS0PfNLC+fDpnSMt0vV3O5SK0e8eO/9vt6ReFWranMci+aAyr3EZ9ANrCRgSHSwWEtJrl34Xdhp1RSpnvWXUJmse8NEqYdAc15HHonaiXQ+2XK2eBzZGPLAPAzeXNXwMmBSEu0lSzP6qNcfPrzvuyFWFEVPJwAqeo+OpgJfi4VrMU6nRFv2Iqbjt40bUgQo/rnUf39CRiyfsxar/WwU7rv0IbL2VnS3LsOmoFnqoF1EiAAKNknGSo0PnPygJw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?EdNlyjGXK54A+fwGh0QxnbZ8RYOwL3vRcqahYS93JTDmQcikq3ZimJfUG2TY?=
 =?us-ascii?Q?0A2AZ89WeCog3BN6eyfyiw6uk3FXBtx3pZPJCup9tphrO0VLna2cjhjVjCvl?=
 =?us-ascii?Q?TKSuKfryG12bKBxkDM7aKwLsOhliFWCMHVXNhtiQfAnzh3RaNcCg96mSWKBt?=
 =?us-ascii?Q?uK0yh+Qbw1piJK+cYOhtQ1XeqE3LuqkQJzxWB+cpeEEHqxcZ/4RnUOf1coNo?=
 =?us-ascii?Q?WAxL6jwphJbE3i93Hg6ADzVZF1sDt+GVpmoF77sq7dkeWxgAwc9f0UsHB8gr?=
 =?us-ascii?Q?SG7OMukmWsdySqOjbwrpxDTu7OpmT9w1or6TObXdy2OMb+1mH8q/utbzS/BN?=
 =?us-ascii?Q?SylnCklqr3t3DJazacH3upZTHGYJhS6/66DSX7CqmDZRYoPI5yDGthD7hgA6?=
 =?us-ascii?Q?jKqkZ2gWyM3QWSm8QwlU0WrxrfxOHLMk73V23wwn2v6FybjNZht+YqGNLglV?=
 =?us-ascii?Q?1j8Z1JygizjRjKfecQo8Hm8wQn6YsRe9eRksrr6p6zCGNk2S0E97L63jNWIN?=
 =?us-ascii?Q?KRMoPI4Q1ZF9s65lwytm40TCjqr5+FX9tIvh8dK3s4OQEa4EyzNegae2DGlC?=
 =?us-ascii?Q?xdFNjy4umz+SyOqfCzRFv0+1ZRw2F2DH4C5WMy6UQD/8tUiKE1px7rjCNuxK?=
 =?us-ascii?Q?IGDBEygL8WAH15F9bL5o+eo8pSEI1X+kqZHddV2Xctcc54f6ATWGAPkgSxNJ?=
 =?us-ascii?Q?CSvpg29uOZsGkfwMv/fsqxdpPeCO0TPrCYDS407C3TUbsIFLE8ZBMGnPe2oD?=
 =?us-ascii?Q?e90Xpm3aoIWFF6/596Aw5Rp4laBUoA1A/5/MKQbNxHzFIXRLFASqlR3xl8Vr?=
 =?us-ascii?Q?Jupg9faOeOlW3W7u+dZAP3vKlUZdsuzIno8bzE2b3jfGWP1xoTn+ENe/uuSf?=
 =?us-ascii?Q?uTcn8F3QH/bj07uJpKhrE0SzIsID/IaIrebZRrbGTcFOQuqQ3WanaYzulLY1?=
 =?us-ascii?Q?fxmrTr4iPfxtws3pZTZr7i6NgW/rNZEVOjj555eEMPwjXxqiLSwZYi7MgIvJ?=
 =?us-ascii?Q?Qquk9BGiHWq3xwH9PGQ9zC3LmXl51v22nD7i1Ne+G5RLeYPE3XDPxl3soe76?=
 =?us-ascii?Q?p4xhnRYNqJ3us5F3y8oGoMR0PiAxiAsUz885aekzSbvx7ffer7DafF1DSSeW?=
 =?us-ascii?Q?V9x7L5WGe/0oRmvSTa/+eVEvHuy+1T2LiVaSl2t1lg0t2CmeaOT7glEvVNgF?=
 =?us-ascii?Q?yW9nfUZa3I052zlbsQxkExtpEi0xXc3D95r+fHV8G5tx55HSwPdUE25nlGPF?=
 =?us-ascii?Q?tepy2R793ddM4EOW2dscfDnzaHFWMgDEa6bvhucwqvqIaBdZy0QzbyC3wD8R?=
 =?us-ascii?Q?Ze0uzcb5qrCaQjudXOYY9DPaQKKEnVWsjjk8DBSTyv1pvn8MYH5wHv09W4sQ?=
 =?us-ascii?Q?KclLg1CF1GQ69ilGe77A2+z+dyIi/zssK0C92NUQXBXw1b0zQhM1oHAaJwt7?=
 =?us-ascii?Q?36bVsRGGWlIpEUec99AklxdFlZqMbBpBOVArYwAzNbkNoNTHiYqwke/2I81u?=
 =?us-ascii?Q?f4FR//DqCpSTPjDh+VFyZPCdg2bNc61tLAddxvBkbRJ+MsE0vbQJVB5i3NXZ?=
 =?us-ascii?Q?jHzXXjCBXDmNx1cQG0bVNoyqJSst52qV2hL67yIx?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13c07355-e622-4bb9-bc27-08dc4e88e17d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 18:08:18.6290
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JCKSDw/n0H2GwDoB4i44KvnOixq+TH7YDVrL05cheOmbK5jdBLAtUHvvsvcPpCKk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8487

The SVA cleanup made the SSID logic entirely general so all we need to do
is call it with the correct cd table entry for a S1 domain.

This is slightly tricky because of the ASID and how the locking works, the
simple fix is to just update the ASID once we get the right locks.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 45 +++++++++++++++++++--
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  2 +-
 2 files changed, 42 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index f87525225c8a50..59f24602e24d68 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1332,8 +1332,6 @@ void arm_smmu_make_s1_cd(struct arm_smmu_cd *target,
 	typeof(&pgtbl_cfg->arm_lpae_s1_cfg.tcr) tcr =
 		&pgtbl_cfg->arm_lpae_s1_cfg.tcr;
 
-	lockdep_assert_held(&master->smmu->asid_lock);
-
 	memset(target, 0, sizeof(*target));
 
 	target->data[0] = cpu_to_le64(
@@ -2765,6 +2763,36 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	return 0;
 }
 
+static int arm_smmu_s1_set_dev_pasid(struct iommu_domain *domain,
+				      struct device *dev, ioasid_t id)
+{
+	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
+	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
+	struct arm_smmu_device *smmu = master->smmu;
+	struct arm_smmu_cd target_cd;
+	int ret = 0;
+
+	mutex_lock(&smmu_domain->init_mutex);
+	if (!smmu_domain->smmu)
+		ret = arm_smmu_domain_finalise(smmu_domain, smmu);
+	else if (smmu_domain->smmu != smmu)
+		ret = -EINVAL;
+	mutex_unlock(&smmu_domain->init_mutex);
+	if (ret)
+		return ret;
+
+	if (smmu_domain->stage != ARM_SMMU_DOMAIN_S1)
+		return -EINVAL;
+
+	/*
+	 * We can read cd.asid outside the lock because arm_smmu_set_pasid()
+	 * will fix it
+	 */
+	arm_smmu_make_s1_cd(&target_cd, master, smmu_domain);
+	return arm_smmu_set_pasid(master, to_smmu_domain(domain), id,
+				  &target_cd);
+}
+
 static void arm_smmu_update_ste(struct arm_smmu_master *master,
 				struct iommu_domain *sid_domain,
 				bool want_ats)
@@ -2792,7 +2820,7 @@ static void arm_smmu_update_ste(struct arm_smmu_master *master,
 
 int arm_smmu_set_pasid(struct arm_smmu_master *master,
 		       struct arm_smmu_domain *smmu_domain, ioasid_t pasid,
-		       const struct arm_smmu_cd *cd)
+		       struct arm_smmu_cd *cd)
 {
 	struct iommu_domain *sid_domain = iommu_get_domain_for_dev(master->dev);
 	struct attach_state state = {
@@ -2824,6 +2852,14 @@ int arm_smmu_set_pasid(struct arm_smmu_master *master,
 	if (ret)
 		goto out_unlock;
 
+	/*
+	 * We don't want to obtain to the asid_lock too early, so fix up the
+	 * caller set ASID under the lock in case it changed.
+	 */
+	cd->data[0] &= ~cpu_to_le64(CTXDESC_CD_0_ASID);
+	cd->data[0] |= cpu_to_le64(
+		FIELD_PREP(CTXDESC_CD_0_ASID, smmu_domain->cd.asid));
+
 	arm_smmu_write_cd_entry(master, pasid, cdptr, cd);
 	arm_smmu_update_ste(master, sid_domain, state.want_ats);
 
@@ -2840,7 +2876,7 @@ static void arm_smmu_remove_dev_pasid(struct device *dev, ioasid_t pasid)
 	struct arm_smmu_domain *smmu_domain;
 	struct iommu_domain *domain;
 
-	domain = iommu_get_domain_for_dev_pasid(dev, pasid, IOMMU_DOMAIN_SVA);
+	domain = iommu_get_domain_for_dev_pasid(dev, pasid, 0);
 	if (WARN_ON(IS_ERR(domain)) || !domain)
 		return;
 
@@ -3362,6 +3398,7 @@ static struct iommu_ops arm_smmu_ops = {
 	.owner			= THIS_MODULE,
 	.default_domain_ops = &(const struct iommu_domain_ops) {
 		.attach_dev		= arm_smmu_attach_dev,
+		.set_dev_pasid		= arm_smmu_s1_set_dev_pasid,
 		.map_pages		= arm_smmu_map_pages,
 		.unmap_pages		= arm_smmu_unmap_pages,
 		.flush_iotlb_all	= arm_smmu_flush_iotlb_all,
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 853cd17d06e671..890fc6628d5e0b 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -768,7 +768,7 @@ void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
 
 int arm_smmu_set_pasid(struct arm_smmu_master *master,
 		       struct arm_smmu_domain *smmu_domain, ioasid_t pasid,
-		       const struct arm_smmu_cd *cd);
+		       struct arm_smmu_cd *cd);
 void arm_smmu_remove_pasid(struct arm_smmu_master *master,
 			   struct arm_smmu_domain *smmu_domain, ioasid_t pasid);
 
-- 
2.43.2

