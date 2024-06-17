Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2046.outbound.protection.outlook.com [40.107.212.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B125B12D74D
	for <patches@lists.linux.dev>; Mon, 17 Jun 2024 14:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718633206; cv=fail; b=CpW/SklS/sbd7LkYXfbg9bm/UwH3uS1tOTCwNurI1GTgi4NKl5Xk6BpPqqGCpkGw6ZDCj+ZnKVWt5EbwN3hJH3dtA3pAgAnO1PYe/sdM8BAmiSeq2yZQRm0LM6sb4HX1Q0w7YhjAyJJSDulAhEWyoOQqouIo14puoEN0r32bM1w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718633206; c=relaxed/simple;
	bh=LOK1JlPq/27QpWJ8GH4DpmNWd/m0lqnUpVMlHmr2QC8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=J7hyJu+Yy/3FfHrOFDOg69OVof3eW+xR+ifOb/IU4fOZ6o3HN69fz9lfZC5NYshldYFJxewrjhgRIDgccWp+I8lifRlW2w5IIiyYr9gHgm8g6BpAMe4yMUWsGTR6ksrx1tGcgdjiMyMa2Hm2KYB5N2aEWknT3FdV5UKsUq/MX5M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=O1Lhbfkn; arc=fail smtp.client-ip=40.107.212.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="O1Lhbfkn"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FhOj8+/4jKsfsl80ImhEn6ecAMq9/NeI80KAToiMcvnCTBowB7N+x9OpO8go1pJEj50Kjuz6XICLJaEqfCxsxdVUT7JoZ1Pd4bYAl9lK55sijnHn6lcyvj1eMX0ch9nkzIwEKZ1VswGRWtprSHHD7kLTJaR2gbjwb5beRiNvAdJ7oUr+EcL7Lmv6Gs8BY9NHzr4zIbPmjOmhHrxQ9DoTI0Zn0/jL08lgsi3heUZIPAcWr6Ohc4fqWqV4NKh5s1LVPqd3v1JWeyVVgLNaXenL12oofA0CeE4GRIexyXhw83+lyeXlTuxSL9+znI2HD2yVXlvQ7wq0zD8YMSBOsgEpLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mz84ufwAsQlW03FXnATiQZpEKn/ont2aFMFsJeaITZo=;
 b=WNp4paFFvcWSUiFR2FuCdbasL5jua/hh7ZcfFVqEcqba/cj1F5FavRWtpFZDiCmJpbyovBIVlyxGviEYxDPM9Uu5W24q7lcMNW023OZ4o/bPqLR9DOFqrjvsZ4QpZdt69XCl4e650sF5Er/tkB1ns3h3WcPHew0sf4tb7VE4p9U8+xcQ0/0cQG61YOuJq1x9XjaumeJ0ypwTbQ1PWkkWL9v03y0cNBdaCc+A9muHRk4cEFhk7m3hBsmps/yWFVXcKheSx19U3Z8L265TYRW4SVBCbhiG6PrNByhV2bq/+QXtbTashvSuuKGH6hLH1xeGLWhzsY+HgA6Ao21kYrY8zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mz84ufwAsQlW03FXnATiQZpEKn/ont2aFMFsJeaITZo=;
 b=O1LhbfknlspfTDIRm0p7I0/IqQp1aJ6qM3VMn2kx3TR71xxVIiGOOw/2nvG7IcWjBLn0VhIGAvDglhbYzzgNbRxWLd5NFayC9+vJf95SUG7l4l/VatumAg6j4iy3MVDDqoJVsoctBZ/oS/wULjNJ14Vez3sOI2X8LolwIhGdbt0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MW3PR12MB4553.namprd12.prod.outlook.com (2603:10b6:303:2c::19)
 by DS0PR12MB7995.namprd12.prod.outlook.com (2603:10b6:8:14e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.30; Mon, 17 Jun
 2024 14:06:36 +0000
Received: from MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::b0ef:2936:fec1:3a87]) by MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::b0ef:2936:fec1:3a87%5]) with mapi id 15.20.7677.027; Mon, 17 Jun 2024
 14:06:35 +0000
