Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2085.outbound.protection.outlook.com [40.107.243.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 228EC14BFBF;
	Tue, 25 Jun 2024 12:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719319081; cv=fail; b=dhgdevnKrI98cw86F6OmdCRhP58tppahr090+XW2wdEYsLiHDF9My5IEaMkUHNnuvIGHxx/5TfeGd8/C62SXE+Vvw/A0rei/Aa98+ryIEC1aC4dv31V01WeZSI3T2ClR0PN1dda0ULvElQ4/+r6fS10ZPMe5op6tTLZdN8Er4Ro=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719319081; c=relaxed/simple;
	bh=LzgdvCqwveABusmBPqJY3b0tX9XdUMK7F8xy/TVYm+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BPgZmHXPR4LRRpqTSstPYPVdQNdIOfnA8IqxAd8zk66IP/Rs2yrYZ2NTeem/9ckOCVo/OnGfVrlMm1JUS5zcdGOay9cZnLlQBWUXto0cSQ+Gf6KGDHwuXADPBgm/4DFgHUShGVYve2X4a2KvJB28CD7FVJoUs5yLhO0V3NOMnz0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BPFGdFPt; arc=fail smtp.client-ip=40.107.243.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BPFGdFPt"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eVdcUKYE1LHGgKUpeqk6O60z1zCiEQUCbOYSzabRzrwslRUQekwMyxDRbU3MjUJQ5Hw/1wTx0OkjYMG7XkHxm5Q/Y41S/WwsneUC9LvYT6zba24g7CUDfBVGpYpEq3DlvLVyDR+Cp2mLgvuz2dU00oWdHgf3f6iZQDG1n/9gU0f0Y+nT/n2m4aocKzKgqnTmoMSWLJVZo+5ZeyUirSO8UaW6qxTDnztlq5nX59XCqj03XF5MqTZ8v5M7tXyPnEbQ8ie8rTU3nX3qFQGFthM2ZAQFwYphIRWm4P7F2nGQX8Ieq8LcKRotum6KaLedYWn+doHJTehWmeDSo9ASbu29Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+X3WjW4RXlZV8/opPZ85LBFlYMENPROAjYdO236yOBE=;
 b=NeFKEZrAAprlW37EBrDpNShDZaTuhUeR/SLiXWVYEwIfLDQ/mzowUI4nE8CgOSBksauyAt/8fAXUEERSMm4i7TvSzEmrPyvU8jo0efCN99dQ2pBnD4sbHC+nZ4NGBu3fVrhrOLIEjoNJI7uZOgGV2xCfztouy9ttYCusIngV2WVSTCxCTmlFVCQYc40vAwe3srJrLYnigJe0umNW/wGRdoVumN6zb2vbJ+hMPMKbRtTR0EgI9ERt/tW3jrOTQO1fMnEhtPkUxxfFLF/1WMfz+gfrUQuwVkVPDazEzAMUepDbUT+0P9fM33d3jWNY6m6m1AqEz5R/wuKBlB4htLOl1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+X3WjW4RXlZV8/opPZ85LBFlYMENPROAjYdO236yOBE=;
 b=BPFGdFPtPtuYKPPDBbG0nA0Z9CGX/uv6QVR7G4+laHdUGi/HEeryh+Z2DOhu0pY8iMyApXtSEmXFH0iZ0MDXaLWAtTLAFwRqVrIlHyf5IbEnA+LFhENi8OfkPtuEUkhOG053P6z9KWAMxYFmxqRjfIlIwSyuA/yQ6mWhHy84D4Jh2xdbIeBQvWvs4GYMIXCcY7JNINSsbOtBThOZDlvtXiBCimWuAySPAUMk5mycrEzta4Y/3KRWSbHd1R2+wQlt55Y4+qnzYCY6oPXH5r6VCYGNnVBBbZQ1yZ7IMENgfQhd0jlHEJPFKi6QLnRh5MpCujPf4N1XFT6VpFobz5L/5w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by SA1PR12MB8946.namprd12.prod.outlook.com (2603:10b6:806:375::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.26; Tue, 25 Jun
 2024 12:37:48 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%6]) with mapi id 15.20.7698.025; Tue, 25 Jun 2024
 12:37:48 +0000
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
Subject: [PATCH v9 13/14] iommu/arm-smmu-v3: Allow a PASID to be set when RID is IDENTITY/BLOCKED
Date: Tue, 25 Jun 2024 09:37:44 -0300
Message-ID: <13-v9-5cd718286059+79186-smmuv3_newapi_p2b_jgg@nvidia.com>
In-Reply-To: <0-v9-5cd718286059+79186-smmuv3_newapi_p2b_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR08CA0028.namprd08.prod.outlook.com
 (2603:10b6:208:239::33) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|SA1PR12MB8946:EE_
