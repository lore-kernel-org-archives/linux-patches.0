Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2067.outbound.protection.outlook.com [40.107.93.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02684A59;
	Tue,  4 Jun 2024 00:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717460172; cv=fail; b=o3fns+80wvbY+oojx2fQtUIv+mGUaefirYh18AR1ymJzIvBBz5E2OJlLq1eqO/MxXE/P7qR3uGdcAZcF14NRWc92Q6R9m3tuKDeFdOYLOrK1ACQN4737jsIUB21mB6Co3JqFSm+uP9bj6m38lbEC+EeUxNE8ZR7c1fyEObRKxL4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717460172; c=relaxed/simple;
	bh=jbXyjgJDP1hSqXA88htEkMSwHspeWDtm3NvbMGXeETs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Ncjk1g2MHggE2ACMeol+ecTbY/hCnKQk++EhynC8Lrdpqdxyasct4tJelGCLwgkEKyMPcv8AopnDGDOw3H4Z8nPCnUx3LTQoR6omegtVwVbYBqxsGBOEN1rY6rJShXS8cxtzxuLyF5R+v+Ic7RIEnjrmZ3kdyDZf8D4ImGRZJ5k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kQtebnv+; arc=fail smtp.client-ip=40.107.93.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kQtebnv+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VM4A9eDhEmbQ+5mEfSDZTxajslDPLpHL5ZqypJiUTs7/8bEQDuXdweZUSWXGloblL8NmmeQOdS8aqOX5BTdVmikVz4Vjp+FNjBGzzy6y//x5Nc/VyqU273F2Nul6jr4W5n8uJEP8kRM7+gk7LPbK0PaT4ijGE1AEtftUllylY83YgPd6KjwOG52hEKLOmX0oIc8VZabrLd9Vj9VGjkwa4+NZZ+HH5SNzzeuOXRaeS2peZpuw4A5Bwu1BiCeiBsUdfgKJldEHkdzUe38bOCGvO7GO7v0lGMFfu+zaECqlcOyMjgHXCjg8OniSxE7Y9pXW2u3wkE458EnAIXwaxPVysg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cQ+oXPaH2Dvdsl8ipr4Ab/UcVTtIlrC+HUgz666jeGw=;
 b=S+2mI5w2JLgAu4tPH/2gFsSz7wf8Un46pude3zKd+3VcQExPasdZFJBi9+QxcZlltKeixJMy5xi3aYGgK6WDzC6b+zITSfERZkmkeT46zxeOmqOHbWLfSOS/tTWt/R3hdiRjHv4ljrH65kaUiDPeM9V2ZJQ6eIYTtFRQ6lTQRbWbPe7OL2fyFVN33hAHRKAvhtdcV0xX9O6gqOpDDKfuhuqZcXaZuFRdVa/et8Qtgn+/PuYC/H51waO77LiD7MQZXtniLT0ZBIzBTfHnIWD9I77rEGwVbyhWSsKwOV6t9I3h3D10llFp61/qWJFjlyOEE6qAcYjDoNsJGMtPK1kdjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cQ+oXPaH2Dvdsl8ipr4Ab/UcVTtIlrC+HUgz666jeGw=;
 b=kQtebnv+dtuzlM7n0HmyMb/csINOaS9BPVQwHOMXJVVfRp8QQLp6HsghKkrw65I/XUBnR45SuEPDm9SKf6NpXBBkuzQp0Cgw7AFF2B6thnoGj22VAnq7BHY7+wHpIQKMGccmc0zhmC5lK/rPb9ZQuMBwAbXs0pj+VIN0een5ipuTkPYKiEVEPDUaimkta3HbCv9IT7qALi99b9WGTwms5FlPPraNbGZPO+9Nt1gcthhYHm5vEXkZYKjZXN8xR6ayEeDAIpojUQzpI0+IKa+LERhlJyqzzDE8Xh6suY1/kU8TT09u8sHH0ntJEBXksH123hZq8qpOAvVChrFSMVZFdA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by BL3PR12MB6451.namprd12.prod.outlook.com (2603:10b6:208:3ba::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.24; Tue, 4 Jun
 2024 00:16:06 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7633.021; Tue, 4 Jun 2024
 00:16:05 +0000
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
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH v8 05/14] iommu/arm-smmu-v3: Add ssid to struct arm_smmu_master_domain
Date: Mon,  3 Jun 2024 21:15:50 -0300
Message-ID: <5-v8-6f85cdc10ce7+563e-smmuv3_newapi_p2b_jgg@nvidia.com>
In-Reply-To: <0-v8-6f85cdc10ce7+563e-smmuv3_newapi_p2b_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0092.namprd03.prod.outlook.com
 (2603:10b6:208:32a::7) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|BL3PR12MB6451:EE_
X-MS-Office365-Filtering-Correlation-Id: d32fc7e6-d5ff-474e-8cfb-08dc842b84dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|7416005|1800799015|366007|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?medzyDOTDGGuoWXoPwj1jX8E1FzDV2Lql9DCXKPozra0JOQKefVeGi7ROupT?=
 =?us-ascii?Q?qn3X+vsfHPomaWUrM3hmeBy/Cwf2IeKxIytsF6Jnw4k47K1hYjiLhkIU1FCx?=
 =?us-ascii?Q?VBFZ4m6ChS5H/l7H6cFJdU5IWWpGdFaQnr3x806dHO0cFrx+oOHhfpDu+OEs?=
 =?us-ascii?Q?FA6zgUZfDow6XuqO+dNxu5/rPbX7F3MpBbNTMODYtebSFRvMGZfgDbDo8Lre?=
 =?us-ascii?Q?RWYqUq65cKtNvc7wN052hdMx6F9umI7AhDLeFOwp5SVYwzTsc1cIPa5wjcTq?=
 =?us-ascii?Q?6H0sD1xEgAGvI2zCxU9kTjGjmFVZ9u8VSMSQa0mLSKEyK1yBoFjkxRSl1AO8?=
 =?us-ascii?Q?c1nzacCnk/KqWRrGf8ApQ4dTzAHBBnsPbMZP/n/BSEE3cgXyCYFASdVn47rb?=
 =?us-ascii?Q?1v+nciEVaoSZD19oDZ8fnSsJ/PNbQMYhYjg1eUfrS6jbjpc/wJwyndzEKPjs?=
 =?us-ascii?Q?/mhGcv2S39QXK2qD6n0brRpri7WSXucKCEk4u5aIQ0G+UKRsn5dT0nc0wBgK?=
 =?us-ascii?Q?aOVlm34yEPTp1nEOM3O6k/qwd6KzoyEVTaRMJ/DmfLfdR/7ifu5S1BmZVh6r?=
 =?us-ascii?Q?q9bX7Kf2/Tw0c9owHk321+QgLbM2MSlcU7775kd0cjxcmCBFbw/aek5WhJ8e?=
 =?us-ascii?Q?X/1JJGL9ozvHjJslODFd0i8v8jZLN43XUkhSnDXrp09hzNR3V+eMCeTvFeFp?=
 =?us-ascii?Q?zZLCxKTgJ00YNmrnXvOdFwaWb6BPsaFWZNwfw00BHtOTMBqaj76Ur8bwgdua?=
 =?us-ascii?Q?nJber7GNmfqCNZRAkcONxlPcXPW5eC4DifwXQDjMpRGH6b2sHXTifqWNJe2m?=
 =?us-ascii?Q?kxA2DRNEy3PDgcEIsrmYbnmOszsdgEknIiLtc5Es9k/FttHJAxka1+S+gRH5?=
 =?us-ascii?Q?ishlRsuc7ZlFUHMnRqLAzRY2Q3jY7CaZghzfOnDvnSqm6UGdlNCDGxtJ3tAK?=
 =?us-ascii?Q?Ja8IGAT8EMlZQL8IUbThKtULtH5vVkPgABzk0w6pBfyeXsGmeauzuTsd4ZBD?=
 =?us-ascii?Q?6WL86m+nmKaGCSVHoMW+pztzo7jB8tEVGzmSj5TEO0LPMoMfEnAsJf88FFxu?=
 =?us-ascii?Q?fOvau5uAbn8nj+ph2H6YBrZjLU99YCkzpsQcAHM+HttAriHcg9svuvgiKXf8?=
 =?us-ascii?Q?5p0e/NfHhO0oAhL+XaOP0xmPl+XxiI5MDyeSDRjcDrfBVXfidfxcQXyZGQgo?=
 =?us-ascii?Q?IgjDmD1FxubjVPcjyr36XbIUDzS7k1kExu1iGEGmXe2QcCv81hdCwMX6REg4?=
 =?us-ascii?Q?PR3V3JOMWG31xukw8vfymwH/31kOyl7OobCdTwbKcw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Idh8VR1xBUROFzlKDVoAkYVCF87oMpncIz/KcjQ7JxmMtPG576THq8MGyOoM?=
 =?us-ascii?Q?AJuHF4znVDvTKlY9zqxk8Rmt8i8KLdhiNyLfMqlaWYYXBobLV9190BbRsNbZ?=
 =?us-ascii?Q?ajMx9MMOUCnq8Fd8qQ8a9e3HehcdqGkSz2RpbJlE9goBKjt+4ft3TVBk0tA/?=
 =?us-ascii?Q?Yd0eQou474QaV0TjLf9Ot6Vtemzxy66BiiXpHa8CKD9m46nyvoDs4TOu9HUl?=
 =?us-ascii?Q?wQ32M9n4aU+jsk9GoAprgqXlBw14KMZGWDFkr2DCtSECRRogN9b8W0aim57X?=
 =?us-ascii?Q?8cs9uM+13N+C2hcxe0RRRXXkFrkeITHHj8XpP+M7D6dDAE+YcdJIiMbIAjXk?=
 =?us-ascii?Q?Kajq1o68JDU9tsbb+E/QePnIHpqMmV3ruu6Yv2FmVDzGr01ZKEvJxV39jXXI?=
 =?us-ascii?Q?X9B93yohVQrlORcwEp4w2MRm0+EfavhfmlA74aiQJjoTlUSuuBTn/EvNkldX?=
 =?us-ascii?Q?VoYXfPkEcww8WBfyZCv6vmEdkBZexbSjrPaSequ5enE6CssAHWsDBt0Gq4Lu?=
 =?us-ascii?Q?45duP7Dxnf9Pqetl2dMXi9/mFS2dlstMTuQ9OGSUUJv68anJJj5wNtJIUr4o?=
 =?us-ascii?Q?UcGJqyGzECRN83xknk6KSe+1098a8C/R3p72UtkPKG/eFHDl/Lq9fOAGAHj5?=
 =?us-ascii?Q?/tP0m3eJBA85Dg8wn9wK2wNY4fA0UrlopndtznK8uPwBltoyU1w4eZD9L/0y?=
 =?us-ascii?Q?RMrZtJ8HgPg+b8xtMy2pxFolbwBtojYyOhuCid8cW5QG60yaS4LQDAXmSYpm?=
 =?us-ascii?Q?G/XwY7/HRV+7pJ+IJvXkUhypXldpn+98ILWZ1RRg7/1tu4AQnemDtj4RwvfX?=
 =?us-ascii?Q?KeYTlw8W3YrqFRXKYk8Qq0XAC9GRk9S4dbE4+VShbyvZB/d9NpzpYj3zhMEU?=
 =?us-ascii?Q?O768teuogbrSxtViA85kpIeQL6Rs+ew1iZJlQIps/D8nfIz7QMbitxUD5RC1?=
 =?us-ascii?Q?gMGQIEafMjqoeEAtlC5WyVLyrHTxtbT96ClHfN4j1mERuJL2SJdHPVeg6p06?=
 =?us-ascii?Q?Y+XBUtrkzLJHvUZgNmBPE7C9b2akB6jR8tdV+gnbbf4S6YwePSo30AHfMM8J?=
 =?us-ascii?Q?bw68Vy/3i7LZULQLTwu+6z6TJDc9CAFDSiaXSAHB0AAID7WOx2P/ou2secyb?=
 =?us-ascii?Q?tFfTtYrR/IySxkA3w90/Lrdolup26Vov5rJuuSUfjYFGG+WpKAAkaSc5tLTX?=
 =?us-ascii?Q?n/498vM8Rb/ymTSpUchRo8AU/jZLLr7iStv6yUMAYsqbGNaaJ8S7lrA51/qJ?=
 =?us-ascii?Q?VVpvXoGmtIUMNRmn8fEkIY/maz3ckMtDZQmFtuLTP0RCOdKic97rddA6NuGg?=
 =?us-ascii?Q?CvdR2yJ3eHH71ayOtYs5vUM3xBbdyJ1scqiobg52i/3blEFDnAoM640yTH5U?=
 =?us-ascii?Q?BkWlsZSY9Q/ijJ6ozxRXZYb0HsHZkHnRE/pacF+p0njUEeJuUujN0yV7h6BH?=
 =?us-ascii?Q?OrJoG6j3S4P/nP+zTwky/BJG/1nqQRYue8obV41RKjzGlKqxq4y5vbkTjZWe?=
 =?us-ascii?Q?fdmJR1pHyiDf23sIASVmQSsIiuv/an/+slFbLrDVw0DuHgf1g7d654NASIcb?=
 =?us-ascii?Q?xAZ/RbFmOYf92Pgl0h0=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d32fc7e6-d5ff-474e-8cfb-08dc842b84dc
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2024 00:16:02.9130
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CrWgfYvxojsKhLIzq4ThcAWCEuRLQMyqgHuqz8slKdlEWvXJOJSTRSkT8jPol9Dj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6451

Prepare to allow a S1 domain to be attached to a PASID as well. Keep track
of the SSID the domain is using on each master in the
arm_smmu_master_domain.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Reviewed-by: Michael Shavit <mshavit@google.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 15 ++++---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 42 +++++++++++++++----
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  5 ++-
 3 files changed, 43 insertions(+), 19 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index cb3a0e4143c84a..d31caceb584984 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -47,13 +47,12 @@ arm_smmu_update_s1_domain_cd_entry(struct arm_smmu_domain *smmu_domain)
 		struct arm_smmu_master *master = master_domain->master;
 		struct arm_smmu_cd *cdptr;
 
-		/* S1 domains only support RID attachment right now */
-		cdptr = arm_smmu_get_cd_ptr(master, IOMMU_NO_PASID);
+		cdptr = arm_smmu_get_cd_ptr(master, master_domain->ssid);
 		if (WARN_ON(!cdptr))
 			continue;
 
 		arm_smmu_make_s1_cd(&target_cd, master, smmu_domain);
-		arm_smmu_write_cd_entry(master, IOMMU_NO_PASID, cdptr,
+		arm_smmu_write_cd_entry(master, master_domain->ssid, cdptr,
 					&target_cd);
 	}
 	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
@@ -294,8 +293,8 @@ static void arm_smmu_mm_arch_invalidate_secondary_tlbs(struct mmu_notifier *mn,
 						    smmu_domain);
 	}
 
