Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2050.outbound.protection.outlook.com [40.107.102.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADC76156654;
	Tue, 25 Jun 2024 12:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719319087; cv=fail; b=oN/oxhQo8+iPtiqvr15MUaR4kXF2lW38MQxSlp7E1+V3rFOZ3qQcK2hkJa2nfA3ezicPOgzNDSSizGLR998gdu2Jr1o15hEZwFCbB1I7/rvlWjBmPGGGu+vuFA1kMcmChOlRtF9skYZljvol7NgNl1gJXY9mqsAFYpJ039iZy2Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719319087; c=relaxed/simple;
	bh=Xhp3HPCBrS8NiVyVMNcHMmr+chLc/d/JGnLdV+qGrp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JeF+gL8mwPCqWYvXkLG9JDjpffBkv+9rl4kw7Cma3ZFFJyL2+ECVY/t9POHKN3VwIhGahHbZDtB9eVggQ8aRjxT6r30JywtaJ3LK3KWUt7ZRJT1SYskOGx0hnBtIPHHFbwHJNoC7NDrL2HYSSpS/uxP4WRdNAQSJpi7VuWl+vOY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=e2Y9HPN3; arc=fail smtp.client-ip=40.107.102.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="e2Y9HPN3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eRc/JRkbSbffUuu36IFGwxtlU6MjPfhrO7JRodBLA1RXSKBJp6xCtYTgss6k4vISey5J317N1sr83TcFKjnR2f+NRFmHysn5N7/dU7r/trzYA7AHH/w1mjr2GP9LuVy8GxEgYhZafEcrgVyBSe73ET+80CEzCrcpaY3y08Rp2DLXdrjZFXnLjdDmX6X84+dJ6b4gpBYk2YGhzHiVG4bHE/+YnVsNhR8AdbzKPht9U6Nm8Nu/REWZVQzgDpbkkjyZvr4ODnCnhfJgpuARkEU+BBv2ovLwjNHKc8sMJGxqB0Gr9sSIdqFqADnSX8bNmugUX3WJuw+e+ULfvhTS0lxSug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E95aCzlBZGQUhqk24tjR7TaUpY2oFlOq0aA6h/qYFV8=;
 b=UIDdbBDUDLsXlMfXEUVTaobLt79lHNn6EjjRM8igObkqr/nEaaLKjdfQpfI3Q1jNv6sygtFSt9Qz4vhtoIw6iDE81ymqzzhR+kNL0JV7rTtfA/B+ta+EIHLpWujv5f8cB3E0rHVYj7kfCQplsJsKAMqUCITIG2aO3ee0dlFvtCQrywaixu8ujIU7kWdNDE5QgnQ8CryHB4dfJz9tpOwHjC4lVz2G+DOEXbjS2pK+5902avhfTgQi1VDTQCkHaHoWnMykLUn105yz6NUO45IGScv/UczxjiZ+//W55O3JCk2WZccuDRK2QHEA6IHLOtjNmLu3ZjZl0LxNepOfdw7+lQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E95aCzlBZGQUhqk24tjR7TaUpY2oFlOq0aA6h/qYFV8=;
 b=e2Y9HPN3/3HSZasTmWOzzZhUrFub7RzdXwhb8WwGo4LylH9UlvrjPBdrERUjN9khXfQaBZX7/j1PAmU+o5KUFC9DXtC/YJpMJDlJb27oPwRdvM5b6DI3hEn8RkctWEZ5JzxAOAWcB4qLO2XmUSxt/hk7BPjvfxWXdk4I/uweQWkdm+S0oxOrXrbNxRbETgCDI+56XhifFTIsIwFnyPaRx+92wodFFHHmfuUHmul1btw6e0atUylgh1GGuYh9U80mWvMfJk8986CmtSzqpSTnxEe1w9jBW5aBsbwBZCQBanmlHynH7DmQPtG6U9bOXzYHvh657hBn9KGYg6IZXSF9gw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by SA1PR12MB8946.namprd12.prod.outlook.com (2603:10b6:806:375::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.26; Tue, 25 Jun
 2024 12:37:51 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%6]) with mapi id 15.20.7698.025; Tue, 25 Jun 2024
 12:37:51 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Jerry Snitselaar <jsnitsel@redhat.com>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH v9 14/14] iommu/arm-smmu-v3: Allow setting a S1 domain to a PASID
