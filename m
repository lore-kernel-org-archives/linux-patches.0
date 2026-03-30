Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010024.outbound.protection.outlook.com [40.93.198.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F5F34315F;
	Mon, 30 Mar 2026 12:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.24
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774872308; cv=fail; b=qfTQnExd7gUOMbTGjAQ2MxE0Xh9SaLQ4dGeFM8QaUpT6Lt0Pam2EVPnxDPAFLUzSlbfqFKqaE38byyqija8H1Fq10W2G1fF7JpUdoUvQJrtq0i5yJXAmuKD3YZFLpCdwtE0Gt5/iqWVFw2/M7YwtlLJpQLVQFw7ySGzMoukDg9Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774872308; c=relaxed/simple;
	bh=J3TRTkx7a/spmc8S1DJAML2plhayhWS0V8g2qXFXeDI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=RksXoDpv1hKCNlChi925aNQrC7LBozCr6s1Gzm41kJcOyaB0ZySx2IxPq5bejUibEtGpK+mhFc4Dx7RkDwjN9u8UakzHFFY4t22WAAbUeZOGag9ihS0zg29Oru4ATfhlJy7xXkWjP1IKZT7jFF3Z77RnfY2HJskNVmjhphr7dR0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=mvR0m36a; arc=fail smtp.client-ip=40.93.198.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="mvR0m36a"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aRWJvgihcF8ABzXIqIjPgj+pgplBByBaEE4HHThdhAB9o1rRDBqxk/vwGWM5O/xSilkhHWudukKXeM9tK+4p8UuI0oNiqN/qbNRYlY16JRXkLETxQdyvKoNaESSfSlJl76DV6w5/4mFTOlvzqgCkI2cGauTQLRR6qgn4e+RzXZoxns+ER45Z3AD7K6Mgr+ySkqptmU05pZTgqJL6jONAjkcFaEzUlQOu3Okf/0mwh9B+d+fjp+RMkaaP2sPPC8d9z0020QIUkU03+GgqtGRlDmLNyxZOhLuLFKPgFiR2rmyb40MUDlDWDpmh3tlEu6zUtfzUmEOyDprJNX8qBT24UQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RAKrwdRWn5HdfBomJj4RmJFAhBHWEkZRg5lgh3rdi2Y=;
 b=suRWYZyI42zcZ+YkBMr/x4WDlS27YkFzd4Y4DgkhPHyGsqmNqaxEsJqY+mjTFJUBnxiUcaXbKI38W7Hq7uMPT5BnQDuLRhUwkogNU6Ob86fXdrKYSTqvnA/6eciJbzECGvb+CRyCVpQBgoq8IL/J8ZbcbSjwF1xpQ0w91a9uhpeZKLD49j+c4heYdzjT0c5XI/cqlMgxr8LZtarKtAcphnbFq6NSb2WDA8aG7H9WBTDl99D/Cp5bhz4ZvivzDIRqgooLBNm6t1hZi9u04db9y6ADv3LcyZqgA8iXXXr2357E8majUUBMuscVkSUtw9UGFxtP2G9sc3jAFmw+xLOGDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RAKrwdRWn5HdfBomJj4RmJFAhBHWEkZRg5lgh3rdi2Y=;
 b=mvR0m36a5itizy4hoF6wuI7h7DqKi6KmJ5jbdkDZx6dULfRKIaTt6JgQF6mUoEocfNwvwSzS0V6x+0+jYShAx5T2cfsPXq9/SSniKA07oO1WxSdHehimvRrQ65OYTD85weV46pZqgymbXuPEgwu/Nf4LnJst3+8mWet1WQecd9LzDCUUtxdE2BdYBUevDJQAyJVjtBT5q/CKGwW3qV8i8SbSV3fvoV2g8DTf4kqquvoqTrt76jcuUSCbPHyHxwjDW2miupWKAdk1gi//EnN4KMr7LXWxLQftA7dsBCFSqMglCvXK6NFCaQHa79Q+JPg49SBsUyGFRgXwIGqPl0Z++w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by PH7PR12MB5653.namprd12.prod.outlook.com (2603:10b6:510:132::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.12; Mon, 30 Mar
 2026 12:05:02 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9769.014; Mon, 30 Mar 2026
 12:05:02 +0000
Date: Mon, 30 Mar 2026 09:05:00 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Wei Wang <wei.w.wang@hotmail.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>, patches@lists.linux.dev
Subject: Re: [PATCH 1/5] iommu/amd: Simplify build_inv_address()
Message-ID: <20260330120500.GC310919@nvidia.com>
References: <1-v1-a7b77c25974e+115bf-iommupt_inv_amd_jgg@nvidia.com>
 <SI2PR01MB439395C17C83A66A3E614470DC52A@SI2PR01MB4393.apcprd01.prod.exchangelabs.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SI2PR01MB439395C17C83A66A3E614470DC52A@SI2PR01MB4393.apcprd01.prod.exchangelabs.com>
X-ClientProxiedBy: BL1PR13CA0098.namprd13.prod.outlook.com
 (2603:10b6:208:2b9::13) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|PH7PR12MB5653:EE_
X-MS-Office365-Filtering-Correlation-Id: 1fa76dc9-88d6-432e-bc2f-08de8e549247
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|56012099003|22082099003|18002099003|3613699012;
X-Microsoft-Antispam-Message-Info:
	jwgK+XcrFXwE4HCVBzwmq7TC3PehPJsNczsMveM8pEp1cMGgGlrnPQ1hL7L8BuFvrmKJaZKNvUa1aDwteRbUxz4FWY0BkK4tob2+JIYcjDiSalLwyWsYRPFOCGU1akqmqPggWuQfFeHeiqPfs127OYOR10cywUszrIDPITMorwq6ZB8FLLd8uEeWOuhlv9IaEsjAnAtNp0PZhCOFMfcGK6SD+jIY1OIBZ/DeDEV/rTM14O2uehUpghgzKP2NT8zdmqU7f85pbP6h1U+5wof7X2csjXUip/r1YLGxoe2QwJeG44hi9pcpAZ2Y7cZIqDvxnPaQQZuOJLSI8Z+N/CUSVWQ5OFwOeF6heJD3UOqN1dnxYGnllKLZhIyYAvCgyKa/jSb//vIjWfO+CyseIqkhtbUkPkpLWgRrgeh6YfWnFN+arzxhJerOhvB/Mulcbym+yPbXqiIEjAxeCo8WvleiQHT4lNlpUOjxD6udRFRIvRciaMTp6WqnSi14UTd4C/uG60o6jUvUzylZFMD2o9YOaVd8/7V1vcDBKZiwhHWLrmIsaB7887ZsRJQQc//MjYZmrGvgpst4v1Ee8dUyOdPMvM0wjwiJJhTWFnMe5fB3g2Q9cxjDD0/Uzil65mjeTlmh8G9+Nqr/i9VBkJWjsn/OEkRJqiPiiL3kU7m1J8ZqXVnczk9ah3D0i9jyft3Wv3sKh8cPsn22WZfqB+D8F/aSjhNnTgtVX5GUE6dHsxWwFkNHXvlMi0rTwhtdaAChJkCAcAbBTLbbJ8uUceIkeGZPhWG0rLz9VrUOJtobP9Ectd8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(56012099003)(22082099003)(18002099003)(3613699012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NoREWAernOQmRl49fiZm8QycZEDdgBoMcC1BRzjiOuJDBw9CFIHnsmzkzpJ7?=
 =?us-ascii?Q?MiyU+UcDOA97EDxovlWKe0LHj8KDTIwAaqJbnGHz1H7YTpqDNzvOLxz+J7ch?=
 =?us-ascii?Q?Ii/pyxMZbE/iA3IHsri1EJ3mHIZ8KtkaXT6fiidnV1e0hE1V5lLPGUZjyO3N?=
 =?us-ascii?Q?yPvHyTELqYh4UZMUuSnbyYg7U4VVr6yPNwZo5T4zXKuSAVIA1MKP7PSOnIRJ?=
 =?us-ascii?Q?63/G7BT4eAiLK/Num6/vk49foUGqeXfvlC5fX7sPYsa6ve/B6DJKftKg0sOf?=
 =?us-ascii?Q?/ScQSgu5K6QQ5HbXQOcxLOUcgFuTVfowpH93OAUgGNpyNjCLntmfc4PrprCI?=
 =?us-ascii?Q?n2MXAWgPqZvdcMUv81CF6y2JCgqZzzKDvO9st9sXFW8B4bFwJaCLZAvdCKmU?=
 =?us-ascii?Q?S0qKHvxsNaMr/VIMbRByEu+0Zo02WNEm4vrkLXl1LPLW53ZD/opPFhBbHS9G?=
 =?us-ascii?Q?DXyi+zA+mMcWB0QZOhThKvh1kOYG4CfXXPBNsfn7j288EJ2RWKjdpqyfRh72?=
 =?us-ascii?Q?Z0xVfflyCRW+UTJV99r6Ajzb5BRfXzAk6lkoTGASlTT1bsdgnQguSKqO9qG5?=
 =?us-ascii?Q?W/65OchSPr7tCeBqzr3n01PJXE3BoFZ1amRdELiF+ysQb5LJ76AAaMI0sBJP?=
 =?us-ascii?Q?mISc/WZMhsFyGeiDHN4lZLhrsF2Nr4etYN88XsoBf/4hB9Hb+B1pzIbwd/SK?=
 =?us-ascii?Q?391gGWEH2w8RD898tT5FJthMz9zN0DDSua+8euPoSOv/d0oBdnEP6rDymqDp?=
 =?us-ascii?Q?OVNh586f2OtfWItZtPA4KS1Idu7H+bccZyAton9HXh81RnFzC8khqatX0E88?=
 =?us-ascii?Q?t0wOgX0R1l49EljVz+ElhfFuSI71gergCz2TLgr3k9al5mRMxz1puBeqluIa?=
 =?us-ascii?Q?EPAcb8tWk6N/q6uy++SxQmksQjOip5gjQBfn/cGIsHvg2eifZ4YombD35HmA?=
 =?us-ascii?Q?al8ldjQ5iHwTzJYc9U175US8kDB+x+KGKWIteY0370fKND/G8z8JS/iK1M7Y?=
 =?us-ascii?Q?exFBiSzDeMpVaUVMeVIGdSQ65LTB2x8LToyNzEtdNtDVq/732WsYWKeBjTyo?=
 =?us-ascii?Q?gzb7bagrtmXEEchnksbvaOPLZikxXcNi5nzkrPAaBvaDlV28yLBLMRFDuD9u?=
 =?us-ascii?Q?SkTf1uotbhpJMPti5tD3LLQX/nO/DyUPDPezUjmH2XSwvkrYGTdBMTAiF+wr?=
 =?us-ascii?Q?vIFAIYmqEkuzvCwi79OSZX/ErB7zwuAZ0hU3UplxSZzUedWbrjgAU1RDcTO3?=
 =?us-ascii?Q?eSvTtegI9cOKNgb0dbz9aTDAYAvYmZAuWhJA4tknJIhXpBWzH+mY3P5VFqxe?=
 =?us-ascii?Q?Z6BvNZZBd6V8rktuh8uvCwrPk45G6Fiph7F7W6tCkENjHs3CIn2ldcz0I2sP?=
 =?us-ascii?Q?4OkXD8zBwmF0Yk9kABJRUXKUAkFOZ3BSY+u3qHI0mEvUn62bTjmt6Dn0U/4g?=
 =?us-ascii?Q?bA90KP7M10oVRIsiiyaYBCn+xDMBAmMgHnQ4HeGpJfj+ieTkyk5WkKsI2AyR?=
 =?us-ascii?Q?ewHzSsYrtgbpQ39f8Fvs9hTmxewrmfCa3hcRQgYtNIaXpprHjkcI7ctVYe9Q?=
 =?us-ascii?Q?GPaP3k8TK7WRIJ1nqxzuqjckB/FS482NoU5ofPjbRArGp3GrzwhzAQooFKp0?=
 =?us-ascii?Q?/iOkgcWQoab+ywy6c0SNEBb9h8MoY0srk2qVnyOcU/n/n4tpwWjZQW8al446?=
 =?us-ascii?Q?80JS/V7ZKIJxSMPklGlZcsl2CHIdFo94ikYHL5ok3v5dH6xd?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fa76dc9-88d6-432e-bc2f-08de8e549247
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2026 12:05:01.8513
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OVUbEDHYsccXekLb5LeGANEe8BOB91y2P8MW0Lt+RBvz2lBCNRUZK941unAXh0g8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5653

On Mon, Mar 30, 2026 at 03:39:16PM +0800, Wei Wang wrote:

> > @@ -1267,39 +1267,37 @@ static void build_inv_dte(struct iommu_cmd *cmd, u16 devid)
> >    */
> >   static inline u64 build_inv_address(u64 address, size_t size)
> >   {
> > -	u64 pages, end, msb_diff;
> > +	u64 last = address + size - 1;
> > +	unsigned int sz_lg2;
> 
> Would naming it shift (or order) be more conventional?

I find that confusing, shift of what exactly? It is size of the
invalidation encoded in log 2.

> > -	end = address + size - 1;
> > +	address &= GENMASK_U64(63, 12);
> > +	sz_lg2 = fls64(address ^ last);
> > +	if (sz_lg2 <= 12)
> 
> then could use "if (shift < PAGE_SHIFT)" here.

PAGE_SHIFT defines the kernel mm configuration, "12" is a hardware
constant from the iommu spec. They should not be intermixed.
 
> > +		return address;
> >   	/*
> > -	 * msb_diff would hold the index of the most significant bit that
> > -	 * flipped between the start and end.
> > +	 * Encode sz_lg2 according to Table 14: Example Page Size Encodings
> > +	 *
> > +	 * See "Note *":
> > +	 *   Address bits 51:32 can be used to encode page sizes greater
> > +	 *   that 4 Gbytes.
> 
> "than" (seems a spec typo)

Yeah, I'll leave it as is.
 
> > +	 * Which we take to mean that the highest page size has bit
> > +	 *  [51]=0, [50:12]=1
> > +	 * and that coding happens when sz_lg2 is 52. Fall back to full
> > +	 * invalidation if the size is too big.
> > +	 *
> >   	 */
> > -	msb_diff = fls64(end ^ address) - 1;
> > +	if (unlikely(sz_lg2 > 52))
> > +		return (CMD_INV_IOMMU_ALL_PAGES_ADDRESS & PAGE_MASK) |
> > +		       CMD_INV_IOMMU_PAGES_SIZE_MASK;
> 
> 
> The spec mentions "Address bits 63:52 are zero-extended.", should we enforce
> it:
> 
> -#define CMD_INV_IOMMU_ALL_PAGES_ADDRESS        0x7ffffffffffff000ULL
> +#define CMD_INV_IOMMU_ALL_PAGES_ADDRESS        GENMASK_ULL(51, 12)
> 
> also for the returned "address"

2.4.3 specifically calls out 

 The IOMMU invalidates all translation
 information associated with the DomainID for both nested and guest levels when S=1, PDE=1,
 GN=0, and Address[63:12]=7_FFFF_FFFF_FFFFh.

I wouldn't change it.

Jason
