Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2076.outbound.protection.outlook.com [40.107.100.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 948914C619;
	Mon, 29 Jan 2024 19:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706557760; cv=fail; b=fvXyfioekW3q9KK+1HKqVUUGH8zHSacYjxUbTxWjcjC6lawtqBBjPDzR/2cZ6TVMZXM6thPIKs31vW7Czo+Q3a9yiRevwZK1SRlAyHJbWHqdoTlt3bPdTnlhDbifD/QeUJA7akOEgp9znBRz914r6xDyJVh0BxJ+cj1xYjCvvPs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706557760; c=relaxed/simple;
	bh=4Yvwe5EyitOtYrtnvKa4RcAoSRSRYWvJOyYPXF7NFHM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=UVU3mvUq4beDswmaBF/8upz3xgX7TIkcZOpnjbACNgYbKbO3VMjAf6qOGwDVeQAyQI9xnjWqCSxlnnkTLkeHj9vZ1dJhvvxot7sEOySBYevjij2bJHCUpeu3Xpx/kIlEiCU+mkXqQFwF0BA5c9hT5DeXzxuk56XhqJOAR7X4R6E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hXujl4zS; arc=fail smtp.client-ip=40.107.100.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hXujl4zS"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kMxZmc5BCAx1cW1d5yqTf0ZtFtylFErZH0W7k/fX/u+0Yboy3CcJWloNqW1xb+redcRKtybZRz/SZcEoBd3UicmCMIUZVJOdjRHTW+MmdI2XeWinAYxknAPbZClLZde6Br9cTCFX9+Vyw3rhMiiRoOO9fV8iPxUV+AWkDdkTuk82UaNTA+9V4IDbmYKOD0JfYhzqULakdPUY7lsxo6djQnXfZ/PXvx6peC1EPxyAjZJxEcn457gQwbl+g4CBZ/74XNRNA5m01Fu9QgSUyZSc2MrL0xOacilElcVyEjOU6LrZr6hEahicupy/f3Zhz7B3nlS5S0Um0UN3/HydqZ/7SA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GXXjW3kE+8ToIPjtobXqaNrlQ5C6v4gCgowCwPpSSYY=;
 b=BLhNlhhzaAzkCslZwgqP9F4Z4XQI7xnTx3/ge1UDYZf8C9lq0uJMTH+tdTeWD7eAEzWmb0WLqL5n9czuj46/lFh2yGtii7qzjVE0DAhhIJMlvKYGTOH9dreR6XubkR86s5sicKHiIIzbVkPkjG895RNlUoLC+z9FAv0Z93efbuZ9sbiYEO0xHJblYbyVGTImzRYuZ8K5NndXKIRz6XJTywhmvul6ArZzOqmCLZvAg8VQSXOmpj/EfIFazzMYY6ezOJSl9ry7DJ5iO4Dd4/zgMgHwkXztLhwenz9YsuoG4wwTeFGhaweAi2el8Thet8lANVH1xfGtxMeruJBSyFOITw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GXXjW3kE+8ToIPjtobXqaNrlQ5C6v4gCgowCwPpSSYY=;
 b=hXujl4zS1KTX5D5/ADSVPqVmbMv5ki2BAB1XHUIkkPtdhcR4cGGepiM3YFVUyBTSmgFM+iMQoRBYWxiYyKzURXuwbeTuyHeHAVVMdEiJ99doGqK9R8aXdv7w8TRtFB6byrI3taqWjEkcJJlEzuTveupgika0o7YwBfsvOabZw8LfjK2eWZiwrC30Abp43qEI0SHgHuKMYe0WBvibY9SviIB5gdmJmnZSNXQpqhcTxIImt1Io0ZpwKireMA2UFfN3JMnO05WNITucVAC8wJb6d8Zpr2jHJgzlY7R5oDgn1EXXxB4ksZGap1Bmz9BQJr/XtSbyCvVcfOYMR127ipU9kA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB5199.namprd12.prod.outlook.com (2603:10b6:5:396::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.32; Mon, 29 Jan
 2024 19:49:14 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7228.029; Mon, 29 Jan 2024
 19:49:12 +0000
Date: Mon, 29 Jan 2024 15:49:10 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>, Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v3 04/19] iommu/arm-smmu-v3: Make STE programming
 independent of the callers
Message-ID: <20240129194910.GB1455070@nvidia.com>
References: <0-v3-d794f8d934da+411a-smmuv3_newapi_p1_jgg@nvidia.com>
 <4-v3-d794f8d934da+411a-smmuv3_newapi_p1_jgg@nvidia.com>
 <Zbf4NyiZtmjslDFf@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Zbf4NyiZtmjslDFf@google.com>
X-ClientProxiedBy: SN6PR16CA0066.namprd16.prod.outlook.com
 (2603:10b6:805:ca::43) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB5199:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e8797ee-90c5-457e-0b38-08dc21035dca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	WgGaalIrQoqTgXhxvXlpYyygnIuRcW0BgIKpGziWdUFXFJ7y4dL4KFetuPaDjCvDUSWGmDJyY38Q5RcPzN1XR0ZZqD7072VCDs5lbmkvTkrkrlyYfcvSWs7y8jfnOkFKtOqQ/ECtG0PQSqbsrhkIXsronws47PH0Hs5YPvKr1BIFaS/3n1Qko5ogO8PR4wttHbTHb+ga4Tu6wRiFgIZyVcL952OmK5THu4IZoWXLgvktsF4SbRNdCWouZPp4HKctckC5hZnkCSZAGmusWqBb6OPHKgpmFtCxrIjj06tqKzoAnWzg5ITfz6qzuBEcuB7tfnlzE3RwRp6x2kp521nEM8/L+wZNjAARF/7mRJ+eH+WwewglkV+Jldxx0gkK2SWZ9yr2XVY98LvekEM95BDrjjt3uLes/YBoYwBe/oI8VO+5x/bKi5SITn5+OWXzAeGgS9UMvCy6ObNg9mwmA+4XCpBGyGAElSxuPS/LIm98wOD+63pV6aMz1asiDXrMNxkouwuYczkmj46cR0UmEvd/RtT2a4TS/ivpsCRrLF3RDRCBdOH8gNOOxVEdtwQhP6kP
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(396003)(366004)(39860400002)(346002)(230922051799003)(64100799003)(1800799012)(451199024)(186009)(83380400001)(33656002)(86362001)(36756003)(38100700002)(1076003)(26005)(2616005)(7416002)(6512007)(66556008)(6506007)(2906002)(6486002)(6916009)(8676002)(478600001)(316002)(66946007)(54906003)(41300700001)(66476007)(4326008)(8936002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WlNRRUh2ZzNJOGxJUEIvbU91MkNXZm1BNU5KSFR4NVA5QkJNK3NnbVRJdmky?=
 =?utf-8?B?RmdZTE5lM3lGSDBNakxVbW00M3pkNjZta1FCMWpBaUtXRndqZ3dSeitHekND?=
 =?utf-8?B?QUdVQ21KZDVHcitGRW9haDNvc2JqeE8zamE0OEVJVzVYRW01ejVqQ25Vc0Nr?=
 =?utf-8?B?Zm5IS1hpZTc4amczbVlQR0FjcG5ldVVMMVBtdFpPWEIrZHdhMElUekg1OWdN?=
 =?utf-8?B?Y0ZwQUZacW1nR3NRa3JQUzE0TWVvVlE3UmFVWmhMeDMvdXJ2SUw2SzBrL1pS?=
 =?utf-8?B?QU5HU0FSTkNjRE9ydFpHTWZnTlBkT3czK0M3dTlNVUF2ZnF1Z2VPNjJqZUNS?=
 =?utf-8?B?WFhJMVkveThqWTUzM015UENFUzh5NjhOV2YwcVJsM3AwVTFaV1o3QWhCQmdJ?=
 =?utf-8?B?cFhZL0tUWXcwQ1JGb09aNStxSFNUZ0NoNXgrSlc5OHplc3BJQ2tyVWZDaXlC?=
 =?utf-8?B?eEpkM3ZZamltbTJuUE5FK1pPYWo4cUVjRjdyZnZEaUU0eHZ2L2hFdTlBYi9Y?=
 =?utf-8?B?NTRoWWlFYVJGanh2ckxnNDROYVJOYkhVSXVHQzJQTjBCZkhuSWRvdmNlRzJL?=
 =?utf-8?B?QWhQSkJKcVI5Mm5GMlRKaE1DbnZyWWJYZ0poeXYraStwdnU3d3BIVmtkdXkx?=
 =?utf-8?B?d0R3cjZOYWVNbnhGNUg1YW5BYTFYN0cvSnhZZkc4VVNJYWw4cEJpdnZqWldI?=
 =?utf-8?B?M1B3dXNDMHB1NWFvbDdHN0FVZGRmNkR4V01Ca01ZdFZ5L3YydEVYU1NoaHJD?=
 =?utf-8?B?VE1wMGpmSkhuWFgzaTVFUlliTHR1UTQxOEhxckhtdWhpUzlmYlN4ZUlwNjJC?=
 =?utf-8?B?dS93b0FBaVhPUTZmbUt4TGdubFZmYUFmSGF4SWhTb2ExaWFvUUlMb0UrZzFC?=
 =?utf-8?B?VERJOFVmbGwvZkE4aXF4ZFI1d0NSN0NQMEZwL2p6eE84NkZWa2ZCNU9BOGND?=
 =?utf-8?B?OUF0N1pvdnlHTTVJUGptbFExMEtHUnZQVFEwMUYwOStIM3FRRC9FYlVzeXBJ?=
 =?utf-8?B?UmlJNDNCSkZ2NlBEQ1RYMnBJaUxCTG5FMFpvM3VsMXBmbCtYTmxxK3VGUWtr?=
 =?utf-8?B?RU5EcDFJZlpTQmhSQXA3SHNVczBoYmpnSmJhTlVrWnFvMDVESEpIelc0VDVw?=
 =?utf-8?B?ZXE5NVp2a1h5UGFpMENQUThPbXVKUWRVWkVRU2pGN085azhVUERuK3JGcXA0?=
 =?utf-8?B?T0J6ak1sUHU3OFc2MVMwTkIrWXhiSXY1QnA4QXpic0FtdldlY2hFQmk0cTRv?=
 =?utf-8?B?QmZabjA1RE54VlZ5WDNKV1I2NzN2bGc2aVNQcjBjWTVFMzJUWHhjZFFRaDlw?=
 =?utf-8?B?aitGM2xxV1BtUHp5S1BjY0g3cERHTEpsSEpsbHVVNUlEQ2NCd1E5Wk1Ya3Rw?=
 =?utf-8?B?L2tZYVNLTy8wK3llS2U5RmE5aHdXdHJ6Q0I5dTc5U2NJdkNiVmlKT2NIb2JC?=
 =?utf-8?B?bUtDSFNUTDZRenBma1cxdHEwVmEwKzNQN3M1NmM2b1JSbXFIZEhWQmt1NkJR?=
 =?utf-8?B?VDFhL3E5dUt2MXNFL2VMd1pVM2NvaGJxcno1U2htZUVma2duMlJ5TjR5cGg5?=
 =?utf-8?B?Zk5rTFBLekdpa0xLaW1sTXdMKy9mOTZVR1Q5eU1TSGp3aVdIcEI0UDYwYW5m?=
 =?utf-8?B?Z1JuWEZqOEdQVE81Vlp3bUJpemZxREhsRTR1L3NzcUFjSHdxcGVWcEpWZ0JW?=
 =?utf-8?B?ZFdVdWJtK0pselpUdzNCcVpwYzhZa2lSQ3FvRm11cDhpMjZDQlRsZ0tOcXpw?=
 =?utf-8?B?TmkvNk9Nb29XZDNtcVppSzdhK3h3QXhTZzlwZWNZZUUrdEkzZVN3dDlsM2Zx?=
 =?utf-8?B?dmVyMzFKUTI3VGZBNERqSTlIVnYvdkl4aXE5a3NlTG5Idjd0Q2s3cXZqYldD?=
 =?utf-8?B?YW5POFR4NFZ6T01XV3BOd0R4aVF3T1UxNElIRHM2TVlwYWkyUCtqdXFCdVVD?=
 =?utf-8?B?QlZWZjBnOTdEaDh0UVNpekh3VlhtSkpFZC92T1ZXMm9WRkhVVjcxeHkwL1RU?=
 =?utf-8?B?czlPcWFtaXZLTTZRTTlMTDJyb2Z1RU9zNzB4aDNxTmVVaGZxNnhzVDBNbmlP?=
 =?utf-8?B?Q1FXK1M3T1l2QWtjbTZEQmREckhLeEFqSFZOWk8xNXRRZHlxUWNHYUcxTkRr?=
 =?utf-8?Q?/YTZoReIvdhGjjrLL28+5jsyv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e8797ee-90c5-457e-0b38-08dc21035dca
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2024 19:49:12.2900
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /MV6gfLeKPWL+4jP3bmZiYk3g8x1jzCbM1u+vBbt0CIrKOEwqzXZm9pgLAgg/nLx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5199

On Mon, Jan 29, 2024 at 07:10:47PM +0000, Mostafa Saleh wrote:

> > Going forward this will use a V=0 transition instead of cycling through
> > ABORT if a hitfull change is required. This seems more appropriate as ABORT
> > will fail DMAs without any logging, but dropping a DMA due to transient
> > V=0 is probably signaling a bug, so the C_BAD_STE is valuable.
> Would the driver do anything in that case, or would just print the log message?

Just log, AFAIK.
 
> > +static bool arm_smmu_write_entry_step(__le64 *cur, const __le64 *cur_used,
> > +				      const __le64 *target,
> > +				      const __le64 *target_used, __le64 *step,
> > +				      __le64 v_bit,
> I think this is confusing here, I believe we have this as an argument as this
> function would be used for CD later, however for this series it is unnecessary,
> IMHO, this should be removed and added in another patch for the CD rework.

It is alot of code churn to do that, even more on the new version.

> > +	used_bits->data[0] |= cpu_to_le64(STRTAB_STE_0_CFG);
> > +	switch (FIELD_GET(STRTAB_STE_0_CFG, le64_to_cpu(ent->data[0]))) {
> > +	case STRTAB_STE_0_CFG_ABORT:
> > +		break;
> > +	case STRTAB_STE_0_CFG_BYPASS:
> > +		used_bits->data[1] |= cpu_to_le64(STRTAB_STE_1_SHCFG);
> > +		break;
> > +	case STRTAB_STE_0_CFG_S1_TRANS:
> > +		used_bits->data[0] |= cpu_to_le64(STRTAB_STE_0_S1FMT |
> > +						  STRTAB_STE_0_S1CTXPTR_MASK |
> > +						  STRTAB_STE_0_S1CDMAX);
> > +		used_bits->data[1] |=
> > +			cpu_to_le64(STRTAB_STE_1_S1DSS | STRTAB_STE_1_S1CIR |
> > +				    STRTAB_STE_1_S1COR | STRTAB_STE_1_S1CSH |
> > +				    STRTAB_STE_1_S1STALLD | STRTAB_STE_1_STRW);
> > +		used_bits->data[1] |= cpu_to_le64(STRTAB_STE_1_EATS);
> > +		break;
> AFAIU, this is missing something like (while passing smmu->features)
> 	used_bits->data[2] |= features & ARM_SMMU_FEAT_NESTING ?
> 			      cpu_to_le64(STRTAB_STE_2_S2VMID) : 0;
> 
> As the SMMUv3 manual says:
> “ For a Non-secure STE when stage 2 is implemented (SMMU_IDR0.S2P == 1)
>   translations resulting from a StreamWorld == NS-EL1 configuration are
>   VMID-tagged with S2VMID when either of stage 1 (Config[0] == 1) or stage 2
>   (Config[1] == 1) provide translation.“
> 
> Which means in case of S1=>S2 switch or vice versa this algorithm will ignore
> VMID while it is used.

Ah, yes, that is a small miss, thanks. I don't think we need the
features test though, s2vmid doesn't mean something different if the
feature is not present..

> > +static void arm_smmu_write_ste(struct arm_smmu_device *smmu, u32 sid,
> > +			       struct arm_smmu_ste *ste,
> > +			       const struct arm_smmu_ste *target)
> > +{
> > +	struct arm_smmu_ste target_used;
> > +	int i;
> > +
> > +	arm_smmu_get_ste_used(target, &target_used);
> > +	/* Masks in arm_smmu_get_ste_used() are up to date */
> > +	for (i = 0; i != ARRAY_SIZE(target->data); i++)
> > +		WARN_ON_ONCE(target->data[i] & ~target_used.data[i]);
> In what situation this would be triggered, is that for future proofing,
> maybe we can move it to arm_smmu_get_ste_used()?

Yes, prevent people from making an error down the road.

It can't be in ste_used due to how this specific algorithm works
iteratively

And in the v4 version it still wouldn't be a good idea at this point
due to how the series slowly migrates STE and CD programming
over. There are cases where the current STE will not have been written
by this code and may not pass this test.

Thanks,
Jason
