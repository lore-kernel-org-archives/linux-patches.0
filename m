Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2065.outbound.protection.outlook.com [40.107.237.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28AB363C0;
	Tue, 21 Nov 2023 01:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="sQcEXl54"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PJ2J7GCYagRQWeFUYPD+aM3Y1muL3hE7b4oxnc/xkcJ7nsAyAv1RZYmSUrIKcFzlWWe9Mz+kLsZyJY4+zaJYCFaTRpHWPzjcFdrgWJUyHrcAAYyiZhlJ6xDcdn+V1ETAbo8LdWE26KxRNgA+OiaHy384tdWJVfOIiM6cboMKQ1LE9bhyOh1lh47DbCo8u4vmiSGw6vVxmOnUoPCqpDAifikGgwxh/evM/kmLn+xu9oJQ0FQnsPjnt1Giu6C2hIH6jqjnkIuzRxboyvDN9Y0PbxdmrQbNFm4fbFc2wls987ZoCbtKG28bo8VRL5L2ncZTgjow4+7T+U1yke8Mi2RG7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Uavyu/16pjneJzgKHVl7K5yzM4SQn+b7YuZ4eI+Uy+0=;
 b=G4yXZN++g7/Vu6JzCO5QqqcJVCbBqc598izbBdMGaNYbVK1G13TyaPRaikd5G+BI0nBtV2oMZIMPYPGqULSqD5JpglFJAfD94BUJs5ue6nohXKav3YMrFDZuQiNnr5uv47PA1jy6fY+7PhBmc7ttL4JfP50sAvD8oLQbEYhnousAi++fnMtEBBaKM8wi0G/yIm/H8/cXT7TbFBUbxHUbw6sdSaXzukCSXFkcaL3N83d+J13sith70JQ1q4/Aqjdv7188HNq4AaL4RPriuFB6n7+5eOB4oYEHXT+AGlA9O73xMtE2wgl5gpBOO59Tya/RQ7x+R+L3sg+pKA8FN2WMNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uavyu/16pjneJzgKHVl7K5yzM4SQn+b7YuZ4eI+Uy+0=;
 b=sQcEXl540BbskB+d9Bam04R0Tcn4Q5QCfbefW4FXHd7UWU5K66+tePd6M/BSityKw34ZNRPeHc33GnIFrvAj0T7krSdSFCKqYV5BIZMboX3wh3RP3yMexr6uCsWesFF3rA2OqvyN4i8ZYvRDh3l2LgafwGO5M5VRfQRtU2jpwRL+lB+SZ8SmkG//D3RenmY0JALH411CekUEer98KsXPPx6SjbzYfyeTgfWAh+yGONavHZ0Tf5iEnk0i6+iXLT9/H+BnI/v8yBIXEfdaPUzqwyvqBjbZ5Hs4ByiRTwXOuo8xzrluMJ5X+qYLX/oMNGOsBPtLZLl+D0PVu4FvQjWo2A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MN0PR12MB6173.namprd12.prod.outlook.com (2603:10b6:208:3c6::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.26; Tue, 21 Nov
 2023 01:28:29 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7002.027; Tue, 21 Nov 2023
 01:28:28 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Kevin Tian <kevin.tian@intel.com>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	Eric Auger <eric.auger@redhat.com>,
	Lixiao Yang <lixiao.yang@intel.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	syzbot+7574ebfe589049630608@syzkaller.appspotmail.com,
	syzbot+d31adfb277377ef8fcba@syzkaller.appspotmail.com,
	Yi Liu <yi.l.liu@intel.com>
Subject: [PATCH rc 1/2] iommufd: Add iommufd_ctx to iommufd_put_object()
Date: Mon, 20 Nov 2023 21:28:25 -0400
Message-ID: <1-v1-4c9a7fbb5702+107a-iommufd_syz4_jgg@nvidia.com>
In-Reply-To: <0-v1-4c9a7fbb5702+107a-iommufd_syz4_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7P222CA0030.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:2e::10)
 To LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MN0PR12MB6173:EE_
