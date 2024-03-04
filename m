Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2043.outbound.protection.outlook.com [40.107.94.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ABE77E0FB;
	Mon,  4 Mar 2024 23:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709595876; cv=fail; b=dUSw60+KuycvsvYexdaVQ8P5VHPit1Es++Ua+ZbhMrZa0Zb02Dp0lt5frzeqDE69ZNGuwGSIjMp58+nB1x/p77pUrdwRxfXEuz51kv1ynEzG7L4tGQC1UAGCN2CNWOa+vTkNoWWSjjACtMIyT295Awo//xErj8l/QReRQf3ehfY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709595876; c=relaxed/simple;
	bh=QikF7oyVEHAKSLjIO0f27WYj+Pu+5r4WD0G0V5i145s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hYfmU5ZcrZW1ras2L5bwNCq0sDcoBvAoUbgPxlh5mjDagpyh+SHhMBNa6c6w9yC+mQK1VCywRUGjoB7/qKvXMLgWkybOnhk91lZwmP/tC4YloyhK/CnUYcRB2rirJQ0iQIY5BeSazUtHUB/f38f3VJRbAV/9d8DwwLUYGT4d9LY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=E+AAhfk8; arc=fail smtp.client-ip=40.107.94.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="E+AAhfk8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X2e693pV3HBWp+vmH3vExyDUgMlkhJCuxBeOJzf/uANM3zFpPRnRF5swY5z/M1nx9cZ2PkKMLdNdMWcMF6gzhfpiTKlYURH40iKwh84ffuOoG4zxUm8c4+o8zU5bkb+KOZOVW+GWpYZBhw2K3VAK2cpZU1r6KKd3JEcvda4vpUPRYHYBDc0kEQyKZIn9Y6Qg4dB2bP6JTPx7Qy8AkTs/jpWxsPgGGBnLsl0vUG+ncO34f0rNKzTw4OJIOJB7ummMZXTvgYcCyDB5Vg+IpIg3JWIGnz/6J+sqR+M82OT6XYWWZ8RDdHa6XKib0EXOoecRjwARdV0LLMsEzyqyw53/EA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qa8mXWX8hmnXz9ypuGLj01PRBuGZ4u4hEq+IQOpCPAc=;
 b=BXyAhmv+2NMq4ER/HuC7Dvzhajc+h4XVbOSLnwEsRrxLKas+SqmViojToN1nchecqKEXprXGBWu8T83l6+N0N+ydavxYqi309PMGtSCGhi6BVGUcqi9C1agnpQy+qsjYrsuxhckFkfvUKqU6+y0AKSpDWp0avKnPguzWimZpKd/7ykHLom7nmkxim0rUd07MsTVwF4u6jMx8psrAlXFMV8Fj7X8AbRm5aMCR8F7JBlQlMPSnLXjieWIEbNRd2HqizshMBdlamBNLNb79iXL05OwQBqqvRMWEq22PT4BJDiMK2ekqf7VPvAFNMqknIlXK40Ij9BSfGsw+8/GZIwgxQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qa8mXWX8hmnXz9ypuGLj01PRBuGZ4u4hEq+IQOpCPAc=;
 b=E+AAhfk8EQTO9Wzi8fwL4i2/5r5hqtoc1OzyZgd04sZP0/8t/6d7PuiO+z+MaUnmwoUc/oNMizJSSIKATofjxHNN/XDtlQVo9k4U+IQtak84PQ0koI8eZJuk0hWtH2zx6/U/of1hq68Bny0NzQ2sZCdL2YoKR/PgXk6eoGbU4Q/jb/hQieXFcUu/tbEu+FPyIC71Zl3GUzRC/ckNf4YCkMOcyNqaPbPeQ4jL4rClWaKndLe9yQVfqMC013ZR+CAJGWui1sXMmrQl35fMwDVkjxWJYT1uwp6IRhOOkpqTWQOnkI4nB4lwID+KDfYeH1MdGhuiEKqnI75PlrTra3/C1g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by MW6PR12MB8949.namprd12.prod.outlook.com (2603:10b6:303:248::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.38; Mon, 4 Mar
 2024 23:44:22 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c33c:18db:c570:33b3]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c33c:18db:c570:33b3%5]) with mapi id 15.20.7339.035; Mon, 4 Mar 2024
 23:44:22 +0000
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
Subject: [PATCH v5 12/27] iommu/arm-smmu-v3: Start building a generic PASID layer
Date: Mon,  4 Mar 2024 19:44:00 -0400
Message-ID: <12-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR12CA0018.namprd12.prod.outlook.com
 (2603:10b6:208:a8::31) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|MW6PR12MB8949:EE_
