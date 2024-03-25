Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2086.outbound.protection.outlook.com [40.107.237.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 181FE10A3C;
	Mon, 25 Mar 2024 16:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711385243; cv=fail; b=QtjJLew2bP+AylVoMZ909/MA0Jd5GjMmsX30rclcBy+S4GrsApiDIWt34YQIVLuSHFlOje4Mq+Z9Xu0eMrvfb2OkynL+pgcnri736jPM5T9XVwSA7SlLMyA2DmW1x+ePMQ3Zda8m7eCIPMlKSFWHU8yr7rOH6B/vD9z7mhWZVGM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711385243; c=relaxed/simple;
	bh=5Y1LRUmKroyINtfhG0Mv3zVG6YiytKtNpUprTqsyAOc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=H5OvpaIl/5Wlivk3WVUjxJLCDPV2ol7CUApLnxh/fe9Zhsi9SaybRu/vRDCuKfKjqO6rtt51/f9eRuif656geUBQIfwa5glY2+rlkA+IqxlZnjJA2AEK4qr0sfoQMBqBT3Qn6eStPhyxmQHoB/nM3Sr4ja6BooIbgfEz03uI37c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=JVrd+OoD; arc=fail smtp.client-ip=40.107.237.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="JVrd+OoD"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MORnNrc1rUgW5RCWZ4vSGcvIzUhHgHBo+EumAJJlyKAlvYbvsLW3iDd8Yaab7S2rzy3drMJ/8gTHvc9RooA/XO9OMLTl1KdsJ6ZOID52ND2xegWboAOpm3atVos0IWQIqACSTuvsV+iE6Zhgq6TM1oxcZoYoVkhpSoWescYDCX7VJ7J4nQC7pS5m5tQ7EogcK/FqihwzEECDWkgsQxpbz0G1JVh7uLbTznSl4I82ODzgBu8op6/gITttZxEoWqpad2o3IRIsaBW7DZB+KcTDKl9PaEM7gQFYmiD/a7ZLq3mhWx2M5smJwVwXVe8Ul44WZlvfoANtEimYqPimSClRow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yiwHPwzCR4lhfsrE9gsnrb1BmFB69QJICRxYzpux6a8=;
 b=PWBz5u43rN9Y7JE18+O9ypDKcx8nE61kMwEVCsxleTCTd9stZZYHzLLfwyslESnBMUDqmMTXsYKtYIcfCTPLwoalCEwNsPLZG4ZsOMdENwlPmtTzR9tcltrR9P6q5GtcKEAxQI8ivD4DXox+MfT8ziuBvHz2SebpPvovZO4O91KhYxTUJ3VJ0uIG66qKVVtgMelHL3plOqCvjWDzmw8T7f5H/V05qbxs9Wsg/KfCuPxU18m1nITnC5B93ylIlhpa1joDuuEKGIkHllafuJTxQwiHip6e4oeIEJ9wtKjhrWbzERuIkpZ8Dg6Vxd7Y5od3oZVGIEKfmLEXEilz3JShzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yiwHPwzCR4lhfsrE9gsnrb1BmFB69QJICRxYzpux6a8=;
 b=JVrd+OoDOLxvhfj53fYGFr7SxvBIrMmQUlfVMFuWeFkSGreSltfSwjqQ/yHgs4SCWc7kmJcJPWhHkGzsOoYOd2t4hmLqJl/xbqKUzYJv0jsvqlcii+zoL2hL2hAvnQVOGhc6LTxou5FAuYhzvo7cKm+gAVStxh6fmUh1vScbqQfoxehyT2FFVvMeMomhcN3py1dC8rloGkVvLcQie5/phPbV1F3dsLuPhJJ3K10iEji1tO4M0y8QxiqhJOSDP9X3MpQeZZ8qqgCmYqQoFVpHQ3JKvgGBh3mMrrU8a/MgnxDrr+8TIyloRxq8TB1KlYPP8LHRfoNbQ2BnOFi/lA2Jkg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by LV3PR12MB9409.namprd12.prod.outlook.com (2603:10b6:408:21d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Mon, 25 Mar
 2024 16:47:18 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7409.028; Mon, 25 Mar 2024
 16:47:18 +0000
Date: Mon, 25 Mar 2024 13:47:17 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	Joerg Roedel <joro@8bytes.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: Re: [PATCH v5 00/27] Update SMMUv3 to the modern iommu API (part 2/3)
Message-ID: <20240325164717.GG110546@nvidia.com>
References: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <ZgFQVy-gIJJKL2IG@google.com>
 <9819d9f48ad64fb8a704a0a779010581@huawei.com>
 <CAFgf54qSbNMQ1XTnV-YSZV=gqwN+JJy0S5ziv=fUfinOXGZ9jw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFgf54qSbNMQ1XTnV-YSZV=gqwN+JJy0S5ziv=fUfinOXGZ9jw@mail.gmail.com>
X-ClientProxiedBy: BL1PR13CA0201.namprd13.prod.outlook.com
 (2603:10b6:208:2be::26) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|LV3PR12MB9409:EE_
X-MS-Office365-Filtering-Correlation-Id: 6990d923-91b2-4e3b-d6a5-08dc4ceb3ba1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	RcsMwcKryT8vGUkYxYoxreNTU7wDAIbUzeomEmeFDwO0RUpC8I+NZS57JB7rFFgQXNQ1i0/9gBgZcpjzLAqDXLCEl3Ly3cB6mg/C6//ItbviQt/Ghelax1OkodKWE0QxKXgT7uzawv5CxfV1sCoD7hgMXeXvBgpLHlL/y8ca0OlISXp/RyaVdZ52FKRPvJmXkPZ6O9VhiexOBXIVEQY2wJ6HegbAcNqDHdnqo3mtKsB37vyNAQYWyvZ4YlR7oDiiynFmjVr1T4ho+fTbN1Pa2s/GMfX8S2wch7sSpEMqgtJHhr5aPGM7b0x4co0Clz1eUIeka9K1THDPxm5JZTGMHo5ooPjMayyAikvSDaGN41guC+Xm0dtteTb/LhVNdXvYkQ1HsMjKnNzZRtlZ+UtMvX1o82LiA5Oh/YHRTj2Soa0lh1ZdQfElaxzv9kjjSjkjPS9RudjISO/3qIEVewPl33BaXdqYU+ord0Q4aD1razeuxmQQEymiPraj6SVOFp2OaCPFSaNGk3SZixpAHHH3IJTSOaVPMQzMC8w0y9UZVWeFLQOKmNwvncKF5Do3zpRKIU7+Jzp70Avn1u7tzU1vBMy+/hz/UEmdJnc0Oe2Q9MO0Vbiphybj0eIOwp1krJDTBaTB+s54AQHef7unzTQDwKIrkJFWnoRbB8gAj+4WzuM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Jc/W1/xArACZoU6laqhUTQK9mTwiCVwvJh6foX1sdVLYc+x8W/4VeYgyF+6g?=
 =?us-ascii?Q?b5LhyBfynQelpJwf5+UFJOKrtRgQ619TI0PGRVc9GOB2VLerIgFUenD5WkIm?=
 =?us-ascii?Q?fC07V/bI6fvaaOfgFJD8NeXi8nj74w1taJUSAVpojAN5JGX1AlNuiXZQgEbg?=
 =?us-ascii?Q?A/00w+WdY5IL4PTUwOexcAHpnUhlchfnJocddcxV96rNJ/QqCu/awwauYiZY?=
 =?us-ascii?Q?XyDp6saHMiqIF5D6t/DbYPhi4EnAsNBwOkHGUMAxApElMtK+T/Mw1AljG86Y?=
 =?us-ascii?Q?Uyi6x2XAh2PuQrRnu4LmyKhLSStfCjPzsq3QibnIcdFOYILi5x+vR3H2GxO+?=
 =?us-ascii?Q?o6OgivkkAlfA4Vn+RojoGccKJZwhgXS7KNC5OiLkzMjy9b3pRDaqEabcy2L2?=
 =?us-ascii?Q?HFiJGiifVzkA1CK+yCFmhtDXxeugpmyes/jB5g7lG8IbITj7U7Nv25EWiwgI?=
 =?us-ascii?Q?xqmHzGO6fKHyKfrqyoTpTv337EclRUtgjXyort/htuJ/O5OG6Fjsd4NG+EQd?=
 =?us-ascii?Q?4df7vWuyVg3h6VrNJcjIDwAFYWSkgq7nPeDpXlK7tN7ctYLpaUp2HgVpguNR?=
 =?us-ascii?Q?GbgPYs3FBzcqlOIWAiyi2xYOpi3BEVkhdQxDnumPfDkyth8nTYGHSKC+2qSw?=
 =?us-ascii?Q?sELmuZtg4khSd+sCWO84+H24dkVDuu2QP//i6szMUTI9EO6l2yotq/RYtBOL?=
 =?us-ascii?Q?U4sbFoTggZ9RHjrSZd/T1CoeJQuK73l0I/4mlTI1NkRHyUKMBPQ4d7kmqUmQ?=
 =?us-ascii?Q?3rfUSJ4y1k04zHCGaKqPTSGvAaMK8HkO6W8cCuEeNBgW6ScyW0btH55McG2X?=
 =?us-ascii?Q?YvthjHU3uV+l8zoFnlc9oN49e6jsu/ByG7xlRYHAK/J7+fkanOwM0vQhT/C2?=
 =?us-ascii?Q?iLq/yl6GOZVQYNZj4/nuVmhTdBZLiJgPbFMbY4Yu+wxeVn9BcbWYx+4XGmt9?=
 =?us-ascii?Q?RkCT+pxrpW54biioh6okj4RbDn9yzckbcw3fdxu/pLKaSfEa5FS2fg93elCl?=
 =?us-ascii?Q?WWRorvwX1VLqlu3j7gtbbTd8sD+EdAbEp5tW7U3I85oDXZYPb9YHz+i6UCwF?=
 =?us-ascii?Q?Y0P0UHgwneskt+KcaPMVEBdWO0B+NwuvA7DInQ7aDRrOalj4Qx881LSlvYkU?=
 =?us-ascii?Q?e6m++PhFTorxVnM0PYaKp/DcbKmijCFeegCqSBdmCQCoggdv2obSTA53txyp?=
 =?us-ascii?Q?hmLYyV79vGxrf/0rAshyfaXWiKte+cBMBiHEwlOCGngB8dmlfBwc246Ltc8+?=
 =?us-ascii?Q?yxTmJT52aXr0FgKEEaX3sy5iK+BFOKZBIMmTwhFRp7fVnJf7tPbwvvaaAq7P?=
 =?us-ascii?Q?yuG1W+CZtD7O/Hr5ulhDXAJBKuQPEBBbd9SsglsJ8eH/dQjCypkXWfRpJY7+?=
 =?us-ascii?Q?VuK9ZR6pgilB7zH/ewZN35phEUTVa+Ert9mGHHMl3WIxUbFdngj6LgHJKLxH?=
 =?us-ascii?Q?pHXtqaHKj5lQzaEcyEEKwANTrHEjnSVEBdH5XKplWNd3KQl9GNy7UwBSl9o9?=
 =?us-ascii?Q?6bNaiJ5PXcj00cIDFWDEMdeCttnrFK66QiIr93AU7k4/DKzeAlK34oGVpeWo?=
 =?us-ascii?Q?Sy1yzDZOzRnjMgv8VvErREzb2i+BZi0+E2o848rj?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6990d923-91b2-4e3b-d6a5-08dc4ceb3ba1
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2024 16:47:18.2634
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RIJLiqLuoqjp2ZOVaf/8Hvt+lag/KHKDhbvO6J9qlh7hQPUtTBiE7s5kLPQUl5Sm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9409

On Mon, Mar 25, 2024 at 11:22:19AM +0000, Mostafa Saleh wrote:
> > I think that is probably because you are testing with "nested-smmuv3". This
> > series not yet fully enable that. For that, I think you are missing few patches
> > from Nicolin's iommufd branch,
> > https://github.com/nicolinc/iommufd/commits/wip/iommufd_nesting-03112024/
> 
> I see, thanks for clarifying. I think we shouldn't still crash the
> kernel, but that's a problem for part 3.

Yeah, definately. Part 3 needs to include the invalidation bits too, I
haven't integrated them from Nicolin.

I'll send a patch like this for iommufd to stop the oops:

@@ -236,7 +236,8 @@ iommufd_hwpt_nested_alloc(struct iommufd_ctx *ictx,
        }
        hwpt->domain->owner = ops;
 
-       if (WARN_ON_ONCE(hwpt->domain->type != IOMMU_DOMAIN_NESTED)) {
+       if (WARN_ON_ONCE(hwpt->domain->type != IOMMU_DOMAIN_NESTED ||
+                        !hwpt->domain->ops->cache_invalidate_user)) {
                rc = -EINVAL;
                goto out_abort;
        }

Jason
