Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011011.outbound.protection.outlook.com [40.93.194.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76D3336EAA7;
	Fri, 27 Feb 2026 13:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772200094; cv=fail; b=cBjsAgzOb9HbhLD+DGDmSWrpyF/FmQ/L2MFi4RNo+byB8qrDVO9EM/4cw47B7TE5jqJ+NjUa3LGhKpHZlShvaCXIag1ocHrKC2cekPRZ3gigdEeBcK4afxMkPFbcJq+12jJcWjollPwXEN5P6oe04oE96fBEF0m4ID8CHXwCaZ4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772200094; c=relaxed/simple;
	bh=aZpY0DVJlJQPnILC94r98yG9S8dZNzvJzgCU49EGDqE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=tmqZDHe22HFBnzVlrBpM4Verh7hOXCp/pvrVx/ss5HKZHP7TZYhxHbHKhXDLz2rZmBtd+gbXg3+9prZ5u5CgPz6OOvRxzmzIs7AGQSleKjyQ+H2o+1IWleN4gNk487hNAZeNf8OogIikj0siFzcNnX6qXcRS3FiJFA21QxudySI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=JOMlcEzW; arc=fail smtp.client-ip=40.93.194.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="JOMlcEzW"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f9AfKfGNMQ10RTen/SvrcLcSv+ZbbRxxbKR5/D3n4SflnjaTNYg8KYmYRJNjtlL1VEzRjyU0ESwnphg72RM/j6Nm4aumH23xe4sDNJsXoGoSQXtRzZ+QthCdHKdqyhPh2KPT67JJogpfBaqJMHT+iWQ1NWxZyx3onXDkp0Wnm2L58Q3qTm1oyq7WJSITiQCy6xFAzfNW2KHkPY+QAYv6IyUuxBlmZMKXIxLDgD0cDEN36WprAriJemxGPH8qPYVv/uKWwp7gwUfO1PC8R30w/9ef/iLllt639wR03VZAeWH97SjFF3R3s9zdoothK0r18/bxUXtZ0qjzwINHB6v16A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fk+OXJQCHLO4K9H5hRfiRa7MqHe46cXgZlinnCfZMdc=;
 b=aupzz1koVdOcfkrNFPbbfpeIOeCxo7nujSkl7Krew0hjD4mZ/zZf/zp3d9G+q+gI0/g6MZgmea+zFaxT9VS6zrw/dkujmw33PnmER6mwiwkEe9Yas3BRBPie+7Ioka4eonhobEO3H7ZbF0EEfhqBBhM5IbOc0JsgZ6TXHnw1+wyVJrxrSBIZNTXWBElbDHiUYABgNRUihLsCL0RW8DpsnZ3gRSD57tHdxfvrn+JfICir+hpK/xIGKmlFX2nuecIjX2HyEOtFSe/0TKjkfdRQT9qkP5GTiQNdE9tRcCMHjZNE3OeE/IgcdEesIeSCHoBzBBqAsq/7357O5q3MRiUe5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fk+OXJQCHLO4K9H5hRfiRa7MqHe46cXgZlinnCfZMdc=;
 b=JOMlcEzWCKlJDfRoQ3PseBO3EkWIrRWCu3RN/l8BRMFKemuAgD+RrwtOx58IVs7u64uTieyIFAV1CPzQcysdxyg5SnbNC3ciE74R1w+bEcVTw85ce9PP6WQwT3EXY4oTrnYE1zKkspsww39WS0zBOiyMWjcpsLYwmxNwZ3/nC/5XRKNnRptafaWRD4tC3PQek3+xThoulaHM9kPeAaFRj5Vy5jiCwAcyBd7N64FoPnVYXvm1LiXs/ps7R5v0Kpxg7FdJNwPFwyNU+xMDLXOOZZrvb3Cl45QfehuY79Et/1YLMN0BGV3s+6iNFkoIGyajPbXSGckwqjucFdsqoVVqtw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CY8PR12MB7610.namprd12.prod.outlook.com (2603:10b6:930:9a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.16; Fri, 27 Feb
 2026 13:48:06 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9654.014; Fri, 27 Feb 2026
 13:48:06 +0000
Date: Fri, 27 Feb 2026 09:48:05 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alexey Kardashevskiy <aik@amd.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Anup Patel <anup@brainfault.org>,
	Albert Ou <aou@eecs.berkeley.edu>, Jonathan Corbet <corbet@lwn.net>,
	iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	Justin Stitt <justinstitt@google.com>, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-riscv@lists.infradead.org,
	llvm@lists.linux.dev, Bill Wendling <morbo@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>, Shuah Khan <shuah@kernel.org>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	James Gowans <jgowans@amazon.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Michael Roth <michael.roth@amd.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Samiullah Khawaja <skhawaja@google.com>,
	Vasant Hegde <vasant.hegde@amd.com>
Subject: Re: [PATCH v8 07/15] iommupt: Add map_pages op
Message-ID: <20260227134805.GJ5933@nvidia.com>
References: <7-v8-d50aeee4481d+55efb-iommu_pt_jgg@nvidia.com>
 <fc4f0354-4e6d-452d-abfb-fe24e53253a2@amd.com>
 <20260117154347.GF1134360@nvidia.com>
 <bc6817bd-4aa5-4033-b89d-88fef637de65@amd.com>
 <20260226150440.GB5933@nvidia.com>
 <c6ac32f2-2531-4bd0-abaf-ff76e9cc864e@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c6ac32f2-2531-4bd0-abaf-ff76e9cc864e@amd.com>
X-ClientProxiedBy: MN0P223CA0005.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:52b::22) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CY8PR12MB7610:EE_
X-MS-Office365-Filtering-Correlation-Id: 5bf65e5a-b1e3-449a-edd8-08de7606d606
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	VkMuTb/sL8yVWA6g7iByX8T02BsA844qtaoDkazWxYxGqQFjDSNVe+gJTJpnhnKHGe3+BEdYDOpNcr1bX6imVQfEQZrgsqRHlvU12sDxd2lFI4OWGGRwSiEbIHBbd/afOit7NrB3M8JffA0V7+uOLdlpU27MISYm3K/we9vGpslPjp6fF7WoaX9wd+RDc8lmYGZyQ3cn5KrgNzqckheOUQR5rT+8jy10RLBEAMC69RaKOWDX6PpSwCy8RWioVdvEGoFXkmRVamRJjB1GoYURMvWk3HE3pBQLahoyOk46kqSPDY1WzWU7LnR4n+9mdE0g/NpG9mXFU2eE3DcDOkiVtnbDnEn3afRJ3tBXP8TvVpY6v9mY0sZIUGLs9W4HmkctqYhnwF6ymJR42duS4GhewcqJaIzAtAyTVAfVKXfQd/KRD+L21qhQfsw9ZxQGFjUlMFyUU5VtDQjMLkamawJrsXGp9/m2ef33bcX0SLPsFP5AFP5idozLGNPSz5OCgdAKsQhOG8zFZYwE37/CWZNn+vEFJXHUjPU5UqcFdZwXbxDSwDotUdF5o14LY6+3osdeRWpqn8rY/UNvDqJSku1ElFdPY1yxEC1RSrxmcdfQdd2HY85UHkCHJ31wKdMi20oVkB6wmsYFSFvYjHg7rTu0z//0VdrSmA8ySpjbQmbm+zdouE8AQ4bNK4QxXo0fmsXtV3cnb7uigJ4EHaM3jKgyh9i3Jz5w4ag60lEXdX50y7Q=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3t3jB5oxX8vQuyC4DwRSPqCUJiiXpayAmjsTbMkWwX5R40RHsBvDg3J+3zMS?=
 =?us-ascii?Q?hErH9hBH+RxKx2fq/Cop2mHMfB4To+M3kmG0Jc5KO+PCpjXYK/qFzlhPPtoN?=
 =?us-ascii?Q?C1WoShhvvuDXlG8A2y8jeT7ZDJh/IfGY7D/jVnm7kMG7Br+InLGHNdTWuZUH?=
 =?us-ascii?Q?+b5XLTO8e85RpG5CPGHpGnQWTDxa1lJMDKdM+yNm0eabo58gySlJRa1TbqIh?=
 =?us-ascii?Q?LWS9T814y+M25DOIckZmNKdYOY9zX8lHPsiR//gDPTWbgOjX+hX2KK5sPQPk?=
 =?us-ascii?Q?0piG53xWv3/WpFjyQqyMNe/sKavEftVnFJkBUSyFVby1TZOZyJ4Cp6yzguEN?=
 =?us-ascii?Q?thY+dsIKFrAqSR6xVnMntQUeVuU0l2fu6Du+tWtOi1ti3OPbXmOKvQgjguJj?=
 =?us-ascii?Q?Xvt6uplY3xNBfEnx7piEfmcCMcHSw9AateIWCysZunTrRqGHnqNvT8AKyO4L?=
 =?us-ascii?Q?GACvURJytyYlL9vgsNvVu5TAThXKHXpfQicTjteZia9nYmULRFXxrbEDQDAm?=
 =?us-ascii?Q?ooRULYGgY+Mu7JjlUq/AMhtkpLGL1dOgqWdJUO5qpsgTlgNgl8WHhTN8sFvR?=
 =?us-ascii?Q?W0pNsO0Q3yeMY3X4zmSxMyGQrR64Pk4t0+3BDarGBJDz9QI/VfRwKlwCk1sI?=
 =?us-ascii?Q?xYbKiSrEJm9WGxtrHw3z77YliarOzqOQ721LapwkyB1L3Z95CQplrGdb5/7L?=
 =?us-ascii?Q?2KX0AdR/gRZoVmQM9jQ81/eBvH2Moubq4ns8LcL2p+jg0jAgi6heI3WbqSXp?=
 =?us-ascii?Q?I3NJJVeM9h4jmp7UkXql+z561BWyVZhozrd79NDMa4+m/4Gtcuj/66kAJLAi?=
 =?us-ascii?Q?KYEMzRujSuR1oQR6dwCh/l0MhdCzMHU85ilMnZWOsAjW0jx/p6dJvpiIevcs?=
 =?us-ascii?Q?m/ZUJ93yXVb/jCe8hEbGM9kec5pWS3owHw+5AoBCA9FNzEYnSjeEUU2ajpHv?=
 =?us-ascii?Q?MC7Cp9Df6OHj0OToT3HSuv/nwbh77+epqEahIEw22qx3JuM4AS40silufrN9?=
 =?us-ascii?Q?5Dbvsam7qVueTzvaxNLbqcxyQ29byi7hKQ6nH4fndYSuvH7cEwbqqlxKo9x9?=
 =?us-ascii?Q?Eqo4XefHIsh01oD0i1NuqO/Vdl1sAstxK7hoVOxVMHgPbdrlbKKJrOpon6z0?=
 =?us-ascii?Q?5VknczDvilYwZTxZNw4ik2V7RR+yYNANmxMeAO3XGU939BoScnP8SdH4i17w?=
 =?us-ascii?Q?F7sxeJfZ/4i1AeyhDNL0EuwWnvQbRhLkStzehVq93DQnXFduTY2snloMb0Ga?=
 =?us-ascii?Q?RgsjXUu3nfvPSRGI8e6mcgEBzvX0pViVRMpz888AccFxKR+c+5OQAc6mCH6T?=
 =?us-ascii?Q?WwPwDY25FofWwChkBpFFweEUBXWRKi0NoqKmwIkDKZT4AwsFnDHFAp4PE92H?=
 =?us-ascii?Q?nqZifouWIueQEfAZbXv0bEoAEoT9hNDxP1xd1dHOoAZeq+sjoqvEL2N0xfy4?=
 =?us-ascii?Q?xRBJnknqcOMZKhIiQmuLTKREk3HonN2Py7W6q3jTH0agCGyMfK4SvzOt6zwg?=
 =?us-ascii?Q?ZfGH183MgvQPW9v+Q/g9BRqDrcLx8QRG2azMRsqcs+jX+ifq2hhKx/nDm7iX?=
 =?us-ascii?Q?0kfX44Nxlea5yy4Q0qzJ55+S6m1JnSPQCQ1Zpq07Rg76hblMYoAEmCZfWUXa?=
 =?us-ascii?Q?rBSz92b4NR4ushX80oz5dQ+rUZsNdFv0+vGiwaEMwkxwymPQ1+KTNgrKMcs/?=
 =?us-ascii?Q?s4wipwHaHLkqZl8dx3i1Xaki2zoX8b8fFYlcfYRqtue6rp5cIWKrbjE7GWeQ?=
 =?us-ascii?Q?YPnS8XYrgg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bf65e5a-b1e3-449a-edd8-08de7606d606
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2026 13:48:06.8714
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qAYMNnxFUh9uuY4SuTzbpIl548Oc9osOceFD7YpM2MJzk+tfDumHxV2O5xIsLHLs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7610

On Fri, Feb 27, 2026 at 12:39:28PM +1100, Alexey Kardashevskiy wrote:
> 
> 
> On 27/2/26 02:04, Jason Gunthorpe wrote:
> > On Thu, Feb 26, 2026 at 10:11:56AM +1100, Alexey Kardashevskiy wrote:
> > > > The flow would be some thing like..
> > > >    1) Create an IOAS
> > > >    2) Create a HWPT. If there is some known upper bound on RMP/etc page
> > > >       size then limit the HWPT page size to the upper bound
> > > >    3) Map stuff into the ioas
> > > >    4) Build the RMP/etc and map ranges of page granularity
> > > >    5) Call iommufd to adjust the page size within ranges
> > > 
> > > I am about to try this approach now. 5) means splitting bigger pages
> > > to smaller and I remember you working on that hitless IO PDEs
> > > smashing, do you have something to play with? I could not spot
> > > anything on github but do not want to reinvent. Thanks,
> > 
> > I thought this thread had concluded you needed to use the HW engines
> 
> The HW engine has to be used for smashing while DMAing to 2M page
> being smashed. It is not needed when the insecure->trusted switch
> happens and IOMMU now needs to match already configured RMP.

Oh? I'm surprised shared->private is different that private->shared..

Regardless, I think if you go this path you have to stick to 4k IOPTEs
and avoid the HW engine. Maybe that is good enough to start.

> > for this and if so then KVM should maintain the IOMMU S2 where it can
> > synchronize things and access the HW engines?
> 
> I want to explore the idea of using the gmemfd->iommufd notification
> mechanism for smashing too (as these smashes are always the result
> of page state changes and this requires a notification on its own as
> we figured out) and plumb that HW engine to the IOMMU side,
> somewhere in the AMD IOMMU driver. Hard to imagine KVM learning
> about IOMMU.

Equally hard to imagine IOMMU changing the RMP.. Since you explained
the HW engine changes both I don't know what you will do.

Maybe guestmemfd needs to own the RMP updates and it can somehow
invoke the HW engine and co-ordinate all the parts. This sounds very
hard as well, so IDK.

Jason