-	arm_smmu_atc_inv_domain(smmu_domain, mm_get_enqcmd_pasid(mm), start,
-				size);
+	arm_smmu_atc_inv_domain_sva(smmu_domain, mm_get_enqcmd_pasid(mm), start,
+				    size);
 }
 
 static void arm_smmu_mm_release(struct mmu_notifier *mn, struct mm_struct *mm)
@@ -332,7 +331,7 @@ static void arm_smmu_mm_release(struct mmu_notifier *mn, struct mm_struct *mm)
 	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
 
 	arm_smmu_tlb_inv_asid(smmu_domain->smmu, smmu_mn->cd->asid);
-	arm_smmu_atc_inv_domain(smmu_domain, mm_get_enqcmd_pasid(mm), 0, 0);
+	arm_smmu_atc_inv_domain_sva(smmu_domain, mm_get_enqcmd_pasid(mm), 0, 0);
 
 	smmu_mn->cleared = true;
 	mutex_unlock(&sva_lock);
@@ -411,8 +410,8 @@ static void arm_smmu_mmu_notifier_put(struct arm_smmu_mmu_notifier *smmu_mn)
 	 */
 	if (!smmu_mn->cleared) {
 		arm_smmu_tlb_inv_asid(smmu_domain->smmu, cd->asid);
-		arm_smmu_atc_inv_domain(smmu_domain, mm_get_enqcmd_pasid(mm), 0,
-					0);
+		arm_smmu_atc_inv_domain_sva(smmu_domain,
+					    mm_get_enqcmd_pasid(mm), 0, 0);
 	}
 
 	/* Frees smmu_mn */
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 24f42ff39f77a9..674884a8fe25ba 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2013,8 +2013,8 @@ static int arm_smmu_atc_inv_master(struct arm_smmu_master *master)
 	return arm_smmu_cmdq_batch_submit(master->smmu, &cmds);
 }
 
