Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2082.outbound.protection.outlook.com [40.107.223.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3958182;
	Wed,  8 May 2024 18:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715194655; cv=fail; b=P+M2FwE7dTIA4miweKTIGLqpNddwGN7cBVyL39NS7Y1z9ERX8kRTWoXY4END4y5taHwIdKOXetG+52M/b1ZqSCsBa74MGiSHtD1F1wRHwjeluFn/W1Qgv3OTBMOd9iQ/O6kBbmp8FUgnwroI1H4VlbUly1QzXoUS8mO93614joA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715194655; c=relaxed/simple;
	bh=+MNT8msjum1i0Jq55d6aGomiJuyZuhZvjzAxpaZRTY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=I+sUNNBk6u/OhQrYMAf5+MJmrmR0r2fVuZabFna5BxQF0K6HzRsoONPHbvMbrbrRkfk2+khsVH0pZ9S3hsr+KJsFsN5zjW3nTh1j2zPXk3K5TjzHEQBqf/Th6hVH7+OK7gEyp0l9FZJ3TgunqGtg8C+TDsgrVYxnDZcxu+YW+ug=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nI9ejoMx; arc=fail smtp.client-ip=40.107.223.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nI9ejoMx"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e8U6IqF7IWAm2YpN9Y7LPW2kDNIA+4mzRbdRC9JjByXqfF4SC/NTaLTAhDBnXanVaUchwzbZAr+Q68w1/3CilYqh+E8tLm47FLBg1FzD1F/MHN95gCZ4WipZHQdt8SZHxmORTHvOrARMXSwdMt2SAlR6BJFscYNh0jm2OPLeMmxCOUI2rOrXSvHmND8fIzD6iA9/qde2x4TdogEb0je2hN9JMfKOrOZj4kHM+w2S/nQH3yt2+LzztZMNgjBQxJ4y/uHE6+/jG2aCazAFmW+y6GWFfht5TcK2sp7Ge+Bpu9cuWbY9Jdadf4u41Tly7Ui9wxe4bO4kekk7nZBSksAoiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w0XpbKjKEw6H9M+bLyl+7sJR2dx4lSw7magdLibEy8U=;
 b=NP1PTGX8yqsKeEbRXttZ7FLlVD19RAz3MI5/lpj7y/XU2g1iMVuPkqNpdtp7YHD55PBtV/ZYqivY4Ed/tEIMnt1QRhPL0uzC91sOznkuWiywtX82WqqDGxVqj4sEA0AqW/9P63rkVW/Oh6237kzohhBJeS8paDnefhIttMydKm5UTCnqfARYNgAzH4Yt/81YDmiViPmR62wmzeaRIGXQx24CEA1JHxbV30ZG/6jyPnjVEk7jtIIjs0JNhQXL8tPlLcB4YAGWySWDWujYsPcC8IcsSbzd7wZ3ePlMGNsI0nm6Nv+ZSURHEFTPkM4bvlFJ89h85Lwa2J1Ys4Om9hF7ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w0XpbKjKEw6H9M+bLyl+7sJR2dx4lSw7magdLibEy8U=;
 b=nI9ejoMxqp6RRdCpdkmRPOX7hJ3fwXLXxSAqF1ZAqrdPqz/SoHPqn7RzWtJMfU4/i1W8K7xJhTzGjuq/gFqRFCyrZMQnMVixfH/jwImp+4pX7YIA3gU7HxWEauvsz3sXNjrLMwM7gQNNmlcbF6fhLgsA7vLIKma9PhPKiJoG3nN+KAjGh0fLvTwbr/sh/QZ8JDln3sLJfbk2egQpZv0HF99l05P6252oyjJ1Fz97vZv3osrjUAD/SVMBHV/wZLB+uRJKpJHXr5YMn32ol5iA6WZlKtlkQJgMEGzS4L/QhoVub4XwFBEubexJpu1nOaKbhLV2svo6e+utGTh7V9woeg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by CY8PR12MB7514.namprd12.prod.outlook.com (2603:10b6:930:92::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.46; Wed, 8 May
 2024 18:57:25 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%3]) with mapi id 15.20.7544.045; Wed, 8 May 2024
 18:57:25 +0000
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
Subject: [PATCH v7 14/14] iommu/arm-smmu-v3: Allow setting a S1 domain to a PASID
Date: Wed,  8 May 2024 15:57:22 -0300
Message-ID: <14-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
In-Reply-To: <0-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0261.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::26) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|CY8PR12MB7514:EE_
X-MS-Office365-Filtering-Correlation-Id: ddb3c262-98a1-4ae7-d0e0-08dc6f90b293
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|7416005|1800799015|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wzEyANIb6eEMQnWm1d2PSacIGDDpYM61TKNfnsd6KVE0CxNJ6hmhKNejcVO0?=
 =?us-ascii?Q?oD+dLMZWzvLagP12rKu1WFQa4NRpNnSgBQJl5qxqU1HMqiHSHDdvNlA7NQOA?=
 =?us-ascii?Q?81w78gyRO8Ip+OXsZkBiKFuccE0xjVrqdGOaSx6tBLmoT8Gq7CqXL0I+8zSU?=
 =?us-ascii?Q?nIcWDkDJZMEx7xYvX4iYxKMPi76P1QwqOcONkJ1FHjv696tbUMrMJOl7w4p4?=
 =?us-ascii?Q?Advm0Rif1vDcd0/8DlgWz20nNtEjQE0ArSsskk/BCKqPO3na+9EuSLBOEJvk?=
 =?us-ascii?Q?ZZHQILHfh2rgNaniKYagm4Y9JjlJ86NGJmbMQmlLAVkaX2dRFD+cnqxttzaD?=
 =?us-ascii?Q?M21gyWpt0Sy6oYfeQYR4FsA8d90iybQT45tlqjS14hNmMxCV1HHKhJikwn09?=
 =?us-ascii?Q?Q91cTMatKs7mpQXmboamFNaEMbvJNwZpiJVLGQFCB5F4YsQjKl/X9nLguCKJ?=
 =?us-ascii?Q?0zc4cuBkM7SW/4fFhQJ4nPxqAQAs2DZmZ7LCY4w2iHcn4YAuztO8ZZLQU560?=
 =?us-ascii?Q?SLpE6SDFojYKDwMJbHQcvDkF0xkMRf/T4nZMQTCloihn1GxNBaeJsirigC4o?=
 =?us-ascii?Q?MBHXBrWjM/mPSxj8Bkvx5VOJsm9tKabKJDk71dOWqvYWVfwQR61VsUzKVOyy?=
 =?us-ascii?Q?A7eCJEcqs4UDAUVyhe0z5mdNET8SesdkswkC8Z/AgDvV+wZg+EdklOaUA9eu?=
 =?us-ascii?Q?rtnBra6dcXU5LGn1FtIi88WqzUT32yrP0FDEigvKmJ0Qk49ANQYnPzR7RmJP?=
 =?us-ascii?Q?61j4O365zQQCTiCIcT44QI5gXOZXdyK+wGEYr3QbbMnrm3a5F3ovLv78p2En?=
 =?us-ascii?Q?5HyDX9x58vk3etc9uy7iqTaJeXHCzJMFNcX3zmFBnz2IvM6ZSoB0w71g6rpC?=
 =?us-ascii?Q?NkEzpI2bT1+5oWTv2kRdCThB1fWrBgvNno2Nwu4fepMTmxui4m+Pwoo11McO?=
 =?us-ascii?Q?5dgll0tPqVPMc9hQw6XWDEi3LuyjzT8jUlRHnvf8cmpNSiFFpalfjviQGPya?=
 =?us-ascii?Q?AoWcIpOgvURkjuherncrG1cB4wtFDWamevdRD1Y3aHARN4QueW2pw4pjnL0/?=
 =?us-ascii?Q?/mGZB5x3YQJkrvR7jDHXNenQvb6Lvt1pR1oqY+yJlOg0MxVBoNuVKOv9avQk?=
 =?us-ascii?Q?No/E9g8/XQgC+4MBTE5++u2Juroa+FLAwQu2DaR7hIrAO3MkfnHsfKtN/b8y?=
 =?us-ascii?Q?uPH8zTQO5b9lRVUHqTWM8DeC/dPLs/61UeNqHoUXtHoqjnC98sx+3pxZ9JKu?=
 =?us-ascii?Q?UqY5YNk/PAfEkTqhxcmKrYuYBZG6TMWCsNPs0QpFLQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yyhEIrg5reKg3VkfpslBMrkYk/u2vYvd62G7QilZCCXdNH+LuSk5upMrzt6o?=
 =?us-ascii?Q?oq3TU6o53wnJfnZfSb1r9xyl5zf4CH/pec0064+siCAEhrKa+f2Hc6ozBcp7?=
 =?us-ascii?Q?LkOgHjzz0OurO6eYWUYsXdCoUM6FDZ2k0DvHBRFeCjXGXYfxKQ0v4PoFFB6V?=
 =?us-ascii?Q?zPYtHgQqowzWxxVG+eyKYupAeg5ZoYZ4ZkifikMwHG5Qxf7ok+jQn3BJxHFl?=
 =?us-ascii?Q?Dzb6QaV0PcytrNS4l0dvIvv8pyJWmF8dOu8cwCZlUAtvaAmp4RcFwWnHxvPd?=
 =?us-ascii?Q?uWu5W9xSo5/d1dEphnCT6Ku+y6kgqzUfXZCZdXVeFtFahdHajvT3EFBqn0RM?=
 =?us-ascii?Q?Az+u5/vPoKDUcI94UiEw4oM0HHL8wB4DofAd8v8z3lkmLNZXUI69TRA6ZjXN?=
 =?us-ascii?Q?7VtRSkK571mTjIAJzLePm8AyJ/LL57x6fL9+1W2tcoRqxRFyxBm7cjSh1fXq?=
 =?us-ascii?Q?hb8cuTX97Ryze2rza7EeejguTaPFourbVz5jvRc0gjXNLQ7i0F0t//wX7T1U?=
 =?us-ascii?Q?L9OJ7AwiIO5bDhsgT2Uk9ds6FdgqlmcGVwD09xvRTxwND2JKcXN0z2cDSRCO?=
 =?us-ascii?Q?C8fjRN/n2PL6ZoLGGkftO2VQ8kY6u1FpXErvU+F0GhhG/PE3cOAdjsdixSao?=
 =?us-ascii?Q?5aMg8Bq/0CQ8MNnffa8GQak46xdwvTflzA2QPX1/O391W5ivPKtupjc+X5nk?=
 =?us-ascii?Q?7yAM/FNNSWxZMNnIFWdszqrVB04+uQ3BXgBc2L6LYrgeDMNZykS/MZFUpG8h?=
 =?us-ascii?Q?6UdGDAzPEFqVQflDStGsc019ARVwMa8f8Fo38rsaEVUzoW4+TjeBI/SDXxTU?=
 =?us-ascii?Q?vbGc/I/JbPhS/JRGsAy1PvEOGwoHfD5NKXcDpqJZPDYkQTvpXaae4mWV9/DD?=
 =?us-ascii?Q?w7h4f4fiRwG7U+zgNuYVWIdUDasdTC0yGNgpOuec2BQh84b0svz/LO/1sjuA?=
 =?us-ascii?Q?Ccynb/LLw+0TC9Pv2mOoIwECeXh+gm9Zd1BZYDjK6bPy9bINx4EPyh5zRqgp?=
 =?us-ascii?Q?KLJhbvglsDgmkQ8vvtxN2eUTMYV8Nd81PlU8V+CuxZ5zE3WKMf62IoQlIi9/?=
 =?us-ascii?Q?BGGiIhDLkoGHf6prOZvMv+fRQdwWIOmzSJSSrjmAACqK1STCr101OhWb/WpZ?=
 =?us-ascii?Q?QwxYpb1Ko6ZLYw7n1vN312pWzisWc05+a6oppft1ZDM7i6ZRnVkQRS3Njs0L?=
 =?us-ascii?Q?MEvy3/NVgG1GomDSWStl2rcfEyXr5srdCFj9to7aRco42JhAIqvOg9IslaO0?=
 =?us-ascii?Q?SC5aGXAwVO4yONQ/NfUZg2BkD4qDVrXSoPBxcYH3BqjEoRQhXD+XwcQ9f3tc?=
 =?us-ascii?Q?ij1IcXm9OHEys0vMv/WZmqfj5MRSENspfoWEM8YHMc5bk8Wtu5WVXPdPyH+D?=
 =?us-ascii?Q?LirO6y2VeirPxFlFx+7ypEHEavcsJHTu5Ultd5k7q9HRRtGsm3Dyazp4qH8a?=
 =?us-ascii?Q?YZZ5C/x95Sde1gSZcIftBQ0e9Sp4+8p4BO6bL0jnwfnBpif6i/9gvgQDjKvN?=
 =?us-ascii?Q?J1L/eKSjyYNYAIKVVhT8unyFYGqLfy1uJTgcNbaVYQz8ScruMs0S+O+KjVbX?=
 =?us-ascii?Q?MUs5NuKRKw47Rgbq5sSIOCsKzaTwL6H/J2jWT4/v?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ddb3c262-98a1-4ae7-d0e0-08dc6f90b293
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2024 18:57:24.3794
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nj9fbZ9Uc6gDIGbACiR1MBaakdBgdunUA05PUv8p0wNkXeZP4nxUmKWpfMkNRMIp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7514

