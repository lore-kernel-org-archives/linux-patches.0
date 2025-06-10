Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2058.outbound.protection.outlook.com [40.107.100.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 056DF1E835D;
	Tue, 10 Jun 2025 23:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749599492; cv=fail; b=hEcd+pF/6dT292VLQP0hTwD/pbVW09e1Oyx6JqPhlUZFwihhjsIzCDJOlW/c8d2Tc4zyjTth9vXazeppsxXJCJFNsvvGONmOO8TXvX2Enaga7tFH7IQMwFTsVpBsv8yrMN2M2dX7sG4OU+EmycT2/QXH1UZpNACRw/ra4nV9duk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749599492; c=relaxed/simple;
	bh=dlaKyr6TUVIn4s4lYWc+U/X3aopWy22X/XzcoVioFaw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=c668gIrK276kCxx7/Ns+aAsW5nkS8+qc9HRy1Hk5XEMQqELT4OUF1511bIDtaB7UhLk5Q5e1qaXZU2EY17+8MBcFACfacbVduck8O0QyUkReKx6DVNToJkna9ktR7Kbhou9qO9s1mWW8M7f9dFCAdxM5GdyhNmaYxGGVg07kFM4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=PzF5WmBL; arc=fail smtp.client-ip=40.107.100.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="PzF5WmBL"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=azFhgF1TEYa6bGdIMFX7MIG1BNMgeouwjrk2BicHRgotEEr67bXvqfwlw2jjkCWSQphpLEW/iklGQSB9tMeMjEcCr+hZ/mTX2/bTeWCOvmw0Dfz6DxSriipr+t0YtVTMfKuf71IxD0fGonrtTEuvZRRc+975S6eZTJxfPBTA/+LkEYSTz1c5nrg79E6H8+38RqjHkHX92ktyrSsTHxD/YHuQB6O0MEyNMt5az06wgPFurPNAAKxEH+89CS1Rx/Uh3ppIx9xBzfS9ErPKg82iGqobqQSVwANZNPUxrJq+SKrWQL6gN5TQVZSy9JDtdHUTFmpV893Tzq9/ad6KxWLRvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TpplYe1m6AgHRY22MewZRitw/XEJbr6SoMKIqmkXoyg=;
 b=l1bE7FP+cGlnmR/9oSz6JpwG/ZjSLYpTHZTj28/QOelHlN5d+bsA/83m0UoB4oaXn5d6ovLcKfXR6HCc6lJSmJ6EQAypmGGDawxAzUZyJgZ1iPGZeWeVngVmMPVjCyCvoYMArrrLf8CiggFJd2bhfLghBPJ49CMiOxPGxkPzldmJ7EJvxNXUeuoLdsl+ooPcpygRwNwsrt3bjZrHA84p+q3refEls/FBIrLZWmCeWa+QHqM+cd9xaz3c273RL1riYB8vaj0N0az9yjL2KCGQaqFbZntg2B5AUoRbuQbJJNbqkxTwnWT7mzgTw7UGofYRgwGPUUB5e46LKzZ0tSvYuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TpplYe1m6AgHRY22MewZRitw/XEJbr6SoMKIqmkXoyg=;
 b=PzF5WmBL9NHqO71ffsyK4LKcvJKR41TgDPk5r10dijFiLWJApOA7mPPiIZTYq2TmXowGKNKgPwVGrvtiGBQa4xH2IO51gzEXvT7ZWxxP8lYdd/67W1qQV6MURvex5HL9uu9XwCX5gLpNW/pn3S/6Cdd1vLq+y/VGM6J0JhKm+2/BK9eeZnNmY8l1FhQ4lFUpBARGz5SQpOBOeAjggzFyLi2/++fLhWbgztEajqp1DQhGFeRUoX4w19XyXuOxQUfJzkamDmUescVDGYA0fvvxPXQfak0+/B/t9K10oqqQi+7hjP95/VDYMf0ZxQAj6zu1t4O2t5J0d756KyExJINMkA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by PH7PR12MB6907.namprd12.prod.outlook.com (2603:10b6:510:1b9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.36; Tue, 10 Jun
 2025 23:51:27 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8792.038; Tue, 10 Jun 2025
 23:51:27 +0000
Date: Tue, 10 Jun 2025 20:51:25 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Baolu Lu <baolu.lu@linux.intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, patches@lists.linux.dev,
	Wei Wang <wei.w.wang@intel.com>
Subject: Re: [PATCH 7/7] iommu/vtd: Split paging_domain_compatible()
Message-ID: <20250610235125.GP543171@nvidia.com>
References: <7-v1-20c73f153f4c+1895-vtd_prep_jgg@nvidia.com>
 <39400661-9f18-4ba3-8cb8-d56ef548c9b0@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <39400661-9f18-4ba3-8cb8-d56ef548c9b0@linux.intel.com>
X-ClientProxiedBy: MN0PR04CA0023.namprd04.prod.outlook.com
 (2603:10b6:208:52d::28) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|PH7PR12MB6907:EE_
X-MS-Office365-Filtering-Correlation-Id: 21c712ce-d092-4246-1042-08dda879b666
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?EpuXaI3Qw2727pfhLScFwjSnl1LvuSdrHnsdipsfKt8si5TUTiVjm+jMmfGc?=
 =?us-ascii?Q?3OWYXR2WvSvEu+Nlitjz6ZaHerhMzqMwk66WCVgR3xzvhGp0hFR7/XZp/ai7?=
 =?us-ascii?Q?avieJBltXpS4AHsD/L9x7mBWVUAh5AXmKNuGmdMJPESULAIgsbib2/XlFqmF?=
 =?us-ascii?Q?9UjXHB5HiSks5FBBRHW5IKj0bsYadeXKlN/c76wWdFV8jpaf2Dv0lRYybO84?=
 =?us-ascii?Q?Y3VFT8qH0onF0+KX/SsatxJ2+2oztA3UoRZ16z6Cv+78m+jkJ0Xm3/hkgt6B?=
 =?us-ascii?Q?U4/E8s0Iw9YgmKoG0naho+S3IX+bECco/h+370GIxT8kRJKF6lMQwAPaRE3x?=
 =?us-ascii?Q?ZGI96FiNmdCDa9q1WznJ0vAoBofIAfZKGuXqlMxaS6gBldM7XbBj/FKFeYhW?=
 =?us-ascii?Q?vCRjKejfKdkVfMlC1rB3R6dqtw1HSONy9ZxLARHT1dvIQCmxcHBfKiyHz/UI?=
 =?us-ascii?Q?pTEz7EqtPGK0YxociheTgTs5hKzjvz3a1dbloKX9VYrRay2MXxZfck4+aPl9?=
 =?us-ascii?Q?qN53gmdyf+87TPdjjdvRb2P5HZCprpQOmsTkSNqABlsnobnEqHe3dEW40mpB?=
 =?us-ascii?Q?DH4fJuXDqrZuclMnwSKetNgeOIER3Gr9tuLtJIxO6tcOLO5mqvFtfXAp3eUN?=
 =?us-ascii?Q?eDXIHcWAbv24FyPySgmPG87jZTfsElYMNoqOuP7ui+tanIfZq9pZPHGblbui?=
 =?us-ascii?Q?v0gFyEZVi7Ou4GZfRfkHqszyAUr69/XQw2ZZfg9/7FoeMhnSbK7uwmw1JclC?=
 =?us-ascii?Q?++/lA2gHuJZF3SmBOxQeuWJlRdhmVC23mHJx53kDbugi3rBhkssKl1m+2dsU?=
 =?us-ascii?Q?ZL3a8VAoCuK06yVxEVNfNfRCtGzIEDegNGvaR5CnzNKyRzLdwDBt42fWbjTc?=
 =?us-ascii?Q?nVavsBQS/byFB39Q8uSvMjOh4q7kdLH1g30xlcLqn/0GpD/9rak2NptthPCe?=
 =?us-ascii?Q?WJtN5vVm73TV8WJWKQtXyWjHhbwMafNQPyXpL/Y7IKokJG7tZWtFIJG3FvZE?=
 =?us-ascii?Q?/QkNl2wCElDavaKs2Gm62dwUcTTLXzxwGdisnA7RE8lW28VB1AamhA8Kgzbf?=
 =?us-ascii?Q?eZeGHTWfyrukuB3iQNDtaUXW8I3NIyLfqKlLHDupMJc8loD069NG97HvWI2H?=
 =?us-ascii?Q?D7567LPBt5Sm2UaY+It4g5UzCZcY7n/bSBqvsMZdSxiGpswU1cc8FDrb0KwE?=
 =?us-ascii?Q?nLsVQo2dzpAAujOoJo76VJDKPKad6ri2L9v1DI1GIWElbpta5apfqUqYWWMR?=
 =?us-ascii?Q?4SEAycD87szPm28plIkXXD7kpssX+A6n7cXwL0FWBnLS4egVTnkbE67fCoVB?=
 =?us-ascii?Q?wuyXx436fV8GpmNOKECG4TEKv+irw6VoTrIegKQVblZqFdt+4moky651fVl+?=
 =?us-ascii?Q?HInioID7L3t4D/pVTxMWLR4Lb8iGxkdo+KFcsa8FLFT8DIEPgknmrKUx6SZm?=
 =?us-ascii?Q?i/HuGu/dc7Q=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GInMo6CKZboRCuVfR9zfd1wKzW0YzbhC95KMz4EZSVObmiPLvlgMsvgspoTm?=
 =?us-ascii?Q?aFSQT9MJasSDNI10XijE24tFhtM3P85r5WMUhd0OBI70WJewAHSdh3ChQ7U9?=
 =?us-ascii?Q?zi7xq11juKN21J9cc1k52l683vK3sQVk70ba39ueP1+T0lztnVpvvtYNL+Bc?=
 =?us-ascii?Q?lEDnLOsuRrKOWsyVUv4gcQy1yQyryaBEg+YIOu5RLmNJlOfCPX0PjmNl2i6v?=
 =?us-ascii?Q?Iv+ZsG//cxNuzDUt5uEuF8z7KlPTRNhaYAcwacOIAqJWh127Ki9buFb33r8C?=
 =?us-ascii?Q?VYFjEhPtblMHA6fmPhqpYDjtMJCEQX7C8GdOZV7NkEc0y+xDksk8Lv8hl0Ru?=
 =?us-ascii?Q?Owv+jgsSqqJjRDX/6QBFkLaj+YsBg557+XkrLFTByQx5Ph1NXGXX3J9frT0d?=
 =?us-ascii?Q?6ZcTjsE5TCYXer3Z/wpx/EF7+7vmrwjZDOe7pDRWERPvu9gv1hM7ONTIEk8Z?=
 =?us-ascii?Q?x44XHrzGNYOwLWuqjHO7gJ4F3tYGnqdlRsJYFX1STJEc4kG6I2GbDjb4vaOY?=
 =?us-ascii?Q?30OFze2MVH+x7zG5rea2fA781D/snEksiXAxNG7oe+lVJiVgwGce4DONSTbg?=
 =?us-ascii?Q?gXcl9hSXWf3gFAakTK+1tzZrmEYB54g9VuMHDmL2ogBoAWztJgglz2+TNsQO?=
 =?us-ascii?Q?iWr8QklGtAUd0t7S31mg2R3+sTwhWy64nilSAcIxn9gnCxxORieV+ibTJzz5?=
 =?us-ascii?Q?TuTm9TEWhDrcoa1Ym4iV08lMuC6Uqk5Q6OO2mEHWiQ2Sc9+t7+JtOhtVCn4l?=
 =?us-ascii?Q?2qYbbw+UPxRdx+zOf6V+P7naappsCs94caUvhtIoJ694Zz3vTFXmwBnKwa8g?=
 =?us-ascii?Q?HCNaC7mPpmIzTpJrXLrhrSh+yswUpGpfElJrbxtUqZ/2cjvz8a0R15nxIRSa?=
 =?us-ascii?Q?sjleOXuSWxZ1XVolglREjCRWh6xwBVNdXHKcen0WEv23zoYhYpXLx3uhsDPh?=
 =?us-ascii?Q?tIzH/rliKnjenzCPal4xFDVo5DlicSnXCTea6hUqvp0Qiyklrrl4V4uqM8ai?=
 =?us-ascii?Q?YQApw9tI4kbmKdD10rwwecidkxzpdziAUValxlKudP7jlodDpc8pL0+p2IPC?=
 =?us-ascii?Q?lG76+/MVH3XS1kK2IIsDmd/NoAYMBRjcFfBGoFctHaBIy+TDAc3ZKYhCZJyW?=
 =?us-ascii?Q?EOU0Xj/ilrNOPVE9IiKX45FkaeVRohqtzldvbj9d0Kd8CM3/TWOqLJ9jVF1Z?=
 =?us-ascii?Q?1RMFuutGVl916wiqDWFmM7/Hk//nCkZvM2Yt1D8sK5axS0dZYACb43VSEwAO?=
 =?us-ascii?Q?a9GJAqJMhpOu6OwX54IDBUZyvV+pgtWtHAgZe/n251HZHYfk40pPJMNVyEje?=
 =?us-ascii?Q?M0r0PK8DmPCz6TAwd5Hx7pm8xrHguPTq5W+ChykpE0BUCIFtbHTqm0IGm9Yg?=
 =?us-ascii?Q?BdXDU9a3OLU5Yl8yI7DB45hODkPVMvB82nEt81GL03pFDwa0iQje4+aTFUvV?=
 =?us-ascii?Q?yYs5bSHjwHYUnLJ8+JoZdVgTk2rLvoUSvh/bOOHF+jIy1Sn8+wEGhtkL+GrN?=
 =?us-ascii?Q?1txpbXxTgcvkPRSL8fCW3mph3RkELq2PqIx9pNCSb1CzWgAEOEV2RQVFak2/?=
 =?us-ascii?Q?BiJh5U2P2Dsoq9LDFsXvntorCM/nu3b88pW6X6Tm?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21c712ce-d092-4246-1042-08dda879b666
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2025 23:51:26.2247
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6ISGOk7srmAlW6f8+RJUpTzdLtAnoYt3lLJH3IYn4HxE5S2118tfCms6vNYKxmGv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6907

On Tue, Jun 10, 2025 at 03:12:43PM +0800, Baolu Lu wrote:
> > +	/*
> > +	 * FIXME this is locked wrong, it needs to be under the
> > +	 * dmar_domain->lock
> > +	 */
> >   	if (dmar_domain->force_snooping && !ecap_sc_support(iommu->ecap))
> >   		return -EINVAL;
> 
> Perhaps we can use group->mutex to fix this in the future?

It is part of the iommu_domain, there is no clear group->mutex that
is affiliated with a domain, there can be multiple devices attached..

Maybe we should change the enforce coherency away from a function op
and into a domain creation flag. Then it won't change at run time,
fixing this race, and we don't have the issue of possibly having PTEs
with the wrong bit already mapped into the domain.

When this was first done that was harder, but now I think we have
enough infrastructure to do it easily..

Jason
