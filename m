Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2048.outbound.protection.outlook.com [40.107.237.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F2461B950
	for <patches@lists.linux.dev>; Wed, 26 Jun 2024 08:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719389068; cv=fail; b=ONEAabX3l4owh6kCDy64XhFsjYoOGAL3fd07E73bj52YXjDW5475GrWPCSh986J+9+aQEu2pk3itvS3DMS7NUaMS2Rf3kaSsqB5Br8qVQjAE1ySkQUz1AI0ycMAkO9jeTzdQyFBy3bEKCGRoIfD/H5PrQr3cVdHKPBfFVyfrKXc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719389068; c=relaxed/simple;
	bh=QIqF77HWNhl14y3MqXLB2LQVvhYpWljuMxm1KPmgX08=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YtYf+jY3+R2Kw3JUYqxSxObYuejmdbn+71zYjLpwRJFVMohtrhgMpIpjvza7JQolSidWzpti38dckXqMuFhRS+lHUnYa66bWcmqJO13U2ub0n49+VswRtxDooawi6FOI/pZvJQAyRWwetxSDpe5jCTERURkudReo6aj1g4vRRr4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Ai3DkIyV; arc=fail smtp.client-ip=40.107.237.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Ai3DkIyV"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lq77F4YLpJBgs5MSjTGFZfFeSxbmrqNlseFl7j2ggvNjZdjlGaMcirJ9IsOz+ZU68ZO07JBmX8oe5shZelUyjRU1WiDWQAZdCkgJ2W5euvnjSe0CiRzNwqGm631eGW2h2DsjklPMLldHLBpccWGtno05iaP0FTYx9a7GfgvxZzU2kiYC9PR/XSbUG86l1WJlm8TC4XZC+PIn9Oi/8dQ/gXi9UjUVY4MkZ2JrhFAwWeXfXwc+GBBJZgELKxz1LOu4DN6yUobwtuHSHF+uVJLNSCCx+OS/bdZqeEaiUWBHVXGcQOEuJGaEs/gC90FuR5lCpl4ISnEHHGwbl222ncyG8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ffCzjzfS5XXurXsd6emh1F3seXkHK1sX1x/bAfeLzQ4=;
 b=WOkqSkDn5ESdXj60fFfbm1l35U9tzj2A1VrT7D4VbrxtXc6rt/+l41yGfpWKv67zFJ6wPxSt7KgWp6aAHXG5ly3sVOIkJB+Ab0qXOpBTtt1qD62+QmXbaaI9X2SRTRGr+r60JXNsG43A/t+ee3pMOPcqiCu6kL8WmdzO7rWyDVinikwj2ZzGLbFkf+A0ZjRBKWqvXhi4wTQOTTvSIlN+wzLtGB8+vcrLVjxfGjOYo6S8UCPNxrJAJHxOlmq4gKbP0ZdwDv+KKaNzRKCCApuM8M1rMYginb5m6JtaJDX/REwBw2aig7aApkERfaiFUBjpVMuZnj4ZNoUrkrLvY6Of7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ffCzjzfS5XXurXsd6emh1F3seXkHK1sX1x/bAfeLzQ4=;
 b=Ai3DkIyVZlm21pfMujqZljlFk5RKdI2ErIQyOSeq8vO5ceotn01DnWQhVDtLdjU5W07Yl0jNDDnGn50TKlbsiKdeRjQHFQKerg0S5GlgldPexH7kOSciSWn8mknGVSP2TA9nyVTOVBjwI5mN3AlJWBbLCPRam91HTpkXw4sHR80lvBbNZRYNGKJGaCyTDSBDMuOhjYBjdJYAjorG35RUyXAVQ8BNrw1TbMswiOJN1/i1YNvLD4YfXfdZzH16CVBY5dPg9pB6t7V9SY0u6ldVaeTqGj7Wq2bw8ZKaXd+BlL0azLhCLi/jvTQzmjQV/fE3ur3cEofItCuNBXn3oVnbZA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 SJ0PR12MB7007.namprd12.prod.outlook.com (2603:10b6:a03:486::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7698.30; Wed, 26 Jun 2024 08:04:23 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::ae68:3461:c09b:e6e3]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::ae68:3461:c09b:e6e3%6]) with mapi id 15.20.7698.025; Wed, 26 Jun 2024
 08:04:22 +0000
