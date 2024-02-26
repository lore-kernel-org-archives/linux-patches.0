Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2057.outbound.protection.outlook.com [40.107.237.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E5F212F5A7;
	Mon, 26 Feb 2024 17:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708967262; cv=fail; b=GAombRSFwvtiOzGkan5kRNE3QnPA7pptgDKuVbr71ZcS7In2E7hMfrOcENuGhWZYdQdDI832xF5F1o/yzRi3yWFQ6fswLTJPIJyTVrLILbfBFGkZdeyAS+KBreIWZ9En126TcXDWPgP14OGDG976m2wS84S3Kxoqt48Xlcm04ik=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708967262; c=relaxed/simple;
	bh=4bHS4iFaGrqyFP5EaI0AxVJpnIeCeAejvpqXTBM+KGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=AfwfzVDEfQSDg75cmGOqXmSmiZI3hvKc06jdEvMsyFq3L4KvdgfJs2VYU6CA0X2cwjWeaRv5X4UpCjF7KnW4Cg4Na3aLZwN37nHXTnigvRXdPZIwIUAt6aoqIQAGLHt9BaujNUQA7/G1WmNqhp7xUH33LZmgGrWcKWa3dogi+HA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nUxWZX32; arc=fail smtp.client-ip=40.107.237.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nUxWZX32"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zso5XF6AfMqpa1uTE2FUfkYRwggAZD9JvdOAhykIKfq5vYGfaIfgtRW5E0y4sA+VRgRA2XPZOLWWcNkQtNDsuAzu7PB5MHwnmTBHZAY8mTtxGyCpkyWuE9iniv9c9FVxbcdpG1CWioGMHX0h0vJ72s661E5aDjFjswA1UArNLYJNtjsndEppX0hg4Y9Rdcp7whTwDCgJXuM6/inCVnu5sygvD1ter+1D9xw+7Dokhks5v02mlu9csa3UyZ0WoHuDm4zFebB4MN7RsHUyTnkij6GPqWMrYpTZQXL5buGYLXEdatQAlB8/wvN8xmGhHSfI2CDWd26NVLJ6hthMQIqJEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v4j2mcTm+Aa/oMQiUnxUzj9IKjIrzKi0EFXG/jhnrW4=;
 b=UVWehrPpMS88ltc5HC+IVv9PhrRL2rN1Aer/fFNUASyPIeHUOuB0BxQMO+3pY8fxhzvEpSZEJZ8TncVeFyNPMuGk7ObzAfhKao3mJKc1ZzxEbIxRqy8EG9PiLTWjZI3QlPdFKBVTOaMFA5tPEYIa+d+tigggyTC82CGsGCD+GJNpnb1uD9QBI/z6Z/wiyZgTZI0RufkcWQOH4ha0eIUrJUs74YAbhvhkARFBtitp5LGKiTUOiyccRP08Nvyl/3RN81DLh7bHCoHJ+MHr36HxIsfD5xPIRbFe8Hqoj1bmkNSA8JVq4Yv1sqYEJXab905/mhEdupVcgPnbm1XIyodlxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v4j2mcTm+Aa/oMQiUnxUzj9IKjIrzKi0EFXG/jhnrW4=;
 b=nUxWZX32zyXOlFfFhiThJrO/zsg2B0oGHGL1+MDZth3HEhVt2iQhNh0ddWNhinY4XKJBc1wZS/4MnAxfYm2Di/zQDRkRFQW7ZVax9qR+HecNfdmGlqtubSGqJX7DtUxEefRwPVFNoUOnHuFBwthFkleeAII++POKwQZb0/Mk1Uv+k2kiymYsxyqwjC7UYgFMYnBlHGaqy95V4JE9YNr/g+G0x3XmzvNoj7i/bJEGnN65H/yqldgAuP1ru8hE4dEN0eVkOho2DFpLN9EoN9PtssXw5k+0BUpjE7CkiaAoAMMJTD6QwLjOpL0DClQX3OERzJF6FaFrAu1FRoxB2PaO4g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by SN7PR12MB6768.namprd12.prod.outlook.com (2603:10b6:806:268::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.33; Mon, 26 Feb
 2024 17:07:36 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::2e3e:c7c0:84da:3941]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::2e3e:c7c0:84da:3941%6]) with mapi id 15.20.7316.034; Mon, 26 Feb 2024
 17:07:36 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <jroedel@suse.de>,
	Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH v6 05/16] iommu/arm-smmu-v3: Hold arm_smmu_asid_lock during all of attach_dev
Date: Mon, 26 Feb 2024 13:07:16 -0400
Message-ID: <5-v6-96275f25c39d+2d4-smmuv3_newapi_p1_jgg@nvidia.com>
In-Reply-To: <0-v6-96275f25c39d+2d4-smmuv3_newapi_p1_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR03CA0013.namprd03.prod.outlook.com
 (2603:10b6:208:23a::18) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|SN7PR12MB6768:EE_
