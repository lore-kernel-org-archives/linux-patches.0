Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011023.outbound.protection.outlook.com [52.101.62.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01CBE1B4236;
	Tue, 30 Sep 2025 12:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.23
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759234328; cv=fail; b=YC6/SkAE83al7DMnM1ERrvz4McEBiTSifFV6zwptptxU+t2pTbdSpBX623F/lKLsxxR8lnG8fGFcyNFRqtxKYXnq0xeFWLDL6lx0BI+yMcgAndCw0I2nWEMCY7xg6GieLmE0cyiBNYB5hk20MbZptrl50rlMdWIB+GLYRkdvdlE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759234328; c=relaxed/simple;
	bh=aurpTO3nKpV9T3eRa+oav7g7BGAXig82rcGqKiarMyw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=gD1AsvgAppy2Q6mb+Vzd4l6GFTZCOPC+toFDHmlf6qPyPtetnWSwE8DYuhT5JdKo8xRPnrmFvPgbWpJkhpCOOmzLo0+OKTrEEuKCm0AENuK5Iu8C51nYLmaUlfyWoUV7zL+144RSJPFpdWoI7F19eJGAvJsZi4/TM9rg49EhIfM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=pAsxJ9PM; arc=fail smtp.client-ip=52.101.62.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="pAsxJ9PM"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NONAZnMVAzPkv7t/G1DphdFOzylecf2YCpx5fsX+Cufky1bMKZW4A2cnT84S2H29VOc55O9TxDBJcfMRTAnShEE5vTANd5lb3v7T4yVqhr8+7r6Bis2UdGyzPfsaHlNkak5BaaKbAWZKlBgvqfiWlemGBOz1JDbTOBI5BXceBvUfVPxiBY0Tlm7fAYfQk2rAvPuYtl+88E/w24Gbs+aKvtg3tf3Xm9L7oYVBrQtL/+cpLi4hfUC7nTb7qeYtHnS54hdY79KoY3rG4Qv9QPW7qpcFXb/73YMv+Gbm5wvagOW9EW5BIZEUZJOnkySz24ceninL8+6CEU4f10GEut1PVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qA7+KA6YBCQvJe8UZEWifbVQa46grQisYFE92UHLwx0=;
 b=gq9AUpvpwLWsT3GVoONOD4yuameEgjZs0BDgMwYt3gNaClguDaF0y6Jyn+gtl14rD0GQOlLtgeeVl0S7pInCbfZJUYoDSl7zSuNwNqAV0S9MZT9QJPJIN0l1cQfCRlxPUnHy2MXgdzVDVJpLacYWuMNWH8Yv9q73oov/mLtOWnMN+xGpwLp3GtC5HxWJIvYIGqg+Y1nUWBvuWLSO5WQc5jor32UsZRWKoJzfoxMah1KpyNHCCc/lCUzvlQJWxTXvzYgRrfDHiI4N3uUGEmB+ueiz7HXbQ/wk6DdYqyPjC7as7HBzwi7OBELPArnFL1WdQ2ItWIGwbWup8nyLAAYQjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qA7+KA6YBCQvJe8UZEWifbVQa46grQisYFE92UHLwx0=;
 b=pAsxJ9PMgxR6g2P/X+MNcnyykZeAQMQiz8qX0exk2AfXOYtlSEXR1CoIyPBstrhMq+V/LQNSzlHqUqp0b8KY4xhkxc2zQ8tcrCSzjRKM7SUdtvEna7FWGPUxkrPbzIbh7SLo2jmkAcN+cbIHj6558wiG1qlkroiMY/dwHK86IR8xiA1TD8G3mb+XDI8Vi3M/u1BJGMAc/vqpeRDLej0qr4wWvomOGLkR4nbo87CL20OwfS3dl1CeZtiDXMvu8hpq4VwR4LkNqw7sSkwdEl2dvCPQfIbYISNCCirLSlDcYjzw8e5xwbZXKkSRVbexeLzivdGm3F2V6iMe/aq+KLvdpA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by MN2PR12MB4045.namprd12.prod.outlook.com (2603:10b6:208:1d6::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.18; Tue, 30 Sep
 2025 12:12:02 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9160.014; Tue, 30 Sep 2025
 12:12:02 +0000
Date: Tue, 30 Sep 2025 09:12:00 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: will@kernel.org, robin.murphy@arm.com, joro@8bytes.org,
	jean-philippe@linaro.org, miko.lenczewski@arm.com,
	balbirs@nvidia.com, peterz@infradead.org, smostafa@google.com,
	kevin.tian@intel.com, praan@google.com,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH rfcv2 6/8] iommu/arm-smmu-v3: Populate smmu_domain->invs
 when attaching masters
Message-ID: <20250930121200.GG2942991@nvidia.com>
References: <cover.1757373449.git.nicolinc@nvidia.com>
 <d3f9777e46d531273dfecb54d69725428cdef308.1757373449.git.nicolinc@nvidia.com>
 <20250924214215.GR2617119@nvidia.com>
 <aNrxjkUEEUzKU+za@Asurada-Nvidia>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aNrxjkUEEUzKU+za@Asurada-Nvidia>
X-ClientProxiedBy: BYAPR07CA0008.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::21) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|MN2PR12MB4045:EE_
X-MS-Office365-Filtering-Correlation-Id: bd18493d-50eb-4c5f-2cfe-08de001a9026
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?PTjcwUazc1QwHLiDko7kd2CJSpbLvw4OPhJ4if9s8jY2/2mJ4swwI6pFirkg?=
 =?us-ascii?Q?IbpLFqyDv2VkcLKmc5urRulrbcfKwAfYmWksL4nDNqX6E4BBZer4ORfeN68x?=
 =?us-ascii?Q?eHP3u7gSIZNreWEZaj4zlCH/vQfFz8NxkZpUl/q1+87jzp4L72roCj9DHlt+?=
 =?us-ascii?Q?4YL37/hoxnx6PRFoaV6ZnMxwqplXm5PNgC6NI6X+Wk5AdVt1UyZdpPUxVCrk?=
 =?us-ascii?Q?JjdNcJKx1LFSRxb7wTbmCqCMkqsXMXbGaijyHpvuGnwsNdRa0cvN3aTgf3Dp?=
 =?us-ascii?Q?W8FF+ZCcmRB0ecMJPBWdq1i5Rn/WxhGOaAud/7/uCcR+dUr96upu3i0oHwLv?=
 =?us-ascii?Q?DRkJGX+c3y86WXACg9nOpOQT2FwXeHNjjyBRCXJw1ITGTbeQPbA7cHICVZpy?=
 =?us-ascii?Q?vlhHn8sM7lvUocspGPeU1yHw0xr+dkzw6075zxkNXlmJ/lefb9eq04YmclN9?=
 =?us-ascii?Q?WwOo30SGT8TCEUA/Do1vyDS00LUvNLBShCDW4zXAqnirl7lbnhunu98ouAN4?=
 =?us-ascii?Q?F0M7OTvrE/Uon2rpOQlP60hGKE9izhu0wtLNJGYLFvLsaUpRiGNXQe4StCmA?=
 =?us-ascii?Q?AUNnl90Q/ynxhohPIkfNRe/FMVW3VT3kI6jGNc0c9t7EdFkEvwpbEYcBEepK?=
 =?us-ascii?Q?jky3A75ilNTCqK2YP5vDm6YFVy0TxuULh1hFZ4iTpfIzF9ABN4s+swyrfX3i?=
 =?us-ascii?Q?XQ7HFpWTlNajLj1F4GFBA4ibSc9IRpUY2SEq6wKUNUaZNiNKZETpQDUET1es?=
 =?us-ascii?Q?l2Yxkq/iIwOmbDuW7PFQoBLe/sECTY8RR9RmwCTqv0YDNCVtxMYVx/gm3Xbn?=
 =?us-ascii?Q?TKur6vdS+HVgdWALZcYCz5w+u49tLjNp5CSHqCfWUHLEWFo8zYAGMsrdrPnK?=
 =?us-ascii?Q?Lztu0M5v4pwxPi4J3K3za0VGGTs6tJvaluzV7e6254a73Ij4X9iUQC+u1TcC?=
 =?us-ascii?Q?87/COqFUcnF1FSD29kqlTxTi68dHV+HqqhXtT8XtmZ5tsiS6btN+wG9Du0fp?=
 =?us-ascii?Q?JQ5/WdaRcp8EpYIuBUKrdLIIFt/BUycbNnehns94NEZBiay8NM/d8xVhaS1n?=
 =?us-ascii?Q?r5am/Gq6+gcKaBgowaVzs8jCh4gblgCEugS0Jf65V1aAu8b72K38uXNoFcTW?=
 =?us-ascii?Q?nxmW5/Fcrah0iywbr4o2oad4RJf4halZdvsN2BCkyTYJf7wzO5sSfxvgNlnd?=
 =?us-ascii?Q?hs+62D9dj1xBdzC6QhZ9E0p39/Fsleyaf2inK4vPw6jQtzaLM178m/XeQiiy?=
 =?us-ascii?Q?TUVSG7Ir53vLysMMdYFX4Nqy0RCr4ekP/R6p5bjz9YthsolPCKscUW1BoSXB?=
 =?us-ascii?Q?SdlA0OBKQIkzwAl7+0v8ZLYy3Ti2qMr+hs+yzIaBOY7e4EJcdqTVAOETqCWs?=
 =?us-ascii?Q?tetZI3S29gpKqJrczFFIxWgXKRScZ4gAph/fFhV1PC4ig1ImJ+7hyB9VUeSl?=
 =?us-ascii?Q?mgJprrSI/rWjQz0iKWXKOC6/aOUHDmWS?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?URDSA9FbL8cTxPVp4151+4oVow7Y/hlPAfHtCy5Ch9jge3EkV0tW0U9y3utP?=
 =?us-ascii?Q?qYM5RshIm1aTkbk2Hh1N9v75nvTgfsvrYNFxuUDy05BJXfeLPhiNEhy+LmOy?=
 =?us-ascii?Q?Xla97aWGjSK6x/wQjZuesnpFQJaOQb5HRz8CgPrDCgE1ZEPoUmkx+hvG0I/S?=
 =?us-ascii?Q?xAjrEvxKO3E6r/5+M/ow9ZEqroS4m1LYXBBo5jtSxaxTeKbbotsyjI9ws2li?=
 =?us-ascii?Q?Ww/u50FeLmwTkg9Xqynzuxbc7ulqmgPLUC7CuMlnArpGr1xvIvsk83xGDhEu?=
 =?us-ascii?Q?nr8VouLsfjRxSr2qh/3udeKOK4F2qZWkPnKHyaLBMRshIBWUCUM1uWevMPLj?=
 =?us-ascii?Q?o5Qo21aF1DbGRwRk8ExWDPwkrphX/C+USxQCPg1EGX0UipidgNHvOJnZIbyE?=
 =?us-ascii?Q?/SKf9JxRs3hRGRGJUm2HBkGUr7J2Ug6g8qYfLTT177w1FyFNlvZRSvqBtJrN?=
 =?us-ascii?Q?9buAXdOQ+AFpLHuCp5kHlPBIElYx5uv3AZ4QqoZ42aGCgeLLtfpf0bpw8wdt?=
 =?us-ascii?Q?2/TThywZZIqy6P0/hURe4aWwcAC+0Du6I2myYdReeYDj7qsBucyfjhIb96GW?=
 =?us-ascii?Q?gip6sLxha9vi5Kw08XsrjDShjfdehQqivcWOyN1p414zxm6Xc8tbNb401dkR?=
 =?us-ascii?Q?eoG4EdWaeDG0xRc5Cs57M1OuHaM4vUoR9DDRZmoy280D6vyFGjWUWpD7bJ1A?=
 =?us-ascii?Q?kdRnC1pZ2ktIHz0Ul4zqvPNqLjjt7COiPQptcF7ap6+0dfDIE0zY/WmE+1y5?=
 =?us-ascii?Q?4UUTX0ov8mBVGWYJGMLKcNt1ibK70LI3MHAlZDnVzQmZAvT3h7NgUVOOJ4He?=
 =?us-ascii?Q?jgcMM32wozGc9V/DBlmx7AAxxAWh7o38WdZNHP9NOCGCGDjtKmACip+Dx7Si?=
 =?us-ascii?Q?apjyZoFI9l/A02thkmF7JWsqst2vONnZlsFYF395iuciPvw6IhVBWc1JuQUg?=
 =?us-ascii?Q?Rwo1vCtSnqjsvav/joRDFACJdT5Xl3s/IZoAUvCoUAKEQTZRya4789oPJNAZ?=
 =?us-ascii?Q?HxW2cVu7d4+ZlTpO6GXK7hp2iU5/H9zjx1qfR1ZXmEFnMDVCLul7TWnEHewN?=
 =?us-ascii?Q?X0KN4zywTaQcZth9uJHDwYpCNzUsU5XtLB/+5mzXWMQfpG/68+7QiR6BZ3th?=
 =?us-ascii?Q?Zr5VIAHx8DEh1mHLT5DCZkr501mcNrLpLeW7YVuWvfKke7HRbxxqfPsQqJhR?=
 =?us-ascii?Q?7mG3twMEgQHf5WsIECVr/C+gR3gP7rDd9FT0mFGWWiPyxXr52qFmwlt218r3?=
 =?us-ascii?Q?xfh1WD7N+b1CEKRYt7IljOMN7A5Q8aB+175wY/81supwBDVZpQ5GK1+j26y2?=
 =?us-ascii?Q?+H/B73GK7G136PATnc7OMUx5KosgVrkuntdRetn1KiopmwrR92iGzFtxE+Gl?=
 =?us-ascii?Q?w7T0IY4JUDRyBdEbSegTe5/bEJ06K6wKexZbknumDoCUk6rxN0KSrKp4VSRo?=
 =?us-ascii?Q?llgT/2xNCRzQJp1fbSQpmmlcACCiKVMYlDG5bYmSOgMORL8Rx8ziEmZT2s6S?=
 =?us-ascii?Q?5A695b1caiix/1yE7IDoFYNNOBmh/dC9iJchlWf50AC8vViDVFKd2cTt/N6A?=
 =?us-ascii?Q?hMK7UvBRP9SFToV/FFx1efMG/94HfOP4Yzx8N0yc?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd18493d-50eb-4c5f-2cfe-08de001a9026
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2025 12:12:02.2179
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b8R1iO1HreATwbpYKFhfs55WMMxnb9PTY3XO0Gt1ntZ7nl0Rj7oOpa0Wy6xfOo+O
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4045

On Mon, Sep 29, 2025 at 01:52:30PM -0700, Nicolin Chen wrote:

> > > +	if (!new_invs) {
> > > +		size_t new_num = old_invs->num_invs;
> > > +
> > > +		/*
> > > +		 * OOM. Couldn't make a copy. Leave the array unoptimized. But
> > > +		 * trim its size if some tailing entries are marked as trash.
> > > +		 */
> > > +		while (new_num != 0) {
> > > +			if (refcount_read(&old_invs->inv[new_num - 1].users))
> > > +				break;
> > > +			new_num--;
> > > +		}
> > 
> > Would be nicer to have arm_smmu_invs_unref return the new size so we
> > don't need this loop
> 
> The "new size" must be invs->num_invs subtracting the number of
> the tailing trash entries. So, arm_smmu_invs_unref() would have
> to have the same loop validating the tailing entries, right?

It doesn't need another loop, it just need to record the index of the
last valid entry while it is doing its own loop. If it reaches
invs->num_invs then that will be the new length.

Jason
