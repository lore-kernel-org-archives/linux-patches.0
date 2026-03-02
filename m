Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010066.outbound.protection.outlook.com [52.101.56.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4A3A41754;
	Mon,  2 Mar 2026 00:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772409785; cv=fail; b=bY1uHxDHu6lBepv7EKTtkfCh0IoYXXZ7OrYLWXM/c7yA41BPHHtdvr3k/9o1gombc54avJzMRSeAiJQh7o3vBGN2ry8BwxSdNUj2N+KhZ3fCjzLP/THzwgB7t68Wi4l2Y4780HDXNZ6reSG0FMiVQUx1SoSFU5S5xK4rHyzS1RI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772409785; c=relaxed/simple;
	bh=SJiEMUiibg2rjpZ+42NEbGNoKHrNaDKwsVe9+plTFQw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RynB1Zk945o58XyrpfMZC4YWcD6UIXnGdw9i44mc4bZEBjDe3HG4oDWI9xhyYnsuDlAWCG/nGvHts4RQwysGAAMKPKYnjKeUUXbzXZfzSFc9Md3D+Vk+bCXxg5gkRRIdaZ1e2EPGjPFFJB7myZlkhXIpSkbkmVz7d+FVUKIgGCc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=T+Mu2tEC; arc=fail smtp.client-ip=52.101.56.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="T+Mu2tEC"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f8/waD+d8IPSJrTt5/X2gB49IW9tsSxKr98G2wVUcNe7xKZHtcP2csMoFtASK8HiZxhTzSAZuGlQhl5/N1kklf6e5vdcIna/hUiCmu4Ewm1ROHcg4b7wakCkDLOWjRzfYKPW9VG/Uqlb3/bUt0Yif2RIGXqJV2jb2ChuVDt6C1akZnikiMee7qZ+F8+tWfWJJccoOkCBq47a8pgAHcUiNpPJRLb6KzsyYuFa4imlB1igYYyBA8KeVQu/wWjOo7B7+NOWnhc4PXtwxQAzOoqXotVzQo/Y+aev5I7BQ44m84+ktarRIkQ12ottXHc6597ZbZL2blJANEFtCz3sFMb75w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DFL7mUJMJe9wehFdmFeA0YgCwUMyKFyEjmxDQGkriZY=;
 b=xN7NYzMlIYzdv/64hXcnbJKg+/Mdq1TseyI7oBQnaxJiCxRwJHiylFEbEbDCUnwoEkOVhMcnmMv7S0wnwmlIlrwpu081h3ocqerg7UCZZiQahTBGVBnoRGRz9+WyPYNdiv8HM047YthlVdfcQWCKFDeNOqwFotvzbf2mmZplFS85FZMYu98JfZD4wUJ8dtm3FhkZA1zIMUvCvEOSt012MS64HUv0hdpKrlf5DJ5eTljOmrmUDhWufwiZc1Lll47Druxmus2OgXQfUqtSM40vTDHqOT5NbCcfltcSeEMDvSdIjQclRPNosD5Il1fEeCUS1tPQ61y8+lN1d25hOeElHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DFL7mUJMJe9wehFdmFeA0YgCwUMyKFyEjmxDQGkriZY=;
 b=T+Mu2tECRqWKTMs6xrWv8Yo9m/wEy9Gu0ZsysrKiEsSysmMrnJznT3cpiT9bTfSlwowCfSqvkH8wCoGGSqcEO8yI7OordAL3huUSv3X8f68uM4alpP4zxwbeQaJLvbdYS0/ZumdLuCWl9R6OoiKyXc0FcberVloyYm4SOR9qoFQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9654.18; Mon, 2 Mar 2026 00:03:00 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::1e6b:ca8b:7715:6fee]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::1e6b:ca8b:7715:6fee%4]) with mapi id 15.20.9654.015; Mon, 2 Mar 2026
 00:03:00 +0000
