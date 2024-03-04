Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2B547D06E;
	Mon,  4 Mar 2024 23:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709595882; cv=fail; b=lI2kiYlPrdmdRwgZ++ZmC6qstm42zQg6DembXG9v3YJCcEy0sU3OP1N1U8Su/EW6BUxJQQ/fkiqYqUnGBSGdR1bmu+jNI5OT5xT8WzA48T1YGSN2+XFXalGDXaFEHuJXEEB1IwU1Dom2sAfSM89QPFuYmQiRaDLLjEwU0IdCJNY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709595882; c=relaxed/simple;
	bh=JDS9tzPlNhHRQUp6xvOC8ijHUHwHinSibb0wjrpOoL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RbJR2dwk7dsbzyqMTw65tT9qLLqD4JJe10D+4gCsg8s5Ebhh42ay4pDzQ2WKK5GzPADiG0efJKc2d6EQvUDXcdqKnRuqbBXp4LfTZEQNjMnb+KGHiOzWuY+yNsS6V0haJSF/PNmeESh/UcqXCiMZLjoblomtl8wiSl5yVX2OVJ4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nnA2f/8w; arc=fail smtp.client-ip=40.107.236.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nnA2f/8w"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A4M7MULX8NLYVQCZXF9hpDXR5VySebdgzAgZIsZBkfzPdp1h/02EegrEj7Gcu5BMKrRhkK1fG0pecMXAaaqQhq9TXKDHPOzPoTb4DgKw103B8Pgn8doPlqMaGeosTM9sz3yFRJ44edpixJnIgJp43JwLIeT7fUM2Vl1dpvF6/phWbjMPMB+IGttO536reURIUh6+5vRFPYEeWnUeXJRuVYj2vqppKpUEiUb50wA+4zn9pj8bR684W/pczyPvfjkJ47ycT3P80R1EyBvnPJcE7UhQSf4R8cykiLb4ZX8tLW4duwf/HOyeh3WCPKL8eySzntTtj2q69HFPfYbtXKC0vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6g5JKPqHJQm+Fswp8HSfNrWm4fQ6UXpSN6bdB099DpI=;
 b=mij1SEREw2TxVMsfSydA9vf8RBvt1cUnRaRiZuq+4EQQAafkeZAgILu9yoNgNdrtTD2JHmJ1eTUKBFdzBFO5Qn9SAPRtfhwP+IbZ6Ix0EyZ/tHtvfOv9ncfY1m8rAFmNs6I79+2DL0MeCLEPed1E0EfkxMMoxwH2ncjJfF6UE632Q01uyZ7RW/vI8Ng2OiA0Y/5KzD3VcUeSTK+KIQLJ3PjgkLGwV6lFDBTmXjw8bs8+8gbuWsFXD+1gekrQd2aMejgk/SXKeDAPd7Kwf6bV0H9EibG6kqn7ZFUV1h8NKnhuVKWNLeQz9xeBPCMycb9Lvii5MwCQIik78tKs0RQnuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6g5JKPqHJQm+Fswp8HSfNrWm4fQ6UXpSN6bdB099DpI=;
 b=nnA2f/8w1D8dhsGgHug8LrYRCeHoHml/w2kKhbN0Q1j0CxJkNYowucYv/oi09m8v0lUWR4EZ9tsrlPA3csd6g6kKIHzv7bPBVfsyho/xFuVT/+LGwSImBfbEqD/07R7ORLdmxZN0c9X7cQujipWDvRPAvD11smMiCBiinzBLUAQVvftbQzru1CsetsCUBpamAeKY85gcHYisrs/hLe1ttX1ppTC8aVcRFwdHidnu3srEAJiFU9v7pLwZMh0V2S6WEwGsTfgDqvqFMmK3ETIarWrzwR+UlWQWz97PvPu1lmm+MTsIBPDSSvWh9+Np9Z7Uh85X7tLwNDxOXVg8dVyN8w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by DS0PR12MB6584.namprd12.prod.outlook.com (2603:10b6:8:d0::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7339.39; Mon, 4 Mar 2024 23:44:26 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c33c:18db:c570:33b3]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c33c:18db:c570:33b3%5]) with mapi id 15.20.7339.035; Mon, 4 Mar 2024
 23:44:26 +0000
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
Subject: [PATCH v5 19/27] iommu/arm-smmu-v3: Keep track of arm_smmu_master_domain for SVA
Date: Mon,  4 Mar 2024 19:44:07 -0400
Message-ID: <19-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR1501CA0018.namprd15.prod.outlook.com
 (2603:10b6:207:17::31) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|DS0PR12MB6584:EE_
