Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazolkn19012054.outbound.protection.outlook.com [52.103.66.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D63563A382E;
	Wed,  1 Apr 2026 08:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.66.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775033528; cv=fail; b=IlV+XJM1eR0Ezs9Ob5ajxjT4fBEITZLi6wa6ODUx5FWCLy34tNvW3OfczQcfOXnWP4ZGtjrAtrUYo9jvk5lKuk3tJTNVDx8/K0aTiqQkbnrSIIkBkGD87MGoCVHao8+9dT6u5joWB6wQHBXQY2rpujO2QEDNQ2IdB5lKkN2UBS4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775033528; c=relaxed/simple;
	bh=d6+34baj7LUeV6CT+8a6DyccGgbd8PsK5ebgEsg8F08=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=dsLKkj8mLOJdWYXUP+znoHCzHWXbHzlIWOCkgrHBpC3s249F0yU2+i0xjpK9Q0KbyJuzOopJRr0Kqspd7U55NUfQJqAAHmd18T/yNL5SZOrhHLCKlLcU89tCDaJcopTHPpyL9kw2vNknPogwCxd63riZSeHg9rzrCzkAumUsRF4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com; spf=pass smtp.mailfrom=hotmail.com; dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b=hRXDLSrs; arc=fail smtp.client-ip=52.103.66.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b="hRXDLSrs"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=anRSBU4f2w1Y30/b5W0nSQbFXbn2JjEn/eN8uTVCKhGYBRlF3bpHPDpjDUcpggUpXoo9nRC5+nN1zLot8LqYEj4t5vJc1mroIYhFJZ26K9Kd0hRERgkfjmKxOqy3viDS16ZYktQOZTeeygQDKcAxHManzxKAKA1lvPb/DjEcvoHR059qIRRv3RSTO0LiNbpm18C7kSFzIhp7cTwFNUm6i1CxiOWBE+kafQ1HfPkjvi/oxuWynrLBtk6PyJ79TAMIllwrw38y2DQLtrCMwUVOiPSLIC4KztTIDAfTLvbRvu7imTgDlC8PuGahncKKgdBldvOEI2h9SnKmsoZkhaZt3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H4cC6VLiz1KhgeBNmQMIrDEGoh4+QEpKfHka7T5fijg=;
 b=hcOwGHVzt7G8Sc9CakY2TQ1df4vUXLv1yXwvyQqb67ts6RW7BmgCDdNIgmwZmtDz6SryLfePpdgf+oloPu/5AbXDdtchGKDBR0Yb6jEFoLyCYSI398X5mXPgWgN9TTnVP88MJq/S8YWqmHjgotl010sZem3YrVEKJ2AhE4oAugq+ytFegUJqzfPUN5fpQkO1oARLjk+WVqSYWpCGxYIZQEEsoTkfirEfWxqmzgDszbMH3enp6GDwQbjNj+rQDd4cD1+7cj0Z3uVVnrN70/Z0yeFzThBF2LlkV2oU8eqVmii3JiwgSjPUP/rN/fyYvBzG6TjDsoXgyjkB21ZgOhOGKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H4cC6VLiz1KhgeBNmQMIrDEGoh4+QEpKfHka7T5fijg=;
 b=hRXDLSrsyQvNmAhoOZENchL9otipzBu8I1P3uZqfjBk0BjX2oZGTaZHOYZai7jM4qvfelm0WpRpiCohlAHEEqzGXefkS6+HKKwOri1pub7X0hPLaIPir5gj/WWQe6Tctnc9kuQR/Zo1wAH4uVtweRm/wmFgsuCPj2Xnzs+rfUzZLdV7o7xaj58akFDkhztDFMaDteHNmzJkc+X6KUukpjRckxMRi/ZILA4azydI2IxNc1QRMUEeeq1ngd1JssezBVkwck3/KqQ86LOD4XHkS3nbflA8NH/waxkKHixXbvU+pLQZo1+rllgSv94mdJApsdBRryUms5Itv2L0fmDtgqA==
Received: from SI2PR01MB4393.apcprd01.prod.exchangelabs.com
 (2603:1096:4:1b0::7) by TYZPR01MB5056.apcprd01.prod.exchangelabs.com
 (2603:1096:400:334::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.16; Wed, 1 Apr
 2026 08:52:03 +0000
Received: from SI2PR01MB4393.apcprd01.prod.exchangelabs.com
 ([fe80::c735:fab8:6e3d:6d1c]) by SI2PR01MB4393.apcprd01.prod.exchangelabs.com
 ([fe80::c735:fab8:6e3d:6d1c%4]) with mapi id 15.20.9745.027; Wed, 1 Apr 2026
 08:52:03 +0000
Message-ID:
 <SI2PR01MB4393EA93D66A8E204E357713DC50A@SI2PR01MB4393.apcprd01.prod.exchangelabs.com>
Date: Wed, 1 Apr 2026 16:51:58 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/5] iommu/amd: Control INVALIDATE_IOMMU_PAGES PDE from
 the gather
To: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Will Deacon <will@kernel.org>
Cc: patches@lists.linux.dev
References: <5-v1-a7b77c25974e+115bf-iommupt_inv_amd_jgg@nvidia.com>
Content-Language: en-US
From: Wei Wang <wei.w.wang@hotmail.com>
In-Reply-To: <5-v1-a7b77c25974e+115bf-iommupt_inv_amd_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TP0P295CA0060.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:3::15) To SI2PR01MB4393.apcprd01.prod.exchangelabs.com
 (2603:1096:4:1b0::7)
