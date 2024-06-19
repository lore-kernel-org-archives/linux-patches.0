Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2050.outbound.protection.outlook.com [40.107.236.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA92E2261D
	for <patches@lists.linux.dev>; Wed, 19 Jun 2024 14:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718808235; cv=fail; b=k7a4ZsTRX2RJ5LNNNfpVHDOwnCJOELsYHgJSsVTKZasZG8f4uBuSzTkYfs58TXsuG2+MZRbTczCqmDmlMD3CHuIsgTI/vskekluzVP5MSGHGVcd22tktXehlVDxuVq3o7fa5AwCYHcNs/h49eDSQ1yF3Bj3VhJwbRMqVPC2ltQg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718808235; c=relaxed/simple;
	bh=Yvw+JLg4EycyKofApCzBFnwaDPcjsOo+mU1oKCRE2ik=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=m87QCTEVtw7Y8dtPSyr4pzZ/sCbDfFmhQ5DnwyO37d92A55m6QMJaIXS2JZ/NSc5aVsH6pTFuNJkEfTML8lrk7DjfiZUHIj0fJS0MxpXPHlpLYym0OL1Lf+maFKpW8+MX9sZICpCZcbCf+Y9Kc+cAewQObWswHl9Bgtlgu8GjMw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=eRuVfR1a; arc=fail smtp.client-ip=40.107.236.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="eRuVfR1a"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HxABEn9VOHVWw9RAtFvvozmRkhZ9AyhFYMtyd1R9jOmaGSHwwWRJhIjSQhE6i0ntx8Q9AOSGOVjfVO/yQPf5ZC8ZH51ElwiuRRKgcJ2YBHo+IpQLThfcaFMxc5XpLWkmTS1z+tv0keVl3giTm6FPCbAAZtW0fDZZNNoWWEyRX/vkFN4S6HiLOIcaSEjGV6myLgDOdZsSwuz96PbqOaYwaYl7h5khdazc3bhWSPOZOdl4ofokckEoIzNAxVqJ+nTjU51dqWCLdut7sZ4syN0Q6qnrJQIAdfEoGpu2QjECnOhS7IUlpY8l+die8C4n9AN84/84sz+iUDPH3yt3E75NUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CMVGIWJYEbHDBY0syAkvuzOWpdLIub8KB1Byj5toUjQ=;
 b=EqZLb71GBRk9YGh2zGvu/42Mi6kuHiw+k8ktkr0K+K9iAulq4Hr7xfiIhghsID1UG4sm597DVePjne/BNgQ4DlVF4YK9JTowprCqLP+dY68cieAip1m/epG23BEfKaYhGQuVVgVw1t/Y088Pq4U5W0ZssOgTM/vxHDCzdIrlEwwgJjN9Gq/zlEXrHkDqZ/kyl4E1ch4945x4XmnUqC9lvFgAqWAPOGZ1y5AQa0js9akDo/b7+hQuHv02xkncYx4GZJMK+ialKberw089zpsFTiRvANF0EKFX9p4YsEGVmAcAo1Gb4SDOKvXqLq9KRufFIglrAud12xoVHNiqW10zaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CMVGIWJYEbHDBY0syAkvuzOWpdLIub8KB1Byj5toUjQ=;
 b=eRuVfR1a53YgZxDZ6HoMQlWoaGS2BfG91emq0pnGLjY/uSMIVQNEj8GDs6gINVw9BrWgB0AKXPmEbOuaUIft/D70dMdLKGaRDWnJvuAdLjCjDGcPY7tVAGFl68G9T3jV/yn4S26DzqHcixyud6IsxGhfliATLp/9zIcnbUhJfpU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MW3PR12MB4553.namprd12.prod.outlook.com (2603:10b6:303:2c::19)
 by DS0PR12MB7512.namprd12.prod.outlook.com (2603:10b6:8:13a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.31; Wed, 19 Jun
 2024 14:43:44 +0000
Received: from MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::b0ef:2936:fec1:3a87]) by MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::b0ef:2936:fec1:3a87%5]) with mapi id 15.20.7698.017; Wed, 19 Jun 2024
 14:43:43 +0000