-int arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain, int ssid,
-			    unsigned long iova, size_t size)
+static int __arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain,
+				     ioasid_t ssid, unsigned long iova, size_t size)
 {
 	struct arm_smmu_master_domain *master_domain;
 	int i;
@@ -2042,8 +2042,6 @@ int arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain, int ssid,
 	if (!atomic_read(&smmu_domain->nr_ats_masters))
 		return 0;
 
-	arm_smmu_atc_inv_to_cmd(ssid, iova, size, &cmd);
-
 	cmds.num = 0;
 
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
@@ -2054,6 +2052,16 @@ int arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain, int ssid,
 		if (!master->ats_enabled)
 			continue;
 
+		/*
+		 * Non-zero ssid means SVA is co-opting the S1 domain to issue
+		 * invalidations for SVA PASIDs.
+		 */
+		if (ssid != IOMMU_NO_PASID)
+			arm_smmu_atc_inv_to_cmd(ssid, iova, size, &cmd);
+		else
+			arm_smmu_atc_inv_to_cmd(master_domain->ssid, iova, size,
+						&cmd);
+
 		for (i = 0; i < master->num_streams; i++) {
 			cmd.atc.sid = master->streams[i].id;
 			arm_smmu_cmdq_batch_add(smmu_domain->smmu, &cmds, &cmd);
@@ -2064,6 +2072,19 @@ int arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain, int ssid,
 	return arm_smmu_cmdq_batch_submit(smmu_domain->smmu, &cmds);
 }
 
+static int arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain,
+				   unsigned long iova, size_t size)
+{
+	return __arm_smmu_atc_inv_domain(smmu_domain, IOMMU_NO_PASID, iova,
+					 size);
+}
+
+int arm_smmu_atc_inv_domain_sva(struct arm_smmu_domain *smmu_domain,
+				ioasid_t ssid, unsigned long iova, size_t size)
+{
+	return __arm_smmu_atc_inv_domain(smmu_domain, ssid, iova, size);
+}
+
 /* IO_PGTABLE API */
 static void arm_smmu_tlb_inv_context(void *cookie)
 {
@@ -2085,7 +2106,7 @@ static void arm_smmu_tlb_inv_context(void *cookie)
 		cmd.tlbi.vmid	= smmu_domain->s2_cfg.vmid;
 		arm_smmu_cmdq_issue_cmd_with_sync(smmu, &cmd);
 	}
