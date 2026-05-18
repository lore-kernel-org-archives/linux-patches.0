Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012024.outbound.protection.outlook.com [52.101.48.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40465396560
	for <patches@lists.linux.dev>; Mon, 18 May 2026 20:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.24
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779137729; cv=fail; b=JFR/4WSnZzSxbIDgPn96mrXZFSXtrQKWl65Il/9Ou81uuA6SYmtTvyQxj2lNfx1K2ET1jd45Vh/p3eWGlCrNm1sSM4v15XvnZe6CnKgZkhM16qkrv/ljxF6SwOH5r3K7606zihuloccNzD5cCJK7L5W+izS+qs2B5cZqxX4YFu8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779137729; c=relaxed/simple;
	bh=sLfVeNR88uoaCXTkHAx64R7geKVsy7OcldDsqC1xkq4=;
	h=Message-ID:Date:From:Subject:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=R7UQTqIPc3esR1dffMYxzGfWUT/8ya5jUgNK8tsGgCidC6Wwh7IVhrcGdOa71o3C6AyhqtIy6N9D0a1xUiM2kOBB2Lf7wE2sVXXMA8le2MndEgZGaCwLQdI6aNP1GiCUeptDQxR6m65rw94UPqdrlgH/tDfl9mO7UXk5W9fTXFI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ggWawMEj; arc=fail smtp.client-ip=52.101.48.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ggWawMEj"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UTaIPDVQcBiv57um49nsxGras4DIl1uSVUkROIMArjvGvMoOltNrTLSM3EOHApQnwdB/vM3fV9oUV1qryrM2LH1IN33p6xvlp+w5qeve5nCE+qLgKlc1a7nw2rGJSc+MOEa/ToF41kunzOdfXoSxi52SdtUc5po1re0DUYWPpq/7d2kr/EXbAc4ba9CRxI3A5m3Fe4tDHO+CyQZo2dlB1RYBqpCiFGJAj+7jK829ChYsNDrDglHj4zzjAIYosDhsRErz8+jHx3hN+tiCpC6lUveolM2AJN9l6j+ZMl/OdOzIBaLhc5bmA8sVy4rP3geqMLq5bPE7gkfWuwPfg0F5IA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/W96JRVqCN/flRxbA9+tqFQ3YJHAQzhWiBqYPj6ygDU=;
 b=luT42uWKw/NL4YzaqSRktFQ6Lex2pFv01ybdwe9pfH/B22+LZiKHzM8G2mfvphCJv6yW364qrDKMBIftQ/R41spC+CDSKtxMOWj6c/PveFl9AHDQi7dIg1gcwhSgU+5K1P2OjsdeE+t97J4qBaOUVz0xElId2VSiYjerMZ+NdJnoXchri1oS8tJQWSrmvqwOw+ggCrSgKwJ5lVSalwSPtl+JjwzVg/2dQLgpupQjKVL/88INnMFj7l8QvOU9X+phD2dYT6kw0R6Bhf7mo1/zuU5iNkKvHn3eehbKrMf3pLrD0uTMTbTBQI7fIWwNuiaqj0LuB31iMcMoO4AjADt4PQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/W96JRVqCN/flRxbA9+tqFQ3YJHAQzhWiBqYPj6ygDU=;
 b=ggWawMEj51ShxfZaN/DUoIWs8ne8Xbj8DB2tou/+HGUkX4OMmKxaQ4iZfDzzVfEKHECrawkvCH/6QxY3wndyJOUX5kuExZW9QV1Cci91Ee0nASmCzizEy+jcOWjYecym0rF/vWU8t2PZ5kdip0psH3jr1US3V5+Qh61qY/VjOcY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SA3PR12MB8803.namprd12.prod.outlook.com (2603:10b6:806:317::8)
 by CY3PR12MB9631.namprd12.prod.outlook.com (2603:10b6:930:ff::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.19; Mon, 18 May
 2026 20:55:17 +0000
Received: from SA3PR12MB8803.namprd12.prod.outlook.com
 ([fe80::b6b5:dec5:43de:6d2f]) by SA3PR12MB8803.namprd12.prod.outlook.com
 ([fe80::b6b5:dec5:43de:6d2f%6]) with mapi id 15.21.0025.022; Mon, 18 May 2026
 20:55:14 +0000
Message-ID: <170821c5-0d78-4c7a-a52d-e37a5133356c@amd.com>
Date: Mon, 18 May 2026 15:55:11 -0500
User-Agent: Mozilla Thunderbird
From: Babu Moger <babu.moger@amd.com>
Subject: Re: [PATCH v2 5/5] fs/resctrl: Fix issues with worker threads when
 CPUs are taken offline
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>,
 Reinette Chatre <reinette.chatre@intel.com>,
 Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
 Peter Newman <peternewman@google.com>, James Morse <james.morse@arm.com>,
 Drew Fustini <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>,
 Chen Yu <yu.c.chen@intel.com>
Cc: Borislav Petkov <bp@alien8.de>, x86@kernel.org,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <20260515193944.15114-1-tony.luck@intel.com>
 <20260515193944.15114-6-tony.luck@intel.com>
Content-Language: en-US
In-Reply-To: <20260515193944.15114-6-tony.luck@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0065.namprd03.prod.outlook.com
 (2603:10b6:610:cc::10) To SA3PR12MB8803.namprd12.prod.outlook.com
 (2603:10b6:806:317::8)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA3PR12MB8803:EE_|CY3PR12MB9631:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f282352-a177-4845-5c4c-08deb51fc234
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|7416014|4143699003|11063799003|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	vPeWlJ/tnX+pWr0/yae6i9fCD+Wr3ocVrmqN+X8PptZSL7+SmRNW8EUemy5Y2ZIYAyoaYS7mgXJ8tKjZIkt0zgPjsY8JmkBU2A/vCEyQQB4IPo+0Y8Pt0++zZW93tJZvr5JiK+Y7Kov8Q+TUUKyHVnGNvYnN/sdmIMM3O1DoK8ysfBdA4ItFYeFa8fCNoG6UgRu3Pg9rDWvlH7MguAka8SHmecNsGhmgE2/F5FvQkLWImvEBo6TQPEMEDGx/l6PwlcqhFcaI64gizH0kJAeKObQI0p5KpzqKc8j3R6ywTOBbmIQpzr1UMOZIMIwfJc59mNYNdL1sfuchVbqKPWmOA3OtCV+6/q2FWa2HOW22pjR7GNqxNL/hAZTVP5ZLOyRggyTTghEJU8vleNAZsMKZT4oofDfZVau4dHFG5RQhX/cfwq+wY/8yu/JMbNnY+t7NiUtr89P+EIiQm/x5e3Dfw45PAZ7qT39fOSPwj1QDVV6fvYpY9P48vQYPYQLmWaJsUYpsF6QNdk9RCUNYw8lsVRy0474sApHIk1l4GGwS/+ZuoUU7NsKB0aa1NKJZt7ed5zEnY8zFC26WXvF+x1ARQ9oyimmIQSKleieihV5BypiTlmPNndSNzZcXdwZVkOBMHrypPTTLkWAcjncEi7nY1g==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB8803.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014)(4143699003)(11063799003)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c2t0R3VQbkNOVjNFaEhUL3dEZzRpT1pXTC9tWEZPZDBoMi9UQlRYbWdIbVNF?=
 =?utf-8?B?NmtnQU5vU0ZHNkgvY2t4WDdTZUlvTzZCdnN4NGRwaE1kTXJScUoxblFucEVi?=
 =?utf-8?B?Y1dSYmVvS1lhZzlObGZIQk9MVU4xVGtpUWtXZUFkOHhGbERNMEJXbTVwcldw?=
 =?utf-8?B?UGlwU3VRWmppeGtkNUh4b3BQT1R4elBwQ0Y3S0RvQ3RDV0p0bys5TDF5NmVT?=
 =?utf-8?B?eURGa0c2WStpMUJIZGRxL0dUeWVjb3NnZnNlaE5XSjdyWm9sek8xdjlzejgv?=
 =?utf-8?B?d3YzSlB5Y2dUUUhWOXZhOUhWZXJIbnc0cmY3RWdSc3QxdDBQank3TTRvQVM3?=
 =?utf-8?B?ZWxETzB5R0NOVVh2eDNXdHNiTnQrQ2Q1Q09EdVdsSFZSZEZOUmZlT3BOTVBa?=
 =?utf-8?B?WXhTeVpqQ3JGZzJqcFNRZlNUUmhuWUxiNmlNLzE4cXFjQTdETHc1ZU93YXZI?=
 =?utf-8?B?M2ZhOERURFJlcjRZNGp1bUVTL1dVK05Lc2VYeVYvbk5veXNMTlMzUTBFRjEz?=
 =?utf-8?B?UW5Wd0FoSHA4K0NOSFN3TzExWjAyT2t4TU9jMmwzVVJqQWlrVXZxamVwREkr?=
 =?utf-8?B?R0VDbmRiVGlwemlReVRCV1RVbmlPRzZIUGFnUkZRZFNHR3NRdWRvME0wd09o?=
 =?utf-8?B?S29FN3ArRzhlMlpiS081ZFdvbVAyVHJvMnBrZ2RNUlpNYWRKTnFCcG9XYW1a?=
 =?utf-8?B?YjRYdk9mUHBkSmhidEFlUC9NeDlhdkQ5SFM2am1iVTV6bjcwZk04RDRUcGdp?=
 =?utf-8?B?eTNYcFZSVXh3WnpDN0R4c3NKMmhSeGpJblJtZ3MwUTNrMS9INVpEdXRNTERv?=
 =?utf-8?B?eEhkY2RUMGhnTU8ycStJc2FsaEs0SDVaV2phRU5CekZhbEJ1M3Q1QzFKeFha?=
 =?utf-8?B?TzJicC9JbjU0WEViT3FZS3ZaRURIZ1Rvblh1eGpVMDgyRWFjT1lmbDMySmZX?=
 =?utf-8?B?Q3d2b1cxZWVxdm5VY0hmNGswWXJmaCtaQnc1bG5tMTVDSHVuV1I5NFArY1dC?=
 =?utf-8?B?YS9hc1YwaWVmaVY4dzZqTEZRNU9VQm9XN0l6QXlQM0UwMzJUT0NRQzJJNXlU?=
 =?utf-8?B?NXpRbWZIZjJxM0dkbld4bjZCZ05IS2RzczY2bW1FUDN4YkRkeCsrc1BsU1JV?=
 =?utf-8?B?NVJYb3pVeVhLR0JkRkhUNlEyM0ZBSm92OXF4NFRaMTAyWnFxZ1I4aVpCVmlZ?=
 =?utf-8?B?d2FJZG41V3JWbVMzblZTUTNnaEFDL2ZjUUtUR1pQeU5INHRTcnlHMVhoTnF3?=
 =?utf-8?B?ZFZVam5VeDZwbTAvdkhZWEdleTRGanc5RXEyMldGR054OGs4elZVSVdSSmF1?=
 =?utf-8?B?YmRweFNNMWJFTXNJeXlWbVdiQ2htMkFwdkZlRGc4RzhwY2ZyOEJ3MGlKK05i?=
 =?utf-8?B?Q2FqNFNDMndTNk9JbTZvZ1EyMXc2bHVIVHI4N3JLdjEvOXhPZ1JFQ0Y3Vm10?=
 =?utf-8?B?NWFHWGRna3RFUkhma2RRakZKbURyWHdyZ0tHekRiSUZ1a1ZTdGlmOVRRaWpT?=
 =?utf-8?B?UkN1OEJSU3VOck9ZbWUxVFprdllobzdHbVNsNkMxcWlvaUxOS3FVRitHZ0s1?=
 =?utf-8?B?aFBnMzE3eWh5bnBrTXBWWG81MTlqT01ZOVFiVk9FRUQwTEFZODYxbEttNDUy?=
 =?utf-8?B?d205QWdlaXpuRlAyZll6Y24vTEJPSTdPN2ZlTWQyaHA4d1FQc3llZFlwTW0r?=
 =?utf-8?B?N2wvV0h3a1lQbVNQSG9HcVhxVSs5aURxL1N3VlNJLzVkMnUzTEJJTnJ5VWsy?=
 =?utf-8?B?bXQvNGYzejdmV0RSVThhOUQvdmxvZWhUdldVSHpYTGhNbE9NMkREemV3TDEz?=
 =?utf-8?B?UnM5RFR4YU82TUc2dDhMSDliSGdGR2VuU2NaUTFhWVNnUUkycVA2MURZZUVD?=
 =?utf-8?B?VkxWSWxhdkEzRENncGtmanNUeWRmY29xdWpYaFRqU09qUlpzTDRqWThOZTZk?=
 =?utf-8?B?ZVlFU2FpcHBkcEZKWGVpZFFQUC85SERhZm84eUNQbEJpWDF2aVlLTGVJbzBP?=
 =?utf-8?B?aHhWd2Focm52K09Yc1hHNWZRa1lma09tc0I0ZzZ2TVluYnlaK0NjNjlmdW52?=
 =?utf-8?B?Vm8wa3V2cDhJQnBaZGJlbUpaSE04ODdXYUczVVJORmI4OXJnd28xaWQ2QWV2?=
 =?utf-8?B?cE15ODQrL2hidFE1cDkvMEpLZXhXdHVpN0ZpVHNGTWJ6UFdEMUN1NFh6QXRS?=
 =?utf-8?B?QWEyc3ZXRmVNdkU2OFl3ajJuaDJVaE9mZGpDZzRmMjBHVzkyT2hFQURSWndl?=
 =?utf-8?B?c2pVZnF6YjFxVUZ6Sm1obGpBK0JmRmpLSitoRHlzL2M1eG45OWZiMkxUdjNl?=
 =?utf-8?Q?29xgyD5l41MxW3IV7G?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f282352-a177-4845-5c4c-08deb51fc234
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB8803.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2026 20:55:14.1251
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aiFIyI0ubEps4juUcdlCmMMe9uQKIl+nILLzmXH4CJaxswKndy5YvhIvNrvlW6Xo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY3PR12MB9631

Hi Tony,


On 5/15/26 14:39, Tony Luck wrote:
> From: Reinette Chatre <reinette.chatre@intel.com>
> 
> Sashiko noticed[1] a user-after-free in the resctrl worker thread code

user-after-free -> use-after-free

> where the rdt_l3_mon_domain structure was freed while the worker was blocked
> waiting for locks.
> 
> The root issue is that cancel_delayed_work() does not block in the case where
> the worker thread is executing. This results in the race that Sashiko noticed,
> but also causes problems when the CPU that has been chosen to service the
> worker thread is taken offline.
> 
> Note that worker threads are allowed to delete their own work_struct
> (see comment in kernel/workqueue.c:process_one_work()) so there can't be
> any problems on the return path from the worker in this case where the
> work_struct was deleted by other code while the worker was executing.
> 
> Indicate failure of cancel_delayed_work() calls in resctrl_offline_cpu()
> by setting d->mbm_work_cpu or d->cqm_work_cpu to nr_cpu_ids. Make the worker
> threads check to see if they are no longer bound to the right CPU. In this
> case search the L3 domain list for any domain(s) with the work cpu set to
> nr_cpu_ids. In the case where the last CPU was removed from a domain, the
> domain has been removed from the list and there is nothing to do. If the
> domain still exists, then restart the worker on any of the remaining CPUs.
> 
> Remove redundant cancel_delayed_work() calls from resctrl_offline_mon_domain().
> 
> Fixes: 24247aeeabe9 ("x86/intel_rdt/cqm: Improve limbo list processing")
> Co-developed-by: Tony Luck <tony.luck@intel.com>
> Signed-off-by: Tony Luck <tony.luck@intel.com>

This should be

Co-developed-by: Tony Luck <tony.luck@intel.com>
Signed-off-by:   Tony Luck <tony.luck@intel.com>
Signed-off-by:   Reinette Chatre <reinette.chatre@intel.com>

Thanks
Babu

> Link: https://sashiko.dev/#/patchset/20260429184858.36423-1-tony.luck%40intel.com [1]
> ---
>   fs/resctrl/monitor.c  | 55 +++++++++++++++++++++++++++++++++++++++++++
>   fs/resctrl/rdtgroup.c | 27 +++++++++++++++------
>   2 files changed, 75 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
> index 9fd901c78dc6..c422850f044b 100644
> --- a/fs/resctrl/monitor.c
> +++ b/fs/resctrl/monitor.c
> @@ -791,12 +791,38 @@ static void mbm_update(struct rdt_resource *r, struct rdt_l3_mon_domain *d,
>    */
>   void cqm_handle_limbo(struct work_struct *work)
>   {
> +	struct rdt_resource *r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
>   	unsigned long delay = msecs_to_jiffies(CQM_LIMBOCHECK_INTERVAL);
>   	struct rdt_l3_mon_domain *d;
>   
>   	cpus_read_lock();
>   	mutex_lock(&rdtgroup_mutex);
>   
> +	/*
> +	 * Worker was blocked waiting for the CPU it was running on to go
> +	 * offline. Handle two scenarios:
> +	 * - Worker was running on the last CPU of a domain. The domain and
> +	 *   thus the work_struct has been freed so do not attempt to obtain
> +	 *   domain via container_of(). All remaining domains have limbo
> +	 *   handlers so the loop will not find any domains needing a
> +	 *   limbo handler. Just exit.
> +	 * - Worker was running on CPU that just went offline with other
> +	 *   CPUs in domain still running and available to take over the
> +	 *   worker. Offline handler could not schedule a new worker on
> +	 *   another CPU in the domain but signaled that this needs to be
> +	 *   done by setting cqm_work_cpu to nr_cpu_ids. Find the domain
> +	 *   that needs a worker and schedule it after the normal CQM
> +	 *   interval.
> +	 */
> +	if (!is_percpu_thread()) {
> +		list_for_each_entry(d, &r->mon_domains, hdr.list) {
> +			if (d->cqm_work_cpu == nr_cpu_ids)
> +				cqm_setup_limbo_handler(d, CQM_LIMBOCHECK_INTERVAL,
> +							RESCTRL_PICK_ANY_CPU);
> +		}
> +		goto out_unlock;
> +	}
> +
>   	d = container_of(work, struct rdt_l3_mon_domain, cqm_limbo.work);
>   
>   	__check_limbo(d, false);
> @@ -808,6 +834,7 @@ void cqm_handle_limbo(struct work_struct *work)
>   					 delay);
>   	}
>   
> +out_unlock:
>   	mutex_unlock(&rdtgroup_mutex);
>   	cpus_read_unlock();
>   }
> @@ -852,6 +879,34 @@ void mbm_handle_overflow(struct work_struct *work)
>   		goto out_unlock;
>   
>   	r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
> +
> +	/*
> +	 * Worker was blocked waiting for the CPU it was running on to go
> +	 * offline. Handle two scenarios:
> +	 * - Worker was running on the last CPU of a domain. The domain and
> +	 *   thus the work_struct has been freed so do not attempt to obtain
> +	 *   domain via container_of(). All remaining domains have overflow
> +	 *   handlers so the loop will not find any domains needing an
> +	 *   overflow handler. Just exit.
> +	 * - Worker was running on CPU that just went offline with other
> +	 *   CPUs in domain still running and available to take over the
> +	 *   worker. Offline handler could not schedule a new worker on
> +	 *   another CPU in the domain but signaled that this needs to be
> +	 *   done by setting mbm_work_cpu to nr_cpu_ids. Find the domain
> +	 *   that needs a worker and schedule it to run after the normal
> +	 *   MBM interval. This is completely safe on CPUs with wide MBM
> +	 *   counters. Likely OK for old CPUs with narrow counters as the
> +	 *   MBM_OVERFLOW_INTERVAL was picked conservatively.
> +	 */
> +	if (!is_percpu_thread()) {
> +		list_for_each_entry(d, &r->mon_domains, hdr.list) {
> +			if (d->mbm_work_cpu == nr_cpu_ids)
> +				mbm_setup_overflow_handler(d, MBM_OVERFLOW_INTERVAL,
> +							   RESCTRL_PICK_ANY_CPU);
> +		}
> +		goto out_unlock;
> +	}
> +
>   	d = container_of(work, struct rdt_l3_mon_domain, mbm_over.work);
>   
>   	list_for_each_entry(prgrp, &rdt_all_groups, rdtgroup_list) {
> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> index 282a0acedea8..fd82fc78b058 100644
> --- a/fs/resctrl/rdtgroup.c
> +++ b/fs/resctrl/rdtgroup.c
> @@ -4376,8 +4376,7 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *h
>   		goto out_unlock;
>   
>   	d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
> -	if (resctrl_is_mbm_enabled())
> -		cancel_delayed_work(&d->mbm_over);
> +
>   	if (resctrl_is_mon_event_enabled(QOS_L3_OCCUP_EVENT_ID) && has_busy_rmid(d)) {
>   		/*
>   		 * When a package is going down, forcefully
> @@ -4388,7 +4387,6 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *h
>   		 * package never comes back.
>   		 */
>   		__check_limbo(d, true);
> -		cancel_delayed_work(&d->cqm_limbo);
>   	}
>   
>   	domain_destroy_l3_mon_state(d);
> @@ -4569,13 +4567,28 @@ void resctrl_offline_cpu(unsigned int cpu)
>   	d = get_mon_domain_from_cpu(cpu, l3);
>   	if (d) {
>   		if (resctrl_is_mbm_enabled() && cpu == d->mbm_work_cpu) {
> -			cancel_delayed_work(&d->mbm_over);
> -			mbm_setup_overflow_handler(d, 0, cpu);
> +			if (cancel_delayed_work(&d->mbm_over)) {
> +				mbm_setup_overflow_handler(d, 0, cpu);
> +			} else {
> +				/*
> +				 * Unable to schedule work on new CPU if it
> +				 * is currently running since the re-schedule
> +				 * will just force new work to run on
> +				 * current CPU. Mark domain's worker as
> +				 * needing to be rescheduled to be handled
> +				 * by worker itself.
> +				 */
> +				d->mbm_work_cpu = nr_cpu_ids;
> +			}
>   		}
>   		if (resctrl_is_mon_event_enabled(QOS_L3_OCCUP_EVENT_ID) &&
>   		    cpu == d->cqm_work_cpu && has_busy_rmid(d)) {
> -			cancel_delayed_work(&d->cqm_limbo);
> -			cqm_setup_limbo_handler(d, 0, cpu);
> +			if (cancel_delayed_work(&d->cqm_limbo)) {
> +				cqm_setup_limbo_handler(d, 0, cpu);
> +			} else {
> +				/* Same as mbm_work_cpu case above */
> +				d->cqm_work_cpu = nr_cpu_ids;
> +			}
>   		}
>   	}
>   

