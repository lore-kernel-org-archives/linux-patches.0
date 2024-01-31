Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2053.outbound.protection.outlook.com [40.107.93.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 703C91272B2;
	Wed, 31 Jan 2024 14:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706710342; cv=fail; b=RWvJMEEjiqW47RM9B92dkJYXVSbAlbNtMtfe8ZQdx11udmVjBbsfDmH4lZ6tbDEzX9b3Ld2zQeA1HN+Ip5cm+fglHtGH2KkCVyxbq8luT0m4qxjY7W2bK2LdcQ0H+sXLzJ+ErFurgM82F79qwwKEMFXUNWgbpdEwIO6zm2NAVBg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706710342; c=relaxed/simple;
	bh=wxgoRSI6WJDi0xxojsf9u+d+AuME5W0eYmAdyjBdFSs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=HnkacONdG0/uHlWGr/kBB+OWPF3/gpVmPbAKYqCbQKZEiLZYsE2ZEcCGRjR/BR65VlPT914fIlYS3UNWMskCDrkTZnNu6LEXzqp54j66Mwmqj+Lb8QjKFP1Xz5W6TTwihO686dxQ3Lk7ZplMPEmjgQQXx1APCALeEvMqwdVCQWE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=aEMWJ/oI; arc=fail smtp.client-ip=40.107.93.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="aEMWJ/oI"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fQY82E560LJvEUz3ToRI7vqeBuIy//Ut6mZE7m4hRtlUsqU1PCL/3z6NJnRV5NwLS44QUrKoNue4I6PjsnM85OD0scaUqwK+ZOVi9Ik+X8fNKjmAMkWD9qPtyhagP69+3iOmT2OB6C40xsL2embnyUSbUTmM1TQ7Glp7UTAfAFGiydt3Qz/95b+dnJfPluwQ4imPrXuyOBLgF/I1/5TMRhKgnwwEvUzL2NPYXqTtAQkG6LSZTl5/b9im0rYWP67RHrTgxi1OeWs3U5ZiLtPvT0pLK5BsXBXW4nkhSbVGY3ajTMPcNhns3WFAXGUAub3bfBC7tr6v2c6+SjgT/OjZYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5Qy3pK3LRXnxFJT8/zwRp+sto7WjN0MxXBV2XCLc2+0=;
 b=YxM+ZxInBayick1APm2doQzOWxUnd8Ejkzm+0PDjOCixwXOU5NmTfql1BJP6NwhQDW3y0+0DCUBXcjt//SetpZc2GJggok5ze7inRSHqYVsr/kn7EFAJjTbPSxxfRlBa43eqxbGTj5DlCMAbGgRyNHIA5JNQTuTew5G9IrkM66GvXQs8r5qOSlnmGYaRLEyXe8kf1xiY519KbTIPalEiUCbA0mitiBAJ8d8+IjngirCR2u3YZAaY3FgbI2Gih/F0y17kijyuGhKHRFmoaqMraDmJ/O38ePFgoDRW7MaYIUJRKMEwBNB3V0ONq1k9ULthb0ve8dZYXVik4/sNwgjG6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Qy3pK3LRXnxFJT8/zwRp+sto7WjN0MxXBV2XCLc2+0=;
 b=aEMWJ/oIDyq3G+pwjYlG6gnx5TCwT+8LE+tSEN+jVreEu2CNh9UYzKQMDFNr66DJASSdD+/NH5BiFAoN+7hUKEOBIvLtveDGt845c4M3ttwMlfgMlq0LbZlzlYIRzlZ2VqQu+Y91ZWs83kI5wP2UeE95NdFVQJwu1ulicgcZbrlsCHbnajHwZhnX1GaJJPVgaMxDKqAHyPCO1HDWP3wDH1KQ5pF442oZ9l0HN3FTUloF6WiyYmE3luTxLZ+DY/+Lx/DljMHRTU81nJsFmM2yWIoLKoNHBTKrmVJMhnICN1NJ468ea4pjJtnFeL/iM+nLyJOF8o2CevQvJAunEOVrjA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CY5PR12MB6204.namprd12.prod.outlook.com (2603:10b6:930:23::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.24; Wed, 31 Jan
 2024 14:12:18 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7228.029; Wed, 31 Jan 2024
 14:12:18 +0000
Date: Wed, 31 Jan 2024 10:12:17 -0400
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
Subject: Re: [PATCH v4 14/27] iommu/arm-smmu-v3: Make changing domains be
 hitless for ATS
Message-ID: <20240131141217.GG1455070@nvidia.com>
References: <0-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com>
 <14-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com>
 <78401f5d541042f5a71f13bf8af7ed3f@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <78401f5d541042f5a71f13bf8af7ed3f@huawei.com>
X-ClientProxiedBy: BL1P221CA0026.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::27) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CY5PR12MB6204:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ea9631f-0c19-43ac-00a9-08dc2266a1e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	UBnn3U6kai+OYPcPV16VHVBw5PsQB0w2PUbN9AyQeDIJT6zbycrRxf8ANzddu9wbvi7Iij2nkZoMPDnjgfG+LHKaMO+1oQghtkGIyfi1COjgsErYhGYN/0ob5m/GPSaux8ruPU8h8wUtEURsJHVavG+Ld1XwKndIzGWBiCyL3pRDKLZF4eRdyjsFE60zqsJcwsXFtVmXC4lJ0JytLE33Hlwa8H4r/EIMiUbRmLISd9FNvwEURRUoBZccfkH8p9/GFcNF27THBH5kCkIj1Vx7CatfVlTNlBU05JaGOkqdcru2o2pDasWnDVBEC9WfSTBZcelb3OGaBHbrWMdkNrxWpQ03p1Wm+hQQkzPGktzSefetGdJ3pHQ+aR105fj8GL9DjprWtc7jHCwyAROYC3s8YoTe9iiPK2MkayUm+7n+ZI6TePgQqKBupjBkZDi+UgjQlPkZAgy5bFh57gA8HMOKtoULzqvYwuSBdhFGgbdynDETmqyqFC3jOC3KTrVTdshh5qYLuujc9kLGgNLOt5xddrReRFF+13GFaDHAG43BDqlYcpWHLkU6lSVehX46k2+B
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(376002)(39860400002)(346002)(136003)(396003)(230922051799003)(451199024)(186009)(1800799012)(64100799003)(26005)(2616005)(1076003)(83380400001)(478600001)(6486002)(41300700001)(6506007)(6512007)(36756003)(8936002)(4326008)(8676002)(316002)(66476007)(66556008)(6916009)(66946007)(54906003)(2906002)(5660300002)(33656002)(38100700002)(7416002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?w+Hw1anDfTjJPY8MixYlsYJe6GAtiDOqGu3Qke/kLcme8KzMeWQEwAlgzUSq?=
 =?us-ascii?Q?nXJNT0mAbqslMqXExB8SPponsMK/hqKeXoPm4KeEHcWDkp0BbB22LbXhNSNe?=
 =?us-ascii?Q?wB7rW+5QiWkG+1Eu9HHlxsaG6w0yOdTCrACeHa9p1xCOHk8x6H2hssp4mpju?=
 =?us-ascii?Q?h08SJZbEz7oRTJQ1GrHIPETW5CMgFRfl/m36cAjWjJ8zSa6fCo4VXevhsnOx?=
 =?us-ascii?Q?jXmQJ5YFZEbxC9EWIjINGtrPWQ4xFLLLyyPnSu5+jFC6dctGCsgdaC8j2+Nb?=
 =?us-ascii?Q?iy7j0yBcSSe+nE9SlC0tuj4gle0MIMycFimaQpq3Q58GCEQCq/4QeJWzY1NP?=
 =?us-ascii?Q?IvUQtha+9h4ESSEQT+BqrM4HQrEOmAjxjHcJGC4mahTryBr4QiXf8guNRsSJ?=
 =?us-ascii?Q?u42TCN9wFxIy9ThtaBZ/RKR3jWyMtnvN0wNIlNgzVvocv8glgUn2jBXRgRtK?=
 =?us-ascii?Q?etcyzvr6Ejneuky3+UJk6Db5tUKbL8nlT/byJvi+4Bq+atT7K364+BctEoRU?=
 =?us-ascii?Q?EOKkrWq8o57fOeU21nxgI81qVT9YEiyrUKsATEbohIh41UHgr9r4ZpjYH4CR?=
 =?us-ascii?Q?jHr+4Q8TgCquC4bQ7s3BAhR+WTfliGZ4p0f75OGkaAZdPTOQU7FahVaWtEPz?=
 =?us-ascii?Q?9qHFVJ8md6Dn0SWtC6CXjfaEAPyPc0Z3PYDmSIPzb8DY6xnXc7J0h92wFn6g?=
 =?us-ascii?Q?LVHdq6y5VD4WgI5ekbUEdG02BcCXY2XoUvLuQrIB4velaVVdJwN5u5yCWMUP?=
 =?us-ascii?Q?fobwrOtFobmT4Z7OE21y0J9wUOhk8upDYvFOvWDIngmSRu0TZJn04k3rZSyG?=
 =?us-ascii?Q?mLPoCvLWugrhFBiqZX5gGUjHyszCktDxCDca3VXz0TvYEj1287x+xIS2m1KJ?=
 =?us-ascii?Q?CewOIOKBM95PRtpZWTSeKjMisu5etehWBtZYlHyUSbqxQYx/s6RR90TJhPti?=
 =?us-ascii?Q?rrC0lEDXmVgO4Z+lTPOVkERcRf5USKvw3mz32F4gRIrc8o3F5sPx01Cpm1YD?=
 =?us-ascii?Q?zlHPSeR6iQJ8q0/sOn2WHdMJ5ekJAJlYYjHcCkEQxQ8U+uOpfqMnuRsgMOvf?=
 =?us-ascii?Q?P29WRvPSktK+J6UQdlYwpKWYylzs5XqNvj6+ZDdlaDS2XdgyORalrpELAGGh?=
 =?us-ascii?Q?mCFRqdoPBmxSb05557w4AEUVXDkKXU6uRbHp5A/A5PsPc/Z1vTFXyOAOn4ki?=
 =?us-ascii?Q?x49NlUM1sSjvW0zYMLzQkBhIR/sFD0/uHHlTKz2XQHZ4Zd0fICRkfF4akpCz?=
 =?us-ascii?Q?FgDPKxcilccpCKeA3o+KcSB/58i3gQS1pIDOlQk3EV2PV48GRRLWFh5CIcft?=
 =?us-ascii?Q?xXs2zZ5qjvkm/0ncQvw/vaoijZNAzhgridX19jikdwCYJZTMaagRlUw/Vr+U?=
 =?us-ascii?Q?RQo9X7QlYOOe5Z6Rcd6sVwvGVj0V+c0haJpWQpHKRATEYxbUWmeEfA4P+hc6?=
 =?us-ascii?Q?4r+BEDBZkkQDCjBKlqRqNuTHxwyI6nfovekZdLlxtYNS+DrZi/iXBm17EIrB?=
 =?us-ascii?Q?MGX5Qg6lyQ8NoGCZxk9sPbxRN4DN77XZoXl6cEkWsZsBAXJ7G0nCZLQefRGZ?=
 =?us-ascii?Q?mQgf9rEX7a96HRPCGZC0uwO0KZVl5gDdvY0y/KR1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ea9631f-0c19-43ac-00a9-08dc2266a1e7
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2024 14:12:17.9312
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1q9IXQ/WX6Qcz5RYXZ60uZNO5qZJtjG3WBJM4APLif2VRqZFp9LhjIHS4RJ3soKp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6204

On Wed, Jan 31, 2024 at 11:20:48AM +0000, Shameerali Kolothum Thodi wrote:

> > +static void arm_smmu_attach_commit(struct arm_smmu_master *master,
> > +				   struct attach_state *state)
> > +{
> > +	lockdep_assert_held(&arm_smmu_asid_lock);
> > +
> > +	if (state->want_ats && !master->ats_enabled) {
> > +		arm_smmu_enable_ats(master);
> > +	} else if (master->ats_enabled) {
> > +		/*
> > +		 * The translation has changed, flush the ATC. At this point the
> > +		 * SMMU is translating for the new domain and both the
> > old&new
> > +		 * domain will issue invalidations.
> > +		 */
> > +		arm_smmu_atc_inv_master(master);
> > +	}
> > +	master->ats_enabled = state->want_ats;
> > +
> > +	arm_smmu_remove_master_domain(master,
> > +				      iommu_get_domain_for_dev(master-
> > >dev));
> 
> I think the core has not yet set the group->domain since we are still in attach().

Any chance you are not running exactly v4? There was an earlier
version on github that had exactly what you said, Nicolin
found it and it was fixed before v4 was posted:

static struct arm_smmu_domain *
to_smmu_domain_devices(struct iommu_domain *domain)
{
        /* The domain can be NULL only when processing the first attach */
        if (!domain)
                return NULL;
      ^^^^^^^^^^^^^^^^^^^^^ This was added
        if (domain->type & __IOMMU_DOMAIN_PAGING)
                return to_smmu_domain(domain);
        return NULL;
}

static void arm_smmu_remove_master_domain(struct arm_smmu_master *master,
                                          struct iommu_domain *domain)
{
        struct arm_smmu_domain *smmu_domain = to_smmu_domain_devices(domain);
        struct arm_smmu_master_domain *master_domain;
        unsigned long flags;

        if (!smmu_domain)  <---- On first attach smmu_domain will be NULL
                return;

(this is what it looks like in my version of v4 at commit
595a8ea0f0ad60e80412dcfbc36b74af7116ba4a)

Otherwise I don't have a guess.. Can you narrow it a bit more?

Thanks,
Jason