X-MS-Office365-Filtering-Correlation-Id: 02815f54-38f8-4f1c-8d7d-08dbea3129de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	2HHx/aYbFHfnGD4/dJUhcKpzqwiyckce4nhJRHNpyTWOM+6d7STnZDRVBYFaKOepFEAUb9J7NMCmcc5sZFm8eK+erSy2b6q0uBBlxB4R6Q2HOmstsZXWMkW6YKvD3TFC21ofZkG+rCjITlHCeRhE+IQxL6fH3RQumsMO7okOsUYjkLd9ouWatspDvKlj/4078Kp6gh7iwKtKQ0IWc5JRyfEeK+aQIG2r/BBMh29pXzDj8Nk/3Z/5doXjhy4VURa6axHGLYZ0qOWYZGf2aKJj5vRLRc88M6t5ma1P9/6gFLzfcCI/HkOqfGlASZHr96YuRL1E5hLew8ys8qNnWYm76Yatd70MgxZgDfBuWO7xqnLiTFSQ25VP+QGsMj12u4z4qcd343obajcwkllBUrBpB5usoza6EDZz3t7NpvvGbRx72aJlehYCnI4NvKlJFf88Ox1DVM4KkjGK9H8671tpVI+k/XIwHUDTxJFdnN6cm8UXTLVgjqPOSsfH52/H92bxBCs//DFrPsuGY2rOtlYGytQsgvG7GVNezCkNAXtxcgKOo5JH+EUk+Ai76TdaE0J/ggNDuuPanLPJPfHzLMlBngbRG9WFp7oKAp2nZDqdQzM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(39860400002)(346002)(376002)(136003)(230922051799003)(186009)(1800799012)(64100799003)(451199024)(66556008)(66476007)(66946007)(54906003)(38100700002)(36756003)(478600001)(6512007)(83380400001)(26005)(2616005)(6506007)(6666004)(6486002)(30864003)(2906002)(86362001)(6916009)(316002)(7416002)(4326008)(41300700001)(5660300002)(8676002)(8936002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?s9dNBQvtUxJdi45UlVd7L0tT8DdN1M1ToKsB/cDL9vQomcm/f0vjnvC8ZHet?=
 =?us-ascii?Q?/qJPczhaTk1kSqiUC7Mp68CAAckOmI/b9UDxn3X/0Bq0Rkxpq5twvIK5O1NC?=
 =?us-ascii?Q?7hERDVqXVRa6iybi+7sHKWnecn/j0aS3Eeaip9Q7Ude+v7945brQyO9ByRIL?=
 =?us-ascii?Q?Iq2pBPgZweRG1DtdB6xGV/fzIMee2C6ENyCWHDusGlYxa9nF4OqBUig4XJkV?=
 =?us-ascii?Q?PKpZWMrp6BSE6fbvc7aF98c+36tBBqr3VuvMsHV+YVz9EO5I4l4OJlDON/br?=
 =?us-ascii?Q?YBWmxhCyAkfaCEoG0D6u0Noo2R/QovkmGCxxkkFEDn8XDBVo2FM4n0vTSlMH?=
 =?us-ascii?Q?tYlt9tSUtEejrXWxQs+OTT3JMAl9Mb60+J2CESd2fDRjDq2k+z6F0PZz1X5t?=
 =?us-ascii?Q?qUacjJam4hPaEYuXm9hQjcESlDoiriAvOuK2chxDkQk1v6kgjC4TZ7/hmGgf?=
 =?us-ascii?Q?5gVGpMnJ6taiNcsoyqPwAd6shrawKDePH3z6MYRmumNaBBGQEzMfqgjhQL6q?=
 =?us-ascii?Q?4dMD3IGYlpPfeWn9mKzDQ3ZoVTpH+tsdrAqieKGETiH69pkpP3AvSQC+VQqg?=
 =?us-ascii?Q?7ky49mdm4mohfXsjcyugz3gyaxCtFNBGmwbjMHq8w0vmirj8VSIIn7PE+QLV?=
 =?us-ascii?Q?fT4mekwANfaRK/HB3EyLH3vyaNNhIzgTRcsMgVS7cBBAdsfTAbhGjw7uMFWU?=
 =?us-ascii?Q?iJVsRJQ/Do3cTv5aNcE0R0jPpUARTugG2W8QiiVyhsuT0LpXzH/NvBqkM7UD?=
 =?us-ascii?Q?MpnQWjUz+EaHPKfGkgVyhwxfJQXEDHtUdmH+7jg4DZb04UmcRUoQh1HXVAfZ?=
 =?us-ascii?Q?e1oafTs1WsYF2jjXDosRk/lvH+4i10TKld1x3vdcDvp55wkjOZRlh3+oT8hj?=
 =?us-ascii?Q?/j99pWVYOgPI1cMt94jxwvMX8AzSkUzo3RTVUQPnFVeKWUqQ5jjly0hPvNPB?=
 =?us-ascii?Q?qwQ6pg9mIDEYnN19mJEJkEeJ3nUzeTKCIcc+uYLPL8GWYu7yoZrdIbu7I66y?=
 =?us-ascii?Q?Q1K3tJY7jEslz/FyNz/rMGLXuvzswVVr52qaMZF0I5uJUZYOHmuxCwzIC6Ct?=
 =?us-ascii?Q?lEby+2hnXWCi0uO6Sksg/vY5Br50LmGT4gVopP02lE/AhfjkxxSpJQ/Uubw9?=
 =?us-ascii?Q?80hreBuFhQkVbDqGGjgkYC7cHYMxn+GLzjMKQ/+A/8gdDf5HbpIqbyhr3dHk?=
 =?us-ascii?Q?C69PFdcbnyrwC6Qp5s33kziHAa2/mP7Ju8mDRiETL0ZOve6euyi8XlleY+mA?=
 =?us-ascii?Q?K3ilKrDtIOMqvMF4Lz/ZjHp89xqS8Ta/UkBGsKVvzBzeh3kbugNYotXVY6Kt?=
 =?us-ascii?Q?lR01ElUiX34f7mUhAg6L5zxJLXsbeLgyXOGoTxM70F8pi7DM1WMuxiGLrBWK?=
 =?us-ascii?Q?7W7VDqvkOUIyARf12WkIAzgHiBPToUQN5U7XbIuyuQLIEIsUrGKJmBQPcPZU?=
 =?us-ascii?Q?OZ/R8ncTX0d0Ac8MT8WQ66Z8EvAb7Es41rhs4Ov4w/DpC11sGq2wxyhSW3Px?=
 =?us-ascii?Q?uZLXHkiJAW9R33yY/FYg1KoFAkCp6E7fpr/fDmgw+f4JUnxEUYDxG+hq/eGm?=
 =?us-ascii?Q?AnsLZCZwlRB74SkjjN/zOaVFo75W7QDC4fhrWLQE?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02815f54-38f8-4f1c-8d7d-08dbea3129de
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2023 01:28:28.1401
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VPl7oceVpjbEc2H3VL4WvCaUkVF27jTq0G1EiOzkgjaF5OVnA026u8NmsNPd73hQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6173

