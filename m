Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2084.outbound.protection.outlook.com [40.107.243.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 766494642D
	for <patches@lists.linux.dev>; Sat,  7 Jun 2025 00:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749257556; cv=fail; b=qtqsQhYR3ZpnwOe4vyrYxqTOAKCuM6ZjH2DEL2hNiI1hmC2gI9WT3tC4n4HUoAUj8GISV1cG6oZVEYmFDXhi4a8uXDHF8iHp/nJuGcDLYp0GlM0FifR4Q+vodQZucE0D1nVJ+WKESjjevleF+oaHVf8D60IF8FDBCGaOrzK7Ulo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749257556; c=relaxed/simple;
	bh=KYDJHQrgY1jMb3otetQhKsHXXfZPr9VItQlGSyTQkbk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=M6sR49Wpli6Ksr3ZicpzPpPhu5l7gtunNcKzpHcVzaq6RFQFzBWX+twQA66lFi8tGNCn3kaTJyCuZgqQvRW7H/5RGHojF6KqiNTuCY7GEDiLMrQIr1KUb//KuPSCh6zL5EgB9wPIwShVLkygNjD8n06/YHDzSCy56bMwJ7OxfRA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=e+NhElLq; arc=fail smtp.client-ip=40.107.243.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="e+NhElLq"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Vvl5CcS1XJtpHq4ncQS1nQCr4zqmUjVobUG2MD9CuBZ2QxeSXPpMvVIAXzr/vXUXXztjEEIKy5itzLo7q9g/LcMDpCMPYvYwNwueeFubWZHFSGaoRRLbvnR9FeMt3rCKxeGxJK4vqlUPN3DKPB1l2AvehFvUSQjg/V7cJMhpK3sjhZcgDDMYTSpCJfWDFsDJ48VcztSIH0+LBKHvwChfFT7rigz64+Run5pV1BK6CyMYDcJpcRmwFIY9rSrRE2SuiYhjSVgqpGH7zL49FWKSfeFeIrn9ZauaGyvetFD2gSOhLgh9D1h1/Az8Nyg7VN/H9cZZyafGZZ7HVbeBxaqVgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TL9P/nrQfrNXIipPgxPLqfrpVZ+nd0uxd6XWdhTkPfM=;
 b=Okp0gRmcUU1swxnBgBtCGgkmRA/ygbptby3DOZ8cx23o3gjKBZcWMMbDIGkVJm9KodCYSvNr5PJSZmGN5HK6y78W/eY9XmE6I89U8k9kVXKrZEP+4Ga2W3SIBui+hm3h4Ui3S0K0wYEFG+OtOLTAka4A5YAGeNh4OJf6AmDhPsvLNlH37PLBrn1KWkfyceD/38NRTwklI3kU/ZLelDuTt6LTGyK9mciYJwgqutJ65YFmgjycaC75fk9/2U6owPMHAU7MYTUHehSol+UKmbZpSPPC/uYfHO5FnUX4a9w1N3MtoDWEMNpVfAJSHPQVYda9ZBVlCZIsMyNaZzZVz35ewA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TL9P/nrQfrNXIipPgxPLqfrpVZ+nd0uxd6XWdhTkPfM=;
 b=e+NhElLqkqimCesfEN6LfdZKcv/6ZC64zt9konEbVhfRqhSsLbNrjGwZUEFZEHQS6HJGbdh287Y7XeEtp5Zpg+P7d1Peu1x7rkGI31wTMNGgEQdmbQKv44Rc1qDSstkw6VBJGpymhxtN/CJ4G8XeovfrzXJ/oALXT+gJDnQrmmmX1xDuAyhnwBUZybH+OOxRQ+16k9c1gUTo+5+txTF0zTwfPWsAgNzk2443QgaO/dRoDEmhECNlOXrgM9CN9nwlS5KquzAFwL0zj5T7/QNwQIj0uJOdgHyTdymwcUUvTqTND1hqSXkWK9ux5EWR6svg0JJxOJlQyXdWDTRialoqpQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB2667.namprd12.prod.outlook.com (2603:10b6:5:42::28) by
 PH0PR12MB7930.namprd12.prod.outlook.com (2603:10b6:510:283::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8792.35; Sat, 7 Jun 2025 00:52:29 +0000
Received: from DM6PR12MB2667.namprd12.prod.outlook.com
 ([fe80::bd88:b883:813d:54a2]) by DM6PR12MB2667.namprd12.prod.outlook.com
 ([fe80::bd88:b883:813d:54a2%6]) with mapi id 15.20.8792.034; Sat, 7 Jun 2025
 00:52:29 +0000
Message-ID: <ccb22f13-c717-478d-ab0f-ab4fbb0a8862@nvidia.com>
Date: Fri, 6 Jun 2025 17:52:16 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 10/29] x86/resctrl: Change generic domain functions to
 use struct rdt_domain_hdr
To: Tony Luck <tony.luck@intel.com>,
 Reinette Chatre <reinette.chatre@intel.com>,
 Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
 Peter Newman <peternewman@google.com>, James Morse <james.morse@arm.com>,
 Babu Moger <babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>,
 Dave Martin <Dave.Martin@arm.com>,
 Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
 Chen Yu <yu.c.chen@intel.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <20250521225049.132551-1-tony.luck@intel.com>
 <20250521225049.132551-11-tony.luck@intel.com>
Content-Language: en-US
From: Fenghua Yu <fenghuay@nvidia.com>
In-Reply-To: <20250521225049.132551-11-tony.luck@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR13CA0023.namprd13.prod.outlook.com
 (2603:10b6:a03:180::36) To DM6PR12MB2667.namprd12.prod.outlook.com
 (2603:10b6:5:42::28)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2667:EE_|PH0PR12MB7930:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f28e92a-4855-4614-ffbc-08dda55d9098
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TURpU0RaWXF4a1NYSmJSNEZVb2treWRtUTZ2NDlMUGFQUjIrZU83MWQ3KzYr?=
 =?utf-8?B?M2wydmpLcSs3S2QrTnpKTVZKV1djMTlCYUJDOWE1WkxscjNRQVhBcUczbW9R?=
 =?utf-8?B?UHo3ZFlZOW5FcGxnUHpaMTdEVWtHV0xJbUdsNENPelF0alN5dGpSNjJ3WTJl?=
 =?utf-8?B?bUtPVWtDQ0hjWExlakRoU3JSdFFQU09oU1BkRlJ6Y1BpK0Zqdk5BdUEwdVl1?=
 =?utf-8?B?cEdoY2lhYTBweDNSSVE2TEFhQUFmQkw2MEY1VVZmRDRpNzZuaFZzeDVKUmxn?=
 =?utf-8?B?bW9nOWRaZG1LR1lNeHBpZEdkVnc1UERVL2JDaGk3dTlGdmZnZVAxL0lBNVJN?=
 =?utf-8?B?ZVRIa05nam1XRmFlU3psaW5HK0NmWWZrLzVYYXB6WjJLbVJxUFRGeDc5eE13?=
 =?utf-8?B?VUhkb0htbVIvN25hOXJxVGZoakI0Y05YYW5rL1pXcUFqTXdGU1hXeWpRUXlN?=
 =?utf-8?B?dGxyUVdiV2lJVDNJR0l3M0Qvd2VUdjFEL2p0VlVzN29BQXloaFA0ckZTazdi?=
 =?utf-8?B?cGJQZml4TGQ0dFB5NDE1OUlLWnA4TjNPUC8renVRd1JMU2ZINFpQSitkZUkx?=
 =?utf-8?B?SG5UWmttWHZJeHo0c1lPOVhKcElqbkRSRmJMTkREM3U3TUorNjE3dG9CT1FJ?=
 =?utf-8?B?aUg2MlArdnJPMlRveWJVTnUwalA0ZGNiVUZuYkE1THVYTW1UcVlpNVdUMFBj?=
 =?utf-8?B?OUdNWFRpZzROTkZTaW1MUXkrTVJQdDlVMFZ2UHV0UWtuWHZQUEd4Z2loVnM3?=
 =?utf-8?B?Z3JmK3ZnVFNrRUJjVXJXRzFTcGx0K0NXbFFhNmZJRDFsU3VkWVhSR3pHTDlt?=
 =?utf-8?B?S2xxR1U1SXJqcTFqa29NWXJEKzVsUHdpZTVUUXNqNUo0S29iRVd5d2IwSGlp?=
 =?utf-8?B?djIwMVRCWFM4OWl5bmNLa2FYMmpwYiszWkVxWXRBS0tGS1MrYWJ6Q0h3Kzcy?=
 =?utf-8?B?MEdCVlAyRVExYkt4MnQvM2gvL1pzSDJWbTE1WTdyREJibHppWGUrcDJXMzh2?=
 =?utf-8?B?WkFvK2NORHgydXdyVnBBSTJ2QW9LTDViVDcycmh1OVpsdkZFVEplSmVTQm1y?=
 =?utf-8?B?MG5JSmQrS3Zsd2RybnFyYXVBZ0UwTFBzZ1RrY0NBSWtHSWduS3VRVmJvdi9Q?=
 =?utf-8?B?Qlgva0NTV2NlOEc1ZU01K1VCdFBrZVhYek5Db0NwRHZhQ0puY0x2bkFyTHpM?=
 =?utf-8?B?dDMrU3QvZEtPaXJySUl1THFRY1RTc2lJeW1lRTZDaUg1b250QXgzdndjR1FN?=
 =?utf-8?B?cU4vMnMzSDRoRFJUQXUxTy8wTWtiQTlKVU9YR3h0VUhMT1R0dG9GQ1gvRE8y?=
 =?utf-8?B?VEpLcHlBRXpBbXZBTXE2MjFrZU56am40QkhabXAyS09Sa3V1Vk1lSWJLV0NZ?=
 =?utf-8?B?dEpMU2t2bXRoWm1UejVzazlNMVo2ZHNhN3pJTnc4djNkQ21IaHNnc05PV280?=
 =?utf-8?B?ajh4aWRNZXFYSXdBMzM4aC95QTRORHhRcTNGVTNxd3NvSXF0S214ZVlTY3BR?=
 =?utf-8?B?TDMvbCtJRzNFY2ZIeVBuY2wyclNxSXBTK2Ezd3F0RjN1aVl6RU1ra0NnUHAy?=
 =?utf-8?B?bXhrODduSURrVmRIZlgwNnpCVGd4NllKdU5YekFjOHluTFdnQjBQYlRwT09S?=
 =?utf-8?B?YkFJOVN3eEFNV2xLYUdYbkIyNmR4MnMzUzEvQUhqcWNhWG56amt3RHlBOHlI?=
 =?utf-8?B?aFduSkxZdEdlL1hacERjalE0VWs3cElQbktIT0NsRTY5SnVVMExsUVlhT1lF?=
 =?utf-8?B?TW95RGExZlZDM2tvTlJaSTF3cGpuVnZHOXk2U2p2NjNCR2pqWFoyeEJsdStM?=
 =?utf-8?B?ZVZML3pGOWlOY2Y1TjFyYnN2YTFPYVFCMTJDclFhQ295WnZ0NHJvWlpZVUgr?=
 =?utf-8?B?eTkzdjh1MEhhd1kvUVFMOUNPQzlBbHlkeThjekxhbERlL0RjV2hWVFpTUHd5?=
 =?utf-8?B?NGNSbzFyNGVlTGYwWmYwaEFVOHFsMFFnVGlQa1RrU0tKZXpsWlZjM0JLQUZF?=
 =?utf-8?B?MXh1OXVIODJRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UHBPRjhXcElYczlPeDR0RW1UVG10UnVDVHVRNWpaOGlmUjQrRU9mcnRVb3kw?=
 =?utf-8?B?WDZhQVUzTlUyNWpRSGVDS3BhT2c4L0FJcXZCd0NWTmRUWUJ0RnBwN05ML2Fk?=
 =?utf-8?B?YmJmbTRXOU45M1hlT05wWFF4eW5kRE1MbnlJTmxhTkROY2tpS1dFb05SaDZE?=
 =?utf-8?B?UDNtdFQ3dU1Ka0dKcjZyZy95dm1VMjVUcERFV2lqVnhlcWJkc2ZNSGlNQzA5?=
 =?utf-8?B?a1FqUDlwR2RVSnNyNHZRaEZMRnB1S3VpNDdqZ3ZiVVkwcWN1UEgyUUY5OXpy?=
 =?utf-8?B?VHhPVXptdGFtMkJTRXQ1NGd6RzBwcDlJQ3YwK2EvaG5rc2dWQjFyUlZhWGdN?=
 =?utf-8?B?ay9icVhCTDZqWFVLWVhMV3gxdGRkcGJVTEI1Uk5QemRDSmQwL2J5bWp6dFBx?=
 =?utf-8?B?bkJQZll2RGJnSzRMVlNUN2phOWNpeUp4K1I2V3Y2YjhDVGpmaURETVJlT2RU?=
 =?utf-8?B?QXdlL0cyRXpnem02Y0tpejUzL3FhNHFEdVpCRWxYeDJSSm83VnhxYlNzUGlh?=
 =?utf-8?B?NEl1QTM4TWRYYXp4MFBxYkF6ZHZpR3RoNXZranFCVlN5d2g1R2h1Nm9LRWpo?=
 =?utf-8?B?cFBKL0dSRGs3WEFvVUUxb2JCTVhSRlVjM3pKMmJDRDkrV2JRM252NHpvdWtH?=
 =?utf-8?B?NTBXaWdjOE10YkxSUkhNd21qREtCZ05vY3U3RW5Sa2FsUmljSDlpWEVZM250?=
 =?utf-8?B?QU9MeDl4NzJtUE5KWVU1eGpEeGV4RThqT0VEejUyNnkrT3dGQWtyczZ3ZVFM?=
 =?utf-8?B?VFVpcTNTQjZSWXNVVklLN0RBVWpwWGlaZXRucmVBUTVURk0zYTVnZjBUazRQ?=
 =?utf-8?B?SzBmQVlRWXJGL0grTlNzZTB6elY4RUFiWTMzWWhINisxV0NNTFRtMTk0Z2V0?=
 =?utf-8?B?ZFlwRTAzSzJ2Z3NJUlNWNDlrS1duWTNvdS9SU0hheURWRGdEdHJ3emsrSjl2?=
 =?utf-8?B?VTFQNFFmRHpGdEluU3dpZy8yK1psbEl4dXRUM0NRMXpmSjZQSE1UZnB4c1Ja?=
 =?utf-8?B?eTNPM0JWLzlKUGh2VkV6R3RFOTZkRlpPdG9STmFIWnRqNDFDTWwxL0gyYUNp?=
 =?utf-8?B?Y3ZndHJJOUc2OUhvS01rYkdMZ29qNUJiM296SVpBYzVzbmdPWkdITXhzTjR0?=
 =?utf-8?B?SVVibGV1bW9xcmFML0JtR1BFMUZ0dCtDVmhaeXoyOEpPNFFTaXlSWU53THRj?=
 =?utf-8?B?UG81bGFjc1E2ZEkzRzZCUGZ6aitKakxjK1h5RExIYXJSVURLajZxWnNIUDlW?=
 =?utf-8?B?SUZyaVNXVGJHWEdhR2ZJQVlrcHdoRUdCMkwxQ1lDdVl1Z2V5MS9FcndRdWlD?=
 =?utf-8?B?aDExRjQ0UjJEbUtXYWM3N25xMkdnNGY1bTNTN3VHMU5KZVZ4dm04cGJVZm5I?=
 =?utf-8?B?Y1BSMXc4bGV6cmFmRjdaTWUzeGxuTytzWjkxMTNXZTJnU3ZFWDJ6WHhyVGlQ?=
 =?utf-8?B?YUpCRnFrdjZJV0txSitVMTFQTXNhOFVHR1NYNU4rVU5QbklOUTQzVVBMUG9L?=
 =?utf-8?B?NnRvTURZSSsweVBka000dWowa25ZR3liMjErMWU1ZG1iWnZvdzhWVUI0UEh5?=
 =?utf-8?B?dUxoend4QWdBcVdHNHZvMGFEWjNKUXVReHFnOVBleWhqWVZaNWJ0ZHVFc0tl?=
 =?utf-8?B?Ny9KM0lLT1FxaWdhaFFnK2Q1bjV5NDBuWEFtNUdOQit4Q2Npc1hrZm5CVzVr?=
 =?utf-8?B?T0ZIWmZPSG5NRFZjb09KY1cxOVloV2tpeThnWlNkOHJ6YlhvY0EwV2M2c3Vw?=
 =?utf-8?B?bkE2eEFoTmFPYkY4YVpKa2ZoQll6L3lieUdoZkZkS3FmNDBMTHQycWpDak8r?=
 =?utf-8?B?TUcrc25IV2JydENMRnlKYm4yT1o0MEhPZTRvd09MWldtN3RvMVVQR0hHZEJD?=
 =?utf-8?B?Zk1WSXJ3MWVrWGZFWW11aW5TTVJ5YjFEMjFkOFdiU0xhVTc4TTY1bTVqdzlo?=
 =?utf-8?B?dlBIYnVKckxUMjg1NDZBeFZYeXgwZXFNL3NUUFVmZjFVV2Z5M1pzM2NCMHJ4?=
 =?utf-8?B?OXY2Vjl6a0thSzRaQ1lmanlUc2NqVGJ0OU8yZUZnOXRmelppd2xacWM3dnpj?=
 =?utf-8?B?eUVoQ3ZROGh2cHFtS2FDeU1CRTY2QW1UaW9FZ3ZtckdBdjIrbUZiRHNmd0pQ?=
 =?utf-8?Q?n4zc9ssXQd3el7B1iPvMV1ueS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f28e92a-4855-4614-ffbc-08dda55d9098
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2025 00:52:29.8008
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g8Z5cRvGw7itx3kLQuXRAslCRk4WfyXDucnzoDEk/cOGppAKaIGaa8bKPZz/F+mTIYvoS9Q43MrwwjGp38g3Ig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7930

Hi, Tony,

On 5/21/25 15:50, Tony Luck wrote:
> Historically all monitoring events have been associated with the L3
> resource and it made sense to use "struct rdt_mon_domain *" arguments
> to functions manipulating domains. But the addition of monitor events
> tied to other resources changes this assumption.
>
> Some functionality like:
> *) adding a CPU to an existing domain
> *) removing a CPU that is not the last one from a domain
> can be achieved with just access to the rdt_domain_hdr structure.
>
> Change arguments from "rdt_*_domain" to rdt_domain_hdr so functions
> can be used on domains from any resource.
>
> Add sanity checks where container_of() is used to find the surrounding
> domain structure that hdr has the expected type.
>
> Simplify code that uses "d->hdr." to "hdr->" where possible.
>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>   include/linux/resctrl.h            |  4 +-
>   arch/x86/kernel/cpu/resctrl/core.c | 39 +++++++-------
>   fs/resctrl/rdtgroup.c              | 83 +++++++++++++++++++++---------
>   3 files changed, 79 insertions(+), 47 deletions(-)
>
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index d6b09952ef92..c02a4d59f3eb 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -444,9 +444,9 @@ int resctrl_arch_update_one(struct rdt_resource *r, struct rdt_ctrl_domain *d,
>   u32 resctrl_arch_get_config(struct rdt_resource *r, struct rdt_ctrl_domain *d,
>   			    u32 closid, enum resctrl_conf_type type);
>   int resctrl_online_ctrl_domain(struct rdt_resource *r, struct rdt_ctrl_domain *d);
> -int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d);
> +int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *hdr);
>   void resctrl_offline_ctrl_domain(struct rdt_resource *r, struct rdt_ctrl_domain *d);
> -void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d);
> +void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *hdr);
>   void resctrl_online_cpu(unsigned int cpu);
>   void resctrl_offline_cpu(unsigned int cpu);
>   
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index e4125161ffbd..71b884f25475 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -458,9 +458,7 @@ static void domain_add_cpu_ctrl(int cpu, struct rdt_resource *r)
>   	if (hdr) {
>   		if (!domain_header_is_valid(hdr, RESCTRL_CTRL_DOMAIN, r->rid))
>   			return;
> -		d = container_of(hdr, struct rdt_ctrl_domain, hdr);
> -
> -		cpumask_set_cpu(cpu, &d->hdr.cpu_mask);
> +		cpumask_set_cpu(cpu, &hdr->cpu_mask);
>   		if (r->cache.arch_has_per_cpu_cfg)
>   			rdt_domain_reconfigure_cdp(r);
>   		return;
> @@ -524,7 +522,7 @@ static void l3_mon_domain_setup(int cpu, int id, struct rdt_resource *r, struct
>   
>   	list_add_tail_rcu(&d->hdr.list, add_pos);
>   
> -	err = resctrl_online_mon_domain(r, d);
> +	err = resctrl_online_mon_domain(r, &d->hdr);
>   	if (err) {
>   		list_del_rcu(&d->hdr.list);
>   		synchronize_rcu();
> @@ -597,25 +595,24 @@ static void domain_remove_cpu_ctrl(int cpu, struct rdt_resource *r)
>   	if (!domain_header_is_valid(hdr, RESCTRL_CTRL_DOMAIN, r->rid))
>   		return;
>   
> +	cpumask_clear_cpu(cpu, &d->hdr.cpu_mask);
> +	if (!cpumask_empty(&hdr->cpu_mask))
> +		return;
> +
>   	d = container_of(hdr, struct rdt_ctrl_domain, hdr);
>   	hw_dom = resctrl_to_arch_ctrl_dom(d);
>   
> -	cpumask_clear_cpu(cpu, &d->hdr.cpu_mask);
> -	if (cpumask_empty(&d->hdr.cpu_mask)) {
> -		resctrl_offline_ctrl_domain(r, d);
> -		list_del_rcu(&d->hdr.list);
> -		synchronize_rcu();
> -
> -		/*
> -		 * rdt_ctrl_domain "d" is going to be freed below, so clear
> -		 * its pointer from pseudo_lock_region struct.
> -		 */
> -		if (d->plr)
> -			d->plr->d = NULL;
> -		ctrl_domain_free(hw_dom);
> +	resctrl_offline_ctrl_domain(r, d);
> +	list_del_rcu(&hdr->list);
> +	synchronize_rcu();
>   
> -		return;
> -	}
> +	/*
> +	 * rdt_ctrl_domain "d" is going to be freed below, so clear
> +	 * its pointer from pseudo_lock_region struct.
> +	 */
> +	if (d->plr)
> +		d->plr->d = NULL;
> +	ctrl_domain_free(hw_dom);
>   }
>   
>   static void domain_remove_cpu_mon(int cpu, struct rdt_resource *r)
> @@ -651,8 +648,8 @@ static void domain_remove_cpu_mon(int cpu, struct rdt_resource *r)
>   	case RDT_RESOURCE_L3:
>   		d = container_of(hdr, struct rdt_mon_domain, hdr);
>   		hw_dom = resctrl_to_arch_mon_dom(d);
> -		resctrl_offline_mon_domain(r, d);
> -		list_del_rcu(&d->hdr.list);
> +		resctrl_offline_mon_domain(r, hdr);
> +		list_del_rcu(&hdr->list);
>   		synchronize_rcu();
>   		l3_mon_domain_free(hw_dom);
>   		break;
> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> index 828c743ec470..0213fb3a1113 100644
> --- a/fs/resctrl/rdtgroup.c
> +++ b/fs/resctrl/rdtgroup.c
> @@ -3022,7 +3022,7 @@ static void mon_rmdir_one_subdir(struct kernfs_node *pkn, char *name, char *subn
>    * when last domain being summed is removed.
>    */
>   static void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
> -					   struct rdt_mon_domain *d)
> +					   struct rdt_domain_hdr *hdr)
>   {
>   	struct rdtgroup *prgrp, *crgrp;
>   	char subname[32];
> @@ -3030,9 +3030,17 @@ static void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
>   	char name[32];
>   
>   	snc_mode = r->mon_scope == RESCTRL_L3_NODE;
> -	sprintf(name, "mon_%s_%02d", r->name, snc_mode ? d->ci->id : d->hdr.id);
> -	if (snc_mode)
> -		sprintf(subname, "mon_sub_%s_%02d", r->name, d->hdr.id);
> +	if (snc_mode) {
> +		struct rdt_mon_domain *d;
> +
> +		if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, r->rid))
> +			return;
> +		d = container_of(hdr, struct rdt_mon_domain, hdr);
> +		sprintf(name, "mon_%s_%02d", r->name, d->ci->id);
> +		sprintf(subname, "mon_sub_%s_%02d", r->name, hdr->id);
> +	} else {
> +		sprintf(name, "mon_%s_%02d", r->name, hdr->id);
> +	}
>   
>   	list_for_each_entry(prgrp, &rdt_all_groups, rdtgroup_list) {
>   		mon_rmdir_one_subdir(prgrp->mon.mon_data_kn, name, subname);
> @@ -3042,11 +3050,12 @@ static void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
>   	}
>   }
>   
> -static int mon_add_all_files(struct kernfs_node *kn, struct rdt_mon_domain *d,
> +static int mon_add_all_files(struct kernfs_node *kn, struct rdt_domain_hdr *hdr,
>   			     struct rdt_resource *r, struct rdtgroup *prgrp,
>   			     bool do_sum)
>   {
>   	struct rmid_read rr = {0};
> +	struct rdt_mon_domain *d;
>   	struct mon_data *priv;
>   	struct mon_evt *mevt;
>   	int ret, domid;
> @@ -3054,7 +3063,14 @@ static int mon_add_all_files(struct kernfs_node *kn, struct rdt_mon_domain *d,
>   	for (mevt = &mon_event_all[0]; mevt < &mon_event_all[QOS_NUM_EVENTS]; mevt++) {
>   		if (mevt->rid != r->rid || !mevt->enabled)
>   			continue;
> -		domid = do_sum ? d->ci->id : d->hdr.id;
> +		if (r->rid == RDT_RESOURCE_L3) {
> +			if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, r->rid))
> +				return -EINVAL;
> +			d = container_of(hdr, struct rdt_mon_domain, hdr);
> +			domid = do_sum ? d->ci->id : d->hdr.id;
> +		} else {
> +			domid = hdr->id;
> +		}
>   		priv = mon_get_kn_priv(r->rid, domid, mevt, do_sum);
>   		if (WARN_ON_ONCE(!priv))
>   			return -EINVAL;
> @@ -3063,18 +3079,19 @@ static int mon_add_all_files(struct kernfs_node *kn, struct rdt_mon_domain *d,
>   		if (ret)
>   			return ret;
>   
> -		if (!do_sum && resctrl_is_mbm_event(mevt->evtid))
> -			mon_event_read(&rr, r, d, prgrp, &d->hdr.cpu_mask, mevt->evtid, true);
> +		if (r->rid == RDT_RESOURCE_L3 && !do_sum && resctrl_is_mbm_event(mevt->evtid))
> +			mon_event_read(&rr, r, d, prgrp, &hdr->cpu_mask, mevt->evtid, true);
>   	}
>   
>   	return 0;
>   }
>   
>   static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
> -				struct rdt_mon_domain *d,
> +				struct rdt_domain_hdr *hdr,
>   				struct rdt_resource *r, struct rdtgroup *prgrp)
>   {
>   	struct kernfs_node *kn, *ckn;
> +	struct rdt_mon_domain *d;
>   	char name[32];
>   	bool snc_mode;
>   	int ret = 0;
> @@ -3082,7 +3099,14 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
>   	lockdep_assert_held(&rdtgroup_mutex);
>   
>   	snc_mode = r->mon_scope == RESCTRL_L3_NODE;
> -	sprintf(name, "mon_%s_%02d", r->name, snc_mode ? d->ci->id : d->hdr.id);
> +	if (snc_mode) {
> +		if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, r->rid))
> +			return -EINVAL;
> +		d = container_of(hdr, struct rdt_mon_domain, hdr);
> +		sprintf(name, "mon_%s_%02d", r->name, d->ci->id);
> +	} else {
> +		sprintf(name, "mon_%s_%02d", r->name, hdr->id);
> +	}
>   	kn = kernfs_find_and_get(parent_kn, name);
>   	if (kn) {
>   		/*
> @@ -3098,13 +3122,13 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
>   		ret = rdtgroup_kn_set_ugid(kn);
>   		if (ret)
>   			goto out_destroy;
> -		ret = mon_add_all_files(kn, d, r, prgrp, snc_mode);
> +		ret = mon_add_all_files(kn, hdr, r, prgrp, snc_mode);
>   		if (ret)
>   			goto out_destroy;
>   	}
>   
>   	if (snc_mode) {
> -		sprintf(name, "mon_sub_%s_%02d", r->name, d->hdr.id);
> +		sprintf(name, "mon_sub_%s_%02d", r->name, hdr->id);
>   		ckn = kernfs_create_dir(kn, name, parent_kn->mode, prgrp);
>   		if (IS_ERR(ckn)) {
>   			ret = -EINVAL;
> @@ -3115,7 +3139,7 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
>   		if (ret)
>   			goto out_destroy;
>   
> -		ret = mon_add_all_files(ckn, d, r, prgrp, false);
> +		ret = mon_add_all_files(ckn, hdr, r, prgrp, false);
>   		if (ret)
>   			goto out_destroy;
>   	}
> @@ -3133,7 +3157,7 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
>    * and "monitor" groups with given domain id.
>    */
>   static void mkdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
> -					   struct rdt_mon_domain *d)
> +					   struct rdt_domain_hdr *hdr)
>   {
>   	struct kernfs_node *parent_kn;
>   	struct rdtgroup *prgrp, *crgrp;
> @@ -3141,12 +3165,12 @@ static void mkdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
>   
>   	list_for_each_entry(prgrp, &rdt_all_groups, rdtgroup_list) {
>   		parent_kn = prgrp->mon.mon_data_kn;
> -		mkdir_mondata_subdir(parent_kn, d, r, prgrp);
> +		mkdir_mondata_subdir(parent_kn, hdr, r, prgrp);
>   
>   		head = &prgrp->mon.crdtgrp_list;
>   		list_for_each_entry(crgrp, head, mon.crdtgrp_list) {
>   			parent_kn = crgrp->mon.mon_data_kn;
> -			mkdir_mondata_subdir(parent_kn, d, r, crgrp);
> +			mkdir_mondata_subdir(parent_kn, hdr, r, crgrp);
>   		}
>   	}
>   }
> @@ -3155,14 +3179,14 @@ static int mkdir_mondata_subdir_alldom(struct kernfs_node *parent_kn,
>   				       struct rdt_resource *r,
>   				       struct rdtgroup *prgrp)
>   {
> -	struct rdt_mon_domain *dom;
> +	struct rdt_domain_hdr *hdr;
>   	int ret;
>   
>   	/* Walking r->domains, ensure it can't race with cpuhp */
>   	lockdep_assert_cpus_held();
>   
> -	list_for_each_entry(dom, &r->mon_domains, hdr.list) {
> -		ret = mkdir_mondata_subdir(parent_kn, dom, r, prgrp);
> +	list_for_each_entry(hdr, &r->mon_domains, list) {
> +		ret = mkdir_mondata_subdir(parent_kn, hdr, r, prgrp);
>   		if (ret)
>   			return ret;
>   	}
> @@ -4030,8 +4054,10 @@ void resctrl_offline_ctrl_domain(struct rdt_resource *r, struct rdt_ctrl_domain
>   	mutex_unlock(&rdtgroup_mutex);
>   }
>   
> -void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d)
> +void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *hdr)
>   {
> +	struct rdt_mon_domain *d;
> +
>   	mutex_lock(&rdtgroup_mutex);
>   
>   	/*
> @@ -4039,11 +4065,15 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d
>   	 * per domain monitor data directories.
>   	 */
>   	if (resctrl_mounted && resctrl_arch_mon_capable())
> -		rmdir_mondata_subdir_allrdtgrp(r, d);
> +		rmdir_mondata_subdir_allrdtgrp(r, hdr);
>   
>   	if (r->rid != RDT_RESOURCE_L3)
>   		goto done;
>   
> +	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, r->rid))
> +		return;