X-MS-Office365-Filtering-Correlation-Id: ea3135e5-6b63-4bd3-f8e4-08dc3ca5014f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	LPJ0xAZOKj8cBoxlk5DebfTNqDnhti7f581AGg2J5Vixt/b1Qmr1J1oYCheqwor0Zq9wf++1mI5a1USW36D1To3WleC1Z9sXQzb5t2XGjceoTiLTrwvFl7ZVP+VEpB5uXmgn/ck6UL34F2RKRBWiBHoExx6rAz+INGUNjb1MJPSJn9TGocvmwSIWHbZil2r+8/s8maycPhI6sxFk68BoBhMAXR/viFk+VsGOl2GO2PUDhgVnFd5oAYjT1by77u3GvjRQueSg7TKWzxHSlQ7qGawvMpuR68ni/Jt4IY8cZ8Ic72yEKKQ5ZeJWC0ITXIC2rRhZrhHvuNp4KeYWUYRjrTqQhARC1Tfw4eonPNeCeUraXVoKLBEw8AWXNkMVxrGb3T3DmIHLnawI+n3cHz9RzgSFQ/xvBMcL1m7tU1+sbmD3o2UPnaQMl38Fe6uEsnUV8PlSv4iNV3Tz/nCZubRQZoIPC24dDudKHE8E4gpymlt3TTaz2d3bRqD6HNOMQVbNpAOFi15HafvVzCDmfMcmUmsD5SbXOPAgm3++wyXZfXZBz1UTZXXxxU7vWhyxwttQUyRwfjsQp3p7pkFKlCibDOYXoOqb5iXfiBve8KgZywdwCYT/M80JQ+sF/V/LwRcMypsEGZM9lj/lRa8qH6y6Vx8tDMj/ffkI4p1doNtLQvc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?c7ritClFodtROkR1VrF6ozTcNAYd9g/qR+BpmWv9MVu3Q85Uo42vvBdH1iGV?=
 =?us-ascii?Q?S53KCVQAPIpSGjaKGTdilEOjLiaB+1cV2nXCrcXgaifkPwC7vhOlS/SO5BM8?=
 =?us-ascii?Q?A+UGFXof5J4pDUZKdrhvQUxZJIWjDWiSSi/3ZsRQb8MWwY5f9mknCaSx2EbX?=
 =?us-ascii?Q?eEWzhmtabnZ7+iFz3ay4Ec1zpwFodfT+1aYApuHnj8cM5vNUdop7LQsVGCVT?=
 =?us-ascii?Q?61RmbYhMhpWMg+3GhZ0c5Vjz3VlKQd/07y0W66sqWeX1bYguLjNR1qK6M3JT?=
 =?us-ascii?Q?/p5KQQzFGeJE+JpYABrEb3KNLr+08TGRDaoneLZlhPk88wbWvr2QJye4pV8V?=
 =?us-ascii?Q?wbY/wIvNNoXJiWeLwz1cdJBrDopCXE3M50PB64vrQAtNnjuW8vSVPceig70L?=
 =?us-ascii?Q?MwvA8U2nwp7dOUR2oTE8YZVEOHMBUphiWpcWuJbzYHNeN/rCdV7hz9HWdTif?=
 =?us-ascii?Q?H19xOIhlnZlPcM5uyMl69ozwLEokisaOIvHt05su6SNH2/Ziq0bOBZWWVe9m?=
 =?us-ascii?Q?NeoH3ndiXiXIIHomH6azpo2uEv0mKBkQj5/uIqHkLL8kt+7cRRW7FvrxMvA5?=
 =?us-ascii?Q?qPJb8k5gXmEjYGZ/3lf2+8ogblAZrXPtI9x671e7zktZ3VSQgjGVFYe80f2S?=
 =?us-ascii?Q?L2CqQQRvWWTH5KdnGRlA3mg1b2rgQiiLG33bBBmL5vzKrxjaYCXzJvrW+C3T?=
 =?us-ascii?Q?MynqebV5hzfzdAk7yTANMFcqoLCj53VJkYiPtmAfvBRbTwPM4zkQvZ+sU+5S?=
 =?us-ascii?Q?nra1NRRGl31RG04SDAFgoP6mnLi3r8fp6mdxr6d8iLos7ujaXeTHAeaxdHpP?=
 =?us-ascii?Q?FILAEVPGbOzLiHDOObLb7BBk7aErlYbLyEUfhtmiuhAPTQ1y48w5Vs5Wwnjf?=
 =?us-ascii?Q?CThnpb/bcxTvzbfj8fV26nkb/8pXQOlCJfI7y4JDaxDWjQ3zGDsFhppKk5OI?=
 =?us-ascii?Q?2onc8muIg65OH3KxwI7YDumagZiIZItuiKJtdaiv11NEemhcaHql9m3rn4pv?=
 =?us-ascii?Q?9cTw3XyW4ymURZz5bHb6nUgS+GaNfUwqmOQCKMlquhDNvgG2VRMhSNkwqmGH?=
 =?us-ascii?Q?jNsGbB8AVF5H12wsaNjBd66NPaK30IZWMhQXskEKIzKlr7VaYkOLulKB6pPu?=
 =?us-ascii?Q?T1nTE1d3llYGYJ09C6hoiFMbxOkDQIAOer/om8PDeqUoWBJBYdG0O+D96Yid?=
 =?us-ascii?Q?UYmnf4Ym4Xl6uYjqliSFhrv3VsvR++P6ZU3hbfxBVHeiwQQcOEp2BobwbMub?=
 =?us-ascii?Q?9HrnMQpeKX+MxnO2LK+z0KjFOVwZFypm5S8YgXFgdWV3arTmaibfAM+4VeTb?=
 =?us-ascii?Q?I41Sn30Lnp2vNoGrjQ1IP2lnJYcFk2SJjELY07fXqh5A3v8w4/9GNI3EPWg7?=
 =?us-ascii?Q?2Iqldk4N8o+Fn0WhpsMWAqLR1GJYoLeJ9RLUu0qrrNYLUMzf17ekPsacKBnA?=
 =?us-ascii?Q?yfz+UI/I97xtK7oOLOKs1W52Ev1sxFMqM/+QVqeSsS7wNwL5LAENeAceJerL?=
 =?us-ascii?Q?VzKe25J/Qb4IcU2//00RuT6VLv3FhM12v4x4cUqG1PRnfncbe3QvmgJvC9c6?=
 =?us-ascii?Q?QMFjbKtSHBB/YJaadx1TpSqjvhQKDixCfZsXM6r5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea3135e5-6b63-4bd3-f8e4-08dc3ca5014f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2024 23:44:16.9909
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YfVYTwnudVoXkkLTuKvLuLXedcH1Ohxw1GK7TJLrrHKiOK8L7iBkCwDGYt0ifdjB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8949