Message-ID: <4be771ef-9329-4094-a4ca-5ae9826360fb@amd.com>
Date: Mon, 17 Jun 2024 09:06:30 -0500
User-Agent: Mozilla Thunderbird
Reply-To: babu.moger@amd.com
Subject: Re: [PATCH v20 00/18] Add support for Sub-NUMA cluster (SNC) systems
To: Reinette Chatre <reinette.chatre@intel.com>,
 Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
 Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
 Peter Newman <peternewman@google.com>, James Morse <james.morse@arm.com>,
 Drew Fustini <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <20240610183528.349198-1-tony.luck@intel.com>
 <658d9869-ef22-48a7-876a-5bbba4f134ff@amd.com>
 <bc52a051-4296-48ac-9a83-29139855553f@intel.com>
 <e17d3a79-9c07-44cd-b0ea-2d0545680342@amd.com>
 <f57e9cf2-35b6-401d-afc2-8d11b22836c2@intel.com>
 <a65739a4-1c0e-ab36-611d-e2da0bd1d00a@amd.com>
 <bd2a8f5b-783f-49b7-b32d-efba4729b84a@intel.com>
Content-Language: en-US
From: "Moger, Babu" <babu.moger@amd.com>
In-Reply-To: <bd2a8f5b-783f-49b7-b32d-efba4729b84a@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA1P222CA0063.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:2c1::12) To MW3PR12MB4553.namprd12.prod.outlook.com
 (2603:10b6:303:2c::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR12MB4553:EE_|DS0PR12MB7995:EE_
X-MS-Office365-Filtering-Correlation-Id: d91b3745-421e-4054-4e39-08dc8ed6b262
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|7416011|366013|376011|1800799021;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dWJRVTJFLzRhcnd3cE5UZis3WEhBNFo2TDhCTEFySUlhcWxQV2pQUDFnbVp2?=
 =?utf-8?B?MWJxTkVFY1hxZW1HS0xlVjJkU0t6V2t1d2dha3Y3eEJIalUvLzE1MEllenJO?=
 =?utf-8?B?djBXT2hmTHNQVjVITExaUzBFTVo2NlhQMWdXNS9mQlk3bWw4dk5YTGFrbndN?=
 =?utf-8?B?bG5uTWdUMzBoL0JYVy9QeHZZVDlMc1kvc0lIcFFmTDFIZ0Z6SHBEdEMxRjFF?=
 =?utf-8?B?b2RzMTZiNTFZQm8rK3ZXYzRVUG1wVFhkR3Z0RXVsL0JSR3Y1YVYvM2xDUmYz?=
 =?utf-8?B?SWFJeGNXR2c4RjFRUzhqdXQ4SGdQc1hTT3RiWEZjNkg2QkdZN3JZeFJRNDlL?=
 =?utf-8?B?OEFDMUN5N0JDNzJyd25mZVREdkZBeDFtQS9uY25PcjE4cDF2ZzZlaUFuQkRO?=
 =?utf-8?B?RjhQbW4xRXFReUhNam51UytkZXpEWEgrQUpvaEJoVEd0YkZTQXdBZnY3ZExu?=
 =?utf-8?B?aW5YbTNqckNsV0lyU1dOeldaNGIzYWhDY2tPMCtIb05hUk5TbHFHSEJURjBs?=
 =?utf-8?B?TWdlbFRnMkJkRXRxUmZkZ3hnNFlXVGQ0UjJCU2lsWVFldlhMeU8zVWxMbXph?=
 =?utf-8?B?ek1Wb09CcGcrSGQ4ZGJUT2J1WXlnNURzeWljSjh3UHJ4eDhRVkxobW02ODRM?=
 =?utf-8?B?NTJZZ2xCWHZ1UWhaWmxESVBPVUFGcVp6VnFEZDNsWmpMZmFac0VUQ0ljaldv?=
 =?utf-8?B?MllxVDFFRjZzVWtvaXNjQVhjR1Q5QlhZV2dzRmVLQ3MxTU9jTlhyY09CQnA5?=
 =?utf-8?B?amVnUXRTdFdOdWpjTFp5c3dia2I2L25OajlOWWk3YnN0V21acDF0QTd3QWhZ?=
 =?utf-8?B?eklPUnc4L0hWT1BOVHFsTURuRWlPNXoraFBub2t1MlZHZEhPME4yZUZrcmEz?=
 =?utf-8?B?ZEFTM0RDbk90VHEwVGsyTVlMckxSOWZqQ203cGx2UDFnU1Y4VzBycmcwSS9l?=
 =?utf-8?B?ZmR6dUxxbkh6K1AxMlFMUWdiMmFlZ1Zjb2Q5ejBjREoyTUlsVHQyL1p3TDVo?=
 =?utf-8?B?Z3pXaHFETGJ5ZEt1UzMxd05aVGZDUSt1QXdlaVkwbHlreHlSdDVUWkZtTXU5?=
 =?utf-8?B?bGZKQnJpYk1VbHhUd1Jsa1dLQXdUd1kyZWpNM0J6U09nKzJRUTY0dFJpMWtL?=
 =?utf-8?B?OXZ3azI0VnVlRGVVeHEvSDNRRjE0RHdtQnFDUENldlo5aDN1MENSanFzS1Nm?=
 =?utf-8?B?dWxER2VQclVzd2R2cHhYQy9ZV3NDMnpISUVNT2ZMaUE2RVZLcDZwZEVtOFhI?=
 =?utf-8?B?RDVtRm5YYmZwWXJlbmQvZEkyNWhjMFA5RWZIK1htRDJzZUlVWnRaQytGOHZq?=
 =?utf-8?B?QUJhY2hIN1RXRytHbXJ3ZmVZZks1eHplY1JkL2M3QmJ2S2lINW9nUXc2QnpK?=
 =?utf-8?B?RnpKaTNZTWRoc0VOZnRtNExVRk1KNXJwUkV5TDIweWZRMG5veFhZcS9QM2dj?=
 =?utf-8?B?UFNCWmJycGFOeVdwaHBTZmZudlFTVGIzVFVVTEkvOXJNYkI3ZWF2Smo1dXVZ?=
 =?utf-8?B?eGNMVUZhTm9NZEdiZ1dwM0VIMFUwRitkOC9uY1pLalZlSGhXWnYwUXFQdkNz?=
 =?utf-8?B?ZUVqSkNhK0dXS0JmUklPYjAyR3gvN1AweDJSQWNzT3A3aVlJME9qRU1VWm0y?=
 =?utf-8?B?SWpIK3RFejZPWHZTY3dJa1J3Ykxtdk9nWjZtLzVUS3NvQ2JjeklObks5d3dP?=
 =?utf-8?B?aTVvaFh4Z2xaeVN0UkxPZVJoL1ZMTXQ3SThkUmVUTFEyK0dhSlFjNHh3PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4553.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(7416011)(366013)(376011)(1800799021);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c0N4aEg0eHZ4eEg4M0JGcTdkcTVQQ0RrT1pNc0RHeXplWjV6aTFuQXVLZjFD?=
 =?utf-8?B?c1RMamJjOG1Hd3I0eXpQY2ZVdUlOZUFqZ0YzT2ZXUnE2aHRHQ20yazVBalNK?=
 =?utf-8?B?ZEV1NWYrK1QxenovamdCQnpEOFhNdzF0Nms3TzU4Z2xNVUtmRUJKZkZ1N2Vu?=
 =?utf-8?B?U3B4MU1yWDROZUZGaHZDcU5BV1g3bFlIWEVSNXVlSzU1NTBsR09wbnpISmhL?=
 =?utf-8?B?Vmt4WGpQNWdPZXBEN0R1dUdNYjNxaDdibnN0SkdyRzJHRzlWN3BtQklYVkVx?=
 =?utf-8?B?TzZ4dXpBOGJpUHh4eVFrTTZFTGMweWJIeDdlZHhVZlJGZDE1bE9UVEVUTE4x?=
 =?utf-8?B?WkFLUlZIUnRCbTZtZ3FCMVRVdWpqZmNJZlJXN0ROME10SFozaUpUbndheTNR?=
 =?utf-8?B?K2tkcHdEa1FPMHBWU1RpbDBUcnNwTnNUdXZkRTd2Nnh2U1lYamtGaEpMS2h0?=
 =?utf-8?B?eWRTLzRDdVZkVCs3WkNZWmZZemVrdkQrYndyOHlmV0ExUk10d0hVTk5yZUNL?=
 =?utf-8?B?NjZGbnYwUzlRRWY0QkIwbUJlaDBnajJGMFNQRk82SHFMQlVOMW82VkVEN1ZB?=
 =?utf-8?B?SFdaWUI2OXNWck9wZWplODRqMFo2ZGw0QXA0NTkvaWpNb1RpSU5QMmZXcUc0?=
 =?utf-8?B?bGxYYTNsTHZRYUdzeExBR1pYb1MwcUpNNUVCY2pablNTSkdOcm8rT25aUlNS?=
 =?utf-8?B?WHRacHdQdFo1ZWw3ejZTQWV1NnM1SjZNNnRKSm4zYTlVaHplV05nMFNzYmVW?=
 =?utf-8?B?TzdxbUhJbXc3M255TzdtR1NmV1JjYlpZcWFxbVJoV05pdUsxRHhMV1NhNlAz?=
 =?utf-8?B?TEVobGVkdEQyc1kzdFR1TE5MUjdTYUNVT2FzOHRKQTV5dzVuM3YrNGFnSm9Q?=
 =?utf-8?B?cDFEZjhLNVhEQXdNZDlVc3lzWTV5MWsxYWVUeVJ2YXNQNFMvM1ZNNVpkZzFF?=
 =?utf-8?B?R3dkSFRUQSt0eXFyUG51OUR2ZUYyMHQ4Ymt4UFZDR2dpeHhFRkVELzRDTnEx?=
 =?utf-8?B?aDRQUjJCTzhkNnlaODNRWDhhZEpIbWY0OFh2NVN0THlKQVd1VllNbGF0b1Vu?=
 =?utf-8?B?SXZNVm9LZVdqc0lUU2RaR0xsTEdMRDJlSXROZTVhNFpDM3dEQlM2d3JMT1or?=
 =?utf-8?B?ajNIREVlVlVZckVUS3k5KzNReGNmRkVPZjdLUzkxVERuMFZycjJPdVArcjB3?=
 =?utf-8?B?RUFWeVg3OS9QQzhKOHlrMGg1N1plclFGRzhjRjlucXhUODhPWW5zdXhoZWRR?=
 =?utf-8?B?UVVIRWpoYnhVM0dSc0lQSlJqQ0JpSXBjeHE0d3Zmdmp2YnBVdjJRUldTeGRO?=
 =?utf-8?B?UGp3YktDWmhGeWhoWmRpUjJaTlJXYU1SdjFhL1VVc1FiejR0RW94K3pFU3Q5?=
 =?utf-8?B?Q29ZL1N4UVlsak0rdE95c056TjJJMjhOTmpqY1lJeEw5akZHYVZpbC8wdmIz?=
 =?utf-8?B?eWcreXRVM3pJQi94ZjdkbFB6SndlTGZuZEhPRkpLaExiUmZDS0ViMXN5VC9z?=
 =?utf-8?B?WTJDVFQvRnltVTl2SHhZaWlUczkxUUxXWE5DVS81VjFBU3RoYXNZSUtLMVZ3?=
 =?utf-8?B?Y1ZBTGFsckdkN1VkSWFrNU1jVE8vNnA4SXdldDVvSEs1dzdHYmo1cXhnNmpj?=
 =?utf-8?B?MXBXSFlNMERSd1F4R1h2TFNmVzhlRGlpK0FLbTl6Um9Sc29EYWYrYUR3NmdO?=
 =?utf-8?B?QlFlcFhKdlNzMGorZ2U2a3ZTbE4weTdZR1B0M1ZocWxlemxWK1FQNFlTMFNQ?=
 =?utf-8?B?dDBDWHM4NHQ3ZkhLeUxud3FUdzRGa1o3VDRtclBqbGRHbVhnOW5xSHlUMjFV?=
 =?utf-8?B?OU0vZWppdmxUQ2FTaGZEVURnQm01R1FUeTN0cHJLeFNTL20reGs3eGZGUGNT?=
 =?utf-8?B?b2ZYdlNKcVFpR3YxcGhPYjJrNmV5dUVqRVh2VWJ5WUVsTzZLYm85aTI4QVMv?=
 =?utf-8?B?aHl2OG42TVE1R1J3V2ZSU29tdzJGTjVPeW1ralBLa0hPdnJ2REwvV2xTTi8w?=
 =?utf-8?B?NmZEY0tJTVFtR000eXc0R28vdDFrcEI3UGdkYjdpK294akdrY3VJZDRsdjVk?=
 =?utf-8?B?QXI3QUZSS0VjdXhVN2JUTVpRb0VtZUJJOGZrYjNrb3JvWEVFV1lKdXRiS3Fa?=
 =?utf-8?Q?21fo=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d91b3745-421e-4054-4e39-08dc8ed6b262
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4553.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2024 14:06:34.9321
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mw2em9ijtIEa8OJ9/kpWAlRYJhzOPQuvKwU12r71URbBbPMA0LdeqIbbRsudEsgJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7995

Hi Reinette,

On 6/14/24 18:11, Reinette Chatre wrote:
> Hi Babu,
> 
> On 6/14/24 2:29 PM, Moger, Babu wrote:
>> Hi Reinette,
>>
>> On 6/14/2024 11:46 AM, Reinette Chatre wrote:
>>> Hi Babu,
>>>
>>> On 6/14/24 9:27 AM, Moger, Babu wrote:
>>>> Hi Reinette,
>>>>
>>>> On 6/13/24 15:32, Reinette Chatre wrote:
>>>>> Hi Babu,
>>>>>
>>>>> On 6/13/24 12:17 PM, Moger, Babu wrote:
>>>>>> I may be little bit out of sync here. Also, sorry to come back late
>>>>>> in the
>>>>>> series.
>>>>>>
>>>>>> Looking at the series again, I see this approach adds lots of code.
>>>>>> Look at this structure.
>>>>>>
>>>>>>
>>>>>> @@ -187,10 +196,12 @@ struct rdt_resource {
>>>>>>        bool            alloc_capable;
>>>>>>        bool            mon_capable;
>>>>>>        int            num_rmid;
>>>>>> -    enum resctrl_scope    scope;
>>>>>> +    enum resctrl_scope    ctrl_scope;
>>>>>> +    enum resctrl_scope    mon_scope;
>>>>>>        struct resctrl_cache    cache;
>>>>>>        struct resctrl_membw    membw;
>>>>>> -    struct list_head    domains;
>>>>>> +    struct list_head    ctrl_domains;
>>>>>> +    struct list_head    mon_domains;
>>>>>>        char            *name;
>>>>>>        int            data_width;
>>>>>>        u32            default_ctrl;
>>>>>>
>>>>>> There are two scope fields.
>>>>>> There are two domains fields.
>>>>>>
>>>>>> These are very confusing and very hard to maintain. Also, I am not
>>>>>> sure if
>>>>>> these fields are useful for anything other than SNC feature. This
>>>>>> approach
>>>>>> adds quite a bit of code for no specific advantage.
>>>>>>
>>>>>> Why don't we just split the RDT_RESOURCE_L3 resource
>>>>>> into separate resources, one for control, one for monitoring.
>>>>>> We already have "control" only resources (MBA, SMBA, L2). Lets
>>>>>> create new
>>>>>> "monitor" only resource. I feel it will be much cleaner approach.
>>>>>>
>>>>>> Tony has already tried that approach and showed that it is much
>>>>>> simpler.
>>>>>>
>>>>>> v15-RFC :
>>>>>> https://lore.kernel.org/lkml/20240130222034.37181-1-tony.luck@intel.com/
>>>>>>
>>>>>> What do you think?
>>>>>>
>>>>>
>>>>> Some highlights of my thoughts in response to that series, but the whole
>>>>> thread
>>>>> may be of interest to you:
>>>>> https://lore.kernel.org/lkml/78c88c6d-2e8d-42d1-a6f2-1c5ac38fb258@intel.com/
>>>>> https://lore.kernel.org/lkml/59944211-d34a-4ba3-a1de-095822c0b3f0@intel.com/
>>>>>
>>>>
>>>> Went through the thread, in summary:
>>>>
>>>> The main concerns are related to duplication of code and data structures.
>>>>
>>>> The solutions are
>>>>
>>>> a) Split the domains.
>>>> This is what this series is doing now. This creates members like
>>>> ctrl_scope, mon_scope, ctrl_domains etc.. These fields are added to all
>>>> the resources (MBA, SMBA and L2). Then there is additional domain header.
>>>>
>>>>
>>>> b) Split the resource.
>>>>    Split RDT_RESOURCE_L3 into two, one for "monitor" and one for
>>>> "control".
>>>>    There will be one domain structure for "monitor" and  one for
>>>> "control"
>>>>
>>>> Both these approaches have code and data duplication. So, there is no
>>>> difference that way.
>>>
>>> Could you please elaborate where code and data duplication of (a) is?
>>
>> We have ctrl_scope, mon_scope, ctrl_domains. mon_domains.  Only one
>> resource, RDT_RESOURCE_L3 is going to use these fields. Rest of the
>> resources don't need these fields. But these fields are part of all
>> the resources.
> 
> Correct. There are two new empty fields per resource that does
> not support monitoring. Having the new mon_domains list results in
> the benefit of eliminating monitoring fields from all the domains
> forming part of resources that do not support monitoring. Providing
> more details below but the additional pointer results in a significant
> net reduction of unused fields. Having the new mon_scope field results
> in the benefit to support SNC.
> 
>>
>> I am not too worried about the size of the patch.  But, I don't
>> foresee these fields will be used anytime soon in these
>> resources(MBA. L3. SMBA). Why add it now? In future we may have to
>> cleanup all these anyways.
> 
> This work does indeed go through the effort to _eliminate_ unused fields.
> Note how all domains of all resources (whether they support monitoring or
> not) currently have to carry a significant number of monitoring fields.
> These can be found in both struct rdt_domain (*rmid_busy_llc, *mbm_total,
> *mbm_local, mbm_over, cqm_limbo, mbm_work_cpu, cqm_work_cpu)  as
> well as struct rdt_hw_domain (*arch_mbm_total, *arch_mbm_local).
> 
> For a resource that does not support monitoring it is of course
> unnecessary to carry all of this for _every_ domain instance and
> after this series it no longer will.

Yes. I see that. Thanks for the explanation. Lets go ahead with the
series. This feature is been pending for a while. I will provide my
comments for series.
-- 
Thanks
Babu Moger
