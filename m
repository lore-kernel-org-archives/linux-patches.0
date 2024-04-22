Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2064.outbound.protection.outlook.com [40.107.93.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FDBD14F13D;
	Mon, 22 Apr 2024 13:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713792601; cv=fail; b=MHJLTIiFMhcHvQeYNqnGFiUptPKisyLGk6z8BPAQZ8Wj4UDCZm0fFoKyHFrn44AVMPMBLW1wkHAMYiz7QbPXfq4qPCeFlHaiTi1T8Z1ulYIPUgMTTd30KeemfF+Zj1dUlqWja7jH9bNUrw2dlG9Kb+1UlsZyQ9Ss/xyqvXZVKtI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713792601; c=relaxed/simple;
	bh=Z1UC831m6ON6g5CGIl+6RJ8iTNubs42s9z41Vy90ckU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=PqMfljOJ1Q7W6KULvF4i2JaCBvXXQ876JYAQp/kvHBsyNSmBlw6E7cz9nP7fibZp3bRJjTsC07UzkW7z/DIjjJe7IIC0AN77oeN1lc2b5q2nATBKK1Cm45+EdSle4lvNEZpX4u3uUhrOE0XEZLp55s24KcgvVL5LQXrx8/smYdo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=GB0AJqrN; arc=fail smtp.client-ip=40.107.93.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="GB0AJqrN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=URgQd/ak4jnSIFTexNxBM4IQfYnEK18XN1ZJLLc/gX8nafJ4jJf4FhvMPWPhN0JD3Gdq+KsFTpQoYnKDB54ulYuOWeB+dfGVCYJvXpnXFO389ZBemtuuHYwT3LkLtac/L/hxmEX7+xp9ryQDxccHD1Tx5EUwxmo2dr/UpSTP+dshWjc8BV8YUJpf2YZOMNxxw6U4izolp0NRnrmO03LFxk0ZE8E7l5HudO1nKkUt9KtJa5pkt8fenxTRqojwMJE/k9QOb8rHcezjR5UgTgsE03Zz1UGycx9v9aNypJTxukl4aHbhswjbLKHBFwPgePU+BgZzmVv+GRCFitM6SaGIQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ni38pAcb/DinRyhSO5LRd7j8b48yt6a4VO2/2I02rIg=;
 b=caVTmiYPmwfXQzMnPWYD4NhGL+cORlwYtmfn3XKIIFgJOztvAzjXuX8OH9KuNUN4sWsA4V4+4POLlo/kgMHgpwgm7lqSCWJNrDO0H0rWqocRXP0s1XyHNib0X0+SpMtqfx+OFHZ885wzUQFCcZv2UIL/do3AKwkxVIfHwudZ9nNGgpoTroK+JeY43SOq3DI39wdf3ycqLaXtuR1WQMpXOGUwo39/IXOFhMx+e3uH9DrI4SRBBqhwXdJ0dlygil8IQAEUjD25iPM+fsjDZjYOi6II71CxcEp77Xi2SUonmPwqXpJH2R4tKuuDMQDdLVqmlcy8PEouyWrlA2fPr3BaHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ni38pAcb/DinRyhSO5LRd7j8b48yt6a4VO2/2I02rIg=;
 b=GB0AJqrN2pODiRledKCZbUvQ7Rjy74qUy6YK1yiI17NgnD7K7iocylTImt+2U6P0N/tAix6GPjswnfV95H+OpY8s12wPhL618+V2z72W86C2y+wyq8KHelqWxs5nhhqotR4tDvsvpXQGU4DYSxrHrzCU9m1pC96+wj3X+oUc3pbzXkMdn/awHIxo+eQ+MsYrn9lANDnPomnT0ZPmmOn4FyyqP0JGa6VccSpWtFyQegID7NhaJz3tD2OIIXCtIH53Kw57XS7zUR1p3yjEPLaMqT5UgBy+X+VVCk4RfhtUZIQNsO3cXZvgRpdlpUUH7Y1k7cIThEwvKYdqzfQICUC55A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by IA0PR12MB8085.namprd12.prod.outlook.com (2603:10b6:208:400::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Mon, 22 Apr
 2024 13:29:57 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7472.044; Mon, 22 Apr 2024
 13:29:56 +0000
Date: Mon, 22 Apr 2024 10:29:54 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>, Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v7 2/9] iommu/arm-smmu-v3: Make CD programming use
 arm_smmu_write_entry()
Message-ID: <20240422132954.GB49823@nvidia.com>
References: <0-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
 <2-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
 <ZiLdB6nVg9S65Q1G@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZiLdB6nVg9S65Q1G@google.com>
X-ClientProxiedBy: MN2PR19CA0008.namprd19.prod.outlook.com
 (2603:10b6:208:178::21) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|IA0PR12MB8085:EE_
X-MS-Office365-Filtering-Correlation-Id: 1818f9fa-3db8-4c3a-a0cb-08dc62d04cd4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RW9pY29ObzFqRkNUS2dmdm8rUytLZlVmVkFkNzhzM1JsTWFiL3RyWlVBNHlG?=
 =?utf-8?B?b0hENy9mT1FkYlI5NUZlVDdDL1pMajh2a0Q2Z2E2NFNXdGVYYjgxM2VxZXh2?=
 =?utf-8?B?NjRPZTFUKzludzdWZFdhb0tUc0dvUHlQRFZLTGlCS0VKaTZXUlM1UGtiOVQ0?=
 =?utf-8?B?NVh3YmJnYVU5cW5VVEo1cGFyVGlDWFoxY09GS0tCUmlZRVliNjZFZXJ0VG9M?=
 =?utf-8?B?eUtBcE9YZ1NMQ3BmdGozZ1RUcmFaK1NPT2NpV3VaM0RYRXUrYlptcVNta1U3?=
 =?utf-8?B?d1pNdlVKM3ZxSk1idjFzcjE2bGJnSjN6cDRWa1orRGtOY3dKZzZPT3VJQkRR?=
 =?utf-8?B?eFlxVzAwVCtnOXAwT0dJVHFCUXlhRElDanNpc3FnTjZ2QXNlc1NEOXlRa0NC?=
 =?utf-8?B?TFA5VDBSRFdWT2hrK1dDY1lxZnhpRmRCRjN2cG5QZmk1eHB2QUpNcmNoZ3JC?=
 =?utf-8?B?YzM1dUN0cW9IVnRWWjZubkpnbWdWNTRDVUQ1ZUxMb0ZqLzhQMExjTTNEakV0?=
 =?utf-8?B?dVhIUWIrRlNSWm10VFVsWExHdDNZVzJKT3o0ajh1Sk1RWFFsTldPQ0xqUUNi?=
 =?utf-8?B?cXZvVXl0ZFpHUVU5M1Z5YStNZWc5QU56bFJYc000MzNCRWZqSnlRK3IrRmZ4?=
 =?utf-8?B?UGsyV1pmN3N5K20rMEtwVStoUjA4dW16OXlZOXoyS0VxeUMzSDlwZDFoUXhm?=
 =?utf-8?B?ZkRsUlVlTjArMHNuaktXZkJhaitHSWNuYWVob1ZnNkhsTjlqTWp5a1NZNFhh?=
 =?utf-8?B?MTBmeU0rN0FCaTJOalNlQTh6MTVzUmV4RkxsNlh2Wkx5ZlV5aDNuenpaWlZp?=
 =?utf-8?B?LzFnM3BraENxM0xXbm1wdGlhNFVHcEliOWl0cFNvbFg0b25RMWtZZVREbEc2?=
 =?utf-8?B?aWVGUzVROFExS3BGOU9ueXRmMjZzSjloV2NCdmlnSFI5cEpERC90ZkRFMHNl?=
 =?utf-8?B?cU9JOUxoTVErdC9MeVFORWc2bVU5dm96ZUEyKy9nM0w5WUd6aXVwc2RBa0Qr?=
 =?utf-8?B?UEt2Nk9KdnFGakFxMFBYaHZkd3p4RGoxMFdjQW9jWTk3d2kzbVZuQkZlbWp0?=
 =?utf-8?B?TDI5b2Nkc3FSMjNla3pIMEZRWHNkeUFITVNGcGpMdzAyaklKQTJoTENEMUxs?=
 =?utf-8?B?M2xVVTR6WWlQSWxEbFpEZHMzcWJubEJrSGdCWjNzSXZGWk9uR25STmZuazlL?=
 =?utf-8?B?Z1p1TUxuNGxMTkFvbkVDQlpCNGY5cStyTkttTFlKL1lKZ0FmTyt1WmE5NjU1?=
 =?utf-8?B?Z2Q4RVRTL01XQ3lIYkMrc2p5ZmkyRWNjWW9zR2xVcjBMWWRrWFhHNncwWUs1?=
 =?utf-8?B?K3VoQ1M0ellyZzJoNVppZWFZUU55UHA4NFkwak8yQTQ1V3craTBRKzQvRG5G?=
 =?utf-8?B?bWU2ZDhnOTlYQnRrM2FyMjRoZGpyRXB4a2s1ZkRyMm4wanF2dEZlWWM1UUlL?=
 =?utf-8?B?N2tRdVVLc1RZaENVdlJPN3BWUm9lWlRXR0VDcVZwMU1QMEgvcXVQSS9HMVRM?=
 =?utf-8?B?cndDNDlFbkhkc1pYTkJZSmYrYW51ZE1kRGpIbEo4TlJ4NjUvUWprYXlmQklw?=
 =?utf-8?B?ZElNWWxaTC9LOFhsdXNjY0hKZWg5VkVjcWt5eUdUR2U1RHJwaHpTYVFRU2hn?=
 =?utf-8?B?RU5WWkhKcXdVWGJtVm9CR3M2Zm0wRy9EZlYxM1NCSWdMT0hDTWw5V1k1MlFm?=
 =?utf-8?B?NlRyVHdoOEVlazE1dit2OVhnOTg5WGd6anhZZ3ZjaGtBT0w2Qmd1Y1pBPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(7416005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UE5LR3hrSzZLcHFlVGRaTHdSTHdBUjdLZ0p3amRBQ2QvUDdrcy9NY2c4VjR1?=
 =?utf-8?B?dkx2SE1WUVNaWUtpU2FUY1FOaWZqN3dsbnc1SklmMHVGZlRTZEkxeFFxVHJw?=
 =?utf-8?B?ako5cUNjemhRemUyQlpGb3Ywc3cxM0tnMlk2Z2RTRjhrYlhvNkcxUlRVS0h2?=
 =?utf-8?B?eEtnSUV5OVFuN0VTaW01WW10d0dYZ044ZC83UStHMTcyd1dtb29uMXIzWFZG?=
 =?utf-8?B?ck4vUHB2S2ZLUmlEaDc4K2FiN2o2bnVEZ2hNbHRvMzJTczBpRzlEYVFmUWQ3?=
 =?utf-8?B?RmRqKzJkZXRqM2hBR3FqZldqK1NZZEtVVG5NMFdLUGJwbmRUc3FvM2FIanV0?=
 =?utf-8?B?VzdVT21pL3JHd1lEUDZCZWlTSVJLaHJ3K2pLRHVLMm9obnlSTitMWGJuK01s?=
 =?utf-8?B?VHFITVpRVko2RTdlcGRtNnA0VUJJT09jbWZ0dzJobEROWlNadG84Y0VKL3lF?=
 =?utf-8?B?bGFCWGNGVVlPdXIrYXRqZCtmWVBaeTZXQUtiUmRoUW9jVmIvTS8zaXBnTUYv?=
 =?utf-8?B?NGJNUVpTL3o5aEhzZzJNaU5lOVlTNjkzRVc0MndJYmM3K05MM1VoZ0dsR0JU?=
 =?utf-8?B?akwzYUo5d210MXBmVzZERXVTN0hmcWVYVWN1cGp4OGNtcXdZMCtmV2duODZM?=
 =?utf-8?B?d2NkSXJwSUJZR0pWcmxUOExNZ1MzTDVkZXlraUhic1QySlpYSFR2RjJOVGU2?=
 =?utf-8?B?OGF5N1ppMW1mNGJ3ZDNIaUZNRitYM3VUN1FvbU5FY3E2OXFQUVlHS1FVVStO?=
 =?utf-8?B?c25sWTB6RFZzZVVZaDZ6dFhWU3RZMWx2SzdUT0dzR0dVS2VCQUlvanNjVzQy?=
 =?utf-8?B?UTZKWkZ0YTJwdVFoRlVpTDVVZUdyNmtKd1Y0aU5xU1pGNlh5OFJYbi9wazc4?=
 =?utf-8?B?SDVCK2NKajJpblFKZ3ZaL2JSRXpBc1BLYlR4STlzOFpnS0k5eWdDc3BWa2N5?=
 =?utf-8?B?MTBKNUlUaXVDcDRyd3dRNmJhWTk3d3ZzdjVwZGtBbldpbEUxd0NSTlgvSlo3?=
 =?utf-8?B?bDQrTU0weXdWYTVBKzFWT21qanZGTGN1anRXZURUNGlHL08yakZLU2xYMzJq?=
 =?utf-8?B?bUtFaVFNOHFCZHpGemJRSzRoQlA4Y3dQWE91SzFpRi80UjUveTRKU0JxYVZ5?=
 =?utf-8?B?TldVRXNJd01MTEZLczduYTV1M3YybGt5TmE3V0M3S3hXYmY3dUpNL1NWUEdv?=
 =?utf-8?B?cWxwbTlhMTA0TUNsM3JxckU2UkdqL0VVU2NXb3g3UlR3OVI1dVpGRld1NDZh?=
 =?utf-8?B?dTBiQjJtWVlqaHpFRWM3ajRyL3JEZlR6c3l4OWkzL3RSVncyQURuRWZoS2RE?=
 =?utf-8?B?aU81aGNkV2JINWN4VkNVMWlJbVZuYU9kYU5ETGt6bkZ4WGgyNkp2NXEraUx4?=
 =?utf-8?B?SUVQSGZyM200SVhRT1ozby94dU9WVG9MOXA4aG10QUNScDNVYTN5TVFpdUpL?=
 =?utf-8?B?NGVBUkV3Zlc1aXpMekx0Q1dyKzdmNCtybSszZUo2VXhuM1pncUJyV3VkOTR3?=
 =?utf-8?B?RytGcXBETCtMSEw3VCtod25RTG1xU3FDQ1c0M2hPZWl5dEtqcWdTak1kVzVQ?=
 =?utf-8?B?eEJDVkFVVG9xUzRiT2lULzgwUzF0aGdGbmY2RVZsTXRTVUsybHVwR2huNjIw?=
 =?utf-8?B?UFM2NEdUcTRBRVJxWE1GaklqbDZJdHJwU2hpQlpEQnRXMWt0TGNXQVBBam91?=
 =?utf-8?B?aUxhTzVmQmJqRmZGT2ZRLzhJalp6YzFreUR4bjNmRm5xQUg4QWgxOFpnTG9E?=
 =?utf-8?B?bG1XdkxRbm9FUjgyVmFiMmNURmZIbEsxcnNYNU9NOFAvdjh3eU5XN25SblBv?=
 =?utf-8?B?ZlkwZTZ2bU43UnFQd0V6U1pCaXRzVUNCb0loeEhIcVVMWmhkcWtrYXUwSWhQ?=
 =?utf-8?B?SFBGZzNOeXZjdjAwVW50cCtTQXlweWRWc0gxSWhQSnZsMTErTUszRENJTVZY?=
 =?utf-8?B?ZDBucFJCTlBhZldWZC9peGZVbEh5NGRYVWZRd2pLdWg2VTgxZ09Ic3RWL2NH?=
 =?utf-8?B?MDg4Z1B0WXpDclMxQndKb05PUk5vUVplN3lkbTJjV0RrT09GalRvVkgvZmpI?=
 =?utf-8?B?Znk0VVRBaUZTOTVJM1hXTnZBRnJuTS95b05HRmowRUllWEJRZXh6cjg1UWgx?=
 =?utf-8?Q?tKLje/IObOFSXA7cc0k+AEDdW?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1818f9fa-3db8-4c3a-a0cb-08dc62d04cd4
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2024 13:29:56.2907
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U/SrHYIoy6AkNrKXwoTAC+XaOzFyFW4PrUcZog9mwQx//YZ5QC/19i7kMlvXFGdx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8085

On Fri, Apr 19, 2024 at 09:07:19PM +0000, Mostafa Saleh wrote:
> > -	cdptr = arm_smmu_get_cd_ptr(master, ssid);
> > -	if (!cdptr)
> > +	cd_table_entry = arm_smmu_get_cd_ptr(master, ssid);
> > +	if (!cd_table_entry)
> >  		return -ENOMEM;
> >  
> > +	target = *cd_table_entry;
> 
> As this changes the logic where all CD manipulation is not on the actual
> CD, I believe a comment would be helpful here.

This is all deleted in a few patches, doesn't seem worth it to
me. These steps exist only for bisection.

> > @@ -1299,18 +1357,14 @@ int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
> >  		if (cd_table->stall_enabled)
> >  			val |= CTXDESC_CD_0_S;
> >  	}
> > -
> > +	cdptr->data[0] = cpu_to_le64(val);
> >  	/*
> > -	 * The SMMU accesses 64-bit values atomically. See IHI0070Ca 3.21.3
> > -	 * "Configuration structures and configuration invalidation completion"
> > -	 *
> > -	 *   The size of single-copy atomic reads made by the SMMU is
> > -	 *   IMPLEMENTATION DEFINED but must be at least 64 bits. Any single
> > -	 *   field within an aligned 64-bit span of a structure can be altered
> > -	 *   without first making the structure invalid.
> > +	 * Since the above is updating the CD entry based on the current value
> > +	 * without zeroing unused bits it needs fixing before being passed to
> > +	 * the programming logic.
> >  	 */
> > -	WRITE_ONCE(cdptr->data[0], cpu_to_le64(val));
> > -	arm_smmu_sync_cd(master, ssid, true);
> > +	arm_smmu_clean_cd_entry(&target);
> 
> I am not sure I understand the logic here, is that only needed for entry[0]
> As I see the other entries are set and not reused.

I'm not sure what you are asking?

The issue is the old logic constructs the new CD by manipulating the
existing CD in various ways "in place" that ends up creating CDs that
don't meet the requirements for the new programmer. For instance EPD0
will be set and the TTB0 will also be left programmed.

> If so, I think it’d be better to make that clear, also as used_bits
> are always 0xff for all cases, I believe the EPD0 logic should be
> integrated in populating the CD so it is correct by construction, as
> this looks like a hack to me.

Yes, this is what happens, in a few more steps. We have to go and
build the missing make functions first.

There is a bit of a circular problem here: the new scheme expects that
the CD is only programmed by the new scheme and follows the rules - eg
no unused bits set. While the old scheme doesn't follow the rules.

So this patch makes the old scheme follow the rules and be compatible
with the new scheme then we go place by place and convert to the new
scheme. Then we remove the old scheme entirely. Look at the "Move the
CD generation for SVA into a function" patch.

Yes, this is a minimal hack to let the next few patches work out
correctly without breaking bisection.

How about a new commit message:

iommu/arm-smmu-v3: Make CD programming use arm_smmu_write_entry()

CD table entries and STE's have the same essential programming sequence,
just with different types. Use the new ops indirection to link CD
programming to the common writer.

In a few more patches all CD writers will call an appropriate make
function and then directly call arm_smmu_write_cd_entry().
arm_smmu_write_ctx_desc() will be removed.

Until then lightly tweak arm_smmu_write_ctx_desc() to also use the new
programmer by using the same logic as right now to build the target CD on
the stack, sanitizing it to meet the used rules, and then using the
writer.

This is necessary because the writer expects that the currently programmed
CD follows the used rules. Next patches add new make functions and new
direct calls to arm_smmu_write_cd_entry() which will require this.

Jason