Will be used in the next patch.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommufd/device.c          | 14 +++++++-------
 drivers/iommu/iommufd/hw_pagetable.c    |  8 ++++----
 drivers/iommu/iommufd/ioas.c            | 14 +++++++-------
 drivers/iommu/iommufd/iommufd_private.h |  3 ++-
 drivers/iommu/iommufd/selftest.c        | 14 +++++++-------
 drivers/iommu/iommufd/vfio_compat.c     | 18 +++++++++---------
 6 files changed, 36 insertions(+), 35 deletions(-)

diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
index 59d3a07300d934..873630c111c1fc 100644
--- a/drivers/iommu/iommufd/device.c
+++ b/drivers/iommu/iommufd/device.c
@@ -571,7 +571,7 @@ iommufd_device_auto_get_domain(struct iommufd_device *idev,
 			continue;
 		destroy_hwpt = (*do_attach)(idev, hwpt);
 		if (IS_ERR(destroy_hwpt)) {
-			iommufd_put_object(&hwpt->obj);
+			iommufd_put_object(idev->ictx, &hwpt->obj);
 			/*
 			 * -EINVAL means the domain is incompatible with the
 			 * device. Other error codes should propagate to
@@ -583,7 +583,7 @@ iommufd_device_auto_get_domain(struct iommufd_device *idev,
 			goto out_unlock;
 		}
 		*pt_id = hwpt->obj.id;
-		iommufd_put_object(&hwpt->obj);
+		iommufd_put_object(idev->ictx, &hwpt->obj);
 		goto out_unlock;
 	}
 
@@ -652,7 +652,7 @@ static int iommufd_device_change_pt(struct iommufd_device *idev, u32 *pt_id,
 		destroy_hwpt = ERR_PTR(-EINVAL);
 		goto out_put_pt_obj;
 	}
-	iommufd_put_object(pt_obj);
+	iommufd_put_object(idev->ictx, pt_obj);
 
 	/* This destruction has to be after we unlock everything */
 	if (destroy_hwpt)
@@ -660,7 +660,7 @@ static int iommufd_device_change_pt(struct iommufd_device *idev, u32 *pt_id,
 	return 0;
 
 out_put_pt_obj:
-	iommufd_put_object(pt_obj);
+	iommufd_put_object(idev->ictx, pt_obj);
 	return PTR_ERR(destroy_hwpt);
 }
 
@@ -792,7 +792,7 @@ static int iommufd_access_change_ioas_id(struct iommufd_access *access, u32 id)
 	if (IS_ERR(ioas))
 		return PTR_ERR(ioas);
 	rc = iommufd_access_change_ioas(access, ioas);
-	iommufd_put_object(&ioas->obj);
+	iommufd_put_object(access->ictx, &ioas->obj);
 	return rc;
 }
 
@@ -941,7 +941,7 @@ void iommufd_access_notify_unmap(struct io_pagetable *iopt, unsigned long iova,
 
 		access->ops->unmap(access->data, iova, length);
 
-		iommufd_put_object(&access->obj);
+		iommufd_put_object(access->ictx, &access->obj);
 		xa_lock(&ioas->iopt.access_list);
 	}
 	xa_unlock(&ioas->iopt.access_list);
@@ -1243,6 +1243,6 @@ int iommufd_get_hw_info(struct iommufd_ucmd *ucmd)
 out_free:
 	kfree(data);
 out_put:
-	iommufd_put_object(&idev->obj);
+	iommufd_put_object(ucmd->ictx, &idev->obj);
 	return rc;
 }
