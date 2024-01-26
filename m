Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2073.outbound.protection.outlook.com [40.107.93.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83A82208D9;
	Fri, 26 Jan 2024 18:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706292950; cv=fail; b=XzcfvOMS/9WgxuC5paQ5mnDv7LJt+Fqi8WvAcA84I5wQ2sY3JQucFPzR/OrOKMJMFNOvevaIjFBluL3tdE08D/AGYUId3SVF8MXoJeJ4ca1G4+ZDT2becXHOS9THdvT52eekSd0HUyRlnj37nsU/VW7maiHu8hy4XnntkdYAuZQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706292950; c=relaxed/simple;
	bh=HM/wz9FfoVQlU77nss88NmcYPqFV6RETZN32wt5eNw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=g+F8XoLRBMe8k7ACDlmKwBV5Vc7Xkbv53nKNoQhOHF9A7C0T4Fe0cAe+R0KgcSlxw5YKI1bGHIccckb+YxWBa3qgDer/mP+5j72id6SqI8K1w9i5ErGlk4o/w2J/gK5OfGM98w/ZbVCVxJF4RkKwagoNUfMw8bSoTyc/+0eeRS8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Zd3ltFGa; arc=fail smtp.client-ip=40.107.93.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Zd3ltFGa"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RuFwmBn2n8zXVmWgvKNJ52CH+SCSkrSr5ileNVPqRrTFeMSOG57OLg29NMGOJH6t7E1NyAHgUUnuEgP5bP87qwNrzoH63O6S4ZrQK2pY2Ixb8o0+30ECjx7ulqTLqKgih44pzfJDSJ4M7oqI9EzohqAkxkGCAuzZiAiJtYc1Y7aLiaei/kxE+4xI0h/MOg64GwYW/pTtqSTvFjxyPbxvH9Eutw7N+xeBkgw4IqbWS0l1NBRkYxj/B1haXPBF0wR371DUz/gx9uaaCtpGS8tppjIYfut4xDXhb3pKWmGpBljwnb4CdPecsL1RteXnLQZV9h7ODME8r9xu2EFAvRm2JQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OjupnVJ2T0we0nVfAmgNqoQcbNhw/8HuxqhGeas1gDk=;
 b=BYQc8OQFkHH3f1dsDtwNokpcCS+UAROSzk/9fjdQQcopVW2gAv3TuUmTq8bK2l7Sh+BRp4pYUKOMN08uiS4hDshXJCuIP7yEv9dt0J3MtUhK2sk6JKarOs8uRoNipQjIMbNqvUzLEFC5g4RlQO15Flfxkv4UCRGOFD3pkmsslF7AkXj8GRzCzRtFLE6ak1aORZJ8Nu1HlVPQNq9RF3Gkapxd36raWmOrwsA72vkCb6W+L2hl9uQSO70Er2Tojes/DSQM32hkZYKAgMFDBRea4gTWOe/+AOr9E9HObxCvF1eDZ/KBSjGSWyOLJC38S+wcIT8A20qDAAst9O4vI28JXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OjupnVJ2T0we0nVfAmgNqoQcbNhw/8HuxqhGeas1gDk=;
 b=Zd3ltFGad2OH5IoZbG7I4q5WvlXOmKza5M7aVZrR+epwXEt6yAqFa/1lHCc1kjOndCBoC7Mkf3j/eiWa2acEhZ9jDY4DNtolDuf5nftdH2wKJ0weg9QaaJksaPeL/4dITjxgk5+DAwH8PZmFQXmk5Emlz5XbmnRabOBujbJzm0LPVgTp0W9pKEYz7RfaKFQt/XOAyLSCb0mLRhht0I1nT7b7Pf1bQ2+IxLoBdwHyCI7B7GseRRxxmOd5xZB7Fvd2ujK/+5cvb/miV6QUXJmp+kvhXhcXNWeqZcHv5GyROi4bbQr4f+/yQjet5wwA+ynXvCHWGtViA2jvJvbgpH6IKQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB7185.namprd12.prod.outlook.com (2603:10b6:510:201::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.29; Fri, 26 Jan
 2024 18:15:37 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7228.022; Fri, 26 Jan 2024
 18:15:37 +0000
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
Subject: [PATCH v4 19/27] iommu/arm-smmu-v3: Keep track of arm_smmu_master_domain for SVA
Date: Fri, 26 Jan 2024 14:15:21 -0400
Message-ID: <19-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN6PR16CA0040.namprd16.prod.outlook.com
 (2603:10b6:805:ca::17) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB7185:EE_
X-MS-Office365-Filtering-Correlation-Id: 84361178-3f99-4e6c-3842-08dc1e9ac90f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	7uwIusB7BChwD19YiRzf1iQsN0XsI//KMUPlaVYU+nX4xcF2ZJjjeNfMZyQQKvBTajkDPvC+q0l9Np9SR515k79Sqirw/bsaNfZ9toSng+ys1orNCOZbSFgO0q+g8w+EAFdGmkiHBGLxFDDRA7MSx1M/WDUjhIj1Z4gXAdamVs0x1KtistSbyOQQ1MsMR5Be0Bhu7OgoNOc2j/ARili0uht2egU58SdL4pAfJKuCofGeMggUV8wdK7MreMiZ06l6X0LwLqh7XfX8AIJrQozw3ArHgYWUmPWpWVRvXiNFH5FWpwSQEOsRsp3C6aaZND8lcupz8IVKvkVfeqeXHYnicN0jkijGq/kQaHpjJguDfpHLxITgb2jric1ufS6YhZP89Y7oFcXp5ppyZe+jycJHmlqUoxL5XXtOiG/c/wwzDNE1GRYD6ViRmyriGMPw4jFVP5eO+grtq5v+tjvay39i8m0PLynC8MyHSj3gG3cgjqHplo5xlXzBr7gidpjv1n0ECUaZELv6uz0NfSDY7f2L+LrkJj+UOCxpRdhTtHzLcWIKcoljQxOvU9jsDKkp42B6
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(396003)(39860400002)(376002)(136003)(366004)(230922051799003)(1800799012)(186009)(451199024)(64100799003)(8676002)(5660300002)(66946007)(316002)(66476007)(478600001)(110136005)(54906003)(26005)(6486002)(6512007)(6666004)(2906002)(8936002)(7416002)(2616005)(66556008)(4326008)(6506007)(36756003)(38100700002)(83380400001)(41300700001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2Y3MHfiTez0GkSf+zBMccv6Fz/YTkxALL5c4EwK85gIVfcnwhPxG+r4juFRK?=
 =?us-ascii?Q?aU8+697EWIhwBXs+q4S7AKUCShEue8+EYB5/PhDi+hdJeuQAcVp8IBiYfIMr?=
 =?us-ascii?Q?CAlkHWl4a+knkmiB4/kEzB5U1XBDTcRft5JW+GjpMNV8UXIAV2nW6dBlkFbu?=
 =?us-ascii?Q?qO+sGYSoSvN2mUeQUUskiCzcsx8uqlIS0prmnAC7PFWKTgRg3k29MnEiySdy?=
 =?us-ascii?Q?kdhyDEPyIzh6ey8plaFmvxS75yCGHNGH368+h69gPaYxcFUKs+qLuq4Ws8FW?=
 =?us-ascii?Q?7QDlI6V71HWl0zM7jQ3uEd2iCs7g9Wp4j4TwEIXkTPf94jRkXbYdTn5HwQ3l?=
 =?us-ascii?Q?xWrnGV/Pk6vpRYitmzkUB9ku9tdglu7KKuCsTMWzQ0Ax+i+Cu2OrSKYfSe1M?=
 =?us-ascii?Q?XZM5kGgkcSoi1cht1vaZA/SHydIrZmkhUFSaNESW/NPeSu0puyHHAgr9OL51?=
 =?us-ascii?Q?WptPm7IacKYgEbYRYG66sNX2jfqnz5lI7Y5CpXp8ZKbBaG1rIZVQ3sAa8wC8?=
 =?us-ascii?Q?lPuLKiX/kQUypQVbvDEnc9eF8kfVdEREQbh+IdPG26SfVkHw68O5inhTi7bc?=
 =?us-ascii?Q?YUVoTc6O5t8zLBw4RZPxMwpg7MTTcGGj9bMS++USolP91X8KGzJJ7hItMfAr?=
 =?us-ascii?Q?v0D2t9hB57XOO3mrk7CoG/rxrn2OE1itnHFezW/tNbyynJL3sYlDpk0+UzPE?=
 =?us-ascii?Q?DG4VMv8ls19CsM3IAKedx/pBzGa2HOjFejGuSvVePMR92kLyEYZOVUysafBx?=
 =?us-ascii?Q?cCARGQmruKQqQgPex6aQFQANHuMTfoRBuyakVmZgg0b2uqlPQsWt4WdaNDzq?=
 =?us-ascii?Q?TmAYNuDfpyq7M9uS8QR+Pqtyf0Pa4o56TKcMqSdxLbsKHrbVr0UbCBnoCPO8?=
 =?us-ascii?Q?F1W794HXT6wROHgSk/T10q2ZgCyPWPyeGsbHkrgbk4EKa40qfQF8dgu6V2bG?=
 =?us-ascii?Q?EzBDC/vNbJ588P5WG4GIf6NOBD5gfkTKOoM2YRtBU5oOt0nribp/6Alus3SR?=
 =?us-ascii?Q?hVQhf5wqS7n30teEeGBndOU0uHcnh3XxNgQrZ5I4IddT7L6XhOv5aiDXf/Zg?=
 =?us-ascii?Q?Oz3fdEUhlughzaDX+5pLyoOdT965UFsGczoggCx3HMthLBMo5ZZokKZlA+Pu?=
 =?us-ascii?Q?7gXxivisLD8GM8uPlhDQBNEIfIPfSG7yx69tpUmHP/QAePa1VvcvoiJZi4As?=
 =?us-ascii?Q?pPGhXuEOh7cX+Ikz99ivVsGRkBW5xFxF17dyrkQ7Z481wD3iai8rOz8wYP4D?=
 =?us-ascii?Q?mXm7bH+nMJnq+yw6fdv2+y3CYSVRGrCIXZHEZbuJ2ejoEVwQVjfg2lr1SvGw?=
 =?us-ascii?Q?HxzGA1hJx2tx0GlCWeCl44UGmdIc4zXPHxIPyhjg2Uw3Ij2rPBuUT9o8Q4cg?=
 =?us-ascii?Q?Hc9EEMOCoF+tADEQ4D09igHT1g/B4ILT35LE09oNPo1nkqXskJd+bHnobyLE?=
 =?us-ascii?Q?jLfcgOwJlZ9LJCGHMJutk9upRJlUk/SezUHPITu4211EZ6RKpIDoukG8bYkq?=
 =?us-ascii?Q?L23/e3qnfCYmgV6D1gkC22Z5fodTkQgn8Z5uCRcHBn4o/CyY6MJZyFEw7DnH?=
 =?us-ascii?Q?LTsKP4JsKGhVRqA/fLlC05GfH3N8lAShcXgLUyUA?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84361178-3f99-4e6c-3842-08dc1e9ac90f
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 18:15:32.7869
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZZ2TQc+3hWys0v2EKvLhi6kwrQn43ji4cbehgTR844VIUh8f4YEC7dV6XRb2EjGD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7185

Currently the smmu_domain->devices list is unused for SVA domains.
Fill it in with the SSID and master of every arm_smmu_set_pasid()
using the same logic as the RID attach.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 23 +++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index a8e9276990b006..961000f308b9bd 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2592,7 +2592,8 @@ to_smmu_domain_devices(struct iommu_domain *domain)
 	/* The domain can be NULL only when processing the first attach */
 	if (!domain)
 		return NULL;
-	if (domain->type & __IOMMU_DOMAIN_PAGING)
+	if ((domain->type & __IOMMU_DOMAIN_PAGING) ||
+	    domain->type == IOMMU_DOMAIN_SVA)
 		return to_smmu_domain(domain);
 	return NULL;
 }
@@ -2803,7 +2804,9 @@ int arm_smmu_set_pasid(struct arm_smmu_master *master,
 		       struct arm_smmu_domain *smmu_domain, ioasid_t pasid,
 		       const struct arm_smmu_cd *cd)
 {
+	struct attach_state state = {.ssid = pasid};
 	struct arm_smmu_cd *cdptr;
+	int ret;
 
 	if (!arm_smmu_is_s1_domain(iommu_get_domain_for_dev(master->dev)))
 		return -ENODEV;
@@ -2811,14 +2814,30 @@ int arm_smmu_set_pasid(struct arm_smmu_master *master,
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
2.43.0

