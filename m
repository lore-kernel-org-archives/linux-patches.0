Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2081.outbound.protection.outlook.com [40.107.237.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FD9D10E7;
	Wed, 29 Nov 2023 01:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="m+5XEkXV"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cmw/m/F6Js3pypDdSZOK1AMixdZ8viP3IDVThSzaQLLPdJ1G2gezs0VgkahZMQaOZEhDq5GxaHFKOqU5hqzwnzTbDraGo+2iJ8PJ0wpKb2ZsqeLtOXE9olyLLrTZZEjJJL7ZwW4h+8HFROFmeKxp9SCf9vYAgtMQCrxQ1Ue03IbsFw6oz6bhMyyIE3wKwf3D+D3pAf4raAgvmlz5kjhgba1gaPqYHv9ADJxdaAg+1QKo2k7Lxu5MPjsafzbJGP3zor1QJ3ul0yRudEaU6h806itxPA47m/2EC0SzHG/hLMtPD1wQTBU4mKy/MPmJiWEp4i2XbwvIgWgBPNyc7ALGgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E3Q+gelrtXUdi1gl6/JJO7QyEgM942d9umm3jDDo1H0=;
 b=SpKKmUq3/6hdmcfUlHUNBEBO/CyV8ZBA4k9t7aY3uzYrAMq+3nX8DmbrErQL+PwGHL2DvmJhD1Ksz1/cXRe5H/5oDeq1PZd9UsME6VrVQ0rHP8DKHP/o74Vsdd6O+bFFxlYKLO9snbD9xwmhyVmnVxKvG3t2vhM07wGmnh0SgxZj37EsMEvLAU97+DYz8w1BEsZLSnubFOHzGGwMn53jzqZSWn4lyZCeEjBa3Pjm2iOdtsjEHdOlc61aV6q+XuU+xfnexOE/WyD6EVEOFC8b7hABIL1xOLIinm8jcNkVucfBQHjsEZerv1REcFsVEXLMHuOIIl8W0dVazBs/bruzRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E3Q+gelrtXUdi1gl6/JJO7QyEgM942d9umm3jDDo1H0=;
 b=m+5XEkXVoai+y1X3ofjbOdl5PNgNmhwxTUg5IJAL/7oxn30ZGYWPhgamwmChCMkDSjLoqDPP7Y4svi/0Xl9sQY/egnGYQFmAnDccmB23USOzMYUoob0pgNxP0cJf7tgjqyM/9pdw2Z2s/9IfCE4NP+BkRNCvVH+feAQ6YsPewdk7noBpdrNf/RgxCAVzEmdmAUWG2OS4dHVhXXgfx6f6PAUx73exUWMskxwmABUfs99M63x+W4TZYc7TKQ4Kl1OGQntv69tfad/xpsKVxf1vPsEzG2osCsEmalei/yomo5qsYr9Snbtxnsa+2KA4sVjA+nuxA+9TDDc34SQJq+AMgQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN0PR12MB5859.namprd12.prod.outlook.com (2603:10b6:208:37a::17)
 by MW6PR12MB8998.namprd12.prod.outlook.com (2603:10b6:303:249::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.22; Wed, 29 Nov
 2023 01:03:11 +0000
Received: from MN0PR12MB5859.namprd12.prod.outlook.com
 ([fe80::7d0e:720a:6192:2e6b]) by MN0PR12MB5859.namprd12.prod.outlook.com
 ([fe80::7d0e:720a:6192:2e6b%5]) with mapi id 15.20.7025.022; Wed, 29 Nov 2023
 01:03:10 +0000
Date: Tue, 28 Nov 2023 21:03:09 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Eric Auger <eric.auger@redhat.com>,
	Lixiao Yang <lixiao.yang@intel.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	"syzbot+7574ebfe589049630608@syzkaller.appspotmail.com" <syzbot+7574ebfe589049630608@syzkaller.appspotmail.com>,
	"syzbot+d31adfb277377ef8fcba@syzkaller.appspotmail.com" <syzbot+d31adfb277377ef8fcba@syzkaller.appspotmail.com>,
	"Liu, Yi L" <yi.l.liu@intel.com>
Subject: Re: [PATCH rc v2 2/2] iommufd: Do not UAF during iommufd_put_object()
Message-ID: <20231129010309.GT436702@nvidia.com>
References: <0-v2-ca9e00171c5b+123-iommufd_syz4_jgg@nvidia.com>
 <2-v2-ca9e00171c5b+123-iommufd_syz4_jgg@nvidia.com>
 <BN9PR11MB5276FE18B63A22DB64EBD8098CB8A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20231124125006.GC436702@nvidia.com>
 <BN9PR11MB5276CF21A13C701838CD309B8CBCA@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276CF21A13C701838CD309B8CBCA@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: SN7PR04CA0198.namprd04.prod.outlook.com
 (2603:10b6:806:126::23) To MN0PR12MB5859.namprd12.prod.outlook.com
 (2603:10b6:208:37a::17)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB5859:EE_|MW6PR12MB8998:EE_
X-MS-Office365-Filtering-Correlation-Id: a7bc4d48-4d7b-4d95-fe36-08dbf076f4c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	mvMrQx8YvTiRC1nd3C3Ik3MmlPxJt5Npuc6uQ9b5fBJZ3BaAOja4NmEYceJz2M3DiJM+ciVi+U6FbhVdIYt6Q9/SyDF8WOxkIc4k1epnhrp35dhq1TufGEUqA/ghwlhRZiYUf7SWPYnO6+ZqCeZyWr44hoy7XCas6plsiibAmbCCQ1cDRC7N1D9i+W5g7Is+ot1L63UedGJh8RgR9AFACT5FFgaZtAHoCyBo36Vqj3Lj7mWfyuQQjtvT8UpM/0SYomHlCZDqTtAyzWoo1w5trQhQ6yt+jHB2G9gCydhsdYIaaGjqcjb8o+RrGeipIe2SMoZiwZTMDtL4D8tFWATIOiYVyPtj2LDMI/tv636RgedQDGw5YgLrIj1DCnVxfFMuxnXl+9+eTPZUUr9bmWdDIFAwF/D1g+Yth5VnYzwPBMnn0xIOz0zEOZkyUMDWXpFXGcdVB/pkohJ9wCLDaXH3ckpmGZc256vxKyDuyFJQg6L2LwOedmM02c4WZA/FtaegFCSZefwjC/8HWTsqdaBiReIOGABip8IChytaBnZxxMGLCEhQdNzv71ebVfA3qFqUECUkylT9YMfO8w2SPES96KFLZjvecX/QAjE7yOcKsZk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB5859.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(366004)(39860400002)(396003)(376002)(346002)(230922051799003)(64100799003)(451199024)(1800799012)(186009)(86362001)(41300700001)(2906002)(7416002)(6486002)(54906003)(26005)(66476007)(66946007)(1076003)(2616005)(66556008)(6916009)(6512007)(6506007)(478600001)(4326008)(8936002)(8676002)(83380400001)(5660300002)(36756003)(33656002)(316002)(38100700002)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ks2YjU4DiBk1txIk6NMUALxVbHPnwik8AwxYe7n5LkxgyWbG+SbkTrEvaC0j?=
 =?us-ascii?Q?bhJO4kYQqMX+1bfLOJQ5rGzRmECak/uWKRUUETboXvz0bGkOR068Unlx5XfE?=
 =?us-ascii?Q?OBqrsDL0D795GVAKo00YFNA8kIV0ZTO6EYNRcdJzc6rZ03mtWIuG1ASuRz+h?=
 =?us-ascii?Q?FWDtoGm8+mUIUF1ROIbhmsatLzqQR1x5i5B3s86jO4rXxZf+0cCCl1oivF5q?=
 =?us-ascii?Q?QFL0TXQZNQpAKTC67f2yknLAAC+3DnrGjG1Lvw6GchNYnC4/mNGu/YDDLYZk?=
 =?us-ascii?Q?3l1aJDJ9SWCAmTHOv0aWYK5RjXl8al+Yu2AMo785UtRLL3XabmxTfvMPoFSc?=
 =?us-ascii?Q?N0Zi9RCH1T0/wYv6fT0M0Pp2vYeOFtiOGWEieKYYbeMHhunkCObLq+eS+2D1?=
 =?us-ascii?Q?3LKT5WIPAbB0xfl30IU6jfdSq4UrdpryYVbz/DsGGQrfimSOi7gIHJmrtqO9?=
 =?us-ascii?Q?XX//psZzSM9o+Z4VRIWt1zlZ/cLSQW/JxAFrVTpcMpJ57aX6B5LOXGcyCL1r?=
 =?us-ascii?Q?LaV5xJGWH5k1jeVUnE1pmK88QyU1Z2/K0pTtw5OntJai3gb4FKXWJsSZ99Nu?=
 =?us-ascii?Q?vXUs6qxWcj0e2nok9QoRHLGT4XFX/mV6smSzDi+1WmEjSwLcPZJogyHbce6a?=
 =?us-ascii?Q?PEsHigHdioxx545AF7Gf/f2WH5WNlH5vZ6mz+CdJaCRD41IRAV424Hhffcfp?=
 =?us-ascii?Q?6cfnUrYSDlxwDv2RYBEWT/OuTS7yQjP+TcZBEQ54sKZNNMGur1sbIeObzm3F?=
 =?us-ascii?Q?9JE4KUYv02VwqcFGUkjXHRZXfSo/r2cZFbqM0C+H+59HhUF4FmI3Gip+J5Yf?=
 =?us-ascii?Q?UwxJ1Wv2uyS34vuh573Wszc6R6re0f75QocdsyoTJnghGcGGbwP7R3RDwuDX?=
 =?us-ascii?Q?h0tp9U5nRoAimfA3xy785s3mw4rC9kj1gKgqCg7zRxZANU2LFH/bsLUpS1JS?=
 =?us-ascii?Q?ueS+PJNOOJTtqmG0gvlVyiWMxUdtfAzUiqpaFo/dZQnY+Q9wkZ2aXw8AJgQg?=
 =?us-ascii?Q?s44XhVeL0JWv/ujbvlML5/Kwm9RRkrME3wD4tOuIbYQ3LFOoyp9daeMmXChp?=
 =?us-ascii?Q?trK5udmkCiVdvq88an80uZOqe9TLgy55xOVDifGx51fGyC/Tz5hgea40Gs44?=
 =?us-ascii?Q?W7nIvvcPsgxNFFZkOMIyrZ4A0H9de3MYkZWP6jyxsgj1ou5bINpre4wl3h/0?=
 =?us-ascii?Q?QxeOmK3W1pDUnRodgf0LtwNx6H46JAeyoIIEmeb2vMdkYQjQD58vjZqWwfiQ?=
 =?us-ascii?Q?SdU47PhnigD1NFlviJzrd25j8Ty5Mt/urFAi34ptsuRnx6zW1WreXJ1s/e0u?=
 =?us-ascii?Q?UeVrVsGgzDFCDdcwONOkvm6W3E9dcDbvwWsKPFNDLI2aPZfw3iEdCOhL1OhR?=
 =?us-ascii?Q?Xg2EvJhRlGYeZVKTtO26W+xZGH6xewSU2gKlNc8N5E/vyxdpOzyEfVm0vo3w?=
 =?us-ascii?Q?LqS4A0lZNycYZMW+tRbxXIrXeK72wkRXyX193dzP7YdzxD3yvJrZtig2HEbe?=
 =?us-ascii?Q?8pUcNM1pH4rKR30wCUFONGUj71WiZb1RitDDJp19fQvZkxaZwr7s5ZZ46Pb+?=
 =?us-ascii?Q?JfmJkYFiaMF+eKde+uRPjlOq82+u7co1LA/5S3bM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7bc4d48-4d7b-4d95-fe36-08dbf076f4c4
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB5859.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2023 01:03:10.7838
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3mnxAb3BUBMzNMVax7VzJaK0eGHTf+3jIiesVIHjkU0TE55q0TBTXZLyu45WfYBW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8998

On Tue, Nov 28, 2023 at 07:59:29AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Friday, November 24, 2023 8:50 PM
> > 
> > On Fri, Nov 24, 2023 at 06:48:59AM +0000, Tian, Kevin wrote:
> > > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > > Sent: Wednesday, November 22, 2023 9:13 PM
> > > >
> > > > +		if (ret) {
> > > > +			/*
> > > > +			 * We have a bug. Put back the callers reference and
> > > > +			 * defer cleaning this object until close.
> > > > +			 */
> > > > +			refcount_dec(&to_destroy->users);
> > >
> > > explain why refcount_dec means 'put back'? also 'put back' is
> > > inconsistent with the earlier comment "In all cases the caller no
> > > longer has a users reference "
> > 
> > As above, "put back" means to have effectively done iommufd_put_object()
> > 
> 
> Probably just my English problem on the confusion that here 'put back'
> means removing the users refcnt of the caller while later 'put back'
> means adding back the shortterm refcnt in the error path:
> 
> +err_xa:
> +	if (zerod_shortterm) {
> +		/* Put back the xarray owned reference */
> +		refcount_set(&obj->shortterm_users, 1);
> +	}

Let's use the word 'restore' here instead of 'put back' :)

Thanks,
Jason
