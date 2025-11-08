Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012015.outbound.protection.outlook.com [52.101.48.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C849726E165;
	Sat,  8 Nov 2025 00:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762562905; cv=fail; b=jHXmWg0Vk6Kq2Hxj4FMMVgBqPCVpVa9AXGFKcyn8yx1R+asQ1Geltr+pY2dLUHhV56Mnbm5ocGD65P/eHqKYtnxZwpcsDyVnPMbAFuR5uBdiLubSg37NEEXWv04xcs6eYXTYxweRjKe5bs+Lfn+6mfMoNgfjEmma36ATKPFnWj0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762562905; c=relaxed/simple;
	bh=cAmT+Trj32PPDKlHg4JUsdlX6TwBg47QrtBJBabHxlI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=KCc+gLZi0dFJduah0g33UCfaQh/M4rDsocNzkTX6kwF4djssL23QfHmGFDCH0n1dixysrO37GMwy0IE3fynbntT+YjqzJ0ef4CWpfbC0s2pLgqKio3tJwGVMHz4E+zChRIONVGsRHz03E25GCbZDtPMSfcDnR2R/IlR9RFW++vM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Pizy2zf2; arc=fail smtp.client-ip=52.101.48.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Pizy2zf2"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N5lHOkBGfyBO/zF3WFhgnP5XhHvSmV2aimxwa4KX1uN7QWTl0kknNrg0S3YH2xIX1kUijq49ANBEDidKv2M10ITeAJws+6wrmTyIFSuhGbFEdh7v9UT+cFkO2NVqYcURuoDzFKpB4jSF7n9aE8G7AWZPZINsf3QgIrxrTv4+ovEgWT9EowrNwbbpf4r725PofZUo63/RHnK3n77FvUpbiPt0k01GUOEO4q4bR2nnXoEeN54DsR+7MPqLAMIFiFfw1ppQ3YI8/YnGMiG7wUDk4BiT4ajTjJG8UD6a2aBd3cASSjnbBQkeRlht4V1qTQvzMBaJoeYE5DyxnQQVOeikUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=93IuP8QS+PSwi5jiSM1JFK8rVBe2O7lTuH9jmKmhi7g=;
 b=CJXF3Z/TpuyyKMPzZIe97/COZScZFGY75+6GjU59tJ3Sg9fodLTPgeC4lBJRwhtlApEMdLzAbFndU6cET2EVoqwSOtdGgTXTDwFfpUZp4t+HO91lB6XXemTUSaREjBIprvP5ufhB+CMDT6Fwk2gy8xUf78hl8bYUYAlGzJoHhCwQOFt5LY1YaYXlIi/6SZcCv0sUZqQHI8XV9sKK67K57Sv2S+4XMYAmWBNf3m1NEkTjjHZS31Zvaufqa2yKtyxeB5V3vBdzkEhcnQOhdXa8X6VloQwTFvS12x/4+2Uxb3gHsrjLM2aT2Kg0lGXpv+ZIJBK3Xwlya4p8+vPfX9J73Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=93IuP8QS+PSwi5jiSM1JFK8rVBe2O7lTuH9jmKmhi7g=;
 b=Pizy2zf24GBBOeSmAbrFKiRYUo2J1kAJW6fxIByTKhtF73MeK4rhfv8dZcLd+HVsRjs313UicbKX9ifJJO3C/CrWbLNpgi3GbRxBNrh+WM+jpAdvQcKlJoFkoCTdyQczy1/paNJqiPo4aLaaBytZ0inOS309lDOcr03tnNbyRx34SU6hYEbN+xKJRNNAzJAm76wGPTVi2toJUy3kpAZbVU93IuefZWmdHPKIHIVE8nJhkmS1MeaeEOfTJ8gf1qDj8bH/lQEdgOy7m6I/eCRl2fEwTabJQLxHdUSzPZWCmpU8IRJiv4DqkvzVwbMAKD/nXEKrxlUL8Yw7DnY2WAVGCw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SN1SPR01MB0019.namprd12.prod.outlook.com (2603:10b6:802:23::32)
 by SJ0PR12MB6733.namprd12.prod.outlook.com (2603:10b6:a03:477::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.9; Sat, 8 Nov
 2025 00:48:21 +0000
Received: from SN1SPR01MB0019.namprd12.prod.outlook.com
 ([fe80::8d14:5845:8725:4978]) by SN1SPR01MB0019.namprd12.prod.outlook.com
 ([fe80::8d14:5845:8725:4978%7]) with mapi id 15.20.9298.012; Sat, 8 Nov 2025
 00:48:20 +0000
Date: Fri, 7 Nov 2025 20:48:19 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: David Matlack <dmatlack@google.com>
Cc: David Woodhouse <dwmw2@infradead.org>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Lu Baolu <baolu.lu@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>, patches@lists.linux.dev,
	Tina Zhang <tina.zhang@intel.com>, Wei Wang <wei.w.wang@intel.com>
Subject: Re: [PATCH v3 00/10] Convert Intel VT-d to use the generic iommu
 page table
Message-ID: <20251108004819.GD1932966@nvidia.com>
References: <0-v3-634ccd3efce0+16d38-iommu_pt_vtd_jgg@nvidia.com>
 <aQ6OlHhq4TBM6sF8@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQ6OlHhq4TBM6sF8@google.com>
X-ClientProxiedBy: MN2PR16CA0057.namprd16.prod.outlook.com
 (2603:10b6:208:234::26) To SN1SPR01MB0019.namprd12.prod.outlook.com
 (2603:10b6:802:23::32)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1SPR01MB0019:EE_|SJ0PR12MB6733:EE_
X-MS-Office365-Filtering-Correlation-Id: bf1a9d27-a886-4108-026e-08de1e608381
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8EhgjooRc77MzM0uFF4eyd50ZTaMuLWKk6cyZHE7zAdlfhxbo9YAYqGuvIbE?=
 =?us-ascii?Q?6r4EKTZ7LAc4geNcVI7tQCl+474Z0Hd26ijj28K5Tinoa1MsgQauB7VS1VnJ?=
 =?us-ascii?Q?Y/OmdsXcbd2vYOF2zvL0LVnQT45ev3HrQqvlAzdmexkUMyEp2mRJteRxtxLt?=
 =?us-ascii?Q?6e3EMPjniY+mJ+DXW8YQavIDwsT48ZLBzfRlkfQNrkv2/4zibTNm0JZ5egGA?=
 =?us-ascii?Q?yXx6Gm6I/YEoSmWMHgcCyXJoEtTKkaYHGihE6X/mHbVgQALTY6HpUuSCPqx1?=
 =?us-ascii?Q?eG7OCCeuEp61ND9UsASJcNQ72t3T+G1RV92Q6R/88Kc/fDMXg/7xlfXhJjCm?=
 =?us-ascii?Q?RtLB9tlyn2iVoLcp4Fj3Rz5EvNg/yQczBisaPUX5hM+FkD1ik8jEIaXmhQ7J?=
 =?us-ascii?Q?LSAFv4TpWNvQFp81/cMNMaTqLXGgmeiCcpHFiN9/a44/ZdsS6hNSrzh2+pRx?=
 =?us-ascii?Q?si4J4E26GUmeKE2ulgpW3d21/fvp+6cT7Th+uYWmnDlg8gIQS+V+b3Kdmlit?=
 =?us-ascii?Q?KhbV7U+UoNi6qLoJN+TZtS564uxJAv8TnvqcLtcyduaUmO/rmWgNIbQZnU2B?=
 =?us-ascii?Q?kpBHUYdJ+Qfh15jXWW3hyTWRnYuNrDVsTF4kQk2nGOgXnD8vo5jqr2n6C+9C?=
 =?us-ascii?Q?iu+KJ9f8qfs0/H/h3qw5dgzwuAx15gi/YQa7mHHQSQZloBCkOSYhupatIEEH?=
 =?us-ascii?Q?/4t1gHomGiwA7w1KNGrRlbFupCUNzCkj7+ZY0PEj67aA2lhWZgP2nOpM8E5C?=
 =?us-ascii?Q?1vemMN7anJpwecoEqB0ssLlO/9jyghU1DR2zaSgy2x+ogi85ecrC4MM/38eJ?=
 =?us-ascii?Q?53nvNfkv6Jtg8SVJ+FNfKMVgdm0Y/Xq8wcqXK90P6liFZvf5jinEvl03m6vz?=
 =?us-ascii?Q?Hn2hRFwpR8HwFrbB3+Y89c16ZwVkSKK1tZfyNOVIU9WBF4DQRc0qsI+o9t3D?=
 =?us-ascii?Q?+Xy/KTQ7xkz5vW7+TkJT0y3h6188ovxD0SLXB3qx3+sOCpKu/fcy/obdIJtI?=
 =?us-ascii?Q?Qleov7P5lyKRWuTUX1dkbMGVVhZrzzJUA/x6ZxIwaOw/Ya8Zy+WqeMddI4+2?=
 =?us-ascii?Q?of626q/O1+t3Evq/dm6i65BRdlZQ1+Ew6uGFAgBywE/X1kwYLyFXwf7EFAFw?=
 =?us-ascii?Q?PCCazXlHkiHMz98A3ziRUKy8A8CujudnBDIJY0gEjog8J1oc/5nLaSTyn4X2?=
 =?us-ascii?Q?XYlUND+5AgT6v3qScox1hTbYTfCQnZ1wlG2Vjzh5tTyVIkxV7ObveXzcpwrC?=
 =?us-ascii?Q?tRia065txVd9lBl9DrOxj+O2crhWxOLq5OPj42FzNVPHuktUO1FGQK0++zGm?=
 =?us-ascii?Q?SfXeZJMqbdX0c9JWETmaiAHR5Z5kF0ndHtwOQ6kPBM1M4tUbM+5/+eQCtofl?=
 =?us-ascii?Q?vSsfj1TYD43z5E1jCNKQcfW666hKEUhLDhyUwYifyx+Kv+subOdIBHuFjMv6?=
 =?us-ascii?Q?hDrlh0frYwzYzLbDcileV4bmDv9xjbB4bo0JhIP5cxLekHMEhGr3nA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1SPR01MB0019.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cuUK3r48hzLAL3CCPOqSA2P+dhpqxt6n9EQql+mud9QqSaAgz+CP4Chy3zLe?=
 =?us-ascii?Q?zjHsZjtUcH2+lskBpPyIw8HNm9yuWyl9F7R70JeCa/z32KxhRvwPUvf1c708?=
 =?us-ascii?Q?aZqnS/RTcEhEvzXLEx7oM8EF2lk0LFTd3bk8+YfVaN7JBKAmWjEMJMUGamIP?=
 =?us-ascii?Q?kbA88X5z8X9s10Xapvr0uBGZHmAQkG0yoPn/hHgMtjUVGAXxFmIcUkFamRZ/?=
 =?us-ascii?Q?wkjzFcnAHvgYxxck0mS4dgX89kVOZtriJM0CiRq4PjEb1jW9NNO991anq7lS?=
 =?us-ascii?Q?LDkGJ5WS6Oefcx/REzsflpti1N3Cn0gtSm4XAEx9yqDUUNsGoSnJCFFWTnqM?=
 =?us-ascii?Q?1EdM7r6+iqbBQuDxlm48YOV2vke/kMj1zb+Du+jrRoiOx+zsUyOitRpyX88r?=
 =?us-ascii?Q?8c0UbDWjUV5euZKeIiNZYREYeURNzoCaxTeSQbMcqiZypAq76jJju3OSNt7K?=
 =?us-ascii?Q?477Tx7ZnELL0N+NStuZEJy/rV08PCehakCGqDKlyftYoS2wL9gv9BrgsDoOn?=
 =?us-ascii?Q?H3jxdazo0Qj0EiaV7Cy9BrIAi/5musEdG2ND4s27mKBWZMFHxoxu87gv84iv?=
 =?us-ascii?Q?hEhDtKv/Bsf00uTei8TvTXJgl5KlbpVR4l3DFOz/p0l8CkRpsuWlCLK04lQz?=
 =?us-ascii?Q?j9Nr+SPyRQE1nHDAzyAHB14dQWCBeVHuiGsPfyBaaKqVnodYlbSlbFbG33Rg?=
 =?us-ascii?Q?ng2ig6kPBq6x4iTGyzLp5T3aN2AQJmyVR1IMZvaMAhaMMOnLoLvFsUW8Pe87?=
 =?us-ascii?Q?I0fWmeM7oG9s3lPAUEqVkjT6lh/KdWExRe5Zwa9RVegNZQGxikNz3mZPyNih?=
 =?us-ascii?Q?Fr/TWjK5rLP+gY6w4pVKXSSqcnodCQFQIYmaI1Em5dEv8dmdk/oSpeLne8g/?=
 =?us-ascii?Q?vrsBjNZ4TsIVJgcTjnOcqAgp3gcnRA+bVV6rv8jVmG4P5AwvM2skp8WCL6br?=
 =?us-ascii?Q?O/L81VVoU53miRZgSuD4BNQTFzoffYUCqUjcMSm/9xPBcygwPa/IwgKS0eFM?=
 =?us-ascii?Q?uIvzmTAcCnSXAxo3xb1LJm0QOUMRfT/T5fnWUrLa8SLn5Kh3i0NtZZEH4H5K?=
 =?us-ascii?Q?466qJDXLDAjjmwpCbiAMWUbLGzwi+fN4J/3dNu4dPd4kgL46ntXB2NZjT9VH?=
 =?us-ascii?Q?cJhsRvZUNheb/4VVcI8F2w1aIkXdx3ns26TdzP6L8rXgfnw/NuuqxG98e+aP?=
 =?us-ascii?Q?4js7zbHFmtTQ+tjT6TXP416ODZGEA2oewlYx4K7iNvSeFGk8qrJu3rmBhnkT?=
 =?us-ascii?Q?AJC+waT2ka6TNEaOPITt+/X+kGJKgMD6JwFVEPblk6giv98jjBnRGSupKZ9t?=
 =?us-ascii?Q?6xV2CpmBbvlQ36JH994MUJbim0JQtikpd1YCo5xQCTr//SG4XCF4Gq0Q4vLr?=
 =?us-ascii?Q?QtGO2RutMrio1JqHCuPQGxpf3CluaUUTDDhmaCQERUlEc3tK6ANNfKrwlhkC?=
 =?us-ascii?Q?drGNGZE4QdTyaPk30F9qr9fE3QWmXzvheYyaicEYwFwkTpGscbIhRSRPiXr+?=
 =?us-ascii?Q?D+RJlNYJBWqwn2kzgY6oqxDxtFQk2lFLxkatPjlcFrdGWwTL0URJ0cAGle9p?=
 =?us-ascii?Q?vSlNQ0lOE99EQyy6w6k=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf1a9d27-a886-4108-026e-08de1e608381
X-MS-Exchange-CrossTenant-AuthSource: SN1SPR01MB0019.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2025 00:48:20.6393
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UgfwdPyjexhQ46O7FS9ZVdbCXK26DsByC58wmnwdxyI5X3nupxcHjDCNON8nwxp3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6733

On Sat, Nov 08, 2025 at 12:28:04AM +0000, David Matlack wrote:
> On 2025-10-23 03:22 PM, Jason Gunthorpe wrote:
> > Replace the VT-d iommu_domain implementation of the VT-d second stage and
> > first stage page tables with the iommupt VTDSS and x86_64
> > pagetables. x86_64 is shared with the AMD driver.
> > 
> > VT-d has HW that requires an incoherent page table walker, the majority of
> > the patches are adding generic support for the required cache flushing to
> > iommupt. This is modeled after the existing ARM64 version and is intended
> > to be re-used there.
> > 
> > Applies on top of the AMD conversion:
> >   https://patch.msgid.link/r/0-v2-5c26bde5c22d+58b-iommu_pt_jgg@nvidia.com
> > 
> > This is on github: https://github.com/jgunthorpe/linux/commits/iommu_pt_vtd
> 
> I ran VFIO selftests against this series and did not detect any
> regressions.
> 
> Notably, vfio_dma_mapping_test confirmed that this series did not
> regress VFIO's or IOMMUFD's ability to map 2MB and 1GB HugeTLB pages
> as 2MB and 1GB entries in the I/O page tables as expected.  And
> vfio_pci_driver_test validates that a device (Intel DSA in this case)
> can do DMA, and exercises I/O faulting handling.
> 
> Tested-by: David Matlack <dmatlack@google.com>

Thanks David!

Jason