rdtgroup_mutex is being locked right now. Cannot return without 
unlocking it.

s/return;/goto done;/

> +
> +	d = container_of(hdr, struct rdt_mon_domain, hdr);
>   	if (resctrl_is_mbm_enabled())
>   		cancel_delayed_work(&d->mbm_over);
>   	if (resctrl_is_mon_event_enabled(QOS_L3_OCCUP_EVENT_ID) && has_busy_rmid(d)) {
> @@ -4126,12 +4156,17 @@ int resctrl_online_ctrl_domain(struct rdt_resource *r, struct rdt_ctrl_domain *d
>   	return err;
>   }
>   
> -int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d)
> +int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *hdr)
>   {
> -	int err;
> +	struct rdt_mon_domain *d;
> +	int err = -EINVAL;
>   
>   	mutex_lock(&rdtgroup_mutex);
>   
> +	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, r->rid))
> +		goto out_unlock;
> +
> +	d = container_of(hdr, struct rdt_mon_domain, hdr);
>   	err = domain_setup_l3_mon_state(r, d);
>   	if (err)
>   		goto out_unlock;
> @@ -4152,7 +4187,7 @@ int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d)
>   	 * If resctrl is mounted, add per domain monitor data directories.
>   	 */
>   	if (resctrl_mounted && resctrl_arch_mon_capable())
> -		mkdir_mondata_subdir_allrdtgrp(r, d);
> +		mkdir_mondata_subdir_allrdtgrp(r, hdr);
>   
>   out_unlock:
>   	mutex_unlock(&rdtgroup_mutex);

Thanks.

-Fenghua