Message-ID: <2e55dc18-0154-402d-ab81-cdcd00c2f77d@nvidia.com>
Date: Wed, 26 Jun 2024 09:04:13 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/192] 6.6.36-rc1 review
To: Naresh Kamboju <naresh.kamboju@linaro.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Anders Roxell <anders.roxell@linaro.org>,
 Dan Carpenter <dan.carpenter@linaro.org>,
 "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20240625085537.150087723@linuxfoundation.org>
 <CA+G9fYuWjzLJmBy+ty8uOCkJSdGEziXs-UYuEQSC-XFb5n938g@mail.gmail.com>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <CA+G9fYuWjzLJmBy+ty8uOCkJSdGEziXs-UYuEQSC-XFb5n938g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0428.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a0::32) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR12MB5444:EE_|SJ0PR12MB7007:EE_
X-MS-Office365-Filtering-Correlation-Id: f10cbbad-22f3-42b2-f8af-08dc95b696c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230038|366014|376012|7416012|1800799022;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?US9uVUx3d0JNL0wvSzdPT0dsNitmVmFWRU5TWlVnZHZVNlo0TWltZ2hwOXdl?=
 =?utf-8?B?OU9CUzE0dDhOalo0OGtENE5XUk94YmdBWWdyUUNyeEZQQm5sZmk0Y2xZdW5D?=
 =?utf-8?B?a0pxWmZSVHEvd3dadTBzLzZ1N3RDdW50eTMrTW1HeU03RVNCWlJlZ2pMTnJ6?=
 =?utf-8?B?UnB3VFgxRXdSZUdBNHMxRlpubmY3UGVwMzZCTkNJR3VsWUdyejJncVI1MkYx?=
 =?utf-8?B?OU1OeWNTNkwwOU5Md2hxU3JaQWJ6bTBQVS9nM2NuWktFUjhJQWMwdE0zOHpp?=
 =?utf-8?B?Wjg2M0JIeCtyYXZydmpNUnhJZUltQWI1TG0wSU5HQkNBRkZ1MjF0UGxYTkYz?=
 =?utf-8?B?UHIwUU9BNnJIbmRhQ1Y5QmJEY0RwVjNoVWEyRFpMNmNsWHZ1OXM0V1lBV2dv?=
 =?utf-8?B?NFVaSDgyb3dadXZmL0dOUjVERWJNSUFMTG54VVJHVDd3R2NwM0lrNEdkdjNI?=
 =?utf-8?B?OEFobjJVYU1QY0p2RGF1WW1zMUtZdnJwUjF4UnpwV2RnaTFTRUw2VmtoWXRm?=
 =?utf-8?B?TjJuam5qUTFqUWlBYUhpbFVtaVVVWHhCcStZQ1ltZEJ1ZHEvUE5RZTJkYzFp?=
 =?utf-8?B?VDNmNDJ4UzFEZndHL3FVeVR1MXF2c0J0dzFyb21EcHhrUDM4OTlDbjBtTG1m?=
 =?utf-8?B?R1prNHZJOWJqV1RYNkVwbXA0Vk9leWxjaXhmSEpiQjNnZXhBV1psMU9jZE5k?=
 =?utf-8?B?c2duTkJvb3J2M3hJejNJbTNOcGpJS0thVlcyTHU0MWRSdGNseWx1MVR1U0Ir?=
 =?utf-8?B?Q0JzWG9YanZ6OGRTWXJLejJqM1Z5Yi9hZjJaOHdlNi81dy83MXBsdHpna0do?=
 =?utf-8?B?NkhZcDFSTkJiTS9ROUF5VEV3MnpCNkFod0QxU0JqeWpEdkFUejlrZ3lYYjBR?=
 =?utf-8?B?Tys3RGtGREkwaWMzL3FSYThxVHU3YnJ2a3YvcHNmYkFaVi8yZk8wdFlVSFhl?=
 =?utf-8?B?bWVZR043aktIRll3WTlqWm51OFpGaUpZOXBzSTZjVzdZS0Y5ZUtuVURaK0Z5?=
 =?utf-8?B?RVdzZHVIVDVzbEtkYnVUSmE3Uk92TTl6bnZyVloxckJVU1hONWh5NFY4eTRW?=
 =?utf-8?B?NVZHdzJoc2tHSFRvU2IxYWdVZW16VW5HN2x1MWphbmpRelNlOFdPZm1DMC9J?=
 =?utf-8?B?RUJoLzRvYUhaakJPSndEYm93d3EzR1EvdG1ZY1dMM2YwRHF2RzJvS1RMZGMw?=
 =?utf-8?B?MjlSMzR3ZVBaRG9oNkdLcFc1Sy9QQk1uUUxrckFyN25DUlZiWWY2RFZUZ2Rq?=
 =?utf-8?B?RHlwUFBORzBxZUY2UWNlNUJMQ0hjSDNnSEhJN3MwTjN1V3V3enhqY1ZEb0Ir?=
 =?utf-8?B?MFIrc0ROMUh2ZkhPOE12QjRXckFZS0tqNkVnL1pEaXlZUnpqZzNYdnBKcjBy?=
 =?utf-8?B?SUdHL040Z0JKVlRLbmN1SlhtQ3Y4eTdTM1dDWURXRVhRbU9TTmYyaGhnM1VJ?=
 =?utf-8?B?UHFzcjZtK0RCMHJEdVJwOGdacGE4Z3BDMG94ME1idEZLb2dUMWxIUnFGOEdS?=
 =?utf-8?B?OVNicGV5YVVaeWQwck4vYkxyczB4OVlxQXUveGtQUitTNUx2R3R5TkoxbmZa?=
 =?utf-8?B?MWs5c2tEM2lGUmNNVml5Y21zMWZwZURYNkhpOFZxSHpFMVNBZTJ1RFo5aHNr?=
 =?utf-8?B?M0FSKzVqSW5sWXhCTEJTTUxmQStPQUQxSWpqZUtodnZNZkpHUzJtay9Ta1lj?=
 =?utf-8?B?RnJ6a21seHozUkprLzZKWDVQeDFKWGxid1BlQlo0R1c3SFVFMVJNUTAyUHY0?=
 =?utf-8?Q?VfjNr2W3eDNvNE3LgUBcyEK+csxz182CKTj4uQB?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230038)(366014)(376012)(7416012)(1800799022);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bTNVS3k5R2tSQVZxdmI0WlI0bktGNG1PbnNHUmQ1RzJwWjFjcFFaZjBxdkZw?=
 =?utf-8?B?UzdxcW4rUk5hajkxS2FRUmgrN2VBTjAzZEJJa1ZrcHowaXFTaDhaaExQYjhX?=
 =?utf-8?B?N1RXR2pXT1NESHQ3VHFDbXJnL3BGa3ZjbzIraFpWREtsSUpqUm9GODhDWlRl?=
 =?utf-8?B?M002K2N0WXVKdTUzMmZTYlFlcU5nUXFFNGx6SzlOL05zem5iSHhEdE93Y212?=
 =?utf-8?B?RUc5RCtMdjFWU2xhM2VDQ1FubW1jdGFBd0tuZUJXNllMRFVEM1k4WTRjMStV?=
 =?utf-8?B?eHlqNGJNN3RNRXFWSjFvVUFQdjFwTEhCb3ZvYkNnOGVyRXNQQitvUThINDYw?=
 =?utf-8?B?RHFnSjZ4Ujd0M0tsYVE0SmpYcmJYcUp4aERUM21SZ1VGSHU2NlNGMzNuWmV1?=
 =?utf-8?B?enp2OWwyVFdoZ0NhTzg0SzRPWjF1YlZuRk9CSWFkcCtTWnNZZGhHWjNsMExQ?=
 =?utf-8?B?WFRPTHVvZnQxK1ZYdTZzeHBCcXdZZVphMUMyYUM1ZURzK09ycXlzeStWc0I1?=
 =?utf-8?B?dHhPYVg2bFpYbEFtRmJHTXBuZGJnSWVlY0kyeklpaGdXTjdGYkJnaVNnZE1y?=
 =?utf-8?B?a3VRWlZ0ZzVUdXhkN1BoWE1GbXR3Wnlud2tETTJ1MnJjTXMzOTFzRlhOeVBt?=
 =?utf-8?B?SC9mTmdZbytLUWJOZU8xU3cwSHlYNkZ3UUJWYWJVVFZFbmtzN3Z3TzV6cFV1?=
 =?utf-8?B?aWhTb0lpSCtIKy9FY3dqb3VYOEZpMmRmR2JocUVCNXJ5V2gxK1pFZ1RaZG9J?=
 =?utf-8?B?SERScmVSbjh2STNTVUtkeXpNOCs0aWpjNExBakRxMzIvRk5EbFdVdkg2T2w2?=
 =?utf-8?B?R0xrcXl4YUI1b24rR20zVHIrZ2R1ZDR4b0VKN2pzY21teDAzemJLelBVVDBF?=
 =?utf-8?B?TXVKVVM5cnFONjhKQkliQWlUZHAwUTRHUDM3ZCtkbit6Q0dvSG9mKy9QU3BU?=
 =?utf-8?B?anNZTW9oaHFRanpLSVIxc1JvejAzM0t1QWN0U24xbmhabFJnV3JXdWtBMyty?=
 =?utf-8?B?alVNKzJOTmR4bWhsTjVMZzBUODhadmZvOHhManlpbXF4N3dWUTExREd6VU9M?=
 =?utf-8?B?WG9RZFZFYTJwWUw1UGJISUQ3VTQrdUwzYnJ1UmhFaDBPR3BubkUwejBkYnp3?=
 =?utf-8?B?RGpSbytaMDgwQW9aUU5XWmxla1IxMmZrZXZIdjVEekpjMlJvVzBLNEhaNHlo?=
 =?utf-8?B?YjA3UUphU3k3dE8xbys5M2ZjWFNWSWxnWWl5RFM1OXVBa3JDeHZaQzRveEFN?=
 =?utf-8?B?eEhoZ3Y4Tjg3a0ZHMVlNZExxN0liRXZmQVBsZk0wQTRmeEZ5YXZudDcvS3FR?=
 =?utf-8?B?UmpxNVBWNS9CaE0zRVNxZVcvdkQvQ2Vraks0NWJ5TjcyeUJSb0JjaFR4NFY3?=
 =?utf-8?B?MjBuS2Y3dndSL2lKb0tZV0NIT0hKd1R6R3laU1lhSnp1QklYdHh2V0ZNVmV4?=
 =?utf-8?B?YldySytoVzVxbHB6R0xpNmttWmkyQmNUVk9sczF2RGUzaGw0S1hGYnY1enJv?=
 =?utf-8?B?K3M1Z1lObW45U1JBZkx5V2hjNllIUndOUWs3bytmcjRpMlh6L0xOME5aUG8x?=
 =?utf-8?B?UFZQdkszM1FQdEcwaXZNYTdnaDh5L0VmNEpYZjNhRW00bUtRaFB3WnhTWUIr?=
 =?utf-8?B?clpnUnpqY1BoWUR6d0VFbFFVY1F0YWp6bzhYWkhhcVdmanF5ak05MTU1cEND?=
 =?utf-8?B?TThwcVJpTmRScXIzdlBodk9rU05qOVBNYnA3Tk5nYUpUL3kxbFFyK0R6MzVs?=
 =?utf-8?B?U1o4eEdLeWlrQVQ5M0l1ZWwwUEhETzdUN2VWdUlRK2dTSDNlRGFvQ204b1Vt?=
 =?utf-8?B?LzdpN0hLVkFIZ3lDMnczcytVakdOak9WN3JEUlJSQlFzeENqQlBTNGlMYzZT?=
 =?utf-8?B?RnRaZUptMDBYSGlCMW4wQy9YT3IrK1hjdUh6V3Ayc0hyUmYxbW1zMkJHUkp0?=
 =?utf-8?B?UWZTN252blMrVGd3c2FRWnJOVE03VzFLL3pvT2R2RUpUTTRpcTBGOThXUStu?=
 =?utf-8?B?Z1VVSzN6UE5OS1FPMXh2ZWExMDJ0VXFaMXVMTUI5ZUg1R3NZSmVQV2tYRUxW?=
 =?utf-8?B?aGljL2UwVlhRLzFoSnlNaTZNNks5eXV0cXM1ckJxdW1sVldNZHRWSXpGZkZR?=
 =?utf-8?B?T1pIRGgzc0NvNDBGbTdoNmJTU0lUbTBTNVk5OXovQk1hbURsZ0kxYkNmc2p3?=
 =?utf-8?B?bGQ2aWFGMWZSWEhLSVZpQjJrOTVRbWprMHpueDRYLzdOUktRck5TTjQzaXU0?=
 =?utf-8?B?aVI0RjFYdHNKRFhyb2RTVXdIK3hnPT0=?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f10cbbad-22f3-42b2-f8af-08dc95b696c8
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2024 08:04:22.8466
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sVPz9NUU7PZf6uB6NSpGmMqG+7MXwxe1ZiNWjzySZRZaWYu3IKZnVCwV8bgLGtdlll7VKhhx1qvu3oi7RXPFNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7007


On 25/06/2024 12:09, Naresh Kamboju wrote:
> On Tue, 25 Jun 2024 at 15:18, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>>
>> This is the start of the stable review cycle for the 6.6.36 release.
>> There are 192 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Thu, 27 Jun 2024 08:54:55 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>          https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.36-rc1.gz
>> or in the git tree and branch at:
>>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
> 
> The arm builds are failing on stable-rc 6.6 branch due to following errors.
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> Build log:
> --------
> arm-linux-gnueabihf-ld: drivers/firmware/efi/efi-init.o: in function
> `.LANCHOR1':
> efi-init.c:(.data+0x0): multiple definition of `screen_info';
> arch/arm/kernel/setup.o:setup.c:(.data+0x12c): first defined here
> make[3]: *** [scripts/Makefile.vmlinux_o:62: vmlinux.o] Error 1


I am seeing the same build issue for Linux 6.6.y.

Jon

-- 
nvpublic