X-MS-Office365-Filtering-Correlation-Id: 71c39cad-15b9-4c55-b630-08dc36ed6b15
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	FenS+SvTsLBBCCUJKdx3/RILCblm4uYyUytKODQmZ9+7HeUVYM+gptojOigci74NKUwxQEtjKEjGTr9KlLbnEeETz9aR8DBfRPGYiCRoUJpfvG9VWR2dB49AhBk86XRFY9wOAC6HVEhIKBnQKm0E2MiGLwHvfXoRU8ubKWUtGFDPhGoF87UEZuW+DksbnGXFN0fsxiKZU4C/DdA88hX1HT8mcDYb5OC4sPmbxANaaluuRTKKkmMMzuzArHWE2BpBies3fsilDbn0gmuG7Xa5pnQvU3tSeuXSsZD97fApRuMTzDShhZvte6W4wGZlAAnYqXH6tovgpwabO4EMhXA0K1evmNmWcZ8MyaTsYaluaNpXMOxKlVykkcusPDzW3p1Uc36CxEP6kbWk5OwXtYTIvx2M8xrcE7gLnIWBJRUG4VSo2c5Hcg4scNjW9fNOt/8Hz2T8w5RPVa7v0ylUX63ukvxor5r781L5oN/95b8rmak092GZtTKSxJwh+z/VckKkxv2Ld6dk0A0xT8guw6Zb4jYnz80byfuoZMaxGB5YX4Qr+AOWMMKo2MXNtJYRvYQHMKRwmiClOJnKuI7wpcxgwK8Z40umKoWyd6/WFHkMPkmITzM5u8ebA9g+QGrns+ZJHSxPO5uf2iqVHVU/Z/YLJw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?m34TLF+KlHgLcsZe4DJLXP1F+bjJzvqoiKeFh7xebMLwpT7Lts0odd70Zrtl?=
 =?us-ascii?Q?urHImxNSBOXNdA2WX5CUrNakFBPeWThDqszRnntoZUAdtD8SD65UrOnUHbGN?=
 =?us-ascii?Q?HiLVEooihIkL+GDX6hTULisoek4hpOcdOSVskfFSfh3xtEpnf3M6AJq8omVb?=
 =?us-ascii?Q?FZDCwjOdAPcpQvtiwNqrX04D/rpzTi41vWdGh8OxEkm8Xnypom906fWFtPj0?=
 =?us-ascii?Q?4kJOIWwalyx6l9ekSixU+K1iqUSOeaaKhPYRbEdEaMiiyaGqotTx6Fm56R6C?=
 =?us-ascii?Q?G6j6F8QzLfA1d/69LzYTN97Yz88k9CIYYlgO/MEEzkN//yZdZF64FpBxPDve?=
 =?us-ascii?Q?mu9AR+H6ZtLbCJzta2pODSLrVBzqO9EBsuR/LZVkjuivhtrQTf3tND9edb5c?=
 =?us-ascii?Q?BgKjTHa3N5LH77H3dbV4RxPKTMOwNOu15ZtG0tPYrrh7pOOGFSTP5Fv4KUnX?=
 =?us-ascii?Q?0v+jOX9EomeTZ5pEfSAMSfEJnzeA5me1TyH4F/ccYa3k5yEZiXxcEPJRxHRm?=
 =?us-ascii?Q?pIcjEJehw9SFuaeO+Wlkn/HFw6erD6zmRa+SOQT1Ea+N8YxQttyWHGL9d4aZ?=
 =?us-ascii?Q?IDNr0thL/UJ37gtSJ0hXG0tINN2lQ3ibhNzTL2YGYJ3g8eSNkF9GH4A1CHQe?=
 =?us-ascii?Q?SeV3ilh7hiC6fWkvujjP50Akx7blAktOXO0rSuSHxA2F8yTB/YGvR0SiFyOD?=
 =?us-ascii?Q?rIqpLxuL5SBxa79IwzUuLmndZDdcJf3FkO0isi2kwQP7+UXed0+oA9K76siQ?=
 =?us-ascii?Q?0Tk7O/GH9u+tNEbdanJLcV5/yVL0zYKuwjtgGkYxcLyrvBufoVlZuGUR52/v?=
 =?us-ascii?Q?bWEfHAdFyxFhVhLAkrMKs4/txw8Szu5LYFppjINKV4UGwgYib6zfRb1zGjXp?=
 =?us-ascii?Q?bZYamHTyy6p+lYsmp361tobcYUNM4zzPteNyuaRxUxN0e2g06P/Kw091tZ6l?=
 =?us-ascii?Q?I775k5G5p2LEulDijhakudnPgyWONIF9JtKGH2kZhaf8bO7le5DmgXXUZaIo?=
 =?us-ascii?Q?SIaTI6jawEBQWx9OMzTg8s/W+zH161EG3tIaLifAHbDgKlZVTV0zJaeEyICX?=
 =?us-ascii?Q?/oH4NZdVXUbDg8qQIK965iEgeY/A5lUN7rVqS6njsRHwzT/l9cyIMhcewTxr?=
 =?us-ascii?Q?YGyd1w39cnsy92rlz8sajApyncLrKuc9KA7OfUQ3bIo2NXVVu1uXiEJy0zBN?=
 =?us-ascii?Q?fW/iLE9xjZh7fCEBKfigDqSKNq2P7Il4hAaQNl+iSaQqFHWkb8l+KfGa/KXp?=
 =?us-ascii?Q?elP7p1oHublHuZ/FH1nUoomvzZDVvS9XRjmJvfrsRB8+1OvK2TO0iKSUCjpv?=
 =?us-ascii?Q?/rLxdIMrbDb/orc3iOUvOlPOCHaTZONXjEcVrRwDqX1a+Xm1ilf2tNF8tdOy?=
 =?us-ascii?Q?ZMwL8mFRSriyIg/wXXng9GmJCGkFehoKrcflWWFh3RXyspvAft/4wD3UUaRz?=
 =?us-ascii?Q?/8AJDw3YDP3jedqZHnrKR6ZHd5v5c4XsGDcpCkYlIngvI6EmSQntCoFX9Eup?=
 =?us-ascii?Q?yamK6WPdGzSQVHeHZqlL8TB2WV/GSxD5OTBG2fHc3Bd2CMLn0dQY/E1Dn2Zr?=
 =?us-ascii?Q?3vj/ZEZYTpM4hhFJmFn9pFmMYAklBIA+uzGuUvNz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71c39cad-15b9-4c55-b630-08dc36ed6b15
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2024 17:07:31.2846
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DpHvcfaUHBx0fMHVLxq7qI6+1pE8XEGrFs45HDeYBB+ESZkL8q81u9aym6qXcUJz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6768

