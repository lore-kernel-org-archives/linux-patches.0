Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2079.outbound.protection.outlook.com [40.107.212.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C2B91F03FB;
	Wed,  4 Dec 2024 20:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733343304; cv=fail; b=ZVWDFXLJgXC7WEvfYW6Qma/cL0HcBywKRSZBuSNYQr1bNRHjgtm9FTr6aQFHGzmyef0AXbYwj1X839O/12uEXbF8lMn9H+ZStAhvw36qJwEJbzfQHOFGhlGXEdn5CKn51tRGzgWkgNejfLR9CQV/stF6JUNgToNbvB+0SEVrZmA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733343304; c=relaxed/simple;
	bh=kUpwTNzIredmRr1p0VsQ7bdN2CFDlpanVXErA4KV0o8=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=IhXUcD6wwNBwFzcyLAdUK/31ajUN4GrBSmLVabhh3vyBH5Kp5Q3QCH7MUCouRhAKf+gvnpMbPQKzyrPavCygJ6mt1uHSfAzZ7vKjnWfsd9hiXQqi8qqhFXJ7rWWOSQ8I8gKlmC8z1wi/KAKDfGZqP37IuqBxSZkdG4crrKHSuCE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=UjiK/2Tm; arc=fail smtp.client-ip=40.107.212.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="UjiK/2Tm"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xvLc/cjBYxgNWejZzeHDoVyMDOVB6EW9BHpm1jT+P8IesU+yNqCx+gbX153qbLgoTSmvVQ0EuUbQ0BQo1clrV4kp0FexEfm6DURS+x7HkCsFOknyspSzJoKaT3m0AFFrPFWfYtDY9PtfSqgtmzc7NwBFx/b5lYm368tJrxxX+rbKoRkguKFaIPN67gNtx/H5u2DN+N29gkBVKyhohWUT6GXTfPLdkRP/ebd5mrRhamb6OQHD7oJXfEt6KlVN903DMmuyMzV1+jSMDi8d0DGVOC+DBMctaew2jUdAQ+KP+88Tw9DYCQ4n/hmcOpjt1P97gsCivrdy0kqbW5jIu6fx0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2WOggmNJPbhmQGkupeLIeeYQZ9YU97V6aF/Ku53m50E=;
 b=ApCutM/NB8UYark5k3kjlLN3T7qUOcWoXo/WDplp7XbnXukzYw0/Vw6B8E/IKMfPq9ZsiMcYbRuRpSmUbVC/nAHlLVOVWxi75IE18f2np6kHZ44fq6MVd1oje+invckHWOtxh7mhujpzJwl0VhpdVomjA15o8tfLAxg4YvW4zc00D0OQtttEW2j2/6JrG5heDU3QeA8brJNNPyPDrOxeU3Nh9OL65StziOYmry4BfNVL3a5OI0P9x3GEuGlc9W5ezhDd1owHI14dnG1xdkDohPDHEm6tRaaLuTyVVrLbR+dAt+atPzBu77sdbZChX5tvFYFjnfADdid6Jz1UonYGug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2WOggmNJPbhmQGkupeLIeeYQZ9YU97V6aF/Ku53m50E=;
 b=UjiK/2Tmwf+skRIlVudwsAcTt+VbKg2ssthxzooCB1FV3TwBWep8XqIhFsX0x6yh1nLJsTdEsVaZ1bteu0VD7w3gQo0ZBFi/DSSIjH3UOZkvGBLdoeA0Wfz7Ja6xSL5c2MjAyAlcD30E9fDh8akZAvW7Px/BY9nPDtCByUEu4DgMg89D1XBmi1V7pJaRVXQZCSLUzVhDpJ+t3X9OPCz5kQQVVU8WqCP/C7LOM0FoTzgXVQjl9WSXRETe591A2Kq+ulXLNWiAAa8Bj4ybE6PSC/1YJx/cGWWkNA1dO8ub5+NJkPC+pwCDbY2njez+7ivB46w9893S5lGMS/4pP2aPHw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CYYPR12MB8990.namprd12.prod.outlook.com (2603:10b6:930:ba::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.18; Wed, 4 Dec
 2024 20:14:59 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%5]) with mapi id 15.20.8230.010; Wed, 4 Dec 2024
 20:14:59 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: patches@lists.linux.dev