Add arm_smmu_set_pasid()/arm_smmu_remove_pasid() which are to be used by
callers that already constructed the arm_smmu_cd they wish to program.

These functions will encapsulate the shared logic to setup a CD entry that
will be shared by SVA and S1 domain cases.

Prior fixes had already moved this logic most up into
__arm_smmu_sva_bind(), move it to it's final home.

This does not yet relieve the SVA restrictions:
 - The RID domain is a S1 domain
 - The programmed PASID is the mm_get_enqcmd_pasid()
 - Nothing changes while SVA is running (sva_enable)

Also, SVA invalidation will still iterate over the S1 domain's master
list.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 39 +++++++++----------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 29 ++++++++++++++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  6 +++
 3 files changed, 53 insertions(+), 21 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 159350a78d4cf9..e1fa2074c0b37b 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -416,12 +416,10 @@ static void arm_smmu_mmu_notifier_put(struct arm_smmu_mmu_notifier *smmu_mn)
 	arm_smmu_free_shared_cd(cd);
 }
 
-static int __arm_smmu_sva_bind(struct device *dev, ioasid_t pasid,
-			       struct mm_struct *mm)
+static int __arm_smmu_sva_bind(struct device *dev, struct mm_struct *mm,
+			       struct arm_smmu_cd *target)
 {
 	int ret;
-	struct arm_smmu_cd target;
-	struct arm_smmu_cd *cdptr;
 	struct arm_smmu_bond *bond;
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
 	struct iommu_domain *domain = iommu_get_domain_for_dev(dev);
@@ -448,19 +446,10 @@ static int __arm_smmu_sva_bind(struct device *dev, ioasid_t pasid,
 		goto err_free_bond;
 	}
 
-	cdptr = arm_smmu_get_cd_ptr(master, mm_get_enqcmd_pasid(mm));
-	if (!cdptr) {
-		ret = -ENOMEM;
-		goto err_put_notifier;
-	}
-	arm_smmu_make_sva_cd(&target, master, mm, bond->smmu_mn->cd->asid);
-	arm_smmu_write_cd_entry(master, pasid, cdptr, &target);
-
+	arm_smmu_make_sva_cd(target, master, mm, bond->smmu_mn->cd->asid);
 	list_add(&bond->list, &master->bonds);
 	return 0;
 
-err_put_notifier:
-	arm_smmu_mmu_notifier_put(bond->smmu_mn);
 err_free_bond:
 	kfree(bond);
 	return ret;
@@ -621,10 +610,9 @@ void arm_smmu_sva_remove_dev_pasid(struct iommu_domain *domain,
 	struct arm_smmu_bond *bond = NULL, *t;
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
 
+	arm_smmu_remove_pasid(master, to_smmu_domain(domain), id);
+
 	mutex_lock(&sva_lock);
-
-	arm_smmu_clear_cd(master, id);
-
 	list_for_each_entry(t, &master->bonds, list) {
 		if (t->mm == mm) {
 			bond = t;
@@ -643,17 +631,26 @@ void arm_smmu_sva_remove_dev_pasid(struct iommu_domain *domain,
 static int arm_smmu_sva_set_dev_pasid(struct iommu_domain *domain,
 				      struct device *dev, ioasid_t id)
 {
+	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
 	int ret = 0;
 	struct mm_struct *mm = domain->mm;
+	struct arm_smmu_cd target;
 
 	if (mm_get_enqcmd_pasid(mm) != id)
 		return -EINVAL;
 
-	mutex_lock(&sva_lock);
-	ret = __arm_smmu_sva_bind(dev, id, mm);
-	mutex_unlock(&sva_lock);
+	if (!arm_smmu_get_cd_ptr(master, id))
+		return -ENOMEM;
 
-	return ret;
+	mutex_lock(&sva_lock);
+	ret = __arm_smmu_sva_bind(dev, mm, &target);
+	mutex_unlock(&sva_lock);
+	if (ret)
+		return ret;
+
+	/* This cannot fail since we preallocated the cdptr */
+	arm_smmu_set_pasid(master, to_smmu_domain(domain), id, &target);
+	return 0;
 }
 
 static void arm_smmu_sva_domain_free(struct iommu_domain *domain)
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index dfdd48cf217c4e..7a0be7dd719793 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2656,6 +2656,35 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	return 0;
 }
 
+static bool arm_smmu_is_s1_domain(struct iommu_domain *domain)
+{
+	if (!domain || !(domain->type & __IOMMU_DOMAIN_PAGING))
+		return false;
+	return to_smmu_domain(domain)->stage == ARM_SMMU_DOMAIN_S1;
+}
+
+int arm_smmu_set_pasid(struct arm_smmu_master *master,
+		       struct arm_smmu_domain *smmu_domain, ioasid_t pasid,
+		       const struct arm_smmu_cd *cd)
+{
+	struct arm_smmu_cd *cdptr;
+
+	if (!arm_smmu_is_s1_domain(iommu_get_domain_for_dev(master->dev)))
+		return -ENODEV;
+
+	cdptr = arm_smmu_get_cd_ptr(master, pasid);
+	if (!cdptr)
+		return -ENOMEM;
+	arm_smmu_write_cd_entry(master, pasid, cdptr, cd);
+	return 0;
+}
+
+void arm_smmu_remove_pasid(struct arm_smmu_master *master,
+			   struct arm_smmu_domain *smmu_domain, ioasid_t pasid)
+{
+	arm_smmu_clear_cd(master, pasid);
+}
+
 static int arm_smmu_attach_dev_ste(struct device *dev,
 				   struct arm_smmu_ste *ste)
 {
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 468cd33b80ac35..ab0a6587e07ec8 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -753,6 +753,12 @@ void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
 			     struct arm_smmu_cd *cdptr,
 			     const struct arm_smmu_cd *target);
 
+int arm_smmu_set_pasid(struct arm_smmu_master *master,
+		       struct arm_smmu_domain *smmu_domain, ioasid_t pasid,
+		       const struct arm_smmu_cd *cd);
+void arm_smmu_remove_pasid(struct arm_smmu_master *master,
+			   struct arm_smmu_domain *smmu_domain, ioasid_t pasid);
+
 void arm_smmu_tlb_inv_asid(struct arm_smmu_device *smmu, u16 asid);
 void arm_smmu_tlb_inv_range_asid(unsigned long iova, size_t size, int asid,
 				 size_t granule, bool leaf,
-- 
2.43.2