-	arm_smmu_atc_inv_domain(smmu_domain, IOMMU_NO_PASID, 0, 0);
+	arm_smmu_atc_inv_domain(smmu_domain, 0, 0);
 }
 
 static void __arm_smmu_tlb_inv_range(struct arm_smmu_cmdq_ent *cmd,
@@ -2183,7 +2204,7 @@ static void arm_smmu_tlb_inv_range_domain(unsigned long iova, size_t size,
 	 * Unfortunately, this can't be leaf-only since we may have
 	 * zapped an entire table.
 	 */
-	arm_smmu_atc_inv_domain(smmu_domain, IOMMU_NO_PASID, iova, size);
+	arm_smmu_atc_inv_domain(smmu_domain, iova, size);
 }
 
 void arm_smmu_tlb_inv_range_asid(unsigned long iova, size_t size, int asid,
@@ -2518,7 +2539,8 @@ static void arm_smmu_disable_pasid(struct arm_smmu_master *master)
 
 static struct arm_smmu_master_domain *
 arm_smmu_find_master_domain(struct arm_smmu_domain *smmu_domain,
-			    struct arm_smmu_master *master)
+			    struct arm_smmu_master *master,
+			    ioasid_t ssid)
 {
 	struct arm_smmu_master_domain *master_domain;
 
@@ -2526,7 +2548,8 @@ arm_smmu_find_master_domain(struct arm_smmu_domain *smmu_domain,
 
 	list_for_each_entry(master_domain, &smmu_domain->devices,
 			    devices_elm) {
-		if (master_domain->master == master)
+		if (master_domain->master == master &&
+		    master_domain->ssid == ssid)
 			return master_domain;
 	}
 	return NULL;
@@ -2559,7 +2582,8 @@ static void arm_smmu_remove_master_domain(struct arm_smmu_master *master,
 		return;
 
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
-	master_domain = arm_smmu_find_master_domain(smmu_domain, master);
+	master_domain = arm_smmu_find_master_domain(smmu_domain, master,
+						    IOMMU_NO_PASID);
 	if (master_domain) {
 		list_del(&master_domain->devices_elm);
 		kfree(master_domain);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index f9b4bfb2e6b723..f4061ffc1e612d 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -772,6 +772,7 @@ void arm_smmu_make_sva_cd(struct arm_smmu_cd *target,
 struct arm_smmu_master_domain {
 	struct list_head devices_elm;
 	struct arm_smmu_master *master;
+	ioasid_t ssid;
 };
 
 static inline struct arm_smmu_domain *to_smmu_domain(struct iommu_domain *dom)
@@ -803,8 +804,8 @@ void arm_smmu_tlb_inv_range_asid(unsigned long iova, size_t size, int asid,
 				 size_t granule, bool leaf,
 				 struct arm_smmu_domain *smmu_domain);
 bool arm_smmu_free_asid(struct arm_smmu_ctx_desc *cd);
-int arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain, int ssid,
-			    unsigned long iova, size_t size);
+int arm_smmu_atc_inv_domain_sva(struct arm_smmu_domain *smmu_domain,
+				ioasid_t ssid, unsigned long iova, size_t size);
 
 #ifdef CONFIG_ARM_SMMU_V3_SVA
 bool arm_smmu_sva_supported(struct arm_smmu_device *smmu);
-- 
2.45.2