Subject: [PATCH] iommu/vt-d: Remove domain_alloc_paging()
Date: Wed,  4 Dec 2024 16:14:58 -0400
Message-ID: <0-v1-b101d00c5ee5+17645-vtd_paging_flags_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0211.namprd03.prod.outlook.com
 (2603:10b6:408:f8::6) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CYYPR12MB8990:EE_
X-MS-Office365-Filtering-Correlation-Id: 09947045-af75-4f18-700f-08dd14a053ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KhEYBIewubQRbmD50qbh8utG/r8nve6N+knHiGKPT2P71HYoqYHNNTIstE58?=
 =?us-ascii?Q?uWrRWiSSxAfglBRN4g8PP3+55HujWmmafwy+AyffwM9Wje0oQiDMhoWisDSc?=
 =?us-ascii?Q?tRREDOOhLU47LSgKVsUBOQ+u1SWOGAf5tOl9VgPUI5tmfGH85AwCbZ8/lBZ7?=
 =?us-ascii?Q?IAGr+x2rtrxWO9GKRqUEKzfMWNREFho7G/L56URF4wVPhV3jRWe3Bu2mrk7d?=
 =?us-ascii?Q?gfnyOq5m+/ZDm42bxCWervRTUkoiz1apYVNAOzStrAhE+AErk5dR7vh98ijm?=
 =?us-ascii?Q?m1qKV8ZF7NmkFatwg+yrkNwhY64r6ID21HIv4MsjQKRiKGG23BuW0J9NONnx?=
 =?us-ascii?Q?dl+hAEng0+ix1nVGtSjQiU9aCRXzoia9XHRJRsQafwrkYBFZ5ym7IysdHLUE?=
 =?us-ascii?Q?l5Hdy2xmvXV3YGIIJLVctE+3++e2mtzmeZOzGfbZi3V+ipiF1Doh4renJMpj?=
 =?us-ascii?Q?joakiCXii6JYMV3BuWxeKBCTYAx0RNEPKloDL5X7UcePG/pwMbGHTorD+7uB?=
 =?us-ascii?Q?VK11j8B8LIxMIf5Vtb+HSXCE/w3FGSRykjHqWF5aXH+u8fu8rNHMbH/PukUy?=
 =?us-ascii?Q?DEp8hWRdIHBX0QfwbplYfNVth0uvYGJWsmQV5Os2TwgLsL4iYtXX5Hy+rzrO?=
 =?us-ascii?Q?cvKfcmJrkFlpP37BDWbn4XlYsJcLveGTf2Lavipsy40ZHmZXHSrId66+6cyW?=
 =?us-ascii?Q?CP1ZO/Pt0yPUFQkVUW5pSvV0xNe+9yksrIjChK7iSQGl6YCIDymT3sp5GF3H?=
 =?us-ascii?Q?DqI2b0HPf67Ph2bMd5ewwuTNCGBH6rtU+7A2AuTBDTb4etr5uGLf2+x9Ja42?=
 =?us-ascii?Q?O2jKcOBbFyf6+DR+BGV6vAxkfDd48xPnF9u4UG/smanJ5saMnvp3f+f+g2PJ?=
 =?us-ascii?Q?y4N/fkhXEt08L4MubSFf9XSVdJ+oDc4MtpK1r8BOgVekfPQIGsx+/cXKyxJD?=
 =?us-ascii?Q?Zb+MFZEX+5WPLBBfSCfJtrekORnk4yqVLnoEOAlH6AvI30UyzDqV4DExcgnX?=
 =?us-ascii?Q?J86QhQlHeCMoz0ZLU5QkFCL1ZKiwd7CPsEZ9lnRvynUk97Ukzb7J+CDOb8f/?=
 =?us-ascii?Q?Lt+arKWMhtAN7uKpiJkF/IgTddOKEbjYrKO0mYUCfu5qBYINFcaCe0P67tRd?=
 =?us-ascii?Q?davYqfpQOLJjHawg5ByyEG196YGV1QtPcKzUYC8WPKEIXjH2kPJQ8TjESpUX?=
 =?us-ascii?Q?5Z3dKJxzzmqPdagkbuPuN0tmYOc+UK5hWyRypdFmecATN80WLp6zeJ4Ryi5R?=
 =?us-ascii?Q?oB8AZieyIQmztpVG5vli/iopj3J21sNHJK0vIry57/7cu2HGKCMIWjkbIGv/?=
 =?us-ascii?Q?yyRQdDAIO9E4zCuYXaeOQeVx91ltO4AvALCGoUgO5mlGdw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DMQmZ5wDe1RGRR1Cyai0+/KwZ6BaliQZgMfnsQv1dyzax+mYGw2B+9H2IREe?=
 =?us-ascii?Q?Y5FbtRtzijHVTvTDo8+LiYUp2vLwIXdXWavHJ6wpYWiX/cXwcljm7sKwChDq?=
 =?us-ascii?Q?B/Dr6mMBIaiNPm2LiKnehv2MBrQ4tNH+d/A07lJYDKv8LEibkiW4bVTi4jA1?=
 =?us-ascii?Q?cB5MxJY/GjcNkYa891C3MQRILDHAMzZ4WNezz9QPstkdwVZVz+tLGJXpBimC?=
 =?us-ascii?Q?wmG7uF92dGVVgI+2wg5k9HFDRgzy/Z2zBvMZG6xSDU5aT9YBNNRCizMwi/WL?=
 =?us-ascii?Q?OaKBGQVpwnH0fwX4NQ1r9OWyM6i7PjxdVtIL+ogn3JYXDc6le17cwyHkwk//?=
 =?us-ascii?Q?Cvt3UtT+jg0COLvEQU0tuy1lhOC1zO9VHg2bmIp94goWk4qZlV5ByLBYKxuc?=
 =?us-ascii?Q?H5qS9zM7uIEC12buXWbre55vBkVlGk+vS8YIOVRPw+iAuwli5Ofz+3EhxOeu?=
 =?us-ascii?Q?f3fDcb9yZ5ImdZ+Sn4pkb+HsaHUSp2uZ8KzcBRtimNAtdBsJG470raxVW7O1?=
 =?us-ascii?Q?SXoTsLL5dmzfyjVmLsYdG5JTtd4P/pbK4ViaLi33ynTHR9u1uGFIr91SlhUR?=
 =?us-ascii?Q?GZLK7h1fjbmBYmnMuJMmKNefAAgYzyT3qZ8zA7n/ETbz2YXw4D57RYUmQ0vZ?=
 =?us-ascii?Q?ZAH9cwNHq006cv5+a2/DkryyBjIequQojS+oOuaF1EK22lUnqHN56mZeBy0q?=
 =?us-ascii?Q?mYyVMV4GTm6KV39LH6e1CWhoA7JTzq8fa1H/PhkwnrAy3K9BPSQjm2vxTtTi?=
 =?us-ascii?Q?ggaHBe4maTIfKqBbHUpM3RLf0eXVqhi3sksaT6Vr9yBwMgaWJkioP2CS2pv/?=
 =?us-ascii?Q?GT/e9XwkIaNWVs6xWwAHGrhCLXwQcUfYuIh6yt40Dukgnn/s77a6Ui17gs2y?=
 =?us-ascii?Q?+PVHvyrTeNUOkZzmysNrn0gXV6FkUGqIMvv4PQHPtbbVRAZiX6mUD1fibjq0?=
 =?us-ascii?Q?JOuiQmOTZbL+6ZN9dmVLhPsvLogME9C5LMKAFps2cyhSNAkQNn0nwDvN2DjI?=
 =?us-ascii?Q?POweq7sbYdP5xJ0wPjHWX+R4Fav2gf3B24SWxlMAkr+OjDPCat9g1pMVdi48?=
 =?us-ascii?Q?qzIBGCfCVqpAh8ETsc2wcZUrareDUAVJbvTklPMdp+Bxovp+PDd8+e8TNj4y?=
 =?us-ascii?Q?xd8TJOVouJ4r2US8pEwl+iudmkKhvBih1EHGmfVP9E8v9txkjLZJQavkh1BE?=
 =?us-ascii?Q?NGOC/JfJsXH1yNex8tJkgEn+FtLyvt4MC3PdJjYVaiqCM/Ihx6YaKavGhtzi?=
 =?us-ascii?Q?BpgBPUkU0ALAe1o3GBFtVNmrzhJy1YqCBxOWUxoklqtzNM9MlUSCsNC/S8ef?=
 =?us-ascii?Q?VGQlxqNDBdjJvjzc9tvhlT+4TCKEkfVurI4B6n0g6m+cWMByWfvQ9TKWt55e?=
 =?us-ascii?Q?RNotFSE1aDPu6y2uCQFCrnMB/mLykuAByUgkXF7lljEFKQNxOG8oF4NbMA+4?=
 =?us-ascii?Q?wa3bOefkAlMU/KWkSogvquzZn7l6/Nd3d/5v5Ysty+uRbozA4AEO3q6OdjoP?=
 =?us-ascii?Q?inrPoTjgHT6pgbWh4jG8oT1GOxai465GuqKMh9IRbjU6w3NfBJUTO/OrQYps?=
 =?us-ascii?Q?hzU8kmGYOCeUkmvzVjnhPa/tjXvNYxaYhLXISUUQ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09947045-af75-4f18-700f-08dd14a053ca
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2024 20:14:59.0810
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OalmUPbk7kPHgmL3ppO0d7LPUvuQhOd8IWtJpemaxmLdVQokCVTsWQCPtrK1dGX+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8990

