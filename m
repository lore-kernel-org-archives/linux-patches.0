Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBFEF60266;
	Tue, 13 Feb 2024 17:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707846649; cv=fail; b=F/WulFn6VUP02iprmafATuZ3hlGZ1JV1tmlTYhD6ZQcgJQRDmAgjOR1nfUJ5DUqeSW+18Ld2CGeTg+WGP/xUbMzLI8qd8cknxnRDgd0ECrDtOSbkWS+F9RrS9cQJdi9FlqNXM/U3UypzK2LyZvroY7GO+WNWFIv/tHQbh6Ga1F4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707846649; c=relaxed/simple;
	bh=xpJ/FomTTBMfAI4fzRuwCRglKLrAWnpxh+VFOBMlChk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=VMGbuGzZaykYx8Zq/ihDGVEXR5B/QSI8HAv1M9j9e4fCTZ6L5HFK3tPF/iugy35LSt38jqjttLvcIEBE5ko7dxfB6t0Xr8PGoxn+E68nm2h1uPPkkxiot3KQdfUGK4E/01uiga1h+2dD58SORy4X3Lj/883W3q/6WBP8vVh6n4Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=p2pym76B; arc=fail smtp.client-ip=40.107.236.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="p2pym76B"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KBjCmn54R5FKqu/hSiG1zS6Y+SQQ83aSePcUXWx2reSlFL5C0W2r2tQjZB+ZMl82tXMTMbGLJ8aF9cV+9/GVeMBcI1uDwfSb4XhG2FJkTv/gN9qwPriibj9xB9qc4I+4a604HB+ZYsLOBp2gxJo3ktBfRdU8SQwre8BYhOEK6fHkeifAuWnK0zFKpjzKaofzo2PTpHHbhEIDS5VKHLLCpZrvmw+S1D4fHNrIzXNZ1WTJ1lD73wMfAXV/tMJRP/ItmDV/wTGAyj+qsxM5Is1ny9xz/KKF9toiRof8YB10EuBYlVC3qGNleIwBEw3s260Rr2FzhxzjKm3WPTiFnfEQxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1hgJZtjf4tNqKcFDnybAEonklDTtvJDWpJY56i5sJOc=;
 b=RtkZB70XGFdR20Fe8NY3jd5GKUdhSUSDKyfQBqmXDg1YylONuH3ilBSutBpeg66in3KRydgBKrtZ0tSvgpLo/W05ZNWjxXGmoOWma8YojeuN/qti6vRueOroG9iiRh5PihmYPgAd1l0k2QcZ++ZP01/rPBd6deP2N/N2o9HCj1Pb07vqq1OI3ZrLAc3muFO56XtXFlQzHB9lQV2XkE2ZItCbjQdlZUMIzGMWCOomzj3MHMphFKGFPCnGo9xiwGQVMP2l4+nt52R5n1rtth739+brxvbWM7EnxymwCk4QLTgZ8DKw0nV0CZ7cBrY9rWIm5a1SuzqQ8iocreB4IgPzHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1hgJZtjf4tNqKcFDnybAEonklDTtvJDWpJY56i5sJOc=;
 b=p2pym76BGaDToZpLOraLIdJZOgG31zNgPjUHCuIgadoOYr8usF3kGd6JXbX8FDxf9iMufidjzY95Ar+MiRNtjMngilJJ8apNF3dBEtLHBO4Uur/rbpn7AA1axLcDDccH7KJPeL8129ezLddW1snra58AL/a5EHkeLv7dfqbvFFIkM7XZ5KHoBCORlJOd0aTIxyFAe31YJPjWvdovCe2ZlkujTHn+6cAdesexObHcIPtlRTYRvFF0E1EISTf4GlvKiW6VA487VlmB8cVkXx7u/XHHjcgsaBZVR7QOfHZWQCi/b4F961bxMO3Jt7MnDuetOJOqvcCsFwTL1pDnT/ScHQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DS0PR12MB7558.namprd12.prod.outlook.com (2603:10b6:8:133::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.25; Tue, 13 Feb
 2024 17:50:43 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7292.022; Tue, 13 Feb 2024
 17:50:43 +0000
Date: Tue, 13 Feb 2024 13:50:42 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <jroedel@suse.de>, Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: Re: [PATCH v5 09/17] iommu/arm-smmu-v3: Put writing the context
 descriptor in the right order
Message-ID: <20240213175042.GF1088888@nvidia.com>
References: <0-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
 <9-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
 <ZcuN_YZBzxJ2wvAg@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZcuN_YZBzxJ2wvAg@google.com>
X-ClientProxiedBy: BL1P221CA0013.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::11) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DS0PR12MB7558:EE_
X-MS-Office365-Filtering-Correlation-Id: fe5cacf4-8c0a-41a3-ad84-08dc2cbc4caf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	DZt5BxkjcyyXnu1/uf16XNJH3jsTpRXxuQsoMAhh4Gm1CtW+cBb4h1SadJuRRmqwbVrsyHd9dhEh3/6C6Xkk0M75Bhdq0diSbKBqiSKFZifbgyekqAqIEMf8g4Qp3wETqndf2zDMR6uehz39P0O8Qxr/of2alRecH2R43rl1ghupmwK+49Au6z7tnl2o3rWiYEq2CNAGwpNwgpV/SyjH1+uSvO+4bEiff+BPd/ex/yr3WAfVcpjXg6YitV+tCIYX1Vkv2fsv8rtjjrIdRgVnwnysNElFFi651pK9Zh7ylqIPZECpPTA4J6ga8Bqla8oLrlcP8w3MvnxMV9srcMj073ic+vaQki3FDiEG5oPC7L2z3FqoG7y6C4VqCkzQxWmQa1rSPO7J2JtmrPlAorgFP7GzNMkTFTW8iIWwZqPhWApFrCayMF/CpttJPWky4syxx1YV8S/jAA3HfANOcXI8JJpvyQCI7F8TRbt4s87hSad13Ylxm0UPmhhzyZ+ftPIEW53qP9BpU5pdngR7YxxbveQ3ke/nYbFAKJ4QuVBpV9uJ12rcTAshC1Y9Va0vo7MQ
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(39860400002)(136003)(376002)(346002)(230922051799003)(64100799003)(451199024)(186009)(1800799012)(2906002)(7416002)(1076003)(2616005)(41300700001)(478600001)(26005)(83380400001)(5660300002)(66946007)(8676002)(66476007)(4326008)(8936002)(6916009)(33656002)(36756003)(66556008)(6506007)(6512007)(54906003)(6486002)(316002)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UG5YL2VXOG9NRysyZHV6ak82d2xBZlBxc0E5L2N6WlpTZ0RsL2pEZVpFbW9R?=
 =?utf-8?B?QkhBUVNhNm5vZXNjcGlaUnBhK094anZnazlrNEw2V1JkNTQ2WnhxWUI5djIw?=
 =?utf-8?B?dVlaOVE5eE04aU8xWWhuM0R1ZDh2bFVPODF1YjBNc3g0YWVUakpGb1NCUlo1?=
 =?utf-8?B?eXc1ZFhUU3gzN1NPQVNGZU9OVitOLytiaWQvUkxTQU9CWTVlTHI2RURYNy9q?=
 =?utf-8?B?MXgySXk0cyszeThDNzMydWNvd29xRTEyNnNjeTdybmN6MG8vWmdzeGM1bUEr?=
 =?utf-8?B?ekFJY3JrY0JhTWhTSWdTSGlDT0xvS2VsR09OQlk4OERVNHc3UTRBU05MajE4?=
 =?utf-8?B?dnNCVWhMUlNxeldvWVRjOGNvN3hlenB1ZjFZVko4MTJJQmh2cjlKSWlINENL?=
 =?utf-8?B?bWFxUm1kaW9hSGExbEJtNUJ2czFWdlhhajZBbCtqZ2lOUStHVGs3bW83dFo1?=
 =?utf-8?B?eFdRbnJ6K0dwS1drRlNRd3VaWjZISml2ZXdsRGtZdWxnS2lYYzBiMmY5dnJk?=
 =?utf-8?B?RHlMNDc4MHUvRGV1Um4xL2dOdXE4S25MUWhNamJVeHpZWTlIb1RaZ0s3Y29O?=
 =?utf-8?B?Rk41Ym9GaUxNMDBBa1U4clg4dmtQS01MYjdSRENCWUlub2lXRTl3ZjRkcjV5?=
 =?utf-8?B?ZUJ4MUxlN0s0cVNXNlNZZmZ1WDRxdGpVMGVrdUgzVnp2aVhET09tQ3hxK1pR?=
 =?utf-8?B?MlAxc01IcFVSMXdWSWpCOExnL0RvZ1VwY0x5WkhsbUhKRzhZUDZMelZiQ0Mv?=
 =?utf-8?B?VVdKbVRsM1NKV3NwaU9sZVFSeVFBYjkxNHQwN2VXaFoxbmIwWllzV3FmVlZ4?=
 =?utf-8?B?QjVkakxQaTdpTmV0UVM2TDFzTlpQaTBnQkZRblZqd1lHdVBlZnBGT09iOFVB?=
 =?utf-8?B?ME9hYlJZcTVpYnZNM2pCdHc5VGdqWUNFcVhyVUNjUnpNWHR6SGJWUXJVd2dB?=
 =?utf-8?B?Ryt0UjB3YmV6WFBrSkx4NkNBbGpWbWNKMFhDRkRuVEdUL2twRXVBelE2T3Bx?=
 =?utf-8?B?NlhPMWxEb01paGZNczRIbUlEQ1dIV0dZRkdXc2habUxLb1VrWDhTcTk5R29E?=
 =?utf-8?B?ZTZTMVEwbVN2MkJwbTNyeDdrSWMzSVlNaHJwc3phQWM3RU9kZE5leWROM0JI?=
 =?utf-8?B?d0RtSlhhMHNJSEUvbnhnMXlqUkdINkJDRkpIbU02dUxRNXVWS2NPOEpWWTZU?=
 =?utf-8?B?N2FHakt6K2tKVndPemczMllFQk52UE1lNkxsaHJ6NlZMb2JRcG5ZU0FzZGZL?=
 =?utf-8?B?aXdzcG52RUx1dFlsbmRpRW5UYzdVTy94TjAxZk1WM1VQV0JrZHNZMXdRQkp3?=
 =?utf-8?B?am5YbS84SWRqY1Y4LzA2dXBQclJpRmFxT0ZjVmhWRm53dmNBRlFVOWkvRFJ5?=
 =?utf-8?B?UjVEaTBlQWVoN0dhWFlFQjhKNVpQeFdkWFpJcE5NZEd4eFU1UEU0SVI0MXl3?=
 =?utf-8?B?ZWpUSVJhTStDTnBKdjRrZVdGb05uOXo2L0xVTVJBV2xCdlpQbGtLOHJSaWoz?=
 =?utf-8?B?OXRKSG4ySDdCeHgyNXhyUDhLYkVyTmpyaXJIZGZtbXVBemxXZk1xbThFa0ds?=
 =?utf-8?B?WTJqNjVQVzJUVkUxY2Mxc1hmbjA2NHcwcEhMdkNLeitaQ1hwWkM3MzRMZzBU?=
 =?utf-8?B?VDlReDFwc1FwSEdZVXdYdjFhZ1BpcEZvMTZMcWdrSGhjM3Rmbm9Wc0RzbThk?=
 =?utf-8?B?ZGkzeW9LVFNGcVY5c3NLYk5SRTJIV1hxVzExRzRxV2NFcGF1bmZINWduak5n?=
 =?utf-8?B?KzdXR0sxOGQvS29mQ08wNWQ5NHVMSEFlNzlwY3A3UTdIVkRIMWNCbXZPOFc0?=
 =?utf-8?B?cUtKNjdtNkZZUTYxYk8wZlVkb04zUEJ0UFVQYlVENlZRc2tZaTNTZm5sQlRr?=
 =?utf-8?B?UmdpYTF3UHJWU2oxYTNHaUZEYmdlSno1WjV5dUViZkxSb1BqazFOMHR2TGha?=
 =?utf-8?B?cGhldDV3elpwOUlwb2IrRnp1NHI3bTlLTGJxcDBiRTVUYzdteXh1MlRGTU1l?=
 =?utf-8?B?eEtiRjlaTTltWURwZVptWWhqSEtIaVhIQUh1N0R3VVJQVHNpdkxISHAzL1FV?=
 =?utf-8?B?MERlN05OMGM5eGF0SEI5WVB5dkExTGpkbm5TZzYyOUtmRkZtNzVIcGttWGRk?=
 =?utf-8?Q?3owijpEd9Ad01IG84hzQCEacf?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe5cacf4-8c0a-41a3-ad84-08dc2cbc4caf
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2024 17:50:43.3192
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /JTA7K2oVRh+mzFJnsIcIZqdzlWAGDwWOnTx7ytnacqTzOpR5VdNgyFBxXMNwdun
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7558

