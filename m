Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2085.outbound.protection.outlook.com [40.107.243.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A429E14D294;
	Tue, 25 Jun 2024 12:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719319074; cv=fail; b=RaNRFw2Sixnbqq21xHLQQLL/vtPfcWlFyQZ/ox8C8wKS29WP+g5buZf0kfuv/507KiEer2DDjB3902R6L9fsqi0/XZcWtAmat7Bx0tJ7F3hdWQ178k+nVVR30g/7il/AWfODgF+4MpZ68bpiAaFrMpusoSPSt5QAVLNfmR+Cltk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719319074; c=relaxed/simple;
	bh=0NzC9kuAdloKyUByuPID97JcmWfqWtNKMlmGO6OG4wg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RDdPxdrdpyISZduAPvU7zTpRfvjZ13dqeKTIqh5fxI+a95mgJgXDsonEdHn8DDqo8+Z8ana4z0BlKajrh3GWv7NYn3ZRBTxy+7Hz1sOgo63XFSFlzi3lMF/smBmh/Z4W6d1nlgwaflCgX7JnaU1YDk1MbaL9Vb2emZU0aGna8P8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=c3UUCmqm; arc=fail smtp.client-ip=40.107.243.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="c3UUCmqm"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UlA9GVi8DOrdtSny5BK/CIimoJQuiJv7rVdIz1A+eYSbFu2l55bLFOX4yLooM5scDEXw/b44H5Uhg70LmZ/Hgf2ic8RMz++KdWemgy5+f/lCa4050aBUazPm6cWQQNrgEOI7iL1X+FNKDY1Fzt+nF7yG8Bbq8wv8EuTEzqoAqHGZyTzxfcVdzT+yMGI5sYfS9n5j7hiJARbvRWR7FYFgJWrzF4A4zkcPcthsCSGFQ7xLgX8o9FttsmPLM0lB6MKJC/xehs1PFUjD9OMoJcHonLGf451S2qYhxHb42/bTMiCSJEJEerr3McafaBHvXObystAkburMEK6rJMAPVFOjZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RMhaN0GEtCNsfPgD3QJL5CcnxTDRZV+09R33NzJD3ak=;
 b=ADTRhahAHd2Gqq9fuJCearybopAlyFUUI7N94Zx8dFHVXpMoLFBy/mfRIZrgsB8wi05DCPztCNKQMe7mgeLzIvvPu7WL16h+fOmzng9aEgYuyZr3MUuiedO7YdlR2uyUvUjdF0jGSo4wClYHUoxqKT2HkL/za0we8qUHsfoSrtT7WRZ21ubVfXeCtVx2y5Gan5w+ahlwsqgNPx/aSy5n3z9OXEbKzkoYrQbrfy3oi2tlD2sRytZawDTs1OrazlBnEwZMSemGwQbEFl6J28A4fuI083Z1Z1bfGUIbwCEe+HarToSVQNL302yFK84R0n6z2f66pbVQp/Dm5yWHpP4eOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RMhaN0GEtCNsfPgD3QJL5CcnxTDRZV+09R33NzJD3ak=;
 b=c3UUCmqmAIgI99Ve+0CCQIcmzLLc4+ArhsE+cacvdFEDjgRqPwRcuOb5m2oZIJy93/99263lVh43trvdvqyu/M1U7L3AyaWcT4lFG9Y7TuyP/0xeXVfc+l1k+vRe2x1KT9AeB6QvZlQT5oY2Tf+zoz6hG91Ab8R7rfqRVb4lwkLDba5gC0rj15MvE8Eu/0272vqeg0cEtw837JLbvBaq5ALq6TJBJOhowVW+JhYPHNAxDn6usGySXgRGp79VQwrW3kgxPTrpmAZLD/pw8mw1I/bJ0bXcvga09ycjolNuqz4AFlFYkrUTQFw6U93M+vlm7q0RswIwFBetBkfvW8Ddzw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by SA1PR12MB8946.namprd12.prod.outlook.com (2603:10b6:806:375::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.26; Tue, 25 Jun
 2024 12:37:46 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%6]) with mapi id 15.20.7698.025; Tue, 25 Jun 2024
 12:37:46 +0000
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
Subject: [PATCH v9 05/14] iommu/arm-smmu-v3: Add ssid to struct arm_smmu_master_domain
Date: Tue, 25 Jun 2024 09:37:36 -0300
Message-ID: <5-v9-5cd718286059+79186-smmuv3_newapi_p2b_jgg@nvidia.com>
In-Reply-To: <0-v9-5cd718286059+79186-smmuv3_newapi_p2b_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR08CA0026.namprd08.prod.outlook.com
 (2603:10b6:208:239::31) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|SA1PR12MB8946:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b8e2866-5b26-40d4-8ce0-08dc95139d92
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|7416011|366013|1800799021|376011;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8c7lRyv3MK071jJRYG3X4cR0FOTXBLIRMjGeOQt7IneEsqVc/BmGEEHZMn1y?=
 =?us-ascii?Q?ZhXoSQwKwSvIRD5mUjRzONv9QsbbNq8CEUDLjBUI0J7Rc7VR8BmDOKpxIhFc?=
 =?us-ascii?Q?qN6wXQg5JvOuFWsNZQK8lOtawtXJWjGPtkN1OOfY/THlyMqzxltqG5LShjyD?=
 =?us-ascii?Q?ztE6aHbr+jQdLaeG27HnHc8lfTBIoqy9zejfAaSupDZsm+CsHFRdISIoUG6v?=
 =?us-ascii?Q?hdWAWawCUPwB46FrW1aVTYKBmEXau6UqjTlKIEJkCWI5pWuh1hK/bduiKCmO?=
 =?us-ascii?Q?/nYe8wLnMyqv8rjqUXWDXQ0janctUSVMS885wlE0hjwm1VgPXkGvWHQx4oUJ?=
 =?us-ascii?Q?zB1uetgHX8UzItzHtRknAIAhnNAwQs6lHfMSeKfROqp/ueDXJnpOhCnyWDj1?=
 =?us-ascii?Q?kl/UsELlFZuTOm1l98Ls8KK/+fELA/g0Elh7Rj+C1K1ziKydrGMhO7I13trA?=
 =?us-ascii?Q?Wbr5ckh/+lKRHFw0GvuyEg/Dy1k38Qpm5kAAW0pVM7w7+I8M/b72WxOmdIXo?=
 =?us-ascii?Q?KjovQcYX3dJlb8Df4Hh7dZC261sf0omYRsutZPrDzx92+wcz23MraSw+xYnP?=
 =?us-ascii?Q?FrZweyvno566C5s1D6cpAeK187qK1p5VFICjLWkhjBenXNf04i6DIf/3ytbe?=
 =?us-ascii?Q?2Ys61nqL3kspxKz3Zh2T2kJ2iga5P3O4P9EK+ekH8QJpa+bDwCGXP1VoUn96?=
 =?us-ascii?Q?CIypbzhrWgEZEQhAfPErCFdVSVScJ41zwiHUI8JFddP90Tkbn6ie6cg98MKf?=
 =?us-ascii?Q?XcEEUvt7vFjd+YESiwYLDhFXoBGhRgWzrjcjLePtC+bo0UXA9I1NhaOCwJrD?=
 =?us-ascii?Q?aEQx0khHazqPg/PpCBdRe3rZO9SuaTWKYmZq9aWpA59MUIyks2fAgbcbzH1y?=
 =?us-ascii?Q?bslQ7wSKknuebvudUF+mNj2bJpGdWgDz0Dkbb97ohUgMfIxXMt11dUJInbTp?=
 =?us-ascii?Q?wHdYB9p0RbL65CEdmfpg2UELhUzzoOpX1wgeBwTTQyKuyvJe2hcjuEoFsXxd?=
 =?us-ascii?Q?xSFG5BSwMkqp+fpbn8MLPbbAk48/NV3mnhDmvFJPU8WYBAFhh6C5BPG8BR9D?=
 =?us-ascii?Q?WV8MHmDQC4RUPFMskVcjfOTcq08wHAQlzAlYDev5yyUSxnexXdpZ1Q47QIeA?=
 =?us-ascii?Q?XuuyHEWgCNCFphvB7yILTKKcPuEzULBmPlKMAdP7yiaOER0pxkirmGfrG0gS?=
 =?us-ascii?Q?TbH2j2QzC2cjsKswYC6xRdMLaVaNgjxD7Mey+1zdQmoAIWUwsUNb+WCMbzKG?=
 =?us-ascii?Q?keVu+5EbC9PDqvD36B1//2JuRm58vwJ4EDs+S6mr8eAfrbTPiXT+O3oEYK4g?=
 =?us-ascii?Q?KkI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(7416011)(366013)(1800799021)(376011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Pgb8r8vBgO/VbMHhtlFn68GKjNEJ78kfsKMuKaqPhBYwpV8/th2+ZgvXRK6X?=
 =?us-ascii?Q?IbUbjS7jJgz3UcpieQq8CcRqN4xpGar3veDGYkwOe8dxgfiH8khG/bU5QT+0?=
 =?us-ascii?Q?oj00ga9uG/IDwc/miGzi9FZvZ5ZyvKX7mO+MDnLH/bLV13xYEdLxI4h01NMX?=
 =?us-ascii?Q?SZNPYPRc8ssgJ4+gTD2eOj1eZl/DZ6H5gAKdgffmEqQMisSF6a/w1+YNCRqE?=
 =?us-ascii?Q?cyl7OBPBNmciEHAvhWmd16Ierg7GHf4eqqDMJjelFcw2d5kxlGprM7b5Ykr9?=
 =?us-ascii?Q?HMz2D3bKdqeFfxwS3MjmPWhqriFlkiuzRY/9ojlwAqDTTN/6uSJLhYo1AEGO?=
 =?us-ascii?Q?WlqNVJsfDt6S+/VLjXzioAimsZ1JSPnFr01TLEjc/XzDi4ivrD1OFOJ9VZ8j?=
 =?us-ascii?Q?aKKdNQvVvy7bZJc6zhnXa6TIkDMCxprJ/aykMSAuKyhtkjtwQ3qSgalZclzZ?=
 =?us-ascii?Q?2GtaENLiP49UB/J3tkSnA3m1IPBL3DaKfMxcya0hg/F1hQGwBAXTE7Iu5e+k?=
 =?us-ascii?Q?RqrZgRR1JsiGuwrlEABJ85X7QRNLiJEZ7zSiP/QNBMsdG7iLkqi0D0uf8X2F?=
 =?us-ascii?Q?1qv8BmukcF20Tih5P86i4Cf+sZUwTp8f5jgmY2rKt5NvBnbP4r6SMiDxXPNu?=
 =?us-ascii?Q?nGZ0ipSktYWtKA52nIrnphtDMHLYp2hdY5kXqJDGg7ROu+K7eS8AfmrpghUw?=
 =?us-ascii?Q?FaBuLZgLpKZPxs6pnFOA6xyMBNI0ypDG921KP7CXDkY9D5zqmNaFFp8tv8g9?=
 =?us-ascii?Q?Akbo4s0BQ7rFyTLefZkfXKVmE/AbJ5Qkmd7KuUwJcvZ1NUySKFjfTW7dvIBU?=
 =?us-ascii?Q?12S43OihTaQaDDldpSH7/ByG/J16AjbTme1sM/1Y+rFZOsRZd3HtnREdrKeH?=
 =?us-ascii?Q?/33ujycpgLlfv6EbPxzGsrySKhzDbh/qqtZHF2yHLbI6eaWMvTrbqaiaFZ0B?=
 =?us-ascii?Q?OyclO8ELCvMQlAls0X/mwnfyjESy6KzJRMqXzKlp8O4lkQTHXJ5/MAWebwU6?=
 =?us-ascii?Q?kG4GRIDtKCagNM7CFTKoDX7Q9gWp8OxxPoeKDi45oNXqhGyaH+OEm/QucNVN?=
 =?us-ascii?Q?k4m9BICklpIF9r2E//ziNUci5HUuoPvloYhfFO5zOJcslv8znXZkccM1zAIr?=
 =?us-ascii?Q?DmZcb58rxgapyyNqTjdpPSUYgpnEaBhmE0K17p+LEyV0A6ZJ2y5E8WEw6Qr/?=
 =?us-ascii?Q?ewgqURIhFgtlDGUmVvjDi1UXkjcS4wYh/qGwYgGPFzYtLdtYQThW58QuiIuc?=
 =?us-ascii?Q?oAh560ZRJbrsZE8ALtMpHKRCa5NXSksEjQj3o+k+OYLeTV9ztYW0zP3YwAfq?=
 =?us-ascii?Q?gUcuET0koRVs51Nu2vEaInMvHZe8FA8UKunZCTcmMjgluOlPMqA/ViFUqjrP?=
 =?us-ascii?Q?GiuP8uhVhuu8VRYpo6QqfLlDKvL5nECcwng/uqGfku9wHTxE0DWPImZD8ywn?=
 =?us-ascii?Q?YBaJKE3jeT37XHke4dw91ClGsiS0D05rDCErLxRQkikGYDvYCCCYII6x9rGd?=
 =?us-ascii?Q?fu1vx7ymyKE0uTxGzhy9nbO9du8rhmGGNDbaTK0jM63YYBifOBpDA6QHr14r?=
 =?us-ascii?Q?653GiXYnxqtunYGTAnFc2Dg0qd78Ds0TX3IcLoLB?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b8e2866-5b26-40d4-8ce0-08dc95139d92
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2024 12:37:46.2078
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zKyUTXMnprRUSeIDTjFSE6L9aUMsplCX8oWagyIC4E9l5r+NOscCDJDM0TQCcHtL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8946

Prepare to allow a S1 domain to be attached to a PASID as well. Keep track
of the SSID the domain is using on each master in the
arm_smmu_master_domain.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Reviewed-by: Michael Shavit <mshavit@google.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
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
index d33d97496a03fb..f563f2ee6fd76d 100644
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