X-MS-Office365-Filtering-Correlation-Id: a4f19260-335e-4666-f656-08dc3ca50246
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	9OKx1tBkY/xF/Vz/iPpoxnxp5q4zTZvll1MwsV3r5UVDNynAvmx/TgtsehYPfwxJ/TxroI8xpcr281a+xA7V6Bng/y9/ijc4ZlH02Fh0Tiyt/VgQJp8Z+wI34aL5VYQl25Pob1WMLsmC18XZFsRStoKlSRF6KMhuK6xrGDSV8aSrFDNI5aBYOSIQ/RsBhKqbcToAuW1XTpqjt2hM7YWTnbng/KPO3Ylzw9V+SI2eryryrrLFTPerDYVgALRK7+hhsO0gGo55+RgaT5DAYwOzdyNo7Ma8BcyQpPl3LXZzBdcAUs+AH43K1X1ATwhYSfMZcJJ9nX6wrLnV2DrGtNenH4ZP1WvZddiTmbGzOddtrlvWBuu7ClcXQEV3GUAquAqAOMoEkbJICrSkADplwmahOBhmUv9oB5N5ruLEJ4REY92Y1dHpFlMcx8j06Gwh2GZZevkDY0Micbmcb2xRYM1Eb7m1PK7ct1nm86u7bJmj3nPFkytTzUibP8AhGqr8VLmsUPJCSLRRNGB0Aa/RmfYiLgvSdZMYSPlGJ9r4HT1I7mfDmkjCjXUZvGSoslCY7P7zR/u2DaAYnwCRvTdA7ywV1KKzJUZo3gwrrlJvHnL2DHvE6S6a0IgbaHzKyz8ZQKvXbEAu47O+MV69Xom+LVCcKcU3zlIQQkmhZ3MpYUPeppI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?svO/c8dpzWZs4W3O9aAAjPWmMoXqRPLYj8lgxMhAeQz+bB3Ell0cmWjAeLx4?=
 =?us-ascii?Q?jc2JtbYUWk1Jc1eVD3qHM0sN0E6CEuMhGjKBdB4P2Gp/0ULV07S3L6/u+zhY?=
 =?us-ascii?Q?7uHjMBqoUqAWVz6dEU7qIpUSK1bdd7Z0TH5AmTY7dEM7oxE7aFssgcY1vjzf?=
 =?us-ascii?Q?lRVHj5pJ1JqmNmj+40puHwrGptMNuULXVlXU5Jgde0EjEUR5pUHYc231KKmk?=
 =?us-ascii?Q?hfmAYEYAqKumZOTX5f4dV52fjXclbeQ/y15bk21Uk84i54OUqBVKY98ovoJj?=
 =?us-ascii?Q?U+9xqiHg4zHAHzMGAg6OdvBjfJIn06quiw/Fw5dw9g77jv+Wd+e/mtAkDHmJ?=
 =?us-ascii?Q?UzJtSUjl+A30NPyE1303cdknnyu5ashSwBkSOIs2JCpzKgsVp3+YYM3pJZX4?=
 =?us-ascii?Q?2fWudusadVT9SBrAtA/lTU+1oxJlQ+wzrIZ7S2PmcZoEc1wz5budPtJrNc1U?=
 =?us-ascii?Q?2tGhJ5dq3bUabE+rFQC4tfBPXxV+SNHfS9hEgLnA+xvTXt5kNWSL+y8imPsY?=
 =?us-ascii?Q?DxWs9R4WjWjPt1e0PEwza83mYrNk/TI5/8Bi2fOBx4G4mHtAA6Era+m7QMFO?=
 =?us-ascii?Q?IpBRNAi7TAGlQrK61+32jsMP3J+PBYtA5N8KUKd0TRKfztRf+DFBHssYX4dY?=
 =?us-ascii?Q?IbZ7tIXT2lPSKBH5zM2y1uUkMKxobHQWJyd11Om76AOoD3YBQ5bdV+iXW12u?=
 =?us-ascii?Q?JwAYsXVWQ0ERV6S5OUk+NnDz15bMjGTSXpTpuhxuIXZ1PMD8Gj9ebQfsJspB?=
 =?us-ascii?Q?hNdfC6N/9w7UwD+GG5DAUA2alD+7GwODG9qefr5IzHZZ4GsQALmViQ8v+NC0?=
 =?us-ascii?Q?OS+W57NldSw1LwLQGBVKHsyb1kgRIAHarfZLkoYjgkQQCnsQEgD6iNqY7DI0?=
 =?us-ascii?Q?li5RuQvTDyM1RBmaqoXRK9XZ6JhFAtxU3bWLDKmROwi+ViX9fFKQiG5hHpPV?=
 =?us-ascii?Q?hUHu5eunAWc+p3rwOi0lr2mjcyjxsZH18qv16AJ/BSmsOQaRBN3rJW5aYzw3?=
 =?us-ascii?Q?SqA8mZmEy7be2ucIeQJH2d6B4MK7FIVcsXBy198KvwCdgPLHB0XOW2NriQAk?=
 =?us-ascii?Q?xNvKf1VuZpjpaGanqDWrYjNeRb867wP9f4E+q4rEw/iFkP96MgwYYueRsHN6?=
 =?us-ascii?Q?/Cy4EEYbwMj+U3YvilTNPZFZNuvBzuqKH1xlDtvu+8uNdK7m5kzHwPdpPWnQ?=
 =?us-ascii?Q?yBCdzz8gvz6ECevxkWWxixVnr3vNRQ7Y4i5RA5rAZdfB0ktGpexci/SsJi/I?=
 =?us-ascii?Q?w8YtfDlsR+Be072KYdIRm7u5BJXB57H9lao03neAHgRQNpWM4DqHxa5TZTAf?=
 =?us-ascii?Q?ExMiqF+YW6H/YaR1GOo/G8GMCoM/+H5Xb7O5gUbBlbXaWAxnnzSql2LBWBCg?=
 =?us-ascii?Q?sQKkTnz9liWRNQwtlHAVeD/MDqKi7u/Xk4I2bBdxHxKWupYYwMaaAEmBxH6t?=
 =?us-ascii?Q?uXf2nk8AC/3gHb/wMwu5gA9V3zsSSKclRm0fCzBs3+ZGWv1WQ7KDpOwint1c?=
 =?us-ascii?Q?kgAh1xCaDStV0uxnxmI/zpP3/8+gAfQAk0xSE7GV1ltEbGJdpDd7rt/oS54F?=
 =?us-ascii?Q?33JiM/8vywxw7bCvbkpZBUKXXnvjwCKSv5veYoPr?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4f19260-335e-4666-f656-08dc3ca50246
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2024 23:44:18.6106
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yXwbnKeB/z00hsHxiuDXM1Md7jtPVyC8VfSVt962RujoPM4oextrJE2GbbiSiuVe
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6584

