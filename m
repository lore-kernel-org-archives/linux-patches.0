Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC4617C65;
	Thu, 25 Jan 2024 23:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706227054; cv=fail; b=iNifqz/AiKPNk/cr9Z3yIEGnKUK1WJwMXznCdygK9kTVOvNiu+O9rWeXLcjxLWl/5meuMWS+lmaFEy+/qxmI1bmtnHiwHwyG0zaXHM/s1RQpyd+oZCgP7wk1qrURfnui6lUZLsMtkv9UVC4iIgv3Nv3c+3p0Z5kRzZEj+YBZBJo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706227054; c=relaxed/simple;
	bh=cWvGQ9w8KQDgD/85MpvD92DOO6Rc4z8xIc67bNugyaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=H8QkmMIEznk7lNjVZx+K9rXfcAls6YqMUDHZHmwRkVlhhRLJlTzcViAsEDb/s17c2nwqMP7eQgP7Z97ZitwtoU54MCdBxK0xv0RjHtnOaODjHd9Lr+cD3ECGv0aNlXhjfMMN+YtuLwlqs0cqw9FOq70WH90PXH/Ny5aOM1tmrh0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=dcJGAghd; arc=fail smtp.client-ip=40.107.236.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="dcJGAghd"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZifyElMKBkAkz4bEzgNsbVgCcbQJRZ+gMeTel4PL1nsoWbE78i9DnZOvXheaX9q3YdmFx5Gg/Z0EdHaNVxlE8UliQfZE7pZwkgHw4xaYK9qlUFBD26qUWAS+NnNZkX31OSndsmZvzNWEu4y6zzxJu/FmAVYB168oLxZgzQE2tkHCfuOXI+tuU+RHohp/JQeVZXU1RieeOv8Ehg8sRzY0P7IVMeAVkAAmXnX/SL+UpmGFnI0fLLni0zAdiX/WFG7ECOiuB1vErhroU25H1LHziefXDu6sUzE3ABxsfDNb/08VpNQOzU8xtIeub2w7PQ5MtQmP/v78380njlQQJXVVSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i+5omMpixyrBaIH7vhWbxuQzj8eGJz9OdPtAPhuuySM=;
 b=cxRZgZg/v/CLdwyuHjRCEzvTFNejku9bw4Xj9471YIzsKZQQWOWe0hKOjpUF9qwYkBVrg2njH6tDwBvguL+TWWyPis+4q1vSdKUzVie0Dum8e23fDjORDxrtma8vAugFNT2xUvJngeXEePFpwwxwTqgSlTY7aqEn7HZrxX4cJz5MDP1Hmy+bEJkyelyR5gnvhgNBA46VUDy07xWEAcLipcSf2T6Mrr/oOqtlrULjtzdYNzQADfUjKBvexw1POoEi+3ayw703Xf4fWQQAFesOuaIzaYQ1NDH7Bzd3J4uVvelbOxhjyu5/w7RlITsKb423/7pu1pjNSLe2HNPj/f5b2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i+5omMpixyrBaIH7vhWbxuQzj8eGJz9OdPtAPhuuySM=;
 b=dcJGAghdmIYZfzuDmMj+9SrlSytKVfD+mqZSVpAzhDvoMAwcyetRcxVjRZBsUkF9pE/xxBzOAwQldLBnn3Gf9IX2nYRCrbtFRcuNECzqdZEM8WcOeoYp9FJBqlSGgGUIgcl8dqOa1x4lHysLBu+wb6NXWITG9QYdalIjdyZBNZL2e1mCCy23QI9Hh0wlOpuzWU80rLsGrmLhmhOoRbnT/I8PtmJWlP+RpGJx+mDR306UTvNSu/vKJPNpN8TInbuwlspkPxI8LKl4wPdZxhODg9q946mbE/K91SomnlSZGXnPdpxdUgijckg/qIl/RINqbn4B2hP7HuXuC6fnSC+XtQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA1PR12MB7038.namprd12.prod.outlook.com (2603:10b6:806:24d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.22; Thu, 25 Jan
 2024 23:57:28 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7228.022; Thu, 25 Jan 2024
 23:57:28 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH v4 06/16] iommu/arm-smmu-v3: Hold arm_smmu_asid_lock during all of attach_dev
