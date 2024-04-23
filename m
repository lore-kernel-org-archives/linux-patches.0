Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2072.outbound.protection.outlook.com [40.107.244.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 845E81353F2;
	Tue, 23 Apr 2024 13:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713878069; cv=fail; b=dXOpbSl2KhoBU02iwIUA5oZLrmJQ2ZcXNykXBYnjzRjgU2KLUipTKYHzFs3H/5GlxcA2duQfTh0oso2e+O4uQQFB60nuQJ9kPPspl50c/W44zfyJ6UMGqR4Prat8VxwzYXwhczn17HPcaHf+/gdn/b/Q8WBr2MYI3ikXsz0D/3M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713878069; c=relaxed/simple;
	bh=fwTloDu3/8jUUXxg94dt1MoqWnCchzxkMQJoew5h7js=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JTDnJ3tYppfJRJ5KGr8jnsozenSFOQEB2WYEJ1WuduXP5a7Z6ESFfW01KYyQbq7cxQplzSJFmr+5j9Z7vDflPhQM+yXP/4Mn979ELUjO9KwX8O2ABpHo5z2++k/K7WFBi85ECyuWK6uYFBJJwqpPGFRUEwDyAoxfnZBB9OiHRqc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=cn2cZnNO; arc=fail smtp.client-ip=40.107.244.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="cn2cZnNO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b6o+G6WZIme0m+GB3Aw3ugxHIuzizOCUIMYMPgdDwc4zxNpou9Y3M1p4pGGYUp3ukkPXKTeyruuMzqgCIFP+NIfgKCOREzUEoMSCofMQAm0Ttk6ziC596/zXGV6koHiuTzLVWRlLR4lnKrziXIK0eAa7kyC6L27OkSSMCZmps78K/zqBqGIAHmAssQ+pOFDAxFDCqHJO0VQ5c+E9Hw2dssbTlxKnA4Nq3K86O/e+W78H0Utuv9jEyaOsVGGSEC652W0P1VMk27kuWkC2CGqs02uBbwA44aEdpJm+AUa3sinAdD1K6z6Bfdd77ZYkfTcniMT/4dY8hZAR8X6u3xH9Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g7USwmTvgNseOMZ0U83Nja0Rt/T64eXvuRAGu+bFU60=;
 b=YuoYcqKSJqTiCEyP49SocLCn6zr+kOBa49T4qOZvfamwYq88jYkmp8drOvYRzESuFCNndd9wbY+xYkDr1mZ4uNgoDzuyU6rmzo4KBlft41bSIdTEW2h/fbZR31zGULELxZrcE0WMOFQPIRuVqZ0eT38X1YQYTfuQHVwh7nW0nkFkv5ocdtD8epJ4UDp2tVQhjqdDDAsUS4uVRbjnLb+KV/c4lw3NglaBJ6T8trgEKoxGNWySIRDYe2OLUkftF+OuQRUy9Ie845JJT6MT65uvrvOEQJbWlQXl0HKJ7U7y+SDiUQr7Gv70tDZ72fjDmoRfGLuTHYtG9TlwDjfHkiTCHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g7USwmTvgNseOMZ0U83Nja0Rt/T64eXvuRAGu+bFU60=;
 b=cn2cZnNOVZvTIRcAf/3FrnSHVeuvJQjAETiY+zJf7rKuN93COzbMDMODyz28poOnk2JOZwW7GNJM1TkvQC056GnqyX4/GLCoWNzpyF7RSzFbJ5OWyOAiq+b91djuknLtIb/JMtCPKzak9Z4cWC3uAZcBjG/4z2D/zRA6e3fBaMH7Y3JlvECsH7lHZcjNCG8pHjk5l0vVwyh2X1HRpF4cjGB2FU1Si4VKOgTFq1xSRResJ8moSBzeeRZa1hmdGvKueGXhyPTxNifoF9SWvjW9alwRuI+ned+Gm3NPsiXckS0097uuxnWTR5/dx0MxQnJmi7VWUdqlh+MSTc/OrEdfBg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by BL3PR12MB6593.namprd12.prod.outlook.com (2603:10b6:208:38c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Tue, 23 Apr
 2024 13:14:15 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%3]) with mapi id 15.20.7519.021; Tue, 23 Apr 2024
 13:14:15 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
	Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v8 4/9] iommu/arm-smmu-v3: Consolidate clearing a CD table entry
