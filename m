Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2067.outbound.protection.outlook.com [40.107.93.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4EBA4404;
	Tue,  4 Jun 2024 00:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717460178; cv=fail; b=Q99ZapmTb4Dys5zmp3PrBiV1eciznUVz2X/QrIHpdc1mwYUZp/0jU4r6k3wMJOX3ymquFz1criMojz5eJS0uhy8r2MR+UXIn/QCn8gVxYsG0+yj1iZG55RhNLgm8g91k7tCwAdHmNtWnm8ZV9BIxko9bWdVsC9uGZfdSuCo0jCU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717460178; c=relaxed/simple;
	bh=cV7687cvABSlIkUWKwyEnJ6PeObGjfTvtufqCcfl50U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LdB0ydYt63nQAv51PpqFP3877oxJ3MI5N1Z7gwBQFP6UN1RVze+17P8gHXmqsjgq7IdckhEJUF6NJPGZNAVxgSUuxJ4YUUnb9Z8oK3u5MBaULY/pbeZAuaTdrlDRjOGZkq7X2+9bz+WeUeeUKWUPN1dQrdflOxvTByQQQV2UCAU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=EjAGixP7; arc=fail smtp.client-ip=40.107.93.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="EjAGixP7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EBr+K43Y867LNt5yB4LmlKTRZydW+eKtvO+pc0kb3MtNUznJG+D0/vGR8xs38p40XD+C/AqRTroq75uapZ/P80zIN+DLyC2X4T8+07is+TcV4RPMqWgL1JKvuhh/pYFqQLoBjSER+1nexPgSkxpcgyJmVcUoUTKJDoZP8iCrUXzIhztEUC8RoW6k0CK9ZPNRHK2foMSQwGSphSRb7NesBnQtS71t/shmHXHISPQkIZtRezfZ847kbykOq84+TR+xZ6KEE4fE8ZQhfDw6TD3U5lZAPwlyxdbxdf0Hxp4EMmsvIIw6b+4CfWvsH97k7SluPHK0a0fuDnxX3OGFOxvzag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6zdESbDRq244oFLCJ0opKNkjFSD2iqt5hoN4csFU1Vc=;
 b=Yvc7OihggYuLNk6PoNklX4ZlmbNaSNdLHY0CGW1nIAf7eswBt3hH6KRvRN8JCQsyLFtq37fKEWYcuxJ1Zls3HxMlc4T5OmPZroWa9PqEOiucCmuIeZsMF02gv3AEOFh0EXrJZSVBd0sj6Q/7DfhYphrbjfINVzjYOpolkWfs8gP6mvgRJiosHb8uTCoORHHqrSoIQ2iGe2geB8bg/jPTGKDkn4/I+gaTSEtkVNVES4L6WjWXcOfvXd/UzGRrypgvTgQdkOOrhuUMBDzjfj48VvOPQYheEISUfLO/gXNRMsUKCXDSjx0wVk80FLMM3pbk8diK1hVx6T9N8KmLsS5Lyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6zdESbDRq244oFLCJ0opKNkjFSD2iqt5hoN4csFU1Vc=;
 b=EjAGixP7sMVwlBmjjLTNGW9LstPTccdTXfhfH2t3ZiB2/8zdSFyACE6E52z3y6D3dAA3VYGCWqJEwBXeiMY14FJbNSKOZHgB7b4Ieai48ufb7mjBVzoBn71/wf0u2DdO9ZvXu0FjT7dPyIlKmPCgwukmrStDq/y+Soo2NFGH26nAHgr2+k8nqhiiFomQkytu4M51yCCIus9cdIcvUQHxR0RFhm1b3d8qTIbswANn5+wX7CDhMioPo2RynYnk/2s+gaK/FgnMGbbU7h8ouSRx3vZABrJQJ5mmw7lbBL5ABUePHJ9lHG+shltQy3sEYTZzXCHE9uYu6kiK+17DPSOZDQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by BL3PR12MB6451.namprd12.prod.outlook.com (2603:10b6:208:3ba::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.24; Tue, 4 Jun
 2024 00:16:08 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7633.021; Tue, 4 Jun 2024
 00:16:08 +0000
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
Subject: [PATCH v8 14/14] iommu/arm-smmu-v3: Allow setting a S1 domain to a PASID
Date: Mon,  3 Jun 2024 21:15:59 -0300
Message-ID: <14-v8-6f85cdc10ce7+563e-smmuv3_newapi_p2b_jgg@nvidia.com>
In-Reply-To: <0-v8-6f85cdc10ce7+563e-smmuv3_newapi_p2b_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P222CA0006.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::11) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|BL3PR12MB6451:EE_
X-MS-Office365-Filtering-Correlation-Id: 65cf1043-1b55-4e70-1484-08dc842b85d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|7416005|1800799015|366007|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IyAyiyFH/1/4ayIoEs1Ph8hB7vfdRyq8JhhqPT6xUfGUpAmmlYu1m/iKLxFF?=
 =?us-ascii?Q?3SsnU9YBEYcP44BevTkUmStmnKsccg6Ld4fRryzoxfCw868sorwt25ajLSKV?=
 =?us-ascii?Q?/qBuNwjpXmpDUo3/dg8ErQlKpSKMaOrSZ8mDu+xnRUBg48imD/YbtdyfAVb5?=
 =?us-ascii?Q?n15BylmheJFnGVul+6WPTnkvuOFCjGHsUtStORi857DNxDgJQE5TsMtJRFjL?=
 =?us-ascii?Q?v6kC0XEo+znpNFbw6Lv3yNre6UwDiMWYo4ZxMUMhk6A9l271qye7CzNQWJFe?=
 =?us-ascii?Q?3mSZ2rmHEIRssrHoU/j5WFIzn4H5Kyg4eJ6MrOvoLqP1pfBXab+URX2L9aAF?=
 =?us-ascii?Q?0j9KcQcI1f+ywIBq3tKrI2A05RYAdIWfPCuHskpAFcF7y39XK+P3AbcNDPsK?=
 =?us-ascii?Q?epAUeYpNXTQPW6PejrI3Oen6jGjiaAb1JVWD56zPHEmWomyA1STQcrpoyNFr?=
 =?us-ascii?Q?6/3v7qjBQxVWYGzTKPtO0YxfElmtrf52lH+/suD5csohXls0ibZHVLGaiV9X?=
 =?us-ascii?Q?HWaKCLUnG6c2sAvkIhKRXnfjBY7LWqlq42jWcGkKSURDUkuD7IdXRbTocQjl?=
 =?us-ascii?Q?tYDxFogr6ezpERk8agFuxPio1lk0DzA6cthSfePkufr5E9Z6Eg/g8YF2c9rg?=
 =?us-ascii?Q?rsNOaghfUR7cQ0BUPSrX4a9Q/HJHsRGJZEtT/8SchJ87htGuBFAAZ80AnHP9?=
 =?us-ascii?Q?KZiaS29pwbSqBP8076FGI7EDcKdyTJWqHu1cqztcOockf54yIKAt0dcyEweX?=
 =?us-ascii?Q?2PH7Q+UTCQGnz/BKz9TJ19t1vAAZ5EKFuvP6+yVRcuiVmE5iRaP53kpNNr/n?=
 =?us-ascii?Q?R5LThBFm9bHf9n65kaNZk3wAKk0sLSj8FsnhJksEqmuv1baWxpT6Bd43JNnG?=
 =?us-ascii?Q?RjwHjmooZh72/9Ny4dM9rPRKXjf19/qD7Ud5fe5xjYn+TMPrax4TOpwpd6W0?=
 =?us-ascii?Q?T2lk/b4cnzHeLX+SiZ+bjWbUl0aUWYxgHJC0Br2WnoEcJ/aJaHLSXTN4zEh7?=
 =?us-ascii?Q?P6Tu2gO2etTJGQny4EmSLbfBLKJ0/DwjCRYBaGfFyUqxEvUttxAsL9ugfSch?=
 =?us-ascii?Q?/4qKd61yB+XzsDyBNGNwbASbGZFx32GSbpZRBhqWIQNyRmX0GRoeXF9C3lRu?=
 =?us-ascii?Q?pavdCQfwNBkKPxUbinmuRkH+t1NFjSxzhTVb3issjLdq4RPqbKQodU/Z60gz?=
 =?us-ascii?Q?3oDt6GrlFshI3n42XBNwJmXSRmCL+jwh6PjjOOXEC+a0+MukWZwcdVy3Hz8L?=
 =?us-ascii?Q?R5PDYn8RPOTPWCrFgRUYlifrPhaFV8odoLvpCu11EQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ChpaPRYhgh6/acmbM5btPNMB8fbtAzvuiJj7xcIkXDecbyvTppKJiobD1jQs?=
 =?us-ascii?Q?T8sHJJof782wCipVBXke48ZzKsKg3TPEF5sR971aLcWxr8uwhpLD0kblOP75?=
 =?us-ascii?Q?WQp3DKW7NRbBbU0VdeKMikG1orHsZ6w5RsZLtBFUQKWD7fUclRLeQ14bC4Jb?=
 =?us-ascii?Q?AL0APRARL9Vxay3HuiYvXEh8IZQmSMiReO/gwDmECgaO5NEfu25v7qELx9pU?=
 =?us-ascii?Q?n6jJhNMUfvUNNUJGgTeLRvF0seY/7gjcHoJerTpW4Sg0ioAhfI9kKZo440QI?=
 =?us-ascii?Q?zSzv5AEOT1HC8f15rXpf93qjYl3iUvl+OSlQ8wgvmmUvLpWS2vR7+N8+UmNt?=
 =?us-ascii?Q?AlXfgQ1E1YHSC6Tv0drbRPyELhqpi8eP+SnAKeClR5v6O2QmfTwgxWZQCHFS?=
 =?us-ascii?Q?yvE5xdIklz8kqFrg3eNcHHEOjYc6eXJxbRegQkzXubSVEcZlQvS+hy1Nox6V?=
 =?us-ascii?Q?rEpVvgvcy+Xmvj7LDd0nDHoxDyV9O8qi7fKidMNsvy55Eq84ebRaIUAxBaGz?=
 =?us-ascii?Q?sWWi/G5gbvWz+bEy31fSw0/gqGTCnvdy935LgALbhTiCTPuZMeAWOZw9ClE4?=
 =?us-ascii?Q?f21TCGqtONoSfjZ2ElbiQ1liYCUqu0WGAbju+Yt6e7kGMIMcbFA/vQzqH9q3?=
 =?us-ascii?Q?rwKFaSQSNT97C6DgI60zap9pIMXwBp1lxWGWhuqM6LbD91WF3pmzsyDeuE1Y?=
 =?us-ascii?Q?gbS5ZSQ24vfVo9OpLrCrlDU1IEYv8tklv6YQzCwSRxZyCAjjUuFdf1s5kGSQ?=
 =?us-ascii?Q?cCbfYTKffxiY9e1/NPcIb3PAjyds3BD0rn/xbM3tLJS56DLnK35blqll4c0+?=
 =?us-ascii?Q?s8fRPJ0HURRHLWS1sqKlbtqbY+tVf1m/2nuLaYtwDcFCfUK1HHCEhOomYS73?=
 =?us-ascii?Q?+QNhsHQ+oUy47zGyfP58y3CkAsnJbF9Jv/uH4xXTm75xvYR2xvWjxCmWMYYm?=
 =?us-ascii?Q?oM7S5S5+rF7vt0OxBM1SC09vQp81kDsEBnt904g5b99ryd4WWIg8yn2L2N8k?=
 =?us-ascii?Q?4SHNuoFRPkgXCGJ/8DP44LNfEETwBmxqF3SI3zpzr02/L4bUlM3w2iZQp5QY?=
 =?us-ascii?Q?5qHN5dXlkdnnaaTQ+qHlyU5BVKBzThksr2QR4pCpvCeddNEjt6ZGZKZfZ3of?=
 =?us-ascii?Q?vtpP2LgQUTe/jnC4cIqxbxAmzi4HmdT083wlTWDxu+Ib/aKBBSPznys68q5I?=
 =?us-ascii?Q?VLBTc3Q269K90MIG2nj/HRuvz7RukdD78cAzvkU/wsz8QxRilOwa5JrAqBZA?=
 =?us-ascii?Q?LoevTG6R/QVON9VSH8qgLKeGdyBlvcXM8T2oJqOapvmkkv9APJk1NOD28Vbb?=
 =?us-ascii?Q?EKuCAO25QCMW4agKqdlgODVferMuD0Fmzdh/2Og8XcLeZz3/J1toeTFnMafq?=
 =?us-ascii?Q?084QhibtspakF/qlJ6a9R+QCWZeaaZ4BTYD2bp3lfm3OwVNFDmKRxP3OeEvr?=
 =?us-ascii?Q?MDXlfvCaZCNGyS7p+Mvd3vdufNIsG/z/TFh2cCvEj30xc//ZRnwAbYxX45+8?=
 =?us-ascii?Q?YS8t4ovGnJG2BpNE/9VOhxxK+71Ol+7VZz1RCpPS2vkU8uAyqUmmKTw8pm1B?=
 =?us-ascii?Q?zQD+x35fKYtWWjG2Xl8=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65cf1043-1b55-4e70-1484-08dc842b85d1
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2024 00:16:04.4170
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f5xDde6I7KhbIgQDc3lN9AfD+0XiHY0eVmL7njye7SIe47USgPCxKvxoIBfA6hw8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6451

The SVA cleanup made the SSID logic entirely general so all we need to do
is call it with the correct cd table entry for a S1 domain.

This is slightly tricky because of the ASID and how the locking works, the
simple fix is to just update the ASID once we get the right locks.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 41 ++++++++++++++++++++-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  2 +-
 2 files changed, 41 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index f54be4f32d30d1..85d0b4fd7943c5 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2799,6 +2799,36 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
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
@@ -2826,7 +2856,7 @@ static void arm_smmu_update_ste(struct arm_smmu_master *master,
 
 int arm_smmu_set_pasid(struct arm_smmu_master *master,
 		       struct arm_smmu_domain *smmu_domain, ioasid_t pasid,
-		       const struct arm_smmu_cd *cd)
+		       struct arm_smmu_cd *cd)
 {
 	struct iommu_domain *sid_domain = iommu_get_domain_for_dev(master->dev);
 	struct arm_smmu_attach_state state = {
@@ -2859,6 +2889,14 @@ int arm_smmu_set_pasid(struct arm_smmu_master *master,
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
 
@@ -3377,6 +3415,7 @@ static struct iommu_ops arm_smmu_ops = {
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

