Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2079.outbound.protection.outlook.com [40.107.220.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BDEB1474CB
	for <patches@lists.linux.dev>; Fri, 14 Jun 2024 21:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718400578; cv=fail; b=GiVyMdlzH3oXVYmxiB9QDq8iG/oUWWoN8BsbBOIGyuoG9vrmMMExy4OEqVkd6erEqWbFJJcdKQUD//O/116ljoWAKttoTBLwSTqjmIhPZI8rz+LS1d2Xfo0pnSGfVz0e1+HrY5Aepwu/vVAkkYdMv/lltnYdkludPrD97YrPaYw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718400578; c=relaxed/simple;
	bh=LZnCDjr32c2VFBqAVzGPVrnLrotuoieROomGpGh0AEY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=H+741jpFKDhGGlB2H03aYnzszy6vgoResUYvT2/VvKccwwAntsU7s61MDJrh/tdKo7uuMk8jHM22Uaic8Qfj7Dk9Fk2wmXe8VRuEasGmNT0Uo3FG/cThJbiLjGacedjtYIjM5XPwK/58rWEDh+yZm8BbpPttwKQha/zyRW/BwBo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=4c5BRCBk; arc=fail smtp.client-ip=40.107.220.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="4c5BRCBk"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bihbk9Hg0uPfBiG/Tqu20p3g9i3ZQwCH/pmtIJhj+4VgPY0xPMnMKinLIC25Eu13tQyeHUKkckM9D+s+rXlmJWPLxBXe5y143ezRX/m8PrAz0vb9hX4mYmNQCPIOVcjYOdShLhPX3vWJZx0QBrfWVwonjhQXecHpDrYUB/qMkLsIyE5GsqutbCMyHPagJQoeDe9raHFeHoN3IzT8BFbYHhMOznZBtlRvNMolnSCWRiA/DNDzwqocK0RGNfTI3ZLB/599DllKgLUypLxGY7yXvFUNmEyM/jeupsNhugjDuu8S9nPvk1HmQ0qGo/X0k0qCD97WDWjeusLNF2MNOoUg/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tx3xSoFc9PAm4vToiIG4Ce8Z4Q4ENcjPZ1fIePhVsgM=;
 b=Rg67ekuQAipQvZ8RhnPF5p2gMk6/bRQcEc0J0mwvXS9MUVXQa/m47ZkiqhnE8NLEa5Jqgz22qHf1rSptZwAz1u/rDlkZeK9KCKS1rpi663Zai6uwbmPQYx0hzE1DsRpsoqUCQ6du+7WWn/dONUZ9TAs+e7OjPB7mhG6aIjib2VRzrASiLRsnRFGAtHHTeRV4gomPf1COKjPgMW0968gNHKB+hSbm6/4TVtjKMhebro36SLgeIBcxi/sZ0p6qsrGcUTfKQuGpnu2LamGgCcLMCZBmcOfi4Lux4GmQtrf5EGyNlAnG4nGQQhSZWYiw1CIRdKZd1YfctZWqOOEG5A6M7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tx3xSoFc9PAm4vToiIG4Ce8Z4Q4ENcjPZ1fIePhVsgM=;
 b=4c5BRCBk9MZeJSdMHheoXDjTQmWnJTsRpwXDSaXkvovdJah8lfKvpeLhNF37TqYsmgFneIfR4vHlt7KwooJ+2kw7cKkBq4qn1FixRf/VdiQ2yFsdozpH2/Jl2j6egLEfBcOrWx2lIO7yQYdBiK/Jg8C4HFaAAVqyHPi+haRlBfk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MW3PR12MB4553.namprd12.prod.outlook.com (2603:10b6:303:2c::19)
 by BY5PR12MB4067.namprd12.prod.outlook.com (2603:10b6:a03:212::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.25; Fri, 14 Jun
 2024 21:29:33 +0000
Received: from MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::b0ef:2936:fec1:3a87]) by MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::b0ef:2936:fec1:3a87%5]) with mapi id 15.20.7633.037; Fri, 14 Jun 2024
 21:29:33 +0000
