Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2074.outbound.protection.outlook.com [40.107.237.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED77A5DF29;
	Tue, 13 Feb 2024 16:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707841146; cv=fail; b=p5/gIvjz6HwRenvz+XIrPDijcgGyasTiEPIdj7jCxzefkJAbDPZt+z5JC8Cfv7AbrXRS+pBt0xtWBTIcFY+1RIPieVSzkPaT3W5JPFJEYW5St94lOeR6ALxWHehsloo5JLLIHjGXddBaO8YpdlKhuLTPE376jvd5nE5pG/jjCIw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707841146; c=relaxed/simple;
	bh=wHlGzncuZOrTeCxBQm4kRHR7Avd/bM3Gy43nw0/4uQ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=gZD9y0qi9o2B/cmLMlk5zkwBh8HVnLo2Az6pO4EFIzINkeiqOVBvJpS58amXuzuETfYsVXeGPHZFbjM4vqScTiCKNxpESnLyDeKHa1iwPZmBmGkZ4PhVBXJaVBdh5AD4ZLj3Z9S0yB5LNVP0b+H64Ef1bM6Lk8DHSXqwHWAGdYE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=mR8P+1wp; arc=fail smtp.client-ip=40.107.237.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="mR8P+1wp"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a9AjPx3Epf0BQ4OKc1NRaQ7JlterrjJxB773T4ALyDhek3+QBsS2PNVWNeQ+1zk/QHl7A/5K4FiI35sxb6Apf7TOdC5Ry7gav0GegJjicUYxELkvS2/3+czmkj9apeaDWUwPFBdY77exPyyj1jVdCdmi+hOs7FGx02gwTEKVUOxHfov/kMR9FOwgu9RQxsuNLDE7gko/FnwPcSgyCxvHhOJmLXYRWL/MfTgcqmM7AtuYUTK4mw8+CwKt6XUs80xGR4YIMGyZPRF/YqdkZ3I9vsS5sCHRLgtndLaDSHyeDtzOdR7vswbWEHZTO+O9aggx/Q5lg6snhskJt0qSC1t41Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wHlGzncuZOrTeCxBQm4kRHR7Avd/bM3Gy43nw0/4uQ0=;
 b=nKodzRPCAwxxQtQQivEFAnp+BQT2JwSaJvtmQMz/RZXmtqzutVRLxP6SxCL/b9olVKrzT/pNgXD6018AQeKdD9L7fLfWm7b0BzMcyBAxwjU7isLGPlLxrS7F1F7tq+WjlhJa/dXuoQZUfMR7yor078+yaQey+xCLpz+jx2ePSLqoQIQ6sTmbCxhgEyxqljHpCm9fR8eOsrhYO901rUQe+mttZhUFHCYBtKaguDtQ8WFREoqY6mKQj//rL4nU0pfvytLYSbkg+8FT0VE0P2Cm9rV2QuKWA9bbrcCK3Z6PF2/U7KmuEGenS3j8XuOvlOv1YW8dvc5L2i/OY617bXKKtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wHlGzncuZOrTeCxBQm4kRHR7Avd/bM3Gy43nw0/4uQ0=;
 b=mR8P+1wp+9dnFRqnCUsXlT4+qOkPqXmuF5UbmURE9TrgWVEDyo8Onl779+m6zTftPyedGtQ27ICvNKKDFTBXHzpQOgQt6jbkcJcLhEnad2ny9wwuhJdud1cuS7SOzr+BG647uJ464mrytzSUYJRIUH8+qikL2hKjhxDBBiQRjfsE2K6JhPOHZ18tR3orsgBY4oxgfo5kqAIR69jX+iV9V/kFNEkI5LcCkDxroDmp7isE19Nf5rNBXeLd3G6+A2Q4WqfDJOgE02/4vJ+JDjXGRoXCSvJkSRf41q1HfPGfZMKoRZfGturKtkTSSeU2ica4QUkoE1HBeUo72vACDu+TYQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ0PR12MB6805.namprd12.prod.outlook.com (2603:10b6:a03:44f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.25; Tue, 13 Feb
 2024 16:19:00 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7292.022; Tue, 13 Feb 2024
 16:19:00 +0000
Date: Tue, 13 Feb 2024 12:18:58 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <jroedel@suse.de>, Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: Re: [PATCH v5 06/17] iommu/arm-smmu-v3: Hold arm_smmu_asid_lock
 during all of attach_dev
Message-ID: <20240213161858.GC1088888@nvidia.com>
References: <0-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
 <6-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
 <ZcuNESWmrC9jZ9lM@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZcuNESWmrC9jZ9lM@google.com>
X-ClientProxiedBy: MN2PR17CA0028.namprd17.prod.outlook.com
 (2603:10b6:208:15e::41) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ0PR12MB6805:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f0c7dcd-278f-4ef8-123e-08dc2caf7cb8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	P6QwuifNZnTlz2PVlcNFrQ7l5nTWHa0xOwiAq88QxC2qsyLAzm0kwvDU5czs6eKD0B+p/LFp/+4dRHRFpMCHIKfKQnQ11klmtbiOp6XtFNE4rsAAbKC5/3jcCAosboBriW9h4u+k42fUxCQ9cJ3qMgtwR/pyt/TQabRxEvVUmoi38zKXYTCBBpBsRacZhGcFJM/a8dnpD5oVqALasJGYka+W+gMF6D4cQhJiPUl84daRHfZ6ryCXuKKRnaewiiLK7RhLu3XvSmOuhJdFvCr4YDBepyV3qYAy2wxKaZ2Ohr3TNYeIH1sMUfiuvdJ/6unrMazUHFVC7a5Wrwvss1+lCEYj9TbsPZ5VyaaPJrv72LaXEHzfeJHvtnpJw4qzK5qQ0ftZUgERgPbRqtW/H/nAW1/Vg1omDJV4I1ztP95/6OJPFt6tD2h5w+RNgoWNWItK106oKXhOkD3UbNLF7HSaEHXNo7CHukGsrb52WcRnADMpKGBlUwvlfqGI/Y4KpGAkkfEnFzicAVIWVecsAu8OP05x7a9h4fkzuxJNdAGzHJ/eI/PyHMG6WqmrrBizD2Jq
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(396003)(346002)(366004)(136003)(376002)(230922051799003)(451199024)(64100799003)(1800799012)(186009)(2616005)(36756003)(2906002)(26005)(1076003)(478600001)(6916009)(6486002)(7416002)(6512007)(54906003)(6506007)(4326008)(5660300002)(66556008)(8936002)(66476007)(8676002)(66946007)(33656002)(41300700001)(86362001)(316002)(558084003)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?aspiQFas1wsmJfjvdyx3MeLyaWSRBRRSX8+ofvJr6lFAkcpE2wkQfpiiuJzY?=
 =?us-ascii?Q?NDWxGfXeSTTgboT9WrjjjLUFP36JaU6/1qJUj24EkbSKmOQcWxr3PC27rMhE?=
 =?us-ascii?Q?r2jgdhkWB2cxygzvKjN+k9fgkHa2niVlfeRzRlH1nqQ40uk5NSOgauoUyvZe?=
 =?us-ascii?Q?n1aOjtYeSrT8EpIrnEtOhmH7Jf0k5GYi5Lu1vPtWjA9FNSXRCCFqu3Vg+p5v?=
 =?us-ascii?Q?eIOzoDmFxWk43asSa/XpDu9a00JFcLyNhp/RinFK5CmjBvIp8FkDLddhUeQ/?=
 =?us-ascii?Q?CNEkOv8qcXqiTWzYwNV//hTWNxHQa+jNRTEUBoYW3f8CCCveapHxOJ7W69KS?=
 =?us-ascii?Q?DKWiM0X1UViBI2MxBkKQmg9Y6YNC/UJqvkCpKLVc7t63Xwh7MG9BuXPGsC5f?=
 =?us-ascii?Q?slG275cin7bjHvj31h40WKGQJ+hEiFlIraZv0lRrUv1HMl8Jk2uipqBVeZvJ?=
 =?us-ascii?Q?lWx4T6RXx50CNEEX0s3txU4YB9joN00qqOqE2+dr95Y5novgmVPqlRQagLf2?=
 =?us-ascii?Q?qExwiGrQWkMhv5+R9nH9yERImyohfndZeApszGTYf5lLc1g9yVILmgwAf1BL?=
 =?us-ascii?Q?AvB9Ih45NqeLcGv79xgdwyn2IazZ6KLS8Qoot7ZkxYfm9+sfMf2VKi7oh4G1?=
 =?us-ascii?Q?RB31QXEzFjVHZzL82rmV5n0bXALpdFeptAJz7vhMrthbwT0EP1xt7UBbsRk0?=
 =?us-ascii?Q?rlp1uKq/h2kok7cx+ffBAFUWzRwcghvKr3KtQaSbYWTD9J21IS6JtVl2TF3z?=
 =?us-ascii?Q?PX8re9h35rBZeQuFEBdmi7iJVfyx14kmcMQmVgWHIRN6mlYU6AjohMm7YPn1?=
 =?us-ascii?Q?CQABau+nJr0f8cPeaU2lqEXm404ZTl54sQSY8y2Iho1cjYzi/HJX9skVa3f5?=
 =?us-ascii?Q?SUJgjR6f7s9adAZKcrx9P2mZ11zZacjFiyZqJhX+VOEscclY/irkSB/2HPtj?=
 =?us-ascii?Q?cnraHWS7zq7VIETL69rLqUidk70+TVIHLpSv0mC+H5jIWO3SiyPC7rTtQbAn?=
 =?us-ascii?Q?Wfg9wbAhVhsC4qeQhaQAfVwsK/LfoYI8THnS0OTCaQWct74wQVZWKYLvdCUN?=
 =?us-ascii?Q?RzlRNdca1wXJwC6GK9vNbCS7+dOzHe3/Y56PBY9V55fBPVPTPkVlQnDnaRtD?=
 =?us-ascii?Q?C74y/Apz10lVQVFn7HD9P+SA/Wi2S/KNVhInf9uBMWpZfoYDbplgkNz+Qus8?=
 =?us-ascii?Q?sbacNvTzdvaftQ1jBV/ykNR/es8cqIKm7WHm9s8PdPo2y67kHjhh12hVT/fk?=
 =?us-ascii?Q?q9UI1K55Gni3uwFXRrFISSvgd9u0UYc8XYXDUa82VKalubqMx8uwAoZ0anvT?=
 =?us-ascii?Q?SqcT6f0s4xqRnY2eTxXCnOkVqckWto5HA0jJiXeYAMQv9pDAMwXO0ydJ1exO?=
 =?us-ascii?Q?rO9U+qSGZdRJ+t/4Ini0Xn/+naq1NDKOLHEVMnoL//VEsTIOZHPPrb7o9Yri?=
 =?us-ascii?Q?B8UmVk90fTjOCnZM4dGn7EaYht75JC/RuY24HPU/5L5LqPAlbPwCFa/0Kpri?=
 =?us-ascii?Q?1Q8CmI3FI2V6JAFpiiUp5IMgYCN4C+sbUScDok2FMW5YoaqXgZ9z9r3Hpsmo?=
 =?us-ascii?Q?cvs3svKERmtGf2/SO7IDsuDEVfh2Hw8CEIxQ+qxL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f0c7dcd-278f-4ef8-123e-08dc2caf7cb8
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2024 16:19:00.4310
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OHqbt0wUigYIOfs3h91+s32Cf9EaKNjTwX7NBVyhge/plSwLoJ19NpqV0kDrjSVK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6805

On Tue, Feb 13, 2024 at 03:38:57PM +0000, Mostafa Saleh wrote:

> This seems a bit theoretical to me also it requires mis-programming as the master
> will issue DMA in detach

iommufd allows VFIO userspace to do this workload as an attack on the
kernel.

Thanks,
Jason