Message-ID: <543a1cdb-30a1-4aea-aa8a-e6dd7be0aba6@amd.com>
Date: Wed, 19 Jun 2024 09:43:41 -0500
User-Agent: Mozilla Thunderbird
Reply-To: babu.moger@amd.com
Subject: Re: [PATCH v20 06/18] x86/resctrl: Introduce snc_nodes_per_l3_cache
To: Reinette Chatre <reinette.chatre@intel.com>,
 Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
 Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
 Peter Newman <peternewman@google.com>, James Morse <james.morse@arm.com>,
 Drew Fustini <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <20240610183528.349198-1-tony.luck@intel.com>
 <20240610183528.349198-7-tony.luck@intel.com>
 <67baa15a-76b6-5543-56fd-d2841d6f6b03@amd.com>
 <bbb72852-6c9e-412e-abda-8c4ed72978e1@intel.com>
Content-Language: en-US
From: "Moger, Babu" <babu.moger@amd.com>
In-Reply-To: <bbb72852-6c9e-412e-abda-8c4ed72978e1@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN7PR04CA0033.namprd04.prod.outlook.com
 (2603:10b6:806:120::8) To MW3PR12MB4553.namprd12.prod.outlook.com
 (2603:10b6:303:2c::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR12MB4553:EE_|DS0PR12MB7512:EE_
X-MS-Office365-Filtering-Correlation-Id: 282ea4f9-18d7-4ad7-ec42-08dc906e37a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|1800799021|7416011|376011|366013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MWd2V2o4WXZEWGdJV3ZrS2xYVXFONnU2czF6NE5tZnU1ekJjMGpYOElSWVQv?=
 =?utf-8?B?bTZ6bDhRZFRZaFdmQjJGa2NKeCtJa2JESGJzaXBMUVNtbDBMck9yaHBrVWR5?=
 =?utf-8?B?Q2dDcmx3VjlhY1JMbXF4SER3bEVXd3NaTURJWUVmZ1FzZkZ1NkllUTVJZ2E2?=
 =?utf-8?B?RmRFRzVWbXpjVDcydmN2YzJObUczNlhWd2tkaW9YMlBlaXpFODJPdjBSZklm?=
 =?utf-8?B?ZEJDV2lEaXpnSU53TzRHMlRYeDRFelI3RVlMc0NxcEtZdFdudzJlT1dxMDBq?=
 =?utf-8?B?ZEpwSDJlUnl3ODVKUVppVGhWVE0zTmx5L0t2NUlBc0x4TlhXNmtiajNDb08x?=
 =?utf-8?B?S3B3WnJNb2pKS0VvR2ViUmRBdXdTYUFFdE0vK2VEMTVPVTVYNEtldEoxN3N4?=
 =?utf-8?B?dE80TnpUK2dtY1lSZG9DQU1xdGVCNlJ1RERXSksvTWVvdEgvb042OUFLYVdx?=
 =?utf-8?B?SEhTVTU3UmJGdVZuTUZ4UnNmbzNRZ2VnWG4ramVaU3dmcFNZY2RRbEVHZ2Qx?=
 =?utf-8?B?b1ZOc2pZUE8rNXhWUUQwRFFxSVB4a0JkTDJHOVhLL1BrN01tOTFsbTFHNDRT?=
 =?utf-8?B?d3RWZXROUUFBZkJ0UnFUb1dEY0t0bHYrR0ZORnNFMGxYdjlTV0pEWGFrTEVm?=
 =?utf-8?B?eDYraEZVZC9qTDFCKzdYZ2lXZ0RSQVIwcnEwdkJURjJmR2JiN3VyYW90TGtM?=
 =?utf-8?B?RHVRM0lJc0piQmg3dzhjVVB3RTRDeHpTdUFpVnhGS0psbjlFb25Nb0k5RkxX?=
 =?utf-8?B?d1dqaDhMcS9iNENBRk5sWmJXWWMwK1RPbEFFTTFjUU5TazNWWjA3emRqYkZJ?=
 =?utf-8?B?dHdrYmFIdTJMY0taN25xbFhaNnJ3eEhlQmEzRG1xSXhqZ0Y2Z0UxWVMwbG9W?=
 =?utf-8?B?b1RQMXMwa2hOUlFHdzA4OTFQemh0WXhqczZMdlByWkNuSWpNTEhWNlBzYStO?=
 =?utf-8?B?NUhEU00rTkx4T2ljRkFUOU9EWE5rVDVINXRaUXRKcncySUwyOGhhYWt6c1hr?=
 =?utf-8?B?UURjWWJHVDU3QjBERHFTQ29HRlJibGxMZE10bU5yMVR1NktqaDl4R2lXK0NC?=
 =?utf-8?B?ZFhOK3ZJR0E5MVM2ZmRXZEdDRWMya0hnWFVvOE5ydTFyWDFTL0w5Q0FSbERa?=
 =?utf-8?B?MmV1VWsxVzF6RXRyb0licU5kRXFxMS93eTRmSWx0OU5sNHcyK1JhWnA1REdO?=
 =?utf-8?B?eUtRYTBJK1YyVC9HdXg1YkRkN1pDTlVVOER4R1poa0JNcDFWemZnTnJKdk52?=
 =?utf-8?B?amlpaERmYmxVcC9IUi9kcXBzb0MrMU4wTU5ZSFRFTjc1d0RuWE5VTmYybUR1?=
 =?utf-8?B?QThhWmN3TzJGMUtEanZRc1BEbjZCL2c1Q0xPOGVHK3l4bmUzajUyMjJGRnNG?=
 =?utf-8?B?Z2x3TTcrUWNtdTRKWitDeXFGaEhCWCtDeU9maFNiRW56cWVUYVB0MFlFS1dw?=
 =?utf-8?B?TitFRWVlbXhnS3kxSXB4NWlESGdwcnZ0eDNhVVlLZmd2VUg4YXBQRFcvZWhn?=
 =?utf-8?B?b2FZRWxTVmNXNjBtcko3eDh5Uy9ZSm9wdGJkYnh6NWlISit5aHZjc1FqREhC?=
 =?utf-8?B?Y3BBL1pNeVNUV0ZqYjZYbmZnRmEyQzM4UjNSejFuTWpOeGpicVFRMnhVQmoy?=
 =?utf-8?B?RXBNbUhWSXZaSUYwaVZhcExad0o1OVppb1JJYmV4RnFzdE9wbGxpNE5Xd0hH?=
 =?utf-8?B?Yy9SU0JxQmF6Vi8veThvTW5SYmRKQjQ3dWtEbmdsN1pCNU5FcWNQRGFkeVNt?=
 =?utf-8?Q?uPoBq4xRVl4wM9Ll8bNL1RJm0ZwIhsHDX1IOQ4f?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4553.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(1800799021)(7416011)(376011)(366013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QmlpeENuWjJ3YXQ4dmhZRzNHOWdxMGUyenpzNThqSkFGYjhKdGxhZXJ1ZmFs?=
 =?utf-8?B?NWRVQ3VEN2RzY0xkRnYyTkhnU3gwSjhXSys2NUtJWTJHdFdldWpsQUtqMitH?=
 =?utf-8?B?cDNiaTJESVZMU3FkYWx6VHhobmZ3TmFSRXlQYUUxUTJJdW93UzRoUUVvUmsz?=
 =?utf-8?B?MXhHMlA0RE05UUlQenFydHBVNkV3N3lFSkVBU0tGQXpKbVhGU1NWK1FzRU9W?=
 =?utf-8?B?VmE2V2dqZ1VoT0duR3gva09DTlB2OVlsYitqNHE4ZStyUFpRU09WbHdXOFZu?=
 =?utf-8?B?QitVUytWbHFKRU8rVXJYZnlsS2Z2RXFFRUMvSmwwWE03U2RvMzNpbHVnWVBw?=
 =?utf-8?B?REtCY0wvY3lFczJIL2xwMGNOVmgzMHFxNU5UaGR4dFR4TnRMRzNTbHZOeTYy?=
 =?utf-8?B?VUkvM3FSU25LLys4U3VnWWRZZEIzYWYzQnN3MzlwTFcwUm1ISXVlMmpRbksw?=
 =?utf-8?B?TUdkUURYbStpSEhJSXU5Tk5vNUxrTHhIT01UM3ZlalRESURGUytFTzdaVHgz?=
 =?utf-8?B?emVPZnVlZStrZlV5cmRIZTROYlJMMGdzb1o3d3F6TDl2dDdFZGJuT01MY1FG?=
 =?utf-8?B?ak02aFJ1cG9UMW5yK0pDMGZrcm9rYUE2SXRidkRLenc2Y3hPWXBRbktlcjZs?=
 =?utf-8?B?RDJCT28vaWM0NEdsQ1VFTVFVeFp0TGtkWWZhcU4xMm1PVE8wVVV4Ymh5eVhp?=
 =?utf-8?B?V0ZRdE5MQkk2U0ljcUY4M1NxbUhGczFaR3gxcGdueFJoMFppL0h2dU1JTVo3?=
 =?utf-8?B?cVNFM1V6elRJTU9yWHBpOCtVaVM0RFlKLytjV281elRQL0VBeFFhcmN0WXN3?=
 =?utf-8?B?cG5KbVdVU0hERjhnZ09KeEdTeERld2ZQMDBKcExYakhhK1QwSHY2YXU3dFpq?=
 =?utf-8?B?TXJvYnFRdGFmL21TUm4yNEpzSUJUYkh1RXhmV3NqVjZUd3hmMjFBeVUvbmFC?=
 =?utf-8?B?SlZsVjdvSEJXOFNSYWVmRWl3MWZnQ2dIajdWd3ZOUVJwZ1dacHNuTkRDMHc5?=
 =?utf-8?B?TGVoaUlRNkw4aENuRGlsZnhnR1pwT0FYUmdsYlB3YTg0ZXBVaEM1cEIzdGVK?=
 =?utf-8?B?TFM3NEhQQXQ4cGNveW90VUtzZTRaSVRNM0JJWk5UOGJ4NnRwVWlneWpmZUIy?=
 =?utf-8?B?TUJXek0zN0czRi9RUE9pZHQrTXdRWlRDVzJETHBleEpPdmQ4OXZVVks3em1N?=
 =?utf-8?B?aGR3Rkl3VlBSRGxXTnovbS9vKythQmZZYW5FZ1ZLOFFXK3JZbHk4QmNjR0RP?=
 =?utf-8?B?TXN2Mi9lT29KMTNXa1hMZXhUYVZYeHJjc3E3V0FDQVA4UjJyK0s0ckMzUkxN?=
 =?utf-8?B?TmR2WCtpWFJlK3RWVWNOODBrR2pqSUJvVE5hMTA3WFhxTW02cS9lYXFsdkwv?=
 =?utf-8?B?ckhnaWdRMXNEQlU5eXBSNyszSDI0bkxNbDZISGRMampzM2U1ckI3RGVvS0Jj?=
 =?utf-8?B?MTZMeTdWakc1QTdtWDJhbS9JMmZBTGV1WktlSVg5TGJhcG9Hc3RsbXJwb3pz?=
 =?utf-8?B?cUVCSnU0a2hMRlVjdEpmNmp0WlVXeFQxR0FRQURVYlJTSUpBM0VSb2JsMlZn?=
 =?utf-8?B?QkJ0Ky9PYXpwWGdpK2VZejR4R3B0VjFpbGhUd2NHd0dMMWl5RFUxM1lDYTFO?=
 =?utf-8?B?WnBya3ZVT0diSXpFU2JuSk1jWUZvUU1WNG9rWVVJZXZIZUNEb3pNdS9BdHJC?=
 =?utf-8?B?MGpxZ25wRGc3TzJCSlpON044bC9YUjluQlRVZkNMU3ZwdDYrTmlVMG93NGpk?=
 =?utf-8?B?NlNCUnh6bnA3T1JLY1FQTzhjRHdMVlcvTlk1ZFJjcm5uaXMvdG1pUDRURVFM?=
 =?utf-8?B?ZnJjYVErOGlmYmF4bU5NZSs5eXhOaGZiTXk1VXRMbm01Rm8xUU4vUXNoSkJ6?=
 =?utf-8?B?aXJOSTB2K0VNWTkvODFaaUF2OTNkVzRDYVp5MEVYZVlldU1VRUc5TUEveko1?=
 =?utf-8?B?Q0UvNHMwSlFCQlZ6MzVZbS83RmdrQVRoMEhmMmRZeldtUlZORjBEMjFRWmUz?=
 =?utf-8?B?aVBsZEFwQWJaWHFrMG5YVHJJUWZrbzBrbnRrY1Y5NnJqa29seENxVU9rTndj?=
 =?utf-8?B?L2Zsa2syaXNIMUd5SkkvRkdrNmR4UUJrSVRGd2VmaUE2U3ZQY1JpNG4xTWtm?=
 =?utf-8?Q?bvx8=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 282ea4f9-18d7-4ad7-ec42-08dc906e37a9
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4553.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2024 14:43:43.7956
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8cu+kZL8g5jj9RVTRRz3/kmE7qkByW0AIvvpoXyG6HkbGwfg7k97fid1gL0ooPD5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7512



On 6/18/24 17:58, Reinette Chatre wrote:
> Hi Babu and Tony,
> 
> On 6/17/24 3:36 PM, Moger, Babu wrote:
>> On 6/10/2024 1:35 PM, Tony Luck wrote:
> 
>>> diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c
>>> b/arch/x86/kernel/cpu/resctrl/monitor.c
>>> index 89d7e6fcbaa1..f2fd35d294f2 100644
>>> --- a/arch/x86/kernel/cpu/resctrl/monitor.c
>>> +++ b/arch/x86/kernel/cpu/resctrl/monitor.c
>>> @@ -97,6 +97,8 @@ unsigned int resctrl_rmid_realloc_limit;
>>>   #define CF(cf)    ((unsigned long)(1048576 * (cf) + 0.5))
>>> +static int snc_nodes_per_l3_cache = 1;
>>> +
>>>   /*
>>>    * The correction factor table is documented in
>>> Documentation/arch/x86/resctrl.rst.
>>>    * If rmid > rmid threshold, MBM total and local values should be
>>> multiplied
>>> @@ -185,7 +187,43 @@ static inline struct rmid_entry *__rmid_entry(u32
>>> idx)
>>>       return entry;
>>>   }
>>> -static int __rmid_read(u32 rmid, enum resctrl_event_id eventid, u64 *val)
>>> +/*
>>> + * When Sub-NUMA Cluster (SNC) mode is not enabled (as indicated by
>>> + * "snc_nodes_per_l3_cache  == 1") no translation of the RMID value is
>>> + * needed. The physical RMID is the same as the logical RMID.
>>> + *
>>> + * On a platform with SNC mode enabled, Linux enables RMID sharing mode
>>> + * via MSR 0xCA0 (see the "RMID Sharing Mode" section in the "Intel
>>> + * Resource Director Technology Architecture Specification" for a full
>>> + * description of RMID sharing mode).
>>> + *
>>> + * In RMID sharing mode there are fewer "logical RMID" values available
>>> + * to accumulate data ("physical RMIDs" are divided evenly between SNC
>>> + * nodes that share an L3 cache). Linux creates an rdt_mon_domain for
>>> + * each SNC node.
>>> + *
>>> + * The value loaded into IA32_PQR_ASSOC is the "logical RMID".
>>> + *
>>> + * Data is collected independently on each SNC node and can be retrieved
>>> + * using the "physical RMID" value computed by this function and loaded
>>> + * into IA32_QM_EVTSEL. @cpu can be any CPU in the SNC node.
>>> + *
>>> + * The scope of the IA32_QM_EVTSEL and IA32_QM_CTR MSRs is at the L3
>>> + * cache.  So a "physical RMID" may be read from any CPU that shares
>>> + * the L3 cache with the desired SNC node, not just from a CPU in
>>> + * the specific SNC node.
>>> + */
>>> +static int logical_rmid_to_physical_rmid(int cpu, int lrmid)
>>
>> How about ? (or something similar)
>>
>> static int get_snc_node_rmid(int cpu, int rmid)
>>
>>> +{
>>> +    struct rdt_resource *r =
>>> &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
>>> +
>>> +    if (snc_nodes_per_l3_cache  == 1)
> 
> (nit: unnecessary space)
> 
>>> +        return lrmid;
>>> +
>>> +    return lrmid + (cpu_to_node(cpu) % snc_nodes_per_l3_cache) *
>>> r->num_rmid;
>>> +}
>>> +
>>> +static int __rmid_read_phys(u32 prmid, enum resctrl_event_id eventid,
>>> u64 *val)
>>
>> You don't need to write new function.  Just update the rmid.
>>
>>
>>>   {
>>>       u64 msr_val;
>>> @@ -197,7 +235,7 @@ static int __rmid_read(u32 rmid, enum
>>> resctrl_event_id eventid, u64 *val)
>>>        * IA32_QM_CTR.Error (bit 63) and IA32_QM_CTR.Unavailable (bit 62)
>>>        * are error bits.
>>>        */
>>> -    wrmsr(MSR_IA32_QM_EVTSEL, eventid, rmid);
>>> +    wrmsr(MSR_IA32_QM_EVTSEL, eventid, prmid);
>>>       rdmsrl(MSR_IA32_QM_CTR, msr_val);
>>>       if (msr_val & RMID_VAL_ERROR)
>>> @@ -233,14 +271,17 @@ void resctrl_arch_reset_rmid(struct rdt_resource
>>> *r, struct rdt_mon_domain *d,
>>>                    enum resctrl_event_id eventid)
>>>   {
>>>       struct rdt_hw_mon_domain *hw_dom = resctrl_to_arch_mon_dom(d);
>>> +    int cpu = cpumask_any(&d->hdr.cpu_mask);
>>>       struct arch_mbm_state *am;
>>> +    u32 prmid;
>>
>> snc_rmid?
>>
>>>       am = get_arch_mbm_state(hw_dom, rmid, eventid);
>>>       if (am) {
>>>           memset(am, 0, sizeof(*am));
>>> +        prmid = logical_rmid_to_physical_rmid(cpu, rmid);
>>>           /* Record any initial, non-zero count value. */
>>> -        __rmid_read(rmid, eventid, &am->prev_msr);
>>> +        __rmid_read_phys(prmid, eventid, &am->prev_msr);
>>
>> How about ? Feel free to simplify.
>>
>>            if (snc_nodes_per_l3_cache > 1) {
>>                   snc_rmid = get_snc_node_rmid(cpu, rmid);
>>                  __rmid_read(snc_rmid, eventid, &am->prev_msr);
>>            } else {
>>                __rmid_read(rmid, eventid, &am->prev_msr);
>>            }
>>
> 
> When considering something like this I think it would be better to contain
> the
> SNC checking in a single place so that all places needing to read RMID
> need not
> remember to have the same copied "if (snc_nodes_per_l3_cache > 1)" check.
> This then essentially becomes logical_rmid_to_physical_rmid() in this
> patch so
> now it just becomes a question about what name to pick for variables and
> functions.
> 
> I do prefer a name like __rmid_read_phys()  with a unique "prmid"
> parameter since that
> should prompt developer to give a second thought to what rmid parameter is
> provided
> instead of just blindly calling __rmid_read() that implies that it is
> reading the
> data for the RMID used by resctrl without considering that a conversion
> may be needed.

Ok. That sounds reasonable.

> 
> I do understand and agree that "logical" vs "physical" is not intuitive
> here but
> to that end I find that the comments explain the distinction well. If
> there are
> better suggestions then they are surely welcome.
> 
> In summary, I do think that the "__rmid_read()" function needs a name
> change to make
> clear that it may not be reading the RMID used internally by resctrl and
> this function
> should be accompanied by a function with similar term in its name that
> does the
> conversion and includes the SNC check.
> 
> Reinette
> 

-- 
Thanks
Babu Moger
