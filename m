Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2062.outbound.protection.outlook.com [40.107.92.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69F81DF980;
	Fri, 22 Nov 2024 19:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732302026; cv=fail; b=nH+HAOXFM+iu9NSAq9sINiqbL/Phw0zuG4ns4KTwE3200hl7Mx/aX58uK9VwfqOYHSttoWaO9dAlqMryYiwp2WWCUXyN64CEsgOSBUttSQLamXzmg3GmyU3kwQD1MoYiwzc2R1XMlU7uGkamtltFZUYtH9ibMbpz9CNSHRsBhT4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732302026; c=relaxed/simple;
	bh=fDg5D3E1DQ1DNObTzXJrXlzvmoiQbsBA4eFZsqkJzlA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=hStIWoUl84sWsArf/DRVZXrK8h1Zxx5uEHoLZjzuWmb6w7eD3nnz+JetDIsvng0V/N2nWw88LbJFZ9gMZ+rNaEjoirOU00c1vAT2YWkrBM/meaMgU9yQvH3qnVm7VZZSQozqmHcPMyqLLQhNuimdl/J+rBAjslfH4tSISqjRQns=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=PgkK4EuF; arc=fail smtp.client-ip=40.107.92.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="PgkK4EuF"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xfVpj3EKMMkHH55PGITSBhENOtiegHcZxrLU1Xvqi+9uDch/aJ5D/jqBUctP9hhcUvl6ysHlYnXXG6gTE8CebZB+Me2F0NUVPuQu66qJ6Vp8O+cc/pyhRVciRFct4r+55JX6U3DBKROYYtT0MmPdBAPuKzu6t72e7CdERoeMxEYinbuTxfGuyGk+btgEsEZ+KEL4s2+lUQbsdqkPCvLpeLh4gs7hWkPZnIkqlbth5n/ZhQK0LoIcWJZi2KPW5LPFf9VDUagXyR67/t+xM+cR2agbwrkBxnrrXi/a6nls6b7K6XGEu/5l5uJS6G7/JrkBt6e6wDZyq4C9qIt0wZeDew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QEXwGDe3hCzpUTskN8ts0ay97I/rYFXnZTinYWtEMAw=;
 b=ucW6c6AH2yr49VBCG+pnF91U11GA7FB6CtLUzaooEjpMNShDri+g5MPYOauInLhGH8r9nCpd+W38gNmdJOiJLt8f1X18N3gq1SG8bqp5L7H5xjuu2gjVRy4xsC6ZtGzOmipFXZnX2zaoKyXJaMjOAYdRVwV8yPmyiBxXNXTykEL4hN58mz8JSzsW2FVpjIhGL/BLHEQAIWjF1l1eq3Jf9828kI7b7X/MeKqDk++tnevzcxL3IBxenjsTz2hTHVyDAjhl7oBYhJ2XoNIfHigL3FfnySWISGMgqk4Lgwrrjam6W8qp2FbUX600PZ57tWTb/bVjigy4aPstc30ICUx6oA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QEXwGDe3hCzpUTskN8ts0ay97I/rYFXnZTinYWtEMAw=;
 b=PgkK4EuFaWG9TW22qm09u5DzXvRZ9iGRgtNrIUWPNY+Cgt/+2y73STulWmx73RvvX1Mb7T3DLmRAMcnhMATEEnW4Z3napM4WQPUCCPAs7krlVnzrMFtc5fNnXmIBulqcnc6zLE+0jjsl3o1Pc5x7B7Mm9Yoq5sEajY+OaxNYPZAu+nmtXbiSYNp3TrFu0/aTVBXhieT+dfQqca0KNiKx4M4KTEHQ24XLGIf1E+Z9PuLGsnZ6qKdBbIS43D+3ykh/SDWeHUWx4owGxJAgdhiSROkCswpu4pqQa2X2cAsH/HNnJdmNJ52dle2hEHe9o4pavwMC/+GmIMMqczcLUEa00g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CH3PR12MB8877.namprd12.prod.outlook.com (2603:10b6:610:170::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.14; Fri, 22 Nov
 2024 19:00:20 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8158.019; Fri, 22 Nov 2024
 19:00:20 +0000
Date: Fri, 22 Nov 2024 15:00:19 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, Kevin Tian <kevin.tian@intel.com>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>
Cc: patches@lists.linux.dev
Subject: Re: [PATCH 0/2] Rename ops->domain_alloc_user() to
 domain_alloc_paging_flags()
Message-ID: <20241122190019.GA1104537@nvidia.com>
References: <0-v1-c252ebdeb57b+329-iommu_paging_flags_jgg@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v1-c252ebdeb57b+329-iommu_paging_flags_jgg@nvidia.com>
X-ClientProxiedBy: BN9PR03CA0119.namprd03.prod.outlook.com
 (2603:10b6:408:fd::34) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CH3PR12MB8877:EE_
X-MS-Office365-Filtering-Correlation-Id: 6bb65abe-ba88-4973-4d81-08dd0b27e953
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?CgA9aXbvU/MUIf9FcAGVA3h8BPosVaLy8hOwCSdwWlSQx3s2qoGmeYXlwUs5?=
 =?us-ascii?Q?VPXIitaOquD1j7QTXelgqO0IFsdiyxIstPnbGHY+4JFV/dEbPTohpbm1bm6n?=
 =?us-ascii?Q?Yr8FEpmvUcMQ+mr3kgmLf41jt5CNDdcfF9K/WdSDOSd/FhCsre6my12aObh+?=
 =?us-ascii?Q?LTbIwCh1VpHmOCOIaRfS+fLYg74FJkacAgkjCdj6JXwPE/HdSp4s0QdjzRPI?=
 =?us-ascii?Q?Q/rdEdFQm2dNbgRWYjI2G4pAGp5w9dzqaXuYEanofA9J507FQxlidRTK/pMG?=
 =?us-ascii?Q?/8erC4MxEtdZ31+lwhGVWpe2hd433uRp58fZde4lf2Hm9H62IhFqLOZKth89?=
 =?us-ascii?Q?ULDEIuTYHga3KzKjINrg525xJhAv903r40fAppyoKq7mjHUMggIlYok8q5N6?=
 =?us-ascii?Q?Fu7JIBhP8zDIOXHzaCbVjgev6lCdjZHlBow0idC6hGxejMOubb+mLTgSh+mW?=
 =?us-ascii?Q?7F7J7mIMq+b0URLjKPUCIxVwiXRl1igz1pdLqLAZK+OLIUfDI+1fcK30T9IL?=
 =?us-ascii?Q?CUUhtwo21u5fg+EgkzXLuQPEL5GaqNNwm8Z7ONE7D1ip3JzZ1M4e3r6OuMzq?=
 =?us-ascii?Q?hbyCDHubd8ddmi4FIw4PoHi2l31iO9VFDuhTYThWOgYQa4Rgv8IXPk69HZne?=
 =?us-ascii?Q?ArkLDTX3T+w1HwyiD7ktMYw64FZ1daQ/Msi6dU2N+ZqVDNDXnNtDiOd8jf43?=
 =?us-ascii?Q?Fd8jxVq7TAJndlVPFoGJUyDJzSoQkAve8o6CVBEZsVCuGOtNu4PYvMjTQLb0?=
 =?us-ascii?Q?hkk1CDZ99knOAeXrGVWHJfB+fqncUb7fI2PD8xs+k2EQ6/Mr4wxD+823Cp1P?=
 =?us-ascii?Q?N3idRUvdpSaUOI2gIGvlzZgnnirTugXy0o1cUloo9j3TM1euel/JcpIGyM/G?=
 =?us-ascii?Q?hQs8XAk8yD8U9nIulC0grb4BkhmQU0VIvDyUiNqhylmv+E37e92oRKwfprpB?=
 =?us-ascii?Q?BpIlnXpGrGy53lPq33OoL+3y69ZGnstjr4a71kSynpnUC/ooKUxLMZ2RX2On?=
 =?us-ascii?Q?5bnXa6Cubfpy0+E2ZCvpGXabRHlcMTJK4NMD96J0qtwyEhWzhDDHfLQbtV2W?=
 =?us-ascii?Q?ZolU/iNsPvDKPXsYw6UA/Fb0rD9s59XiS4Q/ULVbmT0Db6gl7HlOUchVXXzq?=
 =?us-ascii?Q?6sgmD/eXloXU+EGm2muQ6r/fTfZe8k2StbCf24StFg2k5TWTg6v9tdaMcjud?=
 =?us-ascii?Q?XbOkdXGMjHeYDldROIiEMXC1rRtlf5J8VqUatJ+CPX3kiEsskpX5uE3sHiFt?=
 =?us-ascii?Q?WpBhx1bulGgL7WXUBzHPS7Ud5nsA+kA8yH22blRGQvpzkfp8WmjDJdZYsqEH?=
 =?us-ascii?Q?8P1TROXZHl3ywgq4UJ6D03toFjeGgExNHfmiWki2LnejWg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3WXkKfm02wJzyFmefJ3peukHrPDK4SiI8N3ngtDUEW+g+WFL7JCgS7QxN5qf?=
 =?us-ascii?Q?V9KtcAc79p9jgGZREgxAkSrawhmn/Jk+9WMoANHZt6JkDp1z6ijCCP7qqX11?=
 =?us-ascii?Q?hfWBglOiI6qScNCy85q7WBQG6xnMgLztpIDdGiAKZ1LB1WN2TYfVYKyME9BV?=
 =?us-ascii?Q?riwrYZ6K6Op+uFGUXiSoWYA3w20KBUjXPw9sRXQENIg9f/UhAVL4jSHMXuCC?=
 =?us-ascii?Q?0EVUhNox8jTrTp9vwBWI5j03Rl8vo/Dx726OAtvNpMWOn6LETM5YprRgYVdg?=
 =?us-ascii?Q?3iP1UU76R8/LC1lTfYz2LmrEn6wGebvcJE/WIoIuQQAp1dbMz02ge4BdxK/3?=
 =?us-ascii?Q?SLibpKhzLnUMDhrxF3uARL/CElgdiHhHQy2SkhhP0OMBFJ9ippmvXtIjzV8C?=
 =?us-ascii?Q?W0Eh6VnkJsmqMyZH0K1bnRUMKA6svaJAkXnB18ZJyrUYAwOets1gzuRt1Nzi?=
 =?us-ascii?Q?hkfyra8LZEpbMcEZCwjDCyBh+d1rq7FdupPqaNodt4htCjNx7y2FPLq8ssb9?=
 =?us-ascii?Q?yQD0yumM0KlAL2pLfrLIDWgNc2Py7/lFIehsJpRv892WBhiUBkthRtMj1KiP?=
 =?us-ascii?Q?g3r0ilLnUSMIkcbINoZW9gAzEe3d6QecDds//i0nldadvPi8/ppr8B7ts2Wo?=
 =?us-ascii?Q?AVo0Nqfsyv9KsdZMgFBAbEhxERANiOoyfPGfPMNm94jYCloAX18u5TVvJIbP?=
 =?us-ascii?Q?l3hh7NtFNDq/YJlsuh8tedxNnhPaDn/KNLCrb95FYPgQaXjC8GqybKC7D9V5?=
 =?us-ascii?Q?0cho1MAAdKs2vog1ICfPCsvIUPq0f3/aw5HlV4zNh6ywW65dlC3sBcPE7DWp?=
 =?us-ascii?Q?yxItxO/TxP7FScTj+504Anej8FKo5oV4O7Ysk3vdmjyND1K4wXXmASEu1tIN?=
 =?us-ascii?Q?JVzyV/FVw+rHEuucix+d2ghDCSaFcSaoKfakiJ8umRFLEqdnkWgYHgoBhyN0?=
 =?us-ascii?Q?+VO1AmOWeit3q57PhX8OpFXwHavgWzBbhvMRwsgaYkXVJBzJA7/O8GyFsXHF?=
 =?us-ascii?Q?8fnYzARD5NKyi6FcLHGuu+RHZdhlbyZTFGzYCvL4yjnL5BvSoeI/DuROdnxR?=
 =?us-ascii?Q?7VwFDcJNvSpi5ZbiARA2zQBCZjR5e9M3ODUNplJlbKsWUW5Kf//bIradUIds?=
 =?us-ascii?Q?6d2FWX+VVnnn/CVdWQlMRXiAiGeIPekjvoHfsyyMb/I5IiBALesACAa02M4Q?=
 =?us-ascii?Q?4zdJXlYSx469LNCHN8lcO+4SuESBnnZTYWps5hqy6lAR38vIvkvaHQZCHqWW?=
 =?us-ascii?Q?lIQNAzmDK6njuKQ1sN6B60Hitt14xxvg8FX0U84iH0EKqxJ9OhcwoeTEAw0h?=
 =?us-ascii?Q?NuUTA+rhPZ9vOJmtufhbix89sYJE+EzlyiVTqQHULfuLY0BIryFsf7SCF5kb?=
 =?us-ascii?Q?l0ueNLLm5FoUED0C9/Q7eQl2zuXoO8cAj2l8NF1Cg4vJfRMoqsuw7jCzoPdn?=
 =?us-ascii?Q?JTiSsvbGprOeffbY2W6rk6XkbNxg5YU4VSQbHNKuyn3uDgXEOhSNgGrUSwBe?=
 =?us-ascii?Q?GyOihbE1/GgcR1tfqtcUGh+OPGqe7Qce/43P8G8LF8D9BuQhT3IsQkR03R0U?=
 =?us-ascii?Q?VTKjrvisCX+qfiF5H/U=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bb65abe-ba88-4973-4d81-08dd0b27e953
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2024 19:00:20.4397
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YfvPhSzSTJeT20juDXiUj3u2bh3WFQM2BdsaAYATrgL9PkH6tD9ixX1R3lfX27lD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8877

On Thu, Nov 14, 2024 at 03:55:29PM -0400, Jason Gunthorpe wrote:
> This tidies some of the naming that has become messy this cycle. This
> series is on top of the iommufd and iommu tress as there are dependences
> on the iommufd selftests files changes.
> 
> I would like to push this into this merge window so that the next cycle
> can have the folowup got through the driver trees. Otherwise we will again
> have conflicts and problems. I have written additional patches to
> consolidate the drivers to use only domain_alloc_paging_flags() instead of
> implementing both.
> 
> So I propose sending this as a late pull request in the second week.
> 
> Jason Gunthorpe (2):
>   iommu: Add ops->domain_alloc_nested()
>   iommu: Rename ops->domain_alloc_user() to domain_alloc_paging_flags()

I'm going to stick this in linux-next the next few days and hope to
send it next week if there are no comments

Thanks,
Jason
