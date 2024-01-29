Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2063.outbound.protection.outlook.com [40.107.100.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1348F125CC;
	Mon, 29 Jan 2024 18:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706553477; cv=fail; b=rZUhMkqMhbNzqIfg0y551SAkwfKdwu9VXJDYTJjy+TI2UzW4W7zJ6ay3CdE58Xv/VS6pyDtD5SgD293SKvws2suvNewiL0PZsuzZrZgA0uRz0LMEW8cRvNP0q99DZx75zLtmZHnLAA5XHGODMdnsGE0fgnMTCuwp1qj9QNv1Dcw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706553477; c=relaxed/simple;
	bh=iJNgyzrbujWlFjMPQcZMY8siKKsTZ7TFins1g0LCfXE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=YZwIVF/bYLJ87girHL0za2X4zvqeP+TB70Y2KTclXvosFeIF5h8DpLjCiKelRI4OP7Wf3HCGAO0qgVNxv5G5c13CFZSmpUisXKZiIiCjjF3TZDMT6Xocl/wxqPdlBB9IsX+/djVSvr94aUk3ROylYcJVHWJepTrf3qDlIhi7/Ow=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=c5Bu62wk; arc=fail smtp.client-ip=40.107.100.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="c5Bu62wk"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GCpNXL+lwZ+K4QoAyxabLhAwDmDpC+B1hO3kvSogYOqqyPChpIuwb01f8w3Xc0lJBAtEqLroAKMBccAjrc3Z+nNPTn2xbFdRzMKaAHvEGGe4xIGeStjIWZRVMx/wqhRNGIHrpnhZ4n2Um0efk34y5618BLxboHDfaOtckf8flYvNyO2jA+dDsgkgj6kpLReWn76UGV2x+Phw3WOOxJVRMiabrig/vRBffSLS17SkXuaYeqf7KgDa/YhLIu1E5L8fYXBYrqAoIP5/D4+B1APGThOXArbRq5BZPm0T90I+zJLVs8EgUrGahLNTCPItka3qGews9yu9Hd0PZw/LeOtPLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zaE1jUrjPhNxTIY0MqAluCmrxYRLcT/vzFMokOxr3os=;
 b=EDoXQ8SMc0TSQcsvBII4s0Xc+1GXAQ3u3R7zhq1ZfXnxiFEAkmWQG4Izy/VKW/pIkXF5KFn1bkNcllfVYGUzw48w7VXxAYrjGXlYCnF5SFtNYCY06CY8LXQpdCojLX4eTvUlVn/miBq6TvoVQ04rc9As/WOIQaLKdHsw9PmntgRajtjEud1hTewPR3dSWvA6H7GhSDvhPfQjPnX23kkGk2nRJxbjKC9+HzkhYxDi5P0t1J/G0SsmfOSc39n6f9urVlt2z1wqq34nkLlme+gDmPYZXn5Aq7V1+v24Z9nhquIilzNN8lXL6IbD2wLbsd/kYK7B3EJtlTvd3r/N6/Cmmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zaE1jUrjPhNxTIY0MqAluCmrxYRLcT/vzFMokOxr3os=;
 b=c5Bu62wknfwJQ8byxtbVZKS8Jii+ED1YKe7jA4rqrNdV0U6bZZ79pC+6g8nw6N7mMpICXvPqW4KNNN8GkwsUghi2Uv+xkhEMBahrcd3ZdCSZB0Db81aDV61KgMMyyvK9kBungGUbZPdfqZb26dOwC17yNFgLUCNuqTm7lPppScodeHgeLCHK265xFOFZaJWP/yjXObbP8t4QTLqPIw84yp38uB8ce74bIISkVZQN003E3cMya6lSqKRzCaB/KByjNkNgbk2OLuPciden+cHvN5y8ydoRbtvhxlooEAKQlLg9BnAsnzmIsJxvmxuHfOo+aEJuJv4asObM4zVwVR1BvQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB7817.namprd12.prod.outlook.com (2603:10b6:510:279::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.32; Mon, 29 Jan
 2024 18:37:52 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7228.029; Mon, 29 Jan 2024
 18:37:52 +0000
Date: Mon, 29 Jan 2024 14:37:50 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Cc: "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	Joerg Roedel <joro@8bytes.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: Re: [PATCH v4 12/16] iommu/arm-smmu-v3: Add a global static IDENTITY
 domain
Message-ID: <20240129183750.GZ1455070@nvidia.com>
References: <0-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>
 <12-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>
 <2a828e481416405fb3a4cceb9e075a59@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2a828e481416405fb3a4cceb9e075a59@huawei.com>
X-ClientProxiedBy: DS7PR06CA0004.namprd06.prod.outlook.com
 (2603:10b6:8:2a::19) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB7817:EE_
X-MS-Office365-Filtering-Correlation-Id: 757d32bc-77cc-47d4-fe0f-08dc20f966ad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	OL/JkiCXPfzxFDDLRbG2QDlBx9FY8w+fWvwhcL312Zq2Ro0NLylE4vsyACb8f2hMv69S+JLCW7Bkhdc+U7CMuV8raQg1Sa5404tz1toT7JslrUiISAPAjbRkWxk/RoczM1rSljILjtaTs/AbAmNrSw9P7OiJ1WT3jgiRsrn6m7VXwgDzm1n/HezwNXs917P57sjylAmPhpkdMn1o9HEYYQfwAhToAqEnoxwxjdRWZQv1ZGlCvn/QFnYhe4dgJBHQ7ioDd/ime0+fJvg8swtZ3BTNPhX+6ktMsH8UJ6R0LJfCHcbPiH4vAi4ccEB185Y72BLr3twVkrplM4GDbA/s6QRNuH/PH3vx3TKzL10H2KXhKnQM5RmRK19UNkksIQoY6pg5TgzfNiB6xxd+ShCQgimnUj6vOcJglkhOokj+xF43tiRMdcm2E5CkFeGtC28NI+s7dPQKWnS8gSNhArOQ98P/unCegkkUw5v2PPsBvQwkvLvqsLEUx0tRd8yTXpN0+djjhP2VkN1xiVzR3w0/VlYBKWIuE1KB0CYg6nbdLbQeoJHx4RXx3sHyJdvSWL5+rmwUQyrvu/GlMDR/JYWLEhY8Mt4O9tjxpznHOCt4Kmo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(39860400002)(366004)(346002)(396003)(230922051799003)(64100799003)(1800799012)(451199024)(186009)(36756003)(54906003)(66476007)(8936002)(8676002)(7416002)(5660300002)(86362001)(4326008)(316002)(6916009)(6486002)(966005)(66556008)(66946007)(2906002)(41300700001)(38100700002)(33656002)(6512007)(478600001)(6506007)(2616005)(1076003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LUdysHYsLJeFSmoGrRpZvYWWkYazswBuDFYWByDID2WwaFrCKmNHCHb4iYIh?=
 =?us-ascii?Q?S4l5Hm5/b7xjovOe7ggo0JSgjub2KO5NZCPROwgGXDy9bYAiZ8j7R9LLKxWk?=
 =?us-ascii?Q?wJGOrCj1lyDEGIbmaLHNWPhASUrgidHfmuoKxbW9tgDOWLGMZzGLicw2KirU?=
 =?us-ascii?Q?sq471sMBq+2JnEE7M18+M+98GSl3uVQD9bfC/3laG6V7yDwBvvbc2Zs3YFe4?=
 =?us-ascii?Q?Rw5iFu41VRN24zaL9gOUMaDYtBqL9rdyTnxc56aWlsaEcHnvfryNxWxbL9Mc?=
 =?us-ascii?Q?xZXHCxhqPIKTaxgjmDzeZ356rOPEH8YG1mEsF3s7S/uSwXq8Yu3V2ckNjql2?=
 =?us-ascii?Q?b6g9DVYWQYoyuU/vw9ADi+11DhU8AwQl9iidnUb63snPel1AO8DOe/kCWvCU?=
 =?us-ascii?Q?iKZlzqyVXpxUEJfJsVoZxx1oToc1SMaraGc+hqpBfq/N0nHiuviYOMZw6Cu3?=
 =?us-ascii?Q?MBB5RAxQZsmHJFh8SjeMHVSECh2fRXEIFsAxYaV8K/oC5Zt/NXxBNTQzFCVK?=
 =?us-ascii?Q?XCIW2VX8jrPd/5UIe6AGFvt0O3YxYYeU25hKVxtSku0vHV9oGRw7wOVRrq2r?=
 =?us-ascii?Q?S7HegeA3IkEwFZD7hFdX+1bemyDdYRQauNXmzAi6goQQbF8sjt6PqZF014TJ?=
 =?us-ascii?Q?twfCQPwOcWr59rX0gHcmNLcx+FKMRQaI5ActQvLdY9wkLwTrT7x9QnUjPqON?=
 =?us-ascii?Q?shCLrkvYg1K24m2gegZW2/V6gkdI0jaZDKTr0s9VViU7PAutLeSWqEbJQ2Hg?=
 =?us-ascii?Q?116CuFhgtD4rcqdsjvWweTi9Dnz8jHeTY3fO90dVcEIoggynspcCZMYGCAa9?=
 =?us-ascii?Q?cpbtTfJTTCaIj156mkV2Ug7jAOAV1NhCPI8MmYpjuWIXWnMjHz888W9rtxw2?=
 =?us-ascii?Q?KiDhA6KrhZ9x9oMqJ5P8VVjY0EgGsMPbkP8D6TXKqCa8RT96ckV0L4Zvvwjp?=
 =?us-ascii?Q?CvCze1+h5Vih9XlixzsmPPXSj09EI+aZQ54MmEicLbW8QAFrXh5SzzXlmPhi?=
 =?us-ascii?Q?CkquAtKyMY6rYoups4gbrQWJs1cAT4e+VNUn+E4HOnuXWjC12RGTovDic4lZ?=
 =?us-ascii?Q?b2ahnAOiiAbMy8RKAUINvCc8e1CinJ8UvB0II0syCAMqcN//VMD5Cl17kW0n?=
 =?us-ascii?Q?IHsnS/jDeqB/fjIz8C+AT43L7kWaLd6Ok8hB/DTAhJ8MG1P8VJzHvZ/MWqB5?=
 =?us-ascii?Q?Helu/9YHCYQH8ubnG5ZN2gcanb9FqBCUiUvRa+LpijYMG4GOGV3/k6XihVfY?=
 =?us-ascii?Q?cPy5Jr7IxtctAmkKzZXJY3iUS6f93IwT8Z+ovmk4fbJRsmYLfE6BqGrTaD/K?=
 =?us-ascii?Q?eUSlni+sy1ifE3D0fo/nwSrttjwUaOqwZMFwLK7Nc/0ceT8B31Boe8Xm7qKU?=
 =?us-ascii?Q?nzcFhfoomMshsm3fd/Y5boOsD1/Qb3eMWBsy023zN/iDJIE70al5+/r7TnuS?=
 =?us-ascii?Q?1XuHCp+V16PZ+IITWyanTGmwQz+xQLJtEvTg323g7bJdbHRexiPyDuTeRVdX?=
 =?us-ascii?Q?pFpL4ZySHpHnYfiwwavsCs1pKlqNKGyBwRMe83aEka8N1UfvWk8wu+40A8zn?=
 =?us-ascii?Q?/AZ4JSQibzt9PXbtb2l5+yUfcbJfDsSG7no41TP9?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 757d32bc-77cc-47d4-fe0f-08dc20f966ad
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2024 18:37:52.2618
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A+5Jj4op546BZ6LlQ9eXs5xnUara94JA7mIkJsmn3uk9qqKbpR5nostTwvLSc9p0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7817

On Mon, Jan 29, 2024 at 06:11:48PM +0000, Shameerali Kolothum Thodi wrote:

> > @@ -3056,6 +3089,7 @@ static void arm_smmu_remove_dev_pasid(struct
> > device *dev, ioasid_t pasid)
> >  }
> > 
> >  static struct iommu_ops arm_smmu_ops = {
> > +	.identity_domain	= &arm_smmu_identity_domain,
> 
> This seems to create a problem when we have set the identity domain and
> try to enable sva for the device. Since there is no smmu_domain for this case 
> and there is no specific domain type checking in iommu_sva_bind_device() path,
> it eventually crashes(hangs in my test) in,

Yeah, that is a longstanding issue in the SVA implementation, it only
works if the RID is set to a S1 paging domain.

I cleaned it up here so that the SVA series was cleaer:

https://lore.kernel.org/linux-iommu/1-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com/

> iommu_sva_bind_device()
>    ...
>       arm_smmu_sva_set_dev_pasid()
>         __arm_smmu_sva_bind()
>            arm_smmu_mmu_notifier_get(smmu_domain, ..)  --> never exit the mmu notifier list loop.
> 
> I think we should check for the domain type in iommu_sva_bind_device() or later
> before trying to use smmu_domain.  At present(ie, without this series) it returns error
> while we are trying to write the CD. But that looks too late as well.

Oh wow, is that how it worked? OK, I figured it was just broken but if
there was some error code that happened indirectly then lets've move
the above patch ahead of this one.

Thanks,
Jason
