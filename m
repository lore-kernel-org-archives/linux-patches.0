Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2085.outbound.protection.outlook.com [40.107.220.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F30F35F11;
	Fri,  5 Jan 2024 19:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="C37iLfp/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bC7nCxGXIbFSueZLpAxOvqY/unHRqKYhuUSuT1JFHKfUvCng3n05rUermse/qTEOmvfJ4L+8pWJgtXENInuBnnGK42+Flc2seIPiiidRQxGA08R+w1yv2pBVKhO+DjFWBS1a9Qi2YMYduCdZ71GaHvakuZHKXwZDCejiPrZBY2bzNf2GGp8sWBgtIn+MqnQUf1KNxyTkzruuo2s4psJXNIV2JgmlhcxRfo2YzVi0ZavBi70UrZJup9cg4541ujZUDRU27239KPjfsLfik/KQTihiGNreIn/mq8Va9REh/Gt1/cmCbOVickiQ5QbrnTXEJlB8aDwe0qTMQApyV9eZwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F49JQ8YSJo0jkfCfCOIVhqKeR6oPLeftwC1ynjQJ+Ys=;
 b=nwWvWz0iSktt2pIEofYaHa1MI7ypXdrb3UMMflOIURWEvjXnGonc0X97xyb+2E+RUPzIHBiAIzC2V2Cnjz7qoR9UAfSfF52kaU+khGZY6WaB/CNv/4Ay2EXsOSvDbf71+gWPXPGuJaRlADCFtnA1cbdGACfAXzp8qzfDro/4s0LdyuPeyAvbeNe01GwoRJW/st6y+bvgNHlc4de4Zuz7UHZtCrWF3ilPUlDyIbunSEaQv1drE7PqcqVyf+iZCCl67X55d+l8xadZU3yyD4cJcRtxFWW7alRZiLIaqkgdXGr29DhqWtpukw7F7l1iG8nEcYGjE5X7LBIt7FcENPjrWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F49JQ8YSJo0jkfCfCOIVhqKeR6oPLeftwC1ynjQJ+Ys=;
 b=C37iLfp/CryhCfTJoaokbZUTls0lk3QqT0KvRdqxQhn1s2z6q7s4v051R7fDNcWBL1/bj5xW8+pU9PxDXaSeJOmOj2TEvRQeiXgV6TZBwMLoBQTRRFx/VItbWxygS5P4CaiMlpwC5mOYzNClmKQn4UyofyBmv/meE9YB2qCwG5RFNXgRdTJmqcFJrqe9VFpHqGEpoum5lQTq+W/Hm6WvNmgTDJA+ZQPTqp9LP3N0OrWdaLZSS1Unj3uj7dJzC/E578hmOxrQeDI4nO+xTfgRElOVj+JdVsHpcpeJbcvAbiKm12ptm/ctYrPSYkSh/Qvy/YsoNV+GjAsNBmcVeBHR8A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BL1PR12MB5062.namprd12.prod.outlook.com (2603:10b6:208:313::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7159.16; Fri, 5 Jan
 2024 19:49:34 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7159.015; Fri, 5 Jan 2024
 19:49:34 +0000
Date: Fri, 5 Jan 2024 15:49:33 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	"Rodel, Jorg" <jroedel@suse.de>,
	Jerry Snitselaar <jsnitsel@redhat.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH] iommufd/selftest: Check the bus type during probe
Message-ID: <20240105194933.GA366351@nvidia.com>
References: <0-v1-82d59f7eab8c+40c-iommufd_mock_bus_jgg@nvidia.com>
 <BN9PR11MB52766626A292048AA13F04A78C662@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB52766626A292048AA13F04A78C662@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL0PR02CA0104.namprd02.prod.outlook.com
 (2603:10b6:208:51::45) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BL1PR12MB5062:EE_
X-MS-Office365-Filtering-Correlation-Id: 2bdbf596-e96b-447d-49ab-08dc0e277106
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	jx+cgt3N56iL8GUZwMHifIkfryOiGsckcQw2faoskmxat+lFmnT4XLA6MZ0a8qK+jaYA8hruo+WaScQ5+v50hE16AtNMIMZrqdLiB0hr8NVBQYvhjwvhWwzHjCz3L1If1/rVx31aROaLaa5A83n3Lb27XYaiC1PLCq4umsqJxkOMDhhLFJeiVBBUwEmVgqRrkpLeCx+a8TBkpsTODCUd8spnq615H7o7Zmwl/ikCwj/dlqfwbI9TPYhzRlFef0AWMMEV0QrtLcRuQVQd2sQTVutym+v4CJSR2ojNK7/egTzbOIvErEFCmhT2VocIsBmLnLOTr57vy4HhssosSEGKNin33785cp9hqor9zuQipksdNEUj8suuMHbexSaEvmc74yBB7n300v0pZTDFKQCG+LihJAWkSDs1mo8sVvbMY+Y28RSspy9GR0NgeOaJHrltjPk1umCv2hU3FjeKJdCCW3GbjSyYJtewOuGrMhxpjNtSm6WpPg8BUl/TkywSMoiR6+JxzUuIRqjrUYHeaeQzgxxfUuy0yQ9Ep9UU6K3GutEjXwJZL1sF75ha5e6nR6/rlVWvTdB7zeS1ssw4K3dKG+NWZYqG36EOYaO54h4h+IM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(39860400002)(346002)(366004)(396003)(230922051799003)(186009)(451199024)(1800799012)(64100799003)(2616005)(26005)(1076003)(6506007)(6512007)(54906003)(316002)(8676002)(8936002)(36756003)(2906002)(5660300002)(66946007)(4744005)(6486002)(33656002)(4326008)(478600001)(66476007)(66556008)(6916009)(38100700002)(86362001)(41300700001)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ocM3Vjrqg1L4wNSyhfvQYMJlNjq0Wrc+WCwhBEO2NnY956czRx0e34iWZlJT?=
 =?us-ascii?Q?TeYCapUK6NRnUjOcTruM9qe4C/iUwCuc99TD6+VAW62smfp5OT6lkLdsq4hn?=
 =?us-ascii?Q?wYc7SUNiXAoTZ/PCmJevUVNd9hTFNAAvwj12urdprHRzQL/sLpElZEgHhzF4?=
 =?us-ascii?Q?bEfGNSbN0AxkjNyJCHKuc4nbA4OHklm8d50AxVdmpnMU4+4ZdA++m7o5fMP+?=
 =?us-ascii?Q?hdNy8ib3SVtLMu3fsxx1V2bTIbx9VwC7FCL3lVwKeeQQZfzcWQMzFtcnn6+d?=
 =?us-ascii?Q?tO/fby4kHN/bJRkTy+Lz1/Mvz6t250J7Z5lEFhhpvGyyEJcAlC3FJmC29a5j?=
 =?us-ascii?Q?u/1kBuoqMB3Mz2TicK3HYVq7nfmTx/0PweoZP4wV816xI2ZGP1mIlrF/8d1y?=
 =?us-ascii?Q?TNcgoFg5c5Wf9TZUN66pdAfLvyd5nUMzJzIHBLNkCLbFCubuMrSXGJdkK4yZ?=
 =?us-ascii?Q?P4rmdp8JmTZ34pzepEKZYTZhyn1yBMJWHPx8p2Nq3Bw7U3i1X9a5omalyI8v?=
 =?us-ascii?Q?CBs0JRdmQhDC2w7L9kHjsXAz8T6TZW4pUHvcROf/tZJgh78WZs+SMsEi2wJe?=
 =?us-ascii?Q?9PsE6nXGxwE/JrFmUYmABfo/702xVeW+7N/auI2vLHz7vTggi6b2vdhkpKQU?=
 =?us-ascii?Q?PguilLUl29Ec0Lvo0PCVdUC7/bTQcfQGI2lh8inHWXegHJg6njLfIBQpXabL?=
 =?us-ascii?Q?3i/ar4+bQEbhnm1C/q/bVlNEUDvc0o/2BAFEfz4aE5kTXEOEW5DEMG2vflkL?=
 =?us-ascii?Q?1oDxYl+Uh372LVUI37p5Odnla5dRtWfjpEmCc8lRY3Ej3QqwKJ/IIbrrPe5T?=
 =?us-ascii?Q?9Ou++6UDm3JOCt5FYPvwBKf58UGvqCzTvpgs0bdl+y0bCq7+PbMjYSv+7RJQ?=
 =?us-ascii?Q?+lrS08l74+uQjDPbCm3t9uwvOmiSOarA0lO2r2NimiZE8xlEA0QK3qQvWEJX?=
 =?us-ascii?Q?7QSpSsg2hXo8nAGLnm2Dtz6/Gc04t0+TUc517jyeOMVZuirrn18PQSIPjTrP?=
 =?us-ascii?Q?a1UWwQgjS0+LAGUKmPSoiXXVjES6imjfoOerF1YiDAWjhyzTnSoCI5jJZ6EI?=
 =?us-ascii?Q?G52A1MVVmN56pquVZ+SSsigWZPwLxhfBCZOtTCyP0Xvcu96gKCpSzFeb32Iq?=
 =?us-ascii?Q?TFY9Se3mn2QvSlqRftFVtTj5i5515MDl9aSF1VlLm0DNBxi9TszeMT3L3Y5/?=
 =?us-ascii?Q?PIpLRZDAfRffGG5x6DeSfKemtN7LwmSBaTGR8JtxoJS30hFF7lCx4RZ/wJ9s?=
 =?us-ascii?Q?SOhB8VG2/RokL6HAhcRIk8sIYb7MtFGjWvjjvEGk04EUqys4VCEYHXti9aRs?=
 =?us-ascii?Q?oKd2z1CLnLj4hUz52ZKCchOVY1z45M2SKjyE+CVI4Vd5TcIZKhBhj6zkmOXO?=
 =?us-ascii?Q?3eLgeM11/r/H1k42cgxu/ywNK21hxVCKErMhyPxQgkyozWcAfKSJW6Rfv6ZH?=
 =?us-ascii?Q?AYs4b0gDllWf0t0lMBsdyPxX9aXvifuHr5f25hQxt0b0LOC4ydFOiVYDDm0O?=
 =?us-ascii?Q?Y8lGpCVpaqQOqUtwkoY+U+BC6YcroSXBqxjoWfgPO+OmaTuvHERrTteT8ePD?=
 =?us-ascii?Q?MfPlozSoljf4n+NLST0=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bdbf596-e96b-447d-49ab-08dc0e277106
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2024 19:49:34.4227
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3ouTyx1pzV9gkhlBWrgdRZ8kr6d5i+jPNq/sXkV9b0Gg4mkNLo2Reez2F82yl2b/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5062

On Fri, Jan 05, 2024 at 12:38:49AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Wednesday, January 3, 2024 11:27 PM
> > 
> > This relied on the probe function only being invoked by the bus type mock
> > was registered on. The removal of the bus ops broke this assumption and
> > the probe could be called on non-mock bus types like PCI.
> > 
> > Check the bus type directly in probe.
> > 
> > Fixes: 17de3f5fdd35 ("iommu: Retire bus ops")
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> 
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>

Applied to iommufd for-next

Thanks,
Jason