X-Microsoft-Original-Message-ID:
 <824c80ce-5b31-460d-9999-21c625f40728@hotmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SI2PR01MB4393:EE_|TYZPR01MB5056:EE_
X-MS-Office365-Filtering-Correlation-Id: 66075512-e048-412b-6a54-08de8fcbf142
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|51005399006|12121999013|5072599009|6090799003|461199028|8060799015|7042599007|19110799012|15080799012|41001999006|23021999003|37011999003|40105399003|440099028|3412199025|12091999003|26121999003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NU1jUjZ4Tm10YnRmTThhMENXREtKRVdhTVVDZHJBS0JQN2dPL2IyeW5hL1Vi?=
 =?utf-8?B?L3FNMnhjS21DaTJ0dFUyZENEVitTRnZvSHd0R2R0N3R2WUxBWHV5bkh4bE02?=
 =?utf-8?B?TFlIMmpGU1RKdkFKR05zcUdXTmpZMnlhdDVUY08vTXBVY0MyQUwwRzFqeGJw?=
 =?utf-8?B?SHhyaFV2RU5SaUM2WUVIRXA3Yk5XM29KL2o1cVptSWFqZFlXVzRhMmljbkp2?=
 =?utf-8?B?Q2k0dStXZ1ZNK2tVbVlsTVg5Nkd0S1AxTmRadGNrR2w3ZUozdTNuM3NOMUlK?=
 =?utf-8?B?OFk4dDVGQ0t2NXUvbHRoM2FHOGN6VkkxczFTTDAwY09TQklmNlYrQWJPMGxK?=
 =?utf-8?B?WXoyM01ZTnAxQ3RCQUI1V3o0UGdnQk9Ra0VibGc2Y2Z2cjE3QWJ2QmhnVC9j?=
 =?utf-8?B?Q2JvSU1ZRUp6elpzb3AwL0k2V3Y3YnQrNmduOThyQ3NwWmRPMG01eENleVcy?=
 =?utf-8?B?MFJLUyt1ZXNSNTdaZlIyaXVDTkUrV0xSZEVFNEd1R2hCMENEdm9NSTVKZ0Ux?=
 =?utf-8?B?MDFzdGxOaW5GWUFST01GcU5sVWxyMkJFelQ5UEhTb1FwTlZPZ2dxUE02UjNs?=
 =?utf-8?B?VCtHa0FmRlQ2a25GNzlvUnMyRDg0RTI1Tm5vbTFEZEFyN3IzZVBSNmZoTDUw?=
 =?utf-8?B?cG93dXkwN2s1bFZMeGYvVXJCaEIzZThTaXN1dTc1SXRibzYySjQ4Mjh0Q1hQ?=
 =?utf-8?B?UmdrQ05QZnJENTVTWFNhZStvb05ZWElXbHVQUmdQVEZ1MG03TGZVU3pYdjJP?=
 =?utf-8?B?RndObDF4cml4MWVtMDl4Z0FEaVJTNWJicW85dnd2MnkzS2s4VUhCeEpOWUNa?=
 =?utf-8?B?eHltZzFjV3pGS3B5b1VrbkVjd2pqMUFvVUhZcXhRQ1M2UDhyV2tvVTJIREcw?=
 =?utf-8?B?Vnd2a09rc2xaZWx2U3RFYVJBSkpZYzNmaFFqQWpLdWh6eEs1cEg4R1grRkNv?=
 =?utf-8?B?UmQ3eDl0ek9HYkI2Q0w0dDZ3QURmRlduczBaYnd0OUNlQStWYnNwWHo5K2xm?=
 =?utf-8?B?WFZhVUx4elNMTjJuYmNPWGVYd1FsMEFqS0d2S25sc3NqV1oxa0FpTTlzbDkx?=
 =?utf-8?B?eE1QY01aS1VFdUdKWmNXbWthNnhkQU9HMDA4SDZTemxYcmdBM3E0cWhHZmhx?=
 =?utf-8?B?eERkRHNGcU91VG8yY0FWZkJPVVpuR2Y1MTRqcDNSdzJzWU1aQXAxUlI0cXVB?=
 =?utf-8?B?MVF1dVVXRFpqU3VySU8rOTNCQnZyRFhnSmhTdUYyNzQyS0NOc0Rmcko4b2pG?=
 =?utf-8?B?bWFiSktoWkdkMllvNXB5U3VsZk5PSElLemV1QmRzNlpSVU10Rm9HRnVxV3Vh?=
 =?utf-8?B?NGhMZmR4bW5salhJVWd3QUFyUXRwcW1jK0ZlUCtZSXRiU0J5eTRXcFpyR3dN?=
 =?utf-8?B?VlAxYXRuOTlNQmlscklrd25ZaForcEVHQ1hTS0xmMHRRNEkzSjJCL3V4V1BT?=
 =?utf-8?B?T3RHdGJtN0VabGRrSDkzN3d4aUNHT0IyekVTSXBxRDNMbm8vNUkzdVpyT0Fp?=
 =?utf-8?Q?mgLvO/8xWQXNth+ZQ8f1mC41aGu?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cVZLSm80dUhMVFQ1cXp6TWZRb2MxZTNNUXdQc3owYng0d3d4aXhHTU5Jak9T?=
 =?utf-8?B?aUtiQjZHV2w0RTdsRUtNRFdpY1ZOSFBNYmV0MUVldFEwZCtvNkdlV3ZIVzZx?=
 =?utf-8?B?dEhZenRydGxLV1ozM1E1WEx4S3JLeEZ4VVNQNUordkVERFhNbEcxZHJsYWJl?=
 =?utf-8?B?MTNGMDAxMEJGUy9yTE12NFFPQ1J0UXh0ZDFLNVgrMEEvWGI2emcyb1I2OVNv?=
 =?utf-8?B?aC9oaFpwN2dIbXdLN1FnYkowTUpnUEhRWTFSbEhWY1E3L2ZrelcwU2JGTlQ0?=
 =?utf-8?B?K1hNNGVzcURENFlTU2ZoNkJmYXVWaExGczR4TWhxZG05MmVnSktrTWllR0Fk?=
 =?utf-8?B?cnZ5eHNxSzBXbjVpY2grRUxBbmFtZnJBdEdBeFdLTGo2WDlsV2hSWEx3VmEz?=
 =?utf-8?B?RW91YVpnMGRVdGp3SmJzVTJMOFVYTU42Yy9TYUNTcnluaFV0WmEzYlZGOWhO?=
 =?utf-8?B?UHgyVFlnUXUxY2tyK2VmYlBpdnFmR2xET0dPRGRSZ1dRZGRYU3JheERZQWow?=
 =?utf-8?B?UzV1S2hJYkozLy9HK2FOcjNvbFJ5YkZIdmlxTnB6aVpxUnRyTWJTZ2FNTUlV?=
 =?utf-8?B?QmhEMERJQlJPemYrM1EzN0dsZlJwSGtGbDQ0Y2RkSGkzdEhwVlg4U0U4OHlr?=
 =?utf-8?B?ZzV2OGRhSnN4SlB3TkpZaTQ2TWNkUlBQOXN5V0NaRmFha3ZNWEk2TmVWOFNm?=
 =?utf-8?B?S3dzL2krcm1nUWFrVTBPVkxaNXJvaGFWUXZXU0RZeWtjMmhUYmNvenUxVUsy?=
 =?utf-8?B?Y3poNjUyS09kOFJTUysxV3NQSUdOYXA0MS9jZmh4d0pIZTZkWVNhOE9QYVcx?=
 =?utf-8?B?NTlOOE5temZqcHNPakFob2lVcmRycUI0MC85d0lucUthVDlBbDlYcEQ2d0h0?=
 =?utf-8?B?bjlRaFFIZG9veVlkcUdHaHI3TWx3dkJNUjZ5aG5XMUVJN3o1NW83OHk3TTFQ?=
 =?utf-8?B?ditDaEZaS0ZPVVNMV2Q0a2U4U1Vpb3BFaXFheFQrYUNvUFdQMU5Uc3hVUnRC?=
 =?utf-8?B?MWtnS1E3VkRGY3MxdXNrUk1oVVdMaG9UalYweklSRnQ3OUZnY25xTHFXUlcv?=
 =?utf-8?B?eldiYnpxVTEzTW9heTYyV1FoeFdVTktwU0JhSjU5b2FQSGZ2MzQ0T016dmRT?=
 =?utf-8?B?blpCSGJvQlNjYVZvWTFtMVRMMUVJLy9sR21tQTgwQVhyMHNsK2Z6WE0yUkln?=
 =?utf-8?B?NDNEcnlSL0g2WVRReW1WVTVtVWhkYlZObC9LTi9sSCtIRXYrVmVNSFRYMVlp?=
 =?utf-8?B?MEtUMEl5N3BXNC9NR1RDNnV3MjV6TkVQNkNYQ29kVjhVamxLNmpSZlhoS2tz?=
 =?utf-8?B?YTZZZHloWE16azh6dnc5ZEdoOHN4cTZXdTlYYkNaSS8xVEYwUHBkNm5XZ2k3?=
 =?utf-8?B?MnA2NGdOQ2VnZ0tMVE9Lalp1WituY1pVV0RMSW5haW5mMmxHTkY3NWVjUWtI?=
 =?utf-8?B?b0N6UFU2QjFhc2JUeTI3RHF0SEprKzFwdDQxQjMvZ3U0dk1JMzVyVW41WU1p?=
 =?utf-8?B?bkMzR1NydlNPb0tmaVlGelVZaUZvSUNyaVJrTVJXMnAvL3RFK2FHdDZMNHJS?=
 =?utf-8?B?bDNLRGZWUnY0UC8xbGVUV1dwUGZPQ1E3RkRDaGJsdmJ2bnFpNll0VG4rZGFp?=
 =?utf-8?B?K1ZaeFl5WXVsQ2JieVVCRUhlc2xBOWdpUFRNak1UcGlOQ25JWUYxYjNMbmZB?=
 =?utf-8?B?TlVYbEgxek1zUTRrU0tXKzJjcDdmN2tHbkNwdERBcE1HVGJTdlpVWlV0dGpM?=
 =?utf-8?B?MDlKN1N1THVyQWFGUWhTL3dSc3R5dUZKUWxPaEtlWDhTR2lCd1I2SXNkRnB5?=
 =?utf-8?B?bmZOSXgvYzhTaXRMODRsUkdkeEZjQi8vams0M0ZWZ1VNcHNJczJrMjVnYXBH?=
 =?utf-8?Q?7HAmJ9IWsK+KN?=
