Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012069.outbound.protection.outlook.com [40.93.195.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 281F92F8EA6;
	Fri,  8 May 2026 16:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778256171; cv=fail; b=IGzpIsjNQTPAuL+T5UVif5Np7GSy38qs1qafoLHDXr9s1dlC1B2McJPgpU0/didDqPQKOVK45eG+CieW+eTJ+yuozOnYvaT6ksGkfid008oFWqY1UpMU/h1wQOP8iUnkzMxmS8wFPFdAjUwFmAClyDscsAr73D4axrRON8eP+Ts=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778256171; c=relaxed/simple;
	bh=wSO9SWIgHED8/i+XIxY0FMDj+tIyTsUv5d52hetTwN0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Lh9PMGxWYd3jB/2sZTfS2tihBArl4f7NUzgbkiSuisEpR/KCWLECP80zuK5rrLw8wjgLu6EBot1jahJ93GUkBWKmeqEHMUEwfxqsPGDbviVRRrRKFRmNto4Escjwz6eFDvUiSobvdHgB1UDv9dvgvkzN6OVwMcjqjqJ3rrPqH0M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=LWKnrIG5; arc=fail smtp.client-ip=40.93.195.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="LWKnrIG5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mv3S3rMFWwjIQONCFIUbZjryO2BEQhiSSejcPL+DIV38IF32ud9QJUoznL9jFSdf/HSsPgWkAjrK4e1AGwod2v86xDjm4S0FtQIC80/FRhIXgwDGcy1y+6vdpfHj916b9aWKokD84ujnZbLGos3P2Rovu2zAsxAyYs0YGXMoDApK+wJuRPcnJkkMqUEDteFCpl2aMZn790ezoAFKCYdVKms9N3qXedS9f86Q3j/NmBCwgoZxdm+VdbzbeBnlcymMAhmMZmY+t1WnmeMYq9Jo+xT1FGW1xAbSfQ4qQEoT7xX8VMufgVTyxNDWqUUty9j1OIReDjYOgk8BB90LZrzjWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2+R/3C0087xqcjZHQNsWnCT6OGW3BwgylgKgVGEdpns=;
 b=OqrQh5eZs2QEJvcUpSr8moYlV7sMx++vNTiJJXeqKuzPHEMqEffI5gZOiVfb2wYpEuvOIAdqjnpNCAAH/3oG4nOGb60Fx8eMCs/t8u1fcRG0qvK1N/RBtCBL2UuhXfPQvAp6kas1E/YbJ+rV2iEyhObzdVTgwSMQ6EC6c97YHX6fj287lzXNpLxcZuE6EG5fBindjkvZPEfPddWXPIXYxzrLe5FIX+IPYDZ9/+/WRSaHnJV1pqvD5quskC7W6pqrgH5XxiVDXtUDvSXGeDwnywmFfTm/dX3XuGqtCNlMbUoNDfce3pKwPXqHOUFUqzY1bmaObFzB08rjGFhEgwBJOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2+R/3C0087xqcjZHQNsWnCT6OGW3BwgylgKgVGEdpns=;
 b=LWKnrIG5fsXCY0CTZVq6JLPtZN77w7v3otIERrxnBMKbpFCZyjVxje9nx+WwIcj1dlV5bXsdq+NXN6UKnHOukcLfIPvcYgciGkh9ozEiM9oYNMQpGX5FtcZ3M8HNh2MZwHdCX3apNxaQJyiVGqoINvga/O4yx7Q6NNx8YElGwoXNOvFcwwcjgWJQCsltscUjbbo0mISCyeU6Aji6a8AuVhJ74YbykyE5KJLGUkh0kNG0/InmtdMfb4cBbn1FYFAdRa1HnpnrRkYKPmnQDgxBqX/o2gGE9eBfXwnHX/ph/FJLfiXdOJG3zCWH4AmvnjUrT0tSRkoaoB0TuMN2qd5ZDw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DS0PR12MB8502.namprd12.prod.outlook.com (2603:10b6:8:15b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.15; Fri, 8 May
 2026 16:02:38 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9891.017; Fri, 8 May 2026
 16:02:37 +0000
Date: Fri, 8 May 2026 13:02:36 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Pranjal Shrivastava <praan@google.com>
Cc: iommu@lists.linux.dev, Jonathan Hunter <jonathanh@nvidia.com>,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>,
	Thierry Reding <thierry.reding@kernel.org>,
	Krishna Reddy <vdumpa@nvidia.com>, Will Deacon <will@kernel.org>,
	David Matlack <dmatlack@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH 5/9] iommu/arm-smmu-v3: Remove CMDQ_OP_CFGI_CD_ALL from
 arm_smmu_cmdq_build_cmd()
Message-ID: <20260508160236.GG9254@nvidia.com>
References: <0-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>
 <5-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>
 <af2w01YI01Av0Wg5@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af2w01YI01Av0Wg5@google.com>
X-ClientProxiedBy: IA1P220CA0019.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:464::6) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DS0PR12MB8502:EE_
X-MS-Office365-Filtering-Correlation-Id: 094286ec-b406-4ec0-a6e8-08dead1b39b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|56012099003|22082099003|3023799003|18002099003;
X-Microsoft-Antispam-Message-Info:
	az65ZZQiTw2Z0f7iD/2gQ+EbO9A3yoYDM1FbpFgaJU6P1XqzTDz6PpUuGDyd+Q+ExpBiIMYRxOvjBmUDt+DrxVBxlW81+MQP1BvIxtiy0VMzCgLQPp9xcIsSaAA0B4bxjlDsTrlLBG01Ri4rzI6HefufIufERCqs+6setHrVSYLs4u7v010RjUBT7ePwBQZdWigMxuB98YzIwDivH60iPJ+C6wcjRS6IGEbB+9BCnLtzkSLBlzYxP+so60X/pyiBKgsqdp6FsSahcj+DuNdSx/kpxyBeTRQ/8afQj2RaHMD4NrFPh733r57SWPOzEn3xLeLd8/wglhleVvsIdTdFhmfbApegsy7+1EdAN1+tXWu7CitOxaWTUeSHdqTOZSSDC4pn7GxDBy3YFtMP45GBcRV9gT/2v0Kgre4rw7Nw1g7NQQg/omIE0mYK0/JDtq1HYFdbsARKBmKu4dc2M+ny5ENuxdyKBpakViDp6uWZcXgN66ItsxHzC4KJaHLKIr7mqZnkLEeHehfG67mWPL810WbtNdJpv52HjQdxjVB8TSskUyf+RIQqTcAHuzPDJmZDeHQ00cyMHrzRZ223yU18C11JaXYbR8z1ernvt4+2ASu2ExW8RrHbQxOwB5daJ45yUipg0o9PRyMQb6eaNKOqgUgIh3k01O+vNcXa03LGt0YWsjQE7n37sj4gfEuv0MeY
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(56012099003)(22082099003)(3023799003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?l08SfGSVvhdvykxz3cQEHqsuHqdBHGFDAylLK/ruy+CQYb6KE6XPTfd5eePa?=
 =?us-ascii?Q?VmCp72CFs9mX6QCTxQHKOaUaa4Hi3HQxL0a5ld+70t7d8KXFPX3415KXD7DK?=
 =?us-ascii?Q?aVd3QQf3AwT1CF2Ia0M+Nm8dmFxsYuKYc8tmBbmA1xjxFFRLza5qhwymZSmZ?=
 =?us-ascii?Q?6W2C3IUUA/pVubCewq5aUkBmOU3EWfjoc/kgJjQQrwjoiT4Chaz3LrLMRFDr?=
 =?us-ascii?Q?aOhuiIIuwNHApOnoCQuTi5HQtY0iqIZ9DNBga2koeiKPUNMU3UI/ZLHiHnBw?=
 =?us-ascii?Q?lO5aXdXPY4d/oKFBPNBCLQ+K15YhwtzUtw+dyl/xDAxnRCRDlbJH+iCwH1sa?=
 =?us-ascii?Q?QE30lFvAZ2q3C0ubYoOcGZsBSC6z+XNxcjBkg+2dNQ3xQPfnE/Dn6y3YP9eX?=
 =?us-ascii?Q?3JX+lErZkbRKADJsErwjpCnEWVyqd3NR8PAxc4jaqDRv1NmX+GNNW96Wi00h?=
 =?us-ascii?Q?JheMM7i2bEiayn1ZOHoxwYqMYEr8w4Dd0PVoYfSZmGCkWE9XThDiSYv5iYkZ?=
 =?us-ascii?Q?BUFWRUJRGfYIKbrFHA/55cVWlRGm48gXEyEbNGYGS9ku58uSqxd0LH99KAaM?=
 =?us-ascii?Q?fcw7thfFK+9tX0tVht6W8G0MfaNDmIDo5sbRj+R/ukUyB8KzGirJ1zahmtT/?=
 =?us-ascii?Q?SExPm9HJJp1McVniwb1nfZx0O8g0fseV73qpvansyy6SHCOUKE4BoT4XT6YS?=
 =?us-ascii?Q?3flXNP1bgoD0EgjFzZgM7Wsab7iKNY+XTOrFUK7i+At/rRp8YkZbRJlIOu4W?=
 =?us-ascii?Q?fy5OhIVxKSYQ8RJmdnlsqSyxD/CLxyKkjme02a2isFmjZKuGpKIA9u9+aks1?=
 =?us-ascii?Q?78nKyxK24l+cMQ6H6hK2cJ0SEBSf1e2jSWAQyi+k6pESN1bZG7JTbTGTPEv8?=
 =?us-ascii?Q?fAj6/jFNr7ASJdt1Quvi3ZnfSe10EszYLFWDsJT/Llnf4eNqfFmajP/WxfmO?=
 =?us-ascii?Q?OcMIte/vE5Ui+64t9oeWjKYWf4hzslicR8mBvKLMBt/nx89yQNzXznHPmF43?=
 =?us-ascii?Q?GfJCeKOcNFYi+UL4e4ADHprRLFbbNHX2GbY4+hnHtE0EJ6cYfM4zJ6j6S1TL?=
 =?us-ascii?Q?fuoMHwLz5MXKBNTiTwZZf1FASe8vMsrl/ds8IIlhArNpzaFnnCpAM7GU85Vy?=
 =?us-ascii?Q?OybbPs7WiruO1rVi+1VLR85y5jnMkm+1ml6np0GsQVAauMAK1AH0J4WvIHvA?=
 =?us-ascii?Q?lNWgOTf4+VOoCU0VQr8CPHDtHPD36X/2jqgrA/k1zHqMUuR49psGDTWMkx4G?=
 =?us-ascii?Q?Jm5LEYCqlk/e5r7FK3Dt+dWyPN5zx5wAELAQCx3Glkwaq/BmANZ9lrehUh9G?=
 =?us-ascii?Q?IMM3OMhWH3X7BNjVUSll4th38GBZVusSgWVm7NUIwT9BeZBY6zcAcNC8d3W4?=
 =?us-ascii?Q?NzXxQzDglCmrzRnrKUzsALxKoNj9MO76ifb315gbl7dBgtbaBYlCaPPR/jpt?=
 =?us-ascii?Q?Y/H6xl1TC+m1ANtmr2+nX0cgCUmlyajv7xy/A0plMw8raFbkNdoPDtJBfVB/?=
 =?us-ascii?Q?Siup1sdBsDB3G3JZHNtP4UOX7ysAJUhpqY4E5sZqhXoZix6Ifg4iqOOiCsMO?=
 =?us-ascii?Q?XAJ0Ija1yzcFdJpY5znhxE1ROxUTTU2kXjHKrtDYJL18ny8M8eGcPOKAa/u+?=
 =?us-ascii?Q?Mb0Bg61map5tRr/yg60Dy+kCB7ILgDC+2I01g5yt+fiOOZssUJQuiBWV6uVZ?=
 =?us-ascii?Q?kHBky2EkCd0ezT42rc1+dPY8QQf6MmscGhZx3sKLoF/9WqYH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 094286ec-b406-4ec0-a6e8-08dead1b39b5
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2026 16:02:37.9204
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pGpDGGeuGVlaz+wIfqF46Mr49rnBXdkCUL4NYFBqsk7FyO5yK0QTHPuGz15O64Ii
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8502

On Fri, May 08, 2026 at 09:45:55AM +0000, Pranjal Shrivastava wrote:
> On Fri, May 01, 2026 at 11:29:14AM -0300, Jason Gunthorpe wrote:
> > Nothing uses this, just dead code.
> > 
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > ---
> >  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 3 ---
> >  1 file changed, 3 deletions(-)
> > 
> > diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > index b3ef001ce80d23..ef0907b1a2204f 100644
> > --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > @@ -290,9 +290,6 @@ static int arm_smmu_cmdq_build_cmd(struct arm_smmu_cmd *cmd_out,
> >  		cmd[0] |= FIELD_PREP(CMDQ_CFGI_0_SID, ent->cfgi.sid);
> >  		cmd[1] |= FIELD_PREP(CMDQ_CFGI_1_LEAF, ent->cfgi.leaf);
> >  		break;
> > -	case CMDQ_OP_CFGI_CD_ALL:
> > -		cmd[0] |= FIELD_PREP(CMDQ_CFGI_0_SID, ent->cfgi.sid);
> > -		break;
> >  	case CMDQ_OP_CFGI_ALL:
> >  		/* Cover the entire SID range */
> >  		cmd[1] |= FIELD_PREP(CMDQ_CFGI_1_RANGE, 31);
> 
> CMDQ_OP_CFGI_CD_ALL is also present in arm-smmu-v3-iommufd.c
> I'm wondering if we should remove this from the iommufd.c file too?

> This op code seems to be unused since 5.15, if a guest is running the
> same Linux driver, it will never generate this command anyway.

Yes
 
> Unless we care about Guest VMs running non-Linux OSes, 

We certainly do :)

And who knows, Linux might start using it someday!

Guest emulation has to cover all the commands a guest is allowed to
execute, and that is what the iommufd code is doing.

Jason