Currently the smmu_domain->devices list is unused for SVA domains.
Fill it in with the SSID and master of every arm_smmu_set_pasid()
using the same logic as the RID attach.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 23 +++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 2db2b822292a87..6d15fe3a160acf 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2603,7 +2603,8 @@ to_smmu_domain_devices(struct iommu_domain *domain)
 	/* The domain can be NULL only when processing the first attach */
 	if (!domain)
 		return NULL;
-	if (domain->type & __IOMMU_DOMAIN_PAGING)
+	if ((domain->type & __IOMMU_DOMAIN_PAGING) ||
+	    domain->type == IOMMU_DOMAIN_SVA)
 		return to_smmu_domain(domain);
 	return NULL;
 }
@@ -2813,7 +2814,9 @@ int arm_smmu_set_pasid(struct arm_smmu_master *master,
 		       struct arm_smmu_domain *smmu_domain, ioasid_t pasid,
 		       const struct arm_smmu_cd *cd)
 {
+	struct attach_state state = {.ssid = pasid};
 	struct arm_smmu_cd *cdptr;
+	int ret;
 
 	if (!arm_smmu_is_s1_domain(iommu_get_domain_for_dev(master->dev)))
 		return -ENODEV;
@@ -2821,14 +2824,30 @@ int arm_smmu_set_pasid(struct arm_smmu_master *master,
 	cdptr = arm_smmu_get_cd_ptr(master, pasid);
 	if (!cdptr)
 		return -ENOMEM;
+
+	mutex_lock(&arm_smmu_asid_lock);
+	ret = arm_smmu_attach_prepare(master, &smmu_domain->domain, &state);
+	if (ret)
+		goto out_unlock;
+
 	arm_smmu_write_cd_entry(master, pasid, cdptr, cd);
-	return 0;
+
+	arm_smmu_attach_commit(master, &state);
+
+out_unlock:
+	mutex_unlock(&arm_smmu_asid_lock);
+	return ret;
 }
 
 void arm_smmu_remove_pasid(struct arm_smmu_master *master,
 			   struct arm_smmu_domain *smmu_domain, ioasid_t pasid)
 {
+	mutex_lock(&arm_smmu_asid_lock);
 	arm_smmu_clear_cd(master, pasid);
+	if (master->ats_enabled)
+		arm_smmu_atc_inv_master(master, pasid);
+	arm_smmu_remove_master_domain(master, &smmu_domain->domain, pasid);
+	mutex_unlock(&arm_smmu_asid_lock);
 }
 
 static int arm_smmu_attach_dev_ste(struct iommu_domain *domain,
-- 
2.43.2

