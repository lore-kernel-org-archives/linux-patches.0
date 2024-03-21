Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2070.outbound.protection.outlook.com [40.107.244.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 703909468;
	Thu, 21 Mar 2024 17:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711042358; cv=fail; b=Uurp50oBr9qyIBV/1oawgGycpgU7tDHU/F08Uhj3zDGtlwOOIGq8WLzR7E+UI7x3Vt8e5e3dW0YdJHENheNLs4+tY+Rxu/1qxrBkg1AQY7p62mRIpxPP2wBt6zEGkhSPlsqVvfxMlSvQHD4MGW05zElunc3Ibipubmnniv2XO0A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711042358; c=relaxed/simple;
	bh=/pDluwAE5YzAm1cxkhM0MpFw+bz/bSC2q4vu7KgpMHU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=XPnMwlq0/qRK990pzC/T9S8fi32kOTjOxZWIU8le1XAFoHt6Ow6pZqFV+YRu8tHWTpoQAancK7+fWGiq3PBqJFZ5jcljRlEd/IeoMpNDfgAC967aLvo+jIxlZ/1QkTc/rjoFOaHahcWIF8plOr2BL5pIPICq0ljam46Y203VCM8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=EgNzmWNM; arc=fail smtp.client-ip=40.107.244.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="EgNzmWNM"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hHcGny/IjM8HSkgamFWacPO7YnKiShQXcsGDxxEZDVlbZ6b4/R2/z395fkENeUN29WpcVyWKyHIY83spYJes+dKLlqDWXAShhe2ZRbnPtyphmx0JU9+dv9soIq4/LPZ9m4WNNKF68iK66kaLyZldz/XGX4RA1+vmoC3UxPXKVZEcXVGy7STIjEeI5f1ZzVIaO6470sfhDBc/Uy4gAYe/Iipze80DYS0G6XF+SLSccZm8v7ZupcDAmHKQcMNMzYPzsKZDFd9UX11W0WbP9ws67tkMX56j1vPl70UJGUx29Rwq6bXIIsmsGTC+rAN/OeLNvUU1pB98D6rL07PTdEeQFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lx34rZOUTYnKnxDeHAKD6ihqpn0FmS4OQPjKRgX5ttg=;
 b=aGWSjVr5efScBJPAed5wn8rxka/xLqM59Uk9GHlQ+0fmUvmIrMJtoQSMvA4cH7OgZMxSDBpnHF5OrY9Qe7KnwsdSUw8Wu+fZD3cm3rmfVOCKGCTiTwM/jRXQlnjZF8qlmCXrgO9DvkYyYVFQT8Uc0OVx9mWD9SLJPrXTBRulnD3iMWZ5f9HqHD5evTYKaUzokelVr5+s8reORHNtG6k8sgYk1i8UpvsMQW/zJpYW3JnZet5SbC1WZTc4ot9+fdgpTNINLFDudC2si5oRTwc+zdBQlsE50oq0GZkwhXx4HxlSlL9m+ovCsQrnUw26cQF/DziIC77um0y93qr8JeUqUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lx34rZOUTYnKnxDeHAKD6ihqpn0FmS4OQPjKRgX5ttg=;
 b=EgNzmWNMndTQgZZ9TaFmv9qgflSig8+6RiQIp/mrTrWzK0a8q2spyz9+5S5xAY7J/4+fmnkmE5O+t0Y5Qu55Z4VLBcw0K2LUjIOyHHP0MuAPl3KC703c5g7yHt6MwOmPGcKCl79LOT91bX2Br583HNo05bwzlHUGq4AgQQKZsEDNnfFdxY5BKla6mKnl18gb40gBZGWGy3TZkC4Taarg4fcxqda6VxWSnpeNjweBSHIA2IVJU4bqQcYC0z7whM2QTUMMhzfwDmtUI30B3E7pcQzvxYIcmNb9GwcY0UXITVe9XINp87CcvcdzOEpIXZ7nitKsEjT1c5OcOVLKQGfcUQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by CY8PR12MB8297.namprd12.prod.outlook.com (2603:10b6:930:79::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.34; Thu, 21 Mar
 2024 17:32:33 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7386.030; Thu, 21 Mar 2024
 17:32:33 +0000
Date: Thu, 21 Mar 2024 14:32:32 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Michael Shavit <mshavit@google.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>, Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v5 14/27] iommu/arm-smmu-v3: Make changing domains be
 hitless for ATS
Message-ID: <20240321173232.GM1044235@nvidia.com>
References: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <14-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <CAKHBV25xx51EuDXK91-o9BnFq5TZ66TAPuZ4YEdJ1UPq8sr7ZQ@mail.gmail.com>
 <20240321132839.GK1044235@nvidia.com>
 <CAKHBV26dSY+Gy-x9HTWVCcNMyAkB1g+Y+dv-Lg+-furpu9bnSw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKHBV26dSY+Gy-x9HTWVCcNMyAkB1g+Y+dv-Lg+-furpu9bnSw@mail.gmail.com>
X-ClientProxiedBy: MN2PR01CA0038.prod.exchangelabs.com (2603:10b6:208:23f::7)
 To DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|CY8PR12MB8297:EE_
X-MS-Office365-Filtering-Correlation-Id: 58cb20bc-7a82-4525-f042-08dc49cce443
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	229HL6R7LbCT/0QGSQCnCLoc2VlXdxiRsDUK9M6L8nXua4MmDZYPQjusZfxUvJhZfvLN1Fzgd9B6TAIVvvI96qO3c5m/vFPGZW80h7AS3F022hPeUQ558vgXH9HDn9208nS6Bc5616T8A/vq5b9HdGRozSjkGyLTBOwSLi2Nz34Nhv4kv+7Noo//xuPN4Y/hqvN4V1HvvF13JYpX0ev4/k2/7EamY9UyN1k5gYiSwD8OfFbic9QnB8H09VE5xVC5cDfhYZ1+EhDTPKAbWjREnfoEjf8Mkr+r2LWoiXsi+1mAiUNGDG7AIpmKe6nfg40oUJuHH1D50Bvyzh0knO6U5IrkvOUiWpr6wfeGamhj1cw5ZcMcEojPwtRRQCaZ8rFgBzj9F2szk8NUJcfBUaaCcXAWQHPJSJY2qT0VnZKnbm+PdkR/xbzcYSPyGp6QzdeMHwiS/3IoQ1rMXl0oz5SV3IGKf47iYv2uck3cjLjEsKLmyAUZEOs9xDr5vJgVX1gyQrd63sNGbmdzyOk6zLdyiZfvcEQ2F+hVD5NN1xWbTcSUQ0rngStjNShVvJJGKk0mR+GfCSYOrgWfaBPLMGHmVG8RYqnqqEtO5sL4BcT/sVIk3PmeFAKBJIu3Vsa/7Jp9slzZTSUqJMFPDcEVfkq8OIGbr722IP99kJ7c6daCnIQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(7416005)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?amR5a1dPUTNRUzhsd0xBYXhjQndGeWlySERLL2ZXdllsczQxSWRTRHhaOUlC?=
 =?utf-8?B?TjBYMTBpcDZFVGpDQVRTdU84cGFVU1pUNDFmamNRNGZ1SXU0b0hUVFpzeUQy?=
 =?utf-8?B?cUpvYytXQXB5Y0J3eWY0NEw1bGRjTDhyaVM4ZGl3cENQOUF2dGl1SnViNFVC?=
 =?utf-8?B?dzk4Z29iWWJLU01ERWJicFlLREZjNVBBWStTNzQyTHlVM0p0VWh0U3M2Zjly?=
 =?utf-8?B?YmdqWTc3WGhiLzUvdjZwZ3duaHZOYzNkUXZLK2lGM3Jjb2g1U1grdW5vN29P?=
 =?utf-8?B?NmZTT2V3VFNBbkJwRTV2Q0JvZnBlY2p3RXFNeVVLRHVaaldBZFdXVW1YUXJO?=
 =?utf-8?B?WVRYWUNRMXljcENzVHBGOGhXQmJiOE5YZCtXTGZQdFo1Ulc2aElQWGF0REtn?=
 =?utf-8?B?b0N6cVlvWUtzc2RuZ0dla09RRG1ERnFLNXVicDF5K0JMTmNWbEEwLzhicGlP?=
 =?utf-8?B?bFc5QzVydy9UMkx6OEVUMUdQdnBCeFd5N2JZcTc2WmZSVFdCdHlVdXFkcm5Y?=
 =?utf-8?B?NVQ0VkJIWmhmQVFjUExub00xWFYralRoTmlyNDVzVGY3ejNZaGd6RzBhS3Ju?=
 =?utf-8?B?Wno5cFczUUhlOE1WV0tZS1pzbjFuTkt3aUo5LzZwSVNGSkNmN2t4Ukg3c3J1?=
 =?utf-8?B?cVZsaXBQRm1JWXdjQzNPMzJOZGozRGs3dXZaSWRmUldYaEtxNExTejZLNWl2?=
 =?utf-8?B?NzVUS0lvSXZPYzNNTUhWc1R4b2UycFVWdjEzNXRoeVJCYlRlOFNkTW5Lcjk2?=
 =?utf-8?B?N0UzaStTTjFabFVCTkpwT1dJcC9vUkF3eUhhMTNWVnNpMk1FaEttaEc0a1FC?=
 =?utf-8?B?TlhacGt6R0xTdUxrS29xeWZBWGplVXhpYVY0WnlkODY1b3FKZmhuY0oyQmJI?=
 =?utf-8?B?WlNiVWJRbHNNSXJwS3V5Vk9uRUpDZDNyeGx6bWRxaGF0KzhhS0FrNUJSeDRv?=
 =?utf-8?B?WVVscmZaQlJCdnF3TlVoZ2ptVVAvdHZPektOSCtXL0wyVmhmOFM0Z3VpQllG?=
 =?utf-8?B?VTVSaFRDZlljZHNqQ1hYU0kyU1NpYnp3MEgvOVpzZk82L2NiazUzdmdIdjNs?=
 =?utf-8?B?SXlZVXVja1FWVG1jTGdUMWpFWXEySDR0OUM4VmtFdzlGNVRrb3ZveHc4bkM1?=
 =?utf-8?B?ekJTMGczY29TVG9rSVd5RHloOHZkQnMvcXZLS1NoSDVNSmtCUVFLazdlRGtu?=
 =?utf-8?B?Q0pUTVFYdGJITWl3amJjNGNiTDBvd1JHREkzaWlpbkFPbUc1Tk1maDNkb3hs?=
 =?utf-8?B?aFNib0J4ZlhZbmFkWm5NQ0lacDNHTHBkSzRqM3NURUQwdHF5eU5nRHFkTHhu?=
 =?utf-8?B?czllZXQ2a254MG9VcHJZVUUvNHZUNXhJS09QTjFwbFFybWpVM2NDMmp5NFZE?=
 =?utf-8?B?dFVqeTVPSldIWkhBZWhBbHlZRjh2STFxalRnd2ltdTNmSEVoazhqMWRSUEph?=
 =?utf-8?B?YnNtODQ1b0VGUlEyT1pWbFJTVXF6cEtRNzliak9FYjBuSWJCc3pUakpuNE5j?=
 =?utf-8?B?ZjJXd3BybnJxYXZ4VXRPTXhwSmhCV1R6NlJNMW5VOGpCbWNHT3E5MFo2Y1dj?=
 =?utf-8?B?eDBHRFdMa3NrS0FpUHFnUldkaTFFYnJWK1NRbWt1Y1labHAvYVpVc0VwRnQr?=
 =?utf-8?B?VjJZdzVkQ2ZrV3c2Yy9QQjhVOHFjWVVseXF4WnJrM0F0S1dFZTArOGpFYWZq?=
 =?utf-8?B?Kzl6dTZicEFSbXJWbHJ4a1Q2NnAzZXdSNVV4ZGM2WkRZK3hQU0dnVXdKazlR?=
 =?utf-8?B?UjFkY2xtdUxNam51WG44RWNRK2M5cEF0NFN4K0hkSU1XYm91Z3pBNnNSU2tu?=
 =?utf-8?B?ejR2bHZ5K1lFajZuZ1RkeU5SWVppZWFiTC8vNFcwRkJNSWxLcHlEbjFOQzZ1?=
 =?utf-8?B?SmEyWSt1SDhKd0d6SnQ3ZWNLN1YyaEl0TnE4MU14dzNDdVNLL2IwcWtpTTdV?=
 =?utf-8?B?bDFmWjFBNnV6OHBkSmxDbUZEcEdpZUNlSnpsQ0I4ZUY3dnZGNkhrZ3FsTFo2?=
 =?utf-8?B?a3pQMlRqRWpRNjJWcDBLcVNTbllPaER4SmNtNjNoNHNhUFkxSmdRdmVETjFs?=
 =?utf-8?B?Yno2WnNDSi9meERISUpGRE80cjE1d3EweURyM25veEFjdVZNd3cyR3JZVzJz?=
 =?utf-8?Q?rQTFS/G6zP+nuzqG51xjL/AvV?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58cb20bc-7a82-4525-f042-08dc49cce443
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2024 17:32:33.2779
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7xAeaTLRrZxSi7nn+Cvo/yZxt+uxipmxRocEUApe0h2Bwfb+HS3cNRZ0MJnNp4M1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8297

On Thu, Mar 21, 2024 at 10:53:20PM +0800, Michael Shavit wrote:
> On Thu, Mar 21, 2024 at 9:28 PM Jason Gunthorpe <jgg@nvidia.com> wrote:
> >
> > On Thu, Mar 21, 2024 at 08:26:43PM +0800, Michael Shavit wrote:
> > > Overall I think the patch works, but it took me a while to really
> > > digest the big picture. Just to make sure I fully understand:
> > >
> > > We're trying to satisfy the following invariants for correctness:
> > > 1. Devices cannot get translations from a domain that was detached
> > > after arm_smmu_attach_dev() returns.
> >
> > Yes, regardless of ATS this is the API requirement.
> >
> > > 2. Devices cannot get cached translations from a domain after
> > > arm_smmu_atc_inv_domain() returns, regardless of whether the domain is
> > > simultaneously being attached/detached from a device.
> >
> > There is no simultaneously here since the group lock is held by the
> > core code.
> 
> I meant a call to arm_smmu_attach_dev concurrent with
> arm_smmu_atc_inv_domain (through tlb_flush_all).

Oh, yes that is the concurrency that drives alot of this organization

> > Yes, we can't just disable ATS due to the PASIDs. A SVA PASID might be
> > present and disabling ATS to change the RID domain would completely
> > wreck it. Today this scenario is prevented by sva_enable, which is
> > removed in following patches.
> 
> What do you mean by wrecking? We might slow it down to a crawl but we
> wouldn't be corrupting or destroying anything by disabling ATS while
> SVA is running would we?
> Oh does disabling ATS abort all transactions rather than making it transparent?

As you deduced, without ATS a non-present page will return an abort
back to the device instead of a non-present ATS reply which should
then trigger PRI.

IOW the SVA domain can no longer handle page faults and is effectively
non-functioning if ATS is disabled.
 
Jason
