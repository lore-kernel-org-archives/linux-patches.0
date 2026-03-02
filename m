Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012040.outbound.protection.outlook.com [52.101.43.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9654469D;
	Mon,  2 Mar 2026 00:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772412122; cv=fail; b=JwQVxNBI39ksAVaydE7zZINfmQLOmvUQknvuEip11ElyW3TFMsnwxkOxpyLgBrybshBnigqdwOU0r3wLo3sD/Vz332W+xXkB1FSk/Gh0+HkSRKrWpW5F/YgA/5r8VvaVvKWn/O2HizGvza/0WddFvCw9QAK5ec1vOu3aEWPJKXo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772412122; c=relaxed/simple;
	bh=VGp24FSIn5jIw1COXU82mdzcg5vN3afk6DzbgJvB6Nc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=tL25oiJLPSqIRRebqJZdlD0jivPTbRXvjEhJ1OztVT17CMMESirYo9ITq4cbDPa6O2G75YMP2OZCowJqg9eePFaE6bmf0fldSbMmiQrcNCSIldMPSmK2VRdx0UFyD+aXPaJxiWDns9eb0pFDAZBtSeN8xRZBu2u8DvRiNtiL7VQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=tMCay8VY; arc=fail smtp.client-ip=52.101.43.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="tMCay8VY"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UQnJDYfJq82l9DUNqU9lHfJZJT5ARsNsKWB+b5M0mz3QmFJOpL3Zqwhc0uBOZlqX+Ko2qnNtS/japZGNkqnmvDi08w70r4696XkHN1qLLmCnGWgsiE2TgMDP4++BQgFWHejuI8Tn7LTNGdF/NkGSRrMsaYSUdObKQY+vi2+L+5Onj1JzKNTse/AZXm76UbEYRX6KwbCLGKhlikGPTt4f9+ckN9HewoaGUcxPTxo6BkWqHjbQojiSnPkxKo/lm+MXQopg5vCJntr2mVUYaMOFybioKvjDRibBtxsU+SnJTiM/nZEDc1LqteM9s7YZuDtV7IrV4w12bevZtbZ71glNyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b8mr+G+zrI9LK4azegBuvD6dg/PQWijZf3oiLRyGuys=;
 b=yXsXRd6QFjDSZ8d5I2uRa02GDDFrKAyEz18C0MuuxcfUzhBEWTiFLFWM5ZgLF1fNwMdVMTzz6ZElGbzBVtk7PxfkSNWbsCV2iv8Wr50owDm4jJrpM6x5OXoTwoWeo/uGR3ICSyiVrDyRMQGuY8LpMCDiPhYg6/NduzQaXHuQjz1zpqVmqtXehvOe5EoxIdGPLqmmAMFalhl+/LsAPaekYK+tdntPxjdSAu6V0QNAfKLkgS9EVXQ/4YXLdUGsngicbfwPIelT9W+yuzgA0s7FqHDchBzWmzVQ0258r9zOTBNr8nMYLXwhflg7HDTsyISs7OYEFQhLE8TJSiI4f93WYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b8mr+G+zrI9LK4azegBuvD6dg/PQWijZf3oiLRyGuys=;
 b=tMCay8VYz8XkK5EWVFIyv9eZykIj2Jh6UT+FcpBAQdKDztlmxk/0/cv3bMr05SdrjMzdI9mWLazmBJHGu2kkhggYovKbxZpY7cNJy2CC+ERIh/u02lpwtAdpaeaBjcuuB2wptUnHMm62YfhlgrYn/trRoTd8nh52VdUr/LSzEhAI8kEENxEiYTFz6KPxZgqg++AYDkYwOa7rrgK7wpYpq+AeoBL2edVs5Hwnpsvn8gjjXE8PPkX+qAOM4K6i/+1ZoNBHB8KkNkbWbqZiVladtLs9aqrFb7cOWhclaoYEKeoKaf7vAG0PPCkqHnrovb+VmTBNGbuu7gb3NiHG1XADgA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CH0PR12MB8488.namprd12.prod.outlook.com (2603:10b6:610:18d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.20; Mon, 2 Mar
 2026 00:41:54 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9654.014; Mon, 2 Mar 2026
 00:41:54 +0000
Date: Sun, 1 Mar 2026 20:41:53 -0400
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
Message-ID: <20260302004153.GT5933@nvidia.com>
References: <7-v8-d50aeee4481d+55efb-iommu_pt_jgg@nvidia.com>
 <fc4f0354-4e6d-452d-abfb-fe24e53253a2@amd.com>
 <20260117154347.GF1134360@nvidia.com>
 <bc6817bd-4aa5-4033-b89d-88fef637de65@amd.com>
 <20260226150440.GB5933@nvidia.com>
 <c6ac32f2-2531-4bd0-abaf-ff76e9cc864e@amd.com>
 <20260227134805.GJ5933@nvidia.com>
 <8f734d5d-7d18-4b65-a058-32088353e13e@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8f734d5d-7d18-4b65-a058-32088353e13e@amd.com>
X-ClientProxiedBy: MN2PR05CA0047.namprd05.prod.outlook.com
 (2603:10b6:208:236::16) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CH0PR12MB8488:EE_
X-MS-Office365-Filtering-Correlation-Id: 445e8416-dd7f-40ef-a8d5-08de77f48063
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	NKeG9fK2lPb2S/D2XXgMCgb86cKzJ4FHagkpHyZplJRpCesU1ymd4BXPPgFpMsXTWp9wtIrPlOnDKHHHEHd0INAfGdJ+82IhKwPVIU/GQ+VHffMCAcBGHMEKXjqln4vuYADRFwbv+65smChf/4pKDp51q+qNXc0X+MSnlg86v+fm6zay4GYxjFdJcfPUW2kVLny9qNOgq1DdtUR8VulTLj/kYKKMdstGNPh148+0cVGD45Xhiginr84LzOxScXbE/pfltrbyYJeidM4lW35pduFU9W7B9gv8Qqpieo5CDvITo5brM5bGXE55bWnQXJK6xlkBd5e2q8GFS692CnvaK1mnJSSL97yLu+X+2pmejT85NBicEAL2wct6iOBerrSzjwkwTsOez7m8c1f9LqC6lXtxoq2+b4uQrx0P6spcfGHtIPz3+rzg5EoysIsac7PwzkIjWHtjbP0y+ZbAXixs2cH06rT3m8644tgoPn7NeuSkfwFNAtBg4W0ScfW9LyCR5OQJgbrkG2m8qnLy3agZPcnCiifUV5xD94ae70jNWM1m8aHGAOFAR6RLZJ0Sf23iZ+Cno/L3kAN2+6bfQDFl3zeiX9ODFGJvcA71DaZ+gGSiSXgYM5L/rdkTzObfu7d0e44H4XIb/QlAJjdwE/3Qlfs+RdQJTUpkfJg+80fL6t3fxgoFCZ/ItoBj0bmtq5PxQq9Vuty5eley/DINPqiSVAVmNv6bKffUT7jR5U0p24U=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gO+v1f2b3LCaxMZUdnxkn3R69/gj1aXIBdfi+MYYOo4D4L/BJeaudnrIkXgS?=
 =?us-ascii?Q?zgGRvbFCG7TZfphvcVX+roNoDDdUiomLpzNZao2dVQJrwEV3nnLbsiEUpd/I?=
 =?us-ascii?Q?7QLAXKGA4e0FTWlnwfZLmNNRnWfSBFfBqcLIvKy4V+oZy4R9lJamg/PRM23c?=
 =?us-ascii?Q?xsDAvf0I6zZreFMVhxH8Qto62DsB35WyWnvTbJ3+o74r6cyxazixFjWXS6l2?=
 =?us-ascii?Q?Fedvci53FpW+hkFZZnb4OpV97z7YLRjwj5vHtTkUVtQXl9ZA3AdKt5ZuVZIR?=
 =?us-ascii?Q?kOTsuWo5iZbu1R/AfgcJxiB7xnjqdTjhA9/cnfi4ipoTPlvVtmhsuQR+WaeJ?=
 =?us-ascii?Q?6LY15q2wE+EtKUPZW6T0orDjHXTwwL8hQfuC/nM4IMHuOYUU4f49fBF2FI2E?=
 =?us-ascii?Q?PrFXGyEnSj1RmLCcXbm6qfPI4YdsVf9Uu5F8w5NjiaFamg/QteSWH2cYjF6c?=
 =?us-ascii?Q?b5y0eB8NTfxObaeFd17eiDSU+VniBYtS/QqEAIHz2JwOsZBNryahEhD3lfYK?=
 =?us-ascii?Q?iefuctRdIvv/7R8aj2CziE3GpCz+MFxtDEW/6IBzFRzx3SfccgHY9q1sUqEu?=
 =?us-ascii?Q?NVWOQ+wA8pivkkH/YI21DR+Mwllyn28syVYPGwI3Hjir9RTQ5Pq4kba4oPTg?=
 =?us-ascii?Q?UdzyzQ9zfkU6LwoiTqGnQ9v2G+Wv6iKIryUJ0dPwvSkjmC3+iCWu3tQKehuK?=
 =?us-ascii?Q?XZbyQX1HDGRs8uejYWjZyMQk6noF8LvHwaUdT6xMpAZdkUZy5/Ybl+ug/iEh?=
 =?us-ascii?Q?DCmyn7mm6CR5juAovM21i0UTwEOMqXeIiuJmkSOrCeHKN2DHyLlD7aPCtIXM?=
 =?us-ascii?Q?8J1Pq7rDGRD7amO4xn/qLwHdrpQYMngKdlVq47B0hVGIKplQ2dXj2Kd9ZxsT?=
 =?us-ascii?Q?Slv1bPgzZFRpy/IMOLaanEEv/JOKeAHxS1+0m8WdvT0r4J/3Q6IhCcdcXjVM?=
 =?us-ascii?Q?rWU1llWxXHxk4PV4xm5kqz2/nYx6Vw7zYtOr/3Cpii3hSidXy8MLjRzRClLn?=
 =?us-ascii?Q?QishLrkmOkR3yMpFIWbis+yIzfdjIkf/H9IsAEcKw0QSK89S65yGVcY3Nbol?=
 =?us-ascii?Q?zbZas5XG9qe0we2NwMGODhsaOhu6DfKeNwHkmC+dYKi+O7GGXb4vJCaL6PaL?=
 =?us-ascii?Q?O50kgIcRH1NzDz9ev/S9K2H42/QGSdlCPjDseVF+YxSli2JIAtEDa7h5I60M?=
 =?us-ascii?Q?lmyl9W48muE8YOIdTg14lezNEnXVgpMK8YlfLpqKxBXGa05Osh9eTnAoRVr5?=
 =?us-ascii?Q?3cNYRXED+8CkFHU3Cir5KbAULsq/mEOczYnu5vuAIo3+PPnfD3TOFgw/Mkyj?=
 =?us-ascii?Q?IHykTyfx1Oe6q2KR0Qycqg42fh7dhoRYXDOyKht+fYZfT7U6uiC6ckAmEu8W?=
 =?us-ascii?Q?6yxD6p8MLLyJyBRUpBobnMJ9jfDvRBIGCCHnpVDZhqgdEx2HaiSJm5OKGnPU?=
 =?us-ascii?Q?+fdwo75A7TmQ8w1IO9CJ/wQ5ZtF6X1G2MVbX/7DPR5zklssV6AhJcQTWJXAA?=
 =?us-ascii?Q?Cewlrr5BbFXhiBHiJJhvJVfA4qHHSAPCcflJRtf7JpE/OH0cqG7NtLKCZHSy?=
 =?us-ascii?Q?NPnI/RFLiDR/kef3I4YBrenZ15TOGHy02mCMg0YYa4LTpSbmX0U2/3Z/ZIVI?=
 =?us-ascii?Q?mt8eQG6EpNHbvJL+Q6KtRD0VyZqRDEHF+wXUiq5M6m7I0l6kgsr2pE80vezg?=
 =?us-ascii?Q?80bV735DSdwBmJ0quhGv4BD6/kq/yyRPh+cJzhewmlF9JQdp3+NT0VUIZGCY?=
 =?us-ascii?Q?Nv88uE+jOw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 445e8416-dd7f-40ef-a8d5-08de77f48063
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 00:41:54.5413
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CN4V8YM+u8m3gWYJSd0Rzik5nvQtwtGQXnLrJL4BTnp47IQ7+jcNsTpk/uzctnL5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8488

On Mon, Mar 02, 2026 at 11:02:48AM +1100, Alexey Kardashevskiy wrote:
> > Regardless, I think if you go this path you have to stick to 4k IOPTEs
> > and avoid the HW engine. Maybe that is good enough to start.
> 
> This is the current plan.

Okay..

So taking the Intel and arm stuff into account I suggest what we need
here is, in some broad strokes..

1) Guest memfd gives some phys_addr_t list of its underlying physical
2) It is marked up with shared/private splits in some way
3) iommufd has a special area 'synchronized guestmemfd'
4) When guestmemfd changes anything about its mapping it invokes an
   synchronization callback that iommufd will register
5) iommupt provides a new primitive: synchronize IOPTEs with
   phys_addr_t list
   It scans the current IOPTEs and adjusts them to match the
   phys_addr_t list. Splitting,unsplitting,mapping and unmapping as
   required.
6) That primitive as some flag 'private is mapped' or 'private is
   unmapped'
7) iommufd invokes this primivate from the guestmemfd callback

AMD sets the pgsize bitmap to 4k and 'private is mapped'
ARM leaves pgsize bitmap alone and does 'private is mapped' (?)
Intel leaves pgsize bitmap alone and does 'private is unmapped'

Does that work for everyone?

#5 may be a bit tricky to implement, but doable.

Jason