Date: Thu, 25 Jan 2024 19:57:16 -0400
Message-ID: <6-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>
In-Reply-To: <0-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN7PR04CA0002.namprd04.prod.outlook.com
 (2603:10b6:806:f2::7) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA1PR12MB7038:EE_
X-MS-Office365-Filtering-Correlation-Id: c8d252ee-c8f7-4143-b1e2-08dc1e0162d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ba0CxVJ69r6ziZVl0oHfZNIm8xDOC+tTkORlSOZfMgAuHMmF28t1pegwcvJy8mpf1oVQQXJfbwxQh4bIhQBcEVjhq9UTgF4nYCtFveVK+eo2W2+S7wV08i7mDlsOl8TDpYTmhoAJ6IYe+dPVK1nD9EuHPGIhSFu5r3WLLXSD83SyD0UHCFjgdrgtszT3VbDFjDEh1cAwBw0DTq7M4Wk2kUBLhvpMkKKdj03RpsBF2PpTVEo30d+LRAtpm1LswM4xNveQFDNQi4NzomWpgBI3dp7RnzG0Yp+cPhZM4Plt58CXgpnhg0N7a3Noe9W1xxfnuXGJdcQFi97c/cX1Oa0OF01WmDD9PlcAQiAxv7OxZ1u/1seBdb3f25VxSQdCCj029Bh8YiSmUH8jFgs3K9op68jn4yqApM/NHD8g7Z4e2U4RZgDl0njkCXekCxEdpYsvefBTzd2sqj2EOLNVXqrcQ/VXVP+EHO0C2WH2dxFBzFbzzqO3YCVNNMqJZlVwn6E3nxeaWZpf3lMZ9sOX/rtvNRR0a4HSoFatphZYcdCuPgqJpn5bfbulSIseQvpdpqdykHN8DL/RlLLeCr3M76klANeBzZrScRuiSqs29ZlA5h4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(39860400002)(136003)(396003)(366004)(230922051799003)(451199024)(64100799003)(1800799012)(186009)(66556008)(54906003)(66476007)(5660300002)(316002)(66946007)(8676002)(26005)(6666004)(4326008)(8936002)(2616005)(110136005)(7416002)(6512007)(83380400001)(2906002)(6506007)(478600001)(86362001)(36756003)(41300700001)(38100700002)(6486002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VyhXuag+Z6hyunrs3LkUMJL5JGKAuATTVIjTYLTSrT50QYdnIaGFpHq3Y1JC?=
 =?us-ascii?Q?igouC2TWa3MwTzWWIx582RJZOe61vSwQVeR2hPfWbcWEHe/sSDP9liCMWOai?=
 =?us-ascii?Q?tfjqkrspueSZ2MOac1tUopNAyEFT0UYUgvF1EihGnk2LyCdNBXSs9vtYyhyK?=
 =?us-ascii?Q?1HrQqq+E2tO4OlWpZAeFjpv0ojjJ0i2s7eTVQRXd72Lgdr050Ne2C350b0MC?=
 =?us-ascii?Q?pCfj/+1+ziyCiizLxxZ94iHI4vgB40Qf6Z/+9GwP7psPhmOAqW94j45AiR3D?=
 =?us-ascii?Q?HgNBbTRsWWPfiOuabOevSjbWnUp7Xn4NL6HtZjbbau5eGcG95uqsikTrOpca?=
 =?us-ascii?Q?FSUTcRMQ7HUdkFoeyMObwgdk/X+rzNUkJmEnXTMdCYJHn95RcG0Go6DBSzmZ?=
 =?us-ascii?Q?BXYJJujXMj8ELm+9TYoFotawnDefk/90yJq0RTFiGCDWoGVICTKXEBVeuWsz?=
 =?us-ascii?Q?T2HMcpILjCt75BF8GQk36uX2ZO46te1fB17YNoCGhg9VsfoIENF3fGzbykiP?=
 =?us-ascii?Q?0TqHteNalTtwDMQ2oFQIyLiDg7hF8Ho/Wqgt6MBLdMtTiHhT4yZ/0E35uo5b?=
 =?us-ascii?Q?N5vQ8cXqlv0AOGRAg0uUpG93DTWlW07TV0/2JpxWFInrxLMFqXOskD61y0+2?=
 =?us-ascii?Q?88azu35+zKFez2IByd3KasvCtFBnzP5Fuv2PvIbZcC0c4xAvOIohsVlq4kes?=
 =?us-ascii?Q?BRWfq8cKly/Uge5sIlmGGp2kPVlf7nq16yULoH52aDtm52aYO26pblPWA9R2?=
 =?us-ascii?Q?lYuSu4jbuyAuPD3Ua6/TMoQn6GPD6Eo7i8qsCSPD1raBGgGcyAdj8gS0EzSu?=
 =?us-ascii?Q?y4KjbgL96WYcEpd71uuC+szvsrRUJwD5msTrYy9lUaUC/PIGSV30hdxq1m0c?=
 =?us-ascii?Q?Decj9zR7x4EyFM3zZg8UFvVm7TnOk0wW/XmsBvkwq4jIPpYDplFZ7Ply0PTl?=
 =?us-ascii?Q?gD2a2Ma57Ifzasa0qX3zCQLism2sNdHKFNMD6NK3sesuifKVlmbKRVvIS6/W?=
 =?us-ascii?Q?ItwQuNgOiALU5c0LMZAnUSP9srlGjvLNyTeCy6OOdlF+cYh8bpjICKxgi23W?=
 =?us-ascii?Q?YWCm+ejKqVYKnhEZbM80V83TrkHI3UMFcr2nlNtphICWItzv8brFHHDzShCD?=
 =?us-ascii?Q?S+9wl3cYqAwO/BI0J01nPe5PG90lafKahMceKSk3wx0+pHhMiutYJCkEsRIN?=
 =?us-ascii?Q?5uCPlKZWfnpHZkovxsyfWVAE0l9gElcqUuq72CUB/MpcvlG4layF09sYpSmh?=
 =?us-ascii?Q?HJD8SqZGFRTSgzacCN0vXt5nQELwE1h4w8qHIcL0dQwOMxlpOFqSWWBV8kws?=
 =?us-ascii?Q?zkAl+UOXs0g5jv2l6QWTiCdU5GdQNusvqKnvzpADB74hDuSbo5KH3lZoCqzS?=
 =?us-ascii?Q?JGTluvupBxNTbCAdKX7wWC/xY+0DOpxZ64oF1SU3iQonspgzFkroQlYllBn8?=
 =?us-ascii?Q?kraGs5rOkbwAl15IWNP3RzMMOzfvnd6ZqYevWcBMZq73n55GqWI3Jt2cNhgS?=
 =?us-ascii?Q?2XBBX0VsRsYTCn7ym28yBfsqyNGHYESr48hc2Dqh3GW6hDveIHScTqN1hHsg?=
 =?us-ascii?Q?hU3KVLH9wq+KVeQ61Oy2RfMjH7sAbP6YPZ+ywMLZ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8d252ee-c8f7-4143-b1e2-08dc1e0162d5
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2024 23:57:28.2966
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lr1aZWC7yWbEyk/DtR5vgTb5jvfnt54M1BfRjqCs9HPdMT7r+up0zWeWS3hNV6wW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7038

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

Solve this by wrapping most of the attach flow in the
arm_smmu_asid_lock. This locks more than strictly needed to prepare for
the next patch which will reorganize the order of the linked list, STE and
CD changes.

Move arm_smmu_detach_dev() till after we have initialized the domain so
the lock can be held for less time.

Reviewed-by: Michael Shavit <mshavit@google.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Moritz Fischer <moritzf@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 22 ++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 9a95d0f1494223..539ef380f457fa 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2612,8 +2612,6 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 		return -EBUSY;
 	}
 
-	arm_smmu_detach_dev(master);
-
 	mutex_lock(&smmu_domain->init_mutex);
 
 	if (!smmu_domain->smmu) {
@@ -2628,6 +2626,16 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
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
@@ -2653,13 +2661,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
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
@@ -2669,13 +2671,15 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
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
2.43.0

