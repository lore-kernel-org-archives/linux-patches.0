Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012068.outbound.protection.outlook.com [40.107.200.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FDEF2D5926;
	Mon,  6 Apr 2026 13:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775482260; cv=fail; b=SVu8WZBC+pwp7EYhn7zKuVByrdWPxEGhcZeqxH3t60vhVsnPOQ/o9sB9ifQx0phOeMku3poOW8EehmS2Rfp5N1SkQG41zXvU58wXhg0qf+OvjSca0hITH/Zz8Y8+1FKnkkZmyaktxOkalk1vgE4FAOipH9FBEbEKB5zCD5DeOzc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775482260; c=relaxed/simple;
	bh=0CLTmwKGJS4sblz2SH7BETJkDBQ9jXED5ZeYmn1S1Gc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=GjTp9buibIPCyz0fZGFohoqE5hVVTNoOmVOgWLUJyojBfD+7/AbsyX3isVjP7ITXw9wWk5/IM3b0gUtwJ0UDq/c0tU9qDqmKGpAsD0luy8faJ96y255G0EBhPHUiWTFb27RZ8UPT05z6mXEwyyPzoTC7Pn7Q4YaseHQQi1DZ7oc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=LpqPXfd0; arc=fail smtp.client-ip=40.107.200.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="LpqPXfd0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qGRmNANWGl3UM/gklUB2cwc12+fcklw2aPWuA0XcE+oNNvLY3aH2Qqh4IeOU4NVguszN5gdNIkZ/l5Gs/fR15FXK/qN/r/nxxsONtyvrESoJt+PZ/ZCPXXn5c7xMnc/TAVF+uYvrWFlkZ874GX1ORKGckSlJJXvTD4JCFl2UcjkpmJpX8NavERV/jz7FoKod6JE83uER+5fxbs0Jl2sKES1oLVTURoiH+RmpcpEQ9vOqg6pZCFTLYPBQHP4PQo7PhJoS7pEZYuA7aNlrXSVjkUw3zNgEp6vUU8nk9vELoXFSjlOYN1jJrmTxxS2I+7BLY7SIlMQmTQE4NFz6o+Rnbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KR8IdsWlQgojrG+zQb7o6EdHXkYTYVFnmiy+VcUXV7w=;
 b=l0Jyl/P+8px0KZO972KtazSOHCSKGdSm0PNPfc8kD689xF40aTlecKK2Ej+cKJ3njEZMRMJ7jtWA29UEm+3+KdM3YwetTR+4in3q76WvHsyX7gex+l72Hjjq/wDyClokp5kH04UFkLwaLc9vNBD0VhVJ4w6s/2dcpfaKJw7jUdjN/Zo+oRECMRqZtlpzhxJoLmw0DgTaHKJMOEbHrjsE42l3BjciCNaOm6/LUXRTwsqO18V7ibEiqWFluXDH2XLhWoNqM7quy628hXmVEHPNPYNNjNX6p92rU68Yz0obrX9NJH5WK7qv/EJTAUiZq3ymAWqrIC/zSHZaxfm4Hz249Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KR8IdsWlQgojrG+zQb7o6EdHXkYTYVFnmiy+VcUXV7w=;
 b=LpqPXfd0mjB4Hxt0778rcLCwsqdGUaubJwiGZnB44c3QeHDoo0eB43U7fDNr80y5xTsEXGqmAu05z+kK7Q5YUs6OFSr+biFAfc43CVCQAS/5ibVUIDAhwRZBnZStJr3httYJB53qgAPKkVnr1q4t0me5mPzRxKpa7q/4KfnUnAcaapxpchFDclouMNcH9ALfAFb8vLs5vYbC1vBPyquBdmCcbR88Xz2UImcVvtu9fD0GZll5N8Acoq5ooOVoHgDkmBViZnGdxXcj3+yg6JKR/JbeAGQuqOy0c12F+q+l/7vBP4LfugFsfl3YFhAJeXmDqF6S/21iBtSIlQUzTSa1KQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by IA0PR12MB7529.namprd12.prod.outlook.com (2603:10b6:208:431::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.18; Mon, 6 Apr
 2026 13:30:48 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9769.017; Mon, 6 Apr 2026
 13:30:48 +0000
Date: Mon, 6 Apr 2026 10:30:47 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Wei Wang <wei.w.wang@hotmail.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>, patches@lists.linux.dev
Subject: Re: [PATCH v2 1/5] iommu/amd: Simplify build_inv_address()
Message-ID: <20260406133047.GM310919@nvidia.com>
References: <1-v2-90ddd19c0894+13561-iommupt_inv_amd_jgg@nvidia.com>
 <SI2PR01MB4393C1FF5BDB413E68BD018EDC5DA@SI2PR01MB4393.apcprd01.prod.exchangelabs.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SI2PR01MB4393C1FF5BDB413E68BD018EDC5DA@SI2PR01MB4393.apcprd01.prod.exchangelabs.com>
X-ClientProxiedBy: MN2PR03CA0024.namprd03.prod.outlook.com
 (2603:10b6:208:23a::29) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|IA0PR12MB7529:EE_
X-MS-Office365-Filtering-Correlation-Id: ee155cd1-62f5-4118-40bd-08de93e0b6b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|3613699012|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	wdL3D7CVkqwHCLO2jQlB8aj/2XKuLDceJ8dR7ZWdcqJ1tVh9/x3OPRpRmz0a3Q+SD16KJqQzu2SxCLGiF0nJ4pwGbzMTc5V55OYB9ygYsKe6CanRZl+ay+oyQt5124gHD3TgLuns6gHb1F8ITj6Rp+eFqF7u06Ze5LchpI+/CK3Oww5vTPlEM0MpS7RgNU5oJXB/t/qS754DkrDD09GgfrcHk1iUSTxlH+o26qj7yRXYHj2VhzyCticxwNP+Qyk3E4YiNs6uYSCyJgGylSvBJszydY0K6Hm5fJQeGYw1mw+4FlL/Sz8x0Lm0ONGCg8xEOLD2tijMrAHolxpwOHpfvHubrno4xQqAXd+M1RxgU/r60a+d46i5nfBiFa0ReNLQR9jhvLz9ZUwjfRnL2zGGJRM4GQgrrGB8mBLu9QM6x+9XX1zkQCImfjPwPDVWIcKhGUHFqLle+MrowFMTYMETV5xm2dtSgOF3lPaPnYmYpDLEkPXyTIJY2D5Wtq6qFsGRd1FOqGal8T5uHNbLwl0BzRfDzHQNnTLT46ZVsL41tmo1K68e5GFs6UjIBqc7roLEJ6Mp/72gzFDg3+57di54TZjlcBjB1AbsPcqZ8lmDBdElN59CLP/5ZiabmaD+u8CFHbUHlEqifYqrpetS6jrMTIRdAbWqfgMltR8pgu5HWQXwMsWrZSPhclWppezcUhVIrrv8ASil2c+2inY2bLY3T1KCAH0DxF1yniB0j0Xdx9iPwkx2A1BpDFmyRG5O7fMTQ1mPPCX5sojLngY/ENvdWCJ+KqU8s2+Fa3ZvIn5nY9c=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(3613699012)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HsCCJW+wmvTirTeWkUXZfQLrXYIZ1XbE8pbhCO2ygGn8Qp2FdMh8DYNNp/l5?=
 =?us-ascii?Q?o2peQ0tnKphGO0j/ekBhJRCgsr4WySbJbcYvksVqrbAY8WtjcxZzoo6atoDG?=
 =?us-ascii?Q?ASwRIrmXRNaZoGjmAxpcPcXmkJWBzGGhFXf42C4Ntjnd56lrYakkPIbEqwUK?=
 =?us-ascii?Q?+KM1v1TSjRfA1iLkcMBUEvMSbtL5rCKoK1kg/GLFol+wF3d9Sko8JfNtwH2Z?=
 =?us-ascii?Q?l7om5Ni7bw6CKNlFQdPcKTlppaCdombHjaU1P2YdnwgPcv8UYt4xNwvsMoFU?=
 =?us-ascii?Q?oOBjw/59DowM3crugYmYbtPpAvDTIBPGuZTYov2+TJNliVM62+rXbObyBknC?=
 =?us-ascii?Q?UNNdIqxsXr9gznjG1aVOpWzRmChw7OxkLl/xAdoNsO3aTApuzyZ90H2T7zYY?=
 =?us-ascii?Q?QdaSkO/FCeSzVWDMu4iwOjX6PWCmXBRAoa08jHX56Jx7LcIQXPRIXAMZKkZ1?=
 =?us-ascii?Q?qJRWbZvIQtpw3n8NdUIv61OhP22DdexuoLhkxs8Dgp+OQh5teDTUNTvUgO1T?=
 =?us-ascii?Q?XmFX6/jI2pjT4/Vj0V93F0kFxcgEKfKilVAyjUyoBxWzFJEvImSQy5Sk+h8z?=
 =?us-ascii?Q?tBUkpUP6lBxU8wC/LaA7yM/yM3lOtSFEqRW0+tNkrkWzfhHx03AZ1k4Hwm0Y?=
 =?us-ascii?Q?qrQDx5/CEqUmymvhGLOGRBoKqPQMR+R1nzAdkvJzFTGO3PmP1lywA09otzqY?=
 =?us-ascii?Q?kvHdI/6jY+sezKAQvkquI0/xx3069j1ZW6+Ey+uPvk5JLBDyhC8FrNia0wcZ?=
 =?us-ascii?Q?/nRKPADSHO4BoEYTxwW4HFpOGBDqruCTenmbW6F1XBmd+m+aJgJSIKyGJ+hW?=
 =?us-ascii?Q?zcDjaWAu3M9X69uvjgGtcTuJ5yx+LoseFZsSzyUQnflTUSe78iSSU968SvaE?=
 =?us-ascii?Q?LWOS6TVgnRY8MYDxgS9keOpR9tqXLAj3UJIttBiUFHSQPdFnCN2IQytgwqBr?=
 =?us-ascii?Q?TfqRWXTCx1iAFseBEIuD1mbPKLyZh8Ay9qfwAVYhR7vxOLY/dzbdM+OqZYc5?=
 =?us-ascii?Q?leUmBignrLY3VibDkpTyrd3DDz3CmdaeKzLjvkaLlEXlgwzPTp+fe7ZDJogD?=
 =?us-ascii?Q?js1lsVtUW+IpqHPDXKW7aV8gclwBP/Qj1fUL66Ymk7ib0QvqBTt9CPCnlqR0?=
 =?us-ascii?Q?BuleEJeZ/n+naFpBpcRczkOqTFSARNTCiHzU+cdB/kXq4xqtHv1E2TzgSPnE?=
 =?us-ascii?Q?8krRwos8mZHV71OpWGMX0KeeWwgZUo2O9wk1ALqff2O1taL4s3SCvAEo56S3?=
 =?us-ascii?Q?SZqQjzMlVkoKB2+lsd+wb4UvqSuvG667qSXJ/RgNVtS6iuqsPODohGwaBpoN?=
 =?us-ascii?Q?1L0I1eziG255nT/hkBsT9/5cHili0w3BRJSrgZ3BaZ4LAq32Ci+spHllfWd7?=
 =?us-ascii?Q?gF7mK+hINsm2/ovUF9wiGilm96fPEdf2gpuNmhOwdn8Wg1BSpw8UCm6a3sIH?=
 =?us-ascii?Q?l7VusXkdFJ2WiM95uPvkTKvg3Ps8d86UVn2jkE0vgsXLHR9KIbTsAITpnzBm?=
 =?us-ascii?Q?NO+s2+Qj7G+vuu7xRSIeCCsMNHqiyJubu9Yb/x69ycdx0LsAYWaFy8VlR4kI?=
 =?us-ascii?Q?6XA39HfmoburhX9U3Ax+Q69Y5Bk49Om/L/X2+kT4VhbgM+ODCaR8YOLi2QFs?=
 =?us-ascii?Q?j/PzXo7HNX465n3nED6o6toPZB2IL47zvfs+q1vBDLaYvgJMgNINWW0nvyCW?=
 =?us-ascii?Q?QsmwODDMuaXbAkf0WUCsP+oZMQ+5coMPZf6722T5NQgbzIjX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee155cd1-62f5-4118-40bd-08de93e0b6b4
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2026 13:30:48.2375
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZO/f8AB1J7su9N41WQAthWdhzjTcbypVVMRGpzidJBSqc+PiiOnU4mZS1RRb9ySc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7529

On Mon, Apr 06, 2026 at 09:18:19PM +0800, Wei Wang wrote:

> > -	msb_diff = fls64(end ^ address) - 1;
> > +	if (unlikely(sz_lg2 > 52))
> > +		return (CMD_INV_IOMMU_ALL_PAGES_ADDRESS & PAGE_MASK) |
> > +		       CMD_INV_IOMMU_PAGES_SIZE_MASK;

I was looking at Ankit's series and thinking this is slightly better as:

+	if (unlikely(sz_lg2 > min(52, BITS_PER_LONG - 1)))

So a ULONG_MAX gather will trigger full invalidation on 32 bit as
well, though it shouldn't be necessary it seems a tish cleaner and
matches how vt-d ended up

It is probably too late for this cycle, I'll repost it after the merge
window.

Thanks,
Jason
