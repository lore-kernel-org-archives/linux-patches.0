Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012010.outbound.protection.outlook.com [40.93.195.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0582D4F85D2
	for <patches@lists.linux.dev>; Mon, 21 Sep 2026 17:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790012746; cv=fail; b=WNexBGaYQcV/HIJMjtq+ARVUm0ivqZC6/bhgkXLReNZ+HUHAKbyPmwMQl4o6c4qL6AhaQUMXnzZGOYU6cxbFpKHT1kfl/wnI6XiMFTNXkxYwlPcVqycRcIi7sWPMuHHFpZe38RS+aP2yefUpZUryOmwaQz5fUeXA1mcx7NheYhg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790012746; c=relaxed/simple;
	bh=qZJlIOAyqnbwhhLF01j4jn4DcOwWE7hpSx58voDNDXg=;
	h=Message-ID:Date:From:Subject:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uOMlwAp83tj6r/1PHDMnuYwFiZeJi2Y572OGTWB6Q8aCCptneh2/wHGz2uGYDHIcyBKA8azDQhWXQuUm3XVgvvKLAJaaBh09HOjFxEshG9QFD+9Ex786ceU4h/vS4bXCtnK91t4Vl+9mp5derzNkeR5AH/4ocJmo0Mu83IolTko=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Xnz2m1CO; arc=fail smtp.client-ip=40.93.195.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Xnz2m1CO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WgP1vUqqEOC0/99fUpev5xkymbMyoYKYxBghNt3lXZ8pEkDzHSndxUFrPTEIfCoU8T4AWr3aAAXdlcg1DxirefFSZ0u6MXXX5zfYsUBQysseTfA0TZRFpCG98W6EMbd75e3bOESBlK3gx+vaEFBEp95Kj1GXWBD/bDar8PxIejJBK8qPoBiozk66bBr8HxkEBb6w14TACGQgL5btqpLfzttp9g2luE2ORa6CVOSK560kLhls3rrlgI7jLchaTMnv8ZSE6lhGEJqkmZgdJ3AlWwJeQp38tBwGfu4zLrT9BnBiVxDVQBrvgPD6NCCOSxymm+KUGW9NT+eK+4M7F3GDkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w9SqdgbW4yc61/K2JvJSzXsb38KgM5+ZLQmRIdiX42U=;
 b=ZiAGnH/A9bU4AKcj7jWpESAM4GgkMenoU6JSbCOIxBwk2Nyx8KsN14sfOFefd61r/0CGZXAzDokU6lXRX63hZ3cfFNS9qzJF41QUxCo9AqyB1pyQWx24a280IxV744xT/bFUnQk8KEA/5LFrk5gLchK2JhjblhMIBdXWE06yslFTkwdcxZnoQk6GK+8hIN5xrV+mbdIWAqs+883DSzvIAhoIbH+THNjeyAK3YWjNqL2Z5F6mK8ZVy00IZD+O9qRnLw+nMPoDPreX0kyrfOAvotitze6nUhX+RxOYokNmkDTykvD7WVcvb+ln2MhJ8HPespJ/TAhn1zY3lNpWi/BOog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w9SqdgbW4yc61/K2JvJSzXsb38KgM5+ZLQmRIdiX42U=;
 b=Xnz2m1COVPTuH+0QGVEaXceOO3X/rZfGQeuY6XMcXtiVZKKaRUeJ9BE3AdZmmBYU1eN9yiWYA2blQFuS1nEWaj2MOcMaq4v9uavA5dw2T85Z90N5hNkeH89zGTFNWrTOwM9W5sSWZ4CixLUlNwk3E3MJSQX7qXLbpvH0vnyvjXc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5320.namprd12.prod.outlook.com (2603:10b6:208:314::17)
 by IA1PR12MB6651.namprd12.prod.outlook.com (2603:10b6:208:3a0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Mon, 21 Sep
 2026 17:45:38 +0000
Received: from BL1PR12MB5320.namprd12.prod.outlook.com
 ([fe80::1876:4a6d:2cf5:b8d1]) by BL1PR12MB5320.namprd12.prod.outlook.com
 ([fe80::1876:4a6d:2cf5:b8d1%5]) with mapi id 15.21.0428.015; Mon, 21 Sep 2026
 17:45:38 +0000
Message-ID: <87ec019b-762b-4ef3-b2bb-6322efb6a7de@amd.com>
Date: Mon, 21 Sep 2026 12:45:36 -0500
User-Agent: Mozilla Thunderbird Beta
From: Babu Moger <babu.moger@amd.com>
Subject: Re: [PATCH v12 12/25] arm,x86,fs/resctrl: Allocate maximum needed
 rmid_ptrs[]
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>,
 Reinette Chatre <reinette.chatre@intel.com>,
 Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
 Peter Newman <peternewman@google.com>, James Morse <james.morse@arm.com>,
 Drew Fustini <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>,
 Chen Yu <yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>,
 x86@kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
References: <20260916231320.14502-1-tony.luck@intel.com>
 <20260916231320.14502-13-tony.luck@intel.com>
Content-Language: en-US
In-Reply-To: <20260916231320.14502-13-tony.luck@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0253.namprd03.prod.outlook.com
 (2603:10b6:610:e5::18) To BL1PR12MB5320.namprd12.prod.outlook.com
 (2603:10b6:208:314::17)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5320:EE_|IA1PR12MB6651:EE_
X-MS-Office365-Filtering-Correlation-Id: 67bf0364-1b86-4f3c-e768-08df1808260e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|23010399003|56012099006|4143699003|11063799006|921020|6133799003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	X3v6w6fr2KD8ams/6cHT5EXF62jrOkOBOLFn2CRJP9S50sjL+Pvtoj0UEGNMv5dZRnD8odB9s1/iCcDnyV6u22qIVxq0e0m57aeiljqmH7QuQVilzwNXYlvJQ3R6IQKFDac0YYgnvuC4bdC8cLtE+Z3Vgq+88K/g85d+pexDORDjpI14BIlrzNcFzLFa7p4OX14rz2SnZIVc9y4N5r/X4krjKghyKqPoZMa20SPC6+E6FPjzIuLNFIbA27Z+JnW21A5HeMOKYuTDA0iCl25wHzwBRL9eHrFQ0tQPQ3oLED4aaSBtymSRikQpNSH+6Bdiz75BRK7QCYge3WcmVKcNDqncKu1Kjc3rmJkpd4Rcy0EMgn/DHeLtbpZ4phLr00BWnPA6E6nL3wUV+FLEQockUowmGMwJiX+xySBgy3z3fMWcI6UwFVV3PE1uCp8Lbt7PAuV9+UoAi0NhcUGK9pOJTfXA8c664pi+dlJQcqPqcXfAeOJc3443mquxj1PJgM4EBjY+PIQl82NnMkfUcGb9XAWExeoU9wP8/aIMU5DJnbIYq5wqumJL7uZdHG/o6qPwbmjPqK/IuXBI6DgwLe+raU8yO+6rZs9DO1RgKPeHhxAn8aej6ATfQZV1W4mpUJZexwfT83dBclxpJUZBaVHvfnmQoWuQ+2WJc5HJfJzQgwTWTaJWRqHDP1O/zonBhhNUrDAc9T9NaC4IgKfAqM/Ilw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5320.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(23010399003)(56012099006)(4143699003)(11063799006)(921020)(6133799003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TkNSMytlcU13WEo5aEdva0FoQnJ3aHdpb2NYVW5uTWo1SXl3OEJINnJidm9X?=
 =?utf-8?B?eUt4bWVTQUNKdUpCK2FkTTBtTjNVQ2U1V0F5Z2hsUU1nTXV6eTU4S0xHSnE2?=
 =?utf-8?B?eGZEL2RtWjJadjFuN2pYalgxbGdwUGJMRE9ibDRyUmtZNWgyV1BoQmRaOG5M?=
 =?utf-8?B?UjBmMFRveWd0cWpVVXN1RlpWMkxvZk9TSmJMVW9SK0dVTG1aR2hqQm4yNnpa?=
 =?utf-8?B?SDhzZng3bXRzWU96Z2pzRnM0bHRLOUJ4RjBOaDJ4dm9UZmpLZUVDWGQ0Nnl3?=
 =?utf-8?B?c3JxbWxTQ3BRcUIwVVNDck5kRE0yR0FNOXNBVzBFL0ZUL0VMVWZ5eFU1bnFL?=
 =?utf-8?B?TjA2aVI4cUprUkRhd2h3ZjhZWmhQYnkvR2tkTTh1RzFMejlmc3Nnd3pGei9k?=
 =?utf-8?B?Mm83OHdURFhNSE5rZTk2dFJVcXlaWGNycGc1SEdUd3EwclRaWlBDRFczZndW?=
 =?utf-8?B?bEFQdVl2b2RUa0JOUlhYZ3MrOU9TU3I0OHRCTmhXZXQvWmxoYllYU2VGQlQx?=
 =?utf-8?B?aXBvbEJjdWhsLzVJWjNqL3k0bGxZOGxsN3laRGFPcG5COVFWTXA3N1FMWStv?=
 =?utf-8?B?MjNRSXJCai9nVzgvUjR3S0hpck4rQnF4TjA0SmlQc01VWjE0c2UxUjFqWmw4?=
 =?utf-8?B?STdwSXNRb1BIN09mbWZUL0dHUk9wMWcvRWcrdWhKcURPRUE4bUlzOWVDTThP?=
 =?utf-8?B?Wmo3dzdCanNXWWpLem9UUDNnMy9VaW9WZ3Bibk5pSThnaTUveHMwQVhTajlP?=
 =?utf-8?B?dkZUUytzSzI5MWJwNXUxYXhWenZJbTcvZ0hBY0tsYXc0R290NktqSzRyTitJ?=
 =?utf-8?B?d2lUMXM0S3oxN3VsemI3SHBzdW9IazFHcmVpNEZjWjdKUEFHK1g3VjlKMWcx?=
 =?utf-8?B?aXZoZlFMYTRjcGJRMzlBMlhKdXEvb0VrM0VOMTJ3a3N1QWxueXMyTGFDNW5Q?=
 =?utf-8?B?cjczUFUrQnMzSDhqd1I3ZS9sbVhpSGcwc3hTZjN2K2ZmdllRelVudmw2THV4?=
 =?utf-8?B?SFNQa1paNVpUQUhuVndFM1pib2NzVjVPZkRZc0tvL0pueWQvSXNVMXA4anBG?=
 =?utf-8?B?NVpWc3E3YnVvWHRZWlh1OHd0OXVVS1JFbXNSRWk1S2c4cmZNTXZvWlBEaUtr?=
 =?utf-8?B?Qkp4QThBMWFoNEsvbEw2b0JNVlh2MG9pKzhPN1lQSlIveDg4T3JoYVNyTVpj?=
 =?utf-8?B?OTFJYWdKV05RTjNVa3pnSG5PNk5aTWI0SlJtekNYNHFWVUpKT09yeUppN0Fi?=
 =?utf-8?B?em9aM1ZoalR3NDVTYjQ3ZUszbWY4OExxQUU2KzJidlg5SjN4VVdNdUhtOG96?=
 =?utf-8?B?a3JMbmJBVmdaNWxMVlh4TkhpSnlJY0gxNlB4NGdCZnJibmVhSUdEQVc5WElX?=
 =?utf-8?B?NWpoSUpqazlrUms1ZldzcFkvS2VtYU1SaVB4Q04yTkRSWlUyN2VnVzBSc1hB?=
 =?utf-8?B?UUJyTWFaWkVOL1BzcjVqV1RQU05HeVZzbVAzcjJWS292UVBWbDNvRlMyejZF?=
 =?utf-8?B?bWg4K0NxNSsrZnJsSG9Sd1JFUU1PUGN0RW90YzkzRFlNQlNZRnNRSVA4c3Rp?=
 =?utf-8?B?dGpkNVVlL3pNS2c3aDFSblYvam9XeTVjRXJMYlhpaUNvczBBdjRuTVBIdzZ2?=
 =?utf-8?B?WDkwZGhCcmxCMVVmcUM3YWIzc0dDdnRwM251bTM5S2pJVjFHQzBwNlVmaWVN?=
 =?utf-8?B?VVlqMkNnV1hkcTBpRjBBY1VRQVByTzdzMUd0TzA5Z2lmR09lS0JTSjZ1QjZR?=
 =?utf-8?B?QmdaeXllZkFMSUU3a3RFcDROUThvUVBua2JsczZOTnh6ZkNPSWJQRFljalFW?=
 =?utf-8?B?Vno4UVhybFBoMmpaZHJFNWpoWVVWRVhIY2xwM0ZhMG16blhSZXNaZSt6WGlB?=
 =?utf-8?B?VmVLWlBsYU5JdmdML1EvM05xSnVrdzdQckMzOTVWaDVVOUZDMjd0bWVpSXVl?=
 =?utf-8?B?QTlYbHRFN3hvZnV2aVA3b3p2ajVZYU5lQ1g2RDJ0LzhreDRaZ09XVHRwenV0?=
 =?utf-8?B?OTJKeXJpN0UwOEdaQlNLdGdiNk94eTY5QWtLK3BVNjhTR1B3REt0ZC9OTGlK?=
 =?utf-8?B?SWVsekFJQlc4dE41TnBSeWd0ZHVYa0xGMVBVSUNjbC9WS2tsYjgrK3luQnd3?=
 =?utf-8?B?ZzZXT2dZT3dNL29CeUtJaTQ2czlKQm93NHU3RVV0RXZNakRrVXB4UXBTb0RE?=
 =?utf-8?B?am5zdFI3Znk3TUVxdHVJQStscWZGRWN1K2tqcyswM3gydzFyZnU5MHpiTC9O?=
 =?utf-8?B?bldFSzNLQzIybW1TckJPbnlOU05uQ0dsemxGUUxBR3M4NnFpOFlWa3BDZnh2?=
 =?utf-8?Q?/RqeILbo9kaoy/oPHS?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67bf0364-1b86-4f3c-e768-08df1808260e
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5320.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 17:45:38.8185
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zXZvgb8G/70RobcahYwvf1pYf1UhR+EPSwagEdf4aYVBkJU0M64oA1r40cEQ8h3B
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6651

Hi Tony,


On 9/16/26 18:13, Tony Luck wrote:
> File system code allocates the rmid_ptrs[] array once during
> initialization. The number of entries needed in this array is currently
> constant. When changes are made to allow Application Energy Telemetry
> (AET) to run with the pmt_telemetry driver as a module, then number of
> entries needed may change from one mount to the next.
> 
> Allocate rmid_ptrs[] with enough entries for any future mount.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
> v12:
> 	New patch. Split out from old patch 12.
> 	New global pqr_assoc_num_rmid to avoid repeat CPUID calls.
> ---
>   include/linux/resctrl.h            |  1 +
>   arch/x86/kernel/cpu/resctrl/core.c | 27 +++++++++++++++++++++++++++
>   drivers/resctrl/mpam_resctrl.c     |  9 +++++++++
>   fs/resctrl/monitor.c               |  2 +-
>   4 files changed, 38 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index fbf737e884db..5535bde7b925 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -447,6 +447,7 @@ static inline u32 resctrl_get_default_ctrl(struct rdt_resource *r)
>   /* The number of closid supported by this resource regardless of CDP */
>   u32 resctrl_arch_get_num_closid(struct rdt_resource *r);
>   u32 resctrl_arch_system_num_rmid_idx(void);
> +u32 resctrl_arch_system_max_rmid_idx(void);
>   int resctrl_arch_update_domains(struct rdt_resource *r, u32 closid);
>   
>   /**
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index 2e3b9c16cbda..a9109f2bc43e 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -45,6 +45,9 @@ static DEFINE_MUTEX(domain_list_lock);
>    */
>   DEFINE_PER_CPU(struct resctrl_pqr_state, pqr_state);
>   
> +/* Number of RMIDS values that can be written to IA32_PQR_ASSOC.RMID */
> +static u32 pqr_assoc_num_rmid;
> +
>   static void mba_wrmsr_intel(struct msr_param *m);
>   static void cat_wrmsr(struct msr_param *m);
>   static void mba_wrmsr_amd(struct msr_param *m);
> @@ -124,6 +127,28 @@ u32 resctrl_arch_system_num_rmid_idx(void)
>   	return num_rmids == U32_MAX ? 0 : num_rmids;
>   }
>   
> +/**
> + * resctrl_arch_system_max_rmid_idx - Largest possible number of RMIDs
> + *
> + * Return: Maximum possible number of RMIDs used for boot time allocations.
> + */
> +u32 resctrl_arch_system_max_rmid_idx(void)
> +{
> +	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
> +	u32 num_rmid = pqr_assoc_num_rmid;

Why not  use "cpuid_ebx(0xf) + 1" instead of global variable?

Thanks
Babu
