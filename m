Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2074.outbound.protection.outlook.com [40.107.94.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D3924EB4D;
	Mon, 11 Dec 2023 18:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Xd6gh7ET"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MMMCI/upkoOmZ5E2GIiHGz0P99CqjmCq3zKaLFbOo31vgafOSCeJbLW/mJQYmdY/8YvEN/DyHsg6szF2HdxFMB8OiCNArxtS+GfdGog0Hc6IESEhG+qPrYzfn2PtTZmFOHzfnVb5WBxonNW2ZvEF0aHvocdn/6H8JJqkWFXC9XwtAM+2lUXHahOfTJAK8afFVpat/Up0uvnxVgFsolZv4ydW0Th7jEK/pQcC2ex07QFL2QkfV7wa2t6b1O5SJPzoLxoawTIww40QBXuoI+A62dHq5zwPYHKVbahzochLXIvTd/KJx4mSRbPoxSm67froqtlcQTZAZ10rsLJgo4X2vA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8PN9fFjxMUxGMKxhSYTXCx09rk23qfYEG184ZZgwt+4=;
 b=XZcfl3eIMAu9jm6aCjUjNx3tthePlVHOjBH2G19u99GCcxwg/BEiv4qEIb001WQV7R/rPiujlgp+6kXbLqKr9+rwgRfqWD/regY/rjD6EDAgyvAw/a5CeB0NvXEjwbPFfu//HmCznezOItuZKpJnxGPEJIKfnaHO58sSyJzpHe3p/TAdUZBxSwbBjEOiXgvu0RIrKQv9RLpFptoUAF8dEhNM7Ivb1xFK27J652EA50x54WySBtfjVilQQEdsaVSZtET4VMBxXBsdnGbRt2/KWtz9q7KP1P0KCT87aD7eAPejxa84m6MTCV5ZfYf1yEj5ALbMjcpkjBDmy5osZUO/mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8PN9fFjxMUxGMKxhSYTXCx09rk23qfYEG184ZZgwt+4=;
 b=Xd6gh7ET+YpcMeXzQG/zFxyYk+54uFoF2R44tBCxmr9WiSkyN9z5p0wjuSqWvji/16fPTJPdz6SiF+PphnpJqiKVKxXz/yl4gXjDGWGWG7XAFTG+g0cUcUizpE51FvvZkRre778QqHEHlBJDc6TRBPBNsDu2DQgqJyhxuYSbgp23eNvUF5q/k5UMxDGRZyZ1QY5tkWRw9817vpmuQ0H45ylk8lTyC3Dgzc7yEs7le3uXpKuFdEWVTPznXKiLqJcIHa0ivdC/Y7wjKnE4aFIx9vkrJ0BdJV0oERbiwiIjaB+dtYu+LSdpCLESg49ZHh4plWutk/YQQikYbJLsXJYfOg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BN9PR12MB5227.namprd12.prod.outlook.com (2603:10b6:408:100::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.32; Mon, 11 Dec
 2023 18:03:25 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7068.031; Mon, 11 Dec 2023
 18:03:25 +0000
Date: Mon, 11 Dec 2023 14:03:24 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>, Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v3 00/19] Update SMMUv3 to the modern iommu API (part 1/3)
Message-ID: <20231211180324.GA3012960@nvidia.com>
References: <0-v3-d794f8d934da+411a-smmuv3_newapi_p1_jgg@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v3-d794f8d934da+411a-smmuv3_newapi_p1_jgg@nvidia.com>
X-ClientProxiedBy: BL1PR13CA0442.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::27) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BN9PR12MB5227:EE_
X-MS-Office365-Filtering-Correlation-Id: f30ddbef-1ef6-4652-98bd-08dbfa7378a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	CVIsKYvXjEcc8OUB/CJjw7CktonOGolPvDQc5btBpO/qGD1bzimK7354Mmm+wxdIQrv4qRxj3GvMqBHkc6LErlgYwPX81PFoLXNMgqBtgtRDRqF56vY9wraUWkKIdiMUvadqBfHCMiNrHhTA3BErGcBXMuWqNgo+FrHpagJKm978+gRm2MQ64nLfDJbwxCJNs2PvL4yvLwzxzx+WdJ4CnOVR1Ultzrgnn9D34KbLdEjN61dowZWkxJgBN3u5Y4GwDxWapxyFURoyadWh2M656xrlVO/L4LW3ElnN3mkbgiUVULFbL2F4HBJs/jr2KtZjPDpQwr6fxBdH7/Gfzbckfyw4od8pk6EOR5PVwcH5HUpDf4qsl8UKdXXSS4eFSX9mh9SQ7dGV7jcqfv87/iV6BGJ9o7/d/9gVZYlSBxnIscDPl+UP0jHP8PfpbWpxD+Mw5iq0Ub5XXl5HCz3ZLwKdYLgZMonIM6dXp5WU8ohZ9jqn0RfQWO8MAQLg5UUKiOGZut58UqN5kF8BOIn8jOtbKhybBVsHTYeWJkyDtg4oyNjZI78EJjaNND2x2IxmtwWzYrtghm3QFt/3EIdx9gBaYoeD7e4jn3VI4otbo5nEKg0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(396003)(136003)(366004)(346002)(230922051799003)(1800799012)(186009)(64100799003)(451199024)(15650500001)(7416002)(2906002)(41300700001)(38100700002)(110136005)(36756003)(33656002)(86362001)(2616005)(6512007)(1076003)(26005)(478600001)(6486002)(83380400001)(6506007)(966005)(4326008)(5660300002)(316002)(66556008)(66476007)(54906003)(66946007)(8936002)(8676002)(66899024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gLgRAP9K6uBHtKoXlRxm/esng48fcQxSVJ1JJXU+izxGNFTa6/40oGAHvxGY?=
 =?us-ascii?Q?uRThHupDXV20Hvd32R/M/kxbtRwjy+SvFOYyWoKS4ICcomPkIenJSn1ViMYu?=
 =?us-ascii?Q?k0kyuGHPMD4jgy1oSsRDP7ng0mmBTlrp8LImXXM4idvYKLM9NleJanL1gwIZ?=
 =?us-ascii?Q?m8x8+Gqc9M5wEn3dpLXZ3sABL7evFJqLtvS1eE9vBODQAjGyeB4aLgva0hGg?=
 =?us-ascii?Q?4uS5zzEuczZoH7p2JXLfcXf8qEO8CUNUNF4Zf9VU4OKP1i1v7tu6GtRe5U8g?=
 =?us-ascii?Q?UkT/YGnfbs6jfszQ0obu8EIsuO7CB6jbtEeRZiZJ2MNz8CdcPA/koV+GvK66?=
 =?us-ascii?Q?InHH35ic3liqEJ36bxe/ynVdSz5IbOcwhf64HAWJwzm2pzf7/hz3NdPtyB/d?=
 =?us-ascii?Q?2ZdZnSPnuxiduWvTyicOI6Oq0uNvQbKAQYR2d5sezilIx6EKRAbx5iXprv2U?=
 =?us-ascii?Q?2JCkK894xpSrJFJkljw0FmGh7wQDJ/U4h1nhZXtAM4vShb/U4Yt38KJ/TQLV?=
 =?us-ascii?Q?7BEOLzmdXm9tL709UvBSTuY0n5MNi588h0jZ7PLCt6JlXKbsQ0+XFnqvEgat?=
 =?us-ascii?Q?5xa3XRPqkJqdUtSIUJUoiIX9OciTWIjbFWkuADPNzGVdP18EKmEmNGcGJQFK?=
 =?us-ascii?Q?EAYcgxE49q+pqjruwiToWhd2MbHlra2yF4IqMcbO4LvgHjsmr+NjkbcEK/tn?=
 =?us-ascii?Q?3eneH/PRx8BCZF6SZkxL93kOfhvJVCm1z+bnVA+vipr6KKbdMG3N7TJSuwr5?=
 =?us-ascii?Q?6A1lIUeWJ4sMX+k/pOfpMmT5VNy/GaT4eEZLhQX0GJ2WGmi+7/qx/bYFXPYq?=
 =?us-ascii?Q?GsioKUEzsByLoJ+qSfz4ev/8tKj0wkl2qk47nwaN8NxnUPuYi9XYGT2uKYzk?=
 =?us-ascii?Q?05S+zpUHjMqO09NitO2ERbZcHfyOEpYczAphfXpA/O7nv/VsmnrqGbARan9S?=
 =?us-ascii?Q?lMj45RfAA6+vXbeBsWpfeSWrXij2MGBQS9AKKbiUlSOSxRMRWadiEMYwJrte?=
 =?us-ascii?Q?Y58NGkdL8n35NzAYIUo2X4XqmYIwtYrQYzZtLZPzjxqJVhbiBmhstjtEjs8C?=
 =?us-ascii?Q?Ed+gWOhW06ELmi8xLiC9HbRiZRTk81wslZ9TS1cwktN3+mPtZ9a/Ax9YWUqO?=
 =?us-ascii?Q?Rrtrl0QFCdmwesb/TPY35TULfQJo1o5BFpMzs6vFtnao6uvDs49a/V+q35Cp?=
 =?us-ascii?Q?NVzRFfwM+8HFGRkNXroBx+T5nYpOsg/rZOHhKSd42H7dUMniYu2Fuev1SSfB?=
 =?us-ascii?Q?xXcjpAJ88QjXUodKs4N0RmVt4WPRL81za0ftwnaO0B476TaRfCDCJ9eodNPJ?=
 =?us-ascii?Q?s+d6Kop0HY6IBRH1n1Sa+kr4GZXEJDwBY5j7Ik2oHDykDodREwNWjq64+u95?=
 =?us-ascii?Q?1KnU4Ro+XHkBkI62nvOkxRHdpH4xy2NOI+rmpK0sbRmkRIRLs026gxq5gnqP?=
 =?us-ascii?Q?ezIyq8xdRsagc/R+jT4eXOYGkRxqKA0uUJ045cVZ/IWvmrL87nqs9d7AQROC?=
 =?us-ascii?Q?92QpTDebBdQjTiPB4cPW9K8nx5FnmYo62FP9tqEyISkZQpGmwdHPJ4JPOxnq?=
 =?us-ascii?Q?EulVB7uBOKE9G8wA5UA6kIftF+4BicMQboHylt+v?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f30ddbef-1ef6-4652-98bd-08dbfa7378a2
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2023 18:03:25.6778
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d9Hjdgjv1Vci1OAizpGHCKcMhgiCXo5XG4fMpkuppSK8E91/Fnv04kcpicvguj1H
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5227

On Tue, Dec 05, 2023 at 03:14:32PM -0400, Jason Gunthorpe wrote:
> All parts are on github:
> 
>  https://github.com/jgunthorpe/linux/commits/smmuv3_newapi
> 
> v3:
>  - Use some local variables in arm_smmu_get_step_for_sid() for clarity
>  - White space and spelling changes
>  - Commit message updates
>  - Keep master->domain_head initialized to avoid a list_del corruption
> v2: https://lore.kernel.org/r/0-v2-de8b10590bf5+400-smmuv3_newapi_p1_jgg@nvidia.com
>  - Rebased on v6.7-rc1
>  - Improve the comment for arm_smmu_write_entry_step()
>  - Fix the botched memcmp
>  - Document the spec justification for the SHCFG exclusion in used
>  - Include STRTAB_STE_1_SHCFG for STRTAB_STE_0_CFG_S2_TRANS in used
>  - WARN_ON for unknown STEs in used
>  - Fix error unwind in arm_smmu_attach_dev()
>  - Whitespace, spelling, and checkpatch related items
> v1: https://lore.kernel.org/r/0-v1-e289ca9121be+2be-smmuv3_newapi_p1_jgg@nvidia.com

This hasn't changed significantly in the last three months, so I feel
done now. I think Eric may still have a formal Tested-by for his
Fujitsu system to record the run he did.

Will, we are waiting for you to say something so we can shift review
and testing focus to part 2, ideally in January. Many people are
waiting for this.

Thanks,
Jason
