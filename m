Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2087.outbound.protection.outlook.com [40.107.93.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4845212F5BF;
	Wed, 27 Mar 2024 18:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711562916; cv=fail; b=dCWQ1yekMCs75sW58Xc7QQnMSMJPQvVtKSqJsv82nITHLarVjVaebgFlny01ePwfMr5mS2QOWh4TcrMka1uX3uNijtmRn+MRZXvyziqkmu5CxLhHajFL0VqxS0mLrLDWq20HXs6YRKBW+MHMkgnAfcJaEf471/xImvq608dRClw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711562916; c=relaxed/simple;
	bh=O/p+jQ3zIJg4dnOefZGjSzw8pJyyuoZ+hufXJ0gu2jY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sym0n7rQZeQQHnC7SU4oplm9utZpxfyzDCy/ZQ/r9SCezQpF/3rYTwe7QC7ZwinimSeeKEuqCGZUMrz7FvGKADQP4y1cO90ckbY24y3lHM+6jQRElUs3hLtuZVXMDhZECCd98Z8jOzPm3U9CU6rUXsRH8j50igFsCb26LUq8teY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=uAZDSdhI; arc=fail smtp.client-ip=40.107.93.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="uAZDSdhI"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KXqgy4xZRokcglVsH0+AG31p9TjxhyNCrG/EFjqN4++1KArn0nTRdn2K/Byf38TzLsMBusvh/9ttOSYOtkV17xTuFyYdqUwBpECn4azuvjr40Vch185TmytsLbPkD+bDDmWjifXwLPEecxTD1Gb74Yvu6jaOumAyaRMosYPYZhAUfd7p4gBeZRb4QhieWEhZOMdiScDi1rnoNSIWmQ6u+n5sAHjQmdg8Ka0iM+l5X2bmWjYtQIV/DuDqKBtw0SENkW9iaDSJHkb9kWCFxRJOpOi3vLl1Z6Wy1zkSRBd4J98uhyjlb2zHeIZRHM6GzfpSQvjd3jWm02hVLWH1ul27fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v/hAtwLjsJOu8g9LAALDkiAlP1Ro+9RmW8hrd4iBZPk=;
 b=H1s8C7QT5uuYncS253aTk91rrsh8akpzaiPI9+41tC/cbikzOmMI19vvOkAD5bPrBpbg6iKlzmDIeQ7HqQBpPCvakOrQsRQPmH6+SvFudaf3fWb8Kv0WTPsniN7q4MCsY+YEIlJGg/eoH9xvhpCuI2HKTrPw9TULnEY7k4xXmpriykxjZ7Lj74xGTKCW3VhzF4ux/k/G8lnnRlLa41smNvs2ykOjroXQQC84dRps8o5HR0LGJlW18VqgCqSG2Rb/x8MyG+blqAKXUjVZZLdKb6g8uHLdCDl0NtLnrjWdc6uQmtNlpcNMFHZ8H3jqY2KZlawfxoHdS6Y72hVmYwpZnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v/hAtwLjsJOu8g9LAALDkiAlP1Ro+9RmW8hrd4iBZPk=;
 b=uAZDSdhIAmtjrODjbWRrHZGn1TizSyNJ5gJnlO3lahh6R8oAQene3lGpxSFGOUuq3jDAuk+RdVU9hFL9IUGq9oLEs2yQRyITHf9+wVX28eJDyJZOHuFMB4rHFOjEfuKWIWOJL1VYiTaL6vbzcV0HbfXkA4sHyIt+Nen72YKwUC/PQ05/Rl6OD6lcv3FQMRgKxEZ30Z1rBxf+dnsx5olCzYALBuBbMU7IWPjOui9rXIDVEk4d0qNJx6jIfi6NgtzONFu4+W5obHms53NVRTBxWzEDQtD1rJVpw7x3x5Zt5EIlyaaIC/fM0dtuRXGpt+DP1VrJL4Bd02YpqDXCBAqthA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by IA1PR12MB6044.namprd12.prod.outlook.com (2603:10b6:208:3d4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Wed, 27 Mar
 2024 18:08:31 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 18:08:30 +0000
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
Subject: [PATCH v6 18/29] iommu/arm-smmu-v3: Do not use master->sva_enable to restrict attaches
Date: Wed, 27 Mar 2024 15:08:04 -0300
Message-ID: <18-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR05CA0042.namprd05.prod.outlook.com
 (2603:10b6:208:236::11) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|IA1PR12MB6044:EE_
X-MS-Office365-Filtering-Correlation-Id: 482c9163-76fd-4654-84a5-08dc4e88e1d8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	9OGrJGlZgzQjXQcHA3ArmRm6f/lCsbadmX4rNk+Dje4pKF6vyjdPy3GFpOFdvkx9Pi+3EPje4hNAXC2BcQZHzs11CepdaEI+YwLgphiwJD5bX+OtYyruGeEHo9mOkPvtgEgFROHXOwhTFb0GtU3us2BgZCblLOfoWemDcTnLmSD3ev4mCEO4Lv72chg19Fo7R9ngCyhAoJG5Hw9BjIaKpkHE7xkrvTjOmk7qN8DJhshJRZz0uUbrXMT5kvEPcTsyYH1NnJULmlFF+357Ik/YdPZrJ9W2IepQ/QH3Xbga9bxqYlbgQZK+bnujKnNpnafzIU9cDfPmIZVVCfDy3wjhAOl3JqrJmj1MQtLxTMx3VqJKrUnHJlwvRy+6OYVlCGq57RVistlllsujllAlAZCtpm1GPxyeDGcynuWJEjpuLT8GBGV7Pm1UsQNKCdeyNVZEkomIDuQyjOrdvPoZrkB3fq5Gb1/4tCSvBc02HIL1aUnWwKOUXrbNhltDD7KBw7PE4PsT1TXQL2Yqrc/yZvxZPvnW7tYOvvNGdM307aIKcsbw+OG+FqIszUj3CrNli9tNxfxtIxkKMWbJm9DoQLMcIfIoI6PX+7ZZ7ZJiGZ7oDLcRwW6/3U7spOF4Z1TkCl2uvDjZ0MiThcYE+9vS61fKnE8RpV7/wfX1uu5mz33pzyM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wJkWJ7tf5MfrVM0NhKwCue/BRD/a1yxObblt0XuZrT8F5BXttU/iDuPl3QZ3?=
 =?us-ascii?Q?poUaQsHIAH4k+NS5dJmMRYTnQCZv7naYl7VLDMhiPow/xKM7oWCePR7SA+xW?=
 =?us-ascii?Q?QrDiIksqwBKudiULpe+vGfssJRrrOF3U36/l3KrYthEX08ss8xNBnbXUIwNc?=
 =?us-ascii?Q?YUrdYb6jsq3mLM28Gen0bsVkCTUgX92yBx2CRwAwb20OczOQ2TAJahVg9rR6?=
 =?us-ascii?Q?GqdRlFFN3csulJV9yfrvtcMHG3kya4xJopmiIt4CFlkdqG5IPhmJMNiNzK+l?=
 =?us-ascii?Q?C8w821mxbCV8D75SQk1tVUukP6XtVBmxJ5jZTjbFSHNDSQ+Fa1vzxdl74/oR?=
 =?us-ascii?Q?UWLQfzNSSBMpPQ7/QRRldIQDSKTTguo/B6WM533GwkxIkYOYj3PiVuHmlb+Q?=
 =?us-ascii?Q?KPi0ZNSkCwkP3h50ftb5hsxtd5f/CbRfxtgZCnvbJiwLxsealBnQcc8oJZj+?=
 =?us-ascii?Q?ssFdVEzn7AW5BD/iHq3Q0mWHO07FLHuvkv+O4trGIrafDtRsHkX4F4g9jGeu?=
 =?us-ascii?Q?mIqbZCQ7RhmAqCVcfh+/SeH3E4pfMQ8Cj9f/i4nozOJSUGPw18Wv2WLzbVb1?=
 =?us-ascii?Q?1y1CmM2Uq2/fOmr9kPkrwy56cqavVej584AbJgPPvLf0mP9nD/JFPHQJRkIp?=
 =?us-ascii?Q?AL+I9I3DtT6gLix5uXnagybDEYmFHiVeaHhjkkqcTsHwjv/XT1ebTL0/n47D?=
 =?us-ascii?Q?d1lNlX3vFydCzURrlgMHU8MKqbtkjdF+zbO8/nSXqQRBounQJp2gptGH65D7?=
 =?us-ascii?Q?ROHzbR1YkjEDjPyS2xcONTCA0gpQMXSzmzE4q8r5M1fB23VIkvF84P/C1XF+?=
 =?us-ascii?Q?n5TCFCwxEm4/Wn88En7TMDH/pRCE5vgR3gI5X4o675pUdP2NC04O4nP92VXQ?=
 =?us-ascii?Q?8Q4/j5Vz74iP11KtmtBw0RMo3/gM0TAIO2jRbC5RTV1xFRZ+DFvkP/vsWeu8?=
 =?us-ascii?Q?LNxdjyhvhu+Am+uCvX2tt6MEx6dQFTPu5D6dj9SuKMKmTfRNsJ0ydgSr6Va7?=
 =?us-ascii?Q?JhR2bVLtVvbeeb64XdGXsPkKS8vzaNXxnE/1XIE+0xQpUxgNf1YWnxOG7Way?=
 =?us-ascii?Q?x/n/O7JkdrLcUqr+hZSv4ectmUpKcwIXCdQPMhf8pR6oX4cACK1vGE0F9wH5?=
 =?us-ascii?Q?hUki7cGLXDtn7OH2gH7/xYgo5XLX1+E3/4bKyFG+RQTHk12gBcgL4o+w5xmi?=
 =?us-ascii?Q?UudggNCiWqeiZKY5puRjdQpvEVpd2iECUllO2GlaoGW10lYjXQsYW9AZCCMF?=
 =?us-ascii?Q?NYI6RPQi0pjzJdnvTPLKNxtBKL1YI0jTi6RjA5jbyC9ZVQtwqSzBb315qI23?=
 =?us-ascii?Q?8UkXmYe3xRasvdYUBpuS7Mg3WexlsNp4JK6oupr0TndroN5X75gITEUvvicr?=
 =?us-ascii?Q?U0+8RmEIph+q9hTXx+JLEmN9jixi4w+B1la9M7KcywcjzGSeaBtsJZFgOBM4?=
 =?us-ascii?Q?uRmb/zPNIoeiYt9+aovxyer7tUj0qfFHJtgSSL0kIWAC5Bi9us70SItblSyJ?=
 =?us-ascii?Q?RyAQ7o+NGqjtNNo/52Vm/cb86wypECUBQcyyi9DjCdfVuszlR39QgeWp7B/A?=
 =?us-ascii?Q?VcMq4ENDaRwuicWEDcd2PBjK3nqvpMHWE4lJYz/u?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 482c9163-76fd-4654-84a5-08dc4e88e1d8
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 18:08:19.2218
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HrQfFOFiu9nmpYBQ6AdlBHxg58bm1U9Rc73u5XXT+Lzg0YIcHsG6G+5fSy0Vl+2l
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6044

We no longer need a master->sva_enable to control what attaches are
allowed. Instead we can tell if the attach is legal based on the current
configuration of the master.

Keep track of the number of valid CD entries for SSID's in the cd_table
and if the cd_table has been installed in the STE directly so we know what
the configuration is.

The attach logic is then made into:
 - SVA bind, check if the CD is installed
 - RID attach of S2, block if SSIDs are used
 - RID attach of IDENTITY/BLOCKING, block if SSIDs are used

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |  2 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 24 +++++++++----------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  7 ++++++
 3 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index be54dfb89e880e..24e7cf759bbc35 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -626,7 +626,7 @@ static int arm_smmu_sva_set_dev_pasid(struct iommu_domain *domain,
 	struct arm_smmu_cd target;
 	int ret;
 
-	if (mm_get_enqcmd_pasid(mm) != id)
+	if (mm_get_enqcmd_pasid(mm) != id || !master->cd_table.in_ste)
 		return -EINVAL;
 
 	mutex_lock(&sva_lock);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 00be1e2ebefaa9..a77467f8837515 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1297,6 +1297,8 @@ void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
 			     struct arm_smmu_cd *cdptr,
 			     const struct arm_smmu_cd *target)
 {
+	bool target_valid = target->data[0] & cpu_to_le64(CTXDESC_CD_0_V);
+	bool cur_valid = cdptr->data[0] & cpu_to_le64(CTXDESC_CD_0_V);
 	struct arm_smmu_cd_writer cd_writer = {
 		.writer = {
 			.ops = &arm_smmu_cd_writer_ops,
@@ -1305,6 +1307,13 @@ void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
 		.ssid = ssid,
 	};
 
+	if (ssid != IOMMU_NO_PASID && cur_valid != target_valid) {
+		if (cur_valid)
+			master->cd_table.used_ssids--;
+		else
+			master->cd_table.used_ssids++;
+	}
+
 	arm_smmu_write_entry(&cd_writer.writer, cdptr->data, target->data);
 }
 
@@ -2712,16 +2721,6 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	master = dev_iommu_priv_get(dev);
 	smmu = master->smmu;
 
-	/*
-	 * Checking that SVA is disabled ensures that this device isn't bound to
-	 * any mm, and can be safely detached from its old domain. Bonds cannot
-	 * be removed concurrently since we're holding the group mutex.
-	 */
-	if (arm_smmu_master_sva_enabled(master)) {
-		dev_err(dev, "cannot attach - SVA enabled\n");
-		return -EBUSY;
-	}
-
 	mutex_lock(&smmu_domain->init_mutex);
 
 	if (!smmu_domain->smmu) {
@@ -2737,7 +2736,8 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 		cdptr = arm_smmu_alloc_cd_ptr(master, IOMMU_NO_PASID);
 		if (!cdptr)
 			return -ENOMEM;
-	}
+	} else if (arm_smmu_ssids_in_use(&master->cd_table))
+		return -EBUSY;
 
 	/*
 	 * Prevent arm_smmu_share_asid() from trying to change the ASID
@@ -2809,7 +2809,7 @@ static int arm_smmu_attach_dev_ste(struct iommu_domain *domain,
 		.old_domain = iommu_get_domain_for_dev(dev),
 	};
 
-	if (arm_smmu_master_sva_enabled(master))
+	if (arm_smmu_ssids_in_use(&master->cd_table))
 		return -EBUSY;
 
 	/*
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 5f49a5771ab027..3da131e0173e1f 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -602,12 +602,19 @@ struct arm_smmu_ctx_desc_cfg {
 	dma_addr_t			cdtab_dma;
 	struct arm_smmu_l1_ctx_desc	*l1_desc;
 	unsigned int			num_l1_ents;
+	unsigned int			used_ssids;
 	u8				in_ste;
 	u8				s1fmt;
 	/* log2 of the maximum number of CDs supported by this table */
 	u8				s1cdmax;
 };
 
+/* True if the cd table has SSIDS > 0 in use. */
+static inline bool arm_smmu_ssids_in_use(struct arm_smmu_ctx_desc_cfg *cd_table)
+{
+	return cd_table->used_ssids;
+}
+
 struct arm_smmu_s2_cfg {
 	u16				vmid;
 };
-- 
2.43.2