Message-ID: <8f734d5d-7d18-4b65-a058-32088353e13e@amd.com>
Date: Mon, 2 Mar 2026 11:02:48 +1100
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH v8 07/15] iommupt: Add map_pages op
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Anup Patel <anup@brainfault.org>,
 Albert Ou <aou@eecs.berkeley.edu>, Jonathan Corbet <corbet@lwn.net>,
 iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
 Justin Stitt <justinstitt@google.com>, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-riscv@lists.infradead.org,
 llvm@lists.linux.dev, Bill Wendling <morbo@google.com>,
 Nathan Chancellor <nathan@kernel.org>,
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
 Miguel Ojeda <ojeda@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Paul Walmsley <pjw@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
 Shuah Khan <shuah@kernel.org>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Will Deacon <will@kernel.org>,
 Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
 James Gowans <jgowans@amazon.com>, Kevin Tian <kevin.tian@intel.com>,
 Michael Roth <michael.roth@amd.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
 Samiullah Khawaja <skhawaja@google.com>, Vasant Hegde <vasant.hegde@amd.com>
References: <7-v8-d50aeee4481d+55efb-iommu_pt_jgg@nvidia.com>
 <fc4f0354-4e6d-452d-abfb-fe24e53253a2@amd.com>
 <20260117154347.GF1134360@nvidia.com>
 <bc6817bd-4aa5-4033-b89d-88fef637de65@amd.com>
 <20260226150440.GB5933@nvidia.com>
 <c6ac32f2-2531-4bd0-abaf-ff76e9cc864e@amd.com>
 <20260227134805.GJ5933@nvidia.com>