This is duplicated by intel_iommu_domain_alloc_paging_flags(), just remove
it.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/intel/iommu.c | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 7d0acb74d5a543..88e4e867012cba 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4443,21 +4443,6 @@ static struct iommu_domain identity_domain = {
 	},
 };
 
-static struct iommu_domain *intel_iommu_domain_alloc_paging(struct device *dev)
-{
-	struct device_domain_info *info = dev_iommu_priv_get(dev);
-	struct intel_iommu *iommu = info->iommu;
-	struct dmar_domain *dmar_domain;
-	bool first_stage;
-
-	first_stage = first_level_by_default(iommu);
-	dmar_domain = paging_domain_alloc(dev, first_stage);
-	if (IS_ERR(dmar_domain))
-		return ERR_CAST(dmar_domain);
-
-	return &dmar_domain->domain;
-}
-
 const struct iommu_ops intel_iommu_ops = {
 	.blocked_domain		= &blocking_domain,
 	.release_domain		= &blocking_domain,
@@ -4466,7 +4451,6 @@ const struct iommu_ops intel_iommu_ops = {
 	.hw_info		= intel_iommu_hw_info,
 	.domain_alloc_paging_flags = intel_iommu_domain_alloc_paging_flags,
 	.domain_alloc_sva	= intel_svm_domain_alloc,
-	.domain_alloc_paging	= intel_iommu_domain_alloc_paging,
 	.domain_alloc_nested	= intel_iommu_domain_alloc_nested,
 	.probe_device		= intel_iommu_probe_device,
 	.release_device		= intel_iommu_release_device,

base-commit: f6ba64bc6669cb5152a31a474734308dcccb3ed8
-- 
2.43.0