Date: Tue, 25 Jun 2024 09:37:45 -0300
Message-ID: <14-v9-5cd718286059+79186-smmuv3_newapi_p2b_jgg@nvidia.com>
In-Reply-To: <0-v9-5cd718286059+79186-smmuv3_newapi_p2b_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR05CA0027.namprd05.prod.outlook.com
 (2603:10b6:208:335::7) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|SA1PR12MB8946:EE_
X-MS-Office365-Filtering-Correlation-Id: 71ce7bd7-31bb-4e34-520d-08dc95139f0e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|7416011|366013|1800799021|376011;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pKHGIOOMJicn41bpaTJqaeJs5SoSFAUDsb/lsdpLuoZqdWTMD9wDl13WPv9o?=
 =?us-ascii?Q?p2LEC2Kd8UEhlMVzW/sMQ34NaLYmHYQwIjmabZxPUMwC5mGjMP2NjdDiqn+f?=
 =?us-ascii?Q?HdqAK4vy7t2euWxnIWnIauSuJYP8ses2/wXEZrbH24Tdb5T5V9lcDiGZpcMg?=
 =?us-ascii?Q?GU7rn6L94AeIuTPupe/D6HU5eB97fRmIPXqRVR0TMzipCAmygeYEMQknniiX?=
 =?us-ascii?Q?BlCgLx+JLmIdVdOIHUUkiX/kI3WqM8uqspjrWhAnm2zJKIb9zakee6lc3K5L?=
 =?us-ascii?Q?VK2cRs/usR7Kvm38QmA0zoO6fPQgTFheTJB2cELkyUJlxqBolENFsh7PRo3g?=
 =?us-ascii?Q?DDwEIuyQ1tnKqGoibWHqWLLmKjIlM9hfvFNfTUt4oD5QpO45gPEd/EBkUUWS?=
 =?us-ascii?Q?0S6gTNHpze35S+V+TkNR+RVrYPZJTYRI6ZbR8W0a3KJLDElR1OqxFRmxJtul?=
 =?us-ascii?Q?vaP0Db592rSFjXzdVzx78nFIAzglje9bxYiwFhmAWbnmZfvyVotKFXYZRiAL?=
 =?us-ascii?Q?ttdICvZN2tVDx4d9JhtBwl108OkWtgj9YPMffqaoqcqn4Mimk7sCV0WmVHVA?=
 =?us-ascii?Q?V6+8YVolf2HF2SMH746JXuKyy9BBfUH2sc+wrH6aEU80ze9x2T1SRe6VO74H?=
 =?us-ascii?Q?mwL60k2Sitz/baJMMiYXARZIPz/u0XxgCiZcx5/Hbocb/zTcnSWKR4gyKF+K?=
 =?us-ascii?Q?7CjWRB86EWyxCC6mZ2wJZOuIEtJs8Q0haWn7KfdnZa1eGksKEy3f9KSzM/hQ?=
 =?us-ascii?Q?dxvAl2JclwEpdapqSrBntSgbIDThMIggLpoGbYBxBKYj6ZNxkdFRaW4T6gUd?=
 =?us-ascii?Q?lhosfTUMwZr647/KvM310zzitJvq6k6OofVy8bh9lsAJKbCnQf4sKMU5IIyh?=
 =?us-ascii?Q?30MAgMlD+JE330OtubTud7ibmiArq0qrawsfx7pCp2vapAhM6M/guk9W68Vv?=
 =?us-ascii?Q?nEvsaZ/2u1S9JQFm1bDgWa0McfyhJoX7HWWpEVQ5ZXuJN3I55Iy8/cBdbsGY?=
 =?us-ascii?Q?9H9We7vIsE9l6ILxbVNsB9iLD5VDT2QbgmEv1VmLDrWNKcuyDIz0dCRCfoya?=
 =?us-ascii?Q?ISvioYpgZOyXJx0BFW4TgNO/sVDHBtw2tLLZdHsGXu2yYTphWab7V5sKXv49?=
 =?us-ascii?Q?yTXyhEYZeqWq25askjR8qY3Bnz/g2yHkYxaFYtMQ4VxxU9l6mO9kBNNgKLWT?=
 =?us-ascii?Q?cvNXckC8KAPnqMWIoPyg43zywvv17SxbpGNZB41LOIN3J2vnm3WcDVMXWzw6?=
 =?us-ascii?Q?ioaKI7dFxaP7dkGNPhaVk/G8+tQBDZMsyN43a6D0Ez+j7jGYEIQUbvzTUuwI?=
 =?us-ascii?Q?l2k=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(7416011)(366013)(1800799021)(376011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OlAs4fW8IkQ7oxFu3IBPYtgObCgDIRzirnpkTc8PkMvHBhfI5K5R+/voXfMt?=
 =?us-ascii?Q?VrddFix+zup0jeoFlCSrFKLXcq18gzHKDNACEzCzu2tpWyn/XIsCs9qS2uCR?=
 =?us-ascii?Q?F446KrOKJUyUy+qrrHhfNERQQmkVeTG6pv7N9snI9nULoDauDxG9yCD6y0Gr?=
 =?us-ascii?Q?kaSoyk58dYoNC90o6uyp+Za7YUZpn7O+UDFjQ/earl4bw5jAB28KLDEbeA1T?=
 =?us-ascii?Q?LrV0as2GuYlCwee44wtUirslxVaV8TiIftAt2/UfoOMRRgkXiQKeJ1zy83bO?=
 =?us-ascii?Q?GzI3mMnp9rrUU4KzFyxxQ6BksWYKxnXEXpqQfiaOAhz4/RzhE77rOpkt4pBV?=
 =?us-ascii?Q?ZkVsjn3i/2XpRfxvu0qDFWlNfBcgpIqsojkVsy9rsrEs34BStiFCfFe9h3x5?=
 =?us-ascii?Q?IttVc9NcpYq2TIaPYlefXYuJGhXDizduQjaG//KvtXeGVk7LZzV/8QRrfchs?=
 =?us-ascii?Q?5C5WnLu30s16PdYyZsum4G4xvCSdJdI487HsmFc1A7Ff+/ptlLrImRTKzUNb?=
 =?us-ascii?Q?QpAXTjyvvhImheQkgNmWPz/D+EXNFdVs/xNJ3ht0RYYfnYLN2j/lq/lWz2hL?=
 =?us-ascii?Q?dhJSK5CSrspqsGyl1vYP46y636sFMZ3+0g1M2Y2cqY7+DJmNOBlBr3I6vA/a?=
 =?us-ascii?Q?QXpc0Vj9ITmVKvI9LMbxVIrUGa1JlbhQqgkYL3MwXZatKJxPuVfPD465MFYx?=
 =?us-ascii?Q?liO46Esi/DZab5sjlCg2gQhSQerVK43FsfBgG4QG2wTF/x+2KKjl1m9+6xJW?=
 =?us-ascii?Q?qrOx4mW1aXVUIXEvgQONEtb1lThuMhJZU+9sfcDfE3R1727V14vSWYVcxWnP?=
 =?us-ascii?Q?tbM5sHu/A+oq/TJsCyQWSFCWMaXzkxl+KwKP5Mt5ko0AcXHSeOC+2zbQpObz?=
 =?us-ascii?Q?mc+W+tIKDck85t0+ycfAK/wq7Zs44ojgehMBdyfiU1z/Dgn5qCwG5ieoAT7G?=
 =?us-ascii?Q?wSSw5A9Mn9vX/CxybRXxixPoFMlZTNT2aPAWa3zLVeI2wLRcXd3x879wQQre?=
 =?us-ascii?Q?sZbOOIaDUgoClnZirAyjg+r1Ag2v04XvQvxC/oV/N/FjbRF4WYqPMr56UhfE?=
 =?us-ascii?Q?0uQKFtcF7X+BQ438Nv3CmGY4Rse1gOGaTo5abQoeAlgCNiSEG3CvIAZwCBz5?=
 =?us-ascii?Q?JzXm/eoBLSAA4g3RNgfwJhNJIojW3TZhHI9JFzAftV1cJ6TC45UishG/Zbef?=
 =?us-ascii?Q?+kzv5/dfXNrzxOYPfqAug5OTgzb8BUF9b3a/4yc8+Jd2mqRWK667MnH9WNle?=
 =?us-ascii?Q?r9rdDQcU6b8ge6b6DLpJzeSIctuzMYcaOMIlu1e3vm4t8NoeGZVLq374+zrI?=
 =?us-ascii?Q?m2xVTkO/qggOwxqjcEKFFE1KZ5n3WKA+RT7xFPTElWx6hpY599T5eayRakDu?=
 =?us-ascii?Q?0qUJvTW95qupw7mkfcito+wztUerjzyHKewbQ51UA+7tRYCjgf+yEp0sKMMo?=
 =?us-ascii?Q?XglUGt3JBvGI3EYNP3kL/cWPL7XxoUYYYnGuGkakdL0aVRpjKpx3VVk1GnlT?=
 =?us-ascii?Q?nVa+mdQjaPzUPrJYR7UuiEO0p4DMIjP7PdfPfIrsu9x8LYAvVvXAdq1D1uDI?=
 =?us-ascii?Q?GRuZPuURfk3T9DyiwZOoESho3teeWmoEEH4AI8d3?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71ce7bd7-31bb-4e34-520d-08dc95139f0e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2024 12:37:48.6318
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vzFx5WzXhyqWsCHz/iRRSuVA7absWbOVR/J400Q/C7uNs5S0ZqnjIFGh6jKPrHim
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8946

The SVA cleanup made the SSID logic entirely general so all we need to do
is call it with the correct cd table entry for a S1 domain.

This is slightly tricky because of the ASID and how the locking works, the
simple fix is to just update the ASID once we get the right locks.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 41 ++++++++++++++++++++-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  2 +-
 2 files changed, 41 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index fbe14466f5f379..1e8c996a4be0d2 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2798,6 +2798,36 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
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
 				bool ats_enabled)