From: Alexey Kardashevskiy <aik@amd.com>
Content-Language: en-US
In-Reply-To: <20260227134805.GJ5933@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY5P282CA0162.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:24a::8) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|DS7PR12MB6048:EE_
X-MS-Office365-Filtering-Correlation-Id: 57870d0f-5929-45cc-71aa-08de77ef1111
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	dQrtr4cZfarD0hSl/WO0+9ft05J3OGQodE/XCKLmDLJ6Ptu8U1ROUSX+xFLWCXLAGGtJc3+2hDyBQ51MVxDT1MlSmc7lr1Ou0y+KAhKP/yVtQw1dVRtHAojloq1gbh7YzIt/Mh+5ecibHb5cQ+iqidLhu5M/VlxPuQzFqyUIO7K2SMBk9TpzBTRoyA4PQSCN+8Bth19/oYti4T80QF6cwkq6sguqTgnEY5dsqI6Dq7kVge0qNJlrkuXQsA56mI8juXOufoBGPOBkUBZ1oQdaUsS/6JnXmCA3lK/3j7dazneXE0K28iS7GrTnqNIC+raZqoQjq/wdZ/vkoH3aR4eWRBSE+UflLCBExGp+lvw2KZZ+BdRcPggwwnurstvjZmXi0qBhddY27D37vEVEaSIsmuJYUSkRSvrpJY5oANrjP8EbZH5taCLMWxS9h6lv+y3IYVO/uKmrrwrvz2Ke1JO9/tCOG2vP5CDTTHCk4liqF/4V0YIKz7koTylhuEMlMRS+ls+h6JIxvJ9DO5x/BEtBA77nRcDUfY2EMcVM5reK7WobxGbjIOSJAd+nz/yvFwvXwhcTC3zaLdUeT96e90Ckhe4DUvUJkWrb5y9zsKI5GZ47PonAgFLSHj2jd4fupqnOZm9YRqnJA6zYgMdDNx4/GebQjm4IqxewmmG/nYCoYrIvLwKv3LKk1/GAWJFPZj5BBYXBozStCCHzcQtJx1PHYYqIt1ngQ/rVG7REQLrDepk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZmF6bGhOVkVHY25FdVVUeCtBbllLN1VLOFVKTURNbUdhbEFPS3orRHpzdFY2?=
 =?utf-8?B?VDMrWE0zT3Bna05BTXc4Mzl2bVpSTWFyYXUyU2xkRmhreS84aUpQWFY4UWRK?=
 =?utf-8?B?TUU3V2Yrb1ptdTNBV2MrSWc0Q2pZWjFFNlFwdWRGUjVaZC9KVWZsSzZ4eFNJ?=
 =?utf-8?B?b252L3ZUT2V5bHJ2Z3VoSWFFZERDdm1oSEdEZ2dvdFA5K25ORW5qYmk0MU5m?=
 =?utf-8?B?OFRTemdQS1Vpa0hFaHI5QTZBY2JIcVNsdU1LTEZaMU5DeE1vblBSRUNOWHFx?=
 =?utf-8?B?anNwZVBIY2VoelBiOXJYL3Y1ekRFTzZQcC9RaDB2VG9WWGZSLy8rSy90NmR5?=
 =?utf-8?B?bFZYeURyQzVEeThJb0ZaeEpPY2pQamE2Ryswb2hXM0xUdjlDd2VYSG9LcEh3?=
 =?utf-8?B?cHN6MHM5eUg4TVk3ZFI2K3dFVWxOVDhIRHI0Sllqa3FIbzJ1SVVhUVAzaFpp?=
 =?utf-8?B?UWJxaWQzR3U3T3d2NWN4OVhkVWRRRkFxU2RQMXFxaWFnd0Qza29GUTZla2hk?=
 =?utf-8?B?RDVoamxLUlQ3blRERktSL1VUZmZkRE5ld2hJVlVLelh2eHNVY3g3RXZvTGxB?=
 =?utf-8?B?ZWIzaWJRRnpORUYrM0hmRDBRWHd3WS9FNkhhaDE0VHM0ci9QbUJsOVU3UCtO?=
 =?utf-8?B?Mmo0Q0JlZkV3bG1KSFpNUGpSeGpxeEkyRVRFdndOaUtoNzlHU2lIQjdodEM5?=
 =?utf-8?B?akhoaitvV2dGL2hCa3o2S2w3QSt5WHh2djZrM0pZVWZTeURvTWcwa3l5Qkww?=
 =?utf-8?B?QVk5dGpqT1ZWeTl3RjBLdG9UM00vM2xTUmNnSzJYeVYrL0ZDU09EQTJnRVVJ?=
 =?utf-8?B?T1VGdnM0TEdLQVE3TWQzZm8vSWRFRlVpK2k2WHpwNVN1OFdYOGV0bjhyR2Ju?=
 =?utf-8?B?blhJUEd5Ly91aFphdDJwaUxGK1lyU1pCYnpoSmdhSnlMa1VkUkxUblhzcFN2?=
 =?utf-8?B?VTlLbnpFZng5YzJ0dTkxczd3MWVwelJEZjQxOFJ2V1pGUk1sQmVsUk4rSk9H?=
 =?utf-8?B?aG9rTWU1cWRYY3pBamI3WTduZzNabGdSM3JnTHUwbWthdTBzVExNd2ROQ2VX?=
 =?utf-8?B?dG90Q0Q4NVh5NmRyZGlxWU9jYWx6TGFNaGZUK2kydC9UUEVTSnp3RVdIb28w?=
 =?utf-8?B?YXNONU5laENmM3QzSFJqWHdQL1djb3VSbVJ1eHZ4UGtQMklTZUY5WlZYbzkv?=
 =?utf-8?B?VnVlZEFBL1BRVGQvNXVOQzhUZlltdHAwZk83NnlHZ2dudUY4N01RenV0NU1B?=
 =?utf-8?B?R21yNkpjOHJRWDNIeFNXMU5VTDNkdGRwK01OQlpVeHBzcXlmV2FEVDNObXBK?=
 =?utf-8?B?T2dRT1RRNC9ad1FSeTBJbTZkMVNQc1hlUk8zeGZSRVZHdE5NRGlRaEhpTnUy?=
 =?utf-8?B?MHJleVVVRjBBZlB2R2NNZFp6MmZla2pJTEhOUEtGQStCdlpyVDFFb3RRNHFR?=
 =?utf-8?B?OXVySGhXZ2pVYlErT1pvK0N6LzRHdzdHZ3JXei9LRzM4Y003Rjc5V09VTVNx?=
 =?utf-8?B?ak40S2pzWDczaEp6OUlSb0J2K2dNUURrQ09GNnYwNXM1bUtpT2NQWlNRdXVT?=
 =?utf-8?B?c0JUbzNMQlNyVGRNRWt4aWxTb25aV3h5emNwOEk1eVZOeHdteit2Z3VvL3hq?=
 =?utf-8?B?bkhZeXc1S2J6M3pWK1h0V2Q5SXZSRjVxeTVzbEFadklJclk3UDlNNm9BaVRl?=
 =?utf-8?B?dGo0R0N3ejBWRWNnUVppWEt5TXYzMDJaSWVRUm1iaWYvdkVxdUJjUXBOYnRG?=
 =?utf-8?B?anEvdGhXNS9CaTkzSW9oenZBVkVmbDlXYjhVdTVkZUtFTC9Xc2hXaE1xNEhY?=
 =?utf-8?B?TGhrbGpPekNxSE1ZWlNnUDlUWG8vTERnQ1paSEs3MnZYQ2V6YzlYZldxSzN2?=
 =?utf-8?B?OTg4VFRpamFSMGRmWmZlWDRyTm9ZSjRnQU5GdXhMTmZFYTllNXFyem43Tmkv?=
 =?utf-8?B?anVVdHdyN1ZLT1RhcUt2aGlLSDhvcTduSE5yZkdkNCtNUUJrSzBSL1hIYzZ3?=
 =?utf-8?B?MG5hMUdxMER5a2VJUkZjU1NyMHRTUXBidE92amVQVk1PKzlLVUxOdjhjalBy?=
 =?utf-8?B?d1hTOUhURG9LNG9rQjVwdE51Ui9BTytaZytBR1k4ZTlRQm1XNGc4aWNKM0tT?=
 =?utf-8?B?KzB2RVVFR0h2TkhtVVNsOTVVcEIwaWhKSlRoQ2tVSzdDZ2tlRkwyMWdyM0lp?=
 =?utf-8?B?ejlPdW1VOEpQeFpKNTVjbFpIVUlSc1hVZFI4UWpORHdET0FIRXNMNTl5UGM0?=
 =?utf-8?B?bzcvelBsbFlqbkVmenRxS0ZUVWRZeVpSbk0rajAvdXhxazV4ekFNa2JNb3BU?=
 =?utf-8?Q?6+aicMleS0SclHdgl4?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57870d0f-5929-45cc-71aa-08de77ef1111
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 00:03:00.3637
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZbedsQqnKIsoTqLolpTgJ1oEcsZZbbM0c4h1QUVmpm06M4wjAXO77JrzkxKFcrCO5cEUwy1kH6j6qmj8fFUOaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6048



