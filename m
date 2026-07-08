Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011007.outbound.protection.outlook.com [52.101.62.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DEE2378D77;
	Wed,  8 Jul 2026 18:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783534187; cv=fail; b=AEIJJQQM/YztlTw1b/FeHE9EZoA6c/adZbeKJcJWKgfFls0zMUlm6jfj4A3j6cLD/DOKnoZHS2hWoIFyYq5FdMolgL+Dq8MGctkfAZ9AhpWXT6SpKA5N18Df66ll/mfqEv4Lhxp+DUsuyDU5FTqO9BXqcYv5yGz2yQIdES5QUjE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783534187; c=relaxed/simple;
	bh=kgZWIsitv/1umE2KXiLsbIlpPB6whHQStVuQImN1d98=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=bGx5LrkJ2bywpqDm7TU0jv8/MdEofh3kjo4U/6axYDHtgmwA+WVpymOSXkHb6+Ed3bwbzf2U/hekLFytbADsJol8k/UK4+C3Pa/hvUgHu/Pq1IBCdnqfqRqbRgpatod4SJN8fyl21T0+YMkCjlqT+FHDkxc2dyU6cDg+UW5ujNo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=TGISsuN9; arc=fail smtp.client-ip=52.101.62.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="TGISsuN9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WyP4PjRDbB7S86ttQ8esiHXO20CW/+ekhcUOZF1beonJD97ofrrTmfQVHLzTfxXHfG1qoqv9e769ybQ1xfyociNUkvMcsFXlusODpbgy9CbbWCdUV4TAF/yfQ7C0Rn5HmG49BXja2pvw8GlqOH1FCcehxEAPPHB5yxRjBmqmm+AmnUxO2TvxCvzizgj17FkCDqGRJGcbcIJ/tTODr8H5OjLZB5ZJQmx8CWJ1cmpf39jXzGfnlWGjKdRbh6D3a+VEguoH4/XlNlcgs93s9dmaj1exg/w1xEV7QwnuZugKHdKSkmcy00ZqZsCytsRuGV1dGulQ/X06JN4N96eScx+EYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DqS+CU+ESy71Bua+X5h0kJ4zhG6CFfJ+ZL4x0e9diUU=;
 b=w1/not/h4RaNIXPOUbJHUWBUQdCFmFkq2uyjgGcg3EBMKzOrTh+vlOvBpN9nCyJevYARV/rQBEkCcsEsVt8u/+WauBRSChK+3RhnDdbkBr3Us/nUOIR1LZbB2GdHYXnvj1qNSy2Fs5gO3Aztjzkn39beJmDEKKuiwe2Vwe9Td+gqiTkDJmE9mqKHfXkdyk0E2Fx3o5KAbvwzrLpA7KJ4Y3lxPF63eWIcxeeqUxVRoj9GX1j6DgXyUF0uSA0Q9aZmi2ug4TWiVhXfDfEJeSzg5FaOq70Q9QuHR49A4u1FPS0R/zJH8neng9sSIDWq4K+KIUwZk0GMkQOFaomZKV5QVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DqS+CU+ESy71Bua+X5h0kJ4zhG6CFfJ+ZL4x0e9diUU=;
 b=TGISsuN9vSd+Lp4YxU3aOpwB2eb/sQ1moICLZuz+isv/+w/Y3Sz8eaGSXRaC0nKZgUE0yBWPk4YSTKN00LyQE5bkQyWv5m8fhEdMqDWdZ3Vy5zignOZLiwbD0WYsUb8NXzS/pHKdYZkNzOvtyGwrhIZvL9JL9o3J8uexi0TAH/rYFrkV1VhmMw2oHEB/hvCSkqFqM7eguheVhPQBIcWBRwovK+N/8dpOHk22l9BNdS8xZajxE7QVVzC1xHuqzPUwCJhM+7MxxiZD/LAXan/oxmSst1n5kSLRK1jRMBcPNTbYOFGcZUKJmiDaK0dKrwhJO0zObQdr+YzZ1W5lu+UgWA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SA1PR12MB8641.namprd12.prod.outlook.com (2603:10b6:806:388::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.9; Wed, 8 Jul 2026
 18:09:40 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0181.008; Wed, 8 Jul 2026
 18:09:37 +0000
Date: Wed, 8 Jul 2026 15:09:36 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: iommu@lists.linux.dev, "Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	David Matlack <dmatlack@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>
Subject: Re: [PATCH v2 6/8] iommu/arm-smmu-v3: Populate the tlbi at the top
 of the call chain
Message-ID: <20260708180936.GB422027@nvidia.com>
References: <0-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
 <6-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
 <akzptWVIihnH79Hb@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akzptWVIihnH79Hb@google.com>
X-ClientProxiedBy: BN9PR03CA0918.namprd03.prod.outlook.com
 (2603:10b6:408:107::23) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SA1PR12MB8641:EE_
X-MS-Office365-Filtering-Correlation-Id: baaf850f-a4b2-41a2-038a-08dedd1c128a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|23010399003|22082099003|18002099003|4143699003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	y8xMfWduy4OXY+i42FwhguvSQbMOnTMWGGPHA/wWg8nQHJ4xygHO5xT2V8h2vjj9QyLlyCfkfy7Uh+TOpjYPbqQxHCApnZPc+1vDizr1yKlnQwPIEDxNRwl15UatcQmoxErBuYEvxDFIcMmWRjKd4dSrqC53bVs5fkcLoeKNem56Ep/ppEfP9NamGXWb9re4ufxtrRSp3BOCmzNeXGoh26X79DgG9CB0YwBjvE+24AdWMUQvbePEO3B+yzeh+ZOEBric2Sp9IY+oH2rtWblB8Q8IKoAvDgX7nYTqQ5vzzKbF436NSF0Ugt3AAGhtgYMAkDSQ8j9qEp5SskAKI7XppvX+npgYqUvP39RmESlqICL9XHc7y/q+t8Dtpn0sZfUlYc7UGfKAmECxUafL10MgdhLAQZnuAJdn7k4fTOvX9xOUyPUjTR4fgxUF642GnLpzc97qla2EL3s4kXkxZ/a3jRQc6TpxQ/nnEtOsiDMgQfxLdUsI0rLUCHqYgocnCHquC8qpsJq2rjnRunnqhDw58oTDefpu3H2cGnLT41IsHuTGuME5DUn+ozcXhjy1296Va2bDXuNE1s2gTb4UN1YG5uV+PQygx20/bKPMSYTZkFoejQ4K9bwBsGKz9IlpwAs5DmWNExaUZHEs1Fm4OViBYHGI3mvtxmb5TlxEwXpqh8o=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(23010399003)(22082099003)(18002099003)(4143699003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?UO/UWkm++SjDEU38nq4AbrxqvRf+zULB8tnc/9DBsw5kgkOsB7qYdqOwN2/b?=
 =?us-ascii?Q?YJKbsx4jWANwDrz3K+cZohmjX8cq6pFxB8k2sa8PoY9Lo6BkNKmRQIw+j8Jv?=
 =?us-ascii?Q?l9FMZLee80vF+Ww/eAvQWBnF7T1gKlVny5RT75wTFVhGkaaDOH8RoOONa+Mj?=
 =?us-ascii?Q?p/KLpB5wKNIKII/fbMSTTaTSuK3+PR8jJehjnhTYgs707Fm259F7S2Smk1vJ?=
 =?us-ascii?Q?Yt+n2PhttGbO1cFriHXQY2SjIphQIY1Pklt7nQ5eV8lebLWV95j3eQSZqwq1?=
 =?us-ascii?Q?t3OWBDN8nO7rleKe5v1OzRv7vC4+uVSIrGnOxNfnChKH07hQbL8sY+UYHFKu?=
 =?us-ascii?Q?qP6Ew5EX9HiStxqjKNPjGfCTZjC6skZXXGUAGVgYs2ticdbCA6nhesASPVxv?=
 =?us-ascii?Q?8QkxEGeHPPlek+Ko29Q4npsB4xbbOI72rRzdMKCJ84TDdSWpl7sZb0IMVRTd?=
 =?us-ascii?Q?t0AOwzLtfGXcJIW/dTisZ0udd+iDdnWOn3ZwdqChUrsyWsD7O/VtIUxFXy+Q?=
 =?us-ascii?Q?TFAutQH/2yAZ4wlU1c6ksz86KG0JL6pKpIm3IiKaCO/A6NwHpXxjDHwkU7YV?=
 =?us-ascii?Q?tLE9S9iciX21QXjAiEp5BJDACzoV6++ggoE7bkVjm7ue1CO9jxQZy3JwS2IH?=
 =?us-ascii?Q?Pga37wPugx4N6hn/jlxP+7fBzMpbyVr7nstWtPG+qYba2aRjG2hdXU+qsAfv?=
 =?us-ascii?Q?x/KEfXlpnenbR4I1W6F70+gvyFIzkNhBEO8SCI4llOHYTTOEtl10qdRz48q2?=
 =?us-ascii?Q?BTAxLDQoDD6Tt7b3SuBZter3gSaYPXyEdh3GUq8Zv8r3ktH7TLU1paWhKQQn?=
 =?us-ascii?Q?HQQ/c+at7pXiazEzfQbrb0UxXIYHe84fjYpwjU8zjZAcHoGzvREiyzu2Jj4i?=
 =?us-ascii?Q?Q0/47RB4QNE5Ns9JV3w4gNaT0/XAVXiU2TnlGqxUztM93acWbBvCli51sCOS?=
 =?us-ascii?Q?qWBr3NEf6efV5dEeMSOzpM1emVlC3sKQvHgPrI+c37G9laBpWEH/sjvHkVpt?=
 =?us-ascii?Q?jeWpBB2CSAmco76+wsbrq7qXFTbHeA3/tg325kbN0GJCxF/vr6hSPTNZE4Wt?=
 =?us-ascii?Q?8veg9R/zOxcyvBkuVtVN3jiEwt9zYAl9pKhtfUL3uBnXplrKn0Pz/Zx2kWba?=
 =?us-ascii?Q?yIwpIvAWctZuEeSuKjlDolgR+5Y1ZzEsiq+A77K5rGyDfxcPS1OPVxTg3qGM?=
 =?us-ascii?Q?fiBDZIq2mPOFLu3j7uuYe+SS0bfXdFRGdFUzRpouaktLtZMqz+ajabK9u8Mn?=
 =?us-ascii?Q?sHUq7H5MJsSqNR2q3Kob1ALIyvhWUTQYRRsohF1HGJewcz7RNMuoqiC6u9w4?=
 =?us-ascii?Q?jQTJPP1LjSxgDY6tyHJczEf8v0C99LSBERvLVzt+7qkB+uYqY8zP8ZS+PQ8m?=
 =?us-ascii?Q?3gm4g+ZNn3ntgBQIkeiyW4DVtp5VH4IKFzPkqoyEcB3rRwlPIwd3n71DCNwc?=
 =?us-ascii?Q?zSqyfVdAz/bK8BIMdnNawjo5xGAh/ZwobsFrElK2o6M+yYC7maFELo+kQfma?=
 =?us-ascii?Q?8eQjYU+h/7EbadzLBdb458mf5aOLaY7e+WSfKSx3joV8Mv1G3GAmhu+bX9zR?=
 =?us-ascii?Q?SLdi+lM4i7+plOemLraJdAbyYrZzQKfGm7WcMmXllxefXwpAuMlF+e8EJqrs?=
 =?us-ascii?Q?ZnuUlTJLWGjjQRb+tHkE/UQFrhZaYLfkueOeUxrPQWjEIn1mu5HPTfjsbJ+p?=
 =?us-ascii?Q?g0g1PPahYut79Hg/K22lt9kE1BIWbUO0fUTrs0L3GOUc8uX7?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: baaf850f-a4b2-41a2-038a-08dedd1c128a
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2026 18:09:37.4792
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R1DRnLTkCQq4rhzSViyPQZjgBjEijX5Fxd8PtPb1267Q8KSBX0kztF1H9cYirzrn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8641

On Tue, Jul 07, 2026 at 11:57:41AM +0000, Mostafa Saleh wrote:
> > +	if (!tlbi->single.use_full_inv)
> > +		arm_smmu_tlbi_calc_single(tlbi);
> >  
> >  	/*
> >  	 * An invalidation request must follow some IOPTE change and then load
> 
> The rest of the comment still refers to the old name
> arm_smmu_domain_inv_range()

Got it!

> >  static inline void arm_smmu_domain_inv(struct arm_smmu_domain *smmu_domain)
> >  {
> > -	arm_smmu_domain_inv_range(smmu_domain, 0, 0, 0, false);
> > +	/* Prefilled for invalidate all */
> > +	struct arm_smmu_tlbi tlbi = {
> > +		.smmu_domain = smmu_domain,
> > +		.single.use_full_inv = true,
> > +		.range.use_full_inv = true,
> 
> Those were introduced last patch, but I am wondering if use_full_inv
> should be a common field instead of having it in both single and range.

They are usually different values, this is the only place that sets
both the same. The conditions for RIL and single to switch to full
invalidation are not the same.

Thanks,
Jason
