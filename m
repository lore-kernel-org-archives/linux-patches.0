Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2080.outbound.protection.outlook.com [40.107.93.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C3184A25;
	Wed, 31 Jan 2024 14:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706712431; cv=fail; b=QHQXcu1mfuVz2VxtEg718IjnWPyxBXa35rVfuBQ3DrTiAJl61gPrDkv1ZhfJbvZkDOM3FHP0N/IGzKkWr5ny/Vy1a1lP/v5GSFGy1ZSC/PcGq1hjZEujwX6f+lUemS0VqamowM7C6LrIqGdMEDBhraYT1KPjIdkPMltIMHpRrE8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706712431; c=relaxed/simple;
	bh=/GRE1njb5QV0yinEEg165j6JBcaXfktN9trsebFXQ+M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Kewf8VbwiCT1acR4k38wvg3C7ZkejZZDnLjwRxPRKga1vrhfQgziopjlwfu1G98wW9rsX9JsgIaBmUhcnbd0imHMpQGh1ZTYGL/w03ybxL+TTgntBr7OhVOZ1/59ImJKlNWDRosg9kQ/fgzYRipqdbYPB7Nv3RabMJx9bHVqyjY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=pyIKj20c; arc=fail smtp.client-ip=40.107.93.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="pyIKj20c"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SslwiKGVK8uS4SUA3LainUh9Gb3Z42ZT7nbKUY82+ezvdBIFuFUdPlccSO5rDIjYKlXy2Gb3WxRjaygzWfdCQjBsNdc5KzwpL0oxXBsZ35DmrpZ+LpZLMQrld6oGGvko+bU8h2zCLLfbaoQOoDV6qeN8r37LdutS7gEr5rv0V/QYN4CLC/tYUjQ+Td3GfGZCBkXGkw3FKjMLktTK32pqUWZZS/x4PJhgdE5GfJU6CbaDJxHr5CdWBsl4fa2hQR+3dJBhzVr45GpUmgC/xy/MU7tGxbW5xNCZGPUTHmdRyvVBZuvnjqtZ4qBoZ1g+qJntJnmo6xlReDojyz5CBH//9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TUA4nsdSMPOWl7yIat2JR0hs5xVZ5opn964syCIvDzw=;
 b=bekOauc/uANsVtekv0+nZHilKO7mV7Y8GX3RpUCTimXLoMl+dSEPbSR2/lP82jx16qRIZ2jscG5Ci6/Xf/UZycLEjN7oq7L957Fyy2/Qj0j+u3AcIP7ufuY7bHuKAkAxvpnaaBhT8W6+ZYcfEnFxaCsUHeMwaiIVE9+P1lBRdY4seiOcUE9LddNmtaU9StQsnFVLu3tvjhMTDdTIp2+eRKzIWNcXRA+IW1NJaTHEEzdpCiXdTVEjgePu2WSFZkqD1Bep2HOkuAU+oz5NjTefxO+ZqTk6A/O+4hphNXVeaJIG7fIH9eJnHZ8O9d5Xmhbmnk7XJKKmcj/T/ycJKMpQOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TUA4nsdSMPOWl7yIat2JR0hs5xVZ5opn964syCIvDzw=;
 b=pyIKj20cWyfcOLmTzr+PgtHgDkbUGszkyq2kQqNCe6mOZjO3kScG4y3c1m+3Yb5LRHsQ6p10/IQP01PIC7mJMDzwvI9GLNo4Ci8JBijF5fBpGZU4jAhWp/1o9/vqcImAHCNvitgw6MVb1e63TJeNEzDn3Bp4IREk/jJ1rrQaKB4rkchdExPax+0tBr4/sxWLVNI0w7cw5DBWTusmAtdeClKcl/UB/cJCh9yWeABqkFL7Gy85aM8KnkxxQdYU1hJRDNf1WYuSZV9d/Hmo9Apnpinm83GM5AKIgM61Ab9zPzj+7a/HYqhSmTYc7tckwLimW3R6WDDdFXe9AVBJB2I8Dw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SN7PR12MB7298.namprd12.prod.outlook.com (2603:10b6:806:2ae::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.32; Wed, 31 Jan
 2024 14:47:03 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7228.029; Wed, 31 Jan 2024
 14:47:03 +0000
Date: Wed, 31 Jan 2024 10:47:02 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v4 02/16] iommu/arm-smmu-v3: Consolidate the STE
 generation for abort/bypass
Message-ID: <20240131144702.GJ1455070@nvidia.com>
References: <0-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>
 <2-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>
 <Zbpb2JSgnRuHGIo-@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Zbpb2JSgnRuHGIo-@google.com>
X-ClientProxiedBy: BL1P221CA0009.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::24) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SN7PR12MB7298:EE_
X-MS-Office365-Filtering-Correlation-Id: d51cb72f-50b7-4d76-6d11-08dc226b7d35
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	+9pXPkieiMBPf0POTfGrZTKNgEvSJrTKtb3rOvd1JTjMxP/Vb1GH7PWbRNa0UOxe9+oTdzt57XI4IFF2zrVzK4zQmlIqzCb+k2zsdH97CqtCsDZVgMpXxyJmHnGEKd3bdApuEPfnQBfUToOFHAQixFroQy7zE7fzcCQfp7jY+BrnvjNL0LDsnmvexOt4ObWW5UiL4AjfSESBEYmLH17ihyY2X1kkNu1+ObS6T947ZWne6kdC0OPf2t3mXFox6px5DPWz1HnppzHsHdwHbwpyQ38dfETSvFi2IKexARh0EHmRpPpwr8Lg9DNvM9Kr8mBvlSJRrKWa/JsdLO9+nZ3s9haYY8n+/u3R2HdkIHWEyPFU1qOoTvF0hH1sREabEuVg+5/qNY3DGnZhDHPBsHAHiGwrVEEv4pv1oKBtbVdeCk1BrkY72iTrpNkj4vhDRDi2DWr0UWMvGJ6SnxQ0aVHD46ieQsz+Iws8PHw4CWiR8HgtA8j9XtlwAbTKjhdXJI/lqzW78XkhpFEQcksQ4uBtA+EfTV9QBf7p72yP6tb/c0Ps8ObnUYAxHHSjVDPBoDz8
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(396003)(376002)(366004)(346002)(230922051799003)(1800799012)(186009)(451199024)(64100799003)(2906002)(4744005)(6512007)(4326008)(8936002)(8676002)(1076003)(26005)(7416002)(6486002)(5660300002)(33656002)(2616005)(478600001)(66946007)(6916009)(54906003)(66556008)(66476007)(316002)(6506007)(86362001)(38100700002)(36756003)(83380400001)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NDNESExpNWk4Y216ZTduWjBQMXVLeDVCZnhMMFhNOWdZcWliK3R3WmxpTmpv?=
 =?utf-8?B?VnBRWjZNdWJqN3VqSDB0K0l6NVN6ZkgzYU5IU0I0R1o4Q3BNM2gvOUJMcG03?=
 =?utf-8?B?a2t2N3VkTFRkMUhrcFpxVUQwYWFrVDBpSnVnZUVkTytnaTdDK0FVU3pHcnBj?=
 =?utf-8?B?Nmhva0s0b2dOWCtCUXZ3ZC81UVhSM1BJTFZYNTg3V25GamZSME1MRGJUZnpY?=
 =?utf-8?B?NTROU1RpMnFsYlBia29jd2FLN1ZlOHNkVnFVT0U1cVk0L0MyQmUwM2wrNkpG?=
 =?utf-8?B?aGFCRVJNREdrY2hBL253MEN4MDk5dUd0dCtraldnV3RrVkZIWGs5a2NkcWww?=
 =?utf-8?B?WVpnOS8rVmNsa1BlekhadGVLTmtiVldNTnJ1UC9WQkN5ZE9qdzJBdjFBYmtF?=
 =?utf-8?B?bnZyUll2Mk5FMEk3Z0cvMXBuR0JrRElOaG9hVXMvaGJNUFdWaXg3TEs4dXBr?=
 =?utf-8?B?c3Rzb1JuN2ZJbWNYZDZxY0liWFhMQ2dlWW50MU5OZzBiaHBsZWtYblFKUEpZ?=
 =?utf-8?B?YjBYUnRnOGJmU0pjRGtaZzA4QXBPRHJNZ2k0ais4MzJQRkFZOWs3ZWhuMXRQ?=
 =?utf-8?B?ZXorM2xlb2NibjNVQWZkb0pURVczSWJtYkg3WUVRbWJrbk83cnRSVzJ1SnhV?=
 =?utf-8?B?cWhLQ2hVNmk2ZFFIV3VIN245SVhDcTExenhpOEdFUno5cTJJY256QXppb045?=
 =?utf-8?B?ZEE3ZnJtWUhDUTYrRGIyMXlZS0U4d2tkY2oyTnlHakh0Z3BQV0g2Q0V5RGJP?=
 =?utf-8?B?V1RYNXBuQm9EeWxJMzJta09iOU4rclgzSElJQWUya2x0TFVCeXNXVW1YUUN2?=
 =?utf-8?B?ME8wTXdSRFFxUEYzUlBGYVBoMisvUHdab1lKQ25tcElxaTRXZk04cStDc1Ju?=
 =?utf-8?B?ZzR2T1lVTkNrOXNoR3pnMWFodzljN1JQVmp5OUYyMzU1bzFGNzdQM1pzRHpU?=
 =?utf-8?B?VURET2lZNlV4QjFLdm8wRlF5QXZzSEV2UUxJaktPRWV3WTFsNTQvZURCUDRP?=
 =?utf-8?B?bWRKTmlQNjFMREs3NU15WUh0QW4wR2p5aFRONS9acjJ2RWsyWVloNTMvRW5s?=
 =?utf-8?B?cVM5Zjk3aTRrZnFPZnR0dG5zczJ2ZWNXd2lwZ3dVRTU4eFlMeUJEOHhUS1lR?=
 =?utf-8?B?bU9Rc2RUN0Y4QlhTbzNTRmx6VmdrSHgzNklGZXFvQnZ6WnhtSFV4ckNDRXJ6?=
 =?utf-8?B?c2cwdkRhYWxzMjVsRUhZRjRXTVZCcFZqMWhabVptQlo5QXhnSE9WdmpyYlhh?=
 =?utf-8?B?dW9oSkFheDY5bTIwRzI2UWFFQVk5NWkrdHJaTDdoQUVzQ3RCejVlSzBLSzhr?=
 =?utf-8?B?SE8vVU5LS0xIU2dwUWpVRkVoeWp2aWJ2ekc5ZUE5MkRGR2Ntc2QxQU0yeC93?=
 =?utf-8?B?RHAwR2V0ckRUNWhDbUd2NjVaTStnRnJmdlArTTVvUUh5OE1wTnhscUVjeGMx?=
 =?utf-8?B?RC84cE0xZzN5c0ZwbjBNeDVMcGNFOG9SRDZhOVcvdnEydHl0YnN6UVo2ZzdN?=
 =?utf-8?B?VUVtUjJjWEI1YVZkaTZQc3h4YW44dEwrZFlNQllrTHpycm94bFU4dTRtcEps?=
 =?utf-8?B?Y1QxUXp1bFlFdktoVVBldWxBT2RXMWtueEpRbWhXMmpESENGdjk5T1MwT05n?=
 =?utf-8?B?RFJkL1Vwb3gzek10dkJldDVMdnFwcmRiK2VSN0lmajN1OUZDVHN2NXk0a0Zt?=
 =?utf-8?B?R0MzVXhyOXhVWTltZDNsclhLSUhqZk80cFJrTFczeUlEKzB0a1pPc3pNUCtC?=
 =?utf-8?B?WTgrMGNKZ2U2NXBnaW81azNNSG81ZHBqRWthbjUycWdGbnJnNmV5MSttNS9B?=
 =?utf-8?B?c1JhYlkvR2k5dkJhcDRzUkxCTkw2dStCZ0xGV0hyYXVaVmRqQks0cTNQc0lY?=
 =?utf-8?B?aUhlcnRkVGRXME5SYjM3L0dXT0tTNnZyYWE2TUk2dE9BbExrZnh0Uy9YeWxV?=
 =?utf-8?B?Uzg2aHowcGdQckpWclVVWkcwQ0crTllGU0xSNE5lMzdDeENLbkVhL3ZSa1lh?=
 =?utf-8?B?b3pSSDRNS3o4Y1NiN1BqSDAxbTVEQ2wzUzl0R3k3cnA1dU5ZcTdpYWczZHF6?=
 =?utf-8?B?TjQ1U0NPZ3JlZkg5dkYzMncwcmY3cWNQSFhKSmJZaWRKSGNJVUNjd2pKTU5J?=
 =?utf-8?Q?UcHDqre5Qdvw4lXxGSowPEhZm?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d51cb72f-50b7-4d76-6d11-08dc226b7d35
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2024 14:47:03.8123
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fw5jLfuONeV4S7pfPOQs7A04S1oqIQrztC7AzXIQlAyv3u/IKbtYxfovj+B51KZG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7298

On Wed, Jan 31, 2024 at 02:40:24PM +0000, Mostafa Saleh wrote:
> > +static void arm_smmu_make_bypass_ste(struct arm_smmu_ste *target)
> > +{
> > +	memset(target, 0, sizeof(*target));
> 
> I see this can be used with the actual STE. Although this is done at init, but
> briefly making the STE abort from “arm_smmu_make_bypass_ste”, seems a bit
> fragile to me, in case we use this in the future in different scenarios, it
> might break the hitless assumption. But no strong opinion though.

At init time, when that case happens, the STE table hasn't been
installed in the HW yet. This is why that specific code path has been
directly manipulating the STE and does not call the normal update path
with the sync'ing.

It is perhaps subtle that is why it is a different flow.

(this is also why I moved the function order as it was a bit obscure
to see that indeed all this stuff was sequenced right and we were not
updating a live STE improperly)

Thanks,
Jason
