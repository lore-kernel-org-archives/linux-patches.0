Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010027.outbound.protection.outlook.com [40.93.198.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ECD151AFC6
	for <patches@lists.linux.dev>; Tue, 22 Sep 2026 13:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.27
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790082593; cv=fail; b=HKIFErhTXm/T/El2azSAPATPUhnnUqs1aj/IWYcOw3K7duHRy2XcxPIAeIBT6yqFZrr/KgRyQGie61IT0ahoP95sdM/RUCSLtmB0XuBRZveuMn4RNU8t3YlXdxzXiDNMHcox3nwVUmGUKyZbS4/DA+e3l3wPjvK0UscJ0LAnPA4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790082593; c=relaxed/simple;
	bh=gP/5W6vrB5ViL4pnPeeoBLim13hELk6nskuDj20IGiY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=uyYXg0evyNqRXRWM/0wVPGrSYB/TcKk3QluXH5MMolk2YGALGA0WwtCfQQc4MR822tyjLkZbeAMqtOGAHbKlM73+bBM3dCJ5pT/sbbhcKO99gWKBhhXebBxBQylSn0OR4+ZB66wEN1XnrnV243K347N8MumIviAswGdsNquXP2M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ftABsYxv; arc=fail smtp.client-ip=40.93.198.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ftABsYxv"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WJNoXkCKQI9a4Tr2PGEtNn6RCzBrfbheWwANtDyK1Y68xk5YI0GE2hCki9ACx6G+Es5u4SogJPHrRf5X7XTcAgRWD6f9cp4O36IxYRw0zSrbkgdrXPK5l2S8mGw6QMYYRue8BuuzjC04ted/77I9LMgpCulaUdKOVZ0i1bfXD46gz2OQH2pCjCxeiPhLrRcMKQYzbR/eJL6Zgi0XH2rrc6Vj7fR+OeqgLpFEyZYegDgSKwuloWpqSzUe+I2n+bQAFMH3rg2whDpyJPtaHbkKCJhps66dRZ0f0r0A+4mD+5vHOv/nbJwnQyV7RnffBhgO/vNh5tAvJLhSlkergpS+Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zAnGOrS52m/LU/376yFDz1hAabCnPk8ZGeiuJNGE47w=;
 b=aA8HaeXW9kRtDmgggCnnk7h6F79B49jL8zp3kbq1/cIjVYwC0iblumQm4bm55D5rzU3kT5vgqEsP39W1+gxxwqu96AtAeqtg1sEZgsD3EuZ27nC1fOdwoNFELAgjY17dim0hUHjL40a20GZow85cecx0uDYXHpr5QiUqmdXJLO7mKJs4m3RqFtFabtA8UAwT/V61rHaEX+gXI5XhNNnxA1u2RgH9Eehch0l3BcFgyzHQYgLEhJzlcB0x8/2Iv9x20kZ/08Mk57FBDXJceWxYbPl0lBW2Y3OitZSTp7fhNcAJorq1+ZTSXR+g//T63ZuA391lJKS2H+aNA+Ce4vzpnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zAnGOrS52m/LU/376yFDz1hAabCnPk8ZGeiuJNGE47w=;
 b=ftABsYxvX5GrhBGElQRVbe7/s3GH2iJ7CamYFIury3vRtxrY06Iv2KzQy5tiRWVlq7gzP+/PsjXmXuyFRPxAIDM2FiSYxZgMc6s25svuE5WO03sVFlss3/zPLl0ByQCJqQePBuaNx30xgQ6xq8YPsyE93QlqrrKkNl1WPuSJcrM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5320.namprd12.prod.outlook.com (2603:10b6:208:314::17)
 by SN7PR12MB6839.namprd12.prod.outlook.com (2603:10b6:806:265::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.14; Tue, 22 Sep
 2026 13:09:45 +0000
Received: from BL1PR12MB5320.namprd12.prod.outlook.com
 ([fe80::1876:4a6d:2cf5:b8d1]) by BL1PR12MB5320.namprd12.prod.outlook.com
 ([fe80::1876:4a6d:2cf5:b8d1%5]) with mapi id 15.21.0451.012; Tue, 22 Sep 2026
 13:09:45 +0000
Message-ID: <80892761-25d2-4535-8722-430b402c00cc@amd.com>
Date: Tue, 22 Sep 2026 08:09:43 -0500
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH v12 12/25] arm,x86,fs/resctrl: Allocate maximum needed
 rmid_ptrs[]
To: Reinette Chatre <reinette.chatre@intel.com>,
 Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>,
 Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
 Peter Newman <peternewman@google.com>, James Morse <james.morse@arm.com>,
 Drew Fustini <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>,
 Chen Yu <yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>,
 x86@kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
References: <20260916231320.14502-1-tony.luck@intel.com>
 <20260916231320.14502-13-tony.luck@intel.com>
 <87ec019b-762b-4ef3-b2bb-6322efb6a7de@amd.com>
 <d5f9dfff-abe9-4622-a0fd-09a2bb6b389d@intel.com>
Content-Language: en-US
From: Babu Moger <babu.moger@amd.com>
In-Reply-To: <d5f9dfff-abe9-4622-a0fd-09a2bb6b389d@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH5PR03CA0009.namprd03.prod.outlook.com
 (2603:10b6:610:1f1::22) To BL1PR12MB5320.namprd12.prod.outlook.com
 (2603:10b6:208:314::17)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5320:EE_|SN7PR12MB6839:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a15f6af-c651-416f-74c4-08df18aac59c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|23010399003|376014|366016|10067099003|11063799006|4143699003|56012099006|3023799007|18002099003|22082099003|921020;
X-Microsoft-Antispam-Message-Info:
	fICzg1QbMOVXG/aPPCjR8DyUeM+aEAlj6TyNRvKoIvquRi4ld98U6vRuF4mSDtmUOXUZ+vo/Jg0Ib1yFDQVJsbyRfq3vJo6p8zhayLYzc5LCtqz4dsq07m3kR8S/qqPe+4HihVLBp9JuX2lYCeTar94+BqGk1Z5B+wtsqimZmFTxDJmqmKsn1XPZwVgFuYp2xxJ0GXS5OiahGLZLC7VuWowMVoqgj5er1jWex9dXC9UCYu2AHHHLN8qEZioeJhzvfELoTaxYltkBbSeNhdDM1PoCRh2jua0N54ahjlN86RUX6gNulVfy7Jmjl2XEG8u2Jo+DrWXrJYWHiacuwD44+ZbgbK3IxIuU2Erqil1DB5qflMSBePTr80EWA5Rit3ZEow37vot9Ih0P8hENueTlBx8RUxPUW/RZeZnmtdCe5/ruRF/lozqNJ5uetImU3TUTkNF+tEqn+VVbtA8FN44nIJeVx04g+dC/TYeOTqciOTuWqSKSpcQAMec/IfXMI6MUVqPw2XEyBjBIXUhMVs+gfVB0YP7EAVcsY8/iiBV4T5D+Gr9Q5aqHdzNdxS8kRK1vRPhbIiVetGE6uRdokNeQQAig1CIkWUEQrSzzP8XIJI3v7kR3hK+jaOmI6H0P+8r4dgzQE07cQCxcgYPM6Jtvbmqi1HPO0rjBPgqHftfWQT66pWwqamBXAxofxP/qlSeOCf9cPad+18YJFUsXmrCfzA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5320.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(23010399003)(376014)(366016)(10067099003)(11063799006)(4143699003)(56012099006)(3023799007)(18002099003)(22082099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bjdlRnhRdzNyOEoxZmgyYkRZcVU1c1ZiaFVSK1hkbytKYzRqOG5NT2NSMXpz?=
 =?utf-8?B?RHBVeW1SS1pucFBhQTNjbzFUbnhLdk9SVEFXN3pmaTR0Mml3Ry93TVBhVFhN?=
 =?utf-8?B?YVh2SUxwWG9IeEpubkNVZmFxalhiUGdCUE5RV2ZCaXB0emU4bWlzaE8yRGVq?=
 =?utf-8?B?TnpOMFViditkaE50RlBTa05ZZC9sTnh2OGlBSFlGQ0JhQWZVZ2ZpdjVBeFhJ?=
 =?utf-8?B?YndpNDJuWUdkKzQzYWRQaER1dzBuazRTN0c5b1lQMTduaXFlWm4wTW1sY0Nk?=
 =?utf-8?B?cHVQQUlxa0VyRmU2Z3l3M3BKRlJqVUV3bjF2RnZjaEd3MU1qYStMV0t0SEJw?=
 =?utf-8?B?cHdqeHYzemVnTGlLUmlGeVkvWjNCbm40YThUKzd6Q2pTVlJOOWRUOHpqdnBu?=
 =?utf-8?B?VCtGQjdvM2lDMTVpU2JEamgyU0lteEhLNytTV1d4dDZraDI2emFUWUhKVmxM?=
 =?utf-8?B?eXh3UXdpYndER3Jkdml1eWZJOGh0RStZa3F6Q3Q5RVpQaWRzdVdMMDlpeUZi?=
 =?utf-8?B?ZWh5M0tmSzFPRHFzNlM1dzg3NVBSU09SdDc5aFdydDhLU2RjWnRTVVd2cG1I?=
 =?utf-8?B?UGJzMVFKSmZCT244RUlPQzJ5SkpsaCtEejFkVDhLeDMxc0tpbzdZRmthcVUx?=
 =?utf-8?B?RzR0UTkrcmxUNU94TXhQSU0rb2xLem1UUHhzZjJpd3I2QmdrVW5GWnlrVTBz?=
 =?utf-8?B?T05BUGZHMmM4d0Q4azJlRkdDanBJZ2tGQStUU1hhQWlkUnNjSHdBTlBUNEFy?=
 =?utf-8?B?YmJJTEowSlA2U21hallwcys3UldOcSsyYjE4aHdzZjMxMWVPYmhOZGp1Zkw4?=
 =?utf-8?B?L2RWZVF2alNUVWZSNHJndEpabFZXSEV5ditVbnIyRWpJWE5HTm9WSjJuT29Z?=
 =?utf-8?B?S2N0cVUySGRGa2tFSSs3RldPamlJd0JkM2MwbGtKU0NTRmh3bmMvZWljNlRm?=
 =?utf-8?B?WTl2SDFJRVF1aEFmanZKQWVPMjc4WUpWSW9GRlRjajM5TDB6Zit3a3BYajZn?=
 =?utf-8?B?VXJlY0FKL0FKdkIwSUZCMnd4QjlacXk1Ums4Zm95NFhTbWZzQldDS05TVTda?=
 =?utf-8?B?d3JrRndDeG9BSGE1aFkraVFaMlY3V0lwMVhiYmU2dVdWbHA1czhvNGhnMm51?=
 =?utf-8?B?d0hqbXdyeFdqU2pWYWxFMCtIc1cxS0IzcWZIdUUxaEFPeGYwMy9IWGljRUt1?=
 =?utf-8?B?cnJMTlRGSEo3RGNDUm5oelJ4engyQ29BRzlSUWhUMFVFTHliOVZXY1RqQkY3?=
 =?utf-8?B?Nk4yNUVLVllodVFYd2xGNkdkdDN6NFNyeWNXUzZOYzBqdHk0bjUzNUZQeHJ4?=
 =?utf-8?B?WjdTYU5WbXdMRkJPaUpLd091RWpNd3JQWC9TbTZDRVBSQTJaZmwxblk5eHdr?=
 =?utf-8?B?NDdFbDFDby9pSFRyWXI2MnZzTkk1cFh2Um5DUE5mekNVT01sZVhua09iRmpM?=
 =?utf-8?B?RWRtZW5vYjRyYnJMc3dZaER6RC9tYk94bEpLejhHTlh4VHhqZU9FQlp1UHZM?=
 =?utf-8?B?dUNJL1d5T01rV0pLZm1HL2dtd09TSWNwb0FIdnVaWDJxazdMLzBaT05hSXc4?=
 =?utf-8?B?amZMZ1hNVjREbFJwSUlwcnBEai9YZm1rNVR6NFFkR3R0bENKdjQvKzdsUENG?=
 =?utf-8?B?aUYxc0l3YkF6dE12U1k5dS9NZkl0anlFMmVBWjRuVEVCaWZzQUhnRCtreEN1?=
 =?utf-8?B?VXFLajUwVHZnRmhxTUpxVlBsbjc5V3BDMzBsR1dNWDNuOW9DZzVzYnFmMi9K?=
 =?utf-8?B?OFl6Wit0SzFRMUtkTStOQ2grbDMyMTUrZ25Ic25YeEdWeDJvL3J2U1g0NUdC?=
 =?utf-8?B?Wmg2RGJ6dnp1eU5BOUtqYkw1ME1QRGlNdUJ1czhhcC80VkxUY0VTcUsveUJK?=
 =?utf-8?B?VWU1cTlDejRRMDJYT3ZsSFdET2I4QUh3MWZ1K0dWUTkwbHFWaHBDcTR4UklH?=
 =?utf-8?B?MUZkSGFHa05nQThVMmltMzArZFRSb3Z1ZFZLdldKc21tSXJPc0owUzRuT3lQ?=
 =?utf-8?B?UXJvUzIrN2daQmNlUTZkVzN4dE9OUlhZRjUyZi91Y2VaTERVUTExTnlwYnY0?=
 =?utf-8?B?Y1I0RlBRSjNqYTR0ZGFxNENma3ppZUg4K0I5cTJKRWE3MlprUVYzWnNZUDFK?=
 =?utf-8?B?RmpQRTFQNkNoNzJpM3ZzTld3dmV2YkQzVTNxcWhiVURTZUttRllVUTFIcUN3?=
 =?utf-8?B?Mmg2Y0w1ZVlNRmcrR0MxOVBuWGJiamJnSmQ4cUNVaEtqM09ZdWIvVldIaG5p?=
 =?utf-8?B?T2paYjlXU3FteWNRRXVOM3g3bStWc0tHOGQxaHl4VXgycGgweVh2LzdIZnZN?=
 =?utf-8?Q?us6qWRX7pBaX+DeqV7?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a15f6af-c651-416f-74c4-08df18aac59c
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5320.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2026 13:09:45.0826
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W+oiQwAuq8uBq3XmhmO14DTOrF3g6TnNhMje2ZQcTtwNH4omCCVG7DX7JSflBSAj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6839

Hi Reinette,

On 9/21/26 19:30, Reinette Chatre wrote:
> Hi Babu,
> 
> Thank you for taking a look.
> 
> On 9/21/26 10:45 AM, Babu Moger wrote:
>> On 9/16/26 18:13, Tony Luck wrote:
> 
> ...
> 
>>> @@ -45,6 +45,9 @@ static DEFINE_MUTEX(domain_list_lock);
>>>     */
>>>    DEFINE_PER_CPU(struct resctrl_pqr_state, pqr_state);
>>>    +/* Number of RMIDS values that can be written to IA32_PQR_ASSOC.RMID */
>>> +static u32 pqr_assoc_num_rmid;
>>> +
>>>    static void mba_wrmsr_intel(struct msr_param *m);
>>>    static void cat_wrmsr(struct msr_param *m);
>>>    static void mba_wrmsr_amd(struct msr_param *m);
>>> @@ -124,6 +127,28 @@ u32 resctrl_arch_system_num_rmid_idx(void)
>>>        return num_rmids == U32_MAX ? 0 : num_rmids;
>>>    }
>>>    +/**
>>> + * resctrl_arch_system_max_rmid_idx - Largest possible number of RMIDs
>>> + *
>>> + * Return: Maximum possible number of RMIDs used for boot time allocations.
>>> + */
>>> +u32 resctrl_arch_system_max_rmid_idx(void)
>>> +{
>>> +    struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
>>> +    u32 num_rmid = pqr_assoc_num_rmid;
>>
>> Why not  use "cpuid_ebx(0xf) + 1" instead of global variable?
>>
> Tony did so in v11 but I proposed it to be changed [1]. This series adds
> multiple consumers of this value so it seems more efficient to enumerate
> it once and re-use that value when needed. Locating this one-time enumeration
> with all the other monitoring information enumerated from hardware in
> get_rdt_mon_resources() also has the benefit of keeping all monitoring data
> enumeration together.

Ok. Sounds good to me.

Thanks
Babu
