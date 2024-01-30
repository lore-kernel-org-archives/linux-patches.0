Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2073.outbound.protection.outlook.com [40.107.243.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABA877993E;
	Tue, 30 Jan 2024 19:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706641444; cv=fail; b=V9ekWNTdTkRoLJIJc93xHY526z46vb677YC1QWZEdNlnNc7JD9KsGCCcgR5kBaTd+xVfx5fCzQuMfv9aMZntFqTaG9RXp0aqxt26EsWsj7ITSLcPc544P/niL1pg79XjCapam89JrxwHhVnvPMhB2Dox7JQ5ENYfuDhOO7A1ONA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706641444; c=relaxed/simple;
	bh=GjRGrRm7TjdtsCuienZqRCyvGx79EoBOktb7zrbkI0Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=E9J7tsK8btJxrYCPLlmJBGW6bs8+NbTxaUu+oX6+YkBejjIvzjKzU8gfq0BMJ/ls8R6ncziQUQPRfbkck7UuHM7xQtdUH6biJcFqIIpy971vGxqUYvnzjY6QyFbSwokI2sS14GwUR5mZiDqbq/sBW0CmgGSUDeRgVLFBEfvTclg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=TBHiPXHf; arc=fail smtp.client-ip=40.107.243.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="TBHiPXHf"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FmIfknBkUfXDFzZG4pNgRr0D4XHQUHVb/6QDX6Iwj6DTidTHjriQwbuy2nZt6zYSPof3sWp2VomSdkUPaII6Wptt3Au8/PRKXabGIHmmM3aQyq46ERrzstbg+L7MwDgGXM21JRub5JIK2gR1jnpo/BNM/YOLabwxKEdydBd6NzNbGa0w6+uPBOu+49CRkA8qN6yh7wjRUxS3i2w5cegKBZx9wsqtV9T+6qAKPbeWpVq+5ace9iqtuEyGl7lSKh68VS3Yjo2JfA6OoxWtLQ5/jPmbCwxKHOo1CCg67xzsEYORmCuyX8dWjTWQePvk4SMS30yduPbmATK3UKXLUBe4Gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZGAFqzHQxWx4rhSZBsafxNh5bAM/MxMX6mKAfP8LZlM=;
 b=kIk1Dj2R9VXd1honHoDZacIS1bs4BBwx5ZJSlC6yyffPlhLU3dlzc/BChzrj6+ZS96W22ZZeGTacdBEkR7OQ6I7s3i7opDxB5sx+o9ajT8Z+Nc++nMKFe+r8/4FO+EK5Um6V+D8OIc+8I2p3fWx8ZBPMWn8oQa7VjHSfhcR/afzPvYkA08rY/4dNiwKMQPWH4a+gEyBSEsqGQrHh6uAHgKeJK4UKAykq/46yAVI1Mr+2ylTQHzjzz148eOatp0hOHlEsT/u1tcxPXXuUs3bp81tTRWWRrnh3zGzbZEuio5faC+BvRsVte5Gk5bCO/CVxco3gXevGm96jhKjkVRvoMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZGAFqzHQxWx4rhSZBsafxNh5bAM/MxMX6mKAfP8LZlM=;
 b=TBHiPXHfRJut9Xp+CxjkHPfaXxypSXDIrPx0RS4P8WDmAwY1rGGOaLbCLvWksjWHSdt3BDCKPu5gPqafMrFi0xwEK1RAuWHTjzb0iaYBTS2EtlTU9goDghbs/FTv7vILc+rlPIi5xfx5Y59dOKX0o6E/K101jYo9qRFL1SeKlbIWpfBlfDJ4MpLYLalOd+J2S/a83rzLJFyD/Yuho0bqSiIVxcA7AjtJh/00r02u17BoD65LTExvBWRtYlql53SM3fyRMznnEX8QqYJ7GhuxhSSLuWSEDAj3dZ9duN1cIHs8uj9lrN8FNme/xKc2tmeTL1Db9I9vgs8tyugNmV6zCQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB6091.namprd12.prod.outlook.com (2603:10b6:208:3ed::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.22; Tue, 30 Jan
 2024 19:03:59 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7228.029; Tue, 30 Jan 2024
 19:03:59 +0000
Date: Tue, 30 Jan 2024 15:03:58 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Cc: "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	Joerg Roedel <joro@8bytes.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: Re: [PATCH v4 01/27] iommu/arm-smmu-v3: Check that the RID domain is
 S1 in SVA
Message-ID: <20240130190358.GE1455070@nvidia.com>
References: <0-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com>
 <1-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com>
 <b3a7b564dcef4b518af0493155b67cc6@huawei.com>
 <20240130160430.GC1455070@nvidia.com>
 <c8cf99b2532644de9b38c44019bf83a2@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c8cf99b2532644de9b38c44019bf83a2@huawei.com>
X-ClientProxiedBy: BLAP220CA0018.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::23) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB6091:EE_
X-MS-Office365-Filtering-Correlation-Id: 75ff0ff4-63d2-4e14-dd97-08dc21c636ea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	OVPUKzOrYlxBcW6/yFN9wUeTDyHSIRabDRvwcvdzZvRXrTCp2/cAe57u1IkBAt+ovXom/6LMtiglrHxTyQdb43XWFjIrRunMzhpQVW7zKaFMfz4gLmjU75p8CY0N9EGWOCjuh4hpDzuficxlK3NihADyR/UBQ/VKp/syhpUv14HHe9cGoEvd0CpN+OJQcsjZvEWqno8TperQxqrmsySUp/9AKYfNwgoCe5AGIjp2Op6LRlF6ZY2UC9fDLMn5r44oeEun8Evq+B16o9G4VTbkMRDirvxkrvOCsKl709Ym81pwMQxePwv74oIPsK0Ey3Dx4wE1AFXtW433BNSzUNwahw+yuzZl3cHgbvBatLV4mzwBatqekoUNrvi4CCgiInDrvMAFYskrho70mwRyX+JfPi1ly4CBO4l1wksTiRzfEwgPl3vxJnZsoM2AtupgjnCcUlfNdviu5vGyu7pMFQZIoVYvOLzsbVBle1TZ8pKB+ECnmhomMoHzck2TipyxNrckjbAAeJnod+Q0OGOZagyIdsfKf+/kBZ/EmRQHCUESG+woRkMPrxRPNa8M2JaAq40g
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(366004)(136003)(39860400002)(346002)(396003)(230922051799003)(1800799012)(64100799003)(451199024)(186009)(26005)(2616005)(1076003)(41300700001)(6916009)(36756003)(6486002)(6512007)(6506007)(478600001)(83380400001)(38100700002)(316002)(54906003)(66899024)(33656002)(5660300002)(2906002)(7416002)(66556008)(66946007)(66476007)(8936002)(4326008)(8676002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6n7gtnaCMZjouZL0xyfQeOrkEodFDYGXRYM/Cn0NSXKx+KBUYDVbTOct9PaQ?=
 =?us-ascii?Q?BVn8pXWB2IJdd62jO0OjXvDjDIiUOmc0QZiVybsdPtzp6nAzilM7VcpboZxy?=
 =?us-ascii?Q?1VZLRpDGX/GArjgOXHDJcylxcoAO2dR+rzsYtOPxZpvQgoYdWlp7tAHUySY5?=
 =?us-ascii?Q?aba++YOJdT98ZgJlNymDVMwdAlbER4QGx/AnHFe2xHA95dr4MosUo/VC9A1s?=
 =?us-ascii?Q?MMI95JlYNPrfuvf19cBuvRFeBY+TbMe1g+GOeX8m+Bv782rOUg4pCWA4yysQ?=
 =?us-ascii?Q?aRwCOYckH5nCFS15KLNSeglN1QzZezdAv6gtAQCIdIei8ogSKlm4UE9AbvIA?=
 =?us-ascii?Q?LdYa6S7CVWjcTJFlbEvgqBqDEqJnTRdU+j5mcaic44/wRwTFSLg1c2ZPq6/q?=
 =?us-ascii?Q?E9csY0v8fx3D+w7wzABDj9j8YlT/em8BKkbBN4LZBsw5PFLqGBpArIpj+2N6?=
 =?us-ascii?Q?NRqIp/7p1RpR+Y4yvjYpeiZAiQ4EK1F4dO1OHJgwSRZ2h8VeeHKsyIdcOJmJ?=
 =?us-ascii?Q?fRjE4Bhwadqr+3i8dAQhQho17cNIk0VZbGYU+sf7Cs1H7YQ4oT5pq7UoL6hT?=
 =?us-ascii?Q?jO0u//WdQYkTGs0SWtQLsMRcRtUhuXl0PP4zu15WL6lNXqIxMgBPAwyZRqU6?=
 =?us-ascii?Q?ITH8+l1kN4jEg1WzfaFi6DIafYofQ5wLmZ5J1+7y2jlDzBTCjYBGFt0QeGpf?=
 =?us-ascii?Q?dgZf496Iua5GJU1DFvPDK4m8rfbNbGbjv3Fdt6M2+dRbamvKdSYaBZtV6aS9?=
 =?us-ascii?Q?TA8Pbuj+LxO0GgKYDWV9hBTpXeHQAZGYlUyBerJc/jfaikXyPgobIIpMda4Z?=
 =?us-ascii?Q?PvrIrQgEUpF/NJgboJN1zXbIjzeAFrdIrk6EqnSJWGlxgsBfeoYtZICCeXYB?=
 =?us-ascii?Q?wuI9378po+CxqHUT8ww/gyAhikWaLaBa7mMi6UK33i6UpIioL8J8vWjVA7T4?=
 =?us-ascii?Q?sxHJEnTAOMCu0ZrKy/8apSxOm0G1bsqmlPrr2SFtYaTQsLLuPspNB5LNbWYu?=
 =?us-ascii?Q?TlHxNXGKoin/q/qW0cMKXOLP62km+F68zxD5bk/jh4W2+pgUgTS1EGfS5RBC?=
 =?us-ascii?Q?YdU1/qbKWp9QBIPn01R+Ll3uy8vpuCLd3IezjzyVv/I9hfygN8nC+I4g26Mw?=
 =?us-ascii?Q?j/UQQ6doIXp0Mz84jymY2zarIOEWukCSy2SX7J8PtmsqzD9JPnn/ACueindH?=
 =?us-ascii?Q?RKYRs0ZsNk6moqB1mYm1gJWljqX+wOrMA+1GQonbZIqXBVsHmKinwnRlM8Tp?=
 =?us-ascii?Q?4+rsQaV5x2xjR6f5yrl0Vrrcn6QDVEkbnFsybXBN19+RnqyZSs2a+FsLF5th?=
 =?us-ascii?Q?gcwfRFi4Yn2XlXIqGMNifCHGtzmKgJF8KxyiZLlYUsilBbf8iqTgNDR/fKYy?=
 =?us-ascii?Q?vLIWGK4vR+4U48IXfutIS0OTAFH8zWQ6k+ZXt6LM5Kux1Pokc9UamE7mFKSs?=
 =?us-ascii?Q?mXfBxgIOPaX19mceGy2nT/VWGhI4fsTKIw3xQyhvV2QCNMKYLrOa3eRUUuLl?=
 =?us-ascii?Q?PHdHZqwBCXr4YFa4SZq/iruPiRsOZgYIwdFYnrbIoann6FtuS5SRn0Y6A097?=
 =?us-ascii?Q?yCd14es/M5uCcj87uPxxAh9qRe11qDF6FzPp5dCa?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75ff0ff4-63d2-4e14-dd97-08dc21c636ea
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2024 19:03:58.9518
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CZ5//3xBowkPSWxIhBWC57iX06lBEBeOj7LcNZaMV3Izz1/+RWyChf0+NN+41xUx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6091

On Tue, Jan 30, 2024 at 05:11:36PM +0000, Shameerali Kolothum Thodi wrote:
> > 
> > > > +	if (smmu_domain->stage != ARM_SMMU_DOMAIN_S1)
> > > > +		return -ENODEV;
> > >
> > > I think we need to do the above checks in
> > arm_smmu_sva_remove_dev_pasid()
> > > as well.
> > 
> > The core won't call that unless a PASID is already attached, meaning
> > we already passed the above check in bind. So it shouldn't need to be
> > duplicated.
> 
> I think it does in the error path.  See __iommu_set_group_pasid() call.
> I haven't tested what happens if that returns error because of identity 
> domain and then __iommu_remove_group_pasid() is called.

You are correct, but this is a problem in the core code :(

Driver should not have to deal with this unbalance. A set/remove
pairing should be enforced by the core.

--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -3481,15 +3481,24 @@ EXPORT_SYMBOL_GPL(iommu_group_dma_owner_claimed);
 static int __iommu_set_group_pasid(struct iommu_domain *domain,
                                   struct iommu_group *group, ioasid_t pasid)
 {
+       struct group_device *last_gdev;
        struct group_device *device;
        int ret = 0;
 
        for_each_group_device(group, device) {
                ret = domain->ops->set_dev_pasid(domain, device->dev, pasid);
                if (ret)
-                       break;
+                       goto err_revert;
        }
+       return 0;
 
+err_revert:
+       last_gdev = device;
+       for_each_group_device(group, device) {
+               if (device == last_gdev)
+                       break;
+               dev_iommu_ops(device->dev)->remove_dev_pasid(device->dev, pasid);
+       }
        return ret;
 }
 
@@ -3538,10 +3547,8 @@ int iommu_attach_device_pasid(struct iommu_domain *domain,
        }
 
        ret = __iommu_set_group_pasid(domain, group, pasid);
-       if (ret) {
-               __iommu_remove_group_pasid(group, pasid);
+       if (ret)
                xa_erase(&group->pasid_array, pasid);
-       }
 out_unlock:
        mutex_unlock(&group->mutex);
        return ret;

> So as an exported function, still think it is better to check for domain
> type before accessing smmu_domain there.

After part 2 the remove path doesn't touch the RID so I prefer to
leave it in part 1 and it will be fully safe in part 2. It is just
more code that part 2 has to remove.

Thanks,
Jason