diff --git a/drivers/iommu/iommufd/hw_pagetable.c b/drivers/iommu/iommufd/hw_pagetable.c
index 2abbeafdbd22d8..cbb5df0a6c32f8 100644
--- a/drivers/iommu/iommufd/hw_pagetable.c
+++ b/drivers/iommu/iommufd/hw_pagetable.c
@@ -318,9 +318,9 @@ int iommufd_hwpt_alloc(struct iommufd_ucmd *ucmd)
 	if (ioas)
 		mutex_unlock(&ioas->mutex);
 out_put_pt:
-	iommufd_put_object(pt_obj);
+	iommufd_put_object(ucmd->ictx, pt_obj);
 out_put_idev:
-	iommufd_put_object(&idev->obj);
+	iommufd_put_object(ucmd->ictx, &idev->obj);
 	return rc;
 }
 
@@ -345,7 +345,7 @@ int iommufd_hwpt_set_dirty_tracking(struct iommufd_ucmd *ucmd)
 	rc = iopt_set_dirty_tracking(&ioas->iopt, hwpt_paging->common.domain,
 				     enable);
 
-	iommufd_put_object(&hwpt_paging->common.obj);
+	iommufd_put_object(ucmd->ictx, &hwpt_paging->common.obj);
 	return rc;
 }
 
