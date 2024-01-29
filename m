Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2089.outbound.protection.outlook.com [40.107.244.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D1A6F090;
	Mon, 29 Jan 2024 19:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706557371; cv=fail; b=eehhg+2LAwB7jeWAG9r0YX0Aoa/mxFbe4Sdgr5IdnH2GY32bHm52HhV0HaSnSOBVITjZP0yhxeY11OBZRf9VeWx3SAQVdbadPq03IHzXSGBjPthsvy0EsYiux5gTzB2buIQRSHmcxSyVzgtbUliR6GkwODuj1TOge9onKRcT/NY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706557371; c=relaxed/simple;
	bh=SnnqGxaPe8pgOWag+I430ZII1Rbo5k+D6CyKkWLGLmI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=GcCcYhXqk6BVyR3XqpMGp2AfnCPJlp7UVmQqv/vC04WwRFXbZhGSYaDLW5qRBj+tXAZkvMw6HQhYG1kwES/Pz3tOMLwU+a9ruHlOI47/vmajrIYE0T/33mW/1kRl6BRb/HbyFFQcSWAQpkOXTcliUpZxENdGP6JJvOApk3ZhosY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=k1l4xBTo; arc=fail smtp.client-ip=40.107.244.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="k1l4xBTo"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BEbbEE5SjzB3YtWYn+lmu6RtoE9io7jOgDgTWKoftxvLVmrDKrD1CMg/3lgSEh1IRmjXUqj3OXLC3DFQQfwSwCP1K1QFxNNxRrxZ98R4x2Km+UobZ//wUg1JKzxuvEhDOs8JmIpnc8qvzDCinavywIhzUPxcQRhj1PRK6dreWLpoMNmCPnp25eN8ngbuA3wDyayLgLalByjQvGZwlvkoMGWooUWRHlWuqYQSFrllyQVWWg6kOfCRpHCKd1pgAOpkpRahgmYdDzpx1azrP3JPi7dMirK+iekr52tNAeLDNSH6QLuL0A6Zy5gIZeBIt0Fn+KhqIVfWzz5SzX5LZTWsaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G2NK49hwvRtIz+LG5CGptlsmeM/plmRS1gVQ7ZmSQmk=;
 b=Eye9eqcwRIwdBnI/TUVq8yjlovKVtVOd3d/4pCVQtPSbtglA4K5WcQoUGcIv1dHzYU86Hyits9XD+HofydQG9PlIGWzOLoPS67vGhFx9dpv+fJxfmC4q1/aWI1a63Q2qV0pf3eXxCcQmLh2n2jhRjv+LQl7YzLhw3p0cU6/MKsejiablZd0TjpenHsRnARmQZr0PhlpwgNSCg7Ct7vuvl2DKXrIjDlH987AmZDbolpVS9lPx3LEuJilvVHkF7tFxit/6YJJWOZFgKgCzl9MP0M34PsR8g3+DwUgi/nr2TA61SAmWX5Ue9y4e5ZegATujbWUE2aoFyQui83NidBD86w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G2NK49hwvRtIz+LG5CGptlsmeM/plmRS1gVQ7ZmSQmk=;
 b=k1l4xBTou+wl4pp1Kdkef/lR/Gyq1Tg3a1J8g+EFXORVlyCgb16lmdaW5Fz3jJmKgEHl4+BACVbeeZpQxn1MCgO8PxTD3YvvMgE+zwwyN9qla5FcV4cIdY2oHnTbkB7OOkGgz4Se/UjKEt8AACA+OFRGRmN/pSSHR8QvKsPyEQe/7ZuNvBqyDsAvzdrpWJq92uPHzjDi/9s+gaEzzmw/ebuRtmHnhviMAuN4R1PGejmy63lgF8qoZUzRO9CANTjSZIaQzO4DUxZNe/TQRGRwclg0oNu3v/oFXL97oKFZGtFCf/uuHaxmD9hE360Akp8Pe9/t6lCLMN4FlxKPZg2KYw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH3PR12MB8403.namprd12.prod.outlook.com (2603:10b6:610:133::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.32; Mon, 29 Jan
 2024 19:42:46 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7228.029; Mon, 29 Jan 2024
 19:42:46 +0000
Date: Mon, 29 Jan 2024 15:42:45 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>, Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v3 00/19] Update SMMUv3 to the modern iommu API (part 1/3)
Message-ID: <20240129194245.GA1455070@nvidia.com>
References: <0-v3-d794f8d934da+411a-smmuv3_newapi_p1_jgg@nvidia.com>
 <Zbf4ySDT0bAMXXwO@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Zbf4ySDT0bAMXXwO@google.com>
X-ClientProxiedBy: SA1P222CA0115.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c5::24) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH3PR12MB8403:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c96fc61-0f40-46c7-09ac-08dc210277e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	XHi/y512wQOs9jTK73PjdpGhpKX2q9AYITliZdLI1NuWqcyfihXcyRUx0Fl4nbXAd74Lf80Ikn2rMglhmOoEGY8+Gx7JAB2d+bwxXQ1vTcJV0G3hwrsF43L9Jbv7NVnkiUw2evaV79o3am8UqYEuRzzmVNtfjB8XmnTNJAYhg3VzDKR68j8/BF/KW7qotUHe0tsU6zrKGFQTz21pVyYVHLepBadJ/4+wc8lNMQBmm831jcrObf2+M7wBg88rYlVNdatw4N5yVCC1lAri9VWXrkuhRDU8+j+WuZ8nfKfmOhvDY8yXJJTFG7dAzIukM28MohIALULC0T1j2JTbfcKKfdEyHRvTYeF1vEAG6xvqbtDISts0N8BsZXMqdO5sfm/5y8YzyyguGLm+dkSILSoqNT5I/VtOVv62AN8HS1H717ApqJh6xS7C9HmseAduJR3mRJMde4ZqUjXYzXDM1mUUJq38aFAndLH3xMN68Ep/X13fjta8ljsiF4Em8QjmbERj5BavBm3Sigwmpmc7mv6YFACdeCgTf4ejgUGb6qQE9M5HwEnbEHtHY83V5XeX7ZuoOYyyiBY2/6qTR/uZXMwIZl1n7W3jmehyXA5kwXk8wmU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(346002)(366004)(39860400002)(396003)(376002)(230922051799003)(64100799003)(186009)(451199024)(1800799012)(41300700001)(38100700002)(316002)(6506007)(86362001)(54906003)(6916009)(66946007)(6486002)(66476007)(966005)(8676002)(8936002)(2616005)(5660300002)(6512007)(7416002)(33656002)(26005)(478600001)(2906002)(4744005)(4326008)(1076003)(66556008)(36756003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aWNtSTlSWEtUYitEb0E1RFRwZWxuaTBCZWVMZmdWbW1PQkZvNGNpWGxFa2pX?=
 =?utf-8?B?MVhSWWxsZ3FXTk5qZkcwQzk5d1dPcTZ2M0lMcWI4V3ZMbUZNbnUveVhSa0cx?=
 =?utf-8?B?TEJSYUhTMVhZWUF2SjMyNjZsc09MTk5qbHA1R284YUhvYzdyNzdHNS9KMjVB?=
 =?utf-8?B?RUxlanozS3BzQ2xZZlg0ZXlCVHNFamxoUXNmNDVqd1paWG9HQXU3ZDhUajV1?=
 =?utf-8?B?aDMvTHBVOG9tY2g5ZHVaREhsKzE5QWp1RVpveTd4ZDVJa1MvVjcxRlVYUUlh?=
 =?utf-8?B?dG83SjN2VWFnTk5EZmdBOTdiaklzVG5ZMndvOFVtWGpWcGcwdVdOT2k1R1Jz?=
 =?utf-8?B?Q1VSQUVJcjJIbVZKVlk5QzF1d3hIUlUzV0R4UTBWNWtlNjA2Z21NQUNuU09j?=
 =?utf-8?B?WlV2VjllSSswZUFXTTduU1c2M2gvV0JhSnQvU2RySmZubTVOSGVGbXpnNHFl?=
 =?utf-8?B?Vm83dUxQYUhhdGJXWGpkYzhjQmhid3p3aGMxY3Y5MHRUL2dJRmNUYWZ5dE5Q?=
 =?utf-8?B?bmR1QlNLbmVyQ1A0YXgzbm0zUHcvbjhhUW9relVvQnFCUGpWZ25xVHl4Rnlk?=
 =?utf-8?B?cEY0UzVkaUIvWkViaDhZVVR3T01MRml4c0pKckp2dmZ6U09HVlI0NEtpYXZh?=
 =?utf-8?B?b1AxZkNxSlJBMXZPMStrZER3MlkxM0p4VW9hclJrWmVjUmJXM2FQWCtrZWxR?=
 =?utf-8?B?NzNML1oyVkIyc2VJWDFvbER4OTdmTUh5NkFOOWtZUUhuYmNpdVVZZXZLYVlJ?=
 =?utf-8?B?YXNZbHBmUDVkcjdRNGpSRTVTWFBHemxxaDhEWUw5QjErbHVZa1dnVGx3dHNk?=
 =?utf-8?B?cnFFUE9IVWZNUjdVODVXLzBXZ2tObzB1N0NVLzdwdUVDMDZ5S2pLamk0Vm9F?=
 =?utf-8?B?Qko2aVNjc2hLbnBSeDZpcXdSWTU5YnFJK3lmK0VHSlhkc0tUcjRLaTAySHZK?=
 =?utf-8?B?c0lKUUlRa3lVcEVhckVxTDJVQ016VE8rVHVwMTY2RjZDL1dZUG5GN2dXdXU2?=
 =?utf-8?B?Q0NjY1YxdGw5dG9IMXlwejZsem5sbzBHSUVhRlA3M3lRbnFxc2t5VGtVWDJO?=
 =?utf-8?B?bUxUZnlzUkl5dVlxK1VSMGhrTHZYQXJRTytRTXpvNTN0TEhFZUxTZVEwUmpE?=
 =?utf-8?B?QVV3U1RYblg2TnFneDc0Tm5vYWdiZmNlOEcrd1drbHB2Q2NldHlqLzhNOGo4?=
 =?utf-8?B?QnRZRk8yV3FjSGZCbW5FTFRxQ2VyTUNFTUV2OU5YdVVJSENkeHpEdHFsNHRO?=
 =?utf-8?B?RVNDdEs2Y0JmTktLZnUvdVFTUDFJMkdkbzhGQ2xudm90ek9wWnVEbEZhTEVR?=
 =?utf-8?B?eVlqOE1jcmxIWlNTdnRDemVnbkx3bWxTT09GUVMzbllGNnZuSTl0TWxrc1Ri?=
 =?utf-8?B?UjJvcnh5OFpVamVzMjd6RVViM0V4Z1pPYVpPK0VHWUhOUFdrNkRXVXQ4Vzhl?=
 =?utf-8?B?S09HMnpicGxMSnQ4ditSUHR1RTE5ZkYyajNCMzR6SkZ1UnVJckFTaHhNaHEy?=
 =?utf-8?B?UHJ3WjZpZnlua1cvOFdRRDF5aUtuRGRhQVVLV2VSLzV6eW5BTFFseTRhaU1l?=
 =?utf-8?B?bjNkdzJQQXB5d0QyVUdSK0Q0RlIrekpCMU5EVXVDNDdNY2wwQ0NDaGNObFp0?=
 =?utf-8?B?NjBLbTdoejdNNnZYcFl5bWowUldLZlgzQi9WWWZWcDQxUENZbVl0SUlRdUZZ?=
 =?utf-8?B?L1lYVVc3a01zN2lZdWdSazNybG41OEU5V3Fzc1FiMnpIb0o1a3pNdUtsSVhJ?=
 =?utf-8?B?dXRhcjBwN09hVWlQSDJlbkpEdHpiTjdTdUkyZCsrbVVCS0QwL3BHcVFIYTcv?=
 =?utf-8?B?YnJYc3NFZk5WQnIzQ2x0ZHo3VEw5U2pIU1NocTFha0NTWDBIYzdIaVZyK1NO?=
 =?utf-8?B?SUNRdEZIR2RKS3dkbTNFbWtsSjJDRnFKcit5RDAwZHNDbnIzSFp4dkFFalYz?=
 =?utf-8?B?K3QzMDNEam1rRFZITFpYck9PdXU0NTlLL3NDYmNOKysra041UVhvQ252dEZa?=
 =?utf-8?B?K0NiS2tnemh4Y0NidzNCUFJnbTYxRVhkZ2ZNRXBVbXg5clZmbkFvQjNtdVJW?=
 =?utf-8?B?T0tHNmtLeFVkb2Y3MWlWTk1sRG1Td2pVL3ZXTjNwWk1HUkVrUlgzNStKT0dI?=
 =?utf-8?Q?Tas/UXGvnA9zt2MmxvCP43mqr?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c96fc61-0f40-46c7-09ac-08dc210277e7
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2024 19:42:46.6481
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 47FHiyu4RDPphGdkbG1o6tYVtzw+DVf6Hj38WnKoaPksL/pdlGsU3nvIlWd1eJda
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8403

On Mon, Jan 29, 2024 at 07:13:13PM +0000, Mostafa Saleh wrote:

> > All parts are on github:
> > 
> >  https://github.com/jgunthorpe/linux/commits/smmuv3_newapi
> I added some comments/questions for this series, but didn’t review it
> thoroughly as I see the code on github is quite different from these patches,
> and it seems to be targeted for v4. Do you have any plans to send it soon?

The part 1 didn't change too, much aside from patch 4, but v4 is already posted:

https://lore.kernel.org/linux-iommu/0-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com/

Thanks,
Jason