The BTM support wants to be able to change the ASID of any smmu_domain.
When it goes to do this it holds the arm_smmu_asid_lock and iterates over
the target domain's devices list.

During attach of a S1 domain we must ensure that the devices list and
CD are in sync, otherwise we could miss CD updates or a parallel CD update
could push an out of date CD.

This is pretty complicated, and almost works today because
arm_smmu_detach_dev() removes the master from the linked list before
working on the CD entries, preventing parallel update of the CD.

However, it does have an issue where the CD can remain programed while the
domain appears to be unattached. arm_smmu_share_asid() will then not clear
any CD entriess and install its own CD entry with the same ASID
concurrently. This creates a small race window where the IOMMU can see two
ASIDs pointing to different translations.

       CPU0                                   CPU1
arm_smmu_attach_dev()
   arm_smmu_detach_dev()
     spin_lock_irqsave(&smmu_domain->devices_lock, flags);
     list_del(&master->domain_head);
     spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);

				      arm_smmu_mmu_notifier_get()
				       arm_smmu_alloc_shared_cd()
					arm_smmu_share_asid():
                                          // Does nothing due to list_del above
					  arm_smmu_update_ctx_desc_devices()
					  arm_smmu_tlb_inv_asid()
				       arm_smmu_write_ctx_desc()
					 ** Now the ASID is in two CDs
					    with different translation

     arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID, NULL);

Solve this by wrapping most of the attach flow in the
arm_smmu_asid_lock. This locks more than strictly needed to prepare for
the next patch which will reorganize the order of the linked list, STE and
CD changes.

Move arm_smmu_detach_dev() till after we have initialized the domain so
the lock can be held for less time.

Reviewed-by: Michael Shavit <mshavit@google.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Mostafa Saleh <smostafa@google.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Moritz Fischer <moritzf@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 22 ++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index b81e621a8e5921..d2fc609fab60ab 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2586,8 +2586,6 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 		return -EBUSY;
 	}
 
-	arm_smmu_detach_dev(master);
-
 	mutex_lock(&smmu_domain->init_mutex);
 
 	if (!smmu_domain->smmu) {
@@ -2602,6 +2600,16 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	if (ret)
 		return ret;
 
+	/*
+	 * Prevent arm_smmu_share_asid() from trying to change the ASID
+	 * of either the old or new domain while we are working on it.
+	 * This allows the STE and the smmu_domain->devices list to
+	 * be inconsistent during this routine.
+	 */
+	mutex_lock(&arm_smmu_asid_lock);
+
+	arm_smmu_detach_dev(master);
+
 	master->domain = smmu_domain;
 
 	/*
@@ -2627,13 +2635,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 			}
 		}
 
-		/*
-		 * Prevent SVA from concurrently modifying the CD or writing to
-		 * the CD entry
-		 */
-		mutex_lock(&arm_smmu_asid_lock);
 		ret = arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID, &smmu_domain->cd);
-		mutex_unlock(&arm_smmu_asid_lock);
 		if (ret) {
 			master->domain = NULL;
 			goto out_list_del;
@@ -2643,13 +2645,15 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	arm_smmu_install_ste_for_dev(master);
 
 	arm_smmu_enable_ats(master);
-	return 0;
+	goto out_unlock;
 
 out_list_del:
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
 	list_del(&master->domain_head);
 	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
 
+out_unlock:
+	mutex_unlock(&arm_smmu_asid_lock);
 	return ret;
 }
 
-- 
2.43.2

