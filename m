Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2041.outbound.protection.outlook.com [40.107.223.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77E0B2417C2;
	Fri,  7 Mar 2025 18:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741371460; cv=fail; b=K9Bj/UrGpEIP8jmvB0cjW9kyt1XfsjX7PNw+fC+AmlbnM5FIDNKSw+nEmjI6vdGuUII9+tu2rlKBg92fl4zyeSnIXw0KaPBGAMXlx1LFnqzHgBOVnTwjyT0v+Bnwe7Ic1fVAltalSmLtLIW893AlGt6bgpcQ/ZxUOlhmWuXkkp8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741371460; c=relaxed/simple;
	bh=zPCoMa4j9cMJIRxqlYBFeZyxfUokyQdeLcffRKZR+Kk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qin+CAkIkKqS951bHDeTlO9+TOWVuiwufnju0lw9nIT4t3flsUv7uYCJr/tOO8vpDKGHwQhZ1cIqEwdxtxr458kzvCBrmitKHXdQ0jQEOI0fJNTEOALWyLGHkdYrcL1QhcnwzX8gxVJHEHs9qKAzcmHlscpPf8ine/l4wA8au2I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=SnVJEtJZ; arc=fail smtp.client-ip=40.107.223.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="SnVJEtJZ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y3Zqp0rgHoI+uKx2gsS817MIaXWhUxFZSZoiSvM+aeaUStFvcOGtGphU4EUMa3cqdZlnFKw2FuGXSLG+6LlLmOknGNWvKLgLLyksp2h52JHWrIw0IAqGuYPS7MEnOzu+E21cX+OrxtgcHnQ2o8CKff8kY6PqR9ehsWxz8NS1Ylff2Qsm0JwQ9qZJD/30vf5qYLTQxZTwkAdYuzX8UrC3OTieqmd8Ujd/yMHhTZL876TL/UuMnCaDGrS1+QJVCww+MhCslJ0Kkg3YHLu2+Zxz/uqOrH/qPWLLsc8/0q8O49mtuDzuolHh4j9YDLRv2hK1UiXAtxbLD5+wdbLC/WLyww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DTAxPOuxTKrGiIKO19BRtkqXkwH7FWpet314rchS2CI=;
 b=sTMKtHniflnn3hOcWjIHlgmHCGC2+YBcbvJaqfUblaaGoWt/szhIuChcKhAN6G5aN4seQOuBLhGyCffsZ8fVxMrJqQ5hflmU4OLQtD5L901P/SUN2yvocm6TDTQ7yL+XOB7NnsEObLDsiiy5EllFw57tndldmpb668u/R5uBfDeL8Jm+bUg9qgdlPhTucNOd2fVWS4EgHiE0de34/ic46sx1q89YUVTf8shDt1ww+cJhUCkvqOp9m35DhOtEqhHnC5uDOrszgdrJgxj5OwniDY/mNbhiw+2Y5MQGEqUI4ZRQ88Z6EvHmI2NudFccIIpFa8H7ujLCHdgmBz9qbdHbsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DTAxPOuxTKrGiIKO19BRtkqXkwH7FWpet314rchS2CI=;
 b=SnVJEtJZd/9/1OWY2w9azd65fQU5vAG48dvvRZEtU6yAG0HfzJ76dMGpUHVInf085Khdl7MBp8WdEX0y9ejSEv8QqCS1juF76VeEMli7nHQHa/1oe0fZWweQF/e4v3gzz69HTzcMHnFcEBmrwmYWB3xKtWyFrJpsE21CtEpWGi/cpHXFoli+bB4oQT5raqnK6i6GE54Bg6gqHpseu5LCKBPdLcB6Ct5YB009E+JG3FV0INoSJH8h2Mk5t71wXBx2HzKsu0KVgyYkKqNl30rlnphYKTOBeAIgfRRIiZd+7ys3tE8Sq8QBTSl6GOAqe/0EyiVyPwB183PWPpveJ9DEIQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MW6PR12MB8663.namprd12.prod.outlook.com (2603:10b6:303:240::9)
 by PH7PR12MB6539.namprd12.prod.outlook.com (2603:10b6:510:1f0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.18; Fri, 7 Mar
 2025 18:17:31 +0000
Received: from MW6PR12MB8663.namprd12.prod.outlook.com
 ([fe80::594:5be3:34d:77f]) by MW6PR12MB8663.namprd12.prod.outlook.com
 ([fe80::594:5be3:34d:77f%2]) with mapi id 15.20.8511.017; Fri, 7 Mar 2025
 18:17:31 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	virtualization@lists.linux.dev,
	Will Deacon <will@kernel.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	patches@lists.linux.dev
Subject: [PATCH v3 5/5] iommu: Hide ops.domain_alloc behind CONFIG_FSL_PAMU
Date: Fri,  7 Mar 2025 14:17:26 -0400
Message-ID: <5-v3-e005a650174b+53def-iommu_virtio_domains_jgg@nvidia.com>
In-Reply-To: <0-v3-e005a650174b+53def-iommu_virtio_domains_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0307.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::12) To MW6PR12MB8663.namprd12.prod.outlook.com
 (2603:10b6:303:240::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW6PR12MB8663:EE_|PH7PR12MB6539:EE_
X-MS-Office365-Filtering-Correlation-Id: aa3e722f-e4af-480e-9007-08dd5da451e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?W70XneF7OzMQqYkPTkxDjuEBqlqEt0i0itmteXzzT9MuVA0u1wDp/wzQi8fi?=
 =?us-ascii?Q?vj8il+gU6i25/Y7z4+DAC6llJVLViPms2zqmXlXdUL3vevsLimtNbWH/C4da?=
 =?us-ascii?Q?rXnFj7DGFT03HsS3/HJwbycGytWL0U6G+iLp1+ppQVbQzYlTR31gINvn5tTc?=
 =?us-ascii?Q?Ph6o8NpxdI+qsJxT+k6C8OnyzvBUMdVltLB5YQdsTHom0R+VwllOR0sBIvOH?=
 =?us-ascii?Q?Qi7ibLBHveQ6cXGGVMSqlJjV8Guf9PraTHrrcNl32/PgNSj/Ih2vhVzXHlLj?=
 =?us-ascii?Q?+EnN0HnR5rhAPdc0wlNi8FdVKTNY5SHnEBCXZRllEREwir60adxCdrKzKm+z?=
 =?us-ascii?Q?vjRo7a4Zv8VEtQSYXebASh1nCZYdjjMep5Yd5WCDhXkYGZMMU5xIH8espdv4?=
 =?us-ascii?Q?Ncj0BmXGjXPv1vi0FgG+v25qYahRJUHv7JiaE5XC6fyPha/rsnc9hlG1YVYq?=
 =?us-ascii?Q?euACbjmfaNRamd8/yYJSxNE4C2s/H3TeBpaLXd5OLqZsONMI7NxINVRXlIX4?=
 =?us-ascii?Q?C9islr66gCBxzo2BPsCxR3ItFz3mt6Xd4H9REwdhMOMR82jN7zAybVf6fn54?=
 =?us-ascii?Q?y0LMs2fASYfc2qmdVKE0UbWzvUWx9b43P3lH+3+iiEMWcr4sycxTXNV0nO90?=
 =?us-ascii?Q?+KwX1w5ju9p7wvguQ7IkUK501qLtbeowehBKY96yGtqOpZd+Lj9h4Ihoittj?=
 =?us-ascii?Q?BYorlGQyjMq+CHeGX4XUZxUiQarZICOCeTulHSPOPQl3RqDKWmylpcP0vE/r?=
 =?us-ascii?Q?XbjzJJCMVjKpyfYHYuzZGa3jl30AWQJ3P+dLkUvAyoca4cTyIktkJd7sri4x?=
 =?us-ascii?Q?Qm6XnZuyCTf0X0oZDiCcixF3vP6OEl4fJ42w9c7OmiZiP6+xfft4MlzY6tij?=
 =?us-ascii?Q?jlrx1sW1hM7n/8JLJ5P/WJrADSv3l9liKwvb55XaSKnG9cDR3tHz+p3s6vaV?=
 =?us-ascii?Q?bHcziMNUTnVvmn6pw7vX5CuzOU8h8nyg5zOK/4Rd8H0FKbdeKL1ms89ag9nN?=
 =?us-ascii?Q?QWjuiA+Hf1iTaz408kVYZywjr+rHWzToqteo/CDZkXqPR5e+Nszg6+wGRJ6U?=
 =?us-ascii?Q?2SxlZ6dcR8Ty1bKhM9oQIrb9RLdgj+84Cr6s0v0ppTDLSqBMFL/sIwvTQW6z?=
 =?us-ascii?Q?wYvcKofo3DHbJ0b+MVCCunSY7M3QmhHWr6k1tVcW/9xIMe086lX9O6WbLBNn?=
 =?us-ascii?Q?2fp3/iiKaARcOTW8S2ac5tK66RL9DNNYZM9W68CaSIFW6gUOAUvizF68a38u?=
 =?us-ascii?Q?ld09njJSaXYPDtqZXN5TP1pmHmZWahEGERE3RKPo1E8FssxQdrnFYjCnyEeG?=
 =?us-ascii?Q?s3mTIin69onr6eO1BGAv2JGYI3fDB9ZBgQayqhLWr1+RuCDfPgCr+J2fDXOn?=
 =?us-ascii?Q?XETurSAKSvxk+NHV1Jqta6mJy4MO?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW6PR12MB8663.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?km1tLFO/UtWeFDz82Ud2C8sKTMUBfx0nUN2PSxzlDs7lQmE+HEqT/ie5uugq?=
 =?us-ascii?Q?bkWC5axR7ROj0F/p1y/yHLNdkNX6pahlI8a06Lzb4schH6k1evIckzEDi5Pu?=
 =?us-ascii?Q?EvdH3kVlo8KOVvweHixM1Lg2cEfFRpJrLm8OoaunCbMaJM+v2cCU4iQSiL5O?=
 =?us-ascii?Q?5/jbG20Gr2LHbNKgfc32Q9BMY5PLqtNsHYIes2Ee3nrK5A/z8CZjUM5dj6Ob?=
 =?us-ascii?Q?pdPu259tIsw/rc/1q6akyOQMwMbd7zEBHqqImou3aEH9GwGtfSAA4HwJOmQG?=
 =?us-ascii?Q?D/t48Qd3ASOe4s3vQM9KKLqc6ITPICaOs36cCMyrWvL9nnUZT/x95YeqATGI?=
 =?us-ascii?Q?ju6bnY3CblrBffM39EEbi3c9s4539Z1aD3tttSHVA5z9tSZ/2IlXWGjkGVeH?=
 =?us-ascii?Q?rPDpc4l+R2ljQ0SlPFqoe+N5HvfcBT22gf5Of3xuWt+GDcxBQuVKRvUdmPXU?=
 =?us-ascii?Q?EE0dbxbC3G4fetQ87QPL1FRV2TSLRg5EXWq6yWvl61vejIKMayFuFNphii3O?=
 =?us-ascii?Q?3CxQyQHffmCtJxXQH5q4/Og4t+SkBgPpmqHmvWECN6kjrIFNvcVvpf7dMVsi?=
 =?us-ascii?Q?SSCGLKF2XDq5W6wo3re5jo8wXTH1wujHYwaJ5pIxMhvm0V5PZeoSX1XEDSzr?=
 =?us-ascii?Q?78Pge0gptP7YNp2iKWsajZEJC4D0NooZRab+ZXtsFt51CLleFj7JXfj2wher?=
 =?us-ascii?Q?6Qv8Tx+K4M1XWkKv2174v28j75Sy7m3LmTmvR2UqDQv6YxKRs2CDPWBZdV9i?=
 =?us-ascii?Q?m7k6AxFdVxg7xZw+epGGnFWnJAPczbgnOZkGrEefg3hZvwYP7XL7xMBMPT/H?=
 =?us-ascii?Q?tZn8iUT4fomtlDQEsIoFoZHuryP+iHmrme2cuGmBuVUizeTKpDqRCp/mWcPh?=
 =?us-ascii?Q?35+g3SHd0Bqfjlobxmgc+hVyN3Alw0shMSEhHtw5zOAhHc+tPO/zpilpjzto?=
 =?us-ascii?Q?fvUSJPyBBcFaKB7vYq4TNC7NLwIIaokWjiYfdkUuSVkXOA4Z4t5CmTZOrjhh?=
 =?us-ascii?Q?gw5LxIhpipA0PHUL/w7zkVFr58FeWRTp6Xy3YX1IWE2H4Ftc+Rap49wseCJ6?=
 =?us-ascii?Q?nh8tyYmz99cIMvl1KXPGLDMI/3A5UyUfD5mTTa3zdUehG+7ELkOjf9hZI8Et?=
 =?us-ascii?Q?KBcRp2Md6TR4gQJ3858yLPhpXajc65+dczaNm6gZF0OAhyKmbxKUvTvPVJC1?=
 =?us-ascii?Q?a7P0g8Ub/h8U4aBsvTSNhVtqATsWdmfk8hX0v/UYP5MLF+iXE1OPBba0p3OR?=
 =?us-ascii?Q?H7BGGJiYJs7dW1Y8fvaQxVHNWVvEP+z4o4S+2lZ70tOsSGvaaL2D3LwwCgg4?=
 =?us-ascii?Q?Krp6JQyXGyDAPp5ZUGV267d1neFWXEAQx8LC9UGnqfOPPIAGYXSM5etYj9Be?=
 =?us-ascii?Q?eydSsFpv5d4nIY1d0M1ej2aY6zu4/TIMfge16pncj0gylI6d9eDiTh0iLMTr?=
 =?us-ascii?Q?ANgyimlErRJCLmxvzO37bpetQywYc8Z+6jmvL5aemdJBS5bG1UGUjpKZUih+?=
 =?us-ascii?Q?MYYE6kwtIDKJwrfXpBNzK+egOo/2pauBLLoDWPXitRFiuPH4dlOm40X8sOzq?=
 =?us-ascii?Q?te+IHXc9nAZcCT0RdsqDfU+117ZD5ET49t7h/n2L?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa3e722f-e4af-480e-9007-08dd5da451e2
X-MS-Exchange-CrossTenant-AuthSource: MW6PR12MB8663.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2025 18:17:28.7645
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: paHAP2HKv+Izlo46Oz64Twz5tguS3uz0bsT3SiSGsSg/KqDEn+mXq1hlb5LZtrj8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6539

fsl_pamu is the last user of domain_alloc(), and it is using it to create
something weird that doesn't really fit into the iommu subsystem
architecture. It is a not a paging domain since it doesn't have any
map/unmap ops. It may be some special kind of identity domain.

For now just leave it as is. Wrap it's definition in CONFIG_FSL_PAMU to
discourage any new drivers from attempting to use it.

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommu.c | 2 ++
 include/linux/iommu.h | 6 +++---
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 73a05b34de4768..b81a82df9fed25 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1987,8 +1987,10 @@ __iommu_paging_domain_alloc_flags(struct device *dev, unsigned int type,
 		domain = ops->domain_alloc_paging(dev);
 	else if (ops->domain_alloc_paging_flags)
 		domain = ops->domain_alloc_paging_flags(dev, flags, NULL);
+#if IS_ENABLED(CONFIG_FSL_PAMU)
 	else if (ops->domain_alloc && !flags)
 		domain = ops->domain_alloc(IOMMU_DOMAIN_UNMANAGED);
+#endif
 	else
 		return ERR_PTR(-EOPNOTSUPP);
 
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 6389d59178ba3f..55cc87bc62f5d0 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -554,9 +554,7 @@ iommu_copy_struct_from_full_user_array(void *kdst, size_t kdst_entry_size,
  *           op is allocated in the iommu driver and freed by the caller after
  *           use. The information type is one of enum iommu_hw_info_type defined
  *           in include/uapi/linux/iommufd.h.
- * @domain_alloc: allocate and return an iommu domain if success. Otherwise
- *                NULL is returned. The domain is not fully initialized until
- *                the caller iommu_domain_alloc() returns.
+ * @domain_alloc: Do not use in new drivers
  * @domain_alloc_identity: allocate an IDENTITY domain. Drivers should prefer to
  *                         use identity_domain instead. This should only be used
  *                         if dynamic logic is necessary.
@@ -617,7 +615,9 @@ struct iommu_ops {
 	void *(*hw_info)(struct device *dev, u32 *length, u32 *type);
 
 	/* Domain allocation and freeing by the iommu driver */
+#if IS_ENABLED(CONFIG_FSL_PAMU)
 	struct iommu_domain *(*domain_alloc)(unsigned iommu_domain_type);
+#endif
 	struct iommu_domain *(*domain_alloc_identity)(struct device *dev);
 	struct iommu_domain *(*domain_alloc_paging_flags)(
 		struct device *dev, u32 flags,
-- 
2.43.0

