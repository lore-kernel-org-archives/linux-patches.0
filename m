Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012021.outbound.protection.outlook.com [52.101.48.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3B923624AE;
	Tue, 27 Jan 2026 15:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769526706; cv=fail; b=d8lt7H4uLxdYfPkzuNHm0mACYN9CG9hkxv5IQZ8rUJOfDRUsvho8FSnsL/IWfl+muR0UIJOIIo9gHhzLnQI4gTti1MAyxUpTFnNgwJI8A9TJRjb2d1GRk4S6QPhhQORQPoaI2Wa8BxooPGcly+UmFIPwP86UqWA3JWrvHLVS3Yc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769526706; c=relaxed/simple;
	bh=KkXCB5lyVNzZg/CNMlCRkzPV7z+AoeV2MyyXgidmpMI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=C8LLwRaWT9/ArMhfrEog/hs9GdjttKncW6JETXtBdezbI/uOeUYDaaLFBbwTD5ETcE2U145ekxwgWymeG/ECnqsSOqLuv5nTpJ0d8d+NLx2+3s/PEqUdP//YQOzQsjU4OtEPgQg7zPQNWuiZ29L7as5KNq45NkK7/I1khS/Tb6w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WTO4LrZ0; arc=fail smtp.client-ip=52.101.48.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WTO4LrZ0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VxlWQGucge3VjctUOd01zpwJHkSR4tK1qS1R9+ERftQBxa1eDAat7SXPYQA4eZh5N21BPvMlRk3SIY2hsCRUW4sjQdXqj9zRO4T63EZfa5aglITHj4LmZtW+Ba0eJNNLWWiBSopqfM5KQB9MCxQDrL1Q5qBMJNP7eZm+e0r8TpKjhTz1wGB0wp0v4jmpEjVCCYc6zWNyra+eNAJrCf30blSxKwjHZ20/cOB9okWnQF8UOCs//oKWAGguwvjZMIr2dowHvqQoss3/39pKPr3wSRjoddF0M/NG7UeboMJP7U8PjGpFRqL1XjESkZNhwzmRWBhW84g8CaFU2xG6ZbO1oA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TmlnnHaLajHX0f7NKrwmyjkHbW/oEAb3Wt8HZGBTR6I=;
 b=D8yLQrFsMDKYyWJzEgcKrnGx1wxxVuK/WTAL3RTDnUYXI4Hy5e6CrewZnZ0+4qV/1dD/oFyoG7Gf1eA+yHGw7c0Fqxd8ap2nYz7p6iUyFswwSIvVpxP/Pefw0meNgbuGWbD6C09/IU1j/12TBJrapTfktCkfiZuRsZ3stID/LopworLSfUYjktDaOlzCytmZP1cmb0Cvki8or6UrSBIz2pgfNAH944qPkIfaF46r4VrtWmvLHyobbuxf7tiB/q8uuDqOdcUk57cyHgyPD65xHc7SuCRXWk7U4f0NMNtn8wPbbjWd9V+D9InVPjjPANFx2KVOXftt4t8FNZvwuQEaTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TmlnnHaLajHX0f7NKrwmyjkHbW/oEAb3Wt8HZGBTR6I=;
 b=WTO4LrZ0BJ7LCAoctzrQJ0NIUgCC5uCdfuEDPZ4HuzQsPVowkg8mzyIV2LNL+dmIJiXd5uxqwa3O/bEsetqyaA8BoGE+o8/a7ezSuTukYMXGkd4fHuMDVEXbmSVFPVhoHFURj83dQp1cxOrMpgD3W7XIavbWcsn/sPaXiH+QMWPmlvsD9/z31TKWKWbsKirC3MugHkFo2jBSqPXEJUtIzu/TdB+h1DlgRo0CLa8en+7SMy3sqGv78btcb1f0CjlCrrkbwaCxNKSPEgNFc87TunqIJ9I2AgYLEP1f62RFjFlziTEqhko/Ck4DUkM8pIdFghOKkAHIUrgtgfBE337IUA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by MW4PR12MB7483.namprd12.prod.outlook.com (2603:10b6:303:212::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Tue, 27 Jan
 2026 15:11:40 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9542.015; Tue, 27 Jan 2026
 15:11:40 +0000
Date: Tue, 27 Jan 2026 11:11:38 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: will@kernel.org, robin.murphy@arm.com, joro@8bytes.org, jpb@kernel.org,
	praan@google.com, miko.lenczewski@arm.com,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v2 06/10] iommu/arm-smmu-v3: Allocate vmid in
 arm_vsmmu_init
Message-ID: <20260127151138.GI1134360@nvidia.com>
References: <cover.1769044718.git.nicolinc@nvidia.com>
 <3f7c5b84c4f8605688ac08fc2ea2dab08a3c5c0c.1769044718.git.nicolinc@nvidia.com>
 <20260126211636.GB1134360@nvidia.com>
 <aXgrsJeXB3bpFQqK@Asurada-Nvidia>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXgrsJeXB3bpFQqK@Asurada-Nvidia>
X-ClientProxiedBy: MN2PR15CA0037.namprd15.prod.outlook.com
 (2603:10b6:208:237::6) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|MW4PR12MB7483:EE_
X-MS-Office365-Filtering-Correlation-Id: a41ed359-f416-4bc3-aafd-08de5db65f7c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FWu6GqDAMLL85yRN0PZWxp7pXucKgPoSHJXhBsc38gPdDnCiC32s7yj5CGWb?=
 =?us-ascii?Q?NEwmMb4AmbTxb+t+vETBmA6Vyutd/sgeYro1k4wKVXhqf45QEkQP3O3Z1iZl?=
 =?us-ascii?Q?3ZpxCe+EONMCYzviousJ7m6Fh2JcF7SB7FtGLC/MFZ57IUkYZjzagDk9aNur?=
 =?us-ascii?Q?/JYiv4rMzBLmJFJDdaq3yKeWoWKaKXPIfXX7C97n7llN/abcwzn49lZG2j90?=
 =?us-ascii?Q?aR2NU8zX7FVwHswpKhwSAJvdMi+KEg5lFFuChR0dnS4bZ7xm+zs/xxNVuqK5?=
 =?us-ascii?Q?VdGRMfHKWxvpKCMljs7F2qzxVWZYzA7QT72b6S6ClZnrL/RsMz/sc4Ras5dO?=
 =?us-ascii?Q?gZSrTBOlVtxl5Qyu9s9/N/sRK1YzDogdmZqEW6DYi8MVDxeuIPaHsHQmJqCS?=
 =?us-ascii?Q?+YTIGyaQ/FnfR53TT1Wv9Awf0H4gozW794lP29AcBbq8+186IEAzPnoD+vcl?=
 =?us-ascii?Q?clvC861bWUCAFPEHUQbsRK1yZdnyhmNC7BWd4pyNuiaXxBdUWUpOt7voW+PS?=
 =?us-ascii?Q?laSJpGQ0ISpHttq0KmtPo+jn/In6t4iXLuFEpcj8uMOCWUYvQ7LpYPKgwnUo?=
 =?us-ascii?Q?cVg1dTbLfdHD0h84Ncx0rOxFSGzXBF7OxemHpNUXnNNjOWTrVK8/z7NrBwSr?=
 =?us-ascii?Q?eSTSr4awBH5cSuxaHq3hbVUNerGTCFHYgyk6XYEE0DO4Av3zq1CuXPnZh40T?=
 =?us-ascii?Q?aPnk05AXQFqLsaojf8BUl8vq+Sbsjv4ix4z5LFzg2xU6xYrN/+YR83Xrw6Qu?=
 =?us-ascii?Q?otfXlyQK/AmVz8YPqOwkpiLz4PpCnUF1owwRTRzyChhU54C7b6ccq6DIhpco?=
 =?us-ascii?Q?UM/Ku6onSqGSdmeOpoch4cyytPTRbLNFlcJrgQv1ZmNcLxKrjcdioLVpztnt?=
 =?us-ascii?Q?r0fQvJAW02Q+8WKN0jlim5k4SBJ/XqMa1TIK2EsyVcRq+t3/n7mAXkoMrzeb?=
 =?us-ascii?Q?heKn1Ls0TbpFMdzORTcByIURwTZxgM7raD00PWjpkIR6hTxkh032k0YGkNWO?=
 =?us-ascii?Q?Zfe7fqEfplM9H71nK/iXf1piy0ZaETjpL3WvUt1YEkVAYz2U8rbs7auAsIWV?=
 =?us-ascii?Q?VBNFLBCF3LzViEUEdHNAac+eVJ7UfwWNk9yaD03+fHNSwwpyF6a5ww/d7WJC?=
 =?us-ascii?Q?xTCKfIQjEU4Q7sFHfTT0sGwdwyR8wNpHFXX8nnJ+a0NAcifrzv88aQhUkJiS?=
 =?us-ascii?Q?yej5TVMXwQld0keENdlVNoE5VGve1y1/OqLmkwc33SLpfUl08toRebo8FlYR?=
 =?us-ascii?Q?CqrNdRgS5eA2Njuki6QV9C0zXbmLQmwysYj77DWhxQas2kEFI8eygIziEO/g?=
 =?us-ascii?Q?HKEvGcy/H9klxdWPEPtrawZhbdRdFLv3iYW5gJomDJBhjYPsYf5gNQP//eiv?=
 =?us-ascii?Q?XXLgBJ8Rrot2nGmZIARHGF7AKq12SuYsBjpDSZpruSMJ0PiqzEufkTMBdl/O?=
 =?us-ascii?Q?cz6VCI9DCN70WdR8QTQob9hwlFxLwu4hAtkfFBSZS6+9J+dRzrO/L9YIUkS3?=
 =?us-ascii?Q?b2cm2w7Q1zGTeQtwKgnBtC8JJshUlR0siWcP/nuNagw3uCMR7AjZhKVP3gcN?=
 =?us-ascii?Q?k+TOroyaRHT1I3OLCz0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1wYbjATIKkOPlIVA+glMZbTEcJeH0vzBc9UFydUfo4vYCbyA3uIr80TvELES?=
 =?us-ascii?Q?GRNIQWDdDLC+74nEmr12uUQpU4BW3hCBxz+iIzpEQ+/Vhc7L6A6WeAZqWr8r?=
 =?us-ascii?Q?bTR2rpZf/tNgAvMMGXXhXdA+4LDhGEPLz8B7RDbCzuk3gbP/Wy+x7XvDvjhG?=
 =?us-ascii?Q?RhPP5c22f3tDrLpH6kASPyvIZcWTESNDIAc6s13T4dvIRspyMU9kO0swbv4/?=
 =?us-ascii?Q?FgYA+K3K1s6Hx30KuIQc61M3W7jDdNcyBrNuAuNXHrt9Xa4ccvSD4wzxoRBi?=
 =?us-ascii?Q?UT9XJqPD3r1d/kx2jjef1B8alOKMTdXxrssAmNGvopaRxEABpeotzm2sXPI0?=
 =?us-ascii?Q?hpxZ1GK3HyPSSwLLYnk+ycBHw0ZGis3YSl19YZz8rkIOu4vVaCPzj00zuiYS?=
 =?us-ascii?Q?KVzkYbY8QmBblNLs+w0w5lYO8rdSFRR6hjegDe/IipjMVjNp5WmslyCw4EgS?=
 =?us-ascii?Q?Dmnp0IuHyCCFGvZk4WusDRC/pPCwdZOa6siPfsEpVJolNgimdYT3NLwGh/Cu?=
 =?us-ascii?Q?14y00fto1+5IMyZe9dx3Xqr5pogUKvY/78nLxr19wosuLubwrqtLybaMdIoP?=
 =?us-ascii?Q?54B2oFsqkaTfijIqDxbhsMjO3ijI1ibR5ZwERZC6mblnvq/NY3LUbs0ARk5y?=
 =?us-ascii?Q?dFPObOVUhbluqimwlgRNwULaG+uSTWME7i5WuIs89gqhxrA9xJnHhKDf3sD/?=
 =?us-ascii?Q?NZZRnoQOt414VFeNFkkiQxEi/6r8e2P+UApFlHr+pIxNSA9R5m6WxQNaC26V?=
 =?us-ascii?Q?xYoU233VqP4XYBBYcK+yl7uL2Zy6u7zoXh8ei5/CuegRnzSEIrWTAZRAJ+uR?=
 =?us-ascii?Q?kYxiw0zd5lRop8NFwX21b3Rqbj9HqYpQFzKySLD7nwmnrcCtYQOZU9aCy6EW?=
 =?us-ascii?Q?Xxkz8YIDb4awaTI9zGRXCjTYfqcD8dg/+YqACyiOCA9Q4IOpCGSVlVI9+8jN?=
 =?us-ascii?Q?esK9ooq+Up8DO8Bo+LINUm2fxiPGEbd7UeXylWGiXKDoeJI1S9sEj2XDKtbI?=
 =?us-ascii?Q?kSyc4LhTK/GZ4F1rHxZ/iEhc9TEIa+JAEjdpeWvnPt+dkw3cp+8dNrXvgkOZ?=
 =?us-ascii?Q?FzS549Qim7gIhyy2XWS96Wv3n3BoT/gpB1yMneVEAYZe+JpOKNYSy5pOW5q+?=
 =?us-ascii?Q?eSXKV0N1Pv9X++GaTTNr6u/gvRkjzFK2hNNrp6eRKybZUi8sNau+q5blivCp?=
 =?us-ascii?Q?46jQzDH1Ger1N7PMqHhOijHO3qrkMrBwhk8R8RwXEmm0DuF636gcwn4q2XfZ?=
 =?us-ascii?Q?/RkSVRtNh4PMB0sgJbY8zYp3OWlaBQByGQgDzCNJhlwjx5MvSf206W5wKq5Y?=
 =?us-ascii?Q?4PG/CDwK/FLwWRIGcS2bz8wci8EV5honwfEtK+VEUKGKq6HiCp5XgxaL1o/z?=
 =?us-ascii?Q?ahqHX5x0gpW7gVxNW5X67kutVTLXsL+aM/NPxgzfiDU0uNOUvI2qd4S54l4C?=
 =?us-ascii?Q?R4BSfaYDKb91C6arVkUUKNuLgLiViHcnUdshe2H4WwMvgm0q+m7nbZTJqKbz?=
 =?us-ascii?Q?sztS5GNywovspzSrZzrN6i+fTLwoy9vLTuagZaWTDnU+vUskpT6VwPenAa+g?=
 =?us-ascii?Q?0anM93kuVhcQG8lqM1Ai7r0GgJjvdF2X1+2lw9xKZTAfiIn/01kMA9YXxYJr?=
 =?us-ascii?Q?mBfOQT+ONZHmCAHHK2WMCH/toyQaunf8qg5mtSubKG9xAYrEVfVRdB/0AHRK?=
 =?us-ascii?Q?W5OMj7SYKPn8a3LEEIkIGGv4ftfC8k/MruMTMgh6G4fDevc1/jqkIHwBv2p8?=
 =?us-ascii?Q?urcIEg/bMg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a41ed359-f416-4bc3-aafd-08de5db65f7c
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2026 15:11:40.2749
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tOFiDwkOfP0rO6XnlWVcFJPcT5kvf420a/MjCeBIrJrlnJepJ/W3/+iYDLW7+J3Y
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7483

On Mon, Jan 26, 2026 at 07:06:24PM -0800, Nicolin Chen wrote:
> On Mon, Jan 26, 2026 at 05:16:36PM -0400, Jason Gunthorpe wrote:
> > On Wed, Jan 21, 2026 at 05:24:24PM -0800, Nicolin Chen wrote:
> > > VMID owned by a vSMMU should be allocated in the viommu_init callback, as
> > > HW like tegra241-cmdqv needs to setup VINTF with the VMID.
> > 
> > Even the architected SMMU needs this, the VMS (not implemented in
> > Linux) should all share the same VMID for the same VM.
> 
> But for standard SMMU, the allocation/sharing could happen at the
> device attachment to a nested (maybe bypass proxy) domain, right?
> 
> vmid is only needed for STE (attach) and invalidation.
> 
> Or do you see some other case where vmid must be allocated during
> viommu_init?

It has to be tied to the VSMMU, it doesn't matter if a single VMID is
allocated on-demand for the VSMMU or for the lifetime, it has to be a
single ID and shared across all STEs.

It is easy to understand that lifecycle by just allocating it for the
lifetime of the VSMMU..

Jason
