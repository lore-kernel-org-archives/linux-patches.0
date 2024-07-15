Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2040.outbound.protection.outlook.com [40.107.95.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD5E291E;
	Mon, 15 Jul 2024 12:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721047550; cv=fail; b=mYAVyZR+5AEdnWDfDOVtYrHlgKLCmzq8BDLjlxh/TTES8j+1ACyAde5xFsbDdEC9haV0Z0u66+QJ+3thsc+C5fOINivluS7Vr4Pev41nh4YWq1jToJGnc8u/UBHzuQBY/VSg9WB0tE6nJsUjhbVhEs3BYVFgtJimzFNXi/5680w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721047550; c=relaxed/simple;
	bh=3KNZdLSk/N/xniA3hXXZp5Oo0CWL1J5Bqq5OI1lhQVw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=V0Y+kthCqs6N0gqfKuI2+CD5nOMouPMOJKAa1B6blrqCNDhap9PQjxMXhfYj7EkoUSEga6m+UN0PtSG4uvMlKrk5tjGSzK+3NeBo08dwGkHYD0MhNLYxRPHCUju1lYBwhxE0vFcyZ7BOIWapOIYqETau3MaL+ISRE0gxMNuupDk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=FoO91vDn; arc=fail smtp.client-ip=40.107.95.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="FoO91vDn"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T+0fYzU1Vq3f3dkGNLnC88e6muacvxNJSJXB90fDLD6knjHJWd85+bU1ELQJaootU+rY/G1fL3zpEUyvTdN47Tm4PP34tbjhrjSBM6AgFokCA3LiITpk223b/LiMLMBBofygaIVo1O/zctn5RLehsyE4nXRS6rxPqvBWEt+tD7yr8CfJfJXXW0aHiPAv78zbQzcwm6MvRfPKGaIFQwsrh64HugIBDfVtb8GO0K3N8OuwW9EfzZkanifAc7xWJWi1NV6kYzBO4QKfUjHtKT4ZaTp5utlakQMGexajodgife4dFbtQk/gpJIUKjKR9AnlUO5znBCbw6Vyp19WGfBoRZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j1d0/XY+VrxFvoxbJ6wqwZow+iebARdZQuD2SfE36e8=;
 b=Dt/Za+naet64tB/LbaYibaDD7NkMlKQ9m18eIJ00uJvCYNiY7JAMrDNn3YaMIAfhTOp426Qj6YXLUzJDv0eGDkqWNW/eu2C2zsXJLC3XkovzrJGLD4ZQg6iTcBQKKr/eC9oX4XVXvFcYkFtE2G8o6JyuTv8rJ07UhsZf1qIQA/bFG2cuUEwnVEDzab4LXc4zE0/zL0j1+DA9gD11pKXumcVS8Zvt7BiZSbnImGQYhepTNbmLo/xBKrlH2dkEqMcWg066xWG3gjnltGCBGDmmL0Tmsyl9DAHHqar9C7GuFZ2vVenZ5F0fChtscNoydB8HCNPxLKNP5bIfDXfTEgoduA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j1d0/XY+VrxFvoxbJ6wqwZow+iebARdZQuD2SfE36e8=;
 b=FoO91vDnJQ6yfgMnTVHXTcMRrVxW7HGDdLxcPhmsHJ1ABeYB/r+sr6+XlSvjhZIN8k0c3eu+QH7yBr+5vPuYAYzlRUgzaDfqMQcLxFo2O/3REeqrzIhV1CAnyG078TXdrKSxhyJcLsXk42quA+9kkKbrNmvDLoQCRZEPQHx0n4cyd6JA0PuH1JRO/bxwBo8qOb7VUltWkoy1xHwWqBIYmwcSc11tZkyd8W5ZD3Vh7bRgGWGSLDBVOZODmtWBL1AyBVfIMRfSwngDTL4/Xb2GhEEYkEHu8tTGEfVEzMjHEP/3f4hIRaOmd9x/xhPR7+lYMrkndhZbZYYNsjtUiZZoJg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by SA0PR12MB4480.namprd12.prod.outlook.com (2603:10b6:806:99::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.28; Mon, 15 Jul
 2024 12:45:45 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7762.027; Mon, 15 Jul 2024
 12:45:45 +0000
Date: Mon, 15 Jul 2024 09:45:44 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>
Cc: patches@lists.linux.dev
Subject: Re: [PATCH] iommufd: Put constants for all the uAPI enums
Message-ID: <20240715124544.GA622030@nvidia.com>
References: <0-v1-2c06ec044924+133-iommufd_uapi_const_jgg@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v1-2c06ec044924+133-iommufd_uapi_const_jgg@nvidia.com>
X-ClientProxiedBy: MN2PR15CA0046.namprd15.prod.outlook.com
 (2603:10b6:208:237::15) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|SA0PR12MB4480:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f61a8fd-c1b9-4872-99bc-08dca4cc0b40
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?TeYkoMBtqQwiJv5G/JPhu6EyYS1PvP6nmUcIrTKBjMQGTQj5lJEUcMCwague?=
 =?us-ascii?Q?saR/vK2PSgD0ftjDv16AGPbw7vC2yqwnGIqDzjmaf6GG9nWq7Ka47x7mMGQR?=
 =?us-ascii?Q?SmN6VDr1Xh32QyMDyW6W207NBbqH1Do/DYqhhzLIygw90RIjUDKIb9xF4n+C?=
 =?us-ascii?Q?kIHxV6MX8V47yltE3+/4P/Ml6eJlRxdBScK+t9b/4HX5six+2kD/WNYoXCjR?=
 =?us-ascii?Q?80CjdY5uXaj4jpz3WiqqQr8Lkzkmx4kkjVBwZVwg42ij42hCE6QtAmh9pvZ2?=
 =?us-ascii?Q?+wkgL+ROzr9NQCs83079yvOwyFnwhMONAk8gCXVrvbQXBFcnu8Jx9+J4396S?=
 =?us-ascii?Q?DrxojtcVEfEu9Vr77/QusR9pmhkQ+FZHSIyqcEdeeKwO8bpeoXhycGtLpicA?=
 =?us-ascii?Q?ghJp0bpl+Pwkcl3Lo+RRhjIUdZdRNaoL0T6u2JLSoYLcpxe5cvqd0Bpj0BV6?=
 =?us-ascii?Q?DxqF1sp5SF2b1tgtGlrnwoew8fbwApBScATSrCy/G+n/GJLHXRdyagKCdHmr?=
 =?us-ascii?Q?kspuFsHRzRtqeFNTkkW972bFmq8aO0mbA0rK0h0sP8wv20ErwkkF6TMvYGwX?=
 =?us-ascii?Q?sxdKM5GON2uoQJgYMX2BuvNdvUkC7IIDs1a+Awq9vR6TVfcLOU452Q6J8PIV?=
 =?us-ascii?Q?SNAcoDlAQggSHNljFbVhRCvlfN2ByR4/dPH7dASF0YLXDIXaa6KJKHc0qDx5?=
 =?us-ascii?Q?fmkekZB4VVgr20Ah1PedYWEEqTI9ciydczgG3wbuku1/f34Ofws0AsUXkLZU?=
 =?us-ascii?Q?2q1G/97iVi+UnqsNQBjuilpOyZh6Xf5pL3zn9/9BYLiwXvtjnzpUS51wA61L?=
 =?us-ascii?Q?AFe8roUZqOz9gpYMyJGkZh6aPXGwF2ssciulG1p4BtA6+rdXWNopKMylD0Xb?=
 =?us-ascii?Q?2JwJdZUwlCa2qFPfwKA+lDG5Z25XkaWMw57qrO6adY48Lh9y+yMAPsjt6rCH?=
 =?us-ascii?Q?jNSKIpZsUvRpepuTgOQND1UTr5OlEradyEgYdJcgQflg1bx/cN5Z0mu31tuM?=
 =?us-ascii?Q?vPg7Ntbzrkqc23JAyPsKYw9p0ApTBdmJrLGX+VBf1QeFKGGZBl8oWtjhHsN1?=
 =?us-ascii?Q?V/vOV5mKw/c8abTvBqG4t+QzN0D+z2o8nTR5H9e0HrA4YJl/46MF40muCuW8?=
 =?us-ascii?Q?jqm4U56aw82NIjj2I1Vxclh0RrXq7lqYSC5kGfUiXTjlRcUCLr2jJoFdGvaz?=
 =?us-ascii?Q?zy/9dwIAABDPVxSEaVbY7UBXycaxt/bQTToTxc9pVlbzm8535y1aQRtPVWss?=
 =?us-ascii?Q?4kRPPAEJJgHfyypzKUtHjKv3tGwuItStPhEgesqrjah3dZku9SZ4WY8nU+eb?=
 =?us-ascii?Q?QTbFCshveEBsthI4EYUsNU5ZNcatm2egHdbuGQjAgeZEJg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?l5yjFvmtK3vTbpGDEx1Y9ffY6sW2PLz+6UAAI5rrqAAd9TM/mDUzyYj/zIKX?=
 =?us-ascii?Q?6+/8ohSjllq1hnyl5hDllG4q6bxU2KnP1BQ3KwbTN5Ip5Qx6FyL8aNJpEvBp?=
 =?us-ascii?Q?U4FnYCvyk+O/5OtFMaZXg7Cly8WbJceIw9KbR1IbRFK5DP1jaQ2VKpS3ZoLo?=
 =?us-ascii?Q?2EwJBdT8f0HJQDAmDPPo+OFu09BOmUSoHhEMP0AWahvzU+xLph7btVuUbPRz?=
 =?us-ascii?Q?owadyQA9iG3SsMSX5/MektsDya8oZ2eQc6xnIz9H/Z3gWzaKaSludNw7ztz9?=
 =?us-ascii?Q?WjhirbreHYjxlmr8L1xcIL6IagBStqfyJftTC2ZOlMi/E0crry96nen+1gou?=
 =?us-ascii?Q?R6QhJyOyVW6eyz+A+z5lB1QoB8sdgyBK1G+lIWC+1xREKem4ClxLRRt9NTYY?=
 =?us-ascii?Q?2WZZUjfgk35zzyMahuJm+P4/GAYiXnvLQot5MRC5QkV1CDnGtf7/buBzeATW?=
 =?us-ascii?Q?U9XATkpRXZFIv/97M5PrOeniar/sQ31LrG4s9GA9xqf5vDoq9hKcFpkdr1/O?=
 =?us-ascii?Q?UGv52FSfWgJkF+jOa7kJ9fWLREDnW9z5kgjGFOXO7zwC5C4KRKQbuW24+bKw?=
 =?us-ascii?Q?vP3hoAEQx+/mcWaZGzYiIzloKqL9MUV/4Zj8KfyQG1TsySNhCZHogC60cED+?=
 =?us-ascii?Q?YWz8n4ifOgBFUkRXu9Qi9Ma7OkQV3M+i6PjXccU4O8u3cRxArXqQRXsZtmzp?=
 =?us-ascii?Q?2Vq9uVIj58NAROaquiK0/1LXvRBwlFq1M4Fth7YDpx4zQVjul/bYK4M/l669?=
 =?us-ascii?Q?J/BPvrtRUAOPzLAi2gaAWz3EThTzCikkMwPPdsdVQrRUz8QCqQL9Sc3zo8po?=
 =?us-ascii?Q?GfnS1kexbhQ7gAzjBfCrMeK5oZfk9gRKeMFZaqm8JI5W0cE2638RtGtR7xPV?=
 =?us-ascii?Q?GtN9Rd4vZ1A1Qb63CRfM2WpcI16KBAZGowCjCpZccueLNVECwerwCwYodsGL?=
 =?us-ascii?Q?xQbIGRXLnowDl8GBjCeZrD18NMJaxcSqemN+y43efuW06Fz2FFoEdsEXx6D/?=
 =?us-ascii?Q?4vxXfIlD2j0Yd00ZPtiqThmsBK0hRCT5+plCy11iaVbIpZarbWhOtvn2RSAd?=
 =?us-ascii?Q?J2VqeOA53GGIF0K4uXmnsIdmJVOdFtfhbUPIAJHFDu4vXhPi86e+Y+6dqgvq?=
 =?us-ascii?Q?cmLQW92BKRa7FDWhxBEJQgShXyrjw7sTU6M4XzpRSS8QW7EUQf4FhHOa6lyR?=
 =?us-ascii?Q?7+68l2NpSAtSYikaSFPteTZlUDUdSqYVSxs+j69M6mL4oYw9lN3xbfH9Qx0o?=
 =?us-ascii?Q?M6dNFLnw5Hzm9Uqt+M8YUZH1oJo3ni1dCCjw00Efz0FyYd+fL+s/Aa9AeyVo?=
 =?us-ascii?Q?SAZDQyAVESjTGprCuUxPIX9OA/ZnpR2scbTDtRTrr7mjImkrBIkdbqhS01mI?=
 =?us-ascii?Q?4N6bFcTriBTf1v7PAHalpsZEWz8hMB7/tNLnoQJtF28Ka1N+vR8VB++IwETD?=
 =?us-ascii?Q?HmlHdWX4vAPTmExyE2pv1RFpk3oQXMlLMLpxHr+w8Y8U7s1pkU9+6hGE3jVZ?=
 =?us-ascii?Q?lkU9oRzy2btCNytw7IvdGEw5tR0X2zlOLKw65b4y5qAa18/20e/fCA41dbcP?=
 =?us-ascii?Q?OGjDcjM4Qk8jm2GR1r6PoDdoE8nDairxSrfaZ4W/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f61a8fd-c1b9-4872-99bc-08dca4cc0b40
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2024 12:45:44.9640
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: be3hzCiArbnHWcusRTpAsNZoORU45Cyaw5pmxwd81mSpt+zhQ+xGYeBu6CzHFRTh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4480

On Thu, Jul 11, 2024 at 09:11:03PM -0300, Jason Gunthorpe wrote:
> Relying on position in the enum makes it subtly harder when doing merge
> resolutions or backporting as it is easy to grab a patch and not notice it
> is a uAPI change with a differently ordered enum. This may become a bigger
> problem in next cycles when iommu_hwpt_invalidate_data_type and other
> per-driver enums have patches flowing through different trees.
> 
> So lets start including constants for all the uAPI enums to make this
> safer.
> 
> No functional change.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  include/uapi/linux/iommufd.h | 40 ++++++++++++++++++------------------
>  1 file changed, 20 insertions(+), 20 deletions(-)

Applied

Jason
