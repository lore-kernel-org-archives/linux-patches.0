Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2060.outbound.protection.outlook.com [40.107.102.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD99A4C60E;
	Wed, 22 Nov 2023 13:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="tHW9CRYW"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qb+3FFh1zNhmNPnxlI51Ky811wyoKLOzJsnU6OOtrUCcLTcfyacpFAO5UrasSzunl30PEu+o5xecavx9oowdGYxrJuk5dRWFwUyo+YWwWNuf8PHBE+kgtlUWyjOE6ZB7Amg7dUYTEhKW0NK/LWFLMKk/hOO+Gm3VoiIOTUEbK+ZdZkD1YD7OJtXfmcraRGhzNAiH+49XYketiSqirka6TX6yhrF75wefAaXAn8mp3R6cBU0ihU2mJ9KCsLQDeNzlr/hbXLrGSb6GYireiAYYLcAyZBMelKA+yn0pnO8CFq+uI25V1yXbRxIBWoHAPr5J64NsHiF2otmscS94DChnpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l1Eb9lqGUj4vmR7+/xXBrjtM+zgRgcTwcNDv6pQgGIU=;
 b=dkDHBM0cLKu5FubcnSuIF9uz74trjT0CXTDdllAViccgK/jyB6ljWFooN/ovVSKqkjIC+eW1HonzWZOpGB7o3zWuOUlxiKdEdZAXUBksfXRy242ifKM0wjmKLXNj2i7Gq5l9EiAO4oOsF635dwCjoLoRfWhMTFvm7kG775ugJPhaSH5+h4PttneTpjv6rSDyHJwsy/7P1meoMJ8W7zMP0qE+JXniWyZlXQ8ftbONkqx01H+euSaG9RX4/pNoysmxf2gzydNCwT9QCns6EY6QaS3Vk4Ie2floHXteHQBmVxinAeI3sa9K8DKCZ30D4IVu6FDQ6SoJUAHfyCgocNnZ7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l1Eb9lqGUj4vmR7+/xXBrjtM+zgRgcTwcNDv6pQgGIU=;
 b=tHW9CRYWYuowbjK0Nr9wXDZ/uLEC3rAfz4FgMbZqsN09uFCNGA4Rl2D5UTUF0zpsEOt9S4r1EoGwiKHVQGzXFVTs6GWImAVD3XkZQJ4seB9GXKcuWvUYAAvzr80fyb/kph4xFG8YD5BPJdD2kBccqgQn1vffceltKfQER2EbzscrcFQm+q08tzjZZwYJkAnBBvBIDzZnyTqkB4AgiqKbipgc3fPxXTiAAFSSXBljR0PYfWeyRSju0eTJXhCGluN8hcVbFZBetSgVS7np7rILOuCTUhiWEpK5beJKNol50ChuA8K4DjKGbhVxaOjI5uHrH2Ubrj2UQP0vcOQXwgCicw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MN6PR12MB8489.namprd12.prod.outlook.com (2603:10b6:208:474::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.28; Wed, 22 Nov
 2023 13:13:21 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7002.027; Wed, 22 Nov 2023
 13:13:21 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	Eric Auger <eric.auger@redhat.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Lixiao Yang <lixiao.yang@intel.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	syzbot+7574ebfe589049630608@syzkaller.appspotmail.com,
	syzbot+d31adfb277377ef8fcba@syzkaller.appspotmail.com,
	Yi Liu <yi.l.liu@intel.com>
Subject: [PATCH rc v2 1/2] iommufd: Add iommufd_ctx to iommufd_put_object()
Date: Wed, 22 Nov 2023 09:13:18 -0400
Message-ID: <1-v2-ca9e00171c5b+123-iommufd_syz4_jgg@nvidia.com>
In-Reply-To: <0-v2-ca9e00171c5b+123-iommufd_syz4_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR11CA0042.namprd11.prod.outlook.com
 (2603:10b6:5:14c::19) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MN6PR12MB8489:EE_
X-MS-Office365-Filtering-Correlation-Id: c3aaac86-dd77-4a1f-91e1-08dbeb5ccce6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	CePgDLWSgDcHEk6zjU2IvBsIsQ5wz2zatkP1rLjtugD0uWIr1FbAOTemRhL+0Ata5JYedoOlAATzdDEpqp+T+UVSspCmZH9kLuyce0Ed8b8+QDeH35wOusUSQh/DIAoX78paUEQ7sQQOFM80OqrWEWlj9DVEFQfp8XSbcpNuvocH2+MjWjJIE+ZGvqM/KTaxBCMKhGOmpuFbjJ92E303AtG4xP+xaTJxySMGhTfQWyYG77kAd7tPnItUkQtMaPw4szHkfWCnO5CnFgq16jhKKQax1Wrwlm4t9mavr9jbEzRgA9uWScdA2Mu/J+v5V76hNQojm6Xdh5hdWuUWpvDR85Z/r2We+mAzPBcwBKJJFespuaxiCND+D7KJivmVqArvgzbPaLHNlxxbuIHs5Qu2abzIvezPFzz1/sWWF8NUluX7LM5RnARuluwSISXcuT40zBIGGTYjgc2ikgZuAZQsBrKdU99Txx+mFEhcuvhlQiCzShUIY2KD9uLWvMmiMAsdKRGRtGGBHXHgq+RZaIf4oAjE7YkwKOV44XZ4o3tRJx/DbrLCk7Z8qSxs8O6tDvBW4hKpCFYm1pJdXb5zJFezdTOb6MUd15QH9iClWgQnDZk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(396003)(136003)(39860400002)(376002)(366004)(230922051799003)(1800799012)(186009)(64100799003)(451199024)(4326008)(30864003)(2906002)(6486002)(8676002)(41300700001)(8936002)(2616005)(26005)(66946007)(316002)(6916009)(66476007)(54906003)(66556008)(7416002)(5660300002)(6512007)(6506007)(6666004)(478600001)(83380400001)(38100700002)(86362001)(36756003)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jYyDAuAFRVV8C/juO8xNi9ha2qYPxKEdFbnN+JZJQN9rUS3w8YihB5IRg2G2?=
 =?us-ascii?Q?TugJZJ4cmOacLVsUhbeqcAZehITEU3iHTjlP2yu1ai/liaez8OoDIRRxHGiQ?=
 =?us-ascii?Q?ywaDgB1ypCCY/Ei8ApH1QAV+LW1NPUKemFq+7m4D1VB/3QOfCF7jROc/iwu4?=
 =?us-ascii?Q?9X+aUZjqkLpc0afyIgnk0TM4JcqUrHCkD4K7c2OvpizqF+vjxvte7KUd626Q?=
 =?us-ascii?Q?Px6/WoixCoEH/nUJc8rSvzqj5Ex7jkczXwHpQMyMhz1eR6TjrXXWalnrIrLL?=
 =?us-ascii?Q?7agJ7h5U/2n3p7soZY6nUvPLBUZiwaI3ljyyqEDlMhuc+DuxLOqItlCqT5vH?=
 =?us-ascii?Q?YB77U7Iycxm3oUjSUHRbyfrbyGVhDqfvplNCV9TE0TYdoOc9vF/oiwAZzRws?=
 =?us-ascii?Q?pqKE1AO5P1dG94NusDuOGrgxe9NwHMCcNew5wboHbVb+mTnei2Iceifq43ov?=
 =?us-ascii?Q?j2aJWd4+iaw0PBt7fQbOw+qNANn+55ykbud14QplYqMJ43TMHWf/4OHn99Ht?=
 =?us-ascii?Q?S/jXHOmzeZnK6l8UO9Zan7+dWs3ku6oqdE8G8Gz/no7YOU6fnvqsgf9OGgVQ?=
 =?us-ascii?Q?/7eVpt2n6vjX1hnUNoFtYF610KuAT9jt4WEzYHqwaFq6WySOkmysRLQNo3Ny?=
 =?us-ascii?Q?ruo/VxDRL3g0inb+FBymeBnDveMF/pi6pWxizViaUs7nyCX3IxgAQer8FLPx?=
 =?us-ascii?Q?+8dcJqMrBfcECDqHwv1yu422XnMSW24xX1cpbWfne1kvwSmEzGWt/5vFWrIS?=
 =?us-ascii?Q?CpgFuZ7sEduBoENwyFCAYDq2Wwmk6DlS6+3YoWNj5eABdoTBFgegqS6hgmFD?=
 =?us-ascii?Q?FOlQZtLIhBlmBh5UN58o8N9pDHXaWNJxUhxsW1D8XK4MMLpt8yaGhXj/s1kf?=
 =?us-ascii?Q?IiJEeppY//vjuJ35XOKV6GJksugFJ6gxnP+Xh6BTxYtW+TF7YYDeJqQvUJUN?=
 =?us-ascii?Q?7IVcfaaDI6dXMiS1kI5rjexYG+9+KlqXM93LlPT7iEDD2Mz2GAWp6K9c8r3E?=
 =?us-ascii?Q?f9oIuf6sNO0SRP7oaJiPVkXwMuP3ekdM7gOow5Wx4LKu28cLJ7mZ9PNgc0XT?=
 =?us-ascii?Q?Gl/gAZ5Kuh7pjyAJ7blL6S1s2x/rIOB76084I11GpU1Y8HTO34nM5Q7hehJB?=
 =?us-ascii?Q?w3aIlJ42wjiuak5Art1O569xCmI2Oy8v1+k0wTnBLLpZ9MTTGJ2m+i0y8xAU?=
 =?us-ascii?Q?ZxEJLTjSUmMBAvVx9TJaSvomCUWn+JcKteB/K7ncdU7J7Mdd+b21qV0mpIUA?=
 =?us-ascii?Q?nx0evr4zVaIlBJLHwZa5Y+0C/Ly40qf37x60kIxnWUtVePP664s4qXaCYFMa?=
 =?us-ascii?Q?UryRuqOkwoN94sxV1lA5OHf1yx1EmZ/wsuMLtbIiuXcRYCenOjqPdDwDVQ9S?=
 =?us-ascii?Q?fWX6csrVMW0hJk7XMXGpkEGZQa/Prsx1wP7N1LStrbWVUNBrZLwPVXDaETl+?=
 =?us-ascii?Q?0XaDe4HGEzMC7KdDxHtJev1LFPnHSC2jIcsrOSBSKXvtJjLOaIMX3y4skzsl?=
 =?us-ascii?Q?jajbyv2D76W0SBs0H0OSyIHCJHYeL2Xwf9OIz617kN4RAReX0NZbAPdZfqc+?=
 =?us-ascii?Q?q3w5sBpTZ6CvzzKMLAJg7e2Gkr3JIJstxia+9HZl?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3aaac86-dd77-4a1f-91e1-08dbeb5ccce6
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2023 13:13:21.2466
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7GPr0yPplnMh96DOgGfmYC25v51x9osnFm3jV4VnvbJG5LYS+CbNpWHvMDZeUpwj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8489

Will be used in the next patch.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
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

