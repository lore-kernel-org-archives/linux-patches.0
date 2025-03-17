Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2040.outbound.protection.outlook.com [40.107.94.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8E6BEACD;
	Mon, 17 Mar 2025 13:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742218509; cv=fail; b=cxWydkl61JF0YJwMrNC4kpJLPIf8eiDyxfDNIEKY6/BDt4vybX8pryHDbAf8vmw4Pvmtn11Y+xMaujTeqjk/CDLhIIVitFYFfi1+63Pivv9GaszgiXxMzYboKkN4AEvvdyQT9d3YjEbxB2sGT38FbO9UacT+6VYuVL5kj4aG8rY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742218509; c=relaxed/simple;
	bh=Y5M8+csDZQ3aHOaNzP56HHpXXSYM7jkj6oh2WGwaMk8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=DKLwm3nAldaC6bI0Rl34VCtfJjlmbxRjsX3ltM8KyuJmJuOKG/aAOuYLVQJzEdrnd18uUdNURVvD2pYtkjatNwmoFKAbUYBCPrs9Syq9S7+DKGikqt2aoaGFQsi5k5hEMfOfu5TQr8DhJMFsbiKGpFJLopxQBANLrffJSlokZSw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=dh5TA+Cr; arc=fail smtp.client-ip=40.107.94.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="dh5TA+Cr"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R4JFDgbB+/rDELzQmoUMSKdSTaebqjnt8r+g07pcdde106csMgIPYA/UbJrL8unzN9k1ObhS7AUV9jCHWTd2XUV7AfhKifqFji6npQv2Fh+IDGIoplqB9ovS4OIwWs6oAyMMf/rALEAlqfv8U0qJwyDAMmLz9OYvoW7oBikQZipkW4z8Q1G0J4C1R5mCP4i6vmF1f4zBSkQeHH7BGQjm5sJ7Ict3GOOwPoAn2edvVz3ltzFruM1+c9c4epc4T5ISBDr3JCEkzojVImN7RfvAMoeAchzyXZOzyZNjsqqDW4n9oWZ8x4VOt6qXiIG2WzruYt8pgSo3Rt6eLcp/VmEMkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QVpmREWUg9a8YZJByOGNqEoHBBTPLjNhi5JntbtUWso=;
 b=yUung9teO2WkWBkKvZLc2bey32SwnmYzQ5UuxviRV+IC53NFLwNiWf2qKj785GU37eLNw7u5IppfLeudI/Q6N/L6WgpD1dFwYMR7tzSYUCTkNA95CjTjihL313AXChTvJa2q1QfBH2slKiVrXq9OmJRVAzZcDnN/s+77KbmI4aK80xIoM/F/lP130NzBJUKULRMCNHqcWjvCybpZrPVldJRZ80JUrG1uYdqUXujLh6gX1ZKVoCFrIUF6nlqB7y+BtGr5tqMhztCfoovH5wxiOVqZ0dP8fIxUHOumFIghUc0Bs4hhmbzmZlFU1rCrlOG7DUNPOG1Zs5uM/xCRh/fXcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QVpmREWUg9a8YZJByOGNqEoHBBTPLjNhi5JntbtUWso=;
 b=dh5TA+CrMpG8lvyAa6MPyfAnUBsCguXEvGpY4XwIgA8eoMVWnVZFNUeY29m04Bh0m5ai9sPEAv1Ish4g9QKoqrVWZSCGw2r4mzk6273+xbYdlMG8AFGYcz+isuECBe9If42bCk2tWu6A8ZMeADjpZ6KrRlAslKnu8AAyt/qnWjwMlQAPQA26bgJLPLvAfJLZkZUqezO+R37lmEAl3wVDM/RfDA3BtU+Q5p/pG3QUSsbS8oDvO85YJN4bSQdSpXyZy7BtQk1ydgZWtdzYkMib93atgvD6ohojDhvwTchJgY9bExOtjpX+o9SZIjjCsuyAsoA1B0SbQshkFWN8vvDmoQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by PH8PR12MB6698.namprd12.prod.outlook.com (2603:10b6:510:1cd::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.33; Mon, 17 Mar
 2025 13:35:01 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8534.031; Mon, 17 Mar 2025
 13:35:01 +0000
Date: Mon, 17 Mar 2025 10:35:00 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>,
	Alyssa Rosenzweig <alyssa@rosenzweig.io>,
	Albert Ou <aou@eecs.berkeley.edu>, asahi@lists.linux.dev,
	Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Heiko Stuebner <heiko@sntech.de>, iommu@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Joerg Roedel <joro@8bytes.org>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-riscv@lists.infradead.org, linux-rockchip@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-sunxi@lists.linux.dev,
	linux-tegra@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Hector Martin <marcan@marcan.st>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Samuel Holland <samuel@sholland.org>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Sven Peter <sven@svenpeter.dev>,
	Thierry Reding <thierry.reding@gmail.com>,
	Tomasz Jeznach <tjeznach@rivosinc.com>,
	Krishna Reddy <vdumpa@nvidia.com>, Chen-Yu Tsai <wens@csie.org>,
	Will Deacon <will@kernel.org>, Bagas Sanjaya <bagasdotme@gmail.com>,
	Joerg Roedel <jroedel@suse.de>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	David Rientjes <rientjes@google.com>,
	Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v3 20/23] iommu: Update various drivers to pass in lg2sz
 instead of order to iommu pages
Message-ID: <20250317133500.GC9311@nvidia.com>
References: <0-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
 <20-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
 <Z9GFFBvUFg7a9WEg@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z9GFFBvUFg7a9WEg@google.com>
X-ClientProxiedBy: BN9PR03CA0490.namprd03.prod.outlook.com
 (2603:10b6:408:130::15) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|PH8PR12MB6698:EE_
X-MS-Office365-Filtering-Correlation-Id: 8864a866-d4a2-49c2-7c3a-08dd65588462
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dm2wKysOZKcS2iA9ccaDPOlpmobmsYLHBSFHXDqYq0YPtUux89H70gfzutxN?=
 =?us-ascii?Q?P3IGyYPpP5GNZezRYcuFAc+GBulXK02g0bT6xNbQHZz13sKWtWHILYILvtS8?=
 =?us-ascii?Q?YPJkowhYJC9YbA0LwGIq6IzkfXAtH9QC4C0CerQQabu1K7jVViMH9fkU1f8n?=
 =?us-ascii?Q?ROlEOC9ZUNPb9KZvCheE3ZIz2JbzD/WMIHw1GlJ0pykFp4xnpJWEseHc10PO?=
 =?us-ascii?Q?k+ewbt7eBmHvH5/aUJibP/YVq27OU6bw66SCZXB6drdAnSCRbleR9fq/AD9r?=
 =?us-ascii?Q?TbEdQ4INcEKz1JPqTmwaVWTiNkLVbA8q6A7Pw1NdH7s2olbK1359tJq9dq9B?=
 =?us-ascii?Q?8qZEF8Wad6mA1xf8iEDgX188mr5hF4zSowC8oKg9dzkRzdcGLhXe+OL4rLPV?=
 =?us-ascii?Q?bOH0I6406gj1AjrMHq5LApCooUC1khCpTkm6sRPdhejm28VRefjeyuXgnQOf?=
 =?us-ascii?Q?710t8Eu0UOa/M/3X2wz92sQjF50DTfluCRx1JqHhAEfmTwaxkLlmCEqzIanR?=
 =?us-ascii?Q?Z6oji9UOTNQIA4VFAI58kuCaJ9mmEwWIX/JV0M44QCN+NJzDmcwpQ4MElDF1?=
 =?us-ascii?Q?BFbB06HQ5ek3wm7ZTn7Cz3M20NLA7X2yI7ogBN+MqfrrfoafP2WvuKs+iELP?=
 =?us-ascii?Q?AYOQUV/uS5iEdwsM/iUo1+c3XHBDmSU1Rq2MAruL1/cA1aZpA1S5d7IMKlNT?=
 =?us-ascii?Q?QVseLHJmFJQ/mQ9hx6Mkj103XvARFOigat0bnxkeL+2Xew81edryaOeP5fdH?=
 =?us-ascii?Q?/icGKXnMg0FY/5o73L5yTz5jEqhK2BhI/yAVrtz5bihv6Xy83ZxTB8Xpo42R?=
 =?us-ascii?Q?aqmZiebzVKgkVta+zBA1HEvWdG4ook0Pu92c0YrX9qE7hV0fYzY2UzEtviJN?=
 =?us-ascii?Q?6hpcW3PaSVwwUTMocqMQQSHlhL0ML54TZyqu7v52O1PlT7RDs4efebaYG0t+?=
 =?us-ascii?Q?4ZwFVafeDUhccrYVXYFy4KqGjrIR3DCe0ZUTKpIniO410k0y8DUchGq/i05O?=
 =?us-ascii?Q?JFB8C3k24CwZVdv7keZZHu6MhDuDNm3h53f0mRiJzaDpIl2P2ehgWvwoVoRO?=
 =?us-ascii?Q?oPf09w80ryiWKPHWPs1OHUvld+fve6ISO3m6OEUU5T8S5x7Gy/hd3LMv5PrL?=
 =?us-ascii?Q?qkcspGY7y8vSSRqtClZ+DRPqrYtw7hXvNLfMt63G0nB3jYIqnGgpP1z0qIEB?=
 =?us-ascii?Q?ujHAAFH1crIUws7C00XjHTFlYmV/UoRV/lwgXvarK/XKXMau/o8mlHfl4y+V?=
 =?us-ascii?Q?PdKO9/IKMHTvDEDO7IoGxMoqPYIBi1eVwt7SVP7Ay5lOK5kXvXv4Hg29n26v?=
 =?us-ascii?Q?w5pcRoxR/b01Om8CN/boKEhzyDftRQUtSMy9L3lDJSTt80YDOxPUyGRxiLuW?=
 =?us-ascii?Q?bvvC/pg2E4Jp+IH3NUfX7M4DzyJL?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9/tYovh1Sd1Pp5AsYoyo0sVnNIob+XlG72pHIw05rRevClzz8gOQoTc0/Mg2?=
 =?us-ascii?Q?jbYlsR6T86UFEhb66QJMwbJ58vp5VpAj9jJrKk//LehJ/VFFqBndDErqeVSb?=
 =?us-ascii?Q?7/KE9JeSRxP1a8oHllJMae6lPoqcXU6h8402pLhWW9vCBPmqpQENfT+ej4fc?=
 =?us-ascii?Q?bRW5wxP9jbTmMh/relrVcb8Es1Gj60IxMJfGgqi0C4ykO9AIGxuZlam/p3wa?=
 =?us-ascii?Q?piHOJhxcPPSsHCiJJSw+NQi36bnEF4doFcmyliLGwtNRZCCWkYLb6M2STupZ?=
 =?us-ascii?Q?p9amCjJTFtUunRqDYiGu0NH8A6R4GAEnKju9/8c5arFQs7U2ItwMrZ6MaBBk?=
 =?us-ascii?Q?9Pb2KNmCr8M38CBe9UXgbHlsOIJnWPpkRnygSLUqNK7qNt8rlM3UjezeUqYv?=
 =?us-ascii?Q?vMA49cfBfQ8WJqGUvC4wumnY/0Z/E19QDDNHVngKvzMPg2PRZFVJCEVO1Wv+?=
 =?us-ascii?Q?i4TyoWHWJJhT+CIT2F2utqWIguOfmeBZ799RmZVCPPgsgKSoeORVUnuhFIwx?=
 =?us-ascii?Q?oYd0AuhThvpbECCK8CqeBwJumDoNi3QmjlBIRx2xdiG3xJK1iJ3qakPCD7+U?=
 =?us-ascii?Q?GYgTWz6ISLR06hIEHR5SuwI7v9DVQCFGJ4oA5x4+yLAnZeAxdyuxXXf6x8X8?=
 =?us-ascii?Q?IA5Ru52sQ7uJrNGsK64M+OyJ67ihWL3eqlXTblorbQfewFRbZZnGE4w821xS?=
 =?us-ascii?Q?DsWcflOisZFZrASO3Dq5sIhvzLH+xTGnEiVooe/7FGXwyMgHpZwflJZSD/FC?=
 =?us-ascii?Q?zRTHENdmSImwEY+bbsEf3tWofWQBUYN42fZfUvEbCgRmDsXcqMAOaygAZgex?=
 =?us-ascii?Q?K1QGIgSK6huN6bAC60jka4Yy5SP13b+qJ27AC+gZbvNIBPAvGvPj5F9dmNfT?=
 =?us-ascii?Q?DkRd2bRTSSBr4itTUjaCe6x3s/+O8ftFacLnZKEzlAFf2eIiKDz7Y5fa4HY5?=
 =?us-ascii?Q?XCpj7dFF31SpXvTT+IxmkmuL0NcxK2jroHMpX6KovSQMFGpKdXt+30Kccime?=
 =?us-ascii?Q?MSixvAqU8V0PhE6yB7oKOcj0yp+VKyOZneOz72EYyqz6nf1PVKjInPmXFg72?=
 =?us-ascii?Q?RkIomuVEJg5oDYd1/xs5d3BEHVNOl6C0PCngSEuCoIOGWKfgFwA36PqNJHIu?=
 =?us-ascii?Q?MBSsJSQs/q/kO8NQI1X+7a5wmzU+Cf2/zjEFJT6AQXvIRDD/SM3SrG/u88xN?=
 =?us-ascii?Q?yzvFoPRrOzkNYXjQdtA6dXB8BC+YzTEzGIWnjVvMQkMD6FDFvZfiF89XebOn?=
 =?us-ascii?Q?U2/Es4gDDh8at5xMfRg4Ihrhp4+MdOTI2/VJiylDKAiBaAH8UOGdj+ID13FW?=
 =?us-ascii?Q?OHPThQ4lJKhX8fQNcKB3Vk5+ezDB5onyx5VeKWrhSoJjANpukhU9iKwI1Oq4?=
 =?us-ascii?Q?eeyyWWLbg5kgPruhiTTNcXEjX2cHx8ywG4gjkg6rpzbQUyulqHgQ1mo1WCc6?=
 =?us-ascii?Q?m115uU9QJqdwqlFYwXGFiesQJoSO/oti4VYTBZ+Tzd5Jo8AsSrCbU4ZY/p6M?=
 =?us-ascii?Q?jyEXUfAeWr3dOp2WTndCuQ9lnt+74cvJpSOXEd5Ww/U2no6/HVOw0Y5TNE50?=
 =?us-ascii?Q?XVbGt1c0ZhqR2KTuGZc=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8864a866-d4a2-49c2-7c3a-08dd65588462
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2025 13:35:01.1663
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1r79D9N92GH0VlXTY8ANVxs948ij5kn6KL+g7m/TOO2O74FKbytqc+bBw2qwIdfd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6698

On Wed, Mar 12, 2025 at 12:59:00PM +0000, Mostafa Saleh wrote:
> > --- a/drivers/iommu/io-pgtable-arm.c
> > +++ b/drivers/iommu/io-pgtable-arm.c
> > @@ -263,14 +263,13 @@ static void *__arm_lpae_alloc_pages(size_t size, gfp_t gfp,
> >  				    void *cookie)
> >  {
> >  	struct device *dev = cfg->iommu_dev;
> > -	int order = get_order(size);
> >  	dma_addr_t dma;
> >  	void *pages;
> >  
> >  	if (cfg->alloc)
> >  		pages = cfg->alloc(cookie, size, gfp);
> >  	else
> > -		pages = iommu_alloc_pages_node(dev_to_node(dev), gfp, order);
> > +		pages = iommu_alloc_pages_node_sz(dev_to_node(dev), gfp, size);
> 
> Although, the current implementation of iommu_alloc_pages_node_sz() would round
> the size to order, but this is not correct according to the API definition
> "The returned allocation is round_up_pow_two(size) big, and is physically aligned
> to its size."

Yes.. The current implementation is limited to full PAGE_SIZE only,
the documentation imagines a future where it is not. Drivers should
ideally not assume the PAGE_SIZE limit during this conversion.

> I'd say we can align the size or use min with 64 bytes before calling the
> function would be enough (or change the API to state that allocations
> are rounded to order)

OK, like this:

	if (cfg->alloc) {
		pages = cfg->alloc(cookie, size, gfp);
	} else {
		/*
		 * For very small starting-level translation tables the HW
		 * requires a minimum alignment of at least 64 to cover all
		 * cases.
		 */
		pages = iommu_alloc_pages_node_sz(dev_to_node(dev), gfp,
						  max(size, 64));
	}

Thanks,
Jason