Message-ID: <a65739a4-1c0e-ab36-611d-e2da0bd1d00a@amd.com>
Date: Fri, 14 Jun 2024 16:29:29 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Reply-To: babu.moger@amd.com
Subject: Re: [PATCH v20 00/18] Add support for Sub-NUMA cluster (SNC) systems
Content-Language: en-US
To: Reinette Chatre <reinette.chatre@intel.com>, babu.moger@amd.com,
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
From: "Moger, Babu" <bmoger@amd.com>
In-Reply-To: <f57e9cf2-35b6-401d-afc2-8d11b22836c2@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA0PR11CA0006.namprd11.prod.outlook.com
 (2603:10b6:806:d3::11) To MW3PR12MB4553.namprd12.prod.outlook.com
 (2603:10b6:303:2c::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR12MB4553:EE_|BY5PR12MB4067:EE_
X-MS-Office365-Filtering-Correlation-Id: bc28d5a7-fa10-4366-bb33-08dc8cb91513
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|1800799021|366013|7416011|376011;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TnZCek4zdEs2UUxTcDd3RzkyRDdML1RoNlBoR3Q5aGRUbE9NbUZEaGk4dVlJ?=
 =?utf-8?B?VXdCMXJ6cCtIS2pJSGE3cmF3OHZNVmJOSHk4NCt5SEk4Q2VUd0ZnRldLTDEx?=
 =?utf-8?B?ak91bHpFMEo1Qis0OWNTVXFoZjhFYXlQanRFdXNuUHJuS0ovMGdrUUVZMjds?=
 =?utf-8?B?TzFrSFFIUG1zUm5LbjJOc2w1QkZHRTU1YzR6K0g4YU1IQ1NMdGx1N3lTV3RS?=
 =?utf-8?B?cFBqNFB6Nk5VS0lVdEpIOGZKQlR0MDN5UHIrbkJPd01CMkVRTVk3V0FjdCsz?=
 =?utf-8?B?RXh4c0p5NWFjczRUOW05Ui9TZVFGMXV0U0hNQk1rbmlWZkI5blJ3aDVQL2I2?=
 =?utf-8?B?bXEyM0ZBR2lBN0U3KytFWGdZNHd3T016YUlNdHI5c3h5ODJ5QUlHWGl6cUdQ?=
 =?utf-8?B?YXZsNWFQSk9IV0thNDJSS045UXRIVlltSzZmUkVVNzRpa0MrZEo1azZLTnVv?=
 =?utf-8?B?eEhadUxMUTlISE9HTzNobzc3VWhkQVFpeFhMQjVpWStLdnZCSWtha2RzRXZy?=
 =?utf-8?B?TE9aT3FCeFY1QmdSYmhVZjdiaEJ3RGp6V3Y3a0Q5eUs3MnpJcStpenljMmkw?=
 =?utf-8?B?RU9qZXFPZ0tNMVpuVmZ0bnpXeUZEVklZVVBrZ0NEbnAwemtqeWZXcnlKdnhs?=
 =?utf-8?B?a0hFZ01Selh1RUZnbGY1eWRMT0VSVEdZZ1Y2SGZncTE2cEFveU5YcDlMUVk5?=
 =?utf-8?B?MnZWMXZPRkpkS3ZhU3p3SEtFa3BoWW90M1NyZ0ZIaUVRcVBmeVNzMVBENjlJ?=
 =?utf-8?B?Z0ZXR3VxeTFUWlFYL2pnMEI2WjBUbG1yalNXT1dseWVDWXA0NzNJZnp1dW1O?=
 =?utf-8?B?MnFMb0w0QThZM09DTmNyM0gyQzhET0N0cDFBWlM4VUNOczlNWVYyeG1RT2o3?=
 =?utf-8?B?dnpieGx5MldkWkV0K3FINTlOOFF6cDcvd09ObkxBaVRLeEFUemhvV2xXUkVH?=
 =?utf-8?B?NllTeGl2RGlCZHBRT1U4all1UlU3UGJUcXBGblRUWDNjSVZYdkx5SWRZUkNh?=
 =?utf-8?B?TjIrZXJYSTV0c041NmxldmVwaVJRWE5IVVhJRHRsSG9QMlhweWw2WHk4TitF?=
 =?utf-8?B?cU9INlJoM0ljWC8rMjRMRjlEemlRMXlpeVY3ZFBuaXBMbEl1VDhaSGNJZHJo?=
 =?utf-8?B?aVZSZVRWTEppRjdZa1hjTlZxM3M4QTViMFZCKzk2WUlzaXVYQkhtTVdZcERr?=
 =?utf-8?B?Y1VqcE4xZCtZb0sreDhvQzdsZGhJdFkyYmtwWElkV3VEL1lLMG9ZdmZoUmJT?=
 =?utf-8?B?VWVhVk5mUjJUcHVhLzE5SDZiZjluME40MVZGS3VYWlBFOGVDa1B3enIxRFIw?=
 =?utf-8?B?VTkxSkVvYVU5MUE2aVNMUmxOS1ZJQTZtak1weHNXVmp1dGt4Wm1VdnNMcklh?=
 =?utf-8?B?U0FXNVNEdlBMcFdPT0lFdGpVK0xrMkNRMS9JK214a2Q3eFBocHNzWFBDM29r?=
 =?utf-8?B?aTdtMHBFbEFaZkNoQ1dKdk5PWXlWSDgzdVgyZk1PcWpobGZzOHVKWmdmbFYv?=
 =?utf-8?B?NGhPRTg5UENtYjNSUU9GWHJ2QUtRNW1raUhYVG00Vy84TG51c21aYnNTQWQ3?=
 =?utf-8?B?NmpIZ05jQnN0aDdPK0xZSEdGN0pUVW9WVU9WZW9ZcU9zb0hPNlVEaHc5WVR3?=
 =?utf-8?B?RUdFU0VPcCtSZHo3OEFySXpEeXU3aDljTUhlbXFlQUdLS00yeUJkaDY1QVdr?=
 =?utf-8?B?SnR6UmhmR0RmZW9FdTA3SFZxcis0czJ1MjQ1dUhaUGpSQ2o2aEUzekZBLzMy?=
 =?utf-8?Q?V38VG6t7b3N/Rk7kNh3TVxdhbTlJcKHIkV8uVMN?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4553.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(1800799021)(366013)(7416011)(376011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZlhoOXMzNy8xb2NTZCtkK0tOcnZYN1NYa20rQU1DeDZwSlZmL3N1ZFRHSytL?=
 =?utf-8?B?bGpXcUIxcTYvT0czWUJubDBzTzhRdEZ6OHlzdkpQNXRTTzJzVGtybWNmUkRy?=
 =?utf-8?B?YmFVellBaEhsOWFybkFyaExVT2FIMkhYMXlEbVpib04wdEFYV0ZOY2ZKenY0?=
 =?utf-8?B?MnkxS0pSc3FZMFpVbGtkc0hhMFdsYk5OK1V1SlBic3ZxUzRGbEx0aENNZndN?=
 =?utf-8?B?V0t0Mnd0MUR1U0dMZGVXOXZzUzJBTUhTYkJYVHBqWkU3a2tCQVhiVSt4eXk2?=
 =?utf-8?B?YnMyK25xd1MyS2kyaFoveFVtZkpEZHA4Qk0wVnFHb0duTlc5bVFwVGZBTnow?=
 =?utf-8?B?NURPWE5zLzExTWc5dDlramtNRndaZXNOV1hpMERianhmUUJzZEpKdVcyWER5?=
 =?utf-8?B?aTlGSWE2eXZxL211eEtIenVpTzJIYjBaS2ZNd3piSFlyQ0Z2VFpNUHdkeW1L?=
 =?utf-8?B?SEVMSElzKytMQ2lUK29Vcm02RXhNRHREeVNRQ0FWRlpuMkFvNTRBQWQ2b0xy?=
 =?utf-8?B?bER0MWJrelpGRUdxUWZTRWNtMzBCaGg5K0tGZlZNdmdZSUkwN0s3NnZtM0Vr?=
 =?utf-8?B?Mm1vcFluUytuUTVpdzZvNTBZMUw4REJNSUpUajdiWERSb1VVam9wQyt6anQ0?=
 =?utf-8?B?Vk0vdHhGd2JuTmpKblJaeTBha0lva045U3h6bDkreDZGT2hUYmlVaW9vNUY4?=
 =?utf-8?B?VEtFZy8vdGltcWw3TWFWVXBlQ003alNUbi9UY0kxYVpVSWw3bHcrSElhbHll?=
 =?utf-8?B?dXdVT0RQcXBSYlV1cmdHRVQvZm83dVdkcDNDdDc2SnBSRS81TzlXa1dkcVps?=
 =?utf-8?B?Skl3QTNQMUVQQ2dTNGZ0ZmdteFEyWFZCYzVvYk5CWStrVWZuZkV2S1dUVkNa?=
 =?utf-8?B?amQwMHNUV24yY1JIRHpINllON1hHdzduZWVLVG91VXhsQlBVYWZSeFRQVk1W?=
 =?utf-8?B?dHQ0dVl1T3NWVnV0S1ZqcHZ1TERCMldwT08vYVR5OEhKMVdDcVppdHFCL2d0?=
 =?utf-8?B?WTNET3c2ZzUrNlJiSGtsTTRWNkczazdRamdkaXA1bjNhbnA3UW56U1hWeHB2?=
 =?utf-8?B?NDBycE50d2grTjYyN3U0R1BPVXdKSlJ2R1V2dzJCejN5alJQMnRsT0twc0I1?=
 =?utf-8?B?K1NlY2hYK0Nia2lNRXEydHVnR2RFbm1HNVFGNVQ5RHFoTFRZODZIaVFyc1ZV?=
 =?utf-8?B?OHo0R1Z5UkMzL3AwVTJaWDJZVUhGVUdLV1E2T25oczNBbWNTaVZZeFN3bVFm?=
 =?utf-8?B?M010dm9GNW9jZE9DM0VkNXFDdVlCbVQyejBpRnc4bWs3QU93MUpUdFJnUlRP?=
 =?utf-8?B?OU9weHlTR1kvY2o1Z0VrZ0dJQlNnLzVSMklZSXh5TzcrTTQ1aXRNR0lFL245?=
 =?utf-8?B?WkxRd25Oc0hIRDZjaEdtTFZ4ZGNBWVVMTnNGVkdTaG1kZktaL09ZOTNPRmV6?=
 =?utf-8?B?WUVrcGsxVE9FWkdwSmlkckg2bVZ1MHNMNjJ0UkZZYVdkQVc5STR5QmM3bGc5?=
 =?utf-8?B?alp0RUZUZkN6RUlXVFpKYnZ4Y0RCbC9uZ2VxY28yRmRqcXg1TDNTSUU4QzRw?=
 =?utf-8?B?Y1FCWFN2cXRJbEhRakRmWFUzTHVrTE95OGdCYzZDVkJOenUyY1AxVzVBKy9U?=
 =?utf-8?B?WVJJVkw3Y1ZibjFGRkdGVGtkNnBFcW9RRE5ySXJLMGtwTithSXNESFZCMmls?=
 =?utf-8?B?M0htMXlQd1pMNjBxeldpMWJsL3UvMTNmRkUyVks4Q21TdEVtNG4vL2xmcENo?=
 =?utf-8?B?WXRUMGJuSlZNckwyN0d3MTBRU3BHLzE3SVFreHhWbGludUdUNUpsSEZSNmU0?=
 =?utf-8?B?WFVobXAvQVhLMVp3UnVrRVloY0t2aDZhTE4rZm0zK3BjeEl2TGIyd3QzaU1J?=
 =?utf-8?B?WDhST0hicWVEaUViLyswc3IydHdwWkcxN2xnU25jWm0rRG5vL2FJWk9uakVP?=
 =?utf-8?B?eUNONXBkZ24zY0ppdkxTOWY2VUcwTEdNR0liSGtmci9ydjJzeGVWOXlOMHVn?=
 =?utf-8?B?SlFVM3A5bkJ5NGdTMytrY0dFaUZGZHAya2pKQkduM0Y5Mk1ONzFHRFJ1M0lN?=
 =?utf-8?B?UFhTcUhQbmlXcEt0YnJ0NVVobUlFWjNpN2N0YUtBcXZ3VnpBTTNLOXBlOVpI?=
 =?utf-8?Q?FJiXZTe7KSMC0xU14HCoxeJBv?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc28d5a7-fa10-4366-bb33-08dc8cb91513
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4553.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2024 21:29:33.1529
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TkvPek3xxdLHt8Nrk6B2cy2zJ5pO7NftGevUJdBgGNMeTTQvYfic1v6k8LmiMUsG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4067

Hi Reinette,

On 6/14/2024 11:46 AM, Reinette Chatre wrote:
> Hi Babu,
> 
> On 6/14/24 9:27 AM, Moger, Babu wrote:
>> Hi Reinette,
>>
>> On 6/13/24 15:32, Reinette Chatre wrote:
>>> Hi Babu,
>>>
>>> On 6/13/24 12:17 PM, Moger, Babu wrote:
>>>> I may be little bit out of sync here. Also, sorry to come back late 
>>>> in the
>>>> series.
>>>>
>>>> Looking at the series again, I see this approach adds lots of code.
>>>> Look at this structure.
>>>>
>>>>
>>>> @@ -187,10 +196,12 @@ struct rdt_resource {
>>>>        bool            alloc_capable;
>>>>        bool            mon_capable;
>>>>        int            num_rmid;
>>>> -    enum resctrl_scope    scope;
>>>> +    enum resctrl_scope    ctrl_scope;
>>>> +    enum resctrl_scope    mon_scope;
>>>>        struct resctrl_cache    cache;
>>>>        struct resctrl_membw    membw;
>>>> -    struct list_head    domains;
>>>> +    struct list_head    ctrl_domains;
>>>> +    struct list_head    mon_domains;
>>>>        char            *name;
>>>>        int            data_width;
>>>>        u32            default_ctrl;
>>>>
>>>> There are two scope fields.
>>>> There are two domains fields.
>>>>
>>>> These are very confusing and very hard to maintain. Also, I am not 
>>>> sure if
>>>> these fields are useful for anything other than SNC feature. This 
>>>> approach
>>>> adds quite a bit of code for no specific advantage.
>>>>
>>>> Why don't we just split the RDT_RESOURCE_L3 resource
>>>> into separate resources, one for control, one for monitoring.
>>>> We already have "control" only resources (MBA, SMBA, L2). Lets 
>>>> create new
>>>> "monitor" only resource. I feel it will be much cleaner approach.
>>>>
>>>> Tony has already tried that approach and showed that it is much 
>>>> simpler.
>>>>
>>>> v15-RFC :
>>>> https://lore.kernel.org/lkml/20240130222034.37181-1-tony.luck@intel.com/ 
>>>>
>>>>
>>>> What do you think?
>>>>
>>>
>>> Some highlights of my thoughts in response to that series, but the whole
>>> thread
>>> may be of interest to you:
>>> https://lore.kernel.org/lkml/78c88c6d-2e8d-42d1-a6f2-1c5ac38fb258@intel.com/ 
>>>
>>> https://lore.kernel.org/lkml/59944211-d34a-4ba3-a1de-095822c0b3f0@intel.com/ 
>>>
>>>
>>
>> Went through the thread, in summary:
>>
>> The main concerns are related to duplication of code and data structures.
>>
>> The solutions are
>>
>> a) Split the domains.
>> This is what this series is doing now. This creates members like
>> ctrl_scope, mon_scope, ctrl_domains etc.. These fields are added to all
>> the resources (MBA, SMBA and L2). Then there is additional domain header.
>>
>>
>> b) Split the resource.
>>    Split RDT_RESOURCE_L3 into two, one for "monitor" and one for 
>> "control".
>>    There will be one domain structure for "monitor" and  one for 
>> "control"
>>
>> Both these approaches have code and data duplication. So, there is no
>> difference that way.
> 
> Could you please elaborate where code and data duplication of (a) is?

We have ctrl_scope, mon_scope, ctrl_domains. mon_domains.  Only one 
resource, RDT_RESOURCE_L3 is going to use these fields. Rest of the 
resources don't need these fields. But these fields are part of all the 
resources.

I am not too worried about the size of the patch.  But, I don't foresee 
these fields will be used anytime soon in these resources(MBA. L3. 
SMBA). Why add it now? In future we may have to cleanup all these anyways.

> 
>>
>> But complexity wise, approach (a) adds quite bit of complexity. 
>> Doesn't it?
> 
> "complex" is a subjective term. Could you please elaborate what is complex
> about this? Is your concern about the size of the patch? To me that is
> not a concern when considering the end result of how the resctrl structures
> are organized.
> 
>>
>> For me, solution (b) looks simple and easy. Eventually, we may have to
>> restructure these data structures anyways. I feel it is the right 
>> direction.
>>
> 
> I understand that it is tempting to look for smallest patch possible but we
> really need to ensure that any work integrates well into resctrl. Doing
> so may end up with larger patches but in the end it makes the data 
> structures
> and code easier to understand. I specifically find the duplication of 
> structures
> troublesome since that requires developers to always be on high alert of
> what code is being worked on and what flows the particular code 
> participates in
> since the duplication results in members of structures be invalid based 
> on which
> code flow is used. To me this is an unnecessary burden on developers and 
> against
> your original goal of making resctrl easier to maintain.
> 
> Reinette

-- 
- Babu Moger
