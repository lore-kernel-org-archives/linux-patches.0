Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011038.outbound.protection.outlook.com [40.107.208.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF43A22B5AD;
	Tue, 27 Jan 2026 16:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.38
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769531354; cv=fail; b=euYca+xCxH6/iA0MS/BrY33bw6b+ubyksnVaCd9x7gH4fn7WcnznY5pJYFTw8asCscaNTlpBrxYSjA16iXAVYslGL/CpCixghGG0nB7hDNp94jIz7W9H5tRGiz/T7XW72Ar4bpbR7D3o9uggErgDoMn9dNDukqnevPR9/AFLQH0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769531354; c=relaxed/simple;
	bh=CKa/pUal4rYV5rKs+i9YT9gimeaOHgQL5F9LgbJ8+7g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=RKffNHZ4/KkS+QUFd4rOo/yfR1Bov7vXsYgQVGnycKrbNEj3Oxms45Dwx2n0ZZze19+hFGoMrnbYzKvfxayrYn0rC1QxIrDTBIuGDNggy42hOxYn0qwuat5u4k//vYzLMDmwc0p5NZGSkIO1/ef8/52613jsWBhemJI9/fERwwM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=pN/9YJ3F; arc=fail smtp.client-ip=40.107.208.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="pN/9YJ3F"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EVLnvgXah9RxOUcEJGN1PZyJiNgZDqyL6vAkQfuCiyI/bJsdDGFSfXBKV96SD6nHHXe6Zxj4DMc2HScI8a9MM7TOjWhIXKD1SoNKpA193uwgKMwID+bEVHFkLtb5KOKeKLpmhKWPTulByQVJiiLgo1X/Si3gyC8vdU+GGi6djWyVa8Qi45+Ov6jbewQU7QxBz59Vpdzlf0ZM38rkwm8SZQ+jBMU/i84atwS3nq/54RMN5+wTdpqozKsmYvc6Vo2ij06bshJ/70pOiZZyJUMJQC0SmvDzWxqKKMWF9TumN5m15zg/AeWOhHdsLj8s90Ey3cprSD7+N6+m5pWZact2Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GYif95XqJ2fLMNceJJGIvtve9jzZLwOUGYklyUmj1io=;
 b=delRBkjqsb4krmZDERsHgIYthv8GZ6Z6+9dpeBx0mSwPEQc7oK/RpT4dFVrXi/F4MSLVkqRGhIklnh3fpFU4j7EMRJ19E8qYpbEINa9/Xdhb4aiuRq3uuMaAeGy0N1FcRkGP73el/egohUp0XFkRNlCegW2m9WfwTJ25SxvhPJHvmUmvaOlBdRxcA1aWKf9olQ19H0m//Zwk30EL4wR2+GEGkGDnblVAhJZysVBpSns/+LKHD+9xRBqE4mIRj/bcqu8J3GGBv8l1Too88gEtceiBHr4J1G13DnleLeSLm21vbCfZoFuluseEVQqIcZPQbSCsWMZTlwVpL4VWby0z4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GYif95XqJ2fLMNceJJGIvtve9jzZLwOUGYklyUmj1io=;
 b=pN/9YJ3FSMcIJsrGBhyjgLwF01CxiKcLkUTI1scp/phs8Brp3kle+kAo9O9mJsDKXmL/sQeHlMl4mkb/f68s6Nw2OFkP1WntGg1TOxtf9gSPEbo5pQxfEE4zfVvkgrhi/l94U38VfTeomLjeHTZnfACbG1famib7J5q/+xzxy9XGU6cmaFQGdaCbuWieOMiJ8eF44iu/HBUAg0ODF/J98uzrnqYuqFv15cQzTBUEV3NM0uT585QLfMcK+5HgNG9mFO5gXVQA1T5iNuNnbSX4g9DjWAfbc0/F1yPjkPKeDew0peaVj4BO7DZcfbq7VxTta0AcawuOebJhlMRUjShrSw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CH3PR12MB7644.namprd12.prod.outlook.com (2603:10b6:610:14f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Tue, 27 Jan
 2026 16:29:09 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9542.015; Tue, 27 Jan 2026
 16:29:09 +0000
Date: Tue, 27 Jan 2026 12:29:08 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: will@kernel.org, robin.murphy@arm.com, joro@8bytes.org, jpb@kernel.org,
	praan@google.com, miko.lenczewski@arm.com,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v2 04/10] iommu/arm-smmu-v3: Allocate IOTLB cache tag if
 no id to reuse
Message-ID: <20260127162908.GL1134360@nvidia.com>
References: <cover.1769044718.git.nicolinc@nvidia.com>
 <85f3361fa07ca6884500ccc917da6f6b84e13a6c.1769044718.git.nicolinc@nvidia.com>
 <20260126210640.GZ1134360@nvidia.com>
 <aXfpaN4UCYcY9W8T@Asurada-Nvidia>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXfpaN4UCYcY9W8T@Asurada-Nvidia>
X-ClientProxiedBy: BLAPR05CA0015.namprd05.prod.outlook.com
 (2603:10b6:208:36e::15) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CH3PR12MB7644:EE_
X-MS-Office365-Filtering-Correlation-Id: a4c70a66-084a-4f34-47b2-08de5dc13289
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xObE3AJhGXGyPzezQtdSICgo5cw4Ckse5f1Afh/4D1GAtvCBe28nKOGfxH9y?=
 =?us-ascii?Q?DrOjWyA2CQ+1sxBf6a/LtVn7CINJTqgGxfw62peXkUzgxyTDLyJGqciZzJ7B?=
 =?us-ascii?Q?R5fUCd1rJd7ecNXkijj1TZ62O2BsKMbuButcRpKshOrRIHucdRrZCpXSBwYm?=
 =?us-ascii?Q?bZxp9kHH6uG8B1LDkl3gRWhK33gijBgKJB8dRJaAkLLk6mi5sFLtyC7Nzkry?=
 =?us-ascii?Q?16PT8Lb5il/8fj1mnIicJ4Crfzad2Izsq9M6UOWW822Ux9radN04r0VSiz83?=
 =?us-ascii?Q?bXSmcBznZMuhlJ26l4AVwbOrwH0dDwdXdeVkjc6REZjLQhRi0Hm3Q9dhZOJB?=
 =?us-ascii?Q?r/h+2jk/xPtFHRTxNhqmoysAr63xAY2xT4+S5xy7A8UWkVNPxJG4ftJogTi7?=
 =?us-ascii?Q?VDJ3gUlBjHGFhVi480MMtSTIk6ZmqoGK2LMSOxep6RvIHrki2dxAvSWLO2gq?=
 =?us-ascii?Q?JeGurDtuZtZ1cwetdHz2mOOJg5PifprhsEKgfcdWBVqMul7OZ9cNUbrS9k5+?=
 =?us-ascii?Q?iW9r/IMtfuFsRQfDu4+PXrECUnBFgMMN9zl4w4gXZyIHpU43/KlRAS2UFyBd?=
 =?us-ascii?Q?QWQ/ew7O9YqdIfYMIZAofsXvSTuuqdh0zUtQ7zoYptGNqjtBhWNczHZ8KJKk?=
 =?us-ascii?Q?Tps1WxzzPGYKTkDIhR6f02m+sa/2Q0q8Jn22jT1+2YKVIVGwN5PuTYcS6hvW?=
 =?us-ascii?Q?D22r+zzgqzAH6TGkTU8cI8xHIU3534nZj6BIccyc9UVasSrDGgDBwwGmISUe?=
 =?us-ascii?Q?PGyC2iThKWCNrWOnw4lEp34ArlIdW/5L8NSM49NkWO2BJPy8AlBfu6cAVU3S?=
 =?us-ascii?Q?EI+E+Fn1h5jbC51IttslQeuDV3bN9JoLZLu2b1sOuoZd8lTFyO6WpQZMFHAd?=
 =?us-ascii?Q?WL+0PP1jV3MwJIqctTKtCaR3pr2Hq+eIaQF4zbpcmXUV4B2EC1vIcp59EPVv?=
 =?us-ascii?Q?RpDUxSdu3wUSQCzWN32q0udjBQ9Xjwc2G2yifTDssmWigwZ3YrAufj1Su+Ky?=
 =?us-ascii?Q?BeROsffcUND9OkS91jPNHX33Jd2mWEgdP+aMIJOGqmIoyTtE7lQ0D/JYi+hY?=
 =?us-ascii?Q?kJKqwc3AMUE2dwLZ/5gtDSKSMMuRfHGBGMRCUsLSZrBlv522vSFkE76hRuLv?=
 =?us-ascii?Q?uxVG6ShBICwNoDm7ClBJLQpNSam7tNUSwt3rI/lS3ILQCdkB/dHNKFHqcrNg?=
 =?us-ascii?Q?4IAAglk4YuysTSqdNloZ6tsCBUUURSFfIVVhRWO/RQGNr18l832lZdBJXnD4?=
 =?us-ascii?Q?IQqc2+2R0Bh3BCC+G2mB+U3/j5f3ZLOB36SXl2H3rZipIyjwv3PF26YERkIu?=
 =?us-ascii?Q?9W33iMRh51qSXA75bOhTIRjx7B+D1noe8QC6ciJp4JKDhJTMkqfHV4r6giZI?=
 =?us-ascii?Q?t1PgFJhqyKfC+Y4GJa2vdW9tR+vPJ8Zo5WJYHEOl4Gw7NIjUxLe5Bdskq+oD?=
 =?us-ascii?Q?s1hwEh8nXmxrMGMrFRdWCoSUrQDjkth+CfSUhq7ocfE8hdqW6Cekr02sfzfY?=
 =?us-ascii?Q?a0YuAdW6xviB9rlvzBuzLq5o6UXKkNaq4V3DLP1S9sJwxUIT9XAd9TfdB8rQ?=
 =?us-ascii?Q?ncUwLPm6ngcdOyjVqHU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?upPUGDv8V/iXvbVabwCx7PA8f7AqTPDBX6UupUUGXR0X/cdoWQLgjvyPWUSa?=
 =?us-ascii?Q?rQ29Bs9/1Ma/k77mz/92Olupc6xebGZWz9JxtFkagOG+6k+cQTnfyCK7D64L?=
 =?us-ascii?Q?YYK03gCs9fqizxM6aFR89UFlNGQaVYLE7VZi6cgfv0ot72ZYsu5iXEc6A4U8?=
 =?us-ascii?Q?Uo5CQnXIqqv3B1xANxyr/p8V83Jm1kkzPg9/lSMVa6Ns/oYTKjj0qYYnUXMd?=
 =?us-ascii?Q?HqNFf5RijOa+oxMgz28LzGAw8MYttOpCcqqBO/9fwwh54qO2ygDVYj7QTzQB?=
 =?us-ascii?Q?9NdqvE6fUpl2WbaWXwbSF/5niKV6DTcVisX07vEODInQ5uyZSG1FFPl9B65f?=
 =?us-ascii?Q?8PeNsg1kg2GVKIeYTbJRrHtOVVxcj0t+BraCpNL4mvsVZ/pdcRdkZZ2hwa8X?=
 =?us-ascii?Q?qaeCFzEieqE0N/EEvwxg9FErfPsNhW4nO6nIB71DL9HmpUNyX/K199Qvhtic?=
 =?us-ascii?Q?bt3nkbYaKYq4a6hhBsjW1tlKBl8LQqGInkgsS3Sy0GYP783mx5O4eC6ajHHj?=
 =?us-ascii?Q?+281OCiPQjHm+4qeTZ5E9ImIBVavcmnQxoKhcN+RfItHZy3Hm1KSxIQ8XuVx?=
 =?us-ascii?Q?8DSsUr6FBBrjhzz3DjKTnBH/DhBi5dmtOpxuJvldtHudWfScSiKj+wItBjsC?=
 =?us-ascii?Q?OSF/fwitKiVf+T3/7wrJ9uNvadg6TkecRAZHIZmU/u7vMH2QTx2hPGfadHMx?=
 =?us-ascii?Q?9PGS7tb1pxWc1vN8rm25vCvDeOj8NGyNY2+pJrU5YqWEkvZxt48corN0MFbr?=
 =?us-ascii?Q?yU4YWvrtnB9ZgMDk2n1iTLMWSz5zjjZOlkivitO2I41luVSaEoYIlEkgaism?=
 =?us-ascii?Q?tMAJj3RFKncA/y8v+g+3fmYv+lCuAzaxw0qLt2iSidDHD2YBh3nCpMNyLfrL?=
 =?us-ascii?Q?HbxbDGt0DhUsQEXHVv6inIhsIKrfBCAzJuZwDgmDAkSSUOAR2asCSXKa3oLy?=
 =?us-ascii?Q?YUx3MM/v4ZK+g2/Eslt+iF2tyoix+AeYtepTDj3L65aKgrJ8r9mrNdknFxE5?=
 =?us-ascii?Q?xwRexdbx+TuIfSzd4f7Q+NeLLr8uU6d1wcwHsdVQQu/MDNE5XSFL/S9EvksG?=
 =?us-ascii?Q?mS3PIhOmUaqqkT4n1F4dWtyfQWnuoIblRJQOjMDjijj66+r7ykXL4v/GAZ0T?=
 =?us-ascii?Q?6Of4VY6aqnOu5RCPFp3NTjlsj5E9da/ifDJcQNai6NsC/4KHowCL5sCus5rS?=
 =?us-ascii?Q?JLG5Qj1EhYnY9vij3W5Vmp/d7DOGU9iNvgenA3mos9IOm3k5lPMHE8sggJcx?=
 =?us-ascii?Q?uF1FLWWt4LYDJ3kBAsD2DQmVNNXKyj6zE3XrGM5c2d7nrzl4W0Bzn/AkZ7/R?=
 =?us-ascii?Q?TOeLHa/eBpH0bqD8l/bVtsGlmaGcipWRRnpkeXqrePFbsZ+HktD+bI7Y4Wca?=
 =?us-ascii?Q?yG51iat4mwPuGiF8eaq0fKz4g4zpzglJJWgkPmneJwDYtkH3nDKJ19cVJodX?=
 =?us-ascii?Q?Ou05Nz3qhPP3giQp+OyMS/2Umn1jID1jsjy/3e10RWFKD027FFvH8U8Asjfl?=
 =?us-ascii?Q?jhbZqWehzCsgSnz0S6wf0jqxAv6TMwnx3U/mC4z+UbG1ynxwPmcKge6KNja+?=
 =?us-ascii?Q?+U6EsOaPf96qHGkFbEoOklXCH/DqcyZAjQURh33PVUM8gMpNKe5h5ob3mGsM?=
 =?us-ascii?Q?Ywm33oDvDofyar94ZZn7kEhWTN2owIkModdkrpmCJVxfYOSJIGmHyZLRCOBu?=
 =?us-ascii?Q?xJtyXeuEdhJ25QbbyZXUzDHciibOi4mW6gYPEzjd6zWBoeAbFPlSk/UCWu0I?=
 =?us-ascii?Q?eWkd4eAKZA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4c70a66-084a-4f34-47b2-08de5dc13289
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2026 16:29:09.3419
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LKSNmbNahW7XS54JiZpLEdn2nHTnlY+Jdwa2GPOW8hqezP2NzZKxGMx30eAgbDd1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7644

On Mon, Jan 26, 2026 at 02:23:36PM -0800, Nicolin Chen wrote:
> On Mon, Jan 26, 2026 at 05:06:40PM -0400, Jason Gunthorpe wrote:
> > On Wed, Jan 21, 2026 at 05:24:22PM -0800, Nicolin Chen wrote:
> > > @@ -3220,6 +3241,9 @@ arm_smmu_master_build_inv(struct arm_smmu_master *master,
> > >  		break;
> > >  	}
> > >  
> > > +	/* Set a default users counter */
> > > +	refcount_set(&cur->users, 1);
> > 
> > I think abusing users here is a little too hard to read..
> > 
> > Can we just keep track in the state somehow with a flag?
> >
> > Or maybe union in a "bool needs_free" that is for the on-stack version
> > of this structure?
> 
> This doesn't only apply to the case when a tag is newly allocated
> during the attach, but it can be used when an old tag has users=0
> during a detach, right?

Oh, IDK, I didn't look so closely..

I though this was just about cleaning up the tag during attach, the
detach flow worked differently and did use users = 0?

Jason