@@ -2825,7 +2855,7 @@ static void arm_smmu_update_ste(struct arm_smmu_master *master,
 
 int arm_smmu_set_pasid(struct arm_smmu_master *master,
 		       struct arm_smmu_domain *smmu_domain, ioasid_t pasid,
-		       const struct arm_smmu_cd *cd)
+		       struct arm_smmu_cd *cd)
 {
 	struct iommu_domain *sid_domain = iommu_get_domain_for_dev(master->dev);
 	struct arm_smmu_attach_state state = {
@@ -2858,6 +2888,14 @@ int arm_smmu_set_pasid(struct arm_smmu_master *master,
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
 	arm_smmu_update_ste(master, sid_domain, state.ats_enabled);
 
@@ -3376,6 +3414,7 @@ static struct iommu_ops arm_smmu_ops = {
 	.owner			= THIS_MODULE,
 	.default_domain_ops = &(const struct iommu_domain_ops) {
 		.attach_dev		= arm_smmu_attach_dev,
+		.set_dev_pasid		= arm_smmu_s1_set_dev_pasid,
 		.map_pages		= arm_smmu_map_pages,
 		.unmap_pages		= arm_smmu_unmap_pages,
 		.flush_iotlb_all	= arm_smmu_flush_iotlb_all,
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index cdd426efb384d2..91ec2d49ecbf2e 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -801,7 +801,7 @@ void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
 
 int arm_smmu_set_pasid(struct arm_smmu_master *master,
 		       struct arm_smmu_domain *smmu_domain, ioasid_t pasid,
-		       const struct arm_smmu_cd *cd);
+		       struct arm_smmu_cd *cd);
 
 void arm_smmu_tlb_inv_asid(struct arm_smmu_device *smmu, u16 asid);
 void arm_smmu_tlb_inv_range_asid(unsigned long iova, size_t size, int asid,
-- 
2.45.2