On Tue, Feb 13, 2024 at 03:42:53PM +0000, Mostafa Saleh wrote:
> > @@ -2659,6 +2651,17 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
> >  				master->domain = NULL;
> >  				goto out_list_del;
> >  			}
> > +		} else {
> > +			/*
> > +			 * arm_smmu_write_ctx_desc() relies on the entry being
> > +			 * invalid to work, clear any existing entry.
> > +			 */
> > +			ret = arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID,
> > +						      NULL);
> > +			if (ret) {
> > +				master->domain = NULL;
> > +				goto out_list_del;
> > +			}
> 
> Instead of having duplicate
>            if (ret) {
>                master->domain = NULL;
>                goto out_list_del;
>            }
> 
> In the if and the else, we can just move it outside.

Stylistically I often try to avoid shifting the error path from its
statement, but it is OK either way..

However, part 2 removes the need for error handling here entirely, so
let's leave it.

> > @@ -2668,15 +2671,23 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
> >  		}
> >  
> >  		arm_smmu_make_cdtable_ste(&target, master);
> > +		arm_smmu_install_ste_for_dev(master, &target);
> >  		break;
> >  	case ARM_SMMU_DOMAIN_S2:
> >  		arm_smmu_make_s2_domain_ste(&target, master, smmu_domain);
> > +		arm_smmu_install_ste_for_dev(master, &target);
> > +		if (master->cd_table.cdtab)
> > +			arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID,
> > +						      NULL);
> >  		break;
> >  	case ARM_SMMU_DOMAIN_BYPASS:
> >  		arm_smmu_make_bypass_ste(&target);
> > +		arm_smmu_install_ste_for_dev(master, &target);
> > +		if (master->cd_table.cdtab)
> > +			arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID,
> > +						      NULL);
> >  		break;
> >  	}
> This invalidates the CD while the STE is in bypass/S2 which is a new behavior
> to the driver, 

Yes

> I don’t see anything from the user manual about this, so I
> believe that is fine.

Nor do I. Nor can I see any reason why HW would care. We also
invalidate ASID's and VMID's after their tables have been removed from
the STE/CD too.

There are other options here if this is found out to be a trouble but
they are convoluted enough to not do them without a concrete reason.

Thanks,
Jason
