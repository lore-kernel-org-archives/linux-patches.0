Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2044.outbound.protection.outlook.com [40.107.101.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB39D482FA;
	Tue, 20 Feb 2024 14:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708438187; cv=fail; b=j4aaAirg4S3wHCiF5rPnqmUKbDRooaBPIQix9tpkHFzryhpRIKthxjbkn9FpGHPT/p+J/ARB4Ckq8POzR0J9t5XUoTvhsnViF1Ubw7jZ+AXbwwL+SY5bBu+VHU2nZjj6Y5cm3ms0/CgV4SVWfpZCyMJDoudzyH5m4dvuBwHkGAI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708438187; c=relaxed/simple;
	bh=jFQzRyogmI16TRTztpHrMEbIhaoQshDaxuE9brpVda0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Jb02ueiTBnPF/Vk6Q254Sj0U4TrvhzVgf8DQgmOQYBm9hhhi/BjuPlUmyib4rAYWJ5tZ1b1jyhprymAHe2ZT8UCFpHEgKbWwUqsgItiAmDAc1PQ8G37Hjr3wLDtRfSPubq5k9Uu0dq4CnDMvP7UrUWLhWLDb5CH8k/cWXvbYOc8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=uHHCFA8/; arc=fail smtp.client-ip=40.107.101.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="uHHCFA8/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EHj9GZdKEobq5hjUA1jVqHqhmkvFpbw3eKgjMEF+ZJJTb0EVFpWpgdcUtRfM9upvzR3irnsMqUV1cAl8NJsGfgGEklV8FIowdLLJ61jHEY/VMv0/nk+Fyin6abuHywf0ugaNJv1p7X9O/GYInCapylzSdp5DzayYkO/d6zKOKkKNRaVZzeyuh+iq7by4b23TtuulM7Ymr8Kb7FmaRvljB1ZpYIa+uvKpqaJA7xTZLWzmtTVI4vPISloNUmjxz8pMm/qXtTyCbzMJslTtHU5EYo2TrhPTJ+l0nmIJaGopWdlZGbgXY8NkQ7DJl00/TIYKTD5mLJe6SMxfX77Qdta8Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7lTD/FIgSu5lPHR3WkxkM6UuMFx8uKoVAyraO4tY844=;
 b=BDtOBtbXJZ1n9HDJTbLRqLL3VXDONky/rFLwWn7Tf+wPbDWvqJ4Ki4A1jZSTclk3kgZfZMXTpUW8T/9t63lGW0SieCqRcFU0mUklyzbYsKfrF6G6wfm6fHwuel4MFydBNbJf5Hfoi2XJ7eqyJFRMBBJw7NtvKKnvNeRn/k4qHfaY/Sg7nSd9iSuHmZmm8pSf5l43mclXslAequISABmjybkgoVALysTEhu5mng1WV9KQMD3g75RPB+L5tjU252WwEI5Fl2h+QmdSoqOHTE+vYLxELeUdYPhH4R50hzoV3hMzG5Z+np5ffkvDPLRfDqrHgXU7f4AxvIA9UVquQ2Ws9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7lTD/FIgSu5lPHR3WkxkM6UuMFx8uKoVAyraO4tY844=;
 b=uHHCFA8/xxuatEq5X/jokhKw8rZFjbVsWiEfRKbzage5HMD/TN4rZpWBm99qlVefR3YkGRDs767WTjD8pgW415QFJcZ916sN3eE0BlmgU3HDlkOEnkNDE21hfU9YQHIpsZRlCRxSdyZQWcCFsdGAJiaZBOn0wjoOVs3XCPllFuZv4urLU0jU9sqZ+wTERJZxa/iOuuB5If1yIi31C+LqaGjA1295vSW6miY8RHC6xZq6RidProyb1GGB8Gkk8YbHodPSr7ic1/BoT/jLGTnkZ+4lLwWL44qePLrbWgIDr0D3Uj9d0ZuuRxhEUbbbaqhXYiMb8MfCM8D4RzYOefFcHw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB5618.namprd12.prod.outlook.com (2603:10b6:510:134::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.19; Tue, 20 Feb
 2024 14:09:40 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7316.018; Tue, 20 Feb 2024
 14:09:40 +0000
Date: Tue, 20 Feb 2024 10:09:39 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Daniel Mentz <danielmentz@google.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v4 20/27] iommu: Add ops->domain_alloc_sva()
Message-ID: <20240220140939.GN13330@nvidia.com>
References: <0-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com>
 <20-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com>
 <CAE2F3rBip7oe4ip-kK5GR6+nY_efsVrrxcxv=4m4_aWGKOg=gw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAE2F3rBip7oe4ip-kK5GR6+nY_efsVrrxcxv=4m4_aWGKOg=gw@mail.gmail.com>
X-ClientProxiedBy: BL1PR13CA0204.namprd13.prod.outlook.com
 (2603:10b6:208:2be::29) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB5618:EE_
X-MS-Office365-Filtering-Correlation-Id: ebb2388e-88e8-44b4-0a49-08dc321d9480
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	6afz795w0DkwnkEYD4nZnInurL6cBtPFKcUj96l4Ms1Ko+RqPmAozrJeMbLka4HMtp2wR1TZTe5cvSFuNp6Z3+bw5HQRlyoap61mtyGxIBIwMqsVq1yIDtpeywgRqvp6tPALXT1Enk62fsBGNs0AQCOfTMVFGm8p59Gf6CmyF3z+s9ivcelpAjorq6ijMONyDkt1d/++Z9Q7+jwVkbV4lDJg4fwCEfUSc4nZuUv8m1pw+KcVnN6JmdcckPXCA2FO5hu0pzWgzi95pD9rbp1O+RBcl710S6UaP7j6x9031R/PEjYZk4r1BrlOGx+jCHUbM/cMc7LLeDJbfBGJz/dnyJ8vXMmox0gQZyQOMPrxqLIcUixTZ5T7wbUoCO5yB5gHs4zL+0l6i4+t2NQoaNyEpiOLu5guDgL1PHpCQ+RuUmhgQ4Dnk5YvWTqE1FdBUKMsbabz6mHl2qnuBQMTDnLkcPtQcJyeQlqnVNp0XhvqJ1CgPhaNT9G+8eZh+JfG7mingkMXjz+QGXMMrPtcrG5HguovJXLD2EhRhI4GWXfrsxg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TXpGM2pTMkdDTm1RRGZVYTZrWitDbHVwTmdKQWlvUERrK3B4bmhJUnF5N0I5?=
 =?utf-8?B?L2hvT3I0cU40RWh3c041WjNTVzUyWG4xd1A2SHF1TWNZcWJoQUdTdnhUdkEr?=
 =?utf-8?B?MU16NDBtSXFieWRhdVZXaXZrNVRKRG9FemFHQ2IzcWltQzdSS1hWNW1rdlg4?=
 =?utf-8?B?cnR4ZkxKdDlZeXRaTjB5OWw4UjZlSzMyd2FpeEdxeHpJUW8yQStTSG9XQmxi?=
 =?utf-8?B?d2NiWTc0OFMwTUhqYnF2ZjdKUkRQNnFKZ1JwVnhMMEFPNW9KMGpJU05kaHor?=
 =?utf-8?B?TXBudDBON2VoV1JBdDQzMTB1UysyeFppQXNWRlUyVVlaNXRyUXR6K2lHeEFS?=
 =?utf-8?B?UDlHUUN2RjIxdFl2NzRnOWNKRm8yUVArSVAzK3d1QmlvTng2VGw0WDB0cGtu?=
 =?utf-8?B?Q2FQQVcrOGs1ZUVLcldNTDJpdTE1Wnl1cTZ2MGJlTllBVlRSMmVMOXFlYWpa?=
 =?utf-8?B?dmVuTVpPN2VXRm8vSnRKUUMwVGtuNnd2U3IzallqaXVUbElOajF6YlFpNkFZ?=
 =?utf-8?B?YlNyWW1wSjN1Vlljc1NkNWRFVFVqcklOY2hxTVZLYWF5MWdjajREczFkV1kv?=
 =?utf-8?B?YzdUMkdqY0IxWU1jeDdmREFrN2xjSnJNT0x1RTYzU1pkNXdVRGtZQ1RFblVn?=
 =?utf-8?B?R0NTeUVXN0Z0YlNrL0Vsb051ckpxWmNVZ3kzQ1J4VHMxU3ZTbHp5ZzVuaGpB?=
 =?utf-8?B?bSt4RnNJRytPOWJqQVhYTkIvTTRZZ2NYWUhmeHFsZEp3cE9Ta2llb1FZQlRV?=
 =?utf-8?B?UlR2LzdVMVh3TEplN3hGSVJQcm4yV2VacmVhV2czZkhMNHpmN3NCcXdta2pT?=
 =?utf-8?B?QWdDY2ZIcFBmZEtSVmlBc1MyV0hLZno0QWVhQ0hhNlFQRHhwd0RtUGRKMzJp?=
 =?utf-8?B?bkMzQmhqakJCaXk1Yy9GRXNsQzVhSjJKN1NkM2c5NFVQd0FlY3FlMlhuWHNl?=
 =?utf-8?B?TTRJVGk0TzBDR3F1TVFjSkE2bkcvNE1sdkdtL1RDU05qcGNQSUFwK1ZLanhV?=
 =?utf-8?B?SFBqZG81V1hGY2lValNqZXIwV3Vsb0ZuMzN4ZzJ1VVNNRmVQOHJwWG9SU0hu?=
 =?utf-8?B?V3RwK1BtcEllQVhPbXZHSVVzL2thcDFDVXZaSnFqaW1kTkZLSWdJeSs2YzNQ?=
 =?utf-8?B?WUVZYmVaZm5ISnFNOUpDQUFpS1R2NjBBVE9JSmRnTkQ2NmhpL3A4cjUzc3Zl?=
 =?utf-8?B?amhQZGZpWVJZMTJGQmoxdEdXcXc3ZFkrN2lxTklpRThQeTlESHBPendtdmZz?=
 =?utf-8?B?TXFpWHpOOXVqaVhMZFVMbFdSM3MyeDVGZGlZRzBoSEVEdHNyZFQ3SGdvZGJL?=
 =?utf-8?B?ZlR2NWZQNXNldmt6M3J6aEhUK1JUWkN6ZUtVQlAvRllGNE9tUzRsVmhOazhU?=
 =?utf-8?B?T2RpZHBKbnRab2w5ZElwZmlKem12aCtTRWlueWhERzBaUnN6MzFGemFpZkNx?=
 =?utf-8?B?VWNNaXRldWpjYWRjcEI3OXc3bTljRU9peXkzYTUyUlV0NWlmTGZCWWh1c1dw?=
 =?utf-8?B?NEVjZ1AxN1FTaWVBN3dwTFdQOTVRL0F6ODdURnFSNFZ2NVVqbkUxKzVVc0JB?=
 =?utf-8?B?Qy9aczk0cm5vQ0FUYlNjOTlUOVJ4Q0Fma21RNWJXRVIweFlGSzJ2T0dDVmtN?=
 =?utf-8?B?RUw3bDVULzN2RzJlZHVDaEcrMWc5cmYxYTJGQ1Nxam8yNW1kNndYeUdTSkhZ?=
 =?utf-8?B?RWcyZTFDM2VWSThMYzNLdWRZdStlZHl2YnlmWHdyTExjRE1uWWFPZmtlZHc4?=
 =?utf-8?B?eUFUazVleGZRUVhvaTZGdHJiQ3pnNW1uM0xEMnpzUUExS1VlOXptY2k3ejI0?=
 =?utf-8?B?eVB0Tzl4TFNmWFZlay9sZlpIZWRjZXY1RmZlMWZNV0JJTFIveklKTGJTTnRL?=
 =?utf-8?B?V1dGSEhUbnZwSy9GT05ISFJ0V1dMY2JKR0x1Y0RuV25RUGxCdndFd05HVk1o?=
 =?utf-8?B?TG03em16S3BzUkdMRytMeC9Wdk1RVUNFbFh3MFM1Vit5L3Q3TlQ4bjlYemcz?=
 =?utf-8?B?VHF2TFNQNXN6YlJGT2owZElBZjgwSnpHeEFvWFRNbDQrYzFhLzFLVFp5QWVs?=
 =?utf-8?B?SmtkSkJWRUxNV3hIWWRKcVNucWxBQmo4cGRhMmF0WEtaZFZqK2hUc3BxeExT?=
 =?utf-8?Q?YZD7pXq5H31qYj6jIpn4XTmmz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebb2388e-88e8-44b4-0a49-08dc321d9480
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2024 14:09:40.8142
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bYB/UsMamWoxxBOoFLVNaJlhfbHaY6eMsN1ZOAxykLM7aKdg2yYy5vZykxv7LwGh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5618

On Mon, Feb 19, 2024 at 02:47:31PM -0800, Daniel Mentz wrote:
> On Fri, Jan 26, 2024 at 10:15 AM Jason Gunthorpe <jgg@nvidia.com> wrote:
> > --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> > +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> > @@ -654,7 +654,7 @@ static int arm_smmu_sva_set_dev_pasid(struct iommu_domain *domain,
> >
> >  static void arm_smmu_sva_domain_free(struct iommu_domain *domain)
> >  {
> > -       kfree(domain);
> > +       kfree(to_smmu_domain(domain));
> >  }
> 
> I'm wondering if this particular change belongs into the other change
> with title "iommu/arm-smmu-v3: Make SVA allocate a normal
> arm_smmu_domain"

Yes, you are right. I think it is a rebasing error..

Thanks,
Jason
