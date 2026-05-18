Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011055.outbound.protection.outlook.com [52.101.52.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 176F5359A68
	for <patches@lists.linux.dev>; Mon, 18 May 2026 20:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779137663; cv=fail; b=GMNGR66YvjhOj2GZ1Htgm/Ll2lA6+9ftSaN7jnIUgJnh/xWSZTzwx5ys2zwpktAWo1K1WHJBlbc4MEXodP+0vAL0Z1DUtyzBn/t6y4wJmjdGBSUZLv/FjJSFHe8pKFPljFHcmiDO/1irenlqHVjmYXqR1Fb9upL9D9A06twTsS0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779137663; c=relaxed/simple;
	bh=zmP3UqEJuEnbbIGy7CvLZPGczCcoVx6KmE0A9s0EhQw=;
	h=Message-ID:Date:From:Subject:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TFOvQqTT78sSMiyfJjd2vuD+Ibitt3bAxcY4ilTHM7KUH6DtjlWzQQ2wqly93ci2xCN7KyfFo7fyxx/wx2iGr+fchDm4pI9TgDhF4SnTrefaFi2F/OPsJiqjSDamQpPkgOPRRvaORPXgZUp3+CshyhUWLZNPtPZruyuFyYNUsIc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=vjZP4a5I; arc=fail smtp.client-ip=52.101.52.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="vjZP4a5I"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kNMU+lwysIpCEqwrQ2/vuScEqFelSNlJYAuSAA8QjxmIaBWPmYrZaqQNyo9gwGcu8LsoV2gVhz4i6MRq26Gqf1BK1pWdFiIp+CLNMR7A7HfTlIc7CU3N4R955enSwjXTlzFziSghrUQ2rV2n/2494VsmwQgoHDEk8/oCk9vGHkxd+STLn9Gf51PKy+yIcA9e6Z9f6ogjz3lbrI/exVYgBBVjg2hYAqD9tXU7rgBWIA6DBVVHNgnPK1Omby4RopE4Nj6AbaVhNn+jgrG5k9lfRx0HUGDe+XI0zr7THLiKo/MfP3MKyIrwvlXTICYAOQ8TEU3as8IAW08QJskftO0agA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DP2kE9xEqOwVBgiVrCaA9fP6FfRtGNkx+BlLdBKSNqU=;
 b=Ksf/oiKRNtrQPymP5wr8drp+7lOBdBrWPkyx5YCJ5OzsgY0MBRdsSX2q4L1PDY97sYetaVLns5RXLMvt6R9RC8rVUB7A4DkjswTSuAbRTarPMXORQukoM0D/61yzxROEMEPr+E/ihCAUE+1w+Zu3X3i7HoWMELo9nlPrv2UWQL9H+RmW7qZj14OkgfAhIjNdstHSljGa09PuRrxGQa4KaBaPz4RHADDWPlKHS2t0rwApGd3AVUgEyJsicpnUvgb5VG58XU8vW8K+imfFK/Q5D4zOjbh4FbyEQxsqM5UsLrIRwDAgUrxWRHY8FOyt3AKvEsTZ5yHvOnbmtak26cZIrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DP2kE9xEqOwVBgiVrCaA9fP6FfRtGNkx+BlLdBKSNqU=;
 b=vjZP4a5Ip1NDQqwx5LmbKzxkukJ/DXX0tWt/ENJhakbeJroIxvBWVZMRQLsQ+qkfoTUEykeIRxQ7brOfbjur8I3gnNdFfc22KNKD2AFfRM1nozPMPPUhzWHXte1z7FC/ArHkIRUaYm91q9KeOXx0zt4qwhZxXhIzmG8Deehd3hU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SA3PR12MB8803.namprd12.prod.outlook.com (2603:10b6:806:317::8)
 by CY3PR12MB9631.namprd12.prod.outlook.com (2603:10b6:930:ff::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.19; Mon, 18 May
 2026 20:54:15 +0000
Received: from SA3PR12MB8803.namprd12.prod.outlook.com
 ([fe80::b6b5:dec5:43de:6d2f]) by SA3PR12MB8803.namprd12.prod.outlook.com
 ([fe80::b6b5:dec5:43de:6d2f%6]) with mapi id 15.21.0025.022; Mon, 18 May 2026
 20:54:12 +0000
Message-ID: <6dc547cf-4e33-4075-a463-3208db35db0c@amd.com>
Date: Mon, 18 May 2026 15:54:09 -0500
User-Agent: Mozilla Thunderbird
From: Babu Moger <babu.moger@amd.com>
Subject: Re: [PATCH v2 1/5] fs/resctrl: Move functions to avoid forward
 references in subsequent fixes
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>,
 Reinette Chatre <reinette.chatre@intel.com>,
 Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
 Peter Newman <peternewman@google.com>, James Morse <james.morse@arm.com>,
 Drew Fustini <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>,
 Chen Yu <yu.c.chen@intel.com>
Cc: Borislav Petkov <bp@alien8.de>, x86@kernel.org,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <20260515193944.15114-1-tony.luck@intel.com>
 <20260515193944.15114-2-tony.luck@intel.com>
Content-Language: en-US
In-Reply-To: <20260515193944.15114-2-tony.luck@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0081.namprd03.prod.outlook.com
 (2603:10b6:610:cc::26) To SA3PR12MB8803.namprd12.prod.outlook.com
 (2603:10b6:806:317::8)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA3PR12MB8803:EE_|CY3PR12MB9631:EE_
X-MS-Office365-Filtering-Correlation-Id: ef186533-467e-43d4-5c7e-08deb51f9d22
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|7416014|4143699003|11063799003|18002099003|56012099003|22082099003|3023799003;
X-Microsoft-Antispam-Message-Info:
	ItHfH4v1PoeUvn5tN2PZkYnf0/JzQFx9T/le4B8+fG/7l0/89xpW4GcTU1wS9gulOvw5IxIpkg8qSCzgbIvmvqXpUidCfVsike9HSl1BgKLWkT6T4MEoXhq1QSfHRJSN7pZ7hf53ysjRT0+qBZKBDRgmmnOF4M6rvP27Z0KQg0NHP4MU99dUSRP3/ut3ufedAvYRq0l0x1GuMZutvW+35v4bPGscX2b+nXzH4ngbc1DP1R5fayMlVZFboVfJl+xbwFnSlHXedjO3n2+0kuEZ1GUlO+G9RXd8x+4HpRtJD7ApJITErrbM7Xn+xvS5k9+fx2p0ES/LwGxrJAXYzrHQc4bqyV9mIF55uoAC2SzsSNZhedDXLfJr1/ZoIPx9UbUQYzqFySy8kCYRaGYlO1ujrBoj4Dj2SPRn1ZRvWpJscbf5qX2kmzojQItVb1QBvzwFH4IHAWQPcxjA69N7Pg5lV0SqrdkYTPeNXcDsmJ3nfKvGKooW37Cu5mZGhFC78Yj9usBZfi2rLrVOR8GqwJZq1+n51gedQD6ulLfqS6PvXrS6DzpSkX8S3cA2KX2cP8ftwiShaGlQLV/QH4h9Sj1Mqlt77LlGl+miNwYLq2V17JNHsTavmPM+sWEob+zT1QypHe8rm9A8+wUvvC5JxyyM9rocTLmAnQfABBhKvOy782w3nqhhCfcY1rh0ZP0Jrhv+
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB8803.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014)(4143699003)(11063799003)(18002099003)(56012099003)(22082099003)(3023799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WStoUFNCeXBXZlJYcmt5Mk9nYW1VMXlhbUMvUnAxbTk0bi9NS0xhQmtsQysx?=
 =?utf-8?B?SUFGNGJyKyt4ZFFIUkhiZTVCQlgrdExFTCt3bE0yN1d3aVBGQTRraVRJTmJH?=
 =?utf-8?B?c0Y1WVJKYVZlc1JleXRUTjJpeDcyWXdzSnpmdEFPd2RranhOdEJJMDZUYk8r?=
 =?utf-8?B?MkpFTGdVSXpOZ0lrMzBPZ1hVbVNibU96VXFmVnJ3Vk4rT01SVzRmSVJLNWdV?=
 =?utf-8?B?Y0N5WnZ1d0hicU9BSVQvbGpITVovcUMvRVkyTWVSeEt4VTNCanVHOFY3d0l6?=
 =?utf-8?B?VDFmN1FFcURRQWZZSStkN1FPL2tpQXlNL2drUEYwNjIveTVEOWtjU1hhU1BB?=
 =?utf-8?B?ZWNFODF5WHZEelRYdlhPQXM3RW82TWxMOVE3QjZBaGdGT3piMno2bTEwM2Fw?=
 =?utf-8?B?K1Jmc2JLdnF3dmgvaFhrbGVUS21rd25qRU1UazdSUnZwQ2FqRDZLS0IvMlBD?=
 =?utf-8?B?MlQ0eWxaTTdMNC82SFdlejlMR2E5cHEzWGFBZ0pzMXl0VzczVXR1RFBvUVNz?=
 =?utf-8?B?VXBITjM5OHJ4dFVFb1lMTjZUTktxRUpmNGtpNnR0NnU3Tzd2a0FIUkxDcEhD?=
 =?utf-8?B?cWExTzIxR2xWOVZkU1NVRzlJNHJGeTdIZ25HUWZoQUovbXQzaUF5a3dYWHNj?=
 =?utf-8?B?NWlCT1BMQWs1Y2tZQ1IrZWtrSmxoSEhHVU5tREtGL3lBYVdNVHVzZ3hOTVJ3?=
 =?utf-8?B?MkdKbUhFbm9UalU4akt1eU41Wk11dk1BazR4VjlYcGFLZDFCNFhSWTlReUZk?=
 =?utf-8?B?TTZYbGhlK015NlhlandWMldNTzRnV21tSEp2SnRZWC9iblBFZy9JQVVjcFpa?=
 =?utf-8?B?aFNGc0NSbXVNeU1XVHNWNy9SaE5zdXRZbmk5NVFFSlFHT3B5ZmJFN25JWDl2?=
 =?utf-8?B?SmthSmpVK0FHVFJnWHpOMkRvVHZhZVNETGxEeU0wWkhjUURpNGxocCtxOGRC?=
 =?utf-8?B?VG5Sam9vWFQwV1A3K2tOUFNQenlNNGs5QjEvODI4MDZONThmSXVhanNhNUN1?=
 =?utf-8?B?MDQ0Z0tNRGZXM2VuNTM1azM4T3lQT2tDR0tCN2psYjJUVjFVR1R6Y0JScm1j?=
 =?utf-8?B?bjVCc0FPRlFUT2FLcklQVkg3Z045T2I4aDMvVmdsaU4xTGwwSGhyK2d1WmUz?=
 =?utf-8?B?cmY4Q1A3VWI1YmlVRHArTi84QnV6L3BlZFBBYlliWVk0bGNWSTdKai9uUkRF?=
 =?utf-8?B?OURoNysvTjJpb1RRSkFYMi9lYStmRElIOGFBZEZOb0c1bHdKakluSXMwMTJN?=
 =?utf-8?B?aEx0VGhaYzBuSEVYR3Q3UlVzWjFsK202SitjOExqMmx2SEZnaXFaQmRYenVK?=
 =?utf-8?B?KzFZRmVSYTVNeUtwYTVWcC9ZckdJaW5CNnhBSFVJczV0Y1ovUDFyU1N3V1dk?=
 =?utf-8?B?cTFuWHNCK2JPWGk3dm9Ybit2b2VxclF6dzg0R0g4ZFVTOWJzZm8yVkcxSVI2?=
 =?utf-8?B?NFVGOWQwVjNkNlp4bEZxMURhTG01alp4VHpaV2dXem1rSTVmZnBZNjJCdE1U?=
 =?utf-8?B?WDVPSXV0RmFxN3pTM2Rkb3BNTTV1cFJCYm10Z2V6V2lkaGttbVllR2Y5a01u?=
 =?utf-8?B?ek9UQXRTemx6S1lWRzdCREVYeDZrM25sd3dDa1JTRTcxdlhpc25wV2c0MUJX?=
 =?utf-8?B?VGpLZTV1bnBzclNoektvcCs4em5XTThmdVVzejNFVHl1Z0xSNGUvbUduYk0x?=
 =?utf-8?B?REgvUTlQdG1zcGU3cTFudFBEa2IzdTdWR0FKVjBVZFFOeEhib3F2OXlwaVhX?=
 =?utf-8?B?TDgvdGZlWTRCNkxzK1NTbktQZDFpQ291aUV1R3MxY0JQYTJldldhVVlmRWhY?=
 =?utf-8?B?OE1Pb2k1VWJ6a0FscStza3R4azUxOWZ1V1JsOHo1ZjRkNE0zM2pORnRpelc4?=
 =?utf-8?B?Qk9IQXk3NjZpV1ZFdWcxMDFQd0JFMzZySVRQTHp3N2JsWVEycjdkS0daTEdl?=
 =?utf-8?B?bDU1c0pxZTNpTkJsYjJYNnRqa2MwbWJKKzdtNmV3endOVCtxa3p3MXFPbUFZ?=
 =?utf-8?B?YnYxaEJZTUpxclNwU2dkZzFZMFdtcGl0ZVQvdC9BQnhVMTJEL0o3TTM2b2g2?=
 =?utf-8?B?aDNESzVvVjh2ZVJYdExaU0grYU1IZUF4anR0aVNiVkt6dnVIZUJXd0FqeVg2?=
 =?utf-8?B?dGg1aDIrMXN1Qitack15WUsxVDE2SDRoeXg3QVZzQlF2RWtnNUh2bVdZaVhR?=
 =?utf-8?B?OUdKZXpyQks1NVJMNjFoQ1BNQXVtRGxaYkFJelYwNzd0MkNsZEtQOTFUZmRp?=
 =?utf-8?B?Mnhac3FncDgrVmJWdUI2U2I1Wmx6c2lTZVp1cmdXRFQxUUNFbURLY3lhMTZM?=
 =?utf-8?Q?nd4HnIbIhK0XaWUJQd?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef186533-467e-43d4-5c7e-08deb51f9d22
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB8803.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2026 20:54:11.9443
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7Pin6Rn8z4KKZp7m4wRBHTdnDlJP7P40MkUDps/NwiQOySEWVxBuAvK/9SAbObD8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY3PR12MB9631

Hi Tony,

On 5/15/26 14:39, Tony Luck wrote:
> No functional change. Just pull some functions before rdt_get_tree().

Would it be better to list functions instead of "some functions" ?

Thanks
Babu

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>   fs/resctrl/rdtgroup.c | 376 +++++++++++++++++++++---------------------
>   1 file changed, 188 insertions(+), 188 deletions(-)
> 
> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> index 5dfdaa6f9d8f..a6376a3fc4c3 100644
> --- a/fs/resctrl/rdtgroup.c
> +++ b/fs/resctrl/rdtgroup.c
> @@ -2782,6 +2782,194 @@ static void schemata_list_destroy(void)
>   	}
>   }
>   
> +/*
> + * Move tasks from one to the other group. If @from is NULL, then all tasks
> + * in the systems are moved unconditionally (used for teardown).
> + *
> + * If @mask is not NULL the cpus on which moved tasks are running are set
> + * in that mask so the update smp function call is restricted to affected
> + * cpus.
> + */
> +static void rdt_move_group_tasks(struct rdtgroup *from, struct rdtgroup *to,
> +				 struct cpumask *mask)
> +{
> +	struct task_struct *p, *t;
> +
> +	read_lock(&tasklist_lock);
> +	for_each_process_thread(p, t) {
> +		if (!from || is_closid_match(t, from) ||
> +		    is_rmid_match(t, from)) {
> +			resctrl_arch_set_closid_rmid(t, to->closid,
> +						     to->mon.rmid);
> +
> +			/*
> +			 * Order the closid/rmid stores above before the loads
> +			 * in task_curr(). This pairs with the full barrier
> +			 * between the rq->curr update and
> +			 * resctrl_arch_sched_in() during context switch.
> +			 */
> +			smp_mb();
> +
> +			/*
> +			 * If the task is on a CPU, set the CPU in the mask.
> +			 * The detection is inaccurate as tasks might move or
> +			 * schedule before the smp function call takes place.
> +			 * In such a case the function call is pointless, but
> +			 * there is no other side effect.
> +			 */
> +			if (IS_ENABLED(CONFIG_SMP) && mask && task_curr(t))
> +				cpumask_set_cpu(task_cpu(t), mask);
> +		}
> +	}
> +	read_unlock(&tasklist_lock);
> +}
> +
> +static void free_all_child_rdtgrp(struct rdtgroup *rdtgrp)
> +{
> +	struct rdtgroup *sentry, *stmp;
> +	struct list_head *head;
> +
> +	head = &rdtgrp->mon.crdtgrp_list;
> +	list_for_each_entry_safe(sentry, stmp, head, mon.crdtgrp_list) {
> +		rdtgroup_unassign_cntrs(sentry);
> +		free_rmid(sentry->closid, sentry->mon.rmid);
> +		list_del(&sentry->mon.crdtgrp_list);
> +
> +		if (atomic_read(&sentry->waitcount) != 0)
> +			sentry->flags = RDT_DELETED;
> +		else
> +			rdtgroup_remove(sentry);
> +	}
> +}
> +
> +/*
> + * Forcibly remove all of subdirectories under root.
> + */
> +static void rmdir_all_sub(void)
> +{
> +	struct rdtgroup *rdtgrp, *tmp;
> +
> +	/* Move all tasks to the default resource group */
> +	rdt_move_group_tasks(NULL, &rdtgroup_default, NULL);
> +
> +	list_for_each_entry_safe(rdtgrp, tmp, &rdt_all_groups, rdtgroup_list) {
> +		/* Free any child rmids */
> +		free_all_child_rdtgrp(rdtgrp);
> +
> +		/* Remove each rdtgroup other than root */
> +		if (rdtgrp == &rdtgroup_default)
> +			continue;
> +
> +		if (rdtgrp->mode == RDT_MODE_PSEUDO_LOCKSETUP ||
> +		    rdtgrp->mode == RDT_MODE_PSEUDO_LOCKED)
> +			rdtgroup_pseudo_lock_remove(rdtgrp);
> +
> +		/*
> +		 * Give any CPUs back to the default group. We cannot copy
> +		 * cpu_online_mask because a CPU might have executed the
> +		 * offline callback already, but is still marked online.
> +		 */
> +		cpumask_or(&rdtgroup_default.cpu_mask,
> +			   &rdtgroup_default.cpu_mask, &rdtgrp->cpu_mask);
> +
> +		rdtgroup_unassign_cntrs(rdtgrp);
> +
> +		free_rmid(rdtgrp->closid, rdtgrp->mon.rmid);
> +
> +		kernfs_remove(rdtgrp->kn);
> +		list_del(&rdtgrp->rdtgroup_list);
> +
> +		if (atomic_read(&rdtgrp->waitcount) != 0)
> +			rdtgrp->flags = RDT_DELETED;
> +		else
> +			rdtgroup_remove(rdtgrp);
> +	}
> +	/* Notify online CPUs to update per cpu storage and PQR_ASSOC MSR */
> +	update_closid_rmid(cpu_online_mask, &rdtgroup_default);
> +
> +	kernfs_remove(kn_info);
> +	kernfs_remove(kn_mongrp);
> +	kernfs_remove(kn_mondata);
> +}
> +
> +/**
> + * mon_get_kn_priv() - Get the mon_data priv data for this event.
> + *
> + * The same values are used across the mon_data directories of all control and
> + * monitor groups for the same event in the same domain. Keep a list of
> + * allocated structures and re-use an existing one with the same values for
> + * @rid, @domid, etc.
> + *
> + * @rid:    The resource id for the event file being created.
> + * @domid:  The domain id for the event file being created.
> + * @mevt:   The type of event file being created.
> + * @do_sum: Whether SNC summing monitors are being created. Only set
> + *	    when @rid == RDT_RESOURCE_L3.
> + *
> + * Return: Pointer to mon_data private data of the event, NULL on failure.
> + */
> +static struct mon_data *mon_get_kn_priv(enum resctrl_res_level rid, int domid,
> +					struct mon_evt *mevt,
> +					bool do_sum)
> +{
> +	struct mon_data *priv;
> +
> +	lockdep_assert_held(&rdtgroup_mutex);
> +
> +	list_for_each_entry(priv, &mon_data_kn_priv_list, list) {
> +		if (priv->rid == rid && priv->domid == domid &&
> +		    priv->sum == do_sum && priv->evt == mevt)
> +			return priv;
> +	}
> +
> +	priv = kzalloc_obj(*priv);
> +	if (!priv)
> +		return NULL;
> +
> +	priv->rid = rid;
> +	priv->domid = domid;
> +	priv->sum = do_sum;
> +	priv->evt = mevt;
> +	list_add_tail(&priv->list, &mon_data_kn_priv_list);
> +
> +	return priv;
> +}
> +
> +/**
> + * mon_put_kn_priv() - Free all allocated mon_data structures.
> + *
> + * Called when resctrl file system is unmounted.
> + */
> +static void mon_put_kn_priv(void)
> +{
> +	struct mon_data *priv, *tmp;
> +
> +	lockdep_assert_held(&rdtgroup_mutex);
> +
> +	list_for_each_entry_safe(priv, tmp, &mon_data_kn_priv_list, list) {
> +		list_del(&priv->list);
> +		kfree(priv);
> +	}
> +}
> +
> +static void resctrl_fs_teardown(void)
> +{
> +	lockdep_assert_held(&rdtgroup_mutex);
> +
> +	/* Cleared by rdtgroup_destroy_root() */
> +	if (!rdtgroup_default.kn)
> +		return;
> +
> +	rmdir_all_sub();
> +	rdtgroup_unassign_cntrs(&rdtgroup_default);
> +	mon_put_kn_priv();
> +	rdt_pseudo_lock_release();
> +	rdtgroup_default.mode = RDT_MODE_SHAREABLE;
> +	closid_exit();
> +	schemata_list_destroy();
> +	rdtgroup_destroy_root();
> +}
> +
>   static int rdt_get_tree(struct fs_context *fc)
>   {
>   	struct rdt_fs_context *ctx = rdt_fc2context(fc);
> @@ -2981,194 +3169,6 @@ static int rdt_init_fs_context(struct fs_context *fc)
>   	return 0;
>   }
>   
> -/*
> - * Move tasks from one to the other group. If @from is NULL, then all tasks
> - * in the systems are moved unconditionally (used for teardown).
> - *
> - * If @mask is not NULL the cpus on which moved tasks are running are set
> - * in that mask so the update smp function call is restricted to affected
> - * cpus.
> - */
> -static void rdt_move_group_tasks(struct rdtgroup *from, struct rdtgroup *to,
> -				 struct cpumask *mask)
> -{
> -	struct task_struct *p, *t;
> -
> -	read_lock(&tasklist_lock);
> -	for_each_process_thread(p, t) {
> -		if (!from || is_closid_match(t, from) ||
> -		    is_rmid_match(t, from)) {
> -			resctrl_arch_set_closid_rmid(t, to->closid,
> -						     to->mon.rmid);
> -
> -			/*
> -			 * Order the closid/rmid stores above before the loads
> -			 * in task_curr(). This pairs with the full barrier
> -			 * between the rq->curr update and
> -			 * resctrl_arch_sched_in() during context switch.
> -			 */
> -			smp_mb();
> -
> -			/*
> -			 * If the task is on a CPU, set the CPU in the mask.
> -			 * The detection is inaccurate as tasks might move or
> -			 * schedule before the smp function call takes place.
> -			 * In such a case the function call is pointless, but
> -			 * there is no other side effect.
> -			 */
> -			if (IS_ENABLED(CONFIG_SMP) && mask && task_curr(t))
> -				cpumask_set_cpu(task_cpu(t), mask);
> -		}
> -	}
> -	read_unlock(&tasklist_lock);
> -}
> -
> -static void free_all_child_rdtgrp(struct rdtgroup *rdtgrp)
> -{
> -	struct rdtgroup *sentry, *stmp;
> -	struct list_head *head;
> -
> -	head = &rdtgrp->mon.crdtgrp_list;
> -	list_for_each_entry_safe(sentry, stmp, head, mon.crdtgrp_list) {
> -		rdtgroup_unassign_cntrs(sentry);
> -		free_rmid(sentry->closid, sentry->mon.rmid);
> -		list_del(&sentry->mon.crdtgrp_list);
> -
> -		if (atomic_read(&sentry->waitcount) != 0)
> -			sentry->flags = RDT_DELETED;
> -		else
> -			rdtgroup_remove(sentry);
> -	}
> -}
> -
> -/*
> - * Forcibly remove all of subdirectories under root.
> - */
> -static void rmdir_all_sub(void)
> -{
> -	struct rdtgroup *rdtgrp, *tmp;
> -
> -	/* Move all tasks to the default resource group */
> -	rdt_move_group_tasks(NULL, &rdtgroup_default, NULL);
> -
> -	list_for_each_entry_safe(rdtgrp, tmp, &rdt_all_groups, rdtgroup_list) {
> -		/* Free any child rmids */
> -		free_all_child_rdtgrp(rdtgrp);
> -
> -		/* Remove each rdtgroup other than root */
> -		if (rdtgrp == &rdtgroup_default)
> -			continue;
> -
> -		if (rdtgrp->mode == RDT_MODE_PSEUDO_LOCKSETUP ||
> -		    rdtgrp->mode == RDT_MODE_PSEUDO_LOCKED)
> -			rdtgroup_pseudo_lock_remove(rdtgrp);
> -
> -		/*
> -		 * Give any CPUs back to the default group. We cannot copy
> -		 * cpu_online_mask because a CPU might have executed the
> -		 * offline callback already, but is still marked online.
> -		 */
> -		cpumask_or(&rdtgroup_default.cpu_mask,
> -			   &rdtgroup_default.cpu_mask, &rdtgrp->cpu_mask);
> -
> -		rdtgroup_unassign_cntrs(rdtgrp);
> -
> -		free_rmid(rdtgrp->closid, rdtgrp->mon.rmid);
> -
> -		kernfs_remove(rdtgrp->kn);
> -		list_del(&rdtgrp->rdtgroup_list);
> -
> -		if (atomic_read(&rdtgrp->waitcount) != 0)
> -			rdtgrp->flags = RDT_DELETED;
> -		else
> -			rdtgroup_remove(rdtgrp);
> -	}
> -	/* Notify online CPUs to update per cpu storage and PQR_ASSOC MSR */
> -	update_closid_rmid(cpu_online_mask, &rdtgroup_default);
> -
> -	kernfs_remove(kn_info);
> -	kernfs_remove(kn_mongrp);
> -	kernfs_remove(kn_mondata);
> -}
> -
> -/**
> - * mon_get_kn_priv() - Get the mon_data priv data for this event.
> - *
> - * The same values are used across the mon_data directories of all control and
> - * monitor groups for the same event in the same domain. Keep a list of
> - * allocated structures and re-use an existing one with the same values for
> - * @rid, @domid, etc.
> - *
> - * @rid:    The resource id for the event file being created.
> - * @domid:  The domain id for the event file being created.
> - * @mevt:   The type of event file being created.
> - * @do_sum: Whether SNC summing monitors are being created. Only set
> - *	    when @rid == RDT_RESOURCE_L3.
> - *
> - * Return: Pointer to mon_data private data of the event, NULL on failure.
> - */
> -static struct mon_data *mon_get_kn_priv(enum resctrl_res_level rid, int domid,
> -					struct mon_evt *mevt,
> -					bool do_sum)
> -{
> -	struct mon_data *priv;
> -
> -	lockdep_assert_held(&rdtgroup_mutex);
> -
> -	list_for_each_entry(priv, &mon_data_kn_priv_list, list) {
> -		if (priv->rid == rid && priv->domid == domid &&
> -		    priv->sum == do_sum && priv->evt == mevt)
> -			return priv;
> -	}
> -
> -	priv = kzalloc_obj(*priv);
> -	if (!priv)
> -		return NULL;
> -
> -	priv->rid = rid;
> -	priv->domid = domid;
> -	priv->sum = do_sum;
> -	priv->evt = mevt;
> -	list_add_tail(&priv->list, &mon_data_kn_priv_list);
> -
> -	return priv;
> -}
> -
> -/**
> - * mon_put_kn_priv() - Free all allocated mon_data structures.
> - *
> - * Called when resctrl file system is unmounted.
> - */
> -static void mon_put_kn_priv(void)
> -{
> -	struct mon_data *priv, *tmp;
> -
> -	lockdep_assert_held(&rdtgroup_mutex);
> -
> -	list_for_each_entry_safe(priv, tmp, &mon_data_kn_priv_list, list) {
> -		list_del(&priv->list);
> -		kfree(priv);
> -	}
> -}
> -
> -static void resctrl_fs_teardown(void)
> -{
> -	lockdep_assert_held(&rdtgroup_mutex);
> -
> -	/* Cleared by rdtgroup_destroy_root() */
> -	if (!rdtgroup_default.kn)
> -		return;
> -
> -	rmdir_all_sub();
> -	rdtgroup_unassign_cntrs(&rdtgroup_default);
> -	mon_put_kn_priv();
> -	rdt_pseudo_lock_release();
> -	rdtgroup_default.mode = RDT_MODE_SHAREABLE;
> -	closid_exit();
> -	schemata_list_destroy();
> -	rdtgroup_destroy_root();
> -}
> -
>   static void rdt_kill_sb(struct super_block *sb)
>   {
>   	struct rdt_resource *r;

