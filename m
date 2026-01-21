Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012038.outbound.protection.outlook.com [40.107.200.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB913382D3;
	Wed, 21 Jan 2026 17:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.38
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769015381; cv=fail; b=IuAePPZZtTnuW/2Cr3DBSfUwIEWJDTBe4UWJOl1HD8ZBGBgpKvPi5KC1dYoP9S7b93n2g4theBFdRLEGw0OXrOdDHy68c2ka+O3JfsdXQe4BR6vaQM8Gls4MenH7jGZ7KVx87L861JGVMz6+Vxv2Y46/YrsdTEGBAILzmcGg9KY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769015381; c=relaxed/simple;
	bh=lv+7dMdN/MCdUOQADOmeqHzG1jfzjljUdXSeyn6PC78=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=WzdyB0AVbWo9m1afvFLWdPNK6PiH9Hte+HOXhwgBy/swZIztXCcJ9vp7/XAty1Z6NUSMlm0RVa7jqr+RuzysVb2VIkN6NZ2hte7lLOHfqrIGyQfXc8n7PWx1suDnvb9WGJta1wYu3kOD83bI8Kim1MLIjl7QWCbtNf/Kd3T8ePI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=VAtOqMGB; arc=fail smtp.client-ip=40.107.200.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="VAtOqMGB"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Rt/f75a56KkU05o4ZLiNCSYM7ZZMBiy0laTNnHqVeK65Bp2ZZFZbXDu7cA7JYFDireHdrMXkEcCOjYEH7JOhZOPMlkYDIydn5hvHjSQUXhwJXlqcMnG1s9DtZ09dhlRF2EPz5WJ01JiLO3wx5z14u8Tn5dJgyZkbrw8/ddJZaOl4oTX/988JOSrbFxpW2Gu8FAlKpLGG4oBWTgQ1BctDevMUJyvvUrprCMt9wwr33zTWew3UmL/DUkIQilhpEWvA104wsZucCUCOgwlZ1KqlmGOGyP7PaRuPM64EFlq0rxRP124eDGM77q7czoIeNiFCjSoaYjrVqDpwFOUXtRaL2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sSqeHxExP+GmAyyVasY0JG7QugVh1F8B6+Kr0w5a4gE=;
 b=W84/GivSkxxYS0kffTYFHNUimU32WD4weK/NZxMyUutB3cIDVy1DMHcDoyNl4shu3Udr8Xbp3eDQmyPNsfqQwBR1IBIVbztK2DLyvqqNbxdZAV44YuG8gG1I+WvsHYFgJ+c8+lgzlY8cJY1t5TTgw6m+UgqhyP6MYQHsrnfc6g4ggtk8SKz6Gie7Dy9sRKpdjnxT10XoVVhSnt/yC4/O5vqe578yKedCO18waDXXygxovrCK5VOQjnYVXqiAgCZDSZDcuIi6AiZAjWVuKcEMeQwnjDzKfrslRfTidDD/48nXKO61Gg2g8bP9Ha8PhnAZtTR+Y/N3kmW1BephdIpioQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sSqeHxExP+GmAyyVasY0JG7QugVh1F8B6+Kr0w5a4gE=;
 b=VAtOqMGB1vposAZHnruOJ2ZiDlAYj+5vLY80oI415QqMkpgX4kmKDgAHP4wQj2acRxHJ8nWzbYU4r6FavKce2lc1/c8xG5BYKNGIRt/XVUWDt5cLdLoFnLNZiE1NwjCDsaZh0lU2yVXO+8MpIJfLuORa+Eaeh9XUKziP28xQoqZ1JLn1stcaYL4Bzkv9EKXal4Rog7M1uNWtTvY12FTsY0NnNL8NPPt/kxa2H9WLcek7ZgIghMSFqYkaCiKwo23mAdCNraZwaKG4xXtr6feepH5Eh9d1zLp7qqXeWZ4V1qgLAOjo86wBRuVpfFSUfxOKNxAnyGQ+labc0u3GXmixIQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DS4PR12MB9748.namprd12.prod.outlook.com (2603:10b6:8:29e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Wed, 21 Jan
 2026 17:09:32 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9542.008; Wed, 21 Jan 2026
 17:09:32 +0000
Date: Wed, 21 Jan 2026 13:09:31 -0400
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
Message-ID: <20260121170931.GG1134360@nvidia.com>
References: <7-v8-d50aeee4481d+55efb-iommu_pt_jgg@nvidia.com>
 <fc4f0354-4e6d-452d-abfb-fe24e53253a2@amd.com>
 <20260117154347.GF1134360@nvidia.com>
 <e0514ec6-b428-4367-9e0d-cfb53cc64379@amd.com>
 <20260119173734.GL1134360@nvidia.com>
 <e8cb2549-6a17-47ce-8e9f-96c576890262@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e8cb2549-6a17-47ce-8e9f-96c576890262@amd.com>
X-ClientProxiedBy: BL0PR05CA0024.namprd05.prod.outlook.com
 (2603:10b6:208:91::34) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DS4PR12MB9748:EE_
X-MS-Office365-Filtering-Correlation-Id: 6189c44c-65a9-4c79-3291-08de590fd821
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bT9RrkpKZu0WKUgrIFTJj5fpdG9mkuazu9HwLyZulpEcQMAePGqNYmM0FpVE?=
 =?us-ascii?Q?9E5EzgCFXMFRq0RKb1nKX+D46NmjxoizAq3PNjGhw+Vc7P7iJZI6PU/QxzG2?=
 =?us-ascii?Q?5cCq7AAWe6EOr/ZnarEthZaU/T+i0HEEbfV7vk3hHlLOpqU34eOjVgWDBw0z?=
 =?us-ascii?Q?B6ErF8Nj/aBZkTG14S2sObpTOOABvzuwX4qg2QhWouVCGYRcVmOhLolo7ZvR?=
 =?us-ascii?Q?mEUbIsvuujndR0JAlwDcR5GQ9JOeqbNgTkNmCASpn7BfUUlzqnvA7nycCxTU?=
 =?us-ascii?Q?Optiyqp8vt1V+eLGV4J5kLZJC1A4qurcvpj9H2/q8Nr3FjIfLCxx57U/TXEv?=
 =?us-ascii?Q?ExU5UYpCkQ66l7DE7ce1Mx24yXaVtt0TACuWyN/YedBYMmOF+mVmLiVy8YgW?=
 =?us-ascii?Q?KvHpvKUrfK8+dMxV22OXDw7iQcBlCA451A84eyVDwI3DOnxUix4SWF6UOytk?=
 =?us-ascii?Q?qgx6qxxWUhru2coJCs0vOu0ujbnOP/64Bi8RMki6dgNAA60UuB/7ulHGKNi4?=
 =?us-ascii?Q?4JK9BN0FObVZN8LrXh79cnwVQKOwUKbmluSiOfcnd8kCt6DUZWCCrIntf+Ne?=
 =?us-ascii?Q?gxo40wH+f8VIS6W5TxjRZ2eLiFwMdKEQe1QCUqL5OXqwK0DweKunbMVCj4XE?=
 =?us-ascii?Q?24tTjheSsg/eN2XihYf3wSExpwxqqTa+ZfsFNYh8euzMmaLQzlrJ3rOkRsMA?=
 =?us-ascii?Q?Rk6NIImiBATd8l3q5tTaq1D//uooRU2jxeCy4T5Wjr9eQOC3yDj6MysVH3n4?=
 =?us-ascii?Q?yY/sP0vjSumpkxJr/mg+lam+Kl9K687qoWVGQv8YMxHMCqMWlFe2ZboPa5Gl?=
 =?us-ascii?Q?ohrJoUkj1isW+UBdvwknsgdZGJvFVyKAB2e9TTxMdPrEUTlfZMOkn1/fme4/?=
 =?us-ascii?Q?HYvfFk3uRuhRVP5OzHYPwQEOpvicLZBy/rPz7m2yGDnTGJze5ZM/OF3up5HN?=
 =?us-ascii?Q?TFFv7Ht3q2wXp/CtHIamLJXU9rJbMpPt0OE8awd0VXK1DnE5+y7N95emcKRS?=
 =?us-ascii?Q?PuNH/HTzukYJwqIMMspoalWhVc90epT8SYYpsrYt4PC9UNi7JdvUmccB3Fq/?=
 =?us-ascii?Q?phGxmTAOe6X80VG5NQoEa47fcfRpTVXLTJkrnvNz41L2P/Q+fTsI372W6BTJ?=
 =?us-ascii?Q?ZwTk/GRqNKHqy7AZQyDYR3bECZRew9IoAcBHLTnSvh0fRdVW9JrdT7FS3+IX?=
 =?us-ascii?Q?e88gpvyKuST4IAyMJuZgF1xU6ZRvacp0buuL/IymrK8FQTv3sCFCLyxB8z+U?=
 =?us-ascii?Q?PBeoB0o6iAMEtaG81AQFjO4/ilP11vYCT3mzQgI0U2O0XzsmCgfMpPkV0zg9?=
 =?us-ascii?Q?PSkS42PXEzTjfDJk+7i04hTs9m7TxPUwzd0qC8TmGtExkjyN40e8MvWS3T+N?=
 =?us-ascii?Q?Pw5yYz2lEanFnJROa2T+Gv8KFBnZ1izv5TTP+dK6NDg63WQP2DJaPnR81SMg?=
 =?us-ascii?Q?04DqJIO2TVDkAjhm1TaBUNNhlgHxD19Au6irVQuIyi6j+JdaNJKYoXalwuRL?=
 =?us-ascii?Q?ezUy43WUFx027go6qDO5niIFxM3Q4lQONU50lUmkg6vi/5oMlXEmWVYKl6qT?=
 =?us-ascii?Q?qt5WAgw/7VR7buN4oK8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rto9fbv5hCB3cDBmi3DqZpifLSruA7lOkqCKTf/Uc/I2xv45g7e2Bd1ojscH?=
 =?us-ascii?Q?HIoV1FNiiGQA7ipu64LGs0bXMXzH3JiLVXGndmoZyx93RHV4V+d73E/7o2Ig?=
 =?us-ascii?Q?xAohjkS3NIQVy1nducgksafWKwpUfriMjl7reg/2L7+ByXT1tEALYmvcxmnp?=
 =?us-ascii?Q?GGLazZvbIrG5Rskt69rmmthzi5WfDpKkELLWlXyaWDArlChElEAHSq3Z63o9?=
 =?us-ascii?Q?xjildhuVKZ7oJDCoVXXBjy28a970kYlZQWf1Nv9M2VQxu/NUglrmPVkLxOfD?=
 =?us-ascii?Q?YnGVRf9KUA62O9Rmfxj44PYiLKaz0tVJ6zVaWA26PGxUZfKGjO76LKtgwjBT?=
 =?us-ascii?Q?JGSZUNFMuIYsmZdk/NKF9eo60zoJs9nTmef0wBEerSuZIwWf+vrqr5n/tK1A?=
 =?us-ascii?Q?vUcZ5GGMp/VoR3CYTN7K1cdz/9dfQiPkA0CfPVlDeZKv8lAPArvIcARdr8nt?=
 =?us-ascii?Q?TPBhFKBFKvP91E5v0vWawHPeLTJc80iX0NiKfZ7uN45VNC1r9pm++5/EQHgU?=
 =?us-ascii?Q?I4mua+4p9FduHa4MzYjHPInPypLgZxjhwqXqEF9ReJiQwE8RKrzmQZmxS5cv?=
 =?us-ascii?Q?vuCR8+/MHKWAUQyYoOFFtgg5Zz/ahntIwHiYDhq2vjMtgeKWf7w80+kbXFdP?=
 =?us-ascii?Q?v9X13sUAIoKPwJA23zT7TAxpAzeNSIermSaUmvDqqz8a+y1dBDbdmgXuau+3?=
 =?us-ascii?Q?6CcAdH8pGbq3Z33ciNVL6MJRWD3cA2q/+oLAQ7jZK2kZefkMRc5HD5eQ6ZHm?=
 =?us-ascii?Q?uI4UQ7ALtB7n52MdpR4aOzRwYEpFvj82GpZCIfq9OsepDOEKag0QM0aGCtNf?=
 =?us-ascii?Q?4ttOWuFsEklYgCWMAEkMLN+kevmz1uWGpxi63HP+mdDhm+uaHZT/VTd8drvA?=
 =?us-ascii?Q?RQeZPitKkCDgO7DRK+AgvNkAbg53FAmD3BztPQ6vEl6ePp9X/wQZypN1MP/P?=
 =?us-ascii?Q?JZTR1JtGcALbYSO/uR706C/iz1cl7dPWU35tQNolR7WITutUJksqh+POJueB?=
 =?us-ascii?Q?GE3MpIU31pV4wbp13W0cW9/JH0ufd71UV2SQYEnABHjG/uJ+J568Fid7ahq1?=
 =?us-ascii?Q?AKwHqEhGAI2Z3qcnPh83BHLsC+9BUC46Jnt2XGjS6GMhCCyoBXhexhcKbLuk?=
 =?us-ascii?Q?aGI1atgkzcMAAJXYc1Zmhb3SdyTNf+kNWSVrwQqp3WTnFpdjZMbAMRmtzBpX?=
 =?us-ascii?Q?VOQZyuiKIuSArI3gI0RYPzveUYVvevqgTLKrJPH0uEmHtDlzwMZ0T2a/5Z2p?=
 =?us-ascii?Q?CyolF95Df/Zv4tbUVV9WtyKYtsAbhYXWXrSy7DVbW7e6q5vf2U+G+XMNpqFe?=
 =?us-ascii?Q?iuUEIi7UTUSUUlx/nYrLUSGHctAkZlO6o3taGkhI1Qhtgkhft3n5xAppD/L3?=
 =?us-ascii?Q?5NrMQaqrZTlpo0eS3o8S0x9cUHKZX0HnbKG00HAQC7wHm8myqtITKjPjTodV?=
 =?us-ascii?Q?vQcL195fpzPvlSIEAL/ZlU5p8nT/Re1CAVHs75zTkSCN9W5B3Ffn24TVwyK4?=
 =?us-ascii?Q?z9NO0XrVGJk1IrqF067cUbJfg+hxrQrkA1NBcMA8gOFWdCGuCPOG35CXYg/Q?=
 =?us-ascii?Q?dXAjx8pkt30nBnHDEs2TgViOlwbLaeq0ECfcwFsKUraSYvzFcPzt6q5RkGCm?=
 =?us-ascii?Q?5cdwn1bQXWzcLnrZx9ugRg1e6qfxCKrX5m36h4pddSOnQCtvZcd2meSHHtex?=
 =?us-ascii?Q?WT6OwDOdoiCT5sKLQWkFG8LD8GVPQUvWTpFFEDN5rc68nsH7?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6189c44c-65a9-4c79-3291-08de590fd821
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 17:09:32.0108
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oGybYxEuA6cl6GO36a5fTO70uSgUW8rTQK1sJeX269Ovfr4q754udrSB/SluRVlP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9748

On Wed, Jan 21, 2026 at 12:08:19PM +1100, Alexey Kardashevskiy wrote:
> > I mean that the HW requires multiple SW controlled tables to all be
> > sizes must be matched. Instead the HW should read all the tables and
> > compute the appropriate smallest size automatically.
> 
> Not sure I follow. IOMMU table matches the QEMU page table, it is
> two tables already and IOMMU cannot just blindly use 2M PTEs if the
> guest is backed with 4K pages.

That is just because AMD HW can't handle it.

For example if you look at the CPU when the guest S1 page table has a
1G PTE and the KVM S2 has a 2M PTE the CPU doesn't explode, it walks
the S1, walks the S2 and loads a 2M PTE into the TLB.

This issue with the RMP is no different, if you get a 2M IOPTE then
the HW should check the RMP and load in a 4K IOPTE to the IOTLB if
that is what the RMP requires.

That the HW doesn't do that means you have all these difficult
problems.

> > I don't think you need hitless here, if the guest is doing
> > encrpyed/decrypted conversions then it can be expected to not do DMA
> > at the same time, or at least it is OK if DMA during this period
> > fails.
> 
> The guest converts only a handful of 4Ks (say, the guest userspace
> wants to read certificates from guest-os->host-os->fw) and only that
> converted part is not expected for DMA but the rest of 2MB page is
> DMA-able.

Yes, that's very true!

> > So long as the VMM gets a chance to fix the iommu before the guest
> > understands the RMP change is completed it would be OK.
> 
> The IOMMU HW needs to understand the change too. After I smash IO
> PDE, there is a small window before smashing an RMP entry when
> incoming trafic may hit not-converted part of a 2MB page and RMP
> check in the IOMMU will fail. That mentioned above HW+FW engine can
> stall DMA for a few ms while it is smashing things.

> oh but I can :) It is a FW call which takes a pointer to an 2MB
> IOPDE, a new table of 4K PTEs filled with the old PDE's pfn plus
> offsets and then the FW exchanges the old IOPDE with a new table and
> smashes the corresponding RMP, and it suspends the DMA while doing
> so.

That's a completely grotesque solution! 

It violates all of our software layers. The IOMMU and RMP are not
controled by the same software entity and you propose to have a FW
call that edits *both* together somehow? How is that even going to
work safely?

Can't you do things in a sequence?

Change the iommu from 2M to 4K, flush, then change the RMP from 2M to
4K?

> If I get it right, for other platforms, the entire IOMMU table is
> going to live in a secure space so there will be similar FW calls so
> it is not that different.

At least ARM the iommu S2 table is in secure memory and the secure FW
keeps it 1:1 with the KVM S2 table. So edits to the KVM automatically
make matching edits to the IOMMU. Only one software layer is
responsible for things.

That is *very* different from saying that kvm or iommu has to go and
reach into the other subsystem and edit their in-memory structures.

Currently kvm has no idea about the iommu.

So if you want to make use of that you have to solve this fundamental
issue that we can't issue the FW call without some security
synchronization and locking between KVM and iommu.

Jason
