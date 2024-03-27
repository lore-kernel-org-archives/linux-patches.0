Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2055.outbound.protection.outlook.com [40.107.93.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AACF14D29E;
	Wed, 27 Mar 2024 18:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711562911; cv=fail; b=ZecMqiz4AqJ8D4Q3Gm4wNrRVucUpmoTM/ksgeqMRw8YNYBaC/chbLGAmkBmBoSKXtXOfYB+s7JSAh+7mbmx2zsVIGofksyINadSgGM9ShK0eDvYsZapwlkmYQ1omc67/kRJrVxCcCmVOPCoIEsH/VXn6NnK0fGct3XLhf4Xss28=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711562911; c=relaxed/simple;
	bh=4nBFi3Q2elrZnk+DrG5O5CS3F4E++SWH/05rm7XZWSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JoesEhjhn5G1kfHir44NBCoEELn/nDV3giYwJzjmdd1UHBL/Xnc0vTVcpVUDcg5CMA22E/TnQ4Tc+VLHqHrpTmaWfriXbOFcuYUd7rz8InMeMVBdip7krL/0jzscd6XxZVbN6mXViHPZZgHgCYhocjVmW70hFSLQgg763RG4kzo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Wm55HyO0; arc=fail smtp.client-ip=40.107.93.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Wm55HyO0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GBoIqat1yo51Kcf1SS79QTHNBLVQsE7ZPDQsBVYnEe+GiHdsUjN4e6gEeXbU9mkbZQKAtKU7DsKBTv5WvlILiPVfapolPQinQ1VhJFbINm242vuTPWnePU2cXB+DtamK+8ewYBE+4K28MY35ZZc8F2XNe+mUTpH4qqSvhLCivnt4yWjHP9kehFO35s1aoVRsNAmGu5Gxjpm9LXYWs95+X4+I3BzPX40IMgJ0t7sbzlVje3nPSF7RnIEWXKwWAaBRHGzBmXr2usfcYRQN5AMZGJciMafaM+LXlsGUy4VT3or6Z2c3NbIhl/I/OheFQ9tMXn5Gblpy1cjhzHSfeuMfWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FosaEK32/1ZODeT9QLnadln0gjum6Vu9SMmO+5zATo0=;
 b=kCQ55rjrskujkhaXn6gz37D6Envk3cMHEmwfCDok0C2D2Vyqn6jgdLBcjwQSLdFK62GBO7UYbrKkLj+VaFRAXjiaccVahXtd4w1CGLTVEgQgmKCLCKgyiJrRfpLlBv0o4C55jALxZygVHJw0gkfTQjx5NQY6Oi5usLQ2t6zP51tKKxkXqQLj1jWLKXYmy2FaV9bo0OQU9ixNclHgAgzCi2B6WdrRj8KgX9y3QFs5PGQ1Zhz16uPUGrAvj/KT29YQ9IRM9zIg3lzjXV3bIGBFZ8uPJUeNhaGD9VnLxySVcB6akRv8SgmKMtpAcddsCEJC4FgLKwtIISS5Kr4Wi0RnVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FosaEK32/1ZODeT9QLnadln0gjum6Vu9SMmO+5zATo0=;
 b=Wm55HyO01KwImMISxtFGjBG3NLiIfsKOetgtFoQm1QGDwe6NVypwghkUA5/0RbLiBzvSznOYz/imst3Cy3hV9YbUgQzfVSX3wiaj8qHpJTKGcawZzBsF+5ZQTXkgORCKXNlwnayZ3SoadoZH6o7MMV8KAH/p3a77uIV7uhpspZe3av/1LEKnLwZda5QpRmbVGmOJDRWElNsMb3vmTLU155dKxc77cZJfhGS7YY+hBtqXU/tLSaSVyMMLIGErwYFs58F8cIXapVqDX6qH5pw+Cu+sKfcbV2D4UAYs+Sq6oNNU00++54uTqckSrBD4CvskYt8XI1bZWFNHxVwfRb1+0g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by CH0PR12MB8487.namprd12.prod.outlook.com (2603:10b6:610:18c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.32; Wed, 27 Mar
 2024 18:08:20 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 18:08:20 +0000
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
Subject: [PATCH v6 07/29] iommu/arm-smmu-v3: Make CD programming use arm_smmu_write_entry()
Date: Wed, 27 Mar 2024 15:07:53 -0300
Message-ID: <7-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0312.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::17) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|CH0PR12MB8487:EE_
X-MS-Office365-Filtering-Correlation-Id: 25e95adb-424d-41fc-bb0f-08dc4e88e102
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	mQxOS+iOxdFZSh3fsU56FLF+dtHoopM+hSnlmAOBA4Liqa6dISSGOJ7bpKLowS5D5ceMFAdHWRquZU98e41mz5JKIWfwHp+sRJuBKw1ZFVYqYTGB3kLWM/+WQfDBk/sBgws8aTJDZKpIlg5PviWRhdPwCxaqZkiGt7fWoUJn6EkQm4/jAlGh/5++ot13AZJVrw2YLojNL6WCpgVhTfvPr8uYDFqbZGwQRWDhZlovfs7uGe02/fr20jT94ehHM4kCuc/TSySWtqfSFvFQ98y0Z7+ClC3FM2Pc9pVYE+fkQKlahZyOquJ26QcoIvVQJbHSnNT0rktiJ7ff/8HGfBfm5mdPcwzWVuV57mMCPz9p9Ml0THPn+5QI3jkWz6rEVd17AgsnR6HNU2hQkzX61dAzahiWF6kl3C8jX/gcKT098uPDEohJTCYdv1fzWMt9OpFsZz3404TdjWeiABEFBDIJyH9YDU7Iz1cmSGao+DKFw5LaKpYLxmxfao3CFiRxmPhNplk5/uCbQQdMuKkC0y2aBwx/t18nX0d+38rLek9ZRIc1QVqdoZyIFXg2N5XmEDlw+0G3ku9VcTV/v+3Z2CzIRA3Lpv7iGi73KFL5X7WwIeV8pndHgDBxqH9u0MrzrAJd3EdVZNVLeL5FsQKymxU+mK8z2bT7BlKCpDQokaMCFcE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?IFsaRKzH9giRoU9YdEwBX/7/pRrxYL7gqBprHmWSSfFAMb9d6DGFIQ0us9cJ?=
 =?us-ascii?Q?OxJ2IZlXXDOEB501/dm24MNiavcqJZ0kCXmqiTGuHVLinHeKsfMJK2gryNbe?=
 =?us-ascii?Q?ACEIW1SXI6N2lshzFhzKCub/40d32l88aOzTpw9RAloYHOHh1bq+UNXRc/ea?=
 =?us-ascii?Q?jTbEQuS+PjNU9uVACYL0fo+Fbsn0eUr8LjgcvokcYAfalJrefM8KyMxHF0gv?=
 =?us-ascii?Q?I33UoTSCkHWT6jH+eh+pPOZeTFSHYzgvCC/XvNzFb02KozbZ+lBe9dRLOOUe?=
 =?us-ascii?Q?SNDAKPm4W0ADErm8ryJZL+9tMvlBcmsv/lkSt4T/1L6eGv+QNEUE21yESOzF?=
 =?us-ascii?Q?blr3PIWgcBn59jvjssLASDZaVZZvJNWpHLVcdQSkKS2roN8g7X/72wQX+qk4?=
 =?us-ascii?Q?t4CbBD9ngQKCxlYODxmV2iPC96Www5Ppx1EAzkaScXaDUZLN9jQwtEjaE0CG?=
 =?us-ascii?Q?AdGxRMstGCYq2oyX6DnyG9+zQm4EsmAkhY0r3YTL61QaO543X8KPK2OBNQnU?=
 =?us-ascii?Q?6QK9tuMs92SQVZImb6GT0/pL5o4XrPkXTwyv/W6HKFl3luf+9wbewPCmVMdN?=
 =?us-ascii?Q?LpbLRS2Sgv7Jr73gqCNpWRchGDotlwKEu6vrtGCcW5Eee3MXGNz11TFO0dss?=
 =?us-ascii?Q?jyxibTjGHr2c33dPq7LuIabh4whY0IrqOzO6tX7/elTGALEGCOaVbyaKqvW0?=
 =?us-ascii?Q?GFjb+2/+zCbn9iDHv7tCRErWbqakaTOjuIB0ArnR+Hq6u1mAGOVFt+VD6fAL?=
 =?us-ascii?Q?F8pD5W88vSs4fTfhO0ugBOfnUPUi9UIAzyofvn3exQDm6rERHaXdtQqW96gz?=
 =?us-ascii?Q?uoIjGoRF30FXOocuGmGqFKNC0iy2HRwyVngO2ELPjkV9rfkLY9CQQ8mqOHxa?=
 =?us-ascii?Q?rONGBaL/qN6b5ay4ROjR+qinA1JBpQJ2pjxle33YRB8qO9hc3ikDaCWcubc2?=
 =?us-ascii?Q?RM7L/4CnQBTnSybEVbgZoy6nbTPqAwqxp0mOh0M+jtmnuWPCdk/1QKAK461b?=
 =?us-ascii?Q?2eMxVP75wGVu2I0zvBJUCxPdBD0zpm6duaPvYko6rcRS2wpl1MHGo93zZt5T?=
 =?us-ascii?Q?oqm03WTQwrLrxHvMWz6MQQJcHb7m+WKQB8NcGCHRvt9kVjsDvyTosfDw+HsM?=
 =?us-ascii?Q?bDwMR/nh2JGMntHcAS4aV292f4Ki7kUHvAyLcyys9z/O4iFQqsV1wvlaHtxD?=
 =?us-ascii?Q?VzW9JmSCgoIp9mBn/Td1ue2iCPciQ50HVpbnyU9Xj3B+t8DigQvMK4gFjUcV?=
 =?us-ascii?Q?dOiuk6Ak1LGWfhQSZ17U0o1pDGaymHRyF6nJbk23JhBw0v3OJLaxHJEYaGSZ?=
 =?us-ascii?Q?HkYTG1A+rr3X19k9q1PeDwFdrGV96StqcNbPUXAtoZ+J7xDW6uuLOQTi+E5G?=
 =?us-ascii?Q?GWLW/Wx0w7FTUuDI4DXNDcFADWi/EjzsDH7MrLql2v/lYeEclDevQLiOsuEa?=
 =?us-ascii?Q?rH/ULbwnaNkGsmdN3c3mXs79eupWsEWQRr/493lDii6r1h5QryWgXEcETrns?=
 =?us-ascii?Q?vebArhYuO8o25vajgpMz3H2BQIlHqsWgtgoiA9dd1HJPbiizKxGaTLozuJgN?=
 =?us-ascii?Q?++Y7G1z+aYNQTX05yKcAJnvSkRix01WJwwFPx67z?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25e95adb-424d-41fc-bb0f-08dc4e88e102
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 18:08:17.8492
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OLEasHP6uke5v+0HnMxZrX5Smd1TTOIJI7Rwf+6KkLvxjAvI+vXEMuRbCwg4yhoi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8487

CD table entries and STE's have the same essential programming sequence,
just with different types.

Have arm_smmu_write_ctx_desc() generate a target CD and call
arm_smmu_write_entry() to do the programming. Due to the way the target CD
is generated by modifying the existing CD this alone is not enough for the
CD callers to be freed of the ordering requirements.

The following patches will make the rest of the CD flow mirror the STE
flow with precise CD contents generated in all cases.

Signed-off-by: Michael Shavit <mshavit@google.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Reviewed-by: Moritz Fischer <moritzf@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 94 ++++++++++++++++-----
 1 file changed, 74 insertions(+), 20 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 19fa511cec2c05..453437ca4bfc2b 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -61,6 +61,7 @@ struct arm_smmu_entry_writer_ops {
 
 #define NUM_ENTRY_QWORDS 8
 static_assert(sizeof(struct arm_smmu_ste) == NUM_ENTRY_QWORDS * sizeof(u64));
+static_assert(sizeof(struct arm_smmu_cd) == NUM_ENTRY_QWORDS * sizeof(u64));
 
 static phys_addr_t arm_smmu_msi_cfg[ARM_SMMU_MAX_MSIS][3] = {
 	[EVTQ_MSI_INDEX] = {
@@ -1236,6 +1237,67 @@ static struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
 	return &l1_desc->l2ptr[idx];
 }
 
+struct arm_smmu_cd_writer {
+	struct arm_smmu_entry_writer writer;
+	unsigned int ssid;
+};
+
+static void arm_smmu_get_cd_used(const __le64 *ent, __le64 *used_bits)
+{
+	used_bits[0] = cpu_to_le64(CTXDESC_CD_0_V);
+	if (!(ent[0] & cpu_to_le64(CTXDESC_CD_0_V)))
+		return;
+	memset(used_bits, 0xFF, sizeof(struct arm_smmu_cd));
+
+	/* EPD0 means T0SZ/TG0/IR0/OR0/SH0/TTB0 are IGNORED */
+	if (ent[0] & cpu_to_le64(CTXDESC_CD_0_TCR_EPD0)) {
+		used_bits[0] &= ~cpu_to_le64(
+			CTXDESC_CD_0_TCR_T0SZ | CTXDESC_CD_0_TCR_TG0 |
+			CTXDESC_CD_0_TCR_IRGN0 | CTXDESC_CD_0_TCR_ORGN0 |
+			CTXDESC_CD_0_TCR_SH0);
+		used_bits[1] &= ~cpu_to_le64(CTXDESC_CD_1_TTB0_MASK);
+	}
+}
+
+static void arm_smmu_cd_writer_sync_entry(struct arm_smmu_entry_writer *writer)
+{
+	struct arm_smmu_cd_writer *cd_writer =
+		container_of(writer, struct arm_smmu_cd_writer, writer);
+
+	arm_smmu_sync_cd(writer->master, cd_writer->ssid, true);
+}
+
+static const struct arm_smmu_entry_writer_ops arm_smmu_cd_writer_ops = {
+	.sync = arm_smmu_cd_writer_sync_entry,
+	.get_used = arm_smmu_get_cd_used,
+	.v_bit = cpu_to_le64(CTXDESC_CD_0_V),
+};
+
+static void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
+				    struct arm_smmu_cd *cdptr,
+				    const struct arm_smmu_cd *target)
+{
+	struct arm_smmu_cd_writer cd_writer = {
+		.writer = {
+			.ops = &arm_smmu_cd_writer_ops,
+			.master = master,
+		},
+		.ssid = ssid,
+	};
+
+	arm_smmu_write_entry(&cd_writer.writer, cdptr->data, target->data);
+}
+
+static void arm_smmu_clean_cd_entry(struct arm_smmu_cd *target)
+{
+	struct arm_smmu_cd used = {};
+	int i;
+
+	arm_smmu_get_cd_used(target->data, used.data);
+	for (i = 0; i != ARRAY_SIZE(target->data); i++)
+		target->data[i] &= used.data[i];
+}
+
 int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
 			    struct arm_smmu_ctx_desc *cd)
 {
@@ -1252,17 +1314,20 @@ int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
 	 */
 	u64 val;
 	bool cd_live;
-	struct arm_smmu_cd *cdptr;
+	struct arm_smmu_cd target;
+	struct arm_smmu_cd *cdptr = &target;
+	struct arm_smmu_cd *cd_table_entry;
 	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
 	struct arm_smmu_device *smmu = master->smmu;
 
 	if (WARN_ON(ssid >= (1 << cd_table->s1cdmax)))
 		return -E2BIG;
 
-	cdptr = arm_smmu_get_cd_ptr(master, ssid);
-	if (!cdptr)
+	cd_table_entry = arm_smmu_get_cd_ptr(master, ssid);
+	if (!cd_table_entry)
 		return -ENOMEM;
 
+	target = *cd_table_entry;
 	val = le64_to_cpu(cdptr->data[0]);
 	cd_live = !!(val & CTXDESC_CD_0_V);
 
@@ -1284,13 +1349,6 @@ int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
 		cdptr->data[2] = 0;
 		cdptr->data[3] = cpu_to_le64(cd->mair);
 
-		/*
-		 * STE may be live, and the SMMU might read dwords of this CD in any
-		 * order. Ensure that it observes valid values before reading
-		 * V=1.
-		 */
-		arm_smmu_sync_cd(master, ssid, true);
-
 		val = cd->tcr |
 #ifdef __BIG_ENDIAN
 			CTXDESC_CD_0_ENDI |
@@ -1304,18 +1362,14 @@ int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
 		if (cd_table->stall_enabled)
 			val |= CTXDESC_CD_0_S;
 	}
-
+	cdptr->data[0] = cpu_to_le64(val);
 	/*
-	 * The SMMU accesses 64-bit values atomically. See IHI0070Ca 3.21.3
-	 * "Configuration structures and configuration invalidation completion"
-	 *
-	 *   The size of single-copy atomic reads made by the SMMU is
-	 *   IMPLEMENTATION DEFINED but must be at least 64 bits. Any single
-	 *   field within an aligned 64-bit span of a structure can be altered
-	 *   without first making the structure invalid.
+	 * Since the above is updating the CD entry based on the current value
+	 * without zeroing unused bits it needs fixing before being passed to
+	 * the programming logic.
 	 */
-	WRITE_ONCE(cdptr->data[0], cpu_to_le64(val));
-	arm_smmu_sync_cd(master, ssid, true);
+	arm_smmu_clean_cd_entry(&target);
+	arm_smmu_write_cd_entry(master, ssid, cd_table_entry, &target);
 	return 0;
 }
 
-- 
2.43.2

