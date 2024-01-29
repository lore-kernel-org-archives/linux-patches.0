Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2084.outbound.protection.outlook.com [40.107.94.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3293E154448;
	Mon, 29 Jan 2024 15:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706543043; cv=fail; b=HsKJl50bqxxUYZNzIz/tFv0RvEK/etREryzoqdEKy5n0omvti37DIby4c1C2cTlb1WY8vFb70CUC4T+AVQ9BzyuicoCEZY42qqQI9aVaBHnm1MfCiaLsT/bNAVpcmLFpvkX9v51cD0LW48Fk/5GOGK1/qSqqRZeBFJTTfzh/w0w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706543043; c=relaxed/simple;
	bh=mD+kDuo/fltlv2p3cqxCVgko9OzrbT6hInnmEX9zGsk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=iQHimuRbZpJtojdn1NYYztC829jFaRjoCw0TBr1ZM6sofyW3FBgbFvjsJP++wljaBp1OR/6Cjh1Lyd2gmvRfbDc+F3CjErDZWcPOsGNIl8V6+l8R/qxYsUcqrzENX3PywG+ewZk62GtZp4hRbP0sBNeK8jZ8ZFNGMYBIU/hGA0Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=UVvyj654; arc=fail smtp.client-ip=40.107.94.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="UVvyj654"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A90laNsUE7p56cQZxWYi+CrdWXj7/rSXEvPbPzFIdNKcObA65g2bj/fknndRUx8VPjqdZz3MaJdSjlO1mFiWUbsfiFp63xy7CMqIgZeAw5aPSSa8mL2u2HE9+IzBqw5F79Co6DMkjrgCdnDxtlG0RLapTsx9D2yZEo8sskeH8VTJDoRQiVRFbtP/VZcA9WxW9dif4XQRfYmTwsBt4HUfGbfRMArD2P8mQQ+FmVBC4/6D3vLD/0XCz82v+tQxcBz1EwSO5UsKtB9QhXqkISZnRXFfuKxnSN9cVzzRsi4yaArX+uVmbgBPYB4XcJr1uhiBOgmkFlGQqwZqLkUaIqmPUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pS8XhJUUtgkn+Sx9b4dNYgDeelrmVQpo8VjTFf9EFyY=;
 b=TWXdrWIH1Hf55bBn2c73Rfwj1X+e+8I9pc5dtZrm0o9OyHXzM5mlj+YbxbIGzSgFbhTxnnrEu5APnsNn/nASUgxZkZcO+Q3DESYlL34yynCMnkDfWHNzFICXwp5b+byIUipTzM+LLzbmNpn3wEFwyRZhj7sjMRPE1sAOUSHUHlRh4CwCEL4Vy0nF+LM9MzL3SczFIJhEUBf5qJ5By1k3sMZhJwIFp1aaVwK4udl8zwZT586WC/+cacARiNe4b4alDu2HF1gu7qxBc9DgaQESw39jvWsyHVmWAHKN/lAeWi21khHJ6dQxl9WlWfXA7N4u7rpehNWiSuD8J2Kt/aAvzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pS8XhJUUtgkn+Sx9b4dNYgDeelrmVQpo8VjTFf9EFyY=;
 b=UVvyj654zjHv3ERUM/tYGwtwdo+IDpBLVkeMJjiMfRop7woK6+wvyz0KYOCPB5LwnkNDBPPxZshZSiugRcDI8VrKyFytm2di4HOGVjtUmyevvq+9XHNRv8A9hZq0Xdd6T1V6HnO98lpLsjNnSyx/VPq9Geh+LMeFZMrIyUKOq3oA5T4uGy8Z57Eo+qk4AAqgOYwsmm4bXcavfqsNDIyF1OSSXB1ifojj4xwI5TD/sTZ3fUrDFWt7EvKt01NZB9d1Ji2wgpoIcxJdZEH+QM2eqpNB0N8s/pz/Fm/PcMXgLB8EP+EOvAzLImSi0iiSmtPHRLsyQEcfY8P/6q8AkHJdvA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ2PR12MB8064.namprd12.prod.outlook.com (2603:10b6:a03:4cc::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.34; Mon, 29 Jan
 2024 15:43:58 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7228.029; Mon, 29 Jan 2024
 15:43:58 +0000
Date: Mon, 29 Jan 2024 11:43:56 -0400
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
Subject: Re: [PATCH v4 03/16] iommu/arm-smmu-v3: Move
 arm_smmu_rmr_install_bypass_ste()
Message-ID: <20240129154356.GA2421628@nvidia.com>
References: <0-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>
 <3-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>
 <e1b1a2fbaf3f4312a6d6c27afdfaf7fd@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e1b1a2fbaf3f4312a6d6c27afdfaf7fd@huawei.com>
X-ClientProxiedBy: SN6PR08CA0021.namprd08.prod.outlook.com
 (2603:10b6:805:66::34) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ2PR12MB8064:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f3efb3a-427d-4e34-094e-08dc20e11bc1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	wSv6wc8yQhWtyYLKef+0+BwHXGjq5rg6RZn7lXUKoUnKvieG4XTfPY1tCPld6h/4FtZT70MiNXgFCbWFWqO1L+/lCGHbrkKiI9zWoYZLNC99IKmmesGv5sTKmLH2iyWl2EwhdTdTeBU9vpkmYRSm8xtyrFr1F0rzsu9KwjpmQ9ow/wQl8MHPkjk2PMIqONk2B8JNkqb/WsobfamsC41raX4MzHQ+9p0YIBAAah+UhHFLHs+dtbE6sWukqxSLPLw7sbEfT06fXUQSeSmVBOot5BU2nioD8D3IwF4rdWDf3UtdK4ffA1JylZL7QdzARbCjK7J4lkQ9G6bHTPaEfbE0CSWTF69d+4Tytyv9joP+wgxS5iHUbNqH2ByI1PYK5A7eYwFffxke2CHuZ7/IOPl8MNxMojkKn8n2yWPSBo+QvU7QPt8wezS75NryvMq3KXaAY0yZY2kfGV82q0Cl0UgQ8UaZ00BXtMcpsqI2BpWXx/kpazNyjZJvsHG8sakCXSoeqD6MdZSDhQ+iJIhgWRMwM7a3CIfoqJsbVzgquVnbuOGkQwBR5sPnU8C9fe3Mk1nE
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(39860400002)(346002)(396003)(376002)(230922051799003)(1800799012)(186009)(64100799003)(451199024)(86362001)(316002)(2616005)(83380400001)(6512007)(6506007)(66476007)(66556008)(66946007)(6916009)(54906003)(1076003)(8676002)(38100700002)(4326008)(6486002)(26005)(8936002)(478600001)(2906002)(4744005)(5660300002)(33656002)(41300700001)(7416002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?m7queZKIRKAsn6Ka6HS+WOFemSHbRisbm0dRP7EMv+TH2EraVQPb/zhesKbG?=
 =?us-ascii?Q?S/Od7G8eg+MZZKDBYFIlzEC0LiP0YBfL9c2jRCiT6AntQ7IGTd0weAMCopBt?=
 =?us-ascii?Q?4uQOF13K2GTna+mzT8ASZJu3YDyEleQK5ZbnffeaFSdZ+M3FJA+hT9CNOfwf?=
 =?us-ascii?Q?Nv/EGw8J7B+UOaIVtqBaQbBrog/vOxN2US2rzejJD0dMExhI2c1/KEVZ4lH7?=
 =?us-ascii?Q?+NQexJns+92JC1VceiGWBWoUASwp+RZq4NYPi7G/agnWb+NIubKB7cUkpTAV?=
 =?us-ascii?Q?Y9QxWL4WHJa5i1PDlE+Ug0yS5QAHbyeS2Gw9XPEecOeKAQXPkDEiGfTZoL1H?=
 =?us-ascii?Q?RLxXMYgPN+FujeSagUgIAxBbt+R+ZNfsLvfGGeG5cJehoODvymU/8FDSZ14+?=
 =?us-ascii?Q?JXuUSNwodRDOsvK3oaoI+FGJ4nDtZSOoaSGqFSJqeCjxPXa+uMOuKiqWTEkd?=
 =?us-ascii?Q?Ck0Yl3gJMfslobCHoJVSLV3oEcmADDNP6AHMHRcUlqa8uESahHwCfsValo56?=
 =?us-ascii?Q?YN8Zb6M55k1FOcgMHWOKe+nAnyGgR8d7WHkHm6Qy+oFaK/+0LuRFk1BJTNnu?=
 =?us-ascii?Q?AJwS1/Jg3RhKID6gEq8q4Jq7+8m0QS976QoR3MWnlK21VLT4uQ/z3RknyxV2?=
 =?us-ascii?Q?TuLH3grrBv4iAe/XCmB9caQaUYNaCDPSzfpo9b487WEexlFtCUCyRuxkq2bZ?=
 =?us-ascii?Q?flYijD6MBYE7p7m20a9m8JilKdYO3y+wc3vZKUC8zD9dQmXIeLcKz1vu4yvp?=
 =?us-ascii?Q?/oLz5/Ui6cFuO3CAhw5zgLvjxTAqXopwRreD8h8pCPmmI+sf7BmQ0Acrdw31?=
 =?us-ascii?Q?hIo3CE6IAsEYeeaz4+jnXw0T5YX95hsJL9nDQE+0mqwYySBYnr20cuIH58Qz?=
 =?us-ascii?Q?iuQEUPfQCmWWC9fACFaw//iedEbtpFWciiWXygVIUn8NGlq2JxbL1fwkgmz7?=
 =?us-ascii?Q?qKdDWiyAIzmSor0lG8no2NJjUoUwXb+XDckfPJdlq8BqG3Mk7rVtXwr3ERn6?=
 =?us-ascii?Q?bZK4dbplx+4b6HgQhlTIce9Joj3gVN8Vh79C9beitkib/d/n24jdWyJVXm9G?=
 =?us-ascii?Q?m35CdpI7Xt2bAjNTGONGC+msHge8IpeONBETVLKnFFa0pPedd6jxq1eD1Wta?=
 =?us-ascii?Q?6on5PL12B0c/pfSOdZhPVSqbNBMJ+WD1BsGu46KjbuCNsJ7UjW+3WmtyL0AZ?=
 =?us-ascii?Q?UJFecCO7OmB0aNjEnV1ls8YZT+8G0qd3aBF61AtrZ+dXKGsN2AWo3UaYQVLw?=
 =?us-ascii?Q?p0Snevbm0fxURSCe8LmpL0f5dlezjBaPxU0mejamwWL5zPZHkAIkobfwjEr/?=
 =?us-ascii?Q?eiM27DYcibRxnEJb2uWgcEXyvIzNiRYBSqvACm86seNfkHz1wMgaCsKuIqqS?=
 =?us-ascii?Q?WdYZdHlYh5+7nlT+u1/KiEq1BN/4v7Gr+n0t3eK1WuPKNvs7A+eBWZK50P7J?=
 =?us-ascii?Q?Y5mKdwKOVw25uZ8r7EVHZ6S0u13YzF6fW6OMz8i0ne3hae08bf6+TLsl6Yl3?=
 =?us-ascii?Q?e8Qi0vr0P/cqov5ahac5Cqxk/6Nfy/o9zkb7yt+Ni1ACSMrHBj2UZlNtElAn?=
 =?us-ascii?Q?aza44c0X574mdprasSE=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f3efb3a-427d-4e34-094e-08dc20e11bc1
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2024 15:43:58.6296
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b5UydIpZCJgo/SGfVi6JoEM3z/Q6kgCaYObFfIlUzGWqSWdJfQOKXyTSFS3NN7Ko
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8064

On Mon, Jan 29, 2024 at 03:07:21PM +0000, Shameerali Kolothum Thodi wrote:

> > Logically arm_smmu_init_strtab_linear() is the function that allocates and
> > populates the stream table with the initial value of the STEs. After this
> > function returns the stream table should be fully ready.
> > 
> > arm_smmu_rmr_install_bypass_ste() adjusts the initial stream table to force
> > any SIDs that the FW says have IOMMU_RESV_DIRECT to use bypass. This
> > ensures there is no disruption to the identity mapping during boot.
> > 
> > Put arm_smmu_rmr_install_bypass_ste() into arm_smmu_init_strtab_linear(),
> > it already executes immediately after arm_smmu_init_strtab_linear().
> > 
> > No functional change intended.
> 
> I think this actually changes the behavior and will cause regression as we
> now install rmr  sids only for linear stream table not for SMMUv3 with 
> 2-level stream table supported.

Oh you are right, it should be in arm_smmu_init_strtab()

Thanks!
Jason