@@ -368,6 +368,6 @@ int iommufd_hwpt_get_dirty_bitmap(struct iommufd_ucmd *ucmd)
 	rc = iopt_read_and_clear_dirty_data(
 		&ioas->iopt, hwpt_paging->common.domain, cmd->flags, cmd);
 
-	iommufd_put_object(&hwpt_paging->common.obj);
+	iommufd_put_object(ucmd->ictx, &hwpt_paging->common.obj);
 	return rc;
 }
diff --git a/drivers/iommu/iommufd/ioas.c b/drivers/iommu/iommufd/ioas.c
index d5624577f79f1b..74224827654815 100644
--- a/drivers/iommu/iommufd/ioas.c
+++ b/drivers/iommu/iommufd/ioas.c
@@ -105,7 +105,7 @@ int iommufd_ioas_iova_ranges(struct iommufd_ucmd *ucmd)
 		rc = -EMSGSIZE;
 out_put:
 	up_read(&ioas->iopt.iova_rwsem);
-	iommufd_put_object(&ioas->obj);
+	iommufd_put_object(ucmd->ictx, &ioas->obj);
 	return rc;
 }
 
@@ -175,7 +175,7 @@ int iommufd_ioas_allow_iovas(struct iommufd_ucmd *ucmd)
 		interval_tree_remove(node, &allowed_iova);
 		kfree(container_of(node, struct iopt_allowed, node));
 	}
-	iommufd_put_object(&ioas->obj);
+	iommufd_put_object(ucmd->ictx, &ioas->obj);
 	return rc;
 }
 
@@ -228,7 +228,7 @@ int iommufd_ioas_map(struct iommufd_ucmd *ucmd)
 	cmd->iova = iova;
 	rc = iommufd_ucmd_respond(ucmd, sizeof(*cmd));
 out_put:
-	iommufd_put_object(&ioas->obj);
+	iommufd_put_object(ucmd->ictx, &ioas->obj);
 	return rc;
 }
 
@@ -258,7 +258,7 @@ int iommufd_ioas_copy(struct iommufd_ucmd *ucmd)
 		return PTR_ERR(src_ioas);
 	rc = iopt_get_pages(&src_ioas->iopt, cmd->src_iova, cmd->length,
 			    &pages_list);
-	iommufd_put_object(&src_ioas->obj);
+	iommufd_put_object(ucmd->ictx, &src_ioas->obj);
 	if (rc)
 		return rc;
 
@@ -279,7 +279,7 @@ int iommufd_ioas_copy(struct iommufd_ucmd *ucmd)
 	cmd->dst_iova = iova;
 	rc = iommufd_ucmd_respond(ucmd, sizeof(*cmd));
 out_put_dst:
-	iommufd_put_object(&dst_ioas->obj);
+	iommufd_put_object(ucmd->ictx, &dst_ioas->obj);
 out_pages:
 	iopt_free_pages_list(&pages_list);
 	return rc;
@@ -315,7 +315,7 @@ int iommufd_ioas_unmap(struct iommufd_ucmd *ucmd)
 	rc = iommufd_ucmd_respond(ucmd, sizeof(*cmd));
 
 out_put:
-	iommufd_put_object(&ioas->obj);
+	iommufd_put_object(ucmd->ictx, &ioas->obj);
 	return rc;
 }
 
@@ -393,6 +393,6 @@ int iommufd_ioas_option(struct iommufd_ucmd *ucmd)
 		rc = -EOPNOTSUPP;
 	}
 
-	iommufd_put_object(&ioas->obj);
+	iommufd_put_object(ucmd->ictx, &ioas->obj);
 	return rc;
 }
diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
index a74cfefffbc6c5..f918a22f0d4800 100644
--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -154,7 +154,8 @@ static inline bool iommufd_lock_obj(struct iommufd_object *obj)
 
 struct iommufd_object *iommufd_get_object(struct iommufd_ctx *ictx, u32 id,
 					  enum iommufd_object_type type);