On 28/2/26 00:48, Jason Gunthorpe wrote:
> On Fri, Feb 27, 2026 at 12:39:28PM +1100, Alexey Kardashevskiy wrote:
>>
>>
>> On 27/2/26 02:04, Jason Gunthorpe wrote:
>>> On Thu, Feb 26, 2026 at 10:11:56AM +1100, Alexey Kardashevskiy wrote:
>>>>> The flow would be some thing like..
>>>>>     1) Create an IOAS
>>>>>     2) Create a HWPT. If there is some known upper bound on RMP/etc page
>>>>>        size then limit the HWPT page size to the upper bound
>>>>>     3) Map stuff into the ioas
>>>>>     4) Build the RMP/etc and map ranges of page granularity
>>>>>     5) Call iommufd to adjust the page size within ranges
>>>>
>>>> I am about to try this approach now. 5) means splitting bigger pages
>>>> to smaller and I remember you working on that hitless IO PDEs
>>>> smashing, do you have something to play with? I could not spot
>>>> anything on github but do not want to reinvent. Thanks,
>>>
>>> I thought this thread had concluded you needed to use the HW engines
>>
>> The HW engine has to be used for smashing while DMAing to 2M page
>> being smashed. It is not needed when the insecure->trusted switch
>> happens and IOMMU now needs to match already configured RMP.
> 
> Oh? I'm surprised shared->private is different that private->shared..

Well, I rather meant "statistically". Confidential VMs are all private with occasional sharing so shared->private normally means there was a recent private->shared which did the smashing. And there is also "unsmash_io" in that HW engine which I am not touching yet (but keep it in mind).

> Regardless, I think if you go this path you have to stick to 4k IOPTEs
> and avoid the HW engine. Maybe that is good enough to start.

This is the current plan.

>>> for this and if so then KVM should maintain the IOMMU S2 where it can
>>> synchronize things and access the HW engines?
>>
>> I want to explore the idea of using the gmemfd->iommufd notification
>> mechanism for smashing too (as these smashes are always the result
>> of page state changes and this requires a notification on its own as
>> we figured out) and plumb that HW engine to the IOMMU side,
>> somewhere in the AMD IOMMU driver. Hard to imagine KVM learning
>> about IOMMU.
> 
> Equally hard to imagine IOMMU changing the RMP.. Since you explained
> the HW engine changes both I don't know what you will do.>> Maybe guestmemfd needs to own the RMP updates and it can somehow
> invoke the HW engine and co-ordinate all the parts. This sounds very
> hard as well, so IDK.

The latter is worth exploring. Thanks,

-- 
Alexey