Date: Tue, 23 Apr 2024 10:14:09 -0300
Message-ID: <4-v8-4c4298c63951+13484-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v8-4c4298c63951+13484-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0323.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::28) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|BL3PR12MB6593:EE_
X-MS-Office365-Filtering-Correlation-Id: aa76286a-4f46-4d01-4e6f-08dc63974651
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FoppDCxzb7/FFo0j2oplOp82j3Rco6W3P936ejaTc4Y7RLHwIwxGRcKPl0Qk?=
 =?us-ascii?Q?GQqdWKgdJo5dqs3s5sfyLAlz+xnyfYpttSlVCKJ48+go1t67OlTFF+mW2WlO?=
 =?us-ascii?Q?4h1OwOJ/jft5s9m/l7W96Siqnof+zukiZXx1cSqWu/FvznSa7hLvOWfiYYgt?=
 =?us-ascii?Q?mk+UsGqQhayxHqZCEQTRNr8RzaBgXMXPtH++UjL+o+zxZvbmjGtnKTtNOe14?=
 =?us-ascii?Q?kifkVtUTEviTHTqfawO7DjT/ShEcjMTXaITRy/x66vDdd+LsnAk1uB6q3UB2?=
 =?us-ascii?Q?sTxE5bufZ7oqyVDSvaViYYDePFdB0ie31Azg9LZx/c0hdda6JwLJ+x9GgXKh?=
 =?us-ascii?Q?86B6yxVJtfMTE3J9so0PWL+Zn+B2mc2McY+gRVHS7nbkviMi0MNFJdZIdhX9?=
 =?us-ascii?Q?Cy91q7skRw0Yz2QyyKARR5Xztmy1avrJPJI5YdnVVcV8dgMnYA4mJmmkzc1m?=
 =?us-ascii?Q?FiH06X87gYsFW//gu26EVrGvNS3x03/kg7q9KMW3AssLyyQRRWbpazqnYi5m?=
 =?us-ascii?Q?0MFJROY3MH9glxstNnuQt/7fJNEPo7sLxztMcKZoVM3CJUcbJx6Ah1QUulwk?=
 =?us-ascii?Q?ftN8FgcDehiesEabs5D8Z1yW/qIUd9HyDJXQuz5onhUP6mMC7n0+2K86jzjC?=
 =?us-ascii?Q?yfDsRKPQGBCNWunjiC/Q7JuLKkHyCUF1oWSHGUZaXVZshVOWBIwrq5/zEayB?=
 =?us-ascii?Q?MGf8HCo8b5bBrBEimgp6ODI4wC5plA+VT9xU8uecTf34Ih7hOkzeume0Hi1r?=
 =?us-ascii?Q?9zv/DR1Bp60RSV0gsRu157EQ17Iox4TuWtAT17TsOWiNJK+LdUctrj79dWt9?=
 =?us-ascii?Q?YzhUBK400xc+XfExBrHCoj8lN6tI1QZfGGjEZlIPb1aIfllKVvWQIjUo/pba?=
 =?us-ascii?Q?S83PZMUTgMocdUTPbSMJKiZDsHov5JPKZnEVz1dPXxQeDpFB9KV4FPARGnG0?=
 =?us-ascii?Q?V/0IX8MHcvL/UgSqZs7PpQIuljSSd3/4AqQCWxvYef5+NKcwO2KBxWfyvmLL?=
 =?us-ascii?Q?XdKv1n6KgYEujHu37Sd+jE4JoD2G7j+QiiRI07+6LWSp/ZJmB9DqZrw+WvF7?=
 =?us-ascii?Q?ZKRwONj38t6CHflmyq4O2SxCoGu8clX2UbgyrgclA+1NPQDCjC/86Kq1TixA?=
 =?us-ascii?Q?VY1t0U9yayE44G24phTBscAOzEYR8rdGBn2jpnHRY32CPy1ssLdhmf1A3INK?=
 =?us-ascii?Q?bCIzlJkbZpbJ/mC9MTpkVtWHAcl+uD9Dy1n7qO3H0ELOJl6JgPZGLv44yOa+?=
 =?us-ascii?Q?tBh3Lwk4YO8HTRf+0eedaU/utSqiXG7j2hefdePrOA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(7416005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JD3QaJoX7XVhk1z0ZjMTPhXdo+7JsO3dQ/LJLmdnpZfNUGhbH4Ko725M8KuQ?=
 =?us-ascii?Q?ow+QyeOnDcIVVzCVs0OLVJlDGyLFSgFD1DyWAYtb3qAjnTkuu78Sw/OanhtZ?=
 =?us-ascii?Q?Lw5AdhRZrxcP67D6QGQ+YhO91K3SpyYuM7WP8Y7noiAToEveSl4QdRaTeS5Y?=
 =?us-ascii?Q?RtLWLpn0ffrmyULlyUy/3eCdjnZfHDPA8vcnD9mYoblCNgDagBtzcEEFfrGW?=
 =?us-ascii?Q?rVxfEg9Mx7JlYLa2nlOYebSjivPGyPIibLb9mJsD2pMBvNR/h0KWCmmUduiG?=
 =?us-ascii?Q?cFBxxDTIhmgcJ2IowQPE/GzNy8kloF1N/nuRh/FcH6RkFLqhjCWRlaaKQtdJ?=
 =?us-ascii?Q?RtaoDv2fU5+i6AEsgX26ZA07zcu/Ut7G5BVaSAwPeFwyg3Q7T0fKtFKYp+Bb?=
 =?us-ascii?Q?HrfouXlnYJRvNADbYMNfqHDREyEfy8o/JoYLDMz4aAvSEP+mWFZ8qs+zyGR4?=
 =?us-ascii?Q?OB0D5sZy4IjP/auZfJE6PesCSAhfYaEetBHeKlGgRCSaOsJefZeuBKpXa7jo?=
 =?us-ascii?Q?dgCnjBw8tcGiLRKsPz+0VbbY1xMb25KQf6hF1fKyCc11D5FVSBLe1VcBym/8?=
 =?us-ascii?Q?niXa1Cd+OvcL4FentmELGeUn8KA/xX869YqX0d5c+cL1OKNsly/lZe9faDF0?=
 =?us-ascii?Q?XyX4L+XonDY0rrThwU09Oiq4kRFHlUYgEnW0YOr1zcgM3lIWZgIXnix8GatL?=
 =?us-ascii?Q?zH5ui+AUku9/Wo6M3K+IqDhCAkldBabwO3g2WtVpPT9XJsq4uE562N3P4t+k?=
 =?us-ascii?Q?hNnE0J8Kv/QoqZMQCWPUMW6bMiXd8bJK0FPK9ceB/BcpEWz2nBvcj9vJNelW?=
 =?us-ascii?Q?BG4oknIZib45M5YtogHOOqP0pjqwjduCSiF4VhYGLzEPV4kzJEZDtz6vjCTV?=
 =?us-ascii?Q?JEzfR+1E34eHKsg6zzLsUaABDsy2blUL7mUSES6rqlLiyU+4IUYZ01/seWxj?=
 =?us-ascii?Q?DdjhC54BzLKHgs9YII3ebFAN8qNoVRTlQBO4Gh37xHpc5cTEu5rwu35PHPxO?=
 =?us-ascii?Q?WbA0O7yFTTpiY99KpZDs1HQyhz4jMF74Ir3TD6ov6031z0uIB1DqH5QwP234?=
 =?us-ascii?Q?nnLA7SZqCrYNUm538Zz52dRVb56djSS6NsgkV1GFxNxLmU0Gz/4XaNk+lOB5?=
 =?us-ascii?Q?cgNBBKvzo0DEpHYYIIim2/fqMJnxQSnE/NZyW37VIuHNOhdIJv/+0Aeb5q/k?=
 =?us-ascii?Q?7h6fVbpO21IES/KSLZfIRSQnvqWUcnE/euF8+obqtEWYafThmmr31uGvhLjf?=
 =?us-ascii?Q?q4H/tlm2QV73dkJz1f1uZ5DqzKwe5EBSaql5C3563Heak14MQx7CT9v3EPq7?=
 =?us-ascii?Q?Pvhmda10EYgU21aiXB1JA9uw838tm+bkssZGpVK9Zn0r6mGQ9r9XeMT/VaD+?=
 =?us-ascii?Q?qjJtnuZHqnQqeoPoFe/3bqluDxB3eS4OnFXR+Eb4O3cbrp6pHGV3kxcgmC59?=
 =?us-ascii?Q?1ZtCKi3JF1fele2SGDPRBvZiFAIxGNX41EMHITHkQWQekFhPC9C8TVJdTEUz?=
 =?us-ascii?Q?8QeL7in12cSXfUtWHrElcMhVKt/gJiddZ2+ODiOaFteoRxBfyLaAeCh4F8SL?=
 =?us-ascii?Q?O9JwC5GGs0wTFoOBVrdKwf16u8/2VqBV0PnIork/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa76286a-4f46-4d01-4e6f-08dc63974651
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2024 13:14:15.2122
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bibSZdlP02v9M4h/ZcGvY1s5pG/FiZhgN94sBtrEAzO0+2fUnahpihsDYqzBnzQM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6593

A cleared entry is all 0's. Make arm_smmu_clear_cd() do this sequence.

If we are clearing an entry and for some reason it is not already
allocated in the CD table then something has gone wrong.

Remove case (5) from arm_smmu_write_ctx_desc().

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Reviewed-by: Michael Shavit <mshavit@google.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Moritz Fischer <moritzf@google.com>
Reviewed-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |  2 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 25 ++++++++++++-------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  1 +
 3 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index d159f60480935e..7cf286f7a009fb 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -569,7 +569,7 @@ void arm_smmu_sva_remove_dev_pasid(struct iommu_domain *domain,
 
 	mutex_lock(&sva_lock);
 
-	arm_smmu_write_ctx_desc(master, id, NULL);
+	arm_smmu_clear_cd(master, id);
 
 	list_for_each_entry(t, &master->bonds, list) {
 		if (t->mm == mm) {
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 0f4d275fff67b0..14beba55c32ff2 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1310,6 +1310,19 @@ void arm_smmu_make_s1_cd(struct arm_smmu_cd *target,
 	target->data[3] = cpu_to_le64(cd->mair);
 }
 
+void arm_smmu_clear_cd(struct arm_smmu_master *master, ioasid_t ssid)
+{
+	struct arm_smmu_cd target = {};
+	struct arm_smmu_cd *cdptr;
+
+	if (!master->cd_table.cdtab)
+		return;
+	cdptr = arm_smmu_get_cd_ptr(master, ssid);
+	if (WARN_ON(!cdptr))
+		return;
+	arm_smmu_write_cd_entry(master, ssid, cdptr, &target);
+}
+
 static void arm_smmu_clean_cd_entry(struct arm_smmu_cd *target)
 {
 	struct arm_smmu_cd used = {};
@@ -1330,7 +1343,6 @@ int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
 	 * (2) Install a secondary CD, for SID+SSID traffic.
 	 * (4) Quiesce the context without clearing the valid bit. Disable
 	 *     translation, and ignore any translation fault.
-	 * (5) Remove a secondary CD.
 	 */
 	u64 val;
 	struct arm_smmu_cd target;
@@ -1349,9 +1361,7 @@ int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
 	target = *cd_table_entry;
 	val = le64_to_cpu(cdptr->data[0]);
 
-	if (!cd) { /* (5) */
-		val = 0;
-	} else if (cd == &quiet_cd) { /* (4) */
+	if (cd == &quiet_cd) { /* (4) */
 		if (!(smmu->features & ARM_SMMU_FEAT_STALL_FORCE))
 			val &= ~(CTXDESC_CD_0_S | CTXDESC_CD_0_R);
 		val |= CTXDESC_CD_0_TCR_EPD0;
@@ -2685,9 +2695,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	case ARM_SMMU_DOMAIN_S2:
 		arm_smmu_make_s2_domain_ste(&target, master, smmu_domain);
 		arm_smmu_install_ste_for_dev(master, &target);
-		if (master->cd_table.cdtab)
-			arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID,
-						      NULL);
+		arm_smmu_clear_cd(master, IOMMU_NO_PASID);
 		break;
 	}
 
@@ -2735,8 +2743,7 @@ static int arm_smmu_attach_dev_ste(struct device *dev,
 	 * arm_smmu_domain->devices to avoid races updating the same context
 	 * descriptor from arm_smmu_share_asid().
 	 */
-	if (master->cd_table.cdtab)
-		arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID, NULL);
+	arm_smmu_clear_cd(master, IOMMU_NO_PASID);
 	return 0;
 }
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index bb08f087ba39e4..99fd6f24caa818 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -751,6 +751,7 @@ extern struct xarray arm_smmu_asid_xa;
 extern struct mutex arm_smmu_asid_lock;
 extern struct arm_smmu_ctx_desc quiet_cd;
 
+void arm_smmu_clear_cd(struct arm_smmu_master *master, ioasid_t ssid);
 struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
 					u32 ssid);
 void arm_smmu_make_s1_cd(struct arm_smmu_cd *target,
-- 
2.43.2