-static inline void iommufd_put_object(struct iommufd_object *obj)
+static inline void iommufd_put_object(struct iommufd_ctx *ictx,
+				      struct iommufd_object *obj)
 {
 	refcount_dec(&obj->users);
 	up_read(&obj->destroy_rwsem);
diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/selftest.c
index 5d93434003d8ad..022ef8f55088a6 100644
--- a/drivers/iommu/iommufd/selftest.c
+++ b/drivers/iommu/iommufd/selftest.c
@@ -86,7 +86,7 @@ void iommufd_test_syz_conv_iova_id(struct iommufd_ucmd *ucmd,
 	if (IS_ERR(ioas))
 		return;
 	*iova = iommufd_test_syz_conv_iova(&ioas->iopt, iova);
-	iommufd_put_object(&ioas->obj);
+	iommufd_put_object(ucmd->ictx, &ioas->obj);
 }
 
 struct mock_iommu_domain {
@@ -500,7 +500,7 @@ get_md_pagetable(struct iommufd_ucmd *ucmd, u32 mockpt_id,
 		return hwpt;
 	if (hwpt->domain->type != IOMMU_DOMAIN_UNMANAGED ||
 	    hwpt->domain->ops != mock_ops.default_domain_ops) {
-		iommufd_put_object(&hwpt->obj);
+		iommufd_put_object(ucmd->ictx, &hwpt->obj);
 		return ERR_PTR(-EINVAL);
 	}
 	*mock = container_of(hwpt->domain, struct mock_iommu_domain, domain);
@@ -518,7 +518,7 @@ get_md_pagetable_nested(struct iommufd_ucmd *ucmd, u32 mockpt_id,
 		return hwpt;
 	if (hwpt->domain->type != IOMMU_DOMAIN_NESTED ||
 	    hwpt->domain->ops != &domain_nested_ops) {
-		iommufd_put_object(&hwpt->obj);
+		iommufd_put_object(ucmd->ictx, &hwpt->obj);
 		return ERR_PTR(-EINVAL);
 	}
 	*mock_nested = container_of(hwpt->domain,
@@ -681,7 +681,7 @@ static int iommufd_test_mock_domain_replace(struct iommufd_ucmd *ucmd,
 	rc = iommufd_ucmd_respond(ucmd, sizeof(*cmd));
 
 out_dev_obj:
-	iommufd_put_object(dev_obj);
+	iommufd_put_object(ucmd->ictx, dev_obj);
 	return rc;
 }
 
@@ -699,7 +699,7 @@ static int iommufd_test_add_reserved(struct iommufd_ucmd *ucmd,
 	down_write(&ioas->iopt.iova_rwsem);
 	rc = iopt_reserve_iova(&ioas->iopt, start, start + length - 1, NULL);
 	up_write(&ioas->iopt.iova_rwsem);
-	iommufd_put_object(&ioas->obj);
+	iommufd_put_object(ucmd->ictx, &ioas->obj);
 	return rc;
 }
 
@@ -754,7 +754,7 @@ static int iommufd_test_md_check_pa(struct iommufd_ucmd *ucmd,
 	rc = 0;
 
 out_put:
-	iommufd_put_object(&hwpt->obj);
+	iommufd_put_object(ucmd->ictx, &hwpt->obj);
 	return rc;
 }
 
@@ -1233,7 +1233,7 @@ static int iommufd_test_dirty(struct iommufd_ucmd *ucmd, unsigned int mockpt_id,
 out_free:
 	kvfree(tmp);
 out_put:
-	iommufd_put_object(&hwpt->obj);
+	iommufd_put_object(ucmd->ictx, &hwpt->obj);
 	return rc;
 }
 
diff --git a/drivers/iommu/iommufd/vfio_compat.c b/drivers/iommu/iommufd/vfio_compat.c
index 538fbf76354d13..a3ad5f0b6c59dd 100644
--- a/drivers/iommu/iommufd/vfio_compat.c
+++ b/drivers/iommu/iommufd/vfio_compat.c
@@ -41,7 +41,7 @@ int iommufd_vfio_compat_ioas_get_id(struct iommufd_ctx *ictx, u32 *out_ioas_id)
 	if (IS_ERR(ioas))
 		return PTR_ERR(ioas);
 	*out_ioas_id = ioas->obj.id;
-	iommufd_put_object(&ioas->obj);
+	iommufd_put_object(ictx, &ioas->obj);
 	return 0;
 }
 EXPORT_SYMBOL_NS_GPL(iommufd_vfio_compat_ioas_get_id, IOMMUFD_VFIO);
@@ -98,7 +98,7 @@ int iommufd_vfio_compat_ioas_create(struct iommufd_ctx *ictx)
 
 	if (ictx->vfio_ioas && iommufd_lock_obj(&ictx->vfio_ioas->obj)) {
 		ret = 0;
-		iommufd_put_object(&ictx->vfio_ioas->obj);
+		iommufd_put_object(ictx, &ictx->vfio_ioas->obj);
 		goto out_abort;
 	}
 	ictx->vfio_ioas = ioas;
@@ -133,7 +133,7 @@ int iommufd_vfio_ioas(struct iommufd_ucmd *ucmd)
 		if (IS_ERR(ioas))
 			return PTR_ERR(ioas);
 		cmd->ioas_id = ioas->obj.id;
-		iommufd_put_object(&ioas->obj);
+		iommufd_put_object(ucmd->ictx, &ioas->obj);
 		return iommufd_ucmd_respond(ucmd, sizeof(*cmd));
 
 	case IOMMU_VFIO_IOAS_SET:
@@ -143,7 +143,7 @@ int iommufd_vfio_ioas(struct iommufd_ucmd *ucmd)
 		xa_lock(&ucmd->ictx->objects);
 		ucmd->ictx->vfio_ioas = ioas;
 		xa_unlock(&ucmd->ictx->objects);
-		iommufd_put_object(&ioas->obj);
+		iommufd_put_object(ucmd->ictx, &ioas->obj);
 		return 0;
 
 	case IOMMU_VFIO_IOAS_CLEAR:
@@ -190,7 +190,7 @@ static int iommufd_vfio_map_dma(struct iommufd_ctx *ictx, unsigned int cmd,
 	iova = map.iova;
 	rc = iopt_map_user_pages(ictx, &ioas->iopt, &iova, u64_to_user_ptr(map.vaddr),
 				 map.size, iommu_prot, 0);
-	iommufd_put_object(&ioas->obj);
+	iommufd_put_object(ictx, &ioas->obj);
 	return rc;
 }
 
@@ -249,7 +249,7 @@ static int iommufd_vfio_unmap_dma(struct iommufd_ctx *ictx, unsigned int cmd,
 		rc = -EFAULT;
 
 err_put:
-	iommufd_put_object(&ioas->obj);
+	iommufd_put_object(ictx, &ioas->obj);
 	return rc;
 }
 
@@ -272,7 +272,7 @@ static int iommufd_vfio_cc_iommu(struct iommufd_ctx *ictx)
 	}
 	mutex_unlock(&ioas->mutex);
 
-	iommufd_put_object(&ioas->obj);
+	iommufd_put_object(ictx, &ioas->obj);
 	return rc;
 }
 
@@ -349,7 +349,7 @@ static int iommufd_vfio_set_iommu(struct iommufd_ctx *ictx, unsigned long type)
 	 */
 	if (type == VFIO_TYPE1_IOMMU)
 		rc = iopt_disable_large_pages(&ioas->iopt);
-	iommufd_put_object(&ioas->obj);
+	iommufd_put_object(ictx, &ioas->obj);
 	return rc;
 }
 
@@ -511,7 +511,7 @@ static int iommufd_vfio_iommu_get_info(struct iommufd_ctx *ictx,
 
 out_put:
 	up_read(&ioas->iopt.iova_rwsem);
-	iommufd_put_object(&ioas->obj);
+	iommufd_put_object(ictx, &ioas->obj);
 	return rc;
 }
 
-- 
2.42.0