X-OriginatorOrg: sct-15-20-9412-4-msonline-outlook-3e488.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 66075512-e048-412b-6a54-08de8fcbf142
X-MS-Exchange-CrossTenant-AuthSource: SI2PR01MB4393.apcprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2026 08:52:03.1466
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR01MB5056

On 3/27/26 11:23 PM, Jason Gunthorpe wrote:
> Now that AMD uses iommupt, it is easy to make use of the PDE bit. If
> the gather has no free list then no page directory entries were
> changed.
> 
> Pass GN/PDE through the invalidation call chain in a u32 flags field
> that is OR'd into data[2] and set it properly from the gather.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/iommu/amd/amd_iommu.h |  2 +-
>   drivers/iommu/amd/iommu.c     | 61 +++++++++++++++++++----------------
>   2 files changed, 35 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/iommu/amd/amd_iommu.h b/drivers/iommu/amd/amd_iommu.h
> index 67d4daaaf6f0ce..364878a923edd0 100644
> --- a/drivers/iommu/amd/amd_iommu.h
> +++ b/drivers/iommu/amd/amd_iommu.h
> @@ -88,7 +88,7 @@ int amd_iommu_complete_ppr(struct device *dev, u32 pasid, int status, int tag);
>    */
>   void amd_iommu_flush_all_caches(struct amd_iommu *iommu);
>   void amd_iommu_domain_flush_pages(struct protection_domain *domain,
> -				  u64 address, u64 last);
> +				  u64 address, u64 last, u32 flags);
>   void amd_iommu_dev_flush_pasid_pages(struct iommu_dev_data *dev_data,
>   				     ioasid_t pasid, u64 address, u64 last);
>   
> diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
> index 4e057fbc20021e..95f7dc6cf67eaf 100644
> --- a/drivers/iommu/amd/iommu.c
> +++ b/drivers/iommu/amd/iommu.c
> @@ -1301,8 +1301,8 @@ static inline u64 build_inv_address(u64 address, u64 last)
>   }
>   
>   static void build_inv_iommu_pages(struct iommu_cmd *cmd, u64 address,
> -				  u64 last, u16 domid,
> -				  ioasid_t pasid, bool gn)
> +				  u64 last, u16 domid, ioasid_t pasid,
> +				  u32 flags)
>   {
>   	u64 inv_address = build_inv_address(address, last);
>   
> @@ -1311,12 +1311,9 @@ static void build_inv_iommu_pages(struct iommu_cmd *cmd, u64 address,
>   	cmd->data[1] |= domid;
>   	cmd->data[2]  = lower_32_bits(inv_address);
>   	cmd->data[3]  = upper_32_bits(inv_address);
> -	/* PDE bit - we want to flush everything, not only the PTEs */
> -	cmd->data[2] |= CMD_INV_IOMMU_PAGES_PDE_MASK;
> -	if (gn) {
> +	cmd->data[2] |= flags;
> +	if (flags & CMD_INV_IOMMU_PAGES_GN_MASK)
>   		cmd->data[0] |= pasid;
> -		cmd->data[2] |= CMD_INV_IOMMU_PAGES_GN_MASK;
> -	}
>   	CMD_SET_TYPE(cmd, CMD_INV_IOMMU_PAGES);
>   }
>   
> @@ -1523,7 +1520,8 @@ static void amd_iommu_flush_tlb_all(struct amd_iommu *iommu)
>   	for (dom_id = 0; dom_id <= last_bdf; ++dom_id) {
>   		struct iommu_cmd cmd;
>   		build_inv_iommu_pages(&cmd, 0, U64_MAX,
> -				      dom_id, IOMMU_NO_PASID, false);
> +				      dom_id, IOMMU_NO_PASID,
> +				      CMD_INV_IOMMU_PAGES_PDE_MASK);
>   		iommu_queue_command(iommu, &cmd);
>   	}
>   
> @@ -1535,13 +1533,15 @@ static void amd_iommu_flush_tlb_domid(struct amd_iommu *iommu, u32 dom_id)
>   	struct iommu_cmd cmd;
>   
>   	build_inv_iommu_pages(&cmd, 0, U64_MAX,
> -			      dom_id, IOMMU_NO_PASID, false);
> +			      dom_id, IOMMU_NO_PASID,
> +			      CMD_INV_IOMMU_PAGES_PDE_MASK);
>   	iommu_queue_command(iommu, &cmd);
>   
>   	iommu_completion_wait(iommu);
>   }
>   
> -static int iommu_flush_pages_v1_hdom_ids(struct protection_domain *pdom, u64 address, u64 last)
> +static int iommu_flush_pages_v1_hdom_ids(struct protection_domain *pdom,
> +					 u64 address, u64 last, u32 flags)
>   {
>   	int ret = 0;
>   	struct amd_iommu_viommu *aviommu;
> @@ -1559,7 +1559,7 @@ static int iommu_flush_pages_v1_hdom_ids(struct protection_domain *pdom, u64 add
>   			pr_debug("%s: iommu=%#x, hdom_id=%#x\n", __func__,
>   				 iommu->devid, gdom_info->hdom_id);
>   			build_inv_iommu_pages(&cmd, address, last, gdom_info->hdom_id,
> -					      IOMMU_NO_PASID, false);
> +					      IOMMU_NO_PASID, flags);
>   			ret |= iommu_queue_command(iommu, &cmd);
>   		}
>   		xa_unlock(&aviommu->gdomid_array);
> @@ -1674,7 +1674,7 @@ static int device_flush_dte(struct iommu_dev_data *dev_data)
>   }
>   
>   static int domain_flush_pages_v2(struct protection_domain *pdom,
> -				 u64 address, u64 last)
> +				 u64 address, u64 last, u32 flags)
>   {
>   	struct iommu_dev_data *dev_data;
>   	struct iommu_cmd cmd;
> @@ -1685,8 +1685,9 @@ static int domain_flush_pages_v2(struct protection_domain *pdom,
>   		struct amd_iommu *iommu = get_amd_iommu_from_dev(dev_data->dev);
>   		u16 domid = dev_data->gcr3_info.domid;
>   
> -		build_inv_iommu_pages(&cmd, address, last,
> -				      domid, IOMMU_NO_PASID, true);
> +		build_inv_iommu_pages(&cmd, address, last, domid,
> +				      IOMMU_NO_PASID,
> +				      flags | CMD_INV_IOMMU_PAGES_GN_MASK);
>   
>   		ret |= iommu_queue_command(iommu, &cmd);
>   	}
> @@ -1695,7 +1696,7 @@ static int domain_flush_pages_v2(struct protection_domain *pdom,
>   }
>   
>   static int domain_flush_pages_v1(struct protection_domain *pdom,
> -				 u64 address, u64 last)
> +				 u64 address, u64 last, u32 flags)
>   {
>   	struct pdom_iommu_info *pdom_iommu_info;
>   	struct iommu_cmd cmd;
> @@ -1705,7 +1706,7 @@ static int domain_flush_pages_v1(struct protection_domain *pdom,
>   	lockdep_assert_held(&pdom->lock);
>   
>   	build_inv_iommu_pages(&cmd, address, last,
> -			      pdom->id, IOMMU_NO_PASID, false);
> +			      pdom->id, IOMMU_NO_PASID, flags);
>   
>   	xa_for_each(&pdom->iommu_array, i, pdom_iommu_info) {
>   		/*
> @@ -1724,7 +1725,7 @@ static int domain_flush_pages_v1(struct protection_domain *pdom,
>   	 * See drivers/iommu/amd/nested.c: amd_iommu_alloc_domain_nested()
>   	 */
>   	if (!list_empty(&pdom->viommu_list))
> -		ret |= iommu_flush_pages_v1_hdom_ids(pdom, address, last);
> +		ret |= iommu_flush_pages_v1_hdom_ids(pdom, address, last, flags);
>   
>   	return ret;
>   }
> @@ -1734,7 +1735,7 @@ static int domain_flush_pages_v1(struct protection_domain *pdom,
>    * It flushes range of PTEs of the domain.
>    */
>   static void __domain_flush_pages(struct protection_domain *domain,
> -				 u64 address, u64 last)
> +				 u64 address, u64 last, u32 flags)
>   {
>   	struct iommu_dev_data *dev_data;
>   	int ret = 0;
> @@ -1745,9 +1746,9 @@ static void __domain_flush_pages(struct protection_domain *domain,
>   
>   	if (pdom_is_v2_pgtbl_mode(domain)) {
>   		gn = true;
> -		ret = domain_flush_pages_v2(domain, address, last);
> +		ret = domain_flush_pages_v2(domain, address, last, flags);
>   	} else {
> -		ret = domain_flush_pages_v1(domain, address, last);
> +		ret = domain_flush_pages_v1(domain, address, last, flags);
>   	}
>   
>   	list_for_each_entry(dev_data, &domain->dev_list, list) {
> @@ -1762,13 +1763,13 @@ static void __domain_flush_pages(struct protection_domain *domain,
>   }
>   
>   void amd_iommu_domain_flush_pages(struct protection_domain *domain,
> -				  u64 address, u64 last)
> +				  u64 address, u64 last, u32 flags)
>   {
>   	lockdep_assert_held(&domain->lock);
>   
>   	if (likely(!amd_iommu_np_cache) ||
>   	    unlikely(address == 0 && last == U64_MAX)) {
> -		__domain_flush_pages(domain, address, last);
> +		__domain_flush_pages(domain, address, last, flags);
>   
>   		/* Wait until IOMMU TLB and all device IOTLB flushes are complete */
>   		domain_flush_complete(domain);
> @@ -1794,7 +1795,7 @@ void amd_iommu_domain_flush_pages(struct protection_domain *domain,
>   			sz_lg2 = min_t(unsigned int, sz_lg2, __ffs64(address));
>   
>   		flush_last = address + (1ULL << sz_lg2) - 1;
> -		__domain_flush_pages(domain, address, flush_last);
> +		__domain_flush_pages(domain, address, flush_last, flags);
>   		if (check_add_overflow(flush_last, 1, &address))
>   			break;
>   	}
> @@ -1806,7 +1807,8 @@ void amd_iommu_domain_flush_pages(struct protection_domain *domain,
>   /* Flush the whole IO/TLB for a given protection domain - including PDE */
>   static void amd_iommu_domain_flush_all(struct protection_domain *domain)
>   {
> -	amd_iommu_domain_flush_pages(domain, 0, U64_MAX);
> +	amd_iommu_domain_flush_pages(domain, 0, U64_MAX,
> +				     CMD_INV_IOMMU_PAGES_PDE_MASK);
>   }
>   
>   void amd_iommu_dev_flush_pasid_pages(struct iommu_dev_data *dev_data,
> @@ -1816,7 +1818,9 @@ void amd_iommu_dev_flush_pasid_pages(struct iommu_dev_data *dev_data,
>   	struct amd_iommu *iommu = get_amd_iommu_from_dev(dev_data->dev);
>   
>   	build_inv_iommu_pages(&cmd, address, last,
> -			      dev_data->gcr3_info.domid, pasid, true);
> +			      dev_data->gcr3_info.domid, pasid,
> +			      CMD_INV_IOMMU_PAGES_GN_MASK |
> +			      CMD_INV_IOMMU_PAGES_PDE_MASK);
>   	iommu_queue_command(iommu, &cmd);
>   
>   	if (dev_data->ats_enabled)
> @@ -2606,7 +2610,8 @@ static int amd_iommu_iotlb_sync_map(struct iommu_domain *dom,
>   		return 0;
>   
>   	spin_lock_irqsave(&domain->lock, flags);
> -	amd_iommu_domain_flush_pages(domain, iova, iova + size - 1);
> +	amd_iommu_domain_flush_pages(domain, iova, iova + size - 1,
> +				     CMD_INV_IOMMU_PAGES_PDE_MASK);
>   	spin_unlock_irqrestore(&domain->lock, flags);
>   	return 0;
>   }
> @@ -2628,7 +2633,9 @@ static void amd_iommu_iotlb_sync(struct iommu_domain *domain,
>   	unsigned long flags;
>   
>   	spin_lock_irqsave(&dom->lock, flags);
> -	amd_iommu_domain_flush_pages(dom, gather->start, gather->end);
> +	amd_iommu_domain_flush_pages(dom, gather->start, gather->end,
> +				     iommu_pages_list_empty(&gather->freelist) ?
> +				     0 : CMD_INV_IOMMU_PAGES_PDE_MASK);
>   	spin_unlock_irqrestore(&dom->lock, flags);
>   	iommu_put_pages_list(&gather->freelist);
>   }


The logic for checking the gather freelist to conditionally set the PDE 
bit is a nice optimization.

Reviewed-by: Wei Wang <wei.w.wang@hotmail.com>