The SVA cleanup made the SSID logic entirely general so all we need to do
is call it with the correct cd table entry for a S1 domain.

This is slightly tricky because of the ASID and how the locking works, the
simple fix is to just update the ASID once we get the right locks.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 41 ++++++++++++++++++++-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  2 +-
 2 files changed, 41 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index ccc10ad3ab996d..9506073678bbcb 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2768,6 +2768,36 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
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
@@ -2795,7 +2825,7 @@ static void arm_smmu_update_ste(struct arm_smmu_master *master,
 
 int arm_smmu_set_pasid(struct arm_smmu_master *master,
 		       struct arm_smmu_domain *smmu_domain, ioasid_t pasid,
-		       const struct arm_smmu_cd *cd)
+		       struct arm_smmu_cd *cd)
 {
 	struct iommu_domain *sid_domain = iommu_get_domain_for_dev(master->dev);
 	struct attach_state state = {
@@ -2827,6 +2857,14 @@ int arm_smmu_set_pasid(struct arm_smmu_master *master,
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
 
@@ -3352,6 +3390,7 @@ static struct iommu_ops arm_smmu_ops = {
 	.owner			= THIS_MODULE,
 	.default_domain_ops = &(const struct iommu_domain_ops) {
 		.attach_dev		= arm_smmu_attach_dev,
+		.set_dev_pasid		= arm_smmu_s1_set_dev_pasid,
 		.map_pages		= arm_smmu_map_pages,
 		.unmap_pages		= arm_smmu_unmap_pages,
 		.flush_iotlb_all	= arm_smmu_flush_iotlb_all,
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 3c189a48e29757..c32ac37c0b0e00 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -801,7 +801,7 @@ void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
 
 int arm_smmu_set_pasid(struct arm_smmu_master *master,
 		       struct arm_smmu_domain *smmu_domain, ioasid_t pasid,
-		       const struct arm_smmu_cd *cd);
+		       struct arm_smmu_cd *cd);
 void arm_smmu_remove_pasid(struct arm_smmu_master *master,
 			   struct arm_smmu_domain *smmu_domain, ioasid_t pasid);
 
-- 
2.43.2