X-MS-Office365-Filtering-Correlation-Id: b63a69bd-13e2-4eb6-6d7b-08dc95139dfc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|7416011|366013|1800799021|376011;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vjMXXi4tYI7sQIF+0+gGkE4Jbdo3iAqQ+8d4BTwpcVf9lO3UIZGGiM6nAT9x?=
 =?us-ascii?Q?m9CnrNnpCGelRHkNCZUB6BUSC2pwT4ocKOxki3TkYWxsxS/psqgFCETzuYXG?=
 =?us-ascii?Q?GSpf1ph2q9H8pFEGHY3OzLWypJ/+w0HbpfAFY7htpOBvdm66VCxNnzwoB3Ru?=
 =?us-ascii?Q?JIl9uWCtxfmfwufBQ0QF10/LjZVLYPNcTJWLmv272W1Ei173ve2/o2y2aIp2?=
 =?us-ascii?Q?sF72mAJ5sZp1nytHIr6rRaUFxqmVwYHe+yKEUhZ0hPotGzqwTYzuzIpJrFa/?=
 =?us-ascii?Q?35JB+cpLcGVz7/8qYjia/uwFA49lTYp8HSEn9XBxQemA/lDtX1XLZ8FjPkUu?=
 =?us-ascii?Q?jNWjXAsZNi/I+ZNEt2eSIqdi/zkqGPk58HwZPXhmCLmdrXQiXtAfVsV6NRpm?=
 =?us-ascii?Q?X5ZkQd9F4BosExXAIs5uct0nM8r4A4DmV20R9V6yKJhApxosuw6whPsM/IK1?=
 =?us-ascii?Q?OpDDr82z1+Mh9aJ5rxy2k7p2skR7FasKYG9GPDvtLkB4wnMOgnaOcc8dDYYg?=
 =?us-ascii?Q?De3TD5r9ill8EfYQtAMJSisqSeM+Y5tAT2YylvP9tI3oiRNz0ni64EBc75Lr?=
 =?us-ascii?Q?Tq0Xe7YFsn/0Z5a2sZVxVq/xYC9E4LcHF+FaPuDK/V2sJWmwAKYbjV6AUKPx?=
 =?us-ascii?Q?sszGadzP7mHHPK+HW6HKyEOtTEzpXwl4A6a5stHQT/fwP1IAJN/YoCTC7xlE?=
 =?us-ascii?Q?q2YrNC50R6McumB5RTXbNveHgOZ8gU5qgeMtH0k33gLSiIDNeqGAKabG3mjx?=
 =?us-ascii?Q?JfDX5XMCgzdjg5Cm3JfQiIxcwla82in7xCoa3O3lmpSoouefFuCDMR8/67oA?=
 =?us-ascii?Q?UzyacFA2RVZlGDckXl0aUZzeOmP0KU1E16MqNGBiq8Nd6P6NaQNs1eZQWsm5?=
 =?us-ascii?Q?/idRW5yRRBaTDQPRUwBEvLg5TDbSvHuxil6ihsJO8NV9DU1jENFI+xfh8zXp?=
 =?us-ascii?Q?gzjbWaDol8dHHd5KeG56qDMTeOaugCWHlMR/yIP/vHyFZbd5KLeMEM2o1yCU?=
 =?us-ascii?Q?eQiw0dXVtqiAUY9BRTj2qT4ffbdx5/NRZWCmunOhWiHJwzrTkrrUkVYo0kD5?=
 =?us-ascii?Q?BIypfsi2iCj0KO1/R+7oYPAXvzGn4pI9xHbhn5pKLg4S7dEAXykO2CMcf9CH?=
 =?us-ascii?Q?mgB3WYiJmoGtQpv5gfb6AUFGKENFpuUCfcHMoS07AdtMe0sxPDQcjD9Rh1sX?=
 =?us-ascii?Q?08Lwfkygt8f//MSKxMLAtpgTnv8CuoydblRSwZM+rJdET3YWMawSa1oFAKCS?=
 =?us-ascii?Q?WdqjkohzxAvV8KekbjzQyhwMyWshA0xCCGS31JbvpJNyMfIWxXA0W93IyDXQ?=
 =?us-ascii?Q?mTk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(7416011)(366013)(1800799021)(376011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Da4q/hgr/7f4QzJNfjN0yZDD+qTbw2U3VXuIUREwh7BzjsT+FiqWIyhEJJMQ?=
 =?us-ascii?Q?ykTSImvSu3g+8qqYreRiuYvSwKidHtMp9vps5M84LtquedkfUBpY2FyMjuie?=
 =?us-ascii?Q?b7KouPQRra1nRWvHNJT8fCktmcPSGbx/UbJJUDJzaj7F1kIJokfAWYGAmkFc?=
 =?us-ascii?Q?B6o/rbIk7q3vq6QF+4rRDVnIsuLm1gastS1G+frZcmkGWVEnwfMu9d+FPy9w?=
 =?us-ascii?Q?cXwzAxwHoKxN3cotY/tzqgQVfHzLbyOZYczMTLES8Z2hkJm9HaElc28f41Hq?=
 =?us-ascii?Q?FpmSWSiQdrX/8YSoon6jCzjn36ug3do84fKh4iEDXy236Dz1PjUe+62nsmlw?=
 =?us-ascii?Q?ein9P4iGmdMcK2CkEcUkekvl4+wUgtIBzyq1wQU8jk8oY6libxAqOEp2YMT6?=
 =?us-ascii?Q?sPMftApbJxsdIs6Ui3gVGuIzurF5q+QUdwPYra9+cX8x68sajywv0+/GW8Nw?=
 =?us-ascii?Q?CofTXMuTMJYglxKr/C4pb6pUxt8Qs6K/+tLBHTJJhMXIi5brkbeIsjvAxeI/?=
 =?us-ascii?Q?2NpuatysfpNKD+Yy7SYH3doU/I9GfSGoJmyuoYeJ6EBfsbwHU+tzb0asBbGC?=
 =?us-ascii?Q?SDmpHZd9DS8lloIkT8UwBPI87zj9yiL3uglfL5PvvkS9rFUJIJ51nxzE5CFG?=
 =?us-ascii?Q?O5YjgKWWJjLLQFo/61hY2CdrSihD1q4ELzBDM1wqNenaUOXGuBPwri0HwNzy?=
 =?us-ascii?Q?cWHPw55hL7ncWmOQYo/UuReRT3KwNh0P6uewvLFj4d7tqJ1QVeYLQ9QQfnC4?=
 =?us-ascii?Q?5B9fpMgfYdm2IOSIflYRTw9sUhrABJIHkoFRbJyujnC2aBQ1yAGepOn+v24T?=
 =?us-ascii?Q?bnvw4lTWc8tIx+vG/8Sxi8+hWaSJuC/S10Q8TEioyM3SGeABC1l60IEqiUGW?=
 =?us-ascii?Q?4dgO4tEvkIVwI2FJU+nNtvGNvqpkbObpk7BEBBF6H/lUA3QtX300WBeKiQAw?=
 =?us-ascii?Q?I51m9HI9Cqhf+iRpwsrgZMm0wAz+Z/mzsXrpR/YeLW5ScUVnjYum2gQ7HKs/?=
 =?us-ascii?Q?4drN6EYSoOeUMeZe3cEoRiK2kwo9ITepLc1onnrDfulYH+YTwPe9slUYaFQI?=
 =?us-ascii?Q?lY+BxXH5MkNxbR0hr2VKZgZ1lwd3mtjFeUoQ6R0IpNUG7k9T3lrgMf7UsJW7?=
 =?us-ascii?Q?ltMGKerwW3gV1rv+TyWnAtH0ea3q+OUYcS42vr30smBj7LLwjNW2Xd2fShl7?=
 =?us-ascii?Q?TOV9pJ908vJvE8Rbv4kWSNuY4BaVUkxAAxxdtxwGyJnRwZyfcGFeRS7jlwRz?=
 =?us-ascii?Q?1bo7EiZRvtNywoYUsMG8Xj5Sabx6KL9D0834SisEIsHv8DPyclxi511et37M?=
 =?us-ascii?Q?auw77HbHi9WbLPOFRmBPgYQs7JIrBZA9i+eJoj4TXaHClxtWsgggJ7R+JPvz?=
 =?us-ascii?Q?h0fSwbcmQ1vMHgpP9WJn8IBrrPDEoMCCatPKAwVpGbF8vL4Io4d//Oft+1if?=
 =?us-ascii?Q?SZUZ5fVazwRnETbjJBTRT7gvOXE3U+zN7bzIw6evxFKtpPm63N71g/1tCYm3?=
 =?us-ascii?Q?o4GXlc2SYdxgaG9gzCxTurGgQbXjs92/Qa6aAa96iT+GmNat0tMqCV+csJD1?=
 =?us-ascii?Q?sBmFkG9grqrsGXCwFxwosY1lBbH/w1JKAd0Xxf2R?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b63a69bd-13e2-4eb6-6d7b-08dc95139dfc
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2024 12:37:46.8234
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7h33LbJiNQdF3HX5RxMH78+hPKe12EHjW04r+fN6jMO5Z3cdhYbVamhj6tSO1yjl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8946

If the STE doesn't point to the CD table we can upgrade it by
reprogramming the STE with the appropriate S1DSS. We may also need to turn
on ATS at the same time.

Keep track if the installed STE is pointing at the cd_table and the ATS
state to trigger this path.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 49 ++++++++++++++++++++-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  3 +-
 2 files changed, 49 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 10d140a5cd0f38..fbe14466f5f379 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2435,6 +2435,9 @@ static void arm_smmu_install_ste_for_dev(struct arm_smmu_master *master,
 	master->cd_table.in_ste =
 		FIELD_GET(STRTAB_STE_0_CFG, le64_to_cpu(target->data[0])) ==
 		STRTAB_STE_0_CFG_S1_TRANS;
+	master->ste_ats_enabled =
+		FIELD_GET(STRTAB_STE_1_EATS, le64_to_cpu(target->data[1])) ==
+		STRTAB_STE_1_EATS_TRANS;
 
 	for (i = 0; i < master->num_streams; ++i) {
 		u32 sid = master->streams[i].id;
@@ -2795,10 +2798,36 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	return 0;
 }
 
+static void arm_smmu_update_ste(struct arm_smmu_master *master,
+				struct iommu_domain *sid_domain,
+				bool ats_enabled)
+{
+	unsigned int s1dss = STRTAB_STE_1_S1DSS_TERMINATE;
+	struct arm_smmu_ste ste;
+
+	if (master->cd_table.in_ste && master->ste_ats_enabled == ats_enabled)
+		return;
+
+	if (sid_domain->type == IOMMU_DOMAIN_IDENTITY)
+		s1dss = STRTAB_STE_1_S1DSS_BYPASS;
+	else
+		WARN_ON(sid_domain->type != IOMMU_DOMAIN_BLOCKED);
+
+	/*
+	 * Change the STE into a cdtable one with SID IDENTITY/BLOCKED behavior
+	 * using s1dss if necessary. If the cd_table is already installed then
+	 * the S1DSS is correct and this will just update the EATS. Otherwise it
+	 * installs the entire thing. This will be hitless.
+	 */
+	arm_smmu_make_cdtable_ste(&ste, master, ats_enabled, s1dss);
+	arm_smmu_install_ste_for_dev(master, &ste);
+}
+
 int arm_smmu_set_pasid(struct arm_smmu_master *master,
 		       struct arm_smmu_domain *smmu_domain, ioasid_t pasid,
 		       const struct arm_smmu_cd *cd)
 {
+	struct iommu_domain *sid_domain = iommu_get_domain_for_dev(master->dev);
 	struct arm_smmu_attach_state state = {
 		.master = master,
 		/*
@@ -2815,8 +2844,10 @@ int arm_smmu_set_pasid(struct arm_smmu_master *master,
 	if (smmu_domain->smmu != master->smmu)
 		return -EINVAL;
 
-	if (!master->cd_table.in_ste)
-		return -ENODEV;
+	if (!master->cd_table.in_ste &&
+	    sid_domain->type != IOMMU_DOMAIN_IDENTITY &&
+	    sid_domain->type != IOMMU_DOMAIN_BLOCKED)
+		return -EINVAL;
 
 	cdptr = arm_smmu_alloc_cd_ptr(master, pasid);
 	if (!cdptr)
@@ -2828,6 +2859,7 @@ int arm_smmu_set_pasid(struct arm_smmu_master *master,
 		goto out_unlock;
 
 	arm_smmu_write_cd_entry(master, pasid, cdptr, cd);
+	arm_smmu_update_ste(master, sid_domain, state.ats_enabled);
 
 	arm_smmu_attach_commit(&state);
 
@@ -2850,6 +2882,19 @@ static void arm_smmu_remove_dev_pasid(struct device *dev, ioasid_t pasid,
 		arm_smmu_atc_inv_master(master, pasid);
 	arm_smmu_remove_master_domain(master, &smmu_domain->domain, pasid);
 	mutex_unlock(&arm_smmu_asid_lock);
+
+	/*
+	 * When the last user of the CD table goes away downgrade the STE back
+	 * to a non-cd_table one.
+	 */
+	if (!arm_smmu_ssids_in_use(&master->cd_table)) {
+		struct iommu_domain *sid_domain =
+			iommu_get_domain_for_dev(master->dev);
+
+		if (sid_domain->type == IOMMU_DOMAIN_IDENTITY ||
+		    sid_domain->type == IOMMU_DOMAIN_BLOCKED)
+			sid_domain->ops->attach_dev(sid_domain, dev);
+	}
 }
 
 static void arm_smmu_attach_dev_ste(struct iommu_domain *domain,
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 30459a800c7b2d..cdd426efb384d2 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -705,7 +705,8 @@ struct arm_smmu_master {
 	/* Locked by the iommu core using the group mutex */
 	struct arm_smmu_ctx_desc_cfg	cd_table;
 	unsigned int			num_streams;
-	bool				ats_enabled;
+	bool				ats_enabled : 1;
+	bool				ste_ats_enabled : 1;
 	bool				stall_enabled;
 	bool				sva_enabled;
 	bool				iopf_enabled;
-- 
2.45.2

